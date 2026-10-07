-- SI units. Diagnostic RWD tune; NOT an extracted NR2003 Cup setup.
local U=require(script and script.Parent.MathUtil or "core.MathUtil")
local T={
    name="NR2003 Lab RWD",version="3.5.0-stage5",originalCalibration=false,
    sourceCommit="03bcafb44cf63464493f1864edbd9f781fac24f4",
    solver="Selected by Roblox.ModeConfig; numeric chassis + raycast suspension by default",rounding="nearest",
    fixedStep=1/288,maxFrame=1/15,gravity=9.80665,
    metresPerStud=0.28,kilogramsPerMassUnit=21.952,mass=1500,
    chassisSize={1.78,0.38,4.45},wheelbase=2.79,frontTrack=1.60,rearTrack=1.59,
    frontZ=-1.35,rearZ=1.44,mountY=-0.05,
    wheelRadius=0.35,wheelWidth=0.30,wheelInertia=1.50,
    springFreeLength=0.38,initialCompression=0.067,maximumRaySlope=0.25,maximumNormalForce=18000,
    frontSuspension={rate=58000,travel=0.18,bumpTravel=0.045,bumpForce=6000,
        motionRatio=1,compression=0.85,rebound=1.15},
    rearSuspension={rate=54000,travel=0.18,bumpTravel=0.045,bumpForce=6000,
        motionRatio=1,compression=0.90,rebound=1.10},
    antiRollFront=18000,antiRollRear=9000,antiRollPreload=0,
    steering={maximum=math.rad(29),rate=math.rad(125),returnRate=math.rad(150),
        speedReduction=0.014,minimumFraction=0.23,ackermann=1,toe=0,camber=math.rad(-1)},
    brake={maximumTorque=7200,frontBias=0.61,handbrakeTorque=1600,dragTorque=1.5},
    tire={slipExponent=3,speedSensitivity=-0.055,slidingDecay=85,
        stiffnessExponent=-0.12,loadSensitivity=0.0155,relaxationLength=0.45,
        longitudinalStiffness=1.05,lateralStiffness=1.10,camberThrust=0.55,
        anisotropy=1/1.05,verticalStiffness=-300000,grip=1,rollingResistance=0.014,
        inverseLoad=1/4000,contactPatch=0.000005},
    thermal={enabled=true,initialK=298.15,coldPressure=28,referencePressure=28,
        optimumPressure=32,minimumPressure=1,loadReference=2000,optimumK=355,maximumK=470,
        heatScale=1,heatFraction=0.45,surfaceCapacity=8500,carcassCapacity=19000,
        conduction=120,surfaceCooling=28,carcassCooling=9,coolingSpeedOffset=0.01,
        brakeCapacity=6500,brakeCooling=0.008},
    engine={idleRPM=900,redlineRPM=8500,engineInertia=0.40,wheelInertia=1.50,
        clutchCapacity=850,gears={2.50,1.78,1.35,1.00},reverseRatio=-2.4,
        finalDrive=3.70,efficiency=0.94,shiftSeconds=0.18,diffPreload=35,diffPowerLock=0.08,
        netTorqueCurve={{0,0},{800,90},{1500,180},{3000,320},{4500,370},{6000,380},
            {7500,360},{8500,300},{9000,0},{25800,0}},
        frictionCurve={{0,20},{1000,35},{3000,60},{6000,100},{9000,155},{25800,650}}},
    aero={enabled=true,area=2.20,length=2.79,baseDrag=0.43,baseLift=-0.58,
        grilleDrag=0,spoilerDrag=0,grilleLift=0,spoilerLift=0,draftLift=0,
        grillePitch=0,spoilerPitch=0,rearDamagePitch=0,frontDamagePitch=0,
        curves={pitchDrag=0,yawDrag=0,yawDragDelta=0,yawSide=0,yawLift=0,yawLiftDelta=0,
            pitchLift=0,yawRoll=0,pitchMoment=0,yawPitch=0,yawPitchDelta=0,yawMoment=0,
            heightDrag=0,heightLift=0,heightPitch=0}},
    environment={ambientK=298.15,airDensity=1.20,wind={0,0,0}},
    adapter={frictionEnvelope=1.35,lowSpeedLongitudinalDamping=900,maxWheelOmega=600,
        thermalGripFloor=0.25,inputTimeout=0.5,telemetryHz=10,maxPacketHz=60},
}
function T.new()
    local p=U.copy(T); p.new=nil
    p.engine.wheelInertia=p.wheelInertia
    p.corners={
        {name="FL",x=-p.frontTrack/2,z=p.frontZ,front=true,side=-1},
        {name="FR",x=p.frontTrack/2,z=p.frontZ,front=true,side=1},
        {name="RL",x=-p.rearTrack/2,z=p.rearZ,front=false,side=-1},
        {name="RR",x=p.rearTrack/2,z=p.rearZ,front=false,side=1},
    }
    return p
end
return T
