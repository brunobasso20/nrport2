-- Roblox cockpit/entry settings. These are test settings, not extracted NR2003 values.
-- Positions below are relative to DriverSeat; SI metres, except explicitly named studs.
return {
    version="3.5.0-stage5",
    entryDistanceStuds=12,
    requestCooldown=0.5,
    entryTimeout=3.5,
    retryInterval=0.35,
    steeringRatio=12, -- steering-wheel angle / centre road-wheel angle
    wheelRadius=0.185,
    wheelTubeRadius=0.016,
    wheelOffset={0,0.44,-0.46},
    columnTiltDegrees=-20,
    cameraOffset={0,0.90,0.08},
    cameraPitchDegrees=-12,
    cockpitFieldOfView=75,
}
