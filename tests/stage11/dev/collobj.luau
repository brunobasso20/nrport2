local Vehicle = require("../../../core/NR2003CupVehicle")
local function get(name) local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name); if ok then return m end; return nil end
local V = Vehicle.fromLoader(get).V
V.startSession({}, {})
local player = V._callx11(0x55ab00, nil)
print(string.format("player index 0055ab00() = %d   c7e75c = %08x   00883500[0..2] = %08x %08x %08x", player, V.r32(0xc7e75c), V.r32(0x883500), V.r32(0x883504), V.r32(0x883508)))
for _, base in ipairs({V.r32(0xc7e75c), V.r32(0x883500)}) do
	if base ~= 0 and base >= V.base and base < 0xf80000 then
		local t = {}
		for k = 0, 4 do t[#t + 1] = string.format("%08x", V.r32(base + 0x28 + 4 * k)) end
		print(string.format("  container %08x parts +0x28: %s", base, table.concat(t, " ")))
	end
end
