-- ===== mock Studio DataModel for PATCH_STAGE6_7.lua (install + revert paths) =====
local Instance = {}
local IMeta = {}
local function newInstance(class, name)
	local o = {ClassName = class, Name = name or class, _children = {}, _attrs = {}, Archivable = true, _parent = nil}
	return setmetatable(o, IMeta)
end
IMeta.__index = function(o, k)
	if k == "Parent" then return rawget(o, "_parent") end
	local m = Instance[k]
	if m then return m end
	for _, c in ipairs(rawget(o, "_children")) do if c.Name == k then return c end end
	return nil
end
IMeta.__newindex = function(o, k, v)
	if k == "Parent" then
		local old = rawget(o, "_parent")
		if old then
			local list = rawget(old, "_children")
			for i, c in ipairs(list) do if c == o then table.remove(list, i); break end end
		end
		rawset(o, "_parent", v)
		if v then table.insert(rawget(v, "_children"), o) end
		return
	end
	if k == "Source" and #v >= 200000 then error("Source exceeds 200000 characters (" .. #v .. ")") end
	rawset(o, k, v)
end
function Instance.new(class) return newInstance(class) end
function Instance.FindFirstChild(o, name) for _, c in ipairs(rawget(o, "_children")) do if c.Name == name then return c end end return nil end
function Instance.WaitForChild(o, name) return assert(Instance.FindFirstChild(o, name), "WaitForChild: " .. name) end
function Instance.GetChildren(o) return table.clone(rawget(o, "_children")) end
function Instance.SetAttribute(o, k, v) rawget(o, "_attrs")[k] = v end
function Instance.GetAttribute(o, k) return rawget(o, "_attrs")[k] end
function Instance.IsA(o, c) return o.ClassName == c end
function Instance.Destroy(o) o.Parent = nil; rawset(o, "_destroyed", true) end
function Instance.Clone(o)
	local c = newInstance(o.ClassName, o.Name)
	for k, v in pairs(o) do if k ~= "_children" and k ~= "_parent" and k ~= "_attrs" then rawset(c, k, v) end end
	for k, v in pairs(rawget(o, "_attrs")) do rawget(c, "_attrs")[k] = v end
	for _, ch in ipairs(rawget(o, "_children")) do Instance.Clone(ch).Parent = c end
	return c
end

local function make(class, name, parent, source)
	local o = newInstance(class, name)
	if source then rawset(o, "Source", source) end
	o.Parent = parent
	return o
end
local dataModel = newInstance("DataModel", "game")
local services = {}
for _, n in ipairs({"ReplicatedStorage", "ServerScriptService", "ServerStorage", "StarterPlayer", "Workspace"}) do
	services[n] = make(n, n, dataModel)
end
local SP = make("StarterPlayerScripts", "StarterPlayerScripts", services.StarterPlayer)
local function stage5()
	for _, c in ipairs(services.ReplicatedStorage:GetChildren()) do c:Destroy() end
	local pkg = make("Folder", "NR2003Lab", services.ReplicatedStorage)
	local core = make("Folder", "Core", pkg); local rb = make("Folder", "Roblox", pkg)
	for _, n in ipairs({"NR2003FixedStep", "Surface", "MathUtil", "TestTune", "RecoveredData", "NR2003Math", "Float32"}) do make("ModuleScript", n, core, "return {}") end
	for _, n in ipairs({"VisualRig", "RenderSnapshot", "SnapshotBuffer", "RenderPresentation", "CoreChassisAdapter", "SeatAccess", "Cockpit", "LegacyRobloxAdapter", "ModeConfig"}) do
		make("ModuleScript", n, rb, n == "ModeConfig" and 'return {mode="NR2003_CORE"}' or "return {}")
	end
	if not services.ServerScriptService:FindFirstChild("NR2003Server") then make("Script", "NR2003Server", services.ServerScriptService, "-- stage5 server") end
	if not SP:FindFirstChild("NR2003Client") then make("LocalScript", "NR2003Client", SP, "-- stage5 client") end
	if not services.Workspace:FindFirstChild("NR2003LabWorld") then
		local world = make("Folder", "NR2003LabWorld", services.Workspace)
		local car = make("Model", "TestCar", world); make("Part", "Chassis", car); make("VehicleSeat", "DriverSeat", car)
	end
	return pkg
