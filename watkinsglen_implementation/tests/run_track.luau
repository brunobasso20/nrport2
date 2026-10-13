-- Watkins Glen track world tests (Luau CLI), from the repository root:
--   luau -O2 --codegen watkinsglen_implementation/tests/run_track.luau -a [scenario ...] [+detail] [+smoke]
-- Golden values come from the ORIGINAL NR2003.exe code executed in Unicorn (watkinsglen_implementation/recovery:
-- orig_world.py harness, ref_track.py scenarios, gen_fixtures_track.py):
--   fixtures/track_<name>.lua  the car on Watkins Glen from the session start: every cell the original wrote while the
--                              session started and the car was placed (enter), the 45-state vector per tick, and every
--                              cell written up to the checkpoint frames, compared with the Luau port bit for bit
local Vehicle = require("../../core/NR2003CupVehicle")

local function get(name)
	for _, dir in ipairs({"../../core/NR2003Cup/", "../core/NR2003Cup/"}) do
		local ok, m = pcall(require, dir .. name)
		if ok then return m end
	end
	return nil
end

local passed, failed = 0, 0
local function check(name, ok, detail)
	if ok then passed += 1; print("PASS  " .. name .. (detail and ("  " .. detail) or ""))
	else failed += 1; print("FAIL  " .. name .. (detail and ("  " .. detail) or "")) end
end

local ARGS = {...}
local DETAIL, SMOKE = false, false
local WANT = {}
for _, a in ipairs(ARGS) do
	if a == "+detail" then DETAIL = true elseif a == "+smoke" then SMOKE = true else WANT[a] = true end
end
for name in pairs(WANT) do assert(name == "stall0" or name == "launch" or name == "wall" or name == "grass" or name == "sand", "unknown scenario " .. name) end

local t0 = os.clock()
local car = Vehicle.fromLoader(get)
local V = car.V
check("load core + track world (NR2003CupTrack)", V.loadTrack ~= nil and V._world ~= nil,
	string.format("%.2f s, memory %d bytes", os.clock() - t0, buffer.len(V.memory())))
local M, BASE = V.memory(), V.base

