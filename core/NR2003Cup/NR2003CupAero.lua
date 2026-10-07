--!native
--!optimize 2
-- NR2003 Cup aerodynamics: session air, per-frame aero factors, drafting, aero setup, telemetry
-- (Stage 9). Installed on the runtime returned by NR2003CupDriver. Hand port of x87 code: every
-- float32 store rounds toward -inf like every store of the simulation task (0055cef0 -> CW 0x077f),
-- x87 extended intermediates are evaluated in IEEE double (same approximation as Stages 6-8).
--
-- The aero FORCE model is ORIGINAL generated code (Stage 6/7 modules, untouched). At car build
-- 00561960 registers two natives in the forces callback of the chassis (both lifted):
--   00561a80  half wind velocity (e0b840..e0b848 * 0.5), projected on the plane of the car's
--             track-object vector (car+0x5ae -> +0x24) when the car has a track object
--   00561b70  body-frame air velocity (chassis velocity - half wind, rotated by the chassis
--             rotation) and body rates -> q = 0.5*rho*|v|^2 (rho = e0b84c),
--             yaw = atan2(vy,vx), pitch = atan2(-vz,|vxy|) + c083c4 (setup item 0xb1),
--             front ride height = ((c084c8 - z_LF) + (c084cc - z_RF))/2 (items 0xad/0xae, live
--             LF/RF suspension translation), factors car+0x59e/0x5a2/0x5a6 ->
--             00410280: coefficients from the car spec (+0xa0 area, +0xa4 length, +0xa8..+0xe0
--             scalars, +0xec..+0x134 yaw/pitch/ride-height curves, +0x138..+0x144 damage tables),
--             setup items 0x3b grille tape / 0x3d rear spoiler / 0x20 0x21, damage 00410910 ->
--             force (Fx,Fy,Fz) and moment (Mx,My,Mz) in chassis axes about the chassis origin,
--             rotated to world (005b8370) and added to the chassis spatial force (005b8040).
--             Every 16th call 00410b50 integrates the yaw stall state 007636e0/007636e4.
-- What the car build never runs and the game runs on the simulation task (ported here):
--   session start  0055d3ec -> 0055af80 -> 0055b140 -> 0055a830 -> 005a3c00(weather e0b728,
--                  race settings c0692a): air temperature, wind e0b840/e0b844, density e0b84c
--                  (005a3ba0 humid ideal gas, 005a3be0 saturation pressure polynomial)
--   every frame    0055d3f4 -> 0055b450 -> 0055bfd0 -> 005637e0(car), BEFORE the 8 physics ticks:
--                  factors = 1.0, airspeed car+0x5aa, drafting 005afd80 for the focused car
-- Without startSession() the core stays in its post-build state (rho = 0, factors = 0: no aero),
-- which is exactly the state of every Stage 6/7/8 fixture and self-test.
return function(V)
	local rf32, r32, w32, wf32, wf32d, fd = V.rf32, V.r32, V.w32, V.wf32, V.wf32d, V.fd
	local ri32 = V.ri32
	local callx = V._callx
	local sqrt, sin, cos, atan2, abs, floor = math.sqrt, math.sin, math.cos, math.atan2, math.abs, math.floor
	local S = buffer.create(8)
	local function bits(u) buffer.writeu32(S, 0, u); return buffer.readf32(S, 0) end
	local function f2u(x) buffer.writef32(S, 0, x); return buffer.readu32(S, 0) end
	local function near32(x) buffer.writef32(S, 0, x); return buffer.readf32(S, 0) end -- x87 CW 0x027f store
	local function qword(lo, hi) buffer.writeu32(S, 0, lo); buffer.writeu32(S, 4, hi); return buffer.readf64(S, 0) end
	local NEG0 = -(0 * 1)

	-------------------------------------------------------------------------------------------------
	-- ORIGINAL constants (address -> IEEE-754 single bits). Most of them lie outside the Stage 6/7
	-- image windows; tests/stage9 checks every entry against the NR2003.exe memory export.
	-------------------------------------------------------------------------------------------------
	local KBITS = {
		[0x6e97d8] = 0x3f800000, -- 1.0
		[0x6ea44c] = 0x3f000000, -- 0.5
		[0x6ea4a4] = 0x3c23d70a, -- 0.01 (005afd80 attenuation limit; 00423de0 percent scale)
		[0x6ea4cc] = 0x3dcccccd, -- 0.1 (005afd80 minimum distance)
		[0x6ea514] = 0x40a00000, -- 5.0 (005afd80 minimum wake speed*length)
		[0x6ea67c] = 0x3a83126f, -- 0.001 (005afd80 rear lift distance weight)
		[0x6ef640] = 0x3e99999a, -- 0.3 (005afd80 drag blend)
		[0x6f4164] = 0x3f8ccccd, -- 1.1 (factor upper clamp)
		[0x6f4658] = 0x3ee66666, -- 0.45 (lateral attenuation base)
		[0x6f5350] = 0x40600000, -- 3.5 (005b0230 lateral column split)
		[0x6f5a64] = 0x40e00000, -- 7.0 (maximum lateral offset)
		[0x6f688c] = 0x39d1b717, -- 0.0004 (front lift distance weight)
		[0x6f7340] = 0x42840000, -- 66 (maximum normalised gap, car behind)
		[0x6f7344] = 0x3da0ea0f, -- 0.0785714 (lateral attenuation slope)
		[0x6f7348] = 0x42960000, -- 75 (gap normalisation speed)
		[0x6f734c] = 0x43840000, -- 264 (maximum normalised gap, car ahead)
		[0x6f7350] = 0x3e924925, -- 1/3.5 (005b0230)
		[0x6f7334] = 0x00000000, -- lateral breakpoints 0 / 3.5 / 7 m (005b0230)
		[0x6f7338] = 0x40600000,
		[0x6f733c] = 0x40e00000,
		[0x6f7228] = 0xc2340000, -- wake table x0 = -45 m
		[0x6f722c] = 0x3e088889, -- wake table 1/dx (dx = 7.5 m)
		-- weather -> air (005a3c00 / 005a3ba0 / 005a3be0)
		[0x6efe7c] = 0x42000000, -- 32 (F -> C)
		[0x6f53b8] = 0x3f0e38e4, -- 5/9
		[0x6f6f84] = 0x41e00000, -- +28 C (conditions < 2 and daytime)
		[0x6f6f80] = 0x3f490fd0, -- 45 deg per wind direction step
		[0x6f6f7c] = 0x4553a87b, -- 3386.53 Pa per inHg
		[0x6f6f78] = 0x3b6453d2, -- 0.003484 (1/R_dry)
		[0x6f6f74] = 0x3aac9f30, -- 0.001317 (0.378/R_dry)
		[0x6ee350] = 0x43889333, -- 273.15
		[0x6f6f50] = 0x4418c000, -- 611      saturation vapour pressure (Pa) polynomial in T (C)
		[0x6f6f54] = 0x41dbd4fe, -- 27.479
		[0x6f6f58] = 0x40461965, -- 3.0953
		[0x6f6f5c] = 0xbcd288ce, -- -0.0257
		[0x6f6f60] = 0x3a6bedfa, -- 0.0009
	}
	local K = {}
	for a, u in pairs(KBITS) do K[a] = bits(u) end
	local K_0447 = qword(0xe353f7cf, 0x3fdc9ba5) -- qword 006ef7b0 (mph -> m/s, 005a3c00)
	-- 005a38b0 weather constructor defaults kept in obfuscated (XOR) containers: relative humidity
	-- (weather +0x00) and barometric pressure in inHg (weather +0x2c). The per-frame drift of
	-- 005a4cc0 (dynamic weather, 005a4690/005a4b10) is mapped but not ported.
	local HUMIDITY0, PRESSURE0 = bits(0x3e99999a), bits(0x41ef5c29) -- 0.3, 29.92
	-- wake table 006f7228 (00567818 format: x0, 1/dx, last index 0x1e, 2 columns) rows 006f7234..
	-- column 0: lateral offset 0 m, column 1: 3.5 m; column 2 (7 m) is e7d27c, never written (0).
	local WAKE_BITS = {
		0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xbcac0831, 0xbbe56041, 0xbd73b646, 0xbcac0831,
		0xbda4dd2f, 0xbca0902e, 0xbdc8b439, 0xbc83e426, 0xbdf3b646, 0xbcac0831, 0xbe010625, 0xbce56041,
		0xbdf97247, 0xbd0f5c29, 0xbdf0d844, 0xbd2ee632, 0xbde83e42, 0xbd4e703a, 0xbddfa440, 0xbd5fa440,
		0xbdd59b3d, 0xbd628241, 0xbdcb923a, 0xbd628241, 0xbdbeab36, 0xbd5fa440, 0xbdb33333, 0xbd5cc63f,
		0xbda64c2f, 0xbd542c3d, 0xbd9ad42c, 0xbd4b923a, 0xbd8c7e28, 0xbd3d3c36, 0xbd810625, 0xbd2ee632,
		0xbd6b1c43, 0xbd1db22d, 0xbd542c3d, 0xbd09a027, 0xbd401a37, 0xbcf0d844, 0xbd2c0831, 0xbcc8b439,
		0xbd17f62b, 0xbca64c2f, 0xbd03e426, 0xbc83e426, 0xbcd42c3d, 0xbc4e703a, 0xbca64c2f, 0xbc15182b,
		0xbc656041, 0xbbb78035, 0xbbfc5048, 0xbb378035, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
	}
	local WAKE = table.create(#WAKE_BITS, 0)
	for i, u in ipairs(WAKE_BITS) do WAKE[i] = bits(u) end
	local WAKE_LAST, WAKE_COLS = 30, 2
	-- aero damage tables of the Cup spec (+0x138..+0x144 -> 0071f908/0071f960/0071f9b8/0071fa10, 11 zones
	-- x {slope, detached value}, read by 00410910): these 16 cells (end of the lift table, first 12 cells of
	-- the yaw-moment table) lie outside the Stage 6/7 image windows because the build trace ran without
	-- damage. Original .data values (static export = post-build), restored on every reset.
	local DAMAGE_CELLS = {
		[0x71fa00] = 0x00000000, [0x71fa04] = 0x00000000, [0x71fa08] = 0x00000000, [0x71fa0c] = 0x00000000,
		[0x71fa10] = 0x00000000, [0x71fa14] = 0x00000000, [0x71fa18] = 0x00000000, [0x71fa1c] = 0x00000000,
		[0x71fa20] = 0x3c23d70a, [0x71fa24] = 0x3c449ba6, [0x71fa28] = 0xbc23d70a, [0x71fa2c] = 0xbc449ba6,
		[0x71fa30] = 0x3ba3d70a, [0x71fa34] = 0x3bb43958, [0x71fa38] = 0xbba3d70a, [0x71fa3c] = 0xbbb43958,
	}
	local function restoreImageCells()
		for a, u in pairs(DAMAGE_CELLS) do w32(a, u) end
	end
	restoreImageCells()

	-------------------------------------------------------------------------------------------------
	-- original cells
	-------------------------------------------------------------------------------------------------
	local WEATHER = 0xe0b728        -- 005a3c00 / 005a4cc0 'this' (session weather object)
	local AIR = WEATHER + 0x118     -- e0b840 wind x, e0b844 wind y, e0b848 wind z, e0b84c density
	local TRACK_NORTH = 0xbdbcf8    -- track orientation angle read by 005a3c00 (track data)
	local CAR = 0xc12030            -- player car slot (00562f70(0))
	local F_DRAG, F_FRONT, F_REAR, AIRSPEED, TRACKOBJ = 0x59e, 0x5a2, 0x5a6, 0x5aa, 0x5ae
	local SPEC = r32(CAR + 0x58a)   -- car spec (Cup speedway 0x7238e0)
	local SETUP = 0xc055c0          -- active setup (00557d60(n) = setup + 4n)
	local ITEM_TAPE, ITEM_SPOILER = 0x3b, 0x3d
	local DESC_TAPE, DESC_SPOILER = 0x6ee11c, 0x6ee138 -- garage descriptors: int min/max/step/default
	local ONE = 0x3f800000
	local HOST = 0xf7f100
	local BLOCK, OUT6, TOBJ = HOST + 0x600, HOST + 0x640, HOST + 0x680 -- telemetry args, outputs, track object
	local ROOT = V.ROOT
	local LF_SUSP, RF_SUSP = r32(0xc084c0), r32(0xc08310) -- lfsusp / rfsusp records (0055e9b0)

	-- x87 FSUB under RC = toward -inf: an exact zero difference is -0 (except +0 - (-0) = +0)
	local function subRTN(a, b)
		local r = a - b
		if r == 0 then
			if a ~= 0 then return NEG0 end
			if 1 / a > 0 and 1 / b < 0 then return 0 end
			return NEG0
		end
		return r
	end
	local function clampInt(x, lo, hi, default)
		x = tonumber(x)
		if x == nil or x ~= x then return default end
		x = floor(x + 0.5)
		if x < lo then return lo elseif x > hi then return hi end
		return x
	end
	local function f32(x) return near32(tonumber(x) or 0) end

	-------------------------------------------------------------------------------------------------
	-- weather -> air (005a3c00 subset that feeds the aero cells; settings clamped by the option
	-- getters 004cd280 temperature 40..110 F, 004cd2d0 wind 0..30 mph, 004cd2b0 direction 0..7
	-- (out of range -> 0), 004cd260 conditions 0..3 (out of range -> 0))
	-------------------------------------------------------------------------------------------------
	-- 005a3be0: saturation vapour pressure (Pa) at T (C), Horner over 006f6f60..006f6f50
	local function esat(t)
		local v = K[0x6f6f60]
		v = v * t + K[0x6f6f5c]
		v = v * t + K[0x6f6f58]
		v = v * t + K[0x6f6f54]
		return v * t + K[0x6f6f50]
	end
	-- 005a3ba0(T C, P Pa (float32 argument), RH): the P*0.003484 product is stored back into the
	-- float argument slot (FSTP, RC down) before (P' - esat*RH*0.001317) / (T + 273.15)
	local function density(t, p, rh)
		local p2 = fd(p * K[0x6f6f78])
		return (p2 - esat(t) * rh * K[0x6f6f74]) / (t + K[0x6ee350])
	end
	V.airDensityOriginal = function(t, p, rh) return fd(density(t, p, rh)) end
	V.esatOriginal = esat

	local session = nil  -- applied weather settings (nil = post-build state, no aero inputs)
	local draftEnv = nil
	local trackNormal = nil

	local function applyWeather(w)
		local tF = clampInt(w.temperatureF, 40, 110, 70)
		local mph = clampInt(w.windSpeedMph, 0, 30, 0)
		local dir = clampInt(w.windDirection, -1, 8, 0); if dir < 0 or dir > 7 then dir = 0 end
		local cond = clampInt(w.conditions, -1, 4, 0); if cond < 0 or cond > 3 then cond = 0 end
		local night = w.night == true and 1 or 0
		local north = f32(w.trackNorth or 0)
		local rh = w.humidity ~= nil and f32(w.humidity) or HUMIDITY0
		local inHg = w.pressureInHg ~= nil and f32(w.pressureInHg) or PRESSURE0
		local applied = {temperatureF = tF, windSpeedMph = mph, windDirection = dir, conditions = cond,
			night = night == 1, trackNorth = north, humidity = rh, pressureInHg = inHg}
		-- +0x108 air temperature (C): FILD; FSUB 32; FMUL 5/9; FSTP
		local tC = fd((tF - K[0x6efe7c]) * K[0x6f53b8])
		wf32(WEATHER + 0x108, tC)
		-- +0x10c: +28 C when conditions < 2 and the daytime container (+0x2bc, settings+0x48 bit 1) is 0
		local tAir = tC
		if cond < 2 and night == 0 then tAir = fd(tC + K[0x6f6f84]) end
		wf32(WEATHER + 0x10c, tAir)
		-- +0x110 wind direction angle: FILD qword dir; FMUL 0.7853975; FSTP (container round trip)
		local ang = fd(dir * K[0x6f6f80])
		wf32(WEATHER + 0x110, ang)
		-- +0x114 wind speed m/s: FILD mph; FMUL qword 0.447; FSTP
		local spd = fd(mph * K_0447)
		wf32(WEATHER + 0x114, spd)
		-- +0x118 / +0x11c wind vector: -(cos|sin)(trackNorth - direction) * speed
		wf32(TRACK_NORTH, north)
		local d = subRTN(north, ang)
		wf32d(AIR, -(cos(d) * spd))
		wf32d(AIR + 4, -(sin(d) * spd))
		-- +0x120 (e0b848, wind z) is not written by 005a3c00 (BSS 0)
		-- +0x124 density: 005a3ba0(T = +0x10c, P = fd(inHg * 3386.53), RH)
		wf32d(AIR + 12, density(tAir, fd(inHg * K[0x6f6f7c]), rh))
		applied.airTemperatureC = tC; applied.densityTemperatureC = tAir
		applied.windAngle = ang; applied.windSpeed = spd
		applied.wind = {rf32(AIR), rf32(AIR + 4), rf32(AIR + 8)}; applied.density = rf32(AIR + 12)
		return applied
	end

	-------------------------------------------------------------------------------------------------
	-- drafting: 005afd80 + 005b0230 + 00567818 + 00516daa
	-------------------------------------------------------------------------------------------------
	-- 00516daa(a, b): b - a, increased by the track length (bad918) while negative
	local function trackGap(a, b, len)
		local g = subRTN(b, a)
		while g < 0 do g = g + len end
		return g
	end
	-- 00567818 on the wake table: 2 float32 outputs (e7d274, e7d278); FIST rounds down (RC)
	local function wakeLookup(x)
		local u = (x - K[0x6f7228]) * K[0x6f722c]
		local i
		if u ~= u or u >= 2147483648 or u < -2147483648 then i = -2147483648 else i = floor(u) end
		local frac
		if i < 0 then i = 0; frac = u
		elseif i > WAKE_LAST then i = WAKE_LAST; frac = u - WAKE_LAST
		else frac = u - i end
		local row, nxt = i * WAKE_COLS, (i + 1) * WAKE_COLS
		local a0, a1 = WAKE[row + 1], WAKE[row + 2]
		return fd((WAKE[nxt + 1] - a0) * frac + a0), fd((WAKE[nxt + 2] - a1) * frac + a1)
	end
	-- 005b0230(gap, |lateral|): linear blend of the two lateral columns (column 2 = 0)
	local function wake(g, lat)
		local c0, c1 = wakeLookup(g)
		local lo, hi, bp
		if lat < K[0x6f5350] then lo, hi, bp = c0, c1, K[0x6f7334] else lo, hi, bp = c1, 0, K[0x6f7338] end
		return subRTN(lat, bp) * subRTN(hi, lo) * K[0x6f7350] + lo
	end
	V.wakeOriginal = wake

	-- one direction of the race-order ring (car+4: cars ahead, car+8: cars behind)
	local function draftPass(cars, selfDist, selfLat, len, ahead)
		local maxGap = ahead and K[0x6f734c] or K[0x6f7340]
		local prod, att = 1.0, 1.0
		for _, c in ipairs(cars) do
			if not (att > K[0x6ea4a4]) then break end
			local g
			if ahead then g = trackGap(selfDist, f32(c.lapDistance), len) else g = trackGap(f32(c.lapDistance), selfDist, len) end
			if not (g < maxGap) then break end
			local vx, vy, vz = f32(c.vx), f32(c.vy), f32(c.vz)
			local d = sqrt((vx * vx + vy * vy) + vz * vz) * f32(c.wakeLength or rf32(SPEC + 0xd4))
			if d < K[0x6ea514] then d = K[0x6ea514] end
			local gn = g * (K[0x6f7348] / d)
			local gn32 = fd(gn)
			if gn > maxGap then break end
			local lat = abs(fd(subRTN(selfLat, f32(c.lateral))))
			if lat < K[0x6f5a64] then
				local wk = wake(ahead and gn32 or -gn32, lat) * f32(c.wakeStrength or rf32(SPEC + 0xd0)) * att
				prod = fd((1 + wk) * prod)
				local gg = gn32 * gn32
				local r = sqrt(lat * lat + gg)
				if r > K[0x6ea4cc] then
					local cell = CAR + (ahead and F_FRONT or F_REAR)
					local k = ahead and K[0x6f688c] or K[0x6ea67c]
					wf32d(cell, ((wk * gn32) / ((gg * k + 1) * r) + 1) * rf32(cell))
				end
				att = fd((lat * K[0x6f7344] + K[0x6f4658]) * att)
			end
		end
		return prod
	end
	local function clampFactor(v)
		if v < K[0x6ea44c] then return K[0x6ea44c] end
		if v < K[0x6f4164] or v == K[0x6f4164] or v ~= v then return v end
		return K[0x6f4164]
	end
	-- env: {trackLength, lapDistance, lateral, ahead = {car...}, behind = {car...}}, car = {lapDistance,
	-- lateral, vx, vy, vz, wakeStrength (spec+0xd0), wakeLength (spec+0xd4)} in race order
	local function drafting(env)
		local len = f32(env.trackLength)
		local selfDist, selfLat = f32(env.lapDistance), f32(env.lateral)
		local p14 = draftPass(env.ahead or {}, selfDist, selfLat, len, true)
		local p10 = draftPass(env.behind or {}, selfDist, selfLat, len, false)
		local mn = (p14 < p10) and p14 or p10
		local mx = (p14 < p10 or p14 == p10) and p10 or p14
		wf32d(CAR + F_DRAG, clampFactor((1 - (1 - mx) * K[0x6ef640]) * mn))
		wf32d(CAR + F_FRONT, clampFactor(rf32(CAR + F_FRONT)))
		wf32d(CAR + F_REAR, clampFactor(rf32(CAR + F_REAR)))
	end
	V.draftingOriginal = drafting

	-------------------------------------------------------------------------------------------------
	-- per-frame aero update: 005637e0 subset, run by NR2003CupDriver before frameStart
	-------------------------------------------------------------------------------------------------
	-- track-object velocity = render copy (005543f0) of the exported chassis velocity bf6d44/4c/54
	local function frameAero()
		if session == nil then return end
		local dx = fd(rf32(0xbf6d44) - rf32(AIR))
		local dy = rf32(0xbf6d4c) - rf32(AIR + 4)
		local dz = rf32(0xbf6d54) - rf32(AIR + 8)
		w32(CAR + F_DRAG, ONE); w32(CAR + F_FRONT, ONE); w32(CAR + F_REAR, ONE)
		wf32d(CAR + AIRSPEED, sqrt((dz * dz + dy * dy) + dx * dx))
		if draftEnv then drafting(draftEnv) end
	end
	V._aeroFrame = frameAero

	local function applyTrackObject()
		if trackNormal then
			wf32(TOBJ + 0x24, trackNormal[1]); wf32(TOBJ + 0x28, trackNormal[2]); wf32(TOBJ + 0x2c, trackNormal[3])
			w32(CAR + TRACKOBJ, TOBJ)
		else
			w32(CAR + TRACKOBJ, 0)
		end
	end

	-------------------------------------------------------------------------------------------------
	-- API
	-------------------------------------------------------------------------------------------------
	-- session start (005a3c00): weather = {temperatureF, windSpeedMph, windDirection (0..7, 45 deg
	-- steps), conditions (0..3), night, trackNorth (rad), humidity, pressureInHg}; nil = defaults
	-- of the race options (70 F, no wind, conditions 0, daytime) and of the weather constructor.
	function V.startSession(weather)
		session = applyWeather(weather or {})
		session.request = table.clone(weather or {})
		applyTrackObject()
		return session
	end
	-- back to the post-build state (no session start: rho = 0, factors as built)
	function V.endSession()
		session = nil
		w32(AIR, 0); w32(AIR + 4, 0); w32(AIR + 8, 0); w32(AIR + 12, 0)
		for _, o in ipairs({F_DRAG, F_FRONT, F_REAR, AIRSPEED}) do w32(CAR + o, 0) end
		w32(CAR + TRACKOBJ, 0)
	end
	function V.sessionActive() return session ~= nil end
	function V.weather() return session end
	-- drafting environment (005afd80 inputs); nil = no race-order ring (single car: factors 1.0)
	function V.setDraftEnvironment(env)
		if env ~= nil then
			assert(type(env) == "table", "draft environment must be a table")
			local hasCars = (env.ahead and #env.ahead > 0) or (env.behind and #env.behind > 0)
			assert(not hasCars or (tonumber(env.trackLength) or 0) > 0, "draft environment needs trackLength > 0")
		end
		draftEnv = env
	end
	-- vector of the car's track object (+0x24) used by 00561a80 to project the wind; nil = no
	-- track object (car+0x5ae = 0: wind used unprojected, as in the post-build state)
	function V.setTrackNormal(n)
		trackNormal = n and {f32(n[1]), f32(n[2]), f32(n[3])} or nil
		applyTrackObject()
	end
	function V.aeroFactors()
		return rf32(CAR + F_DRAG), rf32(CAR + F_FRONT), rf32(CAR + F_REAR), rf32(CAR + AIRSPEED)
	end

	-- garage aero items read at run time by 00410280 (no build-time conversion uses them):
	--   0x3b grille tape  % 0..100 step 5 -> 00423de0: FILD; FMUL 0.01f; FSTP (CW 0x027f, nearest)
	--   0x3d rear spoiler deg 45..70 step 1 -> 004241d0: FILD (deg - 45); FSTP
	-- (item 0x3b also feeds the engine cooling of 00554520 -> 0051a000: Stage 11, frozen)
	local function desc(d) return ri32(d + 2), ri32(d + 6), ri32(d + 10), ri32(d + 14) end
	function V.setAeroSetup(s)
		s = s or {}
		local lo, hi, step, def = desc(DESC_TAPE)
		local tape = tonumber(s.grilleTape) or def
		tape = math.clamp(floor(tape / step + 0.5) * step, lo, hi)
		wf32(SETUP + 4 * ITEM_TAPE, near32(tape * K[0x6ea4a4]))
		local lo2, hi2, _, def2 = desc(DESC_SPOILER)
		local sp = math.clamp(floor((tonumber(s.spoiler) or def2) + 0.5), lo2, hi2)
		wf32(SETUP + 4 * ITEM_SPOILER, sp - 45)
		return tape, sp
	end
	function V.aeroSetup()
		local t, sp = rf32(SETUP + 4 * ITEM_TAPE), rf32(SETUP + 4 * ITEM_SPOILER)
		return floor(t * 100 + 0.5), sp + 45, t, sp
	end

	-- telemetry: the ORIGINAL 00561b70 evaluated at the current exported state (chassis velocity
	-- relative to the half wind of 00561a80, body rates), with its side effects (call counter
	-- 0074e090, stall state 007636e0/e4) saved and restored. Read-only for the simulation.
	local st = table.create(45, 0)
	local pos, rot = table.create(3, 0), table.create(9, 0)
	function V.aeroState(out)
		out = out or {}
		local exportTarget = r32(0xe847c8) -- 005b2cb0 records its target block here
		V.state(st)
		w32(0xe847c8, exportTarget)
		V.componentPose(0, pos, rot)
		local wx, wy, wz = rf32(AIR), rf32(AIR + 4), rf32(AIR + 8)
		local tobj = r32(CAR + TRACKOBJ)
		if tobj ~= 0 then
			local nx, ny, nz = rf32(tobj + 0x24), rf32(tobj + 0x28), rf32(tobj + 0x2c)
			local dn = wx * nx + wz * nz + wy * ny
			wx, wy, wz = wx - dn * nx, wy - dn * ny, wz - dn * nz
		end
		local rx, ry, rz = st[2] - wx * 0.5, st[4] - wy * 0.5, st[6] - wz * 0.5
		local bx = rot[1] * rx + rot[4] * ry + rot[7] * rz
		local by = rot[2] * rx + rot[5] * ry + rot[8] * rz
		local bz = rot[3] * rx + rot[6] * ry + rot[9] * rz
		for k = 0, 5 do w32(BLOCK + 4 * k, OUT6 + 4 * k) end
		wf32(BLOCK + 24, bx); wf32(BLOCK + 28, by); wf32(BLOCK + 32, bz)
		wf32(BLOCK + 36, st[11]); wf32(BLOCK + 40, st[12]); wf32(BLOCK + 44, st[13])
		local c0, e0, e4 = r32(0x74e090), r32(0x7636e0), r32(0x7636e4)
		callx(0x561b70, BLOCK)
		w32(0x74e090, c0); w32(0x7636e0, e0); w32(0x7636e4, e4)
		local fx, fy, fz = rf32(OUT6), rf32(OUT6 + 4), rf32(OUT6 + 8)
		local mx, my, mz = rf32(OUT6 + 12), rf32(OUT6 + 16), rf32(OUT6 + 20)
		local rho = rf32(AIR + 12)
		local v2 = bx * bx + by * by + bz * bz
		out.density = rho; out.wind = out.wind or {}; out.wind[1], out.wind[2], out.wind[3] = rf32(AIR), rf32(AIR + 4), rf32(AIR + 8)
		out.q = v2 * rho * 0.5; out.airspeedBody = sqrt(v2)
		out.vx, out.vy, out.vz = bx, by, bz
		out.yaw = atan2(by, bx); out.pitch = atan2(-bz, sqrt(bx * bx + by * by)) + rf32(0xc083c4)
		out.fx, out.fy, out.fz, out.mx, out.my, out.mz = fx, fy, fz, mx, my, mz
		out.drag = -fx; out.downforce = -fz; out.side = fy
		-- equivalent axle split of (Fz, My) about the chassis origin, lever arms = LF suspension and
		-- rear axle attachment x offsets of the component records (presentation/telemetry only)
		local xf, xr = rf32(LF_SUSP + 0x44), rf32(ROOT + 9 * 0x505 + 0x44)
		local front = (my - xr * out.downforce) / (xf - xr)
		out.downforceFront, out.downforceRear = front, out.downforce - front
		local zlf, zrf = rf32(r32(LF_SUSP + 0x2d5)), rf32(r32(RF_SUSP + 0x2d5))
		out.rideHeightFront = ((rf32(0xc084c8) - zlf) + (rf32(0xc084cc) - zrf)) * 0.5
		out.groundProximity = math.max(0, 0.1778 - math.max(0, out.rideHeightFront)) -- 006ec748 = 7 in
		local d, f, r, a = V.aeroFactors()
		out.factorDrag, out.factorFront, out.factorRear, out.airspeed = d, f, r, a
		out.stall = rf32(0x7636e4)
		out.session = session ~= nil
		return out
	end

	-- session state survives V.reset() (a reset reloads the car into the same session)
	local baseReset = V.reset
	function V.reset()
		baseReset()
		restoreImageCells()
		if session ~= nil then
			applyWeather(session.request)
			applyTrackObject()
		end
	end
	V._aeroConstants = KBITS
	V._aeroWake = WAKE_BITS
	V._aeroDamageCells = DAMAGE_CELLS
	return V
end
