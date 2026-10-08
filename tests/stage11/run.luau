-- Stage 11 tests (Luau CLI):  luau -O2 --codegen tests/stage11/run.luau [scenario ...]
-- Golden values come from the ORIGINAL NR2003.exe code executed in Unicorn (recovery/stage11/gen_fixtures11.py,
-- harness recovery/stage11/orig_stage11.py): the whole original frame end 00554520 + collision frame 00549c40,
-- the original collision record entry 0054a760, pit service 00550f10 and car-placed-on-track 00550a50 subset.
--   fixtures/footprint.lua         dwords touched / written by the original Stage 11 code (Unicorn trace)
--   fixtures/scenario_<name>.lua   session + control law + events, original rows every 0.5 s, the 1-ulp twin
--                                  rows, the footprint right after the session start, and synchronized
--                                  snapshots (footprint before / written dwords after one frame end or event)
local Vehicle = require("../../core/NR2003CupVehicle")
local FP = require("./fixtures/footprint")

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
local r32, rf32, w32 = V.r32, V.rf32, V.w32
check("load core + Stage 11 runtime (NR2003CupFrame*)", V.stage11State ~= nil and V.runtimeMode() == "original",
	string.format("%.2f s, supplement %d bytes", os.clock() - t0, V._stage11Supplement or -1))

local FLAT = {}
for i = 1, 4 do FLAT[i] = {0, 0, 1, 0, 0, 0, 0, 1, 1} end

---------------------------------------------------------------------------------------------- helpers
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
-- load a footprint snapshot (runs of dwords) into the core memory
local function load(runs, s)
	local b = b64(s)
	local o = 0
	for _, r in ipairs(runs) do
		buffer.copy(M, r[1] - BASE, b, o, 4 * r[2]); o += 4 * r[2]
	end
end
-- Protected (XOR-encoded) values of the original: pointer triple {p0, p1, p2} at a fixed address, value = *p0 ^ *p2,
-- check *p1 = *p0 ^ KEY. Their data cells are compared through the decoded value (a 1-ulp difference of the value
-- changes the low bits of p0 and p1). The triples (engine water / oil, fuel double, per tyre wear, wear clock, 3
-- surface + 3 carcass temperatures, brake temperature) are read from the core memory (the pool layout never moves:
-- rdtsc = 1, no re-keying / relocation).
local PROTECTED = {}   -- data cell address -> {base = triple address, kind = 4 | 8, word = 0 | 1}
do
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
	buffer.writeu32(S, 0, lo); local d = buffer.create(8); buffer.writeu32(d, 0, lo); buffer.writeu32(d, 4, hi)
	return buffer.readf64(d, 0)
end
-- compare the core memory with a snapshot: exact dwords; float-like cells by relative distance; protected data cells
-- by their decoded value; anything else (pointers, bit fields, counters) must be exact
local function compare(runs, s, st)
	local b = b64(s)
	local o = 0
	local snap = {}
	for _, r in ipairs(runs) do
		for k = 0, r[2] - 1 do snap[r[1] + 4 * k] = buffer.readu32(b, o + 4 * k) end
		o += 4 * r[2]
	end
	local function readSnap(a) return snap[a] or r32(a) end
	st = st or {n = 0, exact = 0, float = 0, worst = 0, at = 0, int = 0, firstInt = nil, prot = 0, protWorst = 0}
	for a, want in pairs(snap) do
		local mine = r32(a)
		st.n += 1
		if want == mine then st.exact += 1
		else
			local p = PROTECTED[a]
			if p then
				local x, y = decodeFrom(readSnap, p.base, p.kind), decodeFrom(r32, p.base, p.kind)
				local d = math.abs(x - y) / math.max(math.abs(x), math.abs(y), 1e-6)
				st.prot += 1
				if d > st.protWorst then st.protWorst = d end
				if d > st.worst then st.worst = d; st.at = a end
			else
				local x, y = fb(want), fb(mine)
				-- float-like cells: finite, moderate magnitude (pointers / bit fields / counters are integers)
				if x == x and y == y and math.abs(x) < 1e12 and math.abs(y) < 1e12 and (math.abs(x) > 1e-30 or math.abs(y) > 1e-30) then
					st.float += 1
					local d = math.abs(x - y) / math.max(math.abs(x), math.abs(y), 1e-6)
					if d > st.worst then st.worst = d; st.at = a end
				else
					st.int += 1
					if not st.firstInt then st.firstInt = string.format("%08x want %08x got %08x", a, want, mine) end
				end
			end
		end
	end
	return st
