local SOURCES = {}
SOURCES['Core.NR2003CupVehicle'] = [=[
-- Stage 6/7 vehicle core: the ORIGINAL NR2003 Cup car running in Luau.
-- Core.NR2003Cup holds code generated from NR2003.exe (recovery/stage6_7/gen_runtime.py):
--   NR2003CupImage1..n : memory image after the game's own car build (spec, setup defaults,
--                        tire/engine init, component graph, JIT cells, tables)
--   NR2003CupCore      : machine state + 86 lifted x86 natives + host primitives
--   NR2003CupJIT1..n   : the x87 callbacks NR2003 generates at car build, translated
--   NR2003CupDriver    : 005b2190 tick order, 00551e80/005539c0 driver layer (hand port)
--   NR2003CupAero      : Stage 9 session air (005a3c00), per-frame aero factors (005637e0),
--                        drafting (005afd80), aero setup items, aero telemetry (hand port)
--   NR2003CupSetup(+Data): Stage 10 garage setup: descriptors c05150, unit converters, garage API (hand port)
--   NR2003CupBuild, NR2003CupBuildCode1..n, NR2003CupBuildData1..n: Stage 10 ORIGINAL car-build sequence
--                        (setup -> runtime parameters) lifted from the exe, run on the core memory
--   NR2003CupGarage    : Stage 10 applySetup / setup inspection (orchestration only)
--   NR2003CupJITG1..n  : Stage 10 callbacks of the generic (setup-invariant) structure, translated
--   NR2003CupSteering  : Stage 12 ORIGINAL steering chain (00552720, 00551e80 tail, 00554fb0, options)
--   NR2003CupFFB       : Stage 13 ORIGINAL force feedback (00554d30, FFB block of 00554520, 0054fed0 / 00550070,
--                        options), exact x87 arithmetic; output = the DirectInput constant force (ADAPTER)
-- This module only assembles them and exposes a numeric API (no Instances, no Roblox types).
-- Axes: NR2003 vehicle-world frame (+X forward, +Y left, +Z up, metres, seconds) fixed at reset.
local M={};M.__index=M

local function collect(get,prefix)
    local list={}
    for k=1,32 do
        local m=get(prefix..k)
        if m==nil then break end
        list[#list+1]=m
    end
    return list
end
local function merge(parts)
    assert(#parts>0,"NR2003CupImage parts missing")
    local p=parts[1]
    local image={base=p.base,size=p.size,stackTop=p.stackTop,host=p.host,windows={}}
    for _,part in ipairs(parts) do
        assert(part.base==image.base and part.size==image.size,"mismatched image part")
        for _,w in ipairs(part.windows) do image.windows[#image.windows+1]=w end
    end
    assert(#parts==p.parts,"image has "..tostring(p.parts).." parts, found "..#parts)
    return image
end
-- get(name) -> module value or nil
function M.fromLoader(get)
    local image=merge(collect(get,"NR2003CupImage"))
    -- Watkins Glen port (absent without a track install): the ORIGINAL track / collision world memory (track arena,
    -- world pools, its stack) lies above the Stage 6/7 image; the core memory is created large enough for it. Nothing
    -- else changes until V.loadTrack() (NR2003CupTrack)
    local trackHost=get("NR2003CupTrack")
    local trackData=nil
    if trackHost then
        trackData=collect(get,"NR2003CupTrackData")
        assert(#trackData>0,"NR2003CupTrackData modules missing")
        image.size=math.max(image.size,trackData[1].top-image.base)
    end
    local jit=collect(get,"NR2003CupJIT")
    assert(#jit>0,"NR2003CupJIT modules missing")
    local V=get("NR2003CupDriver")(get("NR2003CupCore")(image,jit))
    local aero=get("NR2003CupAero") -- Stage 9 (absent in a Stage 6/7/8 install)
    if aero then aero(V) end
    -- Stage 11 (absent in a Stage 6..10 install). Installed before the garage: its image supplement becomes part
    -- of the reset image that the garage snapshots (applySetup of the default setup restores that image)
    local frame=get("NR2003CupFrame")
    if frame then
        frame(V,collect(get,"NR2003CupFrameCode"),collect(get,"NR2003CupFrameData"))
    end
    local build=get("NR2003CupBuild") -- Stage 10 (absent in a Stage 6/7/8/9 install)
    if build then
        local Setup=get("NR2003CupSetup")(get("NR2003CupSetupData"))
        local B=build(V,collect(get,"NR2003CupBuildCode"),collect(get,"NR2003CupBuildData"))
        get("NR2003CupGarage")(V,Setup,B,collect(get,"NR2003CupJITG"))
    end
    -- Stage 12 (absent in a Stage 6..11 install): ORIGINAL steering chain; installed last so that its option
    -- re-application wraps every reset (garage rebuilds included)
    local steering=get("NR2003CupSteering")
    if steering then steering(V) end
    -- Stage 13 (absent in a Stage 6..12 install): ORIGINAL force feedback; installed after the steering chain (it
    -- follows the control-7 binding written by the steering device layer) and after the frame end (its hooks)
    local ffb=get("NR2003CupFFB")
    if ffb then ffb(V) end
    -- Watkins Glen port: installed last (its enterTrack / reset / session wrappers are the outermost)
    if trackHost then
        trackHost(V,collect(get,"NR2003CupTrackCode"),trackData,
            {build=get("NR2003CupTrackBuild"),placed=collect(get,"NR2003CupJITP"),placedGeneric=collect(get,"NR2003CupJITPG")})
    end
    return setmetatable({V=V,state=table.create(45,0),pos={0,0,0},rot={1,0,0,0,1,0,0,0,1}},M)
end
function M.new(folder)
    folder=folder or (script and script.Parent:FindFirstChild("NR2003Cup"))
    assert(folder,"Core.NR2003Cup folder missing")
    return M.fromLoader(function(name)
        local m=folder:FindFirstChild(name)
        return m and require(m) or nil
    end)
end

function M:reset() self.V.reset() end
-- Watkins Glen port: load the track into the car's memory (NR2003CupTrack); the next session start / reset places
-- the car on it (ORIGINAL 005512f0) and the ORIGINAL collision world replaces the host contact planes
function M:loadTrack(opts) return self.V.loadTrack(opts) end
function M:trackLoaded() return self.V.trackLoaded ~= nil and self.V.trackLoaded() end
function M:tick() return self.V.tick end
-- controls: {throttle, clutch(engagement), shiftUp, shiftDown,
--   steerLeft/steerRight (Stage 12: raw steering controls 7/8, 0..1) + steerDigital (true = keys/buttons,
--   false = analog axis), or steerAxis (-1..1, + right: one analog axis split as the original device layer),
--   steer (road-wheel rad, + left: PROVISIONAL Stage 6-11 contract, only in the steering mode "provisional"),
--   brakeControl (Stage 8: raw brake device value 0..1 -> ORIGINAL 00552d00/00553080 chain),
--   brakeDigital (true = key/button binding, false = analog axis), throttleControl/throttleDigital,
--   driver (false -> 005524f0 'not driven': brake held at 1.0),
--   brake (no brakeControl: processed pedal injected directly, Stage 6/7 contract)}
-- contacts: 4 planes {nx,ny,nz,d,gvx,gvy,gvz,surface,grip} or function(phase) -> planes
function M:step(controls,contacts) self.V.drive(controls,contacts) end
-- Stage 8 brake API (original cells; see CORE_API.md)
function M:setBrakeBias(percent) return self.V.setBrakeBias(percent) end
function M:brakeBias() return self.V.brakeBias() end
function M:brakeState() return self.V.brakeState() end
function M:wheelBrake(i,out) return self.V.wheelBrake(i,out) end
function M:brakeTemperature(i) return self.V.brakeTemperature(i) end
-- Stage 9 aero API (original cells; see CORE_API.md). Without startSession the core keeps its
-- post-build state (no air: rho = 0), the condition of every Stage 6/7/8 fixture.
--   weather = {temperatureF, windSpeedMph, windDirection 0..7, conditions 0..3, night, trackNorth,
--              humidity, pressureInHg}  (nil fields = original defaults)
-- Stage 11: opts = {damageLevel 0..3, consumptionRate 0..3, series (car+0x596), seed} (see CORE_API.md)
function M:startSession(weather,opts) return self.V.startSession(weather,opts) end
function M:endSession() self.V.endSession() end
function M:sessionActive() return self.V.sessionActive() end
function M:weather() return self.V.weather() end
function M:setDraftEnvironment(env) self.V.setDraftEnvironment(env) end
function M:setTrackNormal(n) self.V.setTrackNormal(n) end
function M:aeroFactors() return self.V.aeroFactors() end
function M:setAeroSetup(s) return self.V.setAeroSetup(s) end
function M:aeroSetup() return self.V.aeroSetup() end
function M:aeroState(out) return self.V.aeroState(out) end
-- Stage 10 setup API (see CORE_API.md / SETUP_MAP.md). A setup is a raw array [0..183] in the
-- original c055c0 representation; edit it with M:setupModule() (Setup.set/step/display/...).
function M:setupModule() return self.V.Setup end
function M:defaultSetup() return self.V.Setup.cupGarageDefault() end
function M:setup() return self.V.setup() end
function M:applySetup(s) return self.V.applySetup(s) end
function M:setupReport() return self.V.setupReport() end
function M:setupDump(out) return self.V.setupDump(out) end
-- Stage 11 runtime systems (ORIGINAL frame end; see CORE_API.md). Mode "original" (default, production) or
-- "frozen" (the Stage 6-10 frame end, only for comparisons with the Stage 6-10 golden data).
function M:setRuntimeMode(m) self.V.setRuntimeMode(m) end
function M:runtimeMode() return self.V.runtimeMode() end
function M:stage11State(out) return self.V.stage11State(out) end
function M:collision(rec) self.V.collision(rec) end
function M:pitTyres(wheels) self.V.pitTyres(wheels) end
function M:enterTrack() self.V.enterTrack() end
function M:setDamageLevel(level) return self.V.setDamageLevel(level) end
function M:setConsumptionRate(rate) return self.V.setConsumptionRate(rate) end
function M:setRandomSeed(seed) self.V.setRandomSeed(seed) end
function M:randomState() return self.V.randomState() end
-- Stage 12 steering API (ORIGINAL chain; see CORE_API.md / STAGE12_STEERING_STATE_MAP.md)
function M:setSteeringMode(m) self.V.setSteeringMode(m) end
function M:steeringMode() return self.V.steeringMode() end
function M:setSteeringOptions(o) return self.V.setSteeringOptions(o) end
function M:steeringOptions() return self.V.steeringOptions() end
function M:steeringState(out) return self.V.steeringState(out) end
function M:steeringWheelAngle() return self.V.steeringWheelAngle() end
-- Stage 13 force feedback API (ORIGINAL chain; see CORE_API.md / STAGE13_FFB_STATE_MAP.md)
function M:setForceFeedbackOptions(o) return self.V.setForceFeedbackOptions(o) end
function M:forceFeedbackOptions() return self.V.forceFeedbackOptions() end
function M:setForceFeedbackDevice(d) self.V.setForceFeedbackDevice(d) end
function M:forceFeedbackState(out) return self.V.forceFeedbackState(out) end
function M:setControlsSuspended(flag) self.V.setControlsSuspended(flag) end
function M:controlsSuspended() return self.V.controlsSuspended() end
function M:selectActiveControls() self.V.selectActiveControls() end
function M:readState() return self.V.state(self.state) end
function M:componentPose(record,pos,rot) return self.V.componentPose(record,pos,rot) end
function M:contactOut(i) return self.V.contactOut(i) end
function M:resetContactBlock(i,x,y,z) self.V.resetContactBlock(i,x,y,z) end
function M:translate(dx,dy,dz) self.V.translate(dx,dy,dz) end
function M:checkpoint() return self.V.checkpoint() end
function M:restore(c) self.V.restore(c) end
function M:engineRpm() return self.V.engineRpm() end
function M:gearIndex() return self.V.gearIndex() end
function M:gearCount() return self.V.gearCount() end
function M:revLimiter() return self.V.revLimiter() end
function M:inputs() return self.V.inputs() end
-- Stage 5 HUD numbering: -1 R, 0 N, 1.. forward
function M.displayGear(index) return index-1 end
return M
]=]
SOURCES['Core.CupTune'] = [=[
-- NR2003 Cup (series 0, chassis type 2 "spdway") HOST/PRESENTATION geometry for Stage 6/7.
-- The physics does NOT read this table: mass, inertia, suspension, tires, engine, drivetrain,
-- setup and aero all live inside the original NR2003 memory image (Core.NR2003Cup).
-- Values here only place Roblox parts, aim contact queries and drive the cockpit visuals.
-- Sources (original component records 0x727290 + i*0x505, after the original build path):
--   lfsusp/rfsusp offset (1.2070, +-0.7684, -0.0982) m; raxle offset (-1.5870, 0, -0.2577);
--   lr/rr wheel offset in raxle (0, +-0.7684, 0.1042); wheel centre height at rest 0.3541/0.3509 m
--   (record +0x32d world-position cells, car settled on a flat plane).
-- Everything marked PROVISIONAL is a Roblox-side choice, not NR2003 data.
local U=require(script and script.Parent.MathUtil or "core.MathUtil")
local Base=require(script and script.Parent.TestTune or "core.TestTune")
local T={
    name="NR2003 Cup (original image)",version="3.6.0-stage7",originalCalibration=true,
    physics="NR2003_CUP: original 45-state core (Core.NR2003Cup)",
    reference={series=0,chassisType=2,spec="0x7238e0",tireProfiles="0x8b0c00",setup="descriptor defaults (c03350/c055c0)"},
    fixedStep=1/288,gravity=9.80665,
    metresPerStud=Base.metresPerStud,          -- same scale as the Stage 5 bench model
    kilogramsPerMassUnit=Base.kilogramsPerMassUnit,
    mass=1715,                                 -- static wheel-load sum / g (display only)
    chassisSize=Base.chassisSize,
    wheelbase=1.2070+1.5870,frontTrack=2*0.7684,rearTrack=2*0.7684,
    frontZ=-1.2070,rearZ=1.5870,               -- Roblox chassis frame: -Z forward
    -- VisualRig places hubs at (x, mountY - springFreeLength + compression, z); the Cup adapter
    -- sends compression = wheel-centre height relative to the chassis reference (record cells).
    mountY=0,springFreeLength=0,initialCompression=0,
    restCentre={front=0.3541-0.4174,rear=0.3509-0.4174},
    wheelRadius=0.354,wheelWidth=Base.wheelWidth,   -- loaded radius at rest (presentation)
    -- contact query (PROVISIONAL host choice): ray from wheel centre + up*rayAbove, length rayLength
    contactQuery={rayAbove=0.55,rayLength=1.45,maximumSlopeCos=0.25,noContactPlane=1000},
    -- host collision box (PROVISIONAL): chassis part box raised so its floor keeps the Stage 5
    -- bench clearance (~0.55 m) and ramps/kerbs are handled by the tires, not by the boundary
    collision={raise=0.32},
    -- steering: only the presentation fields (camber of the visual rig) are still read; the steering itself is the
    -- ORIGINAL chain since Stage 12 (NR2003CupSteering)
    steering=U.copy(Base.steering),
    -- Stage 12.1 driver defaults of the Roblox bench (car attributes override them at every reset, see
    -- CupChassisAdapter.initialize). The core default without these options is the original executable.
    --   steeringLockDegrees  steering-wheel rotation lock to lock at full input: 360 = the ORIGINAL x pi (180 deg per
    --                        side, 00551e80); other values are a NON-ORIGINAL extension (attribute SteeringLockDegrees)
    --   setupSteeringRatio   garage item 0x30 (12..32) used when the car has no Setup_steeringRatio attribute, applied
    --                        through the ORIGINAL garage pipeline (the shipped Cup setup has 18)
    --   momentumKeys         steering momentum (0..100, original setter 005500c0) while the keys drive the steering;
    --                        nil = the executable's image rate 0.033 / frame (smooth keys, no controls.cfg)
    --   momentumAxis         the same while an analog axis (gamepad / mouse) drives it: 0 = no slew and no sine (the
    --                        front-end default of a saved controls.cfg)
    --   cockpitLimit         cockpit wheel draw limit: "lock" = the full lock (180 deg per side at 360), "original" =
    --                        the 005662d0 limit 2.79 rad (160 deg)
    driver={steeringLockDegrees=360,setupSteeringRatio=12,momentumKeys=nil,momentumAxis=0,cockpitLimit="lock",
        -- Stage 13 bench defaults (car attributes override): force feedback ON with the image values of the executable
        -- (strength 80, damping 0, latency 0 = no controls.cfg), FF output present (HUD + gamepad motors). The original
        -- default without controls.cfg is OFF; the effect still needs the steering on an analog axis (0054fed0)
        ffbEnabled=true,ffbStrength=nil,ffbDamping=nil,ffbLatency=nil,ffbDevice=true,
        -- presentation only (NOT original): the constant force drives the large motor of the active gamepad with |force|
        -- (Roblox has no directional force feedback); false = HUD only
        ffbRumble=true},
    engine={gears=4,limiterRPM=9300},          -- engine+0x444 / engine+0x438 (display)
    environment={ambientC=26.6667},            -- e0b830 (tire thermal frozen: Stage 11)
    adapter=U.copy(Base.adapter),
}
T.steering.ackermann=0; T.steering.toe=0; T.steering.camber=0 -- toe comes from c086b0/c086b4
function T.new()
    local p=U.copy(T); p.new=nil
    p.corners={
        {name="FL",x=-0.7684,z=-1.2070,front=true,side=-1,record=5,hub=4,state={angle=17,rate=18,travel=13}},
        {name="FR",x=0.7684,z=-1.2070,front=true,side=1,record=8,hub=7,state={angle=23,rate=24,travel=19}},
        {name="RL",x=-0.7684,z=1.5870,front=false,side=-1,record=10,state={angle=29,rate=30,travel=25}},
        {name="RR",x=0.7684,z=1.5870,front=false,side=1,record=11,state={angle=31,rate=32,travel=25}},
    }
    return p
end
return T
]=]
SOURCES['Core.NR2003FixedStep'] = [=[
-- Scheduling uses 1/288 wall seconds; equations use the recovered float32 dt.
-- Backlog is retained and exposed. Rendering never changes the simulation step.
local Math=require(script and script.Parent.NR2003Math or "NR2003Math")
local M={}; M.__index=M
function M.new(solver,maxSteps)
    maxSteps=maxSteps or 96
    assert(maxSteps>=1 and maxSteps%1==0,"Invalid maxSteps")
    return setmetatable({solver=solver,accumulator=0,wallStep=1/288,maxSteps=maxSteps},M)
end
function M:advance(elapsed,inputProvider,contactProvider)
    assert(Math.finite(elapsed) and elapsed>=0,"Invalid elapsed time")
    self.accumulator=self.accumulator+elapsed
    local count=0
    while self.accumulator+1e-12>=self.wallStep and count<self.maxSteps do
        local tick=self.solver.state.tick
        local input=type(inputProvider)=="function" and inputProvider(tick,self.solver) or inputProvider
        local contacts=type(contactProvider)=="function" and contactProvider(tick,self.solver) or contactProvider
        self.solver:step(input,contacts)
        self.accumulator=self.accumulator-self.wallStep; count=count+1
    end
    if math.abs(self.accumulator)<1e-12 then self.accumulator=0 end
    return count,self.accumulator/self.wallStep
end
function M:checkpoint() return {accumulator=self.accumulator,solver=self.solver:checkpoint()} end
function M:restore(c)
    assert(Math.finite(c.accumulator) and c.accumulator>=0,"Invalid backlog")
    self.solver:restore(c.solver); self.accumulator=c.accumulator
end
return M
]=]
SOURCES['Core.NR2003Math'] = [=[
-- Numeric cells of the 005b7xxx/005b8xxx expression engine, row-major matrices.
-- Each primitive corresponds to a stored float cell, not arbitrary Lua arithmetic.
local F = require(script and script.Parent.Float32 or "Float32")
local M = {f=F.round}
local f=F.round
function M.copy(a) local b={} for i=1,#a do b[i]=a[i] end return b end
function M.zero(n) local a={} for i=1,n do a[i]=0 end return a end
function M.eye(n) local a=M.zero(n*n) for i=1,n do a[(i-1)*n+i]=1 end return a end
function M.add(a,b) local c={} for i=1,#a do c[i]=f(a[i]+b[i]) end return c end
function M.sub(a,b) local c={} for i=1,#a do c[i]=f(a[i]-b[i]) end return c end
function M.scale(a,s) local c={} for i=1,#a do c[i]=f(a[i]*s) end return c end
function M.dot(a,b) local s=0 for i=1,#a do s=f(s+f(a[i]*b[i])) end return s end
function M.transpose(a,rows,cols)
    local b={} for i=1,rows do for j=1,cols do b[(j-1)*rows+i]=a[(i-1)*cols+j] end end return b
end
function M.mul(a,b,rows,inner,cols)
    local c={} for i=1,rows do for j=1,cols do
        local s=0 for k=1,inner do s=f(s+f(a[(i-1)*inner+k]*b[(k-1)*cols+j])) end
        c[(i-1)*cols+j]=s
    end end return c
end
function M.mv(a,b,n) return M.mul(a,b,n,#b,1) end
function M.slice(a,start,n) local b={} for i=1,n do b[i]=a[start+i-1] end return b end
function M.join(a,b) local c=M.copy(a) for _,x in ipairs(b) do c[#c+1]=x end return c end
function M.cross(a,b)
    return {f(f(a[2]*b[3])-f(a[3]*b[2])),f(f(a[3]*b[1])-f(a[1]*b[3])),f(f(a[1]*b[2])-f(a[2]*b[1]))}
end
function M.skew(a) return {0,-a[3],a[2],a[3],0,-a[1],-a[2],a[1],0} end
function M.wrap(a)
    local pi=f(math.pi); local tau=f(2*pi)
    while a>=pi do a=f(a-tau) end while a < -pi do a=f(a+tau) end return a
end
function M.axisRotation(axis,angle)
    local c,s=f(math.cos(angle)),f(math.sin(angle))
    if axis==1 then return {1,0,0,0,c,-s,0,s,c}
    elseif axis==2 then return {c,0,s,0,1,0,-s,0,c}
    else return {c,-s,0,s,c,0,0,0,1} end
end
function M.quatMultiply(a,b)
    local av,bv=M.slice(a,1,3),M.slice(b,1,3)
    return M.join(M.add(M.add(M.scale(bv,a[4]),M.scale(av,b[4])),M.cross(av,bv)),
        {f(f(a[4]*b[4])-M.dot(av,bv))})
end
function M.normalizeQuaternion(q)
    local n=M.dot(q,q); assert(n>0 and n<math.huge,"Invalid quaternion")
    return M.scale(q,f(1/f(math.sqrt(n))))
end
function M.quatRotation(q)
    local x,y,z,w=q[1],q[2],q[3],q[4]
    local w2,x2,y2,z2=f(2*w),f(2*x),f(2*y),f(2*z)
    local wx,wy,wz,ww=f(w2*x),f(w2*y),f(w2*z),f(w2*w)
    local xx,xy,xz,yy,yz,zz=f(x2*x),f(x2*y),f(x2*z),f(y2*y),f(y2*z),f(z2*z)
    return {f(f(ww+xx)-1),f(xy-wz),f(xz+wy),f(xy+wz),f(f(ww+yy)-1),f(yz-wx),
        f(xz-wy),f(yz+wx),f(f(ww+zz)-1)}
end
function M.finite(x) return type(x)=="number" and x==x and math.abs(x)<math.huge end
function M.vector(a,n,label)
    assert(type(a)=="table" and #a==n,(label or "vector")..": wrong size")
    for i=1,n do assert(M.finite(a[i]),(label or "vector")..": non-finite value") end
    return a
end
return M
]=]
SOURCES['Core.Float32'] = [=[
-- Round values assigned to C float fields. Extended x87 registers are not emulated.
local M = {}
local storage
if buffer then storage = buffer.create(4) end
function M.round(value)
    if storage then
        buffer.writef32(storage, 0, value)
        return buffer.readf32(storage, 0)
    end
    if string.pack and string.unpack then
        return (string.unpack("<f", string.pack("<f", value)))
    end
    error("Float32 requires Roblox buffer or Lua 5.3+ string.pack")
end
function M.bits(value)
    if storage then buffer.writef32(storage,0,value); return buffer.readu32(storage,0) end
    return (string.unpack("<I4",string.pack("<f",value)))
end
function M.fromBits(value)
    if storage then buffer.writeu32(storage,0,value); return buffer.readf32(storage,0) end
    return (string.unpack("<f",string.pack("<I4",value)))
end
function M.inverseSqrt(x)
    -- 0054cab0, bit reinterpretation (decompiler casts are misleading).
    local bits=math.floor(((0xbe7ffffd-M.bits(x))%4294967296)/2)
    local y=M.fromBits(bits)
    y=M.round((1.5-y*y*0.5*x)*y)
    return M.round((1.5-y*y*0.5*x)*y)
end
return M
]=]
SOURCES['Core.Surface'] = [=[
local Data=require(script and script.Parent.RecoveredData or "core.RecoveredData")
local U=require(script and script.Parent.MathUtil or "core.MathUtil")
local M={}
M.indices={Asphalt=1,Concrete=2,Brick=3,Cobblestone=3,Grass=5,LeafyGrass=5,Ground=6,Mud=6,
    Sand=7,Pebble=8,Water=9,Metal=10,Wood=16,WoodPlanks=16}
function M.grip(index,multiplier)
    local row=Data.surfaces[(index or 1)+1] or Data.surfaces[2]
    return row.base*(multiplier or 1)
end
function M.resolve(name,index,multiplier)
    if not U.finite(index) then index=nil end
    if not U.finite(multiplier) then multiplier=1 end
    multiplier=U.clamp(multiplier,0,4)
    index=math.max(0,math.min(19,math.floor(index or M.indices[name] or 0)))
    return {index=index,grip=M.grip(index,multiplier)}
end
return M
]=]
SOURCES['Core.RecoveredData'] = [=[
-- Generated from included Ghidra memory exports; embedded pre-setup defaults only.
-- Not a calibrated/drivable car tune. Preserve raw records for future recovery.
return {
    sourceCommit = "03bcafb44cf63464493f1864edbd9f781fac24f4",
    recordBytes = 0x505,
    angleScale = 0.01745329238474369,
    trackDefaults = { ["track_tire_wear"] = 1.0, ["track_tire_heat"] = 1.0, ["track_tire_wear_loss"] = 0.20000000298023224, ["track_tire_wear_exp"] = 1.0 },
    surfaces = {
        { ["index"] = 0, ["key"] = "track_undefined_grip", ["base"] = 0.800000011920929 },
        { ["index"] = 1, ["key"] = "track_asphalt_grip", ["base"] = 0.800000011920929 },
        { ["index"] = 2, ["key"] = "track_concrete_grip", ["base"] = 0.7680000066757202 },
        { ["index"] = 3, ["key"] = "track_rumble_grip", ["base"] = 0.7680000066757202 },
        { ["index"] = 4, ["key"] = "track_paint_grip", ["base"] = 0.7199999690055847 },
        { ["index"] = 5, ["key"] = "track_grass_grip", ["base"] = 0.46399998664855957 },
        { ["index"] = 6, ["key"] = "track_dirt_grip", ["base"] = 0.5199999809265137 },
        { ["index"] = 7, ["key"] = "track_sand_grip", ["base"] = 0.64000004529953 },
        { ["index"] = 8, ["key"] = "track_gravel_grip", ["base"] = 0.64000004529953 },
        { ["index"] = 9, ["key"] = "track_water_grip", ["base"] = 0.08000000566244125 },
        { ["index"] = 10, ["key"] = "track_armco_grip", ["base"] = 0.7199999690055847 },
        { ["index"] = 11, ["key"] = "track_tire_wall_grip", ["base"] = 0.800000011920929 },
        { ["index"] = 12, ["key"] = "track_haybale_grip", ["base"] = 0.35999998450279236 },
        { ["index"] = 13, ["key"] = "track_chain_fence_grip", ["base"] = 0.5600000023841858 },
        { ["index"] = 14, ["key"] = "track_shrub_grip", ["base"] = 0.320000022649765 },
        { ["index"] = 15, ["key"] = "track_forest_grip", ["base"] = 0.320000022649765 },
        { ["index"] = 16, ["key"] = "track_wood_fence_grip", ["base"] = 0.64000004529953 },
        { ["index"] = 17, ["key"] = "track_chassis_grip", ["base"] = 0.7199999690055847 },
        { ["index"] = 18, ["key"] = "track_opp_wheel_grip", ["base"] = 0.800000011920929 },
        { ["index"] = 19, ["key"] = "track_wheel_grip", ["base"] = 0.800000011920929 },
    },
    components = {
        { ["index"] = 0, ["address"] = "00727290", ["name"] = "chassis", ["parentName"] = "inertial", ["flags"] = 39, ["rawFieldsF32"] = { ["0x44"] = 0.0, ["0x48"] = 0.0, ["0x4c"] = 0.0, ["0x51"] = 0.0, ["0x55"] = 0.0, ["0x59"] = 0.0, ["0x5d"] = 584.7999877929688, ["0x61"] = 39.599998474121094, ["0x65"] = 325.20001220703125, ["0x69"] = 324.0 }, ["rawHex"] = "6368617373697300000000000000000000000000000000000000000000000000696e65727469616c00000000000000000000000000000000000000000000000027000000000000000000000000000000000000000000000000000000003333124466661e429a99a2430000a24300000000000000000000000000000000000000000000000000000000000000000000000000000000647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400" },
        { ["index"] = 1, ["address"] = "00727795", ["name"] = "ballast", ["parentName"] = "chassis", ["flags"] = 0, ["rawFieldsF32"] = { ["0x44"] = 0.0, ["0x48"] = 0.0, ["0x4c"] = 0.0, ["0x51"] = 0.0, ["0x55"] = 0.0, ["0x59"] = 0.0, ["0x5d"] = 136.0800018310547, ["0x61"] = 0.0, ["0x65"] = 0.0, ["0x69"] = 0.0 }, ["rawHex"] = "62616c6c61737400000000000000000000000000000000000000000000000000636861737369730000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007b14084300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400" },
        { ["index"] = 2, ["address"] = "00727c9a", ["name"] = "fuel", ["parentName"] = "chassis", ["flags"] = 0, ["rawFieldsF32"] = { ["0x44"] = 0.3499999940395355, ["0x48"] = 0.0, ["0x4c"] = 0.05000000074505806, ["0x51"] = 0.0, ["0x55"] = 0.0, ["0x59"] = 0.0, ["0x5d"] = 62.316741943359375, ["0x61"] = 6.2316741943359375, ["0x65"] = 6.2316741943359375, ["0x69"] = 6.2316741943359375 }, ["rawHex"] = "6675656c000000000000000000000000000000000000000000000000000000006368617373697300000000000000000000000000000000000000000000000000000000003333b33e00000000cdcc4c3d0000000000000000000000000058447942e069c740e069c740e069c74000000000000000000000000000000000000000000000000000000000000000000000000000000000647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400" },
        { ["index"] = 3, ["address"] = "0072819f", ["name"] = "lfsusp", ["parentName"] = "chassis", ["flags"] = 4, ["rawFieldsF32"] = { ["0x44"] = 1.5199999809265137, ["0x48"] = 0.7620000243186951, ["0x4c"] = -0.1550000011920929, ["0x51"] = 0.0, ["0x55"] = 0.0, ["0x59"] = 0.0, ["0x5d"] = 0.0, ["0x61"] = 0.0, ["0x65"] = 0.0, ["0x69"] = 0.0 }, ["rawHex"] = "6c667375737000000000000000000000000000000000000000000000000000006368617373697300000000000000000000000000000000000000000000000000040000005c8fc23f6f12433f52b81ebe000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400" },
        { ["index"] = 4, ["address"] = "007286a4", ["name"] = "lfhub", ["parentName"] = "lfsusp", ["flags"] = 768, ["rawFieldsF32"] = { ["0x44"] = 0.0, ["0x48"] = 0.0, ["0x4c"] = 0.0, ["0x51"] = 0.0, ["0x55"] = 0.0, ["0x59"] = 0.0, ["0x5d"] = 30.0, ["0x61"] = 0.8500000238418579, ["0x65"] = 0.10000000149011612, ["0x69"] = 0.8500000238418579 }, ["rawHex"] = "6c666875620000000000000000000000000000000000000000000000000000006c6673757370000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000000f0419a99593fcdcccc3d9a99593f00000000000000000000000000000000000000000000000000000000000000000000000000000000647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400" },
        { ["index"] = 5, ["address"] = "00728ba9", ["name"] = "lfwheel", ["parentName"] = "lfhub", ["flags"] = 80, ["rawFieldsF32"] = { ["0x44"] = 0.0, ["0x48"] = 0.0, ["0x4c"] = 0.0, ["0x51"] = 0.0, ["0x55"] = 0.0, ["0x59"] = 0.0, ["0x5d"] = 0.0, ["0x61"] = 0.0, ["0x65"] = 1.7100000381469727, ["0x69"] = 0.0 }, ["rawHex"] = "6c66776865656c000000000000000000000000000000000000000000000000006c666875620000000000000000000000000000000000000000000000000000005000000000000000000000000000000000000000000000000000000000000000000000000048e1da3f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400" },
        { ["index"] = 6, ["address"] = "007290ae", ["name"] = "rfsusp", ["parentName"] = "chassis", ["flags"] = 4, ["rawFieldsF32"] = { ["0x44"] = 1.5199999809265137, ["0x48"] = -0.7620000243186951, ["0x4c"] = -0.1550000011920929, ["0x51"] = 0.0, ["0x55"] = 0.0, ["0x59"] = 0.0, ["0x5d"] = 0.0, ["0x61"] = 0.0, ["0x65"] = 0.0, ["0x69"] = 0.0 }, ["rawHex"] = "72667375737000000000000000000000000000000000000000000000000000006368617373697300000000000000000000000000000000000000000000000000040000005c8fc23f6f1243bf52b81ebe000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400" },
        { ["index"] = 7, ["address"] = "007295b3", ["name"] = "rfhub", ["parentName"] = "rfsusp", ["flags"] = 768, ["rawFieldsF32"] = { ["0x44"] = 0.0, ["0x48"] = 0.0, ["0x4c"] = 0.0, ["0x51"] = 0.0, ["0x55"] = 0.0, ["0x59"] = 0.0, ["0x5d"] = 30.0, ["0x61"] = 0.8500000238418579, ["0x65"] = 0.10000000149011612, ["0x69"] = 0.8500000238418579 }, ["rawHex"] = "7266687562000000000000000000000000000000000000000000000000000000726673757370000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000000f0419a99593fcdcccc3d9a99593f00000000000000000000000000000000000000000000000000000000000000000000000000000000647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400" },
        { ["index"] = 8, ["address"] = "00729ab8", ["name"] = "rfwheel", ["parentName"] = "rfhub", ["flags"] = 80, ["rawFieldsF32"] = { ["0x44"] = 0.0, ["0x48"] = 0.0, ["0x4c"] = 0.0, ["0x51"] = 0.0, ["0x55"] = 0.0, ["0x59"] = 0.0, ["0x5d"] = 0.0, ["0x61"] = 0.0, ["0x65"] = 1.7100000381469727, ["0x69"] = 0.0 }, ["rawHex"] = "7266776865656c0000000000000000000000000000000000000000000000000072666875620000000000000000000000000000000000000000000000000000005000000000000000000000000000000000000000000000000000000000000000000000000048e1da3f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400" },
        { ["index"] = 9, ["address"] = "00729fbd", ["name"] = "raxle", ["parentName"] = "chassis", ["flags"] = 12, ["rawFieldsF32"] = { ["0x44"] = -0.8930000066757202, ["0x48"] = 0.0, ["0x4c"] = -0.2199999988079071, ["0x51"] = 0.0, ["0x55"] = 0.0, ["0x59"] = 0.0, ["0x5d"] = 97.5, ["0x61"] = 5.0, ["0x65"] = 0.5, ["0x69"] = 5.0 }, ["rawHex"] = "7261786c6500000000000000000000000000000000000000000000000000000063686173736973000000000000000000000000000000000000000000000000000c000000a69b64bf00000000ae4761be010000000000000000000000000000c3420000a0400000003f0000a04000000000000000000000000000000000000000000000000000000000000000000000000000000000647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400" },
        { ["index"] = 10, ["address"] = "0072a4c2", ["name"] = "lrwheel", ["parentName"] = "raxle", ["flags"] = 80, ["rawFieldsF32"] = { ["0x44"] = 0.0, ["0x48"] = 0.7620000243186951, ["0x4c"] = 0.0, ["0x51"] = 0.0, ["0x55"] = 0.0, ["0x59"] = 0.0, ["0x5d"] = 40.0, ["0x61"] = 1.350000023841858, ["0x65"] = 1.659999966621399, ["0x69"] = 1.350000023841858 }, ["rawHex"] = "6c72776865656c000000000000000000000000000000000000000000000000007261786c6500000000000000000000000000000000000000000000000000000050000000000000006f12433f000000000100000000000000000000000000002042cdccac3fe17ad43fcdccac3f00000000000000000000000000000000000000000000000000000000000000000000000000000000647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400" },
        { ["index"] = 11, ["address"] = "0072a9c7", ["name"] = "rrwheel", ["parentName"] = "raxle", ["flags"] = 80, ["rawFieldsF32"] = { ["0x44"] = 0.0, ["0x48"] = -0.7620000243186951, ["0x4c"] = 0.0, ["0x51"] = 0.0, ["0x55"] = 0.0, ["0x59"] = 0.0, ["0x5d"] = 40.0, ["0x61"] = 1.350000023841858, ["0x65"] = 1.659999966621399, ["0x69"] = 1.350000023841858 }, ["rawHex"] = "7272776865656c000000000000000000000000000000000000000000000000007261786c6500000000000000000000000000000000000000000000000000000050000000000000006f1243bf000000000100000000000000000000000000002042cdccac3fe17ad43fcdccac3f00000000000000000000000000000000000000000000000000000000000000000000000000000000647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400" },
        { ["index"] = 12, ["address"] = "0072aecc", ["name"] = "engine", ["parentName"] = "chassis", ["flags"] = 72, ["rawFieldsF32"] = { ["0x44"] = 0.0, ["0x48"] = 0.0, ["0x4c"] = 0.0, ["0x51"] = 180.0, ["0x55"] = 0.0, ["0x59"] = 0.0, ["0x5d"] = 0.0, ["0x61"] = 0.11999999731779099, ["0x65"] = 0.0, ["0x69"] = 0.0 }, ["rawHex"] = "656e67696e65000000000000000000000000000000000000000000000000000063686173736973000000000000000000000000000000000000000000000000004800000000000000000000000000000000000034430000000000000000000000008fc2f53d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400" },
        { ["index"] = 13, ["address"] = "0072b3d1", ["name"] = "clutch", ["parentName"] = "chassis", ["flags"] = 72, ["rawFieldsF32"] = { ["0x44"] = 0.0, ["0x48"] = 0.0, ["0x4c"] = 0.0, ["0x51"] = 180.0, ["0x55"] = 0.0, ["0x59"] = 0.0, ["0x5d"] = 0.0, ["0x61"] = 0.07999999821186066, ["0x65"] = 0.0, ["0x69"] = 0.0 }, ["rawHex"] = "636c75746368000000000000000000000000000000000000000000000000000063686173736973000000000000000000000000000000000000000000000000004800000000000000000000000000000000000034430000000000000000000000000ad7a33d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400" },
        { ["index"] = 14, ["address"] = "0072b8d6", ["name"] = "outshaft", ["parentName"] = "chassis", ["flags"] = 72, ["rawFieldsF32"] = { ["0x44"] = 0.0, ["0x48"] = 0.0, ["0x4c"] = 0.0, ["0x51"] = 180.0, ["0x55"] = 0.0, ["0x59"] = 0.0, ["0x5d"] = 0.0, ["0x61"] = 0.11999999731779099, ["0x65"] = 0.0, ["0x69"] = 0.0 }, ["rawHex"] = "6f7574736861667400000000000000000000000000000000000000000000000063686173736973000000000000000000000000000000000000000000000000004800000000000000000000000000000000000034430000000000000000000000008fc2f53d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400" },
        { ["index"] = 15, ["address"] = "0072bddb", ["name"] = "head", ["parentName"] = "chassis", ["flags"] = 7, ["rawFieldsF32"] = { ["0x44"] = 0.05000000074505806, ["0x48"] = 0.0, ["0x4c"] = 0.4099999964237213, ["0x51"] = 0.0, ["0x55"] = 0.0, ["0x59"] = 0.0, ["0x5d"] = 3.0, ["0x61"] = 0.0, ["0x65"] = 0.0, ["0x69"] = 0.0 }, ["rawHex"] = "6865616400000000000000000000000000000000000000000000000000000000636861737369730000000000000000000000000000000000000000000000000007000000cdcc4c3d0000000085ebd13e000000000000000000000000000000404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd4005cfd7400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400647dd400" },
    },
}
]=]
SOURCES['Core.MathUtil'] = [=[
local M={}
function M.clamp(x,a,b) return math.max(a,math.min(b,x)) end
function M.sign(x) return x<0 and -1 or (x>0 and 1 or 0) end
function M.finite(x) return type(x)=="number" and x==x and math.abs(x)<math.huge end
function M.approach(x,target,amount) return x+M.clamp(target-x,-amount,amount) end
function M.copy(t)
    if type(t)~="table" then return t end
    local c={}; for k,v in pairs(t) do c[k]=M.copy(v) end; return c
end
function M.atan2(y,x) if math.atan2 then return math.atan2(y,x) end return math.atan(y,x) end
function M.assertFinite(t,label)
    for k,v in pairs(t) do
        if type(v)=="number" then assert(M.finite(v),(label or "state").."."..tostring(k)) end
    end
end
return M
]=]
SOURCES['Core.TestTune'] = [=[
-- SI units. Diagnostic RWD tune; NOT an extracted NR2003 Cup setup.
local U=require(script and script.Parent.MathUtil or "core.MathUtil")
local T={
    name="NR2003 Lab RWD",version="3.5.0-stage5",originalCalibration=false,
    sourceCommit="03bcafb44cf63464493f1864edbd9f781fac24f4",
    solver="Selected by Roblox.ModeConfig; numeric chassis + raycast suspension by default",rounding="nearest",
    fixedStep=1/288,maxFrame=1/15,gravity=9.80665,
    metresPerStud=0.28,kilogramsPerMassUnit=21.952,mass=1500,
    chassisSize={1.78,0.38,4.45},wheelbase=2.79,frontTrack=1.60,rearTrack=1.59,
    frontZ=-1.35,rearZ=1.44,mountY=-0.05,
    wheelRadius=0.35,wheelWidth=0.30,wheelInertia=1.50,
    springFreeLength=0.38,initialCompression=0.067,maximumRaySlope=0.25,maximumNormalForce=18000,
    frontSuspension={rate=58000,travel=0.18,bumpTravel=0.045,bumpForce=6000,
        motionRatio=1,compression=0.85,rebound=1.15},
    rearSuspension={rate=54000,travel=0.18,bumpTravel=0.045,bumpForce=6000,
        motionRatio=1,compression=0.90,rebound=1.10},
    antiRollFront=18000,antiRollRear=9000,antiRollPreload=0,
    steering={maximum=math.rad(29),rate=math.rad(125),returnRate=math.rad(150),
        speedReduction=0.014,minimumFraction=0.23,ackermann=1,toe=0,camber=math.rad(-1)},
    brake={maximumTorque=7200,frontBias=0.61,handbrakeTorque=1600,dragTorque=1.5},
    tire={slipExponent=3,speedSensitivity=-0.055,slidingDecay=85,
        stiffnessExponent=-0.12,loadSensitivity=0.0155,relaxationLength=0.45,
        longitudinalStiffness=1.05,lateralStiffness=1.10,camberThrust=0.55,
        anisotropy=1/1.05,verticalStiffness=-300000,grip=1,rollingResistance=0.014,
        inverseLoad=1/4000,contactPatch=0.000005},
    thermal={enabled=true,initialK=298.15,coldPressure=28,referencePressure=28,
        optimumPressure=32,minimumPressure=1,loadReference=2000,optimumK=355,maximumK=470,
        heatScale=1,heatFraction=0.45,surfaceCapacity=8500,carcassCapacity=19000,
        conduction=120,surfaceCooling=28,carcassCooling=9,coolingSpeedOffset=0.01,
        brakeCapacity=6500,brakeCooling=0.008},
    engine={idleRPM=900,redlineRPM=8500,engineInertia=0.40,wheelInertia=1.50,
        clutchCapacity=850,gears={2.50,1.78,1.35,1.00},reverseRatio=-2.4,
        finalDrive=3.70,efficiency=0.94,shiftSeconds=0.18,diffPreload=35,diffPowerLock=0.08,
        netTorqueCurve={{0,0},{800,90},{1500,180},{3000,320},{4500,370},{6000,380},
            {7500,360},{8500,300},{9000,0},{25800,0}},
        frictionCurve={{0,20},{1000,35},{3000,60},{6000,100},{9000,155},{25800,650}}},
    aero={enabled=true,area=2.20,length=2.79,baseDrag=0.43,baseLift=-0.58,
        grilleDrag=0,spoilerDrag=0,grilleLift=0,spoilerLift=0,draftLift=0,
        grillePitch=0,spoilerPitch=0,rearDamagePitch=0,frontDamagePitch=0,
        curves={pitchDrag=0,yawDrag=0,yawDragDelta=0,yawSide=0,yawLift=0,yawLiftDelta=0,
            pitchLift=0,yawRoll=0,pitchMoment=0,yawPitch=0,yawPitchDelta=0,yawMoment=0,
            heightDrag=0,heightLift=0,heightPitch=0}},
    environment={ambientK=298.15,airDensity=1.20,wind={0,0,0}},
    adapter={frictionEnvelope=1.35,lowSpeedLongitudinalDamping=900,maxWheelOmega=600,
        thermalGripFloor=0.25,inputTimeout=0.5,telemetryHz=10,maxPacketHz=60},
}
function T.new()
    local p=U.copy(T); p.new=nil
    p.engine.wheelInertia=p.wheelInertia
    p.corners={
        {name="FL",x=-p.frontTrack/2,z=p.frontZ,front=true,side=-1},
        {name="FR",x=p.frontTrack/2,z=p.frontZ,front=true,side=1},
        {name="RL",x=-p.rearTrack/2,z=p.rearZ,front=false,side=-1},
        {name="RR",x=p.rearTrack/2,z=p.rearZ,front=false,side=1},
    }
    return p
end
return T
]=]
SOURCES['Roblox.RenderSnapshot'] = [=[
-- Presentation-only render snapshot codec + quaternion helpers.
-- Pure Lua apart from Roblox's `buffer` library. It never feeds the authoritative solver.
local M={}
M.VERSION=1
M.WHEELS=4
M.FLAG_TELEPORT=1
M.FLAG_WHEEL_ANGLE=2 -- Stage 12 (NR2003_CUP): 'steer' carries the ORIGINAL steering-wheel angle (005662d0), not a road angle
M.HEADER=76
M.WHEEL_BYTES=32
M.SIZE=M.HEADER+M.WHEELS*M.WHEEL_BYTES -- 204 bytes
local TAU=2*math.pi

local function finite(v) return v==v and v>-math.huge and v<math.huge end
M.finite=finite
function M.wrapPi(a) return (a+math.pi)%TAU-math.pi end
function M.hasFlag(flags,flag) return math.floor((flags or 0)/flag)%2==1 end

-- Layout, little endian:
--  0 u8 version | 1 u8 wheelCount | 2 u16 vehicleId | 4 u16 seq | 6 u16 flags
--  8 u32 tick | 12 f64 serverTime
-- 20 f32 worldPos[3] | 32 f32 quat[4] | 48 f32 linearVel[3] studs/s
-- 60 f32 angularVel[3] world rad/s | 72 f32 roadSteer
-- 76 + wheel*32: f32 compression | f32 steer | f64 unwrappedSpin |
--                 f32 contactLocalXYZ | u8 grounded | 3 bytes padding.
function M.encode(s)
    local b=buffer.create(M.SIZE)
    buffer.writeu8(b,0,M.VERSION);buffer.writeu8(b,1,M.WHEELS)
    buffer.writeu16(b,2,s.vehicleId%65536);buffer.writeu16(b,4,s.seq%65536)
    buffer.writeu16(b,6,s.flags or 0);buffer.writeu32(b,8,s.tick%4294967296)
    buffer.writef64(b,12,s.time)
    buffer.writef32(b,20,s.px);buffer.writef32(b,24,s.py);buffer.writef32(b,28,s.pz)
    buffer.writef32(b,32,s.qx);buffer.writef32(b,36,s.qy);buffer.writef32(b,40,s.qz);buffer.writef32(b,44,s.qw)
    buffer.writef32(b,48,s.lx);buffer.writef32(b,52,s.ly);buffer.writef32(b,56,s.lz)
    buffer.writef32(b,60,s.ax);buffer.writef32(b,64,s.ay);buffer.writef32(b,68,s.az)
    buffer.writef32(b,72,s.steer)
    for j=1,M.WHEELS do
        local w=s.wheels[j];local o=M.HEADER+(j-1)*M.WHEEL_BYTES
        buffer.writef32(b,o,w.comp);buffer.writef32(b,o+4,w.steer);buffer.writef64(b,o+8,w.spin)
        buffer.writef32(b,o+16,w.cx);buffer.writef32(b,o+20,w.cy);buffer.writef32(b,o+24,w.cz)
        buffer.writeu8(b,o+28,w.grounded and 1 or 0)
    end
    return b
end

function M.decode(b)
    if type(b)~="buffer" then return nil,"not a buffer" end
    if buffer.len(b)<M.SIZE then return nil,"short packet" end
    if buffer.readu8(b,0)~=M.VERSION then return nil,"version" end
    if buffer.readu8(b,1)~=M.WHEELS then return nil,"wheel count" end
    local s={vehicleId=buffer.readu16(b,2),seq=buffer.readu16(b,4),flags=buffer.readu16(b,6),
        tick=buffer.readu32(b,8),time=buffer.readf64(b,12),
        px=buffer.readf32(b,20),py=buffer.readf32(b,24),pz=buffer.readf32(b,28),
        qx=buffer.readf32(b,32),qy=buffer.readf32(b,36),qz=buffer.readf32(b,40),qw=buffer.readf32(b,44),
        lx=buffer.readf32(b,48),ly=buffer.readf32(b,52),lz=buffer.readf32(b,56),
        ax=buffer.readf32(b,60),ay=buffer.readf32(b,64),az=buffer.readf32(b,68),
        steer=buffer.readf32(b,72),wheels={}}
    for _,k in ipairs({"time","px","py","pz","qx","qy","qz","qw","lx","ly","lz","ax","ay","az","steer"}) do
        if not finite(s[k]) then return nil,"non-finite "..k end
    end
    local n=math.sqrt(s.qx*s.qx+s.qy*s.qy+s.qz*s.qz+s.qw*s.qw)
    if n<0.5 or n>1.5 then return nil,"bad quaternion" end
    s.qx,s.qy,s.qz,s.qw=s.qx/n,s.qy/n,s.qz/n,s.qw/n
    for j=1,M.WHEELS do
        local o=M.HEADER+(j-1)*M.WHEEL_BYTES
        local w={comp=buffer.readf32(b,o),steer=buffer.readf32(b,o+4),spin=buffer.readf64(b,o+8),
            cx=buffer.readf32(b,o+16),cy=buffer.readf32(b,o+20),cz=buffer.readf32(b,o+24),
            grounded=buffer.readu8(b,o+28)~=0}
        for _,k in ipairs({"comp","steer","spin","cx","cy","cz"}) do
            if not finite(w[k]) then return nil,"non-finite wheel "..k end
        end
        s.wheels[j]=w
    end
    return s
end

-- CFrame rotation-matrix order -> unit quaternion (Shepperd).
function M.quatFromMatrix(m00,m01,m02,m10,m11,m12,m20,m21,m22)
    local x,y,z,w;local tr=m00+m11+m22
    if tr>0 then
        local s=math.sqrt(tr+1)*2;w=0.25*s;x=(m21-m12)/s;y=(m02-m20)/s;z=(m10-m01)/s
    elseif m00>m11 and m00>m22 then
        local s=math.sqrt(1+m00-m11-m22)*2;w=(m21-m12)/s;x=0.25*s;y=(m01+m10)/s;z=(m02+m20)/s
    elseif m11>m22 then
        local s=math.sqrt(1+m11-m00-m22)*2;w=(m02-m20)/s;x=(m01+m10)/s;y=0.25*s;z=(m12+m21)/s
    else
        local s=math.sqrt(1+m22-m00-m11)*2;w=(m10-m01)/s;x=(m02+m20)/s;y=(m12+m21)/s;z=0.25*s
    end
    local n=math.sqrt(x*x+y*y+z*z+w*w)
    return x/n,y/n,z/n,w/n
end
function M.quatToMatrix(x,y,z,w)
    local xx,yy,zz=x*x,y*y,z*z;local xy,xz,yz=x*y,x*z,y*z;local wx,wy,wz=w*x,w*y,w*z
    return 1-2*(yy+zz),2*(xy-wz),2*(xz+wy),
        2*(xy+wz),1-2*(xx+zz),2*(yz-wx),
        2*(xz-wy),2*(yz+wx),1-2*(xx+yy)
end
function M.slerp(ax,ay,az,aw,bx,by,bz,bw,t,out)
    local d=ax*bx+ay*by+az*bz+aw*bw
    if d<0 then bx,by,bz,bw,d=-bx,-by,-bz,-bw,-d end
    d=math.max(-1,math.min(1,d))
    local sa,sb
    if d>0.9995 then sa,sb=1-t,t
    else local theta=math.acos(d);local st=math.sin(theta);sa=math.sin((1-t)*theta)/st;sb=math.sin(t*theta)/st end
    local x,y,z,w=sa*ax+sb*bx,sa*ay+sb*by,sa*az+sb*bz,sa*aw+sb*bw
    local n=math.sqrt(x*x+y*y+z*z+w*w);out.x,out.y,out.z,out.w=x/n,y/n,z/n,w/n
    return out
end
-- Angular velocity is world-frame, matching CoreChassisAdapter:kinematics().
function M.integrate(qx,qy,qz,qw,wx,wy,wz,dt,out)
    local mag=math.sqrt(wx*wx+wy*wy+wz*wz);local angle=mag*dt;local dx,dy,dz,dw
    if angle<1e-9 then dx,dy,dz,dw=0,0,0,1
    else local s=math.sin(angle*0.5)/mag;dx,dy,dz,dw=wx*s,wy*s,wz*s,math.cos(angle*0.5) end
    local x=dw*qx+dx*qw+dy*qz-dz*qy
    local y=dw*qy-dx*qz+dy*qw+dz*qx
    local z=dw*qz+dx*qy-dy*qx+dz*qw
    local w=dw*qw-dx*qx-dy*qy-dz*qz
    local n=math.sqrt(x*x+y*y+z*z+w*w);out.x,out.y,out.z,out.w=x/n,y/n,z/n,w/n
    return out
end
-- The physics wheel angle is wrapped to [0,2pi). Use omega to select the correct turn count.
function M.unwrapSpin(previous,wrapped,omega,dt)
    if previous==nil or not finite(previous) or not finite(dt) or dt<=0 or dt>0.25 then return wrapped end
    local predicted=previous+omega*dt
    return predicted+M.wrapPi(wrapped-predicted)
end
return M
]=]
SOURCES['Roblox.CupChassisAdapter'] = [=[
-- Stage 13: the ORIGINAL force feedback runs inside the core (00554d30 front tyre statistics per tick, the FFB block of the
-- frame end 00554520, 0054fed0 / 00550070 FF axis and controls; exact x87 arithmetic). Options = the controls.cfg values
-- (attributes ForceFeedback bool, ForceFeedbackStrength 0..100, ForceFeedbackDamping 0..100, ForceFeedbackLatency
-- 0..250 ms; absent = CupTune.driver bench defaults, then the original image values: off, 80, 0, 0). ForceFeedbackDevice
-- (bool) = the host offers an FF output for the steering axis (ADAPTER for DirectInput: the HUD + gamepad motors on the
-- client); the effect is acquired by the ORIGINAL 0054fed0 only while the steering is on an analog axis. No driver seated
-- = player controls suspended (ORIGINAL 00550070(1)). The output (the original constant force -1..1 and the DirectInput
-- magnitude _ftol(force x 10000)) is published as car attributes FFBForce / FFBMagnitude / FFBActive; nothing feeds back.
-- Stage 12: the ORIGINAL steering chain runs inside the core (00552720 device processing, linearity, x pi,
-- 00554fb0 setup ratio item 0x30 with the low-speed override, per-tick ramp + toe -> prescribed hub coordinates).
-- The adapter is only the device layer (0057abc0 equivalent): keys -> digital steering controls 7 / 8, an analog
-- axis (gamepad / wheel, normalised -1..1 by Roblox) -> both controls split by sign. Driver options from car
-- attributes: SteeringLinearity (controls.cfg value 0..100), SteeringMomentum (0..100, 0 = no slew),
-- SteeringLowSpeedOverride (bool); absent = the original values when no controls.cfg was loaded. (The arcade
-- driving mode and steering assistance are not ported: the core refuses them.) The cockpit wheel draws the ORIGINAL 005662d0 angle; front wheels use the solver poses.
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
local trackModule=script.Parent:FindFirstChild("NR2003WatkinsGlen")
local TrackHost=trackModule and require(trackModule)
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
        fault=nil,renderSpin={},lastRenderSnapshotTime=nil,renderTeleport=true,pendingShift=0,steeringOut={},
        planes={},inContact={},wheelPose={},contactPoints={},scratchPos={0,0,0},scratchRot={1,0,0,0,1,0,0,0,1},ffbOut={}},M)
    for j=1,4 do
        self.planes[j]={0,0,1,0,0,0,0,1,1};self.inContact[j]=false
        self.wheelPose[j]={pos={0,0,0},rot={1,0,0,0,1,0,0,0,1},compression=0,steer=0,angle=0,rate=0}
        self.contactPoints[j]={point=Vector3.zero,grounded=false}
    end
    self.spawn=car:GetPivot();self.oldAnchored=self.root.Anchored;self.oldCollide=self.root.CanCollide
    car:SetAttribute("NR2003CorePoseOwner",true);car:SetAttribute("PhysicsMode","NR2003_CUP")
    car:SetAttribute("NR2003Tune","CupTune")
    car:SetAttribute("CockpitWheelAngle",true) -- Stage 12: render snapshots carry the ORIGINAL steering-wheel angle
    self.root.Anchored=true;self.root.CanCollide=false
    self.root.AssemblyLinearVelocity=Vector3.zero;self.root.AssemblyAngularVelocity=Vector3.zero
    local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances={car};params.RespectCanCollide=true;params.IgnoreWater=false
    self.params=params
    self.visual=Visual.new(car,cup);self.access=SeatAccess.new(car,remote);Cockpit.ensure(car,cup)
    self.core=Vehicle.new(Core:WaitForChild("NR2003Cup"))
    if TrackHost then TrackHost.attach(self) end
    self:initialize()
    if self.originalTrack then
        TrackHost.prepareDriverSpawn(self, assert(car.Parent, "Parent TestCar before initializing the original track"))
    end
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
    local s=self.originalTrack and TrackHost.garageSetup(self,Setup) or Setup.cupGarageDefault()
    for i=0,70 do
        if Setup.adjustable(i) then
            local name=Setup.ITEM[i].name
            local v=self.car:GetAttribute("Setup_"..name)
            if not U.finite(v) and LEGACY_SETUP[name] then v=self.car:GetAttribute(LEGACY_SETUP[name]) end
            if U.finite(v) then Setup.set(s,i,v) end
        end
    end
    -- Stage 12.1: bench default of the garage steering ratio (item 0x30) when no Setup_steeringRatio attribute is set
    local ratio=self.tune.driver and self.tune.driver.setupSteeringRatio
    if not self.originalTrack and U.finite(ratio) and not U.finite(self.car:GetAttribute("Setup_steeringRatio")) then Setup.set(s,"steeringRatio",ratio) end
    return s
end
function M:applyGarageSetup(s)
    local key=table.concat(s,",",0,183)
    if key==self.appliedSetupKey then return end
    local ok,rep=self.core:applySetup(s)
    self.car:SetAttribute("SetupStructure",rep.structure);self.car:SetAttribute("SetupApplySeconds",rep.seconds)
    if ok then
        self.appliedSetupKey=key;self.car:SetAttribute("SetupError",nil)
        if self.originalTrack then
            self.trackSetupName=self.requestedTrackSetupName
            self.car:SetAttribute("TrackSetupApplied",self.trackSetupName)
            self.car:SetAttribute("TrackSetupSHA256",self.requestedTrackSetupSHA256)
        end
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
    self.origin=self.originalTrack and TrackHost.origin(self) or self:groundOrigin(self.spawn)
    if self.originalTrack then TrackHost.checkSession(self) end
    -- Stage 12: the steering options are re-read from the attributes at every initialize/reset
    if self.core.V.clearSteeringOptions then self.core.V.clearSteeringOptions() end
    if self.core.V.clearForceFeedbackOptions then self.core.V.clearForceFeedbackOptions() end
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
    -- Stage 12: ORIGINAL steering chain + driver options (ORIGINAL setters 005502f0 / 005500c0 / 00550110)
    if self.core.V.setSteeringMode then
        self.core:setSteeringMode("original")
        local function flag(name) local v=self.car:GetAttribute(name);if type(v)=="boolean" then return v end;return nil end
        -- Stage 12.1 bench options (CupTune.driver defaults; attributes override): steering lock, momentum per device,
        -- cockpit wheel draw limit. Lock 360 = the original constant; the others are host choices (STAGE12_RESULT.md)
        local d=self.tune.driver or {}
        local function pick(name,default) local v=num(name);if v~=nil then return v end;return default end
        local clamp=self.car:GetAttribute("CockpitWheelClamp")
        if clamp~="original" and clamp~="lock" then clamp=d.cockpitLimit end
        local o=self.core:setSteeringOptions({linearity=num("SteeringLinearity"),momentum=num("SteeringMomentum"),
            lowSpeedOverride=flag("SteeringLowSpeedOverride"),lockDegrees=pick("SteeringLockDegrees",d.steeringLockDegrees),
            momentumKeys=pick("SteeringMomentumKeys",d.momentumKeys),momentumAxis=pick("SteeringMomentumAxis",d.momentumAxis),
            cockpitLimit=clamp})
        self.car:SetAttribute("SteeringLinearityApplied",o.linearity);self.car:SetAttribute("SteeringRateApplied",o.steerRate)
        self.car:SetAttribute("SteeringRatioApplied",o.setupRatio);self.car:SetAttribute("SteeringLockApplied",o.lockDegrees)
        print(string.format("[NR2003 Stage 12] direção original: relação %g:1 (item 0x30), trava %g° (%g° por lado), override baixa velocidade %s, linearidade %.2f, taxa %.4f/quadro (teclas %s, eixo %s), volante até %g°",
            o.setupRatio,o.lockDegrees,o.lockDegrees/2,o.lowSpeedOverride and "on" or "off",o.linearity,o.steerRate,
            o.momentumKeys==nil and "imagem" or tostring(o.momentumKeys),o.momentumAxis==nil and "imagem" or tostring(o.momentumAxis),
            o.cockpitLimitDegrees))
    end
    -- Stage 13: ORIGINAL force feedback options (messages 8..11 = controls.cfg values) and the host FF device, set before
    -- the car is placed on the track (00550a50 -> 00550070(0) -> 0054fed0)
    self.controlsSuspended=nil
    if self.core.V.setForceFeedbackOptions then
        local d=self.tune.driver or {}
        local function boolAttr(name,default) local v=self.car:GetAttribute(name);if type(v)=="boolean" then return v end;return default end
        local function range(name,hi,default)
            local v=num(name);if v==nil then v=default end
            if v==nil then return nil end
            return math.clamp(math.floor(v),0,hi)            -- the front-end slider ranges (0043ef90 / 0043efe0 / 0043f030)
        end
        self.core:setForceFeedbackDevice({capable=boolAttr("ForceFeedbackDevice",d.ffbDevice==true)})
        local o=self.core:setForceFeedbackOptions({enabled=boolAttr("ForceFeedback",d.ffbEnabled),
            strength=range("ForceFeedbackStrength",100,d.ffbStrength),damping=range("ForceFeedbackDamping",100,d.ffbDamping),
            latency=range("ForceFeedbackLatency",250,d.ffbLatency)})
        self.car:SetAttribute("ForceFeedbackApplied",o.enabled)
        print(string.format("[NR2003 Stage 13] force feedback original %s: força %g, amortecimento %g, latência %g ms, dispositivo %s (efeito adquirido pelo 0054fed0 só com o eixo analógico)",
            o.enabled and "ligado" or "desligado",o.strength,o.damping,o.latency,boolAttr("ForceFeedbackDevice",d.ffbDevice==true) and "sim" or "não"))
    end
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
    self.pendingShift=0
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

-- Stage 12 host device layer (0057abc0 equivalent, ADAPTER): the raw steering controls of the frame. Keys -> steer
-- left / right key bindings (digital controls 7 / 8 = 1.0 while held); an analog axis (input.steerAnalog) -> one axis
-- bound to both controls (negative half -> 7, positive half -> 8). A legacy client (input.steer only) = keys.
local function steerControls(controls,input)
    local axis=input.steerAxis
    if input.steerAnalog==true and U.finite(axis) then
        controls.steerAxis=U.clamp(axis,-1,1)
        return
    end
    local left,right=input.steerLeft,input.steerRight
    if not U.finite(left) and not U.finite(right) and U.finite(input.steer) then
        left=input.steer<0 and 1 or 0;right=input.steer>0 and 1 or 0
    end
    controls.steerLeft=U.finite(left) and U.clamp(left,0,1) or 0
    controls.steerRight=U.finite(right) and U.clamp(right,0,1) or 0
    controls.steerDigital=true
end
M.steerControls=steerControls

function M:tickCore(input)
    local frame=self.core:tick()%8==0
    -- Stage 8: the brake goes through the ORIGINAL input chain (00552d00/00553080 -> bf6eac).
    -- The bench client sends keyboard keys (S/W = 0/1): NR2003 key binding (0057af60 digital).
    -- brakeAxis=true in the input selects the analog-axis binding for real pedals/triggers.
    -- No driver seated = 005524f0 'car not driven' branch (pedal held at 1.0).
    local controls
    if self:driver()==nil then
        controls={driver=false,throttle=0,clutch=0}
    else
        local throttle=U.clamp(input.throttle or 0,0,1)
        controls={throttle=throttle,throttleControl=throttle,throttleDigital=input.throttleAxis~=true,
            brakeControl=U.clamp(input.brake or 0,0,1),brakeDigital=input.brakeAxis~=true,
            clutch=1-U.clamp(input.clutch or 0,0,1),originalPedals=self.originalTrack==true}
        steerControls(controls,input)
    end
    if frame and self.pendingShift~=0 and controls.driver~=false then
        controls.shiftUp=self.pendingShift>0;controls.shiftDown=self.pendingShift<0;self.pendingShift=0
    end
    if frame and self.weather then self:aeroHostInputs() end
    -- Stage 13: no driver seated = player controls suspended (ORIGINAL 00550070(1): 005524f0 not-driven branch, FFB block
    -- gated, zero force); a driver seated = 00550070(0). Applied between frames, where the original drains its messages
    local suspended=controls.driver==false
    if frame and self.core.V.setControlsSuspended and suspended~=self.controlsSuspended then
        self.controlsSuspended=suspended;self.core:setControlsSuspended(suspended)
    end
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
    -- The recovered track query supplies the original normal and race-order context.
    if self.originalTrack then return end
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
    if not self.originalTrack and not teleport and self.rootCF then
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
        self.runner:advance(elapsed,input,nil)
        if self.originalTrack then TrackHost.update(self) end
        self.car:PivotTo(self.rootCF)
        self.car:SetAttribute("CoreTick",self.core:tick());self.car:SetAttribute("CoreCollision",self.collision==true)
        local wheels=self:wheels()
        for j=1,4 do
            local _,_,_,px,py,pz=self.core:contactOut(j-1)
            self.contactPoints[j].point=self:worldPoint(px,py,pz);self.contactPoints[j].grounded=self.inContact[j]
        end
        self.visual:update({wheels=wheels},self.contactPoints,self.debugVisible)
        Cockpit.updateAngle(self.car,self:steeringWheelAngle())
        -- Stage 13: the ORIGINAL constant force (005d08d0 -> 005d3010) for the client presentation (HUD, gamepad motors)
        if self.core.V.forceFeedbackState then
            local f=self.core:forceFeedbackState(self.ffbOut)
            self.car:SetAttribute("FFBForce",f.force);self.car:SetAttribute("FFBMagnitude",f.magnitude)
            self.car:SetAttribute("FFBActive",f.acquired and f.effect and not f.suspended)
        end
    end)
    if not ok then self.fault=tostring(reason);self.car:SetAttribute("PhysicsFault",self.fault);warn("NR2003 Cup core paused: "..self.fault) end
end

-- Stage 12 presentation: the ORIGINAL steering-wheel angle of the car model (005662d0: clamp(-(00554fb0() *
-- car[0x1554]), +-2.79 rad), + = clockwise seen by the driver (right turn)); 0 without the Stage 12 core
function M:steeringWheelAngle()
    if self.core.V.steeringWheelAngle then return self.core:steeringWheelAngle() end
    return 0
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
    local flags=(self.renderTeleport and RenderSnapshot.FLAG_TELEPORT or 0)+RenderSnapshot.FLAG_WHEEL_ANGLE
    self.renderTeleport=false;self.lastRenderSnapshotTime=time
    return {vehicleId=vehicleId or 1,seq=seq,flags=flags,tick=self.core:tick(),time=time,
        px=px,py=py,pz=pz,qx=qx,qy=qy,qz=qz,qw=qw,
        lx=linear.X,ly=linear.Y,lz=linear.Z,ax=angular.X,ay=angular.Y,az=angular.Z,
        steer=self:steeringWheelAngle(),wheels=wheels}
end

function M:telemetry()
    local st=self.core:readState()
    local linear=self:kinematics()
    local _,r=self.core:componentPose(0,self.scratchPos,self.scratchRot)
    local forward=st[2]*r[1]+st[4]*r[4]+st[6]*r[7]
    local lf,rf,thr,brk,clu,gearIn=self.core:inputs()
    local wheels={}
    local track
    if self.originalTrack then
        local p=self.core.V.trackPosition(self.trackPositionOut)
        track={name="Watkins Glen",setup=self.trackSetupName,dlong=p.dlong,dlat=p.dlat,wheels={}}
    end
    -- Stage 11: ORIGINAL runtime state (read-only view of the core cells)
    local s11=self.core.V.stage11State and self.core:stage11State(self.stage11Out) or nil
    for j,c in ipairs(self.tune.corners) do
        local fx,fy,fz=self.core:contactOut(j-1)
        local travel=st[c.state.travel+1]
        local w=self.wheelPose[j]
        -- Stage 8: original per-wheel brake/tire cells (no side effects on the core)
        local b=self.core:wheelBrake(j-1)
        local ty=s11 and s11.tyres[j]
        if track then
            local contact=self.core.V.trackContact(j-1,{})
            local grounded=contact.grounded==true
            local fx,fy,fz=grounded and b.fx or 0,grounded and b.fy or 0,grounded and b.fz or 0
            local surface=grounded and contact.surface or nil
            track.wheels[j]={name=c.name,grounded=grounded,surface=surface,
                surfaceGrip=surface and self.core.V.rf32(0x74fb30+4*surface) or 0,
                fx=fx,fy=fy,fz=fz,forceXY=math.sqrt(fx*fx+fy*fy),
                muUsed=fz>1 and math.sqrt(fx*fx+fy*fy)/fz or 0,
                slipVelocity=b.vslip,wearFactor=ty and ty.gripWear or 1}
        end
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
        collision=self.collision==true,aero=aero,track=track,
        stage11=s11 and {mode=s11.mode,fuelKg=s11.fuel.kg,fuelRecordKg=s11.fuel.massRecord,water=s11.engine.water,oil=s11.engine.oil,
            coolantLevel=s11.engine.coolantLevel,oilLevel=s11.engine.oilLevel,power=s11.engine.power,life=s11.engine.life,
            overRev=s11.engine.overRev,damageScale=s11.damage.scale,engineDamage=s11.damage.engine,leakRadiator=s11.damage.radiator,
            leakOil=s11.damage.oil,leakFuel=s11.damage.fuel,zones=s11.damage.zones,failures=s11.damage.failures,
            broken=s11.damage.brokenFlags,airspeed=s11.airspeed,ambientK=s11.ambient} or nil,
        -- Stage 12: hubSteerAngle = mean prescribed hub coordinate q (states 15 / 21, + = left; the original car[0x1554]),
        -- a rotation about the inclined steering axis (caster 2.455 deg, inclination 9.215 deg); roadWheelAngle = mean
        -- front wheel yaw measured from the solver wheel poses (+ = right, Stage 5 sign; about -0.99 q, no Ackermann)
        hubSteerAngle=st[16]*0.5+st[22]*0.5,roadWheelAngle=(self.wheelPose[1].steer+self.wheelPose[2].steer)*0.5,
        steeringWheelAngle=self:steeringWheelAngle(),steering=self:steeringTelemetry(),ffb=self:forceFeedbackTelemetry()}
end
-- Stage 13 force-feedback telemetry (original cells + the last device output, see STAGE13_FFB_STATE_MAP.md)
function M:forceFeedbackTelemetry()
    if not self.core.V.forceFeedbackState then return nil end
    local f=self.core:forceFeedbackState(self.ffbOut)
    return {enabled=f.enabled,acquired=f.acquired,suspended=f.suspended,effect=f.effect,force=f.force,magnitude=f.magnitude,
        slip=f.slip,moment=f.moment,filtered=f.filtered,load=f.load,strength=f.strength,damping=f.damping,latency=f.latency,
        axis=f.axis}
end
-- Stage 12 steering telemetry (original cells, see STAGE12_STEERING_STATE_MAP.md); nil without the Stage 12 core
function M:steeringTelemetry()
    if not self.core.V.steeringState then return nil end
    local s=self.core:steeringState(self.steeringOut)
    return {left=s.left,right=s.right,digital=s.digital,input=s.input,shaped=s.shaped,ratio=s.ratio,ratioNow=s.ratioNow,
        target=s.target,current=s.current,lf=s.lf,rf=s.rf,hubLF=s.hubLF,hubRF=s.hubRF,wheelAngle=s.wheelAngle,
        sensitivity=s.sensitivity,mode=s.mode}
end
function M:reset()
    self.car:PivotTo(self.spawn);self.fault=nil;self.car:SetAttribute("PhysicsFault",nil)
    self.rootCF=nil;self:initialize();self.car:PivotTo(self.rootCF)
end
function M:destroy()
    if TrackHost then TrackHost.clearDriverSpawn(self) end
    self.access:destroy();self.car:SetAttribute("NR2003CorePoseOwner",nil)
    self.root.Anchored=self.oldAnchored;self.root.CanCollide=self.oldCollide
end
return M
]=]
SOURCES['Roblox.NR2003WatkinsGlen'] = [=[
-- Roblox presentation adapter for the recovered Watkins Glen world.
-- Physics, materials, bump sampling and barrier forces belong to NR2003CupTrack.
-- This module only selects a common render origin and the original test spawn.
local M = {}
M.TRACK = "watkins_glen"
M.METRES_PER_STUD = 0.28

function M.garageSetup(controller, Setup)
    local Setups = require(script.Parent.NR2003WatkinsGlenSetup)
    local items, name, hash = Setups.new(Setup, controller.car:GetAttribute("WatkinsGlenSetup"))
    controller.requestedTrackSetupName = name
    controller.requestedTrackSetupSHA256 = hash
    return items
end

function M.enabled(package)
    return package:GetAttribute("NR2003Track") == M.TRACK
end

function M.origin(controller)
    local model = assert(workspace:FindFirstChild("NR2003WatkinsGlen"),
        "Import the Watkins Glen visuals and run INSTALL_TRACK_VISUALS before driving")
    assert(model:IsA("Model") and model:GetAttribute("TrackOriginEnabled") == true,
        "Watkins Glen visuals have not been calibrated by the asset installer")
    controller.trackModel = model
    return model:GetPivot()
end

function M.attach(controller)
    local package = script.Parent.Parent
    if not M.enabled(package) then return false end
    assert(math.abs(controller.tune.metresPerStud - M.METRES_PER_STUD) < 1e-12,
        "Watkins Glen and the car must both use 0.28 metres per stud")
    assert(controller.core.V.loadTrack, "Install the recovered Watkins Glen core modules first")
    M.origin(controller)
    controller.core:loadTrack()
    controller.originalTrack = true
    controller.trackPositionOut = {}
    controller.trackContactOut = {}
    local stalls = controller.core.V.trackStalls
    local stall = assert(stalls and stalls[1], "Watkins Glen original pit spawn is missing")
    local function number(name, default)
        local value = controller.car:GetAttribute(name)
        if type(value) == "number" and value == value and math.abs(value) < math.huge then return value end
        return default
    end
    controller.core.V.setTrackStart(number("TrackDlong", stall[1]), number("TrackDlat", stall[2]),
        number("TrackYaw", stall[3]))
    controller.car:SetAttribute("NR2003Track", M.TRACK)
    controller.car:SetAttribute("TrackContactMode", "NR2003 original world")
    return true
end

function M.checkSession(controller)
    assert(controller.car:GetAttribute("AeroSession") ~= false,
        "Watkins Glen requires an active original NR2003 session (AeroSession must be enabled)")
    assert(controller.car:GetAttribute("Stage11Runtime") ~= "frozen",
        "Watkins Glen requires the original tire thermal/wear runtime")
end

-- Read-only diagnostics. They never become input to the contact solver.
function M.update(controller)
    local V = controller.core.V
    if V.trackPosition then
        local p = V.trackPosition(controller.trackPositionOut)
        controller.car:SetAttribute("TrackDlongCurrent", p.dlong)
        controller.car:SetAttribute("TrackDlatCurrent", p.dlat)
        controller.car:SetAttribute("TrackSurface", p.surface)
    end
    if V.trackContact then
        for j = 1, 4 do
            local c = V.trackContact(j - 1, controller.trackContactOut)
            controller.inContact[j] = c.grounded == true
            controller.planes[j][8] = c.surface or 0
        end
    end
end

function M.clearDriverSpawn(controller)
    local state = controller.trackDriverSpawn
    if not state or state.closed then return end
    state.closed = true
    controller.trackDriverSpawn = nil
    for _, connection in ipairs(state.connections) do connection:Disconnect() end
    for player, entry in pairs(state.players) do
        entry.connection:Disconnect()
        if player.Parent == state.service and player.RespawnLocation == state.spawn then
            local previous = entry.previous
            if previous and not previous:IsDescendantOf(workspace) then previous = nil end
            player.RespawnLocation = previous
        end
    end
    state.players = {}
    if state.spawn.Parent and not state.spawnDestroying then state.spawn:Destroy() end
end

-- An avatar can already exist when the recovered core finishes initializing.
-- Select the new spawn for subsequent characters and bring existing characters
-- onto its walking surface. No avatar placement enters the native car solver.
local function bindDriverSpawn(controller, spawn)
    local players = game:GetService("Players")
    local state = {spawn = spawn, service = players, connections = {}, players = {}, closed = false}
    controller.trackDriverSpawn = state
    local function place(player, character)
        task.defer(function()
            if state.closed or player.Parent ~= players or player.Character ~= character then return end
            local root = character:WaitForChild("HumanoidRootPart", 10)
            local humanoid = character:WaitForChild("Humanoid", 10)
            if not root or not humanoid or state.closed or player.Parent ~= players or player.Character ~= character
                or not spawn.Parent or humanoid.Health <= 0 or humanoid.SeatPart then return end
            -- Keep a character already standing nearby in place. Otherwise put
            -- its root above the platform, preserving the avatar's orientation.
            if (root.Position - spawn.Position).Magnitude > 12 then
                local destination = spawn.Position + Vector3.new(0, 4, 0)
                character:PivotTo(character:GetPivot() + (destination - root.Position))
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end
        end)
    end
    local function bind(player)
        if state.closed or state.players[player] or player.Parent ~= players then return end
        local previous = player.RespawnLocation
        local connection = player.CharacterAdded:Connect(function(character) place(player, character) end)
        state.players[player] = {connection = connection, previous = previous}
        player.RespawnLocation = spawn
        if player.Character then place(player, player.Character) end
    end
    state.connections[1] = players.PlayerAdded:Connect(bind)
    state.connections[2] = players.PlayerRemoving:Connect(function(player)
        local entry = state.players[player]
        if entry then entry.connection:Disconnect(); state.players[player] = nil end
    end)
    state.connections[3] = spawn.Destroying:Connect(function()
        state.spawnDestroying = true
        M.clearDriverSpawn(controller)
    end)
    for _, player in ipairs(players:GetPlayers()) do bind(player) end
end

-- A small invisible Roblox walking surface lets the avatar reach the anchored
-- driver's seat. The car's native world never queries this presentation part.
function M.prepareDriverSpawn(controller, world)
    if not controller.originalTrack then return end
    M.clearDriverSpawn(controller)
    controller.car:PivotTo(controller.rootCF)
    local p = controller.core.V.trackPosition(controller.trackPositionOut)
    local surface = controller:worldPoint(p.x, p.y, p.bumpedZ)
    local spawn = world:FindFirstChild("WatkinsGlenDriverSpawn") or Instance.new("SpawnLocation")
    spawn.Name = "WatkinsGlenDriverSpawn"
    spawn.Size = Vector3.new(40, 0.5, 40)
    spawn.CFrame = (controller.rootCF - controller.rootCF.Position) + surface
        + controller.rootCF.RightVector * 7 - controller.rootCF.UpVector * 0.25
    spawn.Anchored = true
    spawn.CanCollide = true
    spawn.CanTouch = false
    spawn.CanQuery = false
    spawn.Transparency = 1
    spawn.Neutral = true
    spawn.Duration = 0
    spawn:SetAttribute("NR2003AvatarOnly", true)
    spawn.Parent = world
    bindDriverSpawn(controller, spawn)
    return spawn
end

return M
]=]
SOURCES['Roblox.NR2003WatkinsGlenSetup'] = [=[
-- Generated by tools/build_watkinsglen_setups.py from the supplied original .sim files.
-- Raw setup values; retain file values between garage UI steps.
local DATA = {
    fast = {file="fast.cup.sim",sha256="fd85e5c432c07272808e184e6e74304d580081cf4a57513e1fdc386dc30291e3",items={[0]=0x41b40000,[1]=0x41b40000,[2]=0x41b40000,[3]=0x41b40000,[4]=0x00000003,[5]=0x00000003,[6]=0x00000002,[7]=0x00000002,[8]=0x00000000,[9]=0x00000000,[10]=0x00000000,[11]=0x00000000,[12]=0x00000004,[13]=0x00000004,[14]=0x00000004,[15]=0x00000004,[16]=0x00000000,[17]=0x00000000,[18]=0x00000000,[19]=0x00000000,[20]=0xc7320e41,[21]=0xc7320e41,[22]=0xc7142b40,[23]=0xc7142b40,[24]=0x00000000,[25]=0x00000000,[26]=0x00000000,[27]=0x00000000,[28]=0x3d020c4a,[29]=0x3d020c4a,[30]=0x3d020c4a,[31]=0x3d020c4a,[32]=0xbd567781,[33]=0xbd567770,[34]=0xbd00ae00,[35]=0xbd00ae00,[36]=0x3dea161e,[38]=0x3e1c0e2b,[39]=0x3e1c0ebf,[40]=0x3f2b851e,[41]=0xbbcd88b8,[42]=0xbb12cf5f,[43]=0x0000000a,[44]=0x0000000f,[45]=0x3e820c05,[46]=0x3e820c05,[47]=0x00000000,[48]=0x41800000,[49]=0x4279b75b,[50]=0x00000001,[51]=0x00000004,[52]=0x00000000,[53]=0x00000011,[54]=0x0000001e,[55]=0x00000033,[56]=0x00000042,[57]=0x0000007a,[58]=0x00000000,[59]=0x3f000000,[60]=0x3f000000,[61]=0x41c80000,[62]=0xc1b570a4,[63]=0x401126e9,[64]=0x00000000,[65]=0x00000000,[66]=0x00000000,[67]=0x3d8efa61,[68]=0x3d8efa61}},
    easy = {file="easy.cup.sim",sha256="57bfd898dc8b293c058333a6957239b8dd0931e47298a3b0035cff2f0104292d",items={[0]=0x41b80000,[1]=0x41b80000,[2]=0x41b80000,[3]=0x41b80000,[4]=0x00000004,[5]=0x00000004,[6]=0x00000002,[7]=0x00000002,[8]=0x00000000,[9]=0x00000000,[10]=0x00000000,[11]=0x00000000,[12]=0x00000005,[13]=0x00000005,[14]=0x00000004,[15]=0x00000004,[16]=0x00000000,[17]=0x00000000,[18]=0x00000000,[19]=0x00000000,[20]=0xc771a5a1,[21]=0xc771a5a1,[22]=0xc7208430,[23]=0xc7208430,[24]=0x00000000,[25]=0x00000000,[26]=0x00000000,[27]=0x00000000,[28]=0x3d020c4a,[29]=0x3d020c4a,[30]=0x3d020c4a,[31]=0x3d020c4a,[32]=0xbcd6775a,[33]=0xbcd6775a,[34]=0xbd00ae00,[35]=0xbd00ae00,[36]=0x3dea161e,[38]=0x3e1c0e95,[39]=0x3e1c0ebf,[40]=0x3f2e147b,[41]=0xbbcd88b8,[42]=0xbb12cf5f,[43]=0x0000000b,[44]=0x0000000b,[45]=0x3e5d14e4,[46]=0x3e5d14e4,[47]=0x00000000,[48]=0x41a00000,[49]=0x4279b75b,[50]=0x00000001,[51]=0x00000004,[52]=0x00000000,[53]=0x00000011,[54]=0x0000001f,[55]=0x00000034,[56]=0x00000043,[57]=0x0000007a,[58]=0x00000000,[59]=0x3e999999,[60]=0x3e999999,[61]=0x41c80000,[62]=0x4159ba5e,[63]=0xc1b570a4,[64]=0x00000000,[65]=0x00000000,[66]=0x00000000,[67]=0x3d8efa4d,[68]=0x3d8efa4d}},
    qualify = {file="qualify.cup.sim",sha256="ca3eb866392a2459210f3ffa6602ab703979eb0a55707c7092885ccaf66bb8fb",items={[0]=0x41c00000,[1]=0x41c00000,[2]=0x41c00000,[3]=0x41c00000,[4]=0x00000003,[5]=0x00000003,[6]=0x00000002,[7]=0x00000002,[8]=0x00000000,[9]=0x00000000,[10]=0x00000000,[11]=0x00000000,[12]=0x00000005,[13]=0x00000005,[14]=0x00000004,[15]=0x00000004,[16]=0x00000000,[17]=0x00000000,[18]=0x00000000,[19]=0x00000000,[20]=0xc7320e41,[21]=0xc7320e41,[22]=0xc707d250,[23]=0xc707d250,[24]=0x00000000,[25]=0x00000000,[26]=0x00000000,[27]=0x00000000,[28]=0x3d020c4a,[29]=0x3d020c4a,[30]=0x3d020c4a,[31]=0x3d020c4a,[32]=0xbd64c395,[33]=0xbd64c395,[34]=0xbd00ae00,[35]=0xbd00ae00,[36]=0x3dea161e,[38]=0x3e1c0e17,[39]=0x3e1c0ebf,[40]=0x3f2b851e,[41]=0xbbcd88b8,[42]=0xbb12cf5f,[43]=0x0000000a,[44]=0x0000000e,[45]=0x3e820c39,[46]=0x3e820c39,[47]=0x00000000,[48]=0x41800000,[49]=0x4279b75b,[50]=0x00000001,[51]=0x00000004,[52]=0x00000000,[53]=0x00000011,[54]=0x0000001e,[55]=0x00000033,[56]=0x00000042,[57]=0x0000007a,[58]=0x00000000,[59]=0x3f4ccccc,[60]=0x3f4ccccc,[61]=0x41c80000,[62]=0xc1b570a4,[63]=0x00000000,[64]=0x00000000,[65]=0x00000000,[66]=0x00000000,[67]=0x3d8efa65,[68]=0x3d8efa65}},
    jasper = {file="jasper.cup.sim",sha256="99e32fd4f6cc752e55bcd3c697f761446489d4e672a232c3fcef95981dae57bf",items={[0]=0x41a80000,[1]=0x41a80000,[2]=0x41a80000,[3]=0x41a80000,[4]=0x00000004,[5]=0x00000004,[6]=0x00000002,[7]=0x00000002,[8]=0x00000000,[9]=0x00000000,[10]=0x00000000,[11]=0x00000000,[12]=0x00000005,[13]=0x00000005,[14]=0x00000004,[15]=0x00000004,[16]=0x00000000,[17]=0x00000000,[18]=0x00000000,[19]=0x00000000,[20]=0xc77e5d81,[21]=0xc77e5d81,[22]=0xc7142b40,[23]=0xc7142b40,[24]=0x00000000,[25]=0x00000000,[26]=0x00000000,[27]=0x00000000,[28]=0x3d020c4a,[29]=0x3d020c4a,[30]=0x3d020c4a,[31]=0x3d020c4a,[32]=0xbd87d424,[33]=0xbd87d424,[34]=0xbd00ae00,[35]=0xbd00ae00,[36]=0x3dea161e,[38]=0x3e0f0d84,[39]=0x3e1c0ebf,[40]=0x3f2e147b,[41]=0xbb92cf5f,[42]=0xbb12cf5f,[43]=0x00000007,[44]=0x00000003,[45]=0x3e771718,[46]=0x3e771718,[47]=0x00000000,[48]=0x41e00000,[49]=0x4279b75b,[50]=0x00000001,[51]=0x00000004,[52]=0x00000000,[53]=0x00000012,[54]=0x0000001e,[55]=0x00000033,[56]=0x00000041,[57]=0x0000007c,[58]=0x00000000,[59]=0x3f199999,[60]=0x3f199999,[61]=0x41c80000,[62]=0xc1b570a4,[63]=0xc13570a4,[64]=0x00000000,[65]=0x00000000,[66]=0x00000000,[67]=0x3d8efa41,[68]=0x3d8efa41}},
}
local M = {}
function M.new(Setup, name)
    name = name or "fast"
    local data = assert(DATA[name], "WatkinsGlenSetup must be fast, easy, qualify or jasper")
    local items = Setup.defaults()
    for i, raw in pairs(data.items) do items[i] = raw end
    assert(Setup.validateLoaded(items), "Original Watkins Glen setup validation failed")
    return items, name, data.sha256
end
return M
]=]
-- ===== minimal Roblox API mock (only what CupChassisAdapter and its helpers use) =====
local Vector3 = {}
Vector3.__index = function(v, k)
	if k == "Magnitude" then return math.sqrt(v.X * v.X + v.Y * v.Y + v.Z * v.Z) end
	if k == "Unit" then local m = math.sqrt(v.X * v.X + v.Y * v.Y + v.Z * v.Z); return Vector3.new(v.X / m, v.Y / m, v.Z / m) end
	return Vector3[k]
end
function Vector3.new(x, y, z) return setmetatable({X = x or 0, Y = y or 0, Z = z or 0}, Vector3) end
Vector3.__add = function(a, b) return Vector3.new(a.X + b.X, a.Y + b.Y, a.Z + b.Z) end
Vector3.__sub = function(a, b) return Vector3.new(a.X - b.X, a.Y - b.Y, a.Z - b.Z) end
Vector3.__unm = function(a) return Vector3.new(-a.X, -a.Y, -a.Z) end
Vector3.__mul = function(a, b)
	if type(a) == "number" then return Vector3.new(a * b.X, a * b.Y, a * b.Z) end
	if type(b) == "number" then return Vector3.new(a.X * b, a.Y * b, a.Z * b) end
	return Vector3.new(a.X * b.X, a.Y * b.Y, a.Z * b.Z)
end
Vector3.__div = function(a, b) return Vector3.new(a.X / b, a.Y / b, a.Z / b) end
function Vector3.Dot(a, b) return a.X * b.X + a.Y * b.Y + a.Z * b.Z end
function Vector3.Cross(a, b) return Vector3.new(a.Y * b.Z - a.Z * b.Y, a.Z * b.X - a.X * b.Z, a.X * b.Y - a.Y * b.X) end
Vector3.zero = Vector3.new(0, 0, 0)

local CFrame = {}
CFrame.__index = function(c, k)
	if k == "Position" then return Vector3.new(c.p[1], c.p[2], c.p[3]) end
	if k == "Rotation" then return CFrame.fromParts({0, 0, 0}, c.r) end
	if k == "UpVector" then return Vector3.new(c.r[2], c.r[5], c.r[8]) end
	if k == "RightVector" then return Vector3.new(c.r[1], c.r[4], c.r[7]) end
	if k == "LookVector" then return Vector3.new(-c.r[3], -c.r[6], -c.r[9]) end
	return CFrame[k]
end
function CFrame.fromParts(p, r) return setmetatable({p = {p[1], p[2], p[3]}, r = table.clone(r)}, CFrame) end
function CFrame.new(x, y, z, ...)
	if type(x) == "table" then return CFrame.fromParts({x.X, x.Y, x.Z}, {1, 0, 0, 0, 1, 0, 0, 0, 1}) end
	local r = {...}
	if #r == 0 then r = {1, 0, 0, 0, 1, 0, 0, 0, 1} end
	return CFrame.fromParts({x or 0, y or 0, z or 0}, r)
end
local function mulR(a, b)
	local c = {}
	for i = 0, 2 do for j = 0, 2 do
		c[i * 3 + j + 1] = a[i * 3 + 1] * b[j + 1] + a[i * 3 + 2] * b[3 + j + 1] + a[i * 3 + 3] * b[6 + j + 1]
	end end
	return c
end
local function rv(r, v) return Vector3.new(r[1] * v.X + r[2] * v.Y + r[3] * v.Z, r[4] * v.X + r[5] * v.Y + r[6] * v.Z, r[7] * v.X + r[8] * v.Y + r[9] * v.Z) end
local function rtv(r, v) return Vector3.new(r[1] * v.X + r[4] * v.Y + r[7] * v.Z, r[2] * v.X + r[5] * v.Y + r[8] * v.Z, r[3] * v.X + r[6] * v.Y + r[9] * v.Z) end
CFrame.__mul = function(a, b)
	if getmetatable(b) == Vector3 then local w = rv(a.r, b); return Vector3.new(w.X + a.p[1], w.Y + a.p[2], w.Z + a.p[3]) end
	local w = rv(a.r, Vector3.new(b.p[1], b.p[2], b.p[3]))
	return CFrame.fromParts({w.X + a.p[1], w.Y + a.p[2], w.Z + a.p[3]}, mulR(a.r, b.r))
end
CFrame.__add = function(a, v) return CFrame.fromParts({a.p[1] + v.X, a.p[2] + v.Y, a.p[3] + v.Z}, a.r) end
CFrame.__sub = function(a, v) return CFrame.fromParts({a.p[1] - v.X, a.p[2] - v.Y, a.p[3] - v.Z}, a.r) end
function CFrame.PointToWorldSpace(c, v) return c * v end
function CFrame.PointToObjectSpace(c, v) return rtv(c.r, Vector3.new(v.X - c.p[1], v.Y - c.p[2], v.Z - c.p[3])) end
function CFrame.VectorToWorldSpace(c, v) return rv(c.r, v) end
function CFrame.VectorToObjectSpace(c, v) return rtv(c.r, v) end
function CFrame.GetComponents(c) return c.p[1], c.p[2], c.p[3], table.unpack(c.r) end
function CFrame.Angles(rx, ry, rz)
	local cx, sx, cy, sy, cz, sz = math.cos(rx), math.sin(rx), math.cos(ry), math.sin(ry), math.cos(rz), math.sin(rz)
	local X = {1, 0, 0, 0, cx, -sx, 0, sx, cx}
	local Y = {cy, 0, sy, 0, 1, 0, -sy, 0, cy}
	local Z = {cz, -sz, 0, sz, cz, 0, 0, 0, 1}
	return CFrame.fromParts({0, 0, 0}, mulR(mulR(X, Y), Z))
end

-- world: ground plane y = 0 (asphalt), wall plane z = WALL_Z facing +Z (car drives toward -Z)
local WALL_Z = -120
local ground = {Name = "Asphalt", Material = {Name = "Asphalt"}, attrs = {NRSurface = 1, NRGripMultiplier = 1}}
function ground:IsA(c) return c == "BasePart" end
function ground:GetVelocityAtPosition() return Vector3.zero end
function ground:GetAttribute(k) return self.attrs[k] end
local workspace = {}
local SLOPE = 0 -- ground y = SLOPE * z (rises toward +Z, i.e. behind a car facing -Z)
function workspace:Raycast(o, d)
	-- plane y - SLOPE*z = 0
	local den = d.Y - SLOPE * d.Z
	if den >= 0 then return nil end
	local t = -(o.Y - SLOPE * o.Z) / den
	if t < 0 or t > 1 then return nil end
	local p = o + d * t
	local n = Vector3.new(0, 1, -SLOPE).Unit
	return {Position = p, Normal = n, Distance = d.Magnitude * t, Instance = ground, Material = ground.Material}
end
function workspace:Blockcast(cf, size, dir)
	local half = size.Z * 0.5
	local front = cf.p[3] - half
	if dir.Z < 0 and front + dir.Z < WALL_Z then
		local dist = math.max(0, (front - WALL_Z) / (-dir.Z / dir.Magnitude))
		return {Distance = dist, Normal = Vector3.new(0, 0, 1), Position = Vector3.new(cf.p[1], cf.p[2], WALL_Z), Instance = ground}
	end
	return nil
end
local RaycastParams = {new = function() return {} end}
local Enum = {RaycastFilterType = {Exclude = "Exclude"}}

-- car instance mock (sizes from the Stage 5 bench model, studs)
local MPS = 0.28
local attributes = {}
local chassis = {Name = "Chassis", Anchored = false, CanCollide = true, Size = Vector3.new(1.78 / MPS, 0.38 / MPS, 4.45 / MPS),
	CFrame = CFrame.new(0, 2.65, 0), AssemblyLinearVelocity = Vector3.zero, AssemblyAngularVelocity = Vector3.zero}
local car = {Chassis = chassis, DriverSeat = {Occupant = nil}}
function car:GetPivot() return chassis.CFrame end
function car:PivotTo(cf) chassis.CFrame = cf end
function car:SetAttribute(k, v) attributes[k] = v end
function car:GetAttribute(k) return attributes[k] end

-- module system: folders hand out refs; require(ref) loads bundled sources with a mock env
local loaded = {}
local realModules = {}
local mockRequire
local function folder(prefix)
	local f = {}
	setmetatable(f, {__index = function(_, name)
		if name == "WaitForChild" or name == "FindFirstChild" then
			return function(_, child)
				if prefix == "Core" and child == "NR2003Cup" then return folder("NR2003Cup") end
				return {ref = prefix .. "." .. child}
			end
		end
		return {ref = prefix .. "." .. name}
	end})
	return f
end
local CoreFolder, RobloxFolder = folder("Core"), folder("Roblox")
local package = {Core = CoreFolder, Roblox = RobloxFolder}
local packageAttributes = {}
function package:GetAttribute(name) return packageAttributes[name] end
local stubs = {
	["Roblox.VisualRig"] = {new = function() return {update = function(_, dyn, contacts) _G_lastVisual = {dyn = dyn, contacts = contacts} end} end},
	["Roblox.SeatAccess"] = {new = function() return {step = function() end, driver = function() return "player" end, request = function() end,
		exit = function() end, destroy = function() end} end},
	["Roblox.Cockpit"] = {ensure = function() end, update = function(_, _, a) _G_lastSteer = a end, angle = function(a) return a * 12 end,
		updateAngle = function(_, a) _G_lastWheelAngle = a end},
}
function mockRequire(ref)
	local name = ref.ref
	if name:sub(1, 10) == "NR2003Cup." then
		local m = name:sub(11)
		if realModules[m] == nil then
			local ok, v = pcall(require, "../../core/NR2003Cup/" .. m)
            if not ok then ok, v = pcall(require, "../core/NR2003Cup/" .. m) end
			realModules[m] = ok and v or false
		end
		return realModules[m] or nil
	end
	if stubs[name] then return stubs[name] end
	if loaded[name] then return loaded[name] end
	local source = assert(SOURCES[name], "mock: no source for " .. name)
	local f = assert(loadstring(source, name))
	local prefix = name:match("^(%a+)%.")
	local scriptObj = {Parent = prefix == "Core" and CoreFolder or RobloxFolder}
	scriptObj.Parent.Parent = package
	setfenv(f, setmetatable({script = scriptObj, require = mockRequire, workspace = workspace, Vector3 = Vector3, CFrame = CFrame,
		RaycastParams = RaycastParams, Enum = Enum, warn = print}, {__index = _G}))
	loaded[name] = f()
	return loaded[name]
end
-- folders refs whose FindFirstChild returns refs: NR2003Cup children must be nil when absent
local cupFolderMeta = folder("NR2003Cup")
local origFind = rawget(cupFolderMeta, "FindFirstChild")

-- ===== scenario =====
local passed, failed = 0, 0
local function check(name, ok, detail)
	if ok then passed += 1 else failed += 1 end
	print((ok and "PASS  " or "FAIL  ") .. name .. (detail and ("  " .. detail) or ""))
end
-- NR2003CupVehicle.new(folder) probes NR2003CupImage1.. until nil: make missing modules nil
do
	local orig = mockRequire
	mockRequire = function(ref)
		if ref.ref:sub(1, 10) == "NR2003Cup." then
			local m = ref.ref:sub(11)
			if realModules[m] == nil then
				local ok, v = pcall(require, "../../core/NR2003Cup/" .. m)
            if not ok then ok, v = pcall(require, "../core/NR2003Cup/" .. m) end
				realModules[m] = ok and v or false
			end
			return realModules[m] or nil
		end
		return orig(ref)
	end
end
local Adapter = mockRequire({ref = "Roblox.CupChassisAdapter"})
-- NR2003CupVehicle.new uses folder:FindFirstChild(name) and require(m): wrap so absent -> nil
local Vehicle = mockRequire({ref = "Core.NR2003CupVehicle"})
local realNew = Vehicle.new
Vehicle.new = function(f)
	return Vehicle.fromLoader(function(name) return mockRequire({ref = "NR2003Cup." .. name}) end)
end
local TestTune = mockRequire({ref = "Core.TestTune"}).new()
-- The real adapter must not feed host raycasts, averaged normals or blockcasts
-- back into the recovered world. Any such query is an immediate test failure.
local trackOrigin = CFrame.new(123, 45, -678) * CFrame.Angles(0, 0.2, 0)
local visualModel = {}
function visualModel:IsA(class) return class == "Model" end
function visualModel:GetAttribute(name) return name == "TrackOriginEnabled" and true or nil end
function visualModel:GetPivot() return trackOrigin end
function workspace:FindFirstChild(name) return name == "NR2003WatkinsGlen" and visualModel or nil end
function workspace:Raycast() error("Track adapter called Roblox Raycast") end
function workspace:Blockcast() error("Track adapter called Roblox Blockcast") end
packageAttributes.NR2003Track = "watkins_glen"
mockRequire({ref = "Core.CupTune"}).driver.momentumKeys = 0
car.Parent = {Name = "NR2003LabWorld"}
local prepared = 0
local host = mockRequire({ref = "Roblox.NR2003WatkinsGlen"})
-- Avatar lifecycle + actual SeatAccess are exercised by spawn_mock_body.luau.
-- Here the real core/adapter must invoke preparation after its pose is ready.
host.prepareDriverSpawn = function(controller, world)
    assert(world == car.Parent and controller.rootCF and controller.core.V.worldActive())
    controller.car:PivotTo(controller.rootCF)
    prepared += 1
end
local ctl = Adapter.new(car, TestTune, {})
check("track startup prepares driver spawn without a server source patch", prepared == 1)
check("current keyboard momentum=0 is retained by original-core startup", ctl.tune.driver.momentumKeys == 0)
check("original world loaded and active", ctl.originalTrack and ctl.core.V.worldActive())
check("car and visuals share explicit origin", ctl.origin == trackOrigin)
local input = {throttle=0,brake=0,steer=0,clutch=0}
for _=1,5 do ctl:step(1/36,input) end
check("original contact ticks complete without host queries", ctl.core:tick()==40 and not ctl.fault, tostring(ctl.fault))
local tel=ctl:telemetry()
local supported=false
for _,w in ipairs(tel.wheels) do if w.grounded and w.load>0 then supported=true end end
check("telemetry reads original tire support", supported)
local record=ctl.core.V.trackPosition({})
local expected=ctl:worldPoint(record.x,record.y,record.z)
check("render position follows original absolute track coordinates", (chassis.CFrame.Position-expected).Magnitude<0.001)
check("native surfaces published as diagnostics", attributes.TrackDlongCurrent~=nil and attributes.TrackSurface~=nil)
ctl:reset()
check("reset reactivates the original world", ctl.core.V.worldActive() and ctl.origin==trackOrigin)
ctl:step(1/36,input)
check("reset remains drivable without host queries", not ctl.fault and ctl.core:tick()==8,tostring(ctl.fault))
print(string.format("\ntrack adapter: %d passed, %d failed",passed,failed))
if failed>0 then error("track adapter tests failed") end
