-- Stage 11 diagnostic: tyre ambient (0x74c954) vs the new-tyre temperature after the session start, per air temperature
--   luau -O2 --codegen tests/stage11/dev/ambient.luau
local Vehicle = require("../../../core/NR2003CupVehicle")
local function get(name)
	local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name)
	if ok then return m end
	return nil
end
local V = Vehicle.fromLoader(get).V
for _, f in ipairs({40, 70, 110}) do
	V.endSession(); V.reset()
	local w = V.startSession({temperatureF = f}, {})
	local s = V.stage11State()
	print(string.format("%3d F: air %.2f C  ambient(74c954) %.3f K = %.2f C  new tyre surface/carcass %.3f / %.3f K = ambient %+.3f K  cold pressure %.3f",
		f, w.densityTemperatureC or -1, s.ambient, s.ambient - 273.15, s.tyres[1].surface[2], s.tyres[1].carcass[2], s.tyres[1].surface[2] - s.ambient,
		s.tyres[1].coldPressure or -1))
end
