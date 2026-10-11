-- Stage 10 Studio self-test (edit mode or Play, server side). Golden values embedded below were
-- produced by the ORIGINAL NR2003.exe code (Unicorn: recovery/stage10/gen_setup_vectors.py, gen_fixtures10.py).
--   require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage10SelfTest).run()        -- quick (~3-6 s)
--   require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage10SelfTest).run(true)    -- full (+ more builds, 8 s drive)
local Core=script.Parent.Parent.Core
local Vehicle=require(Core.NR2003CupVehicle)
local G=__GOLDEN__
local M={}
local FLAT={}
for i=1,4 do FLAT[i]={0,0,1,0,0,0,0,1,1} end
local VAR_TOL=1e-3
local function relerr(a,b) return math.abs(a-b)/math.max(math.abs(a),math.abs(b),1e-3) end
local function mul32(a,b) local al,ah=a%65536,a//65536;return (al*b+((ah*b)%65536)*65536)%4294967296 end
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
    check("load Core.NR2003Cup (Stage 10: setup, build, generic callbacks, garage)",V.applySetup~=nil and V.Setup~=nil and V.setupStructure()=="image",string.format("%.2f s",os.clock()-t0))
    local Setup=V.Setup
    -- conversions (subset of the CLI vectors, both FPU control words)
    for _,mode in ipairs({"nearest","down"}) do
        local Vv,bad=G.vec[mode],0
        for _,v in ipairs(Vv.toInternal) do if Setup.toInternal(v[1],v[2],mode)~=v[3] then bad+=1 end end
        for _,v in ipairs(Vv.toDisplay) do if Setup.toDisplay(v[1],v[2],mode)~=v[3] then bad+=1 end end
        for _,v in ipairs(Vv.step) do
            local s=Setup.cupGarageDefault();s[v[1]]=v[2]
            local ch=Setup.step(s,v[1],v[3]==1,mode)
            if (ch and 1 or 0)~=v[4] or s[v[1]]~=v[5] then bad+=1 end
        end
        check(string.format("garage conversions / steps = original [%s] (%d vectors)",mode,#Vv.toInternal+#Vv.toDisplay+#Vv.step),bad==0,bad.." mismatches")
    end
    -- image windows of the reset image
    local P,BASE=V._pristine(),V.base
    local ru=buffer.readu32
    local VLO,VHI=0xebbf60-BASE,0xebf610-BASE
    local SOLVE={}
    for _,o in ipairs(G.solve) do SOLVE[o]=true end
    -- cells: aligned dwords outside the tyre objects + tyre fields at their own (unaligned) addresses
    local TY_LO,TY_STRIDE=0xbf3a20-BASE,0xa39
    local TY_HI=TY_LO+4*TY_STRIDE
    local CELLS={}
    for _,w in ipairs(G.windows) do
        for j=0,w[2]-4,4 do
            local off=w[1]+j
            if off+4<=TY_LO or off>=TY_HI then CELLS[#CELLS+1]=off end
        end
    end
    for wh=0,3 do for k=0,TY_STRIDE-4,4 do CELLS[#CELLS+1]=TY_LO+TY_STRIDE*wh+k end end
    local function hashVar()
        local h,vars=2166136261,{}
        for _,off in ipairs(CELLS) do
            local u=ru(P,off)
            if (off>=VLO and off<VHI) or SOLVE[off] then vars[off]=u else h=mul32(bit32.bxor(h,u),16777619) end
        end
        return h,vars
    end
    local imageHash=hashVar()
    -- cells computed in double by the port (variable cells, solve pass): the changed ones are compared with the
    -- original within 1e-3 relative / 2e-5 absolute (the CLI suite compares all of them)
    local function expectVars(e)
        local worst=0
        local S=buffer.create(8)
        for _,d in ipairs(e.var) do
            local u=ru(P,d[1])
            if u~=d[2] then
                buffer.writeu32(S,0,d[2]);buffer.writeu32(S,4,u)
                local x,y=buffer.readf32(S,0),buffer.readf32(S,4)
                local e2=relerr(x,y);if math.abs(x-y)<=2e-5 then e2=0 end;if e2~=e2 then e2=math.huge end
                worst=math.max(worst,e2)
            end
        end
        return worst
    end
    -- builds: setup item changes through the ORIGINAL car build (hash outside the JIT variable cells)
    local list=full and G.items or G.itemsQuick
    local bad,report,nat,gen,tmax=0,"",0,0,0
    for _,e in ipairs(list) do
        local s=Setup.cupGarageDefault();s[e.item]=e.raw
        local t=os.clock()
        local ok,rep=V.applySetup(s)
        tmax=math.max(tmax,os.clock()-t)
        if rep.structure=="natural" then nat+=1 else gen+=1 end
        local h,vars=hashVar()
        local w=expectVars(e)
        if not (ok and rep.structure==e.structure and rep.pool==e.pool and rep.litTop==e.litTop and h==e.hash and w<=VAR_TOL) then
            bad+=1
            if report=="" then report=string.format("item %d %s: ok %s %s/%s hash %s var %.1e %s",e.item,e.tag,tostring(ok),tostring(rep.structure),e.structure,tostring(h==e.hash),w,tostring(rep.firstViolation)) end
        end
    end
    check(string.format("setup items through the ORIGINAL build = original (%d builds: %d natural, %d generic)",#list,nat,gen),bad==0,bad>0 and report or string.format("max %.2f s per applySetup",tmax))
    -- default: image restored bit for bit
    local ok,rep=V.applySetup(Setup.cupGarageDefault())
    local h=hashVar()
    check("applySetup(default) restores the shipped image (exact Stage 6-9 state)",ok and rep.structure=="image" and h==imageHash)
    -- dynamics with a non-default setup vs the ORIGINAL runtime with that setup
    local D=G.dyn
    local s=Setup.cupGarageDefault()
    for i,raw in pairs(D.items) do s[i]=raw end
    local ok2,rep2=V.applySetup(s)
    local ref=rep2.structure=="generic" and D.gen or D.orig
    local n,worst,bad2,st=0,0,0,table.create(45,0)
    local want={}
    for k,r in ipairs(D.orig) do want[r[1]]=k end
    local ticks=full and D.ticks or D.first
    for k=1,ticks do
        local c=D.controls[(k-1)//8+1]
        V.drive({throttle=c[1],brake=c[2],clutch=c[3],steer=c[4],shiftUp=c[5],shiftDown=c[6]},FLAT)
        local idx=want[k]
        if idx then
            V.state(st)
            if idx<=D.first then
                for i=1,45 do worst=math.max(worst,relerr(st[i],ref[idx][i+1])) end
            else
                local o=D.orig[idx]
                for i=1,6 do
                    local spread=0
                    for m=math.max(1,idx-1),math.min(#D.orig,idx+1) do
                        spread=math.max(spread,math.abs(D.pert[m][i+1]-D.orig[m][i+1]),math.abs(D.gen[m][i+1]-D.orig[m][i+1]))
                    end
                    local env=3*spread+0.02+0.01*math.abs(o[i+1])
                    if math.abs(st[i]-o[i+1])>env then bad2+=1 end
                end
                n+=1
            end
        end
    end
    check(string.format("%s setup (%s): first %d ticks = original (rel <= 2e-5)%s",D.name,tostring(rep2.structure),D.first,full and ", 8 s within the original envelope" or ""),
        ok2 and worst<=2e-5 and bad2==0,string.format("worst %.2e, %d samples, %d outside",worst,n,bad2))
    V.applySetup(Setup.cupGarageDefault())
    print(string.format("Stage 10 self-test: %d passed, %d failed",passed,failed))
    return failed==0,results
end
return M
