-- Stage 6/7 Studio self-test (edit mode or Play, server side). Golden values embedded below were
-- produced by the ORIGINAL NR2003.exe code (Unicorn, recovery/stage6_7/gen_fixtures.py).
--   require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage67SelfTest).run()        -- quick (~1-3 s)
--   require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage67SelfTest).run(true)    -- full (2 x 2304 ticks)
local Core=script.Parent.Parent.Core
local Vehicle=require(Core.NR2003CupVehicle)
local G=__GOLDEN__
local M={}
local FLAT={}
for i=1,4 do FLAT[i]={0,0,1,0,0,0,0,1,1} end
local function rawInputs(k)
    local t=k/288
    if t<1 then return {gear=1} end
    if t<4 then return {gear=2,clutch=1,throttle=1} end
    if t<5.5 then return {gear=2,clutch=1,throttle=0.6,lfSteer=0.04,rfSteer=0.035} end
    return {gear=2,clutch=1,throttle=0,brake=0.7}
end
local function controls(frame)
    local c=G.controls[frame+1]
    return {throttle=c[1],brake=c[2],clutch=c[3],steer=c[4],shiftUp=c[5],shiftDown=c[6]}
end
local function relerr(a,b) return math.abs(a-b)/math.max(math.abs(a),math.abs(b),1e-3) end
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
    check("load Core.NR2003Cup",true,string.format("%.2f s",os.clock()-t0))
    local horizon=full and 2304 or 576
    for _,kind in ipairs({"raw","drive"}) do
        V.reset()
        local g=G[kind];local s=table.create(45,0);local worst,bad,mism=0,0,0;local last
        local t=os.clock()
        for k=1,horizon do
            if kind=="raw" then V.stepRaw(rawInputs(k),FLAT) else V.drive(controls((k-1)//8),FLAT) end
            local early=g.early[k];local row=g.rows[k]
            if early or row then V.state(s) end
            if early then for i=1,45 do worst=math.max(worst,relerr(s[i],early[i])) end end
            if row then
                for i=1,6 do
                    local o,p=row.orig[i],row.pert[i]
                    if math.abs(s[i]-o)>3*math.abs(p-o)+0.02+0.01*math.abs(o) then bad+=1 end
                end
                if kind=="drive" and V.gearIndex()~=row.gear then mism+=1 end
                last={k,s[1],row.orig[1],row.pert[1]}
            end
        end
        local dt=os.clock()-t
        check(kind..": ticks 1-8 vs original (rel <= 2e-5)",worst<=2e-5,string.format("worst %.2e",worst))
        check(kind..": chassis states inside original sensitivity envelope ("..horizon.." ticks)",bad==0,
            string.format("%d outside | %.0f ticks/s | x lua %.3f orig %.3f pert %.3f",bad,horizon/dt,last[2],last[3],last[4]))
        if kind=="drive" then check("drive: gear sequence (lifted 00553d70)",mism==0,mism.." mismatches") end
    end
    V.reset()
    for k=1,200 do V.drive(controls((k-1)//8),FLAT) end
    local cp=V.checkpoint();for k=201,400 do V.drive(controls((k-1)//8),FLAT) end
    local a=V.state();V.restore(cp);for k=201,400 do V.drive(controls((k-1)//8),FLAT) end
    local b=V.state();local same=true
    for i=1,45 do if a[i]~=b[i] then same=false end end
    check("checkpoint/restore bit-identical",same)
    print(string.format("Stage 6/7 self-test: %d passed, %d failed",passed,failed))
    return failed==0,results
end
return M
