Vector3.yAxis=Vector3.new(0,1,0)
Vector3.__eq=function(a,b) return a.X==b.X and a.Y==b.Y and a.Z==b.Z end
CFrame.__eq=function(a,b)
    for i=1,3 do if a.p[i]~=b.p[i] then return false end end
    for i=1,9 do if a.r[i]~=b.r[i] then return false end end
    return true
end
function CFrame.lookAt(eye,target,up)
    local f=(target-eye).Unit;local r=f:Cross(up).Unit;local b=-f;local u=b:Cross(r)
    return CFrame.new(eye.X,eye.Y,eye.Z,r.X,u.X,b.X,r.Y,u.Y,b.Y,r.Z,u.Z,b.Z)
end
local Enum={}
for name,items in pairs({Material={"Plastic","Asphalt","Concrete"},RaycastFilterType={"Include","Exclude"},
    RenderFidelity={"Automatic","Precise"},CollisionFidelity={"Default","PreciseConvexDecomposition"},
    ModelStreamingMode={"Default","Persistent"}}) do
    local enum=setmetatable({},{__tostring=function() return "Enum."..name end});Enum[name]=enum
    for _,item in ipairs(items) do enum[item]={__kind="EnumItem",Name=item,EnumType=enum} end
end
local function kind(v)
    if getmetatable(v)==Vector3 then return "Vector3" end
    if getmetatable(v)==CFrame then return "CFrame" end
    if type(v)=="table" and v.__kind then return v.__kind end
    return typeof(v)
end
local function copy(v)
    if type(v)~="table" then return v end
    local out={};for k,x in pairs(v) do out[k]=copy(x) end;return out
end
local methods,mt={},{}
mt.__index=function(o,k)
    if k=="Position" then return o.values.CFrame.Position end
    if methods[k] then return methods[k] end
    if o.values[k]~=nil then return o.values[k] end
    return methods.FindFirstChild(o,k)
