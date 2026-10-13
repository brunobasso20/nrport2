-- Headless Studio DataModel checks for Watkins Glen installation and rollback.
local Instance = {}
local IMeta = {}
local function newInstance(class, name)
	local o = {ClassName = class, Name = name or class, _children = {}, _attrs = {}, Archivable = true, _parent = nil}
	return setmetatable(o, IMeta)
end
IMeta.__index = function(o, k)
	if k == "Parent" then return rawget(o, "_parent") end
	local m = Instance[k]
	if m then return m end
	for _, c in ipairs(rawget(o, "_children")) do if c.Name == k then return c end end
	return nil
end
IMeta.__newindex = function(o, k, v)
	if k == "Parent" then
		local old = rawget(o, "_parent")
		if old then
			local list = rawget(old, "_children")
			for i, c in ipairs(list) do if c == o then table.remove(list, i); break end end
		end
		rawset(o, "_parent", v)
		if v then table.insert(rawget(v, "_children"), o) end
		return
	end
	if k == "Source" and #v >= 200000 then error("Source exceeds 200000 characters (" .. #v .. ")") end
	rawset(o, k, v)
end
function Instance.new(class) return newInstance(class) end
function Instance.FindFirstChild(o, name) for _, c in ipairs(rawget(o, "_children")) do if c.Name == name then return c end end return nil end
function Instance.WaitForChild(o, name) return assert(Instance.FindFirstChild(o, name), "WaitForChild: " .. name) end
function Instance.GetChildren(o) return table.clone(rawget(o, "_children")) end
function Instance.SetAttribute(o, k, v) rawget(o, "_attrs")[k] = v end
function Instance.GetAttribute(o, k) return rawget(o, "_attrs")[k] end
function Instance.IsA(o,c)
 return o.ClassName==c or (c=="LuaSourceContainer" and (o.ClassName=="ModuleScript" or o.ClassName=="Script" or o.ClassName=="LocalScript")) or (c=="BasePart" and o.ClassName=="Part")
end
function Instance.Destroy(o) o.Parent = nil; rawset(o, "_destroyed", true) end
function Instance.Clone(o)
	local c = newInstance(o.ClassName, o.Name)
	for k, v in pairs(o) do if k ~= "_children" and k ~= "_parent" and k ~= "_attrs" then rawset(c, k, v) end end
	for k, v in pairs(rawget(o, "_attrs")) do rawget(c, "_attrs")[k] = v end
	for _, ch in ipairs(rawget(o, "_children")) do Instance.Clone(ch).Parent = c end
	return c
end

local function make(class, name, parent, source)
	local o = newInstance(class, name)
	if source then rawset(o, "Source", source) end
	o.Parent = parent
	return o
end

function Instance.GetDescendants(o)
 local list={}
 local function add(parent) for _,c in ipairs(parent:GetChildren()) do table.insert(list,c);add(c) end end
 add(o);return list
end
function Instance.GetFullName(o) return o.Parent and o.Parent:GetFullName().."."..o.Name or o.Name end
function Instance.IsDescendantOf(o,p) local at=o.Parent;while at do if at==p then return true end;at=at.Parent end;return false end
function Instance.GetPivot(o) return CFrame.identity end
local CFrame={identity={GetComponents=function() return 0,0,0,1,0,0,0,1,0,0,0,1 end}}
-- Methods close over this identity without needing native vector operations.
function Instance.GetPivot(o) return CFrame.identity end
local services, running, failWrite, cache, writeHook={},false,nil,{},nil
local SES={GetEditorSource=function(_,s) return s._editorSource or s.Source or "" end,
 UpdateSourceAsync=function(_,s,cb)
  local parent=s.Parent;local inDataModel=false
  while parent do
   for _,service in pairs(services) do if parent==service then inDataModel=true end end
   parent=parent.Parent
  end
  assert(inDataModel,"ScriptEditorService requires a script in the DataModel")
  if writeHook then writeHook(s) end
  if failWrite and failWrite(s) then failWrite=nil;error("injected source write failure") end
  rawset(s,"Source",cb(s.Source or ""))
 end}
local game={GetService=function(_,n)
 if n=="ScriptEditorService" then return SES end
 if n=="RunService" then return {IsRunning=function() return running end} end
 return assert(services[n],n)
end}
local mockRequire
mockRequire=function(module)
 if cache[module]~=nil then return cache[module] end
 local factory=assert(loadstring(module.Source,module.Name))
 setfenv(factory,setmetatable({script=module,require=mockRequire,game=game,workspace=services.Workspace,Instance=Instance,CFrame=CFrame},{__index=_G}))
 local result=factory();cache[module]=result;return result
