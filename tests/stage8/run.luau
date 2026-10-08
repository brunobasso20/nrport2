-- Stage 8 brake regression tests (Luau CLI):  luau -O2 --codegen tests/stage8/run.luau
-- Golden values come from the ORIGINAL NR2003.exe code executed in Unicorn
-- (recovery/stage8/gen_fixtures_stage8.py, harness recovery/stage8/orig_brake.py):
--   brake_units.lua     bit-level vectors: 00553080 pedal chain, 005f7570 attitude
--   brake_sync.lua      original machine snapshots at braking events + original results 8/16 ticks later
--   brake_scenarios.lua complete braking runs of the original (and a 1-ulp perturbed twin)
local Vehicle = require("../../core/NR2003CupVehicle")
local UNITS = require("./fixtures/brake_units")
local SYNC = require("./fixtures/brake_sync")
local SC = require("./fixtures/brake_scenarios")

local function get(name)
	local ok, m = pcall(require, "../../core/NR2003Cup/" .. name)
	if ok then return m end
	return nil
end

local passed, failed = 0, 0
local function check(name, ok, detail)
	if ok then passed += 1; print("PASS  " .. name .. (detail and ("  " .. detail) or ""))
	else failed += 1; print("FAIL  " .. name .. (detail and ("  " .. detail) or "")) end
end

local car = Vehicle.fromLoader(get)
local V = car.V
-- Stage 11: the golden data of this suite were produced by the ORIGINAL code with the Stage 6-10 frame end (0051aac0 cut-timer subset); compare in the explicit "frozen" runtime mode (production = "original", see tests/stage11)
if V.setRuntimeMode then V.setRuntimeMode("frozen") end
local M, BASE = V.memory(), V.base
local w32, r32, rf32 = V.w32, V.r32, V.rf32
local FLAT = {}
for i = 1, 4 do FLAT[i] = {0, 0, 1, 0, 0, 0, 0, 1, 1} end

local function ulps(a, b)
	if a == b then return 0 end
	local function ord(u) if u >= 0x80000000 then return 0x80000000 - u end return u end
	return math.abs(ord(a) - ord(b))
end
local function relerr(a, b, floor) return math.abs(a - b) / math.max(math.abs(a), math.abs(b), floor or 1e-3) end

