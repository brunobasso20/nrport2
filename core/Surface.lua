local Data=require(script and script.Parent.RecoveredData or "core.RecoveredData")
local U=require(script and script.Parent.MathUtil or "core.MathUtil")
local M={}
M.indices={Asphalt=1,Concrete=2,Brick=3,Cobblestone=3,Grass=5,LeafyGrass=5,Ground=6,Mud=6,
    Sand=7,Pebble=8,Water=9,Metal=10,Wood=16,WoodPlanks=16}
function M.grip(index,multiplier)
    local row=Data.surfaces[(index or 1)+1] or Data.surfaces[2]
    return row.base*(multiplier or 1)
end
function M.resolve(name,index,multiplier)
    if not U.finite(index) then index=nil end
    if not U.finite(multiplier) then multiplier=1 end
    multiplier=U.clamp(multiplier,0,4)
    index=math.max(0,math.min(19,math.floor(index or M.indices[name] or 0)))
    return {index=index,grip=M.grip(index,multiplier)}
end
return M
