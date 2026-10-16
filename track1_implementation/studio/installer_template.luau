local Transaction=require(script:WaitForChild("Journal"))
local SurfaceSource=require(script:WaitForChild("SurfaceSource"))
local HostSource=require(script:WaitForChild("HostSource"))
local Rules=require(script:WaitForChild("Rules"))
local HudRule=require(script:WaitForChild("HudRule"))
local function patch(source)
    source=source:gsub("\r\n","\n")
    for _,rule in ipairs(Rules) do
        local marker,old,new=rule[1],rule[2],rule[3]
        if source:find(marker,1,true) then
            assert(source:find(new,1,true),"track1: hook was edited: "..marker)
        else
            local first,last=source:find(old,1,true)
            assert(first and not source:find(old,last+1,true),"track1: unsupported/ambiguous adapter hook "..marker)
            source=source:sub(1,first-1)..new..source:sub(last+1)
        end
    end
    return source
end
local function folder(name,explicit)
    if explicit then
        assert(explicit:IsDescendantOf(workspace) and (explicit:IsA("Folder") or explicit:IsA("Model")),
            "track1: folder reference must be a Folder or Model in Workspace")
        return explicit
    end
    local found={}
    for _,node in ipairs(workspace:GetDescendants()) do
        if node.Name==name and (node:IsA("Folder") or node:IsA("Model")) then found[#found+1]=node end
    end
    assert(#found==1,"track1: expected exactly one folder/model named "..name.."; found "..#found)
    return found[1]
end
local function parts(root)
    local result={}
    for _,part in ipairs(root:GetDescendants()) do if part:IsA("BasePart") then result[#result+1]=part end end
    assert(#result>0,"track1: empty geometry folder "..root:GetFullName())
    table.sort(result,function(a,b) return a.Name<b.Name end)
    return result
end
local function chooseSpawn(collision,colliders)
    local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances={collision};params.RespectCanCollide=true
    -- Prefer the oval's straight sections, and require space for all four tires.
    for priority=1,2 do
        for _,part in ipairs(colliders) do
            if priority==2 or part.Name:find("Oval",1,true) then
                local p=part.Position
                local hit=workspace:Raycast(p+Vector3.yAxis*(part.Size.Y/2+80),
                    -Vector3.yAxis*(part.Size.Y+240),params)
                if hit and hit.Normal.Y>0.999 then
                    local axis=part.Size.X>=part.Size.Z and part.CFrame.RightVector or part.CFrame.LookVector
                    local forward=Vector3.new(axis.X,0,axis.Z)
                    if forward.Magnitude<0.01 then continue end
                    forward=forward.Unit
                    local cf=CFrame.lookAt(hit.Position,hit.Position+forward,Vector3.yAxis)
                    local supported=true
                    for _,offset in ipairs({Vector3.new(-8,0,0),Vector3.new(-8-0.77/0.28,0,-1.21/0.28),
                        Vector3.new(-8+0.77/0.28,0,-1.21/0.28),Vector3.new(-8-0.77/0.28,0,1.59/0.28),
                        Vector3.new(-8+0.77/0.28,0,1.59/0.28)}) do
                        local point=cf:PointToWorldSpace(offset)
                        local road=workspace:Raycast(point+Vector3.yAxis*80,-Vector3.yAxis*240,params)
                        if not road or road.Normal.Y<0.995 or math.abs(road.Position.Y-hit.Position.Y)>1 then
                            supported=false;break
                        end
                    end
                    if supported then return cf+Vector3.yAxis*0.125 end
                end
            end
        end
    end
    error("track1: no clear, nearly level spawn found. Run with {spawnCFrame=CFrame...} on col")
end
local function apply(options)
    options=options or {}
    assert(not game:GetService("RunService"):IsRunning(),"Stop Play before installing track1")
    local package=assert(game:GetService("ReplicatedStorage"):FindFirstChild("NR2003Lab"),"NR2003Lab missing")
    local core=assert(package:FindFirstChild("Core"),"NR2003Lab.Core missing")
    local modules=assert(package:FindFirstChild("Roblox"),"NR2003Lab.Roblox missing")
    assert(core:FindFirstChild("NR2003CupVehicle") and core:FindFirstChild("NR2003Cup"),"Original Cup core missing")
    local adapter=assert(modules:FindFirstChild("CupChassisAdapter"),"CupChassisAdapter missing")
    local source=patch(adapter.Source)
    local hudChanges={}
    local starter=game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts")
    if starter then
        for _,client in ipairs(starter:GetDescendants()) do
            if client:IsA("LocalScript") then
                local current=client.Source
                local first,last=current:find(HudRule[1],1,true)
                if first and not current:find(HudRule[1],last+1,true) then
                    hudChanges[#hudChanges+1]={client,current:sub(1,first-1)..HudRule[2]..current:sub(last+1)}
                end
            end
        end
    end
    local storage=game:GetService("ServerStorage")
    if storage:FindFirstChild(Transaction.BACKUP) then
        local config=package:FindFirstChild("Track1Config")
        assert(config and config:GetAttribute("Track1PatchVersion")==1 and source==adapter.Source
            and core:FindFirstChild("NR2003Track1Surface") and core.NR2003Track1Surface.Source==SurfaceSource
            and modules:FindFirstChild("NR2003Track1") and modules.NR2003Track1.Source==HostSource,
            "Existing track1 backup: installation was changed; do not overwrite it")
        print("track1 already installed. Reset the car after editing its track parameters.");return true
    end
    assert(not package:FindFirstChild("Track1Config"),"Track1Config already exists without its installation journal")
    for _,entry in ipairs({{core,"NR2003Track1Surface",SurfaceSource},{modules,"NR2003Track1",HostSource}}) do
        local existing=entry[1]:FindFirstChild(entry[2])
        assert(not existing or existing:IsA("ModuleScript") and existing.Source==entry[3],
            "track1 module name collision; existing modules preserved: "..entry[2])
    end
    assert(not workspace:FindFirstChild("NR2003Track1Collision"),"NR2003Track1Collision already exists without this patch's journal")
    local visual=folder("vis",options.visual)
    local collision=folder("col",options.collision)
    assert(visual~=collision and not visual:IsDescendantOf(collision) and not collision:IsDescendantOf(visual),
        "vis and col must be separate geometry roots")
    local visuals,colliders=parts(visual),parts(collision)
    local world=assert(workspace:FindFirstChild("NR2003LabWorld"),
        "NR2003LabWorld missing; open the test place containing the existing car first")
    assert(not world:FindFirstChild("track1"),"A track1 spawn already exists; existing object preserved")
    local tx=Transaction.new()
    local warnings=0
    local function write(target,key,value) tx:write(target,"property",key,value) end
    local function attr(target,key,value) tx:write(target,"attribute",key,value) end
    local function optional(target,key,value)
        local ok,err=pcall(write,target,key,value)
        if not ok then warnings+=1;warn("track1: set "..key.." manually on "..target:GetFullName()..": "..tostring(err)) end
    end
    local ok,reason=pcall(function()
        local sm=core:FindFirstChild("NR2003Track1Surface") or tx:create("ModuleScript","NR2003Track1Surface",core)
        write(sm,"Source",SurfaceSource)
        local hm=modules:FindFirstChild("NR2003Track1") or tx:create("ModuleScript","NR2003Track1",modules)
        write(hm,"Source",HostSource)
        write(adapter,"Source",source)
        for _,entry in ipairs(hudChanges) do write(entry[1],"Source",entry[2]) end
        -- A persistent model keeps collision geometry available to predicted clients.
        -- Existing folder/part identities and all world CFrames are preserved.
        local stream=tx:create("Model","NR2003Track1Collision",workspace)
        write(stream,"ModelStreamingMode",Enum.ModelStreamingMode.Persistent)
        write(collision,"Parent",stream)
        for _,part in ipairs(visuals) do
            write(part,"Anchored",true);write(part,"CanCollide",false);write(part,"CanQuery",false)
            write(part,"CanTouch",false);write(part,"Transparency",0)
            if part:IsA("MeshPart") then optional(part,"RenderFidelity",Enum.RenderFidelity.Precise) end
            attr(part,"NRTrack","track1");attr(part,"INDY_Role","Visual")
        end
        for _,part in ipairs(colliders) do
            local index=part:GetAttribute("NRSurface")
            if index==nil then
                local hint=part:GetAttribute("INDY_Surface")
                index=(hint=="concrete" or part.Material==Enum.Material.Concrete) and 2 or 1
            end
            assert(index==1 or index==2,"track1: col expects asphalt=1 or concrete=2: "..part:GetFullName())
            local grip=part:GetAttribute("NRGripMultiplier")
            if grip==nil then grip=1 end
            assert(type(grip)=="number" and grip==grip and grip>=0 and grip<=4,"Invalid NRGripMultiplier")
            write(part,"Anchored",true);write(part,"CanCollide",true);write(part,"CanQuery",true)
            write(part,"CanTouch",false);write(part,"Transparency",1)
            write(part,"Material",index==2 and Enum.Material.Concrete or Enum.Material.Asphalt)
            if part:IsA("MeshPart") then optional(part,"CollisionFidelity",Enum.CollisionFidelity.PreciseConvexDecomposition) end
            attr(part,"NRSurface",index);attr(part,"NRGripMultiplier",grip)
            attr(part,"NRTrack","track1");attr(part,"INDY_Surface",index==2 and "concrete" or "asphalt")
            attr(part,"INDY_Role","Collision")
        end
        local spawn=tx:create("SpawnLocation","track1",world)
        write(spawn,"Size",Vector3.new(6,0.25,6))
        write(spawn,"CFrame",options.spawnCFrame or chooseSpawn(collision,colliders))
        write(spawn,"Anchored",true);write(spawn,"CanCollide",false);write(spawn,"CanQuery",false)
        write(spawn,"CanTouch",false);write(spawn,"Transparency",1)
        write(spawn,"Neutral",true);write(spawn,"Duration",0)
        attr(spawn,"NRTrack","track1")
        local config=tx:create("Folder","Track1Config",package)
        for name,value in pairs({TrackAsphaltGrip=1,TrackConcreteGrip=1,TrackTireHeat=1,TrackTireWear=1,
            TrackTireWearLoss=0.20000000298023224,TrackTireWearExponent=1,Track1PatchVersion=1}) do attr(config,name,value) end
        for name,target in pairs({CollisionRoot=collision,VisualRoot=visual,Spawn=spawn}) do
            local ref=tx:create("ObjectValue",name,config);write(ref,"Value",target)
        end
        -- Keep existing setup attributes, assists, prediction and all Watkins Glen files.
        -- Change only the track selector after the complete track1 scene is ready.
        attr(package,"NR2003Track","track1")
        tx:commit()
    end)
    if not ok then
        local restored,restoreError=pcall(function() tx:undo() end)
        error(tostring(reason)..(restored and " (all track1 changes restored)" or " (restore error: "..tostring(restoreError)..")"))
    end
    print(string.format("track1 v1.0.1 installed: %d visual parts, %d collision parts, %d property warnings. Start Play.",
        #visuals,#colliders,warnings))
    print("Car reset and player respawn use NR2003LabWorld.track1. Original Watkins Glen sources/spawn preserved.")
    return true
end
return apply
