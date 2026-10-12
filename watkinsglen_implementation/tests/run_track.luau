-- Watkins Glen track world tests (Luau CLI), from the repository root:
--   luau -O2 --codegen watkinsglen_implementation/tests/run_track.luau [scenario ...] [+detail]
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
local DETAIL = false
local WANT = {}
for _, a in ipairs(ARGS) do if a == "+detail" then DETAIL = true else WANT[a] = true end end

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
for _, name in ipairs({"stall0", "launch", "wall"}) do
	if next(WANT) and not WANT[name] then continue end
	local ok, fx = pcall(require, "./fixtures/track_" .. name)
	if not ok then print("SKIP  " .. name .. " (fixture missing)"); continue end
	local ts = os.clock()
	session(fx)
	check(name .. ": world active after the session start (ORIGINAL 005512f0 placement, 00563620)", V.worldActive())
	local bad, first = compareCells(fx.enter)
	check(name .. ": cells after the session start + placement (bit-exact)", bad == 0,
		string.format("%d cells, %d differ%s", fx.enter.n, bad, bad > 0 and ("  e.g. " .. table.concat(first, "; ", 1, math.min(#first, DETAIL and 12 or 4))) or ""))
	local states = b64(fx.states)
	local want = {}
	for i, k in ipairs(fx.ticks) do want[k] = i - 1 end
	local tick, worstTick, badStates, maxDiff, firstBad = 0, nil, 0, 0, nil
	local cellsAt = {}
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
						if d > maxDiff then maxDiff = d; worstTick = tick end
						if not firstBad then firstBad = string.format("tick %d state[%d] got %g want %g", tick, j, fb(g), fb(w)) end
					end
				end
			end
			tick += 1
		end
		local chk = fx.checks[f]
		if chk then
			local b, fi = compareCells(chk)
			cellsAt[f] = {b, chk.n, fi}
		end
	end
	check(name .. string.format(": 45-state vector, %d ticks compared (bit-exact)", #fx.ticks), badStates == 0,
		badStates > 0 and string.format("%d values differ, max |d| %g at tick %s; first: %s", badStates, maxDiff, tostring(worstTick), firstBad) or nil)
	for f, r in pairs(cellsAt) do
		check(name .. string.format(": cells written up to frame %d (bit-exact)", f), r[1] == 0,
			string.format("%d cells, %d differ%s", r[2], r[1], r[1] > 0 and ("  e.g. " .. table.concat(r[3], "; ", 1, math.min(#r[3], DETAIL and 12 or 4))) or ""))
	end
	local pos = V.state(stateBuf)
	print(string.format("      %s: %.1f s, final position %.3f %.3f %.3f", name, os.clock() - ts, pos[1], pos[3], pos[5]))
end

print(string.format("\n%d passed, %d failed", passed, failed))
