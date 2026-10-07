local L=require(script and script.Parent.Lookup or "core.Lookup")
local F=require(script and script.Parent.Float32 or "core.Float32").round
local C=require(script and script.Parent.RecoveredConstants or "core.RecoveredConstants")
local M={}
-- 006f5b50, 25 samples, header 0/100/23. Actual binary shock lookup.
local shock=L.new(0,100,{0,600,970,1260,1470,1610,1730,1820,1900,1970,2030,2080,
    2130,2180,2230,2280,2330,2390,2445,2500,2560,2620,2690,2760,2840})
function M.springTable(rate,travel,bumpTravel,bumpForce,rounding)
    assert(bumpTravel>0,"bumpTravel must be positive")
    local samples={}; local threshold=travel-bumpTravel
    for i=0,19 do
        local x=i*C["006ea4a4"]; local force=x*rate
        if x>threshold then force=force+((x-threshold)/bumpTravel)^3*bumpForce end
        samples[i+1]=F(force)
    end
    -- 0055e490: unusual first sample is retained, not replaced by zero.
    samples[1]=F(C["006f5b1c"]*C["006f5b2c"]*C["006f5cd0"]*C["006ee5e4"])
    return L.new(0,100,samples,rounding)
end
function M.damperTable(motionRatio,positiveScale,negativeScale,rounding)
    -- 0055e510: asymmetry and exact sample count retained.
    local samples={}; local x=F(-0.35)
    for i=1,35 do
        samples[i]=F(L.sample(shock,-x*motionRatio)*motionRatio*negativeScale)
        x=F(x+C["006ea4a4"])
    end
    x=F(x+C["006ea4a4"]); samples[36]=0
    for i=37,70 do
        samples[i]=F(-L.sample(shock,x*motionRatio)*motionRatio*positiveScale)
        x=F(x+C["006ea4a4"])
    end
    return L.new(F(-0.35),100,samples,rounding)
end
function M.new(p,rounding)
    return {spring=M.springTable(p.rate,p.travel,p.bumpTravel,p.bumpForce,rounding),
        damper=M.damperTable(p.motionRatio,p.rebound,p.compression,rounding)}
end
function M.force(p,position,velocity)
    -- 00560b40
    local s=L.sample(p.spring,position); local d=L.sample(p.damper,velocity)
    return s+d,s,d
end
function M.antiRoll(left,right,preload,rate)
    -- 00560c30, opposite forces.
    local f=(left-right-preload)*rate; return f,-f
end
function M.rearAxle(leftTable,rightTable,heave,roll,heaveRate,rollRate,halfTrack,offset)
    -- 005608d0. Its first antiroll moment is overwritten in the recovered builder.
    local left=M.force(leftTable,heave+roll*halfTrack,heaveRate+rollRate*halfTrack)
    local right=M.force(rightTable,heave-roll*halfTrack-(offset or 0),heaveRate-rollRate*halfTrack)
    return left+right,(left-right)*halfTrack,left,right
end
return M
