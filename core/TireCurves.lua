local L=require(script and script.Parent.Lookup or "core.Lookup")
local F=require(script and script.Parent.Float32 or "core.Float32").round
local C=require(script and script.Parent.RecoveredConstants or "core.RecoveredConstants")
local M={}
local function finish(a) a[#a-1]=a[#a] end
function M.new(p,rounding)
    -- 0054c1c0, x87 operands inspected. Obfuscated pow helper 006c5c40
    -- remains an inference; these curves are not claimed bit-identical.
    local slip,speed,sliding,load,stiffness={},{},{},{},{}
    for i=0,314 do
        local x=math.abs(i*C["006e9824"]-C["006f58e8"])*0.5
        slip[i+1]=F(1/(1+x^p.slipExponent))
    end
    slip[1]=slip[2]; finish(slip)
    for i=0,28 do
        speed[i+1]=F(1+math.log(i*4+1)/math.log(10)*p.speedSensitivity)
        sliding[i+1]=F(math.exp(-i*4/p.slidingDecay))
        load[i+1]=F(C["006f58a0"]*p.loadSensitivity*C["006f58e4"]*math.exp(1-i*0.125))
    end
    local a=0.75^p.stiffnessExponent; local b=0.75^(p.stiffnessExponent-1)*p.stiffnessExponent
    stiffness[1]=F(a-0.75*b); stiffness[2]=F(a-0.5*b); stiffness[3]=F(a-0.25*b)
    for i=3,28 do stiffness[i+1]=F((i*1000*C["006f58e0"])^p.stiffnessExponent) end
    finish(speed); finish(sliding); finish(load); finish(stiffness)
    local camber={}
    -- 0055e8f0 and 0055e980: Gaussian camber attenuation, 41 samples.
    for i=0,40 do
        local x=C["006f5838"]+i*C["006ea4a4"]
        camber[i+1]=F(0.3*math.exp(x*x*math.log(0.5)/(10*C["006f5cd4"])^2)+0.7)
    end
    camber[1]=camber[2]; camber[#camber]=camber[#camber-1]
    return {slip=L.new(F(-31.4),5,slip,rounding),speed=L.new(0,0.25,speed,rounding),
        sliding=L.new(0,0.25,sliding,rounding),load=L.new(0,8,load,rounding),
        stiffness=L.new(0,F(0.001),stiffness,rounding),camber=L.new(F(-0.2),100,camber,rounding)}
end
return M
