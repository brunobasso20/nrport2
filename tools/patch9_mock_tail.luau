local passed, failed = 0, 0
local function check(name, ok, detail)
	if ok then passed += 1 else failed += 1 end
	print((ok and "PASS  " or "FAIL  ") .. name .. (detail and ("  " .. detail) or ""))
end
local failStage9 = false
do
	local inner = mockRequire
	mockRequire = function(m)
		if type(m) ~= "string" and failStage9 and m.Name == "Stage9SelfTest" then error("forced Stage 9 self-test failure (revert path)") end
		return inner(m)
	end
end
local function run(source, name)
	local f = assert(loadstring(source, name))
	setfenv(f, setmetatable({game = game, workspace = services.Workspace, Instance = Instance, require = mockRequire}, {__index = _G}))
	return pcall(f)
end

-- 0) Stage 5 bench + the ORIGINAL Stage 6/7 and Stage 8 patches (validated baseline)
stage5()
local ok67, err67 = run(PATCH67, "PATCH_STAGE6_7")
check("baseline: PATCH_STAGE6_7 installs on the Stage 5 bench", ok67, ok67 and nil or tostring(err67):sub(1, 200))
cache = {}
local ok8, err8 = run(PATCH8, "PATCH_STAGE8")
check("baseline: PATCH_STAGE8 installs on the Stage 6/7 bench", ok8, ok8 and nil or tostring(err8):sub(1, 200))
local RS = services.ReplicatedStorage
local pkg = RS:FindFirstChild("NR2003Lab")
local coreBefore = pkg.Core.NR2003Cup.NR2003CupCore.Source
local jitBefore = pkg.Core.NR2003Cup.NR2003CupJIT2.Source
local imageBefore = pkg.Core.NR2003Cup.NR2003CupImage1.Source
local serverBefore = services.ServerScriptService.NR2003Server.Source
local st67Before, st8Before = pkg.Roblox.Stage67SelfTest.Source, pkg.Roblox.Stage8SelfTest.Source

-- 1) Stage 9 install
cache = {}
local ok, err = run(PATCH9, "PATCH_STAGE9")
check("PATCH_STAGE9 runs to completion on the Stage 8 bench (incl. Stage 6/7 + 8 + 9 self-tests)", ok, ok and nil or tostring(err):sub(1, 300))
pkg = RS:FindFirstChild("NR2003Lab")
local cup = pkg.Core.NR2003Cup
check("Core.NR2003Cup: 9 modules (NR2003CupAero added); generated Stage 6/7 modules untouched", #cup:GetChildren() == 9
	and cup:FindFirstChild("NR2003CupAero") ~= nil and cup.NR2003CupCore.Source == coreBefore and cup.NR2003CupJIT2.Source == jitBefore
	and cup.NR2003CupImage1.Source == imageBefore, tostring(#cup:GetChildren()))
check("NR2003CupDriver keeps the Stage 8 brake chain and calls the Stage 9 frame hook", cup.NR2003CupDriver.Source:find("brakePedalOriginal", 1, true) ~= nil
	and cup.NR2003CupDriver.Source:find("_aeroFrame", 1, true) ~= nil)
check("NR2003CupVehicle / CupChassisAdapter updated, Stage9SelfTest installed",
	pkg.Core.NR2003CupVehicle.Source:find("startSession", 1, true) ~= nil and pkg.Roblox.CupChassisAdapter.Source:find("aeroHostInputs", 1, true) ~= nil
	and pkg.Roblox:FindFirstChild("Stage9SelfTest") ~= nil)
check("server untouched, Stage 6/7 and Stage 8 self-tests untouched, client HUD updated", services.ServerScriptService.NR2003Server.Source == serverBefore
	and pkg.Roblox.Stage67SelfTest.Source == st67Before and pkg.Roblox.Stage8SelfTest.Source == st8Before
	and SP.NR2003Client.Source:find("aeroLine", 1, true) ~= nil)
local backups = 0
for _, c in ipairs(services.ServerStorage:GetChildren()) do
	if c.Name:find("NR2003Backup_Stage9_", 1, true) and c:FindFirstChild("NR2003Lab") and c:FindFirstChild("NR2003Client") then backups += 1 end
end
check("backup folder with package + client in ServerStorage", backups == 1, tostring(backups))
check("package tagged NR2003Stage = 9", pkg:GetAttribute("NR2003Stage") == "9")

-- 2) revert path: a failing Stage 9 self-test restores package and client exactly
local vehicleBefore = pkg.Core.NR2003CupVehicle.Source
pkg.Roblox.ModeConfig.Source = 'return {mode="NR2003_CUP"} -- marker'
local clientBefore = SP.NR2003Client.Source
cache = {}
failStage9 = true
local ok2, err2 = run(PATCH9, "PATCH_STAGE9")
failStage9 = false
check("forced failure reports an error", not ok2 and tostring(err2):find("revertido", 1, true) ~= nil, tostring(err2):sub(1, 120))
local restored = RS:FindFirstChild("NR2003Lab")
check("revert restores the previous package", restored ~= nil and restored.Roblox.ModeConfig.Source:find("marker", 1, true) ~= nil
	and restored.Core.NR2003CupVehicle.Source == vehicleBefore)
check("revert restores the client source", SP.NR2003Client.Source == clientBefore)

-- 3) refusing to run without Stage 8 (Stage 6/7 bench)
stage5()
cache = {}
local ok3 = run(PATCH67, "PATCH_STAGE6_7")
cache = {}
local ok4, err4 = run(PATCH9, "PATCH_STAGE9")
check("refuses a Stage 6/7 bench without Stage 8", ok3 and not ok4 and tostring(err4):find("STAGE8", 1, true) ~= nil, tostring(err4):sub(1, 120))
print(string.format("\npatch9 mock: %d passed, %d failed", passed, failed))
if failed > 0 then error("patch9 mock tests failed") end
