local fields={'title','gauge','header','aeroLine','s11Line','steerLine','ffbLine','status','trackTitle'}
local env={driving=true,rows={{},{},{},{}},trackRows={{},{},{},{}},surfaceNames=HUD_MATERIALS,
    Color3={fromRGB=function(...) return {...} end}}
for _,name in ipairs(fields) do env[name]={} end
local f=assert(loadstring(HUD_CALLBACK))
setfenv(f,setmetatable(env,{__index=_G}))
local draw=f()
local live=ctl:telemetry()
local before=ctl.core:readState()
draw(live)
check('HUD consumes actual track telemetry',env.hasTrack and env.trackTitle.Text:find('setup fast',1,true)~=nil)
local labels=true
for j,w in ipairs(live.track.wheels) do
    labels=labels and env.trackRows[j].Text:find(w.name,1,true)~=nil
    if w.grounded then labels=labels and env.trackRows[j].Text:find('('..w.surface..')',1,true)~=nil end
end
check('four live HUD rows identify each original contact material',labels)
local after=ctl.core:readState();local untouched=true
for i=1,45 do untouched=untouched and before[i]==after[i] end
check('HUD callback cannot change the car states',untouched)
ctl.core:translate(0,0,5)
ctl:step(1/36,input)
live=ctl:telemetry();draw(live)
local air=true
for j,w in ipairs(live.track.wheels) do
    air=air and not w.grounded and w.fx==0 and w.fy==0 and w.fz==0 and w.muUsed==0
        and env.trackRows[j].Text:find('SEM CONTATO',1,true)~=nil
end
check('airborne native tires show no contact and zero generated force',air)
local legacy=table.clone(live);legacy.track=nil;draw(legacy)
check('HUD also accepts legacy telemetry without track fields',not env.hasTrack)
print(string.format('track adapter + HUD: %d passed, %d failed',passed,failed))
assert(failed==0,'Actual track HUD tests failed')
