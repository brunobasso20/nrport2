-- Stage 11 Studio self-test (edit mode or Play, server side). Golden values embedded below were produced by the
-- ORIGINAL NR2003.exe code executed in Unicorn (recovery/stage11/gen_fixtures11.py, scenario 'cold': 40 F, race
-- option damage 0, full-throttle launch):
--   require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage11SelfTest).run()      -- quick (~3-5 s)
--   require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage11SelfTest).run(true)  -- + 10 s drives (determinism, A/B)
local Core=script.Parent.Parent.Core
local Vehicle=require(Core.NR2003CupVehicle)
local G=__GOLDEN__
local M={}
local FLAT={}
for i=1,4 do FLAT[i]={0,0,1,0,0,0,0,1,1} end
-- scenarios11.law_launch (exact copy): full throttle for 30 s, brake 30..36 s, upshifts at frames 40 / 110 / 200
local function launch(k)
    local t=k/36
    return {throttle=t<30 and 1 or 0,clutch=1,steer=0,brakeControl=(t>=30 and t<36) and 1 or 0,brakeDigital=true,
        shiftUp=(k==40 or k==110 or k==200),shiftDown=false}
end
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
function M.run(full)
    local results,passed,failed={},0,0
    local function check(name,ok,detail)
        if ok then passed+=1 else failed+=1 end
        local line=(ok and "PASS  " or "FAIL  ")..name..(detail and ("  "..detail) or "")
        results[#results+1]=line;print(line)
    end
    local t0=os.clock()
    local car=Vehicle.new(Core.NR2003Cup);local V=car.V
    check("load Core.NR2003Cup with the Stage 11 runtime (original frame end lifted from NR2003.exe)",
        V.stage11State~=nil and V.runtimeMode()=="original",string.format("%.2f s, supplement %d bytes",os.clock()-t0,V._stage11Supplement or -1))
    local Mem,BASE=V.memory(),V.base
    local r32=V.r32
    -- data cells of the protected fuel double (pointer triple at engine+0x50c; the pool never moves): a 1-ulp
    -- difference of the value (x87 80-bit vs IEEE double accumulation, documented) changes their low bits
    local fuelWords={}
    do
        local E=0xc12030+0xc
        for slot=0,1 do local p=r32(E+0x50c+4*slot);fuelWords[p]=true;fuelWords[p+4]=true end
    end
    local function load(runs,s)
        local b,o=b64(s),0
        for _,r in ipairs(runs) do buffer.copy(Mem,r[1]-BASE,b,o,4*r[2]);o+=4*r[2] end
    end
    local function compare(runs,s)
        local b,o,n,bad,first=b64(s),0,0,0,nil
        for _,r in ipairs(runs) do
            for k=0,r[2]-1 do
                local a=r[1]+4*k;local want=buffer.readu32(b,o);o+=4;n+=1
                if want~=r32(a) and not fuelWords[a] then bad+=1;first=first or string.format("%08x",a) end
            end
        end
        return n,bad,first
    end
    local function drive(frames)
        for k=0,frames-1 do local c=launch(k);for _=1,8 do V.drive(c,FLAT) end end
    end
    -- session start (weather 40 F, race option damage 0) + car placed on the track (00550a50 subset)
    V.setRuntimeMode("original");if V.setSteeringMode then V.setSteeringMode("provisional") end;V.endSession();V.reset()
    V.startSession({temperatureF=40},{damageLevel=0})
    local n,bad,first=compare(G.touchRuns,G.start)
    check(string.format("session start = original (%d dwords: engine, fuel, 4 new tyres, damage repaired, options)",n),bad==0,bad>0 and (bad.." differ, first "..first) or nil)
    -- one complete frame end from the ORIGINAL state of frame 120 (tyres at the 505 K limit, engine, fuel, smoke)
    local cp=V.checkpoint()
    load(G.touchRuns,G.before)
    V._frameEnd()
    local n2,bad2,first2=compare(G.writeRuns,G.after)
    check(string.format("frame end 00554520 + 00549c40 from the original state = original (%d dwords; fuel double within 1 ulp)",n2),bad2==0,bad2>0 and (bad2.." differ, first "..first2) or nil)
    V.restore(cp)
    -- first 0.5 s of the drive vs the original (tight: the original's own 1-ulp twins agree to < 2e-5 here)
    drive(18)
    local s=V.stage11State();local x=V.state()
    local mine={s.fuel.kg,s.engine.water,s.engine.oil,s.tyres[3].surface[2],s.tyres[3].carcass[2],s.tyres[1].brake,x[1],x[2],x[5]}
    local worst=0
    for i,v in ipairs(mine) do
        local w=G.row18[i];local d=math.abs(v-w);if d>1e-6 then worst=math.max(worst,d/math.max(math.abs(w),1e-6)) end
    end
    check("0.5 s drive = original (fuel, water, oil, LR tyre temperatures, LF brake, chassis x / vx / z; <= 2e-5 relative)",worst<=2e-5,string.format("worst %.2e",worst))
    if full then
        -- determinism + checkpoint/restore over 10 s, then the frozen A/B mode
        local function run10()
            V.endSession();V.reset();V.startSession({temperatureF=40},{damageLevel=0})
            drive(360)
            local a=V.stage11State();return {a.fuel.kg,a.engine.water,a.tyres[3].wear,a.tyres[3].surface[1],a.random}
        end
        local a,b=run10(),run10()
        local same=true;for i=1,#a do if a[i]~=b[i] then same=false end end
        check("10 s drive twice: Stage 11 state bit-identical (determinism)",same,string.format("fuel %.4f kg water %.2f C LR wear %.4f",a[1],a[2],a[3]))
        V.setRuntimeMode("frozen");V.endSession();V.reset()
        local f0=V.stage11State().fuel.kg
        for _=1,288 do V.drive({throttle=1,clutch=1},FLAT) end
        check("frozen A/B mode keeps the post-build Stage 11 state (Stage 6-10 comparisons only)",V.stage11State().fuel.kg==f0)
        V.setRuntimeMode("original")
    end
    V.endSession();V.reset()
    print(string.format("Stage 11 self-test: %d passed, %d failed",passed,failed))
    return failed==0,results
end
return M
