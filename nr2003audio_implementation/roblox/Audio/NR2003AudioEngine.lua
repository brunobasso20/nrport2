-- Original CES continuous sample weighting, 004eb260. This module computes
-- controls only; playback and spatialization belong to the Roblox backend.
local Curves=require(script and script.Parent.NR2003AudioCurves or "./NR2003AudioCurves")
local M={}
function M.controls(bank,state,focus,interior,out,volumeBank)
    out=out or {};local totals={}
    local overrideGain=nil
    if volumeBank and #(volumeBank.samples or {})>0 then
        local v=0
        for _,s in ipairs(volumeBank.samples) do
            local a,activeA=Curves.evaluate(s.curves[1],state.rpm)
            local b,activeB=Curves.evaluate(s.curves[2],state.load)
            if s.mechanical==0 and (activeA or activeB) then v=Curves.f32(v+Curves.f32(a*b)) end
        end
        local bounds=volumeBank.engineVolume or {0,1}
        overrideGain=bounds[1]+(bounds[2]-bounds[1])*math.clamp(v,0,1)
    end
    for i,sample in ipairs(bank.samples or {}) do
        local c=out[i] or {};out[i]=c;c.gain=0;c.pitch=1
        if sample.phase==0 and sample.enabled and Curves.selected(sample,focus,interior) then
            local a,activeA=Curves.evaluate(sample.curves[1],state.rpm)
            local b,activeB=Curves.evaluate(sample.curves[2],state.load)
            if activeA or activeB then
                c.gain=Curves.f32(a*b)
                c.pitch=state.fixedPitch or Curves.pitch(bank,sample,state.rpm,state.gearScale)
                if not c.pitch then c.gain=0;c.pitch=1 end
                local key=sample.mechanical..":"..sample.group
                c.group=key;totals[key]=Curves.f32((totals[key] or 0)+c.gain)
            end
        end
    end
    for i,sample in ipairs(bank.samples or {}) do
        local c=out[i];local sum=c.group and totals[c.group] or 0
        if sum>0 and c.gain>0 then
            -- Original mixer normalizes by sum + 1e-5, then multiplies the
            -- composite's volume (engvol.ces or the engine-load volume ramp).
            local volume=bank.engineVolume or {0,1}
            if sample.mechanical==1 then volume=bank.gearVolume or {0,1} end
            local gain=volume[1]+(volume[2]-volume[1])*state.load
            if state.volumeOverride then gain=state.volumeOverride end
            if overrideGain then gain=overrideGain end
            c.gain=Curves.f32(c.gain/(sum+9.999999747378752e-6))*math.max(0,gain)
        else c.gain=0 end
    end
    return out
end
return M
