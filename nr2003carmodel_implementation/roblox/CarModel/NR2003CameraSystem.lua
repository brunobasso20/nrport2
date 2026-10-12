-- NR2003CameraSystem: the ORIGINAL NR2003 camera logic, pure math (no Instances) in NR2003 axes (metres, +X fwd, +Y left,
-- +Z up). Recovered from NR2003.exe (see recovery/CARMODEL_RECOVERY.md, section Cameras):
--   names 0056b960; next / previous camera 00411530 / 00411550 (tables 006ec798 / 006ec7f0; cockpit only when the
--   session flag 0x80000 is set); mode change 00568e20 (keyboard changes are cuts: blend time 0); per-frame input
--   00569450 (look left / right controls 0x54 / 0x55, next / previous camera 0x56 / 0x57, FOV 0x6d / 0x6e); look
--   easing 005697e0 (0.1 s, x^2 / 1-(1-x)^2, 45 deg); camera placement 0056a9a0 (render path, interpolated draw record);
--   chase parameters 004116f0 / 00411730 / 00411770 / 004117b0 (exe data 00721684..); on-car cameras from <model>.cam
--   (chunk MACC, 00568610 -> 00567e10 tables, modes 10..15); cockpit eye 0074ebbc (0.1, 0, 0.1) on the head node +
--   head-state displacement (00551990); cockpit FOV option "field_of_view" default 65, range 65..78 deg, step 1 deg
--   (00440a30 / 00567a80 / 00567ab0); projection 00587e70 + rendserv 100043a0 (4:3 horizontal FOV, Hor+, frustum shift
--   (cx, cy) = (0, -0.125)); car model hidden (cockpitView = 10) in Nose / Gearbox / F Susp / R Susp (0056bb30, 005662d0).
-- Inputs per frame: body position / rotation (NR world), draw state ds (head, filtered pitch / roll), ground height under
-- a point (host), dt. Output: eye, rotation (columns = forward, left, up), fov43 (rad), shift, near, cockpitView.
local Scale=require(script.Parent.NR2003Scale)
local M={};M.__index=M
M.NAMES={[0]="NONE","cockpit","LookLeft","LookRight","F10Near","F10Far","Chase","Far Chase","Rear chase","Sky","Nose",
    "Gearbox","On Car","Roll Bar","F Susp","R Susp","Zeppelin","Pit Lane","Pit Lane 2","TV1","TV2","TV3"}
-- 006ec798 / 006ec7f0 (index = mode)
M.NEXT={[0]=1,13,1,1,5,10,1,1,1,1,1,1,1,4,1,1,1,1,1,1,1,1}
M.PREV={[0]=1,10,1,1,13,4,1,1,1,1,5,1,1,1,1,1,1,1,1,1,1,1}
M.DRIVING={1,13,4,5,10}           -- the cycle reachable while driving (next: 1 -> 13 -> 4 -> 5 -> 10 -> 1)
local FOV78=1.3612565994262695    -- 006f5f18 (with 006f5f1c 0, 006f5f20 -0.125)
M.DEFAULT_FOV={FOV78,0,-0.125}
-- 00567e10: chase tables from 004116f0 (offset), 00411730 (hpr), 00411770 (height), 004117b0 (fov)
M.CHASE={
    [4]={offset={-6,0,0},hpr={0,0.18000000715255737,0},height=2.25,fov=M.DEFAULT_FOV,near=0.4},
    [5]={offset={-9,0,0},hpr={0,0.19949999451637268,0},height=4.0,fov=M.DEFAULT_FOV,near=0.4},
    [8]={offset={5,0,0},hpr={-3.1415927410125732,0.23999999463558197,0},height=2.25,fov=M.DEFAULT_FOV,near=0.4},
}
M.CHASE[6]=M.CHASE[4];M.CHASE[7]=M.CHASE[5]
M.HIDE_CAR={[10]=true,[11]=true,[14]=true,[15]=true}  -- 0056bb30: drawobj bit 0x20 cleared -> cockpitView = 10
M.EYE_OFFSET={0.10000000149011612,0,0.10000000149011612}   -- 0074ebbc / c0 / c4
-- cockpit FOV option: degrees in 00894ee8 (default 006ef48c = 65, 00440a30); read as degrees * 006ec778 (00411850),
-- written as radians * 006ec77c (00411860); FOV up / down (controls 0x6d / 0x6e, 00569450) step 006e97f0 clamped to
-- c5736c = 78 * 006e97f0 (00567ab0) / c5c27c = 65 * 006e97f0 (00567a80)
M.FOV_OPTION_DEFAULT_DEG=65.0                -- 006ef48c
M.OPTION_DEG_TO_RAD=0.017453299835324287     -- 006ec778 (f32)
M.OPTION_RAD_TO_DEG=57.295780181884766       -- 006ec77c (f32)
M.FOV_MIN=1.1344640254974365       -- c5c27c (f32 65 * 006e97f0)
M.FOV_MAX=1.3613568544387817       -- c5736c (f32 78 * 006e97f0)
M.FOV_STEP=0.01745329238474369     -- 006e97f0 (f32 1 deg)
M.LOOK_TIME=0.10000000149011612    -- 006ea4cc
M.QUARTER_PI=0.7853981852531433   -- 006f5f30 (f32)
M.FOUR_OVER_PI=1.2732394933700562  -- 006f5f48 (f32)
M.LOOK_SMOOTHING=0.0555555559694767 -- cockpitLookSmoothingTime (0074eb94)
M.LOOK_DEADZONE=0.05000000074505806 -- cockpitLookDeadZone (0074eb98)
M.FOV_CLAMP={0.0174532998353*0.25,0.0174532998353*110} -- 0056b388: [pi/180 * 0.25, pi/180 * 110]
M.WIDESCREEN_COCKPIT_FOV=1.1343804537521816              -- 006f69a0 (65 deg), 00587ea4

