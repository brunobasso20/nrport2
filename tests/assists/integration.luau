local Vehicle=require("../../core/NR2003CupVehicle")
local function get(name)
    local ok,m=pcall(require,"../../core/NR2003Cup/"..name)
    return ok and m or nil
end
local car=Vehicle.fromLoader(get)
local V=car.V
local defaults={automatic=true,autoClutch=true,abs=true,tractionControl=false,stabilityControl=false,steering=0}
local passed=0
local function check(label,condition) assert(condition,label);passed+=1;print("PASS",label) end
V.startSession({temperatureF=70},{damageLevel=0})
V.setSteeringOptions({momentum=0,lowSpeedOverride=false})
local a=car:setDrivingAssists(defaults)
check("requested defaults use original option cells",a.automatic and a.autoClutch and a.abs and not a.tractionControl
    and not a.stabilityControl and not a.steering and not a.lowSpeedSteering
    and V.ri32(0x74c974)==0 and V.r32(0x74c980)==0x3df5c28f)
check("steering assistance cannot silently use missing racing-line data",not a.steeringAvailable and not pcall(function()
    local o=table.clone(defaults);o.steering=50;V.setDrivingAssists(o)
end) and V.rf32(0xbf6f08)==0)
local manual=table.clone(defaults);manual.automatic=false
a=V.setDrivingAssists(manual)
check("manual + auto clutch uses ShiftMethod 1 and original timing",not a.automatic and a.autoClutch and a.shiftMethod==1 and V.r32(0x74c980)==0x3db851ec)
manual.autoClutch=false;a=V.setDrivingAssists(manual)
check("manual clutch uses ShiftMethod 3",not a.automatic and not a.autoClutch and a.shiftMethod==3)
local all=table.clone(defaults);all.tractionControl=true;all.stabilityControl=true
V.setDrivingAssists(all)
local flags=V.r32(0xc0692a+0x4c)
V.w32(0xc0692a+0x4c,bit32.bor(flags,0x20000000));a=V.drivingAssists()
check("hardcore race flag disables ABS/TC/stability but retains automatic/clutch",not a.abs and not a.tractionControl
    and not a.stabilityControl and a.automatic and a.autoClutch and a.aidsDisabled)
V.w32(0xc0692a+0x4c,flags)
V.setDrivingAssists(defaults)
local flat={}
for i=1,4 do flat[i]={0,0,1,0,0,0,0,1,1} end
local controls={throttle=1,throttleControl=1,brakeControl=0,clutch=1,originalPedals=true,steerLeft=0,steerRight=0,steerDigital=true}
V.setControlsSuspended(false)
local gears={}
for tick=1,288*12 do
    car:step(controls,flat);gears[car:gearIndex()]=true
end
check("automatic selects and executes forward shifts without E/Q",gears[3]==true)
local before=V.checkpoint()
for i=1,24 do car:step(controls,flat) end
local expected=V.checkpoint()
V.restore(before)
for i=1,24 do car:step(controls,flat) end
local actual=V.checkpoint()
check("automatic + ABS replay restores complete native memory",buffer.tostring(expected.memory)==buffer.tostring(actual.memory))
V.setDrivingAssists(manual)
V.restore(before)
check("checkpoint restores assist options as well as flags",V.drivingAssists().automatic)
V.reset();a=V.drivingAssists()
check("reset reapplies restored assist selection",a.automatic and a.autoClutch and a.abs and not a.tractionControl and not a.stabilityControl)
local depth=V._fpu()
check("original FPU stack stays balanced",depth==0)
print(passed,"assist integration checks passed")
