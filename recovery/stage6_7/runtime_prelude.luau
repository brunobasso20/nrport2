--!native
--!optimize 2
-- GENERATED NR2003 Cup vehicle runtime (Stage 6+7). Source: NR2003.exe original x86.
--   * JIT[...]  : x87 callbacks that NR2003 itself generates at car build (005b3090, mode-2 emitter),
--                 translated instruction-by-instruction (predictor 005b39a0, solve 005b3180+0055e410,
--                 tire x4 0055d9c0, forces 005b3990 = 0055f8f0+00560680, corrector 005b3e50, commit 005b2fb0).
--   * XF[...]   : native C functions lifted from x86 (tire 0054cab0, engine 0051a870, drivetrain
--                 projection 0055fc50, differential 005614b0, brakes, aero 00561b70/00410280, ...).
--   * Host step : 005b2190 order (adapter: contact planes come from Roblox instead of the track code).
-- Layout: this core module (natives + machine state + host) and NR2003CupJIT* modules (callbacks),
-- split so that every module stays below the Luau native-code block size (4 MB).
-- Numerics: memory is a byte buffer holding the original float32/int32 cells. Every float32 store
-- rounds toward -inf (NR2003 main loop sets FPU CW 0x077f, 00546f80 -> 00567704(1,3)); FIST
-- rounds toward -inf. x87 extended intermediates are evaluated in IEEE double (approximation).
-- Do not edit by hand: regenerate with recovery/stage6_7/gen_runtime.py.
return function(Image, jitModules)
local M = buffer.create(Image.size)
local BASE = Image.base
local rf, wf, ru, wu = buffer.readf32, buffer.writef32, buffer.readu32, buffer.writeu32
local ri, wi = buffer.readi32, buffer.writei32
local rf64b, wf64b = buffer.readf64, buffer.writef64
local r8b, w8b, r16b, w16b, ri16b, ri8b = buffer.readu8, buffer.writeu8, buffer.readu16, buffer.writeu16, buffer.readi16, buffer.readi8
local band, bor, bxor, bnot, lshift, rshift, arshift = bit32.band, bit32.bor, bit32.bxor, bit32.bnot, bit32.lshift, bit32.rshift, bit32.arshift
local abs, sqrt, sin, cos, floor, fmod = math.abs, math.sqrt, math.sin, math.cos, math.floor, math.fmod
local atan2 = math.atan2
local TINY = 2 ^ -125

-- scratch cell for value rounding
local S = buffer.create(8)
local function fd(x)
	wf(S, 0, x)
	local r = rf(S, 0)
	if r > x then
		local u = ru(S, 0)
		if r > 0 then wu(S, 0, u - 1) elseif r == 0 then wu(S, 0, 0x80000001) else wu(S, 0, u + 1) end
		r = rf(S, 0)
	end
	return r
end
local function wfd(o, x)
	wf(M, o, x)
	local r = rf(M, o)
	if r > x then
		local u = ru(M, o)
		if r > 0 then wu(M, o, u - 1) elseif r == 0 then wu(M, o, 0x80000001) else wu(M, o, u + 1) end
	end
end
-- absolute-address accessors (lifted code)
local function r32(a) return ru(M, a - BASE) end
local function w32(a, v) wu(M, a - BASE, band(v)) end
local function r16(a) return r16b(M, a - BASE) end
local function w16(a, v) w16b(M, a - BASE, band(v, 0xffff)) end
local function r8(a) return r8b(M, a - BASE) end
local function w8(a, v) w8b(M, a - BASE, band(v, 0xff)) end
local function rf32(a) return rf(M, a - BASE) end
local function wf32(a, v) wf(M, a - BASE, v) end
local function wf32d(a, v) wfd(a - BASE, v) end
local function rf64(a) return rf64b(M, a - BASE) end
local function wf64(a, v) wf64b(M, a - BASE, v) end
local function ri16(a) return ri16b(M, a - BASE) end
local function ri32(a) return ri(M, a - BASE) end
local function ri64(a) return ru(M, a - BASE) + ri(M, a - BASE + 4) * 4294967296 end
local function fistround(x)
	-- RC = round toward -inf; out of range / NaN -> integer indefinite
	if x ~= x or x >= 2147483648 or x < -2147483648 then return -2147483648 end
	return floor(x)
