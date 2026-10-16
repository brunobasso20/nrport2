local Transaction=require(script.Journal)
local Sources=require(script.Sources)
local Rules=require(script.Rules)
local function patch(source,kind)
    source=source:gsub("\r\n","\n")
    local list=Rules[kind]
    if kind=="client" and source:find("local carModel",1,true) then list=Rules.carClient end
    for _,rule in ipairs(list) do
        local marker,old,new=rule[1],rule[2],rule[3]
        if source:find(marker,1,true) then
            assert(source:find(new,1,true),"Edited audio hook: "..marker)
        else
            local first,last=source:find(old,1,true)
            assert(first and not source:find(old,last+1,true),"Unsupported/ambiguous audio "..kind.." hook: "..marker)
            source=source:sub(1,first-1)..new..source:sub(last+1)
        end
    end
    return source
end
return function()
    assert(not game:GetService("RunService"):IsRunning(),"Stop Play before installing audio")
    local package=assert(game:GetService("ReplicatedStorage"):FindFirstChild("NR2003Lab"),"NR2003Lab missing")
    local core=assert(package:FindFirstChild("Core"),"Original Cup core missing")
    assert(core:FindFirstChild("NR2003CupVehicle"),"Original Cup vehicle missing")
    local server=assert(game:GetService("ServerScriptService"):FindFirstChild("NR2003Server"),"NR2003Server missing")
    local starter=game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts")
    local client=assert(starter and starter:FindFirstChild("NR2003Client"),"NR2003Client missing")
    assert(server:IsA("Script") and client:IsA("LocalScript"),"Unexpected NR2003 scripts")
    -- Validate every source anchor before changing any object.
    local serverSource,clientSource=patch(server.Source,"server"),patch(client.Source,"client")
    local storage=game:GetService("ServerStorage")
    local installed=storage:FindFirstChild(Transaction.BACKUP)
    local folder=package:FindFirstChild("Audio")
    if installed then
        assert(folder and folder:GetAttribute("NR2003AudioVersion")=="1.1.0","Incomplete audio installation")
        assert(serverSource==server.Source and clientSource==client.Source,"Audio hooks changed after installation")
        for name,source in pairs(Sources) do
            local m=folder:FindFirstChild(name)
            assert(m and m.Source==source,"Installed audio source changed: "..name)
        end
        print("NR2003 audio already installed; no changes")
        return true
    end
    assert(not folder,"NR2003Lab.Audio exists without this patch's backup; refusing to overwrite it")
    local tx=Transaction.new()
    local ok,reason=pcall(function()
        folder=tx:create("Folder","Audio",package)
        tx:write(folder,"attribute","NR2003AudioVersion","1.1.0")
        for name,source in pairs(Sources) do
            local module=tx:create("ModuleScript",name,folder);tx:write(module,"property","Source",source)
        end
        tx:write(server,"property","Source",serverSource);tx:write(client,"property","Source",clientSource)
        if package:GetAttribute("NR2003AudioProfile")==nil then
            tx:write(package,"attribute","NR2003AudioProfile","NR2003_ORIGINAL_REFERENCE")
        end
        if package:GetAttribute("NR2003AudioEnabled")==nil then tx:write(package,"attribute","NR2003AudioEnabled",true) end
        tx:commit()
    end)
    if not ok then tx:undo();error(reason) end
    print("NR2003 audio installed. Link local original CES/WAV resources; missing assets remain silent. Place was not saved.")
    return true
end
