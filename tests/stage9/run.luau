-- Stage 9 aero regression tests (Luau CLI):  luau -O2 --codegen tests/stage9/run.luau
-- Golden values come from the ORIGINAL NR2003.exe code executed in Unicorn
-- (recovery/stage9/gen_fixtures_stage9.py, harness recovery/stage9/orig_aero.py):
--   aero_constants.lua  NR2003.exe bytes of every constant embedded by NR2003CupAero
--   aero_units.lua      bit-level vectors: 005a3c00 weather, 005a3ba0 density, 00561a80 half wind,
--                       00561b70 aero force/moment, 005b0230 wake, 005afd80 drafting, garage conversions
--   aero_sync.lua       original machine snapshots + original results 8/16 ticks later + original
--                       00561b70 evaluated at the snapshot state
--   aero_scenarios.lua  complete runs of the original car with session air (and a 1-ulp twin)
local Vehicle = require("../../core/NR2003CupVehicle")
local KC = require("./fixtures/aero_constants")
local UNITS = require("./fixtures/aero_units")
local SYNC = require("./fixtures/aero_sync")
local SC = require("./fixtures/aero_scenarios")

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
local M, BASE = V.memory(), V.base
local w32, r32, rf32 = V.w32, V.r32, V.rf32
local callx = V._callx
local FLAT = {}
for i = 1, 4 do FLAT[i] = {0, 0, 1, 0, 0, 0, 0, 1, 1} end
local S = buffer.create(8)
local function fb(u) buffer.writeu32(S, 0, u); return buffer.readf32(S, 0) end
local function bf(x) buffer.writef32(S, 0, x); return buffer.readu32(S, 0) end
local function ulps(a, b)
	if a == b then return 0 end
	local function ord(u) if u >= 0x80000000 then return 0x80000000 - u end return u end
	return math.abs(ord(a) - ord(b))
end
local function relerr(a, b, floor) return math.abs(a - b) / math.max(math.abs(a), math.abs(b), floor or 1e-3) end

local AIR, WEATHER, CAR = 0xe0b840, 0xe0b728, 0xc12030
local HOST = 0xf7f100
local BLOCK, OUT6, TOBJ = HOST + 0x600, HOST + 0x640, HOST + 0x680
local F_DRAG, F_FRONT, F_REAR = 0x59e, 0x5a2, 0x5a6

-- per-family statistics of bit-level comparisons
local function stats() return {n = 0, exact = 0, worst = 0, at = ""} end
local function add(st, d, where)
	st.n += 1
	if d == 0 then st.exact += 1 end
	if d > st.worst then st.worst = d; st.at = where end
end

---------------------------------------------------------------------------------------------- constants
do
	local bad, n = 0, 0
	for _, c in ipairs(KC.cells) do
		n += 1
		local mine = V._aeroConstants[c[1]]
		if mine == nil then mine = V._aeroDamageCells[c[1]] end
		if mine ~= c[2] then bad += 1 end
	end
	local wbad = 0
	for i, u in ipairs(KC.wake) do if V._aeroWake[i] ~= u then wbad += 1 end end
	check(string.format("embedded constants + aero damage-table cells = NR2003.exe bytes (%d cells, 64 wake rows, header, qword 0.447)", n),
		bad == 0 and wbad == 0 and KC.header[1] == V._aeroConstants[0x6f7228] and KC.header[2] == V._aeroConstants[0x6f722c]
		and KC.header[3] == 0x0002001e and KC.qword[1] == 0xe353f7cf and KC.qword[2] == 0x3fdc9ba5 and KC.e7d27c == 0,
		string.format("%d / %d mismatching", bad, wbad))
	V.reset()
	check("image holds the original aero cells (00410b50 flag 0071f904 = 1, half-wind cell pointers 0074e094..9c, Cup spec, damage tables after reset)",
		V.ri32(0x71f904) == 1 and r32(0x74e094) == UNITS.halfwindCells[1] and r32(0x74e098) == UNITS.halfwindCells[2]
		and r32(0x74e09c) == UNITS.halfwindCells[3] and r32(CAR + 0x58a) == 0x7238e0 and r32(0x71fa20) == 0x3c23d70a and r32(0x71fa3c) == 0xbbb43958,
		string.format("flag %d spec %x", V.ri32(0x71f904), r32(CAR + 0x58a)))
	check("post-build state has no air (rho e0b84c = 0, factors 0): the Stage 6/7/8 contract",
		r32(AIR + 12) == 0 and r32(CAR + F_DRAG) == 0 and r32(CAR + F_FRONT) == 0 and r32(CAR + F_REAR) == 0 and not V.sessionActive())
end

