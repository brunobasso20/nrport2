-- Generated Watkins Glen visual installer: watkins_glen_terrain_000.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_terrain_000"
local KIND = "terrain"
local SOURCE_HASH = "0c112d6fbe50d8ec69bb75cc050078e732233e7720f1fcb1f9f61ae73234c261"
local GEOMETRIES = {
    {name="G000_terrain_000_00",center=Vector3.new(1012.606566,97.981654,1092.681067),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G001_terrain_000_01",center=Vector3.new(1134.070969,97.981691,1102.61334),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G002_terrain_000_02_baked_f_0",center=Vector3.new(1152.297701,97.981691,1104.109028),opacity=1.0,blend=false,texture="baked_f_00500_00_00"},
    {name="G003_terrain_000_03",center=Vector3.new(1192.888914,97.981698,1107.451793),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G004_terrain_000_04",center=Vector3.new(1219.089345,97.981698,1109.610476),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G005_terrain_000_05_baked_f_0",center=Vector3.new(1231.407438,97.981698,1110.617011),opacity=1.0,blend=false,texture="baked_f_00511_00_00"},
    {name="G006_terrain_000_06",center=Vector3.new(1352.899061,97.981698,1120.654024),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G007_terrain_001_00",center=Vector3.new(1010.440036,97.942877,1110.949217),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G008_terrain_001_01",center=Vector3.new(1122.491183,97.942976,1121.781213),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G009_terrain_001_02_baked_f_0",center=Vector3.new(1150.754329,97.942993,1123.279081),opacity=1.0,blend=false,texture="baked_f_00567_00_00"},
    {name="G010_terrain_001_03",center=Vector3.new(1191.319111,97.94301,1126.619339),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G011_terrain_001_04",center=Vector3.new(1217.516436,97.943006,1128.777313),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G012_terrain_001_05_baked_f_0",center=Vector3.new(1229.750388,97.943006,1129.779489),opacity=1.0,blend=false,texture="baked_f_00576_00_00"},
    {name="G013_terrain_001_06",center=Vector3.new(1351.510293,97.943006,1139.827183),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G014_terrain_002_00",center=Vector3.new(924.371338,80.314837,1594.392395),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G015_terrain_002_01",center=Vector3.new(1082.758713,80.314847,1604.555021),opacity=1.0,blend=false,texture="trackmat__concrete_02"},
    {name="G016_terrain_002_02_baked_f_0",center=Vector3.new(np.float64(1137.532352),np.float64(94.978562),np.float64(1289.555781)),opacity=1.0,blend=false,texture="baked_f_00624_00_00"},
    {name="G017_terrain_002_02_baked_f_0",center=Vector3.new(np.float64(1112.045506),np.float64(85.612501),np.float64(1606.833799)),opacity=1.0,blend=false,texture="baked_f_00624_00_01"},
    {name="G018_terrain_002_02_baked_f_0",center=Vector3.new(np.float64(1086.558605),np.float64(70.949247),np.float64(1924.111866)),opacity=1.0,blend=false,texture="baked_f_00624_00_02"},
    {name="G019_terrain_002_03",center=Vector3.new(1152.030781,80.314864,1610.106495),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G020_terrain_002_04",center=Vector3.new(1177.708708,80.314864,1612.28169),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G021_terrain_002_05_baked_f_0",center=Vector3.new(np.float64(1216.078585),np.float64(94.979252),np.float64(1295.951775)),opacity=1.0,blend=false,texture="baked_f_00633_00_00"},
    {name="G022_terrain_002_05_baked_f_0",center=Vector3.new(np.float64(1188.955488),np.float64(85.61363),np.float64(1613.095116)),opacity=1.0,blend=false,texture="baked_f_00633_00_01"},
    {name="G023_terrain_002_05_baked_f_0",center=Vector3.new(np.float64(1161.832392),np.float64(70.949244),np.float64(1930.238469)),opacity=1.0,blend=false,texture="baked_f_00633_00_02"},
    {name="G024_terrain_002_06",center=Vector3.new(1308.635603,80.314861,1624.139513),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G025_terrain_003_00",center=Vector3.new(869.063595,54.748023,2189.168004),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G026_terrain_003_01",center=Vector3.new(1011.499677,54.756492,2201.124355),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G027_terrain_003_02",center=Vector3.new(1034.846224,54.757054,2202.998025),opacity=1.0,blend=false,texture="trackmat__concrete_02"},
    {name="G028_terrain_003_03_baked_f_0",center=Vector3.new(1062.969589,54.757936,2205.360086),opacity=1.0,blend=false,texture="baked_f_00688_00_00"},
    {name="G029_terrain_003_04",center=Vector3.new(1102.120045,54.758835,2208.664594),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G030_terrain_003_05",center=Vector3.new(1128.976059,54.760478,2210.781206),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G031_terrain_003_06_baked_f_0",center=Vector3.new(1134.585026,54.760478,2211.84409),opacity=1.0,blend=false,texture="baked_f_00697_00_00"},
    {name="G032_terrain_003_07",center=Vector3.new(1164.839663,54.760494,2213.984462),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G033_terrain_003_08_baked_f_0",center=Vector3.new(1171.581432,54.760521,2214.304788),opacity=1.0,blend=false,texture="baked_f_00704_00_00"},
    {name="G034_terrain_003_09",center=Vector3.new(1286.214066,54.760526,2223.743003),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G035_terrain_004_00",center=Vector3.new(861.174747,39.414116,2423.143659),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G036_terrain_004_01_baked_f_0",center=Vector3.new(1020.612499,39.436504,2436.355373),opacity=1.0,blend=false,texture="baked_f_00760_00_00"},
    {name="G037_terrain_004_02",center=Vector3.new(1038.341686,39.195815,2443.588693),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G038_terrain_004_03",center=Vector3.new(1057.437679,39.442222,2440.193285),opacity=1.0,blend=false,texture="trackmat__grassedge2"},
    {name="G039_terrain_004_04",center=Vector3.new(1083.069393,39.443881,2442.413112),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G040_terrain_004_05",center=Vector3.new(1110.166659,39.443881,2444.573648),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G041_terrain_004_06_baked_f_0",center=Vector3.new(1123.079899,39.443896,2446.14127),opacity=1.0,blend=false,texture="baked_f_00776_00_00"},
    {name="G042_terrain_004_07",center=Vector3.new(1175.309045,39.443929,2450.11346),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G043_terrain_004_08_baked_f_0",center=Vector3.new(1203.344563,39.443946,2452.229527),opacity=1.0,blend=false,texture="baked_f_00782_00_00"},
    {name="G044_terrain_004_09",center=Vector3.new(1314.057595,39.444096,2461.345019),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G045_terrain_005_00",center=Vector3.new(843.445832,25.838823,2604.28554),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G046_terrain_005_01_baked_f_0",center=Vector3.new(970.921108,25.938558,2616.667284),opacity=1.0,blend=false,texture="baked_f_00842_00_00"},
    {name="G047_terrain_005_02",center=Vector3.new(1008.143452,27.376516,2620.859964),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G048_terrain_005_03",center=Vector3.new(1041.374316,27.455975,2622.383881),opacity=1.0,blend=false,texture="trackmat__grassedge2"},
    {name="G049_terrain_005_04",center=Vector3.new(1068.045916,27.469554,2624.622127),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G050_terrain_005_05",center=Vector3.new(1095.842307,28.644562,2626.859392),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G051_terrain_005_06",center=Vector3.new(1151.489094,28.644581,2631.522805),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G052_terrain_005_07_baked_f_0",center=Vector3.new(1211.270033,28.644581,2636.377389),opacity=1.0,blend=false,texture="baked_f_00860_00_00"},
    {name="G053_terrain_005_08",center=Vector3.new(1226.636178,28.439529,2641.601127),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G054_terrain_005_09_baked_f_0",center=Vector3.new(1236.797878,28.644582,2638.474601),opacity=1.0,blend=false,texture="baked_f_00866_00_00"},
    {name="G055_terrain_005_10",center=Vector3.new(1328.856495,28.644618,2645.746504),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G056_terrain_006_00",center=Vector3.new(926.960863,19.624628,2686.482021),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G057_terrain_006_01_baked_f_0",center=Vector3.new(949.139459,21.105965,2696.877616),opacity=1.0,blend=false,texture="baked_f_00929_00_00"},
    {name="G058_terrain_006_02",center=Vector3.new(996.258054,20.639854,2718.129621),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G059_terrain_006_03",center=Vector3.new(1025.127356,20.506801,2721.14672),opacity=1.0,blend=false,texture="trackmat__curbing2"},
    {name="G060_terrain_006_04",center=Vector3.new(1037.261145,21.017149,2723.691668),opacity=1.0,blend=false,texture="trackmat__asphalt"},
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
