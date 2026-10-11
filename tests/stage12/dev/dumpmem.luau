-- dev: play a scenario in the port up to the start of frame R and print its whole memory window (hex) for
-- recovery/stage12/dev/reverse.py (the ORIGINAL code continued from the PORT's own state)
local Vehicle = require("../../../core/NR2003CupVehicle")
local function get(name) local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name); if ok then return m end; return nil end
local car = Vehicle.fromLoader(get)
local V = car.V
local args = {...}
local name, R = args[1], tonumber(args[2])
local fx = require("../fixtures/scenario_" .. name)
local FLAT = {}
for i = 1, 4 do FLAT[i] = {0, 0, 1, 0, 0, 0, 0, 1, 1} end
local function controlsOf(row)
	local c = {throttle = row[1], clutch = row[2], brakeControl = row[3], brakeDigital = true, shiftUp = row[4], shiftDown = row[5]}
	if row[9] then c.steerAxis = row[10] else c.steerLeft = row[6]; c.steerRight = row[7]; c.steerDigital = row[8] end
	if not row[11] then c.driver = false end
	return c
end
V.setRuntimeMode("original"); V.endSession(); V.clearSteeringOptions()
if fx.law.ratio then local st = V.Setup.cupGarageDefault(); V.Setup.set(st, "steeringRatio", fx.law.ratio); V.applySetup(st) end
V.reset()
if fx.law.steer then V.setSteeringOptions(fx.law.steer, true) end -- validation: may set race bit 25 as the reference
V.startSession({temperatureF = 70, windSpeedMph = 0, windDirection = 0, conditions = 0, night = false}, {damageLevel = 0, series = 1})
for k = 0, R - 1 do
	local c = controlsOf(fx.law.controls[k + 1])
	for _ = 1, 8 do V.drive(c, FLAT) end
end
local M = V.memory()
local n = buffer.len(M)
local parts = {}
for o = 0, n - 1, 4 do parts[#parts + 1] = string.format("%08x", buffer.readu32(M, o)) end
print(V.base, V.tick or 0)
print(table.concat(parts))
