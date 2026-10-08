-- Stage 11 diagnostic: Luau run vs original rows (and the 1-ulp twin) for chosen fields.
--   luau -O2 --codegen tests/stage11/dev/diff_rows.luau -a <scenario> <lastRow> field1 field2 ...
local Vehicle = require("../../../core/NR2003CupVehicle")
local FP = require("../fixtures/footprint")
local function get(name)
	local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name)
	if ok then return m end
	return nil
end
local args = {...}
local name, last = args[1] or "cold", tonumber(args[2] or "8")
local fx = require("../fixtures/scenario_" .. name)
local V = Vehicle.fromLoader(get).V
local FLAT = {}
for i = 1, 4 do FLAT[i] = {0, 0, 1, 0, 0, 0, 0, 1, 1} end
local idx = {}
for i, f in ipairs(FP.fields) do idx[f] = i + 1 end
local want = {}
for k = 3, #args do table.insert(want, args[k]) end
if #want == 0 then want = {"x", "vx", "z", "fuel", "water", "wear2", "surfaceMid2", "omegaEngine", "gear", "rng"} end
local s = fx.law.session
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
	return r
end
local function show(r, i)
	local line = string.format("frame %4d", r[1])
	for _, f in ipairs(want) do
		local j = idx[f]
		line ..= string.format("  %s lua %.9g orig %.9g pert %.9g", f, r[j], fx.rows[i][j], fx.pert[1][i][j])
	end
	print(line)
end
show(row(0), 1)
local ev = {}
for _, e in ipairs(fx.law.events) do ev[e[1]] = ev[e[1]] or {}; table.insert(ev[e[1]], e) end
for k = 0, fx.law.frames - 1 do
	for _, e in ipairs(ev[k] or {}) do if e[2] == "enter" then V.enterTrack() end end
	local c = fx.law.controls[k + 1]
	for _ = 1, 8 do V.drive({throttle = c[1], clutch = c[2], steer = c[3], brakeControl = c[4], brakeDigital = true, shiftUp = c[5], shiftDown = c[6]}, FLAT) end
	if (k + 1) % 18 == 0 then
		local i = (k + 1) // 18 + 1
		show(row(k + 1), i)
		if i > last then break end
	end
end