local S4=buffer.create(4)
local function f32(x) buffer.writef32(S4,0,x) return buffer.readf32(S4,0) end
M.f32=f32
-- look easing (00569250 / 00569210) and their inverses (00569260 / 00569230), x in 0..1
function M.easeIn(x) return x*x end                    -- 00569250
function M.easeOut(x) return 1-(1-x)*(1-x) end         -- 00569210
function M.invEaseIn(x) return math.sqrt(x) end        -- 00569260
function M.invEaseOut(x) return 1-math.sqrt(1-x) end   -- 00569230

function M.new(config)
    config=config or {}
    local self=setmetatable({mode=1,prevMode=0,lookCur=0,lookTarget=0,lookSign=0,lookEased=0,lookAnalog=0,
        fovDeg=f32(config.fovDegrees or M.FOV_OPTION_DEFAULT_DEG),cockpitOnly=config.cockpitOnly==true,
        orbitYaw=0,orbitPitch=0,orbitZoom=1,
        widescreen=config.widescreen~=false,onCar=config.onCar or {},
        digitalLookLeft=false,digitalLookRight=false,scratch={},R={},L={}},M)
    return self
end

-- 00568e20 (look part): switching between cockpit and LookLeft / LookRight keeps the eased look continuous
function M:setMode(m)
    local prev=self.mode
    if m==prev then return end
    if m==1 then
        if prev==2 or prev==3 then
            self.lookTarget=0
            self.lookCur=f32(M.invEaseIn(f32(M.easeOut(self.lookCur))))         -- 00569260(00569210(x))
        else self.lookTarget,self.lookCur=0,0 end
    elseif m==2 or m==3 then
        self.lookTarget=1
        if prev==1 then self.lookCur=f32(M.invEaseOut(f32(M.easeIn(self.lookCur))))  -- 00569230(00569250(x))
        else self.lookCur=0 end
        self.lookSign=(m==2) and 1 or -1
    end
    self.prevMode,self.mode=prev,m
end
function M:nextCamera()
    self:resetOrbit()
    if self.cockpitOnly then self:setMode(1) return end
    self:setMode(M.NEXT[self.mode] or 1)
end
function M:prevCamera()
    self:resetOrbit()
    if self.cockpitOnly then self:setMode(1) return end
    self:setMode(M.PREV[self.mode] or 1)
end

-- NON-ORIGINAL extension (bench request): free orbit of the third-person (chase) cameras around the car. With no
-- orbit input (yaw = pitch = 0, zoom = 1) the ORIGINAL placement is used unchanged. The orbit rotates the original
-- camera (eye and orientation) about the car's body origin: yaw about the world vertical, pitch about the horizontal
-- axis across the view (elevation kept within [-5, 80] deg), zoom scales the distance (0.4 .. 3). Reset on V / B.
M.ORBIT_MIN_ELEVATION=math.rad(-5)
M.ORBIT_MAX_ELEVATION=math.rad(80)
M.ORBIT_ZOOM={0.4,3.0}
function M:resetOrbit() self.orbitYaw,self.orbitPitch,self.orbitZoom=0,0,1 end
function M:orbit(dyaw,dpitch)
    self.orbitYaw=((self.orbitYaw or 0)+(dyaw or 0))%(2*math.pi)
    self.orbitPitch=(self.orbitPitch or 0)+(dpitch or 0)
