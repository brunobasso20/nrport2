-- Generated Watkins Glen visual installer: watkins_glen_scenery_003.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_scenery_003"
local KIND = "scenery"
local SOURCE_HASH = "5f47163467a16675ac07d2e1d21bb6453ed77d89f3845a715f016aee8495febc"
local GEOMETRIES = {
    {name="G000_cmpr_line2_312_0",center=Vector3.new(-898.495629,106.57039,898.198315),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G001_cmpr_line2_312_1",center=Vector3.new(-898.18427,107.2858,894.748761),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G002_cmpr_line1_313_0",center=Vector3.new(-384.955656,118.725354,-952.660549),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G003_cmpr_line1_313_1",center=Vector3.new(-385.59798,119.216807,-945.871602),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G004_cmpr_line2_314_0",center=Vector3.new(-362.558531,118.686985,-831.66454),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G005_cmpr_line2_314_1",center=Vector3.new(-360.997012,119.201606,-834.883589),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G006_cmpr_line1_315_0",center=Vector3.new(-292.618203,117.69057,-470.62109),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G007_cmpr_line1_315_1",center=Vector3.new(-293.916636,118.132358,-461.089758),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G008_cmpr_line2_316_0",center=Vector3.new(-320.421853,118.686985,-592.411303),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G009_cmpr_line2_316_1",center=Vector3.new(-318.924603,119.201606,-595.655749),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G010_cmpr_line1_317_0",center=Vector3.new(-342.24346,118.725354,-715.293498),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G011_cmpr_line1_317_1",center=Vector3.new(-342.188642,119.216807,-721.416648),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G012_cmpr_line2_318_0",center=Vector3.new(-406.87168,118.686985,-1080.422331),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G013_cmpr_line2_318_1",center=Vector3.new(-408.368929,119.201606,-1077.177885),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G014_cmpr_line1_319_0",center=Vector3.new(172.201671,100.472318,252.148683),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G015_cmpr_line1_319_1",center=Vector3.new(171.673697,101.123599,256.818654),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G016_cmpr_line2_320_0",center=Vector3.new(277.626411,99.613188,294.204147),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G017_cmpr_line2_320_1",center=Vector3.new(273.936504,100.20911,292.970561),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G018_cmpr_line2_321_0",center=Vector3.new(-258.253611,114.18218,-343.015198),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G019_cmpr_line2_321_1",center=Vector3.new(-259.442988,116.119886,-339.505906),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G020_cmpr_line1_322_0",center=Vector3.new(-224.42979,110.547713,-225.496358),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G021_cmpr_line1_322_1",center=Vector3.new(-225.386325,110.989501,-214.882129),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G022_cmpr_line2_323_0",center=Vector3.new(55.701138,101.398902,179.112738),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G023_cmpr_line2_323_1",center=Vector3.new(54.68237,101.994824,175.709209),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G024_cmpr_line1_324_0",center=Vector3.new(-571.100394,117.653928,-1970.803654),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G025_cmpr_line1_324_1",center=Vector3.new(-570.45807,118.145382,-1977.592601),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G026_cmpr_line2_325_0",center=Vector3.new(-587.266833,114.18218,-2094.210628),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G027_cmpr_line2_325_1",center=Vector3.new(-585.801873,116.119886,-2097.630906),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G028_cmpr_line1_326_0",center=Vector3.new(-616.53347,112.367944,-2204.39417),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G029_cmpr_line1_326_1",center=Vector3.new(-615.185824,112.759931,-2213.371087),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G030_cmpr_line2_327_0",center=Vector3.new(-547.026109,117.61556,-1854.065824),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G031_cmpr_line2_327_1",center=Vector3.new(-548.523359,118.13018,-1850.821379),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G032_cmpr_line1_328_0",center=Vector3.new(-500.014803,117.653928,-1491.044014),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G033_cmpr_line1_328_1",center=Vector3.new(-504.758604,118.145382,-1491.238986),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G034_cmpr_line2_329_0",center=Vector3.new(-523.016994,117.61556,-1620.080913),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G035_cmpr_line2_329_1",center=Vector3.new(-521.328383,118.13018,-1623.246233),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G036_cmpr_line1_330_0",center=Vector3.new(-524.197356,117.615173,-1735.88874),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G037_cmpr_line1_330_1",center=Vector3.new(-524.837342,118.266454,-1729.098649),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G038_d_vehicle_gr1_331_0",center=Vector3.new(881.004531,73.235517,1929.70209),opacity=1.0,blend=false,texture="d_vehicle_gr1"},
    {name="G039_d_vehicle_gr2_332_0",center=Vector3.new(900.965183,75.722193,1889.64359),opacity=1.0,blend=false,texture="d_vehicle_gr2"},
    {name="G040_d_vehicle_gr2_333_0",center=Vector3.new(905.730522,78.912555,1830.132759),opacity=1.0,blend=false,texture="d_vehicle_gr2"},
    {name="G041_d_vehicle_gr1_334_0",center=Vector3.new(887.436551,76.127395,1872.868276),opacity=1.0,blend=false,texture="d_vehicle_gr1"},
    {name="G042_d_vehicle_gr2_335_0",center=Vector3.new(898.366315,72.841124,1945.989161),opacity=1.0,blend=false,texture="d_vehicle_gr2"},
    {name="G043_cmpr_line1_336_0",center=Vector3.new(-731.230995,128.368214,-1530.167304),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G044_cmpr_line1_336_1",center=Vector3.new(-735.272923,128.859667,-1530.285715),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G045_cmpr_line2_337_0",center=Vector3.new(-769.001218,128.329845,-2104.540706),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G046_cmpr_line2_337_1",center=Vector3.new(-766.879843,128.844466,-2106.816346),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G047_cmpr_line1_338_0",center=Vector3.new(-739.922936,128.368214,-1991.00376),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G048_cmpr_line1_338_1",center=Vector3.new(-742.911276,128.859667,-1993.724929),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G049_cmpr_line2_339_0",center=Vector3.new(-825.067677,126.68218,-2338.764923),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G050_cmpr_line2_339_1",center=Vector3.new(-822.946302,128.619886,-2341.219575),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G051_cmpr_line1_340_0",center=Vector3.new(-780.48859,128.368214,-2220.135622),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G052_cmpr_line1_340_1",center=Vector3.new(-783.47693,128.859667,-2222.856791),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G053_cmpr_line2_341_0",center=Vector3.new(-725.001628,128.329845,-1875.667153),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G054_cmpr_line2_341_1",center=Vector3.new(-722.880253,128.844466,-1877.942794),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G055_cmpr_line1_342_0",center=Vector3.new(-853.723107,114.658801,-2479.173847),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G056_cmpr_line1_342_1",center=Vector3.new(-856.725093,114.16032,-2482.553634),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G057_cmpr_line2_343_0",center=Vector3.new(-728.913328,128.329845,-1646.792402),opacity=1.0,blend=false,texture="cmpr_line2"},
    {name="G058_cmpr_line2_343_1",center=Vector3.new(-726.791952,128.844466,-1649.068042),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G059_cmpr_line1_344_0",center=Vector3.new(-728.381242,128.368214,-1760.668198),opacity=1.0,blend=false,texture="cmpr_line1"},
    {name="G060_cmpr_line1_344_1",center=Vector3.new(-731.369582,128.859667,-1763.389366),opacity=1.0,blend=false,texture="cmprs_only"},
    {name="G061_infield_345_0_cell__2__1",center=Vector3.new(133.776118,-1.25,2363.885085),opacity=1.0,blend=false,texture="infield"},
    {name="G062_infield_345_0_cell__2__1",center=Vector3.new(465.535355,37.834828,2247.802407),opacity=1.0,blend=false,texture="infield"},
    {name="G063_infield_345_0_cell__2_0_",center=Vector3.new(-84.735472,32.060405,2117.366949),opacity=1.0,blend=false,texture="infield"},
    {name="G064_infield_345_0_cell__1__1",center=Vector3.new(543.382372,78.672818,942.210329),opacity=1.0,blend=false,texture="infield"},
    {name="G065_infield_345_0_cell__1_0_",center=Vector3.new(-472.829249,87.98832,900.0),opacity=1.0,blend=false,texture="infield"},
    {name="G066_infield_345_0_cell_0_0_0",center=Vector3.new(-533.320686,108.13103,-900.0),opacity=1.0,blend=false,texture="infield"},
    {name="G067_infield_345_0_cell_1_0_0",center=Vector3.new(-739.928447,106.735212,-2183.805084),opacity=1.0,blend=false,texture="infield"},
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
