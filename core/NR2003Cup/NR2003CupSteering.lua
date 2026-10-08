--!native
--!optimize 2
-- Stage 12: the ORIGINAL NR2003 steering chain of the player car (hand port of the x86, float32 stores round
-- toward -inf like every store of the simulation task, CW 0x077f; x87 intermediates in IEEE double, the Stage 6/7
-- convention; exact-zero sums signed as under RC-down). Installed on a runtime created by NR2003CupCore +
-- NR2003CupDriver; NR2003CupDriver.frameStart calls V._steerDevices (inside 005524f0) and V._steerTail (00551e80).
--
-- Per 36 Hz task frame (005b2190 -> 00551e80, player car), recovered in recovery/stage12 (STAGE12_RECOVERY.md):
--   device layer 0057abc0 (HOST): control 7 = steer left, control 8 = steer right, raw 0..1 in the control table
--     d35b18 + 10n (f32), binding d37cc8 + 29n (1 = analog axis, otherwise key/button: 0057af60 'digital')
--   005524f0 -> bf63c8 = 00552720():
--     00552d00(8) / 00552d00(7): per-control slew limit 74c990 (steering 'momentum') and sin(x * pi/2) shaping
--       (only while the rate is < 1; Stage 8 hand port V.axisOriginal)
--     speed sensitivity  k = L * 0.15 * exp(-0.000493827 * v^2) + (1 - L * 0.15),  L = 00552410()
--     yaw-rate limiter (race settings +0x4c bit 25, 0055a770): (min(12.25 / v, |r|) / max(|r|, 0.01)) * 0.9 + 0.1
--     steering assistance (bf6f08 > 0, 00550230): needs the track racing line -> NOT PORTED (refused)
--   00551e80 tail: bf63c0 = -bf63c8 ; 005524b0 ; linearity  x = sign * |x|^(L + 1)  (00552410() != 0 and both
--     steering controls analog) ; road-wheel target = f32(x * pi) / 00554fb0() ; bf63b8 / bf6e80 / ramp bf6e88
--   00554fb0: setup item 0x30 ratio (c055c0 + 0xc0) with the low-speed override (74c9a0, ini 'steer_ratio'):
--     ratio >= 7 and v <= 17.88 m/s: v <= 8.94 -> 7, else r - (17.88 - v) * (r - 7) * 0.111856826
-- Per 288 Hz tick (unchanged, NR2003CupDriver.tickInputs = 005539c0): bf63c0 += bf6e88, lf = bf63c0 - toe c086b0,
--   rf = c086b4 + bf63c0 -> core input cells -> prescribed lfhub / rfhub steer coordinates (states 15 / 21).
-- Presentation (005662d0, car model draw): steering-wheel angle = clamp(-(00554fb0() * car[0x1554]), +-2.79 rad),
--   car[0x1554] = (state15 + state21) * 0.5 written by the car snapshot 00551990 (Stage 11 frame end).
return function(V)
	local rf32, r32, ri32, w32, r8, w8 = V.rf32, V.r32, V.ri32, V.w32, V.r8, V.w8
	local wf32d, fd, rf64, wf32 = V.wf32d, V.fd, V.rf64, V.wf32
	local band, rshift = bit32.band, bit32.rshift
	local floor, abs = math.floor, math.abs

	local CAR = 0xc12030                       -- player car slot (00562f70(0))
	local SETTINGS = 0xc0692a                  -- 0055a680(): race settings record of the session
	local SETUP_RATIO = 0xc055c0 + 4 * 0x30    -- active setup item 0x30 (00557d60(0x30)), steering ratio (float)
	local CTRL_RAW, CTRL_TYPE = 0xd35b18, 0xd37cc8 -- 0057af30: f32 [d35b18 + 10n]; 0057af60: i32 [d37cc8 + 29n]
	local STEER_LEFT, STEER_RIGHT = 7, 8
	local DRAW_STEER = CAR + 0x1554            -- car snapshot (00551990): mean prescribed front steer angle
	-- .rdata constants read from the image (the cells the original reads)
	local K_ONE, K_ZERO, K_MONE = rf32(0x6e97d8), rf32(0x6ea454), rf32(0x6ea4a8) -- 1, 0, -1
	local K_CENTI = rf32(0x6ea4a4)             -- 0.01
	local K_SENS_EXP = rf32(0x6f59fc)          -- -0.000493827 (speed sensitivity exponent / v^2)
	local K_YAW_LAT = rf32(0x6f59f8)           -- 12.25 (lateral acceleration of the yaw limiter)
	local K_09, K_01 = rf32(0x6ed020), rf32(0x6ea4cc) -- 0.9, 0.1
	local K_SENS = rf32(0x6ee4c4)              -- 0.15
	local K_LIN_A, K_LIN_B = rf32(0x6ef740), rf32(0x6f59e4) -- 0.66, 0.34 (00552410 with aids)
	local K_PI = rf32(0x6f4a4c)                -- 3.14159274 (steering-wheel lock +-pi per unit input)
	local K_LOW_RATIO, K_V_HIGH, K_V_LOW, K_RAMP = rf32(0x6f5a64), rf32(0x6f5a60), rf32(0x6f5a5c), rf32(0x6f5a58)
	local K_DRAW_LOCK = rf32(0x6f5e6c)         -- 2.79 rad (005662d0 steering-wheel draw limit)
	local K_RATE = rf64(0x6f59c0)              -- 0.016663333999866692 (005500c0: rate = K / (momentum * 0.01))
	local LOG2E = 1.4426950408889634           -- FLDL2E (lifter convention)
	local scratch = buffer.create(4)

	-- exact-zero sums signed as under round-toward-negative (IEEE 754: x + (-x) = -0 when RC = down)
	local function zadd(x, y)
		local r = x + y
		if r == 0 and not (x == 0 and y == 0 and 1 / x > 0 and 1 / y > 0) then return -0.0 end
		return r
	end
	local function zsub(x, y) return zadd(x, -y) end
	-- x87 F2XM1 / FLD1 / FADDP / FSCALE after FRNDINT (RC = down -> floor), lifter convention (double)
	local function exp2(t)
		local n = t ~= t and t or floor(t)
		local f = 2 ^ (t - n) - 1
		f = f + 1
		if n >= 0 then n = floor(n) else n = -floor(-n) end
		return f * 2 ^ n
	end
	-- f32 store rounded to nearest (UI thread, CW 0x027f): message payloads built by the front end
	local function f32near(x) buffer.writef32(scratch, 0, x); return buffer.readf32(scratch, 0) end

	-- 00554f50: vehicle speed from the exported state block (cached in bf6f44 as float32). observe = true: the
	-- same value without touching the cache (presentation / telemetry reads between frames)
	local function speed(observe)
		local vz, vy, vx = rf32(0xbf6d54), rf32(0xbf6d4c), rf32(0xbf6d44)
		local v = math.sqrt((vz * vz + vy * vy) + vx * vx)
		if observe then return fd(v) end
		wf32d(0xbf6f44, v)
		return rf32(0xbf6f44)
	end
	-- 0055a770: race settings +0x4c bit 25 (yaw-rate limiter + linearity remap)
	local function settingsBit25() return band(rshift(r32(SETTINGS + 0x4c), 25), 1) ~= 0 end
	-- 00550230: steering assistance; inServer() = false, inBackground() = true on the simulation task ->
	-- 0055a680() = race settings; +0x4c bit 29 disables the driver aids
	local function assist()
		if band(r32(SETTINGS + 0x4c), 0x20000000) ~= 0 then return K_ZERO end
		return rf32(0xbf6f08)
	end
	-- 00552410: linearity value L (bf6f00, 0..1), remapped 0.66 L + 0.34 with the aids
	local function linearity()
		if not settingsBit25() then
			local a = assist()
			if a <= K_ZERO or a ~= a then return rf32(0xbf6f00) end -- FCOMP 0; AND 0x4100; JZ remap
		end
		return rf32(0xbf6f00) * K_LIN_A + K_LIN_B
	end
	-- 0057af60: control n is not an analog-axis binding
	local function digital(n) return ri32(CTRL_TYPE + 29 * n) ~= 1 end

	local axis = V.axisOriginal -- 00552d00 (Stage 8 hand port; steering controls 7/8 with sin shaping)

	-- 00552720: processed steering input (returned float32 value, stored to bf63c8 by 005524f0)
	local yawLimiterFactor, sensitivity = 1, 1 -- last values (telemetry only)
	local function steerInput()
		local v = speed()
		local s = v
		if not (K_CENTI <= v or v ~= v) then s = K_CENTI end -- FLD 0.01; FCOMP v; AND 0x4100; JNZ keep v
		local yaw = abs(rf32(0xbf6d70))                      -- |state[12]| chassis yaw rate (AND 0x7fffffff)
		local f = yaw
		if not (K_CENTI <= yaw or yaw ~= yaw) then f = K_CENTI end
		local p = s * s                                      -- FLD s; FMUL s (exact in double)
		local e = fd(exp2(p * K_SENS_EXP * LOG2E))           -- exp(-0.000493827 v^2) -> float32
		local q = K_YAW_LAT / s                              -- 12.25 / v
		local m = q
		if not (q <= f or q ~= q or f ~= f) then m = f end   -- FCOM; AND 0x4100; JNZ keep q
		local limiter = fd(m / f * K_09 + K_01)
		local a = linearity() * K_SENS                       -- L * 0.15
		local sens = fd((K_ONE - a) + a * e)
		local a8 = fd(axis(STEER_RIGHT))                     -- FSTP dword
		local a7 = axis(STEER_LEFT)                          -- x87 value
		local x = fd(zsub(a8, a7) * sens)                    -- FSUBR; FMUL; FSTP
		if settingsBit25() then x = fd(x * limiter) end
		local aid = assist()
		if not (aid <= K_ZERO or aid ~= aid) then
			-- the assistance branch blends the racing-line steering of the track system (car+0x5ae world record,
			-- racing line bd7960, 00527580 / 00536180 / 00536260 / 00535530): not available without a track
			error("NR2003 Stage 12: steering assistance (bf6f08 > 0) needs the NR2003 track racing line: not ported")
		end
		yawLimiterFactor, sensitivity = limiter, sens
		return x
	end

	-- 00554fb0: steering ratio of the car at the current speed (setup item 0x30 + low-speed override)
	local function ratio(observe)
		local v = speed(observe)
		local r = rf32(SETUP_RATIO)
		if r8(0x74c9a0) == 0 then return r end
		if r < K_LOW_RATIO and r == r then return r end              -- FCOM 7; TEST AH,5; JNP ret
		if not (v < K_V_HIGH or v == K_V_HIGH or v ~= v) then return r end -- v > 17.88
		if v < K_V_LOW or v == K_V_LOW or v ~= v then
			if r < K_LOW_RATIO or r == K_LOW_RATIO or r ~= r then return r end
			return K_LOW_RATIO
		end
		if r < K_LOW_RATIO or r == K_LOW_RATIO or r ~= r then return r end
		return r - (K_V_HIGH - v) * (r - K_LOW_RATIO) * K_RAMP
	end

	-- 005524b0: ignition-sequence timer of the frame start (bf6e0c / bf6ea0)
	local function ignitionTimer()
		local t = ri32(0xbf6e0c)
		if t == 0 then return end
		t -= 1
		w32(0xbf6e0c, t)
		if t ~= 0 then return end
		local st = ri32(0xbf6ea0)
		if st == 5 then w32(0xbf6ea0, 6) elseif st == 7 then w32(0xbf6ea0, 0) end
	end

	-- host device layer (0057abc0 equivalent, ADAPTER): controls of one frame -> control table cells 7 / 8.
	--   steerAxis (-1..1, + right): one analog axis bound to both controls (negative half -> 7, positive -> 8)
	--   steerLeft / steerRight (0..1) + steerDigital (true = keys / buttons, false = analog axes)
	local function hostDevices(c)
		local left, right, isDigital
		if c.steerAxis ~= nil then
			local x = math.clamp(tonumber(c.steerAxis) or 0, -1, 1)
			left = x < 0 and -x or 0; right = x > 0 and x or 0; isDigital = false
		else
			left = math.clamp(tonumber(c.steerLeft) or 0, 0, 1)
			right = math.clamp(tonumber(c.steerRight) or 0, 0, 1)
			isDigital = c.steerDigital ~= false
		end
		wf32(CTRL_RAW + 10 * STEER_LEFT, left); wf32(CTRL_RAW + 10 * STEER_RIGHT, right)
		local kind = isDigital and 0 or 1
		w32(CTRL_TYPE + 29 * STEER_LEFT, kind); w32(CTRL_TYPE + 29 * STEER_RIGHT, kind)
	end

	-- steering mode: "original" (production) or "provisional" (the Stage 6-11 contract controls.steer = road-wheel
	-- target in rad, + left; used ONLY by the Stage 6-11 regression suites and self-tests whose golden data were
	-- produced with it)
	local mode = "original"
	function V.setSteeringMode(m)
		assert(m == "original" or m == "provisional", "steering mode must be 'original' or 'provisional'")
		mode = m
	end
	function V.steeringMode() return mode end

	-- inside 005524f0 (player branch, after the brake / clutch devices): bf63c8 = 00552720()
	local lastShaped, lastRatio, lastTarget = 0, 0, 0
	-- V._steerMutate (TEST ONLY, nil in production): function(stage, value) -> value, used by tests/stage12 to show that
	-- the comparisons detect deliberately wrong mappings (stages "input", "shaped", "ratio", "target")
	function V._steerDevices(c)
		if mode ~= "original" then return end
		hostDevices(c)
		local x = steerInput()
		local mu = V._steerMutate
		if mu then x = mu("input", x) end
		wf32d(0xbf63c8, x)
	end
	-- 00551e80 tail from @00552082 (after 005524f0): returns the road-wheel target (x87 value) or nil in the
	-- provisional mode
	function V._steerTail(c)
		if mode ~= "original" then return nil end
		wf32d(0xbf63c0, -rf32(0xbf63c8))                                  -- FLD; FCHS; FSTP
		ignitionTimer()
		local L = linearity()
		if L ~= K_ZERO or L ~= L then                                      -- FCOMP 0; TEST AH,0x44; JNP skip
			if not digital(STEER_LEFT) and not digital(STEER_RIGHT) then
				local x = rf32(0xbf63c0)
				local y = L + K_ONE
				local v
				if x < K_ZERO or x == K_ZERO or x ~= x then              -- AND 0x4100; JNZ negative branch
					local b = -x
					v = -((b == 0) and 0 or b ^ y)                       -- _CIpow(-x, L + 1); FCHS
				else
					v = (x == 0) and 0 or x ^ y
				end
				wf32d(0xbf63c0, v)
			end
		end
		local mu = V._steerMutate
		if mu then wf32d(0xbf63c0, mu("shaped", rf32(0xbf63c0))) end
		lastShaped = rf32(0xbf63c0)
		local w = fd(lastShaped * K_PI)                                    -- FMUL pi; FSTP dword
		local r = ratio()
		if mu then r = mu("ratio", r) end
		local t = w / r                                                    -- FDIVR (x87 value)
		if mu then t = mu("target", t) end
		lastRatio, lastTarget = r, t
		return t
	end
	V._zsub = zsub

	-- bit-level access for the Stage 12 tests (ORIGINAL functions)
	V.steerInputOriginal = steerInput   -- 00552720
	V.steerRatioOriginal = ratio        -- 00554fb0
	V.steerLinearityOriginal = linearity -- 00552410
	V.steerAssistOriginal = assist      -- 00550230

	---------------------------------------------------------------------------------------------------------
	-- driver options (simulation-side setters reached through the front-end messages, table 00752540)
	---------------------------------------------------------------------------------------------------------
	-- 005502f0: linearity bf6f00 = clamp(x, 0, 1)
	local function setLinearityRaw(x)
		if not (x >= K_ZERO) and x == x then w32(0xbf6f00, 0)            -- x < 0
		elseif x >= K_ONE or x ~= x then w32(0xbf6f00, 0x3f800000)       -- x >= 1 or NaN
		else wf32(0xbf6f00, x) end
	end
	-- 005500c0(i, momentum): control rate 74c990[i] (0 steering, 1 throttle, 2 brake), per frame
	local function setMomentum(i, m)
		local p = m * K_CENTI
		if p == 0 then w32(0x74c990 + 4 * i, 0x3f800000); return end
		wf32d(0x74c990 + 4 * i, K_ONE / p * K_RATE)
	end
	local options = nil -- applied option table (survives reset)
	local function applyOptions()
		if options == nil then return end
		local o = options
		if o.linearityRaw ~= nil then setLinearityRaw(f32near(o.linearityRaw))
		elseif o.linearity ~= nil then
			-- controls.cfg value (int 0..100, slider shows 100 - value): 0043f1d0 sends (float)value * 0.01f
			setLinearityRaw(f32near(math.clamp(floor(o.linearity), 0, 100) * K_CENTI))
		end
		if o.momentum ~= nil then setMomentum(0, math.clamp(floor(o.momentum), 0, 100)) end
		if o.lowSpeedOverride ~= nil then w8(0x74c9a0, o.lowSpeedOverride and 1 or 0) end -- 00550110
		if o.yawLimiter ~= nil then
			local v = r32(SETTINGS + 0x4c)
			w32(SETTINGS + 0x4c, o.yawLimiter and bit32.bor(v, 0x2000000) or band(v, bit32.bnot(0x2000000)))
		end
	end
	-- opts: linearity (controls.cfg integer 0..100; nil = keep), linearityRaw (bf6f00 value 0..1), momentum (steering
	-- momentum 0..100, 0 = no slew limit), lowSpeedOverride (bool), yawLimiter (race settings bit 25), assist (0..100:
	-- only 0 is accepted, see steerInput). Values survive reset(); nil options = the image values (no message).
	function V.setSteeringOptions(opts)
		opts = opts or {}
		if opts.assist ~= nil and (tonumber(opts.assist) or 0) ~= 0 then
			error("NR2003 Stage 12: steering assistance > 0 needs the NR2003 track racing line: not ported")
		end
		options = table.clone(opts)
		options.assist = nil
		applyOptions()
		return V.steeringOptions()
	end
	function V.clearSteeringOptions() options = nil end
	function V.steeringOptions()
		return {linearity = rf32(0xbf6f00), steerRate = rf32(0x74c990), releaseFactor = rf32(0x74c99c),
			lowSpeedOverride = r8(0x74c9a0) ~= 0, assist = rf32(0xbf6f08), yawLimiter = settingsBit25(),
			aidsDisabled = band(r32(SETTINGS + 0x4c), 0x20000000) ~= 0, setupRatio = rf32(SETUP_RATIO)}
	end
	local baseReset = V.reset
	function V.reset()
		baseReset()
		applyOptions()
	end

	---------------------------------------------------------------------------------------------------------
	-- observation (original cells; no side effects except the speed cache bf6f44 also written by 00554f50)
	---------------------------------------------------------------------------------------------------------
	-- 005662d0: steering-wheel angle of the car model (rad, + = clockwise seen by the driver for a right turn as
	-- drawn by NR2003: -(ratio * mean front steer), left road-wheel angles are positive)
	local function wheelAngle(drawSteer, r)
		local a = -(r * drawSteer)
		if a < -K_DRAW_LOCK then return -K_DRAW_LOCK end
		if a > K_DRAW_LOCK then return K_DRAW_LOCK end
		return a
	end
	-- mean front steer of the draw state: the cell written by the ORIGINAL 00551990 (Stage 11 frame end); the
	-- Stage 6-10 frozen frame end does not run it -> the same formula on the exported state block
	local function drawSteer()
		if V.runtimeMode and V.runtimeMode() == "original" then return rf32(DRAW_STEER) end
		return fd((rf32(0xbf6d7c) + rf32(0xbf6d94)) * 0.5)
	end
	function V.steeringWheelAngle()
		return wheelAngle(drawSteer(), ratio(true))
	end
	function V.steeringState(out)
		out = out or {}
		out.mode = mode
		out.left, out.right = rf32(CTRL_RAW + 10 * STEER_LEFT), rf32(CTRL_RAW + 10 * STEER_RIGHT)
		out.digital = digital(STEER_LEFT) or digital(STEER_RIGHT)
		out.slewLeft, out.slewRight = rf32(0xbf639c), rf32(0xbf63a0)    -- 00552d00 states (controls 7 / 8)
		out.input = rf32(0xbf63c8)                                       -- 00552720 output
		out.shaped = lastShaped                                          -- after linearity (transient bf63c0)
		out.sensitivity, out.yawLimiter = sensitivity, yawLimiterFactor
		out.ratio = lastRatio                                            -- 00554fb0 of the last frame start
		out.target = rf32(0xbf63b8)                                      -- road-wheel target of the frame
		out.frameTarget, out.ramp = rf32(0xbf6e80), rf32(0xbf6e88)
		out.current = rf32(0xbf63c0)                                     -- per-tick ramped value (005539c0)
		out.lf, out.rf = rf32(0xbf6360), rf32(0xbf6364)                  -- prescribed hub inputs (toe incl.)
		out.toeLeft, out.toeRight = rf32(0xc086b0), rf32(0xc086b4)
		out.hubLF, out.hubRF = rf32(0xbf6d7c), rf32(0xbf6d94)            -- exported states 15 / 21
		out.drawSteer = drawSteer()
		out.ratioNow = ratio(true)                                      -- 00554fb0 at the current speed
		out.wheelAngle = wheelAngle(out.drawSteer, out.ratioNow)
		return out
	end
	return V
end
