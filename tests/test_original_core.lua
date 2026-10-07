package.path="./?.lua;./core/?.lua;"..package.path
local Solver=require("NR2003VehicleSolver")
local Projection=require("NR2003DrivetrainProjection")
local Math=require("NR2003Math")
local reference=dofile("tests/fixtures/original_x86.lua")
local checks,maxError=0,0
local function compare(actual,expected,label,tolerance)
    checks=checks+1; local error=math.abs(actual-expected);maxError=math.max(maxError,error)
    assert(error <= (tolerance or math.max(3e-7,math.abs(expected)*2e-5)),
        string.format("%s: %.12g vs %.12g (error %.12g)",label,actual,expected,error))
end
for _,case in ipairs(reference.cases) do
    local solver=Solver.new({records=case.records,forces=function(core,acc,input,contacts,stage)
        local tick=core.state.tick
        if stage~="initial" then
            for name,fields in pairs(case.steps[tick+1][stage]) do
                local actual=core.state.components[name]
                for field,values in pairs(fields) do for i,value in ipairs(values) do
                    compare(actual[field][i],value,case.name.."/"..tick.."/"..stage.."/"..name.."/"..field.."/"..i)
                end end
            end
        end
        local multiplier=stage=="initial" and 1 or (stage=="predictor" and 1+.1*tick or 1+.2*tick)
        for name,force in pairs(case.forces) do acc:localWrench(name,Math.scale(force,multiplier)) end
    end})
    for _=1,4 do solver:step() end
end
for case,c in ipairs(reference.drivetrain) do
    local actual=Projection.matrix(c.parameters)
    for i,v in ipairs(c.matrix) do compare(actual[i],v,"drivetrain/"..case.."/"..i,3e-7) end
end
print(string.format("PASS: %d original-x86 intermediate comparisons; max absolute error %.9g",checks,maxError))
