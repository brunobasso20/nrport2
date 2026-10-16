local passed=0
local function check(name,ok) assert(ok,name);passed+=1;print("PASS "..name) end
local objects={};local defaultLoaded=true;local preloadFails=false
local function signal()
    local s={connections={}}
    function s:Connect(fn)
        local c={fn=fn,active=true};function c:Disconnect() self.active=false end
        self.connections[#self.connections+1]=c;return c
    end
    function s:Fire() for _,c in ipairs(self.connections) do if c.active then c.fn() end end end
    return s
end
local mt={}
mt.__index=function(o,k) return o.values[k] end
mt.__newindex=function(o,k,v)
    if k=="Parent" and v then v.children[#v.children+1]=o end
    o.values[k]=v
end
local function new(class)
    local o=setmetatable({values={ClassName=class,IsLoaded=defaultLoaded,Loaded=signal(),Ended=signal(),playCount=0,TimeLength=2,TimePosition=0,destroyed=false},children={}},mt)
    function o:Play() self.playCount+=1;self.IsPlaying=true end
    function o:Stop() self.IsPlaying=false;self.TimePosition=0 end
    function o:Destroy() self.destroyed=true;for _,c in ipairs(self.children) do c:Destroy() end end
    objects[#objects+1]=o;return o
end
local root=new("Part");local car={FindFirstChild=function(_,name) if name=="Chassis" then return root end end}
local provider={PreloadAsync=function(_,list,callback)
    if preloadFails then error("injected content failure") end
    for _,s in ipairs(list) do callback(s.SoundId,"Success") end
end}
local env=setmetatable({Instance={new=new},Enum={RollOffMode={InverseTapered="InverseTapered"},AssetFetchStatus={Success="Success"}},
    Vector3={new=function(x,y,z) return {X=x,Y=y,Z=z} end},NumberRange={new=function(a,b) return {Min=a,Max=b} end},
    task={spawn=function(f) f() end},game={GetService=function(_,name) assert(name=="ContentProvider");return provider end}}, {__index=getfenv()})
local f=assert(loadstring(SPATIAL_SOURCE));setfenv(f,env);local Spatial=f()
local backend=Spatial.new(car,{rollOffMinMetres=8,rollOffMaxMetres=250})
local voice=backend:create("original-loop","rbxasset://sounds/nr2003_reference/fixture.wav",0,{loop={startSeconds=.2,endSeconds=1.2}})
check("loaded loop starts exactly once",voice.sound.playCount==1 and backend.starts==1)
voice.sound.Loaded:Fire();backend:preload()
for _=1,300 do backend:set(voice,.5,1.5) end
check("preloading/300 control updates never restart a loop",voice.sound.playCount==1)
check("original loop-region metadata reaches the sound",voice.sound.PlaybackRegionsEnabled and voice.sound.LoopRegion.Min==.2)
check("metre-to-stud rolloff uses existing 0.28 scale",voice.sound.RollOffMinDistance==8/.28)
backend:position(1,1,2,3)
check("wheel positioning only moves owned audio attachments",backend.attachments[1].Position.X==1 and root.Position==nil)
defaultLoaded=false
local delayed=backend:create("delayed","rbxasset://sounds/nr2003_reference/delayed.wav",1,{})
check("unloaded assets do not claim playback",delayed.sound.playCount==0)
delayed.sound.IsLoaded=true;delayed.sound.Loaded:Fire();delayed.sound.Loaded:Fire()
check("late loading starts once",delayed.sound.playCount==1 and backend.loaded==2)
defaultLoaded=true
local intro=backend:create("intro","rbxasset://sounds/nr2003_reference/intro.wav",0,{phase=1,loop={startSeconds=.2,endSeconds=1.2}})
check("one-shot loads without starting or accepting a WAV loop region",intro.sound.playCount==0 and not intro.sound.Looped and intro.sound.PlaybackRegionsEnabled==nil)
backend:play(intro,.25)
for _=1,300 do backend:set(intro,.7,1.5) end
check("one-shot starts once at requested normalized position",intro.sound.playCount==1 and intro.sound.TimePosition==.5 and backend:normalized(intro)==.25)
intro.sound.Ended:Fire()
check("actual completion signal advances the one-shot clock to its end",not backend:playing(intro) and backend:normalized(intro)==1)
defaultLoaded=false
local lateIntro=backend:create("late-intro","rbxasset://sounds/nr2003_reference/late-intro.wav",0,{phase=1})
backend:play(lateIntro,.6);check("one-shot can await asynchronous loading without a repeated start",backend:playing(lateIntro) and lateIntro.sound.playCount==0)
lateIntro.sound.IsLoaded=true;lateIntro.sound.Loaded:Fire();lateIntro.sound.Loaded:Fire()
check("late-loaded one-shot starts at the saved phase once",lateIntro.sound.playCount==1 and lateIntro.sound.TimePosition==1.2)
local cancelled=backend:create("cancelled","rbxasset://sounds/nr2003_reference/cancelled.wav",0,{phase=1})
backend:play(cancelled,.4);backend:stop(cancelled);cancelled.sound.IsLoaded=true;cancelled.sound.Loaded:Fire()
check("cancelled pending one-shot cannot start on a late load",cancelled.sound.playCount==0 and not backend:playing(cancelled))
local lateLoop=backend:create("late-loop","rbxasset://sounds/nr2003_reference/late-loop.wav",0,{phase=0})
backend:seek(lateLoop,.3);lateLoop.sound.IsLoaded=true;lateLoop.sound.Loaded:Fire()
check("original tire start phase survives asynchronous loop loading",lateLoop.sound.playCount==1 and lateLoop.sound.TimePosition==.6)
preloadFails=true;backend:preload()
check("content loading failures are contained and reported",backend.failures==1)
local unavailable=backend:create("unavailable","rbxasset://sounds/nr2003_reference/unavailable.wav",0,{phase=1})
backend:play(unavailable,0);backend:preload()
check("failed pending one-shot releases its phase wait",not backend:playing(unavailable) and unavailable.failed)
local attachment=backend.attachments[0];backend:destroy();backend:destroy()
check("cleanup is idempotent and only removes owned sound objects",attachment.destroyed and voice.sound.destroyed and not root.destroyed)
voice.sound.Loaded:Fire()
check("late callbacks after destruction cannot restart audio",voice.sound.playCount==1)
print(string.format("audio playback backend mock: %d passed, 0 failed",passed))
