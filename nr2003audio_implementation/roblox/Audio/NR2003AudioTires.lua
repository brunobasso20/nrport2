-- The original tire response is already evaluated inside the physics frame.
-- Feed (xfade,1) to tire_*.ces, then apply the original volume/pitch controls.
local Engine=require(script and script.Parent.NR2003AudioEngine or "./NR2003AudioEngine")
local M={BANKS={[1]="tire_asphalt.ces",[2]="tire_grass.ces",[3]="tire_gravel.ces",[4]="tire_rumble.ces"}}
function M.controls(profile,wheel,out,focus,interior)
    local bank=profile.banks[M.BANKS[wheel.soundType]]
    if not bank or not wheel.grounded or wheel.volume<=0 then return nil end
    out=Engine.controls(bank,{rpm=wheel.xfade,load=1,gearScale=1,fixedPitch=wheel.pitch,volumeOverride=1},focus,interior,out)
    for _,c in ipairs(out) do c.gain*=wheel.volume;c.pitch=wheel.pitch end
    return out,bank
end
return M
