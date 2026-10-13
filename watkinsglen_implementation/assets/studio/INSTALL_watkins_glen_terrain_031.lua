-- Generated Watkins Glen visual installer: watkins_glen_terrain_031.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_terrain_031"
local KIND = "terrain"
local SOURCE_HASH = "04800240295547afcfc4ea53b30afcab2dea262dd38888ed6381d6dd7d662a6f"
local GEOMETRIES = {
    {name="G000_terrain_058_02",center=Vector3.new(-1164.056832,120.155607,-2142.661176),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G001_terrain_058_03",center=Vector3.new(-1215.955516,120.206867,-2142.05562),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G002_terrain_058_04",center=Vector3.new(-1230.955614,120.000975,-2141.890826),opacity=1.0,blend=false,texture="trackmat__curbing"},
    {name="G003_terrain_058_05",center=Vector3.new(-1246.616418,119.776106,-2141.705758),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G004_terrain_058_06",center=Vector3.new(-1268.822043,119.776106,-2141.443634),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G005_terrain_058_07",center=Vector3.new(-1280.866677,119.776106,-2141.307722),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G006_terrain_058_08",center=Vector3.new(-1433.520235,119.776106,-2139.52822),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G007_terrain_059_00",center=Vector3.new(-951.192393,119.944641,-2148.746164),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G008_terrain_059_01_baked_f_0",center=Vector3.new(-1120.842634,120.117446,-2146.746063),opacity=1.0,blend=false,texture="baked_f_04056_00_00"},
    {name="G009_terrain_059_02",center=Vector3.new(-1167.272513,120.164701,-2146.194022),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G010_terrain_059_03",center=Vector3.new(-1217.675018,120.216036,-2145.608194),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G011_terrain_059_04",center=Vector3.new(-1231.930596,120.000969,-2145.451137),opacity=1.0,blend=false,texture="trackmat__curbing"},
    {name="G012_terrain_059_05",center=Vector3.new(-1258.101,119.776092,-2145.139858),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G013_terrain_059_06",center=Vector3.new(-1280.913489,119.776092,-2144.87915),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G014_terrain_059_07",center=Vector3.new(-1433.565412,119.776092,-2143.098995),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G015_terrain_060_00",center=Vector3.new(-953.512355,119.946739,-2152.292851),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G016_terrain_060_01_baked_f_0",center=Vector3.new(-1125.11395,120.121356,-2150.268773),opacity=1.0,blend=false,texture="baked_f_04116_00_00"},
    {name="G017_terrain_060_02",center=Vector3.new(-1170.013918,120.167051,-2149.726105),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G018_terrain_060_03",center=Vector3.new(-1218.882588,120.216778,-2149.166761),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G019_terrain_060_04",center=Vector3.new(-1232.59855,120.000955,-2149.016353),opacity=1.0,blend=false,texture="trackmat__curbing"},
    {name="G020_terrain_060_05",center=Vector3.new(-1258.593042,119.776072,-2148.708235),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G021_terrain_060_06",center=Vector3.new(-1280.956105,119.776072,-2148.450252),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G022_terrain_060_07",center=Vector3.new(-1433.63533,119.776072,-2146.669987),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G023_terrain_061_00",center=Vector3.new(-960.357557,119.946705,-2159.7726),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G024_terrain_061_01_baked_f_0",center=Vector3.new(-1133.867863,120.116261,-2157.674844),opacity=1.0,blend=false,texture="baked_f_04178_00_00"},
    {name="G025_terrain_061_02",center=Vector3.new(-1173.288509,120.161472,-2157.151576),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G026_terrain_061_03",center=Vector3.new(-1219.89212,120.20137,-2156.664712),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G027_terrain_061_04",center=Vector3.new(-1232.679204,120.000921,-2156.520626),opacity=1.0,blend=false,texture="trackmat__curbing"},
    {name="G028_terrain_061_05",center=Vector3.new(-1258.908245,119.776024,-2156.218828),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G029_terrain_061_06",center=Vector3.new(-1281.02684,119.776024,-2155.959865),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G030_terrain_061_07",center=Vector3.new(-1433.798,119.776024,-2154.179491),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G031_terrain_062_00",center=Vector3.new(-988.31204,119.939927,-2188.883645),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G032_terrain_062_01_baked_f_0",center=Vector3.new(-1168.6106,120.029776,-2186.488669),opacity=1.0,blend=false,texture="baked_f_04240_00_00"},
    {name="G033_terrain_062_02",center=Vector3.new(-1180.73022,120.063244,-2186.024039),opacity=1.0,blend=false,texture="trackmat__sand"},
    {name="G034_terrain_062_03",center=Vector3.new(-1222.082247,119.471352,-2185.862405),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G035_terrain_062_04",center=Vector3.new(-1232.954407,119.983251,-2185.7181),opacity=1.0,blend=false,texture="trackmat__curbing"},
    {name="G036_terrain_062_05",center=Vector3.new(-1259.128789,119.775704,-2185.429818),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G037_terrain_062_06",center=Vector3.new(-1281.298338,119.775704,-2185.167258),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G038_terrain_062_07",center=Vector3.new(-1434.425899,119.775704,-2183.386557),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G039_terrain_063_00",center=Vector3.new(-1000.497355,119.859512,-2230.230059),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G040_terrain_063_01_baked_f_0",center=Vector3.new(-1202.411979,119.864873,-2227.651869),opacity=1.0,blend=false,texture="baked_f_04302_00_00"},
    {name="G041_terrain_063_02_baked_f_0",center=Vector3.new(-1224.906376,119.351224,-2227.511488),opacity=1.0,blend=false,texture="baked_f_04305_00_00"},
    {name="G042_terrain_063_03",center=Vector3.new(-1236.611503,119.802202,-2227.37405),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G043_terrain_063_04",center=Vector3.new(-1259.340995,119.775111,-2227.108111),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G044_terrain_063_05",center=Vector3.new(-1281.824548,119.775111,-2226.846313),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G045_terrain_063_06",center=Vector3.new(-1435.078485,119.775111,-2225.060926),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G046_terrain_064_00",center=Vector3.new(-1011.607034,119.774457,-2266.852243),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G047_terrain_064_01_baked_f_0",center=Vector3.new(-1223.29483,119.774457,-2264.178685),opacity=1.0,blend=false,texture="baked_f_04358_00_00"},
    {name="G048_terrain_064_02",center=Vector3.new(-1236.970792,119.774457,-2264.128331),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G049_terrain_064_03",center=Vector3.new(-1259.769658,119.774457,-2263.862828),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G050_terrain_064_04",center=Vector3.new(-1282.238225,119.774457,-2263.600595),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G051_terrain_064_05",center=Vector3.new(-1435.787691,119.774457,-2261.813028),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G052_terrain_065_00",center=Vector3.new(-1013.096183,118.722228,-2352.144187),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G053_terrain_065_01_baked_f_0",center=Vector3.new(-1233.989007,118.724823,-2350.145285),opacity=1.0,blend=false,texture="baked_f_04416_00_00"},
    {name="G054_terrain_065_02",center=Vector3.new(-1238.010189,118.724891,-2350.08316),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G055_terrain_065_03",center=Vector3.new(-1260.77216,118.724932,-2349.820709),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G056_terrain_065_04",center=Vector3.new(-1283.300018,119.773286,-2349.558803),opacity=1.0,blend=false,texture="trackmat__dirt_left"},
    {name="G057_terrain_065_05",center=Vector3.new(-1438.569478,119.773286,-2347.767421),opacity=1.0,blend=false,texture="trackmat__grass"},
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
