-- NR2003Scale: the ONE unit / axis conversion between original NR2003 data and Roblox, shared by the car model,
-- the cameras and (later) the original tracks. Keep identical to pipeline/nr2003res/scale.py.
--   NR2003 (physics core, .3do models, .cam files, tracks): right-handed, metres, +X forward, +Y left, +Z up.
--   Roblox (this bench): studs, +X right, +Y up, -Z forward  ->  (x, y, z)_NR = metres  ->  (-y, z, -x) / METRES_PER_STUD.
-- METRES_PER_STUD is the bench constant every Stage 5-13 module already uses (TestTune.metresPerStud = 0.28): the
-- Cup physics adapter, this car model and future tracks must share it so original geometry aligns with no manual
-- scaling. Rotations: NR2003 Euler (heading, pitch, roll) = Rz(h) Ry(p) Rx(r), row-major (NR2003.exe 005f6f20);
-- R_roblox = B R B^T with B the axis map above (the same as CupChassisAdapter.localRotation).
-- Projection: an NR2003 camera FOV is the HORIZONTAL FOV of a 4:3 view; NR2003.exe 00587e70 keeps the 4:3 vertical FOV
-- and widens the horizontal one for wider screens (Hor+), which is Roblox's own behaviour, so
-- Camera.FieldOfView (vertical, degrees) = 2 atan(0.75 tan(fov / 2)) is exact at any aspect ratio.
local M={}
M.VERSION="1.0.0-carmodel"
M.METRES_PER_STUD=0.28

function M.point(x,y,z) local m=M.METRES_PER_STUD return Vector3.new(-y/m,z/m,-x/m) end
function M.vector(x,y,z) return Vector3.new(-y,z,-x) end
function M.toNRPoint(v) local m=M.METRES_PER_STUD return -v.Z*m,-v.X*m,v.Y*m end
function M.toNRVector(v) return -v.Z,-v.X,v.Y end
function M.studs(metres) return metres/M.METRES_PER_STUD end
function M.metres(studs) return studs*M.METRES_PER_STUD end

-- NR2003 Euler (005f6f20) -> row-major 3x3 {r1..r9}
function M.euler(h,p,r,out)
    local ch,sh,cp,sp,cr,sr=math.cos(h),math.sin(h),math.cos(p),math.sin(p),math.cos(r),math.sin(r)
    out=out or {}
    out[1],out[2],out[3]=cp*ch,ch*sr*sp-cr*sh,sr*sh+ch*cr*sp
    out[4],out[5],out[6]=cp*sh,cr*ch+sr*sp*sh,cr*sp*sh-sr*ch
    out[7],out[8],out[9]=-sp,sr*cp,cr*cp
    return out
end
-- row-major 3x3 -> (heading, pitch, roll) as NR2003.exe 005f74c0
function M.decompose(m)
    local h=math.atan2(m[4],m[1])
    local c=math.sqrt(m[4]*m[4]+m[1]*m[1])
    local p=math.atan2(-m[7],c)
    local r
    if c<9.99999974737875e-06 then -- 006ef4c8 (gimbal branch)
        r=h-math.atan2(m[6],m[3])
        if m[7]>0 then r=math.pi-r end
    else
        local a,b=-(1/c)*m[4],(1/c)*m[1]
        r=math.atan2(-(a*m[3]+b*m[6]),a*m[2]+b*m[5])
    end
    return h,p,r
end
function M.mul(a,b,out)
    out=out or {}
    for i=0,2 do for j=1,3 do
        out[i*3+j]=a[i*3+1]*b[j]+a[i*3+2]*b[3+j]+a[i*3+3]*b[6+j]
    end end
    return out
end
function M.apply(m,x,y,z) return m[1]*x+m[2]*y+m[3]*z,m[4]*x+m[5]*y+m[6]*z,m[7]*x+m[8]*y+m[9]*z end

-- NR2003 (t in metres, row-major R) -> Roblox CFrame (studs)
function M.cframe(tx,ty,tz,r)
    local p=M.point(tx,ty,tz)
    return CFrame.new(p.X,p.Y,p.Z,r[5],-r[6],r[4],-r[8],r[9],-r[7],r[2],-r[3],r[1])
end
-- Roblox CFrame -> NR2003 (tx, ty, tz, row-major R)
function M.fromCFrame(cf,out)
    local _,_,_,r00,r01,r02,r10,r11,r12,r20,r21,r22=cf:GetComponents()
    out=out or {}
    -- inverse of the map in M.cframe: R_nr = B^T R_rbx B
    out[1],out[2],out[3]=r22,r20,-r21
    out[4],out[5],out[6]=r02,r00,-r01
    out[7],out[8],out[9]=-r12,-r10,r11
    local x,y,z=M.toNRPoint(cf.Position)
    return x,y,z,out
end

function M.verticalFov(fovHorizontal43) return math.deg(2*math.atan(0.75*math.tan(fovHorizontal43*0.5))) end

-- the shared constant must match the physics adapter's (TestTune / CupTune); a mismatch would misalign everything
function M.check(tune)
    if tune and tune.metresPerStud and math.abs(tune.metresPerStud-M.METRES_PER_STUD)>1e-12 then
        error(string.format("NR2003Scale: METRES_PER_STUD %g ~= tune.metresPerStud %g",M.METRES_PER_STUD,tune.metresPerStud))
    end
    return true
end
return M
