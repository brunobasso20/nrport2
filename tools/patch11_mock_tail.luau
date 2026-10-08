local passed, failed = 0, 0
local function check(name, ok, detail)
	if ok then passed += 1 else failed += 1 end
	print((ok and "PASS  " or "FAIL  ") .. name .. (detail and ("  " .. detail) or ""))
end
local failStage11 = false
do
	local inner = mockRequire
	mockRequire = function(m)
		if type(m) ~= "string" and failStage11 and m.Name == "Stage11SelfTest" then error("forced Stage 11 self-test failure (revert path)") end
		return inner(m)
	end
end
local function run(source, name)
	local f = assert(loadstring(source, name))
	setfenv(f, setmetatable({game = game, workspace = services.Workspace, Instance = Instance, require = mockRequire}, {__index = _G}))
	return pcall(f)
end
local function bench10()
	stage5()
	local all = true
	for _, p in ipairs({{PATCH67, "PATCH_STAGE6_7"}, {PATCH8, "PATCH_STAGE8"}, {PATCH9, "PATCH_STAGE9"}, {PATCH10, "PATCH_STAGE10"}}) do
		cache = {}
		local ok, err = run(p[1], p[2])
		if not ok then all = false; print("    " .. p[2] .. ": " .. tostring(err):sub(1, 300)) end
	end
	return all
end

-- 0) Stage 5 bench + the ORIGINAL Stage 6/7, 8, 9 and 10 patches (validated baseline)
local t0 = os.clock()
check("baseline: PATCH_STAGE6_7, 8, 9, 10 install on the Stage 5 bench", bench10(), string.format("%.1f s", os.clock() - t0))
local RS = services.ReplicatedStorage
local pkg = RS:FindFirstChild("NR2003Lab")
local cup = pkg.Core.NR2003Cup
local keep = {"NR2003CupImage1", "NR2003CupImage2", "NR2003CupJIT1", "NR2003CupJIT2", "NR2003CupAero", "NR2003CupCore",
	"NR2003CupSetup", "NR2003CupSetupData", "NR2003CupBuild", "NR2003CupBuildCode1", "NR2003CupBuildData1", "NR2003CupJITG1", "NR2003CupGarage"}
local before = {}
for _, n in ipairs(keep) do before[n] = cup[n].Source end
local serverBefore, clientBefore = services.ServerScriptService.NR2003Server.Source, SP.NR2003Client.Source

-- 1) Stage 11 install
cache = {}
t0 = os.clock()
local ok, err = run(PATCH11, "PATCH_STAGE11")
check("PATCH_STAGE11 runs to completion on the Stage 10 bench (incl. Stage 6/7 + 8 + 9 + 10 + 11 self-tests)", ok, ok and string.format("%.1f s", os.clock() - t0) or tostring(err):sub(1, 400))
pkg = RS:FindFirstChild("NR2003Lab")
cup = pkg.Core.NR2003Cup
local same = true
for n, src in pairs(before) do if cup[n].Source ~= src then same = false end end
check("Stage 6/7 image + callbacks + core, Stage 9 aero and the Stage 10 setup / build modules untouched", same)
local names = {}
for _, c in ipairs(cup:GetChildren()) do names[c.Name] = true end
local missing = {}
for _, n in ipairs({"NR2003CupFrame", "NR2003CupFrameCode1", "NR2003CupFrameData1"}) do if not names[n] then missing[#missing + 1] = n end end
check("Stage 11 modules installed in Core.NR2003Cup", #missing == 0, #missing > 0 and table.concat(missing, ",") or (#cup:GetChildren() .. " modules"))
check("driver (frame start + switchable frame end), vehicle, adapter, self-tests 6/7..10 (frozen comparisons) and Stage11SelfTest updated",
	cup.NR2003CupDriver.Source:find("_frameStart11", 1, true) ~= nil and pkg.Core.NR2003CupVehicle.Source:find("NR2003CupFrame", 1, true) ~= nil
	and pkg.Roblox.CupChassisAdapter.Source:find("stage11TestEvents", 1, true) ~= nil and pkg.Roblox:FindFirstChild("Stage11SelfTest") ~= nil
	and pkg.Roblox.Stage67SelfTest.Source:find('setRuntimeMode("frozen")', 1, true) ~= nil
	and pkg.Roblox.Stage10SelfTest.Source:find('setRuntimeMode("frozen")', 1, true) ~= nil)
check("client HUD updated (Stage 11 line), server untouched", SP.NR2003Client.Source ~= clientBefore and SP.NR2003Client.Source:find("s11Line", 1, true) ~= nil
	and services.ServerScriptService.NR2003Server.Source == serverBefore)
local backups = 0
for _, c in ipairs(services.ServerStorage:GetChildren()) do
	if c.Name:find("NR2003Backup_Stage11_", 1, true) and c:FindFirstChild("NR2003Lab") and c:FindFirstChild("NR2003Client") then backups += 1 end
end
check("backup folder with the package and the client in ServerStorage", backups == 1, tostring(backups))
check("package tagged NR2003Stage = 11", pkg:GetAttribute("NR2003Stage") == "11")

-- 2) re-applying the patch on a Stage 11 bench works (parts replaced, nothing duplicated)
cache = {}
local okR, errR = run(PATCH11, "PATCH_STAGE11")
local count = {}
for _, c in ipairs(pkg.Core.NR2003Cup:GetChildren()) do count[c.Name] = (count[c.Name] or 0) + 1 end
local dup = false
for _, v in pairs(count) do if v > 1 then dup = true end end
check("re-applying PATCH_STAGE11 on a Stage 11 bench: no duplicate modules", okR and not dup, okR and nil or tostring(errR):sub(1, 200))

-- 3) revert path: a failing Stage 11 self-test restores the package and the client exactly
pkg = RS:FindFirstChild("NR2003Lab")
local vehicleBefore = pkg.Core.NR2003CupVehicle.Source
pkg.Roblox.ModeConfig.Source = 'return {mode="NR2003_CUP"} -- marker'
SP.NR2003Client.Source = SP.NR2003Client.Source .. "\n-- client marker"
local clientMarked = SP.NR2003Client.Source
cache = {}
failStage11 = true
local ok2, err2 = run(PATCH11, "PATCH_STAGE11")
failStage11 = false
check("forced failure reports an error", not ok2 and tostring(err2):find("revertido", 1, true) ~= nil, tostring(err2):sub(1, 120))
local restored = RS:FindFirstChild("NR2003Lab")
check("revert restores the previous package and client", restored ~= nil and restored.Roblox.ModeConfig.Source:find("marker", 1, true) ~= nil
	and restored.Core.NR2003CupVehicle.Source == vehicleBefore and SP.NR2003Client.Source == clientMarked)

