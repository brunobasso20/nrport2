local Phases=require("../roblox/Audio/NR2003AudioPhases")
local Golden=require("./transport_golden")
local Mixer=require("./mixer_golden")
local Tires=require("../roblox/Audio/NR2003AudioTires")
local Engine=require("../roblox/Audio/NR2003AudioEngine")
local Controller=require("../roblox/Audio/NR2003AudioController")
local Profiles=require("../roblox/Audio/NR2003AudioProfiles")
local Bank=require("../roblox/Audio/NR2003AudioBank")
local passed=0
local function check(name,ok) assert(ok,name);passed+=1;print("PASS "..name) end
for i,v in ipairs(Golden) do
    local t={phase=v[1],lastTransition=v[10]}
    Phases.update(t,{v[7],v[8]},v[2],v[3],v[4],v[5]~=0,v[6]~=0,v[9])
    assert(t.phase==v[11] and t.lastTransition==v[12],string.format("native transport vector %d: phase %d != %d; time %.7g != %.7g",i,t.phase,v[11],t.lastTransition,v[12]))
end
check("2400 transport decisions agree with original x86, including threshold/gate/cooldown edges",#Golden==2400)
for _,v in ipairs(Mixer.fade) do
    local slot=Tires.newSlot();slot.fade=v[1];slot.step=v[2]
    Tires.advance(slot,{volume=0},1)
    assert(slot.fade==v[3],"native tire fade increment/clamp")
end
check("24 tire fade/clamp vectors agree with original x86 instruction block",#Mixer.fade==24)
for _,v in ipairs(Mixer.aggregation) do
    local wheels={}
    for _,w in ipairs(v.wheels) do wheels[#wheels+1]={volume=w[1],pitch=w[2],xfade=w[3],soundType=w[4]} end
    local out=Tires.aggregate(wheels)
    assert(out.volume==v.result[1] and out.pitch==v.result[2] and out.xfade==v.result[3] and out.soundType==v.result[4],"native remote aggregation")
    assert(wheels[2].volume==v.wheels[2][1],"aggregation changed physics state")
end
check("32 remote tire combinations agree with original x86 and leave inputs unchanged",#Mixer.aggregation==32)
for _,v in ipairs(Mixer.uniform) do
    local seed,value=Tires.random(v[1]);assert(seed==v[2] and value==v[3],"native uniform random")
end
check("32 playback random vectors agree with original x86 LCG/uniform",#Mixer.uniform==32)
local one={kind=0,constant=1};local unity={kind=4}
local bank={thresholds={100,0},engineRefs={4000},gearRefs={2000},engineVolume={0,1},gearVolume={0,1},samples={}}
local function sample(phase,mechanical)
    return {file="s"..phase..mechanical..".wav",phase=phase,enabled=true,mechanical=mechanical,group=0,focus=0,perspective=0,curves={one,one,unity,unity}}
end
local grouped={samples={sample(0,1),sample(0,0),sample(0,0),sample(0,0),sample(0,0)}}
grouped.samples[1].group=7;grouped.samples[2].group=3;grouped.samples[3].group=1;grouped.samples[4].group=2
check("original four-composite limit keeps engines first in bank order",table.concat(Bank.layout(grouped,false),",")=="0:3,0:1,0:2,0:0")
check("original tire constructor selects engine group zero",table.concat(Bank.layout(grouped,true),",")=="0:0")
for _,v in ipairs(Mixer.weights) do
    local b={engineRefs={4000},engineVolume={0,1},samples={}}
    for i,value in ipairs(v.values) do
        local s=sample(0,0);s.curves=value=="inactive" and {unity,unity,unity,unity} or {{kind=0,constant=value},one,unity,unity};s.enabled=v.enabled[i]~=0;b.samples[i]=s
    end
    local controls=Engine.controls(b,{rpm=300,load=1,gearScale=1},true,true)
    for i,c in ipairs(controls) do assert(c.weight==v.weights[i],"native mixer normalization") end
end
check("80 mixer configurations retain exact original float32 normalization, including disabled/inactive samples",#Mixer.weights==80)
local selectorBank={engineRefs={4000},engineVolume={0,1},samples={sample(0,0),sample(0,0)}}
selectorBank.samples[1].selector=1;selectorBank.samples[2].selector=2
local selected=Engine.controls(selectorBank,{rpm=300,load=1,gearScale=1},false,true)
check("CES failure selector uses original control flag independently of camera",selected[1].gain==0 and selected[2].gain>.99)
selected=Engine.controls(selectorBank,{rpm=300,load=1,gearScale=1},true,true,selected)
check("selector change clears reused controls instead of carrying an old sample group",selected[1].gain>.99 and selected[2].gain==0 and selected[2].group==nil)
bank.samples={sample(0,0),sample(1,0),sample(2,0),sample(0,1)}
local assets={};for _,s in ipairs(bank.samples) do assets[s.file]="rbxassetid://12345" end
local function make(overrides)
    local profile=Profiles.resolve(Profiles.DEFAULT,{profiles={[Profiles.DEFAULT]={banks={["winston.ces"]=bank,["tire_asphalt.ces"]={thresholds={0,0},samples={sample(0,0)},engineRefs={1},engineVolume={0,1}}},assets=overrides or assets}}})
    local backend={items={},starts=0}
    function backend:create(key) local h={key=key,position=0,playing=false,starts=0};self.items[key]=h;return h end
    function backend:set(h,g,p) h.gain=g;h.pitch=p end
    function backend:play(h,pos) h.starts+=1;self.starts+=1;h.position=pos;h.playing=true end
    function backend:stop(h) h.playing=false end
    function backend:seek(h,pos) h.position=pos end
    function backend:normalized(h) return h.position end
    function backend:playing(h) return h.playing end
    function backend:destroy() end
    return Controller.new(profile,backend),backend
end
local c,b=make();local state={epoch=1,time=10,tick=0,gear=1,rpm=300,load=1,gearScale=1,wheels={}}
c:update(state,true,true)
local loop=b.items["winston.ces:1:1"];local intro=b.items["winston.ces:1:2"];local outro=b.items["winston.ces:1:3"];local gear=b.items["winston.ces:1:4"]
check("low-RPM startup starts original intro once and mutes continuous/gear samples",intro.starts==1 and intro.gain>0 and loop.gain==0 and gear.gain==0 and c:stats().enginePhase==0)
for _=1,300 do c:update(state,true,true) end
check("render updates do not restart one-shots",intro.starts==1 and outro.starts==0)
intro.position=.8;state.time=10.1;c:update(state,true,true)
check("intro tail crosses into loops at original 0.6 position with 2.500000238 slope",c:stats().enginePhase==2 and math.abs(loop.gain-.5)<1e-5 and math.abs(intro.gain-.5)<1e-5)
check("shared gear layer enters continuous transport without an invented gear fade",gear.gain>.99)
intro.position=1;intro.playing=false;state.time=10.2;c:update(state,true,true)
check("completed intro leaves stable continuous playback",intro.gain==0 and loop.gain>.99 and intro.starts==1)
state.rpm=50;state.time=10.3;c:update(state,true,true)
check("bank RPM threshold starts original outro",outro.starts==1 and outro.gain>.99 and loop.gain==0 and c:stats().enginePhase==1)
outro.position=1;outro.playing=false;state.time=10.4;c:update(state,true,true)
check("outro completion stops the transport",c:stats().enginePhase==3 and outro.gain==0 and loop.gain==0)
state.rpm=5000;state.time=11;c:update(state,true,true)
check("joining above original startup gate enters loops directly",c:stats().enginePhase==2 and intro.starts==1 and loop.gain>.99)
state.engineHalfVolume=true;c:update(state,true,true)
check("original car+596 branch halves composite gain without changing pitch",math.abs(loop.gain-.5)<1e-5 and loop.pitch==1.25)
state.engineHalfVolume=false
local reverse,rb=make();state.rpm=300;state.time=20;reverse:update(state,true,true)
rb.items["winston.ces:1:2"].position=.4;state.rpm=0;state.time=20.7;reverse:update(state,true,true)
check("reversing intro into outro mirrors normalized sample position",math.abs(rb.items["winston.ces:1:3"].position-.6)<1e-12)
rb.items["winston.ces:1:3"].position=.7;state.rpm=300;state.time=21.4;reverse:update(state,true,true)
check("reversing outro into intro preserves original position mirror",math.abs(rb.items["winston.ces:1:2"].position-.3)<1e-12)
local missingAssets=table.clone(assets);missingAssets[bank.samples[2].file]=nil
local missing=make(missingAssets);state.time=30;missing:update(state,true,true)
check("missing intro cannot trap a loaded engine in startup",missing:stats().enginePhase==2)
local slot=Tires.newSlot();local wheel={volume=1,pitch=1,xfade=.5,soundType=1}
for _,expected in ipairs({0,.25,.5,.75,1,1}) do assert(Tires.advance(slot,wheel,1).volume==expected,"tire onset sequence") end
check("tire onset uses old fade before the original quarter-step",slot.starts==1)
wheel.volume=0
for _,expected in ipairs({1,.75,.5,.25,0,0}) do assert(Tires.advance(slot,wheel,1).volume==expected,"tire release sequence") end
check("tire release retains last volume until the original fade ends",not slot.active)
local tireController,tb=make();state.time=40;state.tick=8
state.wheels={{volume=1,pitch=1,xfade=.5,soundType=1,cx=1,cy=0,cz=0}}
for _=1,300 do tireController:update(state,true,true) end
check("300 render calls inside one original frame advance tire fade once",tireController.tireSlots[1].fade==.25 and tb.items["tire_asphalt.ces:1:1"].gain==0)
state.tick=16;tireController:update(state,true,true)
check("next original frame advances the audible tire ramp",math.abs(tb.items["tire_asphalt.ces:1:1"].gain-.25)<1e-5)
state.epoch=2;state.tick=0;tireController:update(state,true,true)
check("reset clears transport and tire fade history without a shift event",tireController.resets==1 and tireController.shifts==0 and tireController.tireSlots[1].fade==.25)
print(string.format("audio transitions: %d passed, 0 failed",passed))
