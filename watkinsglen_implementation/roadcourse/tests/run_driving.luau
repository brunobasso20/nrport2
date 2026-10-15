local Vehicle=require('../../../core/NR2003CupVehicle')
local Setups=require('../../../roblox/NR2003WatkinsGlenSetup')
local fixtures=require('./driving_fixtures')
local function get(n)
 local ok,m=pcall(require,'../../../core/NR2003Cup/'..n)
 if not ok then ok,m=pcall(require,'../../core/NR2003Cup/'..n) end
 return ok and m or nil
end
for _,name in ipairs({'pit_fast','pit_easy','concrete_fast'}) do
 local ref=fixtures[name]
 local c=Vehicle.fromLoader(get);local V=c.V
 c:loadTrack();local items=Setups.new(V.Setup,ref.setup);assert(c:applySetup(items))
 local statics=0
 for a,u in pairs(ref.static) do assert(V.r32(tonumber(a))==u,'Original spec/profile constant mismatch: '..a);statics+=1 end
 assert(V.r32(0xc125be)==4 and V.r32(0xc125ba)==0x723c70,'Original road chassis selection failed')
 V.setSteeringOptions({momentum=0});V.setForceFeedbackDevice({capable=false});V.setForceFeedbackOptions({enabled=false})
 V.setTrackStart(unpack(ref.start));c:startSession({temperatureF=70,windSpeedMph=0,conditions=0},{damageLevel=0,series=1})
 V.setControlsSuspended(false);V.w8(0xbf6f04,0);V.w8(0xbf6f05,0);V.w8(0xbf6f06,0);V.w32(0xbf6f08,0)
 for w=0,3 do assert(V.r32(0xbf3a20+w*0xa39+0x70)==0x8b0fa0,'Road tire profile must be active after enterTrack') end
 local position,velocity,rpm,yaw,force,squared,count,pedals,gears,surfaces=0,0,0,0,0,0,0,0,0,0
 for frame,row in ipairs(ref.rows) do
  local f=frame-1;local throttle=f>=24 and 1 or 0
  for _=1,8 do c:step({originalPedals=true,throttle=throttle,throttleControl=throttle,throttleDigital=true,
   brakeControl=0,brakeDigital=true,clutch=1,steerLeft=name=='concrete_fast' and f>=126 and f<128 and 1 or 0,
   steerRight=0,steerDigital=true,shiftUp=f==18}) end
  local got=c:readState()
  for i=1,45 do assert(got[i]==got[i] and math.abs(got[i])<math.huge,'Nonfinite road-course state') end
  for _,i in ipairs({1,3,5}) do position=math.max(position,math.abs(got[i]-row.state[i])) end
  for _,i in ipairs({2,4,6}) do velocity=math.max(velocity,math.abs(got[i]-row.state[i])) end
  rpm=math.max(rpm,math.abs(c:engineRpm()-row.state[35]*9.549296585513721))
  yaw=math.max(yaw,math.abs(got[13]-row.state[13]))
  if V.r32(0xbf6390)~=row.throttle or V.r32(0xbf6eb0)~=row.clutch then pedals+=1 end
  if V.gearIndex()~=row.gear then gears+=1 end
  for w=0,3 do
   local tire=V.wheelBrake(w);local want=row.wheels[w+1]
   if V.r32(0xbf3a20+w*0xa39+0x2c0)~=want[1] then surfaces+=1 end
   for k,v in ipairs({tire.fx,tire.fy,tire.fz}) do local e=math.abs(v-want[k+1]);force=math.max(force,e);squared+=e*e;count+=1 end
  end
  if frame==60 or frame==144 then
   local speed=math.sqrt(got[2]^2+got[4]^2+got[6]^2)*3.6
   local rs=math.sqrt(row.state[2]^2+row.state[4]^2+row.state[6]^2)*3.6
   print(string.format('%s %.2f s after gas: speed %.3f / original %.3f km/h; RPM %.2f / original %.2f',name,(frame-24)/36,speed,rs,c:engineRpm(),row.state[35]*9.549296585513721))
  end
 end
 print(string.format('%s: %d exact spec/profile constants; pedal/gear/material mismatches %d/%d/%d; max position %.9g m, velocity %.9g m/s, RPM %.6f, yaw %.9g rad/s, force %.3f N; force RMS %.3f N',name,statics,pedals,gears,surfaces,position,velocity,rpm,yaw,force,math.sqrt(squared/count)))
 assert(pedals==0 and gears==0 and surfaces==0,'Road-course original input/gear/material check failed')
 -- Full force/state equality is reported, not asserted to pass.
end
print('Road-course selectors/constants/input checks passed. Numerical dynamics discrepancies are reported above.')
