-- NR2003Mirror: the cockpit rear-view mirror. NR2003 draws the image of its mirror camera (0056a9a0 second camera,
-- NR2003CameraSystem.computeMirror: exact) through the cockpit model's portal `rearView` (mirrorFrameEnable case 0).
-- Roblox has no render-to-texture: the image is a ViewportFrame on a local part laid on the portal polygon.
--   * handedness: a mirror shows the rear view flipped left-right. The static world is cloned ONCE reflected through
--     the world plane x = 0 (M = diag(-1, 1, 1)); each frame only the camera is reflected the same way and made proper
--     by flipping its local X: render(M W, M C S_x) = flip_h(render(W, C)). Parts are reflected as R' = M R S_x, exact
--     for shapes symmetric in their local X (Block, Ball, Cylinder, Wedge); other shapes (MeshPart, Union,
--     CornerWedge) keep their own handedness. Terrain cannot be shown in a ViewportFrame.
--   * projection (APPROXIMATION, the rendserv portal mapping is not recovered): the mirror FOV (120 deg) spans the
--     portal width; vertical FOV from the portal aspect; the frustum shift (0, -look * 0.2) as a tilt.
-- Client only, presentation only; never touches the physics.
local Scale=require(script.Parent.NR2003Scale)
local M={};M.__index=M
M.MAX_PARTS=3000
M.RADIUS=2000           -- studs around the car at snapshot time
M.CANVAS_HEIGHT=96      -- pixels; width from the portal aspect

local function reflect(cf)
    -- (p, R) -> (M p, M R S_x): proper rotation, columns (-M r_x, M r_y, M r_z)
    local x,y,z,r00,r01,r02,r10,r11,r12,r20,r21,r22=cf:GetComponents()
    return CFrame.new(-x,y,z, r00,-r01,-r02, -r10,r11,r12, -r20,r21,r22)
end
M.reflect=reflect

-- portal polygon (NR body frame, metres) -> centre, width (NR y), height (NR z), plane x
local function portalBox(poly)
    local x0,x1,y0,y1,z0,z1=math.huge,-math.huge,math.huge,-math.huge,math.huge,-math.huge
    for _,p in ipairs(poly) do
        x0,x1=math.min(x0,p[1]),math.max(x1,p[1]);y0,y1=math.min(y0,p[2]),math.max(y1,p[2]);z0,z1=math.min(z0,p[3]),math.max(z1,p[3])
    end
    return {(x0+x1)/2,(y0+y1)/2,(z0+z1)/2},y1-y0,z1-z0,x0
end
M.portalBox=portalBox

function M.new(desc,parent,options)
    options=options or {}
    local portal
    for _,n in ipairs(desc.nodes) do if n.kind=="portal" and n.name=="rearView" then portal=n end end
    if not portal or not portal.polygon then return nil end
    local self=setmetatable({desc=desc,options=options,clones=0},M)
    local c,w,h,x0=portalBox(portal.polygon)
    -- 2 mm towards the driver (-x) so the image covers the mirror backing of the 3do
    self.center={x0-0.002,c[2],c[3]};self.width,self.height=w,h
    local mps=Scale.METRES_PER_STUD
    local part=Instance.new("Part")
    part.Name="NR2003RearViewMirror";part.Anchored=true;part.CanCollide=false;part.CanQuery=false;part.CanTouch=false
    part.CastShadow=false;part.Transparency=1;part.Size=Vector3.new(w/mps,h/mps,0.01)
    local gui=Instance.new("SurfaceGui")
    gui.Name="Mirror";gui.Face=Enum.NormalId.Back           -- part +Z = NR -x = towards the driver
    gui.SizingMode=Enum.SurfaceGuiSizingMode.FixedSize
    gui.CanvasSize=Vector2.new(math.floor(M.CANVAS_HEIGHT*w/h+0.5),M.CANVAS_HEIGHT)
    gui.LightInfluence=0;gui.Adornee=part;gui.ResetOnSpawn=false
    local vpf=Instance.new("ViewportFrame")
    vpf.Size=UDim2.fromScale(1,1);vpf.BorderSizePixel=0
    vpf.BackgroundColor3=options.sky or Color3.fromRGB(160,190,225)
    local cam=Instance.new("Camera");cam.Parent=vpf;vpf.CurrentCamera=cam
    local world=Instance.new("WorldModel");world.Parent=vpf
    vpf.Parent=gui
    self.part,self.gui,self.vpf,self.cam,self.world=part,gui,vpf,cam,world
    part.Parent=parent
    gui.Parent=options.guiParent or part
    return self
end

-- clone the static world (anchored, visible BaseParts not excluded) reflected through x = 0
function M:snapshot(around,exclude)
    self.world:ClearAllChildren()
    local n=0
    local lighting=game:GetService("Lighting")
    local sun=lighting:GetSunDirection()
    -- light travels along -sun; reflected through x = 0 with the world
    self.vpf.LightDirection=Vector3.new(sun.X,-sun.Y,-sun.Z)
    self.vpf.Ambient=lighting.OutdoorAmbient:Lerp(Color3.new(1,1,1),0.35)
    self.vpf.LightColor=Color3.new(1,1,1)
    local function excluded(d)
        for _,e in ipairs(exclude) do if e and (d==e or d:IsDescendantOf(e)) then return true end end
        return false
    end
    for _,d in ipairs(workspace:GetDescendants()) do
        if n>=M.MAX_PARTS then break end
        if d:IsA("BasePart") and d.Anchored and d.Transparency<1 and not d:IsA("Terrain") and not excluded(d)
            and (around==nil or (d.Position-around).Magnitude<M.RADIUS+d.Size.Magnitude) then
            local ok,cl=pcall(function() return d:Clone() end)
            if ok and cl then
                for _,x in ipairs(cl:GetDescendants()) do
                    if x:IsA("LuaSourceContainer") or x:IsA("JointInstance") or x:IsA("Constraint") then x:Destroy() end
                end
                cl.CFrame=reflect(d.CFrame);cl.Parent=self.world;n+=1
            end
        end
    end
    self.clones=n
    return n
end

-- bodyCF: chassis CFrame (NR body frame); mc: NR2003CameraSystem.computeMirror output (NR world); visible: cockpit
function M:update(bodyCF,mc,visible)
    if not visible or not mc then
        if self.part.Parent and self.gui.Enabled then self.gui.Enabled=false end
        return
    end
    self.gui.Enabled=true
    local c=self.center
    self.part.CFrame=bodyCF*Scale.cframe(c[1],c[2],c[3],{1,0,0,0,1,0,0,0,1})
    local camCF=Scale.cframe(mc.eye[1],mc.eye[2],mc.eye[3],mc.R)
    local aspect=self.width/self.height
    local vfov=2*math.atan(math.tan(mc.fov43*0.5)/aspect)
    if mc.shift and mc.shift[2]~=0 then camCF=camCF*CFrame.Angles(math.atan(-mc.shift[2]*math.tan(vfov*0.5)),0,0) end
    self.cam.FieldOfView=math.deg(vfov)
    self.cam.CFrame=reflect(camCF)
end

function M:destroy()
    if self.gui then self.gui:Destroy() end
    if self.part then self.part:Destroy() end
end
return M
