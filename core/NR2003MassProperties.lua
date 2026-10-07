local Math=require(script and script.Parent.NR2003Math or "NR2003Math")
local M={}
-- 005b32e0. X maps a child wrench to its parent; transpose(X) maps velocity down.
function M.spatialTransform(n,state)
    local s=state.components[n.name]; local p=state.components[n.parent.name]
    local r=Math.add(Math.mv(n.baseRotation,s.translation,3),n.offset)
    local a=Math.mul(p.relativeRotation,n.baseRotation,3,3,3)
    local b=Math.mul(Math.skew(r),n.baseRotation,3,3,3)
    local d=Math.mul(n.baseRotation,s.relativeRotation,3,3,3)
    local x=Math.zero(36)
    for i=1,3 do for j=1,3 do
        x[(i-1)*6+j]=a[(i-1)*3+j]
        x[(i+2)*6+j]=b[(i-1)*3+j]
        x[(i+2)*6+j+3]=d[(i-1)*3+j]
    end end
    return x
end
function M.worldInertia(n,s)
    local i=Math.zero(9); for k=1,3 do i[(k-1)*3+k]=n.inertia[k] end
    return Math.mul(Math.mul(s.worldRotation,i,3,3,3),Math.transpose(s.worldRotation,3,3),3,3,3)
end
return M
