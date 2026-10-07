-- Numerical path 0054cab0. Call-site coordinates and integration are adapters.
local L=require(script and script.Parent.Lookup or "core.Lookup")
local Float=require(script and script.Parent.Float32 or "core.Float32")
local C=require(script and script.Parent.RecoveredConstants or "core.RecoveredConstants")
local F=Float.round
local M={}
function M.newState()
    return {relaxedLateral=0,relaxedLongitudinal=0,contactMode=2,
        slipLong=0,slipLat=0,slidingFraction=0,rollingTorque=0,rollingForce=0,
        statCount=0,statLong=0,statLat=0,statCombined=0}
end
function M.evaluate(s,p,i)
    local scale=i.scale or 1
    local long=F(i.treadSpeed-i.forwardSpeed); local lat=F(-i.lateralSpeed)
    local rolling=math.abs(i.treadSpeed); local camber=i.camber or 0
    local result={longitudinal=0,lateral=0,normal=0,creepLongitudinal=0,
        aligningMoment=0,rollingTorque=0,contactMode=2,impact=false}
    local bodyGap=i.bodyGap or 0
    local function bodyForce()
        return ((i.bodyDamping or 0)*i.normalSpeed+(i.bodyStiffness or 0)*scale*bodyGap)*scale
    end
    s.slipLong=long; s.slipLat=lat; s.forwardSpeed=i.forwardSpeed; s.rollingSpeed=rolling
    if i.gap>=0 then
        s.relaxedLateral=0; s.relaxedLongitudinal=0
        s.slipLong=0; s.slipLat=0; s.forwardSpeed=0; s.slidingFraction=0; s.rollingForce=0
        if bodyGap<0 then result.normal=F(bodyForce()) end
        result.impact=result.normal>C["006f58f8"]
    else
        local rLat=F((lat-s.relaxedLateral*rolling)*p.relaxationStep+s.relaxedLateral)
        local rLong=F((long-s.relaxedLongitudinal*rolling)*p.relaxationStep+s.relaxedLongitudinal)
        if i.commit~=false then s.relaxedLateral=rLat; s.relaxedLongitudinal=rLong end
        local normal=F(scale*p.verticalStiffness*scale*i.gap); result.normal=normal
        local loadFactor=L.sample(p.curves.load,normal*p.inverseLoad)
        local speedFactor=L.sample(p.curves.speed,rolling)
        local forceScale=F((1-math.abs(camber)*C["006ee390"])*speedFactor*loadFactor*normal)
        local q=normal*C["006f58e0"]
        local longScale=F((1/(q*q+1)+1)*forceScale)
        local stiffness=L.sample(p.curves.stiffness,normal)
        local kLong=F(p.grip*p.longitudinalStiffness*stiffness)
        local kLat=F(p.grip*p.lateralStiffness*stiffness)
        local camberScale=L.sample(p.curves.camber,C["006f58fc"]/(C["006f5900"]-normal)*camber)
        kLong=F(kLong*camberScale); kLat=F(kLat*camberScale)
        local body=0
        if bodyGap<0 then
            body=bodyForce(); result.normal=F(normal+body)
            -- Unresolved coefficient is explicit, rather than mislabeled as recovered.
            kLong=F(kLong*assert(p.bodyStiffnessScale)); kLat=F(kLat*p.bodyStiffnessScale)
        end
        assert(kLong~=0 and kLat~=0 and normal>0,"Tire requires positive load and nonzero stiffness")
        local nLat=F(normal*kLat); local nLong=F(normal*kLong)
        local normalizedLat=F(forceScale/nLat*rLat)
        local camberSlip=F(-p.camberThrust*forceScale*camber/nLat)
        local normalizedLong=F(rLong/nLong*longScale)
        local squared=F(normalizedLat^2+normalizedLong^2)
        local combined=F(Float.inverseSqrt(squared)*squared)
        if math.abs(camber)<C["006ed020"] then
            s.statCount=s.statCount+1; s.statLong=F(s.statLong+normalizedLong)
            s.statLat=F(s.statLat+normalizedLat); s.statCombined=F(s.statCombined+combined)
        end
        local camberBlend=L.sample(p.curves.slip,camberSlip)
        local blend=F(L.sample(p.curves.slip,combined)); s.slidingFraction=F(1-blend)
        local weightedLat=F(((p.anisotropy*blend+1-blend)/kLat)*kLong*lat)
        squared=F(long*long+weightedLat*weightedLat)
        local inverseSpeed=Float.inverseSqrt(squared)
        local adhesion=F(blend*blend*combined)
        local sliding=L.sample(p.curves.sliding,inverseSpeed*squared)*s.slidingFraction
        local multiplier=(sliding+adhesion)*inverseSpeed
        result.lateral=F(((camberBlend*camberBlend*camberSlip+1-camberBlend)*blend+weightedLat*multiplier)*nLat)
        result.longitudinal=F(multiplier*long*nLong)
        s.rollingForce=F(normal*p.rollingResistance); result.rollingTorque=F(p.radius*s.rollingForce)
        result.impact=body>C["006f58f8"]
        if p.front and p.aligningTrailFactor then
            local lateralDirection=F(inverseSpeed*weightedLat*nLat)
            local patch=math.sqrt(math.max(0,normal*p.contactPatch))
            local trail=patch*0.5+result.longitudinal/longScale*C["006e9824"]+(i.trail or 0)+(i.steerTrail or 0)
            result.aligningMoment=F(C["006e9824"]/forceScale*result.lateral*result.longitudinal+
                adhesion*lateralDirection*(trail-patch*blend*p.aligningTrailFactor)+
                sliding*lateralDirection*(trail-(blend+1)*0.5*patch))
        end
        if math.abs(lat)+math.abs(long)+rolling<C["006f58c4"] then
            local px,py=i.anchorLong or 0,i.anchorLat or 0
            local motionSquared=px*px+py*py; local anchorScale=1
            if motionSquared<C["006f58bc"]^2 then result.contactMode=0
            elseif motionSquared<C["006f58c0"]^2 then
                result.contactMode=1; anchorScale=C["006f58bc"]/math.sqrt(motionSquared)
            end
            if result.contactMode<2 then
                result.creepLongitudinal=F((anchorScale*scale*px*C["006f58f4"]-long*C["006f58f0"])*scale*(i.brake or 0))
                result.lateral=F(result.lateral+(i.lateralSpeed*C["006f58f0"]-anchorScale*scale*py*C["006f58ec"])*scale)
            end
        end
    end
    s.contactMode=result.contactMode; s.rollingTorque=result.rollingTorque
    s.normalForce=result.normal; s.longForce=result.longitudinal; s.latForce=result.lateral
    return result
end
return M
