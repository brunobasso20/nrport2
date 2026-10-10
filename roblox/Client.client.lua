local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local CAS=game:GetService("ContextActionService")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
local package=game:GetService("ReplicatedStorage"):WaitForChild("NR2003Lab")
local Config=require(package.Roblox.DriverConfig)
local Tune=require(package.Core.TestTune)
local RenderPresentation=require(package.Roblox.RenderPresentation)
local remote=package:WaitForChild("Input");local telemetry=package:WaitForChild("Telemetry")
local renderState=package:WaitForChild("RenderState")
local car=workspace:WaitForChild("NR2003LabWorld"):WaitForChild("TestCar")
local seat=car:WaitForChild("DriverSeat");local root=car:WaitForChild("Chassis")
-- Stage 6/7: NR2003_CUP presents the car with the Cup geometry (CupTune); other modes keep TestTune
local modeName=require(package.Roblox.ModeConfig).mode
local presentationTune=(modeName=="NR2003_CUP" and package.Core:FindFirstChild("CupTune")) and require(package.Core.CupTune).new() or Tune.new()
local presentation=RenderPresentation.new(car,presentationTune,renderState)
local keys={};local driving=false;local sendTimer=0;local cameraMode=1;local expanded=true;local renderDiag=false
local savedCameraType,savedCameraSubject,savedFieldOfView
local gui=Instance.new("ScreenGui");gui.Name="NR2003LabHUD";gui.ResetOnSpawn=false
gui.Parent=player:WaitForChild("PlayerGui")
local entry=Instance.new("TextLabel");entry.Name="EntryStatus";entry.Size=UDim2.fromOffset(560,42)
entry.Position=UDim2.new(.5,-280,1,-70);entry.BackgroundColor3=Color3.fromRGB(17,24,34)
entry.TextColor3=Color3.fromRGB(240,245,250);entry.TextSize=16;entry.TextWrapped=true
entry.Font=Enum.Font.Gotham;entry.Visible=false;entry.Parent=gui
local entryUntil=0
remote.OnClientEvent:Connect(function(message)
    if type(message)=="table" and message.kind=="seat" then
        entry.Text=tostring(message.message);entryUntil=os.clock()+5;entry.Visible=true
    end
end)
UIS.InputBegan:Connect(function(input,processed)
    if processed or UIS:GetFocusedTextBox() or input.KeyCode~=Enum.KeyCode.F then return end
    local character=player.Character;local hrp=character and character:FindFirstChild("HumanoidRootPart")
    if hrp and (hrp.Position-seat.Position).Magnitude<=Config.entryDistanceStuds then remote:FireServer({kind="enter"}) end
end)
local panel=Instance.new("Frame");panel.Name="Telemetry";panel.Position=UDim2.new(0,16,0,70)
panel.Size=UDim2.fromOffset(460,250);panel.BackgroundColor3=Color3.fromRGB(17,24,34)
panel.BackgroundTransparency=0.08;panel.BorderSizePixel=0;panel.Visible=false;panel.Parent=gui
local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,8);corner.Parent=panel
local function label(parent,name,y,height,size)
    local l=Instance.new("TextLabel");l.Name=name;l.Position=UDim2.fromOffset(14,y)
    l.Size=UDim2.new(1,-28,0,height);l.BackgroundTransparency=1
    l.TextColor3=Color3.fromRGB(225,232,240);l.TextXAlignment=Enum.TextXAlignment.Left
    l.Font=Enum.Font.Code;l.TextSize=size;l.TextWrapped=false;l.Parent=parent;return l
