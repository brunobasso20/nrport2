-- Actual recovered car/world, stock setup files and unprocessed keyboard input.
local Vehicle=require('../../../core/NR2003CupVehicle')
local Setups=require('../../../roblox/NR2003WatkinsGlenSetup')
local fixtures=require('./driving_fixtures')
local function get(name)
    local ok,m=pcall(require,'../../../core/NR2003Cup/'..name)
    if not ok then ok,m=pcall(require,'../../core/NR2003Cup/'..name) end
    return ok and m or nil
end
local c=Vehicle.fromLoader(get)
local V=c.V
c:loadTrack()
local reports={}
local function controls(frame)
    local throttle=(frame>=24 and frame<100 or frame>=112) and 1 or 0
    return {originalPedals=true,throttle=throttle,throttleControl=throttle,throttleDigital=true,
        brakeControl=frame>=100 and frame<108 and 1 or 0,brakeDigital=true,clutch=1,
        steerLeft=frame>=126 and frame<128 and 1 or 0,steerRight=0,steerDigital=true,shiftUp=frame==18}
end
for _,name in ipairs({'fast','easy'}) do
    c:endSession()
    local items=Setups.new(V.Setup,name)
    assert(c:applySetup(items))
    V.setSteeringOptions({momentum=0})
    V.setForceFeedbackDevice({capable=false});V.setForceFeedbackOptions({enabled=false})
    V.setTrackStart(255,-.21,0)
    c:startSession({temperatureF=70,windSpeedMph=0,conditions=0},{damageLevel=0,series=1})
    V.setControlsSuspended(false)
    V.w8(0xbf6f04,0);V.w8(0xbf6f05,0);V.w8(0xbf6f06,0);V.w32(0xbf6f08,0)
    local position,velocity,force,slip,stateFields,pedals,gears,surfaces=0,0,0,0,0,0,0,0
    local squaredError,forceSamples,totalX,totalY,wantX,wantY,yaw=0,0,0,0,0,0,0
    local worst=''
    for frame,ref in ipairs(fixtures[name]) do
        for _=1,8 do c:step(controls(frame-1)) end
        local got=c:readState()
        for j=1,45 do
            assert(got[j]==got[j] and math.abs(got[j])<math.huge,'nonfinite original world')
            if got[j]~=ref.state[j] then stateFields+=1 end
        end
        for _,j in ipairs({1,3,5}) do position=math.max(position,math.abs(got[j]-ref.state[j])) end
        for _,j in ipairs({2,4,6}) do velocity=math.max(velocity,math.abs(got[j]-ref.state[j])) end
        yaw=math.max(yaw,math.abs(got[13]-ref.state[13]))
        if V.r32(0xbf6390)~=ref.throttle or V.r32(0xbf6eb0)~=ref.clutch then pedals+=1 end
        if V.gearIndex()~=ref.gear then gears+=1 end
        for w=0,3 do
            local tire=V.wheelBrake(w);local want=ref.wheels[w+1]
            if V.r32(0xbf3a20+w*0xa39+0x2c0)~=want[1] then surfaces+=1 end
            for k,value in ipairs({tire.fx,tire.fy,tire.fz}) do
                local diff=math.abs(value-want[k+1])
                squaredError+=diff*diff;forceSamples+=1
                if diff>force then force=diff;worst=string.format('frame %d wheel %d component %d got %.3f original %.3f',frame,w,k,value,want[k+1]) end
            end
            totalX+=tire.fx/36;totalY+=tire.fy/36;wantX+=want[2]/36;wantY+=want[3]/36
            slip=math.max(slip,math.abs(tire.vslip-want[5]))
        end
    end
    print(string.format('%s: pedals %d, gears %d, surfaces %d mismatches; state fields %d differ; max position %.9g m, velocity %.9g m/s, tire force %.9g N, slip velocity %.9g m/s',
        name,pedals,gears,surfaces,stateFields,position,velocity,force,slip))
    print(string.format('force RMS error %.3f N; net sampled Fx impulse %.3f / original %.3f Ns, Fy %.3f / %.3f Ns; max yaw-rate error %.6f rad/s; %s',
        math.sqrt(squaredError/forceSamples),totalX,wantX,totalY,wantY,yaw,worst))
    -- Pedals/gear/material are independently exact checks. Numeric trajectory
    -- differences stay printed; this is not a bit-identical dynamics assertion.
    assert(pedals==0 and gears==0 and surfaces==0,'Original input/gear/surface comparison failed')
    reports[name]={position=position,velocity=velocity,force=force,slip=slip,stateFields=stateFields}
end
print('Original keyboard input, stock setup placement and track surface comparisons passed; dynamics differences reported above.')
