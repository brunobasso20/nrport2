-- Vector3/CFrame helpers are prepended from the existing adapter mock.
local originalVectorNew = Vector3.new
Vector3.new = function(x,y,z)
    for _,v in ipairs({x,y,z}) do assert(type(v)=='number' and v==v and math.abs(v)<math.huge,'invalid numeric vector') end
    return originalVectorNew(x,y,z)
end
function CFrame.fromMatrix(p,x,y,z)
    return CFrame.fromParts({p.X,p.Y,p.Z},{x.X,y.X,z.X,x.Y,y.Y,z.Y,x.Z,y.Z,z.Z})
end
function CFrame.ToObjectSpace(a,b)
    local r=a.r
    return CFrame.fromParts({a:PointToObjectSpace(b.Position).X,a:PointToObjectSpace(b.Position).Y,a:PointToObjectSpace(b.Position).Z},
        mulR({r[1],r[4],r[7],r[2],r[5],r[8],r[3],r[6],r[9]},b.r))
end
CFrame.identity=CFrame.new()
local Instance={}
local IM={}
IM.__index=function(o,k)
    if k=='Position' then return o.CFrame.Position end
    return Instance[k] or o._props[k]
end
IM.__newindex=function(o,k,v)
    if k=='Parent' then
        assert(not o._destroyed,'The Parent property is locked, current parent NULL')
        local old=o._props.Parent
        if old then for i,ch in ipairs(old._children) do if ch==o then table.remove(old._children,i);break end end end
        if v then table.insert(v._children,o) end
    end
    o._props[k]=v
end
function Instance.new(class)
    return setmetatable({_props={ClassName=class,Name=class,TextureID='rbxassetid://123',Size=Vector3.new(1,1,1),CFrame=CFrame.identity},_children={},_attrs={}},IM)
end
function Instance:IsA(c) return self.ClassName==c or (c=='BasePart' and self.ClassName=='MeshPart') end
function Instance:GetChildren() return table.clone(self._children) end
function Instance:GetDescendants()
    local result={}
    local function walk(o) for _,ch in ipairs(o._children) do table.insert(result,ch);walk(ch) end end
    walk(self);return result
end
function Instance:FindFirstChild(name,recursive)
    for _,ch in ipairs(self._children) do if ch.Name==name then return ch end end
    if recursive then for _,ch in ipairs(self._children) do local found=ch:FindFirstChild(name,true);if found then return found end end end
    return nil
end
function Instance:FindFirstChildOfClass(c) for _,ch in ipairs(self._children) do if ch:IsA(c) then return ch end end end
function Instance:SetAttribute(k,v) self._attrs[k]=v end
function Instance:GetAttribute(k) return self._attrs[k] end
function Instance:Destroy() error('Visual installer must preserve instances for Studio history') end
local function make(class,name,parent) local o=Instance.new(class);o.Name=name;o.Parent=parent;return o end
local function vec(a) return Vector3.new(a[1],a[2],a[3]) end
local function world()
    local w={workspace=make('Folder','Workspace'),storage=make('Folder','ServerStorage'),selection={}}
    w.game={GetService=function(_,name)
        if name=='RunService' then return {IsRunning=function()return false end} end
        if name=='Selection' then return {Get=function()return w.selection end} end
        if name=='ServerStorage' then return w.storage end
        error(name)
    end}
    return w
end
local markerPositions={O={0,0,0},X={4,0,0},Y={0,4,0},Z={0,0,4}}
local function imported(w,c,k,xf,parent)
    local model=make('Model',c.name,parent or w.workspace)
    local markers={}
    for letter,p in pairs(markerPositions) do
        local name='NR2003_MARKER_'..letter
        local node=make('Model',name..'_Node',model)
        local part=make('MeshPart',name,node)
        part.CFrame=xf*CFrame.new((vec(p)+Vector3.new(.0625,.0625,.0625))*k)
        markers[letter]={part=part,node=node}
    end
    for _,g in ipairs(c.geometries) do
        local node=make('Model',g.name..'_Node',model)
        local part=make('MeshPart',g.name,node)
        part.CFrame=xf*CFrame.new(vec(g.center)*k);part.Size=vec(g.size)*k
    end
    return model,markers
end
local function compile(w,c)
    local fn=assert(loadstring(c.source,c.name))
    setfenv(fn,setmetatable({game=w.game,workspace=w.workspace,Instance=Instance,Vector3=Vector3,CFrame=CFrame,
        Enum={AlphaMode={Transparency='Transparency',Overlay='Overlay'}},print=function()end,warn=function()end},{__index=_G}))
    return fn()
