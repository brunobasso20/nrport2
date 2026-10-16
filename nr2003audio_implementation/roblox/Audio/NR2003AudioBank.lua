-- A CES bank's original shared phase transport, adapted to asynchronous Sound
-- voices. The platform owns sample clocks; no second engine is simulated here.
local Engine=require(script and script.Parent.NR2003AudioEngine or "./NR2003AudioEngine")
local Curves=require(script and script.Parent.NR2003AudioCurves or "./NR2003AudioCurves")
local Phases=require(script and script.Parent.NR2003AudioPhases or "./NR2003AudioPhases")
local M={};M.__index=M
function M.layout(bank,tire)
    -- 00556b0d creates tire banks as engine/group 0. 004eab20/004ea9f0
    -- take up to four engine/gear groups in first appearance order, engines first.
    if tire then return {"0:0"} end
    local list,seen={},{}
    for mechanical=0,1 do for _,s in ipairs(bank.samples) do
        local key=s.mechanical..":"..s.group
        if s.mechanical==mechanical and not seen[key] and #list<4 then
            seen[key]=true;list[#list+1]=key
        end
    end end
    return list
end
function M.new(bank,key,voices,backend)
    local self=setmetatable({bank=bank,key=key,backend=backend,phase=Phases.new(),groups={},controls={},available={}},M)
    local byKey={}
    for i,s in ipairs(bank.samples) do
        local voice=voices[key..":"..i]
        if voice then
            self.available[i]=true
            local k=s.mechanical..":"..s.group
            local g=byKey[k] or {key=k,samples={},mechanical=s.mechanical,group=s.group}
            byKey[k]=g;g.samples[#g.samples+1]={index=i,voice=voice}
            if s.mechanical==0 and s.phase~=0 then g.hasPhases=true end
        end
    end
    for _,k in ipairs(M.layout(bank,key:match("^tire_")~=nil)) do
        if byKey[k] then self.groups[#self.groups+1]=byKey[k] end
    end
    for _,g in ipairs(self.groups) do if g.hasPhases then self.master=g;break end end
    self.master=self.master or self.groups[1]
    return self
end
local function first(group,phase,interior)
    if not group then return nil end
    for _,e in ipairs(group.samples) do
        local s=e.voice.sample
        -- 004ec2b0 builds intro/outro lists with selector parameter 1.
        if s.phase==phase and Curves.selected(s,false,interior) then return e end
    end
    return nil
end
function M:normalized(e) return e and self.backend.normalized and self.backend:normalized(e.voice.handle) or 0 end
function M:changed(old,interior)
    local phase=self.phase.phase
    if phase~=Phases.LOOP then self.blend=false end
    if phase~=Phases.INTRO and phase~=Phases.OUTRO then
        for _,g in ipairs(self.groups) do for _,e in ipairs(g.samples) do
            local s=e.voice.sample
            local tail=phase==Phases.LOOP and self.blend and g==self.master and s.phase==1
            if s.phase~=0 and not tail and self.backend.stop then self.backend:stop(e.voice.handle) end
        end end
        return
    end
    local samplePhase=phase==Phases.INTRO and 1 or 2
    for _,g in ipairs(self.groups) do
        local opposite=first(g,samplePhase==1 and 2 or 1,interior)
        local mirrored=(old==Phases.INTRO or old==Phases.OUTRO) and opposite~=nil
        local position=mirrored and 1-self:normalized(opposite) or 0
        for _,e in ipairs(g.samples) do
            if e.voice.sample.phase==samplePhase and self.backend.play then self.backend:play(e.voice.handle,position)
            elseif e.voice.sample.phase~=0 and self.backend.stop then self.backend:stop(e.voice.handle) end
        end
    end
end
function M:stop()
    for _,g in ipairs(self.groups) do for _,e in ipairs(g.samples) do
        if e.voice.sample.phase~=0 and self.backend.stop then self.backend:stop(e.voice.handle) end
    end end
end
function M:seek(position)
    if not self.backend.seek then return end
    local phase=self.phase.phase
    local samplePhase=phase==Phases.INTRO and 1 or (phase==Phases.OUTRO and 2 or 0)
    for _,g in ipairs(self.groups) do for _,e in ipairs(g.samples) do
        if e.voice.sample.phase==samplePhase then self.backend:seek(e.voice.handle,position) end
    end end
end
function M:update(state,selector,interior,now,gate,outerGain,volumeBank,apply)
    local intro,outro=first(self.master,1,interior),first(self.master,2,interior)
    local old=self.phase.phase
    if Phases.update(self.phase,self.bank.thresholds or {0,0},state.rpm,state.load,gate,intro~=nil,outro~=nil,now) then
        self:changed(old,interior)
    end
    local phase=self.phase.phase
    if phase==Phases.INTRO or phase==Phases.OUTRO then
        local samplePhase=phase==Phases.INTRO and 1 or 2
        local playing=false
        if self.master then for _,e in ipairs(self.master.samples) do
            if e.voice.sample.phase==samplePhase and self.backend.playing and self.backend:playing(e.voice.handle) then playing=true end
        end end
        local blend=phase==Phases.INTRO and intro and self:normalized(intro)>0.6000000238418579
        if blend or not playing then
            Phases.change(self.phase,phase==Phases.INTRO and Phases.LOOP or Phases.STOP,now)
            self.blend=blend==true;self:changed(phase,interior);phase=self.phase.phase
        end
    end
    local groups
    self.controls,groups=Engine.controls(self.bank,state,selector,interior,self.controls,volumeBank,self.available)
    local loopFactor=1
    if self.blend then loopFactor=math.clamp((self:normalized(intro)-0.6000000238418579)*2.500000238418579,0,1) end
    if self.blend and loopFactor==1 then self.blend=false;self:stop() end
    for i,c in ipairs(self.controls) do
        local gain=c.gain
        if phase~=Phases.LOOP then gain=0
        elseif self.blend and self.master and c.group==self.master.key then gain*=loopFactor end
        apply(self.key..":"..i,{gain=gain*outerGain,pitch=c.pitch})
    end
    for _,g in ipairs(self.groups) do
        local e=nil;local scale=1
        if phase==Phases.INTRO then e=first(g,1,interior)
        elseif phase==Phases.OUTRO then e=first(g,2,interior)
        elseif self.blend and g==self.master then e=first(g,1,interior);scale=1-loopFactor end
        if e then
            local s=e.voice.sample;local control=groups[g.key]
            local gain=s.enabled and control and math.min(control.weight,1)*control.gain*scale*outerGain or 0
            local pitch=state.fixedPitch or Curves.pitch(self.bank,s,state.rpm,state.gearScale) or 1
            apply(self.key..":"..e.index,{gain=gain,pitch=pitch})
        end
    end
end
return M
