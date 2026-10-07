-- Stage 9 Studio self-test (edit mode or Play, server side). Golden values embedded below were
-- produced by the ORIGINAL NR2003.exe code (Unicorn, recovery/stage9/gen_fixtures_stage9.py).
--   require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage9SelfTest).run()        -- quick (~1-3 s)
--   require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage9SelfTest).run(true)    -- full (+ driving runs)
local Core=script.Parent.Parent.Core
local Vehicle=require(Core.NR2003CupVehicle)
local G=__GOLDEN__
local M={}
local FLAT={}
for i=1,4 do FLAT[i]={0,0,1,0,0,0,0,1,1} end
local S=buffer.create(8)
local function fb(u) buffer.writeu32(S,0,u);return buffer.readf32(S,0) end
local function bf(x) buffer.writef32(S,0,x);return buffer.readu32(S,0) end
local function ulps(a,b)
    if a==b then return 0 end
    local function ord(u) if u>=0x80000000 then return 0x80000000-u end return u end
    return math.abs(ord(a)-ord(b))
end
local B64={}
do
    local chars="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    for i=1,64 do B64[string.byte(chars,i)]=i-1 end
end
local function loadChunk(V,addr,s)
    local Mm,o=V.memory(),addr-V.base
    for i=1,#s,4 do
        local a,b,c,d=string.byte(s,i,i+3)
        local x=B64[a]*262144+B64[b]*4096+(c~=61 and B64[c]*64 or 0)+(d~=61 and B64[d] or 0)
        buffer.writeu8(Mm,o,bit32.rshift(x,16));o+=1
        if c~=61 then buffer.writeu8(Mm,o,bit32.band(bit32.rshift(x,8),0xff));o+=1 end
        if d~=61 then buffer.writeu8(Mm,o,bit32.band(x,0xff));o+=1 end
    end
end
local function controls(s,frame)
    local row=s.controls[frame+1]
    if row[8]==0 then return {driver=false,throttle=0,clutch=0,steer=0} end
    local c={throttle=row[1],clutch=row[4],steer=row[5],shiftUp=row[6]==1,shiftDown=row[7]==1}
    if row[2]>=0 then c.brakeControl=row[2];c.brakeDigital=row[3]==1 end
    return c
