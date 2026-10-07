-- Generated test geometry. +X right, +Y up, -Z forward; cylinder axle is +X.
-- Wheels/arms are visual mechanisms. Raycast forces own suspension/tire physics.
local TestTune=require(script.Parent.Parent.Core.TestTune)
local Cockpit=require(script.Parent.Cockpit)
local M={}
local colors={body=Color3.fromRGB(35,87,140),frame=Color3.fromRGB(72,80,86),
    tire=Color3.fromRGB(26,27,29),metal=Color3.fromRGB(175,185,198),
    spring=Color3.fromRGB(240,177,52),brake=Color3.fromRGB(205,55,40)}
local function folder(parent,name)
    local f=Instance.new("Folder"); f.Name=name; f.Parent=parent; return f
end
local function part(parent,name,size,cf,color,shape)
    local p=Instance.new("Part"); p.Name=name; p.Size=size; p.CFrame=cf; p.Color=color
    p.Material=Enum.Material.SmoothPlastic; p.Shape=shape or Enum.PartType.Block
    p.TopSurface=Enum.SurfaceType.Smooth; p.BottomSurface=Enum.SurfaceType.Smooth
    p.Anchored=false; p.CanCollide=false; p.CanTouch=false; p.CanQuery=false; p.Massless=true
    p.Parent=parent; return p
end
local function attachment(parent,name,cf)
    local a=Instance.new("Attachment"); a.Name=name; a.CFrame=cf or CFrame.new(); a.Parent=parent; return a
end
local function joint(a,b,name,cf,motor)
    local w=Instance.new(motor and "Motor6D" or "Weld"); w.Name=name
    w.Part0=a; w.Part1=b; w.C0=cf; w.C1=CFrame.new(); w.Parent=b; return w
end
local function rod(parent,root,name,a,b,radius,color)
    local delta=b-a; local mid=(a+b)*0.5
    local cf=CFrame.lookAt(mid,mid+delta)*CFrame.Angles(math.pi/2,0,0)
    local p=part(parent,name,Vector3.new(radius,delta.Magnitude,radius),root.CFrame*cf,color)
    joint(root,p,"Pose",cf,false); return p
