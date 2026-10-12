-- NR2003DrawState: the ORIGINAL car draw record, sampled on the server from the core and replayed on the client.
-- PRESENTATION ONLY: read-only views of cells the ported frame end already writes (00551990, lifted in Stage 11);
-- nothing here is written back to the core.
--   car = 0xc12030 (player car slot, 00562f70(0)); snapshot fields 0x1508..0x15b4 (00551990) -> draw record
--   (00565880 gather) -> 005662d0 / camera 0056a9a0:
--     0x1508 rpm, 0x1518 tach hold value, 0x151c oil pressure, 0x1520 / 0x1524 engine temperatures,
--     0x1528 fuel pressure, 0x152c voltage, 0x1530/34/38 attitude (heading / pitch / roll),
--     0x153c..44 head (head-state displacement + modelinfo head; the bench core has no model -> displacement only,
--       the client adds the 3do 'head' node rest position), 0x1548 heading (attitude filter), 0x154c / 0x1550 filtered
--       pitch / roll (00551ce0), 0x1554 mean front hub steer, 0x1558.. wheel z, 0x1568.. wheel spin, 0x1578.. wheel
--       rate, 0x1588 / 0x158c shifter, 0x1590..0x15a8 shift-arm animation, 0x15ac roof flap, 0x15b0 backfire frame.
--   engine rev limit for the shift light: *(car+0x576)+0x2c; blink: getBGCount (0x7559bc) bit 4.
--   steering: ratio = 00554fb0 at the current speed, limit = cockpit draw limit (Stage 12.1 option), so the client
--   applies 005662d0's a = clamp(-(ratio * steer)) to the INTERPOLATED steer exactly like the original draw.
-- Client interpolation: 005ba170 rules (see Buf:sample), sampled at the render time of the body pose.
local M={}
M.VERSION=1
local CAR=0xc12030
local BGCOUNT=0x7559bc
M.CAR=CAR
local FIELDS={
    "rpm","tachTell","oilPressure","temp1520","temp1524","fuelPressure","voltage",
    "heading","pitch","roll","headX","headY","headZ","attHeading","headPitch","headRoll","steer",
    "wheelZ1","wheelZ2","wheelZ3","wheelZ4","spin1","spin2","spin3","spin4","rate1","rate2","rate3","rate4",
    "shifterP","shifterR","arm1","arm2","arm3","arm4","arm5","arm6","arm7","roofFlap","backfire",
    "revLimit","ratio","limit",
}
M.FIELDS=FIELDS
local OFFS={rpm=0x1508,tachTell=0x1518,oilPressure=0x151c,temp1520=0x1520,temp1524=0x1524,fuelPressure=0x1528,
    voltage=0x152c,heading=0x1530,pitch=0x1534,roll=0x1538,headX=0x153c,headY=0x1540,headZ=0x1544,attHeading=0x1548,
    headPitch=0x154c,headRoll=0x1550,steer=0x1554,wheelZ1=0x1558,wheelZ2=0x155c,wheelZ3=0x1560,wheelZ4=0x1564,
    spin1=0x1568,spin2=0x156c,spin3=0x1570,spin4=0x1574,rate1=0x1578,rate2=0x157c,rate3=0x1580,rate4=0x1584,
    shifterP=0x1588,shifterR=0x158c,arm1=0x1590,arm2=0x1594,arm3=0x1598,arm4=0x159c,arm5=0x15a0,arm6=0x15a4,
    arm7=0x15a8,roofFlap=0x15ac,backfire=0x15b0}
M.OFFSETS=OFFS
M.HEADER=16
M.SIZE=M.HEADER+#FIELDS*4