end
mt.__newindex=function(o,k,v)
    if o.values.ClassName=="StringValue" and k=="Value" and type(v)=="string" then
        assert(#v<200000,"Provided string length is greater than or equal to max length (200000)")
        if o.state.failValueName==o.Name and o.state.failRemaining>0 then
            o.state.failRemaining-=1;error("injected backup chunk write failure")
        end
        o.state.maxStringValueBytes=math.max(o.state.maxStringValueBytes or 0,#v)
    end
    if k=="Parent" then
        local p=o.values.Parent
        if p then for i,c in ipairs(p.children) do if c==o then table.remove(p.children,i);break end end end
        o.values.Parent=v;if v then v.children[#v.children+1]=o end
    else
        if k=="Source" and o.state.failName==o.Name and o.state.failRemaining>0 then
            o.state.failRemaining-=1;error("injected Source failure")
        end
        o.values[k]=v
    end
    o.state.writes+=1
end
function methods:FindFirstChild(name)
    for _,child in ipairs(self.children) do if child.Name==name then return child end end
end
function methods:WaitForChild(name) return assert(self:FindFirstChild(name),name) end
function methods:GetChildren() return table.clone(self.children) end
function methods:GetDescendants()
    local out={}
    for _,child in ipairs(self.children) do
        out[#out+1]=child;for _,nested in ipairs(child:GetDescendants()) do out[#out+1]=nested end
    end
    return out
end
function methods:IsA(class)
    return class==self.ClassName or class=="BasePart" and (self.ClassName=="MeshPart" or self.ClassName=="Part" or self.ClassName=="SpawnLocation")
end
function methods:IsDescendantOf(root)
    local p=self.Parent;while p do if p==root then return true end;p=p.Parent end;return false
end
function methods:GetFullName() return self.Parent and self.Parent:GetFullName().."."..self.Name or self.Name end
function methods:SetAttribute(name,value) self.attributes[name]=value;self.state.writes+=1 end
function methods:GetAttribute(name) return self.attributes[name] end
function methods:Destroy() for _,child in ipairs(self:GetChildren()) do child:Destroy() end;self.Parent=nil end
function methods:Raycast(origin,direction,params)
    if self.state.missingRoad then return nil end
    assert(params.FilterType==Enum.RaycastFilterType.Include)
    local t=-origin.Y/direction.Y
    return {Position=origin+direction*t,Normal=Vector3.yAxis,Instance=self.state.colPart}
end
local function fixture()
    local state={writes=0,failRemaining=0,running=false}
    local function new(class,name,parent,source)
        local o=setmetatable({__kind="Instance",state=state,children={},attributes={},values={
            ClassName=class,Name=class,Source="",CanCollide=true,CanQuery=true,CanTouch=true,Anchored=false,
            Transparency=0,Material=Enum.Material.Plastic,RenderFidelity=Enum.RenderFidelity.Automatic,
            CollisionFidelity=Enum.CollisionFidelity.Default,ModelStreamingMode=Enum.ModelStreamingMode.Default,
            CFrame=CFrame.new(),Size=Vector3.new(60,1,20),Neutral=false,Duration=10}},mt)
        if name then o.Name=name end;if parent then o.Parent=parent end;if source then o.Source=source end
        return o
    end
    local root=new("DataModel","game")
    local workspace=new("Workspace","Workspace",root)
    local rs=new("Folder","ReplicatedStorage",root);local storage=new("Folder","ServerStorage",root)
    local starter=new("Folder","StarterPlayer",root);local starterScripts=new("Folder","StarterPlayerScripts",starter)
    local client=new("LocalScript","NR2003Client",starterScripts,HUD_RULE[1]..' | existing format")')
    local package=new("Folder","NR2003Lab",rs);package:SetAttribute("NR2003Track","watkins_glen")
    local core=new("Folder","Core",package);new("Folder","NR2003Cup",core)
    new("ModuleScript","NR2003CupVehicle",core,"-- original core")
    local modules=new("Folder","Roblox",package)
    local adapter=new("ModuleScript","CupChassisAdapter",modules,BASE_ADAPTER.."\n-- LOCAL_PREDICTION_SENTINEL\n")
    local watkins=new("ModuleScript","NR2003WatkinsGlen",modules,"-- Watkins remains unchanged")
    local world=new("Folder","NR2003LabWorld",workspace)
    local oldSpawn=new("SpawnLocation","WatkinsGlenDriverSpawn",world)
    new("Model","TestCar",world)
    local vis=new("Folder","vis",workspace);local col=new("Folder","col",workspace)
    local vp=new("MeshPart","VIS_Oval_1",vis)
    local cp=new("MeshPart","COL_Oval_1",col);local concrete=new("MeshPart","COL_Oval_2",col)
    concrete:SetAttribute("INDY_Surface","concrete");state.colPart=cp
    local stored={};local Http={}
    local function encode(value)
        if type(value)=="string" then
            return '"'..value:gsub('[%z\1-\31\\"]',function(c)
                if c=='"' then return '\\"' end
                if c=='\\' then return '\\\\' end
                return string.format('\\u%04x',string.byte(c))
            end)..'"'
        end
        if type(value)=="number" or type(value)=="boolean" then return tostring(value) end
        local items={}
        if value[1]~=nil or next(value)==nil then
            for _,item in ipairs(value) do items[#items+1]=encode(item) end
            return '['..table.concat(items,',')..']'
        end
        local keys={};for key in pairs(value) do keys[#keys+1]=key end;table.sort(keys)
        for _,key in ipairs(keys) do items[#items+1]=encode(key)..':'..encode(value[key]) end
        return '{'..table.concat(items,',')..'}'
    end
    function Http:JSONEncode(value)
        local encoded=encode(value)
        if state.journalBytes then
            assert(#encoded<=state.journalBytes)
            encoded..=string.rep(' ',state.journalBytes-#encoded)
        end
        stored[encoded]=copy(value);return encoded
    end
    function Http:JSONDecode(value) return copy(assert(stored[value],"Journal content changed during persistence")) end
    local services={ReplicatedStorage=rs,ServerStorage=storage,StarterPlayer=starter,HttpService=Http,
        RunService={IsRunning=function() return state.running end}}
    local payload=new("ModuleScript","NR2003_Track1",workspace,INSTALLER)
    for name,source in pairs({Journal=JOURNAL,SurfaceSource="",HostSource="",Rules="",HudRule=""}) do new("ModuleScript",name,payload,source) end
    local loaded={SurfaceSource=SURFACE,HostSource=HOST,Rules=RULES,HudRule=HUD_RULE}
    local env=setmetatable({workspace=workspace,Vector3=Vector3,CFrame=CFrame,Enum=Enum,typeof=kind,
        RaycastParams={new=function() return {} end},
        Instance={new=function(class) return new(class) end},
        game={GetService=function(_,name) return assert(services[name],name) end},print=function() end,warn=function() end},
        {__index=getfenv()})
    env.require=function(ref)
        if loaded[ref.Name] then return loaded[ref.Name] end
        local f=assert(loadstring(ref.Source,ref.Name));local e=setmetatable({script=ref},{__index=env});setfenv(f,e)
        local value=f();loaded[ref.Name]=value;return value
    end
    local install=env.require(payload)
    state.writes=0
    return {state=state,new=new,install=install,env=env,package=package,core=core,modules=modules,adapter=adapter,
        storage=storage,world=world,workspace=workspace,vis=vis,col=col,vp=vp,cp=cp,concrete=concrete,
        oldSpawn=oldSpawn,watkins=watkins,client=client,services=services,
        journal=function() return env.require(payload.Journal) end}
end
local passed=0
local function check(label,condition) assert(condition,label);passed+=1;print("PASS "..label) end
local f=fixture();local original=f.adapter.Source;local clientOriginal=f.client.Source
check("installer applies actual payload",f.install())
check("only small adapter insertions preserve existing prediction/local source",f.adapter.Source:find("LOCAL_PREDICTION_SENTINEL",1,true)
    and f.core.NR2003Track1Surface.Source==SURFACE and f.modules.NR2003Track1.Source==HOST)
check("asphalt/concrete indices are applied separately",f.cp:GetAttribute("NRSurface")==1 and f.concrete:GetAttribute("NRSurface")==2)
check("visuals never collide or answer tire queries",not f.vp.CanCollide and not f.vp.CanQuery and f.vp.RenderFidelity==Enum.RenderFidelity.Precise)
check("collision stays invisible, queryable and persistent",f.cp.CanCollide and f.cp.CanQuery and f.cp.Transparency==1
    and f.col.Parent.ModelStreamingMode==Enum.ModelStreamingMode.Persistent)
check("track1 has a separate scene marker and selector",f.world.track1:IsA("SpawnLocation") and f.package:GetAttribute("NR2003Track")=="track1")
check("Watkins Glen module and spawn identities are preserved",f.watkins.Source=="-- Watkins remains unchanged"
    and f.world.WatkinsGlenDriverSpawn==f.oldSpawn)
check("track HUD selects its name without dropping existing fields",f.client.Source:find('tr.name=="track1"',1,true)~=nil)
local writes=f.state.writes
check("repeat installation makes no writes",f.install() and f.state.writes==writes)
f.adapter.Source..="-- later user edit\n";writes=f.state.writes
check("rollback refuses newer source edits before writing",not pcall(f.journal().rollback) and f.state.writes==writes)
f.adapter.Source=f.adapter.Source:sub(1,-#"-- later user edit\n"-1)
check("rollback executes",f.journal().rollback())
check("rollback restores original active track and source",f.package:GetAttribute("NR2003Track")=="watkins_glen"
    and f.adapter.Source==original and f.client.Source==clientOriginal)
check("rollback restores original folder and material properties",f.col.Parent==f.workspace and f.cp.Transparency==0
    and f.cp:GetAttribute("NRSurface")==nil and f.concrete:GetAttribute("INDY_Surface")=="concrete")
check("rollback removes only created track1 objects",not f.world.track1 and not f.package.Track1Config
    and not f.storage.NR2003Backup_Track1 and f.world.WatkinsGlenDriverSpawn==f.oldSpawn)
local g=fixture();g.state.failName="CupChassisAdapter";g.state.failRemaining=1
check("source write failure reverses earlier new modules",not pcall(g.install) and not g.core.NR2003Track1Surface
    and not g.modules.NR2003Track1 and g.package:GetAttribute("NR2003Track")=="watkins_glen")
local h=fixture();h.state.missingRoad=true
check("spawn failure restores all source/geometry changes",not pcall(h.install) and h.col.Parent==h.workspace
    and h.cp.Transparency==0 and not h.world.track1 and not h.storage.NR2003Backup_Track1)
local i=fixture();i.state.running=true
check("installation during Play is refused without writes",not pcall(i.install) and i.state.writes==0)
local j=fixture();j.adapter.Source="-- incompatible adapter";j.state.writes=0
check("unsupported source is refused without writes",not pcall(j.install) and j.state.writes==0)
local k=fixture();k.new("Folder","col",k.workspace);k.state.writes=0
check("ambiguous col roots are refused without writes",not pcall(k.install) and k.state.writes==0)
local b=fixture();b.cp:SetAttribute("Feature",false)
local tx=b.journal().new();tx:write(b.cp,"attribute","Feature",true);tx:commit();b.journal().rollback()
check("journal preserves a prior false attribute value",b.cp:GetAttribute("Feature")==false)
local r=fixture()
local rs=r.new("ModuleScript","NR2003Track1Surface",r.core,SURFACE)
local rh=r.new("ModuleScript","NR2003Track1",r.modules,HOST)
r.install();r.journal().rollback()
check("matching Rojo modules are reused and preserved by rollback",r.core.NR2003Track1Surface==rs and r.modules.NR2003Track1==rh)
local large=fixture();large.state.journalBytes=579660
large.install()
local backup=large.storage.NR2003Backup_Track1
check("reported 579660-byte backup persists below the per-value limit",backup.Journal:GetAttribute("ByteLength")==579660
    and backup.Journal:GetAttribute("ChunkCount")==4 and large.state.maxStringValueBytes<=150000)
check("large backup can be decoded and fully rolled back",large.journal().rollback()
    and large.package:GetAttribute("NR2003Track")=="watkins_glen" and large.col.Parent==large.workspace)
local unicode=fixture();local note=unicode.new("StringValue","Note",unicode.workspace)
note.Value=string.rep("á",75001)
local originalNote=note.Value
local utx=unicode.journal().new();utx:write(note,"property","Value",string.rep("é",75001));utx:commit()
local valid=true
for _,chunk in ipairs(unicode.storage.NR2003Backup_Track1.Journal:GetChildren()) do
    valid=valid and utf8.len(chunk.Value)~=nil and #chunk.Value<=150000
end
unicode.journal().rollback()
check("Unicode boundaries survive journal chunking and rollback",valid and note.Value==originalNote)
local corrupt=fixture();corrupt.install()
local firstChunk=corrupt.storage.NR2003Backup_Track1.Journal.Part00001
firstChunk.Value=firstChunk.Value:sub(1,-2);local beforeCorruptRollback=corrupt.state.writes
check("truncated backup is rejected before rollback writes",not pcall(corrupt.journal().rollback)
    and corrupt.state.writes==beforeCorruptRollback)
local legacy=fixture();local ltx=legacy.journal().new()
ltx:write(legacy.cp,"attribute","LegacyFlag",true);ltx:commit()
local lb=legacy.storage.NR2003Backup_Track1
local encoded={};for _,chunk in ipairs(lb.Journal:GetChildren()) do encoded[#encoded+1]=chunk.Value end
lb.Journal:Destroy();local oldJournal=legacy.new("StringValue","Journal",lb);oldJournal.Value=table.concat(encoded)
check("small v1 StringValue backups remain readable",legacy.journal().rollback() and legacy.cp:GetAttribute("LegacyFlag")==nil)
local circuit=fixture()
for n=1,437 do circuit.new("MeshPart","VIS_"..n,circuit.vis) end
for n=1,763 do circuit.new("MeshPart","COL_"..n,circuit.col) end
circuit.install()
local whole=circuit.storage.NR2003Backup_Track1.Journal
local wholeBytes=whole:GetAttribute("ByteLength")
circuit.journal().rollback()
check("438 visual and 765 collision parts install and roll back under the string limit",wholeBytes>579660
    and #circuit.vis:GetChildren()==438 and #circuit.col:GetChildren()==765 and circuit.col.Parent==circuit.workspace
    and circuit.state.maxStringValueBytes<=150000)
local partial=fixture();partial.state.journalBytes=579660
partial.state.failValueName="Part00002";partial.state.failRemaining=1
check("failure halfway through backup chunks restores installation changes",not pcall(partial.install)
    and not partial.storage.NR2003Backup_Track1 and not partial.package.Track1Config
    and partial.col.Parent==partial.workspace and partial.package:GetAttribute("NR2003Track")=="watkins_glen")
local function signal()
    local event={callbacks={}}
    function event:Connect(fn)
        local row={fn=fn,active=true};self.callbacks[#self.callbacks+1]=row
        return {Disconnect=function() row.active=false end}
    end
    function event:Fire(...) for _,row in ipairs(self.callbacks) do if row.active then row.fn(...) end end end
    return event
end
local s=fixture();s.install()
local players={PlayerAdded=signal(),PlayerRemoving=signal(),list={}}
function players:GetPlayers() return table.clone(self.list) end
s.services.Players=players
local deferred={};s.env.task={defer=function(fn) deferred[#deferred+1]=fn end}
local oldRequire=s.env.require
s.env.require=function(ref)
    if ref.Name=="NR2003Track1Surface" then return {DEFAULTS={}} end
    return oldRequire(ref)
end
local player={Parent=players,RespawnLocation=s.oldSpawn,CharacterAdded=signal()}
local root={Position=Vector3.new(1000,0,1000),AssemblyLinearVelocity=Vector3.new(1,2,3)}
local humanoid={Health=100}
local character={}
function character:WaitForChild(name) return name=="Humanoid" and humanoid or root end
function character:GetPivot() return CFrame.new(root.Position) end
function character:PivotTo(cf) root.Position=cf.Position end
player.Character=character;players.list={player}
s.world.track1.Destroying=signal()
local host=s.env.require(s.modules.NR2003Track1)
local controller={track1Spawn=s.world.track1}
host.prepareDriverSpawn(controller)
check("existing player receives dedicated track1 respawn",player.RespawnLocation==s.world.track1)
for _,fn in ipairs(deferred) do fn() end
check("existing avatar is moved from old world to track1",(root.Position-s.world.track1.Position).Magnitude<5)
host.clearDriverSpawn(controller)
check("driver teardown restores prior respawn without deleting either marker",player.RespawnLocation==s.oldSpawn
    and s.world.track1~=nil and s.world.WatkinsGlenDriverSpawn==s.oldSpawn)
root.Position=Vector3.new(1000,0,1000);humanoid.SeatPart={};deferred={}
host.prepareDriverSpawn(controller)
for _,fn in ipairs(deferred) do fn() end
check("spawn lifecycle leaves seated avatars in place",root.Position.X==1000)
host.clearDriverSpawn(controller)
print(string.format("track1 installer/rollback: %d passed, 0 failed",passed))
