local Vehicle=require("../../core/NR2003CupVehicle")
local Setups=require("../../roblox/NR2003WatkinsGlenSetup")
local function get(name)
    local ok,m=pcall(require,"../../core/NR2003Cup/"..name)
    if not ok then ok,m=pcall(require,"../../watkinsglen_implementation/core/NR2003Cup/"..name) end
    return ok and m or nil
end
local car=Vehicle.fromLoader(get);car:loadTrack()
local V=car.V
local options={automatic=true,autoClutch=true,abs=true,tractionControl=false,stabilityControl=false,steering=0}
local controls={originalPedals=true,throttle=1,throttleControl=1,brakeControl=0,clutch=1,steerLeft=0,steerRight=0,steerDigital=true}
for _,name in ipairs({"fast","easy","qualify","jasper"}) do
    assert(car:applySetup(Setups.new(V.Setup,name)))
    car:startSession({temperatureF=70},{damageLevel=0})
    V.setSteeringOptions({momentum=0,lowSpeedOverride=false})
    V.setDrivingAssists(options);V.setControlsSuspended(false)
    assert(V.r32(0xbd7960)==0,"Racing line expected absent from the supplied world image")
    assert(V.r32(0xc12030+0x5ae)~=0,"Original world record must exist")
    for _=1,288 do car:step(controls) end
    for _,value in ipairs(car:readState()) do assert(value==value and math.abs(value)<math.huge,"Nonfinite state "..name) end
    local original=car:checkpoint()
    for _=1,24 do car:step(controls) end
    local expected=car:checkpoint()
    car:restore(original)
    for _=1,24 do car:step(controls) end
    local actual=car:checkpoint()
    assert(buffer.tostring(expected.memory)==buffer.tostring(actual.memory),"Road replay differs "..name)
    car:reset();car:startSession({temperatureF=70},{damageLevel=0});V.setDrivingAssists(options)
    local a=V.drivingAssists()
    assert(a.automatic and a.autoClutch and a.abs and not a.tractionControl and not a.stabilityControl)
    print("PASS",name,"road setup + requested aids + native contacts + exact checkpoint replay + reset")
end
print("PASS missing original racing-line data confirmed in installed track image; positive steering help remains guarded")
