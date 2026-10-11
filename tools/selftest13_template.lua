-- Stage 13 Studio self-test (edit mode or Play, server side). Golden values embedded below were produced by the
-- ORIGINAL NR2003.exe code executed in Unicorn (recovery/stage13: gen_units13.py / gen_fixtures13.py):
--   require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage13SelfTest).run()      -- quick (~1-3 s)
--   require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage13SelfTest).run(true)  -- + determinism / checkpoint run
-- What it checks (subset of tests/stage13/run.luau): the exact x87 arithmetic of the port (64-bit significand, round
-- toward -inf) against the exact reference, the ORIGINAL 00554d30 and the FFB block of 00554520 vector by vector, the
-- ORIGINAL 00550070 / 0054fed0 / 00550680 decisions with the device-call sequence, the option setters, the original's own
-- 00554d30 / FFB-block calls traced in a closed-loop run (bit-exact), and the behaviour (keys never acquire the effect,
-- an analog axis does, controls suspended = 005524f0 not-driven + FFB gated + zero force, options survive reset).
local G=__GOLDEN__
local Core=script.Parent.Parent.Core
local Vehicle=require(Core.NR2003CupVehicle)
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
    return out,o
end
local S=buffer.create(8)
local function fb(u) buffer.writeu32(S,0,u);return buffer.readf32(S,0) end
local function bits(x) buffer.writef32(S,0,x);return buffer.readu32(S,0) end
local function dbl(hi,lo) buffer.writeu32(S,4,hi);buffer.writeu32(S,0,lo);return buffer.readf64(S,0) end
local function dbits(x) buffer.writef64(S,0,x);return buffer.readu32(S,4),buffer.readu32(S,0) end
-- packed u32 records: (string, record length) -> iterator of buffers offsets
local function records(s,len)
    local b,n=b64(s)
    local k=-1
    return function()
        k+=1
        if 4*len*(k+1)>n then return nil end
        return b,4*len*k
    end
end
local ru=buffer.readu32
local SUSPENDED,ACQUIRED,AXIS,DIRSIGN=0xbf6eb8,0xbf6ebb,0xbf6ebc,0x74c95c
local FF_ON,STRENGTH,DAMPING,LATENCY=0xbf6f1c,0x74c9a4,0xbf6f24,0xbf6f20
local REC7=0xd37cb8+29*7
local ACC={0xbf6ed4,0xbf6ed8,0xbf6edc,0xbf6ee0,0xbf6ee4,0xbf6ee8,0xbf6eec,0xbf6ef0}
local OUTS={0x74c960,0xbf6ec4,0xbf6ec8,0xbf6ed0}
local BLOCK_IN={0xbf6ec4,0xbf6ec0,0xbf6ecc,0xbf6ed0,0xbf3a00,LATENCY,DAMPING,STRENGTH,0xc055c0+4*0x30}

