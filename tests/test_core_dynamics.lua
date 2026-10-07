package.path="./?.lua;./core/?.lua;"..package.path
local Solver=require("NR2003VehicleSolver")
local Fixed=require("NR2003FixedStep")
local Math=require("NR2003Math")
local Forces=require("NR2003RecoveredForces")
local Acc=require("NR2003ForceAccumulator")
local Projection=require("NR2003DrivetrainProjection")
local Contact=require("NR2003Contact")
local checks=0
local function check(v,label) checks=checks+1;assert(v,label) end
local function near(a,b,e,label) check(math.abs(a-b)<=e,(label or "value")..": "..a.." vs "..b) end
local body={name="chassis",parentName="inertial",flags=39,mass=1000,inertia={200,300,400},offset={0,0,0},angles={0,0,0}}
local free=Solver.new({records={body},state={0,10,0,0,0,0,0,0,0,1,0,0,0}})
for _=1,288 do free:step() end
near(free.state.components.chassis.translation[1],10,4e-5,"free motion")
near(free.state.components.chassis.velocity[1],10,1e-6,"free velocity")
local fall=Solver.new({records={body},gravity={0,0,-9.80665}})
for _=1,288 do fall:step() end
near(fall.state.components.chassis.velocity[3],-9.80665,5e-5,"gravity velocity")
near(fall.state.components.chassis.translation[3],-9.80665/2,5e-5,"gravity position")
local rotate=Solver.new({records={body},forces=function(_,a) a:localWrench("chassis",{0,0,0,0,0,40}) end})
for _=1,144 do rotate:step() end
near(rotate.state.components.chassis.velocity[6],.05,2e-6,"chassis torque after 144 float32 steps")
near(Math.dot(rotate.state.components.chassis.orientation,rotate.state.components.chassis.orientation),1,3e-7,"quaternion norm")
for _,case in ipairs({{name="wheel",axis=2,inertia=1.7},{name="engine",axis=1,inertia=.12}}) do
    local moment={0,0,0};moment[case.axis]=case.inertia
    local rotor={name=case.name,parentName="chassis",flags=case.axis*8+64,mass=0,inertia=moment,offset={0,0,0},angles={0,0,0}}
    local s=Solver.new({records={body,rotor},forces=function(_,a) a:jointTorque(case.name,case.axis,10) end})
    s:step();local chassis=s.state.components.chassis;local r=s.state.components[case.name];local slot=case.axis+3
    near(r.totalVelocity[slot],10/case.inertia*s.dt,4e-7,case.name.." absolute spin")
    near(chassis.totalVelocity[slot],-10/body.inertia[case.axis]*s.dt,2e-8,"reaction")
    near(r.totalVelocity[slot]*case.inertia+chassis.totalVelocity[slot]*body.inertia[case.axis],0,2e-7,"angular momentum conservation")
    check(r.velocity[slot]>r.totalVelocity[slot],"relative spin includes chassis reaction")
