local passed, failed = 0, 0
local function check(name, ok, detail)
	if ok then passed += 1 else failed += 1 end
	print((ok and "PASS  " or "FAIL  ") .. name .. (detail and ("  " .. detail) or ""))
end
local failStage12 = false
do
	local inner = mockRequire
	mockRequire = function(m)
		if type(m) ~= "string" and failStage12 and m.Name == "Stage12SelfTest" then error("forced Stage 12 self-test failure (revert path)") end
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
-- published Stage 12 bench = Stage 5 bench (real Stage 5 presentation modules) + the ORIGINAL Stage 6/7 .. 12 patches
local function bench12()
	stage5()
	local rb = services.ReplicatedStorage.NR2003Lab.Roblox
	for name, src in pairs(STAGE5_SOURCES) do rawset(rb[name], "Source", src) end
	local all = true
	for _, p in ipairs({{PATCH67, "PATCH_STAGE6_7"}, {PATCH8, "PATCH_STAGE8"}, {PATCH9, "PATCH_STAGE9"}, {PATCH10, "PATCH_STAGE10"},
		{PATCH11, "PATCH_STAGE11"}, {PATCH12, "PATCH_STAGE12"}}) do
		cache = {}
		local ok, err = run(p[1], p[2])
		if not ok then all = false; print("    " .. p[2] .. ": " .. tostring(err):sub(1, 300)) end
	end
	-- the earlier patches' backups are not part of the Stage 12.1 checks
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
local CHANGED = {"ReplicatedStorage.NR2003Lab.Core.NR2003Cup.NR2003CupSteering", "ReplicatedStorage.NR2003Lab.Core.CupTune",
	"ReplicatedStorage.NR2003Lab.Roblox.CupChassisAdapter", "StarterPlayer.StarterPlayerScripts.NR2003Client",
	"ReplicatedStorage.NR2003Lab.Roblox.Stage12SelfTest"}
local BACKUP_KEY = {["NR2003Cup.NR2003CupSteering"] = CHANGED[1], ["Core.CupTune"] = CHANGED[2], ["Roblox.CupChassisAdapter"] = CHANGED[3],
	["Client.NR2003Client"] = CHANGED[4], ["Roblox.Stage12SelfTest"] = CHANGED[5]}
local changedSet = {}
for _, p in ipairs(CHANGED) do changedSet[p] = true end
local function sameAs(a, oa, b, ob)
	for p, s in pairs(b) do if a[p] ~= s or (oa and oa[p] ~= ob[p]) then return false end end
	for p in pairs(a) do if b[p] == nil then return false end end
	return true
end

-- 0) baseline
local t0 = os.clock()
check("baseline: Stage 5 bench + ORIGINAL PATCH_STAGE6_7, 8, 9, 10, 11, 12 (published Stage 12)", bench12(), string.format("%.1f s", os.clock() - t0))
local RS = services.ReplicatedStorage
check("baseline tagged NR2003Stage = 12, version 3.11.0-stage12", RS.NR2003Lab:GetAttribute("NR2003Stage") == "12"
	and RS.NR2003Lab:GetAttribute("NR2003Version") == "3.11.0-stage12")
local backup12 = services.ServerStorage:FindFirstChild("NR2003Backup_Stage12")
local S12, O12 = snapshot()

-- 1) refusals: nothing changes, no backup is created
RS.NR2003Lab:SetAttribute("NR2003Stage", "11")
cache = {}
local okA, errA = run(PATCH121, "PATCH_STAGE12_1")
RS.NR2003Lab:SetAttribute("NR2003Stage", "12")
check("refuses a bench that is not Stage 12 (NR2003Stage = 11): nothing changed, no backup", not okA
	and tostring(errA):find("Stage 12", 1, true) ~= nil and sameAs(snapshot(), nil, S12, nil)
	and services.ServerStorage:FindFirstChild("NR2003Backup_Stage12_1") == nil, tostring(errA):sub(1, 120))
