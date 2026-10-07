-- 005b29c0/005b2d00: physical hierarchy, masks and constant mass matrices.
local Math=require(script and script.Parent.NR2003Math or "NR2003Math")
local Data=require(script and script.Parent.RecoveredData or "RecoveredData")
local Rotation=require(script and script.Parent.RotationMatrix or "RotationMatrix")
local M={}
local function bit(flags,n) return math.floor(flags/2^n)%2==1 end
function M.new(records,overrides)
    local graph={nodes={},byName={},roots={},order={}}
    for _,r in ipairs(records or Data.components) do
        assert(not graph.byName[r.name],"Duplicate component: "..r.name)
        local raw=r.rawFieldsF32 or {}; local flags=r.flags or 0
        local function value(key) return raw[key] or 0 end
        local n={name=r.name,parentName=r.parentName or "inertial",flags=flags,children={},free={},
            offset=r.offset or {value("0x44"),value("0x48"),value("0x4c")},
            mass=math.abs(r.mass or value("0x5d")),
            inertia=r.inertia or {math.abs(value("0x61")),math.abs(value("0x65")),math.abs(value("0x69"))}}
        local angles=r.angles or {Math.f(value("0x51")*Data.angleScale),Math.f(value("0x55")*Data.angleScale),Math.f(value("0x59")*Data.angleScale)}
        n.baseRotation=Rotation.fromAngles(angles[1],angles[2],angles[3])
        n.rotationAxis=math.floor(flags/8)%4
        n.quaternion=n.rotationAxis==0 and bit(flags,5)
        n.axisymmetric=bit(flags,6)
        n.prescribed=math.floor(flags/128)%8
        assert(n.prescribed<=6,"Unknown prescribed coordinate code")
        for axis=1,3 do if bit(flags,axis-1) then n.free[#n.free+1]=axis end end
        if n.rotationAxis>0 then n.free[#n.free+1]=n.rotationAxis+3
        elseif n.quaternion then for axis=4,6 do n.free[#n.free+1]=axis end end
        n.constraint=Math.eye(6)
        for _,axis in ipairs(n.free) do n.constraint[(axis-1)*6+axis]=0 end
        local change=overrides and overrides[n.name]
        if change then n.mass=change.mass or n.mass; n.inertia=change.inertia or n.inertia end
        assert(Math.finite(n.mass) and n.mass>=0,"Invalid mass")
        Math.vector(n.inertia,3,"inertia"); Math.vector(n.offset,3,"offset")
        n.mass=Math.f(n.mass); n.inertia=Math.scale(n.inertia,1); n.offset=Math.scale(n.offset,1)
        n.massMatrix=Math.zero(36)
        for axis=1,6 do
            local v=axis<=3 and n.mass or n.inertia[axis-3]
            assert(v>=0,"Negative inertia"); n.massMatrix[(axis-1)*6+axis]=v
        end
        graph.nodes[#graph.nodes+1]=n; graph.byName[n.name]=n
    end
    for _,n in ipairs(graph.nodes) do
        n.parent=graph.byName[n.parentName]
        assert(n.parent or n.parentName=="inertial","Unknown parent: "..n.parentName)
        local list=n.parent and n.parent.children or graph.roots; list[#list+1]=n
        local seen={}; local p=n
        while p do assert(not seen[p],"Component cycle"); seen[p]=true; p=graph.byName[p.parentName] end
    end
    local function visit(n) graph.order[#graph.order+1]=n for _,c in ipairs(n.children) do visit(c) end end
    for _,r in ipairs(graph.roots) do visit(r) end
    return graph
end
return M