end
local selection = {Set = function() end}
local scriptEditor = {UpdateSourceAsync = function(_, s, f) rawset(s, "Source", f(s.Source)) end}
local runService = {IsRunning = function() return false end}
local game = {GetService = function(_, n)
	if n == "RunService" then return runService end
	if n == "Selection" then return selection end
	if n == "ScriptEditorService" then return scriptEditor end
	return assert(services[n], "service " .. n)
end}
services.StarterPlayer.WaitForChild = function(_, n) return SP end

-- require(ModuleScript): run its Source with a Roblox-like env (script, require, game)
local cache = {}
local failSelfTest = false
local function mockRequire(m)
	if type(m) == "string" then return require(m) end
	if failSelfTest and m.Name == "Stage67SelfTest" then error("forced self-test failure (revert path)") end
	if cache[m] ~= nil then return cache[m] end
	local f = assert(loadstring(m.Source, m.Name))
	setfenv(f, setmetatable({script = m, require = mockRequire, game = game, workspace = services.Workspace}, {__index = _G}))
	local v = f()
	cache[m] = v
	return v
end

local passed, failed = 0, 0
local function check(name, ok, detail)
	if ok then passed += 1 else failed += 1 end
	print((ok and "PASS  " or "FAIL  ") .. name .. (detail and ("  " .. detail) or ""))
end
local function runPatch()
	local f = assert(loadstring(PATCH, "PATCH_STAGE6_7"))
	setfenv(f, setmetatable({game = game, workspace = services.Workspace, Instance = Instance, require = mockRequire}, {__index = _G}))
	return pcall(f)
end

-- 1) install on a Stage 5 bench
local pkg = stage5()
local ok, err = runPatch()
check("patch runs to completion on a Stage 5 bench (incl. self-test)", ok, ok and nil or tostring(err))
local RS = services.ReplicatedStorage
local newPkg = RS:FindFirstChild("NR2003Lab")
local cup = newPkg and newPkg.Core:FindFirstChild("NR2003Cup")
local cupCount = cup and #cup:GetChildren() or 0
check("Core.NR2003Cup installed with 8 modules", cupCount == 8, tostring(cupCount))
check("Core.NR2003CupVehicle / CupTune, Roblox.CupChassisAdapter / Stage67SelfTest installed",
	newPkg.Core:FindFirstChild("NR2003CupVehicle") and newPkg.Core:FindFirstChild("CupTune") and newPkg.Roblox:FindFirstChild("CupChassisAdapter")
	and newPkg.Roblox:FindFirstChild("Stage67SelfTest") and true or false)
check("ModeConfig switched to NR2003_CUP", newPkg.Roblox.ModeConfig.Source:find('mode="NR2003_CUP"', 1, true) ~= nil)
check("Stage 5 modules kept", newPkg.Roblox:FindFirstChild("CoreChassisAdapter") ~= nil and newPkg.Core:FindFirstChild("TestTune") ~= nil)
check("server/client sources replaced", services.ServerScriptService.NR2003Server.Source:find("NR2003_CUP", 1, true) ~= nil
	and SP.NR2003Client.Source:find("CupTune", 1, true) ~= nil)
local backups = 0
for _, c in ipairs(services.ServerStorage:GetChildren()) do
	if c.Name:find("NR2003Backup_Stage67_", 1, true) and c:FindFirstChild("NR2003Lab") and c:FindFirstChild("NR2003Server") and c:FindFirstChild("NR2003Client") then backups += 1 end
end
check("backup folder with package + scripts in ServerStorage", backups == 1, tostring(backups))
check("package tagged NR2003Stage = 6-7", newPkg:GetAttribute("NR2003Stage") == "6-7")

-- 2) revert path: self-test failure restores the previous package and script sources
local before = RS.NR2003Lab
local serverBefore = services.ServerScriptService.NR2003Server.Source
local clientBefore = SP.NR2003Client.Source
before.Roblox.ModeConfig.Source = 'return {mode="NR2003_CORE"} -- marker'
cache = {}
failSelfTest = true
local ok2, err2 = runPatch()
failSelfTest = false
check("forced failure reports an error", not ok2 and tostring(err2):find("revertido", 1, true) ~= nil, tostring(err2):sub(1, 120))
local restored = RS:FindFirstChild("NR2003Lab")
check("revert restores the previous package", restored ~= nil and restored.Roblox.ModeConfig.Source:find("marker", 1, true) ~= nil)
check("revert restores server/client sources", services.ServerScriptService.NR2003Server.Source == serverBefore and SP.NR2003Client.Source == clientBefore)
print(string.format("\npatch mock: %d passed, %d failed", passed, failed))
if failed > 0 then error("patch mock tests failed") end
