-- Stage 11: the ORIGINAL per-frame runtime systems run inside the core (fuel burn and fuel mass, tyre thermal /
-- hot pressure / wear / failure, brake temperature, engine thermal / damage / failure, random failures, collision
-- damage). The adapter only starts the Stage 11 session with the race options (car attributes RaceDamageLevel 0..3,
-- RaceConsumptionRate 0..3, RosterSeries, RandomSeed; Stage11Runtime="frozen" = Stage 6-10 frame end for A/B),
-- offers TEST-ONLY event injection (DamageTestImpact = magnitude of one ORIGINAL collision record at the front
-- bumper, PitTyresTest = ORIGINAL 00550f10 x4) and reads telemetry from the original cells. No state is kept here.
-- Stage 10: garage setup at initialize/reset (car attributes Setup_<item> in display units, e.g.
-- Setup_springLF = 1700, Setup_camberLF = -2.5; legacy SetupBrakeBias/SetupGrilleTape/SetupSpoiler map to
-- items brakeBias/grilleTape/spoilerAngle). Each value goes through the ORIGINAL garage function 005581d0
-- (snap to the step grid + clamp), and the setup is applied by the ORIGINAL car build (core:applySetup).
-- Rebuild only when the setup changed; the rebuilt car is the core's reset image.
-- Stage 9: session air + aero setup at initialize/reset (car attributes), per-frame track normal and
-- test-only phantom draft (aeroHostInputs), aero telemetry. The aero forces themselves are computed
-- by the ORIGINAL core (00561a80/00561b70); the host applies no aero force.
-- Stage 6/7 host for mode NR2003_CUP: the ORIGINAL NR2003 Cup vehicle core owns all 45 states
-- (chassis, LF/RF suspension + hub + wheel, rear axle + LR/RR wheels, engine, clutch, output
-- shaft, head). Roblox only supplies contact planes (raycasts at the core's own wheel positions),
-- driver controls, and presentation. Nothing rendered feeds back into the core.
-- No ApplyImpulse / AssemblyMass / Roblox rigid-body integration for this car.
local Core=script.Parent.Parent.Core
local Vehicle=require(Core.NR2003CupVehicle)
local CupTune=require(Core.CupTune)
local Surface=require(Core.Surface)
local Fixed=require(Core.NR2003FixedStep)
local U=require(Core.MathUtil)
local Visual=require(script.Parent.VisualRig)
local SeatAccess=require(script.Parent.SeatAccess)
local Cockpit=require(script.Parent.Cockpit)
local RenderSnapshot=require(script.Parent.RenderSnapshot)
local M={};M.__index=M

-- NR2003 vehicle-world (+X fwd, +Y left, +Z up) <-> Roblox origin-local (+X right, +Y up, -Z fwd)
local function toLocal(x,y,z) return Vector3.new(-y,z,-x) end
local function fromLocal(v) return -v.Z,-v.X,v.Y end
-- R' = B R B^T for a row-major NR2003 body->world matrix
local function localRotation(r)
    return r[5],-r[6],r[4],
        -r[8],r[9],-r[7],
        r[2],-r[3],r[1]
end

function M.new(car,tune,remote)
    local cup=CupTune.new()
    local self=setmetatable({car=car,root=car.Chassis,tune=cup,benchTune=tune,telemetryTimer=0,debugVisible=false,
        fault=nil,renderSpin={},lastRenderSnapshotTime=nil,renderTeleport=true,pendingShift=0,steerAngle=0,
        planes={},inContact={},wheelPose={},contactPoints={},scratchPos={0,0,0},scratchRot={1,0,0,0,1,0,0,0,1}},M)
    for j=1,4 do
        self.planes[j]={0,0,1,0,0,0,0,1,1};self.inContact[j]=false
        self.wheelPose[j]={pos={0,0,0},rot={1,0,0,0,1,0,0,0,1},compression=0,steer=0,angle=0,rate=0}
        self.contactPoints[j]={point=Vector3.zero,grounded=false}
    end
    self.spawn=car:GetPivot();self.oldAnchored=self.root.Anchored;self.oldCollide=self.root.CanCollide
    car:SetAttribute("NR2003CorePoseOwner",true);car:SetAttribute("PhysicsMode","NR2003_CUP")
    car:SetAttribute("NR2003Tune","CupTune")
    self.root.Anchored=true;self.root.CanCollide=false
    self.root.AssemblyLinearVelocity=Vector3.zero;self.root.AssemblyAngularVelocity=Vector3.zero
    local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances={car};params.RespectCanCollide=true;params.IgnoreWater=false
    self.params=params
    self.visual=Visual.new(car,cup);self.access=SeatAccess.new(car,remote);Cockpit.ensure(car,cup)
    self.core=Vehicle.new(Core:WaitForChild("NR2003Cup"))
    self:initialize()
    return self
end

-- numeric frame: origin on the ground under the spawn pose (the core starts at z=0.42 m)
function M:groundOrigin(pivot)
    local hit=workspace:Raycast(pivot.Position+pivot.UpVector*2,-pivot.UpVector*60,self.params)
    local rot=pivot-pivot.Position
    if hit then return CFrame.new(hit.Position)*rot end
    return CFrame.new(pivot.Position-pivot.UpVector*(0.42/self.tune.metresPerStud))*rot
end
function M:worldPoint(x,y,z) return self.origin:PointToWorldSpace(toLocal(x,y,z)/self.tune.metresPerStud) end
function M:worldVector(x,y,z) return self.origin:VectorToWorldSpace(toLocal(x,y,z)) end
function M:numericPoint(p)
    local x,y,z=fromLocal(self.origin:PointToObjectSpace(p)*self.tune.metresPerStud);return x,y,z
end
function M:numericVector(v) local x,y,z=fromLocal(self.origin:VectorToObjectSpace(v));return x,y,z end

-- Stage 10: garage setup from the car attributes (nil when the core has no Stage 10 modules)
local LEGACY_SETUP={brakeBias="SetupBrakeBias",grilleTape="SetupGrilleTape",spoilerAngle="SetupSpoiler"}
function M:garageSetup()
    local Setup=self.core.V.Setup
    if not Setup then return nil end
    local s=Setup.cupGarageDefault()
    for i=0,70 do
        if Setup.adjustable(i) then
            local name=Setup.ITEM[i].name
            local v=self.car:GetAttribute("Setup_"..name)
            if not U.finite(v) and LEGACY_SETUP[name] then v=self.car:GetAttribute(LEGACY_SETUP[name]) end
            if U.finite(v) then Setup.set(s,i,v) end
        end
    end
    return s
end
function M:applyGarageSetup(s)
    local key=table.concat(s,",",0,183)
    if key==self.appliedSetupKey then return end
    local ok,rep=self.core:applySetup(s)
    self.car:SetAttribute("SetupStructure",rep.structure);self.car:SetAttribute("SetupApplySeconds",rep.seconds)
    if ok then
        self.appliedSetupKey=key;self.car:SetAttribute("SetupError",nil)
        local d=self.core:setupDump()
        local r=d.runtime
        print(string.format("[NR2003 Stage 10] setup aplicado (%s, %.2f s): molas %.0f/%.0f/%.0f/%.0f N/m, freio %.0f/%.0f N*m, marchas %.3f/%.3f/%.3f/%.3f x %.3f",
            rep.structure,rep.seconds or 0,r.springRate[1],r.springRate[2],r.springRate[3],r.springRate[4],r.brakeTorque[1],r.brakeTorque[3],
            r.gearRatio[3],r.gearRatio[4],r.gearRatio[5],r.gearRatio[6],r.finalDrive))
    else
        self.car:SetAttribute("SetupError",tostring(rep.firstViolation))
        warn("NR2003 Stage 10: setup não representável, mantido o anterior ("..tostring(rep.firstViolation)..")")
    end
end
function M:initialize()
    self.origin=self:groundOrigin(self.spawn)
    self.core:reset()
    local function num(name) local v=self.car:GetAttribute(name);return U.finite(v) and v or nil end
    local garage=self:garageSetup()
    if garage then
        -- Stage 10: the whole garage setup through the ORIGINAL build (brake bias, tape and spoiler included)
        self:applyGarageSetup(garage)
        self.brakeBias=select(2,self.core:brakeBias())
        self.car:SetAttribute("BrakeBiasApplied",self.brakeBias)
        local tape,spoiler=self.core:aeroSetup()
        self.car:SetAttribute("GrilleTapeApplied",tape);self.car:SetAttribute("SpoilerApplied",spoiler)
    else
        -- Stage 8: garage brake bias (setup item 0x28, % front, 50..90). Car attribute SetupBrakeBias;
        -- absent = shipped Cup default (74). Applied at build/reset only, like the original garage.
        local bias=self.car:GetAttribute("SetupBrakeBias")
        if U.finite(bias) then self.brakeBias=self.core:setBrakeBias(bias) else self.brakeBias=select(2,self.core:brakeBias()) end
        self.car:SetAttribute("BrakeBiasApplied",self.brakeBias)
        -- Stage 9: garage aero items read at run time by the original aero (00410280): grille tape
        -- (item 0x3b, % 0..100 step 5) and rear spoiler (item 0x3d, deg 45..70). Absent = Cup defaults.
        local tape,spoiler=self.core:setAeroSetup({grilleTape=num("SetupGrilleTape"),spoiler=num("SetupSpoiler")})
        self.car:SetAttribute("GrilleTapeApplied",tape);self.car:SetAttribute("SpoilerApplied",spoiler)
    end
    local tape,spoiler=self.core:aeroSetup()
    -- Stage 9: session start 005a3c00 = race weather settings (ADAPTER: car attributes standing for
    -- the race options; absent = original defaults 70 F, no wind, conditions 0, daytime). TrackNorth
    -- (rad) stands for the track's north angle (bdbcf8) in the core frame. AeroSession=false keeps the
    -- Stage 6/7/8 post-build state (no air) for A/B comparison.
    self.core:setDraftEnvironment(nil);self.core:setTrackNormal(nil)
    -- Stage 11: production = "original" runtime; Stage11Runtime="frozen" keeps the Stage 6-10 frame end (A/B only)
    local frozen=self.car:GetAttribute("Stage11Runtime")=="frozen"
    if self.core.V.setRuntimeMode then self.core:setRuntimeMode(frozen and "frozen" or "original") end
    if self.car:GetAttribute("AeroSession")==false then
        self.core:endSession();self.weather=nil
    else
        -- Stage 11 session options (race options of the original; absent = post-build values: damage scale 1.0,
        -- consumption x1, random stream state of the build). RosterSeries stands for the roster series field
        -- car+0x596 (PROVISIONAL host input, 1 = collision damage evaluated). The car is then placed on the
        -- track by the ORIGINAL 00550a50 subset (repair, engine and fuel init, four new tyres).
        self.weather=self.core:startSession({temperatureF=num("WeatherTemperatureF"),windSpeedMph=num("WeatherWindMph"),
            windDirection=num("WeatherWindDirection"),conditions=num("WeatherConditions"),night=self.car:GetAttribute("WeatherNight")==true,
            trackNorth=num("TrackNorth")},{damageLevel=num("RaceDamageLevel"),consumptionRate=num("RaceConsumptionRate"),
            series=num("RosterSeries"),seed=num("RandomSeed")})
    end
    self.stage11Out={}
    self.car:SetAttribute("AirDensityApplied",self.weather and self.weather.density or 0)
    self.aeroOut={};self.trackNormal=nil;self.draftTest=false
    local w=self.weather
    if w then
        print(string.format("[NR2003 Stage 9] sessão: %d F, condições %d, %s, vento %d mph dir %d -> ar %.2f C, rho %.7g kg/m3, vento (%.3f, %.3f) m/s | fita %d%%, aerofólio %d°",
            w.temperatureF,w.conditions,w.night and "noite" or "dia",w.windSpeedMph,w.windDirection,w.densityTemperatureC,w.density,w.wind[1],w.wind[2],tape,spoiler))
    else
        print("[NR2003 Stage 9] AeroSession=false: estado pós-build (sem ar, rho = 0)")
    end
    self.renderSpin={};self.lastRenderSnapshotTime=nil;self.renderTeleport=true
    for j=1,4 do self.inContact[j]=false end
    self.pendingShift=0;self.steerAngle=0
    local controller=self
    local stepper={state={tick=0}}
    function stepper:step(input) controller:tickCore(input);self.state.tick=controller.core:tick() end
    function stepper:checkpoint() return {core=controller.core:checkpoint(),origin=controller.origin,contact=table.clone(controller.inContact)} end
    function stepper:restore(c)
        controller.core:restore(c.core);controller.origin=c.origin;controller.inContact=table.clone(c.contact)
        self.state.tick=controller.core:tick();controller:pose(true)
    end
    self.stepper=stepper
    self.runner=Fixed.new(stepper,96)
    self.contactFn=function(phase) return self:contacts(phase) end
    self:pose(true)
end

-- contact planes at the CURRENT wheel positions of the core (called by the core twice per tick,
-- like 00578da0 / 00578de0). Plane: n.x + d = 0 in vehicle-world axes (0055e1e0 arguments).
function M:contacts(phase)
    local t=self.tune;local q=t.contactQuery;local mps=t.metresPerStud
    local occupant=self.car.DriverSeat.Occupant
    self.params.FilterDescendantsInstances=occupant and {self.car,occupant.Parent} or {self.car}
    local _,crot=self.core:componentPose(0,self.scratchPos,self.scratchRot)
    local ux,uy,uz=crot[3],crot[6],crot[9]                      -- chassis +Z in vehicle-world
    local upWorld=self:worldVector(ux,uy,uz)
    for j,c in ipairs(t.corners) do
        local w=self.wheelPose[j]
        local p=self.core:componentPose(c.record,w.pos,w.rot)
        local origin=self:worldPoint(p[1]+ux*q.rayAbove,p[2]+uy*q.rayAbove,p[3]+uz*q.rayAbove)
        local hit=workspace:Raycast(origin,-upWorld*(q.rayLength/mps),self.params)
        local plane=self.planes[j]
        if hit and hit.Normal:Dot(upWorld)>q.maximumSlopeCos then
            local nx,ny,nz=self:numericVector(hit.Normal)
            local px,py,pz=self:numericPoint(hit.Position)
            -- (+0 normalises signed zeros from the axis permutation; the track code passes +0)
            plane[1],plane[2],plane[3],plane[4]=nx+0,ny+0,nz+0,-(nx*px+ny*py+nz*pz)+0
            local gx,gy,gz=0,0,0
            if hit.Instance:IsA("BasePart") then
                gx,gy,gz=self:numericVector(hit.Instance:GetVelocityAtPosition(hit.Position)*mps)
            end
            plane[5],plane[6],plane[7]=gx+0,gy+0,gz+0
            local attr=hit.Instance:GetAttribute("NRSurface")
            plane[8]=U.finite(attr) and math.clamp(math.floor(attr),0,16) or (Surface.indices[hit.Material.Name] or 1)
            local grip=hit.Instance:GetAttribute("NRGripMultiplier")
            plane[9]=U.finite(grip) and math.clamp(grip,0,4) or 1
            if not self.inContact[j] then self.core:resetContactBlock(j-1,px,py,pz) end -- 005778a0 pair init
            self.inContact[j]=true
        else
            -- no geometry under the wheel: plane far below (tire separates). PROVISIONAL: the original
            -- simply has no contact pair for that wheel.
            plane[1],plane[2],plane[3]=ux,uy,uz
            plane[4]=-(ux*p[1]+uy*p[2]+uz*p[3])+q.noContactPlane
            plane[5],plane[6],plane[7],plane[8],plane[9]=0,0,0,1,1
            self.inContact[j]=false
        end
    end
    return self.planes
end

-- PROVISIONAL steering (Stage 12 pending): Stage 5 slew/speed law -> one road-wheel target;
-- the original 005539c0 adds the setup toe per side (lf = s - toe, rf = s + toe).
function M:steer(input,dt)
    local s=self.tune.steering
    local st=self.core:readState()
    local _,rot=self.core:componentPose(0,self.scratchPos,self.scratchRot)
    local speed=st[2]*rot[1]+st[4]*rot[4]+st[6]*rot[7]
    local fraction=math.max(s.minimumFraction,1/(1+math.abs(speed)*s.speedReduction))
    local command=U.clamp(input.steer or 0,-1,1)
    local target=command*s.maximum*fraction
    self.steerAngle=U.approach(self.steerAngle,target,(command==0 and s.returnRate or s.rate)*dt) -- + = right
end

function M:tickCore(input)
    local frame=self.core:tick()%8==0
    -- Stage 8: the brake goes through the ORIGINAL input chain (00552d00/00553080 -> bf6eac).
    -- The bench client sends keyboard keys (S/W = 0/1): NR2003 key binding (0057af60 digital).
    -- brakeAxis=true in the input selects the analog-axis binding for real pedals/triggers.
    -- No driver seated = 005524f0 'car not driven' branch (pedal held at 1.0).
    local controls
    if self:driver()==nil then
        controls={driver=false,throttle=0,clutch=0,steer=0}
    else
        local throttle=U.clamp(input.throttle or 0,0,1)
        controls={throttle=throttle,throttleControl=throttle,throttleDigital=input.throttleAxis~=true,
            brakeControl=U.clamp(input.brake or 0,0,1),brakeDigital=input.brakeAxis~=true,
            clutch=1-U.clamp(input.clutch or 0,0,1),steer=-self.steerAngle}
    end
    if frame and self.pendingShift~=0 and controls.driver~=false then
        controls.shiftUp=self.pendingShift>0;controls.shiftDown=self.pendingShift<0;self.pendingShift=0
    end
    if frame and self.weather then self:aeroHostInputs() end
    self.core:step(controls,self.contactFn)
    if self.core:tick()%8==0 and self.weather then self:stage11TestEvents() end
    self:pose(false)
end

-- Stage 11 TEST ADAPTER (not an NR2003 feature): one-shot attributes to exercise the ORIGINAL event paths on the
-- bench, which has no walls / other cars / pit lane. Applied after a frame end (where the original track contact code
-- would have entered the record during the frame).
--   DamageTestImpact = magnitude -> ORIGINAL 0054a760 record: front bumper point (car frame +2.4 m x), wall
--                      normal against the car's heading, wall material 1; evaluated by 00549c40 at the next frame end
--   PitTyresTest = true          -> ORIGINAL 00550f10 for the four wheels (pit tyre change)
function M:stage11TestEvents()
    local impact=self.car:GetAttribute("DamageTestImpact")
    if U.finite(impact) and impact>0 then
        self.car:SetAttribute("DamageTestImpact",nil)
        local st=self.core:readState()
        local p,r=self.core:componentPose(0,self.scratchPos,self.scratchRot)
        self.core:collision({magnitude=impact,material=0x10,surface=1,point={p[1]+2.4*r[1],p[2]+2.4*r[4],p[3]+2.4*r[7]},
            localPoint={2.4,0,0.3},velocity={st[2],st[4],st[6]},normal={-r[1],-r[4],-r[7]},speed=math.abs(st[2]*r[1]+st[4]*r[4]+st[6]*r[7])})
        print(string.format("[NR2003 Stage 11] TESTE: registro de colisão original (magnitude %.0f) na frente do carro",impact))
    end
    if self.car:GetAttribute("PitTyresTest")==true then
        self.car:SetAttribute("PitTyresTest",nil)
        self.core:pitTyres({0,1,2,3})
        print("[NR2003 Stage 11] TESTE: troca dos 4 pneus pelo 00550f10 original")
    end
end

-- Stage 9 per-frame host inputs of the aero, set before the frame's first tick (005637e0 order):
--  * track-object surface normal (0051370a -> car track object +0x24, used by 00561a80 to project the
--    wind): ADAPTER = mean normal of the grounded contact planes (core frame). Airborne: unchanged.
--  * drafting (005afd80): no other cars on the bench, so no race-order ring (factors stay 1.0).
--    TEST ADAPTER only: attribute DraftTestGap (m, > 0) puts a phantom car that far ahead on a straight
--    line along the core +X axis (lap distance = x, lateral = y + DraftTestLateral, same velocity as
--    the player, Cup wake), to exercise the ORIGINAL drafting code. Not an NR2003 feature.
function M:aeroHostInputs()
    local nx,ny,nz,n=0,0,0,0
    for j=1,4 do
        if self.inContact[j] then local p=self.planes[j];nx+=p[1];ny+=p[2];nz+=p[3];n+=1 end
    end
    if n>0 then
        local m=math.sqrt(nx*nx+ny*ny+nz*nz)
        if m>1e-6 then self.trackNormal={nx/m,ny/m,nz/m};self.core:setTrackNormal(self.trackNormal) end
    end
    local gap=self.car:GetAttribute("DraftTestGap")
    if U.finite(gap) and gap>0 then
        local st=self.core:readState()
        local lat=self.car:GetAttribute("DraftTestLateral");lat=U.finite(lat) and lat or 0
        local L=5000
        local other={lapDistance=(st[1]+gap)%L,lateral=st[3]+lat,vx=st[2],vy=st[4],vz=st[6]}
        self.core:setDraftEnvironment({trackLength=L,lapDistance=st[1]%L,lateral=st[3],ahead={other},behind={other}})
        self.draftTest=true
    elseif self.draftTest then
        self.core:setDraftEnvironment(nil);self.draftTest=false
    end
end

-- chassis pose from the core (+ host collision boundary). PROVISIONAL collision: a Blockcast of
-- the chassis box; on a hit the core is translated back through the ORIGINAL state import
-- 005b4560 (positions only). Momentum/velocity is not changed: NR2003 body collision response
-- (car-wall/car-car penalty forces) is not recovered yet.
function M:pose(teleport)
    local p,r=self.core:componentPose(0,self.scratchPos,self.scratchRot)
    local mps=self.tune.metresPerStud
    local function target()
        local lp=toLocal(p[1],p[2],p[3])/mps
        local r00,r01,r02,r10,r11,r12,r20,r21,r22=localRotation(r)
        return self.origin*CFrame.new(lp.X,lp.Y,lp.Z,r00,r01,r02,r10,r11,r12,r20,r21,r22)
    end
    local cf=target()
    if not teleport and self.rootCF then
        local delta=cf.Position-self.rootCF.Position
        if delta.Magnitude>1e-6 then
            local cast=self.rootCF*CFrame.new(0,self.tune.collision.raise/mps,0)
            local hit=workspace:Blockcast(cast,self.root.Size,delta,self.params)
            if hit then
                local allowed=self.rootCF.Position+delta.Unit*math.max(0,hit.Distance-0.01)
                local ax,ay,az=self:numericPoint(allowed)
                local tx,ty,tz=self:numericPoint(cf.Position)
                self.core:translate(ax-tx,ay-ty,az-tz) -- takes effect in the core's next tick
                cf=cf-cf.Position+allowed;self.collision=true
            else self.collision=false end
        end
    end
    self.rootCF=cf
end

function M:wheels()
    local _,cr=self.core:componentPose(0,self.scratchPos,self.scratchRot)
    local cp=self.scratchPos;local st=self.core:readState()
    for j,c in ipairs(self.tune.corners) do
        local w=self.wheelPose[j]
        local p,r=self.core:componentPose(c.record,w.pos,w.rot)
        local dx,dy,dz=p[1]-cp[1],p[2]-cp[2],p[3]-cp[3]
        w.compression=cr[3]*dx+cr[6]*dy+cr[9]*dz              -- centre height in chassis frame
        -- spin axis (wheel +Y column) in chassis frame -> road-wheel yaw (Stage 5 sign: + right)
        local ax=cr[1]*r[2]+cr[4]*r[5]+cr[7]*r[8]
        local ay=cr[2]*r[2]+cr[5]*r[5]+cr[8]*r[8]
        w.steer=math.atan2(ax,ay)
        w.angle=st[c.state.angle+1];w.rate=st[c.state.rate+1]
    end
    return self.wheelPose
end

function M:driver() return self.access:driver() end
function M:requestEntry(player) return self.access:request(player) end
function M:exit(player) return self.access:exit(player) end
function M:shift(delta) if U.finite(delta) and delta~=0 then self.pendingShift=delta>0 and 1 or -1 end end
function M:step(elapsed,input)
    self.access:step();self.telemetryTimer=self.telemetryTimer+elapsed
    if self.fault then return end
    local ok,reason=pcall(function()
        self:steer(input,elapsed)
        self.runner:advance(elapsed,input,nil)
        self.car:PivotTo(self.rootCF)
        self.car:SetAttribute("CoreTick",self.core:tick());self.car:SetAttribute("CoreCollision",self.collision==true)
        local wheels=self:wheels()
        for j=1,4 do
            local _,_,_,px,py,pz=self.core:contactOut(j-1)
            self.contactPoints[j].point=self:worldPoint(px,py,pz);self.contactPoints[j].grounded=self.inContact[j]
        end
        self.visual:update({wheels=wheels},self.contactPoints,self.debugVisible)
        Cockpit.update(self.car,self.tune,self.steerAngle)
    end)
    if not ok then self.fault=tostring(reason);self.car:SetAttribute("PhysicsFault",self.fault);warn("NR2003 Cup core paused: "..self.fault) end
end

function M:kinematics()
    local st=self.core:readState()
    local _,r=self.core:componentPose(0,self.scratchPos,self.scratchRot)
    local linear=self:worldVector(st[2],st[4],st[6])/self.tune.metresPerStud
    local bx,by,bz=st[11],st[12],st[13]                          -- body rates
    local angular=self:worldVector(r[1]*bx+r[2]*by+r[3]*bz,r[4]*bx+r[5]*by+r[6]*bz,r[7]*bx+r[8]*by+r[9]*bz)
    return linear,angular
end

function M:renderSnapshot(seq,time,vehicleId)
    local cf=self.root.CFrame
    local px,py,pz,r00,r01,r02,r10,r11,r12,r20,r21,r22=cf:GetComponents()
    local qx,qy,qz,qw=RenderSnapshot.quatFromMatrix(r00,r01,r02,r10,r11,r12,r20,r21,r22)
    local linear,angular=self:kinematics()
    local dt=self.lastRenderSnapshotTime and math.max(0,time-self.lastRenderSnapshotTime) or 0
    local wheels={}
    for j,w in ipairs(self.wheelPose) do
        local spin=RenderSnapshot.unwrapSpin(self.renderSpin[j],w.angle,w.rate,dt)
        self.renderSpin[j]=spin
        local localPoint=cf:PointToObjectSpace(self.contactPoints[j].point)
        wheels[j]={comp=w.compression,steer=w.steer,spin=spin,cx=localPoint.X,cy=localPoint.Y,cz=localPoint.Z,
            grounded=self.contactPoints[j].grounded}
    end
    local flags=self.renderTeleport and RenderSnapshot.FLAG_TELEPORT or 0
    self.renderTeleport=false;self.lastRenderSnapshotTime=time
    return {vehicleId=vehicleId or 1,seq=seq,flags=flags,tick=self.core:tick(),time=time,
        px=px,py=py,pz=pz,qx=qx,qy=qy,qz=qz,qw=qw,
        lx=linear.X,ly=linear.Y,lz=linear.Z,ax=angular.X,ay=angular.Y,az=angular.Z,
        steer=self.steerAngle,wheels=wheels}
end

function M:telemetry()
    local st=self.core:readState()
    local linear=self:kinematics()
    local _,r=self.core:componentPose(0,self.scratchPos,self.scratchRot)
    local forward=st[2]*r[1]+st[4]*r[4]+st[6]*r[7]
    local lf,rf,thr,brk,clu,gearIn=self.core:inputs()
    local wheels={}
    -- Stage 11: ORIGINAL runtime state (read-only view of the core cells)
    local s11=self.core.V.stage11State and self.core:stage11State(self.stage11Out) or nil
    for j,c in ipairs(self.tune.corners) do
        local fx,fy,fz=self.core:contactOut(j-1)
        local travel=st[c.state.travel+1]
        local w=self.wheelPose[j]
        -- Stage 8: original per-wheel brake/tire cells (no side effects on the core)
        local b=self.core:wheelBrake(j-1)
        local ty=s11 and s11.tyres[j]
        wheels[j]={name=c.name,load=self.inContact[j] and fz or 0,compression=travel,
            slip=b.vslip/math.max(math.abs(b.vx),2),
            omega=w.rate,temperature=ty and ty.surface[2]-273.15 or self.tune.environment.ambientC,grounded=self.inContact[j],
            tyreSurfaceK=ty and ty.surface,tyreCarcassK=ty and ty.carcass,tyrePressure=ty and ty.pressure,
            tyreWear=ty and ty.wear,tyreGrip=ty and ty.gripWear,tyreState=ty and ty.state,
            surface=self.planes[j][8],out1={fx,fy,fz},
            brakeTorque=b.torque,brakeCapacity=b.brakeCap,dragCapacity=b.dragCap,locked=b.locked,
            fx=b.fx,fy=b.fy,fz=b.fz,slipVelocity=b.vslip,brakeTemperatureK=b.temperature}
    end
    local pedal,target,tickValue,coreBrake=self.core:brakeState()
    local gear=self.core:gearIndex()
    -- Stage 9: ORIGINAL 00561b70 evaluated at the current state (read-only; see CORE_API.md)
    local a=self.core:aeroState(self.aeroOut)
    local tape,spoiler=self.core:aeroSetup()
    local aero={session=a.session,density=a.density,q=a.q,drag=a.drag,downforce=a.downforce,
        front=a.downforceFront,rear=a.downforceRear,side=a.side,mx=a.mx,my=a.my,mz=a.mz,
        factorDrag=a.factorDrag,factorFront=a.factorFront,factorRear=a.factorRear,airspeed=a.airspeedBody,
        yaw=a.yaw,pitch=a.pitch,rideHeight=a.rideHeightFront,proximity=a.groundProximity,stall=a.stall,
        windX=a.wind[1],windY=a.wind[2],grilleTape=tape,spoiler=spoiler,draftTest=self.draftTest==true}
    return {speed=linear.Magnitude*self.tune.metresPerStud*3.6,rpm=self.core:engineRpm(),
        gear=Vehicle.displayGear(gear),gearIndex=gear,wheels=wheels,torque=0,
        clutchSlip=st[35]-st[37],limiter=self.core:revLimiter(),
        throttleIn=thr,brakeIn=brk,clutchIn=clu,lfSteer=lf,rfSteer=rf,
        brakePedal=pedal,brakeTarget=target,brakeTick=tickValue,brakeCore=coreBrake,brakeBias=self.brakeBias,
        droppedTime=0,fault=self.fault,mode="NR2003_CUP",tick=self.core:tick(),backlog=self.runner.accumulator,
        chassisStateCount=45,chassisIntegration="NR2003 original JIT (005b39a0/005b3180/005b3e50/005b2fb0)",
        collision=self.collision==true,aero=aero,
        stage11=s11 and {mode=s11.mode,fuelKg=s11.fuel.kg,fuelRecordKg=s11.fuel.massRecord,water=s11.engine.water,oil=s11.engine.oil,
            coolantLevel=s11.engine.coolantLevel,oilLevel=s11.engine.oilLevel,power=s11.engine.power,life=s11.engine.life,
            overRev=s11.engine.overRev,damageScale=s11.damage.scale,engineDamage=s11.damage.engine,leakRadiator=s11.damage.radiator,
            leakOil=s11.damage.oil,leakFuel=s11.damage.fuel,zones=s11.damage.zones,failures=s11.damage.failures,
            broken=s11.damage.brokenFlags,airspeed=s11.airspeed,ambientK=s11.ambient} or nil,
        roadWheelAngle=self.steerAngle,steeringWheelAngle=Cockpit.angle(self.steerAngle,self.tune)}
end
function M:reset()
    self.car:PivotTo(self.spawn);self.fault=nil;self.car:SetAttribute("PhysicsFault",nil)
    self.rootCF=nil;self:initialize();self.car:PivotTo(self.rootCF)
end
function M:destroy()
    self.access:destroy();self.car:SetAttribute("NR2003CorePoseOwner",nil)
    self.root.Anchored=self.oldAnchored;self.root.CanCollide=self.oldCollide
end
return M
