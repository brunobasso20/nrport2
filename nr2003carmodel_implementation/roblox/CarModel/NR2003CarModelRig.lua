-- NR2003CarModelRig: the ORIGINAL car model (imported 3do geometry library) driven like NR2003.exe draws it.
-- Client-side presentation only: anchored, non-colliding, non-queryable parts created locally; nothing touches the
-- physics. Twin of pipeline/nr2003res/rig.py (the validation renderer uses the same rules).
--   graph      descriptor nodes (frames, switches, LODs) exported by convert_car.py from <model>.3do (damage branches
--              resolved to the undamaged car, carMakeIdx fixed at export)
--   frames     T(t) * Rz(h) Ry(p) Rx(r) (005f6f20); AnimatedTransform keys (rendserv 10012810: t < key.time bracket,
--              translation lerp, quaternion nlerp with sign flip when |q2 - q1|^2 >= 1, (x, y, z, w))
--   switches   values[i] <= v < values[i+1], nothing outside [values[1], values[n+1]] (rendserv 10011ec0)
--   LODs       first threshold >= distance to the switch centre, detail floor if below the level count (100118e0)
--   overrides  (005662d0) lf/rf wheel: z = car[0x1558+4i], rotation (steer + 1.570795, rest r, spin);
--              lr/rr wheel: rotation (rest h + 1.570795, rest r, spin); steer: (rest h, rest p, wheel angle);
--              needles: (0, rest p, gauge angle) for the focus car in every view; cockpit camera only (bit 0x01):
--              steer: (rest h, rest p, wheel angle), shifter: (rest h, car[0x1588], car[0x158c]); head: translation
--              = draw-record head, rotation (0, headPitch - body pitch, headRoll - body roll).
-- Import calibration: the OBJ carries four marker tetrahedra (origin, +4 studs X / Y / Z); whatever rigid transform or
-- uniform scale the Studio 3D Importer applied is measured from them, so each template's placement in its frame is exact.
local Scale=require(script.Parent.NR2003Scale)
local M={};M.__index=M
local HALF_PI=1.5707950592041016   -- 006f5e74
local WHEEL_INDEX={lfwheel=1,rfwheel=2,lrwheel=3,rrwheel=4}
local NEEDLE={ptach=true,poilp=true,poilt=true,pfuel=true,pwater=true,pvoltage=true}
local MARKER_CENTER=0.25*0.25      -- markerSize / 4: bounding-box centre of the marker tetrahedron

local function nlerp(q1,q2,f)
    local g=1-f
    local d=(q2[1]-q1[1])^2+(q2[2]-q1[2])^2+(q2[3]-q1[3])^2+(q2[4]-q1[4])^2
    local x,y,z,w
    if d>=1 then x,y,z,w=g*q1[1]-f*q2[1],g*q1[2]-f*q2[2],g*q1[3]-f*q2[3],g*q1[4]-f*q2[4]
    else x,y,z,w=f*q2[1]+g*q1[1],f*q2[2]+g*q1[2],f*q2[3]+g*q1[3],f*q2[4]+g*q1[4] end
    local s=1/math.sqrt(x*x+y*y+z*z+w*w)
    return x*s,y*s,z*s,w*s
end
local function quatMatrix(x,y,z,w,out)
    out[1],out[2],out[3]=2*x*x+2*w*w-1,2*x*y-2*w*z,2*x*z+2*w*y
    out[4],out[5],out[6]=2*x*y+2*w*z,2*y*y+2*w*w-1,2*y*z-2*w*x
    out[7],out[8],out[9]=2*x*z-2*w*y,2*y*z+2*w*x,2*z*z+2*w*w-1
    return out
end
-- AnimatedTransform evaluation (rendserv 10012810), keys = {{time, {x,y,z,w}, {tx,ty,tz}}, ...}
function M.animated(keys,t,R)
    local n=#keys
    local k,f=2,0
    if keys[1][1]<t then
        local found=false
        for i=2,n do
            if t<keys[i][1] then f=(t-keys[i-1][1])/(keys[i][1]-keys[i-1][1]);k=i;found=true;break end
        end
        if not found then f,k=1,n end
    end
    if k>n then k=n end
    local a,b=keys[math.max(k-1,1)],keys[k]
    local tx=(b[3][1]-a[3][1])*f+a[3][1]
    local ty=(b[3][2]-a[3][2])*f+a[3][2]
    local tz=(b[3][3]-a[3][3])*f+a[3][3]
    if f==0 then local q=a[2];quatMatrix(q[1],q[2],q[3],q[4],R)
    elseif f>=1 then local q=b[2];quatMatrix(q[1],q[2],q[3],q[4],R)
    else local x,y,z,w=nlerp(a[2],b[2],f);quatMatrix(x,y,z,w,R) end
    return tx,ty,tz
end
function M.selectState(values,v)
    local n=#values-1
    if n<1 or v~=v or v<values[1] or v>values[n+1] then return nil end
    local i=0
    for k=2,n do
        if v<values[k] then break end
        i=i+1
    end
    return i
