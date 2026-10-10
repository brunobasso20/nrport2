-- Stage 12 Studio self-test (edit mode or Play, server side). Golden values embedded below were produced by the
-- ORIGINAL NR2003.exe code executed in Unicorn (recovery/stage12: gen_units12.py / gen_fixtures12.py):
--   require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage12SelfTest).run()      -- quick (~2-4 s)
--   require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage12SelfTest).run(true)  -- + all embedded snapshots, determinism
-- What it checks (subset of tests/stage12/run.luau): the ORIGINAL steering functions vector by vector (00552d00,
-- 00552720, 00554fb0, the 00551e80 tail, the option setters), frame starts loaded from the original's traced state
-- compared bit for bit, full lock at rest (pi / 7 with the low-speed override), options / garage ratio survive reset,
-- steering assistance refused, the provisional mode kept for the Stage 6-11 suites only.
local Core=script.Parent.Parent.Core
local Vehicle=require(Core.NR2003CupVehicle)
local G=__GOLDEN__
local M={}
local FLAT={}
for i=1,4 do FLAT[i]={0,0,1,0,0,0,0,1,1} end
local B64={}
do
    local chars="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    for i=1,64 do B64[string.byte(chars,i)]=i-1 end
end
local function b64(s)
    local out=buffer.create(#s*3//4);local o=0
    for i=1,#s,4 do
        local a,b,c,d=string.byte(s,i,i+3)
        local x=B64[a]*262144+B64[b]*4096+(c~=61 and B64[c] or 0)*64+(d~=61 and B64[d] or 0)
        buffer.writeu8(out,o,bit32.rshift(x,16));o+=1
        if c~=61 then buffer.writeu8(out,o,bit32.band(bit32.rshift(x,8),0xff));o+=1 end
        if d~=61 then buffer.writeu8(out,o,bit32.band(x,0xff));o+=1 end
    end
    return out
end
local S=buffer.create(8)
local function fb(u) buffer.writeu32(S,0,u);return buffer.readf32(S,0) end
local function bits(x) buffer.writef32(S,0,x);return buffer.readu32(S,0) end
local CTRL_RAW,CTRL_TYPE,SETTINGS,SETUP_RATIO=0xd35b18,0xd37cc8,0xc0692a,0xc055c0+0x30*4

local function controlsOf(row)
    local c={throttle=row[1],clutch=row[2],brakeControl=row[3],brakeDigital=true,shiftUp=row[4],shiftDown=row[5]}
    if row[9] then c.steerAxis=row[10] else c.steerLeft=row[6];c.steerRight=row[7];c.steerDigital=row[8] end
    if not row[11] then c.driver=false end
    return c
end

function M.run(full)
    local t0=os.clock()
    local passed,failed,lines=0,0,{}
    local function check(name,ok,detail)
        if ok then passed+=1 else failed+=1 end
        local line=(ok and "PASS  " or "FAIL  ")..name..(detail and ("  "..detail) or "")
        table.insert(lines,line);print("[NR2003 Stage 12 self-test] "..line)
    end
    local car=Vehicle.new(Core:WaitForChild("NR2003Cup"))
    local V=car.V
    check("Stage 12 steering chain installed (NR2003CupSteering), production mode 'original'",V.steeringMode~=nil and V.steeringMode()=="original")
    if not V.steeringMode then return false,lines end
    local fd,rf32,r32,w32,wf32,r8,w8=V.fd,V.rf32,V.r32,V.w32,V.wf32,V.r8,V.w8
    local function fdBits(x) return bits(fd(x)) end
    local M_,BASE=V.memory(),V.base
    V.setRuntimeMode("original");V.endSession();V.clearSteeringOptions();V.reset()
    local rate0=rf32(0x74c990)
    -- L1 00552d00
    local bad=0
    for _,v in ipairs(G.axis) do
        local n=v[1]
        wf32(CTRL_RAW+10*n,fb(v[2]));w32(CTRL_TYPE+29*n,v[3] and 0 or 1)
        wf32(0xbf639c+4*(n==7 and 0 or 1),fb(v[4]));wf32(0x74c990,fb(v[5]))
        local x=V.axisOriginal(n)
        if fdBits(x)~=v[7] or r32(0xbf639c+4*(n==7 and 0 or 1))~=v[8] or math.abs(x-v[6])>4*math.abs(v[6])*2^-52 then bad+=1 end
    end
    wf32(0x74c990,rate0)
    check(string.format("00552d00 steering axes (slew + sin): %d original vectors",#G.axis),bad==0,bad>0 and (bad.." differ") or nil)
    -- L1 00552720
    local s25=r32(SETTINGS+0x4c)
    local function speedState(v,yaw) wf32(0xbf6d44,fb(v));wf32(0xbf6d4c,0);wf32(0xbf6d54,0);wf32(0xbf6d70,fb(yaw)) end
    bad=0
    for _,v in ipairs(G.input) do
        w32(SETTINGS+0x4c,v[4]==1 and bit32.bor(s25,0x2000000) or bit32.band(s25,bit32.bnot(0x2000000)))
        wf32(0xbf6f00,fb(v[3]));wf32(0x74c990,1);speedState(v[1],v[2])
        local u=fb(v[5])
        wf32(CTRL_RAW+70,u<0 and -u or 0);wf32(CTRL_RAW+80,u>0 and u or 0);w32(CTRL_TYPE+29*7,1);w32(CTRL_TYPE+29*8,1)
        if bits(V.steerInputOriginal())~=v[7] then bad+=1 end
    end
    w32(SETTINGS+0x4c,s25);wf32(0xbf6f00,0);wf32(0x74c990,rate0)
    check(string.format("00552720 processed input (-1..1 x speed x yaw rate x linearity x limiter): %d original vectors bit-exact",#G.input),bad==0,bad>0 and (bad.." differ") or nil)
    -- L1 00554fb0
    bad=0
    for _,v in ipairs(G.ratio) do
        w8(0x74c9a0,v[1]);wf32(SETUP_RATIO,fb(v[2]));speedState(v[3],0)
        local r=V.steerRatioOriginal()
        if fdBits(r)~=v[5] or math.abs(r-v[4])>2*math.abs(v[4])*2^-52 then bad+=1 end
    end
    w8(0x74c9a0,1);wf32(SETUP_RATIO,18)
    check(string.format("00554fb0 steering ratio + low-speed override (8.94 / 17.88 m/s): %d original vectors",#G.ratio),bad==0,bad>0 and (bad.." differ") or nil)
    -- L1 00551e80 tail
    bad=0
    for _,v in ipairs(G.tail) do
        wf32(0xbf6f00,fb(v[1]));w32(CTRL_TYPE+29*7,v[2] and 0 or 1);w32(CTRL_TYPE+29*8,v[2] and 0 or 1)
        wf32(SETUP_RATIO,fb(v[4]));speedState(v[3],0);w32(0xbf63c8,v[5]);w32(0xbf6e80,v[6])
        local t=V._steerTail({})
        if r32(0xbf63c0)~=v[7] or fdBits(t)~=v[8] or fdBits(V._zsub(t,fb(v[6]))/8)~=v[10] then bad+=1 end
    end
    wf32(0xbf6f00,0);wf32(SETUP_RATIO,18)
    check(string.format("00551e80 tail (linearity, x pi, / ratio, ramp): %d original vectors bit-exact",#G.tail),bad==0,bad>0 and (bad.." differ") or nil)
    -- setters
    bad=0
    for _,v in ipairs(G.linUI) do V.setSteeringOptions({linearity=v[1]});if r32(0xbf6f00)~=v[2] then bad+=1 end end
    for _,v in ipairs(G.momentum) do V.setSteeringOptions({momentum=v[1]});if r32(0x74c990)~=v[2] then bad+=1 end end
    V.clearSteeringOptions();V.reset()
    check(string.format("option setters 005502f0 / 005500c0 (controls.cfg 0..100): %d original vectors",#G.linUI+#G.momentum),bad==0,bad>0 and (bad.." differ") or nil)
    -- L2 frame-start snapshots
    local function frameStart(sn)
        local cp=V.checkpoint()
        local b=b64(sn.before);local o=0
        for _,r in ipairs(sn.beforeRuns) do buffer.copy(M_,r[1]-BASE,b,o,4*r[2]);o+=4*r[2] end
        V._frameStartOnly(controlsOf(sn.controls))
        local a=b64(sn.after);o=0
        local n,diff=0,0
        for _,r in ipairs(sn.afterRuns) do
            for k=0,r[2]-1 do
                n+=1
                if r32(r[1]+4*k)~=buffer.readu32(a,o) then diff+=1 end
                o+=4
            end
        end
        V.restore(cp)
        return n,diff
    end
    for _,sc in ipairs(G.scenarios) do
        V.setRuntimeMode("original");V.endSession();V.clearSteeringOptions()
        if sc.ratio then
            local st=V.Setup.cupGarageDefault();V.Setup.set(st,"steeringRatio",sc.ratio);V.applySetup(st)
        else V.applySetup(V.Setup.cupGarageDefault()) end
        V.reset()
        if sc.steer then V.setSteeringOptions(sc.steer,true) end
        V.startSession({temperatureF=70,windSpeedMph=0,windDirection=0,conditions=0,night=false},{damageLevel=0,series=1})
        local nn,dd,cnt=0,0,0
        for i,sn in ipairs(sc.start) do
            if full or i<=sc.quick then
                local n,d=frameStart(sn);nn+=n;dd+=d;cnt+=1
            end
        end
        check(string.format("%s: %d frame starts from the original's traced state: %d written dwords bit-exact",sc.name,cnt,nn),dd==0,dd>0 and (dd.." differ") or nil)
    end
    V.applySetup(V.Setup.cupGarageDefault());V.clearSteeringOptions();V.endSession();V.reset()
    -- behaviour
    for _=1,8*60 do V.drive({throttle=0,clutch=1,steerAxis=-1},FLAT) end
    local ss=V.steeringState()
    check("analog full left at rest: road-wheel target pi / 7 (18:1 -> 7:1 below 8.94 m/s), cockpit wheel -2.79 rad (005662d0)",
        ss.target==fd(rf32(0x6f4a4c)/7) and ss.ratio==7 and math.abs(ss.wheelAngle+rf32(0x6f5e6c))<1e-6,
        string.format("target %.6f ratio %.3f wheel %.4f",ss.target,ss.ratio,ss.wheelAngle))
    V.setSteeringOptions({linearity=80,momentum=0,lowSpeedOverride=false})
    local st=V.Setup.cupGarageDefault();V.Setup.set(st,"steeringRatio",25)
    local okS=V.applySetup(st)
    local o=V.steeringOptions()
    check("options survive a garage rebuild; setup ratio 25 reaches 00554fb0 (override off)",okS and o.setupRatio==25 and o.steerRate==1
        and math.abs(o.linearity-0.8)<1e-6 and V.steerRatioOriginal()==25)
    V.clearSteeringOptions();V.applySetup(V.Setup.cupGarageDefault());V.reset()
    check("steering assistance > 0 refused (needs the NR2003 track racing line)",not pcall(V.setSteeringOptions,{assist=50}))
    check("arcade driving mode (race bit 25: also chassis spec 0 at build, 004233a0) refused",not pcall(V.setSteeringOptions,{yawLimiter=true})
        and V.steeringOptions().drivingMode=="simulation")
    if full then
        local function run(n,k0)
            local out={}
            for i=1,n do
                local k=k0+i
                local c={throttle=0.7,clutch=1,steerAxis=0.2*math.sin(k/20),shiftUp=k==40}
                for _=1,8 do V.drive(c,FLAT) end
                out[i]=r32(0xbf6360)..":"..r32(0xbf6d44)
            end
            return out
        end
        V.reset();local a=run(200,0)
        V.reset();local b=run(100,0);local cp=V.checkpoint();local b2=run(100,100);V.restore(cp);local b3=run(100,100)
        local same=true
        for k=1,100 do if a[k]~=b[k] or a[100+k]~=b2[k] or b2[k]~=b3[k] then same=false end end
        check("determinism + checkpoint/restore with the steering chain (200 frames)",same)
        V.reset()
    end
    print(string.format("[NR2003 Stage 12 self-test] %d passed, %d failed (%.1f s)",passed,failed,os.clock()-t0))
    return failed==0,lines
end
return M
