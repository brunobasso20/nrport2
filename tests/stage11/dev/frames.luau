-- Stage 11 diagnostic: Luau per-frame rows (same layout as recovery/stage11/dev/frames.py: observe row + 45 state
-- values) for the first N frames of a scenario:   luau -O2 --codegen tests/stage11/dev/frames.luau -a <scenario> <frames> [every] [frozen]
local Vehicle = require("../../../core/NR2003CupVehicle")
local function get(name)
	local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name)
	if ok then return m end
	return nil
end
local args = {...}
local name, frames = args[1] or "cold", tonumber(args[2] or "18")
local every = tonumber(args[3] or "1")
if args[4] == "frozen" then V_FROZEN = true end
local fx = require("../fixtures/scenario_" .. name)
local V = Vehicle.fromLoader(get).V
local FLAT = {}
for i = 1, 4 do FLAT[i] = {0, 0, 1, 0, 0, 0, 0, 1, 1} end
local s = fx.law.session
if V_FROZEN then V.setRuntimeMode("frozen") end
local o = fx.law.options or {}
V.startSession({temperatureF = s.temperature, windSpeedMph = s.wind_mph, windDirection = s.wind_dir, conditions = s.conditions,
	night = s.night == 1}, {damageLevel = o.damage_level, consumptionRate = o.consumption, series = o.series or 1, seed = o.seed})
local st11, buf = {}, table.create(45, 0)
local function row(frame)
	local t = V.stage11State(st11)
	local x = V.state(buf)
	local r = {frame, t.fuel.kg, t.engine.water, t.engine.oil, t.engine.coolantLevel, t.engine.oilLevel, t.engine.power, t.engine.overRev, t.engine.wear}
	for w = 1, 4 do
		local y = t.tyres[w]
		for _, v in ipairs({y.pressure, y.surface[2], y.carcass[2], y.wear, y.gripWear, y.brake}) do table.insert(r, v) end
	end
	for _, v in ipairs({t.damage.words[1], t.damage.words[3], t.damage.words[4]}) do table.insert(r, v) end
	for k = 1, 11 do table.insert(r, t.damage.zones[k]) end
	for _, v in ipairs({t.damage.radiator, t.damage.oil, t.damage.fuel, t.damage.engine}) do table.insert(r, v) end
	for k = 1, 6 do table.insert(r, x[k]) end
	table.insert(r, x[35]); table.insert(r, V.gearIndex()); table.insert(r, t.fuel.massRecord); table.insert(r, t.random)
	for k = 1, 45 do table.insert(r, x[k]) end
	local parts = table.create(#r)
	for i, v in ipairs(r) do parts[i] = string.format("%.17g", v) end
	print("[" .. table.concat(parts, ", ") .. "]")
end
row(0)
local ev = {}
for _, e in ipairs(fx.law.events) do ev[e[1]] = ev[e[1]] or {}; table.insert(ev[e[1]], e) end
for k = 0, frames - 1 do
	for _, e in ipairs(ev[k] or {}) do if e[2] == "enter" then V.enterTrack() end end
	local c = fx.law.controls[k + 1]
	for _ = 1, 8 do V.drive({throttle = c[1], clutch = c[2], steer = c[3], brakeControl = c[4], brakeDigital = true, shiftUp = c[5], shiftDown = c[6]}, FLAT) end
	for _, e in ipairs(ev[k] or {}) do
		if e[2] == "collision" then
			local a = e[3]
			V.collision({magnitude = a.magnitude, material = a.material, surface = a.surface, flags = a.flags, point = a.point,
				localPoint = a["local"], otherLocal = a.other_local, velocity = a.velocity, normal = a.normal, p9 = a.p9,
				speed = a.speed, key = a.key, other = a.other})
		elseif e[2] == "pit" then V.pitTyres(e[3]) end
	end
	if (k + 1) % every == 0 then row(k + 1) end
end
