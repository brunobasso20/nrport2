-- ===== mock Studio DataModel: executes studio/INSTALL_CARMODEL.lua and studio/ROLLBACK_CARMODEL.lua =====
-- Checks: refusal on a non-Stage-13 bench and on a locally modified script (nothing changed), install (scripts updated in
-- place with instance identity kept, CarModel folder + DrawState remote created, physics folders untouched, NR2003Stage
-- unchanged), backup of only what changes + ADDED markers, idempotent re-run, automatic revert on a failing self-test,
-- verified rollback to the published Stage 13 sources (CarModel kept in ServerStorage), no SavePlace.
local Vector3 = {}
Vector3.__index = function(v, k)
	if k == "Magnitude" then return math.sqrt(v.X * v.X + v.Y * v.Y + v.Z * v.Z) end
	return Vector3[k]
end
function Vector3.new(x, y, z) return setmetatable({X = x or 0, Y = y or 0, Z = z or 0}, Vector3) end
Vector3.__add = function(a, b) return Vector3.new(a.X + b.X, a.Y + b.Y, a.Z + b.Z) end
Vector3.__sub = function(a, b) return Vector3.new(a.X - b.X, a.Y - b.Y, a.Z - b.Z) end
Vector3.__mul = function(a, b)
	if type(a) == "number" then return Vector3.new(a * b.X, a * b.Y, a * b.Z) end
	return Vector3.new(a.X * b, a.Y * b, a.Z * b)
end
Vector3.__div = function(a, b) return Vector3.new(a.X / b, a.Y / b, a.Z / b) end
function Vector3.Dot(a, b) return a.X * b.X + a.Y * b.Y + a.Z * b.Z end
function Vector3.Cross(a, b) return Vector3.new(a.Y * b.Z - a.Z * b.Y, a.Z * b.X - a.X * b.Z, a.X * b.Y - a.Y * b.X) end
local CFrame = {}
function CFrame.fromMatrix(p, vx, vy, vz) return CFrame.new(p.X, p.Y, p.Z, vx.X, vy.X, vz.X, vx.Y, vy.Y, vz.Y, vx.Z, vy.Z, vz.Z) end
CFrame.__index = function(c, k)
	if k == "Position" then return Vector3.new(c.p[1], c.p[2], c.p[3]) end
	return CFrame[k]
end
function CFrame.new(x, y, z, ...)
	local r = {...}
	if #r == 0 then r = {1, 0, 0, 0, 1, 0, 0, 0, 1} end
	return setmetatable({p = {x or 0, y or 0, z or 0}, r = r}, CFrame)
end
CFrame.__mul = function(a, b)
	local r = a.r
	return Vector3.new(r[1] * b.X + r[2] * b.Y + r[3] * b.Z + a.p[1], r[4] * b.X + r[5] * b.Y + r[6] * b.Z + a.p[2],
		r[7] * b.X + r[8] * b.Y + r[9] * b.Z + a.p[3])
end
function CFrame.GetComponents(c) return c.p[1], c.p[2], c.p[3], table.unpack(c.r) end
local Random = {new = function(seed)
	local st = seed
	return {NextNumber = function(_, a, b) st = (st * 1103515245 + 12345) % 2147483648; return a + (b - a) * st / 2147483648 end}
end}

local Instance = {}
local IMeta = {}
local function newInstance(class, name)
	local o = {ClassName = class, Name = name or class, _children = {}, _attrs = {}, Archivable = true, _parent = nil}
	return setmetatable(o, IMeta)
end
IMeta.__index = function(o, k)
	if k == "Parent" then return rawget(o, "_parent") end
	if k == "Position" and rawget(o, "CFrame") then return rawget(o, "CFrame").Position end
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
function Instance.FindFirstChild(o, name, recursive)
	for _, c in ipairs(rawget(o, "_children")) do if c.Name == name then return c end end
	if recursive then
		for _, c in ipairs(rawget(o, "_children")) do local r = Instance.FindFirstChild(c, name, true); if r then return r end end
	end
	return nil