end

local function session(fx)
	local s = fx.law.session
	local weather = {temperatureF = s.temperature, windSpeedMph = s.wind_mph, windDirection = s.wind_dir,
		conditions = s.conditions, night = s.night == 1}
	local o = fx.law.options or {}
	V.setRuntimeMode("original")
	V.endSession()
	V.reset()
	V.startSession(weather, {damageLevel = o.damage_level, consumptionRate = o.consumption, series = o.series or 1, seed = o.seed})
end

local function controlsOf(row)
	return {throttle = row[1], clutch = row[2], steer = row[3], brakeControl = row[4], brakeDigital = true,
		shiftUp = row[5], shiftDown = row[6]}
end
local function collisionRec(a)
	return {magnitude = a.magnitude, material = a.material, surface = a.surface, flags = a.flags, point = a.point,
		localPoint = a["local"], otherLocal = a.other_local, velocity = a.velocity, normal = a.normal, p9 = a.p9,
		speed = a.speed, key = a.key, other = a.other}
end

local OBS = table.create(64, 0)
local st11 = {}
local stateBuf = table.create(45, 0)
local function observe(frame)
	local s = V.stage11State(st11)
	local row = {frame, s.fuel.kg, s.engine.water, s.engine.oil, s.engine.coolantLevel, s.engine.oilLevel, s.engine.power,
		s.engine.overRev, s.engine.wear}
	for w = 1, 4 do
		local t = s.tyres[w]
		table.insert(row, t.pressure); table.insert(row, t.surface[2]); table.insert(row, t.carcass[2])
		table.insert(row, t.wear); table.insert(row, t.gripWear); table.insert(row, t.brake)
	end
	local d = s.damage
	table.insert(row, d.words[1]); table.insert(row, d.words[3]); table.insert(row, d.words[4])
	for k = 1, 11 do table.insert(row, d.zones[k]) end
	table.insert(row, d.radiator); table.insert(row, d.oil); table.insert(row, d.fuel); table.insert(row, d.engine)
	local x = V.state(stateBuf)
	for k = 1, 6 do table.insert(row, x[k]) end
	table.insert(row, x[35]); table.insert(row, V.gearIndex()); table.insert(row, s.fuel.massRecord); table.insert(row, s.random)
	return row
end

-- run a scenario from its session start; returns rows every 18 frames (+ frame 0)
local function play(fx, onFrame)
	session(fx)
	local rows = {observe(0)}
	local ev = {}
	for _, e in ipairs(fx.law.events) do
		local k = e[1]
		ev[k] = ev[k] or {}
		table.insert(ev[k], e)
	end
	for k = 0, fx.law.frames - 1 do
		for _, e in ipairs(ev[k] or {}) do
			if e[2] == "enter" then V.enterTrack() end
		end
		local c = controlsOf(fx.law.controls[k + 1])
		for _ = 1, 8 do V.drive(c, FLAT) end
		for _, e in ipairs(ev[k] or {}) do
			if e[2] == "collision" then V.collision(collisionRec(e[3]))
			elseif e[2] == "pit" then V.pitTyres(e[3]) end
		end
		if onFrame then onFrame(k + 1) end
		if (k + 1) % 18 == 0 then table.insert(rows, observe(k + 1)) end
	end
	return rows
end

local FIELDS = FP.fields
local INT_FIELDS = {dmg0 = true, dmg8 = true, dmgC = true, gear = true, rng = true}

