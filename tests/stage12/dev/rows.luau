-- dev: play a scenario and print the Luau rows as JSON (for recovery/stage12/dev/rowdiff.py)
local Vehicle = require("../../../core/NR2003CupVehicle")
local function get(name) local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name); if ok then return m end; return nil end
local car = Vehicle.fromLoader(get)
local V = car.V
local name = ({...})[1]
local EVERY = tonumber(({...})[2]) or 9
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
local st = table.create(45, 0)
local out = {}
local function row(k)
	local s = V.state(st)
	local r = {k}
	for i = 1, 13 do table.insert(r, s[i]) end
	for _, a in ipairs({0xbf63c8, 0xbf63b8, 0xbf63c0, 0xbf6e80, 0xbf6360, 0xbf6364}) do table.insert(r, V.rf32(a)) end
	table.insert(r, s[16]); table.insert(r, s[22]); table.insert(r, V.rf32(0xc12030 + 0x1554)); table.insert(r, V.rf32(0xbf6f44))
	for w = 0, 3 do table.insert(r, V.rf32(0xbf3a20 + w * 0xa39 + 0x2dc)) end
	table.insert(r, s[35])
	local t = {}
	for i, v in ipairs(r) do t[i] = string.format("%.9g", v) end
	table.insert(out, "[" .. table.concat(t, ",") .. "]")
end
for k = 0, fx.law.frames - 1 do
	local c = controlsOf(fx.law.controls[k + 1])
	for _ = 1, 8 do V.drive(c, FLAT) end
	if (k + 1) % EVERY == 0 then row(k + 1) end
end
print("[" .. table.concat(out, ",") .. "]")
