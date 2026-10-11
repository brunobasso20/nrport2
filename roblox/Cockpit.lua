-- Visual steering column + wheel. +Z of the pivot points toward the driver.
-- Positive road steering (right) produces clockwise rotation as seen by driver.
local Config=require(script.Parent.DriverConfig)
local M={}
local function part(parent,name,size,cf,color)
    local p=Instance.new("Part"); p.Name=name; p.Size=size; p.CFrame=cf; p.Color=color
    p.Material=Enum.Material.SmoothPlastic; p.Anchored=false; p.Massless=true
    p.CanCollide=false; p.CanTouch=false; p.CanQuery=false; p.Parent=parent
    return p
end
local function weld(a,b,name,cf,motor)
    local w=Instance.new(motor and "Motor6D" or "Weld"); w.Name=name
    w.Part0=a; w.Part1=b; w.C0=cf; w.C1=CFrame.new(); w.Parent=b
    return w
end
local function vector(values) return Vector3.new(values[1],values[2],values[3]) end
local function rod(parent,anchor,name,a,b,thickness,color)
    local cf=CFrame.lookAt((a+b)*0.5,b)
    local p=part(parent,name,Vector3.new(thickness,thickness,(b-a).Magnitude),anchor.CFrame*cf,color)
    weld(anchor,p,"VisualWeld",cf); return p
end
function M.ensure(car,tune)
    local existing=car:FindFirstChild("Cockpit")
    if existing and existing:FindFirstChild("SteeringPivot") then return existing end
    local m=tune.metresPerStud; local root=car.Chassis; local seat=car.DriverSeat
    local cockpit=existing or Instance.new("Folder"); cockpit.Name="Cockpit"; cockpit.Parent=car
    local wheelCF=seat.CFrame*CFrame.new(vector(Config.wheelOffset)/m)*CFrame.Angles(math.rad(Config.columnTiltDegrees),0,0)
    local base=root.CFrame:ToObjectSpace(wheelCF)
    local pivot=part(cockpit,"SteeringPivot",Vector3.new(0.035,0.035,0.035)/m,wheelCF,Color3.fromRGB(60,65,70))
    pivot.Transparency=1
    weld(root,pivot,"SteeringMotor",base,true)
    pivot:SetAttribute("NeutralCFrame",base)
    local geometry=Instance.new("Folder"); geometry.Name="SteeringWheel"; geometry.Parent=cockpit
    local radius=Config.wheelRadius/m; local thickness=Config.wheelTubeRadius*2/m
    local function point(angle) return Vector3.new(math.sin(angle)*radius,math.cos(angle)*radius,0) end
    for i=1,32 do
        rod(geometry,pivot,"Rim_"..i,point((i-1)*math.pi/16),point(i*math.pi/16),thickness,
            Color3.fromRGB(25,28,31))
    end
    for _,angle in ipairs({math.pi/2,-math.pi/2,math.pi}) do
        rod(geometry,pivot,"Spoke",Vector3.zero,point(angle)*0.88,0.025/m,Color3.fromRGB(160,170,181))
    end
    local hub=part(geometry,"Hub",Vector3.new(0.07,0.07,0.05)/m,wheelCF,Color3.fromRGB(58,65,75))
    weld(pivot,hub,"HubWeld",CFrame.new())
    local markerCF=CFrame.new(0,radius,0.004/m)
    local marker=part(geometry,"CenterStripe",Vector3.new(0.026,0.032,0.038)/m,
        wheelCF*markerCF,Color3.fromRGB(255,190,60)); weld(pivot,marker,"MarkerWeld",markerCF)
    local columnCF=wheelCF*CFrame.new(0,0,-0.15/m)
    local column=part(cockpit,"SteeringColumn",Vector3.new(0.035,0.035,0.30)/m,
        columnCF,Color3.fromRGB(115,125,135))
    weld(root,column,"ColumnMount",root.CFrame:ToObjectSpace(columnCF))
    local camera=Instance.new("Attachment"); camera.Name="CockpitCamera"
    camera.CFrame=CFrame.new(vector(Config.cameraOffset)/m)*CFrame.Angles(math.rad(Config.cameraPitchDegrees),0,0)
    camera.Parent=seat
    local axis=Instance.new("Attachment"); axis.Name="SteeringAxis"; axis.Parent=pivot
    axis.CFrame=CFrame.Angles(0,-math.pi/2,0) -- Attachment.Axis = pivot local +Z
    car:SetAttribute("SteeringRatio",Config.steeringRatio)
    return cockpit
end
function M.angle(roadAngle,tune)
    local ratio=(tune.steering and tune.steering.wheelRatio) or Config.steeringRatio
    return roadAngle*ratio
end
-- Stage 12 (NR2003_CUP): the steering wheel at an angle given directly (rad, + = clockwise seen by the driver),
-- the ORIGINAL 005662d0 angle of the core (setup ratio + low-speed override, +-2.79 rad); no visual multiplier
function M.updateAngle(car,angle)
    local cockpit=car:FindFirstChild("Cockpit")
    local pivot=cockpit and cockpit:FindFirstChild("SteeringPivot")
    if not pivot then return end
    pivot.SteeringMotor.C0=pivot:GetAttribute("NeutralCFrame")*CFrame.Angles(0,0,-angle)
end
function M.update(car,tune,roadAngle)
    local cockpit=car:FindFirstChild("Cockpit")
    local pivot=cockpit and cockpit:FindFirstChild("SteeringPivot")
    if not pivot then return end
    local angle=M.angle(roadAngle,tune)
    pivot.SteeringMotor.C0=pivot:GetAttribute("NeutralCFrame")*CFrame.Angles(0,0,-angle)
end
return M
