-- Pure-Lua validation for the Stage-5 presentation layer.
package.path="./roblox/?.lua;"..package.path
local rawtype=_G.type
local BufMT={}
buffer={}
function buffer.create(n) return setmetatable({bytes=string.rep("\0",n),n=n},BufMT) end
function buffer.len(b) return b.n end
local function put(b,off,fmt,v)
    local p=string.pack(fmt,v);b.bytes=b.bytes:sub(1,off)..p..b.bytes:sub(off+#p+1)
end
local function get(b,off,fmt) return (string.unpack(fmt,b.bytes,off+1)) end
function buffer.writeu8(b,o,v) put(b,o,"<I1",v) end
function buffer.writeu16(b,o,v) put(b,o,"<I2",v) end
function buffer.writeu32(b,o,v) put(b,o,"<I4",v) end
function buffer.writef32(b,o,v) put(b,o,"<f",v) end
function buffer.writef64(b,o,v) put(b,o,"<d",v) end
function buffer.readu8(b,o) return get(b,o,"<I1") end
function buffer.readu16(b,o) return get(b,o,"<I2") end
function buffer.readu32(b,o) return get(b,o,"<I4") end
function buffer.readf32(b,o) return get(b,o,"<f") end
function buffer.readf64(b,o) return get(b,o,"<d") end
function _G.type(v) if rawtype(v)=="table" and getmetatable(v)==BufMT then return "buffer" end return rawtype(v) end

local Snap=require("RenderSnapshot")
local Buffer=require("SnapshotBuffer")
local checks=0
local function check(v,label) checks=checks+1;if not v then error("FAIL: "..label,2) end end
local function near(a,b,tol,label) checks=checks+1;if math.abs(a-b)>tol then error(string.format("FAIL: %s %.12g %.12g",label,a,b),2) end end
local function make(k,time)
    local wheels={}
    for j=1,4 do wheels[j]={comp=.06+j*.002,steer=j<3 and .12 or 0,spin=k*4+j,cx=j*.4,cy=-.5,cz=.8,grounded=j~=4} end
    return {vehicleId=1,seq=k%65536,flags=0,tick=k*5,time=time or k/60,px=k*.6,py=2,pz=-k*.2,
        qx=0,qy=0,qz=0,qw=1,lx=36,ly=0,lz=-12,ax=0,ay=.2,az=0,steer=.11,wheels=wheels}
end

do
    local s=make(9);local b=Snap.encode(s);check(buffer.len(b)==204,"204-byte packet")
    local d=assert(Snap.decode(b));check(d.seq==9 and d.tick==45,"header round trip")
    near(d.wheels[2].spin,s.wheels[2].spin,0,"f64 wheel spin")
    check(d.wheels[4].grounded==false,"ground flag")
    local bad=Snap.encode(s);buffer.writef32(bad,20,0/0);check(Snap.decode(bad)==nil,"reject NaN")
end

do
    local a=math.rad(170)/2;local b=math.rad(190)/2
    local out={};Snap.slerp(0,math.sin(a),0,math.cos(a),0,math.sin(b),0,math.cos(b),.5,out)
    local r00,r01,r02,r10,r11,r12,r20,r21,r22=Snap.quatToMatrix(out.x,out.y,out.z,out.w)
    near(r00,-1,1e-9,"shortest-path slerp crosses 180");near(r22,-1,1e-9,"slerp matrix")
    near(Snap.unwrapSpin(100,((100+235/60)%(2*math.pi)),235,1/60),100+235/60,1e-8,"wheel spin unwrap")
end

do
    local b=Buffer.new({initialDelay=.09,minDelay=.055,maxDelay=.18})
    local s1,s2,s3=make(1,1),make(2,1+1/60),make(3,1+2/60)
    check(b:push(s1,1.04));check(b:push(s3,1.075));local ok,why=b:push(s2,1.065);check(ok and why=="reordered","out-of-order insertion")
    local o=b:sample(1+1.5/60);near(o.px,(s2.px+s3.px)*.5,1e-6,"position interpolation")
    check(o.mode=="interp","interpolation mode")
    local e=b:sample(s3.time+.03);check(e.mode=="extrap","bounded extrapolation")
    near(e.px,s3.px+s3.lx*.03,1e-6,"velocity extrapolation")
    local tele=make(4,2);tele.flags=Snap.FLAG_TELEPORT;b:push(tele,2.04);check(b:count()==1,"teleport flushes old interpolation history")
end

-- Network simulation: 60 Hz server snapshots, render at multiple display rates, deterministic jitter/loss.
local seed=123456
local function rnd() seed=(seed*1103515245+12345)%2147483648;return seed/2147483648 end
local function truth(t)
    local yaw=.7*t;local h=yaw/2
    local s={vehicleId=1,seq=0,flags=0,tick=math.floor(t*288),time=t,
        px=25*t+2*t*t,py=1+.02*math.sin(t*8),pz=-3*t,qx=0,qy=math.sin(h),qz=0,qw=math.cos(h),
        lx=25+4*t,ly=.16*math.cos(t*8),lz=-3,ax=0,ay=.7,az=0,steer=.15*math.sin(t),wheels={}}
    for j=1,4 do s.wheels[j]={comp=.065+.01*math.sin(t*8+j),steer=j<3 and s.steer or 0,spin=220*t+j,cx=j,cy=-.5,cz=.5,grounded=true} end
    return s
end
local function simulate(fps)
    seed=1000+fps
    local arrivals={};local duration=10;local hz=60
    for i=0,duration*hz do
        local t=i/hz;local s=truth(t);s.seq=i%65536
        if rnd()>.03 then
            local latency=.035+(rnd()-.5)*.024
            if rnd()<.02 then latency=latency+.025 end
            arrivals[#arrivals+1]={at=t+latency,s=assert(Snap.decode(Snap.encode(s)))}
        end
    end
    table.sort(arrivals,function(a,b) return a.at<b.at end)
    local b=Buffer.new();local idx=1;local out={};local extrap=0;local frames=0;local maxPosErr=0
    local frame=0;local now=0
    while now<duration do
        frame=frame+1;now=frame/fps
        while idx<=#arrivals and arrivals[idx].at<=now do b:push(arrivals[idx].s,arrivals[idx].at);idx=idx+1 end
        local rt=b:advance(now)
        if rt and not b:isStale(now) then
            local o=b:sample(rt,out)
            if now>2 then
                frames=frames+1;if o.mode~="interp" then extrap=extrap+1 end
                local ref=truth(rt);local err=math.sqrt((o.px-ref.px)^2+(o.py-ref.py)^2+(o.pz-ref.pz)^2)
                maxPosErr=math.max(maxPosErr,err)
            end
        end
    end
    local st=b:stats();return extrap/math.max(1,frames),maxPosErr,st
end
for _,fps in ipairs({30,60,120,144,240}) do
    local extrap,err,st=simulate(fps)
    check(extrap<.05,fps.." FPS extrapolation remains rare: "..string.format("%.3f",extrap))
    check(err<.35,fps.." FPS interpolation remains close to truth: "..string.format("%.3f",err))
    check(st.delay>=.055 and st.delay<=.18,fps.." FPS delay bounded")
    check(math.abs(st.serverSnapshotHz-60)<4,fps.." FPS measures snapshot Hz")
end
print(string.format("PASS: %d render snapshot/buffer checks",checks))