-- server: read the cells from a Core.NR2003CupVehicle instance (nil when the core lacks the Stage 11 frame end)
function M.sample(core,out,steerScratch)
    local V=core and core.V
    if not (V and V.rf32 and V.r32 and V.runtimeMode and V.runtimeMode()=="original") then return nil end
    out=out or {}
    local rf32,r32=V.rf32,V.r32
    for k,o in pairs(OFFS) do out[k]=rf32(CAR+o) end
    local engineSpec=r32(CAR+0x576)
    out.revLimit=engineSpec~=0 and rf32(engineSpec+0x2c) or 0
    out.bgCount=r32(BGCOUNT)
    if V.steeringState then
        local s=V.steeringState(steerScratch)
        out.ratio=s.ratioNow or 0
        out.steer=s.drawSteer or out.steer
        local o=V.steeringOptions and V.steeringOptions()
        out.limit=o and math.rad(o.cockpitLimitDegrees or 159.85916) or 2.7899999618530273
    else
        out.ratio,out.limit=0,2.7899999618530273
    end
    return out
end

function M.encode(seq,time,s)
    local b=buffer.create(M.SIZE)
    buffer.writeu8(b,0,M.VERSION);buffer.writeu8(b,1,#FIELDS);buffer.writeu16(b,2,seq%65536)
    buffer.writeu32(b,4,(s.bgCount or 0)%4294967296);buffer.writef64(b,8,time)
    for i,k in ipairs(FIELDS) do buffer.writef32(b,M.HEADER+(i-1)*4,s[k] or 0) end
    return b
end
function M.decode(b)
    if type(b)~="buffer" or buffer.len(b)<M.SIZE then return nil end
    if buffer.readu8(b,0)~=M.VERSION or buffer.readu8(b,1)~=#FIELDS then return nil end
    local s={seq=buffer.readu16(b,2),bgCount=buffer.readu32(b,4),time=buffer.readf64(b,8)}
    for i,k in ipairs(FIELDS) do
        local v=buffer.readf32(b,M.HEADER+(i-1)*4)
        if v~=v then return nil end
        s[k]=v
    end
    return s
end

-- client buffer: keeps the last packets ordered by server time; sample(t) mirrors 005ba170 (prev, cur, alpha)
local Buf={};Buf.__index=Buf
function M.newBuffer(capacity) return setmetatable({list={},cap=capacity or 32},Buf) end
function Buf:push(s)
    local l=self.list;local n=#l
    if n>0 and s.time<=l[n].time then
        for i=n,1,-1 do if l[i].time==s.time then return end end
    end
    table.insert(l,s);table.sort(l,function(a,b) return a.time<b.time end)
    while #l>self.cap do table.remove(l,1) end
end
local TWO_PI=6.2831854820251465       -- 006ee484 (f32)
local PI_HI=3.141592653587892          -- 006e97f8 (f64)
local PI_LO=-3.141592653587892         -- 006f4638 (f64)
local HALF_PI=1.5707963705062866       -- 006ee480 / -006f59cc (f32)
local INV_TWO_PI=0.15915494309199166   -- 006f7598 (f64)
local TWO_PI_D=6.283185307175784       -- 006efb78 (f64)
local function wrapPi(a)
    if a>PI_HI then repeat a=a-TWO_PI until not (a>PI_HI)
    elseif a<PI_LO then repeat a=a+TWO_PI until not (a<PI_LO) end
    return a
end
M.wrapPi=wrapPi
local S4=buffer.create(4)
local function f32(x) buffer.writef32(S4,0,x) return buffer.readf32(S4,0) end
-- 005ba170 field by field (draw record offset: car cell -> rule):
--   0x98..0xb0 arm2, arm3, arm4, arm1, arm5, arm6, arm7 (0x1594.., 0x1590, 0x15a0..)   lerp
--   0xb4 / 0xb8 shifter (0x1588 / 0x158c), 0xbc steer (0x1554)                          lerp, wrap to [-pi, pi]
--   0xc0..0xc8 head (0x153c..)                                                            lerp
--   0xcc heading (0x1548), 0xd0 head pitch (0x154c)                                       lerp, wrap
--   0xd4 head roll (0x1550): prev < -pi/2 and cur > pi/2 -> cur -= 2pi (repeat); prev > pi/2 and cur < -pi/2 ->
--        cur += 2pi (repeat); lerp, wrap
--   0xd8..0xe4 wheel z (0x1558..)                                                         lerp
--   0xe8..0xf4 wheel spin (0x1568..): prev spin + dt * rate(newer record, 0x1578..) * alpha, minus
--        round(x * 1/(2pi)) * 2pi (dt = 1 / taskGetRate() between consecutive records; here the record interval)
--   0xf8 roof flap (0x15ac)                                                               lerp
--   everything else (gauges, lights, backfire, ...) is read from the newer record (drawobj fields, 00565880)
local LERP={"arm1","arm2","arm3","arm4","arm5","arm6","arm7","headX","headY","headZ",
    "wheelZ1","wheelZ2","wheelZ3","wheelZ4","roofFlap"}
local LERP_WRAP={"shifterP","shifterR","steer","attHeading","headPitch"}
M.LERP,M.LERP_WRAP=LERP,LERP_WRAP
function M.lerpRoll(prev,cur,alpha)
    if prev<-HALF_PI then
        if cur>HALF_PI then repeat cur=cur-TWO_PI until not (cur>HALF_PI) end
    elseif prev>HALF_PI then
        if cur<-HALF_PI then repeat cur=cur+TWO_PI until not (cur<-HALF_PI) end
    end
    return wrapPi((cur-prev)*alpha+prev)
end
local function roundEven(x)                -- FISTP in the default x87 rounding mode (nearest, ties to even)
    local f=math.floor(x)
    local d=x-f
    if d>0.5 or (d==0.5 and f%2~=0) then return f+1 end
    return f
end
function M.spin(prev,rate,dt,alpha)
    local x=f32(dt*rate*alpha+prev)        -- FST dword [esp+0x10]
    local n=roundEven(f32(x*INV_TWO_PI))   -- FSTP dword / FLD / FISTP
    if n~=0 then x=f32(x-n*TWO_PI_D) end
    return x
end
function Buf:sample(t,out)
    local l=self.list;local n=#l
    if n==0 then return nil end
    out=out or {}
    local a,b
    if t==nil or t>=l[n].time then a,b=l[n],l[n]
    elseif t<=l[1].time then a,b=l[1],l[1]
    else
        for i=n-1,1,-1 do if l[i].time<=t then a,b=l[i],l[i+1] break end end
    end
    local alpha=(b.time>a.time) and (t-a.time)/(b.time-a.time) or 1
    for k,v in pairs(b) do out[k]=v end
    if a~=b then
        for _,k in ipairs(LERP) do out[k]=(b[k]-a[k])*alpha+a[k] end
        for _,k in ipairs(LERP_WRAP) do out[k]=wrapPi((b[k]-a[k])*alpha+a[k]) end
        out.headRoll=M.lerpRoll(a.headRoll,b.headRoll,alpha)
        local dt=b.time-a.time
        for i=1,4 do out["spin"..i]=M.spin(a["spin"..i],b["rate"..i],dt,alpha) end
    end
    out.alpha=alpha
    return out
end
-- 005662d0: a = clamp(-(00554fb0() * steer), +-limit)
function M.steeringWheelAngle(ds)
    local a=-(ds.ratio*ds.steer)
    local lim=ds.limit or 2.7899999618530273
    if a<-lim then return -lim end
    if a>lim then return lim end
    return a
end
-- 005662d0 external views: timeValue = 10 * max(0, trunc(deg(a) + 160.355225))
function M.timeValue(a)
    local x=a*57.2957764+160.355225          -- 0056885b..0056888f, _ftol truncates toward zero
    local v=(x>=0) and math.floor(x) or -math.floor(-x)
    return math.max(0,v)*10
end
-- 00565b10: wheel_speed state from |wheel rate|: < 20 -> 0, < 60 -> 1, else 2
function M.wheelSpeedState(rate)
    local r=math.abs(rate)
    if r<20 then return 0 end
    if r<60 then return 1 end
    return 2
end
return M
