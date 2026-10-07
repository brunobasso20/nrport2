-- Contact queries belong to the host. Everything here is plain numeric SI data.
local Math=require(script and script.Parent.NR2003Math or "NR2003Math")
local Tire=require(script and script.Parent.TireForces or "core.TireForces")
local M={}
function M.validate(c)
    assert(type(c)=="table" and type(c.hit)=="boolean","Contact requires hit boolean")
    if not c.hit then return c end
    for _,key in ipairs({"position","normal","forward","left","groundVelocity"}) do Math.vector(c[key],3,key) end
    for _,key in ipairs({"normal","forward","left"}) do
        assert(math.abs(Math.dot(c[key],c[key])-1)<1e-4,"Contact basis must be normalized")
    end
    assert(math.abs(Math.dot(c.normal,c.forward))<1e-4 and math.abs(Math.dot(c.normal,c.left))<1e-4
        and math.abs(Math.dot(c.left,c.forward))<1e-4,"Contact basis must be orthogonal")
    assert(Math.dot(Math.cross(c.forward,c.left),c.normal)>0.999,"Contact basis must be right handed")
    return c
end
function M.applyOutput(accumulator,name,contact,output)
    M.validate(contact); if not contact.hit then return end
    local force=Math.add(Math.add(Math.scale(contact.forward,output.longitudinal or 0),
        Math.scale(contact.left,output.lateral or 0)),Math.scale(contact.normal,output.normal or 0))
    local moment=output.aligningMoment or 0
    local torque=Math.scale(contact.normal,moment)
    -- Output rollingTorque must already have the signed wheel-axis convention.
    if output.rollingTorque then torque=Math.add(torque,Math.scale(contact.left,output.rollingTorque)) end
    accumulator:worldWrench(name,force,torque,contact.position)
    accumulator.aligningMoments[name]=moment
end
function M.evaluate(accumulator,name,contact,tireState,parameters,sample)
    assert(parameters and sample,"Explicit recovered tire parameters/sample required")
    M.validate(contact); if not contact.hit then return nil end
    local output=Tire.evaluate(tireState,parameters,sample)
    -- TireForces returns a resistance magnitude. Resolve its sign at this boundary.
    output.rollingTorque=-(sample.treadSpeed>0 and 1 or sample.treadSpeed<0 and -1 or 0)*(output.rollingTorque or 0)
    M.applyOutput(accumulator,name,contact,output)
    return output
end
return M
