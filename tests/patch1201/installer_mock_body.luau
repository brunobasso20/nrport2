-- The embedded installer runs unchanged; only Roblox services/Instances are mocked.
local passed = 0
local function check(label, condition)
    assert(condition, label)
    passed += 1; print("PASS  " .. label)
end
local methods, mt = {}, {}
local function detach(object)
    local parent = object.values.Parent
    if parent then
        for i, child in ipairs(parent.children) do if child == object then table.remove(parent.children, i); break end end
    end
end
mt.__index = function(object, key)
    return methods[key] or object.values[key] or methods.FindFirstChild(object, key)
end
mt.__newindex = function(object, key, value)
    if key == "Parent" then
        detach(object)
        object.values.Parent = value
        if value then value.children[#value.children + 1] = object end
    elseif key == "Source" then
        local state = object.state
        if state.failName == object.Name and state.failRemaining > 0 then
            state.failRemaining -= 1
            error("Injected Source write failure: " .. object.Name)
        end
        state.writes += 1
        object.values.Source = value
    else object.values[key] = value end
end
function methods:FindFirstChild(name)
    for _, child in ipairs(self.children) do if child.Name == name then return child end end
end
function methods:WaitForChild(name) return assert(self:FindFirstChild(name), "Missing mock child " .. name) end
function methods:GetChildren() return table.clone(self.children) end
function methods:IsA(class) return self.ClassName == class end
function methods:SetAttribute(name, value) self.attributes[name] = value end
function methods:GetAttribute(name) return self.attributes[name] end
function methods:Destroy()
    for _, child in ipairs(self:GetChildren()) do child:Destroy() end
    detach(self); self.values.Parent = nil; self.values.Destroyed = true
end
local function fixture(prediction)
    local state = {writes=0, failRemaining=0, running=false}
    local function new(class, name, parent, source)
        local object = setmetatable({state=state, values={ClassName=class, Name=class, Source=""},
            children={}, attributes={}}, mt)
        if name then object.Name = name end
        if parent then object.Parent = parent end
        if source then object.Source = source end
        return object
    end
    local root = new("Folder", "DataModel")
    local rs = new("Folder", "ReplicatedStorage", root)
    local ss = new("Folder", "ServerStorage", root)
    local servers = new("Folder", "ServerScriptService", root)
    local sp = new("Folder", "StarterPlayer", root)
    local starter = new("Folder", "StarterPlayerScripts", sp)
    local package = new("Folder", "NR2003Lab", rs)
    local modules = new("Folder", "Roblox", package)
    local setup = new("ModuleScript", "NR2003WatkinsGlenSetup", modules, OLD_SETUP)
    local pred = prediction and new("ModuleScript", "PredictionServer", modules, OLD_PREDICTION) or nil
    local legacy = new("Script", "NR2003Server", servers, OLD_LEGACY)
    local untouched = new("LocalScript", "ExistingUnrelatedClient", starter, "-- unrelated source\n")
    local services = {ReplicatedStorage=rs, ServerStorage=ss, ServerScriptService=servers, StarterPlayer=sp,
        RunService={IsRunning=function() return state.running end}}
    local env = setmetatable({game={GetService=function(_, name) return assert(services[name], name) end},
        Instance={new=function(class) return new(class) end}, print=function() end}, {__index=getfenv()})
    state.writes = 0
    return {state=state, root=root, storage=ss, modules=modules, starter=starter,
        setup=setup, prediction=pred, legacy=legacy, untouched=untouched, env=env}
end
local function run(text, f)
    local chunk, reason = loadstring(text)
    assert(chunk, reason)
    setfenv(chunk, f.env)
    return pcall(chunk)
end
local function snapshot(object)
    local out = {object.ClassName, object.Name, object.Source or ""}
    local keys = {}
    for name in pairs(object.attributes) do keys[#keys + 1] = name end
    table.sort(keys)
    for _, name in ipairs(keys) do out[#out + 1] = name .. "=" .. tostring(object.attributes[name]) end
    if object.Value ~= nil then
        out[#out + 1] = type(object.Value) == "table" and ("reference=" .. object.Value.Name) or tostring(object.Value)
    end
    local children = object:GetChildren()
    table.sort(children, function(a, b) return a.Name < b.Name end)
    for _, child in ipairs(children) do out[#out + 1] = snapshot(child) end
    return table.concat(out, "\0")
end
local f = fixture(true)
local original = snapshot(f.root)
local ok, reason = run(APPLY, f)
check("actual generated installer accepts uploaded prediction baseline", ok)
check("installer writes exact patched setup, helper and client sources", f.setup.Source == NEW_SETUP
    and f.modules.SetupTestControls.Source == NEW_CONTROLS and f.starter.NR2003SetupTestBindings.Source == NEW_BINDINGS)
check("prediction module updated while legacy server stays unchanged", f.prediction.Source == NEW_PREDICTION and f.legacy.Source == OLD_LEGACY)
local backup = f.storage:FindFirstChild("NR2003Backup_Patch1201")
check("backup records both original scripts and two added scripts", backup ~= nil and #backup:GetChildren() == 4
    and backup["1"].OriginalSource.Value == OLD_SETUP and backup["4"].OriginalSource.Value == OLD_PREDICTION)
local installed = snapshot(f.root)
f.state.writes = 0
ok = run(APPLY, f)
check("reapply is a no-op and cannot overwrite original backup", ok and f.state.writes == 0
    and f.storage.NR2003Backup_Patch1201 == backup and snapshot(f.root) == installed)
ok = run(ROLLBACK, f)
check("rollback restores complete original tree and sources", ok and snapshot(f.root) == original)
check("rollback removes added helper, client script and backup", f.modules:FindFirstChild("SetupTestControls") == nil
    and f.starter:FindFirstChild("NR2003SetupTestBindings") == nil and f.storage:FindFirstChild("NR2003Backup_Patch1201") == nil)
for _, field in ipairs({"setup", "prediction"}) do
    local edited = fixture(true)
    edited[field].Source ..= "\n-- user edit\n"
    local before = snapshot(edited.root)
    edited.state.writes = 0
    ok, reason = run(APPLY, edited)
    check("edited " .. field .. " preflight refuses before any mutation", not ok and string.find(tostring(reason), "source differs", 1, true)
        and edited.state.writes == 0 and snapshot(edited.root) == before)
end
local failure = fixture(true)
local beforeFailure = snapshot(failure.root)
failure.state.failName, failure.state.failRemaining = "PredictionServer", 1
ok, reason = run(APPLY, failure)
check("injected fourth Source write failure is reported", not ok and string.find(tostring(reason), "Injected Source", 1, true))
check("failed apply restores prior writes, removes added scripts and backup", snapshot(failure.root) == beforeFailure
    and failure.storage:FindFirstChild("NR2003Backup_Patch1201") == nil)
local rollbackGuard = fixture(true)
assert(run(APPLY, rollbackGuard))
rollbackGuard.prediction.Source ..= "\n-- user edit after install\n"
local beforeGuard = snapshot(rollbackGuard.root)
rollbackGuard.state.writes = 0
ok, reason = run(ROLLBACK, rollbackGuard)
check("rollback preflight preserves edited patched source and all other scripts", not ok
    and string.find(tostring(reason), "rollback refused", 1, true) and rollbackGuard.state.writes == 0
    and snapshot(rollbackGuard.root) == beforeGuard)
local legacy = fixture(false)
local originalLegacy = snapshot(legacy.root)
ok = run(APPLY, legacy)
check("legacy install updates actual legacy server without creating prediction module", ok and legacy.legacy.Source == NEW_LEGACY
    and legacy.modules:FindFirstChild("PredictionServer") == nil)
ok = run(ROLLBACK, legacy)
check("legacy rollback restores all original sources and removes additions", ok and snapshot(legacy.root) == originalLegacy)
local running = fixture(true)
running.state.running = true
local beforePlay = snapshot(running.root)
ok = run(APPLY, running)
check("Play-mode preflight refuses without mutation", not ok and running.state.writes == 0 and snapshot(running.root) == beforePlay)
print(string.format("Studio patch installer: %d checks passed", passed))
