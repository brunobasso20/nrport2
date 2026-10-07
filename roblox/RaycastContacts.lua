local Surface=require(script.Parent.Parent.Core.Surface)
local M={}; M.__index=M
function M.new(car,tune)
    local p=RaycastParams.new(); p.FilterType=Enum.RaycastFilterType.Exclude
    p.FilterDescendantsInstances={car}; p.RespectCanCollide=true; p.IgnoreWater=false
    return setmetatable({car=car,root=car.Chassis,tune=tune,params=p},M)
end
function M:sample(dynamics,velocityAtPoint)
    local root,t=self.root,self.tune; local m=t.metresPerStud; local cf=root.CFrame
    local occupant=self.car.DriverSeat.Occupant
    self.params.FilterDescendantsInstances=occupant and {self.car,occupant.Parent} or {self.car}
    local up=cf.UpVector; local samples={}
    for j,c in ipairs(t.corners) do
        local mount=root["Mount_"..c.name].WorldPosition; local lift=0.20/m
        local rayLength=(t.springFreeLength+t.wheelRadius+0.05)/m+lift
        local hit=workspace:Raycast(mount+up*lift,-up*rayLength,self.params)
        local wheelFrame=cf*CFrame.Angles(0,-dynamics.wheels[j].steer,0)*CFrame.Angles(0,0,-c.side*t.steering.camber)
        local normal=up; local point=mount-up*((t.springFreeLength+t.wheelRadius)/m)
        local grounded=false; local compression=0; local surface={grip=0.8,index=0}
        if hit then
            local cosine=hit.Normal:Dot(up)
            if cosine>t.maximumRaySlope then
                local distance=(hit.Distance-lift)*m; local length=distance-t.wheelRadius/cosine
                compression=t.springFreeLength-length; grounded=compression>=0
                normal=hit.Normal; point=hit.Position
                surface=Surface.resolve(hit.Material.Name,hit.Instance:GetAttribute("NRSurface"),hit.Instance:GetAttribute("NRGripMultiplier"))
            end
        end
        local tangent=wheelFrame.LookVector-normal*wheelFrame.LookVector:Dot(normal)
        if tangent.Magnitude<0.001 then tangent=cf.LookVector end
        local forward=tangent.Unit; local right=forward:Cross(normal).Unit
        local groundVelocity=Vector3.zero
        if hit and hit.Instance:IsA("BasePart") then groundVelocity=hit.Instance:GetVelocityAtPosition(point) end
        local v=((velocityAtPoint and velocityAtPoint(point) or root:GetVelocityAtPosition(point))-groundVelocity)*m
        local mountV=((velocityAtPoint and velocityAtPoint(mount) or root:GetVelocityAtPosition(mount))-groundVelocity)*m
        samples[j]={grounded=grounded,compression=compression,
            compressionRate=-mountV:Dot(normal)/math.max(t.maximumRaySlope,normal:Dot(up)),
            forwardSpeed=v:Dot(forward),lateralSpeed=v:Dot(right),normalSpeed=v:Dot(normal),
            camber=wheelFrame.RightVector:Dot(normal),grip=surface.grip,surface=surface.index,
            normal=normal,forward=forward,right=right,point=point,instance=hit and hit.Instance or nil}
    end
    return samples
end
return M
