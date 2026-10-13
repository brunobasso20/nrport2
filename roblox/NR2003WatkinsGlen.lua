-- Roblox presentation adapter for the recovered Watkins Glen world.
-- Physics, materials, bump sampling and barrier forces belong to NR2003CupTrack.
-- This module only selects a common render origin and the original test spawn.
local M = {}
M.TRACK = "watkins_glen"
M.METRES_PER_STUD = 0.28

function M.enabled(package)
    return package:GetAttribute("NR2003Track") == M.TRACK
end

function M.origin(controller)
    local model = assert(workspace:FindFirstChild("NR2003WatkinsGlen"),
        "Import the Watkins Glen visuals and run INSTALL_TRACK_VISUALS before driving")
    assert(model:IsA("Model") and model:GetAttribute("TrackOriginEnabled") == true,
        "Watkins Glen visuals have not been calibrated by the asset installer")
    controller.trackModel = model
    return model:GetPivot()
end

function M.attach(controller)
    local package = script.Parent.Parent
    if not M.enabled(package) then return false end
    assert(math.abs(controller.tune.metresPerStud - M.METRES_PER_STUD) < 1e-12,
        "Watkins Glen and the car must both use 0.28 metres per stud")
    assert(controller.core.V.loadTrack, "Install the recovered Watkins Glen core modules first")
    M.origin(controller)
    controller.core:loadTrack()
    controller.originalTrack = true
    controller.trackPositionOut = {}
    controller.trackContactOut = {}
    local stalls = controller.core.V.trackStalls
    local stall = assert(stalls and stalls[1], "Watkins Glen original pit spawn is missing")
    local function number(name, default)
        local value = controller.car:GetAttribute(name)
        if type(value) == "number" and value == value and math.abs(value) < math.huge then return value end
        return default
    end
    controller.core.V.setTrackStart(number("TrackDlong", stall[1]), number("TrackDlat", stall[2]),
        number("TrackYaw", stall[3]))
    controller.car:SetAttribute("NR2003Track", M.TRACK)
    controller.car:SetAttribute("TrackContactMode", "NR2003 original world")
    return true
end

function M.checkSession(controller)
    assert(controller.car:GetAttribute("AeroSession") ~= false,
        "Watkins Glen requires an active original NR2003 session (AeroSession must be enabled)")
    assert(controller.car:GetAttribute("Stage11Runtime") ~= "frozen",
        "Watkins Glen requires the original tire thermal/wear runtime")
end

-- Read-only diagnostics. They never become input to the contact solver.
function M.update(controller)
    local V = controller.core.V
    if V.trackPosition then
        local p = V.trackPosition(controller.trackPositionOut)
        controller.car:SetAttribute("TrackDlongCurrent", p.dlong)
        controller.car:SetAttribute("TrackDlatCurrent", p.dlat)
        controller.car:SetAttribute("TrackSurface", p.surface)
    end
    if V.trackContact then
        for j = 1, 4 do
            local c = V.trackContact(j - 1, controller.trackContactOut)
            controller.inContact[j] = c.grounded == true
            controller.planes[j][8] = c.surface or 0
        end
    end
end

function M.clearDriverSpawn(controller)
    local state = controller.trackDriverSpawn
    if not state or state.closed then return end
    state.closed = true
    controller.trackDriverSpawn = nil
    for _, connection in ipairs(state.connections) do connection:Disconnect() end
    for player, entry in pairs(state.players) do
        entry.connection:Disconnect()
        if player.Parent == state.service and player.RespawnLocation == state.spawn then
            local previous = entry.previous
            if previous and not previous:IsDescendantOf(workspace) then previous = nil end
            player.RespawnLocation = previous
        end
    end
    state.players = {}
    if state.spawn.Parent and not state.spawnDestroying then state.spawn:Destroy() end
end

-- An avatar can already exist when the recovered core finishes initializing.
-- Select the new spawn for subsequent characters and bring existing characters
-- onto its walking surface. No avatar placement enters the native car solver.
local function bindDriverSpawn(controller, spawn)
    local players = game:GetService("Players")
    local state = {spawn = spawn, service = players, connections = {}, players = {}, closed = false}
    controller.trackDriverSpawn = state
    local function place(player, character)
        task.defer(function()
            if state.closed or player.Parent ~= players or player.Character ~= character then return end
            local root = character:WaitForChild("HumanoidRootPart", 10)
            local humanoid = character:WaitForChild("Humanoid", 10)
            if not root or not humanoid or state.closed or player.Parent ~= players or player.Character ~= character
                or not spawn.Parent or humanoid.Health <= 0 or humanoid.SeatPart then return end
            -- Keep a character already standing nearby in place. Otherwise put
            -- its root above the platform, preserving the avatar's orientation.
            if (root.Position - spawn.Position).Magnitude > 12 then
                local destination = spawn.Position + Vector3.new(0, 4, 0)
                character:PivotTo(character:GetPivot() + (destination - root.Position))
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end
        end)
    end
    local function bind(player)
        if state.closed or state.players[player] or player.Parent ~= players then return end
        local previous = player.RespawnLocation
        local connection = player.CharacterAdded:Connect(function(character) place(player, character) end)
        state.players[player] = {connection = connection, previous = previous}
        player.RespawnLocation = spawn
        if player.Character then place(player, player.Character) end
    end
    state.connections[1] = players.PlayerAdded:Connect(bind)
    state.connections[2] = players.PlayerRemoving:Connect(function(player)
        local entry = state.players[player]
        if entry then entry.connection:Disconnect(); state.players[player] = nil end
    end)
    state.connections[3] = spawn.Destroying:Connect(function()
        state.spawnDestroying = true
        M.clearDriverSpawn(controller)
    end)
    for _, player in ipairs(players:GetPlayers()) do bind(player) end
end

-- A small invisible Roblox walking surface lets the avatar reach the anchored
-- driver's seat. The car's native world never queries this presentation part.
function M.prepareDriverSpawn(controller, world)
    if not controller.originalTrack then return end
    M.clearDriverSpawn(controller)
    controller.car:PivotTo(controller.rootCF)
    local p = controller.core.V.trackPosition(controller.trackPositionOut)
    local surface = controller:worldPoint(p.x, p.y, p.bumpedZ)
    local spawn = world:FindFirstChild("WatkinsGlenDriverSpawn") or Instance.new("SpawnLocation")
    spawn.Name = "WatkinsGlenDriverSpawn"
    spawn.Size = Vector3.new(40, 0.5, 40)
    spawn.CFrame = (controller.rootCF - controller.rootCF.Position) + surface
        + controller.rootCF.RightVector * 7 - controller.rootCF.UpVector * 0.25
    spawn.Anchored = true
    spawn.CanCollide = true
    spawn.CanTouch = false
    spawn.CanQuery = false
    spawn.Transparency = 1
    spawn.Neutral = true
    spawn.Duration = 0
    spawn:SetAttribute("NR2003AvatarOnly", true)
    spawn.Parent = world
    bindDriverSpawn(controller, spawn)
    return spawn
end

return M
