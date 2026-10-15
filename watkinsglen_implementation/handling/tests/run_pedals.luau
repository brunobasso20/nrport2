local Vehicle=require('../../../core/NR2003CupVehicle')
local fixture=require('./pedal_fixtures')
local function get(name)
    local ok,m=pcall(require,'../../../core/NR2003Cup/'..name)
    return ok and m or nil
end
local V=Vehicle.fromLoader(get).V
local s=buffer.create(4)
local function fb(u) buffer.writeu32(s,0,u);return buffer.readf32(s,0) end
local failures,offFailures,helpUlp=0,0,0
for i,v in ipairs(fixture.throttle) do
    local addresses={0xd35b18+50,0xd35b18+60,0xbf6390,nil,0xbf63a4,0xbf63a8,0x74c994,0x74c998,nil,nil,0xbf6d44,0xbf513e,0xbf5b77}
    for k,a in pairs(addresses) do V.w32(a,v[k]) end
    V.w32(0xd37cc8+29*5,v[4]);V.w32(0xd37cc8+29*6,0)
    V.w8(0xbf6f05,v[9]);V.w32(0xc0692a+0x4c,0);V.w32(0x74c97c,v[10])
    V.wf32(0xbf6d4c,0);V.wf32(0xbf6d54,0)
    V.wf32d(0xbf6390,V.throttlePedalOriginal())
    local got=V.r32(0xbf6390)
    local state=V.r32(0xbf63a4)==v[15] and V.r32(0xbf63a8)==v[16] and V.r8(0xbf6eba)==v[17]
    if got~=v[14] or not state then
        failures+=1
        if v[9]==0 then offFailures+=1 end
        helpUlp=math.max(helpUlp,math.abs(got-v[14]))
        if failures<=8 then print('FAIL throttle',i,fb(got),fb(v[14]),'state',state,'TC',v[9]) end
    end
end
local clutchFailures=0
for i,v in ipairs(fixture.clutch) do
    V.w32(0x74c974,v[1]);V.w32(0xbf6d88,v[2]);V.w32(0xbf6390,v[3]);V.w32(0xd35b18+40,v[4])
    V.wf32d(0xbf6eb0,V.clutchPedalOriginal())
    if V.r32(0xbf6eb0)~=v[5] then clutchFailures+=1;print('FAIL clutch',i) end
end
print(string.format('Original throttle: %d vectors; %d mismatches (%d with TC off); max bit distance %d',#fixture.throttle,failures,offFailures,helpUlp))
print(string.format('Original clutch: %d vectors; %d mismatches',#fixture.clutch,clutchFailures))
assert(failures==0 and clutchFailures==0,'Original pedal comparison failed')
