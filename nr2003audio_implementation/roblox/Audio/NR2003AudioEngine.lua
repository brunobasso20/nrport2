-- Original CES continuous sample weighting, 004eb260. This module computes
-- controls only; playback and spatialization belong to the Roblox backend.
local Curves=require(script and script.Parent.NR2003AudioCurves or "./NR2003AudioCurves")
local M={}
function M.volume(bank,sample,state,overrideGain)
    local volume=sample.mechanical==1 and bank.gearVolume or bank.engineVolume
    volume=volume or {0,1}
    local gain=Curves.f32(volume[1]+(volume[2]-volume[1])*state.load)
    if state.volumeOverride then gain=state.volumeOverride end
    if overrideGain then gain=overrideGain end
    return math.max(0,gain)
end
function M.controls(bank,state,controlFlag,interior,out,volumeBank,available)
    out=out or {};local totals={};local groups={}
    local overrideGain=nil
    if volumeBank and #(volumeBank.samples or {})>0 then
        local v=0
        for _,s in ipairs(volumeBank.samples) do
            local a,activeA=Curves.evaluate(s.curves[1],state.rpm)
            local b,activeB=Curves.evaluate(s.curves[2],state.load)
            if s.mechanical==0 and (activeA or activeB) then v=Curves.f32(v+Curves.f32(a*b)) end
        end
        local bounds=volumeBank.engineVolume or {0,1}
        overrideGain=Curves.f32(bounds[1]+(bounds[2]-bounds[1])*math.clamp(v,0,1))
    end
    for i,sample in ipairs(bank.samples or {}) do
        local c=out[i] or {};out[i]=c;c.gain=0;c.pitch=1;c.group=nil;c.weight=0;c.raw=-1
        if sample.phase==0 and (not available or available[i]) and Curves.selected(sample,controlFlag,interior) then
            local a,activeA=Curves.evaluate(sample.curves[1],state.rpm)
            local b,activeB=Curves.evaluate(sample.curves[2],state.load)
            local key=sample.mechanical..":"..sample.group
            c.group=key;totals[key]=totals[key] or 0
            if activeA or activeB then c.raw=Curves.f32(a*b);totals[key]=Curves.f32(totals[key]+c.raw) end
            c.pitch=state.fixedPitch or Curves.pitch(bank,sample,state.rpm,state.gearScale)
            c.validPitch=c.pitch~=nil;c.pitch=c.pitch or 1
        end
    end
    for i,sample in ipairs(bank.samples or {}) do
        local c=out[i];local sum=c.group and totals[c.group] or 0
        if c.group then
            -- Original mixer normalizes by sum + 1e-5, then multiplies the
            -- composite's volume (engvol.ces or the engine-load volume ramp).
            local gain=M.volume(bank,sample,state,overrideGain)
            -- Inactive pairs use the original -1 sentinel and still undergo
            -- normalization. Preserve it for the phase mixer's composite sum.
            c.weight=Curves.f32(c.raw*Curves.f32(1/(sum+9.999999747378752e-6)))
            c.gain=sample.enabled and c.validPitch and c.weight>0.0001 and c.weight*gain or 0
            local group=groups[c.group] or {weight=0,gain=gain,pitch=c.pitch}
            groups[c.group]=group;group.weight=Curves.f32(group.weight+c.weight)
        else c.gain=0 end
    end
    return out,groups
end
return M
