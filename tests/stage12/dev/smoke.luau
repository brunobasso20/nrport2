local Vehicle = require("../../../core/NR2003CupVehicle")
local function get(name)
	local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name)
	if ok then return m end
	return nil
end
local car = Vehicle.fromLoader(get)
local V = car.V
print("mode", V.steeringMode(), V.runtimeMode())
local o = V.steeringOptions()
for k, v in pairs(o) do print("opt", k, v) end
local FLAT = {}
for i = 1, 4 do FLAT[i] = {0, 0, 1, 0, 0, 0, 0, 1, 1} end
V.startSession(nil, {})
local s = {}
for tick = 0, 8 * 36 * 4 - 1 do
	local t = tick / 288
	local c = {throttle = 0.5, clutch = 1, brakeControl = 0, brakeDigital = true,
		steerLeft = (t > 1 and t < 2) and 1 or 0, steerRight = 0, steerDigital = true}
	car:step(c, FLAT)
	if tick % 36 == 35 then
		V.steeringState(s)
		print(string.format("t=%.2f in=%.4f shaped=%.4f ratio=%.3f target=%.5f cur=%.5f lf=%.5f rf=%.5f hub=%.5f/%.5f wheel=%.4f v=%.2f",
			t, s.input, s.shaped, s.ratio, s.target, s.current, s.lf, s.rf, s.hubLF, s.hubRF, s.wheelAngle, V.rf32(0xbf6f44)))
	end
end
