-- Stage 5 host: numeric chassis integration, external geometry queries, pose output.
-- No ApplyImpulse/AssemblyMass or Roblox rigid-body integration for this chassis.
local Core=script.Parent.Parent.Core
local Math=require(Core.NR2003Math)
local Fixed=require(Core.NR2003FixedStep)
local Bridge=require(script.Parent.CoreChassisBridge)
local Contact=require(script.Parent.RaycastContacts)
local Visual=require(script.Parent.VisualRig)
local SeatAccess=require(script.Parent.SeatAccess)
local Cockpit=require(script.Parent.Cockpit)
local RenderSnapshot=require(script.Parent.RenderSnapshot)
local Legacy=require(script.Parent.VehicleController)
local M={};M.__index=M
local B={0,-1,0,0,0,1,-1,0,0};local BT=Math.transpose(B,3,3)
local function array(v) return {v.X,v.Y,v.Z} end
local function vector(a) return Vector3.new(a[1],a[2],a[3]) end
function M.numericPose(s,scale)
    local p=Math.mv(B,s.worldPosition,3)
    local r=Math.mul(Math.mul(B,s.worldRotation,3,3,3),BT,3,3,3)
    return CFrame.new(p[1]/scale,p[2]/scale,p[3]/scale,table.unpack(r))
end
function M:toNumericVector(v) return Math.mv(BT,array(self.origin:VectorToObjectSpace(v)),3) end
function M:toNumericPoint(p) return Math.scale(Math.mv(BT,array(self.origin:PointToObjectSpace(p)),3),self.tune.metresPerStud) end
function M:toWorldVector(v) return self.origin:VectorToWorldSpace(vector(Math.mv(B,v,3))) end
function M:kinematics()
    local s=self.bridge.state.components.chassis
    local linear=self:toWorldVector(Math.slice(s.totalVelocity,1,3))/self.tune.metresPerStud
    local angular=self:toWorldVector(Math.mv(s.worldRotation,Math.slice(s.totalVelocity,4,3),3))
    return linear,angular
end
function M.new(car,tune,remote)
    local self=setmetatable({car=car,root=car.Chassis,tune=tune,origin=car.Chassis.CFrame,
        telemetryTimer=0,debugVisible=false,droppedTime=0,fault=nil,renderSpin={},lastRenderSnapshotTime=nil,renderTeleport=true},M)
    self.spawn=car:GetPivot();self.oldAnchored=self.root.Anchored;self.oldCollide=self.root.CanCollide
    car:SetAttribute("NR2003CorePoseOwner",true);car:SetAttribute("PhysicsMode","NR2003_CORE")
    self.root.Anchored=true;self.root.CanCollide=false
    self.root.AssemblyLinearVelocity=Vector3.zero;self.root.AssemblyAngularVelocity=Vector3.zero
    self.contact=Contact.new(car,tune);self.visual=Visual.new(car,tune)
    self.access=SeatAccess.new(car,remote);Cockpit.ensure(car,tune)
    self:initialize()
    return self
end
function M:initialize()
    self.renderSpin={};self.lastRenderSnapshotTime=nil;self.renderTeleport=true
    self.bridge=Bridge.new(self.tune,self:toNumericVector(Vector3.new(0,-self.tune.gravity,0)))
    self.dynamics=self.bridge.dynamics;self.contacts=self.contact:sample(self.dynamics,function() return Vector3.zero end)
    local controller=self
    local stepper={state=self.bridge.state}
    function stepper:step(input,packet)
        controller.bridge:step(input,packet);self.state=controller.bridge.state
        controller:moveChassis()
    end
    function stepper:checkpoint() return controller.bridge:checkpoint() end
    function stepper:restore(checkpoint)
        controller.bridge:restore(checkpoint);self.state=controller.bridge.state
        controller.dynamics=controller.bridge.dynamics
        controller.car:PivotTo(controller.origin*M.numericPose(self.state.components.chassis,controller.tune.metresPerStud))
    end
    self.runner=Fixed.new(stepper,(self.tune.coreChassis and self.tune.coreChassis.maxStepsPerFrame) or 96)
end
function M:sample(input)
    self.bridge:steer(input)
    local linear,angular=self:kinematics();local position=self.root.Position
    self.contacts=self.contact:sample(self.dynamics,function(point)
        return linear+angular:Cross(point-position)
    end)
    local contacts={}
    for i,c in ipairs(self.contacts) do
        local numeric={}
        for k,v in pairs(c) do if type(v)=="number" or type(v)=="boolean" then numeric[k]=v end end
        numeric.position=self:toNumericPoint(c.point)
        numeric.normal=self:toNumericVector(c.normal);numeric.forward=self:toNumericVector(c.forward);numeric.right=self:toNumericVector(c.right)
        contacts[i]=numeric
    end
    local wind=self.tune.environment.wind
    return {contacts=contacts,wind=self:toNumericVector(Vector3.new(wind[1],wind[2],wind[3]))}