end
function Instance.FindFirstChildOfClass(o, class)
	for _, c in ipairs(rawget(o, "_children")) do if c.ClassName == class then return c end end
	return nil
end
function Instance.GetDescendants(o)
	local out = {}
	local function walk(x) for _, c in ipairs(rawget(x, "_children")) do table.insert(out, c); walk(c) end end
	walk(o)
	return out
end
function Instance.WaitForChild(o, name) return assert(Instance.FindFirstChild(o, name), "WaitForChild: " .. name) end
function Instance.GetChildren(o) return table.clone(rawget(o, "_children")) end
function Instance.SetAttribute(o, k, v) rawget(o, "_attrs")[k] = v end
function Instance.GetAttribute(o, k) return rawget(o, "_attrs")[k] end
function Instance.IsA(o, c) return o.ClassName == c or (c == "BasePart" and (o.ClassName == "MeshPart" or o.ClassName == "Part")) end
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
services.StarterPlayer.WaitForChild = function(_, n) return SP end
local saved = 0
local scriptEditor = {UpdateSourceAsync = function(_, s, f) rawset(s, "Source", f(s.Source)) end}
local runService = {IsRunning = function() return false end}
local selected = {}
local selection = {Get = function() return selected end}
local game = {GetService = function(_, n)
	if n == "RunService" then return runService end
	if n == "Selection" then return selection end
	if n == "ScriptEditorService" then return scriptEditor end
	return assert(services[n], "service " .. n)
end, SavePlace = function() saved += 1 end}

local function stage13()
	for _, s in pairs(services) do
		if s ~= services.StarterPlayer then for _, c in ipairs(s:GetChildren()) do c:Destroy() end end
	end
	for _, c in ipairs(SP:GetChildren()) do c:Destroy() end
	local pkg = make("Folder", "NR2003Lab", services.ReplicatedStorage)
	pkg:SetAttribute("NR2003Stage", "13"); pkg:SetAttribute("NR2003Version", "3.12.0-stage13")
	local core = make("Folder", "Core", pkg); local rb = make("Folder", "Roblox", pkg)
	for n, src in pairs(CORE) do make("ModuleScript", n, core, src) end
	make("Folder", "NR2003Cup", core)
	make("ModuleScript", "Stage13SelfTest", rb, "return {run=function() return true,{'stub'} end}")
	make("ModuleScript", "CupChassisAdapter", rb, "return {}")
	make("Script", "NR2003Server", services.ServerScriptService, PUBLISHED.Server)
	make("LocalScript", "NR2003Client", SP, PUBLISHED.Client)
	return pkg
end

local cache = {}
local failSelfTest = false
local function mockRequire(m)
	if failSelfTest and m.Name == "NR2003CarModelSelfTest" then error("forced self-test failure (revert path)") end
	if cache[m] ~= nil and cache[m].src == m.Source then return cache[m].v end
	local f = assert(loadstring(m.Source, m.Name))
	setfenv(f, setmetatable({script = m, require = mockRequire, game = game, workspace = services.Workspace,
		Vector3 = Vector3, CFrame = CFrame, Random = Random, Instance = Instance}, {__index = _G}))
	local v = f()
	cache[m] = {v = v, src = m.Source}
	return v
end
local passed, failed = 0, 0
local function check(name, ok, detail)
	if ok then passed += 1 else failed += 1 end
	print((ok and "PASS  " or "FAIL  ") .. name .. (detail and ("  " .. detail) or ""))
end
local Enum = {AlphaMode = {Overlay = "Overlay", Transparency = "Transparency"}}
local function run(src, name)
	local f = assert(loadstring(src, name))
	setfenv(f, setmetatable({game = game, workspace = services.Workspace, Instance = Instance, require = mockRequire,
		Vector3 = Vector3, CFrame = CFrame, Enum = Enum, warn = print}, {__index = _G}))
	return pcall(f)
