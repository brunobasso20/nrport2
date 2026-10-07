-- PATCH_STAGE10 parte 4/4 — NR2003 Roblox port, estágio 10 (instalação em partes pela Command Bar).
-- Cole as partes 1..4 em ordem (cada uma inteira, FORA do Play) e depois PATCH_STAGE10_INSTALL.lua.
-- As partes só guardam fontes em ServerStorage.NR2003Stage10Staging; nada muda no jogo até o INSTALL.
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes do patch")
local storage=game:GetService("ServerStorage")
local SES=game:GetService("ScriptEditorService")
local function setSource(s,src)
    if #src<200000 then s.Source=src else SES:UpdateSourceAsync(s,function() return src end) end
end
local staging=storage:FindFirstChild("NR2003Stage10Staging")
if not staging then staging=Instance.new("Folder");staging.Name="NR2003Stage10Staging";staging.Parent=storage end
local function module(folder,name,source)
    local f=staging:FindFirstChild(folder)
    if not f then f=Instance.new("Folder");f.Name=folder;f.Parent=staging end
    local old=f:FindFirstChild(name);if old then old:Destroy() end
    local s=Instance.new("ModuleScript");s.Name=name;setSource(s,source);s.Parent=f
    assert(#s.Source==#source,"fonte truncada: "..folder.."."..name)
end
module("NR2003Cup","NR2003CupCore",[=[
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

]=])
module("NR2003Cup","NR2003CupDriver",[=[
--!native
--!optimize 2
-- NR2003 Cup driver layer + tick sequencing (Stage 7). Installs V.drive / V.componentPose on a
-- runtime created by NR2003CupCore. Every float32 store goes through V.wf32d (IEEE single,
-- rounding toward -inf: NR2003 bg task FPU CW 0x077f, 0055cef0 -> 00567704(1,3)).
--
-- Per 36 Hz task frame (005b2190 -> 00551e80 tail, player car):
--   pedals/axes -> bf6390/bf6eac/bf6eb0, throttle^2/brake^2 targets, per-tick ramps (/N),
--   shift request (00552450/00552480).  Steering: PROVISIONAL (Stage 12 pending) -- the host
--   supplies the road-wheel target instead of 00552720 shaping + pow linearity + 00554fb0 ratio.
-- Per 288 Hz tick (005b2190 loop body):
--   005539c0 input composition (ramps, toe c086b0/c086b4, brake/clutch ramps, lifted 00553d70
--   shift FSM + auto clutch 005542f0, gear, rev limiter engine+0x438 with 006f5a3c hysteresis),
--   005b2b90 predictor+solve, 005b2cb0 export, tires (00578da0 -> 0055e1e0 x4), 005b2bd0 forces,
--   005b2be0 corrector+solve, export, tires (00578de0), forces, 005b2c00 commit.
-- Per frame end (00554520): 0051aac0 cut-timer subset (in the core: V._frameEnd).
-- Stage 8 (brake input chain, per frame, 005524f0 player branch):
--   raw brake control (0057af30 control table) -> 00552d00 axis limiter -> 00553080 pedal
--   processing (auto-hold below 0.8 m/s, key ramp, braking help 00550130) -> bf6eac; the
--   00551e80 tail squares it and ramps it per tick into bf636c -> 005b2b90 -> brake cell e84480,
--   which the ORIGINAL generated force code (005610b0 x4 + 00561040) turns into wheel torque.
-- Stage 9: frame start calls V._aeroFrame (005637e0 subset, NR2003CupAero) before frameStart.
-- Not ported (documented): replay/telemetry recording, FFB, auto-shift 005536b0 (transmission
-- mode 0), H-pattern mode (bf6f0c 1/2), ignition states driven by 005524f0/0057af40(0x19),
-- throttle/clutch/steering device processing (00552df0/005534f0/00552720 - Stage 7 host
-- values / Stage 12).
return function(V)
	local rf32, r32, ri32, w32, r8, w8 = V.rf32, V.r32, V.ri32, V.w32, V.r8, V.w8
	local wf32d, fd, rf64, wf64 = V.wf32d, V.fd, V.rf64, V.wf64
	local wf32 = V.wf32
	local callx, tires, export, frameEnd, popF = V._callx, V._tires, V._export, V._frameEnd, V._popF
	local M, BASE = V.memory(), V.base
	local TPF, ENGINE, ROOT, INPUTS = V.TPF, V.ENGINE, V.ROOT, V.INPUTS
	local abs, sqrt, atan2 = math.abs, math.sqrt, math.atan2

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
			v = prev - rate -- FSUBR
			if not (v >= raw or v ~= v or raw ~= raw) then v = raw end -- TEST AH,5; JP keep
		else
			v = rate + prev -- FADD
			if not (v <= raw or v ~= v or raw ~= raw) then v = raw end -- AND 0x4100; JNZ keep
		end
		wf32d(0xbf639c + 4 * ecx, v) -- FST dword (state), ST0 keeps the x87 value
		if edx == 0 then v = math.sin(v * rf64(0x6f5a00)) end -- steering axes only
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
	-- controls: throttle pedal 0..1, clutch = engagement 0..1 (1 = pedal up), steer = road-wheel
	-- target (rad, + = left, PROVISIONAL), shiftUp/shiftDown = sequential shift keys.
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
			wf32d(0xbf6390, c.throttle or 0)
		end
		for w = 0, 3 do -- per-frame tire accumulators cleared by 00551e80 (bf3ccc.., bf4705.., ...)
			local t = 0xbf3a20 + w * 0xa39
			w32(t + 0x2ac, 0); w32(t + 0x2b0, 0); w32(t + 0x2b4, 0); w32(t + 0x2b8, 0)
			w32(t + 0x2d0, 0); w32(t + 0x2d4, 0); w32(t + 0x2bc, 0); w32(t + 0x2c0, 0)
		end
		local target = c.steer or 0
		wf32d(0xbf63b8, target)
		w32(0xbf6e38, r32(0xbf6eb0))
		w32(0xbf63c0, r32(0xbf6e80)); w32(0xbf636c, r32(0xbf6e64))
		w32(0xbf6ea4, r32(0xbf6e60)); w32(0xbf6e14, r32(0xbf6e68))
		local thr, brk = rf32(0xbf6390), rf32(0xbf6eac)
		wf32d(0xbf6e30, thr * thr); wf32d(0xbf6e34, brk * brk)
		wf32d(0xbf6e88, (target - rf32(0xbf6e80)) / N)
		wf32d(0xbf6394, (rf32(0xbf6e30) - rf32(0xbf6e60)) / N)
		wf32d(0xbf6358, (rf32(0xbf6e34) - rf32(0xbf6e64)) / N)
		local cl = rf32(0xbf6eb0) - rf32(0xbf6e68)
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
	local function tickInputs()
		wf64(0xbf6ef8, rf64(0xbf6ef8) + rf32(0x74fd74))
		wf32d(0xbf6ea4, rf32(0xbf6394) + rf32(0xbf6ea4))
		wf32d(0xbf63c0, rf32(0xbf6e88) + rf32(0xbf63c0))
		wf32d(0xbf6360, rf32(0xbf63c0) - rf32(0xc086b0))
		w32(0xbf6368, r32(0xbf6ea4))
		wf32d(0xbf6364, rf32(0xc086b4) + rf32(0xbf63c0))
		wf32d(0xbf636c, rf32(0xbf636c) + rf32(0xbf6358))
		local c = rf32(0xbf6e50) + rf32(0xbf6e14)
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
	function V.drive(controls, contacts)
		if V.tick % TPF == 0 then
			if V._aeroFrame then V._aeroFrame() end
			frameStart(controls)
		end
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
		if V.tick % TPF == 0 then frameEnd() end
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
module("Core","NR2003CupVehicle",[=[
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
    local build=get("NR2003CupBuild") -- Stage 10 (absent in a Stage 6/7/8/9 install)
    if build then
        local Setup=get("NR2003CupSetup")(get("NR2003CupSetupData"))
        local B=build(V,collect(get,"NR2003CupBuildCode"),collect(get,"NR2003CupBuildData"))
        get("NR2003CupGarage")(V,Setup,B,collect(get,"NR2003CupJITG"))
    end
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
-- controls: {throttle, clutch(engagement), steer(road-wheel rad, + left), shiftUp, shiftDown,
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
function M:startSession(weather) return self.V.startSession(weather) end
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
module("Roblox","CupChassisAdapter",[=[
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
        fault=nil,renderSpin={},lastRenderSnapshotTime=nil,renderTeleport=true,pendingShift=0,steerAngle=0,
        planes={},inContact={},wheelPose={},contactPoints={},scratchPos={0,0,0},scratchRot={1,0,0,0,1,0,0,0,1}},M)
    for j=1,4 do
        self.planes[j]={0,0,1,0,0,0,0,1,1};self.inContact[j]=false
        self.wheelPose[j]={pos={0,0,0},rot={1,0,0,0,1,0,0,0,1},compression=0,steer=0,angle=0,rate=0}
        self.contactPoints[j]={point=Vector3.zero,grounded=false}
    end
    self.spawn=car:GetPivot();self.oldAnchored=self.root.Anchored;self.oldCollide=self.root.CanCollide
    car:SetAttribute("NR2003CorePoseOwner",true);car:SetAttribute("PhysicsMode","NR2003_CUP")
    car:SetAttribute("NR2003Tune","CupTune")
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
    if self.car:GetAttribute("AeroSession")==false then
        self.core:endSession();self.weather=nil
    else
        self.weather=self.core:startSession({temperatureF=num("WeatherTemperatureF"),windSpeedMph=num("WeatherWindMph"),
            windDirection=num("WeatherWindDirection"),conditions=num("WeatherConditions"),night=self.car:GetAttribute("WeatherNight")==true,
            trackNorth=num("TrackNorth")})
    end
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
    self.pendingShift=0;self.steerAngle=0
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

-- PROVISIONAL steering (Stage 12 pending): Stage 5 slew/speed law -> one road-wheel target;
-- the original 005539c0 adds the setup toe per side (lf = s - toe, rf = s + toe).
function M:steer(input,dt)
    local s=self.tune.steering
    local st=self.core:readState()
    local _,rot=self.core:componentPose(0,self.scratchPos,self.scratchRot)
    local speed=st[2]*rot[1]+st[4]*rot[4]+st[6]*rot[7]
    local fraction=math.max(s.minimumFraction,1/(1+math.abs(speed)*s.speedReduction))
    local command=U.clamp(input.steer or 0,-1,1)
    local target=command*s.maximum*fraction
    self.steerAngle=U.approach(self.steerAngle,target,(command==0 and s.returnRate or s.rate)*dt) -- + = right
end

function M:tickCore(input)
    local frame=self.core:tick()%8==0
    -- Stage 8: the brake goes through the ORIGINAL input chain (00552d00/00553080 -> bf6eac).
    -- The bench client sends keyboard keys (S/W = 0/1): NR2003 key binding (0057af60 digital).
    -- brakeAxis=true in the input selects the analog-axis binding for real pedals/triggers.
    -- No driver seated = 005524f0 'car not driven' branch (pedal held at 1.0).
    local controls
    if self:driver()==nil then
        controls={driver=false,throttle=0,clutch=0,steer=0}
    else
        local throttle=U.clamp(input.throttle or 0,0,1)
        controls={throttle=throttle,throttleControl=throttle,throttleDigital=input.throttleAxis~=true,
            brakeControl=U.clamp(input.brake or 0,0,1),brakeDigital=input.brakeAxis~=true,
            clutch=1-U.clamp(input.clutch or 0,0,1),steer=-self.steerAngle}
    end
    if frame and self.pendingShift~=0 and controls.driver~=false then
        controls.shiftUp=self.pendingShift>0;controls.shiftDown=self.pendingShift<0;self.pendingShift=0
    end
    if frame and self.weather then self:aeroHostInputs() end
    self.core:step(controls,self.contactFn)
    self:pose(false)
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
        self:steer(input,elapsed)
        self.runner:advance(elapsed,input,nil)
        self.car:PivotTo(self.rootCF)
        self.car:SetAttribute("CoreTick",self.core:tick());self.car:SetAttribute("CoreCollision",self.collision==true)
        local wheels=self:wheels()
        for j=1,4 do
            local _,_,_,px,py,pz=self.core:contactOut(j-1)
            self.contactPoints[j].point=self:worldPoint(px,py,pz);self.contactPoints[j].grounded=self.inContact[j]
        end
        self.visual:update({wheels=wheels},self.contactPoints,self.debugVisible)
        Cockpit.update(self.car,self.tune,self.steerAngle)
    end)
    if not ok then self.fault=tostring(reason);self.car:SetAttribute("PhysicsFault",self.fault);warn("NR2003 Cup core paused: "..self.fault) end
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
    local flags=self.renderTeleport and RenderSnapshot.FLAG_TELEPORT or 0
    self.renderTeleport=false;self.lastRenderSnapshotTime=time
    return {vehicleId=vehicleId or 1,seq=seq,flags=flags,tick=self.core:tick(),time=time,
        px=px,py=py,pz=pz,qx=qx,qy=qy,qz=qz,qw=qw,
        lx=linear.X,ly=linear.Y,lz=linear.Z,ax=angular.X,ay=angular.Y,az=angular.Z,
        steer=self.steerAngle,wheels=wheels}
end

function M:telemetry()
    local st=self.core:readState()
    local linear=self:kinematics()
    local _,r=self.core:componentPose(0,self.scratchPos,self.scratchRot)
    local forward=st[2]*r[1]+st[4]*r[4]+st[6]*r[7]
    local lf,rf,thr,brk,clu,gearIn=self.core:inputs()
    local wheels={}
    for j,c in ipairs(self.tune.corners) do
        local fx,fy,fz=self.core:contactOut(j-1)
        local travel=st[c.state.travel+1]
        local w=self.wheelPose[j]
        -- Stage 8: original per-wheel brake/tire cells (no side effects on the core)
        local b=self.core:wheelBrake(j-1)
        wheels[j]={name=c.name,load=self.inContact[j] and fz or 0,compression=travel,
            slip=b.vslip/math.max(math.abs(b.vx),2),
            omega=w.rate,temperature=self.tune.environment.ambientC,grounded=self.inContact[j],
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
        roadWheelAngle=self.steerAngle,steeringWheelAngle=Cockpit.angle(self.steerAngle,self.tune)}
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
module("Roblox","Stage10SelfTest",[=[
-- Stage 10 Studio self-test (edit mode or Play, server side). Golden values embedded below were
-- produced by the ORIGINAL NR2003.exe code (Unicorn: recovery/stage10/gen_setup_vectors.py, gen_fixtures10.py).
--   require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage10SelfTest).run()        -- quick (~3-6 s)
--   require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage10SelfTest).run(true)    -- full (+ more builds, 8 s drive)
local Core=script.Parent.Parent.Core
local Vehicle=require(Core.NR2003CupVehicle)
local G={
vec={["nearest"]={["toInternal"]={{0,0,0},{0,1098383360,1098383360},{0,1104936960,1104936960},{0,1109262336,1109262336},{0,1112408064,1112408064},{1,1090519040,1090519040},{1,1099431936,1099431936},{1,1105723392,1105723392},{1,1109655552,1109655552},{1,1112801280,1112801280},{2,1091066688,1091066688},{2,1100218368,1100218368},{2,1106509824,1106509824},{2,1110048768,1110048768},{2,1113194496,1113194496},{3,1092091904,1092091904},{3,1101004800,1101004800},{3,1107296256,1107296256},{3,1110441984,1110441984},{3,1113587712,1113587712},{4,4294967290,4294967290},{6,10,10},{10,0,0},{13,3,3},{15,1,1},{19,0,0},{20,1250,3347446784},{20,2300,3354822656},{21,1100,3345731584},{21,2200,3354120192},{22,400,3343224576},{23,275,3339178576},{24,1075838976,1075838976},{28,1067450368,1023544394},{31,2147483648,2147483648},{32,1074161255,1024860246},{32,1083179008,1033951616},{32,1088212173,1039573718},{32,3221225471,3171875384},{32,3230452941,3181201010},{32,3235066675,3186354603},{33,1067030939,1017877164},{33,1080452711,1031843328},{33,1086324736,1037465430},{33,3213675724,3164423793},{33,3227516928,3178903012},{33,3233598669,3184714823},{34,1100899942,1051782976},{36,1084459134,1040509813},{39,1085800448,1041600033},{40,58,1058306785},{40,82,1062333317},{41,3175926989,988472677},{43,2,2},{44,2,2},{44,26,26},{45,1092549322,1048655866},{46,1091043328,1046287588},{46,1095761920,1051267065},{48,19,1100480512},{49,8,1102421151},{51,0,0},{53,5,5},{53,29,29},{54,19,19},{54,43,43},{55,17,17},{55,41,41},{55,65,65},{56,37,37},{56,61,61},{57,111,111},{57,135,135},{58,8,8},{58,12736,12736},{58,32759,32759},{59,40,1053609164},{60,31,1050589266},{61,44,3212836864},{61,68,1102577664},{62,95,1110203957},{62,4294967271,3241504932},{63,90,1109609414},{63,4294967124,3265006036},{63,4294967231,3253460795},{64,50,1102409892},{64,4294967141,3263995314},{64,4294967246,3249893540},{65,1073741824,1006930033},{66,1067450368,1000712846},{67,1069547520,1020688214},{67,3208260285,3159356248},{68,1075838976,1026734279},{68,3214287099,3165106706},{69,33,33},{69,57,57},{70,29,29},{70,53,53}},["toDisplay"]={{0,0,0},{0,1098383360,1098383360},{0,1104936960,1104936960},{0,1109262336,1109262336},{0,1112408064,1112408064},{1,1090519040,1090519040},{1,1099431936,1099431936},{1,1105723392,1105723392},{1,1109655552,1109655552},{1,1112801280,1112801280},{2,1091066688,1091066688},{2,1100218368,1100218368},{2,1106509824,1106509824},{2,1110048768,1110048768},{2,1113194496,1113194496},{3,1092091904,1092091904},{3,1101004800,1101004800},{3,1107296256,1107296256},{3,1110441984,1110441984},{3,1113587712,1113587712},{4,4294967290,4294967290},{6,10,10},{10,0,0},{13,3,3},{15,1,1},{19,0,0},{20,3347446784,1250},{20,3354822656,2300},{21,3345731584,1100},{21,3354120192,2200},{22,3343224576,400},{23,3339178576,275},{24,1075838976,1075838976},{28,1023544394,1067450347},{31,2147483648,2147483648},{32,1024860246,1074161259},{32,1033951616,1083179012},{32,1039573718,1088212179},{32,3171875384,3221225475},{32,3180966756,3230243230},{32,3186256115,3234978510},{33,1016940147,1066192082},{33,1031419365,1080033287},{33,1037231175,1086115026},{33,3163486776,3212836867},{33,3177965995,3226678073},{33,3184246314,3233179243},{34,1023454720,1072064109},{36,1039828225,1083841489},{38,2147483648,2147483648},{40,1057803469,55},{40,1061830000,79},{41,1001401356,3189348762},{42,3157754679,1050673153},{43,4294967295,4294967295},{44,23,23},{45,1047992153,1092091884},{46,0,0},{46,1050627853,1094975461},{48,1098907648,16},{49,1097008071,5},{50,2,2},{53,1,1},{53,25,25},{54,15,15},{54,39,39},{55,8,8},{55,37,37},{55,61,61},{56,33,33},{56,57,57},{57,107,107},{57,131,131},{58,4,4},{58,11583,11583},{58,30685,30685},{59,1050253721,30},{60,1041865113,15},{60,3175926988,4294967291},{61,1102053376,67},{62,1107825787,75},{62,3241504932,4294967271},{63,1107166232,70},{63,3243883102,4294967266},{63,3263038488,4294967156},{64,1098777624,35},{64,1116214395,150},{64,3258876690,4294967191},{65,1000712846,1067450346},{66,994495658,1061158886},{67,1007614521,1056964612},{67,1041754589,1091043332},{68,1020688214,1069547526},{68,3157267020,3206389916},{69,29,29},{69,53,53},{70,25,25},{70,49,49},{73,0,0},{97,0,0},{111,13,13},{124,29,29}},["step"]={{0,0,1,1,1090519040},{0,1100218368,1,1,1100480512},{0,1107689472,1,1,1107820544},{0,1111621632,1,1,1111752704},{1,1090519040,1,1,1091043328},{1,1101004800,1,1,1101266944},{1,1108082688,1,1,1108213760},{1,1112014848,1,1,1112145920},{2,1091066688,1,1,1091567616},{2,1101791232,1,1,1102053376},{2,1108475904,1,1,1108606976},{2,1112408064,1,1,1112539136},{3,1092091904,1,1,1092616192},{3,1102577664,1,1,1102839808},{3,1108869120,1,1,1109000192},{3,1112801280,1,1,1112932352},{4,4294967290,1,1,1},{7,3,1,1,4},{13,7,1,1,8},{15,16,1,1,9},{20,3349905408,1,1,3350256640},{21,3339409408,1,1,3340111872},{21,3353059472,1,1,3353066496},{22,3344033776,1,1,3344842977},{23,3343742464,1,1,3344033776},{26,3196059648,1,1,0},{31,1020269481,1,1,1023544394},{32,1025797263,1,1,1026265771},{32,1035825650,1,1,1036059904},{32,3163486776,1,1,3162549759},{32,3180029738,1,1,3179795484},{32,3186494890,1,1,3186120349},{33,1023923229,1,1,1024391738},{33,1034888633,1,1,1035122887},{33,3156972201,1,1,3155098167},{33,3178903012,1,1,3178434503},{33,3185906451,1,1,3185651841},{35,3156014116,1,1,1023454720},{38,1042878457,1,0,1042878457},{40,1058306785,1,1,1058474557},{40,1063339950,1,1,1063507722},{41,3152733541,1,0,3152733541},{43,20,1,1,19},{44,26,1,1,27},{45,1049775571,1,1,1049988641},{46,1048710218,1,1,1048923288},{48,1095761920,1,1,1096810496},{49,1102421151,1,1,1103908915},{51,5,1,1,6},{53,16,1,1,17},{54,12,1,1,13},{54,42,1,1,43},{55,22,1,1,23},{55,52,1,1,53},{56,30,1,1,31},{56,60,1,1,61},{57,116,1,1,117},{57,146,1,1,147},{58,11034,1,1,11035},{58,32758,1,1,32759},{59,1059481190,1,1,1060320051},{60,1061158912,1,1,1061997772},{61,1100480512,1,1,1101004800},{62,1109609414,1,1,1110203957},{62,3251558259,1,1,3249893540},{63,1115917123,1,1,1116214395},{63,3261849403,1,1,3261254860},{64,1101696440,1,1,1102409892},{64,3246261272,1,1,3243883102},{65,976190801,1,1,990152817},{66,986786091,1,1,994495658},{67,1018345671,1,1,1020688214},{67,3165829319,1,1,3163486777},{68,1035708523,1,1,1036294158},{69,26,1,1,27},{69,56,1,1,57},{70,34,1,1,35},{70,64,1,1,65}}},["down"]={["toInternal"]={{0,0,0},{0,1098383360,1098383360},{0,1104936960,1104936960},{0,1109262336,1109262336},{0,1112408064,1112408064},{1,1090519040,1090519040},{1,1099431936,1099431936},{1,1105723392,1105723392},{1,1109655552,1109655552},{1,1112801280,1112801280},{2,1091411631,1091411631},{2,1100218368,1100218368},{2,1106509824,1106509824},{2,1110048768,1110048768},{2,1113194496,1113194496},{3,1092091904,1092091904},{3,1101004800,1101004800},{3,1107296256,1107296256},{3,1110441984,1110441984},{3,1113587712,1113587712},{4,4294967290,4294967290},{6,10,10},{10,0,0},{13,3,3},{15,1,1},{19,1,1},{20,1350,3348149249},{20,2350,3355173889},{21,1150,3346434049},{21,2200,3354120193},{22,410,3343548257},{23,300,3339987777},{24,2147483648,2147483648},{28,1069547520,1025248958},{31,3214934016,3171028042},{32,1074580685,1025328754},{32,1083388724,1034185871},{32,1088421888,1039807971},{32,3221644902,3172343894},{32,3230662656,3181435265},{32,3235188352,3186490518},{33,1067869799,1018814180},{33,1080872141,1032077582},{33,1086534452,1037699684},{33,3214514585,3165360811},{33,3227936358,3179326976},{33,3233808384,3184949078},{34,2147483648,2147483648},{36,1084751872,1040747750},{39,1086324736,1042026174},{40,59,1058474557},{40,83,1062501088},{41,3179454535,991285873},{43,3,3},{44,3,3},{44,27,27},{45,1092616192,1048710217},{46,1091187855,1046522530},{46,1096024064,1051480135},{48,20,1101004800},{49,9,1103908914},{51,1,1},{53,6,6},{53,30,30},{54,20,20},{54,44,44},{55,18,18},{55,42,42},{55,66,66},{56,38,38},{56,62,62},{57,112,112},{57,136,136},{58,9,9},{58,14551,14551},{58,32759,32759},{59,40,1053609164},{60,23,1047233822},{61,38,3235905536},{61,67,1102053376},{62,90,1109609414},{62,4294967266,3243883102},{63,85,1109014871},{63,4294967121,3265184400},{63,4294967236,3252271710},{64,50,1102409891},{64,4294967141,3263995314},{64,4294967256,3247515370},{65,1075838976,1009101453},{66,1069547520,1002884266},{67,1073741824,1024391737},{67,3208855747,3160021386},{68,1077936128,1029076821},{68,3216329910,3167388549},{69,35,35},{69,59,59},{70,31,31},{70,55,55}},["toDisplay"]={{0,0,0},{0,1098383360,1098383360},{0,1104936960,1104936960},{0,1109262336,1109262336},{0,1112408064,1112408064},{1,1090519040,1090519040},{1,1099431936,1099431936},{1,1105723392,1105723392},{1,1109655552,1109655552},{1,1112801280,1112801280},{2,1091411631,1091411631},{2,1100218368,1100218368},{2,1106509824,1106509824},{2,1110048768,1110048768},{2,1113194496,1113194496},{3,1092091904,1092091904},{3,1101004800,1101004800},{3,1107296256,1107296256},{3,1110441984,1110441984},{3,1113587712,1113587712},{4,4294967290,4294967290},{6,10,10},{10,0,0},{13,3,3},{15,1,1},{19,1,1},{20,3347798017,1300},{20,3354822657,2300},{21,3345731585,1100},{21,3353417729,2100},{22,3341606177,350},{23,3336454369,225},{23,3349590185,675},{27,3223322624,3223322624},{30,3171028042,3214933996},{32,1019751197,1068708664},{32,1032311836,1081291577},{32,1037933938,1086744172},{32,3166297828,3215353452},{32,3179561231,3228355797},{32,3185183332,3234018105},{33,1007614523,1056964613},{33,1028608313,1077516702},{33,1035825650,1084856734},{33,3152331660,3201092817},{33,3175623453,3224580921},{33,3183075044,3232130668},{33,3187291620,3235905543},{36,1028658089,1073741789},{38,1042026175,1086324710},{40,0,0},{40,1060487823,71},{41,980084069,3167538382},{41,3152733542,1045220558},{43,14,14},{44,14,14},{45,1045861446,1090781166},{45,1050840924,1095237605},{46,1048644064,1092534780},{47,2,2},{48,1105723392,29},{49,1112297522,18},{51,9,9},{53,14,14},{53,4294967295,4294967295},{54,28,28},{54,52,52},{55,26,26},{55,50,50},{56,22,22},{56,46,46},{56,75,75},{57,120,120},{57,144,144},{58,3306,3306},{58,22263,22263},{58,32767,32767},{59,1061997772,80},{60,1058642329,60},{61,1091567616,54},{62,1083254505,10},{62,1113771212,125},{63,1083254505,10},{63,1113176669,120},{63,3255309435,4294967221},{63,3266373485,4294967101},{64,1109609414,90},{64,3249893540,4294967246},{65,0,0},{65,1020747192,1087373283},{66,1013444294,1080033248},{67,1032780345,1082130435},{67,3170893857,3219468061},{68,1035122887,1084227588},{69,0,0},{69,43,43},{69,67,67},{70,39,39},{70,63,63},{87,0,0},{106,1067541548,1067541548},{119,0,0}},["step"]={{0,0,1,1,1090519040},{0,1100218368,1,1,1100480512},{0,1107689472,1,1,1107820544},{0,1111621632,1,1,1111752704},{1,1090519040,1,1,1091043328},{1,1101004800,1,1,1101266944},{1,1108082688,1,1,1108213760},{1,1112014848,1,1,1112145920},{2,1091411631,1,1,1091567616},{2,1101791232,1,1,1102053376},{2,1108475904,1,1,1108606976},{2,1112408064,1,1,1112539136},{3,1092091904,1,1,1092616192},{3,1102577664,1,1,1102839808},{3,1108869120,1,1,1109000192},{3,1112801280,1,1,1112932352},{4,4294967290,1,1,1},{7,3,1,1,4},{13,7,1,1,8},{15,16,1,1,9},{20,3349905409,1,1,3350256641},{21,3338706945,1,1,3339409409},{21,3352012801,1,1,3352364033},{22,3342415377,1,1,3343224577},{23,3342415377,1,1,3343224577},{26,0,1,0,0},{30,1023544393,1,0,1023544393},{32,1020688214,1,1,1021625230},{32,1033951616,1,1,1034185870},{32,3143943047,1,1,3135554431},{32,3177497487,1,1,3177028979},{32,3185417586,1,1,3185183333},{33,1017877164,1,1,1018814180},{33,1033248854,1,1,1033483107},{33,1041168953,1,1,1039807971},{33,3176091961,1,1,3175623453},{33,3184714824,1,1,3184480570},{35,0,1,1,1023454719},{38,1041382706,1,1,1041600033},{40,1056629063,1,1,1056964607},{40,1061662228,1,1,1061830000},{41,1006903561,1,1,1005249893},{43,10,1,1,11},{44,16,1,1,17},{45,1047940666,1,1,1047992152},{46,1046522530,1,1,1046713728},{46,1054250054,1,1,1052119347},{48,1106771968,1,1,1107296256},{49,3246929272,1,1,1077255327},{53,4,1,1,5},{53,34,1,0,34},{54,30,1,1,31},{54,60,1,1,59},{55,40,1,1,41},{55,75,1,1,68},{56,48,1,1,49},{57,104,1,1,105},{57,134,1,1,135},{58,709,1,1,710},{58,22958,1,1,22959},{59,1040522936,1,1,1041865113},{60,1044549467,1,1,1045220556},{61,1084227584,1,1,1086324736},{62,1091643113,1,1,1094021283},{62,1116630574,1,1,1116214394},{63,1107825786,1,1,1108420329},{63,3252271710,1,1,3251082625},{63,3266968027,1,1,3266670756},{64,1114365755,1,1,1114960297},{64,3260660318,1,1,3260065776},{65,1013444294,1,1,1014530004},{66,1015318641,1,0,1015318641},{67,1037465429,1,0,1037465429},{68,1026734279,1,1,1027905550},{68,3171314777,1,1,3170514404},{69,45,1,1,46},{70,23,1,1,24},{70,53,1,1,54}}}},
windows={{0,53312},{223424,320},{223808,3904},{239808,576},{254592,20672},{405504,16448},{501376,320},{1866752,2624},{5138176,384},{5269184,256},{5286336,14720},{5359040,3904},{5363968,320},{5369856,2112},{5410752,5760},{6605056,1088},{6614016,1600},{6627776,320},{7481344,256},{7975808,2496},{8204032,15168},{8937472,16448},{9002944,256}},
solve={255256,255260,255264,255268,255272,255276,255444,255448,255452,255456,255460,255464,255468,255484,255488,255492,255496,255500,255504,255508,255532,255536,255540,255544,255548,255552,255556,255748,255752,255756,255760,255764,255768,255772,255776,255780,255784,255788,255792,255796,255800,255804,255808,255812,255816,255820,255824,255828,255832,255836,255840,255844,255848,255852,255856,255860,255864,255868,255872,255876,255880,255884,255888,255892,256540,256544,256548,256672,256676,256680,256684,256688,256692,256696,256700,256704,256768,256772,256776,256780,256816,256820,256824,256828,256876,256880,256884,256888,257032,257036,257060,257064,257088,257092,257824,257828,257832,257836,257840,257844,257956,257960,257964,257968,257972,257976,257980,257984,257988,258052,258056,258060,258064,258068,258072,258076,258100,258104,258108,258112,258160,258164,258168,258172,258316,258320,258344,258348,258372,258376,258400,258404,258428,258432,258456,258460,259340,259344,259348,259352,259356,259360,259396,259448,259452,259456,259604,259608,259612,259628,259632,259636,259652,259656,259660,259688,259692,259696,259712,259716,259720,259736,259740,259744,260396,260400,260404,260408,260412,260416,260580,260584,260592,260596,260604,260608,260624,260628,260632,260636,260640,260644,260648,260672,260676,260680,260684,260688,260692,260696,260732,260736,260740,260744,260888,260892,260916,260920,260944,260948,260972,260976,261000,261004,261028,261032,261692,261696,261812,261816,261820,261824,261828,261832,261836,261840,261844,261908,261912,261916,261920,261924,261928,261932,261956,261960,261964,261968,261972,261976,261980,262016,262020,262024,262028,262284,262288,263192,263196,263200,263204,263208,263212,263216,263248,263252,263300,263304,263308,263312,263456,263460,263464,263468,263480,263484,263488,263492,263504,263508,263512,263516,263540,263544,263548,263552,263564,263568,263572,263576,263588,263592,263596,263600,264252,264256,264260,264264,264268,264436,264448,264460,264480,264484,264488,264492,264496,264500,264528,264532,264536,264544,264548,264588,264592,264596,264744,264772,264800,264828,264856,264884,265548,265552,265668,265672,265676,265680,265684,265688,265692,265696,265700,265764,265768,265772,265776,265780,265784,265788,265812,265816,265820,265824,265828,265832,265836,265872,265876,265880,265884,266140,266144,266820,266824,266828,266832,266836,266840,267000,267004,267008,267012,267016,267020,267024,267028,267032,267048,267052,267056,267060,267064,267068,267072,267096,267100,267104,267108,267112,267116,267156,267160,267164,267168,267312,267316,267320,267324,267328,267332,267336,267340,267344,267348,267352,267356,267360,267364,267368,267372,267376,267380,267384,267388,267392,267396,267400,267404,267408,267412,267416,267420,267424,267428,267432,267436,267440,267444,267448,267452,267456,268104,268108,268112,268116,268120,268124,268240,268244,268252,268256,268264,268268,268332,268336,268340,268344,268348,268352,268356,268380,268384,268388,268392,268396,268400,268404,268436,268440,268444,268448,268452,268596,268600,268624,268628,268652,268656,268680,268684,268708,268712,268736,268740,269392,269396,269400,269404,269408,269528,269540,269552,269620,269624,269628,269632,269636,269640,269668,269672,269676,269680,269684,269688,269724,269728,269732,269736,269884,269912,269940,269968,269996,270024,270684,270688,270812,270816,270824,270828,270836,270840,270916,270920,270924,270928,270964,270968,271012,271016,271020,271024,271252,271256,271968,271972,272096,272100,272108,272112,272120,272124,272200,272204,272208,272212,272248,272252,272296,272300,272304,272308,272536,272540,273252,273256,273380,273384,273392,273396,273404,273408,273484,273488,273492,273496,273580,273584,273588,273592,273820,273824,274532,274536,274664,274668,274676,274680,274688,274692,274760,274764,274768,274808,274812,274816,274868,274872,274876,275024,275052,275080,407892,407908,407912,413840,421204,421208,421448,421452,5138272,5138276,5138280,5138284,5138288,5138292,5138296,5138300,5138304,5138312,5138316,5286640,5287048,5287096,5287100,5287104,5287108,5287112,5287132,5287136,5287140,5287144,5287148,5287152,5287156,5287160,5287164,5287168,5287172,5287176,5287180,5287184,5288972,5288976,5288980,5288984,5288988,5288992,5289257,5289665,5289713,5289717,5289721,5289725,5289729,5289749,5289753,5289757,5289761,5289765,5289769,5289773,5289777,5289781,5289785,5289789,5289793,5289797,5289801,5291589,5291593,5291597,5291601,5291605,5291609,5291874,5292282,5292330,5292334,5292338,5292342,5292346,5292366,5292370,5292374,5292378,5292382,5292386,5292390,5292394,5292398,5292402,5292406,5292410,5292414,5292418,5294206,5294210,5294214,5294218,5294222,5294226,5294491,5294899,5294947,5294951,5294955,5294959,5294963,5294983,5294987,5294991,5294995,5294999,5295003,5295007,5295011,5295015,5295019,5295023,5295027,5295031,5295035,5296823,5296827,5296831,5296835,5296839,5296843,5299924,5299928,5299932,5299936,5299940,5299944,5299948,5299952,5370348,5370396,5370448,5370460,5370464,5370468,5370484,5370488,5370492,5370500,5370508,5370556,5370560,5370564,5370568,5370572,5370576,5370608,5370612,5370616,5370848,5370852,5370860,5370864,5370868,5370872,5370876,5370880,5370916,5370920,5370924,5370928,5370932,5370936,5370948,5370952,5370956,5370960,5370964,5370968,5370972,5370992,5371212,5371264,5371356,5371388,5371392,5371424,5371464,5371468,5371472,5371564,5371652,5371680,5412032,5412036,5412040,5412044,7975968,7975972,7975976,7975980,7975984,7975988,7975992,7975996,7976000,7976012,7976016,7976020,7976024,7976028,7976032,7976036,7976040,7976044,7976088,7976092,7976096,7976100,7976104,7976108,7976112,7976120,7976124,7976128,7976144,7976148,7976152,7976168,7976172,7976176,7976180,7976200,7976204,7976264,7976272,7976276,7976280,7976284,7976288,7976292,7976296,7976300,7976304,7976308,7976312,7976316,7976320,7976324,7976328,7976332,7976336,7976340,7976344,7976348,7976352,7976356,7976360,7976364,7976368,7976372,7976376,7976380,7976384,7976388,7976392,7976396,7976400,7976404,7976408,7976412,7976416,7976420,7976424,7976428,7976432,7976436,7976440,7976444,7976448,7976452,7976468,7976472,7976476,7976480,7976484,7976488,7976492,7976496,7976500,7976504,7976520,7976524,7976536,7976540,7976544,7976548,7976552,7976556,7976560,7976564,7976568,7976572,7976576,7976580,7976584,7976588,7976592,7976596,7976600,7976604,7976608,7976612,7976616,7976620,7976624,7976628,7976632,7976636,7976640,7976644,7976648,7976652,7976656,7976660,7976664,7976668,7976672,7976676,7976680,7976684,7976688,7976692,7976696,7976700,7976704,7976708,7976712,7976716,7976720,7976724,7976728,7976732,7976736,7976740,7976744,7976748,7976760,7976764,7976768,7976772,7976776,7976780,7976784,7976788,7976792,7976796,7976800,7976804,7976808,7976812,7976816,7976820,7976824,7976828,7976832,7976836,7976840,7976844,7976848,7976852,7976856,7976860,7976864,7976868,7976872,7976876,7976880,7976884,7976888,7976892,7976896,7976900,7976908,7976912,7976916,7976920,7976924,7976928,7976940,7976944,7976948,7976952,7976956,7976960,7976964,7976968,7976972,7976976,7976980,7976984,7976988,7976992,7976996,7977000,7977004,7977008,7977012,7977016,7977020,7977024,7977028,7977032,7977036,7977040,7977044,7977048,7977052,7977056,7977060,7977064,7977068,7977072,7977076,7977080,7977084,7977088,7977092,7977504,7977508,7977512,7977516,7977520,7977528,7977532,7977536,7977540,7977544,7977548,7977552,7977556,7977560,7977564,7977568,7977572,7977576,7977580,7977584,7977588,7977592,7977596,7977600,7977604,7977608,7977612,7977616,7977620,7977624,7977628,7977632,7977636,7977640,7977644,7977648,7977652,7977656,7977660,7977664,7977668,7977684,7977704,7977708,7977712,7977716,7977720,7977724,7977728,7977732,7977736,7977740,7977744,7977748,7977752,7977756,7977760,7977764,7977768,7977772,7977776,7977780,7977784,7977788,7977792,7977796,7977800,7977804,7977808,7977812,7977816,7977820,7977824,7977828,7977832,7977836,7977840,7977844,7977848,7977852,7977856,7977860,7977864,7977868,7977872,7977876,7977880,7977884,7977888,7977892,7977896,7977900,7977904,7977908,7977912,7977916,7977920,7977924,7977928,7977932,7977936,7977940,7977944,7977948,7977952,7977956,7977960,7977964,7977968,7977972,7977976,7977980,7977984,7977988,7977992,7977996,7978000,7978004,7978008,7978012,7978016,7978020,7978024,7978028,7978032,7978036,7978040,7978044,7978048,7978052,7978056,7978060,7978064,7978068,7978072,7978076,7978080,7978084,7978088,7978092,7978096,7978100,7978104,7978108,7978112,7978116,7978124,7978128,7978132,8943956,8943996,8944016,8947500,8947520,8947560,8947580,8947620,8947640,8947680,8947700,8947740,8947760,8947800,8947820,8947860,8947880,8947920,8947940,8948220,8948240,8948280,8948300,8948340,8948360,8948400,8948420,8948460,8948480,8948520,8948540,8948580,8948600,8948640,8948660,8948940,8948960,8949000,8949020,8949060,8949080,8949120,8949140,8949180,8949200,8949240,8949260,8949300,8949320,8949360,8949380,8949660,8949680,8949720,8949740,8949780,8949800,8949840,8949860,8949900,8949920,8949960,8949980,8950020},
itemsQuick={{["item"]=0,["tag"]="min",["raw"]=1090519040,["structure"]="natural",["pool"]=4660,["litTop"]=15464784,["hash"]=184029461,["var"]={{5138272,1009739276},{5138276,1021652781},{5138288,1046566761},{5138292,1055185620},{5138296,1046566761},{5138300,1055185620},{5138312,1023705737},{5138316,1031919072},{5412032,1087227388},{8204444,869295867},{8204448,2990707398},{8204460,873491622},{8204464,3045451399},{8204468,821503002},{8204476,577672879},{8204516,881880230},{8204520,3053840007},{8204524,829891610},{8204528,690156753},{8204532,2862028033},{8204536,638283058},{8204540,738988719},{8204544,2810266703},{8204548,586061487},{8204556,893484125},{8204560,872569435},{8204564,954344422},{8204604,906691663},{8204716,903920693},{8204860,3179193512},{8204868,2988514424},{8204872,2996924862},{8204876,970444908},{8204880,3161245558},{8204884,931365284},{8204888,1028502721},{8204892,3217868512},{8204896,901764533},{8204932,946500571},{8204936,3067798814},{8204940,3179193512},{8204976,3209354797},{8204980,1047444432},{8204984,3196706117},{8204988,3196706117},{8204992,3168054646},{8204996,3161069408},{8205000,3146738649},{8205004,3238243603},{8205008,988493309},{8205012,1053637466},{8205016,3202669268},{8205056,946500571},{8205060,3067798814},{8205064,3179193512},{8205092,946500571},{8205096,3067798814},{8205100,3179193512},{8205160,1158321073},{8205164,3284256760},{8205168,3110435164},{8205172,1134164721},{8205176,3260940421},{8205180,3302334942},{8205184,3307808163},{8205188,1126802019},{8205196,1147631410},{8205200,1035366402},{8205204,3096331151},{8205208,1165766252},{8205212,1038884730},{8205216,1157520281},{8205220,3288674534},{8205224,941983670},{8205228,1171023532},{8205232,1010805155},{8205236,1059883140},{8205248,3097714049},{8205252,760147194},{8205260,3247781532},{8205264,3209641431},{8205268,1034244355},{8205280,748788822},{8205284,1037162325},{8205288,3184645964},{8205292,3181456612},{8205296,3102780816},{8205300,3124398010},{8205304,931790860},{8205312,962641320},{8205320,3168054646},{8205324,3146738649},{8205328,3238243603},{8205332,3238243592},{8205336,988493309},{8205340,1053637466},{8205344,3110435164},{8205348,3054175311},{8205356,958560827},{8205368,3179151918},{8205372,3179235107},{8205472,829890401},{8205476,906356359},{8205480,2977376467},{8205488,881880229},{8205492,3053840007},{8205496,3029363879},{8206876,1033864934},{8206880,3242461400},{8206900,3146943239},{8206904,3234852191},{8206924,1116854376},{8206928,999458325},{8206948,3171146098},{8206952,1125318898},{8206960,3146944177},{8206964,1118831448},{8206968,3171146136},{8206972,1140323210},{8206976,1043680067},{8206980,3265521064},{8206984,3234852187},{8206988,999447575},{8206992,1125318898},{8206996,1043680050},{8207000,1160333228},{8207004,1065253932},{8207020,3261463695},{8207024,1065254017},{8207048,3057161882},{8207052,3145920782},{8207080,1029493753},{8207084,909615067},{8207108,3084051824},{8207112,1038833681},{8207120,3146943239},{8207128,1116854375},{8207132,3171140305},{8207136,1140194381},{8207140,968909269},{8207144,3182805355},{8207148,3234852191},{8207156,999458315},{8207160,1125320940},{8207164,1043910760},{8207168,1160263911},{8207172,969206887},{8207188,3263318473},{8207192,1065511248},{8207196,1164853866},{8207200,983780715},{8207224,1044303435},{8207228,3191787086},{8207240,989466320},{8207244,3136949968},{8207264,932969090},{8207316,3080452738},{8207372,983780715},{8207376,962332145},{8207384,3131264525},{8207388,3109817082},{8208096,3175226268},{8208108,3175126809},{8208124,3175730395},{8208144,3175729356},{8208160,923055130},{8208164,812787599},{8208196,3188970438},{8208200,892923576},{8208204,3255037737},{8208208,1025309075},{8208212,3220787318},{8208216,897975216},{8208284,3091008504},{8208288,3070163103},{8208292,3161069375},{8208352,3107620485},{8208360,981259196},{8210132,1000155791},{8210140,3171136278},{8210144,909563625},{8210152,3240148908},{8210156,3219487926},{8210160,874906410},{8210168,1088593783},{8210172,839847656},{8210176,1081060777},{8210180,1074550780},{8210184,3014034557},{8210204,908515371},{8210208,956478331},{8210212,1140193809},{8210224,3240148908},{8210228,1072004602},{8210232,864217253},{8210240,1065511719},{8210244,3031400147},{8210248,1084320070},{8210256,850042978},{8210272,2993718749},{8210276,965630556},{8210280,3171189385},{8210284,3194050409},{8210288,3194050409},{8210292,1017519812},{8210300,909512069},{8210304,3068344747},{8210308,1158082284},{8210312,3175729356},{8210316,1009739276},{8210324,3119600732},{8210328,1039668920},{8210336,2883970665},{8210344,1105162257},{8210348,946348167},{8210352,2776819980},{8210364,2867645849},{8210368,1084372673},{8210376,600822744},{8210380,3080757253},{8210388,741764145},{8210392,3088681614},{8210400,3145815101},{8210412,3057152766},{8210420,1033535271},{8210424,889412720},{8210428,879835078},{8210432,1165566587},{8210436,3079469372},{8210444,3048453790},{8210452,3036803278},{8210476,3182804242},{8210484,1158083495},{8210488,3264784763},{8210492,3119600732},{8210500,1038833672},{8210504,3010153408},{8210508,3062132221},{8210512,1073672086},{8210516,941430869},{8210528,969207567},{8210532,1160263945},{8210536,3263317748},{8210540,1068385000},{8210548,3229270507},{8210556,1043910862},{8210560,1029480546},{8210564,3219587357},{8211752,1070282676},{8211756,3208949456},{8211760,1040741471},{8211764,855980103},{8211812,869295867},{8211816,3066939763},{8211820,2990707398},{8211824,3070333977},{8211832,3178498308},{8211836,873491622},{8211840,3045451399},{8211844,821503002},{8211852,958492450},{8211856,3123692863},{8211860,909744484},{8211888,965321641},{8211892,1041196053},{8211904,906360372},{8211908,952749361},{8211912,965335886},{8211916,1041211633},{8211928,906348278},{8211932,952645960},{8211940,961659770},{8211944,1037133993},{8211948,3029005993},{8211952,3105496487},{8211960,885507335},{8211964,953687608},{8211972,885506673},{8211976,953686496},{8211980,983129319},{8211984,1059873636},{8211988,3063366559},{8211992,3131286532},{8211996,903920693},{8212000,972234637},{8212004,893487912},{8212008,965448097},{8212012,872571477},{8212016,948897923},{8212020,954344422},{8212024,1029727210},{8212028,3066939763},{8212032,3070333977},{8212036,3178498308},{8212040,958492450},{8212044,3123692863},{8212048,909744484},{8212052,869295867},{8212056,2990707398},{8212064,869295867},{8212068,2990707398},{8212080,873491622},{8212084,3045451399},{8212088,821503002},{8212096,2977376467},{8212100,3053840007},{8212104,829890401},{8212112,3029363879},{8212116,906356359},{8212120,881880229},{8212132,2977376467},{8212136,3053840007},{8212140,829890401},{8212148,3029363879},{8212152,906356359},{8212156,881880229},{8212164,3066939763},{8212168,3070333977},{8212172,3178498308},{8212176,958492450},{8212180,3123692863},{8212184,909744484},{8212192,2977376467},{8212196,3053840007},{8212200,829890401},{8212208,3029363879},{8212212,906356359},{8212216,881880229},{8212228,851030615},{8212240,851030615},{8212252,2977376467},{8212256,3053840007},{8212260,829890401},{8212268,3029363879},{8212272,906356359},{8212276,881880229},{8212288,2977376467},{8212292,3053840007},{8212296,829890401},{8212304,3029363879},{8212308,906356359},{8212312,881880229},{8212320,950184149},{8212324,926430681},{8212328,3178532485},{8212332,958492450},{8212336,3123692863},{8212340,909744484},{8212348,2977376467},{8212352,3053840007},{8212356,829890401},{8212364,3029363879},{8212368,906356359},{8212372,881880229},{8212384,2980572892},{8212388,1052598778},{8212396,2980572892},{8212400,1052598778},{8212408,2977376467},{8212412,3053840007},{8212416,829890401},{8212424,3029363879},{8212428,906356359},{8212432,881880229},{8212444,2977376467},{8212448,3053840007},{8212452,829890401},{8212460,3029363879},{8212464,906356359},{8212468,881880229},{8212476,937740786},{8212480,3065404420},{8212484,3178849287},{8212488,958492450},{8212492,3123692863},{8212496,909744484},{8212500,1041196053},{8212504,965321641},{8212512,3143595885},{8212516,1041028216},{8212520,858669063},{8212528,1019939605},{8212532,3188514703},{8212536,3167296730},{8212552,1050379949},{8212564,1050388671},{8212572,3143595885},{8212576,1041028216},{8212580,858669063},{8212588,1019939605},{8212592,3188514703},{8212596,3167296730},{8212612,3143595885},{8212616,1036425797},{8212620,1041028217},{8212624,1061388571},{8212628,858669063},{8212632,1028787002},{8212640,1022753663},{8212644,1019939606},{8212648,3214607635},{8212652,3188514703},{8212660,3167296730},{8212676,1006981954},{8212680,985560527},{8212684,1034411240},{8212688,958365706},{8212692,3123699509},{8212696,922007210},{8212708,3157954168},{8212712,3173857324},{8212716,999471065},{8212724,3190020037},{8212732,1042513375},{8212748,1050388671},{8212760,1050388671},{8212788,3157954168},{8212792,3173857324},{8212796,999471065},{8212804,3190020037},{8212812,1042513375},{8212844,1018879134},{8212848,1015219003},{8212852,1033815644},{8212856,958284268},{8212860,3123566868},{8212864,953749099},{8212868,952749361},{8212876,3148914489},{8212880,3174172235},{8212884,999471065},{8212892,3165426848},{8212900,1017827824},{8212916,1050388671},{8212928,1050388671},{8212932,906360372},{8212940,3148914489},{8212944,3174172235},{8212948,999471065},{8212956,3165426848},{8212964,1017827824},{8212996,1018879134},{8213000,1000695087},{8213004,1034013115},{8213008,958284268},{8213012,3122050299},{8213016,925569735},{8213020,1041211633},{8213024,965335886},{8213032,996112200},{8213036,1041028217},{8213040,858669063},{8213048,3167423538},{8213052,3188514703},{8213056,1019813366},{8213084,1050991289},{8213092,996112200},{8213096,1041028217},{8213100,858669063},{8213108,3167423538},{8213112,3188514703},{8213116,1019813366},{8213132,996112201},{8213136,1034016013},{8213140,1041028217},{8213148,858669063},{8213152,1032680498},{8213164,3167423537},{8213172,3188514703},{8213180,1019813366},{8213196,1007008614},{8213200,3132887246},{8213204,1034410734},{8213208,958365706},{8213212,3123679139},{8213216,942276668},{8213228,1010470494},{8213232,3173857320},{8213236,3146954750},{8213244,1042536353},{8213252,3189996994},{8213268,1050991289},{8213280,1050991289},{8213308,1010470494},{8213312,3173857320},{8213316,3146954750},{8213324,1042536353},{8213332,3189996994},{8213364,1018891879},{8213368,3162692205},{8213372,1033815014},{8213376,958696888},{8213380,3123521809},{8213384,3102272604},{8213388,952645960},{8213396,1001430794},{8213400,3174172230},{8213404,3146954750},{8213412,1017942904},{8213420,3165311272},{8213436,1050991289},{8213448,1050991289},{8213452,906348278},{8213460,1001430794},{8213464,3174172230},{8213468,3146954750},{8213476,1017942904},{8213484,3165311272},{8213516,1018891879},{8213520,3148138768},{8213524,1034012127},{8213528,958696888},{8213532,3122036693},{8213536,3080155891},{8213540,1037133993},{8213544,3105496487},{8213548,961659770},{8213556,2971659759},{8213560,3188067300},{8213564,3003641507},{8213572,3028957820},{8213576,1040583650},{8213580,881541986},{8213592,861969402},{8213596,1042681974},{8213604,861954904},{8213612,3029005993},{8213624,3029005993},{8213628,881522345},{8213636,856131650},{8213640,3188067301},{8213644,3003641507},{8213652,817638656},{8213656,1040583650},{8213660,826239872},{8213672,714011347},{8213676,2971659759},{8213680,1048828273},{8213684,857143865},{8213688,3188067299},{8213692,824949660},{8213700,3003641507},{8213704,3175269786},{8213720,3028957820},{8213728,881863522},{8213732,1040583650},{8213736,2886161402},{8213740,881541986},{8213748,3029265870},{8213764,3154032547},{8213768,937875173},{8213772,1026324684},{8213776,919200128},{8213780,3123692862},{8213784,3079802624},{8213788,953687608},{8213796,3130100451},{8213800,3188067301},{8213804,982699593},{8213812,817638656},{8213816,1040583644},{8213820,3105471989},{8213852,885507335},{8213860,3130100451},{8213864,3188067301},{8213868,982699593},{8213876,817638656},{8213880,1040583644},{8213884,3105471989},{8213916,881522345},{8213920,2946458230},{8213924,3029005988},{8213932,3154135172},{8213936,940935026},{8213940,1026325924},{8213944,917548608},{8213948,3121922532},{8213952,3079802624},{8213956,953686496},{8213964,982617347},{8213968,3188067301},{8213972,3130183789},{8213980,817638656},{8213984,1040583643},{8213988,957988725},{8214020,885506673},{8214028,982617347},{8214032,3188067301},{8214036,3130183789},{8214044,817638656},{8214048,1040583643},{8214052,957988725},{8214084,881522345},{8214088,798974584},{8214092,3029005988},{8214100,3154163966},{8214104,932686807},{8214108,1026323442},{8214112,920851630},{8214116,3121922439},{8214120,3079802624},{8214124,1059873636},{8214132,3021882565},{8214136,3053840007},{8214140,874398954},{8214148,3029363879},{8214152,3053840007},{8214156,3029363888},{8214164,869295867},{8214168,2990707398},{8214176,869295867},{8214180,2990707398},{8214188,983129319},{8214196,3021882565},{8214200,3053840007},{8214204,874398954},{8214212,3029363879},{8214216,3053840007},{8214220,3029363888},{8214232,3021882565},{8214236,3053840007},{8214240,874398954},{8214248,3029363879},{8214252,3053840007},{8214256,3029363888},{8214264,919717525},{8214268,922867953},{8214272,3178498308},{8214280,976209214},{8214284,909744484},{8214288,3131286532},{8214296,3021882565},{8214300,3053840007},{8214304,874398954},{8214312,3029363879},{8214316,3053840007},{8214320,3029363888},{8214328,869295867},{8214332,2990707398},{8214340,869295867},{8214344,2990707398},{8214352,3063366559},{8214360,3021882565},{8214364,3053840007},{8214368,874398954},{8214376,3029363879},{8214380,3053840007},{8214384,3029363888},{8214396,3021882565},{8214400,3053840007},{8214404,874398954},{8214412,3029363879},{8214416,3053840007},{8214420,3029363888},{8214428,919717525},{8214432,922867953},{8214436,3178498308},{8214440,3132609000},{8214444,976209214},{8214448,909744484},{8214452,972234637},{8214460,3021882565},{8214464,3053840007},{8214468,874398954},{8214476,3029363879},{8214480,3053840007},{8214484,3029363888},{8214492,869295867},{8214496,2990707398},{8214504,869295867},{8214508,2990707398},{8214516,903920693},{8214524,3021882565},{8214528,3053840007},{8214532,874398954},{8214540,3029363879},{8214544,3053840007},{8214548,3029363888},{8214560,3021882565},{8214564,3053840007},{8214568,874398954},{8214576,3029363879},{8214580,3053840007},{8214584,3029363888},{8214592,919717525},{8214596,922867953},{8214600,3178498308},{8214604,966944760},{8214608,976209214},{8214612,909744484},{8214616,965448097},{8214620,948897923},{8214624,1029727210},{8214628,893487912},{8214632,872571477},{8214636,954344422},{8214644,2977376467},{8214648,3053840007},{8214652,829890401},{8214660,3029363879},{8214664,906356359},{8214668,881880229},{8214676,1028443147},{8214680,3020055892},{8214692,2922352640},{8214704,2977376467},{8214708,3053840007},{8214712,829890401},{8214720,3029363879},{8214724,906356359},{8214728,881880229},{8214740,2977376467},{8214748,3053840007},{8214752,872571477},{8214756,829890401},{8214768,3029363879},{8214772,3175927182},{8214776,906356359},{8214780,3020055125},{8214784,881880229},{8214788,1028443534},{8214796,3078364533},{8214800,3056218332},{8214804,3147566997},{8214808,958492450},{8214812,3123692863},{8214816,909744484},{8214836,3175226268},{8214860,3175126809},{8214868,3267067998},{8214872,1037503783},{8214884,3175730395},{8214892,3267067997},{8214896,3184987969},{8214908,3175729357},{8214916,1102016520},{8214920,3298015524},{8214924,3264223526},{8214928,3135081422},{8214932,3331492474},{8214936,1008872658},{8214940,3140386864},{8214944,3116119857},{8214952,3131062190},{8214956,3106721615},{8214968,3269767269},{8214980,1122283579},{8214988,3266103933},{8214992,3107161088},{8214996,1162886540},{8215000,1158083578},{8215004,1158082200},{8215008,1039668919},{8215016,941430869},{8215020,1027618819},{8215024,3151502827},{8215028,1027520328},{8215032,1003908437},{8215036,1036634827},{8215040,3163729318},{8215044,3146961465},{8215048,3237239624},{8215052,869295867},{8215056,2990707398},{8215068,2977376467},{8215072,3053840007},{8215076,829890401},{8215084,3029363879},{8215088,906356359},{8215092,881880229},{8215100,3151490928},{8215104,3154638843},{8215108,3263170800},{8215112,1033142696},{8215116,3218259459},{8215120,1005865883},{8215124,3264223526},{8215128,3135081422},{8215132,3331492474},{8215136,1102016520},{8215140,3298015524},{8215144,1008872658},{8215152,851030615},{8215164,2977376467},{8215168,3053840007},{8215172,829890401},{8215180,3029363879},{8215184,906356359},{8215188,881880229},{8215200,851030615},{8215212,2977376467},{8215216,3053840007},{8215220,829890401},{8215228,3029363879},{8215232,906356359},{8215236,881880229},{8215244,1009577320},{8215248,985913007},{8215252,3238133576},{8215256,3140386864},{8215260,3116119857},{8215272,2980572892},{8215276,1052598778},{8215284,2977376467},{8215288,3053840007},{8215292,829890401},{8215300,3029363879},{8215304,906356359},{8215308,881880229},{8215320,2980572892},{8215324,1052598778},{8215332,2977376467},{8215336,3053840007},{8215340,829890401},{8215348,3029363879},{8215352,906356359},{8215356,881880229},{8215364,987714172},{8215368,3115450511},{8215372,3228790413},{8215376,981212782},{8215380,3146334491},{8215384,932244964},{8215388,3131062190},{8215392,3106721615},{8215408,1050379949},{8215416,3143595885},{8215420,1041028216},{8215424,858669063},{8215432,1019939605},{8215436,3188514703},{8215440,3167296730},{8215456,1050388671},{8215464,3143595885},{8215468,1041028216},{8215472,858669063},{8215480,1019939605},{8215484,3188514703},{8215488,3167296730},{8215496,1158083578},{8215508,1050388671},{8215516,3157954168},{8215520,3173857324},{8215524,999471065},{8215532,3190020037},{8215540,1042513375},{8215556,1050388671},{8215564,3157954168},{8215568,3173857324},{8215572,999471065},{8215580,3190020037},{8215588,1042513375},{8215596,1070938564},{8215600,1066762034},{8215604,1085615373},{8215608,956728533},{8215612,3096122385},{8215616,951615348},{8215624,3269767269},{8215632,1027618819},{8215636,3151502827},{8215648,1050388671},{8215656,3148914489},{8215660,3174172235},{8215664,999471065},{8215672,3165426848},{8215680,1017827824},{8215696,1050388671},{8215704,3148914489},{8215708,3174172235},{8215712,999471065},{8215720,3165426848},{8215728,1017827824},{8215736,3129006782},{8215756,3175226268},{8215780,996112200},{8215784,1041028217},{8215788,858669063},{8215796,3167423538},{8215800,3188514703},{8215804,1019813366},{8215820,1050991289},{8215828,996112200},{8215832,1041028217},{8215836,858669063},{8215844,3167423538},{8215848,3188514703},{8215852,1019813366},{8215860,1158082200},{8215872,1050991289},{8215880,1010470494},{8215884,3173857320},{8215888,3146954750},{8215896,1042536353},{8215904,3189996994},{8215920,1050991289},{8215928,1010470494},{8215932,3173857320},{8215936,3146954750},{8215944,1042536353},{8215952,3189996994},{8215960,1070953107},{8215964,3214233763},{8215968,1085614654},{8215972,957079260},{8215976,3096086337},{8215980,3099982876},{8215988,1122283579},{8215996,1027520328},{8216000,1003908437},{8216012,1050991289},{8216020,1001430794},{8216024,3174172230},{8216028,3146954750},{8216036,1017942904},{8216044,3165311272},{8216060,1050991289},{8216068,1001430794},{8216072,3174172230},{8216076,3146954750},{8216084,1017942904},{8216092,3165311272},{8216100,3128995149},{8216120,3175126809},{8216132,861969402},{8216136,1042681974},{8216144,2971659759},{8216148,3188067300},{8216152,3003641507},{8216160,3028957820},{8216164,1040583650},{8216168,881541986},{8216180,861954904},{8216192,856131650},{8216196,3188067301},{8216200,3003641507},{8216208,817638656},{8216212,1040583650},{8216216,826239872},{8216224,3204836597},{8216228,988986874},{8216232,1077239149},{8216236,939284960},{8216240,3115304254},{8216244,3098972864},{8216248,3266103933},{8216252,3107161088},{8216256,1162886540},{8216260,1039668919},{8216264,1036634827},{8216284,3130100451},{8216288,3188067301},{8216292,982699593},{8216300,817638656},{8216304,1040583644},{8216308,3105471989},{8216332,3130100451},{8216336,3188067301},{8216340,982699593},{8216348,817638656},{8216352,1040583644},{8216356,3105471989},{8216364,3205652968},{8216368,992649266},{8216372,1078252475},{8216376,921601238},{8216380,3128356848},{8216384,3083152858},{8216388,3267067998},{8216392,1037503783},{8216404,3175730395},{8216428,982617347},{8216432,3188067301},{8216436,3130183789},{8216444,817638656},{8216448,1040583643},{8216452,957988725},{8216476,982617347},{8216480,3188067301},{8216484,3130183789},{8216492,817638656},{8216496,1040583643},{8216500,957988725},{8216508,3205685824},{8216512,984420854},{8216516,1078249643},{8216520,924403599},{8216524,3128356694},{8216528,3083152858},{8216532,3267067997},{8216536,3184987969},{8216548,3175729357},{8216556,869295867},{8216560,2990707398},{8216572,3021882565},{8216576,3053840007},{8216580,874398954},{8216588,3029363879},{8216592,3053840007},{8216596,3029363888},{8216604,869295867},{8216608,2990707398},{8216620,3021882565},{8216624,3053840007},{8216628,874398954},{8216636,3029363879},{8216640,3053840007},{8216644,3029363888},{8216660,869295867},{8216664,2990707398},{8216676,3021882565},{8216680,3053840007},{8216684,874398954},{8216692,3029363879},{8216696,3053840007},{8216700,3029363888},{8216708,869295867},{8216712,2990707398},{8216724,3021882565},{8216728,3053840007},{8216732,874398954},{8216740,3029363879},{8216744,3053840007},{8216748,3029363888},{8216756,3102427679},{8216760,941430869},{8216764,869295867},{8216768,2990707398},{8216780,3021882565},{8216784,3053840007},{8216788,874398954},{8216796,3029363879},{8216800,3053840007},{8216804,3029363888},{8216812,869295867},{8216816,2990707398},{8216828,3021882565},{8216832,3053840007},{8216836,874398954},{8216844,3029363879},{8216848,3053840007},{8216852,3029363888},{8216860,941353197},{8216864,1028443147},{8216868,3020055892},{8216880,2977376467},{8216884,3053840007},{8216888,829890401},{8216896,3029363879},{8216900,906356359},{8216904,881880229},{8216916,2922352640},{8216928,2977376467},{8216932,3053840007},{8216936,829890401},{8216944,3029363879},{8216948,906356359},{8216952,881880229},{8216960,3091011096},{8216964,3070183754},{8216968,3161069408},{8216972,3163729318},{8216976,3146961465},{8216980,3237239624},{8216984,3203452707},{8216988,3138672184},{8216992,3264785058},{8216996,1033776505},{8217000,3240702079},{8217004,996948585},{8217008,3063618717},{8217012,3039251842},{8217020,3054398051},{8217024,3029965781},{8217044,1086294997},{8217048,1051666814},{8217052,1031409643},{8217072,981414764},{8217076,3104798452},{8217096,3129006781},{8217104,1086294419},{8217108,1051666812},{8217112,3178892775},{8217120,1053509467},{8217132,981391726},{8217136,957301848},{8217156,3128995148},{8217168,896485403},{8217172,1091550838},{8217176,958631357},{8217180,3179948470},{8217184,849791624},{8217188,3198593706},{8217192,968829396},{8217204,3107621103},{8217212,3198593706},{8217216,3116312462},{8217228,3107620485},{8217240,2938101855},{8217244,866990642},{8217248,873543339},{8217272,3091011082},{8217276,3070183726},{8217280,3161069396},{8217288,3058919668},{8217292,1090097668},{8217296,3146937017},{8217300,3234684372},{8217304,3079067119},{8217308,3059074123},{8217316,951699213},{8217320,1116843850},{8217324,999375562},{8217332,1090097666},{8217336,952189318},{8217344,3171140928},{8217348,1125318919},{8217352,3098439168},{8217356,3146936941},{8217360,1118820921},{8217364,3171139947},{8217368,3234684375},{8217372,999365497},{8217376,1125318919},{8217380,3082745792},{8217388,3098967188},{8217416,1140322377},{8217420,3265518332},{8217424,1160333257},{8217428,3261458231},{8217436,3070713410},{8217440,981514411},{8217444,943210864},{8217484,1043680136},{8217488,1043680119},{8217492,1065254886},{8217496,1065254976},{8217500,923217559},{8217504,981502791},{8217508,3090677914},{8217552,2801371988},{8217572,2883970665},{8217588,2807805283},{8217592,2899043360},{8217600,914629838},{8217604,2773457532},{8217608,2812637475},{8217620,872716766},{8217644,2760504896},{8217664,2770898384},{5286640,1063097548},{5287048,3175102468},{5287096,1049896866},{5287100,966168090},{5287104,1090955476},{5287108,927646967},{5287112,3357261186},{5287132,1017871353},{5287140,1007521063},{5287148,940609238},{5288980,3177722792},{5288984,1017137915},{5288988,996663703},{5288992,1034148320},{5289665,3175003977},{5289749,3165354871},{5289765,940535168},{5291597,3172901856},{5291601,3214408787},{5291605,3209074624},{5291609,1040971717},{5292282,3175730387},{5292366,3105471989},{5292382,961778593},{5294218,3214682474},{5294222,1061534292},{5294226,1034074467},{5294899,3175729348},{5294983,957988725},{5294999,961778394},{5296835,1070282676},{5296839,3208949456},{5296843,1040741471}}},{["item"]=2,["tag"]="min",["raw"]=1090519040,["structure"]="generic",["pool"]=4711,["litTop"]=15464700,["hash"]=3315873510,["var"]={{5138272,1013828302},{5138276,1023727315},{5138288,1046908338},{5138292,1055420294},{5138296,1046908338},{5138300,1055420294},{5138312,1023551591},{5138316,1031851947},{5412032,1087225645},{5412044,1109852792},{7977504,3217885780},{7977508,3208965645},{7977512,3183514108},{7978124,3217885780},{7978128,3208965645},{7978132,3183514108},{8204292,3217866025},{8204296,1061448849},{8204300,3185908014},{8204304,3217866025},{8204308,1061448849},{8204312,3185908014},{8204444,869144436},{8204448,3029565917},{8204460,860707670},{8204464,3045604236},{8204468,868589782},{8204476,672698606},{8204516,869096278},{8204520,3053992844},{8204524,876978390},{8204528,665107304},{8204532,2849673365},{8204536,673089613},{8204540,739311269},{8204544,2857522900},{8204548,681087214},{8204556,893753642},{8204560,883137204},{8204564,954343487},{8204604,954094833},{8204660,3164205239},{8204676,3164071909},{8204684,3164205239},{8204688,3164071909},{8204696,986216742},{8204704,1065352070},{8204712,3158165825},{8204716,904364041},{8204720,3188066566},{8204724,1010790131},{8204728,1065207714},{8204752,1065352117},{8204760,992805514},{8204764,1065352059},{8204768,3158008385},{8204772,1065353158},{8204776,3140289906},{8204788,992806258},{8204792,1065353158},{8204804,3158008385},{8204808,985555400},{8204812,1044582184},{8204816,1043049360},{8204820,1052253117},{8204828,1052253164},{8204832,3138308437},{8204836,3175142827},{8204840,989691340},{8204844,3199632953},{8204860,3179192728},{8204864,2988514463},{8204868,2988514420},{8204872,2996924862},{8204876,970704325},{8204880,3161144426},{8204884,981610887},{8204888,1028503949},{8204892,3217868495},{8204896,901995126},{8204900,3209036585},{8204932,946330211},{8204936,3106271768},{8204940,3179192728},{8204964,0},{8204976,3209249915},{8204980,1049255879},{8204984,3196847487},{8204988,3196847487},{8204992,3168350818},{8204996,3161068440},{8205000,3157513706},{8205004,3238243059},{8205008,999520022},{8205012,1053629006},{8205016,3202903942},{8205048,1089774656},{8205052,3290665187},{8205056,946330211},{8205060,3106271768},{8205064,3179192728},{8205092,946330211},{8205096,3106271768},{8205100,3179192728},{8205160,1158321383},{8205164,3284254256},{8205168,3121602133},{8205172,1134165066},{8205176,3260940917},{8205180,3302335420},{8205184,3307808541},{8205188,1126802398},{8205196,1147631487},{8205200,1095467812},{8205204,3085929352},{8205208,1165764741},{8205212,1038883774},{8205216,1157520366},{8205220,3288673736},{8205224,1111373265},{8205228,1171032103},{8205232,3264670947},{8205236,1059881465},{8205240,3250191104},{8205244,913019445},{8205248,3098036329},{8205252,760555408},{8205260,3247781376},{8205264,3209641216},{8205268,1034244360},{8205280,749435972},{8205284,1037576237},{8205288,3185059876},{8205292,3181665599},{8205296,3103255554},{8205300,3124765992},{8205304,932055741},{8205312,963084744},{8205320,3168350818},{8205324,3157513706},{8205328,3238243059},{8205332,3238243048},{8205336,999520022},{8205340,1053629006},{8205344,3121602133},{8205348,3101578481},{8205356,946276033},{8205368,3179177943},{8205372,3179207514},{8205460,0},{8205472,876978383},{8205476,906509196},{8205480,3024462045},{8205488,869096251},{8205492,3053992844},{8205496,3016579953},{8205760,1051137228},{8205768,2998926501},{8205772,1129666615},{8205784,3223202975},{8205796,1051137228},{8205804,2998926501},{8205808,1129666615},{8205820,3223202975},{8205828,3211875620},{8205832,1034704605},{8205836,3187702287},{8205864,1129427999},{8205868,1119394938},{8205872,1051136480},{8205876,1105034053},{8205880,1035090615},{8205884,1078327983},{8205888,3207730656},{8205892,1051136480},{8205896,1129665659},{8205900,3223202267},{8205904,1109868172},{8205908,3229633111},{8205912,3282716392},{8205916,1105034053},{8205920,3223202267},{8205924,1080807759},{8205928,3203821154},{8205932,1055478323},{8205936,1081803473},{8205940,1038187167},{8205944,1113822047},{8205948,3207066115},{8205952,1078327996},{8205956,3229633111},{8205960,1055478328},{8205964,3207679614},{8205968,3282651135},{8205972,1081706707},{8205976,3229734503},{8205980,1067222294},{8205984,1119500783},{8206000,1113823066},{8206004,3229734503},{8206008,1078466555},{8206016,1067222294},{8206020,3282651892},{8206024,1119500783},{8206052,1113823066},{8206056,1078466555},{8206064,3282651892},{8206080,1095510331},{8206084,3268281866},{8206088,1066475371},{8206092,3265074782},{8206096,1142829500},{8206116,995164174},{8206120,1049780913},{8206124,1103177848},{8206128,3167083470},{8206132,995164174},{8206136,1049780913},{8206140,1103177848},{8206144,3167083470},{8206160,3214606683},{8206164,3211621021},{8206168,1089415422},{8206172,1089336932},{8206188,3242505862},{8206192,1066170825},{8206196,1019127470},{8206212,3242505862},{8206216,3229633685},{8206228,1066170825},{8206232,3191110873},{8206284,1019127470},{8206300,3229633685},{8206308,3191110873},{8206656,3166610055},{8206664,3245566850},{8206668,2977954694},{8206672,2998926501},{8206684,3166610055},{8206692,3074316597},{8206708,3245566850},{8206712,2977954694},{8206716,2998926501},{8206720,1043626210},{8206728,3049850920},{8206776,3074316597},{8206792,1043626210},{8206800,3049850920},{8206860,3200639514},{8206864,3187938520},{8206868,3265228535},{8206872,1027464655},{8206876,3242491798},{8206880,1045589056},{8206884,1154171282},{8206888,1051136436},{8206892,1090088288},{8206896,1035090231},{8206900,3236116911},{8206904,3207731104},{8206908,1051136435},{8206912,1154222886},{8206916,3223202286},{8206920,1116932754},{8206924,3229633103},{8206928,3281769227},{8206932,1090088284},{8206936,3223202271},{8206940,1151333057},{8206944,3203821166},{8206948,1125293937},{8206952,1081803461},{8206956,1038186719},{8206960,1118909691},{8206964,3207066122},{8206968,1140344039},{8206972,3214606681},{8206976,3266127833},{8206980,3236116908},{8206984,3229633113},{8206988,1125293937},{8206992,3211621024},{8206996,1160333928},{8207000,1089415422},{8207004,3207680126},{8207008,3281703970},{8207012,1081706689},{8207016,3262672984},{8207020,1089336943},{8207024,1165119423},{8207032,1154171282},{8207036,961702963},{8207040,1000149882},{8207044,948829583},{8207048,3146717234},{8207052,3118420889},{8207060,1051136436},{8207068,1154222885},{8207072,3133575202},{8207076,1029592176},{8207080,3139495549},{8207084,3192013012},{8207088,1090088288},{8207096,3223208847},{8207100,1151332719},{8207104,3117811348},{8207108,1038793093},{8207112,992991096},{8207116,1035090231},{8207124,1116932751},{8207128,3200097954},{8207132,1140213266},{8207136,3132843294},{8207140,3184017772},{8207144,3236116911},{8207152,3229630115},{8207156,1125295769},{8207160,3211714434},{8207164,1160264907},{8207168,991341080},{8207172,3207731104},{8207176,3281769223},{8207180,1079837227},{8207184,3263910402},{8207188,1086765547},{8207192,1164849268},{8207196,984008175},{8207220,1044302646},{8207224,3191786297},{8207236,989766900},{8207240,3137250548},{8207260,920504634},{8207312,3067988282},{8207368,984008175},{8207372,973736888},{8207380,3131491985},{8207384,3121220859},{8208076,1102707472},{8208092,3176153570},{8208104,3176326583},{8208120,3176388546},{8208140,3176387590},{8208156,923480762},{8208160,2956710901},{8208192,3188976595},{8208196,3181972049},{8208200,3255037584},{8208204,1016441913},{8208208,3220928008},{8208212,1040591242},{8208280,3091271768},{8208284,3080706712},{8208288,3161068408},{8208316,0},{8208348,3107988407},{8208356,981612549},{8210132,1000150817},{8210136,3045059553},{8210140,3200085103},{8210144,929791132},{8210152,3240148905},{8210156,3219488032},{8210160,874906419},{8210168,1085844057},{8210172,853187500},{8210176,1084320022},{8210180,1074532023},{8210184,3016413901},{8210192,1118871353},{8210196,3034937934},{8210204,929529069},{8210208,956627516},{8210212,1140212692},{8210224,3240148905},{8210228,1072004496},{8210232,864217319},{8210236,1049780912},{8210240,1086765952},{8210244,3031400167},{8210248,1084320041},{8210252,3222015670},{8210256,850043085},{8210272,3118429873},{8210276,965793040},{8210280,3171035239},{8210284,3194391986},{8210288,3194391986},{8210292,1000830486},{8210296,3192013018},{8210300,3139495624},{8210304,941097624},{8210308,1158082833},{8210312,3176387590},{8210316,1013828302},{8210324,3119966544},{8210328,1030408110},{8210332,1119500781},{8210336,724346813},{8210340,1129666615},{8210344,1105162262},{8210348,3223202886},{8210352,2818635803},{8210364,708303228},{8210368,1078645624},{8210372,3229633683},{8210376,2823737403},{8210380,3191144170},{8210384,3282652074},{8210388,2877870551},{8210392,3076149764},{8210400,3146611546},{8210412,948828572},{8210420,1021117304},{8210424,936516218},{8210428,927000563},{8210432,1165566120},{8210436,3066590031},{8210440,1103178056},{8210444,3167101934},{8210448,3245566849},{8210452,908942448},{8210476,3184016731},{8210484,1158083197},{8210488,3264784753},{8210492,3119966544},{8210496,1151332723},{8210500,1038793081},{8210504,992991015},{8210508,1043626109},{8210512,1073672092},{8210516,941943272},{8210528,991341326},{8210532,1160264941},{8210536,3263909691},{8210540,1067247836},{8210548,3229728171},{8210556,3211705108},{8210560,1029578968},{8210564,3219991518},{8211740,3217885780},{8211744,3208965645},{8211748,3183514108},{8211752,1070273534},{8211756,3208917091},{8211760,1042038263},{8211764,3139064960},{8211768,3217337679},{8211772,1016208584},{8211812,869144436},{8211816,3067910151},{8211820,3029565917},{8211824,3105135467},{8211832,3178497543},{8211836,860707670},{8211840,3045604236},{8211844,868589782},{8211852,948711068},{8211856,3124003049},{8211860,952518451},{8211888,965325445},{8211892,1041199603},{8211904,906492515},{8211908,953713418},{8211912,965329035},{8211916,1041204954},{8211928,906521739},{8211932,953893289},{8211936,3196619820},{8211940,961663607},{8211944,1037137693},{8211948,3018456290},{8211952,3096963252},{8211960,885901489},{8211964,954392456},{8211972,885900700},{8211976,954391432},{8211980,983127830},{8211984,1059872176},{8211988,3063664966},{8211992,3131820285},{8211996,904364041},{8212000,973027642},{8212004,893757494},{8212008,965706782},{8212012,883137563},{8212016,958774448},{8212020,954343487},{8212024,1029726284},{8212028,3067910151},{8212032,3105135467},{8212036,3178497543},{8212040,948711068},{8212044,3124003049},{8212048,952518451},{8212052,869144436},{8212056,3029565917},{8212064,869144436},{8212068,3029565917},{8212080,860707670},{8212084,3045604236},{8212088,868589782},{8212096,3024462045},{8212100,3053992844},{8212104,876978383},{8212112,3016579953},{8212116,906509196},{8212120,869096251},{8212132,3024462045},{8212136,3053992844},{8212140,876978383},{8212148,3016579953},{8212152,906509196},{8212156,869096251},{8212164,3067910151},{8212168,3105135467},{8212172,3178497543},{8212176,948711068},{8212180,3124003049},{8212184,952518451},{8212192,3024462045},{8212196,3053992844},{8212200,876978383},{8212208,3016579953},{8212212,906509196},{8212216,869096251},{8212224,3192025164},{8212228,3030374998},{8212236,3192025164},{8212240,3030374998},{8212252,3024462045},{8212256,3053992844},{8212260,876978383},{8212268,3016579953},{8212272,906509196},{8212276,869096251},{8212288,3024462045},{8212292,3053992844},{8212296,876978383},{8212304,3016579953},{8212308,906509196},{8212312,869096251},{8212320,950433398},{8212324,3105795369},{8212328,3178532640},{8212332,948711068},{8212336,3124003049},{8212340,952518451},{8212348,3024462045},{8212352,3053992844},{8212356,876978383},{8212364,3016579953},{8212368,906509196},{8212372,869096251},{8212384,3039350876},{8212388,1052598776},{8212396,3039350876},{8212400,1052598776},{8212408,3024462045},{8212412,3053992844},{8212416,876978383},{8212424,3016579953},{8212428,906509196},{8212432,869096251},{8212444,3024462045},{8212448,3053992844},{8212452,876978383},{8212460,3016579953},{8212464,906509196},{8212468,869096251},{8212476,937993337},{8212480,3114874625},{8212484,3178857973},{8212488,948711068},{8212492,3124003049},{8212496,952518451},{8212500,1041199603},{8212504,965325445},{8212512,3143596656},{8212516,1041028214},{8212520,877780983},{8212528,1019939711},{8212532,3188514701},{8212536,3167296823},{8212544,1067089356},{8212548,1061466772},{8212552,1050982563},{8212556,1067089658},{8212560,1061466881},{8212572,3143596656},{8212576,1041028214},{8212580,877780983},{8212588,1019939711},{8212592,3188514701},{8212596,3167296823},{8212612,3143596656},{8212616,1034016055},{8212620,1041028214},{8212628,877780983},{8212632,1032680456},{8212640,1022720787},{8212644,1019939711},{8212648,3214586916},{8212652,3188514701},{8212660,3167296823},{8212664,1067108527},{8212672,3181061694},{8212676,1006901802},{8212680,985275529},{8212684,1034411105},{8212688,945759365},{8212692,3124043207},{8212696,951308807},{8212708,3157954362},{8212712,3173857324},{8212716,999471468},{8212720,1065136894},{8212724,3190020026},{8212728,1026716344},{8212732,1042513363},{8212736,1065121858},{8212740,1067089658},{8212744,1061466881},{8212752,1067089658},{8212756,1061466881},{8212788,3157954362},{8212792,3173857324},{8212796,999471468},{8212800,1065136894},{8212804,3190020026},{8212808,1026716344},{8212812,1042513363},{8212816,1065121858},{8212844,1018839620},{8212848,1015202730},{8212852,1033818111},{8212856,948844613},{8212860,3123604266},{8212864,961697023},{8212868,953713418},{8212876,3148914873},{8212880,3174172242},{8212884,999471468},{8212888,1065349320},{8212892,3165426752},{8212896,1026716344},{8212900,1017827728},{8212904,1065333629},{8212908,1067089658},{8212912,1061466881},{8212920,1067089658},{8212924,1061466881},{8212932,906492515},{8212940,3148914873},{8212944,3174172242},{8212948,999471468},{8212952,1065349320},{8212956,3165426752},{8212960,1026716344},{8212964,1017827728},{8212968,1065333629},{8212996,1018839620},{8213000,1000625132},{8213004,1034014992},{8213008,948844613},{8213012,3122198960},{8213016,954097667},{8213020,1041204954},{8213024,965329035},{8213032,996111421},{8213036,1041028215},{8213040,877780983},{8213048,3167423432},{8213052,3188514701},{8213056,1019813273},{8213064,1067089359},{8213068,3208950424},{8213072,1050982559},{8213076,1067089662},{8213080,3208950534},{8213092,996111421},{8213096,1041028215},{8213100,877780983},{8213108,3167423432},{8213112,3188514701},{8213116,1019813273},{8213132,996111422},{8213136,1034016040},{8213140,1041028215},{8213148,877780983},{8213152,1032680472},{8213160,3170204431},{8213164,3167423432},{8213172,3188514701},{8213180,1019813273},{8213196,1007071497},{8213200,3133138381},{8213204,1034410978},{8213208,945759365},{8213212,3123955622},{8213216,956000062},{8213228,1010470308},{8213232,3173857336},{8213236,3146954346},{8213240,1065136895},{8213244,1042536364},{8213248,1026716344},{8213252,3189997006},{8213256,1065121858},{8213260,1067089662},{8213264,3208950534},{8213272,1067089662},{8213276,3208950534},{8213308,1010470308},{8213312,3173857336},{8213316,3146954346},{8213320,1065136895},{8213324,1042536364},{8213328,1026716344},{8213332,3189997006},{8213336,1065121858},{8213364,1018922979},{8213368,3162706764},{8213372,1033813132},{8213376,949692076},{8213380,3124096784},{8213384,3081091771},{8213388,953893289},{8213396,1001430408},{8213400,3174172240},{8213404,3146954346},{8213408,1065349320},{8213412,1017943000},{8213416,1026716344},{8213420,3165311376},{8213428,1067089662},{8213432,3208950534},{8213440,1067089662},{8213444,3208950534},{8213452,906521739},{8213460,1001430408},{8213464,3174172240},{8213468,3146954346},{8213472,1065349320},{8213476,1017943000},{8213480,1026716344},{8213484,3165311376},{8213516,1018922979},{8213520,3148200628},{8213524,1034010770},{8213528,949692076},{8213532,3122231837},{8213536,950110340},{8213540,1037137693},{8213544,3096963252},{8213548,961663607},{8213556,986215362},{8213560,3188066703},{8213564,875986071},{8213568,1065352070},{8213572,1010790003},{8213576,1040583653},{8213580,3158165719},{8213584,1065207709},{8213592,3037811077},{8213596,1042079484},{8213604,904995927},{8213608,1042092796},{8213612,3018456290},{8213624,3018456290},{8213628,870972642},{8213636,986215483},{8213640,3188066703},{8213644,875986071},{8213648,1065352068},{8213652,1010790118},{8213656,1040583653},{8213660,3158165835},{8213664,1065207707},{8213672,883183545},{8213676,986215363},{8213680,1049128904},{8213684,986216863},{8213688,3188066702},{8213692,994850691},{8213696,3188066566},{8213700,875986071},{8213704,3177658976},{8213708,1065352070},{8213712,3164205238},{8213716,1065352068},{8213720,1010790003},{8213724,1070455004},{8213728,1010790247},{8213732,1040583653},{8213736,3055258965},{8213740,3158165719},{8213744,3217760588},{8213748,3158165941},{8213752,1065207709},{8213756,3164071909},{8213760,1065207712},{8213764,3154017687},{8213768,971044690},{8213772,1026325098},{8213776,919624192},{8213780,3124019299},{8213784,950097485},{8213788,954392456},{8213792,1065208863},{8213796,970694912},{8213800,3188066703},{8213804,982700666},{8213808,1065352056},{8213812,1010790118},{8213816,1040582776},{8213820,3158323262},{8213824,1065207707},{8213828,3217866017},{8213832,1061486340},{8213836,1048425515},{8213840,3217866017},{8213844,1061486340},{8213848,1048425515},{8213852,885901489},{8213856,1065208863},{8213860,970694912},{8213864,3188066703},{8213868,982700666},{8213872,1065352056},{8213876,1010790118},{8213880,1040582776},{8213884,3158323262},{8213888,1065207707},{8213916,870972642},{8213920,2936418239},{8213924,3018456280},{8213932,3154207219},{8213936,971326230},{8213940,1026326378},{8213944,917925871},{8213948,3122160866},{8213952,950097485},{8213956,954391432},{8213960,1065208806},{8213964,992804883},{8213968,3188066703},{8213972,3130181400},{8213976,1065352057},{8213980,1010790118},{8213984,1040584517},{8213988,3158008393},{8213992,1065207707},{8213996,3217885731},{8214000,3208929091},{8214004,1049098046},{8214008,3217885731},{8214012,3208929091},{8214016,1049098046},{8214020,885900700},{8214024,1065208806},{8214028,992804883},{8214032,3188066703},{8214036,3130181400},{8214040,1065352057},{8214044,1010790118},{8214048,1040584517},{8214052,3158008393},{8214056,1065207707},{8214084,870972642},{8214088,788934593},{8214092,3018456280},{8214100,3154046013},{8214104,970722913},{8214108,1026323816},{8214112,921322495},{8214116,3122160755},{8214120,950097485},{8214124,1059872176},{8214132,856554964},{8214136,3053992844},{8214140,3004038556},{8214148,3016579953},{8214152,3053992844},{8214156,3016579943},{8214164,869144436},{8214168,3029565917},{8214176,869144436},{8214180,3029565917},{8214188,983127830},{8214196,856554964},{8214200,3053992844},{8214204,3004038556},{8214212,3016579953},{8214216,3053992844},{8214220,3016579943},{8214232,856554964},{8214236,3053992844},{8214240,3004038556},{8214248,3016579953},{8214252,3053992844},{8214256,3016579943},{8214264,920692466},{8214268,957652211},{8214272,3178497543},{8214276,1059871054},{8214280,976519400},{8214284,952518451},{8214288,3131820285},{8214296,856554964},{8214300,3053992844},{8214304,3004038556},{8214312,3016579953},{8214316,3053992844},{8214320,3016579943},{8214328,869144436},{8214332,3029565917},{8214340,869144436},{8214344,3029565917},{8214352,3063664966},{8214360,856554964},{8214364,3053992844},{8214368,3004038556},{8214376,3016579953},{8214380,3053992844},{8214384,3016579943},{8214396,856554964},{8214400,3053992844},{8214404,3004038556},{8214412,3016579953},{8214416,3053992844},{8214420,3016579943},{8214428,920692466},{8214432,957652211},{8214436,3178497543},{8214440,3132394471},{8214444,976519400},{8214448,952518451},{8214452,973027642},{8214460,856554964},{8214464,3053992844},{8214468,3004038556},{8214476,3016579953},{8214480,3053992844},{8214484,3016579943},{8214492,869144436},{8214496,3029565917},{8214504,869144436},{8214508,3029565917},{8214516,904364041},{8214524,856554964},{8214528,3053992844},{8214532,3004038556},{8214540,3016579953},{8214544,3053992844},{8214548,3016579943},{8214560,856554964},{8214564,3053992844},{8214568,3004038556},{8214576,3016579953},{8214580,3053992844},{8214584,3016579943},{8214592,920692466},{8214596,957652211},{8214600,3178497543},{8214604,970730895},{8214608,976519400},{8214612,952518451},{8214616,965706782},{8214620,958774448},{8214624,1029726284},{8214628,893757494},{8214632,883137563},{8214636,954343487},{8214644,3024462045},{8214648,3053992844},{8214652,876978383},{8214660,3016579953},{8214664,906509196},{8214668,869096251},{8214676,1028443142},{8214680,3030621598},{8214688,1028443339},{8214692,2914680832},{8214704,3024462045},{8214708,3053992844},{8214712,876978383},{8214720,3016579953},{8214724,906509196},{8214728,869096251},{8214740,3024462045},{8214748,3053992844},{8214752,883137563},{8214756,876978383},{8214768,3016579953},{8214772,3175927186},{8214776,906509196},{8214780,3030621211},{8214784,869096251},{8214788,1028443538},{8214796,3078667344},{8214800,3067428453},{8214804,3147566352},{8214808,948711068},{8214812,3124003049},{8214816,952518451},{8214836,3176153570},{8214860,3176326583},{8214868,3267066784},{8214872,1090939437},{8214876,3291577785},{8214884,3176388547},{8214892,3267069219},{8214896,1090719221},{8214900,3291577785},{8214908,3176387590},{8214912,0},{8214916,1093358075},{8214920,3298091805},{8214924,3264231149},{8214928,3258597990},{8214932,3331492309},{8214936,1116984369},{8214940,3140586043},{8214944,3104165819},{8214952,3131245066},{8214956,3094722474},{8214964,3254361117},{8214968,3269767252},{8214972,3291517743},{8214976,3254361117},{8214980,1122283596},{8214984,3291517743},{8214988,3266103937},{8214992,1089774520},{8214996,1162886256},{8215000,1158083217},{8215004,1158082812},{8215008,1030408108},{8215012,1102707472},{8215016,941943272},{8215020,1028537096},{8215024,3152535271},{8215028,1028708426},{8215032,1005244247},{8215036,1037293019},{8215040,3163996338},{8215044,3156913607},{8215048,3237238615},{8215052,869144436},{8215056,3029565917},{8215068,3024462045},{8215072,3053992844},{8215076,876978383},{8215084,3016579953},{8215088,906509196},{8215092,869096251},{8215100,3152509170},{8215104,3189501832},{8215108,3263170399},{8215112,1023472848},{8215116,3218631360},{8215120,1048739316},{8215124,3264231149},{8215128,3258597990},{8215132,3331492309},{8215136,1093358075},{8215140,3298091805},{8215144,1116984369},{8215148,3192025164},{8215152,3030374998},{8215164,3024462045},{8215168,3053992844},{8215172,876978383},{8215180,3016579953},{8215184,906509196},{8215188,869096251},{8215196,3192025164},{8215200,3030374998},{8215212,3024462045},{8215216,3053992844},{8215220,876978383},{8215228,3016579953},{8215232,906509196},{8215236,869096251},{8215244,1009842303},{8215248,3165172064},{8215252,3238133658},{8215256,3140586043},{8215260,3104165819},{8215272,3039350876},{8215276,1052598776},{8215284,3024462045},{8215288,3053992844},{8215292,876978383},{8215300,3016579953},{8215304,906509196},{8215308,869096251},{8215320,3039350876},{8215324,1052598776},{8215332,3024462045},{8215336,3053992844},{8215340,876978383},{8215348,3016579953},{8215352,906509196},{8215356,869096251},{8215364,987960688},{8215368,3164941299},{8215372,3228798891},{8215376,970649016},{8215380,3146576707},{8215384,974836852},{8215388,3131245066},{8215392,3094722474},{8215400,1067089356},{8215404,1061466772},{8215408,1050982563},{8215416,3143596656},{8215420,1041028214},{8215424,877780983},{8215432,1019939711},{8215436,3188514701},{8215440,3167296823},{8215448,1067089658},{8215452,1061466881},{8215464,3143596656},{8215468,1041028214},{8215472,877780983},{8215480,1019939711},{8215484,3188514701},{8215488,3167296823},{8215496,1158083217},{8215500,1067089658},{8215504,1061466881},{8215516,3157954362},{8215520,3173857324},{8215524,999471468},{8215528,1065136894},{8215532,3190020026},{8215536,1026716344},{8215540,1042513363},{8215544,1065121858},{8215548,1067089658},{8215552,1061466881},{8215564,3157954362},{8215568,3173857324},{8215572,999471468},{8215576,1065136894},{8215580,3190020026},{8215584,1026716344},{8215588,1042513363},{8215592,1065121858},{8215596,1070893475},{8215600,1066743465},{8215604,1085618188},{8215608,946980367},{8215612,3096152303},{8215616,959629375},{8215620,3254361117},{8215624,3269767252},{8215628,3291517743},{8215632,1028537096},{8215636,3152535271},{8215640,1067089658},{8215644,1061466881},{8215656,3148914873},{8215660,3174172242},{8215664,999471468},{8215668,1065349320},{8215672,3165426752},{8215676,1026716344},{8215680,1017827728},{8215684,1065333629},{8215688,1067089658},{8215692,1061466881},{8215704,3148914873},{8215708,3174172242},{8215712,999471468},{8215716,1065349320},{8215720,3165426752},{8215724,1026716344},{8215728,1017827728},{8215732,1065333629},{8215736,3129133887},{8215756,3176153570},{8215764,1067089359},{8215768,3208950424},{8215772,1050982559},{8215780,996111421},{8215784,1041028215},{8215788,877780983},{8215796,3167423432},{8215800,3188514701},{8215804,1019813273},{8215812,1067089662},{8215816,3208950534},{8215828,996111421},{8215832,1041028215},{8215836,877780983},{8215844,3167423432},{8215848,3188514701},{8215852,1019813273},{8215860,1158082812},{8215864,1067089662},{8215868,3208950534},{8215880,1010470308},{8215884,3173857336},{8215888,3146954346},{8215892,1065136895},{8215896,1042536364},{8215900,1026716344},{8215904,3189997006},{8215908,1065121858},{8215912,1067089662},{8215916,3208950534},{8215928,1010470308},{8215932,3173857336},{8215936,3146954346},{8215940,1065136895},{8215944,1042536364},{8215948,1026716344},{8215952,3189997006},{8215956,1065121858},{8215960,1070988595},{8215964,3214250376},{8215968,1085612507},{8215972,948166879},{8215976,3096546317},{8215980,3079462585},{8215984,3254361117},{8215988,1122283596},{8215992,3291517743},{8215996,1028708426},{8216000,1005244247},{8216004,1067089662},{8216008,3208950534},{8216020,1001430408},{8216024,3174172240},{8216028,3146954346},{8216032,1065349320},{8216036,1017943000},{8216040,1026716344},{8216044,3165311376},{8216052,1067089662},{8216056,3208950534},{8216068,1001430408},{8216072,3174172240},{8216076,3146954346},{8216080,1065349320},{8216084,1017943000},{8216088,1026716344},{8216092,3165311376},{8216100,3129161997},{8216120,3176326583},{8216132,3037811077},{8216136,1042079484},{8216144,986215362},{8216148,3188066703},{8216152,875986071},{8216156,1065352070},{8216160,1010790003},{8216164,1040583653},{8216168,3158165719},{8216172,1065207709},{8216180,904995927},{8216184,1042092796},{8216192,986215483},{8216196,3188066703},{8216200,875986071},{8216204,1065352068},{8216208,1010790118},{8216212,1040583653},{8216216,3158165835},{8216220,1065207707},{8216224,3204828784},{8216228,1022136544},{8216232,1077239584},{8216236,939669568},{8216240,3115630691},{8216244,969518048},{8216248,3266103937},{8216252,1089774520},{8216256,1162886256},{8216260,1030408108},{8216264,1037293019},{8216268,3217866017},{8216272,1061486340},{8216276,1048425515},{8216280,1065208863},{8216284,970694912},{8216288,3188066703},{8216292,982700666},{8216296,1065352056},{8216300,1010790118},{8216304,1040582776},{8216308,3158323262},{8216312,1065207707},{8216316,3217866017},{8216320,1061486340},{8216324,1048425515},{8216328,1065208863},{8216332,970694912},{8216336,3188066703},{8216340,982700666},{8216344,1065352056},{8216348,1010790118},{8216352,1040582776},{8216356,3158323262},{8216360,1065207707},{8216364,3205735180},{8216368,1023593941},{8216372,1078252993},{8216376,922110543},{8216380,3128752483},{8216384,953798171},{8216388,3267066784},{8216392,1090939437},{8216396,3291577785},{8216404,3176388547},{8216412,3217885731},{8216416,3208929091},{8216420,1049098046},{8216424,1065208806},{8216428,992804883},{8216432,3188066703},{8216436,3130181400},{8216440,1065352057},{8216444,1010790118},{8216448,1040584517},{8216452,3158008393},{8216456,1065207707},{8216460,3217885731},{8216464,3208929091},{8216468,1049098046},{8216472,1065208806},{8216476,992804883},{8216480,3188066703},{8216484,3130181400},{8216488,1065352057},{8216492,1010790118},{8216496,1040584517},{8216500,3158008393},{8216504,1065207707},{8216508,3205591507},{8216512,1023089269},{8216516,1078250070},{8216520,924721433},{8216524,3128752299},{8216528,953798171},{8216532,3267069219},{8216536,1090719221},{8216540,3291577785},{8216548,3176387590},{8216552,0},{8216556,869144436},{8216560,3029565917},{8216572,856554964},{8216576,3053992844},{8216580,3004038556},{8216588,3016579953},{8216592,3053992844},{8216596,3016579943},{8216604,869144436},{8216608,3029565917},{8216620,856554964},{8216624,3053992844},{8216628,3004038556},{8216636,3016579953},{8216640,3053992844},{8216644,3016579943},{8216652,1034253427},{8216656,1102707472},{8216660,869144436},{8216664,3029565917},{8216676,856554964},{8216680,3053992844},{8216684,3004038556},{8216692,3016579953},{8216696,3053992844},{8216700,3016579943},{8216708,869144436},{8216712,3029565917},{8216724,856554964},{8216728,3053992844},{8216732,3004038556},{8216740,3016579953},{8216744,3053992844},{8216748,3016579943},{8216756,3102153082},{8216760,941943272},{8216764,869144436},{8216768,3029565917},{8216780,856554964},{8216784,3053992844},{8216788,3004038556},{8216796,3016579953},{8216800,3053992844},{8216804,3016579943},{8216812,869144436},{8216816,3029565917},{8216828,856554964},{8216832,3053992844},{8216836,3004038556},{8216844,3016579953},{8216848,3053992844},{8216852,3016579943},{8216860,944987887},{8216864,1028443142},{8216868,3030621598},{8216880,3024462045},{8216884,3053992844},{8216888,876978383},{8216896,3016579953},{8216900,906509196},{8216904,869096251},{8216912,1028443339},{8216916,2914680832},{8216928,3024462045},{8216932,3053992844},{8216936,876978383},{8216944,3016579953},{8216948,906509196},{8216952,869096251},{8216960,3091274360},{8216964,3080711884},{8216968,3161068440},{8216972,3163996338},{8216976,3156913607},{8216980,3237238615},{8216984,3203454230},{8216988,3185108841},{8216992,3264785027},{8216996,1029073073},{8217000,3240727998},{8217004,1043133054},{8217008,3063795765},{8217012,3027100436},{8217020,3054560608},{8217024,3017435743},{8217044,1086294843},{8217048,1051666818},{8217052,1031409448},{8217056,3185434302},{8217060,3200993121},{8217072,981566818},{8217076,3104939969},{8217096,3129133886},{8217104,1086294697},{8217108,1051666816},{8217112,3178892961},{8217116,3185434303},{8217120,1053509474},{8217132,981594655},{8217136,957487615},{8217156,3129161996},{8217164,3212014880},{8217168,1034705438},{8217172,1091551182},{8217176,3150085806},{8217180,3179947034},{8217184,865448371},{8217188,3198592626},{8217192,1022293404},{8217196,3223176472},{8217204,3107989145},{8217212,3198594789},{8217216,1021901910},{8217220,3223176472},{8217228,3107988407},{8217236,1034253429},{8217240,2986322971},{8217244,867188368},{8217248,873829810},{8217272,3091274346},{8217276,3080711868},{8217280,3161068429},{8217284,1154171284},{8217288,1051136542},{8217292,1090089770},{8217296,1035088947},{8217300,3235949083},{8217304,3207738250},{8217308,1051136540},{8217312,1154222889},{8217316,3223202133},{8217320,1116922228},{8217324,3229633129},{8217328,3281769235},{8217332,1090089771},{8217336,3223202119},{8217340,1151333060},{8217344,3203804178},{8217348,1125293957},{8217352,1081803339},{8217356,1038185116},{8217360,1118899166},{8217364,3207057609},{8217368,3235949085},{8217372,3229633141},{8217376,1125293957},{8217380,3207687261},{8217384,3281703977},{8217388,1081706555},{8217416,1140343203},{8217420,3266125115},{8217424,1160333956},{8217428,3262667544},{8217432,1165119557},{8217436,3070846940},{8217440,981641385},{8217444,943392617},{8217484,3214599962},{8217488,3211607584},{8217492,1089415590},{8217496,1089337111},{8217500,923392838},{8217504,981669467},{8217508,3090916494},{8217552,2783671304},{8217572,724347586},{8217588,2802335768},{8217592,2872724282},{8217600,903774514},{8217604,2770359539},{8217608,2781672234},{8217620,3054550887},{8217644,588721664},{8217664,650235175},{5287048,3176020745},{5287132,1017871275},{5287148,941299828},{5288972,1067089477},{5288976,1061533783},{5288980,3172901864},{5288984,1017098895},{5288988,996386063},{5288992,1034149627},{5289665,3176192075},{5289749,3165354942},{5289765,941428676},{5291589,1067089481},{5291593,3209017437},{5291597,3172901872},{5291601,3214408201},{5291605,3209075640},{5291609,1039344690},{5291874,1063097548},{5292282,3176388537},{5292330,1049896866},{5292334,966168090},{5292338,1090955476},{5292342,927646967},{5292346,3357261186},{5292366,3158323262},{5292374,1007521063},{5292382,962166865},{5294206,3217866025},{5294210,1061448849},{5294214,3185908014},{5294218,3214682965},{5294222,1061549206},{5294226,1034072465},{5294899,3176387581},{5294983,3158008393},{5294999,962166682},{5296823,3217885780},{5296827,3208965645},{5296831,3183514108},{5296835,1070273534},{5296839,3208917091},{5296843,1042038263}}},{["item"]=20,["tag"]="min",["raw"]=3334533121,["structure"]="generic",["pool"]=4711,["litTop"]=15464700,["hash"]=1595767356,["var"]={{5138272,1070394984},{5138276,1071909467},{5138288,1061590978},{5138292,1061590978},{5138296,1061590978},{5138300,1061590978},{5138312,1060701357},{5138316,1060701357},{5299948,0},{5412032,1086378405},{5412044,1109852149},{7977504,3217875818},{7977508,3208950259},{7977512,3183314424},{7978124,3217875818},{7978128,3208950259},{7978132,3183314424},{8204188,1035090314},{8204292,3217875948},{8204296,1061465997},{8204300,3183315428},{8204304,3217875948},{8204308,1061465997},{8204312,3183315428},{8204444,868520551},{8204448,910961051},{8204452,1054276630},{8204460,3089507345},{8204464,3044009675},{8204468,869550575},{8204476,674237065},{8204492,0},{8204496,2147483648},{8204516,3097895953},{8204520,3052398283},{8204524,877939183},{8204528,827827606},{8204532,781955444},{8204536,2903098842},{8204540,736153791},{8204544,2856775785},{8204548,682625673},{8204556,892082254},{8204560,3088384087},{8204564,954350712},{8204604,955175725},{8204716,925654983},{8204860,3179198547},{8204864,2988514459},{8204868,2988512740},{8204872,2996925282},{8204876,968993865},{8204880,3156461124},{8204884,3157423909},{8204888,1029000406},{8204892,3217868511},{8204896,900474717},{8204932,945628340},{8204936,988131023},{8204940,3179198547},{8204976,1091099188},{8204980,1097697994},{8204984,1034448663},{8204988,1034448663},{8204992,3166513937},{8204996,3161075520},{8205000,1067695238},{8205004,3238247041},{8205008,3204858765},{8205012,1053682447},{8205016,1040960728},{8205056,945628340},{8205060,988131023},{8205064,3179198547},{8205072,2147483648},{8205080,0},{8205088,2147483648},{8205092,945628340},{8205096,988131023},{8205100,3179198547},{8205128,3182573962},{8205132,1166345322},{8205136,1142053419},{8205140,3268608279},{8205144,1166259779},{8205148,3310029974},{8205152,3315647620},{8205156,1134639894},{8205160,1162089102},{8205164,1141333740},{8205168,1031994680},{8205172,1138351580},{8205176,3265072682},{8205180,3306627672},{8205184,3312407418},{8205188,1131414525},{8205196,1147854703},{8205200,3251831234},{8205204,1017283750},{8205208,1165771274},{8205212,1036189543},{8205216,1157696781},{8205220,3288677186},{8205224,941986966},{8205228,1171027603},{8205232,3227444382},{8205236,1059114964},{8205240,3250192492},{8205244,913021203},{8205248,3120208662},{8205252,782153431},{8205260,3247546771},{8205264,3209315664},{8205268,1034245779},{8205280,792637517},{8205284,1059138896},{8205288,3206622538},{8205292,3182647184},{8205296,3124288716},{8205300,3146715673},{8205304,953397756},{8205308,872415232},{8205312,984359637},{8205316,3019898880},{8205320,3166513937},{8205324,1067695238},{8205328,3238247041},{8205332,3238247030},{8205336,3204858765},{8205340,1053682447},{8205344,1031994680},{8205348,3102659373},{8205352,2147483648},{8205356,3174754451},{8205368,3185365107},{8205372,3163004800},{8205472,877944165},{8205476,904914566},{8205480,3025417849},{8205488,3097895954},{8205492,3052398352},{8205496,950412304},{8206860,3200638346},{8206864,3208351538},{8206872,3249813013},{8206876,3242209598},{8206880,1074745593},{8206888,3039379388},{8206892,1090096208},{8206896,3165748674},{8206900,3241616153},{8206904,3088151550},{8206908,3045236702},{8206916,3069766668},{8206920,1117515064},{8206924,1018264965},{8206944,3189749821},{8206948,1125363913},{8206956,3165748141},{8206960,1119492136},{8206964,3189749858},{8206968,1140366749},{8206972,1062980418},{8206976,3264721952},{8206980,3241616155},{8206984,1018261637},{8206988,1125363913},{8206992,1062980414},{8206996,1160332520},{8207000,1083884043},{8207004,3090229939},{8207012,3060492689},{8207016,3259865470},{8207020,1083884053},{8207024,1165119799},{8207036,2955183448},{8207044,3076491777},{8207048,3152455945},{8207052,3000968196},{8207060,3039379388},{8207072,2969369406},{8207076,1030322660},{8207080,928947742},{8207088,1090096208},{8207096,3069756405},{8207104,3103750705},{8207108,1038908221},{8207112,2977763452},{8207116,3165748674},{8207124,1117515063},{8207128,3189742839},{8207132,1140221126},{8207136,988337582},{8207140,3180864617},{8207144,3241616153},{8207152,1018264961},{8207156,1125367510},{8207160,1063259103},{8207164,1160262302},{8207168,988735827},{8207172,3088151550},{8207180,3049815953},{8207184,3261617898},{8207188,1084109101},{8207192,1164859861},{8207196,982597450},{8207220,1044308416},{8207224,3191792067},{8207236,987785038},{8207240,3135268686},{8207260,3149098656},{8207312,1001615008},{8207368,982597450},{8207372,3178987534},{8207380,3130081260},{8207384,1031503880},{8207972,2147483648},{8207980,0},{8207988,0},{8208076,1102708758},{8208092,1051144775},{8208104,1047622253},{8208120,3202083187},{8208140,3202121164},{8208156,949014358},{8208160,830948519},{8208192,3198355253},{8208196,3198409014},{8208200,3255367313},{8208204,3239813424},{8208208,3197737949},{8208212,1064971708},{8208280,3089638985},{8208284,991005473},{8208288,3161075487},{8208348,3129951416},{8208356,1002564544},{8210132,1000155694},{8210136,3053447855},{8210140,3189968599},{8210144,3125601929},{8210148,1116865430},{8210152,3240148924},{8210156,3219536608},{8210160,887916507},{8210164,3237414926},{8210168,1094812258},{8210172,2993091896},{8210176,3214688275},{8210180,1074622916},{8210184,2989100910},{8210188,3260961247},{8210192,1118871895},{8210196,3020598816},{8210204,3125610119},{8210208,954870552},{8210212,1140220315},{8210216,1116865467},{8210220,3057643729},{8210224,3240148924},{8210228,1071955919},{8210232,864249279},{8210236,880664977},{8210240,1083997210},{8210244,3031441146},{8210248,1084257040},{8210256,850263926},{8210260,1113477211},{8210264,1118870809},{8210268,3062656912},{8210272,3025243956},{8210276,964627280},{8210280,1060701357},{8210284,1061590978},{8210288,1061590978},{8210292,1166262813},{8210300,933983131},{8210304,991149859},{8210308,1162261116},{8210312,3202121164},{8210316,1070394984},{8210324,987016926},{8210328,3255730168},{8210336,2965958261},{8210340,1129667570},{8210344,1105162233},{8210348,3163192319},{8210352,2804346717},{8210360,3183521062},{8210364,2949571933},{8210368,1084372542},{8210372,3059693082},{8210376,2848077432},{8210380,982755585},{8210388,824139519},{8210392,1009819878},{8210400,3152350233},{8210404,1017987325},{8210412,3076603779},{8210420,3248921049},{8210424,937542965},{8210428,927943269},{8210432,1165586479},{8210436,1000483790},{8210444,958609504},{8210452,958960326},{8210460,1062437305},{8210464,3186207775},{8210468,3186922429},{8210476,3180863484},{8210484,1156122577},{8210488,3264949444},{8210492,987016926},{8210500,1038908209},{8210504,931010119},{8210508,983433645},{8210512,1073672059},{8210516,967535930},{8210524,1062697367},{8210528,988566546},{8210532,1160262307},{8210536,3261616352},{8210540,1068384963},{8210548,3229270528},{8210552,1038942696},{8210556,1063134825},{8210560,1030309454},{8210564,1043508131},{8211740,3217875818},{8211744,3208950259},{8211748,3183314424},{8211752,1070311924},{8211756,3209107590},{8211760,1040873094},{8211764,931282973},{8211768,3217338560},{8211772,922419200},{8211812,868520551},{8211816,3101508080},{8211820,910961051},{8211824,989953948},{8211828,1054276630},{8211832,3178786010},{8211836,3089507345},{8211840,3044009675},{8211844,869550575},{8211852,3173854069},{8211856,948468229},{8211860,3104536563},{8211888,976285100},{8211892,1052671794},{8211904,901984890},{8211908,3123565258},{8211912,3105617585},{8211916,3180341896},{8211928,907336465},{8211932,3120235609},{8211940,961638984},{8211944,1037117520},{8211948,949927798},{8211952,1025775939},{8211960,907608707},{8211964,980124616},{8211972,907636468},{8211976,980165288},{8211980,982446496},{8211984,1059162394},{8211988,3085437661},{8211992,3157430728},{8211996,925654983},{8212000,998549197},{8212004,892085524},{8212008,948534797},{8212012,3088386436},{8212016,3164087547},{8212020,954350325},{8212024,1030023831},{8212028,3101508080},{8212032,989953948},{8212036,3178786010},{8212040,3173854069},{8212044,948468229},{8212048,3104536563},{8212052,868520551},{8212056,910961051},{8212060,1054276630},{8212064,868520551},{8212068,910961051},{8212072,1054276630},{8212080,3089507345},{8212084,3044009675},{8212088,869550575},{8212096,3025417849},{8212100,3052398352},{8212104,877944165},{8212112,950412304},{8212116,904914566},{8212120,3097895954},{8212132,3025417849},{8212136,3052398352},{8212140,877944165},{8212148,950412304},{8212152,904914566},{8212156,3097895954},{8212164,3101508080},{8212168,989953948},{8212172,3178786010},{8212176,3173854069},{8212180,948468229},{8212184,3104536563},{8212192,3025417849},{8212196,3052398352},{8212200,877944165},{8212208,950412304},{8212212,904914566},{8212216,3097895954},{8212224,3192025167},{8212228,3068622317},{8212236,3192025167},{8212240,3068622317},{8212252,3025417849},{8212256,3052398352},{8212260,877944165},{8212268,950412304},{8212272,904914566},{8212276,3097895954},{8212288,3025417849},{8212292,3052398352},{8212296,877944165},{8212304,950412304},{8212308,904914566},{8212312,3097895954},{8212320,3102640943},{8212324,3143032569},{8212328,3178782651},{8212332,3173854069},{8212336,948468229},{8212340,3104536563},{8212348,3025417849},{8212352,3052398352},{8212356,877944165},{8212364,950412304},{8212368,904914566},{8212372,3097895954},{8212384,3048150778},{8212388,1052598791},{8212396,3048150778},{8212400,1052598791},{8212408,3025417849},{8212412,3052398352},{8212416,877944165},{8212424,950412304},{8212428,904914566},{8212432,3097895954},{8212444,3025417849},{8212448,3052398352},{8212452,877944165},{8212460,950412304},{8212464,904914566},{8212468,3097895954},{8212476,3101970133},{8212480,956589977},{8212484,3178751904},{8212488,3173854069},{8212492,948468229},{8212496,3104536563},{8212500,1052671794},{8212504,976285100},{8212512,3143596740},{8212516,1041028230},{8212520,3073609961},{8212524,1065348027},{8212528,1019981877},{8212532,3188514717},{8212536,3167339393},{8212540,1065188555},{8212548,1061466582},{8212552,1047544946},{8212556,1067090135},{8212560,1061466863},{8212564,1047589795},{8212572,3143596740},{8212576,1041028230},{8212580,3073609961},{8212584,1065348027},{8212588,1019981877},{8212592,3188514717},{8212596,3167339393},{8212600,1065188555},{8212608,3185081567},{8212612,3143596740},{8212616,1042912593},{8212620,1041028230},{8212624,1061417290},{8212628,3073609960},{8212632,3163090521},{8212636,1065348028},{8212640,1022880097},{8212644,1019981878},{8212648,3214687315},{8212652,3188514717},{8212656,3208828128},{8212660,3167339393},{8212664,1067109002},{8212668,1065188555},{8212672,3181061694},{8212676,1011997365},{8212680,3144803151},{8212684,1049569700},{8212688,3173741247},{8212692,962514517},{8212696,3150105333},{8212704,1065337116},{8212708,3156728178},{8212712,3173935392},{8212716,999478918},{8212720,1065203301},{8212724,3188228551},{8212728,1026716188},{8212732,1040723511},{8212736,1065188117},{8212740,1067090135},{8212744,1061466863},{8212748,1047589795},{8212752,1067090135},{8212756,1061466863},{8212760,1047589795},{8212784,1065337116},{8212788,3156728178},{8212792,3173935392},{8212796,999478918},{8212800,1065203301},{8212804,3188228551},{8212808,1026716188},{8212812,1040723511},{8212816,1065188117},{8212824,3169392419},{8212832,1065143797},{8212840,1042195074},{8212844,1031880573},{8212848,1025573148},{8212852,1049242991},{8212856,3173844658},{8212860,972790590},{8212864,987335805},{8212868,3123565258},{8212872,1065337116},{8212876,3146399451},{8212880,3174206888},{8212884,999478918},{8212888,1065352748},{8212892,1002567456},{8212896,1026716188},{8212900,3150458528},{8212904,1065336968},{8212908,1067090135},{8212912,1061466863},{8212916,1047589795},{8212920,1067090135},{8212924,1061466863},{8212928,1047589795},{8212932,901984890},{8212936,1065337116},{8212940,3146399451},{8212944,3174206888},{8212948,999478918},{8212952,1065352748},{8212956,1002567456},{8212960,1026716188},{8212964,3150458528},{8212968,1065336968},{8212996,1031880573},{8213000,984807148},{8213004,1049338424},{8213008,3173844658},{8213012,3118176458},{8213016,987770770},{8213020,3180341896},{8213024,3105617585},{8213032,996111389},{8213036,1041028231},{8213040,3073609961},{8213044,1065348093},{8213048,3167381266},{8213052,3188514717},{8213056,1019770702},{8213060,1065188621},{8213064,1067089359},{8213068,3208950498},{8213072,1050984593},{8213076,1067089187},{8213080,3208950437},{8213084,1050979651},{8213092,996111389},{8213096,1041028231},{8213100,3073609961},{8213104,1065348093},{8213108,3167381266},{8213112,3188514717},{8213116,1019770702},{8213120,1065188621},{8213128,1037597541},{8213132,996111389},{8213136,1034070742},{8213140,1041028231},{8213148,3073609960},{8213152,1032625261},{8213156,1065348093},{8213164,3167381265},{8213172,3188514717},{8213176,1061344141},{8213180,1019770702},{8213184,1067108051},{8213188,1065188621},{8213196,997245169},{8213200,3141964315},{8213204,3184091870},{8213208,3173741247},{8213212,3098328595},{8213216,3150112261},{8213224,1065337116},{8213228,1010470254},{8213232,3173857280},{8213236,3146946896},{8213240,1065136683},{8213244,1042541615},{8213248,1026716380},{8213252,3190002261},{8213256,1065121646},{8213260,1067089187},{8213264,3208950437},{8213268,1050979651},{8213272,1067089187},{8213276,3208950437},{8213280,1050979651},{8213304,1065337116},{8213308,1010470254},{8213312,3173857280},{8213316,3146946896},{8213320,1065136683},{8213324,1042541615},{8213328,1026716380},{8213332,3190002261},{8213336,1065121646},{8213364,3160921914},{8213368,1014287719},{8213372,3183815436},{8213376,3173844814},{8213380,3117388252},{8213384,987398613},{8213388,3120235609},{8213392,1065337116},{8213396,1001430365},{8213400,3174172183},{8213404,3146946896},{8213408,1065349293},{8213412,1017985544},{8213416,1026716380},{8213420,3165353952},{8213424,1065333602},{8213428,1067089187},{8213432,3208950437},{8213436,1050979651},{8213440,1067089187},{8213444,3208950437},{8213448,1050979651},{8213452,907336465},{8213456,1065337116},{8213460,1001430365},{8213464,3174172183},{8213468,3146946896},{8213472,1065349293},{8213476,1017985544},{8213480,1026716380},{8213484,3165353952},{8213488,1065333602},{8213516,3160921914},{8213520,985082558},{8213524,3183968785},{8213528,3173844814},{8213532,3123148403},{8213536,987732554},{8213540,1037117520},{8213544,1025775939},{8213548,961638984},{8213552,1065208847},{8213556,3025328526},{8213560,3188067286},{8213564,925976231},{8213568,1065353215},{8213572,950316386},{8213576,1040583636},{8213580,3097897276},{8213584,1065208847},{8213588,3217761274},{8213592,3079954881},{8213596,1042681994},{8213600,3217761494},{8213604,3079946259},{8213612,949927798},{8213624,949927797},{8213628,3097411445},{8213632,1065208847},{8213636,3072952964},{8213640,3188067286},{8213644,925976231},{8213648,1065353214},{8213652,910015872},{8213656,1040583636},{8213660,3062659008},{8213664,1065208846},{8213668,1065208847},{8213672,713997181},{8213676,3025328526},{8213680,1048828284},{8213684,3072735508},{8213688,3188067285},{8213692,824949660},{8213700,925976232},{8213704,3175269866},{8213708,1065353215},{8213716,1065353215},{8213720,950316387},{8213724,1070446069},{8213728,3097410113},{8213732,1040583636},{8213736,2886147993},{8213740,3097897276},{8213748,949836953},{8213752,1065208847},{8213764,3154368526},{8213768,3155064645},{8213772,1026327383},{8213776,3136610208},{8213780,948524426},{8213784,1001457327},{8213788,980124616},{8213796,3130187527},{8213800,3188067286},{8213804,982790629},{8213808,1065353202},{8213812,910015872},{8213816,1040583629},{8213820,3105759842},{8213824,1065208846},{8213828,3217875948},{8213832,1061466479},{8213836,1049100774},{8213840,3217875948},{8213844,1061466479},{8213848,1049100774},{8213852,907608707},{8213860,3130187527},{8213864,3188067286},{8213868,982790629},{8213872,1065353202},{8213876,910015872},{8213880,1040583629},{8213884,3105759842},{8213888,1065208846},{8213916,3097411445},{8213920,867570570},{8213924,949927790},{8213932,3158828451},{8213936,3154837591},{8213940,1025942230},{8213944,3136609568},{8213948,981285608},{8213952,1001457327},{8213956,980165288},{8213960,1065208836},{8213964,982530271},{8213968,3188067286},{8213972,3130092751},{8213980,910015872},{8213984,1040583630},{8213988,957700840},{8213992,1065208846},{8213996,3217875818},{8214000,3208950714},{8214004,1049100990},{8214008,3217875818},{8214012,3208950714},{8214016,1049100990},{8214020,907636468},{8214024,1065208836},{8214028,982530271},{8214032,3188067286},{8214036,3130092751},{8214044,910015872},{8214048,1040583630},{8214052,957700840},{8214056,1065208846},{8214084,3097411445},{8214088,3015054223},{8214092,949927790},{8214100,3145614548},{8214104,3154856931},{8214108,1026712887},{8214112,3136610828},{8214116,981254380},{8214120,1001457327},{8214124,1059162394},{8214132,860378180},{8214136,3052398352},{8214140,3007901684},{8214148,950412304},{8214152,3052398320},{8214156,950412305},{8214164,868520551},{8214168,910961051},{8214172,1054276630},{8214176,868520551},{8214180,910961051},{8214184,1054276630},{8214188,982446496},{8214196,860378180},{8214200,3052398352},{8214204,3007901684},{8214212,950412304},{8214216,3052398320},{8214220,950412305},{8214232,860378180},{8214236,3052398352},{8214240,3007901684},{8214248,950412304},{8214252,3052398320},{8214256,950412305},{8214264,954039320},{8214268,3137458234},{8214272,3178785968},{8214276,1059871697},{8214280,3095951000},{8214284,3104536563},{8214288,3157430728},{8214296,860378180},{8214300,3052398352},{8214304,3007901684},{8214312,950412304},{8214316,3052398320},{8214320,950412305},{8214328,868520551},{8214332,910961051},{8214336,1054276630},{8214340,868520551},{8214344,910961051},{8214348,1054276630},{8214352,3085437661},{8214360,860378180},{8214364,3052398352},{8214368,3007901684},{8214376,950412304},{8214380,3052398320},{8214384,950412305},{8214396,860378180},{8214400,3052398352},{8214404,3007901684},{8214412,950412304},{8214416,3052398320},{8214420,950412305},{8214428,954039320},{8214432,3137458234},{8214436,3178785968},{8214440,1023444740},{8214444,3095951000},{8214448,3104536563},{8214452,998549197},{8214460,860378180},{8214464,3052398352},{8214468,3007901684},{8214476,950412304},{8214480,3052398320},{8214484,950412305},{8214492,868520551},{8214496,910961051},{8214500,1054276630},{8214504,868520551},{8214508,910961051},{8214512,1054276630},{8214516,925654983},{8214524,860378180},{8214528,3052398352},{8214532,3007901684},{8214540,950412304},{8214544,3052398320},{8214548,950412305},{8214560,860378180},{8214564,3052398352},{8214568,3007901684},{8214576,950412304},{8214580,3052398320},{8214584,950412305},{8214592,954039320},{8214596,3137458234},{8214600,3178785968},{8214604,1027457102},{8214608,3095951000},{8214612,3104536563},{8214616,948534797},{8214620,3164087547},{8214624,1030023831},{8214628,892085524},{8214632,3088386436},{8214636,954350325},{8214644,3025417849},{8214648,3052398352},{8214652,877944165},{8214660,950412304},{8214664,904914566},{8214668,3097895954},{8214676,1028443168},{8214680,940902785},{8214684,1062499278},{8214692,840081408},{8214696,1062501087},{8214704,3025417849},{8214708,3052398352},{8214712,877944165},{8214720,950412304},{8214724,904914566},{8214728,3097895954},{8214740,3025417849},{8214744,3201431976},{8214748,3052398352},{8214752,3088386436},{8214756,877944165},{8214760,1053948328},{8214768,950412304},{8214772,3175927161},{8214776,904914566},{8214780,940902788},{8214784,3097895954},{8214788,1028443513},{8214796,3076538494},{8214800,977407667},{8214804,3147571072},{8214808,3173854069},{8214812,948468229},{8214816,3104536563},{8214836,1051144775},{8214840,0},{8214860,1047622253},{8214868,3267067977},{8214872,1037906427},{8214876,3291578582},{8214884,3202083187},{8214892,3267067979},{8214896,3184585281},{8214900,3291578582},{8214908,3202121165},{8214916,3316147907},{8214920,3279396144},{8214924,3274386270},{8214928,3274856694},{8214932,3331862536},{8214936,1141371836},{8214940,3139195410},{8214944,1037599821},{8214952,3129968260},{8214956,1028049763},{8214964,3254360899},{8214968,3267263641},{8214972,3291564084},{8214976,3254361167},{8214980,1122290947},{8214984,3291517595},{8214988,3266103915},{8214992,1029058591},{8214996,1162906431},{8215000,1170080785},{8215004,3296830332},{8215008,3255730168},{8215012,1102708758},{8215016,967535930},{8215020,3198521787},{8215024,1027221358},{8215028,3194951908},{8215032,3171314024},{8215036,1063007126},{8215040,3148560533},{8215044,1067223437},{8215048,3237546988},{8215052,868520551},{8215056,910961051},{8215060,1054276630},{8215068,3025417849},{8215072,3052398352},{8215076,877944165},{8215084,950412304},{8215088,904914566},{8215092,3097895954},{8215100,3186109244},{8215104,1074258554},{8215108,3263321745},{8215112,3248442726},{8215116,1042522463},{8215120,3199701864},{8215124,3274386270},{8215128,3274856694},{8215132,3331862536},{8215136,3316147907},{8215140,3279396144},{8215144,1141371836},{8215148,3192025167},{8215152,3068622317},{8215164,3025417849},{8215168,3052398352},{8215172,877944165},{8215180,950412304},{8215184,904914566},{8215188,3097895954},{8215196,3192025167},{8215200,3068622317},{8215212,3025417849},{8215216,3052398352},{8215220,877944165},{8215228,950412304},{8215232,904914566},{8215236,3097895954},{8215244,3162348045},{8215248,3202641738},{8215252,3238266555},{8215256,3139195410},{8215260,1037599821},{8215272,3048150778},{8215276,1052598791},{8215284,3025417849},{8215288,3052398352},{8215292,877944165},{8215300,950412304},{8215304,904914566},{8215308,3097895954},{8215320,3048150778},{8215324,1052598791},{8215332,3025417849},{8215336,3052398352},{8215340,877944165},{8215348,950412304},{8215352,904914566},{8215356,3097895954},{8215364,3151944273},{8215368,1006714291},{8215372,3228695357},{8215376,3196533046},{8215380,970269764},{8215384,3126448244},{8215388,3129968260},{8215392,1028049763},{8215404,1061466582},{8215408,1047544946},{8215416,3143596740},{8215420,1041028230},{8215424,3073609961},{8215428,1065348027},{8215432,1019981877},{8215436,3188514717},{8215440,3167339393},{8215444,1065188555},{8215448,1067090135},{8215452,1061466863},{8215456,1047589795},{8215464,3143596740},{8215468,1041028230},{8215472,3073609961},{8215476,1065348027},{8215480,1019981877},{8215484,3188514717},{8215488,3167339393},{8215492,1065188555},{8215496,1170080785},{8215500,1067090135},{8215504,1061466863},{8215508,1047589795},{8215512,1065337116},{8215516,3156728178},{8215520,3173935392},{8215524,999478918},{8215528,1065203301},{8215532,3188228551},{8215536,1026716188},{8215540,1040723511},{8215544,1065188117},{8215548,1067090135},{8215552,1061466863},{8215556,1047589795},{8215560,1065337116},{8215564,3156728178},{8215568,3173935392},{8215572,999478918},{8215576,1065203301},{8215580,3188228551},{8215584,1026716188},{8215588,1040723511},{8215592,1065188117},{8215596,1083407288},{8215600,1077393492},{8215604,1100852271},{8215608,3172143742},{8215612,944326910},{8215616,985197213},{8215620,3254360899},{8215624,3267263641},{8215628,3291564084},{8215632,3198521787},{8215636,1027221358},{8215640,1067090135},{8215644,1061466863},{8215648,1047589795},{8215652,1065337116},{8215656,3146399451},{8215660,3174206888},{8215664,999478918},{8215668,1065352748},{8215672,1002567456},{8215676,1026716188},{8215680,3150458528},{8215684,1065336968},{8215688,1067090135},{8215692,1061466863},{8215696,1047589795},{8215700,1065337116},{8215704,3146399451},{8215708,3174206888},{8215712,999478918},{8215716,1065352748},{8215720,1002567456},{8215724,1026716188},{8215728,3150458528},{8215732,1065336968},{8215736,3124478300},{8215756,1051144775},{8215760,0},{8215764,1067089359},{8215768,3208950498},{8215772,1050984593},{8215780,996111389},{8215784,1041028231},{8215788,3073609961},{8215792,1065348093},{8215796,3167381266},{8215800,3188514717},{8215804,1019770702},{8215808,1065188621},{8215812,1067089187},{8215816,3208950437},{8215820,1050979651},{8215828,996111389},{8215832,1041028231},{8215836,3073609961},{8215840,1065348093},{8215844,3167381266},{8215848,3188514717},{8215852,1019770702},{8215856,1065188621},{8215860,3296830332},{8215864,1067089187},{8215868,3208950437},{8215872,1050979651},{8215876,1065337116},{8215880,1010470254},{8215884,3173857280},{8215888,3146946896},{8215892,1065136683},{8215896,1042541615},{8215900,1026716380},{8215904,3190002261},{8215908,1065121646},{8215912,1067089187},{8215916,3208950437},{8215920,1050979651},{8215924,1065337116},{8215928,1010470254},{8215932,3173857280},{8215936,3146946896},{8215940,1065136683},{8215944,1042541615},{8215948,1026716380},{8215952,3190002261},{8215956,1065121646},{8215960,3213117049},{8215964,1066118051},{8215968,3235970163},{8215972,3172143875},{8215976,3089501770},{8215980,985250600},{8215984,3254361167},{8215988,1122290947},{8215992,3291517595},{8215996,3194951908},{8216000,3171314024},{8216004,1067089187},{8216008,3208950437},{8216012,1050979651},{8216016,1065337116},{8216020,1001430365},{8216024,3174172183},{8216028,3146946896},{8216032,1065349293},{8216036,1017985544},{8216040,1026716380},{8216044,3165353952},{8216048,1065333602},{8216052,1067089187},{8216056,3208950437},{8216060,1050979651},{8216064,1065337116},{8216068,1001430365},{8216072,3174172183},{8216076,3146946896},{8216080,1065349293},{8216084,1017985544},{8216088,1026716380},{8216092,3165353952},{8216096,1065333602},{8216100,3129945661},{8216120,1047622253},{8216128,3217761274},{8216132,3079954881},{8216136,1042681994},{8216140,1065208847},{8216144,3025328526},{8216148,3188067286},{8216152,925976231},{8216156,1065353215},{8216160,950316386},{8216164,1040583636},{8216168,3097897276},{8216172,1065208847},{8216176,3217761494},{8216180,3079946259},{8216188,1065208847},{8216192,3072952964},{8216196,3188067286},{8216200,925976231},{8216204,1065353214},{8216208,910015872},{8216212,1040583636},{8216216,3062659008},{8216220,1065208846},{8216224,3205145702},{8216228,3205877715},{8216232,1077241987},{8216236,3155758020},{8216240,940135818},{8216244,1021134938},{8216248,3266103915},{8216252,1029058591},{8216256,1162906431},{8216260,3255730168},{8216264,1063007126},{8216268,3217875948},{8216272,1061466479},{8216276,1049100774},{8216284,3130187527},{8216288,3188067286},{8216292,982790629},{8216296,1065353202},{8216300,910015872},{8216304,1040583629},{8216308,3105759842},{8216312,1065208846},{8216316,3217875948},{8216320,1061466479},{8216324,1049100774},{8216332,3130187527},{8216336,3188067286},{8216340,982790629},{8216344,1065353202},{8216348,910015872},{8216352,1040583629},{8216356,3105759842},{8216360,1065208846},{8216364,3211008410},{8216368,3206454489},{8216372,1077814647},{8216376,3139782774},{8216380,986852948},{8216384,1005517881},{8216388,3267067977},{8216392,1037906427},{8216396,3291578582},{8216404,3202083187},{8216412,3217875818},{8216416,3208950714},{8216420,1049100990},{8216424,1065208836},{8216428,982530271},{8216432,3188067286},{8216436,3130092751},{8216444,910015872},{8216448,1040583630},{8216452,957700840},{8216456,1065208846},{8216460,3217875818},{8216464,3208950714},{8216468,1049100990},{8216472,1065208836},{8216476,982530271},{8216480,3188067286},{8216484,3130092751},{8216492,910015872},{8216496,1040583630},{8216500,957700840},{8216504,1065208846},{8216508,3197178447},{8216512,3206476558},{8216516,1078694034},{8216520,3139783625},{8216524,986827029},{8216528,1005517881},{8216532,3267067979},{8216536,3184585281},{8216540,3291578582},{8216548,3202121165},{8216556,868520551},{8216560,910961051},{8216564,1054276630},{8216572,860378180},{8216576,3052398352},{8216580,3007901684},{8216588,950412304},{8216592,3052398320},{8216596,950412305},{8216604,868520551},{8216608,910961051},{8216612,1054276630},{8216620,860378180},{8216624,3052398352},{8216628,3007901684},{8216636,950412304},{8216640,3052398320},{8216644,950412305},{8216652,1034254044},{8216656,1102708758},{8216660,868520551},{8216664,910961051},{8216668,1054276630},{8216676,860378180},{8216680,3052398352},{8216684,3007901684},{8216692,950412304},{8216696,3052398320},{8216700,950412305},{8216708,868520551},{8216712,910961051},{8216716,1054276630},{8216724,860378180},{8216728,3052398352},{8216732,3007901684},{8216740,950412304},{8216744,3052398320},{8216748,950412305},{8216756,992248795},{8216760,967535930},{8216764,868520551},{8216768,910961051},{8216772,1054276630},{8216780,860378180},{8216784,3052398352},{8216788,3007901684},{8216796,950412304},{8216800,3052398320},{8216804,950412305},{8216812,868520551},{8216816,910961051},{8216820,1054276630},{8216828,860378180},{8216832,3052398352},{8216836,3007901684},{8216844,950412304},{8216848,3052398320},{8216852,950412305},{8216860,1001793856},{8216864,1028443168},{8216868,940902785},{8216872,1062499278},{8216880,3025417849},{8216884,3052398352},{8216888,877944165},{8216896,950412304},{8216900,904914566},{8216904,3097895954},{8216916,840081408},{8216920,1062501087},{8216928,3025417849},{8216932,3052398352},{8216936,877944165},{8216944,950412304},{8216948,904914566},{8216952,3097895954},{8216960,3089641567},{8216964,991005446},{8216968,3161075520},{8216972,3148560533},{8216976,1067223437},{8216980,3237546988},{8216984,3206870625},{8216988,3167002985},{8216992,3264949849},{8216996,3248916668},{8217000,3238859024},{8217004,1065716729},{8217008,3062559647},{8217012,960525722},{8217020,3053398024},{8217024,951104715},{8217044,1101225071},{8217048,1051667119},{8217052,1031184026},{8217056,3185434206},{8217060,3198770969},{8217064,3223164236},{8217072,976874902},{8217076,3100707652},{8217096,3124478299},{8217104,3236285591},{8217108,1051666335},{8217112,3178806948},{8217116,3185434325},{8217120,1053512741},{8217124,3223123032},{8217132,982370692},{8217136,958360135},{8217156,3129945660},{8217160,2147483648},{8217164,3212014903},{8217168,3112002066},{8217172,1091553089},{8217176,3174904243},{8217180,3179703206},{8217184,2996148356},{8217188,3198593696},{8217192,969008349},{8217196,3223177181},{8217204,3129925497},{8217212,3198593698},{8217216,3116133490},{8217220,3223177181},{8217228,3129951416},{8217236,1034254046},{8217240,2986951973},{8217244,865808041},{8217248,895402686},{8217272,3089641563},{8217276,991005432},{8217280,3161075508},{8217288,975272488},{8217292,1090097508},{8217296,3165836098},{8217300,3241532220},{8217304,3114399302},{8217308,975266220},{8217316,3169125945},{8217320,1117504538},{8217324,1023977995},{8217328,3281770755},{8217332,1090097511},{8217336,3169123401},{8217344,3190065134},{8217348,1125363932},{8217352,1019970656},{8217356,3165837069},{8217360,1119481610},{8217364,3190145368},{8217368,3241532225},{8217372,1023976372},{8217376,1125363932},{8217380,3114689082},{8217388,1019883603},{8217416,1140365661},{8217420,3264719172},{8217424,1160332517},{8217428,3259859909},{8217432,1165119933},{8217436,3055614324},{8217440,976992535},{8217444,928717827},{8217448,1062826445},{8217452,1017946810},{8217456,995665916},{8217460,1017946810},{8217464,1039329284},{8217468,3186293607},{8217472,995666004},{8217476,3186293607},{8217480,1062534651},{8217484,1062858974},{8217488,1062858970},{8217492,1083774034},{8217496,1083774045},{8217500,924216116},{8217504,982452321},{8217508,3092037095},{8217552,2877164891},{8217572,2965958261},{8217588,2880456758},{8217592,2958756309},{8217600,3130455306},{8217604,2856333803},{8217608,2876332570},{8217620,3130488075},{8217644,2853276728},{8217664,2878959302},{5287048,1051038138},{5287132,3150010792},{5287148,964233289},{5288972,1067090174},{5288976,1061448004},{5288980,3187483706},{5288984,1028724256},{5288988,3158517257},{5288992,1049423131},{5289665,1047468259},{5289749,3165329289},{5289765,959696917},{5291589,1067089007},{5291593,3209017187},{5291597,3172993480},{5291601,3214656317},{5291605,3209197558},{5291609,1020497408},{5292282,3202083178},{5292366,3105759842},{5292382,965214052},{5294206,3217875948},{5294210,1061465997},{5294214,3183315428},{5294218,3214718905},{5294222,1061375591},{5294226,1033853470},{5294899,3202121155},{5294983,957700840},{5294999,965184917},{5296823,3217875818},{5296827,3208950259},{5296831,3183314424},{5296835,1070311924},{5296839,3209107590},{5296843,1040873094}}},{["item"]=40,["tag"]="min",["raw"]=1056964607,["structure"]="natural",["pool"]=4660,["litTop"]=15464784,["hash"]=459062861,["var"]={{8204196,1156415487},{8204200,1156415487},{8204204,1156415488},{8204208,1156415488}}},{["item"]=60,["tag"]="max",["raw"]=1065353215,["structure"]="natural",["pool"]=4660,["litTop"]=15464784,["hash"]=1876293613,["var"]={}},{["item"]=62,["tag"]="min",["raw"]=3249893540,["structure"]="generic",["pool"]=4711,["litTop"]=15464700,["hash"]=377705466,["var"]={{5138272,1014479488},{5138276,1025336492},{5138288,1046627266},{5138292,1055222819},{5138296,1046627266},{5138300,1055222819},{5138312,1023200876},{5138316,1031046623},{5412032,1087225175},{5412044,1109852792},{7977504,3217867164},{7977508,3208934609},{7977512,3184542864},{7978124,3217867164},{7978128,3208934609},{7978132,3184542864},{8204148,0},{8204188,3142343456},{8204192,3156512880},{8204292,3217884633},{8204296,1061480270},{8204300,3182425296},{8204304,3217884633},{8204308,1061480270},{8204312,3182425296},{8204444,870101760},{8204448,881846323},{8204460,3016436888},{8204464,3045526830},{8204468,3017267265},{8204472,0},{8204476,674626803},{8204480,2147483648},{8204496,2147483648},{8204500,2147483648},{8204516,3024825496},{8204520,3053915438},{8204524,3025655873},{8204528,681656256},{8204532,710303219},{8204536,682315284},{8204540,739147214},{8204544,711179342},{8204548,683015411},{8204556,893507062},{8204560,3031705623},{8204564,954344612},{8204604,3102921545},{8204644,2147483648},{8204660,1015548084},{8204676,1015436697},{8204680,2147483648},{8204684,1015548084},{8204688,1015436697},{8204696,3132180650},{8204704,1065352320},{8204712,1009243452},{8204716,904507347},{8204720,3188066697},{8204724,3156822567},{8204728,1065207962},{8204752,1065352309},{8204760,3112035680},{8204764,1065352309},{8204768,1009400876},{8204772,1065353216},{8204776,964552932},{8204788,3112036580},{8204792,1065353216},{8204804,1009400876},{8204808,984413556},{8204812,1044582330},{8204816,1043049618},{8204820,1052248859},{8204828,1052248898},{8204832,989968406},{8204836,3175135856},{8204840,3135643126},{8204844,3199628767},{8204860,3179193859},{8204864,2988514459},{8204868,2988514417},{8204872,2996924864},{8204876,970578566},{8204880,3161294909},{8204884,3127168775},{8204888,1028500602},{8204892,3217868517},{8204896,901883340},{8204900,3208928086},{8204932,947407201},{8204936,958522682},{8204940,3179193859},{8204976,3208579222},{8204980,1050932105},{8204984,3196728526},{8204988,3196728526},{8204992,3168079883},{8204996,3161069604},{8205000,1011210607},{8205004,3238243714},{8205008,3147971722},{8205012,1053636997},{8205016,3202706467},{8205048,3235403734},{8205052,3290665347},{8205056,947407201},{8205060,958522682},{8205064,3179193859},{8205072,2147483648},{8205080,0},{8205088,2147483648},{8205092,947407201},{8205096,958522682},{8205100,3179193859},{8205128,994859808},{8205132,3273164073},{8205136,3249000305},{8205140,1081209099},{8205144,3273065989},{8205148,1122555236},{8205152,1127768170},{8205156,3241729746},{8205160,1158302042},{8205164,3284410517},{8205168,975062924},{8205172,1134143575},{8205176,3260909932},{8205180,3302306411},{8205184,3307787174},{8205188,1126778722},{8205196,1147632548},{8205200,3241055603},{8205204,946598667},{8205208,1165765141},{8205212,1038870652},{8205216,1157521532},{8205220,3288673948},{8205224,3257415077},{8205228,1171022633},{8205232,1116042543},{8205236,1059878712},{8205240,3250191108},{8205244,913019450},{8205248,3098140501},{8205252,760687357},{8205260,3247780371},{8205264,3209639821},{8205268,1034244364},{8205280,749649898},{8205284,1037710429},{8205288,3185194068},{8205292,3181538549},{8205296,3103409466},{8205300,3124884935},{8205304,932144529},{8205308,838860800},{8205312,963227641},{8205316,2986344448},{8205320,3168079883},{8205324,1011210607},{8205328,3238243714},{8205332,3238243703},{8205336,3147971722},{8205340,1053636997},{8205344,975062924},{8205348,955437897},{8205352,2147483648},{8205356,3101987370},{8205368,3179223117},{8205372,3179164602},{8205472,3025655860},{8205476,906431790},{8205480,878172238},{8205488,3024825482},{8205492,3053915438},{8205496,877341862},{8205752,1129547252},{8205760,3197354276},{8205768,2998926688},{8205772,1129666824},{8205780,1105162035},{8205784,1074520242},{8205792,1129547252},{8205796,3197354276},{8205804,2998926688},{8205808,1129666824},{8205816,1105162035},{8205820,1074520242},{8205828,3211876086},{8205832,3180881943},{8205836,3187688025},{8205864,1129427993},{8205868,1119395298},{8205872,3197353759},{8205876,1105034486},{8205880,3180875220},{8205884,1084180706},{8205888,1058896743},{8205892,3197353759},{8205896,1129666077},{8205900,1074519752},{8205904,1109366483},{8205908,1080212761},{8205912,3282716726},{8205916,1105034484},{8205920,1074519752},{8205924,1080781585},{8205928,1053811307},{8205932,1060222224},{8205936,3227384496},{8205940,3183613457},{8205944,1113320417},{8205948,1057980288},{8205952,1084180706},{8205956,1080212760},{8205960,1060222224},{8205964,1058851486},{8205968,3282651467},{8205972,3227298929},{8205976,3229282291},{8205980,1068358528},{8205984,1119500965},{8206000,1113321187},{8206004,3229282291},{8206008,1084281448},{8206016,1068358528},{8206020,3282652059},{8206024,1119500965},{8206052,1113321187},{8206056,1084281448},{8206064,3282652059},{8206080,1094599604},{8206084,3267881519},{8206088,1066922428},{8206092,3264676731},{8206096,1142829810},{8206116,3141061431},{8206120,3196148649},{8206124,1103178036},{8206128,1018097992},{8206132,3141061431},{8206136,3196148649},{8206140,1103178036},{8206144,1018097992},{8206160,1065673967},{8206164,1061792384},{8206168,3235074676},{8206172,3235005324},{8206188,3242506054},{8206192,3212342284},{8206196,3165163826},{8206212,3242506054},{8206216,1080213554},{8206228,3212342284},{8206232,1042257077},{8206284,3165163826},{8206300,1080213554},{8206308,1042257077},{8206656,1017681244},{8206660,1097947007},{8206664,3245567087},{8206668,2977954944},{8206672,2998926688},{8206684,1017681244},{8206688,1097947007},{8206692,3074316526},{8206708,3245567087},{8206712,2977954944},{8206716,2998926688},{8206720,3189741743},{8206724,1073671834},{8206728,3049855211},{8206776,3074316526},{8206792,3189741743},{8206796,1073671834},{8206800,3049855211},{8206860,3200639240},{8206864,1041215293},{8206868,3265228542},{8206872,1074186795},{8206876,3242478020},{8206880,3196460891},{8206884,1154171282},{8206888,3197353785},{8206892,1090090016},{8206896,3180756500},{8206900,3232165402},{8206904,1108205241},{8206908,3197353799},{8206912,1154222938},{8206916,1074519730},{8206920,1116681909},{8206924,1080209063},{8206928,3281769562},{8206932,1090090008},{8206936,1074519750},{8206940,1151333006},{8206944,3255419525},{8206948,1125309565},{8206952,3227384502},{8206956,3183494865},{8206960,1118658876},{8206964,3255379019},{8206968,1140608090},{8206972,3233000273},{8206976,3265727486},{8206980,3232165414},{8206984,1080209037},{8206988,1125309565},{8206992,3233525564},{8206996,1160334148},{8207000,3241314298},{8207004,1108204531},{8207008,3281704302},{8207012,3227298953},{8207016,3261876883},{8207020,3241279614},{8207024,1165156063},{8207032,1154171282},{8207036,3107591735},{8207040,1000150968},{8207044,3094490079},{8207048,3142729582},{8207052,1018342333},{8207060,3197353785},{8207068,1154222937},{8207072,984586409},{8207076,1029277439},{8207080,990783973},{8207084,3192013125},{8207088,1090090016},{8207096,1074525532},{8207100,1151332674},{8207104,3168550685},{8207108,1038817365},{8207112,3139702817},{8207116,3180756500},{8207124,1116681907},{8207128,3255444581},{8207132,1140453051},{8207136,3146173469},{8207140,3183130728},{8207144,3232165402},{8207152,1080205180},{8207156,1125310892},{8207160,3220000932},{8207164,1160264952},{8207168,3145131354},{8207172,1108205241},{8207176,3281769356},{8207180,3226346476},{8207184,3263569194},{8207188,3240387648},{8207192,1164885498},{8207196,983800096},{8207220,1044303596},{8207224,3191787247},{8207236,989621187},{8207240,3137104835},{8207260,3076222336},{8207312,928738688},{8207368,983800096},{8207372,3122136107},{8207380,3131283906},{8207384,974652136},{8207972,2147483648},{8207980,0},{8207988,0},{8208076,1102707472},{8208092,3175892025},{8208104,3175506251},{8208120,3176216755},{8208140,3176215612},{8208156,923368639},{8208160,2942963457},{8208192,3188975865},{8208196,1034912466},{8208200,3255037649},{8208204,1055325296},{8208208,3220859005},{8208212,3189664419},{8208280,3091030937},{8208284,934272440},{8208288,3161069572},{8208348,3108107688},{8208356,981693159},{8210132,1000151892},{8210136,3057643747},{8210140,3255444681},{8210144,3079138568},{8210148,1116865447},{8210156,3219488205},{8210160,888734956},{8210164,3237414704},{8210168,1085573266},{8210172,867094953},{8210176,1084588285},{8210180,1074530161},{8210184,3030043767},{8210188,3260961048},{8210192,1118871334},{8210196,3047955349},{8210204,3079662695},{8210208,956551960},{8210212,1140452495},{8210216,1116865449},{8210220,3053448152},{8210228,1072004323},{8210232,884616117},{8210236,3196148646},{8210240,3240388124},{8210244,3035961132},{8210248,1084051788},{8210252,3222017530},{8210256,3021040318},{8210260,1113477410},{8210264,1118871370},{8210268,3063313397},{8210272,1018342482},{8210276,965710748},{8210280,3170684524},{8210284,3194110914},{8210288,3194110914},{8210292,3273084149},{8210296,3192013131},{8210300,990784087},{8210304,3088859709},{8210308,1158045986},{8210312,3176215612},{8210316,1014479488},{8210324,3119665529},{8210328,3158371206},{8210332,1119500963},{8210336,2899163496},{8210340,1129666824},{8210348,1074520070},{8210352,2844252747},{8210356,1039775306},{8210360,3186095495},{8210364,2882787262},{8210368,1084370971},{8210372,1080213555},{8210376,2849715598},{8210380,1042286640},{8210384,3282652240},{8210388,757280531},{8210392,936902642},{8210400,3142518207},{8210404,1019878700},{8210408,3167296371},{8210412,3094475185},{8210420,1022615740},{8210424,3085269057},{8210428,3075649516},{8210432,1165566347},{8210436,927355357},{8210440,1103178245},{8210444,1018115564},{8210448,3245567086},{8210452,3056754007},{8210460,1062331060},{8210464,3186051665},{8210468,3188604338},{8210472,1062335098},{8210476,3183129641},{8210480,1041075072},{8210484,1158123422},{8210488,3264784774},{8210492,3119665529},{8210496,1151332677},{8210500,1038817354},{8210504,3139702470},{8210508,3189741544},{8210516,941809459},{8210524,1062696251},{8210528,3145132004},{8210532,1160264987},{8210536,3263568475},{8210540,1068384066},{8210544,1038522036},{8210548,3229269631},{8210552,1039808202},{8210556,3220002936},{8210560,1029264229},{8210564,3219780253},{8211740,3217867164},{8211744,3208934609},{8211748,3184542864},{8211752,1070290955},{8211756,3208976386},{8211760,1040295934},{8211764,990411766},{8211768,3217337872},{8211772,3162586880},{8211812,870101760},{8211816,3060534285},{8211820,881846323},{8211824,957092046},{8211832,3178497589},{8211836,3016436888},{8211840,3045526830},{8211844,3017267265},{8211852,943029107},{8211856,3123845248},{8211860,3101115578},{8211888,964899837},{8211892,1040721118},{8211904,906444007},{8211908,953441506},{8211912,965756536},{8211916,1041684963},{8211928,906416286},{8211932,953040442},{8211936,3196318578},{8211940,961662061},{8211944,1037135771},{8211948,879131072},{8211952,3084115153},{8211960,886028508},{8211964,954208476},{8211972,886028444},{8211976,954207252},{8211980,983125383},{8211984,1059871782},{8211988,3063761422},{8211992,3131680897},{8211996,904507347},{8212000,972820552},{8212004,893510882},{8212008,965482318},{8212012,3031706334},{8212016,3101263708},{8212020,954344612},{8212024,1029726356},{8212028,3060534285},{8212032,957092046},{8212036,3178497589},{8212040,943029107},{8212044,3123845248},{8212048,3101115578},{8212052,870101760},{8212056,881846323},{8212064,870101760},{8212068,881846323},{8212080,3016436888},{8212084,3045526830},{8212088,3017267265},{8212096,878172238},{8212100,3053915438},{8212104,3025655860},{8212112,877341862},{8212116,906431790},{8212120,3024825482},{8212132,878172238},{8212136,3053915438},{8212140,3025655860},{8212148,877341862},{8212152,906431790},{8212156,3024825482},{8212164,3060534285},{8212168,957092046},{8212172,3178497589},{8212176,943029107},{8212180,3123845248},{8212184,3101115578},{8212192,878172238},{8212196,3053915438},{8212200,3025655860},{8212208,877341862},{8212212,906431790},{8212216,3024825482},{8212224,3192025169},{8212228,3196264882},{8212232,1050082315},{8212236,3192025169},{8212240,3196264882},{8212244,1050082315},{8212252,878172238},{8212256,3053915438},{8212260,3025655860},{8212268,877341862},{8212272,906431790},{8212276,3024825482},{8212288,878172238},{8212292,3053915438},{8212296,3025655860},{8212304,877341862},{8212308,906431790},{8212312,3024825482},{8212320,946252532},{8212324,958803907},{8212328,3178535193},{8212332,943029107},{8212336,3123845248},{8212340,3101115578},{8212348,878172238},{8212352,3053915438},{8212356,3025655860},{8212364,877341862},{8212368,906431790},{8212372,3024825482},{8212384,892248919},{8212396,892248919},{8212408,878172238},{8212412,3053915438},{8212416,3025655860},{8212424,877341862},{8212428,906431790},{8212432,3024825482},{8212444,878172238},{8212448,3053915438},{8212452,3025655860},{8212460,877341862},{8212464,906431790},{8212468,3024825482},{8212476,939421944},{8212480,967843274},{8212484,3178853211},{8212488,943029107},{8212492,3123845248},{8212496,3101115578},{8212500,1040721118},{8212504,964899837},{8212512,3143595004},{8212516,1041028216},{8212520,3027353182},{8212528,1019939834},{8212536,3167296976},{8212544,1067089359},{8212548,1061466772},{8212552,1051042313},{8212556,1067089647},{8212560,1061466876},{8212564,1051050627},{8212572,3143595004},{8212576,1041028216},{8212580,3027353182},{8212588,1019939834},{8212596,3167296976},{8212608,3185081373},{8212612,3143595004},{8212616,1033778746},{8212624,1061380362},{8212628,3027353182},{8212632,1032915550},{8212636,1065348060},{8212640,1022717525},{8212644,1019939834},{8212648,3214584861},{8212656,3208827954},{8212660,3167296976},{8212664,1067108512},{8212676,1007068300},{8212680,985577113},{8212684,1033453163},{8212688,946797745},{8212692,3123800903},{8212696,3102473606},{8212708,3157975842},{8212712,3173855860},{8212716,999470669},{8212720,1065135599},{8212724,3190051940},{8212732,1042545250},{8212736,1065120567},{8212740,1067089647},{8212744,1061466876},{8212748,1051050627},{8212752,1067089647},{8212756,1061466876},{8212760,1051050627},{8212788,3157975842},{8212792,3173855860},{8212796,999470669},{8212800,1065135599},{8212804,3190051940},{8212812,1042545250},{8212816,1065120567},{8212824,3171451754},{8212832,1065065210},{8212840,1043976311},{8212844,1018229301},{8212848,1014064913},{8212852,1032886506},{8212856,940952337},{8212860,3123984731},{8212864,919101966},{8212868,953441506},{8212876,3148959045},{8212880,3174171540},{8212884,999470669},{8212888,1065349147},{8212892,3165685344},{8212900,1018086088},{8212904,1065333460},{8212908,1067089647},{8212912,1061466876},{8212916,1051050627},{8212920,1067089647},{8212924,1061466876},{8212928,1051050627},{8212932,906444007},{8212940,3148959045},{8212944,3174171540},{8212948,999470669},{8212952,1065349147},{8212956,3165685344},{8212964,1018086088},{8212968,1065333460},{8212996,1018229301},{8213000,1000087320},{8213004,1033069507},{8213008,940952337},{8213012,3122144388},{8213016,3099345340},{8213020,1041684963},{8213024,965756536},{8213032,996113077},{8213036,1041028215},{8213040,3027353182},{8213048,3167423309},{8213056,1019813120},{8213064,1067089356},{8213068,3208950424},{8213072,1050922809},{8213076,1067089673},{8213080,3208950539},{8213084,1050931952},{8213092,996113077},{8213096,1041028215},{8213100,3027353182},{8213108,3167423309},{8213116,1019813120},{8213128,1037597735},{8213132,996113077},{8213136,1034253340},{8213140,1041028215},{8213144,3208865493},{8213148,3027353182},{8213152,1032445387},{8213156,1065348061},{8213160,3170207690},{8213164,3167423309},{8213168,3214588970},{8213176,1061344316},{8213180,1019813120},{8213184,1067108541},{8213196,1006912915},{8213200,3132840109},{8213204,1035369055},{8213208,946797745},{8213212,3123882421},{8213216,3097844931},{8213228,1010448824},{8213232,3173858796},{8213236,3146955145},{8213240,1065138186},{8213244,1042504447},{8213252,3189965116},{8213256,1065123148},{8213260,1067089673},{8213264,3208950539},{8213268,1050931952},{8213272,1067089673},{8213276,3208950539},{8213280,1050931952},{8213308,1010448824},{8213312,3173858796},{8213316,3146955145},{8213320,1065138186},{8213324,1042504447},{8213332,3189965116},{8213336,1065123148},{8213344,1023922149},{8213352,1065068187},{8213360,3191397408},{8213364,1019537289},{8213368,3163362842},{8213372,1034744848},{8213376,942624652},{8213380,3123406491},{8213384,3109927072},{8213388,953040442},{8213396,1001386233},{8213400,3174172938},{8213404,3146955145},{8213408,1065349488},{8213412,1017684400},{8213420,3165052992},{8213424,1065333797},{8213428,1067089673},{8213432,3208950539},{8213436,1050931952},{8213440,1067089673},{8213444,3208950539},{8213448,1050931952},{8213452,906416286},{8213460,1001386233},{8213464,3174172938},{8213468,3146955145},{8213472,1065349488},{8213476,1017684400},{8213484,3165052992},{8213488,1065333797},{8213516,1019537289},{8213520,3148724683},{8213524,1034956246},{8213528,942624652},{8213532,3122113202},{8213536,3103279790},{8213540,1037135771},{8213544,3084115153},{8213548,961662061},{8213556,3132179102},{8213560,3188066832},{8213564,3023791139},{8213568,1065352320},{8213572,3156822338},{8213580,1009243245},{8213584,1065207957},{8213592,890273884},{8213596,1042681970},{8213604,3050125262},{8213608,1042695280},{8213612,879131072},{8213624,879131071},{8213628,3026614719},{8213636,3132179344},{8213640,3188066832},{8213644,3023791139},{8213648,1065352318},{8213652,3156822569},{8213660,1009243472},{8213664,1065207955},{8213672,3029420516},{8213676,3132179101},{8213680,1048827812},{8213684,3132180891},{8213688,3188066832},{8213692,3140387805},{8213696,3188066697},{8213700,3023791139},{8213704,3175269785},{8213708,1065352320},{8213712,1015548084},{8213716,1065352318},{8213720,3156822338},{8213724,1070445348},{8213728,3156822797},{8213736,906595100},{8213740,1009243245},{8213744,3217760787},{8213748,1009243679},{8213752,1065207957},{8213756,1015436697},{8213760,1065207960},{8213764,3154025322},{8213768,3114571692},{8213772,1026325046},{8213776,915213308},{8213780,3123863694},{8213784,3100807034},{8213788,954208476},{8213792,1065208809},{8213796,3139528638},{8213800,3188066832},{8213804,982697851},{8213808,1065352307},{8213812,3156822569},{8213816,1040584414},{8213820,1009086029},{8213824,1065207955},{8213828,3217884593},{8213832,1061448000},{8213836,1049364794},{8213840,3217884593},{8213844,1061448000},{8213848,1049364794},{8213852,886028508},{8213856,1065208809},{8213860,3139528638},{8213864,3188066832},{8213868,982697851},{8213872,1065352307},{8213876,3156822569},{8213880,1040584414},{8213884,1009086029},{8213888,1065207955},{8213916,3026614719},{8213920,797191196},{8213924,879131061},{8213932,3154012619},{8213936,3114287630},{8213940,1026325912},{8213944,912716325},{8213948,3122028220},{8213952,3100807034},{8213956,954207252},{8213960,1065208860},{8213964,3112025256},{8213968,3188066832},{8213972,3130184503},{8213976,1065352306},{8213980,3156822569},{8213984,1040582875},{8213988,1009400898},{8213992,1065207955},{8213996,3217867159},{8214000,3208967817},{8214004,1048836596},{8214008,3217867159},{8214012,3208967817},{8214016,1048836596},{8214020,886028444},{8214024,1065208860},{8214028,3112025256},{8214032,3188066832},{8214036,3130184503},{8214040,1065352306},{8214044,3156822569},{8214048,1040582875},{8214052,1009400898},{8214056,1065207955},{8214084,3026614719},{8214088,2944674848},{8214092,879131061},{8214100,3154229524},{8214104,3114891147},{8214108,1026324178},{8214112,916889305},{8214116,3122028211},{8214120,3100807034},{8214124,1059871782},{8214128,3212836864},{8214132,3032284379},{8214136,3053915438},{8214140,884800718},{8214144,3212836864},{8214148,877341862},{8214152,3053915439},{8214156,877341812},{8214164,870101760},{8214168,881846323},{8214176,870101760},{8214180,881846323},{8214188,983125383},{8214192,3212836864},{8214196,3032284379},{8214200,3053915438},{8214204,884800718},{8214208,3212836864},{8214212,877341862},{8214216,3053915439},{8214220,877341812},{8214228,3212836864},{8214232,3032284379},{8214236,3053915438},{8214240,884800718},{8214244,3212836864},{8214248,877341862},{8214252,3053915439},{8214256,877341812},{8214264,913578137},{8214268,3104576469},{8214272,3178497589},{8214276,1059871056},{8214280,976361599},{8214284,3101115578},{8214288,3131680897},{8214292,3212836864},{8214296,3032284379},{8214300,3053915438},{8214304,884800718},{8214308,3212836864},{8214312,877341862},{8214316,3053915439},{8214320,877341812},{8214328,870101760},{8214332,881846323},{8214340,870101760},{8214344,881846323},{8214352,3063761422},{8214356,3212836864},{8214360,3032284379},{8214364,3053915438},{8214368,884800718},{8214372,3212836864},{8214376,877341862},{8214380,3053915439},{8214384,877341812},{8214392,3212836864},{8214396,3032284379},{8214400,3053915438},{8214404,884800718},{8214408,3212836864},{8214412,877341862},{8214416,3053915439},{8214420,877341812},{8214428,913578137},{8214432,3104576469},{8214436,3178497589},{8214440,3132052574},{8214444,976361599},{8214448,3101115578},{8214452,972820552},{8214456,3212836864},{8214460,3032284379},{8214464,3053915438},{8214468,884800718},{8214472,3212836864},{8214476,877341862},{8214480,3053915439},{8214484,877341812},{8214492,870101760},{8214496,881846323},{8214504,870101760},{8214508,881846323},{8214516,904507347},{8214520,3212836864},{8214524,3032284379},{8214528,3053915438},{8214532,884800718},{8214536,3212836864},{8214540,877341862},{8214544,3053915439},{8214548,877341812},{8214556,3212836864},{8214560,3032284379},{8214564,3053915438},{8214568,884800718},{8214572,3212836864},{8214576,877341862},{8214580,3053915439},{8214584,877341812},{8214592,913578137},{8214596,3104576469},{8214600,3178497589},{8214604,971333845},{8214608,976361599},{8214612,3101115578},{8214616,965482318},{8214620,3101263708},{8214624,1029726356},{8214628,893510882},{8214632,3031706334},{8214636,954344612},{8214644,878172238},{8214648,3053915438},{8214652,3025655860},{8214660,877341862},{8214664,906431790},{8214668,3024825482},{8214676,1028443146},{8214680,884222307},{8214688,1028443339},{8214692,757465088},{8214704,878172238},{8214708,3053915438},{8214712,3025655860},{8214720,877341862},{8214724,906431790},{8214728,3024825482},{8214740,878172238},{8214748,3053915438},{8214752,3031706334},{8214756,3025655860},{8214768,877341862},{8214772,3175927182},{8214776,906431790},{8214780,884222686},{8214784,3024825482},{8214788,1028443534},{8214796,3078394443},{8214800,921330216},{8214804,3147567128},{8214808,943029107},{8214812,3123845248},{8214816,3101115578},{8214836,3175892025},{8214860,3175506251},{8214868,3267069075},{8214872,3236390602},{8214876,3291577958},{8214884,3176216756},{8214888,2147483648},{8214892,3267066923},{8214896,3236831035},{8214900,3291577958},{8214908,3176215612},{8214916,1132109004},{8214920,3298046285},{8214924,3264244117},{8214928,1111545571},{8214932,3331492786},{8214936,3266164241},{8214940,3140485167},{8214944,964977582},{8214952,3131152447},{8214956,955456297},{8214968,3269811855},{8214972,3291516840},{8214980,1122238989},{8214984,3291518645},{8214992,3235403467},{8214996,1162886443},{8215000,1157379485},{8215004,1158665713},{8215008,3158371212},{8215012,1102707472},{8215016,941809459},{8215020,1028278097},{8215024,3152244071},{8215028,1027896077},{8215032,1004330902},{8215036,1037121135},{8215040,3163763964},{8215044,1005027155},{8215048,3237238750},{8215052,870101760},{8215056,881846323},{8215068,878172238},{8215072,3053915438},{8215076,3025655860},{8215084,877341862},{8215088,906431790},{8215092,3024825482},{8215100,3145183248},{8215104,1041430805},{8215108,3263170423},{8215112,1017574139},{8215116,3218442163},{8215120,3196955774},{8215124,3264244117},{8215128,1111545571},{8215132,3331492786},{8215136,1132109004},{8215140,3298046285},{8215144,3266164241},{8215148,3192025169},{8215152,3196264882},{8215156,1050082315},{8215164,878172238},{8215168,3053915438},{8215172,3025655860},{8215180,877341862},{8215184,906431790},{8215188,3024825482},{8215196,3192025169},{8215200,3196264882},{8215204,1050082315},{8215212,878172238},{8215216,3053915438},{8215220,3025655860},{8215228,877341862},{8215232,906431790},{8215236,3024825482},{8215244,1005927051},{8215248,1018211670},{8215252,3238135015},{8215256,3140485167},{8215260,964977582},{8215272,892248919},{8215284,878172238},{8215288,3053915438},{8215292,3025655860},{8215300,877341862},{8215304,906431790},{8215308,3024825482},{8215320,892248919},{8215332,878172238},{8215336,3053915438},{8215340,3025655860},{8215348,877341862},{8215352,906431790},{8215356,3024825482},{8215364,989355160},{8215368,1017899140},{8215372,3228794243},{8215376,965588710},{8215380,3146453485},{8215384,3123189986},{8215388,3131152447},{8215392,955456297},{8215400,1067089359},{8215404,1061466772},{8215408,1051042313},{8215416,3143595004},{8215420,1041028216},{8215424,3027353182},{8215432,1019939834},{8215440,3167296976},{8215448,1067089647},{8215452,1061466876},{8215456,1051050627},{8215464,3143595004},{8215468,1041028216},{8215472,3027353182},{8215480,1019939834},{8215488,3167296976},{8215496,1157379485},{8215500,1067089647},{8215504,1061466876},{8215508,1051050627},{8215516,3157975842},{8215520,3173855860},{8215524,999470669},{8215528,1065135599},{8215532,3190051940},{8215540,1042545250},{8215544,1065120567},{8215548,1067089647},{8215552,1061466876},{8215556,1051050627},{8215564,3157975842},{8215568,3173855860},{8215572,999470669},{8215576,1065135599},{8215580,3190051940},{8215588,1042545250},{8215592,1065120567},{8215596,1070197048},{8215600,1065990930},{8215604,1084555146},{8215608,939435523},{8215612,3096456675},{8215616,917132121},{8215624,3269811855},{8215628,3291516840},{8215632,1028278097},{8215636,3152244071},{8215640,1067089647},{8215644,1061466876},{8215648,1051050627},{8215656,3148959045},{8215660,3174171540},{8215664,999470669},{8215668,1065349147},{8215672,3165685344},{8215680,1018086088},{8215684,1065333460},{8215688,1067089647},{8215692,1061466876},{8215696,1051050627},{8215704,3148959045},{8215708,3174171540},{8215712,999470669},{8215716,1065349147},{8215720,3165685344},{8215728,1018086088},{8215732,1065333460},{8215736,3129087228},{8215756,3175892025},{8215764,1067089356},{8215768,3208950424},{8215772,1050922809},{8215780,996113077},{8215784,1041028215},{8215788,3027353182},{8215796,3167423309},{8215804,1019813120},{8215812,1067089673},{8215816,3208950539},{8215820,1050931952},{8215828,996113077},{8215832,1041028215},{8215836,3027353182},{8215844,3167423309},{8215852,1019813120},{8215860,1158665713},{8215864,1067089673},{8215868,3208950539},{8215872,1050931952},{8215880,1010448824},{8215884,3173858796},{8215888,3146955145},{8215892,1065138186},{8215896,1042504447},{8215904,3189965116},{8215908,1065123148},{8215912,1067089673},{8215916,3208950539},{8215920,1050931952},{8215928,1010448824},{8215932,3173858796},{8215936,3146955145},{8215940,1065138186},{8215944,1042504447},{8215952,3189965116},{8215956,1065123148},{8215960,1071689576},{8215964,3214999019},{8215968,1086675676},{8215972,940901277},{8215976,3095994083},{8215980,3107747465},{8215988,1122238989},{8215992,3291518645},{8215996,1027896077},{8216000,1004330902},{8216004,1067089673},{8216008,3208950539},{8216012,1050931952},{8216020,1001386233},{8216024,3174172938},{8216028,3146955145},{8216032,1065349488},{8216036,1017684400},{8216044,3165052992},{8216048,1065333797},{8216052,1067089673},{8216056,3208950539},{8216060,1050931952},{8216068,1001386233},{8216072,3174172938},{8216076,3146955145},{8216080,1065349488},{8216084,1017684400},{8216092,3165052992},{8216096,1065333797},{8216100,3129060564},{8216120,3175506251},{8216132,890273884},{8216136,1042681970},{8216144,3132179102},{8216148,3188066832},{8216152,3023791139},{8216156,1065352320},{8216160,3156822338},{8216168,1009243245},{8216172,1065207957},{8216180,3050125262},{8216184,1042695280},{8216192,3132179344},{8216196,3188066832},{8216200,3023791139},{8216204,1065352318},{8216208,3156822569},{8216216,1009243472},{8216220,1065207955},{8216224,3204832798},{8216228,3165459532},{8216232,1077239530},{8216236,934301435},{8216240,3115475086},{8216244,3120798125},{8216252,3235403467},{8216256,1162886443},{8216260,3158371212},{8216264,1037121135},{8216268,3217884593},{8216272,1061448000},{8216276,1049364794},{8216280,1065208809},{8216284,3139528638},{8216288,3188066832},{8216292,982697851},{8216296,1065352307},{8216300,3156822569},{8216304,1040584414},{8216308,1009086029},{8216312,1065207955},{8216316,3217884593},{8216320,1061448000},{8216324,1049364794},{8216328,1065208809},{8216332,3139528638},{8216336,3188066832},{8216340,982697851},{8216344,1065352307},{8216348,3156822569},{8216352,1040584414},{8216356,1009086029},{8216360,1065207955},{8216364,3205572454},{8216368,3166101074},{8216372,1078252461},{8216376,916185970},{8216380,3128532290},{8216384,3104710873},{8216388,3267069075},{8216392,3236390602},{8216396,3291577958},{8216404,3176216756},{8216408,2147483648},{8216412,3217867159},{8216416,3208967817},{8216420,1048836596},{8216424,1065208860},{8216428,3112025256},{8216432,3188066832},{8216436,3130184503},{8216440,1065352306},{8216444,3156822569},{8216448,1040582875},{8216452,1009400898},{8216456,1065207955},{8216460,3217867159},{8216464,3208967817},{8216468,1048836596},{8216472,1065208860},{8216476,3112025256},{8216480,3188066832},{8216484,3130184503},{8216488,1065352306},{8216492,3156822569},{8216496,1040582875},{8216500,1009400898},{8216504,1065207955},{8216508,3205760632},{8216512,3166789740},{8216516,1078250483},{8216520,920711179},{8216524,3128532276},{8216528,3104710873},{8216532,3267066923},{8216536,3236831035},{8216540,3291577958},{8216548,3176215612},{8216556,870101760},{8216560,881846323},{8216568,3212836864},{8216572,3032284379},{8216576,3053915438},{8216580,884800718},{8216584,3212836864},{8216588,877341862},{8216592,3053915439},{8216596,877341812},{8216604,870101760},{8216608,881846323},{8216616,3212836864},{8216620,3032284379},{8216624,3053915438},{8216628,884800718},{8216632,3212836864},{8216636,877341862},{8216640,3053915439},{8216644,877341812},{8216652,1034253429},{8216656,1102707472},{8216660,870101760},{8216664,881846323},{8216672,3212836864},{8216676,3032284379},{8216680,3053915438},{8216684,884800718},{8216688,3212836864},{8216692,877341862},{8216696,3053915439},{8216700,877341812},{8216708,870101760},{8216712,881846323},{8216720,3212836864},{8216724,3032284379},{8216728,3053915438},{8216732,884800718},{8216736,3212836864},{8216740,877341862},{8216744,3053915439},{8216748,877341812},{8216756,3101715454},{8216760,941809459},{8216764,870101760},{8216768,881846323},{8216776,3212836864},{8216780,3032284379},{8216784,3053915438},{8216788,884800718},{8216792,3212836864},{8216796,877341862},{8216800,3053915439},{8216804,877341812},{8216812,870101760},{8216816,881846323},{8216824,3212836864},{8216828,3032284379},{8216832,3053915438},{8216836,884800718},{8216840,3212836864},{8216844,877341862},{8216848,3053915439},{8216852,877341812},{8216860,945566719},{8216864,1028443146},{8216868,884222307},{8216880,878172238},{8216884,3053915438},{8216888,3025655860},{8216896,877341862},{8216900,906431790},{8216904,3024825482},{8216912,1028443339},{8216916,757465088},{8216928,878172238},{8216932,3053915438},{8216936,3025655860},{8216944,877341862},{8216948,906431790},{8216952,3024825482},{8216960,3091033529},{8216964,934267294},{8216968,3161069604},{8216972,3163763964},{8216976,1005027155},{8216980,3237238750},{8216984,3203454228},{8216988,1039587177},{8216992,3264785048},{8216996,1074112663},{8217000,3240716742},{8217004,3194714816},{8217008,3063706097},{8217012,887839713},{8217020,3054478279},{8217024,878188582},{8217032,2147483648},{8217044,1085201749},{8217048,1051666801},{8217052,1031409304},{8217056,3185434298},{8217060,3201032778},{8217064,3223122296},{8217072,981520613},{8217076,3104888019},{8217096,3129087227},{8217104,1087387949},{8217108,1051666837},{8217112,3178893175},{8217116,3185434301},{8217120,1053469812},{8217124,3223123901},{8217132,981494208},{8217136,957374681},{8217156,3129060563},{8217160,2147483648},{8217164,3212014882},{8217168,3180882572},{8217172,1091551139},{8217176,1000974660},{8217180,3179946568},{8217184,824556202},{8217188,3198594663},{8217192,3167596710},{8217196,3223176626},{8217204,3108107749},{8217212,3198592749},{8217216,3167988204},{8217220,3223176626},{8217228,3108107688},{8217236,1034253431},{8217240,839622297},{8217244,867088229},{8217248,873922408},{8217252,2147483648},{8217264,2147483648},{8217272,3091033515},{8217276,934267284},{8217280,3161069593},{8217284,1154171283},{8217288,3197353839},{8217292,1090091473},{8217296,3180745141},{8217300,3231997577},{8217304,1108205359},{8217308,3197353854},{8217312,1154222941},{8217316,1074519442},{8217320,1116671381},{8217324,1080209188},{8217328,3281769568},{8217332,1090091477},{8217336,1074519462},{8217340,1151333008},{8217344,3255419654},{8217348,1125309586},{8217352,3227383948},{8217356,3183483041},{8217360,1118648348},{8217364,3255379150},{8217368,3231997590},{8217372,1080209161},{8217376,1125309585},{8217380,1108204650},{8217384,3281704309},{8217388,3227298398},{8217416,1140607278},{8217420,3265724759},{8217424,1160334179},{8217428,3261871426},{8217432,1165156196},{8217436,3070892857},{8217440,981594587},{8217444,943455115},{8217448,1062822655},{8217452,1019822396},{8217456,999596291},{8217460,1019822396},{8217464,1040222872},{8217468,3188258794},{8217472,999596304},{8217476,3188258794},{8217480,1062422308},{8217484,3233001233},{8217488,3233526525},{8217492,3241312923},{8217496,3241278237},{8217500,923191631},{8217504,981568323},{8217508,3090642623},{8217512,1062822798},{8217516,3167240667},{8217520,999496448},{8217524,3167240665},{8217528,1040205316},{8217532,1040730648},{8217536,999496492},{8217540,1040730647},{8217544,1062426553},{8217552,2809038325},{8217572,2899164216},{8217588,2809496251},{8217592,2886136990},{8217600,3059427886},{8217604,2785488089},{8217608,2804793098},{8217620,3069023512},{8217644,2785030878},{8217664,2810541057},{5287048,3175761746},{5287132,1018127581},{5287148,941105047},{5288972,1067089461},{5288976,1061535303},{5288980,3172441984},{5288984,1016658272},{5288988,995740738},{5288992,1033198095},{5289665,3175379726},{5289749,3165098621},{5289765,940817750},{5291589,1067089497},{5291593,3209015916},{5291597,3173361656},{5291601,3214401293},{5291605,3209079689},{5291609,1040066283},{5292282,3176216747},{5292366,1009086029},{5292382,961918289},{5294206,3217884633},{5294210,1061480270},{5294214,3182425296},{5294218,3214681899},{5294222,1061519808},{5294226,1034304795},{5294899,3176215604},{5294983,1009400898},{5294999,961918070},{5296823,3217867164},{5296827,3208934609},{5296831,3184542864},{5296835,1070290955},{5296839,3208976386},{5296843,1040295934}}}},
items={{["item"]=12,["tag"]="max",["raw"]=9,["structure"]="natural",["pool"]=4660,["litTop"]=15464784,["hash"]=847208559,["var"]={}},{["item"]=13,["tag"]="min",["raw"]=1,["structure"]="natural",["pool"]=4660,["litTop"]=15464784,["hash"]=157613783,["var"]={}},{["item"]=13,["tag"]="+1",["raw"]=5,["structure"]="natural",["pool"]=4660,["litTop"]=15464784,["hash"]=3914025722,["var"]={}},{["item"]=14,["tag"]="-1",["raw"]=3,["structure"]="natural",["pool"]=4660,["litTop"]=15464784,["hash"]=1384002853,["var"]={}},{["item"]=40,["tag"]="min",["raw"]=1056964607,["structure"]="natural",["pool"]=4660,["litTop"]=15464784,["hash"]=459062861,["var"]={{8204196,1156415487},{8204200,1156415487},{8204204,1156415488},{8204208,1156415488}}},{["item"]=40,["tag"]="+1",["raw"]=1061158911,["structure"]="natural",["pool"]=4660,["litTop"]=15464784,["hash"]=1570553421,["var"]={{8204196,1160912895},{8204200,1160912895},{8204204,1148026883},{8204208,1148026883}}},{["item"]=41,["tag"]="-1",["raw"]=1001401356,["structure"]="natural",["pool"]=4660,["litTop"]=15464784,["hash"]=1253483481,["var"]={}},{["item"]=43,["tag"]="max",["raw"]=19,["structure"]="natural",["pool"]=4660,["litTop"]=15464784,["hash"]=3331388863,["var"]={{8204132,3359844992},{8210292,1035084226},{8214916,1102457745},{8214928,3148014013},{8214936,1017481746},{8215000,1158083941},{8215004,1158081956},{8215128,3148014013},{8215136,1102457745},{8215144,1017481746},{8215496,1158083941},{8215860,1158081956}}},{["item"]=44,["tag"]="max",["raw"]=31,["structure"]="natural",["pool"]=4660,["litTop"]=15464784,["hash"]=1671731517,["var"]={{8204136,3335611711}}},{["item"]=48,["tag"]="-1",["raw"]=1099431936,["structure"]="natural",["pool"]=4660,["litTop"]=15464784,["hash"]=3876915738,["var"]={}},{["item"]=49,["tag"]="-1",["raw"]=1114529168,["structure"]="natural",["pool"]=4660,["litTop"]=15464784,["hash"]=666260463,["var"]={}},{["item"]=53,["tag"]="-1",["raw"]=11,["structure"]="natural",["pool"]=4660,["litTop"]=15464784,["hash"]=541177250,["var"]={}}},
dyn={["name"]="brakes_aero_tyres",["items"]={[40]=1059313418,[0]=1107558400,[1]=1109131264,[2]=1107820544,[3]=1110179840,[59]=1053609164,[61]=1092616192,[49]=1106884442},["ticks"]=2304,["first"]=8,["orig"]={{1,-3.8937253421522655e-09,0.008242015726864338,-1.3349037430998578e-07,0.00033608509693294764,0.4195873737335205,-0.11113060265779495,5.359253805181652e-07,-2.457985146975261e-06,3.64837795530093e-08,0.9999999403953552,2.667128501343541e-05,-0.0009007113985717297,0.0006067918729968369,0.0009643621742725372,0.6998181939125061,-0.002240143483504653,0.0,2.731351287366124e-06,0.00010125549306394532,0.0009659414063207805,0.7558624148368835,0.002240143483504653,0.0,2.7283551844448084e-06,0.00012737137149088085,0.0007069687126204371,1.0096957683563232,-1.024540324578993e-06,-0.1375846266746521,9.733421393320896e-07,-3.270810339017771e-05,9.732704029374872e-07,0.00027528483769856393,0.0037406885530799627,0.8067272901535034,0.001394794206134975,0.8067272305488586,4.379878191684838e-06,0.0005457975785247982,1.9321694253449095e-06,-0.007914543151855469,5.486829763867718e-07,-0.00036738355993293226,0.00038045059773139656,0.09181865304708481,1},{2,5.570840949076228e-05,0.02269824594259262,2.7311659778206376e-06,-0.0005022149416618049,0.41914260387420654,-0.12746284902095795,-7.626405817973136e-07,7.616702646373597e-07,1.969517370525864e-06,0.9999999403953552,-0.00438442500308156,0.010725789703428745,0.002872961573302746,0.005065308418124914,1.5887930393218994,-0.002240143483504653,0.0,1.8226587599201594e-06,0.030812544748187065,0.0054461234249174595,1.7357059717178345,0.002240143483504653,0.0,3.1730131013318896e-05,0.05788428336381912,0.0070619429461658,2.516162633895874,-0.0009437219123356044,-0.386588454246521,-5.291499292070512e-06,-0.006301430054008961,-3.7095103380124783e-06,-0.005881969816982746,0.00723887188360095,1.205058217048645,0.004892977420240641,1.205058217048645,-2.0252269678167067e-05,-0.027412647381424904,-5.558360498980619e-05,-0.025924202054739,-3.5728210150409723e-06,-0.0013680988922715187,0.0007284641615115106,0.08818898350000381,1},{3,0.00015615488518960774,0.03401092067360878,4.0698378143133596e-06,-8.8935557869263e-05,0.41871190071105957,-0.10347703844308853,-1.259947384824045e-05,3.511782779241912e-05,7.3959986366389785e-06,0.9999998807907104,-0.010506073012948036,0.03260050341486931,0.004312407691031694,0.011883812956511974,2.2140164375305176,-0.002240143483504653,0.0,0.0004216974484734237,0.23735669255256653,0.012889344245195389,2.4078986644744873,0.002240143483504653,0.0,0.0006632999866269529,0.33426985144615173,0.01805129460990429,3.6490302085876465,-0.002648183610290289,-0.5627711415290833,-2.0719355234177783e-05,-0.011959118768572807,-0.00011941867705900222,-0.0721309557557106,0.012113331817090511,1.6010726690292358,0.009767437353730202,1.6010726690292358,-0.00031531054992228746,-0.18920265138149261,-0.00017672523972578347,-0.04350633919239044,-1.4741083759872708e-05,-0.004126026760786772,0.00099364563357085,0.04940181225538254,1},{4,0.0002906373410951346,0.04243464767932892,8.097422323771752e-06,0.0017661568708717823,0.4184211194515228,-0.05467258766293526,-3.5138898965669796e-05,0.00011314820585539564,1.4904562704032287e-05,0.9999998807907104,-0.016500558704137802,0.06063390523195267,0.004902905784547329,0.02039089985191822,2.5796098709106445,-0.002240143483504653,0.0,0.0019022267078980803,0.611530601978302,0.022111792117357254,2.7712061405181885,0.002240143483504653,0.0,0.0026468480937182903,0.7774494290351868,0.03235207498073578,4.418649673461914,-0.004825585056096315,-0.6435819864273071,-0.00014458804798778147,-0.04724478721618652,-0.0006066853529773653,-0.2685152292251587,0.018361641094088554,1.9966089725494385,0.01601574569940567,1.996608853340149,-0.0016903650248423219,-0.7104600071907043,-0.0003557216259650886,-0.05921241641044617,-3.63705403287895e-05,-0.007977570407092571,0.0010786083294078708,-0.006148739252239466,1},{5,0.0004508442943915725,0.05114300549030304,2.0188384951325133e-05,0.00531099084764719,0.4183288514614105,0.008220567367970943,-6.844925519544631e-05,0.00024481589207425714,2.3154274458647706e-05,0.9999998807907104,-0.02195128984749317,0.0934176817536354,0.004274305887520313,0.0297679640352726,2.706834077835083,-0.002240143483504653,0.0,0.004839632660150528,0.8468134999275208,0.032103389501571655,2.844378709793091,0.002240143483504653,0.0,0.006225225981324911,0.8982712626457214,0.04870488494634628,4.8198561668396,-0.007099378854036331,-0.6106559634208679,-0.0004116015916224569,-0.15735015273094177,-0.0021956029813736677,-0.777235209941864,0.025981564074754715,2.392085075378418,0.02363566868007183,2.392084836959839,-0.005866209510713816,-2.1028170585632324,-0.0005871530156582594,-0.07560250908136368,-7.268889021361247e-05,-0.012859594076871872,0.0009562848135828972,-0.06637357920408249,1},{6,0.0006417349795810878,0.05819537118077278,4.618713865056634e-05,0.010750787332654,0.41847488284111023,0.07951444387435913,-0.0001108486540033482,0.0004364551277831197,2.9046541385469027e-05,0.9999998807907104,-0.025756726041436195,0.12847775220870972,-0.00020185753237456083,0.039173346012830734,2.5971641540527344,-0.002240143483504653,0.0,0.0084229139611125,0.8890597820281982,0.04184841364622116,2.6340808868408203,0.002240143483504653,0.0,0.010038690641522408,1.040566325187683,0.06581222265958786,4.856693267822266,-0.009057425893843174,-0.46119117736816406,-0.001373457838781178,-0.6178287863731384,-0.006183930207043886,-1.1660605669021606,0.034974370151758194,2.7886030673980713,0.03262847661972046,2.7886030673980713,-0.017004122957587242,-4.0137505531311035,-0.0008754412992857397,-0.08909276127815247,-0.0001263527519768104,-0.018300723284482956,0.0006220749928615987,-0.12020766735076904,1},{7,0.0008582761511206627,0.05939844250679016,9.11056631593965e-05,0.016698559746146202,0.4188775420188904,0.1529218554496765,-0.00015899285790510476,0.0006902304594404995,2.502317693142686e-05,0.9999997615814209,-0.027675388380885124,0.163428395986557,-0.005414965096861124,0.04780775308609009,2.311457872390747,-0.002240143483504653,0.0,0.011784585192799568,0.94082111120224,0.050410423427820206,2.2820522785186768,0.002240143483504653,0.0,0.013546514324843884,0.9827878475189209,0.08243587613105774,4.558172225952148,-0.010306987911462784,-0.21598152816295624,-0.004477408714592457,-0.7585046887397766,-0.011714373715221882,-1.4540592432022095,0.04534466192126274,3.1864023208618164,0.042998768389225006,3.1864025592803955,-0.036431506276130676,-4.978268623352051,-0.0012087214272469282,-0.09421824663877487,-0.000197115441551432,-0.022939370945096016,0.00011903436825377867,-0.15074746310710907,1},{8,0.0010694253724068403,0.05714266747236252,0.00015283578250091523,0.02002320997416973,0.4195350110530853,0.22451627254486084,-0.00020848243730142713,0.0010037843603640795,1.236223124578828e-05,0.9999995231628418,-0.028929967433214188,0.19614268839359283,-0.008527737110853195,0.05523454025387764,1.961072564125061,-0.002240143483504653,0.0,0.014956556260585785,0.8878691792488098,0.05769813805818558,1.9118763208389282,0.002240143483504653,0.0,0.016863949596881866,0.9297134876251221,0.09747679531574249,4.043663501739502,-0.010599738918244839,-0.05498022586107254,-0.009113901294767857,-1.0531290769577026,-0.016800960525870323,-1.5443470478057861,0.057099130004644394,3.5842573642730713,0.05475324019789696,3.584256887435913,-0.0583084337413311,-5.844321250915527,-0.0015468273777514696,-0.09395568817853928,-0.0002777010085992515,-0.024411441758275032,-0.00045278447214514017,-0.1621103435754776,1},{72,0.004463917575776577,0.0058069690130651,0.0047274623066186905,0.012615576386451721,0.4634421765804291,-0.28507113456726074},{144,0.004852776415646076,-0.0445902980864048,0.007465264294296503,0.00856916606426239,0.39695268869400024,0.051432132720947266},{216,0.003966518212109804,-0.011031396687030792,0.00774844316765666,0.001308384700678289,0.4157564342021942,0.015338005498051643},{288,0.006507274694740772,0.04999689757823944,0.008215200155973434,-0.005213872063905001,0.4161807596683502,0.021935133263468742},{360,0.249702587723732,1.5218963623046875,0.006021497771143913,4.156517024966888e-05,0.4226466417312622,-0.05208953097462654},{432,0.7217478156089783,2.247347354888916,0.004990803077816963,5.604947727988474e-05,0.41969817876815796,-0.0019364631734788418},{504,1.3571362495422363,2.6456189155578613,0.0045023392885923386,-0.0010194418719038367,0.4177081882953644,-0.031815093010663986},{576,2.1393020153045654,3.567779064178467,0.0011737665627151728,-0.016985997557640076,0.4216320514678955,-0.016834892332553864},{648,3.104398488998413,4.154706954956055,-0.0009632004075683653,-0.003750256495550275,0.41919153928756714,-0.006981267128139734},{720,4.223421096801758,4.791232585906982,-0.002463414566591382,-0.010249713435769081,0.4190838932991028,-0.004813988693058491},{792,5.474646091461182,5.073737621307373,-0.004884950816631317,-0.0018318325746804476,0.4173826575279236,-0.01860329881310463},{864,6.834668159484863,5.754193305969238,-0.008374633267521858,-0.014021140523254871,0.4205908179283142,-0.018523141741752625},{936,8.339431762695312,6.2816386222839355,-0.008833647705614567,0.0064554354175925255,0.41860994696617126,-0.007323984056711197},{1008,9.964449882507324,6.734165191650391,-0.009451222606003284,-0.010754755698144436,0.418565958738327,-0.0018641925416886806},{1080,11.703186988830566,7.183372974395752,-0.010254506953060627,0.0017805683892220259,0.41909998655319214,-0.0006819567061029375},{1152,13.521327018737793,7.296395778656006,-0.007814671844244003,0.009905213490128517,0.41782841086387634,0.0014214831171557307},{1224,15.45418643951416,7.960181713104248,-0.004327948670834303,0.031795550137758255,0.41964635252952576,-0.010214601643383503},{1296,17.489805221557617,8.329692840576172,0.003618951654061675,0.03335344046354294,0.4185786247253418,-0.0012085472699254751},{1368,19.6156005859375,8.684693336486816,0.024604374542832375,0.12497901171445847,0.4188949167728424,-0.0005303759826347232},{1440,21.83083724975586,9.040006637573242,0.06739440560340881,0.2079208642244339,0.41929349303245544,0.0016795158153399825},{1512,24.134973526000977,9.39540958404541,0.1289706975221634,0.2875326871871948,0.4196184575557709,0.0011807818664237857},{1584,26.527606964111328,9.74611759185791,0.21219058334827423,0.3782055675983429,0.4198119342327118,-0.00023959061945788562},{1656,29.008949279785156,10.101806640625,0.3046644330024719,0.3705590069293976,0.419808030128479,0.000681626726873219},{1728,31.579011917114258,10.456274032592773,0.40010732412338257,0.39261117577552795,0.4199270009994507,0.0007522038067691028},{1800,34.113651275634766,9.7467622756958,0.4980757534503937,0.3812536895275116,0.4181535542011261,0.005237163044512272},{1872,36.44968032836914,8.952449798583984,0.5897916555404663,0.35362914204597473,0.4192582070827484,0.0017388047417625785},{1944,38.58821487426758,8.155804634094238,0.6748178005218506,0.3269091844558716,0.41980987787246704,0.0005421863752417266},{2016,40.52504348754883,7.346810817718506,0.7529215812683105,0.29848217964172363,0.42016056180000305,0.000483282667119056},{2088,42.264183044433594,6.576297283172607,0.8238797187805176,0.2705570459365845,0.42053869366645813,0.00014883327821735293},{2160,43.81254196166992,5.8187360763549805,0.888006329536438,0.23985253274440765,0.4207403063774109,-0.000645417021587491},{2232,45.17177963256836,5.064146041870117,0.9439532160758972,0.20800167322158813,0.4209011197090149,-0.00048519435222260654},{2304,46.34281539916992,4.313284873962402,0.9920425415039062,0.17648003995418549,0.4209970533847809,-0.0007139255758374929}},["pert"]={{1,-3.8937253421522655e-09,0.008242013864219189,-1.3349037430998578e-07,0.00033608521334826946,0.4195874035358429,-0.11113060265779495,5.359253805181652e-07,-2.457985146975261e-06,3.64837795530093e-08,0.9999999403953552,2.667172157089226e-05,-0.0009007113985717297,0.0006067921058274806,0.0009643621742725372,0.6998178958892822,-0.002240143483504653,0.0,2.731351287366124e-06,0.00010125549306394532,0.0009659414063207805,0.7558620572090149,0.002240143483504653,0.0,2.7283551844448084e-06,0.00012737131328321993,0.0007069687126204371,1.0096955299377441,-1.024540324578993e-06,-0.13758456707000732,9.733421393320896e-07,-3.27079942508135e-05,9.732704029374872e-07,0.00027528475038707256,0.0037406885530799627,0.8067272901535034,0.001394794206134975,0.8067272305488586,4.379878191684838e-06,0.00054579769494012,1.9321694253449095e-06,-0.00791454128921032,5.486829763867718e-07,-0.00036738350172527134,0.00038045059773139656,0.09181865304708481,1},{2,5.570840949076228e-05,0.02269824594259262,2.731168251557392e-06,-0.0005022162804380059,0.41914263367652893,-0.12746284902095795,-7.626392743986798e-07,7.616707193847105e-07,1.9695180526468903e-06,0.9999999403953552,-0.004384423606097698,0.01072579063475132,0.002872961340472102,0.005065306089818478,1.5887919664382935,-0.002240143483504653,0.0,1.8226987776870374e-06,0.030812596902251244,0.005446121096611023,1.735704779624939,0.002240143483504653,0.0,3.1730294722365215e-05,0.0578843392431736,0.007061941549181938,2.5161616802215576,-0.0009437217959202826,-0.3865882158279419,-5.291499292070512e-06,-0.006301430054008961,-3.7095114748808555e-06,-0.005881970748305321,0.00723887188360095,1.205058217048645,0.004892977420240641,1.205058217048645,-2.0252273316145875e-05,-0.027412649244070053,-5.558360498980619e-05,-0.025924203917384148,-3.5728221519093495e-06,-0.0013680969132110476,0.0007284641615115106,0.08818897604942322,1},{3,0.00015615488518960774,0.03401092067360878,4.069836904818658e-06,-8.893287304090336e-05,0.41871193051338196,-0.10347706824541092,-1.259946839127224e-05,3.511782779241912e-05,7.39599954613368e-06,0.9999998807907104,-0.010506066493690014,0.03260049968957901,0.004312408622354269,0.011883805505931377,2.214015007019043,-0.002240143483504653,0.0,0.0004216976813040674,0.23735669255256653,0.012889336794614792,2.4078972339630127,0.002240143483504653,0.0,0.0006633005104959011,0.3342698812484741,0.01805128902196884,3.649028778076172,-0.002648182213306427,-0.5627709031105042,-2.0719551685033366e-05,-0.011959206312894821,-0.00011941848060814664,-0.07213094830513,0.012113331817090511,1.6010726690292358,0.009767437353730202,1.6010726690292358,-0.00031531054992228746,-0.18920283019542694,-0.00017672523972578347,-0.04350633919239044,-1.4741078302904498e-05,-0.004126027226448059,0.00099364563357085,0.04940183833241463,1},{4,0.0002906373410951346,0.04243465140461922,8.097426871245261e-06,0.0017661586171016097,0.4184211492538452,-0.05467265471816063,-3.513887713779695e-05,0.00011314820585539564,1.4904565432516392e-05,0.9999998807907104,-0.01650054194033146,0.06063389778137207,0.00490290904417634,0.020390884950757027,2.57960844039917,-0.002240143483504653,0.0,0.001902226940728724,0.6115304827690125,0.02211177721619606,2.7712037563323975,0.002240143483504653,0.0,0.0026468487922102213,0.7774491906166077,0.03235206753015518,4.4186482429504395,-0.0048255822621285915,-0.6435820460319519,-0.00014458849909715354,-0.047244906425476074,-0.0006066845962777734,-0.26851505041122437,0.018361641094088554,1.9966089725494385,0.01601574569940567,1.996608853340149,-0.001690364326350391,-0.71045982837677,-0.0003557216259650886,-0.05921241641044617,-3.637052941485308e-05,-0.007977565750479698,0.0010786084458231926,-0.006148687098175287,1},{5,0.00045084432349540293,0.05114300921559334,2.0188406779197976e-05,0.005310989450663328,0.4183288812637329,0.00822045374661684,-6.844918971182778e-05,0.0002448158629704267,2.3154285372584127e-05,0.9999998807907104,-0.021951260045170784,0.09341767430305481,0.004274310078471899,0.029767945408821106,2.7068328857421875,-0.002240143483504653,0.0,0.004839631728827953,0.8468132615089417,0.032103363424539566,2.8443756103515625,0.002240143483504653,0.0,0.006225225515663624,0.8982702493667603,0.04870487004518509,4.819854259490967,-0.007099376991391182,-0.6106564998626709,-0.0004116035415790975,-0.15735109150409698,-0.002195601584389806,-0.7772349119186401,0.025981564074754715,2.392085075378418,0.02363566868007183,2.392085075378418,-0.005866210907697678,-2.102818250656128,-0.0005871530156582594,-0.07560250908136368,-7.268886838573962e-05,-0.012859581969678402,0.0009562851628288627,-0.06637348979711533,1},{6,0.0006417350377887487,0.058195363730192184,4.6187167754396796e-05,0.010750786401331425,0.4184749126434326,0.079514279961586,-0.00011084852303611115,0.00043645506957545877,2.9046559575363062e-05,0.9999998807907104,-0.025756673887372017,0.12847773730754852,-0.00020185609173495322,0.039173323661088943,2.597163200378418,-0.002240143483504653,0.0,0.008422911167144775,0.8890596032142639,0.041848376393318176,2.634078025817871,0.002240143483504653,0.0,0.010038685984909534,1.0405651330947876,0.06581220030784607,4.856691360473633,-0.009057425893843174,-0.46119198203086853,-0.0013734629610553384,-0.6178296804428101,-0.006183928344398737,-1.166059136390686,0.034974370151758194,2.7886030673980713,0.03262847661972046,2.7886030673980713,-0.01700412854552269,-4.013749599456787,-0.0008754412992857397,-0.08909274637699127,-0.00012635267921723425,-0.018300702795386314,0.0006220757495611906,-0.12020757049322128,1},{7,0.0008582762093283236,0.05939843878149986,9.11057140910998e-05,0.016698570922017097,0.41887757182121277,0.152921661734581,-0.00015899261052254587,0.0006902304012328386,2.502320239727851e-05,0.9999997615814209,-0.027675310149788857,0.1634284108877182,-0.005414963234215975,0.047807727009058,2.3114569187164307,-0.002240143483504653,0.0,0.011784580536186695,0.9408206939697266,0.050410378724336624,2.282050371170044,0.002240143483504653,0.0,0.013546505011618137,0.9827864170074463,0.08243585377931595,4.558170318603516,-0.010306989774107933,-0.21598190069198608,-0.004477414768189192,-0.7585054636001587,-0.011714368127286434,-1.4540581703186035,0.04534466192126274,3.1864023208618164,0.042998768389225006,3.1864025592803955,-0.036431510001420975,-4.978268146514893,-0.0012087214272469282,-0.09421824663877487,-0.00019711531058419496,-0.022939352318644524,0.00011903542326763272,-0.1507474035024643,1},{8,0.0010694253724068403,0.05714265629649162,0.00015283585526049137,0.02002321183681488,0.4195350408554077,0.22451603412628174,-0.00020848202984780073,0.0010037843603640795,1.2362260349618737e-05,0.9999995231628418,-0.02892986498773098,0.19614268839359283,-0.00852773617953062,0.05523451045155525,1.9610719680786133,-0.002240143483504653,0.0,0.014956549741327763,0.8878688216209412,0.0576980859041214,1.9118742942810059,0.002240143483504653,0.0,0.016863934695720673,0.9297119975090027,0.0974767655134201,4.043661594390869,-0.010599741712212563,-0.05498062074184418,-0.009113911539316177,-1.0531305074691772,-0.01680094376206398,-1.5443437099456787,0.05709913372993469,3.584257125854492,0.05475324019789696,3.5842573642730713,-0.058308422565460205,-5.8443169593811035,-0.0015468273777514696,-0.09395568072795868,-0.0002777008048724383,-0.024411410093307495,-0.0004527831915766001,-0.16211029887199402,1},{72,0.004463911987841129,0.005806937348097563,0.004727467894554138,0.012615594081580639,0.4634420871734619,-0.2850709557533264},{144,0.004787457175552845,-0.04496520757675171,0.007398511283099651,0.007713232655078173,0.3969547748565674,0.05140156298875809},{216,0.00463116355240345,-0.005989047233015299,0.007396653760224581,0.0012088260846212506,0.4158451557159424,0.014752842485904694},{288,0.00946767721325159,0.02987588755786419,0.00754889752715826,0.004086337983608246,0.41647496819496155,0.005661251954734325},{360,0.24519675970077515,1.5182323455810547,0.006470028776675463,-0.0019253429491072893,0.4232504367828369,-0.045001983642578125},{432,0.7169044017791748,2.240086793899536,0.004790192935615778,-0.012745660729706287,0.41973426938056946,0.0006811670027673244},{504,1.3488044738769531,2.6169681549072266,0.002514962339773774,-0.009136080741882324,0.4176006615161896,-0.02610008977353573},{576,2.1283693313598633,3.5450496673583984,-0.0013756158296018839,-0.017453676089644432,0.42158517241477966,-0.02004113420844078},{648,3.0916810035705566,4.150706768035889,-0.004718301352113485,-0.004696502350270748,0.4195372462272644,-0.002875970210880041},{720,4.20839262008667,4.783512115478516,-0.005308987572789192,-0.004206872545182705,0.4190332889556885,-0.005811574403196573},{792,5.458629608154297,5.074888706207275,-0.0054739429615437984,0.0049906843341887,0.41706621646881104,-0.02066255360841751},{864,6.8176350593566895,5.75217866897583,-0.005070238374173641,0.006016931030899286,0.42079412937164307,-0.01632600836455822},{936,8.320799827575684,6.262257099151611,-0.002396203111857176,0.020390864461660385,0.41881754994392395,-0.006201473064720631},{1008,9.944270133972168,6.733536243438721,0.00211524311453104,0.018428700044751167,0.41863125562667847,-0.0003566669183783233},{1080,11.681136131286621,7.179234981536865,0.009305142797529697,0.027409888803958893,0.41914424300193787,-0.0018672201549634337},{1152,13.499292373657227,7.2942938804626465,0.019030343741178513,0.048118144273757935,0.41775083541870117,0.001429057097993791},{1224,15.431068420410156,7.9564619064331055,0.0311032235622406,0.06327258795499802,0.41960808634757996,-0.011195069178938866},{1296,17.465707778930664,8.333538055419922,0.04771960899233818,0.06818459182977676,0.4185091555118561,-0.0018168302485719323},{1368,19.591184616088867,8.6876859664917,0.08013378828763962,0.17201535403728485,0.4189797043800354,-0.00033187848748639226},{1440,21.805938720703125,9.038537979125977,0.13117428123950958,0.2385513186454773,0.4193328022956848,-0.0006689520087093115},{1512,24.10929298400879,9.398390769958496,0.20017267763614655,0.31571510434150696,0.41946887969970703,-0.002365604043006897},{1584,26.500774383544922,9.748052597045898,0.2893756031990051,0.3969314694404602,0.4195379912853241,-0.00064987619407475},{1656,28.98069953918457,10.111639022827148,0.38714247941970825,0.39912644028663635,0.4194917678833008,-0.0028652551118284464},{1728,31.550046920776367,10.455987930297852,0.4868322014808655,0.406774640083313,0.4196831285953522,-0.0006342721753753722},{1800,34.08303451538086,9.734467506408691,0.5884102582931519,0.39308759570121765,0.4180392026901245,0.006252476945519447},{1872,36.417510986328125,8.943177223205566,0.6832955479621887,0.366134911775589,0.4191768765449524,0.0026615827810019255},{1944,38.5545768737793,8.14655876159668,0.7713426351547241,0.33831578493118286,0.4197486340999603,0.0014263049233704805},{2016,40.48994445800781,7.337656021118164,0.8521791696548462,0.30879807472229004,0.4201168715953827,0.001374868443235755},{2088,42.22773742675781,6.567629814147949,0.9255989789962769,0.2795107960700989,0.4205085337162018,0.0012999465689063072},{2160,43.774810791015625,5.810192108154297,0.991680920124054,0.24740354716777802,0.4207310974597931,0.0001615002693142742},{2232,45.13273239135742,5.05560827255249,1.0494195222854614,0.21444599330425262,0.42088639736175537,0.00036758286296389997},{2304,46.302520751953125,4.3047332763671875,1.0990267992019653,0.18205316364765167,0.4209878146648407,0.00019928031542804092}},["gen"]={{1,-3.8937253421522655e-09,0.008242015726864338,-1.3349037430998578e-07,0.00033608509693294764,0.4195873737335205,-0.11113060265779495,5.359253805181652e-07,-2.457985146975261e-06,3.64837795530093e-08,0.9999999403953552,2.667128501343541e-05,-0.0009007113985717297,0.0006067918729968369,0.0009643621742725372,0.6998181939125061,-0.002240143483504653,0.0,2.731351287366124e-06,0.00010125549306394532,0.0009659414063207805,0.7558624148368835,0.002240143483504653,0.0,2.7283551844448084e-06,0.00012737137149088085,0.0007069687126204371,1.0096957683563232,-1.024540324578993e-06,-0.1375846266746521,9.733421393320896e-07,-3.270810339017771e-05,9.732704029374872e-07,0.00027528483769856393,0.0037406885530799627,0.8067272901535034,0.001394794206134975,0.8067272305488586,4.379878191684838e-06,0.0005457975785247982,1.9321694253449095e-06,-0.007914543151855469,5.486829763867718e-07,-0.00036738355993293226,0.00038045059773139656,0.09181865304708481,1},{2,5.570840949076228e-05,0.02269824594259262,2.7311659778206376e-06,-0.0005022149416618049,0.41914260387420654,-0.12746284902095795,-7.626405817973136e-07,7.616702646373597e-07,1.969517370525864e-06,0.9999999403953552,-0.00438442500308156,0.010725789703428745,0.002872961573302746,0.005065308418124914,1.5887930393218994,-0.002240143483504653,0.0,1.8226587599201594e-06,0.030812544748187065,0.0054461234249174595,1.7357059717178345,0.002240143483504653,0.0,3.1730131013318896e-05,0.05788428336381912,0.0070619429461658,2.516162633895874,-0.0009437219123356044,-0.386588454246521,-5.291499292070512e-06,-0.006301430054008961,-3.7095103380124783e-06,-0.005881969816982746,0.00723887188360095,1.205058217048645,0.004892977420240641,1.205058217048645,-2.0252269678167067e-05,-0.027412647381424904,-5.558360498980619e-05,-0.025924202054739,-3.5728210150409723e-06,-0.0013680988922715187,0.0007284641615115106,0.08818898350000381,1},{3,0.00015615488518960774,0.03401092067360878,4.0698378143133596e-06,-8.8935557869263e-05,0.41871190071105957,-0.10347703844308853,-1.259947384824045e-05,3.511782779241912e-05,7.3959986366389785e-06,0.9999998807907104,-0.010506073012948036,0.03260050341486931,0.004312407691031694,0.011883812956511974,2.2140164375305176,-0.002240143483504653,0.0,0.0004216974484734237,0.23735669255256653,0.012889344245195389,2.4078986644744873,0.002240143483504653,0.0,0.0006632999866269529,0.33426985144615173,0.01805129460990429,3.6490302085876465,-0.002648183610290289,-0.5627711415290833,-2.0719355234177783e-05,-0.011959118768572807,-0.00011941867705900222,-0.0721309557557106,0.012113331817090511,1.6010726690292358,0.009767437353730202,1.6010726690292358,-0.00031531054992228746,-0.18920265138149261,-0.00017672523972578347,-0.04350633919239044,-1.4741083759872708e-05,-0.004126026760786772,0.00099364563357085,0.04940181225538254,1},{4,0.0002906373410951346,0.04243464767932892,8.097422323771752e-06,0.0017661568708717823,0.4184211194515228,-0.05467258766293526,-3.5138898965669796e-05,0.00011314820585539564,1.4904562704032287e-05,0.9999998807907104,-0.016500558704137802,0.06063390523195267,0.004902905784547329,0.02039089985191822,2.5796098709106445,-0.002240143483504653,0.0,0.0019022267078980803,0.611530601978302,0.022111792117357254,2.7712061405181885,0.002240143483504653,0.0,0.0026468480937182903,0.7774494290351868,0.03235207498073578,4.418649673461914,-0.004825585056096315,-0.6435819864273071,-0.00014458804798778147,-0.04724478721618652,-0.0006066853529773653,-0.2685152292251587,0.018361641094088554,1.9966089725494385,0.01601574569940567,1.996608853340149,-0.0016903650248423219,-0.7104600071907043,-0.0003557216259650886,-0.05921241641044617,-3.63705403287895e-05,-0.007977570407092571,0.0010786083294078708,-0.006148739252239466,1},{5,0.0004508442943915725,0.05114300549030304,2.0188384951325133e-05,0.00531099084764719,0.4183288514614105,0.008220567367970943,-6.844925519544631e-05,0.00024481589207425714,2.3154274458647706e-05,0.9999998807907104,-0.02195128984749317,0.0934176817536354,0.004274305887520313,0.0297679640352726,2.706834077835083,-0.002240143483504653,0.0,0.004839632660150528,0.8468134999275208,0.032103389501571655,2.844378709793091,0.002240143483504653,0.0,0.006225225981324911,0.8982712626457214,0.04870488494634628,4.8198561668396,-0.007099378854036331,-0.6106559634208679,-0.0004116015916224569,-0.15735015273094177,-0.0021956029813736677,-0.777235209941864,0.025981564074754715,2.392085075378418,0.02363566868007183,2.392084836959839,-0.005866209510713816,-2.1028170585632324,-0.0005871530156582594,-0.07560250908136368,-7.268889021361247e-05,-0.012859594076871872,0.0009562848135828972,-0.06637357920408249,1},{6,0.0006417349795810878,0.05819537118077278,4.618713865056634e-05,0.010750787332654,0.41847488284111023,0.07951444387435913,-0.0001108486540033482,0.0004364551277831197,2.9046541385469027e-05,0.9999998807907104,-0.025756726041436195,0.12847775220870972,-0.00020185753237456083,0.039173346012830734,2.5971641540527344,-0.002240143483504653,0.0,0.0084229139611125,0.8890597820281982,0.04184841364622116,2.6340808868408203,0.002240143483504653,0.0,0.010038690641522408,1.040566325187683,0.06581222265958786,4.856693267822266,-0.009057425893843174,-0.46119117736816406,-0.001373457838781178,-0.6178287863731384,-0.006183930207043886,-1.1660605669021606,0.034974370151758194,2.7886030673980713,0.03262847661972046,2.7886030673980713,-0.017004122957587242,-4.0137505531311035,-0.0008754412992857397,-0.08909276127815247,-0.0001263527519768104,-0.018300723284482956,0.0006220749928615987,-0.12020766735076904,1},{7,0.0008582761511206627,0.05939844250679016,9.11056631593965e-05,0.016698559746146202,0.4188775420188904,0.1529218554496765,-0.00015899285790510476,0.0006902304594404995,2.502317693142686e-05,0.9999997615814209,-0.027675388380885124,0.163428395986557,-0.005414965096861124,0.04780775308609009,2.311457872390747,-0.002240143483504653,0.0,0.011784585192799568,0.94082111120224,0.050410423427820206,2.2820522785186768,0.002240143483504653,0.0,0.013546514324843884,0.9827878475189209,0.08243587613105774,4.558172225952148,-0.010306987911462784,-0.21598152816295624,-0.004477408714592457,-0.7585046887397766,-0.011714373715221882,-1.4540592432022095,0.04534466192126274,3.1864023208618164,0.042998768389225006,3.1864025592803955,-0.036431506276130676,-4.978268623352051,-0.0012087214272469282,-0.09421824663877487,-0.000197115441551432,-0.022939370945096016,0.00011903436825377867,-0.15074746310710907,1},{8,0.0010694253724068403,0.05714266747236252,0.00015283578250091523,0.02002320997416973,0.4195350110530853,0.22451627254486084,-0.00020848243730142713,0.0010037843603640795,1.236223124578828e-05,0.9999995231628418,-0.028929967433214188,0.19614268839359283,-0.008527737110853195,0.05523454025387764,1.961072564125061,-0.002240143483504653,0.0,0.014956556260585785,0.8878691792488098,0.05769813805818558,1.9118763208389282,0.002240143483504653,0.0,0.016863949596881866,0.9297134876251221,0.09747679531574249,4.043663501739502,-0.010599738918244839,-0.05498022586107254,-0.009113901294767857,-1.0531290769577026,-0.016800960525870323,-1.5443470478057861,0.057099130004644394,3.5842573642730713,0.05475324019789696,3.584256887435913,-0.0583084337413311,-5.844321250915527,-0.0015468273777514696,-0.09395568817853928,-0.0002777010085992515,-0.024411441758275032,-0.00045278447214514017,-0.1621103435754776,1},{72,0.004463918041437864,0.0058069913648068905,0.004727460443973541,0.012615581043064594,0.4634421765804291,-0.2850710451602936},{144,0.0049684783443808556,-0.04120650887489319,0.007503489498049021,0.008841760456562042,0.3969449996948242,0.05088897794485092},{216,0.003955412656068802,-0.022847598418593407,0.008190077729523182,0.00789149384945631,0.41570669412612915,0.017289532348513603},{288,0.004430771805346012,0.04386710375547409,0.007827943190932274,-0.002585625508800149,0.41713467240333557,0.019306574016809464},{360,0.24384212493896484,1.528067708015442,0.0068628378212451935,0.0006735550123266876,0.4225551187992096,-0.0432899184525013},{432,0.7135976552963257,2.2330756187438965,0.005067209713160992,-0.006999739445745945,0.4198814034461975,0.0016231900081038475},{504,1.3449276685714722,2.622223138809204,0.003001545323058963,-0.006224131677299738,0.4175010025501251,-0.028286879882216454},{576,2.1242220401763916,3.564483165740967,0.0013006717199459672,0.0010072450386360288,0.42161795496940613,-0.01570379175245762},{648,3.087991237640381,4.162282466888428,0.001410675817169249,-0.004697577562183142,0.4193171560764313,-0.0038728865329176188},{720,4.20498514175415,4.7903900146484375,0.0003178860351908952,-0.007133410312235355,0.41907617449760437,-0.0032583530992269516},{792,5.455226421356201,5.0817646980285645,-0.0006721672834828496,0.003731421660631895,0.4172201156616211,-0.021729543805122375},{864,6.815301418304443,5.771903038024902,-0.0011831495212391019,0.008898512460291386,0.4207327663898468,-0.012830150313675404},{936,8.318694114685059,6.272767066955566,0.0019660675898194313,0.00453060632571578,0.4187181890010834,-0.007374364882707596},{1008,9.942708969116211,6.727769374847412,0.002272198209539056,0.005734981503337622,0.4185527563095093,-0.0017411595908924937},{1080,11.680161476135254,7.183517932891846,0.005693498998880386,0.016022274270653725,0.4191225469112396,-0.0006535917054861784},{1152,13.498187065124512,7.288483142852783,0.012067780829966068,0.027625683695077896,0.4178242087364197,0.0030073269736021757},{1224,15.42952823638916,7.957089900970459,0.01907123066484928,0.045991577208042145,0.4195888638496399,-0.010653343982994556},{1296,17.46401023864746,8.330155372619629,0.030680108815431595,0.049047309905290604,0.4185533821582794,-0.0011558148544281721},{1368,19.588882446289062,8.678356170654297,0.05753462761640549,0.1475825309753418,0.4189351797103882,8.566162432543933e-05},{1440,21.8028564453125,9.035526275634766,0.10352037101984024,0.22184883058071136,0.4193435609340668,0.0017078956589102745},{1512,24.105812072753906,9.38690185546875,0.16908782720565796,0.30492642521858215,0.4196445941925049,0.00021154724527150393},{1584,26.497249603271484,9.743528366088867,0.25637319684028625,0.3951171338558197,0.4198094606399536,0.00048546004109084606},{1656,28.977340698242188,10.096895217895508,0.3532645106315613,0.39158397912979126,0.41978171467781067,0.00041392879211343825},{1728,31.546077728271484,10.45102310180664,0.4538469910621643,0.4126448333263397,0.41991356015205383,0.0008363762754015625},{1800,34.07939147949219,9.74085807800293,0.5569804310798645,0.4008011221885681,0.4181549549102783,0.0053863790817558765},{1872,36.41411590576172,8.94732666015625,0.6532480716705322,0.3714725375175476,0.4192619025707245,0.0016968075651675463},{1944,38.5513801574707,8.150750160217285,0.7425132989883423,0.3430660367012024,0.41980987787246704,0.000534017279278487},{2016,40.48694610595703,7.341882228851318,0.8244516253471375,0.31301042437553406,0.42016032338142395,0.0004876145103480667},{2088,42.22502899169922,6.576258659362793,0.8988527655601501,0.28368619084358215,0.42054483294487,0.0005785934627056122},{2160,43.77262878417969,5.81439208984375,0.9662005305290222,0.25205159187316895,0.4207303524017334,-0.00037289716419763863},{2232,45.13093566894531,5.060032367706299,1.0248799324035645,0.21814416348934174,0.42091038823127747,-0.0002739126211963594},{2304,46.30097961425781,4.309281349182129,1.0753129720687866,0.18510526418685913,0.42100799083709717,-0.0007536078919656575}},["controls"]={{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,1.0,0.0,false,false},{0.0,0.0,1.0,0.0,false,false},{0.0,0.0,1.0,0.0,false,false},{0.0,0.0,1.0,0.0,false,false},{0.0,0.0,1.0,0.0,false,false},{0.0,0.0,1.0,0.0,false,false},{0.0,0.0,1.0,0.0,false,false},{0.0,0.0,1.0,0.0,false,false},{0.0,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,true,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,true,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,true,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,true,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,true},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false}}}
}
local M={}
local FLAT={}
for i=1,4 do FLAT[i]={0,0,1,0,0,0,0,1,1} end
local VAR_TOL=1e-3
local function relerr(a,b) return math.abs(a-b)/math.max(math.abs(a),math.abs(b),1e-3) end
local function mul32(a,b) local al,ah=a%65536,a//65536;return (al*b+((ah*b)%65536)*65536)%4294967296 end
function M.run(full)
    local results,passed,failed={},0,0
    local function check(name,ok,detail)
        if ok then passed+=1 else failed+=1 end
        local line=(ok and "PASS  " or "FAIL  ")..name..(detail and ("  "..detail) or "")
        results[#results+1]=line;print(line)
    end
    local t0=os.clock()
    local car=Vehicle.new(Core.NR2003Cup);local V=car.V
    check("load Core.NR2003Cup (Stage 10: setup, build, generic callbacks, garage)",V.applySetup~=nil and V.Setup~=nil and V.setupStructure()=="image",string.format("%.2f s",os.clock()-t0))
    local Setup=V.Setup
    -- conversions (subset of the CLI vectors, both FPU control words)
    for _,mode in ipairs({"nearest","down"}) do
        local Vv,bad=G.vec[mode],0
        for _,v in ipairs(Vv.toInternal) do if Setup.toInternal(v[1],v[2],mode)~=v[3] then bad+=1 end end
        for _,v in ipairs(Vv.toDisplay) do if Setup.toDisplay(v[1],v[2],mode)~=v[3] then bad+=1 end end
        for _,v in ipairs(Vv.step) do
            local s=Setup.cupGarageDefault();s[v[1]]=v[2]
            local ch=Setup.step(s,v[1],v[3]==1,mode)
            if (ch and 1 or 0)~=v[4] or s[v[1]]~=v[5] then bad+=1 end
        end
        check(string.format("garage conversions / steps = original [%s] (%d vectors)",mode,#Vv.toInternal+#Vv.toDisplay+#Vv.step),bad==0,bad.." mismatches")
    end
    -- image windows of the reset image
    local P,BASE=V._pristine(),V.base
    local ru=buffer.readu32
    local VLO,VHI=0xebbf60-BASE,0xebf610-BASE
    local SOLVE={}
    for _,o in ipairs(G.solve) do SOLVE[o]=true end
    -- cells: aligned dwords outside the tyre objects + tyre fields at their own (unaligned) addresses
    local TY_LO,TY_STRIDE=0xbf3a20-BASE,0xa39
    local TY_HI=TY_LO+4*TY_STRIDE
    local CELLS={}
    for _,w in ipairs(G.windows) do
        for j=0,w[2]-4,4 do
            local off=w[1]+j
            if off+4<=TY_LO or off>=TY_HI then CELLS[#CELLS+1]=off end
        end
    end
    for wh=0,3 do for k=0,TY_STRIDE-4,4 do CELLS[#CELLS+1]=TY_LO+TY_STRIDE*wh+k end end
    local function hashVar()
        local h,vars=2166136261,{}
        for _,off in ipairs(CELLS) do
            local u=ru(P,off)
            if (off>=VLO and off<VHI) or SOLVE[off] then vars[off]=u else h=mul32(bit32.bxor(h,u),16777619) end
        end
        return h,vars
    end
    local imageHash=hashVar()
    -- cells computed in double by the port (variable cells, solve pass): the changed ones are compared with the
    -- original within 1e-3 relative / 2e-5 absolute (the CLI suite compares all of them)
    local function expectVars(e)
        local worst=0
        local S=buffer.create(8)
        for _,d in ipairs(e.var) do
            local u=ru(P,d[1])
            if u~=d[2] then
                buffer.writeu32(S,0,d[2]);buffer.writeu32(S,4,u)
                local x,y=buffer.readf32(S,0),buffer.readf32(S,4)
                local e2=relerr(x,y);if math.abs(x-y)<=2e-5 then e2=0 end;if e2~=e2 then e2=math.huge end
                worst=math.max(worst,e2)
            end
        end
        return worst
    end
    -- builds: setup item changes through the ORIGINAL car build (hash outside the JIT variable cells)
    local list=full and G.items or G.itemsQuick
    local bad,report,nat,gen,tmax=0,"",0,0,0
    for _,e in ipairs(list) do
        local s=Setup.cupGarageDefault();s[e.item]=e.raw
        local t=os.clock()
        local ok,rep=V.applySetup(s)
        tmax=math.max(tmax,os.clock()-t)
        if rep.structure=="natural" then nat+=1 else gen+=1 end
        local h,vars=hashVar()
        local w=expectVars(e)
        if not (ok and rep.structure==e.structure and rep.pool==e.pool and rep.litTop==e.litTop and h==e.hash and w<=VAR_TOL) then
            bad+=1
            if report=="" then report=string.format("item %d %s: ok %s %s/%s hash %s var %.1e %s",e.item,e.tag,tostring(ok),tostring(rep.structure),e.structure,tostring(h==e.hash),w,tostring(rep.firstViolation)) end
        end
    end
    check(string.format("setup items through the ORIGINAL build = original (%d builds: %d natural, %d generic)",#list,nat,gen),bad==0,bad>0 and report or string.format("max %.2f s per applySetup",tmax))
    -- default: image restored bit for bit
    local ok,rep=V.applySetup(Setup.cupGarageDefault())
    local h=hashVar()
    check("applySetup(default) restores the shipped image (exact Stage 6-9 state)",ok and rep.structure=="image" and h==imageHash)
    -- dynamics with a non-default setup vs the ORIGINAL runtime with that setup
    local D=G.dyn
    local s=Setup.cupGarageDefault()
    for i,raw in pairs(D.items) do s[i]=raw end
    local ok2,rep2=V.applySetup(s)
    local ref=rep2.structure=="generic" and D.gen or D.orig
    local n,worst,bad2,st=0,0,0,table.create(45,0)
    local want={}
    for k,r in ipairs(D.orig) do want[r[1]]=k end
    local ticks=full and D.ticks or D.first
    for k=1,ticks do
        local c=D.controls[(k-1)//8+1]
        V.drive({throttle=c[1],brake=c[2],clutch=c[3],steer=c[4],shiftUp=c[5],shiftDown=c[6]},FLAT)
        local idx=want[k]
        if idx then
            V.state(st)
            if idx<=D.first then
                for i=1,45 do worst=math.max(worst,relerr(st[i],ref[idx][i+1])) end
            else
                local o=D.orig[idx]
                for i=1,6 do
                    local spread=0
                    for m=math.max(1,idx-1),math.min(#D.orig,idx+1) do
                        spread=math.max(spread,math.abs(D.pert[m][i+1]-D.orig[m][i+1]),math.abs(D.gen[m][i+1]-D.orig[m][i+1]))
                    end
                    local env=3*spread+0.02+0.01*math.abs(o[i+1])
                    if math.abs(st[i]-o[i+1])>env then bad2+=1 end
                end
                n+=1
            end
        end
    end
    check(string.format("%s setup (%s): first %d ticks = original (rel <= 2e-5)%s",D.name,tostring(rep2.structure),D.first,full and ", 8 s within the original envelope" or ""),
        ok2 and worst<=2e-5 and bad2==0,string.format("worst %.2e, %d samples, %d outside",worst,n,bad2))
    V.applySetup(Setup.cupGarageDefault())
    print(string.format("Stage 10 self-test: %d passed, %d failed",passed,failed))
    return failed==0,results
end
return M
]=])
print("PATCH_STAGE10 parte 4/4 guardada (5 módulos). Próximo: PATCH_STAGE10_INSTALL.lua")
