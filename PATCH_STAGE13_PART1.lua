-- PATCH_STAGE13 parte 1/2 — NR2003 Roblox port, estágio 13 (instalação em partes pela Command Bar).
-- Cole as partes 1..2 em ordem (cada uma inteira, FORA do Play) e depois PATCH_STAGE13_INSTALL.lua.
-- As partes só guardam fontes em ServerStorage.NR2003Stage13Staging; nada muda no jogo até o INSTALL.
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes do patch")
local storage=game:GetService("ServerStorage")
local SES=game:GetService("ScriptEditorService")
local function setSource(s,src)
    if #src<200000 then s.Source=src else SES:UpdateSourceAsync(s,function() return src end) end
end
local staging=storage:FindFirstChild("NR2003Stage13Staging")
if not staging then staging=Instance.new("Folder");staging.Name="NR2003Stage13Staging";staging.Parent=storage end
local function stage(key,source)
    local old=staging:FindFirstChild(key);if old then old:Destroy() end
    local s=Instance.new("ModuleScript");s.Name=key;setSource(s,source);s.Parent=staging
    assert(#s.Source==#source,"fonte truncada: "..key)
end
stage("NR2003Cup.NR2003CupDriver",[=[
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
-- Stage 13: tickInputs runs the ORIGINAL 00554d30 (V._ffbTick, NR2003CupFFB) at its slot @00553a64; frameStart takes
-- the 005524f0 not-driven branch while bf6eb8 (player controls suspended, 00550070) is set.
-- Not ported (documented): replay/telemetry recording, auto-shift 005536b0 (transmission
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
		-- Stage 13: 005524f0 @00552549 also takes the not-driven branch while the player controls are suspended
		-- (bf6eb8, written by the ORIGINAL 00550070: NR2003CupFFB.setControlsSuspended / car placement)
		if c.driver == false or r8(0xbf6eb8) ~= 0 then
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
		-- Stage 13 (@00553a64): ORIGINAL 00554d30 front tyre statistics for the force feedback (NR2003CupFFB)
		local ffb = V._ffbTick
		if ffb then ffb() end
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
]=])
stage("NR2003Cup.NR2003CupFrame",[=[
--!optimize 2
-- GENERATED by recovery/stage11/gen_stage11.py from recovery/stage11/frame_host.luau; do not edit.
-- Stage 11: the ORIGINAL per-frame runtime systems of the NR2003 Cup car (fuel, mass, tyre thermal / pressure /
-- wear / failure, brake temperature, engine thermal / damage / failure, random failures, collision damage), run
-- by code lifted from NR2003.exe (NR2003CupFrameCode*) on the core memory, in the order of the simulation task:
--
--   task loop 005f78f0       ++getBGCount (0x7559bc) before the frame                       V._frameStart11
--   0055bfd0 -> 005637e0     aero factors / airspeed / drafting (Stage 9, NR2003CupAero)      V._aeroFrame
--   005b2190                 00551e80 frame start, 8 x 288 Hz ticks (Stages 6-8)               NR2003CupDriver
--             -> 00554520    FRAME END (whole ORIGINAL function, lifted):                     V._frameEnd
--                  00551ce0 attitude filter, [005547a0 world/replay record: host], bf3a00 = airspeed,
--                  radiator air factor (1 - grille tape, damage) -> 0051a830, 0051aac0 engine (ignition and
--                  misfire, fuel burn, water / oil temperature and level, wear and failure), 0051c3d0 random
--                  component failures, 005605c0 fuel mass -> fuel component record, 00551990 car snapshot +
--                  per tyre 0054d610 (thermal zones, hot pressure, wear 0054e9f0, brake temperature 0054f260)
--   0055bfd0 -> 00549c40     collision damage of the records of this frame (lifted)
--
-- Host boundary (ADAPTER, documented in STAGE11_RECOVERY.md, identical in the Unicorn reference harness
-- recovery/stage11/orig_stage11.py): 005547a0 / 00592dc0 / 00557650 / 005d08d0 return immediately (track and
-- replay recorders, multiplayer damage sync, collision sound, force feedback: Stage 13 evaluates the FFB block in
-- NR2003CupFFB and delivers 005d08d0 to the host device layer); 005f58d0 (track point) copies the
-- point and clears the track-query fields (no track loaded); the car world record (car+0x5ae) is posed from the
-- exported state like 005543f0 does (position, 005f5a60 rotation, 005f5ac0 velocities) before the frame end.
-- Pure Luau: no Instances.
local CODE_PARTS, DATA_PARTS = 4, 1
local band = bit32.band
local ru, wu, rf, wf = buffer.readu32, buffer.writeu32, buffer.readf32, buffer.writef32

local B64 = {}
do
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	for i = 1, 64 do B64[string.byte(chars, i)] = i - 1 end
end
local function b64into(dst, off, s)
	local o = off
	for i = 1, #s, 4 do
		local a, b, c, d = string.byte(s, i, i + 3)
		local x = B64[a] * 262144 + B64[b] * 4096 + (c ~= 61 and B64[c] or 0) * 64 + (d ~= 61 and B64[d] or 0)
		buffer.writeu8(dst, o, bit32.rshift(x, 16)); o += 1
		if c ~= 61 then buffer.writeu8(dst, o, band(bit32.rshift(x, 8), 0xff)); o += 1 end
		if d ~= 61 then buffer.writeu8(dst, o, band(x, 0xff)); o += 1 end
	end
	return o - off
end

local CAR = 0xc12030
local ENGINE = CAR + 0xc
local DAMAGE = CAR + 0x1493          -- car vtable slots 1/2 (00592db0): damage object
local TIRE0, TIRE_STRIDE = 0xbf3a20, 0xa39
local BGCOUNT = 0x7559bc             -- getBGCount (005f7cb0)
-- getIntCount (005f7cd0): timer-interrupt counter, a host clock. ADAPTER (same convention as the Stage 8 harness,
-- orig_brake.INTCOUNT): +1 per frame at the frame start. Read by the lifted 00567660 (tyre / continuous contact
-- records 0054a8d0: table row copy + getIntCount stamp at car+0x1323); the Stage 8 speed cache (00554f50) is
-- recomputed in Luau and ignores it
local INTCOUNT = 0x7559c4
local RNG = 0xf6eae4                 -- rndInt (005f5670) state of stream 0 (+4: stream 1)
local SETTINGS = 0xc0692a            -- race settings (0055a680)
local FRAME_STACK = 0xf7e000
local HOST = 0xf7f100
local TOBJ = HOST + 0x680            -- Stage 9 car world record block (0x32c bytes)
local S11 = 0xf7a000                 -- Stage 11 host blocks (unreferenced BSS): contact objects, body proxies, vectors
local KEYS, BODY, OTHER, VEC = S11, S11 + 0x80, S11 + 0x280, S11 + 0x480
-- ADAPTER host geometry: the car's collision object of the track system (c7e75c; built by the unrecovered track
-- collision code when the car is placed in the world, null in the bench): container + 9 parts (+0x18..+0x24 wheel
-- parts, +0x28..+0x38 deformable body parts), read by the original damage code 0054b0d0 / 00549860 / 0054a8d0 /
-- 00577cb0. No collision-mesh deformation is simulated by the host: zeroed parts (PROVISIONAL; Unicorn reference identical)
local COLL, COLL_PARTS, COLL_OBJ, HOST_SIZE = S11 + 0x500, S11 + 0x540, 0xc7e75c, 0x7c8

-- V: core with driver (NR2003CupDriver), aero (NR2003CupAero) and garage (NR2003CupGarage) installed
return function(V, codeParts, dataParts)
	assert(#codeParts == CODE_PARTS, "NR2003CupFrameCode: expected " .. CODE_PARTS .. " parts, found " .. #codeParts)
	assert(#dataParts == DATA_PARTS, "NR2003CupFrameData: expected " .. DATA_PARTS .. " parts, found " .. #dataParts)
	local M, BASE = V.memory(), V.base
	local PRISTINE = V._pristine()

	-- image supplement: cells of the original post-build memory that only the Stage 11 code touches
	local zbuf = buffer.create(4096)
	local SUPPLEMENT = 0
	for _, d in ipairs(dataParts) do
		for _, z in ipairs(d.zero) do
			local off, len = z[1], z[2]
			while len > 0 do
				local n = math.min(len, 4096)
				buffer.copy(PRISTINE, off, zbuf, 0, n); off += n; len -= n
			end
			SUPPLEMENT += z[2]
		end
		for _, x in ipairs(d.data) do SUPPLEMENT += b64into(PRISTINE, x[1], x[2]) end
	end

	local ctx = {M = M, base = BASE, F = {}, R = table.create(10, 0), XF = {}}
	for _, p in ipairs(codeParts) do p(ctx) end
	local XF, R = ctx.XF, ctx.R

	local function r32(a) return ru(M, a - BASE) end
	local function w32(a, v) wu(M, a - BASE, band(v)) end
	local function rf32(a) return rf(M, a - BASE) end
	local function wf32(a, v) wf(M, a - BASE, v) end
	local S = buffer.create(8)
	local function f2u(x) buffer.writef32(S, 0, x); return buffer.readu32(S, 0) end
	local function u2f(u) buffer.writeu32(S, 0, u); return buffer.readf32(S, 0) end

	-- call an ORIGINAL lifted function (cdecl args, optional ECX for thiscall) on the Stage 11 register file
	local function callx(addr, ecx, ...)
		local args = { ... }
		local n = #args
		local esp = FRAME_STACK - 4 * (n + 1)
		for k = 1, n do w32(esp + 4 * k, args[k]) end
		w32(esp, 0)
		for k = 1, 7 do R[k] = 0 end
		R[8] = esp; R[9] = 0; R[10] = 0
		if ecx then R[3] = ecx end
		table.clear(ctx.F)
		local f = XF[addr]
		if not f then error(string.format("NR2003 Stage 11: %08x not lifted", addr)) end
		f()
		assert(R[8] == esp + 4 * (n + 1) - 4 * n or R[8] == esp + 4, "NR2003 Stage 11: unbalanced stack")
		return R[1]
	end
	V._callx11 = callx

	-------------------------------------------------------------------------------------------------------------
	-- mode: "original" = the ORIGINAL frame end and collision frame (production); "frozen" = the Stage 6-10 frame
	-- end (0051aac0 cut-timer subset only: every Stage 11 state held at its post-build value), kept ONLY to
	-- compare against the Stage 6-10 golden data, which were produced by the original code with that frame end.
	-------------------------------------------------------------------------------------------------------------
	local mode = "original"
	local frozenFrameEnd = V._frameEnd
	local session11 = nil      -- Stage 11 session options applied at startSession (survive reset)

	local function ensureWorldRecord()
		if r32(CAR + 0x5ae) == 0 then
			wf32(TOBJ + 0x24, 0); wf32(TOBJ + 0x28, 0); wf32(TOBJ + 0x2c, 1)
			w32(CAR + 0x5ae, TOBJ)
		end
	end
	-- 005543f0 without the track query: world record <- exported state (position, rotation, velocities)
	local function syncWorldRecord()
		ensureWorldRecord()
		local rec = r32(CAR + 0x5ae)
		w32(rec, r32(0xbf6d40)); w32(rec + 4, r32(0xbf6d48)); w32(rec + 8, r32(0xbf6d50))
		callx(0x5f5a60, nil, rec, 0xbf6d58)
		local v = VEC + 0x60
		w32(v, r32(0xbf6d44)); w32(v + 4, r32(0xbf6d4c)); w32(v + 8, r32(0xbf6d54))
		callx(0x5f5ac0, nil, rec, v, 0xbf6d68)
	end
	local function hostBlocks()
		for a = S11, S11 + HOST_SIZE - 4, 4 do w32(a, 0) end
		for k = 0, 7 do w32(KEYS + 16 * k + 4, BODY) end
		w32(BODY + 0x1a4, 0); w32(OTHER + 0x1a4, 1)
		for k = 0, 8 do w32(COLL + 0x18 + 4 * k, COLL_PARTS + 0x48 * k) end
		w32(COLL_OBJ, COLL)
	end

	local function frameStart11()
		if mode ~= "original" then return end
		w32(BGCOUNT, r32(BGCOUNT) + 1)
		w32(INTCOUNT, r32(INTCOUNT) + 1)
	end
	local function frameEnd11()
		if mode ~= "original" then frozenFrameEnd(); return end
		syncWorldRecord()
		-- Stage 13: the force-feedback block of 00554520 (0055464c..0055479d) is evaluated by NR2003CupFFB in exact x87
		-- arithmetic right after the lifted function (V._ffbFrameEnd: where the block ends the function); the lifted copy
		-- (IEEE double intermediates) is skipped by presenting bf6ebb = 0, its only reader in 00554520 / 00549c40
		local ffb = V._ffbFrameEnd
		if ffb then
			local acquired = buffer.readu8(M, 0xbf6ebb - BASE)
			buffer.writeu8(M, 0xbf6ebb - BASE, 0)
			callx(0x554520, nil)
			buffer.writeu8(M, 0xbf6ebb - BASE, acquired)
			ffb()
		else
			callx(0x554520, nil)
		end
		-- ADAPTER: the car is in the race order of the session (race-order ring car+4 / car+8, recovered in Stage 9;
		-- the Stage 6/7 build leaves it 0). car+4 != 0 gates the collision damage of 00549c40 (00549290 body damage,
		-- 0054a330 wheel / tyre impact states). One-car ring (links -> car+4) around 00549c40 only, as in the Unicorn
		-- reference (orig_stage11.race_order): car+4 != 0 would also enable the per-tick render copy 005543f0.
		local l4, l8 = r32(CAR + 4), r32(CAR + 8)
		w32(CAR + 4, CAR + 4); w32(CAR + 8, CAR + 4)
		callx(0x549c40, nil)
		w32(CAR + 4, l4); w32(CAR + 8, l8)
	end
	V._frameStart11 = frameStart11
	V._frameEnd = frameEnd11

	function V.setRuntimeMode(m)
		assert(m == "original" or m == "frozen", "runtime mode must be 'original' or 'frozen'")
		mode = m
	end
	function V.runtimeMode() return mode end

	-------------------------------------------------------------------------------------------------------------
	-- race options and session (simulation task paths)
	-------------------------------------------------------------------------------------------------------------
	-- race option 'damage' (settings +0x4c bits 22..23): ORIGINAL 00547e90 -> damage scale bef700 = {0, .15, .6, 1}
	function V.setDamageLevel(level)
		level = math.clamp(math.floor(tonumber(level) or 3), 0, 3)
		w32(SETTINGS + 0x4c, bit32.bor(band(r32(SETTINGS + 0x4c), bit32.bnot(bit32.lshift(3, 22))), bit32.lshift(level, 22)))
		callx(0x547e90, nil, level)
		return level, rf32(0xbef700)
	end
	-- race option fuel / tyre consumption rate (settings +0x50 bits 0..1 -> x1..x4, read by 0051aac0 / 0054e9f0)
	function V.setConsumptionRate(rate)
		rate = math.clamp(math.floor(tonumber(rate) or 0), 0, 3)
		w32(SETTINGS + 0x50, bit32.bor(band(r32(SETTINGS + 0x50), bit32.bnot(3)), rate))
		return rate + 1
	end
	-- roster series field of the player car (car+0x596): collision damage needs it nonzero (PROVISIONAL host input)
	function V.setSeriesField(v) w32(CAR + 0x596, math.floor(tonumber(v) or 1)) end
	-- rndSeed (005f5650) of stream 0, the stream used by every physics random draw (misfire, failures, damage)
	function V.setRandomSeed(seed) w32(RNG, band(math.floor(tonumber(seed) or 0))) end
	function V.randomState() return r32(RNG), r32(RNG + 4) end

	-- ORIGINAL 00550a50 subset (car placed on the track by the simulation task): 00563080(car, 1) damage repair,
	-- 00550c40 engine init, 00550c60 fuel load, 005512d0 four new tyres (00550f10), car+0x1518 = 0, 00550070(0)
	-- (Stage 13, NR2003CupFFB), bf6eb9 = 0
	function V.enterTrack()
		ensureWorldRecord()
		callx(0x563080, nil, CAR, 1)
		callx(0x550c40, nil)
		callx(0x550c60, nil)
		callx(0x5512d0, nil)
		w32(CAR + 0x1518, 0)
		-- Stage 13 (@00550b07): ORIGINAL 00550070(0), player controls active + FF axis setup (NR2003CupFFB)
		if V._ffbEnterTrack then V._ffbEnterTrack() end
		buffer.writeu8(M, 0xbf6eb9 - BASE, 0)
	end
	-- ORIGINAL 00433610(chassis type car+0x58e): the collision-damage zone tree (00433660, nodes from the static pool
	-- *bf39d4 via 00547e60), built in the game by the car-model load 00432d90; without it every zone lookup (0054a710)
	-- returns -1 and no collision damage exists. Built once per car load (table 00890490 is checked first).
	function V.buildDamageZones()
		callx(0x433610, nil, r32(CAR + 0x58e))
		return r32(0x890490) ~= 0
	end
	local function applySession11()
		hostBlocks()
		V.buildDamageZones()
		V.setSeriesField(session11.series)
		if session11.damageLevel ~= nil then V.setDamageLevel(session11.damageLevel) end
		if session11.consumptionRate ~= nil then V.setConsumptionRate(session11.consumptionRate) end
		if session11.seed ~= nil then V.setRandomSeed(session11.seed) end
		V.enterTrack()
	end
	-- startSession(weather, opts): Stage 9 weather (005a3c00) then, in "original" mode, the Stage 11 session: race
	-- options (opts.damageLevel 0..3, opts.consumptionRate 0..3, nil = post-build values), opts.series (car+0x596,
	-- default 1), opts.seed (stream 0 state, nil = post-build), then the car is placed on the track (enterTrack)
	local baseStart, baseEnd, baseReset = V.startSession, V.endSession, V.reset
	function V.startSession(weather, opts)
		local r = baseStart(weather)
		if mode == "original" then
			opts = opts or {}
			session11 = {series = opts.series or 1, damageLevel = opts.damageLevel, consumptionRate = opts.consumptionRate, seed = opts.seed}
			applySession11()
		end
		return r
	end
	function V.endSession()
		session11 = nil
		baseEnd()
	end
	-- reset = the car reloaded from the reset image (post-build); in an active Stage 11 session it is placed on
	-- the track again (00550a50: repaired, engine and fuel re-initialised, new tyres), like a restart
	function V.reset()
		baseReset()
		if session11 ~= nil and mode == "original" then applySession11() end
	end

	-------------------------------------------------------------------------------------------------------------
	-- events
	-------------------------------------------------------------------------------------------------------------
	-- ORIGINAL 0054a760 collision record entry (called by the track contact code 00576e00 / 0057xxxx). The host
	-- (Roblox geometry query) supplies the contact; NR2003 evaluates the damage (0054a8d0 -> 0054aa20 immediately
	-- for tyre / flagged contacts, 00549c40 -> 00549290 at the end of the frame). rec = {magnitude (impact
	-- magnitude in the units of the contact code), material (self, 0x13 = tyre), flags (0x2000000), surface (other
	-- material id), point (world), localPoint (car frame, zone lookup), otherLocal, velocity, normal, p9, speed,
	-- key 0..7 (contact object), other = true (contact with another car: body proxy index 1)}
	local function vec(a, v)
		v = v or {0, 0, 0}
		wf32(a, v[1] or 0); wf32(a + 4, v[2] or 0); wf32(a + 8, v[3] or 0)
	end
	function V.collision(rec)
		assert(type(rec) == "table" and rec.magnitude, "collision record needs a magnitude")
		vec(VEC, rec.point); vec(VEC + 12, rec.localPoint); vec(VEC + 24, rec.otherLocal)
		vec(VEC + 36, rec.velocity); vec(VEC + 48, rec.normal or {0, 0, 1})
		local key = math.clamp(math.floor(rec.key or 0), 0, 7)
		callx(0x54a760, nil, KEYS + 16 * key, f2u(rec.magnitude), band((rec.flags or 0) + (rec.material or 0x13)),
			rec.surface or 1, VEC, VEC + 12, VEC + 24, VEC + 36, rec.p9 or 0, f2u(rec.speed or 0),
			rec.other and OTHER or 0, VEC + 48)
	end
	-- ORIGINAL 00550f10 pit tyre change for wheels (0 LF, 1 RF, 2 LR, 3 RR): cold pressure from the setup, wear 0,
	-- temperatures = session air temperature e0b834 (sun-heated) + 11 C, tyre state reset, 0054d610 run once
	function V.pitTyres(wheels)
		for _, w in ipairs(wheels or {0, 1, 2, 3}) do callx(0x550f10, nil, w) end
	end

	-------------------------------------------------------------------------------------------------------------
	-- telemetry (reads the ORIGINAL cells; no duplicate state)
	-------------------------------------------------------------------------------------------------------------
	local function pf32(a) return u2f(bit32.bxor(r32(r32(a)), r32(r32(a + 8)))) end
	local function pf64(a)
		local p0, p2 = r32(a), r32(a + 8)
		buffer.writeu32(S, 0, bit32.bxor(r32(p0), r32(p2))); buffer.writeu32(S, 4, bit32.bxor(r32(p0 + 4), r32(p2 + 4)))
		return buffer.readf64(S, 0)
	end
	local function damageComponent(n)
		-- 005486a0: packed component n of the damage word +8 (table 006f56b8, stride 21 bytes)
		local e = 0x6f56b8 + n * 0x15
		local shift, mask, flag = band(r32(e), 31), r32(e + 4), buffer.readu8(M, e + 8 - BASE)
		local v = band(bit32.rshift(r32(DAMAGE + 8), shift), mask)
		if flag == 0 then return v / mask end
		if v == mask then return rf32(0x6ea4a0) end
		return v / (mask - 1)
	end
	V.damageComponentOriginal = damageComponent
	function V.stage11State(out)
		out = out or {}
		local fuel = pf64(ENGINE + 0x50c)
		local spec = r32(CAR + 0x58a)
		local fuelRec = r32(0xc08234)
		out.mode = mode
		out.fuel = {kg = fuel, massRecord = rf32(r32(fuelRec + 0x125)), inertiaRecord = rf32(r32(fuelRec + 0x179)),
			specInertiaPerKg = rf32(spec + 0x28)}
		out.engine = {water = pf32(ENGINE + 0x4a4), oil = pf32(ENGINE + 0x4d4), coolantLevel = rf32(ENGINE + 0x4a0),
			oilLevel = rf32(ENGINE + 0x49c), power = rf32(ENGINE + 0x554), cutTimer = rf32(ENGINE + 0x550),
			radiator = {rf32(ENGINE + 0x470), rf32(ENGINE + 0x474), rf32(ENGINE + 0x478), rf32(ENGINE + 0x47c), rf32(ENGINE + 0x480)},
			heat = {rf32(ENGINE + 0x494), rf32(ENGINE + 0x498)}, overRev = rf32(ENGINE + 0x508), wear = rf32(ENGINE + 0x558),
			life = rf32(ENGINE + 0x55c), blown = rf32(ENGINE + 0x560), flags = r32(ENGINE + 0x548), x4d0 = rf32(ENGINE + 0x4d0)}
		out.tyres = out.tyres or {}
		for w = 0, 3 do
			local t = TIRE0 + w * TIRE_STRIDE
			local o = out.tyres[w + 1] or {}
			o.coldPressure = rf32(t); o.pressure = rf32(t + 0x2a0)
			o.surface = {pf32(t + 0x160), pf32(t + 0x18c), pf32(t + 0x1b8)}
			o.carcass = {pf32(t + 0x1e4), pf32(t + 0x210), pf32(t + 0x23c)}
			o.wear = pf32(t + 0x74); o.gripWear = rf32(t + 0xcc); o.brake = pf32(t + 0x26c)
			o.state = band(bit32.rshift(buffer.readu16(M, DAMAGE + 2 - BASE), 2 * w), 3)
			o.wheel = band(bit32.rshift(buffer.readu16(M, DAMAGE - BASE), 6 + 2 * w), 3)
			out.tyres[w + 1] = o
		end
		local zones = {}
		for k = 0, 10 do zones[k + 1] = rf32(DAMAGE + 0x10 + 4 * k) end
		local broken = {}
		for k = 0, 8 do broken[k + 1] = buffer.readu8(M, 0xc086e0 + k - BASE) end
		out.damage = {words = {r32(DAMAGE), r32(DAMAGE + 4), r32(DAMAGE + 8), r32(DAMAGE + 0xc)}, zones = zones,
			tyre = {rf32(DAMAGE + 0x3c), rf32(DAMAGE + 0x40), rf32(DAMAGE + 0x44), rf32(DAMAGE + 0x48)},
			radiator = rf32(DAMAGE + 0x4c), oil = rf32(DAMAGE + 0x50), fuel = rf32(DAMAGE + 0x54), engine = rf32(DAMAGE + 0x58),
			x5c = rf32(DAMAGE + 0x5c), x60 = rf32(DAMAGE + 0x60), failures = buffer.readu8(M, DAMAGE + 0xe - BASE),
			brokenFlags = broken, scale = rf32(0xbef700), series = r32(CAR + 0x596)}
		out.airspeed = rf32(0xbf3a00); out.ambient = rf32(0x74c954); out.bgCount = r32(BGCOUNT); out.intCount = r32(INTCOUNT)
		out.random = r32(RNG)
		return out
	end
	V._stage11Supplement = SUPPLEMENT
	buffer.copy(M, 0, PRISTINE, 0, V.imageSize)   -- the supplement is part of the reset image
	V.reset()
	return V
end
]=])
stage("Core.NR2003CupVehicle",[=[
-- Stage 6/7 vehicle core: the ORIGINAL NR2003 Cup car running in Luau.
-- Core.NR2003Cup holds code generated from NR2003.exe (recovery/stage6_7/gen_runtime.py):
--   NR2003CupImage1..n : memory image after the game's own car build (spec, setup defaults,
--                        tire/engine init, component graph, JIT cells, tables)
--   NR2003CupCore      : machine state + 86 lifted x86 natives + host primitives
--   NR2003CupJIT1..n   : the x87 callbacks NR2003 generates at car build, translated
--   NR2003CupDriver    : 005b2190 tick order, 00551e80/005539c0 driver layer (hand port)
--   NR2003CupAero      : Stage 9 session air (005a3c00), per-frame aero factors (005637e0),
--                        drafting (005afd80), aero setup items, aero telemetry (hand port)
--   NR2003CupSetup(+Data): Stage 10 garage setup: descriptors c05150, unit converters, garage API (hand port)
--   NR2003CupBuild, NR2003CupBuildCode1..n, NR2003CupBuildData1..n: Stage 10 ORIGINAL car-build sequence
--                        (setup -> runtime parameters) lifted from the exe, run on the core memory
--   NR2003CupGarage    : Stage 10 applySetup / setup inspection (orchestration only)
--   NR2003CupJITG1..n  : Stage 10 callbacks of the generic (setup-invariant) structure, translated
--   NR2003CupSteering  : Stage 12 ORIGINAL steering chain (00552720, 00551e80 tail, 00554fb0, options)
--   NR2003CupFFB       : Stage 13 ORIGINAL force feedback (00554d30, FFB block of 00554520, 0054fed0 / 00550070,
--                        options), exact x87 arithmetic; output = the DirectInput constant force (ADAPTER)
-- This module only assembles them and exposes a numeric API (no Instances, no Roblox types).
-- Axes: NR2003 vehicle-world frame (+X forward, +Y left, +Z up, metres, seconds) fixed at reset.
local M={};M.__index=M

local function collect(get,prefix)
    local list={}
    for k=1,32 do
        local m=get(prefix..k)
        if m==nil then break end
        list[#list+1]=m
    end
    return list
end
local function merge(parts)
    assert(#parts>0,"NR2003CupImage parts missing")
    local p=parts[1]
    local image={base=p.base,size=p.size,stackTop=p.stackTop,host=p.host,windows={}}
    for _,part in ipairs(parts) do
        assert(part.base==image.base and part.size==image.size,"mismatched image part")
        for _,w in ipairs(part.windows) do image.windows[#image.windows+1]=w end
    end
    assert(#parts==p.parts,"image has "..tostring(p.parts).." parts, found "..#parts)
    return image
end
-- get(name) -> module value or nil
function M.fromLoader(get)
    local image=merge(collect(get,"NR2003CupImage"))
    local jit=collect(get,"NR2003CupJIT")
    assert(#jit>0,"NR2003CupJIT modules missing")
    local V=get("NR2003CupDriver")(get("NR2003CupCore")(image,jit))
    local aero=get("NR2003CupAero") -- Stage 9 (absent in a Stage 6/7/8 install)
    if aero then aero(V) end
    -- Stage 11 (absent in a Stage 6..10 install). Installed before the garage: its image supplement becomes part
    -- of the reset image that the garage snapshots (applySetup of the default setup restores that image)
    local frame=get("NR2003CupFrame")
    if frame then
        frame(V,collect(get,"NR2003CupFrameCode"),collect(get,"NR2003CupFrameData"))
    end
    local build=get("NR2003CupBuild") -- Stage 10 (absent in a Stage 6/7/8/9 install)
    if build then
        local Setup=get("NR2003CupSetup")(get("NR2003CupSetupData"))
        local B=build(V,collect(get,"NR2003CupBuildCode"),collect(get,"NR2003CupBuildData"))
        get("NR2003CupGarage")(V,Setup,B,collect(get,"NR2003CupJITG"))
    end
    -- Stage 12 (absent in a Stage 6..11 install): ORIGINAL steering chain; installed last so that its option
    -- re-application wraps every reset (garage rebuilds included)
    local steering=get("NR2003CupSteering")
    if steering then steering(V) end
    -- Stage 13 (absent in a Stage 6..12 install): ORIGINAL force feedback; installed after the steering chain (it
    -- follows the control-7 binding written by the steering device layer) and after the frame end (its hooks)
    local ffb=get("NR2003CupFFB")
    if ffb then ffb(V) end
    return setmetatable({V=V,state=table.create(45,0),pos={0,0,0},rot={1,0,0,0,1,0,0,0,1}},M)
end
function M.new(folder)
    folder=folder or (script and script.Parent:FindFirstChild("NR2003Cup"))
    assert(folder,"Core.NR2003Cup folder missing")
    return M.fromLoader(function(name)
        local m=folder:FindFirstChild(name)
        return m and require(m) or nil
    end)
end

function M:reset() self.V.reset() end
function M:tick() return self.V.tick end
-- controls: {throttle, clutch(engagement), shiftUp, shiftDown,
--   steerLeft/steerRight (Stage 12: raw steering controls 7/8, 0..1) + steerDigital (true = keys/buttons,
--   false = analog axis), or steerAxis (-1..1, + right: one analog axis split as the original device layer),
--   steer (road-wheel rad, + left: PROVISIONAL Stage 6-11 contract, only in the steering mode "provisional"),
--   brakeControl (Stage 8: raw brake device value 0..1 -> ORIGINAL 00552d00/00553080 chain),
--   brakeDigital (true = key/button binding, false = analog axis), throttleControl/throttleDigital,
--   driver (false -> 005524f0 'not driven': brake held at 1.0),
--   brake (no brakeControl: processed pedal injected directly, Stage 6/7 contract)}
-- contacts: 4 planes {nx,ny,nz,d,gvx,gvy,gvz,surface,grip} or function(phase) -> planes
function M:step(controls,contacts) self.V.drive(controls,contacts) end
-- Stage 8 brake API (original cells; see CORE_API.md)
function M:setBrakeBias(percent) return self.V.setBrakeBias(percent) end
function M:brakeBias() return self.V.brakeBias() end
function M:brakeState() return self.V.brakeState() end
function M:wheelBrake(i,out) return self.V.wheelBrake(i,out) end
function M:brakeTemperature(i) return self.V.brakeTemperature(i) end
-- Stage 9 aero API (original cells; see CORE_API.md). Without startSession the core keeps its
-- post-build state (no air: rho = 0), the condition of every Stage 6/7/8 fixture.
--   weather = {temperatureF, windSpeedMph, windDirection 0..7, conditions 0..3, night, trackNorth,
--              humidity, pressureInHg}  (nil fields = original defaults)
-- Stage 11: opts = {damageLevel 0..3, consumptionRate 0..3, series (car+0x596), seed} (see CORE_API.md)
function M:startSession(weather,opts) return self.V.startSession(weather,opts) end
function M:endSession() self.V.endSession() end
function M:sessionActive() return self.V.sessionActive() end
function M:weather() return self.V.weather() end
function M:setDraftEnvironment(env) self.V.setDraftEnvironment(env) end
function M:setTrackNormal(n) self.V.setTrackNormal(n) end
function M:aeroFactors() return self.V.aeroFactors() end
function M:setAeroSetup(s) return self.V.setAeroSetup(s) end
function M:aeroSetup() return self.V.aeroSetup() end
function M:aeroState(out) return self.V.aeroState(out) end
-- Stage 10 setup API (see CORE_API.md / SETUP_MAP.md). A setup is a raw array [0..183] in the
-- original c055c0 representation; edit it with M:setupModule() (Setup.set/step/display/...).
function M:setupModule() return self.V.Setup end
function M:defaultSetup() return self.V.Setup.cupGarageDefault() end
function M:setup() return self.V.setup() end
function M:applySetup(s) return self.V.applySetup(s) end
function M:setupReport() return self.V.setupReport() end
function M:setupDump(out) return self.V.setupDump(out) end
-- Stage 11 runtime systems (ORIGINAL frame end; see CORE_API.md). Mode "original" (default, production) or
-- "frozen" (the Stage 6-10 frame end, only for comparisons with the Stage 6-10 golden data).
function M:setRuntimeMode(m) self.V.setRuntimeMode(m) end
function M:runtimeMode() return self.V.runtimeMode() end
function M:stage11State(out) return self.V.stage11State(out) end
function M:collision(rec) self.V.collision(rec) end
function M:pitTyres(wheels) self.V.pitTyres(wheels) end
function M:enterTrack() self.V.enterTrack() end
function M:setDamageLevel(level) return self.V.setDamageLevel(level) end
function M:setConsumptionRate(rate) return self.V.setConsumptionRate(rate) end
function M:setRandomSeed(seed) self.V.setRandomSeed(seed) end
function M:randomState() return self.V.randomState() end
-- Stage 12 steering API (ORIGINAL chain; see CORE_API.md / STAGE12_STEERING_STATE_MAP.md)
function M:setSteeringMode(m) self.V.setSteeringMode(m) end
function M:steeringMode() return self.V.steeringMode() end
function M:setSteeringOptions(o) return self.V.setSteeringOptions(o) end
function M:steeringOptions() return self.V.steeringOptions() end
function M:steeringState(out) return self.V.steeringState(out) end
function M:steeringWheelAngle() return self.V.steeringWheelAngle() end
-- Stage 13 force feedback API (ORIGINAL chain; see CORE_API.md / STAGE13_FFB_STATE_MAP.md)
function M:setForceFeedbackOptions(o) return self.V.setForceFeedbackOptions(o) end
function M:forceFeedbackOptions() return self.V.forceFeedbackOptions() end
function M:setForceFeedbackDevice(d) self.V.setForceFeedbackDevice(d) end
function M:forceFeedbackState(out) return self.V.forceFeedbackState(out) end
function M:setControlsSuspended(flag) self.V.setControlsSuspended(flag) end
function M:controlsSuspended() return self.V.controlsSuspended() end
function M:selectActiveControls() self.V.selectActiveControls() end
function M:readState() return self.V.state(self.state) end
function M:componentPose(record,pos,rot) return self.V.componentPose(record,pos,rot) end
function M:contactOut(i) return self.V.contactOut(i) end
function M:resetContactBlock(i,x,y,z) self.V.resetContactBlock(i,x,y,z) end
function M:translate(dx,dy,dz) self.V.translate(dx,dy,dz) end
function M:checkpoint() return self.V.checkpoint() end
function M:restore(c) self.V.restore(c) end
function M:engineRpm() return self.V.engineRpm() end
function M:gearIndex() return self.V.gearIndex() end
function M:gearCount() return self.V.gearCount() end
function M:revLimiter() return self.V.revLimiter() end
function M:inputs() return self.V.inputs() end
-- Stage 5 HUD numbering: -1 R, 0 N, 1.. forward
function M.displayGear(index) return index-1 end
return M
]=])
stage("Core.CupTune",[=[
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
    driver={steeringLockDegrees=360,setupSteeringRatio=12,momentumKeys=nil,momentumAxis=0,cockpitLimit="lock",
        -- Stage 13 bench defaults (car attributes override): force feedback ON with the image values of the executable
        -- (strength 80, damping 0, latency 0 = no controls.cfg), FF output present (HUD + gamepad motors). The original
        -- default without controls.cfg is OFF; the effect still needs the steering on an analog axis (0054fed0)
        ffbEnabled=true,ffbStrength=nil,ffbDamping=nil,ffbLatency=nil,ffbDevice=true,
        -- presentation only (NOT original): the constant force drives the large motor of the active gamepad with |force|
        -- (Roblox has no directional force feedback); false = HUD only
        ffbRumble=true},
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
]=])
stage("Roblox.CupChassisAdapter",[=[
-- Stage 13: the ORIGINAL force feedback runs inside the core (00554d30 front tyre statistics per tick, the FFB block of the
-- frame end 00554520, 0054fed0 / 00550070 FF axis and controls; exact x87 arithmetic). Options = the controls.cfg values
-- (attributes ForceFeedback bool, ForceFeedbackStrength 0..100, ForceFeedbackDamping 0..100, ForceFeedbackLatency
-- 0..250 ms; absent = CupTune.driver bench defaults, then the original image values: off, 80, 0, 0). ForceFeedbackDevice
-- (bool) = the host offers an FF output for the steering axis (ADAPTER for DirectInput: the HUD + gamepad motors on the
-- client); the effect is acquired by the ORIGINAL 0054fed0 only while the steering is on an analog axis. No driver seated
-- = player controls suspended (ORIGINAL 00550070(1)). The output (the original constant force -1..1 and the DirectInput
-- magnitude _ftol(force x 10000)) is published as car attributes FFBForce / FFBMagnitude / FFBActive; nothing feeds back.
-- Stage 12: the ORIGINAL steering chain runs inside the core (00552720 device processing, linearity, x pi,
-- 00554fb0 setup ratio item 0x30 with the low-speed override, per-tick ramp + toe -> prescribed hub coordinates).
-- The adapter is only the device layer (0057abc0 equivalent): keys -> digital steering controls 7 / 8, an analog
-- axis (gamepad / wheel, normalised -1..1 by Roblox) -> both controls split by sign. Driver options from car
-- attributes: SteeringLinearity (controls.cfg value 0..100), SteeringMomentum (0..100, 0 = no slew),
-- SteeringLowSpeedOverride (bool); absent = the original values when no controls.cfg was loaded. (The arcade
-- driving mode and steering assistance are not ported: the core refuses them.) The cockpit wheel draws the ORIGINAL 005662d0 angle; front wheels use the solver poses.
-- Stage 11: the ORIGINAL per-frame runtime systems run inside the core (fuel burn and fuel mass, tyre thermal /
-- hot pressure / wear / failure, brake temperature, engine thermal / damage / failure, random failures, collision
-- damage). The adapter only starts the Stage 11 session with the race options (car attributes RaceDamageLevel 0..3,
-- RaceConsumptionRate 0..3, RosterSeries, RandomSeed; Stage11Runtime="frozen" = Stage 6-10 frame end for A/B),
-- offers TEST-ONLY event injection (DamageTestImpact = magnitude of one ORIGINAL collision record at the front
-- bumper, PitTyresTest = ORIGINAL 00550f10 x4) and reads telemetry from the original cells. No state is kept here.
-- Stage 10: garage setup at initialize/reset (car attributes Setup_<item> in display units, e.g.
-- Setup_springLF = 1700, Setup_camberLF = -2.5; legacy SetupBrakeBias/SetupGrilleTape/SetupSpoiler map to
-- items brakeBias/grilleTape/spoilerAngle). Each value goes through the ORIGINAL garage function 005581d0
-- (snap to the step grid + clamp), and the setup is applied by the ORIGINAL car build (core:applySetup).
-- Rebuild only when the setup changed; the rebuilt car is the core's reset image.
-- Stage 9: session air + aero setup at initialize/reset (car attributes), per-frame track normal and
-- test-only phantom draft (aeroHostInputs), aero telemetry. The aero forces themselves are computed
-- by the ORIGINAL core (00561a80/00561b70); the host applies no aero force.
-- Stage 6/7 host for mode NR2003_CUP: the ORIGINAL NR2003 Cup vehicle core owns all 45 states
-- (chassis, LF/RF suspension + hub + wheel, rear axle + LR/RR wheels, engine, clutch, output
-- shaft, head). Roblox only supplies contact planes (raycasts at the core's own wheel positions),
-- driver controls, and presentation. Nothing rendered feeds back into the core.
-- No ApplyImpulse / AssemblyMass / Roblox rigid-body integration for this car.
local Core=script.Parent.Parent.Core
local Vehicle=require(Core.NR2003CupVehicle)
local CupTune=require(Core.CupTune)
local Surface=require(Core.Surface)
local Fixed=require(Core.NR2003FixedStep)
local U=require(Core.MathUtil)
local Visual=require(script.Parent.VisualRig)
local SeatAccess=require(script.Parent.SeatAccess)
local Cockpit=require(script.Parent.Cockpit)
local RenderSnapshot=require(script.Parent.RenderSnapshot)
local M={};M.__index=M

-- NR2003 vehicle-world (+X fwd, +Y left, +Z up) <-> Roblox origin-local (+X right, +Y up, -Z fwd)
local function toLocal(x,y,z) return Vector3.new(-y,z,-x) end
local function fromLocal(v) return -v.Z,-v.X,v.Y end
-- R' = B R B^T for a row-major NR2003 body->world matrix
local function localRotation(r)
    return r[5],-r[6],r[4],
        -r[8],r[9],-r[7],
        r[2],-r[3],r[1]
end

function M.new(car,tune,remote)
    local cup=CupTune.new()
    local self=setmetatable({car=car,root=car.Chassis,tune=cup,benchTune=tune,telemetryTimer=0,debugVisible=false,
        fault=nil,renderSpin={},lastRenderSnapshotTime=nil,renderTeleport=true,pendingShift=0,steeringOut={},
        planes={},inContact={},wheelPose={},contactPoints={},scratchPos={0,0,0},scratchRot={1,0,0,0,1,0,0,0,1},ffbOut={}},M)
    for j=1,4 do
        self.planes[j]={0,0,1,0,0,0,0,1,1};self.inContact[j]=false
        self.wheelPose[j]={pos={0,0,0},rot={1,0,0,0,1,0,0,0,1},compression=0,steer=0,angle=0,rate=0}
        self.contactPoints[j]={point=Vector3.zero,grounded=false}
    end
    self.spawn=car:GetPivot();self.oldAnchored=self.root.Anchored;self.oldCollide=self.root.CanCollide
    car:SetAttribute("NR2003CorePoseOwner",true);car:SetAttribute("PhysicsMode","NR2003_CUP")
    car:SetAttribute("NR2003Tune","CupTune")
    car:SetAttribute("CockpitWheelAngle",true) -- Stage 12: render snapshots carry the ORIGINAL steering-wheel angle
    self.root.Anchored=true;self.root.CanCollide=false
    self.root.AssemblyLinearVelocity=Vector3.zero;self.root.AssemblyAngularVelocity=Vector3.zero
    local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances={car};params.RespectCanCollide=true;params.IgnoreWater=false
    self.params=params
    self.visual=Visual.new(car,cup);self.access=SeatAccess.new(car,remote);Cockpit.ensure(car,cup)
    self.core=Vehicle.new(Core:WaitForChild("NR2003Cup"))
    self:initialize()
    return self
end

-- numeric frame: origin on the ground under the spawn pose (the core starts at z=0.42 m)
function M:groundOrigin(pivot)
    local hit=workspace:Raycast(pivot.Position+pivot.UpVector*2,-pivot.UpVector*60,self.params)
    local rot=pivot-pivot.Position
    if hit then return CFrame.new(hit.Position)*rot end
    return CFrame.new(pivot.Position-pivot.UpVector*(0.42/self.tune.metresPerStud))*rot
end
function M:worldPoint(x,y,z) return self.origin:PointToWorldSpace(toLocal(x,y,z)/self.tune.metresPerStud) end
function M:worldVector(x,y,z) return self.origin:VectorToWorldSpace(toLocal(x,y,z)) end
function M:numericPoint(p)
    local x,y,z=fromLocal(self.origin:PointToObjectSpace(p)*self.tune.metresPerStud);return x,y,z
end
function M:numericVector(v) local x,y,z=fromLocal(self.origin:VectorToObjectSpace(v));return x,y,z end

-- Stage 10: garage setup from the car attributes (nil when the core has no Stage 10 modules)
local LEGACY_SETUP={brakeBias="SetupBrakeBias",grilleTape="SetupGrilleTape",spoilerAngle="SetupSpoiler"}
function M:garageSetup()
    local Setup=self.core.V.Setup
    if not Setup then return nil end
    local s=Setup.cupGarageDefault()
    for i=0,70 do
        if Setup.adjustable(i) then
            local name=Setup.ITEM[i].name
            local v=self.car:GetAttribute("Setup_"..name)
            if not U.finite(v) and LEGACY_SETUP[name] then v=self.car:GetAttribute(LEGACY_SETUP[name]) end
            if U.finite(v) then Setup.set(s,i,v) end
        end
    end
    -- Stage 12.1: bench default of the garage steering ratio (item 0x30) when no Setup_steeringRatio attribute is set
    local ratio=self.tune.driver and self.tune.driver.setupSteeringRatio
    if U.finite(ratio) and not U.finite(self.car:GetAttribute("Setup_steeringRatio")) then Setup.set(s,"steeringRatio",ratio) end
    return s
end
function M:applyGarageSetup(s)
    local key=table.concat(s,",",0,183)
    if key==self.appliedSetupKey then return end
    local ok,rep=self.core:applySetup(s)
    self.car:SetAttribute("SetupStructure",rep.structure);self.car:SetAttribute("SetupApplySeconds",rep.seconds)
    if ok then
        self.appliedSetupKey=key;self.car:SetAttribute("SetupError",nil)
        local d=self.core:setupDump()
        local r=d.runtime
        print(string.format("[NR2003 Stage 10] setup aplicado (%s, %.2f s): molas %.0f/%.0f/%.0f/%.0f N/m, freio %.0f/%.0f N*m, marchas %.3f/%.3f/%.3f/%.3f x %.3f",
            rep.structure,rep.seconds or 0,r.springRate[1],r.springRate[2],r.springRate[3],r.springRate[4],r.brakeTorque[1],r.brakeTorque[3],
            r.gearRatio[3],r.gearRatio[4],r.gearRatio[5],r.gearRatio[6],r.finalDrive))
    else
        self.car:SetAttribute("SetupError",tostring(rep.firstViolation))
        warn("NR2003 Stage 10: setup não representável, mantido o anterior ("..tostring(rep.firstViolation)..")")
    end
end
function M:initialize()
    self.origin=self:groundOrigin(self.spawn)
    -- Stage 12: the steering options are re-read from the attributes at every initialize/reset
    if self.core.V.clearSteeringOptions then self.core.V.clearSteeringOptions() end
    if self.core.V.clearForceFeedbackOptions then self.core.V.clearForceFeedbackOptions() end
    self.core:reset()
    local function num(name) local v=self.car:GetAttribute(name);return U.finite(v) and v or nil end
    local garage=self:garageSetup()
    if garage then
        -- Stage 10: the whole garage setup through the ORIGINAL build (brake bias, tape and spoiler included)
        self:applyGarageSetup(garage)
        self.brakeBias=select(2,self.core:brakeBias())
        self.car:SetAttribute("BrakeBiasApplied",self.brakeBias)
        local tape,spoiler=self.core:aeroSetup()
        self.car:SetAttribute("GrilleTapeApplied",tape);self.car:SetAttribute("SpoilerApplied",spoiler)
    else
        -- Stage 8: garage brake bias (setup item 0x28, % front, 50..90). Car attribute SetupBrakeBias;
        -- absent = shipped Cup default (74). Applied at build/reset only, like the original garage.
        local bias=self.car:GetAttribute("SetupBrakeBias")
        if U.finite(bias) then self.brakeBias=self.core:setBrakeBias(bias) else self.brakeBias=select(2,self.core:brakeBias()) end
        self.car:SetAttribute("BrakeBiasApplied",self.brakeBias)
        -- Stage 9: garage aero items read at run time by the original aero (00410280): grille tape
        -- (item 0x3b, % 0..100 step 5) and rear spoiler (item 0x3d, deg 45..70). Absent = Cup defaults.
        local tape,spoiler=self.core:setAeroSetup({grilleTape=num("SetupGrilleTape"),spoiler=num("SetupSpoiler")})
        self.car:SetAttribute("GrilleTapeApplied",tape);self.car:SetAttribute("SpoilerApplied",spoiler)
    end
    local tape,spoiler=self.core:aeroSetup()
    -- Stage 9: session start 005a3c00 = race weather settings (ADAPTER: car attributes standing for
    -- the race options; absent = original defaults 70 F, no wind, conditions 0, daytime). TrackNorth
    -- (rad) stands for the track's north angle (bdbcf8) in the core frame. AeroSession=false keeps the
    -- Stage 6/7/8 post-build state (no air) for A/B comparison.
    self.core:setDraftEnvironment(nil);self.core:setTrackNormal(nil)
    -- Stage 11: production = "original" runtime; Stage11Runtime="frozen" keeps the Stage 6-10 frame end (A/B only)
    local frozen=self.car:GetAttribute("Stage11Runtime")=="frozen"
    if self.core.V.setRuntimeMode then self.core:setRuntimeMode(frozen and "frozen" or "original") end
    -- Stage 12: ORIGINAL steering chain + driver options (ORIGINAL setters 005502f0 / 005500c0 / 00550110)
    if self.core.V.setSteeringMode then
        self.core:setSteeringMode("original")
        local function flag(name) local v=self.car:GetAttribute(name);if type(v)=="boolean" then return v end;return nil end
        -- Stage 12.1 bench options (CupTune.driver defaults; attributes override): steering lock, momentum per device,
        -- cockpit wheel draw limit. Lock 360 = the original constant; the others are host choices (STAGE12_RESULT.md)
        local d=self.tune.driver or {}
        local function pick(name,default) local v=num(name);if v~=nil then return v end;return default end
        local clamp=self.car:GetAttribute("CockpitWheelClamp")
        if clamp~="original" and clamp~="lock" then clamp=d.cockpitLimit end
        local o=self.core:setSteeringOptions({linearity=num("SteeringLinearity"),momentum=num("SteeringMomentum"),
            lowSpeedOverride=flag("SteeringLowSpeedOverride"),lockDegrees=pick("SteeringLockDegrees",d.steeringLockDegrees),
            momentumKeys=pick("SteeringMomentumKeys",d.momentumKeys),momentumAxis=pick("SteeringMomentumAxis",d.momentumAxis),
            cockpitLimit=clamp})
        self.car:SetAttribute("SteeringLinearityApplied",o.linearity);self.car:SetAttribute("SteeringRateApplied",o.steerRate)
        self.car:SetAttribute("SteeringRatioApplied",o.setupRatio);self.car:SetAttribute("SteeringLockApplied",o.lockDegrees)
        print(string.format("[NR2003 Stage 12] direção original: relação %g:1 (item 0x30), trava %g° (%g° por lado), override baixa velocidade %s, linearidade %.2f, taxa %.4f/quadro (teclas %s, eixo %s), volante até %g°",
            o.setupRatio,o.lockDegrees,o.lockDegrees/2,o.lowSpeedOverride and "on" or "off",o.linearity,o.steerRate,
            o.momentumKeys==nil and "imagem" or tostring(o.momentumKeys),o.momentumAxis==nil and "imagem" or tostring(o.momentumAxis),
            o.cockpitLimitDegrees))
    end
    -- Stage 13: ORIGINAL force feedback options (messages 8..11 = controls.cfg values) and the host FF device, set before
    -- the car is placed on the track (00550a50 -> 00550070(0) -> 0054fed0)
    self.controlsSuspended=nil
    if self.core.V.setForceFeedbackOptions then
        local d=self.tune.driver or {}
        local function boolAttr(name,default) local v=self.car:GetAttribute(name);if type(v)=="boolean" then return v end;return default end
        local function range(name,hi,default)
            local v=num(name);if v==nil then v=default end
            if v==nil then return nil end
            return math.clamp(math.floor(v),0,hi)            -- the front-end slider ranges (0043ef90 / 0043efe0 / 0043f030)
        end
        self.core:setForceFeedbackDevice({capable=boolAttr("ForceFeedbackDevice",d.ffbDevice==true)})
        local o=self.core:setForceFeedbackOptions({enabled=boolAttr("ForceFeedback",d.ffbEnabled),
            strength=range("ForceFeedbackStrength",100,d.ffbStrength),damping=range("ForceFeedbackDamping",100,d.ffbDamping),
            latency=range("ForceFeedbackLatency",250,d.ffbLatency)})
        self.car:SetAttribute("ForceFeedbackApplied",o.enabled)
        print(string.format("[NR2003 Stage 13] force feedback original %s: força %g, amortecimento %g, latência %g ms, dispositivo %s (efeito adquirido pelo 0054fed0 só com o eixo analógico)",
            o.enabled and "ligado" or "desligado",o.strength,o.damping,o.latency,boolAttr("ForceFeedbackDevice",d.ffbDevice==true) and "sim" or "não"))
    end
    if self.car:GetAttribute("AeroSession")==false then
        self.core:endSession();self.weather=nil
    else
        -- Stage 11 session options (race options of the original; absent = post-build values: damage scale 1.0,
        -- consumption x1, random stream state of the build). RosterSeries stands for the roster series field
        -- car+0x596 (PROVISIONAL host input, 1 = collision damage evaluated). The car is then placed on the
        -- track by the ORIGINAL 00550a50 subset (repair, engine and fuel init, four new tyres).
        self.weather=self.core:startSession({temperatureF=num("WeatherTemperatureF"),windSpeedMph=num("WeatherWindMph"),
            windDirection=num("WeatherWindDirection"),conditions=num("WeatherConditions"),night=self.car:GetAttribute("WeatherNight")==true,
            trackNorth=num("TrackNorth")},{damageLevel=num("RaceDamageLevel"),consumptionRate=num("RaceConsumptionRate"),
            series=num("RosterSeries"),seed=num("RandomSeed")})
    end
    self.stage11Out={}
    self.car:SetAttribute("AirDensityApplied",self.weather and self.weather.density or 0)
    self.aeroOut={};self.trackNormal=nil;self.draftTest=false
    local w=self.weather
    if w then
        print(string.format("[NR2003 Stage 9] sessão: %d F, condições %d, %s, vento %d mph dir %d -> ar %.2f C, rho %.7g kg/m3, vento (%.3f, %.3f) m/s | fita %d%%, aerofólio %d°",
            w.temperatureF,w.conditions,w.night and "noite" or "dia",w.windSpeedMph,w.windDirection,w.densityTemperatureC,w.density,w.wind[1],w.wind[2],tape,spoiler))
    else
        print("[NR2003 Stage 9] AeroSession=false: estado pós-build (sem ar, rho = 0)")
    end
    self.renderSpin={};self.lastRenderSnapshotTime=nil;self.renderTeleport=true
    for j=1,4 do self.inContact[j]=false end
    self.pendingShift=0
    local controller=self
    local stepper={state={tick=0}}
    function stepper:step(input) controller:tickCore(input);self.state.tick=controller.core:tick() end
    function stepper:checkpoint() return {core=controller.core:checkpoint(),origin=controller.origin,contact=table.clone(controller.inContact)} end
    function stepper:restore(c)
        controller.core:restore(c.core);controller.origin=c.origin;controller.inContact=table.clone(c.contact)
        self.state.tick=controller.core:tick();controller:pose(true)
    end
    self.stepper=stepper
    self.runner=Fixed.new(stepper,96)
    self.contactFn=function(phase) return self:contacts(phase) end
    self:pose(true)
end

-- contact planes at the CURRENT wheel positions of the core (called by the core twice per tick,
-- like 00578da0 / 00578de0). Plane: n.x + d = 0 in vehicle-world axes (0055e1e0 arguments).
function M:contacts(phase)
    local t=self.tune;local q=t.contactQuery;local mps=t.metresPerStud
    local occupant=self.car.DriverSeat.Occupant
    self.params.FilterDescendantsInstances=occupant and {self.car,occupant.Parent} or {self.car}
    local _,crot=self.core:componentPose(0,self.scratchPos,self.scratchRot)
    local ux,uy,uz=crot[3],crot[6],crot[9]                      -- chassis +Z in vehicle-world
    local upWorld=self:worldVector(ux,uy,uz)
    for j,c in ipairs(t.corners) do
        local w=self.wheelPose[j]
        local p=self.core:componentPose(c.record,w.pos,w.rot)
        local origin=self:worldPoint(p[1]+ux*q.rayAbove,p[2]+uy*q.rayAbove,p[3]+uz*q.rayAbove)
        local hit=workspace:Raycast(origin,-upWorld*(q.rayLength/mps),self.params)
        local plane=self.planes[j]
        if hit and hit.Normal:Dot(upWorld)>q.maximumSlopeCos then
            local nx,ny,nz=self:numericVector(hit.Normal)
            local px,py,pz=self:numericPoint(hit.Position)
            -- (+0 normalises signed zeros from the axis permutation; the track code passes +0)
            plane[1],plane[2],plane[3],plane[4]=nx+0,ny+0,nz+0,-(nx*px+ny*py+nz*pz)+0
            local gx,gy,gz=0,0,0
            if hit.Instance:IsA("BasePart") then
                gx,gy,gz=self:numericVector(hit.Instance:GetVelocityAtPosition(hit.Position)*mps)
            end
            plane[5],plane[6],plane[7]=gx+0,gy+0,gz+0
            local attr=hit.Instance:GetAttribute("NRSurface")
            plane[8]=U.finite(attr) and math.clamp(math.floor(attr),0,16) or (Surface.indices[hit.Material.Name] or 1)
            local grip=hit.Instance:GetAttribute("NRGripMultiplier")
            plane[9]=U.finite(grip) and math.clamp(grip,0,4) or 1
            if not self.inContact[j] then self.core:resetContactBlock(j-1,px,py,pz) end -- 005778a0 pair init
            self.inContact[j]=true
        else
            -- no geometry under the wheel: plane far below (tire separates). PROVISIONAL: the original
            -- simply has no contact pair for that wheel.
            plane[1],plane[2],plane[3]=ux,uy,uz
            plane[4]=-(ux*p[1]+uy*p[2]+uz*p[3])+q.noContactPlane
            plane[5],plane[6],plane[7],plane[8],plane[9]=0,0,0,1,1
            self.inContact[j]=false
        end
    end
    return self.planes
end

-- Stage 12 host device layer (0057abc0 equivalent, ADAPTER): the raw steering controls of the frame. Keys -> steer
-- left / right key bindings (digital controls 7 / 8 = 1.0 while held); an analog axis (input.steerAnalog) -> one axis
-- bound to both controls (negative half -> 7, positive half -> 8). A legacy client (input.steer only) = keys.
local function steerControls(controls,input)
    local axis=input.steerAxis
    if input.steerAnalog==true and U.finite(axis) then
        controls.steerAxis=U.clamp(axis,-1,1)
        return
    end
    local left,right=input.steerLeft,input.steerRight
    if not U.finite(left) and not U.finite(right) and U.finite(input.steer) then
        left=input.steer<0 and 1 or 0;right=input.steer>0 and 1 or 0
    end
    controls.steerLeft=U.finite(left) and U.clamp(left,0,1) or 0
    controls.steerRight=U.finite(right) and U.clamp(right,0,1) or 0
    controls.steerDigital=true
end
M.steerControls=steerControls

function M:tickCore(input)
    local frame=self.core:tick()%8==0
    -- Stage 8: the brake goes through the ORIGINAL input chain (00552d00/00553080 -> bf6eac).
    -- The bench client sends keyboard keys (S/W = 0/1): NR2003 key binding (0057af60 digital).
    -- brakeAxis=true in the input selects the analog-axis binding for real pedals/triggers.
    -- No driver seated = 005524f0 'car not driven' branch (pedal held at 1.0).
    local controls
    if self:driver()==nil then
        controls={driver=false,throttle=0,clutch=0}
    else
        local throttle=U.clamp(input.throttle or 0,0,1)
        controls={throttle=throttle,throttleControl=throttle,throttleDigital=input.throttleAxis~=true,
            brakeControl=U.clamp(input.brake or 0,0,1),brakeDigital=input.brakeAxis~=true,
            clutch=1-U.clamp(input.clutch or 0,0,1)}
        steerControls(controls,input)
    end
    if frame and self.pendingShift~=0 and controls.driver~=false then
        controls.shiftUp=self.pendingShift>0;controls.shiftDown=self.pendingShift<0;self.pendingShift=0
    end
    if frame and self.weather then self:aeroHostInputs() end
    -- Stage 13: no driver seated = player controls suspended (ORIGINAL 00550070(1): 005524f0 not-driven branch, FFB block
    -- gated, zero force); a driver seated = 00550070(0). Applied between frames, where the original drains its messages
    local suspended=controls.driver==false
    if frame and self.core.V.setControlsSuspended and suspended~=self.controlsSuspended then
        self.controlsSuspended=suspended;self.core:setControlsSuspended(suspended)
    end
    self.core:step(controls,self.contactFn)
    if self.core:tick()%8==0 and self.weather then self:stage11TestEvents() end
    self:pose(false)
end

-- Stage 11 TEST ADAPTER (not an NR2003 feature): one-shot attributes to exercise the ORIGINAL event paths on the
-- bench, which has no walls / other cars / pit lane. Applied after a frame end (where the original track contact code
-- would have entered the record during the frame).
--   DamageTestImpact = magnitude -> ORIGINAL 0054a760 record: front bumper point (car frame +2.4 m x), wall
--                      normal against the car's heading, wall material 1; evaluated by 00549c40 at the next frame end
--   PitTyresTest = true          -> ORIGINAL 00550f10 for the four wheels (pit tyre change)
function M:stage11TestEvents()
    local impact=self.car:GetAttribute("DamageTestImpact")
    if U.finite(impact) and impact>0 then
        self.car:SetAttribute("DamageTestImpact",nil)
        local st=self.core:readState()
        local p,r=self.core:componentPose(0,self.scratchPos,self.scratchRot)
        self.core:collision({magnitude=impact,material=0x10,surface=1,point={p[1]+2.4*r[1],p[2]+2.4*r[4],p[3]+2.4*r[7]},
            localPoint={2.4,0,0.3},velocity={st[2],st[4],st[6]},normal={-r[1],-r[4],-r[7]},speed=math.abs(st[2]*r[1]+st[4]*r[4]+st[6]*r[7])})
        print(string.format("[NR2003 Stage 11] TESTE: registro de colisão original (magnitude %.0f) na frente do carro",impact))
    end
    if self.car:GetAttribute("PitTyresTest")==true then
        self.car:SetAttribute("PitTyresTest",nil)
        self.core:pitTyres({0,1,2,3})
        print("[NR2003 Stage 11] TESTE: troca dos 4 pneus pelo 00550f10 original")
    end
end

-- Stage 9 per-frame host inputs of the aero, set before the frame's first tick (005637e0 order):
--  * track-object surface normal (0051370a -> car track object +0x24, used by 00561a80 to project the
--    wind): ADAPTER = mean normal of the grounded contact planes (core frame). Airborne: unchanged.
--  * drafting (005afd80): no other cars on the bench, so no race-order ring (factors stay 1.0).
--    TEST ADAPTER only: attribute DraftTestGap (m, > 0) puts a phantom car that far ahead on a straight
--    line along the core +X axis (lap distance = x, lateral = y + DraftTestLateral, same velocity as
--    the player, Cup wake), to exercise the ORIGINAL drafting code. Not an NR2003 feature.
function M:aeroHostInputs()
    local nx,ny,nz,n=0,0,0,0
    for j=1,4 do
        if self.inContact[j] then local p=self.planes[j];nx+=p[1];ny+=p[2];nz+=p[3];n+=1 end
    end
    if n>0 then
        local m=math.sqrt(nx*nx+ny*ny+nz*nz)
        if m>1e-6 then self.trackNormal={nx/m,ny/m,nz/m};self.core:setTrackNormal(self.trackNormal) end
    end
    local gap=self.car:GetAttribute("DraftTestGap")
    if U.finite(gap) and gap>0 then
        local st=self.core:readState()
        local lat=self.car:GetAttribute("DraftTestLateral");lat=U.finite(lat) and lat or 0
        local L=5000
        local other={lapDistance=(st[1]+gap)%L,lateral=st[3]+lat,vx=st[2],vy=st[4],vz=st[6]}
        self.core:setDraftEnvironment({trackLength=L,lapDistance=st[1]%L,lateral=st[3],ahead={other},behind={other}})
        self.draftTest=true
    elseif self.draftTest then
        self.core:setDraftEnvironment(nil);self.draftTest=false
    end
end

-- chassis pose from the core (+ host collision boundary). PROVISIONAL collision: a Blockcast of
-- the chassis box; on a hit the core is translated back through the ORIGINAL state import
-- 005b4560 (positions only). Momentum/velocity is not changed: NR2003 body collision response
-- (car-wall/car-car penalty forces) is not recovered yet.
function M:pose(teleport)
    local p,r=self.core:componentPose(0,self.scratchPos,self.scratchRot)
    local mps=self.tune.metresPerStud
    local function target()
        local lp=toLocal(p[1],p[2],p[3])/mps
        local r00,r01,r02,r10,r11,r12,r20,r21,r22=localRotation(r)
        return self.origin*CFrame.new(lp.X,lp.Y,lp.Z,r00,r01,r02,r10,r11,r12,r20,r21,r22)
    end
    local cf=target()
    if not teleport and self.rootCF then
        local delta=cf.Position-self.rootCF.Position
        if delta.Magnitude>1e-6 then
            local cast=self.rootCF*CFrame.new(0,self.tune.collision.raise/mps,0)
            local hit=workspace:Blockcast(cast,self.root.Size,delta,self.params)
            if hit then
                local allowed=self.rootCF.Position+delta.Unit*math.max(0,hit.Distance-0.01)
                local ax,ay,az=self:numericPoint(allowed)
                local tx,ty,tz=self:numericPoint(cf.Position)
                self.core:translate(ax-tx,ay-ty,az-tz) -- takes effect in the core's next tick
                cf=cf-cf.Position+allowed;self.collision=true
            else self.collision=false end
        end
    end
    self.rootCF=cf
end

function M:wheels()
    local _,cr=self.core:componentPose(0,self.scratchPos,self.scratchRot)
    local cp=self.scratchPos;local st=self.core:readState()
    for j,c in ipairs(self.tune.corners) do
        local w=self.wheelPose[j]
        local p,r=self.core:componentPose(c.record,w.pos,w.rot)
        local dx,dy,dz=p[1]-cp[1],p[2]-cp[2],p[3]-cp[3]
        w.compression=cr[3]*dx+cr[6]*dy+cr[9]*dz              -- centre height in chassis frame
        -- spin axis (wheel +Y column) in chassis frame -> road-wheel yaw (Stage 5 sign: + right)
        local ax=cr[1]*r[2]+cr[4]*r[5]+cr[7]*r[8]
        local ay=cr[2]*r[2]+cr[5]*r[5]+cr[8]*r[8]
        w.steer=math.atan2(ax,ay)
        w.angle=st[c.state.angle+1];w.rate=st[c.state.rate+1]
    end
    return self.wheelPose
end

function M:driver() return self.access:driver() end
function M:requestEntry(player) return self.access:request(player) end
function M:exit(player) return self.access:exit(player) end
function M:shift(delta) if U.finite(delta) and delta~=0 then self.pendingShift=delta>0 and 1 or -1 end end
function M:step(elapsed,input)
    self.access:step();self.telemetryTimer=self.telemetryTimer+elapsed
    if self.fault then return end
    local ok,reason=pcall(function()
        self.runner:advance(elapsed,input,nil)
        self.car:PivotTo(self.rootCF)
        self.car:SetAttribute("CoreTick",self.core:tick());self.car:SetAttribute("CoreCollision",self.collision==true)
        local wheels=self:wheels()
        for j=1,4 do
            local _,_,_,px,py,pz=self.core:contactOut(j-1)
            self.contactPoints[j].point=self:worldPoint(px,py,pz);self.contactPoints[j].grounded=self.inContact[j]
        end
        self.visual:update({wheels=wheels},self.contactPoints,self.debugVisible)
        Cockpit.updateAngle(self.car,self:steeringWheelAngle())
        -- Stage 13: the ORIGINAL constant force (005d08d0 -> 005d3010) for the client presentation (HUD, gamepad motors)
        if self.core.V.forceFeedbackState then
            local f=self.core:forceFeedbackState(self.ffbOut)
            self.car:SetAttribute("FFBForce",f.force);self.car:SetAttribute("FFBMagnitude",f.magnitude)
            self.car:SetAttribute("FFBActive",f.acquired and f.effect and not f.suspended)
        end
    end)
    if not ok then self.fault=tostring(reason);self.car:SetAttribute("PhysicsFault",self.fault);warn("NR2003 Cup core paused: "..self.fault) end
end

-- Stage 12 presentation: the ORIGINAL steering-wheel angle of the car model (005662d0: clamp(-(00554fb0() *
-- car[0x1554]), +-2.79 rad), + = clockwise seen by the driver (right turn)); 0 without the Stage 12 core
function M:steeringWheelAngle()
    if self.core.V.steeringWheelAngle then return self.core:steeringWheelAngle() end
    return 0
end

function M:kinematics()
    local st=self.core:readState()
    local _,r=self.core:componentPose(0,self.scratchPos,self.scratchRot)
    local linear=self:worldVector(st[2],st[4],st[6])/self.tune.metresPerStud
    local bx,by,bz=st[11],st[12],st[13]                          -- body rates
    local angular=self:worldVector(r[1]*bx+r[2]*by+r[3]*bz,r[4]*bx+r[5]*by+r[6]*bz,r[7]*bx+r[8]*by+r[9]*bz)
    return linear,angular
end

function M:renderSnapshot(seq,time,vehicleId)
    local cf=self.root.CFrame
    local px,py,pz,r00,r01,r02,r10,r11,r12,r20,r21,r22=cf:GetComponents()
    local qx,qy,qz,qw=RenderSnapshot.quatFromMatrix(r00,r01,r02,r10,r11,r12,r20,r21,r22)
    local linear,angular=self:kinematics()
    local dt=self.lastRenderSnapshotTime and math.max(0,time-self.lastRenderSnapshotTime) or 0
    local wheels={}
    for j,w in ipairs(self.wheelPose) do
        local spin=RenderSnapshot.unwrapSpin(self.renderSpin[j],w.angle,w.rate,dt)
        self.renderSpin[j]=spin
        local localPoint=cf:PointToObjectSpace(self.contactPoints[j].point)
        wheels[j]={comp=w.compression,steer=w.steer,spin=spin,cx=localPoint.X,cy=localPoint.Y,cz=localPoint.Z,
            grounded=self.contactPoints[j].grounded}
    end
    local flags=(self.renderTeleport and RenderSnapshot.FLAG_TELEPORT or 0)+RenderSnapshot.FLAG_WHEEL_ANGLE
    self.renderTeleport=false;self.lastRenderSnapshotTime=time
    return {vehicleId=vehicleId or 1,seq=seq,flags=flags,tick=self.core:tick(),time=time,
        px=px,py=py,pz=pz,qx=qx,qy=qy,qz=qz,qw=qw,
        lx=linear.X,ly=linear.Y,lz=linear.Z,ax=angular.X,ay=angular.Y,az=angular.Z,
        steer=self:steeringWheelAngle(),wheels=wheels}
end

function M:telemetry()
    local st=self.core:readState()
    local linear=self:kinematics()
    local _,r=self.core:componentPose(0,self.scratchPos,self.scratchRot)
    local forward=st[2]*r[1]+st[4]*r[4]+st[6]*r[7]
    local lf,rf,thr,brk,clu,gearIn=self.core:inputs()
    local wheels={}
    -- Stage 11: ORIGINAL runtime state (read-only view of the core cells)
    local s11=self.core.V.stage11State and self.core:stage11State(self.stage11Out) or nil
    for j,c in ipairs(self.tune.corners) do
        local fx,fy,fz=self.core:contactOut(j-1)
        local travel=st[c.state.travel+1]
        local w=self.wheelPose[j]
        -- Stage 8: original per-wheel brake/tire cells (no side effects on the core)
        local b=self.core:wheelBrake(j-1)
        local ty=s11 and s11.tyres[j]
        wheels[j]={name=c.name,load=self.inContact[j] and fz or 0,compression=travel,
            slip=b.vslip/math.max(math.abs(b.vx),2),
            omega=w.rate,temperature=ty and ty.surface[2]-273.15 or self.tune.environment.ambientC,grounded=self.inContact[j],
            tyreSurfaceK=ty and ty.surface,tyreCarcassK=ty and ty.carcass,tyrePressure=ty and ty.pressure,
            tyreWear=ty and ty.wear,tyreGrip=ty and ty.gripWear,tyreState=ty and ty.state,
            surface=self.planes[j][8],out1={fx,fy,fz},
            brakeTorque=b.torque,brakeCapacity=b.brakeCap,dragCapacity=b.dragCap,locked=b.locked,
            fx=b.fx,fy=b.fy,fz=b.fz,slipVelocity=b.vslip,brakeTemperatureK=b.temperature}
    end
    local pedal,target,tickValue,coreBrake=self.core:brakeState()
    local gear=self.core:gearIndex()
    -- Stage 9: ORIGINAL 00561b70 evaluated at the current state (read-only; see CORE_API.md)
    local a=self.core:aeroState(self.aeroOut)
    local tape,spoiler=self.core:aeroSetup()
    local aero={session=a.session,density=a.density,q=a.q,drag=a.drag,downforce=a.downforce,
        front=a.downforceFront,rear=a.downforceRear,side=a.side,mx=a.mx,my=a.my,mz=a.mz,
        factorDrag=a.factorDrag,factorFront=a.factorFront,factorRear=a.factorRear,airspeed=a.airspeedBody,
        yaw=a.yaw,pitch=a.pitch,rideHeight=a.rideHeightFront,proximity=a.groundProximity,stall=a.stall,
        windX=a.wind[1],windY=a.wind[2],grilleTape=tape,spoiler=spoiler,draftTest=self.draftTest==true}
    return {speed=linear.Magnitude*self.tune.metresPerStud*3.6,rpm=self.core:engineRpm(),
        gear=Vehicle.displayGear(gear),gearIndex=gear,wheels=wheels,torque=0,
        clutchSlip=st[35]-st[37],limiter=self.core:revLimiter(),
        throttleIn=thr,brakeIn=brk,clutchIn=clu,lfSteer=lf,rfSteer=rf,
        brakePedal=pedal,brakeTarget=target,brakeTick=tickValue,brakeCore=coreBrake,brakeBias=self.brakeBias,
        droppedTime=0,fault=self.fault,mode="NR2003_CUP",tick=self.core:tick(),backlog=self.runner.accumulator,
        chassisStateCount=45,chassisIntegration="NR2003 original JIT (005b39a0/005b3180/005b3e50/005b2fb0)",
        collision=self.collision==true,aero=aero,
        stage11=s11 and {mode=s11.mode,fuelKg=s11.fuel.kg,fuelRecordKg=s11.fuel.massRecord,water=s11.engine.water,oil=s11.engine.oil,
            coolantLevel=s11.engine.coolantLevel,oilLevel=s11.engine.oilLevel,power=s11.engine.power,life=s11.engine.life,
            overRev=s11.engine.overRev,damageScale=s11.damage.scale,engineDamage=s11.damage.engine,leakRadiator=s11.damage.radiator,
            leakOil=s11.damage.oil,leakFuel=s11.damage.fuel,zones=s11.damage.zones,failures=s11.damage.failures,
            broken=s11.damage.brokenFlags,airspeed=s11.airspeed,ambientK=s11.ambient} or nil,
        -- Stage 12: hubSteerAngle = mean prescribed hub coordinate q (states 15 / 21, + = left; the original car[0x1554]),
        -- a rotation about the inclined steering axis (caster 2.455 deg, inclination 9.215 deg); roadWheelAngle = mean
        -- front wheel yaw measured from the solver wheel poses (+ = right, Stage 5 sign; about -0.99 q, no Ackermann)
        hubSteerAngle=st[16]*0.5+st[22]*0.5,roadWheelAngle=(self.wheelPose[1].steer+self.wheelPose[2].steer)*0.5,
        steeringWheelAngle=self:steeringWheelAngle(),steering=self:steeringTelemetry(),ffb=self:forceFeedbackTelemetry()}
end
-- Stage 13 force-feedback telemetry (original cells + the last device output, see STAGE13_FFB_STATE_MAP.md)
function M:forceFeedbackTelemetry()
    if not self.core.V.forceFeedbackState then return nil end
    local f=self.core:forceFeedbackState(self.ffbOut)
    return {enabled=f.enabled,acquired=f.acquired,suspended=f.suspended,effect=f.effect,force=f.force,magnitude=f.magnitude,
        slip=f.slip,moment=f.moment,filtered=f.filtered,load=f.load,strength=f.strength,damping=f.damping,latency=f.latency,
        axis=f.axis}
end
-- Stage 12 steering telemetry (original cells, see STAGE12_STEERING_STATE_MAP.md); nil without the Stage 12 core
function M:steeringTelemetry()
    if not self.core.V.steeringState then return nil end
    local s=self.core:steeringState(self.steeringOut)
    return {left=s.left,right=s.right,digital=s.digital,input=s.input,shaped=s.shaped,ratio=s.ratio,ratioNow=s.ratioNow,
        target=s.target,current=s.current,lf=s.lf,rf=s.rf,hubLF=s.hubLF,hubRF=s.hubRF,wheelAngle=s.wheelAngle,
        sensitivity=s.sensitivity,mode=s.mode}
end
function M:reset()
    self.car:PivotTo(self.spawn);self.fault=nil;self.car:SetAttribute("PhysicsFault",nil)
    self.rootCF=nil;self:initialize();self.car:PivotTo(self.rootCF)
end
function M:destroy()
    self.access:destroy();self.car:SetAttribute("NR2003CorePoseOwner",nil)
    self.root.Anchored=self.oldAnchored;self.root.CanCollide=self.oldCollide
end
return M
]=])
stage("Client.NR2003Client",[=[
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local CAS=game:GetService("ContextActionService")
local UIS=game:GetService("UserInputService")
local HapticService=game:GetService("HapticService")
local player=Players.LocalPlayer
local package=game:GetService("ReplicatedStorage"):WaitForChild("NR2003Lab")
local Config=require(package.Roblox.DriverConfig)
local Tune=require(package.Core.TestTune)
local RenderPresentation=require(package.Roblox.RenderPresentation)
local remote=package:WaitForChild("Input");local telemetry=package:WaitForChild("Telemetry")
local renderState=package:WaitForChild("RenderState")
local car=workspace:WaitForChild("NR2003LabWorld"):WaitForChild("TestCar")
local seat=car:WaitForChild("DriverSeat");local root=car:WaitForChild("Chassis")
-- Stage 6/7: NR2003_CUP presents the car with the Cup geometry (CupTune); other modes keep TestTune
local modeName=require(package.Roblox.ModeConfig).mode
local presentationTune=(modeName=="NR2003_CUP" and package.Core:FindFirstChild("CupTune")) and require(package.Core.CupTune).new() or Tune.new()
local presentation=RenderPresentation.new(car,presentationTune,renderState)
local keys={};local driving=false;local sendTimer=0;local cameraMode=1;local expanded=true;local renderDiag=false
local savedCameraType,savedCameraSubject,savedFieldOfView
local gui=Instance.new("ScreenGui");gui.Name="NR2003LabHUD";gui.ResetOnSpawn=false
gui.Parent=player:WaitForChild("PlayerGui")
local entry=Instance.new("TextLabel");entry.Name="EntryStatus";entry.Size=UDim2.fromOffset(560,42)
entry.Position=UDim2.new(.5,-280,1,-70);entry.BackgroundColor3=Color3.fromRGB(17,24,34)
entry.TextColor3=Color3.fromRGB(240,245,250);entry.TextSize=16;entry.TextWrapped=true
entry.Font=Enum.Font.Gotham;entry.Visible=false;entry.Parent=gui
local entryUntil=0
remote.OnClientEvent:Connect(function(message)
    if type(message)=="table" and message.kind=="seat" then
        entry.Text=tostring(message.message);entryUntil=os.clock()+5;entry.Visible=true
    end
end)
UIS.InputBegan:Connect(function(input,processed)
    if processed or UIS:GetFocusedTextBox() or input.KeyCode~=Enum.KeyCode.F then return end
    local character=player.Character;local hrp=character and character:FindFirstChild("HumanoidRootPart")
    if hrp and (hrp.Position-seat.Position).Magnitude<=Config.entryDistanceStuds then remote:FireServer({kind="enter"}) end
end)
local panel=Instance.new("Frame");panel.Name="Telemetry";panel.Position=UDim2.new(0,16,0,70)
panel.Size=UDim2.fromOffset(460,250);panel.BackgroundColor3=Color3.fromRGB(17,24,34)
panel.BackgroundTransparency=0.08;panel.BorderSizePixel=0;panel.Visible=false;panel.Parent=gui
local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,8);corner.Parent=panel
local function label(parent,name,y,height,size)
    local l=Instance.new("TextLabel");l.Name=name;l.Position=UDim2.fromOffset(14,y)
    l.Size=UDim2.new(1,-28,0,height);l.BackgroundTransparency=1
    l.TextColor3=Color3.fromRGB(225,232,240);l.TextXAlignment=Enum.TextXAlignment.Left
    l.Font=Enum.Font.Code;l.TextSize=size;l.TextWrapped=false;l.Parent=parent;return l
end
local title=label(panel,"Title",10,22,17);title.Text="NR2003 / bancada de física";title.TextColor3=Color3.fromRGB(94,197,255)
local gauge=label(panel,"Gauges",38,28,22);gauge.Text="0 km/h | 900 rpm | 1"
local header=label(panel,"Header",80,18,13);header.Text="RODA   CARGA N  CURSO mm  SLIP %  PNEU °C"
local rows={};for j=1,4 do rows[j]=label(panel,"Wheel"..j,98+(j-1)*20,20,13) end
-- Stage 9: aero line (ORIGINAL 00561b70 evaluated by the server adapter at telemetry rate)
local aeroLine=label(panel,"Aero",180,30,11);aeroLine.Text="";aeroLine.TextColor3=Color3.fromRGB(150,214,160)
-- Stage 11: runtime systems line (ORIGINAL cells read by the server adapter at telemetry rate; display only)
local s11Line=label(panel,"Stage11",212,30,11);s11Line.Text="";s11Line.TextColor3=Color3.fromRGB(236,200,140)
-- Stage 12: steering line (ORIGINAL steering cells read by the server adapter at telemetry rate; display only)
local steerLine=label(panel,"Stage12",246,16,11);steerLine.Text="";steerLine.TextColor3=Color3.fromRGB(190,172,244)
-- Stage 13: force-feedback line (ORIGINAL FFB cells + the constant force sent to the device; display only)
local ffbLine=label(panel,"Stage13",263,16,11);ffbLine.Text="";ffbLine.TextColor3=Color3.fromRGB(244,172,190)
local hint=label(panel,"Controls",282,50,11)
hint.Text="W/S acelerar/frear   A/D direção (gamepad: analógico esquerdo)   E/Q marchas\nShift embreagem   Espaço freio de mão   X sair\nT painel   G contatos   H render diag   V câmera   R reposicionar"
local status=label(panel,"Status",331,16,11);status.Text="Tune de teste | contato por raycast"
local renderInfo=Instance.new("TextLabel");renderInfo.Name="RenderDiagnostics";renderInfo.AnchorPoint=Vector2.new(1,0)
renderInfo.Position=UDim2.new(1,-16,0,20);renderInfo.Size=UDim2.fromOffset(390,142);renderInfo.BackgroundColor3=Color3.fromRGB(17,24,34)
renderInfo.BackgroundTransparency=0.08;renderInfo.BorderSizePixel=0;renderInfo.TextColor3=Color3.fromRGB(225,232,240)
renderInfo.Font=Enum.Font.Code;renderInfo.TextSize=13;renderInfo.TextXAlignment=Enum.TextXAlignment.Left;renderInfo.TextYAlignment=Enum.TextYAlignment.Top
renderInfo.TextWrapped=false;renderInfo.Visible=false;renderInfo.Parent=gui
local renderCorner=Instance.new("UICorner");renderCorner.CornerRadius=UDim.new(0,8);renderCorner.Parent=renderInfo
local function isDriver()
    local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    return h and h.SeatPart==seat
end
local bindings={
    {"Gas","Acelerar",Enum.KeyCode.W,Enum.KeyCode.Up},{"Brake","Frear",Enum.KeyCode.S,Enum.KeyCode.Down},
    {"Left","←",Enum.KeyCode.A,Enum.KeyCode.Left},{"Right","→",Enum.KeyCode.D,Enum.KeyCode.Right},
    {"Handbrake","Mão",Enum.KeyCode.Space},{"Clutch","Embreagem",Enum.KeyCode.LeftShift},
    {"UpGear","+ marcha",Enum.KeyCode.E},{"DownGear","− marcha",Enum.KeyCode.Q},
    {"Reset","Reset",Enum.KeyCode.R},{"Debug","Contato",Enum.KeyCode.G},
    {"Details","Painel",Enum.KeyCode.T},{"Camera","Câmera",Enum.KeyCode.V},{"RenderDiag","Render",Enum.KeyCode.H},{"Exit","Sair",Enum.KeyCode.X},
}
local function action(name,state)
    if not isDriver() then return Enum.ContextActionResult.Pass end
    name=name:gsub("NR2003_","")
    if state==Enum.UserInputState.Begin then
        keys[name]=true
        if name=="UpGear" then remote:FireServer({kind="shift",delta=1})
        elseif name=="DownGear" then remote:FireServer({kind="shift",delta=-1})
        elseif name=="Reset" then remote:FireServer({kind="reset"})
        elseif name=="Debug" then remote:FireServer({kind="debug"})
        elseif name=="Exit" then remote:FireServer({kind="exit"})
        elseif name=="Details" then expanded=not expanded
        elseif name=="Camera" then cameraMode=cameraMode%3+1
        elseif name=="RenderDiag" then renderDiag=not renderDiag;renderInfo.Visible=renderDiag end
    elseif state==Enum.UserInputState.End or state==Enum.UserInputState.Cancel then keys[name]=nil end
    return Enum.ContextActionResult.Sink
end
local function bind()
    for i,b in ipairs(bindings) do
        local codes={};for j=3,#b do table.insert(codes,b[j]) end
        CAS:BindActionAtPriority("NR2003_"..b[1],action,i<=8,2100,table.unpack(codes))
        CAS:SetTitle("NR2003_"..b[1],b[2])
        if i<=8 then CAS:SetPosition("NR2003_"..b[1],UDim2.new(1,-80-((i-1)%4)*78,1,-90-math.floor((i-1)/4)*75)) end
    end
end
local function unbind() for _,b in ipairs(bindings) do CAS:UnbindAction("NR2003_"..b[1]) end;keys={} end
UIS.WindowFocusReleased:Connect(function() keys={} end)
telemetry.OnClientEvent:Connect(function(data)
    if not driving then return end
    title.Text=data.mode=="NR2003_CUP" and "NR2003 Cup / núcleo original 45 estados · estágios 6-8"
        or (data.mode=="NR2003_CORE" and "NR2003 / chassi numérico · estágio 5 estabilizado" or "NR2003 / adaptador Roblox")
    local gear=data.gear==-1 and "R" or (data.gear==0 and "N" or tostring(data.gear))
    gauge.Text=string.format("%3.0f km/h | %4.0f rpm | %s",data.speed,data.rpm,gear)
    local cup=data.mode=="NR2003_CUP" and data.brakePedal~=nil
    header.Text=cup and "RODA   CARGA N  CURSO mm  SLIP %  FREIO Nm" or "RODA   CARGA N  CURSO mm  SLIP %  PNEU °C"
    for j,w in ipairs(data.wheels) do
        if cup then
            rows[j].Text=string.format("%s   %7.0f  %8.1f  %6.1f  %7.0f%s",w.name,w.load,w.compression*1000,w.slip*100,math.abs(w.brakeTorque or 0),w.locked and " TRAV" or "")
            rows[j].TextColor3=w.locked and Color3.fromRGB(255,96,96) or (w.grounded and Color3.fromRGB(216,228,237) or Color3.fromRGB(246,147,106))
        else
            rows[j].Text=string.format("%s   %7.0f  %8.1f  %6.1f  %7.1f",w.name,w.load,w.compression*1000,w.slip*100,w.temperature)
            rows[j].TextColor3=w.grounded and Color3.fromRGB(216,228,237) or Color3.fromRGB(246,147,106)
        end
    end
    local a=data.aero
    if a then
        if a.session then
            aeroLine.Text=string.format("AERO rho %.4f  q %5.0f Pa  arrasto %5.0f N  downforce %5.0f N (D %5.0f / T %5.0f)\nfatores %.3f/%.3f/%.3f%s  alt. diant. %4.0f mm  fita %d%%  aerofólio %d°  yaw %.1f°",
                a.density,a.q,a.drag,a.downforce,a.front,a.rear,a.factorDrag,a.factorFront,a.factorRear,a.draftTest and " (vácuo TESTE)" or "",
                a.rideHeight*1000,a.grilleTape,a.spoiler,math.deg(a.yaw))
        else
            aeroLine.Text="AERO sem sessão (AeroSession=false): estado pós-build, rho = 0, sem forças aero"
        end
    else aeroLine.Text="" end
    local s=data.stage11
    if s and s.mode=="original" then
        local t={}
        for j,w in ipairs(data.wheels) do
            t[j]=string.format("%s %3.0f°C %4.1fpsi %3.0f%%%s",w.name,(w.temperature or 0),w.tyrePressure or 0,100*(w.tyreWear or 0),
                (w.tyreState or 0)>=2 and " FURADO" or "")
        end
        local zmax=0;for _,z in ipairs(s.zones or {}) do zmax=math.max(zmax,z) end
        s11Line.Text=string.format("COMB %.2f kg  água %.1f°C  óleo %.1f°C  pot %.3f  dano mot %.2f vaz %.2f/%.2f/%.2f carroc %.2f\n%s | freio %.0f/%.0f/%.0f/%.0f°C",
            s.fuelKg,s.water,s.oil,s.power,s.engineDamage,s.leakRadiator,s.leakOil,s.leakFuel,zmax,table.concat(t,"  "),
            (data.wheels[1].brakeTemperatureK or 273.15)-273.15,(data.wheels[2].brakeTemperatureK or 273.15)-273.15,
            (data.wheels[3].brakeTemperatureK or 273.15)-273.15,(data.wheels[4].brakeTemperatureK or 273.15)-273.15)
    elseif s then
        s11Line.Text="ESTÁGIO 11 congelado (Stage11Runtime=frozen): combustível/térmica/desgaste/dano nos valores pós-build"
    else s11Line.Text="" end
    local sd=data.steering
    if sd and sd.mode=="original" then
        -- all angles shown with one sign convention, + = right (the simulation cells are + = left: negated here)
        steerLine.Text=string.format("DIREÇÃO %s (+ = dir.)  entrada %+.3f  relação %.1f:1  alvo %+.2f°  cubos %+.2f/%+.2f°  rodas %+.2f°  volante %+.0f°",
            sd.digital and "teclas" or "eixo",sd.input or 0,sd.ratioNow or 0,-math.deg(sd.target or 0),-math.deg(sd.hubLF or 0),-math.deg(sd.hubRF or 0),
            math.deg(data.roadWheelAngle or 0),math.deg(data.steeringWheelAngle or 0))
    else steerLine.Text="" end
    local fb=data.ffb
    if fb then
        ffbLine.Text=fb.enabled and string.format("FFB %s  força %+.3f (DI %+d)  deslize %+.4f  momento %+.1f  filtro %+.1f | força %g amort %g lat %g ms",
            fb.acquired and (fb.suspended and "suspenso" or "ativo (eixo)") or "inativo (teclas / sem dispositivo)",fb.force or 0,fb.magnitude or 0,
            fb.slip or 0,fb.moment or 0,fb.filtered or 0,fb.strength or 0,fb.damping or 0,fb.latency or 0)
            or "FFB desligado (atributo ForceFeedback)"
    else ffbLine.Text="" end
    if data.mode=="NR2003_CUP" then
        status.Text=data.fault and "Física pausada; veja Output. R reinicia." or string.format("acel %.2f | pedal freio %.2f -> núcleo %.2f | viés %d%% | embr %.2f | lim %s%s",
            data.throttleIn or 0,data.brakePedal or 0,data.brakeCore or data.brakeIn or 0,data.brakeBias or 74,data.clutchIn or 0,data.limiter and "ON" or "off",data.collision and " | colisão" or "")
    else
        status.Text=data.fault and "Física pausada; veja Output. R reinicia." or string.format("Motor %.0f Nm | embreagem Δ %.0f rad/s",data.torque,data.clutchSlip)
    end
end)
-- Stage 13 presentation (NOT original): the ORIGINAL constant force -> large motor of the active gamepad, |force| 0..1
local rumbleGamepad=nil
local function setRumble(gp,v)
    if gp then pcall(function() HapticService:SetMotor(gp,Enum.VibrationMotor.Large,v) end) end
end
local function stopRumble() setRumble(rumbleGamepad,0);rumbleGamepad=nil end
local function updateRumble()
    if presentationTune.driver and presentationTune.driver.ffbRumble==false then return end
    local last=UIS:GetLastInputType()
    local gp=(last.Name:sub(1,7)=="Gamepad" and UIS:GetGamepadConnected(last)) and last or nil
    if gp~=rumbleGamepad then stopRumble() end
    if gp==nil then return end
    local ok,supported=pcall(function() return HapticService:IsVibrationSupported(gp) and HapticService:IsMotorSupported(gp,Enum.VibrationMotor.Large) end)
    if not (ok and supported) then return end
    rumbleGamepad=gp
    local f=car:GetAttribute("FFBForce")
    local v=(car:GetAttribute("FFBActive")==true and type(f)=="number") and math.clamp(math.abs(f),0,1) or 0
    setRumble(gp,v)
end
local diagTimer=0
local function updateRenderDiag(dt)
    if not renderDiag then return end
    diagTimer=diagTimer+dt;if diagTimer<0.25 then return end;diagTimer=0
    local s=presentation:stats()
    renderInfo.Text=string.format(" RENDER / PRESENTATION ONLY\n sim %6.1f Hz   snapshot %5.1f Hz   recv %5.1f Hz\n render %5.1f FPS  delay %5.1f ms   buffer %d\n drops %d   out-of-order %d   resets %d\n extrap episodes %d   max %.1f ms\n mode %-7s alpha %.3f   active %s",
        s.serverTickHz or 0,s.serverSnapshotHz or 0,s.recvHz or 0,s.renderFPS or 0,(s.delay or 0)*1000,s.buffer or 0,
        s.dropped or 0,s.outOfOrder or 0,s.resets or 0,s.extrapEpisodes or 0,(s.maxExtrapSeen or 0)*1000,
        tostring(s.mode),s.alpha or 0,tostring(s.active))
end
local function frame(dt)
    presentation:update() -- MUST precede every camera path; render state never feeds physics.
    entry.Visible=os.clock()<entryUntil
    local nowDriving=isDriver() and true or false
    if nowDriving~=driving then
        driving=nowDriving;panel.Visible=driving
        if driving then
            bind();savedCameraType=workspace.CurrentCamera.CameraType;savedCameraSubject=workspace.CurrentCamera.CameraSubject
            savedFieldOfView=workspace.CurrentCamera.FieldOfView
        else
            unbind();renderDiag=false;renderInfo.Visible=false;stopRumble()
            if savedCameraType then workspace.CurrentCamera.CameraType=savedCameraType end
            if savedCameraSubject and savedCameraSubject.Parent then workspace.CurrentCamera.CameraSubject=savedCameraSubject end
            if savedFieldOfView then workspace.CurrentCamera.FieldOfView=savedFieldOfView end
        end
    end
    updateRenderDiag(dt)
    if not driving then return end
    header.Visible=expanded;for _,r in ipairs(rows) do r.Visible=expanded end
    aeroLine.Visible=expanded;s11Line.Visible=expanded;steerLine.Visible=expanded;ffbLine.Visible=expanded
    hint.Visible=expanded;status.Visible=expanded;panel.Size=UDim2.fromOffset(600,expanded and 352 or 76)
    updateRumble()
    local camera=workspace.CurrentCamera
    if cameraMode==1 then
        camera.CameraType=Enum.CameraType.Scriptable;camera.FieldOfView=savedFieldOfView or 70
        local look=root.Position+Vector3.new(0,2,0)
        local behind=root.Position-root.CFrame.LookVector*24+Vector3.new(0,10,0)
        camera.CFrame=camera.CFrame:Lerp(CFrame.lookAt(behind,look+root.CFrame.LookVector*8),1-math.exp(-8*dt))
    elseif cameraMode==2 and seat:FindFirstChild("CockpitCamera") then
        camera.CameraType=Enum.CameraType.Scriptable;camera.FieldOfView=Config.cockpitFieldOfView
        camera.CFrame=seat.CockpitCamera.WorldCFrame
    else
        camera.CameraType=Enum.CameraType.Custom;camera.CameraSubject=seat;camera.FieldOfView=savedFieldOfView or 70
    end
    sendTimer=sendTimer+dt
    if sendTimer>=1/30 then
        sendTimer=sendTimer%(1/30)
        -- Stage 12: raw steering controls (the NR2003 device layer 0057abc0 on the server side splits them into
        -- controls 7 / 8): keys A/D or arrows = key bindings (digital); a gamepad thumbstick (last input from a
        -- gamepad) = one analog axis, already normalised -1..1 by Roblox (deadzone: DriverConfig, 0 = none)
        local axis,analog=nil,false
        local last=UIS:GetLastInputType()
        if last.Name:sub(1,7)=="Gamepad" and UIS:GetGamepadConnected(last) then
            for _,o in ipairs(UIS:GetGamepadState(last)) do
                if o.KeyCode==Enum.KeyCode.Thumbstick1 then
                    axis=o.Position.X
                    if math.abs(axis)<(Config.gamepadSteerDeadzone or 0) then axis=0 end
                    analog=true
                end
            end
        end
        local left,right=keys.Left and 1 or 0,keys.Right and 1 or 0
        remote:FireServer({kind="input",throttle=keys.Gas and 1 or 0,brake=keys.Brake and 1 or 0,
            steer=analog and axis or (right-left),handbrake=keys.Handbrake and 1 or 0,clutch=keys.Clutch and 1 or 0,
            steerLeft=left,steerRight=right,steerAxis=axis,steerAnalog=analog})
    end
end
local renderName="NR2003_Presentation"
RunService:BindToRenderStep(renderName,Enum.RenderPriority.Camera.Value-1,frame)
script.Destroying:Connect(function()
    RunService:UnbindFromRenderStep(renderName);presentation:destroy();unbind();stopRumble()
end)
]=])
stage("NR2003Cup.NR2003CupFFB",[=[
--!native
--!optimize 2
-- Stage 13: the ORIGINAL NR2003 force feedback (steering torque) of the player car, hand port of the x86
-- (recovered in recovery/stage13, STAGE13_RECOVERY.md). A presentation output: nothing here feeds the physics or the
-- steering chain (Stage 12 evidence ffbinterface.md + Stage 13 dynamic proof).
--
-- Producers (Stage 6/7 core, unchanged): the front tyre callback 0055e180 -> 00554e70 accumulates per front wheel
-- (slot 0 LF, 1 RF), twice per tick (predictor + corrector): n 74c964+4i, A bf6ed4+4i += c085dc (relaxed lateral slip
-- state), B bf6edc+4i += |Fz| + 0.01, C bf6ee4+4i += Fy, D bf6eec+4i += 0.1 * (r x F).z + c081ec (aligning moment).
-- Per 288 Hz tick, 005539c0 @00553a64 (V._ffbTick, called by NR2003CupDriver.tickInputs):
--   00554d30  l = B_LF / (B_LF + B_RF) (only when n_LF > 0 and the sum > 0), a = 1/n_LF, b = 1/n_RF ->
--             74c960 = min(B_RF b + B_LF a, 1500) (no reader), bf6ec4 = (1 - l) A_RF b + l A_LF a (slip),
--             bf6ec8 = C_RF b + C_LF a (no reader), bf6ed0 = D_RF b + D_LF a (moment); n, A, B, C, D <- 0
-- Per 36 Hz frame, FFB block of the frame end 00554520 (0055464c..0055479d; V._ffbFrameEnd, called by
-- NR2003CupFrame right after the lifted 00554520, whose own copy of the block is skipped):
--   gate bf6ebb (FF effect acquired) != 0 and bf6eb8 (player controls suspended) == 0
--   d = (ec4 - ec0) * 36 ; ec0 = ec4 ; q = ec4 + d * (latency bf6f20 * 0.001) * (1 - 20 / (airspeed bf3a00 + 20))
--   m = |ec4| > 1e-5 ? q / ec4 * ed0 : ed0 ; ecc = (m - damping bf6f24 * d + ecc) * 0.5
--   out = clamp(ecc * strength 74c9a4 / (setup item 0x30 * 1600), -1, 1) -> 005d08d0(axis bf6ebc, out)
--   005d08d0 -> 005d2260 -> 005d3010: DirectInput constant force (one axis, rglDirection 0, autocentre off)
--   lMagnitude = _ftol(out * 10000), SetParameters(DIEP_TYPESPECIFICPARAMS | DIEP_START): the ADAPTER output here.
-- Controls / device (simulation side, ORIGINAL): 00550070(flag) (bf6eb8 = flag; flag 0 -> 0054fed0 FF axis setup from
-- the control-7 binding: axis binding + FF on (bf6f1c) + capable device -> acquired bf6ebb = 1, axis bf6ebc), 00550030
-- (zero force), 00550680 (release). bf6eb8 is ALSO the 005524f0 player-branch gate (@00552549, NR2003CupDriver).
-- Options (messages 8..11, sent only by the controls.cfg loader 0043f1d0): 00550270 on/off bf6f1c, 00550290 strength
-- 74c9a4, 005502d0 damping bf6f24, 005502b0 latency bf6f20 (controls.cfg integers converted by fild / fstp dword).
--
-- Arithmetic: the simulation task runs the x87 with CW 0x077f (64-bit precision, round toward -inf). The FFB code is
-- evaluated in EXACT x87 arithmetic (X87 below: every operation rounded to a 64-bit significand toward -inf, every
-- f32 store rounded toward -inf), not in IEEE double: an exact intermediate within double rounding of an f32 boundary
-- (e.g. f32 a + a tiny negative b: double returns a, the x87 a value below a) would otherwise change a stored bit.
-- Exact fast path in double when every operation is exact (checked by TwoSum / Dekker TwoProduct), limb arithmetic
-- otherwise. Pure Luau: no Instances.
return function(V)
	local rf32, r32, ri32, w32, r8, w8, wf32 = V.rf32, V.r32, V.ri32, V.w32, V.r8, V.w8, V.wf32
	local floor, huge = math.floor, math.huge
	local frexp, ldexp = math.frexp, math.ldexp

	---------------------------------------------------------------------------------------------------------
	-- X87: exact 64-bit-significand arithmetic, round toward -inf (x87 CW 0x077f). A value is a pair (h, l) of doubles,
	-- h + l exact, h = the value truncated toward zero to 53 significant bits, l the rest (same sign, |l| < ulp(h)).
	---------------------------------------------------------------------------------------------------------
	local TWO32, TWO31 = 4294967296, 2147483648
	local function unpack(h, l)
		-- nonzero finite -> sign, exponent e (2^e <= |v| < 2^(e+1)), significand m = m1 * 2^32 + m0 in [2^63, 2^64)
		local s = 0
		if h < 0 then s = 1; h = -h; l = -l end
		local _, ex = frexp(h)
		local H, L = ldexp(h, 64 - ex), ldexp(l, 64 - ex)
		local m1 = floor(H / TWO32)
		return s, ex - 1, m1, (H - m1 * TWO32) + L
	end
	local function pack(s, e, m1, m0)
		local low = m0 % 2048
		local h, l = ldexp(m1 * TWO32 + (m0 - low), e - 63), ldexp(low, e - 63)
		if s == 1 then return -h, -l end
		return h, l
	end
	-- the magnitude m (+ a nonzero remainder when inexact) rounded toward -inf for the sign s
	local function round(s, e, m1, m0, inexact)
		if inexact and s == 1 then
			m0 += 1
			if m0 == TWO32 then
				m0 = 0; m1 += 1
				if m1 == TWO32 then m1 = TWO31; e += 1 end
			end
		end
		return pack(s, e, m1, m0)
	end
	-- IEEE 754 sign of an exact zero sum under round toward -inf: +0 only for (+0) + (+0)
	local function zeroSum(a, b)
		if a == 0 and b == 0 and 1 / a > 0 and 1 / b > 0 then return 0 end
		return -0.0
	end
	local function addSlow(ah, al, bh, bl)
		if ah == 0 then
			if bh == 0 then return zeroSum(ah, bh), 0 end
			return bh, bl
		end
		if bh == 0 then return ah, al end
		local sa, ea, a1, a0 = unpack(ah, al)
		local sb, eb, b1, b0 = unpack(bh, bl)
		if eb > ea or (eb == ea and (b1 > a1 or (b1 == a1 and b0 > a0))) then
			sa, ea, a1, a0, sb, eb, b1, b0 = sb, eb, b1, b0, sa, ea, a1, a0
		end
		-- B aligned to A with a 32-bit guard limb (y1, y0, yg) + sticky (bits shifted out below the guard limb)
		local d = ea - eb
		local y1, y0, yg, sticky = b1, b0, 0, false
		if d >= 96 then
			y1, y0, yg, sticky = 0, 0, 0, true
		else
			while d >= 32 do
				sticky = sticky or yg ~= 0
				yg = y0; y0 = y1; y1 = 0; d -= 32
			end
			if d > 0 then
				local p, q = 2 ^ d, 2 ^ (32 - d)
				local r1, r0, rg = y1 % p, y0 % p, yg % p
				sticky = sticky or rg ~= 0
				yg = (yg - rg) / p + r0 * q
				y0 = (y0 - r0) / p + r1 * q
				y1 = (y1 - r1) / p
			end
		end
		local z1, z0, zg
		if sa == sb then
			zg = yg; z0 = a0 + y0; z1 = a1 + y1
			if z0 >= TWO32 then z0 -= TWO32; z1 += 1 end
			if z1 >= TWO32 then
				local c0, cg = z0 % 2, zg % 2
				sticky = sticky or cg ~= 0
				zg = (zg - cg) / 2 + c0 * TWO31
				local c1 = z1 % 2
				z0 = (z0 - c0) / 2 + c1 * TWO31
				z1 = (z1 - c1) / 2
				ea += 1
			end
		else
			-- |A| - |B|; with sticky the true |B| exceeds (y1, y0, yg) by less than one guard unit: subtract one more
			-- unit, the remaining fraction (0, 1) is the (nonzero) remainder
			zg = -yg; z0 = a0 - y0; z1 = a1 - y1
			if sticky then zg -= 1 end
			if zg < 0 then zg += TWO32; z0 -= 1 end
			if z0 < 0 then z0 += TWO32; z1 -= 1 end
			if z1 == 0 and z0 == 0 and zg == 0 and not sticky then return -0.0, 0 end
			while z1 < TWO31 do
				local t0, tg = floor(z0 / TWO31), floor(zg / TWO31)
				z1 = z1 * 2 + t0
				z0 = (z0 - t0 * TWO31) * 2 + tg
				zg = (zg - tg * TWO31) * 2
				ea -= 1
			end
		end
		return round(sa, ea, z1, z0, zg ~= 0 or sticky)
	end
	local function add(ah, al, bh, bl)
		if al == 0 and bl == 0 then
			local s = ah + bh
			if s ~= s or s == huge or s == -huge then return s, 0 end
			local bb = s - ah
			if (ah - (s - bb)) + (bh - bb) == 0 then          -- TwoSum error 0: exact
				if s == 0 then return zeroSum(ah, bh), 0 end
				return s, 0
			end
		end
		return addSlow(ah, al, bh, bl)
	end
	local function sub(ah, al, bh, bl) return add(ah, al, -bh, -bl) end
	local SPLIT = 134217729 -- 2^27 + 1 (Dekker)
	local function prodErr(a, b, p)
		local t = SPLIT * a
		local a1 = t - (t - a)
		local a2 = a - a1
		t = SPLIT * b
		local b1 = t - (t - b)
		local b2 = b - b1
		return ((a1 * b1 - p) + a1 * b2 + a2 * b1) + a2 * b2
	end
	local function limbs16(m1, m0)
		local x3, x1 = floor(m1 / 65536), floor(m0 / 65536)
		return m0 - x1 * 65536, x1, m1 - x3 * 65536, x3
	end
	local function mulSlow(ah, al, bh, bl)
		local sa, ea, a1, a0 = unpack(ah, al)
		local sb, eb, b1, b0 = unpack(bh, bl)
		local x0, x1, x2, x3 = limbs16(a1, a0)
		local y0, y1, y2, y3 = limbs16(b1, b0)
		local t = x0 * y0
		local p0 = t % 65536; t = (t - p0) / 65536 + x0 * y1 + x1 * y0
		local p1 = t % 65536; t = (t - p1) / 65536 + x0 * y2 + x1 * y1 + x2 * y0
		local p2 = t % 65536; t = (t - p2) / 65536 + x0 * y3 + x1 * y2 + x2 * y1 + x3 * y0
		local p3 = t % 65536; t = (t - p3) / 65536 + x1 * y3 + x2 * y2 + x3 * y1
		local p4 = t % 65536; t = (t - p4) / 65536 + x2 * y3 + x3 * y2
		local p5 = t % 65536; t = (t - p5) / 65536 + x3 * y3
		local p6 = t % 65536
		local p7 = (t - p6) / 65536
		local s, e = (sa + sb) % 2, ea + eb
		local m1, m0, inexact
		if p7 >= 32768 then                                     -- product in [2^127, 2^128)
			m1, m0 = p7 * 65536 + p6, p5 * 65536 + p4
			inexact = p3 ~= 0 or p2 ~= 0 or p1 ~= 0 or p0 ~= 0
			e += 1
		else                                                    -- [2^126, 2^127): one bit left
			local c5, c3 = floor(p5 / 32768), floor(p3 / 32768)
			m1 = (p7 * 65536 + p6) * 2 + c5
			m0 = ((p5 - c5 * 32768) * 65536 + p4) * 2 + c3
			inexact = (p3 - c3 * 32768) ~= 0 or p2 ~= 0 or p1 ~= 0 or p0 ~= 0
		end
		return round(s, e, m1, m0, inexact)
	end
	local function mul(ah, al, bh, bl)
		if al == 0 and bl == 0 then
			local p = ah * bh
			if p == 0 or p ~= p or p == huge or p == -huge then return p, 0 end
			if prodErr(ah, bh, p) == 0 then return p, 0 end
		end
		if ah == 0 or bh == 0 then return ah * bh, 0 end          -- exact zero: sign = xor of the signs (h holds the sign)
		return mulSlow(ah, al, bh, bl)
	end
	local function divSlow(ah, al, bh, bl)
		local sa, ea, a1, a0 = unpack(ah, al)
		local sb, eb, b1, b0 = unpack(bh, bl)
		local e = ea - eb
		local r1, r0 = a1, a0
		if a1 < b1 or (a1 == b1 and a0 < b0) then
			r0 *= 2; r1 *= 2
			if r0 >= TWO32 then r0 -= TWO32; r1 += 1 end
			e -= 1
		end
		local q1, q0 = 0, 0
		for i = 1, 64 do
			local bit = 0
			if r1 > b1 or (r1 == b1 and r0 >= b0) then
				bit = 1
				r0 -= b0; r1 -= b1
				if r0 < 0 then r0 += TWO32; r1 -= 1 end
			end
			if i <= 32 then q1 = q1 * 2 + bit else q0 = q0 * 2 + bit end
			r0 *= 2; r1 *= 2
			if r0 >= TWO32 then r0 -= TWO32; r1 += 1 end
		end
		return round((sa + sb) % 2, e, q1, q0, r1 ~= 0 or r0 ~= 0)
	end
	local function div(ah, al, bh, bl)
		if al == 0 and bl == 0 then
			local q = ah / bh
			if q == 0 or q ~= q or q == huge or q == -huge then return q, 0 end
			local p = q * bh
			if p == ah and prodErr(q, bh, p) == 0 then return q, 0 end
		end
		if ah == 0 then return ah / bh, 0 end
		return divSlow(ah, al, bh, bl)
	end
	-- FST dword: the value rounded toward -inf to binary32 (returned as the double holding it)
	local SB = buffer.create(4)
	local function f32(h, l)
		buffer.writef32(SB, 0, h)
		local f = buffer.readf32(SB, 0)
		if f - h > l then                                       -- f > h + l
			local u = buffer.readu32(SB, 0)
			if f > 0 then u -= 1 elseif f == 0 then u = 0x80000001 else u += 1 end
			buffer.writeu32(SB, 0, u)
			f = buffer.readf32(SB, 0)
		end
		return f
	end
	local X87 = {add = add, sub = sub, mul = mul, div = div, f32 = f32}
	V.x87 = X87 -- exposed for the Stage 13 arithmetic vectors (tests/stage13)

	---------------------------------------------------------------------------------------------------------
	-- cells (original addresses) and .rdata constants (the cells the original reads)
	---------------------------------------------------------------------------------------------------------
	local N_LF, N_RF = 0x74c964, 0x74c968
	local A_LF, A_RF, B_LF, B_RF = 0xbf6ed4, 0xbf6ed8, 0xbf6edc, 0xbf6ee0
	local C_LF, C_RF, D_LF, D_RF = 0xbf6ee4, 0xbf6ee8, 0xbf6eec, 0xbf6ef0
	local LOAD, SLIP, FY, MOMENT = 0x74c960, 0xbf6ec4, 0xbf6ec8, 0xbf6ed0
	local PREV, FILT = 0xbf6ec0, 0xbf6ecc
	local SUSPENDED, ACQUIRED, AXIS, DIRSIGN = 0xbf6eb8, 0xbf6ebb, 0xbf6ebc, 0x74c95c
	local FF_ON, STRENGTH, DAMPING, LATENCY = 0xbf6f1c, 0x74c9a4, 0xbf6f24, 0xbf6f20
	local AIRSPEED = 0xbf3a00                                  -- |v - wind| copied by 00554520 @0055455f
	local SETUP_RATIO = 0xc055c0 + 4 * 0x30                    -- 00557d60(0x30), ECX c055c0: raw item, no override
	local SIMULATED = 0xbf6e04                                 -- 00551880(): player vehicle simulated
	local REC7 = 0xd37cb8 + 29 * 7                             -- control-7 (steer left) binding record (0057b1e0(7))
	local K_ZERO, K_ONE, K_MONE = rf32(0x6ea454), rf32(0x6e97d8), rf32(0x6ea4a8) -- 0, 1, -1
	local K_LOADMAX = rf32(0x6f5878)                           -- 1500
	local K_V0 = rf32(0x6ecfc8)                                -- 20
	local K_MS = rf32(0x6ea67c)                                -- 0.001 (f32)
	local K_EPS = rf32(0x6ea480)                               -- 1e-5 (f32)
	local K_HALF = rf32(0x6ea44c)                              -- 0.5
	local K_SCALE = rf32(0x6f5a44)                             -- 1600
	local K_DI = rf32(0x6f5214)                                -- 10000 (005d3010)
	local RATE = 36                                            -- 005f7c50 taskGetRate (lifter builtin B_taskGetRate)
	local LOAD_MAX_BITS = 0x44bb8000                           -- mov dword [74c960], 1500.0 (immediate)


	---------------------------------------------------------------------------------------------------------
	-- host device layer (ADAPTER: the DirectInput module 005d0xxx / 005d2xxx; no simulation memory)
	---------------------------------------------------------------------------------------------------------
	local device = {capable = false, acquire = true} -- 005d0820 FF support of the bound axis / 005d0840 acquisition result
	local effect = false                             -- f5d414: constant-force effect acquired (005d2bb0)
	local sink = nil                                 -- host callback(axis, force, magnitude) per 005d3010 SetParameters
	local last = {axis = 0, force = 0, magnitude = 0, frames = 0, calls = 0, block = false}
	-- every 005d08d0 call of the ORIGINAL code (force as passed: f32, before the device conversion)
	local trace = nil                                -- tests: table receiving {kind, axis, value}
	local function deviceForce(axis, force)          -- 005d08d0(axis, force)
		last.calls += 1
		if trace then table.insert(trace, {"force", axis, force}) end
		if not effect then return end                 -- [f5d4f0] DirectInput up and [f5d414] effect acquired
		local x = force * K_DI                         -- fld dword ; fmul dword 10000 (exact: 24 x 14 bits)
		local mag = x >= 0 and floor(x) or -floor(-x)  -- _ftol (truncation toward zero)
		last.axis, last.force, last.magnitude = axis, force, mag
		if sink then sink(axis, force, mag) end
	end
	local function deviceAcquire(axis)                -- 00550000 on the FG thread: 005d0840(axis) -> f5d414
		if trace then table.insert(trace, {"acquire", axis}) end
		if not device.capable then return false end
		local ok = device.acquire ~= false
		if ok then effect = true end
		return ok
	end
	local function deviceRelease(axis)                -- 00550060 on the FG thread: 005d0870(axis)
		if trace then table.insert(trace, {"release", axis}) end
		if device.capable then effect = false end
	end

	---------------------------------------------------------------------------------------------------------
	-- simulation-side controls / FF setup (ORIGINAL; 005f79a0 FG requests run synchronously: ADAPTER)
	---------------------------------------------------------------------------------------------------------
	local function band8(x) return bit32.band(math.floor(tonumber(x) or 0), 0xff) end
	local configuredKind = nil -- control-7 binding type at the last 0054fed0 (host bookkeeping, see V._steerDevices)
	-- 00550030: condition effects (005d08a0: no effect exists, no-op) + zero constant force
	local function zeroForce() deviceForce(r32(AXIS), 0) end
	-- 0054fed0: FF axis = the control-7 binding (0057aff0 fields: +0x10 type, +0x14 axis, +0x1c direction)
	local function configure()
		local kind = ri32(REC7 + 0x10)
		configuredKind = kind
		if kind ~= 1 then                                         -- not an analog axis: release
			if r8(ACQUIRED) ~= 0 then deviceRelease(r32(AXIS)); w8(ACQUIRED, 0) end
			return
		end
		local axis = r32(REC7 + 0x14)
		-- axis name "<n><" / "<n>>" (table 0074fc68, axis < 16) or "?" (0074fd52): 74c95c = (char after digits) == '>' ? -1 : 1
		local sign = (bit32.band(axis, 0x7fffffff) < 16 and r8(REC7 + 0x1c) ~= 0) and -1 or 1
		if r8(ACQUIRED) ~= 0 then
			if not (r8(FF_ON) ~= 0 and r32(AXIS) == axis) then  -- 00550280() ; cmp bf6ebc, axis
				deviceRelease(r32(AXIS)); w8(ACQUIRED, 0)
			end
		end
		w32(DIRSIGN, sign); w32(AXIS, axis)
		if r8(ACQUIRED) ~= 0 or r8(FF_ON) == 0 then return end
		if not device.capable then return end                     -- 005d0820(axis)
		if deviceAcquire(axis) then                               -- 005f79a0(00550000, &ok): ok -> 00550030
			zeroForce()
			w8(ACQUIRED, 1)
		end
	end
	-- 00550070(flag): flag 0 = player controls active (FF axis set up), 1 = suspended (force zeroed); bf6eb8 = flag
	local function controls(flag)
		flag = band8(flag)
		if flag == 0 then configure() end
		if r8(ACQUIRED) ~= 0 and flag ~= 0 then zeroForce() end
		w8(SUSPENDED, flag)
	end
	-- 00550680: release at the end of the session (00572cb0 / 00573bc0)
	local function release()
		if r8(ACQUIRED) ~= 0 then deviceRelease(r32(AXIS)); w8(ACQUIRED, 0) end
	end


	---------------------------------------------------------------------------------------------------------
	-- 00554d30 (per tick): front tyre statistics of the last tick's passes; clears the accumulators
	---------------------------------------------------------------------------------------------------------
	local function makeStats(add, sub, mul, div, f32, mu)
		return function()
			local nL, nR = ri32(N_LF), ri32(N_RF)
			local bL, bR = rf32(B_LF), rf32(B_RF)
			local ah, al, l = K_ZERO, 0, 0                          -- 00554d75: fld 0.0 ; mov dword [esp], 0
			if nL > 0 then
				local sh, sl = add(bR, 0, bL, 0)                    -- fld B_RF ; fadd B_LF
				local sx = f32(sh, sl)                              -- fst dword [esp]
				if sh > 0 then                                      -- fcomp 0.0 ; and 0x4100 ; jne (sum <= 0 or NaN)
					ah, al = div(K_ONE, 0, nL, 0)                   -- fild n_LF ; fdivr 1.0
					l = f32(div(bL, 0, sx, 0))                      -- fld B_LF ; fdiv dword [esp] ; fstp dword [esp]
				end
			end
			local bh, bl = K_ZERO, 0
			if nR > 0 then bh, bl = div(K_ONE, 0, nR, 0) end        -- fild n_RF ; fdivr 1.0 (else fld 0.0)
			-- 74c960 = B_RF b + B_LF a (fst), > 1500 -> 1500 (NaN kept)
			local t1h, t1l = mul(bR, 0, bh, bl)
			local t2h, t2l = mul(bL, 0, ah, al)
			local vh, vl = add(t1h, t1l, t2h, t2l)
			wf32(LOAD, f32(vh, vl))
			if (vh > K_LOADMAX or (vh == K_LOADMAX and vl > 0)) and not (mu and mu("noclamp", true)) then w32(LOAD, LOAD_MAX_BITS) end
			-- bf6ec4 = ((1 - l) A_RF) b + (A_LF l) a
			local oh, ol = sub(K_ONE, 0, l, 0)
			local ph, pl = mul(oh, ol, rf32(A_RF), 0)
			ph, pl = mul(ph, pl, bh, bl)
			local qh, ql = mul(rf32(A_LF), 0, l, 0)
			qh, ql = mul(qh, ql, ah, al)
			local slip = f32(add(ph, pl, qh, ql))
			if mu then slip = f32(mu("slip", slip), 0) end
			wf32(SLIP, slip)
			-- bf6ec8 = C_RF b + C_LF a ; bf6ed0 = D_RF b + D_LF a
			ph, pl = mul(rf32(C_RF), 0, bh, bl)
			qh, ql = mul(rf32(C_LF), 0, ah, al)
			wf32(FY, f32(add(ph, pl, qh, ql)))
			ph, pl = mul(rf32(D_RF), 0, bh, bl)
			qh, ql = mul(rf32(D_LF), 0, ah, al)
			local moment = f32(add(ph, pl, qh, ql))
			if mu then moment = f32(mu("moment", moment), 0) end
			wf32(MOMENT, moment)
			-- integer MOV 0 (00554ddf..00554e59)
			w32(N_LF, 0); w32(N_RF, 0); w32(B_LF, 0); w32(B_RF, 0); w32(C_LF, 0); w32(C_RF, 0)
			w32(D_LF, 0); w32(D_RF, 0); w32(A_LF, 0); w32(A_RF, 0)
		end
	end

	---------------------------------------------------------------------------------------------------------
	-- FFB block of the frame end 00554520 (0055464c..0055479d)
	---------------------------------------------------------------------------------------------------------
	local function makeBlock(add, sub, mul, div, f32, mu)
		return function()
			if r8(ACQUIRED) == 0 or r8(SUSPENDED) ~= 0 then return end
			local ec4, ec0 = rf32(SLIP), rf32(PREV)
			local dh, dl = sub(ec4, 0, ec0, 0)                        -- fld ec4 ; fsub ec0
			w32(PREV, r32(SLIP))                                      -- ec0 = ec4 (MOV)
			local d = f32(mul(RATE, 0, dh, dl))                       -- fild rate ; fmulp ; fstp dword [esp]
			local th, tl = add(rf32(AIRSPEED), 0, K_V0, 0)            -- fld airspeed ; fadd 20
			th, tl = div(K_V0, 0, th, tl)                             -- fdivr 20
			th, tl = sub(K_ONE, 0, th, tl)                            -- fsubr 1.0
			local uh, ul = mul(rf32(LATENCY), 0, K_MS, 0)             -- fld latency ; fmul 0.001
			th, tl = mul(th, tl, uh, ul)                              -- fmulp st(1)
			th, tl = mul(th, tl, d, 0)                                -- fmul dword [esp] (d)
			local q = f32(add(th, tl, ec4, 0))                        -- fadd ec4 ; fstp dword [esp+0xc]
			if mu then q = f32(mu("q", q), 0) end
			local mh, ml
			local a = math.abs(ec4)                                   -- and 0x7fffffff
			if not (a < K_EPS or a == K_EPS or a ~= a) then           -- fcomp 1e-5 ; and 0x4100 ; jne
				mh, ml = div(q, 0, ec4, 0)                            -- fld q ; fdiv ec4
				mh, ml = mul(mh, ml, rf32(MOMENT), 0)                 -- fmul ed0
			else
				mh, ml = rf32(MOMENT), 0                              -- fld ed0
			end
			local xh, xl = mul(rf32(DAMPING), 0, d, 0)                -- fld damping ; fmul d
			if mu then xh, xl = mu("damping", xh), 0 end
			local yh, yl = sub(mh, ml, xh, xl)                        -- fsubp st(1)
			yh, yl = add(yh, yl, rf32(FILT), 0)                       -- fadd ecc
			yh, yl = mul(yh, yl, K_HALF, 0)                           -- fmul 0.5
			local ecc = f32(yh, yl)                                   -- fst [esp+0x10] ; fstp ecc
			wf32(FILT, ecc)
			local ratio = rf32(SETUP_RATIO)
			if mu then ratio = mu("ratio", ratio) end
			local rh, rl = mul(ratio, 0, K_SCALE, 0)                  -- fld item 0x30 ; fmul 1600
			rh, rl = div(rf32(STRENGTH), 0, rh, rl)                   -- fdivr strength
			local out = f32(mul(rh, rl, ecc, 0))                      -- fmul ecc ; fstp dword [esp]
			if mu then out = f32(mu("out", out), 0) end
			if K_ONE < out then out = K_ONE                           -- fcomp ; test ah,5 ; jp
			elseif K_MONE > out then out = K_MONE end                 -- fcomp ; and 0x4100 ; jne
			last.block = true
			last.frames += 1
			deviceForce(r32(AXIS), out)                               -- 005d08d0(bf6ebc, out)
		end
	end

	-- the arithmetic of the two routines: exact x87 (production) or, TEST ONLY (V._ffbModel), the IEEE double model of the
	-- Stage 6-12 lifter convention (intermediates in double, round to nearest; f32 stores toward -inf) and a deliberate
	-- mapping error mu(stage, value) -> value (level 5 of tests/stage13)
	local fd = V.fd
	local function dadd(ah, _, bh, _) local r = ah + bh; if r == 0 then return zeroSum(ah, bh), 0 end; return r, 0 end
	local function dsub(ah, _, bh, _) return dadd(ah, 0, -bh, 0) end
	local function dmul(ah, _, bh, _) return ah * bh, 0 end
	local function ddiv(ah, _, bh, _) return ah / bh, 0 end
	local function dstore(h, _) return fd(h) end
	local stats, frameBlock
	local function build(model, mu)
		if model == "double" then
			stats, frameBlock = makeStats(dadd, dsub, dmul, ddiv, dstore, mu), makeBlock(dadd, dsub, dmul, ddiv, dstore, mu)
		else
			stats, frameBlock = makeStats(add, sub, mul, div, f32, mu), makeBlock(add, sub, mul, div, f32, mu)
		end
	end
	build("x87", nil)
	V._ffbModel = function(model, mu) build(model or "x87", mu) end
	V.ffbStatsOriginal = function() stats() end
	V.ffbFrameOriginal = function() frameBlock() end

	-- integration points (NR2003CupDriver.tickInputs @00553a64 / NR2003CupFrame after the lifted 00554520)
	function V._ffbTick() stats() end
	function V._ffbFrameEnd()
		last.block = false
		if r8(SIMULATED) == 0 then return end                     -- 0055452a: whole frame end gated by 00551880
		frameBlock()
	end

	---------------------------------------------------------------------------------------------------------
	-- options (messages 8..11; controls.cfg integers, front-end ranges 0..100 / 0..100 / 0..250)
	---------------------------------------------------------------------------------------------------------
	local options = nil
	local function applyOptions()
		if options == nil then return end
		local o = options
		if o.enabled ~= nil then w8(FF_ON, o.enabled and 1 or 0) end                          -- 00550270
		if o.strength ~= nil then wf32(STRENGTH, math.clamp(floor(o.strength), 0, 100)) end  -- 00550290
		if o.damping ~= nil then wf32(DAMPING, math.clamp(floor(o.damping), 0, 100)) end     -- 005502d0
		if o.latency ~= nil then wf32(LATENCY, math.clamp(floor(o.latency), 0, 250)) end     -- 005502b0
	end
	-- opts: enabled (bool, FF on/off), strength (0..100, image 80), damping (0..100, image 0), latency (ms 0..250,
	-- image 0); nil = keep the image value (no controls.cfg). Values survive reset(). The FF axis is set up again at
	-- once (the front end re-selects the active controls when it returns to the car: 00550070(0)).
	function V.setForceFeedbackOptions(opts)
		opts = opts or {}
		local function range(name, hi)
			local v = opts[name]
			if v ~= nil and not (type(v) == "number" and v >= 0 and v <= hi) then
				error(string.format("NR2003 Stage 13: %s must be a number 0..%d (got %s)", name, hi, tostring(v)))
			end
		end
		range("strength", 100); range("damping", 100); range("latency", 250)
		if opts.enabled ~= nil and type(opts.enabled) ~= "boolean" then error("NR2003 Stage 13: enabled must be a boolean") end
		options = {enabled = opts.enabled, strength = opts.strength, damping = opts.damping, latency = opts.latency}
		applyOptions()
		controls(r8(SUSPENDED))
		return V.forceFeedbackOptions()
	end
	function V.clearForceFeedbackOptions() options = nil end
	function V.forceFeedbackOptions()
		return {enabled = r8(FF_ON) ~= 0, strength = rf32(STRENGTH), damping = rf32(DAMPING), latency = rf32(LATENCY)}
	end
	-- dev: {capable = bool (an FF device is bound to the steering axis: 005d0820), acquire = bool (005d0840 result,
	-- default true), sink = function(axis, force, magnitude) called on every constant-force update}
	function V.setForceFeedbackDevice(dev)
		dev = dev or {}
		local was = device.capable
		device = {capable = dev.capable == true, acquire = dev.acquire ~= false}
		if dev.sink ~= nil then sink = dev.sink end
		if was and not device.capable and r8(ACQUIRED) ~= 0 then  -- device removed: DirectInput loses the effect
			effect = false
		end
		controls(r8(SUSPENDED))
	end
	function V.setForceFeedbackSink(fn) sink = fn end
	-- ORIGINAL 00550070: true = player controls suspended (005524f0 not-driven branch, FFB off, force zeroed)
	function V.setControlsSuspended(flag) controls(flag and 1 or 0) end
	function V.controlsSuspended() return r8(SUSPENDED) ~= 0 end
	-- re-select the active controls (fgmsgSelectActiveControls: 00550070(0) on the current binding)
	function V.selectActiveControls() controls(0) end
	V._ffbControls = controls
	V._ffbDeviceForce = deviceForce
	V._ffbRelease = release
	V._ffbTrace = function(t) trace = t end
	-- TEST ONLY: raw host device state (capable, acquire result, effect acquired = f5d414) without the 00550070 that
	-- setForceFeedbackDevice runs
	V._ffbHostState = function(capable, acquire, eff)
		if capable ~= nil then device = {capable = capable, acquire = acquire ~= false} end
		if eff ~= nil then effect = eff end
		return device.capable, device.acquire, effect
	end

	---------------------------------------------------------------------------------------------------------
	-- lifecycle
	---------------------------------------------------------------------------------------------------------
	-- 00550a50 @00550b07 (car placed on the track): the options are simulation cells that the game keeps across car
	-- placements; the port's reset reloads the image, so they are re-applied first
	function V._ffbEnterTrack()
		applyOptions()
		controls(0)
	end
	local baseReset = V.reset
	function V.reset()
		effect = false                 -- the reloaded image has no acquired effect (bf6ebb 0): host side released
		configuredKind = nil
		last.force, last.magnitude, last.block = 0, 0, false
		baseReset()
		applyOptions()
	end
	-- checkpoint / restore: the host device state goes with the memory (bf6ebb / bf6ebc are in the memory; the effect
	-- acquired by the device layer and the binding type of the last 0054fed0 are host-side)
	local baseCheckpoint, baseRestore = V.checkpoint, V.restore
	function V.checkpoint()
		local c = baseCheckpoint()
		c.ffb = {effect = effect, configuredKind = configuredKind, force = last.force, magnitude = last.magnitude,
			axis = last.axis, block = last.block}
		return c
	end
	function V.restore(c)
		baseRestore(c)
		local h = c.ffb
		if h then
			effect, configuredKind = h.effect, h.configuredKind
			last.force, last.magnitude, last.axis, last.block = h.force, h.magnitude, h.axis, h.block
		end
	end
	if V.endSession then
		local baseEnd = V.endSession
		function V.endSession()
			release()                  -- 00550680 (session end)
			baseEnd()
		end
	end
	-- device layer (ADAPTER): the Roblox host re-binds controls 7 / 8 every frame (NR2003CupSteering.hostDevices); a change
	-- of the control-7 binding type (keys <-> analog axis) is what the game's controls menu + fgmsgSelectActiveControls
	-- produce, followed by 00550070(0). Run only while FF is on or acquired (otherwise 0054fed0 changes nothing
	-- observable but bf6ebc / 74c95c).
	if V._steerDevices then
		local baseDevices = V._steerDevices
		function V._steerDevices(c)
			baseDevices(c)
			if configuredKind ~= ri32(REC7 + 0x10) and (r8(FF_ON) ~= 0 or r8(ACQUIRED) ~= 0) then
				controls(0)
			end
		end
	end

	---------------------------------------------------------------------------------------------------------
	-- observation (original cells)
	---------------------------------------------------------------------------------------------------------
	function V.forceFeedbackState(out)
		out = out or {}
		out.enabled, out.acquired, out.suspended = r8(FF_ON) ~= 0, r8(ACQUIRED) ~= 0, r8(SUSPENDED) ~= 0
		out.effect = effect
		out.axis, out.directionSign = r32(AXIS), ri32(DIRSIGN)
		out.force, out.magnitude = last.force, last.magnitude     -- last constant force sent to the device
		out.blockRan = last.block                                  -- FFB block evaluated in the last frame end
		out.frames, out.calls = last.frames, last.calls
		out.slip, out.moment, out.fy, out.load = rf32(SLIP), rf32(MOMENT), rf32(FY), rf32(LOAD)
		out.previousSlip, out.filtered = rf32(PREV), rf32(FILT)
		out.strength, out.damping, out.latency = rf32(STRENGTH), rf32(DAMPING), rf32(LATENCY)
		out.setupRatio, out.airspeed = rf32(SETUP_RATIO), rf32(AIRSPEED)
		return out
	end
	return V
end
]=])
print("PATCH_STAGE13 parte 1/2 guardada (7 fontes). Próximo: parte 2")
