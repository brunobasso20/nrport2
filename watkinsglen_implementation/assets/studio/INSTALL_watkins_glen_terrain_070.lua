-- Generated Watkins Glen visual installer: watkins_glen_terrain_070.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_terrain_070"
local KIND = "terrain"
local SOURCE_HASH = "ff1e525ee40b613966f6f7d33c0aa3554f76add1b3a9598d2d8499df77d05a14"
local GEOMETRIES = {
    {name="G000_terrain_109_02",center=Vector3.new(1241.034426,83.041014,230.823387),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G001_terrain_109_03",center=Vector3.new(1247.40012,83.690398,230.553947),opacity=1.0,blend=false,texture="trackmat__paint"},
    {name="G002_terrain_109_04",center=Vector3.new(1250.668008,83.962001,231.551763),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G003_terrain_109_05",center=Vector3.new(1259.680721,84.717665,228.443643),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G004_terrain_109_06",center=Vector3.new(1275.128392,86.17925,226.092924),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G005_terrain_109_07",center=Vector3.new(1284.864262,87.190666,225.689295),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G006_terrain_109_08_baked_f_0",center=Vector3.new(1288.18561,87.486618,225.16923),opacity=1.0,blend=false,texture="baked_f_06935_00_00"},
    {name="G007_terrain_109_09_baked_f_0",center=Vector3.new(1304.140472,87.486686,221.756097),opacity=1.0,blend=false,texture="baked_f_06938_00_00"},
    {name="G008_terrain_109_10",center=Vector3.new(1413.204139,87.487085,200.316525),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G009_terrain_110_00",center=Vector3.new(1154.070227,83.268339,262.658542),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G010_terrain_110_01",center=Vector3.new(1236.411067,83.276936,262.684672),opacity=1.0,blend=false,texture="trackmat__curbing2"},
    {name="G011_terrain_110_02",center=Vector3.new(1243.20597,83.715149,262.98884),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G012_terrain_110_03",center=Vector3.new(1249.716405,84.254898,263.001987),opacity=1.0,blend=false,texture="trackmat__paint"},
    {name="G013_terrain_110_04",center=Vector3.new(1254.109464,84.59285,263.278648),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G014_terrain_110_05",center=Vector3.new(1266.439111,85.473388,263.730976),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G015_terrain_110_06",center=Vector3.new(1280.815342,86.580886,263.901656),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G016_terrain_110_07",center=Vector3.new(1289.986038,87.623508,264.015307),opacity=1.0,blend=false,texture="trackmat__curbing_asphalt"},
    {name="G017_terrain_110_08",center=Vector3.new(1292.938014,88.016265,265.343298),opacity=1.0,blend=false,texture="trackmat__asphalt_rumble"},
    {name="G018_terrain_110_09_baked_f_0",center=Vector3.new(1301.039505,88.001333,264.299897),opacity=1.0,blend=false,texture="baked_f_07007_00_00"},
    {name="G019_terrain_110_10_baked_f_0",center=Vector3.new(1312.855312,88.001197,264.53995),opacity=1.0,blend=false,texture="baked_f_07011_00_00"},
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
