"""Checked, additive hooks shared by the Studio patch and repository sources."""
SERVER_INIT='''-- NR2003_AUDIO_SERVER_V1
local audioServer=nil
do
    local f=package:FindFirstChild("Audio");local m=f and f:FindFirstChild("NR2003AudioServer")
    if m and Mode.mode=="NR2003_CUP" then
        local ok,value=pcall(function() return require(m).new(controller,package) end)
        if ok then audioServer=value else warn("NR2003 audio server: "..tostring(value)) end
    end
end
local function encodeAudioSnapshot(snapshot,packet)
    if audioServer then
        local ok,value=pcall(audioServer.encode,audioServer,snapshot,packet)
        if ok then return value end
        warn("NR2003 audio disabled: "..tostring(value));audioServer=nil
    end
    return packet
end
'''
CLIENT_INIT='''-- NR2003_AUDIO_CLIENT_V1
local audioClient=nil
do
    local f=package:FindFirstChild("Audio");local m=f and f:FindFirstChild("NR2003AudioClient")
    if m then
        local ok,value=pcall(function() return require(m).new(car,presentation,package,renderState) end)
        if ok then audioClient=value else warn("NR2003 audio client: "..tostring(value)) end
    end
end
script.Destroying:Connect(function() if audioClient then audioClient:destroy() end end)
'''
CLIENT_UPDATE='''    -- NR2003_AUDIO_UPDATE_V1
    if audioClient then
        local ok,value=pcall(audioClient.update,audioClient,dt,driving,__CAR_MODEL__,cameraMode)
        if not ok then
            warn("NR2003 audio disabled: "..tostring(value));audioClient:destroy();audioClient=nil
        end
    end
'''
def rules(kind,has_car_model=False):
    if kind=='server':
        anchor='local input={throttle=0,brake=1,steer=0,handbrake=0,clutch=1}'
        old='renderState:FireAllClients(RenderSnapshot.encode(snapshot))'
        return [('-- NR2003_AUDIO_SERVER_V1',anchor,SERVER_INIT+anchor),
            ('encodeAudioSnapshot(snapshot,RenderSnapshot.encode(snapshot))',old,
             'renderState:FireAllClients(encodeAudioSnapshot(snapshot,RenderSnapshot.encode(snapshot)))')]
    anchor='local function frame(dt)'
    old='    if not driving then return end\n    header.Visible=expanded;'
    update=CLIENT_UPDATE.replace('__CAR_MODEL__','carModel' if has_car_model else 'nil')
    return [('-- NR2003_AUDIO_CLIENT_V1',anchor,CLIENT_INIT+anchor),
        ('-- NR2003_AUDIO_UPDATE_V1',old,update+old)]

def patch(source,kind):
    source=source.replace('\r\n','\n')
    for marker,old,new in rules(kind,'local carModel' in source):
        if marker in source:
            if source.count(marker)!=1 or new not in source:raise ValueError('Edited/ambiguous audio hook '+marker)
        else:
            if source.count(old)!=1:raise ValueError('Unsupported '+kind+' source; missing/ambiguous audio anchor '+marker)
            source=source.replace(old,new,1)
    return source
