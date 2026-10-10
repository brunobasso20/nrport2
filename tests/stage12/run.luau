-- Stage 12 tests (Luau CLI):  luau -O2 --codegen tests/stage12/run.luau [scenario ...] [+detail]
-- Golden values come from the ORIGINAL NR2003.exe code executed in Unicorn (recovery/stage12: orig_stage12.py harness,
-- gen_units12.py, gen_fixtures12.py, scenarios12.py):
--   fixtures/units.lua            level 1: ORIGINAL 00552d00 / 00552720 / 00554fb0 / 00551e80 tail / setters, vector by vector
--   fixtures/scenario_<name>.lua  level 2: frame-start snapshots (traced footprint of 005524f0 + 00551e80) bit for bit
--                                 level 3: full-state restarts (one frame from the original's state, twins envelope)
--                                 level 4: closed-loop rows vs the envelope of the original's 14 twins (law.horizon)
--                                 level 5: deliberate steering-mapping errors must be detected (levels 2 and 3)
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
local r32, rf32, w32, wf32, r8, w8 = V.r32, V.rf32, V.w32, V.wf32, V.r8, V.w8
check("load core + Stage 12 steering (NR2003CupSteering)", V.steeringMode ~= nil and V.steeringMode() == "original"
	and V.runtimeMode() == "original", string.format("%.2f s", os.clock() - t0))

local DETAIL = false
local FLAT = {}
for i = 1, 4 do FLAT[i] = {0, 0, 1, 0, 0, 0, 0, 1, 1} end
local S = buffer.create(8)
local function fb(u) buffer.writeu32(S, 0, u); return buffer.readf32(S, 0) end
local function bits(x) buffer.writef32(S, 0, x); return buffer.readu32(S, 0) end
local function fdBits(x) return bits(V.fd(x)) end
local CTRL_RAW, CTRL_TYPE = 0xd35b18, 0xd37cc8
local SETTINGS = 0xc0692a
local SETUP_RATIO = 0xc055c0 + 0x30 * 4

---------------------------------------------------------------------------------------------- helpers (Stage 11)
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
local function runsMap(runs, s)
	local b = b64(s)
	local map, o = {}, 0
	for _, r in ipairs(runs) do
		for k = 0, r[2] - 1 do map[r[1] + 4 * k] = buffer.readu32(b, o); o += 4 end
	end
	return map
end
local rfb, ru = buffer.readf32, buffer.readu32
local function floatLike(x, y) return x == x and y == y and math.abs(x) < 1e12 and math.abs(y) < 1e12 end
local function floorOf(x, y) return math.max(2e-5 * math.max(math.abs(x), math.abs(y)), 1e-6) end

---------------------------------------------------------------------------------------------- level 1: units
do
	local U = require("./fixtures/units")
	local function setupAxis(n, raw, dig, prev, rate)
		wf32(CTRL_RAW + 10 * n, fb(raw)); w32(CTRL_TYPE + 29 * n, dig and 0 or 1)
		wf32(0xbf639c + 4 * (n == 7 and 0 or 1), fb(prev)); wf32(0x74c990, fb(rate))
	end
	local rate0 = rf32(0x74c990)
	-- 00552d00(7 | 8)
	local bad, worstUlp, first = 0, 0, nil
	for _, v in ipairs(U.axis) do
		local n, raw, dig, prev, rate, near, down, state = v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8]
		setupAxis(n, raw, dig, prev, rate)
		local x = V.axisOriginal(n)
		local okS = r32(0xbf639c + 4 * (n == 7 and 0 or 1)) == state
		local okD = fdBits(x) == down
		local d = math.abs(x - near)
		local u = d == 0 and 0 or d / (math.abs(near) * 2 ^ -52 + 1e-300)
		if u > worstUlp then worstUlp = u end
		if not (okS and okD and u <= 4) then
			bad += 1
			first = first or string.format("n %d raw %.9g prev %.9g rate %.9g: x %.17g orig %.17g state %08x/%08x", n, fb(raw), fb(prev), fb(rate), x, near, r32(0xbf639c + 4 * (n == 7 and 0 or 1)), state)
		end
	end
	wf32(0x74c990, rate0)
	check(string.format("L1 00552d00 steering axes: %d vectors (raw x slew state x rate x binding): state bits + float32 of the x87 value exact, value <= 4 double ulp", #U.axis),
		bad == 0, string.format("worst %.2f ulp %s", worstUlp, first or ""))
	-- 00552720
	local s25 = r32(SETTINGS + 0x4c)
	local function speedState(v, yaw)
		wf32(0xbf6d44, fb(v)); wf32(0xbf6d4c, 0); wf32(0xbf6d54, 0); wf32(0xbf6d70, fb(yaw))
	end
	bad, first = 0, nil
	local exact = 0
	for _, v in ipairs(U.input) do
		local sp, yaw, L, b25, u, want = v[1], v[2], v[3], v[4], v[5], v[7]
		w32(SETTINGS + 0x4c, b25 == 1 and bit32.bor(s25, 0x2000000) or bit32.band(s25, bit32.bnot(0x2000000)))
		wf32(0xbf6f00, fb(L)); wf32(0x74c990, 1)
		speedState(sp, yaw)
		local uu = fb(u)
		wf32(CTRL_RAW + 70, uu < 0 and -uu or 0); wf32(CTRL_RAW + 80, uu > 0 and uu or 0)
		w32(CTRL_TYPE + 29 * 7, 1); w32(CTRL_TYPE + 29 * 8, 1)
		local x = V.steerInputOriginal()
		if bits(x) == want then exact += 1 else
			bad += 1
			first = first or string.format("v %.9g yaw %.9g L %.9g b25 %d u %.9g: lua %08x (%.9g) orig %08x (%.9g)", fb(sp), fb(yaw), fb(L), b25, uu, bits(x), x, want, fb(want))
		end
	end
	check(string.format("L1 00552720 processed input: %d vectors (11 inputs -1..1 x speed x yaw rate x linearity x yaw limiter) bit-exact", #U.input),
		bad == 0, string.format("exact %d %s", exact, first or ""))
	w32(SETTINGS + 0x4c, s25); wf32(0xbf6f00, 0); wf32(0x74c990, rate0)
	-- keyboard sequence (slew + sin)
	bad, first = 0, nil
	local lastV = nil
	for i, v in ipairs(U.keySeq) do
		if v[1] ~= lastV then wf32(0xbf639c, 0); wf32(0xbf63a0, 0); lastV = v[1] end
		speedState(v[1], bits(0.1))
		w32(CTRL_RAW + 70, v[2]); w32(CTRL_RAW + 80, v[3]); w32(CTRL_TYPE + 29 * 7, 0); w32(CTRL_TYPE + 29 * 8, 0)
		local x = V.steerInputOriginal()
		if bits(x) ~= v[4] or r32(0xbf639c) ~= v[5] or r32(0xbf63a0) ~= v[6] then
			bad += 1; first = first or string.format("step %d: lua %08x/%08x/%08x orig %08x/%08x/%08x", i, bits(x), r32(0xbf639c), r32(0xbf63a0), v[4], v[5], v[6])
		end
	end
	check(string.format("L1 keyboard steering sequence: %d frames of 00552720 with the 0.033/frame slew and sin shaping (key held, released, other key) bit-exact", #U.keySeq),
		bad == 0, first)
	-- 00554fb0
	bad, first = 0, nil
	worstUlp = 0
	for _, v in ipairs(U.ratio) do
		w8(0x74c9a0, v[1]); wf32(SETUP_RATIO, fb(v[2])); speedState(v[3], 0)
		local r = V.steerRatioOriginal()
		local near, down = v[4], v[5]
		local d = math.abs(r - near)
		local u = d == 0 and 0 or d / (math.abs(near) * 2 ^ -52)
		if u > worstUlp then worstUlp = u end
		if fdBits(r) ~= down or u > 2 then
			bad += 1; first = first or string.format("override %d ratio %.9g v %.9g: lua %.17g orig %.17g", v[1], fb(v[2]), fb(v[3]), r, near)
		end
	end
	w8(0x74c9a0, 1); wf32(SETUP_RATIO, 18)
	check(string.format("L1 00554fb0 steering ratio: %d vectors (speed at / +-1 ulp around 8.94 and 17.88 m/s x setup ratio 6.5..32 x low-speed override) float32 exact, x87 value <= 2 double ulp", #U.ratio),
		bad == 0, string.format("worst %.2f ulp %s", worstUlp, first or ""))
	-- 00551e80 tail
	bad, first = 0, nil
	local n = 0
	for _, v in ipairs(U.tail) do
		local L, dig, sp, rr, c8, prev, shaped, b8, e80, e88 = v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9], v[10]
		wf32(0xbf6f00, fb(L)); w32(CTRL_TYPE + 29 * 7, dig and 0 or 1); w32(CTRL_TYPE + 29 * 8, dig and 0 or 1)
		wf32(SETUP_RATIO, fb(rr)); speedState(sp, 0)
		w32(0xbf63c8, c8); w32(0xbf6e80, prev)
		local t = V._steerTail({})
		local myShaped = r32(0xbf63c0)
		local myE88 = fdBits(V._zsub(t, fb(prev)) / 8)
		n += 1
		if myShaped ~= shaped or fdBits(t) ~= b8 or fdBits(t) ~= e80 or myE88 ~= e88 then
			bad += 1
			first = first or string.format("L %.9g dig %s v %.9g ratio %.9g c8 %08x prev %08x: shaped %08x/%08x target %08x/%08x ramp %08x/%08x",
				fb(L), tostring(dig), fb(sp), fb(rr), c8, prev, myShaped, shaped, fdBits(t), b8, myE88, e88)
		end
	end
	wf32(0xbf6f00, 0); wf32(SETUP_RATIO, 18)
	check(string.format("L1 00551e80 tail (bf63c0 = -bf63c8, linearity _CIpow, x pi, / 00554fb0, bf63b8 / bf6e80 / bf6e88): %d vectors bit-exact", n),
		bad == 0, first)
	-- setters
	local st = U.setters
	bad, first = 0, nil
	for _, v in ipairs(st.linRaw) do
		V.setSteeringOptions({linearityRaw = fb(v[1])})
		if r32(0xbf6f00) ~= v[2] then bad += 1; first = first or string.format("linRaw %08x: %08x/%08x", v[1], r32(0xbf6f00), v[2]) end
	end
	for _, v in ipairs(st.linUI) do
		V.setSteeringOptions({linearity = v[1]})
		if r32(0xbf6f00) ~= v[2] then bad += 1; first = first or string.format("linearity %d: %08x/%08x", v[1], r32(0xbf6f00), v[2]) end
	end
	for _, v in ipairs(st.momentum) do
		V.setSteeringOptions({momentum = v[1]})
		if r32(0x74c990) ~= v[2] then bad += 1; first = first or string.format("momentum %d: %08x/%08x", v[1], r32(0x74c990), v[2]) end
	end
	for _, v in ipairs(st.lowSpeed) do
		V.setSteeringOptions({lowSpeedOverride = v[1] == 1})
		if r8(0x74c9a0) ~= v[2] then bad += 1; first = first or "lowSpeed" end
	end
	V.setSteeringOptions({assist = 0})
	if r32(0xbf6f08) ~= st.assist[1][2] then bad += 1; first = first or "assist" end
	check(string.format("L1 setters 005502f0 / 005500c0 / 00550110 / 00550210 + controls.cfg conversion of 0043f1d0: %d vectors bit-exact",
		#st.linRaw + #st.linUI + #st.momentum + #st.lowSpeed + #st.assist), bad == 0, first)
	V.clearSteeringOptions(); V.reset()
	check("image defaults (no front-end message): linearity 0, steering rate 0.033/frame, release x2.5, low-speed override on, assistance 0",
		(r32(0x74c990) == U.image.rate and r32(0x74c99c) == U.image.release and r8(0x74c9a0) == U.image.lowSpeed
		and r32(0xbf6f00) == U.image.linearity and r32(0xbf6f08) == U.image.assist and U.image.lowSpeed == 1
		and U.image.linearity == 0 and U.image.assist == 0 and fb(U.image.release) == 2.5
		and fb(U.image.rate) == 0.032999999821186066),
		string.format("rate %.9g release %.9g", fb(U.image.rate), fb(U.image.release)))
end

---------------------------------------------------------------------------------------------- scenarios
local function controlsOf(row)
	local c = {throttle = row[1], clutch = row[2], brakeControl = row[3], brakeDigital = true, shiftUp = row[4], shiftDown = row[5]}
	if row[9] then c.steerAxis = row[10] else c.steerLeft = row[6]; c.steerRight = row[7]; c.steerDigital = row[8] end
	if not row[11] then c.driver = false end
	return c
end

local function session(fx)
	local s = fx.law.session
	local weather = {temperatureF = s.temperature, windSpeedMph = s.wind_mph, windDirection = s.wind_dir,
		conditions = s.conditions, night = s.night == 1}
	local o = fx.law.options or {}
	V.setRuntimeMode("original"); V.setSteeringMode("original")
	V.endSession()
	V.clearSteeringOptions()
	if fx.law.ratio then
		local Setup = V.Setup
		local st = Setup.cupGarageDefault()
		Setup.set(st, "steeringRatio", fx.law.ratio)
		assert(V.applySetup(st))
	else
		V.applySetup(V.Setup.cupGarageDefault())
	end
	V.reset()
	if fx.law.steer then V.setSteeringOptions(fx.law.steer) end
	V.startSession(weather, {damageLevel = o.damage_level, consumptionRate = o.consumption, series = o.series or 1, seed = o.seed})
	buildProtected()
end

local T_ROOT = V.ROOT
local function rotOf(r, out)
	local _, rot = V.componentPose(r, nil, out)
	return rot
end
local CR, WR = table.create(9, 0), table.create(9, 0)
local stateBuf = table.create(45, 0)
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
	table.insert(row, rf32(0xbf3a20 + 0x2e0)); table.insert(row, rf32(0xbf3a20 + 0xa39 + 0x2e0))
	table.insert(row, s[35]); table.insert(row, V.gearIndex())
	return row
end

local function play(fx, onFrame)
	session(fx)
	local rows = {observe(0)}
	for k = 0, fx.law.frames - 1 do
		local c = controlsOf(fx.law.controls[k + 1])
		for _ = 1, 8 do V.drive(c, FLAT) end
		if onFrame then onFrame(k + 1) end
		if (k + 1) % 9 == 0 then table.insert(rows, observe(k + 1)) end
	end
	return rows
end

-- cells never compared in restarts (as Stage 11; the Unicorn harness and the Luau host differ by design)
local HOSTONLY = {
	{0x74c960, 0x74c96c}, {0x74c9ac, 0x74c9b0}, {0xbf6ec0, 0xbf6ef4}, {0xe847c8, 0xe847cc},
	{0xf7b000, 0xf7f100}, {0xf7f100, 0xf7f240}, {0xf7f240, 0xf7f2f4},
}
local function hostOnly(a)
	for _, h in ipairs(HOSTONLY) do if a >= h[1] and a < h[2] then return true end end
	return false
end
local BLK = 0xf7f100 + 0xc0
local INTCOUNT = 0x7559c4
-- protected (XOR-coded) Stage 11 values (fuel double, engine / tyre values): compared by their decoded value, as in
-- tests/stage11 (the fuel double differs by 1 ulp: x87 80-bit rounded down vs double, STAGE11_RECOVERY.md section 6)
local PROTECTED = {}   -- data cell address -> {base = triple address, kind = 4 | 8, slot}
local function buildProtected()
	table.clear(PROTECTED)
	local E = 0xc12030 + 0xc
	local list = {{E + 0x4a4, 4}, {E + 0x4d4, 4}, {E + 0x50c, 8}}
	for w = 0, 3 do
		local t = 0xbf3a20 + w * 0xa39
		for _, off in ipairs({0x74, 0x134, 0x160, 0x18c, 0x1b8, 0x1e4, 0x210, 0x23c, 0x26c}) do table.insert(list, {t + off, 4}) end
	end
	for _, e in ipairs(list) do
		local base, kind = e[1], e[2]
		for word = 0, kind // 4 - 1 do
			for slot = 0, 1 do PROTECTED[r32(base + 4 * slot) + 4 * word] = {base = base, kind = kind, slot = slot} end
		end
	end
end
local function decodeFrom(read, base, kind)
	local p0, p2 = r32(base), r32(base + 8)
	if kind == 4 then return fb(bit32.bxor(read(p0), read(p2))) end
	local lo, hi = bit32.bxor(read(p0), read(p2)), bit32.bxor(read(p0 + 4), read(p2 + 4))
	local d = buffer.create(8); buffer.writeu32(d, 0, lo); buffer.writeu32(d, 4, hi)
	return buffer.readf64(d, 0)
end

-- level 2: one Luau frame start from the original's traced inputs
local function frameStartSnap(sn, mutate)
	local cp = V.checkpoint()
	applyRuns(M, sn.beforeRuns, sn.before)
	local pre = buffer.create(SIZE)
	buffer.copy(pre, 0, M, 0, SIZE)
	local want = runsMap(sn.afterRuns, sn.after)
	V._steerMutate = mutate
	V._frameStartOnly(controlsOf(sn.controls))
	V._steerMutate = nil
	local st = {n = 0, exact = 0, bad = 0, extra = 0, first = nil}
	for a, w in pairs(want) do
		st.n += 1
		local mine = r32(a)
		if mine == w then st.exact += 1 else
			st.bad += 1
			st.first = st.first or string.format("%08x want %08x (%.9g) got %08x (%.9g)", a, w, fb(w), mine, fb(mine))
		end
	end
	-- Luau writes outside the original's written set (clocks / stacks / speed-cache tag excluded)
	for o = 0, SIZE - 4, 4 do
		if ru(M, o) ~= ru(pre, o) then
			local a = BASE + o
			if want[a] == nil and not hostOnly(a) and a ~= INTCOUNT and a ~= 0x74c9ac then
				st.extra += 1
				st.first = st.first or string.format("extra write %08x %08x -> %08x", a, ru(pre, o), ru(M, o))
			end
		end
	end
	V.restore(cp)
	return st
end

-- level 3: one Luau frame (frame start + 8 ticks + frame end) from the original's complete state (Stage 11 method)
local FIELDS
local INT_FIELDS = {gear = true}
local function restartFrame(fx, rs, S0, mutate)
	local cp = V.checkpoint()
	buffer.copy(M, 0, S0, 0, SIZE)
	applyRuns(M, rs.beforeRuns, rs.before)
	for _, h in ipairs(HOSTONLY) do
		if h[1] >= BASE and h[2] <= BASE + SIZE then buffer.copy(M, h[1] - BASE, S0, h[1] - BASE, h[2] - h[1]) end
	end
	for w = 0, 3 do for j = 0, 4 do w32(BLK + 32 * w + 4 * j, rs.blocks[5 * w + j + 1]) end end
	w32(INTCOUNT, rs.intCount)
	local E = buffer.create(SIZE)
	buffer.copy(E, 0, M, 0, SIZE)
	applyRuns(E, rs.afterRuns, rs.after)
	buffer.writeu32(E, INTCOUNT - BASE, rs.intCount + 1)
	local T = {}
	for k, tw in ipairs(rs.twins) do
		T[k] = buffer.create(SIZE)
		buffer.copy(T[k], 0, E, 0, SIZE)
		applyRuns(T[k], tw.runs, tw.values)
	end
	V.tick = 0
	V._steerMutate = mutate
	local c = controlsOf(fx.law.controls[rs.frame + 1])
	for _ = 1, 8 do V.drive(c, FLAT) end
	V._steerMutate = nil
	local st = {cells = 0, exact = 0, float = 0, worst = 0, at = 0, int = 0, firstInt = nil}
	local rb = buffer.readu8
	local function fieldOk(w)
		local o = w - BASE
		if o < 0 or o + 4 > SIZE then return false, 0 end
		local x, y = rfb(E, o), rfb(M, o)
		if x == y then return true, 0 end
		if not floatLike(x, y) then return false, 0 end
		local env = 0
		for k = 1, #T do
			local t = rfb(T[k], o)
			if t == t then env = math.max(env, math.abs(t - x)) end
		end
		local d = math.abs(x - y)
		return d <= math.max(4 * env, floorOf(x, y)), d / math.max(math.abs(x), math.abs(y), 1e-6)
	end
	local readE = function(a) return ru(E, a - BASE) end
	local seenProt = {}
	for o = 0, SIZE - 4, 4 do
		if ru(M, o) ~= ru(E, o) then
			local a = BASE + o
			if not hostOnly(a) then
				st.cells += 1
				local p = PROTECTED[a]
				if p then
					if not seenProt[p.base] then
						seenProt[p.base] = true
						local u, v = decodeFrom(readE, p.base, p.kind), decodeFrom(r32, p.base, p.kind)
						local env = 0
						for k = 1, #T do env = math.max(env, math.abs(decodeFrom(function(q) return ru(T[k], q - BASE) end, p.base, p.kind) - u)) end
						st.prot = (st.prot or 0) + 1
						if math.abs(u - v) > math.max(4 * env, floorOf(u, v)) then
							st.int += 1; st.firstInt = st.firstInt or string.format("%08x protected %.17g / %.17g", a, u, v)
						end
					end
					continue
				end
				local cellOk, cellRel = true, 0
				for j = 0, 3 do
					if rb(M, o + j) ~= rb(E, o + j) then
						local best, okByte = math.huge, false
						for s = 3, 0, -1 do
							local ok, d = fieldOk(a + j - s)
							if ok then okByte = true; best = math.min(best, d) end
						end
						if not okByte then cellOk = false else cellRel = math.max(cellRel, best) end
					end
				end
				if cellOk then
					st.float += 1
					if cellRel > st.worst then st.worst = cellRel; st.at = a end
				else
					st.int += 1
					st.firstInt = st.firstInt or string.format("%08x want %08x (%.9g) got %08x (%.9g)", a, ru(E, o), fb(ru(E, o)), ru(M, o), fb(ru(M, o)))
					if DETAIL and not mutate then print(string.format("    R%d %08x want %08x (%.9g) got %08x (%.9g)", rs.frame, a, ru(E, o), fb(ru(E, o)), ru(M, o), fb(ru(M, o)))) end
				end
			end
		end
	end
	local row = observe(rs.frame + 1)
	local x45 = V.state(stateBuf)
	for k = 1, 45 do table.insert(row, x45[k]) end
	local rowBad, rowFirst = 0, nil
	for j = 2, #rs.row do
		local f = FIELDS[j - 1] or ("s" .. (j - 2 - #FIELDS))
		local a, b = row[j], rs.row[j]
		local env, twinDiffers = 0, false
		for _, tw in ipairs(rs.twins) do
			env = math.max(env, math.abs(tw.row[j] - b))
			if tw.row[j] ~= b then twinDiffers = true end
		end
		local ok
		if INT_FIELDS[f] then ok = a == b or twinDiffers
		else ok = math.abs(a - b) <= math.max(4 * env, floorOf(a, b)) end
		if not ok then
			rowBad += 1; rowFirst = rowFirst or string.format("%s lua %.9g orig %.9g env %.2g", f, a, b, env)
		end
	end
	V.restore(cp)
	return st, rowBad, rowFirst
end

-- deliberate steering-mapping errors (level 5): each must be detected by the frame-start snapshots and the restarts
local MUTATIONS = {
	{"input x 1.001 (00552720 sensitivity)", function(s, v) if s == "input" then return v * 1.001 end return v end},
	{"linearity exponent +5% (|x|^(L+1) -> |x|^1.05(L+1))", function(s, v) if s == "shaped" then return (v < 0 and -1 or 1) * math.abs(v) ^ 1.05 end return v end},
	{"steering ratio +0.1 (00554fb0)", function(s, v) if s == "ratio" then return v + 0.1 end return v end},
	{"low-speed override ignored (setup ratio at every speed)", function(s, v) if s == "ratio" then return rf32(SETUP_RATIO) end return v end},
	{"road-wheel target +1e-4 relative", function(s, v) if s == "target" then return v * (1 + 1e-4) end return v end},
}

local NAMES = {"keys", "slalom", "linear", "brakesteer", "ratio12", "ratio32", "parking", "yawlimit", "notdriven", "stationary"}
local args = {}
for _, a in ipairs({...}) do
	if a == "+detail" then DETAIL = true else table.insert(args, a) end
end
if #args > 0 then NAMES = args end

local totals = {snaps = 0, n = 0, exact = 0}
DETECT2, DETECT3 = {}, {}
for _, name in ipairs(NAMES) do
	local ok, fx = pcall(require, "./fixtures/scenario_" .. name)
	if not ok then check("fixture " .. name, false, tostring(fx)); continue end
	FIELDS = fx.fields

	-- (2) frame-start snapshots
	session(fx)
	local agg = {n = 0, exact = 0, bad = 0, extra = 0, first = nil}
	for _, sn in ipairs(fx.start) do
		local st = frameStartSnap(sn)
		agg.n += st.n; agg.exact += st.exact; agg.bad += st.bad; agg.extra += st.extra
		if st.first and not agg.first then agg.first = string.format("frame %d %s", sn.frame, st.first) end
	end
	totals.snaps += #fx.start; totals.n += agg.n; totals.exact += agg.exact
	check(string.format("%s: L2 %d frame-start snapshots (traced 005524f0 + 00551e80): written dwords bit-exact, no extra Luau writes", name, #fx.start),
		agg.bad == 0 and agg.extra == 0, string.format("%d dwords: exact %d, differing %d, extra writes %d %s", agg.n, agg.exact, agg.bad, agg.extra, agg.first or ""))
	-- mutations at the snapshots (a mutation without effect in a scenario -- e.g. the override in 'parking', where it
	-- is off -- cannot be seen there: detection is aggregated over all scenarios at the end)
	local seen = {}
	for i, mu in ipairs(MUTATIONS) do
		for _, sn in ipairs(fx.start) do
			local st = frameStartSnap(sn, mu[2])
			if st.bad > 0 then DETECT2[i] = (DETECT2[i] or 0) + 1; table.insert(seen, tostring(i)); break end
		end
	end
	print(string.format("      L5 frame-start: mutations detected in %s: {%s}", name, table.concat(seen, ",")))

	-- (3) full-state restarts
	if fx.restart and #fx.restart > 0 then
		local S0 = buffer.create(SIZE)
		session(fx)
		buffer.copy(S0, 0, M, 0, SIZE)
		local tot = {cells = 0, float = 0, int = 0, worst = 0, at = 0, rowBad = 0}
		local first, frames = nil, {}
		for _, rs in ipairs(fx.restart) do
			local st, rowBad, rowFirst = restartFrame(fx, rs, S0)
			tot.cells += st.cells; tot.float += st.float; tot.int += st.int; tot.rowBad += rowBad; tot.prot = (tot.prot or 0) + (st.prot or 0)
			if st.worst > tot.worst then tot.worst = st.worst; tot.at = st.at end
			if (st.int > 0 or rowBad > 0) and not first then
				first = string.format("frame %d: %s%s", rs.frame, st.firstInt or "", rowFirst and (" row " .. rowFirst) or "")
			end
			table.insert(frames, tostring(rs.frame))
		end
		check(string.format("%s: L3 %d full-state restarts (frames %s): one Luau frame from the original state = original within 4x its twins",
			name, #fx.restart, table.concat(frames, ",")), tot.int == 0 and tot.rowBad == 0,
			string.format("%d differing cells: float %d, protected %d (worst rel %.2e at %08x), outside tolerance %d, row fields %d %s",
				tot.cells, tot.float, tot.prot, tot.worst, tot.at, tot.int, tot.rowBad, first or ""))
		-- mutations at the restart point with the largest steering input
		local best, bestV = fx.restart[#fx.restart], -1
		for _, rs in ipairs(fx.restart) do
			local row = fx.law.controls[rs.frame + 1]
			local v = math.abs(row[10]) + row[6] + row[7]
			if v > bestV then bestV = v; best = rs end
		end
		if bestV > 0 then
			local seenR = {}
			for i, mu in ipairs(MUTATIONS) do
				local st, rowBad = restartFrame(fx, best, S0, mu[2])
				if st.int > 0 or rowBad > 0 then DETECT3[i] = (DETECT3[i] or 0) + 1; table.insert(seenR, tostring(i)) end
			end
			print(string.format("      L5 restart frame %d: mutations detected in %s: {%s}", best.frame, name, table.concat(seenR, ",")))
		end
	end

	-- (4) closed loop vs the original's twins (4x envelope over the row and its neighbours): ten Stage 11 twins (chassis
	-- height +-1 ulp) + four 'all' twins (+-1 ulp on the 45-state vector every frame). Rows after law.horizon are
	-- reported, not gated (Stage 11 method; per scenario in gen_fixtures12.HORIZON with the evidence in
	-- STAGE12_VALIDATION.md: the original's own branch choice, shown by the original continued from the port's state).
	local t1 = os.clock()
	local rows = play(fx)
	local dt = os.clock() - t1
	local envBad, intBad, compared, firstBad = 0, 0, 0, nil
	local afterBad, afterRows = 0, 0
	local horizon = fx.law.horizon or math.huge
	local nRows = #fx.rows
	for i, want in ipairs(fx.rows) do
		local mine = rows[i]
		if not mine then break end
		local after = want[1] > horizon
		if after then afterRows += 1 else compared += 1 end
		for j = 2, #want do
			local f = FIELDS[j - 1]
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
			if out and after then afterBad += 1
			elseif out then
				if INT_FIELDS[f] then intBad += 1 else envBad += 1 end
				firstBad = firstBad or (INT_FIELDS[f] and string.format("frame %d %s lua %s orig %s", want[1], f, tostring(a), tostring(b))
					or string.format("frame %d %s lua %.9g orig %.9g envelope %.3g", want[1], f, a, b, env))
			end
		end
	end
	check(string.format("%s: L4 %d s closed loop (%d rows x %d fields) within 4x the envelope of the original's %d twins%s",
		name, fx.law.frames // 36, compared, #FIELDS, #fx.pert, fx.law.horizon and string.format(" (horizon frame %d)", horizon) or ""),
		envBad == 0 and intBad == 0,
		string.format("%.1f s Luau (%.0f ticks/s); outside envelope %d, integer %d %s%s", dt, fx.law.frames * 8 / dt, envBad, intBad, firstBad or "",
			afterRows > 0 and string.format(" | after horizon (not gated): %d rows, %d field-rows outside", afterRows, afterBad) or ""))
	local last, lastO = rows[#rows], fx.rows[#fx.rows]
	print(string.format("      end: x %.3f/%.3f m  y %.3f/%.3f m  yaw rate %.4f/%.4f  hub LF %.5f/%.5f  wheel yaw LF %.5f/%.5f",
		last[2], lastO[2], last[4], lastO[4], last[14], lastO[14], last[21], lastO[21], last[25], lastO[25]))
end
print(string.format("frame-start snapshots total: %d snapshots, %d dwords, exact %d (%.4f%%)", totals.snaps, totals.n, totals.exact,
	100 * totals.exact / math.max(totals.n, 1)))
do
	local miss2, miss3, list2, list3 = {}, {}, {}, {}
	for i, mu in ipairs(MUTATIONS) do
		table.insert(list2, string.format("%d:%d", i, DETECT2[i] or 0)); table.insert(list3, string.format("%d:%d", i, DETECT3[i] or 0))
		if not DETECT2[i] then table.insert(miss2, mu[1]) end
		if not DETECT3[i] then table.insert(miss3, mu[1]) end
	end
	if #NAMES >= 6 then
		check(string.format("L5 every deliberate steering-mapping error (%d) is detected by the frame-start snapshots (scenarios per mutation %s)",
			#MUTATIONS, table.concat(list2, " ")), #miss2 == 0, #miss2 > 0 and ("never detected: " .. table.concat(miss2, ", ")) or nil)
		check(string.format("L5 every deliberate steering-mapping error (%d) is detected by the full-state restarts (scenarios per mutation %s)",
			#MUTATIONS, table.concat(list3, " ")), #miss3 == 0, #miss3 > 0 and ("never detected: " .. table.concat(miss3, ", ")) or nil)
	end
end

---------------------------------------------------------------------------------------------- API / behaviour
do
	V.setRuntimeMode("original"); V.setSteeringMode("original"); V.endSession(); V.clearSteeringOptions(); V.reset()
	-- options survive reset and a garage rebuild
	V.setSteeringOptions({linearity = 80, momentum = 0, lowSpeedOverride = false})
	V.reset()
	local o1 = V.steeringOptions()
	local Setup = V.Setup
	local st = Setup.cupGarageDefault()
	Setup.set(st, "steeringRatio", 25)
	local ok = V.applySetup(st)
	local o2 = V.steeringOptions()
	check("steering options survive reset() and a garage rebuild (applySetup); the rebuilt setup ratio reaches 00554fb0",
		ok and math.abs(o1.linearity - 0.8) < 1e-6 and o1.steerRate == 1 and not o1.lowSpeedOverride
		and math.abs(o2.linearity - 0.8) < 1e-6 and o2.setupRatio == 25 and V.steerRatioOriginal() == 25)
	V.clearSteeringOptions(); V.applySetup(Setup.cupGarageDefault()); V.reset()
	check("default garage ratio 18:1 (setup item 0x30) after restoring the default setup", V.steeringOptions().setupRatio == 18)
	-- steering assistance needs the track racing line: refused
	local okA = pcall(V.setSteeringOptions, {assist = 50})
	check("steering assistance > 0 refused (needs the NR2003 track racing line; not ported)", not okA)
	-- provisional mode = Stage 6-11 contract (regression suites)
	V.setSteeringMode("provisional")
	for _ = 1, 8 do V.drive({throttle = 0, clutch = 1, steer = 0.1}, FLAT) end
	local s1 = rf32(0xbf6e80)
	V.setSteeringMode("original")
	for _ = 1, 8 do V.drive({throttle = 0, clutch = 1, steer = 0.1}, FLAT) end
	local s2 = rf32(0xbf6e80)
	check("steering mode 'provisional' (regression only) takes controls.steer as road-wheel target; 'original' ignores it",
		math.abs(s1 - 0.1) < 1e-7 and s2 == 0)
	-- full lock at rest: +-pi / 7 (low-speed override), cockpit wheel clamped at +-2.79 rad (005662d0)
	V.reset()
	for _ = 1, 8 * 60 do V.drive({throttle = 0, clutch = 1, steerAxis = -1}, FLAT) end
	local ss = V.steeringState()
	check("analog full left at rest: road-wheel target = pi / 7 (ratio 18 -> 7 below 8.94 m/s), hubs = target -+ toe/2, cockpit wheel -2.79 rad",
		ss.target == V.fd(rf32(0x6f4a4c) / 7) and ss.ratio == 7 and math.abs(ss.hubLF - (ss.current - ss.toeLeft)) < 1e-6
		and math.abs(ss.wheelAngle + rf32(0x6f5e6c)) < 1e-6,
		string.format("target %.6f ratio %.3f hub LF/RF %.6f/%.6f wheel %.4f", ss.target, ss.ratio, ss.hubLF, ss.hubRF, ss.wheelAngle))
	-- determinism / checkpoint with the steering chain
	local function run(n, k0)
		local out = {}
		k0 = k0 or 0
		for i = 1, n do
			local k = k0 + i
			local c = {throttle = 0.7, clutch = 1, steerAxis = 0.2 * math.sin(k / 20), shiftUp = k == 40}
			for _ = 1, 8 do V.drive(c, FLAT) end
			out[i] = r32(0xbf6360) .. ":" .. r32(0xbf6d44)
		end
		return out
	end
	V.reset(); local a = run(200)
	V.reset(); local b = run(100); local cp = V.checkpoint(); local b2 = run(100, 100)
	V.restore(cp); local b3 = run(100, 100)
	local same = true
	for k = 1, 100 do if a[k] ~= b[k] or a[100 + k] ~= b2[k] or b2[k] ~= b3[k] then same = false end end
	check("determinism: identical steering runs and checkpoint/restore replay are bit-identical", same)
	V.reset()
end

print(string.format("\n%d passed, %d failed", passed, failed))
if failed > 0 then error("Stage 12 tests failed") end
