local Profiles=require(script and script.Parent.NR2003AudioProfiles or "./NR2003AudioProfiles")
local Engine=require(script and script.Parent.NR2003AudioEngine or "./NR2003AudioEngine")
local Tires=require(script and script.Parent.NR2003AudioTires or "./NR2003AudioTires")
local M={};M.__index=M
-- The backend is injectable for deterministic lifecycle tests. It only owns its
-- own client-created sounds and attachments; it cannot alter vehicle physics.
function M.new(profile,backend)
    local self=setmetatable({profile=profile,backend=backend,voices={},engineControls={},tireControls={},
        frames=0,shifts=0,resets=0,missing=0,clipped=0,active=false},M)
    for bankName,bank in pairs(profile.banks or {}) do
        if bankName=="engvol.ces" then continue end
        local wheelBank=bankName:match("^tire_")~=nil
        for j=1,(wheelBank and 4 or 1) do
            for i,sample in ipairs(bank.samples or {}) do
                if sample.phase~=0 or not sample.enabled then continue end
                local key=bankName..":"..j..":"..i
                local id=Profiles.assetId(profile.assets[sample.file])
                if id then
                    self.voices[key]={handle=backend:create(key,id,wheelBank and j or 0,sample),sample=sample,bank=bankName}
                else self.missing+=1 end
            end
        end
    end
    if backend.preload then backend:preload() end
    return self
end
function M:silence()
    self.active=false
    for _,voice in pairs(self.voices) do self.backend:set(voice.handle,0,1) end
end
function M:update(state,focus,interior)
    self.frames+=1
    if not state or state.fault then self:silence();return end
    if self.epoch~=state.epoch then
        if self.epoch~=nil then self.resets+=1 end
        self.epoch=state.epoch;self.gear=state.gear
    elseif self.gear~=state.gear then self.shifts+=1;self.gear=state.gear end
    self.active=true;self.rpm=state.rpm;self.age=state.age or 0
    for _,v in pairs(self.voices) do v.gain=0;v.pitch=1 end
    local profile=self.profile
    local bankName=focus and (profile.engineBank or "winston.ces") or (profile.otherEngineBank or "winston_nf.ces")
    local bank=profile.banks[bankName]
    if bank and state.rpm>0 then
        self.engineControls=Engine.controls(bank,state,focus,interior,self.engineControls,profile.banks["engvol.ces"])
        for i,c in ipairs(self.engineControls) do self:apply(bankName..":1:"..i,c) end
    end
    for j,w in ipairs(state.wheels) do
        local controls,tireBank=Tires.controls(profile,w,self.tireControls[j],focus,interior)
        self.tireControls[j]=controls
        if controls then
            if self.backend.position then self.backend:position(j,w.cx or 0,w.cy or 0,w.cz or 0) end
            local name=Tires.BANKS[w.soundType]
            for i,c in ipairs(controls) do self:apply(name..":"..j..":"..i,c) end
        end
    end
    for _,voice in pairs(self.voices) do self.backend:set(voice.handle,voice.gain,voice.pitch) end
end
function M:apply(key,c)
    local voice=self.voices[key];if not voice then return end
    local pitch=math.clamp(c.pitch,self.profile.minPitch,self.profile.maxPitch)
    if pitch~=c.pitch then self.clipped+=1 end
    local gain=math.clamp(c.gain*self.profile.masterGain,0,10)
    voice.gain=gain;voice.pitch=pitch
end
function M:stats()
    local s={profile=self.profile.name,frames=self.frames,shifts=self.shifts,resets=self.resets,
        missing=self.missing,clipped=self.clipped,active=self.active,rpm=self.rpm or 0,age=self.age or 0}
    if self.backend.stats then for k,v in pairs(self.backend:stats()) do s[k]=v end end
    return s
end
function M:destroy()
    self:silence();self.backend:destroy();table.clear(self.voices)
end
return M
