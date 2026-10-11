-- Stage 11 diagnostic: damage of one collision record after a drive (scenario 'impacts' record vs variants)
--   luau -O2 --codegen tests/stage11/dev/impact.luau
local Vehicle = require("../../../core/NR2003CupVehicle")
local function get(name)
	local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name)
	if ok then return m end
	return nil
end
local V = Vehicle.fromLoader(get).V
local FLAT = {}
for i = 1, 4 do FLAT[i] = {0, 0, 1, 0, 0, 0, 0, 1, 1} end
local function drive(frames)
	for k = 0, frames - 1 do
		local c = {throttle = 0.45, clutch = 1, steer = 0, brakeControl = 0, brakeDigital = true, shiftUp = (k == 40 or k == 160)}
		for _ = 1, 8 do V.drive(c, FLAT) end
	end
end
local function try(label, rec)
	V.endSession(); V.reset(); V.startSession({}, {})
	drive(180)
	local before = V.stage11State().damage
	local z0 = table.clone(before.zones)
	V.collision(rec)
	for _ = 1, 16 do V.drive({throttle = 0.45, clutch = 1}, FLAT) end
	local d = V.stage11State().damage
	local changed = {}
	for k = 1, #z0 do if d.zones[k] ~= z0[k] then table.insert(changed, string.format("%d:%.4g", k, d.zones[k])) end end
	local x = V.state()
	print(string.format("%-34s vx %.2f m/s scale %.2f series %d words %08x %08x %08x zones changed {%s}", label, x[2], d.scale, d.series,
		d.words[1], d.words[3], d.words[4], table.concat(changed, " ")))
end
-- scenarios11.impacts() first record (frame 180): point (10,0,0.5), local (2.4,0,0.3), velocity (30,0,0), normal (-1,0,0)
try("impacts record (magnitude 60000)", {magnitude = 60000, material = 0x10, surface = 1, point = {10, 0, 0.5}, localPoint = {2.4, 0, 0.3},
	velocity = {30, 0, 0}, normal = {-1, 0, 0}, speed = 20, key = 0})
try("impacts record (magnitude 150000)", {magnitude = 150000, material = 0x10, surface = 1, point = {10, 0, 0.5}, localPoint = {2.4, 0, 0.3},
	velocity = {30, 0, 0}, normal = {-1, 0, 0}, speed = 20, key = 0})
-- adapter-style: point at the car front, velocity = chassis velocity, normal against the heading
local x = nil
try("adapter-style (150000, own velocity)", (function()
	V.endSession(); V.reset(); V.startSession({}, {})
	drive(180)
	local s = V.state()
	return {magnitude = 150000, material = 0x10, surface = 1, point = {s[1] + 2.4, s[3], s[5]}, localPoint = {2.4, 0, 0.3},
		velocity = {s[2], s[4], s[6]}, normal = {-1, 0, 0}, speed = math.abs(s[2])}
end)())