end
local function atKey(folders,key)
 local bits=string.split(key,".");local parent=folders[bits[1]]
 for i=2,#bits-1 do parent=parent:FindFirstChild(bits[i]) or make("Folder",bits[i],parent) end
 return parent,bits[#bits]
end
local function fixture()
 services={};cache={};running=false;failWrite=nil;writeHook=nil
 for _,name in ipairs({"ReplicatedStorage","ServerScriptService","ServerStorage","StarterPlayer","Workspace"}) do services[name]=make(name,name,nil) end
 local pkg=make("Folder","NR2003Lab",services.ReplicatedStorage)
 local core=make("Folder","Core",pkg);local rb=make("Folder","Roblox",pkg);make("Folder","NR2003Cup",core)
 local sp=make("StarterPlayerScripts","StarterPlayerScripts",services.StarterPlayer)
 local folders={Core=core,Roblox=rb,Server=services.ServerScriptService,Client=sp}
 for key,entry in pairs(ORIGINALS) do local parent,name=atKey(folders,key);make(entry.class,name,parent,entry.source) end
 local client=make("LocalScript","NR2003Client",sp,"-- custom client is preserved")
 local assets=make("Folder","CarModel",pkg);make("Model","Assets",assets):SetAttribute("UserAssetMarker","retain")
 pkg:SetAttribute("NR2003Track",false)
 local world=make("Folder","NR2003LabWorld",services.Workspace)
 local bench=make("Folder","TestTrack",world);make("Part","Asphalt",bench)
 local car=make("Model","TestCar",world);make("Part","Chassis",car)
 local visual=make("Model","NR2003WatkinsGlen",services.Workspace)
 visual:SetAttribute("TrackOriginEnabled",true);visual:SetAttribute("NR2003MetresPerStud",.28)
 local terrain=make("Model","Terrain",visual);terrain:SetAttribute("NR2003VisualKind","terrain")
 local part=make("Part","Mesh",terrain);part.Anchored=true;part.CanCollide=false;part.CanTouch=false;part.CanQuery=false
 local install=make("Model","NR2003_WatkinsGlen_InstallV3",services.Workspace)
 for name,source in pairs(TEMPLATES) do make("ModuleScript",name,install,source) end
 local sources=make("Folder","Sources",install);local sf={}
 for _,name in ipairs({"Core","Roblox","Server"}) do sf[name]=make("Folder",name,sources) end
 for key,source in pairs(PAYLOADS) do local parent,name=atKey(sf,key);make("ModuleScript",name,parent,source) end
 return {pkg=pkg,folders=folders,world=world,bench=bench,car=car,client=client,assets=assets,visual=visual,install=install}
end
local function apply(f) return pcall(mockRequire(f.install.Apply)) end
local function backup() return services.ServerStorage:FindFirstChild("NR2003Backup_WatkinsGlen") end
local function rollback() return pcall(mockRequire(backup().Rollback)) end
local function allOriginal(f)
 for key,entry in pairs(ORIGINALS) do local p,n=atKey(f.folders,key);if not p[n] or p[n].Source~=entry.source then return false end end
 for key in pairs(PAYLOADS) do if not ORIGINALS[key] then local p,n=atKey(f.folders,key);if p[n] then return false end end end
 return true
end
local function allNew(f)
 for key,source in pairs(PAYLOADS) do local p,n=atKey(f.folders,key);if not p[n] or p[n].Source~=source then return false end end
 return true
end
local passed,failed=0,0
local function check(name,ok,detail)
 if ok then passed+=1 else failed+=1 end
 print((ok and "PASS  " or "FAIL  ")..name..(detail and " | "..tostring(detail) or ""))
end
local f=fixture();local H=mockRequire(f.install.Support)
check("FNV-1a UTF-8 source normalization",select(2,H.fingerprint("hello"))==1335831723 and H.matches("a\r\nb\r",{bytes=4,fnv32=select(2,H.fingerprint("a\nb\n"))}))
running=true;local ok,reason=apply(f)
check("Play refusal has no mutation",not ok and not backup() and allOriginal(f));running=false
f.visual:SetAttribute("TrackOriginEnabled",false);ok=apply(f)
check("uncalibrated visuals refuse before mutation",not ok and not backup() and allOriginal(f))
f=fixture();f.visual.Terrain.Mesh.CanQuery=true
local originOk=pcall(mockRequire(f.install.Support).origin)
check("untagged queryable terrain refuses before mutation",not originOk and not backup() and allOriginal(f))
f.visual.Terrain.Mesh:SetAttribute("NR2003TerrainQuery",true)
originOk=pcall(mockRequire(f.install.Support).origin)
check("tagged terrain camera queries accepted without collision",originOk and not f.visual.Terrain.Mesh.CanCollide and not f.visual.Terrain.Mesh.CanTouch)
f.visual.Terrain:SetAttribute("NR2003VisualKind","scenery")
originOk=pcall(mockRequire(f.install.Support).origin)
check("tagged scenery query mesh refused",not originOk and not backup() and allOriginal(f))
f=fixture();local adapter=f.pkg.Roblox.CupChassisAdapter;local originalAdapter=adapter.Source
adapter.Source..="\n-- local edit";ok,reason=apply(f)
check("unknown target edit refuses before mutation",not ok and not backup() and adapter.Source==originalAdapter.."\n-- local edit")
f=fixture();f.pkg.Core.NR2003Cup.NR2003CupCore.Source..="\n-- core edit";ok,reason=apply(f)
check("incompatible solver dependency refuses before mutation",not ok and not backup())
-- Exact supported CupTune edit from the current Studio source.
for _,trimFinalNewline in ipairs({false,true}) do
 f=fixture();local tune=f.pkg.Core.CupTune;local instance=tune
 local source,count=CUPTUNE_BASELINE:gsub("momentumKeys=nil,","momentumKeys=0,")
 assert(count==1)
 if trimFinalNewline then source=source:gsub("\n+$","") end
 tune.Source=source
 ok,reason=apply(f)
 check("keyboard momentum=0 compatible and source preserved; trimmed="..tostring(trimFinalNewline),ok and allNew(f) and tune==instance and tune.Source==source,not ok and reason or nil)
 ok,reason=apply(f)
 check("momentum=0 compatible repeat install",ok and tune.Source==source,not ok and reason or nil)
 ok,reason=rollback()
 check("momentum=0 source preserved through rollback",ok and tune.Source==source and not backup(),not ok and reason or nil)
end
f=fixture();local tune=f.pkg.Core.CupTune
local altered=tune.Source:gsub("momentumKeys=nil,","momentumKeys=0,"):gsub("metresPerStud=Base%.metresPerStud","metresPerStud=0.56")
tune.Source=altered;ok,reason=apply(f)
check("other CupTune changes still refused before mutation",not ok and not backup() and tune.Source==altered,reason)

f=fixture();f.install.Sources.Roblox.NR2003WatkinsGlen.Source="truncated";ok=apply(f)
check("corrupt payload refuses before mutation",not ok and not backup() and allOriginal(f))
f=fixture();f.pkg.Roblox.CupChassisAdapter._editorSource="-- unsaved local edit";ok=apply(f)
check("unsaved editor buffer refuses before mutation",not ok and not backup() and allOriginal(f))
f=fixture();make("ModuleScript","NR2003WatkinsGlen",f.pkg.Roblox,"-- unknown existing module");ok=apply(f)
check("unknown existing newly-added module refuses",not ok and not backup())
f=fixture();local identities={}
for key in pairs(ORIGINALS) do local p,n=atKey(f.folders,key);identities[key]=p[n] end
ok,reason=apply(f)
check("complete patch applies exact source payloads",ok and allNew(f),not ok and reason or nil)
local same=true;for key,o in pairs(identities) do local p,n=atKey(f.folders,key);if p[n]~=o then same=false end end
check("changed source instance identities preserved",same)
check("client, assets and car preserved; bench moved intact",f.client.Source=="-- custom client is preserved" and f.assets.Assets:GetAttribute("UserAssetMarker")=="retain" and f.car.Parent==f.world and f.bench.Parent==backup().MovedBench)
local savedBackup=backup();local entries=savedBackup.Entries;local added,old=0,0
for _,e in ipairs(entries:GetChildren()) do if e:GetAttribute("Added") then added+=1 else old+=1 end end
local expectedAdded,expectedOld=0,0
for key in pairs(PAYLOADS) do if ORIGINALS[key] then expectedOld+=1 else expectedAdded+=1 end end
check("backup has every original and added-module marker",old==expectedOld and added==expectedAdded,string.format("%d originals, %d added",old,added))
check("track attributes enabled only after source install",f.pkg:GetAttribute("NR2003Track")=="watkins_glen" and f.pkg:GetAttribute("NR2003WatkinsGlenPatch")~=nil)
ok,reason=apply(f)
check("repeat install is idempotent and retains first backup",ok and backup()==savedBackup and allNew(f),not ok and reason or nil)
local newAdapter=f.pkg.Roblox.CupChassisAdapter.Source;f.pkg.Roblox.CupChassisAdapter.Source..="\n-- later local edit"
ok,reason=rollback()
check("rollback refuses subsequent target edits without mutation",not ok and backup()==savedBackup and f.pkg:GetAttribute("NR2003Track")=="watkins_glen")
f.pkg.Roblox.CupChassisAdapter.Source=newAdapter;ok,reason=rollback()
check("rollback restores all original sources and removes added modules",ok and allOriginal(f) and not backup(),not ok and reason or nil)
check("rollback restores false-valued prior attributes and bench parent",f.pkg:GetAttribute("NR2003Track")==false and f.pkg:GetAttribute("NR2003WatkinsGlenPatch")==nil and f.bench.Parent==f.world)
f=fixture();failWrite=function(s) return s.Name=="Original" end
ok,reason=apply(f)
check("backup source write failure removes partial backup and changes no live source",not ok and allOriginal(f) and not backup() and f.pkg:GetAttribute("NR2003Track")==false and f.bench.Parent==f.world,reason)
f=fixture();failWrite=function(s) return s.Name=="NR2003CupTrackBuild" and s.Parent and s.Parent.Name=="NR2003Cup" end
ok,reason=apply(f)
check("injected mid-install write failure restores sources, attrs and bench",not ok and allOriginal(f) and f.pkg:GetAttribute("NR2003Track")==false and f.bench.Parent==f.world and not backup(),reason)
f=fixture();assert(apply(f));failWrite=function(s) return s.Name=="NR2003CupFrame" and s.Parent and s.Parent.Name=="NR2003Cup" end
ok,reason=rollback()
check("injected rollback write failure restores installed state",not ok and allNew(f) and backup() and f.pkg:GetAttribute("NR2003Track")=="watkins_glen" and f.bench.Parent==backup().MovedBench,reason)

-- UpdateSourceAsync yields in Studio. Keep one transaction suspended at a real
-- source-write boundary while other imported copies attempt to enter it.
local function operation() return services.ServerStorage:FindFirstChild("NR2003WatkinsGlenOperation") end
f=fixture()
writeHook=function(s) if s.Name=="Original" then writeHook=nil;coroutine.yield("preparing backup") end end
local worker=coroutine.create(function() return mockRequire(f.install.Apply)() end)
local resumed,pause=coroutine.resume(worker)
local held=operation();local incomplete=backup()
check("source-write yield holds operation lock",resumed and pause=="preparing backup" and held~=nil and incomplete:GetAttribute("Complete")==false)
ok,reason=apply(f)
check("overlapping same-model install refuses without disturbing first transaction",not ok and tostring(reason):find("already running",1,true)~=nil and operation()==held and backup()==incomplete and allOriginal(f),reason)
local other=f.install:Clone();other.Name="AnotherInstallerCopy";other.Parent=services.Workspace
ok,reason=pcall(mockRequire(other.Apply))
check("separate imported installer copy shares operation lock",not ok and operation()==held and backup()==incomplete and allOriginal(f),reason)
resumed,reason=coroutine.resume(worker)
check("first installer resumes to completion and releases lock",resumed and coroutine.status(worker)=="dead" and allNew(f) and not operation(),not resumed and reason or nil)
ok=rollback()
check("successful rollback releases operation lock",ok and allOriginal(f) and not operation())

f=fixture()
writeHook=function(s) if s.Name=="NR2003CupBuild" and s.Parent.Name=="NR2003Cup" then writeHook=nil;coroutine.yield("applying sources") end end
worker=coroutine.create(function() return mockRequire(f.install.Apply)() end)
resumed,pause=coroutine.resume(worker);held=operation();incomplete=backup()
ok,reason=rollback()
check("rollback cannot remove backup during a yielding install",resumed and pause=="applying sources" and not ok and operation()==held and backup()==incomplete and tostring(reason):find("already running",1,true)~=nil,reason)
resumed,reason=coroutine.resume(worker)
check("install finishes after blocked concurrent rollback",resumed and allNew(f) and not operation(),not resumed and reason or nil)

f=fixture();assert(apply(f));local missing=backup().Entries["Core.NR2003Cup.NR2003CupTrackData3"]
missing:Destroy();local saved=backup();ok,reason=apply(f)
check("missing backup entry refuses repeated install before mutation",not ok and allNew(f) and backup()==saved and not operation(),reason)
ok,reason=rollback()
check("missing backup entry refuses rollback before mutation",not ok and allNew(f) and backup()==saved and not operation(),reason)

f=fixture();assert(apply(f));saved=backup()
local forged=saved.Entries["Core.NR2003Cup.NR2003CupBuild"]
forged.Original:Destroy();forged:SetAttribute("Added",true)
ok,reason=rollback()
check("existing core target cannot be mislabeled as added and deleted on rollback",not ok and backup()==saved and allNew(f) and not operation(),reason)

f=fixture()
writeHook=function(s)
 if s.Name=="NR2003CupTrackData3" and s.Parent.Name=="NR2003Cup" then
  writeHook=nil;backup().Entries["Core.NR2003Cup.NR2003CupTrackData3"]:Destroy()
 end
end
ok,reason=apply(f)
check("entry removed during source write restores all live sources and releases lock",not ok and allOriginal(f) and not backup() and not operation() and f.bench.Parent==f.world,reason)

local manifest=mockRequire(f.install.Manifest)
local function unfinished(f,bundle)
 local stale=make("Folder","NR2003Backup_WatkinsGlen",services.ServerStorage)
 stale:SetAttribute("Bundle",bundle or manifest.previousBundles[2]);stale:SetAttribute("Complete",false)
 stale:SetAttribute("Previous_NR2003Track_Present",true);stale:SetAttribute("Previous_NR2003Track",false)
 stale:SetAttribute("Previous_NR2003WatkinsGlenPatch_Present",false)
 local entries=make("Folder","Entries",stale)
 make("ModuleScript","PartialOriginal",entries,"-- retained backup data, never required")
 return stale
end
for _,previous in ipairs(manifest.previousBundles) do
 f=fixture();local stale=unfinished(f,previous);local tune=f.pkg.Core.CupTune;local src=tune.Source
 ok,reason=apply(f)
 check("restored unfinished backup is archived intact and install completes: "..previous:sub(1,8),ok and allNew(f) and backup()~=stale and stale.Parent==services.ServerStorage and stale.Name:find("_Recovered_",1,true)~=nil and stale.Entries.PartialOriginal.Source=="-- retained backup data, never required" and tune.Source==src and not operation(),not ok and reason or nil)
 ok,reason=rollback()
 check("rollback after recovery preserves archived backup and starting sources",ok and allOriginal(f) and stale.Parent==services.ServerStorage and not backup(),not ok and reason or nil)
end
f=fixture();local stale=unfinished(f,"unknown");ok,reason=apply(f)
check("unrecognized unfinished backup is retained without source mutation",not ok and backup()==stale and allOriginal(f) and not operation(),reason)
f=fixture();stale=unfinished(f)
f.pkg.Core.NR2003Cup.NR2003CupBuild.Source=PAYLOADS["Core.NR2003Cup.NR2003CupBuild"]
ok,reason=apply(f)
check("partially patched live state is refused without discarding unfinished backup",not ok and backup()==stale and f.pkg.Core.NR2003Cup.NR2003CupBuild.Source==PAYLOADS["Core.NR2003Cup.NR2003CupBuild"] and not operation(),reason)
f=fixture();stale=unfinished(f);f.pkg:SetAttribute("NR2003Track","watkins_glen");ok,reason=apply(f)
check("active track attributes prevent unfinished-backup archive",not ok and backup()==stale and allOriginal(f) and not operation(),reason)
f=fixture();stale=unfinished(f);f.pkg:SetAttribute("NR2003Track","another_track");ok,reason=apply(f)
check("unrestored package attribute prevents unfinished-backup archive",not ok and backup()==stale and allOriginal(f) and not operation(),reason)
f=fixture();stale=unfinished(f);local moved=make("Folder","MovedBench",stale);f.bench.Parent=moved;ok,reason=apply(f)
check("saved moved bench prevents unfinished-backup archive",not ok and backup()==stale and f.bench.Parent==moved and allOriginal(f) and not operation(),reason)
f=fixture();stale=unfinished(f);f.pkg.Core.CupTune.Source..="\n-- unverified change";ok,reason=apply(f)
check("dependency preflight refuses before archiving unfinished backup",not ok and backup()==stale and not operation(),reason)
check("failed operations leave no operation lock",not operation())
print(string.format("installer mock: %d passed, %d failed",passed,failed));assert(failed==0,"installer mock failures")
