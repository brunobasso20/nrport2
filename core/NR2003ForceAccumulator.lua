-- Numeric force interface. Linear wrench is in attachment axes; torque in body axes.
local Math=require(script and script.Parent.NR2003Math or "NR2003Math")
local Mass=require(script and script.Parent.NR2003MassProperties or "NR2003MassProperties")
local M={}; M.__index=M
function M.new(graph,state) return setmetatable({graph=graph,state=state,aligningMoments={}},M) end
function M:localWrench(name,wrench)
    Math.vector(wrench,6,"wrench")
    local s=assert(self.state.components[name],"Unknown component "..tostring(name))
    s.force=Math.add(s.force,wrench)
end
function M:worldWrench(name,force,torque,position)
    local s=assert(self.state.components[name],"Unknown force target")
    Math.vector(force,3,"force"); torque=torque or {0,0,0}; Math.vector(torque,3,"torque")
    if position then Math.vector(position,3,"position"); torque=Math.add(torque,Math.cross(Math.sub(position,s.worldPosition),force)) end
    local linear=Math.mv(Math.transpose(s.attachmentRotation,3,3),force,3)
    local angular=Math.mv(Math.transpose(s.worldRotation,3,3),torque,3)
    self:localWrench(name,Math.join(linear,angular))
end
function M:gravity(acceleration)
    Math.vector(acceleration,3,"gravity")
    for _,n in ipairs(self.graph.nodes) do
        if n.mass~=0 then self:worldWrench(n.name,Math.scale(acceleration,n.mass)) end
    end
end
-- Equal/opposite internal joint force, using the recovered spatial transform.
function M:childReaction(name,wrench)
    local n=assert(self.graph.byName[name]); self:localWrench(name,wrench)
    if n.parent then
        local x=Mass.spatialTransform(n,self.state)
        self:localWrench(n.parent.name,Math.scale(Math.mv(x,wrench,6),-1))
    end
end
function M:jointTorque(name,axis,torque)
    assert(axis>=1 and axis<=3 and axis%1==0,"Invalid torque axis")
    local w=Math.zero(6); w[axis+3]=torque; self:childReaction(name,w)
end
function M:forcePair(a,b,worldForce,position)
    self:worldWrench(a,worldForce,nil,position)
    self:worldWrench(b,Math.scale(worldForce,-1),nil,position)
end
return M
