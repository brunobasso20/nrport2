-- Stage 6/7 regression tests (Luau CLI):  luau --codegen tests/stage67/run.luau
-- Golden values come from the ORIGINAL NR2003.exe code executed in Unicorn (fixtures/*.lua,
-- recovery/stage6_7/gen_fixtures.py). The Luau port evaluates x87 extended intermediates in IEEE
-- double (stores still round toward -inf), so long horizons are compared against the original's
-- own 1-ulp sensitivity envelope ('pert' runs), short horizons tightly.
local Vehicle = require("../../core/NR2003CupVehicle")
local RAW = require("./fixtures/raw_fixture")
local DRIVE = require("./fixtures/drive_fixture")

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

local t0 = os.clock()
local car = Vehicle.fromLoader(get)
check("load core (image parts + lifted natives + JIT modules)", car ~= nil, string.format("%.3f s", os.clock() - t0))
local V = car.V
-- Stage 11: the golden data of this suite were produced by the ORIGINAL code with the Stage 6-10 frame end (0051aac0 cut-timer subset); compare in the explicit "frozen" runtime mode (production = "original", see tests/stage11)
if V.setRuntimeMode then V.setRuntimeMode("frozen") end

local FLAT = {}
for i = 1, 4 do FLAT[i] = {0, 0, 1, 0, 0, 0, 0, 1, 1} end

local function rawInputs(k)
	local t = k / 288.0
	if t < 1.0 then return {gear = 1} end
	if t < 4.0 then return {gear = 2, clutch = 1, throttle = 1} end
	if t < 5.5 then return {gear = 2, clutch = 1, throttle = 0.6, lfSteer = 0.04, rfSteer = 0.035} end
	return {gear = 2, clutch = 1, throttle = 0, brake = 0.7}
end
local function controls(frame)
	local c = DRIVE.controls[frame + 1]
	return {throttle = c[1], brake = c[2], clutch = c[3], steer = c[4], shiftUp = c[5], shiftDown = c[6]}
end

local function relerr(a, b) return math.abs(a - b) / math.max(math.abs(a), math.abs(b), 1e-3) end

-- run a scenario, collect rows at the fixture ticks
local function runScenario(kind)
	V.reset()
	local fixture = kind == "raw" and RAW or DRIVE
	local want = {}
	for _, r in ipairs(fixture.orig) do want[r[1]] = true end
	local rows, s = {}, table.create(45, 0)
	for k = 1, fixture.ticks do
		if kind == "raw" then V.stepRaw(rawInputs(k), FLAT) else V.drive(controls((k - 1) // 8), FLAT) end
		if want[k] then
			V.state(s)
			local r = {k}
			for i = 1, 45 do r[i + 1] = s[i] end
			if kind == "drive" then r[47] = V.gearIndex(); r[48] = V.revLimiter() and 1 or 0 end
			rows[#rows + 1] = r
		end
	end
	return rows
end

for _, kind in ipairs({"raw", "drive"}) do
	local fixture = kind == "raw" and RAW or DRIVE
	local t = os.clock()
	local rows = runScenario(kind)
	local dt = os.clock() - t
	check(kind .. ": ran " .. fixture.ticks .. " ticks", #rows == #fixture.orig, string.format("%.3f s (%.0f ticks/s)", dt, fixture.ticks / dt))
	-- (a) first 8 ticks: every state within 2e-5 relative of the original (rounding-level only)
	local worst, at = 0, ""
	for n = 1, 8 do
		local a, b = rows[n], fixture.orig[n]
		for i = 2, 46 do
			local e = relerr(a[i], b[i])
			if e > worst then worst = e; at = string.format("tick %d state %d: %.9g vs %.9g", a[1], i - 2, a[i], b[i]) end
		end
	end
	check(kind .. ": ticks 1-8 match original (rel <= 2e-5)", worst <= 2e-5, string.format("worst %.2e (%s)", worst, at))
	-- (b) every sampled tick: chassis position/velocity stay within 3x the original's own 1-ulp spread
	local bad, report = 0, ""
	for n = 1, #rows do
		local a, o, p = rows[n], fixture.orig[n], fixture.pert[n]
		for _, i in ipairs({1, 2, 3, 4, 5, 6}) do
			local envelope = 3 * math.abs(p[i + 1] - o[i + 1]) + 0.02 + 0.01 * math.abs(o[i + 1])
			if math.abs(a[i + 1] - o[i + 1]) > envelope then
				bad += 1
				if report == "" then report = string.format("tick %d state %d lua %.5g orig %.5g pert %.5g", a[1], i - 1, a[i + 1], o[i + 1], p[i + 1]) end
			end
		end
	end
	check(kind .. ": chassis x/y/z + velocities within original sensitivity envelope", bad == 0, bad > 0 and report or string.format("%d samples", #rows))
	local last, olast = rows[#rows], fixture.orig[#fixture.orig]
	print(string.format("      final x: lua %.4f  orig %.4f  pert %.4f", last[2], olast[2], fixture.pert[#fixture.pert][2]))
	if kind == "drive" then
		-- (c) gear index sequence identical to the original (shift FSM 00553d70 lifted)
		local mism = 0
		for n = 1, #rows do if rows[n][47] ~= fixture.orig[n][47] then mism += 1 end end
		check("drive: gear sequence equals original (00553d70 + 00552450/80)", mism == 0, mism .. " mismatches")
		local maxGear = 0
		for n = 1, #rows do maxGear = math.max(maxGear, rows[n][47]) end
		check("drive: reached 4th gear (index 5)", maxGear == 5, "max index " .. maxGear)
	end
end

-- rev limiter: 1st gear full throttle must hit engine+0x438 (9300 rpm) and cut throttle (bf6368 = 0)
do
	V.reset()
	local cut, maxRpm = false, 0
	for k = 1, 1400 do
		local f = (k - 1) // 8
		local c = {clutch = f >= 18 and 1 or 0, throttle = f >= 24 and 1 or 0, shiftUp = (f == 30)}
		V.drive(c, FLAT)
		maxRpm = math.max(maxRpm, V.engineRpm())
		local _, _, thr = V.inputs()
		if V.revLimiter() and thr == 0 then cut = true end
	end
	check("rev limiter engages near 9300 rpm and cuts throttle", cut and maxRpm < 9300 * 1.10 and maxRpm > 9000, string.format("max %.0f rpm", maxRpm))
end

-- checkpoint / restore determinism (bit identical)
do
	V.reset()
	for k = 1, 400 do V.drive(controls((k - 1) // 8), FLAT) end
	local cp = V.checkpoint()
	local a = {}
	for k = 401, 700 do V.drive(controls((k - 1) // 8), FLAT) end
	V.state(a)
	V.restore(cp)
	for k = 401, 700 do V.drive(controls((k - 1) // 8), FLAT) end
	local b = V.state()
	local same = true
	for i = 1, 45 do if a[i] ~= b[i] then same = false end end
	check("checkpoint/restore replays bit-identically", same)
end

-- contact provider function == table form; reading the state does not perturb the run
do
	V.reset()
	for k = 1, 300 do V.drive(controls((k - 1) // 8), function() return FLAT end) end
	local a = V.state()
	V.reset()
	for k = 1, 300 do V.drive(controls((k - 1) // 8), FLAT); V.state() end
	local b = V.state()
	local same = true
	for i = 1, 45 do if a[i] ~= b[i] then same = false end end
	check("contact provider(phase) form and state reads are side-effect free", same)
end

-- component poses: chassis pose == exported state; wheel centres sit above their contact points
do
	V.reset()
	for k = 1, 600 do V.drive(controls((k - 1) // 8), FLAT) end
	local s = V.state()
	local p, r = V.componentPose(0)
	local qx, qy, qz, qw = s[7], s[8], s[9], s[10]
	local r01 = 2 * (qx * qy - qz * qw)
	local r02 = 2 * (qx * qz + qy * qw)
	local okPose = math.abs(p[1] - s[1]) < 1e-6 and math.abs(p[2] - s[3]) < 1e-6 and math.abs(p[3] - s[5]) < 1e-6
		and math.abs(r[2] - r01) < 1e-4 and math.abs(r[3] - r02) < 1e-4
	check("chassis record pose (+0x32d/+0x339) == state x,y,z and quaternion (xyzw)", okPose)
	local okWheels, detail = true, ""
	for i, rec in ipairs({5, 8, 10, 11}) do
		local wp = V.componentPose(rec)
		local _, _, fz, cx, cy, cz = V.contactOut(i - 1)
		local h = wp[3] - cz
		if not (math.abs(wp[1] - cx) < 0.05 and math.abs(wp[2] - cy) < 0.05 and h > 0.30 and h < 0.40 and fz > 1000) then okWheels = false end
		detail = detail .. string.format(" w%d h=%.3f Fz=%.0f", i - 1, h, fz)
	end
	check("wheel centres above 0055e1e0 contact points, loads positive", okWheels, detail)
end

-- original state import (005b4560) moves the car by the requested offset (positions only)
do
	V.reset()
	for k = 1, 300 do V.drive({clutch = 1}, FLAT) end
	local before = V.state()[1]
	V.translate(1.0, 0, 0)
	V.drive({clutch = 1}, FLAT)
	local after = V.state()[1]
	check("translate via original import 005b4560", math.abs(after - before - 1.0) < 0.01, string.format("dx %.4f", after - before))
end

-- machine balance: virtual x86 stack and x87 stack return to their rest values
do
	local ft, esp = V._fpu()
	check("x86/x87 stacks balanced after ticks", ft == 0 and esp == 0xf7f000, string.format("FT=%d ESP=%x", ft, esp))
end

print(string.format("\n%d passed, %d failed", passed, failed))
if failed > 0 then error("stage 6/7 tests failed") end