local adapter = RS.NR2003Lab.Roblox.CupChassisAdapter
local adapterSrc = adapter.Source
rawset(adapter, "Source", adapterSrc .. "\n-- local edit")
cache = {}
local okB, errB = run(PATCH121, "PATCH_STAGE12_1")
local sB = snapshot()
local sameB = true
for p, s in pairs(S12) do if p ~= "ReplicatedStorage.NR2003Lab.Roblox.CupChassisAdapter" and sB[p] ~= s then sameB = false end end
check("refuses a locally modified Stage 12 module (CupChassisAdapter): nothing changed, no backup", not okB
	and tostring(errB):find("CupChassisAdapter", 1, true) ~= nil and sameB and services.ServerStorage:FindFirstChild("NR2003Backup_Stage12_1") == nil,
	tostring(errB):sub(1, 160))
rawset(adapter, "Source", adapterSrc)

-- 2) install
cache = {}
t0 = os.clock()
local ok, err = run(PATCH121, "PATCH_STAGE12_1")
check("PATCH_STAGE12_1 runs to completion on the Stage 12 bench (incl. self-tests 6/7, 8, 9, 10, 11, 12 + the 12.1 checks)", ok,
	ok and string.format("%.1f s", os.clock() - t0) or tostring(err):sub(1, 600))
local S121, O121 = snapshot()
local unexpected, idOk = {}, true
for p, s in pairs(S12) do
	if not changedSet[p] and S121[p] ~= s then table.insert(unexpected, p) end
	if O121[p] ~= O12[p] then idOk = false end
end
for p in pairs(S121) do if S12[p] == nil then table.insert(unexpected, "new " .. p) end end
check("only the 5 declared modules change; every other source (driver, vehicle, image, build, cockpit, server, Stage 6-11 self-tests) untouched",
	#unexpected == 0, #unexpected > 0 and table.concat(unexpected, ", ") or nil)
check("sources updated IN PLACE: every Stage 12 instance (folders and scripts) is the same object, nothing created or destroyed", idOk)
local newOk = true
for p, s in pairs(NEW121) do if S121[p] ~= s or S12[p] == s then newOk = false end end
check("declared modules now hold exactly the Stage 12.1 sources (steering, CupTune, adapter, client, Stage 12 self-test)", newOk)
local tune = RS.NR2003Lab.Core.CupTune.Source
check("bench defaults shipped: lock 360, setup ratio 12, axis momentum 0, cockpit wheel up to the lock",
	tune:find("steeringLockDegrees=360", 1, true) ~= nil and tune:find("setupSteeringRatio=12", 1, true) ~= nil
	and tune:find("momentumAxis=0", 1, true) ~= nil and tune:find('cockpitLimit="lock"', 1, true) ~= nil)
local backup = services.ServerStorage:FindFirstChild("NR2003Backup_Stage12_1")
local bOk, nBackup = backup ~= nil, 0
if backup then
	for _, c in ipairs(backup:GetChildren()) do
		nBackup += 1
		local p = BACKUP_KEY[c.Name]
		if p == nil or c:IsA("StringValue") or c.Source ~= S12[p] then bOk = false end
	end
end
check("backup ServerStorage.NR2003Backup_Stage12_1 holds ONLY the 5 changed scripts (published Stage 12 sources); Stage 12 backup untouched",
	bOk and nBackup == 5 and services.ServerStorage:FindFirstChild("NR2003Backup_Stage12") == backup12, string.format("%d copies", nBackup))
check("package tagged NR2003Stage = 12.1, version 3.11.1-stage12.1; the place was never saved",
	RS.NR2003Lab:GetAttribute("NR2003Stage") == "12.1" and RS.NR2003Lab:GetAttribute("NR2003Version") == "3.11.1-stage12.1" and savePlaceCalls == 0)
-- the full Stage 12 self-test (all embedded original snapshots + determinism + 12.1 checks) on the patched bench
cache = {}
local okF, rF = mockRequire(RS.NR2003Lab.Roblox.Stage12SelfTest).run(true)
check("Stage12SelfTest.run(true) on the 12.1 bench (all embedded original snapshots, determinism, 12.1 host options)", okF,
	not okF and table.concat(rF, "\n"):sub(1, 400) or nil)

-- 3) re-run: idempotent, the first backup is kept
cache = {}
local okR, errR = run(PATCH121, "PATCH_STAGE12_1")
local SR, OR = snapshot()
check("re-running PATCH_STAGE12_1 on the 12.1 bench: success, nothing duplicated or changed, first backup kept",
	okR and sameAs(SR, OR, S121, O121) and services.ServerStorage:FindFirstChild("NR2003Backup_Stage12_1") == backup,
	not okR and tostring(errR):sub(1, 200) or nil)

