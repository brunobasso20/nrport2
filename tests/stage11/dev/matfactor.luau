local Vehicle = require("../../../core/NR2003CupVehicle")
local function get(name) local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name); if ok then return m end; return nil end
local V = Vehicle.fromLoader(get).V
local t = {}
for k = 0, 24 do table.insert(t, string.format("%d:%g", k, V.rf32(0x6f6468 + 4 * k))) end
print("material factor 006f6468[k]: " .. table.concat(t, "  "))
