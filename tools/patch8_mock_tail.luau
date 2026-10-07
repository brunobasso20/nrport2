local passed, failed = 0, 0
local function check(name, ok, detail)
	if ok then passed += 1 else failed += 1 end
	print((ok and "PASS  " or "FAIL  ") .. name .. (detail and ("  " .. detail) or ""))
end
local failStage8 = false
do
	local inner = mockRequire
	mockRequire = function(m)
		if type(m) ~= "string" and failStage8 and m.Name == "Stage8SelfTest" then error("forced Stage 8 self-test failure (revert path)") end
		return inner(m)
	end
end
local function run(source, name)
	local f = assert(loadstring(source, name))
	setfenv(f, setmetatable({game = game, workspace = services.Workspace, Instance = Instance, require = mockRequire}, {__index = _G}))
	return pcall(f)
end

-- 0) Stage 5 bench + the ORIGINAL Stage 6/7 patch (validated baseline)
stage5()
local ok67, err67 = run(PATCH67, "PATCH_STAGE6_7")
check("baseline: PATCH_STAGE6_7 installs on the Stage 5 bench", ok67, ok67 and nil or tostring(err67):sub(1, 200))
local RS = services.ReplicatedStorage
local pkg = RS:FindFirstChild("NR2003Lab")
local coreBefore = pkg.Core.NR2003Cup.NR2003CupCore.Source
local jitBefore = pkg.Core.NR2003Cup.NR2003CupJIT2.Source
local serverBefore = services.ServerScriptService.NR2003Server.Source

-- 1) Stage 8 install
cache = {}
local ok, err = run(PATCH8, "PATCH_STAGE8")
check("PATCH_STAGE8 runs to completion on the Stage 6/7 bench (incl. Stage 6/7 + Stage 8 self-tests)", ok, ok and nil or tostring(err):sub(1, 300))
pkg = RS:FindFirstChild("NR2003Lab")
local cup = pkg.Core.NR2003Cup
check("Core.NR2003Cup keeps 8 modules; generated Stage 6/7 modules untouched", #cup:GetChildren() == 8
	and cup.NR2003CupCore.Source == coreBefore and cup.NR2003CupJIT2.Source == jitBefore)
check("NR2003CupDriver updated (Stage 8 brake chain)", cup.NR2003CupDriver.Source:find("brakePedalOriginal", 1, true) ~= nil)
check("NR2003CupVehicle / CupChassisAdapter updated, Stage8SelfTest installed",
	pkg.Core.NR2003CupVehicle.Source:find("setBrakeBias", 1, true) ~= nil and pkg.Roblox.CupChassisAdapter.Source:find("brakeControl", 1, true) ~= nil
	and pkg.Roblox:FindFirstChild("Stage8SelfTest") ~= nil)
check("server untouched, client HUD updated", services.ServerScriptService.NR2003Server.Source == serverBefore
	and SP.NR2003Client.Source:find("brakePedal", 1, true) ~= nil)
check("Stage 5 / 6-7 modules kept", pkg.Roblox:FindFirstChild("CoreChassisAdapter") ~= nil and pkg.Roblox:FindFirstChild("Stage67SelfTest") ~= nil
	and pkg.Core:FindFirstChild("CupTune") ~= nil)
local backups = 0
for _, c in ipairs(services.ServerStorage:GetChildren()) do
	if c.Name:find("NR2003Backup_Stage8_", 1, true) and c:FindFirstChild("NR2003Lab") and c:FindFirstChild("NR2003Client") then backups += 1 end
end
check("backup folder with package + client in ServerStorage", backups == 1, tostring(backups))
check("package tagged NR2003Stage = 8", pkg:GetAttribute("NR2003Stage") == "8")

-- 2) revert path: a failing Stage 8 self-test restores package and client exactly
local driverBefore = pkg.Core.NR2003Cup.NR2003CupDriver.Source
pkg.Roblox.ModeConfig.Source = 'return {mode="NR2003_CUP"} -- marker'
local clientBefore = SP.NR2003Client.Source
cache = {}
failStage8 = true
local ok2, err2 = run(PATCH8, "PATCH_STAGE8")
failStage8 = false
check("forced failure reports an error", not ok2 and tostring(err2):find("revertido", 1, true) ~= nil, tostring(err2):sub(1, 120))
local restored = RS:FindFirstChild("NR2003Lab")
check("revert restores the previous package", restored ~= nil and restored.Roblox.ModeConfig.Source:find("marker", 1, true) ~= nil
	and restored.Core.NR2003Cup.NR2003CupDriver.Source == driverBefore)
check("revert restores the client source", SP.NR2003Client.Source == clientBefore)

-- 3) refusing to run without Stage 6/7
stage5()
cache = {}
local ok3, err3 = run(PATCH8, "PATCH_STAGE8")
check("refuses a bench without Stage 6/7", not ok3 and tostring(err3):find("STAGE6_7", 1, true) ~= nil, tostring(err3):sub(1, 120))
print(string.format("\npatch8 mock: %d passed, %d failed", passed, failed))
if failed > 0 then error("patch8 mock tests failed") end
