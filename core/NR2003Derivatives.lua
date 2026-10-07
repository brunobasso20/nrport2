-- The original step solves momentum/velocity twice. No independent continuous
-- acceleration callback has been identified. Do not label a finite difference f(t,y).
local Math=require(script and script.Parent.NR2003Math or "NR2003Math")
local M={}
function M.coordinateRates(graph,state,layout)
    local result={}
    for _,e in ipairs(layout.entries) do
        local n=graph.byName[e.component]; local s=state.components[e.component]
        if e.field=="translation" then result[e.index]=s.velocity[e.axis]
        elseif e.field=="orientation" then
            if n.quaternion then
                local dq=Math.quatMultiply(s.orientation,Math.join(Math.scale(Math.slice(s.velocity,4,3),0.5),{0}))
                result[e.index]=dq[e.axis]
            else local axis=n.prescribed>=4 and n.prescribed-3 or n.rotationAxis
                result[e.index]=s.velocity[axis+3]
            end
        end
    end
    return {kind="coordinate_rates",values=result,velocityRates="resolved by momentum step"}
end
function M.stepAverage(before,after,dt)
    local a={} for i=1,#before do a[i]=Math.f((after[i]-before[i])/dt) end
    return {kind="step_average",values=a,dt=dt,orientationDifferenceIsWrapped=false}
end
return M
