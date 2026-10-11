local passed, failed = 0, 0
local function check(name, ok, detail)
	if ok then passed += 1 else failed += 1 end
	print((ok and "PASS  " or "FAIL  ") .. name .. (detail and ("  " .. detail) or ""))
end
local failStage13 = false
do
	local inner = mockRequire
	mockRequire = function(m)
		if type(m) ~= "string" and failStage13 and m.Name == "Stage13SelfTest" then error("forced Stage 13 self-test failure (revert path)") end
		return inner(m)
	end
end
local savePlaceCalls = 0
game.SavePlace = function() savePlaceCalls += 1 end
local function run(source, name)
	local f = assert(loadstring(source, name))
	setfenv(f, setmetatable({game = game, workspace = services.Workspace, Instance = Instance, require = mockRequire}, {__index = _G}))
	return pcall(f)
end
-- published Stage 12.1 bench = Stage 5 bench (real Stage 5 presentation modules) + the ORIGINAL Stage 6/7 .. 12.1 patches
local function bench121()
	stage5()
	local rb = services.ReplicatedStorage.NR2003Lab.Roblox
	for name, src in pairs(STAGE5_SOURCES) do rawset(rb[name], "Source", src) end
	local all = true
	for _, p in ipairs({{PATCH67, "PATCH_STAGE6_7"}, {PATCH8, "PATCH_STAGE8"}, {PATCH9, "PATCH_STAGE9"}, {PATCH10, "PATCH_STAGE10"},
		{PATCH11, "PATCH_STAGE11"}, {PATCH12, "PATCH_STAGE12"}, {PATCH121, "PATCH_STAGE12_1"}}) do
		cache = {}
		local ok, err = run(p[1], p[2])
		if not ok then all = false; print("    " .. p[2] .. ": " .. tostring(err):sub(1, 300)) end
	end
	-- the earlier patches' backups are not part of the Stage 13 checks
	for _, c in ipairs(services.ServerStorage:GetChildren()) do
		if c.Name:find("NR2003Backup_Stage11_", 1, true) then c:Destroy() end
	end
	return all
end
-- every script source of the bench (path -> source) and every instance (path -> object)
local function snapshot()
	local src, obj = {}, {}
	local function walk(o, path)
		for _, c in ipairs(o:GetChildren()) do
			local p = path .. "." .. c.Name
			obj[p] = c
			if rawget(c, "Source") ~= nil then src[p] = c.Source end
			walk(c, p)
		end
	end
	for _, n in ipairs({"ReplicatedStorage", "ServerScriptService", "StarterPlayer", "Workspace"}) do walk(services[n], n) end
	return src, obj
end
local CHANGED = {"ReplicatedStorage.NR2003Lab.Core.NR2003Cup.NR2003CupDriver", "ReplicatedStorage.NR2003Lab.Core.NR2003Cup.NR2003CupFrame",
	"ReplicatedStorage.NR2003Lab.Core.NR2003CupVehicle", "ReplicatedStorage.NR2003Lab.Core.CupTune",
	"ReplicatedStorage.NR2003Lab.Roblox.CupChassisAdapter", "StarterPlayer.StarterPlayerScripts.NR2003Client"}
local ADDED = {"ReplicatedStorage.NR2003Lab.Core.NR2003Cup.NR2003CupFFB", "ReplicatedStorage.NR2003Lab.Roblox.Stage13SelfTest"}
local BACKUP_KEY = {["NR2003Cup.NR2003CupDriver"] = CHANGED[1], ["NR2003Cup.NR2003CupFrame"] = CHANGED[2],
	["Core.NR2003CupVehicle"] = CHANGED[3], ["Core.CupTune"] = CHANGED[4], ["Roblox.CupChassisAdapter"] = CHANGED[5],
	["Client.NR2003Client"] = CHANGED[6]}
