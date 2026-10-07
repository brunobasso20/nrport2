-- Numerical part of FUN_005b8c40 (NR2003.exe), nine row-major cells.
-- Inputs are the original angle order in radians; no Roblox axis remap.
local F32 = require(script and script.Parent.Float32 or "Float32")
local M = {}
function M.fromAngles(a, b, c)
    a, b, c = F32.round(a), F32.round(b), F32.round(c)
    local c1, s1 = F32.round(math.cos(a)), F32.round(math.sin(a))
    local c2, s2 = F32.round(math.cos(b)), F32.round(math.sin(b))
    local c3, s3 = F32.round(math.cos(c)), F32.round(math.sin(c))
    return {
        F32.round(c2*c1), F32.round(s3*s2*c1-c3*s1), F32.round(s3*s1+c3*s2*c1),
        F32.round(c2*s1), F32.round(c3*c1+s3*s2*s1), F32.round(c3*s2*s1-s3*c1),
        F32.round(-s2), F32.round(s3*c2), F32.round(c3*c2),
    }
end
return M