end
local function wi32(a, v) wi(M, a - BASE, v) end
local function wi16(a, v) w16b(M, a - BASE, band(v, 0xffff)) end
local function wi64(a, v)
	local lo = v % 4294967296; local hi = (v - lo) / 4294967296
	wu(M, a - BASE, lo); wi(M, a - BASE + 4, hi)
end
local function sx8(v) if v >= 0x80 then return band(v - 0x100) end return v end
local function sx16(v) if v >= 0x8000 then return band(v - 0x10000) end return v end
local function imul32(a, b)
	a = band(a); b = band(b)
	local lo = band(a, 0xffff) * b
	local hi = band(rshift(a, 16) * b, 0xffff) * 65536
	return band(lo + hi)
end
local PAR = {}
for i = 0, 255 do
	local n, v = 0, i
	while v > 0 do n = n + band(v, 1); v = rshift(v, 1) end
	PAR[i] = (n % 2) == 0
end
local function fcmp(a, b)
	if a ~= a or b ~= b then return 0x4500 end
	if a > b then return 0 end
	if a < b then return 0x100 end
	return 0x4000
end

-- machine state (shared by lifted code and JIT code)
local EAX, EBX, ECX, EDX, ESI, EDI, EBP = 0, 0, 0, 0, 0, 0, 0
local ESP = Image.stackTop
local F, FT = table.create(16, 0), 0
local FSW, FCW = 0, 0x77f
local FR, FZ, FS, FC, FO, FP = 0, false, false, false, false, false
local XF = {}      -- lifted functions by original address
local JIT = {}     -- translated JIT callbacks by original generated-code address
local BG = 1       -- inBackground() on the simulation task thread

local function ICALL(a)
	local f = XF[a]
	if not f then error(string.format("NR2003 runtime: indirect call to unknown %08x", a)) end
	f()
end
local function B_nop() ESP = band(ESP + 4) end
local function B_inBackground() EAX = BG; ESP = band(ESP + 4) end
local function B_inServer() EAX = 0; ESP = band(ESP + 4) end
local function B_rdtsc() EAX = 1; ESP = band(ESP + 4) end
local function B_taskGetRate() EAX = 36; ESP = band(ESP + 4) end
local function B_ftol()
	-- 006c5018 (_ftol, encrypted by SecuROM in the shipped exe): truncate ST0 to int64, pop
	local x = F[FT]; F[FT] = nil; FT = FT - 1
	local t = x >= 0 and floor(x) or -floor(-x)
	if t ~= t then t = -2147483648 end
	local lo = t % 4294967296
	EAX = lo; EDX = band((t - lo) / 4294967296)
	ESP = band(ESP + 4)
end
local function B_pow()
	-- 006c5c40 (_CIpow, encrypted): ST1=x, ST0=y -> x^y
	local y = F[FT]; F[FT] = nil; FT = FT - 1
	local x = F[FT]
	F[FT] = (x == 0) and 0 or x ^ y
	ESP = band(ESP + 4)
end
local function B_callback()
	-- 005b9d10: jmp [esp+4] into generated code
	local a = r32(ESP + 4)
	local f = JIT[a]
	if not f then error(string.format("NR2003 runtime: unknown JIT callback %08x", a)) end
	f()
	ESP = band(ESP + 4)
end

-- services for the JIT modules (they own no machine registers)
local function LKF(t, x)
	-- 005677d1 lookup(table*, float x) with the original cdecl frame; returns the popped ST0
	ESP = ESP - 12; wf(M, ESP + 8 - BASE, x); wu(M, ESP + 4 - BASE, t); wu(M, ESP - BASE, 0)
	XF[0x5677d1](); ESP = ESP + 8
	local v = F[FT]; F[FT] = nil; FT = FT - 1
	return v
end
local function LKU(t, x)
	-- same, argument passed as raw 32-bit cell contents
	ESP = ESP - 12; wu(M, ESP + 8 - BASE, x); wu(M, ESP + 4 - BASE, t); wu(M, ESP - BASE, 0)
	XF[0x5677d1](); ESP = ESP + 8
	local v = F[FT]; F[FT] = nil; FT = FT - 1
	return v
end
local function NB(n) ESP = ESP - 4 * (n + 2); return ESP end
local function NC(target, n)
	wu(M, ESP + 4 - BASE, ESP + 8); wu(M, ESP - BASE, 0)
	XF[target]()
	ESP = ESP + 4 * (n + 1)
end