end
function M:zoom(factor)
    self.orbitZoom=math.clamp((self.orbitZoom or 1)*factor,M.ORBIT_ZOOM[1],M.ORBIT_ZOOM[2])
end
function M:orbiting() return (self.orbitYaw or 0)~=0 or (self.orbitPitch or 0)~=0 or (self.orbitZoom or 1)~=1 end
-- rotation about a unit axis (Rodrigues), row-major
local function axisAngle(ax,ay,az,a,out)
    local c,s=math.cos(a),math.sin(a);local t=1-c
    out[1],out[2],out[3]=t*ax*ax+c,t*ax*ay-s*az,t*ax*az+s*ay
    out[4],out[5],out[6]=t*ax*ay+s*az,t*ay*ay+c,t*ay*az-s*ax
    out[7],out[8],out[9]=t*ax*az-s*ay,t*ay*az+s*ax,t*az*az+c
    return out
end
M.axisAngle=axisAngle
function M:applyOrbit(bp,out)
    local rx,ry,rz=out.eye[1]-bp[1],out.eye[2]-bp[2],out.eye[3]-bp[3]
    local dist=math.sqrt(rx*rx+ry*ry+rz*rz)
    if dist<1e-6 then return end
    local el0=math.asin(math.clamp(rz/dist,-1,1))
    local pitch=math.clamp(self.orbitPitch or 0,M.ORBIT_MIN_ELEVATION-el0,M.ORBIT_MAX_ELEVATION-el0)
    self.orbitPitch=pitch
    local Y=axisAngle(0,0,1,self.orbitYaw or 0,{})
    local qx,qy,qz=Scale.apply(Y,rx,ry,rz)
    -- pitch axis: horizontal, perpendicular to the (yawed) offset
    local ax,ay=-qy,qx
    local al=math.sqrt(ax*ax+ay*ay)
    local T=Y
    if al>1e-9 and pitch~=0 then
        local P=axisAngle(ax/al,ay/al,0,-pitch,{})
        qx,qy,qz=Scale.apply(P,qx,qy,qz)
        T=Scale.mul(P,Y,{})
    end
    local z=self.orbitZoom or 1
    out.eye={bp[1]+qx*z,bp[2]+qy*z,bp[3]+qz*z}
    out.R=Scale.mul(T,out.R,{})
    out.orbit=true
end
function M:optionRad() return self.fovDeg*M.OPTION_DEG_TO_RAD end                       -- 00411850
function M:setOptionRad(v) self.fovDeg=f32(M.OPTION_RAD_TO_DEG*f32(v)) end                -- 00411860
function M:fovUp()                                                                        -- control 0x6d
    local v=self:optionRad()+M.FOV_STEP
    if M.FOV_MAX<v then v=M.FOV_MAX end
    self:setOptionRad(v)
end
function M:fovDown()                                                                      -- control 0x6e
    local v=self:optionRad()-M.FOV_STEP
    if v<M.FOV_MIN then v=M.FOV_MIN end
    self:setOptionRad(v)
end

-- 00569450 look input. digital: left / right booleans; analog: axis in -1..1 (right - left) or nil
function M:input(left,right,analogAxis,dt)
    if analogAxis~=nil then
        local x=analogAxis
        local dz=M.LOOK_DEADZONE
        if dz<1 and dz>0 then
            if x>=-dz then
                if x<=dz then x=0 else x=(x-dz)/(1-dz) end
            else x=(x+dz)/(1-dz) end
        end
        if not self.analogStarted then self.lookAnalog=f32(x);self.analogStarted=true   -- first sample (timer 0)
        elseif dt and dt>0 then
            local a=0.5^(M.LOOK_SMOOTHING/dt)       -- 006c5c40 = pow (as in Stage 11), arguments 0.5 and T / dt
            self.lookAnalog=f32(a*self.lookAnalog+(1-a)*x)
        end
    else
        self.lookAnalog=0
        if not left then if self.mode==2 then self:setMode(1) end
        elseif self.mode==1 and self.lookCur==0 then self:setMode(2) end
        if not right then if self.mode==3 then self:setMode(1) end
        elseif self.mode==1 and self.lookCur==0 then self:setMode(3) end
    end
