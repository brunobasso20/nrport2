-- Presentation-only render snapshot codec + quaternion helpers.
-- Pure Lua apart from Roblox's `buffer` library. It never feeds the authoritative solver.
local M={}
M.VERSION=1
M.WHEELS=4
M.FLAG_TELEPORT=1
M.HEADER=76
M.WHEEL_BYTES=32
M.SIZE=M.HEADER+M.WHEELS*M.WHEEL_BYTES -- 204 bytes
local TAU=2*math.pi

local function finite(v) return v==v and v>-math.huge and v<math.huge end
M.finite=finite
function M.wrapPi(a) return (a+math.pi)%TAU-math.pi end
function M.hasFlag(flags,flag) return math.floor((flags or 0)/flag)%2==1 end

-- Layout, little endian:
--  0 u8 version | 1 u8 wheelCount | 2 u16 vehicleId | 4 u16 seq | 6 u16 flags
--  8 u32 tick | 12 f64 serverTime
-- 20 f32 worldPos[3] | 32 f32 quat[4] | 48 f32 linearVel[3] studs/s
-- 60 f32 angularVel[3] world rad/s | 72 f32 roadSteer
-- 76 + wheel*32: f32 compression | f32 steer | f64 unwrappedSpin |
--                 f32 contactLocalXYZ | u8 grounded | 3 bytes padding.
function M.encode(s)
    local b=buffer.create(M.SIZE)
    buffer.writeu8(b,0,M.VERSION);buffer.writeu8(b,1,M.WHEELS)
    buffer.writeu16(b,2,s.vehicleId%65536);buffer.writeu16(b,4,s.seq%65536)
    buffer.writeu16(b,6,s.flags or 0);buffer.writeu32(b,8,s.tick%4294967296)
    buffer.writef64(b,12,s.time)
    buffer.writef32(b,20,s.px);buffer.writef32(b,24,s.py);buffer.writef32(b,28,s.pz)
    buffer.writef32(b,32,s.qx);buffer.writef32(b,36,s.qy);buffer.writef32(b,40,s.qz);buffer.writef32(b,44,s.qw)
    buffer.writef32(b,48,s.lx);buffer.writef32(b,52,s.ly);buffer.writef32(b,56,s.lz)
    buffer.writef32(b,60,s.ax);buffer.writef32(b,64,s.ay);buffer.writef32(b,68,s.az)
    buffer.writef32(b,72,s.steer)
    for j=1,M.WHEELS do
        local w=s.wheels[j];local o=M.HEADER+(j-1)*M.WHEEL_BYTES
        buffer.writef32(b,o,w.comp);buffer.writef32(b,o+4,w.steer);buffer.writef64(b,o+8,w.spin)
        buffer.writef32(b,o+16,w.cx);buffer.writef32(b,o+20,w.cy);buffer.writef32(b,o+24,w.cz)
        buffer.writeu8(b,o+28,w.grounded and 1 or 0)
    end
    return b
end

function M.decode(b)
    if type(b)~="buffer" then return nil,"not a buffer" end
    if buffer.len(b)<M.SIZE then return nil,"short packet" end
    if buffer.readu8(b,0)~=M.VERSION then return nil,"version" end
    if buffer.readu8(b,1)~=M.WHEELS then return nil,"wheel count" end
    local s={vehicleId=buffer.readu16(b,2),seq=buffer.readu16(b,4),flags=buffer.readu16(b,6),
        tick=buffer.readu32(b,8),time=buffer.readf64(b,12),
        px=buffer.readf32(b,20),py=buffer.readf32(b,24),pz=buffer.readf32(b,28),
        qx=buffer.readf32(b,32),qy=buffer.readf32(b,36),qz=buffer.readf32(b,40),qw=buffer.readf32(b,44),
        lx=buffer.readf32(b,48),ly=buffer.readf32(b,52),lz=buffer.readf32(b,56),
        ax=buffer.readf32(b,60),ay=buffer.readf32(b,64),az=buffer.readf32(b,68),
        steer=buffer.readf32(b,72),wheels={}}
    for _,k in ipairs({"time","px","py","pz","qx","qy","qz","qw","lx","ly","lz","ax","ay","az","steer"}) do
        if not finite(s[k]) then return nil,"non-finite "..k end
    end
    local n=math.sqrt(s.qx*s.qx+s.qy*s.qy+s.qz*s.qz+s.qw*s.qw)
    if n<0.5 or n>1.5 then return nil,"bad quaternion" end
    s.qx,s.qy,s.qz,s.qw=s.qx/n,s.qy/n,s.qz/n,s.qw/n
    for j=1,M.WHEELS do
        local o=M.HEADER+(j-1)*M.WHEEL_BYTES
        local w={comp=buffer.readf32(b,o),steer=buffer.readf32(b,o+4),spin=buffer.readf64(b,o+8),
            cx=buffer.readf32(b,o+16),cy=buffer.readf32(b,o+20),cz=buffer.readf32(b,o+24),
            grounded=buffer.readu8(b,o+28)~=0}
        for _,k in ipairs({"comp","steer","spin","cx","cy","cz"}) do
            if not finite(w[k]) then return nil,"non-finite wheel "..k end
        end
        s.wheels[j]=w
    end
    return s
