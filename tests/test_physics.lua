-- Run from package directory: luatex --luaonly tests/test_physics.lua
package.path="./?.lua;./core/?.lua;"..package.path
local U=require("core.MathUtil")
local F=require("core.Float32")
local L=require("core.Lookup")
local S=require("core.Suspension")
local Tire=require("core.TireForces")
local Curves=require("core.TireCurves")
local Thermal=require("core.TireThermal")
local Drive=require("core.Drivetrain")
local Engine=require("core.Engine")
local Aero=require("core.Aerodynamics")
local Steering=require("core.Steering")
local Surface=require("core.Surface")
local Tune=require("core.TestTune")
local Dynamics=require("core.VehicleDynamics")
local checks=0
local function check(x,msg) checks=checks+1; assert(x,msg) end
local function near(a,b,e,msg) check(math.abs(a-b)<=(e or 1e-6),(msg or "mismatch")..": "..a.." vs "..b) end
-- Binary reinterpretation, lookup rounding modes, and extrapolation boundaries.
near(F.fromBits(0x3f800000),1,0); near(F.bits(1),0x3f800000,0)
for _,x in ipairs({0.0001,0.25,1,100,100000}) do near(F.inverseSqrt(x),1/math.sqrt(x),0.006/math.sqrt(x)) end
check(U.finite(F.inverseSqrt(0)),"zero inverse sqrt must remain finite")
local lookup=L.new(0,1,{0,1,4,9})
near(L.sample(lookup,1),1,0); near(L.sample(lookup,-1),-1,0); near(L.sample(lookup,4),14,0)
near(L.roundIndex(0.5),0,0); near(L.roundIndex(1.5),2,0); near(L.roundIndex(-0.5),0,0)
near(L.roundIndex(-0.8,"truncate"),0,0); near(L.roundIndex(-0.8,"floor"),-1,0)
local t=Tune.new(); local suspension=S.new(t.frontSuspension,t.rounding)
check(#suspension.spring.samples==20 and #suspension.damper.samples==70,"curve sample counts")
near(L.sample(suspension.spring,.10),5800,.1)
local springAtBump=L.sample(suspension.spring,.18)
check(springAtBump>.18*t.frontSuspension.rate,"progressive bump stop")
for _,v in ipairs({-.3,-.12,.07,.3}) do check(L.sample(suspension.damper,v)*v<=1e-4,"damper dissipates energy") end
local a,b=S.antiRoll(.08,.03,0,18000); near(a+b,0,0); check(a>0,"antiroll side")
local force,moment=S.rearAxle(suspension,suspension,.07,0,0,0,.8,0)
near(moment,0,.001); check(force>0,"rear heave support")
-- Brake does not turn a stationary wheel backwards and always dissipates energy.
for _,omega in ipairs({-30,-.1,0,.1,30}) do
    local torque=Drive.brake(omega,0,1000,1.5,1/288)
    local nextOmega=omega+torque/1.5/288
    check(torque*omega<=0,"brake power sign")
    check(math.abs(nextOmega)<=math.abs(omega)+1e-9,"brake adds no energy")
    check(nextOmega*omega>=-1e-9,"brake cannot reverse rotation")
end
near(Drive.limitTorque(20,50),-20,0); near(Drive.limitTorque(20,-50),20,0)
local engine=Engine.testTables(t.engine,t.rounding)
check(Engine.torque(engine,5000,1,1,0,0)>Engine.torque(engine,5000,0,1,0,0),"throttle response")
check(Engine.torque(engine,5000,0,1,0,0)<0,"engine braking at high rpm")
local angle,left,right=Steering.step(0,1,0,t.steering,t.wheelbase,t.frontTrack,1)
check(right>left and left>0,"inside right wheel must steer further")
local zero=Steering.step(angle,0,0,t.steering,t.wheelbase,t.frontTrack,1); near(zero,0,1e-9)
check(Surface.grip(5)<Surface.grip(1),"grass lower grip than asphalt")
local p=U.copy(t.tire); p.curves=Curves.new(p,t.rounding); p.radius=t.wheelRadius
near(p.curves.camber.samples[1],p.curves.camber.samples[41],0.00001,"camber endpoints")
p.relaxationStep=t.fixedStep/t.tire.relaxationLength; p.front=false
local function tireCase(vx,vy,tread)
    local s=Tire.newState(); local f
    for _=1,400 do f=Tire.evaluate(s,p,{gap=4000/p.verticalStiffness,forwardSpeed=vx,
        lateralSpeed=vy,normalSpeed=0,treadSpeed=tread,camber=0}) end
    return s,f
end
local state,traction=tireCase(20,0,22)
check(traction.longitudinal>0,"positive drive slip produces forward force")
near(traction.normal,4000,.01)
local _,braking=tireCase(20,0,18); check(braking.longitudinal<0,"negative slip produces braking")
local _,lateral=tireCase(20,2,20); check(lateral.lateral<0,"lateral force opposes lateral velocity")
local _,opposite=tireCase(20,-2,20); near(lateral.lateral,-opposite.lateral,0.1)
local air=Tire.evaluate(state,p,{gap=1,forwardSpeed=20,lateralSpeed=2,normalSpeed=0,treadSpeed=22})
near(air.normal,0,0); near(air.longitudinal,0,0); near(state.relaxedLateral,0,0); near(state.rollingForce,0,0)
for _,load in ipairs({100,1000,4000,15000}) do
    for _,v in ipairs({-30,0,30,70}) do
        local f=Tire.evaluate(Tire.newState(),p,{gap=load/p.verticalStiffness,forwardSpeed=v,
            lateralSpeed=3,normalSpeed=0,treadSpeed=v+2,camber=.02})
        U.assertFinite(f,"load sweep"); checks=checks+1
    end
end
local cold=Thermal.new(t.thermal)
local properties=Thermal.properties(cold,t.thermal,298.15,-300000)
check(properties.verticalStiffness<0 and properties.inverseLoad>0,"thermal property signs")
local hot=Thermal.new(t.thermal); hot.carcass={360,360,360}
Thermal.properties(hot,t.thermal,298.15,-300000); check(hot.pressure>cold.pressure,"pressure increases with temperature")
local af=Aero.wrench(t.aero,{30,0,0},{0,0,0},1.2,.10)
local fast=Aero.wrench(t.aero,{60,0,0},{0,0,0},1.2,.10)
check(af[1]<0 and af[3]<0,"drag/downforce signs"); near(fast[1]/af[1],4,1e-9)
-- Headless longitudinal rig: Newton integration independent of Roblox adapter.
local function simulate(gear,throttle,duration)
    local d=Dynamics.new(t); d.drive.gear=gear
    local velocity=0; local contacts={}; local maximum=0; local signedPeak=0
    for j=1,4 do
        local rate=j<3 and t.frontSuspension.rate or t.rearSuspension.rate
        contacts[j]={grounded=true,compression=t.mass*t.gravity/4/rate,compressionRate=0,
            forwardSpeed=0,lateralSpeed=0,normalSpeed=0,grip=.8,camber=0}
    end
    local count=math.floor(duration/t.fixedStep)
    for k=1,count do
        local accelerating=k<count*.65
        local f=d:step(contacts,{throttle=accelerating and throttle or 0,brake=accelerating and 0 or 1,
            handbrake=0,clutch=0,steer=0},t.fixedStep)
        local fx=0; for j=1,4 do fx=fx+f[j].longitudinal end
        velocity=velocity+fx/t.mass*t.fixedStep
        if math.abs(velocity)>maximum then maximum=math.abs(velocity); signedPeak=velocity end
        for j=1,4 do contacts[j].forwardSpeed=velocity end
    end
    return velocity,maximum,d,contacts,signedPeak
end
local stopped,peak,d,contacts=simulate(1,.50,12)
check(peak>4,"drivetrain accelerates chassis"); check(math.abs(stopped)<.2,"service brakes stop car")
local reversed,reversePeak,_,_,reverseDirection=simulate(-1,.4,10)
check(reversePeak>2 and reverseDirection<0 and math.abs(reversed)<.2,"reverse and braking")
local neutral,neutralPeak=simulate(0,1,5); check(neutralPeak<.01,"neutral cannot drive chassis")
for j=1,4 do contacts[j].grounded=false end
local airborne=d:step(contacts,{throttle=1,brake=0,handbrake=0,clutch=0,steer=0},t.fixedStep)
for _,f in ipairs(airborne) do near(f.normal,0,0); near(f.longitudinal,0,0) end
-- Independent vertical mass dropped onto the suspension curves: settling/damping.
local height,verticalSpeed=0.95,0
local rear=S.new(t.rearSuspension,t.rounding)
for _=1,2880 do
    local compression=t.springFreeLength+t.wheelRadius-t.mountY-height
    local support=0
    if compression>=0 then
        local frontForce=S.force(suspension,compression,verticalSpeed)
        local rearForce=S.force(rear,compression,verticalSpeed)
        support=2*U.clamp(frontForce,0,t.maximumNormalForce)+2*U.clamp(rearForce,0,t.maximumNormalForce)
    end
    verticalSpeed=verticalSpeed+(support/t.mass-t.gravity)*t.fixedStep
    height=height+verticalSpeed*t.fixedStep
end
local equilibrium=t.springFreeLength+t.wheelRadius-t.mountY-t.mass*t.gravity/(2*t.frontSuspension.rate+2*t.rearSuspension.rate)
near(height,equilibrium,.003,"suspension equilibrium")
check(math.abs(verticalSpeed)<.01,"suspension settles")
print(string.format("PASS: %d assertions; forward peak %.2f km/h; stop %.3f km/h; reverse peak %.2f km/h",
    checks,peak*3.6,stopped*3.6,reversePeak*3.6))