end

-- 005697e0 look easing (rate: full travel in 0.1 s)
function M:tick(dt)
    if self.mode>=1 and self.mode<=3 then
        local step=dt/M.LOOK_TIME
        if self.lookCur<self.lookTarget then self.lookCur=math.min(self.lookCur+step,self.lookTarget)
        elseif self.lookCur>self.lookTarget then self.lookCur=math.max(self.lookCur-step,self.lookTarget) end
        local x=self.lookCur
        if x<=0 then self.lookEased=0
        elseif x<1 then
            if self.lookTarget==0 then self.lookEased=x*x*M.QUARTER_PI
            else self.lookEased=(1-(1-x)*(1-x))*M.QUARTER_PI end
        else self.lookEased=0.7853982 end
        self.lookEased=f32(self.lookEased)
    end
end
-- view block [0] = sign * eased, [7] = analog; 0056ac21: look = [0] - [7] * pi/4 (f32)
function M:lookYaw() return f32(f32(self.lookSign*self.lookEased)-self.lookAnalog*M.QUARTER_PI) end

local function addRot(R,x,y,z) local a,b,c=Scale.apply(R,x,y,z) return a,b,c end

-- camera from the body pose. bp = {x,y,z} body position (NR world), Rb row-major body rotation, ds = draw state
-- (head = {x,y,z} in the body frame: 3do head node rest + head-state displacement; headPitch / headRoll filtered),
-- ground(x, y, z) -> ground height below the camera (nil = none).
function M:compute(bp,Rb,ds,ground,out)
    out=out or {}
    local m=self.mode
    out.mode=m;out.name=M.NAMES[m];out.cockpitView=0;out.shift={0,-0.125};out.near=0.2
    local bh,bpitch,broll=Scale.decompose(Rb)
    if m>=1 and m<=3 then
        local hx,hy,hz=ds.head[1]+M.EYE_OFFSET[1],ds.head[2]+M.EYE_OFFSET[2],ds.head[3]+M.EYE_OFFSET[3]
        local ox,oy,oz=addRot(Rb,hx,hy,hz)
        out.eye={bp[1]+ox,bp[2]+oy,bp[3]+oz}
        local look=self:lookYaw()
        Scale.euler(look,ds.headPitch-bpitch,ds.headRoll-broll,self.L)
        Scale.mul(Rb,self.L,self.scratch)
        local h,p,r=Scale.decompose(self.scratch)
        out.R=Scale.euler(h,p,r,out.R)
        local opt=self:optionRad()
        local fov=f32(opt+f32(look*M.FOUR_OVER_PI*(M.FOV_MAX-opt)))      -- 0056ac21..0056ac5e
        out.cockpitView=1;out.near=0.2
        out.fovRaw=fov
        if self.widescreen then fov=M.WIDESCREEN_COCKPIT_FOV end          -- 00587ea2 (wide display branch)
        out.fov43=fov
        out.shift={0,-0.125}                                              -- 006f5f1c / 006f5f20
    elseif M.CHASE[m] then
        local c=M.CHASE[m]
        if m==5 or m==7 then
            local ox,oy,oz=addRot(Rb,c.offset[1],c.offset[2],c.height)
            out.eye={bp[1]+ox,bp[2]+oy,bp[3]+oz}
            Scale.euler(c.hpr[1],c.hpr[2],c.hpr[3],self.L)
            Scale.mul(Rb,self.L,self.scratch)
            local h,p,r=Scale.decompose(self.scratch)
            out.R=Scale.euler(h,p,r,out.R)
        else
            local ox,oy=addRot(Rb,c.offset[1],c.offset[2],0)
            out.eye={bp[1]+ox,bp[2]+oy,c.height+c.offset[3]+bp[3]}
            out.R=Scale.euler(bh+c.hpr[1],c.hpr[2],c.hpr[3],out.R)
        end
        out.fov43=c.fov[1];out.shift={c.fov[2],c.fov[3]};out.near=c.near
        if self:orbiting() then self:applyOrbit(bp,out) end                -- NON-ORIGINAL (see resetOrbit)
        local g=ground and ground(out.eye[1],out.eye[2],out.eye[3])
        if g and out.eye[3]-g<1.0 then out.eye[3]=g+1.0 end                  -- 006e97d8: at least 1 m above the track
    elseif m>=10 and m<=15 then
        local c=self.onCar[M.NAMES[m]]
        if c==nil then out.missing=true;c={pos={0,0,0},hpr={0,0,0},fov=M.DEFAULT_FOV} end   -- 00567e10 defaults
        local ox,oy,oz=addRot(Rb,c.pos[1],c.pos[2],c.pos[3])
        out.eye={bp[1]+ox,bp[2]+oy,bp[3]+oz}
        Scale.euler(c.hpr[1],c.hpr[2],c.hpr[3],self.L)
        Scale.mul(Rb,self.L,self.scratch)
        local h,p,r=Scale.decompose(self.scratch)
        out.R=Scale.euler(h,p,r,out.R)
        out.fov43=c.fov[1];out.shift={c.fov[2],c.fov[3]};out.near=0.2
        out.cockpitView=M.HIDE_CAR[m] and 10 or 0
    else
        return nil   -- Sky / Zeppelin / Pit Lane / TV need the track system (not ported): no change
    end
    local lo,hi=M.FOV_CLAMP[1],M.FOV_CLAMP[2]
    if out.fov43<lo then out.fov43=lo elseif out.fov43>hi then out.fov43=hi end
    return out