local ADDED_KEY = {["ADDED:NR2003Cup.NR2003CupFFB"] = true, ["ADDED:Roblox.Stage13SelfTest"] = true}
local changedSet, addedSet = {}, {}
for _, p in ipairs(CHANGED) do changedSet[p] = true end
for _, p in ipairs(ADDED) do addedSet[p] = true end
local function sameAs(a, oa, b, ob)
	for p, s in pairs(b) do if a[p] ~= s or (oa and oa[p] ~= ob[p]) then return false end end
	for p in pairs(a) do if b[p] == nil then return false end end
	return true
end

-- 0) baseline
local t0 = os.clock()
check("baseline: Stage 5 bench + ORIGINAL PATCH_STAGE6_7, 8, 9, 10, 11, 12, 12_1 (published Stage 12.1)", bench121(), string.format("%.1f s", os.clock() - t0))
local RS = services.ReplicatedStorage
check("baseline tagged NR2003Stage = 12.1, version 3.11.1-stage12.1", RS.NR2003Lab:GetAttribute("NR2003Stage") == "12.1"
	and RS.NR2003Lab:GetAttribute("NR2003Version") == "3.11.1-stage12.1")
local backup121 = services.ServerStorage:FindFirstChild("NR2003Backup_Stage12_1")
local S12, O12 = snapshot()

-- 1) refusals: nothing changes, no backup is created
RS.NR2003Lab:SetAttribute("NR2003Stage", "12")
cache = {}
local okA, errA = run(PATCH13, "PATCH_STAGE13")
RS.NR2003Lab:SetAttribute("NR2003Stage", "12.1")
check("refuses a bench that is not Stage 12.1 (NR2003Stage = 12): nothing changed, no backup", not okA
	and tostring(errA):find("Stage 12.1", 1, true) ~= nil and sameAs(snapshot(), nil, S12, nil)
	and services.ServerStorage:FindFirstChild("NR2003Backup_Stage13") == nil, tostring(errA):sub(1, 120))
local adapter = RS.NR2003Lab.Roblox.CupChassisAdapter
local adapterSrc = adapter.Source
rawset(adapter, "Source", adapterSrc .. "\n-- local edit")
cache = {}
local okB, errB = run(PATCH13, "PATCH_STAGE13")
local sB = snapshot()
local sameB = true
for p, s in pairs(S12) do if p ~= "ReplicatedStorage.NR2003Lab.Roblox.CupChassisAdapter" and sB[p] ~= s then sameB = false end end
check("refuses a locally modified Stage 12.1 module (CupChassisAdapter): nothing changed, no backup", not okB
	and tostring(errB):find("CupChassisAdapter", 1, true) ~= nil and sameB and services.ServerStorage:FindFirstChild("NR2003Backup_Stage13") == nil,
	tostring(errB):sub(1, 160))
rawset(adapter, "Source", adapterSrc)

-- 2) install
cache = {}
t0 = os.clock()
local ok, err = run(PATCH13, "PATCH_STAGE13")
check("PATCH_STAGE13 runs to completion on the Stage 12.1 bench (incl. self-tests 6/7, 8, 9, 10, 11, 12, 13)", ok,
	ok and string.format("%.1f s", os.clock() - t0) or tostring(err):sub(1, 600))
local S121, O121 = snapshot()
local unexpected, idOk = {}, true
for p, s in pairs(S12) do
	if not changedSet[p] and S121[p] ~= s then table.insert(unexpected, p) end
	if O121[p] ~= O12[p] then idOk = false end
