-- The real adapter must not feed host raycasts, averaged normals or blockcasts
-- back into the recovered world. Any such query is an immediate test failure.
local trackOrigin = CFrame.new(123, 45, -678) * CFrame.Angles(0, 0.2, 0)
local visualModel = {}
function visualModel:IsA(class) return class == "Model" end
function visualModel:GetAttribute(name) return name == "TrackOriginEnabled" and true or nil end
function visualModel:GetPivot() return trackOrigin end
function workspace:FindFirstChild(name) return name == "NR2003WatkinsGlen" and visualModel or nil end
function workspace:Raycast() error("Track adapter called Roblox Raycast") end
function workspace:Blockcast() error("Track adapter called Roblox Blockcast") end
packageAttributes.NR2003Track = "watkins_glen"
local ctl = Adapter.new(car, TestTune, {})
check("original world loaded and active", ctl.originalTrack and ctl.core.V.worldActive())
check("car and visuals share explicit origin", ctl.origin == trackOrigin)
local input = {throttle=0,brake=0,steer=0,clutch=0}
for _=1,5 do ctl:step(1/36,input) end
check("original contact ticks complete without host queries", ctl.core:tick()==40 and not ctl.fault, tostring(ctl.fault))
local tel=ctl:telemetry()
local supported=false
for _,w in ipairs(tel.wheels) do if w.grounded and w.load>0 then supported=true end end
check("telemetry reads original tire support", supported)
local record=ctl.core.V.trackPosition({})
local expected=ctl:worldPoint(record.x,record.y,record.z)
check("render position follows original absolute track coordinates", (chassis.CFrame.Position-expected).Magnitude<0.001)
check("native surfaces published as diagnostics", attributes.TrackDlongCurrent~=nil and attributes.TrackSurface~=nil)
ctl:reset()
check("reset reactivates the original world", ctl.core.V.worldActive() and ctl.origin==trackOrigin)
ctl:step(1/36,input)
check("reset remains drivable without host queries", not ctl.fault and ctl.core:tick()==8,tostring(ctl.fault))
print(string.format("\ntrack adapter: %d passed, %d failed",passed,failed))
if failed>0 then error("track adapter tests failed") end
