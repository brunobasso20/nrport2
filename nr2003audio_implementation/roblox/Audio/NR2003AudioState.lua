-- Read-only view of the existing Cup core. The optional tail shares RenderState's
-- vehicle/sequence/tick/time and never creates an input or a second simulation.
local M={MAGIC=0x3141524e,VERSION=1,BASE_BYTES=204,HEADER=64,WHEEL_BYTES=52}
M.SIZE=M.HEADER+4*M.WHEEL_BYTES
local CAR,ENGINE,TYRE=0xc12030,0xc1203c,0xbf3a20
local FIELDS={"rpm","throttle","clutch","engineOmega","shaftOmega","power","cutTimer","revLimit","damage","load","gearScale"}
local WFIELDS={"omega","vx","slipX","slipY","fx","fy","fz","tread","volume","pitch","xfade","soundType"}
local WHEEL_RATE={19,25,31,33} -- CupTune's zero-based rates 18,24,30,32 + 1
local function finite(v) return type(v)=="number" and v==v and math.abs(v)<math.huge end
M.finite=finite
function M.sample(core,host,out)
    if not (core and core.V and core.V.wheelBrake and core.V.rf32) then return nil end
    local V=core.V
    out=out or {wheels={}};out.wheels=out.wheels or {}
    -- The authoritative tick already exported bf6d40. core:readState() invokes
    -- the original exporter into host scratch; audio needs only direct reads.
    local function state(i) return V.rf32(0xbf6d40+(i-1)*4) end
    local _,_,throttle,_,clutch=core:inputs()
    -- These are the exact inputs of 00563bd0 -> 004eac30. 00551e10
    -- already writes RPM and effective load from the original drivetrain.
    out.rpm=V.rf32(CAR+0x1508);out.load=V.rf32(CAR+0x1510)
    out.throttle=throttle;out.clutch=clutch
    out.engineOmega=state(35);out.shaftOmega=state(37)
    out.gear=core:gearIndex()-1 -- R=-1, N=0, 1..4 (core indices 0..5)
    out.gearScale=V.rf32(CAR+0x454+core:gearIndex()*4)*V.rf32(CAR+0x474)
    out.limiter=core:revLimiter();out.power=V.rf32(ENGINE+0x554)
    out.cutTimer=V.rf32(ENGINE+0x550);out.engineFlags=V.r32(ENGINE+0x548)
    out.damage=V.rf32(CAR+0x1493+0x58)
    local spec=V.r32(CAR+0x576)
    out.revLimit=spec~=0 and V.rf32(spec+0x2c) or 0
    out.fault=host and host.fault~=nil or false
    for j=1,4 do
        local w=out.wheels[j] or {};out.wheels[j]=w
        local t=TYRE+(j-1)*0xa39
        w.omega=state(WHEEL_RATE[j]);w.vx=V.rf32(t+0x2f0);w.slipX=V.rf32(t+0x2ec)
        w.slipY=V.rf32(t+0x2e8)
        w.fx=V.rf32(t+0x2d8);w.fy=V.rf32(t+0x2dc);w.fz=V.rf32(t+0x2e0);w.tread=V.rf32(t+0x2cc)
        w.locked=math.abs(w.vx)>0.5 and w.tread<0.05*math.abs(w.vx)
        -- 00556e30 is ALREADY lifted in NR2003CupFrameCode3, called by
        -- 00551990. Reuse its force/surface-based controls without recalculation.
        w.volume=V.rf32(CAR+0x11cb+(j-1)*4)
        w.pitch=V.rf32(CAR+0x11db+(j-1)*4)
        w.xfade=V.rf32(CAR+0x11eb+(j-1)*4)
        w.soundType=V.r32(CAR+0x120b+(j-1)*4)
        if host and host.originalTrack and V.trackContact then
            local c=V.trackContact(j-1,{})
            w.grounded=c.grounded==true;w.surface=c.surface or 0
        elseif host then
            w.grounded=host.inContact and host.inContact[j]==true or false
            w.surface=host.planes and host.planes[j] and host.planes[j][8] or 0
        else w.grounded=false;w.surface=0 end
    end
    return out
end
function M.append(base,s,epoch)
    if not s then return base end
    assert(buffer.len(base)==M.BASE_BYTES,"audio requires the v1 204-byte render packet")
    local b=buffer.create(M.BASE_BYTES+M.SIZE);buffer.copy(b,0,base)
    local o=M.BASE_BYTES
    buffer.writeu32(b,o,M.MAGIC);buffer.writeu8(b,o+4,M.VERSION);buffer.writeu8(b,o+5,4)
    buffer.writeu16(b,o+6,(s.limiter and 1 or 0)+(s.fault and 2 or 0))
    buffer.writeu32(b,o+8,epoch or 0);buffer.writei32(b,o+12,s.gear)
    for i,k in ipairs(FIELDS) do buffer.writef32(b,o+12+i*4,s[k] or 0) end
    buffer.writeu32(b,o+60,s.engineFlags or 0)
    for j=1,4 do
        local w=s.wheels[j];local p=o+M.HEADER+(j-1)*M.WHEEL_BYTES
        for i,k in ipairs(WFIELDS) do buffer.writef32(b,p+(i-1)*4,w[k] or 0) end
        buffer.writeu8(b,p+48,math.clamp(math.floor(w.surface or 0),0,19))
        buffer.writeu8(b,p+49,w.grounded and 1 or 0);buffer.writeu8(b,p+50,w.locked and 1 or 0)
    end
    return b
