local U=require(script and script.Parent.MathUtil or "core.MathUtil")
local Engine=require(script and script.Parent.Engine or "core.Engine")
local M={}
function M.limitTorque(capacity,demand)
    -- 00561040: signed torque opposing demand, limited by capacity.
    return demand>=0 and -math.min(demand,capacity) or math.min(-demand,capacity)
end
function M.new(tune,rounding)
    return {omega=tune.idleRPM*math.pi/30,gear=1,shiftTimer=0,rpm=tune.idleRPM,
        tables=Engine.testTables(tune,rounding),engineTorque=0,clutchTorque=0,clutchSlip=0}
end
function M.shift(s,delta,tune)
    if s.shiftTimer>0 then return end
    s.gear=U.clamp(s.gear+U.sign(delta),-1,#tune.gears); s.shiftTimer=tune.shiftSeconds
end
function M.step(s,tune,input,wheelOmega,dt)
    -- Adapter integration. Does NOT claim the original multibody solve.
    s.shiftTimer=math.max(0,s.shiftTimer-dt); s.rpm=s.omega*30/math.pi
    local ratio=s.gear==-1 and tune.reverseRatio or (s.gear==0 and 0 or tune.gears[s.gear])
    ratio=ratio*tune.finalDrive
    local throttle=math.max(input.throttle,U.clamp((tune.idleRPM-s.rpm)/500,0,0.4))
    local cut=s.rpm>=tune.redlineRPM and 1 or s.shiftTimer
    local torque=Engine.torque(s.tables,s.rpm,throttle,1,cut,0)
    local clutch=1-(input.clutch or 0)
    if s.shiftTimer>0 or ratio==0 then clutch=0 end
    local shaft=(wheelOmega[3]+wheelOmega[4])*0.5*ratio; local slip=s.omega-shaft
    clutch=clutch*U.clamp((s.rpm-tune.idleRPM+250)/1000,0,1)
    -- Automatic launch clutch opens at walking speed with no throttle; no idle creep.
    if math.abs(shaft)<tune.idleRPM*math.pi/30*0.75 and input.throttle<0.01 then clutch=0 end
    local reflected=tune.wheelInertia*2/math.max(ratio*ratio,0.001)
    local effective=1/(1/tune.engineInertia+1/reflected)
    local transfer=U.clamp(slip*effective/dt,-tune.clutchCapacity*clutch,tune.clutchCapacity*clutch)
    local total=transfer*ratio*tune.efficiency
    local capacity=tune.diffPreload+tune.diffPowerLock*math.abs(total)
    local lockDemand=(wheelOmega[3]-wheelOmega[4])*tune.wheelInertia/(2*dt)
    local lock=-M.limitTorque(capacity,lockDemand)
    s.omega=math.max(0,s.omega+(torque-transfer)/tune.engineInertia*dt)
    s.rpm=s.omega*30/math.pi; s.engineTorque=torque; s.clutchTorque=transfer; s.clutchSlip=slip; s.ratio=ratio
    return {0,0,total*0.5-lock,total*0.5+lock}
end
function M.brake(omega,external,capacity,inertia,dt)
    return M.limitTorque(math.max(0,capacity),external+omega*inertia/dt)
end
function M.differentialCapacity(engine,clutch,engagement,gear,finalDrive,powerRamp,coastRamp,axleForce,unloadForce)
    -- 005614b0 with the setup getters passed explicitly.
    local t=gear*finalDrive*(engine+(engagement>=0.9 and clutch or 0))
    t=t>=0 and t*powerRamp or -t*coastRamp
    return math.max(0,(1-math.abs(axleForce)/unloadForce)*t)
end
return M
