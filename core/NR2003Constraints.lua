-- Recovered recursive momentum solve, 005b3180..005b3850.
local Math=require(script and script.Parent.NR2003Math or "NR2003Math")
local Mass=require(script and script.Parent.NR2003MassProperties or "NR2003MassProperties")
local f=Math.f
local M={}
-- Original selected-axis LU, without pivoting: 005b3490 + 005b36c0.
function M.solveSelected(matrix,rhs,axes)
    local lu=Math.zero(36); local result=Math.zero(6)
    local function at(i,j) return (i-1)*6+j end
    for j,axis in ipairs(axes) do
        for k,row in ipairs(axes) do
            local value=matrix[at(row,axis)]
            for h=1,math.min(k,j)-1 do value=f(value-f(lu[at(row,axes[h])]*lu[at(axes[h],axis)])) end
            lu[at(row,axis)]=value
        end
        local diagonal=lu[at(axis,axis)]
        assert(Math.finite(diagonal) and diagonal~=0,"Singular component inertia on axis "..axis)
        if j<#axes then
            local inv=f(1/diagonal)
            for k=j+1,#axes do local index=at(axes[k],axis); lu[index]=f(lu[index]*inv) end
        end
    end
    for j,row in ipairs(axes) do
        local value=rhs[row]
        for k=1,j-1 do value=f(value-f(lu[at(row,axes[k])]*result[axes[k]])) end
        result[row]=value
    end
    for j=#axes,1,-1 do
        local row=axes[j]; local value=result[row]
        for k=j+1,#axes do value=f(value-f(lu[at(row,axes[k])]*result[axes[k]])) end
        result[row]=f(f(1/lu[at(row,row)])*value)
    end
    return result
end
function M.solve(graph,state)
    local function collect(n)
        local s=state.components[n.name]
        s.force=Math.zero(6); s.compositeInertia=Math.copy(n.massMatrix)
        for _,child in ipairs(n.children) do
            collect(child)
            local c=state.components[child.name]
            c.spatialTransform=Mass.spatialTransform(child,state)
            local b=Math.mul(c.spatialTransform,Math.mul(child.constraint,c.compositeInertia,6,6,6),6,6,6)
            local passed=Math.sub(Math.mv(c.spatialTransform,Math.mv(child.constraint,c.momentum,6),6),Math.mv(b,c.velocity,6))
            s.momentum=Math.add(s.momentum,passed)
            s.compositeInertia=Math.add(s.compositeInertia,
                Math.mul(b,Math.transpose(c.spatialTransform,6,6),6,6,6))
        end
    end
    local function distribute(n,inherited)
        local s=state.components[n.name]
        if #n.free>0 then
            local selector=Math.sub(Math.eye(6),n.constraint)
            local matrix=Math.mul(selector,s.compositeInertia,6,6,6)
            local rhs=Math.sub(Math.mv(selector,s.momentum,6),Math.mv(matrix,inherited,6))
            local v=M.solveSelected(matrix,rhs,n.free)
            for _,axis in ipairs(n.free) do s.velocity[axis]=v[axis] end
            s.totalVelocity=Math.add(inherited,s.velocity)
        else s.totalVelocity=Math.copy(inherited) end
        for _,child in ipairs(n.children) do
            local c=state.components[child.name]
            distribute(child,Math.mv(Math.transpose(c.spatialTransform,6,6),s.totalVelocity,6))
        end
    end
    for _,root in ipairs(graph.roots) do collect(root); distribute(root,Math.zero(6)) end
end
return M
