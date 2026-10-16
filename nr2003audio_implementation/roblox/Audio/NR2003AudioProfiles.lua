-- No proprietary samples and no made-up asset IDs. Local CES conversion fills
-- AudioAssets. Both profiles use the same physical-state and controller API.
local M={}
M.DEFAULT="NR2003_ORIGINAL_REFERENCE"
M.PROFILES={
    NR2003_ORIGINAL_REFERENCE={name="NR2003_ORIGINAL_REFERENCE",referenceOnly=true,banks={},assets={},
        status="Original sound resources have not been linked",masterGain=1,
        minPitch=0.25,maxPitch=20,rollOffMinMetres=8,rollOffMaxMetres=250},
    NASCAR_SELFMADE={name="NASCAR_SELFMADE",referenceOnly=false,banks={},assets={},
        status="Reserved for phase two; no self-made recordings are enabled",masterGain=1,
        minPitch=0.25,maxPitch=20,rollOffMinMetres=8,rollOffMaxMetres=250},
}
function M.resolve(name,assets)
    local base=M.PROFILES[name]
    assert(base,"Unknown audio profile: "..tostring(name))
    local out={};for k,v in pairs(base) do out[k]=v end
    local override=assets and assets.profiles and assets.profiles[name]
    if override then for k,v in pairs(override) do out[k]=v end end
    out.name=name
    return out
end
function M.assetId(value)
    if type(value)=="number" and value>0 and value==math.floor(value) then return "rbxassetid://"..string.format("%.0f",value) end
    if type(value)=="string" and value:match("^rbxassetid://[1-9]%d*$") then return value end
    -- Studio-only local files may be linked through rbxasset:// in a private
    -- Studio content directory. Local content never makes a published asset.
    if type(value)=="string" and value:match("^rbxasset://sounds/nr2003_reference/[%w_./%-]+$")
        and not value:find("..",1,true) then return value end
    return nil
end
return M
