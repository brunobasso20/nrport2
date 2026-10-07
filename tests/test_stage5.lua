-- Real stage 5 controller against a deterministic geometry/event double.
-- Tests integration wiring, not the Roblox engine implementation of Sit/Blockcast.
local fixture=dofile("tests/test_geometry.lua")
local I=fixture.Instance;local car=fixture.car;local seat=car.DriverSeat;local modules=fixture.packageRoot
for _,name in ipairs({"TestTune","VehicleDynamics","MathUtil","Aerodynamics","Surface","NR2003Math","NR2003FixedStep",
    "NR2003VehicleSolver","NR2003Integrator","NR2003VehicleState"}) do modules.Core[name]="core."..name end
for _,name in ipairs({"CoreChassisAdapter","CoreChassisBridge","VehicleController","SeatAccess","Units","RenderSnapshot"}) do
    modules.Roblox[name]={path="roblox/"..name..".lua",Parent=modules.Roblox}
end
local checks=0
local function check(v,label) checks=checks+1;assert(v,label) end
local function signal()
    local s={callbacks={}}
    function s:Connect(fn) local c={active=true};function c:Disconnect()self.active=false end
        self.callbacks[#self.callbacks+1]={fn=fn,c=c};return c end
    function s:Fire(...) for _,c in ipairs(self.callbacks) do if c.c.active then c.fn(...) end end end
    return s
end
local players=I.new("Players");players.PlayerRemoving=signal()
local person=I.new("Player");person.UserId=42;person.Parent=players
local character=I.new("Model");person.Character=character;character.Parent=workspace
local humanoid=I.new("Humanoid");humanoid.Health=100;humanoid.Parent=character
local hrp=I.new("Part");hrp.Name="HumanoidRootPart";hrp.CFrame=seat.CFrame;hrp.Parent=character
function I:FindFirstChildOfClass(name)for _,v in ipairs(self:GetChildren())do if v.ClassName==name then return v end end end
function I:SetNetworkOwner() end
function I:ApplyImpulse() error("Stage 5 must not use ApplyImpulse") end
function I:ApplyImpulseAtPosition() error("Stage 5 must not use Roblox force integration") end
function I:ApplyAngularImpulse() error("Stage 5 must not use Roblox angular integration") end
function I:PivotTo(cf)
    local old=self:GetPivot()
    for _,p in ipairs(self:GetDescendants()) do if p:IsA("BasePart") then p.CFrame=cf*old:ToObjectSpace(p.CFrame) end end
    self.PrimaryPart.CFrame=cf
end
local changed=signal();seat.EnterCar.Triggered=signal()
function seat:GetPropertyChangedSignal()return changed end
function seat:Sit(h)self.Occupant=h;h.SeatPart=self;h.Sit=true;changed:Fire() end
function players:GetPlayerFromCharacter(c)if c==character then return person end end
game={GetService=function(_,name)assert(name=="Players");return players end}
local messages={};local remote={FireClient=function(_,_,message)messages[#messages+1]=message end}
local ground=I.new("Part");ground.Anchored=true
local castCount,wallHits=0,0;local wallZ
function workspace:Blockcast(cf,size,delta)
    castCount=castCount+1;local fraction=2;local normal
    local half=math.abs(cf.RightVector.Y)*size.X*.5+math.abs(cf.UpVector.Y)*size.Y*.5+math.abs(cf.LookVector.Y)*size.Z*.5
    if delta.Y<0 and cf.Position.Y-half>=0 then
        local t=(half-cf.Position.Y)/delta.Y;if t>=0 and t<=1 then fraction=t;normal=Vector3.new(0,1,0) end
    end
    if wallZ and delta.Z<0 then
        local t=(wallZ+size.Z*.5-cf.Position.Z)/delta.Z
        if t>=0 and t<=1 and t<fraction then fraction=t;normal=Vector3.new(0,0,1);wallHits=wallHits+1 end
    end
    if normal then return {Distance=delta.Magnitude*fraction,Normal=normal,Position=cf.Position+delta*fraction,Instance=ground} end
end
local Adapter=fixture.require(modules.Roblox.CoreChassisAdapter)
local cf=Adapter.numericPose({worldPosition={2,3,4},worldRotation={0,-1,0,1,0,0,0,0,1}},.5)
check((cf.Position-Vector3.new(-6,8,-4)).Magnitude<1e-6,"position axis and scale conversion")
check((cf.LookVector-Vector3.new(-1,0,0)).Magnitude<1e-6,"yaw handedness")
local controller=Adapter.new(car,fixture.tune,remote)
check(car.Chassis.Anchored and not car.Chassis.CanCollide,"numeric solver owns chassis")
controller:requestEntry(person)
check(controller:driver()==person and car:GetAttribute("DriverUserId")==42,"entry works in intentional anchored core mode")
local function input(throttle,brake,steer) return {throttle=throttle,brake=brake,steer=steer or 0,handbrake=0,clutch=0} end
local function run(n,dt,command)
    for _=1,n do controller:step(dt,command);if controller.fault then
        print("FAULT TICK",controller.bridge.state.tick,"ROOT",car.Chassis.Position.X,car.Chassis.Position.Y,car.Chassis.Position.Z)
        for i,c in ipairs(controller.contacts) do print("CONTACT",i,c.point.X,c.point.Y,c.point.Z,c.normal.X,c.normal.Y,c.normal.Z) end
        error(controller.fault)
    end end
end
run(120,1/60,input(0,1))
check(controller.bridge.state.tick==576,"288 Hz ticks")
check(car.Chassis.Position.Y>0,"car remains above floor")
local start=car.Chassis.Position
run(300,1/60,input(1,0))
local speed=controller:telemetry().speed
check(speed>5,"accelerates using core-integrated chassis: "..speed)
check((car.Chassis.Position-start).Magnitude*fixture.tune.metresPerStud>3,"numerical pose moves car")
check(controller.dynamics.steps==controller.bridge.state.tick,"wheel/engine state advanced exactly once per core tick")
check(controller.bridge.solver.layout.count==13,"stage 5 explicitly uses chassis slice")
local beforeSnapshot=controller.bridge.solver:pack()
local renderSnapshot=controller:renderSnapshot(77,123.5,1)
local afterSnapshot=controller.bridge.solver:pack()
check(renderSnapshot.seq==77 and renderSnapshot.tick==controller.bridge.state.tick and #renderSnapshot.wheels==4,"render snapshot captures compact presentation state")
for i,v in ipairs(beforeSnapshot) do check(v==afterSnapshot[i],"render snapshot cannot mutate authoritative solver state") end
run(120,1/60,input(0,1))
check(controller:telemetry().speed<speed*.7,"braking reduces core speed")
run(120,1/60,input(.7,0,.5))
check(math.abs(controller.bridge.state.components.chassis.velocity[6])>1e-4,"steering produces chassis yaw")
check(controller.roadAngle>0 and controller.dynamics.wheels[1].steer>0,"road wheel/steering visual input")
controller:reset();run(60,1/60,input(.7,0))
local reference=controller.bridge.solver:pack()
local checkpoint=controller.runner:checkpoint()
run(6,1/60,input(.7,0));local replay=controller.bridge.solver:pack()
controller.runner:restore(checkpoint);run(6,1/60,input(.7,0))
for i,v in ipairs(replay) do check(v==controller.bridge.solver:pack()[i],"stage 5 numeric replay") end
controller:reset();run(144,1/144,input(.7,0))
for i,v in ipairs(reference) do check(v==controller.bridge.solver:pack()[i],"30/144-style host rate independence") end
controller:reset();controller:step(.5,input(0,1));check(controller.bridge.state.tick==96,"substep budget")
controller:step(0,input(0,1));check(controller.bridge.state.tick==144,"backlog retained and drained")
controller:reset();wallZ=-15;controller.bridge:project({0,0,0},{20,0,0})
run(30,1/60,input(0,0))
check(wallHits>0 and car.Chassis.Position.Z>=wallZ+car.Chassis.Size.Z*.5-.05,"body sweep prevents translational tunnelling")
check(castCount>100,"geometry queries used while integrating numerically")
controller:exit(person);check(not humanoid.Sit and humanoid.Jump,"driver exits")
controller:destroy();check(not car.Chassis.Anchored and car.Chassis.CanCollide,"adapter restores physical ownership")
print(string.format("PASS: %d stage 5 checks; acceleration %.2f km/h; one wheel update per tick",checks,speed))