local B64 = {}
do
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	for i = 1, 64 do B64[string.byte(chars, i)] = i - 1 end
end
local function b64(s)
	local out = buffer.create(#s * 3 // 4)
	local o = 0
	for i = 1, #s, 4 do
		local a, b, c, d = string.byte(s, i, i + 3)
		local x = B64[a] * 262144 + B64[b] * 4096 + (c ~= 61 and B64[c] or 0) * 64 + (d ~= 61 and B64[d] or 0)
		buffer.writeu8(out, o, bit32.rshift(x, 16)); o += 1
		if c ~= 61 then buffer.writeu8(out, o, bit32.band(bit32.rshift(x, 8), 0xff)); o += 1 end
		if d ~= 61 then buffer.writeu8(out, o, bit32.band(x, 0xff)); o += 1 end
	end
	return out, o
end
local S = buffer.create(8)
local function fb(u) buffer.writeu32(S, 0, u); return buffer.readf32(S, 0) end
local function bits(x) buffer.writef32(S, 0, x); return buffer.readu32(S, 0) end

-- cells {n, addr, val}: count of differences, first differences
local function compareCells(c)
	local A = b64(c.addr)
	local Vv = b64(c.val)
	local bad, first = 0, {}
	for k = 0, c.n - 1 do
		local a = buffer.readu32(A, 4 * k)
		local want = buffer.readu32(Vv, 4 * k)
		local got = buffer.readu32(M, a - BASE)
		if got ~= want then
			bad += 1
			if #first < 12 then table.insert(first, string.format("%08x got %08x want %08x (%g / %g)", a, got, want, fb(got), fb(want))) end
		end
	end
	return bad, first
end

local loadT = os.clock()
check("V.loadTrack(): track image into the reset image", V.loadTrack() and V.trackLoaded(),
	string.format("%d bytes, %.2f s", V.trackImageBytes or 0, os.clock() - loadT))
local info = V.trackInfo()
check("track sections / length (ORIGINAL 00510b70 build)", info.sections == 123 and math.abs(info.length - 3942.876) < 0.01,
	string.format("%d sections, %.3f m, %d pit stalls", info.sections, info.length, info.stalls))

-- Direct ORIGINAL material/contact/roughness tables are checked separately from integration precision.
local surfaceOK, surfaceFixture = pcall(require, "./fixtures/surface_tables")
check("ORIGINAL surface table fixture is present",surfaceOK)
if surfaceOK then
	for _,t in ipairs(surfaceFixture) do
		local differences=0
		for i,want in ipairs(t.bits) do if V.r32(t.address+(i-1)*4)~=want then differences+=1 end end
		check("ORIGINAL " .. t.name .. " table (bit-exact)",differences==0,string.format("%d entries; %d differences",#t.bits,differences))
	end
end

local DEV = {capable = true, acquire = true}
local function session(fx)
	V.endSession()
	V.clearSteeringOptions(); V.clearForceFeedbackOptions()
	V.setForceFeedbackDevice({capable = false})
	V.applySetup(V.Setup.cupGarageDefault())
	V.reset()
	V.setForceFeedbackDevice(DEV)
	V.setForceFeedbackOptions({enabled = true})
	V.setTrackStart(fx.stall[1], fx.stall[2], fx.stall[3])
	V.startSession({temperature = 70, wind_mph = 0, wind_dir = 0, conditions = 0, night = 0}, {damageLevel = 0, series = 1})
end

local stateBuf = table.create(45, 0)
if not SMOKE then
for _, name in ipairs({"stall0", "launch", "wall", "grass", "sand"}) do
	if next(WANT) and not WANT[name] then continue end
	local ok, fx = pcall(require, "./fixtures/track_" .. name)
	if not ok then
		check(name .. ": ORIGINAL reference fixture is present", false,
			"missing fixtures/track_" .. name .. ".lua; generate with ref_track.py and gen_fixtures_track.py, or run -a +smoke")
		continue
	end
	local ts = os.clock()
	session(fx)
	check(name .. ": world active after the session start (ORIGINAL 005512f0 placement, 00563620)", V.worldActive())
	local bad, first = compareCells(fx.enter)
	check(name .. ": cells after the session start + placement (bit-exact)", bad == 0,
		string.format("%d cells, %d differ%s", fx.enter.n, bad, bad > 0 and ("  e.g. " .. table.concat(first, "; ", 1, math.min(#first, DETAIL and 12 or 4))) or ""))
	local states = b64(fx.states)
	local want = {}
	for i, k in ipairs(fx.ticks) do want[k] = i - 1 end
	local tick, worstTick, worstField, badStates, maxDiff, firstBad = 0, nil, nil, 0, 0, nil
	local maxPosition, maxVelocity, maxAttitude = 0, 0, 0
	local cellsAt = {}
	local wheelBits, materialMismatch, maxForce, maxRolling, maxContactSpeed = 0, 0, 0, 0, 0
	for f = 1, fx.frames do
		local c = fx.controls[f]
		for t = 1, 8 do
			V.drive(c)
			local idx = want[tick]
			if idx then
				V.state(stateBuf)
				for j = 0, 44 do
					local w = buffer.readu32(states, 4 * (45 * idx + j))
					local g = bits(stateBuf[j + 1])
					if g ~= w then
						badStates += 1
						local d = math.abs(fb(g) - fb(w))
						if d > maxDiff then maxDiff = d; worstTick = tick; worstField = j end
						if j==0 or j==2 or j==4 then maxPosition=math.max(maxPosition,d)
						elseif j==1 or j==3 or j==5 then maxVelocity=math.max(maxVelocity,d)
						elseif j>=6 and j<=9 then maxAttitude=math.max(maxAttitude,d) end
						if not firstBad then firstBad = string.format("tick %d state[%d] got %g want %g", tick, j, fb(g), fb(w)) end
					end
				end
			end
			tick += 1
		end
		local chk = fx.checks[f]
		if chk then
			local wheelExpected = fx.wheelChecks and fx.wheelChecks[f]
			if wheelExpected then
				for w=0,3 do
					local c=V.wheelBrake(w)
					local got={V.r32(0xbf3a20+w*0xa39+0x2c0),bits(c.fx),bits(c.fy),bits(c.fz),bits(c.vx),bits(c.vslip),bits(c.tread),bits(c.rollingTorque)}
					local expected=wheelExpected[w+1]
					if got[1]~=expected[1] then materialMismatch+=1 end
					for k=2,8 do
						if got[k]~=expected[k] then wheelBits+=1 end
						local d=math.abs(fb(got[k])-fb(expected[k]))
						if k<=4 then maxForce=math.max(maxForce,d) elseif k==8 then maxRolling=math.max(maxRolling,d)
						else maxContactSpeed=math.max(maxContactSpeed,d) end
					end
				end
			end
			local b, fi = compareCells(chk)
			cellsAt[f] = {b, chk.n, fi}
		end
	end
	check(name .. string.format(": 45-state vector, %d ticks compared (bit-exact)", #fx.ticks), badStates == 0,
		badStates > 0 and string.format("%d values differ, max |d| %g at tick %s state[%s]; first: %s", badStates, maxDiff, tostring(worstTick), tostring(worstField), firstBad) or nil)
	print(string.format("      maximum chassis position difference %.9g m; velocity %.9g m/s; quaternion %.9g",maxPosition,maxVelocity,maxAttitude))
	check(name .. ": ORIGINAL per-wheel surface IDs at checkpoints",materialMismatch==0,string.format("%d mismatches",materialMismatch))
	check(name .. ": ORIGINAL wheel forces / contact speeds / rolling torque (bit-exact)",wheelBits==0,
		string.format("%d fields differ; force %.9g N; rolling torque %.9g Nm; contact speed %.9g m/s maximum differences",wheelBits,maxForce,maxRolling,maxContactSpeed))
	for f, r in pairs(cellsAt) do
		check(name .. string.format(": cells written up to frame %d (bit-exact)", f), r[1] == 0,
			string.format("%d cells, %d differ%s", r[2], r[1], r[1] > 0 and ("  e.g. " .. table.concat(r[3], "; ", 1, math.min(#r[3], DETAIL and 12 or 4))) or ""))
	end
	local pos = V.state(stateBuf)
	print(string.format("      %s: %.1f s, final position %.3f %.3f %.3f", name, os.clock() - ts, pos[1], pos[3], pos[5]))
end

end

if SMOKE then
	print("SMOKE ONLY: original trajectory fixtures are not compared by this mode")
	local function finite(x) return x == x and math.abs(x) < math.huge end
	local roundtrip = true
	for _, p in ipairs({{341.13,-19.61}, {147.32,-19.62}, {255,-0.21}, {800,-10}, {1700,30}, {2200,-20}}) do
		local w = V.trackToWorld(p[1],p[2])
		local r = V.trackPointRaw(w.x,w.y,w.z)
		local dl,lat = fb(r[16]),fb(r[17])
		if math.abs(dl-p[1]) > 0.002 or math.abs(lat-p[2]) > 0.002 or bit32.band(r[22],0x8000) == 0 then roundtrip = false end
	end
	check("track to world / world to track roundtrip (metres)",roundtrip)
	-- The ORIGINAL 00513eaa quantises off-road heights on a 5 samples/metre, 16x16 repeating table.
	local noiseOK, noiseSamples = true, 0
	for dlong=100,3500,100 do
		for _,dlat in ipairs({-30,-20,-10,10,20,30}) do
			local w=V.trackToWorld(dlong+0.13,dlat+0.07)
			if w.surface >= 5 and w.surface <= 8 then
				local index=bit32.band(math.floor((dlong+0.13)*5),15)*16+bit32.band(math.floor((dlat+0.07)*5),15)
				local h=buffer.readf32(M,0x6f41d8-BASE+index*4)*buffer.readf32(M,0x74c36c-BASE)
				local expected=w.z+h
				if math.abs(w.bumpedZ-expected)>0.00002 then noiseOK=false end
				noiseSamples+=1
			end
		end
	end
	check("off-road heights follow ORIGINAL 00513eaa roughness table",noiseOK and noiseSamples>0,string.format("%d grass/dirt/sand/gravel samples",noiseSamples))
	for _,sc in ipairs({{name="stall0",stall={341.13,-19.61,0},frames=36}, {name="launch",stall={255,-0.21,0},frames=72}, {name="wall",stall={341.13,-19.61,0},frames=144}, {name="grass",stall={250,20,0},frames=36}, {name="sand",stall={450,32,0},frames=36}}) do
		if next(WANT) and not WANT[sc.name] then continue end
		session(sc)
		local placed=V.trackPosition()
		check(sc.name .. ": placement uses ORIGINAL track coordinates",V.worldActive() and placed.valid and math.abs(placed.dlong-sc.stall[1])<0.003 and math.abs(placed.dlat-sc.stall[2])<0.003)
		local ts = os.clock()
		local badState,contacted,materials=0,false,{}
		for f=1,sc.frames do
			local c={throttle=(sc.name=="launch" or sc.name=="wall") and 0.6 or 0,clutch=1,brakeControl=0,brakeDigital=true,shiftUp=f==19,steerAxis=(sc.name=="wall" and f>29 and f<108) and 0.35 or 0}
			for t=1,8 do
				V.drive(c);V.state(stateBuf)
				for _,x in ipairs(stateBuf) do if not finite(x) then badState+=1 end end
				for i=0,3 do local ct=V.trackContact(i);if ct.grounded then contacted=true;materials[ct.surface]=true end end
			end
		end
		check(sc.name .. ": original broadphase and both contact passes complete with finite states",badState==0,
			string.format("%d ticks; %.3f elapsed s/sim s",sc.frames*8,(os.clock()-ts)/(sc.frames/36)))
		check(sc.name .. ": original tire callbacks produce positive ground loads",contacted)
		if sc.name=="grass" or sc.name=="sand" then
			local expected=sc.name=="grass" and 5 or 7
			check(sc.name .. ": original tyre callbacks encounter the authored surface id",materials[expected]==true)
		end
		if sc.name=="stall0" then
			local normalLoad=0
			for i=0,3 do normalLoad+=V.trackContact(i).load end
			check("stationary pit spawn supports vehicle weight after settling",normalLoad>8000 and normalLoad<22000,string.format("%.1f N",normalLoad))
		end
		V.reset()
		check(sc.name .. ": active-session reset places the car and restarts the world",V.worldActive() and math.abs(V.trackPosition().dlong-sc.stall[1])<0.003)
		V.endSession();check(sc.name .. ": ending session stops the world",not V.worldActive())
	end
end
print(string.format("\n%d passed, %d failed", passed, failed))
assert(failed == 0, string.format("track tests: %d failed", failed))
