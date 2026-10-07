-- Stage 6/7 vehicle core: the ORIGINAL NR2003 Cup car running in Luau.
-- Core.NR2003Cup holds code generated from NR2003.exe (recovery/stage6_7/gen_runtime.py):
--   NR2003CupImage1..n : memory image after the game's own car build (spec, setup defaults,
--                        tire/engine init, component graph, JIT cells, tables)
--   NR2003CupCore      : machine state + 86 lifted x86 natives + host primitives
--   NR2003CupJIT1..n   : the x87 callbacks NR2003 generates at car build, translated
--   NR2003CupDriver    : 005b2190 tick order, 00551e80/005539c0 driver layer (hand port)
--   NR2003CupAero      : Stage 9 session air (005a3c00), per-frame aero factors (005637e0),
--                        drafting (005afd80), aero setup items, aero telemetry (hand port)
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
    local jit=collect(get,"NR2003CupJIT")
    assert(#jit>0,"NR2003CupJIT modules missing")
    local V=get("NR2003CupDriver")(get("NR2003CupCore")(image,jit))
    local aero=get("NR2003CupAero") -- Stage 9 (absent in a Stage 6/7/8 install)
    if aero then aero(V) end
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
function M:tick() return self.V.tick end
-- controls: {throttle, clutch(engagement), steer(road-wheel rad, + left), shiftUp, shiftDown,
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
function M:startSession(weather) return self.V.startSession(weather) end
function M:endSession() self.V.endSession() end
function M:sessionActive() return self.V.sessionActive() end
function M:weather() return self.V.weather() end
function M:setDraftEnvironment(env) self.V.setDraftEnvironment(env) end
function M:setTrackNormal(n) self.V.setTrackNormal(n) end
function M:aeroFactors() return self.V.aeroFactors() end
function M:setAeroSetup(s) return self.V.setAeroSetup(s) end
function M:aeroSetup() return self.V.aeroSetup() end
function M:aeroState(out) return self.V.aeroState(out) end
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
