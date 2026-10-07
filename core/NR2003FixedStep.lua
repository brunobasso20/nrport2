-- Scheduling uses 1/288 wall seconds; equations use the recovered float32 dt.
-- Backlog is retained and exposed. Rendering never changes the simulation step.
local Math=require(script and script.Parent.NR2003Math or "NR2003Math")
local M={}; M.__index=M
function M.new(solver,maxSteps)
    maxSteps=maxSteps or 96
    assert(maxSteps>=1 and maxSteps%1==0,"Invalid maxSteps")
    return setmetatable({solver=solver,accumulator=0,wallStep=1/288,maxSteps=maxSteps},M)
end
function M:advance(elapsed,inputProvider,contactProvider)
    assert(Math.finite(elapsed) and elapsed>=0,"Invalid elapsed time")
    self.accumulator=self.accumulator+elapsed
    local count=0
    while self.accumulator+1e-12>=self.wallStep and count<self.maxSteps do
        local tick=self.solver.state.tick
        local input=type(inputProvider)=="function" and inputProvider(tick,self.solver) or inputProvider
        local contacts=type(contactProvider)=="function" and contactProvider(tick,self.solver) or contactProvider
        self.solver:step(input,contacts)
        self.accumulator=self.accumulator-self.wallStep; count=count+1
    end
    if math.abs(self.accumulator)<1e-12 then self.accumulator=0 end
    return count,self.accumulator/self.wallStep
end
function M:checkpoint() return {accumulator=self.accumulator,solver=self.solver:checkpoint()} end
function M:restore(c)
    assert(Math.finite(c.accumulator) and c.accumulator>=0,"Invalid backlog")
    self.solver:restore(c.solver); self.accumulator=c.accumulator
end
return M
