local M={}
function M.clamp(x,a,b) return math.max(a,math.min(b,x)) end
function M.sign(x) return x<0 and -1 or (x>0 and 1 or 0) end
function M.finite(x) return type(x)=="number" and x==x and math.abs(x)<math.huge end
function M.approach(x,target,amount) return x+M.clamp(target-x,-amount,amount) end
function M.copy(t)
    if type(t)~="table" then return t end
    local c={}; for k,v in pairs(t) do c[k]=M.copy(v) end; return c
end
function M.atan2(y,x) if math.atan2 then return math.atan2(y,x) end return math.atan(y,x) end
function M.assertFinite(t,label)
    for k,v in pairs(t) do
        if type(v)=="number" then assert(M.finite(v),(label or "state").."."..tostring(k)) end
    end
end
return M
