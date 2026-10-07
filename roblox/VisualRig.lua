local M={}; M.__index=M
function M.new(car,tune)
    local self=setmetatable({root=car.Chassis,tune=tune,wheels={},rods={}},M)
    for j,c in ipairs(tune.corners) do
        local w=car.Wheels[c.name]
        self.wheels[j]={hub=w.Hub.SuspensionMotor,spin=w.Wheel.SpinMotor,beam=w.ContactRay,
            contact=car.Chassis["Contact_"..c.name]}; self.rods[j]={}
        for _,p in ipairs(car.Suspension[c.name]:GetChildren()) do
            if p:IsA("BasePart") then table.insert(self.rods[j],{part=p,weld=p.Pose,
                inner=p:GetAttribute("Inner"),coil=p:GetAttribute("CoilIndex")}) end
        end
    end
    return self
end
local function poseRod(r,a,b)
    local d=b-a; if d.Magnitude<0.001 then return end
    r.part.Size=Vector3.new(r.part.Size.X,d.Magnitude,r.part.Size.Z)
    r.weld.C0=CFrame.lookAt((a+b)*0.5,(a+b)*0.5+d)*CFrame.Angles(math.pi/2,0,0)
end
function M:update(dynamics,contacts,debugVisible)
    local t=self.tune; local m=t.metresPerStud
    for j,c in ipairs(t.corners) do
        local w,rig=dynamics.wheels[j],self.wheels[j]
        local hub=Vector3.new(c.x,t.mountY-t.springFreeLength+w.compression,c.z)/m
        rig.hub.C0=CFrame.new(hub)*CFrame.Angles(0,-w.steer,0)*CFrame.Angles(0,0,-c.side*t.steering.camber)
        rig.spin.C0=CFrame.Angles(-w.angle,0,0)
        rig.contact.Position=self.root.CFrame:PointToObjectSpace(contacts[j].point); rig.beam.Enabled=debugVisible
        rig.beam.Color=ColorSequence.new(contacts[j].grounded and Color3.fromRGB(50,220,110) or Color3.fromRGB(235,70,60))
        for _,r in ipairs(self.rods[j]) do
            if r.coil then
                local delta=hub-r.inner; local frame=CFrame.lookAt(r.inner,hub)
                local function helix(f)
                    local a=f*math.pi*8
                    return r.inner+delta*f+frame.RightVector*(math.cos(a)*0.06/m)+frame.UpVector*(math.sin(a)*0.06/m)
                end
                poseRod(r,helix((r.coil-1)/16),helix(r.coil/16))
            else poseRod(r,r.inner,hub) end
        end
    end
end
return M