end
function M.create(parent,spawnCF,tune)
    tune=tune or TestTune.new(); local m=tune.metresPerStud
    local car=Instance.new("Model"); car.Name="TestCar"; car:SetAttribute("NR2003LabVersion",tune.version)
    car:SetAttribute("PhysicsMode","Recovered kernels / Roblox raycast adapter")
    car:SetAttribute("ConfiguredMassKg",tune.mass); car:SetAttribute("MetresPerStud",m)
    local visuals=folder(car,"Visuals"); local wheels=folder(car,"Wheels")
    local suspension=folder(car,"Suspension"); folder(car,"ImportedVisuals")
    local root=part(car,"Chassis",Vector3.new(tune.chassisSize[1],tune.chassisSize[2],tune.chassisSize[3])/m,spawnCF,colors.frame)
    root.Massless=false; root.CanCollide=true; root.CanQuery=true; root.RootPriority=127
    local volume=root.Size.X*root.Size.Y*root.Size.Z
    local density=tune.mass/tune.kilogramsPerMassUnit/volume
    assert(density>=0.01 and density<=100,"Chassis density outside Roblox range")
    root.CustomPhysicalProperties=PhysicalProperties.new(density,0.15,0,100,100)
    car.PrimaryPart=root; attachment(root,"CenterOfMass")
    local seat=Instance.new("VehicleSeat"); seat.Name="DriverSeat"; seat.Size=Vector3.new(0.48,0.15,0.48)/m
    local seatCF=CFrame.new(-0.35/m,0.32/m,0.10/m)
    seat.CFrame=spawnCF*seatCF; seat.CanCollide=false; seat.CanTouch=true; seat.CanQuery=false
    seat.Massless=true; seat.Torque=0; seat.MaxSpeed=0; seat.TurnSpeed=0
    seat.Disabled=false; seat.HeadsUpDisplay=false; seat.Parent=car; joint(root,seat,"DriverSeatMount",seatCF,false)
    local function body(name,size,position,color)
        local cf=CFrame.new(Vector3.new(position[1],position[2],position[3])/m)
        local p=part(visuals,name,Vector3.new(size[1],size[2],size[3])/m,spawnCF*cf,color)
        joint(root,p,"BodyWeld",cf,false); return p
    end
    body("Hood",{1.8,0.08,1.3},{0,0.24,-1.2},colors.body)
    body("Trunk",{1.8,0.08,0.80},{0,0.24,1.50},colors.body)
    body("Roof",{1.40,0.06,1.50},{0,0.93,0.05},colors.body)
    body("FrontBumper",{1.9,0.10,0.12},{0,-0.02,-2.3},colors.metal)
    body("RearBumper",{1.9,0.10,0.12},{0,-0.02,2.3},colors.metal)
    body("EngineBlock",{0.65,0.45,0.70},{0,0.36,-1.08},colors.frame)
    body("Transmission",{0.30,0.26,0.62},{0,0.03,-0.25},colors.metal)
    body("Differential",{0.42,0.28,0.30},{0,-0.24,tune.rearZ},colors.frame)
    body("Spoiler",{1.55,0.22,0.06},{0,0.41,1.9},colors.body)
    for _,x in ipairs({-0.62,0.62}) do
        rod(visuals,root,"RollCage",Vector3.new(x,0.2,-0.8)/m,Vector3.new(x,0.92,-0.5)/m,0.045/m,colors.metal)
        rod(visuals,root,"RearCage",Vector3.new(x,0.92,0.7)/m,Vector3.new(x,0.2,1.1)/m,0.045/m,colors.metal)
    end
    for _,c in ipairs(tune.corners) do
        local wf=folder(wheels,c.name); wf:SetAttribute("Front",c.front); wf:SetAttribute("Side",c.side)
        local mount=Vector3.new(c.x,tune.mountY,c.z)/m
        local upper=attachment(root,"Mount_"..c.name,CFrame.new(mount)); upper:SetAttribute("RayDirection","-Chassis.UpVector")
        local hubPosition=mount-Vector3.new(0,(tune.springFreeLength-tune.initialCompression)/m,0)
        local hub=part(wf,"Hub",Vector3.new(0.12,0.14,0.14)/m,spawnCF*CFrame.new(hubPosition),colors.brake)
        joint(root,hub,"SuspensionMotor",CFrame.new(hubPosition),true)
        attachment(hub,"WheelAxis"); attachment(hub,"SpringLower")
        local wheel=part(wf,"Wheel",Vector3.new(tune.wheelWidth,2*tune.wheelRadius,2*tune.wheelRadius)/m,
            hub.CFrame,colors.tire,Enum.PartType.Cylinder)
        joint(hub,wheel,"SpinMotor",CFrame.new(),true)
        local rim=part(wf,"Rim",Vector3.new(tune.wheelWidth+0.005,0.46,0.46)/m,hub.CFrame,colors.metal,Enum.PartType.Cylinder)
        joint(wheel,rim,"RimWeld",CFrame.new(),false)
        local marker=part(wf,"RotationMarker",Vector3.new(tune.wheelWidth+0.01,0.045,0.06)/m,
            wheel.CFrame*CFrame.new(0,0.23/m,0),colors.spring)
        joint(wheel,marker,"MarkerWeld",CFrame.new(0,0.23/m,0),false)
        local sf=folder(suspension,c.name)
        local inner=Vector3.new(c.x*0.62,tune.mountY+0.08,c.z)/m
        rod(sf,root,"Damper",inner,hubPosition,0.055/m,colors.metal):SetAttribute("Inner",inner)
        for _,dz in ipairs({-0.18,0.18}) do
            local a=Vector3.new(c.x*0.48,tune.mountY-0.05,c.z+dz)/m
            rod(sf,root,dz<0 and "ControlArmFront" or "ControlArmRear",a,hubPosition,0.04/m,colors.frame):SetAttribute("Inner",a)
        end
        for j=1,16 do
            local coil=rod(sf,root,"Coil_"..j,inner,hubPosition,0.018/m,colors.spring)
            coil:SetAttribute("CoilIndex",j); coil:SetAttribute("Inner",inner)
        end
        local contact=attachment(root,"Contact_"..c.name,CFrame.new(hubPosition-Vector3.new(0,tune.wheelRadius/m,0)))
        local beam=Instance.new("Beam"); beam.Name="ContactRay"; beam.Attachment0=upper; beam.Attachment1=contact
        beam.Color=ColorSequence.new(Color3.fromRGB(50,220,110)); beam.Width0=0.018/m; beam.Width1=0.018/m
        beam.FaceCamera=true; beam.Enabled=false; beam.Parent=wf
    end
    Cockpit.ensure(car,tune)
    car.Parent=parent
    local prompt=Instance.new("ProximityPrompt"); prompt.Name="EnterCar"; prompt.ActionText="Dirigir"
    prompt.ObjectText="NR2003 Lab"; prompt.KeyboardKeyCode=Enum.KeyCode.F; prompt.MaxActivationDistance=12
    prompt.RequiresLineOfSight=false; prompt.Parent=seat
    return car
end
function M.makeTrack(parent)
    local track=folder(parent,"TestTrack")
    local function ground(name,size,cf,color,material,index)
        local p=part(track,name,size,cf,color); p.Anchored=true; p.Massless=false
        p.CanCollide=true; p.CanQuery=true; p.Material=material
        p:SetAttribute("NRSurface",index); p:SetAttribute("NRGripMultiplier",1); return p
    end
    ground("Asphalt",Vector3.new(400,2,1000),CFrame.new(0,-1,-350),Color3.fromRGB(57,60,64),Enum.Material.Asphalt,1)
    ground("GrassLane",Vector3.new(30,0.10,190),CFrame.new(65,0.05,-110),Color3.fromRGB(65,117,54),Enum.Material.Grass,5)
    ground("SandLane",Vector3.new(30,0.12,190),CFrame.new(-65,0.06,-110),Color3.fromRGB(209,190,143),Enum.Material.Sand,7)
    ground("Ramp",Vector3.new(22,1,42),CFrame.new(0,2.5,-180)*CFrame.Angles(math.rad(7),0,0),Color3.fromRGB(117,122,130),Enum.Material.Concrete,2)
    for j=1,9 do ground("Bump_"..j,Vector3.new(2.3,0.22,2.1),CFrame.new(25,0.11,-35-j*5),colors.spring,Enum.Material.Concrete,3) end
    for _,x in ipairs({-190,190}) do ground("Barrier",Vector3.new(2,6,1000),CFrame.new(x,3,-350),colors.metal,Enum.Material.Concrete,2) end
    local spawn=Instance.new("SpawnLocation"); spawn.Name="DriverSpawn"; spawn.Size=Vector3.new(7,0.4,7)
    spawn.CFrame=CFrame.new(10,0.2,8); spawn.Anchored=true; spawn.Neutral=true; spawn.Duration=0; spawn.Parent=track
    return track
end
function M.spawnCFrame(tune)
    local height=tune.wheelRadius+tune.springFreeLength-tune.initialCompression-tune.mountY
    return CFrame.new(0,(height+0.03)/tune.metresPerStud,0)
end
return M