end
local function snapshot(folder)
	local t = {}
	local function walk(o, path)
		for _, c in ipairs(o:GetChildren()) do
			local p = path .. "." .. c.Name
			t[p] = rawget(c, "Source") or c.ClassName
			walk(c, p)
		end
	end
	walk(folder, folder.Name)
	return t
end
local function same(a, b)
	for k, v in pairs(a) do if b[k] ~= v then return false end end
	for k in pairs(b) do if a[k] == nil then return false end end
	return true
end
local RS, SSS, SS = services.ReplicatedStorage, services.ServerScriptService, services.ServerStorage

-- 1) refusals: nothing changes
local pkg = stage13()
pkg:SetAttribute("NR2003Stage", "12.1")
local ok, err = run(INSTALL, "INSTALL_CARMODEL")
check("refuses a bench that is not Stage 13", not ok and tostring(err):find("Stage 13") ~= nil and pkg:FindFirstChild("CarModel") == nil
	and SS:FindFirstChild("NR2003Backup_CarModel") == nil and SP.NR2003Client.Source == PUBLISHED.Client)
pkg = stage13()
SP.NR2003Client.Source = PUBLISHED.Client .. "-- local edit\n"
ok, err = run(INSTALL, "INSTALL_CARMODEL")
check("refuses a locally modified NR2003Client (nothing changed)", not ok and tostring(err):find("difere") ~= nil
	and pkg:FindFirstChild("CarModel") == nil and pkg:FindFirstChild("DrawState") == nil and SS:FindFirstChild("NR2003Backup_CarModel") == nil
	and SSS.NR2003Server.Source == PUBLISHED.Server)

-- 2) install
pkg = stage13()
local physicsBefore = snapshot(pkg)
local client, server = SP.NR2003Client, SSS.NR2003Server
ok, err = run(INSTALL, "INSTALL_CARMODEL")
check("install on the published Stage 13 bench", ok, not ok and tostring(err) or nil)
local folder = pkg:FindFirstChild("CarModel")
local modules = 0
if folder then for _, c in ipairs(folder:GetChildren()) do if c.ClassName == "ModuleScript" and c.Source == NEW.modules[c.Name] then modules += 1 end end end
check("CarModel folder: 10 modules (sources exact) + Data + Assets; DrawState UnreliableRemoteEvent",
	folder ~= nil and modules == 10 and folder:FindFirstChild("Data") ~= nil and folder:FindFirstChild("Assets") ~= nil
	and pkg:FindFirstChild("DrawState") ~= nil and pkg.DrawState.ClassName == "UnreliableRemoteEvent", modules .. " modules")
check("NR2003Client / NR2003Server updated in place (same instances, car-model sources)",
	SP.NR2003Client == client and SSS.NR2003Server == server and client.Source == NEW.Client and server.Source == NEW.Server)
local physicsAfter = snapshot(pkg)
local untouched = true
for k, v in pairs(physicsBefore) do if physicsAfter[k] ~= v then untouched = false end end
check("physics / bench modules untouched; NR2003Stage still 13; NR2003CarModel version set",
	untouched and pkg:GetAttribute("NR2003Stage") == "13" and pkg:GetAttribute("NR2003Version") == "3.12.0-stage13"
	and pkg:GetAttribute("NR2003CarModel") == "1.1.0-carmodel")
local backup = SS:FindFirstChild("NR2003Backup_CarModel")
local bnames = {}
if backup then for _, c in ipairs(backup:GetChildren()) do bnames[c.Name] = c end end
check("backup: only the two changed scripts (published sources) + ADDED markers",
	backup ~= nil and #backup:GetChildren() == 4 and bnames["Client.NR2003Client"] and bnames["Client.NR2003Client"].Source == PUBLISHED.Client
	and bnames["Server.NR2003Server"] and bnames["Server.NR2003Server"].Source == PUBLISHED.Server
	and bnames["ADDED:NR2003Lab.CarModel"] ~= nil and bnames["ADDED:NR2003Lab.DrawState"] ~= nil)

