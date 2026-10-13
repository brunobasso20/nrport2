-- Generated Watkins Glen visual installer: watkins_glen_terrain_071.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_terrain_071"
local KIND = "terrain"
local SOURCE_HASH = "1a269f29748ba3f8665d14f23a93f448994c034075aa4e867258eb26d3f09604"
local GEOMETRIES = {
    {name="G000_terrain_110_11",center=Vector3.new(1412.2612,88.000808,269.113922),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G001_terrain_111_00",center=Vector3.new(1039.121192,90.926926,332.526466),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G002_terrain_111_01_baked_f_0",center=Vector3.new(1136.105074,89.780736,336.850779),opacity=1.0,blend=false,texture="baked_f_07054_00_00"},
    {name="G003_terrain_111_02_baked_f_0",center=Vector3.new(1199.501528,85.777542,340.983309),opacity=1.0,blend=false,texture="baked_f_07058_00_00"},
    {name="G004_terrain_111_03_baked_f_0",center=Vector3.new(1214.165497,85.777508,343.309757),opacity=1.0,blend=false,texture="baked_f_07062_00_00"},
    {name="G005_terrain_111_04_baked_f_0",center=Vector3.new(1221.148082,85.777508,344.693974),opacity=1.0,blend=false,texture="baked_f_07066_00_00"},
    {name="G006_terrain_111_05",center=Vector3.new(1237.302181,86.215673,345.230171),opacity=1.0,blend=false,texture="trackmat__paint"},
    {name="G007_terrain_111_06_baked_f_0",center=Vector3.new(1256.023516,86.235097,347.288568),opacity=1.0,blend=false,texture="baked_f_07072_00_00"},
    {name="G008_terrain_111_07_baked_f_0",center=Vector3.new(1283.399146,87.873316,348.946081),opacity=1.0,blend=false,texture="baked_f_07075_00_00"},
    {name="G009_terrain_111_08_baked_f_0",center=Vector3.new(1286.06878,88.391689,349.342755),opacity=1.0,blend=false,texture="baked_f_07078_00_00"},
    {name="G010_terrain_111_09_baked_f_0",center=Vector3.new(1293.795395,88.391529,349.83323),opacity=1.0,blend=false,texture="baked_f_07082_00_00"},
    {name="G011_terrain_111_10_baked_f_0",center=Vector3.new(1304.162107,88.391324,350.696891),opacity=1.0,blend=false,texture="baked_f_07085_00_00"},
    {name="G012_terrain_111_11_baked_f_0",center=Vector3.new(1402.873448,88.389213,359.235695),opacity=1.0,blend=false,texture="baked_f_07088_00_00"},
    {name="G013_terrain_112_00",center=Vector3.new(1077.387401,93.106495,441.245774),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G014_terrain_112_01",center=Vector3.new(1187.669645,88.519921,450.381388),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G015_terrain_112_02_baked_f_0",center=Vector3.new(1204.363905,88.527969,451.795374),opacity=1.0,blend=false,texture="baked_f_07137_00_00"},
    {name="G016_terrain_112_03",center=Vector3.new(1221.067265,88.527969,453.126458),opacity=1.0,blend=false,texture="trackmat__paint"},
    {name="G017_terrain_112_04",center=Vector3.new(1246.080344,88.52738,455.271299),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G018_terrain_112_05",center=Vector3.new(1273.540987,88.636446,457.436521),opacity=1.0,blend=false,texture="trackmat__curbing_asphalt"},
    {name="G019_terrain_112_06",center=Vector3.new(1277.281025,88.978801,457.761996),opacity=1.0,blend=false,texture="trackmat__asphalt_rumble"},
    {name="G020_terrain_112_07_baked_f_0",center=Vector3.new(1285.495704,88.978679,458.451748),opacity=1.0,blend=false,texture="baked_f_07152_00_00"},
    {name="G021_terrain_112_08_baked_f_0",center=Vector3.new(1295.661872,88.978577,459.119633),opacity=1.0,blend=false,texture="baked_f_07155_00_00"},
    {name="G022_terrain_112_09",center=Vector3.new(1396.14187,88.976829,467.762906),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G023_terrain_113_00",center=Vector3.new(1057.479586,93.656111,523.198155),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G024_terrain_113_01_baked_f_0",center=Vector3.new(1185.442897,89.803032,533.606257),opacity=1.0,blend=false,texture="baked_f_07205_00_00"},
    {name="G025_terrain_113_02",center=Vector3.new(1238.578306,89.762276,538.046047),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G026_terrain_113_03",center=Vector3.new(1266.629192,89.780269,540.243748),opacity=1.0,blend=false,texture="trackmat__curbing_asphalt"},
    {name="G027_terrain_113_04",center=Vector3.new(1269.530324,89.942605,540.557398),opacity=1.0,blend=false,texture="trackmat__asphalt_rumble"},
    {name="G028_terrain_113_05_baked_f_0",center=Vector3.new(1277.97699,89.942217,541.270065),opacity=1.0,blend=false,texture="baked_f_07217_00_00"},
    {name="G029_terrain_113_06_baked_f_0",center=Vector3.new(1286.530031,89.941192,542.030253),opacity=1.0,blend=false,texture="baked_f_07220_00_00"},
    {name="G030_terrain_113_07",center=Vector3.new(1390.57421,89.940109,550.630079),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G031_terrain_114_00",center=Vector3.new(1042.894636,92.512536,666.755976),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G032_terrain_114_01",center=Vector3.new(1159.198434,92.518241,676.11005),opacity=1.0,blend=false,texture="trackmat__concrete_02"},
    {name="G033_terrain_114_02_baked_f_0",center=Vector3.new(1186.719295,92.524835,678.433636),opacity=1.0,blend=false,texture="baked_f_07275_00_00"},
    {name="G034_terrain_114_03_baked_f_0",center=Vector3.new(1227.889524,92.524835,681.712478),opacity=1.0,blend=false,texture="baked_f_07278_00_00"},
    {name="G035_terrain_114_04_baked_f_0",center=Vector3.new(1253.913334,92.467563,683.888381),opacity=1.0,blend=false,texture="baked_f_07282_00_00"},
    {name="G036_terrain_114_05_baked_f_0",center=Vector3.new(1262.931606,92.484191,684.409632),opacity=1.0,blend=false,texture="baked_f_07285_00_00"},
    {name="G037_terrain_114_06_baked_f_0",center=Vector3.new(1287.488392,92.481215,687.155206),opacity=1.0,blend=false,texture="baked_f_07288_00_00"},
    {name="G038_terrain_114_07",center=Vector3.new(1398.659733,92.467563,695.849909),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G039_terrain_115_00",center=Vector3.new(1034.527751,94.479857,767.291914),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G040_terrain_115_01",center=Vector3.new(1150.877925,94.530453,776.868384),opacity=1.0,blend=false,texture="trackmat__concrete_02"},
    {name="G041_terrain_115_02_baked_f_0",center=Vector3.new(1179.107503,94.54265,779.191589),opacity=1.0,blend=false,texture="baked_f_07338_00_00"},
    {name="G042_terrain_115_03",center=Vector3.new(1219.626508,94.491972,782.528196),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G043_terrain_115_04",center=Vector3.new(1246.009009,94.435549,784.690802),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G044_terrain_115_05_baked_f_0",center=Vector3.new(1256.103625,94.435549,785.546712),opacity=1.0,blend=false,texture="baked_f_07347_00_00"},
    {name="G045_terrain_115_06",center=Vector3.new(1372.850364,94.435549,795.142419),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G046_terrain_116_00",center=Vector3.new(1033.497947,94.659465,777.087293),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G047_terrain_116_01",center=Vector3.new(1150.075422,94.708994,786.667115),opacity=1.0,blend=false,texture="trackmat__concrete_02"},
    {name="G048_terrain_116_02_baked_f_0",center=Vector3.new(1178.2941,94.720657,788.99122),opacity=1.0,blend=false,texture="baked_f_07392_00_00"},
    {name="G049_terrain_116_03",center=Vector3.new(1218.817575,94.670725,792.327881),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G050_terrain_116_04",center=Vector3.new(1245.089885,94.618181,794.479833),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G051_terrain_116_05_baked_f_0",center=Vector3.new(1255.240032,94.618181,795.32705),opacity=1.0,blend=false,texture="baked_f_07401_00_00"},
    {name="G052_terrain_116_06",center=Vector3.new(1371.980558,94.618181,804.967744),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G053_terrain_117_00",center=Vector3.new(1028.689412,95.441392,822.875105),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G054_terrain_117_01",center=Vector3.new(1146.290643,95.486004,832.472937),opacity=1.0,blend=false,texture="trackmat__concrete_02"},
    {name="G055_terrain_117_02_baked_f_0",center=Vector3.new(1174.512046,95.495074,834.796224),opacity=1.0,blend=false,texture="baked_f_07446_00_00"},
    {name="G056_terrain_117_03",center=Vector3.new(1215.036501,95.448569,838.135229),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G057_terrain_117_04",center=Vector3.new(1241.20418,95.414819,840.291977),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G058_terrain_117_05_baked_f_0",center=Vector3.new(1251.416615,95.414819,841.132627),opacity=1.0,blend=false,texture="baked_f_07455_00_00"},
    {name="G059_terrain_117_06",center=Vector3.new(1368.568747,95.414819,850.85937),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G060_terrain_118_00",center=Vector3.new(1024.771064,96.197782,867.862592),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G061_terrain_118_01",center=Vector3.new(1142.570114,96.227329,877.545221),opacity=1.0,blend=false,texture="trackmat__concrete_02"},
    {name="G062_terrain_118_02_baked_f_0",center=Vector3.new(1170.787866,96.234097,879.868317),opacity=1.0,blend=false,texture="baked_f_07499_00_00"},
    {name="G063_terrain_118_03",center=Vector3.new(1211.335863,96.204196,883.207348),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G064_terrain_118_04",center=Vector3.new(1237.560708,96.173988,885.368865),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G065_terrain_118_05_baked_f_0",center=Vector3.new(1247.856467,96.173988,886.223085),opacity=1.0,blend=false,texture="baked_f_07508_00_00"},
    {name="G066_terrain_118_06",center=Vector3.new(1366.155624,96.173988,895.960072),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G067_terrain_119_00",center=Vector3.new(1023.974228,96.335261,876.912008),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G068_terrain_119_01",center=Vector3.new(1141.822978,96.361944,886.610794),opacity=1.0,blend=false,texture="trackmat__concrete_02"},
    {name="G069_terrain_119_02_baked_f_0",center=Vector3.new(1170.036697,96.368258,888.934081),opacity=1.0,blend=false,texture="baked_f_07552_00_00"},
    {name="G070_terrain_119_03",center=Vector3.new(1210.591234,96.341491,892.273085),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G071_terrain_119_04",center=Vector3.new(1236.850248,96.312135,894.43324),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G072_terrain_119_05_baked_f_0",center=Vector3.new(1247.236579,96.312135,895.295933),opacity=1.0,blend=false,texture="baked_f_07561_00_00"},
    {name="G073_terrain_119_06",center=Vector3.new(1365.680531,96.312135,905.042567),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G074_terrain_120_00",center=Vector3.new(1017.847116,96.978927,933.169365),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G075_terrain_120_01",center=Vector3.new(1137.162181,97.002775,942.873355),opacity=1.0,blend=false,texture="trackmat__concrete_02"},
    {name="G076_terrain_120_02_baked_f_0",center=Vector3.new(1165.391813,97.006498,945.195934),opacity=1.0,blend=false,texture="baked_f_07605_00_00"},
    {name="G077_terrain_120_03",center=Vector3.new(1205.941609,96.980483,948.538072),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G078_terrain_120_04",center=Vector3.new(1232.215445,96.973072,950.694248),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G079_terrain_120_05_baked_f_0",center=Vector3.new(1242.622648,96.973072,951.635006),opacity=1.0,blend=false,texture="baked_f_07614_00_00"},
    {name="G080_terrain_120_06",center=Vector3.new(1362.040656,96.973072,961.446735),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G081_terrain_121_00",center=Vector3.new(1022.062656,97.662898,995.103782),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G082_terrain_121_01",center=Vector3.new(1132.664435,97.668879,1004.103252),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G083_terrain_121_02_baked_f_0",center=Vector3.new(1160.331018,97.670225,1006.427002),opacity=1.0,blend=false,texture="baked_f_07660_00_00"},
    {name="G084_terrain_121_03",center=Vector3.new(1200.916345,97.663648,1009.768949),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G085_terrain_121_04",center=Vector3.new(1227.145168,97.658127,1011.927686),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G086_terrain_121_05_baked_f_0",center=Vector3.new(1238.51569,97.658127,1012.87602),opacity=1.0,blend=false,texture="baked_f_07669_00_00"},
    {name="G087_terrain_121_06",center=Vector3.new(1358.796201,97.658127,1022.773089),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G088_terrain_122_00",center=Vector3.new(1017.703928,97.85224,1041.544342),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G089_terrain_122_01",center=Vector3.new(1138.303593,97.857012,1051.383863),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G090_terrain_122_02_baked_f_0",center=Vector3.new(1156.495176,97.857138,1052.881786),opacity=1.0,blend=false,texture="baked_f_07715_00_00"},
    {name="G091_terrain_122_03",center=Vector3.new(1197.080667,97.85224,1056.225913),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G092_terrain_122_04",center=Vector3.new(1223.329817,97.85224,1058.38198),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G093_terrain_122_05_baked_f_0",center=Vector3.new(1234.806333,97.85224,1059.39876),opacity=1.0,blend=false,texture="baked_f_07724_00_00"},
    {name="G094_terrain_122_06",center=Vector3.new(1355.990328,97.85224,1069.340025),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G095_track_detail_000",center=Vector3.new(1194.658552,97.995731,1096.112606),opacity=1.0,blend=false,texture="tsd_paint"},
    {name="G096_track_detail_001",center=Vector3.new(1182.044111,90.526237,577.963638),opacity=1.0,blend=false,texture="tsd_paint"},
    {name="G097_track_detail_002",center=Vector3.new(1038.286482,46.777914,2327.19138),opacity=1.0,blend=false,texture="tsd_paint"},
    {name="G098_track_detail_003",center=Vector3.new(-1252.381461,119.771828,-1517.717089),opacity=1.0,blend=false,texture="tsd_yellow"},
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