end
local passed=0
local function check(name,condition) assert(condition,name);passed+=1 end
local function verifyChunk(w,c,k,markers)
    local root=assert(w.workspace:FindFirstChild('NR2003WatkinsGlen'))
    local installed=assert(root:FindFirstChild(c.name))
    check('hash',installed:GetAttribute('NR2003SourceHash')==c.hash)
    check('shared scale',root:GetAttribute('NR2003MetresPerStud')==.28)
    for _,g in ipairs(c.geometries) do
        local p=assert(installed:FindFirstChild(g.name,true))
        assert((p.Position-vec(g.center)).Magnitude<1e-6 and (p.Size-vec(g.size)).Magnitude<1e-6,'calibration changed dimensions')
        for i,value in ipairs(p.CFrame.r) do assert(math.abs(value-CFrame.identity.r[i])<1e-9,'calibration changed orientation') end
        assert(p.Anchored and not p.CanCollide and not p.CanTouch and p.CanQuery==(c.kind=='terrain'),'query/collision flags')
    end
    check('geometry and flags',true)
    if markers then
        local backup=assert(w.storage:FindFirstChild('NR2003Backup_TrackVisuals'))
        for _,m in pairs(markers) do
            assert(m.part.Parent==m.node and m.node.Parent.Parent==backup,'marker node history lost')
        end
        check('marker parents retained',true)
    end
    return installed
end
-- A failed master with four installed scenery chunks must resume the remaining 84.
local w=world()
local legacyRoot=make('Model','NR2003WatkinsGlen',w.workspace)
legacyRoot.WorldPivot=CFrame.identity
legacyRoot:SetAttribute('TrackOriginEnabled',true)
legacyRoot:SetAttribute('NR2003MetresPerStud',.28)
local firstFour={}
for _,c in ipairs(CASES) do
    if c.kind=='scenery' then
        local model=make('Model',c.name,legacyRoot)
        for _,g in ipairs(c.geometries) do
            local p=make('MeshPart',g.name,model);p.CFrame=CFrame.new(vec(g.center));p.Size=vec(g.size)
            p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false
        end
        model:SetAttribute('NR2003SourceHash',c.hash);firstFour[c.name]=model
    else imported(w,c,.375,CFrame.new(110,25,-400)*CFrame.Angles(0,.73,0)) end
end
local pending=make('Model','unrelated pending markers',legacyRoot)
for letter,p in pairs(markerPositions) do local m=make('MeshPart','NR2003_MARKER_'..letter,pending);m.CFrame=CFrame.new(vec(p)) end
w.selection={legacyRoot}
for _,c in ipairs(CASES) do
    local src=w.workspace:FindFirstChild(c.name)
    local markerRefs={}
    if src then for letter in pairs(markerPositions) do local p=src:FindFirstChild('NR2003_MARKER_'..letter,true);markerRefs[letter]={part=p,node=p.Parent} end end
    compile(w,c)()
    local installed=verifyChunk(w,c,.375,src and markerRefs or nil)
    if c.kind=='scenery' then assert(installed==firstFour[c.name],'reinstalled completed scenery') end
end
check('all 88 chunks present after partial resume',#legacyRoot:GetChildren()==89)
-- Rerun the exact same cached closures with the complete track selected.
for _,c in ipairs(CASES) do
    local fn=compile(w,c);fn();fn();check('idempotent '..c.name,legacyRoot:FindFirstChild(c.name)~=nil)
end
-- Selected import containers may wrap more than one whole GLB.
do
    local a=world();local parent=make('Folder','Importer wrapper',a.workspace)
    imported(a,CASES[1],1,CFrame.identity,parent);imported(a,CASES[2],1,CFrame.identity,parent);a.selection={parent}
    compile(a,CASES[1])();verifyChunk(a,CASES[1],1)
    check('selected wrapper resolves the named chunk',parent:FindFirstChild(CASES[2].name)~=nil)
end
-- Refuse malformed transforms/incomplete imports before changing any part.
for _,fault in ipairs({'missing mesh','nonuniform','reflection','wrong centre'}) do
    local a=world();local c=CASES[5];local src,markers=imported(a,c,1,CFrame.identity)
    if fault=='missing mesh' then src:FindFirstChild(c.geometries[1].name,true).Parent=nil end
    if fault=='nonuniform' then local p=markers.Y.part;p.CFrame=p.CFrame+Vector3.new(0,4,0) end
    if fault=='reflection' then local p=markers.X.part;p.CFrame=p.CFrame-Vector3.new(8,0,0) end
    if fault=='wrong centre' then local p=src:FindFirstChild(c.geometries[1].name,true);p.CFrame=p.CFrame+Vector3.new(1,0,0) end
    local ok=pcall(compile(a,c))
    check('refuse '..fault,not ok and src.Parent==a.workspace and not a.workspace:FindFirstChild('NR2003WatkinsGlen') and #a.storage:GetChildren()==0)
end
-- Execute installer generated directly from NumPy scalars, without an np global.
do
    local a=world();local c=NUMPY_CASE;local src,markers=imported(a,c,1,CFrame.identity)
    compile(a,c)();verifyChunk(a,c,1,markers);check('NumPy numbers execute as native Luau literals',true)
end
print(string.format('Visual installer runtime: %d checks passed; 88 chunks; partial resume, cached rerun, calibration, marker history and malformed import refusal.',passed))
