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

-- Acquire before any source operation can yield. Separate imported copies share
-- the same DataModel lock; module-local flags cannot protect those copies.
function M.exclusive(owner, operation, callback)
    M.stop()
    local storage = game:GetService("ServerStorage")
    assert(M.child(storage, "NR2003WatkinsGlenOperation", true) == nil,
        "A Watkins Glen install or rollback is already running; wait for its final output before running another command")
    local lock = Instance.new("Folder")
    lock.Name = "NR2003WatkinsGlenOperation"
    lock:SetAttribute("Operation", operation)
    lock:SetAttribute("StartedUTC", os.time())
    local reference = Instance.new("ObjectValue")
    reference.Name = "Owner"; reference.Value = owner; reference.Parent = lock
    lock.Parent = storage
    local result = table.pack(pcall(callback))
    lock:Destroy()
    if not result[1] then error(result[2], 0) end
    return table.unpack(result, 2, result.n)
end

function M.backupEntries(backup, manifest)
    local entries = M.child(backup, "Entries")
    assert(entries.ClassName == "Folder", "Backup Entries is not a Folder")
    assert(#entries:GetChildren() == #manifest.targets,
        "Backup entry count is incomplete; live sources were not changed")
    local verified = {}
    for _, item in ipairs(manifest.targets) do
        local entry = M.child(entries, item.key)
        assert(entry.ClassName == "Folder" and entry:GetAttribute("Class") == item.class and
            entry:GetAttribute("NewBytes") == item.new.bytes and entry:GetAttribute("NewHash") == item.new.fnv32,
            "Backup metadata is incompatible: " .. item.key)
        local target = M.child(entry, "Target")
        assert(target.ClassName == "ObjectValue", "Backup target reference is invalid: " .. item.key)
        local original = M.child(entry, "Original", true)
        local added = entry:GetAttribute("Added")
        assert(type(added) == "boolean" and (not added or item.old == nil)
            and (added and original == nil or not added and original ~= nil),
            "Backup original is incomplete: " .. item.key)
        if original then
            assert(original.ClassName == "ModuleScript", "Backup original has an invalid class: " .. item.key)
            local source = M.source(original)
            assert(M.matches(source, {bytes = entry:GetAttribute("OldBytes"), fnv32 = entry:GetAttribute("OldHash")})
                and (M.matches(source, item.old) or M.matches(source, item.new)),
                "Original backup was edited: " .. item.key)
        end
        verified[item.key] = {entry = entry, reference = target}
    end
    return entries, verified
end

-- Recover only the state observed in the supplied export: every original target
-- restored, every added track module absent, attributes restored, no moved bench.
-- Retain the entire stale backup under a different name rather than delete it.
function M.archiveRestoredBackup(backup, manifest, plan, pkg, folders)
    assert(backup.ClassName == "Folder" and backup:GetAttribute("Complete") ~= true,
        "Only an unfinished Watkins Glen backup can be recovered automatically")
    local bundle = backup:GetAttribute("Bundle")
    local known = bundle == manifest.bundle
    for _, previous in ipairs(manifest.previousBundles) do if bundle == previous then known = true end end
    assert(known, "Unrecognized unfinished backup; retain it for inspection")
    for _, change in ipairs(plan) do
        local original = change.item.old
        assert(original and change.old and M.matches(change.old, original) or original == nil and change.object == nil,
            "Unfinished backup retained: live target is not fully restored: " .. change.item.key)
    end
    if bundle ~= manifest.bundle then
        for _, item in ipairs(manifest.recoveryTargets) do
            local object = M.resolve(folders, item.key, true)
            assert(object and object.ClassName == item.class and M.matches(M.source(object), item.old),
                "Unfinished earlier backup retained: original server was not restored: " .. item.key)
        end
    end
    assert(pkg:GetAttribute("NR2003WatkinsGlenPatch") == nil and pkg:GetAttribute("NR2003Track") ~= "watkins_glen",
        "Unfinished backup retained: the track patch is still active")
    for _, name in ipairs({"NR2003Track", "NR2003WatkinsGlenPatch"}) do
        local expected = nil
        if backup:GetAttribute("Previous_" .. name .. "_Present") then expected = backup:GetAttribute("Previous_" .. name) end
        assert(pkg:GetAttribute(name) == expected, "Unfinished backup retained: package attribute was not restored: " .. name)
    end
    assert(M.child(backup, "MovedBench", true) == nil and M.child(backup, "RollbackStaging", true) == nil,
        "Unfinished backup retained: bench or rollback staging needs recovery")
    local name = "NR2003Backup_WatkinsGlen_Recovered_" .. tostring(os.time())
    local unique, suffix = name, 1
    while M.child(backup.Parent, unique, true) do suffix += 1; unique = name .. "_" .. tostring(suffix) end
    backup.Name = unique
    backup:SetAttribute("RecoveredUTC", os.time())
    print("Verified restored live sources; unfinished backup retained as ServerStorage." .. unique)
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
