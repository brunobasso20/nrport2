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

	-- Stage 14 checkpoint: ffb
	V._registerCheckpoint("ffb", function() return {device=device, effect=effect, kind=configuredKind, options=options, last=last} end, function(h)
		device, effect, configuredKind, options = h.device, h.effect, h.kind, h.options
		for k,v in pairs(h.last) do last[k]=v end
	end)
	return V
end
