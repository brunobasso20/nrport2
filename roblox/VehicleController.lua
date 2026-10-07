local Core=script.Parent.Parent.Core
local Dynamics=require(Core.VehicleDynamics)
local Aero=require(Core.Aerodynamics)
local Units=require(script.Parent.Units)
local Contact=require(script.Parent.RaycastContacts)
local Visual=require(script.Parent.VisualRig)
local SeatAccess=require(script.Parent.SeatAccess)
local Cockpit=require(script.Parent.Cockpit)
local M={}; M.__index=M
function M.new(car,tune,remote)
    local self=setmetatable({car=car,root=car.Chassis,tune=tune,accumulator=0,telemetryTimer=0,
        debugVisible=false,droppedTime=0,fault=nil,connections={}},M)
    self.units=Units.new(tune,self.root); self.dynamics=Dynamics.new(tune)
    self.contact=Contact.new(car,tune); self.visual=Visual.new(car,tune)
    self.spawn=car:GetPivot(); self.contacts=self.contact:sample(self.dynamics)
    self.access=SeatAccess.new(car,remote);Cockpit.ensure(car,tune)
    car:SetAttribute("PhysicsMode","ROBLOX_ADAPTER")
    return self
end
function M:driver()
    return self.access:driver()
end
function M:requestEntry(player) return self.access:request(player) end
function M:exit(player) return self.access:exit(player) end
function M:shift(delta) self.dynamics:shift(delta) end
function M:reset()
    self.root.AssemblyLinearVelocity=Vector3.zero; self.root.AssemblyAngularVelocity=Vector3.zero
    self.car:PivotTo(self.spawn); self.accumulator=0; self.fault=nil; self.car:SetAttribute("PhysicsFault",nil)
    self.dynamics=Dynamics.new(self.tune); self.contacts=self.contact:sample(self.dynamics)
end
function M:step(frameDt,input)
    self.access:step()
    if self.fault then return end
    local t=self.tune; local dt=math.min(frameDt,t.maxFrame)
    self.droppedTime=self.droppedTime+math.max(0,frameDt-dt); self.accumulator=self.accumulator+dt
    local speed=self.root.AssemblyLinearVelocity:Dot(self.root.CFrame.LookVector)*t.metresPerStud
    self.dynamics:steer(input.steer,speed,dt); self.contacts=self.contact:sample(self.dynamics)
    local impulses={Vector3.zero,Vector3.zero,Vector3.zero,Vector3.zero}
    while self.accumulator>=t.fixedStep do
        local ok,forces=pcall(self.dynamics.step,self.dynamics,self.contacts,input,t.fixedStep)
        if not ok then
            self.fault=tostring(forces); self.car:SetAttribute("PhysicsFault",self.fault)
            warn("NR2003 Lab paused: "..self.fault); return
        end
        for j,f in ipairs(forces) do
            local c=self.contacts[j]
            impulses[j]=impulses[j]+(c.normal*f.normal+c.forward*f.longitudinal+c.right*f.lateral)*t.fixedStep
        end
        self.accumulator=self.accumulator-t.fixedStep
    end
    -- Local gravity compensation; no global Workspace.Gravity mutation.
    local correction=(workspace.Gravity-t.gravity/t.metresPerStud)*self.root.AssemblyMass*frameDt
    self.root:ApplyImpulse(Vector3.new(0,correction,0))
    for j,impulse in ipairs(impulses) do
        local rbImpulse=self.units:force(impulse); local contact=self.contacts[j]
        self.root:ApplyImpulseAtPosition(rbImpulse,contact.point)
        local surface=contact.instance
        if contact.grounded and surface and surface:IsA("BasePart") and not surface.Anchored then
            surface:ApplyImpulseAtPosition(-rbImpulse,contact.point)
        end
    end
    if t.aero.enabled then
        local cf=self.root.CFrame; local e=t.environment
        local v=self.root.AssemblyLinearVelocity*t.metresPerStud-Vector3.new(e.wind[1],e.wind[2],e.wind[3])
        local w=self.root.AssemblyAngularVelocity
        local velocity={v:Dot(cf.LookVector),-v:Dot(cf.RightVector),v:Dot(cf.UpVector)}
        local angular={w:Dot(cf.LookVector),-w:Dot(cf.RightVector),w:Dot(cf.UpVector)}
        local force,moment=Aero.wrench(t.aero,velocity,angular,e.airDensity,
            t.springFreeLength-(self.dynamics.wheels[1].compression+self.dynamics.wheels[2].compression)*0.5)
        local worldForce=cf.LookVector*force[1]-cf.RightVector*force[2]+cf.UpVector*force[3]
        local worldTorque=cf.LookVector*moment[1]-cf.RightVector*moment[2]+cf.UpVector*moment[3]
        self.root:ApplyImpulse(self.units:force(worldForce*dt)); self.root:ApplyAngularImpulse(self.units:torque(worldTorque*dt))
    end
    self.visual:update(self.dynamics,self.contacts,self.debugVisible)
    self.roadAngle=self.dynamics.steering;Cockpit.update(self.car,t,self.roadAngle)
    self.telemetryTimer=self.telemetryTimer+frameDt
end
function M:telemetry()
    local wheels={}
    for j,s in ipairs(self.dynamics.wheels) do
        wheels[j]={name=self.tune.corners[j].name,load=s.load,compression=s.compression,slip=s.slipRatio,
            omega=s.omega,forceX=s.force.longitudinal,forceY=s.force.lateral,pressure=s.thermal.pressure,
            temperature=(s.thermal.surface[1]+s.thermal.surface[2]+s.thermal.surface[3])/3-273.15,
            brakeC=s.thermal.brakeK-273.15,grounded=self.contacts[j].grounded,surface=self.contacts[j].surface}
    end
    return {speed=self.root.AssemblyLinearVelocity.Magnitude*self.tune.metresPerStud*3.6,
        rpm=self.dynamics.drive.rpm,gear=self.dynamics.drive.gear,wheels=wheels,
        torque=self.dynamics.drive.engineTorque,clutchSlip=self.dynamics.drive.clutchSlip,
        droppedTime=self.droppedTime,fault=self.fault,mode="ROBLOX_ADAPTER",
        roadWheelAngle=self.roadAngle or 0,steeringWheelAngle=Cockpit.angle(self.roadAngle or 0,self.tune)}
end
function M:destroy()
    self.access:destroy();for _,c in ipairs(self.connections) do c:Disconnect() end;self.connections={}
end
return M