end
function M:moveChassis()
    local s=self.bridge.state.components.chassis
    local target=self.origin*M.numericPose(s,self.tune.metresPerStud)
    local delta=target.Position-self.root.Position
    if delta.Magnitude>1e-7 then
        -- Reuse the same car/avatar filter as wheel queries. Cast responds only to
        -- translation; initial overlap/rotation-only penetration is a known limit.
        local hit=workspace:Blockcast(self.root.CFrame,self.root.Size,delta,self.contact.params)
        if hit then
            local distance=math.max(0,hit.Distance-0.01)
            local point=self.root.Position+delta.Unit*distance
            local linear=self:kinematics();local normal=hit.Normal
            local ground=hit.Instance:IsA("BasePart") and hit.Instance:GetVelocityAtPosition(hit.Position) or Vector3.zero
            local inward=(linear-ground):Dot(normal)
            if inward<0 then linear=linear-normal*inward end
            self.bridge:project(self:toNumericPoint(point),self:toNumericVector(linear*self.tune.metresPerStud))
            target=self.origin*M.numericPose(s,self.tune.metresPerStud)
            self.car:SetAttribute("CoreCollision",true)
        else self.car:SetAttribute("CoreCollision",false) end
    end
    self.car:PivotTo(target)
    self.car:SetAttribute("CoreTick",self.bridge.state.tick)
end
function M:driver() return self.access:driver() end
function M:requestEntry(player) return self.access:request(player) end
function M:exit(player) return self.access:exit(player) end
function M:shift(delta) self.dynamics:shift(delta) end
function M:step(elapsed,input)
    self.access:step();self.telemetryTimer=self.telemetryTimer+elapsed
    if self.fault then return end
    local ok,reason=pcall(function()
        self.runner:advance(elapsed,input,function() return self:sample(input) end)
        self.roadAngle=self.dynamics.steering
        self.visual:update(self.dynamics,self.contacts,self.debugVisible);Cockpit.update(self.car,self.tune,self.roadAngle)
    end)
    if not ok then self.fault=tostring(reason);self.car:SetAttribute("PhysicsFault",self.fault);warn("NR2003 core paused: "..self.fault) end
end

function M:renderSnapshot(seq,time,vehicleId)
    local cf=self.root.CFrame
    local px,py,pz,r00,r01,r02,r10,r11,r12,r20,r21,r22=cf:GetComponents()
    local qx,qy,qz,qw=RenderSnapshot.quatFromMatrix(r00,r01,r02,r10,r11,r12,r20,r21,r22)
    local linear,angular=self:kinematics()
    local dt=self.lastRenderSnapshotTime and math.max(0,time-self.lastRenderSnapshotTime) or 0
    local wheels={}
    for j,w in ipairs(self.dynamics.wheels) do
        local spin=RenderSnapshot.unwrapSpin(self.renderSpin[j],w.angle,w.omega,dt)
        self.renderSpin[j]=spin
        local contact=self.contacts[j]
        local localPoint=cf:PointToObjectSpace(contact.point)
        wheels[j]={comp=w.compression,steer=w.steer,spin=spin,cx=localPoint.X,cy=localPoint.Y,cz=localPoint.Z,grounded=contact.grounded}
    end
    local flags=self.renderTeleport and RenderSnapshot.FLAG_TELEPORT or 0
    self.renderTeleport=false;self.lastRenderSnapshotTime=time
    return {vehicleId=vehicleId or 1,seq=seq,flags=flags,tick=self.bridge.state.tick,time=time,
        px=px,py=py,pz=pz,qx=qx,qy=qy,qz=qz,qw=qw,
        lx=linear.X,ly=linear.Y,lz=linear.Z,ax=angular.X,ay=angular.Y,az=angular.Z,
        steer=self.roadAngle or self.dynamics.steering or 0,wheels=wheels}
end
function M:telemetry()
    local result=Legacy.telemetry(self)
    result.speed=self:kinematics().Magnitude*self.tune.metresPerStud*3.6
    result.mode="NR2003_CORE";result.tick=self.bridge.state.tick;result.backlog=self.runner.accumulator
    result.chassisStateCount=13;result.chassisIntegration="NR2003Integrator"
    return result
end
function M:reset()
    self.car:PivotTo(self.spawn);self.fault=nil;self.car:SetAttribute("PhysicsFault",nil)
    self:initialize()
end
function M:destroy()
    self.access:destroy();self.car:SetAttribute("NR2003CorePoseOwner",nil)
    self.root.Anchored=self.oldAnchored;self.root.CanCollide=self.oldCollide
end
return M
