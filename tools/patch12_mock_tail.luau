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
-- Stage 11 bench = Stage 5 bench (real Stage 5 presentation modules) + the ORIGINAL Stage 6/7 .. 11 patches
local function bench11()
	stage5()
	local rb = services.ReplicatedStorage.NR2003Lab.Roblox
	for name, src in pairs(STAGE5_SOURCES) do rawset(rb[name], "Source", src) end
	local all = true
	for _, p in ipairs({{PATCH67, "PATCH_STAGE6_7"}, {PATCH8, "PATCH_STAGE8"}, {PATCH9, "PATCH_STAGE9"}, {PATCH10, "PATCH_STAGE10"}, {PATCH11, "PATCH_STAGE11"}}) do
		cache = {}
		local ok, err = run(p[1], p[2])
		if not ok then all = false; print("    " .. p[2] .. ": " .. tostring(err):sub(1, 300)) end
	end
	-- the Stage 11 patch keeps one full backup per install: not part of the Stage 12 checks
	for _, c in ipairs(services.ServerStorage:GetChildren()) do if c.Name:find("NR2003Backup_Stage11_", 1, true) then c:Destroy() end end
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
local CHANGED = {"ReplicatedStorage.NR2003Lab.Core.NR2003Cup.NR2003CupDriver", "ReplicatedStorage.NR2003Lab.Core.NR2003CupVehicle",
	"ReplicatedStorage.NR2003Lab.Roblox.CupChassisAdapter", "ReplicatedStorage.NR2003Lab.Roblox.Cockpit",
	"ReplicatedStorage.NR2003Lab.Roblox.RenderSnapshot", "ReplicatedStorage.NR2003Lab.Roblox.RenderPresentation",
	"ServerScriptService.NR2003Server", "StarterPlayer.StarterPlayerScripts.NR2003Client"}
local EDITED = {"Stage67SelfTest", "Stage8SelfTest", "Stage9SelfTest", "Stage10SelfTest", "Stage11SelfTest"}
local ADDED = {"ReplicatedStorage.NR2003Lab.Core.NR2003Cup.NR2003CupSteering", "ReplicatedStorage.NR2003Lab.Roblox.Stage12SelfTest"}

-- 0) baseline
local t0 = os.clock()
check("baseline: Stage 5 bench + ORIGINAL PATCH_STAGE6_7, 8, 9, 10, 11", bench11(), string.format("%.1f s", os.clock() - t0))
local RS = services.ReplicatedStorage
check("baseline tagged NR2003Stage = 11", RS.NR2003Lab:GetAttribute("NR2003Stage") == "11")
local S11, O11 = snapshot()

-- 1) refusals: nothing changes, no backup is created
RS.NR2003Lab:SetAttribute("NR2003Stage", "10")
cache = {}
local okA, errA = run(PATCH12, "PATCH_STAGE12")
RS.NR2003Lab:SetAttribute("NR2003Stage", "11")
local sA = snapshot()
local sameA = true
for p, s in pairs(S11) do if sA[p] ~= s then sameA = false end end
check("refuses a bench that is not Stage 11 (NR2003Stage = 10): nothing changed, no backup", not okA and tostring(errA):find("Stage 11", 1, true) ~= nil
	and sameA and services.ServerStorage:FindFirstChild("NR2003Backup_Stage12") == nil, tostring(errA):sub(1, 120))
local adapter = RS.NR2003Lab.Roblox.CupChassisAdapter
local adapterSrc = adapter.Source
rawset(adapter, "Source", adapterSrc .. "\n-- local edit")
cache = {}
local okB, errB = run(PATCH12, "PATCH_STAGE12")
local sB = snapshot()
local sameB = true
for p, s in pairs(S11) do if p ~= "ReplicatedStorage.NR2003Lab.Roblox.CupChassisAdapter" and sB[p] ~= s then sameB = false end end
check("refuses a locally modified Stage 11 module (CupChassisAdapter): nothing changed, no backup", not okB
	and tostring(errB):find("CupChassisAdapter", 1, true) ~= nil and sameB and services.ServerStorage:FindFirstChild("NR2003Backup_Stage12") == nil,
	tostring(errB):sub(1, 160))
