local function norm(s) return (s:gsub("\r\n","\n")) end
local function fnv(s)
    local h=2166136261
    for i=1,#s do
        h=bit32.bxor(h,string.byte(s,i))
        h=bit32.band(bit32.band(h,65535)*16777619+bit32.band(h,4294901760)*403,4294967295)
    end
    return h
end
local function apply()
    assert(not game:GetService("RunService"):IsRunning(),"Stop Play before installing driving assists")
    local package=assert(game:GetService("ReplicatedStorage"):FindFirstChild("NR2003Lab"),"NR2003Lab missing")
    local core=assert(package:FindFirstChild("Core"),"NR2003Lab.Core missing")
    local cup=assert(core:FindFirstChild("NR2003Cup"),"Original Cup core missing")
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
        if s.id=="track" and not cup:FindFirstChild(s.name) then continue end
        local target=s.parent:FindFirstChild(s.name)
        if target then
            assert(target:IsA(s.class),s.name..": unexpected class")
            local current=norm(target.Source)
            if current==s.source then continue end
            local accepted=false
            for _,old in ipairs(s.baselines) do
                if #current==old[1] and fnv(current)==old[2] then accepted=true;break end
            end
            assert(accepted,s.name..": source differs from verified Studio/repository baseline; update refused")
        else assert(s.added,s.name..": required script missing") end
        s.target=target;changes[#changes+1]=s
    end
    if #changes==0 then print("assist_implementation already installed");return true end
    local storage=game:GetService("ServerStorage")
    assert(not storage:FindFirstChild("NR2003Backup_Assists"),"Existing assist backup: roll back before a partial reinstall")
    local backup=Instance.new("Folder");backup.Name="NR2003Backup_Assists";backup.Parent=storage
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
    print("assist_implementation installed. Defaults: automatic, auto clutch, ABS on; TC/stability/boost off. K setups; comma telemetry. Start Play again.")
    return true
end
return apply
