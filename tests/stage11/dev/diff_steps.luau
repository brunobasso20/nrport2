-- Stage 11 diagnostic: replay the ORIGINAL fine-grained snapshots (recovery/stage11/dev/dump_steps.py) step by step.
--   luau -O2 --codegen tests/stage11/dev/diff_steps.luau -a dev_steps_cold_120
local Vehicle = require("../../../core/NR2003CupVehicle")
local FP = require("../fixtures/footprint")
local function get(name)
	local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name)
	if ok then return m end
	return nil
end
local args = {...}
local STEPS = require("./" .. (args[1] or "dev_steps_cold_120"))
local car = Vehicle.fromLoader(get)
local V = car.V
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
	return out
end
local S = buffer.create(4)
local function fb(u) buffer.writeu32(S, 0, u); return buffer.readf32(S, 0) end
local function load(s)
	local b, o = b64(s), 0
	for _, r in ipairs(FP.touchRuns) do buffer.copy(M, r[1] - BASE, b, o, 4 * r[2]); o += 4 * r[2] end
end
local function diff(s, label, skip)
	local b, o, n = b64(s), 0, 0
	for _, r in ipairs(FP.touchRuns) do
		for k = 0, r[2] - 1 do
			local a = r[1] + 4 * k
			local want, mine = buffer.readu32(b, o), buffer.readu32(M, a - BASE)
			o += 4
			if want ~= mine and not (skip and skip(a)) then
				n += 1
				if n <= 40 then print(string.format("  %s %08x want %08x (%.9g) got %08x (%.9g)", label, a, want, fb(want), mine, fb(mine))) end
			end
		end
	end
	print(string.format("%s: %d mismatches", label, n))
end
local byName = {}
for _, s in ipairs(STEPS) do byName[s.name] = s.mem end
local callx = V._callx11
local function carVisual(a) return a >= 0xc12030 and a < 0xc12030 + 0x15b8 end
-- 1. each tyre update alone, from the original state at its entry
local tyres = {"tyre_ecx_bf3a20", "tyre_ecx_bf4459", "tyre_ecx_bf4e92", "tyre_ecx_bf58cb"}
for i = 1, 3 do
	load(byName[tyres[i]])
	local ecx = tonumber(string.sub(tyres[i], 10), 16)
	callx(0x54d610, ecx)
	diff(byName[tyres[i + 1]], "0054d610 tyre " .. (i - 1), carVisual)
end
-- 2. whole 00554520 from the synced state
load(byName.synced)
callx(0x554520, nil)
diff(byName.after554520, "00554520")
