-- Client-only presentation layer for the server-authoritative NR2003_CORE vehicle.
-- It locally overrides the already replicated anchored car immediately before camera/render.
-- No rendered state is sent back to the server or consumed by physics.
local RunService=game:GetService("RunService")
local Snap=require(script.Parent.RenderSnapshot)
local Buffer=require(script.Parent.SnapshotBuffer)
local Visual=require(script.Parent.VisualRig)
local Cockpit=require(script.Parent.Cockpit)
local Config=require(script.Parent.RenderConfig)
local M={};M.__index=M
local function cframeFromSnapshot(s)
    local r00,r01,r02,r10,r11,r12,r20,r21,r22=Snap.quatToMatrix(s.qx,s.qy,s.qz,s.qw)
    return CFrame.new(s.px,s.py,s.pz,r00,r01,r02,r10,r11,r12,r20,r21,r22)
end
function M.new(car,tune,remote)
    local self=setmetatable({car=car,tune=tune,remote=remote,buffer=Buffer.new(Config.buffer),sampled={wheels={}},
        visual=Visual.new(car,tune),dynamics={wheels={}},contacts={},active=false,frames=0,fps=0,fpsClock=os.clock()},M)
    for j=1,4 do self.dynamics.wheels[j]={compression=0,steer=0,angle=0};self.contacts[j]={point=Vector3.zero,grounded=false} end
    self.connection=remote.OnClientEvent:Connect(function(packet)
        local s=Snap.decode(packet);if not s or s.vehicleId~=Config.vehicleId then return end
        self.buffer:push(s,workspace:GetServerTimeNow())
    end)
    return self
end
function M:update()
    self.frames=self.frames+1;local clock=os.clock();local span=clock-self.fpsClock
    if span>=0.5 then self.fps=self.frames/span;self.frames=0;self.fpsClock=clock end
    if not Config.enabled or self.car:GetAttribute("NR2003CorePoseOwner")~=true then self.active=false;return false end
    local now=workspace:GetServerTimeNow()
    if self.buffer:isStale(now) then self.active=false;return false end
    local renderTime=self.buffer:advance(now);if not renderTime then self.active=false;return false end
    local s=self.buffer:sample(renderTime,self.sampled);if not s then self.active=false;return false end
    local cf=cframeFromSnapshot(s)
    self.car:PivotTo(cf)
    for j,w in ipairs(s.wheels) do
        local d=self.dynamics.wheels[j];d.compression,d.steer,d.angle=w.comp,w.steer,w.spin
        local c=self.contacts[j];c.point=cf:PointToWorldSpace(Vector3.new(w.cx,w.cy,w.cz));c.grounded=w.grounded
    end
    self.dynamics.steering=s.steer
    self.visual:update(self.dynamics,self.contacts,self.car:GetAttribute("DebugContacts")==true)
    Cockpit.update(self.car,self.tune,s.steer)
    self.active=true;return true
end
function M:stats()
    local s=self.buffer:stats();s.renderFPS=self.fps;s.active=self.active;s.mode=self.sampled.mode or "waiting";s.alpha=self.sampled.alpha or 0
    return s
end
function M:destroy() if self.connection then self.connection:Disconnect();self.connection=nil end end
return M