end
-- Rear-view mirror camera (0056a9a0 with its second camera argument, 0056b417..0056b660): a rear-facing camera at
-- C = 006f5f0c (-0.4, 0, 0.7) in the body frame plus the head displacement reflected through the plane of normal
-- normalize(C - model head); orientation (h + pi, -p, -(r + look * 006f5f44)) of R_b * Euler(0, headPitch - p_b,
-- headRoll - r_b); FOV triple (2.0944 (0x40060a92), 0, -look * 006e9824), near 0.3 (0x3e99999a). Drawn through the
-- cockpit model's portal `rearView` (mirrorFrameEnable case 0).
M.MIRROR_BASE={-0.4000000059604645,0,0.699999988079071}       -- 006f5f0c / 10 / 14
M.MIRROR_FOV=2.094395160675049                               -- 0x40060a92
M.MIRROR_NEAR=0.30000001192092896                            -- 0x3e99999a
M.MIRROR_ROLL_PER_LOOK=0.25999999046325684                   -- 006f5f44
M.MIRROR_SHIFT_PER_LOOK=0.20000000298023224                  -- 006e9824
M.PI_D=3.141592653587892                                     -- 006e97f8
-- bp / Rb body pose; ds.head = draw-record head (model head + displacement), ds.modelHead = the model's head
-- (00562f50: the 3do head node), headPitch / headRoll; look = view block [0] (sign * eased look)
function M:computeMirror(bp,Rb,ds,out)
    out=out or {}
    local C=M.MIRROR_BASE
    local mh=ds.modelHead or {0,0,0}
    local hx,hy,hz=f32(ds.head[1]-mh[1]),f32(ds.head[2]-mh[2]),f32(ds.head[3]-mh[3])
    local nx,ny,nz=C[1]-mh[1],C[2]-mh[2],C[3]-mh[3]
    local l=math.sqrt(nx*nx+ny*ny+nz*nz)
    nx,ny,nz=nx/l,ny/l,nz/l
    local d=2*(ny*hy+nz*hz+nx*hx)
    local ex,ey,ez=(C[1]+hx)-nx*d,(C[2]+hy)-ny*d,(C[3]+hz)-nz*d
    local ox,oy,oz=Scale.apply(Rb,ex,ey,ez)
    out.eye={bp[1]+ox,bp[2]+oy,bp[3]+oz}
    local _,bpitch,broll=Scale.decompose(Rb)
    Scale.euler(0,ds.headPitch-bpitch,ds.headRoll-broll,self.L)
    Scale.mul(Rb,self.L,self.scratch)
    local h,p,r=Scale.decompose(self.scratch)
    local look=f32(self.lookSign*self.lookEased)
    r=f32(look*M.MIRROR_ROLL_PER_LOOK+f32(r))
    out.R=Scale.euler(f32(f32(h)+M.PI_D),-f32(p),-r,out.R)
    out.fov43=M.MIRROR_FOV;out.shift={0,f32(0-look*M.MIRROR_SHIFT_PER_LOOK)};out.near=M.MIRROR_NEAR
    return out
end
return M
