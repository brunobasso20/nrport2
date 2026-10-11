-- NR2003 Cup (series 0, chassis type 2 "spdway") HOST/PRESENTATION geometry for Stage 6/7.
-- The physics does NOT read this table: mass, inertia, suspension, tires, engine, drivetrain,
-- setup and aero all live inside the original NR2003 memory image (Core.NR2003Cup).
-- Values here only place Roblox parts, aim contact queries and drive the cockpit visuals.
-- Sources (original component records 0x727290 + i*0x505, after the original build path):
--   lfsusp/rfsusp offset (1.2070, +-0.7684, -0.0982) m; raxle offset (-1.5870, 0, -0.2577);
--   lr/rr wheel offset in raxle (0, +-0.7684, 0.1042); wheel centre height at rest 0.3541/0.3509 m
--   (record +0x32d world-position cells, car settled on a flat plane).
-- Everything marked PROVISIONAL is a Roblox-side choice, not NR2003 data.
local U=require(script and script.Parent.MathUtil or "core.MathUtil")
local Base=require(script and script.Parent.TestTune or "core.TestTune")
local T={
    name="NR2003 Cup (original image)",version="3.6.0-stage7",originalCalibration=true,
    physics="NR2003_CUP: original 45-state core (Core.NR2003Cup)",
    reference={series=0,chassisType=2,spec="0x7238e0",tireProfiles="0x8b0c00",setup="descriptor defaults (c03350/c055c0)"},
    fixedStep=1/288,gravity=9.80665,
    metresPerStud=Base.metresPerStud,          -- same scale as the Stage 5 bench model
    kilogramsPerMassUnit=Base.kilogramsPerMassUnit,
    mass=1715,                                 -- static wheel-load sum / g (display only)
    chassisSize=Base.chassisSize,
    wheelbase=1.2070+1.5870,frontTrack=2*0.7684,rearTrack=2*0.7684,
    frontZ=-1.2070,rearZ=1.5870,               -- Roblox chassis frame: -Z forward
    -- VisualRig places hubs at (x, mountY - springFreeLength + compression, z); the Cup adapter
    -- sends compression = wheel-centre height relative to the chassis reference (record cells).
    mountY=0,springFreeLength=0,initialCompression=0,
    restCentre={front=0.3541-0.4174,rear=0.3509-0.4174},
    wheelRadius=0.354,wheelWidth=Base.wheelWidth,   -- loaded radius at rest (presentation)
    -- contact query (PROVISIONAL host choice): ray from wheel centre + up*rayAbove, length rayLength
    contactQuery={rayAbove=0.55,rayLength=1.45,maximumSlopeCos=0.25,noContactPlane=1000},
    -- host collision box (PROVISIONAL): chassis part box raised so its floor keeps the Stage 5
    -- bench clearance (~0.55 m) and ramps/kerbs are handled by the tires, not by the boundary
    collision={raise=0.32},
    -- steering: only the presentation fields (camber of the visual rig) are still read; the steering itself is the
    -- ORIGINAL chain since Stage 12 (NR2003CupSteering)
    steering=U.copy(Base.steering),
    -- Stage 12.1 driver defaults of the Roblox bench (car attributes override them at every reset, see
    -- CupChassisAdapter.initialize). The core default without these options is the original executable.
    --   steeringLockDegrees  steering-wheel rotation lock to lock at full input: 360 = the ORIGINAL x pi (180 deg per
    --                        side, 00551e80); other values are a NON-ORIGINAL extension (attribute SteeringLockDegrees)
    --   setupSteeringRatio   garage item 0x30 (12..32) used when the car has no Setup_steeringRatio attribute, applied
    --                        through the ORIGINAL garage pipeline (the shipped Cup setup has 18)
    --   momentumKeys         steering momentum (0..100, original setter 005500c0) while the keys drive the steering;
    --                        nil = the executable's image rate 0.033 / frame (smooth keys, no controls.cfg)
    --   momentumAxis         the same while an analog axis (gamepad / mouse) drives it: 0 = no slew and no sine (the
    --                        front-end default of a saved controls.cfg)
    --   cockpitLimit         cockpit wheel draw limit: "lock" = the full lock (180 deg per side at 360), "original" =
    --                        the 005662d0 limit 2.79 rad (160 deg)
    driver={steeringLockDegrees=360,setupSteeringRatio=12,momentumKeys=nil,momentumAxis=0,cockpitLimit="lock"},
    engine={gears=4,limiterRPM=9300},          -- engine+0x444 / engine+0x438 (display)
    environment={ambientC=26.6667},            -- e0b830 (tire thermal frozen: Stage 11)
    adapter=U.copy(Base.adapter),
}
T.steering.ackermann=0; T.steering.toe=0; T.steering.camber=0 -- toe comes from c086b0/c086b4
function T.new()
    local p=U.copy(T); p.new=nil
    p.corners={
        {name="FL",x=-0.7684,z=-1.2070,front=true,side=-1,record=5,hub=4,state={angle=17,rate=18,travel=13}},
        {name="FR",x=0.7684,z=-1.2070,front=true,side=1,record=8,hub=7,state={angle=23,rate=24,travel=19}},
        {name="RL",x=-0.7684,z=1.5870,front=false,side=-1,record=10,state={angle=29,rate=30,travel=25}},
        {name="RR",x=0.7684,z=1.5870,front=false,side=1,record=11,state={angle=31,rate=32,travel=25}},
    }
    return p
end
return T
