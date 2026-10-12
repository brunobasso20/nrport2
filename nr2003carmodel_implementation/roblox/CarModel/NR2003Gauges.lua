-- NR2003Gauges: the ORIGINAL cockpit instrument logic of the car model draw (NR2003.exe 005662d0 -> 0056edd0 /
-- 0056f040) and its warning lights. Pure functions, no Instances. Units are those of the original cells.
-- Needle (model node) <- draw record field <- car snapshot cell written by 00551990 (Stage 11 frame end, ported):
--   ptach    <- drawobj+0x64  <- car+0x1508 = engine+0x484   rpm                      (car+0x1518 while control 3 held)
--   poilp    <- drawobj+0x70  <- car+0x151c = engine+0x4d0   oil pressure ("x4d0" of STAGE11_STATE_MAP)
--   poilt    <- drawobj+0x74  <- car+0x1520 = engine+0x4a4   protected float (00425e80)
--   pwater   <- drawobj+0x78  <- car+0x1524 = engine+0x4d4   protected float (XOR pair)
--   pfuel    <- drawobj+0x7c  <- car+0x1528 = engine+0x500   fuel pressure
--   pvoltage <- drawobj+0x80  <- car+0x152c = engine+0x504   voltage
-- Needle rotation: node vf2(0, rest pitch, angle), angle = 0056f040(cal, v) (degrees -> radians, f32).
-- Calibrations: car spec 0x7238e0 + 0x148.. as left by the ORIGINAL build path (Core.NR2003Cup image, Stage 6/7):
-- {v0, v1, deg0, deg1}. The physics image is the source; these constants are the same bytes, read once here.
local M={}
M.CAL={
    ptach={0,10000,-116,141},
    pfuel={0,1.0800000429153442,-40,220},
    pwater={60,127,-40,220},
    poilt={60,127,-40,220},
    poilp={0.5,6.5,-40,220},
    pvoltage={0,27,-40,220},
}
M.DEG=0.0174532998353243  -- 006f5cd4 (f32 pi/180)
-- warning-light thresholds of 005662d0 (constants 006ee574 / 006f5a4c / 006f5a48 / 006f58f8)
M.WATER_LIGHT=110.0
M.OIL_LIGHT=2.040816307067871     -- 30 psi in atm
M.FUEL_LIGHT=0.30612245202064514  -- 4.5 psi in atm
M.SHIFT_BAND=500.0
local S=buffer.create(4)
local function f32(x) buffer.writef32(S,0,x) return buffer.readf32(S,0) end
M.f32=f32
-- 0056f040: clamp to [v0, v1], linear map to [deg0, deg1], times pi/180 (x87, stored to f32 by the caller)
function M.angle(cal,v)
    local v0,v1,a0,a1=cal[1],cal[2],cal[3],cal[4]
    local x=v
    if not (x>=v0) then x=v0 elseif x>v1 then x=v1 end   -- FCOMP/TEST AH,5 (NaN -> v0), FCOM v1
    return f32(((a1-a0)*((x-v0)/(v1-v0))+a0)*M.DEG)
end
-- all needle angles from a draw state ds (fields of NR2003DrawState)
function M.needles(ds,out)
    out=out or {}
    out.ptach=M.angle(M.CAL.ptach,ds.tachHold and ds.tachTell or ds.rpm)
    out.pfuel=M.angle(M.CAL.pfuel,ds.fuelPressure)
    out.pwater=M.angle(M.CAL.pwater,ds.temp1524)
    out.poilt=M.angle(M.CAL.poilt,ds.temp1520)
    out.poilp=M.angle(M.CAL.poilp,ds.oilPressure)
    out.pvoltage=M.angle(M.CAL.pvoltage,ds.voltage)
    return out
end
-- warning lights (005662d0, focus car only): tach (shift) light blinks with getBGCount bit 4 within 500 rpm of the
-- engine limit; water > 110; oil pressure < 30 psi; fuel pressure < 4.5 psi. Values = 3do variable values (0 / 1).
function M.lights(ds,out)
    out=out or {}
    local blinkOff=bit32.band(bit32.rshift(ds.bgCount or 0,4),1)~=0
    local limit=f32((ds.revLimit or 0)-M.SHIFT_BAND)
    out.tachLightEnable=(not blinkOff and limit<ds.rpm) and 1 or 0
    out.waterTempLightEnable=(ds.temp1524>M.WATER_LIGHT) and 1 or 0
    out.oilPressureLightEnable=(ds.oilPressure<M.OIL_LIGHT) and 1 or 0
    out.fuelPressureLightEnable=(ds.fuelPressure<M.FUEL_LIGHT) and 1 or 0
    return out
end
return M
