-- Selected numerical paths of 0054d610 and 0054f260.
-- Full wear/failure simulation is NOT replaced by a made-up wear counter.
local C=require(script and script.Parent.RecoveredConstants or "core.RecoveredConstants")
local F=require(script and script.Parent.Float32 or "core.Float32").round
local M={}
function M.new(p)
    return {surface={p.initialK,p.initialK,p.initialK},carcass={p.initialK,p.initialK,p.initialK},
        brakeK=295,pressure=p.coldPressure,gripFactor=1}
end
function M.properties(s,p,ambientK,stiffness)
    local sum=s.carcass[1]+s.carcass[2]+s.carcass[3]
    local pressure=(((sum*C["006f5938"]-ambientK)*0.4+ambientK)/ambientK)*p.coldPressure
    s.pressure=F(pressure)
    local pressureScale=pressure/p.referencePressure*0.9+0.1
    local optimumScale=pressure/p.optimumPressure*0.9+0.1
    local inverseLoad=(C["006f58e4"]-sum*C["006f5934"])/(2*optimumScale*p.loadReference)
    local patch=C["006f5894"]*C["006f588c"]^2/math.max(p.minimumPressure,pressure)
    local hottest=math.max(s.surface[1],s.surface[2],s.surface[3])
    local delta=(sum*C["006f5938"]+hottest)*0.5-p.optimumK
    local exponent=math.min(C["006f5914"],delta)*C["006f5910"]
    local loss=(math.exp(exponent)-1)^2*(delta<0 and C["006f590c"] or 4)
    local pressureGrip=math.exp((pressure-(p.optimumPressure-4))^2*C["006f5908"])*0.1+0.9
    s.gripFactor=F((1-loss)*pressureGrip)
    return {verticalStiffness=stiffness*pressureScale,inverseLoad=inverseLoad,
        contactPatch=patch,rollingScale=1/pressureScale,gripFactor=s.gripFactor}
end
function M.step(s,p,i,dt)
    local slipPower=math.sqrt((i.latForce*i.slipLat*i.sliding)^2+(i.longForce*i.slipLong*i.sliding)^2)
    local rollPower=i.rollingForce*math.abs(i.treadSpeed)
    local speedSum=math.abs(i.slipLong)+math.abs(i.slipLat)+math.abs(i.treadSpeed)
    if speedSum<3 then slipPower=0; rollPower=0
    elseif speedSum<10 then
        local fade=(speedSum-3)*C["006f5930"]; slipPower=slipPower*fade; rollPower=rollPower*fade
    end
    local heat=0.5*p.heatScale*slipPower*p.heatFraction
    local rollingHeat=p.heatScale*rollPower*p.heatFraction
    local camber=(i.side or 1)*(i.camber or 0); local weights={0.6,1,1.4}
    if camber<C["006f591c"] then weights={1.4,1,0.6}
    elseif camber<=C["006f5924"] then local f=camber*C["006f5918"]*0.4; weights={1-f,1,1+f} end
    weights[2]=math.sqrt((s.pressure*0.9)/(p.optimumPressure-4)+0.1)
    weights[1]=weights[1]/weights[2]; weights[3]=weights[3]/weights[2]
    if math.abs(i.forwardSpeed)<9 then
        local fade=math.abs(i.forwardSpeed)*C["006f4a50"]; heat=heat*fade; rollingHeat=rollingHeat*fade
    end
    -- Unknown global speed driver and small offset are explicit test inputs.
    local cooling=math.sqrt(math.max(0,i.speed)+p.coolingSpeedOffset)*dt*C["006ee5e0"]
    for j=1,3 do
        local conduction=(s.surface[j]-s.carcass[j])*p.conduction
        local top=s.surface[j]+(heat*weights[j]-conduction)/p.surfaceCapacity*dt
        local inner=s.carcass[j]+(conduction+rollingHeat)/p.carcassCapacity*dt
        top=top-(top-i.ambientK)*p.surfaceCooling*cooling/p.surfaceCapacity
        inner=inner-(inner-i.ambientK)*p.carcassCooling*cooling/p.carcassCapacity
        s.surface[j]=F(math.min(p.maximumK,top)); s.carcass[j]=F(math.min(p.maximumK,inner))
    end
    for _,j in ipairs({1,3}) do
        local transfer=(s.carcass[2]-s.carcass[j])*p.conduction/p.carcassCapacity*dt*C["006ea48c"]
        s.carcass[2]=F(s.carcass[2]-transfer); s.carcass[j]=F(s.carcass[j]+transfer)
    end
    s.brakeK=F(s.brakeK+((i.brakePower or 0)/p.brakeCapacity-
        (s.brakeK-i.ambientK)*(math.sqrt(math.max(0,i.speed))+1)*p.brakeCooling)*dt)
    return slipPower,rollPower
end
return M