-- 3) re-run: idempotent
local snap = snapshot(RS)
ok, err = run(INSTALL, "INSTALL_CARMODEL (re-run)")
check("re-run is idempotent (same tree, first backup kept, no duplicates)", ok and same(snap, snapshot(RS))
	and SS.NR2003Backup_CarModel == backup and #backup:GetChildren() == 4, not ok and tostring(err) or nil)

-- 4) rollback
ok, err = run(ROLLBACK, "ROLLBACK_CARMODEL")
check("rollback: published Stage 13 sources restored in place, DrawState removed, CarModel kept in ServerStorage",
	ok and SP.NR2003Client == client and client.Source == PUBLISHED.Client and server.Source == PUBLISHED.Server
	and pkg:FindFirstChild("DrawState") == nil and pkg:FindFirstChild("CarModel") == nil
	and SS:FindFirstChild("NR2003CarModel_Removido") ~= nil and pkg:GetAttribute("NR2003CarModel") == nil
	and same(physicsBefore, snapshot(pkg)), not ok and tostring(err) or nil)

-- 5) automatic revert on a failing self-test
pkg = stage13()
local before = snapshot(RS)
failSelfTest = true
ok, err = run(INSTALL, "INSTALL_CARMODEL (failing self-test)")
failSelfTest = false
check("failing self-test -> automatic revert (sources, created instances, backup)", not ok and tostring(err):find("revertida") ~= nil
	and same(before, snapshot(RS)) and SS:FindFirstChild("NR2003Backup_CarModel") == nil and SP.NR2003Client.Source == PUBLISHED.Client
	and SSS.NR2003Server.Source == PUBLISHED.Server)
