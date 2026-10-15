local Vehicle=require('../../../core/NR2003CupVehicle')
local Setups=require('../../../roblox/NR2003WatkinsGlenSetup')
local function get(n)
 local ok,m=pcall(require,'../../../core/NR2003Cup/'..n)
 if not ok then ok,m=pcall(require,'../../core/NR2003Cup/'..n) end
 return ok and m or nil
end
local c=Vehicle.fromLoader(get);c:loadTrack()
for _,name in ipairs({'fast','easy','qualify','jasper'}) do
 local s=Setups.new(c.V.Setup,name);assert(c:applySetup(s));c:startSession({temperatureF=70},{damageLevel=0})
 local info=c.V.trackInfo();assert(info.chassisType==4 and info.spec==0x723c70)
 for w=0,3 do assert(c.V.r32(0xbf3a20+w*0xa39+0x70)==0x8b0fa0 and info.tireProfiles[w+1]==8) end
 c.V.setControlsSuspended(false)
 for _=1,96 do c:step({originalPedals=true,throttle=0,throttleControl=0,brakeControl=0,clutch=1,steerLeft=0,steerRight=0,steerDigital=true}) end
 local supported=false
 for w=0,3 do supported=supported or c.V.trackContact(w,{}).grounded end
 assert(supported,'Stock road-course setup lacks tire support')
 c:reset();assert(c.V.trackInfo().chassisType==4)
 c:endSession();print(name,'road chassis / four road tires / native contacts / reset passed')
end
local bench=Vehicle.fromLoader(get)
local s=Setups.new(bench.V.Setup,'fast');assert(bench:applySetup(s),'Road instance contaminated bench callback metadata')
assert(bench.V.r32(0xc125be)==2 and bench.V.r32(0xbf3a20+0x70)~=0x8b0fa0,'Bench specification was changed')
assert(bench.V.Build.REF.generic.litTop~=c.V.Build.REF.generic.litTop)
print('Independent bench keeps original speedway specification and callback layouts')
assert(c:applySetup(c.V.Setup.cupDefault()))
c:startSession({temperatureF=70},{damageLevel=0});assert(c.V.trackInfo().chassisType==4 and c.V.r32(0xbf3a20+0x70)==0x8b0fa0)
print('Default-image restore retains road callback selection')
print('Road-course vehicle regression passed')
