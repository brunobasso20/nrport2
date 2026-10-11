-- PATCH_STAGE12 — NR2003 Roblox port, estágio 12 (cadeia de direção ORIGINAL do NR2003 Cup)
-- Cole na Command Bar do Studio, FORA do Play, sobre a bancada Stage 11 (ou Insert from File do .rbxmx; ou as partes +
-- INSTALL). O patch NÃO salva o place: salve você mesmo depois de conferir.
-- Novos: Core.NR2003Cup.NR2003CupSteering (00552720 / 00551e80 / 00554fb0 / setters do executável), Roblox.Stage12SelfTest.
-- Alterados (fonte atualizada no lugar, mesma instância): Core.NR2003Cup.NR2003CupDriver, Core.NR2003CupVehicle,
-- Roblox.CupChassisAdapter, Roblox.Cockpit, Roblox.RenderSnapshot, Roblox.RenderPresentation, NR2003Server, NR2003Client;
-- uma linha em Roblox.Stage67/8/9/10/11SelfTest (modo de direção "provisional" das suítes antigas).
-- Segurança: confere o Stage 11 módulo por módulo (tamanho + hash da fonte publicada), backup SÓ do que muda em
-- ServerStorage.NR2003Backup_Stage12 (criado uma vez, nunca sobrescrito), nenhuma pasta é substituída, re-executar é
-- seguro, auto-testes 6/7..12 no fim e reversão automática se algo falhar. Reversão manual: PATCH_STAGE12_ROLLBACK.lua.
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes do patch")
local RS=game:GetService("ReplicatedStorage")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local storage=game:GetService("ServerStorage")
local SES=game:GetService("ScriptEditorService")
local pkg=assert(RS:FindFirstChild("NR2003Lab"),"NR2003Lab ausente: instale a bancada Stage 11 antes")
local stage=pkg:GetAttribute("NR2003Stage")
assert(stage=="11" or stage=="12","este patch exige a bancada Stage 11 (NR2003Stage = "..tostring(stage)..")")
local CoreF=assert(pkg:FindFirstChild("Core"),"NR2003Lab.Core ausente")
local RobloxF=assert(pkg:FindFirstChild("Roblox"),"NR2003Lab.Roblox ausente")
local cupFolder=assert(CoreF:FindFirstChild("NR2003Cup"),"Core.NR2003Cup ausente")
for _,n in ipairs({"NR2003CupCore","NR2003CupFrame","NR2003CupGarage","NR2003CupBuild","NR2003CupAero"}) do
    assert(cupFolder:FindFirstChild(n),"Core.NR2003Cup."..n.." ausente (Stage 11 requerido)")
end
local function setSource(s,src)
    if #src<200000 then s.Source=src else SES:UpdateSourceAsync(s,function() return src end) end
end
-- FNV-1a 32 of the source bytes; h * 0x01000193 mod 2^32 = h * 0x193 + (h mod 256) * 2^24 (exact in double precision)
local function fnv(src)
    local h=0x811c9dc5
    for i=1,#src do
        h=bit32.bxor(h,string.byte(src,i))
        h=(h*0x193+bit32.band(h,0xff)*0x1000000)%4294967296
    end
    return h