-- 6) asset installer of a converted package (only when generated with a package dir)
local DATA_SRC_CODE
if ASSETS then
	pkg = stage13()
	ok, err = run(INSTALL, "INSTALL_CARMODEL")
	local DATA_SRC = ASSETS:match("local DATA_SOURCE=(%[=*%[.-%]=*%])")
	DATA_SRC_CODE = assert(loadstring("return " .. DATA_SRC))()
	local desc = assert(loadstring(DATA_SRC_CODE))()
	-- the import as the 3D Importer could leave it: rigid transform (here a translation) + uniform scale 1.25
	local k, off = 1.25, Vector3.new(40, 3, -7)
	local model = make("Model", desc.meta.package, services.Workspace)
	local c = desc.markerSize * 0.25
	for name, m in pairs(desc.markers) do
		local p = make("MeshPart", name, model)
		rawset(p, "CFrame", CFrame.new(off.X + (m[1] + c) * k, off.Y + (m[2] + c) * k, off.Z + (m[3] + c) * k))
	end
	for i, g in ipairs(desc.geometries) do
		local p = make("MeshPart", g.name, model)
		rawset(p, "CFrame", CFrame.new(off.X + g.center[1] * k, off.Y + g.center[2] * k, off.Z + g.center[3] * k))
		-- as a glTF / FBX import: half the parts with a SurfaceAppearance in Overlay, the others with TextureID
		if i % 2 == 0 then local sa = make("SurfaceAppearance", "SurfaceAppearance", p); sa.AlphaMode = "Overlay"
		else rawset(p, "TextureID", "rbxassetid://" .. i) end
	end
	local ok2, err2 = run(ASSETS, "INSTALL_CARMODEL_ASSETS")
	local data = pkg.CarModel.Data:FindFirstChild("NR2003CarModelData_" .. desc.meta.package)
	local moved = pkg.CarModel.Assets:FindFirstChild(desc.meta.package)
	local glass, anchored = 0, true
	for _, g in ipairs(desc.geometries) do
		local p = moved and moved:FindFirstChild(g.name)
		if p and g.opacity < 1 and math.abs(p.Transparency - (1 - g.opacity)) < 1e-3 then glass += 1 end
		if p and not (p.Anchored == true and p.CanCollide == false and p.CanQuery == false and p.CanTouch == false) then anchored = false end
	end
	local nGlass = 0
	for _, g in ipairs(desc.geometries) do if g.opacity < 1 then nGlass += 1 end end
	check("INSTALL_CARMODEL_ASSETS: descriptor module + imported model moved to CarModel.Assets, parts anchored / no collision, glass opacity",
		ok and ok2 and data ~= nil and data.Source == DATA_SRC:sub(DATA_SRC:find("\n") + 1, -(#DATA_SRC:match("%]=*%]$") + 1)) and moved == model
		and model.Parent == pkg.CarModel.Assets and anchored and glass == nGlass,
		not ok2 and tostring(err2) or string.format("%d geometries, %d glass", #desc.geometries, nGlass))
	-- material pass: alpha = transparency where the descriptor says "blend"
	local okMat, nb = true, 0
	for i, g in ipairs(desc.geometries) do
		local p = moved and moved:FindFirstChild(g.name)
		local sa = p and p:FindFirstChildOfClass("SurfaceAppearance")
		if g.alpha == "blend" then nb += 1 end
		if i % 2 == 0 then
			if not sa or sa.AlphaMode ~= (g.alpha == "blend" and "Transparency" or "Overlay") then okMat = false end
		elseif g.alpha == "blend" then
			if not sa or sa.AlphaMode ~= "Transparency" or sa.ColorMap ~= p.TextureID then okMat = false end
		elseif sa then okMat = false end
	end
	local glass = moved and moved:FindFirstChild("G144_GLASS")
	check("asset installer materials: SurfaceAppearance AlphaMode = Transparency for alpha-transparent textures (windshield, windows, nets), Overlay otherwise",
		okMat and nb > 0 and glass ~= nil and glass:FindFirstChildOfClass("SurfaceAppearance") ~= nil
		and glass:FindFirstChildOfClass("SurfaceAppearance").AlphaMode == "Transparency", nb .. " transparent geometries")
	-- FIX_CARMODEL_MATERIALS on an install made with an OLD descriptor (no g.alpha): default list of the cup.dat textures
	for _, g in ipairs(desc.geometries) do
		local p = moved:FindFirstChild(g.name); local sa = p and p:FindFirstChildOfClass("SurfaceAppearance")
		if sa then sa.AlphaMode = "Overlay" end
	end
	local oldDesc = loadstring(DATA_SRC_CODE:gsub(",alpha=\"%a+\"", ""))()
	pkg.CarModel.Data:FindFirstChild("NR2003CarModelData_" .. desc.meta.package).Source = "-- old descriptor\n" .. DATA_SRC_CODE:gsub(",alpha=\"%a+\"", "")
	local ok4, err4 = run(FIX, "FIX_CARMODEL_MATERIALS")
	local g144 = moved:FindFirstChild("G144_GLASS"):FindFirstChildOfClass("SurfaceAppearance")
	check("FIX_CARMODEL_MATERIALS repairs an existing install (old descriptor without alpha: built-in list) — windshield transparent",
		ok4 and oldDesc.geometries[1].alpha == nil and g144.AlphaMode == "Transparency", not ok4 and tostring(err4) or nil)
	-- the full self-test (code + descriptor + import calibration) after the asset install
	local okST, lines = mockRequire(pkg.CarModel.NR2003CarModelSelfTest).run(false)
	check("NR2003CarModelSelfTest (full) after the asset install: descriptor wheel nodes + import calibration", okST, lines[#lines])
	-- refusal: an import without the calibration markers
	pkg = stage13()
	run(INSTALL, "INSTALL_CARMODEL")
	local bad = make("Model", desc.meta.package, services.Workspace)
	make("MeshPart", desc.geometries[1].name, bad)
	local ok3, err3 = run(ASSETS, "INSTALL_CARMODEL_ASSETS (no markers)")
	check("INSTALL_CARMODEL_ASSETS refuses an import without the calibration markers (nothing installed)", not ok3
		and tostring(err3):find("marcador") ~= nil and #pkg.CarModel.Data:GetChildren() == 0)
end
check("the place is never saved", saved == 0)
print(string.format("\n%d passed, %d failed", passed, failed))
if failed > 0 then error("install mock failed") end