end

-- CFrame rotation-matrix order -> unit quaternion (Shepperd).
function M.quatFromMatrix(m00,m01,m02,m10,m11,m12,m20,m21,m22)
    local x,y,z,w;local tr=m00+m11+m22
    if tr>0 then
        local s=math.sqrt(tr+1)*2;w=0.25*s;x=(m21-m12)/s;y=(m02-m20)/s;z=(m10-m01)/s
    elseif m00>m11 and m00>m22 then
        local s=math.sqrt(1+m00-m11-m22)*2;w=(m21-m12)/s;x=0.25*s;y=(m01+m10)/s;z=(m02+m20)/s
    elseif m11>m22 then
        local s=math.sqrt(1+m11-m00-m22)*2;w=(m02-m20)/s;x=(m01+m10)/s;y=0.25*s;z=(m12+m21)/s
    else
        local s=math.sqrt(1+m22-m00-m11)*2;w=(m10-m01)/s;x=(m02+m20)/s;y=(m12+m21)/s;z=0.25*s
    end
    local n=math.sqrt(x*x+y*y+z*z+w*w)
    return x/n,y/n,z/n,w/n
end
function M.quatToMatrix(x,y,z,w)
    local xx,yy,zz=x*x,y*y,z*z;local xy,xz,yz=x*y,x*z,y*z;local wx,wy,wz=w*x,w*y,w*z
    return 1-2*(yy+zz),2*(xy-wz),2*(xz+wy),
        2*(xy+wz),1-2*(xx+zz),2*(yz-wx),
        2*(xz-wy),2*(yz+wx),1-2*(xx+yy)
end
function M.slerp(ax,ay,az,aw,bx,by,bz,bw,t,out)
    local d=ax*bx+ay*by+az*bz+aw*bw
    if d<0 then bx,by,bz,bw,d=-bx,-by,-bz,-bw,-d end
    d=math.max(-1,math.min(1,d))
    local sa,sb
    if d>0.9995 then sa,sb=1-t,t
    else local theta=math.acos(d);local st=math.sin(theta);sa=math.sin((1-t)*theta)/st;sb=math.sin(t*theta)/st end
    local x,y,z,w=sa*ax+sb*bx,sa*ay+sb*by,sa*az+sb*bz,sa*aw+sb*bw
    local n=math.sqrt(x*x+y*y+z*z+w*w);out.x,out.y,out.z,out.w=x/n,y/n,z/n,w/n
    return out
end
-- Angular velocity is world-frame, matching CoreChassisAdapter:kinematics().
function M.integrate(qx,qy,qz,qw,wx,wy,wz,dt,out)
    local mag=math.sqrt(wx*wx+wy*wy+wz*wz);local angle=mag*dt;local dx,dy,dz,dw
    if angle<1e-9 then dx,dy,dz,dw=0,0,0,1
    else local s=math.sin(angle*0.5)/mag;dx,dy,dz,dw=wx*s,wy*s,wz*s,math.cos(angle*0.5) end
    local x=dw*qx+dx*qw+dy*qz-dz*qy
    local y=dw*qy-dx*qz+dy*qw+dz*qx
    local z=dw*qz+dx*qy-dy*qx+dz*qw
    local w=dw*qw-dx*qx-dy*qy-dz*qz
    local n=math.sqrt(x*x+y*y+z*z+w*w);out.x,out.y,out.z,out.w=x/n,y/n,z/n,w/n
    return out
end
-- The physics wheel angle is wrapped to [0,2pi). Use omega to select the correct turn count.
function M.unwrapSpin(previous,wrapped,omega,dt)
    if previous==nil or not finite(previous) or not finite(dt) or dt<=0 or dt>0.25 then return wrapped end
    local predicted=previous+omega*dt
    return predicted+M.wrapPi(wrapped-predicted)
end
return M
