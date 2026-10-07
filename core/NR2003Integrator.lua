-- 005b39a0 predictor, 005b3e50 corrector, 005b2fb0 commit.
-- This advances projected momentum; it is not an assumed RK4 or Euler solver.
local Math=require(script and script.Parent.NR2003Math or "NR2003Math")
local Mass=require(script and script.Parent.NR2003MassProperties or "NR2003MassProperties")
local Constraints=require(script and script.Parent.NR2003Constraints or "NR2003Constraints")
local f=Math.f
local M={dt=f(1/288),halfDt=f(1/576),frequency=288}
local function pose(n,state,velocity,h,input)
    local s=state.components[n.name]; local old=s.saved or s
    local prescribed=input and input.prescribed and input.prescribed[n.name]
    if n.prescribed>=1 and n.prescribed<=3 then
        if prescribed~=nil then assert(Math.finite(prescribed),"Invalid prescribed coordinate"); s.translation[n.prescribed]=f(prescribed) end
    else s.translation=Math.add(old.translation,Math.scale(Math.slice(velocity,1,3),h)) end
    if n.parent then
        local p=state.components[n.parent.name]
        s.attachmentRotation=Math.mul(p.worldRotation,n.baseRotation,3,3,3)
        s.attachmentPosition=Math.add(Math.mv(p.worldRotation,n.offset,3),p.worldPosition)
    else s.attachmentRotation=Math.copy(n.baseRotation); s.attachmentPosition=Math.copy(n.offset) end
    s.worldPosition=Math.add(Math.mv(s.attachmentRotation,s.translation,3),s.attachmentPosition)
    local axis=n.prescribed>=4 and n.prescribed-3 or n.rotationAxis
    if axis>0 then
        if n.prescribed>=4 then
            if prescribed~=nil then assert(Math.finite(prescribed),"Invalid prescribed angle"); s.orientation[1]=f(prescribed) end
        else s.orientation[1]=Math.wrap(f(old.orientation[1]+f(h*velocity[axis+3]))) end
        s.relativeRotation=n.axisymmetric and Math.eye(3) or Math.axisRotation(axis,s.orientation[1])
    elseif n.quaternion then
        local omega=Math.scale(Math.scale(Math.slice(velocity,4,3),f(0.5)),h)
        local dq=Math.quatMultiply(old.orientation,Math.join(omega,{0}))
        s.orientation=Math.normalizeQuaternion(Math.add(old.orientation,dq))
        s.relativeRotation=Math.quatRotation(s.orientation)
    else s.relativeRotation=Math.eye(3) end
    s.worldRotation=Math.mul(s.attachmentRotation,s.relativeRotation,3,3,3)
end
function M.geometry(graph,state,input)
    for _,n in ipairs(graph.order) do
        local s=state.components[n.name]; pose(n,state,Math.zero(6),0,input)
        if n.parent then
            s.spatialTransform=Mass.spatialTransform(n,state)
            s.totalVelocity=Math.add(Math.mv(Math.transpose(s.spatialTransform,6,6),state.components[n.parent.name].totalVelocity,6),s.velocity)
        else s.totalVelocity=Math.copy(s.velocity) end
        s.momentum=Math.mv(n.massMatrix,s.totalVelocity,6)
    end
end
function M.commit(graph,state)
    for _,n in ipairs(graph.order) do
        local s=state.components[n.name]
        s.saved={translation=Math.copy(s.translation),orientation=Math.copy(s.orientation),
            attachmentRotation=Math.copy(s.attachmentRotation),worldRotation=Math.copy(s.worldRotation),
            velocity=Math.copy(s.velocity),momentum=Math.mv(n.massMatrix,s.totalVelocity,6),force=Math.copy(s.force)}
    end
end
local function advance(graph,state,h,correct,input)
    for _,n in ipairs(graph.order) do
        local s=state.components[n.name]; local old=s.saved
        local v=correct and Math.add(old.velocity,s.velocity) or old.velocity
        local currentForce=correct and Math.copy(s.force) or nil
        pose(n,state,v,h,input)
        local p=Math.add(old.momentum,Math.scale(old.force,h))
        local a=Math.mul(Math.transpose(s.attachmentRotation,3,3),old.attachmentRotation,3,3,3)
        local b=Math.mul(Math.transpose(s.worldRotation,3,3),old.worldRotation,3,3,3)
        s.momentum=Math.join(Math.mv(a,Math.slice(p,1,3),3),Math.mv(b,Math.slice(p,4,3),3))
        if correct then s.momentum=Math.add(s.momentum,Math.scale(currentForce,h)) end
    end
    Constraints.solve(graph,state)
end
function M.step(graph,state,evaluate,input,contacts)
    advance(graph,state,M.dt,false,input)
    evaluate("predictor",input,contacts)
    advance(graph,state,M.halfDt,true,input)
    evaluate("corrector",input,contacts)
    M.commit(graph,state); state.tick=state.tick+1
end
return M
