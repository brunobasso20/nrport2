local function allNew(f)
 for k,s in pairs(FULL5_PAYLOADS) do local p,n=atKey(f.folders,k);if not p[n] or p[n].Source~=(DELTA_PAYLOADS[k] or s) then return false end end
 for k,s in pairs(DELTA_PAYLOADS) do local p,n=atKey(f.folders,k);if not p[n] or p[n].Source~=s then return false end end
 return true
end
local function addInstaller(f,templates,payloads,name)
 local model=make('Model',name,services.Workspace)
 for n,s in pairs(templates) do make('ModuleScript',n,model,s) end
 local sources=make('Folder','Sources',model);local folders={}
 for _,n in ipairs({'Core','Roblox','Client'}) do folders[n]=make('Folder',n,sources) end
 for k,s in pairs(payloads) do local p,n=atKey(folders,k);make('ModuleScript',n,p,s) end
 f.install=model
end
local function v5(full)
 local f,older
 if full then
  f=fixture(FULL5_TEMPLATES,FULL5_PAYLOADS,'NR2003_WatkinsGlen_InstallV5');assert(apply(f));older=backup()
 else
  f=fixture(BASE4_TEMPLATES,BASE4_PAYLOADS,'NR2003_WatkinsGlen_InstallV4');assert(apply(f))
  addInstaller(f,BASE5_TEMPLATES,BASE5_PAYLOADS,'NR2003_WatkinsGlen_HandlingV5');assert(apply(f))
  older=services.ServerStorage.NR2003Backup_WatkinsGlenHandlingV5
 end
 local oldInstall=f.install;local bundle=f.pkg:GetAttribute('NR2003WatkinsGlenPatch')
 addInstaller(f,DELTA_TEMPLATES,DELTA_PAYLOADS,'NR2003_WatkinsGlen_RoadCourseV6')
 return f,older,oldInstall,bundle
end
local function own() return services.ServerStorage:FindFirstChild('NR2003Backup_WatkinsGlenRoadCourseV6') end
local function operation() return services.ServerStorage:FindFirstChild('NR2003WatkinsGlenOperation') end
local function ownRollback() return pcall(mockRequire(own().Rollback)) end
local function stillV5(f,bundle)
 for k,s in pairs(FULL5_PAYLOADS) do local p,n=atKey(f.folders,k);if not p[n] or p[n].Source~=s then return false end end
 for k in pairs(DELTA_PAYLOADS) do if not FULL5_PAYLOADS[k] then local p,n=atKey(f.folders,k);if p[n] then return false end end end
 return f.pkg:GetAttribute('NR2003WatkinsGlenPatch')==bundle
end
for _,full in ipairs({false,true}) do
 local f,older,oldInstall,bundle=v5(full);local car,client=f.car,f.client
 f.car:SetAttribute('WatkinsGlenSetup','easy')
 local ok,err=apply(f)
 check((full and 'full V5' or 'V4 + V5 updater')..' installs actual V6 sources',ok and allNew(f),not ok and err or nil)
 check('V5 backup, car, cockpit/client and setup selection retained',older:GetAttribute('Complete') and f.car==car and f.client==client and f.car:GetAttribute('WatkinsGlenSetup')=='easy' and f.assets.Assets:GetAttribute('UserAssetMarker')=='retain')
 check('own complete backup records all V6 changes',own() and own():GetAttribute('Complete') and own().Entries['Core.NR2003Cup.NR2003CupGarage']~=nil)
 local saved=own();ok,err=apply(f)
 check('cached V6 apply is idempotent',ok and own()==saved and allNew(f),not ok and err or nil)
 local other=f.install:Clone();other.Name..='_Copy';other.Parent=services.Workspace;ok,err=pcall(mockRequire(other.Apply))
 check('new imported V6 copy reuses complete backup',ok and own()==saved and allNew(f),not ok and err or nil)
 ok,err=pcall(mockRequire(older.Rollback))
 check('previous rollback refuses while V6 is active',not ok and allNew(f),err)
 ok,err=ownRollback()
 check('V6 rollback restores exact V5 and removes only new road modules',ok and stillV5(f,bundle) and not own() and older:GetAttribute('Complete'),not ok and err or nil)
 ok,err=pcall(mockRequire(older.Rollback))
 check('previous V5 rollback remains usable',ok,not ok and err or nil)
 if not full then ok,err=rollback();check('original V4 rollback still works after both updates',ok and not backup() and f.bench.Parent==f.world,not ok and err or nil) end
