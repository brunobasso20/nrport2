-- Optional mesh-contact host. The original NR2003 tire/thermal/wear solver is retained.
-- No original Watkins Glen geometry, placement or material settings are loaded in this mode.
local package=script.Parent.Parent
local Surface=require(package.Core.NR2003Track1Surface)
local M={TRACK="track1",METRES_PER_STUD=0.28}
function M.enabled() return package:GetAttribute("NR2003Track")==M.TRACK end
local function reference(config,name)
    local value=config:FindFirstChild(name)
    return assert(value and value.Value,"track1: missing reference "..name)
end
function M.attach(controller)
    if not M.enabled() then return false end
    assert(math.abs(controller.tune.metresPerStud-M.METRES_PER_STUD)<1e-12,
        "track1 and the car require 0.28 metres per stud")
    local config=assert(package:FindFirstChild("Track1Config"),"Install the track1 patch in Edit mode first")
    controller.track1Config=config
    controller.track1Col=reference(config,"CollisionRoot")
    controller.track1Spawn=reference(config,"Spawn")
    assert(controller.track1Col:IsDescendantOf(workspace),"track1: col is not in Workspace")
    assert(controller.track1Spawn:IsA("SpawnLocation") and controller.track1Spawn.Name=="track1",
        "track1: expected the dedicated SpawnLocation named track1")
    assert(not controller.core:trackLoaded(),"track1 cannot use the Watkins Glen native collision world")
    controller.track1=true
    controller.params.FilterType=Enum.RaycastFilterType.Include
    controller.params.FilterDescendantsInstances={controller.track1Col}
    controller.car:SetAttribute("NR2003Track",M.TRACK)
    controller.car:SetAttribute("TrackContactMode","track1 mesh raycasts / original NR2003 tires")
    return true
end
function M.origin(controller)
    local spawn=controller.track1Spawn
    assert(spawn:IsDescendantOf(workspace),"track1 spawn was removed from Workspace")
    -- Only yaw belongs in the numeric frame: aligning it to banking would tilt gravity.
    local f=spawn.CFrame.LookVector
    f=Vector3.new(f.X,0,f.Z)
    assert(f.Magnitude>0.01,"track1 spawn must have a horizontal heading")
    local yaw=CFrame.lookAt(spawn.Position,spawn.Position+f.Unit,Vector3.yAxis)
    local target=spawn.Position-yaw.RightVector*8
    local hit=workspace:Raycast(target+Vector3.yAxis*80,-Vector3.yAxis*240,controller.params)
    assert(hit and hit.Normal.Y>0.5,"track1: no road beneath car spawn; move track1 onto col")
    controller.spawn=(yaw-yaw.Position)+hit.Position+Vector3.yAxis*(0.42/M.METRES_PER_STUD)
    return (yaw-yaw.Position)+hit.Position
end
function M.applySurface(controller)
    assert(controller.car:GetAttribute("AeroSession")~=false,"track1 requires an active NR2003 session")
    assert(controller.car:GetAttribute("Stage11Runtime")~="frozen","track1 requires the tire thermal/wear runtime")
    local settings={}
    for key in pairs(Surface.DEFAULTS) do settings[key]=controller.track1Config:GetAttribute(key) end
    controller.track1Settings=Surface.apply(controller.core.V,settings)
    for name,value in pairs(controller.track1Settings) do controller.car:SetAttribute("Track1_"..name,value) end
end
function M.telemetry(controller)
    local result={name="track1",contactMode="mesh raycasts",wheels={},parameters=controller.track1Settings}
    for j,c in ipairs(controller.tune.corners) do
        local grounded=controller.inContact[j]
        local index=controller.planes[j][8]
        local b=controller.core:wheelBrake(j-1)
        local fx,fy,fz=grounded and b.fx or 0,grounded and b.fy or 0,grounded and b.fz or 0
        result.wheels[j]={name=c.name,grounded=grounded,surface=grounded and index or nil,
            surfaceGrip=grounded and controller.core.V.rf32(Surface.ADDRESS.loadedGrip+4*index) or 0,
            contactGripMultiplier=controller.planes[j][9],fx=fx,fy=fy,fz=fz,
            muUsed=fz>1 and math.sqrt(fx*fx+fy*fy)/fz or 0,slipVelocity=b.vslip}
        controller.car:SetAttribute("Track1_Grounded_"..c.name,grounded)
        controller.car:SetAttribute("Track1_Surface_"..c.name,grounded and index or -1)
    end
    return result
end
function M.clearDriverSpawn(controller)
    local state=controller.track1DriverState
    if not state then return end
    controller.track1DriverState=nil;state.closed=true
    for _,connection in ipairs(state.connections) do connection:Disconnect() end
    for player,entry in pairs(state.players) do
        entry.connection:Disconnect()
        if player.Parent==state.service and player.RespawnLocation==state.spawn then
            local previous=entry.previous
            if previous and not previous:IsDescendantOf(workspace) then previous=nil end
            player.RespawnLocation=previous
        end
    end
    -- The Edit-mode marker belongs to the scene, not this controller's lifetime.
end
function M.prepareDriverSpawn(controller)
    M.clearDriverSpawn(controller)
    local players=game:GetService("Players")
    local spawn=controller.track1Spawn
    local state={service=players,spawn=spawn,connections={},players={},closed=false}
    controller.track1DriverState=state
    local function place(player,character)
        task.defer(function()
            local root=character:WaitForChild("HumanoidRootPart",10)
            local humanoid=character:WaitForChild("Humanoid",10)
            if state.closed or player.Parent~=players or player.Character~=character or not root or not humanoid
                or humanoid.Health<=0 or humanoid.SeatPart or not spawn.Parent then return end
            if (root.Position-spawn.Position).Magnitude>12 then
                character:PivotTo(character:GetPivot()+(spawn.Position+Vector3.yAxis*4-root.Position))
                root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero
            end
        end)
    end
    local function bind(player)
        if state.closed or state.players[player] or player.Parent~=players then return end
        state.players[player]={previous=player.RespawnLocation,
            connection=player.CharacterAdded:Connect(function(character) place(player,character) end)}
        player.RespawnLocation=spawn
        if player.Character then place(player,player.Character) end
    end
    state.connections[1]=players.PlayerAdded:Connect(bind)
    state.connections[2]=players.PlayerRemoving:Connect(function(player)
        local entry=state.players[player]
        if entry then entry.connection:Disconnect();state.players[player]=nil end
    end)
    state.connections[3]=spawn.Destroying:Connect(function() M.clearDriverSpawn(controller) end)
    for _,player in ipairs(players:GetPlayers()) do bind(player) end
end
return M
