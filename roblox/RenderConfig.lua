-- Stage 5 presentation-only networking/render configuration.
-- Nothing in this table changes the 288 Hz authoritative NR2003 physics step.
return {
    enabled=true,
    snapshotHz=60,
    vehicleId=1,
    diagnosticsDefault=false,
    -- Host presentation choice for the active Watkins Glen driver. Observe
    -- network delay in H diagnostics; this does not alter any tire/car state.
    driverBuffer={initialDelay=1/30,minDelay=1/60,intervalSafety=1.0},
    buffer={
        capacity=64,
        initialDelay=0.090,
        minDelay=0.055,
        maxDelay=0.180,
        maxExtrapolation=0.075,
        staleAfter=0.75,
        delaySlewPerSecond=0.050,
        latencyFastGain=0.20,
        latencySlowGain=0.015,
        intervalGain=0.10,
        jitterGain=0.08,
        intervalSafety=1.50,
        jitterSafety=2.50,
        maxSpinRate=2000,
    },
}