-- 4) the Stage 12 rollback refuses a 12.1 bench (12.1 must be rolled back first)
cache = {}
local okX, errX = run(ROLLBACK12, "PATCH_STAGE12_ROLLBACK")
check("PATCH_STAGE12_ROLLBACK refuses the 12.1 bench (roll back 12.1 first): nothing changed",
	not okX and sameAs(snapshot(), nil, S121, nil) and RS.NR2003Lab:GetAttribute("NR2003Stage") == "12.1", tostring(errX):sub(1, 120))

-- 5) rollback script: back to the exact published Stage 12 sources (verified), backup kept
cache = {}
local okRb, errRb = run(ROLLBACK121, "PATCH_STAGE12_1_ROLLBACK")
local SB, OB = snapshot()
check("PATCH_STAGE12_1_ROLLBACK restores every Stage 12 source in place, tags Stage 12 again, passes the Stage 12 self-test",
	okRb and sameAs(SB, OB, S12, O12) and RS.NR2003Lab:GetAttribute("NR2003Stage") == "12"
	and RS.NR2003Lab:GetAttribute("NR2003Version") == "3.11.0-stage12" and services.ServerStorage:FindFirstChild("NR2003Backup_Stage12_1") ~= nil,
	not okRb and tostring(errRb):sub(1, 300) or nil)
services.ServerStorage.NR2003Backup_Stage12_1:Destroy()

-- 6) forced failure of the Stage 12 self-test: automatic revert, no backup left behind
cache = {}
failStage12 = true
local ok6, err6 = run(PATCH121, "PATCH_STAGE12_1")
failStage12 = false
local S6, O6 = snapshot()
check("forced Stage 12 self-test failure: error reported, every source back to Stage 12, no backup left",
	not ok6 and tostring(err6):find("revertido", 1, true) ~= nil and sameAs(S6, O6, S12, O12) and RS.NR2003Lab:GetAttribute("NR2003Stage") == "12"
	and services.ServerStorage:FindFirstChild("NR2003Backup_Stage12_1") == nil, tostring(err6):sub(1, 160))

-- 7) split install (Command Bar parts + INSTALL) = same result as the single patch
cache = {}
local okEarly, errEarly = run(INSTALL121, "PATCH_STAGE12_1_INSTALL")
check("split: INSTALL before the parts refuses (nothing changed)", not okEarly and tostring(errEarly):find("PART", 1, true) ~= nil
	and RS.NR2003Lab:GetAttribute("NR2003Stage") == "12", tostring(errEarly):sub(1, 120))
local partsOk = true
for k, src in ipairs(PARTS121) do
	cache = {}
	local okP, errP = run(src, "PATCH_STAGE12_1_PART" .. k)
	if not okP then partsOk = false; print("    part " .. k .. ": " .. tostring(errP):sub(1, 200)) end
end
check("split: parts 1.." .. #PARTS121 .. " only stage sources (bench untouched)", partsOk
	and services.ServerStorage:FindFirstChild("NR2003Stage12_1Staging") ~= nil and sameAs(snapshot(), nil, S12, nil))
cache = {}
local okI, errI = run(INSTALL121, "PATCH_STAGE12_1_INSTALL")
local SI, OI = snapshot()
check("split: INSTALL gives exactly the PATCH_STAGE12_1 result (self-tests included), staging removed",
	okI and sameAs(SI, OI, S121, O121) and services.ServerStorage:FindFirstChild("NR2003Stage12_1Staging") == nil
	and RS.NR2003Lab:GetAttribute("NR2003Stage") == "12.1", not okI and tostring(errI):sub(1, 300) or nil)
check("the place was never saved by any patch / rollback run", savePlaceCalls == 0)
print(string.format("\npatch12_1 mock: %d passed, %d failed", passed, failed))
if failed > 0 then error("patch12_1 mock tests failed") end