end
local title=label(panel,"Title",10,22,17);title.Text="NR2003 / bancada de física";title.TextColor3=Color3.fromRGB(94,197,255)
local gauge=label(panel,"Gauges",38,28,22);gauge.Text="0 km/h | 900 rpm | 1"
local header=label(panel,"Header",80,18,13);header.Text="RODA   CARGA N  CURSO mm  SLIP %  PNEU °C"
local rows={};for j=1,4 do rows[j]=label(panel,"Wheel"..j,98+(j-1)*20,20,13) end
-- Stage 9: aero line (ORIGINAL 00561b70 evaluated by the server adapter at telemetry rate)
local aeroLine=label(panel,"Aero",180,30,11);aeroLine.Text="";aeroLine.TextColor3=Color3.fromRGB(150,214,160)
-- Stage 11: runtime systems line (ORIGINAL cells read by the server adapter at telemetry rate; display only)
local s11Line=label(panel,"Stage11",212,30,11);s11Line.Text="";s11Line.TextColor3=Color3.fromRGB(236,200,140)
-- Stage 12: steering line (ORIGINAL steering cells read by the server adapter at telemetry rate; display only)
local steerLine=label(panel,"Stage12",246,16,11);steerLine.Text="";steerLine.TextColor3=Color3.fromRGB(190,172,244)
local hint=label(panel,"Controls",265,50,11)
hint.Text="W/S acelerar/frear   A/D direção (gamepad: analógico esquerdo)   E/Q marchas\nShift embreagem   Espaço freio de mão   X sair\nT painel   G contatos   H render diag   V câmera   R reposicionar"
local status=label(panel,"Status",314,16,11);status.Text="Tune de teste | contato por raycast"
local renderInfo=Instance.new("TextLabel");renderInfo.Name="RenderDiagnostics";renderInfo.AnchorPoint=Vector2.new(1,0)
renderInfo.Position=UDim2.new(1,-16,0,20);renderInfo.Size=UDim2.fromOffset(390,142);renderInfo.BackgroundColor3=Color3.fromRGB(17,24,34)
renderInfo.BackgroundTransparency=0.08;renderInfo.BorderSizePixel=0;renderInfo.TextColor3=Color3.fromRGB(225,232,240)
renderInfo.Font=Enum.Font.Code;renderInfo.TextSize=13;renderInfo.TextXAlignment=Enum.TextXAlignment.Left;renderInfo.TextYAlignment=Enum.TextYAlignment.Top
renderInfo.TextWrapped=false;renderInfo.Visible=false;renderInfo.Parent=gui
local renderCorner=Instance.new("UICorner");renderCorner.CornerRadius=UDim.new(0,8);renderCorner.Parent=renderInfo
local function isDriver()
    local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    return h and h.SeatPart==seat
end
local bindings={
    {"Gas","Acelerar",Enum.KeyCode.W,Enum.KeyCode.Up},{"Brake","Frear",Enum.KeyCode.S,Enum.KeyCode.Down},
    {"Left","←",Enum.KeyCode.A,Enum.KeyCode.Left},{"Right","→",Enum.KeyCode.D,Enum.KeyCode.Right},
    {"Handbrake","Mão",Enum.KeyCode.Space},{"Clutch","Embreagem",Enum.KeyCode.LeftShift},
    {"UpGear","+ marcha",Enum.KeyCode.E},{"DownGear","− marcha",Enum.KeyCode.Q},
    {"Reset","Reset",Enum.KeyCode.R},{"Debug","Contato",Enum.KeyCode.G},
    {"Details","Painel",Enum.KeyCode.T},{"Camera","Câmera",Enum.KeyCode.V},{"RenderDiag","Render",Enum.KeyCode.H},{"Exit","Sair",Enum.KeyCode.X},
}
local function action(name,state)
    if not isDriver() then return Enum.ContextActionResult.Pass end
    name=name:gsub("NR2003_","")
    if state==Enum.UserInputState.Begin then
        keys[name]=true
        if name=="UpGear" then remote:FireServer({kind="shift",delta=1})
        elseif name=="DownGear" then remote:FireServer({kind="shift",delta=-1})
        elseif name=="Reset" then remote:FireServer({kind="reset"})
        elseif name=="Debug" then remote:FireServer({kind="debug"})
        elseif name=="Exit" then remote:FireServer({kind="exit"})
        elseif name=="Details" then expanded=not expanded
        elseif name=="Camera" then cameraMode=cameraMode%3+1
        elseif name=="RenderDiag" then renderDiag=not renderDiag;renderInfo.Visible=renderDiag end
    elseif state==Enum.UserInputState.End or state==Enum.UserInputState.Cancel then keys[name]=nil end
    return Enum.ContextActionResult.Sink
end
local function bind()
    for i,b in ipairs(bindings) do
        local codes={};for j=3,#b do table.insert(codes,b[j]) end
        CAS:BindActionAtPriority("NR2003_"..b[1],action,i<=8,2100,table.unpack(codes))
        CAS:SetTitle("NR2003_"..b[1],b[2])
        if i<=8 then CAS:SetPosition("NR2003_"..b[1],UDim2.new(1,-80-((i-1)%4)*78,1,-90-math.floor((i-1)/4)*75)) end
    end
