-- The original tire response is already evaluated inside the physics frame.
-- Feed (xfade,1) to tire_*.ces, then apply the original volume/pitch controls.
local Engine=require(script and script.Parent.NR2003AudioEngine or "./NR2003AudioEngine")
local Curves=require(script and script.Parent.NR2003AudioCurves or "./NR2003AudioCurves")
local M={BANKS={[1]="tire_asphalt.ces",[2]="tire_grass.ces",[3]="tire_gravel.ces",[4]="tire_rumble.ces"}}
function M.random(seed)
    seed=bit32.band(seed*1664525+1013904223,0xffffffff)
    return seed,bit32.bor(bit32.band(seed,0x7ffffffe),1)/2147483648
end
function M.newSlot() return {fade=0,step=0,active=false,lastVolume=0,starts=0,output={volume=0}} end
-- 00563bd0: apply the OLD fade to this frame's volume, THEN add +/-0.25.
-- Call at original 36 Hz frame boundaries, never once per RenderStepped.
function M.advance(slot,wheel,steps)
    for _=1,steps do
        local volume=wheel.volume
        if volume<=9.999999747378752e-5 then
            if slot.active then slot.step=-0.25;volume=slot.lastVolume end
            if slot.fade<0.0001 then slot.active=false end
        elseif M.BANKS[wheel.soundType] then
            if not slot.active or slot.soundType~=wheel.soundType then
                if not slot.active then slot.fade=0 end
                slot.starts+=1;slot.active=true;slot.soundType=wheel.soundType
            end
            slot.step=0.25;slot.lastVolume=volume
        end
        local out=slot.output
        out.volume=slot.active and Curves.f32(slot.fade*volume) or 0
        out.soundType=slot.soundType;out.pitch=wheel.pitch;out.xfade=wheel.xfade
        slot.fade=math.clamp(Curves.f32(slot.fade+slot.step),0,1)
    end
    return slot.output
end
function M.aggregate(wheels,out)
    out=out or {};out.volume=0;out.xfade=0;out.pitch=1;out.soundType=0
    -- Preserve the shipped executable's unusual loop over wheels 2..4 only.
    -- This is a presentation copy; the physics wheel fields are never cleared.
    for j=2,4 do
        local w=wheels[j]
        if w then
            out.volume=math.max(out.volume,w.volume);out.xfade=math.max(out.xfade,w.xfade)
            out.pitch=math.min(out.pitch,w.pitch);out.soundType=math.max(out.soundType,w.soundType)
        end
    end
    return out
end
function M.controls(profile,wheel,out,focus,interior)
    local bank=profile.banks[M.BANKS[wheel.soundType]]
    if not bank or wheel.volume<=0 then return nil end
    -- Original tire call supplies selector=false, independently of camera focus.
    out=Engine.controls(bank,{rpm=wheel.xfade,load=1,gearScale=1,fixedPitch=wheel.pitch,volumeOverride=1},false,interior,out)
    for _,c in ipairs(out) do c.gain*=wheel.volume;c.pitch=wheel.pitch end
    return out,bank
end
return M
