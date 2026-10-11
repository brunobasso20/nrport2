local Vehicle = require("../../../core/NR2003CupVehicle")
local function get(name) local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name); if ok then return m end; return nil end
local V = Vehicle.fromLoader(get).V
V.startSession({}, {})
local VEC = 0xf7a000 + 0x480 + 0x70
local out = {}
for _, p in ipairs({{2.4, 0, 0.3}, {-2.5, 0, 0.4}, {0.5, 0.95, 0.4}, {0.5, -0.95, 0.4}, {1.45, 0.8, 0}, {0, 0, 0}, {2.0, 0, 0.5}, {-2.0, 0.5, 0.3}}) do
	V.wf32(VEC, p[1]); V.wf32(VEC + 4, p[2]); V.wf32(VEC + 8, p[3])
	local z = V._callx11(0x54a710, nil, 0, VEC)
	table.insert(out, string.format("(%g,%g,%g) -> %d", p[1], p[2], p[3], z and bit32.bxor(z, 0) or -99))
end
print("zone lookup 0054a710: " .. table.concat(out, "  "))
print(string.format("BSP root 00890490: %08x %08x %08x %08x", V.r32(0x890490), V.r32(0x890494), V.r32(0x890498), V.r32(0x89049c)))
