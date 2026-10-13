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

-- A small invisible Roblox walking surface lets the avatar reach the anchored
-- driver's seat. The car's native world never queries this presentation part.
function M.prepareDriverSpawn(controller, world)
    if not controller.originalTrack then return end
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
    return spawn
end

return M
