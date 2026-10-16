-- Roblox playback adapter. Sound.PlaybackSpeed changes both pitch and duration.
-- Roll-off and Sound's mixer/resampler are Roblox choices, not NR2003 DirectSound.
local M={};M.__index=M
function M.new(car,profile)
    local root=assert(car:FindFirstChild("Chassis") or car.PrimaryPart,"Audio car has no Chassis")
    local self=setmetatable({root=root,profile=profile,sounds={},connections={},attachments={},failures=0,
        loaded=0,starts=0,destroyed=false},M)
    for j=0,4 do
        local a=Instance.new("Attachment");a.Name="NR2003Audio_"..j;a.Parent=root;self.attachments[j]=a
    end
    return self
end
function M:create(key,id,wheel,sample)
    local s=Instance.new("Sound");s.Name=key;s.SoundId=id;s.Volume=0;s.Looped=(sample.phase or 0)==0
    s.RollOffMode=Enum.RollOffMode.InverseTapered
    s.RollOffMinDistance=self.profile.rollOffMinMetres/0.28
    s.RollOffMaxDistance=self.profile.rollOffMaxMetres/0.28
    if s.Looped and sample.loop and sample.loop.startSeconds and sample.loop.endSeconds then
        local ok=pcall(function()
            s.PlaybackRegionsEnabled=true
            s.LoopRegion=NumberRange.new(sample.loop.startSeconds,sample.loop.endSeconds)
        end)
        if not ok then self.failures+=1 end
    end
    s.Parent=self.attachments[wheel]
    local entry={sound=s,gain=0,pitch=1,started=false,looping=s.Looped,ready=false};self.sounds[#self.sounds+1]=entry
    local function start()
        if self.destroyed or not s.IsLoaded then return end
        entry.failed=false
        if not entry.ready then entry.ready=true;self.loaded+=1 end
        if entry.looping then
            if entry.started then return end
            if entry.seek~=nil then self:seek(entry,entry.seek);entry.seek=nil end
            entry.started=true;self.starts+=1;s:Play()
        elseif entry.pending~=nil then self:play(entry,entry.pending) end
    end
    self.connections[#self.connections+1]=s.Loaded:Connect(start)
    self.connections[#self.connections+1]=s.Ended:Connect(function() entry.completed=true;entry.started=false end)
    start()
    return entry
end
function M:preload()
    if #self.sounds==0 then return end
    local sounds={};for _,entry in ipairs(self.sounds) do sounds[#sounds+1]=entry.sound end
    task.spawn(function()
        local ok=pcall(function()
            game:GetService("ContentProvider"):PreloadAsync(sounds,function(id,status)
                if not self.destroyed and status~=Enum.AssetFetchStatus.Success then
                    self.failures+=1
                    for _,entry in ipairs(self.sounds) do
                        if entry.sound.SoundId==id and not entry.ready then entry.failed=true;entry.pending=nil end
                    end
                end
            end)
        end)
        if not ok and not self.destroyed then
            self.failures+=1
            for _,entry in ipairs(self.sounds) do if not entry.ready then entry.failed=true;entry.pending=nil end end
        end
    end)
end
function M:set(entry,gain,pitch)
    if self.destroyed then return end
    -- Calls only update controls. Active loops keep their playback positions.
    if entry.gain~=gain then entry.gain=gain;entry.sound.Volume=gain end
    if entry.pitch~=pitch then entry.pitch=pitch;entry.sound.PlaybackSpeed=pitch end
end
function M:seek(entry,normalized)
    if self.destroyed then return end
    local s=entry.sound
    if not entry.ready then entry.seek=normalized;return end
    s.TimePosition=math.clamp(normalized,0,1)*s.TimeLength
end
function M:play(entry,normalized)
    if self.destroyed or entry.failed then return end
    if not entry.ready then entry.pending=normalized;return end
    entry.pending=nil;entry.completed=false
    entry.sound:Stop();self:seek(entry,normalized)
    entry.started=true;self.starts+=1;entry.sound:Play()
end
function M:stop(entry)
    entry.pending=nil
    if self.destroyed or entry.looping or not entry.started then return end
    entry.sound:Stop();entry.started=false
end
function M:normalized(entry)
    local s=entry.sound
    if entry.completed then return 1 end
    return entry.ready and s.TimeLength>0 and math.clamp(s.TimePosition/s.TimeLength,0,1) or 0
end
function M:playing(entry) return not entry.failed and (entry.pending~=nil or (entry.started and not entry.completed)) end
function M:position(j,x,y,z) self.attachments[j].Position=Vector3.new(x,y,z) end
function M:stats() return {voices=#self.sounds,loaded=self.loaded,failures=self.failures,starts=self.starts} end
function M:destroy()
    if self.destroyed then return end;self.destroyed=true
    for _,c in ipairs(self.connections) do c:Disconnect() end
    for _,a in pairs(self.attachments) do a:Destroy() end
    table.clear(self.sounds);table.clear(self.connections);table.clear(self.attachments)
end
return M