---------------------------------------------------------------------------------------------- full-state restarts
-- Cells that differ BY DESIGN between the Unicorn harness and the Luau host (never compared, never loaded):
local HOSTONLY = {
	{0x74c960, 0x74c96c},   -- 00554d30 FFB frame statistics (called by 005539c0; not ported in Stage 7, PORT_MAP)
	{0x74c9ac, 0x74c9b0},   -- 00554f50 speed cache tag (getIntCount): the Luau speed() recomputes (Stage 8 ADAPTER)
	{0xbf6ec0, 0xbf6ef4},   -- 00554d30 column-torque outputs / accumulators, FFB filter of 00554520 (bf6ebb = 0: off)
	{0xe847c8, 0xe847cc},   -- 005b2cb0 export target (the harness exports into its own scratch block)
	{0xf7b000, 0xf7f100},   -- Luau virtual stacks (the Unicorn reference runs on its own stack)
	{0xf7f100, 0xf7f240},   -- Luau tyre-pass host blocks: outputs, ground velocities, contact blocks (harness: heap)
	{0xf7f240, 0xf7f2f4},   -- 005b2cb0 export scratch block (written whenever a host reads the state)
}
local TYRE_LO, TYRE_HI = 0xbf3a20, 0xbf3a20 + 4 * 0xa39       -- packed tyre structs (stride 0xa39)
local DMG_LO, DMG_HI = 0xc12030 + 0x1493, 0xc12030 + 0x1493 + 0x80
local BLK = 0xf7f100 + 0xc0                                   -- NR2003CupCore contact blocks (32 bytes per wheel)
local INTCOUNT = 0x7559c4
local function hostOnly(a)
	for _, h in ipairs(HOSTONLY) do if a >= h[1] and a < h[2] then return true end end
	return false
end
-- floor of every 1-frame comparison (never tighter): 2e-5 relative, 1e-6 absolute (cells near zero)
local function floorOf(x, y) return math.max(2e-5 * math.max(math.abs(x), math.abs(y)), 1e-6) end
local function floatLike(x, y)
	return x == x and y == y and math.abs(x) < 1e12 and math.abs(y) < 1e12
end
local SIZE = buffer.len(M)
local function applyRuns(dst, runs, s)
	local b = b64(s)
	local o = 0
	for _, r in ipairs(runs) do buffer.copy(dst, r[1] - BASE, b, o, 4 * r[2]); o += 4 * r[2] end
end
local rfb = buffer.readf32
-- deliberate small errors in Stage 11 states read by the per-tick physics (sensitivity check of the restart test)
local wf32 = V.wf32
local T2 = 0xbf3a20 + 2 * 0xa39
local MUTATIONS = {
	{"rear-left tyre grip factor (+0xcc) -2%", function() wf32(T2 + 0xcc, rf32(T2 + 0xcc) * 0.98) end},
	-- (+0x2a0, the hot pressure, is recomputed by 0054d610 from the carcass temperatures every frame end; the tick's
	-- tyre model 0054cab0 reads the pressure / temperature dependent fields 0054d610 derives from it: +0x29c, +0x2a4)
	{"rear-left tyre pressure-derived stiffness (+0x29c) +5%", function() wf32(T2 + 0x29c, rf32(T2 + 0x29c) * 1.05) end},
	{"fuel mass of the multibody record +2 kg", function() local a = r32(r32(0xc08234) + 0x125); wf32(a, rf32(a) + 2) end},
}
-- One Luau frame from the ORIGINAL's complete state at the start of frame R, compared with the original's state after
-- frame R. Tolerance, cell by cell: 4x the original's own one-frame sensitivity (its frame R re-run from the same state
-- with one integrated chassis cell +-1 ulp, or the whole 45-state vector +-1 ulp before every tick through the original
-- export / import: twins), never tighter than 2e-5 relative / 1e-6 absolute. Fields of
-- packed structures sit at any byte alignment (tyres stride 0xa39, damage car+0x1493, car+0x11c8..): every differing
-- byte must be explained by a 4-byte float field containing it (offsets -3..0) that matches within that tolerance.
local function restartFrame(fx, rs, S0, mutate)
	local cp = V.checkpoint()
	buffer.copy(M, 0, S0, 0, SIZE)
	applyRuns(M, rs.beforeRuns, rs.before)
	for _, h in ipairs(HOSTONLY) do
		if h[1] >= BASE and h[2] <= BASE + SIZE then buffer.copy(M, h[1] - BASE, S0, h[1] - BASE, h[2] - h[1]) end
	end
	for w = 0, 3 do for j = 0, 4 do w32(BLK + 32 * w + 4 * j, rs.blocks[5 * w + j + 1]) end end
	w32(INTCOUNT, rs.intCount)
	-- expected state after frame R (E) and the original's twins (T)
	local E = buffer.create(SIZE)
	buffer.copy(E, 0, M, 0, SIZE)
	applyRuns(E, rs.afterRuns, rs.after)
	buffer.writeu32(E, INTCOUNT - BASE, rs.intCount + 1)          -- the harness clock advanced during the frame
	local T = {}
	for k, tw in ipairs(rs.twins) do
		T[k] = buffer.create(SIZE)
		buffer.copy(T[k], 0, E, 0, SIZE)
		applyRuns(T[k], tw.runs, tw.values)
	end
	if mutate then mutate() end
	local c = controlsOf(fx.law.controls[rs.frame + 1])
	for _ = 1, 8 do V.drive(c, FLAT) end
	local st = {cells = 0, exact = 0, float = 0, worst = 0, at = 0, prot = 0, int = 0, firstInt = nil}
	local ru, rb = buffer.readu32, buffer.readu8
	-- does the float field at w (E vs M) match within the envelope? returns ok, relative difference
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
						for k = 1, #T do
							local t = decodeFrom(function(q) return ru(T[k], q - BASE) end, p.base, p.kind)
							env = math.max(env, math.abs(t - u))
						end
						st.prot += 1
						local d = math.abs(u - v) / math.max(math.abs(u), math.abs(v), 1e-6)
						if d > st.worst then st.worst = d; st.at = a end
						if math.abs(u - v) > math.max(4 * env, floorOf(u, v)) then
							st.int += 1; st.firstInt = st.firstInt or string.format("%08x protected %.9g / %.9g", a, u, v)
						end
					end
				else
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
	end
	-- observation row after the frame (Stage 11 states + chassis + gear + RNG, then the 45 state values)
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
			if DETAIL and not mutate then print(string.format("    R%d row %s lua %.9g orig %.9g envelope %.3g", rs.frame, f, a, b, env)) end
		end
	end
	V.restore(cp)
	return st, rowBad, rowFirst
