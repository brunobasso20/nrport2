-- Actual tyre input regression against independently executed NR2003 1.2.0.1 x86.
-- luau -O2 --codegen tests/patch1201/run.luau
local Vehicle = require("../../core/NR2003CupVehicle")
local REF = require("./camber_reference")
local function get(name)
    local ok, module = pcall(require, "../../core/NR2003Cup/" .. name)
    return ok and module or nil
end
local V = Vehicle.fromLoader(get).V
local passed, failed = 0, 0
local function check(label, ok, detail)
    if ok then passed += 1 else failed += 1 end
    print((ok and "PASS  " or "FAIL  ") .. label .. (detail and ("  " .. detail) or ""))
end
local FLAT = {}
for wheel = 1, 4 do FLAT[wheel] = {0, 0, 1, 0, 0, 0, 0, 1, 1} end
local SCRATCH = 0xF7F240
local function sample(row)
    V.reset()
    for i = 0, 44 do V.wf32(SCRATCH + i * 4, 0) end
    V.wf32(SCRATCH + 4 * 4, 0.42)
    V.wf32(SCRATCH + 4 * 6, math.sin(row[4] / 2))
    V.wf32(SCRATCH + 4 * 9, math.cos(row[4] / 2))
    V.wf32(SCRATCH + 4 * 13, row[2]); V.wf32(SCRATCH + 4 * 19, row[2])
    V.w32(0xE847C8, SCRATCH); V.w32(0xE84664, 0xE84474)
    V._callx(0x5B4560, V.ROOT)
    for i = 0, 8 do V.wf32(V.INPUTS + 4 * i, i < 2 and row[3] or 0) end
    V.w8(0xE843FC, 1)
    V._callx(0x5B2B90, V.ROOT, V.INPUTS)
    V._tires(FLAT)
    local values = {}
    -- 0054cab0 stores its exact param11 in tyre+0x2bc, before any force branches.
    for wheel = 0, 1 do values[wheel + 1] = V.rf32(0xBF3A20 + wheel * 0xA39 + 0x2BC) end
    for i, record in ipairs({5, 8}) do
        local _, rotation = V.componentPose(record)
        values[i + 2] = rotation[8] -- world Z component of the wheel's local Y axis
    end
    return values
end
local TOL = 2e-6
local worst, comparisons, mismatches = 0, 0, 0
local samples = {}
for _, setup in ipairs(REF.setups) do
    local s = V.Setup.cupGarageDefault()
    V.Setup.set(s, "rideHeightLF", setup[1])
    check(string.format("original garage conversion at %.1f in", setup[1]), s[36] == setup[2])
    local ok = V.applySetup(s)
    check(string.format("build rideHeightLF %.1f in", setup[1]), ok)
    for _, row in ipairs(REF.rows) do
        if row[1] == setup[1] then
            local actual = sample(row)
            samples[#samples + 1] = {row, actual}
            for i = 1, 4 do
                local error = math.abs(actual[i] - row[i + 4])
                if actual[i] ~= actual[i] or math.abs(actual[i]) == math.huge or error > TOL then mismatches += 1 end
                worst = math.max(worst, error); comparisons += 1
            end
        end
    end
end
check("90 poses: actual tyre camber arguments and render axes match original x86", comparisons == 360 and mismatches == 0,
    string.format("%d values, max abs error %.9g, tolerance %.1g", comparisons, worst, TOL))
-- At fixed steering/roll, the prismatic multibody keeps its wheel orientation constant.
-- The separate tyre path adds suspension camber gain, so its input MUST vary with travel.
local tireChanges, renderChanges, steeringChanges, rollChanges = {}, {}, {}, {}
for _, setup in ipairs(REF.setups) do
    local byPose = {}
    for _, entry in ipairs(samples) do
        local r = entry[1]
        if r[1] == setup[1] then byPose[string.format("%.2f/%.1f/%.2f", r[2], r[3], r[4])] = entry[2] end
    end
    local a = byPose["0.00/0.0/0.00"]
    local b = byPose["0.10/0.0/0.00"]
    local c = byPose["0.00/0.2/0.00"]
    local d = byPose["0.00/0.0/0.05"]
    for wheel = 1, 2 do
        tireChanges[#tireChanges + 1] = math.abs(b[wheel] - a[wheel])
        renderChanges[#renderChanges + 1] = math.abs(b[wheel + 2] - a[wheel + 2])
        steeringChanges[#steeringChanges + 1] = math.abs(c[wheel] - a[wheel])
        rollChanges[#rollChanges + 1] = math.abs(d[wheel] - a[wheel])
    end
end
local function between(values, lo, hi)
    for _, v in ipairs(values) do if v ~= v or v < lo or v > hi then return false end end
    return true
end
check("0.10 m travel changes actual tyre camber input by 0.02..0.04", between(tireChanges, 0.02, 0.04))
check("render wheel axes stay constant with suspension travel", between(renderChanges, 0, 2e-6))
check("0.2 rad steering changes actual tyre camber input", between(steeringChanges, 0.001, 0.03))
check("0.05 rad chassis roll reaches actual tyre camber input", between(rollChanges, 0.04, 0.06))
-- Mutation check: disable only the front camber-gain constant in the committed reset image.
-- Every new sample restores that image, so all other setup/pose values remain the same.
local pristine = V._pristine()
local saved, addresses = {}, {}
for wheel = 0, 1 do
    local address = V.r32(0xC08224 + wheel * 4)
    addresses[wheel + 1] = address
    saved[wheel + 1] = buffer.readu32(pristine, address - V.base)
    buffer.writef32(pristine, address - V.base, 0)
end
local detected = 0
for _, row in ipairs(REF.rows) do
    if row[1] == REF.setups[#REF.setups][1] and row[2] == 0.1 and row[3] == 0 and row[4] == 0 then
        local actual = sample(row)
        for wheel = 1, 2 do if math.abs(actual[wheel] - row[wheel + 4]) > 0.01 then detected += 1 end end
    end
end
for i, address in ipairs(addresses) do buffer.writeu32(pristine, address - V.base, saved[i]) end
V.reset()
check("regression detects disabled camber gain on both front tyres", detected == 2)
print(string.format("Patch 1.2.0.1 camber: %d passed, %d failed", passed, failed))
if failed > 0 then error("patch1201 camber regression failed") end
