local Profiles=require(script and script.Parent.NR2003AudioProfiles or "./NR2003AudioProfiles")
local Bank=require(script and script.Parent.NR2003AudioBank or "./NR2003AudioBank")
local Tires=require(script and script.Parent.NR2003AudioTires or "./NR2003AudioTires")
local Curves=require(script and script.Parent.NR2003AudioCurves or "./NR2003AudioCurves")
local M={};M.__index=M
-- The backend is injectable for deterministic lifecycle tests. It only owns its
-- own client-created sounds and attachments; it cannot alter vehicle physics.
function M.new(profile,backend)
    local self=setmetatable({profile=profile,backend=backend,voices={},transports={},tireSlots={},
        frames=0,shifts=0,resets=0,missing=0,clipped=0,active=false,seed=profile.audioSeed or 1},M)
    self.applyControl=function(key,c) self:apply(key,c) end
    for bankName,bank in pairs(profile.banks or {}) do
        if bankName=="engvol.ces" then continue end
        local wheelBank=bankName:match("^tire_")~=nil
        local allowed={};for _,key in ipairs(Bank.layout(bank,wheelBank)) do allowed[key]=true end
        for j=1,(wheelBank and 4 or 1) do
            for i,sample in ipairs(bank.samples or {}) do
                if not allowed[sample.mechanical..":"..sample.group] then continue end
                if sample.mechanical==1 and sample.phase~=0 then continue end
                -- Disabled samples retain their original weight and phase clock.
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
    if self.active then self:resetPlayback() end
    self.active=false
    for _,voice in pairs(self.voices) do self.backend:set(voice.handle,0,1) end
end
function M:resetPlayback()
    for _,r in pairs(self.transports) do r:stop() end
    self.transports={};self.tireSlots={};self.tireFrame=nil
end
function M:bank(name,wheel,state,selector,interior,now,gate,gain,volumeBank)
    local key=name..":"..wheel
    local r=self.transports[key] or Bank.new(self.profile.banks[name],key,self.voices,self.backend)
    self.transports[key]=r
    r:update(state,selector,interior,now,gate,gain,volumeBank,self.applyControl)
    return r
end
function M:update(state,focus,interior)
    self.frames+=1
    if not state or state.fault then self:silence();return end
    if self.epoch~=state.epoch then
        if self.epoch~=nil then self.resets+=1;self:resetPlayback() end
        self.epoch=state.epoch;self.gear=state.gear
    elseif self.gear~=state.gear then self.shifts+=1;self.gear=state.gear end
    self.active=true;self.rpm=state.rpm;self.age=state.age or 0
    for _,v in pairs(self.voices) do v.gain=0;v.pitch=1 end
    local profile=self.profile;local now=state.sampleTime or state.time or 0
    local bankName=focus and (profile.engineBank or "winston.ces") or (profile.otherEngineBank or "winston_nf.ces")
    if bankName~=self.engineBank then
        if self.engineBank then self:resetPlayback() end
        self.engineBank=bankName
    end
    if profile.banks[bankName] then
        local selector=state.cesSelector==true
        local player=state.isPlayerCar;if player==nil then player=focus end
        self:bank(bankName,1,state,selector,interior,now,state.startGate or (player and 800 or -2),
            state.engineHalfVolume and .5 or 1,profile.banks["engvol.ces"])
    end
    local frame=math.floor((state.tick or now*288)/8)
    local steps=self.tireFrame and math.clamp(frame-self.tireFrame,0,18) or 1
    self.tireFrame=frame
    local aggregate=not focus and Tires.aggregate(state.wheels) or nil
    for j,w in ipairs(state.wheels) do
        local input=focus and w or (j==1 and aggregate or {volume=0,pitch=w.pitch,xfade=w.xfade,soundType=w.soundType})
        local slot=self.tireSlots[j] or Tires.newSlot();self.tireSlots[j]=slot
        local starts=slot.starts;local output=Tires.advance(slot,input,steps)
        if self.backend.position then self.backend:position(j,focus and (w.cx or 0) or 0,focus and (w.cy or 0) or 0,focus and (w.cz or 0) or 0) end
        local name=Tires.BANKS[output.soundType]
        if slot.runtime and (not slot.active or starts~=slot.starts) then
            slot.runtime:stop();self.transports[slot.runtime.key]=nil;slot.runtime=nil
        end
        if slot.active and name and profile.banks[name] then
            local key=name..":"..j
            if starts~=slot.starts then
                if self.transports[key] then self.transports[key]:stop() end
                self.transports[key]=nil
            end
            local r=self:bank(name,j,{rpm=output.xfade,load=1,gearScale=1,fixedPitch=output.pitch,volumeOverride=1},false,interior,now,-1,output.volume)
            slot.runtime=r
            if starts~=slot.starts then
                -- Original LCG/uniform formula, with a private playback seed.
                -- The original global random stream is not a physics input.
                local position;self.seed,position=Tires.random(self.seed)
                r:seek(Curves.f32(position))
            end
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
    local r=self.engineBank and self.transports[self.engineBank..":1"]
    local s={profile=self.profile.name,frames=self.frames,shifts=self.shifts,resets=self.resets,
        missing=self.missing,clipped=self.clipped,active=self.active,rpm=self.rpm or 0,age=self.age or 0,
        enginePhase=r and r.phase.phase or 3}
    if self.backend.stats then for k,v in pairs(self.backend:stats()) do s[k]=v end end
    return s
end
function M:destroy()
    self:silence();self.backend:destroy();table.clear(self.voices)
end
return M
