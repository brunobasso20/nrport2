-- Generated Watkins Glen visual installer: watkins_glen_walls_011.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_walls_011"
local KIND = "walls"
local SOURCE_HASH = "e9ca500852047c8c6ee29999f770b9200dc1dc039390bffdc37bf5575a1ae4d1"
local GEOMETRIES = {
    {name="G000_wall_118_02_00_1",center=Vector3.new(1248.704747,99.995416,886.283711),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G001_wall_118_02_00_2",center=Vector3.new(1248.88273,98.084702,886.298343),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G002_wall_118_03_00_0",center=Vector3.new(1257.256481,101.531131,886.987795),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G003_wall_118_03_00_2",center=Vector3.new(1257.612392,101.531131,887.017114),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G004_wall_profile_118_03_00_0",center=Vector3.new(1257.128525,107.393295,886.977277),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G005_wall_profile_118_03_00_0",center=Vector3.new(1256.639154,108.487044,886.936951),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G006_wall_profile_118_03_00_0",center=Vector3.new(1255.715888,109.564052,886.860956),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G007_wall_profile_118_03_00_0",center=Vector3.new(1254.425648,110.256018,886.754744),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G008_wall_profile_118_03_00_2",center=Vector3.new(1257.484491,107.393295,887.006596),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G009_wall_profile_118_03_00_2",center=Vector3.new(1256.995065,108.487044,886.966269),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G010_wall_profile_118_03_00_2",center=Vector3.new(1256.071854,109.564052,886.890275),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G011_wall_profile_118_03_00_2",center=Vector3.new(1254.78156,110.256018,886.784009),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G012_wall_profile_top_118_03_",center=Vector3.new(1253.875024,110.459702,886.709404),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G013_wall_119_00_00_0",center=Vector3.new(1127.841568,97.251712,885.459845),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G014_wall_119_00_00_1",center=Vector3.new(1128.73121,98.144763,885.533088),opacity=1.0,blend=false,texture="trackmat__wall_pit_top"},
    {name="G015_wall_119_00_00_2",center=Vector3.new(1129.621233,97.25211,885.606357),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G016_wall_119_01_00_0",center=Vector3.new(1185.155487,98.157406,890.178735),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G017_wall_119_01_00_1",center=Vector3.new(1186.047418,99.942068,890.252168),opacity=1.0,blend=false,texture="trackmat__wall_pit_top"},
    {name="G018_wall_119_01_00_2",center=Vector3.new(1186.937605,98.155332,890.325465),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G019_wall_119_02_00_0",center=Vector3.new(1247.762408,98.222848,895.333454),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G020_wall_119_02_00_1",center=Vector3.new(1247.94039,100.133562,895.348086),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G021_wall_119_02_00_2",center=Vector3.new(1248.118373,98.222848,895.362745),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G022_wall_119_03_00_0",center=Vector3.new(1256.707001,101.669277,896.069908),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G023_wall_119_03_00_2",center=Vector3.new(1257.062912,101.669277,896.0992),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G024_wall_profile_119_03_00_0",center=Vector3.new(1256.579099,107.531442,896.059363),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G025_wall_profile_119_03_00_0",center=Vector3.new(1256.089619,108.625191,896.019064),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G026_wall_profile_119_03_00_0",center=Vector3.new(1255.166462,109.702199,895.943069),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G027_wall_profile_119_03_00_0",center=Vector3.new(1253.876168,110.394164,895.836803),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G028_wall_profile_119_03_00_2",center=Vector3.new(1256.935011,107.531442,896.088655),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G029_wall_profile_119_03_00_2",center=Vector3.new(1256.445585,108.625191,896.048382),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G030_wall_profile_119_03_00_2",center=Vector3.new(1255.522374,109.702199,895.972361),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G031_wall_profile_119_03_00_2",center=Vector3.new(1254.23208,110.394164,895.866122),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G032_wall_profile_top_119_03_",center=Vector3.new(1253.325599,110.597849,895.79149),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G033_wall_120_00_00_0",center=Vector3.new(1123.183332,97.894788,941.721235),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G034_wall_120_00_00_1",center=Vector3.new(1124.073029,98.787693,941.794477),opacity=1.0,blend=false,texture="trackmat__wall_pit_top"},
    {name="G035_wall_120_00_00_2",center=Vector3.new(1124.963052,97.89503,941.867747),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G036_wall_cap_120_00_4",center=Vector3.new(1119.561332,98.512077,996.276202),opacity=1.0,blend=false,texture="trackmat__wall_side"},
    {name="G037_wall_120_01_00_0",center=Vector3.new(1180.495071,98.795547,946.439961),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G038_wall_120_01_00_1",center=Vector3.new(1181.386948,100.580236,946.513258),opacity=1.0,blend=false,texture="trackmat__wall_pit_top"},
    {name="G039_wall_120_01_00_2",center=Vector3.new(1182.276862,98.79427,946.586554),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G040_wall_120_02_00_0",center=Vector3.new(1243.019158,98.883786,951.587868),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G041_wall_120_02_00_1",center=Vector3.new(1243.197141,100.794499,951.602527),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G042_wall_120_02_00_2",center=Vector3.new(1243.375124,98.883786,951.617159),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G043_wall_120_03_00_0",center=Vector3.new(1253.240476,102.330215,952.429444),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G044_wall_120_03_00_2",center=Vector3.new(1253.596442,102.330215,952.458736),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G045_wall_profile_120_03_00_0",center=Vector3.new(1253.112575,108.192379,952.4189),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G046_wall_profile_120_03_00_0",center=Vector3.new(1252.623149,109.286128,952.378573),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G047_wall_profile_120_03_00_0",center=Vector3.new(1251.699938,110.363136,952.302551),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G048_wall_profile_120_03_00_0",center=Vector3.new(1250.409698,111.055102,952.196366),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G049_wall_profile_120_03_00_2",center=Vector3.new(1253.468541,108.192379,952.448218),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G050_wall_profile_120_03_00_2",center=Vector3.new(1252.979115,109.286128,952.407891),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G051_wall_profile_120_03_00_2",center=Vector3.new(1252.055849,110.363136,952.33187),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G052_wall_profile_120_03_00_2",center=Vector3.new(1250.765555,111.055102,952.225631),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G053_wall_profile_top_120_03_",center=Vector3.new(1249.859074,111.258786,952.151026),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G054_wall_121_00_00_0",center=Vector3.new(1128.851536,99.275885,1003.835188),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G055_wall_121_00_00_1",center=Vector3.new(1129.029465,100.883034,1003.849847),opacity=1.0,blend=false,texture="trackmat__armco_l02"},
    {name="G056_wall_121_00_00_2",center=Vector3.new(1129.207502,99.275902,1003.864506),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G057_wall_cap_121_00_3",center=Vector3.new(1119.561277,99.226359,996.276147),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G058_wall_121_01_00_0",center=Vector3.new(1175.417273,99.456767,1007.669122),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G059_wall_121_01_00_1",center=Vector3.new(1176.307624,101.242229,1007.742419),opacity=1.0,blend=false,texture="trackmat__wall_pit_top"},
    {name="G060_wall_121_01_00_2",center=Vector3.new(1177.197538,99.456327,1007.815715),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G061_wall_121_02_00_0",center=Vector3.new(1237.857056,99.56884,1012.810135),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G062_wall_121_02_00_1",center=Vector3.new(1238.035039,101.479554,1012.824794),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G063_wall_121_02_00_2",center=Vector3.new(1238.213021,99.56884,1012.839454),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G064_wall_121_03_00_0",center=Vector3.new(1249.453572,103.01527,1013.764954),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G065_wall_121_03_00_2",center=Vector3.new(1249.809538,103.01527,1013.794218),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G066_wall_profile_121_03_00_0",center=Vector3.new(1249.325671,108.877434,1013.754381),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G067_wall_profile_121_03_00_0",center=Vector3.new(1248.836299,109.971183,1013.714055),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G068_wall_profile_121_03_00_0",center=Vector3.new(1247.913034,111.048191,1013.638088),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G069_wall_profile_121_03_00_0",center=Vector3.new(1246.622794,111.740157,1013.531821),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G070_wall_profile_121_03_00_2",center=Vector3.new(1249.681636,108.877434,1013.783646),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G071_wall_profile_121_03_00_2",center=Vector3.new(1249.192211,109.971183,1013.743373),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G072_wall_profile_121_03_00_2",center=Vector3.new(1248.268999,111.048191,1013.667352),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G073_wall_profile_121_03_00_2",center=Vector3.new(1246.978705,111.740157,1013.56114),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G074_wall_profile_top_121_03_",center=Vector3.new(1246.07217,111.943841,1013.486535),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G075_wall_122_00_00_0",center=Vector3.new(1135.047858,99.464151,1051.116289),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G076_wall_122_00_00_1",center=Vector3.new(1135.225786,101.071293,1051.130949),opacity=1.0,blend=false,texture="trackmat__armco_l02"},
    {name="G077_wall_122_00_00_2",center=Vector3.new(1135.403824,99.464158,1051.145608),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G078_wall_122_01_00_0",center=Vector3.new(1171.564811,99.643472,1054.12287),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G079_wall_122_01_00_1",center=Vector3.new(1172.455052,101.428999,1054.196167),opacity=1.0,blend=false,texture="trackmat__wall_pit_top"},
    {name="G080_wall_122_01_00_2",center=Vector3.new(1173.344912,99.643285,1054.269464),opacity=1.0,blend=false,texture="trackmat__wall_pit"},
    {name="G081_wall_122_02_00_0",center=Vector3.new(1233.940615,99.762954,1059.258597),opacity=1.0,blend=false,texture="trackmat__armco_l"},
    {name="G082_wall_122_02_00_1",center=Vector3.new(1234.118598,101.673668,1059.273257),opacity=1.0,blend=false,texture="trackmat__armco_top"},
    {name="G083_wall_122_02_00_2",center=Vector3.new(1234.296581,99.762954,1059.287916),opacity=1.0,blend=false,texture="trackmat__armco_r"},
    {name="G084_wall_122_03_00_0",center=Vector3.new(1246.580505,103.209383,1060.299301),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G085_wall_122_03_00_2",center=Vector3.new(1246.936471,103.209383,1060.328565),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G086_wall_profile_122_03_00_0",center=Vector3.new(1246.452604,109.071548,1060.288729),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G087_wall_profile_122_03_00_0",center=Vector3.new(1245.963178,110.165296,1060.248457),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G088_wall_profile_122_03_00_0",center=Vector3.new(1245.039967,111.242305,1060.172435),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G089_wall_profile_122_03_00_0",center=Vector3.new(1243.749673,111.93427,1060.066223),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
    {name="G090_wall_profile_122_03_00_2",center=Vector3.new(1246.808515,109.071548,1060.318048),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G091_wall_profile_122_03_00_2",center=Vector3.new(1246.319144,110.165296,1060.277775),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G092_wall_profile_122_03_00_2",center=Vector3.new(1245.395878,111.242305,1060.201754),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G093_wall_profile_122_03_00_2",center=Vector3.new(1244.105639,111.93427,1060.095542),opacity=1.0,blend=true,texture="trackmat__wiref_l"},
    {name="G094_wall_profile_top_122_03_",center=Vector3.new(1243.199103,112.137955,1060.020883),opacity=1.0,blend=true,texture="trackmat__wiref_r"},
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
