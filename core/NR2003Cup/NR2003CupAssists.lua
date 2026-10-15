--!native
--!optimize 2
-- NR2003 1.2.0.1 option messages, not a replacement handling model.
-- 00550120/170/1c0 write ABS/TC/stability bytes; 00550210 writes steering percent * .01.
-- 00550340: ShiftMethod 0 automatic, 1 manual + auto clutch, 3 manual clutch.
-- The existing original pedal, shift-FSM and force routines consume these cells.
return function(V)
    local options
    local function apply()
        if not options then return end
        local o=options
        local method=o.automatic and 0 or (o.autoClutch and 1 or 3)
        V.w32(0x74c974,method)
        -- Literal stores in 00550340, including its gearbox-mode branch.
        V.w32(0x74c980,method==0 and 0x3df5c28f or (V.ri32(0xbf6f0c)==0 and 0x3db851ec or 0x3d3851ec))
        V.w8(0xbf6f04,o.abs and 1 or 0)
        V.w8(0xbf6f05,o.tractionControl and 1 or 0)
        V.w8(0xbf6f06,o.stabilityControl and 1 or 0)
        V.wf32d(0xbf6f08,o.steering*V.rf32(0x6ea4a4))
    end
    function V.drivingAssists()
        local permitted=bit32.band(V.r32(0xc0692a+0x4c),0x20000000)==0
        local method=V.ri32(0x74c974)
        local steering=V.rf32(0xbf6f08)
        return {automatic=method==0,autoClutch=method~=3,
            abs=permitted and V.r8(0xbf6f04)~=0,
            tractionControl=permitted and V.r8(0xbf6f05)~=0,
            stabilityControl=permitted and V.r8(0xbf6f06)~=0,
            lowSpeedSteering=V.r8(0x74c9a0)~=0,
            steering=permitted and steering>0,steeringPercent=permitted and steering*100 or 0,
            steeringAvailable=V.steeringAssistanceAvailable~=nil and V.steeringAssistanceAvailable(),
            aidsDisabled=not permitted,shiftMethod=method,
            clutchEngagement=V.rf32(0xbf6370)}
    end
    function V.setDrivingAssists(o)
        assert(type(o)=="table","Driving assists must be a table")
        local nextOptions={}
        for _,key in ipairs({"automatic","autoClutch","abs","tractionControl","stabilityControl"}) do
            assert(type(o[key])=="boolean","Driving assist "..key.." must be boolean")
            nextOptions[key]=o[key]
        end
        -- Automatic uses the original automatic clutch regardless of a separate clutch checkbox.
        nextOptions.autoClutch=o.automatic or o.autoClutch
        local steering=o.steering or 0
        assert(type(steering)=="number" and steering>=0 and steering<=100,"Steering assistance must be 0..100")
        assert(steering==0 or (V.steeringAssistanceAvailable and V.steeringAssistanceAvailable()),
            "Original steering assistance requires the original track racing-line data")
        nextOptions.steering=steering
        options=nextOptions
        apply()
        if V.initializeAutomaticOriginal then V.initializeAutomaticOriginal() end
        return V.drivingAssists()
    end
    function V.clearDrivingAssists() options=nil end
    local reset=V.reset
    function V.reset()
        reset()
        apply()
        if options and V.initializeAutomaticOriginal then V.initializeAutomaticOriginal() end
    end
    if V._registerCheckpoint then
        V._registerCheckpoint("assists",function() return {options=options} end,function(h) options=h.options end)
    end
    return V
end
