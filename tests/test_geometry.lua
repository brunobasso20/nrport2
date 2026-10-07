-- Minimal geometric Roblox API double: executes the REAL generator and raycasts.
-- This does not emulate the Roblox physics engine or certify Studio Play behavior.
package.path="./?.lua;./core/?.lua;"..package.path
local V={}; local VM={}
function V.new(x,y,z) return setmetatable({X=x or 0,Y=y or 0,Z=z or 0},VM) end
function VM.__add(a,b) return V.new(a.X+b.X,a.Y+b.Y,a.Z+b.Z) end
function VM.__sub(a,b) return V.new(a.X-b.X,a.Y-b.Y,a.Z-b.Z) end
function VM.__unm(a) return V.new(-a.X,-a.Y,-a.Z) end
function VM.__mul(a,b)
    if type(a)=="number" then a,b=b,a end
    return V.new(a.X*b,a.Y*b,a.Z*b)
end
function VM.__div(a,b) return a*(1/b) end
function VM.__index(a,k)
    if k=="Magnitude" then return math.sqrt(a.X*a.X+a.Y*a.Y+a.Z*a.Z) end
    if k=="Unit" then return a/a.Magnitude end
    return V[k]
end
function V:Dot(b) return self.X*b.X+self.Y*b.Y+self.Z*b.Z end
function V:Cross(b) return V.new(self.Y*b.Z-self.Z*b.Y,self.Z*b.X-self.X*b.Z,self.X*b.Y-self.Y*b.X) end
V.zero=V.new(); Vector3=V
local CF={}; local CM={}
local function matrix(p,r,u,b) return setmetatable({p=p,r=r,u=u,b=b},CM) end
function CF.new(x,y,z,...)
    local r={...}
    if #r==9 then return matrix(V.new(x,y,z),V.new(r[1],r[4],r[7]),V.new(r[2],r[5],r[8]),V.new(r[3],r[6],r[9])) end
    return matrix(type(x)=="table" and x or V.new(x,y,z),V.new(1,0,0),V.new(0,1,0),V.new(0,0,1))
end
function CF:VectorToWorldSpace(v) return self.r*v.X+self.u*v.Y+self.b*v.Z end
function CF:VectorToObjectSpace(v) return V.new(v:Dot(self.r),v:Dot(self.u),v:Dot(self.b)) end
function CF:PointToObjectSpace(v) return self:VectorToObjectSpace(v-self.p) end
function CF:PointToWorldSpace(v) return self.p+self:VectorToWorldSpace(v) end
function CF:GetComponents()
    return self.p.X,self.p.Y,self.p.Z,self.r.X,self.u.X,self.b.X,self.r.Y,self.u.Y,self.b.Y,self.r.Z,self.u.Z,self.b.Z
end
function CF:ToObjectSpace(b)
    return matrix(self:PointToObjectSpace(b.p),self:VectorToObjectSpace(b.r),self:VectorToObjectSpace(b.u),self:VectorToObjectSpace(b.b))
end
function CM.__mul(a,b)
    if getmetatable(b)==VM then return a.p+a:VectorToWorldSpace(b) end
    return matrix(a*b.p,a:VectorToWorldSpace(b.r),a:VectorToWorldSpace(b.u),a:VectorToWorldSpace(b.b))
end
function CM.__index(a,k)
    if k=="Position" then return a.p elseif k=="RightVector" then return a.r
    elseif k=="UpVector" then return a.u elseif k=="LookVector" then return -a.b end
    return CF[k]
end
function CF.Angles(x,y,z)
    local sx,cx,sy,cy,sz,cz=math.sin(x),math.cos(x),math.sin(y),math.cos(y),math.sin(z),math.cos(z)
    local rx=matrix(V.zero,V.new(1,0,0),V.new(0,cx,sx),V.new(0,-sx,cx))
    local ry=matrix(V.zero,V.new(cy,0,-sy),V.new(0,1,0),V.new(sy,0,cy))
    local rz=matrix(V.zero,V.new(cz,sz,0),V.new(-sz,cz,0),V.new(0,0,1))
    return rx*ry*rz
end
function CF.lookAt(a,b)
    local look=(b-a).Unit; local right=look:Cross(V.new(0,1,0))
    if right.Magnitude<1e-8 then right=V.new(1,0,0) else right=right.Unit end
    return matrix(a,right,right:Cross(look),-look)
end
CFrame=CF
Color3={fromRGB=function(...) return {...} end}; ColorSequence={new=function(x)return x end}
Enum=setmetatable({}, {__index=function(t,k)
    local v=setmetatable({}, {__index=function(q,n)local x={Name=n};rawset(q,n,x);return x end});rawset(t,k,v);return v
end})
PhysicalProperties={new=function(d,...) return {Density=d} end}
RaycastParams={new=function() return {} end}
local I={}; local IM={}
local bases={Part=true,VehicleSeat=true,MeshPart=true,SpawnLocation=true}
local joints={Weld=true,Motor6D=true}
function I.new(class)
    return setmetatable({_p={ClassName=class,Name=class,CFrame=CF.new(),Size=V.new(1,1,1),Axis=V.new(1,0,0)},_c={},_a={}},IM)
