local Vehicle = require("../../../core/NR2003CupVehicle")
local function get(name)
	local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name)
	if ok then return m end
	return nil
end
local car = Vehicle.fromLoader(get)
local V = car.V
local function dump(tag)
	local s = {}
	for _, a in ipairs({0xbf6eb8, 0xbf6eb9, 0xbf6eba, 0xbf6ebb}) do s[#s + 1] = string.format("%x=%d", a, V.r8(a)) end
	for _, a in ipairs({0xbf6ebc, 0x74c95c, 0x74c964, 0x74c968}) do s[#s + 1] = string.format("%x=%d", a, V.ri32(a)) end
	for _, a in ipairs({0x74c960, 0xbf6ec0, 0xbf6ec4, 0xbf6ec8, 0xbf6ecc, 0xbf6ed0, 0xbf6ed4, 0xbf6ed8, 0xbf6edc, 0xbf6ee0, 0xbf6ee4, 0xbf6ee8, 0xbf6eec, 0xbf6ef0, 0x74c9a4, 0xbf6f20, 0xbf6f24, 0xc055c0 + 0xc0}) do
		s[#s + 1] = string.format("%x=%.9g", a, V.rf32(a)) end
	s[#s + 1] = string.format("bf6f1c=%d bf6e04=%d", V.r8(0xbf6f1c), V.r8(0xbf6e04))
	print(tag, table.concat(s, " "))
end
dump("postbuild")
V.startSession(nil, {})
dump("session")
local FLAT = {}
for i = 1, 4 do FLAT[i] = {0, 0, 1, 0, 0, 0, 0, 1, 1} end
for tick = 1, 16 do car:step({throttle = 0.5, clutch = 1, brakeControl = 0, steerAxis = 0.1}, FLAT) end
dump("2frames")