end
local core=Solver.new()
check(#core.graph.nodes==16 and core.layout.count==45,"16 components / 45 states")
check(#core.layout.byComponent.lfhub==2 and #core.layout.byComponent.head==6 and #core.layout.byComponent.raxle==4,"state mapping")
local p={engineInertia=.12,clutchInertia=.08,outputInertia=.12,wheelInertia=1.66,gearRatio=2.5,finalDrive=3.7,clutchEngagement=1}
local v={800,100,20,5,7,0};local corrected=Math.add(v,Math.mv(Projection.matrix(p),v,6))
near(corrected[1],corrected[2],1e-4,"clutch coupling")
near(corrected[2],2.5*corrected[3],1e-4,"gear coupling")
near(corrected[3],3.7*(corrected[4]+corrected[5])*.5,2e-5,"axle coupling")
near(corrected[4]-corrected[5],v[4]-v[5],1e-6,"differential speed difference")
local function energy(a) return .5*(.12*a[1]^2+.08*a[2]^2+.12*a[3]^2+1.66*(a[4]^2+a[5]^2)) end
check(energy(corrected)<=energy(v),"coupling cannot create energy")
core.state.components.engine.velocity[4]=100;core.state.components.clutch.velocity[4]=10
local a=Acc.new(core.graph,core.state);Forces.clutch(core,a,20)
near(core.state.components.engine.force[4]+core.state.components.clutch.force[4],0,0,"clutch action reaction")
core.state.components.lrwheel.velocity[5]=5;core.state.components.rrwheel.velocity[5]=10
Forces.differential(core,a,30)
near(core.state.components.lrwheel.force[5]+core.state.components.rrwheel.force[5],0,0,"differential action reaction")
local function contactAt(s,name)
    return {hit=true,position=Math.copy(s.state.components[name].worldPosition),normal={0,0,1},forward={1,0,0},left={0,1,0},groundVelocity={0,0,0},surface=1}
end
local tire=Solver.new({forces=function(s,acc)
    Contact.applyOutput(acc,"lfwheel",contactAt(s,"lfwheel"),{longitudinal=1000,aligningMoment=12})
end})
tire:step();check(tire.state.components.chassis.totalVelocity[1]>0,"tire force reaches chassis")
near(tire.aligningMoments.lfwheel,12,0,"aligning moment preserved")
local function rear(left,right)
    local s=Solver.new({forces=function(c,acc)
        Contact.applyOutput(acc,"lrwheel",contactAt(c,"lrwheel"),{normal=left})
        Contact.applyOutput(acc,"rrwheel",contactAt(c,"rrwheel"),{normal=right})
    end});s:step();return s
end
near(rear(1000,1000).state.components.raxle.velocity[4],0,1e-6,"symmetric rear load")
check(math.abs(rear(1200,800).state.components.raxle.velocity[4])>1e-3,"asymmetric rear load rolls axle")
local suspension=Solver.new({forces=function(s,acc)
    Contact.applyOutput(acc,"lfwheel",contactAt(s,"lfwheel"),{normal=1000})
    Forces.frontSuspension(s,acc,"lfsusp",function(q) return -20000*q end,function(vz) return -500*vz end)
end})
for _=1,8 do suspension:step() end
check(suspension.state.components.lfsusp.translation[3]>0,"front suspension travels")
check(suspension.state.components.chassis.totalVelocity[3]>0,"spring transfers load to chassis")
local function repeatable()
    return Solver.new({records={body},gravity={0,0,-9.80665},forces=function(_,acc,input)
        acc:localWrench("chassis",{input.force or 0,0,0,0,0,2})
    end})
end
local function input(tick) return {force=tick%17*10} end
local x,y=repeatable(),repeatable();local xr,yr=Fixed.new(x),Fixed.new(y)
for _=1,60 do xr:advance(1/60,input) end
for _=1,144 do yr:advance(1/144,input) end
check(x.state.tick==288 and y.state.tick==288,"fixed frequency independent of host frame rate")
for i,vv in ipairs(x:pack()) do near(vv,y:pack()[i],0,"frame scheduling determinism") end
local checkpoint=x:checkpoint()
for _=1,10 do x:step(input(x.state.tick)) end
local expected=x:pack();x:restore(checkpoint)
for _=1,10 do x:step(input(x.state.tick)) end
for i,vv in ipairs(expected) do near(vv,x:pack()[i],0,"checkpoint replay") end
local backlog=Fixed.new(repeatable(),2);local count,alpha=backlog:advance(.1,input)
check(count==2 and alpha>26,"backlog retained")
check(not pcall(function() backlog:advance(0/0) end),"NaN time rejected")
check(not pcall(function() Contact.validate({hit=true,position={0,0,0},normal={0,0,2},forward={1,0,0},left={0,1,0},groundVelocity={0,0,0}}) end),"invalid contact rejected")
print("PASS: "..checks.." core dynamics checks")
