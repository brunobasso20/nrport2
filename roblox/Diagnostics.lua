-- Run in Studio before and during Play. Checks actual Instances/CFrames.
local M={}
function M.run(car,tune)
    tune=tune or require(script.Parent.Parent.Core.TestTune).new()
    local errors,warnings={},{}; local root=car:FindFirstChild("Chassis")
    local function expect(value,message) if not value then table.insert(errors,message) end end
    expect(root and root:IsA("BasePart"),"Chassis missing or not BasePart")
    if not root then return {ok=false,errors=errors,warnings=warnings} end
    expect(car.PrimaryPart==root,"PrimaryPart must be Chassis")
    local corePose=car:GetAttribute("NR2003CorePoseOwner")==true
    local count,massive,colliding=0,0,0
    for _,p in ipairs(car:GetDescendants()) do
        if p:IsA("BasePart") then
            count=count+1
            expect((p==root and corePose) or not p.Anchored,p:GetFullName().." is unexpectedly anchored")
            if not p.Massless then massive=massive+1 end
            if p.CanCollide then colliding=colliding+1 end
            if p~=root then
                expect(p.Massless,p:GetFullName().." adds mass")
                expect(not p.CanCollide,p:GetFullName().." adds unwanted tire/body contact")
            end
        end
    end
    expect(massive==1,"Exactly one massive part is required")
    expect(colliding==(corePose and 0 or 1),"Collision ownership differs from physics mode")
    if corePose then expect(root.Anchored,"Numeric chassis must be pose-owned") end
    local graph={}; local connected={[root]=true}
    for _,j in ipairs(car:GetDescendants()) do
        if j:IsA("JointInstance") and j.Part0 and j.Part1 then
            graph[j.Part0]=graph[j.Part0] or {}; graph[j.Part1]=graph[j.Part1] or {}
            table.insert(graph[j.Part0],j.Part1); table.insert(graph[j.Part1],j.Part0)
        end
    end
    local queue={root}; local index=1
    while index<=#queue do
        local p=queue[index]; index=index+1
        for _,q in ipairs(graph[p] or {}) do if not connected[q] then connected[q]=true; table.insert(queue,q) end end
    end
    for _,p in ipairs(car:GetDescendants()) do
        if p:IsA("BasePart") then expect(connected[p],p:GetFullName().." is not connected to chassis") end
    end
    local corners={}
    for _,c in ipairs(tune.corners) do
        local mount=root:FindFirstChild("Mount_"..c.name)
        local group=car.Wheels:FindFirstChild(c.name)
        expect(mount~=nil,"Mount missing: "..c.name); expect(group~=nil,"Wheel group missing: "..c.name)
        if mount and group then
            local expected=Vector3.new(c.x,tune.mountY,c.z)/tune.metresPerStud
            expect((mount.Position-expected).Magnitude<0.001,"Mount position differs from tune: "..c.name)
            expect(group.Hub:FindFirstChild("SuspensionMotor")~=nil,"Suspension motor missing: "..c.name)
            expect(group.Wheel:FindFirstChild("SpinMotor")~=nil,"Spin motor missing: "..c.name)
            local axis=group.Hub.WheelAxis
            expect(math.abs(axis.Axis:Dot(Vector3.new(1,0,0))-1)<1e-6,"Wheel axis must be local +X: "..c.name)
            local ray=workspace:Raycast(mount.WorldPosition,-root.CFrame.UpVector*
                ((tune.springFreeLength+tune.wheelRadius+0.1)/tune.metresPerStud),
                (function() local p=RaycastParams.new(); p.FilterType=Enum.RaycastFilterType.Exclude
                    p.FilterDescendantsInstances={car}; p.RespectCanCollide=true; return p end)())
            corners[c.name]={mount=mount.Position,axis=axis.WorldAxis,ground=ray and ray.Instance:GetFullName() or "none"}
            if not ray then table.insert(warnings,"No ground under "..c.name.." (expected during jumps)") end
        end
    end
    local result={ok=#errors==0,errors=errors,warnings=warnings,parts=count,corners=corners,
        connectedParts=#queue,configuredMassKg=tune.mass,assemblyMassUnits=root.AssemblyMass}
    print("NR2003 Diagnostics",result.ok and "PASS" or "FAIL",count,"parts",#queue,"connected")
    for _,e in ipairs(errors) do warn(e) end
    for _,w in ipairs(warnings) do warn(w) end
    return result
end
return M
