-- Stage 5 numeric adapter: original integrator owns the chassis, while the tested
-- wheel/suspension/drivetrain adapter supplies forces once per fixed tick.
-- This is deliberately NOT the stage 6 complete 45-state vehicle integration.
local Core=script and script.Parent.Parent.Core
local Solver=require(Core and Core.NR2003VehicleSolver or "NR2003VehicleSolver")
local Integrator=require(Core and Core.NR2003Integrator or "NR2003Integrator")
local State=require(Core and Core.NR2003VehicleState or "NR2003VehicleState")
local Math=require(Core and Core.NR2003Math or "NR2003Math")
local Dynamics=require(Core and Core.VehicleDynamics or "VehicleDynamics")
local Aero=require(Core and Core.Aerodynamics or "Aerodynamics")
local M={};M.__index=M
function M.new(tune,gravity)
    local width,height,length=tune.chassisSize[1],tune.chassisSize[2],tune.chassisSize[3]
    local inertia=tune.coreChassis and tune.coreChassis.inertia or {
        tune.mass*(width^2+height^2)/12,tune.mass*(length^2+height^2)/12,tune.mass*(length^2+width^2)/12}
    local self=setmetatable({tune=tune,dynamics=Dynamics.new(tune),wrenches={},aligningMoments={}},M)
    self.solver=Solver.new({records={{name="chassis",parentName="inertial",flags=39,
        mass=tune.mass,inertia=inertia,offset={0,0,0},angles={0,0,0}}},
        gravity=gravity or {0,0,-tune.gravity},forces=function(_,acc)
            for _,w in ipairs(self.wrenches) do acc:worldWrench("chassis",w.force,w.torque,w.point) end
        end})
    self.state=self.solver.state;return self
end
function M:steer(input)
    local s=self.state.components.chassis
    local forward={s.worldRotation[1],s.worldRotation[4],s.worldRotation[7]}
    self.dynamics:steer(input.steer or 0,Math.dot(Math.slice(s.totalVelocity,1,3),forward),Integrator.dt)
end
-- packet.contacts are scalar raycast samples plus numeric position/normal/forward/right.
-- Host queries after steer(), before step(); no Instances enter this module.
function M:step(input,packet)
    local outputs=self.dynamics:step(packet.contacts,input,Integrator.dt)
    self.wrenches={};self.aligningMoments={}
    for i,o in ipairs(outputs) do
        local c=packet.contacts[i]
        local force=Math.add(Math.add(Math.scale(c.normal,o.normal),Math.scale(c.forward,o.longitudinal)),Math.scale(c.right,o.lateral))
        self.wrenches[#self.wrenches+1]={force=force,torque=Math.scale(c.normal,o.aligningMoment),point=c.position}
        self.aligningMoments[i]=o.aligningMoment
    end
    if self.tune.aero.enabled then
        local s=self.state.components.chassis;local r=s.worldRotation;local rt=Math.transpose(r,3,3)
        local v=Math.mv(rt,Math.sub(Math.slice(s.totalVelocity,1,3),packet.wind or {0,0,0}),3)
        local force,torque=Aero.wrench(self.tune.aero,v,Math.slice(s.totalVelocity,4,3),self.tune.environment.airDensity,
            self.tune.springFreeLength-(self.dynamics.wheels[1].compression+self.dynamics.wheels[2].compression)*.5)
        self.wrenches[#self.wrenches+1]={force=Math.mv(r,force,3),torque=Math.mv(r,torque,3)}
    end
    local flat=self.solver:step(input)
    self.state=self.solver.state;return flat
end
-- Host collision projection. Explicit kinematic collision boundary, not NR2003 crash physics.
function M:project(position,linearVelocity)
    Math.vector(position,3,"projected position");Math.vector(linearVelocity,3,"projected velocity")
    local s=self.state.components.chassis
    s.translation=Math.scale(position,1);s.worldPosition=Math.copy(s.translation)
    for i=1,3 do s.velocity[i]=Math.f(linearVelocity[i]);s.totalVelocity[i]=s.velocity[i] end
    s.momentum=Math.mv(self.solver.graph.byName.chassis.massMatrix,s.totalVelocity,6)
    Integrator.commit(self.solver.graph,self.state)
end
function M:checkpoint()
    return {core=self.solver:checkpoint(),dynamics=State.clone(self.dynamics),wrenches=State.clone(self.wrenches),aligningMoments=State.clone(self.aligningMoments)}
end
function M:restore(c)
    self.solver:restore(c.core);self.state=self.solver.state
    self.dynamics=setmetatable(State.clone(c.dynamics),getmetatable(self.dynamics))
    self.wrenches=State.clone(c.wrenches);self.aligningMoments=State.clone(c.aligningMoments)
end
return M
