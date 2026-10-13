-- Generated Watkins Glen visual installer: watkins_glen_terrain_007.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_terrain_007"
local KIND = "terrain"
local SOURCE_HASH = "16fadde925ba41e038fbcd09b4f80c5346e5cb991dabffe479af776920e916be"
local GEOMETRIES = {
    {name="G000_terrain_010_10",center=Vector3.new(918.672344,18.787501,3099.397605),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G001_terrain_011_00",center=Vector3.new(895.508984,16.990477,2704.214369),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G002_terrain_011_01_baked_f_0",center=Vector3.new(889.564133,16.253808,2734.351785),opacity=1.0,blend=false,texture="baked_f_01327_00_00"},
    {name="G003_terrain_011_02_baked_f_0",center=Vector3.new(883.063262,15.194309,2771.104431),opacity=1.0,blend=false,texture="baked_f_01330_00_00"},
    {name="G004_terrain_011_03",center=Vector3.new(878.319168,13.972061,2789.98424),opacity=1.0,blend=false,texture="trackmat__curbing2"},
    {name="G005_terrain_011_04",center=Vector3.new(875.30444,14.686106,2801.299286),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G006_terrain_011_05",center=Vector3.new(871.086747,16.436934,2825.44839),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G007_terrain_011_06",center=Vector3.new(868.966484,17.675178,2840.983037),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G008_terrain_011_07",center=Vector3.new(866.775567,18.19499,2848.04524),opacity=1.0,blend=false,texture="trackmat__curbing_left"},
    {name="G009_terrain_011_08",center=Vector3.new(864.881516,18.500829,2856.941005),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G010_terrain_011_09",center=Vector3.new(851.220049,18.370577,2931.44346),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G011_terrain_011_10",center=Vector3.new(817.451477,18.013666,3083.898926),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G012_terrain_012_00",center=Vector3.new(860.125296,14.12565,2710.433415),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G013_terrain_012_01_baked_f_0",center=Vector3.new(851.440511,13.53246,2753.815242),opacity=1.0,blend=false,texture="baked_f_01403_00_00"},
    {name="G014_terrain_012_02",center=Vector3.new(849.289976,13.619319,2779.614803),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G015_terrain_012_03",center=Vector3.new(840.05691,15.423431,2810.40693),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G016_terrain_012_04",center=Vector3.new(833.919961,17.454159,2840.756335),opacity=1.0,blend=false,texture="trackmat__curbing_left"},
    {name="G017_terrain_012_05",center=Vector3.new(832.251358,17.73299,2849.47804),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G018_terrain_012_06",center=Vector3.new(819.369807,17.623754,2916.629791),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G019_terrain_012_07",center=Vector3.new(786.070551,17.331753,3073.54344),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G020_terrain_013_00",center=Vector3.new(834.972436,12.938388,2713.958522),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G021_terrain_013_01_baked_f_0",center=Vector3.new(826.211166,12.964321,2760.333797),opacity=1.0,blend=false,texture="baked_f_01460_00_00"},
    {name="G022_terrain_013_02",center=Vector3.new(816.588456,15.113497,2805.673218),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G023_terrain_013_03",center=Vector3.new(810.55979,16.902876,2835.846274),opacity=1.0,blend=false,texture="trackmat__curbing_left"},
    {name="G024_terrain_013_04",center=Vector3.new(808.93086,17.125083,2843.680573),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G025_terrain_013_05",center=Vector3.new(797.003746,17.04503,2906.940678),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G026_terrain_013_06",center=Vector3.new(763.395446,16.80162,3064.142282),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G027_terrain_014_00",center=Vector3.new(795.132337,12.81117,2713.528224),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G028_terrain_014_01_baked_f_0",center=Vector3.new(786.5745,12.852064,2761.682565),opacity=1.0,blend=false,texture="baked_f_01513_00_00"},
    {name="G029_terrain_014_02",center=Vector3.new(778.308623,14.682701,2797.998701),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G030_terrain_014_03",center=Vector3.new(772.489411,15.955574,2827.463749),opacity=1.0,blend=false,texture="trackmat__curbing_left"},
    {name="G031_terrain_014_04",center=Vector3.new(770.99593,16.07691,2834.238543),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G032_terrain_014_05",center=Vector3.new(760.784885,16.039775,2892.979431),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G033_terrain_014_06",center=Vector3.new(725.962666,15.885834,3047.092874),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G034_terrain_015_00",center=Vector3.new(745.963669,12.761426,2705.95714),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G035_terrain_015_01_baked_f_0",center=Vector3.new(739.267186,12.672014,2745.26062),opacity=1.0,blend=false,texture="baked_f_01570_00_00"},
    {name="G036_terrain_015_02_baked_f_0",center=Vector3.new(737.764331,12.805132,2756.039974),opacity=1.0,blend=false,texture="baked_f_01574_00_00"},
    {name="G037_terrain_015_03",center=Vector3.new(730.622646,13.953386,2788.384574),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G038_terrain_015_04",center=Vector3.new(724.833652,14.681176,2816.654205),opacity=1.0,blend=false,texture="trackmat__curbing_left"},
    {name="G039_terrain_015_05",center=Vector3.new(689.674377,14.691186,2987.713623),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G040_terrain_016_00",center=Vector3.new(678.213555,12.171686,2691.217477),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G041_terrain_016_01_baked_f_0",center=Vector3.new(666.590064,12.148298,2740.015302),opacity=1.0,blend=false,texture="baked_f_01615_00_00"},
    {name="G042_terrain_016_02_baked_f_0",center=Vector3.new(669.97539,12.171832,2742.275674),opacity=1.0,blend=false,texture="baked_f_01618_00_00"},
    {name="G043_terrain_016_03_baked_f_0",center=Vector3.new(673.305076,12.252962,2749.934714),opacity=1.0,blend=false,texture="baked_f_01621_00_00"},
    {name="G044_terrain_016_04",center=Vector3.new(663.519723,12.778285,2775.033787),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G045_terrain_016_05",center=Vector3.new(658.222471,12.79806,2800.708553),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G046_terrain_016_06",center=Vector3.new(621.562004,12.838462,2975.255367),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G047_terrain_017_00",center=Vector3.new(408.500842,6.268146,2601.750401),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G048_terrain_017_01_baked_f_0",center=Vector3.new(397.932925,6.266831,2691.735949),opacity=1.0,blend=false,texture="baked_f_01664_00_00"},
    {name="G049_terrain_017_02_baked_f_0",center=Vector3.new(510.599109,8.63442,2718.144935),opacity=1.0,blend=false,texture="baked_f_01667_00_00"},
    {name="G050_terrain_017_02_baked_f_0",center=Vector3.new(284.27389,3.337599,2673.863002),opacity=1.0,blend=false,texture="baked_f_01667_00_01"},
    {name="G051_terrain_017_03_baked_f_0",center=Vector3.new(392.894363,6.266717,2721.593802),opacity=1.0,blend=false,texture="baked_f_01670_00_00"},
    {name="G052_terrain_017_04",center=Vector3.new(387.689114,6.266598,2744.359698),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G053_terrain_017_05",center=Vector3.new(346.560015,6.27774,2926.367079),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G054_terrain_018_00",center=Vector3.new(118.914589,2.365847,2538.317217),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G055_terrain_018_01_baked_f_0",center=Vector3.new(100.155337,-0.332964,2632.520076),opacity=1.0,blend=false,texture="baked_f_01715_00_00"},
    {name="G056_terrain_018_02",center=Vector3.new(99.314128,-0.43958,2638.134657),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G057_terrain_018_03",center=Vector3.new(94.909587,-0.43958,2660.571834),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G058_terrain_018_04",center=Vector3.new(90.299653,0.48274,2682.573918),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G059_terrain_018_05",center=Vector3.new(48.648616,0.483217,2886.704363),opacity=1.0,blend=false,texture="trackmat__grass"},
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
