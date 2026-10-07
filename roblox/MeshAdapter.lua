-- Body/FL/FR/RL/RR assets replace visuals while preserving physics reference parts.
local M={}
local function parts(item)
    local result={}; if item:IsA("BasePart") then table.insert(result,item) end
    for _,d in ipairs(item:GetDescendants()) do if d:IsA("BasePart") then table.insert(result,d) end end
    return result
end
function M.install(car,source)
    assert(car:FindFirstChild("Chassis") and source,"Car and source model required")
    local installed=0
    for _,role in ipairs({"Body","FL","FR","RL","RR"}) do
        local asset=source:FindFirstChild(role)
        if asset and (asset:IsA("BasePart") or asset:IsA("Model")) then
            local target=role=="Body" and car.Chassis or car.Wheels[role].Wheel
            local copy=asset:Clone(); copy.Name=role.."_Mesh"
            local origin=copy:IsA("Model") and copy:GetPivot() or copy.CFrame
            local offset=asset:GetAttribute("MountOffsetStuds") or Vector3.zero
            local rotation=asset:GetAttribute("MountRotationDegrees") or Vector3.zero
            local transform=CFrame.new(offset)*CFrame.Angles(math.rad(rotation.X),math.rad(rotation.Y),math.rad(rotation.Z))
            for _,d in ipairs(copy:GetDescendants()) do
                if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("Constraint") or d:IsA("JointInstance") then d:Destroy() end
            end
            local list=parts(copy); assert(#list>0,"Empty mesh role: "..role)
            for _,p in ipairs(list) do
                local localCF=transform*origin:ToObjectSpace(p.CFrame)
                p.Anchored=false; p.Massless=true; p.CanCollide=false; p.CanQuery=false; p.CanTouch=false
                p.CFrame=target.CFrame*localCF
                local weld=Instance.new("Weld"); weld.Name="ImportedVisualWeld"
                weld.Part0=target; weld.Part1=p; weld.C0=localCF; weld.C1=CFrame.new(); weld.Parent=p
            end
            local previous=car.ImportedVisuals:FindFirstChild(copy.Name); if previous then previous:Destroy() end
            copy.Parent=car.ImportedVisuals; installed=installed+#list
            local generated=role=="Body" and car.Visuals or car.Wheels[role]
            for _,p in ipairs(generated:GetDescendants()) do if p:IsA("BasePart") then p.Transparency=1 end end
            if role=="Body" then car.Chassis.Transparency=1 end
        end
    end
    return installed
end
return M
