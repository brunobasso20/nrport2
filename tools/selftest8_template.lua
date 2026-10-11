-- Stage 8 Studio self-test (edit mode or Play, server side). Golden values embedded below were
-- produced by the ORIGINAL NR2003.exe code (Unicorn, recovery/stage8/gen_fixtures_stage8.py).
--   require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage8SelfTest).run()        -- quick (~1-3 s)
--   require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage8SelfTest).run(true)    -- full (4 braking runs)
local Core=script.Parent.Parent.Core
local Vehicle=require(Core.NR2003CupVehicle)
local G=__GOLDEN__
local M={}
local FLAT={}
for i=1,4 do FLAT[i]={0,0,1,0,0,0,0,1,1} end
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
-- write an ORIGINAL machine snapshot chunk {address, base64} into the core memory
local function loadChunk(V,addr,s)
    local M,o=V.memory(),addr-V.base
    for i=1,#s,4 do
        local a,b,c,d=string.byte(s,i,i+3)
        local x=B64[a]*262144+B64[b]*4096+(c~=61 and B64[c]*64 or 0)+(d~=61 and B64[d] or 0)
        buffer.writeu8(M,o,bit32.rshift(x,16));o+=1
        if c~=61 then buffer.writeu8(M,o,bit32.band(bit32.rshift(x,8),0xff));o+=1 end
        if d~=61 then buffer.writeu8(M,o,bit32.band(x,0xff));o+=1 end
    end
end
local function controls(s,frame)
    local row=s.controls[frame+1]
    if row[8]==0 then return {driver=false,throttle=0,clutch=0,steer=0} end
    local c={throttle=row[1],clutch=row[4],steer=row[5],shiftUp=row[6]==1,shiftDown=row[7]==1}
    if row[2]>=0 then c.brakeControl=row[2];c.brakeDigital=row[3]==1 end
    return c
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
-- Stage 11: golden data produced by the ORIGINAL code with the Stage 6-10 frame end -> explicit "frozen" runtime mode
if V.setRuntimeMode then V.setRuntimeMode("frozen") end if V.setSteeringMode then V.setSteeringMode("provisional") end
    check("load Core.NR2003Cup (Stage 8 driver layer)",V.brakePedalOriginal~=nil and V.setBrakeBias~=nil,string.format("%.2f s",os.clock()-t0))
    local w32,r32=V.w32,V.r32
    -- 00553080 pedal chain, bit level
    V.reset()
    local worst=0
    for _,r in ipairs(G.pedal) do
        local addrs={0xbf6d44,0xbf6d4c,0xbf6d54,0xbf6d58,0xbf6d5c,0xbf6d60,0xbf6d64,0xbf6390}
        for i,a in ipairs(addrs) do w32(a,r[i]) end
        w32(0xbf6eac,r[9])
        w32(0xd35b18+60,r[10]);w32(0xd37cc8+6*29,r[11]==1 and 0 or 1)
        w32(0xd35b18+50,r[12]);w32(0xd37cc8+5*29,r[13]==1 and 0 or 1)
        V.w8(0xbf6f04,r[14]);w32(0x74c97c,r[15]);w32(0xc067e0,r[16]);w32(0xc0692a+0x4c,r[17])
        w32(0xbf3cd4,r[18]);w32(0xbf470d,r[19]);w32(0xbf5146,r[20]);w32(0xbf5b7f,r[21])
        w32(0x74c994,r[22]);w32(0x74c998,r[23]);w32(0xbf63a4,r[24]);w32(0xbf63a8,r[25])
        V.wf32d(0xbf6eac,V.brakePedalOriginal())
        worst=math.max(worst,ulps(r32(0xbf6eac),r[26]))
    end
    check("00553080 pedal chain vs original ("..#G.pedal.." vectors)",worst<=1,"worst "..worst.." ulp")
    -- setup brake bias (garage item 0x28 -> 0055e9b0 cells)
    V.reset()
    local kb0,kb2=V.wheelBrake(0).kb,V.wheelBrake(2).kb
    V.setBrakeBias(60)
    local k60f,k60r=V.wheelBrake(0).kb,V.wheelBrake(2).kb
    check("brake bias cells: 74 % -> 2812/988, 60 % -> original rebuild values",kb0==2812 and math.abs(kb2-987.9999389648438)<1e-9
        and k60f==2279.999755859375 and k60r==1520.0001220703125,string.format("%.7g/%.7g %.7g/%.7g",kb0,kb2,k60f,k60r))
    -- braking phase vs the original: restart from the ORIGINAL machine state at the braking onset;
    -- chassis must stay inside the original's own 1-ulp sensitivity envelope of the braking phase
    local list=full and G.scenarios or {G.scenarios[1]}
    for _,s in ipairs(list) do
        V.reset()
        for _,ch in ipairs(s.snapshot) do loadChunk(V,ch[1],ch[2]) end
        V.tick=s.onset
        local st=table.create(45,0);local bad,pbad,last=0,0,nil
        local t=os.clock()
        for k=s.onset+1,s.ticks do
            V.drive(controls(s,(k-1)//8),FLAT)
            local row=s.rows[k]
            if row then
                V.state(st)
                for i=1,6 do
                    local o=row.orig[i]
                    local floor=(i%2==0) and 0.05 or 0.02 -- velocities: stick-slip settling of a stopped car
                    if math.abs(st[i]-o)>3*row.spread[i]+floor+0.01*math.abs(o) then bad+=1 end
                end
                local pedal=V.brakeState()
                if row.pedal and math.abs(pedal-row.pedal)>1e-6 then pbad+=1 end
                last={st[1],row.orig[1],row.spread[1],st[2],row.orig[2]}
            end
        end
        local dt=os.clock()-t
        check(s.name..": braking phase inside the original envelope ("..(s.ticks-s.onset).." ticks)",bad==0 and pbad==0,
            string.format("%d state / %d pedal outside | %.0f ticks/s | x lua %.2f orig %.2f (twin spread %.3f) | vx lua %.2f orig %.2f",bad,pbad,(s.ticks-s.onset)/dt,last[1],last[2],last[3],last[4],last[5]))
    end
    -- checkpoint/restore through braking (launch + brake onset of the first scenario)
    V.reset()
    local s=G.scenarios[1]
    for k=1,s.onset+64 do V.drive(controls(s,(k-1)//8),FLAT) end
    local cp=V.checkpoint();for k=s.onset+65,s.onset+264 do V.drive(controls(s,(k-1)//8),FLAT) end
    local a=V.state();V.restore(cp);for k=s.onset+65,s.onset+264 do V.drive(controls(s,(k-1)//8),FLAT) end
    local b=V.state();local same=true
    for i=1,45 do if a[i]~=b[i] then same=false end end
    check("checkpoint/restore bit-identical while braking",same)
    print(string.format("Stage 8 self-test: %d passed, %d failed",passed,failed))
    return failed==0,results
end
return M
