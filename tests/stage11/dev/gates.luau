-- Stage 11 diagnostic: the gates of the collision damage path (00549c40 -> 00549290) after one record
--   luau -O2 --codegen tests/stage11/dev/gates.luau
local Vehicle = require("../../../core/NR2003CupVehicle")
local function get(name)
	local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name)
	if ok then return m end
	return nil
end
local V = Vehicle.fromLoader(get).V
local r32, rf32 = V.r32, V.rf32
local FLAT = {}
for i = 1, 4 do FLAT[i] = {0, 0, 1, 0, 0, 0, 0, 1, 1} end
V.startSession({}, {})
for k = 0, 179 do for _ = 1, 8 do V.drive({throttle = 0.45, clutch = 1, shiftUp = (k == 40 or k == 160)}, FLAT) end end
local CAR = 0xc12030
local car0 = V._callx11(0x562f70, nil, 0)
print(string.format("00562f70(0) = %08x (CAR %08x)  car+4 %08x  +0x596 series %d  track object +0x5ae %08x  bef700 %.3f",
	car0 or -1, CAR, r32(CAR + 4), r32(CAR + 0x596), r32(CAR + 0x5ae), rf32(0xbef700)))
if car0 and car0 ~= CAR then
	print(string.format("   object 00562f70(0): +4 %08x +0x596 %d +0x5ae %08x", r32(car0 + 4), r32(car0 + 0x596), r32(car0 + 0x5ae)))
end
local sv = V._callx11(0x55a610, nil)
print(string.format("0055a610() = %08x  +0xc %08x", sv or -1, sv and r32(sv + 0xc) or -1))
V.collision({magnitude = 150000, material = 0x10, surface = 1, point = {10, 0, 0.5}, localPoint = {2.4, 0, 0.3},
	velocity = {30, 0, 0}, normal = {-1, 0, 0}, speed = 20, key = 0})
local head = r32(0xbf39f0)
print(string.format("record list bf39f0 = %08x", head))
if head ~= 0 then
	print(string.format("   record: key %08x (body %08x -> car index %d) mag %.1f flags %08x other %d", r32(head), r32(r32(head) + 4),
		r32(r32(r32(head) + 4) + 0x1a4), rf32(head + 4), r32(head + 8), r32(head + 12)))
end
