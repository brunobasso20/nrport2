-- 005b2c40 and state copy traversal. Index is Lua 1-based; cIndex is original 0-based.
local M={}
function M.new(graph)
    local layout={entries={},byComponent={}}
    local function add(n,field,axis,semantic,offset)
        local e={index=#layout.entries+1,cIndex=#layout.entries,component=n.name,
            field=field,axis=axis,semantic=semantic,sourcePointerOffset=offset,storage="float32"}
        layout.entries[#layout.entries+1]=e
        local list=layout.byComponent[n.name]; list[#list+1]=e
    end
    for _,n in ipairs(graph.order) do
        layout.byComponent[n.name]={}
        for axis=1,3 do
            if math.floor(n.flags/2^(axis-1))%2==1 or n.prescribed==axis then
                add(n,"translation",axis,"joint_position_m",0x2cd+(axis-1)*4)
                add(n,"velocity",axis,"joint_velocity_m_s",0x385+(axis-1)*4)
            end
        end
        local axis=n.prescribed>=4 and n.prescribed-3 or n.rotationAxis
        if axis>0 then
            add(n,"orientation",1,"joint_angle_rad",0x35d)
            add(n,"velocity",axis+3,"joint_rate_rad_s",0x385+(axis+2)*4)
        elseif n.quaternion then
            for i=1,4 do add(n,"orientation",i,"quaternion_xyzw",0x35d+(i-1)*4) end
            for i=4,6 do add(n,"velocity",i,"body_rate_rad_s",0x385+(i-1)*4) end
        end
    end
    layout.count=#layout.entries
    return layout
end
return M
