-- CES response kernels. Nonlinear lookup tables are compiled by running the
-- original constructors/evaluators in Unicorn, not by inventing RPM bands.
local M={}
local scratch=buffer.create(4)
local function f32(x) buffer.writef32(scratch,0,x);return buffer.readf32(scratch,0) end
M.f32=f32
function M.evaluate(c,x)
    if not c or c.kind==3 or c.kind==4 then return 1,false end
    x=f32(x) -- original evaluator receives a float32 argument
    if c.kind==0 then
        return f32(math.max(0,c.constant or (c.intercept+c.slope*x))),true
    elseif c.kind==1 then
        local delta=f32(x-c.center)
        if -c.half<=delta and delta<c.half then return c.peak,true end
        delta=f32(delta< -c.half and delta+c.half or delta-c.half)
        local side=delta<0 and c.left or c.right
        local z=(delta-side.min)*side.inv*127
        local i=z<0 and math.ceil(z) or math.floor(z);local t=f32(z-i)
        if i<0 or i>=128 then return side.baseline,true end
        local a=side.y[i+1]
        if i==0 and t<0 then return f32(a-(c.left.baseline-a)*t),true end
        return f32(a+(side.y[i+2]-a)*t),true
    elseif c.kind==2 then
        local t=f32((x-c.min)*c.inv)
        if t<0 then return f32(c.y[1]+t*c.slopeLeft*256),true end
        if t>=1 then return f32(c.y[256]+(t-1)*c.slopeRight*256),true end
        local z=t*255;local i=math.floor(z);local a=c.y[i+1]
        return f32(a+(c.y[i+2]-a)*f32(z-i)),true
    end
    error("Unsupported/uncompiled CES response kind "..tostring(c.kind))
end
-- 004ec250: first selector follows the original composite control flag 7c1
-- (failure state in 00563bd0), separately from focus-bank and camera selection.
function M.selected(sample,controlFlag,interior)
    local selector=sample.selector or sample.focus or 0 -- legacy manifest field
    return not ((selector==1 and not controlFlag) or (selector==2 and controlFlag)
        or (sample.perspective==1 and not interior) or (sample.perspective==2 and interior))
end
-- 004ecb70 / 004ecdb0: group reference RPM, with ORIGINAL minimum 0.25.
function M.pitch(bank,sample,rpm,gearScale)
    local refs=sample.mechanical==1 and bank.gearRefs or bank.engineRefs
    local reference=refs and refs[sample.group+1]
    if not reference or reference<=0 then return nil end
    return math.max(0.25,rpm/reference*(sample.mechanical==1 and gearScale or 1))
end
return M
