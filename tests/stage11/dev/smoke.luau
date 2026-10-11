-- Stage 11 smoke run (Luau CLI): load the core with the Stage 11 runtime and drive 30 s, printing the state.
local Vehicle = require("../../../core/NR2003CupVehicle")
local function get(name)
	local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name)
	if ok then return m end
	return nil
end
local t0 = os.clock()
local car = Vehicle.fromLoader(get)
local V = car.V
print(string.format("loaded in %.2f s, mode %s, supplement %d bytes", os.clock() - t0, V.runtimeMode(), V._stage11Supplement))
V.startSession({}, {})
local FLAT = {}
for i = 1, 4 do FLAT[i] = {0, 0, 1, 0, 0, 0, 0, 1, 1} end
local function show(k)
	local s = V.stage11State()
	local st = V.state()
	print(string.format("t=%5.1f v=%6.2f rpm=%6.0f gear=%d fuel=%.4f water=%.3f oil=%.3f power=%.3f", k / 36, st[2],
		V.engineRpm(), V.gearIndex(), s.fuel.kg, s.engine.water, s.engine.oil, s.engine.power))
	for w = 1, 4 do
		local t = s.tyres[w]
		print(string.format("   w%d P0=%.3f P=%.3f surf=%.2f %.2f %.2f core=%.2f %.2f %.2f wear=%.6f brake=%.2f grip=%.4f", w - 1,
			t.coldPressure, t.pressure, t.surface[1], t.surface[2], t.surface[3], t.carcass[1], t.carcass[2], t.carcass[3],
			t.wear, t.brake, t.gripWear))
	end
end
show(0)
local t1 = os.clock()
for k = 0, 36 * 30 - 1 do
	local t = k / 36
	local c = {throttle = t < 20 and 1 or 0, clutch = 1, steer = 0, brakeControl = (t >= 20 and t < 24) and 1 or 0,
		brakeDigital = true, shiftUp = (k == 36 or k == 90 or k == 160)}
	for _ = 1, 8 do V.drive(c, FLAT) end
	if (k + 1) % 180 == 0 then show(k + 1) end
end
print(string.format("%.1f s for 30 s (%.0f ticks/s)", os.clock() - t1, 36 * 30 * 8 / (os.clock() - t1)))
