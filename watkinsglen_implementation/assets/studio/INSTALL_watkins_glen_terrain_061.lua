-- Generated Watkins Glen visual installer: watkins_glen_terrain_061.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_terrain_061"
local KIND = "terrain"
local SOURCE_HASH = "29a7b3b6212694e2667cc56130355d879729e38eb1a360a0648f831664f14bb8"
local GEOMETRIES = {
    {name="G000_terrain_095_09",center=Vector3.new(250.353656,91.159735,-152.785468),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G001_terrain_096_00",center=Vector3.new(235.735362,92.791513,209.327044),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G002_terrain_096_01",center=Vector3.new(252.737127,93.003695,93.297074),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G003_terrain_096_02",center=Vector3.new(266.887433,93.115432,16.671234),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G004_terrain_096_03",center=Vector3.new(269.137927,92.946434,1.211586),opacity=1.0,blend=false,texture="trackmat__curbing"},
    {name="G005_terrain_096_04",center=Vector3.new(270.476818,92.57897,-8.573172),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G006_terrain_096_05",center=Vector3.new(272.343009,91.911646,-20.089577),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G007_terrain_096_06",center=Vector3.new(275.175503,91.004106,-37.985737),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G008_terrain_096_07",center=Vector3.new(277.038288,90.886818,-49.598551),opacity=1.0,blend=false,texture="trackmat__curbing2_left"},
    {name="G009_terrain_096_08_baked_f_0",center=Vector3.new(277.895028,91.138816,-59.503652),opacity=1.0,blend=false,texture="baked_f_06112_00_00"},
    {name="G010_terrain_096_09",center=Vector3.new(285.212503,90.851613,-143.61654),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G011_terrain_097_00",center=Vector3.new(331.375422,91.080475,231.278563),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G012_terrain_097_01",center=Vector3.new(340.135193,91.172569,101.285698),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G013_terrain_097_02",center=Vector3.new(345.640074,91.186707,23.15736),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G014_terrain_097_03",center=Vector3.new(346.68139,91.18668,8.350933),opacity=1.0,blend=false,texture="trackmat__curbing"},
    {name="G015_terrain_097_04",center=Vector3.new(348.646995,91.003803,-18.814972),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G016_terrain_097_05",center=Vector3.new(350.319304,90.333251,-42.950957),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G017_terrain_097_06_baked_f_0",center=Vector3.new(351.024396,90.385597,-52.832631),opacity=1.0,blend=false,texture="baked_f_06170_00_00"},
    {name="G018_terrain_097_07",center=Vector3.new(351.873956,90.356418,-65.159389),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G019_terrain_097_08",center=Vector3.new(359.122549,90.345345,-164.381763),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G020_terrain_098_00",center=Vector3.new(463.537066,88.428191,239.262812),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G021_terrain_098_01",center=Vector3.new(472.611863,88.428157,109.127963),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G022_terrain_098_02",center=Vector3.new(478.156063,88.428153,32.279442),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G023_terrain_098_03",center=Vector3.new(479.091753,88.428153,16.979265),opacity=1.0,blend=false,texture="trackmat__curbing"},
    {name="G024_terrain_098_04",center=Vector3.new(481.083366,88.428664,-9.375086),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G025_terrain_098_05",center=Vector3.new(482.776233,88.428664,-34.189073),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G026_terrain_098_06_baked_f_0",center=Vector3.new(483.403546,88.428657,-42.689996),opacity=1.0,blend=false,texture="baked_f_06235_00_00"},
    {name="G027_terrain_098_07_baked_f_0",center=Vector3.new(484.321989,88.42863,-55.14313),opacity=1.0,blend=false,texture="baked_f_06238_00_00"},
    {name="G028_terrain_098_08",center=Vector3.new(493.246405,88.428613,-178.264984),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G029_terrain_099_00",center=Vector3.new(622.953551,87.088895,249.658591),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G030_terrain_099_01",center=Vector3.new(631.937654,87.070952,117.870642),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G031_terrain_099_02",center=Vector3.new(637.512643,87.068742,40.156318),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G032_terrain_099_03",center=Vector3.new(638.489805,87.097492,26.778903),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G033_terrain_099_04",center=Vector3.new(640.281514,87.106047,1.697838),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G034_terrain_099_05",center=Vector3.new(642.030525,87.10601,-23.322283),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G035_terrain_099_06_baked_f_0",center=Vector3.new(642.816489,87.10601,-33.626934),opacity=1.0,blend=false,texture="baked_f_06312_00_00"},
    {name="G036_terrain_099_07",center=Vector3.new(643.769918,87.10601,-47.900079),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G037_terrain_099_08",center=Vector3.new(653.113992,87.10601,-176.621721),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G038_terrain_100_00",center=Vector3.new(797.218595,87.106844,182.583169),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G039_terrain_100_01",center=Vector3.new(807.312775,87.106882,38.925827),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G040_terrain_100_02",center=Vector3.new(809.133148,87.106848,13.61787),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G041_terrain_100_03",center=Vector3.new(810.893631,87.106766,-11.939741),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G042_terrain_100_04_baked_f_0",center=Vector3.new(815.240696,87.106783,-16.814367),opacity=1.0,blend=false,texture="baked_f_06370_00_00"},
    {name="G043_terrain_100_05_baked_f_0",center=Vector3.new(808.14179,87.106742,-29.294725),opacity=1.0,blend=false,texture="baked_f_06373_00_00"},
    {name="G044_terrain_100_06",center=Vector3.new(812.713296,87.106766,-37.581825),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G045_terrain_100_07",center=Vector3.new(822.705868,87.106766,-173.07983),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G046_terrain_101_00",center=Vector3.new(962.258148,85.355939,188.906722),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G047_terrain_101_01",center=Vector3.new(972.336796,85.356045,50.3772),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G048_terrain_101_02",center=Vector3.new(972.851426,85.356048,43.786769),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G049_terrain_101_03",center=Vector3.new(973.299217,85.793897,37.274812),opacity=1.0,blend=false,texture="trackmat__paint"},
    {name="G050_terrain_101_04",center=Vector3.new(974.619348,85.813236,18.704987),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G051_terrain_101_05",center=Vector3.new(975.952884,87.107505,-0.480547),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G052_terrain_101_06_baked_f_0",center=Vector3.new(976.798494,87.107505,-11.503012),opacity=1.0,blend=false,texture="baked_f_06442_00_00"},
    {name="G053_terrain_101_07",center=Vector3.new(977.846554,87.107505,-26.894342),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G054_terrain_101_08",center=Vector3.new(987.402289,87.107505,-168.990954),opacity=1.0,blend=false,texture="trackmat__grass"},
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
