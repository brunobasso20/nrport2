local passed=0
local function check(name,ok) assert(ok,name);passed+=1;print("PASS "..name) end
local f=fixture();local client,server=f.client.Source,f.server.Source
check("actual audio installer executes",f.install())
check("client/server local edits are preserved",f.client.Source:find("USER_CLIENT_CODE",1,true) and f.server.Source:find("USER_SERVER_CODE",1,true))
check("original core, adapter, surfaces and track selection remain untouched",f.adapter.Source==BASE_ADAPTER.."\n-- LOCAL_PREDICTION_SENTINEL\n"
    and f.package:GetAttribute("NR2003Track")=="watkins_glen" and f.watkins.Source=="-- Watkins remains unchanged")
check("all installed modules are actual source files",f.package.Audio.NR2003AudioState.Source==SOURCES.NR2003AudioState)
f.state.writes=0;check("second installation is idempotent",f.install() and f.state.writes==0)
local linked=f.new("ModuleScript","AudioAssets",f.package,"-- private binding survives rollback")
f.journal().rollback()
check("rollback restores exact previous client/server sources",f.client.Source==client and f.server.Source==server)
check("rollback removes audio code and retains separately imported bindings",not f.package:FindFirstChild("Audio") and linked.Parent==f.package)
f=fixture();f.client.Source="-- unexpected client";f.state.writes=0
check("unsupported scripts fail preflight before any mutation",not pcall(f.install) and f.state.writes==0 and not f.package:FindFirstChild("Audio"))
f=fixture();client,server=f.client.Source,f.server.Source;f.state.failName="NR2003Client";f.state.failRemaining=1
check("injected Source failure rolls the whole installation back",not pcall(f.install) and f.client.Source==client and f.server.Source==server
    and not f.package:FindFirstChild("Audio") and not f.storage:FindFirstChild("NR2003Backup_Audio"))
f=fixture();f.state.journalBytes=512013
check("large backup journal uses safe chunks",f.install() and f.state.maxStringValueBytes<200000)
f.journal().rollback();check("chunked backup can roll back",not f.package:FindFirstChild("Audio"))
f=fixture();client,server=f.client.Source,f.server.Source
f.state.journalBytes=512013;f.state.failValueName="Part00002";f.state.failRemaining=1
check("backup chunk failure restores all scripts",not pcall(f.install) and f.client.Source==client and f.server.Source==server
    and not f.package:FindFirstChild("Audio") and not f.storage:FindFirstChild("NR2003Backup_Audio"))
f=fixture();f.install();f.client.Source..="\n-- later user edit";f.state.writes=0
check("rollback protects edits made after installation",not pcall(f.journal().rollback) and f.state.writes==0 and f.package:FindFirstChild("Audio"))
f=fixture();f.state.running=true;f.state.writes=0
check("installation never runs during Play",not pcall(f.install) and f.state.writes==0)
print(string.format("audio Studio installer/rollback mock: %d passed, 0 failed",passed))