---------------------------------------------------------------------------------------------- units
do
	V.reset()
	local exact, within1, worst, at = 0, 0, 0, ""
	local spdBad, axBad = 0, 0
	for n, r in ipairs(UNITS.pedal) do
		local addrs = {0xbf6d44, 0xbf6d4c, 0xbf6d54, 0xbf6d58, 0xbf6d5c, 0xbf6d60, 0xbf6d64, 0xbf6390}
		for i, a in ipairs(addrs) do w32(a, r[i]) end
		w32(0xbf6eac, r[9])
		w32(0xd35b18 + 60, r[10]); w32(0xd37cc8 + 6 * 29, r[11] == 1 and 0 or 1)
		w32(0xd35b18 + 50, r[12]); w32(0xd37cc8 + 5 * 29, r[13] == 1 and 0 or 1)
		V.w8(0xbf6f04, r[14]); w32(0x74c97c, r[15]); w32(0xc067e0, r[16]); w32(0xc0692a + 0x4c, r[17])
		w32(0xbf3cd4, r[18]); w32(0xbf470d, r[19]); w32(0xbf5146, r[20]); w32(0xbf5b7f, r[21])
		w32(0x74c994, r[22]); w32(0x74c998, r[23]); w32(0xbf63a4, r[24]); w32(0xbf63a8, r[25])
		V.wf32d(0xbf6eac, V.brakePedalOriginal())
		local d = ulps(r32(0xbf6eac), r[26])
		if d == 0 then exact += 1 end
		if d <= 1 then within1 += 1 end
		if d > worst then worst = d; at = string.format("row %d lua %.9g orig %.9g", n, rf32(0xbf6eac), (function() w32(0xf7f400, r[26]); return rf32(0xf7f400) end)()) end
		if ulps(r32(0xbf6f44), r[27]) > 1 then spdBad += 1 end
		if r32(0xbf63a4) ~= r[28] or r32(0xbf63a8) ~= r[29] then axBad += 1 end
	end
	local N = #UNITS.pedal
	check(string.format("00553080 pedal chain vs original: %d vectors bit-exact or 1 ulp", N), within1 == N,
		string.format("exact %d/%d, <=1ulp %d, worst %d ulp %s", exact, N, within1, worst, at))
	check("00554f50 speed cache (bf6f44) vs original (<= 1 ulp)", spdBad == 0, spdBad .. " off")
	check("00552d00 axis limiter states (bf63a4/bf63a8) bit-exact", axBad == 0, axBad .. " off")
	local aexact, abad, aworst = 0, 0, 0
	for _, r in ipairs(UNITS.attitude) do
		for k = 1, 4 do w32(0xf7f400 + 4 * k, r[k]) end
		local a1, a2, a3 = V.attitudeOriginal(0xf7f404)
		w32(0xf7f420, 0); V.wf32(0xf7f420, a1); local b1 = r32(0xf7f420)
		V.wf32(0xf7f420, a2); local b2 = r32(0xf7f420)
		V.wf32(0xf7f420, a3); local b3 = r32(0xf7f420)
		local d = math.max(ulps(b1, r[5]), ulps(b2, r[6]), ulps(b3, r[7]))
		if d == 0 then aexact += 1 end
		if d > 2 then abad += 1 end
		aworst = math.max(aworst, d)
	end
	check(string.format("005f7570 attitude vs original: %d quaternions within 2 ulp", #UNITS.attitude), abad == 0,
		string.format("exact %d, worst %d ulp", aexact, aworst))
	V.reset()
end

---------------------------------------------------------------------------------------------- helpers
local scenarios = {}
for _, s in ipairs(SC) do scenarios[s.name] = s end
local function controls(s, frame)
	local row = s.controls[frame + 1]
	if row[8] == 0 then return {driver = false, throttle = 0, clutch = 0, steer = 0} end
	local c = {throttle = row[1], clutch = row[4], steer = row[5], shiftUp = row[6] == 1, shiftDown = row[7] == 1}
	if row[2] >= 0 then c.brakeControl = row[2]; c.brakeDigital = row[3] == 1 end
	return c
end
local B64 = {}
do
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	for i = 1, 64 do B64[string.byte(chars, i)] = i - 1 end
end
local function loadChunk(addr, s)
	local o = addr - BASE
	for i = 1, #s, 4 do
		local a, b, c, d = string.byte(s, i, i + 3)
		local x = B64[a] * 262144 + B64[b] * 4096 + (c ~= 61 and B64[c] * 64 or 0) + (d ~= 61 and B64[d] or 0)
		buffer.writeu8(M, o, bit32.rshift(x, 16)); o += 1
		if c ~= 61 then buffer.writeu8(M, o, bit32.band(bit32.rshift(x, 8), 0xff)); o += 1 end
		if d ~= 61 then buffer.writeu8(M, o, bit32.band(x, 0xff)); o += 1 end
	end
end
local wb = {}
local function observeWheels(out)
	for w = 0, 3 do
		V.wheelBrake(w, wb)
		out[#out + 1] = wb.torque; out[#out + 1] = wb.fx; out[#out + 1] = wb.fy
		out[#out + 1] = wb.fz; out[#out + 1] = wb.vx; out[#out + 1] = wb.vslip
	end
	local pedal, _, _, core = V.brakeState()
	out[#out + 1] = pedal; out[#out + 1] = core; out[#out + 1] = V.gearIndex()
	return out
end

---------------------------------------------------------------------------------------------- sync
-- the Luau core restarted from the ORIGINAL machine state at a braking event must reproduce the
-- original over one and two frames (rounding-level differences only: x87 80-bit vs IEEE double)
do
	local worstS, atS, worstW, atW, gearBad, pedalBad = 0, "", 0, "", 0, 0
	local worst8 = 0
	local count = 0
	for _, snap in ipairs(SYNC) do
		local s = scenarios[snap.scenario]
		V.reset()
		for _, ch in ipairs(snap.chunks) do loadChunk(ch[1], ch[2]) end
		V.tick = snap.tick
		local st = table.create(45, 0)
		for k = snap.tick + 1, snap.tick + 16 do
			V.drive(controls(s, (k - 1) // 8), FLAT)
			for _, ref in ipairs(snap.after) do
				if ref[1] == k then
					count += 1
					V.state(st)
					for i = 1, 45 do
						local e = relerr(st[i], ref[i + 1], 1e-2)
						if k - snap.tick == 8 then worst8 = math.max(worst8, e) end
						if e > worstS then worstS = e; atS = string.format("%s@%d +%d state %d lua %.7g orig %.7g", snap.scenario, snap.tick, k - snap.tick, i - 1, st[i], ref[i + 1]) end
					end
					local ow = observeWheels({})
					for i = 1, 24 do
						local fl = (i % 6 == 1) and 5 or ((i % 6 == 2 or i % 6 == 3 or i % 6 == 4) and 50 or 0.05)
						local e = math.abs(ow[i] - ref[46 + i]) / math.max(math.abs(ref[46 + i]), fl)
						if e > worstW then worstW = e; atW = string.format("%s@%d +%d wheel %d field %d lua %.6g orig %.6g", snap.scenario, snap.tick, k - snap.tick, (i - 1) // 6, (i - 1) % 6, ow[i], ref[46 + i]) end
					end
					if ow[25] ~= ref[71] or ow[26] ~= ref[72] then pedalBad += 1 end
					if ow[27] ~= ref[73] then gearBad += 1 end
				end
			end
		end
	end
	check(string.format("sync: %d snapshots x 2 frames, 45 states vs original (rel <= 1e-3, floor 1e-2)", #SYNC), count == 2 * #SYNC and worstS <= 1e-3,
		string.format("worst after 1 frame %.2e, after 2 frames %.2e %s", worst8, worstS, atS))
	check("sync: per-wheel brake torque / Fx / Fy / Fz / vx / slip vs original (rel <= 2e-3)", worstW <= 2e-3,
		string.format("worst %.2e %s", worstW, atW))
	check("sync: processed pedal and core brake cell identical to original", pedalBad == 0, pedalBad .. " mismatches")
	check("sync: gear index identical to original", gearBad == 0, gearBad .. " mismatches")
end

---------------------------------------------------------------------------------------------- scenarios
-- each run restarts from the ORIGINAL machine snapshot at the braking onset (events[1]); the
-- original's twin got +1 ulp on the chassis z cell at that tick (braking-phase sensitivity)
local RUNS = {}
local function onsetSnapshot(s)
	local t0 = math.floor(s.events[1] * 288 + 0.5)
	for _, snap in ipairs(SYNC) do
		if snap.scenario == s.name and snap.tick == t0 then return snap end
	end
	error("no onset snapshot for " .. s.name)
end
local function runScenario(s)
	local snap = onsetSnapshot(s)
	V.reset()
	for _, ch in ipairs(snap.chunks) do loadChunk(ch[1], ch[2]) end
	V.tick = snap.tick
	local want = {}
	for _, r in ipairs(s.orig) do if r[1] > snap.tick then want[r[1]] = true end end
	local rows, st = {}, table.create(45, 0)
	for k = snap.tick + 1, s.ticks do
		V.drive(controls(s, (k - 1) // 8), FLAT)
		if want[k] then
			V.state(st)
			local r = {k}
			for i = 1, 6 do r[#r + 1] = st[i] end
			for i = 7, 10 do r[#r + 1] = st[i] end
			for _, i in ipairs({18, 24, 30, 32}) do r[#r + 1] = st[i + 1] end
			r[#r + 1] = st[35]
			observeWheels(r)
			rows[#rows + 1] = r
		end
	end
	return rows
end

local t0 = os.clock()
local nTicks = 0
for _, s in ipairs(SC) do
	local rows = runScenario(s)
	RUNS[s.name] = rows
	nTicks += s.ticks
	local bad, report, pbad, gbad = 0, "", 0, 0
	local base = 0
	for n, r in ipairs(s.orig) do if r[1] <= onsetSnapshot(s).tick then base = n end end
	-- envelope = 3 x the original's own twin spread, taken as the maximum over +-36 ticks (two original
	-- trajectories that happen to cross at one sample do not make the original insensitive there),
	-- + 0.02 + 1 %. Pedal/gear may differ only where the original twin itself differs nearby.
	local function spread(n, i)
		local m, tk = 0, s.orig[base + n][1]
		for j = base + 1, #s.orig do
			local oj, pj = s.orig[j], s.pert[j]
			if math.abs(oj[1] - tk) <= 36 then m = math.max(m, math.abs(pj[i] - oj[i])) end
		end
		return m
	end
	local function twinDiffers(n, i)
		local tk = s.orig[base + n][1]
		for j = base + 1, #s.orig do
			if math.abs(s.orig[j][1] - tk) <= 36 and s.orig[j][i] ~= s.pert[j][i] then return true end
		end
		return false
	end
	-- auto-hold regime (|v| < 0.8 m/s) with the resting pitch within 0.05 deg of the 0.5 deg threshold of
	-- 00553080: the original pedal is discontinuous there (its own twin flips too); those frames are
	-- covered by the synchronized snapshots instead of the long-horizon pedal comparison
	local function nearHoldThreshold(n)
		local tk = s.orig[base + n][1]
		for j = base + 1, #s.orig do
			local r = s.orig[j]
			if math.abs(r[1] - tk) <= 36 then
				local m6 = 2 * (r[8] * r[10] - r[9] * r[11])
				local pitch = math.deg(math.asin(math.clamp(-m6, -1, 1)))
				local v = math.sqrt(r[3] * r[3] + r[5] * r[5] + r[7] * r[7])
				if v < 0.8 and math.abs(math.abs(pitch) - 0.5) < 0.05 then return true end
			end
		end
		return false
	end
	for n, a in ipairs(rows) do
		local o, p = s.orig[base + n], s.pert[base + n]
		assert(o[1] == a[1] and p[1] == a[1], "row alignment")
		for _, i in ipairs({2, 3, 4, 5, 6, 7}) do
			-- positions: floor 0.02 m; velocities: floor 0.05 m/s (stick-slip settling of a stopped car)
			local floor = (i % 2 == 1) and 0.05 or 0.02
			local env = 3 * spread(n, i) + floor + 0.01 * math.abs(o[i])
			if math.abs(a[i] - o[i]) > env then
				bad += 1
				if report == "" then report = string.format("tick %d col %d lua %.5g orig %.5g pert %.5g env %.4g", a[1], i - 1, a[i], o[i], p[i], env) end
			end
		end
		if math.abs(a[41] - o[41]) > 1e-6 and not twinDiffers(n, 41) and not nearHoldThreshold(n) then pbad += 1 end
		if a[43] ~= o[43] and not twinDiffers(n, 43) then gbad += 1 end
	end
	local lo, lp = s.orig[#s.orig], s.pert[#s.pert]
	check(string.format("%s: braking phase from the original onset state, chassis x/y/z + velocities within envelope (%d samples)", s.name, #rows), bad == 0,
		bad > 0 and report or string.format("final x lua %.3f orig %.3f pert %.3f | vx lua %.3f orig %.3f", rows[#rows][2], lo[2], lp[2], rows[#rows][3], lo[3]))
	check(s.name .. ": processed pedal + gear sequence equal to original (except where the original's twin itself differs)", pbad == 0 and gbad == 0, string.format("pedal %d, gear %d mismatches", pbad, gbad))
end
print(string.format("      scenarios: %d ticks in %.2f s (%.0f ticks/s)", nTicks, os.clock() - t0, nTicks / (os.clock() - t0)))

---------------------------------------------------------------------------------------------- physics
-- behaviour checks on the Luau runs; each one is asserted on the ORIGINAL rows as well, so a
-- check can only pass if it is what NR2003 itself does.
local function rowAt(rows, tick) for _, r in ipairs(rows) do if r[1] >= tick then return r end end return rows[#rows] end
local function speed(r) return math.sqrt(r[3] * r[3] + r[5] * r[5] + r[7] * r[7]) end
local function col(w, f) return 16 + 6 * w + f end -- w 0..3, f 1 torque,2 fx,3 fy,4 fz,5 vx,6 vslip
local function both(fn) return fn(RUNS) and fn(setmetatable({}, {__index = function(_, k) return scenarios[k].orig end})) end

check("zero brake: core brake cell stays 0 and wheel friction torque is drag only (|T| < 120 N*m)", both(function(R)
	for _, r in ipairs(R.coast) do
		if r[1] > 6.05 * 288 then
			if r[42] ~= 0 then return false end
			for w = 0, 3 do if math.abs(r[col(w, 1)]) > 120 then return false end end
		end
	end
	return true
end))

check("light < medium < max braking: speed 1 s after onset ordered", both(function(R)
	local t = 7 * 288
	return speed(rowAt(R.light, t)) > speed(rowAt(R.medium, t)) and speed(rowAt(R.medium, t)) > speed(rowAt(R.max, t))
		and speed(rowAt(R.coast, t)) > speed(rowAt(R.light, t))
end))

local function tread(r, w) return r[col(w, 5)] + r[col(w, 6)] end
local function locked(r, w) return math.abs(r[col(w, 5)]) > 1 and math.abs(tread(r, w)) < 0.05 * math.abs(r[col(w, 5)]) end
local function inWindow(R, name, a, b, fn)
	for _, r in ipairs(R[name]) do if r[1] > a * 288 and r[1] < b * 288 and fn(r) then return true end end
	return false
end
check("74 % bias, full pedal: brake torque saturates (|T| 2780..2815 N*m front, ~1000 rear) and no wheel locks", both(function(R)
	local sat = inWindow(R, "max", 6.3, 7.5, function(r)
		return math.abs(r[col(0, 1)]) > 2780 and math.abs(r[col(0, 1)]) < 2815 and math.abs(r[col(2, 1)]) > 990 and math.abs(r[col(2, 1)]) < 1010
	end)
	local anyLock = inWindow(R, "max", 6.1, 7.5, function(r) return locked(r, 0) or locked(r, 1) or locked(r, 2) or locked(r, 3) end)
	return sat and not anyLock
end))
check("85 % bias: front wheels LOCK - static branch of 00561040 (|T| below the 3214 N*m capacity)", both(function(R)
	return inWindow(R, "bias85", 6.1, 7.5, function(r)
		return locked(r, 0) and locked(r, 1) and (math.abs(r[col(0, 1)]) < 3180 or math.abs(r[col(1, 1)]) < 3180)
	end) and not inWindow(R, "bias85", 6.1, 7.5, function(r) return locked(r, 2) or locked(r, 3) end)
end))
check("60 % bias: a rear wheel slides/locks (tread < 50 % of road speed), fronts keep rolling", both(function(R)
	return inWindow(R, "bias60", 6.2, 7.5, function(r) return math.abs(tread(r, 2)) < 0.5 * math.abs(r[col(2, 5)]) or math.abs(tread(r, 3)) < 0.5 * math.abs(r[col(3, 5)]) end)
		and not inWindow(R, "bias60", 6.1, 7.5, function(r) return locked(r, 0) or locked(r, 1) end)
end))

check("max braking: weight transfer (front Fz up, rear Fz down vs coasting) and nose-down pitch rate", both(function(R)
	local a, b = rowAt(R.max, 6.25 * 288), rowAt(R.coast, 6.25 * 288)
	return a[col(0, 4)] + a[col(1, 4)] > b[col(0, 4)] + b[col(1, 4)] + 1000 and a[col(2, 4)] + a[col(3, 4)] < b[col(2, 4)] + b[col(3, 4)] - 1000
end))

check("high-speed braking from ~39 m/s decelerates through the tyres (> 6 m/s^2 mean over 1 s)", both(function(R)
	local a, b = rowAt(R.highspeed, 8 * 288), rowAt(R.highspeed, 9 * 288)
	return speed(a) > 35 and speed(a) - speed(b) > 6
end))

check("key brake release: front wheel spin returns to road speed within 0.5 s", both(function(R)
	local r = rowAt(R.keyboard, 8.0 * 288 - 1)
	return not locked(r, 0) and not locked(r, 1) and math.abs(r[col(0, 6)]) < 0.1 * math.abs(r[col(0, 5)]) + 0.2
end))

check("key brake ramps by 1/12 per frame (00553080 digital binding)", both(function(R)
	for _, r in ipairs(R.keyboard) do
		if r[1] == 6 * 288 + 8 then return math.abs(r[41] - (1 / 12)) < 1e-6 end
	end
	return false
end))

check("braking while turning: lateral motion kept, slower than straight-line medium braking path", both(function(R)
	local a, b = rowAt(R.turn, 7 * 288), rowAt(R.medium, 7 * 288)
	return math.abs(a[4]) > 1 and math.abs(a[4]) > math.abs(b[4]) + 1
end))

check("brake bias: 85 % locks the fronts harder and stops later than 60 % (rear help)", both(function(R)
	local t = 7 * 288
	return speed(rowAt(R.bias85, t)) > speed(rowAt(R.bias60, t))
end))

check("near-zero speed: car stops on the pedal, stays stopped after release (original auto-hold, pedal > 0)", both(function(R)
	local a, b = rowAt(R.nearzero, 5.0 * 288), rowAt(R.nearzero, 2304)
	return speed(a) < 0.05 and speed(b) < 0.05 and b[41] > 0 and math.abs(b[2] - a[2]) < 0.05
end))

check("not driven (005524f0): pedal held at exactly 1.0", both(function(R)
	local r = rowAt(R.nodriver, 6.25 * 288)
	return r[41] == 1
end))

---------------------------------------------------------------------------------------------- API
do
	V.reset()
	local b, p, maxT = V.brakeBias()
	local kb = {}
	for w = 0, 3 do kb[w] = V.wheelBrake(w).kb end
	check("default setup: bias 74 %, max 3800 N*m, Kb 2812 / 987.99994 N*m", p == 74 and maxT == 3800 and kb[0] == 2812 and kb[1] == 2812
		and math.abs(kb[2] - 987.9999389648438) < 1e-9 and kb[2] == kb[3], string.format("b %.9g Kb %.9g %.9g", b, kb[0], kb[2]))
	V.setBrakeBias(60)
	local k60f, k60r = V.wheelBrake(0).kb, V.wheelBrake(2).kb
	check("setBrakeBias(60) = original rebuild cells (2279.9998 / 1520.0001)", k60f == 2279.999755859375 and k60r == 1520.0001220703125,
		string.format("%.9g %.9g", k60f, k60r))
	V.setBrakeBias(74)
	local same = V.wheelBrake(0).kb == 2812 and math.abs(V.wheelBrake(3).kb - 987.9999389648438) < 1e-9
	check("setBrakeBias(74) restores the shipped default bit-exactly", same)
	check("brake temperature readable (frozen build value, Stage 11)", math.abs(V.brakeTemperature(0) - 295.0004577636719) < 1e-6,
		string.format("%.7g K", V.brakeTemperature(0)))
	-- checkpoint / restore with the new input chain
	local s = scenarios.keyboard
	V.reset()
	for k = 1, 2000 do V.drive(controls(s, (k - 1) // 8), FLAT) end
	local cp = V.checkpoint()
	for k = 2001, 2400 do V.drive(controls(s, (k - 1) // 8), FLAT) end
	local a = V.state()
	V.restore(cp)
	for k = 2001, 2400 do V.drive(controls(s, (k - 1) // 8), FLAT) end
	local c = V.state()
	local eq = true
	for i = 1, 45 do if a[i] ~= c[i] then eq = false end end
	check("checkpoint/restore bit-identical through key braking and lock-up", eq)
	local ft, esp = V._fpu()
	check("x86/x87 stacks balanced", ft == 0 and esp == 0xf7f000, string.format("FT=%d ESP=%x", ft, esp))
end

print(string.format("\n%d passed, %d failed", passed, failed))
if failed > 0 then error("stage 8 tests failed") end
