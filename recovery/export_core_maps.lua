package.path="./?.lua;./core/?.lua;"..package.path
local solver=require("NR2003VehicleSolver").new()
local out=assert(io.open("recovery/vehicle_core/state_layout.csv","w"))
out:write("lua_index,c_index,component,field,axis,semantic,current_pointer_offset,storage\n")
for _,e in ipairs(solver.layout.entries) do out:write(string.format("%d,%d,%s,%s,%d,%s,0x%x,%s\n",e.index,e.cIndex,e.component,e.field,e.axis,e.semantic,e.sourcePointerOffset,e.storage)) end
out:close();out=assert(io.open("recovery/vehicle_core/components.csv","w"))
out:write("order,name,parent,flags,mass_kg,Ix_kg_m2,Iy_kg_m2,Iz_kg_m2,x_m,y_m,z_m,state_start,state_count,free_axes,prescribed_code\n")
for order,n in ipairs(solver.graph.order) do
    local entries=solver.layout.byComponent[n.name]
    out:write(string.format('%d,%s,%s,0x%x,%.10g,%.10g,%.10g,%.10g,%.10g,%.10g,%.10g,%s,%d,"%s",%d\n',order,n.name,n.parentName,n.flags,n.mass,
        n.inertia[1],n.inertia[2],n.inertia[3],n.offset[1],n.offset[2],n.offset[3],entries[1] and tostring(entries[1].index) or "",#entries,table.concat(n.free," "),n.prescribed))
end
out:close();print("Exported 45 state entries and 16 components")
