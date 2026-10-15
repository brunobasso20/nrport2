-- Server-side preset selection. The caller owns driver authorization and the reset/epoch operation.
local M = {}
M.names = table.freeze({"fast", "easy", "qualify", "jasper"})
local indices = {}
for index, name in ipairs(M.names) do indices[name] = index end

function M.next(name)
    local index = indices[name] or 1
    return M.names[index % #M.names + 1]
end

local function override(name)
    return string.sub(name, 1, 6) == "Setup_" or name == "SetupBrakeBias"
        or name == "SetupGrilleTape" or name == "SetupSpoiler"
end
local function tracked(name)
    return override(name) or name == "WatkinsGlenSetup" or name == "TrackSetupApplied" or name == "TrackSetupSHA256"
end

function M.cycle(car, resetCallback)
    assert(car:GetAttribute("NR2003Track") == "watkins_glen", "Setup cycling requires the original Watkins Glen track")
    assert(type(resetCallback) == "function", "Setup cycling requires a reset callback")
    local before = car:GetAttributes()
    local chosen = M.next(before.TrackSetupApplied or before.WatkinsGlenSetup or "fast")
    local ok, result, reason = pcall(function()
        for name in pairs(before) do if override(name) then car:SetAttribute(name, nil) end end
        car:SetAttribute("WatkinsGlenSetup", chosen)
        return resetCallback(chosen)
    end)
    if not ok or result == false then
        for name in pairs(car:GetAttributes()) do if tracked(name) then car:SetAttribute(name, nil) end end
        for name, value in pairs(before) do if tracked(name) then car:SetAttribute(name, value) end end
        error(ok and (reason or "The selected setup could not be applied") or result, 0)
    end
    return chosen
end

return M
