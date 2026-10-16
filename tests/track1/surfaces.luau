local Vehicle=require("../../core/NR2003CupVehicle")
local Surface=require("../../core/NR2003Track1Surface")
local function get(name)
    local ok,value=pcall(require,"../../core/NR2003Cup/"..name)
    return ok and value or nil
end
local car=Vehicle.fromLoader(get)
local V=car.V
local passed=0
local function check(label,ok)
    assert(ok,label);passed+=1;print("PASS "..label)
end
local loaded=Surface.apply(V,{})
check("asphalt uses original material scalar, without Watkins Glen override",loaded.asphaltGrip==0.800000011920929)
check("concrete uses original material scalar",loaded.concreteGrip==0.7680000066757202)
check("independent track heat/wear defaults",loaded.tireHeat==1 and loaded.tireWear==1
    and loaded.wearLoss==0.20000000298023224 and loaded.wearExponent==1)
check("original asphalt/concrete heat factors remain distinct",V.rf32(0x6f65c0+4)==1
    and math.abs(V.rf32(0x6f65c0+8)-0.9)<1e-7)
check("original rolling constant and speed-squared coefficient retained",
    math.abs(V.rf32(0x6f63c8+4)-0.0025)<1e-9 and math.abs(V.rf32(0x6f6418+4)-0.0000007)<1e-13)
local custom=Surface.apply(V,{TrackAsphaltGrip=1.05,TrackConcreteGrip=1.09,TrackTireHeat=1.12,
    TrackTireWear=1.2,TrackTireWearLoss=0.25,TrackTireWearExponent=1.11})
check("loader follows original float32 rounding for recovered Watkins reference values",
    V.r32(0x74fb34)==0x3f570a3d and V.r32(0x74fb38)==0x3f564d7f)
check("heat/wear inputs reach original accessor cells",V.rf32(0x74b9dc)==custom.tireHeat
    and V.rf32(0x74b9d8)==custom.tireWear and V.rf32(0x74b9e0)==0.25)
local old=V.r32(0x74fb34)
check("invalid settings rejected before any write",not pcall(Surface.apply,V,{TrackTireWearLoss=2})
    and V.r32(0x74fb34)==old)
local f=V.trackLoaded;V.trackLoaded=function() return true end
check("native Watkins Glen world cannot be overwritten",not pcall(Surface.apply,V,{}) and V.r32(0x74fb34)==old)
V.trackLoaded=f
car:reset();Surface.apply(V,{})
check("reset and explicit reapplication restore track1 values",V.rf32(0x74fb34)==loaded.asphaltGrip)
car:startSession({},{})
local planes={{0,0,1,0,0,0,0,1,1},{0,0,1,0,0,0,0,2,1},
    {0,0,1,0,0,0,0,1,1},{0,0,1,0,0,0,0,2,1}}
for _=1,32 do car:step({driver=true,brakeControl=0,throttleControl=0,clutch=0},planes) end
local tyres=car:stage11State({}).tyres
check("original core accepts mixed asphalt/concrete contacts",car:tick()==32 and car:readState()[5]==car:readState()[5])
check("original thermal and wear runtime stays active",car:runtimeMode()=="original"
    and tyres[1].surface[2]>200 and tyres[2].surface[2]>200 and tyres[1].wear>=0)
print(string.format("track1 surfaces: %d passed, 0 failed",passed))
