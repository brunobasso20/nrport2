-- Startup, seat admission and cleanup scenarios, with the actual host + SeatAccess.
Vector3.__eq = function(a, b) return a.X == b.X and a.Y == b.Y and a.Z == b.Z end
local function signal()
    local s = {connections = {}}
    function s:Connect(callback)
        local c = {active = true, callback = callback}
        function c:Disconnect() self.active = false end
        table.insert(self.connections, c)
        return c
    end
    function s:Fire(...)
        for _, c in ipairs(table.clone(self.connections)) do if c.active then c.callback(...) end end
    end
    return s
end
local queue = {}
local task = {defer = function(callback) table.insert(queue, callback) end}
local function flush()
    while #queue > 0 do table.remove(queue, 1)() end
end
local Node = {}
local Meta = {}
Meta.__index = function(o, key)
    if key == "Parent" then return rawget(o, "parent") end
    if key == "Position" then return o.CFrame.Position end
    if Node[key] then return Node[key] end
    for _, child in ipairs(o.children) do if child.Name == key then return child end end
end
Meta.__newindex = function(o, key, value)
    if key == "Parent" then
        local old = rawget(o, "parent")
        if old then for i, c in ipairs(old.children) do if c == o then table.remove(old.children, i); break end end end
        rawset(o, "parent", value)
        if value then table.insert(value.children, o) end
    else rawset(o, key, value) end
end
local Instance = {}
function Instance.new(class)
    local object = setmetatable({ClassName = class, Name = class, children = {}, attrs = {}, Destroying = signal()}, Meta)
    if class == "ProximityPrompt" then object.Triggered = signal() end
    return object
end
function Node:GetChildren() return table.clone(self.children) end
function Node:FindFirstChild(name) for _, c in ipairs(self.children) do if c.Name == name then return c end end end
function Node:WaitForChild(name) return self:FindFirstChild(name) end
function Node:FindFirstChildOfClass(class) for _, c in ipairs(self.children) do if c.ClassName == class then return c end end end
function Node:IsA(class) return self.ClassName == class end
function Node:SetAttribute(name, value) self.attrs[name] = value end
function Node:GetAttribute(name) return self.attrs[name] end
function Node:IsDescendantOf(parent)
    local at = self.Parent
    while at do if at == parent then return true end; at = at.Parent end
    return false
end
function Node:Destroy()
    assert(not self.destroying, "Recursive destruction")
    self.destroying = true
    self.Destroying:Fire()
    self.Parent = nil
    self.destroyed = true
end
function Node:SetNetworkOwner() end
function Node:GetPropertyChangedSignal(name)
    self.propertySignals = self.propertySignals or {}
    self.propertySignals[name] = self.propertySignals[name] or signal()
    return self.propertySignals[name]
end
function Node:GetPivot()
    if self.Chassis then return self.Chassis.CFrame end
    return self.HumanoidRootPart.CFrame
end
function Node:PivotTo(cf)
    if self.Chassis then
        self.Chassis.CFrame = cf
        self.DriverSeat.CFrame = cf * CFrame.new(-1.25, 1.14, 0.357)
    else self.HumanoidRootPart.CFrame = cf end
end
function Node:Sit(humanoid)
    self.Occupant = humanoid
    humanoid.SeatPart = self
    self:GetPropertyChangedSignal("Occupant"):Fire()
end
local function make(class, name, parent)
    local o = Instance.new(class); o.Name = name; o.Parent = parent
    return o
end
local workspace, players
local function load(source, env)
    local f = assert(loadstring(source))
    setfenv(f, setmetatable(env or {}, {__index = _G}))
    return f()
end
local config = load(CONFIG_SOURCE)
local Enum = {KeyCode = {F = "F"}}
local game = {GetService = function(_, name) assert(name == "Players"); return players end}
local function character(player, position, withRoot)
    local char = make("Model", "Character", workspace)
    if withRoot ~= false then
        local root = make("Part", "HumanoidRootPart", char)
        root.CFrame = CFrame.new(position); root.Anchored = false
        root.AssemblyLinearVelocity = Vector3.new(0, -30, 0)
        root.AssemblyAngularVelocity = Vector3.zero
    end
    local humanoid = make("Humanoid", "Humanoid", char); humanoid.Health = 100
    player.Character = char
    return char
end
local function player(position)
    local p = make("Player", "Driver", players)
    p.UserId = #players.list + 1; p.CharacterAdded = signal()
    if position then character(p, position) end
    table.insert(players.list, p)
    return p
end
local function fixture(position)
    queue = {}
    workspace = Instance.new("Workspace")
    players = Instance.new("Players"); players.list = {}
    players.PlayerAdded = signal(); players.PlayerRemoving = signal()
    function players:GetPlayers() return table.clone(self.list) end
    function players:GetPlayerFromCharacter(char)
        for _, p in ipairs(self.list) do if p.Character == char then return p end end
    end
    local world = make("Folder", "NR2003LabWorld", workspace)
    local car = make("Model", "TestCar", world)
    local root = make("Part", "Chassis", car); root.CFrame = CFrame.new(0, 2.65, 0); root.Anchored = true
    local seat = make("VehicleSeat", "DriverSeat", car); seat.CFrame = root.CFrame; seat.Anchored = false
    car:SetAttribute("NR2003CorePoseOwner", true)
    local ctl = {car = car, originalTrack = true, trackPositionOut = {}, core = {V = {}}, calls = 0}
    function ctl.core.V.trackPosition() return {x = 1375, y = -263, z = 51, bumpedZ = 50.58} end
    function ctl:worldPoint(x, y, z) return Vector3.new(-y, z, -x) / 0.28 end
    ctl.rootCF = CFrame.new(ctl:worldPoint(1375, -263, 51))
    local host = load(HOST_SOURCE, {workspace = workspace, game = game, Instance = Instance,
        task = task, Vector3 = Vector3, CFrame = CFrame})
    local access = load(ACCESS_SOURCE, {game = game, Instance = Instance, Enum = Enum,
        script = {Parent = {DriverConfig = "config"}}, require = function(ref) assert(ref == "config"); return config end})
    local remote = {messages = {}}
    function remote:FireClient(_, message) table.insert(self.messages, message) end
    ctl.access = access.new(car, remote)
    local p = position and player(position) or nil
    return {world = world, car = car, controller = ctl, host = host, player = p, remote = remote}
