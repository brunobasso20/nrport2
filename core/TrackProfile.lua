-- Computational/data subset of FUN_0050fbd0, NOT the complete INI/Profile API.
local Data = require(script and script.Parent.RecoveredData or "RecoveredData")
local Float32 = require(script and script.Parent.Float32 or "Float32")
local M = {}

-- In the source, 0xcceb79a3 is the float sentinel for an absent override.
local SENTINEL = -123456792
local function override(base, specific, key, default)
    local value = base and base[key]
    if value == nil then value = default end
    local replacement = specific and specific[key]
    if replacement ~= nil and replacement ~= SENTINEL then value = replacement end
    assert(type(value) == "number", "Track profile value must be a number: " .. key)
    return Float32.round(value)
end

-- Inputs are already parsed [track] and [track_<series suffix>] values.
-- These are scalar material factors in the original engine; they do not replace
-- a tire model, nor do they map directly to Roblox CustomPhysicalProperties.
function M.resolve(base, specific)
    local result = { surfaces = {} }
    for key, value in pairs(Data.trackDefaults) do
        result[key] = override(base, specific, key, value)
    end
    for i = 1, #Data.surfaces do
        local surface = Data.surfaces[i]
        local multiplier = override(base, specific, surface.key, 1)
        result.surfaces[i] = {
            index = surface.index, key = surface.key,
            multiplier = multiplier,
            effectiveScalar = Float32.round(surface.base * multiplier),
        }
    end
    return result
end

return M
