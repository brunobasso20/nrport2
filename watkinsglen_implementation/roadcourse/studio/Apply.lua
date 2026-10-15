-- Run in Studio's Command Bar outside Play:
-- require(workspace.NR2003_WatkinsGlen_RoadCourseV6.Apply)()
-- No simulation modules or uploaded scripts are executed by this installer.
local function applyLocked(install, H, manifest)
    local pkg, folders = H.folders()
    H.origin()
    local storage = game:GetService("ServerStorage")
    local older = storage:FindFirstChild("NR2003Backup_WatkinsGlenHandlingV5")
    local baseManifest = older and require(install.BaseHandlingManifest) or require(install.BaseManifest)
    older = older or H.child(storage, "NR2003Backup_WatkinsGlen")
    assert(older.ClassName == "Folder" and older:GetAttribute("Complete") == true and
        older:GetAttribute("Bundle") == baseManifest.bundle, "V6 requires the complete retained V5 backup")
    H.backupEntries(older, baseManifest)
    assert(pkg:GetAttribute("NR2003Track") == "watkins_glen" and
        (pkg:GetAttribute("NR2003WatkinsGlenPatch") == baseManifest.bundle or
         pkg:GetAttribute("NR2003WatkinsGlenPatch") == manifest.bundle),
        "RoadCourse V6 requires the installed V5; use the shipped V5 installer first")
    local existingBackup = H.child(storage, "NR2003Backup_WatkinsGlenRoadCourseV6", true)
    if existingBackup then
        assert(existingBackup.ClassName == "Folder", "Watkins Glen backup is not a Folder")
        if existingBackup:GetAttribute("Complete") == true then
            assert(existingBackup:GetAttribute("Bundle") == manifest.bundle,
                "A backup from a different Watkins Glen patch exists; roll back that patch before updating")
            H.backupEntries(existingBackup, manifest)
        end
    end

    -- All payloads, targets and required solver dependencies are checked before mutation.
    local problems, plan = {}, {}
    for _, item in ipairs(manifest.targets) do
        local payload = H.payload(install, item.key)
        assert(H.matches(payload, item.new), "Bundled source is incomplete: " .. item.key)
        local object, parent, name = H.resolve(folders, item.key, true)
        local source = object and object:IsA("LuaSourceContainer") and H.source(object) or nil
        if object and object.ClassName ~= item.class then
            table.insert(problems, item.key .. " has an unexpected instance class")
        elseif object == nil and item.old ~= nil then
            table.insert(problems, item.key .. " is missing from the existing Stage 13 installation")
        elseif source and not H.matches(source, item.new) and not H.matches(source, item.old) then
            table.insert(problems, item.key .. " contains local changes; this patch will not overwrite them")
        else
            table.insert(plan, {item = item, object = object, parent = parent, name = name,
                old = source, payload = payload, current = source and H.matches(source, item.new)})
        end
    end
    for _, check in ipairs(manifest.dependencies) do
        local object = H.resolve(folders, check.key, true)
        local accepted = false
        if object and object.ClassName == check.class then
            local source = H.source(object)
            for _, expected in ipairs(check.accepted) do
                if H.matches(source, expected) then accepted = true; break end
            end
        end
        if not accepted then table.insert(problems, check.key .. " is incompatible with the recovered track runtime") end
    end
    local world = H.child(workspace, "NR2003LabWorld", true)
    local bench = world and H.child(world, "TestTrack", true)
    if bench then
        assert(bench.ClassName == "Folder", "NR2003LabWorld.TestTrack is not the generated bench folder")
        assert(not existingBackup or not H.child(existingBackup, "MovedBench", true),
            "A second TestTrack appeared after installation; move it manually before reapplying")
    end
    local car = world and H.child(world, "TestCar", true)
    if car then
        local setup = car:GetAttribute("WatkinsGlenSetup")
        assert(setup == nil or setup == "fast" or setup == "easy" or setup == "qualify" or setup == "jasper",
            "TestCar.WatkinsGlenSetup must be fast, easy, qualify or jasper")
        assert(car:GetAttribute("AeroSession") ~= false and car:GetAttribute("Stage11Runtime") ~= "frozen",
            "Watkins Glen requires AeroSession enabled and Stage11Runtime original")
    end
    assert(#problems == 0, "Watkins Glen patch refused; nothing was changed:\n  " .. table.concat(problems, "\n  "))

    if existingBackup and existingBackup:GetAttribute("Complete") ~= true then
        H.archiveRestoredBackup(existingBackup, manifest, plan, pkg, folders)
        existingBackup = nil
    end

    local backup = existingBackup
    local createdBackup = backup == nil
    local entries, verifiedEntries
    if createdBackup then
        local prepared, prepareReason = pcall(function()
            backup = Instance.new("Folder")
            backup.Name = "NR2003Backup_WatkinsGlenRoadCourseV6"
            backup:SetAttribute("Bundle", manifest.bundle)
            backup:SetAttribute("CreatedUTC", os.time())
            backup:SetAttribute("Complete", false)
            -- ScriptEditorService operates on scripts in the DataModel. The
            -- incomplete owned backup is parented before any source write.
            backup.Parent = storage
            H.snapshotAttribute(backup, pkg, "NR2003Track")
            H.snapshotAttribute(backup, pkg, "NR2003WatkinsGlenPatch")
            entries = Instance.new("Folder"); entries.Name = "Entries"; entries.Parent = backup
            for _, moduleName in ipairs({"Support", "Rollback", "Manifest"}) do
                local clone = install[moduleName]:Clone(); clone.Parent = backup
            end
            for _, change in ipairs(plan) do
                local entry = Instance.new("Folder"); entry.Name = change.item.key; entry.Parent = entries
                entry:SetAttribute("Added", change.object == nil)
                entry:SetAttribute("Class", change.item.class)
                entry:SetAttribute("NewBytes", change.item.new.bytes)
                entry:SetAttribute("NewHash", change.item.new.fnv32)
                local reference = Instance.new("ObjectValue"); reference.Name = "Target"
                reference.Value = change.object; reference.Parent = entry
                if change.old then
                    local saved = Instance.new("ModuleScript"); saved.Name = "Original"; saved.Parent = entry
                    H.write(saved, change.old)
                    local bytes, hash = H.fingerprint(change.old)
                    entry:SetAttribute("OldBytes", bytes); entry:SetAttribute("OldHash", hash)
                end
            end
            entries, verifiedEntries = H.backupEntries(backup, manifest)
            backup:SetAttribute("Prepared", true)
        end)
        if not prepared then
            local cleaned, cleanReason = pcall(function() if backup then backup:Destroy() end end)
            assert(cleaned, "Backup preparation and cleanup failed; retain the incomplete ServerStorage backup:\n" ..
                tostring(prepareReason) .. "\n" .. tostring(cleanReason))
            error("Watkins Glen backup preparation failed; live sources and attributes were not changed:\n" ..
                tostring(prepareReason))
        end
    else
        entries, verifiedEntries = H.backupEntries(backup, manifest)
    end

    local touched, movedBench = {}, nil
    local priorTrack, priorPatch = pkg:GetAttribute("NR2003Track"), pkg:GetAttribute("NR2003WatkinsGlenPatch")
    local function apply()
        for _, change in ipairs(plan) do
            if not change.current then
                local saved = verifiedEntries[change.item.key]
                assert(entries.Parent == backup and saved.entry.Parent == entries and saved.reference.Parent == saved.entry,
                    "Backup entry was removed during installation: " .. change.item.key)
                local object = change.object
                if not object then
                    object = Instance.new(change.item.class); object.Name = change.name
                    object.Parent = change.parent
                end
                table.insert(touched, {object = object, old = change.old, added = change.object == nil})
                saved.reference.Value = object
                H.write(object, change.payload, change.old)
                assert(H.matches(H.source(object), change.item.new), "Source verification failed: " .. change.item.key)
                assert(entries.Parent == backup and saved.entry.Parent == entries and saved.reference.Parent == saved.entry,
                    "Backup entry was removed during installation: " .. change.item.key)
            end
        end
        if bench then
            movedBench = Instance.new("Folder"); movedBench.Name = "MovedBench"
            local parent = Instance.new("ObjectValue"); parent.Name = "OriginalParent"
            parent.Value = bench.Parent; parent.Parent = movedBench
            movedBench.Parent = backup
            bench.Parent = movedBench
        end
        pkg:SetAttribute("NR2003Track", "watkins_glen")
        pkg:SetAttribute("NR2003WatkinsGlenPatch", manifest.bundle)
        backup:SetAttribute("Complete", true)
    end
    local ok, reason = pcall(apply)
    if not ok then
        local restored, restoreReason = pcall(function()
            pkg:SetAttribute("NR2003Track", priorTrack); pkg:SetAttribute("NR2003WatkinsGlenPatch", priorPatch)
            if movedBench then bench.Parent = world; movedBench:Destroy() end
            for i = #touched, 1, -1 do
                local change = touched[i]
                if change.added then change.object:Destroy() else H.write(change.object, change.old) end
            end
            if createdBackup then backup:Destroy() end
        end)
        if not restored then
            backup:SetAttribute("Complete", false)
            error("Installation failed and automatic recovery was incomplete. Backup retained in ServerStorage.\n" ..
                tostring(reason) .. "\nRecovery error: " .. tostring(restoreReason))
        end
        error("Watkins Glen installation failed; prior sources, attributes and bench were restored:\n" .. tostring(reason))
    end
    print("Watkins Glen V6 installed: road-course chassis 4, original tire profile 8 and track HUD; backup: ServerStorage.NR2003Backup_WatkinsGlenRoadCourseV6")
    print("Rollback outside Play: require(game.ServerStorage.NR2003Backup_WatkinsGlenRoadCourseV6.Rollback)()")
    return true, manifest.bundle
end

return function()
    local install = script.Parent
    local H = require(install.Support)
    local manifest = require(install.Manifest)
    return H.exclusive(install, "install", function() return applyLocked(install, H, manifest) end)
end
