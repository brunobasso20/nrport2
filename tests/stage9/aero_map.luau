-- Stage 9 aero map (documentation helper): the ORIGINAL 00561b70 (lifted, validated against the
-- executed original in tests/stage9/run.luau) evaluated on a grid of speed, front ride height, yaw and
-- aero setup at the default session air. luau -O2 --codegen tests/stage9/aero_map.luau
local Vehicle = require("../../core/NR2003CupVehicle")
local function get(name)
	local ok, m = pcall(require, "../../core/NR2003Cup/" .. name)
	if ok then return m end
	return nil
end
local V = Vehicle.fromLoader(get).V
local HOST = 0xf7f100
local BLOCK, OUT6 = HOST + 0x600, HOST + 0x640
V.reset(); V.startSession(nil)
for _, o in ipairs({0x59e, 0x5a2, 0x5a6}) do V.w32(0xc12030 + o, 0x3f800000) end
local zlf, zrf = V.r32(V.r32(0xc084c0) + 0x2d5), V.r32(V.r32(0xc08310) + 0x2d5)
local z0l, z0r, h = V.rf32(zlf), V.rf32(zrf), V.rf32(0xc084c8)
local function eval(v, yawDeg, dz)
	V.wf32(zlf, z0l + (dz or 0)); V.wf32(zrf, z0r + (dz or 0))
	local y = math.rad(yawDeg or 0)
	for k = 0, 5 do V.w32(BLOCK + 4 * k, OUT6 + 4 * k) end
	V.wf32(BLOCK + 24, v * math.cos(y)); V.wf32(BLOCK + 28, v * math.sin(y)); V.wf32(BLOCK + 32, 0)
	V.wf32(BLOCK + 36, 0); V.wf32(BLOCK + 40, 0); V.wf32(BLOCK + 44, 0)
	V.w32(0x74e090, 5)
	V._callx(0x561b70, BLOCK)
	local r = {}
	for k = 0, 5 do r[k + 1] = V.rf32(OUT6 + 4 * k) end
	return r
end
print(string.format("session air rho %.7g kg/m^3; static front ride height %.4f m (7 in = 0.1778 m threshold)", V.rf32(0xe0b84c), ((h - z0l) + (V.rf32(0xc084cc) - z0r)) / 2))
print("speed sweep (yaw 0, static attitude): v m/s | Fx N | Fz N | My N*m | Fx/v^2 | Fz/v^2")
for _, v in ipairs({0, 10, 20, 30, 40, 50, 60, 70, 75, 80}) do
	local r = eval(v)
	print(string.format("  %3d | %8.1f | %8.1f | %8.1f | %.4f | %.4f", v, r[1], r[3], r[5], v > 0 and r[1] / (v * v) or 0, v > 0 and r[3] / (v * v) or 0))
end
print("front ride height sweep at 70 m/s: dz (suspension translation) | front rh m | Fx | Fz | My")
for _, dz in ipairs({-0.04, -0.02, 0, 0.01, 0.02, 0.03, 0.04, 0.05}) do
	local r = eval(70, 0, dz)
	local rh = ((h - (z0l + dz)) + (V.rf32(0xc084cc) - (z0r + dz))) / 2
	print(string.format("  %+.3f | %.4f | %8.1f | %8.1f | %8.1f", dz, rh, r[1], r[3], r[5]))
end
print("yaw sweep at 70 m/s: yaw deg | Fx | Fy | Fz | Mx | My | Mz")
for _, y in ipairs({0, 2, 5, 10, 20, 45, 90, 135, 180}) do
	local r = eval(70, y)
	print(string.format("  %5.1f | %8.1f | %8.1f | %8.1f | %7.1f | %7.1f | %7.1f", y, r[1], r[2], r[3], r[4], r[5], r[6]))
end
print("aero setup at 70 m/s (yaw 0, static attitude): Fx | Fz | My")
for _, s in ipairs({{0, 65}, {0, 45}, {0, 70}, {50, 65}, {100, 65}}) do
	V.setAeroSetup({grilleTape = s[1], spoiler = s[2]})
	local r = eval(70)
	print(string.format("  tape %3d %% spoiler %2d deg | %8.1f | %8.1f | %8.1f", s[1], s[2], r[1], r[3], r[5]))
end
