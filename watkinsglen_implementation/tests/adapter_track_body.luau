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
mockRequire({ref = "Core.CupTune"}).driver.momentumKeys = 0
car.Parent = {Name = "NR2003LabWorld"}
local prepared = 0
local host = mockRequire({ref = "Roblox.NR2003WatkinsGlen"})
-- Avatar lifecycle + actual SeatAccess are exercised by spawn_mock_body.luau.
-- Here the real core/adapter must invoke preparation after its pose is ready.
host.prepareDriverSpawn = function(controller, world)
    assert(world == car.Parent and controller.rootCF and controller.core.V.worldActive())
    controller.car:PivotTo(controller.rootCF)
    prepared += 1
end
local ctl = Adapter.new(car, TestTune, {})
check("track startup prepares driver spawn without a server source patch", prepared == 1)
check("current keyboard momentum=0 is retained by original-core startup", ctl.tune.driver.momentumKeys == 0)
check("original world loaded and active", ctl.originalTrack and ctl.core.V.worldActive())
check("car and visuals share explicit origin", ctl.origin == trackOrigin)
local input = {throttle=0,brake=0,steer=0,clutch=0}
for _=1,5 do ctl:step(1/36,input) end
check("original contact ticks complete without host queries", ctl.core:tick()==40 and not ctl.fault, tostring(ctl.fault))
local tel=ctl:telemetry()
local a=tel.assists
check("production adapter applies requested default assists",a and a.automatic and a.autoClutch and a.abs
    and not a.tractionControl and not a.stabilityControl and not a.steering and not a.lowSpeedSteering)
check("HUD attributes reflect live core options",attributes.DrivingAssist_automatic==true and attributes.DrivingAssist_autoClutch==true
    and attributes.DrivingAssist_abs==true and attributes.DrivingAssist_tractionControl==false
    and attributes.DrivingAssist_stabilityControl==false and attributes.DrivingAssist_steeringAvailable==false)
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
car:SetAttribute("AutomaticTransmission",false);car:SetAttribute("AutoClutch",false);car:SetAttribute("ABS",false)
car:SetAttribute("TractionControl",true);car:SetAttribute("StabilityControl",true)
ctl:reset();a=ctl:telemetry().assists
check("car attributes select original manual clutch, TC and stability on reset",not a.automatic and not a.autoClutch
    and not a.abs and a.tractionControl and a.stabilityControl)
for _,name in ipairs({"AutomaticTransmission","AutoClutch","ABS","TractionControl","StabilityControl"}) do car:SetAttribute(name,nil) end
local localHost=Adapter.new(car,TestTune,nil,{client=true,networked=true,driver=function() return true end,prepareSpawn=false})
a=localHost:telemetry().assists
check("Stage 14 local host uses same requested default assists",localHost.clientSimulation and localHost.networked
    and a.automatic and a.autoClutch and a.abs and not a.tractionControl and not a.stabilityControl)
check("local prediction warm-up never prepares avatar spawn",prepared==1)
print(string.format("\ntrack adapter: %d passed, %d failed",passed,failed))
if failed>0 then error("track adapter tests failed") end
