-- Shared read-only validation and transactional source helpers for the Watkins Glen Studio patch.
local SES = game:GetService("ScriptEditorService")
local M = {}

function M.normalize(source)
    return (source:gsub("\r\n", "\n"):gsub("\r", "\n"))
end

function M.fingerprint(source)
    source = M.normalize(source)
    local h = 2166136261
    for i = 1, #source do
        h = bit32.bxor(h, string.byte(source, i))
        -- Exact in a double: multiply by 403, then add the low byte shifted 24 bits.
        h = (h * 403 + bit32.band(h, 255) * 16777216) % 4294967296
    end
    return #source, h
end

function M.matches(source, fingerprint)
    if not fingerprint then return false end
    local length, hash = M.fingerprint(source)
    return length == fingerprint.bytes and hash == fingerprint.fnv32
end

function M.source(object)
    local editor = SES:GetEditorSource(object)
    assert(M.normalize(editor) == M.normalize(object.Source),
        "Save the open script editor before installing: " .. object:GetFullName())
    return editor
end

function M.write(object, source, expectedBefore)
    SES:UpdateSourceAsync(object, function(current)
        if expectedBefore ~= nil then
            assert(M.normalize(current) == M.normalize(expectedBefore),
                "Source changed during the operation: " .. object:GetFullName())
        end
        return source
    end)
    assert(M.normalize(M.source(object)) == M.normalize(source),
        "Studio did not save the complete source: " .. object:GetFullName())
end

function M.child(parent, name, optional)
    local found
    for _, item in ipairs(parent:GetChildren()) do
        if item.Name == name then
            assert(found == nil, "Duplicate instance name: " .. parent:GetFullName() .. "." .. name)
            found = item
        end
    end
    assert(optional or found, "Required instance missing: " .. parent:GetFullName() .. "." .. name)
    return found
end

function M.stop()
    assert(not game:GetService("RunService"):IsRunning(), "Stop Play/Run before applying or rolling back this patch")
end

function M.folders()
    local pkg = M.child(game:GetService("ReplicatedStorage"), "NR2003Lab")
    local core = M.child(pkg, "Core")
    local roblox = M.child(pkg, "Roblox")
    local cup = M.child(core, "NR2003Cup")
    assert(pkg:IsA("Folder") and core:IsA("Folder") and roblox:IsA("Folder") and cup:IsA("Folder"),
        "NR2003Lab must contain the existing Core, Roblox and Core.NR2003Cup folders")
    return pkg, {Core = core, Roblox = roblox, Server = game:GetService("ServerScriptService"),
        Client = M.child(game:GetService("StarterPlayer"), "StarterPlayerScripts")}
end

function M.resolve(folders, key, optional)
    local components = string.split(key, ".")
    local parent = assert(folders[components[1]], "Unsupported target root: " .. key)
    for i = 2, #components - 1 do parent = M.child(parent, components[i]) end
    return M.child(parent, components[#components], optional), parent, components[#components]
end

function M.payload(install, key)
    local object = M.child(install, "Sources")
    for _, name in ipairs(string.split(key, ".")) do object = M.child(object, name) end
    assert(object.ClassName == "ModuleScript", "Source payload is not a ModuleScript: " .. key)
    return M.source(object)
end

function M.origin()
    local model = M.child(workspace, "NR2003WatkinsGlen")
    assert(model.ClassName == "Model" and model:GetAttribute("TrackOriginEnabled") == true,
        "Run the visual asset installers before enabling Watkins Glen")
    local scale = model:GetAttribute("NR2003MetresPerStud")
    assert(type(scale) == "number" and math.abs(scale - 0.28) < 1e-12,
        "Watkins Glen visuals must use 0.28 metres per stud")
    local current, expected = {model:GetPivot():GetComponents()}, {CFrame.identity:GetComponents()}
    for i = 1, 12 do
        assert(math.abs(current[i] - expected[i]) < 1e-5,
            "Watkins Glen visual root pivot must remain identity after calibration")
    end
    local terrain, parts = false, 0
    for _, object in ipairs(model:GetDescendants()) do
        if object:GetAttribute("NR2003VisualKind") == "terrain" then terrain = true end
        if object:IsA("BasePart") then
            parts += 1
            assert(object.Anchored and not object.CanCollide and not object.CanTouch,
                "Track visuals must remain anchored and non-colliding: " .. object:GetFullName())
            if object.CanQuery then
                local kind, owner = nil, object.Parent
                while owner and owner ~= model do
                    kind = owner:GetAttribute("NR2003VisualKind")
                    if kind ~= nil then break end
                    owner = owner.Parent
                end
                assert(object:GetAttribute("NR2003TerrainQuery") == true and kind == "terrain",
                    "Only tagged terrain meshes may answer camera queries: " .. object:GetFullName())
            end
        end
    end
    assert(terrain and parts > 0, "Import and calibrate Watkins Glen terrain before installing the physics patch")
    return model
end

function M.snapshotAttribute(backup, object, name)
    local value = object:GetAttribute(name)
    backup:SetAttribute("Previous_" .. name .. "_Present", value ~= nil)
    backup:SetAttribute("Previous_" .. name, value)
end

function M.restoreAttribute(backup, object, name)
    if backup:GetAttribute("Previous_" .. name .. "_Present") then
        object:SetAttribute(name, backup:GetAttribute("Previous_" .. name))
    else
        object:SetAttribute(name, nil)
    end
end

return M
