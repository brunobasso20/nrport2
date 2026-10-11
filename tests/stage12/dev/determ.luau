local Vehicle = require("../../../core/NR2003CupVehicle")
local function get(name) local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name); if ok then return m end; return nil end
local car = Vehicle.fromLoader(get)
local V = car.V
local FLAT = {}
for i = 1, 4 do FLAT[i] = {0, 0, 1, 0, 0, 0, 0, 1, 1} end
local function run(n)
	local out = {}
	for k = 1, n do
		local c = {throttle = 0.7, clutch = 1, steerAxis = 0.2 * math.sin(k / 20), shiftUp = k == 40}
		for _ = 1, 8 do V.drive(c, FLAT) end
		out[k] = V.r32(0xbf6360) .. ":" .. V.r32(0xbf6d44)
	end
	return out
end
V.setRuntimeMode("original"); V.endSession()
V.reset(); local a = run(200)
V.reset(); local b = run(100); local cp = V.checkpoint(); local b2 = run(100)
V.restore(cp); local b3 = run(100)
for k = 1, 100 do if a[k] ~= b[k] then print("a/b differ at", k, a[k], b[k]); break end end
for k = 1, 100 do if a[100 + k] ~= b2[k] then print("a/b2 differ at", k, a[100+k], b2[k]); break end end
for k = 1, 100 do if b2[k] ~= b3[k] then print("b2/b3 differ at", k, b2[k], b3[k]); break end end
print("tick", V.tick)
