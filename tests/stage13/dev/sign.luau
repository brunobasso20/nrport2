local Vehicle = require("../../../core/NR2003CupVehicle")
local function get(name) local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name); if ok then return m end; return nil end
local car = Vehicle.fromLoader(get)
local V = car.V
local FLAT = {}
for i = 1, 4 do FLAT[i] = {0, 0, 1, 0, 0, 0, 0, 1, 1} end
local st = V.Setup.cupGarageDefault(); V.Setup.set(st, "steeringRatio", 12); V.applySetup(st); V.reset()
V.setSteeringOptions({momentumAxis = 0})
V.setForceFeedbackDevice({capable = true})
V.setForceFeedbackOptions({enabled = true})
V.startSession(nil, {damageLevel = 0})
local s = {}
for f = 0, 36 * 22 - 1 do
	local t = f / 36
	local ax = 0
	if t > 10 and t < 14 then ax = 0.05 elseif t > 15 and t < 19 then ax = -0.05 elseif t > 20 then ax = 0.3 end
	local c = {throttle = t < 10 and 0.8 or 0.5, clutch = 1, brakeControl = 0, steerAxis = ax, shiftUp = (f == 40 or f == 110)}
	for _ = 1, 8 do car:step(c, FLAT) end
	if f % 18 == 17 then
		V.forceFeedbackState(s)
		local ss = V.steeringState()
		print(string.format("t=%5.2f axis %+.2f v %5.1f m/s  target %+.4f  force %+.4f (DI %+5d) slip %+.5f moment %+8.2f ecc %+8.2f acq %s", t, ax,
			V.rf32(0xbf6f44), ss.target, s.force, s.magnitude, s.slip, s.moment, s.filtered, tostring(s.acquired)))
	end
end