end
local FOLDERS={NR2003Cup=cupFolder,Core=CoreF,Roblox=RobloxF,Server=SS,Client=SP}
local function find(folder,name) return FOLDERS[folder]:FindFirstChild(name) end
local ITEMS={}
local function item(folder,name,class,oldLen,oldHash,newLen,newHash,source)
    ITEMS[#ITEMS+1]={folder=folder,name=name,class=class,oldLen=oldLen,oldHash=oldHash,newLen=newLen,newHash=newHash,source=source}
end
local EDITS={}
local function edit(folder,name,oldLine,newLine,oldLen,oldHash,newLen,newHash)
    EDITS[#EDITS+1]={folder=folder,name=name,oldLine=oldLine,newLine=newLine,oldLen=oldLen,oldHash=oldHash,newLen=newLen,newHash=newHash}
end
item("NR2003Cup","NR2003CupDriver","ModuleScript",22394,857451009,25020,1689364345,[=[
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
]=])
item("Core","NR2003CupVehicle","ModuleScript",7925,3736862230,9070,588044759,[=[
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
item("Roblox","CupChassisAdapter","ModuleScript",28501,1352800795,32198,4136930264,[=[
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
        planes={},inContact={},wheelPose={},contactPoints={},scratchPos={0,0,0},scratchRot={1,0,0,0,1,0,0,0,1}},M)
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
        local o=self.core:setSteeringOptions({linearity=num("SteeringLinearity"),momentum=num("SteeringMomentum"),
            lowSpeedOverride=flag("SteeringLowSpeedOverride")})
        self.car:SetAttribute("SteeringLinearityApplied",o.linearity);self.car:SetAttribute("SteeringRateApplied",o.steerRate)
        self.car:SetAttribute("SteeringRatioApplied",o.setupRatio)
        print(string.format("[NR2003 Stage 12] direção original: relação %g:1 (item 0x30), override baixa velocidade %s, linearidade %.2f, taxa %.4f/quadro",
            o.setupRatio,o.lowSpeedOverride and "on" or "off",o.linearity,o.steerRate))
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
        steeringWheelAngle=self:steeringWheelAngle(),steering=self:steeringTelemetry()}
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
item("Roblox","Cockpit","ModuleScript",3958,2216434014,4459,1431653166,[=[
-- Visual steering column + wheel. +Z of the pivot points toward the driver.
-- Positive road steering (right) produces clockwise rotation as seen by driver.
local Config=require(script.Parent.DriverConfig)
local M={}
local function part(parent,name,size,cf,color)
    local p=Instance.new("Part"); p.Name=name; p.Size=size; p.CFrame=cf; p.Color=color
    p.Material=Enum.Material.SmoothPlastic; p.Anchored=false; p.Massless=true
    p.CanCollide=false; p.CanTouch=false; p.CanQuery=false; p.Parent=parent
    return p
end
local function weld(a,b,name,cf,motor)
    local w=Instance.new(motor and "Motor6D" or "Weld"); w.Name=name
    w.Part0=a; w.Part1=b; w.C0=cf; w.C1=CFrame.new(); w.Parent=b
    return w
end
local function vector(values) return Vector3.new(values[1],values[2],values[3]) end
local function rod(parent,anchor,name,a,b,thickness,color)
    local cf=CFrame.lookAt((a+b)*0.5,b)
    local p=part(parent,name,Vector3.new(thickness,thickness,(b-a).Magnitude),anchor.CFrame*cf,color)
    weld(anchor,p,"VisualWeld",cf); return p
end
function M.ensure(car,tune)
    local existing=car:FindFirstChild("Cockpit")
    if existing and existing:FindFirstChild("SteeringPivot") then return existing end
    local m=tune.metresPerStud; local root=car.Chassis; local seat=car.DriverSeat
    local cockpit=existing or Instance.new("Folder"); cockpit.Name="Cockpit"; cockpit.Parent=car
    local wheelCF=seat.CFrame*CFrame.new(vector(Config.wheelOffset)/m)*CFrame.Angles(math.rad(Config.columnTiltDegrees),0,0)
    local base=root.CFrame:ToObjectSpace(wheelCF)
    local pivot=part(cockpit,"SteeringPivot",Vector3.new(0.035,0.035,0.035)/m,wheelCF,Color3.fromRGB(60,65,70))
    pivot.Transparency=1
    weld(root,pivot,"SteeringMotor",base,true)
    pivot:SetAttribute("NeutralCFrame",base)
    local geometry=Instance.new("Folder"); geometry.Name="SteeringWheel"; geometry.Parent=cockpit
    local radius=Config.wheelRadius/m; local thickness=Config.wheelTubeRadius*2/m
    local function point(angle) return Vector3.new(math.sin(angle)*radius,math.cos(angle)*radius,0) end
    for i=1,32 do
        rod(geometry,pivot,"Rim_"..i,point((i-1)*math.pi/16),point(i*math.pi/16),thickness,
            Color3.fromRGB(25,28,31))
    end
    for _,angle in ipairs({math.pi/2,-math.pi/2,math.pi}) do
        rod(geometry,pivot,"Spoke",Vector3.zero,point(angle)*0.88,0.025/m,Color3.fromRGB(160,170,181))
    end
    local hub=part(geometry,"Hub",Vector3.new(0.07,0.07,0.05)/m,wheelCF,Color3.fromRGB(58,65,75))
    weld(pivot,hub,"HubWeld",CFrame.new())
    local markerCF=CFrame.new(0,radius,0.004/m)
    local marker=part(geometry,"CenterStripe",Vector3.new(0.026,0.032,0.038)/m,
        wheelCF*markerCF,Color3.fromRGB(255,190,60)); weld(pivot,marker,"MarkerWeld",markerCF)
    local columnCF=wheelCF*CFrame.new(0,0,-0.15/m)
    local column=part(cockpit,"SteeringColumn",Vector3.new(0.035,0.035,0.30)/m,
        columnCF,Color3.fromRGB(115,125,135))
    weld(root,column,"ColumnMount",root.CFrame:ToObjectSpace(columnCF))
    local camera=Instance.new("Attachment"); camera.Name="CockpitCamera"
    camera.CFrame=CFrame.new(vector(Config.cameraOffset)/m)*CFrame.Angles(math.rad(Config.cameraPitchDegrees),0,0)
    camera.Parent=seat
    local axis=Instance.new("Attachment"); axis.Name="SteeringAxis"; axis.Parent=pivot
    axis.CFrame=CFrame.Angles(0,-math.pi/2,0) -- Attachment.Axis = pivot local +Z
    car:SetAttribute("SteeringRatio",Config.steeringRatio)
    return cockpit
end
function M.angle(roadAngle,tune)
    local ratio=(tune.steering and tune.steering.wheelRatio) or Config.steeringRatio
    return roadAngle*ratio
end
-- Stage 12 (NR2003_CUP): the steering wheel at an angle given directly (rad, + = clockwise seen by the driver),
-- the ORIGINAL 005662d0 angle of the core (setup ratio + low-speed override, +-2.79 rad); no visual multiplier
function M.updateAngle(car,angle)
    local cockpit=car:FindFirstChild("Cockpit")
    local pivot=cockpit and cockpit:FindFirstChild("SteeringPivot")
    if not pivot then return end
    pivot.SteeringMotor.C0=pivot:GetAttribute("NeutralCFrame")*CFrame.Angles(0,0,-angle)
end
function M.update(car,tune,roadAngle)
    local cockpit=car:FindFirstChild("Cockpit")
    local pivot=cockpit and cockpit:FindFirstChild("SteeringPivot")
    if not pivot then return end
    local angle=M.angle(roadAngle,tune)
    pivot.SteeringMotor.C0=pivot:GetAttribute("NeutralCFrame")*CFrame.Angles(0,0,-angle)
end
return M
]=])
item("Roblox","RenderSnapshot","ModuleScript",6072,1355566575,6198,607194288,[=[
-- Presentation-only render snapshot codec + quaternion helpers.
-- Pure Lua apart from Roblox's `buffer` library. It never feeds the authoritative solver.
local M={}
M.VERSION=1
M.WHEELS=4
M.FLAG_TELEPORT=1
M.FLAG_WHEEL_ANGLE=2 -- Stage 12 (NR2003_CUP): 'steer' carries the ORIGINAL steering-wheel angle (005662d0), not a road angle
M.HEADER=76
M.WHEEL_BYTES=32
M.SIZE=M.HEADER+M.WHEELS*M.WHEEL_BYTES -- 204 bytes
local TAU=2*math.pi

local function finite(v) return v==v and v>-math.huge and v<math.huge end
M.finite=finite
function M.wrapPi(a) return (a+math.pi)%TAU-math.pi end
function M.hasFlag(flags,flag) return math.floor((flags or 0)/flag)%2==1 end

-- Layout, little endian:
--  0 u8 version | 1 u8 wheelCount | 2 u16 vehicleId | 4 u16 seq | 6 u16 flags
--  8 u32 tick | 12 f64 serverTime
-- 20 f32 worldPos[3] | 32 f32 quat[4] | 48 f32 linearVel[3] studs/s
-- 60 f32 angularVel[3] world rad/s | 72 f32 roadSteer
-- 76 + wheel*32: f32 compression | f32 steer | f64 unwrappedSpin |
--                 f32 contactLocalXYZ | u8 grounded | 3 bytes padding.
function M.encode(s)
    local b=buffer.create(M.SIZE)
    buffer.writeu8(b,0,M.VERSION);buffer.writeu8(b,1,M.WHEELS)
    buffer.writeu16(b,2,s.vehicleId%65536);buffer.writeu16(b,4,s.seq%65536)
    buffer.writeu16(b,6,s.flags or 0);buffer.writeu32(b,8,s.tick%4294967296)
    buffer.writef64(b,12,s.time)
    buffer.writef32(b,20,s.px);buffer.writef32(b,24,s.py);buffer.writef32(b,28,s.pz)
    buffer.writef32(b,32,s.qx);buffer.writef32(b,36,s.qy);buffer.writef32(b,40,s.qz);buffer.writef32(b,44,s.qw)
    buffer.writef32(b,48,s.lx);buffer.writef32(b,52,s.ly);buffer.writef32(b,56,s.lz)
    buffer.writef32(b,60,s.ax);buffer.writef32(b,64,s.ay);buffer.writef32(b,68,s.az)
    buffer.writef32(b,72,s.steer)
    for j=1,M.WHEELS do
        local w=s.wheels[j];local o=M.HEADER+(j-1)*M.WHEEL_BYTES
        buffer.writef32(b,o,w.comp);buffer.writef32(b,o+4,w.steer);buffer.writef64(b,o+8,w.spin)
        buffer.writef32(b,o+16,w.cx);buffer.writef32(b,o+20,w.cy);buffer.writef32(b,o+24,w.cz)
        buffer.writeu8(b,o+28,w.grounded and 1 or 0)
    end
    return b
end

function M.decode(b)
    if type(b)~="buffer" then return nil,"not a buffer" end
    if buffer.len(b)<M.SIZE then return nil,"short packet" end
    if buffer.readu8(b,0)~=M.VERSION then return nil,"version" end
    if buffer.readu8(b,1)~=M.WHEELS then return nil,"wheel count" end
    local s={vehicleId=buffer.readu16(b,2),seq=buffer.readu16(b,4),flags=buffer.readu16(b,6),
        tick=buffer.readu32(b,8),time=buffer.readf64(b,12),
        px=buffer.readf32(b,20),py=buffer.readf32(b,24),pz=buffer.readf32(b,28),
        qx=buffer.readf32(b,32),qy=buffer.readf32(b,36),qz=buffer.readf32(b,40),qw=buffer.readf32(b,44),
        lx=buffer.readf32(b,48),ly=buffer.readf32(b,52),lz=buffer.readf32(b,56),
        ax=buffer.readf32(b,60),ay=buffer.readf32(b,64),az=buffer.readf32(b,68),
        steer=buffer.readf32(b,72),wheels={}}
    for _,k in ipairs({"time","px","py","pz","qx","qy","qz","qw","lx","ly","lz","ax","ay","az","steer"}) do
        if not finite(s[k]) then return nil,"non-finite "..k end
    end
    local n=math.sqrt(s.qx*s.qx+s.qy*s.qy+s.qz*s.qz+s.qw*s.qw)
    if n<0.5 or n>1.5 then return nil,"bad quaternion" end
    s.qx,s.qy,s.qz,s.qw=s.qx/n,s.qy/n,s.qz/n,s.qw/n
    for j=1,M.WHEELS do
        local o=M.HEADER+(j-1)*M.WHEEL_BYTES
        local w={comp=buffer.readf32(b,o),steer=buffer.readf32(b,o+4),spin=buffer.readf64(b,o+8),
            cx=buffer.readf32(b,o+16),cy=buffer.readf32(b,o+20),cz=buffer.readf32(b,o+24),
            grounded=buffer.readu8(b,o+28)~=0}
        for _,k in ipairs({"comp","steer","spin","cx","cy","cz"}) do
            if not finite(w[k]) then return nil,"non-finite wheel "..k end
        end
        s.wheels[j]=w
    end
    return s
end

-- CFrame rotation-matrix order -> unit quaternion (Shepperd).
function M.quatFromMatrix(m00,m01,m02,m10,m11,m12,m20,m21,m22)
    local x,y,z,w;local tr=m00+m11+m22
    if tr>0 then
        local s=math.sqrt(tr+1)*2;w=0.25*s;x=(m21-m12)/s;y=(m02-m20)/s;z=(m10-m01)/s
    elseif m00>m11 and m00>m22 then
        local s=math.sqrt(1+m00-m11-m22)*2;w=(m21-m12)/s;x=0.25*s;y=(m01+m10)/s;z=(m02+m20)/s
    elseif m11>m22 then
        local s=math.sqrt(1+m11-m00-m22)*2;w=(m02-m20)/s;x=(m01+m10)/s;y=0.25*s;z=(m12+m21)/s
    else
        local s=math.sqrt(1+m22-m00-m11)*2;w=(m10-m01)/s;x=(m02+m20)/s;y=(m12+m21)/s;z=0.25*s
    end
    local n=math.sqrt(x*x+y*y+z*z+w*w)
    return x/n,y/n,z/n,w/n
end
function M.quatToMatrix(x,y,z,w)
    local xx,yy,zz=x*x,y*y,z*z;local xy,xz,yz=x*y,x*z,y*z;local wx,wy,wz=w*x,w*y,w*z
    return 1-2*(yy+zz),2*(xy-wz),2*(xz+wy),
        2*(xy+wz),1-2*(xx+zz),2*(yz-wx),
        2*(xz-wy),2*(yz+wx),1-2*(xx+yy)
end
function M.slerp(ax,ay,az,aw,bx,by,bz,bw,t,out)
    local d=ax*bx+ay*by+az*bz+aw*bw
    if d<0 then bx,by,bz,bw,d=-bx,-by,-bz,-bw,-d end
    d=math.max(-1,math.min(1,d))
    local sa,sb
    if d>0.9995 then sa,sb=1-t,t
    else local theta=math.acos(d);local st=math.sin(theta);sa=math.sin((1-t)*theta)/st;sb=math.sin(t*theta)/st end
    local x,y,z,w=sa*ax+sb*bx,sa*ay+sb*by,sa*az+sb*bz,sa*aw+sb*bw
    local n=math.sqrt(x*x+y*y+z*z+w*w);out.x,out.y,out.z,out.w=x/n,y/n,z/n,w/n
    return out
end
-- Angular velocity is world-frame, matching CoreChassisAdapter:kinematics().
function M.integrate(qx,qy,qz,qw,wx,wy,wz,dt,out)
    local mag=math.sqrt(wx*wx+wy*wy+wz*wz);local angle=mag*dt;local dx,dy,dz,dw
    if angle<1e-9 then dx,dy,dz,dw=0,0,0,1
    else local s=math.sin(angle*0.5)/mag;dx,dy,dz,dw=wx*s,wy*s,wz*s,math.cos(angle*0.5) end
    local x=dw*qx+dx*qw+dy*qz-dz*qy
    local y=dw*qy-dx*qz+dy*qw+dz*qx
    local z=dw*qz+dx*qy-dy*qx+dz*qw
    local w=dw*qw-dx*qx-dy*qy-dz*qz
    local n=math.sqrt(x*x+y*y+z*z+w*w);out.x,out.y,out.z,out.w=x/n,y/n,z/n,w/n
    return out
end
-- The physics wheel angle is wrapped to [0,2pi). Use omega to select the correct turn count.
function M.unwrapSpin(previous,wrapped,omega,dt)
    if previous==nil or not finite(previous) or not finite(dt) or dt<=0 or dt>0.25 then return wrapped end
    local predicted=previous+omega*dt
    return predicted+M.wrapPi(wrapped-predicted)
end
return M
]=])
item("Roblox","RenderPresentation","ModuleScript",2853,417927731,2986,27795961,[=[
-- Client-only presentation layer for the server-authoritative NR2003_CORE vehicle.
-- It locally overrides the already replicated anchored car immediately before camera/render.
-- No rendered state is sent back to the server or consumed by physics.
local RunService=game:GetService("RunService")
local Snap=require(script.Parent.RenderSnapshot)
local Buffer=require(script.Parent.SnapshotBuffer)
local Visual=require(script.Parent.VisualRig)
local Cockpit=require(script.Parent.Cockpit)
local Config=require(script.Parent.RenderConfig)
local M={};M.__index=M
local function cframeFromSnapshot(s)
    local r00,r01,r02,r10,r11,r12,r20,r21,r22=Snap.quatToMatrix(s.qx,s.qy,s.qz,s.qw)
    return CFrame.new(s.px,s.py,s.pz,r00,r01,r02,r10,r11,r12,r20,r21,r22)
end
function M.new(car,tune,remote)
    local self=setmetatable({car=car,tune=tune,remote=remote,buffer=Buffer.new(Config.buffer),sampled={wheels={}},
        visual=Visual.new(car,tune),dynamics={wheels={}},contacts={},active=false,frames=0,fps=0,fpsClock=os.clock()},M)
    for j=1,4 do self.dynamics.wheels[j]={compression=0,steer=0,angle=0};self.contacts[j]={point=Vector3.zero,grounded=false} end
    self.connection=remote.OnClientEvent:Connect(function(packet)
        local s=Snap.decode(packet);if not s or s.vehicleId~=Config.vehicleId then return end
        self.buffer:push(s,workspace:GetServerTimeNow())
    end)
    return self
end
function M:update()
    self.frames=self.frames+1;local clock=os.clock();local span=clock-self.fpsClock
    if span>=0.5 then self.fps=self.frames/span;self.frames=0;self.fpsClock=clock end
    if not Config.enabled or self.car:GetAttribute("NR2003CorePoseOwner")~=true then self.active=false;return false end
    local now=workspace:GetServerTimeNow()
    if self.buffer:isStale(now) then self.active=false;return false end
    local renderTime=self.buffer:advance(now);if not renderTime then self.active=false;return false end
    local s=self.buffer:sample(renderTime,self.sampled);if not s then self.active=false;return false end
    local cf=cframeFromSnapshot(s)
    self.car:PivotTo(cf)
    for j,w in ipairs(s.wheels) do
        local d=self.dynamics.wheels[j];d.compression,d.steer,d.angle=w.comp,w.steer,w.spin
        local c=self.contacts[j];c.point=cf:PointToWorldSpace(Vector3.new(w.cx,w.cy,w.cz));c.grounded=w.grounded
    end
    self.dynamics.steering=s.steer
    self.visual:update(self.dynamics,self.contacts,self.car:GetAttribute("DebugContacts")==true)
    if self.car:GetAttribute("CockpitWheelAngle")==true then Cockpit.updateAngle(self.car,s.steer) -- Stage 12 (NR2003_CUP)
    else Cockpit.update(self.car,self.tune,s.steer) end
    self.active=true;return true
end
function M:stats()
    local s=self.buffer:stats();s.renderFPS=self.fps;s.active=self.active;s.mode=self.sampled.mode or "waiting";s.alpha=self.sampled.alpha or 0
    return s
end
function M:destroy() if self.connection then self.connection:Disconnect();self.connection=nil end end
return M
]=])
item("Server","NR2003Server","Script",4009,1117744807,4742,3952310422,[=[
local RS=game:GetService("ReplicatedStorage")
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local package=RS:WaitForChild("NR2003Lab")
local Tune=require(package.Core.TestTune)
local Builder=require(package.Roblox.CarBuilder)
local Mode=require(package.Roblox.ModeConfig)
local RenderConfig=require(package.Roblox.RenderConfig)
local RenderSnapshot=require(package.Roblox.RenderSnapshot)
local U=require(package.Core.MathUtil)
local tune=Tune.new(); local world=workspace:FindFirstChild("NR2003LabWorld")
if not world then
    world=Instance.new("Folder"); world.Name="NR2003LabWorld"; world.Parent=workspace; Builder.makeTrack(world)
end
local car=world:FindFirstChild("TestCar") or Builder.create(world,Builder.spawnCFrame(tune),tune)
local remote=package:WaitForChild("Input"); local telemetry=package:WaitForChild("Telemetry")
local renderState=package:WaitForChild("RenderState")
local controller
if Mode.mode=="ROBLOX_ADAPTER" then
    controller=require(package.Roblox.LegacyRobloxAdapter).new(car,tune,remote)
elseif Mode.mode=="NR2003_CORE" then
    controller=require(package.Roblox.CoreChassisAdapter).new(car,tune,remote)
elseif Mode.mode=="NR2003_CUP" then
    -- Stage 6/7: original NR2003 Cup 45-state core (Core.NR2003Cup); Roblox = contact/presentation host
    controller=require(package.Roblox.CupChassisAdapter).new(car,tune,remote)
else error("Unknown NR2003 mode: "..tostring(Mode.mode)) end
-- Stage 12: only the Cup core sends the ORIGINAL steering-wheel angle in the render snapshots
car:SetAttribute("CockpitWheelAngle",Mode.mode=="NR2003_CUP")
local input={throttle=0,brake=1,steer=0,handbrake=0,clutch=1}
local lastInput,lastAction=0,0; local lastDriver=nil; local packetTimes={}
local renderInterval=1/RenderConfig.snapshotHz;local renderAccumulator=renderInterval;local renderSeq=0
remote.OnServerEvent:Connect(function(player,message)
    if type(message)~="table" then return end
    if message.kind=="enter" then controller:requestEntry(player);return end
    if player~=controller:driver() then return end
    local now=os.clock()
    if message.kind=="input" then
        if now-(packetTimes[player] or 0)<1/tune.adapter.maxPacketHz then return end
        packetTimes[player]=now
        for _,key in ipairs({"throttle","brake","steer","handbrake","clutch"}) do
            if not U.finite(message[key]) then return end
        end
        for _,key in ipairs({"throttle","brake","steer","handbrake","clutch"}) do
            input[key]=U.clamp(message[key],key=="steer" and -1 or 0,1)
        end
        -- Stage 12 (NR2003_CUP): raw steering controls of the client device layer (optional; the legacy
        -- 'steer' keeps the Stage 5 modes working): keys steerLeft/steerRight 0..1, analog steerAxis -1..1
        input.steerLeft=U.finite(message.steerLeft) and U.clamp(message.steerLeft,0,1) or nil
        input.steerRight=U.finite(message.steerRight) and U.clamp(message.steerRight,0,1) or nil
        input.steerAxis=U.finite(message.steerAxis) and U.clamp(message.steerAxis,-1,1) or nil
        input.steerAnalog=message.steerAnalog==true and input.steerAxis~=nil
        lastInput=now
    elseif now-lastAction>0.15 then
        if message.kind=="shift" and U.finite(message.delta) then controller:shift(message.delta)
        elseif message.kind=="reset" then controller:reset()
        elseif message.kind=="debug" then controller.debugVisible=not controller.debugVisible;car:SetAttribute("DebugContacts",controller.debugVisible)
        elseif message.kind=="exit" then controller:exit(player) end
        lastAction=now
    end
end)
Players.PlayerRemoving:Connect(function(player) packetTimes[player]=nil end)
RunService.PreSimulation:Connect(function(dt)
    local driver=controller:driver()
    if driver~=lastDriver then lastInput=0; lastDriver=driver end
    if not driver or os.clock()-lastInput>tune.adapter.inputTimeout then
        input={throttle=0,brake=1,steer=0,handbrake=0,clutch=1}
    end
    controller:step(dt,input)
    if RenderConfig.enabled and controller.renderSnapshot then
        renderAccumulator=renderAccumulator+dt
        if renderAccumulator>=renderInterval then
            renderAccumulator=renderAccumulator%renderInterval
            renderSeq=(renderSeq+1)%65536
            local snapshot=controller:renderSnapshot(renderSeq,workspace:GetServerTimeNow(),RenderConfig.vehicleId)
            renderState:FireAllClients(RenderSnapshot.encode(snapshot))
        end
    end
    if driver and controller.telemetryTimer>=1/tune.adapter.telemetryHz then
        controller.telemetryTimer=0; telemetry:FireClient(driver,controller:telemetry())
    end
end)
script.Destroying:Connect(function() controller:destroy() end)
]=])
item("Client","NR2003Client","LocalScript",14210,2653526811,15936,3687068143,[=[
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local CAS=game:GetService("ContextActionService")
local UIS=game:GetService("UserInputService")
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
local hint=label(panel,"Controls",265,50,11)
hint.Text="W/S acelerar/frear   A/D direção (gamepad: analógico esquerdo)   E/Q marchas\nShift embreagem   Espaço freio de mão   X sair\nT painel   G contatos   H render diag   V câmera   R reposicionar"
local status=label(panel,"Status",314,16,11);status.Text="Tune de teste | contato por raycast"
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
        steerLine.Text=string.format("DIREÇÃO %s  entrada %+.3f  relação %.1f:1  alvo %+.2f°  cubos %+.2f/%+.2f°  rodas %+.2f°  volante %+.0f°",
            sd.digital and "teclas" or "eixo",sd.input or 0,sd.ratioNow or 0,math.deg(sd.target or 0),math.deg(sd.hubLF or 0),math.deg(sd.hubRF or 0),
            math.deg(data.roadWheelAngle or 0),math.deg(data.steeringWheelAngle or 0))
    else steerLine.Text="" end
    if data.mode=="NR2003_CUP" then
        status.Text=data.fault and "Física pausada; veja Output. R reinicia." or string.format("acel %.2f | pedal freio %.2f -> núcleo %.2f | viés %d%% | embr %.2f | lim %s%s",
            data.throttleIn or 0,data.brakePedal or 0,data.brakeCore or data.brakeIn or 0,data.brakeBias or 74,data.clutchIn or 0,data.limiter and "ON" or "off",data.collision and " | colisão" or "")
    else
        status.Text=data.fault and "Física pausada; veja Output. R reinicia." or string.format("Motor %.0f Nm | embreagem Δ %.0f rad/s",data.torque,data.clutchSlip)
    end
end)
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
            unbind();renderDiag=false;renderInfo.Visible=false
            if savedCameraType then workspace.CurrentCamera.CameraType=savedCameraType end
            if savedCameraSubject and savedCameraSubject.Parent then workspace.CurrentCamera.CameraSubject=savedCameraSubject end
            if savedFieldOfView then workspace.CurrentCamera.FieldOfView=savedFieldOfView end
        end
    end
    updateRenderDiag(dt)
    if not driving then return end
    header.Visible=expanded;for _,r in ipairs(rows) do r.Visible=expanded end
    aeroLine.Visible=expanded;s11Line.Visible=expanded;steerLine.Visible=expanded
    hint.Visible=expanded;status.Visible=expanded;panel.Size=UDim2.fromOffset(600,expanded and 334 or 76)
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
    RunService:UnbindFromRenderStep(renderName);presentation:destroy();unbind()
end)
]=])
item("NR2003Cup","NR2003CupSteering","ModuleScript",nil,nil,19075,2934930772,[=[
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
--     yaw-rate limiter (race settings +0x4c bit 25 = driving mode ARCADE, player.ini DrivingMode, 0055a770):
--       (min(12.25 / v, |r|) / max(|r|, 0.01)) * 0.9 + 0.1 ; arcade also remaps L (00552410) and selects car chassis
--       spec 0 at build time (004233a0) -> NOT PORTED as a production option (validation only, see setSteeringOptions)
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
	-- driver options (simulation-side setters reached through the front-end messages: table 00752370, dispatcher 005bad80 drained on the simulation task)
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
	-- momentum 0..100, 0 = no slew limit), lowSpeedOverride (bool), assist (0..100: only 0 is accepted, see
	-- steerInput). Values survive reset(); nil options = the image values (no message).
	-- yawLimiter = race settings +0x4c bit 25, the session option DrivingMode = ARCADE (player.ini, default Simulation):
	-- besides the 00552720 limiter and the 00552410 remap, arcade makes 004233a0 select car chassis spec 0 (8945b8)
	-- instead of the Cup spec (7238e0) when the car is built -- not recovered / not ported. Bit 25 on the Cup spec is a
	-- combination the original never runs, so yawLimiter = true is refused unless `validation` is true (the tests use
	-- it to compare the 00552720 / 00552410 bit-25 branch with the Unicorn reference, which sets the same bit).
	function V.setSteeringOptions(opts, validation)
		opts = opts or {}
		if opts.assist ~= nil and (tonumber(opts.assist) or 0) ~= 0 then
			error("NR2003 Stage 12: steering assistance > 0 needs the NR2003 track racing line: not ported")
		end
		if opts.yawLimiter == true and validation ~= true then
			error("NR2003 Stage 12: arcade driving mode (race settings bit 25) also selects car chassis spec 0 at build (004233a0): not ported")
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
			drivingMode = settingsBit25() and "arcade" or "simulation",
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
]=])
item("Roblox","Stage12SelfTest","ModuleScript",nil,nil,191114,1712048471,[=[
-- Stage 12 Studio self-test (edit mode or Play, server side). Golden values embedded below were produced by the
-- ORIGINAL NR2003.exe code executed in Unicorn (recovery/stage12: gen_units12.py / gen_fixtures12.py):
--   require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage12SelfTest).run()      -- quick (~2-4 s)
--   require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage12SelfTest).run(true)  -- + all embedded snapshots, determinism
-- What it checks (subset of tests/stage12/run.luau): the ORIGINAL steering functions vector by vector (00552d00,
-- 00552720, 00554fb0, the 00551e80 tail, the option setters), frame starts loaded from the original's traced state
-- compared bit for bit, full lock at rest (pi / 7 with the low-speed override), options / garage ratio survive reset,
-- steering assistance refused, the provisional mode kept for the Stage 6-11 suites only.
local Core=script.Parent.Parent.Core
local Vehicle=require(Core.NR2003CupVehicle)
local G={["axis"]={{7,0,true,0,1023879938,0.0,0,0},{7,0,true,1008981770,1023879938,0.0,0,0},{7,0,true,1050253722,1023879938,0.3350405060278411,1051429485,1046394962},{7,0,true,1058642330,1023879938,0.7262748295590242,1060760869,1057258209},{7,0,true,1065353216,1023879938,0.9916148703948507,1065212536,1063969095},{7,1008981770,true,0,1023879938,0.015707316960754142,1015065761,1008981770},{7,1008981770,true,1008981770,1023879938,0.015707316960754142,1015065761,1008981770},{7,1008981770,true,1050253722,1023879938,0.3350405060278411,1051429485,1046394962},{7,1008981770,true,1058642330,1023879938,0.7262748295590242,1060760869,1057258209},{7,1008981770,true,1065353216,1023879938,0.9916148703948507,1065212536,1063969095},{7,1019517862,true,0,1023879938,0.037690182997372555,1025138949,1019517862},{7,1019517862,true,1008981770,1023879938,0.037690182997372555,1025138949,1019517862},{7,1019517862,true,1050253722,1023879938,0.3350405060278411,1051429485,1046394962},{7,1019517862,true,1058642330,1023879938,0.7262748295590242,1060760869,1057258209},{7,1019517862,true,1065353216,1023879938,0.9916148703948507,1065212536,1063969095},{7,1020054733,true,0,1023879938,0.039259816343760946,1025560294,1020054733},{7,1020054733,true,1008981770,1023879938,0.039259816343760946,1025560294,1020054733},{7,1020054733,true,1050253722,1023879938,0.40721493594121494,1053851257,1049146425},{7,1020054733,true,1058642330,1023879938,0.7774753900281992,1061619872,1058088681},{7,1020054733,true,1065353216,1023879938,0.9986568009204606,1065330680,1064799567},{7,1020591604,true,0,1023879938,0.040829352820423465,1025981613,1020591604},{7,1020591604,true,1008981770,1023879938,0.040829352820423465,1025981613,1020591604},{7,1020591604,true,1050253722,1023879938,0.40721493594121494,1053851257,1049146425},{7,1020591604,true,1058642330,1023879938,0.7774753900281992,1061619872,1058088681},{7,1020591604,true,1065353216,1023879938,0.9986568009204606,1065330680,1064799567},{7,1048576000,true,0,1023879938,0.0518130676105279,1028930032,1023879938},{7,1048576000,true,1008981770,1023879938,0.06749289446831619,1032468918,1026564292},{7,1048576000,true,1050253722,1023879938,0.40721493594121494,1053851257,1049146425},{7,1048576000,true,1058642330,1023879938,0.7774753900281992,1061619872,1058088681},{7,1048576000,true,1065353216,1023879938,0.9986568009204606,1065330680,1064799567},{7,1056964608,true,0,1023879938,0.0518130676105279,1028930032,1023879938},{7,1056964608,true,1008981770,1023879938,0.06749289446831619,1032468918,1026564292},{7,1056964608,true,1050253722,1023879938,0.49954649761867564,1056949390,1051361018},{7,1056964608,true,1058642330,1023879938,0.7774753900281992,1061619872,1058088681},{7,1056964608,true,1065353216,1023879938,0.9986568009204606,1065330680,1064799567},{7,1061158912,true,0,1023879938,0.0518130676105279,1028930032,1023879938},{7,1061158912,true,1008981770,1023879938,0.06749289446831619,1032468918,1026564292},{7,1061158912,true,1050253722,1023879938,0.49954649761867564,1056949390,1051361018},{7,1061158912,true,1058642330,1023879938,0.8383853009235582,1062641771,1059195978},{7,1061158912,true,1065353216,1023879938,0.9986568009204606,1065330680,1064799567},{7,1065185444,true,0,1023879938,0.0518130676105279,1028930032,1023879938},{7,1065185444,true,1008981770,1023879938,0.06749289446831619,1032468918,1026564292},{7,1065185444,true,1050253722,1023879938,0.49954649761867564,1056949390,1051361018},{7,1065185444,true,1058642330,1023879938,0.8383853009235582,1062641771,1059195978},{7,1065185444,true,1065353216,1023879938,0.9998766327169457,1065351146,1065185444},{7,1065353216,true,0,1023879938,0.0518130676105279,1028930032,1023879938},{7,1065353216,true,1008981770,1023879938,0.06749289446831619,1032468918,1026564292},{7,1065353216,true,1050253722,1023879938,0.49954649761867564,1056949390,1051361018},{7,1065353216,true,1058642330,1023879938,0.8383853009235582,1062641771,1059195978},{7,1065353216,true,1065353216,1023879938,1.0,1065353215,1065353216},{8,0,true,0,1023879938,0.0,0,0},{8,0,true,1008981770,1023879938,0.0,0,0},{8,0,true,1050253722,1023879938,0.3350405060278411,1051429485,1046394962},{8,0,true,1058642330,1023879938,0.7262748295590242,1060760869,1057258209},{8,0,true,1065353216,1023879938,0.9916148703948507,1065212536,1063969095},{8,1008981770,true,0,1023879938,0.015707316960754142,1015065761,1008981770},{8,1008981770,true,1008981770,1023879938,0.015707316960754142,1015065761,1008981770},{8,1008981770,true,1050253722,1023879938,0.3350405060278411,1051429485,1046394962},{8,1008981770,true,1058642330,1023879938,0.7262748295590242,1060760869,1057258209},{8,1008981770,true,1065353216,1023879938,0.9916148703948507,1065212536,1063969095},{8,1019517862,true,0,1023879938,0.037690182997372555,1025138949,1019517862},{8,1019517862,true,1008981770,1023879938,0.037690182997372555,1025138949,1019517862},{8,1019517862,true,1050253722,1023879938,0.3350405060278411,1051429485,1046394962},{8,1019517862,true,1058642330,1023879938,0.7262748295590242,1060760869,1057258209},{8,1019517862,true,1065353216,1023879938,0.9916148703948507,1065212536,1063969095},{8,1020054733,true,0,1023879938,0.039259816343760946,1025560294,1020054733},{8,1020054733,true,1008981770,1023879938,0.039259816343760946,1025560294,1020054733},{8,1020054733,true,1050253722,1023879938,0.40721493594121494,1053851257,1049146425},{8,1020054733,true,1058642330,1023879938,0.7774753900281992,1061619872,1058088681},{8,1020054733,true,1065353216,1023879938,0.9986568009204606,1065330680,1064799567},{8,1020591604,true,0,1023879938,0.040829352820423465,1025981613,1020591604},{8,1020591604,true,1008981770,1023879938,0.040829352820423465,1025981613,1020591604},{8,1020591604,true,1050253722,1023879938,0.40721493594121494,1053851257,1049146425},{8,1020591604,true,1058642330,1023879938,0.7774753900281992,1061619872,1058088681},{8,1020591604,true,1065353216,1023879938,0.9986568009204606,1065330680,1064799567},{8,1048576000,true,0,1023879938,0.0518130676105279,1028930032,1023879938},{8,1048576000,true,1008981770,1023879938,0.06749289446831619,1032468918,1026564292},{8,1048576000,true,1050253722,1023879938,0.40721493594121494,1053851257,1049146425},{8,1048576000,true,1058642330,1023879938,0.7774753900281992,1061619872,1058088681},{8,1048576000,true,1065353216,1023879938,0.9986568009204606,1065330680,1064799567},{8,1056964608,true,0,1023879938,0.0518130676105279,1028930032,1023879938},{8,1056964608,true,1008981770,1023879938,0.06749289446831619,1032468918,1026564292},{8,1056964608,true,1050253722,1023879938,0.49954649761867564,1056949390,1051361018},{8,1056964608,true,1058642330,1023879938,0.7774753900281992,1061619872,1058088681},{8,1056964608,true,1065353216,1023879938,0.9986568009204606,1065330680,1064799567},{8,1061158912,true,0,1023879938,0.0518130676105279,1028930032,1023879938},{8,1061158912,true,1008981770,1023879938,0.06749289446831619,1032468918,1026564292},{8,1061158912,true,1050253722,1023879938,0.49954649761867564,1056949390,1051361018},{8,1061158912,true,1058642330,1023879938,0.8383853009235582,1062641771,1059195978},{8,1061158912,true,1065353216,1023879938,0.9986568009204606,1065330680,1064799567},{8,1065185444,true,0,1023879938,0.0518130676105279,1028930032,1023879938},{8,1065185444,true,1008981770,1023879938,0.06749289446831619,1032468918,1026564292},{8,1065185444,true,1050253722,1023879938,0.49954649761867564,1056949390,1051361018},{8,1065185444,true,1058642330,1023879938,0.8383853009235582,1062641771,1059195978},{8,1065185444,true,1065353216,1023879938,0.9998766327169457,1065351146,1065185444},{8,1065353216,true,0,1023879938,0.0518130676105279,1028930032,1023879938},{8,1065353216,true,1008981770,1023879938,0.06749289446831619,1032468918,1026564292},{8,1065353216,true,1050253722,1023879938,0.49954649761867564,1056949390,1051361018},{8,1065353216,true,1058642330,1023879938,0.8383853009235582,1062641771,1059195978},{8,1065353216,true,1065353216,1023879938,1.0,1065353215,1065353216},{7,0,true,1059061760,1048576000,-0.0,2147483648,2147483648}},["input"]={{0,0,0,0,3212836864,1,3212836864},{0,0,0,1,0,1,2147483648},{0,0,1045220557,0,1065353216,1,1065353215},{0,0,1061997773,0,3156465418,1,3156465418},{0,0,1061997773,1,1061158912,1,1061158910},{0,0,1065353216,1,3196059648,1,3196059647},{0,994352038,0,0,1056964608,1,1056964608},{0,994352038,1045220557,0,3204448256,1,3204448255},{0,994352038,1045220557,1,1048576000,1,1048575998},{0,994352038,1061997773,1,3208642560,1,3208642560},{0,994352038,1065353216,0,1008981770,1,1008981769},{0,3192704205,0,0,3212836864,1,3212836864},{0,3192704205,0,1,0,1,2147483648},{0,3192704205,1045220557,0,1065353216,1,1065353215},{0,3192704205,1061997773,0,3156465418,1,3156465418},{0,3192704205,1061997773,1,1061158912,1,1061158910},{0,3192704205,1065353216,1,3196059648,1,3196059647},{0,1069547520,0,0,1056964608,1,1056964608},{0,1069547520,1045220557,0,3204448256,1,3204448255},{0,1069547520,1045220557,1,1048576000,1,1048575998},{0,1069547520,1061997773,1,3208642560,1,3208642560},{0,1069547520,1065353216,0,1008981770,1,1008981769},{998445679,0,0,0,3212836864,1,3212836864},{998445679,0,0,1,0,1,2147483648},{998445679,0,1045220557,0,1065353216,1,1065353215},{998445679,0,1061997773,0,3156465418,1,3156465418},{998445679,0,1061997773,1,1061158912,1,1061158910},{998445679,0,1065353216,1,3196059648,1,3196059647},{998445679,994352038,0,0,1056964608,1,1056964608},{998445679,994352038,1045220557,0,3204448256,1,3204448255},{998445679,994352038,1045220557,1,1048576000,1,1048575998},{998445679,994352038,1061997773,1,3208642560,1,3208642560},{998445679,994352038,1065353216,0,1008981770,1,1008981769},{998445679,3192704205,0,0,3212836864,1,3212836864},{998445679,3192704205,0,1,0,1,2147483648},{998445679,3192704205,1045220557,0,1065353216,1,1065353215},{998445679,3192704205,1061997773,0,3156465418,1,3156465418},{998445679,3192704205,1061997773,1,1061158912,1,1061158910},{998445679,3192704205,1065353216,1,3196059648,1,3196059647},{998445679,1069547520,0,0,1056964608,1,1056964608},{998445679,1069547520,1045220557,0,3204448256,1,3204448255},{998445679,1069547520,1045220557,1,1048576000,1,1048575998},{998445679,1069547520,1061997773,1,3208642560,1,3208642560},{998445679,1069547520,1065353216,0,1008981770,1,1008981769},{1008981770,0,0,0,3212836864,1,3212836864},{1008981770,0,0,1,0,1,2147483648},{1008981770,0,1045220557,0,1065353216,1,1065353215},{1008981770,0,1061997773,0,3156465418,1,3156465418},{1008981770,0,1061997773,1,1061158912,1,1061158910},{1008981770,0,1065353216,1,3196059648,1,3196059647},{1008981770,994352038,0,0,1056964608,1,1056964608},{1008981770,994352038,1045220557,0,3204448256,1,3204448255},{1008981770,994352038,1045220557,1,1048576000,1,1048575998},{1008981770,994352038,1061997773,1,3208642560,1,3208642560},{1008981770,994352038,1065353216,0,1008981770,1,1008981769},{1008981770,3192704205,0,0,3212836864,1,3212836864},{1008981770,3192704205,0,1,0,1,2147483648},{1008981770,3192704205,1045220557,0,1065353216,1,1065353215},{1008981770,3192704205,1061997773,0,3156465418,1,3156465418},{1008981770,3192704205,1061997773,1,1061158912,1,1061158910},{1008981770,3192704205,1065353216,1,3196059648,1,3196059647},{1008981770,1069547520,0,0,1056964608,1,1056964608},{1008981770,1069547520,1045220557,0,3204448256,1,3204448255},{1008981770,1069547520,1045220557,1,1048576000,1,1048575998},{1008981770,1069547520,1061997773,1,3208642560,1,3208642560},{1008981770,1069547520,1065353216,0,1008981770,1,1008981769},{1056964608,0,0,0,3212836864,1,3212836864},{1056964608,0,0,1,0,1,2147483648},{1056964608,0,1045220557,0,1065353216,1,1065353153},{1056964608,0,1061997773,0,3156465418,1,3156465259},{1056964608,0,1061997773,1,1061158912,1,1061158708},{1056964608,0,1065353216,1,3196059648,1,3196059337},{1056964608,994352038,0,0,1056964608,1,1056964608},{1056964608,994352038,1045220557,0,3204448256,1,3204448193},{1056964608,994352038,1045220557,1,1048576000,1,1048575852},{1056964608,994352038,1061997773,1,3208642560,1,3208642358},{1056964608,994352038,1065353216,0,1008981770,1,1008981570},{1056964608,3192704205,0,0,3212836864,1,3212836864},{1056964608,3192704205,0,1,0,1,2147483648},{1056964608,3192704205,1045220557,0,1065353216,1,1065353153},{1056964608,3192704205,1061997773,0,3156465418,1,3156465259},{1056964608,3192704205,1061997773,1,1061158912,1,1061158708},{1056964608,3192704205,1065353216,1,3196059648,1,3196059337},{1056964608,1069547520,0,0,1056964608,1,1056964608},{1056964608,1069547520,1045220557,0,3204448256,1,3204448193},{1056964608,1069547520,1045220557,1,1048576000,1,1048575852},{1056964608,1069547520,1061997773,1,3208642560,1,3208642358},{1056964608,1069547520,1065353216,0,1008981770,1,1008981570},{1084227584,0,0,0,3212836864,1,3212836864},{1084227584,0,0,1,0,1,2147483648},{1084227584,0,1045220557,0,1065353216,1,1065347040},{1084227584,0,1061997773,0,3156465418,1,3156449609},{1084227584,0,1061997773,1,1061158912,1,1061138808},{1084227584,0,1065353216,1,3196059648,1,3196028770},{1084227584,994352038,0,0,1056964608,1,1056964608},{1084227584,994352038,1045220557,0,3204448256,1,3204442080},{1084227584,994352038,1045220557,1,1048576000,1,1048561424},{1084227584,994352038,1061997773,1,3208642560,1,3208622458},{1084227584,994352038,1065353216,0,1008981770,1,1008962008},{1084227584,3192704205,0,0,3212836864,1,3212836864},{1084227584,3192704205,0,1,0,1,2147483648},{1084227584,3192704205,1045220557,0,1065353216,1,1065347040},{1084227584,3192704205,1061997773,0,3156465418,1,3156449609},{1084227584,3192704205,1061997773,1,1061158912,1,1061138808},{1084227584,3192704205,1065353216,1,3196059648,1,3196028770},{1084227584,1069547520,0,0,1056964608,1,1056964608},{1084227584,1069547520,1045220557,0,3204448256,1,3204442080},{1084227584,1069547520,1045220557,1,1048576000,1,1048561424},{1084227584,1069547520,1061997773,1,3208642560,1,3208622458},{1084227584,1069547520,1065353216,0,1008981770,1,1008962008},{1091504701,0,0,0,3212836864,1,3212836864},{1091504701,0,0,1,0,1,2147483648},{1091504701,0,1045220557,0,1065353216,1,1065333737},{1091504701,0,1061997773,0,3156465418,1,3156415554},{1091504701,0,1061997773,1,1061158912,1,1061095509},{1091504701,0,1065353216,1,3196059648,1,3195962256},{1091504701,994352038,0,0,1056964608,1,1056964608},{1091504701,994352038,1045220557,0,3204448256,1,3204428777},{1091504701,994352038,1045220557,1,1048576000,1,1048530030},{1091504701,994352038,1061997773,1,3208642560,1,3208579158},{1091504701,994352038,1065353216,0,1008981770,1,1008919439},{1091504701,3192704205,0,0,3212836864,1,3212836864},{1091504701,3192704205,0,1,0,1,2147483648},{1091504701,3192704205,1045220557,0,1065353216,1,1065333737},{1091504701,3192704205,1061997773,0,3156465418,1,3156415554},{1091504701,3192704205,1061997773,1,1061158912,1,1061095509},{1091504701,3192704205,1065353216,1,3196059648,1,3195962256},{1091504701,1069547520,0,0,1056964608,1,1056964608},{1091504701,1069547520,1045220557,0,3204448256,1,3204428777},{1091504701,1069547520,1045220557,1,1048576000,1,1047227463},{1091504701,1069547520,1061997773,1,3208642560,1,3207604485},{1091504701,1069547520,1065353216,0,1008981770,1,1008919439},{1094713344,0,0,0,3212836864,1,3212836864},{1094713344,0,0,1,0,1,2147483648},{1094713344,0,1045220557,0,1065353216,1,1065318667},{1094713344,0,1061997773,0,3156465418,1,3156376974},{1094713344,0,1061997773,1,1061158912,1,1061046455},{1094713344,0,1065353216,1,3196059648,1,3195886905},{1094713344,994352038,0,0,1056964608,1,1056964608},{1094713344,994352038,1045220557,0,3204448256,1,3204413707},{1094713344,994352038,1045220557,1,1048576000,1,1048494464},{1094713344,994352038,1061997773,1,3208642560,1,3208530105},{1094713344,994352038,1065353216,0,1008981770,1,1008871214},{1094713344,3192704205,0,0,3212836864,1,3212836864},{1094713344,3192704205,0,1,0,1,2147483648},{1094713344,3192704205,1045220557,0,1065353216,1,1065318667},{1094713344,3192704205,1061997773,0,3156465418,1,3156376974},{1094713344,3192704205,1061997773,1,1061158912,1,1061046455},{1094713344,3192704205,1065353216,1,3196059648,1,3195886905},{1094713344,1069547520,0,0,1056964608,1,1056964608},{1094713344,1069547520,1045220557,0,3204448256,1,3204413707},{1094713344,1069547520,1045220557,1,1048576000,1,1043694456},{1094713344,1069547520,1061997773,1,3208642560,1,3204944849},{1094713344,1069547520,1065353216,0,1008981770,1,1008871214},{1099893309,0,0,0,3212836864,1,3212836864},{1099893309,0,0,1,0,1,2147483648},{1099893309,0,1045220557,0,1065353216,1,1065279710},{1099893309,0,1061997773,0,3156465418,1,3156277244},{1099893309,0,1061997773,1,1061158912,1,1060919649},{1099893309,0,1065353216,1,3196059648,1,3195692120},{1099893309,994352038,0,0,1056964608,1,1056964608},{1099893309,994352038,1045220557,0,3204448256,1,3204374750},{1099893309,994352038,1045220557,1,1048576000,1,1048402525},{1099893309,994352038,1061997773,1,3208642560,1,3208403299},{1099893309,994352038,1065353216,0,1008981770,1,1008746552},{1099893309,3192704205,0,0,3212836864,1,3212836864},{1099893309,3192704205,0,1,0,1,2147483648},{1099893309,3192704205,1045220557,0,1065353216,1,1065279710},{1099893309,3192704205,1061997773,0,3156465418,1,3156277244},{1099893309,3192704205,1061997773,1,1061158912,1,1060919649},{1099893309,3192704205,1065353216,1,3196059648,1,3195692120},{1099893309,1069547520,0,0,1056964608,1,1056964608},{1099893309,1069547520,1045220557,0,3204448256,1,3204374750},{1099893309,1069547520,1045220557,1,1048576000,1,1040284521},{1099893309,1069547520,1061997773,1,3208642560,1,3200288074},{1099893309,1069547520,1065353216,0,1008981770,1,1008746552},{1103626240,0,0,0,3212836864,1,3212836864},{1103626240,0,0,1,0,1,2147483648},{1103626240,0,1045220557,0,1065353216,1,1065219557},{1103626240,0,1061997773,0,3156465418,1,3156123251},{1103626240,0,1061997773,1,1061158912,1,1060723851},{1103626240,0,1065353216,1,3196059648,1,3195391353},{1103626240,994352038,0,0,1056964608,1,1056964608},{1103626240,994352038,1045220557,0,3204448256,1,3204314597},{1103626240,994352038,1045220557,1,1048576000,1,1048260564},{1103626240,994352038,1061997773,1,3208642560,1,3208207500},{1103626240,994352038,1065353216,0,1008981770,1,1008554061},{1103626240,3192704205,0,0,3212836864,1,3212836864},{1103626240,3192704205,0,1,0,1,2147483648},{1103626240,3192704205,1045220557,0,1065353216,1,1065219557},{1103626240,3192704205,1061997773,0,3156465418,1,3156123251},{1103626240,3192704205,1061997773,1,1061158912,1,1060723851},{1103626240,3192704205,1065353216,1,3196059648,1,3195391353},{1103626240,1069547520,0,0,1056964608,1,1056964608},{1103626240,1069547520,1045220557,0,3204448256,1,3204314597},{1103626240,1069547520,1045220557,1,1048576000,1,1036382058},{1103626240,1069547520,1061997773,1,3208642560,1,3197243547},{1103626240,1069547520,1065353216,0,1008981770,1,1008554061},{1110704128,0,0,0,3212836864,1,3212836864},{1110704128,0,0,1,0,1,2147483648},{1110704128,0,1045220557,0,1065353216,1,1065035059},{1110704128,0,1061997773,0,3156465418,1,3155650937},{1110704128,0,1061997773,1,1061158912,1,1060123310},{1110704128,0,1065353216,1,3196059648,1,3194468864},{1110704128,994352038,0,0,1056964608,1,1056964608},{1110704128,994352038,1045220557,0,3204448256,1,3204130099},{1110704128,994352038,1045220557,1,1048576000,1,1047825149},{1110704128,994352038,1061997773,1,3208642560,1,3207606960},{1110704128,994352038,1065353216,0,1008981770,1,1007963668},{1110704128,3192704205,0,0,3212836864,1,3212836864},{1110704128,3192704205,0,1,0,1,2147483648},{1110704128,3192704205,1045220557,0,1065353216,1,1065035059},{1110704128,3192704205,1061997773,0,3156465418,1,3155650937},{1110704128,3192704205,1061997773,1,1061158912,1,1060123310},{1110704128,3192704205,1065353216,1,3196059648,1,3194468864},{1110704128,1069547520,0,0,1056964608,1,1056964608},{1110704128,1069547520,1045220557,0,3204448256,1,3204130099},{1110704128,1069547520,1045220557,1,1048576000,1,1031850728},{1110704128,1069547520,1061997773,1,3208642560,1,3191445601},{1110704128,1069547520,1065353216,0,1008981770,1,1007963668},{1116471296,0,0,0,3212836864,1,3212836864},{1116471296,0,0,1,0,1,2147483648},{1116471296,0,1045220557,0,1065353216,1,1064894666},{1116471296,0,1061997773,0,3156465418,1,3155291531},{1116471296,0,1061997773,1,1061158912,1,1059666331},{1116471296,0,1065353216,1,3196059648,1,3193766899},{1116471296,994352038,0,0,1056964608,1,1056964608},{1116471296,994352038,1045220557,0,3204448256,1,3203989706},{1116471296,994352038,1045220557,1,1048576000,1,1047493821},{1116471296,994352038,1061997773,1,3208642560,1,3207149981},{1116471296,994352038,1065353216,0,1008981770,1,1007514410},{1116471296,3192704205,0,0,3212836864,1,3212836864},{1116471296,3192704205,0,1,0,1,2147483648},{1116471296,3192704205,1045220557,0,1065353216,1,1064894666},{1116471296,3192704205,1061997773,0,3156465418,1,3155291531},{1116471296,3192704205,1061997773,1,1061158912,1,1058418668},{1116471296,3192704205,1065353216,1,3196059648,1,3192137396},{1116471296,1069547520,0,0,1056964608,1,1056964608},{1116471296,1069547520,1045220557,0,3204448256,1,3203989706},{1116471296,1069547520,1045220557,1,1048576000,1,1027891499},{1116471296,1069547520,1061997773,1,3208642560,1,3188376505},{1116471296,1069547520,1065353216,0,1008981770,1,1007514410}},["ratio"]={{1,1087373312,0,6.5,1087373312},{1,1087373312,1065353216,6.5,1087373312},{1,1087373312,1091504700,6.5,1087373312},{1,1087373312,1091504701,6.5,1087373312},{1,1087373312,1091504702,6.5,1087373312},{1,1087373312,1092616192,6.5,1087373312},{1,1087373312,1096191836,6.5,1087373312},{1,1087373312,1099893308,6.5,1087373312},{1,1087373312,1099893309,6.5,1087373312},{1,1087373312,1099893310,6.5,1087373312},{1,1087373312,1101004800,6.5,1087373312},{1,1087373312,1112014848,6.5,1087373312},{1,1088421888,0,7.0,1088421888},{1,1088421888,1065353216,7.0,1088421888},{1,1088421888,1091504700,7.0,1088421888},{1,1088421888,1091504701,7.0,1088421888},{1,1088421888,1091504702,7.0,1088421888},{1,1088421888,1092616192,7.0,1088421888},{1,1088421888,1096191836,7.0,1088421888},{1,1088421888,1099893308,7.0,1088421888},{1,1088421888,1099893309,7.0,1088421888},{1,1088421888,1099893310,7.0,1088421888},{1,1088421888,1101004800,7.0,1088421888},{1,1088421888,1112014848,7.0,1088421888},{1,1089470464,0,7.0,1088421888},{1,1089470464,1065353216,7.0,1088421888},{1,1089470464,1091504700,7.0,1088421888},{1,1089470464,1091504701,7.0,1088421888},{1,1089470464,1091504702,7.000000066151657,1088421888},{1,1089470464,1092616192,7.059284153877023,1088546215},{1,1089470464,1096191836,7.250000033075828,1088946176},{1,1089470464,1099893308,7.499999893325018,1089470463},{1,1089470464,1099893309,7.5,1089470464},{1,1089470464,1099893310,7.5,1089470464},{1,1089470464,1101004800,7.5,1089470464},{1,1089470464,1112014848,7.5,1089470464},{1,1094713344,0,7.0,1088421888},{1,1094713344,1065353216,7.0,1088421888},{1,1094713344,1091504700,7.0,1088421888},{1,1094713344,1091504701,7.0,1088421888},{1,1094713344,1091504702,7.000000661516566,1088421889},{1,1094713344,1092616192,7.59284153877023,1089665166},{1,1094713344,1096191836,9.500000330758283,1092091904},{1,1094713344,1099893308,11.999998933250183,1094713342},{1,1094713344,1099893309,12.0,1094713344},{1,1094713344,1099893310,12.0,1094713344},{1,1094713344,1101004800,12.0,1094713344},{1,1094713344,1112014848,12.0,1094713344},{1,1095761920,0,7.0,1088421888},{1,1095761920,1065353216,7.0,1088421888},{1,1095761920,1091504700,7.0,1088421888},{1,1095761920,1091504701,7.0,1088421888},{1,1095761920,1091504702,7.000000793819879,1088421889},{1,1095761920,1092616192,7.711409846524276,1089913822},{1,1095761920,1096191836,10.00000039690994,1092616192},{1,1095761920,1099893308,12.99999871990022,1095761918},{1,1095761920,1099893309,13.0,1095761920},{1,1095761920,1099893310,13.0,1095761920},{1,1095761920,1101004800,13.0,1095761920},{1,1095761920,1112014848,13.0,1095761920},{1,1099956224,0,7.0,1088421888},{1,1099956224,1065353216,7.0,1088421888},{1,1099956224,1091504700,7.0,1088421888},{1,1099956224,1091504701,7.0,1088421888},{1,1099956224,1091504702,7.000001455336445,1088421891},{1,1099956224,1092616192,8.304251385294506,1090838070},{1,1099956224,1096191836,12.500000727668223,1095237632},{1,1099956224,1099893308,17.999997653150402,1099956222},{1,1099956224,1099893309,18.0,1099956224},{1,1099956224,1099893310,18.0,1099956224},{1,1099956224,1101004800,18.0,1099956224},{1,1099956224,1112014848,18.0,1099956224},{1,1103626240,0,7.0,1088421888},{1,1103626240,1065353216,7.0,1088421888},{1,1103626240,1091504700,7.0,1088421888},{1,1103626240,1091504701,7.0,1088421888},{1,1103626240,1091504702,7.0000023814596375,1088421892},{1,1103626240,1092616192,9.134229539572829,1091708365},{1,1103626240,1096191836,16.00000119072982,1098907648},{1,1103626240,1099893308,24.999996159700657,1103626237},{1,1103626240,1099893309,25.0,1103626240},{1,1103626240,1099893310,25.0,1103626240},{1,1103626240,1101004800,25.0,1103626240},{1,1103626240,1112014848,25.0,1103626240},{1,1107296256,0,7.0,1088421888},{1,1107296256,1065353216,7.0,1088421888},{1,1107296256,1091504700,7.0,1088421888},{1,1107296256,1091504701,7.0,1088421888},{1,1107296256,1091504702,7.00000330758283,1088421894},{1,1107296256,1092616192,9.96420769385115,1092578661},{1,1107296256,1096191836,19.500001653791415,1100742656},{1,1107296256,1099893308,31.999994666250913,1107296253},{1,1107296256,1099893309,32.0,1107296256},{1,1107296256,1099893310,32.0,1107296256},{1,1107296256,1101004800,32.0,1107296256},{1,1107296256,1112014848,32.0,1107296256},{0,1087373312,0,6.5,1087373312},{0,1087373312,1065353216,6.5,1087373312},{0,1087373312,1091504700,6.5,1087373312},{0,1087373312,1091504701,6.5,1087373312},{0,1087373312,1091504702,6.5,1087373312},{0,1087373312,1092616192,6.5,1087373312},{0,1087373312,1096191836,6.5,1087373312},{0,1087373312,1099893308,6.5,1087373312},{0,1087373312,1099893309,6.5,1087373312},{0,1087373312,1099893310,6.5,1087373312},{0,1087373312,1101004800,6.5,1087373312},{0,1087373312,1112014848,6.5,1087373312},{0,1088421888,0,7.0,1088421888},{0,1088421888,1065353216,7.0,1088421888},{0,1088421888,1091504700,7.0,1088421888},{0,1088421888,1091504701,7.0,1088421888},{0,1088421888,1091504702,7.0,1088421888},{0,1088421888,1092616192,7.0,1088421888},{0,1088421888,1096191836,7.0,1088421888},{0,1088421888,1099893308,7.0,1088421888},{0,1088421888,1099893309,7.0,1088421888},{0,1088421888,1099893310,7.0,1088421888},{0,1088421888,1101004800,7.0,1088421888},{0,1088421888,1112014848,7.0,1088421888},{0,1089470464,0,7.5,1089470464},{0,1089470464,1065353216,7.5,1089470464},{0,1089470464,1091504700,7.5,1089470464},{0,1089470464,1091504701,7.5,1089470464},{0,1089470464,1091504702,7.5,1089470464},{0,1089470464,1092616192,7.5,1089470464},{0,1089470464,1096191836,7.5,1089470464},{0,1089470464,1099893308,7.5,1089470464},{0,1089470464,1099893309,7.5,1089470464},{0,1089470464,1099893310,7.5,1089470464},{0,1089470464,1101004800,7.5,1089470464},{0,1089470464,1112014848,7.5,1089470464},{0,1094713344,0,12.0,1094713344},{0,1094713344,1065353216,12.0,1094713344},{0,1094713344,1091504700,12.0,1094713344},{0,1094713344,1091504701,12.0,1094713344},{0,1094713344,1091504702,12.0,1094713344},{0,1094713344,1092616192,12.0,1094713344},{0,1094713344,1096191836,12.0,1094713344},{0,1094713344,1099893308,12.0,1094713344},{0,1094713344,1099893309,12.0,1094713344},{0,1094713344,1099893310,12.0,1094713344},{0,1094713344,1101004800,12.0,1094713344},{0,1094713344,1112014848,12.0,1094713344},{0,1095761920,0,13.0,1095761920},{0,1095761920,1065353216,13.0,1095761920},{0,1095761920,1091504700,13.0,1095761920},{0,1095761920,1091504701,13.0,1095761920},{0,1095761920,1091504702,13.0,1095761920},{0,1095761920,1092616192,13.0,1095761920},{0,1095761920,1096191836,13.0,1095761920},{0,1095761920,1099893308,13.0,1095761920},{0,1095761920,1099893309,13.0,1095761920},{0,1095761920,1099893310,13.0,1095761920},{0,1095761920,1101004800,13.0,1095761920},{0,1095761920,1112014848,13.0,1095761920},{0,1099956224,0,18.0,1099956224},{0,1099956224,1065353216,18.0,1099956224},{0,1099956224,1091504700,18.0,1099956224},{0,1099956224,1091504701,18.0,1099956224},{0,1099956224,1091504702,18.0,1099956224},{0,1099956224,1092616192,18.0,1099956224},{0,1099956224,1096191836,18.0,1099956224},{0,1099956224,1099893308,18.0,1099956224},{0,1099956224,1099893309,18.0,1099956224},{0,1099956224,1099893310,18.0,1099956224},{0,1099956224,1101004800,18.0,1099956224},{0,1099956224,1112014848,18.0,1099956224},{0,1103626240,0,25.0,1103626240},{0,1103626240,1065353216,25.0,1103626240},{0,1103626240,1091504700,25.0,1103626240},{0,1103626240,1091504701,25.0,1103626240},{0,1103626240,1091504702,25.0,1103626240},{0,1103626240,1092616192,25.0,1103626240},{0,1103626240,1096191836,25.0,1103626240},{0,1103626240,1099893308,25.0,1103626240},{0,1103626240,1099893309,25.0,1103626240},{0,1103626240,1099893310,25.0,1103626240},{0,1103626240,1101004800,25.0,1103626240},{0,1103626240,1112014848,25.0,1103626240},{0,1107296256,0,32.0,1107296256},{0,1107296256,1065353216,32.0,1107296256},{0,1107296256,1091504700,32.0,1107296256},{0,1107296256,1091504701,32.0,1107296256},{0,1107296256,1091504702,32.0,1107296256},{0,1107296256,1092616192,32.0,1107296256},{0,1107296256,1096191836,32.0,1107296256},{0,1107296256,1099893308,32.0,1107296256},{0,1107296256,1099893309,32.0,1107296256},{0,1107296256,1099893310,32.0,1107296256},{0,1107296256,1101004800,32.0,1107296256},{0,1107296256,1112014848,32.0,1107296256}},["tail"]={{0,false,0,1099956224,3212836864,0,1065353216,1055246586,1055246586,1030080762,0},{0,false,0,1099956224,3156465418,0,1008981770,999493627,999493627,974327803,0},{0,false,0,1099956224,1048576000,0,3196059648,3185953019,3185953019,3160787195,0},{0,false,0,1099956224,3187463808,0,1039980160,1029894750,1029894750,1004728926,0},{0,false,1094713344,1099956224,3204448256,0,1056964608,1041591014,1041591014,1016425190,0},{0,false,1094713344,1099956224,0,0,2147483648,2147483648,2147483648,2147483648,0},{0,false,1094713344,1099956224,1061158912,0,3208642560,3193970780,3193970780,3168804956,0},{0,false,1106247680,1099956224,3212836864,0,1065353216,1043511490,1043511490,1018345666,0},{0,false,1106247680,1099956224,3156465418,0,1008981770,988070791,988070791,962904967,0},{0,false,1106247680,1099956224,1048576000,0,3196059648,3174217923,3174217923,3149052099,0},{0,false,1106247680,1099956224,3187463808,0,1039980160,1018200991,1018200991,993035167,0},{0,false,1106247680,1094713344,3204448256,0,1056964608,1040583314,1040583314,1015417490,0},{0,false,1106247680,1094713344,0,0,2147483648,2147483648,2147483648,2147483648,0},{0,false,1106247680,1094713344,1061158912,0,3208642560,3192459228,3192459228,3167293404,0},{0,false,1084227584,1107296256,3212836864,0,1065353216,1055246586,1055246586,1030080762,0},{0,false,1084227584,1107296256,3156465418,0,1008981770,999493627,999493627,974327803,0},{0,false,1084227584,1107296256,1048576000,0,3196059648,3185953019,3185953019,3160787195,0},{0,false,1084227584,1107296256,3187463808,0,1039980160,1029894750,1029894750,1004728926,0},{0,true,0,1099956224,3204448256,0,1056964608,1046857978,1046857978,1021692154,0},{0,true,0,1099956224,0,0,2147483648,2147483648,2147483648,2147483648,0},{0,true,0,1099956224,1061158912,0,3208642560,3198965437,3198965437,3173799613,0},{0,true,1094713344,1099956224,3212836864,0,1065353216,1049979622,1049979622,1024813798,0},{0,true,1094713344,1099956224,3156465418,0,1008981770,994001190,994001190,968835366,0},{0,true,1094713344,1099956224,1048576000,0,3196059648,3180686055,3180686055,3155520231,0},{0,true,1094713344,1099956224,3187463808,0,1039980160,1024692845,1024692845,999527021,0},{0,true,1106247680,1099956224,3204448256,0,1056964608,1035122882,1035122882,1009957058,0},{0,true,1106247680,1099956224,0,0,2147483648,2147483648,2147483648,2147483648,0},{0,true,1106247680,1099956224,1061158912,0,3208642560,3188066963,3188066963,3162901139,0},{0,true,1106247680,1094713344,3212836864,0,1065353216,1048971922,1048971922,1023806098,0},{0,true,1106247680,1094713344,3156465418,0,1008981770,992711333,992711333,967545509,0},{0,true,1106247680,1094713344,1048576000,0,3196059648,3179678354,3179678354,3154512530,0},{0,true,1106247680,1094713344,3187463808,0,1039980160,1023697591,1023697591,998531767,0},{0,true,1084227584,1107296256,3204448256,0,1056964608,1046857978,1046857978,1021692154,0},{0,true,1084227584,1107296256,0,0,2147483648,2147483648,2147483648,2147483648,0},{0,true,1084227584,1107296256,1061158912,0,3208642560,3198965437,3198965437,3173799613,0},{1045220557,false,0,1099956224,3212836864,0,1065353216,1055246586,1055246586,1030080762,0},{1045220557,false,0,1099956224,3156465418,0,998405030,988426170,988426170,963260346,0},{1045220557,false,0,1099956224,1048576000,0,3191997185,3182306560,3182306560,3157140736,0},{1045220557,false,0,1099956224,3187463808,0,1034315147,1024809846,1024809846,999644022,0},{1045220557,false,1094713344,1099956224,3204448256,0,1054792806,1040323415,1040323415,1015157591,0},{1045220557,false,1094713344,1099956224,0,0,2147483648,2147483648,2147483648,2147483648,0},{1045220557,false,1094713344,1099956224,1061158912,0,3207939019,3193149519,3193149519,3167983695,0},{1045220557,false,1106247680,1099956224,3212836864,0,1065353216,1043511490,1043511490,1018345666,0},{1045220557,false,1106247680,1099956224,3156465418,0,998405030,976626975,976626975,951461151,0},{1045220557,false,1106247680,1099956224,1048576000,0,3191997185,3171381789,3171381789,3146215965,0},{1045220557,false,1106247680,1099956224,3187463808,0,1034315147,1013470563,1013470563,988304739,0},{1045220557,false,1106247680,1094713344,3204448256,0,1054792806,1038704929,1038704929,1013539105,0},{1045220557,false,1106247680,1094713344,0,0,2147483648,2147483648,2147483648,2147483648,0},{1045220557,false,1106247680,1094713344,1061158912,0,3207939019,3191722482,3191722482,3166556658,0},{1045220557,false,1084227584,1107296256,3212836864,0,1065353216,1055246586,1055246586,1030080762,0},{1045220557,false,1084227584,1107296256,3156465418,0,998405030,988426170,988426170,963260346,0},{1045220557,false,1084227584,1107296256,1048576000,0,3191997185,3182306560,3182306560,3157140736,0},{1045220557,false,1084227584,1107296256,3187463808,0,1034315147,1024809846,1024809846,999644022,0},{1045220557,true,0,1099956224,3204448256,0,1056964608,1046857978,1046857978,1021692154,0},{1045220557,true,0,1099956224,0,0,2147483648,2147483648,2147483648,2147483648,0},{1045220557,true,0,1099956224,1061158912,0,3208642560,3198965437,3198965437,3173799613,0},{1045220557,true,1094713344,1099956224,3212836864,0,1065353216,1049979622,1049979622,1024813798,0},{1045220557,true,1094713344,1099956224,3156465418,0,1008981770,994001190,994001190,968835366,0},{1045220557,true,1094713344,1099956224,1048576000,0,3196059648,3180686055,3180686055,3155520231,0},{1045220557,true,1094713344,1099956224,3187463808,0,1039980160,1024692845,1024692845,999527021,0},{1045220557,true,1106247680,1099956224,3204448256,0,1056964608,1035122882,1035122882,1009957058,0},{1045220557,true,1106247680,1099956224,0,0,2147483648,2147483648,2147483648,2147483648,0},{1045220557,true,1106247680,1099956224,1061158912,0,3208642560,3188066963,3188066963,3162901139,0},{1045220557,true,1106247680,1094713344,3212836864,0,1065353216,1048971922,1048971922,1023806098,0},{1045220557,true,1106247680,1094713344,3156465418,0,1008981770,992711333,992711333,967545509,0},{1045220557,true,1106247680,1094713344,1048576000,0,3196059648,3179678354,3179678354,3154512530,0},{1045220557,true,1106247680,1094713344,3187463808,0,1039980160,1023697591,1023697591,998531767,0},{1045220557,true,1084227584,1107296256,3204448256,0,1056964608,1046857978,1046857978,1021692154,0},{1045220557,true,1084227584,1107296256,0,0,2147483648,2147483648,2147483648,2147483648,0},{1045220557,true,1084227584,1107296256,1061158912,0,3208642560,3198965437,3198965437,3173799613,0},{1056964608,false,0,1099956224,3212836864,0,1065353216,1055246586,1055246586,1030080762,0},{1056964608,false,0,1099956224,3156465418,0,981668462,971721925,971721925,946556101,0},{1056964608,false,0,1099956224,1048576000,0,3187671040,3177564411,3177564411,3152398587,0},{1056964608,false,0,1099956224,3187463808,0,1026665728,1017084733,1017084733,991918909,0},{1056964608,false,1094713344,1099956224,3204448256,0,1052050675,1037258480,1037258480,1012092656,0},{1056964608,false,1094713344,1099956224,0,0,2147483648,2147483648,2147483648,2147483648,0},{1056964608,false,1094713344,1099956224,1061158912,0,3206956770,3192002914,3192002914,3166837090,0},{1056964608,false,1106247680,1099956224,3212836864,0,1065353216,1043511490,1043511490,1018345666,0},{1056964608,false,1106247680,1099956224,3156465418,0,981668462,959906514,959906514,934740690,0},{1056964608,false,1106247680,1099956224,1048576000,0,3187671040,3165829315,3165829315,3140663491,0},{1056964608,false,1106247680,1099956224,3187463808,0,1026665728,1006114058,1006114058,980948234,0},{1056964608,false,1106247680,1094713344,3204448256,0,1052050675,1035833376,1035833376,1010667552,0},{1056964608,false,1106247680,1094713344,0,0,2147483648,2147483648,2147483648,2147483648,0},{1056964608,false,1106247680,1094713344,1061158912,0,3206956770,3190693872,3190693872,3165528048,0},{1056964608,false,1084227584,1107296256,3212836864,0,1065353216,1055246586,1055246586,1030080762,0},{1056964608,false,1084227584,1107296256,3156465418,0,981668462,971721925,971721925,946556101,0},{1056964608,false,1084227584,1107296256,1048576000,0,3187671040,3177564411,3177564411,3152398587,0},{1056964608,false,1084227584,1107296256,3187463808,0,1026665728,1017084733,1017084733,991918909,0},{1056964608,true,0,1099956224,3204448256,0,1056964608,1046857978,1046857978,1021692154,0},{1056964608,true,0,1099956224,0,0,2147483648,2147483648,2147483648,2147483648,0},{1056964608,true,0,1099956224,1061158912,0,3208642560,3198965437,3198965437,3173799613,0},{1056964608,true,1094713344,1099956224,3212836864,0,1065353216,1049979622,1049979622,1024813798,0},{1056964608,true,1094713344,1099956224,3156465418,0,1008981770,994001190,994001190,968835366,0},{1056964608,true,1094713344,1099956224,1048576000,0,3196059648,3180686055,3180686055,3155520231,0},{1056964608,true,1094713344,1099956224,3187463808,0,1039980160,1024692845,1024692845,999527021,0},{1056964608,true,1106247680,1099956224,3204448256,0,1056964608,1035122882,1035122882,1009957058,0},{1056964608,true,1106247680,1099956224,0,0,2147483648,2147483648,2147483648,2147483648,0},{1056964608,true,1106247680,1099956224,1061158912,0,3208642560,3188066963,3188066963,3162901139,0},{1056964608,true,1106247680,1094713344,3212836864,0,1065353216,1048971922,1048971922,1023806098,0},{1056964608,true,1106247680,1094713344,3156465418,0,1008981770,992711333,992711333,967545509,0},{1056964608,true,1106247680,1094713344,1048576000,0,3196059648,3179678354,3179678354,3154512530,0},{1056964608,true,1106247680,1094713344,3187463808,0,1039980160,1023697591,1023697591,998531767,0},{1056964608,true,1084227584,1107296256,3204448256,0,1056964608,1046857978,1046857978,1021692154,0},{1056964608,true,1084227584,1107296256,0,0,2147483648,2147483648,2147483648,2147483648,0},{1056964608,true,1084227584,1107296256,1061158912,0,3208642560,3198965437,3198965437,3173799613,0},{1061997773,false,0,1099956224,3212836864,0,1065353216,1055246586,1055246586,1030080762,0},{1061997773,false,0,1099956224,3156465418,0,964932087,955018027,955018027,929852203,0},{1061997773,false,0,1099956224,1048576000,0,3181962659,3172440580,3172440580,3147274756,0},{1061997773,false,0,1099956224,3187463808,0,1019066415,1009404594,1009404594,984238770,0},{1061997773,false,1094713344,1099956224,3204448256,0,1049823372,1034658494,1034658494,1009492670,0},{1061997773,false,1094713344,1099956224,0,0,2147483648,2147483648,2147483648,2147483648,0},{1061997773,false,1094713344,1099956224,1061158912,0,3206055739,3190951119,3190951119,3165785295,0},{1061997773,false,1106247680,1099956224,3212836864,0,1065353216,1043511490,1043511490,1018345666,0},{1061997773,false,1106247680,1099956224,3156465418,0,964932087,943186323,943186323,918020499,0},{1061997773,false,1106247680,1099956224,1048576000,0,3181962659,3161183010,3161183010,3136017186,0},{1061997773,false,1106247680,1099956224,3187463808,0,1019066415,998535932,998535932,973370108,0},{1061997773,false,1106247680,1094713344,3204448256,0,1049823372,1033500950,1033500950,1008335126,0},{1061997773,false,1106247680,1094713344,0,0,2147483648,2147483648,2147483648,2147483648,0},{1061997773,false,1106247680,1094713344,1061158912,0,3206055739,3189750315,3189750315,3164584491,0},{1061997773,false,1084227584,1107296256,3212836864,0,1065353216,1055246586,1055246586,1030080762,0},{1061997773,false,1084227584,1107296256,3156465418,0,964932087,955018027,955018027,929852203,0},{1061997773,false,1084227584,1107296256,1048576000,0,3181962659,3172440580,3172440580,3147274756,0},{1061997773,false,1084227584,1107296256,3187463808,0,1019066415,1009404594,1009404594,984238770,0},{1061997773,true,0,1099956224,3204448256,0,1056964608,1046857978,1046857978,1021692154,0},{1061997773,true,0,1099956224,0,0,2147483648,2147483648,2147483648,2147483648,0},{1061997773,true,0,1099956224,1061158912,0,3208642560,3198965437,3198965437,3173799613,0},{1061997773,true,1094713344,1099956224,3212836864,0,1065353216,1049979622,1049979622,1024813798,0},{1061997773,true,1094713344,1099956224,3156465418,0,1008981770,994001190,994001190,968835366,0},{1061997773,true,1094713344,1099956224,1048576000,0,3196059648,3180686055,3180686055,3155520231,0},{1061997773,true,1094713344,1099956224,3187463808,0,1039980160,1024692845,1024692845,999527021,0},{1061997773,true,1106247680,1099956224,3204448256,0,1056964608,1035122882,1035122882,1009957058,0},{1061997773,true,1106247680,1099956224,0,0,2147483648,2147483648,2147483648,2147483648,0},{1061997773,true,1106247680,1099956224,1061158912,0,3208642560,3188066963,3188066963,3162901139,0},{1061997773,true,1106247680,1094713344,3212836864,0,1065353216,1048971922,1048971922,1023806098,0},{1061997773,true,1106247680,1094713344,3156465418,0,1008981770,992711333,992711333,967545509,0},{1061997773,true,1106247680,1094713344,1048576000,0,3196059648,3179678354,3179678354,3154512530,0},{1061997773,true,1106247680,1094713344,3187463808,0,1039980160,1023697591,1023697591,998531767,0},{1061997773,true,1084227584,1107296256,3204448256,0,1056964608,1046857978,1046857978,1021692154,0},{1061997773,true,1084227584,1107296256,0,0,2147483648,2147483648,2147483648,2147483648,0},{1061997773,true,1084227584,1107296256,1061158912,0,3208642560,3198965437,3198965437,3173799613,0},{1065353216,false,0,1099956224,3212836864,0,1065353216,1055246586,1055246586,1030080762,0},{1065353216,false,0,1099956224,3156465418,0,953267990,943471978,943471978,918306154,0},{1065353216,false,0,1099956224,1048576000,0,3179282432,3169175803,3169175803,3144009979,0},{1065353216,false,0,1099956224,3187463808,0,1014609663,1004545212,1004545212,979379388,0},{1065353216,false,1094713344,1099956224,3204448256,0,1048576000,1033202406,1033202406,1008036582,0},{1065353216,false,1094713344,1099956224,0,0,2147483648,2147483648,2147483648,2147483648,0},{1065353216,false,1094713344,1099956224,1061158912,0,3205496832,3190298693,3190298693,3165132869,0},{1065353216,false,1106247680,1099956224,3212836864,0,1065353216,1043511490,1043511490,1018345666,0},{1065353216,false,1106247680,1099956224,3156465418,0,953267990,932341928,932341928,907176104,0},{1065353216,false,1106247680,1099956224,1048576000,0,3179282432,3157440707,3157440707,3132274883,0},{1065353216,false,1106247680,1099956224,3187463808,0,1014609663,992892278,992892278,967726454,0},{1065353216,false,1106247680,1094713344,3204448256,0,1048576000,1032194706,1032194706,1007028882,0},{1065353216,false,1106247680,1094713344,0,0,2147483648,2147483648,2147483648,2147483648,0},{1065353216,false,1106247680,1094713344,1061158912,0,3205496832,3189165029,3189165029,3163999205,0},{1065353216,false,1084227584,1107296256,3212836864,0,1065353216,1055246586,1055246586,1030080762,0},{1065353216,false,1084227584,1107296256,3156465418,0,953267990,943471978,943471978,918306154,0},{1065353216,false,1084227584,1107296256,1048576000,0,3179282432,3169175803,3169175803,3144009979,0},{1065353216,false,1084227584,1107296256,3187463808,0,1014609663,1004545212,1004545212,979379388,0},{1065353216,true,0,1099956224,3204448256,0,1056964608,1046857978,1046857978,1021692154,0},{1065353216,true,0,1099956224,0,0,2147483648,2147483648,2147483648,2147483648,0},{1065353216,true,0,1099956224,1061158912,0,3208642560,3198965437,3198965437,3173799613,0},{1065353216,true,1094713344,1099956224,3212836864,0,1065353216,1049979622,1049979622,1024813798,0},{1065353216,true,1094713344,1099956224,3156465418,0,1008981770,994001190,994001190,968835366,0},{1065353216,true,1094713344,1099956224,1048576000,0,3196059648,3180686055,3180686055,3155520231,0},{1065353216,true,1094713344,1099956224,3187463808,0,1039980160,1024692845,1024692845,999527021,0},{1065353216,true,1106247680,1099956224,3204448256,0,1056964608,1035122882,1035122882,1009957058,0},{1065353216,true,1106247680,1099956224,0,0,2147483648,2147483648,2147483648,2147483648,0},{1065353216,true,1106247680,1099956224,1061158912,0,3208642560,3188066963,3188066963,3162901139,0},{1065353216,true,1106247680,1094713344,3212836864,0,1065353216,1048971922,1048971922,1023806098,0},{1065353216,true,1106247680,1094713344,3156465418,0,1008981770,992711333,992711333,967545509,0},{1065353216,true,1106247680,1094713344,1048576000,0,3196059648,3179678354,3179678354,3154512530,0},{1065353216,true,1106247680,1094713344,3187463808,0,1039980160,1023697591,1023697591,998531767,0},{1065353216,true,1084227584,1107296256,3204448256,0,1056964608,1046857978,1046857978,1021692154,0},{1065353216,true,1084227584,1107296256,0,0,2147483648,2147483648,2147483648,2147483648,0},{1065353216,true,1084227584,1107296256,1061158912,0,3208642560,3198965437,3198965437,3173799613,0}},["linUI"]={{0,0},{1,1008981770},{2,1017370378},{3,1022739087},{4,1025758986},{5,1028443340},{6,1031127695},{7,1032805417},{8,1034147594},{9,1035489771},{10,1036831948},{11,1038174126},{12,1039516303},{13,1040522936},{14,1041194025},{15,1041865113},{16,1042536202},{17,1043207291},{18,1043878379},{19,1044549468},{20,1045220556},{21,1045891645},{22,1046562734},{23,1047233822},{24,1047904911},{25,1048576000},{26,1048911544},{27,1049247088},{28,1049582633},{29,1049918177},{30,1050253721},{31,1050589266},{32,1050924810},{33,1051260354},{34,1051595899},{35,1051931443},{36,1052266987},{37,1052602532},{38,1052938076},{39,1053273620},{40,1053609164},{41,1053944709},{42,1054280253},{43,1054615797},{44,1054951342},{45,1055286886},{46,1055622430},{47,1055957975},{48,1056293519},{49,1056629063},{50,1056964608},{51,1057132380},{52,1057300152},{53,1057467924},{54,1057635696},{55,1057803469},{56,1057971241},{57,1058139013},{58,1058306785},{59,1058474557},{60,1058642329},{61,1058810102},{62,1058977874},{63,1059145646},{64,1059313418},{65,1059481190},{66,1059648962},{67,1059816734},{68,1059984507},{69,1060152279},{70,1060320051},{71,1060487823},{72,1060655595},{73,1060823367},{74,1060991140},{75,1061158912},{76,1061326684},{77,1061494456},{78,1061662228},{79,1061830000},{80,1061997772},{81,1062165545},{82,1062333317},{83,1062501089},{84,1062668861},{85,1062836633},{86,1063004405},{87,1063172178},{88,1063339950},{89,1063507722},{90,1063675494},{91,1063843266},{92,1064011038},{93,1064178811},{94,1064346583},{95,1064514355},{96,1064682127},{97,1064849899},{98,1065017671},{99,1065185443},{100,1065353216}},["momentum"]={{0,1065353216},{1,1070942826},{2,1062554218},{3,1057894812},{4,1054165610},{5,1051369966},{6,1049506204},{7,1047773890},{8,1045777002},{9,1044223866},{10,1042981358},{11,1041964760},{12,1041117596},{13,1040400764},{14,1039385282},{15,1038320275},{16,1037388394},{17,1036566145},{18,1035835258},{19,1035181306},{20,1034592750},{21,1034060246},{22,1033576152},{23,1033134153},{24,1032728988},{25,1032356235},{26,1032012156},{27,1031588344},{28,1030996674},{29,1030445808},{30,1029931667},{31,1029450696},{32,1028999786},{33,1028576203},{34,1028177537},{35,1027801653},{36,1027446650},{37,1027110837},{38,1026792698},{39,1026490875},{40,1026204142},{41,1025931396},{42,1025671638},{43,1025423962},{44,1025187544},{45,1024961634},{46,1024745545},{47,1024538652},{48,1024340380},{49,1024150200},{50,1023967627},{51,1023792214},{52,1023623548},{53,1023461246},{54,1023199736},{55,1022898522},{56,1022608066},{57,1022327801},{58,1022057200},{59,1021795772},{60,1021543059},{61,1021298631},{62,1021062088},{63,1020833054},{64,1020611178},{65,1020396128},{66,1020187595},{67,1019985287},{68,1019788929},{69,1019598263},{70,1019413045},{71,1019233043},{72,1019058042},{73,1018887836},{74,1018722229},{75,1018561039},{76,1018404090},{77,1018251219},{78,1018102267},{79,1017957085},{80,1017815534},{81,1017677477},{82,1017542788},{83,1017411344},{84,1017283030},{85,1017157735},{86,1017035354},{87,1016915787},{88,1016798936},{89,1016684712},{90,1016573026},{91,1016463794},{92,1016356937},{93,1016252378},{94,1016150044},{95,1016049864},{96,1015951772},{97,1015855701},{98,1015761592},{99,1015669383},{100,1015579019}},["scenarios"]={{["name"]="keys",["steer"]=nil,["ratio"]=nil,["quick"]=4,["start"]={{["frame"]=0,["beforeRuns"]={{7247832,1},{7247908,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7271624,2},{7273160,1},{7273256,1},{7293516,1},{7295936,1},{7297528,4},{7297584,1},{7297628,3},{7653748,1},{7653772,2},{7653784,3},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAP83MTD4AAAAACtcjPM3MzD1mZmY/zczMPJqZGT57FK5H4XqEP0jhej/NzEw/2w9JQKuqqj0AAERBLnQBul8cRFT7Ifk/A/oOPD0KD0E9Co9BAADgQAEAAAAAAIA/AisHPQAAgD8AACBAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB17isAAAAAAAAAAAAAAAAAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHXuAAAAAAAAAAAAAAAAOADJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAdQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPQrXPgAAAAAAAAAAAAAAAAAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAkEEAAAAAAAAAAEDw9wAAAAAAAAAAAAAAAAAAAAAAAACA9/cAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAA==",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAPwEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB17isAAAAAAAAAAAAAAAAAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHXuAAAAAAAAAAAAAAAAOADJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAdQAAAAAAAAAAAAAAADmOYzoAAAAAAAAAAAAAAADMzEw/CNejPQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAjXIz85juM7AACAPwAAAD4AAAAAAAAAAAjXIz85juM7AACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAKuqqj0AAIA/AAAAAAAAAAAAAAAAgD8AAIA/AACAPwAAAACA9/cAAAAAAM3MTD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==",["controls"]={0.8,1.0,0.0,false,false,0.0,0.0,true,false,0.0,true}},{["frame"]=84,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297628,3},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj/NzMw8mpkZPs3MTD/bD0lALnQBul8cRFT7Ifk/PQoPQT0Kj0EAAOBAAQAAAAAAgD8CKwc9AACAPwAAgD8AACBAAQAAAFQAAAAKnxC/3dLyP8xj/T8QAAAADGABPQEAAAB2V0hDF1o4QcmLCS5Ald/BP001R0AQAAAAN3W4vAEAAACXjC1AhtcBRRDGQELd9sQAyVxGMUCK7KU9H1YxQBAAAACYAIg6AQAAALNO30DKtk1F+1NfQoLnMwDJl9UTQHewPzwg1BNAEAAAAFpPrToBAAAAiq3hQHDOxkQHcnxCgAAAAIAAAACAAAAAAAAAAADMzEw/AAAAgIHAyj4AAAAAwOSFPgAAAAC85IU+MysVvwAAAACdFF5AFXzCQEpGBj6DvoA/I2rXPnLGpzmmExU86iARO6tVAT1z3H8/eGWbPLWIvDtwFM8+yNvePI1Zh7wdv4Q+AAAAAAAAgD8AAAAAAAAAAAAAAAAI1yM/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAACNcjPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAMDkhT4AAAAA4LAdOwAAAAAIAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAEybCQAAAkEEAAAAAAAAAAEDw9wAAAAAAgD8AAIA/AACAPxMmwkCA9/cAAAAAAM3MTD8AAAAAAAAAAAAAAAAAAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAA==",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP1UAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACXjC1AAAAAAAAAAADd9sQAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALNO30AAAAAAAAAAAILnMwDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAiq3hQAAAAAAAAAAAgAAAAIAAAAAAAAAAAAAAAADMzEw/AAAAgOGl2z4AAAAAuGOPPgAAAADA5IU+gr8fvwAAAAAAAIA/AAAAAAjXIz8AAAAAAACAPwAAAIAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAC4Y48+AAAAAInvFzsAAAAACNcjPwAAAAAAAIA/AAAAAEchxUAAAAAAgD8AAIA/AACAP0chxUCA9/cAAAAAAM3MTD8AAAAAAAAAAAAAAAAAAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==",["controls"]={0.8,1.0,0.0,false,false,1.0,0.0,true,false,0.0,true}},{["frame"]=102,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297528,4},{7297628,3},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj/NzMw8mpkZPs3MTD/bD0lAAABEQS50AbpfHERU+yH5Pz0KD0E9Co9BAADgQAEAAAAAAIA/AisHPQAAgD8AAIA/AAAgQAEAAABmAAAAb0y9P2h3Hr9WPs0/EAAAABdd0DwBAAAA+WgMRSbqTkLJfRACQHFHQ78t8ApAEAAAAKTBK70BAAAAnXsuQAg5pkSAYShCTGuVAMlNTyY/ux4rPj22Kz8QAAAAHz5aOgEAAAAbCP9A+g+bQYn6dkK/3DIAyfRZzj6Xfqk9WKTSPhAAAAAVKJI6AQAAAMRn/0ADDI1BDtWUQv8AAACAAAAAgAAAAAAAAAAAzMxMPwAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAIAAAAAA8pTaQByj9EA02Y4/uiYHQCxD1j7Q+3M8/8Wtu4It3zqN5gk+/al9P/1+PT7YLGI4MsUbPNeJQD3y/Lm9X88SuwAAAAAAAIA/AAAAAAAAAAAAAAAACNcjPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAACAAAAAAAAAAI1yM/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAP38+UAAAJBBAAAAAAAAAABA8PcAAAAAAIA/AACAPwAAgD/9/PlAgPf3AAAAAADNzEw/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAA=",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP2cAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACdey5AAAAAAAAAAABMa5UAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABsI/0AAAAAAAAAAAL/cMgDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAxGf/QAAAAAAAAAAA/wAAAIAAAAAAAAAAAAAAAADMzEw/AAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAIA/AAAAAAjXIz8AAAAAAACAPwAAAIAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAACNcjPwAAAAAAAIA/AAAAAJfM/UAAAAAAgD8AAIA/AACAP5fM/UCA9/cAAAAAAM3MTD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==",["controls"]={0.8,1.0,0.0,false,false,0.0,0.0,true,false,0.0,true}},{["frame"]=113,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297628,3},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj/NzMw8mpkZPs3MTD/bD0lALnQBul8cRFT7Ifk/PQoPQT0Kj0EAAOBAAQAAAAAAgD8CKwc9AACAPwAAgD8AACBAAQAAAHEAAAAX0aE/E/iBPVACoj8QAAAAOoMXPQEAAADZa6tEHdd3Qsm0XkFADQkZvkqUQUAQAAAA0sP8vAEAAADo5i5AIihbRSialUJy7NMAyYViOjwuXyM992gwPRAAAADetnO5AQAAAAStDEHCIBo9DE2VQsCjMQDJJxlrPKRZDb1URx49EAAAAB9SQTgBAAAA8aYMQWbyYTw2PZJC3QAAAIAAAACAAAAAAAAAAADMzEw/AAAAgAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAgAMAAAAFHxVBvF8HQWZZ5j8gshZAr6LWPmAB3bzyrrM6PE9nOwmPCT6BrX0/ox5JvPbr4zxMelc8huIjPdQFnT1fzxK7AAAAAAAAgD8AAAAAAAAAAAAAAAAI1yM/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAACNcjPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAMAAAAIAAAAAgAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAJ48MQQAAkEEAAAAAAAAAAEDw9wAAAAAAgD8AAIA/AACAPyePDEGA9/cAAAAAAM3MTD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAA==",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP3IAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADo5i5AAAAAAAAAAABy7NMAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAStDEEAAAAAAAAAAMCjMQDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA8aYMQQAAAAAAAAAA3QAAAIAAAAAAAAAAAAAAAADMzEw/AAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAMAAAAAAIA/AAAAAAjXIz8AAAAAAACAPwAAAIAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIADAAAACNcjPwAAAAAAAIA/AAAAAOSEDEEAAAAAgD8AAIA/AACAP+SEDEGA9/cAAAAAAM3MTD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==",["controls"]={0.8,1.0,0.0,false,false,0.0,0.0,true,false,0.0,true}},{["frame"]=146,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297624,4},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj/NzMw8mpkZPs3MTD/bD0lALnQBul8cRFT7Ifk/MRXlPT0KD0E9Co9BAADgQAEAAAAAAIA/AisHPQAAgD8AAIA/AAAgQAEAAACSAAAAL0HjPUYLe70gvgo+EAAAAPyCFj0BAAAAW4lHQbCZ6kLJTISXPp7hl75T89Y+EAAAAItS+bwBAAAAgIoyQV8tmUKxGe5C4eCRAMlIK6g+qMQZPRM/qT4QAAAA507duQEAAADE1T5B/2uqQQJoEUM7RzAAyfp1rD4s/wm9ZE6tPhAAAABHGhW5AQAAADT8PkExtRBCQmMJQ2AAAACAAAAAgAAAAAAAAAAAzMxMPwAAAIAAAAAAAiuHPTC2/rwAAAAAMrb+vPbw0z0AAAAAAvmTQYVwNkGjVItAdc9IQJTy1j5tc4Y6KGBUOhmfTTsMGgs+K6B9P4w/NL3IZcc6GQgEvWZ8Ij30GKI8D4gIvQAAAAAAAIA/AAAAAAAAAAAAAAAACNcjPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAwtv68AAAAADwK/LoAAAAACAAAAAAAAAAI1yM/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAOf7O0EAAJBBAAAAAAAAAABA8PcAAAAAAIA/AACAPwAAgD/n+ztBgPf3AAAAAADNzEw/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAA=",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP5MAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAijJBAAAAAAAAAADh4JEAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMTVPkEAAAAAAAAAADtHMADJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANPw+QQAAAAAAAAAAYAAAAIAAAAAAAAAAAAAAAADMzEw/AAAAgAAAAACDwMo9T+M8vQAAAAAwtv68mZkePgAAAAAAAIA/AAAAAAjXIz8AAAAAAACAPwAAAIAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAABP4zy9AAAAANog9roAAAAACNcjPwAAAAAAAIA/AAAAAIE4PUEAAAAAgD8AAIA/AACAP4E4PUGA9/cAAAAAAM3MTD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==",["controls"]={0.8,1.0,0.0,false,false,0.0,1.0,true,false,0.0,true}},{["frame"]=164,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297624,4},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj/NzMw8mpkZPs3MTD/bD0lALnQBul8cRFT7Ifk/MRXlPT0KD0E9Co9BAADgQAEAAAAAAIA/AisHPQAAgD8AAIA/AAAgQAEAAACkAAAACnG4vRm5G8Ae0RtAEAAAAEA9oTwBAAAA1bQOReQsX0PJ2BLevR8EQMCYHUBAEAAAADBZLb0BAAAA2JYzQQleNkR122VCobZSAMmMjrI95Mohvzt1Iz8QAAAAnQFDuwEAAACRf2BB6vzmQ7nBU0OF4y8AycoUnz+6P1G/82G+PxAAAAAhtzC7AQAAAHEiT0EeLDhEYAHfQpYAAACAAAAAgAAAAAAAAAAAzMxMPwAAAIAAAAAA3aXbPl3YJ74AAAAAXtgnvn+/Hz8AAAAAsADFQUp+UEGWvatAb0edPjzL1z7N08U7CaUtvOd/NTtF9Bo9J81/PwpgfbsrnDY8OeIsv/FxTj2BDK27nCMqvgAAAAAAAIA/AAAAAAAAAAAAAAAACNcjPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAABd2Ce+AAAAAMy8VzsAAAAACAAAAAAAAAAI1yM/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAADuKT0EAAJBBAAAAAAAAAABA8PcAAAAAAIA/AACAPwAAgD87ik9BgPf3AAAAAADNzEw/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAA=",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP6UAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADYljNBAAAAAAAAAAChtlIAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJF/YEEAAAAAAAAAAIXjLwDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcSJPQQAAAAAAAAAAlgAAAIAAAAAAAAAAAAAAAADMzEw/AAAAgAAAAABsaLE+bWAKvgAAAABd2Ce+uY4EPwAAAAAAAIA/AAAAAAjXIz8AAAAAAACAPwAAAIAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAABtYAq+AAAAAIO/azsAAAAACNcjPwAAAAAAAIA/AAAAAB+NUEEAAAAAgD8AAIA/AACAPx+NUEGA9/cAAAAAAM3MTD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==",["controls"]={0.8,1.0,0.0,false,false,0.0,0.0,true,false,0.0,true}},{["frame"]=182,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297528,4},{7297624,4},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj/NzMw8mpkZPs3MTD/bD0lAAABEQS50AbpfHERU+yH5PzEV5T09Cg9BPQqPQQAA4EABAAAAAACAPwIrBz0AAIA/AACAPwAAIEABAAAAtgAAANOwn78whAg+8pegPxAAAACuBRY9AQAAACsdoERkuRFDyRFMrb7jLuW9oaC2PhAAAAAuh/28AQAAAPvZNkGUosNC0VMoQ3q0BwDJBqO5Puhb8TzhO7o+EAAAAIqxrzgBAAAAAFxqQWAtRUJsTS9D2G8uAMmj1K0+QjIsvfskrz4QAAAAw0O/OQEAAAAW2WpBKjorQpVzN0P/AAAAgAAAAIAAAAAAAAAAAMzMTD8AAACAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAACAAAAAAJEW/EE4PGhBv6GoQGaQeL7vcdY+zWmdO8up3jrfIDM7o5oJvFn9fz+gAww8uFX8ObXS8TulRCM9Lp3ZvF/PErsAAAAAAACAPwAAAAAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAI1yM/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAgAAAAAAAAACNcjPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAAAs82ZBAACQQQAAAAAAAAAAQPD3AAAAAACAPwAAgD8AAIA/LPNmQYD39wAAAAAAzcxMPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAA",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP7cAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD72TZBAAAAAAAAAAB6tAcAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABcakEAAAAAAAAAANhvLgDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFtlqQQAAAAAAAAAA/wAAAIAAAAAAAAAAAAAAAADMzEw/AAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAIA/AAAAAAjXIz8AAAAAAACAPwAAAIAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAACNcjPwAAAAAAAIA/AAAAAIlEaEEAAAAAgD8AAIA/AACAP4lEaEGA9/cAAAAAAM3MTD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==",["controls"]={0.8,1.0,0.0,false,false,0.0,0.0,true,false,0.0,true}},{["frame"]=223,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297528,4},{7297632,2},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj/NzMw8mpkZPs3MTD/bD0lAAABEQS50AbpfHERU+yH5Pz0Kj0EAAOBAAQAAAAAAgD8CKwc9AACAPwAAgD8AACBAAQAAAN8AAAD2J5q+LUXjPcVkpD4QAAAAf9EXPQEAAADyZ0BC3F8uQ8kQQ5y++u4Evl/zqT4QAAAA5Tr3vAEAAACxZTxBjRmTQj9gVUNwSP0AySN2xz70mSc9B4XIPhAAAABg9+u3AQAAAKb3kUEOO5BCyYVjQyc6KgDJp3W7PvID+7yhGLw+EAAAAGa5gzkBAAAAcKSRQdKgekLQ/mhDxgAAAIAAAACAAAAAAAAAAADMzEw/AAAAgAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAgAAAAADiD0hC4/+PQWzjoEBXkTm+mjHXPpvXuTp6Rgc7htFLO1Ceoru7/n8/y1JpuPtkibnaBr47ASofPQmXFLxfzxK7AAAAAAAAgD8AAAAAAAAAAAAAAAAI1yM/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAACNcjPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAIAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAgk+PQQAAkEEAAAAAAAAAAEDw9wAAAAAAgD8AAIA/AACAP4JPj0GA9/cAAAAAAM3MTD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAA==",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACxZTxBAAAAAAAAAABwSP0AyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKb3kUEAAAAAAAAAACc6KgDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcKSRQQAAAAAAAAAAxgAAAIAAAAAAAAAAAAAAAADMzEw/AAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAIA/AAAAAAjXIz8AAAAAAACAPwAAAIAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAACNcjPwAAAAAAAIA/AAAAAMEBkEEAAAAAgD8AAIA/AACAP8EBkEGA9/cAAAAAAM3MTD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==",["controls"]={0.8,1.0,0.0,false,false,0.0,0.0,true,false,0.0,true}},{["frame"]=256,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297632,2},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj/NzMw8mpkZPs3MTD/bD0lALnQBul8cRFT7Ifk/PQqPQQAA4EABAAAAAACAPwIrBz0AAIA/AACAPwAAIEABAAAAAAEAACS4A75YzBY/Vn0aPxAAAABeNSU9AQAAAORMTkNBPxtDyRUTHL7HXZw+yuqvPhAAAACGdNq8AQAAAOhlQUHM2g5DTBeVQz8GtgDJ554BP02AaT1IcQI/EAAAALTBgzoBAAAA1aapQQZiNUMGunRDf0MmAMkrM6c+UvWAvB5kpz4QAAAAQ2ioOgEAAABTgqlB1Wg1QvzTl0NeAAAAgAAAAIAAAAAAAAAAAMzMTD8AAACAAisHPgAAAAAgKxM9AAAAAB4rEz2mzVK+AAAAALi0h0IUcadBERKdQEHe7T0YJNc+s/yAu+xonDsVxkg7XFy2OfH+fz9xTKk9GEqBuQde4j1nQBU9tnspvSj+CT0AAAAAAACAPwAAAAAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAI1yM/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAICsTPQAAAABzx5E6AAAAAAgAAAAAAAAACNcjPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAADwvKZBAACQQQAAAAAAAAAAQPD3AAAAAACAPwAAgD8AAIA/8LymQYD39wAAAAAAzcxMPwAAAAAAAAAAAAAAAAAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAA",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAPwEBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADoZUFBAAAAAAAAAAA/BrYAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANWmqUEAAAAAAAAAAH9DJgDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAU4KpQQAAAAAAAAAAXgAAAIAAAAAAAAAAAAAAAADMzEw/AAAAgML1KD4AAAAAyTc3PQAAAAAgKxM9XTiDvgAAAAAAAIA/AAAAAAjXIz8AAAAAAACAPwAAAIAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAADJNzc9AAAAAKcykDoAAAAACNcjPwAAAAAAAIA/AAAAAL1xp0EAAAAAgD8AAIA/AACAP71xp0GA9/cAAAAAAM3MTD8AAAAAAAAAAAAAAAAAAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==",["controls"]={0.8,1.0,0.0,false,false,1.0,0.0,true,false,0.0,true}},{["frame"]=274,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297632,2},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj/NzMw8mpkZPs3MTD/bD0lALnQBul8cRFT7Ifk/PQqPQQAA4EABAAAAAACAPwIrBz0AAIA/AACAPwAAIEABAAAAEgEAABcU8bynPLa/G0K2PxAAAADI5JE8AQAAAAI9ZEU0dNNDyRcOb73rTgXAQVwFQBAAAADeDEi9AQAAAJqrQ0F/xLNENDTMQmWGWwDJI8WYPuj52b0o46I+EAAAAJ3e5boBAAAAfIK3QQOIlEJllrBDzVskAMmETGY/1mNBvpN2az8QAAAAYwXBugEAAABzWrZBVDYtRGDLgUN9AAAAgAAAAIAAAAAAAAAAAMzMTD8AAACAAAAAACHbuT6k8sC9AAAAAKvywL1NMAo/AAAAABtdnUIoe7NBzMivQBiGiz+gv9U+64gnPHEOO7wypRs76u/vPG3ffz/shIK7FElQO7Mfrr7YMFw9iR3COyaJxb0AAAAAAACAPwAAAAAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAI1yM/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAApPLAvQAAAAAJl326AAAAAAgAAAAAAAAACNcjPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAABhDbNBAACQQQAAAAAAAAAAQPD3AAAAAACAPwAAgD8AAIA/YQ2zQYD39wAAAAAAzcxMPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAA",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAPxMBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACaq0NBAAAAAAAAAABlhlsAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHyCt0EAAAAAAAAAAM1bJADJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAc1q2QQAAAAAAAAAAfQAAAIAAAAAAAAAAAAAAAADMzEw/AAAAgAAAAACwnY8+KnKYvQAAAACk8sC93FzaPgAAAAAAAIA/AAAAAAjXIz8AAAAAAACAPwAAAIAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAqcpi9AAAAAOgBIjsAAAAACNcjPwAAAAAAAIA/AAAAAFyxs0EAAAAAgD8AAIA/AACAP1yxs0GA9/cAAAAAAM3MTD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==",["controls"]={0.8,1.0,0.0,false,false,0.0,0.0,true,false,0.0,true}},{["frame"]=292,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297528,4},{7297632,2},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj/NzMw8mpkZPs3MTD/bD0lAAABEQS50AbpfHERU+yH5Pz0Kj0EAAOBAAQAAAAAAgD8CKwc9AACAPwAAgD8AACBAAQAAACQBAADIrAI8FcTyPVll8z0QAAAAin4XPQEAAAAuzzw/J7FyQ8mH8/A9gxAAviszMD4QAAAA6Yb3vAEAAACc2EdBSgDfQNQ7lEMQKXIAyZWp2z4y9y09vbLcPhAAAABh07g4AQAAABe7w0EbE+9CPMOiQye/IQDJGILPPq988LyUAdA+EAAAAFXKwTkBAAAAXS/DQS4T2UI+WqpDywAAAIAAAACAAAAAAAAAAADMzEw/AAAAgAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAgAAAAAAQo7RC6eLAQXsvs0DcGY28YZ/WPohxADtbbwM7uDItO4+8Rrmi/38/WAmbO5NHZjrijOE71lAfPRpPVLtfzxK7AAAAAAAAgD8AAAAAAAAAAAAAAAAI1yM/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAACNcjPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAIAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAziXAQQAAkEEAAAAAAAAAAEDw9wAAAAAAgD8AAIA/AACAP84lwEGA9/cAAAAAAM3MTD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAA==",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAPyUBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACc2EdBAAAAAAAAAAAQKXIAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABe7w0EAAAAAAAAAACe/IQDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAXS/DQQAAAAAAAAAAywAAAIAAAAAAAAAAAAAAAADMzEw/AAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAIA/AAAAAAjXIz8AAAAAAACAPwAAAIAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAACNcjPwAAAAAAAIA/AAAAAOziwEEAAAAAgD8AAIA/AACAP+ziwEGA9/cAAAAAAM3MTD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==",["controls"]={0.8,1.0,0.0,false,false,0.0,0.0,true,false,0.0,true}},{["frame"]=372,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297632,2},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj/NzMw8mpkZPs3MTD/bD0lALnQBul8cRFT7Ifk/PQqPQQAA4EABAAAAAACAPwIrBz0AAIA/AACAPwAAIEABAAAAdAEAAJOUB70oXxc/cJoXPxAAAABuOlk9AQAAABUkDUImz0lDyPelTD5SQ38+Dn6nPhAAAABkd2u8AQAAAPmWW0FzdoBCaisMRAOEGgDJ9XONP2QtMj/1Lac/EAAAAA0x6DoBAAAAt9MAQrbCq0QOyslDLGUVAMktAts+3vwPP/LhND8QAAAAjJEGOwEAAAACdABCuQEWREw/D0TUAAAAgAAAAIAAAAAAAAAAAMzMTD8AAACAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAACAAAAAAAIfGENrBftBebDJQCvw/z9lS9Y+Y/olO3myPDzcR0M7XDsbPUjMfz/lwAa+k+utO6bTdj7toOo8fXtuPV/PErsAAAAAAACAPwAAAAAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAI1yM/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAYNhS6AAAAAAgAAAAAAAAACNcjPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAAB72/pBAACQQQAAAAAAAAAAQPD3AAAAAACAPwAAgD8AAIA/e9v6QYD39wAAAAAAzcxMPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAA",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP3UBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD5lltBAAAAAAAAAAADhBoAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALfTAEIAAAAAAAAAACxlFQDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnQAQgAAAAAAAAAA1AAAAIAAAAAAAAAAAAAAAADMzEw/AAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAIA/AAAAAAjXIz8AAAAAAACAPwAAAIAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAACNcjPwAAAAAAAIA/AAAAAMKH+0EAAAAAgD8AAIA/AACAP8KH+0GA9/cAAAAAAM3MTD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==",["controls"]={0.8,1.0,0.0,false,false,0.0,0.0,true,false,0.0,true}},{["frame"]=390,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297632,2},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj/NzMw8mpkZPs3MTD/bD0lALnQBul8cRFT7Ifk/PQqPQQAA4EABAAAAAACAPwIrBz0AAIA/AACAPwAAIEABAAAAhgEAAKmAjr2uVeI/SHziPxAAAABFjlM9AQAAAPWzQUT/yB1DyPDtwLx8dZU/D3uVPxAAAAANaX+8AQAAAAJ/YUJmEMFEMrUxRIBfAQDJxXFaP6BXqD60HGo/EAAAAIpWLzsBAAAAWpcGQkjIU0STWcVDBsoTAMmC3qY+RStkPhJLyj4QAAAAC8xBOwEAAADtcQZC/c8eQ4YLJUSgAAAAgAAAAIAAAAAAAAAAAMzMTD8AAACAYBAYPgAAAACoPyU9AAAAAKg/JT2Hs2y+AAAAAFwrKEMTAANC05z6QBsphkD7HdY+R9GlupjqOTxWAFo7A+uDPVFzfz+Hlo493MWxOyzQjj7fn/Y8bYgZvbISHD0AAAAAAACAPwAAAAAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAI1yM/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAqD8lPQAAAADv/TC7AAAAAAgAAAAAAAAACNcjPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAACvwQNCAACQQQAAAAAAAAAAQPD3AAAAAACAPwAAgD8AAIA/r8EDQoD39wAAAAAAzcxMPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAA",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP4cBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACf2FCAAAAAAAAAACAXwEAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFqXBkIAAAAAAAAAAAbKEwDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA7XEGQgAAAAAAAAAAoAAAAIAAAAAAAAAAAAAAAADMzEw/AAAAgP0qhz0AAAAAfPaTPAAAAACoPyU98PDTvQAAAAAAAIA/AAAAAAjXIz8AAAAAAACAPwAAAIAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAB89pM8AAAAANSINrsAAAAACNcjPwAAAAAAAIA/AAAAAMARBEIAAAAAgD8AAIA/AACAP8ARBEKA9/cAAAAAAM3MTD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==",["controls"]={0.8,1.0,0.0,false,false,0.0,0.0,true,false,0.0,true}},{["frame"]=408,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297632,2},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj/NzMw8mpkZPs3MTD/bD0lALnQBul8cRFT7Ifk/PQqPQQAA4EABAAAAAACAPwIrBz0AAIA/AACAPwAAIEABAAAAmAEAAAtZAL0jT2c/Zm1nPxAAAADFAzA9AQAAAMfFN0QdGo5DyGJs5LwxMxA/eF8QPxAAAABHycm8AQAAABgpZkJOtTVEm9EcRHnx2ADJ510CP+7kzz1B7wQ/EAAAAJcLtDoBAAAAfDsMQgxSj0NPEPFD8FEQAMnYfa0+WhnRPPH/rT4QAAAAWPrYOgEAAABYBgxC44XHQka+HkQKAAAAgAAAAIAAAAAAAAAAAMzMTD8AAACAAisHPgAAAAAgKxM9AAAAAB4rEz2mzVK+AAAAAC7bOEPDFwhCUpgnQTDOw0D39NU+Kl6qOpBIwju++Us7+SO1Pa39fj/6Bqo9SJslOy8T/T0qfRM9DkkivSj+CT0AAAAAAACAPwAAAAAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAI1yM/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAICsTPQAAAABzx5E6AAAAAAgAAAAAAAAACNcjPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAAAT8wlCAACQQQAAAAAAAAAAQPD3AAAAAACAPwAAgD8AAIA/E/MJQoD39wAAAAAAzcxMPwAAAAAAAAAAAAAAAAAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAA",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP5kBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAYKWZCAAAAAAAAAAB58dgAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHw7DEIAAAAAAAAAAPBREADJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWAYMQgAAAAAAAAAACgAAAIAAAAAAAAAAAAAAAADMzEw/AAAAgML1KD4AAAAAyTc3PQAAAAAgKxM9XTiDvgAAAAAAAIA/AAAAAAjXIz8AAAAAAACAPwAAAIAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAADJNzc9AAAAAKcykDoAAAAACNcjPwAAAAAAAIA/AAAAALZGCkIAAAAAgD8AAIA/AACAP7ZGCkKA9/cAAAAAAM3MTD8AAAAAAAAAAAAAAAAAAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==",["controls"]={0.8,1.0,0.0,false,false,1.0,0.0,true,false,0.0,true}},{["frame"]=426,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297632,2},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj/NzMw8mpkZPs3MTD/bD0lALnQBul8cRFT7Ifk/PQqPQQAA4EABAAAAAACAPwIrBz0AAIA/AACAPwAAIEABAAAAqgEAAHg6xLwBZIw+WuyMPhAAAAB2SjE9AQAAAIXVYUHv+rtDyIl2tb0krW08Y2e4PRAAAABm28m8AQAAADtRa0JVBaw/OwMWRCWYFwDJGWrbPjxKLj7CHOw+EAAAAGB9hTkBAAAAxDIRQiv1MUMMmhFEE7oOAMmxhr0+/s7CPV22wz4QAAAAIK4MOgEAAAAWwxFCjq8HQ02sHERAAAAAgAAAAIAAAAAAAAAAAMzMTD8AAACAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAACAAAAAAL8VSkP24QtC3h1kQXbLCkF6ydU+xaQqu5fEqztRvFA7BLr7PdINfj/vbSC9nq5fOirCgDw2vRM9coO+PF/PErsAAAAAAACAPwAAAAAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAI1yM/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAgAAAAAAAAACNcjPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAABXyw9CAACQQQAAAAAAAAAAQPD3AAAAAACAPwAAgD8AAIA/V8sPQoD39wAAAAAAzcxMPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAA",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP6sBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA7UWtCAAAAAAAAAAAlmBcAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMQyEUIAAAAAAAAAABO6DgDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFsMRQgAAAAAAAAAAQAAAAIAAAAAAAAAAAAAAAADMzEw/AAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAIA/AAAAAAjXIz8AAAAAAACAPwAAAIAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAACNcjPwAAAAAAAIA/AAAAADwfEEIAAAAAgD8AAIA/AACAPzwfEEKA9/cAAAAAAM3MTD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==",["controls"]={0.8,1.0,0.0,false,false,0.0,0.0,true,false,0.0,true}},{["frame"]=512,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297632,2},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj/NzMw8mpkZPs3MTD/bD0lALnQBul8cRFT7Ifk/PQqPQQAA4EABAAAAAACAPwIrBz0AAIA/AACAPwAAIEABAAAAAAIAACLbS73ndBJAJnwSQBAAAABweVs9AQAAAIDaJUUKmlJDyIX/sbwdfMA/d3rAPxAAAAC9+3W8AQAAAM1JgULXUflFWRWORI3crP/I2mw4P+K+1D5Q6VQ/EAAAABWJUzsBAAAA0ycqQje8MkTQTwlEYiQAAMmOj38+00OVPnSnxD4QAAAAcfNlOwEAAAAf6SpCMiVUQ98JfURVAAAAgAAAAIAAAAAAAAAAAMzMTD8AAACAASuHPgAAAAAoBJA9AAAAACgEkD3ASc6+AAAAAMhckkMVUSFCazcZQnCdQkFQjNQ+3WCtu0I5Szy29Jc7ft4YPswbfT+4VNo9v9uxO5SamD4MKAI9XpRtva1tiz0AAAAAAACAPwAAAAAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAI1yM/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAKASQPQAAAADHJok6AAAAAAgAAAAAAAAACNcjPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAADlTihCAACQQQAAAAAAAAAAQPD3AAAAAACAPwAAgD8AAIA/5U4oQoD39wAAAAAAzcxMPwAAAAAAAAAAAAAAAAAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAA",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAPwECAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADNSYFCAAAAAAAAAACN3Kz/yAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANMnKkIAAAAAAAAAAGIkAADJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH+kqQgAAAAAAAAAAVQAAAIAAAAAAAAAAAAAAAADMzEw/AAAAgGEQmD4AAAAA9sWgPQAAAAAoBJA9cErmvgAAAAAAAIA/AAAAAAjXIz8AAAAAAACAPwAAAIAAAAAAAAAAAAjXIz8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAD2xaA9AAAAAHEOhjoAAAAACNcjPwAAAAAAAIA/AAAAAH9+KEIAAAAAgD8AAIA/AACAP39+KEKA9/cAAAAAAM3MTD8AAAAAAAAAAAAAAAAAAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==",["controls"]={0.8,1.0,0.0,false,false,1.0,0.0,true,false,0.0,true}}}},{["name"]="linear",["steer"]={["linearity"]=80,["momentum"]=0},["ratio"]=nil,["quick"]=4,["start"]={{["frame"]=0,["beforeRuns"]={{7247832,1},{7247908,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267524,1},{7271624,2},{7273160,1},{7273256,1},{7293516,1},{7295936,1},{7297528,2},{7297584,1},{7297628,3},{7653748,1},{7653772,2},{7653784,1},{7653792,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAP83MTD4AAAAACtcjPM3MzD1mZmY/mpkZPnsUrkfheoQ/SOF6P83MTD/bD0lAq6qqPQAAREEudAG6A/oOPD0KD0E9Co9BAADgQAEAAAAAAIA/AACAPwAAgD8BAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHXuKwAAAAAAAAAAAAAAAADJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAde4AAAAAAAAAAAAAAAA4AMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB1AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPQrXPgAAAAAAAAAAAAAAAAAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADMzEw/AAAAAAAAAAAAAAAAAAAAAAAAkEEAAAAAAAAAAEDw9wAAAAAAAAAAAAAAAAAAAAAAAACA9/cAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAA==",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAPwEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB17isAAAAAAAAAAAAAAAAAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHXuAAAAAAAAAAAAAAAAOADJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAdQAAAAAAAAAAAAAAADmOYzoAAAAAAAAAAAAAAAAAAAAAAAAAgDBr7LgAAAAAAAAAAAnXIzwAAAAAAAAAAAAAAAAAAAAAOY7jOwAAgD8AAAA+AAAAAAAAAAAAAAAAOY7jOwAAgD8AAAAAAAAAAAAAAAAAAAAAMGvsuAAAAAAwa2y3AAAAAAAAAACrqqo9AACAPwAAAAAAAAAAAAAAAIA/AACAPwAAgD8AAAAAgPf3AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAK1yM8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAA=",["controls"]={0.0,1.0,0.0,false,false,0.0,0.0,true,true,0.01,true}},{["frame"]=16,["beforeRuns"]={{7247832,1},{7247908,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267524,1},{7271624,2},{7273160,1},{7273256,1},{7293516,1},{7295936,1},{7297528,2},{7297584,1},{7297628,3},{7653748,1},{7653772,2},{7653784,1},{7653792,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAP83MTD4AAAAACtcjPM3MzD1mZmY/mpkZPnsUrkfheoQ/SOF6P83MTD/bD0lAq6qqPQAAREEudAG6A/oOPD0KD0E9Co9BAADgQAEAAAAAAIA/AACAPwAAgD8BAAAAEAAAAOnLfr034hO9OU2TPRAAAACm+xA9AQAAAAAAAAAAAAAAyaJFiL3yjCS9qSufPRAAAAB94RG9AQAAAA/wKzsAAAAAAAAAABZA+QDJVWuaPLMcprqgu5s8EAAAAC2C+7gBAAAAD/A5PAAAAAAAAAAAxvE3AMkE+6A807hrudwwoTwQAAAAxAFHOQEAAAAPKYo8AAAAAAAAAADF2N3dO8mrCT4AAAAAAAAAAAAAAAAAAACAC2vsuAAAAAASa+y4+9YjPAAAAAC62t+6fb4hvQQluDrbxkS708TLPq/Q9rwEF5C4EjZzu05PuTmN/38/kmgDPP2tzr2GCSK6vtBBPajTnb24Mhq7AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAzKsJPgAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAMyrCT4AAIA/AAAAAAAAAAAAAAAAAAAAAAtr7LgAAAAAkyQhrgAAAAAIAAAAAAAAAAAAAIC7u7s+AACAPwAAAADMzEw/AAAAAAAAAAAAAAAAXRwWPgAAkEEAAAAAAAAAAEDw9wAAAAAAgD8AAIA/AACAP10cFj6A9/cAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAArXIzwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAIAAAAAAAAAAAA==",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAPxEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP8Cs7AAAAAAAAAAAWQPkAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/wOTwAAAAAAAAAAMbxNwDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADymKPAAAAAAAAAAAxbRgCzzMqwk+AAAAAAAAAAAAAAAAAAAAgC1r7LgAAAAAC2vsuAjXIzwAAAAAAACAPwAAAAAAAAAAJlxPPgAAgD8AAACAAAAAAAAAAAAAAAAAJlxPPgAAgD8AAAAAAAAAAAAAAAAAAAAALWvsuAAAAAAlSQauAAAAAAAAAABlZuY+AACAPwAAAABy0Us9AAAAAIA/AACAPwAAgD9y0Us9gPf3AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAK1yM8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAA=",["controls"]={0.0,1.0,0.0,false,false,0.0,0.0,true,true,0.01,true}},{["frame"]=34,["beforeRuns"]={{7247832,1},{7247908,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267524,1},{7271624,2},{7273160,1},{7273256,1},{7293516,1},{7295936,1},{7297528,2},{7297584,1},{7297628,3},{7653748,1},{7653772,2},{7653784,1},{7653792,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAP83MTD4AAAAACtcjPM3MzD1mZmY/mpkZPnsUrkfheoQ/SOF6P83MTD/bD0lAq6qqPQAAREEudAG6A/oOPD0KD0E9Co9BAADgQAEAAAAAAIA/AACAPwAAgD8BAAAAIgAAABnYhTxhj8G8KVLrPBAAAAAMchU9AQAAAAAAAAAAAAAAyeG6jzy5Jum8yPQIPRAAAAB4xQi9AQAAANzxKzkAAAAAAAAAAEXcVwDJgE5yOylVJrxLGjE8EAAAAJdHA7kBAAAA3PHmOAAAAAAAAAAAqxI2AMm358u9BDMZvMPDzD0QAAAA/ogdOQEAAADcHvI4AAAAAAAAAAA6AAAAgMbcdT8AAAAAAAAAAAAAAAAAAACABJoXvQAAAAAEmhe9//9/PgAAAAAyTyA7bzqNuasfjjrQdwK6GLvVPoKdATvfqgs59kmDO8ENlTl3/38/aPoWuqzelzqj5Yu3I3M6Padfkrr6xiC9AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAxtx1PwAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAMbcdT8AAIA/AAAAAAAAAAAAAAAAAAAAAASaF70AAAAAJEmSLwAAAAAIAAAAAAAAAAAAAIBI4Xo/AACAPwAAAADMzEw/AAAAAAAAAAAAAAAAh7zcOwAAkEEAAAAAAAAAAEDw9wAAAAAAgD8AAIA/AACAP4e83DuA9/cAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgD4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAIAAAAAAAAAAAA==",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAPyMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADc8Ss5AAAAAAAAAABF3FcAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANzx5jgAAAAAAAAAAKsSNgDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA3B7yOAAAAAAAAAAAOgAAAIDG3HU/AAAAAAAAAAAAAAAAAAAAgASaF70AAAAABJoXvf//fz4AAAAAAACAPwAAAAAAAAAAxtx1PwAAgD8AAACAAAAAAAAAAAAAAAAAxtx1PwAAgD8AAAAAAAAAAAAAAAAAAAAABJoXvQAAAAAkSZIvAAAAAAAAAABI4Xo/AACAPwAAAAAp0QY7AAAAAIA/AACAPwAAgD8p0QY7gPf3AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIA+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAA=",["controls"]={0.0,1.0,0.0,false,false,0.0,0.0,true,true,0.25,true}},{["frame"]=52,["beforeRuns"]={{7247832,1},{7247908,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267524,1},{7271624,2},{7273160,1},{7273256,1},{7293516,1},{7295936,1},{7297528,2},{7297584,1},{7297628,3},{7653748,1},{7653772,2},{7653784,1},{7653792,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAP83MTD4AAAAACtcjPM3MzD1mZmY/mpkZPnsUrkfheoQ/SOF6P83MTD/bD0lAq6qqPQAAREEudAG6A/oOPD0KD0E9Co9BAADgQAEAAAAAAIA/AACAPwAAgD8BAAAANAAAAGE//jz23cW8SBEhPRAAAADiFh49AQAAAAAAAAAAAAAAye1oOD1jHeu8VKdaPRAAAADxsOq8AQAAALbzKzgAAAAAAAAAAAY8mADJWoZLPLIjKL3Jpy89EAAAALb+mbgBAAAAtvObNwAAAAAAAAAAqIQ0AMlL3bW9x3MkvXyOxz0QAAAAHWRSOQEAAAC2HTw3AAAAAAAAAABOAAAAgMbcdT8AAAAAAAAAAAAAAAAAAACAFPoDvgAAAAAU+gO+////PgAAAABlAxo7UN2eOT1bPzqchdS66zjWPidkxzoE3485PFCNO66dkjlh/38/hzFMugUcmjrm9eA4y105PVXnfTpSRQa+AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAxtx1PwAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAMbcdT8AAIA/AAAAAAAAAAAAAAAAAAAAABT6A74AAAAAAAAAgAAAAAAIAAAAAAAAAAAAAIBI4Xo/AACAPwAAAADMzEw/AAAAAAAAAAAAAAAALaQUOwAAkEEAAAAAAAAAAEDw9wAAAAAAgD8AAIA/AACAPy2kFDuA9/cAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAIAAAAAAAAAAAA==",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAPzUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC28ys4AAAAAAAAAAAGPJgAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALbzmzcAAAAAAAAAAKiENADJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAth08NwAAAAAAAAAATgAAAIDG3HU/AAAAAAAAAAAAAAAAAAAAgBT6A74AAAAAFPoDvv///z4AAAAAAACAPwAAAAAAAAAAxtx1PwAAgD8AAACAAAAAAAAAAAAAAAAAxtx1PwAAgD8AAAAAAAAAAAAAAAAAAAAAFPoDvgAAAAAAAACAAAAAAAAAAABI4Xo/AACAPwAAAADiDRM7AAAAAIA/AACAPwAAgD/iDRM7gPf3AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAA=",["controls"]={0.0,1.0,0.0,false,false,0.0,0.0,true,true,0.5,true}},{["frame"]=70,["beforeRuns"]={{7247832,1},{7247908,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267524,1},{7271624,2},{7273160,1},{7273256,1},{7293516,1},{7295936,1},{7297528,2},{7297576,3},{7297628,3},{7653748,1},{7653772,2},{7653784,1},{7653792,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAP83MTD4AAAAACtcjPM3MzD1mZmY/mpkZPnsUrkfheoQ/SOF6P83MTD/bD0lAq6qqPQAAREEudAG6RhdddNFF1z8D+g48PQoPQT0Kj0EAAOBAAQAAAAAAgD8AAIA/AACAPwEAAABGAAAAhHgkPu8TVj3CBS0+EAAAAKl8ID0BAAAAAAAAAAAAAADJVrmHPjFbfz1ldYs+EAAAAMImqbwBAAAAAPgrPgAAAAAAAAAAu9DeAMlwDA9A6QVSvdAUD0AQAAAADI8ruQEAAADzA4k/AAAAAAAAAAAsujMAyfHK4kA5wS69OcXiQBAAAAA7jd84AQAAADUltj4AAAAAAAAAAH8AAACACtcjPQAAAAAAAAAAAAAAAAAAAIC26Ii+AAAAALboiL7//z8/AAAAAH+L+ToZyMg8sbO0uePZ8Tk16dU+3YRSOUpskDljzKk7R7vxNx3/fz+vluq7w4H0OzzHXDqQ00I90zpyPFUOir4AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAK1yM9AACAPwAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAACtcjPQAAgD8AAAAAAAAAAAAAAAAAAAAAtuiIvgAAAAC2bVsxAAAAAAgAAAAAAAAAAAAAgM3MTD4AAIA/AAAAAMzMTD8AAAAAAAAAAAAAAABpWaQ8AACQQQAAAAAAAAAAQPD3AAAAAACAPwAAgD8AAIA/aVmkPID39wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAgAAAAAAAAAAA",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP0cAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA+Cs+AAAAAAAAAAC70N4AyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPMDiT8AAAAAAAAAACy6MwDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANSW2PgAAAAAAAAAAfwAAAIAK1yM9AAAAAAAAAAAAAAAAAAAAgLboiL4AAAAAtuiIvv//Pz8AAAAAAACAPwAAAAAAAAAACtcjPQAAgD8AAACAAAAAAAAAAAAAAAAACtcjPQAAgD8AAAAAAAAAAAAAAAAAAAAAtuiIvgAAAAC2bVsxAAAAAAAAAADNzEw+AACAPwAAAADs0sg8AAAAAIA/AACAPwAAgD/s0sg8gPf3AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEA/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAA=",["controls"]={0.0,1.0,0.0,false,false,0.0,0.0,true,true,0.75,true}},{["frame"]=88,["beforeRuns"]={{7247832,1},{7247908,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267524,1},{7271624,2},{7273160,1},{7273256,1},{7293516,1},{7295936,1},{7297528,2},{7297576,3},{7297628,3},{7653748,1},{7653772,2},{7653784,1},{7653792,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAP83MTD4AAAAACtcjPM3MzD1mZmY/mpkZPnsUrkfheoQ/SOF6P83MTD/bD0lAq6qqPQAAREEudAG6RhdddNFF1z8D+g48PQoPQT0Kj0EAAOBAAQAAAAAAgD8AAIA/AACAPwEAAABYAAAArgPKQH8Nwz3a/8lAEAAAADCQDj0BAAAAAAAAAAAAAADJK4hdP93+7j2Bhl8/EAAAAPPou7sBAAAAQQYsPwAAAAAAAAAAZPuHAMnzEIlANWkuvX8SiUAQAAAA3oLkuAEAAAB4Fso/EodgQweV/D5+8jEAyf90s0HPcYy8UnKzQRAAAADnpyU5AQAAALELVzsAAAAAAAAAAIUAAACACtcjPQAAAAAAAAAAAAAAAAAAAID3yOW+AAAAAPfI5b79/38/AAAAAEvWLjzigz0904hHu0cNM7ylitU+W0t2OReN5znL1cE78cFYutL+fz9dE8S5nZxoO2P4EbyR6kk9fRXVPJbu5r4AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAK1yM9AACAPwAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAACtcjPQAAgD8AAAAAAAAAAAAAAAAAAAAA98jlvgAAAAAkSRIwAAAAAAgAAAAAAAAAAAAAgM3MTD4AAIA/AAAAAMzMTD8AAAAAAAAAAAAAAACzST89AACQQQAAAAAAAAAAQPD3AAAAAACAPwAAgD8AAIA/s0k/PYD39wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAgAAAAAAAAAAA",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP1kAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBBiw/AAAAAAAAAABk+4cAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHgWyj8AAAAAAAAAAH7yMQDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAsQtXOwAAAAAAAAAAhQAAAIAK1yM9AAAAAAAAAAAAAAAAAAAAgPfI5b4AAAAA98jlvv3/fz8AAAAAAACAPwAAAAAAAAAACtcjPQAAgD8AAACAAAAAAAAAAAAAAAAACtcjPQAAgD8AAAAAAAAAAAAAAAAAAAAA98jlvgAAAAAkSRIwAAAAAAAAAADNzEw+AACAPwAAAAB0u0I9AAAAAIA/AACAPwAAgD90u0I9gPf3AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAA=",["controls"]={0.0,1.0,0.0,false,false,0.0,0.0,true,true,1.0,true}},{["frame"]=106,["beforeRuns"]={{7247832,1},{7247908,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267524,1},{7271624,2},{7273160,1},{7273256,1},{7293516,1},{7295936,1},{7297528,2},{7297576,3},{7297628,3},{7653748,1},{7653772,2},{7653784,1},{7653792,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAP83MTD4AAAAACtcjPM3MzD1mZmY/mpkZPnsUrkfheoQ/SOF6P83MTD/bD0lAq6qqPQAAREEudAG6RhdddNFF1z8D+g48PQoPQT0Kj0EAAOBAAQAAAAAAgD8AAIA/AACAPwEAAABqAAAA0oKsQQR2gjyHfqxBEAAAAAGCDz0BAAAAAAAAAAAAAADJpogeQflA5zzdhB5BEAAAAGahF70BAAAA6PorPgAAAAAAAAAA5SnIAMnjwphA08eWvG7AmEAQAAAA+mUquQEAAACsGc0/a7iEQwtEEj87ijAAyQ/09EEv+hk8nvP0QRAAAACG7tw4AQAAAM/iiTwAAAAAAAAAADgAAACACtcjPQAAAAAAAAAAAAAAAAAAAIAsa+w4AAAAACxr7DgJ1yO8AAAAAIdmlDzdMPc8GkTsurMAhTlFH9Y+G8neufR7GbpDKrs7ow0guuf+fz/gNWk4Hw1aO1Dvj7kA/Ek9KzrsPAZsC7sAAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAK1yM9AACAPwAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAACtcjPQAAgD8AAAAAAAAAAAAAAAAAAAAALGvsOAAAAAAkSRIrAAAAAAgAAAAAAAAAAAAAgM3MTD4AAIA/AAAAAMzMTD8AAAAAAAAAAAAAAABvfAM9AACQQQAAAAAAAAAAQPD3AAAAAACAPwAAgD8AAIA/b3wDPYD39wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAK1yM8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAgAAAAAAAAAAA",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP2sAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADo+is+AAAAAAAAAADlKcgAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKwZzT8AAAAAAAAAADuKMADJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAz+KJPAAAAAAAAAAAOAAAAIAK1yM9AAAAAAAAAAAAAAAAAAAAgC5r7DgAAAAALGvsOArXI7wAAAAAAACAPwAAAAAAAAAACtcjPQAAgD8AAACAAAAAAAAAAAAAAAAACtcjPQAAgD8AAAAAAAAAAAAAAAAAAAAALmvsOAAAAABt2zYsAAAAAAAAAADNzEw+AACAPwAAAABfOfc8AAAAAIA/AACAPwAAgD9fOfc8gPf3AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAArXIzwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAA=",["controls"]={0.0,1.0,0.0,false,false,0.0,0.0,true,true,-0.01,true}},{["frame"]=124,["beforeRuns"]={{7247832,1},{7247908,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267524,1},{7271624,2},{7273160,1},{7273256,1},{7293516,1},{7295936,1},{7297528,2},{7297576,3},{7297628,3},{7653748,1},{7653772,2},{7653784,1},{7653792,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAP83MTD4AAAAACtcjPM3MzD1mZmY/mpkZPnsUrkfheoQ/SOF6P83MTD/bD0lAq6qqPQAAREEudAG6RhdddNFF1z8D+g48PQoPQT0Kj0EAAOBAAQAAAAAAgD8AAIA/AACAPwEAAAB8AAAAAHb1QdslEr2pdfVBEAAAAFAcCz0BAAAAAAAAAAAAAADJVkDDQbQvO72FOMNBEAAAAEdNFb0BAAAAGPwrPQAAAAAAAAAAz7TAAMn0zq1AoCTXPH3LrUAQAAAA5d1QuQEAAADnHdQ/WEPFQ95WVj899i4AyfmXX0FvoxQ9Z5BfQRAAAABeKpY4AQAAAP8OKj0AAAAAAAAAAH8AAACACtcjPQAAAAAAAAAAAAAAAAAAAIACmhc9AAAAAAKaFz3//3++AAAAANoMfDy54sI7CE7auhSFCzvemdY+5aiTu6H2NDZLeqU79nb/uSf/fz9f3q87sxvbumDGobuPtD09lsq7PAxtDj0AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAK1yM9AACAPwAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAACtcjPQAAgD8AAAAAAAAAAAAAAAAAAAAAApoXPQAAAAAkSRIvAAAAAAgAAAAAAAAAAAAAgM3MTD4AAIA/AAAAAMzMTD8AAAAAAAAAAAAAAACReLU7AACQQQAAAAAAAAAAQPD3AAAAAACAPwAAgD8AAIA/kXi1O4D39wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIA+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAgAAAAAAAAAAA",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP30AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAY/Cs9AAAAAAAAAADPtMAAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOcd1D8AAAAAAAAAAD32LgDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/w4qPQAAAAAAAAAAfwAAAIAK1yM9AAAAAAAAAAAAAAAAAAAAgAKaFz0AAAAAApoXPf//f74AAAAAAACAPwAAAAAAAAAACtcjPQAAgD8AAACAAAAAAAAAAAAAAAAACtcjPQAAgD8AAAAAAAAAAAAAAAAAAAAAApoXPQAAAAAkSRIvAAAAAAAAAADNzEw+AACAPwAAAACfQ/47AAAAAIA/AACAPwAAgD+fQ/47gPf3AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgD4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAA=",["controls"]={0.0,1.0,0.0,false,false,0.0,0.0,true,true,-0.25,true}},{["frame"]=142,["beforeRuns"]={{7247832,1},{7247908,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267524,1},{7271624,2},{7273160,1},{7273256,1},{7293516,1},{7295936,1},{7297528,2},{7297576,3},{7297628,3},{7653748,1},{7653772,2},{7653784,1},{7653792,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAP83MTD4AAAAACtcjPM3MzD1mZmY/mpkZPnsUrkfheoQ/SOF6P83MTD/bD0lAq6qqPQAAREEudAG6RhdddNFF1z8D+g48PQoPQT0Kj0EAAOBAAQAAAAAAgD8AAIA/AACAPwEAAACOAAAAYw4DQi+qY71vDgNCEAAAAPOr6zwBAAAAAAAAAAAAAADJnfL4QWh8kb2r8vhBEAAAAPefJr0BAAAANv4rOwAAAAAAAAAAqzrCAMlk6sZAsvkLPdbhxkAQAAAADvo4uQEAAADuHc0/0DSAQ/49BT+WuCwAySYGI0Dv4QA9FwUjQBAAAADJfcA4AQAAALxsyT/+1f9CG1a+Pn8AAACACtcjPQAAAAAAAAAAAAAAAAAAAIAS+gM+AAAAABL6Az7///++AAAAAIecLjykmY88QMDnuZE90Tri6NU+AAyIubKxi7oMprg7NAzpuen+fz9Bfd4489GnO/0wKTrNxEo985IDPdSuAT4AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAK1yM9AACAPwAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAACtcjPQAAgD8AAAAAAAAAAAAAAAAAAAAAEvoDPgAAAAAkSRIwAAAAAAgAAAAAAAAAAAAAgM3MTD4AAIA/AAAAAMzMTD8AAAAAAAAAAAAAAABoNJI8AACQQQAAAAAAAAAAQPD3AAAAAACAPwAAgD8AAIA/aDSSPID39wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAgAAAAAAAAAAA",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP48AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA2/is7AAAAAAAAAACrOsIAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAO4dzT8AAAAAAAAAAJa4LADJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAvGzJPwAAAAAAAAAAfwAAAIAK1yM9AAAAAAAAAAAAAAAAAAAAgBL6Az4AAAAAEvoDPv///74AAAAAAACAPwAAAAAAAAAACtcjPQAAgD8AAACAAAAAAAAAAAAAAAAACtcjPQAAgD8AAAAAAAAAAAAAAAAAAAAAEvoDPgAAAAAkSRIwAAAAAAAAAADNzEw+AACAPwAAAADHNZA8AAAAAIA/AACAPwAAgD/HNZA8gPf3AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAA=",["controls"]={0.0,1.0,0.0,false,false,0.0,0.0,true,true,-0.5,true}},{["frame"]=160,["beforeRuns"]={{7247832,1},{7247908,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267524,1},{7271624,2},{7273160,1},{7273256,1},{7293516,1},{7295936,1},{7297528,2},{7297576,3},{7297628,3},{7653748,1},{7653772,2},{7653784,1},{7653792,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAP83MTD4AAAAACtcjPM3MzD1mZmY/mpkZPnsUrkfheoQ/SOF6P83MTD/bD0lAq6qqPQAAREEudAG6RhdddNFF1z8D+g48PQoPQT0Kj0EAAOBAAQAAAAAAgD8AAIA/AACAPwEAAACgAAAAYMIKQircNr0twgpCEAAAAI2CoTwBAAAAAAAAAAAAAADJaUMKQjcjm71NQwpCEAAAAOAEKL0BAAAAggAsOwAAAAAAAAAA1GjCAMmEG91AqXQGPa4S3UAQAAAA1GlTuQEAAAAsIM0/8/t6Q15rAD89cysAyW0iVUBaRwE9BxpVQBAAAABl1ok4AQAAAA2+zD9U30BD/cf2PuIAAACACtcjPQAAAAAAAAAAAAAAAAAAAIC16Ig+AAAAALXoiD4AAEC/AAAAADZipzvMDjM8X1wiukCALDsE+dU+zZPmuf5Gr7p06b47+dkfutD+fz+9uTy6othkO1STaDoP7Uk9IHr1PBbDhz4AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAK1yM9AACAPwAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAACtcjPQAAgD8AAAAAAAAAAAAAAAAAAAAAteiIPgAAAAAkSRIwAAAAAAgAAAAAAAAAAAAAgM3MTD4AAIA/AAAAAMzMTD8AAAAAAAAAAAAAAAC7mz88AACQQQAAAAAAAAAAQPD3AAAAAACAPwAAgD8AAIA/u5s/PID39wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEA/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAgAAAAAAAAAAA",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP6EAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACCACw7AAAAAAAAAADUaMIAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACwgzT8AAAAAAAAAAD1zKwDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADb7MPwAAAAAAAAAA4gAAAIAK1yM9AAAAAAAAAAAAAAAAAAAAgLXoiD4AAAAAteiIPgAAQL8AAAAAAACAPwAAAAAAAAAACtcjPQAAgD8AAACAAAAAAAAAAAAAAAAACtcjPQAAgD8AAAAAAAAAAAAAAAAAAAAAteiIPgAAAAAkSRIwAAAAAAAAAADNzEw+AACAPwAAAACZUTg8AAAAAIA/AACAPwAAgD+ZUTg8gPf3AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAA=",["controls"]={0.0,1.0,0.0,false,false,0.0,0.0,true,true,-0.75,true}},{["frame"]=178,["beforeRuns"]={{7247832,1},{7247908,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267524,1},{7271624,2},{7273160,1},{7273256,1},{7293516,1},{7295936,1},{7297528,2},{7297576,3},{7297628,3},{7653748,1},{7653772,2},{7653784,1},{7653792,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAP83MTD4AAAAACtcjPM3MzD1mZmY/mpkZPnsUrkfheoQ/SOF6P83MTD/bD0lAq6qqPQAAREEudAG6RhdddNFF1z8D+g48PQoPQT0Kj0EAAOBAAQAAAAAAgD8AAIA/AACAPwEAAACyAAAAwVwOQjjqNr0xXA5CEAAAAJISezsBAAAAAAAAAAAAAADJ8egQQlGC4L0g6BBCEAAAALFtFr0BAAAA3wIsOwAAAAAAAAAABqfCAMn6ifVA0t3lPO+J9UAQAAAAIjx1uQEAAAB2Isw/a95zQ2xy9j6oKSkAyXIAiUApP+k8CgGJQBAAAADMagg4AQAAAF2TzD+8QktDVSfrPv0AAACACtcjPQAAAAAAAAAAAAAAAAAAAID4yOU+AAAAAPjI5T7//3+/AAAAANqWertFiYY7cBbyuhWbJjspq9U+lk0TuuPK6rqX7MU7b06buqb+fz9dsx66+R9UO3Gm+DnNkUk9e47qPFmj5D4AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAK1yM9AACAPwAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAACtcjPQAAgD8AAAAAAAAAAAAAAAAAAAAA+MjlPgAAAAAAAACAAAAAAAgAAAAAAAAAAAAAgM3MTD4AAIA/AAAAAMzMTD8AAAAAAAAAAAAAAAArrrE7AACQQQAAAAAAAAAAQPD3AAAAAACAPwAAgD8AAIA/K66xO4D39wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAgAAAAAAAAAAA",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP7MAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADfAiw7AAAAAAAAAAAGp8IAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHYizD8AAAAAAAAAAKgpKQDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAXZPMPwAAAAAAAAAA/QAAAIAK1yM9AAAAAAAAAAAAAAAAAAAAgPjI5T4AAAAA+MjlPv//f78AAAAAAACAPwAAAAAAAAAACtcjPQAAgD8AAACAAAAAAAAAAAAAAAAACtcjPQAAgD8AAAAAAAAAAAAAAAAAAAAA+MjlPgAAAAAAAACAAAAAAAAAAADNzEw+AACAPwAAAABVTp87AAAAAIA/AACAPwAAgD9VTp87gPf3AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAA=",["controls"]={0.0,1.0,0.0,false,false,0.0,0.0,true,true,-1.0,true}},{["frame"]=196,["beforeRuns"]={{7247832,1},{7247908,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267524,1},{7271624,2},{7273160,1},{7273256,1},{7293516,1},{7295936,1},{7297528,2},{7297576,3},{7297628,3},{7653748,1},{7653772,2},{7653784,1},{7653792,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAP83MTD4AAAAACtcjPM3MzD1mZmY/mpkZPnsUrkfheoQ/SOF6P83MTD/bD0lAq6qqPQAAREEudAG6RhdddNFF1z8D+g48PQoPQT0Kj0EAAOBAAQAAAAAAgD8AAIA/AACAPwEAAADEAAAAK1QQQmbkxrxLUxBCEAAAAMPADj0BAAAAAAAAAAAAAADJo14UQq+olb0JXRRCEAAAAPFaGL0BAAAATAUsOwAAAAAAAAAAX6/CAMnAbwlBuvXePMZvCUEQAAAArj0uuQEAAAAdJMo/USNHQ11OxT4M2ScAyZ6ApkApBvA8e3ymQBAAAABm89Q4AQAAAPs0zT/x9mVDOLP6PnoAAACACtcjPQAAAAAAAAAAAAAAAAAAAIAAAACAAAAAAAAAAIAAAACAAAAAAC5JZrxkyeU7wp8wu7YuxDj/KtY+WBwquhT4NLoKObw7Cdivutj+fz/Mwxu6ZVtRO5FfpjiUYUo9bqfyPF/PErsAAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAK1yM9AACAPwAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAACtcjPQAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAACAAAAAAAgAAAAAAAAAAAAAgM3MTD4AAIA/AAAAAMzMTD8AAAAAAAAAAAAAAAD62Nc7AACQQQAAAAAAAAAAQPD3AAAAAACAPwAAgD8AAIA/+tjXO4D39wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAgAAAAAAAAAAA",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP8UAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABMBSw7AAAAAAAAAABfr8IAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB0kyj8AAAAAAAAAAAzZJwDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA+zTNPwAAAAAAAAAAegAAAIAK1yM9AAAAAAAAAAAAAAAAAAAAgAAAAIAAAAAAAAAAgAAAAIAAAAAAAACAPwAAAAAAAAAACtcjPQAAgD8AAACAAAAAAAAAAAAAAAAACtcjPQAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAACAAAAAAAAAAADNzEw+AACAPwAAAADuyeY7AAAAAIA/AACAPwAAgD/uyeY7gPf3AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAA=",["controls"]={0.0,1.0,0.0,false,false,0.0,0.0,true,true,0.0,true}},{["frame"]=372,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267524,1},{7273256,1},{7293516,1},{7297528,2},{7297628,3},{7653748,1},{7653772,4},{7653792,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj+amRk+zcxMP9sPSUAAAERBLnQBuj0KD0E9Co9BAADgQAEAAAAAAIA/AACAPwAAgD8AAIA/AQAAAHQBAAAiOpxA1i1hPSU5nEAQAAAAjswSPQEAAAAyo+REOLAYQsnbJJ4+//ozvtYptj4QAAAAHMMHvQEAAABGRy5AiJiEQqRMKEI36wcAyeZ1Yj6trC89iLNmPhAAAADO98u4AQAAANzD60Bsbf1BvDVXQmX1DwDJFf9gPmuY9bzwEmM+EAAAAIlOOzkBAAAAxL/rQP2aAEJYcVlC9AAAAIAAAACAAAAAAAAAAACZmRk/AAAAgHMoBbsAAAAAdCgFuw8yTD0AAAAACYJ9QXWu5ECcAQq8cw0KO42d1j4UWd66To5FOkzofzuJUA86eP9/Pym1gbu+8QE73Zlju8orMD1f9QI96vuLuwAAAAAAAIA/AAAAAAAAAAAAAAAA6lG4PgAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAOpRuD4AAAAAAACAPwAAAAAAAAAAAAAAAAAAAABzKAW7AAAAAG3beDIAAAAACAAAAAAAAADqUbg+AAAAAAAAgD8AAAAAzMxMPwAAAAAAAAAAAAAAAFo940AAAJBBAAAAAAAAAABA8PcAAAAAAIA/AACAPwAAgD9aPeNAgPf3AAAAAACamRk/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADNzEw9AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAACAAAAAAAAAAAA=",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP3UBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABGRy5AAAAAAAAAAAA36wcAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANzD60AAAAAAAAAAAGX1DwDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAxL/rQAAAAAAAAAAA9AAAAIAAAAAAAAAAAAAAAACZmRk/AAAAgComBbsAAAAAcygFux0wTD0AAAAAAACAPwAAAADqUbg+AAAAAAAAgD8AAACAAAAAAAAAAADqUbg+AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAKiYFuwAAAABJUpIyAAAAAOpRuD4AAAAAAACAPwAAAAB2ruRAAAAAAIA/AACAPwAAgD92ruRAgPf3AAAAAACamRk/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADNzEw9AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAA=",["controls"]={0.6,1.0,0.0,false,false,0.0,0.0,true,true,0.05,true}},{["frame"]=390,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267524,1},{7273256,1},{7293516,1},{7297528,2},{7297628,3},{7653748,1},{7653772,4},{7653792,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj+amRk+zcxMP9sPSUAAAERBLnQBuj0KD0E9Co9BAADgQAEAAAAAAIA/AACAPwAAgD8AAIA/AQAAAIYBAACAhEVAZgpvPTSFRUAQAAAAs3ESPQEAAABbhStFhGs6Qsmw/Zk+pxgzvrVZsj4QAAAAcEAIvQEAAADcwy5ARhyLQtGuWEJU0QQAyVR9Zj7rwTM9ZtFqPhAAAADMUbm4AQAAAC8Z+UBmOtI/NuNuQrm3CwDJZ/ZhPlvg7rz+5mM+EAAAANFSRDkBAAAAEpP5QOe0bz+Bi3FCnAAAAIAAAACAAAAAAAAAAACZmRk/AAAAgDYFBbsAAAAAOwUFuwgUTD0AAAAAYKOcQbQu+kC6t/G7y1M+u9Co1j4QeBi7z6g1OlgbgjtsgXM5dv9/PxmkEbvgL486NWGquwOpMD1jT/08TeqLuwAAAAAAAIA/AAAAAAAAAAAAAAAA6lG4PgAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAOpRuD4AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAA2BQW7AAAAALbtUjIAAAAACAAAAAAAAADqUbg+AAAAAAAAgD8AAAAAzMxMPwAAAAAAAAAAAAAAAJGd+EAAAJBBAAAAAAAAAABA8PcAAAAAAIA/AACAPwAAgD+RnfhAgPf3AAAAAACamRk/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADNzEw9AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAACAAAAAAAAAAAA=",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP4cBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADcwy5AAAAAAAAAAABU0QQAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC8Z+UAAAAAAAAAAALm3CwDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEpP5QAAAAAAAAAAAnAAAAIAAAAAAAAAAAAAAAACZmRk/AAAAgIICBbsAAAAANgUFu7oRTD0AAAAAAACAPwAAAADqUbg+AAAAAAAAgD8AAACAAAAAAAAAAADqUbg+AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAggIFuwAAAADbNq0yAAAAAOpRuD4AAAAAAACAPwAAAAC1LvpAAAAAAIA/AACAPwAAgD+1LvpAgPf3AAAAAACamRk/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADNzEw9AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAA=",["controls"]={0.6,1.0,0.0,false,false,0.0,0.0,true,true,0.05,true}},{["frame"]=407,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267524,1},{7273256,1},{7293516,1},{7297528,2},{7297628,3},{7653748,1},{7653772,4},{7653792,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj+amRk+zcxMP9sPSUAAAERBLnQBuj0KD0E9Co9BAADgQAEAAAAAAIA/AACAPwAAgD8AAIA/AQAAAJcBAABJk4VAK+JbPQuWhUAQAAAAXa0SPQEAAAATBRVFIcVwQskgtpw+7TU2vpl7tT4QAAAAiTEIvQEAAAC9PC9AZHGiQpTJhELukwcAyQ+dcD559TM908p0PhAAAACU/La4AQAAAB/sDEEvtFtCmqmtQmb+CADJmD9wPsop77wDGXI+EAAAAKNlRTkBAAAA/OoMQb8+XkKu6K9CUQAAAIAAAACAAAAAAAAAAACZmRk/AAAAgP/hBLsAAAAAA+IEuwP2Sz0AAAAAyUa7QcPVBkG92ey7Hi6Lu36m1j76zUG7PrY7OtnBgjtol7A4dv9/P+oFKLspew44jjmAu33RMD104vw8sdiLuwAAAAAAAIA/AAAAAAAAAAAAAAAA6lG4PgAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAOpRuD4AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAD/4QS7AAAAAEkSejIAAAAACAAAAAAAAADqUbg+AAAAAAAAgD8AAAAAzMxMPwAAAAAAAAAAAAAAAJQwBkEAAJBBAAAAAAAAAABA8PcAAAAAAIA/AACAPwAAgD+UMAZBgPf3AAAAAACamRk/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADNzEw9AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAACAAAAAAAAAAAA=",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP5gBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC9PC9AAAAAAAAAAADukwcAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB/sDEEAAAAAAAAAAGb+CADJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/OoMQQAAAAAAAAAAUQAAAIAAAAAAAAAAAAAAAACZmRk/AAAAgJzfBLsAAAAA/+EEu/rzSz0AAAAAAACAPwAAAADqUbg+AAAAAAAAgD8AAACAAAAAAAAAAADqUbg+AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAnN8EuwAAAACS5JgyAAAAAOpRuD4AAAAAAACAPwAAAADE1QZBAAAAAIA/AACAPwAAgD/E1QZBgPf3AAAAAACamRk/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADNzEw9AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAA=",["controls"]={0.6,1.0,0.0,false,false,0.0,0.0,true,true,0.05,true}},{["frame"]=416,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267524,1},{7273256,1},{7293516,1},{7297528,2},{7297628,3},{7653748,1},{7653772,4},{7653792,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj+amRk+zcxMP9sPSUAAAERBLnQBuj0KD0E9Co9BAADgQAEAAAAAAIA/AACAPwAAgD8AAIA/AQAAAKABAABLaNw/8WBiPel+3D8QAAAAW0cTPQEAAAD4chNFSvxyQskCE5g+3xk3vky7sT4QAAAA7bYHvQEAAAA3hi9Bg0+vQgOGlULnKAoAydJmTj5gYS89X/lSPhAAAABlA1C4AQAAAH7nDEFBSmA/cFehQrE6BwDJfIROPkZN+bzI0VA+EAAAAN3IbDkBAAAAWGgMQXY1Kj8Eh6RCOgAAAIAAAACAAAAAAAAAAACZmRk/AAAAgL7NBLsAAAAAvs0Eu73kSz0AAAAAG3PMQcU4DEFlYAq8OAdfuhyl1j5K6Au7LOJOOoV4gzuScee4cv9/PxDgODtWvVY6OtYFOwbZMD35RtI8j86LuwAAAAAAAIA/AAAAAAAAAAAAAAAA6lG4PgAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAOpRuD4AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAC+zQS7AAAAANs2njIAAAAACAAAAAAAAADqUbg+AAAAAAAAgD8AAAAAzMxMPwAAAAAAAAAAAAAAAFWUC0EAAJBBAAAAAAAAAABA8PcAAAAAAIA/AACAPwAAgD9VlAtBgPf3AAAAAACamRk/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADNzEw9AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAACAAAAAAAAAAAA=",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP6EBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA3hi9BAAAAAAAAAADnKAoAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH7nDEEAAAAAAAAAALE6BwDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWGgMQQAAAAAAAAAAOgAAAIAAAAAAAAAAAAAAAACZmRk/AAAAgEjLBLsAAAAAvs0Eu6TiSz0AAAAAAACAPwAAAADqUbg+AAAAAAAAgD8AAACAAAAAAAAAAADqUbg+AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAASMsEuwAAAAAAgJ0yAAAAAOpRuD4AAAAAAACAPwAAAADFOAxBAAAAAIA/AACAPwAAgD/FOAxBgPf3AAAAAACamRk/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADNzEw9AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAA=",["controls"]={0.6,1.0,0.0,false,false,0.0,0.0,true,true,0.05,true}}}},{["name"]="ratio32",["steer"]=nil,["ratio"]=32,["quick"]=4,["start"]={{["frame"]=0,["beforeRuns"]={{7247832,1},{7247908,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7271624,2},{7273160,1},{7273256,1},{7293516,1},{7295936,1},{7297528,4},{7297584,1},{7297628,3},{7653748,1},{7653772,2},{7653784,3},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAP83MTD4AAAAACtcjPM3MzD1mZmY/zczMPJqZGT57FK5H4XqEP0jhej/NzEw/2w9JQKuqqj0AAERBLnQBul8cRFT7Ifk/A/oOPD0KD0E9Co9BAADgQAEAAAAAAIA/AisHPQAAgD8AACBAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB17isAAAAAAAAAAAAAAAAAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHXuAAAAAAAAAAAAAAAAOADJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAdQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPQrXPgAAAAAAAAAAAAAAAAAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEIAAAAAAAAAAEDw9wAAAAAAAAAAAAAAAAAAAAAAAACA9/cAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAA==",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAPwEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB17isAAAAAAAAAAAAAAAAAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHXuAAAAAAAAAAAAAAAAOADJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAdQAAAAAAAAAAAAAAADmOYzoAAAAAAAAAAAAAAAAAAIA/AAAAPgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAgD85juM7AACAPwAAAD4AAAAAAAAAAAAAgD85juM7AACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAKuqqj0AAIA/AAAAAAAAAAAAAAAAgD8AAIA/AACAPwAAAACA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAA==",["controls"]={1.0,1.0,0.0,false,false,0.0,0.0,true,true,0.0,true}},{["frame"]=86,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297628,3},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj/NzMw8mpkZPs3MTD/bD0lALnQBul8cRFT7Ifk/PQoPQT0Kj0EAAOBAAQAAAAAAgD8CKwc9AACAPwAAgD8AACBAAQAAAFYAAABZKoA+rC3qvUwNjT4QAAAA+UgTPQEAAABbtp9B0vkJQsn0v2Q/B7mnvo61cz8QAAAABUXVvAEAAABb5y1AwacCRB6UCELCc3YAyXwhzEHyTnO6bxbMQRAAAADozUa5AQAAAPNnCUIiwxlIFrAQRPExOgDJjhrOQVbncbwdD85BEAAAADCvzDgBAAAApAUJQgGMGUjqZQ9EJgAAAIAAAACAAAAAAAAAAAAAAIA/AAAAgAAAAAB1YqE9a/ZivQAAAABw9mK9Adv8PQAAAABbqW5AcM/mQEGu2bzIjl++LUHZPhGvADvebtM6VJixOhjIXbt6/38//aFgvIFPsjpyg/q9OhsCPcBjPDxmI2y9AAAAAAAAgD8AAAAAAAAAAAAAAAAAAIA/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAACAPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAGv2Yr0AAAAApcnNuQAAAAAIAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAB3XgQAAAAEIAAAAAAAAAAEDw9wAAAAAAgD8AAIA/AACAPwd14ECA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHVioT0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAIAAAAAAAAAAAA==",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP1cAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABb5y1AAAAAAAAAAADCc3YAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPNnCUIAAAAAAAAAAPExOgDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAApAUJQgAAAAAAAAAAJgAAAIAAAAAAAAAAAAAAAAAAAIA/AAAAgAAAAAByyak9wrZuvQAAAABr9mK9RvkEPgAAAAAAAIA/AAAAAAAAgD8AAAAAAACAPwAAAIAAAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAADCtm69AAAAAGMFvLkAAAAAAACAPwAAAAAAAIA/AAAAAIDq5kAAAAAAgD8AAIA/AACAP4Dq5kCA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHLJqT0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAA==",["controls"]={1.0,1.0,0.0,false,false,0.0,0.0,true,true,0.08290375725550417,true}},{["frame"]=98,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297624,4},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj/NzMw8mpkZPs3MTD/bD0lALnQBul8cRFT7Ifk/MRXlPT0KD0E9Co9BAADgQAEAAAAAAIA/AisHPQAAgD8AAIA/AAAgQAEAAABiAAAAS3tqP/ev3r5b2IE/EAAAAACICT0BAAAABQRMRNHgnULJPjbbP+HXFb9qq+c/EAAAAIAc6LwBAAAAHIYvQU09yETPJYhCVlaUAMmohrRB+/H2vuiOtEEQAAAA+M2luQEAAAACCARCcdsJSC/zDEQS2UQAybCYvkFRIgK/652+QRAAAAC8YvO3AQAAABvzBEK/ZglI2nEIRO0AAACAAAAAgAAAAAAAAAAAAACAPwAAAIAAAAAASrDJPcpdar0AAAAAzV1qvV3GHT4AAAAAtR7RQDgdGkGe3Dy+VwBPv/JD2T5nyZ67kOBdOew0sDouCDK9AsJ/PxkPUjxcJj+7Q5m/vqNMCD0b3mg8w4pzvQAAAAAAAIA/AAAAAAAAAAAAAAAAAACAPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAADKXWq9AAAAAJq0GjoAAAAACAAAAAAAAAAAAIA/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAADtkF0EAAABCAAAAAAAAAABA8PcAAAAAAIA/AACAPwAAgD87ZBdBgPf3AAAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABKsMk9AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAACAAAAAAAAAAAA=",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP2MAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAchi9BAAAAAAAAAABWVpQAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIIBEIAAAAAAAAAABLZRADJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAG/MEQgAAAAAAAAAA7QAAAIAAAAAAAAAAAAAAAAAAAIA/AAAAgAAAAABxt8Y97VhYvQAAAADKXWq903cbPgAAAAAAAIA/AAAAAAAAgD8AAAAAAACAPwAAAIAAAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAADtWFi9AAAAAO8mEDoAAAAAAACAPwAAAAAAAIA/AAAAAP+nGkEAAAAAgD8AAIA/AACAP/+nGkGA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHG3xj0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAA==",["controls"]={1.0,1.0,0.0,false,false,0.0,0.0,true,true,0.09702957262759965,true}},{["frame"]=116,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297624,4},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj/NzMw8mpkZPs3MTD/bD0lALnQBul8cRFT7Ifk/MRXlPT0KD0E9Co9BAADgQAEAAAAAAIA/AisHPQAAgD8AAIA/AAAgQAEAAAB0AAAADEyjP7n5fb+46c4/EAAAAI4oZjwBAAAAjFUnRadLVEPJtduoPg9m0b+qntU/EAAAAJanXr0BAAAAaJsyQSLxCERkf2pCHFGPAMk0B4hAo52iwGhe1EAQAAAAvhDCuwEAAACgwU5BamtTRlO1X0Pp/VoAyU/WcUHge73AlPWBQRAAAABuD7m7AQAAAJTBQUHHK5RFYXRXQiUAAACAAAAAgAAAAAAAAAAAAACAPwAAAIAAAAAAbgVkPMXahbsAAAAAytqFu7sSszwEAAAAqwVCQVGQP0HViYi/tGJVwKkE1z45aUK9kxk0vHHQ0DvJ7UW+tiZ7Pyzk+r3rTmo9iMo2vyHkYD39Ty8+ekLPuwAAAAAAAIA/AAAAAAAAAAAAAAAAAACAPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAADF2oW7AAAAANuXhDkFAAAACAAAAAIAAAAAAIA/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAHotR0EAAABCAAAAAAAAAABA8PcAAAAAAIA/AACAPwAAgD96LUdBgPf3AAAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABuBWQ8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAACAAAAAAAAAAAA=",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP3UAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABomzJBAAAAAAAAAAAcUY8AyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKDBTkEAAAAAAAAAAOn9WgDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAlMFBQQAAAAAAAAAAJQAAAIAAAAAAAAAAAAAAAAAAAIA/AAAAgAAAAAD5k+Q7UaQGuwAAAADF2oW7aoUzPAQAAAAAAIA/AAAAAAAAgD8AAAAAAACAPwAAAIAAAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAABRpAa7AAAAADkRhTkFAAAAAACAPwAAAAAAAIA/AAAAALvaRkEAAAAAgD8AAIA/AACAP7vaRkGA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPmT5DsAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAA==",["controls"]={1.0,1.0,0.0,false,false,0.0,0.0,true,true,0.0069756473744125086,true}},{["frame"]=134,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297624,4},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPJqZGT7NzEw/2w9JQC50AbpfHERU+yH5PzEV5T09Cg9BPQqPQQAA4EABAAAAAACAPwIrBz0AAIA/AACAPwAAIEABAAAAhgAAALjri729OrrAVTm6QBAAAACX0488AQAAABviZ0bD3T9DyYO1h7v0JwLB8icCQRAAAABE3Tm9AQAAAOcjM0GeBtpFCjBvQr/vxADJh+iRQe6J0MBS7ppBEAAAAJ/FS7sBAAAACDoZQtDhBkgTZVNElpFyAMnrLt1BI7XwwIMz5UEQAAAA18s4uwEAAADtVRlCtlPFRzLw/EM6AAAAgAAAAIAAAAAAAAAAAAAAgD8AAACAsRK4PQAAAABG7Z08AAAAAELtnTxAFxC+AAAAADflkkEkx0dBoL9zwN2T+MArHtg+IHukO76w1Ltfjo47u6Huvk98Yj99fhU8I8vRPA742L+d4is9QY7wu1aTizwAAAAAAACAPwAAAAAAAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAIA/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAARu2dPAAAAACXdog4AAAAAAgAAAAAAAAAAACAPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAACgMGpBAAAAQgAAAAAAAAAAQPD3AAAAAACAPwAAgD8AAIA/oDBqQYD39wAAAAAAAACAPwAAAAAAAAAAAAAAAAAAAACxErg9AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAgAAAAAAAAAAA",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP4cAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADnIzNBAAAAAAAAAAC/78QAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAg6GUIAAAAAAAAAAJaRcgDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA7VUZQgAAAAAAAAAAOgAAAIAAAAAAAAAAAAAAAAAAAIA/AAAAgCPjvT0AAAAAVYihPAAAAABG7Z08RZwUvgAAAAAAAIA/AAAAAAAAgD8AAAAAAACAPwAAAIAAAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAABViKE8AAAAANDDZjgAAAAAAACAPwAAAAAAAIA/AAAAAOVIa0EAAAAAgD8AAIA/AACAP+VIa0GA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAI+O9PQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAA==",["controls"]={1.0,1.0,0.0,false,false,0.0,0.0,true,true,-0.09271838545667874,true}},{["frame"]=152,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297624,4},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8ZmZmP83MzDyamRk+zcxMP9sPSUAudAG6XxxEVPsh+T8xFeU9PQoPQT0Kj0EAAOBAAQAAAAAAgD8CKwc9AACAPwAAgD8AACBAAQAAAJgAAAC0F7o/zhfgwQdd4EEQAAAAyCSWPAEAAACyOzRHccrKQslZwdxAgS4zwtlHNUIQAAAAfNw6vQEAAAC++CxAf4GkRpMDsUHnfqQAyQusw0GiyznBBpDYQRAAAAAbhIm7AQAAANR4NkLi5DtIhoCNRAGiigDJ8G0oQmctW8EHGzFCEAAAADIfgLsBAAAApz02Qlaj3kcM1wVETwAAAIAAAACAAAAAAAAAAAAAAIA/AAAAgBtEjj0AAAAAt+qBPAAAAACy6oE8HQffvQAAAAACj79Bd3AWQXxuCMGQQybBPP/XPn+mZLud9jS7aCHwO0BlWr+XjAU/oMAyPBXoMj15wSXA17sxPfYzZTyMIV88AAAAAAAAgD8AAAAAAAAAAAAAAAAAAIA/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAACAPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAALfqgTwAAAAAXAHauAAAAAAIAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAN2tiQQAAAEIAAAAAAAAAAEDw9wAAAAAAgD8AAIA/AACAPzdrYkGA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAG0SOPQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAIAAAAAAAAAAAA==",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP5kAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC++CxAAAAAAAAAAADnfqQAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANR4NkIAAAAAAAAAAAGiigDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAApz02QgAAAAAAAAAATwAAAIAAAAAAAAAAAAAAAAAAAIA/AAAAgJWkgz0AAAAAidt0PAAAAAC36oE82m7OvQAAAAAAAIA/AAAAAAAAgD8AAAAAAACAPwAAAIAAAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAACJ23Q8AAAAAEme77gAAAAAAACAPwAAAAAAAIA/AAAAAO44YEEAAAAAgD8AAIA/AACAP+44YEGA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAlaSDPQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAA==",["controls"]={1.0,1.0,0.0,false,false,0.0,0.0,true,true,-0.06427876096865397,true}},{["frame"]=170,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297624,4},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8ZmZmP83MzDyamRk+zcxMP9sPSUAudAG6XxxEVPsh+T8xFeU9PQoPQT0Kj0EAAOBAAQAAAAAAgD8CKwc9AACAPwAAgD8AACBAAQAAAKoAAACxvGFATZE2wqcXN0IQAAAA8oG3PAEAAAB09TdFm58SQsl6JKlALjSvwVs2tEEQAAAAvzItvQEAAAAgVjNBSOyNRKQ7ikJq4zoAyepSCUJoTv3Atu0MQhAAAAASv367AQAAAHe+NEJi9oFIetCKRJ5uogDJfctjQjb3E8G+wmZCEAAAADr7a7sBAAAAj/A0QvXnIkiqLAxEdgAAAIAAAACAAAAAAAAAAAAAAIA/AAAAgAAAAACpS0A9iWabvAAAAACQZpu8R+SWPQAAAABgh95Bi4TYQBKEVcH2/wPBcJjXPkllkzlLpT87km2/OzCReb8lBGS+gyl+PckJOj0Zo2nAWcExPf1cA718wK28AAAAAAAAgD8AAAAAAAAAAAAAAAAAAIA/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAACAPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAIlmm7wAAAAABovOuQAAAAAIAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAbM0sQQAAAEIAAAAAAAAAAEDw9wAAAAAAgD8AAIA/AACAP2zNLEGA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKlLQD0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAIAAAAAAAAAAAA==",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP6sAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgVjNBAAAAAAAAAABq4zoAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHe+NEIAAAAAAAAAAJ5uogDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAj/A0QgAAAAAAAAAAdgAAAIAAAAAAAAAAAAAAAAAAAIA/AAAAgAAAAAAQDlk9ssS0vAAAAACJZpu8GkeqPQAAAAAAAIA/AAAAAAAAgD8AAAAAAACAPwAAAIAAAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAACyxLS8AAAAAEfxyrkAAAAAAACAPwAAAAAAAIA/AAAAAEm3KkEAAAAAgD8AAIA/AACAP0m3KkGA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAOWT0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAA==",["controls"]={1.0,1.0,0.0,false,false,0.0,0.0,true,true,0.05299192642332047,true}},{["frame"]=185,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297628,3},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8ZmZmP83MzDyamRk+zcxMP9sPSUAudAG6XxxEVPsh+T89Cg9BPQqPQQAA4EABAAAAAACAPwIrBz0AAIA/AACAPwAAIEABAAAAuQAAAHtAZsCjssNB28XFQRAAAAADMk09AQAAAO6ciUYs46pBySJQbb9gJMFBzUHBQRAAAAC490S8AQAAAO+kL0EfAz9HS5LzQuIRgADJnIwbQrfrWT/akhtCEAAAALQPBboBAAAA7DM3QrxlXEjYKWNEao+4AMlbLDhCT+BkP6oxOEIQAAAAdX1iuQEAAACNwTdCUANdSKlRVETFAAAAgAAAAIAAAAAAAAAAAAAAgD8AAACAAAAAAN2szD2m+oa9AAAAAKz6hr2UFyA+AAAAAFCI8UGR7pVA5gGGwdYA88ApZdc+bMrWvLhF6bsSY9O79q0kv3z8Q7/J7b89YHcNvZFNKMBnvsg8OXugPCeRi70AAAAAAACAPwAAAAAAAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAIA/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAApvqGvQAAAACGLwi6AAAAAAgAAAAAAAAAAACAPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAACPoBFBAAAAQgAAAAAAAAAAQPD3AAAAAACAPwAAgD8AAIA/j6ARQYD39wAAAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA3azMPQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAgAAAAAAAAAAA",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP7oAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADvpC9BAAAAAAAAAADiEYAAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOwzN0IAAAAAAAAAAGqPuADJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjcE3QgAAAAAAAAAAxQAAAIAAAAAAAAAAAAAAAAAAAIA/AAAAgAAAAADdrMw9x7KPvQAAAACm+oa9lBcgPgAAAAAAAIA/AAAAAAAAgD8AAAAAAACAPwAAAIAAAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAADHso+9AAAAAA6CC7oAAAAAAACAPwAAAAAAAIA/AAAAAJ7EDkEAAAAAgD8AAIA/AACAP57EDkGA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAN2szD0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAA==",["controls"]={1.0,1.0,0.0,false,false,0.0,0.0,true,true,0.09993908270190957,true}},{["frame"]=198,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297628,3},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj/NzMw8mpkZPs3MTD/bD0lALnQBul8cRFT7Ifk/PQoPQT0Kj0EAAOBAAQAAAAAAgD8CKwc9AACAPwAAgD8AACBAAQAAAMYAAABovrXBpEXiQsTE5kIQAAAAodFbPQEAAABB109Gm+pKQMk8fyrAsU+EQh1rhEIQAAAAwu8SvAEAAABuFCw/xsxERwtiRUH1VUUAyXnACUL7pTZAKzkKQhAAAACwqBC6AQAAAGV6MkKmRUJIiAdYRBGPygDJJ7EbQkL5OkCvHRxCEAAAABtaibkBAAAAjtwyQmILQEhdOkhEfQAAAIAAAACAAAAAAAAAAAAAAIA/AAAAgAAAAACVpIM9Oks5vQAAAAA9Szm92W7OPQAAAACszv1BNZOEQKewmMFXzabAU9rXPvENBTvthTq8gCaMu3xqlr4Cr3S/AvNNPMlaLr1WL+i/X5SzPGUHbzszeEK9AAAAAAAAgD8AAAAAAAAAAAAAAAAAAIA/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAACAPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAADpLOb0AAAAAvVPuOQAAAAAIAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAucfZQAAAAEIAAAAAAAAAAEDw9wAAAAAAgD8AAIA/AACAP7nH2UCA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJWkgz0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAIAAAAAAAAAAAA==",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP8cAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABuFCw/AAAAAAAAAAD1VUUAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGV6MkIAAAAAAAAAABGPygDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjtwyQgAAAAAAAAAAfQAAAIAAAAAAAAAAAAAAAAAAAIA/AAAAgAAAAADAwXA9WnwpvQAAAAA6Szm9SdK8PQAAAAAAAIA/AAAAAAAAgD8AAAAAAACAPwAAAIAAAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAABafCm9AAAAAA3u/DkAAAAAAACAPwAAAAAAAIA/AAAAABMS1UAAAAAAgD8AAIA/AACAPxMS1UCA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMDBcD0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAA==",["controls"]={1.0,1.0,0.0,false,false,0.0,0.0,true,true,0.05877852522924734,true}},{["frame"]=216,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297628,3},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj/NzMw8mpkZPs3MTD/bD0lALnQBul8cRFT7Ifk/PQoPQT0Kj0EAAOBAAQAAAAAAgD8CKwc9AACAPwAAgD8AACBAAQAAANgAAAB8rg/BdFVGQrKFSUIQAAAAi2tQPQEAAADsxUhFD2NhQclOgd2/pBpLQpMuS0IQAAAA7jI5vAEAAAC4dS1AlDtLRqDlekIfVigAybcxAUIXYW8/lj8BQhAAAADvO2w5AQAAAGGaOEJjRi9I78NXRKVO4QDJgPv8QXnZZz8TFv1BEAAAAPSrBjoBAAAAvso4QitzPEg5F2dEfwAAAIAAAACAAAAAAAAAAAAAAIA/AAAAgBAOWT0AAAAASdcYPQAAAABJ1xg9G0eqvQAAAABoughCUofBQLmnpsFaO/q/tq/YPlA18To2XE+8lvSNuhxY9bqb+n+/AbeAuoCpNbyqRwi/K5mmPH+tRDpTqg89AAAAAAAAgD8AAAAAAAAAAAAAAAAAAIA/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAACAPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAEnXGD0AAAAAATULOgAAAAAIAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAPF3IQAAAAEIAAAAAAAAAAEDw9wAAAAAAgD8AAIA/AACAPzxdyECA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAEA5ZPQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAIAAAAAAAAAAAA==",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP9kAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC4dS1AAAAAAAAAAAAfVigAyQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGGaOEIAAAAAAAAAAKVO4QDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAvso4QgAAAAAAAAAAfwAAAIAAAAAAAAAAAAAAAAAAAIA/AAAAgMDBcD0AAAAAWHwpPQAAAABJ1xg9StK8vQAAAAAAAIA/AAAAAAAAgD8AAAAAAACAPwAAAIAAAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAABYfCk9AAAAAHgoBToAAAAAAACAPwAAAAAAAIA/AAAAAGpjy0AAAAAAgD8AAIA/AACAP2pjy0CA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAwMFwPQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAA==",["controls"]={1.0,1.0,0.0,false,false,0.0,0.0,true,true,-0.058778525229247286,true}},{["frame"]=233,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297628,3},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj/NzMw8mpkZPs3MTD/bD0lALnQBul8cRFT7Ifk/PQoPQT0Kj0EAAOBAAQAAAAAAgD8CKwc9AACAPwAAgD8AACBAAQAAAOkAAAD5da+/xgF5QOYRhEAQAAAALKosPQEAAACj+TREMpMuQsluJmHA4yCAQHOhqkAQAAAAB/iuvAEAAAA2yzBBTgKNRTWfAUNm2eEBydEX+UE6PEs/diz5QRAAAAAnMc85AQAAAKMDMkLDCx9IydNDRJdj+gDJnxjpQWcsQz8JKelBEAAAAH4aMjoBAAAAVl0yQoVHKkgmV1hERgAAAIAAAACAAAAAAAAAAAAAAIA/AAAAgEqwyT0AAAAATp6NPQAAAABNno09XsYdvgAAAAD+rRZCF1ILQfHOqcFuhrU89VbYPpzpNLtsSAC8hGoNuxZIjrz383+/mkmZvDLLOzysyAQ/NWHjPAu8XDzSB4k9AAAAAAAAgD8AAAAAAAAAAAAAAAAAAIA/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAACAPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAE6ejT0AAAAAE1uxuAAAAAAIAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAARuEIQQAAAEIAAAAAAAAAAEDw9wAAAAAAgD8AAIA/AACAP0bhCEGA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAASrDJPQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAIAAAAAAAAAAAA==",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP+oAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA2yzBBAAAAAAAAAABm2eEByQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKMDMkIAAAAAAAAAAJdj+gDJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAVl0yQgAAAAAAAAAARgAAAIAAAAAAAAAAAAAAAAAAAIA/AAAAgHG3xj0AAAAAPYyLPQAAAABOno091HcbvgAAAAAAAIA/AAAAAAAAgD8AAAAAAACAPwAAAIAAAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAA9jIs9AAAAABOEBLkAAAAAAACAPwAAAAAAAIA/AAAAADVSC0EAAAAAgD8AAIA/AACAPzVSC0GA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAcbfGPQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAA==",["controls"]={1.0,1.0,0.0,false,false,0.0,0.0,true,true,-0.09702957262759965,true}},{["frame"]=244,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297624,4},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj/NzMw8mpkZPs3MTD/bD0lALnQBul8cRFT7Ifk/MRXlPT0KD0E9Co9BAADgQAEAAAAAAIA/AisHPQAAgD8AAIA/AAAgQAEAAAD0AAAAOZ5fv8gB1j8FkfE/EAAAAPY/QT0BAAAAbdD0QyoDIELJdPdLwGTUpD9j+FtAEAAAALaHjLwBAAAAI9IyQS7DakU/1ShDoYPNAckzAwRCVe0OQIRQBEIQAAAAkI7zOgEAAACAwjlCPjgOSDgANkQNwAsByT9hzEGW6wBAfvjMQRAAAADOWww7AQAAAG9fOULRWTlInKmCRPEAAACAAAAAgAAAAAAAAAAAAACAPwAAAIDAwXA9AAAAAOOl4TwAAAAA4KXhPErSvL0AAAAALlIiQtUdJEEMbKjBLxegPyVx2D6GfsE6hE4WvJ36X7upBwe+jsB9v4EdZzzni6c85AeCPy9p2zyBc/u79EvPPAAAAAAAAIA/AAAAAAAAAAAAAAAAAACAPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAADjpeE8AAAAAOWz9LkAAAAACAAAAAAAAAAAAIA/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAHwnI0EAAABCAAAAAAAAAABA8PcAAAAAAIA/AACAPwAAgD98JyNBgPf3AAAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAMDBcD0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAACAAAAAAAAAAAA=",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAP/UAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAj0jJBAAAAAAAAAAChg80ByQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIDCOUIAAAAAAAAAAA3ACwHJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAb185QgAAAAAAAAAA8QAAAIAAAAAAAAAAAAAAAAAAAIA/AAAAgBAOWT0AAAAAHGHEPAAAAADjpeE8G0eqvQAAAAAAAIA/AAAAAAAAgD8AAAAAAACAPwAAAIAAAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAcYcQ8AAAAADUm6rkAAAAAAACAPwAAAAAAAIA/AAAAAAFVJUEAAAAAgD8AAIA/AACAPwFVJUGA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAEA5ZPQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAA==",["controls"]={1.0,1.0,0.0,false,false,0.0,0.0,true,true,-0.0529919264233206,true}},{["frame"]=262,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297624,4},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPJqZGT7NzEw/2w9JQC50AbpfHERU+yH5PzEV5T09Cg9BPQqPQQAA4EABAAAAAACAPwIrBz0AAIA/AACAPwAAIEABAAAABgEAAB+0cD8dtEdBITxIQRAAAAD+NWk9AQAAAE9AgkX5tJFByS+tM72UI+NA+h3jQBAAAABsPPi7AQAAAAY1MkEXWqpGeM48Q+5yRgHJHQIZQjc9BkGdoRxCEAAAAMZ/aTsBAAAAezY4Qk8m5Eet5Q9EaXQnAckl57lBHYPhQC08wkEQAAAAXgN8OwEAAABUkThC3S04SIUwkERpAAAAgAAAAIAAAAAAAAAAAAAAgD8AAACAAAAAAMDBcD1P4qK8AAAAAFDiorxJ0rw9AAAAAPu/N0JLCidBquGbwf1ipECyedg++0YqueaPMbwftxq87bcFvyZFWr8y/lq8mE6MPTCOFUD9wLc8bJhfOjw8tbwAAAAAAACAPwAAAAAAAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAIA/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAT+KivAAAAADvNn+5AAAAAAgAAAAAAAAAAACAPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAAB3VjpBAAAAQgAAAAAAAAAAQPD3AAAAAACAPwAAgD8AAIA/d1Y6QYD39wAAAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwMFwPQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAgAAAAAAAAAAA",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAPwcBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGNTJBAAAAAAAAAADuckYByQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHs2OEIAAAAAAAAAAGl0JwHJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAVJE4QgAAAAAAAAAAaQAAAIAAAAAAAAAAAAAAAAAAAIA/AAAAgAAAAACVpIM9HHGyvAAAAABP4qK82W7OPQAAAAAAAIA/AAAAAAAAgD8AAAAAAACAPwAAAIAAAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAccbK8AAAAAMjseLkAAAAAAACAPwAAAAAAAIA/AAAAAMQqOkEAAAAAgD8AAIA/AACAP8QqOkGA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJWkgz0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAA==",["controls"]={1.0,1.0,0.0,false,false,0.0,0.0,true,true,0.06427876096865384,true}},{["frame"]=280,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297624,4},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8ZmZmP83MzDyamRk+zcxMP9sPSUAudAG6XxxEVPsh+T8xFeU9PQoPQT0Kj0EAAOBAAQAAAAAAgD8CKwc9AACAPwAAgD8AACBAAQAAABgBAADyzJlB6H6CQukKiEIQAAAA9PBnPQEAAACSCPpFPl1UQcnhHa4/IC0GQkpJBkIQAAAAFW4lvAEAAAA9BCw/UPMqRgTOm0BST5sByYB2V0KNq0hBpTBdQhAAAABAGYk7AQAAAG95OUIARfNHt+rzQ3vvQQHJ0GD2QSoeKUFLPgJCEAAAALk4kjsBAAAARDU5QmJQXEhCOJFEewAAAIAAAACAAAAAAAAAAAAAAIA/AAAAgAAAAADAxsI9wbRcvQAAAADBtFy9m2gYPgAAAAAUbUlCbJXhQNxqg8Ha48NAvnXXPqJrlLvOYtW5CuFVvJ5wdb8sYpG+3zyFvIzptT0W+GFAGGrnPK1wlDu34WW9AAAAAAAAgD8AAAAAAAAAAAAAAAAAAIA/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAACAPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAMG0XL0AAAAA/rOUuQAAAAAIAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAoaMYQQAAAEIAAAAAAAAAAEDw9wAAAAAAgD8AAIA/AACAP6GjGEGA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMDGwj0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAIAAAAAAAAAAAA==",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAPxkBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA9BCw/AAAAAAAAAABST5sByQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAG95OUIAAAAAAAAAAHvvQQHJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARDU5QgAAAAAAAAAAewAAAIAAAAAAAAAAAAAAAAAAAIA/AAAAgAAAAAAj4709lk9mvQAAAADBtFy9RJwUPgAAAAAAAIA/AAAAAAAAgD8AAAAAAACAPwAAAIAAAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAACWT2a9AAAAAEytmbkAAAAAAACAPwAAAAAAAIA/AAAAAAFiFUEAAAAAgD8AAIA/AACAPwFiFUGA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACPjvT0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAA==",["controls"]={1.0,1.0,0.0,false,false,0.0,0.0,true,true,0.09271838545667879,true}},{["frame"]=292,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297628,3},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8ZmZmP83MzDyamRk+zcxMP9sPSUAudAG6XxxEVPsh+T89Cg9BPQqPQQAA4EABAAAAAACAPwIrBz0AAIA/AACAPwAAIEABAAAAJAEAANIDUD8J5s8+XCyLPxAAAABOoOA7AQAAAH90v0Vmj2VDybhxdz884ohBjRqJQRAAAAAgAYO9AQAAAFMnLUA1dJpENFaAQNeYGQHJmsdMQu7ou0BaFE5CEAAAANk5hDoBAAAAiZE3QltjQUhnAzVE/GdQAcn0uyZCNVG1QANAKEIQAAAAglmoOgEAAABZrjdCwM9VSKLTYUQQAAAAgAAAAIAAAAAAAAAAAAAAgD8AAACAAAAAAG6ZJj1ivOq8AAAAAGS86rz/wYI9AAAAAKfjUUIxhLdA1FppwRhitED5vNQ+s1azvOw1CruNJZE850Jxv5v5qj708Um+fN4Evpl9YUAD1YI9Ei7lPVAW/bwAAAAAAACAPwAAAAAAAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAIA/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAYrzqvAAAAADLkxA6AAAAAAgAAAAAAAAAAACAPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAADwbQFBAAAAQgAAAAAAAAAAQPD3AAAAAACAPwAAgD8AAIA/8G0BQYD39wAAAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAbpkmPQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAgAAAAAAAAAAA",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAPyUBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABTJy1AAAAAAAAAAADXmBkByQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAImRN0IAAAAAAAAAAPxnUAHJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWa43QgAAAAAAAAAAEAAAAIAAAAAAAAAAAAAAAAAAAIA/AAAAgAAAAABpFww9EG3FvAAAAABivOq8BPNbPQAAAAAAAIA/AAAAAAAAgD8AAAAAAACAPwAAAIAAAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAQbcW8AAAAAEg9FToAAAAAAACAPwAAAAAAAIA/AAAAAMWpAEEAAAAAgD8AAIA/AACAP8WpAEGA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGkXDD0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAA==",["controls"]={1.0,1.0,0.0,false,false,0.0,0.0,true,true,0.03420201433256706,true}},{["frame"]=310,["beforeRuns"]={{7247832,1},{7251028,1},{7251108,1},{7251148,1},{7262240,1},{7267216,1},{7267524,1},{7273256,1},{7293516,1},{7297532,3},{7297628,3},{7653748,1},{7653772,6},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545344,16},{12545548,1},{12545556,1},{12545568,1},{12545576,9},{12545616,1},{12545624,9},{12545664,3},{12545688,4},{12545708,2},{12545720,1},{12545792,1},{12545800,2},{12545812,1},{12545860,1},{12605056,1},{12609908,2},{12616084,1},{12658124,6},{13851464,12},{13860184,23},{14727232,3}},["before"]="AACAPwAAAAAK1yM8zczMPWZmZj/NzMw8mpkZPs3MTD/bD0lALnQBul8cRFT7Ifk/PQoPQT0Kj0EAAOBAAQAAAAAAgD8CKwc9AACAPwAAgD8AACBAAQAAADYBAAB+orW/cy8ZwnZHGUIQAAAAd96UPAEAAAA5wxRHopw4QsnUmX3AmJWMwjHOjEIQAAAAmSJBvQEAAACb9Ss+yodpRj/Wjz/fYRYBySC4MkKqPoi/S8IyQhAAAAA4Dpc6AQAAAM+COUJ6rDlIux1BRATzaAHJ1ncPQvXOfr88hQ9CEAAAAOUovDoBAAAAzZQ5Qj/wVEicsHREKQAAAIAAAACAAAAAAAAAAAAAAIA/AAAAgDEymD0AAAAA0BlWPQAAAADLGVY9xYbuvQAAAAB0nFpCWatQQGmhPsEitohA9ITXPqJX4TuQcK27YRW5O27z/b41SF4/j72ju0M8Dr1YLgxAOUo8PWrga7zV7Ew9AAAAAAAAgD8AAAAAAAAAAAAAAAAAAIA/AAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAACAPwAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAANAZVj0AAAAA0JXeOQAAAAAIAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAA6/SxQAAAAEIAAAAAAAAAAEDw9wAAAAAAgD8AAIA/AACAP+v0sUCA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAMTKYPQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAIAAAAAAAAAAAA==",["afterRuns"]={{7653772,1},{7690684,1},{12532940,6},{12532976,2},{12535556,7},{12535592,3},{12538172,7},{12538208,3},{12540788,7},{12540824,3},{12542808,1},{12542828,1},{12542856,4},{12542876,2},{12542904,3},{12542920,2},{12545556,1},{12545568,1},{12545584,3},{12545616,1},{12545624,9},{12545664,3},{12545688,1},{12545700,1},{12545708,2},{12545812,1},{12545860,1},{12658124,6},{13851464,12},{13860184,23}},["after"]="AACAPzcBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACb9Ss+AAAAAAAAAADfYRYByQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAM+COUIAAAAAAAAAAATzaAHJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAzZQ5QgAAAAAAAAAAKQAAAIAAAAAAAAAAAAAAAAAAAIA/AAAAgHVioT0AAAAAavZiPQAAAADQGVY9Atv8vQAAAAAAAIA/AAAAAAAAgD8AAAAAAACAPwAAAIAAAAAAAAAAAAAAgD8AAAAAAACAPwAAAAAAAAAAAAAAAAAAAABq9mI9AAAAAKTJzTkAAAAAAACAPwAAAAAAAIA/AAAAAOT5q0AAAAAAgD8AAIA/AACAP+T5q0CA9/cAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAdWKhPQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAA==",["controls"]={1.0,1.0,0.0,false,false,0.0,0.0,true,true,-0.07880107536067218,true}}}}}}
local M={}
local FLAT={}
for i=1,4 do FLAT[i]={0,0,1,0,0,0,0,1,1} end
local B64={}
do
    local chars="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    for i=1,64 do B64[string.byte(chars,i)]=i-1 end
end
local function b64(s)
    local out=buffer.create(#s*3//4);local o=0
    for i=1,#s,4 do
        local a,b,c,d=string.byte(s,i,i+3)
        local x=B64[a]*262144+B64[b]*4096+(c~=61 and B64[c] or 0)*64+(d~=61 and B64[d] or 0)
        buffer.writeu8(out,o,bit32.rshift(x,16));o+=1
        if c~=61 then buffer.writeu8(out,o,bit32.band(bit32.rshift(x,8),0xff));o+=1 end
        if d~=61 then buffer.writeu8(out,o,bit32.band(x,0xff));o+=1 end
    end
    return out
end
local S=buffer.create(8)
local function fb(u) buffer.writeu32(S,0,u);return buffer.readf32(S,0) end
local function bits(x) buffer.writef32(S,0,x);return buffer.readu32(S,0) end
local CTRL_RAW,CTRL_TYPE,SETTINGS,SETUP_RATIO=0xd35b18,0xd37cc8,0xc0692a,0xc055c0+0x30*4

local function controlsOf(row)
    local c={throttle=row[1],clutch=row[2],brakeControl=row[3],brakeDigital=true,shiftUp=row[4],shiftDown=row[5]}
    if row[9] then c.steerAxis=row[10] else c.steerLeft=row[6];c.steerRight=row[7];c.steerDigital=row[8] end
    if not row[11] then c.driver=false end
    return c
end

function M.run(full)
    local t0=os.clock()
    local passed,failed,lines=0,0,{}
    local function check(name,ok,detail)
        if ok then passed+=1 else failed+=1 end
        local line=(ok and "PASS  " or "FAIL  ")..name..(detail and ("  "..detail) or "")
        table.insert(lines,line);print("[NR2003 Stage 12 self-test] "..line)
    end
    local car=Vehicle.new(Core:WaitForChild("NR2003Cup"))
    local V=car.V
    check("Stage 12 steering chain installed (NR2003CupSteering), production mode 'original'",V.steeringMode~=nil and V.steeringMode()=="original")
    if not V.steeringMode then return false,lines end
    local fd,rf32,r32,w32,wf32,r8,w8=V.fd,V.rf32,V.r32,V.w32,V.wf32,V.r8,V.w8
    local function fdBits(x) return bits(fd(x)) end
    local M_,BASE=V.memory(),V.base
    V.setRuntimeMode("original");V.endSession();V.clearSteeringOptions();V.reset()
    local rate0=rf32(0x74c990)
    -- L1 00552d00
    local bad=0
    for _,v in ipairs(G.axis) do
        local n=v[1]
        wf32(CTRL_RAW+10*n,fb(v[2]));w32(CTRL_TYPE+29*n,v[3] and 0 or 1)
        wf32(0xbf639c+4*(n==7 and 0 or 1),fb(v[4]));wf32(0x74c990,fb(v[5]))
        local x=V.axisOriginal(n)
        if fdBits(x)~=v[7] or r32(0xbf639c+4*(n==7 and 0 or 1))~=v[8] or math.abs(x-v[6])>4*math.abs(v[6])*2^-52 then bad+=1 end
    end
    wf32(0x74c990,rate0)
    check(string.format("00552d00 steering axes (slew + sin): %d original vectors",#G.axis),bad==0,bad>0 and (bad.." differ") or nil)
    -- L1 00552720
    local s25=r32(SETTINGS+0x4c)
    local function speedState(v,yaw) wf32(0xbf6d44,fb(v));wf32(0xbf6d4c,0);wf32(0xbf6d54,0);wf32(0xbf6d70,fb(yaw)) end
    bad=0
    for _,v in ipairs(G.input) do
        w32(SETTINGS+0x4c,v[4]==1 and bit32.bor(s25,0x2000000) or bit32.band(s25,bit32.bnot(0x2000000)))
        wf32(0xbf6f00,fb(v[3]));wf32(0x74c990,1);speedState(v[1],v[2])
        local u=fb(v[5])
        wf32(CTRL_RAW+70,u<0 and -u or 0);wf32(CTRL_RAW+80,u>0 and u or 0);w32(CTRL_TYPE+29*7,1);w32(CTRL_TYPE+29*8,1)
        if bits(V.steerInputOriginal())~=v[7] then bad+=1 end
    end
    w32(SETTINGS+0x4c,s25);wf32(0xbf6f00,0);wf32(0x74c990,rate0)
    check(string.format("00552720 processed input (-1..1 x speed x yaw rate x linearity x limiter): %d original vectors bit-exact",#G.input),bad==0,bad>0 and (bad.." differ") or nil)
    -- L1 00554fb0
    bad=0
    for _,v in ipairs(G.ratio) do
        w8(0x74c9a0,v[1]);wf32(SETUP_RATIO,fb(v[2]));speedState(v[3],0)
        local r=V.steerRatioOriginal()
        if fdBits(r)~=v[5] or math.abs(r-v[4])>2*math.abs(v[4])*2^-52 then bad+=1 end
    end
    w8(0x74c9a0,1);wf32(SETUP_RATIO,18)
    check(string.format("00554fb0 steering ratio + low-speed override (8.94 / 17.88 m/s): %d original vectors",#G.ratio),bad==0,bad>0 and (bad.." differ") or nil)
    -- L1 00551e80 tail
    bad=0
    for _,v in ipairs(G.tail) do
        wf32(0xbf6f00,fb(v[1]));w32(CTRL_TYPE+29*7,v[2] and 0 or 1);w32(CTRL_TYPE+29*8,v[2] and 0 or 1)
        wf32(SETUP_RATIO,fb(v[4]));speedState(v[3],0);w32(0xbf63c8,v[5]);w32(0xbf6e80,v[6])
        local t=V._steerTail({})
        if r32(0xbf63c0)~=v[7] or fdBits(t)~=v[8] or fdBits(V._zsub(t,fb(v[6]))/8)~=v[10] then bad+=1 end
    end
    wf32(0xbf6f00,0);wf32(SETUP_RATIO,18)
    check(string.format("00551e80 tail (linearity, x pi, / ratio, ramp): %d original vectors bit-exact",#G.tail),bad==0,bad>0 and (bad.." differ") or nil)
    -- setters
    bad=0
    for _,v in ipairs(G.linUI) do V.setSteeringOptions({linearity=v[1]});if r32(0xbf6f00)~=v[2] then bad+=1 end end
    for _,v in ipairs(G.momentum) do V.setSteeringOptions({momentum=v[1]});if r32(0x74c990)~=v[2] then bad+=1 end end
    V.clearSteeringOptions();V.reset()
    check(string.format("option setters 005502f0 / 005500c0 (controls.cfg 0..100): %d original vectors",#G.linUI+#G.momentum),bad==0,bad>0 and (bad.." differ") or nil)
    -- L2 frame-start snapshots
    local function frameStart(sn)
        local cp=V.checkpoint()
        local b=b64(sn.before);local o=0
        for _,r in ipairs(sn.beforeRuns) do buffer.copy(M_,r[1]-BASE,b,o,4*r[2]);o+=4*r[2] end
        V._frameStartOnly(controlsOf(sn.controls))
        local a=b64(sn.after);o=0
        local n,diff=0,0
        for _,r in ipairs(sn.afterRuns) do
            for k=0,r[2]-1 do
                n+=1
                if r32(r[1]+4*k)~=buffer.readu32(a,o) then diff+=1 end
                o+=4
            end
        end
        V.restore(cp)
        return n,diff
    end
    for _,sc in ipairs(G.scenarios) do
        V.setRuntimeMode("original");V.endSession();V.clearSteeringOptions()
        if sc.ratio then
            local st=V.Setup.cupGarageDefault();V.Setup.set(st,"steeringRatio",sc.ratio);V.applySetup(st)
        else V.applySetup(V.Setup.cupGarageDefault()) end
        V.reset()
        if sc.steer then V.setSteeringOptions(sc.steer,true) end
        V.startSession({temperatureF=70,windSpeedMph=0,windDirection=0,conditions=0,night=false},{damageLevel=0,series=1})
        local nn,dd,cnt=0,0,0
        for i,sn in ipairs(sc.start) do
            if full or i<=sc.quick then
                local n,d=frameStart(sn);nn+=n;dd+=d;cnt+=1
            end
        end
        check(string.format("%s: %d frame starts from the original's traced state: %d written dwords bit-exact",sc.name,cnt,nn),dd==0,dd>0 and (dd.." differ") or nil)
    end
    V.applySetup(V.Setup.cupGarageDefault());V.clearSteeringOptions();V.endSession();V.reset()
    -- behaviour
    for _=1,8*60 do V.drive({throttle=0,clutch=1,steerAxis=-1},FLAT) end
    local ss=V.steeringState()
    check("analog full left at rest: road-wheel target pi / 7 (18:1 -> 7:1 below 8.94 m/s), cockpit wheel -2.79 rad (005662d0)",
        ss.target==fd(rf32(0x6f4a4c)/7) and ss.ratio==7 and math.abs(ss.wheelAngle+rf32(0x6f5e6c))<1e-6,
        string.format("target %.6f ratio %.3f wheel %.4f",ss.target,ss.ratio,ss.wheelAngle))
    V.setSteeringOptions({linearity=80,momentum=0,lowSpeedOverride=false})
    local st=V.Setup.cupGarageDefault();V.Setup.set(st,"steeringRatio",25)
    local okS=V.applySetup(st)
    local o=V.steeringOptions()
    check("options survive a garage rebuild; setup ratio 25 reaches 00554fb0 (override off)",okS and o.setupRatio==25 and o.steerRate==1
        and math.abs(o.linearity-0.8)<1e-6 and V.steerRatioOriginal()==25)
    V.clearSteeringOptions();V.applySetup(V.Setup.cupGarageDefault());V.reset()
    check("steering assistance > 0 refused (needs the NR2003 track racing line)",not pcall(V.setSteeringOptions,{assist=50}))
    check("arcade driving mode (race bit 25: also chassis spec 0 at build, 004233a0) refused",not pcall(V.setSteeringOptions,{yawLimiter=true})
        and V.steeringOptions().drivingMode=="simulation")
    if full then
        local function run(n,k0)
            local out={}
            for i=1,n do
                local k=k0+i
                local c={throttle=0.7,clutch=1,steerAxis=0.2*math.sin(k/20),shiftUp=k==40}
                for _=1,8 do V.drive(c,FLAT) end
                out[i]=r32(0xbf6360)..":"..r32(0xbf6d44)
            end
            return out
        end
        V.reset();local a=run(200,0)
        V.reset();local b=run(100,0);local cp=V.checkpoint();local b2=run(100,100);V.restore(cp);local b3=run(100,100)
        local same=true
        for k=1,100 do if a[k]~=b[k] or a[100+k]~=b2[k] or b2[k]~=b3[k] then same=false end end
        check("determinism + checkpoint/restore with the steering chain (200 frames)",same)
        V.reset()
    end
    print(string.format("[NR2003 Stage 12 self-test] %d passed, %d failed (%.1f s)",passed,failed,os.clock()-t0))
    return failed==0,lines
end
return M
]=])
edit("Roblox","Stage67SelfTest",[=[
if V.setRuntimeMode then V.setRuntimeMode("frozen") end]=],[=[
if V.setRuntimeMode then V.setRuntimeMode("frozen") end if V.setSteeringMode then V.setSteeringMode("provisional") end]=],60457,511586509,60520,2889733461)
edit("Roblox","Stage8SelfTest",[=[
if V.setRuntimeMode then V.setRuntimeMode("frozen") end]=],[=[
if V.setRuntimeMode then V.setRuntimeMode("frozen") end if V.setSteeringMode then V.setSteeringMode("provisional") end]=],188240,3860612614,188303,1091763942)
edit("Roblox","Stage9SelfTest",[=[
if V.setRuntimeMode then V.setRuntimeMode("frozen") end]=],[=[
if V.setRuntimeMode then V.setRuntimeMode("frozen") end if V.setSteeringMode then V.setSteeringMode("provisional") end]=],186234,766859960,186297,3003201880)
edit("Roblox","Stage10SelfTest",[=[
if V.setRuntimeMode then V.setRuntimeMode("frozen") end]=],[=[
if V.setRuntimeMode then V.setRuntimeMode("frozen") end if V.setSteeringMode then V.setSteeringMode("provisional") end]=],198519,2781813066,198582,1233186362)
edit("Roblox","Stage11SelfTest",[=[
    V.setRuntimeMode("original");V.endSession();V.reset()]=],[=[
    V.setRuntimeMode("original");if V.setSteeringMode then V.setSteeringMode("provisional") end;V.endSession();V.reset()]=],172423,250092584,172486,1527985883)
-- 1) baseline check (nothing is changed before every target is verified) -----------------------------------
local plan,problems={},{}
for _,it in ipairs(ITEMS) do
    local s=find(it.folder,it.name)
    if s==nil then
        if it.oldLen~=nil then table.insert(problems,it.folder.."."..it.name.." ausente") else table.insert(plan,{it=it,state="add"}) end
    else
        local src=s.Source;local n,h=#src,fnv(src)
        if n==it.newLen and h==it.newHash then table.insert(plan,{it=it,s=s,state="current"})
        elseif it.oldLen~=nil and n==it.oldLen and h==it.oldHash then table.insert(plan,{it=it,s=s,state="replace"})
        elseif it.oldLen==nil then table.insert(plan,{it=it,s=s,state="replace"})  -- a module this patch adds (re-run)
        else table.insert(problems,string.format("%s.%s difere do Stage 11 publicado (%d bytes, hash %08x): alterado localmente?",it.folder,it.name,n,h)) end
    end
end
for _,e in ipairs(EDITS) do
    local s=find(e.folder,e.name)
    if s==nil then table.insert(problems,e.folder.."."..e.name.." ausente") else
        local src=s.Source;local n,h=#src,fnv(src)
        if n==e.newLen and h==e.newHash then table.insert(plan,{edit=e,s=s,state="current"})
        elseif n==e.oldLen and h==e.oldHash and string.find(src,e.oldLine,1,true) then
            table.insert(plan,{edit=e,s=s,state="edit"})
        else table.insert(problems,string.format("%s.%s difere do Stage 11 publicado (%d bytes, hash %08x)",e.folder,e.name,n,h)) end
    end
end
if #problems>0 and not _G.NR2003_PATCH12_FORCE then
    error("Patch Stage 12 recusado, nada foi alterado:\n  "..table.concat(problems,"\n  ")..
        "\n(_G.NR2003_PATCH12_FORCE=true instala mesmo assim, com backup do que existir)")
end
-- 2) backup of exactly the instances this patch changes (created once; a re-run keeps the first backup) ------
local backup=storage:FindFirstChild("NR2003Backup_Stage12")
local firstInstall=backup==nil
if firstInstall then
    backup=Instance.new("Folder");backup.Name="NR2003Backup_Stage12"
    backup:SetAttribute("FromStage",stage);backup:SetAttribute("FromVersion",pkg:GetAttribute("NR2003Version"))
    backup:SetAttribute("Created",os.time())
    for _,p in ipairs(plan) do
        local key=(p.it and p.it.folder or p.edit.folder).."."..(p.it and p.it.name or p.edit.name)
        if p.s then
            local c=p.s:Clone();c.Name=key;c.Parent=backup
        else
            local v=Instance.new("StringValue");v.Name="ADDED:"..key;v.Value=key;v.Parent=backup
        end
    end
    backup.Parent=storage
end
-- 3) apply (sources updated in place; new modules created) and self-tests; revert on any failure ------------
local touched={}
local function apply()
    for _,p in ipairs(plan) do
        if p.it and p.state~="current" then
            local s=p.s
            if s==nil then
                s=Instance.new(p.it.class);s.Name=p.it.name;s.Parent=FOLDERS[p.it.folder]
            end
            table.insert(touched,{s=s,old=p.state=="add" and nil or s.Source,added=p.state=="add"})
            setSource(s,p.it.source)
            assert(#s.Source==p.it.newLen and fnv(s.Source)==p.it.newHash,"fonte truncada: "..p.it.folder.."."..p.it.name)
        elseif p.edit and p.state=="edit" then
            local s=p.s;local src=s.Source
            local i,j=string.find(src,p.edit.oldLine,1,true)
            local new=string.sub(src,1,i-1)..p.edit.newLine..string.sub(src,j+1)
            table.insert(touched,{s=s,old=src})
            setSource(s,new)
            assert(#s.Source==p.edit.newLen and fnv(s.Source)==p.edit.newHash,"edição incompleta: "..p.edit.folder.."."..p.edit.name)
        end
    end
    pkg:SetAttribute("NR2003Stage","12");pkg:SetAttribute("NR2003Version","3.11.0-stage12")
    for _,n in ipairs({"Stage67SelfTest","Stage8SelfTest","Stage9SelfTest","Stage10SelfTest","Stage11SelfTest","Stage12SelfTest"}) do
        local ok,r=require(RobloxF[n]).run(false)
        assert(ok,"self-test "..n.." falhou:\n"..table.concat(r,"\n"))
    end
end
local ok,reason=pcall(apply)
if not ok then
    for i=#touched,1,-1 do
        local t=touched[i]
        if t.added then t.s:Destroy() else setSource(t.s,t.old) end
    end
    pkg:SetAttribute("NR2003Stage",stage);pkg:SetAttribute("NR2003Version",backup:GetAttribute("FromVersion"))
    if firstInstall then backup:Destroy() end
    error("Patch Stage 12 revertido (fontes restauradas): "..tostring(reason))
end
print("Stage 12 aplicado ("..(firstInstall and "backup: ServerStorage.NR2003Backup_Stage12" or "re-execução: backup anterior mantido")..").")
print("Direção ORIGINAL do NR2003: dispositivo (A/D = teclas, analógico do gamepad = eixo) -> 00552720 (taxa + seno, sensibilidade")
print("  por velocidade) -> linearidade -> x pi / relação do setup (item 0x30, 18:1; 7:1 abaixo de 20 mph) -> rampa + toe -> cubos.")
print("Atributos do TestCar (no reset, R): Setup_steeringRatio 12..32, SteeringLinearity 0..100 (controls.cfg), SteeringMomentum")
print("  0..100 (0 = sem taxa), SteeringLowSpeedOverride true/false (modo arcade e assistência: não portados, recusados). O volante do cockpit é o ângulo original.")
print("O place NÃO foi salvo. Reverter: PATCH_STAGE12_ROLLBACK.lua. Auto-teste completo: require(...Roblox.Stage12SelfTest).run(true)")