end
local function unbind() for _,b in ipairs(bindings) do CAS:UnbindAction("NR2003_"..b[1]) end;keys={} end
UIS.WindowFocusReleased:Connect(function() keys={} end)
telemetry.OnClientEvent:Connect(function(data)
    if not driving then return end
    title.Text=data.mode=="NR2003_CUP" and "NR2003 Cup / núcleo original 45 estados · estágios 6-8"
        or (data.mode=="NR2003_CORE" and "NR2003 / chassi numérico · estágio 5 estabilizado" or "NR2003 / adaptador Roblox")
    local gear=data.gear==-1 and "R" or (data.gear==0 and "N" or tostring(data.gear))
    gauge.Text=string.format("%3.0f km/h | %4.0f rpm | %s",data.speed,data.rpm,gear)
    local cup=data.mode=="NR2003_CUP" and data.brakePedal~=nil
    header.Text=cup and "RODA   CARGA N  CURSO mm  SLIP %  FREIO Nm" or "RODA   CARGA N  CURSO mm  SLIP %  PNEU °C"
    for j,w in ipairs(data.wheels) do
        if cup then
            rows[j].Text=string.format("%s   %7.0f  %8.1f  %6.1f  %7.0f%s",w.name,w.load,w.compression*1000,w.slip*100,math.abs(w.brakeTorque or 0),w.locked and " TRAV" or "")
            rows[j].TextColor3=w.locked and Color3.fromRGB(255,96,96) or (w.grounded and Color3.fromRGB(216,228,237) or Color3.fromRGB(246,147,106))
        else
            rows[j].Text=string.format("%s   %7.0f  %8.1f  %6.1f  %7.1f",w.name,w.load,w.compression*1000,w.slip*100,w.temperature)
            rows[j].TextColor3=w.grounded and Color3.fromRGB(216,228,237) or Color3.fromRGB(246,147,106)
        end
    end
    local a=data.aero
    if a then
        if a.session then
            aeroLine.Text=string.format("AERO rho %.4f  q %5.0f Pa  arrasto %5.0f N  downforce %5.0f N (D %5.0f / T %5.0f)\nfatores %.3f/%.3f/%.3f%s  alt. diant. %4.0f mm  fita %d%%  aerofólio %d°  yaw %.1f°",
                a.density,a.q,a.drag,a.downforce,a.front,a.rear,a.factorDrag,a.factorFront,a.factorRear,a.draftTest and " (vácuo TESTE)" or "",
                a.rideHeight*1000,a.grilleTape,a.spoiler,math.deg(a.yaw))
        else
            aeroLine.Text="AERO sem sessão (AeroSession=false): estado pós-build, rho = 0, sem forças aero"
        end
    else aeroLine.Text="" end
    local s=data.stage11
    if s and s.mode=="original" then
        local t={}
        for j,w in ipairs(data.wheels) do
            t[j]=string.format("%s %3.0f°C %4.1fpsi %3.0f%%%s",w.name,(w.temperature or 0),w.tyrePressure or 0,100*(w.tyreWear or 0),
                (w.tyreState or 0)>=2 and " FURADO" or "")
        end
        local zmax=0;for _,z in ipairs(s.zones or {}) do zmax=math.max(zmax,z) end
        s11Line.Text=string.format("COMB %.2f kg  água %.1f°C  óleo %.1f°C  pot %.3f  dano mot %.2f vaz %.2f/%.2f/%.2f carroc %.2f\n%s | freio %.0f/%.0f/%.0f/%.0f°C",
            s.fuelKg,s.water,s.oil,s.power,s.engineDamage,s.leakRadiator,s.leakOil,s.leakFuel,zmax,table.concat(t,"  "),
            (data.wheels[1].brakeTemperatureK or 273.15)-273.15,(data.wheels[2].brakeTemperatureK or 273.15)-273.15,
            (data.wheels[3].brakeTemperatureK or 273.15)-273.15,(data.wheels[4].brakeTemperatureK or 273.15)-273.15)
    elseif s then
        s11Line.Text="ESTÁGIO 11 congelado (Stage11Runtime=frozen): combustível/térmica/desgaste/dano nos valores pós-build"
    else s11Line.Text="" end
    local sd=data.steering
    if sd and sd.mode=="original" then
        steerLine.Text=string.format("DIREÇÃO %s  entrada %+.3f  relação %.1f:1  alvo %+.2f°  cubos %+.2f/%+.2f°  rodas %+.2f°  volante %+.0f°",
            sd.digital and "teclas" or "eixo",sd.input or 0,sd.ratioNow or 0,math.deg(sd.target or 0),math.deg(sd.hubLF or 0),math.deg(sd.hubRF or 0),
            math.deg(data.roadWheelAngle or 0),math.deg(data.steeringWheelAngle or 0))
    else steerLine.Text="" end
    if data.mode=="NR2003_CUP" then
        status.Text=data.fault and "Física pausada; veja Output. R reinicia." or string.format("acel %.2f | pedal freio %.2f -> núcleo %.2f | viés %d%% | embr %.2f | lim %s%s",
            data.throttleIn or 0,data.brakePedal or 0,data.brakeCore or data.brakeIn or 0,data.brakeBias or 74,data.clutchIn or 0,data.limiter and "ON" or "off",data.collision and " | colisão" or "")
    else
        status.Text=data.fault and "Física pausada; veja Output. R reinicia." or string.format("Motor %.0f Nm | embreagem Δ %.0f rad/s",data.torque,data.clutchSlip)
    end
end)
local diagTimer=0
local function updateRenderDiag(dt)
    if not renderDiag then return end
    diagTimer=diagTimer+dt;if diagTimer<0.25 then return end;diagTimer=0
    local s=presentation:stats()
    renderInfo.Text=string.format(" RENDER / PRESENTATION ONLY\n sim %6.1f Hz   snapshot %5.1f Hz   recv %5.1f Hz\n render %5.1f FPS  delay %5.1f ms   buffer %d\n drops %d   out-of-order %d   resets %d\n extrap episodes %d   max %.1f ms\n mode %-7s alpha %.3f   active %s",
        s.serverTickHz or 0,s.serverSnapshotHz or 0,s.recvHz or 0,s.renderFPS or 0,(s.delay or 0)*1000,s.buffer or 0,
        s.dropped or 0,s.outOfOrder or 0,s.resets or 0,s.extrapEpisodes or 0,(s.maxExtrapSeen or 0)*1000,
        tostring(s.mode),s.alpha or 0,tostring(s.active))
