-- CES shared transport: 004eac30, 004f01f0, 004f02d0. These are playback
-- states, not ignition/physics states. Native fixtures exercise the decisions.
local M={INTRO=0,OUTRO=1,LOOP=2,STOP=3}
function M.new() return {phase=M.STOP,lastTransition=-1000} end
function M.change(transport,phase,now)
    if phase==M.INTRO or phase==M.OUTRO then
        if transport.phase==phase or (now>=0 and now<=transport.lastTransition+0.5) then return false end
        transport.lastTransition=now
    else transport.lastTransition=-1000 end
    local changed=transport.phase~=phase
    transport.phase=phase
    return changed
end
function M.update(transport,thresholds,rpm,load,startGate,hasIntro,hasOutro,now)
    local a,b=thresholds[1],thresholds[2]
    local phase=transport.phase;local target=nil
    if a>0 or b>0 then
        local running=(a<=0 or rpm>a) and (b<=0 or load>b)
        if phase==M.INTRO or phase==M.LOOP then
            if not running then target=hasOutro and math.abs(startGate+2)>0.5 and M.OUTRO or M.STOP end
        elseif phase==M.OUTRO then
            if running then target=hasIntro and M.INTRO or M.LOOP end
        elseif phase==M.STOP and running then
            local start=hasIntro and ((startGate>=0 and rpm<startGate) or math.abs(startGate+1)<0.5)
            target=start and M.INTRO or M.LOOP
        end
    else target=load>0.0001 and M.LOOP or M.STOP end
    if target~=nil then return M.change(transport,target,now) end
    return false
end
return M
