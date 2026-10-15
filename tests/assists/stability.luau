local Vehicle = require("../../core/NR2003CupVehicle")
local Reference = require("./stability_reference")
local function get(name)
    local ok, module = pcall(require, "../../core/NR2003Cup/" .. name)
    return ok and module or nil
end
local V = Vehicle.fromLoader(get).V
local TABLE, OUT = 0xF7E200, 0xF7E300
for _, cell in ipairs(Reference.coefficients) do
    assert(V.r32(cell[1]) == cell[2], string.format("production stability coefficient %08x is absent/different", cell[1]))
end
local scratch = buffer.create(4)
local function value(bits) buffer.writeu32(scratch, 0, bits); return buffer.readf32(scratch, 0) end
local exact, total, corrected, maxError = 0, 0, 0, 0
for _, row in ipairs(Reference.rows) do
    for _, cell in ipairs(row.inputs) do V.w32(cell[1], cell[2]) end
    for i = 0, 5 do V.w32(TABLE + 4 * i, OUT + 4 * i); V.w32(OUT + 4 * i, 0xDEADBEEF) end
    for i, velocity in ipairs(row.velocity) do V.wf32(TABLE + 20 + 4 * i, velocity) end
    V._callx(0x561E50, TABLE)
    local changed = false
    for i, wanted in ipairs(row.expected) do
        local address = i <= 6 and OUT + (i - 1) * 4 or 0xC086AC
        local got = V.r32(address)
        local error = math.abs(value(got) - value(wanted))
        if got == wanted then exact += 1 end
        total += 1
        maxError = math.max(maxError, error)
        assert(got == wanted, "original stability force bits mismatch")
        if row.enabled == 0 or row.hardcore ~= 0 then assert(value(got) == 0, "disabled stability still added force") end
        changed = changed or math.abs(value(got)) > 0
    end
    if row.enabled ~= 0 and row.hardcore == 0 and changed then corrected += 1 end
    assert(V._fpu() == 0, "stability force path leaked FPU state")
end
assert(corrected > 0, "stability-on cases never exercised a corrective force")
print(string.format("Original stability: %d vectors; %d/%d force/scalar bits exact, max abs error %.3g; %d aid-on corrective vectors; disabled/hardcore add zero", #Reference.rows, exact, total, maxError, corrected))
