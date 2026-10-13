-- Generated Watkins Glen visual installer: watkins_glen_terrain_054.glb.
-- Import this GLB into Workspace with Studio's 3D Importer, then run this in the Command Bar outside Play.
-- Uses the four NR2003 markers to undo importer translation/rotation/uniform scale.
-- Keeps the previous chunk in ServerStorage.NR2003Backup_TrackVisuals. Does not save the place.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing track assets")
local Selection = game:GetService("Selection")
local storage = game:GetService("ServerStorage")
local PACKAGE = "watkins_glen_terrain_054"
local KIND = "terrain"
local SOURCE_HASH = "73d194e33f017ef3c60a651fc8d96ab3d23c0cdad63f14ec61938029c14ee2ec"
local GEOMETRIES = {
    {name="G000_terrain_074_02",center=Vector3.new(-427.881677,93.368438,-2480.078452),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G001_terrain_074_03",center=Vector3.new(-409.245328,95.697808,-2485.252271),opacity=1.0,blend=false,texture="trackmat__concrete"},
    {name="G002_terrain_074_04",center=Vector3.new(-398.101234,97.278588,-2489.232962),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G003_terrain_074_05",center=Vector3.new(-393.037237,98.036405,-2489.783587),opacity=1.0,blend=false,texture="trackmat__paint"},
    {name="G004_terrain_074_06",center=Vector3.new(-367.9389,98.415862,-2493.435124),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G005_terrain_074_07",center=Vector3.new(-357.87374,98.523756,-2498.526219),opacity=1.0,blend=false,texture="trackmat__grassedge"},
    {name="G006_terrain_074_08",center=Vector3.new(-236.806703,98.326785,-2547.029223),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G007_terrain_075_00",center=Vector3.new(-550.09628,97.039362,-2398.510415),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G008_terrain_075_01",center=Vector3.new(-424.213491,93.760143,-2423.146384),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G009_terrain_075_02",center=Vector3.new(-401.004614,95.602219,-2427.778516),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G010_terrain_075_03",center=Vector3.new(-378.312724,98.03194,-2432.302856),opacity=1.0,blend=false,texture="trackmat__paint"},
    {name="G011_terrain_075_04",center=Vector3.new(-343.594851,98.408723,-2437.400273),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G012_terrain_075_05",center=Vector3.new(-204.738961,98.326683,-2468.334307),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G013_terrain_076_00",center=Vector3.new(-524.832112,99.969094,-2284.92933),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G014_terrain_076_01",center=Vector3.new(-401.141235,96.154598,-2307.296753),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G015_terrain_076_02",center=Vector3.new(-377.909837,96.175231,-2311.95112),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G016_terrain_076_03",center=Vector3.new(-355.219405,98.027015,-2316.475568),opacity=1.0,blend=false,texture="trackmat__paint"},
    {name="G017_terrain_076_04",center=Vector3.new(-353.086131,98.290542,-2317.196219),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G018_terrain_076_05",center=Vector3.new(-349.329608,98.317443,-2317.633602),opacity=1.0,blend=false,texture="trackmat__grassedge"},
    {name="G019_terrain_076_06",center=Vector3.new(-294.375154,95.831547,-2314.64822),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G020_terrain_076_07",center=Vector3.new(-272.998946,94.841184,-2334.616416),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G021_terrain_076_08",center=Vector3.new(-162.496513,91.125659,-2361.647688),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G022_terrain_077_00",center=Vector3.new(-483.826951,103.404978,-2135.742732),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G023_terrain_077_01",center=Vector3.new(-371.552549,98.023432,-2158.344705),opacity=1.0,blend=false,texture="trackmat__dirt"},
    {name="G024_terrain_077_02",center=Vector3.new(-348.209681,98.023432,-2162.995693),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G025_terrain_077_03",center=Vector3.new(-325.514208,97.996388,-2167.519924),opacity=1.0,blend=false,texture="trackmat__paint"},
    {name="G026_terrain_077_04",center=Vector3.new(-324.191121,97.996058,-2167.945971),opacity=1.0,blend=false,texture="trackmat__asphalt"},
    {name="G027_terrain_077_05",center=Vector3.new(-321.968106,97.994784,-2168.238286),opacity=1.0,blend=false,texture="trackmat__grassedge"},
    {name="G028_terrain_077_06",center=Vector3.new(-244.112144,94.678034,-2179.074533),opacity=1.0,blend=false,texture="trackmat__grass"},
    {name="G029_terrain_077_07",center=Vector3.new(-166.550098,90.859345,-2198.905727),opacity=1.0,blend=false,texture="trackmat__asphalt"},
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
