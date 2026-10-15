-- Official patch setup bytes -> imported module -> original x86 load results -> road-course build/contact.
-- luau -O2 --codegen tests/patch1201/run_setups.luau
local Vehicle = require("../../core/NR2003CupVehicle")
local Setups = require("../../roblox/NR2003WatkinsGlenSetup")
local Reference = require("./setup_reference")
local Legacy = require("../../watkinsglen_implementation/handling/tests/setup_load_fixtures")
local function get(name)
    for _, dir in ipairs({"../../core/NR2003Cup/", "../../watkinsglen_implementation/core/NR2003Cup/"}) do
        local ok, module = pcall(require, dir .. name)
        if ok then return module end
    end
    return nil
end
local car = Vehicle.fromLoader(get)
local V, Setup = car.V, car.V.Setup
local passed, failed = 0, 0
local function check(label, ok, detail)
    if ok then passed += 1 else failed += 1 end
    print((ok and "PASS  " or "FAIL  ") .. label .. (detail and ("  " .. detail) or ""))
end
local alphabet, digits = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", {}
for i = 1, #alphabet do digits[string.byte(alphabet, i)] = i - 1 end
local function base64(text)
    local data, offset = buffer.create(#text * 3 // 4), 0
    for i = 1, #text, 4 do
        local a, b, c, d = string.byte(text, i, i + 3)
        local word = digits[a] * 262144 + digits[b] * 4096 + (digits[c] or 0) * 64 + (digits[d] or 0)
        buffer.writeu8(data, offset, bit32.rshift(word, 16)); offset += 1
        if c ~= 61 then buffer.writeu8(data, offset, bit32.band(bit32.rshift(word, 8), 255)); offset += 1 end
        if d ~= 61 then buffer.writeu8(data, offset, bit32.band(word, 255)); offset += 1 end
    end
    return data, offset
end
for _, name in ipairs({"fast", "qualify"}) do
    local reference = Reference.profiles[name]
    local bytes, length = base64(reference.chunkBase64)
    check(name .. " official DGTS payload size", length == #reference.fields * 4)
    local rawDifferences, rawCount = 0, 0
    local inspectingSetup = {defaults=Setup.defaults, validateLoaded=function(items)
        for position, item in ipairs(reference.fields) do
            if items[item] ~= buffer.readu32(bytes, 4 * (position - 1)) then rawDifferences += 1 end
            rawCount += 1
        end
        return Setup.validateLoaded(items)
    end}
    local items, selected, hash = Setups.new(inspectingSetup, name)
    check(name .. " raw values match original official patch bytes", rawCount == 68 and rawDifferences == 0,
        string.format("%d fields, %d differences", rawCount, rawDifferences))
    check(name .. " selected source hash", selected == name and hash == reference.fileSHA256)
    local differences, count = 0, 0
    for item, wanted in pairs(reference.loadedOriginal) do
        if items[item] ~= wanted then differences += 1 end
        count += 1
    end
    check(name .. " file load matches original x86 decoder/validator", count == 70 and differences == 0,
        string.format("%d fields, %d differences", count, differences))
end
-- These profiles were not replaced by the supplied patch; preserve their established values and source identities.
for name, hash in pairs({easy="57bfd898dc8b293c058333a6957239b8dd0931e47298a3b0035cff2f0104292d",
    jasper="99e32fd4f6cc752e55bcd3c697f761446489d4e672a232c3fcef95981dae57bf"}) do
    local items, selected, gotHash = Setups.new(Setup, name)
    local same = selected == name and gotHash == hash
    for item, wanted in pairs(Legacy[name]) do same = same and items[item] == wanted end
    check(name .. " source and loaded settings preserved", same)
end
check("default profile is patched fast", select(3, Setups.new(Setup)) == Reference.profiles.fast.fileSHA256)
check("unknown setup rejected", not pcall(Setups.new, Setup, "unknown"))
check("original road-course track loads", car:loadTrack())
for _, name in ipairs({"fast", "qualify"}) do
    local items = Setups.new(Setup, name)
    local ok, report = car:applySetup(items)
    check(name .. " original road-course setup build", ok and report.structure == "generic",
        "structure=" .. tostring(report.structure))
    local applied = car:setup()
    local pressureMatches = true
    for wheel = 0, 3 do pressureMatches = pressureMatches and applied[wheel] == Reference.profiles[name].loadedOriginal[wheel] end
    check(name .. " all four official tyre pressures reach the built car", pressureMatches)
    car:startSession({temperatureF=70}, {damageLevel=0})
    V.setControlsSuspended(false)
    local supported, finite = false, true
    for _ = 1, 96 do
        car:step({originalPedals=true, throttle=0, throttleControl=0, brakeControl=0,
            clutch=1, steerLeft=0, steerRight=0, steerDigital=true})
        for _, value in ipairs(V.state()) do finite = finite and value == value and math.abs(value) < math.huge end
        for wheel = 0, 3 do supported = supported or V.trackContact(wheel, {}).grounded end
    end
    check(name .. " finite placed state with original tyre contacts", finite and supported and V.worldActive())
    car:endSession()
end
print(string.format("Patch 1.2.0.1 Watkins setups: %d passed, %d failed", passed, failed))
assert(failed == 0, "official patch setup regression failed")
