local State=require(script.Parent.NR2003AudioState)
local Profiles=require(script.Parent.NR2003AudioProfiles)
local Controller=require(script.Parent.NR2003AudioController)
local Spatial=require(script.Parent.NR2003AudioSpatial)
local M={};M.__index=M
function M.new(car,presentation,package,remote)
    local config=require(package.Roblox.RenderConfig)
    local self=setmetatable({package=package,vehicles={},primary=car,diagTimer=0,discovery=0,dead=false},M)
    self:register(car,config.vehicleId or 1,presentation)
    self.connection=remote.OnClientEvent:Connect(function(packet)
        local s=State.decode(packet);if not s then return end
        local entry=self.vehicles[s.vehicleId]
        if entry then entry.buffer:push(s,workspace:GetServerTimeNow()) end
    end)
    return self
end
function M:register(car,id,presentation)
    assert(type(id)=="number" and id>=0 and id<=65535,"Invalid audio vehicle ID")
    local old=self.vehicles[id]
    if old then old.controller:destroy();old.destroyConnection:Disconnect() end
    local name=car:GetAttribute("NR2003AudioProfile") or self.package:GetAttribute("NR2003AudioProfile") or Profiles.DEFAULT
    local assets=self.package:FindFirstChild("AudioAssets")
    local profile=Profiles.resolve(name,assets and require(assets) or nil)
    local entry={car=car,presentation=presentation,profile=name,buffer=State.newBuffer(),state={wheels={}},
        controller=Controller.new(profile,Spatial.new(car,profile))}
    self.vehicles[id]=entry
    entry.destroyConnection=car.Destroying:Connect(function()
        if self.vehicles[id]~=entry then return end
        entry.controller:destroy();entry.destroyConnection:Disconnect();self.vehicles[id]=nil
    end)
    return entry
end
function M:update(dt,driving,carModel,cameraMode)
    if self.dead then return end
    local now=workspace:GetServerTimeNow()
    self.diagTimer+=dt;self.discovery+=dt
    if self.discovery>=1 then
        self.discovery=0
        -- Additional senders can register cars explicitly or mark Models with a
        -- unique NR2003AudioVehicleId. This does not add a multiplayer protocol.
        for _,car in ipairs(workspace:GetDescendants()) do
            if car:IsA("Model") then
                local id=car:GetAttribute("NR2003AudioVehicleId")
                if type(id)=="number" and not self.vehicles[id] and car:FindFirstChild("Chassis") then
                    self:register(car,id,nil)
                end
            end
        end
    end
    for id,entry in pairs(self.vehicles) do
        local car=entry.car
        local name=car:GetAttribute("NR2003AudioProfile") or self.package:GetAttribute("NR2003AudioProfile") or Profiles.DEFAULT
        if name~=entry.profile then entry=self:register(car,id,entry.presentation) end
        local presentation=entry.presentation
        local time=presentation and presentation.active and presentation.sampled.time or nil
        -- A registered remote car without a presentation buffer uses a small,
        -- bounded interpolation delay; callers may provide its own presentation.
        if not presentation then time=now-0.055 end
        local enabled=self.package:GetAttribute("NR2003AudioEnabled")~=false
            and car:GetAttribute("NR2003AudioEnabled")~=false
        local state=enabled and time and entry.buffer:sample(time,now,entry.state) or nil
        local focus=car==self.primary and driving==true
        local interior=focus and cameraMode==2
        if focus and carModel and carModel.active and carModel.vars then interior=carModel.vars._cockpit==true end
        entry.controller:update(state,focus,interior)
        if self.diagTimer>=0.25 then
            local s=entry.controller:stats()
            local status=s.voices==0 and "awaiting audio assets" or (s.active and "active" or "waiting/stale")
            if s.voices>0 and s.loaded==0 then status="loading audio assets" end
            if s.loaded>0 and (s.loaded<s.voices or s.missing>0) then status="partial audio assets" end
            if s.failures>0 then status="asset load/loop error" end
            car:SetAttribute("NR2003AudioStatus",status)
            car:SetAttribute("NR2003AudioRPM",s.rpm)
            car:SetAttribute("NR2003AudioAgeMs",s.age*1000)
            car:SetAttribute("NR2003AudioMissing",s.missing)
            car:SetAttribute("NR2003AudioLoaded",s.loaded)
            car:SetAttribute("NR2003AudioShiftEvents",s.shifts)
            car:SetAttribute("NR2003AudioPitchClamps",s.clipped)
        end
    end
    if self.diagTimer>=0.25 then self.diagTimer=0 end
end
function M:stats(id) local entry=self.vehicles[id];return entry and entry.controller:stats() end
function M:destroy()
    if self.dead then return end;self.dead=true
    if self.connection then self.connection:Disconnect() end
    for _,e in pairs(self.vehicles) do e.destroyConnection:Disconnect();e.controller:destroy() end
    table.clear(self.vehicles)
end
return M