function M.run(full)
    local t0=os.clock()
    local passed,failed,lines=0,0,{}
    local function check(name,ok,detail)
        if ok then passed+=1 else failed+=1 end
        local line=(ok and "PASS  " or "FAIL  ")..name..(detail and ("  "..detail) or "")
        table.insert(lines,line);print("[NR2003 Stage 13 self-test] "..line)
    end
    local car=Vehicle.new(Core:WaitForChild("NR2003Cup"))
    local V=car.V
    check("Stage 13 force feedback installed (NR2003CupFFB)",V.setForceFeedbackOptions~=nil and V.x87~=nil)
    if not V.setForceFeedbackOptions then return false,lines end
    local r32,rf32,w32,wf32,r8,w8=V.r32,V.rf32,V.w32,V.wf32,V.r8,V.w8
    local X=V.x87
    V.setRuntimeMode("original");V.setSteeringMode("original");V.endSession();V.clearSteeringOptions();V.clearForceFeedbackOptions()
    V.setForceFeedbackDevice({capable=false});V.reset()
    check("image defaults: FF off, strength 80, damping 0, latency 0, not acquired, controls active",
        r8(FF_ON)==0 and rf32(STRENGTH)==80 and rf32(DAMPING)==0 and rf32(LATENCY)==0 and r8(ACQUIRED)==0 and r8(SUSPENDED)==0)
    -- exact x87 arithmetic: records a(hi,lo,hi,lo) b(..) r(..)
    local bad,n=0,0
    for _,op in ipairs({"add","mul","div"}) do
        for b,o in records(G.x87[op],12) do
            n+=1
            local h,l=X[op](dbl(ru(b,o),ru(b,o+4)),dbl(ru(b,o+8),ru(b,o+12)),dbl(ru(b,o+16),ru(b,o+20)),dbl(ru(b,o+24),ru(b,o+28)))
            local hh,hl=dbits(h);local lh,ll=dbits(l)
            local eh,el=ru(b,o+32),ru(b,o+36)
            if hh~=eh or hl~=el or l~=dbl(ru(b,o+40),ru(b,o+44)) then bad+=1 end
        end
    end
    for b,o in records(G.x87.f32,5) do
        n+=1
        if bits(X.f32(dbl(ru(b,o),ru(b,o+4)),dbl(ru(b,o+8),ru(b,o+12))))~=ru(b,o+16) then bad+=1 end
    end
    check(string.format("exact x87 arithmetic (64-bit significand, round toward -inf) + FST dword: %d vectors",n),bad==0,bad>0 and (bad.." differ") or nil)
    -- 00554d30: n_LF, n_RF, A/B/C/D (8), outs (4), cleared
    bad,n=0,0
    for b,o in records(G.stats,15) do
        n+=1
        w32(0x74c964,ru(b,o));w32(0x74c968,ru(b,o+4))
        for k=1,8 do w32(ACC[k],ru(b,o+4+4*k)) end
        V.ffbStatsOriginal()
        for k=1,4 do if r32(OUTS[k])~=ru(b,o+36+4*k) then bad+=1;break end end
    end
    check(string.format("00554d30 front tyre statistics: %d original vectors bit-exact",n),bad==0,bad>0 and (bad.." differ") or nil)
    -- FFB block: ebb, eb8, 9 inputs, ec0', ecc', calls, force
    local trace={}
    V._ffbTrace(trace)
    bad,n=0,0
    for b,o in records(G.block,15) do
        n+=1
        w8(ACQUIRED,ru(b,o));w8(SUSPENDED,ru(b,o+4));w32(AXIS,5)
        for k=1,9 do w32(BLOCK_IN[k],ru(b,o+4+4*k)) end
        table.clear(trace)
        V._ffbFrameEnd()
        local nf,force=0,0
        for _,t in ipairs(trace) do if t[1]=="force" then nf+=1;force=bits(t[3]) end end
        if not (r32(0xbf6ec0)==ru(b,o+44) and r32(0xbf6ecc)==ru(b,o+48) and nf==ru(b,o+52) and (nf==0 or force==ru(b,o+56))) then bad+=1 end
    end
    check(string.format("FFB block of 00554520 (0055464c..0055479d): %d original vectors bit-exact (state + 005d08d0 force)",n),bad==0,bad>0 and (bad.." differ") or nil)
    -- traced calls of the original's closed-loop run (slalom / suspend)
    bad,n=0,0
    for b,o in records(G.tracedStats,15) do
        n+=1
        w32(0x74c964,ru(b,o+4));w32(0x74c968,ru(b,o+8))
        for k=1,8 do w32(ACC[k],ru(b,o+8+4*k)) end
        V.ffbStatsOriginal()
        for k=1,4 do if r32(OUTS[k])~=ru(b,o+40+4*k) then bad+=1;break end end
    end
    local nb=0
    for b,o in records(G.tracedBlocks,17) do
        nb+=1
        w8(ACQUIRED,ru(b,o+4));w8(SUSPENDED,ru(b,o+8))
        for k=1,9 do w32(BLOCK_IN[k],ru(b,o+8+4*k)) end
        w32(AXIS,ru(b,o+48))
        table.clear(trace)
        V._ffbFrameEnd()
        local nf,force=0,0
        for _,t in ipairs(trace) do if t[1]=="force" then nf+=1;force=bits(t[3]) end end
        if not (r32(0xbf6ec0)==ru(b,o+52) and r32(0xbf6ecc)==ru(b,o+56) and nf==ru(b,o+60) and (nf==0 or force==ru(b,o+64))) then bad+=1 end
    end
    check(string.format("closed loop: %d 00554d30 calls + %d FFB blocks traced in the ORIGINAL's run: bit-exact",n,nb),bad==0,bad>0 and (bad.." differ") or nil)
    -- 00550070 -> 0054fed0 / 00550030: in (flag, kind, axis, dir, ebb, prevAxis, ffon, cap, acq, eff), out (eb8, ebb, axis, sign, eff), log
    bad,n=0,0
    local KIND={force=0,acquire=1,release=2}
    for _,v in ipairs(G.controls) do
        n+=1
        local i=v[1]
        w32(REC7+0x10,i[2]);w32(REC7+0x14,i[3]);w8(REC7+0x1c,i[4])
        w8(ACQUIRED,i[5]);w32(AXIS,i[6]);w32(DIRSIGN,0x55);w8(FF_ON,i[7]);w8(SUSPENDED,0x33)
        V._ffbHostState(i[8]==1,i[9]==1,i[10]==1)
        table.clear(trace)
        V._ffbControls(i[1])
        local _,_,effect=V._ffbHostState()
        local o=v[2]
        local ok=r8(SUSPENDED)==o[1] and r8(ACQUIRED)==o[2] and r32(AXIS)==o[3] and r32(DIRSIGN)==o[4] and (effect and 1 or 0)==o[5]
            and #trace==#v[3]
        if ok then
            for k,t in ipairs(trace) do
                local w=v[3][k]
                if KIND[t[1]]~=w[1] or t[2]~=w[2] or (t[1]=="force" and bits(t[3])~=w[3]) then ok=false end
            end
        end
        if not ok then bad+=1 end
    end
    V._ffbTrace(nil);V._ffbHostState(false,true,false)
    check(string.format("00550070 / 0054fed0 / 00550030: %d original cases (state + device-call sequence)",n),bad==0,bad>0 and (bad.." differ") or nil)
    -- setters (controls.cfg integers)
    bad=0
    for _,v in ipairs(G.setters) do
        local o={};o[v[1]]=v[2]
        V.setForceFeedbackOptions(o)
        local cell=({strength=STRENGTH,damping=DAMPING,latency=LATENCY})[v[1]]
        if r32(cell)~=v[3] then bad+=1 end
    end
    V.clearForceFeedbackOptions();V.reset()
    check(string.format("FF option setters 00550290 / 005502d0 / 005502b0: %d original vectors",#G.setters),bad==0,bad>0 and (bad.." differ") or nil)
    -- behaviour
    V.applySetup(V.Setup.cupGarageDefault());V.reset()
    V.setForceFeedbackDevice({capable=true})
    V.setForceFeedbackOptions({enabled=true,strength=64,damping=12,latency=30})
    V.startSession(nil,{})
    for _=1,8 do V.drive({throttle=0.3,clutch=1,brakeControl=0,steerLeft=0,steerRight=0,steerDigital=true},FLAT) end
    local s1=V.forceFeedbackState()
    for _=1,8 do V.drive({throttle=0.3,clutch=1,brakeControl=0,steerAxis=0.05},FLAT) end
    local s2=V.forceFeedbackState()
    check("keys: effect never acquired; analog axis: acquired by 0054fed0, block runs at the frame end",
        not s1.acquired and not s1.blockRan and s2.acquired and s2.blockRan)
    V.setControlsSuspended(true)
    for _=1,8 do V.drive({throttle=1,clutch=1,brakeControl=0,steerAxis=0.05},FLAT) end
    local s3=V.forceFeedbackState()
    local nd=rf32(0xbf6eac)==1 and rf32(0xbf6390)==0
    V.setControlsSuspended(false)
    for _=1,8 do V.drive({throttle=0.3,clutch=1,brakeControl=0,steerAxis=0.05},FLAT) end
    local s4=V.forceFeedbackState()
    check("controls suspended (00550070(1)): 005524f0 not-driven branch, FFB gated, zero force; resume runs it again",
        nd and s3.suspended and not s3.blockRan and s3.force==0 and not s4.suspended and s4.blockRan)
    V.reset()
    local o=V.forceFeedbackOptions()
    check("FF options survive reset()",o.enabled and o.strength==64 and o.damping==12 and o.latency==30)
    if full then
        local cp=V.checkpoint()
        local function runN(out)
            for k=1,400 do
                V.drive({throttle=0.6,clutch=1,brakeControl=0,steerAxis=0.1*math.sin(k/50)},FLAT)
                if k%8==0 then table.insert(out,bits(V.forceFeedbackState().force)) end
            end
        end
        local a,b={},{}
        runN(a);V.restore(cp);runN(b)
        local same=#a==#b and #a==50
        for i=1,#a do if a[i]~=b[i] then same=false end end
        check("deterministic FFB output, checkpoint / restore bit-identical",same)
    end
    V.endSession();V.clearForceFeedbackOptions();V.setForceFeedbackDevice({capable=false});V.reset()
    print(string.format("[NR2003 Stage 13 self-test] %d PASS, %d FAIL (%.2f s)",passed,failed,os.clock()-t0))
    return failed==0,lines
end
return M
