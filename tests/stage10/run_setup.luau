-- Stage 10 garage/setup conversion tests (Luau CLI): luau tests/stage10/run_setup.luau
-- Golden values: the ORIGINAL converters and garage functions executed in Unicorn under the default FPU control
-- word (0x027f, "nearest") and the game control word (0x077f, "down") - recovery/stage10/gen_setup_vectors.py.
local Setup = require("../../core/NR2003Cup/NR2003CupSetup")(require("../../core/NR2003Cup/NR2003CupSetupData"))
local FIX = require("./fixtures/setup_vectors")

local passed, failed = 0, 0
local function check(name, ok, detail)
	if ok then passed += 1; print("PASS  " .. name .. (detail and ("  " .. detail) or ""))
	else failed += 1; print("FAIL  " .. name .. (detail and ("  " .. detail) or "")) end
end
local S = buffer.create(4)
local function bits(x) buffer.writef32(S, 0, x); return buffer.readu32(S, 0) end
local function same(a, b) return a == b or (a ~= a and b ~= b) end

-- descriptors / defaults
do
	local bad = 0
	for _, r in ipairs(FIX.descriptors) do
		local d = Setup.ITEM[r.i]
		if r.desc ~= 0 then
			if d.desc ~= r.desc or d.type ~= r.type or d.min ~= r.min or d.max ~= r.max or d.step ~= r.step or d.default ~= r.default then bad += 1 end
		elseif d.desc ~= nil then bad += 1 end
	end
	check("184 setup descriptors = original c05150 table", bad == 0, bad .. " mismatches")
	local b1, b2 = 0, 0
	for i = 0, 183 do
		if Setup.DATA.crtDefault[i] ~= FIX.crt[i + 1] then b1 += 1 end
		if Setup.DATA.cupDefault[i] ~= FIX.cup[i + 1] then b2 += 1 end
	end
	check("CRT default setup and Cup default (after 00559950) = original", b1 == 0 and b2 == 0, b1 .. "/" .. b2)
	local d = Setup.defaults("nearest"); local b3 = 0
	for i = 0, 183 do
		local it = Setup.ITEM[i]
		if it.desc and it.toInternal and d[i] ~= FIX.crt[i + 1] then b3 += 1 end
	end
	check("00557d20 defaults (descriptor defaults through toInternal, CW nearest) = CRT setup", b3 == 0, b3 .. " mismatches")
end

for _, mode in ipairs({"nearest", "down"}) do
	local V = FIX.vectors.modes[mode]
	local function run(name, list, f)
		local bad, first = 0, nil
		for _, v in ipairs(list) do
			local ok, got, want = f(v)
			if not ok then bad += 1; if not first then first = string.format("item %d: got %s want %s", v[1], tostring(got), tostring(want)) end end
		end
		check(string.format("%s [%s] (%d vectors)", name, mode, #list), bad == 0, bad > 0 and (bad .. " bad, first " .. first) or "bit-exact")
	end
	run("toInternal converters", V.toInternal, function(v)
		local got = Setup.toInternal(v[1], v[2], mode); return got == v[3], string.format("%08x", got), string.format("%08x", v[3]) end)
	run("toDisplay converters", V.toDisplay, function(v)
		local got = Setup.toDisplay(v[1], v[2], mode); return got == v[3], string.format("%08x", got), string.format("%08x", v[3]) end)
	run("005582d0 stepCount", V.stepCount, function(v)
		local got = Setup.u32(Setup.stepCount(v[1], mode)); return got == v[2], got, v[2] end)
	local s = table.create(184, 0)
	run("00558320 stepIndex", V.stepIndex, function(v)
		s[v[1]] = v[2]; local got = Setup.u32(Setup.stepIndex(s, v[1], mode)); return got == v[3], got, v[3] end)
	run("00557e40 snapped display value", V.snapped, function(v)
		s[v[1]] = v[2]; local got = Setup.snapped(s, v[1], mode); return same(got, v[3]), got, v[3] end)
	run("005581d0 set display value (snap+clamp)", V.setSnap, function(v)
		s[v[1]] = 0; local ret = Setup.setSnapped(s, v[1], v[2], mode); return s[v[1]] == v[3] and ret == v[4], string.format("%08x/%08x", s[v[1]], ret), string.format("%08x/%08x", v[3], v[4]) end)
	run("005580f0 set display value (clamp)", V.setClamp, function(v)
		s[v[1]] = 0; Setup.setClamped(s, v[1], v[2], mode); return s[v[1]] == v[3], string.format("%08x", s[v[1]]), string.format("%08x", v[3]) end)
	run("005583e0 garage step +/-", V.step, function(v)
		s[v[1]] = v[2]; local ch = Setup.step(s, v[1], v[3] == 1, mode)
		return (ch and 1 or 0) == v[4] and s[v[1]] == v[5], string.format("%s %08x", tostring(ch), s[v[1]]), string.format("%d %08x", v[4], v[5]) end)
	run("00558380 set by step index", V.setIndex, function(v)
		Setup.setIndex(s, v[1], v[2], mode); return s[v[1]] == v[3], string.format("%08x", s[v[1]]), string.format("%08x", v[3]) end)
	do
		local bad = 0
		for _, t in ipairs(V.validate) do
			local w = table.create(184, 0)
			for i = 0, 183 do w[i] = t[1][i + 1] end
			local ok = Setup.validateLoaded(w, mode)
			for i = 0, 183 do if w[i] ~= t[2][i + 1] then bad += 1 end end
			if (ok and 1 or 0) ~= t[3] then bad += 1 end
		end
		check(string.format("00558da0 setup-file validation [%s] (%d setups)", mode, #V.validate), bad == 0, bad .. " mismatching items")
	end
end
print(string.format("\nStage 10 setup conversion: %d passed, %d failed", passed, failed))
if failed > 0 then error("Stage 10 setup conversion tests failed") end
