-- Generated Watkins Glen visual installer: watkins_glen_terrain_055.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_terrain_055"
local KIND = "terrain"
local SOURCE_HASH = "189a1baa8b98b699abeeca8b33217c6bd489edfdb79c0179cf91db5ec70784db"
local GEOMETRIES = {
    {name="G000_terrain_077_08",center=Vector3.new(-71.249708,85.657702,-2219.502476),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G001_terrain_078_00",center=Vector3.new(-461.522729,104.44901,-2018.475669),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G002_terrain_078_01",center=Vector3.new(-348.204422,98.078554,-2041.334098),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G003_terrain_078_02",center=Vector3.new(-324.878189,98.050792,-2045.981053),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G004_terrain_078_03",center=Vector3.new(-302.136012,97.980993,-2050.506265),opacity=1.0,blend=false,texture="trackmat__paint"},
    {name="G005_terrain_078_04",center=Vector3.new(-302.487619,97.977175,-2054.170336),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G006_terrain_078_05",center=Vector3.new(-300.280067,97.953228,-2050.851549),opacity=1.0,blend=false,texture="trackmat__grassedge"},
    {name="G007_terrain_078_06_baked_f_0",center=Vector3.new(-277.45815,97.13801,-2057.829612),opacity=1.0,blend=false,texture="baked_f_05104_00_00"},
    {name="G008_terrain_078_07",center=Vector3.new(-171.715638,92.358981,-2068.094853),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G009_terrain_078_08",center=Vector3.new(-91.462407,88.183011,-2092.495619),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G010_terrain_078_09",center=Vector3.new(-9.006963,83.916552,-2111.834499),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G011_terrain_079_00",center=Vector3.new(-430.125155,104.754315,-1854.573168),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G012_terrain_079_01",center=Vector3.new(-315.534851,98.129834,-1877.594594),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G013_terrain_079_02",center=Vector3.new(-292.228985,98.07618,-1882.235282),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G014_terrain_079_03",center=Vector3.new(-269.123541,97.953078,-1886.875044),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G015_terrain_079_04_baked_f_0",center=Vector3.new(-258.950656,97.525988,-1888.706698),opacity=1.0,blend=false,texture="baked_f_05185_00_00"},
    {name="G016_terrain_079_05",center=Vector3.new(-106.801735,92.39723,-1910.344424),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G017_terrain_079_06",center=Vector3.new(16.439799,85.811308,-1943.63436),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G018_terrain_079_07",center=Vector3.new(78.083952,82.065317,-1960.247367),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G019_terrain_080_00",center=Vector3.new(-380.600125,104.76704,-1602.14653),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G020_terrain_080_01",center=Vector3.new(-265.220288,98.163097,-1625.418799),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G021_terrain_080_02",center=Vector3.new(-241.945839,98.085209,-1630.049842),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G022_terrain_080_03",center=Vector3.new(-218.353585,97.994978,-1631.049292),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G023_terrain_080_04",center=Vector3.new(-218.260963,97.987989,-1634.75162),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G024_terrain_080_05_baked_f_0",center=Vector3.new(-209.895032,97.886586,-1636.76796),opacity=1.0,blend=false,texture="baked_f_05248_00_00"},
    {name="G025_terrain_080_06",center=Vector3.new(45.098373,88.880314,-1679.378782),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G026_terrain_081_00",center=Vector3.new(-352.555398,104.440771,-1438.738523),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G027_terrain_081_01",center=Vector3.new(-232.714326,98.16868,-1462.594713),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G028_terrain_081_02",center=Vector3.new(-209.038973,98.084583,-1467.359652),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G029_terrain_081_03",center=Vector3.new(-185.301188,97.9957,-1472.077015),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G030_terrain_081_04_baked_f_0",center=Vector3.new(-176.869515,97.9957,-1473.776409),opacity=1.0,blend=false,texture="baked_f_05298_00_00"},
    {name="G031_terrain_081_05",center=Vector3.new(74.513429,97.9957,-1524.284254),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G032_terrain_082_00",center=Vector3.new(-343.540008,104.687875,-1392.79905),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G033_terrain_082_01",center=Vector3.new(-223.787035,98.165791,-1416.854477),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G034_terrain_082_02",center=Vector3.new(-199.956117,98.084079,-1421.596418),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G035_terrain_082_03",center=Vector3.new(-176.23917,97.995813,-1426.316125),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G036_terrain_082_04_baked_f_0",center=Vector3.new(-159.646068,97.995813,-1430.074692),opacity=1.0,blend=false,texture="baked_f_05352_00_00"},
    {name="G037_terrain_082_05",center=Vector3.new(-0.040354,97.995813,-1460.987527),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G038_terrain_083_00",center=Vector3.new(-333.134242,105.087141,-1336.727524),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G039_terrain_083_01",center=Vector3.new(-212.529911,98.160972,-1360.835702),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G040_terrain_083_02",center=Vector3.new(-188.889953,98.081432,-1365.57906),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G041_terrain_083_03",center=Vector3.new(-165.362208,97.995952,-1370.279639),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G042_terrain_083_04",center=Vector3.new(-97.701418,97.995952,-1384.49331),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G043_terrain_083_05",center=Vector3.new(16.902437,97.995952,-1399.185235),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G044_terrain_083_06",center=Vector3.new(112.432831,97.995952,-1432.240404),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G045_terrain_084_00",center=Vector3.new(-324.785069,105.085754,-1292.437254),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G046_terrain_084_01",center=Vector3.new(-203.768063,98.155853,-1316.63862),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G047_terrain_084_02",center=Vector3.new(-180.357483,98.079406,-1321.373531),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G048_terrain_084_03",center=Vector3.new(-156.665516,97.996061,-1325.989097),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G049_terrain_084_04",center=Vector3.new(-135.800924,97.996051,-1334.583882),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G050_terrain_084_05",center=Vector3.new(-78.233234,97.996061,-1341.68069),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G051_terrain_084_06",center=Vector3.new(34.816991,97.996061,-1354.177475),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G052_terrain_084_07",center=Vector3.new(106.295841,97.996061,-1387.559836),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G053_terrain_085_00",center=Vector3.new(-316.141319,105.084252,-1246.206774),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G054_terrain_085_01",center=Vector3.new(-194.629022,98.14963,-1270.492554),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G055_terrain_085_02",center=Vector3.new(-171.11249,98.076548,-1275.187302),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G056_terrain_085_03_baked_f_0",center=Vector3.new(-148.390675,97.996174,-1279.743685),opacity=1.0,blend=false,texture="baked_f_05520_00_00"},
    {name="G057_terrain_085_04_baked_f_0",center=Vector3.new(-116.007931,97.996174,-1287.056405),opacity=1.0,blend=false,texture="baked_f_05524_00_00"},
    {name="G058_terrain_085_05_baked_f_0",center=Vector3.new(-83.078405,97.996174,-1292.749786),opacity=1.0,blend=false,texture="baked_f_05527_00_00"},
    {name="G059_terrain_085_06",center=Vector3.new(55.993036,97.996174,-1319.595991),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G060_terrain_086_00",center=Vector3.new(-302.401202,105.053963,-1174.883161),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G061_terrain_086_01",center=Vector3.new(-180.52578,98.139102,-1199.378967),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G062_terrain_086_02",center=Vector3.new(-156.942592,98.07353,-1204.082816),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G063_terrain_086_03_baked_f_0",center=Vector3.new(-134.174388,97.996347,-1208.620834),opacity=1.0,blend=false,texture="baked_f_05574_00_00"},
    {name="G064_terrain_086_04",center=Vector3.new(-127.12997,97.996334,-1215.47045),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G065_terrain_086_05",center=Vector3.new(-117.058699,97.996347,-1212.033354),opacity=1.0,blend=false,texture="trackmat__grassedge"},
    {name="G066_terrain_086_06_baked_f_0",center=Vector3.new(-92.116094,97.996347,-1217.006683),opacity=1.0,blend=false,texture="baked_f_05583_00_00"},
    {name="G067_terrain_086_07",center=Vector3.new(46.252707,97.996347,-1242.640468),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G068_terrain_087_00",center=Vector3.new(-245.903908,104.709843,-885.723223),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G069_terrain_087_01",center=Vector3.new(-123.058258,98.087103,-911.170197),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G070_terrain_087_02",center=Vector3.new(-99.522742,98.065748,-915.870775),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G071_terrain_087_03",center=Vector3.new(-76.174196,97.996954,-920.488712),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G072_terrain_087_04_baked_f_0",center=Vector3.new(-86.647217,97.996732,-1042.571477),opacity=1.0,blend=false,texture="baked_f_05633_00_00"},
    {name="G073_terrain_087_04_baked_f_0",center=Vector3.new(-37.733584,97.997219,-803.592573),opacity=1.0,blend=false,texture="baked_f_05633_00_01"},
    {name="G074_terrain_087_05",center=Vector3.new(94.144222,97.996954,-954.903766),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G075_terrain_088_00",center=Vector3.new(-195.624273,104.859015,-609.519168),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G076_terrain_088_01",center=Vector3.new(-68.007977,98.034518,-635.111237),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G077_terrain_088_02_baked_f_0",center=Vector3.new(-44.486547,98.019535,-639.802361),opacity=1.0,blend=false,texture="baked_f_05672_00_00"},
    {name="G078_terrain_088_03_baked_f_0",center=Vector3.new(-21.090067,97.997495,-644.44719),opacity=1.0,blend=false,texture="baked_f_05675_00_00"},
    {name="G079_terrain_088_04_baked_f_0",center=Vector3.new(-16.604253,97.997488,-650.189563),opacity=1.0,blend=false,texture="baked_f_05678_00_00"},
    {name="G080_terrain_088_05",center=Vector3.new(145.156458,97.997495,-676.143319),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G081_terrain_089_00",center=Vector3.new(-182.453535,104.85659,-539.658328),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G082_terrain_089_01",center=Vector3.new(-54.103385,98.023582,-565.380996),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G083_terrain_089_02_baked_f_0",center=Vector3.new(-30.589383,98.013319,-570.070512),opacity=1.0,blend=false,texture="baked_f_05717_00_00"},
    {name="G084_terrain_089_03_baked_f_0",center=Vector3.new(-7.201358,97.997587,-574.732862),opacity=1.0,blend=false,texture="baked_f_05720_00_00"},
    {name="G085_terrain_089_04",center=Vector3.new(151.741457,97.997587,-606.417302),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G086_terrain_090_00",center=Vector3.new(-169.217661,104.854216,-469.850145),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G087_terrain_090_01",center=Vector3.new(-40.212488,98.014304,-495.718874),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G088_terrain_090_02_baked_f_0",center=Vector3.new(-16.70655,98.008432,-500.406919),opacity=1.0,blend=false,texture="baked_f_05759_00_00"},
    {name="G089_terrain_090_03_baked_f_0",center=Vector3.new(6.493029,97.997662,-505.06758),opacity=1.0,blend=false,texture="baked_f_05762_00_00"},
    {name="G090_terrain_090_04_baked_f_0",center=Vector3.new(18.792095,97.997665,-502.068656),opacity=1.0,blend=false,texture="baked_f_05765_00_00"},
    {name="G091_terrain_090_05",center=Vector3.new(165.653411,97.997662,-538.855907),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G092_terrain_091_00",center=Vector3.new(-141.668334,103.737862,-330.536795),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G093_terrain_091_01",center=Vector3.new(-12.024519,98.00444,-354.371875),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G094_terrain_091_02",center=Vector3.new(11.48035,96.805545,-359.03962),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G095_terrain_091_03",center=Vector3.new(34.712599,96.799374,-363.663946),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G096_terrain_091_04_baked_f_0",center=Vector3.new(45.065838,96.842895,-365.958418),opacity=1.0,blend=false,texture="baked_f_05811_00_00"},
    {name="G097_terrain_091_05",center=Vector3.new(183.495213,96.803515,-397.281647),opacity=1.0,blend=false,texture="trackmat__grass"},
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
