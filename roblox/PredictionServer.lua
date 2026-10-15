local RS=game:GetService("ReplicatedStorage")
local Players=game:GetService("Players")
local Run=game:GetService("RunService")
local package=script.Parent.Parent
local C=require(script.Parent.PredictionConfig)
local P=require(script.Parent.PredictionProtocol)
local Codec=require(script.Parent.PredictionCheckpoint)
local Session=require(script.Parent.PredictionSession)
local Simulation=require(script.Parent.PredictionSimulation)
local Snap=require(script.Parent.RenderSnapshot)
local Tune=require(package.Core.TestTune)
local M={}
local function start(ownerScript,setCleanup)
    package:SetAttribute("PredictionServerRunning",true)
    assert(require(script.Parent.ModeConfig).mode=="NR2003_CUP","Stage 14 requires NR2003_CUP")
    local function event(name,class)
        local r=package:FindFirstChild(name)
        if not r then r=Instance.new(class);r.Name=name;r.Parent=package end
        assert(r.ClassName==class,"remote class: "..name);return r
    end
    local control=event("PredictionControl","RemoteEvent")
    local state=event("PredictionState","UnreliableRemoteEvent")
    local input=package:WaitForChild("Input")
    local world=workspace:FindFirstChild("NR2003LabWorld")
    if not world then
        world=Instance.new("Folder");world.Name="NR2003LabWorld";world.Parent=workspace
    end
    if not world:FindFirstChild("TestCar") then
        local b=require(script.Parent.CarBuilder);b.create(world,b.spawnCFrame(Tune.new()),Tune.new())
    end
    local modelFolder=package:FindFirstChild("CarModel")
    local Draw=modelFolder and require(modelFolder.NR2003DrawState)
    local entries,conns={},{};local nextId=0;local ready={};local actionTimes={};local closed=false
    local function stop()
        if closed then return end
        closed=true
        for _,c in ipairs(conns) do c:Disconnect() end
        for _,e in pairs(entries) do pcall(function() e.sim:destroy() end) end
        package:SetAttribute("PredictionServerRunning",nil)
    end
    setCleanup(stop)
    conns[#conns+1]=ownerScript.Destroying:Connect(stop)
    local function sendStart(e)
        if not e.driver or not ready[e.driver] then return end
        if e.sim:tick()%8~=0 then e.startRequested=true;return end
        e.startRequested=nil;e.correction=nil;e.needsCorrection=nil
        -- Ownership/reset epochs invalidate all traffic from an earlier lifecycle.
        e.epoch+=1;e.initial=e.sim:checkpoint();e.session=Session.new(e.epoch,e.sim:tick(),os.clock(),e.sim)
        e.lastAck=0;e.forceAck=true;e.base=e.initial.memory
        e.session.onWitness=function(seq,accepted,witness)
            local bad,error=P.error(accepted,witness)
            e.lastError=error;e.lastError.tick=e.session.startTick+seq*8
            if error.maximum>0 then e.divergentFrames=(e.divergentFrames or 0)+1 end
            if bad then e.needsCorrection=true end
        end
        e.car:SetAttribute("PredictionEpoch",e.epoch)
        control:FireClient(e.driver,{kind="start",id=e.id,car=e.car,epoch=e.epoch,
            checkpoint=Codec.pack(e.initial),tick=e.sim:tick()})
    end
    local function add(car)
        if closed or car.Parent~=world or not car:IsA("Model") or not car:FindFirstChild("DriverSeat") or not car:FindFirstChild("Chassis") then return end
        if entries[car] then return end
        nextId+=1
        local sim=Simulation.new(car,Tune.new(),input,false,nil,nextId==1)
        local e={car=car,id=nextId,sim=sim,epoch=0,seq=0,renderTimer=0,ackTimer=0,idle=0}
        entries[car]=e;car:SetAttribute("PredictionVehicleId",e.id);car:SetAttribute("PredictionEnabled",true)
    end
    for _,car in ipairs(world:GetChildren()) do add(car) end
    local function deferAdd(car) if task then task.defer(add,car) else add(car) end end
    conns[#conns+1]=world.ChildAdded:Connect(deferAdd)
    if world.DescendantAdded then conns[#conns+1]=world.DescendantAdded:Connect(function(child)
        if child.Name=="DriverSeat" or child.Name=="Chassis" then deferAdd(child.Parent) end
    end) end
    local function find(player,id)
        for _,e in pairs(entries) do if e.id==id and e.driver==player and e.sim.adapter:driver()==player then return e end end
    end
    local function guard(fn)
        return function(...)
            local ok,err=pcall(fn,...);if not ok then warn("Stage 14: "..tostring(err)) end
        end
    end
    conns[#conns+1]=control.OnServerEvent:Connect(guard(function(player,msg)
        if type(msg)~="table" then return end
        if msg.kind=="ready" then
            if ready[player] and os.clock()-ready[player]<1 then return end
            ready[player]=os.clock()
            for _,e in pairs(entries) do if e.driver==player then sendStart(e) end end
            return
        end
        local e=find(player,msg.id);if not e or not e.session or msg.epoch~=e.epoch then return end
        if msg.kind=="commands" then
            local ok=e.session:receive(msg,os.clock())
            if not ok then e.session.rejected+=1 end
        elseif msg.kind=="resync" and os.clock()-(e.lastResync or 0)>1 then
            e.lastResync=os.clock();sendStart(e)
        elseif msg.kind=="ping" and P.finite(msg.echo) and os.clock()-(e.lastPing or -1)>0.25 then
            e.lastPing=os.clock();control:FireClient(player,{kind="pong",id=e.id,epoch=e.epoch,echo=msg.echo})
        end
    end))
    conns[#conns+1]=input.OnServerEvent:Connect(guard(function(player,msg)
        if type(msg)~="table" then return end
        local e
        for _,candidate in pairs(entries) do
            if candidate.sim.adapter:driver()==player then e=candidate;break end
        end
        if msg.kind=="enter" then
            -- The existing seat handler still performs distance, life, cooldown, ownership checks.
            local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local nearest,dist
                for _,candidate in pairs(entries) do
                    local d=(candidate.car.DriverSeat.Position-root.Position).Magnitude
                    if not dist or d<dist then nearest,dist=candidate,d end
                end
                if nearest then nearest.sim.adapter:requestEntry(player) end
            end
            return
        end
        if not e or os.clock()-(actionTimes[player] or 0)<0.15 then return end
        actionTimes[player]=os.clock()
        if msg.kind=="exit" then e.sim.adapter:exit(player)
        elseif msg.kind=="reset" then
            e.sim.adapter:reset();e.faulted=nil;e.driver=player;e.car:SetAttribute("PredictionFault",nil);sendStart(e)
        elseif msg.kind=="cycleSetup" and e.car:GetAttribute("NR2003Track")=="watkins_glen" then
            local ok,reason=pcall(require(script.Parent.SetupTestControls).cycle,e.car,function() e.sim.adapter:reset() end)
            if ok then
                e.faulted=nil;e.driver=player;e.car:SetAttribute("PredictionFault",nil);sendStart(e)
            else warn("NR2003 preset switch failed: "..tostring(reason)) end
        elseif msg.kind=="debug" then
            e.sim.adapter.debugVisible=not e.sim.adapter.debugVisible
            e.car:SetAttribute("DebugContacts",e.sim.adapter.debugVisible)
        end -- legacy input/shift messages cannot drive a Stage 14 car
    end))
    conns[#conns+1]=Players.PlayerRemoving:Connect(function(player)
        ready[player]=nil;actionTimes[player]=nil
        for _,e in pairs(entries) do
            if e.driver==player then e.driver=nil;e.session=nil;e.epoch+=1 end
        end
    end)
    conns[#conns+1]=Run.PreSimulation:Connect(function(dt)
        local cycleStart=os.clock()
        local ordered={};for _,e in pairs(entries) do ordered[#ordered+1]=e end
        table.sort(ordered,function(a,b) return a.id<b.id end)
        M.cursor=((M.cursor or 0)%math.max(1,#ordered))+1
        for index=1,#ordered do
            local e=ordered[(M.cursor+index-2)%#ordered+1];local car=e.car
            if not car:IsDescendantOf(world) then e.sim:destroy();entries[car]=nil;continue end
            if e.faulted then e.sim.adapter.access:step();continue end
            local ok,err=pcall(function()
                local a=e.sim.adapter;a.access:step()
                local driver=a:driver()
                if driver~=e.driver then
                    local old=e.driver
                    if old and old.Parent==Players then control:FireClient(old,{kind="stop",id=e.id,epoch=e.epoch}) end
                    e.driver=driver;e.session=nil;e.epoch+=1
                    -- Finish an idle partial device frame before changing ownership.
                    while e.sim:tick()%8~=0 do e.sim:step({}) end
                    sendStart(e)
                end
                if e.session and driver then
                    local s=e.session
                    local budget=math.max(0,C.serverBudget-(os.clock()-cycleStart))
                    if budget>0 then
                        s:advance(C.maxSteps,budget,function()
                            if e.needsCorrection then
                                e.correction={tick=e.sim:tick(),ack=s.ack,checkpoint=Codec.pack(e.sim:checkpoint(),e.base),error=e.lastError}
                                e.needsCorrection=nil
                            end
                        end)
                    end
                    if e.needsCorrection and e.sim:tick()%8==0 then
                        e.correction={tick=e.sim:tick(),ack=s.ack,checkpoint=Codec.pack(e.sim:checkpoint(),e.base),error=e.lastError}
                        e.needsCorrection=nil
                    end
                    if e.startRequested and e.sim:tick()%8==0 then sendStart(e);s=e.session end
                    if os.clock()-s.lastReceive>C.timeout then
                        -- End authority for a disconnected driver; its client can keep predicting until seat replication.
                        a:exit(driver);e.session=nil
                    end
                    e.ackTimer+=dt
                    if e.ackTimer>=1/C.ackHz or e.forceAck or e.correction then
                        e.ackTimer=0;e.forceAck=false
                        local m=e.correction or {tick=s.startTick+s.ack*8,ack=s.ack}
                        m.kind="ack";m.id=e.id;m.epoch=e.epoch;m.echo=s.echo
                        m.divergence=e.lastError;m.rejected=s.rejected;m.validationCPU=s.cpu
                        control:FireClient(driver,m);e.correction=nil
                    end
                elseif not driver then
                    e.idle+=dt
                    local count=0
                    while e.idle>=1/288 and count<C.maxSteps do
                        e.sim:step({});e.idle-=1/288;count+=1
                    end
                end
                e.sim:present()
                e.renderTimer+=dt
                if e.renderTimer>=1/30 and (e.lastSentTick~=e.sim:tick() or e.lastSentEpoch~=e.epoch) then
                    e.renderTimer=e.renderTimer%(1/30);e.seq=(e.seq+1)%65536
                    local time=workspace:GetServerTimeNow()
                    -- Accepted motion is entirely server-computed, even when a client witness is forged.
                    local snap=a:renderSnapshot(e.seq,time,e.id)
                    local draw=Draw and Draw.sample(a.core,{}, {})
                    local message={id=e.id,epoch=e.epoch,snapshot=Snap.encode(snap),
                        draw=draw and Draw.encode(e.seq,time,draw) or nil}
                    -- Clients register both listeners before declaring readiness.
                    for player in pairs(ready) do
                        if player.Parent==Players then state:FireClient(player,message) end
                    end
                    e.lastSentTick=e.sim:tick();e.lastSentEpoch=e.epoch
                end
            end)
            if not ok then
                e.faulted=true
                car:SetAttribute("PredictionFault",tostring(err));warn("Stage 14 vehicle "..e.id..": "..tostring(err))
                if e.driver then e.sim.adapter:exit(e.driver) end;e.session=nil
            end
        end
    end)
    return entries
end
function M.start(ownerScript)
    assert(not package:GetAttribute("PredictionServerRunning"),"Another Stage 14 server controller is already running")
    local cleanup
    local ok,result=pcall(start,ownerScript,function(fn) cleanup=fn end)
    if not ok then
        if cleanup then pcall(cleanup) end
        package:SetAttribute("PredictionServerRunning",nil)
        error(result,0)
    end
    return result
end
return M
