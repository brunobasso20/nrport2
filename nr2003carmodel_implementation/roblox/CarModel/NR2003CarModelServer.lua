-- NR2003CarModelServer: sends the ORIGINAL draw record of the Cup core (NR2003DrawState.sample, read-only cells) to the
-- clients with the same sequence number and server time as the render snapshot (presentation only; nothing returns).
local DrawState=require(script.Parent.NR2003DrawState)
local M={};M.__index=M
function M.new(controller,package)
    local remote=package:FindFirstChild("DrawState")
    if remote==nil then
        remote=Instance.new("UnreliableRemoteEvent");remote.Name="DrawState";remote.Parent=package
    end
    return setmetatable({controller=controller,remote=remote,s={},scratch={}},M)
end
function M:send(seq,time)
    local core=self.controller and self.controller.core
    if not core then return false end
    local s=DrawState.sample(core,self.s,self.scratch)
    if not s then return false end
    self.remote:FireAllClients(DrawState.encode(seq,time,s))
    return true
end
return M
