Vector3.yAxis=Vector3.new(0,1,0)
Enum.RaycastFilterType.Include="Include"
function CFrame.lookAt(eye,target,up)
    local f=(target-eye).Unit;local r=f:Cross(up).Unit;local b=-f;local u=b:Cross(r)
    return CFrame.new(eye.X,eye.Y,eye.Z,r.X,u.X,b.X,r.Y,u.Y,b.Y,r.Z,u.Z,b.Z)
end
local col={}
function col:IsDescendantOf(root) return root==workspace end
local spawn={Name="track1",CFrame=CFrame.new(0,0.125,0),Position=Vector3.new(0,0.125,0)}
function spawn:IsDescendantOf(root) return root==workspace end
function spawn:IsA(name) return name=="SpawnLocation" end
local config={CollisionRoot={Value=col},Spawn={Value=spawn},attrs={}}
function config:FindFirstChild(name) return self[name] end
function config:GetAttribute(name) return self.attrs[name] end
function package:FindFirstChild(name) return name=="Track1Config" and config or nil end
packageAttributes.NR2003Track="track1"
local rawRaycast=workspace.Raycast
local queries=0
local missing=false
function workspace:Raycast(origin,direction,params)
    assert(params.FilterType=="Include" and params.FilterDescendantsInstances[1]==col,
        "track1 contacted the old world or the visual meshes")
    queries+=1
    if missing then return nil end
    return rawRaycast(self,origin,direction)
end
function workspace:Blockcast() error("track1 applied the provisional host boundary clip") end
local ctl=Adapter.new(car,TestTune,{}, {prepareSpawn=false})
check("track1 selects host mesh contacts and never loads the old world",ctl.track1 and not ctl.originalTrack and not ctl.core:trackLoaded())
check("car originates beside dedicated track1 marker",math.abs(ctl.origin.Position.X+8)<1e-6
    and math.abs(ctl.origin.Position.Y)<1e-6)
local input={throttle=0,brake=0,steer=0,clutch=0}
for _=1,10 do ctl:step(1/36,input) end
check("original core steps against col-only raycasts",not ctl.fault and ctl.core:tick()==80 and queries>100,tostring(ctl.fault))
local tel=ctl:telemetry()
check("HUD packet identifies track1 and original asphalt grip",tel.track.name=="track1"
    and tel.track.parameters.asphaltGrip==0.800000011920929 and tel.track.wheels[1].surface==1)
ground.attrs.NRSurface=2;ground.attrs.NRGripMultiplier=0.75
ctl:contacts(1)
check("concrete and local contact multiplier enter tire arguments",ctl.planes[1][8]==2 and ctl.planes[1][9]==0.75)
SLOPE=0.1
ctl:contacts(1)
local expected=Vector3.new(0,1,-SLOPE).Unit
local nx,ny,nz=ctl:numericVector(expected)
check("banked road normals are converted without flattening",math.abs(ctl.planes[1][1]-nx)<1e-8
    and math.abs(ctl.planes[1][2]-ny)<1e-8 and math.abs(ctl.planes[1][3]-nz)<1e-8)
missing=true;ctl:contacts(2)
check("missing road gives no grounded contact",not ctl.inContact[1] and not ctl.inContact[4])
missing=false;SLOPE=0;ground.attrs.NRSurface=1;ground.attrs.NRGripMultiplier=1
spawn.CFrame=CFrame.new(100,0.125,50);spawn.Position=Vector3.new(100,0.125,50)
config.attrs.TrackAsphaltGrip=1.05;config.attrs.TrackTireHeat=1.12
ctl:reset()
check("reset rereads moved track1 marker instead of Watkins spawn",math.abs(ctl.origin.Position.X-92)<1e-6
    and math.abs(ctl.origin.Position.Z-50)<1e-6 and not ctl.core:trackLoaded())
check("reset reapplies independent track surface settings",ctl.core.V.r32(0x74fb34)==0x3f570a3d
    and math.abs(attributes.Track1_tireHeat-1.12)<1e-6)
ctl:step(1/36,input)
check("reset leaves original thermal/wear simulation drivable",not ctl.fault and ctl.core:tick()==8)
local localCtl=Adapter.new(car,TestTune,nil,{client=true,networked=true,driver=function() return true end,prepareSpawn=false})
check("predicted client attaches to the same col and parameter inputs",localCtl.clientSimulation and localCtl.networked
    and localCtl.track1Col==col and localCtl.core.V.r32(0x74fb34)==ctl.core.V.r32(0x74fb34))
local assists=localCtl:telemetry().assists
check("existing original driving assist options are preserved",assists.automatic and assists.autoClutch and assists.abs
    and not assists.tractionControl and not assists.stabilityControl)
print(string.format("track1 adapter: %d passed, %d failed",passed,failed))
if failed>0 then error("track1 adapter failures") end