-- 4) refusing to run without Stage 10 (Stage 9 bench)
stage5()
local o = true
for _, p in ipairs({{PATCH67, "PATCH_STAGE6_7"}, {PATCH8, "PATCH_STAGE8"}, {PATCH9, "PATCH_STAGE9"}}) do
	cache = {}
	local okp = run(p[1], p[2]); o = o and okp
end
cache = {}
local ok4, err4 = run(PATCH11, "PATCH_STAGE11")
check("refuses a Stage 9 bench without Stage 10", o and not ok4 and tostring(err4):find("Stage 10", 1, true) ~= nil, tostring(err4):sub(1, 120))

-- 5) split install for the Command Bar: parts 1..N stage the sources, INSTALL installs (same result as PATCH_STAGE11)
local s0 = bench10()
cache = {}
local okEarly, errEarly = run(INSTALL11, "PATCH_STAGE11_INSTALL")
check("split: INSTALL before the parts refuses (nothing changed)", s0 and not okEarly and tostring(errEarly):find("PART", 1, true) ~= nil
	and RS.NR2003Lab:GetAttribute("NR2003Stage") ~= "11", tostring(errEarly):sub(1, 120))
local partsOk = true
for k, src in ipairs(PARTS11) do
	cache = {}
	local okP, errP = run(src, "PATCH_STAGE11_PART" .. k)
	if not okP then partsOk = false; print("    part " .. k .. ": " .. tostring(errP):sub(1, 200)) end
end
check("split: parts 1.." .. #PARTS11 .. " only stage sources (package untouched)", partsOk and services.ServerStorage:FindFirstChild("NR2003Stage11Staging") ~= nil
	and RS.NR2003Lab.Core.NR2003Cup:FindFirstChild("NR2003CupFrame") == nil)
cache = {}
local okI, errI = run(INSTALL11, "PATCH_STAGE11_INSTALL")
local cupS = RS.NR2003Lab.Core.NR2003Cup
local sameAsFull = okI
for _, c in ipairs(cup:GetChildren()) do
	local x = cupS:FindFirstChild(c.Name)
	if not x or x.Source ~= c.Source then sameAsFull = false end
end
check("split: INSTALL installs the same modules and client as PATCH_STAGE11 (incl. self-tests), staging removed", sameAsFull
	and SP.NR2003Client.Source:find("s11Line", 1, true) ~= nil
	and services.ServerStorage:FindFirstChild("NR2003Stage11Staging") == nil and RS.NR2003Lab:GetAttribute("NR2003Stage") == "11",
	okI and nil or tostring(errI):sub(1, 300))
print(string.format("\npatch11 mock: %d passed, %d failed", passed, failed))
if failed > 0 then error("patch11 mock tests failed") end
