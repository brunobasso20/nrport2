local Vehicle=require('../../../core/NR2003CupVehicle')
local Setups=require('../../../roblox/NR2003WatkinsGlenSetup')
local function get(name)
    local ok,m=pcall(require,'../../../core/NR2003Cup/'..name)
    if not ok then ok,m=pcall(require,'../../core/NR2003Cup/'..name) end
    return ok and m or nil
end
local car=Vehicle.fromLoader(get)
car:loadTrack()
for _,name in ipairs({'fast','easy','qualify','jasper'}) do
    local items=Setups.new(car.V.Setup,name)
    local ok,report=car:applySetup(items)
    assert(ok,name..' original car build failed')
    car:startSession({temperatureF=70},{damageLevel=0})
    car.V.setControlsSuspended(false)
    for _=1,96 do car:step({originalPedals=true,throttle=0,throttleControl=0,brakeControl=0,
        clutch=1,steerLeft=0,steerRight=0,steerDigital=true}) end
    local supported=false
    for i=0,3 do supported=supported or car.V.trackContact(i,{}).grounded end
    assert(car.V.worldActive() and supported,name..' lacks native support after placement')
    print(name,'build/world/contact passed; pressure',car.V.Setup.display(car:setup(),'tirePressureLF'),
        'steering ratio',car.V.Setup.display(car:setup(),'steeringRatio'),'structure',report.structure)
    car:endSession()
end
print('Four original setup profiles build and drive with original track contacts.')
