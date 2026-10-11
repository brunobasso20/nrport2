-- dev: try a candidate control law in the Luau port (scenario design only; the fixture comes from the original)
local Vehicle = require("../../../core/NR2003CupVehicle")
local function get(name) local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name); if ok then return m end; return nil end
local car = Vehicle.fromLoader(get)
local V = car.V
local FLAT = {}
for i = 1, 4 do FLAT[i] = {0, 0, 1, 0, 0, 0, 0, 1, 1} end
local args = {...}
local thr, brk, thr2 = tonumber(args[1]) or 0.8, tonumber(args[2]) or 0.6, tonumber(args[3]) or 0.7
local function within(t, a, b) return t >= a and t < b end
local function law(k)
	local t = k / 36
	local c = {throttle = 0, clutch = 1, brakeControl = 0, brakeDigital = true, shiftUp = k == 40 or k == 110, shiftDown = false}
	local s = 0
	if t < 9 then c.throttle = thr end
	if within(t, 9, 14) then s = 0.05 end
	if within(t, 10, 14) then c.brakeControl = brk end
	if within(t, 15, 24) then c.throttle = thr2; s = -0.12 end
	c.steerAxis = s
	return c
end
V.setRuntimeMode("original"); V.endSession(); V.clearSteeringOptions(); V.reset()
V.startSession({temperatureF = 70, windSpeedMph = 0, windDirection = 0, conditions = 0, night = false}, {damageLevel = 0, series = 1})
local st = table.create(45, 0)
for k = 0, 36 * 28 - 1 do
	local c = law(k)
	for _ = 1, 8 do V.drive(c, FLAT) end
	if (k + 1) % 18 == 0 then
		local s = V.state(st)
		print(string.format("t %5.1f v %6.2f gear %d rpm %7.1f r %8.4f target %.5f ratio %.3f", (k + 1) / 36, V.rf32(0xbf6f44), s[35], V.rf32(0xbf3a20) , s[13], V.rf32(0xbf6e80), V.steerRatioOriginal()))
	end
end