end
for p in pairs(S121) do if S12[p] == nil and not addedSet[p] then table.insert(unexpected, "new " .. p) end end
local addedOk = true
for _, p in ipairs(ADDED) do if S121[p] == nil or S12[p] ~= nil then addedOk = false end end
check("only the 6 declared modules change and the 2 new modules appear; every other source (image, build, steering, cockpit, server, Stage 6-12 self-tests) untouched",
	#unexpected == 0 and addedOk, #unexpected > 0 and table.concat(unexpected, ", ") or nil)
check("sources updated IN PLACE: every Stage 12.1 instance (folders and scripts) is the same object, nothing destroyed", idOk)
local newOk = true
for p, s in pairs(NEW13) do if S121[p] ~= s or S12[p] == s then newOk = false end end
check("declared modules now hold exactly the Stage 13 sources (driver, frame, vehicle, CupTune, adapter, client, FFB, Stage 13 self-test)", newOk)
local ffbMod = RS.NR2003Lab.Core.NR2003Cup:FindFirstChild("NR2003CupFFB")
check("NR2003CupFFB is a ModuleScript in Core.NR2003Cup; Stage13SelfTest a ModuleScript in Roblox",
	ffbMod ~= nil and ffbMod.ClassName == "ModuleScript" and RS.NR2003Lab.Roblox:FindFirstChild("Stage13SelfTest") ~= nil
	and RS.NR2003Lab.Roblox.Stage13SelfTest.ClassName == "ModuleScript")
local tune = RS.NR2003Lab.Core.CupTune.Source
check("bench defaults shipped: FFB on (image strength / damping / latency), FF output present; Stage 12.1 defaults kept",
	tune:find("ffbEnabled=true", 1, true) ~= nil and tune:find("ffbDevice=true", 1, true) ~= nil
	and tune:find("steeringLockDegrees=360", 1, true) ~= nil and tune:find("setupSteeringRatio=12", 1, true) ~= nil)
local backup = services.ServerStorage:FindFirstChild("NR2003Backup_Stage13")
local bOk, nBackup, nAdded = backup ~= nil, 0, 0
if backup then
	for _, c in ipairs(backup:GetChildren()) do
		if ADDED_KEY[c.Name] then
			nAdded += 1
			if not c:IsA("StringValue") then bOk = false end
		else
			nBackup += 1
			local p = BACKUP_KEY[c.Name]
			if p == nil or c:IsA("StringValue") or c.Source ~= S12[p] then bOk = false end
		end
	end
end
check("backup ServerStorage.NR2003Backup_Stage13 holds ONLY the 6 changed scripts (published Stage 12.1 sources) + 2 ADDED markers; 12.1 backup untouched",
	bOk and nBackup == 6 and nAdded == 2 and services.ServerStorage:FindFirstChild("NR2003Backup_Stage12_1") == backup121, string.format("%d copies, %d markers", nBackup, nAdded))
check("package tagged NR2003Stage = 13, version 3.12.0-stage13; the place was never saved",
	RS.NR2003Lab:GetAttribute("NR2003Stage") == "13" and RS.NR2003Lab:GetAttribute("NR2003Version") == "3.12.0-stage13" and savePlaceCalls == 0)
-- the full Stage 13 self-test (+ determinism) and the full Stage 12 self-test on the patched bench
cache = {}
local okF, rF = mockRequire(RS.NR2003Lab.Roblox.Stage13SelfTest).run(true)
check("Stage13SelfTest.run(true) on the Stage 13 bench (original vectors, traced closed-loop calls, behaviour, determinism)", okF,
	not okF and table.concat(rF, "\n"):sub(1, 400) or nil)
cache = {}
local okG, rG = mockRequire(RS.NR2003Lab.Roblox.Stage12SelfTest).run(true)
check("Stage12SelfTest.run(true) on the Stage 13 bench (the Stage 12 steering chain unchanged)", okG,
	not okG and table.concat(rG, "\n"):sub(1, 400) or nil)

-- 3) re-run: idempotent, the first backup is kept
cache = {}
local okR, errR = run(PATCH13, "PATCH_STAGE13")
local SR, OR = snapshot()
check("re-running PATCH_STAGE13 on the Stage 13 bench: success, nothing duplicated or changed, first backup kept",
	okR and sameAs(SR, OR, S121, O121) and services.ServerStorage:FindFirstChild("NR2003Backup_Stage13") == backup,
	not okR and tostring(errR):sub(1, 200) or nil)

