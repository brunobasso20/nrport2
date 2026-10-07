-- ===== host side (005b2190 order; Roblox supplies contact planes instead of the track code) =====
local function b64decode(s)
	local map = {}
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	for i = 1, 64 do map[string.byte(chars, i)] = i - 1 end
	local out = buffer.create(#s * 3 // 4)
	local n, o = #s, 0
	for i = 1, n, 4 do
		local a, b, c, d = string.byte(s, i, i + 3)
		local va, vb = map[a], map[b]
		local vc, vd = c and map[c], d and map[d]
		local x = va * 262144 + vb * 4096 + (vc or 0) * 64 + (vd or 0)
		buffer.writeu8(out, o, rshift(x, 16)); o += 1
		if c ~= 61 then buffer.writeu8(out, o, band(rshift(x, 8), 0xff)); o += 1 end
		if d ~= 61 then buffer.writeu8(out, o, band(x, 0xff)); o += 1 end
	end
	return out, o
end
local PRISTINE = buffer.create(Image.size)
for _, w in ipairs(Image.windows) do
	local b, n = b64decode(w[2])
	buffer.copy(PRISTINE, w[1], b, 0, n)
end

local HOST = Image.host
local OUTF, OUTP, GV, BLK = HOST, HOST + 0x40, HOST + 0x80, HOST + 0xc0
local INPUTS, STATEBLK, ROOT = 0xbf6360, 0xbf6d40, 0x727290
local ENGINE = 0xc12030 + 0xc

local function f2u(x) wf(S, 0, x); return ru(S, 0) end
local function callx(addr, ...)
	local args = { ... }
	local n = #args
	ESP = band(ESP - 4 * (n + 1))
	for k = 1, n do w32(ESP + 4 * k, args[k]) end
	w32(ESP, 0)
	XF[addr]()
	ESP = band(ESP + 4 * n)
end

local V = {}
V.__index = V
V.frequency = 288
V.dt = 0.0034722222480922937

function V.reset()
	buffer.copy(M, 0, PRISTINE, 0, Image.size)
	EAX, EBX, ECX, EDX, ESI, EDI, EBP = 0, 0, 0, 0, 0, 0, 0
	ESP = Image.stackTop; table.clear(F); FT = 0; FSW = 0; BG = 1
	w8(0xbf6e04, 1)      -- 00551880: player vehicle simulated
	w32(0xbf6e9c, 8)     -- 00555140: ticks per task frame
	V.tick = 0
end

-- contact: {nx, ny, nz, d, gvx, gvy, gvz, surface, grip}: plane n.x + d = 0 in vehicle-world axes
local function tires(contacts, phase)
	-- contacts: array of 4 planes, or a function(phase) returning one (the original queries the
	-- track twice per tick, 00578da0 before the first forces pass and 00578de0 before the second)
	if type(contacts) == "function" then contacts = contacts(phase) end
	for i = 0, 3 do
		local c = contacts[i + 1]
		wf(M, GV + 16 * i - BASE, c[5] or 0); wf(M, GV + 16 * i + 4 - BASE, c[6] or 0); wf(M, GV + 16 * i + 8 - BASE, c[7] or 0)
		callx(0x55e1e0, OUTF + 16 * i, f2u(c[9] or 1), OUTP + 16 * i, GV + 16 * i, BLK + 32 * i, i,
			f2u(c[1]), f2u(c[2]), f2u(c[3]), f2u(c[4]), c[8] or 1)
		if FT > 0 then F[FT] = nil; FT = FT - 1 end -- 0055e1e0 float10 return (skid level) unused here
	end
end

local INPUT_KEYS = { "lfSteer", "rfSteer", "throttle", "brake", "clutch", "gear" }
local TPF = 8 -- 00555140: physics ticks per 36 Hz task frame (288 / taskGetRate)

local function exportState() w32(0xe847c8, STATEBLK); callx(0x5b2cb0, STATEBLK, ROOT) end
local function frameEnd()
	-- 00554520 -> 0051aac0(1/taskGetRate): ignition/shift cut timer (+0x550) countdown only.
	-- Engine thermal/fuel burn/damage/misfire of 0051aac0, tire thermal 0054d610 and fuel mass
	-- 005605c0 are Stage 11 and stay frozen at their build values (documented).
	local t = rf32(ENGINE + 0x550)
	if t > 0 then
		t = fd(t - fd(1 / 36))
		wf32(ENGINE + 0x550, t < 0 and 0 or t)
	end
end

-- Raw core tick (inputs written directly to bf6360; used by the emulator comparison tests)
function V.stepRaw(input, contacts)
	for k = 1, 6 do wf(M, INPUTS + 4 * (k - 1) - BASE, input[INPUT_KEYS[k]] or 0) end
	for k = 7, 9 do wf(M, INPUTS + 4 * (k - 1) - BASE, 0) end
	w8(0xe843fc, 1)
	callx(0x5b2b90, ROOT, INPUTS)
	tires(contacts); callx(0x5b2bd0)
	w8(0xe843fc, 0)
	callx(0x5b2be0)
	tires(contacts); callx(0x5b2bd0)
	callx(0x5b2c00)
	V.tick += 1
	if V.tick % TPF == 0 then frameEnd() end
end
V.step = V.stepRaw -- backwards-compatible name

-- ===== host services =====
-- 0055e1e0 per-wheel outputs of the last tire pass: out1 (z = normal load N; x/y semantics not
-- recovered) and contact point (vehicle-world)
function V.contactOut(i)
	local a, b = OUTF + 16 * i, OUTP + 16 * i
	return rf32(a), rf32(a + 4), rf32(a + 8), rf32(b), rf32(b + 4), rf32(b + 8)
end
-- persistent per-wheel contact block (param_5 of 0055e1e0): anchor xyz + 2 tire states.
-- 005778a0 re-initialises it when a contact pair is (re)created: anchor = contact position, states = 0.
function V.resetContactBlock(i, x, y, z)
	local b = BLK + 32 * i
	wf32d(b, x); wf32d(b + 4, y); wf32d(b + 8, z); w32(b + 12, 0); w32(b + 16, 0)
end
-- position teleport through the ORIGINAL state import 005b4560 (component positions are primary
-- integrator state; velocities/momenta are NOT changed by this path)
function V.translate(dx, dy, dz)
	local S = HOST + 0x140
	callx(0x5b2cb0, S, ROOT)
	wf32(S, rf32(S) + dx); wf32(S + 8, rf32(S + 8) + dy); wf32(S + 16, rf32(S + 16) + dz)
	w32(0xe847c8, S); w32(0xe84664, 0xe84474)
	callx(0x5b4560, ROOT)
end
function V.checkpoint()
	local c = buffer.create(Image.size)
	buffer.copy(c, 0, M, 0, Image.size)
	return { memory = c, tick = V.tick }
end
function V.restore(c)
	buffer.copy(M, 0, c.memory, 0, Image.size)
	ESP = Image.stackTop; table.clear(F); FT = 0
	V.tick = c.tick
end

-- 45-state export (005b2cb0) into a host scratch block, so that reading the state never
-- changes the game's own state block bf6d40 (read by 00554f10 / 00554ee0 in the next tick)
local SCRATCH = HOST + 0x140
function V.state(out)
	out = out or table.create(45, 0)
	callx(0x5b2cb0, SCRATCH, ROOT)
	for i = 0, 44 do out[i + 1] = rf32(SCRATCH + 4 * i) end
	return out
end

-- raw access for adapters/telemetry/tests (addresses are original NR2003 addresses)
V.rf32 = rf32; V.ri32 = ri32; V.r32 = r32; V.r8 = r8; V.wf32 = wf32; V.w32 = w32
V.memory = function() return M end
V._callx = callx; V._tires = tires; V._w8 = w8
V._export = exportState; V._frameEnd = frameEnd
V._popF = function() local v = F[FT]; F[FT] = nil; FT = FT - 1; return v end
V.fd = fd; V.wf32d = wf32d; V.rf64 = rf64; V.wf64 = wf64; V.w8 = w8
V.TPF = TPF; V.ENGINE = ENGINE; V.ROOT = ROOT; V.INPUTS = INPUTS; V.STATEBLK = STATEBLK
V._fpu = function() return FT, ESP end
V._jit = function(a) JIT[a]() end
V.base = BASE
-- Stage 10: the setup application (NR2003CupBuild) rebuilds the car on M and commits the result as the
-- new reset image (the original rebuilds the car when a garage setup is applied)
V._pristine = function() return PRISTINE end
V.imageSize = Image.size
-- the translated callback table (005b9d10 targets) and a loader for another callback set built from the
-- same services (Stage 10 generic structure, NR2003CupJITG*)
V._jitTable = function() return JIT end

-- install the translated JIT callbacks (NR2003CupJIT* modules)
local ctx = { M = M, LKF = LKF, LKU = LKU, NB = NB, NC = NC, JIT = JIT }
for _, install in ipairs(jitModules or {}) do install(ctx) end
V._jitLoad = function(modules)
	local t = {}
	local c = { M = M, LKF = LKF, LKU = LKU, NB = NB, NC = NC, JIT = t }
	for _, install in ipairs(modules) do install(c) end
	return t
end
V.reset()
return V
end
