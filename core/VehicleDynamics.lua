-- Adapter state update; numerical kernels remain independently callable/testable.
-- This is not the original 45-state NR2003 multibody integrator.
local U=require(script and script.Parent.MathUtil or "core.MathUtil")
local Suspension=require(script and script.Parent.Suspension or "core.Suspension")
local Curves=require(script and script.Parent.TireCurves or "core.TireCurves")
local Tire=require(script and script.Parent.TireForces or "core.TireForces")
local Thermal=require(script and script.Parent.TireThermal or "core.TireThermal")
local Drive=require(script and script.Parent.Drivetrain or "core.Drivetrain")
local Steering=require(script and script.Parent.Steering or "core.Steering")
local M={}; M.__index=M
function M.new(tune)
    local self=setmetatable({tune=tune,wheels={},steering=0,time=0,steps=0},M)
    self.drive=Drive.new(tune.engine,tune.rounding)
    self.front=Suspension.new(tune.frontSuspension,tune.rounding)
    self.rear=Suspension.new(tune.rearSuspension,tune.rounding)
    for j,c in ipairs(tune.corners) do
        local p=U.copy(tune.tire); p.curves=Curves.new(p,tune.rounding)
        p.front=c.front; p.radius=tune.wheelRadius
        self.wheels[j]={omega=0,angle=0,steer=0,compression=0,load=0,parameters=p,
            tire=Tire.newState(),thermal=Thermal.new(tune.thermal),
            force={longitudinal=0,lateral=0,normal=0},slipRatio=0}
    end
    return self
end
function M:shift(delta) Drive.shift(self.drive,delta,self.tune.engine) end
function M:steer(command,speed,dt)
    local t=self.tune; local left,right
    self.steering,left,right=Steering.step(self.steering,command,speed,t.steering,t.wheelbase,t.frontTrack,dt)
    self.wheels[1].steer=left; self.wheels[2].steer=right
end
function M:step(contacts,input,dt)
    local t=self.tune; local omega,loads,springs,dampers={},{},{},{}
    self.time=self.time+dt; self.steps=self.steps+1
    for j,w in ipairs(self.wheels) do
        local c=contacts[j]; omega[j]=w.omega
        local suspension=j<3 and t.frontSuspension or t.rearSuspension
        w.compression=c.grounded and U.clamp(c.compression,0,suspension.travel+0.03) or 0
        loads[j]=0; springs[j]=0; dampers[j]=0
        if c.grounded then
            loads[j],springs[j],dampers[j]=Suspension.force(j<3 and self.front or self.rear,
                w.compression,-c.compressionRate)
        end
    end
    for _,axle in ipairs({{1,2,t.antiRollFront},{3,4,t.antiRollRear}}) do
        local a,b=axle[1],axle[2]
        if contacts[a].grounded and contacts[b].grounded then
            local left,right=Suspension.antiRoll(self.wheels[a].compression,self.wheels[b].compression,t.antiRollPreload,axle[3])
            loads[a]=loads[a]+left; loads[b]=loads[b]+right
        end
    end
    local torques=Drive.step(self.drive,t.engine,input,omega,dt); local outputs={}
    for j,w in ipairs(self.wheels) do
        local c,p=contacts[j],w.parameters
        local normal=U.clamp(loads[j],0,t.maximumNormalForce)
        local properties=Thermal.properties(w.thermal,t.thermal,t.environment.ambientK,t.tire.verticalStiffness)
        p.verticalStiffness=properties.verticalStiffness; p.inverseLoad=properties.inverseLoad
        p.contactPatch=properties.contactPatch
        p.grip=t.tire.grip*c.grip*math.max(t.adapter.thermalGripFloor,properties.gripFactor)
        p.rollingResistance=t.tire.rollingResistance*properties.rollingScale
        p.relaxationStep=dt/t.tire.relaxationLength
        local force
        if normal>1 and c.grounded and c.grip>0 then
            force=Tire.evaluate(w.tire,p,{gap=normal/p.verticalStiffness,forwardSpeed=c.forwardSpeed,
                lateralSpeed=c.lateralSpeed,normalSpeed=c.normalSpeed,treadSpeed=w.omega*t.wheelRadius,
                camber=c.camber or 0,brake=input.brake,anchorLong=0,anchorLat=0,commit=true})
            -- Explicit raycast integration guard. Not an extra claim of NR parity.
            local magnitude=math.sqrt(force.longitudinal^2+force.lateral^2)
            local limit=normal*c.grip*t.adapter.frictionEnvelope
            if magnitude>limit then
                force.longitudinal=force.longitudinal*limit/magnitude; force.lateral=force.lateral*limit/magnitude
            end
            if math.abs(c.forwardSpeed)<0.5 and input.brake>0 then
                local resistance=-c.forwardSpeed*t.adapter.lowSpeedLongitudinalDamping*input.brake
                force.longitudinal=U.clamp(force.longitudinal+resistance,-limit,limit)
            end
        else
            force=Tire.evaluate(w.tire,p,{gap=1,forwardSpeed=0,lateralSpeed=0,normalSpeed=0,treadSpeed=w.omega*t.wheelRadius})
        end
        local bias=j<3 and t.brake.frontBias or 1-t.brake.frontBias
        local capacity=t.brake.maximumTorque*input.brake*bias*0.5+t.brake.dragTorque+force.rollingTorque
        if j>=3 then capacity=capacity+input.handbrake*t.brake.handbrakeTorque end
        local external=torques[j]-force.longitudinal*t.wheelRadius
        local braking=Drive.brake(w.omega,external,capacity,t.wheelInertia,dt)
        w.omega=U.clamp(w.omega+(external+braking)/t.wheelInertia*dt,-t.adapter.maxWheelOmega,t.adapter.maxWheelOmega)
        w.angle=(w.angle+w.omega*dt)%(2*math.pi); w.load=normal; w.force=force
        w.springForce=springs[j]; w.damperForce=dampers[j]
        w.slipRatio=(w.omega*t.wheelRadius-c.forwardSpeed)/math.max(math.abs(c.forwardSpeed),2)
        w.brakeTorque=braking; w.driveTorque=torques[j]
        if t.thermal.enabled then
            Thermal.step(w.thermal,t.thermal,{latForce=force.lateral,longForce=force.longitudinal,
                slipLat=w.tire.slipLat,slipLong=w.tire.slipLong,sliding=w.tire.slidingFraction,
                rollingForce=w.tire.rollingForce,treadSpeed=w.omega*t.wheelRadius,forwardSpeed=c.forwardSpeed,
                speed=math.abs(c.forwardSpeed),camber=c.camber or 0,side=t.corners[j].side,
                ambientK=t.environment.ambientK,brakePower=math.abs(braking*w.omega)},dt)
        end
        outputs[j]={longitudinal=force.longitudinal,lateral=force.lateral,normal=normal,
            aligningMoment=force.aligningMoment or 0}
        U.assertFinite(outputs[j],"wheel"..j)
    end
    return outputs
end
return M
