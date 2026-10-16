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
    local o=setmetatable({values={ClassName=class,IsLoaded=defaultLoaded,Loaded=signal(),playCount=0,destroyed=false},children={}},mt)
    function o:Play() self.playCount+=1 end
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
preloadFails=true;backend:preload()
check("content loading failures are contained and reported",backend.failures==1)
local attachment=backend.attachments[0];backend:destroy();backend:destroy()
check("cleanup is idempotent and only removes owned sound objects",attachment.destroyed and voice.sound.destroyed and not root.destroyed)
voice.sound.Loaded:Fire()
check("late callbacks after destruction cannot restart audio",voice.sound.playCount==1)
print(string.format("audio playback backend mock: %d passed, 0 failed",passed))
