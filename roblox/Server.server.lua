local RS=game:GetService("ReplicatedStorage")
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local package=RS:WaitForChild("NR2003Lab")
local Tune=require(package.Core.TestTune)
local Builder=require(package.Roblox.CarBuilder)
local Mode=require(package.Roblox.ModeConfig)
local RenderConfig=require(package.Roblox.RenderConfig)
local RenderSnapshot=require(package.Roblox.RenderSnapshot)
local U=require(package.Core.MathUtil)
local tune=Tune.new(); local world=workspace:FindFirstChild("NR2003LabWorld")
if not world then
    world=Instance.new("Folder"); world.Name="NR2003LabWorld"; world.Parent=workspace; Builder.makeTrack(world)
end
local car=world:FindFirstChild("TestCar") or Builder.create(world,Builder.spawnCFrame(tune),tune)
local remote=package:WaitForChild("Input"); local telemetry=package:WaitForChild("Telemetry")
local renderState=package:WaitForChild("RenderState")
local controller
if Mode.mode=="ROBLOX_ADAPTER" then
    controller=require(package.Roblox.LegacyRobloxAdapter).new(car,tune,remote)
elseif Mode.mode=="NR2003_CORE" then
    controller=require(package.Roblox.CoreChassisAdapter).new(car,tune,remote)
elseif Mode.mode=="NR2003_CUP" then
    -- Stage 6/7: original NR2003 Cup 45-state core (Core.NR2003Cup); Roblox = contact/presentation host
    controller=require(package.Roblox.CupChassisAdapter).new(car,tune,remote)
else error("Unknown NR2003 mode: "..tostring(Mode.mode)) end
-- Stage 12: only the Cup core sends the ORIGINAL steering-wheel angle in the render snapshots
car:SetAttribute("CockpitWheelAngle",Mode.mode=="NR2003_CUP")
local input={throttle=0,brake=1,steer=0,handbrake=0,clutch=1}
local lastInput,lastAction=0,0; local lastDriver=nil; local packetTimes={}
local renderInterval=1/RenderConfig.snapshotHz;local renderAccumulator=renderInterval;local renderSeq=0
remote.OnServerEvent:Connect(function(player,message)
    if type(message)~="table" then return end
    if message.kind=="enter" then controller:requestEntry(player);return end
    if player~=controller:driver() then return end
    local now=os.clock()
    if message.kind=="input" then
        if now-(packetTimes[player] or 0)<1/tune.adapter.maxPacketHz then return end
        packetTimes[player]=now
        for _,key in ipairs({"throttle","brake","steer","handbrake","clutch"}) do
            if not U.finite(message[key]) then return end
        end
        for _,key in ipairs({"throttle","brake","steer","handbrake","clutch"}) do
            input[key]=U.clamp(message[key],key=="steer" and -1 or 0,1)
        end
        -- Stage 12 (NR2003_CUP): raw steering controls of the client device layer (optional; the legacy
        -- 'steer' keeps the Stage 5 modes working): keys steerLeft/steerRight 0..1, analog steerAxis -1..1
        input.steerLeft=U.finite(message.steerLeft) and U.clamp(message.steerLeft,0,1) or nil
        input.steerRight=U.finite(message.steerRight) and U.clamp(message.steerRight,0,1) or nil
        input.steerAxis=U.finite(message.steerAxis) and U.clamp(message.steerAxis,-1,1) or nil
        input.steerAnalog=message.steerAnalog==true and input.steerAxis~=nil
        lastInput=now
    elseif now-lastAction>0.15 then
        if message.kind=="shift" and U.finite(message.delta) then controller:shift(message.delta)
        elseif message.kind=="reset" then controller:reset()
        elseif message.kind=="debug" then controller.debugVisible=not controller.debugVisible;car:SetAttribute("DebugContacts",controller.debugVisible)
        elseif message.kind=="exit" then controller:exit(player) end
        lastAction=now
    end
end)
Players.PlayerRemoving:Connect(function(player) packetTimes[player]=nil end)
RunService.PreSimulation:Connect(function(dt)
    local driver=controller:driver()
    if driver~=lastDriver then lastInput=0; lastDriver=driver end
    if not driver or os.clock()-lastInput>tune.adapter.inputTimeout then
        input={throttle=0,brake=1,steer=0,handbrake=0,clutch=1}
    end
    controller:step(dt,input)
    if RenderConfig.enabled and controller.renderSnapshot then
        renderAccumulator=renderAccumulator+dt
        if renderAccumulator>=renderInterval then
            renderAccumulator=renderAccumulator%renderInterval
            renderSeq=(renderSeq+1)%65536
            local snapshot=controller:renderSnapshot(renderSeq,workspace:GetServerTimeNow(),RenderConfig.vehicleId)
            renderState:FireAllClients(RenderSnapshot.encode(snapshot))
        end
    end
    if driver and controller.telemetryTimer>=1/tune.adapter.telemetryHz then
        controller.telemetryTimer=0; telemetry:FireClient(driver,controller:telemetry())
    end
end)
script.Destroying:Connect(function() controller:destroy() end)
