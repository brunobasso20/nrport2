-- Generated Watkins Glen visual installer: watkins_glen_terrain_016.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_terrain_016"
local KIND = "terrain"
local SOURCE_HASH = "154b1d1bde489c442c34f50ab7a25e318799d8d972b1a15eceb52a7c54c36120"
local GEOMETRIES = {
    {name="G000_terrain_020_07_part2",center=Vector3.new(-528.009333,30.465364,2235.101754),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G001_terrain_021_00",center=Vector3.new(-234.423351,39.877311,2106.603023),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G002_terrain_021_01_baked_f_0",center=Vector3.new(-341.784014,37.030935,2119.595773),opacity=1.0,blend=false,texture="baked_f_01850_00_00"},
    {name="G003_terrain_021_02",center=Vector3.new(-354.496969,37.363357,2116.514369),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G004_terrain_021_03_baked_f_0",center=Vector3.new(-362.977941,37.029496,2122.062574),opacity=1.0,blend=false,texture="baked_f_01856_00_00"},
    {name="G005_terrain_021_04",center=Vector3.new(-369.194957,36.865221,2122.951399),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G006_terrain_021_05",center=Vector3.new(-390.874972,36.866675,2125.585938),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G007_terrain_021_06",center=Vector3.new(-413.041374,37.995141,2128.257533),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G008_terrain_021_07",center=Vector3.new(-537.012877,37.99564,2143.640137),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G009_terrain_022_00",center=Vector3.new(-259.887654,52.369922,1937.212372),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G010_terrain_022_01_baked_f_0",center=Vector3.new(-367.787947,52.369913,1955.595071),opacity=1.0,blend=false,texture="baked_f_01915_00_00"},
    {name="G011_terrain_022_02",center=Vector3.new(-389.657266,52.369913,1955.97338),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G012_terrain_022_03",center=Vector3.new(-411.247826,52.369913,1958.627646),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G013_terrain_022_04",center=Vector3.new(-433.128984,51.513588,1961.332376),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G014_terrain_022_05",center=Vector3.new(-555.205536,52.371371,1976.458195),opacity=1.0,blend=false,texture="trackmat__grass"},
}
local selected = Selection:Get()
local src
for _, item in ipairs(selected) do
    if (item:IsA("Model") or item:IsA("Folder")) and item:FindFirstChild("NR2003_MARKER_O", true) then
        local complete = true
        for _, g in ipairs(GEOMETRIES) do if not item:FindFirstChild(g.name, true) then complete = false; break end end
        if complete then src = item; break end
    end
end
if not src then src = workspace:FindFirstChild(PACKAGE) end
local root = workspace:FindFirstChild("NR2003WatkinsGlen")
assert(not root or root:IsA("Model"), "Workspace.NR2003WatkinsGlen must be a Model")
local existing = root and root:FindFirstChild(PACKAGE)
if not src and existing and existing:GetAttribute("NR2003SourceHash") == SOURCE_HASH then
    print(PACKAGE .. " already installed and calibrated")
    return
end
assert(src and (src:IsA("Model") or src:IsA("Folder")), "Import " .. PACKAGE .. ".glb, or select its imported model")
assert(src ~= root, "Select the imported chunk, not the complete track model")
local function marker(name)
    local p = src:FindFirstChild(name, true)
    assert(p and p:IsA("BasePart"), "Missing calibration marker " .. name .. "; import the complete GLB")
    return p
end
local markers = {marker("NR2003_MARKER_O"), marker("NR2003_MARKER_X"), marker("NR2003_MARKER_Y"), marker("NR2003_MARKER_Z")}
local origin = markers[1].Position
local ex, ey, ez = (markers[2].Position-origin)/4, (markers[3].Position-origin)/4, (markers[4].Position-origin)/4
local k = ex.Magnitude
assert(k > 1e-6, "Degenerate calibration markers")
local qx, qy, qz = ex/k, ey/k, ez/k
local error = math.max(math.abs(qx:Dot(qy)), math.abs(qy:Dot(qz)), math.abs(qz:Dot(qx)),
    math.abs(ey.Magnitude/k-1), math.abs(ez.Magnitude/k-1), math.abs(qx:Cross(qy):Dot(qz)-1))
assert(error < 1e-3, "Importer applied a nonuniform or reflected transform; calibration error " .. error)
-- Marker tetrahedron bounding-box centre is 1/4 of its 0.25-stud edge offset.
local offset = 0.0625
local importedFrame = CFrame.fromMatrix(origin-(qx+qy+qz)*offset*k, qx, qy, qz)
local prepared = {}
local missingTextures = 0
for _, g in ipairs(GEOMETRIES) do
    local p = src:FindFirstChild(g.name, true)
    assert(p and p:IsA("MeshPart"), "Missing imported MeshPart " .. g.name)
    local cf = importedFrame:ToObjectSpace(p.CFrame)
    local centre = cf.Position/k
    assert((centre-g.center).Magnitude < 0.15,
        "Geometry centre differs from original for " .. g.name .. "; disable importer per-object recentering")
    local appearance = p:FindFirstChildOfClass("SurfaceAppearance")
    if g.texture ~= "untextured" and not appearance and p.TextureID == "" then missingTextures += 1 end
    table.insert(prepared, {part=p, geometry=g, cf=CFrame.new(centre)*(cf-cf.Position), size=p.Size/k})
end
-- Every marker and geometry was validated before editing the place.
local backup = storage:FindFirstChild("NR2003Backup_TrackVisuals")
if not backup then backup = Instance.new("Folder"); backup.Name = "NR2003Backup_TrackVisuals"; backup.Parent = storage end
if not root then root = Instance.new("Model"); root.Name = "NR2003WatkinsGlen"; root.WorldPivot = CFrame.identity; root.Parent = workspace end
if existing and existing ~= src then existing.Name = PACKAGE .. "_" .. os.time(); existing.Parent = backup end
local installed = Instance.new("Model")
installed.Name = PACKAGE
installed.WorldPivot = CFrame.identity
for _, item in ipairs(prepared) do
    local p, g = item.part, item.geometry
    p.Anchored = true
    p.CanCollide = false
    -- The existing car client's chase camera queries terrain for clearance.
    -- Vehicle contacts continue to use the recovered NR2003 world exclusively.
    p.CanQuery = (KIND == "terrain")
    p:SetAttribute("NR2003TerrainQuery", KIND == "terrain")
    p.CanTouch = false
    p.Size = item.size
    p.CFrame = item.cf
    p.Transparency = 1-g.opacity
    p.CastShadow = true
    p.DoubleSided = true
    local appearance = p:FindFirstChildOfClass("SurfaceAppearance")
    if not appearance and g.blend and p.TextureID ~= "" then
        appearance = Instance.new("SurfaceAppearance")
        appearance.ColorMap = p.TextureID
        appearance.Parent = p
    end
    if appearance then appearance.AlphaMode = g.blend and Enum.AlphaMode.Transparency or Enum.AlphaMode.Overlay end
    p.Parent = installed
end
for _, p in ipairs(markers) do p:Destroy() end
if #src:GetDescendants() == 0 then src:Destroy() else src.Name = PACKAGE .. "_ImportRemainder_" .. os.time(); src.Parent = backup end
installed:SetAttribute("NR2003SourceHash", SOURCE_HASH)
installed:SetAttribute("NR2003OriginalScale", k)
installed:SetAttribute("NR2003VisualKind", KIND)
installed.Parent = root
root.WorldPivot = CFrame.identity
root:SetAttribute("TrackOriginEnabled", true)
root:SetAttribute("NR2003MetresPerStud", 0.28)
print(string.format("Installed %s: %d original mesh parts; importer scale %.9g undone; collision disabled", PACKAGE, #prepared, k))
if missingTextures > 0 then warn(missingTextures .. " parts have no imported texture; check Asset Manager image moderation") end
print("Track origin is CFrame.identity. The place has not been saved.")
