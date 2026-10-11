-- Stage 13 tests (Luau CLI):  luau -O2 --codegen tests/stage13/run.luau [scenario ...] [+detail]
-- Golden values come from the ORIGINAL NR2003.exe code executed in Unicorn (recovery/stage13: orig_stage13.py harness,
-- gen_units13.py, gen_fixtures13.py, scenarios13.py):
--   fixtures/units.lua            level 1: exact x87 arithmetic, ORIGINAL 00554d30 / FFB block of 00554520 / 00550070 +
--                                 0054fed0 + 00550680 / option setters / device conversion, vector by vector (bit-exact)
--   fixtures/scenario_<name>.lua  level 2: every tick's 00554d30 and every frame's FFB block of the original's closed-loop
--                                 run (inputs -> outputs, bit-exact); level 3: one frame from the original's state (FFB
--                                 cells + device output within the original's one-frame sensitivity); level 4: closed-loop
--                                 FFB output vs the envelope of the original's twins; level 5: deliberate FFB errors detected
local Vehicle = require("../../core/NR2003CupVehicle")

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
local V = car.V
local M, BASE = V.memory(), V.base
local r32, rf32, w32, wf32, r8, w8, ri32 = V.r32, V.rf32, V.w32, V.wf32, V.r8, V.w8, V.ri32
check("load core + Stage 13 force feedback (NR2003CupFFB)", V.setForceFeedbackOptions ~= nil and V.x87 ~= nil
	and V.steeringMode() == "original" and V.runtimeMode() == "original", string.format("%.2f s", os.clock() - t0))

local ARGS = {...}
local DETAIL = false
local WANT = {}
for _, a in ipairs(ARGS) do if a == "+detail" then DETAIL = true else WANT[a] = true end end
local S = buffer.create(8)
local function fb(u) buffer.writeu32(S, 0, u); return buffer.readf32(S, 0) end
local function bits(x) buffer.writef32(S, 0, x); return buffer.readu32(S, 0) end
local function dbl(hi, lo) buffer.writeu32(S, 4, hi); buffer.writeu32(S, 0, lo); return buffer.readf64(S, 0) end
local function dbits(x) buffer.writef64(S, 0, x); return buffer.readu32(S, 4), buffer.readu32(S, 0) end
local X = V.x87

local SUSPENDED, ACQUIRED, AXIS, DIRSIGN = 0xbf6eb8, 0xbf6ebb, 0xbf6ebc, 0x74c95c
local FF_ON, STRENGTH, DAMPING, LATENCY = 0xbf6f1c, 0x74c9a4, 0xbf6f24, 0xbf6f20
local REC7 = 0xd37cb8 + 29 * 7
local ACC = {0xbf6ed4, 0xbf6ed8, 0xbf6edc, 0xbf6ee0, 0xbf6ee4, 0xbf6ee8, 0xbf6eec, 0xbf6ef0}
local OUTS = {0x74c960, 0xbf6ec4, 0xbf6ec8, 0xbf6ed0}
local SLIP, PREV, FILT, MOMENT, AIRSPEED, RATIO = 0xbf6ec4, 0xbf6ec0, 0xbf6ecc, 0xbf6ed0, 0xbf3a00, 0xc055c0 + 4 * 0x30

---------------------------------------------------------------------------------------------- level 1: units
local U = require("./fixtures/units")
do
	-- image defaults (no controls.cfg): FF off, strength 80, damping 0, latency 0, not acquired, controls active
	V.reset()
	local I = U.image
	check("L1 image defaults: FF off, strength 80, damping 0, latency 0, not acquired, controls active",
		r32(STRENGTH) == I.strength and r32(DAMPING) == I.damping and r32(LATENCY) == I.latency and r8(FF_ON) == I.on
		and r8(ACQUIRED) == I.acquired and r8(SUSPENDED) == I.suspended and r32(AXIS) == I.axis and r32(DIRSIGN) == I.sign,
		string.format("strength %g", rf32(STRENGTH)))
