local L=require(script and script.Parent.Lookup or "core.Lookup")
local F=require(script and script.Parent.Float32 or "core.Float32").round
local M={}
function M.fit(p)
    -- 0051a4a0, raw six calibration parameters -> cubic coefficients.
    local x,t,y,u,z,v=p[1],p[2],p[3],p[4],p[5],p[6]
    local x2,y2,z2=x*x,y*y,z*z; local z3=z2*z
    local y3v=y2*y*v; local z3u=z3*u; local delta=y2-2*z*y+z2
    local d=(((2*z3u+y3v-z2*u*y*3)*y*x+
        ((y2*v-2*z*u*y+z2*u)*x2*x-(2*y3v-y2*z*u*3+z3u)*x2))-
        t*delta*y2*z)/(((2*z+y)*y*x+x2*x-(2*y+z)*x2-y2*z)*delta)
    local c=-(((3*y-2*z)*z2*u+(2*z3+y2*y-z2*y*3)*d-y3v)/(delta*z*y))
    local b=((d-v)*y2*3+(3*y2-z2)*c*z)/((2*z-3*y)*z2*y)
    return {F(-(2*b*y+c)/(3*y2)),F(b),F(c),F(d)}
end
function M.testTables(tune,rounding)
    -- Explicit diagnostic torque maps. NOT original NR2003 engine calibration.
    local gross,loss={},{}
    for i=0,129 do
        local rpm=i*200
        loss[i+1]=F(L.linear(tune.frictionCurve,rpm))
        gross[i+1]=F(L.linear(tune.netTorqueCurve,rpm)+loss[i+1])
    end
    return {gross=L.new(0,F(0.005),gross,rounding),friction=L.new(0,F(0.005),loss,rounding)}
end
function M.torque(tables,rpm,throttle,running,cutTimer,damageTorque)
    -- 0051a870. scalar running corresponds to original +0x554.
    local sampleRpm=math.max(0,rpm)
    if cutTimer>0 then throttle=0 end
    local gross=L.sample(tables.gross,sampleRpm)*running
    local idle=1000/math.max(1000,rpm)*running*65
    local combustion=math.max(0,gross-idle)*throttle+idle
    local friction=L.sample(tables.friction,sampleRpm)+math.max(0,damageTorque or 0)
    if rpm<0 then friction=-friction end
    return F(combustion-friction),F(combustion),F(friction)
end
return M
