local clock=0
local workspace={GetServerTimeNow=function() return clock end}
local cache={}
local function get(name)
    if cache[name] then return cache[name] end
    if name=='VisualRig' then return {new=function() return {update=function() end} end} end
    if name=='Cockpit' then return {updateAngle=function() end,update=function() end} end
    local fn=assert(loadstring(SOURCES[name],name))
    setfenv(fn,setmetatable({script={Parent=setmetatable({},{__index=function(_,k) return k end})},
        require=get,game={GetService=function() return {} end},workspace=workspace,
        Vector3=Vector3,CFrame=CFrame},{__index=_G}))
    local result=fn();cache[name]=result;return result
end
local Snap=get('RenderSnapshot')
local Presentation=get('RenderPresentation')
local function car()
    local c={attrs={NR2003Track='watkins_glen',NR2003CorePoseOwner=true,CockpitWheelAngle=true}}
    function c:GetAttribute(name) return self.attrs[name] end
    function c:PivotTo(cf) self.cf=cf end
    return c
end
local function remote()
    local r={}
    r.OnClientEvent={Connect=function(_,fn) r.callback=fn;return {Disconnect=function() end} end}
    return r
end
local function snapshot(k)
    local wheels={}
    for j=1,4 do wheels[j]={comp=0,steer=0,spin=k,cx=0,cy=0,cz=0,grounded=true} end
    return {vehicleId=1,seq=k,tick=math.floor(k/60*288),time=k/60,flags=0,
        px=k/60*30,py=2,pz=0,qx=0,qy=0,qz=0,qw=1,lx=30,ly=0,lz=0,ax=0,ay=0,az=0,steer=0,wheels=wheels}
end
local driverCar,observerCar=car(),car()
local dr,obs=remote(),remote()
local driver=Presentation.new(driverCar,{},dr)
local observer=Presentation.new(observerCar,{},obs)
driver:setDriverActive(true);observer:setDriverActive(false)
local passed=0
local function check(ok,name) assert(ok,name);passed+=1;print('PASS '..name) end
check(driver.buffer.cfg.minDelay==1/60 and observer.buffer.cfg.minDelay==.055,'driver buffer leaves observer settings intact')
local untouched=true
for k=1,180 do
    clock=k/60+.004
    local s=snapshot(k);local packet=Snap.encode(s)
    dr.callback(packet);obs.callback(packet)
    driver:update();observer:update()
    untouched=untouched and s.px==k/60*30 and s.time==k/60
end
check(untouched,'presentation leaves the authoritative snapshot inputs unchanged')
local driverDelay=driver.buffer.delay
check(driver.active and observer.active,'both streams remain renderable')
check(driver.buffer.delay<observer.buffer.delay-.025,'active driver has less deliberate view delay')
check(driverCar.cf.Position.X>observerCar.cf.Position.X,'driver sees the later authoritative pose')
local lastTime=driver.buffer.renderTime
driver:setDriverActive(false);clock+=1/60;driver:update()
check(driver.buffer.cfg.minDelay==.055 and driver.buffer.renderTime>=lastTime,'leaving seat restores buffer without rewinding time')
driverCar.attrs.NR2003Track=nil;driver:setDriverActive(true)
check(driver.buffer.cfg.minDelay==.055,'bench driving keeps the existing presentation policy')
clock+=1;driver:update()
check(not driver.active,'stale stream is not extrapolated indefinitely')
print(string.format('presentation: %d passed; stable driver delay %.1f ms / observer %.1f ms',passed,
    driverDelay*1000,observer.buffer.delay*1000))
