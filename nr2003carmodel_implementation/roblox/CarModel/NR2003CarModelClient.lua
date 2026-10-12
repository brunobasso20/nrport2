-- NR2003CarModelClient: client presentation of the ORIGINAL NR2003 car (model, cockpit, instruments, steering wheel,
-- cameras). Runs after RenderPresentation:update() in the client render step; reads the replicated draw state
-- (NR2003DrawState) at the SAME render time as the interpolated pose; never sends anything that feeds the physics.
-- 3do variables per frame, as NR2003.exe 005662d0 sets them for the focus car:
--   cockpitView      1 in cockpit / LookLeft / LookRight, 10 in Nose / Gearbox / F Susp / R Susp (car hidden), else 0
--   steeringWheelEnable = option "Animated Steering Wheel" ? 0 : 1 (image default ON); windshieldEnable = option
--   "Windshield (buildup)" ? 0 : 1 (image default ON); mirrorFrameEnable = 0 (00750194 = 2); day_night = 0 (day);
--   wheel_speed_N    00565b10(|rate|) (LF -> wheel_speed_1, RF -> 0, LR -> 3, RR -> 2); roofFlapsEnable / roof_flap_state
--   from car[0x15ac]; backfireFrame = car[0x15b0]; animate_driver = 0 (focus car); tach / oil / water / fuel lights
--   (NR2003Gauges.lights); timeValue = 10 max(0, trunc(deg(a) + 160.355)) outside the cockpit.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local Scale=require(script.Parent.NR2003Scale)
local Gauges=require(script.Parent.NR2003Gauges)
local DrawState=require(script.Parent.NR2003DrawState)
local Cameras=require(script.Parent.NR2003CameraSystem)
local Rig=require(script.Parent.NR2003CarModelRig)
local M={};M.__index=M
M.VERSION="1.0.0-carmodel"

local function attr(car,name,default)
    local v=car:GetAttribute(name)
    if v==nil then return default end
    return v
end

function M.new(car,presentation,package,player,getKeys)
    local folder=package:FindFirstChild("CarModel")
    assert(folder,"NR2003Lab.CarModel missing")
    local dataName=attr(car,"NR2003CarModelData","NR2003CarModelData_make_a")
    local dataFolder=folder:FindFirstChild("Data")
    local dataModule=dataFolder and dataFolder:FindFirstChild(dataName)
    local self=setmetatable({car=car,presentation=presentation,package=package,player=player,getKeys=getKeys,
        status="ok",active=false,ds={},vars={},camOut={},bodyR={},hidden={},hiddenChar={},lastCamera=nil},M)
    if not dataModule then self.status="descriptor "..dataName.." not installed (run INSTALL_CARMODEL_ASSETS)";return self end
    local data=require(dataModule)
    Scale.check({metresPerStud=data.metresPerStud})
    local assetsFolder=folder:FindFirstChild("Assets")
    local assets=assetsFolder and assetsFolder:FindFirstChild(data.meta.package)
    if not assets then self.status="imported model '"..data.meta.package.."' not found in NR2003Lab.CarModel.Assets";return self end
    self.data=data
    local ok,rig=pcall(Rig.new,data,assets,workspace,{name="NR2003CarModel_"..car.Name})
    if not ok then self.status="rig: "..tostring(rig);return self end
    self.rig=rig
    if #rig.missing>0 then self.status=string.format("%d geometries missing in the import (first %s)",#rig.missing,rig.missing[1]) end
    local head=data.roles.head and data.nodes[data.roles.head[1]+1]
    self.headRest=head and head.t or {-0.75,0.4,0.467}
    self.cams=Cameras.new({onCar=data.cameras,widescreen=attr(car,"NR2003WidescreenProjection",true),
        fovDegrees=attr(car,"NR2003CockpitFOV",65)})
    self.buf=DrawState.newBuffer(64)
    local remote=package:FindFirstChild("DrawState")
    if remote then
        self.conn=remote.OnClientEvent:Connect(function(b)
            local s=DrawState.decode(b)
            if s then self.buf:push(s) end
        end)
    else self.status="RemoteEvent NR2003Lab.DrawState missing" end
    local livery=attr(car,"NR2003LiveryTexture",nil)
    if type(livery)=="string" and livery~="" then rig:setLivery(livery) end
    self.rayParams=RaycastParams.new();self.rayParams.FilterType=Enum.RaycastFilterType.Exclude
    self.active=true
    car:SetAttribute("NR2003CarModelStatus",self.status)
    return self