end
local passed, failed = 0, 0
local function check(name, ok)
    if ok then passed += 1 else failed += 1 end
    print((ok and "PASS " or "FAIL ") .. name)
end
local f = fixture(Vector3.new(10, 4, 8))
local before = f.player.Character.HumanoidRootPart.Position
local spawn = f.host.prepareDriverSpawn(f.controller, f.world)
check("existing avatar is queued without blocking core startup", #queue == 1 and f.player.Character.HumanoidRootPart.Position == before)
flush()
local root = f.player.Character.HumanoidRootPart
check("avatar born before core initialization is moved within actual entry distance", (root.Position - f.car.DriverSeat.Position).Magnitude <= config.entryDistanceStuds)
check("avatar velocity cleared and next respawn selects track platform", root.AssemblyLinearVelocity.Magnitude == 0 and f.player.RespawnLocation == spawn)
check("avatar-only platform stays outside car query/contact flags", spawn.Anchored and spawn.CanCollide and not spawn.CanQuery and not spawn.CanTouch and spawn:GetAttribute("NR2003AvatarOnly") == true)
local admitted = f.controller.access:request(f.player)
check("actual SeatAccess admits existing avatar and confirms seat Occupant", admitted and f.car.DriverSeat.Occupant == f.player.Character.Humanoid and f.car:GetAttribute("EntryStatus") == "seated")
local seatedPosition = root.Position
f.host.prepareDriverSpawn(f.controller, f.world); flush()
local active = 0
for _, connection in ipairs(players.PlayerAdded.connections) do if connection.active then active += 1 end end
check("repeated preparation keeps seated driver and one player binding", root.Position == seatedPosition and f.car.DriverSeat.Occupant == f.player.Character.Humanoid and active == 1)
f.host.clearDriverSpawn(f.controller)
check("cleanup restores prior respawn and removes track platform", f.player.RespawnLocation == nil and not f.world:FindFirstChild("WatkinsGlenDriverSpawn") and not f.controller.trackDriverSpawn)

f = fixture(); spawn = f.host.prepareDriverSpawn(f.controller, f.world)
local p = player(); players.PlayerAdded:Fire(p)
local char = character(p, Vector3.new(0, 0, 0), false)
p.CharacterAdded:Fire(char)
local late = make("Part", "HumanoidRootPart", char); late.CFrame = CFrame.new(0, 0, 0); late.Anchored = false
flush()
check("later player and root arriving after CharacterAdded reach track", p.RespawnLocation == spawn and (late.Position - f.car.DriverSeat.Position).Magnitude <= config.entryDistanceStuds)
char = character(p, Vector3.new(0, 0, 0)); p.CharacterAdded:Fire(char); flush()
check("subsequent respawn reaches same track platform", (char.HumanoidRootPart.Position - f.car.DriverSeat.Position).Magnitude <= config.entryDistanceStuds)

f = fixture(Vector3.new(0, 0, 0)); spawn = f.host.prepareDriverSpawn(f.controller, f.world)
local stale = f.player.Character
local current = character(f.player, Vector3.new(0, 0, 0)); f.player.CharacterAdded:Fire(current); flush()
check("stale character callback does not move replaced character", stale.HumanoidRootPart.Position.Magnitude == 0 and (current.HumanoidRootPart.Position - f.car.DriverSeat.Position).Magnitude <= config.entryDistanceStuds)

f = fixture(Vector3.new(0, 0, 0)); f.host.prepareDriverSpawn(f.controller, f.world)
f.host.clearDriverSpawn(f.controller); flush()
check("queued callbacks stop after controller cleanup", f.player.Character.HumanoidRootPart.Position.Magnitude == 0)

f = fixture(Vector3.new(0, 0, 0)); spawn = f.host.prepareDriverSpawn(f.controller, f.world)
spawn:Destroy(); flush()
check("external platform destruction avoids recursive Destroy and releases binding", not f.controller.trackDriverSpawn and f.player.RespawnLocation == nil)

f = fixture(Vector3.new(0, 0, 0))
local previous = make("SpawnLocation", "PreviousSpawn", workspace); f.player.RespawnLocation = previous
f.host.prepareDriverSpawn(f.controller, f.world); flush(); f.host.clearDriverSpawn(f.controller)
check("valid original player RespawnLocation preserved through cleanup", f.player.RespawnLocation == previous)

f = fixture(Vector3.new(0, 0, 0)); spawn = f.host.prepareDriverSpawn(f.controller, f.world)
local another = make("SpawnLocation", "ExternalSpawn", workspace); f.player.RespawnLocation = another
f.host.clearDriverSpawn(f.controller)
check("external respawn selection made during driving is preserved", f.player.RespawnLocation == another)

f = fixture(Vector3.new(0, 0, 0)); f.controller.originalTrack = false
local result = f.host.prepareDriverSpawn(f.controller, f.world)
check("legacy bench mode keeps original car and avatar spawn", result == nil and #queue == 0 and f.player.RespawnLocation == nil and f.car:GetPivot().Position.Y == 2.65)
print(string.format("track spawn mock: %d passed, %d failed", passed, failed))
assert(failed == 0, "track spawn mock failed")