end
local function frame(dt)
    presentation:update() -- MUST precede every camera path; render state never feeds physics.
    entry.Visible=os.clock()<entryUntil
    local nowDriving=isDriver() and true or false
    if nowDriving~=driving then
        driving=nowDriving;panel.Visible=driving
        if driving then
            bind();savedCameraType=workspace.CurrentCamera.CameraType;savedCameraSubject=workspace.CurrentCamera.CameraSubject
            savedFieldOfView=workspace.CurrentCamera.FieldOfView
        else
            unbind();renderDiag=false;renderInfo.Visible=false
            if savedCameraType then workspace.CurrentCamera.CameraType=savedCameraType end
            if savedCameraSubject and savedCameraSubject.Parent then workspace.CurrentCamera.CameraSubject=savedCameraSubject end
            if savedFieldOfView then workspace.CurrentCamera.FieldOfView=savedFieldOfView end
        end
    end
    updateRenderDiag(dt)
    if not driving then return end
    header.Visible=expanded;for _,r in ipairs(rows) do r.Visible=expanded end
    aeroLine.Visible=expanded;s11Line.Visible=expanded;steerLine.Visible=expanded
    hint.Visible=expanded;status.Visible=expanded;panel.Size=UDim2.fromOffset(600,expanded and 334 or 76)
    local camera=workspace.CurrentCamera
    if cameraMode==1 then
        camera.CameraType=Enum.CameraType.Scriptable;camera.FieldOfView=savedFieldOfView or 70
        local look=root.Position+Vector3.new(0,2,0)
        local behind=root.Position-root.CFrame.LookVector*24+Vector3.new(0,10,0)
        camera.CFrame=camera.CFrame:Lerp(CFrame.lookAt(behind,look+root.CFrame.LookVector*8),1-math.exp(-8*dt))
    elseif cameraMode==2 and seat:FindFirstChild("CockpitCamera") then
        camera.CameraType=Enum.CameraType.Scriptable;camera.FieldOfView=Config.cockpitFieldOfView
        camera.CFrame=seat.CockpitCamera.WorldCFrame
    else
        camera.CameraType=Enum.CameraType.Custom;camera.CameraSubject=seat;camera.FieldOfView=savedFieldOfView or 70
    end
    sendTimer=sendTimer+dt
    if sendTimer>=1/30 then
        sendTimer=sendTimer%(1/30)
        -- Stage 12: raw steering controls (the NR2003 device layer 0057abc0 on the server side splits them into
        -- controls 7 / 8): keys A/D or arrows = key bindings (digital); a gamepad thumbstick (last input from a
        -- gamepad) = one analog axis, already normalised -1..1 by Roblox (deadzone: DriverConfig, 0 = none)
        local axis,analog=nil,false
        local last=UIS:GetLastInputType()
        if last.Name:sub(1,7)=="Gamepad" and UIS:GetGamepadConnected(last) then
            for _,o in ipairs(UIS:GetGamepadState(last)) do
                if o.KeyCode==Enum.KeyCode.Thumbstick1 then
                    axis=o.Position.X
                    if math.abs(axis)<(Config.gamepadSteerDeadzone or 0) then axis=0 end
                    analog=true
                end
            end
        end
        local left,right=keys.Left and 1 or 0,keys.Right and 1 or 0
        remote:FireServer({kind="input",throttle=keys.Gas and 1 or 0,brake=keys.Brake and 1 or 0,
            steer=analog and axis or (right-left),handbrake=keys.Handbrake and 1 or 0,clutch=keys.Clutch and 1 or 0,
            steerLeft=left,steerRight=right,steerAxis=axis,steerAnalog=analog})
    end
end
local renderName="NR2003_Presentation"
RunService:BindToRenderStep(renderName,Enum.RenderPriority.Camera.Value-1,frame)
script.Destroying:Connect(function()
    RunService:UnbindFromRenderStep(renderName);presentation:destroy();unbind()
end)
