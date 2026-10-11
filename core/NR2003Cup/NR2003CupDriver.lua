--!native
--!optimize 2
-- NR2003 Cup driver layer + tick sequencing (Stage 7). Installs V.drive / V.componentPose on a
-- runtime created by NR2003CupCore. Every float32 store goes through V.wf32d (IEEE single,
-- rounding toward -inf: NR2003 bg task FPU CW 0x077f, 0055cef0 -> 00567704(1,3)).
--
-- Per 36 Hz task frame (005b2190 -> 00551e80 tail, player car):
--   pedals/axes -> bf6390/bf6eac/bf6eb0, throttle^2/brake^2 targets, per-tick ramps (/N),
--   shift request (00552450/00552480).  Steering (Stage 12, NR2003CupSteering): ORIGINAL 00552720
--   (005524f0 -> bf63c8) and the 00551e80 tail (linearity, x pi, 00554fb0 ratio -> road-wheel target);
--   steering mode "provisional" keeps the Stage 6-11 host road-wheel target for the regression suites.
-- Per 288 Hz tick (005b2190 loop body):
--   005539c0 input composition (ramps, toe c086b0/c086b4, brake/clutch ramps, lifted 00553d70
--   shift FSM + auto clutch 005542f0, gear, rev limiter engine+0x438 with 006f5a3c hysteresis),
--   005b2b90 predictor+solve, 005b2cb0 export, tires (00578da0 -> 0055e1e0 x4), 005b2bd0 forces,
--   005b2be0 corrector+solve, export, tires (00578de0), forces, 005b2c00 commit.
-- Per frame end (00554520): V._frameEnd. Stages 6-10: 0051aac0 cut-timer subset (core); Stage 11:
-- the ORIGINAL 00554520 + 00549c40 lifted (NR2003CupFrame, "frozen" runtime mode = the subset).
-- Stage 8 (brake input chain, per frame, 005524f0 player branch):
--   raw brake control (0057af30 control table) -> 00552d00 axis limiter -> 00553080 pedal
--   processing (auto-hold below 0.8 m/s, key ramp, braking help 00550130) -> bf6eac; the
--   00551e80 tail squares it and ramps it per tick into bf636c -> 005b2b90 -> brake cell e84480,
--   which the ORIGINAL generated force code (005610b0 x4 + 00561040) turns into wheel torque.
-- Stage 9: frame start calls V._aeroFrame (005637e0 subset, NR2003CupAero) before frameStart.
-- Not ported (documented): replay/telemetry recording, FFB, auto-shift 005536b0 (transmission
-- mode 0), H-pattern mode (bf6f0c 1/2), ignition states driven by 005524f0/0057af40(0x19),
-- throttle/clutch device processing (00552df0/005534f0 - Stage 7 host values).
return function(V)
	local rf32, r32, ri32, w32, r8, w8 = V.rf32, V.r32, V.ri32, V.w32, V.r8, V.w8
	local wf32d, fd, rf64, wf64 = V.wf32d, V.fd, V.rf64, V.wf64
	local wf32 = V.wf32
	local callx, tires, export, frameEnd, popF = V._callx, V._tires, V._export, V._frameEnd, V._popF
	local M, BASE = V.memory(), V.base
	local TPF, ENGINE, ROOT, INPUTS = V.TPF, V.ENGINE, V.ROOT, V.INPUTS
	local abs, sqrt, atan2 = math.abs, math.sqrt, math.atan2
	-- exact-zero sums signed as under round-toward-negative (CW 0x077f; IEEE 754: x + (-x) = -0). Stage 12 change
	-- record C1 (STAGE12_RESULT.md): used by the driver-layer sums of 005539c0 and of the 00551e80 tail
	local function zadd(x, y)
		local r = x + y
		if r == 0 and not (x == 0 and y == 0 and 1 / x > 0 and 1 / y > 0) then return -0.0 end
		return r
	end
	local function zsub(x, y) return zadd(x, -y) end
	local function plainSub(x, y) return x - y end

	---------------------------------------------------------------------------------------------
	-- Stage 8: ORIGINAL brake input chain (hand port of x87 code; float32 stores round toward
	-- -inf like every store of the simulation task, intermediates in double).
	---------------------------------------------------------------------------------------------
	local CTRL_RAW, CTRL_TYPE = 0xd35b18, 0xd37cc8 -- 0057af30: f32 [d35b18+10n]; 0057af60: i32 [d37cc8+29n]
	local BRAKE_CTL, THROTTLE_CTL = 6, 5
	-- .rdata constants read from the image (same cells the original reads)
	local K_ONE, K_ZERO = rf32(0x6e97d8), rf32(0x6ea454) -- 1.0, 0.0
	local K_AXIS_LOW, K_AXIS_FAST = rf32(0x6ee390), 0x74c99c -- 0.025, release factor cell (2.5)
	local K_HOLD_SPEED, K_THROTTLE_ON = rf32(0x6efb28), rf32(0x6e9824) -- 0.8 m/s, 0.2
	local K_FLAT, K_HOLD = rf32(0x6f5a30), rf32(0x6efac8) -- 0.0087266 rad, 0.98
	local K_RAMP_UP = rf32(0x6f53c0) -- 1/12 per frame
	local K_SLOPE = rf64(0x6f5a28) -- 0.363636... (qword)
	local K_HALF, K_REL_FAST, K_REL_SLOW = rf32(0x6ea44c), rf32(0x6f4614), rf32(0x6f5a24) -- 0.5, 0.125, 1/24
	local K_HELP_SPEED, K_HELP_SLIP = rf32(0x6ea68c), rf32(0x6efbf0) -- 11 m/s, 12.5
	local K_1_5, K_R, K_F = rf32(0x6ea494), rf32(0x6f5a20), rf32(0x6f5a18) -- 1.5, -4/9, -20/33
	local K_2_1, K_R2, K_FLOOR, K_LOWHELP = rf32(0x6f5a1c), rf32(0x6f5a14), rf32(0x6ef640), rf32(0x6ed020) -- 2.1, 2/3, 0.3, 0.9
	local K_02 = 0.20000000298023224 -- literal 0x3e4ccccd (00553080 @0055323f)
	local K_PI = rf32(0x6f4a4c) -- 3.14159274 (005f74c0)
	local K_GIMBAL = rf64(0x6ef4c8) -- 0.01 (qword, 005f74c0)

	-- 00552d00(n): axis value with per-axis slew limit (controls 5..8). Returns the x87 value.
	local function axis(n)
		local raw = rf32(CTRL_RAW + 10 * n) -- 0057af30 (FLD dword; the FST copy is the same float)
		local ecx, edx
		if n == 5 then ecx, edx = 2, 1 elseif n == 6 then ecx, edx = 3, 2
		elseif n == 7 then ecx, edx = 0, 0 elseif n == 8 then ecx, edx = 1, 0 else return raw end
		local rate = rf32(0x74c990 + 4 * edx)
		if not (rate < K_ONE or rate ~= rate) then return raw end -- FCOMP 1.0; AND 0x100; JZ ret
		if not (raw >= K_AXIS_LOW or raw ~= raw) then rate = rate * rf32(K_AXIS_FAST) end -- TEST AH,5; JP
		local prev = rf32(0xbf639c + 4 * ecx)
		local v
		if raw <= prev or raw ~= raw or prev ~= prev then -- AND 0x4100; JNZ
			v = zsub(prev, rate) -- FSUBR (Stage 12 C2: an exact-zero step is -0 under RC-down, stored 80000000)
			if not (v >= raw or v ~= v or raw ~= raw) then v = raw end -- TEST AH,5; JP keep
		else
			v = rate + prev -- FADD
			if not (v <= raw or v ~= v or raw ~= raw) then v = raw end -- AND 0x4100; JNZ keep
		end
		wf32d(0xbf639c + 4 * ecx, v) -- FST dword (state), ST0 keeps the x87 value
		if edx == 0 then -- steering axes only: FMUL 1.570796326793946 (9.5e-13 below pi/2); FSIN
			-- Stage 12 C2: for a state of exactly 1.0 the x87 FSIN under RC-down returns 1 - 2^-64 (the true value is
			-- 1 - 4.5e-25; hardware-verified, recovery/stage12/evidence/reports/verify-input.md), stored as 3f7fffff; double
			-- sin gives 1.0. 1 - 2^-53 reproduces every stored result (f32 store, a8 - a7 with the other control).
			-- Every other f32 state gives the same stored f32 as the x87 (exhaustive scan).
			if v == 1 then v = 1 - 2 ^ -53 else v = math.sin(v * rf64(0x6f5a00)) end
		end
		return v
	end

	-- 00554f50: vehicle speed |v| from the exported state block, cached in bf6f44 (float32).
	-- The original recomputes when the timer-interrupt count changes; the state block does not
	-- change inside a frame start, so recomputing on every call returns the same value.
	local function speed()
		local vz, vy, vx = rf32(0xbf6d54), rf32(0xbf6d4c), rf32(0xbf6d44)
		wf32d(0xbf6f44, sqrt((vz * vz + vy * vy) + vx * vx))
		return rf32(0xbf6f44)
	end

	-- 005f7570 = 005f6e40 (quaternion xyzw -> row-major 3x3, float32 stores) + 005f74c0 (angles).
	-- Returns the three float32 outputs (out1, out2, out3) in the original order.
	local function attitude(q)
		local x, y, z, w = rf32(q), rf32(q + 4), rf32(q + 8), rf32(q + 12)
		local w2 = w + w
		local wx, wy, wz = w2 * x, w2 * y, w2 * z
		local ww = fd(w2 * w)
		local x2 = x + x
		local e0, e4 = fd(x2 * y), fd(x2 * z)
		local y2 = y + y
		local e8, ec = fd(y2 * z), fd(y2 * y)
		local e10 = fd((z * z) + (z * z))
		local m0 = fd((x2 * x + ww) - K_ONE)
		local m1 = fd(e0 - wz)
		local m2 = fd(e4 + wy)
		local m3 = fd(e0 + wz)
		local m4 = fd((ec + ww) - K_ONE)
		local m5 = fd(e8 - wx)
		local m6 = fd(e4 - wy)
		local m7 = fd(e8 + wx); local _ = m7
		local m8 = fd((e10 + ww) - K_ONE); local _2 = m8
		local a1 = fd(atan2(m3, m0))
		local c = sqrt(m0 * m0 + m3 * m3)
		local a2 = fd(atan2(-m6, c))
		local a3
		if c >= K_GIMBAL or c ~= c then
			local ic = K_ONE / c
			local nA, B = -(ic * m3), ic * m0
			local Y = -(B * m5 + nA * m2)
			local X = B * m4 + nA * m1
			a3 = fd(atan2(Y, X))
		else
			local r = a1 - atan2(m5, m2)
			a3 = fd(r)
			if not (m6 <= K_ZERO or m6 ~= m6) then a3 = fd(K_PI - r) end
		end
		return a1, a2, a3
	end

	-- 00550130: braking help option (bf6f04), disabled per car by flag 0x20000000 at
	-- 0055a680()+0x4c (inServer() = false offline; simulation runs inBackground()).
	local function brakingHelp()
		if bit32.band(r32(0xc0692a + 0x4c), 0x20000000) ~= 0 then return false end
		return r8(0xbf6f04) ~= 0
	end

	-- 00553080: processed brake pedal (returned as the x87 value; 005524f0 stores it to bf6eac)
	local function pedal()
		-- 005c2d20([c08194]) is the online-session state; offline host -> 0 (ADAPTER), so the
		-- driver kind comes from 005672e0 -> 0055a730 = [c067e0] (1 -> brake fully applied)
		local r
		if ri32(0xc067e0) == 1 then r = K_ONE else r = fd(axis(BRAKE_CTL)) end
		local spd = speed()
		local hold = false
		if not (spd >= K_HOLD_SPEED or spd ~= spd) then
			if rf32(0xbf6390) < K_THROTTLE_ON then hold = true
			elseif ri32(0x74c97c) == 1 then hold = true end -- neutral
		end
		if hold then
			local _, a2, a3 = attitude(0xbf6d58)
			local pa = abs(a2)
			if not (pa >= K_FLAT or pa ~= pa) then
				if r >= K_HOLD or r ~= r then return r end
				local v = rf32(0xbf6eac) + K_RAMP_UP
				if v < K_HOLD or v == K_HOLD then return v end
				return K_HOLD
			end
			local h
			local pr = abs(a3)
			if pr <= K_ZERO or pr ~= pr then h = K_02
			else
				local q = pa * K_SLOPE / pr
				if not (q <= K_ONE or q ~= q) then q = K_ONE end
				h = fd((K_ONE - q) * K_HOLD)
				if not (h >= K_THROTTLE_ON or h ~= h) then h = K_02 end
			end
			if not (r >= h or r ~= r or h ~= h) then
				local v = rf32(0xbf6eac) + K_RAMP_UP
				if v < h or v == h then return v end
				return h
			end
		end
		-- 0055327b: button/key binding (0057af60(6)) -> per-frame ramp toward the key state
		if ri32(CTRL_TYPE + 29 * BRAKE_CTL) ~= 1 then
			local t = fd(axis(THROTTLE_CTL))
			local p = rf32(0xbf6eac)
			local v
			if not (p >= r or p ~= p or r ~= r) then v = p + K_RAMP_UP
			elseif p <= r or p ~= p or r ~= r then v = r
			elseif t >= K_HALF or t ~= t then v = p - K_REL_FAST
			else v = p - K_REL_SLOW end
			if v >= K_ZERO or v ~= v then
				if not (v <= K_ONE or v ~= v) then v = K_ONE end
			else v = K_ZERO end
			r = fd(v)
		end
		-- 0055332c: braking help (driving aid) while the pedal is rising
		if brakingHelp() then
			local p = rf32(0xbf6eac)
			if p > r or p ~= p or r ~= r then return r end
			local s = speed()
			if s <= K_HELP_SPEED or s ~= s then return r * K_LOWHELP end
			local s0, s1, s2, s3 = rf32(0xbf3cd4), rf32(0xbf470d), rf32(0xbf5146), rf32(0xbf5b7f)
			local A, B = s0, s2
			if not (s1 <= A or s1 ~= s1 or A ~= A) then A = s1 end
			if not (s3 <= B or s3 ~= s3 or B ~= B) then B = s3 end
			local mn = s0
			if not (s1 >= mn or s1 ~= s1 or mn ~= mn) and s1 ~= K_ZERO then mn = s1 end
			if not (s2 >= mn or s2 ~= s2 or mn ~= mn) and s2 ~= K_ZERO then mn = s2 end
			if not (s3 >= mn or s3 ~= s3 or mn ~= mn) and s3 ~= K_ZERO then mn = s3 end
			if not (mn <= K_HELP_SLIP or mn ~= mn) then return r end
			local x = (B - K_1_5) * K_R
			local y = fd((A - K_2_1) * K_F)
			if not (x < y) then x = y end
			if not (x < K_ZERO or x ~= x) then x = (K_1_5 - B) * K_R2 end
			x = x * K_REL_FAST + rf32(0xbf6eac)
			if not (x >= K_FLOOR or x ~= x) then x = K_FLOOR end
			if x <= r or x ~= x or r ~= r then return x end
			return r
		end
		return r
	end
	V.brakePedalOriginal = pedal -- exposed for the bit-level tests (tests/stage8)
	V.attitudeOriginal = attitude
	V.axisOriginal = axis

	-- 005524f0 'car not driven' branch (another car / no driver): pedal held at 1.0
	local function notDriven()
		for _, a in ipairs({0xbf63c8, 0xbf6f14, 0x74c98c, 0xbf6388, 0xbf6e84, 0xbf63bc, 0xbf638c, 0xbf6390, 0xbf6eb0}) do w32(a, 0) end
		w32(0xbf6eac, 0x3f800000)
		w8(0xbf6e20, 0); w8(0xbf6e21, 0); w8(0xbf6e22, 0)
	end

	-- frame start: 005524f0 (driver devices) + 00551e80 tail for the player car.
	-- controls: throttle pedal 0..1, clutch = engagement 0..1 (1 = pedal up), shiftUp/shiftDown =
	-- sequential shift keys. Steering (Stage 12): steerLeft/steerRight (controls 7/8, 0..1) + steerDigital,
	-- or steerAxis (-1..1, + right); steer = road-wheel target (rad, + = left) only in the steering mode
	-- "provisional" (Stage 6-11 contract, regression suites).
	-- Brake (Stage 8): brakeControl = raw brake control value 0..1 of the input device (keyboard
	-- 0/1 or pedal axis), brakeDigital = key/button binding (default true; false = analog axis),
	-- throttleControl/throttleDigital = raw throttle control (key release-rate choice in 00553080).
	-- Without brakeControl, controls.brake is injected directly as the processed pedal bf6eac
	-- (Stage 6/7 contract, kept for regression fixtures). driver = false -> 005524f0 'not driven'.
	local function frameStart(c)
		local N = ri32(0xbf6e9c)
		if c.driver == false then
			notDriven()
		else
			if c.brakeControl ~= nil then
				local bc = math.clamp(tonumber(c.brakeControl) or 0, 0, 1)
				wf32(CTRL_RAW + 10 * BRAKE_CTL, bc)
				w32(CTRL_TYPE + 29 * BRAKE_CTL, c.brakeDigital == false and 1 or 0)
				local tc = c.throttleControl
				if tc == nil then tc = c.throttle or 0 end
				wf32(CTRL_RAW + 10 * THROTTLE_CTL, math.clamp(tonumber(tc) or 0, 0, 1))
				w32(CTRL_TYPE + 29 * THROTTLE_CTL, c.throttleDigital == false and 1 or 0)
				if r8(0xbf6eb9) ~= 0 then -- 005524f0: car held (bf6eb9)
					w32(0xbf6eac, 0x3f800000); w32(0xbf6eb0, 0)
				else
					wf32d(0xbf6eac, pedal()) -- ORIGINAL 00553080 (reads the previous frame's bf6390)
					wf32d(0xbf6eb0, c.clutch or 0)
				end
			else
				wf32d(0xbf6eac, c.brake or 0)
				wf32d(0xbf6eb0, c.clutch or 0)
			end
			-- Stage 12: bf63c8 = ORIGINAL 00552720 (steering devices), NR2003CupSteering
			if V._steerDevices then V._steerDevices(c) end
			wf32d(0xbf6390, c.throttle or 0)
		end
		for w = 0, 3 do -- per-frame tire accumulators cleared by 00551e80 (bf3ccc.., bf4705.., ...)
			local t = 0xbf3a20 + w * 0xa39
			w32(t + 0x2ac, 0); w32(t + 0x2b0, 0); w32(t + 0x2b4, 0); w32(t + 0x2b8, 0)
			w32(t + 0x2d0, 0); w32(t + 0x2d4, 0); w32(t + 0x2bc, 0); w32(t + 0x2c0, 0)
		end
		-- Stage 12: road-wheel target of the ORIGINAL 00551e80 tail (linearity, x pi, / 00554fb0 ratio), or the
		-- Stage 6-11 PROVISIONAL host target in the steering mode "provisional" (regression suites only)
		local target = V._steerTail and V._steerTail(c)
		local provisional = target == nil
		if provisional then target = c.steer or 0 end
		wf32d(0xbf63b8, target)
		w32(0xbf6e38, r32(0xbf6eb0))
		w32(0xbf63c0, r32(0xbf6e80)); w32(0xbf636c, r32(0xbf6e64))
		w32(0xbf6ea4, r32(0xbf6e60)); w32(0xbf6e14, r32(0xbf6e68))
		local thr, brk = rf32(0xbf6390), rf32(0xbf6eac)
		wf32d(0xbf6e30, thr * thr); wf32d(0xbf6e34, brk * brk)
		-- ramps (/N): the original tail signs exact-zero differences under RC-down (x - x = -0); the provisional
		-- mode keeps the Stage 6-11 arithmetic of its golden data (Python hand port of the tail)
		local sub = provisional and plainSub or zsub
		wf32d(0xbf6e88, sub(target, rf32(0xbf6e80)) / N)
		wf32d(0xbf6394, sub(rf32(0xbf6e30), rf32(0xbf6e60)) / N)
		wf32d(0xbf6358, sub(rf32(0xbf6e34), rf32(0xbf6e64)) / N)
		local cl = sub(rf32(0xbf6eb0), rf32(0xbf6e68))
		buffer.copy(M, 0xbf6e58 - BASE, M, 0xbf6e28 - BASE, 36) -- rep movsd bf6e28 -> bf6e58 (9 dwords)
		wf32d(0xbf6e50, cl / N)
		wf32d(0xbf6e80, target)
		-- sequential shift request (bf6f0c == 0, transmission mode 0074c974 ~= 0); the 'not driven'
		-- branch of 005524f0 clears the shift keys (bf6e20/21/22)
		if c.driver ~= false and ri32(0xbf6f0c) ~= 2 and ri32(0xbf63cc) == 0 and ri32(0x74c974) ~= 0 and ri32(0xbf6f0c) == 0 then
			local d = (c.shiftUp and 1 or 0) - (c.shiftDown and 1 or 0)
			local st = ri32(0xbf6ea0)
			if d ~= 0 and (st == 0 or st == 3 or st == 4) then
				w32(0xbf63cc, d > 0 and 1 or 5); w32(0xbf6e98, 0)
			end
		end
	end

	-- 005539c0 input composition (player car; replay/telemetry recording not ported)
	-- Stage 12 (scoped correction, STAGE12_RESULT.md change record C1): the steering / pedal composition sums
	-- (@00553a40..00553ab5) sign exact-zero sums as the x87 under RC-down; until Stage 11 they returned
	-- +0 where the original stores -0 (e.g. +0 + -0 at rest). Only the sign of a zero changes.
	local function tickInputs()
		wf64(0xbf6ef8, rf64(0xbf6ef8) + rf32(0x74fd74))
		wf32d(0xbf6ea4, zadd(rf32(0xbf6394), rf32(0xbf6ea4)))
		wf32d(0xbf63c0, zadd(rf32(0xbf6e88), rf32(0xbf63c0)))
		wf32d(0xbf6360, zadd(rf32(0xbf63c0), -rf32(0xc086b0)))
		w32(0xbf6368, r32(0xbf6ea4))
		wf32d(0xbf6364, zadd(rf32(0xc086b4), rf32(0xbf63c0)))
		wf32d(0xbf636c, zadd(rf32(0xbf636c), rf32(0xbf6358)))
		local c = zadd(rf32(0xbf6e50), rf32(0xbf6e14))
		wf32d(0xbf6e14, c); wf32d(0xbf6370, c)
		callx(0x553d70) -- lifted original: shift FSM, throttle blip/cut, auto clutch (005542f0)
		wf32d(0xbf6374, ri32(0x74c97c))
		-- rev limiter (005539c0): engine+0x438 (Cup 9300 rpm), band = max * 006f5a3c
		local maxr = rf32(ENGINE + 0x438)
		callx(0x554f10) -- lifted original rpm (state[34] * 9.5493, clamp 300..32000)
		local rpm = popF()
		local rpm32 = fd(rpm)
		local band = fd(maxr * rf32(0x6f5a3c))
		if maxr < rpm or ((maxr - band) < rpm32 and r8(0xbf6f3c) ~= 0) then
			w32(0xbf6368, 0); w8(0xbf6f3c, 1)
		elseif not ((maxr - band) < rpm32) then
			w8(0xbf6f3c, 0)
		end
	end

	-- one 288 Hz tick. contacts: 4 planes or function(phase) -> 4 planes (see core tires()).
	-- Stage 9: the per-frame car update 005637e0 (aero factors, airspeed, drafting) runs in
	-- 0055bfd0 before 005b2190 starts the frame; V._aeroFrame is installed by NR2003CupAero and
	-- does nothing until a session is started (post-build state of Stages 6-8).
	-- Stage 11 (integration point): the task loop increments getBGCount before the frame
	-- (V._frameStart11) and the frame end is looked up at run time (V._frameEnd): NR2003CupFrame
	-- replaces the Stage 6-10 subset by the ORIGINAL 00554520 + 00549c40.
	-- the frame start of the 36 Hz task frame (task loop counter, 005637e0 aero subset, 005524f0 + 00551e80);
	-- also called alone by the Stage 12 frame-start snapshot tests
	local function frameStartAll(controls)
		if V._frameStart11 then V._frameStart11() end
		if V._aeroFrame then V._aeroFrame() end
		frameStart(controls)
	end
	V._frameStartOnly = frameStartAll
	function V.drive(controls, contacts)
		if V.tick % TPF == 0 then frameStartAll(controls) end
		w32(0xe8441c, V.tick % TPF)
		w8(0xe843fc, 1)
		tickInputs()
		callx(0x5b2b90, ROOT, INPUTS); export()
		tires(contacts, 1); callx(0x5b2bd0)
		w8(0xe843fc, 0)
		callx(0x5b2be0); export()
		tires(contacts, 2); callx(0x5b2bd0)
		callx(0x5b2c00)
		V.tick += 1
		if V.tick % TPF == 0 then V._frameEnd() end
	end

	-- component world transforms (vehicle-world axes) through the record pointer fields
	-- (+0x32d position, +0x339 row-major body->world 3x3) used by the original export/render paths.
	-- Records: 0 chassis, 4 lfhub, 5 lfwheel, 7 rfhub, 8 rfwheel, 9 raxle, 10 lrwheel, 11 rrwheel.
	local POSP, ROTP = {}, {}
	for r = 0, 15 do
		local rec = ROOT + r * 0x505
		POSP[r] = { r32(rec + 0x32d), r32(rec + 0x331), r32(rec + 0x335) }
		local rot = {}
		for k = 0, 8 do rot[k + 1] = r32(rec + 0x339 + 4 * k) end
		ROTP[r] = rot
	end
	function V.componentPose(r, pos, rot)
		pos = pos or table.create(3, 0); rot = rot or table.create(9, 0)
		local p, q = POSP[r], ROTP[r]
		pos[1], pos[2], pos[3] = rf32(p[1]), rf32(p[2]), rf32(p[3])
		for k = 1, 9 do rot[k] = rf32(q[k]) end
		return pos, rot
	end

	-- engine/drivetrain readouts (original cells)
	function V.engineRpm() return rf32(0xbf6d40 + 4 * 34) * 9.549296585513721 end -- state[34] rad/s
	function V.gearIndex() return ri32(0x74c97c) end      -- 0 = R, 1 = N, 2.. = 1st..
	function V.gearCount() return ri32(ENGINE + 0x444) end -- Cup: 4
	function V.revLimiter() return r8(0xbf6f3c) ~= 0 end
	function V.inputs()
		return rf32(0xbf6360), rf32(0xbf6364), rf32(0xbf6368), rf32(0xbf636c), rf32(0xbf6370), rf32(0xbf6374)
	end

	---------------------------------------------------------------------------------------------
	-- Stage 8: brake setup + read-only brake/tire observation (original cells, no side effects)
	---------------------------------------------------------------------------------------------
	local SETUP_BIAS = 0xc055c0 + 4 * 0x28 -- active setup item 0x28 (00557d60(0x28)): front fraction
	local BIAS_DESC = 0x6edf78 -- setup descriptor of item 0x28: int min/max/step/default (50/90/1/74 %)
	local KB = {} -- per-wheel brake torque cells (0055e9b0 -> c0850c..c08518, JIT cells)
	local RR = {} -- per-wheel rolling-resistance torque cells (0054cab0 -> c081f4..c08200)
	local BRAKE_CELL, DRAG0, DRAG2, RATE
	local WHEEL_RECORD = {[0] = 5, 8, 10, 11} -- lfwheel, rfwheel, lrwheel, rrwheel (00561090/1230/1250/1270)
	local OMEGA, INERTIA = {}, {}
	-- the cell addresses are allocated by the car build (emitter cells); Stage 10 rebuilds the car for a
	-- garage setup (NR2003CupGarage), possibly with the generic callback structure whose constant cells
	-- differ: the garage re-binds them after every rebuild (V._bindDriverCells)
	local function bindCells()
		for w = 0, 3 do KB[w] = r32(0xc0850c + 4 * w); RR[w] = r32(0xc081f4 + 4 * w) end
		BRAKE_CELL = r32(0xe84480) -- e84474[3]: core brake input written by 005b2b90 from bf636c
		DRAG0, DRAG2, RATE = r32(0x74e798), r32(0x74e79c), r32(0x74fda0) -- 10, 1e-4, 288 (005610b0)
		for w = 0, 3 do
			local rec = ROOT + WHEEL_RECORD[w] * 0x505
			OMEGA[w] = r32(rec + 0x395)   -- spin joint velocity cell (velocity +0x385, axis 4)
			INERTIA[w] = r32(rec + 0x195) -- articulated spin inertia cell (mass matrix +0x125, [4][4])
		end
	end
	bindCells()
	V._bindDriverCells = bindCells
	local scratch = buffer.create(4)

	-- garage brake bias (front %, integer 50..90) -> setup item 0x28 -> runtime cells, exactly as
	-- the original car build does: toInternal 00423de0 (pct * 0.01f, x87 default CW = nearest),
	-- then 0055e9b0 @0055f314: Kb[LF]=Kb[RF]=fd(maxT*b), Kb[LR]=Kb[RR]=fd(maxT*fd(1-b)),
	-- maxT = car spec +0x1bc via slot +0x582 (Cup 3800 N*m). The original has no in-car brake bias
	-- adjustment (0055e6d0 is unreferenced): apply after reset(), before driving.
	function V.setBrakeBias(percent)
		local lo, hi = ri32(BIAS_DESC + 2), ri32(BIAS_DESC + 6)
		local p = math.clamp(math.floor((tonumber(percent) or ri32(BIAS_DESC + 14)) + 0.5), lo, hi)
		buffer.writef32(scratch, 0, rf32(0x6ea4a4)); local k = buffer.readf32(scratch, 0)
		buffer.writef32(scratch, 0, p * k)
		wf32(SETUP_BIAS, buffer.readf32(scratch, 0))
		local b, maxT = rf32(SETUP_BIAS), rf32(0xc12030 + 0x582)
		local front, rest = fd(maxT * b), fd(K_ONE - b)
		local rear = fd(maxT * rest)
		wf32(KB[0], front); wf32(KB[1], front); wf32(KB[2], rear); wf32(KB[3], rear)
		return p
	end
	function V.brakeBias()
		local b = rf32(SETUP_BIAS)
		return b, math.floor(b * 100 + 0.5), rf32(0xc12030 + 0x582)
	end

	-- brake chain readout: processed pedal (bf6eac), frame target pedal^2 (bf6e34), per-tick ramp
	-- value (bf636c) and the core brake cell (e84480) used by the force code
	function V.brakeState()
		return rf32(0xbf6eac), rf32(0xbf6e34), rf32(0xbf636c), rf32(BRAKE_CELL)
	end

	-- brake temperature of wheel w (K): XOR-obfuscated storage of the tire object (+0x26c ^ +0x274),
	-- evolved per frame by 0054f260 inside 0054d610 (Stage 11: frozen at the build value)
	function V.brakeTemperature(w)
		local t = 0xbf3a20 + w * 0xa39
		buffer.writeu32(scratch, 0, bit32.bxor(r32(r32(t + 0x26c)), r32(r32(t + 0x274))))
		return buffer.readf32(scratch, 0)
	end

	-- per-wheel observation of the last tire + forces pass (w: 0 LF, 1 RF, 2 LR, 3 RR)
	--   torque   : friction/brake torque recorded by the original 0055e450..0055e480 (tire +0x268)
	--   kb       : brake torque per unit core brake input (setup cells)
	--   brakeCap : core brake input * kb (brake share of the 00561040 capacity)
	--   dragCap  : 10 + 1e-4*omega^2 + rolling-resistance torque (rest of the capacity)
	--   omega    : wheel spin rate relative to its hub/axle (rad/s); inertia = articulated Iyy
	--   fx/fy/fz : tire outputs (+0x2d8/+0x2dc/+0x2e0, tire frame), vx: contact longitudinal
	--              velocity (+0x2f0), vslip: tread - ground (+0x2ec), tread: |band speed| (+0x2cc)
	function V.wheelBrake(w, out)
		out = out or {}
		local t = 0xbf3a20 + w * 0xa39
		local core, kb, om = rf32(BRAKE_CELL), rf32(KB[w]), rf32(OMEGA[w])
		out.torque = rf32(t + 0x268); out.kb = kb; out.brakeCap = core * kb
		out.dragCap = rf32(DRAG0) + om * om * rf32(DRAG2) + rf32(RR[w])
		out.omega = om; out.inertia = rf32(INERTIA[w]); out.rate = rf32(RATE)
		out.fx = rf32(t + 0x2d8); out.fy = rf32(t + 0x2dc); out.fz = rf32(t + 0x2e0)
		out.vx = rf32(t + 0x2f0); out.vslip = rf32(t + 0x2ec); out.tread = rf32(t + 0x2cc)
		out.rollingTorque = rf32(RR[w])
		out.temperature = V.brakeTemperature(w)
		-- presentation-only lock indicator: tread speed ~ 0 while the contact still slides
		out.locked = abs(out.vx) > 0.5 and out.tread < 0.05 * abs(out.vx)
		return out
	end
	return V
end