end

---------------------------------------------------------------------------------------------- scenarios
local NAMES = {"launch", "overrev", "brakes", "slide", "cold", "hot", "impacts", "pit", "enter", "x4", "idle", "failure"}
local args = {}
for _, a in ipairs({...}) do
	if a == "+detail" then DETAIL = true else table.insert(args, a) end   -- +detail: list restart cells out of tolerance
end
if #args > 0 then NAMES = args end

local totals = {n = 0, exact = 0, float = 0, worst = 0, int = 0}
for _, name in ipairs(NAMES) do
	local ok, fx = pcall(require, "./fixtures/scenario_" .. name)
	if not ok then check("fixture " .. name, false, tostring(fx)); continue end

	-- (1) session start: the footprint right after the Stage 11 session start equals the original's
	session(fx)
	local st = compare(FP.touchRuns, fx.start)
	check(string.format("%s: session start footprint (%d dwords) = original", name, st.n),
		st.int == 0 and st.worst <= 1e-6,
		string.format("exact %d, float %d, protected %d (worst %.2e at %08x), other %d %s", st.exact, st.float, st.prot, st.worst, st.at, st.int, st.firstInt or ""))

	-- (2) synchronized snapshots: original state before the frame end / event -> Luau frame end / event -> compare
	local fam = {}
	for _, sn in ipairs(fx.sync) do
		local cp = V.checkpoint()
		load(FP.touchRuns, sn.before)
		if sn.kind == "frame" then V._frameEnd()
		elseif sn.kind == "collision" then V.collision(collisionRec(sn.args))
		elseif sn.kind == "pit" then V.pitTyres(sn.wheels)
		elseif sn.kind == "enter" then V.enterTrack() end
		local s2 = compare(FP.writeRuns, sn.after)
		fam[sn.kind] = fam[sn.kind] or {n = 0, exact = 0, float = 0, worst = 0, at = 0, int = 0, cnt = 0, prot = 0}
		local f = fam[sn.kind]
		f.cnt += 1; f.n += s2.n; f.exact += s2.exact; f.float += s2.float; f.int += s2.int; f.prot += s2.prot
		if s2.worst > f.worst then f.worst = s2.worst; f.at = s2.at end
		if s2.firstInt and not f.firstInt then f.firstInt = string.format("frame %d %s", sn.frame, s2.firstInt) end
		totals.n += s2.n; totals.exact += s2.exact; totals.float += s2.float; totals.int += s2.int
		if s2.worst > totals.worst then totals.worst = s2.worst end
		V.restore(cp)
	end
	for kind, f in pairs(fam) do
		check(string.format("%s: %d synchronized %s snapshot(s): original -> Luau, written dwords bit-exact or <= 2e-5 relative", name, f.cnt, kind),
			f.int == 0 and f.worst <= 2e-5,
			string.format("%d dwords: exact %d, float %d, protected %d (worst %.2e at %08x), other %d %s", f.n, f.exact, f.float, f.prot, f.worst, f.at, f.int, f.firstInt or ""))
	end

	-- (2b) full-state restarts: the ORIGINAL's complete state at the start of frame R (every dword it changed since the
	-- session start, its tyre contact blocks and interrupt clock) is loaded, Luau runs frame R (8 ticks + frame end)
	-- and the whole memory window and the observation row are compared (1-frame per-tick policy of Stages 6/7: exact,
	-- or float within 2e-5 relative / 1e-6 absolute; integers exact). Restart points every 5 s of the long runs and
	-- right after events: the per-tick physics <-> Stage 11 coupling (tyre temperature / pressure / wear / damage ->
	-- force, fuel -> mass and inertia, engine damage -> power) in every regime the runs reach.
	if fx.restart and #fx.restart > 0 then
		local S0 = buffer.create(SIZE)
		session(fx)
		buffer.copy(S0, 0, M, 0, SIZE)
		local tot = {cells = 0, exact = 0, float = 0, prot = 0, int = 0, worst = 0, at = 0, rowBad = 0}
		local first, frames = nil, {}
		for _, rs in ipairs(fx.restart) do
			local st, rowBad, rowFirst = restartFrame(fx, rs, S0)
			tot.cells += st.cells; tot.exact += st.exact; tot.float += st.float; tot.prot += st.prot; tot.int += st.int
			tot.rowBad += rowBad
			if st.worst > tot.worst then tot.worst = st.worst; tot.at = st.at end
			if (st.int > 0 or rowBad > 0) and not first then
				first = string.format("frame %d: %s%s", rs.frame, st.firstInt or "", rowFirst and (" row " .. rowFirst) or "")
			end
			table.insert(frames, tostring(rs.frame))
		end
		check(string.format("%s: %d full-state restarts (frames %s): one Luau frame from the original state = original (window + row)",
			name, #fx.restart, table.concat(frames, ",")), tot.int == 0 and tot.rowBad == 0,
			string.format("%d differing cells: float %d, protected %d (worst rel %.2e at %08x), outside tolerance %d, row fields %d %s",
				tot.cells, tot.float, tot.prot, tot.worst, tot.at, tot.int, tot.rowBad, first or ""))
		-- sensitivity of that comparison: a small error in a Stage 11 state the per-tick physics reads must be detected
		local rs = fx.restart[#fx.restart]
		local missed = {}
		for _, mu in ipairs(MUTATIONS) do
			local st, rowBad = restartFrame(fx, rs, S0, mu[2])
			if st.int == 0 and rowBad == 0 then table.insert(missed, mu[1]) end
		end
		check(string.format("%s: the restart comparison detects small Stage 11 -> physics errors (%d mutations at frame %d)", name, #MUTATIONS, rs.frame),
			#missed == 0, #missed > 0 and ("not detected: " .. table.concat(missed, ", ")) or nil)
	end

	-- (3) complete closed-loop run vs the original rows, within the ORIGINAL's own sensitivity: the envelope at a row
	-- is the largest deviation of the original's ten twins (chassis z +-1 ulp at the start; eight runs with +-1 ulp
	-- on the multibody chassis height every frame = the kind of perturbation the port's inherited per-tick rounding
	-- is) over that row and its neighbours (+-0.5 s), and Luau must stay within 4x that envelope, never tighter than
	-- 2e-5 relative / 1e-6 absolute. Integer fields (damage words, gear, random stream state) must equal the original
	-- unless one of its twins differs there too. Rows after law.horizon are not gated (documented per scenario in
	-- recovery/stage11/gen_fixtures11.HORIZON: a random failure whose threshold the port's rounding can flip; an
	-- inherited Stage 6-10 divergence); they are reported ("after horizon") and covered by the snapshots / restarts.
	local t1 = os.clock()
	local rows = play(fx)
	local dt = os.clock() - t1
	local envBad, intBad, compared, afterBad, afterRows = 0, 0, 0, 0, 0
	local firstBad
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
			if INT_FIELDS[f] then
				if a ~= b and not twinDiffers then
					if after then afterBad += 1; continue end
					intBad += 1
					if not firstBad then firstBad = string.format("frame %d %s lua %s orig %s", want[1], f, tostring(a), tostring(b)) end
				end
			else
				local d = math.abs(a - b)
				if d > math.max(4 * env, 2e-5 * math.abs(b), 1e-6) then
					if after then afterBad += 1; continue end
					envBad += 1
					if not firstBad then firstBad = string.format("frame %d %s lua %.9g orig %.9g envelope %.3g", want[1], f, a, b, env) end
				end
			end
		end
	end
	check(string.format("%s: %d s closed-loop run (%d rows x %d fields) within 4x the envelope of the original's %d twins%s",
		name, fx.law.frames // 36, compared, #FIELDS, #fx.pert, fx.law.horizon and string.format(" (horizon frame %d)", horizon) or ""),
		envBad == 0 and intBad == 0,
		string.format("%.1f s Luau (%.0f ticks/s); outside envelope %d, integer %d %s%s", dt, fx.law.frames * 8 / dt, envBad, intBad, firstBad or "",
			afterRows > 0 and string.format(" | after horizon (not gated): %d rows, %d field-rows outside", afterRows, afterBad) or ""))
	local last, lastO = rows[#rows], fx.rows[#fx.rows]
	print(string.format("      end: fuel %.3f/%.3f kg  water %.2f/%.2f C  oil %.2f/%.2f C  wear LR %.4f/%.4f  brake LF %.1f/%.1f K",
		last[2], lastO[2], last[3], lastO[3], last[4], lastO[4], last[2 + 8 + 2 * 6 + 3], lastO[2 + 8 + 2 * 6 + 3],
		last[2 + 8 + 5], lastO[2 + 8 + 5]))
end
print(string.format("synchronized snapshots total: %d dwords, exact %d (%.4f%%), float %d (worst %.2e), other %d",
	totals.n, totals.exact, 100 * totals.exact / math.max(totals.n, 1), totals.float, totals.worst, totals.int))

---------------------------------------------------------------------------------------------- determinism
do
	local ok, fx = pcall(require, "./fixtures/scenario_launch")
	if ok then
		local short = {law = {session = fx.law.session, options = fx.law.options, frames = 360, controls = fx.law.controls, events = {}}}
		local a = play(short)
		local cpAt, cp = 180, nil
		local b = play(short, function(k) if k == cpAt then cp = V.checkpoint() end end)
		local same = #a == #b
		for i = 1, #a do for j = 1, #a[i] do if a[i][j] ~= b[i][j] then same = false end end end
		check("determinism: two runs of 10 s are bit-identical (all Stage 11 rows)", same)
		V.restore(cp)
		local tail = {}
		for k = cpAt, 359 do
			local c = controlsOf(short.law.controls[k + 1])
			for _ = 1, 8 do V.drive(c, FLAT) end
			if (k + 1) % 18 == 0 then table.insert(tail, observe(k + 1)) end
		end
		local same2 = true
		for i, row in ipairs(tail) do
			local ref = b[(row[1] // 18) + 1]
			for j = 1, #row do if row[j] ~= ref[j] then same2 = false end end
		end
		check("checkpoint at 5 s / restore replays the Stage 11 state bit-identically (fuel, temperatures, wear, damage, RNG)", same2)
	end
end

---------------------------------------------------------------------------------------------- frozen mode
do
	V.setRuntimeMode("frozen")
	V.endSession(); V.reset()
	local s0 = V.stage11State()
	for _ = 1, 288 do V.drive({throttle = 1, clutch = 1}, FLAT) end
	local s1 = V.stage11State()
	check("frozen mode (Stage 6-10 comparisons only): fuel / temperatures / wear held at the post-build values",
		s1.fuel.kg == s0.fuel.kg and s1.engine.water == s0.engine.water and s1.tyres[3].wear == s0.tyres[3].wear
		and s1.tyres[1].surface[2] == s0.tyres[1].surface[2] and s1.bgCount == s0.bgCount)
	V.setRuntimeMode("original")
end

print(string.format("\n%d passed, %d failed", passed, failed))
if failed > 0 then error("Stage 11 tests failed") end
