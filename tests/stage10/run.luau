-- Stage 10 setup -> runtime tests (Luau CLI):  luau -O2 --codegen tests/stage10/run.luau
-- Golden values come from the ORIGINAL NR2003.exe code executed in Unicorn (fixtures/*.lua,
-- recovery/stage10/gen_fixtures10.py): the original car build of each garage setup (natural structure when
-- the setup's own emitter outcome equals the default's, else the generic structure) and the original
-- runtime with that setup. The setup conversions (garage layer) are tested by tests/stage10/run_setup.luau.
local Vehicle = require("../../core/NR2003CupVehicle")
local BUILD = require("./fixtures/build_fixture")
local DYN = require("./fixtures/dyn_fixture")
local ITEMS = require("./fixtures/items_fixture")
local DRIVE = require("../stage67/fixtures/drive_fixture")

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
check("load core + Stage 10 modules (setup, build code/data, generic callbacks, garage)", V.applySetup ~= nil and V.Setup ~= nil,
	string.format("%.3f s, footprint %d bytes", os.clock() - t0, V.Build.footprintBytes))
local Setup = V.Setup
local M, BASE = V.memory(), V.base
local PRISTINE = V._pristine()
local ru, rf = buffer.readu32, buffer.readf32

---------------------------------------------------------------------------------------------------
-- helpers
---------------------------------------------------------------------------------------------------
local B64 = {}
do
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	for i = 1, 64 do B64[string.byte(chars, i)] = i - 1 end
end
local function b64decode(s)
	local out, o = buffer.create(#s * 3 // 4), 0
	for i = 1, #s, 4 do
		local a, b, c, d = string.byte(s, i, i + 3)
		local x = B64[a] * 262144 + B64[b] * 4096 + (c ~= 61 and B64[c] or 0) * 64 + (d ~= 61 and B64[d] or 0)
		buffer.writeu8(out, o, bit32.rshift(x, 16)); o += 1
		if c ~= 61 then buffer.writeu8(out, o, bit32.band(bit32.rshift(x, 8), 0xff)); o += 1 end
		if d ~= 61 then buffer.writeu8(out, o, bit32.band(x, 0xff)); o += 1 end
	end
	return out, o
end
local W = BUILD.windows
-- cells: aligned dwords outside the tyre objects + the tyre fields at their own addresses (objects of 0xa39 bytes
-- from bf3a20: wheels 1..3 have unaligned float fields)
local TY_LO, TY_STRIDE = 0xbf3a20 - BASE, 0xa39
local TY_HI = TY_LO + 4 * TY_STRIDE
local WBYTES, WIN = 0, {}
for _, w in ipairs(W) do WIN[#WIN + 1] = {w[1], w[2], WBYTES}; WBYTES += w[2] end
local CELLS, CPOS = {}, {}
for _, w in ipairs(WIN) do
	for j = 0, w[2] - 4, 4 do
		local off = w[1] + j
		if off + 4 <= TY_LO or off >= TY_HI then CELLS[#CELLS + 1] = {off, w[3] + j}; CPOS[off] = w[3] + j end
	end
end
local function posOf(off)
	for _, w in ipairs(WIN) do if off >= w[1] and off + 4 <= w[1] + w[2] then return w[3] + off - w[1] end end
	error("cell outside the windows")
end
for w = 0, 3 do
	for k = 0, TY_STRIDE - 4, 4 do
		local off = TY_LO + TY_STRIDE * w + k
		local p = posOf(off)
		CELLS[#CELLS + 1] = {off, p}; CPOS[off] = p
	end
end
local function windows(src)
	local b = buffer.create(WBYTES)
	for _, w in ipairs(WIN) do buffer.copy(b, w[3], src, w[1], w[2]) end
	return b
end
-- cells computed in IEEE double by the port: the JIT variable cells and the other cells written by the build
-- after the code generation (generated solve pass 005b3090 through the translated JIT, 0057dcd0(1), 0054d610 x4)
local VAR_LO, VAR_HI = 0xebbf60 - BASE, 0xebf610 - BASE
local SOLVE = {}
for _, off in ipairs(BUILD.solve) do SOLVE[off] = true end
local function isVar(off) return (off >= VAR_LO and off < VAR_HI) or SOLVE[off] == true end
local function mul32(a, b) -- exact (a * b) mod 2^32 for b < 2^25
	local al, ah = a % 65536, a // 65536
	return (al * b + ((ah * b) % 65536) * 65536) % 4294967296
end
local function fnv(buf)
	local h = 2166136261
	for _, c in ipairs(CELLS) do
		if not isVar(c[1]) then h = mul32(bit32.bxor(h, ru(buf, c[2])), 16777619) end
	end
	return h
end
local function relerr(a, b) return math.abs(a - b) / math.max(math.abs(a), math.abs(b), 1e-3) end
-- cells computed in double: relative 1e-3 or absolute 2e-5. Observed: <= 6.7e-5 relative for the solve-pass
-- outputs, except the cell ebc390 (pointed by c083f8) whose build value toggles between two levels (0.0945872 /
-- 0.0946477, a near-tie of the solve pass in double vs x87) in 4 of the 184 item builds: 6.4e-4
local VAR_TOL, VAR_ABS = 1e-3, 2e-5
local function f32(u) local s = buffer.create(4); buffer.writeu32(s, 0, u); return buffer.readf32(s, 0) end
-- compare two window buffers cell by cell: exact for the cells the build computes exactly, relative error for the
-- cells computed in double
local function compareWindows(want, got)
	local exactBad, firstBad, varBad, varWorst, varAt = 0, nil, 0, 0, nil
	for _, c in ipairs(CELLS) do
		local off, p = c[1], c[2]
		local a, b = ru(want, p), ru(got, p)
		if a ~= b then
			if isVar(off) then
				local x, y = f32(a), f32(b)
				local e = relerr(x, y)
				if math.abs(x - y) <= VAR_ABS then e = 0 end
				if e ~= e then e = math.huge end
				if e > varWorst then varWorst = e; varAt = off end
				varBad += 1
			else
				exactBad += 1
				firstBad = firstBad or string.format("%08x: %08x vs %08x", off + BASE, a, b)
			end
		end
	end
	return exactBad, firstBad, varBad, varWorst, varAt
end
local IMAGE = windows(PRISTINE)
local GDEF = b64decode(BUILD.genericDefault)
local IMAGE_HASH = fnv(IMAGE)
local function setupWith(items)
	local s = Setup.cupGarageDefault()
	for i, raw in pairs(items) do s[i] = raw end
	return s
end
local function expectedFor(fx)
	local base = fx.structure == "natural" and IMAGE or GDEF
	local b = buffer.create(WBYTES); buffer.copy(b, 0, base, 0, WBYTES)
	for _, d in ipairs(fx.delta or fx.var) do buffer.writeu32(b, CPOS[d[1]], d[2]) end
	return b
end
local SOLVE_COUNT = #BUILD.solve

---------------------------------------------------------------------------------------------------
-- 1. shipped image = ORIGINAL build of the default garage setup
---------------------------------------------------------------------------------------------------
check("shipped image is the default setup build (structure 'image')", V.setupStructure() == "image" and V.setupReport().structure == "image")
do
	local s = V.setup()
	local okd = true
	for i = 0, 70 do
		-- 0x25 (RF ride height, 00425a30) and 0x41/0x42 (stagger, 00424860) are recomputed by 00559820
		if i ~= 37 and i ~= 65 and i ~= 66 and s[i] ~= Setup.cupGarageDefault()[i] then okd = false end
	end
	check("V.setup() of the image = Cup default garage items (00559950; 0x25/0x41/0x42 recomputed by 00559820)", okd)
end

---------------------------------------------------------------------------------------------------
-- 2. named setups: ORIGINAL car build reproduced in Luau (image windows)
---------------------------------------------------------------------------------------------------
local applyTimes = {}
for _, fx in ipairs(BUILD.setups) do
	if fx.name ~= "default" then
		local t = os.clock()
		local ok, rep = V.applySetup(setupWith(fx.items))
		applyTimes[#applyTimes + 1] = os.clock() - t
		local got = windows(PRISTINE)
		local exactBad, firstBad, varBad, varWorst = compareWindows(expectedFor(fx), got)
		check(string.format("build %-18s structure %-7s report = original (pool %d, literals %08x, code end %08x)", fx.name, fx.structure, fx.pool, fx.litTop, fx.codeEnd),
			ok and rep.structure == fx.structure and rep.pool == fx.pool and rep.litTop == fx.litTop and rep.codeEnd == fx.codeEnd,
			string.format("%s %.2f s violations %d (%s)", tostring(ok), os.clock() - t, rep.violations, tostring(rep.firstViolation)))
		check(string.format("build %-18s image windows = original build (exact outside the %d solve-pass cells)", fx.name, SOLVE_COUNT),
			exactBad == 0 and varWorst <= VAR_TOL,
			string.format("%d delta dwords, %d exact mismatches %s, %d variable cells differ (worst rel %.1e)", #fx.delta, exactBad, firstBad or "", varBad, varWorst))
	end
end

---------------------------------------------------------------------------------------------------
-- 3. default setup: image restore is exact; a Luau rebuild differs only in the JIT variable cells
---------------------------------------------------------------------------------------------------
do
	local ok, rep = V.applySetup(Setup.cupGarageDefault(), {rebuild = true})
	local exactBad, firstBad, varBad, varWorst = compareWindows(IMAGE, windows(PRISTINE))
	check("default rebuilt in Luau (natural structure) = shipped image (exact outside the solve-pass cells)", ok and rep.structure == "natural" and exactBad == 0 and varWorst <= VAR_TOL,
		string.format("%d exact mismatches %s, %d variable cells differ (worst rel %.1e), %.2f s", exactBad, firstBad or "", varBad, varWorst, rep.seconds))
	local applied = V.setup()
	local ok2 = V.applySetup(applied, {rebuild = true})
	local same = true
	local A = windows(PRISTINE)
	local ok3 = V.applySetup(Setup.cupGarageDefault(), {rebuild = true})
	local B = windows(PRISTINE)
	for p = 0, WBYTES - 4, 4 do if ru(A, p) ~= ru(B, p) then same = false end end
	check("applied setup (c055c0 after 00559820) rebuilds identically to the garage setup; rebuild deterministic", ok2 and ok3 and same)
	local ok4, rep4 = V.applySetup(Setup.cupGarageDefault())
	local exact = fnv(windows(PRISTINE)) == IMAGE_HASH
	local all = true
	local P2 = windows(PRISTINE)
	for p = 0, WBYTES - 4, 4 do if ru(P2, p) ~= ru(IMAGE, p) then all = false end end
	check("applySetup(default) restores the shipped image bit for bit (structure 'image')", ok4 and rep4.structure == "image" and exact and all)
end

---------------------------------------------------------------------------------------------------
-- 4. every adjustable item at min / max / default +-1 step: build = original (hash + variable cells)
---------------------------------------------------------------------------------------------------
do
	local bad, report, n, nat, gen, worst = 0, "", 0, 0, 0, 0
	local t = os.clock()
	for _, fx in ipairs(ITEMS) do
		local ok, rep = V.applySetup(setupWith({[fx.item] = fx.raw}))
		n += 1
		if rep.structure == "natural" then nat += 1 else gen += 1 end
		local got = windows(PRISTINE)
		local h = fnv(got)
		local _, _, _, varWorst = compareWindows(expectedFor(fx), got)
		worst = math.max(worst, varWorst)
		if not (ok and rep.structure == fx.structure and rep.pool == fx.pool and rep.litTop == fx.litTop and h == fx.hash and varWorst <= VAR_TOL) then
			bad += 1
			if report == "" then
				report = string.format("item %d (%s) %s: ok %s structure %s/%s hash %s var %.1e", fx.item, Setup.ITEM[fx.item].name, fx.tag,
					tostring(ok), tostring(rep.structure), fx.structure, tostring(h == fx.hash), varWorst)
			end
		end
	end
	check("per item min/max/+-1 step: structure, constant pool, literals, image hash, variable cells = original",
		bad == 0, bad > 0 and report or string.format("%d setups (%d natural, %d generic), worst variable cell rel %.1e, %.1f s", n, nat, gen, worst, os.clock() - t))
end

---------------------------------------------------------------------------------------------------
-- 5. dynamics: Luau core with the applied setup vs the ORIGINAL runtime with that setup
---------------------------------------------------------------------------------------------------
local FLAT = {}
for i = 1, 4 do FLAT[i] = {0, 0, 1, 0, 0, 0, 0, 1, 1} end
local function controls(frame)
	local c = DRIVE.controls[frame + 1]
	return {throttle = c[1], brake = c[2], clutch = c[3], steer = c[4], shiftUp = c[5], shiftDown = c[6]}
end
local FINAL = {}
for _, fx in ipairs(DYN.setups) do
	local ok, rep = V.applySetup(setupWith(fx.items))
	local want = {}
	for _, r in ipairs(fx.orig) do want[r[1]] = true end
	local rows, s = {}, table.create(45, 0)
	local t = os.clock()
	for k = 1, DYN.ticks do
		V.drive(controls((k - 1) // 8), FLAT)
		if want[k] then
			V.state(s)
			local r = {k}
			for i = 1, 45 do r[i + 1] = s[i] end
			r[47] = V.gearIndex()
			rows[#rows + 1] = r
		end
	end
	local generic = rep.structure == "generic"
	local ref = generic and fx.gen or fx.orig
	-- (a) first ticks: rounding level vs the original code of the same structure
	local worst = 0
	for n = 1, DYN.first do
		for i = 2, 46 do worst = math.max(worst, relerr(rows[n][i], ref[n][i])) end
	end
	check(string.format("dyn %-18s %-7s ticks 1-%d = original (rel <= 2e-5)", fx.name, rep.structure, DYN.first), ok and worst <= 2e-5, string.format("worst %.2e", worst))
	-- (b) chassis x/y/z + velocities within the original's sensitivity envelope: two rounding twins of the
	-- original run (+1 ulp start, and the generic-structure build = float32 rounding at the fold sites), spread
	-- taken over the neighbouring samples (+-72 ticks), x3 + 2 cm (/s) + 1 %
	local bad, report = 0, ""
	for n = 1, #rows do
		local a, o = rows[n], fx.orig[n]
		for i = 1, 6 do
			local spread = 0
			for m = math.max(1, n - 1), math.min(#rows, n + 1) do
				local om = fx.orig[m]
				spread = math.max(spread, math.abs(fx.pert[m][i + 1] - om[i + 1]), math.abs(fx.gen[m][i + 1] - om[i + 1]))
			end
			local env = 3 * spread + 0.02 + 0.01 * math.abs(o[i + 1])
			if math.abs(a[i + 1] - o[i + 1]) > env then
				bad += 1
				if report == "" then report = string.format("tick %d state %d lua %.5g orig %.5g pert %.5g gen %.5g", a[1], i - 1, a[i + 1], o[i + 1], fx.pert[n][i + 1], fx.gen[n][i + 1]) end
			end
		end
	end
	local last, ol = rows[#rows], fx.orig[#fx.orig]
	check(string.format("dyn %-18s chassis x/y/z + velocities within the original envelope", fx.name), bad == 0,
		bad > 0 and report or string.format("final x lua %.3f orig %.3f pert %.3f gen %.3f (%.2f s)", last[2], ol[2], fx.pert[#fx.pert][2], fx.gen[#fx.gen][2], os.clock() - t))
	local mism = 0
	for n = 1, #rows do if rows[n][47] ~= ref[n][47] then mism += 1 end end
	check(string.format("dyn %-18s gear sequence = original", fx.name), mism == 0, mism .. " mismatches")
	FINAL[fx.name] = {lua = rows, fx = fx}
end
-- physics response to the setup: change of the 8 s run vs the default setup (x travelled, final speed, chassis
-- height and pitch-related z at the settled sample) has the original's sign and size (within the twins' spread)
do
	local D = FINAL.default
	local bad, report, n = 0, "", 0
	local probes = {{"x", 2, #D.lua}, {"vx", 3, #D.lua}, {"z settled", 6, DYN.first + 3}}
	for name, F in pairs(FINAL) do
		if name ~= "default" then
			for _, pr in ipairs(probes) do
				local col, k = pr[2], pr[3]
				local dl = F.lua[k][col] - D.lua[k][col]
				local dof = F.fx.orig[k][col] - D.fx.orig[k][col]
				local spread = math.abs(F.fx.pert[k][col] - F.fx.orig[k][col]) + math.abs(F.fx.gen[k][col] - F.fx.orig[k][col])
					+ math.abs(D.fx.pert[k][col] - D.fx.orig[k][col]) + math.abs(D.fx.gen[k][col] - D.fx.orig[k][col])
				local tol = 3 * spread + 0.02 + 0.01 * math.abs(dof)
				n += 1
				if math.abs(dl - dof) > tol then
					bad += 1
					if report == "" then report = string.format("%s %s: lua %+.4f orig %+.4f (tol %.4f)", name, pr[1], dl, dof, tol) end
				end
			end
		end
	end
	check("setup response (x, vx after 8 s; settled chassis z) vs default = original response", bad == 0, bad > 0 and report or (n .. " probes"))
end

---------------------------------------------------------------------------------------------------
-- 6. Stage 8 / Stage 9 setters write the same cells as the ORIGINAL build path
---------------------------------------------------------------------------------------------------
do
	local KB = {}
	for w = 0, 3 do KB[w] = ru(M, 0xc0850c + 4 * w - BASE) end
	for _, pct in ipairs({50, 61, 74, 90}) do
		local s = Setup.cupGarageDefault()
		Setup.set(s, "brakeBias", pct)
		local ok = V.applySetup(s)
		local viaBuild = {}
		for w = 0, 3 do viaBuild[w] = ru(M, ru(M, 0xc0850c + 4 * w - BASE) - BASE) end
		V.applySetup(Setup.cupGarageDefault())
		V.setBrakeBias(pct)
		local same = ok
		for w = 0, 3 do if ru(M, KB[w] - BASE) ~= viaBuild[w] then same = false end end
		check(string.format("brake bias %d%%: Stage 8 setBrakeBias cells = ORIGINAL build cells (0055e9b0)", pct), same)
	end
	for _, tc in ipairs({{0, 45}, {35, 52}, {100, 70}}) do
		local s = Setup.cupGarageDefault()
		Setup.set(s, "grilleTape", tc[1]); Setup.set(s, "spoilerAngle", tc[2])
		local ok = V.applySetup(s)
		local a59, a61 = ru(M, 0xc055c0 + 4 * 59 - BASE), ru(M, 0xc055c0 + 4 * 61 - BASE)
		V.applySetup(Setup.cupGarageDefault())
		V.setAeroSetup({grilleTape = tc[1], spoiler = tc[2]})
		local b59, b61 = ru(M, 0xc055c0 + 4 * 59 - BASE), ru(M, 0xc055c0 + 4 * 61 - BASE)
		check(string.format("tape %d%% spoiler %d: Stage 9 setAeroSetup items = garage items through the build", tc[1], tc[2]), ok and a59 == b59 and a61 == b61)
	end
	V.applySetup(Setup.cupGarageDefault())
end

---------------------------------------------------------------------------------------------------
-- 7. invalid input: nothing committed, previous setup kept
---------------------------------------------------------------------------------------------------
do
	local s = Setup.cupGarageDefault()
	Setup.set(s, "springLF", 1700)
	local ok1 = V.applySetup(s)
	local before = windows(PRISTINE)
	local structureBefore = V.setupStructure()
	local bad = Setup.copy(s)
	bad[20] = 0x7fc00000 -- NaN spring rate (not producible by the garage functions)
	local ok, rep = V.applySetup(bad)
	local after = windows(PRISTINE)
	local same = true
	for p = 0, WBYTES - 4, 4 do if ru(before, p) ~= ru(after, p) then same = false end end
	check("NaN setup item: rejected by both structures, previous setup kept", ok1 and not ok and same and V.setupStructure() == structureBefore,
		string.format("ok %s, %s", tostring(ok), tostring(rep.firstViolation)))
	local err = not pcall(V.applySetup, {[0] = -1})
	check("malformed setup array rejected (assert)", err)
	V.applySetup(Setup.cupGarageDefault())
end

---------------------------------------------------------------------------------------------------
-- 8. inspection dump (no per-tick output)
---------------------------------------------------------------------------------------------------
do
	local s = Setup.cupGarageDefault()
	Setup.set(s, "springLF", 1700); Setup.set(s, "gearChoice1", Setup.display(s, "gearChoice1") - 2)
	V.applySetup(s)
	local d = V.setupDump()
	-- 0055e9b0 copies item 0x14 (00423ee0: lb/in x 175 x -0.3136) into the wheel-rate cell 0074e0a0
	local springOk = d.runtime.springRate[1] == Setup.bitsToF(s[20]) and Setup.display(s, "springLF") == 1700
	check("setupDump: garage items + runtime cells (spring LF 1700 lb/in -> wheel rate cell 0074e0a0)", #d.items > 40 and springOk and d.runtime.gearCount == 4,
		string.format("%d items, LF wheel rate %.0f N/m, 1st gear %.4f, final %.3f, %s", #d.items, d.runtime.springRate[1], d.runtime.gearRatio[3], d.runtime.finalDrive, d.report.structure))
	V.applySetup(Setup.cupGarageDefault())
end

table.sort(applyTimes)
print(string.format("applySetup time: median %.2f s, max %.2f s", applyTimes[(#applyTimes + 1) // 2] or 0, applyTimes[#applyTimes] or 0))
print(string.format("\n%d passed, %d failed", passed, failed))
if failed > 0 then error("stage 10 tests failed") end