end

function M:cameraActive() return self.active and self.driving==true end
function M:nextCamera() if self.cams then self.cams:nextCamera() end end
function M:prevCamera() if self.cams then self.cams:prevCamera() end end
function M:fovUp() if self.cams then self.cams:fovUp() end end
function M:fovDown() if self.cams then self.cams:fovDown() end end

local function setLocalHidden(list,root,on)
    for _,d in ipairs(root:GetDescendants()) do
        if d:IsA("BasePart") then
            if on then if list[d]==nil then list[d]=d.LocalTransparencyModifier end;d.LocalTransparencyModifier=1
            elseif list[d]~=nil then d.LocalTransparencyModifier=list[d];list[d]=nil end
        elseif d:IsA("Decal") or d:IsA("Texture") then
            if on then if list[d]==nil then list[d]=d.LocalTransparencyModifier end;d.LocalTransparencyModifier=1
            elseif list[d]~=nil then d.LocalTransparencyModifier=list[d];list[d]=nil end
        end
    end
end

local function ground(self,x,y,z)
    local p=Scale.point(x,y,z)
    local hit=workspace:Raycast(p+Vector3.new(0,20,0),Vector3.new(0,-400,0),self.rayParams)
    if not hit then return nil end
    local _,_,gz=Scale.toNRPoint(hit.Position)
    return gz
end

