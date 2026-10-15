-- Original automatic gear selection: 00562f90 initialization, 00553920 predicted RPM, 005536b0 selector.
-- Shift execution remains the existing original 00553d70 FSM. No assist defaults are selected here.
return function(V)
    local rf, ru, ri, wf, wu, r8 = V.rf32, V.r32, V.ri32, V.wf32d, V.w32, V.r8
    local fd = V.fd
    local GARAGE, ACTIVE, FLAGS = 0xC03350, 0xC055C0, 0xC086E0
    local CAR, ENGINE = 0xC12030, V.ENGINE

    -- 00562f90 reads the GARAGE's derived ratios; 00553920 reads the ACTIVE setup.
    function V.initializeAutomaticOriginal()
        local final = rf(GARAGE + 0x6E * 4)
        for gear = 0, 7 do
            local ratio = final * rf(GARAGE + (0x66 + gear) * 4) * rf(0x6F5E20)
            wf(0xC53438 + gear * 4, ratio)
            wf(0xC53418 + gear * 4, ratio == 0 and 0 or 1 / ratio)
        end
        local engineSet = ru(ENGINE + 0x56A)
        wf(0xC08728, rf(engineSet + 0x2C) - rf(0x6ED00C))
        for gear = 0, 7 do
            if gear < 3 then wu(0xC533F8 + gear * 4, 0)
            elseif gear == 3 then wf(0xC53404, rf(0xC08728) * rf(0x6EA470))
            else
                wf(0xC533F8 + gear * 4, rf(0xC53438 + gear * 4) / rf(0xC53434 + gear * 4)
                    * rf(0x74E928 + ri(0xBDBD00) * 4) * rf(0xC08728))
            end
        end
        return true
    end

    -- 0054c1c0 already bound these profiles through the same 0056ed60(spec,wheel) lookup used by
    -- 00553920. Read the identical current-car radius through tyre+0x70: the old runtime image
    -- omitted the otherwise redundant global profile-pointer table at 00734368.
    function V.predictedRPMOriginal(speed, spec, gear)
        assert(spec == ru(CAR + 0x58A), "Automatic RPM requires the current built car specification")
        local left = rf(ru(0xBF3A20 + 2 * 0xA39 + 0x70))
        local right = rf(ru(0xBF3A20 + 3 * 0xA39 + 0x70))
        local radii = fd(right + left) -- 00553969 FSTP dword before the denominator product
        local item = ru(FLAGS + gear * 4) == 0 and (gear + 0x66) or 0x67
        return rf(ACTIVE + item * 4) * rf(ACTIVE + 0x6E * 4) * speed * rf(0x6F4754)
            / (radii * rf(0x6F5A34))
    end
    local function nextGear(gear)
        local top = ri(ENGINE + 0x444) + 1
        local candidate = gear + 1
        while candidate ~= 1 and candidate <= top and ru(FLAGS + candidate * 4) ~= 0 do candidate += 1 end
        return math.min(candidate, top)
    end
    local function previousGear(gear)
        local candidate = gear - 1
        while candidate ~= 1 and candidate >= 0 and ru(FLAGS + candidate * 4) ~= 0 do candidate -= 1 end
        return candidate < 0 and 1 or candidate
    end
    local function request(direction)
        local phase = ri(0xBF6EA0)
        if phase == 0 or phase == 3 or phase == 4 then
            wu(0xBF63CC, direction > 0 and 1 or 5)
            wu(0xBF6E98, 0)
            return direction
        end
        return 0
    end
    local function speed()
        if ru(0x74C9AC) ~= ru(0x7559C4) then
            local z, y, x = rf(0xBF6D54), rf(0xBF6D4C), rf(0xBF6D44)
            wf(0xBF6F44, math.sqrt((z * z + y * y) + x * x))
            wu(0x74C9AC, ru(0x7559C4))
        end
        return rf(0xBF6F44)
    end
    function V.automaticShiftOriginal()
        V._callx(0x554F10)
        local rpm = fd(V._popF()) -- original selector stores this return to a local float
        local gear, gearbox = ri(0x74C97C), ri(0xBF6F0C)
        if gear == 0 then
            if (gearbox == 0 and r8(0xBF6E20) ~= 0)
                or (gearbox == 1 and r8(0xBF6E22) ~= 0 and ri(0xBF6E23) > 0)
                or ru(FLAGS) ~= 0 then return request(1) end
            return 0
        elseif gear == 1 then
            if (gearbox == 0 and r8(0xBF6E21) ~= 0)
                or (gearbox == 1 and r8(0xBF6E22) ~= 0 and ri(0xBF6E23) == 0) then return request(-1) end
            if rf(0xC53400) < rpm and rf(0x6EA470) < rf(0xBF6EA4) then
                if gearbox == 1 then wu(0xBF6E23, 2) end
                return request(1)
            end
            return 0
        end
        if gear == nextGear(1) and rpm < rf(0x6F58F8) and rf(0xBF6EA4) < rf(0x6E9824) and r8(0xBF6EBA) == 0 then
            if gearbox == 1 then wu(0xBF6E23, 1) end
            return request(-1)
        end
        local predicted = V.predictedRPMOriginal(speed(), ru(CAR + 0x58A), gear)
        if rf(0xC08728) * rf(0x6F599C + gear * 4) < predicted then
            if gearbox == 1 then wu(0xBF6E23, gear + 1) end
            return request(1)
        end
        local low = previousGear(gear) == 1 and 0 or rf(0xC533F8 + gear * 4)
        if fd(predicted) <= low then -- 00553878 TEST AH,0x41: downshift includes equality; uses stored RPM
            if gearbox == 1 then wu(0xBF6E23, gear - 1) end
            return request(-1)
        end
        return 0
    end
    return V
end
