-- Section coverage smoke test; it does not compare NR2003 reference states.
-- luau -O2 --codegen watkinsglen_implementation/tests/run_sections.luau
local Vehicle=require('../../core/NR2003CupVehicle')
local function get(name)
 for _,d in ipairs({'../../core/NR2003Cup/','../core/NR2003Cup/'}) do
  local ok,m=pcall(require,d..name);if ok then return m end
 end
end
local V=Vehicle.fromLoader(get).V
V.loadTrack()
local M,B=V.memory(),V.base
local a=buffer.readu32(M,0xbcf734-B)
local n=buffer.readu32(M,0xbad920-B)
local spans={}
for i=0,n-1 do local p=a+i*0x1550;spans[i+1]=buffer.readf32(M,p+4-B)+buffer.readf32(M,p+8-B)*0.5 end
local good,bad,t0=0,0,os.clock()
for i,dl in ipairs(spans) do
 V.endSession();V.reset();V.setTrackStart(dl,0,0)
 local ok,err=pcall(function()
  V.startSession({temperature=70,wind_mph=0,wind_dir=0,conditions=0,night=0},{damageLevel=0,series=1})
  local _,record=V.worldRecord()
  assert(record and V.r32(record)==V.r32(0xbf6d40) and V.r32(record+4)==V.r32(0xbf6d48)
   and V.r32(record+8)==V.r32(0xbf6d50) and bit32.band(V.r32(record+0x54),0x8000)~=0,
   'placed exported world record was not published before broadphase')
  local contacted=false
  for tick=1,96 do
   V.drive({throttle=0,clutch=1,brakeControl=0,brakeDigital=true,steerAxis=0})
   for _,x in ipairs(V.state()) do assert(x==x and math.abs(x)<math.huge,'non-finite state') end
   for wheel=0,3 do if V.trackContact(wheel).grounded then contacted=true end end
  end
  assert(contacted,'no tyre contact in the first 96 ticks')
 end)
 if ok then good+=1;print(string.format('PASS section %d midpoint %.3f m',i-1,dl))
 else bad+=1;print(string.format('FAIL section %d midpoint %.3f m: %s',i-1,dl,tostring(err))) end
end
print(string.format('%d sections passed, %d failed; %.2f elapsed seconds',good,bad,os.clock()-t0))
assert(bad==0,'section coverage failures')
