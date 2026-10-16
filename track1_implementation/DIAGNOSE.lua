-- Run in the SERVER Command Bar during Play, after entering the car.
local package=assert(game:GetService("ReplicatedStorage"):FindFirstChild("NR2003Lab"),"NR2003Lab missing")
local config=assert(package:FindFirstChild("Track1Config"),"Track1Config missing")
local col=assert(config.CollisionRoot.Value,"col reference missing")
local vis=assert(config.VisualRoot.Value,"vis reference missing")
local spawn=assert(config.Spawn.Value,"track1 spawn missing")
assert(package:GetAttribute("NR2003Track")=="track1","Active track is not track1")
local counts={visual=0,collision=0,asphalt=0,concrete=0}
for _,p in ipairs(vis:GetDescendants()) do
    if p:IsA("BasePart") then
        counts.visual+=1;assert(p.Anchored and not p.CanCollide and not p.CanQuery,"Visual used for contact: "..p:GetFullName())
    end
end
for _,p in ipairs(col:GetDescendants()) do
    if p:IsA("BasePart") then
        counts.collision+=1;assert(p.Anchored and p.CanCollide and p.CanQuery,"Invalid collider: "..p:GetFullName())
        local material=p:GetAttribute("NRSurface")
        assert(material==1 or material==2,"Invalid asphalt/concrete id")
        counts[material==1 and "asphalt" or "concrete"]+=1
    end
end
local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Include
params.FilterDescendantsInstances={col};params.RespectCanCollide=true
local hit=workspace:Raycast(spawn.Position+Vector3.yAxis*80,-Vector3.yAxis*240,params)
assert(hit and hit.Normal.Y>0.5,"No upward-facing track1 road under respawn")
local car=assert(workspace.NR2003LabWorld:FindFirstChild("TestCar"),"TestCar missing")
assert(car:GetAttribute("NR2003Track")=="track1","Car is still using the old track host")
assert(not car:GetAttribute("PhysicsFault"),tostring(car:GetAttribute("PhysicsFault")))
print("TRACK1 geometry",counts.visual,"visual",counts.collision,"collision",counts.asphalt,"asphalt",counts.concrete,"concrete")
print("TRACK1 mode",car:GetAttribute("TrackContactMode"),"grip",car:GetAttribute("Track1_asphaltGrip"),car:GetAttribute("Track1_concreteGrip"))
for _,corner in ipairs({"FL","FR","RL","RR"}) do
    print(corner,"grounded",car:GetAttribute("Track1_Grounded_"..corner),"NRSurface",car:GetAttribute("Track1_Surface_"..corner))
end
print("Structural checks passed. nil wheel readings mean telemetry has not run yet; enter the car. Check seams/normals with the V2 raycast probes.")
