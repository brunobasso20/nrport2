local Vehicle=require("../../core/NR2003CupVehicle")
local State=require("../roblox/Audio/NR2003AudioState")
local Server=require("../roblox/Audio/NR2003AudioServer")
local Render=require("../../roblox/RenderSnapshot")
local passed=0
local function check(name,ok) assert(ok,name);passed+=1;print("PASS "..name) end
local car=Vehicle.fromLoader(function(name)
    local ok,value=pcall(require,"../../core/NR2003Cup/"..name);return ok and value or nil
end)
car:startSession({},{})
local contacts={{0,0,1,0,0,0,0,1,1},{0,0,1,0,0,0,0,2,1},{0,0,1,0,0,0,0,5,1},{0,0,1,0,0,0,0,8,1}}
local host={core=car,inContact={true,true,true,true},planes=contacts}
local package={GetAttribute=function() return nil end}
local server=Server.new(host,package)
local snapshot={vehicleId=1,seq=1,tick=car:tick(),time=1,flags=3,px=0,py=0,pz=0,
    qx=0,qy=0,qz=0,qw=1,lx=0,ly=0,lz=0,ax=0,ay=0,az=0,steer=0,wheels={}}
for j=1,4 do snapshot.wheels[j]={comp=0,steer=0,spin=0,cx=j,cy=0,cz=0,grounded=true} end
local minimum,maximum=math.huge,0
for block=1,8 do
    for _=1,48 do car:step({driver=true,throttle=block/24,brake=0,clutch=0,steer=0},contacts) end
    local before=buffer.tostring(car.V.memory())
    local s=State.sample(car,host)
    check("actual core state sampling is read-only, block "..block,before==buffer.tostring(car.V.memory()))
    check("recovered RPM/load and tire controls are read directly, block "..block,
        s.rpm==car.V.rf32(0xc12030+0x1508) and s.load==car.V.rf32(0xc12030+0x1510)
        and s.wheels[1].volume==car.V.rf32(0xc12030+0x11cb))
    minimum=math.min(minimum,s.rpm);maximum=math.max(maximum,s.rpm)
    snapshot.tick=car:tick();snapshot.time=block;snapshot.seq=block;snapshot.flags=block==1 and 3 or 2
    local base=Render.encode(snapshot);local packet=server:encode(snapshot,base)
    local decoded=assert(State.decode(packet))
    check("476-byte packet preserves all 204 original render bytes, block "..block,
        buffer.len(packet)==476 and buffer.readstring(packet,0,204)==buffer.tostring(base)
        and Render.decode(packet).tick==snapshot.tick)
    check("all four material/contact states survive packing, block "..block,
        decoded.wheels[2].surface==2 and decoded.wheels[3].surface==5 and decoded.wheels[4].surface==8)
end
check("test exercised changing original engine RPM",maximum>minimum)
local base=Render.encode(snapshot)
check("old render packets need no migration",State.decode(base)==nil)
local original=State.sample(car,host)
local packet=State.append(base,original,5)
buffer.writef32(packet,204+16,0/0)
check("non-finite audio data is rejected",State.decode(packet)==nil)
packet=State.append(base,original,5)
local a=assert(State.decode(packet));a.time=1;a.seq=1;a.rpm=2000;a.gear=1
local b=assert(State.decode(packet));b.time=2;b.seq=2;b.rpm=4000;b.gear=2
a.gearScale=10;b.gearScale=4
local buf=State.newBuffer();buf:push(a,2);buf:push(b,2)
local s=assert(buf:sample(1.5,2))
check("audio uses the visual presentation time with continuous RPM",s.rpm==3000)
check("gear events never occur before their original timestamp",s.gear==1 and buf:sample(2,2).gear==2)
check("mechanical pitch ratio changes at the confirmed gear timestamp",s.gearScale==10 and buf:sample(2,2).gearScale==4)
check("duplicate/out-of-order packet cannot repeat an event",not buf:push(a,2.1) and #buf.list==2)
check("stale packet stream silences within 500 ms",buf:sample(2,2.51)==nil)
local reset=assert(State.decode(packet));reset.epoch=6;reset.time=3;reset.rpm=1000;reset.gear=0
buf:push(reset,3)
check("reset epochs cannot interpolate with the previous car state",#buf.list==1 and buf.resets==1 and buf:sample(2.9,3)==nil)
check("delayed pre-reset packets are rejected",not buf:push(b,3.1))
print(string.format("audio state/core/transport: %d passed, 0 failed; RPM %.1f..%.1f",passed,minimum,maximum))
