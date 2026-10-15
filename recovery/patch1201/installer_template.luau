local function norm(s) return (s:gsub("\r\n", "\n")) end
local function fnv(s)
    local h=2166136261
    for i=1,#s do
        h=bit32.bxor(h,string.byte(s,i))
        h=bit32.band(bit32.band(h,65535)*16777619+bit32.band(h,4294901760)*403,4294967295)
    end
    return h
end
local function apply()
    assert(not game:GetService("RunService"):IsRunning(),"Stop Play before installing presets and controls")
    local package=assert(game:GetService("ReplicatedStorage"):FindFirstChild("NR2003Lab"),"NR2003Lab missing")
    local modules=assert(package:FindFirstChild("Roblox"),"NR2003Lab.Roblox missing")
    local starter=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
    local servers=game:GetService("ServerScriptService")
    local specs={
-- @SOURCES@
    }
    local prediction=modules:FindFirstChild("PredictionServer")~=nil
    local changes={}
    for _,s in ipairs(specs) do
        if (s.id=="prediction" and not prediction) or (s.id=="legacy" and prediction) then continue end
        local target=s.parent:FindFirstChild(s.name)
        if target then
            assert(target:IsA(s.class),s.name..": unexpected class")
            local current=norm(target.Source)
            if current==s.source then continue end
            assert(#current==s.oldLen and fnv(current)==s.oldHash,s.name..": source differs from verified baseline; update refused")
        else assert(s.oldLen==0,s.name..": required existing script missing") end
        s.target=target;changes[#changes+1]=s
    end
    if #changes==0 then print("Official presets and K / , controls already installed");return true end
    local storage=game:GetService("ServerStorage")
    assert(not storage:FindFirstChild("NR2003Backup_Patch1201"),"Previous patch backup exists; restore it before a partial reinstall")
    local backup=Instance.new("Folder");backup.Name="NR2003Backup_Patch1201";backup.Parent=storage
    local applied={}
    local ok,reason=pcall(function()
        for i,s in ipairs(changes) do
            local item=Instance.new("Folder");item.Name=tostring(i);item.Parent=backup
            local ref=Instance.new("ObjectValue");ref.Name="Target";ref.Parent=item
            local original=Instance.new("StringValue");original.Name="OriginalSource"
            original.Value=s.target and s.target.Source or "";original.Parent=item
            item:SetAttribute("Added",s.target==nil)
            item:SetAttribute("NewHash",fnv(s.source));item:SetAttribute("NewBytes",#s.source)
            if not s.target then s.target=Instance.new(s.class);s.target.Name=s.name;s.target.Parent=s.parent end
            ref.Value=s.target;applied[#applied+1]={target=s.target,added=item:GetAttribute("Added"),source=original.Value}
            s.target.Source=s.source
            assert(norm(s.target.Source)==s.source,s.name..": source readback differs")
        end
    end)
    if not ok then
        for i=#applied,1,-1 do local s=applied[i];if s.added then s.target:Destroy() else s.target.Source=s.source end end
        backup:Destroy();error(reason)
    end
    print("Official Watkins Glen FAST/QUALIFY installed; EASY/JASPER preserved. K cycles presets and resets at spawn; , toggles telemetry. Start Play again.")
    return true
end
