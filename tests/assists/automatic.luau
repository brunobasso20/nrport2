local Vehicle = require("../../core/NR2003CupVehicle")
local Install = require("../../core/NR2003Cup/NR2003CupAutomatic")
local Reference = require("./automatic_reference")
local function get(name)
    local ok, module = pcall(require, "../../core/NR2003Cup/" .. name)
    return ok and module or nil
end
local V = Vehicle.fromLoader(get).V
Install(V)
local scratch = buffer.create(4)
local function float(bits) buffer.writeu32(scratch, 0, bits); return buffer.readf32(scratch, 0) end
local function bits(value) buffer.writef32(scratch, 0, value); return buffer.readu32(scratch, 0) end
local function apply(cells) for _, cell in ipairs(cells) do V.w32(cell[1], cell[2]) end end
local initialized, rpmCases, selectorCases, worst = 0, 0, 0, 0
for _, context in ipairs(Reference.contexts) do
    V.reset(); apply(context.inputs)
    V.initializeAutomaticOriginal()
    for _, cell in ipairs(context.initialized) do
        assert(V.r32(cell[1]) == cell[2], string.format("%s init %08x: %08x/%08x", context.name, cell[1], V.r32(cell[1]), cell[2]))
        initialized += 1
    end
    for _, row in ipairs(context.rpm) do
        local actual = V.predictedRPMOriginal(float(row[1]), V.r32(0xC12030 + 0x58A), row[2])
        local error = math.abs(actual - row[3]) / math.max(1, math.abs(row[3]))
        worst = math.max(worst, error)
        assert(error <= 1e-14 and bits(V.fd(actual)) == row[4], string.format(
            "%s predicted RPM gear%d speed%.9g: %.17g/%.17g bits%08x/%08x", context.name, row[2], float(row[1]), actual, row[3], bits(V.fd(actual)), row[4]))
        rpmCases += 1
    end
    for index, row in ipairs(context.selector) do
        apply(row.inputs)
        V.automaticShiftOriginal()
        for _, cell in ipairs(row.expected) do
            assert(V.r32(cell[1]) == cell[2], string.format("%s selector %d %08x: %08x/%08x", context.name, index,
                cell[1], V.r32(cell[1]), cell[2]))
        end
        local depth = V._fpu()
        assert(depth == 0, "automatic selector leaked FPU state")
        selectorCases += 1
    end
end
print(string.format("Original automatic shifts: %d initializer cells exact; %d predicted-RPM vectors (max relative %.3g, f32-down exact); %d selector cases bit-exact", initialized, rpmCases, worst, selectorCases))
