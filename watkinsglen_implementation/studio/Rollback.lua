-- Run outside Play: require(game.ServerStorage.NR2003Backup_WatkinsGlen.Rollback)()
-- Restores the pre-install source/attributes and any moved generated bench. Track visuals stay imported.
return function()
    local backup = script.Parent
    local H = require(backup.Support)
    H.stop()
    assert(backup.Name == "NR2003Backup_WatkinsGlen" and backup.ClassName == "Folder",
        "Run the Rollback module stored in ServerStorage.NR2003Backup_WatkinsGlen")
    local pkg, folders = H.folders()
    local entries = H.child(backup, "Entries")
    local plan, problems = {}, {}
    local activePatch = pkg:GetAttribute("NR2003WatkinsGlenPatch")
    assert(activePatch == nil or activePatch == backup:GetAttribute("Bundle"),
        "A different Watkins Glen patch is active; this backup cannot roll it back")
    for _, entry in ipairs(entries:GetChildren()) do
        local object = H.resolve(folders, entry.Name, true)
        local original = H.child(entry, "Original", true)
        local source = original and H.source(original)
        local expectedOld = {bytes = entry:GetAttribute("OldBytes"), fnv32 = entry:GetAttribute("OldHash")}
        if source then assert(H.matches(source, expectedOld), "Original backup was edited: " .. entry.Name) end
        local added = entry:GetAttribute("Added") == true
        if not object and not added then
            table.insert(problems, entry.Name .. " was removed after installation")
        elseif object then
            local current = object:IsA("LuaSourceContainer") and H.source(object)
            if object.ClassName ~= entry:GetAttribute("Class") or not current or
                (not H.matches(current, {bytes = entry:GetAttribute("NewBytes"), fnv32 = entry:GetAttribute("NewHash")})
                    and not H.matches(current, source and expectedOld or nil)) then
                table.insert(problems, entry.Name .. " has local changes; rollback will not overwrite them")
            else table.insert(plan, {object = object, source = source, current = current, added = added}) end
        end
    end
    local moved = H.child(backup, "MovedBench", true)
    local bench, parent
    if moved then
        bench = H.child(moved, "TestTrack")
        parent = H.child(moved, "OriginalParent").Value
        assert(parent and parent:IsDescendantOf(workspace), "Original generated bench parent no longer exists")
        assert(H.child(parent, bench.Name, true) == nil, "A different TestTrack blocks restoration of the saved bench")
    end
    assert(#problems == 0, "Rollback refused; nothing was changed:\n  " .. table.concat(problems, "\n  "))

    -- Keep added modules intact in a temporary folder until every original source is restored.
    local removed = Instance.new("Folder"); removed.Name = "RollbackStaging"; removed.Parent = backup
    local touched, movedObjects = {}, {}
    local priorTrack, priorPatch = pkg:GetAttribute("NR2003Track"), pkg:GetAttribute("NR2003WatkinsGlenPatch")
    local ok, reason = pcall(function()
        for _, change in ipairs(plan) do
            if change.added then
                table.insert(movedObjects, {object = change.object, parent = change.object.Parent})
                change.object.Parent = removed
            else
                table.insert(touched, change)
                H.write(change.object, change.source, change.current)
            end
        end
        H.restoreAttribute(backup, pkg, "NR2003Track")
        H.restoreAttribute(backup, pkg, "NR2003WatkinsGlenPatch")
        if bench then bench.Parent = parent end
    end)
    if not ok then
        local restored, restoreReason = pcall(function()
            if bench and bench.Parent == parent then bench.Parent = moved end
            pkg:SetAttribute("NR2003Track", priorTrack); pkg:SetAttribute("NR2003WatkinsGlenPatch", priorPatch)
            for i = #touched, 1, -1 do H.write(touched[i].object, touched[i].current) end
            for _, change in ipairs(movedObjects) do change.object.Parent = change.parent end
            removed:Destroy()
        end)
        assert(restored, "Rollback and its recovery failed; retain the ServerStorage backup:\n" ..
            tostring(reason) .. "\n" .. tostring(restoreReason))
        error("Rollback failed; installed state was restored:\n" .. tostring(reason))
    end
    removed:Destroy()
    backup:Destroy()
    print("Watkins Glen patch rolled back. Previous sources, package attributes and generated bench restored; imported car and track visuals retained.")
    return true
end