-- 4) the Stage 12.1 rollback refuses a Stage 13 bench (13 must be rolled back first)
cache = {}
local okX, errX = run(ROLLBACK121, "PATCH_STAGE12_1_ROLLBACK")
check("PATCH_STAGE12_1_ROLLBACK refuses the Stage 13 bench (roll back 13 first): nothing changed",
	not okX and sameAs(snapshot(), nil, S121, nil) and RS.NR2003Lab:GetAttribute("NR2003Stage") == "13", tostring(errX):sub(1, 120))

-- 5) rollback script: back to the exact published Stage 12 sources (verified), backup kept
cache = {}
local okRb, errRb = run(ROLLBACK13, "PATCH_STAGE13_ROLLBACK")
local SB, OB = snapshot()
check("PATCH_STAGE13_ROLLBACK restores every Stage 12.1 source in place, removes the 2 Stage 13 modules, tags Stage 12.1 again, passes the Stage 12 self-test",
	okRb and sameAs(SB, OB, S12, O12) and RS.NR2003Lab:GetAttribute("NR2003Stage") == "12.1"
	and RS.NR2003Lab:GetAttribute("NR2003Version") == "3.11.1-stage12.1" and services.ServerStorage:FindFirstChild("NR2003Backup_Stage13") ~= nil
	and RS.NR2003Lab.Core.NR2003Cup:FindFirstChild("NR2003CupFFB") == nil and RS.NR2003Lab.Roblox:FindFirstChild("Stage13SelfTest") == nil,
	not okRb and tostring(errRb):sub(1, 300) or nil)
services.ServerStorage.NR2003Backup_Stage13:Destroy()

-- 6) forced failure of the Stage 12 self-test: automatic revert, no backup left behind
cache = {}
failStage13 = true
local ok6, err6 = run(PATCH13, "PATCH_STAGE13")
failStage13 = false
local S6, O6 = snapshot()
check("forced Stage 13 self-test failure: error reported, every source back to Stage 12.1, the new modules removed, no backup left",
	not ok6 and tostring(err6):find("revertido", 1, true) ~= nil and sameAs(S6, O6, S12, O12) and RS.NR2003Lab:GetAttribute("NR2003Stage") == "12.1"
	and services.ServerStorage:FindFirstChild("NR2003Backup_Stage13") == nil, tostring(err6):sub(1, 160))

-- 7) split install (Command Bar parts + INSTALL) = same result as the single patch
cache = {}
local okEarly, errEarly = run(INSTALL13, "PATCH_STAGE13_INSTALL")
check("split: INSTALL before the parts refuses (nothing changed)", not okEarly and tostring(errEarly):find("PART", 1, true) ~= nil
	and RS.NR2003Lab:GetAttribute("NR2003Stage") == "12.1", tostring(errEarly):sub(1, 120))
local partsOk = true
for k, src in ipairs(PARTS13) do
	cache = {}
	local okP, errP = run(src, "PATCH_STAGE13_PART" .. k)
	if not okP then partsOk = false; print("    part " .. k .. ": " .. tostring(errP):sub(1, 200)) end
end
check("split: parts 1.." .. #PARTS13 .. " only stage sources (bench untouched)", partsOk
	and services.ServerStorage:FindFirstChild("NR2003Stage13Staging") ~= nil and sameAs(snapshot(), nil, S12, nil))
cache = {}
local okI, errI = run(INSTALL13, "PATCH_STAGE13_INSTALL")
local SI = snapshot()
check("split: INSTALL gives exactly the PATCH_STAGE13 sources (self-tests included), staging removed",
	okI and sameAs(SI, nil, S121, nil) and services.ServerStorage:FindFirstChild("NR2003Stage13Staging") == nil
	and RS.NR2003Lab:GetAttribute("NR2003Stage") == "13", not okI and tostring(errI):sub(1, 300) or nil)
check("the place was never saved by any patch / rollback run", savePlaceCalls == 0)
print(string.format("\npatch13 mock: %d passed, %d failed", passed, failed))
if failed > 0 then error("patch13 mock tests failed") end
