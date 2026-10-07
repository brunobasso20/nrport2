local Math=require(script and script.Parent.NR2003Math or "NR2003Math")
local M={}
function M.new(graph)
    local state={tick=0,components={}}
    for _,n in ipairs(graph.nodes) do
        state.components[n.name]={translation={0,0,0},orientation={0,0,0,1},velocity=Math.zero(6),
            totalVelocity=Math.zero(6),force=Math.zero(6),momentum=Math.zero(6),
            compositeInertia=Math.copy(n.massMatrix),relativeRotation=Math.eye(3),
            attachmentRotation=Math.eye(3),worldRotation=Math.eye(3),worldPosition={0,0,0}}
    end
    return state
end
function M.pack(state,layout)
    local a={} for _,e in ipairs(layout.entries) do a[e.index]=state.components[e.component][e.field][e.axis] end return a
end
function M.unpack(state,layout,flat)
    Math.vector(flat,layout.count,"state")
    for _,e in ipairs(layout.entries) do state.components[e.component][e.field][e.axis]=Math.f(flat[e.index]) end
end
function M.clone(value)
    if type(value)~="table" then return value end
    local result={} for k,v in pairs(value) do result[k]=M.clone(v) end return result
end
return M
