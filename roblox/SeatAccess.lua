-- Server owns admission. The engine owns the occupant's SeatWeld.
local Config=require(script.Parent.DriverConfig)
local M={}; M.__index=M

function M.configure(car)
    local seat=assert(car:FindFirstChild("DriverSeat"),"DriverSeat missing")
    assert(seat:IsA("VehicleSeat"),"DriverSeat must be a VehicleSeat")
    -- V2 used this reserved name for the permanent chassis mount. Rename only
    -- that exact connection; never delete/rename the real avatar SeatWeld.
    for _,joint in ipairs(seat:GetChildren()) do
        if joint.Name=="SeatWeld" and joint:IsA("JointInstance") and
            ((joint.Part0==car.Chassis and joint.Part1==seat) or
             (joint.Part1==car.Chassis and joint.Part0==seat)) then
            joint.Name="DriverSeatMount"
        end
    end
    seat.Disabled=false; seat.CanTouch=true
    seat.Torque=0; seat.MaxSpeed=0; seat.TurnSpeed=0; seat.HeadsUpDisplay=false
    local prompt=seat:FindFirstChild("EnterCar")
    if not prompt then prompt=Instance.new("ProximityPrompt"); prompt.Name="EnterCar"; prompt.Parent=seat end
    prompt.ActionText="Dirigir"; prompt.ObjectText="NR2003 Lab"
    prompt.KeyboardKeyCode=Enum.KeyCode.F; prompt.HoldDuration=0
    prompt.MaxActivationDistance=Config.entryDistanceStuds; prompt.RequiresLineOfSight=false
    prompt.Enabled=seat.Occupant==nil
    car:SetAttribute("NR2003LabVersion",Config.version)
    return seat,prompt
end

function M.new(car,remote)
    local seat,prompt=M.configure(car)
    local self=setmetatable({car=car,seat=seat,prompt=prompt,remote=remote,
        players=game:GetService("Players"),connections={},cooldowns={},pending=nil},M)
    self.connections[1]=prompt.Triggered:Connect(function(player) self:request(player) end)
    self.connections[2]=seat:GetPropertyChangedSignal("Occupant"):Connect(function() self:sync() end)
    self.connections[3]=self.players.PlayerRemoving:Connect(function(player)
        self.cooldowns[player]=nil
        if self.pending and self.pending.player==player then self.pending=nil; self:sync() end
    end)
    self:sync(); car:SetAttribute("EntryHandlerReady",true)
    return self
end

function M:driver()
    local humanoid=self.seat.Occupant
    return humanoid and self.players:GetPlayerFromCharacter(humanoid.Parent) or nil
end

function M:reply(player,code,message)
    if self.remote and player.Parent==self.players then
        self.remote:FireClient(player,{kind="seat",code=code,message=message})
    end
end

function M:sync()
    local driver=self:driver()
    self.car:SetAttribute("DriverUserId",driver and driver.UserId or 0)
    self.prompt.Enabled=self.seat.Occupant==nil and self.pending==nil
    -- Keep the chassis simulation on the server after the avatar joins/leaves it.
    if self.car.Chassis.Parent and not self.car.Chassis.Anchored then
        local ok,reason=pcall(function() self.car.Chassis:SetNetworkOwner(nil) end)
        if not ok then warn("NR2003 ownership: "..tostring(reason)) end
    end
end

function M:request(player)
    local now=os.clock()
    if now-(self.cooldowns[player] or -math.huge)<Config.requestCooldown then return end
    self.cooldowns[player]=now
    local character=player.Character
    local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    local root=character and character:FindFirstChild("HumanoidRootPart")
    local function reject(code,message) self:reply(player,code,message); return false end
    if not humanoid or humanoid.Health<=0 or not root then
        return reject("character","Espere o personagem aparecer e tente novamente.")
    end
    if self.seat.Occupant==humanoid then self:sync(); return true end
    if self.seat.Occupant or (self.pending and self.pending.player~=player) then
        return reject("occupied","O banco já está ocupado.")
    end
    if self.pending then return true end
    if humanoid.SeatPart then return reject("other_seat","Saia do outro banco antes de entrar.") end
    if (root.Position-self.seat.Position).Magnitude>Config.entryDistanceStuds+2 then
        return reject("distance","Aproxime-se do banco para dirigir.")
    end
    local corePose=self.car:GetAttribute("NR2003CorePoseOwner")==true
    if ((self.car.Chassis.Anchored or self.seat.Anchored) and not corePose) or root.Anchored then
        return reject("anchored","Há uma peça principal ancorada. Confira Chassis e DriverSeat.")
    end
    self.pending={player=player,humanoid=humanoid,character=character,
        deadline=now+Config.entryTimeout,nextAttempt=now}
    self:sync(); self:reply(player,"pending","Entrando no carro…")
    self:step(now)
    return true
end

function M:finish(code,message)
    local pending=self.pending; self.pending=nil
    self.car:SetAttribute("EntryStatus",code)
    self:sync()
    if pending then self:reply(pending.player,code,message) end
end

function M:step(now)
    local p=self.pending; if not p then return end
    now=now or os.clock()
    if p.player.Parent~=self.players or p.player.Character~=p.character or p.humanoid.Health<=0 then
        self:finish("cancelled","Entrada cancelada: personagem mudou."); return
    end
    if self.seat.Occupant==p.humanoid then
        self:finish("seated","Ao volante: W/S, A/D; V muda a câmera; X sai."); return
    end
    if self.seat.Occupant or (p.humanoid.SeatPart and p.humanoid.SeatPart~=self.seat) then
        self:finish("occupied","O banco ou o personagem foi ocupado durante a entrada."); return
    end
    local root=p.character:FindFirstChild("HumanoidRootPart")
    if not root or (root.Position-self.seat.Position).Magnitude>Config.entryDistanceStuds+2 then
        self:finish("distance","Entrada cancelada: você se afastou do banco."); return
    end
    if now>=p.deadline then
        self:finish("timeout","Não foi possível sentar. Confira EntryStatus e Output.")
        warn("NR2003: VehicleSeat did not confirm Occupant after Sit; inspect DriverSeat and avatar scripts.")
        return
    end
    if now>=p.nextAttempt then
        p.nextAttempt=now+Config.retryInterval
        self.seat.Disabled=false; p.humanoid.Jump=false
        local ok,reason=pcall(function() self.seat:Sit(p.humanoid) end)
        if not ok then self:finish("error","Erro ao sentar; veja Output."); warn("NR2003 Sit: "..tostring(reason))
        elseif self.seat.Occupant==p.humanoid then self:finish("seated","Ao volante: W/S, A/D; V câmera; X sair.") end
    end
end

function M:exit(player)
    if player~=self:driver() then return end
    local h=self.seat.Occupant
    h.Sit=false; h.Jump=true
    self:reply(player,"exited","Você saiu do banco. F para entrar novamente.")
end

function M:destroy()
    for _,connection in ipairs(self.connections) do connection:Disconnect() end
    self.connections={}; self.pending=nil
    self.car:SetAttribute("EntryHandlerReady",false); self.car:SetAttribute("DriverUserId",0)
end
return M
