-- 005677d1: FIST selects a segment, the argument is NOT clamped.
-- Caller x87 rounding mode is unresolved; expose rather than silently assume floor.
local M={}
function M.roundIndex(x,mode)
    if mode=="floor" then return math.floor(x) end
    if mode=="truncate" then return x<0 and math.ceil(x) or math.floor(x) end
    local n=math.floor(x); local f=x-n
    if f>0.5 or (f==0.5 and n%2~=0) then n=n+1 end
    return n
end
function M.new(x0,inverseStep,samples,rounding)
    assert(#samples>=2 and inverseStep~=0,"Invalid lookup table")
    return {x0=x0,inverseStep=inverseStep,lastSegment=#samples-2,samples=samples,rounding=rounding or "nearest"}
end
function M.sample(t,x)
    local u=(x-t.x0)*t.inverseStep
    local i=math.max(0,math.min(t.lastSegment,M.roundIndex(u,t.rounding)))
    return t.samples[i+1]+(t.samples[i+2]-t.samples[i+1])*(u-i)
end
function M.linear(points,x)
    -- Adapter map, with bounded endpoints; not the NR table format.
    if x<=points[1][1] then return points[1][2] end
    for i=2,#points do
        if x<=points[i][1] then local a,b=points[i-1],points[i]
            return a[2]+(b[2]-a[2])*(x-a[1])/(b[1]-a[1]) end
    end
    return points[#points][2]
end
return M