rawset(adapter, "Source", adapterSrc)

-- 2) install
cache = {}
t0 = os.clock()
local ok, err = run(PATCH12, "PATCH_STAGE12")
check("PATCH_STAGE12 runs to completion on the Stage 11 bench (incl. self-tests 6/7, 8, 9, 10, 11, 12)", ok,
	ok and string.format("%.1f s", os.clock() - t0) or tostring(err):sub(1, 500))
local S12, O12 = snapshot()
local same, idOk = true, true
local changedSet, addedSet = {}, {}
for _, p in ipairs(CHANGED) do changedSet[p] = true end
for _, n in ipairs(EDITED) do changedSet["ReplicatedStorage.NR2003Lab.Roblox." .. n] = true end
for _, p in ipairs(ADDED) do addedSet[p] = true end
local unexpected = {}
for p, s in pairs(S11) do
	if not changedSet[p] and S12[p] ~= s then table.insert(unexpected, p) end
	if O12[p] ~= O11[p] then idOk = false end                -- no instance replaced: every Stage 11 object still there
end
for p in pairs(S12) do if S11[p] == nil and not addedSet[p] then table.insert(unexpected, "new " .. p) end end
check("only the declared modules change; every other source (image, JIT, build, frame, aero, ModeConfig, VisualRig, car) untouched",
	#unexpected == 0, #unexpected > 0 and table.concat(unexpected, ", ") or nil)
check("sources updated IN PLACE: every Stage 11 instance (folders and scripts) is the same object after the patch", idOk)
local changedOk = true
for p in pairs(changedSet) do if S12[p] == S11[p] then changedOk = false end end
check("declared modules changed (driver, vehicle, adapter, cockpit, snapshot codec, presentation, server, client, 5 self-tests)", changedOk)
check("new modules NR2003CupSteering and Stage12SelfTest installed",
	RS.NR2003Lab.Core.NR2003Cup:FindFirstChild("NR2003CupSteering") ~= nil and RS.NR2003Lab.Roblox:FindFirstChild("Stage12SelfTest") ~= nil)
local lineOk = true
for _, n in ipairs(EDITED) do
	local s = RS.NR2003Lab.Roblox[n].Source
	if not s:find('V.setSteeringMode("provisional")', 1, true) or #s ~= EXPECTED_EDIT_LEN[n] then lineOk = false end
end
check("Stage 6/7..11 self-tests: exactly one anchored line added (steering mode 'provisional')", lineOk)
local backup = services.ServerStorage:FindFirstChild("NR2003Backup_Stage12")
local bOk = backup ~= nil
local nBackup, nAdded = 0, 0
if backup then
	for _, c in ipairs(backup:GetChildren()) do
		if c:IsA("StringValue") then nAdded += 1 else
			nBackup += 1
			local folder, name = c.Name:match("^([^.]+)%.(.+)$")
			local p
			for _, q in ipairs(CHANGED) do if q:sub(-#name - 1) == "." .. name then p = q end end
			p = p or ("ReplicatedStorage.NR2003Lab.Roblox." .. name)
			if c.Source ~= S11[p] then bOk = false end
		end
	end
end
check("backup ServerStorage.NR2003Backup_Stage12 holds ONLY the 13 changed scripts (Stage 11 sources) + 2 'added' markers",
	bOk and nBackup == 13 and nAdded == 2, string.format("%d copies, %d markers", nBackup, nAdded))
check("package tagged NR2003Stage = 12, version 3.11.0-stage12; the place was never saved",
	RS.NR2003Lab:GetAttribute("NR2003Stage") == "12" and RS.NR2003Lab:GetAttribute("NR2003Version") == "3.11.0-stage12" and savePlaceCalls == 0)

-- 3) re-run: idempotent, the first backup is kept
cache = {}
local okR, errR = run(PATCH12, "PATCH_STAGE12")
local SR, OR = snapshot()
local sameR, dup = true, false
for p, s in pairs(S12) do if SR[p] ~= s or OR[p] ~= O12[p] then sameR = false end end
for p in pairs(SR) do if S12[p] == nil then sameR = false end end
local count = {}
for _, c in ipairs(RS.NR2003Lab.Core.NR2003Cup:GetChildren()) do count[c.Name] = (count[c.Name] or 0) + 1 end
for _, v in pairs(count) do if v > 1 then dup = true end end
check("re-running PATCH_STAGE12 on the Stage 12 bench: success, nothing duplicated or changed, first backup kept",
	okR and sameR and not dup and services.ServerStorage:FindFirstChild("NR2003Backup_Stage12") == backup, okR and nil or tostring(errR):sub(1, 200))

-- 4) rollback script: back to the exact Stage 11 sources (verified), added modules removed, backup kept
cache = {}
local okRb, errRb = run(ROLLBACK12, "PATCH_STAGE12_ROLLBACK")
local SB, OB = snapshot()
local sameRb = true
for p, s in pairs(S11) do if SB[p] ~= s or OB[p] ~= O11[p] then sameRb = false end end
for p in pairs(SB) do if S11[p] == nil then sameRb = false end end
check("PATCH_STAGE12_ROLLBACK restores every Stage 11 source in place, removes the added modules, passes the Stage 11 self-test",
	okRb and sameRb and RS.NR2003Lab:GetAttribute("NR2003Stage") == "11" and services.ServerStorage:FindFirstChild("NR2003Backup_Stage12") ~= nil,
	okRb and nil or tostring(errRb):sub(1, 300))