end
do
	-- exact x87 arithmetic: (h, l) pairs, sign of zero included
	local function pairOf(v, k) return dbl(v[k], v[k + 1]), dbl(v[k + 2], v[k + 3]) end
	local function same(h, l, v, k)
		local eh, el = pairOf(v, k)
		local hh, hl = dbits(h)
		local ehh, ehl = dbits(eh)
		return hh == ehh and hl == ehl and l == el
	end
	for _, op in ipairs({"add", "mul", "div"}) do
		local bad, first = 0, nil
		for _, v in ipairs(U.x87[op]) do
			local ah, al = pairOf(v, 1)
			local bh, bl = pairOf(v, 5)
			local h, l = X[op](ah, al, bh, bl)
			if not same(h, l, v, 9) then
				bad += 1
				first = first or string.format("%.17g+%.17g %s %.17g+%.17g -> %.17g+%.17g want %.17g+%.17g", ah, al, op, bh, bl, h, l, pairOf(v, 9))
			end
		end
		check(string.format("L1 x87 %s: %d vectors (64-bit significand, round toward -inf; random, tiny operands, cancellations, carries, signed zeros), equal to the exact reference (cross-checked with x87 instructions in Unicorn)", op, #U.x87[op]),
			bad == 0, first)
	end
	-- sub = add of the negation
	local bad = 0
	for _, v in ipairs(U.x87.add) do
		local ah, al = pairOf(v, 1)
		local bh, bl = pairOf(v, 5)
		local h, l = X.sub(ah, al, -bh, -bl)
		if not same(h, l, v, 9) then bad += 1 end
	end
	check(string.format("L1 x87 sub (a - (-b) = a + b): %d vectors", #U.x87.add), bad == 0)
	bad = 0
	local first
	for _, v in ipairs(U.x87.f32) do
		local h, l = pairOf(v, 1)
		local f = X.f32(h, l)
		if bits(f) ~= v[5] then bad += 1; first = first or string.format("%.17g+%.17g -> %08x want %08x", h, l, bits(f), v[5]) end
	end
	check(string.format("L1 FST dword under RC = down (binary32, toward -inf): %d vectors", #U.x87.f32), bad == 0, first)
end
do
	-- ORIGINAL 00554d30
	local bad, first = 0, nil
	for _, v in ipairs(U.stats) do
		w32(0x74c964, v[1]); w32(0x74c968, v[2])
		for k = 1, 8 do w32(ACC[k], v[2 + k]) end
		V.ffbStatsOriginal()
		local ok = true
		for k = 1, 4 do if r32(OUTS[k]) ~= v[10 + k] then ok = false end end
		local cleared = r32(0x74c964) == 0 and r32(0x74c968) == 0
		for k = 1, 8 do if r32(ACC[k]) ~= 0 then cleared = false end end
		if not ok or (cleared and 1 or 0) ~= v[15] then
			bad += 1
			first = first or string.format("n %d/%d B %.9g/%.9g -> %08x %08x %08x %08x want %08x %08x %08x %08x", v[1], v[2], fb(v[5]), fb(v[6]),
				r32(OUTS[1]), r32(OUTS[2]), r32(OUTS[3]), r32(OUTS[4]), v[11], v[12], v[13], v[14])
		end
	end
	check(string.format("L1 00554d30 front tyre statistics: %d vectors (n <= 0, sum <= 0, unloaded, tiny / huge, cancellations, signed zeros, 1500 clamp): 74c960 / bf6ec4 / bf6ec8 / bf6ed0 bits + clears", #U.stats),
		bad == 0, first)
end
do
	-- ORIGINAL FFB block of 00554520 (the frame-end hook, with the 00551880 gate set)
	local trace = {}
	V._ffbTrace(trace)
	local bad, first = 0, nil
	for _, v in ipairs(U.block) do
		w8(ACQUIRED, v[1]); w8(SUSPENDED, v[2]); w32(AXIS, 5)
		local addrs = {SLIP, PREV, FILT, MOMENT, AIRSPEED, LATENCY, DAMPING, STRENGTH, RATIO}
		for k = 1, 9 do w32(addrs[k], v[2 + k]) end
		table.clear(trace)
		V._ffbFrameEnd()
		local n, force = 0, nil
		for _, t in ipairs(trace) do if t[1] == "force" then n += 1; force = bits(t[3]); if t[2] ~= 5 then n += 100 end end end
		local ok = r32(PREV) == v[12] and r32(FILT) == v[13] and n == v[14] and (n == 0 or force == v[15])
		if not ok then
			bad += 1
			first = first or string.format("ec4 %.9g ec0 %.9g ecc %.9g ed0 %.9g v %.9g lat %g damp %g str %g ratio %g -> prev %08x ecc %08x n %d force %08x want %08x %08x %d %08x",
				fb(v[3]), fb(v[4]), fb(v[5]), fb(v[6]), fb(v[7]), fb(v[8]), fb(v[9]), fb(v[10]), fb(v[11]), r32(PREV), r32(FILT), n, force or 0, v[12], v[13], v[14], v[15])
		end
	end
	V._ffbTrace(nil)
	w8(ACQUIRED, 0); w8(SUSPENDED, 0)
	check(string.format("L1 FFB block 0055464c..0055479d: %d vectors (gates, |ec4| <= 1e-5, rest / signed zeros, saturation, latency / damping / strength / ratio, raw option values) -> bf6ec0 / bf6ecc bits + 005d08d0(axis, force bits)", #U.block),
		bad == 0, first)
end
do
	-- ORIGINAL 00550070 -> 0054fed0 / 00550030, 00550680: state + device call sequence
	local trace = {}
	V._ffbTrace(trace)
	local KIND = {force = 0, acquire = 1, release = 2}
	local function sameLog(want)
		if #trace ~= #want then return false end
		for k, t in ipairs(trace) do
			local w = want[k]
			if KIND[t[1]] ~= w[1] or t[2] ~= w[2] then return false end
			if t[1] == "force" and bits(t[3]) ~= w[3] then return false end
		end
		return true
	end
	local bad, first = 0, nil
	for _, v in ipairs(U.controls) do
		local i = v.i
		local flag, kind, axis, direc, ebb, prevAxis, ffon, cap, acq, eff = i[1], i[2], i[3], i[4], i[5], i[6], i[7], i[8], i[9], i[10]
		w32(REC7 + 0x10, kind); w32(REC7 + 0x14, axis); w8(REC7 + 0x1c, direc)
		w8(ACQUIRED, ebb); w32(AXIS, prevAxis); w32(DIRSIGN, 0x55); w8(FF_ON, ffon); w8(SUSPENDED, 0x33)
		V._ffbHostState(cap == 1, acq == 1, eff == 1)
		table.clear(trace)
		V._ffbControls(flag)
		local _, _, effect = V._ffbHostState()
		local o = v.o
		local ok = r8(SUSPENDED) == o[1] and r8(ACQUIRED) == o[2] and r32(AXIS) == o[3] and r32(DIRSIGN) == o[4]
			and (effect and 1 or 0) == o[5] and sameLog(v.log)
		if not ok then
			bad += 1
			first = first or string.format("in %s -> %d %d %x %x %s (%d calls) want %d %d %x %x %d (%d calls)", table.concat(i, ","), r8(SUSPENDED), r8(ACQUIRED),
				r32(AXIS), r32(DIRSIGN), tostring(effect), #trace, o[1], o[2], o[3], o[4], o[5], #v.log)
		end
	end
	check(string.format("L1 00550070(flag) -> 0054fed0 / 00550030: %d cases (flag x binding type / axis / direction x acquired x same axis x FF on x device capable / acquire / effect) -> bf6eb8 / bf6ebb / bf6ebc / 74c95c / effect + device call sequence", #U.controls),
		bad == 0, first)
	bad = 0
	for _, v in ipairs(U.release) do
		w8(ACQUIRED, v.i[1]); w32(AXIS, 9)
		V._ffbHostState(v.i[2] == 1, true, v.i[3] == 1)
		table.clear(trace)
		V._ffbRelease()
		local _, _, effect = V._ffbHostState()
		if not (r8(ACQUIRED) == v.o[1] and (effect and 1 or 0) == v.o[2] and sameLog(v.log)) then bad += 1 end
	end
	check(string.format("L1 00550680 release (session end): %d cases", #U.release), bad == 0)
	V._ffbTrace(nil)
	V._ffbHostState(false, true, false)
	V.reset()
end
do
	-- option setters through the API (controls.cfg integer -> fild / fstp dword -> 00550290 / 005502d0 / 005502b0 / 00550270)
	local bad, first = 0, nil
	local CELL = {strength = STRENGTH, damping = DAMPING, latency = LATENCY}
	local HI = {strength = 100, damping = 100, latency = 250}
	for _, v in ipairs(U.setters) do
		local name, val, want = v[1], v[2], v[3]
		if name == "enabled" then
			V.setForceFeedbackOptions({enabled = val == 1})
			if r8(FF_ON) ~= want then bad += 1 end
		else
			local o = {}
			o[name] = math.clamp(val, 0, HI[name])   -- the API refuses out-of-range values (the front end clamps them)
			V.setForceFeedbackOptions(o)
			if r32(CELL[name]) ~= want then bad += 1; first = first or string.format("%s %g -> %08x want %08x", name, val, r32(CELL[name]), want) end
		end
	end
	local refused = not pcall(V.setForceFeedbackOptions, {strength = 101}) and not pcall(V.setForceFeedbackOptions, {latency = -1})
		and not pcall(V.setForceFeedbackOptions, {enabled = 1})
	V.clearForceFeedbackOptions(); V.reset()
	check(string.format("L1 FF option setters (messages 8..11) + controls.cfg conversion: %d vectors; out-of-range values refused", #U.setters), bad == 0 and refused, first)
	-- 005d3010 device conversion: lMagnitude = _ftol(force * 10000)
	bad = 0
	local got = {}
	V.setForceFeedbackSink(function(axis, force, mag) got[1] = mag end)
	V._ffbHostState(true, true, true)
	for _, v in ipairs(U.magnitude) do
		got[1] = nil
		w32(AXIS, 2)
		-- deliver through the device layer exactly as the FFB block does (force f32 -> 005d08d0)
		w8(ACQUIRED, 1); w8(SUSPENDED, 1)
		V._ffbControls(1)   -- acquired + suspend: 00550030 sends 0.0; then the vector force itself
		got[1] = nil
		V._ffbDeviceForce(2, fb(v[1]))
		if got[1] ~= v[2] then bad += 1 end
	end
	V.setForceFeedbackSink(nil); V._ffbHostState(false, true, false); V.reset()
	check(string.format("L1 005d3010 device conversion lMagnitude = _ftol(force x 10000): %d forces", #U.magnitude), bad == 0)
end


---------------------------------------------------------------------------------------------- helpers (Stage 11 / 12)
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
local SIZE = buffer.len(M)
local function applyRuns(dst, runs, s)
	local b = b64(s)
	local o = 0
	for _, r in ipairs(runs) do buffer.copy(dst, r[1] - BASE, b, o, 4 * r[2]); o += 4 * r[2] end
end
local rfb, ru = buffer.readf32, buffer.readu32
local function floatLike(x, y) return x == x and y == y and math.abs(x) < 1e12 and math.abs(y) < 1e12 end
local function floorOf(x, y) return math.max(2e-5 * math.max(math.abs(x), math.abs(y)), 1e-6) end
local FLAT = {}
for i = 1, 4 do FLAT[i] = {0, 0, 1, 0, 0, 0, 0, 1, 1} end
local function controlsOf(row)
	local c = {throttle = row[1], clutch = row[2], brakeControl = row[3], brakeDigital = true, shiftUp = row[4], shiftDown = row[5]}
	if row[9] then c.steerAxis = row[10] else c.steerLeft = row[6]; c.steerRight = row[7]; c.steerDigital = row[8] end
	if not row[11] then c.driver = false end
	return c
end
-- Stage 12 session (scenarios12): weather, Stage 11 options, steering options (validation: race bit 25), garage ratio;
-- Stage 13 adds the host device and the FF options before the session (the car placement runs 00550070(0))
local function session(law, ffbOn)
	local s = law.session
	local weather = {temperatureF = s.temperature, windSpeedMph = s.wind_mph, windDirection = s.wind_dir,
		conditions = s.conditions, night = s.night == 1}
	local o = law.options or {}
	V.setRuntimeMode("original"); V.setSteeringMode("original")
	V.endSession()
	V.clearSteeringOptions(); V.clearForceFeedbackOptions()
	V.setForceFeedbackDevice({capable = false})
	if law.ratio then
		local st = V.Setup.cupGarageDefault()
		V.Setup.set(st, "steeringRatio", law.ratio)
		assert(V.applySetup(st))
	else
		V.applySetup(V.Setup.cupGarageDefault())
	end
	V.reset()
	if law.steer then V.setSteeringOptions(law.steer, true) end
	if ffbOn then
		local d = law.device or {}
		V.setForceFeedbackDevice({capable = d.capable == true, acquire = d.acquire ~= false})
		if law.ffb then V.setForceFeedbackOptions(law.ffb) end
	end
	V.startSession(weather, {damageLevel = o.damage_level, consumptionRate = o.consumption, series = o.series or 1, seed = o.seed})
end
-- Stage 12 observation row (35 fields)
local CR, WR = table.create(9, 0), table.create(9, 0)
local stateBuf = table.create(45, 0)
local function rotOf(r, out) local _, rot = V.componentPose(r, nil, out); return rot end
local function observe(frame)
	local s = V.state(stateBuf)
	local row = {frame}
	for k = 1, 13 do table.insert(row, s[k]) end
	for _, a in ipairs({0xbf63c8, 0xbf63b8, 0xbf63c0, 0xbf6e80, 0xbf6360, 0xbf6364}) do table.insert(row, rf32(a)) end
	table.insert(row, s[16]); table.insert(row, s[22]); table.insert(row, rf32(0xc12030 + 0x1554)); table.insert(row, rf32(0xbf6f44))
	local cr = rotOf(0, CR)
	for _, r in ipairs({5, 8}) do
		local w = rotOf(r, WR)
		local ax = cr[1] * w[2] + cr[4] * w[5] + cr[7] * w[8]
		local ay = cr[2] * w[2] + cr[5] * w[5] + cr[8] * w[8]
		local az = cr[3] * w[2] + cr[6] * w[5] + cr[9] * w[8]
		table.insert(row, math.atan2(ax, ay)); table.insert(row, az)
	end
	for w = 0, 3 do table.insert(row, rf32(0xbf3a20 + w * 0xa39 + 0x2dc)) end
	for w = 0, 1 do table.insert(row, rf32(0xbf3a20 + w * 0xa39 + 0x2e0)) end
	table.insert(row, s[35]); table.insert(row, ri32(0x74c97c))
	return row
end

---------------------------------------------------------------------------------------------- level 2: traced calls
local function words(s)
	local b, n = b64(s)
	return b, n // 4
end
local function statsVectors(fx)
	local b, n = words(fx.stats)
	local bad, first = 0, nil
	for r = 0, n // 15 - 1 do
		local o = 60 * r
		w32(0x74c964, ru(b, o + 4)); w32(0x74c968, ru(b, o + 8))
		for k = 1, 8 do w32(ACC[k], ru(b, o + 8 + 4 * k)) end
		V.ffbStatsOriginal()
		-- record: tick, n_LF, n_RF, A_LF, A_RF, B_LF, B_RF, C_LF, C_RF, D_LF, D_RF, 74c960, bf6ec4, bf6ec8, bf6ed0
		for k = 1, 4 do
			if r32(OUTS[k]) ~= ru(b, o + 40 + 4 * k) then
				bad += 1
				first = first or string.format("tick %d cell %08x got %08x want %08x", ru(b, o), OUTS[k], r32(OUTS[k]), ru(b, o + 40 + 4 * k))
				break
			end
		end
	end
	return n // 15, bad, first
end
local BLOCK_IN = {SLIP, PREV, FILT, MOMENT, AIRSPEED, LATENCY, DAMPING, STRENGTH, RATIO, AXIS}
local function blockVectors(fx)
	local b, n = words(fx.blocks)
	local trace = {}
	V._ffbTrace(trace)
	local bad, first = 0, nil
	for r = 0, n // 17 - 1 do
		local o = 68 * r
		w8(ACQUIRED, ru(b, o + 4)); w8(SUSPENDED, ru(b, o + 8))
		for k = 1, 10 do w32(BLOCK_IN[k], ru(b, o + 8 + 4 * k)) end
		table.clear(trace)
		V._ffbFrameEnd()
		local nf, force = 0, 0
		for _, t in ipairs(trace) do if t[1] == "force" then nf += 1; force = bits(t[3]) end end
		local ok = r32(PREV) == ru(b, o + 52) and r32(FILT) == ru(b, o + 56) and nf == ru(b, o + 60) and (nf == 0 or force == ru(b, o + 64))
		if not ok then
			bad += 1
			first = first or string.format("tick %d: ec0 %08x ecc %08x calls %d force %08x want %08x %08x %d %08x", ru(b, o), r32(PREV), r32(FILT), nf, force,
				ru(b, o + 52), ru(b, o + 56), ru(b, o + 60), ru(b, o + 64))
		end
	end
	V._ffbTrace(nil)
	w8(ACQUIRED, 0); w8(SUSPENDED, 0)
	return n // 17, bad, first
end

---------------------------------------------------------------------------------------------- level 3: Stage 12 restarts
-- the Stage 12 full-state restarts (recovery/stage12/gen_fixtures12.py) carry the ORIGINAL's 00554d30 cells before and
-- after frame R (the harness always ran 00554d30; Stage 12 compared everything else and excluded these as host-only
-- because the port did not run it). One Luau frame from the original's state: the 16 FFB cells must equal the original
-- or lie within 4x its 12 one-frame twins (integer counts exact)
local FFB_RESTART = {0x74c960, 0x74c964, 0x74c968, 0xbf6ec0, 0xbf6ec4, 0xbf6ec8, 0xbf6ecc, 0xbf6ed0,
	0xbf6ed4, 0xbf6ed8, 0xbf6edc, 0xbf6ee0, 0xbf6ee4, 0xbf6ee8, 0xbf6eec, 0xbf6ef0}
local INT_CELL = {[0x74c964] = true, [0x74c968] = true}
-- host-only cells of Stage 12 that stay host-only here (stacks, contact blocks, export scratch, speed-cache tag)
local HOSTONLY = {{0x74c9ac, 0x74c9b0}, {0xe847c8, 0xe847cc}, {0xf7b000, 0xf7f100}, {0xf7f100, 0xf7f240}, {0xf7f240, 0xf7f2f4}}
local BLK, INTCOUNT = 0xf7f100 + 0xc0, 0x7559c4
local function restartFFB(fx12, rs, S0)
	local cp = V.checkpoint()
	buffer.copy(M, 0, S0, 0, SIZE)
	applyRuns(M, rs.beforeRuns, rs.before)
	for _, h in ipairs(HOSTONLY) do buffer.copy(M, h[1] - BASE, S0, h[1] - BASE, h[2] - h[1]) end
	for w = 0, 3 do for j = 0, 4 do w32(BLK + 32 * w + 4 * j, rs.blocks[5 * w + j + 1]) end end
	w32(INTCOUNT, rs.intCount)
	local E = buffer.create(SIZE)
	buffer.copy(E, 0, M, 0, SIZE)
	applyRuns(E, rs.afterRuns, rs.after)
	local T = {}
	for k, tw in ipairs(rs.twins) do
		T[k] = buffer.create(SIZE); buffer.copy(T[k], 0, E, 0, SIZE); applyRuns(T[k], tw.runs, tw.values)
	end
	V.tick = 0
	local c = controlsOf(fx12.law.controls[rs.frame + 1])
	for _ = 1, 8 do V.drive(c, FLAT) end
	local st = {exact = 0, float = 0, bad = 0, worst = 0, first = nil}
	for _, a in ipairs(FFB_RESTART) do
		local o = a - BASE
		local x, y = ru(E, o), ru(M, o)
		if x == y then st.exact += 1
		else
			local fx_, fy_ = rfb(E, o), rfb(M, o)
			local env = 0
			for k = 1, #T do local t = rfb(T[k], o); if t == t then env = math.max(env, math.abs(t - fx_)) end end
			local d = math.abs(fx_ - fy_)
			if not INT_CELL[a] and floatLike(fx_, fy_) and d <= math.max(4 * env, floorOf(fx_, fy_)) then
				st.float += 1
				st.worst = math.max(st.worst, d / math.max(math.abs(fx_), 1e-6))
			else
				st.bad += 1
				st.first = st.first or string.format("frame %d %08x want %08x (%.9g) got %08x (%.9g) env %.3g", rs.frame, a, x, fx_, y, fy_, env)
			end
		end
	end
	V.restore(cp)
	return st
end

---------------------------------------------------------------------------------------------- level 4: closed loop
local function play(fx)
	local trace = {}
	V.endSession()                 -- 00550680 of the previous run (if any) is not part of this run's device calls
	V._ffbTrace(trace)
	session(fx.law, true)
	local ev = {}
	for _, e in ipairs(fx.law.events or {}) do ev[e[1]] = ev[e[1]] or {}; table.insert(ev[e[1]], e) end
	local rows, ffb = {observe(0)}, {}
	local st = {}
	for k = 0, fx.law.frames - 1 do
		for _, e in ipairs(ev[k] or {}) do if e[2] == "controls" then V.setControlsSuspended(e[3] ~= 0) end end
		local c = controlsOf(fx.law.controls[k + 1])
		for _ = 1, 8 do V.drive(c, FLAT) end
		V.forceFeedbackState(st)
		-- n at the block = the counts of tick 8's passes (the next 00554d30 runs in the next tick)
		local nL, nR = ri32(0x74c964), ri32(0x74c968)
		local ran = st.blockRan
		table.insert(ffb, {k + 1, ran and bits(st.force) or 0x7fc00000, ran and 1 or 0, nL, nR, r32(SLIP), r32(MOMENT), r32(FILT),
			r32(0x74c960), r32(0xbf6ec8), r8(ACQUIRED), r8(SUSPENDED), r32(AXIS)})
		if (k + 1) % 9 == 0 then table.insert(rows, observe(k + 1)) end
	end
	V._ffbTrace(nil)
	return rows, ffb, trace
end
local FFB_FLOAT = {[2] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true}
local function compareFfb(fx, ffb)
	local horizon = fx.law.horizon or math.huge
	local nF = #fx.ffb
	local st = {compared = 0, envBad = 0, intBad = 0, after = 0, afterBad = 0, first = nil, ran = 0}
	for i, want in ipairs(fx.ffb) do
		local mine = ffb[i]
		if not mine then break end
		local after = want[1] > horizon
		if after then st.after += 1 else st.compared += 1 end
		if want[3] == 1 then st.ran += 1 end
		for j = 2, #want do
			local a, b = mine[j], want[j]
			local out = false
			if FFB_FLOAT[j] then
				if j == 2 and (want[3] == 0 or mine[3] == 0) then
					out = false                       -- 'ran' (field 3) decides; the force exists only when the block ran
				else
					local fa, fbb = fb(a), fb(b)
					local env = 0
					for m = math.max(1, i - 9), math.min(nF, i + 9) do
						local om = fb(fx.ffb[m][j])
						for _, tw in ipairs(fx.pertFfb) do
							local p = fb(tw[m][j])
							if p == p and om == om then env = math.max(env, math.abs(p - om)) end
						end
					end
					out = a ~= b and not (floatLike(fa, fbb) and math.abs(fa - fbb) <= math.max(4 * env, 2e-5 * math.abs(fbb), 1e-6))
				end
			else
				local twinDiffers = false
				for m = math.max(1, i - 9), math.min(nF, i + 9) do
					for _, tw in ipairs(fx.pertFfb) do if tw[m][j] ~= fx.ffb[m][j] then twinDiffers = true end end
				end
				out = a ~= b and not twinDiffers
			end
			if out then
				if after then st.afterBad += 1
				else
					if FFB_FLOAT[j] then st.envBad += 1 else st.intBad += 1 end
					st.first = st.first or string.format("frame %d %s lua %s orig %s", want[1], fx.ffbFields[j - 1],
						FFB_FLOAT[j] and string.format("%.9g", fb(a)) or tostring(a), FFB_FLOAT[j] and string.format("%.9g", fb(b)) or tostring(b))
				end
			end
		end
	end
	return st
end
local INT_FIELDS = {gear = true}
local function compareRows(fx, rows)
	local horizon = fx.law.horizon or math.huge
	local nRows = #fx.rows
	local st = {compared = 0, bad = 0, after = 0, first = nil}
	for i, want in ipairs(fx.rows) do
		local mine = rows[i]
		if not mine then break end
		if want[1] > horizon then st.after += 1; continue end
		st.compared += 1
		for j = 2, #want do
			local f = fx.fields[j - 1]
			local a, b = mine[j], want[j]
			local env, twinDiffers = 0, false
			for m = math.max(1, i - 1), math.min(nRows, i + 1) do
				local om = fx.rows[m][j]
				for _, tw in ipairs(fx.pert) do
					local p = tw[m][j]
					env = math.max(env, math.abs(p - om))
					if p ~= om then twinDiffers = true end
				end
			end
			local out
			if INT_FIELDS[f] then out = a ~= b and not twinDiffers
			else out = math.abs(a - b) > math.max(4 * env, 2e-5 * math.abs(b), 1e-6) end
			if out then st.bad += 1; st.first = st.first or string.format("frame %d %s lua %.9g orig %.9g env %.3g", want[1], f, a, b, env) end
		end
	end
	return st
end
local function sameDeviceCalls(fx, trace)
	local KIND = {force = 0, acquire = 1, release = 2}
	for k = 1, math.max(#trace, #fx.device) do
		local t, w = trace[k], fx.device[k]
		if t == nil or w == nil or KIND[t[1]] ~= w[1] or t[2] ~= w[2] then
			local around = {}
			for j = math.max(1, k - 3), math.min(math.max(#trace, #fx.device), k + 2) do
				local a, b = trace[j], fx.device[j]
				table.insert(around, string.format("%d:%s/%s", j, a and (a[1] .. (a[1] == "force" and string.format("(%.3g)", a[3]) or "")) or "-",
					b and tostring(b[1]) or "-"))
			end
			return false, string.format("%d calls, original %d; first difference at call %d [%s]", #trace, #fx.device, k, table.concat(around, " "))
		end
	end
	return true
end

---------------------------------------------------------------------------------------------- level 5: mutations
local MUTATIONS = {
	{"latency-predicted slip q x 1.001", function(s, v) if s == "q" then return v * 1.001 end return v end},
	{"damping term sign inverted (m + damping d)", function(s, v) if s == "damping" then return -v end return v end},
	{"steering ratio of 00554fb0 (low-speed override) instead of the raw item 0x30", function(s, v) if s == "ratio" then return V.steerRatioOriginal(true) end return v end},
	{"output scale x 1.01 (strength / ratio / 1600)", function(s, v) if s == "out" then return v * 1.01 end return v end},
	{"00554d30 slip weighting x (1 + 1e-4)", function(s, v) if s == "slip" then return v * (1 + 1e-4) end return v end},
	{"00554d30 load clamp (1500) removed", function(s, v) if s == "noclamp" then return true end return v end},
}
local DETECT = {}

local NAMES = {"slalom", "brakesteer", "ratio12", "linear", "keys", "notdriven", "suspend"}
local SHARED12 = {slalom = true, brakesteer = true, ratio12 = true, linear = true, keys = true, notdriven = true}
local sel = {}
for n in pairs(WANT) do table.insert(sel, n) end
if #sel > 0 then NAMES = sel end
local doubleBad, doubleN = 0, 0
for _, name in ipairs(NAMES) do
	local ok, fx = pcall(require, "./fixtures/scenario_" .. name)
	if not ok then check("fixture " .. name, false, tostring(fx)); continue end
	local t1 = os.clock()
	-- (2) the original's own calls of the closed-loop run
	local n1, bad1, first1 = statsVectors(fx)
	local n2, bad2, first2 = blockVectors(fx)
	check(string.format("%s: L2 %d traced 00554d30 calls (every %s tick) + %d frame-end FFB blocks of the original's run: bit-exact", name, n1,
		fx.statsEvery == 1 and "" or tostring(fx.statsEvery) .. "th", n2), bad1 == 0 and bad2 == 0, first1 or first2)
	-- the IEEE double model (Stage 6-12 lifter convention) on the same calls: evidence for the exact x87 arithmetic
	V._ffbModel("double")
	local _, d1 = statsVectors(fx)
	local _, d2 = blockVectors(fx)
	V._ffbModel("x87")
	doubleBad += d1 + d2; doubleN += n1 + n2
	print(string.format("      double model (intermediates in IEEE double): %d of %d calls differ in a stored bit", d1 + d2, n1 + n2))
	local seen = {}
	for i, mu in ipairs(MUTATIONS) do
		V._ffbModel("x87", mu[2])
		local _, m1 = statsVectors(fx)
		local _, m2 = blockVectors(fx)
		if m1 + m2 > 0 then DETECT[i] = (DETECT[i] or 0) + 1; table.insert(seen, tostring(i)) end
	end
	V._ffbModel("x87")
	print(string.format("      L5 traced calls: mutations detected in %s: {%s}", name, table.concat(seen, ",")))

	-- (3) the Stage 12 restarts of the same law (physics identical: nothing of the FFB feeds back)
	if SHARED12[name] then
		local ok12, fx12 = pcall(require, "../stage12/fixtures/scenario_" .. name)
		if ok12 and fx12.restart and #fx12.restart > 0 then
			session(fx12.law, false)
			local S0 = buffer.create(SIZE)
			buffer.copy(S0, 0, M, 0, SIZE)
			local tot = {exact = 0, float = 0, bad = 0, worst = 0, first = nil}
			for _, rs in ipairs(fx12.restart) do
				local st = restartFFB(fx12, rs, S0)
				tot.exact += st.exact; tot.float += st.float; tot.bad += st.bad; tot.worst = math.max(tot.worst, st.worst)
				tot.first = tot.first or st.first
			end
			check(string.format("%s: L3 %d Stage 12 full-state restarts: one Luau frame (00554d30 at @00553a64 every tick, frame-end values) -> the 16 FFB cells = original / within 4x its twins",
				name, #fx12.restart), tot.bad == 0, string.format("exact %d, within envelope %d (worst rel %.2e), outside %d %s", tot.exact, tot.float, tot.worst, tot.bad, tot.first or ""))
			-- timing mutation: 00554d30 after the tick's tyre passes instead of before them
			local tick = V._ffbTick
			V._ffbTick = function() end
			local drive = V.drive
			V.drive = function(c, ct) drive(c, ct); tick() end
			local late = 0
			for _, rs in ipairs(fx12.restart) do late += restartFFB(fx12, rs, S0).bad end
			V.drive = drive; V._ffbTick = tick
			if late > 0 then DETECT[#MUTATIONS + 1] = (DETECT[#MUTATIONS + 1] or 0) + 1 end
			print(string.format("      L5 restarts: 00554d30 after the tyre passes detected: %s (%d cells outside)", tostring(late > 0), late))
		else
			check(name .. ": Stage 12 restart fixture", false, tostring(fx12))
		end
	end

	-- (4) closed loop with the force feedback on
	local rows, ffb, trace = play(fx)
	local sf = compareFfb(fx, ffb)
	local sr = compareRows(fx, rows)
	local okDev, devFirst = sameDeviceCalls(fx, trace)
	check(string.format("%s: L4 closed loop %d frames (block ran %d): force / ec4 / ed0 / ecc / 74c960 / bf6ec8 within 4x the envelope of the original's %d twins, gates / counts / axis exact; %d observation rows; device calls = original",
		name, sf.compared, sf.ran, #fx.pertFfb, sr.compared), sf.envBad == 0 and sf.intBad == 0 and sr.bad == 0 and okDev,
		string.format("ffb outside %d (int %d), rows outside %d%s %s%s", sf.envBad, sf.intBad, sr.bad,
			sf.after > 0 and string.format(", after horizon: %d frames (%d outside, reported)", sf.after, sf.afterBad) or "",
			sf.first or sr.first or "", okDev and "" or (" device: " .. devFirst)))
	print(string.format("      %s: %.1f s", name, os.clock() - t1))
end
if #sel == 0 then
	local all = true
	local list = {}
	for i = 1, #MUTATIONS + 1 do
		if not DETECT[i] then all = false end
		table.insert(list, string.format("%d:%d", i, DETECT[i] or 0))
	end
	check(string.format("L5 every deliberate FFB error detected (6 mapping errors by the traced calls, 00554d30 timing by the restarts) {%s}",
		table.concat(list, " ")), all)
	check(string.format("L5 the IEEE double model is detected on the original's own calls (%d of %d differ): the exact x87 arithmetic is required", doubleBad, doubleN),
		doubleBad > 0)
end

---------------------------------------------------------------------------------------------- behaviour
do
	-- options survive reset() and a garage rebuild; bf6eb8 gates 005524f0 (not-driven branch); session end releases
	V.endSession(); V.clearSteeringOptions(); V.clearForceFeedbackOptions()
	V.applySetup(V.Setup.cupGarageDefault()); V.reset()
	V.setForceFeedbackDevice({capable = true})
	V.setForceFeedbackOptions({enabled = true, strength = 64, damping = 12, latency = 30})
	V.startSession(nil, {})
	local o1 = V.forceFeedbackOptions()
	V.reset()
	local o2 = V.forceFeedbackOptions()
	local st = V.Setup.cupGarageDefault(); V.Setup.set(st, "steeringRatio", 14); V.applySetup(st)
	local o3 = V.forceFeedbackOptions()
	check("behaviour: FF options survive reset() and a garage rebuild", o1.strength == 64 and o2.strength == 64 and o3.strength == 64
		and o3.damping == 12 and o3.latency == 30 and o3.enabled, string.format("%g %g %g", o1.strength, o2.strength, o3.strength))
	-- acquisition follows the control-7 binding (keys: never; analog axis: acquired at the first frame)
	for _ = 1, 8 do car:step({throttle = 0.3, clutch = 1, brakeControl = 0, steerLeft = 0, steerRight = 0, steerDigital = true}, FLAT) end
	local s1 = V.forceFeedbackState()
	for _ = 1, 8 do car:step({throttle = 0.3, clutch = 1, brakeControl = 0, steerAxis = 0.05}, FLAT) end
	local s2 = V.forceFeedbackState()
	check("behaviour: keys -> not acquired, no output; analog axis -> acquired (0054fed0), the block runs at the frame end",
		not s1.acquired and not s1.blockRan and s2.acquired and s2.blockRan and s2.effect)
	-- controls suspended: 005524f0 not-driven branch (brake held 1.0, throttle 0) + FFB block gated + zero force
	local sinkCalls = {}
	V.setForceFeedbackSink(function(axis, force, mag) table.insert(sinkCalls, mag) end)
	V.setControlsSuspended(true)
	local zero = sinkCalls[#sinkCalls] == 0
	for _ = 1, 8 do car:step({throttle = 1, clutch = 1, brakeControl = 0, steerAxis = 0.05}, FLAT) end
	local s3 = V.forceFeedbackState()
	local notDriven = rf32(0xbf6eac) == 1 and rf32(0xbf6390) == 0 and rf32(0xbf63c8) == 0
	V.setControlsSuspended(false)
	for _ = 1, 8 do car:step({throttle = 0.3, clutch = 1, brakeControl = 0, steerAxis = 0.05}, FLAT) end
	local s4 = V.forceFeedbackState()
	check("behaviour: setControlsSuspended (00550070(1)): zero force, 005524f0 not-driven branch, block gated; resume (00550070(0)) runs it again",
		zero and notDriven and s3.suspended and not s3.blockRan and not s4.suspended and s4.blockRan)
	V.setForceFeedbackSink(nil)
	V.endSession()
	local s5 = V.forceFeedbackState()
	check("behaviour: endSession releases the effect (00550680)", not s5.acquired and not s5.effect)
	-- determinism and checkpoint / restore with the FFB on
	V.clearForceFeedbackOptions(); V.applySetup(V.Setup.cupGarageDefault()); V.reset()
	V.setForceFeedbackDevice({capable = true}); V.setForceFeedbackOptions({enabled = true, damping = 40, latency = 100})
	V.startSession(nil, {})
	local function runN(n, out)
		for k = 1, n do
			car:step({throttle = 0.6, clutch = 1, brakeControl = 0, steerAxis = 0.1 * math.sin(k / 50)}, FLAT)
			if k % 8 == 0 then table.insert(out, bits(V.forceFeedbackState().force)) end
		end
	end
	local cp = V.checkpoint()
	local a, b = {}, {}
	runN(800, a)
	V.restore(cp)
	runN(800, b)
	local same = #a == #b
	for i = 1, #a do if a[i] ~= b[i] then same = false end end
	check("behaviour: deterministic FFB output, checkpoint / restore bit-identical", same and #a == 100)
	V.endSession(); V.clearForceFeedbackOptions(); V.setForceFeedbackDevice({capable = false}); V.reset()
end

print(string.format("\nStage 13: %d PASS, %d FAIL  (%.1f s)", passed, failed, os.clock() - t0))
if failed > 0 then error("stage 13 failures") end
