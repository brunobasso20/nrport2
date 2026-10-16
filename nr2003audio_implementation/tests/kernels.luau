local Curves=require("../roblox/Audio/NR2003AudioCurves")
local Engine=require("../roblox/Audio/NR2003AudioEngine")
local Controller=require("../roblox/Audio/NR2003AudioController")
local State=require("../roblox/Audio/NR2003AudioState")
local Profiles=require("../roblox/Audio/NR2003AudioProfiles")
local Golden=require("./curve_golden")
local passed=0
local function check(name,ok) assert(ok,name);passed+=1;print("PASS "..name) end
local worst=0;local vectors=0
for j,case in ipairs(Golden) do
    for _,v in ipairs(case.vectors) do
        local value=Curves.evaluate(case.curve,Curves.f32(v[1]))
        local error=math.abs(value-v[2]);worst=math.max(worst,error);vectors+=1
        assert(error<=math.max(1e-6,math.abs(v[2])*2e-6),string.format("curve %d x %.8g: %.10g != %.10g",j,v[1],value,v[2]))
    end
end
check("235 response vectors agree with original x86 kernels (documented CRT bridges)",vectors==235)
print("maximum absolute kernel error",worst)
local unity={kind=4};local one={kind=0,constant=1}
local bank={engineRefs={4000},gearRefs={2000},engineVolume={0,1},gearVolume={0,1},samples={}}
for i=1,2 do bank.samples[i]={file="fixture.wav",phase=0,enabled=true,mechanical=0,group=0,focus=0,perspective=0,curves={one,one,unity,unity}} end
local controls=Engine.controls(bank,{rpm=6000,load=0.8,gearScale=3},true,true)
check("equal overlapping samples normalize without invented RPM thresholds",math.abs(controls[1].gain-0.4)<1e-5 and controls[1].gain==controls[2].gain)
check("engine pitch follows actual RPM/reference",controls[1].pitch==1.5)
bank.samples[1].mechanical=1
controls=Engine.controls(bank,{rpm=6000,load=1,gearScale=3},true,true,controls)
check("gear pitch uses recovered gear/final-drive scalar",controls[1].pitch==9)
check("original minimum pitch is 0.25",Curves.pitch(bank,bank.samples[2],0,3)==0.25)
bank.samples[1].perspective=1
check("interior-only sample is excluded outside",Engine.controls(bank,{rpm=4000,load=1,gearScale=1},true,false)[1].gain==0)
bank.samples[1].perspective=0
local profile=Profiles.resolve("NR2003_ORIGINAL_REFERENCE",{profiles={NR2003_ORIGINAL_REFERENCE={
    banks={["winston.ces"]=bank},assets={["fixture.wav"]="rbxassetid://12345"}}}})
local backend={created=0,destroyed=0,sets=0,items={}}
function backend:create() self.created+=1;local h={gain=0};self.items[#self.items+1]=h;return h end
function backend:set(h,g,p) self.sets+=1;h.gain=g;h.pitch=p end
function backend:destroy() self.destroyed+=1 end
local controller=Controller.new(profile,backend)
local s={epoch=1,gear=1,rpm=4000,load=1,gearScale=1,wheels={}}
for _=1,300 do controller:update(s,true,true) end
check("300 frames keep the same voices; playback is never restarted by RPM updates",backend.created==2)
s.gear=2;controller:update(s,true,true);controller:update(s,true,true)
check("confirmed gear transition counted once",controller.shifts==1)
s.epoch=2;s.gear=0;controller:update(s,true,true)
check("reset clears gear history without generating a shift",controller.shifts==1 and controller.resets==1)
controller:update(nil,true,true)
check("stale/missing state silences all voices",backend.items[1].gain==0 and backend.items[2].gain==0)
controller:destroy();check("controller destroys only its owned backend",backend.destroyed==1)
check("self-made profile stays empty",next(Profiles.PROFILES.NASCAR_SELFMADE.assets)==nil)
check("invalid/missing IDs rejected",Profiles.assetId(nil)==nil and Profiles.assetId("rbxassetid://0")==nil)
check("local Studio references reject path traversal",Profiles.assetId("rbxasset://sounds/nr2003_reference/../other.wav")==nil)
check("audio payload stays below the UnreliableRemoteEvent limit",State.SIZE==272 and State.BASE_BYTES+State.SIZE==476)
print(string.format("audio kernels/lifecycle: %d passed, 0 failed",passed))
