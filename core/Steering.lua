-- Ackermann, steering slew and speed reduction: Roblox geometry adapter.
local U=require(script and script.Parent.MathUtil or "core.MathUtil")
local M={}
function M.step(current,command,speed,p,wheelbase,track,dt)
    local fraction=math.max(p.minimumFraction,1/(1+math.abs(speed)*p.speedReduction))
    local target=U.clamp(command,-1,1)*p.maximum*fraction
    local angle=U.approach(current,target,(command==0 and p.returnRate or p.rate)*dt)
    if math.abs(angle)<0.00001 then return angle,p.toe,-p.toe end
    local radius=wheelbase/math.tan(math.abs(angle))
    local inner=math.atan(wheelbase/math.max(0.1,radius-track*0.5))
    local outer=math.atan(wheelbase/(radius+track*0.5))
    inner=math.abs(angle)+(inner-math.abs(angle))*p.ackermann
    outer=math.abs(angle)+(outer-math.abs(angle))*p.ackermann
    if angle>0 then return angle,outer+p.toe,inner-p.toe end
    return angle,-inner+p.toe,-outer-p.toe
end
return M
