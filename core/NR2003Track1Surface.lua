-- Track1 configuration input to the ORIGINAL tire routines, not a new tire model.
-- Addresses and material tables: watkinsglen_implementation/recovery/evidence/
-- 0050fbd0.c, 00510080.c, 00510090.c, 0054ef10.c and surface_tables.json.
local Data=require(script and script.Parent.RecoveredData or "./RecoveredData")
local M={}
local scratch=buffer.create(4)
local function iniFloat(value)
    -- ProfileManager's parsed inputs are nearest float32; the original loader's
    -- subsequent multiplication stores under the simulation's downward mode.
    buffer.writef32(scratch,0,value);return buffer.readf32(scratch,0)
end
M.ADDRESS={baseGrip=0x6f6570,loadedGrip=0x74fb30,wear=0x74b9d8,heat=0x74b9dc,
    wearLoss=0x74b9e0,wearExponent=0x74b9e4}
M.DEFAULTS={TrackAsphaltGrip=1,TrackConcreteGrip=1,TrackTireHeat=Data.trackDefaults.track_tire_heat,
    TrackTireWear=Data.trackDefaults.track_tire_wear,TrackTireWearLoss=Data.trackDefaults.track_tire_wear_loss,
    TrackTireWearExponent=Data.trackDefaults.track_tire_wear_exp}
local function number(settings,key)
    local value=settings[key]
    if value==nil then value=M.DEFAULTS[key] end
    assert(type(value)=="number" and value==value and math.abs(value)<math.huge and value>=0,
        "track1: invalid nonnegative parameter "..key)
    return value
end
function M.apply(V,settings)
    settings=settings or {}
    assert(V.rf32 and V.wf32 and V.wf32d,"track1 requires the original Cup memory/float32 API")
    assert(not V.trackLoaded or not V.trackLoaded(),"track1 must not modify a loaded Watkins Glen world")
    local a=M.ADDRESS
    -- Verify the ABI before writing anything. Track-specific loaded values may differ.
    for index=0,19 do
        assert(V.rf32(a.baseGrip+4*index)==Data.surfaces[index+1].base,
            "track1: incompatible original material table at index "..index)
    end
    local values={}
    for key in pairs(M.DEFAULTS) do values[key]=number(settings,key) end
    assert(values.TrackTireWearLoss<=1,"track1: TrackTireWearLoss must be 0..1")
    assert(values.TrackTireWearExponent>0,"track1: TrackTireWearExponent must be positive")
    -- Original ini values are float32 before the final base*multiplier store.
    for index=0,19 do
        local mult=index==1 and values.TrackAsphaltGrip or index==2 and values.TrackConcreteGrip or 1
        V.wf32d(a.loadedGrip+4*index,V.rf32(a.baseGrip+4*index)*iniFloat(mult))
    end
    V.wf32(a.wear,values.TrackTireWear)
    V.wf32(a.heat,values.TrackTireHeat)
    V.wf32(a.wearLoss,values.TrackTireWearLoss)
    V.wf32(a.wearExponent,values.TrackTireWearExponent)
    return M.read(V)
end
function M.read(V)
    local a=M.ADDRESS
    return {asphaltGrip=V.rf32(a.loadedGrip+4),concreteGrip=V.rf32(a.loadedGrip+8),
        tireHeat=V.rf32(a.heat),tireWear=V.rf32(a.wear),wearLoss=V.rf32(a.wearLoss),
        wearExponent=V.rf32(a.wearExponent)}
end
return M