end
-- rendserv 100118e0: first threshold >= d; the renderer's detail floor (vf +0x154) applies only when it is below the
-- level count
function M.selectLod(distances,d,floor)
    local n=#distances
    local i=0
    for k=2,n do
        if d<=distances[k] then break end
        i=i+1
    end
    if floor and floor<n and i<floor then i=floor end
    return i
end

-- import calibration from the marker parts: returns CFrame (rotation + translation) and uniform scale
function M.calibrate(assets,desc)
    local function pos(name)
        local p=assets:FindFirstChild(name,true)
        assert(p and p:IsA("BasePart"),"NR2003 car model: marker "..name.." missing in the imported model")
        return p.Position
    end
    local O,X,Y,Z=pos("NR2003_MARKER_O"),pos("NR2003_MARKER_X"),pos("NR2003_MARKER_Y"),pos("NR2003_MARKER_Z")
    local ex,ey,ez=(X-O)/4,(Y-O)/4,(Z-O)/4
    local k=ex.Magnitude
    assert(k>1e-6,"NR2003 car model: degenerate markers")
    local qx,qy,qz=ex/k,ey/k,ez/k
    local ortho=math.max(math.abs(qx:Dot(qy)),math.abs(qy:Dot(qz)),math.abs(qx:Dot(qz)),
        math.abs(ey.Magnitude/k-1),math.abs(ez.Magnitude/k-1),math.abs(qx:Cross(qy):Dot(qz)-1))
    assert(ortho<1e-3,"NR2003 car model: the importer did not apply a rigid uniform transform ("..ortho..")")
    local c=(desc.markerSize or 0.25)*0.25
    local P=O-(qx*c+qy*c+qz*c)*k
    return CFrame.fromMatrix(P,qx,qy,qz),k,ortho
end

function M.new(desc,assets,parent,options)
    options=options or {}
    local self=setmetatable({desc=desc,assets=assets,options=options,byId={},kids={},templates={},offsets={},sizes={},
        instParts={},instActive={},frameCF={},R={},L={},nodeLocal={},parts={},cframes={},stats={}},M)
    for _,n in ipairs(desc.nodes) do
        self.byId[n.id]=n
        if n.parent~=nil then
            local l=self.kids[n.parent];if not l then l={};self.kids[n.parent]=l end
            table.insert(l,n)
        end
        if (n.kind=="frame" or n.kind=="billboard") and not n.keys then
            local t=n.t or n.pivot or {0,0,0}
            local h=n.hpr or {0,0,0}
            n._static=Scale.cframe(t[1],t[2],t[3],Scale.euler(h[1],h[2],h[3]))
        end
    end
    self.instByNode={}
    for _,inst in ipairs(desc.instances) do
        local l=self.instByNode[inst.node];if not l then l={};self.instByNode[inst.node]=l end
        table.insert(l,inst)
    end
    -- templates + calibration
    local imp,k,err=M.calibrate(assets,desc)
    self.import,self.importScale,self.importError=imp,k,err
    local missing={}
    local worst=0
    for _,g in ipairs(desc.geometries) do
        local p=assets:FindFirstChild(g.name,true)
        if p and p:IsA("BasePart") then
            local rel=imp:Inverse()*p.CFrame
            local off=CFrame.new(rel.Position/k)*rel.Rotation
            self.templates[g.id]=p;self.offsets[g.id]=off;self.sizes[g.id]=p.Size/k
            local c=Vector3.new(g.center[1],g.center[2],g.center[3])
            worst=math.max(worst,(off.Position-c).Magnitude)
        else table.insert(missing,g.name) end
    end
    self.missing=missing;self.centerError=worst
    self.model=Instance.new("Model");self.model.Name=options.name or "NR2003CarModel"
    self.model:SetAttribute("NR2003Presentation",true);self.model.Parent=parent
    return self
end

function M:instancePart(inst)
    local p=self.instParts[inst.id]
    if p==nil then
        local t=self.templates[inst.geometry]
        if t==nil then self.instParts[inst.id]=false;return false end
        p=t:Clone()
        for _,d in ipairs(p:GetDescendants()) do
            if d:IsA("JointInstance") or d:IsA("Constraint") or d:IsA("LuaSourceContainer") then d:Destroy() end
        end
        p.Anchored=true;p.CanCollide=false;p.CanQuery=false;p.CanTouch=false;p.Massless=true
        p.Size=self.sizes[inst.geometry];p.Locked=true
        p.Name=string.format("I%04d_%s",inst.id,t.Name)
        self.instParts[inst.id]=p
    end
    return p
end