services.ServerStorage.NR2003Backup_Stage12:Destroy()

-- 5) forced failure of the Stage 12 self-test: automatic revert, no backup left behind
cache = {}
failStage12 = true
local ok5, err5 = run(PATCH12, "PATCH_STAGE12")
failStage12 = false
local S5, O5 = snapshot()
local same5 = true
for p, s in pairs(S11) do if S5[p] ~= s or O5[p] ~= O11[p] then same5 = false end end
for p in pairs(S5) do if S11[p] == nil then same5 = false end end
check("forced Stage 12 self-test failure: error reported, every source back to Stage 11, added modules removed, no backup left",
	not ok5 and tostring(err5):find("revertido", 1, true) ~= nil and same5 and RS.NR2003Lab:GetAttribute("NR2003Stage") == "11"
	and services.ServerStorage:FindFirstChild("NR2003Backup_Stage12") == nil, tostring(err5):sub(1, 160))

-- 6) split install (Command Bar parts + INSTALL) = same result as the single patch
cache = {}
local okEarly, errEarly = run(INSTALL12, "PATCH_STAGE12_INSTALL")
check("split: INSTALL before the parts refuses (nothing changed)", not okEarly and tostring(errEarly):find("PART", 1, true) ~= nil
	and RS.NR2003Lab:GetAttribute("NR2003Stage") == "11", tostring(errEarly):sub(1, 120))
local partsOk = true
for k, src in ipairs(PARTS12) do
	cache = {}
	local okP, errP = run(src, "PATCH_STAGE12_PART" .. k)
	if not okP then partsOk = false; print("    part " .. k .. ": " .. tostring(errP):sub(1, 200)) end
end
check("split: parts 1.." .. #PARTS12 .. " only stage sources (bench untouched)", partsOk
	and services.ServerStorage:FindFirstChild("NR2003Stage12Staging") ~= nil and RS.NR2003Lab.Core.NR2003Cup:FindFirstChild("NR2003CupSteering") == nil)
cache = {}
local okI, errI = run(INSTALL12, "PATCH_STAGE12_INSTALL")
local SI = snapshot()
local sameI = okI
for p, s in pairs(S12) do if SI[p] ~= s then sameI = false end end
for p in pairs(SI) do if S12[p] == nil then sameI = false end end
check("split: INSTALL gives exactly the PATCH_STAGE12 result (self-tests included), staging removed", sameI
	and services.ServerStorage:FindFirstChild("NR2003Stage12Staging") == nil and RS.NR2003Lab:GetAttribute("NR2003Stage") == "12",
	okI and nil or tostring(errI):sub(1, 300))
check("the place was never saved by any patch / rollback run", savePlaceCalls == 0)
print(string.format("\npatch12 mock: %d passed, %d failed", passed, failed))
if failed > 0 then error("patch12 mock tests failed") end
