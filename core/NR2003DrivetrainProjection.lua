-- 0055fc50 builds a velocity correction matrix; 0055f8f0 applies it.
-- Original model uses LR inertia for the symmetric rear wheel pair.
local Math=require(script and script.Parent.NR2003Math or "NR2003Math")
local f=Math.f
local M={threshold=f(0.9)}
function M.matrix(p)
    local ie,ic,io,iw=f(p.engineInertia),f(p.clutchInertia),f(p.outputInertia),f(p.wheelInertia)
    local g,d=f(p.gearRatio),f(p.finalDrive)
    local engaged=f(p.clutchEngagement or 0); local d2=f(d*d)
    assert(ie>=0 and ic>0 and io>0 and iw>0 and d~=0,"Invalid drivetrain inertias/ratio")
    local m=Math.zero(36)
    local function put(i,j,v) assert(Math.finite(v),"Singular drivetrain"); m[(i-1)*6+j]=f(v) end
    if g==0 then
        local inv=engaged>=M.threshold and f(1/f(ic+ie)) or 0
        put(1,1,-f(ic*inv)); put(2,1,f(inv*ie)); put(1,2,f(ic*inv)); put(2,2,-f(inv*ie))
        inv=f(1/f(f(iw+iw)+f(io*d2)))
        local wheel=f(iw*inv); put(3,3,f(-2*wheel))
        local output=f(inv*io); local a=f(output*d); put(4,3,a); put(5,3,a)
        wheel=f(wheel*d); put(3,4,wheel); put(3,5,wheel)
        local b=f(f(output*d2)*(-0.5)); put(4,4,b); put(5,4,b); put(4,5,b); put(5,5,b)
    else
        local g2=f(g*g); local enabled=1
        if engaged<M.threshold then enabled=0; ie=0 end
        local pair=f(f(ic+ie)*g2); local total=f(pair+io); local wheels=f(iw+iw)
        local inv=f(1/f(f(total*d2)+wheels))
        put(1,1,-(((g2*ic+io)*d2+wheels)*enabled*inv)); put(2,1,g2*inv*ie*d2)
        local a=f(inv*ie*g); put(3,1,d2*a); a=f(a*d); put(4,1,a); put(5,1,a)
        put(1,2,enabled*g2*inv*ic*d2); put(2,2,-(((g2*ie+io)*d2+wheels)*inv))
        a=f(inv*ic*g); put(3,2,d2*a); a=f(a*d); put(4,2,a); put(5,2,a)
        put(1,3,io*enabled*inv*g*d2); put(2,3,g*inv*io*d2); put(3,3,-((pair*d2+wheels)*inv))
        a=f(inv*io*d); put(4,3,a); put(5,3,a)
        a=f(enabled*inv*iw*g*d); local b=f(g*inv*iw*d); local c=f(inv*iw*d); local z=f(total*inv*d2*(-0.5))
        put(1,4,a); put(1,5,a); put(2,4,b); put(2,5,b); put(3,4,c); put(3,5,c)
        put(4,4,z); put(5,4,z); put(4,5,z); put(5,5,z)
    end
    return m
end
function M.apply(solver,accumulator,p)
    local names={"engine","clutch","outshaft","lrwheel","rrwheel"}; local axes={4,4,4,5,5}
    local velocity={0,0,0,0,0,0}
    for i,name in ipairs(names) do velocity[i]=assert(solver.state.components[name]).velocity[axes[i]] end
    local delta=Math.mv(M.matrix(p),velocity,6)
    local reaction=Math.zero(6)
    for i,name in ipairs(names) do
        local s=solver.state.components[name]; local n=solver.graph.byName[name]; local axis=axes[i]
        s.velocity[axis]=f(s.velocity[axis]+delta[i]); s.totalVelocity[axis]=f(s.totalVelocity[axis]+delta[i])
        reaction[axis]=f(reaction[axis]-f(f(delta[i]*288)*n.inertia[axis-3]))
    end
    accumulator:localWrench("chassis",reaction)
    return delta
end
return M
