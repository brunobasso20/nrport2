-- Pure Lua/Luau. SI: metres, seconds, kg, N, Nm; original +X forward +Y left +Z up.
local Components=require(script and script.Parent.NR2003Components or "NR2003Components")
local Layout=require(script and script.Parent.NR2003StateLayout or "NR2003StateLayout")
local State=require(script and script.Parent.NR2003VehicleState or "NR2003VehicleState")
local Integrator=require(script and script.Parent.NR2003Integrator or "NR2003Integrator")
local Accumulator=require(script and script.Parent.NR2003ForceAccumulator or "NR2003ForceAccumulator")
local Derivatives=require(script and script.Parent.NR2003Derivatives or "NR2003Derivatives")
local Math=require(script and script.Parent.NR2003Math or "NR2003Math")
local M={}; M.__index=M
function M.new(options)
    options=options or {}
    local graph=Components.new(options.records,options.massOverrides)
    local self=setmetatable({graph=graph,layout=Layout.new(graph),state=State.new(graph),
        gravity=options.gravity or {0,0,0},forceProvider=options.forces,
        captureIntermediate=options.captureIntermediate,telemetry={},dt=Integrator.dt,
        drivetrain=options.drivetrain},M)
    if options.state then State.unpack(self.state,self.layout,options.state) end
    Integrator.geometry(graph,self.state,options.input)
    self:evaluate("initial",options.input or {},options.contacts or {})
    Integrator.commit(graph,self.state)
    return self
end
function M:evaluate(stage,input,contacts)
    for _,n in ipairs(self.graph.order) do self.state.components[n.name].force=Math.zero(6) end
    local accumulator=Accumulator.new(self.graph,self.state)
    if self.drivetrain then self.drivetrain(self,accumulator,input,stage) end
    accumulator:gravity(self.gravity)
    if self.forceProvider then self.forceProvider(self,accumulator,input,contacts,stage) end
    for _,n in ipairs(self.graph.order) do Math.vector(self.state.components[n.name].force,6,"force "..n.name) end
    self.aligningMoments=accumulator.aligningMoments
    if self.captureIntermediate then
        self.telemetry[stage]={tick=self.state.tick,components=State.clone(self.state.components)}
    end
end
function M:pack() return State.pack(self.state,self.layout) end
function M:step(input,contacts)
    input=input or {}; contacts=contacts or {}
    local before=self:pack()
    Integrator.step(self.graph,self.state,function(...) self:evaluate(...) end,input,contacts)
    local after=self:pack(); Math.vector(after,self.layout.count,"advanced state")
    self.derivatives={coordinates=Derivatives.coordinateRates(self.graph,self.state,self.layout),
        discrete=Derivatives.stepAverage(before,after,self.dt)}
    return after
end
function M:checkpoint()
    -- Save derived frames and previous force too: recomputing them introduces extra
    -- float32 rounding. Stateful external providers must checkpoint their own data.
    return {version=1,layoutCount=self.layout.count,state=State.clone(self.state)}
end
function M:restore(checkpoint)
    assert(checkpoint.version==1 and checkpoint.layoutCount==self.layout.count,"Checkpoint layout mismatch")
    local s=State.clone(checkpoint.state)
    Math.vector(State.pack(s,self.layout),self.layout.count,"checkpoint state")
    self.state=s; self.telemetry={}; self.derivatives=nil
end
return M
