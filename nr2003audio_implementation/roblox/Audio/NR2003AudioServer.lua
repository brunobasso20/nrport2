-- No work on the server beyond reading the core and appending one bounded tail.
local State=require(script and script.Parent.NR2003AudioState or "./NR2003AudioState")
local M={};M.__index=M
function M.new(controller,package)
    return setmetatable({controller=controller,package=package,state={wheels={}},epoch=0},M)
end
function M:encode(snapshot,packet)
    if self.package:GetAttribute("NR2003AudioEnabled")==false then return packet end
    local core=self.controller.core
    if not core then return packet end
    local car=self.controller.car
    if car and car:GetAttribute("NR2003AudioVehicleId")~=snapshot.vehicleId then
        car:SetAttribute("NR2003AudioVehicleId",snapshot.vehicleId)
    end
    if bit32.band(snapshot.flags or 0,1)~=0 or (self.lastTick and snapshot.tick<self.lastTick) then self.epoch+=1 end
    self.lastTick=snapshot.tick
    return State.append(packet,State.sample(core,self.controller,self.state),self.epoch)
end
return M
