-- Recovered force algebra; tables and capacities are explicit runtime inputs.
local Math=require(script and script.Parent.NR2003Math or "NR2003Math")
local Integrator=require(script and script.Parent.NR2003Integrator or "NR2003Integrator")
local f=Math.f
local M={}
-- 00561040, opposing torque limited by capacity.
function M.opposingTorque(capacity,demand)
    assert(Math.finite(capacity) and capacity>=0 and Math.finite(demand),"Invalid torque limit")
    return f(-math.max(-capacity,math.min(capacity,demand)))
end
-- 00560b40; lookups return signed forces.
function M.frontSuspension(solver,acc,name,springLookup,damperLookup)
    local s=solver.state.components[name]
    local force=f(springLookup(s.translation[3])+damperLookup(s.velocity[3]))
    acc:childReaction(name,{0,0,force,0,0,0});return force
end
-- 00560c30.
function M.frontAntiRoll(solver,acc,coefficient,preload)
    local s=solver.state.components
    local delta=f(f(s.lfsusp.translation[3]-s.rfsusp.translation[3])-(preload or 0))
    local force=f(coefficient*delta)
    acc:childReaction("lfsusp",{0,0,force,0,0,0})
    acc:childReaction("rfsusp",{0,0,-force,0,0,0});return force
end
-- 005608d0. Initial ARB expression is overwritten in the recovered direct path.
function M.rearSuspension(solver,acc,p)
    local s=solver.state.components.raxle;local arm=p.halfTrack
    local roll=f(s.orientation[1]*arm);local rate=f(s.velocity[4]*arm)
    local left=f(p.leftSpring(f(s.translation[3]+roll))+p.leftDamper(f(s.velocity[3]+rate)))
    local right=f(p.rightSpring(f(f(s.translation[3]-roll)-(p.preload or 0)))+p.rightDamper(f(s.velocity[3]-rate)))
    acc:childReaction("raxle",{0,0,f(left+right),f(f(left*arm)-f(right*arm)),0,0})
    return left,right
end
-- 00560e80 / 00561290, with externally evaluated capacity.
local function couple(solver,acc,left,right,axis,capacity)
    local l,r=solver.state.components[left],solver.state.components[right]
    local il,ir=solver.graph.byName[left].inertia[axis],solver.graph.byName[right].inertia[axis]
    local slot=axis+3
    local common=f(f(f(ir*r.velocity[slot])+f(Integrator.dt*f(l.force[slot]+r.force[slot])))+f(il*l.velocity[slot]))
    common=f(f(1/f(il+ir))*common)
    local demand=f(f(f(il*f(l.velocity[slot]-common))*288)+l.force[slot])
    local torque=M.opposingTorque(capacity,demand);local w=Math.zero(6);w[slot]=torque
    acc:localWrench(left,w);acc:localWrench(right,Math.scale(w,-1));return torque
end
function M.clutch(solver,acc,capacity) return couple(solver,acc,"clutch","engine",1,capacity) end
function M.differential(solver,acc,capacity) return couple(solver,acc,"lrwheel","rrwheel",2,capacity) end
-- 005610b0, given total brake capacity.
function M.brake(solver,acc,name,capacity)
    local s=solver.state.components[name];local inertia=solver.graph.byName[name].inertia[2]
    local demand=f(f(f(inertia*s.velocity[5])*288)+s.force[5])
    local torque=M.opposingTorque(capacity,demand);acc:jointTorque(name,2,torque);return torque
end
return M
