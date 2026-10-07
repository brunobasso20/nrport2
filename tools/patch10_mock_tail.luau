local passed, failed = 0, 0
local function check(name, ok, detail)
	if ok then passed += 1 else failed += 1 end
	print((ok and "PASS  " or "FAIL  ") .. name .. (detail and ("  " .. detail) or ""))
end
local failStage10 = false
do
	local inner = mockRequire
	mockRequire = function(m)
		if type(m) ~= "string" and failStage10 and m.Name == "Stage10SelfTest" then error("forced Stage 10 self-test failure (revert path)") end
		return inner(m)
	end
end
local function run(source, name)
	local f = assert(loadstring(source, name))
	setfenv(f, setmetatable({game = game, workspace = services.Workspace, Instance = Instance, require = mockRequire}, {__index = _G}))
	return pcall(f)
end

-- 0) Stage 5 bench + the ORIGINAL Stage 6/7, 8 and 9 patches (validated baseline)
stage5()
local ok67, err67 = run(PATCH67, "PATCH_STAGE6_7")
check("baseline: PATCH_STAGE6_7 installs on the Stage 5 bench", ok67, ok67 and nil or tostring(err67):sub(1, 200))
cache = {}
local ok8, err8 = run(PATCH8, "PATCH_STAGE8")
check("baseline: PATCH_STAGE8 installs on the Stage 6/7 bench", ok8, ok8 and nil or tostring(err8):sub(1, 200))
cache = {}
local ok9, err9 = run(PATCH9, "PATCH_STAGE9")
check("baseline: PATCH_STAGE9 installs on the Stage 8 bench", ok9, ok9 and nil or tostring(err9):sub(1, 200))
local RS = services.ReplicatedStorage
local pkg = RS:FindFirstChild("NR2003Lab")
local cup = pkg.Core.NR2003Cup
local before = {}
for _, n in ipairs({"NR2003CupImage1", "NR2003CupImage2", "NR2003CupJIT1", "NR2003CupJIT2", "NR2003CupJIT3", "NR2003CupJIT4", "NR2003CupAero"}) do before[n] = cup[n].Source end
local serverBefore, clientBefore = services.ServerScriptService.NR2003Server.Source, SP.NR2003Client.Source
local stBefore = {pkg.Roblox.Stage67SelfTest.Source, pkg.Roblox.Stage8SelfTest.Source, pkg.Roblox.Stage9SelfTest.Source}

-- 1) Stage 10 install
cache = {}
local t0 = os.clock()
local ok, err = run(PATCH10, "PATCH_STAGE10")
check("PATCH_STAGE10 runs to completion on the Stage 9 bench (incl. Stage 6/7 + 8 + 9 + 10 self-tests)", ok, ok and string.format("%.1f s", os.clock() - t0) or tostring(err):sub(1, 400))
pkg = RS:FindFirstChild("NR2003Lab")
cup = pkg.Core.NR2003Cup
local same = true
for n, src in pairs(before) do if cup[n].Source ~= src then same = false end end
check("Stage 6/7 image + callbacks and Stage 9 aero untouched", same)
local names = {}
for _, c in ipairs(cup:GetChildren()) do names[c.Name] = true end
local need = {"NR2003CupSetup", "NR2003CupSetupData", "NR2003CupBuild", "NR2003CupBuildCode1", "NR2003CupBuildData1", "NR2003CupJITG1", "NR2003CupGarage"}
local missing = {}
for _, n in ipairs(need) do if not names[n] then missing[#missing + 1] = n end end
check("Stage 10 modules installed in Core.NR2003Cup", #missing == 0, #missing > 0 and table.concat(missing, ",") or (#cup:GetChildren() .. " modules"))
check("NR2003CupCore exports the reset image / callback table; driver re-binds cells; vehicle + adapter updated",
	cup.NR2003CupCore.Source:find("_pristine", 1, true) ~= nil and cup.NR2003CupDriver.Source:find("_bindDriverCells", 1, true) ~= nil
	and pkg.Core.NR2003CupVehicle.Source:find("NR2003CupGarage", 1, true) ~= nil and pkg.Roblox.CupChassisAdapter.Source:find("applyGarageSetup", 1, true) ~= nil
	and pkg.Roblox:FindFirstChild("Stage10SelfTest") ~= nil)
check("server/client and Stage 6/7, 8, 9 self-tests untouched", services.ServerScriptService.NR2003Server.Source == serverBefore and SP.NR2003Client.Source == clientBefore
	and pkg.Roblox.Stage67SelfTest.Source == stBefore[1] and pkg.Roblox.Stage8SelfTest.Source == stBefore[2] and pkg.Roblox.Stage9SelfTest.Source == stBefore[3])
local backups = 0
for _, c in ipairs(services.ServerStorage:GetChildren()) do
	if c.Name:find("NR2003Backup_Stage10_", 1, true) and c:FindFirstChild("NR2003Lab") then backups += 1 end
end
check("backup folder with the package in ServerStorage", backups == 1, tostring(backups))
check("package tagged NR2003Stage = 10", pkg:GetAttribute("NR2003Stage") == "10")

-- 2) re-applying the patch on a Stage 10 bench works (parts replaced, nothing duplicated)
cache = {}
local okR, errR = run(PATCH10, "PATCH_STAGE10")
local count = {}
for _, c in ipairs(pkg.Core.NR2003Cup:GetChildren()) do count[c.Name] = (count[c.Name] or 0) + 1 end
local dup = false
for _, v in pairs(count) do if v > 1 then dup = true end end
check("re-applying PATCH_STAGE10 on a Stage 10 bench: no duplicate modules", okR and not dup, okR and nil or tostring(errR):sub(1, 200))

-- 3) revert path: a failing Stage 10 self-test restores the package exactly
pkg = RS:FindFirstChild("NR2003Lab")
local vehicleBefore = pkg.Core.NR2003CupVehicle.Source
pkg.Roblox.ModeConfig.Source = 'return {mode="NR2003_CUP"} -- marker'
cache = {}
failStage10 = true
local ok2, err2 = run(PATCH10, "PATCH_STAGE10")
failStage10 = false
check("forced failure reports an error", not ok2 and tostring(err2):find("revertido", 1, true) ~= nil, tostring(err2):sub(1, 120))
local restored = RS:FindFirstChild("NR2003Lab")
check("revert restores the previous package", restored ~= nil and restored.Roblox.ModeConfig.Source:find("marker", 1, true) ~= nil
	and restored.Core.NR2003CupVehicle.Source == vehicleBefore)

-- 4) refusing to run without Stage 9 (Stage 8 bench)
stage5()
cache = {}
local o1 = run(PATCH67, "PATCH_STAGE6_7")
cache = {}
local o2 = run(PATCH8, "PATCH_STAGE8")
cache = {}
local ok4, err4 = run(PATCH10, "PATCH_STAGE10")
check("refuses a Stage 8 bench without Stage 9", o1 and o2 and not ok4 and tostring(err4):find("Stage 9", 1, true) ~= nil, tostring(err4):sub(1, 120))
print(string.format("\npatch10 mock: %d passed, %d failed", passed, failed))
if failed > 0 then error("patch10 mock tests failed") end
