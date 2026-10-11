-- dump of the Cup values of the Stage 11 parameters (documentation helper)
local Vehicle = require("../../../core/NR2003CupVehicle")
local function get(name) local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name); if ok then return m end; return nil end
local V = Vehicle.fromLoader(get).V
local rf, r32 = V.rf32, V.r32
local CAR, E = 0xc12030, 0xc12030 + 0xc
local spec = r32(CAR + 0x58a)
print(string.format("spec %08x fuelCapacity(+0x24) %.4f fuelInertiaPerKg(+0x28) %.6f spec+0x98 %.4f", spec, rf(spec + 0x24), rf(spec + 0x28), rf(spec + 0x98)))
local se = r32(E + 0x56a)
print(string.format("engine spec %08x maxRpm(+0x2c) %.1f coolant(+0x34) %.3f oil(+0x38) %.3f k3c %.5f k40 %.5f", se, rf(se + 0x2c), rf(se + 0x34), rf(se + 0x38), rf(se + 0x3c), rf(se + 0x40)))
print(string.format("engine: max_rpm_438 %.2f k43c %.5f k440 %.5f k46c %.1f k470 %.3f flags %08x x4d0 %.4f x504 %.3f", rf(E + 0x438), rf(E + 0x43c), rf(E + 0x440), rf(E + 0x46c), rf(E + 0x470), r32(E + 0x548), rf(E + 0x4d0), rf(E + 0x504)))
local fr = r32(0xc08234)
print(string.format("fuel record %08x mass cells %08x %08x %08x inertia %08x %08x %08x", fr, r32(fr + 0x125), r32(fr + 0x141), r32(fr + 0x15d), r32(fr + 0x179), r32(fr + 0x195), r32(fr + 0x1b1)))
for w = 0, 3 do
	local t = 0xbf3a20 + w * 0xa39
	local p = r32(t + 0x70)
	print(string.format("tyre%d: P0 %.2f p4 %.3f p8 %.3f c10 %.3f c14 %.3f k34 %.4f k40 %.6g k44 %.6g h50 %.5g Topt54 %.2f Tmax58 %.2f brakeC5c %.1f brakeK60 %.5f side6c %d obj70 %08x(+14 %.5g +18 %.5g +0c %.4f) surf2c0 %d",
		w, rf(t), rf(t + 4), rf(t + 8), rf(t + 0x10), rf(t + 0x14), rf(t + 0x34), rf(t + 0x40), rf(t + 0x44), rf(t + 0x50), rf(t + 0x54), rf(t + 0x58),
		rf(t + 0x5c), rf(t + 0x60), r32(t + 0x6c), p, rf(p + 0x14), rf(p + 0x18), rf(p + 0xc), r32(t + 0x2c0)))
end
print("damage layout table 006f56b8 (shift, mask, destroyed flag):")
for n = 0, 10 do
	local e = 0x6f56b8 + n * 0x15
	print(string.format("  component %2d shift %2d mask %4x flag %d", n, r32(e), r32(e + 4), V.r8(e + 8)))
end
print("zone tables 006f5500 (stride 0x20): wheel, zoneValue, bodyObj, start, range, destroyLimit, engine, suspension")
for z = 0, 14 do
	local a = 0x6f5500 + 0x20 * z
	print(string.format("  zone %2d %3d %3d %3d %10.1f %10.1f %6.2f %6.3f %6.3f", z, V.ri32(a), V.ri32(a + 4), V.ri32(a + 8), rf(a + 0xc), rf(a + 0x10), rf(a + 0x14), rf(a + 0x18), rf(a + 0x1c)))
end
print(string.format("bef700 damage scale %.3f  table %g %g %g %g", rf(0xbef700), rf(0x6f57a0), rf(0x6f57a4), rf(0x6f57a8), rf(0x6f57ac)))
print(string.format("surface tables: 6f6468 material factor[1] %g  74fb30[0] %g  6f65c0[1] %g  globals 74b9d8 %g 74b9dc %g 74b9e0 %g 74b9e4 %g",
	rf(0x6f6468 + 4), rf(0x74fb30), rf(0x6f65c0 + 4), rf(0x74b9d8), rf(0x74b9dc), rf(0x74b9e0), rf(0x74b9e4)))
print(string.format("rng %08x %08x", r32(0xf6eae4), r32(0xf6eae8)))