-- node-local transform (Roblox CFrame) with the 005662d0 draw overrides
function M:localCF(n,vars,ds)
    local name=n.name
    if n.keys then
        local tx,ty,tz=M.animated(n.keys,vars[n.channel] or 0,self.R)
        return Scale.cframe(tx,ty,tz,self.R)
    end
    if n.kind=="billboard" then return n._static end
    local wi=WHEEL_INDEX[name]
    if wi and ds then
        local t,h=n.t,n.hpr
        local head=(wi<=2) and ds.steer or h[1]
        return Scale.cframe(t[1],t[2],ds["wheelZ"..wi] or t[3],Scale.euler(head+HALF_PI,h[3],ds["spin"..wi] or 0,self.R))
    end
    if NEEDLE[name] and ds and ds.needles then      -- focus car (drawobj+0x30 bit 0x10): every view
        local t,h=n.t,n.hpr
        return Scale.cframe(t[1],t[2],t[3],Scale.euler(0,h[2],ds.needles[name] or 0,self.R))
    end
    if ds and vars._cockpit then                   -- drawobj+0x30 bit 0x01 (cockpit camera)
        if name=="steer" then
            local t,h=n.t,n.hpr
            return Scale.cframe(t[1],t[2],t[3],Scale.euler(h[1],h[2],ds.wheelAngle or 0,self.R))
        elseif name=="shifter" then
            local t,h=n.t,n.hpr
            return Scale.cframe(t[1],t[2],t[3],Scale.euler(h[1],ds.shifterP or h[2],ds.shifterR or h[3],self.R))
        end
    end
    if name=="head" and ds and ds.headTranslation then
        -- 00566538..0056658a: translation = draw-record head; rotation (0, headPitch - p, headRoll - r) with p, r of
        -- 005f74c0(body matrix of the draw record)
        local t=ds.headTranslation
        return Scale.cframe(t[1],t[2],t[3],Scale.euler(0,(ds.headPitch or 0)-(self.bodyPitch or 0),
            (ds.headRoll or 0)-(self.bodyRoll or 0),self.R))
    end
    return n._static
end

-- bodyCF: Roblox world CFrame of the chassis (the NR2003 body frame); vars: 3do variable values; ds: draw state with
-- the derived fields (wheelAngle, needles, headTranslation); cameraPos: Roblox world position for the LOD distances
function M:update(bodyCF,vars,ds,cameraPos,lodScale)
    local parts,cframes=self.parts,self.cframes
    table.clear(parts);table.clear(cframes)
    local active={}
    local mps=Scale.METRES_PER_STUD
    lodScale=lodScale or 1
    local _,_,_,Rb=Scale.fromCFrame(bodyCF,self.bodyR)
    self.bodyR=Rb
    local _
    _,self.bodyPitch,self.bodyRoll=Scale.decompose(Rb)
    local nodeCount=0
    local function walk(n,cf)
        nodeCount+=1
        local kind=n.kind
        if kind=="frame" or kind=="billboard" then cf=cf*self:localCF(n,vars,ds) end
        local insts=self.instByNode[n.id]
        if insts then
            for _,inst in ipairs(insts) do
                local p=self:instancePart(inst)
                if p then
                    active[inst.id]=true   -- cf is the CFrame of inst.frame: it only changes at frame nodes
                    parts[#parts+1]=p;cframes[#cframes+1]=cf*self.offsets[inst.geometry]
                end
            end
        end
        self.frameCF[n.id]=cf
        local ch=self.kids[n.id]
        if not ch then return end
        if kind=="switch" then
            local v=vars[n.variable]
            if v==nil then v=n.default or 0 end
            local i=M.selectState(n.values,v)
            if i==nil then return end
            for _,c in ipairs(ch) do if c.index==i then walk(c,cf) end end
            return
        elseif kind=="lod" then
            local floor=self.options.lodFloor or 0
            local i=floor<#n.distances and floor or 0
            if cameraPos then
                local c=n.center
                local wc=cf*Scale.point(c[1],c[2],c[3])
                i=M.selectLod(n.distances,(wc-cameraPos).Magnitude*mps*lodScale,floor)
            end
            local best=nil
            for _,c in ipairs(ch) do if c.index<=i and (best==nil or c.index>best.index) then best=c end end
            if best then walk(best,cf) end
            return
        end
        for _,c in ipairs(ch) do walk(c,cf) end
    end
    walk(self.byId[0],bodyCF)
    -- (de)activate
    for id,p in pairs(self.instParts) do
        if p then
            local want=active[id]==true
            if want~=(self.instActive[id]==true) then
                p.Parent=want and self.model or nil
                self.instActive[id]=want
            end
        end
    end
    if #parts>0 then workspace:BulkMoveTo(parts,cframes,Enum.BulkMoveMode.FireCFrameChanged) end
    self.stats.parts=#parts;self.stats.nodes=nodeCount
    return #parts
end

-- livery: replace the TextureID of every 'card' geometry (the 3do paint placeholder) by a texture asset
function M:setLivery(textureId)
    for _,g in ipairs(self.desc.geometries) do
        if g.texture=="card" and self.templates[g.id] then
            local t=self.templates[g.id]
            if t:IsA("MeshPart") then t.TextureID=textureId end
            for _,inst in ipairs(self.desc.instances) do
                if inst.geometry==g.id then
                    local p=self.instParts[inst.id]
                    if p and p:IsA("MeshPart") then p.TextureID=textureId end
                end
            end
        end
    end
end
function M:destroy() self.model:Destroy();self.instParts={} end
return M
