local function v4()
    local f=fixture(BASE_TEMPLATES,BASE_PAYLOADS,'NR2003_WatkinsGlen_InstallV4')
    local ok,err=apply(f);assert(ok,tostring(err))
    local base=backup()
    local update=make('Model','NR2003_WatkinsGlen_HandlingV5',services.Workspace)
    for name,source in pairs(DELTA_TEMPLATES) do make('ModuleScript',name,update,source) end
    local sources=make('Folder','Sources',update);local folders={}
    for _,name in ipairs({'Core','Roblox','Client'}) do folders[name]=make('Folder',name,sources) end
    for key,source in pairs(DELTA_PAYLOADS) do local p,n=atKey(folders,key);make('ModuleScript',n,p,source) end
    f.install=update
    return f,base
end
local function own() return services.ServerStorage:FindFirstChild('NR2003Backup_WatkinsGlenHandlingV5') end
local function operation() return services.ServerStorage:FindFirstChild('NR2003WatkinsGlenOperation') end
local function ownRollback() return pcall(mockRequire(own().Rollback)) end
local function stillV4(f)
    for key,source in pairs(BASE_PAYLOADS) do local p,n=atKey(f.folders,key);if not p[n] or p[n].Source~=source then return false end end
    for key in pairs(DELTA_PAYLOADS) do
        if not BASE_PAYLOADS[key] then
            local p,n=atKey(f.folders,key)
            local prior=ORIGINALS[key]
            if prior then if not p[n] or p[n].Source~=prior.source then return false end
            elseif p[n] then return false end
        end
    end
    return f.pkg:GetAttribute('NR2003WatkinsGlenPatch')==mockRequire(f.install.BaseManifest).bundle
end
local f,base=v4();local baseBundle=base:GetAttribute('Bundle');local originalCar=f.car;local originalClient=f.client
local ok,err=apply(f)
check('actual shipped V4 upgrades to exact V5 sources',ok and allNew(f),not ok and err or nil)
check('V4 backup and moved bench remain intact',backup()==base and base:GetAttribute('Complete')==true and base:GetAttribute('Bundle')==baseBundle and f.bench.Parent==base.MovedBench)
check('car/client instance identity and imported assets retained',f.car==originalCar and f.client==originalClient and f.car.Parent==f.world and f.assets.Assets:GetAttribute('UserAssetMarker')=='retain')
check('own complete backup includes client and original pedal source',own() and own():GetAttribute('Complete') and own().Entries['Client.NR2003Client'].Original.Source==ORIGINALS['Client.NR2003Client'].source)
local savedOwn=own();ok,err=apply(f)
check('cached reapply is idempotent',ok and own()==savedOwn and allNew(f),not ok and err or nil)
local other=f.install:Clone();other.Name..='_Copy';other.Parent=services.Workspace
ok,err=pcall(mockRequire(other.Apply))
check('fresh imported copy also reuses valid backup',ok and own()==savedOwn and allNew(f),not ok and err or nil)
ok,err=rollback()
check('V4 rollback refuses while handling update is active',not ok and own()==savedOwn and allNew(f),err)
ok,err=ownRollback()
check('handling rollback restores exact V4 sources and attributes',ok and stillV4(f) and not own() and backup()==base,not ok and err or nil)
ok,err=rollback()
check('original V4 rollback still works after handling rollback',ok and not backup() and f.bench.Parent==f.world and f.client.Source==ORIGINALS['Client.NR2003Client'].source,not ok and err or nil)

f,base=v4();f.client.Source..='\n-- local cockpit change'
ok,err=apply(f)
check('unknown client changes refuse before live writes',not ok and not own() and backup()==base and f.client.Source:find('local cockpit change',1,true)~=nil,err)
f,base=v4();f.client._editorSource=f.client.Source..'\n-- unsaved edit'
ok,err=apply(f)
check('unsaved client editor refuses before backup',not ok and not own() and backup()==base,err)
f,base=v4();base:SetAttribute('Complete',false)
ok,err=apply(f)
check('incomplete original V4 backup refuses update',not ok and not own() and stillV4(f),err)
f,base=v4();running=true;ok,err=apply(f);running=false
check('Play mode refuses without changing V4',not ok and stillV4(f) and not own(),err)
f,base=v4();f.car:SetAttribute('WatkinsGlenSetup','unknown');ok,err=apply(f)
check('invalid stock setup refuses before updating the car',not ok and stillV4(f) and not own() and backup()==base,err)

for _,name in ipairs({'NR2003CupDriver','RenderPresentation'}) do
    f,base=v4()
    failWrite=function(s) return s.Name==name and s:IsDescendantOf(f.pkg) end
    ok,err=apply(f)
    check('failed live write restores V4 including HUD: '..name,not ok and stillV4(f) and not own() and backup()==base and not operation(),err)
end
f,base=v4();failWrite=function(s) return s.Name=='Original' end
ok,err=apply(f)
check('failed backup preparation leaves V4 untouched',not ok and stillV4(f) and not own() and backup()==base and not operation(),err)

f,base=v4();assert(apply(f));f.client.Source..='\n-- edit after V5'
ok,err=ownRollback()
check('rollback protects new local client changes',not ok and own() and f.client.Source:find('edit after V5',1,true)~=nil and not operation(),err)
f,base=v4();assert(apply(f));own().Entries['Client.NR2003Client'].Original.Source..='\n-- damaged backup'
ok,err=ownRollback()
check('edited saved original refuses rollback',not ok and own() and allNew(f) and not operation(),err)
f,base=v4();assert(apply(f))
failWrite=function(s) return s.Name=='NR2003CupDriver' and s:IsDescendantOf(f.pkg) end
ok,err=ownRollback()
check('failed rollback restores complete V5 state',not ok and own() and allNew(f) and backup()==base and not operation(),err)

f,base=v4();local yielded=false
writeHook=function(s) if not yielded and s.Name=='Original' then yielded=true;coroutine.yield('paused') end end
local worker=coroutine.create(function() return mockRequire(f.install.Apply)() end)
local resumed=coroutine.resume(worker)
check('source-write yield holds shared operation lock',resumed and yielded and operation()~=nil)
other=f.install:Clone();other.Parent=services.Workspace
ok,err=pcall(mockRequire(other.Apply))
check('second imported update cannot race a yielding installer',not ok and operation()~=nil,err)
ok,err=rollback()
check('V4 rollback shares lock with update',not ok and operation()~=nil,err)
writeHook=nil
resumed,ok,err=coroutine.resume(worker)
check('yielded update completes with one coherent backup',resumed and ok and allNew(f) and own() and backup()==base and not operation(),err)
print(string.format('handling upgrade: %d passed, %d failed',passed,failed))
assert(failed==0,'Handling update transaction tests failed')
