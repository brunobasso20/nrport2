-- Coefficient combination 00410280 and dynamic pressure 00561b70.
-- Caller supplies selected lookup tables; original branch/table initialization is pending.
local L=require(script and script.Parent.Lookup or "core.Lookup")
local U=require(script and script.Parent.MathUtil or "core.MathUtil")
local C=require(script and script.Parent.RecoveredConstants or "core.RecoveredConstants")
local M={}
local function curve(p,name,x)
    local v=assert(p.curves[name],"Missing aero curve "..name)
    return type(v)=="number" and v or L.sample(v,x)
end
function M.coefficients(p,pitch,yaw,ride,draft,frontHealth,rearHealth,a)
    a=a or {drag=0,lift=0,pitch=0,yaw=0,spoiler=0,grille=0}
    local cy,sy,cp=math.cos(yaw),math.sin(yaw),math.cos(pitch)
    local f=(cy+1)*0.5; local cx=cy*cp
    local h=math.max(0,C["006ec748"]-math.max(0,ride))
    local pitchDrag=curve(p,"pitchDrag",pitch)
    local deform=p.deformation or 0
    local yawDrag=curve(p,"yawDrag",yaw)+curve(p,"yawDragDelta",yaw)*deform
    local yawLift=curve(p,"yawLift",yaw)+curve(p,"yawLiftDelta",yaw)*deform
    local yawPitch=curve(p,"yawPitch",yaw)+curve(p,"yawPitchDelta",yaw)*deform
    local drag=(cy*pitchDrag+yawDrag*cp+(a.grille*p.grilleDrag*rearHealth+
        a.spoiler*p.spoilerDrag*f-p.baseDrag+curve(p,"heightDrag",h)+a.drag)*cx)*draft
    local side=sy*pitchDrag+curve(p,"yawSide",yaw)*cp
    local lift=curve(p,"pitchLift",pitch)*math.abs(cy)+(f*p.baseLift+yawLift+a.lift)*cp+
        (a.grille*p.grilleLift*rearHealth+a.spoiler*p.spoilerLift*f*frontHealth+
        (1-draft)*p.draftLift+curve(p,"heightLift",h))*cx
    local pitchMoment=curve(p,"pitchMoment",pitch)
    local roll=curve(p,"yawRoll",yaw)*cp-sy*pitchMoment*C["006ec744"]
    local pitchTorque=cy*pitchMoment+(yawPitch+a.pitch)*cp+
        (a.grille*p.grillePitch*rearHealth+a.spoiler*p.spoilerPitch*f*frontHealth+
        (1-rearHealth)*p.rearDamagePitch+(1-frontHealth)*p.frontDamagePitch+curve(p,"heightPitch",h))*cx
    return {drag,side,math.min(3,lift)},{roll,pitchTorque,(curve(p,"yawMoment",yaw)+a.yaw)*cp}
end
function M.wrench(p,v,omega,rho,ride)
    -- Source coordinates: forward, left, up.
    local q=(v[1]^2+v[2]^2+v[3]^2)*rho*0.5
    local yaw=U.atan2(v[2],v[1]); local pitch=U.atan2(-v[3],math.sqrt(v[1]^2+v[2]^2))+(p.pitchOffset or 0)
    local force,moment=M.coefficients(p,pitch,yaw,ride,p.draft or 1,1,1,p.adjust)
    local speed=math.sqrt(omega[1]^2+omega[2]^2+omega[3]^2)
    local damping=(speed>0.1 and 1/speed or 10)*C["006f5cf8"]
    for j=1,3 do force[j]=force[j]*q*p.area; moment[j]=(moment[j]+omega[j]*damping)*q*p.area*p.length end
    return force,moment
end
return M