end
local function draftEnv(V,d)
    local x,y=V.rf32(0xbf6d40),V.rf32(0xbf6d48)
    local L=5000
    local o={lapDistance=(x+d[1])%L,lateral=y+d[2],vx=V.rf32(0xbf6d44),vy=V.rf32(0xbf6d4c),vz=V.rf32(0xbf6d54),wakeStrength=1,wakeLength=1}
    return {trackLength=L,lapDistance=x%L,lateral=y,ahead={o},behind={o}}
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
    check("load Core.NR2003Cup (Stage 9 aero module)",V.startSession~=nil and V.aeroState~=nil and V.draftingOriginal~=nil,string.format("%.2f s",os.clock()-t0))
    local w32,r32=V.w32,V.r32
    local AIR,CAR,HOST=0xe0b840,0xc12030,0xf7f100
    local BLOCK,OUT6,TOBJ=HOST+0x600,HOST+0x640,HOST+0x680
    -- constants embedded by the hand port = NR2003.exe bytes
    local cbad=0
    for _,c in ipairs(G.cells) do
        local mine=V._aeroConstants[c[1]];if mine==nil then mine=V._aeroDamageCells[c[1]] end
        if mine~=c[2] then cbad+=1 end
    end
    check("embedded constants / damage-table cells = NR2003.exe ("..#G.cells.." cells)",cbad==0,cbad.." mismatching")
    V.reset()
    check("post-build state without a session: no air (rho 0), as in Stages 6-8",r32(AIR+12)==0 and not V.sessionActive())
    -- 005a3c00 session weather
    local worst=0
    for _,r in ipairs(G.weather) do
        V.startSession({temperatureF=r[1],conditions=r[2],night=r[3]==1,windSpeedMph=r[4],windDirection=r[5],trackNorth=fb(r[6])})
        for k=1,4 do worst=math.max(worst,ulps(r32(AIR+4*(k-1)),r[6+k])) end
    end
    V.endSession()
    check("005a3c00 weather -> wind / density ("..#G.weather.." vectors) bit-exact",worst==0,"worst "..worst.." ulp")
    worst=0
    for _,r in ipairs(G.density) do worst=math.max(worst,ulps(bf(V.airDensityOriginal(fb(r[1]),fb(r[2]),fb(r[3]))),r[4])) end
    check("005a3ba0 density ("..#G.density.." vectors) <= 1 ulp",worst<=1,"worst "..worst.." ulp")
    -- lifted aero natives
    worst=0
    for _,r in ipairs(G.halfwind) do
        w32(AIR,r[1]);w32(AIR+4,r[2]);w32(AIR+8,r[3]);w32(TOBJ+0x24,r[4]);w32(TOBJ+0x28,r[5]);w32(TOBJ+0x2c,r[6])
        w32(CAR+0x5ae,r[7]==1 and TOBJ or 0)
        V._callx(0x561a80)
        for k=1,3 do worst=math.max(worst,ulps(r32(G.halfwindCells[k]),r[7+k])) end
    end
    w32(CAR+0x5ae,0);w32(AIR,0);w32(AIR+4,0);w32(AIR+8,0)
    check("00561a80 half wind ("..#G.halfwind.." vectors) <= 1 ulp",worst<=1,"worst "..worst.." ulp")
    V.reset()
    local cells={AIR+12,CAR+0x59e,CAR+0x5a2,CAR+0x5a6,0xc083c4,G.aeroCells[1],G.aeroCells[2],0xc084c8,0xc084cc,
        0xc055c0+4*0x3b,0xc055c0+4*0x3d,0xc055c0+4*0x20,0xc055c0+4*0x21,0x74e090,0x7636e0,0x7636e4,0x71f904}
    local maxRel=0
    for _,r in ipairs(G.aero) do
        for k,a in ipairs(cells) do w32(a,r[k]) end
        for k=0,5 do w32(BLOCK+4*k,OUT6+4*k);w32(BLOCK+24+4*k,r[18+k]) end
        for k=0,10 do w32(CAR+0x14a3+4*k,r[24+k]) end
        V._callx(0x561b70,BLOCK)
        for k=0,5 do
            local g,o=fb(r32(OUT6+4*k)),fb(r[35+k])
            maxRel=math.max(maxRel,math.abs(g-o)/math.max(math.abs(g),math.abs(o),1e-2))
        end
    end
    V.reset()
    check("00561b70 aero force/moment ("..#G.aero.." vectors) rel <= 1e-5",maxRel<=1e-5,string.format("worst rel %.2e",maxRel))
    worst=0
    for _,r in ipairs(G.wake) do worst=math.max(worst,ulps(bf(V.fd(V.wakeOriginal(fb(r[1]),fb(r[2])))),r[3])) end
    check("005b0230 wake ("..#G.wake.." vectors) <= 1 ulp",worst<=1,"worst "..worst.." ulp")
    worst=0
    for _,r in ipairs(G.draft) do
        w32(CAR+0x59e,r[4]);w32(CAR+0x5a2,r[5]);w32(CAR+0x5a6,r[6])
        local cars,rev={},{}
        for _,c in ipairs(r[10]) do cars[#cars+1]={lapDistance=fb(c[1]),lateral=fb(c[2]),vx=fb(c[3]),vy=fb(c[4]),vz=fb(c[5]),wakeStrength=fb(c[6]),wakeLength=fb(c[7])} end
        for i=#cars,1,-1 do rev[#rev+1]=cars[i] end
        V.draftingOriginal({trackLength=fb(r[1]),lapDistance=fb(r[2]),lateral=fb(r[3]),ahead=cars,behind=rev})
        worst=math.max(worst,ulps(r32(CAR+0x59e),r[7]),ulps(r32(CAR+0x5a2),r[8]),ulps(r32(CAR+0x5a6),r[9]))
    end
    V.reset()
    check("005afd80 drafting ("..#G.draft.." race rings) <= 1 ulp",worst<=1,"worst "..worst.." ulp")
    local gbad=0
    for _,r in ipairs(G.tape) do V.setAeroSetup({grilleTape=r[1],spoiler=65});if r32(0xc055c0+4*0x3b)~=r[2] then gbad+=1 end end
    for _,r in ipairs(G.spoiler) do V.setAeroSetup({grilleTape=0,spoiler=r[1]});if r32(0xc055c0+4*0x3d)~=r[2] then gbad+=1 end end
    V.reset()
    check("garage grille tape / spoiler conversions (00423de0 / 004241d0)",gbad==0,gbad.." mismatches")
    -- original snapshot at speed: telemetry = original 00561b70, then 2 frames vs the original
    local list=full and G.scenarios or {G.scenarios[1]}
    for _,s in ipairs(list) do
        V.reset();V.endSession();V.setDraftEnvironment(nil);V.setTrackNormal(nil)
        V.startSession(s.weather)
        if s.draft then V.setTrackNormal({0,0,1}) end
        for _,ch in ipairs(s.snapshot) do loadChunk(V,ch[1],ch[2]) end
        V.tick=s.onset
        local a=V.aeroState()
        local got={a.fx,a.fy,a.fz,a.mx,a.my,a.mz};local aw=0
        for k=1,6 do aw=math.max(aw,ulps(bf(got[k]),s.aero[k])) end
        local st=table.create(45,0);local bad,last=0,nil
        local t=os.clock()
        for k=s.onset+1,s.ticks do
            if s.draft and (k-1)%8==0 then V.setDraftEnvironment(draftEnv(V,s.draft)) end
            V.drive(controls(s,(k-1)//8),FLAT)
            local row=s.rows[k]
            if row then
                V.state(st)
                for i=1,6 do
                    local o=row.orig[i]
                    local floor=(i%2==0) and 0.05 or 0.02
                    if math.abs(st[i]-o)>3*row.spread[i]+floor+0.01*math.abs(o) then bad+=1 end
                end
                last={st[1],row.orig[1],st[2],row.orig[2]}
            end
        end
        local dt=os.clock()-t
        check(s.name..": aero telemetry = original 00561b70 at the snapshot; run inside the original envelope ("..(s.ticks-s.onset).." ticks)",
            aw<=1 and bad==0,string.format("aero worst %d ulp, %d outside | %.0f ticks/s | x lua %.1f orig %.1f | vx lua %.2f orig %.2f",aw,bad,(s.ticks-s.onset)/dt,last[1],last[2],last[3],last[4]))
    end
    -- API
    V.reset();V.endSession();V.setDraftEnvironment(nil);V.setTrackNormal(nil)
    V.startSession(nil)
    check("startSession() defaults: rho 1.08119202 kg/m^3 (70 F, sun, day)",r32(AIR+12)==bf(1.08119202))
    for k=1,800 do V.drive({throttle=1,clutch=1,brakeControl=0,brakeDigital=true,shiftUp=(k==150 or k==500)},FLAT) end
    local cp=V.checkpoint();for k=801,1200 do V.drive({throttle=1,clutch=1,brakeControl=0,brakeDigital=true},FLAT) end
    local a1=V.state();V.restore(cp);for k=801,1200 do V.drive({throttle=1,clutch=1,brakeControl=0,brakeDigital=true},FLAT) end
    local b1=V.state();local same=true
    for i=1,45 do if a1[i]~=b1[i] then same=false end end
    check("checkpoint/restore bit-identical with session air",same)
    V.endSession()
    print(string.format("Stage 9 self-test: %d passed, %d failed",passed,failed))
    return failed==0,results
end
return M