end
function M.decode(b)
    if type(b)~="buffer" or buffer.len(b)~=M.BASE_BYTES+M.SIZE then return nil,"no audio tail" end
    local o=M.BASE_BYTES
    if buffer.readu32(b,o)~=M.MAGIC or buffer.readu8(b,o+4)~=M.VERSION or buffer.readu8(b,o+5)~=4 then return nil,"audio version" end
    local s={vehicleId=buffer.readu16(b,2),seq=buffer.readu16(b,4),tick=buffer.readu32(b,8),
        time=buffer.readf64(b,12),epoch=buffer.readu32(b,o+8),gear=buffer.readi32(b,o+12),wheels={}}
    if buffer.readu8(b,0)~=1 or buffer.readu8(b,1)~=4 or not finite(s.time) then return nil,"render header" end
    if s.gear< -1 or s.gear>4 then return nil,"gear" end
    local flags=buffer.readu16(b,o+6);s.limiter=bit32.band(flags,1)~=0;s.fault=bit32.band(flags,2)~=0
    s.teleport=bit32.band(buffer.readu16(b,6),1)~=0;s.engineFlags=buffer.readu32(b,o+60)
    for i,k in ipairs(FIELDS) do
        local v=buffer.readf32(b,o+12+i*4);if not finite(v) then return nil,"non-finite "..k end;s[k]=v
    end
    for j=1,4 do
        local w={};s.wheels[j]=w;local p=o+M.HEADER+(j-1)*M.WHEEL_BYTES
        for i,k in ipairs(WFIELDS) do
            local v=buffer.readf32(b,p+(i-1)*4);if not finite(v) then return nil,"non-finite wheel" end;w[k]=v
        end
        if w.soundType<0 or w.soundType>4 or w.soundType~=math.floor(w.soundType) then return nil,"tire sound type" end
        w.surface=buffer.readu8(b,p+48);if w.surface>19 then return nil,"surface" end
        w.grounded=buffer.readu8(b,p+49)==1;w.locked=buffer.readu8(b,p+50)==1
        local c=76+(j-1)*32
        w.cx=buffer.readf32(b,c+16);w.cy=buffer.readf32(b,c+20);w.cz=buffer.readf32(b,c+24)
        if not (finite(w.cx) and finite(w.cy) and finite(w.cz)) then return nil,"contact position" end
    end
    return s
end
-- Causal interpolation: discrete state changes only at their timestamp. Never
-- interpolate across reset epochs, extrapolate RPM, or use future throttle/gears.
local B={};B.__index=B
function M.newBuffer() return setmetatable({list={},received=0,rejected=0,resets=0,lastArrival=nil},B) end
function B:push(s,arrival)
    local list=self.list;local last=list[#list]
    if last and (s.epoch<last.epoch or (s.epoch==last.epoch and s.time<=last.time)) then self.rejected+=1;return false end
    if last and s.epoch~=last.epoch then self.list={};list=self.list;self.resets+=1 end
    list[#list+1]=s;while #list>64 do table.remove(list,1) end
    self.lastArrival=arrival;self.received+=1;return true
end
function B:sample(t,now,out)
    local l=self.list;local n=#l
    if n==0 or not self.lastArrival or now-self.lastArrival>0.5 or t<l[1].time then return nil end
    local a,b=l[n],l[n]
    for i=n-1,1,-1 do if l[i].time<=t then a,b=l[i],l[i+1];break end end
    if t>=l[n].time then a,b=l[n],l[n] end
    local alpha=a~=b and math.clamp((t-a.time)/(b.time-a.time),0,1) or 0
    out=out or {};out.wheels=out.wheels or {}
    for k,v in pairs(a) do if k~="wheels" then out[k]=v end end
    for _,k in ipairs(FIELDS) do
        if k~="gearScale" or a.gear==b.gear then out[k]=a[k]+(b[k]-a[k])*alpha end
    end
    for j=1,4 do
        local w=out.wheels[j] or {};out.wheels[j]=w
        local aw,bw=a.wheels[j],b.wheels[j]
        for k,v in pairs(aw) do w[k]=v end
        -- Contact transitions and material changes are discrete; never blend
        -- airborne/contact force or road/gravel slip across the boundary.
        if aw.grounded==bw.grounded and aw.surface==bw.surface and aw.soundType==bw.soundType then
            for _,k in ipairs(WFIELDS) do w[k]=aw[k]+(bw[k]-aw[k])*alpha end
        end
    end
    out.sampleTime=t;out.age=math.max(0,now-a.time)
    return out
end
return M