function M:update(dt,driving)
    if not self.active then return false end
    self.driving=driving
    local pres=self.presentation
    local rt=pres.buffer and pres.buffer.renderTime or nil
    local ds=self.buf:sample(rt,self.ds)
    if ds==nil then return false end
    local car=self.car
    -- hide the bench's generated visuals (client only, reversible); the original model replaces them
    if not self.benchHidden then
        setLocalHidden(self.hidden,car,true);self.benchHidden=true
        if car.DescendantAdded then   -- visuals the bench creates later (cockpit wheel, debug parts)
            self.addedConn=car.DescendantAdded:Connect(function(d)
                if (d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture")) and self.hidden[d]==nil then
                    self.hidden[d]=d.LocalTransparencyModifier;d.LocalTransparencyModifier=1
                end
            end)
        end
    end
    local char=self.player.Character
    if driving and char then setLocalHidden(self.hiddenChar,char,true)
    elseif next(self.hiddenChar)~=nil and char then setLocalHidden(self.hiddenChar,char,false) end
    -- derived draw fields (005662d0)
    ds.wheelAngle=DrawState.steeringWheelAngle(ds)
    ds.needles=Gauges.needles(ds,ds.needles)
    ds.headTranslation=ds.headTranslation or {}
    ds.headTranslation[1]=self.headRest[1]+ds.headX
    ds.headTranslation[2]=self.headRest[2]+ds.headY
    ds.headTranslation[3]=self.headRest[3]+ds.headZ
    -- body frame = the core's component-0 pose as placed by CupChassisAdapter:pose / RenderPresentation (car:PivotTo)
    local bodyCF=car:GetPivot()
    local bx,by,bz,Rb=Scale.fromCFrame(bodyCF,self.bodyR)
    -- camera (driver only)
    local cam=nil
    if driving then
        local keys=self.getKeys and self.getKeys() or {}
        local axis=nil
        local last=UIS:GetLastInputType()
        if last.Name:sub(1,7)=="Gamepad" and UIS:GetGamepadConnected(last) then
            for _,o in ipairs(UIS:GetGamepadState(last)) do
                if o.KeyCode==Enum.KeyCode.Thumbstick2 and math.abs(o.Position.X)>0 then axis=-o.Position.X end
            end
        end
        self.cams:input(keys.LookLeft==true,keys.LookRight==true,axis,dt)
        self.cams:tick(dt)
        self.rayParams.FilterDescendantsInstances={car,self.rig.model,char}
        cam=self.cams:compute({bx,by,bz},Rb,{head=ds.headTranslation,headPitch=ds.headPitch,headRoll=ds.headRoll},
            function(x,y,z) return ground(self,x,y,z) end,self.camOut)
        if cam then self.lastCamera=cam end
        cam=cam or self.lastCamera
    end
    local cockpitView=(cam and cam.cockpitView) or 0
    -- 3do variables
    local v=self.vars
    v.cockpitView=cockpitView;v._cockpit=(cockpitView==1)
    v.steeringWheelEnable=attr(car,"NR2003AnimatedSteeringWheel",true) and 0 or 1
    v.windshieldEnable=attr(car,"NR2003Windshield",true) and 0 or 1
    v.mirrorFrameEnable=0;v.day_night=0;v.animate_driver=0
    v.wheel_speed_1=DrawState.wheelSpeedState(ds.rate1);v.wheel_speed_0=DrawState.wheelSpeedState(ds.rate2)
    v.wheel_speed_3=DrawState.wheelSpeedState(ds.rate3);v.wheel_speed_2=DrawState.wheelSpeedState(ds.rate4)
    v.roofFlapsEnable=(ds.roofFlap>=0.01) and 1 or 0
    v.roof_flap_state=math.floor(ds.roofFlap*255)
    v.backfireFrame=ds.backfire
    Gauges.lights(ds,v)                                            -- focus car (bit 0x10): every view
    if not v._cockpit then v.timeValue=DrawState.timeValue(ds.wheelAngle) end   -- bit 0x01 clear: driver animation
    local camera=workspace.CurrentCamera
    self.rig:update(bodyCF,v,ds,camera.CFrame.Position,1)
    car:SetAttribute("NR2003Camera",cam and cam.name or nil)
    return true
end

-- write the NR2003 camera into the Roblox camera (Hor+ vertical FOV; the (0, -0.125) frustum shift approximated by
-- tilting the view so the original view axis lands at the same screen row, NR2003CameraShift = false disables it)
function M:applyCamera(camera)
    local c=self.lastCamera
    if not c then return false end
    local cf=Scale.cframe(c.eye[1],c.eye[2],c.eye[3],c.R)
    local vfov=Scale.verticalFov(c.fov43)
    -- 00587e8a..00587ee7: widescreen branch -> horizontal FOV at the display aspect, clamped to 2.5 rad (006f697c)
    local aspect=camera.ViewportSize.X/math.max(camera.ViewportSize.Y,1)
    if self.cams.widescreen and 2*math.atan(aspect*math.tan(math.rad(vfov)*0.5))>2.5 then
        vfov=math.deg(2*math.atan(math.tan(1.25)/aspect))
    end
    if attr(self.car,"NR2003CameraShift",true) and c.shift then
        local th=math.atan(-c.shift[2]*math.tan(math.rad(vfov)*0.5))
        local tw=math.atan(-c.shift[1]*math.tan(math.rad(vfov)*0.5)*aspect)
        cf=cf*CFrame.Angles(th,-tw,0)
    end
    camera.CameraType=Enum.CameraType.Scriptable
    camera.FieldOfView=vfov
    camera.CFrame=cf
    return true
end

function M:destroy()
    if self.conn then self.conn:Disconnect() end
    if self.addedConn then self.addedConn:Disconnect() end
    setLocalHidden(self.hidden,self.car,false)
    if self.player.Character then setLocalHidden(self.hiddenChar,self.player.Character,false) end
    if self.rig then self.rig:destroy() end
end
return M
