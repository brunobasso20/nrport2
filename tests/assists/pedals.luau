local Vehicle=require("../../core/NR2003CupVehicle")
local V=Vehicle.fromLoader(function(name)
    local ok,m=pcall(require,"../../core/NR2003Cup/"..name)
    return ok and m or nil
end).V
local ref=require("./pedal_vectors")
local failed=0
for i,r in ipairs(ref.throttle) do
    V.w8(0xbf6f05,r[1]);V.w32(0xc0692a+0x4c,r[2]==1 and 0x20000000 or 0)
    V.w32(0x74c97c,r[4])
    V.wf32(0xbf6d44,r[5]);V.wf32(0xbf6d4c,0);V.wf32(0xbf6d54,0)
    V.wf32(0xbf6390,r[6]);V.wf32(0xd35b18+10*5,r[7]);V.wf32(0xd35b18+10*6,1-r[7])
    V.w32(0xd37cc8+29*5,r[3]==1 and 0 or 1);V.w32(0xd37cc8+29*6,r[3]==1 and 0 or 1)
    V.wf32(0xbf63a4,0);V.wf32(0xbf63a8,0)
    V.wf32(0xbf513e,r[8]);V.wf32(0xbf5b77,-r[8]*.8)
    V.wf32d(0xf7f240,V.throttlePedalOriginal())
    if V.r32(0xf7f240)~=r[9] or V.r8(0xbf6eba)~=r[10] then
        failed+=1
        if failed<=12 then print("FAIL throttle",i,V.r32(0xf7f240),r[9],V.r8(0xbf6eba),r[10]) end
    end
end
assert(failed==0,tostring(failed).." original TC/pedal mismatches")
print("PASS original throttle/traction-control",#ref.throttle,"vectors; output bits and digital-key state exact")
