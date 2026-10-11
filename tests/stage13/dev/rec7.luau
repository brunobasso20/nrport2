local Vehicle = require("../../../core/NR2003CupVehicle")
local function get(name)
	local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name)
	if ok then return m end
	return nil
end
local car = Vehicle.fromLoader(get)
local V = car.V
local R = 0xd37cb8 + 29 * 7
print(string.format("type=%d +8=%x +c=%d axis=%d dir=%d  ctl8type=%d", V.ri32(R + 0x10), V.r32(R + 8), V.ri32(R + 0xc), V.ri32(R + 0x14), V.r8(R + 0x1c), V.ri32(0xd37cb8 + 29 * 8 + 0x10)))
