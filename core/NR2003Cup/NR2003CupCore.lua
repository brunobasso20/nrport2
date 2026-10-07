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

-- ===== lifted natives (86 functions) =====
XF[0x410280] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 48
ESP = ESP - 4; wu(M, ESP - 7245824, EBX)
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
s0 = rf(M, ESP - 7245740)
do local x = s0; s0 = sin(x); s1 = cos(x) end
wfd(ESP - 7245800, s1)
wfd(ESP - 7245768, s0)
EAX = ru(M, ESP - 7245800)
wu(M, ESP - 7245772, EAX)
EAX = ru(M, ESP - 7245772)
EAX = band(band(EAX, 2147483647), 4294967295)
wu(M, ESP - 7245764, EAX)
s0 = rf(M, ESP - 7245744)
s0 = cos(s0)
wu(M, ESP - 7245784, 0)
wfd(ESP - 7245804, s0)
s0 = rf(M, ESP - 7245800)
s0 = s0 * rf(M, ESP - 7245804)
wfd(ESP - 7245772, s0)
s0 = rf(M, ESP - 7245800)
s0 = s0 + rf(M, 2008)
s0 = s0 * rf(M, 5196)
wfd(ESP - 7245780, s0)
ESP = ESP - 4
XF[0x55ab00]()
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x562f70]()
ECX = band(ESP + 40)
ESI = EAX
EDX = band(ESP + 36)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
EAX = band(ESP + 36)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ECX = band(ESP + 28)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ESP = ESP - 4
XF[0x410910]()
EDX = ru(M, band(ESI) - 7245824)
ESP = ESP + 24
ECX = ESI
ESP = ESP - 4; wu(M, ESP - 7245824, 1)
ESP = ESP - 4
ICALL(ru(M, band(EDX + 4) - 7245824))
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x5486a0]()
s0 = F[FT]; FT = FT - 1
FSW = fcmp(s0, rf(M, 2008))
ESP = ESP + 8
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 65), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 2 else pc = 1 end
elseif pc == 1 then
ESP = ESP - 4; wu(M, ESP - 7245824, 59)
ECX = 12604864
ESP = ESP - 4
XF[0x557d60]()
EAX = ru(M, band(EAX) - 7245824)
wu(M, ESP - 7245784, EAX)
pc = 2
elseif pc == 2 then
ESP = ESP - 4; wu(M, ESP - 7245824, 61)
ECX = 12604864
ESP = ESP - 4
XF[0x557d60]()
ESI = ru(M, ESP - 7245748)
ECX = ru(M, band(EAX) - 7245824)
wu(M, ESP - 7245776, ECX)
s0 = rf(M, band(ESI + 180) - 7245824)
FSW = fcmp(s0, rf(M, 5204))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 68), 255)
FP = PAR[band(r, 0xff)]
end
if not FP then pc = 10 else pc = 3 end
elseif pc == 3 then
ESP = ESP - 4; wu(M, ESP - 7245824, 32)
ECX = 12604864
ESP = ESP - 4
XF[0x557d60]()
s0 = rf(M, band(EAX) - 7245824)
s1 = rf(M, 14068)
s1 = s1 + s1
s2 = s0
FSW = fcmp(s2, s1)
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 5 else pc = 4 end
elseif pc == 4 then
s1, s0 = s0, s1
s1 = s1 - s0
s1 = s1 * rf(M, band(ESI + 180) - 7245824)
s1 = s1 + rf(M, ESP - 7245808)
wfd(ESP - 7245808, s1)
pc = 6
elseif pc == 5 then
pc = 6
elseif pc == 6 then
ESP = ESP - 4; wu(M, ESP - 7245824, 33)
ECX = 12604864
ESP = ESP - 4
XF[0x557d60]()
s0 = rf(M, band(EAX) - 7245824)
s1 = rf(M, 14068)
s1 = s1 + s1
s2 = s0
FSW = fcmp(s2, s1)
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 8 else pc = 7 end
elseif pc == 7 then
s1, s0 = s0, s1
s1 = s1 - s0
s1 = s1 * rf(M, band(ESI + 180) - 7245824)
s1 = s1 + rf(M, ESP - 7245808)
wfd(ESP - 7245808, s1)
pc = 9
elseif pc == 8 then
pc = 9
elseif pc == 9 then
pc = 10
elseif pc == 10 then
s0 = rf(M, ESP - 7245732)
FSW = fcmp(s0, rf(M, 5204))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 12 else pc = 11 end
elseif pc == 11 then
wu(M, ESP - 7245732, 0)
pc = 12
elseif pc == 12 then
s0 = rf(M, 14152)
s0 = s0 - rf(M, ESP - 7245732)
wfd(ESP - 7245732, s0)
FSW = fcmp(s0, rf(M, 5204))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 14 else pc = 13 end
elseif pc == 13 then
wu(M, ESP - 7245732, 0)
pc = 14
elseif pc == 14 then
EBP = ru(M, ESP - 7245744)
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ESP = ESP - 4
XF[0x410750]()
s0 = F[FT]; FT = FT - 1
EDX = ru(M, ESP - 7245724)
wfd(ESP - 7245736, s0)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ESP = ESP - 4
XF[0x4108b0]()
s0 = F[FT]; FT = FT - 1
s1 = rf(M, ESP - 7245768)
s1 = s1 * rf(M, band(ESI + 184) - 7245824)
EDI = ru(M, ESP - 7245724)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
s1 = s1 * rf(M, ESP - 7245756)
s2 = rf(M, ESP - 7245752)
s2 = s2 * rf(M, band(ESI + 196) - 7245824)
s2 = s2 * rf(M, ESP - 7245696)
s1 = s1 + s2
s1 = s1 - rf(M, band(ESI + 168) - 7245824)
s0 = s0 + s1
s0 = s0 + rf(M, ESP - 7245784)
s0 = s0 * rf(M, ESP - 7245748)
wfd(ESP - 7245724, s0)
ESP = ESP - 4
XF[0x410630]()
s0 = F[FT]; FT = FT - 1
s0 = s0 * rf(M, ESP - 7245780)
EBX = ru(M, ESP - 7245732)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
s0 = s0 + rf(M, ESP - 7245716)
s1 = rf(M, ESP - 7245768)
s1 = s1 * rf(M, ESP - 7245712)
s0 = s0 + s1
s0 = s0 * rf(M, ESP - 7245696)
wfd(band(EBX) - 7245824, s0)
ESP = ESP - 4
XF[0x410670]()
s0 = F[FT]; FT = FT - 1
s0 = s0 * rf(M, ESP - 7245772)
s1 = rf(M, ESP - 7245736)
s1 = s1 * rf(M, ESP - 7245712)
EAX = ru(M, ESP - 7245700)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
s0 = s0 + s1
wfd(band(EBX + 4) - 7245824, s0)
ESP = ESP - 4
XF[0x4108d0]()
s0 = F[FT]; FT = FT - 1
s1 = rf(M, 2008)
s1 = s1 - rf(M, ESP - 7245688)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
s1 = s1 * rf(M, band(ESI + 216) - 7245824)
s0 = s0 + s1
s1 = rf(M, ESP - 7245736)
s1 = s1 * rf(M, band(ESI + 188) - 7245824)
s1 = s1 * rf(M, ESP - 7245732)
s1 = s1 * rf(M, ESP - 7245676)
s0 = s0 + s1
s1 = rf(M, ESP - 7245728)
s1 = s1 * rf(M, band(ESI + 200) - 7245824)
s1 = s1 * rf(M, ESP - 7245672)
s0 = s0 + s1
s0 = s0 * rf(M, ESP - 7245724)
wfd(ESP - 7245696, s0)
ESP = ESP - 4
XF[0x410690]()
s0 = F[FT]; FT = FT - 1
s1 = rf(M, ESP - 7245732)
s1 = s1 * rf(M, band(ESI + 172) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
s0 = s0 + s1
s0 = s0 + rf(M, ESP - 7245736)
s0 = s0 * rf(M, ESP - 7245744)
s0 = s0 + rf(M, ESP - 7245684)
wfd(ESP - 7245684, s0)
ESP = ESP - 4
XF[0x4107b0]()
s0 = F[FT]; FT = FT - 1
s0 = s0 * rf(M, ESP - 7245704)
ESP = ESP + 60
s0 = s0 + rf(M, ESP - 7245744)
wfd(band(EBX + 8) - 7245824, s0)
FSW = fcmp(s0, rf(M, 5676))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 16 else pc = 15 end
elseif pc == 15 then
wu(M, band(EBX + 8) - 7245824, 1077936128)
pc = 16
elseif pc == 16 then
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ESP = ESP - 4
XF[0x410850]()
s0 = F[FT]; FT = FT - 1
wfd(ESP - 7245736, s0)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ESP = ESP - 4
XF[0x4106d0]()
s0 = F[FT]; FT = FT - 1
s0 = s0 * rf(M, ESP - 7245788)
s1 = rf(M, ESP - 7245752)
s1 = s1 * rf(M, ESP - 7245728)
EBX = ru(M, ESP - 7245736)
ECX = ru(M, ESP - 7245716)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
s1 = s1 * rf(M, 14148)
s0 = s0 - s1
wfd(band(EBX) - 7245824, s0)
ESP = ESP - 4
XF[0x4108f0]()
s0 = F[FT]; FT = FT - 1
s1 = rf(M, 2008)
s1 = s1 - rf(M, ESP - 7245700)
EDX = ru(M, ESP - 7245776)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
s1 = s1 * rf(M, band(ESI + 220) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
s0 = s0 + s1
s1 = rf(M, 2008)
s1 = s1 - rf(M, ESP - 7245684)
s1 = s1 * rf(M, band(ESI + 224) - 7245824)
s0 = s0 + s1
s1 = rf(M, ESP - 7245748)
s1 = s1 * rf(M, band(ESI + 192) - 7245824)
s1 = s1 * rf(M, ESP - 7245744)
s1 = s1 * rf(M, ESP - 7245688)
s0 = s0 + s1
s1 = rf(M, ESP - 7245740)
s1 = s1 * rf(M, band(ESI + 204) - 7245824)
s1 = s1 * rf(M, ESP - 7245684)
s0 = s0 + s1
s0 = s0 * rf(M, ESP - 7245736)
wfd(ESP - 7245696, s0)
ESP = ESP - 4
XF[0x4106f0]()
s0 = F[FT]; FT = FT - 1
s0 = s0 + rf(M, ESP - 7245756)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
s0 = s0 * rf(M, ESP - 7245760)
s0 = s0 + rf(M, ESP - 7245688)
s1 = rf(M, ESP - 7245756)
s1 = s1 * rf(M, ESP - 7245700)
s0 = s0 + s1
wfd(band(EBX + 4) - 7245824, s0)
ESP = ESP - 4
XF[0x410730]()
s0 = F[FT]; FT = FT - 1
s0 = s0 + rf(M, ESP - 7245744)
ESP = ESP + 44
s0 = s0 * rf(M, ESP - 7245804)
EDI = ru(M, ESP - 7245824); ESP = ESP + 4
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
EBP = ru(M, ESP - 7245824); ESP = ESP + 4
wfd(band(EBX + 8) - 7245824, s0)
EBX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 48
ESP = ESP + 4
do return end
end
end
end
XF[0x410630] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ESI = ru(M, ESP - 7245812)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
EDI = ru(M, ESP - 7245812)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
EAX = ru(M, band(EDI + 236) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x5677d1]()
s0 = F[FT]; FT = FT - 1
ECX = ru(M, band(EDI + 240) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
wfd(ESP - 7245796, s0)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ESP = ESP - 4
XF[0x5677d1]()
s0 = F[FT]; FT = FT - 1
s0 = s0 * rf(M, 501476)
ESP = ESP + 16
s0 = s0 + rf(M, ESP - 7245808)
EDI = ru(M, ESP - 7245824); ESP = ESP + 4
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
end
end
end
XF[0x410670] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ECX = ru(M, ESP - 7245820)
EAX = ru(M, ESP - 7245816)
wu(M, ESP - 7245816, EAX)
EDX = ru(M, band(ECX + 244) - 7245824)
wu(M, ESP - 7245820, EDX)
pc = 1
elseif pc == 1 then
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
EBP = ESP
ESP = ESP - 4
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EAX = ru(M, EBP - 7245816)
s0 = rf(M, EBP - 7245812)
s0 = s0 - rf(M, band(EAX) - 7245824)
s0 = s0 * rf(M, band(EAX + 4) - 7245824)
wi(M, EBP - 7245828, fistround(s0))
EDX = ru(M, EBP - 7245828)
do local r = band(bor(EDX, EDX), 4294967295)
FS = band(r, 2147483648) ~= 0
EDX = r
end
if not FS then pc = 3 else pc = 2 end
elseif pc == 2 then
s1 = 0
EDX = 0
pc = 6
elseif pc == 3 then
do local a, b = EDX, ru(M, band(EAX + 8) - 7245824)
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FZ = r == 0
FS = band(r, 2147483648) ~= 0
end
if (FZ or FS ~= FO) then pc = 5 else pc = 4 end
elseif pc == 4 then
s1 = ri(M, band(EAX + 8) - 7245824)
EDX = ru(M, band(EAX + 8) - 7245824)
pc = 6
elseif pc == 5 then
s1 = ri(M, EBP - 7245828)
pc = 6
elseif pc == 6 then
s0 = s0 - s1
s1 = rf(M, band(EAX + EDX*4 + 16) - 7245824)
s1 = s1 - rf(M, band(EAX + EDX*4 + 12) - 7245824)
s0 = s0 * s1
s0 = s0 + rf(M, band(EAX + EDX*4 + 12) - 7245824)
EDX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = EBP
EBP = ru(M, ESP - 7245824); ESP = ESP + 4
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
end
end
end
XF[0x410690] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ESI = ru(M, ESP - 7245812)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
EDI = ru(M, ESP - 7245812)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
EAX = ru(M, band(EDI + 248) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x5677d1]()
s0 = F[FT]; FT = FT - 1
ECX = ru(M, band(EDI + 252) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
wfd(ESP - 7245796, s0)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ESP = ESP - 4
XF[0x5677d1]()
s0 = F[FT]; FT = FT - 1
s0 = s0 * rf(M, 501476)
ESP = ESP + 16
s0 = s0 + rf(M, ESP - 7245808)
EDI = ru(M, ESP - 7245824); ESP = ESP + 4
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
end
end
end
XF[0x4106d0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ECX = ru(M, ESP - 7245820)
EAX = ru(M, ESP - 7245816)
wu(M, ESP - 7245816, EAX)
EDX = ru(M, band(ECX + 256) - 7245824)
wu(M, ESP - 7245820, EDX)
pc = 1
elseif pc == 1 then
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
EBP = ESP
ESP = ESP - 4
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EAX = ru(M, EBP - 7245816)
s0 = rf(M, EBP - 7245812)
s0 = s0 - rf(M, band(EAX) - 7245824)
s0 = s0 * rf(M, band(EAX + 4) - 7245824)
wi(M, EBP - 7245828, fistround(s0))
EDX = ru(M, EBP - 7245828)
do local r = band(bor(EDX, EDX), 4294967295)
FS = band(r, 2147483648) ~= 0
EDX = r
end
if not FS then pc = 3 else pc = 2 end
elseif pc == 2 then
s1 = 0
EDX = 0
pc = 6
elseif pc == 3 then
do local a, b = EDX, ru(M, band(EAX + 8) - 7245824)
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FZ = r == 0
FS = band(r, 2147483648) ~= 0
end
if (FZ or FS ~= FO) then pc = 5 else pc = 4 end
elseif pc == 4 then
s1 = ri(M, band(EAX + 8) - 7245824)
EDX = ru(M, band(EAX + 8) - 7245824)
pc = 6
elseif pc == 5 then
s1 = ri(M, EBP - 7245828)
pc = 6
elseif pc == 6 then
s0 = s0 - s1
s1 = rf(M, band(EAX + EDX*4 + 16) - 7245824)
s1 = s1 - rf(M, band(EAX + EDX*4 + 12) - 7245824)
s0 = s0 * s1
s0 = s0 + rf(M, band(EAX + EDX*4 + 12) - 7245824)
EDX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = EBP
EBP = ru(M, ESP - 7245824); ESP = ESP + 4
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
end
end
end
XF[0x4106f0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ESI = ru(M, ESP - 7245812)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
EDI = ru(M, ESP - 7245812)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
EAX = ru(M, band(EDI + 260) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x5677d1]()
s0 = F[FT]; FT = FT - 1
ECX = ru(M, band(EDI + 264) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
wfd(ESP - 7245796, s0)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ESP = ESP - 4
XF[0x5677d1]()
s0 = F[FT]; FT = FT - 1
s0 = s0 * rf(M, 501476)
ESP = ESP + 16
s0 = s0 + rf(M, ESP - 7245808)
EDI = ru(M, ESP - 7245824); ESP = ESP + 4
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
end
end
end
XF[0x410730] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ECX = ru(M, ESP - 7245820)
EAX = ru(M, ESP - 7245816)
wu(M, ESP - 7245816, EAX)
EDX = ru(M, band(ECX + 268) - 7245824)
wu(M, ESP - 7245820, EDX)
pc = 1
elseif pc == 1 then
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
EBP = ESP
ESP = ESP - 4
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EAX = ru(M, EBP - 7245816)
s0 = rf(M, EBP - 7245812)
s0 = s0 - rf(M, band(EAX) - 7245824)
s0 = s0 * rf(M, band(EAX + 4) - 7245824)
wi(M, EBP - 7245828, fistround(s0))
EDX = ru(M, EBP - 7245828)
do local r = band(bor(EDX, EDX), 4294967295)
FS = band(r, 2147483648) ~= 0
EDX = r
end
if not FS then pc = 3 else pc = 2 end
elseif pc == 2 then
s1 = 0
EDX = 0
pc = 6
elseif pc == 3 then
do local a, b = EDX, ru(M, band(EAX + 8) - 7245824)
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FZ = r == 0
FS = band(r, 2147483648) ~= 0
end
if (FZ or FS ~= FO) then pc = 5 else pc = 4 end
elseif pc == 4 then
s1 = ri(M, band(EAX + 8) - 7245824)
EDX = ru(M, band(EAX + 8) - 7245824)
pc = 6
elseif pc == 5 then
s1 = ri(M, EBP - 7245828)
pc = 6
elseif pc == 6 then
s0 = s0 - s1
s1 = rf(M, band(EAX + EDX*4 + 16) - 7245824)
s1 = s1 - rf(M, band(EAX + EDX*4 + 12) - 7245824)
s0 = s0 * s1
s0 = s0 + rf(M, band(EAX + EDX*4 + 12) - 7245824)
EDX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = EBP
EBP = ru(M, ESP - 7245824); ESP = ESP + 4
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
end
end
end
XF[0x410750] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
s0 = rf(M, ESP - 7245816)
FSW = fcmp(s0, rf(M, 14160))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 256), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 3 else pc = 1 end
elseif pc == 1 then
s0 = rf(M, ESP - 7245816)
FSW = fcmp(s0, rf(M, 14156))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 3 else pc = 2 end
elseif pc == 2 then
ECX = ru(M, ESP - 7245820)
EAX = ru(M, ESP - 7245816)
wu(M, ESP - 7245816, EAX)
EDX = ru(M, band(ECX + 276) - 7245824)
wu(M, ESP - 7245820, EDX)
pc = 4
elseif pc == 3 then
ECX = ru(M, ESP - 7245820)
EAX = ru(M, ESP - 7245816)
wu(M, ESP - 7245816, EAX)
EDX = ru(M, band(ECX + 272) - 7245824)
wu(M, ESP - 7245820, EDX)
pc = 4
elseif pc == 4 then
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
EBP = ESP
ESP = ESP - 4
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EAX = ru(M, EBP - 7245816)
s0 = rf(M, EBP - 7245812)
s0 = s0 - rf(M, band(EAX) - 7245824)
s0 = s0 * rf(M, band(EAX + 4) - 7245824)
wi(M, EBP - 7245828, fistround(s0))
EDX = ru(M, EBP - 7245828)
do local r = band(bor(EDX, EDX), 4294967295)
FS = band(r, 2147483648) ~= 0
EDX = r
end
if not FS then pc = 6 else pc = 5 end
elseif pc == 5 then
s1 = 0
EDX = 0
pc = 9
elseif pc == 6 then
do local a, b = EDX, ru(M, band(EAX + 8) - 7245824)
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FZ = r == 0
FS = band(r, 2147483648) ~= 0
end
if (FZ or FS ~= FO) then pc = 8 else pc = 7 end
elseif pc == 7 then
s1 = ri(M, band(EAX + 8) - 7245824)
EDX = ru(M, band(EAX + 8) - 7245824)
pc = 9
elseif pc == 8 then
s1 = ri(M, EBP - 7245828)
pc = 9
elseif pc == 9 then
s0 = s0 - s1
s1 = rf(M, band(EAX + EDX*4 + 16) - 7245824)
s1 = s1 - rf(M, band(EAX + EDX*4 + 12) - 7245824)
s0 = s0 * s1
s0 = s0 + rf(M, band(EAX + EDX*4 + 12) - 7245824)
EDX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = EBP
EBP = ru(M, ESP - 7245824); ESP = ESP + 4
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
end
end
end
XF[0x4107b0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
s0 = rf(M, ESP - 7245812)
FSW = fcmp(s0, rf(M, 14168))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if not FP then pc = 6 else pc = 1 end
elseif pc == 1 then
s0 = rf(M, ESP - 7245812)
FSW = fcmp(s0, rf(M, 14164))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if FZ then pc = 6 else pc = 2 end
elseif pc == 2 then
s0 = rf(M, ESP - 7245816)
FSW = fcmp(s0, rf(M, 14160))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 256), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 5 else pc = 3 end
elseif pc == 3 then
s0 = rf(M, ESP - 7245816)
FSW = fcmp(s0, rf(M, 14156))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 5 else pc = 4 end
elseif pc == 4 then
ECX = ru(M, ESP - 7245820)
EAX = ru(M, ESP - 7245816)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
EDX = ru(M, band(ECX + 288) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4
XF[0x5677d1]()
s0 = F[FT]; FT = FT - 1
ESP = ESP + 8
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
elseif pc == 5 then
ECX = ru(M, ESP - 7245820)
EAX = ru(M, ESP - 7245816)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
EDX = ru(M, band(ECX + 280) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4
XF[0x5677d1]()
s0 = F[FT]; FT = FT - 1
ESP = ESP + 8
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
elseif pc == 6 then
ECX = ru(M, ESP - 7245820)
EAX = ru(M, ESP - 7245816)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
EDX = ru(M, band(ECX + 284) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4
XF[0x5677d1]()
s0 = F[FT]; FT = FT - 1
ESP = ESP + 8
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
end
end
end
XF[0x410850] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
s0 = rf(M, ESP - 7245816)
FSW = fcmp(s0, rf(M, 14160))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 256), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 3 else pc = 1 end
elseif pc == 1 then
s0 = rf(M, ESP - 7245816)
FSW = fcmp(s0, rf(M, 14156))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 3 else pc = 2 end
elseif pc == 2 then
ECX = ru(M, ESP - 7245820)
EAX = ru(M, ESP - 7245816)
wu(M, ESP - 7245816, EAX)
EDX = ru(M, band(ECX + 296) - 7245824)
wu(M, ESP - 7245820, EDX)
pc = 4
elseif pc == 3 then
ECX = ru(M, ESP - 7245820)
EAX = ru(M, ESP - 7245816)
wu(M, ESP - 7245816, EAX)
EDX = ru(M, band(ECX + 292) - 7245824)
wu(M, ESP - 7245820, EDX)
pc = 4
elseif pc == 4 then
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
EBP = ESP
ESP = ESP - 4
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EAX = ru(M, EBP - 7245816)
s0 = rf(M, EBP - 7245812)
s0 = s0 - rf(M, band(EAX) - 7245824)
s0 = s0 * rf(M, band(EAX + 4) - 7245824)
wi(M, EBP - 7245828, fistround(s0))
EDX = ru(M, EBP - 7245828)
do local r = band(bor(EDX, EDX), 4294967295)
FS = band(r, 2147483648) ~= 0
EDX = r
end
if not FS then pc = 6 else pc = 5 end
elseif pc == 5 then
s1 = 0
EDX = 0
pc = 9
elseif pc == 6 then
do local a, b = EDX, ru(M, band(EAX + 8) - 7245824)
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FZ = r == 0
FS = band(r, 2147483648) ~= 0
end
if (FZ or FS ~= FO) then pc = 8 else pc = 7 end
elseif pc == 7 then
s1 = ri(M, band(EAX + 8) - 7245824)
EDX = ru(M, band(EAX + 8) - 7245824)
pc = 9
elseif pc == 8 then
s1 = ri(M, EBP - 7245828)
pc = 9
elseif pc == 9 then
s0 = s0 - s1
s1 = rf(M, band(EAX + EDX*4 + 16) - 7245824)
s1 = s1 - rf(M, band(EAX + EDX*4 + 12) - 7245824)
s0 = s0 * s1
s0 = s0 + rf(M, band(EAX + EDX*4 + 12) - 7245824)
EDX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = EBP
EBP = ru(M, ESP - 7245824); ESP = ESP + 4
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
end
end
end
XF[0x4108b0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ECX = ru(M, ESP - 7245820)
EAX = ru(M, ESP - 7245816)
wu(M, ESP - 7245816, EAX)
EDX = ru(M, band(ECX + 300) - 7245824)
wu(M, ESP - 7245820, EDX)
pc = 1
elseif pc == 1 then
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
EBP = ESP
ESP = ESP - 4
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EAX = ru(M, EBP - 7245816)
s0 = rf(M, EBP - 7245812)
s0 = s0 - rf(M, band(EAX) - 7245824)
s0 = s0 * rf(M, band(EAX + 4) - 7245824)
wi(M, EBP - 7245828, fistround(s0))
EDX = ru(M, EBP - 7245828)
do local r = band(bor(EDX, EDX), 4294967295)
FS = band(r, 2147483648) ~= 0
EDX = r
end
if not FS then pc = 3 else pc = 2 end
elseif pc == 2 then
s1 = 0
EDX = 0
pc = 6
elseif pc == 3 then
do local a, b = EDX, ru(M, band(EAX + 8) - 7245824)
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FZ = r == 0
FS = band(r, 2147483648) ~= 0
end
if (FZ or FS ~= FO) then pc = 5 else pc = 4 end
elseif pc == 4 then
s1 = ri(M, band(EAX + 8) - 7245824)
EDX = ru(M, band(EAX + 8) - 7245824)
pc = 6
elseif pc == 5 then
s1 = ri(M, EBP - 7245828)
pc = 6
elseif pc == 6 then
s0 = s0 - s1
s1 = rf(M, band(EAX + EDX*4 + 16) - 7245824)
s1 = s1 - rf(M, band(EAX + EDX*4 + 12) - 7245824)
s0 = s0 * s1
s0 = s0 + rf(M, band(EAX + EDX*4 + 12) - 7245824)
EDX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = EBP
EBP = ru(M, ESP - 7245824); ESP = ESP + 4
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
end
end
end
XF[0x4108d0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ECX = ru(M, ESP - 7245820)
EAX = ru(M, ESP - 7245816)
wu(M, ESP - 7245816, EAX)
EDX = ru(M, band(ECX + 304) - 7245824)
wu(M, ESP - 7245820, EDX)
pc = 1
elseif pc == 1 then
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
EBP = ESP
ESP = ESP - 4
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EAX = ru(M, EBP - 7245816)
s0 = rf(M, EBP - 7245812)
s0 = s0 - rf(M, band(EAX) - 7245824)
s0 = s0 * rf(M, band(EAX + 4) - 7245824)
wi(M, EBP - 7245828, fistround(s0))
EDX = ru(M, EBP - 7245828)
do local r = band(bor(EDX, EDX), 4294967295)
FS = band(r, 2147483648) ~= 0
EDX = r
end
if not FS then pc = 3 else pc = 2 end
elseif pc == 2 then
s1 = 0
EDX = 0
pc = 6
elseif pc == 3 then
do local a, b = EDX, ru(M, band(EAX + 8) - 7245824)
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FZ = r == 0
FS = band(r, 2147483648) ~= 0
end
if (FZ or FS ~= FO) then pc = 5 else pc = 4 end
elseif pc == 4 then
s1 = ri(M, band(EAX + 8) - 7245824)
EDX = ru(M, band(EAX + 8) - 7245824)
pc = 6
elseif pc == 5 then
s1 = ri(M, EBP - 7245828)
pc = 6
elseif pc == 6 then
s0 = s0 - s1
s1 = rf(M, band(EAX + EDX*4 + 16) - 7245824)
s1 = s1 - rf(M, band(EAX + EDX*4 + 12) - 7245824)
s0 = s0 * s1
s0 = s0 + rf(M, band(EAX + EDX*4 + 12) - 7245824)
EDX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = EBP
EBP = ru(M, ESP - 7245824); ESP = ESP + 4
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
end
end
end
XF[0x4108f0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ECX = ru(M, ESP - 7245820)
EAX = ru(M, ESP - 7245816)
wu(M, ESP - 7245816, EAX)
EDX = ru(M, band(ECX + 308) - 7245824)
wu(M, ESP - 7245820, EDX)
pc = 1
elseif pc == 1 then
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
EBP = ESP
ESP = ESP - 4
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EAX = ru(M, EBP - 7245816)
s0 = rf(M, EBP - 7245812)
s0 = s0 - rf(M, band(EAX) - 7245824)
s0 = s0 * rf(M, band(EAX + 4) - 7245824)
wi(M, EBP - 7245828, fistround(s0))
EDX = ru(M, EBP - 7245828)
do local r = band(bor(EDX, EDX), 4294967295)
FS = band(r, 2147483648) ~= 0
EDX = r
end
if not FS then pc = 3 else pc = 2 end
elseif pc == 2 then
s1 = 0
EDX = 0
pc = 6
elseif pc == 3 then
do local a, b = EDX, ru(M, band(EAX + 8) - 7245824)
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FZ = r == 0
FS = band(r, 2147483648) ~= 0
end
if (FZ or FS ~= FO) then pc = 5 else pc = 4 end
elseif pc == 4 then
s1 = ri(M, band(EAX + 8) - 7245824)
EDX = ru(M, band(EAX + 8) - 7245824)
pc = 6
elseif pc == 5 then
s1 = ri(M, EBP - 7245828)
pc = 6
elseif pc == 6 then
s0 = s0 - s1
s1 = rf(M, band(EAX + EDX*4 + 16) - 7245824)
s1 = s1 - rf(M, band(EAX + EDX*4 + 12) - 7245824)
s0 = s0 * s1
s0 = s0 + rf(M, band(EAX + EDX*4 + 12) - 7245824)
EDX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = EBP
EBP = ru(M, ESP - 7245824); ESP = ESP + 4
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
end
end
end
XF[0x410910] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 8
ESP = ESP - 4; wu(M, ESP - 7245824, EBX)
EBX = ru(M, ESP - 7245796)
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
EBP = ru(M, ESP - 7245788)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ESI = ru(M, ESP - 7245796)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
EDI = ru(M, ESP - 7245788)
wu(M, band(ESI) - 7245824, 0)
wu(M, band(EBX) - 7245824, 0)
wu(M, band(EDI) - 7245824, 0)
wu(M, EBP - 7245824, 0)
ESP = ESP - 4
XF[0x547ec0]()
s0 = F[FT]; FT = FT - 1
FSW = fcmp(s0, rf(M, 5196))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 2 else pc = 1 end
elseif pc == 1 then
s0 = rf(M, 5196)
pc = 2
elseif pc == 2 then
EAX = ru(M, ESP - 7245796)
EAX = ru(M, band(EAX + 1418) - 7245824)
ECX = ru(M, band(EAX + 312) - 7245824)
EDX = ru(M, band(EAX + 320) - 7245824)
wu(M, ESP - 7245780, ECX)
ECX = ru(M, band(EAX + 316) - 7245824)
EAX = ru(M, band(EAX + 324) - 7245824)
wu(M, ESP - 7245808, EAX)
EAX = band(EAX + 4)
wu(M, ESP - 7245784, EAX)
EAX = band(EDX + 4)
wu(M, ESP - 7245788, EAX)
EAX = ru(M, ESP - 7245780)
EAX = band(EAX + 4)
EDX = band(EDX - ECX)
wu(M, ESP - 7245792, EAX)
EAX = ru(M, ESP - 7245796)
EAX = band(EAX + 5283)
wu(M, ESP - 7245796, EAX)
EAX = ru(M, ESP - 7245780)
EAX = band(EAX - ECX)
wu(M, ESP - 7245780, 11)
wu(M, ESP - 7245804, EAX)
EAX = ru(M, ESP - 7245808)
EAX = band(EAX - ECX)
wu(M, ESP - 7245808, EAX)
pc = 3
elseif pc == 3 then
EAX = ru(M, ESP - 7245796)
s1 = rf(M, band(EAX) - 7245824)
FSW = fcmp(s1, rf(M, 5280))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 68), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 5 else pc = 4 end
elseif pc == 4 then
EAX = ru(M, ESP - 7245792)
s1 = rf(M, band(ESI) - 7245824)
s1 = s1 + rf(M, band(EAX) - 7245824)
EAX = ru(M, ESP - 7245788)
wfd(band(ESI) - 7245824, s1)
s1 = rf(M, band(ECX + 4) - 7245824)
s1 = s1 + rf(M, band(EDI) - 7245824)
wfd(band(EDI) - 7245824, s1)
s1 = rf(M, band(EAX) - 7245824)
s1 = s1 + rf(M, band(EBX) - 7245824)
EAX = ru(M, ESP - 7245784)
wfd(band(EBX) - 7245824, s1)
s1 = rf(M, band(EAX) - 7245824)
pc = 6
elseif pc == 5 then
EAX = ru(M, ESP - 7245804)
s2 = s1
s2 = s2 * rf(M, band(EAX + ECX) - 7245824)
EAX = ru(M, ESP - 7245808)
s2 = s2 + rf(M, band(ESI) - 7245824)
wfd(band(ESI) - 7245824, s2)
s2 = s1
s2 = s2 * rf(M, band(ECX) - 7245824)
s2 = s2 + rf(M, band(EDI) - 7245824)
wfd(band(EDI) - 7245824, s2)
s2 = s1
s2 = s2 * rf(M, band(EDX + ECX) - 7245824)
s2 = s2 + rf(M, band(EBX) - 7245824)
wfd(band(EBX) - 7245824, s2)
s1 = s1 * rf(M, band(EAX + ECX) - 7245824)
pc = 6
elseif pc == 6 then
EAX = ru(M, ESP - 7245796)
ECX = band(ECX + 8)
EAX = band(EAX + 4)
wu(M, ESP - 7245796, EAX)
EAX = ru(M, ESP - 7245792)
EAX = band(EAX + 8)
wu(M, ESP - 7245792, EAX)
EAX = ru(M, ESP - 7245788)
s1 = s1 + rf(M, EBP - 7245824)
EAX = band(EAX + 8)
wu(M, ESP - 7245788, EAX)
EAX = ru(M, ESP - 7245784)
EAX = band(EAX + 8)
wfd(EBP - 7245824, s1)
wu(M, ESP - 7245784, EAX)
EAX = ru(M, ESP - 7245780)
do local a = EAX; local r = band(a - 1, 4294967295)
FZ = r == 0
EAX = r
end
wu(M, ESP - 7245780, EAX)
if not FZ then pc = 3 else pc = 7 end
elseif pc == 7 then
s1 = s0
s1 = s1 * rf(M, band(ESI) - 7245824)
wfd(band(ESI) - 7245824, s1)
s1 = s0
s1 = s1 * rf(M, band(EDI) - 7245824)
wfd(band(EDI) - 7245824, s1)
EDI = ru(M, ESP - 7245824); ESP = ESP + 4
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
s1 = s0
s1 = s1 * rf(M, band(EBX) - 7245824)
wfd(band(EBX) - 7245824, s1)
s0 = s0 * rf(M, EBP - 7245824)
wfd(EBP - 7245824, s0)
EBP = ru(M, ESP - 7245824); ESP = ESP + 4
EBX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 8
ESP = ESP + 4
do return end
end
end
end
XF[0x410b50] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
do local r = band(band(r8b(M, band(EAX + 156) - 7245824), 2), 255)
FZ = r == 0
end
if FZ then pc = 3 else pc = 1 end
elseif pc == 1 then
ECX = ru(M, 223492)
do local r = band(band(ECX, ECX), 4294967295)
FZ = r == 0
end
if FZ then pc = 3 else pc = 2 end
elseif pc == 2 then
ECX = ru(M, ESP - 7245804)
EDX = ru(M, ESP - 7245808)
wu(M, ESP - 7245804, ECX)
ECX = ru(M, ESP - 7245812)
wu(M, ESP - 7245808, EDX)
EDX = ru(M, ESP - 7245816)
wu(M, ESP - 7245812, ECX)
wu(M, ESP - 7245816, EDX)
wu(M, ESP - 7245820, EAX)
pc = 4
elseif pc == 3 then
ESP = ESP + 4
do return end
elseif pc == 4 then
ECX = ru(M, ESP - 7245820)
EAX = ru(M, ESP - 7245812)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
EDX = ru(M, band(ECX + 248) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4
XF[0x5677d1]()
s0 = F[FT]; FT = FT - 1
s0 = s0 - rf(M, 5268)
ESP = ESP + 8
s0 = s0 * rf(M, ESP - 7245808)
s0 = s0 * rf(M, 5284)
s0 = s0 - rf(M, 5676)
s0 = s0 * rf(M, ESP - 7245804)
s0 = s0 * rf(M, 14172)
s0 = s0 + rf(M, 501472)
wfd(501472, s0)
s0 = rf(M, 501476)
s0 = s0 + rf(M, 501472)
wfd(501476, s0)
FSW = fcmp(s0, rf(M, 2008))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 6 else pc = 5 end
elseif pc == 5 then
wu(M, 501476, 1065353216)
wu(M, 501472, 0)
ESP = ESP + 4
do return end
elseif pc == 6 then
s0 = rf(M, 501476)
FSW = fcmp(s0, rf(M, 5204))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 8 else pc = 7 end
elseif pc == 7 then
wu(M, 501476, 0)
wu(M, 501472, 0)
pc = 8
elseif pc == 8 then
ESP = ESP + 4
do return end
end
end
end
XF[0x425e80] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ECX = ru(M, ESP - 7245812)
ESP = ESP - 4; wu(M, ESP - 7245824, EBX)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ESI = ru(M, ESP - 7245808)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
EDI = ru(M, ESP - 7245796)
do local a, b = EDI, 4
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FS = band(r, 2147483648) ~= 0
end
if (FS ~= FO) then pc = 4 else pc = 1 end
elseif pc == 1 then
EDX = EDI
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
do local n = band(2, 31)
if n ~= 0 then local a = EDX
FC = band(rshift(a, n - 1), 1) ~= 0
local r = band(rshift(a, n), 4294967295)
FR = r; FZ = r == 0; FS = band(r, 2147483648) ~= 0; FP = PAR[band(r, 0xff)]; FO = false
EDX = r
end end
EAX = EDX
do local a = EAX; local r = band(-a, 4294967295)
EAX = r
end
EDI = band(EDI + EAX*4)
EAX = ru(M, ESP - 7245804)
pc = 2
elseif pc == 2 then
EBX = ru(M, band(ESI) - 7245824)
EBP = ru(M, band(ECX) - 7245824)
EBX = band(bxor(EBX, EBP), 4294967295)
ESI = band(ESI + 4)
wu(M, band(EAX) - 7245824, EBX)
EAX = band(EAX + 4)
ECX = band(ECX + 4)
do local a = EDX; local r = band(a - 1, 4294967295)
FZ = r == 0
EDX = r
end
if not FZ then pc = 2 else pc = 3 end
elseif pc == 3 then
EBP = ru(M, ESP - 7245824); ESP = ESP + 4
pc = 5
elseif pc == 4 then
EAX = ru(M, ESP - 7245808)
pc = 5
elseif pc == 5 then
do local r = band(band(EDI, EDI), 4294967295)
FZ = r == 0
end
if FZ then pc = 7 else pc = 6 end
elseif pc == 6 then
EDX = bor(band(EDX, 0xffffff00), band(r8b(M, band(ESI) - 7245824), 0xff))
EBX = bor(band(EBX, 0xffffff00), band(r8b(M, band(ECX) - 7245824), 0xff))
EDX = bor(band(EDX, 0xffffff00), band(band(bxor(band(EDX, 0xff), band(EBX, 0xff)), 255), 0xff))
w8b(M, band(EAX) - 7245824, band(band(EDX, 0xff), 0xff))
do local a = EAX; local r = band(a + 1, 4294967295)
EAX = r
end
do local a = ECX; local r = band(a + 1, 4294967295)
ECX = r
end
do local a = ESI; local r = band(a + 1, 4294967295)
ESI = r
end
do local a = EDI; local r = band(a - 1, 4294967295)
FZ = r == 0
EDI = r
end
if not FZ then pc = 6 else pc = 7 end
elseif pc == 7 then
EDI = ru(M, ESP - 7245824); ESP = ESP + 4
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
EBX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 20
do return end
end
end
end
XF[0x4f5970] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
ECX = EAX
do local n = band(4, 31)
if n ~= 0 then local a = ECX
FC = band(rshift(a, 32 - n), 1) ~= 0
local r = band(lshift(a, n), 4294967295)
FR = r; FZ = r == 0; FS = band(r, 2147483648) ~= 0; FP = PAR[band(r, 0xff)]; FO = false
ECX = r
end end
ECX = band(ECX + EAX)
do local n = band(5, 31)
if n ~= 0 then local a = ECX
FC = band(rshift(a, 32 - n), 1) ~= 0
local r = band(lshift(a, n), 4294967295)
FR = r; FZ = r == 0; FS = band(r, 2147483648) ~= 0; FP = PAR[band(r, 0xff)]; FO = false
ECX = r
end end
ECX = band(ECX + EAX)
EDX = band(EAX + ECX*4)
EAX = band(EDX*4 + 11323952)
ESP = ESP + 4
do return end
end
end
end
XF[0x51a000] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 4
XF[0x55ab00]()
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x562f70]()
ESP = ESP + 4
EAX = band(EAX + 12)
ESP = ESP + 4
do return end
end
end
end
XF[0x51a870] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
s0 = rf(M, ESP - 7245812)
FSW = fcmp(s0, rf(M, 5204))
EAX = ru(M, ESP - 7245812)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ESI = ECX
wu(M, band(ESI + 1156) - 7245824, EAX)
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 2 else pc = 1 end
elseif pc == 1 then
wu(M, band(ESI + 1156) - 7245824, 0)
pc = 2
elseif pc == 2 then
s0 = rf(M, band(ESI + 1360) - 7245824)
FSW = fcmp(s0, rf(M, 5204))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 4 else pc = 3 end
elseif pc == 3 then
s0 = rf(M, 5204)
pc = 5
elseif pc == 4 then
s0 = rf(M, ESP - 7245812)
pc = 5
elseif pc == 5 then
ECX = ru(M, band(ESI + 1156) - 7245824)
EDX = band(ESI + 16)
wfd(band(ESI + 1160) - 7245824, s0)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4
XF[0x5677d1]()
s0 = F[FT]; FT = FT - 1
s0 = s0 * rf(M, band(ESI + 1364) - 7245824)
ESP = ESP + 8
wfd(ESP - 7245812, s0)
wfd(band(ESI + 1164) - 7245824, s0)
s0 = rf(M, ESP - 7245808)
FSW = fcmp(s0, rf(M, 32376))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 7 else pc = 6 end
elseif pc == 6 then
s0 = rf(M, 32376)
pc = 8
elseif pc == 7 then
s0 = rf(M, ESP - 7245808)
pc = 8
elseif pc == 8 then
s0 = rf(M, 32376) / s0
s0 = s0 * rf(M, band(ESI + 1364) - 7245824)
s0 = s0 * rf(M, 46904)
s1 = rf(M, ESP - 7245812)
s1 = s1 - s0
wfd(band(ESI + 1164) - 7245824, s1)
FSW = fcmp(s1, rf(M, 5204))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 10 else pc = 9 end
elseif pc == 9 then
wu(M, band(ESI + 1164) - 7245824, 0)
pc = 10
elseif pc == 10 then
s1 = rf(M, band(ESI + 1164) - 7245824)
s1 = s1 * rf(M, band(ESI + 1160) - 7245824)
EAX = ru(M, band(ESI + 1156) - 7245824)
ECX = band(ESI + 548)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
s1 = s1 + s0
wfd(band(ESI + 1164) - 7245824, s1)
ESP = ESP - 4
XF[0x5677d1]()
s0 = F[FT]; FT = FT - 1
wfd(band(ESI + 1168) - 7245824, s0)
s1 = rf(M, band(ESI + 1376) - 7245824)
FSW = fcmp(s1, rf(M, 5204))
ESP = ESP + 8
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 12 else pc = 11 end
elseif pc == 11 then
s0 = s0 + rf(M, band(ESI + 1376) - 7245824)
wfd(band(ESI + 1168) - 7245824, s0)
pc = 13
elseif pc == 12 then
pc = 13
elseif pc == 13 then
s0 = rf(M, ESP - 7245808)
FSW = fcmp(s0, rf(M, 5204))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 15 else pc = 14 end
elseif pc == 14 then
s0 = rf(M, band(ESI + 1168) - 7245824)
s0 = -s0
wfd(band(ESI + 1168) - 7245824, s0)
pc = 15
elseif pc == 15 then
s0 = rf(M, band(ESI + 1164) - 7245824)
s0 = s0 - rf(M, band(ESI + 1168) - 7245824)
EDX = ru(M, ESP - 7245816)
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
wfd(band(EDX) - 7245824, s0)
ESP = ESP + 16
do return end
end
end
end
XF[0x51bde0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EDX = ru(M, ESP - 7245820)
EAX = ru(M, band(ECX + 1172) - 7245824)
wu(M, band(EDX) - 7245824, EAX)
EAX = ru(M, band(ECX + 1176) - 7245824)
ECX = ru(M, ESP - 7245816)
wu(M, band(ECX) - 7245824, EAX)
ESP = ESP + 12
do return end
end
end
end
XF[0x51c1e0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
EAX = ru(M, ESP - 7245816)
wu(M, ESP - 7245816, EAX)
EAX = ru(M, ESP - 7245816)
EAX = band(band(EAX, 2147483647), 4294967295)
wu(M, ESP - 7245824, EAX)
s0 = rf(M, ESP - 7245824)
FSW = fcmp(s0, rf(M, band(ECX + 4) - 7245824))
wfd(band(ECX) - 7245824, s0)
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 2 else pc = 1 end
elseif pc == 1 then
wfd(band(ECX + 4) - 7245824, s0)
ECX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 8
do return end
elseif pc == 2 then
ECX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 8
do return end
end
end
end
XF[0x51c2d0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = 12384096
ESP = ESP + 4
do return end
end
end
end
XF[0x544bf0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = 12500280
ESP = ESP + 4
do return end
end
end
end
XF[0x547ec0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
s0 = rf(M, 5269248)
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
end
end
end
XF[0x5486a0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ECX = ru(M, ESP - 7245816)
ESP = ESP - 8
EAX = band(ECX*8)
ESP = ESP - 4; wu(M, ESP - 7245824, EBX)
EAX = band(EAX - ECX)
EBX = 0
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ECX = bor(band(ECX, 0xffffff00), band(r8b(M, band(EAX + EAX*2 + 7296704) - 7245824), 0xff))
do local a, b = band(ECX, 0xff), band(EBX, 0xff)
local r = a - b
r = band(r, 255)
FZ = r == 0
end
ECX = ru(M, ESP - 7245804)
if FZ then pc = 4 else pc = 1 end
elseif pc == 1 then
EDX = ru(M, band(ECX + 8) - 7245824)
ECX = ru(M, band(EAX + EAX*2 + 7296696) - 7245824)
ESI = ru(M, band(EAX + EAX*2 + 7296700) - 7245824)
do local n = band(band(ECX, 0xff), 31)
if n ~= 0 then local a = EDX
FC = band(rshift(a, n - 1), 1) ~= 0
local r = band(rshift(a, n), 4294967295)
FR = r; FZ = r == 0; FS = band(r, 2147483648) ~= 0; FP = PAR[band(r, 0xff)]; FO = false
EDX = r
end end
EDX = band(band(EDX, ESI), 4294967295)
do local a, b = EDX, ESI
local r = a - b
r = band(r)
FZ = r == 0
end
if not FZ then pc = 3 else pc = 2 end
elseif pc == 2 then
s0 = rf(M, 5280)
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
EBX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 8
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
elseif pc == 3 then
wu(M, ESP - 7245816, EDX)
wu(M, ESP - 7245812, EBX)
s0 = ri64(band(ESP + 8))
do local a = ESI; local r = band(a - 1, 4294967295)
ESI = r
end
wu(M, ESP - 7245812, EBX)
wu(M, ESP - 7245816, ESI)
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
s0 = s0 / ri(M, ESP - 7245820)
EBX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 8
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
elseif pc == 4 then
ESI = ru(M, band(ECX + 8) - 7245824)
ECX = ru(M, band(EAX + EAX*2 + 7296696) - 7245824)
EDX = ru(M, band(EAX + EAX*2 + 7296700) - 7245824)
wu(M, ESP - 7245812, EBX)
do local n = band(band(ECX, 0xff), 31)
if n ~= 0 then local a = ESI
FC = band(rshift(a, n - 1), 1) ~= 0
local r = band(rshift(a, n), 4294967295)
FR = r; FZ = r == 0; FS = band(r, 2147483648) ~= 0; FP = PAR[band(r, 0xff)]; FO = false
ESI = r
end end
ESI = band(band(ESI, EDX), 4294967295)
wu(M, ESP - 7245816, ESI)
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
s0 = ri64(band(ESP + 4))
wu(M, ESP - 7245820, EDX)
wu(M, ESP - 7245816, EBX)
EBX = ru(M, ESP - 7245824); ESP = ESP + 4
s0 = s0 / ri(M, ESP - 7245824)
ESP = ESP + 8
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
end
end
end
XF[0x54cab0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 36
s0 = rf(M, ESP - 7245756)
s0 = s0 - rf(M, ESP - 7245768)
ESP = ESP - 4; wu(M, ESP - 7245824, EBX)
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
EAX = ru(M, ESP - 7245756)
ESI = ECX
ECX = ru(M, ESP - 7245744)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
wu(M, ESP - 7245740, ECX)
wfd(band(ESI + 748) - 7245824, s0)
s0 = rf(M, ESP - 7245748)
s0 = -s0
wfd(band(ESI + 744) - 7245824, s0)
wu(M, band(ESI + 752) - 7245824, EAX)
EAX = ru(M, ESP - 7245740)
EAX = band(band(EAX, 2147483647), 4294967295)
wu(M, ESP - 7245784, EAX)
s0 = rf(M, ESP - 7245784)
EDX = ru(M, ESP - 7245728)
EAX = ru(M, band(ESI + 108) - 7245824)
wfd(band(ESI + 716) - 7245824, s0)
wu(M, band(ESI + 700) - 7245824, EDX)
wu(M, 5370448, EAX)
ECX = ru(M, band(ESI + 700) - 7245824)
wu(M, ESP - 7245740, ECX)
EAX = ru(M, ESP - 7245740)
EAX = band(band(EAX, 2147483647), 4294967295)
wu(M, ESP - 7245784, EAX)
s0 = rf(M, ESP - 7245784)
FSW = fcmp(s0, rf(M, 51460))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 4 else pc = 1 end
elseif pc == 1 then
do local a, b = ru(M, band(ESI + 704) - 7245824), 17
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FS = band(r, 2147483648) ~= 0
end
if (FS == FO) then pc = 4 else pc = 2 end
elseif pc == 2 then
wu(M, 5300008, 18)
EDX = ru(M, band(ESI + 108) - 7245824)
EDX = band(band(EDX, 1), 4294967295)
wu(M, 5300016, 3212836864)
EAX = band(EDX + EDX + -1)
do local r = band(band(EAX, EAX), 4294967295)
FZ = r == 0
FS = band(r, 2147483648) ~= 0
FO = false
end
if (not FZ and FS == FO) then pc = 4 else pc = 3 end
elseif pc == 3 then
wu(M, 5300016, 1065353216)
pc = 4
elseif pc == 4 then
s0 = rf(M, ESP - 7245736)
FSW = fcmp(s0, rf(M, 5204))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 21 else pc = 5 end
elseif pc == 5 then
ECX = ru(M, band(ESI + 748) - 7245824)
wu(M, ESP - 7245740, ECX)
EAX = ru(M, ESP - 7245740)
EAX = band(band(EAX, 2147483647), 4294967295)
wu(M, ESP - 7245788, EAX)
EDX = ru(M, band(ESI + 744) - 7245824)
wu(M, ESP - 7245740, EDX)
EAX = ru(M, ESP - 7245740)
EAX = band(band(EAX, 2147483647), 4294967295)
wu(M, ESP - 7245784, EAX)
s0 = rf(M, ESP - 7245784)
s0 = s0 + rf(M, ESP - 7245788)
EDI = band(ESI + 232)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
s0 = s0 + rf(M, band(ESI + 716) - 7245824)
wfd(ESP - 7245772, s0)
ESP = ESP - 4
B_nop()
EAX = ru(M, band(ESI + 228) - 7245824)
ECX = ru(M, band(ESI + 220) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
ECX = ru(M, band(ECX) - 7245824)
EBX = ru(M, band(EAX) - 7245824)
ECX = band(bxor(ECX, EBX), 4294967295)
wu(M, ESP - 7245732, ECX)
ESP = ESP - 4
B_nop()
s0 = rf(M, 5371424)
s0 = s0 * rf(M, band(ESI + 716) - 7245824)
EDI = band(ESI + 232)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
s0 = rf(M, band(ESI + 744) - 7245824) - s0
s0 = s0 * rf(M, ESP - 7245728)
s0 = s0 + rf(M, 5371424)
wfd(ESP - 7245784, s0)
ESP = ESP - 4
B_nop()
EAX = ru(M, band(ESI + 228) - 7245824)
ECX = ru(M, band(ESI + 220) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
EDX = ru(M, band(ECX) - 7245824)
EBX = ru(M, band(EAX) - 7245824)
EDX = band(bxor(EDX, EBX), 4294967295)
wu(M, ESP - 7245724, EDX)
ESP = ESP - 4
B_nop()
s0 = rf(M, 5370508)
s0 = s0 * rf(M, band(ESI + 716) - 7245824)
EAX = bor(band(EAX, 0xffffff00), band(r8b(M, 7975932), 0xff))
ESP = ESP + 16
do local r = band(band(band(EAX, 0xff), band(EAX, 0xff)), 255)
FZ = r == 0
end
s0 = rf(M, band(ESI + 748) - 7245824) - s0
s0 = s0 * rf(M, ESP - 7245740)
s0 = s0 + rf(M, 5370508)
wfd(ESP - 7245808, s0)
if FZ then pc = 7 else pc = 6 end
elseif pc == 6 then
EAX = ru(M, ESP - 7245796)
ECX = ru(M, ESP - 7245808)
wu(M, 5371424, EAX)
wu(M, 5370508, ECX)
pc = 7
elseif pc == 7 then
s0 = rf(M, 5370948)
s0 = s0 * rf(M, band(ESI + 680) - 7245824)
EBX = ru(M, ESP - 7245756)
EDX = ru(M, ESP - 7245728)
wu(M, ESP - 7245728, EDX)
s0 = s0 * rf(M, 5370948)
s0 = s0 * rf(M, ESP - 7245736)
s1 = s0
wfd(band(EBX) - 7245824, s1)
wfd(ESP - 7245740, s0)
s0 = s0 * rf(M, 51424)
wfd(ESP - 7245736, s0)
EAX = ru(M, ESP - 7245728)
EAX = band(band(EAX, 2147483647), 4294967295)
wu(M, ESP - 7245784, EAX)
s0 = rf(M, ESP - 7245740)
s0 = s0 * rf(M, band(ESI + 668) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
EAX = band(ESI + 2284)
wfd(ESP - 7245824, s0)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x5677d1]()
s0 = F[FT]; FT = FT - 1
ECX = ru(M, band(ESI + 716) - 7245824)
EDX = band(ESI + 2028)
wfd(ESP - 7245720, s0)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4
XF[0x5677d1]()
s0 = F[FT]; FT = FT - 1
s0 = s0 * rf(M, ESP - 7245712)
s1 = rf(M, ESP - 7245768)
s1 = s1 * rf(M, 21392)
EAX = ru(M, band(ESI + 112) - 7245824)
ECX = ru(M, band(ESI + 24) - 7245824)
EDX = ru(M, band(ESI + 28) - 7245824)
s1 = rf(M, 2008) - s1
s0 = s0 * s1
s0 = s0 * rf(M, ESP - 7245724)
wfd(ESP - 7245712, s0)
s0 = rf(M, ESP - 7245720)
s0 = s0 * rf(M, ESP - 7245720)
s0 = s0 + rf(M, 2008)
s0 = rf(M, 2008) / s0
s0 = s0 + rf(M, 2008)
s0 = s0 * rf(M, ESP - 7245712)
wfd(ESP - 7245768, s0)
s0 = rf(M, band(EAX + 32) - 7245824)
EAX = ru(M, ESP - 7245724)
wu(M, band(ESI + 212) - 7245824, ECX)
s0 = s0 * rf(M, ESP - 7245712)
ECX = band(ESI + 2412)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
wu(M, band(ESI + 216) - 7245824, EDX)
s0 = -s0
wfd(ESP - 7245768, s0)
ESP = ESP - 4
XF[0x5677d1]()
s0 = F[FT]; FT = FT - 1
s1 = rf(M, band(ESI + 208) - 7245824)
s1 = s1 * rf(M, band(ESI + 212) - 7245824)
EAX = ru(M, band(ESI + 108) - 7245824)
ESP = ESP + 20
s1 = s1 * s0
wfd(band(ESI + 212) - 7245824, s1)
s1 = rf(M, band(ESI + 208) - 7245824)
s1 = s1 * s0
s1 = s1 * rf(M, band(ESI + 216) - 7245824)
wfd(band(ESI + 216) - 7245824, s1)
EDX = ru(M, band(EAX*4 + 7659648) - 7245824)
s0 = rf(M, 51456)
s0 = s0 - rf(M, ESP - 7245736)
s0 = rf(M, 51452) / s0
s0 = s0 * rf(M, band(ESI + 700) - 7245824)
wfd(ESP - 7245824, s0)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4
XF[0x5677d1]()
s0 = F[FT]; FT = FT - 1
s1 = s0
s1 = s1 * rf(M, band(ESI + 212) - 7245824)
ESP = ESP + 8
wu(M, ESP - 7245804, 0)
wfd(band(ESI + 212) - 7245824, s1)
s0 = s0 * rf(M, band(ESI + 216) - 7245824)
wfd(band(ESI + 216) - 7245824, s0)
s0 = rf(M, ESP - 7245732)
FSW = fcmp(s0, rf(M, 5204))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 9 else pc = 8 end
elseif pc == 8 then
EDI = ru(M, band(ESI + 704) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
ESP = ESP - 4; wu(M, ESP - 7245824, 17)
ESP = ESP - 4
XF[0x579ea0]()
s0 = F[FT]; FT = FT - 1
wfd(ESP - 7245728, s0)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
ESP = ESP - 4; wu(M, ESP - 7245824, 17)
ESP = ESP - 4
XF[0x579e80]()
s0 = F[FT]; FT = FT - 1
s0 = s0 * rf(M, 5370948)
ESP = ESP + 16
s0 = s0 * rf(M, ESP - 7245732)
s1 = rf(M, ESP - 7245736)
s1 = s1 * rf(M, ESP - 7245744)
s0 = s0 + s1
s0 = s0 * rf(M, 5370948)
wfd(ESP - 7245804, s0)
s0 = s0 + rf(M, band(EBX) - 7245824)
wfd(band(EBX) - 7245824, s0)
s0 = rf(M, band(ESI + 212) - 7245824)
s0 = s0 * rf(M, 21700)
wfd(band(ESI + 212) - 7245824, s0)
s0 = rf(M, band(ESI + 216) - 7245824)
s0 = s0 * rf(M, 21700)
wfd(band(ESI + 216) - 7245824, s0)
pc = 9
elseif pc == 9 then
s0 = rf(M, ESP - 7245740)
s0 = s0 * rf(M, band(ESI + 216) - 7245824)
EAX = 3196059645
ECX = ru(M, band(ESI + 700) - 7245824)
wfd(ESP - 7245800, s0)
s0 = rf(M, ESP - 7245740)
s0 = s0 * rf(M, band(ESI + 212) - 7245824)
wfd(ESP - 7245788, s0)
s0 = rf(M, 2008)
s0 = s0 / rf(M, ESP - 7245800)
s1 = rf(M, ESP - 7245728)
s1 = s1 * s0
s1 = s1 * rf(M, ESP - 7245796)
wfd(ESP - 7245744, s1)
s1 = rf(M, ESP - 7245792)
s1 = s1 * rf(M, band(ESI + 700) - 7245824)
s1 = s1 * s0
wfd(ESP - 7245792, s1)
s0 = rf(M, ESP - 7245808)
s0 = s0 / rf(M, ESP - 7245788)
s0 = s0 * rf(M, ESP - 7245784)
wfd(ESP - 7245736, s0)
s0 = s0 * rf(M, ESP - 7245736)
s1 = rf(M, ESP - 7245744)
s1 = s1 * rf(M, ESP - 7245744)
s0 = s0 + s1
wfd(ESP - 7245732, s0)
EDX = ru(M, ESP - 7245732)
s1 = rf(M, 5196)
EAX = band(EAX - EDX)
do local n = band(1, 31)
if n ~= 0 then local a = EAX
FC = band(rshift(a, n - 1), 1) ~= 0
local r = band(rshift(a, n), 4294967295)
FR = r; FZ = r == 0; FS = band(r, 2147483648) ~= 0; FP = PAR[band(r, 0xff)]; FO = false
EAX = r
end end
s1 = s1 * s0
wu(M, ESP - 7245732, EAX)
s2 = rf(M, ESP - 7245732)
s2 = s2 * rf(M, ESP - 7245732)
s2 = s2 * s1
s2 = rf(M, 5268) - s2
s2 = s2 * rf(M, ESP - 7245732)
wu(M, ESP - 7245732, ECX)
s3 = s2
s3 = s3 * s2
s3 = s3 * s1
s3 = rf(M, 5268) - s3
s3 = s3 * s2
s3 = s3 * s0
wfd(ESP - 7245808, s3)
EAX = ru(M, ESP - 7245732)
EAX = band(band(EAX, 2147483647), 4294967295)
wu(M, ESP - 7245780, EAX)
s0 = rf(M, ESP - 7245780)
FSW = fcmp(s0, rf(M, 16416))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 11 else pc = 10 end
elseif pc == 10 then
s0 = rf(M, ESP - 7245736)
s0 = s0 + rf(M, band(ESI + 684) - 7245824)
do local a = ru(M, band(ESI + 696) - 7245824); local r = band(a + 1, 4294967295)
wu(M, band(ESI + 696) - 7245824, r)
end
wfd(band(ESI + 684) - 7245824, s0)
s0 = rf(M, ESP - 7245744)
s0 = s0 + rf(M, band(ESI + 688) - 7245824)
wfd(band(ESI + 688) - 7245824, s0)
s0 = rf(M, ESP - 7245808)
s0 = s0 + rf(M, band(ESI + 692) - 7245824)
wfd(band(ESI + 692) - 7245824, s0)
pc = 11
elseif pc == 11 then
EDX = ru(M, ESP - 7245792)
EDI = band(ESI + 756)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
ESP = ESP - 4
XF[0x5677d1]()
s0 = F[FT]; FT = FT - 1
s1 = s0
s1 = s1 * s0
EAX = ru(M, ESP - 7245800)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
s1 = s1 * rf(M, ESP - 7245776)
s1 = s1 + rf(M, 2008)
s1 = s1 - s0
wfd(ESP - 7245764, s1)
ESP = ESP - 4
XF[0x5677d1]()
s0 = F[FT]; FT = FT - 1
wfd(ESP - 7245716, s0)
EDI = band(ESI + 276)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
ESP = ESP - 4
B_nop()
EAX = ru(M, band(ESI + 272) - 7245824)
ECX = ru(M, band(ESI + 264) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
ECX = ru(M, band(ECX) - 7245824)
EDX = ru(M, band(EAX) - 7245824)
ECX = band(bxor(ECX, EDX), 4294967295)
wu(M, ESP - 7245712, ECX)
ESP = ESP - 4
B_nop()
s0 = rf(M, 2008)
s0 = s0 - rf(M, ESP - 7245708)
EDX = 3196059645
wfd(band(ESI + 740) - 7245824, s0)
s1 = rf(M, ESP - 7245712)
s1 = s1 * rf(M, ESP - 7245708)
s1 = s1 + s0
s1 = s1 / rf(M, band(ESI + 216) - 7245824)
s1 = s1 * rf(M, band(ESI + 212) - 7245824)
s1 = s1 * rf(M, band(ESI + 744) - 7245824)
wfd(ESP - 7245712, s1)
s0 = rf(M, band(ESI + 748) - 7245824)
s1 = rf(M, ESP - 7245712)
s1 = s1 * rf(M, ESP - 7245712)
s2 = s0
s2 = s2 * s0
s1 = s1 + s2
s0 = s1
wfd(ESP - 7245720, s0)
EBX = ru(M, ESP - 7245720)
s1 = rf(M, 5196)
EDX = band(EDX - EBX)
do local n = band(1, 31)
if n ~= 0 then local a = EDX
FC = band(rshift(a, n - 1), 1) ~= 0
local r = band(rshift(a, n), 4294967295)
FR = r; FZ = r == 0; FS = band(r, 2147483648) ~= 0; FP = PAR[band(r, 0xff)]; FO = false
EDX = r
end end
wu(M, ESP - 7245720, EDX)
ESP = ESP + 20
s1 = s1 * s0
s2 = rf(M, ESP - 7245740)
s2 = s2 * rf(M, ESP - 7245740)
s2 = s2 * s1
s2 = rf(M, 5268) - s2
s2 = s2 * rf(M, ESP - 7245740)
s3 = s2
s3 = s3 * s2
s3 = s3 * s1
s3 = rf(M, 5268) - s3
s3 = s3 * s2
wfd(ESP - 7245740, s3)
s1 = rf(M, ESP - 7245728)
s1 = s1 * rf(M, ESP - 7245728)
s1 = s1 * rf(M, ESP - 7245804)
wfd(ESP - 7245804, s1)
s1 = rf(M, ESP - 7245740)
s1 = s1 * s0
wfd(ESP - 7245824, s1)
EAX = band(ESI + 2156)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x5677d1]()
s0 = F[FT]; FT = FT - 1
s0 = s0 * rf(M, band(ESI + 740) - 7245824)
EDI = ru(M, ESP - 7245752)
EBX = ru(M, ESP - 7245756)
EBP = ru(M, ESP - 7245760)
ESP = ESP + 8
wfd(ESP - 7245792, s0)
s0 = s0 + rf(M, ESP - 7245808)
s0 = s0 * rf(M, ESP - 7245744)
s1 = s0
s1 = s1 * rf(M, band(ESI + 748) - 7245824)
s2 = rf(M, ESP - 7245736)
s2 = s2 * s0
s3 = rf(M, ESP - 7245780)
s3 = s3 * rf(M, ESP - 7245732)
s2 = s2 + s3
s2 = s2 * rf(M, ESP - 7245800)
wfd(band(EDI) - 7245824, s2)
s1 = s1 * rf(M, ESP - 7245788)
wfd(band(EBX) - 7245824, s1)
wu(M, EBP - 7245824, 0)
EDX = ru(M, band(ESI + 112) - 7245824)
s0 = rf(M, ESP - 7245740)
s0 = s0 * rf(M, band(ESI + 708) - 7245824)
ECX = ru(M, band(ESI + 108) - 7245824)
wfd(band(ESI + 712) - 7245824, s0)
s1 = rf(M, band(EDX) - 7245824)
EAX = ru(M, band(ECX*4 + 12616180) - 7245824)
s1 = s1 * s0
s1 = s1 + rf(M, band(EAX) - 7245824)
wfd(band(EAX) - 7245824, s1)
s0 = rf(M, ESP - 7245804)
FSW = fcmp(s0, rf(M, 51448))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 13 else pc = 12 end
elseif pc == 12 then
EAX = ru(M, ESP - 7245748)
ECX = ru(M, ESP - 7245752)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ESP = ESP - 4
XF[0x577260]()
ESP = ESP + 8
pc = 13
elseif pc == 13 then
EAX = ru(M, band(ESI + 108) - 7245824)
ECX = 2
do local a, b = EAX, ECX
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FS = band(r, 2147483648) ~= 0
end
if (FS == FO) then pc = 15 else pc = 14 end
elseif pc == 14 then
s0 = rf(M, ESP - 7245744)
s0 = s0 * rf(M, ESP - 7245736)
EDX = ru(M, ESP - 7245796)
s0 = s0 * rf(M, ESP - 7245800)
s1 = rf(M, ESP - 7245740)
s1 = s1 * rf(M, band(ESI + 676) - 7245824)
s1 = sqrt(s1)
s2 = rf(M, band(EBX) - 7245824)
s2 = s2 / rf(M, ESP - 7245784)
s2 = s2 * rf(M, 2084)
s2 = s2 + rf(M, band(EAX*4 + 12616404) - 7245824)
s3 = s1
s3 = s3 * rf(M, 5196)
s2 = s2 + s3
s2 = s2 + rf(M, ESP - 7245716)
s3 = rf(M, 2084)
s3 = s3 / rf(M, ESP - 7245728)
s3 = s3 * rf(M, band(EDI) - 7245824)
s4 = rf(M, ESP - 7245732)
s4 = s4 + rf(M, 2008)
wu(M, 5371356, EDX)
s4 = s4 * rf(M, 5196)
s4 = s4 * s1
s4 = s2 - s4
s5 = rf(M, ESP - 7245792)
s5 = s5 * s0
s4 = s4 * s5
s4, s1 = s1, s4
s4 = s4 * rf(M, ESP - 7245732)
s4 = s4 * rf(M, 27432)
s4 = s2 - s4
s5 = rf(M, ESP - 7245808)
s5 = s5 * s0
s4 = s4 * s5
s1 = s1 + s4
s3 = s3 * rf(M, band(EBX) - 7245824)
s1 = s1 + s3
s2, s1 = s1, s2
wfd(5370348, s2)
pc = 15
elseif pc == 15 then
s0 = rf(M, ESP - 7245776)
FSW = fcmp(s0, rf(M, 51396))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 20 else pc = 16 end
elseif pc == 16 then
s0 = rf(M, ESP - 7245724)
s0 = s0 * rf(M, ESP - 7245724)
s1 = rf(M, ESP - 7245720)
s1 = s1 * rf(M, ESP - 7245720)
s0 = s0 + s1
wfd(ESP - 7245732, s0)
s0 = rf(M, 51388)
s0 = s0 * rf(M, 51388)
FSW = fcmp(s0, rf(M, ESP - 7245732))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 18 else pc = 17 end
elseif pc == 17 then
s0 = rf(M, 5370948)
s0 = s0 * rf(M, ESP - 7245724)
wu(M, 5370500, 0)
EAX = ru(M, 7976064)
s0 = s0 * rf(M, 51444)
s1 = rf(M, band(ESI + 748) - 7245824)
s1 = s1 * rf(M, 51440)
s0 = s0 - s1
s0 = s0 * rf(M, 5370948)
s0 = s0 * rf(M, band(EAX) - 7245824)
s0 = s0 + rf(M, EBP - 7245824)
wfd(EBP - 7245824, s0)
s0 = rf(M, ESP - 7245748)
s0 = s0 * rf(M, 51440)
s1 = rf(M, 5370948)
s1 = s1 * rf(M, ESP - 7245720)
s1 = s1 * rf(M, 51436)
s0 = s0 - s1
s0 = s0 * rf(M, 5370948)
s0 = s0 + rf(M, band(EDI) - 7245824)
wfd(band(EDI) - 7245824, s0)
pc = 27
elseif pc == 18 then
s0 = rf(M, 51392)
s0 = s0 * rf(M, 51392)
FSW = fcmp(s0, rf(M, ESP - 7245732))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 20 else pc = 19 end
elseif pc == 19 then
s0 = rf(M, ESP - 7245732)
s0 = sqrt(s0)
wu(M, 5370500, 1)
ECX = ru(M, 7976064)
s0 = rf(M, 51388) / s0
wfd(5371428, s0)
s0 = s0 * rf(M, 5370948)
s0 = s0 * rf(M, ESP - 7245724)
s0 = s0 * rf(M, 51444)
s1 = rf(M, band(ESI + 748) - 7245824)
s1 = s1 * rf(M, 51440)
s0 = s0 - s1
s0 = s0 * rf(M, 5370948)
s0 = s0 * rf(M, band(ECX) - 7245824)
s0 = s0 + rf(M, EBP - 7245824)
wfd(EBP - 7245824, s0)
s0 = rf(M, ESP - 7245748)
s0 = s0 * rf(M, 51440)
s1 = rf(M, 5371428)
s1 = s1 * rf(M, 5370948)
s1 = s1 * rf(M, ESP - 7245720)
s1 = s1 * rf(M, 51436)
s0 = s0 - s1
s0 = s0 * rf(M, 5370948)
s0 = s0 + rf(M, band(EDI) - 7245824)
wfd(band(EDI) - 7245824, s0)
pc = 27
elseif pc == 20 then
wu(M, 5370500, ECX)
pc = 27
elseif pc == 21 then
EDX = ru(M, ESP - 7245756)
EDI = ru(M, ESP - 7245760)
s0 = rf(M, ESP - 7245732)
EBX = ru(M, ESP - 7245764)
EAX = ru(M, ESP - 7245768)
FSW = fcmp(s0, rf(M, 5204))
ECX = 0
wu(M, 5370500, 2)
wu(M, band(EDX) - 7245824, ECX)
wu(M, band(EDI) - 7245824, ECX)
wu(M, band(EBX) - 7245824, ECX)
wu(M, band(EAX) - 7245824, ECX)
EAX = bor(band(EAX, 0xffff0000), FSW)
wu(M, 5371424, ECX)
wu(M, 5370508, ECX)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 25 else pc = 22 end
elseif pc == 22 then
EBP = ru(M, band(ESI + 704) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
ESP = ESP - 4; wu(M, ESP - 7245824, 17)
ESP = ESP - 4
XF[0x579ea0]()
s0 = F[FT]; FT = FT - 1
wfd(ESP - 7245716, s0)
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
ESP = ESP - 4; wu(M, ESP - 7245824, 17)
ESP = ESP - 4
XF[0x579e80]()
s0 = F[FT]; FT = FT - 1
s0 = s0 * rf(M, 5370948)
ECX = ru(M, ESP - 7245740)
ESP = ESP + 16
s0 = s0 * rf(M, ESP - 7245732)
s1 = rf(M, ESP - 7245724)
s1 = s1 * rf(M, ESP - 7245744)
s0 = s0 + s1
s0 = s0 * rf(M, 5370948)
s1 = s0
wfd(band(ECX) - 7245824, s1)
FSW = fcmp(s0, rf(M, 51448))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 24 else pc = 23 end
elseif pc == 23 then
EDX = ru(M, ESP - 7245748)
EAX = ru(M, ESP - 7245752)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x577260]()
ESP = ESP + 8
pc = 24
elseif pc == 24 then
ECX = 0
pc = 25
elseif pc == 25 then
EAX = ru(M, band(ESI + 108) - 7245824)
wu(M, band(ESI + 712) - 7245824, ECX)
do local a, b = EAX, 2
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FS = band(r, 2147483648) ~= 0
end
wu(M, band(ESI + 740) - 7245824, ECX)
wu(M, band(ESI + 744) - 7245824, ECX)
wu(M, band(ESI + 748) - 7245824, ECX)
wu(M, band(ESI + 752) - 7245824, ECX)
if (FS == FO) then pc = 27 else pc = 26 end
elseif pc == 26 then
wu(M, 5371356, 0)
wu(M, 5370348, 0)
pc = 27
elseif pc == 27 then
ECX = ru(M, ESP - 7245756)
EDX = ru(M, band(ECX) - 7245824)
wu(M, band(ESI + 736) - 7245824, EDX)
EAX = ru(M, band(EDI) - 7245824)
wu(M, band(ESI + 732) - 7245824, EAX)
ECX = ru(M, band(EBX) - 7245824)
wu(M, band(ESI + 728) - 7245824, ECX)
EDI = ru(M, ESP - 7245824); ESP = ESP + 4
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
EBP = ru(M, ESP - 7245824); ESP = ESP + 4
EBX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 36
ESP = ESP + 60
do return end
end
end
end
XF[0x5501d0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 4
B_inServer()
do local r = band(band(band(EAX, 0xff), band(EAX, 0xff)), 255)
FZ = r == 0
end
if FZ then pc = 2 else pc = 1 end
elseif pc == 1 then
ESP = ESP - 4
XF[0x544bf0]()
pc = 4
elseif pc == 2 then
ESP = ESP - 4
B_inBackground()
do local r = band(band(band(EAX, 0xff), band(EAX, 0xff)), 255)
FZ = r == 0
end
if FZ then pc = 7 else pc = 3 end
elseif pc == 3 then
ESP = ESP - 4
XF[0x55a680]()
pc = 4
elseif pc == 4 then
do local r = band(band(EAX, EAX), 4294967295)
FZ = r == 0
end
if FZ then pc = 7 else pc = 5 end
elseif pc == 5 then
do local r = band(band(ru(M, band(EAX + 76) - 7245824), 536870912), 4294967295)
FZ = r == 0
end
if FZ then pc = 7 else pc = 6 end
elseif pc == 6 then
EAX = bor(band(EAX, 0xffffff00), band(0, 0xff))
ESP = ESP + 4
do return end
elseif pc == 7 then
EAX = bor(band(EAX, 0xffffff00), band(r8b(M, 5299974), 0xff))
ESP = ESP + 4
do return end
end
end
end
XF[0x550880] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 4
B_inBackground()
do local r = band(band(band(EAX, 0xff), band(EAX, 0xff)), 255)
FZ = r == 0
end
if FZ then pc = 3 else pc = 1 end
elseif pc == 1 then
ESP = ESP - 4
XF[0x55ab00]()
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x562f70]()
ECX = ru(M, band(EAX + 4) - 7245824)
EAX = band(EAX + 4)
ESP = ESP + 4
do local r = band(band(ECX, ECX), 4294967295)
FZ = r == 0
end
if FZ then pc = 3 else pc = 2 end
elseif pc == 2 then
ESP = ESP - 4
XF[0x55ab00]()
ECX = band(EAX + EAX*4)
ECX = band(ECX + ECX*4)
EDX = band(EAX + ECX*4)
EAX = band(EAX + EDX*2)
EAX = band(EAX*4 + 12617844)
pc = 6
elseif pc == 3 then
ESP = ESP - 4
B_inBackground()
do local r = band(band(band(EAX, 0xff), band(EAX, 0xff)), 255)
FZ = r == 0
end
if not FZ then pc = 8 else pc = 4 end
elseif pc == 4 then
ESP = ESP - 4
XF[0x55ab00]()
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x4f5970]()
ECX = ru(M, band(EAX + 4) - 7245824)
EAX = band(EAX + 4)
ESP = ESP + 4
do local r = band(band(ECX, ECX), 4294967295)
FZ = r == 0
end
if FZ then pc = 8 else pc = 5 end
elseif pc == 5 then
ESP = ESP - 4
XF[0x55ab00]()
ECX = band(EAX + EAX*4)
ECX = band(ECX + ECX*4)
EDX = band(EAX + ECX*4)
EAX = band(EAX + EDX*2)
EAX = band(EAX*4 + 11742956)
pc = 6
elseif pc == 6 then
do local r = band(band(EAX, EAX), 4294967295)
FZ = r == 0
end
if FZ then pc = 8 else pc = 7 end
elseif pc == 7 then
EDX = ru(M, ESP - 7245820)
ECX = band(EAX + 352)
EAX = band(EAX + 364)
wu(M, band(EDX) - 7245824, ECX)
ECX = ru(M, ESP - 7245816)
wu(M, band(ECX) - 7245824, EAX)
ESP = ESP + 4
do return end
elseif pc == 8 then
EDX = ru(M, ESP - 7245820)
EAX = ru(M, ESP - 7245816)
wu(M, band(EDX) - 7245824, 7297424)
wu(M, band(EAX) - 7245824, 7297424)
ESP = ESP + 4
do return end
end
end
end
XF[0x552400] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ECX = ru(M, 407924)
EAX = 0
do local r = band(band(ECX, ECX), 4294967295)
FZ = r == 0
end
EAX = bor(band(EAX, 0xffffff00), band((FZ) and 1 or 0, 0xff))
ESP = ESP + 4
do return end
end
end
end
XF[0x5538a0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ESI = band(EAX + 1)
do local a, b = ESI, 1
local r = a - b
r = band(r)
FZ = r == 0
end
if FZ then pc = 4 else pc = 1 end
elseif pc == 1 then
ESP = ESP - 4
XF[0x51a000]()
ECX = ru(M, band(EAX + 1092) - 7245824)
do local a = ECX; local r = band(a + 1, 4294967295)
ECX = r
end
do local a, b = ESI, ECX
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FZ = r == 0
FS = band(r, 2147483648) ~= 0
end
if (not FZ and FS == FO) then pc = 4 else pc = 2 end
elseif pc == 2 then
EAX = ru(M, band(ESI*4 + 12617440) - 7245824)
do local r = band(band(EAX, EAX), 4294967295)
FZ = r == 0
end
if FZ then pc = 4 else pc = 3 end
elseif pc == 3 then
do local a = ESI; local r = band(a + 1, 4294967295)
ESI = r
end
do local a, b = ESI, 1
local r = a - b
r = band(r)
FZ = r == 0
end
if not FZ then pc = 1 else pc = 4 end
elseif pc == 4 then
ESP = ESP - 4
XF[0x51a000]()
EDX = ru(M, band(EAX + 1092) - 7245824)
do local a = EDX; local r = band(a + 1, 4294967295)
EDX = r
end
do local a, b = ESI, EDX
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FZ = r == 0
FS = band(r, 2147483648) ~= 0
end
if (FZ or FS ~= FO) then pc = 6 else pc = 5 end
elseif pc == 5 then
ESP = ESP - 4
XF[0x51a000]()
EAX = ru(M, band(EAX + 1092) - 7245824)
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
do local a = EAX; local r = band(a + 1, 4294967295)
EAX = r
end
ESP = ESP + 4
do return end
elseif pc == 6 then
EAX = ESI
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 4
do return end
end
end
end
XF[0x5538f0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
do local a = EAX; local r = band(a - 1, 4294967295)
EAX = r
end
do local a, b = EAX, 1
local r = a - b
r = band(r)
FZ = r == 0
end
if FZ then pc = 4 else pc = 1 end
elseif pc == 1 then
do local r = band(band(EAX, EAX), 4294967295)
FS = band(r, 2147483648) ~= 0
FO = false
end
if (FS ~= FO) then pc = 5 else pc = 2 end
elseif pc == 2 then
ECX = ru(M, band(EAX*4 + 12617440) - 7245824)
do local r = band(band(ECX, ECX), 4294967295)
FZ = r == 0
end
if FZ then pc = 4 else pc = 3 end
elseif pc == 3 then
do local a = EAX; local r = band(a - 1, 4294967295)
EAX = r
end
do local a, b = EAX, 1
local r = a - b
r = band(r)
FZ = r == 0
end
if not FZ then pc = 1 else pc = 4 end
elseif pc == 4 then
do local r = band(band(EAX, EAX), 4294967295)
FS = band(r, 2147483648) ~= 0
FO = false
end
if (FS == FO) then pc = 6 else pc = 5 end
elseif pc == 5 then
EAX = 1
pc = 6
elseif pc == 6 then
ESP = ESP + 4
do return end
end
end
end
XF[0x553d70] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ESP = ESP - 4; wu(M, ESP - 7245824, EBX)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ESI = ru(M, 5299980)
EBX = 2
do local a, b = ESI, EBX
local r = a - b
r = band(r)
FZ = r == 0
end
if not FZ then pc = 11 else pc = 1 end
elseif pc == 1 then
ESP = ESP - 4
XF[0x51a000]()
ECX = ru(M, band(EAX + 1092) - 7245824)
EAX = ru(M, 5299747)
do local a = ECX; local r = band(a + 1, 4294967295)
ECX = r
end
do local a, b = EAX, ECX
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FZ = r == 0
FS = band(r, 2147483648) ~= 0
end
if (FZ or FS ~= FO) then pc = 3 else pc = 2 end
elseif pc == 2 then
EAX = 1
wu(M, 5299747, EAX)
pc = 3
elseif pc == 3 then
do local a, b = ru(M, 407932), EAX
local r = a - b
r = band(r)
FZ = r == 0
end
if FZ then pc = 6 else pc = 4 end
elseif pc == 4 then
do local a, b = EAX, 1
local r = a - b
r = band(r)
FZ = r == 0
end
if FZ then pc = 6 else pc = 5 end
elseif pc == 5 then
ESP = ESP - 4
XF[0x5543e0]()
EAX = ru(M, 5299747)
wu(M, 407920, 0)
pc = 6
elseif pc == 6 then
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
wu(M, 407932, EAX)
ESP = ESP - 4
XF[0x565830]()
ESP = ESP + 4
wu(M, 407928, EAX)
ESP = ESP - 4
XF[0x5542e0]()
do local r = band(band(band(EAX, 0xff), band(EAX, 0xff)), 255)
FZ = r == 0
end
if FZ then pc = 64 else pc = 7 end
elseif pc == 7 then
s0 = rf(M, 5297008)
FSW = fcmp(s0, rf(M, 407920))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 9 else pc = 8 end
elseif pc == 8 then
EDX = ru(M, 407920)
wu(M, 5297008, EDX)
pc = 9
elseif pc == 9 then
s0 = rf(M, 421236)
s0 = s0 * rf(M, 5396)
s0 = s0 + rf(M, 407920)
wfd(407920, s0)
FSW = fcmp(s0, rf(M, 2008))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 64 else pc = 10 end
elseif pc == 10 then
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
wu(M, 407920, 1065353216)
EBX = ru(M, ESP - 7245824); ESP = ESP + 4
ECX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 4
do return end
elseif pc == 11 then
EAX = ru(M, 5299864)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
EDI = 0
do local a, b = EAX, EDI
local r = a - b
r = band(r)
FZ = r == 0
end
if FZ then pc = 17 else pc = 12 end
elseif pc == 12 then
do local a = EAX; local r = band(a - 1, 4294967295)
FZ = r == 0
EAX = r
end
wu(M, 5299864, EAX)
if not FZ then pc = 54 else pc = 13 end
elseif pc == 13 then
EAX = ru(M, 5299872)
do local a, b = EAX, 3
local r = a - b
r = band(r)
FZ = r == 0
end
if not FZ then pc = 15 else pc = 14 end
elseif pc == 14 then
s0 = rf(M, 2084)
s0 = s0 / rf(M, 421236)
FT = FT + 1; F[FT] = s0
ESP = ESP - 4
B_ftol()
wu(M, 5299864, EAX)
wu(M, 5299700, EAX)
wu(M, 5299872, 4)
pc = 54
elseif pc == 15 then
do local a, b = EAX, 4
local r = a - b
r = band(r)
FZ = r == 0
end
if not FZ then pc = 54 else pc = 16 end
elseif pc == 16 then
wu(M, 5299872, EDI)
pc = 54
elseif pc == 17 then
EAX = ru(M, 5297100)
do local a = EAX; local r = band(a - 1, 4294967295)
EAX = r
end
do local a, b = EAX, 7
local r = a - b
FC = r < 0
r = band(r)
FZ = r == 0
end
if (not FC and not FZ) then pc = 54 else pc = 18 end
elseif pc == 18 then
do local t = EAX
if t == 0 then pc = 19
elseif t == 1 then pc = 29
elseif t == 2 then pc = 30
elseif t == 3 then pc = 31
elseif t == 4 then pc = 32
elseif t == 5 then pc = 41
elseif t == 6 then pc = 46
elseif t == 7 then pc = 49
else error("NR2003 lift: switch index out of range") end end
elseif pc == 19 then
ESP = ESP - 4
XF[0x552400]()
do local r = band(band(band(EAX, 0xff), band(EAX, 0xff)), 255)
FZ = r == 0
end
if FZ then pc = 21 else pc = 20 end
elseif pc == 20 then
ECX = ru(M, 407932)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ESP = ESP - 4
XF[0x5538a0]()
ESP = ESP + 4
pc = 24
elseif pc == 21 then
do local a, b = ESI, EDI
local r = a - b
r = band(r)
FZ = r == 0
end
if not FZ then pc = 23 else pc = 22 end
elseif pc == 22 then
EDX = ru(M, 407932)
do local a = EDX; local r = band(a + 1, 4294967295)
EDX = r
end
wu(M, 5297068, EDX)
pc = 25
elseif pc == 23 then
EAX = ru(M, 5299747)
pc = 24
elseif pc == 24 then
wu(M, 5297068, EAX)
pc = 25
elseif pc == 25 then
ESP = ESP - 4
XF[0x51a000]()
ECX = ru(M, band(EAX + 1092) - 7245824)
EAX = ru(M, 5297068)
do local a = ECX; local r = band(a + 1, 4294967295)
ECX = r
end
do local a, b = EAX, ECX
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FZ = r == 0
FS = band(r, 2147483648) ~= 0
end
if (not FZ and FS == FO) then pc = 53 else pc = 26 end
elseif pc == 26 then
do local a, b = EAX, ru(M, 407932)
local r = a - b
r = band(r)
FZ = r == 0
end
if FZ then pc = 53 else pc = 27 end
elseif pc == 27 then
wu(M, 5299864, EDI)
wu(M, 5299700, EDI)
wu(M, 5299872, 1)
wu(M, 5297100, EBX)
ESP = ESP - 4
XF[0x552400]()
do local r = band(band(band(EAX, 0xff), band(EAX, 0xff)), 255)
FZ = r == 0
end
if FZ then pc = 54 else pc = 28 end
elseif pc == 28 then
wu(M, 407916, 0)
pc = 55
elseif pc == 29 then
EDX = ru(M, 407932)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4
XF[0x565830]()
s0 = rf(M, 407936)
s0 = s0 / rf(M, 421236)
ESP = ESP + 4
wu(M, 407928, EAX)
wu(M, 407932, 1)
FT = FT + 1; F[FT] = s0
ESP = ESP - 4
B_ftol()
wu(M, 5299864, EAX)
wu(M, 5299700, EAX)
wu(M, 5299872, EBX)
wu(M, 5297100, 3)
pc = 54
elseif pc == 30 then
EAX = ru(M, 5297068)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x565830]()
s0 = rf(M, 407936)
s0 = s0 / rf(M, 421236)
ESP = ESP + 4
wu(M, 407928, EAX)
FT = FT + 1; F[FT] = s0
ESP = ESP - 4
B_ftol()
wu(M, 5299864, EAX)
wu(M, 5299700, EAX)
wu(M, 5299872, EBX)
wu(M, 5297100, 4)
pc = 54
elseif pc == 31 then
ECX = ru(M, 5297068)
wu(M, 407932, ECX)
ESP = ESP - 4
XF[0x5543e0]()
s0 = rf(M, 2084)
s0 = s0 / rf(M, 421236)
FT = FT + 1; F[FT] = s0
ESP = ESP - 4
B_ftol()
wu(M, 5299864, EAX)
wu(M, 5299700, EAX)
wu(M, 5299872, 4)
wu(M, 5297100, EDI)
wu(M, 407916, 3212836864)
pc = 56
elseif pc == 32 then
ESP = ESP - 4
XF[0x552400]()
EDX = ru(M, 407932)
do local r = band(band(band(EAX, 0xff), band(EAX, 0xff)), 255)
FZ = r == 0
end
if FZ then pc = 34 else pc = 33 end
elseif pc == 33 then
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4
XF[0x5538f0]()
ESP = ESP + 4
pc = 36
elseif pc == 34 then
do local a, b = ESI, EDI
local r = a - b
r = band(r)
FZ = r == 0
end
EAX = band(EDX + -1)
if FZ then pc = 36 else pc = 35 end
elseif pc == 35 then
EAX = ru(M, 5299747)
pc = 36
elseif pc == 36 then
do local a, b = EAX, EDI
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FS = band(r, 2147483648) ~= 0
end
wu(M, 5297068, EAX)
if (FS ~= FO) then pc = 53 else pc = 37 end
elseif pc == 37 then
do local a, b = EAX, EDX
local r = a - b
r = band(r)
FZ = r == 0
end
if FZ then pc = 53 else pc = 38 end
elseif pc == 38 then
EAX = ru(M, 5299872)
wu(M, 5299700, EDI)
do local a, b = EAX, 3
local r = a - b
r = band(r)
FZ = r == 0
end
wu(M, 5299864, EDI)
wu(M, 5299872, EBX)
if FZ then pc = 40 else pc = 39 end
elseif pc == 39 then
wu(M, 5299872, 1)
pc = 40
elseif pc == 40 then
wu(M, 5297100, 6)
pc = 54
elseif pc == 41 then
EDX = ru(M, 407932)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4
XF[0x565830]()
ESP = ESP + 4
wu(M, 407928, EAX)
wu(M, 407932, 1)
wu(M, 5299736, 1049750405)
ESP = ESP - 4
XF[0x554f10]()
s0 = F[FT]; FT = FT - 1
FSW = fcmp(s0, rf(M, 51776))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 45 else pc = 42 end
elseif pc == 42 then
do local a, b = ru(M, 5297068), EBX
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FS = band(r, 2147483648) ~= 0
end
if (FS ~= FO) then pc = 45 else pc = 43 end
elseif pc == 43 then
wu(M, 5296988, 1056293519)
ESP = ESP - 4
XF[0x5542e0]()
do local r = band(band(band(EAX, 0xff), band(EAX, 0xff)), 255)
FZ = r == 0
end
if FZ then pc = 45 else pc = 44 end
elseif pc == 44 then
EAX = ru(M, 5296988)
wu(M, 407916, EAX)
pc = 45
elseif pc == 45 then
s0 = rf(M, 5299736)
s0 = s0 / rf(M, 421236)
FT = FT + 1; F[FT] = s0
ESP = ESP - 4
B_ftol()
wu(M, 5299864, EAX)
wu(M, 5299700, EAX)
wu(M, 5299872, EBX)
wu(M, 5297100, 7)
pc = 54
elseif pc == 46 then
ECX = ru(M, 5297068)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ESP = ESP - 4
XF[0x565830]()
ESP = ESP + 4
wu(M, 407928, EAX)
wu(M, 407916, 3212836864)
ESP = ESP - 4
XF[0x5542e0]()
do local r = band(band(band(EAX, 0xff), band(EAX, 0xff)), 255)
FZ = r == 0
end
if FZ then pc = 48 else pc = 47 end
elseif pc == 47 then
wu(M, 407920, 0)
pc = 48
elseif pc == 48 then
s0 = rf(M, 407940)
s0 = s0 / rf(M, 421236)
FT = FT + 1; F[FT] = s0
ESP = ESP - 4
B_ftol()
wu(M, 5299864, EAX)
wu(M, 5299700, EAX)
wu(M, 5299872, EBX)
wu(M, 5297100, 8)
pc = 54
elseif pc == 49 then
EDX = ru(M, 5297068)
wu(M, 407932, EDX)
ESP = ESP - 4
XF[0x5543e0]()
EAX = ru(M, 5297068)
wu(M, 407920, 1065353216)
do local a, b = EAX, EBX
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FZ = r == 0
FS = band(r, 2147483648) ~= 0
end
if (not FZ and FS == FO) then pc = 51 else pc = 50 end
elseif pc == 50 then
s0 = rf(M, 2084)
s0 = s0 / rf(M, 421236)
FT = FT + 1; F[FT] = s0
ESP = ESP - 4
B_ftol()
wu(M, 5299872, 4)
pc = 52
elseif pc == 51 then
s0 = rf(M, 27432)
s0 = s0 / rf(M, 421236)
FT = FT + 1; F[FT] = s0
ESP = ESP - 4
B_ftol()
wu(M, 5299872, 3)
pc = 52
elseif pc == 52 then
wu(M, 5299864, EAX)
wu(M, 5299700, EAX)
pc = 53
elseif pc == 53 then
wu(M, 5297100, EDI)
pc = 54
elseif pc == 54 then
s0 = rf(M, 407916)
FSW = fcmp(s0, rf(M, 5204))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 256), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 56 else pc = 55 end
elseif pc == 55 then
EAX = ru(M, 407916)
wu(M, 5297000, EAX)
pc = 56
elseif pc == 56 then
ESP = ESP - 4
XF[0x5542e0]()
EDI = ru(M, ESP - 7245824); ESP = ESP + 4
do local r = band(band(band(EAX, 0xff), band(EAX, 0xff)), 255)
FZ = r == 0
end
ESP = ESP - 4; wu(M, ESP - 7245824, 4)
if FZ then pc = 62 else pc = 57 end
elseif pc == 57 then
ESP = ESP - 4
XF[0x57af60]()
ESP = ESP + 4
do local r = band(band(band(EAX, 0xff), band(EAX, 0xff)), 255)
FZ = r == 0
end
if FZ then pc = 61 else pc = 58 end
elseif pc == 58 then
s0 = rf(M, 407920)
FSW = fcmp(s0, rf(M, 5297008))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 60 else pc = 59 end
elseif pc == 59 then
ECX = ru(M, 407920)
ESP = ESP - 4; wu(M, ESP - 7245824, 1065353216)
EAX = ECX
wu(M, ESP - 7245812, ECX)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x5542f0]()
ESP = ESP + 8
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
EBX = ru(M, ESP - 7245824); ESP = ESP + 4
ECX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 4
do return end
elseif pc == 60 then
EDX = ru(M, 5297008)
ESP = ESP - 4; wu(M, ESP - 7245824, 1065353216)
EAX = EDX
wu(M, ESP - 7245812, EDX)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x5542f0]()
ESP = ESP + 8
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
EBX = ru(M, ESP - 7245824); ESP = ESP + 4
ECX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 4
do return end
elseif pc == 61 then
ECX = ru(M, 5297008)
EDX = ru(M, 407920)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4
XF[0x5542f0]()
ESP = ESP + 8
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
EBX = ru(M, ESP - 7245824); ESP = ESP + 4
ECX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 4
do return end
elseif pc == 62 then
ESP = ESP - 4
XF[0x57af60]()
ESP = ESP + 4
do local r = band(band(band(EAX, 0xff), band(EAX, 0xff)), 255)
FZ = r == 0
end
if FZ then pc = 64 else pc = 63 end
elseif pc == 63 then
EAX = ru(M, 5297008)
ESP = ESP - 4; wu(M, ESP - 7245824, 1065353216)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x5542f0]()
ESP = ESP + 8
pc = 64
elseif pc == 64 then
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
EBX = ru(M, ESP - 7245824); ESP = ESP + 4
ECX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 4
do return end
end
end
end
XF[0x5542e0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ECX = ru(M, 407924)
EAX = 0
do local a, b = ECX, 3
local r = a - b
r = band(r)
FZ = r == 0
end
EAX = bor(band(EAX, 0xffffff00), band((not FZ) and 1 or 0, 0xff))
ESP = ESP + 4
do return end
end
end
end
XF[0x5542f0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
s0 = rf(M, 407976)
FSW = fcmp(s0, rf(M, ESP - 7245816))
wu(M, ESP - 7245824, 1092616192)
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 3 else pc = 1 end
elseif pc == 1 then
s0 = rf(M, 421236)
s0 = s0 * rf(M, 5240)
s0 = rf(M, 407976) - s0
wfd(407976, s0)
FSW = fcmp(s0, rf(M, ESP - 7245816))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 10 else pc = 2 end
elseif pc == 2 then
EAX = ru(M, ESP - 7245816)
wu(M, 407976, EAX)
pc = 10
elseif pc == 3 then
s0 = rf(M, 407976)
FSW = fcmp(s0, rf(M, ESP - 7245816))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 10 else pc = 4 end
elseif pc == 4 then
ESP = ESP - 4
XF[0x554ee0]()
s0 = F[FT]; FT = FT - 1
FSW = fcmp(s0, rf(M, 21360))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 7 else pc = 5 end
elseif pc == 5 then
do local a, b = ru(M, 407932), 2
local r = a - b
r = band(r)
FZ = r == 0
end
if not FZ then pc = 7 else pc = 6 end
elseif pc == 6 then
s0 = rf(M, 2052)
pc = 8
elseif pc == 7 then
s0 = rf(M, ESP - 7245824)
pc = 8
elseif pc == 8 then
s1 = rf(M, 421236)
s1 = s1 * s0
s1 = s1 + rf(M, 407976)
wfd(407976, s1)
s0 = rf(M, 407976)
FSW = fcmp(s0, rf(M, ESP - 7245816))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 10 else pc = 9 end
elseif pc == 9 then
ECX = ru(M, ESP - 7245816)
wu(M, 407976, ECX)
pc = 10
elseif pc == 10 then
s0 = rf(M, ESP - 7245812)
FSW = fcmp(s0, rf(M, 407976))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 12 else pc = 11 end
elseif pc == 11 then
EDX = ru(M, 407976)
wu(M, 5297008, EDX)
ECX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 4
do return end
elseif pc == 12 then
EAX = ru(M, ESP - 7245812)
wu(M, 5297008, EAX)
ECX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 4
do return end
end
end
end
XF[0x5543e0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
w8b(M, 5300021, band(1, 0xff))
ESP = ESP + 4
do return end
end
end
end
XF[0x554e70] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
s0 = rf(M, ESP - 7245816)
s0 = s0 + rf(M, band(EAX*4 + 12545748) - 7245824)
ECX = ru(M, band(EAX*4 + 7653732) - 7245824)
do local a = ECX; local r = band(a + 1, 4294967295)
ECX = r
end
wu(M, band(EAX*4 + 7653732) - 7245824, ECX)
wfd(band(EAX*4 + 12545748) - 7245824, s0)
s0 = rf(M, ESP - 7245812)
s0 = s0 + rf(M, band(EAX*4 + 12545756) - 7245824)
wfd(band(EAX*4 + 12545756) - 7245824, s0)
s0 = rf(M, ESP - 7245808)
s0 = s0 + rf(M, band(EAX*4 + 12545764) - 7245824)
wfd(band(EAX*4 + 12545764) - 7245824, s0)
s0 = rf(M, ESP - 7245804)
s0 = s0 + rf(M, band(EAX*4 + 12545772) - 7245824)
wfd(band(EAX*4 + 12545772) - 7245824, s0)
EAX = band(EAX*4 + 7653732)
ESP = ESP + 4
do return end
end
end
end
XF[0x554ee0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 8
s0 = rf(M, 5299592)
s0 = s0 * rf(M, 51792)
wfd(ESP - 7245824, s0)
EAX = ru(M, ESP - 7245824)
EAX = band(band(EAX, 2147483647), 4294967295)
wu(M, ESP - 7245820, EAX)
s0 = rf(M, ESP - 7245820)
ESP = ESP + 8
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
end
end
end
XF[0x554f10] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
s0 = rf(M, 5299656)
s0 = s0 * rf(M, 51796)
FSW = fcmp(s0, rf(M, 16376))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 2 else pc = 1 end
elseif pc == 1 then
s0 = rf(M, 16376)
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
elseif pc == 2 then
FSW = fcmp(s0, rf(M, 49652))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 4 else pc = 3 end
elseif pc == 3 then
s0 = rf(M, 49652)
pc = 4
elseif pc == 4 then
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
end
end
end
XF[0x557d60] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
EAX = band(ECX + EAX*4)
ESP = ESP + 8
do return end
end
end
end
XF[0x55a680] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = 12609834
ESP = ESP + 4
do return end
end
end
end
XF[0x55ab00] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, 5364006)
ESP = ESP + 4
do return end
end
end
end
XF[0x55d880] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
ECX = ru(M, band(EAX + 52) - 7245824)
EDX = ru(M, band(EAX + 48) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 44) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX + 40) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 36) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX + 32) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 28) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX + 24) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 20) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX + 16) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 12) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX + 8) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 4) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ECX = 12532256
ESP = ESP - 4
XF[0x54cab0]()
ESP = ESP + 4
do return end
end
end
end
XF[0x55d8d0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
ECX = ru(M, band(EAX + 52) - 7245824)
EDX = ru(M, band(EAX + 48) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 44) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX + 40) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 36) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX + 32) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 28) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX + 24) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 20) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX + 16) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 12) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX + 8) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 4) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ECX = 12534873
ESP = ESP - 4
XF[0x54cab0]()
ESP = ESP + 4
do return end
end
end
end
XF[0x55d920] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
ECX = ru(M, band(EAX + 52) - 7245824)
EDX = ru(M, band(EAX + 48) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 44) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX + 40) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 36) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX + 32) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 28) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX + 24) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 20) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX + 16) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 12) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX + 8) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 4) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ECX = 12537490
ESP = ESP - 4
XF[0x54cab0]()
ESP = ESP + 4
do return end
end
end
end
XF[0x55d970] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
ECX = ru(M, band(EAX + 52) - 7245824)
EDX = ru(M, band(EAX + 48) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 44) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX + 40) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 36) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX + 32) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 28) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX + 24) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 20) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX + 16) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 12) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX + 8) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, band(EAX + 4) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = ru(M, band(EAX) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ECX = 12540107
ESP = ESP - 4
XF[0x54cab0]()
ESP = ESP + 4
do return end
end
end
end
XF[0x55e160] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
s0 = rf(M, band(EAX + 16) - 7245824)
s1 = rf(M, band(EAX + 20) - 7245824)
s2 = rf(M, band(EAX + 12) - 7245824)
ECX = ru(M, band(EAX) - 7245824)
wfd(band(ECX) - 7245824, s2)
EDX = ru(M, band(EAX + 4) - 7245824)
s1, s0 = s0, s1
wfd(band(EDX) - 7245824, s1)
EAX = ru(M, band(EAX + 8) - 7245824)
wfd(band(EAX) - 7245824, s0)
ESP = ESP + 4
do return end
end
end
end
XF[0x55e180] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 8
ECX = ru(M, ESP - 7245812)
s0 = rf(M, band(ECX + 4) - 7245824)
EAX = ru(M, band(ECX) - 7245824)
wfd(ESP - 7245812, s0)
wu(M, ESP - 7245824, EAX)
EAX = ru(M, ESP - 7245812)
EAX = band(band(EAX, 2147483647), 4294967295)
wu(M, ESP - 7245820, EAX)
s0 = rf(M, band(ECX + 8) - 7245824)
s0 = s0 * rf(M, 5324)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, ESP - 7245820)
EDX = ru(M, 5371356)
EAX = ru(M, 5370448)
s0 = s0 + rf(M, 5370348)
wfd(ESP - 7245824, s0)
s0 = rf(M, ESP - 7245816)
s0 = s0 + rf(M, 5284)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
wfd(ESP - 7245824, s0)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x554e70]()
ESP = ESP + 28
ESP = ESP + 4
do return end
end
end
end
XF[0x55e1e0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 4; wu(M, ESP - 7245824, EBX)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ESI = ru(M, ESP - 7245796)
EDX = ru(M, ESP - 7245808)
s0 = rf(M, ESP - 7245788)
EAX = ru(M, band(ESI + 12) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
wu(M, 5371424, EAX)
ECX = ru(M, band(ESI + 16) - 7245824)
EAX = ru(M, ESP - 7245788)
wu(M, 5370508, ECX)
wu(M, 5370948, EDX)
ECX = band(EAX + EAX*2)
ECX = band(ECX + ECX*8)
ECX = band(EAX + ECX*4)
EDX = band(ECX + ECX*2)
ECX = ru(M, ESP - 7245768)
EDI = band(EAX + EDX*8)
EDX = ru(M, 5371432)
wu(M, band(EDI + 12532960) - 7245824, ECX)
wfd(band(EDX) - 7245824, s0)
s0 = rf(M, ESP - 7245780)
ECX = ru(M, 5371436)
wfd(band(ECX) - 7245824, s0)
s0 = rf(M, ESP - 7245776)
EDX = ru(M, 5371440)
wfd(band(EDX) - 7245824, s0)
s0 = rf(M, ESP - 7245772)
ECX = ru(M, 5371240)
wfd(band(ECX) - 7245824, s0)
ECX = ru(M, ESP - 7245796)
EBX = ru(M, 5370628)
EDX = ru(M, band(ECX) - 7245824)
wu(M, band(EBX) - 7245824, EDX)
EBX = ru(M, 5370632)
EDX = ru(M, band(ECX + 4) - 7245824)
wu(M, band(EBX) - 7245824, EDX)
EDX = ru(M, 5370636)
ECX = ru(M, band(ECX + 8) - 7245824)
wu(M, band(EDX) - 7245824, ECX)
EDX = ru(M, 5371192)
ECX = ru(M, band(ESI) - 7245824)
wu(M, band(EDX) - 7245824, ECX)
EDX = ru(M, 5371196)
ECX = ru(M, band(ESI + 4) - 7245824)
wu(M, band(EDX) - 7245824, ECX)
EDX = ru(M, 5371200)
ECX = ru(M, band(ESI + 8) - 7245824)
wu(M, band(EDX) - 7245824, ECX)
EAX = ru(M, band(EAX*4 + 15223696) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
B_callback()
ECX = ru(M, 5371340)
ESP = ESP + 4
EDX = ru(M, band(ECX) - 7245824)
ECX = ru(M, ESP - 7245808)
wu(M, band(ECX) - 7245824, EDX)
EAX = ru(M, 5371344)
EDX = ru(M, band(EAX) - 7245824)
wu(M, band(ECX + 4) - 7245824, EDX)
EAX = ru(M, 5371348)
EDX = ru(M, band(EAX) - 7245824)
wu(M, band(ECX + 8) - 7245824, EDX)
EAX = ru(M, 5371424)
wu(M, band(ESI + 12) - 7245824, EAX)
EDX = ru(M, 5370508)
wu(M, band(ESI + 16) - 7245824, EDX)
EAX = ru(M, 5371220)
EDX = ru(M, band(EAX) - 7245824)
EAX = ru(M, ESP - 7245800)
wu(M, band(EAX) - 7245824, EDX)
EDX = ru(M, 5371224)
EDX = ru(M, band(EDX) - 7245824)
wu(M, band(EAX + 4) - 7245824, EDX)
EDX = ru(M, 5371228)
EDX = ru(M, band(EDX) - 7245824)
wu(M, band(EAX + 8) - 7245824, EDX)
EDX = ru(M, 5370500)
do local a, b = EDX, 2
local r = a - b
r = band(r)
FZ = r == 0
end
if not FZ then pc = 2 else pc = 1 end
elseif pc == 1 then
EDX = ru(M, band(EAX) - 7245824)
wu(M, band(ESI) - 7245824, EDX)
EDX = ru(M, band(EAX + 4) - 7245824)
wu(M, band(ESI + 4) - 7245824, EDX)
EDX = ru(M, band(EAX + 8) - 7245824)
wu(M, band(ESI + 8) - 7245824, EDX)
pc = 4
elseif pc == 2 then
do local a, b = EDX, 1
local r = a - b
r = band(r)
FZ = r == 0
end
if not FZ then pc = 4 else pc = 3 end
elseif pc == 3 then
EDX = ru(M, 5371284)
s0 = rf(M, 5371428)
s0 = s0 * rf(M, band(EDX) - 7245824)
s0 = rf(M, band(EAX) - 7245824) - s0
wfd(band(ESI) - 7245824, s0)
EDX = ru(M, 5371288)
s0 = rf(M, 5371428)
s0 = s0 * rf(M, band(EDX) - 7245824)
s0 = rf(M, band(EAX + 4) - 7245824) - s0
wfd(band(ESI + 4) - 7245824, s0)
EDX = ru(M, 5371292)
s0 = rf(M, 5371428)
s0 = s0 * rf(M, band(EDX) - 7245824)
s0 = rf(M, band(EAX + 8) - 7245824) - s0
wfd(band(ESI + 8) - 7245824, s0)
pc = 4
elseif pc == 4 then
EDX = ru(M, 5370528)
EDX = ru(M, band(EDX) - 7245824)
wu(M, band(EDI + 12534808) - 7245824, EDX)
EDX = ru(M, 5370532)
EDX = ru(M, band(EDX) - 7245824)
wu(M, band(EDI + 12534812) - 7245824, EDX)
EDX = ru(M, 5370536)
EDX = ru(M, band(EDX) - 7245824)
wu(M, band(EDI + 12534816) - 7245824, EDX)
EDX = ru(M, band(EAX) - 7245824)
wu(M, band(EDI + 12534796) - 7245824, EDX)
EDX = ru(M, band(EAX + 4) - 7245824)
wu(M, band(EDI + 12534800) - 7245824, EDX)
EAX = ru(M, band(EAX + 8) - 7245824)
wu(M, band(EDI + 12534804) - 7245824, EAX)
EDX = ru(M, band(ECX) - 7245824)
wu(M, ESP - 7245792, EDX)
EAX = ru(M, ESP - 7245792)
EAX = band(band(EAX, 2147483647), 4294967295)
wu(M, ESP - 7245804, EAX)
EAX = ru(M, band(ECX + 4) - 7245824)
wu(M, ESP - 7245792, EAX)
EAX = ru(M, ESP - 7245792)
EAX = band(band(EAX, 2147483647), 4294967295)
wu(M, ESP - 7245788, EAX)
s0 = rf(M, ESP - 7245804)
s0 = s0 * rf(M, 5388)
EDI = ru(M, ESP - 7245824); ESP = ESP + 4
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
EBX = ru(M, ESP - 7245824); ESP = ESP + 4
s0 = s0 + rf(M, ESP - 7245800)
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
end
end
end
XF[0x55e3e0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, 5370356)
wu(M, band(EAX) - 7245824, 0)
ECX = ru(M, 5370360)
wu(M, band(ECX) - 7245824, 0)
EDX = ru(M, 5370364)
wu(M, band(EDX) - 7245824, 0)
EAX = ru(M, 5370368)
wu(M, band(EAX) - 7245824, 0)
ESP = ESP + 4
do return end
end
end
end
XF[0x55e450] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
s0 = rf(M, band(EAX) - 7245824)
wfd(5287048, s0)
ESP = ESP + 4
do return end
end
end
end
XF[0x55e460] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
s0 = rf(M, band(EAX) - 7245824)
wfd(5289665, s0)
ESP = ESP + 4
do return end
end
end
end
XF[0x55e470] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
s0 = rf(M, band(EAX) - 7245824)
wfd(5292282, s0)
ESP = ESP + 4
do return end
end
end
end
XF[0x55e480] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
s0 = rf(M, band(EAX) - 7245824)
wfd(5294899, s0)
ESP = ESP + 4
do return end
end
end
end
XF[0x55fc50] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 48
EAX = ru(M, ESP - 7245772)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ECX = ru(M, band(EAX) - 7245824)
s0 = rf(M, band(EAX + 4) - 7245824)
wu(M, ESP - 7245784, ECX)
FT = FT + 1; F[FT] = s0
ESP = ESP - 4
B_ftol()
ESI = EAX
ESP = ESP - 4
XF[0x51c2d0]()
s0 = rf(M, band(EAX + 8) - 7245824)
FSW = fcmp(s0, rf(M, ESP - 7245784))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 68), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 3 else pc = 1 end
elseif pc == 1 then
ESP = ESP - 4
XF[0x51c2d0]()
do local a, b = ESI, ru(M, band(EAX + 12) - 7245824)
local r = a - b
r = band(r)
FZ = r == 0
end
if not FZ then pc = 3 else pc = 2 end
elseif pc == 2 then
EAX = bor(band(EAX, 0xffffff00), band(r8b(M, 5371652), 0xff))
do local r = band(band(band(EAX, 0xff), band(EAX, 0xff)), 255)
FZ = r == 0
end
if FZ then pc = 14 else pc = 3 end
elseif pc == 3 then
ESP = ESP - 4; wu(M, ESP - 7245824, 110)
ECX = 12604864
ESP = ESP - 4
XF[0x557d60]()
EDX = ru(M, band(EAX) - 7245824)
EAX = ru(M, band(ESI*4 + 12617440) - 7245824)
wu(M, ESP - 7245812, EDX)
ECX = 12604864
s0 = rf(M, ESP - 7245812)
s0 = s0 * rf(M, ESP - 7245812)
do local r = band(band(EAX, EAX), 4294967295)
FZ = r == 0
end
wfd(ESP - 7245768, s0)
if not FZ then pc = 5 else pc = 4 end
elseif pc == 4 then
EAX = band(ESI + 102)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x557d60]()
ECX = ru(M, band(EAX) - 7245824)
wu(M, ESP - 7245816, ECX)
pc = 6
elseif pc == 5 then
ESP = ESP - 4; wu(M, ESP - 7245824, 103)
ESP = ESP - 4
XF[0x557d60]()
EDX = ru(M, band(EAX) - 7245824)
wu(M, ESP - 7245816, EDX)
pc = 6
elseif pc == 6 then
EAX = ru(M, 5370648)
EDX = ru(M, 5371136)
ECX = ru(M, band(EAX + 377) - 7245824)
EAX = ru(M, band(EDX + 377) - 7245824)
EDX = ru(M, 5370772)
s0 = rf(M, band(ECX) - 7245824)
ECX = ru(M, band(EAX) - 7245824)
EAX = ru(M, band(EDX + 377) - 7245824)
EDX = ru(M, 5371060)
wu(M, ESP - 7245804, ECX)
s1 = rf(M, ESP - 7245816)
ECX = ru(M, band(EAX) - 7245824)
EAX = ru(M, band(EDX + 405) - 7245824)
FSW = fcmp(s1, rf(M, 5204))
wu(M, ESP - 7245808, ECX)
ECX = ru(M, band(EAX) - 7245824)
wu(M, ESP - 7245796, ECX)
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 68), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 11 else pc = 7 end
elseif pc == 7 then
s1 = rf(M, ESP - 7245784)
FSW = fcmp(s1, rf(M, 16416))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 9 else pc = 8 end
elseif pc == 8 then
s1 = rf(M, 5204)
pc = 10
elseif pc == 9 then
s1 = rf(M, ESP - 7245804)
s1 = s1 + s0
s1 = rf(M, 2008) / s1
pc = 10
elseif pc == 10 then
s2 = rf(M, ESP - 7245804)
EDX = ru(M, 415672)
s2 = s2 * s1
wfd(ESP - 7245788, s2)
s2 = -s2
wfd(band(EDX) - 7245824, s2)
EAX = ru(M, 415696)
s0 = s0 * s1
s1 = s0
wfd(band(EAX) - 7245824, s1)
ECX = ru(M, 415720)
s1 = rf(M, ESP - 7245788)
wu(M, band(ECX) - 7245824, 0)
EDX = ru(M, 415744)
wu(M, band(EDX) - 7245824, 0)
EAX = ru(M, 415768)
wu(M, band(EAX) - 7245824, 0)
ECX = ru(M, 415676)
wfd(band(ECX) - 7245824, s1)
EDX = ru(M, 415700)
s0 = -s0
wfd(band(EDX) - 7245824, s0)
s0 = rf(M, ESP - 7245808)
s0 = s0 * rf(M, ESP - 7245768)
s1 = rf(M, ESP - 7245796)
s1 = s1 + s1
EAX = ru(M, 415724)
s0 = s0 + s1
wu(M, band(EAX) - 7245824, 0)
ECX = ru(M, 415748)
s0 = rf(M, 2008) / s0
wu(M, band(ECX) - 7245824, 0)
EDX = ru(M, 415772)
wu(M, band(EDX) - 7245824, 0)
EAX = ru(M, 415680)
wu(M, band(EAX) - 7245824, 0)
ECX = ru(M, 415704)
wu(M, band(ECX) - 7245824, 0)
EDX = ru(M, 415728)
s1 = rf(M, ESP - 7245796)
s1 = s1 * s0
s2 = rf(M, 18240)
s2 = s2 * s1
wfd(band(EDX) - 7245824, s2)
s1, s0 = s0, s1
s1 = s1 * rf(M, ESP - 7245808)
EAX = ru(M, 415752)
wfd(ESP - 7245788, s1)
s1 = s1 * rf(M, ESP - 7245812)
s2 = s1
wfd(band(EAX) - 7245824, s2)
ECX = ru(M, 415776)
wfd(band(ECX) - 7245824, s1)
EDX = ru(M, 415684)
s0 = s0 * rf(M, ESP - 7245812)
wu(M, band(EDX) - 7245824, 0)
EAX = ru(M, 415708)
wu(M, band(EAX) - 7245824, 0)
ECX = ru(M, 415732)
s1 = s0
wfd(band(ECX) - 7245824, s1)
s1 = rf(M, ESP - 7245788)
s1 = s1 * rf(M, ESP - 7245768)
EDX = ru(M, 415756)
s1 = s1 * rf(M, 21352)
s2 = s1
wfd(band(EDX) - 7245824, s2)
EAX = ru(M, 415780)
s2 = s1
wfd(band(EAX) - 7245824, s2)
ECX = ru(M, 415688)
s1, s0 = s0, s1
wu(M, band(ECX) - 7245824, 0)
EDX = ru(M, 415712)
wu(M, band(EDX) - 7245824, 0)
EAX = ru(M, 415736)
wfd(band(EAX) - 7245824, s1)
ECX = ru(M, 415760)
s1 = s0
wfd(band(ECX) - 7245824, s1)
EDX = ru(M, 415784)
wfd(band(EDX) - 7245824, s0)
pc = 14
elseif pc == 11 then
s1 = rf(M, ESP - 7245816)
s1 = s1 * rf(M, ESP - 7245816)
wu(M, ESP - 7245792, 1065353216)
wfd(ESP - 7245800, s1)
s1 = rf(M, ESP - 7245784)
FSW = fcmp(s1, rf(M, 16416))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 13 else pc = 12 end
elseif pc == 12 then
s0 = rf(M, 5204)
wu(M, ESP - 7245792, 0)
pc = 13
elseif pc == 13 then
s1 = rf(M, ESP - 7245804)
s1 = s1 + s0
EAX = ru(M, 415672)
s1 = s1 * rf(M, ESP - 7245800)
wfd(ESP - 7245780, s1)
s1 = s1 + rf(M, ESP - 7245808)
wfd(ESP - 7245776, s1)
s1 = rf(M, ESP - 7245796)
s1 = s1 + s1
wfd(ESP - 7245788, s1)
s1 = rf(M, ESP - 7245776)
s1 = s1 * rf(M, ESP - 7245768)
s1 = s1 + rf(M, ESP - 7245788)
s1 = rf(M, 2008) / s1
wfd(ESP - 7245820, s1)
s1 = rf(M, ESP - 7245800)
s1 = s1 * rf(M, ESP - 7245804)
s1 = s1 + rf(M, ESP - 7245808)
s1 = s1 * rf(M, ESP - 7245768)
s1 = s1 + rf(M, ESP - 7245788)
s1 = s1 * rf(M, ESP - 7245792)
s1 = s1 * rf(M, ESP - 7245820)
s1 = -s1
wfd(band(EAX) - 7245824, s1)
s1 = rf(M, ESP - 7245800)
s1 = s1 * rf(M, ESP - 7245820)
ECX = ru(M, 415696)
s1 = s1 * s0
s1 = s1 * rf(M, ESP - 7245768)
wfd(band(ECX) - 7245824, s1)
s1 = rf(M, ESP - 7245820)
s1 = s1 * s0
EDX = ru(M, 415720)
s1 = s1 * rf(M, ESP - 7245816)
s2 = rf(M, ESP - 7245768)
s2 = s2 * s1
wfd(band(EDX) - 7245824, s2)
EAX = ru(M, 415744)
s1 = s1 * rf(M, ESP - 7245812)
s2 = s1
wfd(band(EAX) - 7245824, s2)
ECX = ru(M, 415768)
wfd(band(ECX) - 7245824, s1)
s1 = rf(M, ESP - 7245792)
s1 = s1 * rf(M, ESP - 7245800)
EDX = ru(M, 415676)
s1 = s1 * rf(M, ESP - 7245820)
s1 = s1 * rf(M, ESP - 7245804)
s1 = s1 * rf(M, ESP - 7245768)
wfd(band(EDX) - 7245824, s1)
s1 = rf(M, ESP - 7245800)
s1 = s1 * s0
EAX = ru(M, 415700)
s1 = s1 + rf(M, ESP - 7245808)
s1 = s1 * rf(M, ESP - 7245768)
s1 = s1 + rf(M, ESP - 7245788)
s1 = s1 * rf(M, ESP - 7245820)
s1 = -s1
wfd(band(EAX) - 7245824, s1)
ECX = ru(M, 415724)
s0 = rf(M, ESP - 7245820)
s0 = s0 * rf(M, ESP - 7245804)
s0 = s0 * rf(M, ESP - 7245816)
s1 = rf(M, ESP - 7245768)
s1 = s1 * s0
wfd(band(ECX) - 7245824, s1)
EDX = ru(M, 415748)
s0 = s0 * rf(M, ESP - 7245812)
s1 = s0
wfd(band(EDX) - 7245824, s1)
EAX = ru(M, 415772)
wfd(band(EAX) - 7245824, s0)
s0 = rf(M, ESP - 7245792)
s0 = s0 * rf(M, ESP - 7245820)
s1 = rf(M, ESP - 7245808)
s1 = s1 * s0
ECX = ru(M, 415680)
s1 = s1 * rf(M, ESP - 7245816)
s1 = s1 * rf(M, ESP - 7245768)
wfd(band(ECX) - 7245824, s1)
s1 = rf(M, ESP - 7245820)
s1 = s1 * rf(M, ESP - 7245808)
s2 = rf(M, ESP - 7245816)
EDX = ru(M, 415704)
s2 = s2 * s1
s2 = s2 * rf(M, ESP - 7245768)
wfd(band(EDX) - 7245824, s2)
s2 = rf(M, ESP - 7245780)
s2 = s2 * rf(M, ESP - 7245768)
EAX = ru(M, 415728)
s2 = s2 + rf(M, ESP - 7245788)
s2 = s2 * rf(M, ESP - 7245820)
s2 = -s2
wfd(band(EAX) - 7245824, s2)
ECX = ru(M, 415752)
s1 = s1 * rf(M, ESP - 7245812)
s2 = s1
wfd(band(ECX) - 7245824, s2)
EDX = ru(M, 415776)
wfd(band(EDX) - 7245824, s1)
EAX = ru(M, 415684)
s0 = s0 * rf(M, ESP - 7245796)
s0 = s0 * rf(M, ESP - 7245816)
s0 = s0 * rf(M, ESP - 7245812)
s1 = s0
wfd(band(EAX) - 7245824, s1)
s1 = rf(M, ESP - 7245820)
s1 = s1 * rf(M, ESP - 7245796)
s2 = rf(M, ESP - 7245816)
ECX = ru(M, 415708)
s2 = s2 * s1
s2 = s2 * rf(M, ESP - 7245812)
wfd(ESP - 7245780, s2)
wfd(band(ECX) - 7245824, s2)
EDX = ru(M, 415732)
s1 = s1 * rf(M, ESP - 7245812)
s2 = s1
wfd(band(EDX) - 7245824, s2)
s2 = rf(M, ESP - 7245776)
s2 = s2 * rf(M, ESP - 7245820)
EAX = ru(M, 415756)
s2 = s2 * rf(M, ESP - 7245768)
s2 = s2 * rf(M, 21352)
wfd(ESP - 7245768, s2)
wfd(band(EAX) - 7245824, s2)
s2 = rf(M, ESP - 7245768)
ECX = ru(M, 415780)
wfd(band(ECX) - 7245824, s2)
EDX = ru(M, 415688)
s1, s0 = s0, s1
wfd(band(EDX) - 7245824, s1)
s1 = rf(M, ESP - 7245780)
EAX = ru(M, 415712)
wfd(band(EAX) - 7245824, s1)
ECX = ru(M, 415736)
wfd(band(ECX) - 7245824, s0)
s0 = rf(M, ESP - 7245768)
EDX = ru(M, 415760)
wfd(band(EDX) - 7245824, s0)
s0 = rf(M, ESP - 7245768)
EAX = ru(M, 415784)
wfd(band(EAX) - 7245824, s0)
pc = 14
elseif pc == 14 then
w8b(M, 5371652, band(0, 0xff))
ESP = ESP - 4
XF[0x51c2d0]()
ECX = ru(M, ESP - 7245784)
wu(M, band(EAX + 8) - 7245824, ECX)
ESP = ESP - 4
XF[0x51c2d0]()
wu(M, band(EAX + 12) - 7245824, ESI)
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 48
ESP = ESP + 4
do return end
end
end
end
XF[0x560120] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
ECX = ru(M, band(EAX) - 7245824)
wu(M, ESP - 7245820, ECX)
ESP = ESP - 4
XF[0x51c2d0]()
EDX = ru(M, ESP - 7245820)
ECX = band(EAX + 32)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4
XF[0x51c1e0]()
ESP = ESP + 4
do return end
end
end
end
XF[0x560140] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
ECX = ru(M, band(EAX) - 7245824)
wu(M, ESP - 7245820, ECX)
ESP = ESP - 4
XF[0x51c2d0]()
EDX = ru(M, ESP - 7245820)
ECX = band(EAX + 40)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4
XF[0x51c1e0]()
ESP = ESP + 4
do return end
end
end
end
XF[0x560160] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
ECX = ru(M, band(EAX) - 7245824)
wu(M, ESP - 7245820, ECX)
ESP = ESP - 4
XF[0x51c2d0]()
EDX = ru(M, ESP - 7245820)
ECX = band(EAX + 16)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4
XF[0x51c1e0]()
ESP = ESP + 4
do return end
end
end
end
XF[0x560180] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
ECX = ru(M, band(EAX) - 7245824)
wu(M, ESP - 7245820, ECX)
ESP = ESP - 4
XF[0x51c2d0]()
EDX = ru(M, ESP - 7245820)
ECX = band(EAX + 24)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4
XF[0x51c1e0]()
ESP = ESP + 4
do return end
end
end
end
XF[0x5601a0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
ECX = ru(M, band(EAX) - 7245824)
wu(M, ESP - 7245820, ECX)
ESP = ESP - 4
XF[0x51c2d0]()
EDX = ru(M, ESP - 7245820)
ECX = EAX
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4
XF[0x51c1e0]()
ESP = ESP + 4
do return end
end
end
end
XF[0x560300] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, 5371680)
ESP = ESP - 24
do local r = band(bxor(EAX, 1), 4294967295)
FZ = r == 0
EAX = r
end
wu(M, 5371680, EAX)
if FZ then pc = 5 else pc = 1 end
elseif pc == 1 then
EAX = bor(band(EAX, 0xffffff00), band(r8b(M, 5297112), 0xff))
do local r = band(band(band(EAX, 0xff), band(EAX, 0xff)), 255)
FZ = r == 0
end
if FZ then pc = 5 else pc = 2 end
elseif pc == 2 then
ESP = ESP - 4; wu(M, ESP - 7245824, EBX)
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
EBX = 0
EDI = 12543106
ESI = 12532752
pc = 3
elseif pc == 3 then
s0 = rf(M, band(ESI + 176) - 7245824)
s0 = s0 * rf(M, 52460)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
wfd(band(EDI + 12) - 7245824, s0)
ESP = ESP - 4
B_nop()
EAX = ru(M, band(ESI + -4) - 7245824)
EDX = ru(M, band(ESI + -12) - 7245824)
ESP = ESP + 4
ECX = band(ESI + -12)
ESP = ESP - 4; wu(M, ESP - 7245824, 4)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
EAX = band(ESP + 24)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x425e80]()
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ESP = ESP - 4
B_nop()
s0 = rf(M, ESP - 7245804)
s0 = s0 - rf(M, 21328)
EBP = band(ESI + 44)
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
wfd(band(EDI) - 7245824, s0)
ESP = ESP - 4
B_nop()
EDX = ru(M, band(ESI + 40) - 7245824)
EAX = ru(M, band(ESI + 32) - 7245824)
ESP = ESP + 8
ECX = band(ESI + 32)
ESP = ESP - 4; wu(M, ESP - 7245824, 4)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EDX = band(ESP + 28)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4
XF[0x425e80]()
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
ESP = ESP - 4
B_nop()
s0 = rf(M, ESP - 7245800)
s0 = s0 - rf(M, 21328)
EBP = band(ESI + 88)
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
wfd(band(EDI + 4) - 7245824, s0)
ESP = ESP - 4
B_nop()
EAX = ru(M, band(ESI + 84) - 7245824)
EDX = ru(M, band(ESI + 76) - 7245824)
ESP = ESP + 8
ECX = band(ESI + 76)
ESP = ESP - 4; wu(M, ESP - 7245824, 4)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
EAX = band(ESP + 32)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x425e80]()
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
ESP = ESP - 4
B_nop()
s0 = rf(M, ESP - 7245796)
ECX = ru(M, band(EBX*4 + 12616876) - 7245824)
ESP = ESP + 4
s0 = s0 - rf(M, 21328)
wfd(band(EDI + 8) - 7245824, s0)
EDX = ru(M, band(ECX + 917) - 7245824)
ECX = EBX
ECX = bor(band(ECX, 0xffffff00), band(band(band(band(ECX, 0xff), 1), 255), 0xff))
do local a = band(ECX, 0xff); local r = band(-a, 255)
FC = a ~= 0
ECX = bor(band(ECX, 0xffffff00), band(r, 0xff))
end
do local a, b = ECX, ECX
local r = a - b - (FC and 1 or 0)
r = band(r)
ECX = r
end
EAX = ru(M, band(EDX) - 7245824)
ECX = band(band(ECX, 2), 4294967295)
EDX = ru(M, band(ESI + 240) - 7245824)
do local a = ECX; local r = band(a - 1, 4294967295)
ECX = r
end
wu(M, band(EDI + -64) - 7245824, EAX)
wu(M, ESP - 7245796, ECX)
wu(M, band(EDI + -52) - 7245824, EDX)
s0 = ri(M, ESP - 7245796)
s0 = s0 * rf(M, band(ESI + 204) - 7245824)
wfd(band(EDI + -56) - 7245824, s0)
ESI = band(ESI + 2617)
do local a = EBX; local r = band(a + 1, 4294967295)
EBX = r
end
EDI = band(EDI + 16)
do local a, b = ESI, 12540603
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FZ = r == 0
FS = band(r, 2147483648) ~= 0
end
if (FZ or FS ~= FO) then pc = 3 else pc = 4 end
elseif pc == 4 then
ESP = ESP - 4; wu(M, ESP - 7245824, 178)
ECX = 12604864
ESP = ESP - 4
XF[0x557d60]()
ECX = ru(M, 5371072)
ESP = ESP - 4; wu(M, ESP - 7245824, 179)
EDX = ru(M, band(ECX + 725) - 7245824)
ECX = 12604864
s0 = rf(M, band(EDX) - 7245824)
s0 = s0 + rf(M, band(EAX) - 7245824)
wfd(5297222, s0)
ESP = ESP - 4
XF[0x557d60]()
ECX = ru(M, 5370640)
ESP = ESP - 4; wu(M, ESP - 7245824, 180)
EDX = ru(M, band(ECX + 725) - 7245824)
ECX = 12604864
s0 = rf(M, band(EDX) - 7245824)
s0 = s0 + rf(M, band(EAX) - 7245824)
wfd(5297238, s0)
ESP = ESP - 4
XF[0x557d60]()
ECX = ru(M, 5370452)
ESP = ESP - 4; wu(M, ESP - 7245824, 181)
EDX = ru(M, band(ECX + 861) - 7245824)
ECX = ru(M, band(ECX + 725) - 7245824)
s0 = rf(M, band(EDX) - 7245824)
EDX = ru(M, 5371060)
s0 = s0 * rf(M, band(EDX + 72) - 7245824)
s0 = s0 + rf(M, band(ECX) - 7245824)
ECX = 12604864
s0 = s0 + rf(M, band(EAX) - 7245824)
wfd(5297254, s0)
ESP = ESP - 4
XF[0x557d60]()
ECX = ru(M, 5370452)
EDX = ru(M, band(ECX + 861) - 7245824)
ECX = ru(M, band(ECX + 725) - 7245824)
s0 = rf(M, band(EDX) - 7245824)
EDX = ru(M, 5371064)
s0 = s0 * rf(M, band(EDX + 72) - 7245824)
EDX = band(ESP + 36)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
s0 = s0 + rf(M, band(ECX) - 7245824)
s0 = s0 + rf(M, band(EAX) - 7245824)
EAX = band(ESP + 36)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
wfd(5297270, s0)
ESP = ESP - 4
XF[0x51a000]()
ECX = EAX
ESP = ESP - 4
XF[0x51bde0]()
ECX = ru(M, 5370648)
EDX = ru(M, band(ECX + 913) - 7245824)
s0 = rf(M, band(EDX) - 7245824)
s0 = s0 * rf(M, 52456)
wfd(5297346, s0)
s0 = rf(M, ESP - 7245792)
s0 = s0 - rf(M, ESP - 7245788)
wfd(5297350, s0)
ESP = ESP - 4
XF[0x51c2d0]()
ECX = ru(M, 5370648)
EDI = ru(M, ESP - 7245824); ESP = ESP + 4
s0 = rf(M, band(EAX + 32) - 7245824)
EDX = ru(M, band(ECX + 937) - 7245824)
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
s0 = s0 + rf(M, band(EDX) - 7245824)
EBP = ru(M, ESP - 7245824); ESP = ESP + 4
EBX = ru(M, ESP - 7245824); ESP = ESP + 4
wfd(5297354, s0)
pc = 5
elseif pc == 5 then
ESP = ESP + 24
ESP = ESP + 4
do return end
end
end
end
XF[0x560870] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 8
EAX = band(ESP + 4)
ECX = band(ESP)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ESP = ESP - 4
XF[0x550880]()
EAX = ru(M, ESP - 7245804)
ECX = ru(M, ESP - 7245816)
EDX = ru(M, band(EAX) - 7245824)
ECX = ru(M, band(ECX) - 7245824)
wu(M, band(EDX) - 7245824, ECX)
ECX = ru(M, ESP - 7245816)
EDX = ru(M, band(EAX + 4) - 7245824)
ECX = ru(M, band(ECX + 4) - 7245824)
wu(M, band(EDX) - 7245824, ECX)
ECX = ru(M, ESP - 7245816)
EDX = ru(M, band(EAX + 8) - 7245824)
ECX = ru(M, band(ECX + 8) - 7245824)
wu(M, band(EDX) - 7245824, ECX)
ECX = ru(M, ESP - 7245812)
EDX = ru(M, band(EAX + 12) - 7245824)
ECX = ru(M, band(ECX) - 7245824)
wu(M, band(EDX) - 7245824, ECX)
ECX = ru(M, ESP - 7245812)
EDX = ru(M, band(EAX + 16) - 7245824)
ECX = ru(M, band(ECX + 4) - 7245824)
wu(M, band(EDX) - 7245824, ECX)
EDX = ru(M, band(EAX + 20) - 7245824)
EAX = ru(M, ESP - 7245812)
ECX = ru(M, band(EAX + 8) - 7245824)
wu(M, band(EDX) - 7245824, ECX)
ESP = ESP + 16
ESP = ESP + 4
do return end
end
end
end
XF[0x560dd0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
EAX = ru(M, ESP - 7245816)
s0 = rf(M, band(EAX + 8) - 7245824)
s0 = s0 * rf(M, 52456)
ECX = ru(M, band(EAX + 4) - 7245824)
EAX = ru(M, band(EAX) - 7245824)
wu(M, ESP - 7245824, ECX)
wfd(ESP - 7245816, s0)
EDX = ru(M, ESP - 7245816)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x51a000]()
ECX = EAX
ESP = ESP - 4
XF[0x51a870]()
ECX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 4
do return end
end
end
end
XF[0x561040] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ECX = ru(M, ESP - 7245820)
s0 = rf(M, band(ECX + 8) - 7245824)
FSW = fcmp(s0, rf(M, 5204))
s0 = rf(M, band(ECX + 8) - 7245824)
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 4 else pc = 1 end
elseif pc == 1 then
s0 = -s0
FSW = fcmp(s0, rf(M, band(ECX + 4) - 7245824))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 3 else pc = 2 end
elseif pc == 2 then
EAX = ru(M, band(ECX) - 7245824)
wfd(band(EAX) - 7245824, s0)
ESP = ESP + 4
do return end
elseif pc == 3 then
EDX = ru(M, band(ECX) - 7245824)
EAX = ru(M, band(ECX + 4) - 7245824)
wu(M, band(EDX) - 7245824, EAX)
ESP = ESP + 4
do return end
elseif pc == 4 then
FSW = fcmp(s0, rf(M, band(ECX + 4) - 7245824))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 6 else pc = 5 end
elseif pc == 5 then
s0 = rf(M, band(ECX + 8) - 7245824)
ECX = ru(M, band(ECX) - 7245824)
s0 = -s0
wfd(band(ECX) - 7245824, s0)
ESP = ESP + 4
do return end
elseif pc == 6 then
s0 = rf(M, band(ECX + 4) - 7245824)
EDX = ru(M, band(ECX) - 7245824)
s0 = -s0
wfd(band(EDX) - 7245824, s0)
ESP = ESP + 4
do return end
end
end
end
XF[0x5614b0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 8
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ESI = ru(M, ESP - 7245808)
s0 = rf(M, band(ESI + 12) - 7245824)
FSW = fcmp(s0, rf(M, 16416))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 2 else pc = 1 end
elseif pc == 1 then
EAX = ru(M, band(ESI + 4) - 7245824)
wu(M, ESP - 7245808, EAX)
pc = 3
elseif pc == 2 then
s0 = rf(M, band(ESI + 8) - 7245824)
s0 = s0 + rf(M, band(ESI + 4) - 7245824)
wfd(ESP - 7245808, s0)
pc = 3
elseif pc == 3 then
s0 = rf(M, band(ESI + 16) - 7245824)
FT = FT + 1; F[FT] = s0
ESP = ESP - 4
B_ftol()
ECX = ru(M, band(EAX*4 + 12617440) - 7245824)
do local r = band(band(ECX, ECX), 4294967295)
FZ = r == 0
end
ECX = 12604864
if not FZ then pc = 5 else pc = 4 end
elseif pc == 4 then
EAX = band(EAX + 102)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x557d60]()
ECX = ru(M, band(EAX) - 7245824)
wu(M, ESP - 7245820, ECX)
pc = 6
elseif pc == 5 then
ESP = ESP - 4; wu(M, ESP - 7245824, 103)
ESP = ESP - 4
XF[0x557d60]()
EDX = ru(M, band(EAX) - 7245824)
wu(M, ESP - 7245820, EDX)
pc = 6
elseif pc == 6 then
ESP = ESP - 4; wu(M, ESP - 7245824, 110)
ECX = 12604864
ESP = ESP - 4
XF[0x557d60]()
s0 = rf(M, ESP - 7245820)
s0 = s0 * rf(M, band(EAX) - 7245824)
ECX = 12604864
s0 = s0 * rf(M, ESP - 7245808)
wfd(ESP - 7245808, s0)
FSW = fcmp(s0, rf(M, 5204))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 8 else pc = 7 end
elseif pc == 7 then
ESP = ESP - 4; wu(M, ESP - 7245824, 163)
ESP = ESP - 4
XF[0x557d60]()
s0 = rf(M, ESP - 7245808)
s0 = s0 * rf(M, band(EAX) - 7245824)
s0 = -s0
pc = 9
elseif pc == 8 then
ESP = ESP - 4; wu(M, ESP - 7245824, 164)
ESP = ESP - 4
XF[0x557d60]()
s0 = rf(M, ESP - 7245808)
s0 = s0 * rf(M, band(EAX) - 7245824)
pc = 9
elseif pc == 9 then
EAX = ru(M, band(ESI + 20) - 7245824)
wfd(ESP - 7245808, s0)
wu(M, ESP - 7245820, EAX)
EAX = ru(M, ESP - 7245820)
EAX = band(band(EAX, 2147483647), 4294967295)
wu(M, ESP - 7245816, EAX)
s0 = rf(M, 2008)
s0 = s0 / rf(M, 415840)
s0 = s0 * rf(M, ESP - 7245816)
s0 = rf(M, 2008) - s0
s0 = s0 * rf(M, ESP - 7245808)
FSW = fcmp(s0, rf(M, 5204))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 11 else pc = 10 end
elseif pc == 10 then
s0 = rf(M, 5204)
pc = 11
elseif pc == 11 then
ECX = ru(M, band(ESI) - 7245824)
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
wfd(band(ECX) - 7245824, s0)
ESP = ESP + 8
ESP = ESP + 4
do return end
end
end
end
XF[0x5618d0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ECX = ru(M, ESP - 7245816)
s0 = rf(M, band(ECX + 8) - 7245824)
FSW = fcmp(s0, rf(M, 5371296))
EAX = ru(M, band(ECX + 12) - 7245824)
EDX = ru(M, band(ECX + 20) - 7245824)
wu(M, ESP - 7245816, EAX)
wu(M, ESP - 7245824, EDX)
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 2 else pc = 1 end
elseif pc == 1 then
s1 = rf(M, 5371296)
s1 = s1 - s0
EAX = ru(M, band(ECX) - 7245824)
s1 = s1 * rf(M, 52468)
s2 = rf(M, band(ECX + 16) - 7245824)
s2 = s2 * rf(M, 52464)
s1 = s1 - s2
wfd(band(EAX) - 7245824, s1)
pc = 3
elseif pc == 2 then
EDX = ru(M, band(ECX) - 7245824)
wu(M, band(EDX) - 7245824, 0)
pc = 3
elseif pc == 3 then
s0 = rf(M, ESP - 7245816)
FSW = fcmp(s0, rf(M, 5370344))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 5 else pc = 4 end
elseif pc == 4 then
s0 = rf(M, 5370344)
s0 = s0 - rf(M, ESP - 7245816)
EAX = ru(M, band(ECX + 4) - 7245824)
s0 = s0 * rf(M, 52468)
s1 = rf(M, ESP - 7245824)
s1 = s1 * rf(M, 52464)
s0 = s0 - s1
wfd(band(EAX) - 7245824, s0)
ECX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 4
do return end
elseif pc == 5 then
ECX = ru(M, band(ECX + 4) - 7245824)
wu(M, band(ECX) - 7245824, 0)
ECX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 4
do return end
end
end
end
XF[0x561a80] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 12
ESP = ESP - 4
XF[0x55ab00]()
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x562f70]()
EAX = ru(M, band(EAX + 1454) - 7245824)
ESP = ESP + 4
do local r = band(band(EAX, EAX), 4294967295)
FZ = r == 0
end
if FZ then pc = 2 else pc = 1 end
elseif pc == 1 then
s0 = rf(M, 7481412)
s0 = s0 * rf(M, band(EAX + 40) - 7245824)
s1 = rf(M, 7481416)
s1 = s1 * rf(M, band(EAX + 44) - 7245824)
s0 = s0 + s1
s1 = rf(M, 7481408)
s1 = s1 * rf(M, band(EAX + 36) - 7245824)
s0 = s0 + s1
s1 = s0
s1 = s1 * rf(M, band(EAX + 36) - 7245824)
s2 = s0
s2 = s2 * rf(M, band(EAX + 40) - 7245824)
wfd(ESP - 7245820, s2)
s1, s0 = s0, s1
s1 = s1 * rf(M, band(EAX + 44) - 7245824)
EAX = ru(M, 413844)
wfd(ESP - 7245816, s1)
s0 = rf(M, 7481408) - s0
s1 = rf(M, 7481412)
s1 = s1 - rf(M, ESP - 7245820)
s2 = rf(M, 7481416)
s2 = s2 - rf(M, ESP - 7245816)
wfd(ESP - 7245816, s2)
s1, s0 = s0, s1
s1 = s1 * rf(M, 5196)
wfd(band(EAX) - 7245824, s1)
ECX = ru(M, 413848)
s0 = s0 * rf(M, 5196)
wfd(band(ECX) - 7245824, s0)
s0 = rf(M, ESP - 7245816)
s0 = s0 * rf(M, 5196)
EDX = ru(M, 413852)
wfd(band(EDX) - 7245824, s0)
ESP = ESP + 12
ESP = ESP + 4
do return end
elseif pc == 2 then
s0 = rf(M, 7481408)
s0 = s0 * rf(M, 5196)
EAX = ru(M, 413844)
wfd(band(EAX) - 7245824, s0)
s0 = rf(M, 7481412)
s0 = s0 * rf(M, 5196)
ECX = ru(M, 413848)
wfd(band(ECX) - 7245824, s0)
s0 = rf(M, 7481416)
s0 = s0 * rf(M, 5196)
EDX = ru(M, 413852)
wfd(band(EDX) - 7245824, s0)
ESP = ESP + 12
ESP = ESP + 4
do return end
end
end
end
XF[0x561b70] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 64
ESP = ESP - 4; wu(M, ESP - 7245824, EBX)
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
ESP = ESP - 4
XF[0x55ab00]()
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x562f70]()
ESI = ru(M, ESP - 7245736)
EDI = ru(M, band(EAX + 1418) - 7245824)
ESP = ESP + 4
s0 = rf(M, band(ESI + 24) - 7245824)
s1 = rf(M, band(ESI + 28) - 7245824)
s2 = s1
s2 = s2 * s1
ECX = ru(M, band(ESI + 32) - 7245824)
EDX = ru(M, band(ESI + 36) - 7245824)
wu(M, ESP - 7245760, ECX)
ECX = ru(M, band(ESI + 40) - 7245824)
wu(M, ESP - 7245792, EDX)
EDX = ru(M, band(ESI + 44) - 7245824)
wfd(ESP - 7245804, s2)
s2 = s0
s2 = s2 * s0
wu(M, ESP - 7245788, ECX)
ECX = ru(M, band(EAX + 1446) - 7245824)
wu(M, ESP - 7245784, EDX)
EDX = ru(M, band(EAX + 1442) - 7245824)
EAX = ru(M, band(EAX + 1438) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
wfd(ESP - 7245804, s2)
s2 = rf(M, ESP - 7245756)
s2 = s2 * rf(M, ESP - 7245756)
ECX = ru(M, 5370640)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
EAX = ru(M, 5371072)
s2 = s2 + rf(M, ESP - 7245796)
EDX = ru(M, band(ECX + 725) - 7245824)
ECX = ru(M, band(EAX + 725) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
EAX = band(ESP + 60)
s2 = s2 + rf(M, ESP - 7245788)
s2 = s2 * rf(M, 7481420)
s2 = s2 * rf(M, 5196)
wfd(ESP - 7245784, s2)
s2 = s2 * rf(M, band(EDI + 160) - 7245824)
EBX = ru(M, ESP - 7245784)
wfd(ESP - 7245724, s2)
s1, s0 = s0, s1
s0 = atan2(s0, s1)
wfd(ESP - 7245780, s0)
s0 = rf(M, ESP - 7245744)
s0 = -s0
s1 = rf(M, ESP - 7245792)
s1 = s1 + rf(M, ESP - 7245788)
EBP = ru(M, ESP - 7245780)
s1 = sqrt(s1)
s0 = atan2(s0, s1)
s0 = s0 + rf(M, 5370820)
wfd(ESP - 7245788, s0)
s0 = rf(M, band(EDX) - 7245824)
s0 = rf(M, 5371084) - s0
s1 = rf(M, band(ECX) - 7245824)
s1 = rf(M, 5371080) - s1
EDX = ru(M, ESP - 7245788)
s0 = s0 + s1
s0 = s0 * rf(M, 5196)
wfd(ESP - 7245824, s0)
ESP = ESP - 4; wu(M, ESP - 7245824, EBX)
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ECX = band(ESP + 104)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ESP = ESP - 4
XF[0x410280]()
EAX = ru(M, 413840)
ESP = ESP + 40
do local a = EAX; local r = band(a - 1, 4294967295)
FZ = r == 0
EAX = r
end
wu(M, 413840, EAX)
if not FZ then pc = 2 else pc = 1 end
elseif pc == 1 then
s0 = rf(M, 421236)
s0 = s0 * rf(M, 5672)
EDX = ru(M, ESP - 7245804)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
wfd(ESP - 7245824, s0)
ESP = ESP - 4; wu(M, ESP - 7245824, EBX)
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
ESP = ESP - 4
XF[0x410b50]()
ESP = ESP + 20
wu(M, 413840, 16)
pc = 2
elseif pc == 2 then
s0 = rf(M, ESP - 7245784)
s0 = s0 * rf(M, ESP - 7245784)
s1 = rf(M, ESP - 7245788)
s1 = s1 * rf(M, ESP - 7245788)
s0 = s0 + s1
s1 = rf(M, ESP - 7245792)
s1 = s1 * rf(M, ESP - 7245792)
s0 = s0 + s1
s0 = sqrt(s0)
FSW = fcmp(s0, rf(M, 5324))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 4 else pc = 3 end
elseif pc == 3 then
s0 = rf(M, 2008) / s0
pc = 5
elseif pc == 4 then
s0 = rf(M, 5240)
pc = 5
elseif pc == 5 then
s0 = s0 * rf(M, 52472)
s1 = rf(M, ESP - 7245792)
EAX = ru(M, band(ESI) - 7245824)
s1 = s1 * s0
s2 = s0
s2 = s2 * rf(M, ESP - 7245788)
wfd(ESP - 7245764, s2)
s1, s0 = s0, s1
s1 = s1 * rf(M, ESP - 7245784)
wfd(ESP - 7245760, s1)
s1 = rf(M, ESP - 7245780)
s1 = s1 + s0
wfd(ESP - 7245780, s1)
s0 = rf(M, ESP - 7245776)
s0 = s0 + rf(M, ESP - 7245764)
wfd(ESP - 7245776, s0)
s0 = rf(M, ESP - 7245772)
s0 = s0 + rf(M, ESP - 7245760)
wfd(ESP - 7245772, s0)
s0 = rf(M, ESP - 7245756)
s0 = s0 * rf(M, ESP - 7245740)
wfd(band(EAX) - 7245824, s0)
s0 = rf(M, ESP - 7245752)
s0 = s0 * rf(M, ESP - 7245740)
ECX = ru(M, band(ESI + 4) - 7245824)
wfd(band(ECX) - 7245824, s0)
s0 = rf(M, ESP - 7245748)
s0 = s0 * rf(M, ESP - 7245740)
EDX = ru(M, band(ESI + 8) - 7245824)
wfd(band(EDX) - 7245824, s0)
s0 = rf(M, ESP - 7245740)
s0 = s0 * rf(M, band(EDI + 164) - 7245824)
s1 = rf(M, ESP - 7245780)
EAX = ru(M, band(ESI + 12) - 7245824)
EDI = ru(M, ESP - 7245824); ESP = ESP + 4
s1 = s1 * s0
wfd(band(EAX) - 7245824, s1)
s1 = rf(M, ESP - 7245780)
ECX = ru(M, band(ESI + 16) - 7245824)
s1 = s1 * s0
wfd(band(ECX) - 7245824, s1)
s1 = rf(M, ESP - 7245776)
EDX = ru(M, band(ESI + 20) - 7245824)
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
s1 = s1 * s0
EBP = ru(M, ESP - 7245824); ESP = ESP + 4
EBX = ru(M, ESP - 7245824); ESP = ESP + 4
wfd(band(EDX) - 7245824, s1)
ESP = ESP + 64
ESP = ESP + 4
do return end
end
end
end
XF[0x561e50] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 56
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ESI = ru(M, ESP - 7245760)
EAX = ru(M, band(ESI) - 7245824)
wu(M, band(EAX) - 7245824, 0)
ECX = ru(M, band(ESI + 4) - 7245824)
wu(M, band(ECX) - 7245824, 0)
EDX = ru(M, band(ESI + 8) - 7245824)
wu(M, band(EDX) - 7245824, 0)
EAX = ru(M, band(ESI + 12) - 7245824)
wu(M, band(EAX) - 7245824, 0)
ECX = ru(M, band(ESI + 16) - 7245824)
wu(M, band(ECX) - 7245824, 0)
EDX = ru(M, band(ESI + 20) - 7245824)
wu(M, band(EDX) - 7245824, 0)
wu(M, 5371564, 0)
s0 = rf(M, 5300012)
FSW = fcmp(s0, rf(M, 2008))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 2 else pc = 1 end
elseif pc == 1 then
do local a, b = ru(M, 5300008), 15
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FZ = r == 0
FS = band(r, 2147483648) ~= 0
end
if (not FZ and FS == FO) then pc = 3 else pc = 2 end
elseif pc == 2 then
ESP = ESP - 4
XF[0x5501d0]()
do local r = band(band(band(EAX, 0xff), band(EAX, 0xff)), 255)
FZ = r == 0
end
if FZ then pc = 31 else pc = 3 end
elseif pc == 3 then
EDX = ru(M, band(ESI + 32) - 7245824)
ECX = ru(M, band(ESI + 28) - 7245824)
wu(M, ESP - 7245780, EDX)
EAX = ru(M, band(ESI + 24) - 7245824)
s0 = rf(M, ESP - 7245780)
s0 = s0 * rf(M, ESP - 7245780)
wu(M, ESP - 7245784, ECX)
wu(M, ESP - 7245788, EAX)
s1 = rf(M, ESP - 7245784)
s1 = s1 * rf(M, ESP - 7245784)
EAX = band(ESP + 36)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
s0 = s0 + s1
s1 = rf(M, ESP - 7245784)
s1 = s1 * rf(M, ESP - 7245784)
s0 = s0 + s1
wfd(ESP - 7245756, s0)
ESP = ESP - 4
XF[0x5f6a70]()
s0 = rf(M, 5300012)
FSW = fcmp(s0, rf(M, 2008))
ESP = ESP + 4
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 6 else pc = 4 end
elseif pc == 4 then
EAX = ru(M, 5300008)
do local a, b = EAX, 15
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FZ = r == 0
FS = band(r, 2147483648) ~= 0
end
if (FZ or FS ~= FO) then pc = 6 else pc = 5 end
elseif pc == 5 then
EAX = band(EAX + 4294967281)
wu(M, ESP - 7245800, EAX)
EAX = ru(M, band(ESI) - 7245824)
s0 = ri(M, ESP - 7245800)
s1 = rf(M, 5300012)
s1 = s1 - rf(M, 2008)
s0 = s0 * s1
s0 = s0 * rf(M, 18148)
s1 = rf(M, ESP - 7245788)
s1 = s1 * s0
s2 = s0
s2 = s2 * rf(M, ESP - 7245784)
wfd(ESP - 7245772, s2)
s1, s0 = s0, s1
s1 = s1 * rf(M, ESP - 7245780)
wfd(ESP - 7245768, s1)
s0 = s0 + rf(M, band(EAX) - 7245824)
wfd(band(EAX) - 7245824, s0)
EAX = ru(M, band(ESI + 4) - 7245824)
s0 = rf(M, ESP - 7245772)
s0 = s0 + rf(M, band(EAX) - 7245824)
wfd(band(EAX) - 7245824, s0)
EAX = ru(M, band(ESI + 8) - 7245824)
s0 = rf(M, ESP - 7245768)
s0 = s0 + rf(M, band(EAX) - 7245824)
wfd(band(EAX) - 7245824, s0)
pc = 6
elseif pc == 6 then
ESP = ESP - 4
XF[0x5501d0]()
do local r = band(band(band(EAX, 0xff), band(EAX, 0xff)), 255)
FZ = r == 0
end
if FZ then pc = 31 else pc = 7 end
elseif pc == 7 then
s0 = rf(M, 413388)
s0 = s0 * rf(M, 413388)
FSW = fcmp(s0, rf(M, ESP - 7245760))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 31 else pc = 8 end
elseif pc == 8 then
s0 = rf(M, ESP - 7245760)
s0 = sqrt(s0)
wfd(ESP - 7245760, s0)
s0 = rf(M, 5204)
s1 = rf(M, ESP - 7245760)
FSW = fcmp(s1, rf(M, 413396))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 10 else pc = 9 end
elseif pc == 9 then
s0 = rf(M, 2008)
pc = 12
elseif pc == 10 then
s1 = rf(M, ESP - 7245760)
FSW = fcmp(s1, rf(M, 413392))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 12 else pc = 11 end
elseif pc == 11 then
s0 = rf(M, ESP - 7245760)
s0 = s0 - rf(M, 413392)
s1 = rf(M, 413396)
s1 = s1 - rf(M, 413392)
s0 = s0 / s1
pc = 12
elseif pc == 12 then
s1 = rf(M, 2008)
s1 = s1 - s0
s2 = rf(M, 413408)
wu(M, ESP - 7245760, 0)
s2 = s2 * s1
s3 = rf(M, 413412)
s3 = s3 * s0
s2 = s2 + s3
wfd(ESP - 7245808, s2)
s2 = rf(M, 413416)
s2 = s2 * s1
s3 = rf(M, 413420)
s3 = s3 * s0
s2 = s2 + s3
wfd(ESP - 7245812, s2)
s2 = rf(M, 413400)
s2 = s2 * s1
s3 = rf(M, 413404)
s3 = s3 * s0
s2 = s2 + s3
wfd(ESP - 7245820, s2)
s2 = rf(M, 5371556)
s2 = s2 * s1
s3 = rf(M, 5371560)
s3 = s3 * s0
s2 = s2 + s3
wfd(ESP - 7245804, s2)
s2 = rf(M, 413432)
s2 = s2 * s1
s3 = rf(M, 413436)
s3 = s3 * s0
s2 = s2 + s3
wfd(ESP - 7245800, s2)
s2 = rf(M, 413424)
s2 = s2 * s1
s3 = rf(M, 413428)
s3 = s3 * s0
s2 = s2 + s3
wfd(ESP - 7245816, s2)
s2 = rf(M, 413440)
s2 = s2 * s1
s3 = rf(M, 413444)
s3 = s3 * s0
s2 = s2 + s3
wfd(ESP - 7245796, s2)
s1 = s1 * rf(M, 413448)
s2 = rf(M, 413452)
s2 = s2 * s0
s1 = s1 + s2
wfd(ESP - 7245792, s1)
s0 = rf(M, ESP - 7245784)
s1 = rf(M, ESP - 7245788)
s0 = atan2(s0, s1)
FSW = fcmp(s0, rf(M, 51660))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 14 else pc = 13 end
elseif pc == 13 then
s0 = rf(M, 47688) - s0
pc = 14
elseif pc == 14 then
FSW = fcmp(s0, rf(M, 21632))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 16 else pc = 15 end
elseif pc == 15 then
s0 = rf(M, 47692) - s0
pc = 16
elseif pc == 16 then
s1 = rf(M, ESP - 7245820)
s1 = -s1
s2 = s0
FSW = fcmp(s2, s1)
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 19 else pc = 17 end
elseif pc == 17 then
s1 = rf(M, ESP - 7245820)
s1 = s1 + s0
s1 = s1 * rf(M, ESP - 7245808)
wfd(ESP - 7245760, s1)
s1 = rf(M, ESP - 7245812)
s1 = -s1
s2 = rf(M, ESP - 7245760)
FSW = fcmp(s2, s1)
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 22 else pc = 18 end
elseif pc == 18 then
wfd(ESP - 7245760, s1)
pc = 23
elseif pc == 19 then
FSW = fcmp(s0, rf(M, ESP - 7245820))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 23 else pc = 20 end
elseif pc == 20 then
s1 = rf(M, ESP - 7245820)
s1 = s0 - s1
s1 = s1 * rf(M, ESP - 7245808)
wfd(ESP - 7245760, s1)
FSW = fcmp(s1, rf(M, ESP - 7245812))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 23 else pc = 21 end
elseif pc == 21 then
ECX = ru(M, ESP - 7245812)
wu(M, ESP - 7245760, ECX)
pc = 23
elseif pc == 22 then
pc = 23
elseif pc == 23 then
s1 = rf(M, ESP - 7245816)
s1 = -s1
s2 = s0
FSW = fcmp(s2, s1)
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 25 else pc = 24 end
elseif pc == 24 then
s0 = s0 + rf(M, ESP - 7245816)
s0 = s0 * rf(M, ESP - 7245804)
s0 = -s0
wfd(5371564, s0)
pc = 28
elseif pc == 25 then
FSW = fcmp(s0, rf(M, ESP - 7245816))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 27 else pc = 26 end
elseif pc == 26 then
s0 = s0 - rf(M, ESP - 7245816)
s0 = s0 * rf(M, ESP - 7245804)
wfd(5371564, s0)
pc = 28
elseif pc == 27 then
pc = 28
elseif pc == 28 then
EDX = ru(M, ESP - 7245760)
wu(M, ESP - 7245804, EDX)
EAX = ru(M, ESP - 7245804)
EAX = band(band(EAX, 2147483647), 4294967295)
wu(M, ESP - 7245808, EAX)
s0 = rf(M, ESP - 7245808)
s0 = s0 * rf(M, ESP - 7245796)
s0 = s0 + rf(M, 5371564)
wfd(5371564, s0)
FSW = fcmp(s0, rf(M, ESP - 7245800))
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(band(rshift(EAX, 8), 0xff), 5), 255)
FP = PAR[band(r, 0xff)]
end
if FP then pc = 30 else pc = 29 end
elseif pc == 29 then
EAX = ru(M, ESP - 7245800)
wu(M, 5371564, EAX)
pc = 30
elseif pc == 30 then
ECX = ru(M, 5371564)
wu(M, ESP - 7245796, ECX)
EAX = ru(M, ESP - 7245796)
EAX = band(band(EAX, 2147483647), 4294967295)
wu(M, ESP - 7245800, EAX)
s0 = rf(M, 5371564)
s1 = rf(M, ESP - 7245788)
s1 = s1 * s0
s2 = s0
s2 = s2 * rf(M, ESP - 7245784)
EAX = ru(M, band(ESI) - 7245824)
wfd(ESP - 7245772, s2)
s1, s0 = s0, s1
s1 = s1 * rf(M, ESP - 7245780)
wfd(ESP - 7245768, s1)
s0 = s0 + rf(M, band(EAX) - 7245824)
wfd(band(EAX) - 7245824, s0)
EAX = ru(M, band(ESI + 4) - 7245824)
s0 = rf(M, ESP - 7245772)
s0 = s0 + rf(M, band(EAX) - 7245824)
wfd(band(EAX) - 7245824, s0)
s0 = rf(M, ESP - 7245800)
EAX = ru(M, band(ESI + 8) - 7245824)
s0 = s0 * rf(M, ESP - 7245792)
s0 = s0 + rf(M, band(EAX) - 7245824)
s0 = s0 + rf(M, ESP - 7245768)
wfd(band(EAX) - 7245824, s0)
ESI = ru(M, band(ESI + 20) - 7245824)
s0 = rf(M, ESP - 7245760)
s0 = s0 + rf(M, band(ESI) - 7245824)
wfd(band(ESI) - 7245824, s0)
pc = 31
elseif pc == 31 then
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 56
ESP = ESP + 4
do return end
end
end
end
XF[0x562f70] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ECX = ru(M, ESP - 7245820)
EAX = band(ECX + ECX*2)
do local n = band(3, 31)
if n ~= 0 then local a = EAX
FC = band(rshift(a, 32 - n), 1) ~= 0
local r = band(lshift(a, n), 4294967295)
FR = r; FZ = r == 0; FS = band(r, 2147483648) ~= 0; FP = PAR[band(r, 0xff)]; FO = false
EAX = r
end end
EAX = band(EAX - ECX)
EAX = band(EAX + EAX*2)
EAX = band(ECX + EAX*2)
ECX = band(EAX + EAX*4)
EAX = band(ECX*8 + 12656688)
ESP = ESP + 4
do return end
end
end
end
XF[0x565830] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
EAX = ru(M, band(EAX*4 + 7298436) - 7245824)
ESP = ESP + 4
do return end
end
end
end
XF[0x566aa0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ESP = ESP - 4
XF[0x592db0]()
ESP = ESP + 4
ESP = ESP + 4
do return end
end
end
end
XF[0x5677d1] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ESP = ESP - 4; wu(M, ESP - 7245824, EBP)
EBP = ESP
ESP = ESP - 4
ESP = ESP - 4; wu(M, ESP - 7245824, EDX)
EAX = ru(M, EBP - 7245816)
s0 = rf(M, EBP - 7245812)
s0 = s0 - rf(M, band(EAX) - 7245824)
s0 = s0 * rf(M, band(EAX + 4) - 7245824)
wi(M, EBP - 7245828, fistround(s0))
EDX = ru(M, EBP - 7245828)
do local r = band(bor(EDX, EDX), 4294967295)
FS = band(r, 2147483648) ~= 0
EDX = r
end
if not FS then pc = 2 else pc = 1 end
elseif pc == 1 then
s1 = 0
EDX = 0
pc = 5
elseif pc == 2 then
do local a, b = EDX, ru(M, band(EAX + 8) - 7245824)
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FZ = r == 0
FS = band(r, 2147483648) ~= 0
end
if (FZ or FS ~= FO) then pc = 4 else pc = 3 end
elseif pc == 3 then
s1 = ri(M, band(EAX + 8) - 7245824)
EDX = ru(M, band(EAX + 8) - 7245824)
pc = 5
elseif pc == 4 then
s1 = ri(M, EBP - 7245828)
pc = 5
elseif pc == 5 then
s0 = s0 - s1
s1 = rf(M, band(EAX + EDX*4 + 16) - 7245824)
s1 = s1 - rf(M, band(EAX + EDX*4 + 12) - 7245824)
s0 = s0 * s1
s0 = s0 + rf(M, band(EAX + EDX*4 + 12) - 7245824)
EDX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = EBP
EBP = ru(M, ESP - 7245824); ESP = ESP + 4
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
end
end
end
XF[0x577260] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
ECX = ru(M, ESP - 7245816)
w8b(M, 6087416, band(1, 0xff))
wu(M, 5855116, EAX)
wu(M, 5855120, ECX)
ESP = ESP + 4
do return end
end
end
end
XF[0x579e80] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
ECX = ru(M, ESP - 7245816)
EAX = band(EAX + EAX*4 + -85)
EDX = band(ECX + EAX*4)
s0 = rf(M, band(EDX*4 + 13851160) - 7245824)
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
end
end
end
XF[0x579ea0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
ECX = ru(M, ESP - 7245816)
EAX = band(EAX + EAX*4 + -85)
EDX = band(ECX + EAX*4)
s0 = rf(M, band(EDX*4 + 13850920) - 7245824)
FT = FT + 1; F[FT] = s0
ESP = ESP + 4
do return end
end
end
end
XF[0x57af60] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
EDX = 0
ECX = band(EAX*8)
ECX = band(ECX - EAX)
ESI = ru(M, band(EAX + ECX*4 + 13860040) - 7245824)
do local a, b = ESI, 1
local r = a - b
r = band(r)
FZ = r == 0
end
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
EDX = bor(band(EDX, 0xffffff00), band((not FZ) and 1 or 0, 0xff))
EAX = bor(band(EAX, 0xffffff00), band(band(EDX, 0xff), 0xff))
ESP = ESP + 4
do return end
end
end
end
XF[0x592db0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
EAX = band(EAX + 5267)
ESP = ESP + 4
do return end
end
end
end
XF[0x5b2b90] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ECX = ru(M, ESP - 7245816)
EAX = 15221876
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
pc = 1
elseif pc == 1 then
EDX = ru(M, band(EAX) - 7245824)
ESI = ru(M, band(ECX) - 7245824)
EAX = band(EAX + 4)
ECX = band(ECX + 4)
do local a, b = EAX, 15221912
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FS = band(r, 2147483648) ~= 0
end
wu(M, band(EDX) - 7245824, ESI)
if (FS ~= FO) then pc = 1 else pc = 2 end
elseif pc == 2 then
EAX = ru(M, 7976264)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
B_callback()
ECX = ru(M, 7976088)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ESP = ESP - 4
B_callback()
ESP = ESP + 8
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 4
do return end
end
end
end
XF[0x5b2bd0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, 7977948)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
B_callback()
ECX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 4
do return end
end
end
end
XF[0x5b2be0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, 7977888)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
B_callback()
ECX = ru(M, 7976088)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
ESP = ESP - 4
B_callback()
ESP = ESP + 8
ESP = ESP + 4
do return end
end
end
end
XF[0x5b2c00] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, 7976452)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
B_callback()
ECX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 4
do return end
end
end
end
XF[0x5b2cb0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ECX = ru(M, ESP - 7245816)
EAX = ru(M, ESP - 7245820)
ESP = ESP - 4; wu(M, ESP - 7245824, ECX)
wu(M, 7976904, EAX)
ESP = ESP - 4
XF[0x5b2cd0]()
ECX = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 4
do return end
end
end
end
XF[0x5b2cd0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
ECX = ru(M, band(EAX + 64) - 7245824)
do local r = band(band(band(ECX, 0xff), 1), 255)
FZ = r == 0
end
if not FZ then pc = 2 else pc = 1 end
elseif pc == 1 then
do local n = band(7, 31)
if n ~= 0 then local a = ECX
FC = band(rshift(a, n - 1), 1) ~= 0
local r = band(arshift(a, n), 4294967295)
FR = r; FZ = r == 0; FS = band(r, 2147483648) ~= 0; FP = PAR[band(r, 0xff)]; FO = false
ECX = r
end end
ECX = band(band(ECX, 7), 4294967295)
do local a = ECX; local r = band(a - 1, 4294967295)
FZ = r == 0
ECX = r
end
if not FZ then pc = 3 else pc = 2 end
elseif pc == 2 then
ECX = ru(M, band(EAX + 717) - 7245824)
EDX = ru(M, band(ECX) - 7245824)
ECX = ru(M, 7976904)
wu(M, band(ECX) - 7245824, EDX)
ECX = ru(M, 7976904)
ECX = band(ECX + 4)
wu(M, 7976904, ECX)
EDX = ru(M, band(EAX + 901) - 7245824)
EDX = ru(M, band(EDX) - 7245824)
wu(M, band(ECX) - 7245824, EDX)
ECX = ru(M, 7976904)
ECX = band(ECX + 4)
wu(M, 7976904, ECX)
pc = 4
elseif pc == 3 then
ECX = ru(M, 7976904)
pc = 4
elseif pc == 4 then
EDX = ru(M, band(EAX + 64) - 7245824)
do local r = band(band(band(EDX, 0xff), 2), 255)
FZ = r == 0
end
if not FZ then pc = 6 else pc = 5 end
elseif pc == 5 then
do local n = band(7, 31)
if n ~= 0 then local a = EDX
FC = band(rshift(a, n - 1), 1) ~= 0
local r = band(arshift(a, n), 4294967295)
FR = r; FZ = r == 0; FS = band(r, 2147483648) ~= 0; FP = PAR[band(r, 0xff)]; FO = false
EDX = r
end end
EDX = band(band(EDX, 7), 4294967295)
do local a = EDX; local r = band(a - 1, 4294967295)
EDX = r
end
do local a, b = EDX, 1
local r = a - b
r = band(r)
FZ = r == 0
end
if not FZ then pc = 7 else pc = 6 end
elseif pc == 6 then
EDX = ru(M, band(EAX + 721) - 7245824)
EDX = ru(M, band(EDX) - 7245824)
wu(M, band(ECX) - 7245824, EDX)
ECX = ru(M, 7976904)
ECX = band(ECX + 4)
wu(M, 7976904, ECX)
EDX = ru(M, band(EAX + 905) - 7245824)
EDX = ru(M, band(EDX) - 7245824)
wu(M, band(ECX) - 7245824, EDX)
ECX = ru(M, 7976904)
ECX = band(ECX + 4)
wu(M, 7976904, ECX)
pc = 7
elseif pc == 7 then
EDX = ru(M, band(EAX + 64) - 7245824)
do local r = band(band(band(EDX, 0xff), 4), 255)
FZ = r == 0
end
if not FZ then pc = 9 else pc = 8 end
elseif pc == 8 then
do local n = band(7, 31)
if n ~= 0 then local a = EDX
FC = band(rshift(a, n - 1), 1) ~= 0
local r = band(arshift(a, n), 4294967295)
FR = r; FZ = r == 0; FS = band(r, 2147483648) ~= 0; FP = PAR[band(r, 0xff)]; FO = false
EDX = r
end end
EDX = band(band(EDX, 7), 4294967295)
do local a = EDX; local r = band(a - 1, 4294967295)
EDX = r
end
do local a, b = EDX, 2
local r = a - b
r = band(r)
FZ = r == 0
end
if not FZ then pc = 10 else pc = 9 end
elseif pc == 9 then
EDX = ru(M, band(EAX + 725) - 7245824)
EDX = ru(M, band(EDX) - 7245824)
wu(M, band(ECX) - 7245824, EDX)
ECX = ru(M, 7976904)
ECX = band(ECX + 4)
wu(M, 7976904, ECX)
EDX = ru(M, band(EAX + 909) - 7245824)
EDX = ru(M, band(EDX) - 7245824)
wu(M, band(ECX) - 7245824, EDX)
ECX = ru(M, 7976904)
ECX = band(ECX + 4)
wu(M, 7976904, ECX)
pc = 10
elseif pc == 10 then
EDX = ru(M, band(EAX + 64) - 7245824)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ESI = EDX
do local n = band(7, 31)
if n ~= 0 then local a = ESI
FC = band(rshift(a, n - 1), 1) ~= 0
local r = band(arshift(a, n), 4294967295)
FR = r; FZ = r == 0; FS = band(r, 2147483648) ~= 0; FP = PAR[band(r, 0xff)]; FO = false
ESI = r
end end
ESI = band(band(ESI, 7), 4294967295)
do local a = ESI; local r = band(a - 1, 4294967295)
ESI = r
end
do local a, b = ESI, 2
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FZ = r == 0
FS = band(r, 2147483648) ~= 0
end
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
if (FZ or FS ~= FO) then pc = 12 else pc = 11 end
elseif pc == 11 then
EDX = ru(M, band(EAX + 861) - 7245824)
EDX = ru(M, band(EDX) - 7245824)
wu(M, band(ECX) - 7245824, EDX)
ECX = ru(M, 7976904)
ECX = band(ECX + 4)
wu(M, 7976904, ECX)
EDX = ru(M, band(EAX + 64) - 7245824)
do local n = band(7, 31)
if n ~= 0 then local a = EDX
FC = band(rshift(a, n - 1), 1) ~= 0
local r = band(arshift(a, n), 4294967295)
FR = r; FZ = r == 0; FS = band(r, 2147483648) ~= 0; FP = PAR[band(r, 0xff)]; FO = false
EDX = r
end end
EDX = band(band(EDX, 7), 4294967295)
EDX = ru(M, band(EAX + EDX*4 + 897) - 7245824)
pc = 16
elseif pc == 12 then
do local r = band(band(band(EDX, 0xff), 24), 255)
FZ = r == 0
end
if FZ then pc = 14 else pc = 13 end
elseif pc == 13 then
EDX = ru(M, band(EAX + 861) - 7245824)
EDX = ru(M, band(EDX) - 7245824)
wu(M, band(ECX) - 7245824, EDX)
ECX = ru(M, 7976904)
ECX = band(ECX + 4)
wu(M, 7976904, ECX)
EDX = ru(M, band(EAX + 64) - 7245824)
do local n = band(3, 31)
if n ~= 0 then local a = EDX
FC = band(rshift(a, n - 1), 1) ~= 0
local r = band(arshift(a, n), 4294967295)
FR = r; FZ = r == 0; FS = band(r, 2147483648) ~= 0; FP = PAR[band(r, 0xff)]; FO = false
EDX = r
end end
EDX = band(band(EDX, 3), 4294967295)
EDX = ru(M, band(EAX + EDX*4 + 909) - 7245824)
pc = 16
elseif pc == 14 then
do local r = band(band(band(EDX, 0xff), 32), 255)
FZ = r == 0
end
if FZ then pc = 17 else pc = 15 end
elseif pc == 15 then
EDX = ru(M, band(EAX + 861) - 7245824)
EDX = ru(M, band(EDX) - 7245824)
wu(M, band(ECX) - 7245824, EDX)
ECX = ru(M, 7976904)
ECX = band(ECX + 4)
wu(M, 7976904, ECX)
EDX = ru(M, band(EAX + 865) - 7245824)
EDX = ru(M, band(EDX) - 7245824)
wu(M, band(ECX) - 7245824, EDX)
ECX = ru(M, 7976904)
ECX = band(ECX + 4)
wu(M, 7976904, ECX)
EDX = ru(M, band(EAX + 869) - 7245824)
EDX = ru(M, band(EDX) - 7245824)
wu(M, band(ECX) - 7245824, EDX)
ECX = ru(M, 7976904)
ECX = band(ECX + 4)
wu(M, 7976904, ECX)
EDX = ru(M, band(EAX + 873) - 7245824)
EDX = ru(M, band(EDX) - 7245824)
wu(M, band(ECX) - 7245824, EDX)
ECX = ru(M, 7976904)
ECX = band(ECX + 4)
wu(M, 7976904, ECX)
EDX = ru(M, band(EAX + 913) - 7245824)
EDX = ru(M, band(EDX) - 7245824)
wu(M, band(ECX) - 7245824, EDX)
ECX = ru(M, 7976904)
ECX = band(ECX + 4)
wu(M, 7976904, ECX)
EDX = ru(M, band(EAX + 917) - 7245824)
EDX = ru(M, band(EDX) - 7245824)
wu(M, band(ECX) - 7245824, EDX)
ECX = ru(M, 7976904)
ECX = band(ECX + 4)
wu(M, 7976904, ECX)
EDX = ru(M, band(EAX + 921) - 7245824)
pc = 16
elseif pc == 16 then
EDX = ru(M, band(EDX) - 7245824)
wu(M, band(ECX) - 7245824, EDX)
ECX = ru(M, 7976904)
ECX = band(ECX + 4)
wu(M, 7976904, ECX)
pc = 17
elseif pc == 17 then
ESP = ESP - 4; wu(M, ESP - 7245824, 5975248)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x5b2ef0]()
ESP = ESP + 8
ESP = ESP + 4
do return end
end
end
end
XF[0x5b2ef0] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ESI = ru(M, band(EAX + 117) - 7245824)
do local r = band(band(ESI, ESI), 4294967295)
FZ = r == 0
end
if FZ then pc = 4 else pc = 1 end
elseif pc == 1 then
ESP = ESP - 4; wu(M, ESP - 7245824, EDI)
EDI = ru(M, ESP - 7245808)
pc = 2
elseif pc == 2 then
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
ESP = ESP - 4
ICALL(EDI)
ESI = ru(M, band(ESI + 113) - 7245824)
ESP = ESP + 4
do local r = band(band(ESI, ESI), 4294967295)
FZ = r == 0
end
if not FZ then pc = 2 else pc = 3 end
elseif pc == 3 then
EDI = ru(M, ESP - 7245824); ESP = ESP + 4
pc = 4
elseif pc == 4 then
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 4
do return end
end
end
end
XF[0x5b4560] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
EAX = ru(M, ESP - 7245820)
ESP = ESP - 4; wu(M, ESP - 7245824, ESI)
EDX = 4
ECX = ru(M, band(EAX + 64) - 7245824)
do local r = band(band(band(ECX, 0xff), 1), 255)
FZ = r == 0
end
if FZ then pc = 2 else pc = 1 end
elseif pc == 1 then
ESI = ru(M, 7976904)
ECX = ru(M, band(EAX + 485) - 7245824)
ESI = ru(M, band(ESI) - 7245824)
wu(M, band(ECX) - 7245824, ESI)
pc = 4
elseif pc == 2 then
do local n = band(7, 31)
if n ~= 0 then local a = ECX
FC = band(rshift(a, n - 1), 1) ~= 0
local r = band(arshift(a, n), 4294967295)
FR = r; FZ = r == 0; FS = band(r, 2147483648) ~= 0; FP = PAR[band(r, 0xff)]; FO = false
ECX = r
end end
ECX = band(band(ECX, 7), 4294967295)
do local a = ECX; local r = band(a - 1, 4294967295)
FZ = r == 0
ECX = r
end
if not FZ then pc = 5 else pc = 3 end
elseif pc == 3 then
ESI = ru(M, 7976904)
ECX = ru(M, band(EAX + 485) - 7245824)
ESI = ru(M, band(ESI) - 7245824)
wu(M, band(ECX) - 7245824, ESI)
ESI = ru(M, 7976548)
ECX = ru(M, band(EAX + 485) - 7245824)
ESI = ru(M, band(ESI) - 7245824)
ECX = ru(M, band(ECX) - 7245824)
wu(M, band(ESI) - 7245824, ECX)
ECX = ru(M, 7976548)
ECX = band(ECX + EDX)
wu(M, 7976548, ECX)
pc = 4
elseif pc == 4 then
ECX = ru(M, 7976904)
ECX = band(ECX + EDX)
wu(M, 7976904, ECX)
ESI = ru(M, band(EAX + 669) - 7245824)
ECX = ru(M, band(ECX) - 7245824)
wu(M, band(ESI) - 7245824, ECX)
ECX = ru(M, 7976904)
ECX = band(ECX + EDX)
wu(M, 7976904, ECX)
pc = 5
elseif pc == 5 then
ECX = ru(M, band(EAX + 64) - 7245824)
do local r = band(band(band(ECX, 0xff), 2), 255)
FZ = r == 0
end
if FZ then pc = 7 else pc = 6 end
elseif pc == 6 then
ESI = ru(M, 7976904)
ECX = ru(M, band(EAX + 489) - 7245824)
ESI = ru(M, band(ESI) - 7245824)
wu(M, band(ECX) - 7245824, ESI)
pc = 9
elseif pc == 7 then
do local n = band(7, 31)
if n ~= 0 then local a = ECX
FC = band(rshift(a, n - 1), 1) ~= 0
local r = band(arshift(a, n), 4294967295)
FR = r; FZ = r == 0; FS = band(r, 2147483648) ~= 0; FP = PAR[band(r, 0xff)]; FO = false
ECX = r
end end
ECX = band(band(ECX, 7), 4294967295)
do local a = ECX; local r = band(a - 1, 4294967295)
ECX = r
end
do local a, b = ECX, 1
local r = a - b
r = band(r)
FZ = r == 0
end
if not FZ then pc = 10 else pc = 8 end
elseif pc == 8 then
ESI = ru(M, 7976904)
ECX = ru(M, band(EAX + 489) - 7245824)
ESI = ru(M, band(ESI) - 7245824)
wu(M, band(ECX) - 7245824, ESI)
ESI = ru(M, 7976548)
ECX = ru(M, band(EAX + 489) - 7245824)
ESI = ru(M, band(ESI) - 7245824)
ECX = ru(M, band(ECX) - 7245824)
wu(M, band(ESI) - 7245824, ECX)
ECX = ru(M, 7976548)
ECX = band(ECX + EDX)
wu(M, 7976548, ECX)
pc = 9
elseif pc == 9 then
ECX = ru(M, 7976904)
ECX = band(ECX + EDX)
wu(M, 7976904, ECX)
ESI = ru(M, band(EAX + 673) - 7245824)
ECX = ru(M, band(ECX) - 7245824)
wu(M, band(ESI) - 7245824, ECX)
ECX = ru(M, 7976904)
ECX = band(ECX + EDX)
wu(M, 7976904, ECX)
pc = 10
elseif pc == 10 then
ECX = ru(M, band(EAX + 64) - 7245824)
do local r = band(band(band(EDX, 0xff), band(ECX, 0xff)), 255)
FZ = r == 0
end
if FZ then pc = 12 else pc = 11 end
elseif pc == 11 then
ESI = ru(M, 7976904)
ECX = ru(M, band(EAX + 493) - 7245824)
ESI = ru(M, band(ESI) - 7245824)
wu(M, band(ECX) - 7245824, ESI)
pc = 14
elseif pc == 12 then
do local n = band(7, 31)
if n ~= 0 then local a = ECX
FC = band(rshift(a, n - 1), 1) ~= 0
local r = band(arshift(a, n), 4294967295)
FR = r; FZ = r == 0; FS = band(r, 2147483648) ~= 0; FP = PAR[band(r, 0xff)]; FO = false
ECX = r
end end
ECX = band(band(ECX, 7), 4294967295)
do local a = ECX; local r = band(a - 1, 4294967295)
ECX = r
end
do local a, b = ECX, 2
local r = a - b
r = band(r)
FZ = r == 0
end
if not FZ then pc = 15 else pc = 13 end
elseif pc == 13 then
ESI = ru(M, 7976904)
ECX = ru(M, band(EAX + 493) - 7245824)
ESI = ru(M, band(ESI) - 7245824)
wu(M, band(ECX) - 7245824, ESI)
ESI = ru(M, 7976548)
ECX = ru(M, band(EAX + 493) - 7245824)
ESI = ru(M, band(ESI) - 7245824)
ECX = ru(M, band(ECX) - 7245824)
wu(M, band(ESI) - 7245824, ECX)
ECX = ru(M, 7976548)
ECX = band(ECX + EDX)
wu(M, 7976548, ECX)
pc = 14
elseif pc == 14 then
ECX = ru(M, 7976904)
ECX = band(ECX + EDX)
wu(M, 7976904, ECX)
ESI = ru(M, band(EAX + 677) - 7245824)
ECX = ru(M, band(ECX) - 7245824)
wu(M, band(ESI) - 7245824, ECX)
ECX = ru(M, 7976904)
ECX = band(ECX + EDX)
wu(M, 7976904, ECX)
pc = 15
elseif pc == 15 then
ECX = ru(M, band(EAX + 64) - 7245824)
ESI = ECX
do local n = band(7, 31)
if n ~= 0 then local a = ESI
FC = band(rshift(a, n - 1), 1) ~= 0
local r = band(arshift(a, n), 4294967295)
FR = r; FZ = r == 0; FS = band(r, 2147483648) ~= 0; FP = PAR[band(r, 0xff)]; FO = false
ESI = r
end end
ESI = band(band(ESI, 7), 4294967295)
do local a = ESI; local r = band(a - 1, 4294967295)
ESI = r
end
do local a, b = ESI, 2
local r = a - b
r = band(r)
FO = band(bxor(a, b), bxor(a, r), 2147483648) ~= 0
FZ = r == 0
FS = band(r, 2147483648) ~= 0
end
if (FZ or FS ~= FO) then pc = 17 else pc = 16 end
elseif pc == 16 then
ESI = ru(M, 7976904)
ECX = ru(M, band(EAX + 629) - 7245824)
ESI = ru(M, band(ESI) - 7245824)
wu(M, band(ECX) - 7245824, ESI)
ESI = ru(M, 7976548)
ECX = ru(M, band(EAX + 629) - 7245824)
ESI = ru(M, band(ESI) - 7245824)
ECX = ru(M, band(ECX) - 7245824)
wu(M, band(ESI) - 7245824, ECX)
ECX = ru(M, 7976548)
ECX = band(ECX + EDX)
wu(M, 7976548, ECX)
ECX = ru(M, 7976904)
ECX = band(ECX + EDX)
wu(M, 7976904, ECX)
ESI = ru(M, band(EAX + 64) - 7245824)
do local n = band(7, 31)
if n ~= 0 then local a = ESI
FC = band(rshift(a, n - 1), 1) ~= 0
local r = band(arshift(a, n), 4294967295)
FR = r; FZ = r == 0; FS = band(r, 2147483648) ~= 0; FP = PAR[band(r, 0xff)]; FO = false
ESI = r
end end
ESI = band(band(ESI, 7), 4294967295)
ESI = ru(M, band(EAX + ESI*4 + 665) - 7245824)
pc = 21
elseif pc == 17 then
do local r = band(band(band(ECX, 0xff), 24), 255)
FZ = r == 0
end
if FZ then pc = 19 else pc = 18 end
elseif pc == 18 then
ESI = ru(M, 7976904)
ECX = ru(M, band(EAX + 629) - 7245824)
ESI = ru(M, band(ESI) - 7245824)
wu(M, band(ECX) - 7245824, ESI)
ECX = ru(M, 7976904)
ECX = band(ECX + EDX)
wu(M, 7976904, ECX)
ESI = ru(M, band(EAX + 64) - 7245824)
do local n = band(3, 31)
if n ~= 0 then local a = ESI
FC = band(rshift(a, n - 1), 1) ~= 0
local r = band(arshift(a, n), 4294967295)
FR = r; FZ = r == 0; FS = band(r, 2147483648) ~= 0; FP = PAR[band(r, 0xff)]; FO = false
ESI = r
end end
ESI = band(band(ESI, 3), 4294967295)
ESI = ru(M, band(EAX + ESI*4 + 677) - 7245824)
pc = 21
elseif pc == 19 then
do local r = band(band(band(ECX, 0xff), 32), 255)
FZ = r == 0
end
if FZ then pc = 22 else pc = 20 end
elseif pc == 20 then
ESI = ru(M, 7976904)
ECX = ru(M, band(EAX + 629) - 7245824)
ESI = ru(M, band(ESI) - 7245824)
wu(M, band(ECX) - 7245824, ESI)
ECX = ru(M, 7976904)
ECX = band(ECX + EDX)
wu(M, 7976904, ECX)
ESI = ru(M, band(EAX + 633) - 7245824)
ECX = ru(M, band(ECX) - 7245824)
wu(M, band(ESI) - 7245824, ECX)
ECX = ru(M, 7976904)
ECX = band(ECX + EDX)
wu(M, 7976904, ECX)
ESI = ru(M, band(EAX + 637) - 7245824)
ECX = ru(M, band(ECX) - 7245824)
wu(M, band(ESI) - 7245824, ECX)
ECX = ru(M, 7976904)
ECX = band(ECX + EDX)
wu(M, 7976904, ECX)
ESI = ru(M, band(EAX + 641) - 7245824)
ECX = ru(M, band(ECX) - 7245824)
wu(M, band(ESI) - 7245824, ECX)
ECX = ru(M, 7976904)
ECX = band(ECX + EDX)
wu(M, 7976904, ECX)
ESI = ru(M, band(EAX + 681) - 7245824)
ECX = ru(M, band(ECX) - 7245824)
wu(M, band(ESI) - 7245824, ECX)
ECX = ru(M, 7976904)
ECX = band(ECX + EDX)
wu(M, 7976904, ECX)
ESI = ru(M, band(EAX + 685) - 7245824)
ECX = ru(M, band(ECX) - 7245824)
wu(M, band(ESI) - 7245824, ECX)
ECX = ru(M, 7976904)
ECX = band(ECX + EDX)
wu(M, 7976904, ECX)
ESI = ru(M, band(EAX + 689) - 7245824)
pc = 21
elseif pc == 21 then
ECX = ru(M, band(ECX) - 7245824)
wu(M, band(ESI) - 7245824, ECX)
ECX = ru(M, 7976904)
ECX = band(ECX + EDX)
wu(M, 7976904, ECX)
pc = 22
elseif pc == 22 then
ESP = ESP - 4; wu(M, ESP - 7245824, 5981536)
ESP = ESP - 4; wu(M, ESP - 7245824, EAX)
ESP = ESP - 4
XF[0x5b2ef0]()
ESP = ESP + 8
ESI = ru(M, ESP - 7245824); ESP = ESP + 4
ESP = ESP + 4
do return end
end
end
end
XF[0x5f6a70] = function()
local pc = 0
local s0, s1, s2, s3, s4, s5, s6, s7
while true do
if pc == 0 then
ECX = ru(M, ESP - 7245820)
s0 = rf(M, band(ECX + 8) - 7245824)
s1 = rf(M, band(ECX + 4) - 7245824)
s2 = rf(M, band(ECX) - 7245824)
s3 = s2
s3 = s3 * s2
s4 = s1
s4 = s4 * s1
s3 = s3 + s4
s4 = s0
s4 = s4 * s0
s3 = s3 + s4
s3 = sqrt(s3)
s0 = s3
s1 = s0
s1 = abs(s1)
s2 = rf(M, 64392)
FSW = fcmp(s2, s1)
EAX = bor(band(EAX, 0xffff0000), FSW)
do local r = band(band(EAX, 16640), 4294967295)
FZ = r == 0
EAX = r
end
if not FZ then pc = 2 else pc = 1 end
elseif pc == 1 then
EAX = 0
wu(M, band(ECX) - 7245824, 1065353216)
wu(M, band(ECX + 4) - 7245824, EAX)
wu(M, band(ECX + 8) - 7245824, EAX)
ESP = ESP + 4
do return end
elseif pc == 2 then
s0 = rf(M, 2008) / s0
s1 = s0
s1 = s1 * rf(M, band(ECX) - 7245824)
wfd(band(ECX) - 7245824, s1)
s1 = s0
s1 = s1 * rf(M, band(ECX + 4) - 7245824)
wfd(band(ECX + 4) - 7245824, s1)
s0 = s0 * rf(M, band(ECX + 8) - 7245824)
wfd(band(ECX + 8) - 7245824, s0)
ESP = ESP + 4
do return end
end
end
end
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

-- install the translated JIT callbacks (NR2003CupJIT* modules)
local ctx = { M = M, LKF = LKF, LKU = LKU, NB = NB, NC = NC, JIT = JIT }
for _, install in ipairs(jitModules or {}) do install(ctx) end
V.reset()
return V
end