end
function IM.__index(o,k)
    if I[k] then return I[k] end
    if k=="Position" then return o.CFrame.Position end
    if k=="WorldPosition" then return (o.Parent.CFrame*o.CFrame).Position end
    if k=="WorldAxis" then return (o.Parent.CFrame*o.CFrame).RightVector end
    if k=="AssemblyMass" then return o.Size.X*o.Size.Y*o.Size.Z*o.CustomPhysicalProperties.Density end
    if o._p[k]~=nil then return o._p[k] end
    for _,v in ipairs(o._c) do if v.Name==k then return v end end
end
function IM.__newindex(o,k,v)
    if k=="Parent" then
        local old=o._p.Parent
        if old then for j,c in ipairs(old._c) do if c==o then table.remove(old._c,j);break end end end
        if v then table.insert(v._c,o) end
    elseif k=="Position" then o._p.CFrame=matrix(v,o.CFrame.r,o.CFrame.u,o.CFrame.b); return end
    o._p[k]=v
end
function I:IsA(class) return self.ClassName==class or (class=="BasePart" and bases[self.ClassName]) or (class=="JointInstance" and joints[self.ClassName]) or false end
function I:SetAttribute(k,v) self._a[k]=v end
function I:GetAttribute(k) return self._a[k] end
function I:GetChildren() return self._c end
function I:GetDescendants()
    local result={};local function walk(p) for _,c in ipairs(p._c) do table.insert(result,c);walk(c) end end
    walk(self);return result
end
function I:FindFirstChild(n) for _,c in ipairs(self._c) do if c.Name==n then return c end end end
function I:GetFullName() return (self.Parent and self.Parent:GetFullName().."." or "")..self.Name end
function I:GetVelocityAtPosition() return V.zero end
function I:GetPivot() return self.PrimaryPart.CFrame end
Instance=I; warn=print
workspace=I.new("Workspace")
local ground=I.new("Part");ground.Name="Plane";ground.Material=Enum.Material.Asphalt
function workspace:Raycast(origin,direction)
    if direction.Y>=0 then return nil end
    local u=-origin.Y/direction.Y
    if u<0 or u>1 then return nil end
    return {Position=origin+direction*u,Normal=V.new(0,1,0),Distance=direction.Magnitude*u,
        Instance=ground,Material=Enum.Material.Asphalt}
end
local packageRoot={Core={},Roblox={}};packageRoot.Core.Parent=packageRoot;packageRoot.Roblox.Parent=packageRoot
local cache={}
local function mockRequire(m)
    if type(m)=="string" then return require(m) end
    if cache[m] then return cache[m] end
    local env=setmetatable({script=m,require=mockRequire},{__index=_G})
    local result=assert(loadfile(m.path,"t",env))();cache[m]=result;return result
end
for _,name in ipairs({"TestTune","VehicleDynamics","Surface"}) do packageRoot.Core[name]={path="core/"..name..".lua",Parent=packageRoot.Core} end
-- Core modules load via their pure Lua paths so no unrelated mocking is needed.
for name,m in pairs(packageRoot.Core) do if type(m)=="table" and m.path then cache[m]=require("core."..name) end end
for _,name in ipairs({"CarBuilder","RaycastContacts","VisualRig","Diagnostics","Cockpit","DriverConfig"}) do
    packageRoot.Roblox[name]={path="roblox/"..name..".lua",Parent=packageRoot.Roblox}
end
local tune=require("core.TestTune").new()
local builder=mockRequire(packageRoot.Roblox.CarBuilder)
local car=builder.create(workspace,builder.spawnCFrame(tune),tune)
local dynamics=require("core.VehicleDynamics").new(tune)
local contacts=mockRequire(packageRoot.Roblox.RaycastContacts).new(car,tune):sample(dynamics)
for j,c in ipairs(contacts) do
    assert(c.grounded,"initial contact missing "..j)
    assert(math.abs(c.compression-(tune.initialCompression-.03))<1e-6,"wheel radius/axis geometry")
    assert(c.forward:Dot(V.new(0,0,-1))>.999,"car forward convention")
    assert(c.right:Dot(V.new(1,0,0))>.999,"contact lateral convention")
    dynamics.wheels[j].compression=c.compression
end
mockRequire(packageRoot.Roblox.VisualRig).new(car,tune):update(dynamics,contacts,true)
local report=mockRequire(packageRoot.Roblox.Diagnostics).run(car,tune)
assert(report.ok and report.parts==report.connectedParts,"generator connectivity")
local fl=car.Wheels.FL.Hub.SuspensionMotor.C0
local fr=car.Wheels.FR.Hub.SuspensionMotor.C0
assert(fl.Position.X<0 and fr.Position.X>0,"left/right placement")
assert(car.Wheels.FL.Wheel.Size.X<car.Wheels.FL.Wheel.Size.Y,"cylinder axle X")
print("PASS: generated geometry, four raycast contacts, handedness, coil update and joint connectivity")
assert(car.DriverSeat:FindFirstChild("DriverSeatMount") and not car.DriverSeat:FindFirstChild("SeatWeld"),"seat mount name")
local cockpit=mockRequire(packageRoot.Roblox.Cockpit)
local wheel=car.Cockpit.SteeringPivot;local base=wheel:GetAttribute("NeutralCFrame")
cockpit.update(car,tune,.1)
assert((wheel.SteeringMotor.C0.UpVector-(base*CFrame.Angles(0,0,-1.2)).UpVector).Magnitude<1e-6,"steering wheel angle")
assert(car.DriverSeat.CockpitCamera and wheel.SteeringAxis,"cockpit fixtures")
return {car=car,tune=tune,Instance=I,packageRoot=packageRoot,require=mockRequire}
