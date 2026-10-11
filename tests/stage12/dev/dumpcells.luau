local Vehicle = require("../../../core/NR2003CupVehicle")
local function get(name) local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name); if ok then return m end; return nil end
local car = Vehicle.fromLoader(get)
local V = car.V
local CELLS = {0xbf63c8, 0xbf63c0, 0xbf63b8, 0xbf6e80, 0xbf6e88, 0xbf639c, 0xbf63a0, 0xbf6360, 0xbf6364, 0xbf6f44, 0xbf6d7c, 0xbf6d94, 0xc13584}
local args = {...}
local kind, frames = args[1], tonumber(args[2])
local FLAT = {}
for i = 1, 4 do FLAT[i] = {0, 0, 1, 0, 0, 0, 0, 1, 1} end
local function law(k)
	local t = k / 36
	local c = {throttle = t < 6 and 1 or 0.3, clutch = 1, brakeControl = 0, brakeDigital = true, shiftUp = (k == 40 or k == 110)}
	if kind == "keys" then
		c.steerLeft = (t > 3 and t < 3.5) and 1 or 0; c.steerRight = (t > 4 and t < 5) and 1 or 0; c.steerDigital = true
	else
		c.steerAxis = t > 2 and 0.6 * math.sin(t * 2.0) or 0
	end
	return c
end
V.setRuntimeMode("original"); V.endSession(); V.reset()
if args[3] then
	local o = {}
	for kv in string.gmatch(args[3], "[^,]+") do local k, v = string.match(kv, "(%w+)=(.+)"); o[k] = v == "true" or (v ~= "false" and tonumber(v)) end
	V.setSteeringOptions(o)
end
V.startSession({temperatureF = 70, windSpeedMph = 0, windDirection = 0, conditions = 0, night = false}, {damageLevel = 0, series = 1})
local out = {}
for k = 0, frames - 1 do
	local c = law(k)
	V.drive(c, FLAT)
	local a = {}
	for i, x in ipairs(CELLS) do a[i] = V.r32(x) end
	for _ = 1, 7 do V.drive(c, FLAT) end
	local b = {}
	for i, x in ipairs(CELLS) do b[i] = V.r32(x) end
	table.insert(out, string.format("[%d,[%s],[%s]]", k, table.concat(a, ","), table.concat(b, ",")))
end
print("[" .. table.concat(out, ",") .. "]")