---------------------------------------------------------------------------------------------- units
do
	-- 005a3c00 session weather
	local st = stats()
	for n, r in ipairs(UNITS.weather) do
		V.startSession({temperatureF = r[1], conditions = r[2], night = r[3] == 1, windSpeedMph = r[4], windDirection = r[5], trackNorth = fb(r[6])})
		local got = {r32(AIR), r32(AIR + 4), r32(AIR + 8), r32(AIR + 12), r32(WEATHER + 0x108), r32(WEATHER + 0x10c), r32(WEATHER + 0x110), r32(WEATHER + 0x114)}
		local d = 0
		for k = 1, 8 do d = math.max(d, ulps(got[k], r[6 + k])) end
		add(st, d, string.format("row %d (T %d cond %d night %d mph %d dir %d)", n, r[1], r[2], r[3], r[4], r[5]))
	end
	V.endSession()
	check(string.format("005a3c00 session weather -> wind e0b840/44/48, density e0b84c, temperatures: %d vectors bit-exact", st.n),
		st.worst == 0, string.format("exact %d, worst %d ulp %s", st.exact, st.worst, st.at))
	-- 005a3ba0 density formula (+ 005a3be0 saturation pressure)
	st = stats()
	for n, r in ipairs(UNITS.density) do
		add(st, ulps(bf(V.airDensityOriginal(fb(r[1]), fb(r[2]), fb(r[3]))), r[4]), "row " .. n)
	end
	check(string.format("005a3ba0 humid-air density (T, P, RH) vs original: %d vectors <= 1 ulp", st.n), st.worst <= 1,
		string.format("exact %d/%d, worst %d ulp %s", st.exact, st.n, st.worst, st.at))
	-- 00561a80 half wind with/without the track-object projection
	st = stats()
	for n, r in ipairs(UNITS.halfwind) do
		w32(AIR, r[1]); w32(AIR + 4, r[2]); w32(AIR + 8, r[3])
		w32(TOBJ + 0x24, r[4]); w32(TOBJ + 0x28, r[5]); w32(TOBJ + 0x2c, r[6])
		w32(CAR + 0x5ae, r[7] == 1 and TOBJ or 0)
		callx(0x561a80)
		local d = 0
		for k = 1, 3 do d = math.max(d, ulps(r32(UNITS.halfwindCells[k]), r[7 + k])) end
		add(st, d, "row " .. n)
	end
	w32(CAR + 0x5ae, 0); w32(AIR, 0); w32(AIR + 4, 0); w32(AIR + 8, 0)
	check(string.format("00561a80 half wind (lifted) vs original: %d vectors <= 1 ulp", st.n), st.worst <= 1,
		string.format("exact %d/%d, worst %d ulp %s", st.exact, st.n, st.worst, st.at))
	-- 00561b70 aero force and moment (00410280, curves, 00410910 damage, 00410b50 stall)
	V.reset()
	st = stats()
	local stc = stats()
	local zlf, zrf = UNITS.aeroCells[1], UNITS.aeroCells[2]
	local cells = {AIR + 12, CAR + F_DRAG, CAR + F_FRONT, CAR + F_REAR, 0xc083c4, zlf, zrf, 0xc084c8, 0xc084cc,
		0xc055c0 + 4 * 0x3b, 0xc055c0 + 4 * 0x3d, 0xc055c0 + 4 * 0x20, 0xc055c0 + 4 * 0x21, 0x74e090, 0x7636e0, 0x7636e4, 0x71f904}
	local maxRel, relAt = 0, ""
	for n, r in ipairs(UNITS.aero) do
		for k, a in ipairs(cells) do w32(a, r[k]) end
		for k = 0, 5 do w32(BLOCK + 4 * k, OUT6 + 4 * k); w32(BLOCK + 24 + 4 * k, r[18 + k]) end
		for k = 0, 10 do w32(CAR + 0x14a3 + 4 * k, r[24 + k]) end
		callx(0x561b70, BLOCK)
		local d = 0
		for k = 0, 5 do
			local g, o = r32(OUT6 + 4 * k), r[35 + k]
			d = math.max(d, ulps(g, o))
			local e = relerr(fb(g), fb(o), 1e-2)
			if e > maxRel then maxRel = e; relAt = string.format("row %d out %d lua %.9g orig %.9g", n, k, fb(g), fb(o)) end
		end
		add(st, d, string.format("row %d", n))
		local dc = math.max(r32(0x74e090) == r[41] and 0 or 1e9, ulps(r32(0x7636e0), r[42]), ulps(r32(0x7636e4), r[43]))
		add(stc, dc, "row " .. n)
	end
	-- lifted x87 code is evaluated in IEEE double (80-bit extended in the original): rounding-level only
	check(string.format("00561b70 aero force + moment (lifted 00410280 path, incl. damage) vs original: %d vectors, rel <= 1e-5", st.n), maxRel <= 1e-5,
		string.format("bit-exact %d/%d, worst %d ulp, worst rel %.2e %s", st.exact, st.n, st.worst, maxRel, relAt))
	check("00561b70 side effects: 16-call counter 0074e090 exact, 00410b50 stall state 007636e0/e4 <= 2 ulp", stc.worst <= 2,
		string.format("exact %d/%d, worst %s %s", stc.exact, stc.n, tostring(stc.worst), stc.at))
	V.reset()
	-- 005b0230 wake (incl. 00567818)
	st = stats()
	for n, r in ipairs(UNITS.wake) do
		add(st, ulps(bf(V.fd(V.wakeOriginal(fb(r[1]), fb(r[2])))), r[3]), string.format("row %d (gap %.4g lat %.4g)", n, fb(r[1]), fb(r[2])))
	end
	check(string.format("005b0230 wake lookup vs original: %d vectors <= 1 ulp", st.n), st.worst <= 1,
		string.format("exact %d/%d, worst %d ulp %s", st.exact, st.n, st.worst, st.at))
	-- 005afd80 drafting on synthetic race-order rings
	st = stats()
	local touched = 0
	for n, r in ipairs(UNITS.draft) do
		w32(CAR + F_DRAG, r[4]); w32(CAR + F_FRONT, r[5]); w32(CAR + F_REAR, r[6])
		local cars, rev = {}, {}
		for _, c in ipairs(r[10]) do
			cars[#cars + 1] = {lapDistance = fb(c[1]), lateral = fb(c[2]), vx = fb(c[3]), vy = fb(c[4]), vz = fb(c[5]), wakeStrength = fb(c[6]), wakeLength = fb(c[7])}
		end
		for i = #cars, 1, -1 do rev[#rev + 1] = cars[i] end
		V.draftingOriginal({trackLength = fb(r[1]), lapDistance = fb(r[2]), lateral = fb(r[3]), ahead = cars, behind = rev})
		local d = math.max(ulps(r32(CAR + F_DRAG), r[7]), ulps(r32(CAR + F_FRONT), r[8]), ulps(r32(CAR + F_REAR), r[9]))
		if r[7] ~= 0x3f800000 or r[8] ~= r[5] or r[9] ~= r[6] then touched += 1 end
		add(st, d, string.format("row %d (%d cars)", n, #cars))
	end
	check(string.format("005afd80 drafting factors vs original: %d race rings (%d with an active wake) <= 1 ulp", st.n, touched), st.worst <= 1,
		string.format("exact %d/%d, worst %d ulp %s", st.exact, st.n, st.worst, st.at))
	V.reset()
	-- garage conversions of the aero setup items
	local tbad, sbad = 0, 0
	for _, r in ipairs(UNITS.tape) do
		if r[1] % 5 == 0 then V.setAeroSetup({grilleTape = r[1], spoiler = 65}); if r32(0xc055c0 + 4 * 0x3b) ~= r[2] then tbad += 1 end end
	end
	for _, r in ipairs(UNITS.spoiler) do
		if r[1] >= 45 and r[1] <= 70 then V.setAeroSetup({grilleTape = 0, spoiler = r[1]}); if r32(0xc055c0 + 4 * 0x3d) ~= r[2] then sbad += 1 end end
	end
	V.setAeroSetup({grilleTape = 7, spoiler = 99})
	local tapeR, spR = V.aeroSetup()
	check("garage aero items: grille tape (00423de0, 0..100 % step 5) and spoiler (004241d0, 45..70 deg) = original conversions; clamps",
		tbad == 0 and sbad == 0 and tapeR == 5 and spR == 70, string.format("%d / %d mismatches; 7 %% -> %d %%, 99 deg -> %d", tbad, sbad, tapeR, spR))
	V.reset()
	local tape0, sp0, tapeI, spI = V.aeroSetup()
	check("shipped Cup setup: grille tape 0 %, spoiler 65 deg (internal 20)", tape0 == 0 and sp0 == 65 and spI == 20, string.format("%d %% %d deg", tape0, sp0))
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
local function weatherOf(s)
	local w = s.weather or {}
	return {temperatureF = w.temperature, windSpeedMph = w.wind_mph, windDirection = w.wind_dir, conditions = w.conditions, night = w.night == 1}
end
-- straight-track drafting environment of the generator (Draft.update): lap distance = x, lateral = y,
-- phantom car `gap` m ahead with the player's own velocity, track length 5000 m
local function draftEnv(d)
	local x, y = rf32(0xbf6d40), rf32(0xbf6d48)
	local L = 5000
	local other = {lapDistance = (x + d[1]) % L, lateral = y + d[2], vx = rf32(0xbf6d44), vy = rf32(0xbf6d4c), vz = rf32(0xbf6d54),
		wakeStrength = 1, wakeLength = 1}
	return {trackLength = L, lapDistance = x % L, lateral = y, ahead = {other}, behind = {other}}
end
local function prepare(s)
	V.reset()
	V.endSession()
	V.setDraftEnvironment(nil); V.setTrackNormal(nil)
	V.startSession(weatherOf(s))
	if s.setup and (s.setup.spoiler or s.setup.grilleTape) then V.setAeroSetup({spoiler = s.setup.spoiler, grilleTape = s.setup.grilleTape}) end
	if #s.draft > 0 then V.setTrackNormal({0, 0, 1}) end
end
local function drive(s, k)
	if #s.draft > 0 and (k - 1) % 8 == 0 then V.setDraftEnvironment(draftEnv(s.draft)) end
	V.drive(controls(s, (k - 1) // 8), FLAT)
end
local wb = {}
local function observe(r, st)
	for i = 1, 13 do r[#r + 1] = st[i] end
	r[#r + 1] = st[14]; r[#r + 1] = st[20]; r[#r + 1] = st[26]; r[#r + 1] = st[28]; r[#r + 1] = st[35]
	for w = 0, 3 do V.wheelBrake(w, wb); r[#r + 1] = wb.fx; r[#r + 1] = wb.fy; r[#r + 1] = wb.fz end
	r[#r + 1] = V.gearIndex()
	local d, f, rr, a = V.aeroFactors()
	r[#r + 1] = d; r[#r + 1] = f; r[#r + 1] = rr; r[#r + 1] = a; r[#r + 1] = rf32(0x7636e4)
	return r
end
-- row layout (orig/pert/lua): [1] tick, [2..14] x vx y vy z vz qx qy qz qw wx wy wz, [15..19] travel LF RF raxle,
-- raxle roll, engine rate, [20..31] wheel fx fy fz x4, [32] gear, [33..35] factors, [36] airspeed, [37] stall

---------------------------------------------------------------------------------------------- sync
do
	local worstS, atS, worst8 = 0, "", 0
	local worstW, atW, facBad, gearBad = 0, "", 0, 0
	local aero = stats(); local aeroRel, aeroAt = 0, ""
	local count, slowN, slowPos, slowAt = 0, 0, 0, ""
	local worstH, atH = 0, ""
	for _, snap in ipairs(SYNC) do
		local s = scenarios[snap.scenario]
		prepare(s)
		for _, ch in ipairs(snap.chunks) do loadChunk(ch[1], ch[2]) end
		V.tick = snap.tick
		-- near-standstill sliding (|v| < 3 m/s with the car rotating): the original is discontinuous there
		-- (tyre low-speed anchor / static friction, as in Stage 8); compared on positions only
		local st0 = V.state()
		local slow = math.sqrt(st0[2] ^ 2 + st0[4] ^ 2 + st0[6] ^ 2) < 3 and math.abs(st0[13]) > 0.05
		-- telemetry: ORIGINAL 00561b70 at the identical machine state
		local a = V.aeroState()
		local got = {a.fx, a.fy, a.fz, a.mx, a.my, a.mz}
		local d = 0
		for k = 1, 6 do
			d = math.max(d, ulps(bf(got[k]), snap.aero[k]))
			local e = relerr(got[k], fb(snap.aero[k]), 1)
			if e > aeroRel then aeroRel = e; aeroAt = string.format("%s@%d out %d lua %.7g orig %.7g", snap.scenario, snap.tick, k, got[k], fb(snap.aero[k])) end
		end
		add(aero, d, snap.scenario .. "@" .. snap.tick)
		local st = table.create(45, 0)
		for k = snap.tick + 1, snap.tick + 16 do
			drive(s, k)
			for _, ref in ipairs(snap.after) do
				if ref[1] == k and slow then
					slowN += 1
					V.state(st)
					for _, i in ipairs({1, 3, 5}) do
						local d = math.abs(st[i] - ref[i + 1])
						if d > slowPos then slowPos = d; slowAt = string.format("%s@%d +%d", snap.scenario, snap.tick, k - snap.tick) end
					end
				elseif ref[1] == k then
					count += 1
					V.state(st)
					for i = 1, 45 do
						-- floor 2e-2: absolute 2e-5 for near-zero states. States 40..45 (C 39..44) are the 3 kg
						-- driver-head joint, the stiffest and most rounding-sensitive component (also the worst
						-- state of the Stage 8 sync): reported separately
						local e = relerr(st[i], ref[i + 1], 2e-2)
						if i >= 40 then
							if e > worstH then worstH = e; atH = string.format("%s@%d +%d state %d lua %.7g orig %.7g", snap.scenario, snap.tick, k - snap.tick, i - 1, st[i], ref[i + 1]) end
						else
							if k - snap.tick == 8 then worst8 = math.max(worst8, e) end
							if e > worstS then worstS = e; atS = string.format("%s@%d +%d state %d lua %.7g orig %.7g", snap.scenario, snap.tick, k - snap.tick, i - 1, st[i], ref[i + 1]) end
						end
					end
					local ob = observe({}, st)
					for i = 1, 12 do
						local e = math.abs(ob[18 + i] - ref[46 + i]) / math.max(math.abs(ref[46 + i]), 50)
						if e > worstW then worstW = e; atW = string.format("%s@%d +%d wheel %d f%d lua %.6g orig %.6g", snap.scenario, snap.tick, k - snap.tick, (i - 1) // 3, (i - 1) % 3, ob[18 + i], ref[46 + i]) end
					end
					if ob[31] ~= ref[59] then gearBad += 1 end
					for i = 1, 3 do if math.abs(ob[31 + i] - ref[59 + i]) > 1e-6 then facBad += 1 end end
				end
			end
		end
	end
	check(string.format("sync: %d original snapshots (aero on) x 2 frames, 39 chassis/suspension/wheel/drivetrain states vs original (rel <= 1e-3, floor 2e-2)", count // 2),
		count + slowN == 2 * #SYNC and worstS <= 1e-3, string.format("worst after 1 frame %.2e, after 2 frames %.2e %s", worst8, worstS, atS))
	check("sync: 6 driver-head joint states (3 kg head, C 39..44) vs original (rel <= 3e-3, floor 2e-2)", worstH <= 3e-3,
		string.format("worst %.2e %s", worstH, atH))
	check(string.format("sync: %d near-standstill sliding snapshots: chassis position within 1 mm of the original after 1-2 frames", slowN // 2),
		slowPos <= 1e-3, string.format("worst %.2e m %s", slowPos, slowAt))
	check("sync: per-wheel tyre Fx / Fy / Fz vs original (rel <= 2e-3, floor 50 N)", worstW <= 2e-3, string.format("worst %.2e %s", worstW, atW))
	check("sync: per-frame aero factors (005637e0 + 005afd80) and gear identical to original", facBad == 0 and gearBad == 0,
		string.format("factors %d, gear %d mismatches", facBad, gearBad))
	check(string.format("telemetry: aeroState = ORIGINAL 00561b70 at %d original snapshot states (rel <= 1e-6, floor 1 N)", aero.n), aeroRel <= 1e-6,
		string.format("bit-exact %d/%d, worst %d ulp, rel %.2e %s", aero.exact, aero.n, aero.worst, aeroRel, aeroAt))
end

---------------------------------------------------------------------------------------------- scenarios
local RUNS = {}
local function onsetSnapshot(s)
	local t0 = math.floor(s.perturb * 288 + 0.5)
	for _, snap in ipairs(SYNC) do
		if snap.scenario == s.name and snap.tick == t0 then return snap end
	end
	error("no onset snapshot for " .. s.name)
end
local function runScenario(s)
	local snap = onsetSnapshot(s)
	prepare(s)
	for _, ch in ipairs(snap.chunks) do loadChunk(ch[1], ch[2]) end
	V.tick = snap.tick
	local want = {}
	for _, r in ipairs(s.orig) do if r[1] > snap.tick then want[r[1]] = true end end
	local rows, st = {}, table.create(45, 0)
	for k = snap.tick + 1, s.ticks do
		drive(s, k)
		if want[k] then
			V.state(st)
			rows[#rows + 1] = observe({k}, st)
		end
	end
	return rows, snap.tick
end

local t0 = os.clock()
local nTicks = 0
for _, s in ipairs(SC) do
	local rows, onset = runScenario(s)
	RUNS[s.name] = rows
	nTicks += s.ticks - onset
	local base = 0
	for n, r in ipairs(s.orig) do if r[1] <= onset then base = n end end
	local function spread(n, i)
		local m, tk = 0, s.orig[base + n][1]
		for j = base + 1, #s.orig do
			if math.abs(s.orig[j][1] - tk) <= 36 then m = math.max(m, math.abs(s.pert[j][i] - s.orig[j][i])) end
		end
		return m
	end
	local bad, report = 0, ""
	for n, a in ipairs(rows) do
		local o = s.orig[base + n]
		assert(o[1] == a[1], "row alignment " .. s.name)
		for _, i in ipairs({2, 3, 4, 5, 6, 7}) do
			local floor = (i % 2 == 1) and 0.05 or 0.02
			local env = 3 * spread(n, i) + floor + 0.01 * math.abs(o[i])
			if math.abs(a[i] - o[i]) > env then
				bad += 1
				if report == "" then report = string.format("tick %d col %d lua %.5g orig %.5g pert %.5g env %.4g", a[1], i - 1, a[i], o[i], s.pert[base + n][i], env) end
			end
		end
	end
	local la, lo = rows[#rows], s.orig[#s.orig]
	local function spd(r) return math.sqrt(r[3] ^ 2 + r[5] ^ 2 + r[7] ^ 2) end
	check(string.format("%s: chassis x/y/z + velocities inside the original's envelope from its %.1f s snapshot (%d samples)", s.name, s.perturb, #rows), bad == 0,
		bad > 0 and report or string.format("final v lua %.3f orig %.3f | z lua %.4f orig %.4f | factors lua %.3f/%.3f/%.3f orig %.3f/%.3f/%.3f",
			spd(la), spd(lo), la[6], lo[6], la[33], la[34], la[35], lo[33], lo[34], lo[35]))
end
print(string.format("      scenarios: %d ticks in %.2f s (%.0f ticks/s)", nTicks, os.clock() - t0, nTicks / (os.clock() - t0)))

---------------------------------------------------------------------------------------------- physics
-- behaviour checks; each one is asserted on the ORIGINAL rows as well (`both`), so a check can only
-- pass if it is what NR2003 itself does.
local function rowAt(rows, tick) for _, r in ipairs(rows) do if r[1] >= tick then return r end end return rows[#rows] end
local function speed(r) return math.sqrt(r[3] * r[3] + r[5] * r[5] + r[7] * r[7]) end
local function fzSum(r) return r[22] + r[25] + r[28] + r[31] end
local function both(fn) return fn(RUNS) and fn(setmetatable({}, {__index = function(_, k) return scenarios[k].orig end})) end

-- reference without session air: the same launch with the Stage 6/7/8 post-build state (Luau only)
local NOAIR = {}
do
	local s = scenarios.launch
	V.reset(); V.endSession(); V.setDraftEnvironment(nil); V.setTrackNormal(nil)
	local st = table.create(45, 0)
	for k = 1, s.ticks do
		V.drive(controls(s, (k - 1) // 8), FLAT)
		if k % 288 == 0 then V.state(st); NOAIR[#NOAIR + 1] = observe({k}, st) end
	end
end
check("top speed: session air lowers the equilibrium (launch 35-40 s) below the post-build no-air car, and lowers the chassis (downforce)", both(function(R)
	local a, b = rowAt(R.launch, 38 * 288), rowAt(NOAIR, 38 * 288)
	return speed(a) < speed(b) - 0.3 and a[6] < b[6] - 0.005
end), string.format("v %.2f vs %.2f m/s, z %.4f vs %.4f m", speed(rowAt(RUNS.launch, 38 * 288)), speed(rowAt(NOAIR, 38 * 288)), rowAt(RUNS.launch, 38 * 288)[6], rowAt(NOAIR, 38 * 288)[6]))
check("acceleration at speed: 10->15 s gain smaller with air than without (drag)", both(function(R)
	return speed(rowAt(R.launch, 15 * 288)) - speed(rowAt(R.launch, 10 * 288)) < speed(rowAt(NOAIR, 15 * 288)) - speed(rowAt(NOAIR, 10 * 288))
end))
check("downforce loads the tyres: total Fz at ~74 m/s exceeds the at-rest total by > 2000 N", both(function(R)
	return fzSum(rowAt(R.launch, 38 * 288)) > fzSum(rowAt(R.creep, 2304)) + 2000
end), string.format("%.0f vs %.0f N", fzSum(rowAt(RUNS.launch, 38 * 288)), fzSum(rowAt(RUNS.creep, 2304))))
check("high-speed braking: first second from ~74 m/s decelerates harder than the 4th second (drag + downforce fall with speed)", both(function(R)
	local a, b, c, d = rowAt(R.hsbrake, 20 * 288), rowAt(R.hsbrake, 21 * 288), rowAt(R.hsbrake, 23 * 288), rowAt(R.hsbrake, 24 * 288)
	return speed(a) > 70 and (speed(a) - speed(b)) > (speed(c) - speed(d))
end), string.format("%.2f vs %.2f m/s", speed(rowAt(RUNS.hsbrake, 20 * 288)) - speed(rowAt(RUNS.hsbrake, 21 * 288)), speed(rowAt(RUNS.hsbrake, 23 * 288)) - speed(rowAt(RUNS.hsbrake, 24 * 288))))
check("high-speed cornering: lateral displacement develops, car stays planted (no wheel unloads)", both(function(R)
	local r = rowAt(R.hscorner, 28 * 288)
	return math.abs(r[4]) > 20 and r[22] > 500 and r[25] > 500 and r[28] > 500 and r[31] > 500
end), string.format("y %.1f m", rowAt(RUNS.hscorner, 28 * 288)[4]))
check("weather: denser air is slower at 20 s (cold 40 F < default < hot 110 F; cloudy < default)", both(function(R)
	local c, d, h, cl = speed(rowAt(R.cold, 20 * 288)), speed(rowAt(R.launch, 20 * 288)), speed(rowAt(R.hot, 20 * 288)), speed(rowAt(R.cloudy, 20 * 288))
	return c < d and d < h and cl < d
end), string.format("cold %.3f default %.3f hot %.3f cloudy %.3f m/s", speed(rowAt(RUNS.cold, 20 * 288)), speed(rowAt(RUNS.launch, 20 * 288)), speed(rowAt(RUNS.hot, 20 * 288)), speed(rowAt(RUNS.cloudy, 20 * 288))))
-- aero force/moment at an original snapshot: ORIGINAL 00561b70 (fixture) and NR2003CupAero.aeroState
local function aeroAt(name, tick)
	for _, snap in ipairs(SYNC) do
		if snap.scenario == name and snap.tick == tick then
			prepare(scenarios[name])
			for _, ch in ipairs(snap.chunks) do loadChunk(ch[1], ch[2]) end
			V.tick = snap.tick
			local a = V.aeroState()
			local o = {}
			for k = 1, 6 do o[k] = fb(snap.aero[k]) end
			return o, {a.fx, a.fy, a.fz, a.mx, a.my, a.mz}
		end
	end
	error("no snapshot " .. name .. "@" .. tick)
end
do
	local co, cl = aeroAt("crosswind", 20 * 288)
	local lo, ll = aeroAt("launch", 20 * 288)
	check("wind: headwind slower than tailwind at 20 s; 30 mph crosswind (toward +Y) adds > 500 N of aero side force toward +Y (original and port)",
		both(function(R) return speed(rowAt(R.headwind, 20 * 288)) < speed(rowAt(R.tailwind, 20 * 288)) end)
		and co[2] > lo[2] + 500 and cl[2] > ll[2] + 500,
		string.format("head %.2f tail %.2f m/s | Fy cross %.0f (lua %.0f) vs still %.0f N", speed(rowAt(RUNS.headwind, 20 * 288)), speed(rowAt(RUNS.tailwind, 20 * 288)), co[2], cl[2], lo[2]))
end
check("rear spoiler (from the same 10 s state): 70 deg sits lower, compresses the rear axle more and is slower at 20 s than 45 deg", both(function(R)
	local a, b = rowAt(R.spoiler70, 20 * 288), rowAt(R.spoiler45, 20 * 288)
	return a[17] > b[17] and a[6] < b[6] and speed(a) < speed(b)
end), string.format("rear travel %.4f vs %.4f m, z %.4f vs %.4f, v %.3f vs %.3f", rowAt(RUNS.spoiler70, 20 * 288)[17], rowAt(RUNS.spoiler45, 20 * 288)[17],
	rowAt(RUNS.spoiler70, 20 * 288)[6], rowAt(RUNS.spoiler45, 20 * 288)[6], speed(rowAt(RUNS.spoiler70, 20 * 288)), speed(rowAt(RUNS.spoiler45, 20 * 288))))
check("grille tape 100 % (from the same 10 s state): less drag (faster at 20 s), more front tyre load and a lower chassis than 0 %", both(function(R)
	local a, b = rowAt(R.tape100, 20 * 288), rowAt(R.launch, 20 * 288)
	return speed(a) > speed(b) and (a[22] + a[25]) > (b[22] + b[25]) and a[6] < b[6]
end), string.format("v %.3f vs %.3f, front Fz %.0f vs %.0f", speed(rowAt(RUNS.tape100, 20 * 288)), speed(rowAt(RUNS.launch, 20 * 288)), rowAt(RUNS.tape100, 20 * 288)[22] + rowAt(RUNS.tape100, 20 * 288)[25], rowAt(RUNS.launch, 20 * 288)[22] + rowAt(RUNS.launch, 20 * 288)[25]))
check("grille tape 100 % from the garage: the original's full-throttle launch departs (spin near 20 m/s) and the port follows it", both(function(R)
	return speed(rowAt(R.tape100build, 20 * 288)) < 10
end), string.format("v at 20 s lua %.2f orig %.2f m/s", speed(rowAt(RUNS.tape100build, 20 * 288)), speed(rowAt(scenarios.tape100build.orig, 20 * 288))))
check("drafting 8 m behind: drag factor < 1 (005afd80) and faster than the single car at 15 s", both(function(R)
	local a, b = rowAt(R.draft, 15 * 288), rowAt(R.launch, 15 * 288)
	return a[33] < 0.95 and speed(a) > speed(b)
end), string.format("factors %.3f/%.3f/%.3f", rowAt(RUNS.draft, 15 * 288)[33], rowAt(RUNS.draft, 15 * 288)[34], rowAt(RUNS.draft, 15 * 288)[35]))
check("drafting offset 2 m: weaker wake than straight behind", both(function(R)
	return rowAt(R.draftside, 20 * 288)[33] > rowAt(R.draft, 20 * 288)[33]
end))
check("single car (no race ring): all three factors exactly 1.0 every frame", both(function(R)
	for _, r in ipairs(R.launch) do if r[33] ~= 1 or r[34] ~= 1 or r[35] ~= 1 then return false end end
	return true
end))
do
	-- spin: 00410b50 stall state; whatever the original does (rise or stay 0), the port must do the same
	local function anyStall(rows) for _, r in ipairs(rows) do if r[37] > 0 then return true end end return false end
	check("spin at speed: 00410b50 stall state behaves as the original (rises > 0 only if the original's does)",
		anyStall(RUNS.spin) == anyStall(scenarios.spin.orig), string.format("lua %s orig %s", tostring(anyStall(RUNS.spin)), tostring(anyStall(scenarios.spin.orig))))
end
do
	-- creep (Stage 8 low-speed scenario: creep, stop, auto-hold): the aero is negligible there. The
	-- launch from rest itself is discontinuous (tyre low-speed anchor, clutch take-up: even a 0.06 N
	-- force moves it), so the check is on the force, at the original's own snapshots; the trajectory
	-- with session air is checked against the original with session air (creep scenario above).
	local worst = 0
	for _, t in ipairs({math.floor(2.5 * 288 + 0.5), 5 * 288}) do
		local o, l = aeroAt("creep", t)
		for k = 1, 3 do worst = math.max(worst, math.abs(o[k]), math.abs(l[k])) end
	end
	check("low speed (Stage 8 creep/stop/hold): |aero force| < 0.1 % of the car weight (10.5 N) at the original snapshots (original and port)", worst < 10.5,
		string.format("max |F| %.3g N", worst))
end

---------------------------------------------------------------------------------------------- API
do
	V.reset(); V.endSession(); V.setDraftEnvironment(nil); V.setTrackNormal(nil)
	local w = V.startSession(nil)
	check("startSession() defaults (70 F, no wind, conditions 0, daytime): rho 1.08119202 kg/m^3, air 49.11 C for the density",
		r32(AIR + 12) == bf(1.08119202) and math.abs(w.densityTemperatureC - 49.1111) < 1e-3 and r32(AIR) == 0x80000000 and r32(AIR + 4) == 0,
		string.format("rho %.9g", rf32(AIR + 12)))
	V.reset()
	check("reset keeps the session (air re-applied) and the next frame sets factors 1.0", r32(AIR + 12) == bf(1.08119202))
	V.drive({throttle = 0}, FLAT)
	local d, f, r = V.aeroFactors()
	check("first frame of a session: factors = 1.0 before the first physics tick (005637e0 order)", d == 1 and f == 1 and r == 1)
	-- aeroState is side-effect free
	local s = scenarios.launch
	for k = 2, 3000 do V.drive(controls(s, (k - 1) // 8), FLAT) end
	local cpA = V.checkpoint()
	local t = V.aeroState()
	local cpB = V.checkpoint()
	local same = buffer.len(cpA.memory) == buffer.len(cpB.memory)
	local diffs = 0
	for o = 0, buffer.len(cpA.memory) - 4, 4 do
		if buffer.readu32(cpA.memory, o) ~= buffer.readu32(cpB.memory, o) then
			local a = BASE + o
			-- the telemetry blocks themselves and the export scratch are host-only cells
			if not (a >= HOST + 0x140 and a < HOST + 0x200) and not (a >= BLOCK and a < TOBJ) and a < 0xf7e000 then diffs += 1 end
		end
	end
	check("aeroState() leaves every simulation cell unchanged (call counter / stall state restored)", same and diffs == 0, diffs .. " cells changed")
	check("aeroState(): drag, downforce, q, ride height plausible at speed", t.drag > 300 and t.downforce > 500 and t.q > 300 and t.rideHeightFront > 0.05 and t.rideHeightFront < 0.3,
		string.format("v %.1f q %.0f Pa drag %.0f N down %.0f N (front %.0f rear %.0f) My %.0f rh %.4f", t.airspeedBody, t.q, t.drag, t.downforce, t.downforceFront, t.downforceRear, t.my, t.rideHeightFront))
	-- checkpoint / restore with session + drafting
	V.setTrackNormal({0, 0, 1})
	local dd = {8, 0}
	for k = 3001, 3200 do if (k - 1) % 8 == 0 then V.setDraftEnvironment(draftEnv(dd)) end; V.drive(controls(s, (k - 1) // 8), FLAT) end
	local cp = V.checkpoint()
	for k = 3201, 3600 do if (k - 1) % 8 == 0 then V.setDraftEnvironment(draftEnv(dd)) end; V.drive(controls(s, (k - 1) // 8), FLAT) end
	local a = V.state()
	V.restore(cp)
	for k = 3201, 3600 do if (k - 1) % 8 == 0 then V.setDraftEnvironment(draftEnv(dd)) end; V.drive(controls(s, (k - 1) // 8), FLAT) end
	local b = V.state()
	local eq = true
	for i = 1, 45 do if a[i] ~= b[i] then eq = false end end
	check("checkpoint/restore bit-identical with session air + drafting", eq)
	V.endSession(); V.setDraftEnvironment(nil); V.setTrackNormal(nil)
	check("endSession() returns to the post-build state (rho 0, factors 0, no track object)", r32(AIR + 12) == 0 and r32(CAR + F_DRAG) == 0 and r32(CAR + 0x5ae) == 0)
	local ok = pcall(V.setDraftEnvironment, {ahead = {{lapDistance = 1}}})
	check("draft environment with cars requires trackLength > 0 (00516daa would not terminate)", not ok)
	local ft, esp = V._fpu()
	check("x86/x87 stacks balanced", ft == 0 and esp == 0xf7f000, string.format("FT=%d ESP=%x", ft, esp))
end

print(string.format("\n%d passed, %d failed", passed, failed))
if failed > 0 then error("stage 9 tests failed") end
