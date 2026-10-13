-- Generated Watkins Glen visual installer: watkins_glen_terrain_069.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_terrain_069"
local KIND = "terrain"
local SOURCE_HASH = "d7326dd7d1abe71f7741f02c29be9439893ce5b2a8335e3cda4084ab98e3e8d1"
local GEOMETRIES = {
    {name="G000_terrain_106_10_part1",center=Vector3.new(1393.407004,87.108963,98.067151),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G001_terrain_107_00",center=Vector3.new(1147.457286,81.906792,215.948405),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G002_terrain_107_01",center=Vector3.new(1226.568767,81.917759,196.014234),opacity=1.0,blend=false,texture="trackmat__curbing2"},
    {name="G003_terrain_107_02",center=Vector3.new(1233.13773,82.407801,194.360495),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G004_terrain_107_03",center=Vector3.new(1236.675589,82.852289,191.094208),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G005_terrain_107_04",center=Vector3.new(1239.212309,83.137362,191.969619),opacity=1.0,blend=false,texture="trackmat__paint"},
    {name="G006_terrain_107_05",center=Vector3.new(1248.11761,84.073305,189.4035),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G007_terrain_107_06",center=Vector3.new(1263.654545,85.799401,182.932111),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G008_terrain_107_07",center=Vector3.new(1275.314931,87.108384,180.340719),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G009_terrain_107_08_baked_f_0",center=Vector3.new(1293.287877,87.108387,173.032849),opacity=1.0,blend=false,texture="baked_f_06811_00_00"},
    {name="G010_terrain_107_09",center=Vector3.new(1404.343578,87.108561,132.342223),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G011_terrain_108_00",center=Vector3.new(1149.631882,82.164093,230.161238),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G012_terrain_108_01",center=Vector3.new(1231.454304,82.197758,211.773314),opacity=1.0,blend=false,texture="trackmat__curbing2"},
    {name="G013_terrain_108_02",center=Vector3.new(1238.064248,82.678601,210.181761),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G014_terrain_108_03",center=Vector3.new(1244.408635,83.342017,208.751903),opacity=1.0,blend=false,texture="trackmat__paint"},
    {name="G015_terrain_108_04",center=Vector3.new(1253.639821,84.291976,206.591191),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G016_terrain_108_05",center=Vector3.new(1271.405302,86.134733,202.316516),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G017_terrain_108_06",center=Vector3.new(1281.574413,87.111739,200.074734),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G018_terrain_108_07_baked_f_0",center=Vector3.new(1284.627914,87.11179,199.348177),opacity=1.0,blend=false,texture="baked_f_06870_00_00"},
    {name="G019_terrain_108_08_baked_f_0",center=Vector3.new(1301.714379,87.11211,195.221819),opacity=1.0,blend=false,texture="baked_f_06873_00_00"},
    {name="G020_terrain_108_09",center=Vector3.new(1410.304424,87.114177,169.21102),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G021_terrain_109_00",center=Vector3.new(1152.212197,82.615508,235.070794),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G022_terrain_109_01",center=Vector3.new(1234.257398,82.671871,232.206263),opacity=1.0,blend=false,texture="trackmat__curbing2"},
}
local root = workspace:FindFirstChild("NR2003WatkinsGlen")
assert(not root or root:IsA("Model"), "Workspace.NR2003WatkinsGlen must be a Model")
local existing = root and root:FindFirstChild(PACKAGE)
-- Check this before Selection: a selected wrapper can also contain markers
-- belonging to another, still-uninstalled chunk after a partial master run.
if existing and existing:GetAttribute("NR2003SourceHash") == SOURCE_HASH then
    for _, g in ipairs(GEOMETRIES) do
        local p = existing:FindFirstChild(g.name, true)
        assert(p and p:IsA("MeshPart"), "Installed chunk is missing " .. g.name)
    end
    print(PACKAGE .. " already installed and calibrated")
    return
end
local selected = Selection:Get()
local function completeImport(item)
    if not item or not (item:IsA("Model") or item:IsA("Folder")) or item == root then return false end
    local markerCounts = {NR2003_MARKER_O=0, NR2003_MARKER_X=0, NR2003_MARKER_Y=0, NR2003_MARKER_Z=0}
    for _, p in ipairs(item:GetDescendants()) do
        if p:IsA("BasePart") and markerCounts[p.Name] then markerCounts[p.Name] += 1 end
    end
    for _, count in pairs(markerCounts) do if count ~= 1 then return false end end
    for _, g in ipairs(GEOMETRIES) do
        local p = item:FindFirstChild(g.name, true)
        if not p or not p:IsA("MeshPart") then return false end
    end
    return true
end
local named = workspace:FindFirstChild(PACKAGE)
local src = completeImport(named) and named or nil
if not src then
    for _, item in ipairs(selected) do
        local candidate = item:FindFirstChild(PACKAGE, true)
        if completeImport(candidate) then src = candidate; break end
        if completeImport(item) then src = item; break end
    end
end
-- Studio can append a suffix when an empty, history-reverted import still
-- occupies PACKAGE. Resolve a complete chunk by its content, not its label.
if not src then
    local candidates = {}
    for _, item in ipairs(workspace:GetDescendants()) do
        if completeImport(item) then table.insert(candidates, item) end
    end
    local innermost = {}
    for _, candidate in ipairs(candidates) do
        local containsCandidate = false
        for _, other in ipairs(candidates) do
            if other ~= candidate and other:IsDescendantOf(candidate) then containsCandidate = true; break end
        end
        if not containsCandidate then table.insert(innermost, candidate) end
    end
    assert(#innermost <= 1, "More than one complete import for " .. PACKAGE .. "; select the intended chunk model")
    src = innermost[1]
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
-- Keep original marker meshes and their Node parents intact. Destroying them
-- can break Studio/Team Create history replay with a locked Parent = NULL.
-- The whole remainder lives in ServerStorage, outside the rendered world.
src.Name = PACKAGE .. "_ImportRemainder_" .. os.time()
src.Parent = backup
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
