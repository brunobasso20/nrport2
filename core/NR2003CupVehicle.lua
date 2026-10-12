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
