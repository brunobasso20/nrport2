-- DEV check (not part of the suites; the fixture is ~7 MB): the lifted original build compared step by step with
-- the Unicorn build of the same setup (natural structure).
--   python3 recovery/stage10/dev/make_step_fixture.py recovery/stage10/dev/fixture_steps.lua
--   luau -O2 --codegen recovery/stage10/dev/run_steps.luau
-- Expected: steps 1-16 1 differing dword (f7f000 = the Unicorn harness inBackground flag, not restored by design: the
-- image keeps 1); from step 17 (generated solve pass in double) + the solve-pass cells.
local Vehicle = require("../../../core/NR2003CupVehicle")
local function get(name)
	local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name)
	if ok then return m end
	return nil
end
local car = Vehicle.fromLoader(get)
local V = car.V
local B = V.Build
local FIX = require("./fixture_steps")
local M = V.memory()
local B64 = {}
local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
for i = 1, 64 do B64[string.byte(chars, i)] = i - 1 end
local function decode(s)
	local bytes = {}
	for i = 1, #s, 4 do
		local a, b, c, d = string.byte(s, i, i + 3)
		local x = B64[a] * 262144 + B64[b] * 4096 + (c ~= 61 and B64[c] or 0) * 64 + (d ~= 61 and B64[d] or 0)
		bytes[#bytes + 1] = bit32.rshift(x, 16)
		if c ~= 61 then bytes[#bytes + 1] = bit32.band(bit32.rshift(x, 8), 0xff) end
		if d ~= 61 then bytes[#bytes + 1] = bit32.band(x, 0xff) end
	end
	return bytes
end
local function compare(step)
	local bad, total = 0, 0
	for _, r in ipairs(FIX.steps[step]) do
		local bytes = decode(r[2])
		for k = 0, #bytes // 4 - 1 do
			local want = bytes[4*k+1] + bytes[4*k+2] * 256 + bytes[4*k+3] * 65536 + bytes[4*k+4] * 16777216
			total += 1
			if want ~= buffer.readu32(M, r[1] + 4 * k) then bad += 1 end
		end
	end
	return bad, total
end
B.begin(FIX.items, "natural")
for k = 1, B.STEPS do
	local ok, err = pcall(B.step, k)
	local bad, total = compare(k)
	print(string.format("step %d %s: %d/%d dwords differ", k, ok and "ok" or ("ERROR " .. tostring(err)), bad, total))
	if not ok then break end
end