end
local f,older,oldInstall,bundle=v5();f.client.Source..='\n-- local edit'
local ok,err=apply(f);check('unknown client edits refuse before writes',not ok and not own() and f.client.Source:find('local edit',1,true)~=nil,err)
f,older,oldInstall,bundle=v5();f.client._editorSource=f.client.Source..'\n-- unsaved edit';ok,err=apply(f)
check('unsaved editor changes refuse before backup',not ok and not own() and stillV5(f,bundle),err)
f,older,oldInstall,bundle=v5();older:SetAttribute('Complete',false);ok,err=apply(f)
check('incomplete V5 backup refuses safely',not ok and not own() and stillV5(f,bundle),err)
f,older,oldInstall,bundle=v5();older.Entries['Core.NR2003Cup.NR2003CupDriver'].Original.Source..='\n-- corrupt';ok,err=apply(f)
check('damaged V5 backup refuses safely',not ok and not own() and stillV5(f,bundle),err)
f,older,oldInstall,bundle=v5();running=true;ok,err=apply(f);running=false
check('Play mode refuses safely',not ok and not own() and stillV5(f,bundle),err)
f,older,oldInstall,bundle=v5();f.car:SetAttribute('WatkinsGlenSetup','bad');ok,err=apply(f)
check('invalid setup selection refuses before writing',not ok and not own() and stillV5(f,bundle),err)
for _,n in ipairs({'NR2003CupGarage','NR2003Client'}) do
 f,older,oldInstall,bundle=v5();failWrite=function(s) return s.Name==n and (s:IsDescendantOf(f.pkg) or s==f.client) end
 ok,err=apply(f);check('failed live write restores exact V5: '..n,not ok and not own() and stillV5(f,bundle) and not operation(),err)
end
f,older,oldInstall,bundle=v5();failWrite=function(s) return s.Name=='Original' end;ok,err=apply(f)
check('failed backup preparation leaves V5 unchanged',not ok and not own() and stillV5(f,bundle) and not operation(),err)
f,older,oldInstall,bundle=v5();assert(apply(f));f.client.Source..='\n-- later edit';ok,err=ownRollback()
check('rollback protects later edits',not ok and own() and f.client.Source:find('later edit',1,true)~=nil and not operation(),err)
f,older,oldInstall,bundle=v5();assert(apply(f));own().Entries['Client.NR2003Client'].Original.Source..='\n-- corrupt';ok,err=ownRollback()
check('corrupt V6 original backup refuses rollback',not ok and own() and allNew(f) and not operation(),err)
f,older,oldInstall,bundle=v5();assert(apply(f));failWrite=function(s) return s.Name=='NR2003CupGarage' and s:IsDescendantOf(f.pkg) end;ok,err=ownRollback()
check('failed rollback restores complete V6 state',not ok and own() and allNew(f) and not operation(),err)
f,older,oldInstall,bundle=v5();local yielded=false
writeHook=function(s) if not yielded and s.Name=='Original' then yielded=true;coroutine.yield('paused') end end
local worker=coroutine.create(function() return mockRequire(f.install.Apply)() end)
local resumed=coroutine.resume(worker);check('yielding backup holds shared lock',resumed and yielded and operation()~=nil)
local other=f.install:Clone();other.Parent=services.Workspace;ok,err=pcall(mockRequire(other.Apply))
check('concurrent V6 copies cannot race',not ok and operation()~=nil,err)
ok,err=pcall(mockRequire(older.Rollback));check('V5 rollback shares the operation lock',not ok and operation()~=nil,err)
writeHook=nil;resumed,ok,err=coroutine.resume(worker)
check('yielded update completes coherently',resumed and ok and allNew(f) and own() and not operation(),err)
print(string.format('road-course installer: %d passed, %d failed',passed,failed))
assert(failed==0,'Road-course update transaction tests failed')
