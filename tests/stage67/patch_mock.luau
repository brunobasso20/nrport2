local PATCH = [==[
-- PATCH_STAGE6_7 — NR2003 Roblox port, estágios 6 e 7 (núcleo original NR2003 Cup de 45 estados)
-- Cole o arquivo INTEIRO na Command Bar do Studio, FORA do Play, sobre a bancada Stage 5 validada.
-- Atualiza ReplicatedStorage.NR2003Lab no lugar (backup completo em ServerStorage; reverte se falhar).
-- Mantém NR2003_CORE (estágio 5) e ROBLOX_ADAPTER; o modo padrão passa a ser NR2003_CUP.
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes do patch")
local RS=game:GetService("ReplicatedStorage")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local storage=game:GetService("ServerStorage")
local pkg=assert(RS:FindFirstChild("NR2003Lab"),"NR2003Lab ausente: instale/aplique o Stage 5 antes")
local world=assert(workspace:FindFirstChild("NR2003LabWorld"),"NR2003LabWorld ausente")
local car=assert(world:FindFirstChild("TestCar"),"TestCar ausente")
assert(car:FindFirstChild("Chassis") and car:FindFirstChild("DriverSeat"),"Chassis/DriverSeat ausente")
local CoreF=assert(pkg:FindFirstChild("Core"),"NR2003Lab.Core ausente")
local RobloxF=assert(pkg:FindFirstChild("Roblox"),"NR2003Lab.Roblox ausente")
for _,n in ipairs({"NR2003FixedStep","Surface","MathUtil","TestTune"}) do assert(CoreF:FindFirstChild(n),"Core."..n.." ausente (Stage 5 requerido)") end
for _,n in ipairs({"VisualRig","RenderSnapshot","SnapshotBuffer","RenderPresentation","CoreChassisAdapter","SeatAccess","Cockpit","LegacyRobloxAdapter"}) do
    assert(RobloxF:FindFirstChild(n),"Roblox."..n.." ausente (Stage 5 requerido)")
end
local oldServer=assert(SS:FindFirstChild("NR2003Server"),"ServerScriptService.NR2003Server ausente")
local oldClient=assert(SP:FindFirstChild("NR2003Client"),"StarterPlayerScripts.NR2003Client ausente")
assert(pkg.Archivable and car.Archivable,"Habilite Archivable no pacote e no carro para o backup")
local SES=game:GetService("ScriptEditorService")
local function setSource(s,src)
    if #src<200000 then s.Source=src else SES:UpdateSourceAsync(s,function() return src end) end
end
local MODULES={}
local function module(folder,name,source) MODULES[#MODULES+1]={folder,name,source} end
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

-- install the translated JIT callbacks (NR2003CupJIT* modules)
local ctx = { M = M, LKF = LKF, LKU = LKU, NB = NB, NC = NC, JIT = JIT }
for _, install in ipairs(jitModules or {}) do install(ctx) end
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
-- Not ported (documented): replay/telemetry recording, FFB, auto-shift 005536b0 (transmission
-- mode 0), H-pattern mode (bf6f0c 1/2), ignition states driven by 005524f0/0057af40(0x19).
return function(V)
	local rf32, r32, ri32, w32, r8, w8 = V.rf32, V.r32, V.ri32, V.w32, V.r8, V.w8
	local wf32d, fd, rf64, wf64 = V.wf32d, V.fd, V.rf64, V.wf64
	local callx, tires, export, frameEnd, popF = V._callx, V._tires, V._export, V._frameEnd, V._popF
	local M, BASE = V.memory(), V.base
	local TPF, ENGINE, ROOT, INPUTS = V.TPF, V.ENGINE, V.ROOT, V.INPUTS

	-- frame start: 00551e80 tail for the player car.
	-- controls: throttle/brake pedal 0..1, clutch = engagement 0..1 (1 = pedal up; 005524f0 sets
	-- 0 with brake 1 when nobody drives), steer = road-wheel target (rad, + = left, PROVISIONAL),
	-- shiftUp/shiftDown = sequential shift keys (bf6e20/bf6e21).
	local function frameStart(c)
		local N = ri32(0xbf6e9c)
		wf32d(0xbf6390, c.throttle or 0); wf32d(0xbf6eac, c.brake or 0); wf32d(0xbf6eb0, c.clutch or 0)
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
		-- sequential shift request (bf6f0c == 0, transmission mode 0074c974 ~= 0)
		if ri32(0xbf6f0c) ~= 2 and ri32(0xbf63cc) == 0 and ri32(0x74c974) ~= 0 and ri32(0xbf6f0c) == 0 then
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
	function V.drive(controls, contacts)
		if V.tick % TPF == 0 then frameStart(controls) end
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
	return V
end
]=])
module("NR2003Cup","NR2003CupImage1",[=[
-- GENERATED by recovery/stage6_7/gen_runtime.py from NR2003.exe (original x86, Unicorn).
-- Memory image of the ORIGINAL NR2003 Cup vehicle after its own build path (part 1/2); do not edit.
return {base=7245824, size=9007104, stackTop=16248832, host=16249088, part=1, parts=2, windows={
{0,"0DMAD5AzAA+gMwAPsDMAD8AzAA/gMwAP8DMADwA0AA8QNAAPAAAAAHAnAA8AAAAAYCcADwAAAACgMgAPwDIAD9AyAA/gMgAP8DIADwAzAA8QMwAPIDMADzAzAA9AMwAPUDMAD2AzAA9wMwAPgDMAD7AyAA8AAAAAEDkADwA5AA/wOAAP4DgAD9A4AA/AOAAPsDgAD6A4AA+QOAAPgDgAD3A4AA9gOAAPUDgAD0A4AA8wOAAPIDgADxA4AA8AOAAP8DcAD+A3AA/QNwAPwDcAD7A3AA+gNwAPkDcAD4A3AA9wNwAPYDcAD1A3AA9ANwAPIDkADyA3AA8QNwAPADcAD/A2AA/gNgAP0DYAD8A2AA+wNgAPoDYAD5A2AA8gOgAPcDYAD2A2AA9QNgAPQDYADwA6AA8gNgAPEDYAD9AsAA/ALAAPMDoAD0A6AA9QOgAPYDoAD3A6AA+AOgAPkDoAD6A6AA+wOgAPwDoADwA2AA/wNQAPMDkAD0A5AA9QOQAPYDkAD3A5AA+AOQAPkDkAD6A5AA+wOQAPwDkAD9A5AA/gOQAPMDcAD/A5AA+wLAAPoCwAD5AsAA+ALAAPcCwAD2AsAA9QLAAPQCwADzAsAA8gLAAPECwADwAsAA/wKwAP4CsAD9ArAA/AKwAPsCsAD6ArAA+QKwAPgCsAD3ArAA9gKwAPkCcAD1ArAA9AKwAPMCsADyArAA8QKwAPACsAD/AqAA/gKgAP0CoADzA2AA8QOgAPgDYAD9A6AA/AKgAPsCoAD6AqAA+QKgAPgCoAD3AqAA9gKgAPACgADxAoAA8gKAAPMCgAD0AoAA9QKAAPYCgAD3AoAA/wHwAPgCgAD5AoAA+gKAAPsCgAD8AoAA/QKAAP4CgAD/AoAA8AKQAPECkADyApAA8wKQAPQCkAD1ApAA9gKQAPcCkAD4ApAA+QKQAPoCkAD7ApAA/AKQAP0CkAD+ApAA/wKQAPACoADxAqAA8gKgAPMCoAD0AqAA9QKgAPAAAAAEA0AA8AAAAA8C0ADwAuAA8QLgAPIC4ADzAuAA9ALgAPUC4AD2AuAA9wLgAPgC4AD5AuAA+gLgAPsC4AD8AuAA/QLgAP4C4AD/AuAA8ALwAP4C0ADyAvAA8wLwAPQC8AD1AvAA9gLwAPcC8AD4AvAA+QLwAPoC8AD8AvAA/QLwAP4C8AD/AvAA8AMAAPEDAADyAwAA8wMAAPEC8AD9AtAA+wLwAP4CwAD/AsAA8ALQAPEC0ADyAtAA8wLQAPQC0AD1AtAA9gLQAPcC0AD4AtAA+QLQAPoC0AD7AtAA/ALQAPAAAAAGAwAA9QMAAPQDAAD3AwAA+AMAAPkDAAD6AwAA+wMAAPwDAADwAAAADgMAAP0DAAD4AnAA/wMAAPADEADxAxAA8gMQAPMDEAD0AxAA9QMQAPYDEAD3AxAA+QMgAPgDIAD3AyAA9gMgAPUDIAD0AyAA8wMgAPIDIAD4AxAA8AMgAP8DEAD+AxAA/QMQAPwDEAD7AxAA+gMQAPkDEADxAyAA8AAAAAcB8AD+AeAA/wHgAPAB8AD9AfAA/AHwAPsB8AD6AfAA+QHwAPgB8AD9AeAA9gHwAPUB8AD0AfAA8wHwAPIB8ADxAfAA8AAAAA4B8ADzA0AA8gNAAPAAAAAJAlAA+gJQAPsCUAD8AlAA/QJQAP4CUAD/AlAA8AJgAPECYADyAmAA8wJgAPQCYAD1AmAA9gJgAPcCYAD4AmAA+QJgAPoCYAD4AlAA9wJQAPYCUAD1AlAA9AJQAPMCUADyAlAA8QJQAPACUAD/AkAA/gJAAP0CQAD8AkAA+wJAAPoCQAD5AkAA+AJAAPcCQAD2AkAA9QJAAPQCQADzAkAA8gJAAPECQADwAkAA/wIwAPsCYAD8AmAA/QJgAPhkkxAOAjAA/QIwAPUDQAD2A0AA9wNAAPgDQAD5A0AA+gNAAPsDQAD8A0AA/QNAAP4DQAD/A0AA8ANQAPEDUADyA1AA8wNQAPQDUAD1A1AA9gNQAPcDUAD4A1AA+QNQAPoDUAD7A1AA/ANQAP0DUAD+A1AA+yWzEAwCMAD7AjAA+gIwAPkCMAD4AjAA9wIwAPYCMAD1AjAA9AIwAPMCMADyAjAA8QIwAPACMAD/AiAA/gIgAP0CIAD8AiAA+wIgAPoCIAD5AiAA+AIgAPcCIAD2AiAA9QIgAPQCIADzAiAA8gIgAPECIADwAiAA/wIQAP4CEAD9AhAA/AIQAPsCEAD6AhAA+QIQAPgCEAD3AhAA9gIQAPUCEAD0AhAA8wIQAPICEADxAhAA8AIQAP8CAAD+AgAA/QIAAPwCAAD7AgAA+gIAAPkCAAD4AgAA9wIAAPYCAAD1AgAA9AIAAPMCAADyAgAA8QIAAPACAAD5JJMQDgJgAPwEkxAPAmAA8AJwAPECcADyAnAA8wJwAPQCcAD1AnAA8AAAAAsCcAD8AnAA/QJwAP4CcAD/AnAA+gJwAPAAAAAAAAAAAAAAAAAAAAAOaZVz8AAAAAAgAAAEMAAAAAAAAAADA6AAAAlkPbD0lAhetRQAAAQD/sUchAxm20PgAAL0MAALRCAABAQAAAgkIAAJxChetRPwAAAABY6HEAVOhxACASQADG/FwAwPxcAMBKbADASmwAwEpsAMBKbADASmwAwEpsAHARQACAEUAA4P//SAAAgD8AgP9DAAClRcBKbADASmwAYB1AADX6jjwAAAAAXxxEVPshCUDm6R1BAACAQAAAAAAAAPA/7UpLPKfK97unyvc7MzMzP83MzL3NzEw++oK+PAAAAAAAAAAAAAAAQAAAAAAAAAhAAACWQ9sPSUCF61FAAABAP+xRyEDGbbQ+AAAvQwAAtEIAAEBAAACCQgAAnEKF61E/IDdAAKA3QADgN0AAkI9AAKCPQACAzlEAcM9RAKDPUQCA0FEA0NBRAPDQUQAw0VEAsI9AAFCPQACQ0VEAoNFRAHCPQACAj0AAADhAAHA4QACwOEAAwI9AANCPQACAzlEAcM9RAKDPUQCA0FEA0NBRAPDQUQAw0VEA4I9AAFCPQACQ0VEAoNFRAHCPQACAj0AA0EBAAMBBQADgQUAA8I9AAHDOUQCAzlEAcM9RAKDPUQCA0FEA0NBRAPDQUQAw0VEAAJBAAFCPQACQ0VEAoNFRAHCPQACAj0AAgENAADBEQABQREAA8I9AAHDOUQCAzlEAcM9RAKDPUQCA0FEA0NBRAPDQUQAw0VEAEJBAAFCPQACQ0VEAoNFRAHCPQACAj0AAoERAAMBGQAAQR0AA8I9AAHDOUQCAzlEAcM9RAKDPUQCA0FEA0NBRAPDQUQAw0VEAIJBAAFCPQACQ0VEAoNFRAHCPQACAj0AAcEdAANBJQABwSkAA8I9AAHDOUQCAzlEAcM9RAKDPUQCA0FEA0NBRAPDQUQAw0VEAMJBAAFCPQACQ0VEAoNFRAHCPQACAj0AA4EtAAJBNQACwTUAA8I9AAHDOUQCAzlEAcM9RAOA5QACA0FEA0NBRAPDQUQAw0VEAQJBAAFCPQADQOkAAwDpAAFCQQACAj0AAQFBAAIBRQACgUUAA8I9AAHDOUQCAzlEAcM9RAOA5QACA0FEA0NBRAPDQUQAw0VEAQJBAAFCPQADQOkAAwDpAAFCQQACAj0AAkFNAAJBUQACwVEAA8I9AAHDOUQCAzlEAcM9RAOA5QACA0FEA0NBRAPDQUQAw0VEAQJBAAFCPQADQOkAAwDpAAFCQQACAj0AAEFVAAKBWQADAVkAA8I9AAHDOUQCAzlEAcM9RAOA5QACA0FEAEDxAAPDQUQAw0VEAQJBAAFCPQABQPEAAwDpAAGCQQABwkEAAUFdAAOBYQAAAWUAA8I9AAHDOUQCAzlEAcM9RAOA5QACA0FEAEDxAAPDQUQAw0VEAQJBAAFCPQABwPkAAwDpAAGCQQABwkEAAYFlAADBaQABQWkAA8I9AAHDOUQCAzlEAcM9RAOA5QACA0FEAEDxAAPDQUQAw0VEAQJBAAFCPQABQPEAAwDpAAGCQQABwkEAAsFpAAGBbQADAW0AA8I9AAHDOUQCAzlEAcM9RAKDPUQCA0FEA0NBRAPDQUQAw0VEAQJBAAFCPQACQ0VEAoNFRAICQQACAj0AAkF1AAFBeQABwXkAA8I9AAHDOUQCAzlEAcM9RANA4QACA0FEA0NBRAJCQQACgkEAAQJBAAFCPQAAgOUAA0DlAAHCPQACAj0AAIF9AANBfQADgX0AA8I9AAHDOUQCAzlEAcM9RAKDPUQCA0FEA0NBRAPDQUQAw0VEAQJBAAFCPQACQ0VEAoNFRAHCPQACAj0AA8F9AAJBgQACgYEAA8I9AAHDOUQCAzlEAcM9RAKDPUQCA0FEA0NBRAPDQUQAw0VEAQJBAAFCPQACQ0VEAoNFRAHCPQACAj0AAwGBAAGBhQABwYUAA8I9AAHDOUQCAzlEAcM9RAKDPUQCA0FEA0NBRAPDQUQAw0VEAQJBAAFCPQACQ0VEAoNFRAHCPQACAj0AAkGFAACBiQAAwYkAA8I9AAHDOUQCAzlEAcM9RAKDPUQCA0FEA0NBRAPDQUQAw0VEAsJBAAFCPQACQ0VEAoNFRAHCPQACAj0AAQGJAAPBiQAAAY0AA8I9AAHDOUQCAzlEAcM9RAKDPUQCA0FEA0NBRAPDQUQAw0VEAwJBAAFCPQACQ0VEAoNFRAHCPQACAj0AAsGNAAGBkQABwZEAAoNNRAFDVUQCAzlEAcM9RAKDPUQCA0FEA0NBRANCQQADgkEAA8JBAAFCPQACQ0VEAoNFRAHCPQACAj0AAkGRAAFBlQABgZUAA8I9AAHDOUQCAzlEAcM9RAKDPUQCA0FEA0NBRAACRQAAw0VEAQJBAAFCPQACQ0VEAoNFRABCRQACAj0AAMGZAAGBmQABwZkAA8I9AAHDOUQCAzlEAcM9RAKDPUQCA0FEA0NBRACCRQAAw0VEAQJBAAFCPQACQ0VEAoNFRADCRQACAj0AAsGZAANBmQADgZkAA8I9AAHDOUQCAzlEAcM9RAKDPUQCA0FEA0NBRAPDQUQAw0VEAQJBAAFCPQACQ0VEAoNFRAHCPQACAj0AA8GZAABBnQAAgZ0AA8I9AAHDOUQCAzlEAcM9RAKDPUQCA0FEA0NBRAPDQUQAw0VEAQJBAAFCPQACQ0VEAoNFRAHCPQACAj0AAcGdAAPBnQAAAaEAA8I9AAHDOUQCAzlEAMGdAAEBnQABQZ0AAYGdAAFCRQABAkUAAYJFAAFCPQACQ0VEAoNFRAHCPQACAj0AAIGhAANBpQADgaUAA8I9AAHDOUQCAzlEAMGdAAEBnQABQZ0AAYGdAAHCRQABAkUAAgJFAAFCPQACQ0VEAoNFRAHCPQACAj0AAQGxAAHBtQACwbUAA8I9AAHDOUQCAzlEAMGdAAEBnQABQZ0AAYGdAAJCRQABAkUAAQJBAAFCPQACQ0VEAoNFRAHCPQACAj0AA0G9AAOBwQADwcEAA8I9AAHDOUQCAzlEAMGdAAEBnQABQZ0AAYGdAAJCRQABAkUAAQJBAAFCPQACQ0VEAoNFRAHCPQACAj0AAEHJAAOByQAAAc0AA8I9AAHDOUQCAzlEAMGdAAEBnQABQZ0AAYGdAAJCRQABAkUAAQJBAAFCPQACQ0VEAoNFRAHCPQACAj0AAMHRAAOB0QADwdEAA8I9AAHDOUQCAzlEAMGdAAEBnQABQZ0AAYGdAAJCRQABAkUAAQJBAAFCPQACQ0VEAoNFRAHCPQACAj0AAEHVAAGB1QABwdUAA8I9AAHDOUQCAzlEAMGdAAEBnQABQZ0AAYGdAAKCRQABAkUAAsJFAAFCPQACQ0VEAoNFRAHCPQACAj0AAsHVAAOB2QAAAd0AA8I9AAHDOUQCAzlEAMGdAAEBnQABQZ0AAYGdAAMCRQABAkUAAQJBAAFCPQACQ0VEAoNFRAHCPQACAj0AA0HdAAFB4QABgeEAA8I9AAHDOUQCAzlEAcM9RAKDPUQCA0FEA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AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUAAAACAAAAAAAAAAAAAAAAAAAHAAAA6AMAAAAAAAAAAAAAAAAAGwAAAAAAAAAMAAAAGSUWAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAcAAAAAAAAAAsAACMSIxEAAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAeAAAAAAAAAAAAAAAAAAAAAAAAUAAAAAEAAAAA/wAAAAAAAAAAAFAAAAAAAAAAAAoAAAAAAAAAAAAfAAAAAAAAAAEAAAAAAAAAAAAAIAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACEAAAAAAAAAAwUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIgAAAAAAAAAEBQAAAAAAAAAAACMAAAAAAAAABgAAAAAAAAAAAABQAAAAAAAAAAD/AAAAAAAAAAAAUAAAAAEAAAAACgAAAAAAAAAAACQAAAAAAAAABwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjAAAAAAAAAAYAAAAAAAAAAAAAJAAAAAAAAAAHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAAAAAQAAAAH/AAAAAAAAAAAAJQAAAAAAAAAIAAAAAAAAAAAAACYAAAAAAAAACQAAAAAAAAAAAAAoAAAAAAAAAAoAAAAAAAAAAAAAAQAAAAoAAAAAAAAAAAAAAAAAACkAAAAAAAAACwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUAAAAAEAAAAB/wAAAAAAAAAAACUAAAAAAAAAAAAAAAAAAAAAAAAnAAAAAAAAAAEAAAAAAAAAAAAAKAAAAAAAAAACAAAAAAAAAAAAAAEAAAALAAAAAAAAAAAAAAAAAAApAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAAAABAAAAAv8AAAAAAAAAAAAqAAAAAAAAAAQAAAAAAAAAAAAAAQAAAAwAAAAAAAAAAAAAAAAAAAUAAAANAAAAAAAAAAAAAAAAAAApAAAAAAAAAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUAAAABAAAAAAAAAAAAAAAAAAABAAAABQAAAAAAAAAAAAAAAAAAKwAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADwAAAAAAAAACAAAAAAAAAAAAAAEAAAAOAAAAAAAAAAAAAAAAAAARAAAAAAAAAAMAAAAAAAAAAAAAAQAAAA8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABwAAAOgDAAAAAAAAAAAAAAAAACwAAAAAAAAABAAAAAAAAAAAAAAFAAAADAAAAAAAAAAAAAAAAAAAUAAAAAEAAAAC/wAAAAAAAAAAAFAAAAAAAAAAAggAAAAAAAAAAAABAAAADQAAAAAAAAAAAAAAAAAALQAAAAAAAAAFAAAAAAAAAAAAAAUAAAAQAAAAAAAAAAAAAAAAAAAuAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAAABEAAAAAAAAAAAAAAAAAAAUAAAASAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA8AAAAAAAAABwAAAAAAAAAAAAARAAAAAAAAAAgAAAAAAAAAAAAAAQAAABMAAAAAAAAAAAAAAAAAAAQAAAAVAAAAAAAAAAAAAAAAAAABAAAAFAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAAAAQAAAAAAAAAAAAAAAAAALwAAAAAAAAABAAAAAAAAAAAAADAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUAAAAOAAAAAAAAAAAAAAAAAAAxAAAAAAAAAAMAAAAAAAAAAAAABQAAAA8AAAAAAAAAAAAAAAAAAFAAAAABAAAAAv8AAAAAAAAAAABQAAAAAAAAAAIBAAAAAAAAAAAAEQAAAAAAAAAEAAAAAAAAAAAAABAAAAAAAAAABQAAAAAAAAAAAAABAAAAEAAAAAAAAAAAAAAAAAAAMgAAAAAAAAAGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUAAAATAAAAAAAAAAAAAAAAAAACAAAABQAAAAAAAAAAAAAAAAAAMwAAAAAAAAAHAAAAAAAAAAAAAAUAAAAUAAAAAAAAAAAAAAAAAAA1AAAAAAAAAAgAAAAAAAAAAAAANAAAAAAAAAAJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA2AAAAAAAAAAoAAAAAAAAAAAAAUQAAAAAAAAAAAAAAAAAAAAAAAAUAAAACAAAAAAAAAAAAAAAAAAAZAAAAAAAAAAAMCwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAAAAQAAAAAAAAAAAAAAAAAACAAAAAAAAAACAAAAAAAAAAAAAAkAAAAAAAAAAwAAAAAAAAAAAAABAAAAFQAAAAAAAAAAAAAAAAAABQAAABkAAAAAAAAAAAAAAAAAAAUAAAAcAAAAAAAAAAAAAAAAAAAKAAAAAAAAAAQAAAAAAAAAAAAAAwAAABUAAAAAAAAAAAAAAAAAAAEAAAAWAAAAAAAAAAAAAAAAAAA3AAAAAAAAAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAAAAQAAAAAAAAAAAAAAAAAACAAAAAAAAAACAAAAAAAAAAAAAAkAAAAAAAAAAwAAAAAAAAAAAAABAAAAFQAAAAAAAAAAAAAAAAAABQAAABkAAAAAAAAAAAAAAAAAAAUAAAAcAAAAAAAAAAAAAAAAAAAFAAAAHQAAAAAAAAAAAAAAAAAACgAAAAAAAAAEAAAAAAAAAAAAAAMAAAAVAAAAAAAAAAAAAAAAAAABAAAAFgAAAAAAAAAAAAAAAAAANwAAAAAAAAAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAAAAEAAAAAAAAAAAAAAAAAAAgAAAAAAAAABwAAAAAAAAAAAAAJAAAAAAAAAAgAAAAAAAAAAAAAAQAAABUAAAAAAAAAAAAAAAAAAAUAAAAhAAAAAAAAAAAAAAAAAAAFAAAAJAAAAAAAAAAAAAAAAAAACgAAAAAAAAAJAAAAAAAAAAAAAAMAAAAVAAAAAAAAAAAAAAAAAAABAAAAHgAAAAAAAAAAAAAAAAAANwAAAAAAAAAKAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAAAAEAAAAAAAAAAAAAAAAAADgAAAAAAAAAAgAAAAAAAAAAAAALAAAAAAAAAAMAAAAAAAAAAAAACwAAAAAAAAAEAAAAAAAAAAAAAAsAAAAAAAAABQAAAAAAAAAAAAALAAAAAAAAAAYAAAAAAAAAAAAACwAAAAAAAAAHAAAAAAAAAAAAAAwAAAAAAAAACAAAAAAAAAAAAAAFAAAAFQAAAAAAAAAAAAAAAAAAOQAAAAAAAAAJAAAAAAAAAAAAAFAAAAABAAAAAf8AAAAAAAAAAAABAAAAFwAAAAAAAAAAAAAAAAAAOgAAAAAAAAAKAAAAAAAAAAAAAA0AAAAAAAAACwAAAAAAAAAAAAAFAAAAGAAAAAAAAAAAAAAAAAAADgAAAAAAAAAMAAAAAAAAAAAAAA4AAAAAAAAADQAAAAAAAAAAAAAOAAAAAAAAAA4AAAAAAAAAAAAADgAAAAAAAAAPAAAAAAAAAAAAAA4AAAAAAAAAEAAAAAAAAAAAAAABAAAAGQAAAAAAAAAAAAAAAAAAOwAAAAAAAAARAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA8AAAAAAAAACUlJSUlJSUlJSUAAQAAAB0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAAAAEAAAAAAAAAAAAAAAAAADgAAAAAAAAAEwAAAAAAAAAAAAALAAAAAAAAABQAAAAAAAAAAAAACwAAAAAAAAAVAAAAAAAAAAAAAAsAAAAAAAAAFgAAAAAAAAAAAAALAAAAAAAAABcAAAAAAAAAAAAACwAAAAAAAAAYAAAAAAAAAAAAAAwAAAAAAAAAGQAAAAAAAAAAAAAFAAAAFQAAAAAAAAAAAAAAAAAAOQAAAAAAAAAaAAAAAAAAAAAAAFAAAAABAAAAAf8AAAAAAAAAAAABAAAAHwAAAAAAAAAAAAAAAAAAOgAAAAAAAAAbAAAAAAAAAAAAAA0AAAAAAAAAHAAAAAAAAAAAAAAFAAAAIAAAAAAAAAAAAAAAAAAADgAAAAAAAAAdAAAAAAAAAAAAAA4AAAAAAAAAHgAAAAAAAAAAAAAOAAAAAAAAAB8AAAAAAAAAAAAADgAAAAAAAAAgAAAAAAAAAAAAAA4AAAAAAAAAIQAAAAAAAAAAAAABAAAAIQAAAAAAAAAAAAAAAAAAOwAAAAAAAAAiAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAAAAQAAAAAAAAAAAAAAAAAAOAAAAAAAAAACAAAAAAAAAAAAAAsAAAAAAAAAAwAAAAAAAAAAAAALAAAAAAAAAAQAAAAAAAAAAAAACwAAAAAAAAAFAAAAAAAAAAAAAAsAAAAAAAAABgAAAAAAAAAAAAALAAAAAAAAAAcAAAAAAAAAAAAADAAAAAAAAAAIAAAAAAAAAAAAAAUAAAAVAAAAAAAAAAAAAAAAAAA5AAAAAAAAAAkAAAAAAAAAAAAAUAAAAAEAAAAB/wAAAAAAAAAAAAEAAAAaAAAAAAAAAAAAAAAAAAA6AAAAAAAAAAoAAAAAAAAAAAAADQAAAAAAAAALAAAAAAAAAAAAAAUAAAAbAAAAAAAAAAAAAAAAAAAOAAAAAAAAAAwAAAAAAAAAAAAADgAAAAAAAAANAAAAAAAAAAAAAA4AAAAAAAAADgAAAAAAAAAAAAAOAAAAAAAAAA8AAAAAAAAAAAAADgAAAAAAAAAQAAAAAAAAAAAAAAEAAAAcAAAAAAAAAAAAAAAAAAA7AAAAAAAAABEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABoAAAAAAAAAAAAAAAASAAAAAAABAAAAEQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAAAAQAAAAAAAAAAAAAAAAAAOAAAAAAAAAATAAAAAAAAAAAAAAsAAAAAAAAAFAAAAAAAAAAAAAALAAAAAAAAABUAAAAAAAAAAAAACwAAAAAAAAAWAAAAAAAAAAAAAAsAAAAAAAAAFwAAAAAAAAAAAAALAAAAAAAAABgAAAAAAAAAAAAADAAAAAAAAAAZAAAAAAAAAAAAAAUAAAAVAAAAAAAAAAAAAAAAAAA5AAAAAAAAABoAAAAAAAAAAAAAUAAAAAEAAAAB/wAAAAAAAAAAAAEAAAAiAAAAAAAAAAAAAAAAAAA6AAAAAAAAABsAAAAAAAAAAAAADQAAAAAAAAAcAAAAAAAAAAAAAAUAAAAjAAAAAAAAAAAAAAAAAAAOAAAAAAAAAB0AAAAAAAAAAAAADgAAAAAAAAAeAAAAAAAAAAAAAA4AAAAAAAAAHwAAAAAAAAAAAAAOAAAAAAAAACAAAAAAAAAAAAAADgAAAAAAAAAhAAAAAAAAAAAAAAEAAAAkAAAAAAAAAAAAAAAAAAA7AAAAAAAAACIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD0AAAAAAAAAAgAAAAAAAAAAAAAFAAAAFwAAAAAAAAAAAAAAAAAAPgAAAAAAAAADAAAAAAAAAAAAAFAAAAAAAAAAAf8AAAAAAAAAAAABAAAAGAAAAAAAAAAAAAAAAAAAPwAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA7AAAAAAAAAAUAAAAAAAAAAAAAQAAAAAAAAAAGAAAAAAAAAAAAAFAAAAABAAAAAf8AAAAAAAAAAABQAAAAAAAAAAEDAAAAAAAAAAAAQQAAAAAAAAAHAAAAAAAAAAAAAAUAAAAKAAAAAAAAAAAAAAAAAABQAAAAAAAAAAH/AAAAAAAAAAAAQgAAAAAAAAAIAAAAAAAAAAAAAFAAAAABAAAAAf8AAAAAAAAAAABQAAAAAAAAAAEHAAAAAAAAAAAARAAAAAAAAAAJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARQAAAAAAAAAUAAAAAAAAAAAAADsAAAAAAAAAFQAAAAAAAAAAAABQAAAAAQAAAAH/AAAAAAAAAAAAUAAAAAAAAAABAwAAAAAAAAAAAAUAAAAdAAAAAAAAAAAAAAAAAAAzAAAAAAAAABYAAAAAAAAAAAAABQAAABYAAAAAAAAAAAAAAAAAAAIAAAAFAAAAAAAAAAAAAAAAAAA0AAAAAAAAABcAAAAAAAAAAAAAUQAAAAAAAAAAAAAAAAAAAAAAAAUAAAACAAAAAAAAAAAAAAAAAABGAAAAAAAAABgAAAAAAAAAAAAAGwAAAAAAAAAAAAAAGQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA9AAAAAAAAAAoAAAAAAAAAAAAABQAAAB8AAAAAAAAAAAAAAAAAAD4AAAAAAAAACwAAAAAAAAAAAABQAAAAAAAAAAH/AAAAAAAAAAAAAQAAACAAAAAAAAAAAAAAAAAAAD8AAAAAAAAADAAAAAAAAAAAAABFAAAAAAAAAA0AAAAAAAAAAAAAOwAAAAAAAAAOAAAAAAAAAAAAAFAAAAABAAAAAf8AAAAAAAAAAABQAAAAAAAAAAEDAAAAAAAAAAAABQAAACEAAAAAAAAAAAAAAAAAADMAAAAAAAAADwAAAAAAAAAAAAAFAAAAHgAAAAAAAAAAAAAAAAAAAgAAAAUAAAAAAAAAAAAAAAAAADQAAAAAAAAAEAAAAAAAAAAAAABRAAAAAAAAAAAAAAAAAAAAAAAABQAAAAIAAAAAAAAAAAAAAAAAAEYAAAAAAAAAEQAAAAAAAAAAAAAcAAAAAAAAAAAAAAASAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA9AAAAAAAAAAIAAAAAAAAAAAAABQAAABoAAAAAAAAAAAAAAAAAAD4AAAAAAAAAAwAAAAAAAAAAAABQAAAAAAAAAAH/AAAAAAAAAAAAAQAAABsAAAAAAAAAAAAAAAAAAD8AAAAAAAAABAAAAAAAAAAAAAA7AAAAAAAAAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAABgAAAAAAAAAAAABQAAAAAQAAAAH/AAAAAAAAAAAAUAAAAAAAAAABBQAAAAAAAAAAAEEAAAAAAAAABwAAAAAAAAAAAAABAAAAEgAAAAAAAAAAAAAAAAAABQAAAAsAAAAAAAAAAAAAAAAAAFAAAAAAAAAAAf8AAAAAAAAAAABDAAAAAAAAAAgAAAAAAAAAAAAAUAAAAAEAAAAB/wAAAAAAAAAAAFAAAAAAAAAAAQgAAAAAAAAAAABEAAAAAAAAAAkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAAAHAAAAAAAAAAAAAAAAAAAMwAAAAAAAAATAAAAAAAAAAAAAAUAAAAWAAAAAAAAAAAAAAAAAAACAAAABQAAAAAAAAAAAAAAAAAANAAAAAAAAAAUAAAAAAAAAAAAAFEAAAAAAAAAAAAAAAAAAAAAAAAFAAAAAgAAAAAAAAAAAAAAAAAARgAAAAAAAAAVAAAAAAAAAAAAAFAAAAABAAAAAf8AAAAAAAAAAABQAAAAAAAAAAEFAAAAAAAAAAAAGwAAAAAAAAAAAAAAAAAWAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPQAAAAAAAAAKAAAAAAAAAAAAAAUAAAAiAAAAAAAAAAAAAAAAAAA+AAAAAAAAAAsAAAAAAAAAAAAAUAAAAAAAAAAB/wAAAAAAAAAAAAEAAAAjAAAAAAAAAAAAAAAAAAA/AAAAAAAAAAwAAAAAAAAAAAAAOwAAAAAAAAANAAAAAAAAAAAAAFAAAAABAAAAAf8AAAAAAAAAAABQAAAAAAAAAAEFAAAAAAAAAAAABQAAACQAAAAAAAAAAAAAAAAAADMAAAAAAAAADgAAAAAAAAAAAAAFAAAAHgAAAAAAAAAAAAAAAAAAAgAAAAUAAAAAAAAAAAAAAAAAADQAAAAAAAAADwAAAAAAAAAAAABRAAAAAAAAAAAAAAAAAAAAAAAABQAAAAIAAAAAAAAAAAAAAAAAAEYAAAAAAAAAEAAAAAAAAAAAAAAcAAAAAAAAAAAAAAAAABEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABHAAAAAAAAAAEAAAAAAAAAAAAATgAAABYAAAACAAAAAAAAAAAAAEgAAAAAAAAAAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAATgAAAB4AAAAEAAAAAAAAAAAAAAQAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAATgAAABMAAAAEAAAAAAAAAAAAAAQAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASQAAAAAAAAAGAAAAAAAAAAAAAE4AAAAWAAAABwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASgAAAAAAAAAJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFIAAAABAAAAAAAAAAAAAAAAAABLAAAAAAAAAAoAAAAAAAAAAAAATgAAAAMAAAAOAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARwAAAAAAAAABAAAAAAAAAAAAAE4AAAAWAAAAAgAAAAAAAAAAAAAEAAAABAAAAAAAAAAAAAAAAAAAUgAAAAEAAAAAAAAAAAAAAAAAAE0AAAAAAAAADAAAAAAAAAAAAABOAAAAAwAAAA4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEwAAAAAAAAACwAAAAAAAAAAAAAcAAAAAAAAAAAAAAAAAAAAAAUAUgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABTAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAAAAUAAAAAAAAAAAAAAAAAAAQAAAAF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AMJBAPDCQQDwx0EAkMNBAODFQQBAxkEAcMZBAPDGQQBgx0EAkMdBANDHQQAAAHBBwC9CAMb8XADA/FwAUBJAAEAgQABQIEAAcCBAAKAgQADQIEAAcBFAAIARQADwH0AAMCBAAAAAAAAAAAAAAAAoQDMzMzMzM8M/AABAPwAAAACamZmZmZnZP0w3iUFg5QFArkeBPwBAHMbwL0IAxvxcAMD8XADQKUAAECpAACAqQABAKkAAcCpAAKAqQABwEUAAgBFAAIApQADAKUAAAAAAADMzMzMzM9M/z/dT46Wb7D/EziBBAAAAAOF6FK5H4SFAAAAAwAAAAAAAAAAAAEB/wAAAAKCZmbk/IDBCAMb8XADA/FwAsC5CAFAvQgBwL0IAkC9CAKAvQgCwL0IAcBFAAIARQAAwLkIAkC5CAAAAAACF61FA4XodQqkT0DxCPug+AABAP7geDUDsUchAxm20PgRWjkA5+o484S5lQgAAL0MAAJZD2w9JQAAAtEIAAEBAAACCQgAAnEKF61E/zcxMPVUAAAAeAAAAVQAAAFUAAAD///////////////////////////////////////////////////////////////9CAAAARAAAAEYAAADg124AAgAAAAAAAAAAAAAAAAAAAAgAAAAPAAAAFgAAABYAAAAWAAAAZAAAAAkAAAAAAAAAIgAAADsAAABEAAAARAAAAEQAAABEAAAAlAAAAAAAAAANAAAALgAAAA4AAAAuAAAADgAAAC0AAAAMAAAAIwAAAA0AAAAjAAAAEAAAACoAAAAPAAAAJgAAAA4AAAAiAAAAEQAAACkAAAAOAAAAIQAAAA4AAAAgAAAADwAAACEAAAAPAAAAIAAAAA8AAAAfAAAAEAAAACAAAAAQAAAAHwAAABQAAAAmAAAAEAAAAB4AAAARAAAAHwAAABEAAAAeAAAAEQAAAB0AAAAUAAAAIgAAABIAAAAeAAAAEgAAAB0AAAASAAAAHAAAABMAAAAdAAAAFQAAACAAAAATAAAAHAAAABIAAAAaAAAAEwAAABsAAAAYAAAAIgAAABQAAAAcAAAAFQAAAB0AAAAYAAAAIQAAABkAAAAiAAAAFAAAABsAAAAYAAAAIAAAABkAAAAhAAAAEwAAABkAAAAXAAAAHgAAABUAAAAbAAAAGQAAACAAAAAaAAAA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4MRLANDESwAQyEsAwMRLALDESwBArl8AMA1LAPANSwBAbkMAUG5DAIBuQwBgbkMAMK5LAAAOSwBwbkMAEA1LAKCtSwBwrksAkK1LAFCtSwBwrUsAYK1LAFCtSwBArl8AMA1LAPANSwBAbkMAUG5DAIBuQwBgbkMAEK9LAPCuSwBwbkMAEA1LAKCtSwDQYUsAgGJLAHDISwAgxUsAEMVLAFDISwAAxUsA8MRLAECuXwAwDUsA8A1LAEBuQwBQbkMAgG5DAGBuQwBgr0sAQK9LAHBuQwAQDUsAoK1LACBpSwBwaUsAsMhLAGDFSwBQxUsAkMhLAEDFSwAwxUsAQK5fADANSwDwDUsAQG5DAFBuQwCAbkMAYG5DALCvSwCQr0sAcG5DABANSwCgrUsAgGxLAIBtSwDwyEsAoMVLAJDFSwDQyEsAgMVLAHDFSwBArl8AMA1LAPANSwBAbkMAUG5DAIBuQwBgbkMAALBLAOCvSwBwbkMAEA1LAKCtSwCQdEsAwHVLADDJSwDgxUsA0MVLABDJSwDAxUsAsMVLAECuXwAwDUsA8A1LAEBuQwBQbkMAgG5DAGBuQwBQsEsAMLBLAHBuQwAQDUsAoK1LANB5SwCAeksAcMlLACDGSwAQxksAUMlLAADGSwDwxUsAQK5fADANSwDwDUsAQG5DAFBuQwCAbkMAYG5DAKCwSwCAsEsAcG5DABANSwCgrUsAcH5LAKB+SwCwyUsAYMZLAFDGSwCQyUsAQMZLADDGSwBArl8AABlMAFAZTADgsEUA8LBFAACxRQBgbkMAILFLAOCDSwBwjEsA8K9FAPCPSwAQsEUAcI5LANAXTAAQkEsAUJpLADCwRQCgr18AALBfACCwXwDQr18AwK5fACCvXwBQr18AQLBFAACxSwAQsUsAgLVfAJC1XwDwsl8AAJBLANCbSwDAm0sA4BlMAOCwSwAwsUUAQLFFABARTABQsUUAcLFFAICxRQDQsEsAAIhLALCCSwAwg0sA8LBLALCeSwCAn0sA0J9LAKCgSwDgoEsA8KBLAAChSwBgoUsAcKFLALChSwAwnksAcJ5LAHCrSwAAoksAYKNLAACmSwDwqksAQJxLAFCcSwBgnEsAcJxLAICcSwCQnEsAoJxLAGCbSwCgm0sAELtLAHC7SwAQwksAQMJLAAAAQEMAAJZD2w9JQIXrUUAAAEA/7FHIQMZttD4AAC9DAAC0QgAAQEAAAIJCAACcQoXrUT/xaOOItfjkvlDgSwAA3UsA4P1LAMDdSwCQ3ksAsOJLAMD9SwDQ/UsAkOpLAEDoSwAA/ksAMOlLAJDpSwBg7EsAwP1LAND9SwAg8ksA0PBLACD+SwCw8UsAEPJLAODySwDA/UsA0P1LAAAAlkPbD0lAhetRQAAAQD/sUchAxm20PgAAL0MAALRCAABAQAAAgkIAAJxChetRP0CuXwAAGUwAUBlMAOCwRQDwsEUAALFFAGBuQwAwB0wAsAFMALACTADwr0UAALBFABCwRQCwFUwA0BdMACCwRQAQA0wAMLBFAKCvXwAAsF8AILBfANCvXwDArl8AIK9fAFCvXwBAsEUAEAdMACAHTACAtV8AkLVfAPCyXwAQsUUAAANMAMAZTADgGUwA4AZMADCxRQBAsUUAEBFMAPAGTABwsUUAgLFFAAAAlkPbD0lAhetRQAAAQD/sUchAxm20PgAAL0MAALRCAABAQAAAgkIAAJxChetRPwAAlkPbD0lAhetRQAAAQD/sUchAxm20PgAAL0MAALRCAABAQAAAgkIAAJxChetRPwAAlkPbD0lAhetRQAAAQD/sUchAxm20PgAAL0MAALRCAABAQAAAgkIAAJxChetRPywBAAD/HwAACCl0ABwpdAACAAAADAAAAAoAAAABASwBAAD/HwAAKCl0ADQpdAACAAAADAAAAAoAAAAAAQAAAAAAAJZD2w9JQIXrUUAAAEA/uB4NQOxRyEDGbbQ+AAAvQwAAtEIAAEBAAACCQgAAnEKF61E/AAAAAMgpdAAKAAAA3Cl0AAoAAADwKXQACgAAAAQqdAAKAAAAGCp0AAoAAAAoKnQACgAAADgqdAAKAAAARCp0AAoAAABQKnQACgAAAGQqdAAKAAAAeCp0AAoAAACMKnQACgAAAKAqdAAKAAAAsCp0AAoAAADAKnQACgAAAMwqdAAKAAAA2Cp0AAoAAADkKnQACgAAAAAAAAAAAAAA0JlMAFCZTACQmUwA4G9CADBxQgBQckIAIJlMADCZTABAmUwAAAAAAECuXwAAGUwAUBlMAOCwRQDwsEUAALFFAGBuQwAAm0wAcC1MAGAuTADwr0UAALBFABCwRQBgOEwA0BdMAJAwTAAQOUwAMLBFAKCvXwAAsF8AILBfANCvXwDArl8AIK9fAFCvXwBAsEUAwLBFAPCaTACAtV8AkLVfAPCyXwAQsUUA0BlMAMAZTADgGUwA4JpMADCxRQBAsUUAEBFMAFCxRQBwsUUAgLFFAACaTADASmwAwEpsAMBKbADASmwAwEpsAMBKbADASmwAwEpsAMBKbADASmwAwEpsACCaTAAQmkwAwEpsAMBKbADASmwAwEpsAMBKbADASmwAwEpsAMBKbADASmwAwEpsAMBKbADASmwAwEpsAMBKbADASmwAwEpsAMBKbADASmwAwEpsAMBKbADASmwAwFNMAJBYTACwWEwA8FpMAFBbTABAmkwAEFxMAHBcTADAXkwAoHRMAFCaTABgmkwAcHZMANB3TAAAf0wAgH9MAMCATAAQgkwAMINMABCETABQhUwA4IZMACCITAAAiUwAcIlMAOCJTACgikwAEItMAICLTAAgjEwAAI1MAHCNTABQjkwAwI5MAICPTACQkEwA8JBMAFCRTAAwkkwAoJJMAHCTTADwlEwA8JZMADCXTABwmkwAgJpMAJCaTACgmkwAsJpMAMCaTADQmkwAsJtMADCbTABwm0wAiYiIPAAASEUAwKhFAACWQ9sPSUCF61FAAABAP7geDUDsUchAxm20PgAAL0MAALRCAABAQAAAgkIAAJxChetRPwAAAABArl8AABlMAFAZTADgsEUA8LBFAACxRQBgbkMAINZMAHAtTABgLkwA8K9FAACwRQAQsEUAYDhMANAXTACQMEwAEDlMADCwRQCgr18AALBfACCwXwDQr18AwK5fACCvXwBQr18AQLBFABDWTADwmkwAgLVfAJC1XwDwsl8AELFFANAZTADAGUwA4BlMAMDVTADQ1UwAQLFFABARTABQsUUAcLFFAICxRQAAmkwA0MxMAKDMTAAAzUwAEM1MACDNTAAAzkwAUM5MAGDOTACwzkwAIM9MAFDPTABwz0wAYM9MAKDPTADQz0wAANBMABDQTAAg0EwAMNBMAEDQTABQ0EwAYNBMAJDRTABw0UwA8NFMAADSTAAg0kwAMNJMAEDSTABQ0kwAYNJMAIDSTACw0kwA0NJMAADTTACQWEwAsFhMAPBaTABQW0wAsNVMABBcTABwXEwAwF5MAKB0TADg1UwAYJpMAHB2TADQd0wAAH9MAIB/TADAgEwAEIJMADCDTAAQhEwAUIVMAOCGTAAgiEwAAIlMAHCJTADgiUwAoIpMABCLTACAi0wAIIxMAACNTABwjUwAUI5MAMCOTACAj0wAkJBMAPCQTABQkUwAMJJMAKCSTABwk0wA8JRMAPCWTAAwl0wAcJpMAICaTACQmkwAoJpMALCaTADAmkwA0JpMANDYTADG/FwAwPxcAMDXTABg2EwAgNhMAKDYTACw2EwAwNhMAHARQACAEUAAQNdMAKDXTACg1kwAUNZMAAAAlkPbD0lAhetRQAAAQD+4Hg1A7FHIQMZttD4AAC9DAAC0QgAAQEAAAIJCAACcQoXrUT9Arl8AABlMAFAZTADgsEUA8LBFAACxRQBgbkMAQO5MAHAtTABgLkwA8K9FAACwRQAQsEUAsOxMANAXTACQMEwAEDlMADCwRQCgr18AALBfACCwXwDQr18AwK5fACCvXwBQr18AQLBFADDuTADwmkwAgLVfAJC1XwDwsl8AELFFANAZTADAGUwA4BlMAODtTADw7UwAQLFFABARTABQsUUAcLFFAICxRQAAmkwAsOhMAKDoTADg6EwA8OhMAADpTAAQ6UwAYOlMAHDpTADA6UwAEOpMAEDqTABg6kwAUOpMAJDqTADA6kwA8OpMAADrTAAQ60wAIOtMADDrTABA60wAUOtMAHDrTABg60wAoOtMALDrTADQ60wA4OtMAPDrTAAA7EwAEOxMADDsTABg7EwAgOxMAADuTAAQ7kwAsFhMAPBaTABQW0wAQJpMABBcTABwXEwAwF5MAKB0TABQ7UwAIO5MAADtTADQd0wAAH9MAIB/TADAgEwAEIJMADCDTAAQhEwAUIVMAOCGTAAgiEwAAIlMAHCJTADgiUwAoIpMABCLTACAi0wAIIxMAACNTABwjUwAUI5MAMCOTACAj0wAkJBMAPCQTABQkUwAMJJMAKCSTABwk0wA8JRMAPCWTAAwl0wAcJpMAICaTACQmkwAoJpMALCaTADAmkwA0JpMAMDuTABw7kwAAACWQ9sPSUCF61FAAABAP7geDUDsUchAxm20PgAAL0MAALRCAABAQAAAgkIAAJxChetRPwAAAABArl8AABlMAFAZTADgsEUA8LBFAACxRQBgbkMAoAVNAHAtTABgLkwA8K9FAACwRQAQsEUAYDhMANAXTACQMEwAEDlMADCwRQCgr18AALBfACCwXwDQr18AwK5fACCvXwBQr18AQLBFAJAFTQDwmkwAgLVfAJC1XwDwsl8AELFFANAZTADAGUwA4BlMAEAFTQBQBU0AQLFFABARTABQsUUAcLFFAICxRQAAmkwAwP9MAKD/TADw/0wAAABNABAATQDwAE0AQAFNAFABTQCgAU0AEAJNAEACTQBgAk0AUAJNAJACTQDAAk0A8AJNAAADTQAQA00AIANNADADTQBAA00AUANNAHADTQBgA00AoANNALADTQDQA00A4ANNAPADTQAABE0AEARNADAETQBgBE0AgARNAMBTTACQWEwAsFhMAPBaTABQW0wAMAVNABBcTABwXEwAwF5MAKB0TABgBU0AYJpMAHB2TADQd0wAAH9MAIB/TADAgEwAEIJMADCDTAAQhEwAUIVMAOCGTAAgiEwAAIlMAHCJTADgiUwAoIpMABCLTACAi0wAIIxMAACNTABwjUwAUI5MAMCOTACAj0wAkJBMAPCQTABQkUwAMJJMAKCSTABwk0wA8JRMAPCWTAAwl0wAcJpMAICaTACQmkwAoJpMALCaTADAmkwA0JpMACAGTQDQBU0AAACWQ9sPSUCF61FAAABAP7geDUDsUchAxm20PgAAL0MAALRCAABAQAAAgkIAAJxChetRPwAAAABArl8AABlMAFAZTADgsEUA8LBFAACxRQBgbkMAwBNNAHAtTABgLkwA8K9FAACwRQAQsEUAYDhMANAXTACQMEwAEDlMADCwRQCgr18AALBfACCwXwDQr18AwK5fACCvXwBQr18AQLBFALATTQDwmkwAgLVfAJC1XwDwsl8AELFFANAZTADAGUwA4BlMAOCaTAAwsUUAQLFFABARTABQsUUAcLFFAICxRQAAmkwAAA9NAOAOTQAwD00AcBNNAEAPTQBQD00AoA9NALAPTQAAEE0AUBBNAIAQTQCgEE0AkBBNANAQTQAAEU0AMBFNAEARTQBQEU0AYBFNAHARTQCAEU0AkBFNALARTQCgEU0A4BFNAPARTQAQEk0AIBJNADASTQBAEk0AUBJNAHASTQCgEk0AwBJNAMBTTACQWEwA8BJNAPBaTABQW0wAQJpMABBcTABwXEwAwF5MAKB0TACAE00AYJpMAHB2TADQd0wAAH9MAIB/TADAgEwAEIJMADCDTAAQhEwAUIVMAOCGTAAgiEwAAIlMAHCJTADgiUwAoIpMABCLTACAi0wAIIxMAACNTABwjUwAUI5MAMCOTACAj0wAkJBMAPCQTABQkUwAMJJMAKCSTABwk0wA8JRMAPCWTAAwl0wAcJpMAICaTACQmkwAoJpMALCaTADAmkwA0JpMACAUTQDwE00AAACWQ9sPSUCF61FAAABAP7geDUDsUchAxm20PgAAL0MAALRCAABAQAAAgkIAAJxChetRPwAAAABArl8AABlMAFAZTADgsEUA8LBFAACxRQBgbkMAUChNAHAtTABgLkwA8K9FAACwRQAQsEUAYDhMANAXTACQMEwAEDlMADCwRQCgr18AALBfACCwXwDQr18AwK5fACCvXwBQr18AQLBFAEAoTQDwmkwAgLVfAJC1XwDwsl8AELFFANAZTADAGUwA4BlMAOCaTAAwsUUAQLFFABARTABQsUUAcLFFAICxRQAAmkwAECNNAPAiTQBAI00AAChNAFAjTQBgI00AsCNNAMAjTQAQJE0AYCRNAJAkTQCwJE0AoCRNAOAkTQAQJU0AQCVNAFAlTQBgJU0AcCVNAIAlTQCQJU0AoCVNAMAlTQCwJU0A8CVNAAAmTQAgJk0AMCZNAEAmTQBQJk0AYCZNAIAmTQCwJk0A0CZNAMBTTACQWEwAsFhMAPBaTABQW0wAQJpMABBcTABwXEwAwF5MAKB0TAAQKE0AYJpMAAAnTQDQd0wAAH9MAIB/TADAgEwAEIJMADCDTAAQhEwAUIVMAOCGTAAgiEwAAIlMAHCJTADgiUwAoIpMABCLTACAi0wAIIxMAACNTABwjUwAUI5MAMCOTACAj0wAkJBMAPCQTABQkUwAMJJMAKCSTABwk0wA8JRMAPCWTAAwl0wAcJpMAICaTACQmkwAoJpMALCaTADAmkwA0JpMANAoTQCAKE0AAACWQ9sPSUCF61FAAABAP7geDUDsUchAxm20PgAAL0MAALRCAABAQAAAgkIAAJxChetRPwAAAABArl8AABlMAFAZTADgsEUA8LBFAACxRQBgbkMAYGtNAIA/TQAAQk0A8K9FAACwRQAQsEUAQEdNANAXTAAwR00AEDlMADCwRQCgr18AALBfACCwXwDQr18AwK5fACCvXwBQr18AQLBFAFBrTQDwmkwAgLVfAJC1XwDwsl8AELFFANAZTADAGUwA4BlMAOCaTAAwsUUAQLFFABARTABQsUUAcLFFAICxRQAAmkwA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wLpIALApTgBwI04AMClOAGApTgDgI04A8CNOAEAkTgAAAAAAgCROAJAkTgDAJE4AACVOABAlTgAwJU4A8ORIALDlSADwJU4AQCtOAHArTgBwJk4AgOdIAMAmTgAAJ04AQCdOAHDtSADgJ04AkCtOABAsTgAgLE4AcCNOAMAsTgDwLE4AMPVIAPAjTgBAJE4A4OxIAJArTgAQLE4AICxOAHAjTgBALE4AcCxOAMDuSADwI04AQCROALDpSACAJE4AkCROAMAkTgAAJU4AECVOADAlTgBQw0gAEMRIAPAlTgAgJk4AUCZOAHAmTgBQxUgAwCZOAAAnTgBAJ04AAMdIAOAnTgDQxkgAoMZIAFDGSABQyEgAAMlIANAvTgBwI04AQC9OAHAvTgCwzkgA8CNOAEAkTgAQyUgAUMlIAJDLSABAzUgAoDBOAGAxTgAAMk4AcCNOAHAxTgCgMU4A4CNOAPAjTgBAJE4AMLBIAHCvSACwr0gAEDJOAAAAAAAAAAEBAAAAAAAAAAABAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6ADsAPAA9AD4APwBAAP///v8AAPz/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPr/AAAAAAAA+P8AAAAA9v9bAFwAXQBeAF8AYAAHAP3/AAD7/xsADAAAAAAAAAAAAAAAAAAAAAoAAAAAAAAADQD5/wkAAAAAAPf/AAAAAPX/AAAFBQUFBQUFBQUFBQQGAAAAgAAAAGAAAAD/////gAAAAP//////////YAAAAP//////////QAAAAIAAAABgAAAA4AAAACABAAD/////IAEAAP//////////QAAAAP//////////wAAAAP//////////4AAAAP//////////AAEAAP//////////AAAAAP//////////oAAAAP//////////IAAAAP//////////4I1OABCOTgAAAIBDAAAAAADgb0CBgIA7AAAAAEMvGYsKvwVAAAD+QgQCATywpk4AwKZOANCmTgDgpk4A8KZOAACnTgAQp04AMKdOAECnTgBQp04AYKdOACCcTgDQm04AUJxOAHCcTgAwpk4AUKZOAHCmTgCgpk4A8JhOAHCVTgBgm04AsJtOAIClTgCgpU4AwKVOAPClTgAApk4AEKZOACCmTgDAk04AUJJOAICUTgDglE4A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"},
{223424,"AAAAAHdhcl93YWdvbgAAACT4cQAw+HEAPPhxAEz4cQBg+HEAdPhxAIj4cQCc+HEAqPhxALT4cQDE+HEAAAAAAP//AAABAAAAvHSTvArXo7zNzMy9j8L1va5HYb0K16O9rkdhvQrXo70pXA+9KVwPvSlcD70pXA+9j8L1va5H4b0K16O9AAAAAClcD70AAAAAKVwPvQAAAADsUTi9AAAAAM3MzDwK1yM9j8J1Pa5H4T28dJM8zczMPLx0kzzNzMw8vHQTPI/CdTy8dBM8j8J1PJqZmT3NzMw97FE4PQAAAAAK16M7AAAAAArXozsAAAAAj8J1PAAAAAAK16M8j8L1PArXI72PwnW9CtejvM3MzLwK16O8zczMvKabxDsK1yM8ppvEOwrXIzwK16O8zcxMvQrXIz0AAAAAAAAAAAAAAAA="},
{223808,"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"},
{239808,"AAAAAAAA2EEAACDCAABcQ/////8AgG1F5ax9PgAAAAACAAAAAgAAAOf/uES4HsxEmpmZPicxyD+oxts/AAAAAJqZhkIR4XlCzczMPZqZ+b8AAAAAzcxMveXQMkCWssQ/lrLEPwAAoECF6/E+BAAAAAUAAAAEAAAABQAAAGOU1j6XDY8+lw2PPtQOnDwAAAAAzczMPgAAAD85+g4+9FCevvRQnr4AAAAAAAAAAAAAAABbDAI+ABCkRgAAgD8CAAAA3t8CQOXQMkCBfAU/KdKFvlWglrwAAAAAj8L1PFyPQr4K16M9idLeugrXI7xvEoO7AACAPwAAgD+qqqo9WDk0va5HYT0AAAA+cT2KPWj6cQAI+3EAqPtxAEj8cQAo/3EAyP9xAGgAcgBIA3IA6ANyAIgEcgDgBHIAoAVyAPgFcgBQBnIAEAdyAGgHcgAoCHIAcAhyAOAIcgAI+XEAYPlxALj5cQAQ+nEAAAAAAABAHEYAAOjCAAANQwAAAAAAQBxGAADowgAADUMAAAAAcT2KPwAAIMIAAFxDAABwQgAA/kIAACDCAABcQwAAcEIAAP5CAAAgwgAAXEMAAAA/AADQQAAAIMIAAFxDAAAAAAAA2EEAACDCAABcQ/////8AgG1FdzXIPgAAAAACAAAAAgAAAOf/uES4HsxEmpmZPicxyD+oxts/AAAAAJqZhkIR4XlCzczMPZqZ+b8AAAAAzcxMveXQMkCWssQ/lrLEPwAAoECh+PE+BgAAAAcAAAAGAAAA"},
{254592,"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0wBkfdQAZH3UAGR91ABkfdQAZH3UAGR91ABkfdQAZH3UAGR91ABkfdQAZH3UAGR91ABkfdQAZH3UAGR91ABkfdQAZH3UAAiy0wAMstMAZH3UABCy0wAUstMAZH3UAGR91ABkfdQAXP10AGR91ABkfdQAZH3UAFz9dABkfdQAZH3UAGR91ABc/XQAZH3UAGR91ABkfdQAXP10AFTw6wBY8OsAXPDrAGDw6wBk8OsAaPDrAGzw6wBw8OsAdPDrAHjw6wB88OsAgPDrAITw6wCI8OsAjPDrAJDw6wCU8OsAmPDrAJzw6wCg8OsApPDrAKjw6wCs8OsAsPDrABTe6wBkfdQAZH3UAFz9dABkfdQAZH3UAGR91AC08OsAZH3UAGR91ABkfdQAZH3UAGR91AAY3usAZH3UAGR91ABkfdQAZH3UAGR91AC48OsAZH3UAGR91ABkfdQAZH3UAGR91ABc/XQAZH3UAGR91ABkfdQAXP10AGR91ABkfdQAZH3UAFz9dAA45+sAPOfrAEDn6wAU5+sAGOfrABzn6wAg5+sAJOfrACjn6wAs5+sAMOfrADTn6wBE5+sASOfrAEzn6wBU5+sAWOfrAFzn6wBg5+sAZOfrAGjn6wBs5+sAcOfrAHTn6wBQ5+sAZH3UAGR91ABc/XQAZH3UAGR91ABkfdQAoPLrAKTy6wCo8usAZH3UAGR91ABkfdQAEOfrAGR91ABkfdQAZH3UAGR91ABkfdQA6OnrAGR91ABkfdQAZH3UAGR91ABkfdQAZH3UAGR91ABkfdQAnOfrAKDn6wCk5+sAqOfrAKzn6wCw5+sAeOfrAHzn6wCA5+sAZH3UAGR91ABkfdQAhOfrAIjn6wCM5+sAZH3UAGR91ABkfdQAkOfrAJTn6wCY5+sAZH3UAGR91ABkfdQAZH3UAGR91ABkfdQALL7TADC+0wBkfdQAZH3UAGR91ABkfdQANL7TADi+0wBkfdQAZH3UAGR91ABkfdQAZH3UAGR91ABc/XQAZH3UAGR91ABkfdQAZH3UAGR91ABkfdQAZH3UAGR91ABkfdQAZH3UAGR91ABkfdQAZH3UAGR91ABkfdQAZH3UAGR91ABkfdQAZH3UAGR91ABkfdQAXOjTAGR91ABkfdQAZH3UAGR91ABkfdQAZH3UAGR91ABkfdQAZH3UAGR91ABkfdQAZH3UAGR9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"},
{405504,"dGluZ19ncmlkXzEAcm9hZF9jYXV0aW9uX2FkdmFuY2VfZGxvbmcAAHRyYWNrX3R5cGUAAHRyYWNrX2RpcgAAAHRyYWNrX2NpdHkAAHRyYWNrX3N0YXRlAHRyYWNrX2xlbmd0aF9uX3R5cGUAdHJhY2tfbWlzY19pbmZvXzEAAAB0cmFja19taXNjX2luZm9fMgAAAHRyYWNrX21pc2NfaW5mb18zAAAAdHJhY2tfbWlzY19pbmZvXzQAAAB0cmFja19taXNjX2luZm9fNQAAAG1heF9zdGFydGVycwAAAABkZWZhdWx0X2V2ZW50X2xhcHMAAGRlZmF1bHRfcXVhbF9sYXBzAAAAdHJhY2tfYmFzZV9tb250aAAAAAB0cmFja19idWlsZHVwX3JhdGUAAHS/dACAv3QAlL90AKS/dAC0v3QAxL90ANi/dADsv3QA/L90AAzAdAAowHQANMB0AEDAdABMwHQAWMB0AGzAdACAwHQAlMB0AKjAdAC8wHQA0MB0AODAdAD0wHQACMF0ABzBdAB0cmFja19iYXNlX3RlbXAAdHJhY2tfdGVtcF9yYW5nZQAAAAB0cmFja190ZW1wX3N3aW5nAAAAAHRyYWNrX3dpbmRfc3BlZWQAAAAAdHJhY2tfd2luZF9zcGVlZF9yYW5nZQAAdHJhY2tfd2luZF9kaXJlY3Rpb24AAAAAdHJhY2tfY2xvdWRfcHJvYgAAAACUwXQApMF0ALjBdADMwXQA4MF0APjBdAAQwnQAdHJhY2sgYXZnIHRlbXBlcmF0dXJlIG9uIEFwcmlsIDEgKEYpAAAAAHRyYWNrIG1heCBkYWlseSB0ZW1wIHZhcmlhdGlvbiAoRikAAHRyYWNrIGF2ZyB0ZW1wIGNoYW5nZSBmcm9tIEphbnVhcnkgdG8gQXByaWwgKEYpAHRyYWNrIGJhc2Ugd2luZCBzcGVlZCAobXBoKQB0cmFjayBtYXggd2luZCBzcGVlZCB2YXJpYXRpb24gKG1waCkAAAAAdHJhY2sgYmFzZSB3aW5kIGRpcmVjdGlvbiAoMCAtPiAzNjAsIDAgbWVhbnMgZnJvbSBOKXRyYWNrIGNsb3VkIHByb2JhYmlsaXR5ICgwLT4xKQAAQMJ0AGjCdACMwnQAvMJ0ANjCdAAAw3QAAACAP2xhbmVfb25fcmlnaHQAAABsYW5lX2hhc193YWxsAAAAbGFuZV9hcHByb2FjaF9kbG9uZwBsYW5lX21lcmdlX2Rsb25nAAAAAHBpdF9ib2FyZAAAAHN0YWxsX3BhY2UAAHN0YWxsX3ByYWN0aWNlX2V4aXQAc3RhbGxfcXVhbF9leGl0AHN0YWxsX2VudGVyAHNwZWVkX2xpbWl0X01QSABkdWFsX3N3aXRjaF9kbG9uZwAAAGR1YWxfbGluZTBfaWdub3Jlem9uZQAAAGR1YWxfbGluZTFfaWdub3Jlem9uZQAAAHDDdACAw3QAkMN0AKTDdAC4w3QAxMN0ANDDdADkw3QA9MN0AADEdAAQxHQAJMR0ADzEdAByZWNvcmRfbGFwX3RpbWUAcmVjb3JkX2hvbGRlcgAAAIjEdACYxHQATm9uYW1lIFNwZWVkd2F5AE5vbmFtZQAATm9jaXR5AABOb3N0YXRlAE5vbGVuZ3RoIE5vdHlwZQAlZiVjAAAAACVkAAAlZgAAJWYgJWYAAAAlZAAAJWQAACVmAAAlZAAAJWQAACVkAAAlZAAAJWQAACVkAAAlZgAAdHJhY2sAAAB0cmFjay5pbmkAAAAlZgAAJWYAACVmAAAlZgAAJWYAACVmAAAlZgAAd2VhdGhlcgB0cmFjay5pbmkAAAAlZAAAJWQAACVmAAAlZgAAJWYgJWYgJWYgJWYAJWYgJWYgJWYAAAAAJWYgJWYgJWYAAAAAJWYgJWYgJWYAAAAAJWYgJWYgJWYAAAAAJWYAACVmAAAlZiAlZgAAACVmICVmAAAAcGl0X2xhbmVfJWQAdHJhY2suaW5pAAAAc3RhbGxfJWQAAAAAdHJhY2suaW5pAAAAJWYgJWYgJWYAAAAAc3RhcnRpbmdfZ3JpZF8lZAAAAABzdGFsbF9wYWNlAAB0cmFjay5pbmkAAAAlZiAlZiAlZgAAAABzdGFsbF8lZAAAAAB0cmFjay5pbmkAAAAlZiAlZiAlZgAAAABjb25maWd1cmF0aW9uXyVkAAAAAGNoZWNrcG9pbnRfJWQAAABxdWFsX29ubHkAAABBcHBSdWxlQ3V0Q291cnNlAAAAAHRyYWNrLmluaQAAACVmICVmICVmICVmICVkAAAlcwAAdHJhY2suaW5pAAAAJWYAAHRyYWNrLmluaQAAAP//AAAAACBBAAAgQf//////////HoVfQ3NlY29uZHMgYmV0d2VlbiBTZXNzaW9uSW5mbyB0ZWxlbWV0cnkAAABzZXNzaW9uX2luZm9fcGVyaW9kAFRlbGVtZXRyeQAAAHNlY29uZHMgYmV0d2VlbiBTdGFuZGluZ3MgdGVsZW1ldHJ5AHN0YW5kaW5nc19wZXJpb2QAAAAAVGVsZW1ldHJ5AAAAAAAAAP//AAAAAAAAAAAAAAAAAAAAAAAAAAAgQAAAAAAAACBAAAAAAAAAMUAAAAAAAAAAAAAAAAAAAABAAAAAAAAAEEAAAAAAAAAcQAAAAAAAAChAAAAAAAAALkAAAAAAAAAAAHsUrkfherQ/KVyPwvUozD8AAAAAAADgPwrXo3A9Cuc/AAAAAAAA8D8AAAAAAADwPwAAAAAAAPA/AAAAAAAAAAAAAAAAAADwPwAAAAAAAPA/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//8AAE9SUEyQR1QAAAAAAP//AAABAAAA4KRVACUlLiVkUwAAJXNjaGFubmVsWyVkXS4uLgAAAAAlc2NoYW5uZWxbJXNdLi4uAAAAACVkAAAlYyVkTAAAACVjJWRTAAAAJWQlYyVjJWMlYyVjJWMlYyVjJWMlYyVjAAAAACUwMnglMDJ4AAAAACUwMngAAAAAJTAyeCUwMngAAAAAJTAyeAAAAABTVgAAU1YAAAAAAAAlcwElZAElZAElcwElcwElcwElcwElcwElZC8lZAElcwElcwElYwElZAElYyVkASVjASVjASVjASVkASVzASVkAAAAAP//AAD//wAAiOiVQ///AAABAAAAAIC7RAQAAAAEAAAAAACAvwAAgD8BAAAABAAAAAEAAADsUbg9uB6FPVR5vQAAAIA/AisHPQAAgD8AAIA/AAAgQAEAAAAAAKBCAACAP/////9FbmFibGUgbG93IHNwZWVkIHN0ZWVyaW5nIHJhdGlvIG92ZXJyaWRlAAAAAHN0ZWVyX3JhdGlvAENvbnRyb2wgT3B0aW9ucwBjaGFzc2lzAP//AAAAAIA/mpmZPwAAgD8AAIA/mpmZP2Zmpj/hetQ/AFBDRwAAQEAAAEBAAABAQABAnEYAJPRIACT0SABAnEYzMzM/MzMzPzMzMz8AAAAAAACAQAAAAEAAAABAAACAPwAAgD8AALBBAACwQQAAsEEAAIA/zczMPc3MzD0AAAA/AIC7RQBg6kYFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAABgAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAM3MTD4AAAAAAAAAvwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgL9mZuY+zcxMvwAAgL9mZuY+zcxMvwAAgL9mZuY+zcxMvwAAgL9mZuY+zcxMvwAAgL9mZuY+zcxMvwAAgL9mZuY+zcxMvwAAgL9mZuY+zcxMvwAAgL9mZuY+zcxMvwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACwy3QAAAAAAMjLdAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOjMdAD0zHQAAM10AAzNdAAYzXQAJM10ADDNdAA8zXQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAADNzEw+AAAAAAAAAL8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMC/mpm5P83MTL8AAMC/mpm5P83MTL8AAMC/mpm5P83MTL8AAMC/mpm5P83MTL8AAMC/mpm5P83MTL8AAMC/mpm5P83MTL8AAMC/mpm5P83MTL8AAMC/mpm5P83MTL8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASM50AAAAAABgznQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAz3QAjM90AJjPdACkz3QAsM90ALzPdADIz3QA1M90AAAAAAB0aXJlX2FzcGhhbHQuY2VzAAAAAHRpcmVfZ3Jhc3MuY2VzAAB0aXJlX2dyYXZlbC5jZXMAdGlyZV9ydW1ibGUuY2VzAAAAAACU0HQAqNB0ALjQdADI0HQAY29udmVydCBzdGVyZW8gdG8gbW9ubyBmb3IgcG9zaXRpb25hbCBzb3VuZHMgaW4gM2QgbW9kZQBjb252ZXJ0XzNkX3N0ZXJlbwAAAFNvdW5kAAAAMC0xIHZhbHVlIGZvciByb2xsaW5nIHZzLiBzcXVlYWwuAAAAU2hvcnRPdmFsU2NhbGFyAFRpcmVTb3VuZHMAADAtMSB2YWx1ZSBmb3Igcm9sbGluZyB2cy4gc3F1ZWFsLgAAAE1pbGVPdmFsU2NhbGFyAABUaXJlU291bmRzAAAwLTEgdmFsdWUgZm9yIHJvbGxpbmcgdnMuIHNxdWVhbC4AAABNZWRPdmFsU2NhbGFyAAAAVGlyZVNvdW5kcwAAMC0xIHZhbHVlIGZvciByb2xsaW5nIHZzLiBzcXVlYWwuAAAATG9uZ092YWxTY2FsYXIAAFRpcmVTb3VuZHMAADAtMSB2YWx1ZSBmb3Igcm9sbGluZyB2cy4gc3F1ZWFsLgAAAFN1cGVyU3BlZWR3YXlTY2FsYXIAVGlyZVNvdW5kcwAAMC0xIHZhbHVlIGZvciByb2xsaW5nIHZzLiBzcXVlYWwuAAAAUm9hZENvdXJzZVNjYWxhcgAAAABUaXJlU291bmRzAABtaW4gdW5pdHMgb2YgZm9yY2UgZm9yIFhGYWRlAAAAAFhGYWRlUG93ZXJNaW5fQVNQSEFMVAAAAFRpcmVTb3VuZHMAAG1heCB1bml0cyBvZiBmb3JjZSBmb3IgWEZhZGUAAAAAWEZhZGVQb3dlck1heF9BU1BIQUxUAAAAVGlyZVNvdW5kcwAAbWluIHVuaXRzIG9mIGZvcmNlIGZvciB2b2x1bWUAAABWb2x1bWVNaW5fQVNQSEFMVAAAAFRpcmVTb3VuZHMAAG1heCB1bml0cyBvZiBmb3JjZSBmb3Igdm9sdW1lAAAAVm9sdW1lTWF4X0FTUEhBTFQAAABUaXJlU291bmRzAABtaW4gcGl0Y2ggdmFsAAAAUGl0Y2hNaW5Ob3JtX0FTUEhBTFQAAAAAVGlyZVNvdW5kcwAAbWF4IHBpdGNoIHZhbAAAAFBpdGNoTWF4Tm9ybV9BU1BIQUxUAAAAAFRpcmVTb3VuZHMAAG0vcyBzYW1wbGUgdmVsb2NpdHkAU2FtcGxlVmVsb2NpdHlfQVNQSEFMVAAAVGlyZVNvdW5kcwAAcGl0Y2ggc2NhbGFyAAAAAFBpdGNoU2NhbGFyX0FTUEhBTFQAVGlyZVNvdW5kcwAAbWluIHVuaXRzIG9mIGZvcmNlIGZvciBYRmFkZQAAAABYRmFkZVBvd2VyTWluX0dSQVNTAFRpcmVTb3VuZHMAAG1heCB1bml0cyBvZiBmb3JjZSBmb3IgWEZhZGUAAAAAWEZhZGVQb3dlck1heF9HUkFTUwBUaXJlU291bmRzAABtaW4gdW5pdHMgb2YgZm9yY2UgZm9yIHZvbHVtZQAAAFZvbHVtZU1pbl9HUkFTUwBUaXJlU291bmRzAABtYXggdW5pdHMgb2YgZm9yY2UgZm9yIHZvbHVtZQAAAFZvbHVtZU1heF9HUkFTUwBUaXJlU291bmRzAABtaW4gcGl0Y2ggdmFsAAAAUGl0Y2hNaW5Ob3JtX0dSQVNTAABUaXJlU291bmRzAABtYXggcGl0Y2ggdmFsAAAAUGl0Y2hNYXhOb3JtX0dSQVNTAABUaXJlU291bmRzAABtL3Mgc2FtcGxlIHZlbG9jaXR5AFNhbXBsZVZlbG9jaXR5X0dSQVNTAAAAAFRpcmVTb3VuZHMAAHBpdGNoIHNjYWxhcgAAAABQaXRjaFNjYWxhcl9HUkFTUwAAAFRpcmVTb3VuZHMAAG1pbiB1bml0cyBvZiBmb3JjZSBmb3IgWEZhZGUAAAAAWEZhZGVQb3dlck1pbl9HUkFWRUwAAAAAVGlyZVNvdW5kcwAAbWF4IHVuaXRzIG9mIGZvcmNlIGZvciBYRmFkZQAAAABYRmFkZVBvd2VyTWF4X0dSQVZFTAAAAABUaXJlU291bmRzAABtaW4gdW5pdHMgb2YgZm9yY2UgZm9yIHZvbHVtZQAAAFZvbHVtZU1pbl9HUkFWRUwAAAAAVGlyZVNvdW5kcwAAbWF4IHVuaXRzIG9mIGZvcmNlIGZvciB2b2x1bWUAAABWb2x1bWVNYXhfR1JBVkVMAAAAAFRpcmVTb3VuZHMAAG1pbiBwaXRjaCB2YWwAAABQaXRjaE1pbk5vcm1fR1JBVkVMAFRpcmVTb3VuZHMAAG1heCBwaXRjaCB2YWwAAABQaXRjaE1heE5vcm1fR1JBVkVMAFRpcmVTb3VuZHMAAG0vcyBzYW1wbGUgdmVsb2NpdHkAU2FtcGxlVmVsb2NpdHlfR1JBVkVMAAAAVGlyZVNvdW5kcwAAcGl0Y2ggc2NhbGFyAAAAAFBpdGNoU2NhbGFyX0dSQVZFTAAAVGlyZVNvdW5kcwAAbWluIHVuaXRzIG9mIGZvcmNlIGZvciBYRmFkZQAAAABYRmFkZVBvd2VyTWluX1JVTUJMRQAAAABUaXJlU291bmRzAABtYXggdW5pdHMgb2YgZm9yY2UgZm9yIFhGYWRlAAAAAFhGYWRlUG93ZXJNYXhfUlVNQkxFAAAAAFRpcmVTb3VuZHMAAG1pbiB1bml0cyBvZiBmb3JjZSBmb3Igdm9sdW1lAAAAVm9sdW1lTWluX1JVTUJMRQAAAABUaXJlU291bmRzAABtYXggdW5pdHMgb2YgZm9yY2UgZm9yIHZvbHVtZQAAAFZvbHVtZU1heF9SVU1CTEUAAAAAVGlyZVNvdW5kcwAAbWluIHBpdGNoIHZhbAAAAFBpdGNoTWluTm9ybV9SVU1CTEUAVGlyZVNvdW5kcwAAbWF4IHBpdGNoIHZhbAAAAFBpdGNoTWF4Tm9ybV9SVU1CTEUAVGlyZVNvdW5kcwAAbS9zIHNhbXBsZSB2ZWxvY2l0eQBTYW1wbGVWZWxvY2l0eV9SVU1CTEUAAABUaXJlU291bmRzAABwaXRjaCBzY2FsYXIAAAAAUGl0Y2hTY2FsYXJfUlVNQkxFAABUaXJlU291bmRzAABtaW4gZm9yY2UgZm9yIHBpdGNoAEFzcGhhbHRQaXRjaE1pbgBUaXJlU291bmRzAABtYXggZm9yY2UgZm9yIHBpdGNoAEFzcGhhbHRQaXRjaE1heABUaXJlU291bmRzAABTT1VORAAAAGVuZ3ZvbC5jZXMAAP//AABIR1RTkItVAERHVFNQjFUAVEdUU0CNVQBwbGF5ZXJzAHNldHVwcwAAc2V0dXBzAABzZXR1cHMAAHBsYXllcnMAc2V0dXBzAABzZXR1cHMAAHNldHVwcwAAdHJhY2tzAABwbGF5ZXJzAHNldHVwcwAA//8BAQEAAAAIAAAAAAAAAPCrTwByZS1jcmVhdGUgc291bmQgYnVmZmVycyB0byBpbXByb3ZlIHF1YWxpdHkAAGFsbG93X2J1ZmZlcl9yZWNyZWF0aW9uAFNvdW5kAAAAZW5hYmxlIHZvbHVtZSBpbnRlcnBvbGF0aW9uIGZvciAzZCBzb3VuZAAAAABlbmFibGVfM2RfaW50ZXJwb2xhdGlvbgBTb3VuZAAAAERpc2FibGUgRGlyZWN0IENvbm5lY3QAAGRpc2FibGVfZGlyZWN0X2Nvbm5lY3QAAENvbW11bmljYXRpb25zAABEb24ndCBsb29rIGZvci91c2UgbW9kZW1zAAAAZGlzYWJsZV9tb2RlbQAAAENvbW11bmljYXRpb25zAABEaXNhYmxlIG5ldHdvcmsg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YmFja2ZpcmVQcmVlbXB0UmF0aW8AAAAAU291bmRzAABJZiB0cnVlLCBkb2VzIGJhY2tmaXJlIHNvdW5kIGZvciBmb2N1cyBjYXIgb25seQBiYWNrZmlyZUZvY3VzT25seQAAAFNvdW5kcwAAbWluIHZvbHVtZSBvciBiYWNrZmlyZXMAYmFja2ZpcmVNaW5Wb2x1bWUAAABTb3VuZHMAAG1heCB2b2x1bWUgb3IgYmFja2ZpcmVzAGJhY2tmaXJlTWF4Vm9sdW1lAAAAU291bmRzAAAwIG9yIDEAAGVuYWJsZVdpbmQAAFNvdW5kcwAAMCBvciAxAABlbmFibGVSZXZlcmIAAAAAU291bmRzAAD//wAARXJhc2UgcmVwbGF5IHRhcGUgYmV0d2VlbiBzZXNzaW9ucz8AY2xlYXJfcmVwbGF5X2VhY2hfc2Vzc2lvbgAAAE1pc2MAAAAA//8AAP//AAA5jmM9zcxMPQEBAQDbD8m/w7iyPgAAgD8AAIA/AACAPwgAAAAAAIA/zczMPQAAAADNzMw9VGltZSB2YWx1ZSAoc2VjcykgdXNlZCBpbiBqb3lzdGljayBzbW9vdGhpbmcAAAAAY29ja3BpdExvb2tTbW9vdGhpbmdUaW1lAAAAAEdyYXBoaWMgT3B0aW9ucwAwLTEgdmFsdWUgZm9yIGRlYWR6b25lLiAwIGlzIG5vIGRlYWR6b25lLgAAAGNvY2twaXRMb29rRGVhZFpvbmUAR3JhcGhpYyBPcHRpb25zAC5jYW0AAAAAdHJhY2tzAAAuY2FtAAAAAC5jYW0AAAAAdHJhY2tzAAAuY2FtAAAAAE5PTkUAAAAAY29ja3BpdABMb29rTGVmdAAAAABMb29rUmlnaHQAAABGMTBOZWFyAEYxMEZhcgAAQ2hhc2UAAABGYXIgQ2hhc2UAAABSZWFyIGNoYXNlAABTa3kATm9zZQAAAABHZWFyYm94AE9uIENhcgAAUm9sbCBCYXIAAAAARiBTdXNwAABSIFN1c3AAAFplcHBlbGluAAAAAFBpdCBMYW5lAAAAAFBpdCBMYW5lIDIAAFRWMQBUVjIAVFYzAHVua25vd24A//8AAGN1cABnbnMAY3RzAHB0YQBw7XQAdO10AHjtdAB87XQAKgAAAHNlcmllcwAAc2VyaWVzLmRlZgAAVW5sb2NhbGl6ZWQgc2VyaWVzIG5hbWUAZ2l2ZW5fbmFtZQAAU2VyaWVzAAAoMD1jdXAsIDE9Z25zLCAyPXRydWNrKQB0eXBlAAAAAFNlcmllcwAAYml0d2lzZS1vciBvZiBhbGxvd2VkIGNsYXNzZXMAAABjYXJfY2xhc3NlcwBTZXJpZXMAAHNlcmllcy5kZWYAACVzXCVzXCVzXCVzAC5sc3QAAAAALmxzdAAAAAAqLmNhcgAAAAkNCgAubHN0AAAAAC5sc3QAACsALQAAAA0KAAANCgAA//8AAP////8EAAAACgAAACgAAAAyAAAACgAAAAEAAAABAQEBTGF1bmNoIGFzIG1wIHNlcnZlcgBsYXVuY2gAAFNFUlZFUgAATGF1bmNoIGFzIGRlZGljYXRlZCBtcCBzZXJ2ZXIAAABkZWRpY2F0ZWQAAABTRVJWRVIAAENvbm5lY3QgdmlhIElQIGFkZHJlc3MAAHZpYV9pcAAAQ0xJRU5UAABDb25uZWN0IHRvIElQIGFkZHJlc3MAAAB0b19pcAAAAENMSUVOVAAAQ29ubmVjdCBjbGllbnQgdG8gc2llcnJhLmNvbT8AAAB0b19zaWVycmEAAABDTElFTlQAAENvbm5lY3Qgc2VydmVyIHRvIHNpZXJyYS5jb20/AAAAdG9fc2llcnJhAAAAU0VSVkVSAABBbGxvdyBjbGllbnRzIHRvIGNvbnRyb2wgc2VydmVyAG9wZW5fc2VydmVyAFNFUlZFUgAATWF4IG9wZW4gc2VydmVyIHNlc3Npb25zIHJlc3RhcnRlZAAAb3Blbl9zZXJ2ZXJfcmVzdGFydF9saW1pdAAAAFNFUlZFUgAATWludXRlcyBhIGJvc3MgbWF5IHNpdCBhdCB0cmFjayBzZWxlY3QAAG9wZW5fc2VydmVyX2Jvc3NfaWRsZV9saW1pdABTRVJWRVIAAE1heCB0b3RhbCBtaW51dGVzIGZvciBwcmFjdGljZS93YXJtdXAAAABvcGVuX3NlcnZlcl9wcmFjdGljZV9sZW5ndGhfbGltaXQAAABTRVJWRVIAAE1heCByYWNlIHNlc3Npb24gbGVuZ3RoIChwZXJjZW50KQAAAG9wZW5fc2VydmVyX3JhY2VfcGVyY2VudF9saW1pdAAAU0VSVkVSAABNYXggbGF0ZW5jeSAoMCB0byBkaXNhYmxlKQAAb3Blbl9zZXJ2ZXJfbWF4X2xhdGVuY3lfbGltaXQAAABTRVJWRVIAAE1pbiBzaWVycmEuY29tIHJhdGluZyBhbGxvd2VkICgtMSB0byBkaXNhYmxlKQAAAG9wZW5fc2VydmVyX21pbl9yYXRpbmdfbGltaXQAAAAAU0VSVkVSAABNYXggc2llcnJhLmNvbSByYXRpbmcgYWxsb3dlZCAoLTEgdG8gZGlzYWJsZSkAAABvcGVuX3NlcnZlcl9tYXhfcmF0aW5nX2xpbWl0AAAAAFNFUlZFUgAATWluIHNpZXJyYS5jb20gTFBJIGFsbG93ZWQgKC0xIHRvIGRpc2FibGUpAABvcGVuX3NlcnZlcl9taW5fTFBJX2xpbWl0AAAAU0VSVkVSAABEaXNhbGxvdyBib3NzIGZyb20gY2FuY2VsbGluZyB3ZWVrZW5kAAAAb3Blbl9zZXJ2ZXJfZGlzYWJsZV9jYW5jZWxfd2Vla2VuZAAAU0VSVkVSAABEaXNhbGxvdyBib3NzIGZyb20gdXNpbmcgY29tbWFuZHMAAABvcGVuX3NlcnZlcl9kaXNhYmxlX2Jvc3NfY29tbWFuZHMAAABTRVJWRVIAAFJhY2UlZAAATmV4dCB0cmFjayBhdCB3aGljaCB0byBydW4gYSByYWNlAAAARGVkaWNhdGVkIFNlcnZlcgAAAAD//wAA//8AAP//AAD//wAACAAAANsPyb/bD8m/2w/Jv9sPyb/bD8m/2w/Jv8O4sj7DuLI+w7iyPsO4sj7DuLI+w7iyPv///wD///8A////AP///wD///8A////AAEBAQEBAQAAAACAPwAAgD8AAIA/AACAPwAAgD8AAIA/CAAAAAgAAAAIAAAACAAAAAgAAAAIAAAAAQAAAAEAAAAAAIA/AACAPwAAgD8gJ7I9AACAPwAAgD8AAIA/CAAAAAAAgD8AAIA/AACAPwAAgD9QHlcAkB5XAIAfVwBwIFcAoCBXANAhVwDwIlcAICNXAIAjVwCwI1cARXh0cmEgZGV0YWlsIGZvciB0cmFjayBkdXJpbmcgcmVwbGF5AAAAAGluc2FuZV90cmFja19kZXRhaWwATWlzYwAAAAAlZAAAJWYgJWYgJWYAAAAAJWYgJWYgJWYAAAAAJWYgJWYAAAAlZiAlZiAlZiAlZgAlZiAlZiAlZiAlZiAlZiAlZAAAACVmICVmAAAAJXMgJXMAAAAlZAAAJWQgJXMAAABzaGFyZWQAAHNoYXJlZAAAdHJhY2tzAABlbnZpcm9ubWVudC5taXAAc2hhcmVkAAAucHRmAAAAAHRyYWNrLmluaQAAAHNoYXJlZAAAV2Vla2VuZABjYXV0aW9uX2xpZ2h0AAAAV2VhdGhlcgBQb3B1bGF0aW9uAABBbmltT2JqcwAAAABEYXlfTmlnaHQAAABza3kuM2RvAFNreVdlYXRoZXIAAFJhbmRvbVNreQAAAFNreVNlc3Npb24AAERheV9OaWdodAAAAGhvcml6LjNkbwAAAFNreVdlYXRoZXIAACpXRUElZAAAKldFQSVkAABzaGFkb3dfdm9sdW1lX2Rpc3QAAEdyYXBoaWNzAAAAAGR5bmxpZ2h0X2Rpc3QAAABHcmFwaGljcwAAAAB0cmFjay5pbmkAAAD//wAAVE5SRLBPVwBUTlJEQFFXACVzICVzAAAA//8AAAAAAAB0cmFja191bmRlZmluZWRfZ3JpcAAAAAB0cmFja19hc3BoYWx0X2dyaXAAAHRyYWNrX2NvbmNyZXRlX2dyaXAAdHJhY2tfcnVtYmxlX2dyaXAAAAB0cmFja19wYWludF9ncmlwAAAAAHRyYWNrX2dyYXNzX2dyaXAAAAAAdHJhY2tfZGlydF9ncmlwAHRyYWNrX3NhbmRfZ3JpcAB0cmFja19ncmF2ZWxfZ3JpcAAAAHRyYWNrX3dhdGVyX2dyaXAAAAAAdHJhY2tfYXJtY29fZ3JpcAAAAAB0cmFja190aXJlX3dhbGxfZ3JpcAAAAAB0cmFja19oYXliYWxlX2dyaXAAAHRyYWNrX2NoYWluX2ZlbmNlX2dyaXAAAHRyYWNrX3NocnViX2dyaXAAAAAAdHJhY2tfZm9yZXN0X2dyaXAAAAB0cmFja193b29kX2ZlbmNlX2dyaXAAAAB0cmFja19jaGFzc2lzX2dyaXAAAHRyYWNrX29wcF93aGVlbF9ncmlwAAAAAHRyYWNrX3doZWVsX2dyaXAAAAAAAAAAADj2dABQ9nQAZPZ0AHj2dACM9nQAoPZ0ALT2dADE9nQA1PZ0AOj2dAD89nQAEPd0ACj3dAA893QAVPd0AGj3dAB893QAlPd0AKj3dADA93QAcmVsYXRpdmUgZ3JpcCBmb3IgdW5kZWZpbmVkIG1hdGVyaWFsAAAAAHJlbGF0aXZlIGdyaXAgZm9yIGFzcGhhbHQgbWF0ZXJpYWwAAHJlbGF0aXZlIGdyaXAgZm9yIGNvbmNyZXRlIG1hdGVyaWFsAHJlbGF0aXZlIGdyaXAgZm9yIHJ1bWJsZSBzdHJpcAAAcmVsYXRpdmUgZ3JpcCBmb3IgcGFpbnQgbWF0ZXJpYWwAAAAAcmVsYXRpdmUgZ3JpcCBmb3IgZ3Jhc3MgbWF0ZXJpYWwAAAAAcmVsYXRpdmUgZ3JpcCBmb3Igc2FuZCBtYXRlcmlhbAByZWxhdGl2ZSBncmlwIGZvciBncmF2ZWwgbWF0ZXJpYWwAAAByZWxhdGl2ZSBncmlwIGZvciB3YXRlciBtYXRlcmlhbAAAAAByZWxhdGl2ZSBncmlwIGZvciBhcm1jbyBtYXRlcmlhbAAAAAByZWxhdGl2ZSBncmlwIGZvciB0aXJlIHdhbGwgbWF0ZXJpYWwAAAAAcmVsYXRpdmUgZ3JpcCBmb3IgaGF5IGJhbGUgbWF0ZXJpYWwAcmVsYXRpdmUgZ3JpcCBmb3IgY2hhaW4gZmVuY2UgbWF0ZXJpYWwAAHJlbGF0aXZlIGdyaXAgZm9yIHNocnViIG1hdGVyaWFsAAAAAHJlbGF0aXZlIGdyaXAgZm9yIGZvcmVzdCBtYXRlcmlhbAAAAHJlbGF0aXZlIGdyaXAgZm9yIHdvb2QgZmVuY2UgbWF0ZXJpYWwAAAByZWxhdGl2ZSBncmlwIGZvciBjaGFzc2lzIG1hdGVyaWFsAAByZWxhdGl2ZSBncmlwIGZvciBvcHAgd2hlZWwgbWF0ZXJpYWwAAAAAcmVsYXRpdmUgZ3JpcCBmb3Igd2hlZWwgbWF0ZXJpYWwAAAAAKPh0AFD4dAB0+HQAmPh0ALj4dADc+HQAAPl0ACD5dABE+XQAaPl0AIz5dAC0+XQA2Pl0AAD6dAAk+nQASPp0AHD6dACU+nQAvPp0AAAAAAAAAIA/AACAP4/CdT+PwnU/ZmZmP+F6FD9mZiY/zcxMP83MTD/NzMw9ZmZmPwAAgD9mZuY+MzMzP83MzD7NzMw+zcxMP2ZmZj8AAIA/AACAP1VuZGVmaW5lZAAAAEFzcGhhbHQAQ29uY3JldGUAAAAAUnVtYmxlAABQYWludAAAAEdyYXNzAAAARGlydAAAAABTYW5kAAAAAEdyYXZlbAAAV2F0ZXIAAABBcm1jbwAAAFRpcmVXYWxsAAAAAEhheWJhbGUAQ2hhaW5GZW5jZQAAU2hydWIAAABGb3Jlc3QAAFdvb2RGZW5jZQAAAENoYXNzaXMAT3BwV2hlZWwAAAAAV2hlZWwAAABVbmtub3duAP//AAAgICAAICBBACBDIAAgQ0EAUyAgAFMgQQBTQyAAU0NBAAAAAAAwPAAAMD4AADE8AAAxPgAAMjwAADI+AAAzPAAAMz4AADQ8AAA0PgAANTwAADU+AAA2PAAANj4AADc8AAA3PgAAODwAADg+AAA5PAAAOT4AADEwPAAxMD4AMTE8ADExPgAxMjwAMTI+ADEzPAAxMz4AMTQ8ADE0PgAxNTwAMTU+AEFsbG93IG5vbiBrZXlwYWQvRi1rZXlzIGZvciBzdGVlcixnYXMsYnJha2UAYWxsb3dfbm9ybWFsX2tleXNfZm9yX2RyaXZpbmcAAABDb250cm9sIE9wdGlvbnMALAAAACUuMXMlZAAAPwA/ALBs1ADofNQAAACAPwAAgL8AAABAAAAAP9sPSUDbD8lAOY5jOwAAkEM5juM6ZH3UAFz9dABg/XQAZP10AGj9dABs/XQAcP10AHT9dAB4/XQAfP10AGh91ADAzFcAcM1XAKDOVwBQz1cAQNBXAHDQVwCw0FcAENFXAFDRVwCQ0VcA0NFXAEDSVwCQ0lcA0NJXAPDSVwBw01cAkNNXALDTVwDQ01cA8NNXADDUVwBQ1FcAcNRXAJDUVwCw1FcA4NRXAADVVwAQ1lcAQNdXAFDYVwCg2VcA8NlXAEDaVwCw2lcAANtXAFDbVwCg21cAENxXAHDcVwDg/XQA8P10AP//AABGRwAARkcAAP//AABwbGF5ZXJzAHNlYXNvbnMAc2Vhc29ucwBzZWFzb25zAEV2ZW50JWQAc2Vzc2lvbiVkRGF5AAAAAHNlc3Npb24lZEhvdXIAAABzZXNzaW9uJWRNaW51dGUATmFtZSBvZiB0aGUgc2Vhc29uAABuYW1lAAAAAFNlYXNvbgAAWWVhciBmb3IgdGhlIHNlYXNvbgB5ZWFyAAAAAFNlYXNvbgAATnVtYmVyIG9mIGV2ZW50cyBpbiB0aGUgc2Vhc29uAABudW1FdmVudHMAAABTZWFzb24AAERpcmVjdG9yeSBmb3IgdGhlIHRyYWNrIGRhdGEAAAAAdHJhY2tEaXJlY3RvcnkAAE5hbWUgb2YgdGhlIGV2ZW50AAAAbmFtZQAAAABTaG9ydCBOYW1lIG9mIHRoZSBldmVudABzaG9ydG5hbWUAAABBcnR3b3JrIGZpbGVuYW1lIG9mIHRoZSBldmVudCAoKi5zdHApAAAAZXZlbnRBcnR3b3JrAAAAAE1vbnRoIG9mIHRoZSBldmVudCBbMS0xMl0AAABtb250aAAAAERheSBvZiB0aGUgZXZlbnQgWzEtMzFdAGRheQBOdW1iZXIgb2YgbGFwcyBmb3IgdGhlIHJhY2Ugc2Vzc2lvbgA="},
{501376,"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAE+XEAAQAAAAEAAAAAAJ+cNUAyOMlEaoYSP6uqqj6rqqo/lnTJO2giLD8GqCJDCZQjPvJz2kTnPrs7uwaQQBcE8UAeNpE/AAAAAAAAAADxQK4/EwAWOp+cNUAyOMlEAAAAAGqGEj8AAAAAAAAAAAAAAACrqqo+q6qqP5Z0yTtoIiw/AAAAAAAAAAAAAAAABqgiQwmUIz7yc9pEAAAAAAAAAAAAAAAA5z67O7sGkEAXBPFAHjaRPwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABMAFjqWdMk7BqgiQ/Jz2kQTABY6AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="},
{1866752,"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"},
{5138176,"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAeNpE/AAAAAAAAAAAAAAAA8UCuPxMAFjqfnDVAMjjJRGqGEj+rqqo+q6qqP5Z0yTtoIiw/j9EtPM2X5DwAAAAAAAAAAFjPZD487uY+WM9kPjzu5j4AAAAAAAAAAGryBj3TQoM9BqgiQwmUIz7yc9pE5z67O7sGkEAXBPFAHjaRP/FArj8TABY6sEhvADy6dAACAAAAn5w1QDI4yUT4SG8ARLp0AAMAAABqhhI/q6qqPquqqj+WdMk7aCIsPwaoIkMJlCM+8nPaRCBIbwAgunQAAAAAAOc+uzu7BpBAFwTxQGhIbwAwunQAAQAAAB42kT/xQK4/EwAWOp+cNUAyOMlEaoYSP6uqqj6rqqo/lnTJO2giLD8GqCJDCZQjPvJz2kTnPrs7uwaQQBcE8UAeNpE/AAAAAPFArj8TABY6AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"},
{5269184,"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABqhhI/q6qqPgAAgD+rqqo/lnTJO2giLD8AAAAAAAAAAAAAAAAAAAAABqgiQwAAAAA4974AOPe+AAASAAAYAAAAUPe+AAAAAAAAAAAAAAAAAAAAAAAAAAAAaPe+AAAAAAAAAAAAAAAAAAAAAAAAAAAAgPe+AAAAAAAAAAAAAAAAAAAAAAAAAAAAmPe+AAAAAAAAAAAAAAAAAAAAAAAAAAAAsPe+AAAAAAAAAAAAAAAAAAAAAAAAAAAAyPe+AAAAAAAAAAAAAAAAAA=="},
}}
]=])
module("NR2003Cup","NR2003CupImage2",[=[
-- GENERATED by recovery/stage6_7/gen_runtime.py from NR2003.exe (original x86, Unicorn).
-- Memory image of the ORIGINAL NR2003 Cup vehicle after its own build path (part 2/2); do not edit.
return {base=7245824, size=9007104, stackTop=16248832, host=16249088, part=2, parts=2, windows={
{5286336,"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AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPQrXPgAAAAAAAAAAAAAAAAAAAAAAAIA/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAq6qqPquqqj+WdMk7AAAAAGgiLD8AAAAAAAAAAAAAAAAAAAAAkHJyAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABqgiQwAAAAAJlCM+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA8nPaRAAAAAAAAAAAAAAAAOc+uzu7BpBAFwTxQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAeNpE/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAj8L1PI/C9TwAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA8UCuP+jWbgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAYynQAZmamP2Zmpj8AABMAFjro1m4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/BTAAAAAAAAAAAAAAADo1m4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA+BTAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6NZuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADTKdAAAJPRIACT0SAAA6NZuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHDKdAAAAIA/AACAPwAA6NZuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEzKdAAAAAAAAAAAAAAA6NZuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOQUwAAAAAAAAAAAAAAA6NZuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACDKdAAAUENHAFBDRwAA6NZuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAzKdAAAAIA/AACAPwAA6NZuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADjKdAAAJPRIACT0SAAAn5w1QOjWbgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD0FMAAAAAAAAAAAAAAADI4yUQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAdMhuAAMAAAAAAAAAAAAAAAAAAAAAAAAAdMhuAAMAAAAAAAAAAAAAAAAAAAAAAAAAdMhuAAMAAAAAAAAAAAAAAAAAAAAAAAAAdMhuAAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="},
{5359040,"AAAQQgAAEEIAABBCAAAQQgQAAAAEAAAABAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAQAAAAEAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAWIvHAFiLxzCEIMcwhCDHAAAAAAAAAAAAAAAAAAAAAEoMAj1KDAI9SgwCPUoMAj05+g69OfoOvQAAAAAAAAAASgwCPkkMAj6/Dhw+vw4cPqRwPT9fz5I7X88SuwQAAAAAAAAASgyCPkoMgj4AAAAAAACQQRHheUIBAAAABAAAAAAAAAAMAAAAFwAAACwAAABBAAAAfwAAAAAAAAAAAAAAAAAAAAAAoEEAAAAAAAAAAAAAAAAAAACAAAAAgMe4Mj3HuDI9QQAAAEEAAAAAABBCAAAQQgAAEEIAABBCpa+TQ6Wvk0Olr5NDpa+TQ6Wvk0Olr5NDpa+TQ6Wvk0Olr5NDpa+TQ6Wvk0Olr5NDAAAAAAAAAAAAAAAAAAAAABxCkEBmHbBBeti5Qq4UzEOuFMxDKwnMQysJzENs+WBFgBA/xwDAwUUEAAAAxE4swAAAAACIiAhA4zjOPyxkoT8AAIA/AACAPwAAgD8AAJBADQAAAAAAAAAPAAAAEgAAABcAAAAYAAAAGAAAABgAAAAMAAAAIwAAAAAAAAAgAAAAHQAAAB0AAAAYAAAAGAAAABgAAAA2AAAArkfhPq5H4T6uR+E+rkfhPq5H4T6uR+E+rkfhPq5H4T4AoADIAKAAyEArlMhAK5TI0ECpvNBAqbwAAACAAAAAgB8PyT0dD8k9tDsdPrM7HT6pE1A+qRNQPqkTUD6pE1A+AAAAgBUKCzIAAACAAAAAgAAAAIAAAACAYn6yPdWzXT/NzEw+zcxMPoHLjjyqXDE+AAAAgAAAAIAAAAAAAAAAgOSQp0PkkKdDLrKWQy6ylkMYPEs+GDxLPse6fz7Gun8+9D83MWe1PL1ntTy9JlOTvSVTk70CAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAHjaRPwEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=="},
{5363968,"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="},
{5369856,"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"},
{5410752,"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AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADIXW8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"},
{6605056,"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACrqqo+AAAAAKssO8arLDvGqyw7xqssO8arLDvGlM3ZxWx2nMXL2w3Gt232xcvbDcbUSRzG+P36xGx2nMVWlW/E+P36xPj9+sTUSRzGALAzxv0BHMVWlW/EAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAIB3YnDEd2JwxHdicMR3YnDEd2JwxNJFY8RaN1jEAGBqxO3EZsQAYGrEi6FsxADgK8RaN1jEAAD6wwDgK8QA4CvEi6FsxFaVb8TmNTjEAAD6w4AsAMmALADJgCwAyYAsAMmALADJAOYqyIAsgMjyzpnHGUrvxxnqWsaALADJj7EIx4+xCMcg6MzGGepaxhnqWsZgiMTIgCwAyZEdjMe0jQbJAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAIC0jQbJtI0GybSNBsm0jQbJtI0GyY+kLchGSYPI/eiax3z38ccaMVvGtI0GyYAgCceAIAnHrWTNxhoxW8YaMVvGPvLLyLSNBsl6B43HAJoNyfFArj8TABY6n5w1QDI4yUQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="},
{6614016,"AAAAAAAAAAAAAAAAAAAAAAAAAACWdMk7AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaCIsPwaoIkMJlCM+8nPaRAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=="},
{6627776,"4XrUP83MrD+WskS/9f9/P13Pkjpdz5K69f9/PygPkkIoD5JCKA+SQs3MrD/hetQ/zcysPwAAgL9oISK0aCEiNAAAgL+PwvU9AACAv2ghIrRoISI0AACAvwrXoz0AAIC/aCEitGghIjQAAIC/j8L1Pc3MTD2F69E+AABAQAAAQEAAAEBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAY3BCvgAAAL5jcEK+AAAAvmNwQj4AAAA+AAAAAAAAAD4AAAAAAAAAPgAAAL5jcEI+Y3BCPgAAAIBjcEK+AAAAAGNwQr4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIA/AAAAAAAAgD8="},
{7481344,"AAAAAJQX9wCAF/cAqBf3AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAVVXVQauqWkIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABs8PYAWPD2AIDw9gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABYF/cARBf3AGwX9wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABwX9wAIF/cAMBf3AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA4Bb3AMwW9wD0FvcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=="},
{7975808,"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"},
{8204032,"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AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA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"},
{8937472,"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AAAAAAAAAAABAAAAAQAAAAEAAAABAAAAhAH3AAAAAACMAfcAAAAAAAEAAAABAAAAAQAAAAEAAAAAAAAAAAAAAKwB9wAAAAAAtAH3AAAAAAABAAAAAQAAAAAAAAAAAAAAAQAAAAEAAADUAfcAAAAAANwB9wAAAAAAAAAAAAAAAAABAAAAAQAAAAEAAAABAAAA/AH3AAAAAAAEAvcAAAAAAAEAAAABAAAAAQAAAAEAAAAAAAAAAAAAACQC9wAAAAAALAL3AAAAAAABAAAAAQAAAAAAAAAAAAAAAQAAAAEAAABMAvcAAAAAAFQC9wAAAAAAAAAAAAAAAAABAAAAAQAAAAEAAAABAAAAdAL3AAAAAAB8AvcAAAAAAAEAAAABAAAAAQAAAAEAAAAAAAAAAAAAAJwC9wAAAAAApAL3AAAAAAABAAAAAQAAAAAAAAAAAAAAAQAAAAEAAADEAvcAAAAAAMwC9wAAAAAAAAAAAAAAAAABAAAAAQAAAAEAAAABAAAA7AL3AAAAAAD0AvcAAAAAAAEAAAABAAAAAQAAAAEAAAAAAAAAAAAAABQD9wAAAAAAHAP3AAAAAAABAAAAAQAAAAAAAAAAAAAAAQAAAAEAAAA8A/cAAAAAAEQD9wAAAAAAAAAAAAAAAAABAAAAAQAAAAEAAAABAAAAZAP3AAAAAABsA/cAAAAAAAEAAAABAAAAAQAAAAEAAAAAAAAAAAAAAIwD9wAAAAAAlAP3AAAAAAABAAAAAQAAAAAAAAAAAAAAAQAAAAEAAAC0A/cAAAAAALwD9wAAAAAAAAAAAAAAAAABAAAAAQAAAAEAAAABAAAA3AP3AAAAAADkA/cAAAAAAAEAAAABAAAAAQAAAAEAAAAAAAAAAAAAAAQE9wAAAAAADAT3AAAAAAABAAAAAQAAAAAAAAAAAAAAAQAAAAEAAAAsBPcAAAAAADQE9wAAAAAAAAAAAAAAAAABAAAAAQAAAAEAAAABAAAAVAT3AAAAAABcBPcAAAAAAAEAAAABAAAAAQAAAAEAAAAAAAAAAAAAAHwE9wAAAAAAhAT3AAAAAAABAAAAAQAAAAAAAAAAAAAAAQAAAAEAAACkBPcAAAAAAKwE9wAAAAAAAAAAAAAAAAABAAAAAQAAAAEAAAABAAAAzAT3AAAAAADUBPcAAAAAAAEAAAABAAAAAQAAAAEAAAAAAAAAAAAAAPQE9wAAAAAA/AT3AAAAAAABAAAAAQAAAAAAAAAAAAAAAQAAAAEAAAAcBfcAAAAAACQF9wAAAAAAAAAAAAAAAAABAAAAAQAAAAEAAAABAAAARAX3AAAAAABMBfcAAAAAAAEAAAABAAAAAQAAAAEAAAAAAAAAAAAAAGwF9wAAAAAAdAX3AAAAAAABAAAAAQAAAAAAAAAAAAAAAQAAAAEAAACUBfcAAAAAAJwF9wAAAAAAAAAAAAAAAAABAAAAAQAAAAEAAAABAAAAvAX3AAAAAADEBfcAAAAAAAEAAAABAAAAAQAAAAEAAAAAAAAAAAAAAOQF9wAAAAAA7AX3AAAAAAABAAAAAQAAAAAAAAAAAAAAAQAAAAEAAAAMBvcAAAAAABQG9wAAAAAAAAAAAAAAAAABAAAAAQAAAAEAAAABAAAANAb3AAAAAAA8BvcAAAAAAAEAAAABAAAAAQAAAAEAAAAAAAAAAAAAAFwG9wAAAAAAZAb3AAAAAAABAAAAAQAAAAAAAAAAAAAAAQAAAAEAAACEBvcAAAAAAIwG9wAAAAAAAAAAAAAAAAABAAAAAQAAAAEAAAABAAAArAb3AAAAAAC0BvcAAAAAAAEAAAABAAAAAQAAAAEAAAAAAAAAAAAAANQG9wAAAAAA3Ab3AAAAAAABAAAAAQAAAAAAAAAAAAAAAQAAAAEAAAD8BvcAAAAAAAQH9wAAAAAAAAAAAAAAAAABAAAAAQAAAAEAAAABAAAAJAf3AAAAAAAsB/cAAAAAAAEAAAABAAAAAQAAAAEAAAAAAAAAAAAAAEwH9wAAAAAAVAf3AAAAAAABAAAAAQAAAAAAAAAAAAAAAQAAAAEAAAB0B/cAAAAAAHwH9wAAAAAAAAAAAAAAAAABAAAAAQAAAAEAAAABAAAAnAf3AAAAAACkB/cAAAAAAAEAAAABAAAAAQAAAAEAAAAAAAAAAAAAAMQH9wAAAAAAzAf3AAAAAAABAAAAAQAAAAAAAAAAAAAAAQAAAAEAAADsB/cAAAAAAPQH9wAAAAAAAAAAAAAAAAABAAAAAQAAAAEAAAABAAAAFAj3AAAAAAAcCPcAAAAAAAEAAAABAAAAAQAAAAEAAAAAAAAAAAAAADwI9wAAAAAARAj3AAAAAAABAAAAAQAAAAAAAAAAAAAAAQAAAAEAAABkCPcAAAAAAGwI9wAAAAAAAAAAAAAAAAABAAAAAQAAAAEAAAABAAAAjAj3AAAAAACUCPcAAAAAAAEAAAABAAAAAQAAAAEAAAAAAAAAAAAAALQI9wAAAAAAvAj3AAAAAAABAAAAAQAAAAAAAAAAAAAAAQAAAAEAAADcCPcAAAAAAOQI9wAAAAAAAAAAAP////8AAAAAAAAAAP////8AAAAAAAAAAP////8AAAAAAAAAAP////8FAAAAsAn3AP////8wAQAAECH3AO9kqUMAAAAAAQAAAAAAAAAAAAAAAQAAAAEAAAAAAAAAYAn3AGQJ9wA4juM8AQAAAAEAAAB0CfcAeAn3ADmO4zwAAAAAAQAAAIgJ9wCMCfcAAQAAAAEAAAAAAAAAnAn3AKAJ9wB1jGI/AQAAAAEAAAAAAAAAtAn3AHSMYj8AAAAAAQAAAAEAAADICfcAAQAAAAEAAAAAAAAAAQAAANwJ9wA5jmM7AQAAAAEAAAAAAAAA8An3ADiOYzsAAAAAAQAAAAEAAAAECvcAAQAAAAEAAAAAAAAAAQAAABgK9wAAAAAAAQAAAAEAAAAAAAAALAr3AAEAAAAAAAAAAQAAAAEAAABACvcAAQAAAAEAAAAAAAAAAQAAAFQK9wAAAAAAAQAAAAEAAAAAAAAAaAr3AAEAAAAAAAAAAQAAAAEAAAB8CvcAAQAAAAEAAAAAAAAAAQAAAJAK9wAAAAAAAQAAAAEAAAAAAAAApAr3AAEAAAAAAAAAAQAAAAEAAAC4CvcAAQAAAAEAAAAAAAAAAQAAAMwK9wAAAAAAAQAAAAEAAAAAAAAA4Ar3AAEAAAAAAAAAAQAAAAEAAAD0CvcAAQAAAAEAAAAAAAAAAQAAAAgL9wAAAAAAAQAAAAEAAAAAAAAAHAv3AAEAAAAAAAAAAQAAAAEAAAAwC/cAAQAAAAEAAAAAAAAAAQAAAEQL9wAAAAAAAQAAAAEAAAAAAAAAWAv3AAEAAAAAAAAAAQAAAAEAAABsC/cAAQAAAAEAAAAAAAAAAQAAAIAL9wAAAAAAAQAAAAEAAAAAAAAAlAv3AAEAAAAAAAAAAQAAAAEAAACoC/cAAQAAAAEAAAAAAAAAAQAAALwL9wAAAAAAAQAAAAEAAAAAAAAA0Av3AAEAAAAAAAAAAQAAAAEAAADkC/cAAQAAAAEAAAAAAAAAAQAAAPgL9wAAAAAAAQAAAAEAAAAAAAAADAz3AAEAAAAAAAAAAQAAAAEAAAAgDPcAAQAAAAEAAAAAAAAAAQAAADQM9wAAAAAAAQAAAAEAAAAAAAAASAz3AAEAAAAAAAAAAQAAAAEAAABcDPcAAQAAAAEAAAAAAAAAAQAAAHAM9wAAAAAAAQAAAAEAAAAAAAAAhAz3AAEAAAAAAAAAAQAAAAEAAACYDPcAAQAAAAEAAAAAAAAAAQAAAKwM9wAAAAAAAQAAAAEAAAAAAAAAwAz3AAEAAAAAAAAAAQAAAAEAAADUDPcAAQAAAAEAAAAAAAAAAQAAAOgM9wAAAAAAAQAAAAEAAAAAAAAA/Az3AAEAAAAAAAAAAQAAAAEAAAAQDfcAAQAAAAEAAAAAAAAAAQAAACQN9wAAAAAAAQAAAAEAAAAAAAAAOA33AAEAAAAAAAAAAQAAAAEAAABMDfcAAQAAAAEAAAAAAAAAAQAAAGAN9wAAAAAAAQAAAAEAAAAAAAAAdA33AAEAAAAAAAAAAQAAAAEAAACIDfcAAQAAAAEAAAAAAAAAAQAAAJwN9wAAAAAAAQAAAAEAAAAAAAAAsA33AAEAAAAAAAAAAQAAAAEAAADEDfcAAQAAAAEAAAAAAAAAAQAAANgN9wAAAAAAAQAAAAEAAAAAAAAA7A33AAEAAAAAAAAAAQAAAAEAAAAADvcAAQAAAAEAAAAAAAAAAQAAABQO9wAAAAAAAQAAAAEAAAAAAAAAKA73AAEAAAAAAAAAAQAAAAEAAAA8DvcAAQAAAAEAAAAAAAAAAQAAAFAO9wAAAAAAAQAAAAEAAAAAAAAAZA73AAEAAAAAAAAAAQAAAAEAAAB4DvcAAQAAAAEAAAAAAAAAAQAAAIwO9wAAAAAAAQAAAAEAAAAAAAAAoA73AAEAAAAAAAAAAQAAAAEAAAC0DvcAAQAAAAEAAAAAAAAAAQAAAMgO9wAAAAAAAQAAAAEAAAAAAAAA3A73AAEAAAAAAAAAAQAAAAEAAADwDvcAAQAAAAEAAAAAAAAAAQAAAAQP9wAAAAAAAQAAAAEAAAAAAAAAGA/3AAEAAAAAAAAAAQAAAAEAAAAsD/cAAQAAAAEAAAAAAAAAAQAAAEAP9wAAAAAAAQAAAAEAAAAAAAAAVA/3AAEAAAAAAAAAAQAAAAEAAABoD/cAAQAAAAEAAAAAAAAAAQAAAHwP9wAAAAAAAQAAAAEAAAAAAAAAkA/3AAEAAAAAAAAAAQAAAAEAAACkD/cAAQAAAAEAAAAAAAAAAQAAALgP9wAAAAAAAQAAAAEAAAAAAAAAzA/3AAEAAAAAAAAAAQAAAAEAAADgD/cAAQAAAAEAAAAAAAAAAQAAAPQP9wAAAAAAAQAAAAEAAAAAAAAACBD3AAEAAAAAAAAAAQAAAAEAAAAcEPcAAQAAAAEAAAAAAAAAAQAAADAQ9wAAAAAAAQAAAAEAAAAAAAAARBD3AAEAAAAAAAAAAQAAAAEAAABYEPcAAQAAAAEAAAAAAAAAAQAAAGwQ9wAAAAAAAQAAAAEAAAAAAAAAgBD3AAEAAAAAAAAAAQAAAAEAAACUEPcAAQAAAAEAAAAAAAAAAQAAAKgQ9wAAAAAAAQAAAAEAAAAAAAAAvBD3AAEAAAAAAAAAAQAAAAEAAADQEPcAAQAAAAEAAAAAAAAAAQAAAOQQ9wAAAAAAAQAAAAEAAAAAAAAA+BD3AAEAAAAAAAAAAQAAAAEAAAAMEfcAAQAAAAEAAAAAAAAAAQAAACAR9wAAAAAAAQAAAAEAAAAAAAAANBH3AAEAAAAAAAAAAQAAAAEAAABIEfcAAQAAAAEAAAAAAAAAAQAAAFwR9wAAAAAAAQAAAAEAAAAAAAAAcBH3AAEAAAAAAAAAAQAAAAEAAACEEfcAAQAAAAEAAAAAAAAAAQAAAJgR9wAAAAAAAQAAAAEAAAAAAAAArBH3AAEAAAAAAAAAAQAAAAEAAADAEfcAAQAAAAEAAAAAAAAAAQAAANQR9wAAAAAAAQAAAAEAAAAAAAAA6BH3AAEAAAAAAAAAAQAAAAEAAAD8EfcAAQAAAAEAAAAAAAAAAQAAABAS9wAAAAAAAQAAAAEAAAAAAAAAJBL3AAEAAAAAAAAAAQAAAAEAAAA4EvcAAQAAAAEAAAAAAAAAAQAAAEwS9wAAAAAAAQAAAAEAAAAAAAAAYBL3AAEAAAAAAAAAAQAAAAEAAAB0EvcAAQAAAAEAAAAAAAAAAQAAAIgS9wAAAAAAAQAAAAEAAAAAAAAAnBL3AAEAAAAAAAAAAQAAAAEAAACwEvcAAQAAAAEAAAAAAAAAAQAAAMQS9wAAAAAAAQAAAAEAAAAAAAAA2BL3AAEAAAAAAAAAAQAAAAEAAADsEvcAAQAAAAEAAAAAAAAAAQAAAAAT9wAAAAAAAQAAAAEAAAAAAAAAFBP3AAEAAAAAAAAAAQAAAAEAAAAoE/cAAQAAAAEAAAAAAAAAAQAAADwT9wAAAAAAAQAAAAEAAAAAAAAAUBP3AAEAAAAAAAAAAQAAAAEAAABkE/cAAQAAAAEAAAAAAAAAAQAAAHgT9wAAAAAAAQAAAAEAAAAAAAAAjBP3AAEAAAAAAAAAAQAAAAEAAACgE/cAAQAAAAEAAAAAAAAAAQAAALQT9wAAAAAAAQAAAAEAAAAAAAAAyBP3AAEAAAAAAAAAAQAAAAEAAADcE/cAAQAAAAEAAAAAAAAAAQAAAPAT9wAAAAAAAQAAAAEAAAAAAAAABBT3AAEAAAAAAAAAAQAAAAEAAAAYFPcAAQAAAAEAAAAAAAAAAQAAACwU9wAAAAAAAQAAAAEAAAAAAAAAQBT3AAEAAAAAAAAAAQAAAAEAAABUFPcAAQAAAAEAAAAAAAAAAQAAAGgU9wAAAAAAAQAAAAEAAAAAAAAAfBT3AAEAAAAAAAAAAQAAAAEAAACQFPcAAQAAAAEAAAAAAAAAAQAAAKQU9wAAAAAAAQAAAAEAAAAAAAAAuBT3AAEAAAAAAAAAAQAAAAEAAADMFPcAAQAAAAEAAAAAAAAAAQAAAOAU9wAAAAAAAQAAAAEAAAAAAAAA9BT3AAEAAAAAAAAAAQAAAAEAAAAIFfcAAQAAAAEAAAApXO9BAQAAABwV9wAAAAAAAQAAAChc70EAAAAAMBX3AAEAAAAAAAAAAQAAAAEAAABEFfcAAQAAAAEAAACamZk+AQAAAFgV9wAAAAAAAQAAAJuZmT4AAAAAbBX3AAEAAAAAAAAAAQAAAAEAAACAFfcAAQAAAAEAAAAAAAAAAQAAAJQV9wAAAAAAAQAAAAEAAAAAAAAAqBX3AAEAAAAAAAAAAQAAAAEAAAC8FfcAAQAAAAEAAAAAAAAAAQAAANAV9wAAAAAAAQAAAAEAAAAAAAAA5BX3AAEAAAAAAAAAAQAAAAEAAAD4FfcAAQAAAAEAAAAAAAAAAQAAAAwW9wAAAAAAAQAAAAEAAAAAAAAAIBb3AAEAAAAAAAAAAQAAAAEAAAA0FvcAAQAAAAEAAAAAAAAAAQAAAEgW9wAAAAAAAQAAAAEAAAAAAAAAXBb3AAEAAAAAAAAAAQAAAAEAAABwFvcAAQAAAAEAAAAAAAAAAQAAAIQW9wAAAAAAAQAAAAEAAAAAAAAAmBb3AAEAAAAAAAAAAQAAAAEAAACsFvcAAQAAAAEAAAAAAAAAAQAAAMAW9wAAAAAAAQAAAAEAAAAAAAAA1Bb3AAEAAAAAALpCAQAAAAEAAADoFvcAAQAAAAEAukIAAAAAAQAAAPwW9wAAAAAAAQAAAAEAAAAAAAAAEBf3AAEAAAAPgJNDAQAAAAEAAAAkF/cAAQAAAA6Ak0MAAAAAAQAAADgX9wAAAAAAAQAAAAEAAAAAAAAATBf3AAEAAABNaKlDAQAAAAEAAABgF/cAAQAAAExoqUMAAAAAAQAAAHQX9wAAAAAAAQAAAAEAAAAAAAAAiBf3AAEAAABNaKlDAQAAAAEAAACcF/cAAQAAAExoqUMAAAAAAQAAALAX9wAAAAAAAQAAAAEAAAAAAAAAxBf3AAEAAABNaKlDAQAAAAEAAADYF/cAAQAAAExoqUMpXO9BAQAAAOwX9wAAAAAAAQAAAChc70EAAAAAABj3AAEAAADuZKlDAQAAAAEAAAAUGPcAAQAAAO9kqUOamZk+AQAAACgY9wAAAAAAAQAAAJuZmT4AAAAAPBj3AAEAAADuZKlDAQAAAAEAAABQGPcAAQAAAO9kqUMAAAAAAQAAAGQY9wAAAAAAAQAAAAEAAAAAAAAAeBj3AAEAAADuZKlDAQAAAAEAAACMGPcAAQAAAO9kqUMAAAAAAQAAAKAY9wAAAAAAAQAAAAEAAAAAAAAAtBj3AAEAAAA4juM8AQAAAAEAAADIGPcAAQAAADmO4zwAAAAAAQAAANwY9wAAAAAAAQAAAAEAAAAAAAAA8Bj3AAEAAAB1jGI/AQAAAAEAAAAEGfcAAQAAAHSMYj8AAAAAAQAAABgZ9wAAAAAAAQAAAAEAAAAAAAAALBn3AAEAAAA5jmM7AQAAAAEAAABAGfcAAQAAADiOYzsAAAAAAQAAAFQZ9wAAAAAAAQAAAAEAAAAAAAAAaBn3AAEAAAAAAAAAAQAAAAEAAAB8GfcAAQAAAAEAAAAAAAAAAQAAAJAZ9wAAAAAAAQAAAAEAAAAAAAAApBn3AAEAAAAAAAAAAQAAAAEAAAC4GfcAAQAAAAEAAAAAAAAAAQAAAMwZ9wAAAAAAAQAAAAEAAAAAAAAA4Bn3AAEAAAAPgJNDAQAAAAEAAAD0GfcAAQAAAA6Ak0MAAAAAAQAAAAga9wAAAAAAAQAAAAEAAAAAAAAAHBr3AAEAAABNaKlDAQAAAAEAAAAwGvcAAQAAAExoqUMAAAAAAQAAAEQa9wAAAAAAAQAAAAEAAAAAAAAAWBr3AAEAAABNaKlDAQAAAAEAAABsGvcAAQAAAExoqUMAAAAAAQAAAIAa9wAAAAAAAQAAAAEAAAAAAAAAlBr3AAEAAABNaKlDAQAAAAEAAACoGvcAAQAAAExoqUMAAAAAAQAAALwa9wAAAAAAAQAAAAEAAAAAAAAA0Br3AAEAAADuZKlDAQAAAAEAAADkGvcAAQAAAO9kqUMAAAAAAQAAAPga9wAAAAAAAQAAAAEAAAAAAAAADBv3AAEAAADuZKlDAQAAAAEAAAAgG/cAAQAAAO9kqUMAAAAAAQAAADQb9wAAAAAAAQAAAAEAAAAAAAAASBv3AAEAAADuZKlDAQAAAAEAAABcG/cAAQAAAO9kqUMAAAAAAQAAAHAb9wAAAAAAAQAAAAEAAAAAAAAAhBv3AAEAAAA4juM8AQAAAAEAAACYG/cAAQAAADmO4zwAAAAAAQAAAKwb9wAAAAAAAQAAAAEAAAAAAAAAwBv3AAEAAAB1jGI/AQAAAAEAAADUG/cAAQAAAHSMYj8AAAAAAQAAAOgb9wAAAAAAAQAAAAEAAAAAAAAA/Bv3AAEAAAA5jmM7AQAAAAEAAAAQHPcAAQAAADiOYzsAAAAAAQAAACQc9wAAAAAAAQAAAAEAAAAAAAAAOBz3AAEAAAAAAAAAAQAAAAEAAABMHPcAAQAAAAEAAAAAAAAAAQAAAGAc9wAAAAAAAQAAAAEAAAAAAAAAdBz3AAEAAAAAAAAAAQAAAAEAAACIHPcAAQAAAAEAAAAAAAAAAQAAAJwc9wAAAAAAAQAAAAEAAAAAAAAAsBz3AAEAAAAPgJNDAQAAAAEAAADEHPcAAQAAAA6Ak0MAAAAAAQAAANgc9wAAAAAAAQAAAAEAAAAAAAAA7Bz3AAEAAABNaKlDAQAAAAEAAAAAHfcAAQAAAExoqUMAAAAAAQAAABQd9wAAAAAAAQAAAAEAAAAAAAAAKB33AAEAAABNaKlDAQAAAAEAAAA8HfcAAQAAAExoqUMAAAAAAQAAAFAd9wAAAAAAAQAAAAEAAAAAAAAAZB33AAEAAABNaKlDAQAAAAEAAAB4HfcAAQAAAExoqUMAAAAAAQAAAIwd9wAAAAAAAQAAAAEAAAAAAAAAoB33AAEAAADuZKlDAQAAAAEAAAC0HfcAAQAAAO9kqUMAAAAAAQAAAMgd9wAAAAAAAQAAAAEAAAAAAAAA3B33AAEAAADuZKlDAQAAAAEAAADwHfcAAQAAAO9kqUMAAAAAAQAAAAQe9wAAAAAAAQAAAAEAAAAAAAAAGB73AAEAAADuZKlDAQAAAAEAAAAsHvcAAQAAAO9kqUMAAAAAAQAAAEAe9wAAAAAAAQAAAAEAAAAAAAAAVB73AAEAAAA4juM8AQAAAAEAAABoHvcAAQAAADmO4zwAAAAAAQAAAHwe9wAAAAAAAQAAAAEAAAAAAAAAkB73AAEAAAB1jGI/AQAAAAEAAACkHvcAAQAAAHSMYj8AAAAAAQAAALge9wAAAAAAAQAAAAEAAAAAAAAAzB73AAEAAAA5jmM7AQAAAAEAAADgHvcAAQAAADiOYzsAAAAAAQAAAPQe9wAAAAAAAQAAAAEAAAAAAAAACB/3AAEAAAAAAAAAAQAAAAEAAAAcH/cAAQAAAAEAAAAAAAAAAQAAADAf9wAAAAAAAQAAAAEAAAAAAAAARB/3AAEAAAAAAAAAAQAAAAEAAABYH/cAAQAAAAEAAAAAAAAAAQAAAGwf9wAAAAAAAQAAAAEAAAAAAAAAgB/3AAEAAAAPgJNDAQAAAAEAAACUH/cAAQAAAA6Ak0MAAAAAAQAAAKgf9wAAAAAAAQAAAAEAAAAAAAAAvB/3AAEAAABNaKlDAQAAAAEAAADQH/cAAQAAAExoqUMAAAAAAQAAAOQf9wAAAAAAAQAAAAEAAAAAAAAA+B/3AAEAAABNaKlDAQAAAAEAAAAMIPcAAQAAAExoqUMAAAAAAQAAACAg9wAAAAAAAQAAAAEAAAAAAAAANCD3AAEAAABNaKlDAQAAAAEAAABIIPcAAQAAAExoqUMAAAAAAQAAAFwg9wAAAAAAAQAAAAEAAAAAAAAAcCD3AAEAAADuZKlDAQAAAAEAAACEIPcAAQAAAO9kqUMAAAAAAQAAAJgg9wAAAAAAAQAAAAEAAAAAAAAArCD3AAEAAADuZKlDAQAAAAEAAADAIPcAAQAAAO9kqUMAAAAAAQAAANQg9wAAAAAAAQAAAAEAAAAAAAAA6CD3AAEAAADuZKlDAQAAAAEAAAD8IPcAAQAAAAEAAAABAAAAAQAAAAEAAAAAAQEBAAAAAAAAAAAAAAAAEwAWOgAAAAAAAAAAlnTJOwaoIkPyc9pEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACA1m4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIFp1AAEBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD/////AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgNZuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACFadQABAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD/////AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIDWbgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACVJ/cAAAAAAAAAEwAWOgAAAAAAAAAAlnTJOwaoIkPyc9pEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP////8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACA1m4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHGV1AAEBAAAAAIDWbgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD9KPcAAAAAAAAAAAAAAAAAAACA1m4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANCn3AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="},
{9002944,"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=="},
}}
]=])
module("NR2003Cup","NR2003CupJIT1",[=[
--!native
--!optimize 2
-- GENERATED NR2003 Cup vehicle runtime: translated JIT callbacks, part 1 (predictor).
-- These are the x87 callbacks NR2003.exe generates itself at car build (005b3090, mode-2 emitter),
-- translated instruction by instruction. Float32 stores round toward -inf (CW 0x077f).
-- Do not edit by hand: regenerate with recovery/stage6_7/gen_runtime.py.
return function(ctx)
local M, JIT, LKF, LKU, NB, NC = ctx.M, ctx.JIT, ctx.LKF, ctx.LKU, ctx.NB, ctx.NC
local rf, wf, ru, wu = buffer.readf32, buffer.writef32, buffer.readu32, buffer.writeu32
local abs, sqrt, sin, cos, fmod = math.abs, math.sqrt, math.sin, math.cos, math.fmod
local TINY = 2 ^ -125
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

do -- predictor (12 chunks)
  local r_eax, r_ebx, r_ecx, r_edx, r_esi, r_edi
  local function C1()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8211816)
    f1 = f1 * rf(M, 8218132)
    f1 = f1 + rf(M, 8211812)
    wfd(8214504, f1)
    wfd(8214492, f1)
    wfd(8214340, f1)
    wfd(8214328, f1)
    wfd(8214176, f1)
    wfd(8214164, f1)
    wfd(8212064, f1)
    wfd(8212052, f1)
    f1 = rf(M, 8211824)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8211820)
    wfd(8214508, f1)
    wfd(8214496, f1)
    wfd(8214344, f1)
    wfd(8214332, f1)
    wfd(8214180, f1)
    wfd(8214168, f1)
    wfd(8212068, f1)
    wfd(8212056, f1)
    f1 = rf(M, 8211832)
    f1 = f1 * rf(M, 8218132)
    f1 = f1 + rf(M, 8211828)
    wfd(8214512, f1)
    wfd(8214500, f1)
    wfd(8214348, f1)
    wfd(8214336, f1)
    wfd(8214184, f1)
    wfd(8214172, f1)
    wfd(8212072, f1)
    wfd(8212060, f1)
    f1 = rf(M, 8211852)
    f1 = f1 * rf(M, 8218140)
    f1 = f1 * rf(M, 8218136)
    wfd(8210128, f1)
    f1 = f1 * rf(M, 8211848)
    f2 = rf(M, 8211860)
    f2 = f2 * rf(M, 8218140)
    f2 = f2 * rf(M, 8218136)
    wfd(8210132, f2)
    f2 = f2 * rf(M, 8211840)
    f3 = rf(M, 8211856)
    f3 = f3 * rf(M, 8218144)
    f3 = f3 * rf(M, 8218136)
    wfd(8210136, f3)
    f3 = f3 * rf(M, 8211844)
    f2 = f2 - f3
    f1 = f1 + f2
    f1 = f1 + rf(M, 8211836)
    wfd(8210140, f1)
    f1 = f1 * f1
    f2 = rf(M, 8210136)
    f2 = f2 * rf(M, 8211848)
    f3 = rf(M, 8210128)
    f3 = f3 * rf(M, 8211844)
    f4 = rf(M, 8210132)
    f4 = f4 * rf(M, 8211836)
    f3 = f3 - f4
    f2 = f2 + f3
    f2 = f2 + rf(M, 8211840)
    wfd(8210144, f2)
    f2 = f2 * f2
    f1 = f1 + f2
    f2 = rf(M, 8210132)
    f2 = f2 * rf(M, 8211848)
    f3 = rf(M, 8210136)
    f3 = f3 * rf(M, 8211836)
    f4 = rf(M, 8210128)
    f4 = f4 * rf(M, 8211840)
    f3 = f3 - f4
    f2 = f2 + f3
    f2 = f2 + rf(M, 8211844)
    wfd(8210148, f2)
    f2 = f2 * f2
    f1 = f1 + f2
    f2 = rf(M, 8210128)
    f2 = f2 * rf(M, 8211836)
    f3 = rf(M, 8210136)
    f3 = f3 * rf(M, 8211840)
    f2 = f2 + f3
    f3 = rf(M, 8210132)
    f3 = f3 * rf(M, 8211844)
    f2 = f2 + f3
    f2 = -f2
    f2 = f2 + rf(M, 8211848)
    wfd(8210132, f2)
    f2 = f2 * f2
    f1 = f1 + f2
    f1 = sqrt(f1)
    q = fd(f1)
    if q < TINY and q > -TINY then f1 = 1 else f1 = 1 / q end
    wfd(8210136, f1)
    f1 = rf(M, 8210132)
    f1 = f1 * rf(M, 8210136)
    wfd(8212076, f1)
    f1 = f1 * rf(M, 8218148)
    wfd(8210132, f1)
    f1 = rf(M, 8212076)
    f1 = f1 * rf(M, 8210132)
    wfd(8210128, f1)
    f1 = rf(M, 8210140)
    f1 = f1 * rf(M, 8210136)
    wfd(8212080, f1)
    f1 = f1 * rf(M, 8218152)
    wfd(8210140, f1)
    f1 = rf(M, 8212080)
    f1 = f1 * rf(M, 8210140)
    f1 = f1 + rf(M, 8210128)
    f1 = f1 - rf(M, 8218156)
    wfd(8214700, f1)
    wfd(8214640, f1)
    wfd(8212404, f1)
    wfd(8212344, f1)
    wfd(8212248, f1)
    wfd(8212188, f1)
    wfd(8212128, f1)
    wfd(8212092, f1)
    f1 = rf(M, 8210144)
    f1 = f1 * rf(M, 8210136)
    wfd(8212084, f1)
    f1 = f1 * rf(M, 8210140)
    wfd(8210144, f1)
    f1 = rf(M, 8210148)
    f1 = f1 * rf(M, 8210136)
    wfd(8212088, f1)
    f1 = f1 * rf(M, 8210132)
    wfd(8210136, f1)
    f1 = rf(M, 8210144) - f1
    wfd(8214704, f1)
    wfd(8214644, f1)
    wfd(8212408, f1)
    wfd(8212348, f1)
    wfd(8212252, f1)
    wfd(8212192, f1)
    wfd(8212132, f1)
    wfd(8212096, f1)
    f1 = rf(M, 8212088)
    f1 = f1 * rf(M, 8210140)
    wfd(8210140, f1)
    f1 = rf(M, 8212084)
    f1 = f1 * rf(M, 8210132)
    wfd(8210148, f1)
    f1 = f1 + rf(M, 8210140)
    wfd(8214708, f1)
    wfd(8214648, f1)
    wfd(8214528, f1)
    wfd(8214464, f1)
    wfd(8214364, f1)
    wfd(8214300, f1)
    wfd(8214200, f1)
    wfd(8214136, f1)
    wfd(8212412, f1)
    wfd(8212352, f1)
    wfd(8212256, f1)
    wfd(8212196, f1)
    wfd(8212136, f1)
    wfd(8212100, f1)
    f1 = rf(M, 8210136)
    f1 = f1 + rf(M, 8210144)
    wfd(8214712, f1)
    wfd(8214652, f1)
    wfd(8212416, f1)
    wfd(8212356, f1)
    wfd(8212260, f1)
    wfd(8212200, f1)
    wfd(8212140, f1)
    wfd(8212104, f1)
    f1 = rf(M, 8212084)
    f1 = f1 * rf(M, 8218148)
    wfd(8210144, f1)
    f1 = rf(M, 8212084)
    f1 = f1 * rf(M, 8210144)
    f1 = f1 + rf(M, 8210128)
    f1 = f1 - rf(M, 8218160)
    wfd(8214716, f1)
    wfd(8214656, f1)
    wfd(8212420, f1)
    wfd(8212360, f1)
    wfd(8212264, f1)
    wfd(8212204, f1)
    wfd(8212144, f1)
    wfd(8212108, f1)
    f1 = rf(M, 8212088)
    f1 = f1 * rf(M, 8210144)
    wfd(8210144, f1)
    f1 = rf(M, 8212080)
    f1 = f1 * rf(M, 8210132)
    wfd(8210132, f1)
    f1 = rf(M, 8210144) - f1
    wfd(8214720, f1)
    wfd(8214660, f1)
    wfd(8214540, f1)
    wfd(8214476, f1)
    wfd(8214376, f1)
    wfd(8214312, f1)
    wfd(8214212, f1)
    wfd(8214148, f1)
    wfd(8212424, f1)
    wfd(8212364, f1)
    wfd(8212268, f1)
    wfd(8212208, f1)
    wfd(8212148, f1)
    wfd(8212112, f1)
    f1 = rf(M, 8210148)
    f1 = rf(M, 8210140) - f1
    wfd(8214724, f1)
    wfd(8214664, f1)
    wfd(8212428, f1)
    wfd(8212368, f1)
    wfd(8212272, f1)
    wfd(8212212, f1)
    wfd(8212152, f1)
    wfd(8212116, f1)
    f1 = rf(M, 8210132)
    f1 = f1 + rf(M, 8210144)
    wfd(8214728, f1)
    wfd(8214668, f1)
    wfd(8212432, f1)
    wfd(8212372, f1)
    wfd(8212276, f1)
    wfd(8212216, f1)
    wfd(8212156, f1)
    wfd(8212120, f1)
    f1 = rf(M, 8212088)
    f1 = f1 * rf(M, 8218148)
    f1 = f1 * rf(M, 8212088)
    f1 = f1 + rf(M, 8210128)
    f1 = f1 - rf(M, 8218156)
    wfd(8214732, f1)
    wfd(8214672, f1)
    wfd(8214552, f1)
    wfd(8214488, f1)
    wfd(8214388, f1)
    wfd(8214324, f1)
    wfd(8214224, f1)
    wfd(8214160, f1)
    wfd(8212436, f1)
    wfd(8212376, f1)
    wfd(8212280, f1)
    wfd(8212220, f1)
    wfd(8212160, f1)
    wfd(8212124, f1)
    f1 = rf(M, 8215124)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8215100)
    wfd(8216984, f1)
    f1 = rf(M, 8215128)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8215104)
    wfd(8216988, f1)
    f1 = rf(M, 8215132)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8215108)
    wfd(8216992, f1)
    f1 = rf(M, 8215136)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8215112)
    wfd(8210128, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8215064)
    f2 = rf(M, 8214712)
    f2 = f2 * rf(M, 8215076)
    f1 = f1 + f2
    f2 = rf(M, 8214724)
    f2 = f2 * rf(M, 8215088)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210128)
    f2 = rf(M, 8215140)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8215116)
    wfd(8210144, f2)
    f2 = rf(M, 8214700)
    f2 = f2 * rf(M, 8215068)
    f3 = rf(M, 8214712)
    f3 = f3 * rf(M, 8215080)
    f2 = f2 + f3
    f3 = rf(M, 8214724)
    f3 = f3 * rf(M, 8215092)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8215144)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8215120)
    wfd(8210132, f2)
    f2 = rf(M, 8214700)
    f2 = f2 * rf(M, 8215072)
    f3 = rf(M, 8214712)
    f3 = f3 * rf(M, 8215084)
    f2 = f2 + f3
    f3 = rf(M, 8214724)
    f3 = f3 * rf(M, 8215096)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    wfd(8216996, f1)
    f1 = rf(M, 8214704)
    f1 = f1 * rf(M, 8215064)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8215076)
    f1 = f1 + f2
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8215088)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210128)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8215068)
    f3 = rf(M, 8214716)
    f3 = f3 * rf(M, 8215080)
    f2 = f2 + f3
    f3 = rf(M, 8214728)
    f3 = f3 * rf(M, 8215092)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8215072)
    f3 = rf(M, 8214716)
    f3 = f3 * rf(M, 8215084)
    f2 = f2 + f3
    f3 = rf(M, 8214728)
    f3 = f3 * rf(M, 8215096)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    wfd(8217000, f1)
  end
  local function C2()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8214708)
    f1 = f1 * rf(M, 8215064)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8215076)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8215088)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210128)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8215068)
    f3 = rf(M, 8214720)
    f3 = f3 * rf(M, 8215080)
    f2 = f2 + f3
    f3 = rf(M, 8214732)
    f3 = f3 * rf(M, 8215092)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8215072)
    f3 = rf(M, 8214720)
    f3 = f3 * rf(M, 8215084)
    f2 = f2 + f3
    f3 = rf(M, 8214732)
    f3 = f3 * rf(M, 8215096)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    wfd(8217004, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218164)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218168)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214504)
    wfd(8212236, f1)
    wfd(8212224, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218164)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218172)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214508)
    wfd(8212240, f1)
    wfd(8212228, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218164)
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218168)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214512)
    wfd(8212244, f1)
    wfd(8212232, f1)
    f1 = rf(M, 8215256)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8215244)
    wfd(8210132, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8215160)
    f2 = rf(M, 8214712)
    f2 = f2 * rf(M, 8215172)
    f1 = f1 + f2
    f2 = rf(M, 8214724)
    f2 = f2 * rf(M, 8215184)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    f2 = rf(M, 8215260)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8215248)
    wfd(8210144, f2)
    f2 = rf(M, 8214700)
    f2 = f2 * rf(M, 8215164)
    f3 = rf(M, 8214712)
    f3 = f3 * rf(M, 8215176)
    f2 = f2 + f3
    f3 = rf(M, 8214724)
    f3 = f3 * rf(M, 8215188)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8215264)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8215252)
    wfd(8210128, f2)
    f2 = rf(M, 8214700)
    f2 = f2 * rf(M, 8215168)
    f3 = rf(M, 8214712)
    f3 = f3 * rf(M, 8215180)
    f2 = f2 + f3
    f3 = rf(M, 8214724)
    f3 = f3 * rf(M, 8215192)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    wfd(8217008, f1)
    f1 = rf(M, 8214704)
    f1 = f1 * rf(M, 8215160)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8215172)
    f1 = f1 + f2
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8215184)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8215164)
    f3 = rf(M, 8214716)
    f3 = f3 * rf(M, 8215176)
    f2 = f2 + f3
    f3 = rf(M, 8214728)
    f3 = f3 * rf(M, 8215188)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8215168)
    f3 = rf(M, 8214716)
    f3 = f3 * rf(M, 8215180)
    f2 = f2 + f3
    f3 = rf(M, 8214728)
    f3 = f3 * rf(M, 8215192)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    wfd(8217012, f1)
    f1 = rf(M, 8214708)
    f1 = f1 * rf(M, 8215160)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8215172)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8215184)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8215164)
    f3 = rf(M, 8214720)
    f3 = f3 * rf(M, 8215176)
    f2 = f2 + f3
    f3 = rf(M, 8214732)
    f3 = f3 * rf(M, 8215188)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8215168)
    f3 = rf(M, 8214720)
    f3 = f3 * rf(M, 8215180)
    f2 = f2 + f3
    f3 = rf(M, 8214732)
    f3 = f3 * rf(M, 8215192)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    wfd(8217016, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218176)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218180)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214504)
    wfd(8212392, f1)
    wfd(8212380, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218176)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218184)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214508)
    wfd(8212396, f1)
    wfd(8212384, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218176)
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218180)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214512)
    wfd(8212400, f1)
    wfd(8212388, f1)
    f1 = rf(M, 8215388)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8215364)
    wfd(8210128, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8215280)
    f2 = rf(M, 8214712)
    f2 = f2 * rf(M, 8215292)
    f1 = f1 + f2
    f2 = rf(M, 8214724)
    f2 = f2 * rf(M, 8215304)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210128)
    f2 = rf(M, 8215392)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8215368)
    wfd(8210144, f2)
    f2 = rf(M, 8214700)
    f2 = f2 * rf(M, 8215284)
    f3 = rf(M, 8214712)
    f3 = f3 * rf(M, 8215296)
    f2 = f2 + f3
    f3 = rf(M, 8214724)
    f3 = f3 * rf(M, 8215308)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8215396)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8215372)
    wfd(8210132, f2)
    f2 = rf(M, 8214700)
    f2 = f2 * rf(M, 8215288)
    f3 = rf(M, 8214712)
    f3 = f3 * rf(M, 8215300)
    f2 = f2 + f3
    f3 = rf(M, 8214724)
    f3 = f3 * rf(M, 8215312)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    wfd(8217020, f1)
    f1 = rf(M, 8214704)
    f1 = f1 * rf(M, 8215280)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8215292)
    f1 = f1 + f2
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8215304)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210128)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8215284)
    f3 = rf(M, 8214716)
    f3 = f3 * rf(M, 8215296)
    f2 = f2 + f3
    f3 = rf(M, 8214728)
    f3 = f3 * rf(M, 8215308)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8215288)
    f3 = rf(M, 8214716)
    f3 = f3 * rf(M, 8215300)
    f2 = f2 + f3
    f3 = rf(M, 8214728)
    f3 = f3 * rf(M, 8215312)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    wfd(8217024, f1)
    f1 = rf(M, 8214708)
    f1 = f1 * rf(M, 8215280)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8215292)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8215304)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210128)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8215284)
    f3 = rf(M, 8214720)
    f3 = f3 * rf(M, 8215296)
    f2 = f2 + f3
    f3 = rf(M, 8214732)
    f3 = f3 * rf(M, 8215308)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8215288)
    f3 = rf(M, 8214720)
    f3 = f3 * rf(M, 8215300)
    f2 = f2 + f3
    f3 = rf(M, 8214732)
    f3 = f3 * rf(M, 8215312)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    wfd(8217028, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8215328)
    f2 = rf(M, 8214712)
    f2 = f2 * rf(M, 8215340)
    f1 = f1 + f2
    f2 = rf(M, 8214724)
    f2 = f2 * rf(M, 8215352)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8215376)
    f2 = rf(M, 8214700)
    f2 = f2 * rf(M, 8215332)
    f3 = rf(M, 8214712)
    f3 = f3 * rf(M, 8215344)
    f2 = f2 + f3
    f3 = rf(M, 8214724)
    f3 = f3 * rf(M, 8215356)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8215380)
    f1 = f1 + f2
    f2 = rf(M, 8214700)
    f2 = f2 * rf(M, 8215336)
    f3 = rf(M, 8214712)
    f3 = f3 * rf(M, 8215348)
    f2 = f2 + f3
    f3 = rf(M, 8214724)
    f3 = f3 * rf(M, 8215360)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8215384)
    f1 = f1 + f2
    wfd(8217032, f1)
  end
  local function C3()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8214704)
    f1 = f1 * rf(M, 8215328)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8215340)
    f1 = f1 + f2
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8215352)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8215376)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8215332)
    f3 = rf(M, 8214716)
    f3 = f3 * rf(M, 8215344)
    f2 = f2 + f3
    f3 = rf(M, 8214728)
    f3 = f3 * rf(M, 8215356)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8215380)
    f1 = f1 + f2
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8215336)
    f3 = rf(M, 8214716)
    f3 = f3 * rf(M, 8215348)
    f2 = f2 + f3
    f3 = rf(M, 8214728)
    f3 = f3 * rf(M, 8215360)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8215384)
    f1 = f1 + f2
    wfd(8217036, f1)
    f1 = rf(M, 8214708)
    f1 = f1 * rf(M, 8215328)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8215340)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8215352)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8215376)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8215332)
    f3 = rf(M, 8214720)
    f3 = f3 * rf(M, 8215344)
    f2 = f2 + f3
    f3 = rf(M, 8214732)
    f3 = f3 * rf(M, 8215356)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8215380)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8215336)
    f3 = rf(M, 8214720)
    f3 = f3 * rf(M, 8215348)
    f2 = f2 + f3
    f3 = rf(M, 8214732)
    f3 = f3 * rf(M, 8215360)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8215384)
    f1 = f1 + f2
    wfd(8217040, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218188)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218192)
    f1 = f1 + f2
    wfd(8212568, f1)
    wfd(8212508, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218196)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218200)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218204)
    f1 = f1 + f2
    wfd(8212572, f1)
    wfd(8212512, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218208)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218212)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218216)
    f1 = f1 + f2
    wfd(8212576, f1)
    wfd(8212516, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218188)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218192)
    f1 = f1 + f2
    wfd(8212580, f1)
    wfd(8212520, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218196)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218200)
    f1 = f1 + f2
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218204)
    f1 = f1 + f2
    wfd(8212584, f1)
    wfd(8212524, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218208)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218212)
    f1 = f1 + f2
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218220)
    f1 = f1 + f2
    wfd(8212588, f1)
    wfd(8212528, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218188)
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218192)
    f1 = f1 + f2
    wfd(8212592, f1)
    wfd(8212532, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218196)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218200)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218204)
    f1 = f1 + f2
    wfd(8212596, f1)
    wfd(8212536, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218208)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218212)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218216)
    f1 = f1 + f2
    wfd(8212600, f1)
    wfd(8212540, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218224)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218228)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218232)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214504)
    wfd(8212544, f1)
    f1 = rf(M, 8211892)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8211888)
    wfd(8212504, f1)
    f1 = f1 * rf(M, 8212576)
    f1 = f1 + rf(M, 8212544)
    wfd(8212920, f1)
    wfd(8212908, f1)
    wfd(8212752, f1)
    wfd(8212740, f1)
    wfd(8212556, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218224)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218228)
    f1 = f1 + f2
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218236)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214508)
    wfd(8212548, f1)
    f1 = rf(M, 8212504)
    f1 = f1 * rf(M, 8212588)
    f1 = f1 + rf(M, 8212548)
    wfd(8212924, f1)
    wfd(8212912, f1)
    wfd(8212756, f1)
    wfd(8212744, f1)
    wfd(8212560, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218224)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218228)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218232)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214512)
    wfd(8212552, f1)
    f1 = rf(M, 8212504)
    f1 = f1 * rf(M, 8212600)
    f1 = f1 + rf(M, 8212552)
    wfd(8212928, f1)
    wfd(8212916, f1)
    wfd(8212760, f1)
    wfd(8212748, f1)
    wfd(8212564, f1)
    f1 = rf(M, 8215496)
    f1 = f1 * rf(M, 8218136)
    wfd(8210132, f1)
    f1 = rf(M, 8212568)
    f1 = f1 * rf(M, 8215420)
    f2 = rf(M, 8212580)
    f2 = f2 * rf(M, 8215432)
    f1 = f1 + f2
    f2 = rf(M, 8212592)
    f2 = f2 * rf(M, 8215444)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    wfd(8217048, f1)
    f1 = rf(M, 8212572)
    f1 = f1 * rf(M, 8215420)
    f2 = rf(M, 8212584)
    f2 = f2 * rf(M, 8215432)
    f1 = f1 + f2
    f2 = rf(M, 8212596)
    f2 = f2 * rf(M, 8215444)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    wfd(8217052, f1)
    f1 = rf(M, 8212576)
    f1 = f1 * rf(M, 8215420)
    f2 = rf(M, 8212588)
    f2 = f2 * rf(M, 8215432)
    f1 = f1 + f2
    f2 = rf(M, 8212600)
    f2 = f2 * rf(M, 8215444)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    wfd(8217044, f1)
    f1 = rf(M, 8212568)
    f1 = f1 * rf(M, 8218260)
    f2 = rf(M, 8212572)
    f2 = f2 * rf(M, 8218264)
    f1 = f1 + f2
    f2 = rf(M, 8212576)
    f2 = f2 * rf(M, 8218268)
    f1 = f1 + f2
    wfd(8212792, f1)
    wfd(8212712, f1)
    f1 = rf(M, 8212580)
    f1 = f1 * rf(M, 8218260)
    f2 = rf(M, 8212584)
    f2 = f2 * rf(M, 8218264)
    f1 = f1 + f2
    f2 = rf(M, 8212588)
    f2 = f2 * rf(M, 8218272)
    f1 = f1 + f2
    wfd(8212804, f1)
    wfd(8212724, f1)
    f1 = rf(M, 8212592)
    f1 = f1 * rf(M, 8218260)
    f2 = rf(M, 8212596)
    f2 = f2 * rf(M, 8218264)
    f1 = f1 + f2
    f2 = rf(M, 8212600)
    f2 = f2 * rf(M, 8218268)
    f1 = f1 + f2
    wfd(8212816, f1)
    wfd(8212736, f1)
    f1 = rf(M, 8211776)
    wfd(8212764, f1)
    f1 = cos(f1)
    wfd(8212772, f1)
    wfd(8212768, f1)
    f1 = rf(M, 8212568)
    f1 = f1 * rf(M, 8218240)
    f2 = rf(M, 8212576)
    f2 = f2 * rf(M, 8218244)
    f1 = f1 + f2
    wfd(8212704, f1)
    f1 = rf(M, 8212772)
    f1 = f1 * rf(M, 8212704)
    f2 = rf(M, 8212568)
    f2 = f2 * rf(M, 8218248)
    f3 = rf(M, 8212572)
    f3 = f3 * rf(M, 8218252)
    f2 = f2 + f3
    f3 = rf(M, 8212576)
    f3 = f3 * rf(M, 8218256)
    f2 = f2 + f3
    wfd(8212708, f2)
    f2 = rf(M, 8212764)
    f2 = sin(f2)
    wfd(8212776, f2)
    f2 = f2 * rf(M, 8212708)
    f1 = f1 + f2
    wfd(8212936, f1)
    wfd(8212872, f1)
    wfd(8212784, f1)
    f1 = rf(M, 8212580)
    f1 = f1 * rf(M, 8218240)
    f2 = rf(M, 8212588)
    f2 = f2 * rf(M, 8218244)
    f1 = f1 + f2
    wfd(8212716, f1)
    f1 = rf(M, 8212772)
    f1 = f1 * rf(M, 8212716)
    f2 = rf(M, 8212580)
    f2 = f2 * rf(M, 8218248)
    f3 = rf(M, 8212584)
    f3 = f3 * rf(M, 8218252)
    f2 = f2 + f3
    f3 = rf(M, 8212588)
    f3 = f3 * rf(M, 8218256)
    f2 = f2 + f3
    wfd(8212720, f2)
    f2 = rf(M, 8212776)
    f2 = f2 * rf(M, 8212720)
    f1 = f1 + f2
    wfd(8212948, f1)
    wfd(8212884, f1)
    wfd(8212796, f1)
  end
  local function C4()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8212592)
    f1 = f1 * rf(M, 8218240)
    f2 = rf(M, 8212600)
    f2 = f2 * rf(M, 8218244)
    f1 = f1 + f2
    wfd(8212728, f1)
    f1 = rf(M, 8212772)
    f1 = f1 * rf(M, 8212728)
    f2 = rf(M, 8212592)
    f2 = f2 * rf(M, 8218248)
    f3 = rf(M, 8212596)
    f3 = f3 * rf(M, 8218252)
    f2 = f2 + f3
    f3 = rf(M, 8212600)
    f3 = f3 * rf(M, 8218256)
    f2 = f2 + f3
    wfd(8212732, f2)
    f2 = rf(M, 8212776)
    f2 = f2 * rf(M, 8212732)
    f1 = f1 + f2
    wfd(8212960, f1)
    wfd(8212896, f1)
    wfd(8212808, f1)
    f1 = rf(M, 8215620)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8215596)
    wfd(8210132, f1)
    f1 = rf(M, 8212704)
    f1 = f1 * rf(M, 8215512)
    f2 = rf(M, 8212716)
    f2 = f2 * rf(M, 8215524)
    f1 = f1 + f2
    f2 = rf(M, 8212728)
    f2 = f2 * rf(M, 8215536)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    f2 = rf(M, 8215624)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8215600)
    wfd(8210144, f2)
    f2 = rf(M, 8212704)
    f2 = f2 * rf(M, 8215516)
    f3 = rf(M, 8212716)
    f3 = f3 * rf(M, 8215528)
    f2 = f2 + f3
    f3 = rf(M, 8212728)
    f3 = f3 * rf(M, 8215540)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8215628)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8215604)
    wfd(8210128, f2)
    f2 = rf(M, 8212704)
    f2 = f2 * rf(M, 8215520)
    f3 = rf(M, 8212716)
    f3 = f3 * rf(M, 8215532)
    f2 = f2 + f3
    f3 = rf(M, 8212728)
    f3 = f3 * rf(M, 8215544)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    wfd(8217056, f1)
    f1 = rf(M, 8212708)
    f1 = f1 * rf(M, 8215512)
    f2 = rf(M, 8212720)
    f2 = f2 * rf(M, 8215524)
    f1 = f1 + f2
    f2 = rf(M, 8212732)
    f2 = f2 * rf(M, 8215536)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    f2 = rf(M, 8212708)
    f2 = f2 * rf(M, 8215516)
    f3 = rf(M, 8212720)
    f3 = f3 * rf(M, 8215528)
    f2 = f2 + f3
    f3 = rf(M, 8212732)
    f3 = f3 * rf(M, 8215540)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8212708)
    f2 = f2 * rf(M, 8215520)
    f3 = rf(M, 8212720)
    f3 = f3 * rf(M, 8215532)
    f2 = f2 + f3
    f3 = rf(M, 8212732)
    f3 = f3 * rf(M, 8215544)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    wfd(8217060, f1)
    f1 = rf(M, 8212792)
    f1 = f1 * rf(M, 8215512)
    f2 = rf(M, 8212804)
    f2 = f2 * rf(M, 8215524)
    f1 = f1 + f2
    f2 = rf(M, 8212816)
    f2 = f2 * rf(M, 8215536)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    f2 = rf(M, 8212792)
    f2 = f2 * rf(M, 8215516)
    f3 = rf(M, 8212804)
    f3 = f3 * rf(M, 8215528)
    f2 = f2 + f3
    f3 = rf(M, 8212816)
    f3 = f3 * rf(M, 8215540)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8212792)
    f2 = f2 * rf(M, 8215520)
    f3 = rf(M, 8212804)
    f3 = f3 * rf(M, 8215532)
    f2 = f2 + f3
    f3 = rf(M, 8212816)
    f3 = f3 * rf(M, 8215544)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    wfd(8217064, f1)
    f1 = rf(M, 8212936)
    f1 = f1 * rf(M, 8215560)
    f2 = rf(M, 8212948)
    f2 = f2 * rf(M, 8215572)
    f1 = f1 + f2
    f2 = rf(M, 8212960)
    f2 = f2 * rf(M, 8215584)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8215608)
    f2 = rf(M, 8215632)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8215612)
    wfd(8210128, f2)
    f2 = rf(M, 8212936)
    f2 = f2 * rf(M, 8215564)
    f3 = rf(M, 8212948)
    f3 = f3 * rf(M, 8215576)
    f2 = f2 + f3
    f3 = rf(M, 8212960)
    f3 = f3 * rf(M, 8215588)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    f2 = rf(M, 8215636)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8215616)
    wfd(8210144, f2)
    f2 = rf(M, 8212936)
    f2 = f2 * rf(M, 8215568)
    f3 = rf(M, 8212948)
    f3 = f3 * rf(M, 8215580)
    f2 = f2 + f3
    f3 = rf(M, 8212960)
    f3 = f3 * rf(M, 8215592)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    wfd(8217068, f1)
    f1 = rf(M, 8212776)
    f1 = -f1
    wfd(8212780, f1)
    f1 = f1 * rf(M, 8212704)
    f2 = rf(M, 8212772)
    f2 = f2 * rf(M, 8212708)
    f1 = f1 + f2
    wfd(8212788, f1)
    f1 = f1 * rf(M, 8215560)
    f2 = rf(M, 8212780)
    f2 = f2 * rf(M, 8212716)
    f3 = rf(M, 8212772)
    f3 = f3 * rf(M, 8212720)
    f2 = f2 + f3
    wfd(8212800, f2)
    f2 = f2 * rf(M, 8215572)
    f1 = f1 + f2
    f2 = rf(M, 8212780)
    f2 = f2 * rf(M, 8212728)
    f3 = rf(M, 8212772)
    f3 = f3 * rf(M, 8212732)
    f2 = f2 + f3
    wfd(8212812, f2)
    f2 = f2 * rf(M, 8215584)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8215608)
    f2 = rf(M, 8212788)
    f2 = f2 * rf(M, 8215564)
    f3 = rf(M, 8212800)
    f3 = f3 * rf(M, 8215576)
    f2 = f2 + f3
    f3 = rf(M, 8212812)
    f3 = f3 * rf(M, 8215588)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    f2 = rf(M, 8212788)
    f2 = f2 * rf(M, 8215568)
    f3 = rf(M, 8212800)
    f3 = f3 * rf(M, 8215580)
    f2 = f2 + f3
    f3 = rf(M, 8212812)
    f3 = f3 * rf(M, 8215592)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    wfd(8217072, f1)
    f1 = rf(M, 8212792)
    f1 = f1 * rf(M, 8215560)
    f2 = rf(M, 8212804)
    f2 = f2 * rf(M, 8215572)
    f1 = f1 + f2
    f2 = rf(M, 8212816)
    f2 = f2 * rf(M, 8215584)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8215608)
    f2 = rf(M, 8212792)
    f2 = f2 * rf(M, 8215564)
    f3 = rf(M, 8212804)
    f3 = f3 * rf(M, 8215576)
    f2 = f2 + f3
    f3 = rf(M, 8212816)
    f3 = f3 * rf(M, 8215588)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    f2 = rf(M, 8212792)
    f2 = f2 * rf(M, 8215568)
    f3 = rf(M, 8212804)
    f3 = f3 * rf(M, 8215580)
    f2 = f2 + f3
    f3 = rf(M, 8212816)
    f3 = f3 * rf(M, 8215592)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    wfd(8217076, f1)
    f1 = rf(M, 8212788)
    f1 = f1 * rf(M, 8218276)
    f2 = rf(M, 8212792)
    f2 = f2 * rf(M, 8218280)
    f1 = f1 + f2
    wfd(8212940, f1)
    wfd(8212876, f1)
    f1 = rf(M, 8212788)
    f1 = f1 * rf(M, 8218284)
    f2 = rf(M, 8212792)
    f2 = f2 * rf(M, 8218276)
    f1 = f1 + f2
    wfd(8212944, f1)
    wfd(8212880, f1)
    f1 = rf(M, 8212800)
    f1 = f1 * rf(M, 8218276)
    f2 = rf(M, 8212804)
    f2 = f2 * rf(M, 8218280)
    f1 = f1 + f2
    wfd(8212952, f1)
    wfd(8212888, f1)
    f1 = rf(M, 8212800)
    f1 = f1 * rf(M, 8218288)
    f2 = rf(M, 8212804)
    f2 = f2 * rf(M, 8218276)
    f1 = f1 + f2
    wfd(8212956, f1)
    wfd(8212892, f1)
    f1 = rf(M, 8212812)
    f1 = f1 * rf(M, 8218276)
    f2 = rf(M, 8212816)
    f2 = f2 * rf(M, 8218280)
    f1 = f1 + f2
    wfd(8212964, f1)
    wfd(8212900, f1)
    f1 = rf(M, 8212812)
    f1 = f1 * rf(M, 8218284)
    f2 = rf(M, 8212816)
    f2 = f2 * rf(M, 8218276)
    f1 = f1 + f2
    wfd(8212968, f1)
    wfd(8212904, f1)
    f1 = rf(M, 8211908)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8211904)
    f2 = rf(M, 421232)
    f1 = fmod(f1, f2)
    wfd(8204120, f2)
    wfd(8212932, f1)
    f1 = rf(M, 8215740)
    f1 = f1 * rf(M, 8218136)
    wfd(8210144, f1)
    f1 = rf(M, 8212936)
    f1 = f1 * rf(M, 8215652)
    f2 = rf(M, 8212948)
    f2 = f2 * rf(M, 8215664)
    f1 = f1 + f2
    f2 = rf(M, 8212960)
    f2 = f2 * rf(M, 8215676)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210144)
    f2 = rf(M, 8215744)
    f2 = f2 * rf(M, 8218136)
    wfd(8210128, f2)
    f2 = rf(M, 8212936)
    f2 = f2 * rf(M, 8215656)
    f3 = rf(M, 8212948)
    f3 = f3 * rf(M, 8215668)
    f2 = f2 + f3
    f3 = rf(M, 8212960)
    f3 = f3 * rf(M, 8215680)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    f2 = rf(M, 8215748)
    f2 = f2 * rf(M, 8218136)
    wfd(8210132, f2)
    f2 = rf(M, 8212936)
    f2 = f2 * rf(M, 8215660)
    f3 = rf(M, 8212948)
    f3 = f3 * rf(M, 8215672)
    f2 = f2 + f3
    f3 = rf(M, 8212960)
    f3 = f3 * rf(M, 8215684)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    wfd(8217080, f1)
  end
  local function C5()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8212940)
    f1 = f1 * rf(M, 8215652)
    f2 = rf(M, 8212952)
    f2 = f2 * rf(M, 8215664)
    f1 = f1 + f2
    f2 = rf(M, 8212964)
    f2 = f2 * rf(M, 8215676)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210144)
    f2 = rf(M, 8212940)
    f2 = f2 * rf(M, 8215656)
    f3 = rf(M, 8212952)
    f3 = f3 * rf(M, 8215668)
    f2 = f2 + f3
    f3 = rf(M, 8212964)
    f3 = f3 * rf(M, 8215680)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    f2 = rf(M, 8212940)
    f2 = f2 * rf(M, 8215660)
    f3 = rf(M, 8212952)
    f3 = f3 * rf(M, 8215672)
    f2 = f2 + f3
    f3 = rf(M, 8212964)
    f3 = f3 * rf(M, 8215684)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    wfd(8217084, f1)
    f1 = rf(M, 8212944)
    f1 = f1 * rf(M, 8215652)
    f2 = rf(M, 8212956)
    f2 = f2 * rf(M, 8215664)
    f1 = f1 + f2
    f2 = rf(M, 8212968)
    f2 = f2 * rf(M, 8215676)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210144)
    f2 = rf(M, 8212944)
    f2 = f2 * rf(M, 8215656)
    f3 = rf(M, 8212956)
    f3 = f3 * rf(M, 8215668)
    f2 = f2 + f3
    f3 = rf(M, 8212968)
    f3 = f3 * rf(M, 8215680)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    f2 = rf(M, 8212944)
    f2 = f2 * rf(M, 8215660)
    f3 = rf(M, 8212956)
    f3 = f3 * rf(M, 8215672)
    f2 = f2 + f3
    f3 = rf(M, 8212968)
    f3 = f3 * rf(M, 8215684)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    wfd(8217088, f1)
    f1 = rf(M, 8215752)
    f1 = f1 * rf(M, 8218136)
    wfd(8210132, f1)
    f1 = rf(M, 8212936)
    f1 = f1 * rf(M, 8215700)
    f2 = rf(M, 8212948)
    f2 = f2 * rf(M, 8215712)
    f1 = f1 + f2
    f2 = rf(M, 8212960)
    f2 = f2 * rf(M, 8215724)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    f2 = rf(M, 8215756)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8215736)
    wfd(8210128, f2)
    f2 = rf(M, 8212936)
    f2 = f2 * rf(M, 8215704)
    f3 = rf(M, 8212948)
    f3 = f3 * rf(M, 8215716)
    f2 = f2 + f3
    f3 = rf(M, 8212960)
    f3 = f3 * rf(M, 8215728)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    f2 = rf(M, 8215760)
    f2 = f2 * rf(M, 8218136)
    wfd(8210144, f2)
    f2 = rf(M, 8212936)
    f2 = f2 * rf(M, 8215708)
    f3 = rf(M, 8212948)
    f3 = f3 * rf(M, 8215720)
    f2 = f2 + f3
    f3 = rf(M, 8212960)
    f3 = f3 * rf(M, 8215732)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    wfd(8217092, f1)
    f1 = rf(M, 8212940)
    f1 = f1 * rf(M, 8215700)
    f2 = rf(M, 8212952)
    f2 = f2 * rf(M, 8215712)
    f1 = f1 + f2
    f2 = rf(M, 8212964)
    f2 = f2 * rf(M, 8215724)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    f2 = rf(M, 8212940)
    f2 = f2 * rf(M, 8215704)
    f3 = rf(M, 8212952)
    f3 = f3 * rf(M, 8215716)
    f2 = f2 + f3
    f3 = rf(M, 8212964)
    f3 = f3 * rf(M, 8215728)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    f2 = rf(M, 8212940)
    f2 = f2 * rf(M, 8215708)
    f3 = rf(M, 8212952)
    f3 = f3 * rf(M, 8215720)
    f2 = f2 + f3
    f3 = rf(M, 8212964)
    f3 = f3 * rf(M, 8215732)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    wfd(8217096, f1)
    f1 = rf(M, 8212944)
    f1 = f1 * rf(M, 8215700)
    f2 = rf(M, 8212956)
    f2 = f2 * rf(M, 8215712)
    f1 = f1 + f2
    f2 = rf(M, 8212968)
    f2 = f2 * rf(M, 8215724)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    f2 = rf(M, 8212944)
    f2 = f2 * rf(M, 8215704)
    f3 = rf(M, 8212956)
    f3 = f3 * rf(M, 8215716)
    f2 = f2 + f3
    f3 = rf(M, 8212968)
    f3 = f3 * rf(M, 8215728)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    f2 = rf(M, 8212944)
    f2 = f2 * rf(M, 8215708)
    f3 = rf(M, 8212956)
    f3 = f3 * rf(M, 8215720)
    f2 = f2 + f3
    f3 = rf(M, 8212968)
    f3 = f3 * rf(M, 8215732)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    wfd(8217100, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218188)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218192)
    f1 = f1 + f2
    wfd(8213088, f1)
    wfd(8213028, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218292)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218200)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218296)
    f1 = f1 + f2
    wfd(8213092, f1)
    wfd(8213032, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218208)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218300)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218220)
    f1 = f1 + f2
    wfd(8213096, f1)
    wfd(8213036, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218188)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218192)
    f1 = f1 + f2
    wfd(8213100, f1)
    wfd(8213040, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218292)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218200)
    f1 = f1 + f2
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218296)
    f1 = f1 + f2
    wfd(8213104, f1)
    wfd(8213044, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218208)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218304)
    f1 = f1 + f2
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218220)
    f1 = f1 + f2
    wfd(8213108, f1)
    wfd(8213048, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218188)
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218192)
    f1 = f1 + f2
    wfd(8213112, f1)
    wfd(8213052, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218292)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218200)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218296)
    f1 = f1 + f2
    wfd(8213116, f1)
    wfd(8213056, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218208)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218300)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218220)
    f1 = f1 + f2
    wfd(8213120, f1)
    wfd(8213060, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218224)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218308)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218312)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214504)
    wfd(8213064, f1)
    f1 = rf(M, 8211916)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8211912)
    wfd(8213024, f1)
    f1 = f1 * rf(M, 8213096)
    f1 = f1 + rf(M, 8213064)
    wfd(8213440, f1)
    wfd(8213428, f1)
    wfd(8213272, f1)
    wfd(8213260, f1)
    wfd(8213076, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218224)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218308)
    f1 = f1 + f2
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218316)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214508)
    wfd(8213068, f1)
    f1 = rf(M, 8213024)
    f1 = f1 * rf(M, 8213108)
    f1 = f1 + rf(M, 8213068)
    wfd(8213444, f1)
    wfd(8213432, f1)
    wfd(8213276, f1)
    wfd(8213264, f1)
    wfd(8213080, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218224)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218308)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218312)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214512)
    wfd(8213072, f1)
    f1 = rf(M, 8213024)
    f1 = f1 * rf(M, 8213120)
    f1 = f1 + rf(M, 8213072)
    wfd(8213448, f1)
    wfd(8213436, f1)
    wfd(8213280, f1)
    wfd(8213268, f1)
    wfd(8213084, f1)
    f1 = rf(M, 8215860)
    f1 = f1 * rf(M, 8218136)
    wfd(8210144, f1)
  end
  local function C6()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8213088)
    f1 = f1 * rf(M, 8215784)
    f2 = rf(M, 8213100)
    f2 = f2 * rf(M, 8215796)
    f1 = f1 + f2
    f2 = rf(M, 8213112)
    f2 = f2 * rf(M, 8215808)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210144)
    wfd(8217108, f1)
    f1 = rf(M, 8213092)
    f1 = f1 * rf(M, 8215784)
    f2 = rf(M, 8213104)
    f2 = f2 * rf(M, 8215796)
    f1 = f1 + f2
    f2 = rf(M, 8213116)
    f2 = f2 * rf(M, 8215808)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210144)
    wfd(8217112, f1)
    f1 = rf(M, 8213096)
    f1 = f1 * rf(M, 8215784)
    f2 = rf(M, 8213108)
    f2 = f2 * rf(M, 8215796)
    f1 = f1 + f2
    f2 = rf(M, 8213120)
    f2 = f2 * rf(M, 8215808)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210144)
    wfd(8217104, f1)
    f1 = rf(M, 8213088)
    f1 = f1 * rf(M, 8218260)
    f2 = rf(M, 8213092)
    f2 = f2 * rf(M, 8218328)
    f1 = f1 + f2
    f2 = rf(M, 8213096)
    f2 = f2 * rf(M, 8218272)
    f1 = f1 + f2
    wfd(8213312, f1)
    wfd(8213232, f1)
    f1 = rf(M, 8213100)
    f1 = f1 * rf(M, 8218260)
    f2 = rf(M, 8213104)
    f2 = f2 * rf(M, 8218332)
    f1 = f1 + f2
    f2 = rf(M, 8213108)
    f2 = f2 * rf(M, 8218272)
    f1 = f1 + f2
    wfd(8213324, f1)
    wfd(8213244, f1)
    f1 = rf(M, 8213112)
    f1 = f1 * rf(M, 8218260)
    f2 = rf(M, 8213116)
    f2 = f2 * rf(M, 8218328)
    f1 = f1 + f2
    f2 = rf(M, 8213120)
    f2 = f2 * rf(M, 8218272)
    f1 = f1 + f2
    wfd(8213336, f1)
    wfd(8213256, f1)
    f1 = rf(M, 8211780)
    wfd(8213284, f1)
    f1 = cos(f1)
    wfd(8213292, f1)
    wfd(8213288, f1)
    f1 = rf(M, 8213088)
    f1 = f1 * rf(M, 8218240)
    f2 = rf(M, 8213096)
    f2 = f2 * rf(M, 8218244)
    f1 = f1 + f2
    wfd(8213224, f1)
    f1 = rf(M, 8213292)
    f1 = f1 * rf(M, 8213224)
    f2 = rf(M, 8213088)
    f2 = f2 * rf(M, 8218320)
    f3 = rf(M, 8213092)
    f3 = f3 * rf(M, 8218252)
    f2 = f2 + f3
    f3 = rf(M, 8213096)
    f3 = f3 * rf(M, 8218324)
    f2 = f2 + f3
    wfd(8213228, f2)
    f2 = rf(M, 8213284)
    f2 = sin(f2)
    wfd(8213296, f2)
    f2 = f2 * rf(M, 8213228)
    f1 = f1 + f2
    wfd(8213456, f1)
    wfd(8213392, f1)
    wfd(8213304, f1)
    f1 = rf(M, 8213100)
    f1 = f1 * rf(M, 8218240)
    f2 = rf(M, 8213108)
    f2 = f2 * rf(M, 8218244)
    f1 = f1 + f2
    wfd(8213236, f1)
    f1 = rf(M, 8213292)
    f1 = f1 * rf(M, 8213236)
    f2 = rf(M, 8213100)
    f2 = f2 * rf(M, 8218320)
    f3 = rf(M, 8213104)
    f3 = f3 * rf(M, 8218252)
    f2 = f2 + f3
    f3 = rf(M, 8213108)
    f3 = f3 * rf(M, 8218324)
    f2 = f2 + f3
    wfd(8213240, f2)
    f2 = rf(M, 8213296)
    f2 = f2 * rf(M, 8213240)
    f1 = f1 + f2
    wfd(8213468, f1)
    wfd(8213404, f1)
    wfd(8213316, f1)
    f1 = rf(M, 8213112)
    f1 = f1 * rf(M, 8218240)
    f2 = rf(M, 8213120)
    f2 = f2 * rf(M, 8218244)
    f1 = f1 + f2
    wfd(8213248, f1)
    f1 = rf(M, 8213292)
    f1 = f1 * rf(M, 8213248)
    f2 = rf(M, 8213112)
    f2 = f2 * rf(M, 8218320)
    f3 = rf(M, 8213116)
    f3 = f3 * rf(M, 8218252)
    f2 = f2 + f3
    f3 = rf(M, 8213120)
    f3 = f3 * rf(M, 8218324)
    f2 = f2 + f3
    wfd(8213252, f2)
    f2 = rf(M, 8213296)
    f2 = f2 * rf(M, 8213252)
    f1 = f1 + f2
    wfd(8213480, f1)
    wfd(8213416, f1)
    wfd(8213328, f1)
    f1 = rf(M, 8215984)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8215960)
    wfd(8210144, f1)
    f1 = rf(M, 8213224)
    f1 = f1 * rf(M, 8215876)
    f2 = rf(M, 8213236)
    f2 = f2 * rf(M, 8215888)
    f1 = f1 + f2
    f2 = rf(M, 8213248)
    f2 = f2 * rf(M, 8215900)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210144)
    f2 = rf(M, 8215988)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8215964)
    wfd(8210128, f2)
    f2 = rf(M, 8213224)
    f2 = f2 * rf(M, 8215880)
    f3 = rf(M, 8213236)
    f3 = f3 * rf(M, 8215892)
    f2 = f2 + f3
    f3 = rf(M, 8213248)
    f3 = f3 * rf(M, 8215904)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    f2 = rf(M, 8215992)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8215968)
    wfd(8210132, f2)
    f2 = rf(M, 8213224)
    f2 = f2 * rf(M, 8215884)
    f3 = rf(M, 8213236)
    f3 = f3 * rf(M, 8215896)
    f2 = f2 + f3
    f3 = rf(M, 8213248)
    f3 = f3 * rf(M, 8215908)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    wfd(8217116, f1)
    f1 = rf(M, 8213228)
    f1 = f1 * rf(M, 8215876)
    f2 = rf(M, 8213240)
    f2 = f2 * rf(M, 8215888)
    f1 = f1 + f2
    f2 = rf(M, 8213252)
    f2 = f2 * rf(M, 8215900)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210144)
    f2 = rf(M, 8213228)
    f2 = f2 * rf(M, 8215880)
    f3 = rf(M, 8213240)
    f3 = f3 * rf(M, 8215892)
    f2 = f2 + f3
    f3 = rf(M, 8213252)
    f3 = f3 * rf(M, 8215904)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    f2 = rf(M, 8213228)
    f2 = f2 * rf(M, 8215884)
    f3 = rf(M, 8213240)
    f3 = f3 * rf(M, 8215896)
    f2 = f2 + f3
    f3 = rf(M, 8213252)
    f3 = f3 * rf(M, 8215908)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    wfd(8217120, f1)
    f1 = rf(M, 8213312)
    f1 = f1 * rf(M, 8215876)
    f2 = rf(M, 8213324)
    f2 = f2 * rf(M, 8215888)
    f1 = f1 + f2
    f2 = rf(M, 8213336)
    f2 = f2 * rf(M, 8215900)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210144)
    f2 = rf(M, 8213312)
    f2 = f2 * rf(M, 8215880)
    f3 = rf(M, 8213324)
    f3 = f3 * rf(M, 8215892)
    f2 = f2 + f3
    f3 = rf(M, 8213336)
    f3 = f3 * rf(M, 8215904)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    f2 = rf(M, 8213312)
    f2 = f2 * rf(M, 8215884)
    f3 = rf(M, 8213324)
    f3 = f3 * rf(M, 8215896)
    f2 = f2 + f3
    f3 = rf(M, 8213336)
    f3 = f3 * rf(M, 8215908)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    wfd(8217124, f1)
    f1 = rf(M, 8213456)
    f1 = f1 * rf(M, 8215924)
    f2 = rf(M, 8213468)
    f2 = f2 * rf(M, 8215936)
    f1 = f1 + f2
    f2 = rf(M, 8213480)
    f2 = f2 * rf(M, 8215948)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8215972)
    f2 = rf(M, 8215996)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8215976)
    wfd(8210132, f2)
    f2 = rf(M, 8213456)
    f2 = f2 * rf(M, 8215928)
    f3 = rf(M, 8213468)
    f3 = f3 * rf(M, 8215940)
    f2 = f2 + f3
    f3 = rf(M, 8213480)
    f3 = f3 * rf(M, 8215952)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    f2 = rf(M, 8216000)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8215980)
    wfd(8210128, f2)
    f2 = rf(M, 8213456)
    f2 = f2 * rf(M, 8215932)
    f3 = rf(M, 8213468)
    f3 = f3 * rf(M, 8215944)
    f2 = f2 + f3
    f3 = rf(M, 8213480)
    f3 = f3 * rf(M, 8215956)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    wfd(8217128, f1)
    f1 = rf(M, 8213296)
    f1 = -f1
    wfd(8213300, f1)
    f1 = f1 * rf(M, 8213224)
    f2 = rf(M, 8213292)
    f2 = f2 * rf(M, 8213228)
    f1 = f1 + f2
    wfd(8213308, f1)
    f1 = f1 * rf(M, 8215924)
    f2 = rf(M, 8213300)
    f2 = f2 * rf(M, 8213236)
    f3 = rf(M, 8213292)
    f3 = f3 * rf(M, 8213240)
    f2 = f2 + f3
    wfd(8213320, f2)
    f2 = f2 * rf(M, 8215936)
    f1 = f1 + f2
    f2 = rf(M, 8213300)
    f2 = f2 * rf(M, 8213248)
    f3 = rf(M, 8213292)
    f3 = f3 * rf(M, 8213252)
    f2 = f2 + f3
    wfd(8213332, f2)
    f2 = f2 * rf(M, 8215948)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8215972)
    f2 = rf(M, 8213308)
    f2 = f2 * rf(M, 8215928)
    f3 = rf(M, 8213320)
    f3 = f3 * rf(M, 8215940)
    f2 = f2 + f3
    f3 = rf(M, 8213332)
    f3 = f3 * rf(M, 8215952)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    f2 = rf(M, 8213308)
    f2 = f2 * rf(M, 8215932)
    f3 = rf(M, 8213320)
    f3 = f3 * rf(M, 8215944)
    f2 = f2 + f3
    f3 = rf(M, 8213332)
    f3 = f3 * rf(M, 8215956)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    wfd(8217132, f1)
  end
  local function C7()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8213312)
    f1 = f1 * rf(M, 8215924)
    f2 = rf(M, 8213324)
    f2 = f2 * rf(M, 8215936)
    f1 = f1 + f2
    f2 = rf(M, 8213336)
    f2 = f2 * rf(M, 8215948)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8215972)
    f2 = rf(M, 8213312)
    f2 = f2 * rf(M, 8215928)
    f3 = rf(M, 8213324)
    f3 = f3 * rf(M, 8215940)
    f2 = f2 + f3
    f3 = rf(M, 8213336)
    f3 = f3 * rf(M, 8215952)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    f2 = rf(M, 8213312)
    f2 = f2 * rf(M, 8215932)
    f3 = rf(M, 8213324)
    f3 = f3 * rf(M, 8215944)
    f2 = f2 + f3
    f3 = rf(M, 8213336)
    f3 = f3 * rf(M, 8215956)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    wfd(8217136, f1)
    f1 = rf(M, 8213308)
    f1 = f1 * rf(M, 8218276)
    f2 = rf(M, 8213312)
    f2 = f2 * rf(M, 8218336)
    f1 = f1 + f2
    wfd(8213460, f1)
    wfd(8213396, f1)
    f1 = rf(M, 8213308)
    f1 = f1 * rf(M, 8218340)
    f2 = rf(M, 8213312)
    f2 = f2 * rf(M, 8218276)
    f1 = f1 + f2
    wfd(8213464, f1)
    wfd(8213400, f1)
    f1 = rf(M, 8213320)
    f1 = f1 * rf(M, 8218276)
    f2 = rf(M, 8213324)
    f2 = f2 * rf(M, 8218336)
    f1 = f1 + f2
    wfd(8213472, f1)
    wfd(8213408, f1)
    f1 = rf(M, 8213320)
    f1 = f1 * rf(M, 8218344)
    f2 = rf(M, 8213324)
    f2 = f2 * rf(M, 8218276)
    f1 = f1 + f2
    wfd(8213476, f1)
    wfd(8213412, f1)
    f1 = rf(M, 8213332)
    f1 = f1 * rf(M, 8218276)
    f2 = rf(M, 8213336)
    f2 = f2 * rf(M, 8218336)
    f1 = f1 + f2
    wfd(8213484, f1)
    wfd(8213420, f1)
    f1 = rf(M, 8213332)
    f1 = f1 * rf(M, 8218340)
    f2 = rf(M, 8213336)
    f2 = f2 * rf(M, 8218276)
    f1 = f1 + f2
    wfd(8213488, f1)
    wfd(8213424, f1)
    f1 = rf(M, 8211932)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8211928)
    f2 = rf(M, 421232)
    f1 = fmod(f1, f2)
    wfd(8204120, f2)
    wfd(8213452, f1)
    f1 = rf(M, 8216104)
    f1 = f1 * rf(M, 8218136)
    wfd(8210128, f1)
    f1 = rf(M, 8213456)
    f1 = f1 * rf(M, 8216016)
    f2 = rf(M, 8213468)
    f2 = f2 * rf(M, 8216028)
    f1 = f1 + f2
    f2 = rf(M, 8213480)
    f2 = f2 * rf(M, 8216040)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210128)
    f2 = rf(M, 8216108)
    f2 = f2 * rf(M, 8218136)
    wfd(8210132, f2)
    f2 = rf(M, 8213456)
    f2 = f2 * rf(M, 8216020)
    f3 = rf(M, 8213468)
    f3 = f3 * rf(M, 8216032)
    f2 = f2 + f3
    f3 = rf(M, 8213480)
    f3 = f3 * rf(M, 8216044)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    f2 = rf(M, 8216112)
    f2 = f2 * rf(M, 8218136)
    wfd(8210144, f2)
    f2 = rf(M, 8213456)
    f2 = f2 * rf(M, 8216024)
    f3 = rf(M, 8213468)
    f3 = f3 * rf(M, 8216036)
    f2 = f2 + f3
    f3 = rf(M, 8213480)
    f3 = f3 * rf(M, 8216048)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    wfd(8217140, f1)
    f1 = rf(M, 8213460)
    f1 = f1 * rf(M, 8216016)
    f2 = rf(M, 8213472)
    f2 = f2 * rf(M, 8216028)
    f1 = f1 + f2
    f2 = rf(M, 8213484)
    f2 = f2 * rf(M, 8216040)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210128)
    f2 = rf(M, 8213460)
    f2 = f2 * rf(M, 8216020)
    f3 = rf(M, 8213472)
    f3 = f3 * rf(M, 8216032)
    f2 = f2 + f3
    f3 = rf(M, 8213484)
    f3 = f3 * rf(M, 8216044)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    f2 = rf(M, 8213460)
    f2 = f2 * rf(M, 8216024)
    f3 = rf(M, 8213472)
    f3 = f3 * rf(M, 8216036)
    f2 = f2 + f3
    f3 = rf(M, 8213484)
    f3 = f3 * rf(M, 8216048)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    wfd(8217144, f1)
    f1 = rf(M, 8213464)
    f1 = f1 * rf(M, 8216016)
    f2 = rf(M, 8213476)
    f2 = f2 * rf(M, 8216028)
    f1 = f1 + f2
    f2 = rf(M, 8213488)
    f2 = f2 * rf(M, 8216040)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210128)
    f2 = rf(M, 8213464)
    f2 = f2 * rf(M, 8216020)
    f3 = rf(M, 8213476)
    f3 = f3 * rf(M, 8216032)
    f2 = f2 + f3
    f3 = rf(M, 8213488)
    f3 = f3 * rf(M, 8216044)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    f2 = rf(M, 8213464)
    f2 = f2 * rf(M, 8216024)
    f3 = rf(M, 8213476)
    f3 = f3 * rf(M, 8216036)
    f2 = f2 + f3
    f3 = rf(M, 8213488)
    f3 = f3 * rf(M, 8216048)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    wfd(8217148, f1)
    f1 = rf(M, 8216116)
    f1 = f1 * rf(M, 8218136)
    wfd(8210144, f1)
    f1 = rf(M, 8213456)
    f1 = f1 * rf(M, 8216064)
    f2 = rf(M, 8213468)
    f2 = f2 * rf(M, 8216076)
    f1 = f1 + f2
    f2 = rf(M, 8213480)
    f2 = f2 * rf(M, 8216088)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210144)
    f2 = rf(M, 8216120)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8216100)
    wfd(8210132, f2)
    f2 = rf(M, 8213456)
    f2 = f2 * rf(M, 8216068)
    f3 = rf(M, 8213468)
    f3 = f3 * rf(M, 8216080)
    f2 = f2 + f3
    f3 = rf(M, 8213480)
    f3 = f3 * rf(M, 8216092)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    f2 = rf(M, 8216124)
    f2 = f2 * rf(M, 8218136)
    wfd(8210128, f2)
    f2 = rf(M, 8213456)
    f2 = f2 * rf(M, 8216072)
    f3 = rf(M, 8213468)
    f3 = f3 * rf(M, 8216084)
    f2 = f2 + f3
    f3 = rf(M, 8213480)
    f3 = f3 * rf(M, 8216096)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    wfd(8217152, f1)
    f1 = rf(M, 8213460)
    f1 = f1 * rf(M, 8216064)
    f2 = rf(M, 8213472)
    f2 = f2 * rf(M, 8216076)
    f1 = f1 + f2
    f2 = rf(M, 8213484)
    f2 = f2 * rf(M, 8216088)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210144)
    f2 = rf(M, 8213460)
    f2 = f2 * rf(M, 8216068)
    f3 = rf(M, 8213472)
    f3 = f3 * rf(M, 8216080)
    f2 = f2 + f3
    f3 = rf(M, 8213484)
    f3 = f3 * rf(M, 8216092)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    f2 = rf(M, 8213460)
    f2 = f2 * rf(M, 8216072)
    f3 = rf(M, 8213472)
    f3 = f3 * rf(M, 8216084)
    f2 = f2 + f3
    f3 = rf(M, 8213484)
    f3 = f3 * rf(M, 8216096)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    wfd(8217156, f1)
    f1 = rf(M, 8213464)
    f1 = f1 * rf(M, 8216064)
    f2 = rf(M, 8213476)
    f2 = f2 * rf(M, 8216076)
    f1 = f1 + f2
    f2 = rf(M, 8213488)
    f2 = f2 * rf(M, 8216088)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210144)
    f2 = rf(M, 8213464)
    f2 = f2 * rf(M, 8216068)
    f3 = rf(M, 8213476)
    f3 = f3 * rf(M, 8216080)
    f2 = f2 + f3
    f3 = rf(M, 8213488)
    f3 = f3 * rf(M, 8216092)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    f2 = rf(M, 8213464)
    f2 = f2 * rf(M, 8216072)
    f3 = rf(M, 8213476)
    f3 = f3 * rf(M, 8216084)
    f2 = f2 + f3
    f3 = rf(M, 8213488)
    f3 = f3 * rf(M, 8216096)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    wfd(8217160, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218348)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218352)
    f1 = f1 + f2
    wfd(8213632, f1)
    wfd(8213552, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218364)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218368)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218348)
    f1 = f1 + f2
    wfd(8213560, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218348)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218352)
    f1 = f1 + f2
    wfd(8213644, f1)
    wfd(8213564, f1)
  end
  local function C8()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218364)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218372)
    f1 = f1 + f2
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218348)
    f1 = f1 + f2
    wfd(8213572, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218348)
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218352)
    f1 = f1 + f2
    wfd(8213656, f1)
    wfd(8213576, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218364)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218368)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218348)
    f1 = f1 + f2
    wfd(8213584, f1)
    f1 = rf(M, 8211952)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8211948)
    f2 = rf(M, 421232)
    f1 = fmod(f1, f2)
    wfd(8204120, f2)
    wfd(8213612, f1)
    f1 = cos(f1)
    wfd(8213620, f1)
    wfd(8213616, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218356)
    f1 = f1 + rf(M, 8214704)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218360)
    f1 = f1 + f2
    wfd(8213556, f1)
    f1 = rf(M, 8213620)
    f1 = f1 * rf(M, 8213556)
    f2 = rf(M, 8213612)
    f2 = sin(f2)
    wfd(8213624, f2)
    f2 = f2 * rf(M, 8213560)
    f1 = f1 + f2
    wfd(8213636, f1)
    f1 = rf(M, 8213624)
    f1 = -f1
    wfd(8213628, f1)
    f1 = f1 * rf(M, 8213556)
    f2 = rf(M, 8213620)
    f2 = f2 * rf(M, 8213560)
    f1 = f1 + f2
    wfd(8214032, f1)
    wfd(8213968, f1)
    wfd(8213864, f1)
    wfd(8213800, f1)
    wfd(8213640, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218356)
    f1 = f1 + rf(M, 8214716)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218360)
    f1 = f1 + f2
    wfd(8213568, f1)
    f1 = rf(M, 8213620)
    f1 = f1 * rf(M, 8213568)
    f2 = rf(M, 8213624)
    f2 = f2 * rf(M, 8213572)
    f1 = f1 + f2
    wfd(8213648, f1)
    f1 = rf(M, 8213628)
    f1 = f1 * rf(M, 8213568)
    f2 = rf(M, 8213620)
    f2 = f2 * rf(M, 8213572)
    f1 = f1 + f2
    wfd(8214044, f1)
    wfd(8213980, f1)
    wfd(8213876, f1)
    wfd(8213812, f1)
    wfd(8213652, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218356)
    f1 = f1 + rf(M, 8214728)
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218360)
    f1 = f1 + f2
    wfd(8213580, f1)
    f1 = rf(M, 8213620)
    f1 = f1 * rf(M, 8213580)
    f2 = rf(M, 8213624)
    f2 = f2 * rf(M, 8213584)
    f1 = f1 + f2
    wfd(8213660, f1)
    f1 = rf(M, 8213628)
    f1 = f1 * rf(M, 8213580)
    f2 = rf(M, 8213620)
    f2 = f2 * rf(M, 8213584)
    f1 = f1 + f2
    wfd(8214056, f1)
    wfd(8213992, f1)
    wfd(8213888, f1)
    wfd(8213824, f1)
    wfd(8213664, f1)
    f1 = rf(M, 8216248)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8216224)
    wfd(8210128, f1)
    f1 = rf(M, 8213632)
    f1 = f1 * rf(M, 8216140)
    f2 = rf(M, 8213644)
    f2 = f2 * rf(M, 8216152)
    f1 = f1 + f2
    f2 = rf(M, 8213656)
    f2 = f2 * rf(M, 8216164)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210128)
    f2 = rf(M, 8216252)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8216228)
    wfd(8210132, f2)
    f2 = rf(M, 8213632)
    f2 = f2 * rf(M, 8216144)
    f3 = rf(M, 8213644)
    f3 = f3 * rf(M, 8216156)
    f2 = f2 + f3
    f3 = rf(M, 8213656)
    f3 = f3 * rf(M, 8216168)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    f2 = rf(M, 8216256)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8216232)
    wfd(8210144, f2)
    f2 = rf(M, 8213632)
    f2 = f2 * rf(M, 8216148)
    f3 = rf(M, 8213644)
    f3 = f3 * rf(M, 8216160)
    f2 = f2 + f3
    f3 = rf(M, 8213656)
    f3 = f3 * rf(M, 8216172)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    wfd(8217164, f1)
    f1 = rf(M, 8213556)
    f1 = f1 * rf(M, 8216140)
    f2 = rf(M, 8213568)
    f2 = f2 * rf(M, 8216152)
    f1 = f1 + f2
    f2 = rf(M, 8213580)
    f2 = f2 * rf(M, 8216164)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210128)
    f2 = rf(M, 8213556)
    f2 = f2 * rf(M, 8216144)
    f3 = rf(M, 8213568)
    f3 = f3 * rf(M, 8216156)
    f2 = f2 + f3
    f3 = rf(M, 8213580)
    f3 = f3 * rf(M, 8216168)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    f2 = rf(M, 8213556)
    f2 = f2 * rf(M, 8216148)
    f3 = rf(M, 8213568)
    f3 = f3 * rf(M, 8216160)
    f2 = f2 + f3
    f3 = rf(M, 8213580)
    f3 = f3 * rf(M, 8216172)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    wfd(8217168, f1)
    f1 = rf(M, 8213560)
    f1 = f1 * rf(M, 8216140)
    f2 = rf(M, 8213572)
    f2 = f2 * rf(M, 8216152)
    f1 = f1 + f2
    f2 = rf(M, 8213584)
    f2 = f2 * rf(M, 8216164)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210128)
    f2 = rf(M, 8213560)
    f2 = f2 * rf(M, 8216144)
    f3 = rf(M, 8213572)
    f3 = f3 * rf(M, 8216156)
    f2 = f2 + f3
    f3 = rf(M, 8213584)
    f3 = f3 * rf(M, 8216168)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    f2 = rf(M, 8213560)
    f2 = f2 * rf(M, 8216148)
    f3 = rf(M, 8213572)
    f3 = f3 * rf(M, 8216160)
    f2 = f2 + f3
    f3 = rf(M, 8213584)
    f3 = f3 * rf(M, 8216172)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    wfd(8217172, f1)
    f1 = rf(M, 8216260)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8216236)
    wfd(8210144, f1)
    f1 = rf(M, 8213632)
    f1 = f1 * rf(M, 8216188)
    f2 = rf(M, 8213644)
    f2 = f2 * rf(M, 8216200)
    f1 = f1 + f2
    f2 = rf(M, 8213656)
    f2 = f2 * rf(M, 8216212)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210144)
    f2 = rf(M, 8216264)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8216240)
    wfd(8210132, f2)
    f2 = rf(M, 8213632)
    f2 = f2 * rf(M, 8216192)
    f3 = rf(M, 8213644)
    f3 = f3 * rf(M, 8216204)
    f2 = f2 + f3
    f3 = rf(M, 8213656)
    f3 = f3 * rf(M, 8216216)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    f2 = rf(M, 8213632)
    f2 = f2 * rf(M, 8216196)
    f3 = rf(M, 8213644)
    f3 = f3 * rf(M, 8216208)
    f2 = f2 + f3
    f3 = rf(M, 8213656)
    f3 = f3 * rf(M, 8216220)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8216244)
    f1 = f1 + f2
    wfd(8217176, f1)
    f1 = rf(M, 8213636)
    f1 = f1 * rf(M, 8216188)
    f2 = rf(M, 8213648)
    f2 = f2 * rf(M, 8216200)
    f1 = f1 + f2
    f2 = rf(M, 8213660)
    f2 = f2 * rf(M, 8216212)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210144)
    f2 = rf(M, 8213636)
    f2 = f2 * rf(M, 8216192)
    f3 = rf(M, 8213648)
    f3 = f3 * rf(M, 8216204)
    f2 = f2 + f3
    f3 = rf(M, 8213660)
    f3 = f3 * rf(M, 8216216)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    f2 = rf(M, 8213636)
    f2 = f2 * rf(M, 8216196)
    f3 = rf(M, 8213648)
    f3 = f3 * rf(M, 8216208)
    f2 = f2 + f3
    f3 = rf(M, 8213660)
    f3 = f3 * rf(M, 8216220)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8216244)
    f1 = f1 + f2
    wfd(8217180, f1)
    f1 = rf(M, 8214032)
    f1 = f1 * rf(M, 8216188)
    f2 = rf(M, 8214044)
    f2 = f2 * rf(M, 8216200)
    f1 = f1 + f2
    f2 = rf(M, 8214056)
    f2 = f2 * rf(M, 8216212)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210144)
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8216192)
    f3 = rf(M, 8214044)
    f3 = f3 * rf(M, 8216204)
    f2 = f2 + f3
    f3 = rf(M, 8214056)
    f3 = f3 * rf(M, 8216216)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8216196)
    f3 = rf(M, 8214044)
    f3 = f3 * rf(M, 8216208)
    f2 = f2 + f3
    f3 = rf(M, 8214056)
    f3 = f3 * rf(M, 8216220)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8216244)
    f1 = f1 + f2
    wfd(8217184, f1)
  end
  local function C9()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8213632)
    f1 = f1 * rf(M, 8218384)
    f2 = rf(M, 8213636)
    f2 = f2 * rf(M, 8218388)
    f1 = f1 + f2
    wfd(8213856, f1)
    wfd(8213792, f1)
    f1 = rf(M, 8213632)
    f1 = f1 * rf(M, 8218392)
    f2 = rf(M, 8213636)
    f2 = f2 * rf(M, 8218384)
    f1 = f1 + f2
    wfd(8213860, f1)
    wfd(8213796, f1)
    f1 = rf(M, 8213644)
    f1 = f1 * rf(M, 8218384)
    f2 = rf(M, 8213648)
    f2 = f2 * rf(M, 8218388)
    f1 = f1 + f2
    wfd(8213868, f1)
    wfd(8213804, f1)
    f1 = rf(M, 8213644)
    f1 = f1 * rf(M, 8218396)
    f2 = rf(M, 8213648)
    f2 = f2 * rf(M, 8218384)
    f1 = f1 + f2
    wfd(8213872, f1)
    wfd(8213808, f1)
    f1 = rf(M, 8213656)
    f1 = f1 * rf(M, 8218384)
    f2 = rf(M, 8213660)
    f2 = f2 * rf(M, 8218388)
    f1 = f1 + f2
    wfd(8213880, f1)
    wfd(8213816, f1)
    f1 = rf(M, 8213656)
    f1 = f1 * rf(M, 8218392)
    f2 = rf(M, 8213660)
    f2 = f2 * rf(M, 8218384)
    f1 = f1 + f2
    wfd(8213884, f1)
    wfd(8213820, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218376)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8211936)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214504)
    wfd(8213588, f1)
    f1 = rf(M, 8211944)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8211940)
    wfd(8213548, f1)
    f1 = f1 * rf(M, 8213560)
    f1 = f1 + rf(M, 8213588)
    wfd(8213600, f1)
    f1 = rf(M, 8213636)
    f1 = f1 * rf(M, 8218228)
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8211956)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8213600)
    wfd(8213840, f1)
    wfd(8213828, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218380)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8211936)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214508)
    wfd(8213592, f1)
    f1 = rf(M, 8213548)
    f1 = f1 * rf(M, 8213572)
    f1 = f1 + rf(M, 8213592)
    wfd(8213604, f1)
    f1 = rf(M, 8213648)
    f1 = f1 * rf(M, 8218228)
    f2 = rf(M, 8214044)
    f2 = f2 * rf(M, 8211956)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8213604)
    wfd(8213844, f1)
    wfd(8213832, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218376)
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8211936)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214512)
    wfd(8213596, f1)
    f1 = rf(M, 8213548)
    f1 = f1 * rf(M, 8213584)
    f1 = f1 + rf(M, 8213596)
    wfd(8213608, f1)
    f1 = rf(M, 8213660)
    f1 = f1 * rf(M, 8218228)
    f2 = rf(M, 8214056)
    f2 = f2 * rf(M, 8211956)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8213608)
    wfd(8213848, f1)
    wfd(8213836, f1)
    f1 = rf(M, 8211964)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8211960)
    f2 = rf(M, 421232)
    f1 = fmod(f1, f2)
    wfd(8204120, f2)
    wfd(8213852, f1)
    f1 = rf(M, 8216388)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8216364)
    wfd(8210132, f1)
    f1 = rf(M, 8213856)
    f1 = f1 * rf(M, 8216280)
    f2 = rf(M, 8213868)
    f2 = f2 * rf(M, 8216292)
    f1 = f1 + f2
    f2 = rf(M, 8213880)
    f2 = f2 * rf(M, 8216304)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    f2 = rf(M, 8216392)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8216368)
    wfd(8210144, f2)
    f2 = rf(M, 8213856)
    f2 = f2 * rf(M, 8216284)
    f3 = rf(M, 8213868)
    f3 = f3 * rf(M, 8216296)
    f2 = f2 + f3
    f3 = rf(M, 8213880)
    f3 = f3 * rf(M, 8216308)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8216396)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8216372)
    wfd(8210128, f2)
    f2 = rf(M, 8213856)
    f2 = f2 * rf(M, 8216288)
    f3 = rf(M, 8213868)
    f3 = f3 * rf(M, 8216300)
    f2 = f2 + f3
    f3 = rf(M, 8213880)
    f3 = f3 * rf(M, 8216312)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    wfd(8217188, f1)
    f1 = rf(M, 8213860)
    f1 = f1 * rf(M, 8216280)
    f2 = rf(M, 8213872)
    f2 = f2 * rf(M, 8216292)
    f1 = f1 + f2
    f2 = rf(M, 8213884)
    f2 = f2 * rf(M, 8216304)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    f2 = rf(M, 8213860)
    f2 = f2 * rf(M, 8216284)
    f3 = rf(M, 8213872)
    f3 = f3 * rf(M, 8216296)
    f2 = f2 + f3
    f3 = rf(M, 8213884)
    f3 = f3 * rf(M, 8216308)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8213860)
    f2 = f2 * rf(M, 8216288)
    f3 = rf(M, 8213872)
    f3 = f3 * rf(M, 8216300)
    f2 = f2 + f3
    f3 = rf(M, 8213884)
    f3 = f3 * rf(M, 8216312)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    wfd(8217192, f1)
    f1 = rf(M, 8214032)
    f1 = f1 * rf(M, 8216280)
    f2 = rf(M, 8214044)
    f2 = f2 * rf(M, 8216292)
    f1 = f1 + f2
    f2 = rf(M, 8214056)
    f2 = f2 * rf(M, 8216304)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8216284)
    f3 = rf(M, 8214044)
    f3 = f3 * rf(M, 8216296)
    f2 = f2 + f3
    f3 = rf(M, 8214056)
    f3 = f3 * rf(M, 8216308)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8216288)
    f3 = rf(M, 8214044)
    f3 = f3 * rf(M, 8216300)
    f2 = f2 + f3
    f3 = rf(M, 8214056)
    f3 = f3 * rf(M, 8216312)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    wfd(8217196, f1)
    f1 = rf(M, 8216400)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8216376)
    wfd(8210128, f1)
    f1 = rf(M, 8213856)
    f1 = f1 * rf(M, 8216328)
    f2 = rf(M, 8213868)
    f2 = f2 * rf(M, 8216340)
    f1 = f1 + f2
    f2 = rf(M, 8213880)
    f2 = f2 * rf(M, 8216352)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210128)
    f2 = rf(M, 8216404)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8216380)
    wfd(8210144, f2)
    f2 = rf(M, 8213856)
    f2 = f2 * rf(M, 8216332)
    f3 = rf(M, 8213868)
    f3 = f3 * rf(M, 8216344)
    f2 = f2 + f3
    f3 = rf(M, 8213880)
    f3 = f3 * rf(M, 8216356)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8216408)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8216384)
    wfd(8210132, f2)
    f2 = rf(M, 8213856)
    f2 = f2 * rf(M, 8216336)
    f3 = rf(M, 8213868)
    f3 = f3 * rf(M, 8216348)
    f2 = f2 + f3
    f3 = rf(M, 8213880)
    f3 = f3 * rf(M, 8216360)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    wfd(8217200, f1)
    f1 = rf(M, 8213860)
    f1 = f1 * rf(M, 8216328)
    f2 = rf(M, 8213872)
    f2 = f2 * rf(M, 8216340)
    f1 = f1 + f2
    f2 = rf(M, 8213884)
    f2 = f2 * rf(M, 8216352)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210128)
    f2 = rf(M, 8213860)
    f2 = f2 * rf(M, 8216332)
    f3 = rf(M, 8213872)
    f3 = f3 * rf(M, 8216344)
    f2 = f2 + f3
    f3 = rf(M, 8213884)
    f3 = f3 * rf(M, 8216356)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8213860)
    f2 = f2 * rf(M, 8216336)
    f3 = rf(M, 8213872)
    f3 = f3 * rf(M, 8216348)
    f2 = f2 + f3
    f3 = rf(M, 8213884)
    f3 = f3 * rf(M, 8216360)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    wfd(8217204, f1)
    f1 = rf(M, 8214032)
    f1 = f1 * rf(M, 8216328)
    f2 = rf(M, 8214044)
    f2 = f2 * rf(M, 8216340)
    f1 = f1 + f2
    f2 = rf(M, 8214056)
    f2 = f2 * rf(M, 8216352)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210128)
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8216332)
    f3 = rf(M, 8214044)
    f3 = f3 * rf(M, 8216344)
    f2 = f2 + f3
    f3 = rf(M, 8214056)
    f3 = f3 * rf(M, 8216356)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8216336)
    f3 = rf(M, 8214044)
    f3 = f3 * rf(M, 8216348)
    f2 = f2 + f3
    f3 = rf(M, 8214056)
    f3 = f3 * rf(M, 8216360)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    wfd(8217208, f1)
  end
  local function C10()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8213632)
    f1 = f1 * rf(M, 8218384)
    f2 = rf(M, 8213636)
    f2 = f2 * rf(M, 8218400)
    f1 = f1 + f2
    wfd(8214024, f1)
    wfd(8213960, f1)
    f1 = rf(M, 8213632)
    f1 = f1 * rf(M, 8218404)
    f2 = rf(M, 8213636)
    f2 = f2 * rf(M, 8218384)
    f1 = f1 + f2
    wfd(8214028, f1)
    wfd(8213964, f1)
    f1 = rf(M, 8213644)
    f1 = f1 * rf(M, 8218384)
    f2 = rf(M, 8213648)
    f2 = f2 * rf(M, 8218400)
    f1 = f1 + f2
    wfd(8214036, f1)
    wfd(8213972, f1)
    f1 = rf(M, 8213644)
    f1 = f1 * rf(M, 8218408)
    f2 = rf(M, 8213648)
    f2 = f2 * rf(M, 8218384)
    f1 = f1 + f2
    wfd(8214040, f1)
    wfd(8213976, f1)
    f1 = rf(M, 8213656)
    f1 = f1 * rf(M, 8218384)
    f2 = rf(M, 8213660)
    f2 = f2 * rf(M, 8218400)
    f1 = f1 + f2
    wfd(8214048, f1)
    wfd(8213984, f1)
    f1 = rf(M, 8213656)
    f1 = f1 * rf(M, 8218404)
    f2 = rf(M, 8213660)
    f2 = f2 * rf(M, 8218384)
    f1 = f1 + f2
    wfd(8214052, f1)
    wfd(8213988, f1)
    f1 = rf(M, 8213636)
    f1 = f1 * rf(M, 8218308)
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8211968)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8213600)
    wfd(8214008, f1)
    wfd(8213996, f1)
    f1 = rf(M, 8213648)
    f1 = f1 * rf(M, 8218308)
    f2 = rf(M, 8214044)
    f2 = f2 * rf(M, 8211968)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8213604)
    wfd(8214012, f1)
    wfd(8214000, f1)
    f1 = rf(M, 8213660)
    f1 = f1 * rf(M, 8218308)
    f2 = rf(M, 8214056)
    f2 = f2 * rf(M, 8211968)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8213608)
    wfd(8214016, f1)
    wfd(8214004, f1)
    f1 = rf(M, 8211976)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8211972)
    f2 = rf(M, 421232)
    f1 = fmod(f1, f2)
    wfd(8204120, f2)
    wfd(8214020, f1)
    f1 = rf(M, 8216532)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8216508)
    wfd(8210132, f1)
    f1 = rf(M, 8214024)
    f1 = f1 * rf(M, 8216424)
    f2 = rf(M, 8214036)
    f2 = f2 * rf(M, 8216436)
    f1 = f1 + f2
    f2 = rf(M, 8214048)
    f2 = f2 * rf(M, 8216448)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    f2 = rf(M, 8216536)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8216512)
    wfd(8210144, f2)
    f2 = rf(M, 8214024)
    f2 = f2 * rf(M, 8216428)
    f3 = rf(M, 8214036)
    f3 = f3 * rf(M, 8216440)
    f2 = f2 + f3
    f3 = rf(M, 8214048)
    f3 = f3 * rf(M, 8216452)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8216540)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8216516)
    wfd(8210128, f2)
    f2 = rf(M, 8214024)
    f2 = f2 * rf(M, 8216432)
    f3 = rf(M, 8214036)
    f3 = f3 * rf(M, 8216444)
    f2 = f2 + f3
    f3 = rf(M, 8214048)
    f3 = f3 * rf(M, 8216456)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    wfd(8217212, f1)
    f1 = rf(M, 8214028)
    f1 = f1 * rf(M, 8216424)
    f2 = rf(M, 8214040)
    f2 = f2 * rf(M, 8216436)
    f1 = f1 + f2
    f2 = rf(M, 8214052)
    f2 = f2 * rf(M, 8216448)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    f2 = rf(M, 8214028)
    f2 = f2 * rf(M, 8216428)
    f3 = rf(M, 8214040)
    f3 = f3 * rf(M, 8216440)
    f2 = f2 + f3
    f3 = rf(M, 8214052)
    f3 = f3 * rf(M, 8216452)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8214028)
    f2 = f2 * rf(M, 8216432)
    f3 = rf(M, 8214040)
    f3 = f3 * rf(M, 8216444)
    f2 = f2 + f3
    f3 = rf(M, 8214052)
    f3 = f3 * rf(M, 8216456)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    wfd(8217216, f1)
    f1 = rf(M, 8214032)
    f1 = f1 * rf(M, 8216424)
    f2 = rf(M, 8214044)
    f2 = f2 * rf(M, 8216436)
    f1 = f1 + f2
    f2 = rf(M, 8214056)
    f2 = f2 * rf(M, 8216448)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8216428)
    f3 = rf(M, 8214044)
    f3 = f3 * rf(M, 8216440)
    f2 = f2 + f3
    f3 = rf(M, 8214056)
    f3 = f3 * rf(M, 8216452)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8216432)
    f3 = rf(M, 8214044)
    f3 = f3 * rf(M, 8216444)
    f2 = f2 + f3
    f3 = rf(M, 8214056)
    f3 = f3 * rf(M, 8216456)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    wfd(8217220, f1)
    f1 = rf(M, 8216544)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8216520)
    wfd(8210128, f1)
    f1 = rf(M, 8214024)
    f1 = f1 * rf(M, 8216472)
    f2 = rf(M, 8214036)
    f2 = f2 * rf(M, 8216484)
    f1 = f1 + f2
    f2 = rf(M, 8214048)
    f2 = f2 * rf(M, 8216496)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210128)
    f2 = rf(M, 8216548)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8216524)
    wfd(8210144, f2)
    f2 = rf(M, 8214024)
    f2 = f2 * rf(M, 8216476)
    f3 = rf(M, 8214036)
    f3 = f3 * rf(M, 8216488)
    f2 = f2 + f3
    f3 = rf(M, 8214048)
    f3 = f3 * rf(M, 8216500)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8216552)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8216528)
    wfd(8210132, f2)
    f2 = rf(M, 8214024)
    f2 = f2 * rf(M, 8216480)
    f3 = rf(M, 8214036)
    f3 = f3 * rf(M, 8216492)
    f2 = f2 + f3
    f3 = rf(M, 8214048)
    f3 = f3 * rf(M, 8216504)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    wfd(8217224, f1)
    f1 = rf(M, 8214028)
    f1 = f1 * rf(M, 8216472)
    f2 = rf(M, 8214040)
    f2 = f2 * rf(M, 8216484)
    f1 = f1 + f2
    f2 = rf(M, 8214052)
    f2 = f2 * rf(M, 8216496)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210128)
    f2 = rf(M, 8214028)
    f2 = f2 * rf(M, 8216476)
    f3 = rf(M, 8214040)
    f3 = f3 * rf(M, 8216488)
    f2 = f2 + f3
    f3 = rf(M, 8214052)
    f3 = f3 * rf(M, 8216500)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8214028)
    f2 = f2 * rf(M, 8216480)
    f3 = rf(M, 8214040)
    f3 = f3 * rf(M, 8216492)
    f2 = f2 + f3
    f3 = rf(M, 8214052)
    f3 = f3 * rf(M, 8216504)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    wfd(8217228, f1)
    f1 = rf(M, 8214032)
    f1 = f1 * rf(M, 8216472)
    f2 = rf(M, 8214044)
    f2 = f2 * rf(M, 8216484)
    f1 = f1 + f2
    f2 = rf(M, 8214056)
    f2 = f2 * rf(M, 8216496)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210128)
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8216476)
    f3 = rf(M, 8214044)
    f3 = f3 * rf(M, 8216488)
    f2 = f2 + f3
    f3 = rf(M, 8214056)
    f3 = f3 * rf(M, 8216500)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8216480)
    f3 = rf(M, 8214044)
    f3 = f3 * rf(M, 8216492)
    f2 = f2 + f3
    f3 = rf(M, 8214056)
    f3 = f3 * rf(M, 8216504)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210132)
    f1 = f1 + f2
    wfd(8217232, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218412)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218416)
    f1 = f1 + f2
    wfd(8214192, f1)
    wfd(8214128, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218420)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218412)
    f1 = f1 + f2
    wfd(8214196, f1)
    wfd(8214132, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218412)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218416)
    f1 = f1 + f2
    wfd(8214204, f1)
    wfd(8214140, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218424)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218412)
    f1 = f1 + f2
    wfd(8214208, f1)
    wfd(8214144, f1)
  end
  local function C11()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218412)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218416)
    f1 = f1 + f2
    wfd(8214216, f1)
    wfd(8214152, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218420)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218412)
    f1 = f1 + f2
    wfd(8214220, f1)
    wfd(8214156, f1)
    f1 = rf(M, 8211984)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8211980)
    f2 = rf(M, 421232)
    f1 = fmod(f1, f2)
    wfd(8204120, f2)
    wfd(8214188, f1)
    f1 = rf(M, 8216656)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8216652)
    wfd(8210132, f1)
    f1 = rf(M, 8214192)
    f1 = f1 * rf(M, 8216616)
    f2 = rf(M, 8214204)
    f2 = f2 * rf(M, 8216628)
    f1 = f1 + f2
    f2 = rf(M, 8214216)
    f2 = f2 * rf(M, 8216640)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    wfd(8217236, f1)
    f1 = rf(M, 8214196)
    f1 = f1 * rf(M, 8216616)
    f2 = rf(M, 8214208)
    f2 = f2 * rf(M, 8216628)
    f1 = f1 + f2
    f2 = rf(M, 8214220)
    f2 = f2 * rf(M, 8216640)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    wfd(8217240, f1)
    f1 = rf(M, 8214708)
    f1 = f1 * rf(M, 8216616)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8216628)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8216640)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    wfd(8217244, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218412)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218416)
    f1 = f1 + f2
    wfd(8214356, f1)
    wfd(8214292, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218420)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218412)
    f1 = f1 + f2
    wfd(8214360, f1)
    wfd(8214296, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218412)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218416)
    f1 = f1 + f2
    wfd(8214368, f1)
    wfd(8214304, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218420)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218412)
    f1 = f1 + f2
    wfd(8214372, f1)
    wfd(8214308, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218412)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218416)
    f1 = f1 + f2
    wfd(8214380, f1)
    wfd(8214316, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218420)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218412)
    f1 = f1 + f2
    wfd(8214384, f1)
    wfd(8214320, f1)
    f1 = rf(M, 8211992)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8211988)
    f2 = rf(M, 421232)
    f1 = fmod(f1, f2)
    wfd(8204120, f2)
    wfd(8214352, f1)
    f1 = rf(M, 8216760)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8216756)
    wfd(8210132, f1)
    f1 = rf(M, 8214356)
    f1 = f1 * rf(M, 8216720)
    f2 = rf(M, 8214368)
    f2 = f2 * rf(M, 8216732)
    f1 = f1 + f2
    f2 = rf(M, 8214380)
    f2 = f2 * rf(M, 8216744)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    wfd(8217248, f1)
    f1 = rf(M, 8214360)
    f1 = f1 * rf(M, 8216720)
    f2 = rf(M, 8214372)
    f2 = f2 * rf(M, 8216732)
    f1 = f1 + f2
    f2 = rf(M, 8214384)
    f2 = f2 * rf(M, 8216744)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    wfd(8217252, f1)
    f1 = rf(M, 8214708)
    f1 = f1 * rf(M, 8216720)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8216732)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8216744)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    wfd(8217256, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218412)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218416)
    f1 = f1 + f2
    wfd(8214520, f1)
    wfd(8214456, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218420)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218412)
    f1 = f1 + f2
    wfd(8214524, f1)
    wfd(8214460, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218412)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218416)
    f1 = f1 + f2
    wfd(8214532, f1)
    wfd(8214468, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218420)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218412)
    f1 = f1 + f2
    wfd(8214536, f1)
    wfd(8214472, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218412)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218416)
    f1 = f1 + f2
    wfd(8214544, f1)
    wfd(8214480, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218420)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218412)
    f1 = f1 + f2
    wfd(8214548, f1)
    wfd(8214484, f1)
    f1 = rf(M, 8212000)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8211996)
    f2 = rf(M, 421232)
    f1 = fmod(f1, f2)
    wfd(8204120, f2)
    wfd(8214516, f1)
    f1 = rf(M, 8214520)
    f1 = f1 * rf(M, 8216824)
    f2 = rf(M, 8214532)
    f2 = f2 * rf(M, 8216836)
    f1 = f1 + f2
    f2 = rf(M, 8214544)
    f2 = f2 * rf(M, 8216848)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8216860)
    wfd(8217260, f1)
    f1 = rf(M, 8214524)
    f1 = f1 * rf(M, 8216824)
    f2 = rf(M, 8214536)
    f2 = f2 * rf(M, 8216836)
    f1 = f1 + f2
    f2 = rf(M, 8214548)
    f2 = f2 * rf(M, 8216848)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8216860)
    wfd(8217264, f1)
    f1 = rf(M, 8214708)
    f1 = f1 * rf(M, 8216824)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8216836)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8216848)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8216860)
    wfd(8217268, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218428)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218432)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214504)
    wfd(8214676, f1)
    f1 = rf(M, 8212008)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8212004)
    wfd(8214628, f1)
    f1 = f1 * rf(M, 8214700)
    f2 = rf(M, 8212016)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8212012)
    wfd(8214632, f2)
    f2 = f2 * rf(M, 8214704)
    f1 = f1 + f2
    f2 = rf(M, 8212024)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8212020)
    wfd(8214636, f2)
    f2 = f2 * rf(M, 8214708)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214676)
    wfd(8214688, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218428)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218436)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214508)
    wfd(8214680, f1)
    f1 = rf(M, 8214628)
    f1 = f1 * rf(M, 8214712)
    f2 = rf(M, 8214632)
    f2 = f2 * rf(M, 8214716)
    f1 = f1 + f2
    f2 = rf(M, 8214636)
    f2 = f2 * rf(M, 8214720)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214680)
    wfd(8214692, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218428)
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218432)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214512)
    wfd(8214684, f1)
    f1 = rf(M, 8214628)
    f1 = f1 * rf(M, 8214724)
    f2 = rf(M, 8214632)
    f2 = f2 * rf(M, 8214728)
    f1 = f1 + f2
    f2 = rf(M, 8214636)
    f2 = f2 * rf(M, 8214732)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214684)
    wfd(8214696, f1)
    f1 = rf(M, 8216972)
    f1 = f1 * rf(M, 8218136)
    f1 = f1 + rf(M, 8216960)
    wfd(8210132, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8216876)
    f2 = rf(M, 8214712)
    f2 = f2 * rf(M, 8216888)
    f1 = f1 + f2
    f2 = rf(M, 8214724)
    f2 = f2 * rf(M, 8216900)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    f2 = rf(M, 8216976)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8216964)
    wfd(8210144, f2)
    f2 = rf(M, 8214700)
    f2 = f2 * rf(M, 8216880)
    f3 = rf(M, 8214712)
    f3 = f3 * rf(M, 8216892)
    f2 = f2 + f3
    f3 = rf(M, 8214724)
    f3 = f3 * rf(M, 8216904)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8216980)
    f2 = f2 * rf(M, 8218136)
    f2 = f2 + rf(M, 8216968)
    wfd(8210128, f2)
    f2 = rf(M, 8214700)
    f2 = f2 * rf(M, 8216884)
    f3 = rf(M, 8214712)
    f3 = f3 * rf(M, 8216896)
    f2 = f2 + f3
    f3 = rf(M, 8214724)
    f3 = f3 * rf(M, 8216908)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    wfd(8217272, f1)
  end
  local function C12()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8214704)
    f1 = f1 * rf(M, 8216876)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8216888)
    f1 = f1 + f2
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8216900)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8216880)
    f3 = rf(M, 8214716)
    f3 = f3 * rf(M, 8216892)
    f2 = f2 + f3
    f3 = rf(M, 8214728)
    f3 = f3 * rf(M, 8216904)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8216884)
    f3 = rf(M, 8214716)
    f3 = f3 * rf(M, 8216896)
    f2 = f2 + f3
    f3 = rf(M, 8214728)
    f3 = f3 * rf(M, 8216908)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    wfd(8217276, f1)
    f1 = rf(M, 8214708)
    f1 = f1 * rf(M, 8216876)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8216888)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8216900)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210132)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8216880)
    f3 = rf(M, 8214720)
    f3 = f3 * rf(M, 8216892)
    f2 = f2 + f3
    f3 = rf(M, 8214732)
    f3 = f3 * rf(M, 8216904)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210144)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8216884)
    f3 = rf(M, 8214720)
    f3 = f3 * rf(M, 8216896)
    f2 = f2 + f3
    f3 = rf(M, 8214732)
    f3 = f3 * rf(M, 8216908)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210128)
    f1 = f1 + f2
    wfd(8217280, f1)
  end
  JIT[0xead280] = function() -- predictor
    C1()
    C2()
    C3()
    C4()
    C5()
    C6()
    C7()
    C8()
    C9()
    C10()
    C11()
    C12()
  end
end
end
]=])
module("NR2003Cup","NR2003CupJIT2",[=[
--!native
--!optimize 2
-- GENERATED NR2003 Cup vehicle runtime: translated JIT callbacks, part 2 (solve).
-- These are the x87 callbacks NR2003.exe generates itself at car build (005b3090, mode-2 emitter),
-- translated instruction by instruction. Float32 stores round toward -inf (CW 0x077f).
-- Do not edit by hand: regenerate with recovery/stage6_7/gen_runtime.py.
return function(ctx)
local M, JIT, LKF, LKU, NB, NC = ctx.M, ctx.JIT, ctx.LKF, ctx.LKU, ctx.NB, ctx.NC
local rf, wf, ru, wu = buffer.readf32, buffer.writef32, buffer.readu32, buffer.writeu32
local abs, sqrt, sin, cos, fmod = math.abs, math.sqrt, math.sin, math.cos, math.fmod
local TINY = 2 ^ -125
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

do -- solve (12 chunks)
  local r_eax, r_ebx, r_ecx, r_edx, r_esi, r_edi
  local function C1()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    r_eax = ru(M, 8212092)
    wu(M, 8214736, r_eax)
    wu(M, 8212440, r_eax)
    wu(M, 8212284, r_eax)
    r_eax = ru(M, 8212096)
    wu(M, 8214740, r_eax)
    wu(M, 8212444, r_eax)
    wu(M, 8212288, r_eax)
    r_eax = ru(M, 8212100)
    wu(M, 8214748, r_eax)
    wu(M, 8214564, r_eax)
    wu(M, 8214400, r_eax)
    wu(M, 8214236, r_eax)
    wu(M, 8212448, r_eax)
    wu(M, 8212292, r_eax)
    r_eax = ru(M, 8212104)
    wu(M, 8214756, r_eax)
    wu(M, 8212452, r_eax)
    wu(M, 8212296, r_eax)
    r_eax = ru(M, 8212108)
    wu(M, 8214764, r_eax)
    wu(M, 8212456, r_eax)
    wu(M, 8212300, r_eax)
    r_eax = ru(M, 8212112)
    wu(M, 8214768, r_eax)
    wu(M, 8214576, r_eax)
    wu(M, 8214412, r_eax)
    wu(M, 8214248, r_eax)
    wu(M, 8212460, r_eax)
    wu(M, 8212304, r_eax)
    r_eax = ru(M, 8212116)
    wu(M, 8214776, r_eax)
    wu(M, 8212464, r_eax)
    wu(M, 8212308, r_eax)
    r_eax = ru(M, 8212120)
    wu(M, 8214784, r_eax)
    wu(M, 8212468, r_eax)
    wu(M, 8212312, r_eax)
    r_eax = ru(M, 8212124)
    wu(M, 8214792, r_eax)
    wu(M, 8214588, r_eax)
    wu(M, 8214424, r_eax)
    wu(M, 8214260, r_eax)
    wu(M, 8212472, r_eax)
    wu(M, 8212316, r_eax)
    f1 = rf(M, 8212768)
    wfd(8212972, f1)
    f1 = f1 * rf(M, 8218240)
    f2 = rf(M, 8212776)
    wfd(8212984, f2)
    f2 = f2 * rf(M, 8218248)
    f1 = f1 + f2
    wfd(8212820, f1)
    f1 = rf(M, 8212780)
    f1 = f1 * rf(M, 8218240)
    f2 = rf(M, 8212772)
    f2 = f2 * rf(M, 8218248)
    f1 = f1 + f2
    wfd(8212824, f1)
    f1 = rf(M, 8212984)
    f1 = f1 * rf(M, 8218252)
    wfd(8212828, f1)
    f1 = rf(M, 8212772)
    f1 = f1 * rf(M, 8218252)
    wfd(8212832, f1)
    f1 = rf(M, 8212972)
    f1 = f1 * rf(M, 8218244)
    f2 = rf(M, 8212984)
    f2 = f2 * rf(M, 8218256)
    f1 = f1 + f2
    wfd(8212836, f1)
    f1 = rf(M, 8212780)
    f1 = f1 * rf(M, 8218244)
    f2 = rf(M, 8212772)
    f2 = f2 * rf(M, 8218256)
    f1 = f1 + f2
    wfd(8212840, f1)
    f1 = rf(M, 8217080)
    f1 = f1 * rf(M, 8212972)
    f2 = rf(M, 8218276)
    f2 = f2 * rf(M, 8212780)
    wfd(8212976, f2)
    f2 = f2 * rf(M, 8217084)
    f1 = f1 + f2
    f2 = rf(M, 8218288)
    f2 = f2 * rf(M, 8212780)
    wfd(8212980, f2)
    f2 = f2 * rf(M, 8217088)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8217056)
    wfd(8217056, f1)
    f1 = f1 * rf(M, 8218240)
    f2 = rf(M, 8217080)
    f2 = f2 * rf(M, 8212984)
    f3 = rf(M, 8218276)
    f3 = f3 * rf(M, 8212772)
    wfd(8212988, f3)
    f3 = f3 * rf(M, 8217084)
    f2 = f2 + f3
    f3 = rf(M, 8218288)
    f3 = f3 * rf(M, 8212772)
    wfd(8212992, f3)
    f3 = f3 * rf(M, 8217088)
    f2 = f2 + f3
    f2 = f2 + rf(M, 8217060)
    wfd(8217060, f2)
    f2 = f2 * rf(M, 8218248)
    f1 = f1 + f2
    f2 = rf(M, 8217084)
    f2 = f2 * rf(M, 8218280)
    f3 = rf(M, 8217088)
    f3 = f3 * rf(M, 8218276)
    f2 = f2 + f3
    f2 = f2 + rf(M, 8217064)
    wfd(8217064, f2)
    f2 = f2 * rf(M, 8218260)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8217048)
    wfd(8217048, f1)
    f1 = rf(M, 8217060)
    f1 = f1 * rf(M, 8218252)
    f2 = rf(M, 8217064)
    f2 = f2 * rf(M, 8218264)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8217052)
    wfd(8217052, f1)
    f1 = rf(M, 8212504)
    f1 = f1 * rf(M, 8218212)
    f1 = f1 + rf(M, 8218228)
    wfd(8210128, f1)
    f1 = f1 * rf(M, 8218192)
    wfd(8212608, f1)
    f1 = rf(M, 8212504)
    f1 = f1 * rf(M, 8218220)
    f1 = f1 + rf(M, 8218236)
    wfd(8210144, f1)
    f1 = -f1
    wfd(8210132, f1)
    f1 = f1 * rf(M, 8218200)
    f2 = rf(M, 8210128)
    f2 = f2 * rf(M, 8218204)
    f1 = f1 + f2
    wfd(8212616, f1)
    f1 = rf(M, 8210132)
    f1 = f1 * rf(M, 8218212)
    f2 = rf(M, 8210128)
    f2 = f2 * rf(M, 8218220)
    f1 = f1 + f2
    wfd(8212624, f1)
    f1 = rf(M, 8210144)
    f1 = f1 * rf(M, 8218188)
    f2 = rf(M, 8212504)
    f2 = f2 * rf(M, 8218208)
    f2 = f2 + rf(M, 8218224)
    wfd(8210132, f2)
    f2 = -f2
    wfd(8210140, f2)
    f2 = f2 * rf(M, 8218192)
    f1 = f1 + f2
    wfd(8212632, f1)
    f1 = rf(M, 8210144)
    f1 = f1 * rf(M, 8218196)
    f2 = rf(M, 8210140)
    f2 = f2 * rf(M, 8218204)
    f1 = f1 + f2
    wfd(8212640, f1)
    f1 = rf(M, 8210144)
    f1 = f1 * rf(M, 8218208)
    f2 = rf(M, 8210140)
    f2 = f2 * rf(M, 8218220)
    f1 = f1 + f2
    wfd(8212648, f1)
    f1 = rf(M, 8210128)
    f1 = -f1
    wfd(8210128, f1)
    f1 = f1 * rf(M, 8218188)
    wfd(8212656, f1)
    f1 = rf(M, 8210128)
    f1 = f1 * rf(M, 8218196)
    f2 = rf(M, 8210132)
    f2 = f2 * rf(M, 8218200)
    f1 = f1 + f2
    wfd(8212664, f1)
    f1 = rf(M, 8210128)
    f1 = f1 * rf(M, 8218208)
    f2 = rf(M, 8210132)
    f2 = f2 * rf(M, 8218212)
    f1 = f1 + f2
    wfd(8212672, f1)
    f1 = rf(M, 8218188)
    f1 = f1 * rf(M, 8214736)
    f2 = rf(M, 8218192)
    f2 = f2 * rf(M, 8214748)
    f1 = f1 + f2
    wfd(8212604, f1)
    f1 = rf(M, 8218196)
    f1 = f1 * rf(M, 8214736)
    f2 = rf(M, 8218200)
    f2 = f2 * rf(M, 8214740)
    f1 = f1 + f2
    f2 = rf(M, 8218204)
    f2 = f2 * rf(M, 8214748)
    f1 = f1 + f2
    wfd(8212612, f1)
    f1 = rf(M, 8218208)
    f1 = f1 * rf(M, 8214736)
    f2 = rf(M, 8218212)
    f2 = f2 * rf(M, 8214740)
    f1 = f1 + f2
    f2 = rf(M, 8218220)
    f2 = f2 * rf(M, 8214748)
    f1 = f1 + f2
    wfd(8212620, f1)
    f1 = rf(M, 8218188)
    f1 = f1 * rf(M, 8214756)
    f2 = rf(M, 8218192)
    f2 = f2 * rf(M, 8214768)
    f1 = f1 + f2
    wfd(8212628, f1)
    f1 = rf(M, 8218196)
    f1 = f1 * rf(M, 8214756)
    f2 = rf(M, 8218200)
    f2 = f2 * rf(M, 8214764)
    f1 = f1 + f2
    f2 = rf(M, 8218204)
    f2 = f2 * rf(M, 8214768)
    f1 = f1 + f2
    wfd(8212636, f1)
    f1 = rf(M, 8218208)
    f1 = f1 * rf(M, 8214756)
    f2 = rf(M, 8218212)
    f2 = f2 * rf(M, 8214764)
    f1 = f1 + f2
    f2 = rf(M, 8218220)
    f2 = f2 * rf(M, 8214768)
    f1 = f1 + f2
    wfd(8212644, f1)
    f1 = rf(M, 8218188)
    f1 = f1 * rf(M, 8214776)
    f2 = rf(M, 8218192)
    f2 = f2 * rf(M, 8214792)
    f1 = f1 + f2
    wfd(8212652, f1)
    f1 = rf(M, 8218196)
    f1 = f1 * rf(M, 8214776)
    f2 = rf(M, 8218200)
    f2 = f2 * rf(M, 8214784)
    f1 = f1 + f2
    f2 = rf(M, 8218204)
    f2 = f2 * rf(M, 8214792)
    f1 = f1 + f2
    wfd(8212660, f1)
    f1 = rf(M, 8218208)
    f1 = f1 * rf(M, 8214776)
    f2 = rf(M, 8218212)
    f2 = f2 * rf(M, 8214784)
    f1 = f1 + f2
    f2 = rf(M, 8218220)
    f2 = f2 * rf(M, 8214792)
    f1 = f1 + f2
    wfd(8212668, f1)
    f1 = rf(M, 8212604)
    f1 = f1 * rf(M, 8218576)
    f2 = rf(M, 8212612)
    f2 = f2 * rf(M, 8218580)
    f1 = f1 + f2
    wfd(8210132, f1)
    f1 = rf(M, 8212604)
    f1 = f1 * rf(M, 8218584)
    f2 = rf(M, 8212612)
    f2 = f2 * rf(M, 8218576)
    f1 = f1 + f2
    wfd(8210128, f1)
    f1 = rf(M, 8212604)
    f1 = f1 * rf(M, 8218588)
    f2 = rf(M, 8212612)
    f2 = f2 * rf(M, 8218592)
    f1 = f1 + f2
    wfd(8210140, f1)
    f1 = rf(M, 8212628)
    f1 = f1 * rf(M, 8218576)
    f2 = rf(M, 8212636)
    f2 = f2 * rf(M, 8218580)
    f1 = f1 + f2
    wfd(8210144, f1)
    f1 = rf(M, 8212628)
    f1 = f1 * rf(M, 8218584)
    f2 = rf(M, 8212636)
    f2 = f2 * rf(M, 8218576)
    f1 = f1 + f2
    wfd(8210148, f1)
    f1 = rf(M, 8212628)
    f1 = f1 * rf(M, 8218588)
    f2 = rf(M, 8212636)
    f2 = f2 * rf(M, 8218588)
    f1 = f1 + f2
    wfd(8210136, f1)
    f1 = rf(M, 8212652)
    f1 = f1 * rf(M, 8218576)
    f2 = rf(M, 8212660)
    f2 = f2 * rf(M, 8218580)
    f1 = f1 + f2
    wfd(8210152, f1)
  end
  local function C2()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8212652)
    f1 = f1 * rf(M, 8218584)
    f2 = rf(M, 8212660)
    f2 = f2 * rf(M, 8218576)
    f1 = f1 + f2
    wfd(8210156, f1)
    f1 = rf(M, 8212652)
    f1 = f1 * rf(M, 8218588)
    f2 = rf(M, 8212660)
    f2 = f2 * rf(M, 8218588)
    f1 = f1 + f2
    wfd(8210160, f1)
    f1 = rf(M, 8212608)
    f1 = f1 * rf(M, 8218576)
    f2 = rf(M, 8212616)
    f2 = f2 * rf(M, 8218580)
    f1 = f1 + f2
    wfd(8210164, f1)
    f1 = rf(M, 8212608)
    f1 = f1 * rf(M, 8218584)
    f2 = rf(M, 8212616)
    f2 = f2 * rf(M, 8218576)
    f1 = f1 + f2
    wfd(8210168, f1)
    f1 = rf(M, 8212608)
    f1 = f1 * rf(M, 8218588)
    f2 = rf(M, 8212616)
    f2 = f2 * rf(M, 8218588)
    f1 = f1 + f2
    wfd(8210172, f1)
    f1 = rf(M, 8212632)
    f1 = f1 * rf(M, 8218576)
    f2 = rf(M, 8212640)
    f2 = f2 * rf(M, 8218580)
    f1 = f1 + f2
    wfd(8210176, f1)
    f1 = rf(M, 8212632)
    f1 = f1 * rf(M, 8218584)
    f2 = rf(M, 8212640)
    f2 = f2 * rf(M, 8218576)
    f1 = f1 + f2
    wfd(8210180, f1)
    f1 = rf(M, 8212632)
    f1 = f1 * rf(M, 8218588)
    f2 = rf(M, 8212640)
    f2 = f2 * rf(M, 8218588)
    f1 = f1 + f2
    wfd(8210184, f1)
    f1 = rf(M, 8212656)
    f1 = f1 * rf(M, 8218576)
    f2 = rf(M, 8212664)
    f2 = f2 * rf(M, 8218580)
    f1 = f1 + f2
    wfd(8210188, f1)
    f1 = rf(M, 8212656)
    f1 = f1 * rf(M, 8218584)
    f2 = rf(M, 8212664)
    f2 = f2 * rf(M, 8218576)
    f1 = f1 + f2
    wfd(8210192, f1)
    f1 = rf(M, 8212656)
    f1 = f1 * rf(M, 8218588)
    f2 = rf(M, 8212664)
    f2 = f2 * rf(M, 8218588)
    f1 = f1 + f2
    wfd(8210196, f1)
    f1 = rf(M, 8213288)
    wfd(8213492, f1)
    f1 = f1 * rf(M, 8218240)
    f2 = rf(M, 8213296)
    wfd(8213504, f2)
    f2 = f2 * rf(M, 8218320)
    f1 = f1 + f2
    wfd(8213340, f1)
    f1 = rf(M, 8213300)
    f1 = f1 * rf(M, 8218240)
    f2 = rf(M, 8213292)
    f2 = f2 * rf(M, 8218320)
    f1 = f1 + f2
    wfd(8213344, f1)
    f1 = rf(M, 8213504)
    f1 = f1 * rf(M, 8218252)
    wfd(8213348, f1)
    f1 = rf(M, 8213292)
    f1 = f1 * rf(M, 8218252)
    wfd(8213352, f1)
    f1 = rf(M, 8213492)
    f1 = f1 * rf(M, 8218244)
    f2 = rf(M, 8213504)
    f2 = f2 * rf(M, 8218324)
    f1 = f1 + f2
    wfd(8213356, f1)
    f1 = rf(M, 8213300)
    f1 = f1 * rf(M, 8218244)
    f2 = rf(M, 8213292)
    f2 = f2 * rf(M, 8218324)
    f1 = f1 + f2
    wfd(8213360, f1)
    f1 = rf(M, 8217140)
    f1 = f1 * rf(M, 8213492)
    f2 = rf(M, 8218276)
    f2 = f2 * rf(M, 8213300)
    wfd(8213496, f2)
    f2 = f2 * rf(M, 8217144)
    f1 = f1 + f2
    f2 = rf(M, 8218344)
    f2 = f2 * rf(M, 8213300)
    wfd(8213500, f2)
    f2 = f2 * rf(M, 8217148)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8217116)
    wfd(8217116, f1)
    f1 = f1 * rf(M, 8218240)
    f2 = rf(M, 8217140)
    f2 = f2 * rf(M, 8213504)
    f3 = rf(M, 8218276)
    f3 = f3 * rf(M, 8213292)
    wfd(8213508, f3)
    f3 = f3 * rf(M, 8217144)
    f2 = f2 + f3
    f3 = rf(M, 8218344)
    f3 = f3 * rf(M, 8213292)
    wfd(8213512, f3)
    f3 = f3 * rf(M, 8217148)
    f2 = f2 + f3
    f2 = f2 + rf(M, 8217120)
    wfd(8217120, f2)
    f2 = f2 * rf(M, 8218320)
    f1 = f1 + f2
    f2 = rf(M, 8217144)
    f2 = f2 * rf(M, 8218336)
    f3 = rf(M, 8217148)
    f3 = f3 * rf(M, 8218276)
    f2 = f2 + f3
    f2 = f2 + rf(M, 8217124)
    wfd(8217124, f2)
    f2 = f2 * rf(M, 8218260)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8217108)
    wfd(8217108, f1)
    f1 = rf(M, 8217120)
    f1 = f1 * rf(M, 8218252)
    f2 = rf(M, 8217124)
    f2 = f2 * rf(M, 8218332)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8217112)
    wfd(8217112, f1)
    f1 = rf(M, 8213024)
    f1 = f1 * rf(M, 8218304)
    f1 = f1 + rf(M, 8218308)
    wfd(8210200, f1)
    f1 = f1 * rf(M, 8218192)
    wfd(8213128, f1)
    f1 = rf(M, 8213024)
    f1 = f1 * rf(M, 8218220)
    f1 = f1 + rf(M, 8218316)
    wfd(8210204, f1)
    f1 = -f1
    wfd(8210208, f1)
    f1 = f1 * rf(M, 8218200)
    f2 = rf(M, 8210200)
    f2 = f2 * rf(M, 8218296)
    f1 = f1 + f2
    wfd(8213136, f1)
    f1 = rf(M, 8210208)
    f1 = f1 * rf(M, 8218304)
    f2 = rf(M, 8210200)
    f2 = f2 * rf(M, 8218220)
    f1 = f1 + f2
    wfd(8213144, f1)
    f1 = rf(M, 8210204)
    f1 = f1 * rf(M, 8218188)
    f2 = rf(M, 8213024)
    f2 = f2 * rf(M, 8218208)
    f2 = f2 + rf(M, 8218224)
    wfd(8210208, f2)
    f2 = -f2
    wfd(8210212, f2)
    f2 = f2 * rf(M, 8218192)
    f1 = f1 + f2
    wfd(8213152, f1)
    f1 = rf(M, 8210204)
    f1 = f1 * rf(M, 8218292)
    f2 = rf(M, 8210212)
    f2 = f2 * rf(M, 8218296)
    f1 = f1 + f2
    wfd(8213160, f1)
    f1 = rf(M, 8210204)
    f1 = f1 * rf(M, 8218208)
    f2 = rf(M, 8210212)
    f2 = f2 * rf(M, 8218220)
    f1 = f1 + f2
    wfd(8213168, f1)
    f1 = rf(M, 8210200)
    f1 = -f1
    wfd(8210200, f1)
    f1 = f1 * rf(M, 8218188)
    wfd(8213176, f1)
    f1 = rf(M, 8210200)
    f1 = f1 * rf(M, 8218292)
    f2 = rf(M, 8210208)
    f2 = f2 * rf(M, 8218200)
    f1 = f1 + f2
    wfd(8213184, f1)
    f1 = rf(M, 8210200)
    f1 = f1 * rf(M, 8218208)
    f2 = rf(M, 8210208)
    f2 = f2 * rf(M, 8218304)
    f1 = f1 + f2
    wfd(8213192, f1)
    f1 = rf(M, 8218188)
    f1 = f1 * rf(M, 8214736)
    f2 = rf(M, 8218192)
    f2 = f2 * rf(M, 8214748)
    f1 = f1 + f2
    wfd(8213124, f1)
    f1 = rf(M, 8218292)
    f1 = f1 * rf(M, 8214736)
    f2 = rf(M, 8218200)
    f2 = f2 * rf(M, 8214740)
    f1 = f1 + f2
    f2 = rf(M, 8218296)
    f2 = f2 * rf(M, 8214748)
    f1 = f1 + f2
    wfd(8213132, f1)
    f1 = rf(M, 8218208)
    f1 = f1 * rf(M, 8214736)
    f2 = rf(M, 8218304)
    f2 = f2 * rf(M, 8214740)
    f1 = f1 + f2
    f2 = rf(M, 8218220)
    f2 = f2 * rf(M, 8214748)
    f1 = f1 + f2
    wfd(8213140, f1)
    f1 = rf(M, 8218188)
    f1 = f1 * rf(M, 8214756)
    f2 = rf(M, 8218192)
    f2 = f2 * rf(M, 8214768)
    f1 = f1 + f2
    wfd(8213148, f1)
    f1 = rf(M, 8218292)
    f1 = f1 * rf(M, 8214756)
    f2 = rf(M, 8218200)
    f2 = f2 * rf(M, 8214764)
    f1 = f1 + f2
    f2 = rf(M, 8218296)
    f2 = f2 * rf(M, 8214768)
    f1 = f1 + f2
    wfd(8213156, f1)
    f1 = rf(M, 8218208)
    f1 = f1 * rf(M, 8214756)
    f2 = rf(M, 8218304)
    f2 = f2 * rf(M, 8214764)
    f1 = f1 + f2
    f2 = rf(M, 8218220)
    f2 = f2 * rf(M, 8214768)
    f1 = f1 + f2
    wfd(8213164, f1)
    f1 = rf(M, 8218188)
    f1 = f1 * rf(M, 8214776)
    f2 = rf(M, 8218192)
    f2 = f2 * rf(M, 8214792)
    f1 = f1 + f2
    wfd(8213172, f1)
    f1 = rf(M, 8218292)
    f1 = f1 * rf(M, 8214776)
    f2 = rf(M, 8218200)
    f2 = f2 * rf(M, 8214784)
    f1 = f1 + f2
    f2 = rf(M, 8218296)
    f2 = f2 * rf(M, 8214792)
    f1 = f1 + f2
    wfd(8213180, f1)
    f1 = rf(M, 8218208)
    f1 = f1 * rf(M, 8214776)
    f2 = rf(M, 8218304)
    f2 = f2 * rf(M, 8214784)
    f1 = f1 + f2
    f2 = rf(M, 8218220)
    f2 = f2 * rf(M, 8214792)
    f1 = f1 + f2
    wfd(8213188, f1)
    f1 = rf(M, 8213124)
    f1 = f1 * rf(M, 8218576)
    f2 = rf(M, 8213132)
    f2 = f2 * rf(M, 8218584)
    f1 = f1 + f2
    wfd(8210208, f1)
    f1 = rf(M, 8213124)
    f1 = f1 * rf(M, 8218620)
    f2 = rf(M, 8213132)
    f2 = f2 * rf(M, 8218576)
    f1 = f1 + f2
    wfd(8210200, f1)
    f1 = rf(M, 8213124)
    f1 = f1 * rf(M, 8218592)
    f2 = rf(M, 8213132)
    f2 = f2 * rf(M, 8218624)
    f1 = f1 + f2
    wfd(8210212, f1)
  end
  local function C3()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8213148)
    f1 = f1 * rf(M, 8218576)
    f2 = rf(M, 8213156)
    f2 = f2 * rf(M, 8218584)
    f1 = f1 + f2
    wfd(8210204, f1)
    f1 = rf(M, 8213148)
    f1 = f1 * rf(M, 8218620)
    f2 = rf(M, 8213156)
    f2 = f2 * rf(M, 8218576)
    f1 = f1 + f2
    wfd(8210216, f1)
    f1 = rf(M, 8213148)
    f1 = f1 * rf(M, 8218592)
    f2 = rf(M, 8213156)
    f2 = f2 * rf(M, 8218628)
    f1 = f1 + f2
    wfd(8210220, f1)
    f1 = rf(M, 8213172)
    f1 = f1 * rf(M, 8218576)
    f2 = rf(M, 8213180)
    f2 = f2 * rf(M, 8218584)
    f1 = f1 + f2
    wfd(8210224, f1)
    f1 = rf(M, 8213172)
    f1 = f1 * rf(M, 8218620)
    f2 = rf(M, 8213180)
    f2 = f2 * rf(M, 8218576)
    f1 = f1 + f2
    wfd(8210228, f1)
    f1 = rf(M, 8213172)
    f1 = f1 * rf(M, 8218592)
    f2 = rf(M, 8213180)
    f2 = f2 * rf(M, 8218624)
    f1 = f1 + f2
    wfd(8210232, f1)
    f1 = rf(M, 8213128)
    f1 = f1 * rf(M, 8218576)
    f2 = rf(M, 8213136)
    f2 = f2 * rf(M, 8218584)
    f1 = f1 + f2
    wfd(8210236, f1)
    f1 = rf(M, 8213128)
    f1 = f1 * rf(M, 8218620)
    f2 = rf(M, 8213136)
    f2 = f2 * rf(M, 8218576)
    f1 = f1 + f2
    wfd(8210240, f1)
    f1 = rf(M, 8213128)
    f1 = f1 * rf(M, 8218592)
    f2 = rf(M, 8213136)
    f2 = f2 * rf(M, 8218624)
    f1 = f1 + f2
    wfd(8210244, f1)
    f1 = rf(M, 8213152)
    f1 = f1 * rf(M, 8218576)
    f2 = rf(M, 8213160)
    f2 = f2 * rf(M, 8218584)
    f1 = f1 + f2
    wfd(8210248, f1)
    f1 = rf(M, 8213152)
    f1 = f1 * rf(M, 8218620)
    f2 = rf(M, 8213160)
    f2 = f2 * rf(M, 8218576)
    f1 = f1 + f2
    wfd(8210252, f1)
    f1 = rf(M, 8213152)
    f1 = f1 * rf(M, 8218592)
    f2 = rf(M, 8213160)
    f2 = f2 * rf(M, 8218624)
    f1 = f1 + f2
    wfd(8210256, f1)
    f1 = rf(M, 8213176)
    f1 = f1 * rf(M, 8218576)
    f2 = rf(M, 8213184)
    f2 = f2 * rf(M, 8218584)
    f1 = f1 + f2
    wfd(8210260, f1)
    f1 = rf(M, 8213176)
    f1 = f1 * rf(M, 8218620)
    f2 = rf(M, 8213184)
    f2 = f2 * rf(M, 8218576)
    f1 = f1 + f2
    wfd(8210264, f1)
    f1 = rf(M, 8213176)
    f1 = f1 * rf(M, 8218592)
    f2 = rf(M, 8213184)
    f2 = f2 * rf(M, 8218624)
    f1 = f1 + f2
    wfd(8210268, f1)
    f1 = rf(M, 8211956)
    f1 = -f1
    wfd(8210272, f1)
    f1 = f1 * rf(M, 8218388)
    wfd(8213892, f1)
    f1 = rf(M, 8210272)
    f1 = f1 * rf(M, 8218384)
    wfd(8213896, f1)
    f1 = rf(M, 8218384)
    f1 = f1 * rf(M, 8211956)
    wfd(8213904, f1)
    f1 = rf(M, 8218396)
    f1 = f1 * rf(M, 8211956)
    wfd(8213912, f1)
    f1 = rf(M, 8218388)
    f1 = f1 * rf(M, 8213616)
    wfd(8213900, f1)
    f1 = rf(M, 8218384)
    f1 = f1 * rf(M, 8213616)
    wfd(8213908, f1)
    r_eax = ru(M, 8213628)
    wu(M, 8214084, r_eax)
    wu(M, 8213916, r_eax)
    f1 = rf(M, 8218388)
    f1 = f1 * rf(M, 8213624)
    wfd(8213920, f1)
    f1 = rf(M, 8218384)
    f1 = f1 * rf(M, 8213624)
    wfd(8213924, f1)
    r_eax = ru(M, 8213620)
    wu(M, 8214096, r_eax)
    wu(M, 8213928, r_eax)
    f1 = rf(M, 8213900)
    f1 = f1 * rf(M, 8218632)
    wfd(8210272, f1)
    f1 = rf(M, 8213908)
    f1 = f1 * rf(M, 8218636)
    wfd(8210276, f1)
    f1 = rf(M, 8213920)
    f1 = f1 * rf(M, 8218632)
    wfd(8210280, f1)
    f1 = rf(M, 8213924)
    f1 = f1 * rf(M, 8218632)
    wfd(8210284, f1)
    f1 = rf(M, 8213892)
    f1 = f1 * rf(M, 8218632)
    wfd(8210288, f1)
    f1 = rf(M, 8213896)
    f1 = f1 * rf(M, 8218632)
    wfd(8210292, f1)
    f1 = rf(M, 8213904)
    f1 = f1 * rf(M, 8218632)
    wfd(8210296, f1)
    f1 = rf(M, 8213912)
    f1 = f1 * rf(M, 8218632)
    wfd(8210300, f1)
    f1 = rf(M, 8211968)
    f1 = -f1
    wfd(8210304, f1)
    f1 = f1 * rf(M, 8218400)
    wfd(8214060, f1)
    f1 = rf(M, 8210304)
    f1 = f1 * rf(M, 8218384)
    wfd(8214064, f1)
    f1 = rf(M, 8218384)
    f1 = f1 * rf(M, 8211968)
    wfd(8214072, f1)
    f1 = rf(M, 8218408)
    f1 = f1 * rf(M, 8211968)
    wfd(8214080, f1)
    f1 = rf(M, 8218400)
    f1 = f1 * rf(M, 8213616)
    wfd(8214068, f1)
    f1 = rf(M, 8218384)
    f1 = f1 * rf(M, 8213616)
    wfd(8214076, f1)
    f1 = rf(M, 8218400)
    f1 = f1 * rf(M, 8213624)
    wfd(8214088, f1)
    f1 = rf(M, 8218384)
    f1 = f1 * rf(M, 8213624)
    wfd(8214092, f1)
    f1 = rf(M, 8214068)
    f1 = f1 * rf(M, 8218636)
    wfd(8210304, f1)
    f1 = rf(M, 8214076)
    f1 = f1 * rf(M, 8218636)
    wfd(8210308, f1)
    f1 = rf(M, 8214088)
    f1 = f1 * rf(M, 8218636)
    wfd(8210312, f1)
    f1 = rf(M, 8214092)
    f1 = f1 * rf(M, 8218636)
    wfd(8210316, f1)
    f1 = rf(M, 8214060)
    f1 = f1 * rf(M, 8218636)
    wfd(8210320, f1)
    f1 = rf(M, 8214064)
    f1 = f1 * rf(M, 8218636)
    wfd(8210324, f1)
    f1 = rf(M, 8214072)
    f1 = f1 * rf(M, 8218636)
    wfd(8210328, f1)
    f1 = rf(M, 8214080)
    f1 = f1 * rf(M, 8218636)
    wfd(8210332, f1)
    f1 = rf(M, 8217188)
    f1 = f1 * rf(M, 8218384)
    f2 = rf(M, 8217192)
    f2 = f2 * rf(M, 8218396)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8217164)
    f2 = rf(M, 8217212)
    f2 = f2 * rf(M, 8218384)
    f3 = rf(M, 8217216)
    f3 = f3 * rf(M, 8218408)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217164, f1)
    f1 = rf(M, 8213900)
    f1 = f1 * rf(M, 8217188)
    f2 = rf(M, 8213908)
    f2 = f2 * rf(M, 8217192)
    f1 = f1 + f2
    f2 = rf(M, 8217196)
    f2 = f2 * rf(M, 8214084)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8217168)
    f2 = rf(M, 8214068)
    f2 = f2 * rf(M, 8217212)
    f3 = rf(M, 8214076)
    f3 = f3 * rf(M, 8217216)
    f2 = f2 + f3
    f3 = rf(M, 8217220)
    f3 = f3 * rf(M, 8214084)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217168, f1)
    f1 = rf(M, 8213900)
    f1 = f1 * rf(M, 8218648)
    f2 = rf(M, 8213908)
    f2 = f2 * rf(M, 8218652)
    f1 = f1 + f2
    f2 = rf(M, 8214068)
    f2 = f2 * rf(M, 8218648)
    f3 = rf(M, 8214076)
    f3 = f3 * rf(M, 8218716)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217548, f1)
    f1 = rf(M, 8213920)
    f1 = f1 * rf(M, 8218648)
    f2 = rf(M, 8213924)
    f2 = f2 * rf(M, 8218656)
    f1 = f1 + f2
    f2 = rf(M, 8214088)
    f2 = f2 * rf(M, 8218648)
    f3 = rf(M, 8214092)
    f3 = f3 * rf(M, 8218720)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217552, f1)
    f1 = rf(M, 8213892)
    f1 = f1 * rf(M, 8218648)
    f2 = rf(M, 8213896)
    f2 = f2 * rf(M, 8218652)
    f1 = f1 + f2
    f2 = rf(M, 8214060)
    f2 = f2 * rf(M, 8218648)
    f3 = rf(M, 8214064)
    f3 = f3 * rf(M, 8218716)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217556, f1)
    f1 = rf(M, 8213904)
    f1 = f1 * rf(M, 8218648)
    f2 = rf(M, 8213912)
    f2 = f2 * rf(M, 8218652)
    f1 = f1 + f2
    f2 = rf(M, 8214072)
    f2 = f2 * rf(M, 8218648)
    f3 = rf(M, 8214080)
    f3 = f3 * rf(M, 8218716)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217560, f1)
    f1 = rf(M, 8210272)
    f1 = f1 * rf(M, 8218384)
    f2 = rf(M, 8210276)
    f2 = f2 * rf(M, 8218396)
    f1 = f1 + f2
    f2 = rf(M, 8210304)
    f2 = f2 * rf(M, 8218384)
    f3 = rf(M, 8210308)
    f3 = f3 * rf(M, 8218408)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217564, f1)
    f1 = rf(M, 8213900)
    f1 = f1 * rf(M, 8210272)
    f2 = rf(M, 8213908)
    f2 = f2 * rf(M, 8210276)
    f1 = f1 + f2
    f2 = rf(M, 8218632)
    f2 = f2 * rf(M, 8214084)
    wfd(8210336, f2)
    f2 = f2 * rf(M, 8214084)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8218696)
    f2 = rf(M, 8214068)
    f2 = f2 * rf(M, 8210304)
    f3 = rf(M, 8214076)
    f3 = f3 * rf(M, 8210308)
    f2 = f2 + f3
    f3 = rf(M, 8218636)
    f3 = f3 * rf(M, 8214084)
    wfd(8210340, f3)
    f3 = f3 * rf(M, 8214084)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217568, f1)
  end
  local function C4()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8213920)
    f1 = f1 * rf(M, 8210272)
    f2 = rf(M, 8213924)
    f2 = f2 * rf(M, 8210276)
    f1 = f1 + f2
    f2 = rf(M, 8210336)
    f2 = f2 * rf(M, 8214096)
    f1 = f1 + f2
    f2 = rf(M, 8214088)
    f2 = f2 * rf(M, 8210304)
    f3 = rf(M, 8214092)
    f3 = f3 * rf(M, 8210308)
    f2 = f2 + f3
    f3 = rf(M, 8210340)
    f3 = f3 * rf(M, 8214096)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217572, f1)
    f1 = rf(M, 8213892)
    f1 = f1 * rf(M, 8210272)
    f2 = rf(M, 8213896)
    f2 = f2 * rf(M, 8210276)
    f1 = f1 + f2
    f2 = rf(M, 8210336)
    f2 = f2 * rf(M, 8218228)
    f1 = f1 + f2
    f2 = rf(M, 8214060)
    f2 = f2 * rf(M, 8210304)
    f3 = rf(M, 8214064)
    f3 = f3 * rf(M, 8210308)
    f2 = f2 + f3
    f3 = rf(M, 8210340)
    f3 = f3 * rf(M, 8218308)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217576, f1)
    f1 = rf(M, 8213904)
    f1 = f1 * rf(M, 8210272)
    f2 = rf(M, 8213912)
    f2 = f2 * rf(M, 8210276)
    f1 = f1 + f2
    f2 = rf(M, 8214072)
    f2 = f2 * rf(M, 8210304)
    f3 = rf(M, 8214080)
    f3 = f3 * rf(M, 8210308)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217580, f1)
    f1 = rf(M, 8210272)
    f1 = f1 * rf(M, 8218640)
    f2 = rf(M, 8210276)
    f2 = f2 * rf(M, 8218644)
    f1 = f1 + f2
    f2 = rf(M, 8210304)
    f2 = f2 * rf(M, 8218708)
    f3 = rf(M, 8210308)
    f3 = f3 * rf(M, 8218712)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217584, f1)
    f1 = rf(M, 8213548)
    f1 = f1 * rf(M, 8218372)
    wfd(8210308, f1)
    f1 = f1 * rf(M, 8218352)
    wfd(8213672, f1)
    f1 = rf(M, 8213548)
    f1 = f1 * rf(M, 8218348)
    f1 = f1 + rf(M, 8211936)
    wfd(8210304, f1)
    f1 = -f1
    wfd(8210276, f1)
    f1 = rf(M, 8210308)
    f1 = f1 * rf(M, 8218360)
    f1 = f1 + rf(M, 8210276)
    wfd(8213680, f1)
    f1 = rf(M, 8210276)
    f1 = f1 * rf(M, 8218372)
    f2 = rf(M, 8210308)
    f2 = f2 * rf(M, 8218348)
    f1 = f1 + f2
    wfd(8213692, f1)
    f1 = rf(M, 8210304)
    f1 = f1 * rf(M, 8218348)
    f2 = rf(M, 8213548)
    f2 = f2 * rf(M, 8218364)
    f2 = f2 + rf(M, 8218380)
    wfd(8210276, f2)
    f2 = -f2
    wfd(8210272, f2)
    f2 = f2 * rf(M, 8218352)
    f1 = f1 + f2
    wfd(8213704, f1)
    f1 = rf(M, 8210304)
    f1 = f1 * rf(M, 8218356)
    f2 = rf(M, 8210272)
    f2 = f2 * rf(M, 8218360)
    f1 = f1 + f2
    wfd(8213712, f1)
    f1 = rf(M, 8210304)
    f1 = f1 * rf(M, 8218364)
    f2 = rf(M, 8210272)
    f2 = f2 * rf(M, 8218348)
    f1 = f1 + f2
    wfd(8213724, f1)
    f1 = rf(M, 8210308)
    f1 = -f1
    wfd(8210308, f1)
    f1 = f1 * rf(M, 8218348)
    wfd(8213736, f1)
    f1 = rf(M, 8210308)
    f1 = f1 * rf(M, 8218356)
    f1 = f1 + rf(M, 8210276)
    wfd(8213744, f1)
    f1 = rf(M, 8210308)
    f1 = f1 * rf(M, 8218364)
    f2 = rf(M, 8210276)
    f2 = f2 * rf(M, 8218372)
    f1 = f1 + f2
    wfd(8213756, f1)
    f1 = rf(M, 8218348)
    f1 = f1 * rf(M, 8214736)
    f2 = rf(M, 8218352)
    f2 = f2 * rf(M, 8214748)
    f1 = f1 + f2
    wfd(8213668, f1)
    f1 = rf(M, 8218356)
    f1 = f1 * rf(M, 8214736)
    f1 = f1 + rf(M, 8214740)
    f2 = rf(M, 8218360)
    f2 = f2 * rf(M, 8214748)
    f1 = f1 + f2
    wfd(8213676, f1)
    f1 = rf(M, 8218364)
    f1 = f1 * rf(M, 8214736)
    f2 = rf(M, 8218372)
    f2 = f2 * rf(M, 8214740)
    f1 = f1 + f2
    f2 = rf(M, 8218348)
    f2 = f2 * rf(M, 8214748)
    f1 = f1 + f2
    wfd(8213688, f1)
    f1 = rf(M, 8218348)
    f1 = f1 * rf(M, 8214756)
    f2 = rf(M, 8218352)
    f2 = f2 * rf(M, 8214768)
    f1 = f1 + f2
    wfd(8213700, f1)
    f1 = rf(M, 8218356)
    f1 = f1 * rf(M, 8214756)
    f1 = f1 + rf(M, 8214764)
    f2 = rf(M, 8218360)
    f2 = f2 * rf(M, 8214768)
    f1 = f1 + f2
    wfd(8213708, f1)
    f1 = rf(M, 8218364)
    f1 = f1 * rf(M, 8214756)
    f2 = rf(M, 8218372)
    f2 = f2 * rf(M, 8214764)
    f1 = f1 + f2
    f2 = rf(M, 8218348)
    f2 = f2 * rf(M, 8214768)
    f1 = f1 + f2
    wfd(8213720, f1)
    f1 = rf(M, 8218348)
    f1 = f1 * rf(M, 8214776)
    f2 = rf(M, 8218352)
    f2 = f2 * rf(M, 8214792)
    f1 = f1 + f2
    wfd(8213732, f1)
    f1 = rf(M, 8218356)
    f1 = f1 * rf(M, 8214776)
    f1 = f1 + rf(M, 8214784)
    f2 = rf(M, 8218360)
    f2 = f2 * rf(M, 8214792)
    f1 = f1 + f2
    wfd(8213740, f1)
    f1 = rf(M, 8218364)
    f1 = f1 * rf(M, 8214776)
    f2 = rf(M, 8218372)
    f2 = f2 * rf(M, 8214784)
    f1 = f1 + f2
    f2 = rf(M, 8218348)
    f2 = f2 * rf(M, 8214792)
    f1 = f1 + f2
    wfd(8213752, f1)
    f1 = rf(M, 8213616)
    f1 = f1 * rf(M, 8218356)
    f2 = rf(M, 8213624)
    f2 = f2 * rf(M, 8218364)
    f1 = f1 + f2
    wfd(8213684, f1)
    f1 = rf(M, 8214084)
    f1 = f1 * rf(M, 8218356)
    f2 = rf(M, 8214096)
    f2 = f2 * rf(M, 8218364)
    f1 = f1 + f2
    wfd(8213696, f1)
    f1 = rf(M, 8213624)
    f1 = f1 * rf(M, 8218372)
    f1 = f1 + rf(M, 8213616)
    wfd(8213716, f1)
    f1 = rf(M, 8214096)
    f1 = f1 * rf(M, 8218372)
    f1 = f1 + rf(M, 8214084)
    wfd(8213728, f1)
    f1 = rf(M, 8213616)
    f1 = f1 * rf(M, 8218360)
    f2 = rf(M, 8213624)
    f2 = f2 * rf(M, 8218348)
    f1 = f1 + f2
    wfd(8213748, f1)
    f1 = rf(M, 8214084)
    f1 = f1 * rf(M, 8218360)
    f2 = rf(M, 8214096)
    f2 = f2 * rf(M, 8218348)
    f1 = f1 + f2
    wfd(8213760, f1)
    f1 = rf(M, 8213668)
    f1 = f1 * rf(M, 8218756)
    f2 = rf(M, 8217564)
    f2 = f2 * rf(M, 8213676)
    f1 = f1 + f2
    wfd(8210276, f1)
    f1 = rf(M, 8217548)
    f1 = f1 * rf(M, 8213668)
    f2 = rf(M, 8217568)
    f2 = f2 * rf(M, 8213676)
    f1 = f1 + f2
    wfd(8210308, f1)
    f1 = rf(M, 8217552)
    f1 = f1 * rf(M, 8213668)
    f2 = rf(M, 8217572)
    f2 = f2 * rf(M, 8213676)
    f1 = f1 + f2
    wfd(8210272, f1)
    f1 = rf(M, 8213700)
    f1 = f1 * rf(M, 8218756)
    f2 = rf(M, 8217564)
    f2 = f2 * rf(M, 8213708)
    f1 = f1 + f2
    wfd(8210304, f1)
    f1 = rf(M, 8217548)
    f1 = f1 * rf(M, 8213700)
    f2 = rf(M, 8217568)
    f2 = f2 * rf(M, 8213708)
    f1 = f1 + f2
    wfd(8210340, f1)
    f1 = rf(M, 8217552)
    f1 = f1 * rf(M, 8213700)
    f2 = rf(M, 8217572)
    f2 = f2 * rf(M, 8213708)
    f1 = f1 + f2
    wfd(8210336, f1)
    f1 = rf(M, 8213732)
    f1 = f1 * rf(M, 8218756)
    f2 = rf(M, 8217564)
    f2 = f2 * rf(M, 8213740)
    f1 = f1 + f2
    wfd(8210344, f1)
    f1 = rf(M, 8217548)
    f1 = f1 * rf(M, 8213732)
    f2 = rf(M, 8217568)
    f2 = f2 * rf(M, 8213740)
    f1 = f1 + f2
    wfd(8210348, f1)
    f1 = rf(M, 8217552)
    f1 = f1 * rf(M, 8213732)
    f2 = rf(M, 8217572)
    f2 = f2 * rf(M, 8213740)
    f1 = f1 + f2
    wfd(8210352, f1)
    f1 = rf(M, 8213672)
    f1 = f1 * rf(M, 8218756)
    f2 = rf(M, 8217564)
    f2 = f2 * rf(M, 8213680)
    f1 = f1 + f2
    f2 = rf(M, 8210296)
    f2 = f2 * rf(M, 8218384)
    f3 = rf(M, 8210300)
    f3 = f3 * rf(M, 8218396)
    f2 = f2 + f3
    f3 = rf(M, 8210328)
    f3 = f3 * rf(M, 8218384)
    f4 = rf(M, 8210332)
    f4 = f4 * rf(M, 8218408)
    f3 = f3 + f4
    f2 = f2 + f3
    wfd(8217636, f2)
    f2 = f2 * rf(M, 8213684)
    f1 = f1 + f2
    f2 = rf(M, 8213696)
    f2 = f2 * rf(M, 8218768)
    f1 = f1 + f2
    wfd(8210356, f1)
    f1 = rf(M, 8217548)
    f1 = f1 * rf(M, 8213672)
    f2 = rf(M, 8217568)
    f2 = f2 * rf(M, 8213680)
    f1 = f1 + f2
    f2 = rf(M, 8213900)
    f2 = f2 * rf(M, 8210296)
    f3 = rf(M, 8213908)
    f3 = f3 * rf(M, 8210300)
    f2 = f2 + f3
    f3 = rf(M, 8214068)
    f3 = f3 * rf(M, 8210328)
    f4 = rf(M, 8214076)
    f4 = f4 * rf(M, 8210332)
    f3 = f3 + f4
    f2 = f2 + f3
    wfd(8217640, f2)
    f2 = f2 * rf(M, 8213684)
    f1 = f1 + f2
    f2 = rf(M, 8213900)
    f2 = f2 * rf(M, 8218684)
    f3 = rf(M, 8213908)
    f3 = f3 * rf(M, 8218688)
    f2 = f2 + f3
    f3 = rf(M, 8214068)
    f3 = f3 * rf(M, 8218744)
    f4 = rf(M, 8214076)
    f4 = f4 * rf(M, 8218748)
    f3 = f3 + f4
    f2 = f2 + f3
    wfd(8217660, f2)
    f2 = f2 * rf(M, 8213696)
    f1 = f1 + f2
    wfd(8210360, f1)
  end
  local function C5()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8217552)
    f1 = f1 * rf(M, 8213672)
    f2 = rf(M, 8217572)
    f2 = f2 * rf(M, 8213680)
    f1 = f1 + f2
    f2 = rf(M, 8213920)
    f2 = f2 * rf(M, 8210296)
    f3 = rf(M, 8213924)
    f3 = f3 * rf(M, 8210300)
    f2 = f2 + f3
    f3 = rf(M, 8214088)
    f3 = f3 * rf(M, 8210328)
    f4 = rf(M, 8214092)
    f4 = f4 * rf(M, 8210332)
    f3 = f3 + f4
    f2 = f2 + f3
    wfd(8217644, f2)
    f2 = f2 * rf(M, 8213684)
    f1 = f1 + f2
    f2 = rf(M, 8213920)
    f2 = f2 * rf(M, 8218684)
    f3 = rf(M, 8213924)
    f3 = f3 * rf(M, 8218692)
    f2 = f2 + f3
    f3 = rf(M, 8214088)
    f3 = f3 * rf(M, 8218744)
    f4 = rf(M, 8214092)
    f4 = f4 * rf(M, 8218752)
    f3 = f3 + f4
    f2 = f2 + f3
    wfd(8217664, f2)
    f2 = f2 * rf(M, 8213696)
    f1 = f1 + f2
    wfd(8210364, f1)
    f1 = rf(M, 8213704)
    f1 = f1 * rf(M, 8218756)
    f2 = rf(M, 8217564)
    f2 = f2 * rf(M, 8213712)
    f1 = f1 + f2
    f2 = rf(M, 8217636)
    f2 = f2 * rf(M, 8213716)
    f1 = f1 + f2
    f2 = rf(M, 8213728)
    f2 = f2 * rf(M, 8218768)
    f1 = f1 + f2
    wfd(8210368, f1)
    f1 = rf(M, 8217548)
    f1 = f1 * rf(M, 8213704)
    f2 = rf(M, 8217568)
    f2 = f2 * rf(M, 8213712)
    f1 = f1 + f2
    f2 = rf(M, 8217640)
    f2 = f2 * rf(M, 8213716)
    f1 = f1 + f2
    f2 = rf(M, 8217660)
    f2 = f2 * rf(M, 8213728)
    f1 = f1 + f2
    wfd(8210372, f1)
    f1 = rf(M, 8217552)
    f1 = f1 * rf(M, 8213704)
    f2 = rf(M, 8217572)
    f2 = f2 * rf(M, 8213712)
    f1 = f1 + f2
    f2 = rf(M, 8217644)
    f2 = f2 * rf(M, 8213716)
    f1 = f1 + f2
    f2 = rf(M, 8217664)
    f2 = f2 * rf(M, 8213728)
    f1 = f1 + f2
    wfd(8210376, f1)
    f1 = rf(M, 8213736)
    f1 = f1 * rf(M, 8218756)
    f2 = rf(M, 8217564)
    f2 = f2 * rf(M, 8213744)
    f1 = f1 + f2
    f2 = rf(M, 8217636)
    f2 = f2 * rf(M, 8213748)
    f1 = f1 + f2
    f2 = rf(M, 8213760)
    f2 = f2 * rf(M, 8218768)
    f1 = f1 + f2
    wfd(8210380, f1)
    f1 = rf(M, 8217548)
    f1 = f1 * rf(M, 8213736)
    f2 = rf(M, 8217568)
    f2 = f2 * rf(M, 8213744)
    f1 = f1 + f2
    f2 = rf(M, 8217640)
    f2 = f2 * rf(M, 8213748)
    f1 = f1 + f2
    f2 = rf(M, 8217660)
    f2 = f2 * rf(M, 8213760)
    f1 = f1 + f2
    wfd(8210384, f1)
    f1 = rf(M, 8217552)
    f1 = f1 * rf(M, 8213736)
    f2 = rf(M, 8217572)
    f2 = f2 * rf(M, 8213744)
    f1 = f1 + f2
    f2 = rf(M, 8217644)
    f2 = f2 * rf(M, 8213748)
    f1 = f1 + f2
    f2 = rf(M, 8217664)
    f2 = f2 * rf(M, 8213760)
    f1 = f1 + f2
    wfd(8210388, f1)
    f1 = rf(M, 8217008)
    f1 = f1 * rf(M, 8214736)
    f2 = rf(M, 8217012)
    f2 = f2 * rf(M, 8214740)
    f1 = f1 + f2
    f2 = rf(M, 8217016)
    f2 = f2 * rf(M, 8214748)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8216984)
    f2 = rf(M, 8217020)
    f2 = f2 * rf(M, 8214736)
    f3 = rf(M, 8217024)
    f3 = f3 * rf(M, 8214740)
    f2 = f2 + f3
    f3 = rf(M, 8217028)
    f3 = f3 * rf(M, 8214748)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8217048)
    f2 = f2 * rf(M, 8212604)
    f3 = rf(M, 8217052)
    f3 = f3 * rf(M, 8212612)
    f2 = f2 + f3
    f3 = rf(M, 8210140)
    f3 = f3 * rf(M, 8212500)
    f2 = f2 - f3
    f1 = f1 + f2
    f2 = rf(M, 8217108)
    f2 = f2 * rf(M, 8213124)
    f3 = rf(M, 8217112)
    f3 = f3 * rf(M, 8213132)
    f2 = f2 + f3
    f3 = rf(M, 8210212)
    f3 = f3 * rf(M, 8213020)
    f2 = f2 - f3
    f1 = f1 + f2
    f2 = rf(M, 8217164)
    f2 = f2 * rf(M, 8213668)
    f3 = rf(M, 8217168)
    f3 = f3 * rf(M, 8213676)
    f2 = f2 + f3
    f3 = rf(M, 8210272)
    f3 = f3 * rf(M, 8213540)
    f4 = rf(M, 8217556)
    f4 = f4 * rf(M, 8213668)
    f5 = rf(M, 8217576)
    f5 = f5 * rf(M, 8213676)
    f4 = f4 + f5
    wfd(8210392, f4)
    f4 = f4 * rf(M, 8213544)
    f3 = f3 + f4
    f2 = f2 - f3
    f1 = f1 + f2
    wfd(8216984, f1)
    f1 = rf(M, 8218440)
    f1 = f1 * rf(M, 8214736)
    wfd(8210396, f1)
    f1 = f1 * rf(M, 8214756)
    f2 = rf(M, 8218444)
    f2 = f2 * rf(M, 8214740)
    wfd(8210400, f2)
    f2 = f2 * rf(M, 8214764)
    f1 = f1 + f2
    f2 = rf(M, 8218440)
    f2 = f2 * rf(M, 8214748)
    wfd(8210404, f2)
    f2 = f2 * rf(M, 8214768)
    f1 = f1 + f2
    f2 = rf(M, 8211864)
    wfd(8217392, f2)
    f2 = f2 * rf(M, 8214736)
    wfd(8210408, f2)
    f2 = f2 * rf(M, 8214756)
    f3 = rf(M, 8211868)
    wfd(8217396, f3)
    f3 = f3 * rf(M, 8214740)
    wfd(8210412, f3)
    f3 = f3 * rf(M, 8214764)
    f2 = f2 + f3
    f3 = rf(M, 8211872)
    wfd(8217400, f3)
    f3 = f3 * rf(M, 8214748)
    wfd(8210416, f3)
    f3 = f3 * rf(M, 8214768)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8212628)
    f2 = f2 * rf(M, 8210132)
    f3 = rf(M, 8212636)
    f3 = f3 * rf(M, 8210128)
    f2 = f2 + f3
    f3 = rf(M, 8212644)
    f3 = f3 * rf(M, 8210140)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213148)
    f2 = f2 * rf(M, 8210208)
    f3 = rf(M, 8213156)
    f3 = f3 * rf(M, 8210200)
    f2 = f2 + f3
    f3 = rf(M, 8213164)
    f3 = f3 * rf(M, 8210212)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213700)
    f2 = f2 * rf(M, 8210276)
    f3 = rf(M, 8213708)
    f3 = f3 * rf(M, 8210308)
    f2 = f2 + f3
    f3 = rf(M, 8213720)
    f3 = f3 * rf(M, 8210272)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217288, f1)
    f1 = rf(M, 8210396)
    f1 = f1 * rf(M, 8214776)
    f2 = rf(M, 8210400)
    f2 = f2 * rf(M, 8214784)
    f1 = f1 + f2
    f2 = rf(M, 8210404)
    f2 = f2 * rf(M, 8214792)
    f1 = f1 + f2
    f2 = rf(M, 8210408)
    f2 = f2 * rf(M, 8214776)
    f3 = rf(M, 8210412)
    f3 = f3 * rf(M, 8214784)
    f2 = f2 + f3
    f3 = rf(M, 8210416)
    f3 = f3 * rf(M, 8214792)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8212652)
    f2 = f2 * rf(M, 8210132)
    f3 = rf(M, 8212660)
    f3 = f3 * rf(M, 8210128)
    f2 = f2 + f3
    f3 = rf(M, 8212668)
    f3 = f3 * rf(M, 8210140)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213172)
    f2 = f2 * rf(M, 8210208)
    f3 = rf(M, 8213180)
    f3 = f3 * rf(M, 8210200)
    f2 = f2 + f3
    f3 = rf(M, 8213188)
    f3 = f3 * rf(M, 8210212)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213732)
    f2 = f2 * rf(M, 8210276)
    f3 = rf(M, 8213740)
    f3 = f3 * rf(M, 8210308)
    f2 = f2 + f3
    f3 = rf(M, 8213752)
    f3 = f3 * rf(M, 8210272)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217292, f1)
    f1 = rf(M, 8210400)
    f1 = f1 * rf(M, 8218448)
    f2 = rf(M, 8210412)
    f2 = f2 * rf(M, 8218428)
    f1 = f1 + f2
    f2 = rf(M, 8212608)
    f2 = f2 * rf(M, 8210132)
    f3 = rf(M, 8212616)
    f3 = f3 * rf(M, 8210128)
    f2 = f2 + f3
    f3 = rf(M, 8212624)
    f3 = f3 * rf(M, 8210140)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213128)
    f2 = f2 * rf(M, 8210208)
    f3 = rf(M, 8213136)
    f3 = f3 * rf(M, 8210200)
    f2 = f2 + f3
    f3 = rf(M, 8213144)
    f3 = f3 * rf(M, 8210212)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213672)
    f2 = f2 * rf(M, 8210276)
    f3 = rf(M, 8213680)
    f3 = f3 * rf(M, 8210308)
    f2 = f2 + f3
    f3 = rf(M, 8213692)
    f3 = f3 * rf(M, 8210272)
    f2 = f2 + f3
    f3 = rf(M, 8210392)
    f3 = f3 * rf(M, 8218348)
    f2 = f2 + f3
    f3 = rf(M, 8217560)
    f3 = f3 * rf(M, 8213668)
    f4 = rf(M, 8217580)
    f4 = f4 * rf(M, 8213676)
    f3 = f3 + f4
    wfd(8210420, f3)
    f3 = rf(M, 8213684)
    f3 = f3 * rf(M, 8210420)
    f2 = f2 + f3
    f3 = rf(M, 8213668)
    f3 = f3 * rf(M, 8218760)
    f4 = rf(M, 8217584)
    f4 = f4 * rf(M, 8213676)
    f3 = f3 + f4
    wfd(8210424, f3)
    f3 = rf(M, 8213696)
    f3 = f3 * rf(M, 8210424)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217296, f1)
  end
  local function C6()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8210396)
    f1 = f1 * rf(M, 8218172)
    f2 = rf(M, 8210404)
    f2 = f2 * rf(M, 8218456)
    f1 = f1 + f2
    f2 = rf(M, 8210408)
    f2 = f2 * rf(M, 8218184)
    f3 = rf(M, 8210416)
    f3 = f3 * rf(M, 8218496)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8212632)
    f2 = f2 * rf(M, 8210132)
    f3 = rf(M, 8212640)
    f3 = f3 * rf(M, 8210128)
    f2 = f2 + f3
    f3 = rf(M, 8212648)
    f3 = f3 * rf(M, 8210140)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213152)
    f2 = f2 * rf(M, 8210208)
    f3 = rf(M, 8213160)
    f3 = f3 * rf(M, 8210200)
    f2 = f2 + f3
    f3 = rf(M, 8213168)
    f3 = f3 * rf(M, 8210212)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213704)
    f2 = f2 * rf(M, 8210276)
    f3 = rf(M, 8213712)
    f3 = f3 * rf(M, 8210308)
    f2 = f2 + f3
    f3 = rf(M, 8213724)
    f3 = f3 * rf(M, 8210272)
    f2 = f2 + f3
    f3 = rf(M, 8213716)
    f3 = f3 * rf(M, 8210420)
    f2 = f2 + f3
    f3 = rf(M, 8213728)
    f3 = f3 * rf(M, 8210424)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217300, f1)
    f1 = rf(M, 8210400)
    f1 = f1 * rf(M, 8218164)
    f2 = rf(M, 8210412)
    f2 = f2 * rf(M, 8218176)
    f1 = f1 + f2
    f2 = rf(M, 8212656)
    f2 = f2 * rf(M, 8210132)
    f3 = rf(M, 8212664)
    f3 = f3 * rf(M, 8210128)
    f2 = f2 + f3
    f3 = rf(M, 8212672)
    f3 = f3 * rf(M, 8210140)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213176)
    f2 = f2 * rf(M, 8210208)
    f3 = rf(M, 8213184)
    f3 = f3 * rf(M, 8210200)
    f2 = f2 + f3
    f3 = rf(M, 8213192)
    f3 = f3 * rf(M, 8210212)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213736)
    f2 = f2 * rf(M, 8210276)
    f3 = rf(M, 8213744)
    f3 = f3 * rf(M, 8210308)
    f2 = f2 + f3
    f3 = rf(M, 8213756)
    f3 = f3 * rf(M, 8210272)
    f2 = f2 + f3
    f3 = rf(M, 8210392)
    f3 = f3 * rf(M, 8218352)
    f2 = f2 + f3
    f3 = rf(M, 8213748)
    f3 = f3 * rf(M, 8210420)
    f2 = f2 + f3
    f3 = rf(M, 8213760)
    f3 = f3 * rf(M, 8210424)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217304, f1)
    f1 = rf(M, 8218440)
    f1 = f1 * rf(M, 8214756)
    wfd(8210424, f1)
    f1 = f1 * rf(M, 8214736)
    f2 = rf(M, 8218440)
    f2 = f2 * rf(M, 8214764)
    wfd(8210420, f2)
    f2 = f2 * rf(M, 8214740)
    f1 = f1 + f2
    f2 = rf(M, 8218440)
    f2 = f2 * rf(M, 8214768)
    wfd(8210392, f2)
    f2 = f2 * rf(M, 8214748)
    f1 = f1 + f2
    f2 = rf(M, 8217392)
    f2 = f2 * rf(M, 8214756)
    wfd(8210428, f2)
    f2 = f2 * rf(M, 8214736)
    f3 = rf(M, 8217396)
    f3 = f3 * rf(M, 8214764)
    wfd(8210432, f3)
    f3 = f3 * rf(M, 8214740)
    f2 = f2 + f3
    f3 = rf(M, 8217400)
    f3 = f3 * rf(M, 8214768)
    wfd(8210436, f3)
    f3 = f3 * rf(M, 8214748)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8212604)
    f2 = f2 * rf(M, 8210144)
    f3 = rf(M, 8212612)
    f3 = f3 * rf(M, 8210148)
    f2 = f2 + f3
    f3 = rf(M, 8212620)
    f3 = f3 * rf(M, 8210136)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213124)
    f2 = f2 * rf(M, 8210204)
    f3 = rf(M, 8213132)
    f3 = f3 * rf(M, 8210216)
    f2 = f2 + f3
    f3 = rf(M, 8213140)
    f3 = f3 * rf(M, 8210220)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213668)
    f2 = f2 * rf(M, 8210304)
    f3 = rf(M, 8213676)
    f3 = f3 * rf(M, 8210340)
    f2 = f2 + f3
    f3 = rf(M, 8213688)
    f3 = f3 * rf(M, 8210336)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217308, f1)
    f1 = rf(M, 8210396)
    f1 = f1 * rf(M, 8214736)
    f2 = rf(M, 8210400)
    f2 = f2 * rf(M, 8214740)
    f1 = f1 + f2
    f2 = rf(M, 8210404)
    f2 = f2 * rf(M, 8214748)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8218488)
    f2 = rf(M, 8210408)
    f2 = f2 * rf(M, 8214736)
    f3 = rf(M, 8210412)
    f3 = f3 * rf(M, 8214740)
    f2 = f2 + f3
    f3 = rf(M, 8210416)
    f3 = f3 * rf(M, 8214748)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8212604)
    f2 = f2 * rf(M, 8210132)
    f3 = rf(M, 8212612)
    f3 = f3 * rf(M, 8210128)
    f2 = f2 + f3
    f3 = rf(M, 8212620)
    f3 = f3 * rf(M, 8210140)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213124)
    f2 = f2 * rf(M, 8210208)
    f3 = rf(M, 8213132)
    f3 = f3 * rf(M, 8210200)
    f2 = f2 + f3
    f3 = rf(M, 8213140)
    f3 = f3 * rf(M, 8210212)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213668)
    f2 = f2 * rf(M, 8210276)
    f3 = rf(M, 8213676)
    f3 = f3 * rf(M, 8210308)
    f2 = f2 + f3
    f3 = rf(M, 8213688)
    f3 = f3 * rf(M, 8210272)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217284, f1)
    q = fd(f1)
    if q < TINY and q > -TINY then f1 = 1 else f1 = 1 / q end
    wfd(8210272, f1)
    f1 = f1 * rf(M, 8217308)
    wfd(8210308, f1)
    f1 = rf(M, 8218440)
    f1 = f1 * rf(M, 8214776)
    wfd(8210276, f1)
    f1 = f1 * rf(M, 8214736)
    f2 = rf(M, 8218440)
    f2 = f2 * rf(M, 8214784)
    wfd(8210212, f2)
    f2 = f2 * rf(M, 8214740)
    f1 = f1 + f2
    f2 = rf(M, 8218440)
    f2 = f2 * rf(M, 8214792)
    wfd(8210200, f2)
    f2 = f2 * rf(M, 8214748)
    f1 = f1 + f2
    f2 = rf(M, 8217392)
    f2 = f2 * rf(M, 8214776)
    wfd(8210208, f2)
    f2 = f2 * rf(M, 8214736)
    f3 = rf(M, 8217396)
    f3 = f3 * rf(M, 8214784)
    wfd(8210140, f3)
    f3 = f3 * rf(M, 8214740)
    f2 = f2 + f3
    f3 = rf(M, 8217400)
    f3 = f3 * rf(M, 8214792)
    wfd(8210128, f3)
    f3 = f3 * rf(M, 8214748)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8212604)
    f2 = f2 * rf(M, 8210152)
    f3 = rf(M, 8212612)
    f3 = f3 * rf(M, 8210156)
    f2 = f2 + f3
    f3 = rf(M, 8212620)
    f3 = f3 * rf(M, 8210160)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213124)
    f2 = f2 * rf(M, 8210224)
    f3 = rf(M, 8213132)
    f3 = f3 * rf(M, 8210228)
    f2 = f2 + f3
    f3 = rf(M, 8213140)
    f3 = f3 * rf(M, 8210232)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213668)
    f2 = f2 * rf(M, 8210344)
    f3 = rf(M, 8213676)
    f3 = f3 * rf(M, 8210348)
    f2 = f2 + f3
    f3 = rf(M, 8213688)
    f3 = f3 * rf(M, 8210352)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217332, f1)
    f1 = rf(M, 8210272)
    f1 = f1 * rf(M, 8217332)
    wfd(8210132, f1)
    f1 = rf(M, 8214740)
    f1 = f1 * rf(M, 8218460)
    f2 = rf(M, 8217396)
    f2 = f2 * rf(M, 8218428)
    wfd(8210416, f2)
    f2 = f2 * rf(M, 8214740)
    f1 = f1 + f2
    f2 = rf(M, 8212604)
    f2 = f2 * rf(M, 8210164)
    f3 = rf(M, 8212612)
    f3 = f3 * rf(M, 8210168)
    f2 = f2 + f3
    f3 = rf(M, 8212620)
    f3 = f3 * rf(M, 8210172)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213124)
    f2 = f2 * rf(M, 8210236)
    f3 = rf(M, 8213132)
    f3 = f3 * rf(M, 8210240)
    f2 = f2 + f3
    f3 = rf(M, 8213140)
    f3 = f3 * rf(M, 8210244)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213668)
    f2 = f2 * rf(M, 8210356)
    f3 = rf(M, 8213676)
    f3 = f3 * rf(M, 8210360)
    f2 = f2 + f3
    f3 = rf(M, 8213688)
    f3 = f3 * rf(M, 8210364)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217356, f1)
    f1 = rf(M, 8210272)
    f1 = f1 * rf(M, 8217356)
    wfd(8210412, f1)
    f1 = rf(M, 8214736)
    f1 = f1 * rf(M, 8218468)
    f2 = rf(M, 8214748)
    f2 = f2 * rf(M, 8218472)
    f1 = f1 + f2
    f2 = rf(M, 8217392)
    f2 = f2 * rf(M, 8218184)
    wfd(8210408, f2)
    f2 = f2 * rf(M, 8214736)
    f3 = rf(M, 8217400)
    f3 = f3 * rf(M, 8218496)
    wfd(8210404, f3)
    f3 = f3 * rf(M, 8214748)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8212604)
    f2 = f2 * rf(M, 8210176)
    f3 = rf(M, 8212612)
    f3 = f3 * rf(M, 8210180)
    f2 = f2 + f3
    f3 = rf(M, 8212620)
    f3 = f3 * rf(M, 8210184)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213124)
    f2 = f2 * rf(M, 8210248)
    f3 = rf(M, 8213132)
    f3 = f3 * rf(M, 8210252)
    f2 = f2 + f3
    f3 = rf(M, 8213140)
    f3 = f3 * rf(M, 8210256)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213668)
    f2 = f2 * rf(M, 8210368)
    f3 = rf(M, 8213676)
    f3 = f3 * rf(M, 8210372)
    f2 = f2 + f3
    f3 = rf(M, 8213688)
    f3 = f3 * rf(M, 8210376)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217368, f1)
  end
  local function C7()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8210272)
    f1 = f1 * rf(M, 8217368)
    wfd(8210400, f1)
    f1 = rf(M, 8214740)
    f1 = f1 * rf(M, 8218480)
    f2 = rf(M, 8217396)
    f2 = f2 * rf(M, 8218176)
    wfd(8210396, f2)
    f2 = f2 * rf(M, 8214740)
    f1 = f1 + f2
    f2 = rf(M, 8212604)
    f2 = f2 * rf(M, 8210188)
    f3 = rf(M, 8212612)
    f3 = f3 * rf(M, 8210192)
    f2 = f2 + f3
    f3 = rf(M, 8212620)
    f3 = f3 * rf(M, 8210196)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213124)
    f2 = f2 * rf(M, 8210260)
    f3 = rf(M, 8213132)
    f3 = f3 * rf(M, 8210264)
    f2 = f2 + f3
    f3 = rf(M, 8213140)
    f3 = f3 * rf(M, 8210268)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213668)
    f2 = f2 * rf(M, 8210380)
    f3 = rf(M, 8213676)
    f3 = f3 * rf(M, 8210384)
    f2 = f2 + f3
    f3 = rf(M, 8213688)
    f3 = f3 * rf(M, 8210388)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217380, f1)
    f1 = rf(M, 8210272)
    f1 = f1 * rf(M, 8217380)
    wfd(8210272, f1)
    r_eax = ru(M, 8211884)
    wu(M, 8217412, r_eax)
    f1 = rf(M, 8210396)
    f1 = f1 * rf(M, 8218176)
    f1 = f1 + rf(M, 8217412)
    f1 = f1 + rf(M, 8218516)
    f2 = rf(M, 8212656)
    f2 = f2 * rf(M, 8210188)
    f3 = rf(M, 8212664)
    f3 = f3 * rf(M, 8210192)
    f2 = f2 + f3
    f3 = rf(M, 8212672)
    f3 = f3 * rf(M, 8210196)
    f2 = f2 + f3
    f3 = rf(M, 8212820)
    f3 = f3 * rf(M, 8218520)
    wfd(8210440, f3)
    f3 = rf(M, 8212820)
    f3 = f3 * rf(M, 8210440)
    f4 = rf(M, 8212824)
    f4 = f4 * rf(M, 8218524)
    wfd(8210444, f4)
    f4 = rf(M, 8212824)
    f4 = f4 * rf(M, 8210444)
    f3 = f3 + f4
    f3 = f3 + rf(M, 8218544)
    wfd(8217448, f3)
    f3 = f3 * rf(M, 8218192)
    f4 = rf(M, 8212828)
    f4 = f4 * rf(M, 8218520)
    wfd(8210448, f4)
    f4 = rf(M, 8212820)
    f4 = f4 * rf(M, 8210448)
    f5 = rf(M, 8212832)
    f5 = f5 * rf(M, 8218528)
    wfd(8210452, f5)
    f5 = rf(M, 8212824)
    f5 = f5 * rf(M, 8210452)
    f4 = f4 + f5
    f4 = f4 + rf(M, 8218548)
    wfd(8217460, f4)
    f4 = f4 * rf(M, 8218204)
    f3 = f3 + f4
    f4 = rf(M, 8212836)
    f4 = f4 * rf(M, 8218520)
    wfd(8210456, f4)
    f4 = rf(M, 8212820)
    f4 = f4 * rf(M, 8210456)
    f5 = rf(M, 8212840)
    f5 = f5 * rf(M, 8218524)
    wfd(8210460, f5)
    f5 = rf(M, 8212824)
    f5 = f5 * rf(M, 8210460)
    f4 = f4 + f5
    f4 = f4 + rf(M, 8218564)
    wfd(8217472, f4)
    f4 = f4 * rf(M, 8218220)
    f3 = f3 + f4
    wfd(8210464, f3)
    f3 = f3 * rf(M, 8218192)
    f2 = f2 + f3
    f3 = rf(M, 8212828)
    f3 = f3 * rf(M, 8210440)
    f4 = rf(M, 8212832)
    f4 = f4 * rf(M, 8210444)
    f3 = f3 + f4
    f3 = f3 + rf(M, 8218548)
    wfd(8217452, f3)
    f3 = f3 * rf(M, 8218192)
    f4 = rf(M, 8212828)
    f4 = f4 * rf(M, 8210448)
    f5 = rf(M, 8212832)
    f5 = f5 * rf(M, 8210452)
    f4 = f4 + f5
    f4 = f4 + rf(M, 8218556)
    wfd(8217464, f4)
    f4 = f4 * rf(M, 8218204)
    f3 = f3 + f4
    f4 = rf(M, 8212828)
    f4 = f4 * rf(M, 8210456)
    f5 = rf(M, 8212832)
    f5 = f5 * rf(M, 8210460)
    f4 = f4 + f5
    f4 = f4 + rf(M, 8218568)
    wfd(8217476, f4)
    f4 = f4 * rf(M, 8218220)
    f3 = f3 + f4
    wfd(8210468, f3)
    f3 = f3 * rf(M, 8218204)
    f2 = f2 + f3
    f3 = rf(M, 8212836)
    f3 = f3 * rf(M, 8210440)
    f4 = rf(M, 8212840)
    f4 = f4 * rf(M, 8210444)
    f3 = f3 + f4
    f3 = f3 + rf(M, 8218552)
    wfd(8217456, f3)
    f3 = f3 * rf(M, 8218192)
    f4 = rf(M, 8212836)
    f4 = f4 * rf(M, 8210448)
    f5 = rf(M, 8212840)
    f5 = f5 * rf(M, 8210452)
    f4 = f4 + f5
    f4 = f4 + rf(M, 8218560)
    wfd(8217468, f4)
    f4 = f4 * rf(M, 8218204)
    f3 = f3 + f4
    f4 = rf(M, 8212836)
    f4 = f4 * rf(M, 8210456)
    f5 = rf(M, 8212840)
    f5 = f5 * rf(M, 8210460)
    f4 = f4 + f5
    f4 = f4 + rf(M, 8218572)
    wfd(8217480, f4)
    f4 = f4 * rf(M, 8218220)
    f3 = f3 + f4
    wfd(8210460, f3)
    f3 = f3 * rf(M, 8218220)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213176)
    f2 = f2 * rf(M, 8210260)
    f3 = rf(M, 8213184)
    f3 = f3 * rf(M, 8210264)
    f2 = f2 + f3
    f3 = rf(M, 8213192)
    f3 = f3 * rf(M, 8210268)
    f2 = f2 + f3
    f3 = rf(M, 8213340)
    f3 = f3 * rf(M, 8218520)
    wfd(8210456, f3)
    f3 = rf(M, 8213340)
    f3 = f3 * rf(M, 8210456)
    f4 = rf(M, 8213344)
    f4 = f4 * rf(M, 8218528)
    wfd(8210452, f4)
    f4 = rf(M, 8213344)
    f4 = f4 * rf(M, 8210452)
    f3 = f3 + f4
    f3 = f3 + rf(M, 8218544)
    wfd(8217512, f3)
    f3 = f3 * rf(M, 8218192)
    f4 = rf(M, 8213348)
    f4 = f4 * rf(M, 8218520)
    wfd(8210448, f4)
    f4 = rf(M, 8213340)
    f4 = f4 * rf(M, 8210448)
    f5 = rf(M, 8213352)
    f5 = f5 * rf(M, 8218528)
    wfd(8210444, f5)
    f5 = rf(M, 8213344)
    f5 = f5 * rf(M, 8210444)
    f4 = f4 + f5
    f4 = f4 + rf(M, 8218604)
    wfd(8217524, f4)
    f4 = f4 * rf(M, 8218296)
    f3 = f3 + f4
    f4 = rf(M, 8213356)
    f4 = f4 * rf(M, 8218520)
    wfd(8210440, f4)
    f4 = rf(M, 8213340)
    f4 = f4 * rf(M, 8210440)
    f5 = rf(M, 8213360)
    f5 = f5 * rf(M, 8218528)
    wfd(8210472, f5)
    f5 = rf(M, 8213344)
    f5 = f5 * rf(M, 8210472)
    f4 = f4 + f5
    f4 = f4 + rf(M, 8218564)
    wfd(8217536, f4)
    f4 = f4 * rf(M, 8218220)
    f3 = f3 + f4
    wfd(8210476, f3)
    f3 = f3 * rf(M, 8218192)
    f2 = f2 + f3
    f3 = rf(M, 8213348)
    f3 = f3 * rf(M, 8210456)
    f4 = rf(M, 8213352)
    f4 = f4 * rf(M, 8210452)
    f3 = f3 + f4
    f3 = f3 + rf(M, 8218600)
    wfd(8217516, f3)
    f3 = f3 * rf(M, 8218192)
    f4 = rf(M, 8213348)
    f4 = f4 * rf(M, 8210448)
    f5 = rf(M, 8213352)
    f5 = f5 * rf(M, 8210444)
    f4 = f4 + f5
    f4 = f4 + rf(M, 8218608)
    wfd(8217528, f4)
    f4 = f4 * rf(M, 8218296)
    f3 = f3 + f4
    f4 = rf(M, 8213348)
    f4 = f4 * rf(M, 8210440)
    f5 = rf(M, 8213352)
    f5 = f5 * rf(M, 8210472)
    f4 = f4 + f5
    f4 = f4 + rf(M, 8218616)
    wfd(8217540, f4)
    f4 = f4 * rf(M, 8218220)
    f3 = f3 + f4
    wfd(8210480, f3)
    f3 = f3 * rf(M, 8218296)
    f2 = f2 + f3
    f3 = rf(M, 8213356)
    f3 = f3 * rf(M, 8210456)
    f4 = rf(M, 8213360)
    f4 = f4 * rf(M, 8210452)
    f3 = f3 + f4
    f3 = f3 + rf(M, 8218552)
    wfd(8217520, f3)
    f3 = f3 * rf(M, 8218192)
    f4 = rf(M, 8213356)
    f4 = f4 * rf(M, 8210448)
    f5 = rf(M, 8213360)
    f5 = f5 * rf(M, 8210444)
    f4 = f4 + f5
    f4 = f4 + rf(M, 8218612)
    wfd(8217532, f4)
    f4 = f4 * rf(M, 8218296)
    f3 = f3 + f4
    f4 = rf(M, 8213356)
    f4 = f4 * rf(M, 8210440)
    f5 = rf(M, 8213360)
    f5 = f5 * rf(M, 8210472)
    f4 = f4 + f5
    f4 = f4 + rf(M, 8218572)
    wfd(8217544, f4)
    f4 = f4 * rf(M, 8218220)
    f3 = f3 + f4
    wfd(8210472, f3)
    f3 = f3 * rf(M, 8218220)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8213736)
    f2 = f2 * rf(M, 8210380)
    f3 = rf(M, 8213744)
    f3 = f3 * rf(M, 8210384)
    f2 = f2 + f3
    f3 = rf(M, 8213756)
    f3 = f3 * rf(M, 8210388)
    f2 = f2 + f3
    f3 = rf(M, 8217556)
    f3 = f3 * rf(M, 8213736)
    f4 = rf(M, 8217576)
    f4 = f4 * rf(M, 8213744)
    f3 = f3 + f4
    f4 = rf(M, 8213892)
    f4 = f4 * rf(M, 8210296)
    f5 = rf(M, 8213896)
    f5 = f5 * rf(M, 8210300)
    f4 = f4 + f5
    f4 = f4 + rf(M, 8218676)
    f5 = rf(M, 8214060)
    f5 = f5 * rf(M, 8210328)
    f6 = rf(M, 8214064)
    f6 = f6 * rf(M, 8210332)
    f5 = f5 + f6
    f5 = f5 + rf(M, 8218736)
    f4 = f4 + f5
    wfd(8217648, f4)
    f4 = f4 * rf(M, 8213748)
    f3 = f3 + f4
    f4 = rf(M, 8213892)
    f4 = f4 * rf(M, 8218684)
    f5 = rf(M, 8213896)
    f5 = f5 * rf(M, 8218688)
    f4 = f4 + f5
    f5 = rf(M, 8214060)
    f5 = f5 * rf(M, 8218744)
    f6 = rf(M, 8214064)
    f6 = f6 * rf(M, 8218748)
    f5 = f5 + f6
    f4 = f4 + f5
    wfd(8217668, f4)
    f4 = f4 * rf(M, 8213760)
    f3 = f3 + f4
    wfd(8210440, f3)
    f3 = f3 * rf(M, 8218352)
    f2 = f2 + f3
    f3 = rf(M, 8217560)
    f3 = f3 * rf(M, 8213736)
    f4 = rf(M, 8217580)
    f4 = f4 * rf(M, 8213744)
    f3 = f3 + f4
    f4 = rf(M, 8213904)
    f4 = f4 * rf(M, 8210296)
    f5 = rf(M, 8213912)
    f5 = f5 * rf(M, 8210300)
    f4 = f4 + f5
    f4 = f4 + rf(M, 8218680)
    f4 = f4 + rf(M, 8218144)
    f5 = rf(M, 8214072)
    f5 = f5 * rf(M, 8210328)
    f6 = rf(M, 8214080)
    f6 = f6 * rf(M, 8210332)
    f5 = f5 + f6
    f5 = f5 + rf(M, 8218740)
    f4 = f4 + f5
    wfd(8217652, f4)
    f4 = f4 * rf(M, 8213748)
    f3 = f3 + f4
    f4 = rf(M, 8213904)
    f4 = f4 * rf(M, 8218684)
    f5 = rf(M, 8213912)
    f5 = f5 * rf(M, 8218688)
    f4 = f4 + f5
    f5 = rf(M, 8214072)
    f5 = f5 * rf(M, 8218744)
    f6 = rf(M, 8214080)
    f6 = f6 * rf(M, 8218748)
    f5 = f5 + f6
    f4 = f4 + f5
    wfd(8217672, f4)
    f4 = f4 * rf(M, 8213760)
    f3 = f3 + f4
    wfd(8210444, f3)
    f3 = rf(M, 8213748)
    f3 = f3 * rf(M, 8210444)
    f2 = f2 + f3
    f3 = rf(M, 8213736)
    f3 = f3 * rf(M, 8218764)
    f4 = rf(M, 8217584)
    f4 = f4 * rf(M, 8213744)
    f3 = f3 + f4
    f4 = rf(M, 8210296)
    f4 = f4 * rf(M, 8218640)
    f5 = rf(M, 8210300)
    f5 = f5 * rf(M, 8218644)
    f4 = f4 + f5
    f5 = rf(M, 8210328)
    f5 = f5 * rf(M, 8218708)
    f6 = rf(M, 8210332)
    f6 = f6 * rf(M, 8218712)
    f5 = f5 + f6
    f4 = f4 + f5
    wfd(8217656, f4)
    f4 = f4 * rf(M, 8213748)
    f3 = f3 + f4
    f4 = rf(M, 8213760)
    f4 = f4 * rf(M, 8218772)
    f3 = f3 + f4
    wfd(8210332, f3)
    f3 = rf(M, 8213760)
    f3 = f3 * rf(M, 8210332)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217432, f1)
  end
  local function C8()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8217304)
    f1 = f1 * rf(M, 8210272)
    f1 = rf(M, 8217432) - f1
    f2 = rf(M, 8210424)
    f2 = f2 * rf(M, 8214756)
    f3 = rf(M, 8210420)
    f3 = f3 * rf(M, 8214764)
    f2 = f2 + f3
    f3 = rf(M, 8210392)
    f3 = f3 * rf(M, 8214768)
    f2 = f2 + f3
    f2 = f2 + rf(M, 8218492)
    f3 = rf(M, 8210428)
    f3 = f3 * rf(M, 8214756)
    f4 = rf(M, 8210432)
    f4 = f4 * rf(M, 8214764)
    f3 = f3 + f4
    f4 = rf(M, 8210436)
    f4 = f4 * rf(M, 8214768)
    f3 = f3 + f4
    f2 = f2 + f3
    f3 = rf(M, 8212628)
    f3 = f3 * rf(M, 8210144)
    f4 = rf(M, 8212636)
    f4 = f4 * rf(M, 8210148)
    f3 = f3 + f4
    f4 = rf(M, 8212644)
    f4 = f4 * rf(M, 8210136)
    f3 = f3 + f4
    f2 = f2 + f3
    f3 = rf(M, 8213148)
    f3 = f3 * rf(M, 8210204)
    f4 = rf(M, 8213156)
    f4 = f4 * rf(M, 8210216)
    f3 = f3 + f4
    f4 = rf(M, 8213164)
    f4 = f4 * rf(M, 8210220)
    f3 = f3 + f4
    f2 = f2 + f3
    f3 = rf(M, 8213700)
    f3 = f3 * rf(M, 8210304)
    f4 = rf(M, 8213708)
    f4 = f4 * rf(M, 8210340)
    f3 = f3 + f4
    f4 = rf(M, 8213720)
    f4 = f4 * rf(M, 8210336)
    f3 = f3 + f4
    f2 = f2 + f3
    wfd(8217312, f2)
    f2 = rf(M, 8217288)
    f2 = f2 * rf(M, 8210308)
    f2 = rf(M, 8217312) - f2
    wfd(8210328, f2)
    q = fd(f2)
    if q < TINY and q > -TINY then f2 = 1 else f2 = 1 / q end
    wfd(8210300, f2)
    f2 = rf(M, 8214764)
    f2 = f2 * rf(M, 8218484)
    f3 = rf(M, 8210396)
    f3 = f3 * rf(M, 8214764)
    f2 = f2 + f3
    f3 = rf(M, 8212628)
    f3 = f3 * rf(M, 8210188)
    f4 = rf(M, 8212636)
    f4 = f4 * rf(M, 8210192)
    f3 = f3 + f4
    f4 = rf(M, 8212644)
    f4 = f4 * rf(M, 8210196)
    f3 = f3 + f4
    f2 = f2 + f3
    f3 = rf(M, 8213148)
    f3 = f3 * rf(M, 8210260)
    f4 = rf(M, 8213156)
    f4 = f4 * rf(M, 8210264)
    f3 = f3 + f4
    f4 = rf(M, 8213164)
    f4 = f4 * rf(M, 8210268)
    f3 = f3 + f4
    f2 = f2 + f3
    f3 = rf(M, 8213700)
    f3 = f3 * rf(M, 8210380)
    f4 = rf(M, 8213708)
    f4 = f4 * rf(M, 8210384)
    f3 = f3 + f4
    f4 = rf(M, 8213720)
    f4 = f4 * rf(M, 8210388)
    f3 = f3 + f4
    f2 = f2 + f3
    wfd(8217384, f2)
    f2 = rf(M, 8217288)
    f2 = f2 * rf(M, 8210272)
    f2 = rf(M, 8217384) - f2
    f2 = f2 * rf(M, 8210300)
    wfd(8210296, f2)
    f2 = rf(M, 8210420)
    f2 = f2 * rf(M, 8218164)
    f3 = rf(M, 8210432)
    f3 = f3 * rf(M, 8218176)
    f2 = f2 + f3
    f3 = rf(M, 8212656)
    f3 = f3 * rf(M, 8210144)
    f4 = rf(M, 8212664)
    f4 = f4 * rf(M, 8210148)
    f3 = f3 + f4
    f4 = rf(M, 8212672)
    f4 = f4 * rf(M, 8210136)
    f3 = f3 + f4
    f2 = f2 + f3
    f3 = rf(M, 8213176)
    f3 = f3 * rf(M, 8210204)
    f4 = rf(M, 8213184)
    f4 = f4 * rf(M, 8210216)
    f3 = f3 + f4
    f4 = rf(M, 8213192)
    f4 = f4 * rf(M, 8210220)
    f3 = f3 + f4
    f2 = f2 + f3
    f3 = rf(M, 8213736)
    f3 = f3 * rf(M, 8210304)
    f4 = rf(M, 8213744)
    f4 = f4 * rf(M, 8210340)
    f3 = f3 + f4
    f4 = rf(M, 8213756)
    f4 = f4 * rf(M, 8210336)
    f3 = f3 + f4
    f4 = rf(M, 8217556)
    f4 = f4 * rf(M, 8213700)
    f5 = rf(M, 8217576)
    f5 = f5 * rf(M, 8213708)
    f4 = f4 + f5
    wfd(8210448, f4)
    f4 = f4 * rf(M, 8218352)
    f3 = f3 + f4
    f4 = rf(M, 8217560)
    f4 = f4 * rf(M, 8213700)
    f5 = rf(M, 8217580)
    f5 = f5 * rf(M, 8213708)
    f4 = f4 + f5
    wfd(8210452, f4)
    f4 = rf(M, 8213748)
    f4 = f4 * rf(M, 8210452)
    f3 = f3 + f4
    f4 = rf(M, 8213700)
    f4 = f4 * rf(M, 8218764)
    f5 = rf(M, 8217584)
    f5 = f5 * rf(M, 8213708)
    f4 = f4 + f5
    wfd(8210456, f4)
    f4 = rf(M, 8213760)
    f4 = f4 * rf(M, 8210456)
    f3 = f3 + f4
    f2 = f2 + f3
    wfd(8217328, f2)
    f2 = rf(M, 8217304)
    f2 = f2 * rf(M, 8210308)
    f2 = rf(M, 8217328) - f2
    wfd(8210484, f2)
    f2 = f2 * rf(M, 8210296)
    f1 = f1 - f2
    f2 = rf(M, 8210276)
    f2 = f2 * rf(M, 8214776)
    f3 = rf(M, 8210212)
    f3 = f3 * rf(M, 8214784)
    f2 = f2 + f3
    f3 = rf(M, 8210200)
    f3 = f3 * rf(M, 8214792)
    f2 = f2 + f3
    f2 = f2 + rf(M, 8218488)
    f3 = rf(M, 8210208)
    f3 = f3 * rf(M, 8214776)
    f4 = rf(M, 8210140)
    f4 = f4 * rf(M, 8214784)
    f3 = f3 + f4
    f4 = rf(M, 8210128)
    f4 = f4 * rf(M, 8214792)
    f3 = f3 + f4
    f2 = f2 + f3
    f3 = rf(M, 8212652)
    f3 = f3 * rf(M, 8210152)
    f4 = rf(M, 8212660)
    f4 = f4 * rf(M, 8210156)
    f3 = f3 + f4
    f4 = rf(M, 8212668)
    f4 = f4 * rf(M, 8210160)
    f3 = f3 + f4
    f2 = f2 + f3
    f3 = rf(M, 8213172)
    f3 = f3 * rf(M, 8210224)
    f4 = rf(M, 8213180)
    f4 = f4 * rf(M, 8210228)
    f3 = f3 + f4
    f4 = rf(M, 8213188)
    f4 = f4 * rf(M, 8210232)
    f3 = f3 + f4
    f2 = f2 + f3
    f3 = rf(M, 8213732)
    f3 = f3 * rf(M, 8210344)
    f4 = rf(M, 8213740)
    f4 = f4 * rf(M, 8210348)
    f3 = f3 + f4
    f4 = rf(M, 8213752)
    f4 = f4 * rf(M, 8210352)
    f3 = f3 + f4
    f2 = f2 + f3
    wfd(8217340, f2)
    f2 = rf(M, 8217292)
    f2 = f2 * rf(M, 8210132)
    f2 = rf(M, 8217340) - f2
    f3 = rf(M, 8210276)
    f3 = f3 * rf(M, 8214756)
    f4 = rf(M, 8210212)
    f4 = f4 * rf(M, 8214764)
    f3 = f3 + f4
    f4 = rf(M, 8210200)
    f4 = f4 * rf(M, 8214768)
    f3 = f3 + f4
    f4 = rf(M, 8210208)
    f4 = f4 * rf(M, 8214756)
    f5 = rf(M, 8210140)
    f5 = f5 * rf(M, 8214764)
    f4 = f4 + f5
    f5 = rf(M, 8210128)
    f5 = f5 * rf(M, 8214768)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8212628)
    f4 = f4 * rf(M, 8210152)
    f5 = rf(M, 8212636)
    f5 = f5 * rf(M, 8210156)
    f4 = f4 + f5
    f5 = rf(M, 8212644)
    f5 = f5 * rf(M, 8210160)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8213148)
    f4 = f4 * rf(M, 8210224)
    f5 = rf(M, 8213156)
    f5 = f5 * rf(M, 8210228)
    f4 = f4 + f5
    f5 = rf(M, 8213164)
    f5 = f5 * rf(M, 8210232)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8213700)
    f4 = f4 * rf(M, 8210344)
    f5 = rf(M, 8213708)
    f5 = f5 * rf(M, 8210348)
    f4 = f4 + f5
    f5 = rf(M, 8213720)
    f5 = f5 * rf(M, 8210352)
    f4 = f4 + f5
    f3 = f3 + f4
    wfd(8217336, f3)
    f3 = rf(M, 8217288)
    f3 = f3 * rf(M, 8210132)
    f3 = rf(M, 8217336) - f3
    f3 = f3 * rf(M, 8210300)
    wfd(8210488, f3)
    f3 = rf(M, 8210424)
    f3 = f3 * rf(M, 8214776)
    f4 = rf(M, 8210420)
    f4 = f4 * rf(M, 8214784)
    f3 = f3 + f4
    f4 = rf(M, 8210392)
    f4 = f4 * rf(M, 8214792)
    f3 = f3 + f4
    f4 = rf(M, 8210428)
    f4 = f4 * rf(M, 8214776)
    f5 = rf(M, 8210432)
    f5 = f5 * rf(M, 8214784)
    f4 = f4 + f5
    f5 = rf(M, 8210436)
    f5 = f5 * rf(M, 8214792)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8212652)
    f4 = f4 * rf(M, 8210144)
    f5 = rf(M, 8212660)
    f5 = f5 * rf(M, 8210148)
    f4 = f4 + f5
    f5 = rf(M, 8212668)
    f5 = f5 * rf(M, 8210136)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8213172)
    f4 = f4 * rf(M, 8210204)
    f5 = rf(M, 8213180)
    f5 = f5 * rf(M, 8210216)
    f4 = f4 + f5
    f5 = rf(M, 8213188)
    f5 = f5 * rf(M, 8210220)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8213732)
    f4 = f4 * rf(M, 8210304)
    f5 = rf(M, 8213740)
    f5 = f5 * rf(M, 8210340)
    f4 = f4 + f5
    f5 = rf(M, 8213752)
    f5 = f5 * rf(M, 8210336)
    f4 = f4 + f5
    f3 = f3 + f4
    wfd(8217316, f3)
    f3 = rf(M, 8217292)
    f3 = f3 * rf(M, 8210308)
    f3 = rf(M, 8217316) - f3
    wfd(8210492, f3)
    f3 = f3 * rf(M, 8210488)
    f2 = f2 - f3
    wfd(8210496, f2)
    q = fd(f2)
    if q < TINY and q > -TINY then f2 = 1 else f2 = 1 / q end
    wfd(8210500, f2)
    f2 = rf(M, 8214784)
    f2 = f2 * rf(M, 8218480)
    f3 = rf(M, 8210396)
    f3 = f3 * rf(M, 8214784)
    f2 = f2 + f3
    f3 = rf(M, 8212652)
    f3 = f3 * rf(M, 8210188)
    f4 = rf(M, 8212660)
    f4 = f4 * rf(M, 8210192)
    f3 = f3 + f4
    f4 = rf(M, 8212668)
    f4 = f4 * rf(M, 8210196)
    f3 = f3 + f4
    f2 = f2 + f3
    f3 = rf(M, 8213172)
    f3 = f3 * rf(M, 8210260)
    f4 = rf(M, 8213180)
    f4 = f4 * rf(M, 8210264)
    f3 = f3 + f4
    f4 = rf(M, 8213188)
    f4 = f4 * rf(M, 8210268)
    f3 = f3 + f4
    f2 = f2 + f3
    f3 = rf(M, 8213732)
    f3 = f3 * rf(M, 8210380)
    f4 = rf(M, 8213740)
    f4 = f4 * rf(M, 8210384)
    f3 = f3 + f4
    f4 = rf(M, 8213752)
    f4 = f4 * rf(M, 8210388)
    f3 = f3 + f4
    f2 = f2 + f3
    wfd(8217388, f2)
    f2 = rf(M, 8217292)
    f2 = f2 * rf(M, 8210272)
    f2 = rf(M, 8217388) - f2
    f3 = rf(M, 8210492)
    f3 = f3 * rf(M, 8210296)
    f2 = f2 - f3
    f2 = f2 * rf(M, 8210500)
    wfd(8210504, f2)
    f2 = rf(M, 8210212)
    f2 = f2 * rf(M, 8218164)
    f3 = rf(M, 8210140)
    f3 = f3 * rf(M, 8218176)
    f2 = f2 + f3
    f3 = rf(M, 8212656)
    f3 = f3 * rf(M, 8210152)
    f4 = rf(M, 8212664)
    f4 = f4 * rf(M, 8210156)
    f3 = f3 + f4
    f4 = rf(M, 8212672)
    f4 = f4 * rf(M, 8210160)
    f3 = f3 + f4
    f2 = f2 + f3
    f3 = rf(M, 8213176)
    f3 = f3 * rf(M, 8210224)
    f4 = rf(M, 8213184)
    f4 = f4 * rf(M, 8210228)
    f3 = f3 + f4
    f4 = rf(M, 8213192)
    f4 = f4 * rf(M, 8210232)
    f3 = f3 + f4
    f2 = f2 + f3
    f3 = rf(M, 8213736)
    f3 = f3 * rf(M, 8210344)
    f4 = rf(M, 8213744)
    f4 = f4 * rf(M, 8210348)
    f3 = f3 + f4
    f4 = rf(M, 8213756)
    f4 = f4 * rf(M, 8210352)
    f3 = f3 + f4
    f4 = rf(M, 8217556)
    f4 = f4 * rf(M, 8213732)
    f5 = rf(M, 8217576)
    f5 = f5 * rf(M, 8213740)
    f4 = f4 + f5
    wfd(8210508, f4)
    f4 = f4 * rf(M, 8218352)
    f3 = f3 + f4
    f4 = rf(M, 8217560)
    f4 = f4 * rf(M, 8213732)
    f5 = rf(M, 8217580)
    f5 = f5 * rf(M, 8213740)
    f4 = f4 + f5
    wfd(8210512, f4)
    f4 = rf(M, 8213748)
    f4 = f4 * rf(M, 8210512)
    f3 = f3 + f4
    f4 = rf(M, 8213732)
    f4 = f4 * rf(M, 8218760)
    f5 = rf(M, 8217584)
    f5 = f5 * rf(M, 8213740)
    f4 = f4 + f5
    wfd(8210516, f4)
    f4 = rf(M, 8213760)
    f4 = f4 * rf(M, 8210516)
    f3 = f3 + f4
    f2 = f2 + f3
    wfd(8217352, f2)
    f2 = rf(M, 8217304)
    f2 = f2 * rf(M, 8210132)
    f2 = rf(M, 8217352) - f2
    f3 = rf(M, 8210484)
    f3 = f3 * rf(M, 8210488)
    f2 = f2 - f3
    wfd(8210520, f2)
    f2 = f2 * rf(M, 8210504)
    f1 = f1 - f2
    r_eax = ru(M, 8211876)
    wu(M, 8217404, r_eax)
    f2 = rf(M, 8210416)
    f2 = f2 * rf(M, 8218428)
    f2 = f2 + rf(M, 8217404)
    f2 = f2 + rf(M, 8218504)
    f3 = rf(M, 8212608)
    f3 = f3 * rf(M, 8210164)
    f4 = rf(M, 8212616)
    f4 = f4 * rf(M, 8210168)
    f3 = f3 + f4
    f4 = rf(M, 8212624)
    f4 = f4 * rf(M, 8210172)
    f3 = f3 + f4
    f4 = rf(M, 8217448)
    f4 = f4 * rf(M, 8218188)
    f5 = rf(M, 8217460)
    f5 = f5 * rf(M, 8218196)
    f4 = f4 + f5
    f5 = rf(M, 8217472)
    f5 = f5 * rf(M, 8218208)
    f4 = f4 + f5
    wfd(8210524, f4)
    f4 = f4 * rf(M, 8218188)
    f3 = f3 + f4
    f4 = rf(M, 8217452)
    f4 = f4 * rf(M, 8218188)
    f5 = rf(M, 8217464)
    f5 = f5 * rf(M, 8218196)
    f4 = f4 + f5
    f5 = rf(M, 8217476)
    f5 = f5 * rf(M, 8218208)
    f4 = f4 + f5
    wfd(8210528, f4)
    f4 = f4 * rf(M, 8218196)
    f3 = f3 + f4
    f4 = rf(M, 8217456)
    f4 = f4 * rf(M, 8218188)
    f5 = rf(M, 8217468)
    f5 = f5 * rf(M, 8218196)
    f4 = f4 + f5
    f5 = rf(M, 8217480)
    f5 = f5 * rf(M, 8218208)
    f4 = f4 + f5
    wfd(8210532, f4)
    f4 = f4 * rf(M, 8218208)
    f3 = f3 + f4
    f2 = f2 + f3
    f3 = rf(M, 8213128)
    f3 = f3 * rf(M, 8210236)
    f4 = rf(M, 8213136)
    f4 = f4 * rf(M, 8210240)
    f3 = f3 + f4
    f4 = rf(M, 8213144)
    f4 = f4 * rf(M, 8210244)
    f3 = f3 + f4
    f4 = rf(M, 8217512)
    f4 = f4 * rf(M, 8218188)
    f5 = rf(M, 8217524)
    f5 = f5 * rf(M, 8218292)
    f4 = f4 + f5
    f5 = rf(M, 8217536)
    f5 = f5 * rf(M, 8218208)
    f4 = f4 + f5
    wfd(8210536, f4)
    f4 = f4 * rf(M, 8218188)
    f3 = f3 + f4
    f4 = rf(M, 8217516)
    f4 = f4 * rf(M, 8218188)
    f5 = rf(M, 8217528)
    f5 = f5 * rf(M, 8218292)
    f4 = f4 + f5
    f5 = rf(M, 8217540)
    f5 = f5 * rf(M, 8218208)
    f4 = f4 + f5
    wfd(8210540, f4)
    f4 = f4 * rf(M, 8218292)
    f3 = f3 + f4
    f4 = rf(M, 8217520)
    f4 = f4 * rf(M, 8218188)
    f5 = rf(M, 8217532)
    f5 = f5 * rf(M, 8218292)
    f4 = f4 + f5
    f5 = rf(M, 8217544)
    f5 = f5 * rf(M, 8218208)
    f4 = f4 + f5
    wfd(8210544, f4)
    f4 = f4 * rf(M, 8218208)
    f3 = f3 + f4
    f2 = f2 + f3
    f3 = rf(M, 8213672)
    f3 = f3 * rf(M, 8210356)
    f4 = rf(M, 8213680)
    f4 = f4 * rf(M, 8210360)
    f3 = f3 + f4
    f4 = rf(M, 8213692)
    f4 = f4 * rf(M, 8210364)
    f3 = f3 + f4
    f4 = rf(M, 8217556)
    f4 = f4 * rf(M, 8213672)
    f5 = rf(M, 8217576)
    f5 = f5 * rf(M, 8213680)
    f4 = f4 + f5
    f5 = rf(M, 8217648)
    f5 = f5 * rf(M, 8213684)
    f4 = f4 + f5
    f5 = rf(M, 8217668)
    f5 = f5 * rf(M, 8213696)
    f4 = f4 + f5
    wfd(8210548, f4)
    f4 = f4 * rf(M, 8218348)
    f3 = f3 + f4
    f4 = rf(M, 8217560)
    f4 = f4 * rf(M, 8213672)
    f5 = rf(M, 8217580)
    f5 = f5 * rf(M, 8213680)
    f4 = f4 + f5
    f5 = rf(M, 8217652)
    f5 = f5 * rf(M, 8213684)
    f4 = f4 + f5
    f5 = rf(M, 8217672)
    f5 = f5 * rf(M, 8213696)
    f4 = f4 + f5
    wfd(8210552, f4)
    f4 = rf(M, 8213684)
    f4 = f4 * rf(M, 8210552)
    f3 = f3 + f4
    f4 = rf(M, 8213672)
    f4 = f4 * rf(M, 8218764)
    f5 = rf(M, 8217584)
    f5 = f5 * rf(M, 8213680)
    f4 = f4 + f5
    f5 = rf(M, 8217656)
    f5 = f5 * rf(M, 8213684)
    f4 = f4 + f5
    f5 = rf(M, 8213696)
    f5 = f5 * rf(M, 8218772)
    f4 = f4 + f5
    wfd(8210556, f4)
    f4 = rf(M, 8213696)
    f4 = f4 * rf(M, 8210556)
    f3 = f3 + f4
    f2 = f2 + f3
    wfd(8217416, f2)
    f2 = rf(M, 8217296)
    f2 = f2 * rf(M, 8210412)
    f2 = rf(M, 8217416) - f2
    f3 = rf(M, 8214764)
    f3 = f3 * rf(M, 8218464)
    f4 = rf(M, 8210416)
    f4 = f4 * rf(M, 8214764)
    f3 = f3 + f4
    f4 = rf(M, 8212628)
    f4 = f4 * rf(M, 8210164)
    f5 = rf(M, 8212636)
    f5 = f5 * rf(M, 8210168)
    f4 = f4 + f5
    f5 = rf(M, 8212644)
    f5 = f5 * rf(M, 8210172)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8213148)
    f4 = f4 * rf(M, 8210236)
    f5 = rf(M, 8213156)
    f5 = f5 * rf(M, 8210240)
    f4 = f4 + f5
    f5 = rf(M, 8213164)
    f5 = f5 * rf(M, 8210244)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8213700)
    f4 = f4 * rf(M, 8210356)
    f5 = rf(M, 8213708)
    f5 = f5 * rf(M, 8210360)
    f4 = f4 + f5
    f5 = rf(M, 8213720)
    f5 = f5 * rf(M, 8210364)
    f4 = f4 + f5
    f3 = f3 + f4
    wfd(8217360, f3)
    f3 = rf(M, 8217288)
    f3 = f3 * rf(M, 8210412)
    f3 = rf(M, 8217360) - f3
    f3 = f3 * rf(M, 8210300)
    wfd(8210560, f3)
    f3 = rf(M, 8210420)
    f3 = f3 * rf(M, 8218448)
    f4 = rf(M, 8210432)
    f4 = f4 * rf(M, 8218428)
    f3 = f3 + f4
    f4 = rf(M, 8212608)
    f4 = f4 * rf(M, 8210144)
    f5 = rf(M, 8212616)
    f5 = f5 * rf(M, 8210148)
    f4 = f4 + f5
    f5 = rf(M, 8212624)
    f5 = f5 * rf(M, 8210136)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8213128)
    f4 = f4 * rf(M, 8210204)
    f5 = rf(M, 8213136)
    f5 = f5 * rf(M, 8210216)
    f4 = f4 + f5
    f5 = rf(M, 8213144)
    f5 = f5 * rf(M, 8210220)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8213672)
    f4 = f4 * rf(M, 8210304)
    f5 = rf(M, 8213680)
    f5 = f5 * rf(M, 8210340)
    f4 = f4 + f5
    f5 = rf(M, 8213692)
    f5 = f5 * rf(M, 8210336)
    f4 = f4 + f5
    f5 = rf(M, 8210448)
    f5 = f5 * rf(M, 8218348)
    f4 = f4 + f5
    f5 = rf(M, 8213684)
    f5 = f5 * rf(M, 8210452)
    f4 = f4 + f5
    f5 = rf(M, 8213696)
    f5 = f5 * rf(M, 8210456)
    f4 = f4 + f5
    f3 = f3 + f4
    wfd(8217320, f3)
    f3 = rf(M, 8217296)
    f3 = f3 * rf(M, 8210308)
    f3 = rf(M, 8217320) - f3
    wfd(8210432, f3)
    f3 = f3 * rf(M, 8210560)
    f2 = f2 - f3
    f3 = rf(M, 8214784)
    f3 = f3 * rf(M, 8218460)
    f4 = rf(M, 8210416)
    f4 = f4 * rf(M, 8214784)
    f3 = f3 + f4
    f4 = rf(M, 8212652)
    f4 = f4 * rf(M, 8210164)
    f5 = rf(M, 8212660)
    f5 = f5 * rf(M, 8210168)
    f4 = f4 + f5
    f5 = rf(M, 8212668)
    f5 = f5 * rf(M, 8210172)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8213172)
    f4 = f4 * rf(M, 8210236)
    f5 = rf(M, 8213180)
    f5 = f5 * rf(M, 8210240)
    f4 = f4 + f5
    f5 = rf(M, 8213188)
    f5 = f5 * rf(M, 8210244)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8213732)
    f4 = f4 * rf(M, 8210356)
    f5 = rf(M, 8213740)
    f5 = f5 * rf(M, 8210360)
    f4 = f4 + f5
    f5 = rf(M, 8213752)
    f5 = f5 * rf(M, 8210364)
    f4 = f4 + f5
    f3 = f3 + f4
    wfd(8217364, f3)
    f3 = rf(M, 8217292)
    f3 = f3 * rf(M, 8210412)
    f3 = rf(M, 8217364) - f3
    f4 = rf(M, 8210492)
    f4 = f4 * rf(M, 8210560)
    f3 = f3 - f4
    f3 = f3 * rf(M, 8210500)
    wfd(8210420, f3)
    f3 = rf(M, 8210212)
    f3 = f3 * rf(M, 8218448)
    f4 = rf(M, 8210140)
    f4 = f4 * rf(M, 8218428)
    f3 = f3 + f4
    f4 = rf(M, 8212608)
    f4 = f4 * rf(M, 8210152)
    f5 = rf(M, 8212616)
    f5 = f5 * rf(M, 8210156)
    f4 = f4 + f5
    f5 = rf(M, 8212624)
    f5 = f5 * rf(M, 8210160)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8213128)
    f4 = f4 * rf(M, 8210224)
    f5 = rf(M, 8213136)
    f5 = f5 * rf(M, 8210228)
    f4 = f4 + f5
    f5 = rf(M, 8213144)
    f5 = f5 * rf(M, 8210232)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8213672)
    f4 = f4 * rf(M, 8210344)
    f5 = rf(M, 8213680)
    f5 = f5 * rf(M, 8210348)
    f4 = f4 + f5
    f5 = rf(M, 8213692)
    f5 = f5 * rf(M, 8210352)
    f4 = f4 + f5
    f5 = rf(M, 8210508)
    f5 = f5 * rf(M, 8218348)
    f4 = f4 + f5
    f5 = rf(M, 8213684)
    f5 = f5 * rf(M, 8210512)
    f4 = f4 + f5
    f5 = rf(M, 8213696)
    f5 = f5 * rf(M, 8210516)
    f4 = f4 + f5
    f3 = f3 + f4
    wfd(8217344, f3)
    f3 = rf(M, 8217296)
    f3 = f3 * rf(M, 8210132)
    f3 = rf(M, 8217344) - f3
    f4 = rf(M, 8210432)
    f4 = f4 * rf(M, 8210488)
    f3 = f3 - f4
    wfd(8210140, f3)
    f3 = f3 * rf(M, 8210420)
    f2 = f2 - f3
    wfd(8210212, f2)
    q = fd(f2)
    if q < TINY and q > -TINY then f2 = 1 else f2 = 1 / q end
    wfd(8210564, f2)
    f2 = rf(M, 8210396)
    f2 = f2 * rf(M, 8218428)
    f2 = f2 + rf(M, 8218508)
    f3 = rf(M, 8212608)
    f3 = f3 * rf(M, 8210188)
    f4 = rf(M, 8212616)
    f4 = f4 * rf(M, 8210192)
    f3 = f3 + f4
    f4 = rf(M, 8212624)
    f4 = f4 * rf(M, 8210196)
    f3 = f3 + f4
    f4 = rf(M, 8210464)
    f4 = f4 * rf(M, 8218188)
    f3 = f3 + f4
    f4 = rf(M, 8210468)
    f4 = f4 * rf(M, 8218196)
    f3 = f3 + f4
    f4 = rf(M, 8210460)
    f4 = f4 * rf(M, 8218208)
    f3 = f3 + f4
    f2 = f2 + f3
    f3 = rf(M, 8213128)
    f3 = f3 * rf(M, 8210260)
    f4 = rf(M, 8213136)
    f4 = f4 * rf(M, 8210264)
    f3 = f3 + f4
    f4 = rf(M, 8213144)
    f4 = f4 * rf(M, 8210268)
    f3 = f3 + f4
    f4 = rf(M, 8210476)
    f4 = f4 * rf(M, 8218188)
    f3 = f3 + f4
    f4 = rf(M, 8210480)
    f4 = f4 * rf(M, 8218292)
    f3 = f3 + f4
    f4 = rf(M, 8210472)
    f4 = f4 * rf(M, 8218208)
    f3 = f3 + f4
    f2 = f2 + f3
    f3 = rf(M, 8213672)
    f3 = f3 * rf(M, 8210380)
    f4 = rf(M, 8213680)
    f4 = f4 * rf(M, 8210384)
    f3 = f3 + f4
    f4 = rf(M, 8213692)
    f4 = f4 * rf(M, 8210388)
    f3 = f3 + f4
    f4 = rf(M, 8210440)
    f4 = f4 * rf(M, 8218348)
    f3 = f3 + f4
    f4 = rf(M, 8213684)
    f4 = f4 * rf(M, 8210444)
    f3 = f3 + f4
    f4 = rf(M, 8213696)
    f4 = f4 * rf(M, 8210332)
    f3 = f3 + f4
    f2 = f2 + f3
    wfd(8217428, f2)
    f2 = rf(M, 8217296)
    f2 = f2 * rf(M, 8210272)
    f2 = rf(M, 8217428) - f2
    f3 = rf(M, 8210432)
    f3 = f3 * rf(M, 8210296)
    f2 = f2 - f3
    f3 = rf(M, 8210140)
    f3 = f3 * rf(M, 8210504)
    f2 = f2 - f3
    f2 = f2 * rf(M, 8210564)
    wfd(8210476, f2)
    f2 = rf(M, 8210416)
    f2 = f2 * rf(M, 8218176)
    f2 = f2 + rf(M, 8218508)
    f3 = rf(M, 8212656)
    f3 = f3 * rf(M, 8210164)
    f4 = rf(M, 8212664)
    f4 = f4 * rf(M, 8210168)
    f3 = f3 + f4
    f4 = rf(M, 8212672)
    f4 = f4 * rf(M, 8210172)
    f3 = f3 + f4
    f4 = rf(M, 8210524)
    f4 = f4 * rf(M, 8218192)
    f3 = f3 + f4
    f4 = rf(M, 8210528)
    f4 = f4 * rf(M, 8218204)
    f3 = f3 + f4
    f4 = rf(M, 8210532)
    f4 = f4 * rf(M, 8218220)
    f3 = f3 + f4
    f2 = f2 + f3
    f3 = rf(M, 8213176)
    f3 = f3 * rf(M, 8210236)
    f4 = rf(M, 8213184)
    f4 = f4 * rf(M, 8210240)
    f3 = f3 + f4
    f4 = rf(M, 8213192)
    f4 = f4 * rf(M, 8210244)
    f3 = f3 + f4
    f4 = rf(M, 8210536)
    f4 = f4 * rf(M, 8218192)
    f3 = f3 + f4
    f4 = rf(M, 8210540)
    f4 = f4 * rf(M, 8218296)
    f3 = f3 + f4
    f4 = rf(M, 8210544)
    f4 = f4 * rf(M, 8218220)
    f3 = f3 + f4
    f2 = f2 + f3
    f3 = rf(M, 8213736)
    f3 = f3 * rf(M, 8210356)
    f4 = rf(M, 8213744)
    f4 = f4 * rf(M, 8210360)
    f3 = f3 + f4
    f4 = rf(M, 8213756)
    f4 = f4 * rf(M, 8210364)
    f3 = f3 + f4
    f4 = rf(M, 8210548)
    f4 = f4 * rf(M, 8218352)
    f3 = f3 + f4
    f4 = rf(M, 8213748)
    f4 = f4 * rf(M, 8210552)
    f3 = f3 + f4
    f4 = rf(M, 8213760)
    f4 = f4 * rf(M, 8210556)
    f3 = f3 + f4
    f2 = f2 + f3
    wfd(8217420, f2)
    f2 = rf(M, 8217304)
    f2 = f2 * rf(M, 8210412)
    f2 = rf(M, 8217420) - f2
    f3 = rf(M, 8210484)
    f3 = f3 * rf(M, 8210560)
    f2 = f2 - f3
    f3 = rf(M, 8210520)
    f3 = f3 * rf(M, 8210420)
    f2 = f2 - f3
    wfd(8210536, f2)
    f2 = f2 * rf(M, 8210476)
    f1 = f1 - f2
    f2 = rf(M, 8212632)
    f2 = f2 * rf(M, 8210188)
    f3 = rf(M, 8212640)
    f3 = f3 * rf(M, 8210192)
    f2 = f2 + f3
    f3 = rf(M, 8212648)
    f3 = f3 * rf(M, 8210196)
    f2 = f2 + f3
    f3 = rf(M, 8210468)
    f3 = f3 * rf(M, 8218200)
    f2 = f2 + f3
    f3 = rf(M, 8210460)
    f3 = f3 * rf(M, 8218212)
    f2 = f2 + f3
    f3 = rf(M, 8213152)
    f3 = f3 * rf(M, 8210260)
    f4 = rf(M, 8213160)
    f4 = f4 * rf(M, 8210264)
    f3 = f3 + f4
    f4 = rf(M, 8213168)
    f4 = f4 * rf(M, 8210268)
    f3 = f3 + f4
    f4 = rf(M, 8210480)
    f4 = f4 * rf(M, 8218200)
    f3 = f3 + f4
    f4 = rf(M, 8210472)
    f4 = f4 * rf(M, 8218304)
    f3 = f3 + f4
    f2 = f2 + f3
    f3 = rf(M, 8213704)
    f3 = f3 * rf(M, 8210380)
    f4 = rf(M, 8213712)
    f4 = f4 * rf(M, 8210384)
    f3 = f3 + f4
    f4 = rf(M, 8213724)
    f4 = f4 * rf(M, 8210388)
    f3 = f3 + f4
    f4 = rf(M, 8213716)
    f4 = f4 * rf(M, 8210444)
    f3 = f3 + f4
    f4 = rf(M, 8213728)
    f4 = f4 * rf(M, 8210332)
    f3 = f3 + f4
    f2 = f2 + f3
    wfd(8217496, f2)
    f2 = rf(M, 8217300)
    f2 = f2 * rf(M, 8210272)
    f2 = rf(M, 8217496) - f2
    f3 = rf(M, 8210424)
    f3 = f3 * rf(M, 8218172)
    f4 = rf(M, 8210392)
    f4 = f4 * rf(M, 8218452)
    f3 = f3 + f4
    f4 = rf(M, 8210428)
    f4 = f4 * rf(M, 8218184)
    f5 = rf(M, 8210436)
    f5 = f5 * rf(M, 8218496)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8212632)
    f4 = f4 * rf(M, 8210144)
    f5 = rf(M, 8212640)
    f5 = f5 * rf(M, 8210148)
    f4 = f4 + f5
    f5 = rf(M, 8212648)
    f5 = f5 * rf(M, 8210136)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8213152)
    f4 = f4 * rf(M, 8210204)
    f5 = rf(M, 8213160)
    f5 = f5 * rf(M, 8210216)
    f4 = f4 + f5
    f5 = rf(M, 8213168)
    f5 = f5 * rf(M, 8210220)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8213704)
    f4 = f4 * rf(M, 8210304)
    f5 = rf(M, 8213712)
    f5 = f5 * rf(M, 8210340)
    f4 = f4 + f5
    f5 = rf(M, 8213724)
    f5 = f5 * rf(M, 8210336)
    f4 = f4 + f5
    f5 = rf(M, 8213716)
    f5 = f5 * rf(M, 8210452)
    f4 = f4 + f5
    f5 = rf(M, 8213728)
    f5 = f5 * rf(M, 8210456)
    f4 = f4 + f5
    f3 = f3 + f4
    wfd(8217324, f3)
    f3 = rf(M, 8217300)
    f3 = f3 * rf(M, 8210308)
    f3 = rf(M, 8217324) - f3
    wfd(8210456, f3)
    f3 = f3 * rf(M, 8210296)
    f2 = f2 - f3
    f3 = rf(M, 8210276)
    f3 = f3 * rf(M, 8218172)
    f4 = rf(M, 8210200)
    f4 = f4 * rf(M, 8218452)
    f3 = f3 + f4
    f4 = rf(M, 8210208)
    f4 = f4 * rf(M, 8218184)
    f5 = rf(M, 8210128)
    f5 = f5 * rf(M, 8218496)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8212632)
    f4 = f4 * rf(M, 8210152)
    f5 = rf(M, 8212640)
    f5 = f5 * rf(M, 8210156)
    f4 = f4 + f5
    f5 = rf(M, 8212648)
    f5 = f5 * rf(M, 8210160)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8213152)
    f4 = f4 * rf(M, 8210224)
    f5 = rf(M, 8213160)
    f5 = f5 * rf(M, 8210228)
    f4 = f4 + f5
    f5 = rf(M, 8213168)
    f5 = f5 * rf(M, 8210232)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8213704)
    f4 = f4 * rf(M, 8210344)
    f5 = rf(M, 8213712)
    f5 = f5 * rf(M, 8210348)
    f4 = f4 + f5
    f5 = rf(M, 8213724)
    f5 = f5 * rf(M, 8210352)
    f4 = f4 + f5
    f5 = rf(M, 8213716)
    f5 = f5 * rf(M, 8210512)
    f4 = f4 + f5
    f5 = rf(M, 8213728)
    f5 = f5 * rf(M, 8210516)
    f4 = f4 + f5
    f3 = f3 + f4
    wfd(8217348, f3)
    f3 = rf(M, 8217300)
    f3 = f3 * rf(M, 8210132)
    f3 = rf(M, 8217348) - f3
    f4 = rf(M, 8210456)
    f4 = f4 * rf(M, 8210488)
    f3 = f3 - f4
    wfd(8210516, f3)
    f3 = f3 * rf(M, 8210504)
    f2 = f2 - f3
    f3 = rf(M, 8212632)
    f3 = f3 * rf(M, 8210164)
    f4 = rf(M, 8212640)
    f4 = f4 * rf(M, 8210168)
    f3 = f3 + f4
    f4 = rf(M, 8212648)
    f4 = f4 * rf(M, 8210172)
    f3 = f3 + f4
    f4 = rf(M, 8210528)
    f4 = f4 * rf(M, 8218200)
    f3 = f3 + f4
    f4 = rf(M, 8210532)
    f4 = f4 * rf(M, 8218212)
    f3 = f3 + f4
    f4 = rf(M, 8213152)
    f4 = f4 * rf(M, 8210236)
    f5 = rf(M, 8213160)
    f5 = f5 * rf(M, 8210240)
    f4 = f4 + f5
    f5 = rf(M, 8213168)
    f5 = f5 * rf(M, 8210244)
    f4 = f4 + f5
    f5 = rf(M, 8210540)
    f5 = f5 * rf(M, 8218200)
    f4 = f4 + f5
    f5 = rf(M, 8210544)
    f5 = f5 * rf(M, 8218304)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8213704)
    f4 = f4 * rf(M, 8210356)
    f5 = rf(M, 8213712)
    f5 = f5 * rf(M, 8210360)
    f4 = f4 + f5
    f5 = rf(M, 8213724)
    f5 = f5 * rf(M, 8210364)
    f4 = f4 + f5
    f5 = rf(M, 8213716)
    f5 = f5 * rf(M, 8210552)
    f4 = f4 + f5
    f5 = rf(M, 8213728)
    f5 = f5 * rf(M, 8210556)
    f4 = f4 + f5
    f3 = f3 + f4
    wfd(8217484, f3)
    f3 = rf(M, 8217300)
    f3 = f3 * rf(M, 8210412)
    f3 = rf(M, 8217484) - f3
    f4 = rf(M, 8210456)
    f4 = f4 * rf(M, 8210560)
    f3 = f3 - f4
    f4 = rf(M, 8210516)
    f4 = f4 * rf(M, 8210420)
    f3 = f3 - f4
    wfd(8210556, f3)
    f3 = f3 * rf(M, 8210476)
    f2 = f2 - f3
    r_eax = ru(M, 8211880)
    wu(M, 8217408, r_eax)
    f3 = rf(M, 8210408)
    f3 = f3 * rf(M, 8218184)
    f4 = rf(M, 8210404)
    f4 = f4 * rf(M, 8218496)
    f3 = f3 + f4
    f3 = f3 + rf(M, 8217408)
    f3 = f3 + rf(M, 8218512)
    f4 = rf(M, 8212632)
    f4 = f4 * rf(M, 8210176)
    f5 = rf(M, 8212640)
    f5 = f5 * rf(M, 8210180)
    f4 = f4 + f5
    f5 = rf(M, 8212648)
    f5 = f5 * rf(M, 8210184)
    f4 = f4 + f5
    f5 = rf(M, 8217464)
    f5 = f5 * rf(M, 8218200)
    f6 = rf(M, 8217476)
    f6 = f6 * rf(M, 8218212)
    f5 = f5 + f6
    wfd(8210552, f5)
    f5 = f5 * rf(M, 8218200)
    f4 = f4 + f5
    f5 = rf(M, 8217468)
    f5 = f5 * rf(M, 8218200)
    f6 = rf(M, 8217480)
    f6 = f6 * rf(M, 8218212)
    f5 = f5 + f6
    wfd(8210360, f5)
    f5 = f5 * rf(M, 8218212)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8213152)
    f4 = f4 * rf(M, 8210248)
    f5 = rf(M, 8213160)
    f5 = f5 * rf(M, 8210252)
    f4 = f4 + f5
    f5 = rf(M, 8213168)
    f5 = f5 * rf(M, 8210256)
    f4 = f4 + f5
    f5 = rf(M, 8217528)
    f5 = f5 * rf(M, 8218200)
    f6 = rf(M, 8217540)
    f6 = f6 * rf(M, 8218304)
    f5 = f5 + f6
    wfd(8210356, f5)
    f5 = f5 * rf(M, 8218200)
    f4 = f4 + f5
    f5 = rf(M, 8217532)
    f5 = f5 * rf(M, 8218200)
    f6 = rf(M, 8217544)
    f6 = f6 * rf(M, 8218304)
    f5 = f5 + f6
    wfd(8210544, f5)
    f5 = f5 * rf(M, 8218304)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8213704)
    f4 = f4 * rf(M, 8210368)
    f5 = rf(M, 8213712)
    f5 = f5 * rf(M, 8210372)
    f4 = f4 + f5
    f5 = rf(M, 8213724)
    f5 = f5 * rf(M, 8210376)
    f4 = f4 + f5
    f5 = rf(M, 8217560)
    f5 = f5 * rf(M, 8213704)
    f6 = rf(M, 8217580)
    f6 = f6 * rf(M, 8213712)
    f5 = f5 + f6
    f6 = rf(M, 8217652)
    f6 = f6 * rf(M, 8213716)
    f5 = f5 + f6
    f6 = rf(M, 8217672)
    f6 = f6 * rf(M, 8213728)
    f5 = f5 + f6
    wfd(8210540, f5)
    f5 = rf(M, 8213716)
    f5 = f5 * rf(M, 8210540)
    f4 = f4 + f5
    f5 = rf(M, 8213704)
    f5 = f5 * rf(M, 8218764)
    f6 = rf(M, 8217584)
    f6 = f6 * rf(M, 8213712)
    f5 = f5 + f6
    f6 = rf(M, 8217656)
    f6 = f6 * rf(M, 8213716)
    f5 = f5 + f6
    f6 = rf(M, 8213728)
    f6 = f6 * rf(M, 8218776)
    f5 = f5 + f6
    wfd(8210240, f5)
    f5 = rf(M, 8213728)
    f5 = f5 * rf(M, 8210240)
    f4 = f4 + f5
    f3 = f3 + f4
    wfd(8217424, f3)
    f3 = rf(M, 8217300)
    f3 = f3 * rf(M, 8210400)
    f3 = rf(M, 8217424) - f3
    f4 = rf(M, 8214756)
    f4 = f4 * rf(M, 8218468)
    f5 = rf(M, 8214768)
    f5 = f5 * rf(M, 8218476)
    f4 = f4 + f5
    f5 = rf(M, 8210408)
    f5 = f5 * rf(M, 8214756)
    f6 = rf(M, 8210404)
    f6 = f6 * rf(M, 8214768)
    f5 = f5 + f6
    f4 = f4 + f5
    f5 = rf(M, 8212628)
    f5 = f5 * rf(M, 8210176)
    f6 = rf(M, 8212636)
    f6 = f6 * rf(M, 8210180)
    f5 = f5 + f6
    f6 = rf(M, 8212644)
    f6 = f6 * rf(M, 8210184)
    f5 = f5 + f6
    f4 = f4 + f5
    f5 = rf(M, 8213148)
    f5 = f5 * rf(M, 8210248)
    f6 = rf(M, 8213156)
    f6 = f6 * rf(M, 8210252)
    f5 = f5 + f6
    f6 = rf(M, 8213164)
    f6 = f6 * rf(M, 8210256)
    f5 = f5 + f6
    f4 = f4 + f5
    f5 = rf(M, 8213700)
    f5 = f5 * rf(M, 8210368)
    f6 = rf(M, 8213708)
    f6 = f6 * rf(M, 8210372)
    f5 = f5 + f6
    f6 = rf(M, 8213720)
    f6 = f6 * rf(M, 8210376)
    f5 = f5 + f6
    f4 = f4 + f5
    wfd(8217372, f4)
    f4 = rf(M, 8217288)
    f4 = f4 * rf(M, 8210400)
    f4 = rf(M, 8217372) - f4
    f4 = f4 * rf(M, 8210300)
    wfd(8210300, f4)
    f4 = rf(M, 8210456)
    f4 = f4 * rf(M, 8210300)
    f3 = f3 - f4
    f4 = rf(M, 8214776)
    f4 = f4 * rf(M, 8218468)
    f5 = rf(M, 8214792)
    f5 = f5 * rf(M, 8218472)
    f4 = f4 + f5
    f5 = rf(M, 8210408)
    f5 = f5 * rf(M, 8214776)
    f6 = rf(M, 8210404)
    f6 = f6 * rf(M, 8214792)
    f5 = f5 + f6
    f4 = f4 + f5
    f5 = rf(M, 8212652)
    f5 = f5 * rf(M, 8210176)
    f6 = rf(M, 8212660)
    f6 = f6 * rf(M, 8210180)
    f5 = f5 + f6
    f6 = rf(M, 8212668)
    f6 = f6 * rf(M, 8210184)
    f5 = f5 + f6
    f4 = f4 + f5
    f5 = rf(M, 8213172)
    f5 = f5 * rf(M, 8210248)
    f6 = rf(M, 8213180)
    f6 = f6 * rf(M, 8210252)
    f5 = f5 + f6
    f6 = rf(M, 8213188)
    f6 = f6 * rf(M, 8210256)
    f5 = f5 + f6
    f4 = f4 + f5
    f5 = rf(M, 8213732)
    f5 = f5 * rf(M, 8210368)
    f6 = rf(M, 8213740)
    f6 = f6 * rf(M, 8210372)
    f5 = f5 + f6
    f6 = rf(M, 8213752)
    f6 = f6 * rf(M, 8210376)
    f5 = f5 + f6
    f4 = f4 + f5
    wfd(8217376, f4)
    f4 = rf(M, 8217292)
    f4 = f4 * rf(M, 8210400)
    f4 = rf(M, 8217376) - f4
    f5 = rf(M, 8210492)
    f5 = f5 * rf(M, 8210300)
    f4 = f4 - f5
    f4 = f4 * rf(M, 8210500)
    wfd(8210500, f4)
    f4 = rf(M, 8210516)
    f4 = f4 * rf(M, 8210500)
    f3 = f3 - f4
    f4 = rf(M, 8212608)
    f4 = f4 * rf(M, 8210176)
    f5 = rf(M, 8212616)
    f5 = f5 * rf(M, 8210180)
    f4 = f4 + f5
    f5 = rf(M, 8212624)
    f5 = f5 * rf(M, 8210184)
    f4 = f4 + f5
    f5 = rf(M, 8217460)
    f5 = f5 * rf(M, 8218200)
    f6 = rf(M, 8217472)
    f6 = f6 * rf(M, 8218212)
    f5 = f5 + f6
    wfd(8210404, f5)
    f5 = f5 * rf(M, 8218188)
    f4 = f4 + f5
    f5 = rf(M, 8210552)
    f5 = f5 * rf(M, 8218196)
    f4 = f4 + f5
    f5 = rf(M, 8210360)
    f5 = f5 * rf(M, 8218208)
    f4 = f4 + f5
    f5 = rf(M, 8213128)
    f5 = f5 * rf(M, 8210248)
    f6 = rf(M, 8213136)
    f6 = f6 * rf(M, 8210252)
    f5 = f5 + f6
    f6 = rf(M, 8213144)
    f6 = f6 * rf(M, 8210256)
    f5 = f5 + f6
    f6 = rf(M, 8217524)
    f6 = f6 * rf(M, 8218200)
    f7 = rf(M, 8217536)
    f7 = f7 * rf(M, 8218304)
    f6 = f6 + f7
    wfd(8210408, f6)
    f6 = f6 * rf(M, 8218188)
    f5 = f5 + f6
    f6 = rf(M, 8210356)
    f6 = f6 * rf(M, 8218292)
    f5 = f5 + f6
    f6 = rf(M, 8210544)
    f6 = f6 * rf(M, 8218208)
    f5 = f5 + f6
    f4 = f4 + f5
    f5 = rf(M, 8213672)
    f5 = f5 * rf(M, 8210368)
    f6 = rf(M, 8213680)
    f6 = f6 * rf(M, 8210372)
    f5 = f5 + f6
    f6 = rf(M, 8213692)
    f6 = f6 * rf(M, 8210376)
    f5 = f5 + f6
    f6 = rf(M, 8217556)
    f6 = f6 * rf(M, 8213704)
    f7 = rf(M, 8217576)
    f7 = f7 * rf(M, 8213712)
    f6 = f6 + f7
    f7 = rf(M, 8217648)
    f7 = f7 * rf(M, 8213716)
    f6 = f6 + f7
    f7 = rf(M, 8217668)
    f7 = f7 * rf(M, 8213728)
    f6 = f6 + f7
    wfd(8210236, f6)
    f6 = f6 * rf(M, 8218348)
    f5 = f5 + f6
    f6 = rf(M, 8213684)
    f6 = f6 * rf(M, 8210540)
    f5 = f5 + f6
    f6 = rf(M, 8213696)
    f6 = f6 * rf(M, 8210240)
    f5 = f5 + f6
    f4 = f4 + f5
    wfd(8217488, f4)
    f4 = rf(M, 8217296)
    f4 = f4 * rf(M, 8210400)
    f4 = rf(M, 8217488) - f4
    f5 = rf(M, 8210432)
    f5 = f5 * rf(M, 8210300)
    f4 = f4 - f5
    f5 = rf(M, 8210140)
    f5 = f5 * rf(M, 8210500)
    f4 = f4 - f5
    f4 = f4 * rf(M, 8210564)
    wfd(8210564, f4)
    f4 = rf(M, 8210556)
    f4 = f4 * rf(M, 8210564)
    f3 = f3 - f4
    wfd(8210532, f3)
    q = fd(f3)
    if q < TINY and q > -TINY then f3 = 1 else f3 = 1 / q end
    f2 = f2 * f3
    wfd(8210528, f2)
    f2 = rf(M, 8212656)
    f2 = f2 * rf(M, 8210176)
    f3 = rf(M, 8212664)
    f3 = f3 * rf(M, 8210180)
    f2 = f2 + f3
    f3 = rf(M, 8212672)
    f3 = f3 * rf(M, 8210184)
    f2 = f2 + f3
    f3 = rf(M, 8210404)
    f3 = f3 * rf(M, 8218192)
    f2 = f2 + f3
    f3 = rf(M, 8210552)
    f3 = f3 * rf(M, 8218204)
    f2 = f2 + f3
    f3 = rf(M, 8210360)
    f3 = f3 * rf(M, 8218220)
    f2 = f2 + f3
    f3 = rf(M, 8213176)
    f3 = f3 * rf(M, 8210248)
    f4 = rf(M, 8213184)
    f4 = f4 * rf(M, 8210252)
    f3 = f3 + f4
    f4 = rf(M, 8213192)
    f4 = f4 * rf(M, 8210256)
    f3 = f3 + f4
    f4 = rf(M, 8210408)
    f4 = f4 * rf(M, 8218192)
    f3 = f3 + f4
    f4 = rf(M, 8210356)
    f4 = f4 * rf(M, 8218296)
    f3 = f3 + f4
    f4 = rf(M, 8210544)
    f4 = f4 * rf(M, 8218220)
    f3 = f3 + f4
    f2 = f2 + f3
    f3 = rf(M, 8213736)
    f3 = f3 * rf(M, 8210368)
    f4 = rf(M, 8213744)
    f4 = f4 * rf(M, 8210372)
    f3 = f3 + f4
    f4 = rf(M, 8213756)
    f4 = f4 * rf(M, 8210376)
    f3 = f3 + f4
    f4 = rf(M, 8210236)
    f4 = f4 * rf(M, 8218352)
    f3 = f3 + f4
    f4 = rf(M, 8213748)
    f4 = f4 * rf(M, 8210540)
    f3 = f3 + f4
    f4 = rf(M, 8213760)
    f4 = f4 * rf(M, 8210240)
    f3 = f3 + f4
    f2 = f2 + f3
    wfd(8217492, f2)
    f2 = rf(M, 8217304)
    f2 = f2 * rf(M, 8210400)
    f2 = rf(M, 8217492) - f2
    f3 = rf(M, 8210484)
    f3 = f3 * rf(M, 8210300)
    f2 = f2 - f3
    f3 = rf(M, 8210520)
    f3 = f3 * rf(M, 8210500)
    f2 = f2 - f3
    f3 = rf(M, 8210536)
    f3 = f3 * rf(M, 8210564)
    f2 = f2 - f3
    wfd(8210240, f2)
    f2 = f2 * rf(M, 8210528)
    f1 = f1 - f2
    q = fd(f1)
    if q < TINY and q > -TINY then f1 = 1 else f1 = 1 / q end
    f2 = rf(M, 8217012)
    f2 = f2 * rf(M, 8218164)
    f2 = f2 + rf(M, 8217004)
    f3 = rf(M, 8217024)
    f3 = f3 * rf(M, 8218176)
    f3 = f3 + rf(M, 8217040)
    f2 = f2 + f3
    f3 = rf(M, 8217048)
    f3 = f3 * rf(M, 8212656)
    f4 = rf(M, 8217052)
    f4 = f4 * rf(M, 8212664)
    f3 = f3 + f4
    f4 = rf(M, 8217092)
    f4 = f4 + rf(M, 8217068)
    wfd(8217068, f4)
    f4 = f4 * rf(M, 8212820)
    f5 = rf(M, 8217100)
    f5 = f5 * rf(M, 8218288)
    f5 = f5 + rf(M, 8217072)
    wfd(8217072, f5)
    f5 = f5 * rf(M, 8212824)
    f4 = f4 + f5
    f5 = rf(M, 8217100)
    f5 = f5 * rf(M, 8218276)
    f5 = f5 + rf(M, 8217076)
    wfd(8217076, f5)
    f5 = f5 * rf(M, 8218260)
    f4 = f4 + f5
    f5 = rf(M, 8212700)
    f5 = f5 * rf(M, 8218532)
    f4 = f4 - f5
    wfd(8217436, f4)
    f4 = f4 * rf(M, 8218192)
    f3 = f3 + f4
    f4 = rf(M, 8217068)
    f4 = f4 * rf(M, 8212828)
    f5 = rf(M, 8217072)
    f5 = f5 * rf(M, 8212832)
    f4 = f4 + f5
    f5 = rf(M, 8217076)
    f5 = f5 * rf(M, 8218264)
    f4 = f4 + f5
    f5 = rf(M, 8212700)
    f5 = f5 * rf(M, 8218536)
    f4 = f4 - f5
    wfd(8217440, f4)
    f4 = f4 * rf(M, 8218204)
    f3 = f3 + f4
    f4 = rf(M, 8217068)
    f4 = f4 * rf(M, 8212836)
    f5 = rf(M, 8217072)
    f5 = f5 * rf(M, 8212840)
    f4 = f4 + f5
    f5 = rf(M, 8217076)
    f5 = f5 * rf(M, 8218272)
    f4 = f4 + f5
    f5 = rf(M, 8212700)
    f5 = f5 * rf(M, 8218540)
    f4 = f4 - f5
    wfd(8217444, f4)
    f4 = f4 * rf(M, 8218220)
    f3 = f3 + f4
    f4 = rf(M, 8210196)
    f4 = f4 * rf(M, 8212500)
    f3 = f3 - f4
    f2 = f2 + f3
    f3 = rf(M, 8217108)
    f3 = f3 * rf(M, 8213176)
    f4 = rf(M, 8217112)
    f4 = f4 * rf(M, 8213184)
    f3 = f3 + f4
    f4 = rf(M, 8217152)
    f4 = f4 + rf(M, 8217128)
    wfd(8217128, f4)
    f4 = f4 * rf(M, 8213340)
    f5 = rf(M, 8217160)
    f5 = f5 * rf(M, 8218344)
    f5 = f5 + rf(M, 8217132)
    wfd(8217132, f5)
    f5 = f5 * rf(M, 8213344)
    f4 = f4 + f5
    f5 = rf(M, 8217160)
    f5 = f5 * rf(M, 8218276)
    f5 = f5 + rf(M, 8217136)
    wfd(8217136, f5)
    f5 = f5 * rf(M, 8218260)
    f4 = f4 + f5
    f5 = rf(M, 8213220)
    f5 = f5 * rf(M, 8218532)
    f4 = f4 - f5
    wfd(8217500, f4)
    f4 = f4 * rf(M, 8218192)
    f3 = f3 + f4
    f4 = rf(M, 8217128)
    f4 = f4 * rf(M, 8213348)
    f5 = rf(M, 8217132)
    f5 = f5 * rf(M, 8213352)
    f4 = f4 + f5
    f5 = rf(M, 8217136)
    f5 = f5 * rf(M, 8218332)
    f4 = f4 + f5
    f5 = rf(M, 8213220)
    f5 = f5 * rf(M, 8218596)
    f4 = f4 - f5
    wfd(8217504, f4)
    f4 = f4 * rf(M, 8218296)
    f3 = f3 + f4
    f4 = rf(M, 8217128)
    f4 = f4 * rf(M, 8213356)
    f5 = rf(M, 8217132)
    f5 = f5 * rf(M, 8213360)
    f4 = f4 + f5
    f5 = rf(M, 8217136)
    f5 = f5 * rf(M, 8218272)
    f4 = f4 + f5
    f5 = rf(M, 8213220)
    f5 = f5 * rf(M, 8218540)
    f4 = f4 - f5
    wfd(8217508, f4)
    f4 = f4 * rf(M, 8218220)
    f3 = f3 + f4
    f4 = rf(M, 8210268)
    f4 = f4 * rf(M, 8213020)
    f3 = f3 - f4
    f2 = f2 + f3
    f3 = rf(M, 8217164)
    f3 = f3 * rf(M, 8213736)
    f4 = rf(M, 8217168)
    f4 = f4 * rf(M, 8213744)
    f3 = f3 + f4
    f4 = rf(M, 8213904)
    f4 = f4 * rf(M, 8217188)
    f5 = rf(M, 8213912)
    f5 = f5 * rf(M, 8217192)
    f4 = f4 + f5
    f5 = rf(M, 8217200)
    f5 = f5 * rf(M, 8218388)
    f4 = f4 + f5
    f4 = f4 + rf(M, 8217180)
    f5 = rf(M, 8214072)
    f5 = f5 * rf(M, 8217212)
    f6 = rf(M, 8214080)
    f6 = f6 * rf(M, 8217216)
    f5 = f5 + f6
    f6 = rf(M, 8217224)
    f6 = f6 * rf(M, 8218400)
    f5 = f5 + f6
    f4 = f4 + f5
    wfd(8217180, f4)
    f4 = f4 * rf(M, 8213748)
    f3 = f3 + f4
    f4 = rf(M, 8217188)
    f4 = f4 * rf(M, 8218640)
    f5 = rf(M, 8217192)
    f5 = f5 * rf(M, 8218644)
    f4 = f4 + f5
    f4 = f4 + rf(M, 8217208)
    f4 = f4 + rf(M, 8217184)
    f5 = rf(M, 8217212)
    f5 = f5 * rf(M, 8218708)
    f6 = rf(M, 8217216)
    f6 = f6 * rf(M, 8218712)
    f5 = f5 + f6
    f5 = f5 + rf(M, 8217232)
    f4 = f4 + f5
    wfd(8217184, f4)
    f4 = f4 * rf(M, 8213760)
    f3 = f3 + f4
    f4 = rf(M, 8210388)
    f4 = f4 * rf(M, 8213540)
    f5 = rf(M, 8210440)
    f5 = f5 * rf(M, 8213544)
    f4 = f4 + f5
    f3 = f3 - f4
    f2 = f2 + f3
    f2 = f2 + rf(M, 8217244)
    f2 = f2 + rf(M, 8217256)
    f2 = f2 + rf(M, 8217268)
    wfd(8217004, f2)
    f2 = rf(M, 8216984)
    f2 = f2 * rf(M, 8210272)
    f2 = rf(M, 8217004) - f2
    f3 = rf(M, 8217008)
    f3 = f3 * rf(M, 8214756)
    f4 = rf(M, 8217012)
    f4 = f4 * rf(M, 8214764)
    f3 = f3 + f4
    f4 = rf(M, 8217016)
    f4 = f4 * rf(M, 8214768)
    f3 = f3 + f4
    f3 = f3 + rf(M, 8216988)
    f4 = rf(M, 8217020)
    f4 = f4 * rf(M, 8214756)
    f5 = rf(M, 8217024)
    f5 = f5 * rf(M, 8214764)
    f4 = f4 + f5
    f5 = rf(M, 8217028)
    f5 = f5 * rf(M, 8214768)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8217048)
    f4 = f4 * rf(M, 8212628)
    f5 = rf(M, 8217052)
    f5 = f5 * rf(M, 8212636)
    f4 = f4 + f5
    f5 = rf(M, 8210136)
    f5 = f5 * rf(M, 8212500)
    f4 = f4 - f5
    f3 = f3 + f4
    f4 = rf(M, 8217108)
    f4 = f4 * rf(M, 8213148)
    f5 = rf(M, 8217112)
    f5 = f5 * rf(M, 8213156)
    f4 = f4 + f5
    f5 = rf(M, 8210220)
    f5 = f5 * rf(M, 8213020)
    f4 = f4 - f5
    f3 = f3 + f4
    f4 = rf(M, 8217164)
    f4 = f4 * rf(M, 8213700)
    f5 = rf(M, 8217168)
    f5 = f5 * rf(M, 8213708)
    f4 = f4 + f5
    f5 = rf(M, 8210336)
    f5 = f5 * rf(M, 8213540)
    f6 = rf(M, 8210448)
    f6 = f6 * rf(M, 8213544)
    f5 = f5 + f6
    f4 = f4 - f5
    f3 = f3 + f4
    wfd(8216988, f3)
    f3 = rf(M, 8216984)
    f3 = f3 * rf(M, 8210308)
    f3 = rf(M, 8216988) - f3
    wfd(8210308, f3)
    f3 = f3 * rf(M, 8210296)
    f2 = f2 - f3
    f3 = rf(M, 8217008)
    f3 = f3 * rf(M, 8214776)
    f4 = rf(M, 8217012)
    f4 = f4 * rf(M, 8214784)
    f3 = f3 + f4
    f4 = rf(M, 8217016)
    f4 = f4 * rf(M, 8214792)
    f3 = f3 + f4
    f3 = f3 + rf(M, 8216992)
    f4 = rf(M, 8217020)
    f4 = f4 * rf(M, 8214776)
    f5 = rf(M, 8217024)
    f5 = f5 * rf(M, 8214784)
    f4 = f4 + f5
    f5 = rf(M, 8217028)
    f5 = f5 * rf(M, 8214792)
    f4 = f4 + f5
    f3 = f3 + f4
    f4 = rf(M, 8217048)
    f4 = f4 * rf(M, 8212652)
    f5 = rf(M, 8217052)
    f5 = f5 * rf(M, 8212660)
    f4 = f4 + f5
    f5 = rf(M, 8210160)
    f5 = f5 * rf(M, 8212500)
    f4 = f4 - f5
    f3 = f3 + f4
    f4 = rf(M, 8217108)
    f4 = f4 * rf(M, 8213172)
    f5 = rf(M, 8217112)
    f5 = f5 * rf(M, 8213180)
    f4 = f4 + f5
    f5 = rf(M, 8210232)
    f5 = f5 * rf(M, 8213020)
    f4 = f4 - f5
    f3 = f3 + f4
    f4 = rf(M, 8217164)
    f4 = f4 * rf(M, 8213732)
    f5 = rf(M, 8217168)
    f5 = f5 * rf(M, 8213740)
    f4 = f4 + f5
    f5 = rf(M, 8210352)
    f5 = f5 * rf(M, 8213540)
    f6 = rf(M, 8210508)
    f6 = f6 * rf(M, 8213544)
    f5 = f5 + f6
    f4 = f4 - f5
    f3 = f3 + f4
    wfd(8216992, f3)
    f3 = rf(M, 8216984)
    f3 = f3 * rf(M, 8210132)
    f3 = rf(M, 8216992) - f3
    f4 = rf(M, 8210308)
    f4 = f4 * rf(M, 8210488)
    f3 = f3 - f4
    wfd(8210488, f3)
    f3 = f3 * rf(M, 8210504)
    f2 = f2 - f3
    f3 = rf(M, 8217012)
    f3 = f3 * rf(M, 8218448)
    f3 = f3 + rf(M, 8216996)
    f4 = rf(M, 8217024)
    f4 = f4 * rf(M, 8218428)
    f4 = f4 + rf(M, 8217032)
    f3 = f3 + f4
    f4 = rf(M, 8217048)
    f4 = f4 * rf(M, 8212608)
    f5 = rf(M, 8217052)
    f5 = f5 * rf(M, 8212616)
    f4 = f4 + f5
    f5 = rf(M, 8217436)
    f5 = f5 * rf(M, 8218188)
    f4 = f4 + f5
    f5 = rf(M, 8217440)
    f5 = f5 * rf(M, 8218196)
    f4 = f4 + f5
    f5 = rf(M, 8217444)
    f5 = f5 * rf(M, 8218208)
    f4 = f4 + f5
    f5 = rf(M, 8210172)
    f5 = f5 * rf(M, 8212500)
    f4 = f4 - f5
    f3 = f3 + f4
    f4 = rf(M, 8217108)
    f4 = f4 * rf(M, 8213128)
    f5 = rf(M, 8217112)
    f5 = f5 * rf(M, 8213136)
    f4 = f4 + f5
    f5 = rf(M, 8217500)
    f5 = f5 * rf(M, 8218188)
    f4 = f4 + f5
    f5 = rf(M, 8217504)
    f5 = f5 * rf(M, 8218292)
    f4 = f4 + f5
    f5 = rf(M, 8217508)
    f5 = f5 * rf(M, 8218208)
    f4 = f4 + f5
    f5 = rf(M, 8210244)
    f5 = f5 * rf(M, 8213020)
    f4 = f4 - f5
    f3 = f3 + f4
    f4 = rf(M, 8217164)
    f4 = f4 * rf(M, 8213672)
    f5 = rf(M, 8217168)
    f5 = f5 * rf(M, 8213680)
    f4 = f4 + f5
    f5 = rf(M, 8217180)
    f5 = f5 * rf(M, 8213684)
    f4 = f4 + f5
    f5 = rf(M, 8217184)
    f5 = f5 * rf(M, 8213696)
    f4 = f4 + f5
    f5 = rf(M, 8210364)
    f5 = f5 * rf(M, 8213540)
    f6 = rf(M, 8210548)
    f6 = f6 * rf(M, 8213544)
    f5 = f5 + f6
    f4 = f4 - f5
    f3 = f3 + f4
    f4 = rf(M, 8217240)
    f4 = f4 * rf(M, 8218424)
    f3 = f3 + f4
    f4 = rf(M, 8217252)
    f4 = f4 * rf(M, 8218424)
    f3 = f3 + f4
    f4 = rf(M, 8217264)
    f4 = f4 * rf(M, 8218424)
    f3 = f3 + f4
    wfd(8216996, f3)
    f3 = rf(M, 8216984)
    f3 = f3 * rf(M, 8210412)
    f3 = rf(M, 8216996) - f3
    f4 = rf(M, 8210308)
    f4 = f4 * rf(M, 8210560)
    f3 = f3 - f4
    f4 = rf(M, 8210488)
    f4 = f4 * rf(M, 8210420)
    f3 = f3 - f4
    wfd(8210420, f3)
    f3 = f3 * rf(M, 8210476)
    f2 = f2 - f3
    f3 = rf(M, 8217008)
    f3 = f3 * rf(M, 8218172)
    f4 = rf(M, 8217016)
    f4 = f4 * rf(M, 8218452)
    f3 = f3 + f4
    f3 = f3 + rf(M, 8217000)
    f4 = rf(M, 8217020)
    f4 = f4 * rf(M, 8218184)
    f5 = rf(M, 8217028)
    f5 = f5 * rf(M, 8218500)
    f4 = f4 + f5
    f4 = f4 + rf(M, 8217036)
    f3 = f3 + f4
    f4 = rf(M, 8217048)
    f4 = f4 * rf(M, 8212632)
    f5 = rf(M, 8217052)
    f5 = f5 * rf(M, 8212640)
    f4 = f4 + f5
    f5 = rf(M, 8217440)
    f5 = f5 * rf(M, 8218200)
    f4 = f4 + f5
    f5 = rf(M, 8217444)
    f5 = f5 * rf(M, 8218212)
    f4 = f4 + f5
    f5 = rf(M, 8210184)
    f5 = f5 * rf(M, 8212500)
    f4 = f4 - f5
    f3 = f3 + f4
    f4 = rf(M, 8217108)
    f4 = f4 * rf(M, 8213152)
    f5 = rf(M, 8217112)
    f5 = f5 * rf(M, 8213160)
    f4 = f4 + f5
    f5 = rf(M, 8217504)
    f5 = f5 * rf(M, 8218200)
    f4 = f4 + f5
    f5 = rf(M, 8217508)
    f5 = f5 * rf(M, 8218304)
    f4 = f4 + f5
    f5 = rf(M, 8210256)
    f5 = f5 * rf(M, 8213020)
    f4 = f4 - f5
    f3 = f3 + f4
    f4 = rf(M, 8217164)
    f4 = f4 * rf(M, 8213704)
    f5 = rf(M, 8217168)
    f5 = f5 * rf(M, 8213712)
    f4 = f4 + f5
    f5 = rf(M, 8217180)
    f5 = f5 * rf(M, 8213716)
    f4 = f4 + f5
    f5 = rf(M, 8217184)
    f5 = f5 * rf(M, 8213728)
    f4 = f4 + f5
    f5 = rf(M, 8210376)
    f5 = f5 * rf(M, 8213540)
    f6 = rf(M, 8210236)
    f6 = f6 * rf(M, 8213544)
    f5 = f5 + f6
    f4 = f4 - f5
    f3 = f3 + f4
    f4 = rf(M, 8217240)
    f4 = f4 * rf(M, 8218412)
    f3 = f3 + f4
    f4 = rf(M, 8217252)
    f4 = f4 * rf(M, 8218412)
    f3 = f3 + f4
    f4 = rf(M, 8217264)
    f4 = f4 * rf(M, 8218412)
    f3 = f3 + f4
    wfd(8217000, f3)
    f3 = rf(M, 8216984)
    f3 = f3 * rf(M, 8210400)
    f3 = rf(M, 8217000) - f3
    f4 = rf(M, 8210308)
    f4 = f4 * rf(M, 8210300)
    f3 = f3 - f4
    f4 = rf(M, 8210488)
    f4 = f4 * rf(M, 8210500)
    f3 = f3 - f4
    f4 = rf(M, 8210420)
    f4 = f4 * rf(M, 8210564)
    f3 = f3 - f4
    wfd(8210564, f3)
    f3 = f3 * rf(M, 8210528)
    f2 = f2 - f3
    f1 = f1 * f2
    wfd(8214816, f1)
    wfd(8214612, f1)
    wfd(8214448, f1)
    wfd(8214284, f1)
    wfd(8212496, f1)
    wfd(8212340, f1)
    wfd(8212184, f1)
    wfd(8212048, f1)
  end
  local function C9()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8210532)
    q = fd(f1)
    if q < TINY and q > -TINY then f1 = 1 else f1 = 1 / q end
    f2 = rf(M, 8214816)
    f2 = f2 * rf(M, 8210240)
    f2 = rf(M, 8210564) - f2
    f1 = f1 * f2
    wfd(8214812, f1)
    wfd(8212492, f1)
    wfd(8212336, f1)
    wfd(8212180, f1)
    wfd(8212044, f1)
    f1 = rf(M, 8210212)
    q = fd(f1)
    if q < TINY and q > -TINY then f1 = 1 else f1 = 1 / q end
    f2 = rf(M, 8214812)
    f2 = f2 * rf(M, 8210556)
    f2 = rf(M, 8210420) - f2
    f3 = rf(M, 8214816)
    f3 = f3 * rf(M, 8210536)
    f2 = f2 - f3
    f1 = f1 * f2
    wfd(8214808, f1)
    wfd(8212488, f1)
    wfd(8212332, f1)
    wfd(8212176, f1)
    wfd(8212040, f1)
    f1 = rf(M, 8210496)
    q = fd(f1)
    if q < TINY and q > -TINY then f1 = 1 else f1 = 1 / q end
    f2 = rf(M, 8214808)
    f2 = f2 * rf(M, 8210140)
    f2 = rf(M, 8210488) - f2
    f3 = rf(M, 8214812)
    f3 = f3 * rf(M, 8210516)
    f2 = f2 - f3
    f3 = rf(M, 8214816)
    f3 = f3 * rf(M, 8210520)
    f2 = f2 - f3
    f1 = f1 * f2
    wfd(8212172, f1)
    wfd(8212036, f1)
    f1 = rf(M, 8210328)
    q = fd(f1)
    if q < TINY and q > -TINY then f1 = 1 else f1 = 1 / q end
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8210492)
    f2 = rf(M, 8210308) - f2
    f3 = rf(M, 8214808)
    f3 = f3 * rf(M, 8210432)
    f2 = f2 - f3
    f3 = rf(M, 8214812)
    f3 = f3 * rf(M, 8210456)
    f2 = f2 - f3
    f3 = rf(M, 8214816)
    f3 = f3 * rf(M, 8210484)
    f2 = f2 - f3
    f1 = f1 * f2
    wfd(8212168, f1)
    wfd(8212032, f1)
    f1 = rf(M, 8217284)
    q = fd(f1)
    if q < TINY and q > -TINY then f1 = 1 else f1 = 1 / q end
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8217288)
    f2 = rf(M, 8216984) - f2
    f3 = rf(M, 8212172)
    f3 = f3 * rf(M, 8217292)
    f2 = f2 - f3
    f3 = rf(M, 8214808)
    f3 = f3 * rf(M, 8217296)
    f2 = f2 - f3
    f3 = rf(M, 8214812)
    f3 = f3 * rf(M, 8217300)
    f2 = f2 - f3
    f3 = rf(M, 8214816)
    f3 = f3 * rf(M, 8217304)
    f2 = f2 - f3
    f1 = f1 * f2
    wfd(8212164, f1)
    wfd(8212028, f1)
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8214736)
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8214756)
    f1 = f1 + f2
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8214776)
    f1 = f1 + f2
    f2 = rf(M, 8214812)
    f2 = f2 * rf(M, 8218172)
    f1 = f1 + f2
    wfd(8212320, f1)
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8214740)
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8214764)
    f1 = f1 + f2
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8214784)
    f1 = f1 + f2
    f2 = rf(M, 8214808)
    f2 = f2 * rf(M, 8218448)
    f1 = f1 + f2
    f2 = rf(M, 8214816)
    f2 = f2 * rf(M, 8218164)
    f1 = f1 + f2
    wfd(8212324, f1)
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8214748)
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8214768)
    f1 = f1 + f2
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8214792)
    f1 = f1 + f2
    f2 = rf(M, 8214812)
    f2 = f2 * rf(M, 8218456)
    f1 = f1 + f2
    wfd(8212328, f1)
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8214736)
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8214756)
    f1 = f1 + f2
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8214776)
    f1 = f1 + f2
    f2 = rf(M, 8214812)
    f2 = f2 * rf(M, 8218184)
    f1 = f1 + f2
    wfd(8212476, f1)
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8214740)
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8214764)
    f1 = f1 + f2
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8214784)
    f1 = f1 + f2
    f2 = rf(M, 8214808)
    f2 = f2 * rf(M, 8218428)
    f1 = f1 + f2
    f2 = rf(M, 8214816)
    f2 = f2 * rf(M, 8218176)
    f1 = f1 + f2
    wfd(8212480, f1)
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8214748)
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8214768)
    f1 = f1 + f2
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8214792)
    f1 = f1 + f2
    f2 = rf(M, 8214812)
    f2 = f2 * rf(M, 8218500)
    f1 = f1 + f2
    wfd(8212484, f1)
    f1 = rf(M, 8214808)
    f1 = f1 * rf(M, 8218188)
    f2 = rf(M, 8214816)
    f2 = f2 * rf(M, 8218192)
    f1 = f1 + f2
    wfd(8212688, f1)
    f1 = f1 * rf(M, 8212820)
    f2 = rf(M, 8214808)
    f2 = f2 * rf(M, 8218196)
    f3 = rf(M, 8214812)
    f3 = f3 * rf(M, 8218200)
    f2 = f2 + f3
    f3 = rf(M, 8214816)
    f3 = f3 * rf(M, 8218204)
    f2 = f2 + f3
    wfd(8212692, f2)
    f2 = f2 * rf(M, 8212828)
    f1 = f1 + f2
    f2 = rf(M, 8214808)
    f2 = f2 * rf(M, 8218208)
    f3 = rf(M, 8214812)
    f3 = f3 * rf(M, 8218212)
    f2 = f2 + f3
    f3 = rf(M, 8214816)
    f3 = f3 * rf(M, 8218220)
    f2 = f2 + f3
    wfd(8212696, f2)
    f2 = f2 * rf(M, 8212836)
    f1 = f1 + f2
    wfd(8213008, f1)
    wfd(8212856, f1)
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8212604)
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8212628)
    f1 = f1 + f2
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8212652)
    f1 = f1 + f2
    f2 = rf(M, 8214808)
    f2 = f2 * rf(M, 8212608)
    f1 = f1 + f2
    f2 = rf(M, 8214812)
    f2 = f2 * rf(M, 8212632)
    f1 = f1 + f2
    f2 = rf(M, 8214816)
    f2 = f2 * rf(M, 8212656)
    f1 = f1 + f2
    wfd(8212676, f1)
    f1 = f1 * rf(M, 8218240)
    f2 = rf(M, 8212164)
    f2 = f2 * rf(M, 8212620)
    f3 = rf(M, 8212168)
    f3 = f3 * rf(M, 8212644)
    f2 = f2 + f3
    f3 = rf(M, 8212172)
    f3 = f3 * rf(M, 8212668)
    f2 = f2 + f3
    f3 = rf(M, 8214808)
    f3 = f3 * rf(M, 8212624)
    f2 = f2 + f3
    f3 = rf(M, 8214812)
    f3 = f3 * rf(M, 8212648)
    f2 = f2 + f3
    f3 = rf(M, 8214816)
    f3 = f3 * rf(M, 8212672)
    f2 = f2 + f3
    wfd(8210484, f2)
    f2 = rf(M, 8217056)
    f2 = f2 * rf(M, 8218244)
    f3 = rf(M, 8217060)
    f3 = f3 * rf(M, 8218256)
    f2 = f2 + f3
    f3 = rf(M, 8217064)
    f3 = f3 * rf(M, 8218272)
    f2 = f2 + f3
    f2 = f2 + rf(M, 8217044)
    wfd(8217044, f2)
    f2 = rf(M, 8210484)
    f2 = f2 * rf(M, 8218780)
    f2 = rf(M, 8217044) - f2
    f2 = f2 * rf(M, 8218784)
    wfd(8212500, f2)
    f2 = f2 + rf(M, 8210484)
    wfd(8212684, f2)
    f2 = f2 * rf(M, 8218244)
    f1 = f1 + f2
    wfd(8212844, f1)
    f1 = f1 * rf(M, 8212972)
    f2 = rf(M, 8212676)
    f2 = f2 * rf(M, 8218248)
    f3 = rf(M, 8212164)
    f3 = f3 * rf(M, 8212612)
    f4 = rf(M, 8212168)
    f4 = f4 * rf(M, 8212636)
    f3 = f3 + f4
    f4 = rf(M, 8212172)
    f4 = f4 * rf(M, 8212660)
    f3 = f3 + f4
    f4 = rf(M, 8214808)
    f4 = f4 * rf(M, 8212616)
    f3 = f3 + f4
    f4 = rf(M, 8214812)
    f4 = f4 * rf(M, 8212640)
    f3 = f3 + f4
    f4 = rf(M, 8214816)
    f4 = f4 * rf(M, 8212664)
    f3 = f3 + f4
    wfd(8212680, f3)
    f3 = f3 * rf(M, 8218252)
    f2 = f2 + f3
    f3 = rf(M, 8212684)
    f3 = f3 * rf(M, 8218256)
    f2 = f2 + f3
    wfd(8212848, f2)
    f2 = f2 * rf(M, 8212984)
    f1 = f1 + f2
    wfd(8212996, f1)
    f1 = rf(M, 8212844)
    f1 = f1 * rf(M, 8212976)
    f2 = rf(M, 8212848)
    f2 = f2 * rf(M, 8212988)
    f1 = f1 + f2
    f2 = rf(M, 8212676)
    f2 = f2 * rf(M, 8218260)
    f3 = rf(M, 8212680)
    f3 = f3 * rf(M, 8218264)
    f2 = f2 + f3
    f3 = rf(M, 8212684)
    f3 = f3 * rf(M, 8218272)
    f2 = f2 + f3
    wfd(8212852, f2)
    f2 = f2 * rf(M, 8218280)
    f1 = f1 + f2
    wfd(8213000, f1)
    f1 = rf(M, 8212844)
    f1 = f1 * rf(M, 8212980)
    f2 = rf(M, 8212848)
    f2 = f2 * rf(M, 8212992)
    f1 = f1 + f2
    f2 = rf(M, 8212852)
    f2 = f2 * rf(M, 8218276)
    f1 = f1 + f2
    wfd(8213004, f1)
  end
  local function C10()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8212688)
    f1 = f1 * rf(M, 8212824)
    f2 = rf(M, 8212692)
    f2 = f2 * rf(M, 8212832)
    f1 = f1 + f2
    f2 = rf(M, 8212696)
    f2 = f2 * rf(M, 8212840)
    f1 = f1 + f2
    wfd(8212860, f1)
    f1 = f1 * rf(M, 8218288)
    f2 = rf(M, 8212688)
    f2 = f2 * rf(M, 8218260)
    f3 = rf(M, 8212692)
    f3 = f3 * rf(M, 8218264)
    f2 = f2 + f3
    f3 = rf(M, 8212696)
    f3 = f3 * rf(M, 8218272)
    f2 = f2 + f3
    wfd(8212864, f2)
    f2 = f2 * rf(M, 8218276)
    f1 = f1 + f2
    wfd(8213016, f1)
    f1 = rf(M, 8212860)
    f1 = f1 * rf(M, 8218276)
    f2 = rf(M, 8212864)
    f2 = f2 * rf(M, 8218280)
    f1 = f1 + f2
    wfd(8210484, f1)
    f1 = rf(M, 8210484)
    f1 = f1 * rf(M, 8218788)
    f1 = rf(M, 8217096) - f1
    f1 = f1 * rf(M, 8218792)
    wfd(8212868, f1)
    f1 = f1 + rf(M, 8210484)
    wfd(8213012, f1)
    f1 = rf(M, 8214808)
    f1 = f1 * rf(M, 8218188)
    f2 = rf(M, 8214816)
    f2 = f2 * rf(M, 8218192)
    f1 = f1 + f2
    wfd(8213208, f1)
    f1 = f1 * rf(M, 8213340)
    f2 = rf(M, 8214808)
    f2 = f2 * rf(M, 8218292)
    f3 = rf(M, 8214812)
    f3 = f3 * rf(M, 8218200)
    f2 = f2 + f3
    f3 = rf(M, 8214816)
    f3 = f3 * rf(M, 8218296)
    f2 = f2 + f3
    wfd(8213212, f2)
    f2 = f2 * rf(M, 8213348)
    f1 = f1 + f2
    f2 = rf(M, 8214808)
    f2 = f2 * rf(M, 8218208)
    f3 = rf(M, 8214812)
    f3 = f3 * rf(M, 8218304)
    f2 = f2 + f3
    f3 = rf(M, 8214816)
    f3 = f3 * rf(M, 8218220)
    f2 = f2 + f3
    wfd(8213216, f2)
    f2 = f2 * rf(M, 8213356)
    f1 = f1 + f2
    wfd(8213528, f1)
    wfd(8213376, f1)
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8213124)
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8213148)
    f1 = f1 + f2
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8213172)
    f1 = f1 + f2
    f2 = rf(M, 8214808)
    f2 = f2 * rf(M, 8213128)
    f1 = f1 + f2
    f2 = rf(M, 8214812)
    f2 = f2 * rf(M, 8213152)
    f1 = f1 + f2
    f2 = rf(M, 8214816)
    f2 = f2 * rf(M, 8213176)
    f1 = f1 + f2
    wfd(8213196, f1)
    f1 = f1 * rf(M, 8218240)
    f2 = rf(M, 8212164)
    f2 = f2 * rf(M, 8213140)
    f3 = rf(M, 8212168)
    f3 = f3 * rf(M, 8213164)
    f2 = f2 + f3
    f3 = rf(M, 8212172)
    f3 = f3 * rf(M, 8213188)
    f2 = f2 + f3
    f3 = rf(M, 8214808)
    f3 = f3 * rf(M, 8213144)
    f2 = f2 + f3
    f3 = rf(M, 8214812)
    f3 = f3 * rf(M, 8213168)
    f2 = f2 + f3
    f3 = rf(M, 8214816)
    f3 = f3 * rf(M, 8213192)
    f2 = f2 + f3
    wfd(8210484, f2)
    f2 = rf(M, 8217116)
    f2 = f2 * rf(M, 8218244)
    f3 = rf(M, 8217120)
    f3 = f3 * rf(M, 8218324)
    f2 = f2 + f3
    f3 = rf(M, 8217124)
    f3 = f3 * rf(M, 8218272)
    f2 = f2 + f3
    f2 = f2 + rf(M, 8217104)
    wfd(8217104, f2)
    f2 = rf(M, 8213196)
    f2 = f2 * rf(M, 8218592)
    f3 = rf(M, 8212164)
    f3 = f3 * rf(M, 8213132)
    f4 = rf(M, 8212168)
    f4 = f4 * rf(M, 8213156)
    f3 = f3 + f4
    f4 = rf(M, 8212172)
    f4 = f4 * rf(M, 8213180)
    f3 = f3 + f4
    f4 = rf(M, 8214808)
    f4 = f4 * rf(M, 8213136)
    f3 = f3 + f4
    f4 = rf(M, 8214812)
    f4 = f4 * rf(M, 8213160)
    f3 = f3 + f4
    f4 = rf(M, 8214816)
    f4 = f4 * rf(M, 8213184)
    f3 = f3 + f4
    wfd(8213200, f3)
    f3 = f3 * rf(M, 8218796)
    f2 = f2 + f3
    f3 = rf(M, 8210484)
    f3 = f3 * rf(M, 8218780)
    f2 = f2 + f3
    f2 = rf(M, 8217104) - f2
    f2 = f2 * rf(M, 8218784)
    wfd(8213020, f2)
    f2 = f2 + rf(M, 8210484)
    wfd(8213204, f2)
    f2 = f2 * rf(M, 8218244)
    f1 = f1 + f2
    wfd(8213364, f1)
    f1 = f1 * rf(M, 8213492)
    f2 = rf(M, 8213196)
    f2 = f2 * rf(M, 8218320)
    f3 = rf(M, 8213200)
    f3 = f3 * rf(M, 8218252)
    f2 = f2 + f3
    f3 = rf(M, 8213204)
    f3 = f3 * rf(M, 8218324)
    f2 = f2 + f3
    wfd(8213368, f2)
    f2 = f2 * rf(M, 8213504)
    f1 = f1 + f2
    wfd(8213516, f1)
    f1 = rf(M, 8213364)
    f1 = f1 * rf(M, 8213496)
    f2 = rf(M, 8213368)
    f2 = f2 * rf(M, 8213508)
    f1 = f1 + f2
    f2 = rf(M, 8213196)
    f2 = f2 * rf(M, 8218260)
    f3 = rf(M, 8213200)
    f3 = f3 * rf(M, 8218332)
    f2 = f2 + f3
    f3 = rf(M, 8213204)
    f3 = f3 * rf(M, 8218272)
    f2 = f2 + f3
    wfd(8213372, f2)
    f2 = f2 * rf(M, 8218336)
    f1 = f1 + f2
    wfd(8213520, f1)
    f1 = rf(M, 8213364)
    f1 = f1 * rf(M, 8213500)
    f2 = rf(M, 8213368)
    f2 = f2 * rf(M, 8213512)
    f1 = f1 + f2
    f2 = rf(M, 8213372)
    f2 = f2 * rf(M, 8218276)
    f1 = f1 + f2
    wfd(8213524, f1)
    f1 = rf(M, 8213208)
    f1 = f1 * rf(M, 8213344)
    f2 = rf(M, 8213212)
    f2 = f2 * rf(M, 8213352)
    f1 = f1 + f2
    f2 = rf(M, 8213216)
    f2 = f2 * rf(M, 8213360)
    f1 = f1 + f2
    wfd(8213380, f1)
    f1 = f1 * rf(M, 8218344)
    f2 = rf(M, 8213208)
    f2 = f2 * rf(M, 8218260)
    f3 = rf(M, 8213212)
    f3 = f3 * rf(M, 8218332)
    f2 = f2 + f3
    f3 = rf(M, 8213216)
    f3 = f3 * rf(M, 8218272)
    f2 = f2 + f3
    wfd(8213384, f2)
    f2 = f2 * rf(M, 8218276)
    f1 = f1 + f2
    wfd(8213536, f1)
    f1 = rf(M, 8213380)
    f1 = f1 * rf(M, 8218276)
    f2 = rf(M, 8213384)
    f2 = f2 * rf(M, 8218336)
    f1 = f1 + f2
    wfd(8210484, f1)
    f1 = rf(M, 8210484)
    f1 = f1 * rf(M, 8218788)
    f1 = rf(M, 8217156) - f1
    f1 = f1 * rf(M, 8218792)
    wfd(8213388, f1)
    f1 = f1 + rf(M, 8210484)
    wfd(8213532, f1)
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8213668)
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8213700)
    f1 = f1 + f2
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8213732)
    f1 = f1 + f2
    f2 = rf(M, 8214808)
    f2 = f2 * rf(M, 8213672)
    f1 = f1 + f2
    f2 = rf(M, 8214812)
    f2 = f2 * rf(M, 8213704)
    f1 = f1 + f2
    f2 = rf(M, 8214816)
    f2 = f2 * rf(M, 8213736)
    f1 = f1 + f2
    wfd(8213764, f1)
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8213676)
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8213708)
    f1 = f1 + f2
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8213740)
    f1 = f1 + f2
    f2 = rf(M, 8214808)
    f2 = f2 * rf(M, 8213680)
    f1 = f1 + f2
    f2 = rf(M, 8214812)
    f2 = f2 * rf(M, 8213712)
    f1 = f1 + f2
    f2 = rf(M, 8214816)
    f2 = f2 * rf(M, 8213744)
    f1 = f1 + f2
    wfd(8213768, f1)
    f1 = rf(M, 8214808)
    f1 = f1 * rf(M, 8213684)
    f2 = rf(M, 8214812)
    f2 = f2 * rf(M, 8213716)
    f1 = f1 + f2
    f2 = rf(M, 8214816)
    f2 = f2 * rf(M, 8213748)
    f1 = f1 + f2
    wfd(8213780, f1)
    f1 = rf(M, 8214808)
    f1 = f1 * rf(M, 8213696)
    f2 = rf(M, 8214812)
    f2 = f2 * rf(M, 8213728)
    f1 = f1 + f2
    f2 = rf(M, 8214816)
    f2 = f2 * rf(M, 8213760)
    f1 = f1 + f2
    wfd(8214120, f1)
    wfd(8213952, f1)
    wfd(8213784, f1)
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8213688)
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8213720)
    f1 = f1 + f2
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8213752)
    f1 = f1 + f2
    f2 = rf(M, 8214808)
    f2 = f2 * rf(M, 8213692)
    f1 = f1 + f2
    f2 = rf(M, 8214812)
    f2 = f2 * rf(M, 8213724)
    f1 = f1 + f2
    f2 = rf(M, 8214816)
    f2 = f2 * rf(M, 8213756)
    f1 = f1 + f2
    wfd(8210484, f1)
    f1 = rf(M, 8213920)
    f1 = f1 * rf(M, 8210280)
    f2 = rf(M, 8213924)
    f2 = f2 * rf(M, 8210284)
    f1 = f1 + f2
    f2 = rf(M, 8218632)
    f2 = f2 * rf(M, 8214096)
    wfd(8210456, f2)
    f2 = f2 * rf(M, 8214096)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8218700)
    f2 = rf(M, 8214088)
    f2 = f2 * rf(M, 8210312)
    f3 = rf(M, 8214092)
    f3 = f3 * rf(M, 8210316)
    f2 = f2 + f3
    f3 = rf(M, 8218636)
    f3 = f3 * rf(M, 8214096)
    wfd(8210432, f3)
    f3 = f3 * rf(M, 8214096)
    f2 = f2 + f3
    f1 = f1 + f2
    wfd(8217596, f1)
    q = fd(f1)
    if q < TINY and q > -TINY then f1 = 1 else f1 = 1 / q end
    f2 = rf(M, 8213920)
    f2 = f2 * rf(M, 8217188)
    f3 = rf(M, 8213924)
    f3 = f3 * rf(M, 8217192)
    f2 = f2 + f3
    f3 = rf(M, 8217196)
    f3 = f3 * rf(M, 8214096)
    f2 = f2 + f3
    f2 = f2 + rf(M, 8217172)
    f3 = rf(M, 8214088)
    f3 = f3 * rf(M, 8217212)
    f4 = rf(M, 8214092)
    f4 = f4 * rf(M, 8217216)
    f3 = f3 + f4
    f4 = rf(M, 8217220)
    f4 = f4 * rf(M, 8214096)
    f3 = f3 + f4
    f2 = f2 + f3
    wfd(8217172, f2)
    f2 = rf(M, 8210280)
    f2 = f2 * rf(M, 8218384)
    f3 = rf(M, 8210284)
    f3 = f3 * rf(M, 8218396)
    f2 = f2 + f3
    f3 = rf(M, 8210312)
    f3 = f3 * rf(M, 8218384)
    f4 = rf(M, 8210316)
    f4 = f4 * rf(M, 8218408)
    f3 = f3 + f4
    f2 = f2 + f3
    wfd(8217588, f2)
    f2 = rf(M, 8213764)
    f2 = f2 * rf(M, 8217588)
    f3 = rf(M, 8213900)
    f3 = f3 * rf(M, 8210280)
    f4 = rf(M, 8213908)
    f4 = f4 * rf(M, 8210284)
    f3 = f3 + f4
    f4 = rf(M, 8210456)
    f4 = f4 * rf(M, 8214084)
    f3 = f3 + f4
    f4 = rf(M, 8214068)
    f4 = f4 * rf(M, 8210312)
    f5 = rf(M, 8214076)
    f5 = f5 * rf(M, 8210316)
    f4 = f4 + f5
    f5 = rf(M, 8210432)
    f5 = f5 * rf(M, 8214084)
    f4 = f4 + f5
    f3 = f3 + f4
    wfd(8217592, f3)
    f3 = rf(M, 8213768)
    f3 = f3 * rf(M, 8217592)
    f2 = f2 + f3
    f3 = rf(M, 8210484)
    f3 = f3 * rf(M, 8217596)
    f2 = f2 + f3
    f3 = rf(M, 8213892)
    f3 = f3 * rf(M, 8210280)
    f4 = rf(M, 8213896)
    f4 = f4 * rf(M, 8210284)
    f3 = f3 + f4
    f4 = rf(M, 8210456)
    f4 = f4 * rf(M, 8218228)
    f3 = f3 + f4
    f4 = rf(M, 8214060)
    f4 = f4 * rf(M, 8210312)
    f5 = rf(M, 8214064)
    f5 = f5 * rf(M, 8210316)
    f4 = f4 + f5
    f5 = rf(M, 8210432)
    f5 = f5 * rf(M, 8218308)
    f4 = f4 + f5
    f3 = f3 + f4
    wfd(8217600, f3)
    f3 = rf(M, 8214808)
    f3 = f3 * rf(M, 8218348)
    f4 = rf(M, 8214816)
    f4 = f4 * rf(M, 8218352)
    f3 = f3 + f4
    wfd(8210432, f3)
    f3 = f3 * rf(M, 8217600)
    f2 = f2 + f3
    f3 = rf(M, 8213904)
    f3 = f3 * rf(M, 8210280)
    f4 = rf(M, 8213912)
    f4 = f4 * rf(M, 8210284)
    f3 = f3 + f4
    f4 = rf(M, 8214072)
    f4 = f4 * rf(M, 8210312)
    f5 = rf(M, 8214080)
    f5 = f5 * rf(M, 8210316)
    f4 = f4 + f5
    f3 = f3 + f4
    wfd(8217604, f3)
    f3 = rf(M, 8213780)
    f3 = f3 * rf(M, 8217604)
    f2 = f2 + f3
    f3 = rf(M, 8210280)
    f3 = f3 * rf(M, 8218640)
    f4 = rf(M, 8210284)
    f4 = f4 * rf(M, 8218644)
    f3 = f3 + f4
    f4 = rf(M, 8210312)
    f4 = f4 * rf(M, 8218708)
    f5 = rf(M, 8210316)
    f5 = f5 * rf(M, 8218712)
    f4 = f4 + f5
    f3 = f3 + f4
    wfd(8217608, f3)
    f3 = rf(M, 8214120)
    f3 = f3 * rf(M, 8217608)
    f2 = f2 + f3
    f2 = rf(M, 8217172) - f2
    wfd(8210316, f2)
    f2 = rf(M, 8213892)
    f2 = f2 * rf(M, 8210288)
    f3 = rf(M, 8213896)
    f3 = f3 * rf(M, 8210292)
    f2 = f2 + f3
    f2 = f2 + rf(M, 8218668)
    f2 = f2 + rf(M, 8218704)
    f3 = rf(M, 8214060)
    f3 = f3 * rf(M, 8210320)
    f4 = rf(M, 8214064)
    f4 = f4 * rf(M, 8210324)
    f3 = f3 + f4
    f3 = f3 + rf(M, 8218668)
    f2 = f2 + f3
    wfd(8217624, f2)
    f2 = rf(M, 8213920)
    f2 = f2 * rf(M, 8210288)
    f3 = rf(M, 8213924)
    f3 = f3 * rf(M, 8210292)
    f2 = f2 + f3
    f3 = rf(M, 8214096)
    f3 = f3 * rf(M, 8218664)
    f2 = f2 + f3
    f3 = rf(M, 8214088)
    f3 = f3 * rf(M, 8210320)
    f4 = rf(M, 8214092)
    f4 = f4 * rf(M, 8210324)
    f3 = f3 + f4
    f4 = rf(M, 8214096)
    f4 = f4 * rf(M, 8218728)
    f3 = f3 + f4
    f2 = f2 + f3
    wfd(8217620, f2)
    f2 = rf(M, 8217596)
    q = fd(f2)
    if q < TINY and q > -TINY then f2 = 1 else f2 = 1 / q end
    f2 = f2 * rf(M, 8217620)
    wfd(8210312, f2)
    f2 = rf(M, 8217600)
    f2 = f2 * rf(M, 8210312)
    f2 = rf(M, 8217624) - f2
    q = fd(f2)
    if q < TINY and q > -TINY then f2 = 1 else f2 = 1 / q end
    f3 = rf(M, 8213892)
    f3 = f3 * rf(M, 8217188)
    f4 = rf(M, 8213896)
    f4 = f4 * rf(M, 8217192)
    f3 = f3 + f4
    f4 = rf(M, 8217196)
    f4 = f4 * rf(M, 8218228)
    f3 = f3 + f4
    f4 = rf(M, 8217200)
    f4 = f4 * rf(M, 8218384)
    f3 = f3 + f4
    f3 = f3 + rf(M, 8217176)
    f4 = rf(M, 8214060)
    f4 = f4 * rf(M, 8217212)
    f5 = rf(M, 8214064)
    f5 = f5 * rf(M, 8217216)
    f4 = f4 + f5
    f5 = rf(M, 8217220)
    f5 = f5 * rf(M, 8218308)
    f4 = f4 + f5
    f5 = rf(M, 8217224)
    f5 = f5 * rf(M, 8218384)
    f4 = f4 + f5
    f3 = f3 + f4
    wfd(8217176, f3)
    f3 = rf(M, 8210288)
    f3 = f3 * rf(M, 8218384)
    f4 = rf(M, 8210292)
    f4 = f4 * rf(M, 8218396)
    f3 = f3 + f4
    f4 = rf(M, 8210320)
    f4 = f4 * rf(M, 8218384)
    f5 = rf(M, 8210324)
    f5 = f5 * rf(M, 8218408)
    f4 = f4 + f5
    f3 = f3 + f4
    wfd(8217612, f3)
    f3 = rf(M, 8213764)
    f3 = f3 * rf(M, 8217612)
    f4 = rf(M, 8213900)
    f4 = f4 * rf(M, 8210288)
    f5 = rf(M, 8213908)
    f5 = f5 * rf(M, 8210292)
    f4 = f4 + f5
    f5 = rf(M, 8214084)
    f5 = f5 * rf(M, 8218660)
    f4 = f4 + f5
    f5 = rf(M, 8214068)
    f5 = f5 * rf(M, 8210320)
    f6 = rf(M, 8214076)
    f6 = f6 * rf(M, 8210324)
    f5 = f5 + f6
    f6 = rf(M, 8214084)
    f6 = f6 * rf(M, 8218724)
    f5 = f5 + f6
    f4 = f4 + f5
    wfd(8217616, f4)
    f4 = rf(M, 8213768)
    f4 = f4 * rf(M, 8217616)
    f3 = f3 + f4
    f4 = rf(M, 8210484)
    f4 = f4 * rf(M, 8217620)
    f3 = f3 + f4
    f4 = rf(M, 8210432)
    f4 = f4 * rf(M, 8217624)
    f3 = f3 + f4
    f4 = rf(M, 8213904)
    f4 = f4 * rf(M, 8210288)
    f5 = rf(M, 8213912)
    f5 = f5 * rf(M, 8210292)
    f4 = f4 + f5
    f4 = f4 + rf(M, 8218672)
    f5 = rf(M, 8214072)
    f5 = f5 * rf(M, 8210320)
    f6 = rf(M, 8214080)
    f6 = f6 * rf(M, 8210324)
    f5 = f5 + f6
    f5 = f5 + rf(M, 8218732)
    f4 = f4 + f5
    wfd(8217628, f4)
    f4 = rf(M, 8213780)
    f4 = f4 * rf(M, 8217628)
    f3 = f3 + f4
    f4 = rf(M, 8210288)
    f4 = f4 * rf(M, 8218640)
    f5 = rf(M, 8210292)
    f5 = f5 * rf(M, 8218644)
    f4 = f4 + f5
    f5 = rf(M, 8210320)
    f5 = f5 * rf(M, 8218708)
    f6 = rf(M, 8210324)
    f6 = f6 * rf(M, 8218712)
    f5 = f5 + f6
    f4 = f4 + f5
    wfd(8217632, f4)
    f4 = rf(M, 8214120)
    f4 = f4 * rf(M, 8217632)
    f3 = f3 + f4
    f3 = rf(M, 8217176) - f3
    f4 = rf(M, 8210316)
    f4 = f4 * rf(M, 8210312)
    f3 = f3 - f4
    f2 = f2 * f3
    wfd(8213544, f2)
    f2 = f2 * rf(M, 8217600)
    f2 = rf(M, 8210316) - f2
    f1 = f1 * f2
    wfd(8213540, f1)
    f1 = f1 + rf(M, 8210484)
    wfd(8213772, f1)
  end
  local function C11()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8213544)
    f1 = f1 + rf(M, 8210432)
    wfd(8213776, f1)
    f1 = rf(M, 8213764)
    f1 = f1 * rf(M, 8218384)
    f2 = rf(M, 8213768)
    f2 = f2 * rf(M, 8213900)
    f1 = f1 + f2
    f2 = rf(M, 8213772)
    f2 = f2 * rf(M, 8213920)
    f1 = f1 + f2
    f2 = rf(M, 8213776)
    f2 = f2 * rf(M, 8213892)
    f1 = f1 + f2
    f2 = rf(M, 8213780)
    f2 = f2 * rf(M, 8213904)
    f1 = f1 + f2
    f2 = rf(M, 8214120)
    f2 = f2 * rf(M, 8218640)
    f1 = f1 + f2
    wfd(8213932, f1)
    f1 = rf(M, 8213764)
    f1 = f1 * rf(M, 8218396)
    f2 = rf(M, 8213768)
    f2 = f2 * rf(M, 8213908)
    f1 = f1 + f2
    f2 = rf(M, 8213772)
    f2 = f2 * rf(M, 8213924)
    f1 = f1 + f2
    f2 = rf(M, 8213776)
    f2 = f2 * rf(M, 8213896)
    f1 = f1 + f2
    f2 = rf(M, 8213780)
    f2 = f2 * rf(M, 8213912)
    f1 = f1 + f2
    f2 = rf(M, 8214120)
    f2 = f2 * rf(M, 8218644)
    f1 = f1 + f2
    wfd(8213936, f1)
    f1 = rf(M, 8213768)
    f1 = f1 * rf(M, 8214084)
    f2 = rf(M, 8213772)
    f2 = f2 * rf(M, 8214096)
    f1 = f1 + f2
    f2 = rf(M, 8213776)
    f2 = f2 * rf(M, 8218228)
    f1 = f1 + f2
    wfd(8213940, f1)
    f1 = rf(M, 8213776)
    f1 = f1 * rf(M, 8218384)
    f2 = rf(M, 8213780)
    f2 = f2 * rf(M, 8218388)
    f1 = f1 + f2
    wfd(8213944, f1)
    f1 = rf(M, 8213776)
    f1 = f1 * rf(M, 8218396)
    f2 = rf(M, 8213780)
    f2 = f2 * rf(M, 8218384)
    f1 = f1 + f2
    wfd(8210432, f1)
    f1 = rf(M, 8210432)
    f1 = f1 * rf(M, 8218800)
    f1 = rf(M, 8217204) - f1
    f1 = f1 * rf(M, 8218804)
    wfd(8213788, f1)
    f1 = f1 + rf(M, 8210432)
    wfd(8213948, f1)
    f1 = rf(M, 8213764)
    f1 = f1 * rf(M, 8218384)
    f2 = rf(M, 8213768)
    f2 = f2 * rf(M, 8214068)
    f1 = f1 + f2
    f2 = rf(M, 8213772)
    f2 = f2 * rf(M, 8214088)
    f1 = f1 + f2
    f2 = rf(M, 8213776)
    f2 = f2 * rf(M, 8214060)
    f1 = f1 + f2
    f2 = rf(M, 8213780)
    f2 = f2 * rf(M, 8214072)
    f1 = f1 + f2
    f2 = rf(M, 8214120)
    f2 = f2 * rf(M, 8218708)
    f1 = f1 + f2
    wfd(8214100, f1)
    f1 = rf(M, 8213764)
    f1 = f1 * rf(M, 8218408)
    f2 = rf(M, 8213768)
    f2 = f2 * rf(M, 8214076)
    f1 = f1 + f2
    f2 = rf(M, 8213772)
    f2 = f2 * rf(M, 8214092)
    f1 = f1 + f2
    f2 = rf(M, 8213776)
    f2 = f2 * rf(M, 8214064)
    f1 = f1 + f2
    f2 = rf(M, 8213780)
    f2 = f2 * rf(M, 8214080)
    f1 = f1 + f2
    f2 = rf(M, 8214120)
    f2 = f2 * rf(M, 8218712)
    f1 = f1 + f2
    wfd(8214104, f1)
    f1 = rf(M, 8213768)
    f1 = f1 * rf(M, 8214084)
    f2 = rf(M, 8213772)
    f2 = f2 * rf(M, 8214096)
    f1 = f1 + f2
    f2 = rf(M, 8213776)
    f2 = f2 * rf(M, 8218308)
    f1 = f1 + f2
    wfd(8214108, f1)
    f1 = rf(M, 8213776)
    f1 = f1 * rf(M, 8218384)
    f2 = rf(M, 8213780)
    f2 = f2 * rf(M, 8218400)
    f1 = f1 + f2
    wfd(8214112, f1)
    f1 = rf(M, 8213776)
    f1 = f1 * rf(M, 8218408)
    f2 = rf(M, 8213780)
    f2 = f2 * rf(M, 8218384)
    f1 = f1 + f2
    wfd(8210432, f1)
    f1 = rf(M, 8210432)
    f1 = f1 * rf(M, 8218800)
    f1 = rf(M, 8217228) - f1
    f1 = f1 * rf(M, 8218808)
    wfd(8213956, f1)
    f1 = f1 + rf(M, 8210432)
    wfd(8214116, f1)
    f1 = rf(M, 8218412)
    f1 = f1 * rf(M, 8214736)
    f2 = rf(M, 8218416)
    f2 = f2 * rf(M, 8214740)
    f1 = f1 + f2
    wfd(8214228, f1)
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8214228)
    f2 = rf(M, 8218412)
    f2 = f2 * rf(M, 8214756)
    f3 = rf(M, 8218416)
    f3 = f3 * rf(M, 8214764)
    f2 = f2 + f3
    wfd(8214240, f2)
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8214240)
    f1 = f1 + f2
    f2 = rf(M, 8218412)
    f2 = f2 * rf(M, 8214776)
    f3 = rf(M, 8218416)
    f3 = f3 * rf(M, 8214784)
    f2 = f2 + f3
    wfd(8214252, f2)
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8214252)
    f1 = f1 + f2
    wfd(8214264, f1)
    f1 = rf(M, 8218424)
    f1 = f1 * rf(M, 8214736)
    f2 = rf(M, 8218412)
    f2 = f2 * rf(M, 8214740)
    f1 = f1 + f2
    wfd(8214232, f1)
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8214232)
    f2 = rf(M, 8218424)
    f2 = f2 * rf(M, 8214756)
    f3 = rf(M, 8218412)
    f3 = f3 * rf(M, 8214764)
    f2 = f2 + f3
    wfd(8214244, f2)
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8214244)
    f1 = f1 + f2
    f2 = rf(M, 8218424)
    f2 = f2 * rf(M, 8214776)
    f3 = rf(M, 8218412)
    f3 = f3 * rf(M, 8214784)
    f2 = f2 + f3
    wfd(8214256, f2)
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8214256)
    f1 = f1 + f2
    wfd(8214268, f1)
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8214748)
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8214768)
    f1 = f1 + f2
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8214792)
    f1 = f1 + f2
    wfd(8214272, f1)
    f1 = rf(M, 8214808)
    f1 = f1 * rf(M, 8218424)
    f2 = rf(M, 8214812)
    f2 = f2 * rf(M, 8218412)
    f1 = f1 + f2
    wfd(8214280, f1)
    f1 = rf(M, 8214808)
    f1 = f1 * rf(M, 8218412)
    f2 = rf(M, 8214812)
    f2 = f2 * rf(M, 8218416)
    f1 = f1 + f2
    wfd(8210432, f1)
    f1 = rf(M, 8210432)
    f1 = f1 * rf(M, 8218812)
    f1 = rf(M, 8217236) - f1
    f1 = f1 * rf(M, 8218816)
    wfd(8214124, f1)
    f1 = f1 + rf(M, 8210432)
    wfd(8214276, f1)
    f1 = rf(M, 8218412)
    f1 = f1 * rf(M, 8214736)
    f2 = rf(M, 8218416)
    f2 = f2 * rf(M, 8214740)
    f1 = f1 + f2
    wfd(8214392, f1)
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8214392)
    f2 = rf(M, 8218412)
    f2 = f2 * rf(M, 8214756)
    f3 = rf(M, 8218416)
    f3 = f3 * rf(M, 8214764)
    f2 = f2 + f3
    wfd(8214404, f2)
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8214404)
    f1 = f1 + f2
    f2 = rf(M, 8218412)
    f2 = f2 * rf(M, 8214776)
    f3 = rf(M, 8218416)
    f3 = f3 * rf(M, 8214784)
    f2 = f2 + f3
    wfd(8214416, f2)
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8214416)
    f1 = f1 + f2
    wfd(8214428, f1)
    f1 = rf(M, 8218424)
    f1 = f1 * rf(M, 8214736)
    f2 = rf(M, 8218412)
    f2 = f2 * rf(M, 8214740)
    f1 = f1 + f2
    wfd(8214396, f1)
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8214396)
    f2 = rf(M, 8218424)
    f2 = f2 * rf(M, 8214756)
    f3 = rf(M, 8218412)
    f3 = f3 * rf(M, 8214764)
    f2 = f2 + f3
    wfd(8214408, f2)
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8214408)
    f1 = f1 + f2
    f2 = rf(M, 8218424)
    f2 = f2 * rf(M, 8214776)
    f3 = rf(M, 8218412)
    f3 = f3 * rf(M, 8214784)
    f2 = f2 + f3
    wfd(8214420, f2)
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8214420)
    f1 = f1 + f2
    wfd(8214432, f1)
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8214748)
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8214768)
    f1 = f1 + f2
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8214792)
    f1 = f1 + f2
    wfd(8214436, f1)
    f1 = rf(M, 8214808)
    f1 = f1 * rf(M, 8218424)
    f2 = rf(M, 8214812)
    f2 = f2 * rf(M, 8218412)
    f1 = f1 + f2
    wfd(8214444, f1)
    f1 = rf(M, 8214808)
    f1 = f1 * rf(M, 8218412)
    f2 = rf(M, 8214812)
    f2 = f2 * rf(M, 8218416)
    f1 = f1 + f2
    wfd(8210432, f1)
    f1 = rf(M, 8210432)
    f1 = f1 * rf(M, 8218820)
    f1 = rf(M, 8217248) - f1
    f1 = f1 * rf(M, 8218824)
    wfd(8214288, f1)
    f1 = f1 + rf(M, 8210432)
    wfd(8214440, f1)
    f1 = rf(M, 8218412)
    f1 = f1 * rf(M, 8214736)
    f2 = rf(M, 8218416)
    f2 = f2 * rf(M, 8214740)
    f1 = f1 + f2
    wfd(8214556, f1)
  end
  local function C12()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8214556)
    f2 = rf(M, 8218412)
    f2 = f2 * rf(M, 8214756)
    f3 = rf(M, 8218416)
    f3 = f3 * rf(M, 8214764)
    f2 = f2 + f3
    wfd(8214568, f2)
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8214568)
    f1 = f1 + f2
    f2 = rf(M, 8218412)
    f2 = f2 * rf(M, 8214776)
    f3 = rf(M, 8218416)
    f3 = f3 * rf(M, 8214784)
    f2 = f2 + f3
    wfd(8214580, f2)
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8214580)
    f1 = f1 + f2
    wfd(8214592, f1)
    f1 = rf(M, 8218424)
    f1 = f1 * rf(M, 8214736)
    f2 = rf(M, 8218412)
    f2 = f2 * rf(M, 8214740)
    f1 = f1 + f2
    wfd(8214560, f1)
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8214560)
    f2 = rf(M, 8218424)
    f2 = f2 * rf(M, 8214756)
    f3 = rf(M, 8218412)
    f3 = f3 * rf(M, 8214764)
    f2 = f2 + f3
    wfd(8214572, f2)
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8214572)
    f1 = f1 + f2
    f2 = rf(M, 8218424)
    f2 = f2 * rf(M, 8214776)
    f3 = rf(M, 8218412)
    f3 = f3 * rf(M, 8214784)
    f2 = f2 + f3
    wfd(8214584, f2)
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8214584)
    f1 = f1 + f2
    wfd(8214596, f1)
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8214748)
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8214768)
    f1 = f1 + f2
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8214792)
    f1 = f1 + f2
    wfd(8214600, f1)
    f1 = rf(M, 8214808)
    f1 = f1 * rf(M, 8218424)
    f2 = rf(M, 8214812)
    f2 = f2 * rf(M, 8218412)
    f1 = f1 + f2
    wfd(8214608, f1)
    f1 = rf(M, 8214808)
    f1 = f1 * rf(M, 8218412)
    f2 = rf(M, 8214812)
    f2 = f2 * rf(M, 8218416)
    f1 = f1 + f2
    wfd(8210432, f1)
    f1 = rf(M, 8210432)
    f1 = f1 * rf(M, 8218812)
    f1 = rf(M, 8217260) - f1
    f1 = f1 * rf(M, 8218816)
    wfd(8214452, f1)
    f1 = f1 + rf(M, 8210432)
    wfd(8214604, f1)
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8214736)
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8214756)
    f1 = f1 + f2
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8214776)
    f1 = f1 + f2
    f2 = rf(M, 8218436)
    f2 = f2 + rf(M, 8214636)
    wfd(8214760, f2)
    f2 = rf(M, 8214812)
    f2 = f2 * rf(M, 8214760)
    f1 = f1 + f2
    f2 = rf(M, 8214632)
    wfd(8214752, f2)
    f2 = -f2
    wfd(8214780, f2)
    f2 = rf(M, 8214816)
    f2 = f2 * rf(M, 8214780)
    f1 = f1 + f2
    wfd(8210432, f1)
    f1 = rf(M, 8210432)
    f1 = f1 * rf(M, 8218828)
    f1 = rf(M, 8217272) - f1
    f1 = f1 * rf(M, 8218836)
    wfd(8214616, f1)
    f1 = f1 + rf(M, 8210432)
    wfd(8214796, f1)
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8214740)
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8214764)
    f1 = f1 + f2
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8214784)
    f1 = f1 + f2
    f2 = rf(M, 8214760)
    f2 = -f2
    wfd(8214744, f2)
    f2 = rf(M, 8214808)
    f2 = f2 * rf(M, 8214744)
    f1 = f1 + f2
    f2 = rf(M, 8218428)
    f2 = f2 + rf(M, 8214628)
    wfd(8214788, f2)
    f2 = rf(M, 8214816)
    f2 = f2 * rf(M, 8214788)
    f1 = f1 + f2
    wfd(8210432, f1)
    f1 = rf(M, 8210432)
    f1 = f1 * rf(M, 8218832)
    f1 = rf(M, 8217276) - f1
    f1 = f1 * rf(M, 8218840)
    wfd(8214620, f1)
    f1 = f1 + rf(M, 8210432)
    wfd(8214800, f1)
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8214748)
    f2 = rf(M, 8212168)
    f2 = f2 * rf(M, 8214768)
    f1 = f1 + f2
    f2 = rf(M, 8212172)
    f2 = f2 * rf(M, 8214792)
    f1 = f1 + f2
    f2 = rf(M, 8214808)
    f2 = f2 * rf(M, 8214752)
    f1 = f1 + f2
    f2 = rf(M, 8214788)
    f2 = -f2
    wfd(8214772, f2)
    f2 = rf(M, 8214812)
    f2 = f2 * rf(M, 8214772)
    f1 = f1 + f2
    wfd(8210432, f1)
    f1 = rf(M, 8210432)
    f1 = f1 * rf(M, 8218828)
    f1 = rf(M, 8217280) - f1
    f1 = f1 * rf(M, 8218836)
    wfd(8214624, f1)
    f1 = f1 + rf(M, 8210432)
    wfd(8214804, f1)
    r_eax = ru(M, 8204252)
    wu(M, 8214892, r_eax)
    wu(M, 8214868, r_eax)
    wu(M, 8214844, r_eax)
    wu(M, 8214820, r_eax)
    r_eax = ru(M, 8204256)
    wu(M, 8214896, r_eax)
    wu(M, 8214872, r_eax)
    wu(M, 8214848, r_eax)
    wu(M, 8214824, r_eax)
    r_eax = ru(M, 8204260)
    wu(M, 8214900, r_eax)
    wu(M, 8214876, r_eax)
    wu(M, 8214852, r_eax)
    wu(M, 8214828, r_eax)
    r_eax = ru(M, 8204264)
    wu(M, 8214904, r_eax)
    wu(M, 8214880, r_eax)
    wu(M, 8214856, r_eax)
    wu(M, 8214832, r_eax)
    r_eax = ru(M, 8204268)
    wu(M, 8214908, r_eax)
    wu(M, 8214884, r_eax)
    wu(M, 8214860, r_eax)
    wu(M, 8214836, r_eax)
    r_eax = ru(M, 8204272)
    wu(M, 8214912, r_eax)
    wu(M, 8214888, r_eax)
    wu(M, 8214864, r_eax)
    wu(M, 8214840, r_eax)
    do local sp = NB(0); NC(0x55e3e0, 0) end
  end
  JIT[0xeafbf3] = function() -- solve
    C1()
    C2()
    C3()
    C4()
    C5()
    C6()
    C7()
    C8()
    C9()
    C10()
    C11()
    C12()
  end
end
end
]=])
module("NR2003Cup","NR2003CupJIT3",[=[
--!native
--!optimize 2
-- GENERATED NR2003 Cup vehicle runtime: translated JIT callbacks, part 3 (tire0, tire1, tire2, tire3, forces).
-- These are the x87 callbacks NR2003.exe generates itself at car build (005b3090, mode-2 emitter),
-- translated instruction by instruction. Float32 stores round toward -inf (CW 0x077f).
-- Do not edit by hand: regenerate with recovery/stage6_7/gen_runtime.py.
return function(ctx)
local M, JIT, LKF, LKU, NB, NC = ctx.M, ctx.JIT, ctx.LKF, ctx.LKU, ctx.NB, ctx.NC
local rf, wf, ru, wu = buffer.readf32, buffer.writef32, buffer.readu32, buffer.writeu32
local abs, sqrt, sin, cos, fmod = math.abs, math.sqrt, math.sin, math.cos, math.fmod
local TINY = 2 ^ -125
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

do -- tire0 (2 chunks)
  local r_eax, r_ebx, r_ecx, r_edx, r_esi, r_edi
  local function C1()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8212504)
    f1 = f1 * rf(M, 8204212)
    wfd(8210432, f1)
    f1 = sin(f1)
    wfd(8210484, f1)
    f1 = f1 * rf(M, 8212884)
    f2 = rf(M, 8210432)
    f2 = cos(f2)
    f3 = rf(M, 8212504)
    f3 = f3 * rf(M, 8204228)
    f3 = f3 + rf(M, 8204152)
    wfd(8210432, f3)
    f3 = cos(f3)
    f2 = f2 * f3
    wfd(8210316, f2)
    f2 = f2 * rf(M, 8212888)
    f1 = f1 + f2
    f2 = rf(M, 8210432)
    f2 = sin(f2)
    wfd(8210432, f2)
    f2 = f2 * rf(M, 8212892)
    f1 = f1 + f2
    wfd(8210312, f1)
    f1 = f1 * rf(M, 8204284)
    f2 = rf(M, 8210484)
    f2 = f2 * rf(M, 8212896)
    f3 = rf(M, 8210316)
    f3 = f3 * rf(M, 8212900)
    f2 = f2 + f3
    f3 = rf(M, 8210432)
    f3 = f3 * rf(M, 8212904)
    f2 = f2 + f3
    wfd(8210324, f2)
    f2 = f2 * rf(M, 8204280)
    f1 = f1 - f2
    wfd(8210320, f1)
    f1 = f1 * f1
    f2 = rf(M, 8210324)
    f2 = f2 * rf(M, 8204276)
    f3 = rf(M, 8210484)
    f3 = f3 * rf(M, 8212872)
    f4 = rf(M, 8210316)
    f4 = f4 * rf(M, 8212876)
    f3 = f3 + f4
    f4 = rf(M, 8210432)
    f4 = f4 * rf(M, 8212880)
    f3 = f3 + f4
    wfd(8210432, f3)
    f3 = f3 * rf(M, 8204284)
    f2 = f2 - f3
    wfd(8210316, f2)
    f2 = f2 * f2
    f1 = f1 + f2
    f2 = rf(M, 8210432)
    f2 = f2 * rf(M, 8204280)
    f3 = rf(M, 8210312)
    f3 = f3 * rf(M, 8204276)
    f2 = f2 - f3
    wfd(8210484, f2)
    f2 = f2 * f2
    f1 = f1 + f2
    f1 = sqrt(f1)
    q = fd(f1)
    if q < TINY and q > -TINY then f1 = 1 else f1 = 1 / q end
    wfd(8210292, f1)
    f1 = rf(M, 8210320)
    f1 = f1 * rf(M, 8210292)
    wfd(8210320, f1)
    f1 = rf(M, 8210316)
    f1 = f1 * rf(M, 8210292)
    wfd(8210316, f1)
    f1 = rf(M, 8210484)
    f1 = f1 * rf(M, 8210292)
    wfd(8210292, f1)
    f1 = rf(M, 8212764)
    f1 = f1 * rf(M, 8204244)
    p1 = fd(f1)
    f1 = rf(M, 8204276)
    f1 = f1 * rf(M, 8212920)
    f2 = rf(M, 8204280)
    f2 = f2 * rf(M, 8212924)
    f1 = f1 + f2
    f2 = rf(M, 8204284)
    f2 = f2 * rf(M, 8212928)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8204288)
    wfd(8210484, f1)
    f1 = rf(M, 8210292)
    f1 = f1 * rf(M, 8204280)
    f2 = rf(M, 8210316)
    f2 = f2 * rf(M, 8204284)
    f1 = f1 - f2
    wfd(8210288, f1)
    f1 = f1 * f1
    f2 = rf(M, 8210320)
    f2 = f2 * rf(M, 8204284)
    f3 = rf(M, 8210292)
    f3 = f3 * rf(M, 8204276)
    f2 = f2 - f3
    wfd(8210284, f2)
    f2 = f2 * f2
    f1 = f1 + f2
    f2 = rf(M, 8210316)
    f2 = f2 * rf(M, 8204276)
    f3 = rf(M, 8210320)
    f3 = f3 * rf(M, 8204280)
    f2 = f2 - f3
    wfd(8210280, f2)
    f2 = f2 * f2
    f1 = f1 + f2
    f1 = sqrt(f1)
    q = fd(f1)
    if q < TINY and q > -TINY then f1 = 1 else f1 = 1 / q end
    wfd(8210456, f1)
    f1 = rf(M, 8210288)
    f1 = f1 * rf(M, 8210456)
    wfd(8210288, f1)
    f1 = f1 * rf(M, 8210432)
    f2 = rf(M, 8210284)
    f2 = f2 * rf(M, 8210456)
    wfd(8210284, f2)
    f2 = f2 * rf(M, 8210312)
    f1 = f1 + f2
    f2 = rf(M, 8210280)
    f2 = f2 * rf(M, 8210456)
    wfd(8210456, f2)
    f2 = f2 * rf(M, 8210324)
    f1 = f1 + f2
    wfd(8210280, f1)
    f1 = f1 * rf(M, 8218848)
    f2 = rf(M, 8210432)
    f2 = f2 * rf(M, 8204276)
    f3 = rf(M, 8210312)
    f3 = f3 * rf(M, 8204280)
    f2 = f2 + f3
    f3 = rf(M, 8210324)
    f3 = f3 * rf(M, 8204284)
    f2 = f2 + f3
    wfd(8210324, f2)
    f2 = f2 * rf(M, 8218844)
    f2 = abs(f2)
    f1 = f1 + f2
    wfd(8210312, f1)
    f1 = rf(M, 8210484) - f1
    f1 = fd(f1)
    if f1 > 0 or (f1 == 0 and 1 / f1 > 0) or f1 ~= f1 then f1 = 0 end
    wfd(8210432, f1)
    f1 = rf(M, 8210280)
    f1 = f1 * rf(M, 8204156)
    f1 = f1 * rf(M, 8210280)
    f1 = f1 + rf(M, 8210312)
    wfd(8210312, f1)
    f1 = rf(M, 8210484) - f1
    f1 = fd(f1)
    if f1 > 0 or (f1 == 0 and 1 / f1 > 0) or f1 ~= f1 then f1 = 0 end
    f1 = f1 - rf(M, 8210432)
    wfd(8210484, f1)
    f1 = rf(M, 8210312)
    f1 = -f1
    f1 = f1 - rf(M, 8210484)
    wfd(8210312, f1)
    f1 = f1 * rf(M, 8204276)
    f2 = rf(M, 8210324)
    f2 = f2 * rf(M, 8218848)
    wfd(8210280, f2)
    f2 = rf(M, 8210288)
    f2 = f2 * rf(M, 8210280)
    f1 = f1 + f2
    wfd(8210308, f1)
    f1 = f1 + rf(M, 8212920)
    wfd(8211740, f1)
    f1 = f1 - rf(M, 8204304)
    wfd(8211764, f1)
    f1 = rf(M, 8210288)
    f1 = f1 * rf(M, 8211764)
    f2 = rf(M, 8210312)
    f2 = f2 * rf(M, 8204280)
    f3 = rf(M, 8210284)
    f3 = f3 * rf(M, 8210280)
    f2 = f2 + f3
    wfd(8210492, f2)
    f2 = f2 + rf(M, 8212924)
    wfd(8211744, f2)
    f2 = f2 - rf(M, 8204308)
    wfd(8211768, f2)
    f2 = rf(M, 8210284)
    f2 = f2 * rf(M, 8211768)
    f1 = f1 + f2
    f2 = rf(M, 8210312)
    f2 = f2 * rf(M, 8204284)
    f3 = rf(M, 8210456)
    f3 = f3 * rf(M, 8210280)
    f2 = f2 + f3
    wfd(8210280, f2)
    f2 = f2 + rf(M, 8212928)
    wfd(8211748, f2)
    f2 = f2 - rf(M, 8204312)
    wfd(8211772, f2)
    f2 = rf(M, 8210456)
    f2 = f2 * rf(M, 8211772)
    f1 = f1 + f2
    p2 = fd(f1)
    f1 = rf(M, 8210320)
    f1 = f1 * rf(M, 8211764)
    f2 = rf(M, 8210316)
    f2 = f2 * rf(M, 8211768)
    f1 = f1 + f2
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8211772)
    f1 = f1 + f2
    f2 = rf(M, 8218856)
    f2 = f2 * rf(M, 8212868)
    wfd(8210312, f2)
    f2 = f2 * rf(M, 8218136)
    f1 = f1 - f2
    p3 = fd(f1)
    p4 = ru(M, 8210324)
    p5 = ru(M, 8210432)
    p6 = ru(M, 8210484)
    p7 = ru(M, 8210312)
    f1 = rf(M, 8210308)
    f1 = f1 * rf(M, 8212880)
    f2 = rf(M, 8210492)
    f2 = f2 * rf(M, 8212892)
    f1 = f1 + f2
    f2 = rf(M, 8210280)
    f2 = f2 * rf(M, 8212904)
    f1 = f1 + f2
    wfd(8210312, f1)
    f1 = f1 * rf(M, 8212860)
    f2 = rf(M, 8210308)
    f2 = f2 * rf(M, 8212876)
    f3 = rf(M, 8210492)
    f3 = f3 * rf(M, 8212888)
    f2 = f2 + f3
    f3 = rf(M, 8210280)
    f3 = f3 * rf(M, 8212900)
    f2 = f2 + f3
    wfd(8210484, f2)
    f2 = f2 * rf(M, 8212864)
    f1 = f1 - f2
    f1 = f1 + rf(M, 8212996)
    wfd(8210432, f1)
    f1 = f1 * rf(M, 8212872)
    f2 = rf(M, 8210308)
    f2 = f2 * rf(M, 8212872)
    f3 = rf(M, 8210492)
    f3 = f3 * rf(M, 8212884)
    f2 = f2 + f3
    f3 = rf(M, 8210280)
    f3 = f3 * rf(M, 8212896)
    f2 = f2 + f3
    wfd(8210280, f2)
    f2 = f2 * rf(M, 8212864)
    f3 = rf(M, 8210312)
    f3 = f3 * rf(M, 8212856)
    f2 = f2 - f3
    f2 = f2 + rf(M, 8213000)
    wfd(8210492, f2)
    f2 = f2 * rf(M, 8212876)
    f1 = f1 + f2
    f2 = rf(M, 8210484)
    f2 = f2 * rf(M, 8212856)
    f3 = rf(M, 8210280)
    f3 = f3 * rf(M, 8212860)
    f2 = f2 - f3
    f2 = f2 + rf(M, 8213004)
    wfd(8210308, f2)
    f2 = f2 * rf(M, 8212880)
    f1 = f1 + f2
    f1 = f1 - rf(M, 8204292)
    wfd(8211752, f1)
    f1 = f1 * rf(M, 8204276)
    f2 = rf(M, 8210432)
    f2 = f2 * rf(M, 8212884)
    f3 = rf(M, 8210492)
    f3 = f3 * rf(M, 8212888)
    f2 = f2 + f3
    f3 = rf(M, 8210308)
    f3 = f3 * rf(M, 8212892)
    f2 = f2 + f3
    f2 = f2 - rf(M, 8204296)
    wfd(8211756, f2)
    f2 = f2 * rf(M, 8204280)
    f1 = f1 + f2
    f2 = rf(M, 8210432)
    f2 = f2 * rf(M, 8212896)
    f3 = rf(M, 8210492)
    f3 = f3 * rf(M, 8212900)
    f2 = f2 + f3
    f3 = rf(M, 8210308)
    f3 = f3 * rf(M, 8212904)
    f2 = f2 + f3
    f2 = f2 - rf(M, 8204300)
    wfd(8211760, f2)
    f2 = f2 * rf(M, 8204284)
    f1 = f1 + f2
    p8 = fd(f1)
    f1 = rf(M, 8210288)
    f1 = f1 * rf(M, 8211752)
    f2 = rf(M, 8210284)
    f2 = f2 * rf(M, 8211756)
    f1 = f1 + f2
    f2 = rf(M, 8210456)
    f2 = f2 * rf(M, 8211760)
    f1 = f1 + f2
    p9 = fd(f1)
    f1 = rf(M, 8210320)
    f1 = f1 * rf(M, 8211752)
    f2 = rf(M, 8210316)
    f2 = f2 * rf(M, 8211756)
    f1 = f1 + f2
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8211760)
    f1 = f1 + f2
    p10 = fd(f1)
    do local sp = NB(14); wu(M, sp + -7245816, 15453292); wu(M, sp + -7245812, 15453296); wu(M, sp + -7245808, 15453300); wu(M, sp + -7245804, 15453304); wf(M, sp + -7245800, p10); wf(M, sp + -7245796, p9); wf(M, sp + -7245792, p8); wu(M, sp + -7245788, p7); wu(M, sp + -7245784, p6); wu(M, sp + -7245780, p5); wu(M, sp + -7245776, p4); wf(M, sp + -7245772, p3); wf(M, sp + -7245768, p2); wf(M, sp + -7245764, p1); NC(0x55d880, 14) end
  end
  local function C2()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8210320)
    f1 = f1 * rf(M, 8207472)
    f2 = rf(M, 8210288)
    f2 = f2 * rf(M, 8207476)
    f1 = f1 + f2
    f2 = rf(M, 8204276)
    f2 = f2 * rf(M, 8207480)
    f1 = f1 + f2
    wfd(8210288, f1)
    f1 = f1 * rf(M, 8212880)
    f2 = rf(M, 8210316)
    f2 = f2 * rf(M, 8207472)
    f3 = rf(M, 8210284)
    f3 = f3 * rf(M, 8207476)
    f2 = f2 + f3
    f3 = rf(M, 8204280)
    f3 = f3 * rf(M, 8207480)
    f2 = f2 + f3
    wfd(8210284, f2)
    f2 = f2 * rf(M, 8212892)
    f1 = f1 + f2
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8207472)
    f3 = rf(M, 8210456)
    f3 = f3 * rf(M, 8207476)
    f2 = f2 + f3
    f3 = rf(M, 8204284)
    f3 = f3 * rf(M, 8207480)
    f2 = f2 + f3
    wfd(8210456, f2)
    f2 = f2 * rf(M, 8212904)
    f1 = f1 + f2
    f2 = rf(M, 8210320)
    f2 = f2 * rf(M, 8207468)
    wfd(8210320, f2)
    f2 = f2 * rf(M, 8212880)
    f3 = rf(M, 8210316)
    f3 = f3 * rf(M, 8207468)
    wfd(8210316, f3)
    f3 = f3 * rf(M, 8212892)
    f2 = f2 + f3
    f3 = rf(M, 8210292)
    f3 = f3 * rf(M, 8207468)
    wfd(8210308, f3)
    f3 = f3 * rf(M, 8212904)
    f2 = f2 + f3
    f1 = f1 + f2
    p1 = fd(f1)
    f1 = rf(M, 8210288)
    f1 = f1 * rf(M, 8212876)
    f2 = rf(M, 8210284)
    f2 = f2 * rf(M, 8212888)
    f1 = f1 + f2
    f2 = rf(M, 8210456)
    f2 = f2 * rf(M, 8212900)
    f1 = f1 + f2
    f2 = rf(M, 8210320)
    f2 = f2 * rf(M, 8212876)
    f3 = rf(M, 8210316)
    f3 = f3 * rf(M, 8212888)
    f2 = f2 + f3
    f3 = rf(M, 8210308)
    f3 = f3 * rf(M, 8212900)
    f2 = f2 + f3
    f1 = f1 + f2
    p2 = fd(f1)
    f1 = rf(M, 8210288)
    f1 = f1 * rf(M, 8212872)
    f2 = rf(M, 8210284)
    f2 = f2 * rf(M, 8212884)
    f1 = f1 + f2
    f2 = rf(M, 8210456)
    f2 = f2 * rf(M, 8212896)
    f1 = f1 + f2
    p3 = fd(f1)
    do local sp = NB(6); wu(M, sp + -7245816, 15453320); wu(M, sp + -7245812, 15453324); wu(M, sp + -7245808, 15453328); wf(M, sp + -7245804, p3); wf(M, sp + -7245800, p2); wf(M, sp + -7245796, p1); NC(0x55e160, 6) end
    f1 = rf(M, 8210320)
    f1 = f1 * rf(M, 8212872)
    f2 = rf(M, 8210316)
    f2 = f2 * rf(M, 8212884)
    f1 = f1 + f2
    f2 = rf(M, 8210308)
    f2 = f2 * rf(M, 8212896)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8207496)
    wfd(8210308, f1)
    f1 = f1 + rf(M, 8214820)
    wfd(8214820, f1)
    f1 = rf(M, 8207500)
    f1 = f1 + rf(M, 8214824)
    wfd(8214824, f1)
    f1 = rf(M, 8207504)
    f1 = f1 + rf(M, 8214828)
    wfd(8214828, f1)
    f1 = rf(M, 8210484)
    f1 = f1 * rf(M, 8207504)
    f2 = rf(M, 8210312)
    f2 = f2 * rf(M, 8207500)
    f1 = f1 - f2
    f1 = f1 + rf(M, 8214832)
    wfd(8214832, f1)
    f1 = rf(M, 8210312)
    f1 = f1 * rf(M, 8207496)
    f2 = rf(M, 8210280)
    f2 = f2 * rf(M, 8207504)
    f1 = f1 - f2
    f1 = f1 + rf(M, 8214836)
    wfd(8214836, f1)
    f1 = rf(M, 8210280)
    f1 = f1 * rf(M, 8207500)
    f2 = rf(M, 8210484)
    f2 = f2 * rf(M, 8207496)
    f1 = f1 - f2
    wfd(8210280, f1)
    f1 = f1 + rf(M, 8214840)
    wfd(8214840, f1)
    p1 = ru(M, 8210280)
    p2 = ru(M, 8207480)
    p3 = ru(M, 8207476)
    do local sp = NB(3); wu(M, sp + -7245816, p3); wu(M, sp + -7245812, p2); wu(M, sp + -7245808, p1); NC(0x55e180, 3) end
    f1 = rf(M, 8210308)
    f1 = f1 * rf(M, 8212872)
    f2 = rf(M, 8207500)
    f2 = f2 * rf(M, 8212876)
    f1 = f1 + f2
    f2 = rf(M, 8207504)
    f2 = f2 * rf(M, 8212880)
    f1 = f1 + f2
    wfd(8211728, f1)
    f1 = rf(M, 8210308)
    f1 = f1 * rf(M, 8212884)
    f2 = rf(M, 8207500)
    f2 = f2 * rf(M, 8212888)
    f1 = f1 + f2
    f2 = rf(M, 8207504)
    f2 = f2 * rf(M, 8212892)
    f1 = f1 + f2
    wfd(8211732, f1)
    f1 = rf(M, 8210308)
    f1 = f1 * rf(M, 8212896)
    f2 = rf(M, 8207500)
    f2 = f2 * rf(M, 8212900)
    f1 = f1 + f2
    f2 = rf(M, 8207504)
    f2 = f2 * rf(M, 8212904)
    f1 = f1 + f2
    wfd(8211736, f1)
  end
  JIT[0xeb4399] = function() -- tire0
    C1()
    C2()
  end
end
do -- tire1 (2 chunks)
  local r_eax, r_ebx, r_ecx, r_edx, r_esi, r_edi
  local function C1()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8213024)
    f1 = f1 * rf(M, 8204216)
    wfd(8210308, f1)
    f1 = sin(f1)
    wfd(8210280, f1)
    f1 = f1 * rf(M, 8213404)
    f2 = rf(M, 8210308)
    f2 = cos(f2)
    f3 = rf(M, 8213024)
    f3 = f3 * rf(M, 8204232)
    f3 = f3 + rf(M, 8204160)
    wfd(8210308, f3)
    f3 = cos(f3)
    f2 = f2 * f3
    wfd(8210484, f2)
    f2 = f2 * rf(M, 8213408)
    f1 = f1 + f2
    f2 = rf(M, 8210308)
    f2 = sin(f2)
    wfd(8210308, f2)
    f2 = f2 * rf(M, 8213412)
    f1 = f1 + f2
    wfd(8210312, f1)
    f1 = f1 * rf(M, 8204284)
    f2 = rf(M, 8210280)
    f2 = f2 * rf(M, 8213416)
    f3 = rf(M, 8210484)
    f3 = f3 * rf(M, 8213420)
    f2 = f2 + f3
    f3 = rf(M, 8210308)
    f3 = f3 * rf(M, 8213424)
    f2 = f2 + f3
    wfd(8210316, f2)
    f2 = f2 * rf(M, 8204280)
    f1 = f1 - f2
    wfd(8210320, f1)
    f1 = f1 * f1
    f2 = rf(M, 8210316)
    f2 = f2 * rf(M, 8204276)
    f3 = rf(M, 8210280)
    f3 = f3 * rf(M, 8213392)
    f4 = rf(M, 8210484)
    f4 = f4 * rf(M, 8213396)
    f3 = f3 + f4
    f4 = rf(M, 8210308)
    f4 = f4 * rf(M, 8213400)
    f3 = f3 + f4
    wfd(8210308, f3)
    f3 = f3 * rf(M, 8204284)
    f2 = f2 - f3
    wfd(8210484, f2)
    f2 = f2 * f2
    f1 = f1 + f2
    f2 = rf(M, 8210308)
    f2 = f2 * rf(M, 8204280)
    f3 = rf(M, 8210312)
    f3 = f3 * rf(M, 8204276)
    f2 = f2 - f3
    wfd(8210280, f2)
    f2 = f2 * f2
    f1 = f1 + f2
    f1 = sqrt(f1)
    q = fd(f1)
    if q < TINY and q > -TINY then f1 = 1 else f1 = 1 / q end
    wfd(8210456, f1)
    f1 = rf(M, 8210320)
    f1 = f1 * rf(M, 8210456)
    wfd(8210320, f1)
    f1 = rf(M, 8210484)
    f1 = f1 * rf(M, 8210456)
    wfd(8210484, f1)
    f1 = rf(M, 8210280)
    f1 = f1 * rf(M, 8210456)
    wfd(8210456, f1)
    f1 = rf(M, 8213284)
    f1 = f1 * rf(M, 8204248)
    p1 = fd(f1)
    f1 = rf(M, 8204276)
    f1 = f1 * rf(M, 8213440)
    f2 = rf(M, 8204280)
    f2 = f2 * rf(M, 8213444)
    f1 = f1 + f2
    f2 = rf(M, 8204284)
    f2 = f2 * rf(M, 8213448)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8204288)
    wfd(8210280, f1)
    f1 = rf(M, 8210456)
    f1 = f1 * rf(M, 8204280)
    f2 = rf(M, 8210484)
    f2 = f2 * rf(M, 8204284)
    f1 = f1 - f2
    wfd(8210284, f1)
    f1 = f1 * f1
    f2 = rf(M, 8210320)
    f2 = f2 * rf(M, 8204284)
    f3 = rf(M, 8210456)
    f3 = f3 * rf(M, 8204276)
    f2 = f2 - f3
    wfd(8210288, f2)
    f2 = f2 * f2
    f1 = f1 + f2
    f2 = rf(M, 8210484)
    f2 = f2 * rf(M, 8204276)
    f3 = rf(M, 8210320)
    f3 = f3 * rf(M, 8204280)
    f2 = f2 - f3
    wfd(8210292, f2)
    f2 = f2 * f2
    f1 = f1 + f2
    f1 = sqrt(f1)
    q = fd(f1)
    if q < TINY and q > -TINY then f1 = 1 else f1 = 1 / q end
    wfd(8210492, f1)
    f1 = rf(M, 8210284)
    f1 = f1 * rf(M, 8210492)
    wfd(8210284, f1)
    f1 = f1 * rf(M, 8210308)
    f2 = rf(M, 8210288)
    f2 = f2 * rf(M, 8210492)
    wfd(8210288, f2)
    f2 = f2 * rf(M, 8210312)
    f1 = f1 + f2
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8210492)
    wfd(8210492, f2)
    f2 = f2 * rf(M, 8210316)
    f1 = f1 + f2
    wfd(8210292, f1)
    f1 = f1 * rf(M, 8218852)
    f2 = rf(M, 8210308)
    f2 = f2 * rf(M, 8204276)
    f3 = rf(M, 8210312)
    f3 = f3 * rf(M, 8204280)
    f2 = f2 + f3
    f3 = rf(M, 8210316)
    f3 = f3 * rf(M, 8204284)
    f2 = f2 + f3
    wfd(8210316, f2)
    f2 = f2 * rf(M, 8218844)
    f2 = abs(f2)
    f1 = f1 + f2
    wfd(8210312, f1)
    f1 = rf(M, 8210280) - f1
    f1 = fd(f1)
    if f1 > 0 or (f1 == 0 and 1 / f1 > 0) or f1 ~= f1 then f1 = 0 end
    wfd(8210308, f1)
    f1 = rf(M, 8210292)
    f1 = f1 * rf(M, 8204164)
    f1 = f1 * rf(M, 8210292)
    f1 = f1 + rf(M, 8210312)
    wfd(8210312, f1)
    f1 = rf(M, 8210280) - f1
    f1 = fd(f1)
    if f1 > 0 or (f1 == 0 and 1 / f1 > 0) or f1 ~= f1 then f1 = 0 end
    f1 = f1 - rf(M, 8210308)
    wfd(8210280, f1)
    f1 = rf(M, 8210312)
    f1 = -f1
    f1 = f1 - rf(M, 8210280)
    wfd(8210312, f1)
    f1 = f1 * rf(M, 8204276)
    f2 = rf(M, 8210316)
    f2 = f2 * rf(M, 8218852)
    wfd(8210292, f2)
    f2 = rf(M, 8210284)
    f2 = f2 * rf(M, 8210292)
    f1 = f1 + f2
    wfd(8210432, f1)
    f1 = f1 + rf(M, 8213440)
    wfd(8211740, f1)
    f1 = f1 - rf(M, 8204304)
    wfd(8211764, f1)
    f1 = rf(M, 8210284)
    f1 = f1 * rf(M, 8211764)
    f2 = rf(M, 8210312)
    f2 = f2 * rf(M, 8204280)
    f3 = rf(M, 8210288)
    f3 = f3 * rf(M, 8210292)
    f2 = f2 + f3
    wfd(8210324, f2)
    f2 = f2 + rf(M, 8213444)
    wfd(8211744, f2)
    f2 = f2 - rf(M, 8204308)
    wfd(8211768, f2)
    f2 = rf(M, 8210288)
    f2 = f2 * rf(M, 8211768)
    f1 = f1 + f2
    f2 = rf(M, 8210312)
    f2 = f2 * rf(M, 8204284)
    f3 = rf(M, 8210492)
    f3 = f3 * rf(M, 8210292)
    f2 = f2 + f3
    wfd(8210292, f2)
    f2 = f2 + rf(M, 8213448)
    wfd(8211748, f2)
    f2 = f2 - rf(M, 8204312)
    wfd(8211772, f2)
    f2 = rf(M, 8210492)
    f2 = f2 * rf(M, 8211772)
    f1 = f1 + f2
    p2 = fd(f1)
    f1 = rf(M, 8210320)
    f1 = f1 * rf(M, 8211764)
    f2 = rf(M, 8210484)
    f2 = f2 * rf(M, 8211768)
    f1 = f1 + f2
    f2 = rf(M, 8210456)
    f2 = f2 * rf(M, 8211772)
    f1 = f1 + f2
    f2 = rf(M, 8218860)
    f2 = f2 * rf(M, 8213388)
    wfd(8210312, f2)
    f2 = f2 * rf(M, 8218136)
    f1 = f1 - f2
    p3 = fd(f1)
    p4 = ru(M, 8210316)
    p5 = ru(M, 8210308)
    p6 = ru(M, 8210280)
    p7 = ru(M, 8210312)
    f1 = rf(M, 8210432)
    f1 = f1 * rf(M, 8213400)
    f2 = rf(M, 8210324)
    f2 = f2 * rf(M, 8213412)
    f1 = f1 + f2
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8213424)
    f1 = f1 + f2
    wfd(8210312, f1)
    f1 = f1 * rf(M, 8213380)
    f2 = rf(M, 8210432)
    f2 = f2 * rf(M, 8213396)
    f3 = rf(M, 8210324)
    f3 = f3 * rf(M, 8213408)
    f2 = f2 + f3
    f3 = rf(M, 8210292)
    f3 = f3 * rf(M, 8213420)
    f2 = f2 + f3
    wfd(8210280, f2)
    f2 = f2 * rf(M, 8213384)
    f1 = f1 - f2
    f1 = f1 + rf(M, 8213516)
    wfd(8210308, f1)
    f1 = f1 * rf(M, 8213392)
    f2 = rf(M, 8210432)
    f2 = f2 * rf(M, 8213392)
    f3 = rf(M, 8210324)
    f3 = f3 * rf(M, 8213404)
    f2 = f2 + f3
    f3 = rf(M, 8210292)
    f3 = f3 * rf(M, 8213416)
    f2 = f2 + f3
    wfd(8210292, f2)
    f2 = f2 * rf(M, 8213384)
    f3 = rf(M, 8210312)
    f3 = f3 * rf(M, 8213376)
    f2 = f2 - f3
    f2 = f2 + rf(M, 8213520)
    wfd(8210324, f2)
    f2 = f2 * rf(M, 8213396)
    f1 = f1 + f2
    f2 = rf(M, 8210280)
    f2 = f2 * rf(M, 8213376)
    f3 = rf(M, 8210292)
    f3 = f3 * rf(M, 8213380)
    f2 = f2 - f3
    f2 = f2 + rf(M, 8213524)
    wfd(8210432, f2)
    f2 = f2 * rf(M, 8213400)
    f1 = f1 + f2
    f1 = f1 - rf(M, 8204292)
    wfd(8211752, f1)
    f1 = f1 * rf(M, 8204276)
    f2 = rf(M, 8210308)
    f2 = f2 * rf(M, 8213404)
    f3 = rf(M, 8210324)
    f3 = f3 * rf(M, 8213408)
    f2 = f2 + f3
    f3 = rf(M, 8210432)
    f3 = f3 * rf(M, 8213412)
    f2 = f2 + f3
    f2 = f2 - rf(M, 8204296)
    wfd(8211756, f2)
    f2 = f2 * rf(M, 8204280)
    f1 = f1 + f2
    f2 = rf(M, 8210308)
    f2 = f2 * rf(M, 8213416)
    f3 = rf(M, 8210324)
    f3 = f3 * rf(M, 8213420)
    f2 = f2 + f3
    f3 = rf(M, 8210432)
    f3 = f3 * rf(M, 8213424)
    f2 = f2 + f3
    f2 = f2 - rf(M, 8204300)
    wfd(8211760, f2)
    f2 = f2 * rf(M, 8204284)
    f1 = f1 + f2
    p8 = fd(f1)
    f1 = rf(M, 8210284)
    f1 = f1 * rf(M, 8211752)
    f2 = rf(M, 8210288)
    f2 = f2 * rf(M, 8211756)
    f1 = f1 + f2
    f2 = rf(M, 8210492)
    f2 = f2 * rf(M, 8211760)
    f1 = f1 + f2
    p9 = fd(f1)
    f1 = rf(M, 8210320)
    f1 = f1 * rf(M, 8211752)
    f2 = rf(M, 8210484)
    f2 = f2 * rf(M, 8211756)
    f1 = f1 + f2
    f2 = rf(M, 8210456)
    f2 = f2 * rf(M, 8211760)
    f1 = f1 + f2
    p10 = fd(f1)
    do local sp = NB(14); wu(M, sp + -7245816, 15453412); wu(M, sp + -7245812, 15453416); wu(M, sp + -7245808, 15453420); wu(M, sp + -7245804, 15453424); wf(M, sp + -7245800, p10); wf(M, sp + -7245796, p9); wf(M, sp + -7245792, p8); wu(M, sp + -7245788, p7); wu(M, sp + -7245784, p6); wu(M, sp + -7245780, p5); wu(M, sp + -7245776, p4); wf(M, sp + -7245772, p3); wf(M, sp + -7245768, p2); wf(M, sp + -7245764, p1); NC(0x55d8d0, 14) end
  end
  local function C2()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8210320)
    f1 = f1 * rf(M, 8207592)
    f2 = rf(M, 8210284)
    f2 = f2 * rf(M, 8207596)
    f1 = f1 + f2
    f2 = rf(M, 8204276)
    f2 = f2 * rf(M, 8207600)
    f1 = f1 + f2
    wfd(8210284, f1)
    f1 = f1 * rf(M, 8213400)
    f2 = rf(M, 8210484)
    f2 = f2 * rf(M, 8207592)
    f3 = rf(M, 8210288)
    f3 = f3 * rf(M, 8207596)
    f2 = f2 + f3
    f3 = rf(M, 8204280)
    f3 = f3 * rf(M, 8207600)
    f2 = f2 + f3
    wfd(8210288, f2)
    f2 = f2 * rf(M, 8213412)
    f1 = f1 + f2
    f2 = rf(M, 8210456)
    f2 = f2 * rf(M, 8207592)
    f3 = rf(M, 8210492)
    f3 = f3 * rf(M, 8207596)
    f2 = f2 + f3
    f3 = rf(M, 8204284)
    f3 = f3 * rf(M, 8207600)
    f2 = f2 + f3
    wfd(8210492, f2)
    f2 = f2 * rf(M, 8213424)
    f1 = f1 + f2
    f2 = rf(M, 8210320)
    f2 = f2 * rf(M, 8207588)
    wfd(8210320, f2)
    f2 = f2 * rf(M, 8213400)
    f3 = rf(M, 8210484)
    f3 = f3 * rf(M, 8207588)
    wfd(8210484, f3)
    f3 = f3 * rf(M, 8213412)
    f2 = f2 + f3
    f3 = rf(M, 8210456)
    f3 = f3 * rf(M, 8207588)
    wfd(8210432, f3)
    f3 = f3 * rf(M, 8213424)
    f2 = f2 + f3
    f1 = f1 + f2
    p1 = fd(f1)
    f1 = rf(M, 8210284)
    f1 = f1 * rf(M, 8213396)
    f2 = rf(M, 8210288)
    f2 = f2 * rf(M, 8213408)
    f1 = f1 + f2
    f2 = rf(M, 8210492)
    f2 = f2 * rf(M, 8213420)
    f1 = f1 + f2
    f2 = rf(M, 8210320)
    f2 = f2 * rf(M, 8213396)
    f3 = rf(M, 8210484)
    f3 = f3 * rf(M, 8213408)
    f2 = f2 + f3
    f3 = rf(M, 8210432)
    f3 = f3 * rf(M, 8213420)
    f2 = f2 + f3
    f1 = f1 + f2
    p2 = fd(f1)
    f1 = rf(M, 8210284)
    f1 = f1 * rf(M, 8213392)
    f2 = rf(M, 8210288)
    f2 = f2 * rf(M, 8213404)
    f1 = f1 + f2
    f2 = rf(M, 8210492)
    f2 = f2 * rf(M, 8213416)
    f1 = f1 + f2
    p3 = fd(f1)
    do local sp = NB(6); wu(M, sp + -7245816, 15453440); wu(M, sp + -7245812, 15453444); wu(M, sp + -7245808, 15453448); wf(M, sp + -7245804, p3); wf(M, sp + -7245800, p2); wf(M, sp + -7245796, p1); NC(0x55e160, 6) end
    f1 = rf(M, 8210320)
    f1 = f1 * rf(M, 8213392)
    f2 = rf(M, 8210484)
    f2 = f2 * rf(M, 8213404)
    f1 = f1 + f2
    f2 = rf(M, 8210432)
    f2 = f2 * rf(M, 8213416)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8207616)
    wfd(8210432, f1)
    f1 = f1 + rf(M, 8214844)
    wfd(8214844, f1)
    f1 = rf(M, 8207620)
    f1 = f1 + rf(M, 8214848)
    wfd(8214848, f1)
    f1 = rf(M, 8207624)
    f1 = f1 + rf(M, 8214852)
    wfd(8214852, f1)
    f1 = rf(M, 8210280)
    f1 = f1 * rf(M, 8207624)
    f2 = rf(M, 8210312)
    f2 = f2 * rf(M, 8207620)
    f1 = f1 - f2
    f1 = f1 + rf(M, 8214856)
    wfd(8214856, f1)
    f1 = rf(M, 8210312)
    f1 = f1 * rf(M, 8207616)
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8207624)
    f1 = f1 - f2
    f1 = f1 + rf(M, 8214860)
    wfd(8214860, f1)
    f1 = rf(M, 8210292)
    f1 = f1 * rf(M, 8207620)
    f2 = rf(M, 8210280)
    f2 = f2 * rf(M, 8207616)
    f1 = f1 - f2
    wfd(8210292, f1)
    f1 = f1 + rf(M, 8214864)
    wfd(8214864, f1)
    p1 = ru(M, 8210292)
    p2 = ru(M, 8207600)
    p3 = ru(M, 8207596)
    do local sp = NB(3); wu(M, sp + -7245816, p3); wu(M, sp + -7245812, p2); wu(M, sp + -7245808, p1); NC(0x55e180, 3) end
    f1 = rf(M, 8210432)
    f1 = f1 * rf(M, 8213392)
    f2 = rf(M, 8207620)
    f2 = f2 * rf(M, 8213396)
    f1 = f1 + f2
    f2 = rf(M, 8207624)
    f2 = f2 * rf(M, 8213400)
    f1 = f1 + f2
    wfd(8211728, f1)
    f1 = rf(M, 8210432)
    f1 = f1 * rf(M, 8213404)
    f2 = rf(M, 8207620)
    f2 = f2 * rf(M, 8213408)
    f1 = f1 + f2
    f2 = rf(M, 8207624)
    f2 = f2 * rf(M, 8213412)
    f1 = f1 + f2
    wfd(8211732, f1)
    f1 = rf(M, 8210432)
    f1 = f1 * rf(M, 8213416)
    f2 = rf(M, 8207620)
    f2 = f2 * rf(M, 8213420)
    f1 = f1 + f2
    f2 = rf(M, 8207624)
    f2 = f2 * rf(M, 8213424)
    f1 = f1 + f2
    wfd(8211736, f1)
  end
  JIT[0xeb4982] = function() -- tire1
    C1()
    C2()
  end
end
do -- tire2 (2 chunks)
  local r_eax, r_ebx, r_ecx, r_edx, r_esi, r_edi
  local function C1()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8213548)
    f1 = f1 * rf(M, 8204140)
    f2 = rf(M, 8213612)
    f2 = f2 * rf(M, 8204144)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8204148)
    wfd(8210432, f1)
    f1 = sin(f1)
    wfd(8210292, f1)
    f1 = f1 * rf(M, 8213804)
    f2 = rf(M, 8210432)
    f2 = cos(f2)
    f3 = rf(M, 8204168)
    f3 = cos(f3)
    f2 = f2 * f3
    wfd(8210432, f2)
    f2 = f2 * rf(M, 8213808)
    f1 = f1 + f2
    f2 = rf(M, 8204168)
    f2 = sin(f2)
    wfd(8210280, f2)
    f2 = f2 * rf(M, 8213812)
    f1 = f1 + f2
    wfd(8210312, f1)
    f1 = f1 * rf(M, 8204284)
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8213816)
    f3 = rf(M, 8210432)
    f3 = f3 * rf(M, 8213820)
    f2 = f2 + f3
    f3 = rf(M, 8210280)
    f3 = f3 * rf(M, 8213824)
    f2 = f2 + f3
    wfd(8210484, f2)
    f2 = f2 * rf(M, 8204280)
    f1 = f1 - f2
    wfd(8210320, f1)
    f1 = f1 * f1
    f2 = rf(M, 8210484)
    f2 = f2 * rf(M, 8204276)
    f3 = rf(M, 8210292)
    f3 = f3 * rf(M, 8213792)
    f4 = rf(M, 8210432)
    f4 = f4 * rf(M, 8213796)
    f3 = f3 + f4
    f4 = rf(M, 8210280)
    f4 = f4 * rf(M, 8213800)
    f3 = f3 + f4
    wfd(8210280, f3)
    f3 = f3 * rf(M, 8204284)
    f2 = f2 - f3
    wfd(8210432, f2)
    f2 = f2 * f2
    f1 = f1 + f2
    f2 = rf(M, 8210280)
    f2 = f2 * rf(M, 8204280)
    f3 = rf(M, 8210312)
    f3 = f3 * rf(M, 8204276)
    f2 = f2 - f3
    wfd(8210292, f2)
    f2 = f2 * f2
    f1 = f1 + f2
    f1 = sqrt(f1)
    q = fd(f1)
    if q < TINY and q > -TINY then f1 = 1 else f1 = 1 / q end
    wfd(8210492, f1)
    f1 = rf(M, 8210320)
    f1 = f1 * rf(M, 8210492)
    wfd(8210320, f1)
    f1 = rf(M, 8210432)
    f1 = f1 * rf(M, 8210492)
    wfd(8210432, f1)
    f1 = rf(M, 8210292)
    f1 = f1 * rf(M, 8210492)
    wfd(8210492, f1)
    p1 = ru(M, 8204740)
    f1 = rf(M, 8204276)
    f1 = f1 * rf(M, 8213840)
    f2 = rf(M, 8204280)
    f2 = f2 * rf(M, 8213844)
    f1 = f1 + f2
    f2 = rf(M, 8204284)
    f2 = f2 * rf(M, 8213848)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8204288)
    wfd(8210292, f1)
    f1 = rf(M, 8210492)
    f1 = f1 * rf(M, 8204280)
    f2 = rf(M, 8210432)
    f2 = f2 * rf(M, 8204284)
    f1 = f1 - f2
    wfd(8210288, f1)
    f1 = f1 * f1
    f2 = rf(M, 8210320)
    f2 = f2 * rf(M, 8204284)
    f3 = rf(M, 8210492)
    f3 = f3 * rf(M, 8204276)
    f2 = f2 - f3
    wfd(8210284, f2)
    f2 = f2 * f2
    f1 = f1 + f2
    f2 = rf(M, 8210432)
    f2 = f2 * rf(M, 8204276)
    f3 = rf(M, 8210320)
    f3 = f3 * rf(M, 8204280)
    f2 = f2 - f3
    wfd(8210456, f2)
    f2 = f2 * f2
    f1 = f1 + f2
    f1 = sqrt(f1)
    q = fd(f1)
    if q < TINY and q > -TINY then f1 = 1 else f1 = 1 / q end
    wfd(8210324, f1)
    f1 = rf(M, 8210288)
    f1 = f1 * rf(M, 8210324)
    wfd(8210288, f1)
    f1 = f1 * rf(M, 8210280)
    f2 = rf(M, 8210284)
    f2 = f2 * rf(M, 8210324)
    wfd(8210284, f2)
    f2 = f2 * rf(M, 8210312)
    f1 = f1 + f2
    f2 = rf(M, 8210456)
    f2 = f2 * rf(M, 8210324)
    wfd(8210324, f2)
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    wfd(8210456, f1)
    f1 = f1 * rf(M, 8218852)
    f2 = rf(M, 8210280)
    f2 = f2 * rf(M, 8204276)
    f3 = rf(M, 8210312)
    f3 = f3 * rf(M, 8204280)
    f2 = f2 + f3
    f3 = rf(M, 8210484)
    f3 = f3 * rf(M, 8204284)
    f2 = f2 + f3
    wfd(8210484, f2)
    f2 = f2 * rf(M, 8218844)
    f2 = abs(f2)
    f1 = f1 + f2
    wfd(8210312, f1)
    f1 = rf(M, 8210292) - f1
    f1 = fd(f1)
    if f1 > 0 or (f1 == 0 and 1 / f1 > 0) or f1 ~= f1 then f1 = 0 end
    wfd(8210280, f1)
    f1 = rf(M, 8210456)
    f1 = f1 * rf(M, 8204172)
    f1 = f1 * rf(M, 8210456)
    f1 = f1 + rf(M, 8210312)
    wfd(8210312, f1)
    f1 = rf(M, 8210292) - f1
    f1 = fd(f1)
    if f1 > 0 or (f1 == 0 and 1 / f1 > 0) or f1 ~= f1 then f1 = 0 end
    f1 = f1 - rf(M, 8210280)
    wfd(8210292, f1)
    f1 = rf(M, 8210312)
    f1 = -f1
    f1 = f1 - rf(M, 8210292)
    wfd(8210312, f1)
    f1 = f1 * rf(M, 8204276)
    f2 = rf(M, 8210484)
    f2 = f2 * rf(M, 8218852)
    wfd(8210456, f2)
    f2 = rf(M, 8210288)
    f2 = f2 * rf(M, 8210456)
    f1 = f1 + f2
    wfd(8210308, f1)
    f1 = f1 + rf(M, 8213840)
    wfd(8211740, f1)
    f1 = f1 - rf(M, 8204304)
    wfd(8211764, f1)
    f1 = rf(M, 8210288)
    f1 = f1 * rf(M, 8211764)
    f2 = rf(M, 8210312)
    f2 = f2 * rf(M, 8204280)
    f3 = rf(M, 8210284)
    f3 = f3 * rf(M, 8210456)
    f2 = f2 + f3
    wfd(8210316, f2)
    f2 = f2 + rf(M, 8213844)
    wfd(8211744, f2)
    f2 = f2 - rf(M, 8204308)
    wfd(8211768, f2)
    f2 = rf(M, 8210284)
    f2 = f2 * rf(M, 8211768)
    f1 = f1 + f2
    f2 = rf(M, 8210312)
    f2 = f2 * rf(M, 8204284)
    f3 = rf(M, 8210324)
    f3 = f3 * rf(M, 8210456)
    f2 = f2 + f3
    wfd(8210456, f2)
    f2 = f2 + rf(M, 8213848)
    wfd(8211748, f2)
    f2 = f2 - rf(M, 8204312)
    wfd(8211772, f2)
    f2 = rf(M, 8210324)
    f2 = f2 * rf(M, 8211772)
    f1 = f1 + f2
    p2 = fd(f1)
    f1 = rf(M, 8210320)
    f1 = f1 * rf(M, 8211764)
    f2 = rf(M, 8210432)
    f2 = f2 * rf(M, 8211768)
    f1 = f1 + f2
    f2 = rf(M, 8210492)
    f2 = f2 * rf(M, 8211772)
    f1 = f1 + f2
    f2 = rf(M, 8218856)
    f2 = f2 * rf(M, 8213788)
    wfd(8210312, f2)
    f2 = f2 * rf(M, 8218136)
    f1 = f1 - f2
    p3 = fd(f1)
    p4 = ru(M, 8210484)
    p5 = ru(M, 8210280)
    p6 = ru(M, 8210292)
    p7 = ru(M, 8210312)
    f1 = rf(M, 8210308)
    f1 = f1 * rf(M, 8213800)
    f2 = rf(M, 8210316)
    f2 = f2 * rf(M, 8213812)
    f1 = f1 + f2
    f2 = rf(M, 8210456)
    f2 = f2 * rf(M, 8213824)
    f1 = f1 + f2
    wfd(8210312, f1)
    f1 = f1 * rf(M, 8213780)
    f2 = rf(M, 8210308)
    f2 = f2 * rf(M, 8213796)
    f3 = rf(M, 8210316)
    f3 = f3 * rf(M, 8213808)
    f2 = f2 + f3
    f3 = rf(M, 8210456)
    f3 = f3 * rf(M, 8213820)
    f2 = f2 + f3
    wfd(8210292, f2)
    f2 = f2 * rf(M, 8213784)
    f1 = f1 - f2
    f1 = f1 + rf(M, 8213932)
    wfd(8210280, f1)
    f1 = f1 * rf(M, 8213792)
    f2 = rf(M, 8210308)
    f2 = f2 * rf(M, 8213792)
    f3 = rf(M, 8210316)
    f3 = f3 * rf(M, 8213804)
    f2 = f2 + f3
    f3 = rf(M, 8210456)
    f3 = f3 * rf(M, 8213816)
    f2 = f2 + f3
    wfd(8210456, f2)
    f2 = f2 * rf(M, 8213784)
    f3 = rf(M, 8210312)
    f3 = f3 * rf(M, 8213776)
    f2 = f2 - f3
    f2 = f2 + rf(M, 8213936)
    wfd(8210316, f2)
    f2 = f2 * rf(M, 8213796)
    f1 = f1 + f2
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8213776)
    f3 = rf(M, 8210456)
    f3 = f3 * rf(M, 8213780)
    f2 = f2 - f3
    f2 = f2 + rf(M, 8213940)
    wfd(8210308, f2)
    f2 = f2 * rf(M, 8213800)
    f1 = f1 + f2
    f1 = f1 - rf(M, 8204292)
    wfd(8211752, f1)
    f1 = f1 * rf(M, 8204276)
    f2 = rf(M, 8210280)
    f2 = f2 * rf(M, 8213804)
    f3 = rf(M, 8210316)
    f3 = f3 * rf(M, 8213808)
    f2 = f2 + f3
    f3 = rf(M, 8210308)
    f3 = f3 * rf(M, 8213812)
    f2 = f2 + f3
    f2 = f2 - rf(M, 8204296)
    wfd(8211756, f2)
    f2 = f2 * rf(M, 8204280)
    f1 = f1 + f2
    f2 = rf(M, 8210280)
    f2 = f2 * rf(M, 8213816)
    f3 = rf(M, 8210316)
    f3 = f3 * rf(M, 8213820)
    f2 = f2 + f3
    f3 = rf(M, 8210308)
    f3 = f3 * rf(M, 8213824)
    f2 = f2 + f3
    f2 = f2 - rf(M, 8204300)
    wfd(8211760, f2)
    f2 = f2 * rf(M, 8204284)
    f1 = f1 + f2
    p8 = fd(f1)
    f1 = rf(M, 8210288)
    f1 = f1 * rf(M, 8211752)
    f2 = rf(M, 8210284)
    f2 = f2 * rf(M, 8211756)
    f1 = f1 + f2
    f2 = rf(M, 8210324)
    f2 = f2 * rf(M, 8211760)
    f1 = f1 + f2
    p9 = fd(f1)
    f1 = rf(M, 8210320)
    f1 = f1 * rf(M, 8211752)
    f2 = rf(M, 8210432)
    f2 = f2 * rf(M, 8211756)
    f1 = f1 + f2
    f2 = rf(M, 8210492)
    f2 = f2 * rf(M, 8211760)
    f1 = f1 + f2
    p10 = fd(f1)
    do local sp = NB(14); wu(M, sp + -7245816, 15453532); wu(M, sp + -7245812, 15453536); wu(M, sp + -7245808, 15453540); wu(M, sp + -7245804, 15453544); wf(M, sp + -7245800, p10); wf(M, sp + -7245796, p9); wf(M, sp + -7245792, p8); wu(M, sp + -7245788, p7); wu(M, sp + -7245784, p6); wu(M, sp + -7245780, p5); wu(M, sp + -7245776, p4); wf(M, sp + -7245772, p3); wf(M, sp + -7245768, p2); wu(M, sp + -7245764, p1); NC(0x55d920, 14) end
  end
  local function C2()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8210320)
    f1 = f1 * rf(M, 8207712)
    f2 = rf(M, 8210288)
    f2 = f2 * rf(M, 8207716)
    f1 = f1 + f2
    f2 = rf(M, 8204276)
    f2 = f2 * rf(M, 8207720)
    f1 = f1 + f2
    wfd(8210288, f1)
    f1 = f1 * rf(M, 8213800)
    f2 = rf(M, 8210432)
    f2 = f2 * rf(M, 8207712)
    f3 = rf(M, 8210284)
    f3 = f3 * rf(M, 8207716)
    f2 = f2 + f3
    f3 = rf(M, 8204280)
    f3 = f3 * rf(M, 8207720)
    f2 = f2 + f3
    wfd(8210284, f2)
    f2 = f2 * rf(M, 8213812)
    f1 = f1 + f2
    f2 = rf(M, 8210492)
    f2 = f2 * rf(M, 8207712)
    f3 = rf(M, 8210324)
    f3 = f3 * rf(M, 8207716)
    f2 = f2 + f3
    f3 = rf(M, 8204284)
    f3 = f3 * rf(M, 8207720)
    f2 = f2 + f3
    wfd(8210308, f2)
    f2 = f2 * rf(M, 8213824)
    f1 = f1 + f2
    f2 = rf(M, 8210320)
    f2 = f2 * rf(M, 8207708)
    wfd(8210320, f2)
    f2 = f2 * rf(M, 8213800)
    f3 = rf(M, 8210432)
    f3 = f3 * rf(M, 8207708)
    wfd(8210432, f3)
    f3 = f3 * rf(M, 8213812)
    f2 = f2 + f3
    f3 = rf(M, 8210492)
    f3 = f3 * rf(M, 8207708)
    wfd(8210324, f3)
    f3 = f3 * rf(M, 8213824)
    f2 = f2 + f3
    f1 = f1 + f2
    p1 = fd(f1)
    f1 = rf(M, 8210288)
    f1 = f1 * rf(M, 8213796)
    f2 = rf(M, 8210284)
    f2 = f2 * rf(M, 8213808)
    f1 = f1 + f2
    f2 = rf(M, 8210308)
    f2 = f2 * rf(M, 8213820)
    f1 = f1 + f2
    f2 = rf(M, 8210320)
    f2 = f2 * rf(M, 8213796)
    f3 = rf(M, 8210432)
    f3 = f3 * rf(M, 8213808)
    f2 = f2 + f3
    f3 = rf(M, 8210324)
    f3 = f3 * rf(M, 8213820)
    f2 = f2 + f3
    f1 = f1 + f2
    p2 = fd(f1)
    f1 = rf(M, 8210288)
    f1 = f1 * rf(M, 8213792)
    f2 = rf(M, 8210284)
    f2 = f2 * rf(M, 8213804)
    f1 = f1 + f2
    f2 = rf(M, 8210308)
    f2 = f2 * rf(M, 8213816)
    f1 = f1 + f2
    p3 = fd(f1)
    do local sp = NB(6); wu(M, sp + -7245816, 15453560); wu(M, sp + -7245812, 15453564); wu(M, sp + -7245808, 15453568); wf(M, sp + -7245804, p3); wf(M, sp + -7245800, p2); wf(M, sp + -7245796, p1); NC(0x55e160, 6) end
    f1 = rf(M, 8210320)
    f1 = f1 * rf(M, 8213792)
    f2 = rf(M, 8210432)
    f2 = f2 * rf(M, 8213804)
    f1 = f1 + f2
    f2 = rf(M, 8210324)
    f2 = f2 * rf(M, 8213816)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8207736)
    wfd(8210324, f1)
    f1 = f1 + rf(M, 8214868)
    wfd(8214868, f1)
    f1 = rf(M, 8207740)
    f1 = f1 + rf(M, 8214872)
    wfd(8214872, f1)
    f1 = rf(M, 8207744)
    f1 = f1 + rf(M, 8214876)
    wfd(8214876, f1)
    f1 = rf(M, 8210292)
    f1 = f1 * rf(M, 8207744)
    f2 = rf(M, 8210312)
    f2 = f2 * rf(M, 8207740)
    f1 = f1 - f2
    f1 = f1 + rf(M, 8214880)
    wfd(8214880, f1)
    f1 = rf(M, 8210312)
    f1 = f1 * rf(M, 8207736)
    f2 = rf(M, 8210456)
    f2 = f2 * rf(M, 8207744)
    f1 = f1 - f2
    f1 = f1 + rf(M, 8214884)
    wfd(8214884, f1)
    f1 = rf(M, 8210456)
    f1 = f1 * rf(M, 8207740)
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8207736)
    f1 = f1 - f2
    f1 = f1 + rf(M, 8214888)
    wfd(8214888, f1)
    f1 = rf(M, 8210324)
    f1 = f1 * rf(M, 8213792)
    f2 = rf(M, 8207740)
    f2 = f2 * rf(M, 8213796)
    f1 = f1 + f2
    f2 = rf(M, 8207744)
    f2 = f2 * rf(M, 8213800)
    f1 = f1 + f2
    wfd(8211728, f1)
    f1 = rf(M, 8210324)
    f1 = f1 * rf(M, 8213804)
    f2 = rf(M, 8207740)
    f2 = f2 * rf(M, 8213808)
    f1 = f1 + f2
    f2 = rf(M, 8207744)
    f2 = f2 * rf(M, 8213812)
    f1 = f1 + f2
    wfd(8211732, f1)
    f1 = rf(M, 8210324)
    f1 = f1 * rf(M, 8213816)
    f2 = rf(M, 8207740)
    f2 = f2 * rf(M, 8213820)
    f1 = f1 + f2
    f2 = rf(M, 8207744)
    f2 = f2 * rf(M, 8213824)
    f1 = f1 + f2
    wfd(8211736, f1)
  end
  JIT[0xeb4f6a] = function() -- tire2
    C1()
    C2()
  end
end
do -- tire3 (2 chunks)
  local r_eax, r_ebx, r_ecx, r_edx, r_esi, r_edi
  local function C1()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8213548)
    f1 = f1 * rf(M, 8204140)
    f2 = rf(M, 8213612)
    f2 = f2 * rf(M, 8204144)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8204148)
    wfd(8210324, f1)
    f1 = sin(f1)
    wfd(8210456, f1)
    f1 = f1 * rf(M, 8213972)
    f2 = rf(M, 8210324)
    f2 = cos(f2)
    f3 = rf(M, 8204176)
    f3 = cos(f3)
    f2 = f2 * f3
    wfd(8210324, f2)
    f2 = f2 * rf(M, 8213976)
    f1 = f1 + f2
    f2 = rf(M, 8204176)
    f2 = sin(f2)
    wfd(8210292, f2)
    f2 = f2 * rf(M, 8213980)
    f1 = f1 + f2
    wfd(8210312, f1)
    f1 = f1 * rf(M, 8204284)
    f2 = rf(M, 8210456)
    f2 = f2 * rf(M, 8213984)
    f3 = rf(M, 8210324)
    f3 = f3 * rf(M, 8213988)
    f2 = f2 + f3
    f3 = rf(M, 8210292)
    f3 = f3 * rf(M, 8213992)
    f2 = f2 + f3
    wfd(8210432, f2)
    f2 = f2 * rf(M, 8204280)
    f1 = f1 - f2
    wfd(8210320, f1)
    f1 = f1 * f1
    f2 = rf(M, 8210432)
    f2 = f2 * rf(M, 8204276)
    f3 = rf(M, 8210456)
    f3 = f3 * rf(M, 8213960)
    f4 = rf(M, 8210324)
    f4 = f4 * rf(M, 8213964)
    f3 = f3 + f4
    f4 = rf(M, 8210292)
    f4 = f4 * rf(M, 8213968)
    f3 = f3 + f4
    wfd(8210292, f3)
    f3 = f3 * rf(M, 8204284)
    f2 = f2 - f3
    wfd(8210324, f2)
    f2 = f2 * f2
    f1 = f1 + f2
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8204280)
    f3 = rf(M, 8210312)
    f3 = f3 * rf(M, 8204276)
    f2 = f2 - f3
    wfd(8210456, f2)
    f2 = f2 * f2
    f1 = f1 + f2
    f1 = sqrt(f1)
    q = fd(f1)
    if q < TINY and q > -TINY then f1 = 1 else f1 = 1 / q end
    wfd(8210308, f1)
    f1 = rf(M, 8210320)
    f1 = f1 * rf(M, 8210308)
    wfd(8210320, f1)
    f1 = rf(M, 8210324)
    f1 = f1 * rf(M, 8210308)
    wfd(8210324, f1)
    f1 = rf(M, 8210456)
    f1 = f1 * rf(M, 8210308)
    wfd(8210308, f1)
    p1 = ru(M, 8204740)
    f1 = rf(M, 8204276)
    f1 = f1 * rf(M, 8214008)
    f2 = rf(M, 8204280)
    f2 = f2 * rf(M, 8214012)
    f1 = f1 + f2
    f2 = rf(M, 8204284)
    f2 = f2 * rf(M, 8214016)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8204288)
    wfd(8210456, f1)
    f1 = rf(M, 8210308)
    f1 = f1 * rf(M, 8204280)
    f2 = rf(M, 8210324)
    f2 = f2 * rf(M, 8204284)
    f1 = f1 - f2
    wfd(8210284, f1)
    f1 = f1 * f1
    f2 = rf(M, 8210320)
    f2 = f2 * rf(M, 8204284)
    f3 = rf(M, 8210308)
    f3 = f3 * rf(M, 8204276)
    f2 = f2 - f3
    wfd(8210288, f2)
    f2 = f2 * f2
    f1 = f1 + f2
    f2 = rf(M, 8210324)
    f2 = f2 * rf(M, 8204276)
    f3 = rf(M, 8210320)
    f3 = f3 * rf(M, 8204280)
    f2 = f2 - f3
    wfd(8210492, f2)
    f2 = f2 * f2
    f1 = f1 + f2
    f1 = sqrt(f1)
    q = fd(f1)
    if q < TINY and q > -TINY then f1 = 1 else f1 = 1 / q end
    wfd(8210316, f1)
    f1 = rf(M, 8210284)
    f1 = f1 * rf(M, 8210316)
    wfd(8210284, f1)
    f1 = f1 * rf(M, 8210292)
    f2 = rf(M, 8210288)
    f2 = f2 * rf(M, 8210316)
    wfd(8210288, f2)
    f2 = f2 * rf(M, 8210312)
    f1 = f1 + f2
    f2 = rf(M, 8210492)
    f2 = f2 * rf(M, 8210316)
    wfd(8210316, f2)
    f2 = f2 * rf(M, 8210432)
    f1 = f1 + f2
    wfd(8210492, f1)
    f1 = f1 * rf(M, 8218852)
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8204276)
    f3 = rf(M, 8210312)
    f3 = f3 * rf(M, 8204280)
    f2 = f2 + f3
    f3 = rf(M, 8210432)
    f3 = f3 * rf(M, 8204284)
    f2 = f2 + f3
    wfd(8210432, f2)
    f2 = f2 * rf(M, 8218844)
    f2 = abs(f2)
    f1 = f1 + f2
    wfd(8210312, f1)
    f1 = rf(M, 8210456) - f1
    f1 = fd(f1)
    if f1 > 0 or (f1 == 0 and 1 / f1 > 0) or f1 ~= f1 then f1 = 0 end
    wfd(8210292, f1)
    f1 = rf(M, 8210492)
    f1 = f1 * rf(M, 8204180)
    f1 = f1 * rf(M, 8210492)
    f1 = f1 + rf(M, 8210312)
    wfd(8210312, f1)
    f1 = rf(M, 8210456) - f1
    f1 = fd(f1)
    if f1 > 0 or (f1 == 0 and 1 / f1 > 0) or f1 ~= f1 then f1 = 0 end
    f1 = f1 - rf(M, 8210292)
    wfd(8210456, f1)
    f1 = rf(M, 8210312)
    f1 = -f1
    f1 = f1 - rf(M, 8210456)
    wfd(8210312, f1)
    f1 = f1 * rf(M, 8204276)
    f2 = rf(M, 8210432)
    f2 = f2 * rf(M, 8218852)
    wfd(8210492, f2)
    f2 = rf(M, 8210284)
    f2 = f2 * rf(M, 8210492)
    f1 = f1 + f2
    wfd(8210280, f1)
    f1 = f1 + rf(M, 8214008)
    wfd(8211740, f1)
    f1 = f1 - rf(M, 8204304)
    wfd(8211764, f1)
    f1 = rf(M, 8210284)
    f1 = f1 * rf(M, 8211764)
    f2 = rf(M, 8210312)
    f2 = f2 * rf(M, 8204280)
    f3 = rf(M, 8210288)
    f3 = f3 * rf(M, 8210492)
    f2 = f2 + f3
    wfd(8210484, f2)
    f2 = f2 + rf(M, 8214012)
    wfd(8211744, f2)
    f2 = f2 - rf(M, 8204308)
    wfd(8211768, f2)
    f2 = rf(M, 8210288)
    f2 = f2 * rf(M, 8211768)
    f1 = f1 + f2
    f2 = rf(M, 8210312)
    f2 = f2 * rf(M, 8204284)
    f3 = rf(M, 8210316)
    f3 = f3 * rf(M, 8210492)
    f2 = f2 + f3
    wfd(8210492, f2)
    f2 = f2 + rf(M, 8214016)
    wfd(8211748, f2)
    f2 = f2 - rf(M, 8204312)
    wfd(8211772, f2)
    f2 = rf(M, 8210316)
    f2 = f2 * rf(M, 8211772)
    f1 = f1 + f2
    p2 = fd(f1)
    f1 = rf(M, 8210320)
    f1 = f1 * rf(M, 8211764)
    f2 = rf(M, 8210324)
    f2 = f2 * rf(M, 8211768)
    f1 = f1 + f2
    f2 = rf(M, 8210308)
    f2 = f2 * rf(M, 8211772)
    f1 = f1 + f2
    f2 = rf(M, 8218856)
    f2 = f2 * rf(M, 8213956)
    wfd(8210312, f2)
    f2 = f2 * rf(M, 8218136)
    f1 = f1 - f2
    p3 = fd(f1)
    p4 = ru(M, 8210432)
    p5 = ru(M, 8210292)
    p6 = ru(M, 8210456)
    p7 = ru(M, 8210312)
    f1 = rf(M, 8210280)
    f1 = f1 * rf(M, 8213968)
    f2 = rf(M, 8210484)
    f2 = f2 * rf(M, 8213980)
    f1 = f1 + f2
    f2 = rf(M, 8210492)
    f2 = f2 * rf(M, 8213992)
    f1 = f1 + f2
    wfd(8210312, f1)
    f1 = f1 * rf(M, 8213780)
    f2 = rf(M, 8210280)
    f2 = f2 * rf(M, 8213964)
    f3 = rf(M, 8210484)
    f3 = f3 * rf(M, 8213976)
    f2 = f2 + f3
    f3 = rf(M, 8210492)
    f3 = f3 * rf(M, 8213988)
    f2 = f2 + f3
    wfd(8210456, f2)
    f2 = f2 * rf(M, 8213784)
    f1 = f1 - f2
    f1 = f1 + rf(M, 8214100)
    wfd(8210292, f1)
    f1 = f1 * rf(M, 8213960)
    f2 = rf(M, 8210280)
    f2 = f2 * rf(M, 8213960)
    f3 = rf(M, 8210484)
    f3 = f3 * rf(M, 8213972)
    f2 = f2 + f3
    f3 = rf(M, 8210492)
    f3 = f3 * rf(M, 8213984)
    f2 = f2 + f3
    wfd(8210492, f2)
    f2 = f2 * rf(M, 8213784)
    f3 = rf(M, 8210312)
    f3 = f3 * rf(M, 8213776)
    f2 = f2 - f3
    f2 = f2 + rf(M, 8214104)
    wfd(8210484, f2)
    f2 = f2 * rf(M, 8213964)
    f1 = f1 + f2
    f2 = rf(M, 8210456)
    f2 = f2 * rf(M, 8213776)
    f3 = rf(M, 8210492)
    f3 = f3 * rf(M, 8213780)
    f2 = f2 - f3
    f2 = f2 + rf(M, 8214108)
    wfd(8210280, f2)
    f2 = f2 * rf(M, 8213968)
    f1 = f1 + f2
    f1 = f1 - rf(M, 8204292)
    wfd(8211752, f1)
    f1 = f1 * rf(M, 8204276)
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8213972)
    f3 = rf(M, 8210484)
    f3 = f3 * rf(M, 8213976)
    f2 = f2 + f3
    f3 = rf(M, 8210280)
    f3 = f3 * rf(M, 8213980)
    f2 = f2 + f3
    f2 = f2 - rf(M, 8204296)
    wfd(8211756, f2)
    f2 = f2 * rf(M, 8204280)
    f1 = f1 + f2
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8213984)
    f3 = rf(M, 8210484)
    f3 = f3 * rf(M, 8213988)
    f2 = f2 + f3
    f3 = rf(M, 8210280)
    f3 = f3 * rf(M, 8213992)
    f2 = f2 + f3
    f2 = f2 - rf(M, 8204300)
    wfd(8211760, f2)
    f2 = f2 * rf(M, 8204284)
    f1 = f1 + f2
    p8 = fd(f1)
    f1 = rf(M, 8210284)
    f1 = f1 * rf(M, 8211752)
    f2 = rf(M, 8210288)
    f2 = f2 * rf(M, 8211756)
    f1 = f1 + f2
    f2 = rf(M, 8210316)
    f2 = f2 * rf(M, 8211760)
    f1 = f1 + f2
    p9 = fd(f1)
    f1 = rf(M, 8210320)
    f1 = f1 * rf(M, 8211752)
    f2 = rf(M, 8210324)
    f2 = f2 * rf(M, 8211756)
    f1 = f1 + f2
    f2 = rf(M, 8210308)
    f2 = f2 * rf(M, 8211760)
    f1 = f1 + f2
    p10 = fd(f1)
    do local sp = NB(14); wu(M, sp + -7245816, 15453652); wu(M, sp + -7245812, 15453656); wu(M, sp + -7245808, 15453660); wu(M, sp + -7245804, 15453664); wf(M, sp + -7245800, p10); wf(M, sp + -7245796, p9); wf(M, sp + -7245792, p8); wu(M, sp + -7245788, p7); wu(M, sp + -7245784, p6); wu(M, sp + -7245780, p5); wu(M, sp + -7245776, p4); wf(M, sp + -7245772, p3); wf(M, sp + -7245768, p2); wu(M, sp + -7245764, p1); NC(0x55d970, 14) end
  end
  local function C2()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8210320)
    f1 = f1 * rf(M, 8207832)
    f2 = rf(M, 8210284)
    f2 = f2 * rf(M, 8207836)
    f1 = f1 + f2
    f2 = rf(M, 8204276)
    f2 = f2 * rf(M, 8207840)
    f1 = f1 + f2
    wfd(8210284, f1)
    f1 = f1 * rf(M, 8213968)
    f2 = rf(M, 8210324)
    f2 = f2 * rf(M, 8207832)
    f3 = rf(M, 8210288)
    f3 = f3 * rf(M, 8207836)
    f2 = f2 + f3
    f3 = rf(M, 8204280)
    f3 = f3 * rf(M, 8207840)
    f2 = f2 + f3
    wfd(8210288, f2)
    f2 = f2 * rf(M, 8213980)
    f1 = f1 + f2
    f2 = rf(M, 8210308)
    f2 = f2 * rf(M, 8207832)
    f3 = rf(M, 8210316)
    f3 = f3 * rf(M, 8207836)
    f2 = f2 + f3
    f3 = rf(M, 8204284)
    f3 = f3 * rf(M, 8207840)
    f2 = f2 + f3
    wfd(8210280, f2)
    f2 = f2 * rf(M, 8213992)
    f1 = f1 + f2
    f2 = rf(M, 8210320)
    f2 = f2 * rf(M, 8207828)
    wfd(8210320, f2)
    f2 = f2 * rf(M, 8213968)
    f3 = rf(M, 8210324)
    f3 = f3 * rf(M, 8207828)
    wfd(8210324, f3)
    f3 = f3 * rf(M, 8213980)
    f2 = f2 + f3
    f3 = rf(M, 8210308)
    f3 = f3 * rf(M, 8207828)
    wfd(8210316, f3)
    f3 = f3 * rf(M, 8213992)
    f2 = f2 + f3
    f1 = f1 + f2
    p1 = fd(f1)
    f1 = rf(M, 8210284)
    f1 = f1 * rf(M, 8213964)
    f2 = rf(M, 8210288)
    f2 = f2 * rf(M, 8213976)
    f1 = f1 + f2
    f2 = rf(M, 8210280)
    f2 = f2 * rf(M, 8213988)
    f1 = f1 + f2
    f2 = rf(M, 8210320)
    f2 = f2 * rf(M, 8213964)
    f3 = rf(M, 8210324)
    f3 = f3 * rf(M, 8213976)
    f2 = f2 + f3
    f3 = rf(M, 8210316)
    f3 = f3 * rf(M, 8213988)
    f2 = f2 + f3
    f1 = f1 + f2
    p2 = fd(f1)
    f1 = rf(M, 8210284)
    f1 = f1 * rf(M, 8213960)
    f2 = rf(M, 8210288)
    f2 = f2 * rf(M, 8213972)
    f1 = f1 + f2
    f2 = rf(M, 8210280)
    f2 = f2 * rf(M, 8213984)
    f1 = f1 + f2
    p3 = fd(f1)
    do local sp = NB(6); wu(M, sp + -7245816, 15453680); wu(M, sp + -7245812, 15453684); wu(M, sp + -7245808, 15453688); wf(M, sp + -7245804, p3); wf(M, sp + -7245800, p2); wf(M, sp + -7245796, p1); NC(0x55e160, 6) end
    f1 = rf(M, 8210320)
    f1 = f1 * rf(M, 8213960)
    f2 = rf(M, 8210324)
    f2 = f2 * rf(M, 8213972)
    f1 = f1 + f2
    f2 = rf(M, 8210316)
    f2 = f2 * rf(M, 8213984)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8207856)
    wfd(8210316, f1)
    f1 = f1 + rf(M, 8214892)
    wfd(8214892, f1)
    f1 = rf(M, 8207860)
    f1 = f1 + rf(M, 8214896)
    wfd(8214896, f1)
    f1 = rf(M, 8207864)
    f1 = f1 + rf(M, 8214900)
    wfd(8214900, f1)
    f1 = rf(M, 8210456)
    f1 = f1 * rf(M, 8207864)
    f2 = rf(M, 8210312)
    f2 = f2 * rf(M, 8207860)
    f1 = f1 - f2
    f1 = f1 + rf(M, 8214904)
    wfd(8214904, f1)
    f1 = rf(M, 8210312)
    f1 = f1 * rf(M, 8207856)
    f2 = rf(M, 8210492)
    f2 = f2 * rf(M, 8207864)
    f1 = f1 - f2
    f1 = f1 + rf(M, 8214908)
    wfd(8214908, f1)
    f1 = rf(M, 8210492)
    f1 = f1 * rf(M, 8207860)
    f2 = rf(M, 8210456)
    f2 = f2 * rf(M, 8207856)
    f1 = f1 - f2
    f1 = f1 + rf(M, 8214912)
    wfd(8214912, f1)
    f1 = rf(M, 8210316)
    f1 = f1 * rf(M, 8213960)
    f2 = rf(M, 8207860)
    f2 = f2 * rf(M, 8213964)
    f1 = f1 + f2
    f2 = rf(M, 8207864)
    f2 = f2 * rf(M, 8213968)
    f1 = f1 + f2
    wfd(8211728, f1)
    f1 = rf(M, 8210316)
    f1 = f1 * rf(M, 8213972)
    f2 = rf(M, 8207860)
    f2 = f2 * rf(M, 8213976)
    f1 = f1 + f2
    f2 = rf(M, 8207864)
    f2 = f2 * rf(M, 8213980)
    f1 = f1 + f2
    wfd(8211732, f1)
    f1 = rf(M, 8210316)
    f1 = f1 * rf(M, 8213984)
    f2 = rf(M, 8207860)
    f2 = f2 * rf(M, 8213988)
    f1 = f1 + f2
    f2 = rf(M, 8207864)
    f2 = f2 * rf(M, 8213992)
    f1 = f1 + f2
    wfd(8211736, f1)
  end
  JIT[0xeb5531] = function() -- tire3
    C1()
    C2()
  end
end
do -- forces (3 chunks)
  local r_eax, r_ebx, r_ecx, r_edx, r_esi, r_edi
  local function C1()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    p1 = ru(M, 8211796)
    p2 = ru(M, 8211792)
    do local sp = NB(2); wu(M, sp + -7245816, p2); wu(M, sp + -7245812, p1); NC(0x55fc50, 2) end
    f1 = rf(M, 8214124)
    f1 = f1 * rf(M, 8204372)
    f2 = rf(M, 8214288)
    f2 = f2 * rf(M, 8204376)
    f1 = f1 + f2
    f2 = rf(M, 8214452)
    f2 = f2 * rf(M, 8204380)
    f1 = f1 + f2
    f2 = rf(M, 8213788)
    f2 = f2 * rf(M, 8204384)
    f1 = f1 + f2
    f2 = rf(M, 8213956)
    f2 = f2 * rf(M, 8204388)
    f1 = f1 + f2
    wfd(8210316, f1)
    f1 = f1 + rf(M, 8214452)
    r_eax = ru(M, 8214452)
    wu(M, 8210492, r_eax)
    wfd(8214452, f1)
    f1 = rf(M, 8214124)
    f1 = f1 * rf(M, 8204332)
    f2 = rf(M, 8214288)
    f2 = f2 * rf(M, 8204336)
    f1 = f1 + f2
    f2 = rf(M, 8210492)
    f2 = f2 * rf(M, 8204340)
    f1 = f1 + f2
    f2 = rf(M, 8213788)
    f2 = f2 * rf(M, 8204344)
    f1 = f1 + f2
    f2 = rf(M, 8213956)
    f2 = f2 * rf(M, 8204348)
    f1 = f1 + f2
    wfd(8210456, f1)
    f1 = f1 + rf(M, 8214276)
    wfd(8214276, f1)
    f1 = rf(M, 8214124)
    f1 = f1 * rf(M, 8204352)
    f2 = rf(M, 8214288)
    f2 = f2 * rf(M, 8204356)
    f1 = f1 + f2
    f2 = rf(M, 8210492)
    f2 = f2 * rf(M, 8204360)
    f1 = f1 + f2
    f2 = rf(M, 8213788)
    f2 = f2 * rf(M, 8204364)
    f1 = f1 + f2
    f2 = rf(M, 8213956)
    f2 = f2 * rf(M, 8204368)
    f1 = f1 + f2
    wfd(8210312, f1)
    f1 = f1 + rf(M, 8214440)
    wfd(8214440, f1)
    f1 = rf(M, 8210316)
    f1 = f1 + rf(M, 8214604)
    wfd(8214604, f1)
    f1 = rf(M, 8214124)
    f1 = f1 * rf(M, 8204392)
    f2 = rf(M, 8214288)
    f2 = f2 * rf(M, 8204396)
    f1 = f1 + f2
    f2 = rf(M, 8210492)
    f2 = f2 * rf(M, 8204400)
    f1 = f1 + f2
    f2 = rf(M, 8213788)
    f2 = f2 * rf(M, 8204404)
    f1 = f1 + f2
    f2 = rf(M, 8213956)
    f2 = f2 * rf(M, 8204408)
    f1 = f1 + f2
    wfd(8210324, f1)
    f1 = f1 + rf(M, 8213948)
    wfd(8213948, f1)
    f1 = rf(M, 8214124)
    f1 = f1 * rf(M, 8204412)
    f2 = rf(M, 8214288)
    f2 = f2 * rf(M, 8204416)
    f1 = f1 + f2
    f2 = rf(M, 8210492)
    f2 = f2 * rf(M, 8204420)
    f1 = f1 + f2
    f2 = rf(M, 8213788)
    f2 = f2 * rf(M, 8204424)
    f1 = f1 + f2
    f2 = rf(M, 8213956)
    f2 = f2 * rf(M, 8204428)
    f1 = f1 + f2
    wfd(8210492, f1)
    f1 = f1 + rf(M, 8214116)
    wfd(8214116, f1)
    f1 = rf(M, 8210456)
    f1 = f1 * rf(M, 8218864)
    f1 = f1 * rf(M, 8218812)
    wfd(8210320, f1)
    p1 = ru(M, 8210320)
    do local sp = NB(1); wu(M, sp + -7245816, p1); NC(0x560120, 1) end
    f1 = rf(M, 8210312)
    f1 = f1 * rf(M, 8218868)
    f1 = f1 * rf(M, 8218820)
    wfd(8210280, f1)
    p1 = ru(M, 8210280)
    do local sp = NB(1); wu(M, sp + -7245816, p1); NC(0x560140, 1) end
    f1 = rf(M, 8210316)
    f1 = f1 * rf(M, 8218864)
    f1 = f1 * rf(M, 8218812)
    wfd(8210316, f1)
    p1 = ru(M, 8210316)
    do local sp = NB(1); wu(M, sp + -7245816, p1); NC(0x5601a0, 1) end
    f1 = rf(M, 8210324)
    f1 = f1 * rf(M, 8218864)
    f1 = f1 * rf(M, 8218800)
    wfd(8210288, f1)
    p1 = ru(M, 8210288)
    do local sp = NB(1); wu(M, sp + -7245816, p1); NC(0x560160, 1) end
    f1 = rf(M, 8210492)
    f1 = f1 * rf(M, 8218864)
    f1 = f1 * rf(M, 8218800)
    wfd(8210284, f1)
    p1 = ru(M, 8210284)
    do local sp = NB(1); wu(M, sp + -7245816, p1); NC(0x560180, 1) end
    do local sp = NB(6); wu(M, sp + -7245816, 15453744); wu(M, sp + -7245812, 15453748); wu(M, sp + -7245808, 15453752); wu(M, sp + -7245804, 15453756); wu(M, sp + -7245800, 15453760); wu(M, sp + -7245796, 15453764); NC(0x560870, 6) end
    f1 = rf(M, 8218876)
    f1 = f1 * rf(M, 8212212)
    wfd(8214940, f1)
    f1 = rf(M, 8218880)
    f1 = f1 * rf(M, 8212216)
    wfd(8214944, f1)
    f1 = rf(M, 8218876)
    f1 = f1 * rf(M, 8212220)
    wfd(8214948, f1)
    f1 = rf(M, 8218884)
    f1 = f1 * rf(M, 8211864)
    wfd(8210308, f1)
    f1 = f1 * rf(M, 8212368)
    wfd(8214952, f1)
    f1 = rf(M, 8210308)
    f1 = f1 * rf(M, 8212372)
    wfd(8214956, f1)
    f1 = rf(M, 8210308)
    f1 = f1 * rf(M, 8212376)
    wfd(8214960, f1)
    f1 = rf(M, 8218888)
    f1 = f1 * rf(M, 8212728)
    wfd(8214964, f1)
    f1 = rf(M, 8218892)
    f1 = f1 * rf(M, 8212732)
    wfd(8214968, f1)
    f1 = rf(M, 8218888)
    f1 = f1 * rf(M, 8212736)
    wfd(8214972, f1)
    f1 = rf(M, 8218888)
    f1 = f1 * rf(M, 8213248)
    wfd(8214976, f1)
    f1 = rf(M, 8218888)
    f1 = f1 * rf(M, 8213252)
    wfd(8214980, f1)
    f1 = rf(M, 8218888)
    f1 = f1 * rf(M, 8213256)
    wfd(8214984, f1)
    f1 = rf(M, 8218888)
    f1 = f1 * rf(M, 8213816)
    f1 = f1 + rf(M, 8214868)
    wfd(8214868, f1)
    f1 = rf(M, 8218888)
    f1 = f1 * rf(M, 8213824)
    f1 = f1 + rf(M, 8214876)
    wfd(8214876, f1)
    f1 = rf(M, 8218888)
    f1 = f1 * rf(M, 8213984)
    f1 = f1 + rf(M, 8214892)
    wfd(8214892, f1)
    f1 = rf(M, 8218888)
    f1 = f1 * rf(M, 8213992)
    f1 = f1 + rf(M, 8214900)
    wfd(8214900, f1)
    f1 = rf(M, 8218896)
    f1 = f1 * rf(M, 8213576)
    wfd(8214988, f1)
    f1 = rf(M, 8218900)
    f1 = f1 * rf(M, 8213580)
    wfd(8214992, f1)
    do local sp = NB(0); NC(0x561a80, 0) end
    p1 = ru(M, 8212048)
    p2 = ru(M, 8212044)
    p3 = ru(M, 8212040)
    f1 = rf(M, 8204432)
    f1 = rf(M, 8212028) - f1
    wfd(8210308, f1)
    f1 = f1 * rf(M, 8212100)
    f2 = rf(M, 8204436)
    f2 = rf(M, 8212032) - f2
    wfd(8210484, f2)
    f2 = f2 * rf(M, 8212112)
    f1 = f1 + f2
    f2 = rf(M, 8204440)
    f2 = rf(M, 8212036) - f2
    wfd(8210292, f2)
    f2 = f2 * rf(M, 8212124)
    f1 = f1 + f2
    p4 = fd(f1)
    f1 = rf(M, 8210308)
    f1 = f1 * rf(M, 8212096)
    f2 = rf(M, 8210484)
    f2 = f2 * rf(M, 8212108)
    f1 = f1 + f2
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8212120)
    f1 = f1 + f2
    p5 = fd(f1)
    f1 = rf(M, 8210308)
    f1 = f1 * rf(M, 8212092)
    f2 = rf(M, 8210484)
    f2 = f2 * rf(M, 8212104)
    f1 = f1 + f2
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8212116)
    f1 = f1 + f2
    p6 = fd(f1)
    do local sp = NB(12); wu(M, sp + -7245816, 15453796); wu(M, sp + -7245812, 15453800); wu(M, sp + -7245808, 15453804); wu(M, sp + -7245804, 15453808); wu(M, sp + -7245800, 15453812); wu(M, sp + -7245796, 15453816); wf(M, sp + -7245792, p6); wf(M, sp + -7245788, p5); wf(M, sp + -7245784, p4); wu(M, sp + -7245780, p3); wu(M, sp + -7245776, p2); wu(M, sp + -7245772, p1); NC(0x561b70, 12) end
    f1 = rf(M, 8212028)
    f1 = f1 * rf(M, 8212100)
    f2 = rf(M, 8212032)
    f2 = f2 * rf(M, 8212112)
    f1 = f1 + f2
    f2 = rf(M, 8212036)
    f2 = f2 * rf(M, 8212124)
    f1 = f1 + f2
    p1 = fd(f1)
    f1 = rf(M, 8212028)
    f1 = f1 * rf(M, 8212096)
    f2 = rf(M, 8212032)
    f2 = f2 * rf(M, 8212108)
    f1 = f1 + f2
    f2 = rf(M, 8212036)
    f2 = f2 * rf(M, 8212120)
    f1 = f1 + f2
    p2 = fd(f1)
    f1 = rf(M, 8212028)
    f1 = f1 * rf(M, 8212092)
    f2 = rf(M, 8212032)
    f2 = f2 * rf(M, 8212104)
    f1 = f1 + f2
    f2 = rf(M, 8212036)
    f2 = f2 * rf(M, 8212116)
    f1 = f1 + f2
    p3 = fd(f1)
    do local sp = NB(9); wu(M, sp + -7245816, 15453832); wu(M, sp + -7245812, 15453836); wu(M, sp + -7245808, 15453840); wu(M, sp + -7245804, 15453844); wu(M, sp + -7245800, 15453848); wu(M, sp + -7245796, 15453852); wf(M, sp + -7245792, p3); wf(M, sp + -7245788, p2); wf(M, sp + -7245784, p1); NC(0x561e50, 9) end
    f1 = rf(M, 8213024)
    f1 = rf(M, 8212504) - f1
    f1 = f1 - rf(M, 8204188)
    f1 = f1 * rf(M, 8204132)
    wfd(8210292, f1)
    p1 = ru(M, 8212504)
    f1 = LKU(7659776, p1)
    p1 = ru(M, 8212500)
    f2 = LKU(7660176, p1)
    f1 = f1 + f2
    wfd(8210484, f1)
    f1 = rf(M, 8210484)
    f1 = f1 + rf(M, 8210292)
    wfd(8215000, f1)
    p1 = ru(M, 8213024)
    f1 = LKU(7659872, p1)
    p1 = ru(M, 8213020)
    f2 = LKU(7660472, p1)
    f1 = f1 + f2
    wfd(8210308, f1)
    f1 = rf(M, 8210292)
    f1 = -f1
    f1 = f1 + rf(M, 8210308)
    wfd(8215004, f1)
    f1 = rf(M, 8218904)
    f1 = f1 * rf(M, 8213612)
    wfd(8210432, f1)
    f1 = f1 + rf(M, 8213548)
    p1 = fd(f1)
    f1 = LKF(7659968, p1)
    f2 = rf(M, 8218908)
    f2 = f2 * rf(M, 8213544)
    wfd(8210328, f2)
    f2 = f2 + rf(M, 8213540)
    p1 = fd(f2)
    f2 = LKF(7660768, p1)
    f1 = f1 + f2
    wfd(8210520, f1)
    f1 = rf(M, 8210432)
    f1 = rf(M, 8213548) - f1
    f1 = f1 - rf(M, 8204184)
    p1 = fd(f1)
    f1 = LKF(7660064, p1)
    f2 = rf(M, 8210328)
    f2 = rf(M, 8213540) - f2
    p1 = fd(f2)
    f2 = LKF(7661064, p1)
    f1 = f1 + f2
    wfd(8210328, f1)
    f1 = f1 + rf(M, 8210520)
    wfd(8210432, f1)
  end
  local function C2()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8218896)
    f1 = f1 * rf(M, 8213584)
    f1 = f1 + rf(M, 8210432)
    wfd(8214996, f1)
    f1 = rf(M, 8210456)
    f1 = f1 + rf(M, 8214124)
    wfd(8214124, f1)
    p1 = ru(M, 8214124)
    p2 = ru(M, 8211784)
    do local sp = NB(3); wu(M, sp + -7245816, 15453904); wu(M, sp + -7245812, p2); wu(M, sp + -7245808, p1); NC(0x560dd0, 3) end
    f1 = rf(M, 8210312)
    f1 = f1 + rf(M, 8214288)
    wfd(8214288, f1)
    f1 = f1 * rf(M, 8218912)
    wfd(8210516, f1)
    f1 = rf(M, 8214124)
    f1 = f1 * rf(M, 8218812)
    f2 = rf(M, 8210516)
    f2 = f2 + rf(M, 8208080)
    f2 = f2 * rf(M, 8218136)
    f1 = f1 + f2
    f2 = rf(M, 8214288)
    f2 = f2 * rf(M, 8218820)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8218704)
    f1 = rf(M, 8214288) - f1
    f1 = f1 * rf(M, 8218820)
    f1 = f1 * rf(M, 8218868)
    f1 = f1 + rf(M, 8210516)
    p1 = fd(f1)
    f1 = rf(M, 8211792)
    f1 = f1 * rf(M, 8218916)
    p2 = fd(f1)
    do local sp = NB(3); wu(M, sp + -7245816, 15453908); wf(M, sp + -7245812, p2); wf(M, sp + -7245808, p1); NC(0x561040, 3) end
    f1 = rf(M, 8212868)
    f1 = f1 * rf(M, 8218788)
    f1 = f1 * rf(M, 8218868)
    f1 = f1 + rf(M, 8214836)
    p1 = fd(f1)
    f1 = rf(M, 8204196)
    f1 = f1 * rf(M, 8211788)
    f1 = f1 + rf(M, 8218920)
    f2 = rf(M, 8212868)
    f2 = f2 * f2
    f2 = f2 * rf(M, 8218924)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8204316)
    p2 = fd(f1)
    do local sp = NB(3); wu(M, sp + -7245816, 15453920); wf(M, sp + -7245812, p2); wf(M, sp + -7245808, p1); NC(0x561040, 3) end
    f1 = rf(M, 8208096)
    f1 = f1 + rf(M, 8214836)
    wfd(8214836, f1)
    f1 = rf(M, 8208096)
    f1 = f1 * rf(M, 8218276)
    wfd(8210312, f1)
    f1 = -f1
    wfd(8215020, f1)
    f1 = rf(M, 8208096)
    f1 = f1 * rf(M, 8218280)
    f1 = -f1
    wfd(8215024, f1)
    p1 = ru(M, 8210312)
    do local sp = NB(1); wu(M, sp + -7245816, p1); NC(0x55e450, 1) end
    f1 = rf(M, 8213388)
    f1 = f1 * rf(M, 8218788)
    f1 = f1 * rf(M, 8218868)
    f1 = f1 + rf(M, 8214860)
    p1 = fd(f1)
    f1 = rf(M, 8204200)
    f1 = f1 * rf(M, 8211788)
    f1 = f1 + rf(M, 8218920)
    f2 = rf(M, 8213388)
    f2 = f2 * f2
    f2 = f2 * rf(M, 8218928)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8204320)
    p2 = fd(f1)
    do local sp = NB(3); wu(M, sp + -7245816, 15453932); wf(M, sp + -7245812, p2); wf(M, sp + -7245808, p1); NC(0x561040, 3) end
    f1 = rf(M, 8208108)
    f1 = f1 + rf(M, 8214860)
    wfd(8214860, f1)
    f1 = rf(M, 8208108)
    f1 = f1 * rf(M, 8218276)
    wfd(8210312, f1)
    f1 = -f1
    wfd(8215028, f1)
    f1 = rf(M, 8208108)
    f1 = f1 * rf(M, 8218336)
    f1 = -f1
    wfd(8215032, f1)
    p1 = ru(M, 8210312)
    do local sp = NB(1); wu(M, sp + -7245816, p1); NC(0x55e460, 1) end
    f1 = rf(M, 8210324)
    f1 = f1 + rf(M, 8213788)
    wfd(8213788, f1)
    f1 = f1 * rf(M, 8218800)
    f1 = f1 * rf(M, 8218868)
    f1 = f1 + rf(M, 8214884)
    p1 = fd(f1)
    f1 = rf(M, 8204204)
    f1 = f1 * rf(M, 8211788)
    f1 = f1 + rf(M, 8218920)
    f2 = rf(M, 8213788)
    f2 = f2 * f2
    f2 = f2 * rf(M, 8218924)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8204324)
    p2 = fd(f1)
    do local sp = NB(3); wu(M, sp + -7245816, 15453948); wf(M, sp + -7245812, p2); wf(M, sp + -7245808, p1); NC(0x561040, 3) end
    f1 = rf(M, 8208124)
    f1 = f1 * rf(M, 8218384)
    wfd(8210312, f1)
    p1 = ru(M, 8210312)
    do local sp = NB(1); wu(M, sp + -7245816, p1); NC(0x55e470, 1) end
    f1 = rf(M, 8210492)
    f1 = f1 + rf(M, 8213956)
    wfd(8213956, f1)
    f1 = f1 * rf(M, 8218800)
    f1 = f1 * rf(M, 8218868)
    f1 = f1 + rf(M, 8214908)
    p1 = fd(f1)
    f1 = rf(M, 8204208)
    f1 = f1 * rf(M, 8211788)
    f1 = f1 + rf(M, 8218920)
    f2 = rf(M, 8213956)
    f2 = f2 * f2
    f2 = f2 * rf(M, 8218924)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8204328)
    p2 = fd(f1)
    do local sp = NB(3); wu(M, sp + -7245816, 15453968); wf(M, sp + -7245812, p2); wf(M, sp + -7245808, p1); NC(0x561040, 3) end
    f1 = rf(M, 8210520)
    f1 = f1 * rf(M, 8218904)
    f2 = rf(M, 8210328)
    f2 = f2 * rf(M, 8218904)
    f1 = f1 - f2
    wfd(8210328, f1)
    f1 = rf(M, 8208124)
    f1 = f1 * rf(M, 8218396)
    f1 = rf(M, 8210328) - f1
    f2 = rf(M, 8208144)
    f2 = f2 * rf(M, 8218408)
    f1 = f1 - f2
    wfd(8215008, f1)
    f1 = rf(M, 8208144)
    f1 = f1 * rf(M, 8218384)
    wfd(8210520, f1)
    f1 = rf(M, 8210312)
    f1 = -f1
    f1 = f1 - rf(M, 8210520)
    wfd(8215036, f1)
    p1 = ru(M, 8210520)
    do local sp = NB(1); wu(M, sp + -7245816, p1); NC(0x55e480, 1) end
    f1 = rf(M, 8218888)
    f1 = f1 * rf(M, 8213820)
    f1 = f1 + rf(M, 8214872)
    wfd(8214872, f1)
    f1 = rf(M, 8218888)
    f1 = f1 * rf(M, 8213988)
    f1 = f1 + rf(M, 8214896)
    wfd(8214896, f1)
    f1 = f1 + rf(M, 8214872)
    p1 = fd(f1)
    p2 = ru(M, 8211796)
    p3 = ru(M, 8211792)
    f1 = rf(M, 8208084)
    f1 = rf(M, 8208080) - f1
    wfd(8215012, f1)
    p4 = ru(M, 8215012)
    f1 = rf(M, 8210516)
    f1 = f1 + rf(M, 8208084)
    wfd(8215016, f1)
    p5 = ru(M, 8215016)
    do local sp = NB(6); wu(M, sp + -7245816, 15453984); wu(M, sp + -7245812, p5); wu(M, sp + -7245808, p4); wu(M, sp + -7245804, p3); wu(M, sp + -7245800, p2); wf(M, sp + -7245796, p1); NC(0x5614b0, 6) end
    f1 = rf(M, 8208124)
    f1 = f1 + rf(M, 8214884)
    wfd(8210520, f1)
    f1 = rf(M, 8213956)
    f1 = f1 * rf(M, 8218800)
    f2 = rf(M, 8208144)
    f2 = f2 + rf(M, 8214908)
    wfd(8210312, f2)
    f2 = f2 + rf(M, 8210520)
    f2 = f2 * rf(M, 8218136)
    f1 = f1 + f2
    f2 = rf(M, 8213788)
    f2 = f2 * rf(M, 8218800)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8218932)
    f1 = rf(M, 8213788) - f1
    f1 = f1 * rf(M, 8218800)
    f1 = f1 * rf(M, 8218868)
    f1 = f1 + rf(M, 8210520)
    p1 = fd(f1)
    p2 = ru(M, 8208160)
    do local sp = NB(3); wu(M, sp + -7245816, 15453988); wu(M, sp + -7245812, p2); wf(M, sp + -7245808, p1); NC(0x561040, 3) end
    f1 = rf(M, 8210520)
    f1 = f1 + rf(M, 8208164)
    wfd(8214884, f1)
    f1 = rf(M, 8210312)
    f1 = f1 - rf(M, 8208164)
    wfd(8214908, f1)
    f1 = rf(M, 8207972)
    f1 = f1 * rf(M, 8212092)
    f2 = rf(M, 8207976)
    f2 = f2 * rf(M, 8212096)
    f1 = f1 + f2
    f2 = rf(M, 8207980)
    f2 = f2 * rf(M, 8212100)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8207920)
    f2 = rf(M, 8208008)
    f2 = f2 * rf(M, 8212092)
    f3 = rf(M, 8208012)
    f3 = f3 * rf(M, 8212096)
    f2 = f2 + f3
    f3 = rf(M, 8208016)
    f3 = f3 * rf(M, 8212100)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8212620)
    f1 = f1 - f2
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8213140)
    f1 = f1 + f2
    f2 = rf(M, 8210484)
    f2 = f2 * rf(M, 8212620)
    f1 = f1 - f2
    f2 = rf(M, 8210308)
    f2 = f2 * rf(M, 8213140)
    f1 = f1 - f2
    f2 = rf(M, 8210432)
    f2 = f2 * rf(M, 8213688)
    f1 = f1 - f2
    p1 = ru(M, 8214628)
    f2 = LKU(7298016, p1)
    p1 = ru(M, 8214616)
    f3 = LKU(7298072, p1)
    f2 = f2 + f3
    wfd(8215040, f2)
    f2 = f2 * rf(M, 8214736)
    p1 = ru(M, 8214632)
    f3 = LKU(7298016, p1)
    p1 = ru(M, 8214620)
    f4 = LKU(7298072, p1)
    f3 = f3 + f4
    wfd(8215044, f3)
    f3 = f3 * rf(M, 8214740)
    f2 = f2 + f3
    p1 = ru(M, 8214636)
    f3 = LKU(7298128, p1)
    p1 = ru(M, 8214624)
    f4 = LKU(7298184, p1)
    f3 = f3 + f4
    wfd(8215048, f3)
    f3 = f3 * rf(M, 8214748)
    f2 = f2 + f3
    f1 = f1 - f2
    wfd(8214924, f1)
    f1 = rf(M, 8207972)
    f1 = f1 * rf(M, 8212104)
    f2 = rf(M, 8207976)
    f2 = f2 * rf(M, 8212108)
    f1 = f1 + f2
    f2 = rf(M, 8207980)
    f2 = f2 * rf(M, 8212112)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8207924)
    f2 = rf(M, 8208008)
    f2 = f2 * rf(M, 8212104)
    f3 = rf(M, 8208012)
    f3 = f3 * rf(M, 8212108)
    f2 = f2 + f3
    f3 = rf(M, 8208016)
    f3 = f3 * rf(M, 8212112)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8212644)
    f1 = f1 - f2
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8213164)
    f1 = f1 + f2
    f2 = rf(M, 8210484)
    f2 = f2 * rf(M, 8212644)
    f1 = f1 - f2
    f2 = rf(M, 8210308)
    f2 = f2 * rf(M, 8213164)
    f1 = f1 - f2
    f2 = rf(M, 8210432)
    f2 = f2 * rf(M, 8213720)
    f1 = f1 - f2
    f2 = rf(M, 8215040)
    f2 = f2 * rf(M, 8214756)
    f3 = rf(M, 8215044)
    f3 = f3 * rf(M, 8214764)
    f2 = f2 + f3
    f3 = rf(M, 8215048)
    f3 = f3 * rf(M, 8214768)
    f2 = f2 + f3
    f1 = f1 - f2
    wfd(8214928, f1)
  end
  local function C3()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8207932)
    f1 = f1 * rf(M, 8212136)
    f2 = rf(M, 8207936)
    f2 = f2 * rf(M, 8212148)
    f1 = f1 + f2
    f2 = rf(M, 8207940)
    f2 = f2 * rf(M, 8212160)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8207992)
    f1 = f1 + rf(M, 8208028)
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8212672)
    f1 = f1 - f2
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8213192)
    f1 = f1 + f2
    f2 = rf(M, 8210484)
    f2 = f2 * rf(M, 8212672)
    f1 = f1 - f2
    f2 = rf(M, 8210308)
    f2 = f2 * rf(M, 8213192)
    f1 = f1 - f2
    f2 = rf(M, 8210432)
    f2 = f2 * rf(M, 8213756)
    f3 = rf(M, 8210328)
    f3 = f3 * rf(M, 8218352)
    f2 = f2 + f3
    f1 = f1 - f2
    f2 = rf(M, 8215040)
    f2 = f2 * rf(M, 8214780)
    f3 = rf(M, 8215044)
    f3 = f3 * rf(M, 8214788)
    f2 = f2 + f3
    f1 = f1 - f2
    wfd(8214936, f1)
    f1 = rf(M, 8212048)
    f1 = -f1
    f1 = f1 * rf(M, 8212152)
    f2 = rf(M, 8212040)
    f2 = f2 * rf(M, 8212160)
    f1 = f1 + f2
    wfd(8210520, f1)
    f1 = rf(M, 8212036) - f1
    p1 = fd(f1)
    f1 = rf(M, 8210520)
    f1 = f1 + rf(M, 8212036)
    p2 = fd(f1)
    f1 = rf(M, 8212156)
    f1 = rf(M, 8212060) - f1
    p3 = fd(f1)
    f1 = rf(M, 8212060)
    f1 = f1 + rf(M, 8212156)
    p4 = fd(f1)
    do local sp = NB(6); wu(M, sp + -7245816, 15454012); wu(M, sp + -7245812, 15454016); wf(M, sp + -7245808, p4); wf(M, sp + -7245804, p3); wf(M, sp + -7245800, p2); wf(M, sp + -7245796, p1); NC(0x5618d0, 6) end
    f1 = rf(M, 8218872)
    f1 = f1 + rf(M, 8207928)
    f2 = rf(M, 8207972)
    f2 = f2 * rf(M, 8212116)
    f3 = rf(M, 8207976)
    f3 = f3 * rf(M, 8212120)
    f2 = f2 + f3
    f3 = rf(M, 8207980)
    f3 = f3 * rf(M, 8212124)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8208008)
    f2 = f2 * rf(M, 8212116)
    f3 = rf(M, 8208012)
    f3 = f3 * rf(M, 8212120)
    f2 = f2 + f3
    f3 = rf(M, 8208016)
    f3 = f3 * rf(M, 8212124)
    f2 = f2 + f3
    f1 = f1 + f2
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8212668)
    f1 = f1 - f2
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8213188)
    f1 = f1 + f2
    f2 = rf(M, 8210484)
    f2 = f2 * rf(M, 8212668)
    f1 = f1 - f2
    f2 = rf(M, 8210308)
    f2 = f2 * rf(M, 8213188)
    f1 = f1 - f2
    f2 = rf(M, 8210432)
    f2 = f2 * rf(M, 8213752)
    f1 = f1 - f2
    f2 = rf(M, 8215040)
    f2 = f2 * rf(M, 8214776)
    f3 = rf(M, 8215044)
    f3 = f3 * rf(M, 8214784)
    f2 = f2 + f3
    f3 = rf(M, 8215048)
    f3 = f3 * rf(M, 8214792)
    f2 = f2 + f3
    f1 = f1 - f2
    f2 = rf(M, 8208192)
    f2 = f2 + rf(M, 8208188)
    f1 = f1 + f2
    wfd(8214932, f1)
    f1 = rf(M, 8208192)
    f1 = rf(M, 8208188) - f1
    wfd(8210520, f1)
    f1 = rf(M, 8210320)
    f1 = -f1
    f1 = f1 - rf(M, 8210280)
    f1 = f1 - rf(M, 8210316)
    f2 = rf(M, 8207932)
    f2 = f2 * rf(M, 8212128)
    f3 = rf(M, 8207936)
    f3 = f3 * rf(M, 8212140)
    f2 = f2 + f3
    f3 = rf(M, 8207940)
    f3 = f3 * rf(M, 8212152)
    f2 = f2 + f3
    f1 = f1 + f2
    f1 = f1 + rf(M, 8207984)
    f1 = f1 + rf(M, 8208020)
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8212624)
    f1 = f1 - f2
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8213144)
    f1 = f1 + f2
    f2 = rf(M, 8210484)
    f2 = f2 * rf(M, 8212624)
    f1 = f1 - f2
    f2 = rf(M, 8210308)
    f2 = f2 * rf(M, 8213144)
    f1 = f1 - f2
    f2 = rf(M, 8210432)
    f2 = f2 * rf(M, 8213692)
    f3 = rf(M, 8210328)
    f3 = f3 * rf(M, 8218348)
    f2 = f2 + f3
    f1 = f1 - f2
    f2 = rf(M, 8208080)
    f2 = f2 * rf(M, 8218412)
    f1 = f1 - f2
    f2 = rf(M, 8210516)
    f2 = f2 * rf(M, 8218412)
    f1 = f1 - f2
    f2 = rf(M, 8215044)
    f2 = f2 * rf(M, 8214744)
    f3 = rf(M, 8215048)
    f3 = f3 * rf(M, 8214752)
    f2 = f2 + f3
    f1 = f1 - f2
    f1 = f1 + rf(M, 8210520)
    wfd(8214916, f1)
    f1 = rf(M, 8210288)
    f1 = -f1
    f1 = f1 - rf(M, 8210284)
    f2 = rf(M, 8207932)
    f2 = f2 * rf(M, 8212132)
    f3 = rf(M, 8207936)
    f3 = f3 * rf(M, 8212144)
    f2 = f2 + f3
    f3 = rf(M, 8207940)
    f3 = f3 * rf(M, 8212156)
    f2 = f2 + f3
    f1 = f1 + f2
    f1 = f1 + rf(M, 8207988)
    f1 = f1 + rf(M, 8208024)
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8212648)
    f1 = f1 - f2
    f2 = rf(M, 8210292)
    f2 = f2 * rf(M, 8213168)
    f1 = f1 + f2
    f2 = rf(M, 8210484)
    f2 = f2 * rf(M, 8212648)
    f1 = f1 - f2
    f2 = rf(M, 8210308)
    f2 = f2 * rf(M, 8213168)
    f1 = f1 - f2
    f2 = rf(M, 8210432)
    f2 = f2 * rf(M, 8213724)
    f1 = f1 - f2
    f2 = rf(M, 8208080)
    f2 = f2 * rf(M, 8218416)
    f1 = f1 - f2
    f2 = rf(M, 8210516)
    f2 = f2 * rf(M, 8218416)
    f1 = f1 - f2
    f2 = rf(M, 8215040)
    f2 = f2 * rf(M, 8214760)
    f3 = rf(M, 8215048)
    f3 = f3 * rf(M, 8214772)
    f2 = f2 + f3
    f1 = f1 - f2
    f2 = rf(M, 8210520)
    f2 = abs(f2)
    f2 = f2 * rf(M, 8218144)
    f1 = f1 + f2
    wfd(8214920, f1)
    do local sp = NB(0); NC(0x560300, 0) end
  end
  JIT[0xeb5af7] = function() -- forces
    C1()
    C2()
    C3()
  end
end
end
]=])
module("NR2003Cup","NR2003CupJIT4",[=[
--!native
--!optimize 2
-- GENERATED NR2003 Cup vehicle runtime: translated JIT callbacks, part 4 (corrector, commit).
-- These are the x87 callbacks NR2003.exe generates itself at car build (005b3090, mode-2 emitter),
-- translated instruction by instruction. Float32 stores round toward -inf (CW 0x077f).
-- Do not edit by hand: regenerate with recovery/stage6_7/gen_runtime.py.
return function(ctx)
local M, JIT, LKF, LKU, NB, NC = ctx.M, ctx.JIT, ctx.LKF, ctx.LKU, ctx.NB, ctx.NC
local rf, wf, ru, wu = buffer.readf32, buffer.writef32, buffer.readu32, buffer.writeu32
local abs, sqrt, sin, cos, fmod = math.abs, math.sqrt, math.sin, math.cos, math.fmod
local TINY = 2 ^ -125
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

do -- corrector (12 chunks)
  local r_eax, r_ebx, r_ecx, r_edx, r_esi, r_edi
  local function C1()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8212028)
    f1 = f1 + rf(M, 8211816)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8211812)
    wfd(8214504, f1)
    wfd(8214492, f1)
    wfd(8214340, f1)
    wfd(8214328, f1)
    wfd(8214176, f1)
    wfd(8214164, f1)
    wfd(8212064, f1)
    wfd(8212052, f1)
    f1 = rf(M, 8212032)
    f1 = f1 + rf(M, 8211824)
    f1 = f1 * rf(M, 8218940)
    f1 = f1 + rf(M, 8211820)
    wfd(8214508, f1)
    wfd(8214496, f1)
    wfd(8214344, f1)
    wfd(8214332, f1)
    wfd(8214180, f1)
    wfd(8214168, f1)
    wfd(8212068, f1)
    wfd(8212056, f1)
    f1 = rf(M, 8212036)
    f1 = f1 + rf(M, 8211832)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8211828)
    wfd(8214512, f1)
    wfd(8214500, f1)
    wfd(8214348, f1)
    wfd(8214336, f1)
    wfd(8214184, f1)
    wfd(8214172, f1)
    wfd(8212072, f1)
    wfd(8212060, f1)
    f1 = rf(M, 8212040)
    f1 = f1 + rf(M, 8211852)
    f1 = f1 * rf(M, 8218144)
    f1 = f1 * rf(M, 8218936)
    wfd(8210520, f1)
    f1 = f1 * rf(M, 8211848)
    f2 = rf(M, 8212048)
    f2 = f2 + rf(M, 8211860)
    f2 = f2 * rf(M, 8218144)
    f2 = f2 * rf(M, 8218936)
    wfd(8210516, f2)
    f2 = f2 * rf(M, 8211840)
    f3 = rf(M, 8212044)
    f3 = f3 + rf(M, 8211856)
    f3 = f3 * rf(M, 8218144)
    f3 = f3 * rf(M, 8218936)
    wfd(8210432, f3)
    f3 = f3 * rf(M, 8211844)
    f2 = f2 - f3
    f1 = f1 + f2
    f1 = f1 + rf(M, 8211836)
    wfd(8210308, f1)
    f1 = f1 * f1
    f2 = rf(M, 8210432)
    f2 = f2 * rf(M, 8211848)
    f3 = rf(M, 8210520)
    f3 = f3 * rf(M, 8211844)
    f4 = rf(M, 8210516)
    f4 = f4 * rf(M, 8211836)
    f3 = f3 - f4
    f2 = f2 + f3
    f2 = f2 + rf(M, 8211840)
    wfd(8210484, f2)
    f2 = f2 * f2
    f1 = f1 + f2
    f2 = rf(M, 8210516)
    f2 = f2 * rf(M, 8211848)
    f3 = rf(M, 8210432)
    f3 = f3 * rf(M, 8211836)
    f4 = rf(M, 8210520)
    f4 = f4 * rf(M, 8211840)
    f3 = f3 - f4
    f2 = f2 + f3
    f2 = f2 + rf(M, 8211844)
    wfd(8210292, f2)
    f2 = f2 * f2
    f1 = f1 + f2
    f2 = rf(M, 8210520)
    f2 = f2 * rf(M, 8211836)
    f3 = rf(M, 8210432)
    f3 = f3 * rf(M, 8211840)
    f2 = f2 + f3
    f3 = rf(M, 8210516)
    f3 = f3 * rf(M, 8211844)
    f2 = f2 + f3
    f2 = -f2
    f2 = f2 + rf(M, 8211848)
    wfd(8210516, f2)
    f2 = f2 * f2
    f1 = f1 + f2
    f1 = sqrt(f1)
    q = fd(f1)
    if q < TINY and q > -TINY then f1 = 1 else f1 = 1 / q end
    wfd(8210432, f1)
    f1 = rf(M, 8210516)
    f1 = f1 * rf(M, 8210432)
    wfd(8212076, f1)
    f1 = f1 * rf(M, 8218152)
    wfd(8210516, f1)
    f1 = rf(M, 8212076)
    f1 = f1 * rf(M, 8210516)
    wfd(8210520, f1)
    f1 = rf(M, 8210308)
    f1 = f1 * rf(M, 8210432)
    wfd(8212080, f1)
    f1 = f1 * rf(M, 8218152)
    wfd(8210308, f1)
    f1 = rf(M, 8212080)
    f1 = f1 * rf(M, 8210308)
    f1 = f1 + rf(M, 8210520)
    f1 = f1 - rf(M, 8218160)
    wfd(8214700, f1)
    wfd(8214640, f1)
    wfd(8212404, f1)
    wfd(8212344, f1)
    wfd(8212248, f1)
    wfd(8212188, f1)
    wfd(8212128, f1)
    wfd(8212092, f1)
    f1 = rf(M, 8210484)
    f1 = f1 * rf(M, 8210432)
    wfd(8212084, f1)
    f1 = f1 * rf(M, 8210308)
    wfd(8210484, f1)
    f1 = rf(M, 8210292)
    f1 = f1 * rf(M, 8210432)
    wfd(8212088, f1)
    f1 = f1 * rf(M, 8210516)
    wfd(8210432, f1)
    f1 = rf(M, 8210484) - f1
    wfd(8214704, f1)
    wfd(8214644, f1)
    wfd(8212408, f1)
    wfd(8212348, f1)
    wfd(8212252, f1)
    wfd(8212192, f1)
    wfd(8212132, f1)
    wfd(8212096, f1)
    f1 = rf(M, 8212088)
    f1 = f1 * rf(M, 8210308)
    wfd(8210308, f1)
    f1 = rf(M, 8212084)
    f1 = f1 * rf(M, 8210516)
    wfd(8210292, f1)
    f1 = f1 + rf(M, 8210308)
    wfd(8214708, f1)
    wfd(8214648, f1)
    wfd(8214528, f1)
    wfd(8214464, f1)
    wfd(8214364, f1)
    wfd(8214300, f1)
    wfd(8214200, f1)
    wfd(8214136, f1)
    wfd(8212412, f1)
    wfd(8212352, f1)
    wfd(8212256, f1)
    wfd(8212196, f1)
    wfd(8212136, f1)
    wfd(8212100, f1)
    f1 = rf(M, 8210432)
    f1 = f1 + rf(M, 8210484)
    wfd(8214712, f1)
    wfd(8214652, f1)
    wfd(8212416, f1)
    wfd(8212356, f1)
    wfd(8212260, f1)
    wfd(8212200, f1)
    wfd(8212140, f1)
    wfd(8212104, f1)
    f1 = rf(M, 8212084)
    f1 = f1 * rf(M, 8218152)
    wfd(8210484, f1)
    f1 = rf(M, 8212084)
    f1 = f1 * rf(M, 8210484)
    f1 = f1 + rf(M, 8210520)
    f1 = f1 - rf(M, 8218160)
    wfd(8214716, f1)
    wfd(8214656, f1)
    wfd(8212420, f1)
    wfd(8212360, f1)
    wfd(8212264, f1)
    wfd(8212204, f1)
    wfd(8212144, f1)
    wfd(8212108, f1)
    f1 = rf(M, 8212088)
    f1 = f1 * rf(M, 8210484)
    wfd(8210484, f1)
    f1 = rf(M, 8212080)
    f1 = f1 * rf(M, 8210516)
    wfd(8210516, f1)
    f1 = rf(M, 8210484) - f1
    wfd(8214720, f1)
    wfd(8214660, f1)
    wfd(8214540, f1)
    wfd(8214476, f1)
    wfd(8214376, f1)
    wfd(8214312, f1)
    wfd(8214212, f1)
    wfd(8214148, f1)
    wfd(8212424, f1)
    wfd(8212364, f1)
    wfd(8212268, f1)
    wfd(8212208, f1)
    wfd(8212148, f1)
    wfd(8212112, f1)
    f1 = rf(M, 8210292)
    f1 = rf(M, 8210308) - f1
    wfd(8214724, f1)
    wfd(8214664, f1)
    wfd(8212428, f1)
    wfd(8212368, f1)
    wfd(8212272, f1)
    wfd(8212212, f1)
    wfd(8212152, f1)
    wfd(8212116, f1)
    f1 = rf(M, 8210516)
    f1 = f1 + rf(M, 8210484)
    wfd(8214728, f1)
    wfd(8214668, f1)
    wfd(8212432, f1)
    wfd(8212372, f1)
    wfd(8212276, f1)
    wfd(8212216, f1)
    wfd(8212156, f1)
    wfd(8212120, f1)
    f1 = rf(M, 8212088)
    f1 = f1 * rf(M, 8218152)
    f1 = f1 * rf(M, 8212088)
    f1 = f1 + rf(M, 8210520)
    f1 = f1 - rf(M, 8218160)
    wfd(8214732, f1)
    wfd(8214672, f1)
    wfd(8214552, f1)
    wfd(8214488, f1)
    wfd(8214388, f1)
    wfd(8214324, f1)
    wfd(8214224, f1)
    wfd(8214160, f1)
    wfd(8212436, f1)
    wfd(8212376, f1)
    wfd(8212280, f1)
    wfd(8212220, f1)
    wfd(8212160, f1)
    wfd(8212124, f1)
    f1 = rf(M, 8215124)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8215100)
    f2 = rf(M, 8214924)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8216984, f1)
    f1 = rf(M, 8215128)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8215104)
    f2 = rf(M, 8214928)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8216988, f1)
    f1 = rf(M, 8215132)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8215108)
    f2 = rf(M, 8214932)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8216992, f1)
    f1 = rf(M, 8215136)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8215112)
    wfd(8210520, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8215064)
    f2 = rf(M, 8214712)
    f2 = f2 * rf(M, 8215076)
    f1 = f1 + f2
    f2 = rf(M, 8214724)
    f2 = f2 * rf(M, 8215088)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210520)
    f2 = rf(M, 8215140)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8215116)
    wfd(8210484, f2)
    f2 = rf(M, 8214700)
    f2 = f2 * rf(M, 8215068)
    f3 = rf(M, 8214712)
    f3 = f3 * rf(M, 8215080)
    f2 = f2 + f3
    f3 = rf(M, 8214724)
    f3 = f3 * rf(M, 8215092)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8215144)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8215120)
    wfd(8210516, f2)
    f2 = rf(M, 8214700)
    f2 = f2 * rf(M, 8215072)
    f3 = rf(M, 8214712)
    f3 = f3 * rf(M, 8215084)
    f2 = f2 + f3
    f3 = rf(M, 8214724)
    f3 = f3 * rf(M, 8215096)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8214916)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8216996, f1)
  end
  local function C2()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8214704)
    f1 = f1 * rf(M, 8215064)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8215076)
    f1 = f1 + f2
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8215088)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210520)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8215068)
    f3 = rf(M, 8214716)
    f3 = f3 * rf(M, 8215080)
    f2 = f2 + f3
    f3 = rf(M, 8214728)
    f3 = f3 * rf(M, 8215092)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8215072)
    f3 = rf(M, 8214716)
    f3 = f3 * rf(M, 8215084)
    f2 = f2 + f3
    f3 = rf(M, 8214728)
    f3 = f3 * rf(M, 8215096)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8214920)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217000, f1)
    f1 = rf(M, 8214708)
    f1 = f1 * rf(M, 8215064)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8215076)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8215088)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210520)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8215068)
    f3 = rf(M, 8214720)
    f3 = f3 * rf(M, 8215080)
    f2 = f2 + f3
    f3 = rf(M, 8214732)
    f3 = f3 * rf(M, 8215092)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8215072)
    f3 = rf(M, 8214720)
    f3 = f3 * rf(M, 8215084)
    f2 = f2 + f3
    f3 = rf(M, 8214732)
    f3 = f3 * rf(M, 8215096)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8214936)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217004, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218164)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218172)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214504)
    wfd(8212236, f1)
    wfd(8212224, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218164)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218172)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214508)
    wfd(8212240, f1)
    wfd(8212228, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218164)
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218172)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214512)
    wfd(8212244, f1)
    wfd(8212232, f1)
    f1 = rf(M, 8215256)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8215244)
    wfd(8210516, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8215160)
    f2 = rf(M, 8214712)
    f2 = f2 * rf(M, 8215172)
    f1 = f1 + f2
    f2 = rf(M, 8214724)
    f2 = f2 * rf(M, 8215184)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210516)
    f2 = rf(M, 8215260)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8215248)
    wfd(8210484, f2)
    f2 = rf(M, 8214700)
    f2 = f2 * rf(M, 8215164)
    f3 = rf(M, 8214712)
    f3 = f3 * rf(M, 8215176)
    f2 = f2 + f3
    f3 = rf(M, 8214724)
    f3 = f3 * rf(M, 8215188)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8215264)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8215252)
    wfd(8210520, f2)
    f2 = rf(M, 8214700)
    f2 = f2 * rf(M, 8215168)
    f3 = rf(M, 8214712)
    f3 = f3 * rf(M, 8215180)
    f2 = f2 + f3
    f3 = rf(M, 8214724)
    f3 = f3 * rf(M, 8215192)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210520)
    f1 = f1 + f2
    f2 = rf(M, 8214940)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217008, f1)
    f1 = rf(M, 8214704)
    f1 = f1 * rf(M, 8215160)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8215172)
    f1 = f1 + f2
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8215184)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210516)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8215164)
    f3 = rf(M, 8214716)
    f3 = f3 * rf(M, 8215176)
    f2 = f2 + f3
    f3 = rf(M, 8214728)
    f3 = f3 * rf(M, 8215188)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8215168)
    f3 = rf(M, 8214716)
    f3 = f3 * rf(M, 8215180)
    f2 = f2 + f3
    f3 = rf(M, 8214728)
    f3 = f3 * rf(M, 8215192)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210520)
    f1 = f1 + f2
    f2 = rf(M, 8214944)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217012, f1)
    f1 = rf(M, 8214708)
    f1 = f1 * rf(M, 8215160)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8215172)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8215184)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210516)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8215164)
    f3 = rf(M, 8214720)
    f3 = f3 * rf(M, 8215176)
    f2 = f2 + f3
    f3 = rf(M, 8214732)
    f3 = f3 * rf(M, 8215188)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8215168)
    f3 = rf(M, 8214720)
    f3 = f3 * rf(M, 8215180)
    f2 = f2 + f3
    f3 = rf(M, 8214732)
    f3 = f3 * rf(M, 8215192)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210520)
    f1 = f1 + f2
    f2 = rf(M, 8214948)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217016, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218176)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218184)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214504)
    wfd(8212392, f1)
    wfd(8212380, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218176)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218184)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214508)
    wfd(8212396, f1)
    wfd(8212384, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218176)
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218184)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214512)
    wfd(8212400, f1)
    wfd(8212388, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8215328)
    f2 = rf(M, 8214712)
    f2 = f2 * rf(M, 8215340)
    f1 = f1 + f2
    f2 = rf(M, 8214724)
    f2 = f2 * rf(M, 8215352)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8215376)
    f2 = rf(M, 8214700)
    f2 = f2 * rf(M, 8215332)
    f3 = rf(M, 8214712)
    f3 = f3 * rf(M, 8215344)
    f2 = f2 + f3
    f3 = rf(M, 8214724)
    f3 = f3 * rf(M, 8215356)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8215380)
    f1 = f1 + f2
    f2 = rf(M, 8214700)
    f2 = f2 * rf(M, 8215336)
    f3 = rf(M, 8214712)
    f3 = f3 * rf(M, 8215348)
    f2 = f2 + f3
    f3 = rf(M, 8214724)
    f3 = f3 * rf(M, 8215360)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8215384)
    f1 = f1 + f2
    wfd(8217032, f1)
    f1 = rf(M, 8214704)
    f1 = f1 * rf(M, 8215328)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8215340)
    f1 = f1 + f2
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8215352)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8215376)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8215332)
    f3 = rf(M, 8214716)
    f3 = f3 * rf(M, 8215344)
    f2 = f2 + f3
    f3 = rf(M, 8214728)
    f3 = f3 * rf(M, 8215356)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8215380)
    f1 = f1 + f2
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8215336)
    f3 = rf(M, 8214716)
    f3 = f3 * rf(M, 8215348)
    f2 = f2 + f3
    f3 = rf(M, 8214728)
    f3 = f3 * rf(M, 8215360)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8215384)
    f1 = f1 + f2
    wfd(8217036, f1)
    f1 = rf(M, 8214708)
    f1 = f1 * rf(M, 8215328)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8215340)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8215352)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8215376)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8215332)
    f3 = rf(M, 8214720)
    f3 = f3 * rf(M, 8215344)
    f2 = f2 + f3
    f3 = rf(M, 8214732)
    f3 = f3 * rf(M, 8215356)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8215380)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8215336)
    f3 = rf(M, 8214720)
    f3 = f3 * rf(M, 8215348)
    f2 = f2 + f3
    f3 = rf(M, 8214732)
    f3 = f3 * rf(M, 8215360)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8215384)
    f1 = f1 + f2
    wfd(8217040, f1)
  end
  local function C3()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8215388)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8215364)
    wfd(8210520, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8215280)
    f2 = rf(M, 8214712)
    f2 = f2 * rf(M, 8215292)
    f1 = f1 + f2
    f2 = rf(M, 8214724)
    f2 = f2 * rf(M, 8215304)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210520)
    f2 = rf(M, 8215392)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8215368)
    wfd(8210484, f2)
    f2 = rf(M, 8214700)
    f2 = f2 * rf(M, 8215284)
    f3 = rf(M, 8214712)
    f3 = f3 * rf(M, 8215296)
    f2 = f2 + f3
    f3 = rf(M, 8214724)
    f3 = f3 * rf(M, 8215308)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8215396)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8215372)
    wfd(8210516, f2)
    f2 = rf(M, 8214700)
    f2 = f2 * rf(M, 8215288)
    f3 = rf(M, 8214712)
    f3 = f3 * rf(M, 8215300)
    f2 = f2 + f3
    f3 = rf(M, 8214724)
    f3 = f3 * rf(M, 8215312)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8214952)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217020, f1)
    f1 = rf(M, 8214704)
    f1 = f1 * rf(M, 8215280)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8215292)
    f1 = f1 + f2
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8215304)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210520)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8215284)
    f3 = rf(M, 8214716)
    f3 = f3 * rf(M, 8215296)
    f2 = f2 + f3
    f3 = rf(M, 8214728)
    f3 = f3 * rf(M, 8215308)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8215288)
    f3 = rf(M, 8214716)
    f3 = f3 * rf(M, 8215300)
    f2 = f2 + f3
    f3 = rf(M, 8214728)
    f3 = f3 * rf(M, 8215312)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8214956)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217024, f1)
    f1 = rf(M, 8214708)
    f1 = f1 * rf(M, 8215280)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8215292)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8215304)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210520)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8215284)
    f3 = rf(M, 8214720)
    f3 = f3 * rf(M, 8215296)
    f2 = f2 + f3
    f3 = rf(M, 8214732)
    f3 = f3 * rf(M, 8215308)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8215288)
    f3 = rf(M, 8214720)
    f3 = f3 * rf(M, 8215300)
    f2 = f2 + f3
    f3 = rf(M, 8214732)
    f3 = f3 * rf(M, 8215312)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8214960)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217028, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218188)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218192)
    f1 = f1 + f2
    wfd(8212568, f1)
    wfd(8212508, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218196)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218200)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218204)
    f1 = f1 + f2
    wfd(8212572, f1)
    wfd(8212512, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218208)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218212)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218220)
    f1 = f1 + f2
    wfd(8212576, f1)
    wfd(8212516, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218188)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218192)
    f1 = f1 + f2
    wfd(8212580, f1)
    wfd(8212520, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218196)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218200)
    f1 = f1 + f2
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218204)
    f1 = f1 + f2
    wfd(8212584, f1)
    wfd(8212524, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218208)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218212)
    f1 = f1 + f2
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218220)
    f1 = f1 + f2
    wfd(8212588, f1)
    wfd(8212528, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218188)
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218192)
    f1 = f1 + f2
    wfd(8212592, f1)
    wfd(8212532, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218196)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218200)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218204)
    f1 = f1 + f2
    wfd(8212596, f1)
    wfd(8212536, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218208)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218212)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218220)
    f1 = f1 + f2
    wfd(8212600, f1)
    wfd(8212540, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218224)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218228)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218236)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214504)
    wfd(8212544, f1)
    f1 = rf(M, 8212500)
    f1 = f1 + rf(M, 8211892)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8211888)
    wfd(8212504, f1)
    f1 = f1 * rf(M, 8212576)
    f1 = f1 + rf(M, 8212544)
    wfd(8212920, f1)
    wfd(8212908, f1)
    wfd(8212752, f1)
    wfd(8212740, f1)
    wfd(8212556, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218224)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218228)
    f1 = f1 + f2
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218236)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214508)
    wfd(8212548, f1)
    f1 = rf(M, 8212504)
    f1 = f1 * rf(M, 8212588)
    f1 = f1 + rf(M, 8212548)
    wfd(8212924, f1)
    wfd(8212912, f1)
    wfd(8212756, f1)
    wfd(8212744, f1)
    wfd(8212560, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218224)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218228)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218236)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214512)
    wfd(8212552, f1)
    f1 = rf(M, 8212504)
    f1 = f1 * rf(M, 8212600)
    f1 = f1 + rf(M, 8212552)
    wfd(8212928, f1)
    wfd(8212916, f1)
    wfd(8212760, f1)
    wfd(8212748, f1)
    wfd(8212564, f1)
    f1 = rf(M, 8215496)
    f1 = f1 * rf(M, 8218936)
    wfd(8210516, f1)
    f1 = rf(M, 8212568)
    f1 = f1 * rf(M, 8215420)
    f2 = rf(M, 8212580)
    f2 = f2 * rf(M, 8215432)
    f1 = f1 + f2
    f2 = rf(M, 8212592)
    f2 = f2 * rf(M, 8215444)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210516)
    wfd(8217048, f1)
    f1 = rf(M, 8212572)
    f1 = f1 * rf(M, 8215420)
    f2 = rf(M, 8212584)
    f2 = f2 * rf(M, 8215432)
    f1 = f1 + f2
    f2 = rf(M, 8212596)
    f2 = f2 * rf(M, 8215444)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210516)
    wfd(8217052, f1)
    f1 = rf(M, 8212576)
    f1 = f1 * rf(M, 8215420)
    f2 = rf(M, 8212588)
    f2 = f2 * rf(M, 8215432)
    f1 = f1 + f2
    f2 = rf(M, 8212600)
    f2 = f2 * rf(M, 8215444)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210516)
    f2 = rf(M, 8215000)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217044, f1)
    f1 = rf(M, 8212568)
    f1 = f1 * rf(M, 8218260)
    f2 = rf(M, 8212572)
    f2 = f2 * rf(M, 8218264)
    f1 = f1 + f2
    f2 = rf(M, 8212576)
    f2 = f2 * rf(M, 8218272)
    f1 = f1 + f2
    wfd(8212792, f1)
    wfd(8212712, f1)
    f1 = rf(M, 8212580)
    f1 = f1 * rf(M, 8218260)
    f2 = rf(M, 8212584)
    f2 = f2 * rf(M, 8218264)
    f1 = f1 + f2
    f2 = rf(M, 8212588)
    f2 = f2 * rf(M, 8218272)
    f1 = f1 + f2
    wfd(8212804, f1)
    wfd(8212724, f1)
  end
  local function C4()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8212592)
    f1 = f1 * rf(M, 8218260)
    f2 = rf(M, 8212596)
    f2 = f2 * rf(M, 8218264)
    f1 = f1 + f2
    f2 = rf(M, 8212600)
    f2 = f2 * rf(M, 8218272)
    f1 = f1 + f2
    wfd(8212816, f1)
    wfd(8212736, f1)
    f1 = rf(M, 8211776)
    wfd(8212764, f1)
    f1 = cos(f1)
    wfd(8212772, f1)
    wfd(8212768, f1)
    f1 = rf(M, 8212568)
    f1 = f1 * rf(M, 8218240)
    f2 = rf(M, 8212576)
    f2 = f2 * rf(M, 8218244)
    f1 = f1 + f2
    wfd(8212704, f1)
    f1 = rf(M, 8212772)
    f1 = f1 * rf(M, 8212704)
    f2 = rf(M, 8212568)
    f2 = f2 * rf(M, 8218248)
    f3 = rf(M, 8212572)
    f3 = f3 * rf(M, 8218252)
    f2 = f2 + f3
    f3 = rf(M, 8212576)
    f3 = f3 * rf(M, 8218256)
    f2 = f2 + f3
    wfd(8212708, f2)
    f2 = rf(M, 8212764)
    f2 = sin(f2)
    wfd(8212776, f2)
    f2 = f2 * rf(M, 8212708)
    f1 = f1 + f2
    wfd(8212936, f1)
    wfd(8212872, f1)
    wfd(8212784, f1)
    f1 = rf(M, 8212580)
    f1 = f1 * rf(M, 8218240)
    f2 = rf(M, 8212588)
    f2 = f2 * rf(M, 8218244)
    f1 = f1 + f2
    wfd(8212716, f1)
    f1 = rf(M, 8212772)
    f1 = f1 * rf(M, 8212716)
    f2 = rf(M, 8212580)
    f2 = f2 * rf(M, 8218248)
    f3 = rf(M, 8212584)
    f3 = f3 * rf(M, 8218252)
    f2 = f2 + f3
    f3 = rf(M, 8212588)
    f3 = f3 * rf(M, 8218256)
    f2 = f2 + f3
    wfd(8212720, f2)
    f2 = rf(M, 8212776)
    f2 = f2 * rf(M, 8212720)
    f1 = f1 + f2
    wfd(8212948, f1)
    wfd(8212884, f1)
    wfd(8212796, f1)
    f1 = rf(M, 8212592)
    f1 = f1 * rf(M, 8218240)
    f2 = rf(M, 8212600)
    f2 = f2 * rf(M, 8218244)
    f1 = f1 + f2
    wfd(8212728, f1)
    f1 = rf(M, 8212772)
    f1 = f1 * rf(M, 8212728)
    f2 = rf(M, 8212592)
    f2 = f2 * rf(M, 8218248)
    f3 = rf(M, 8212596)
    f3 = f3 * rf(M, 8218252)
    f2 = f2 + f3
    f3 = rf(M, 8212600)
    f3 = f3 * rf(M, 8218256)
    f2 = f2 + f3
    wfd(8212732, f2)
    f2 = rf(M, 8212776)
    f2 = f2 * rf(M, 8212732)
    f1 = f1 + f2
    wfd(8212960, f1)
    wfd(8212896, f1)
    wfd(8212808, f1)
    f1 = rf(M, 8212936)
    f1 = f1 * rf(M, 8215560)
    f2 = rf(M, 8212948)
    f2 = f2 * rf(M, 8215572)
    f1 = f1 + f2
    f2 = rf(M, 8212960)
    f2 = f2 * rf(M, 8215584)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8215608)
    f2 = rf(M, 8215632)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8215612)
    wfd(8210516, f2)
    f2 = rf(M, 8212936)
    f2 = f2 * rf(M, 8215564)
    f3 = rf(M, 8212948)
    f3 = f3 * rf(M, 8215576)
    f2 = f2 + f3
    f3 = rf(M, 8212960)
    f3 = f3 * rf(M, 8215588)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8215636)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8215616)
    wfd(8210484, f2)
    f2 = rf(M, 8212936)
    f2 = f2 * rf(M, 8215568)
    f3 = rf(M, 8212948)
    f3 = f3 * rf(M, 8215580)
    f2 = f2 + f3
    f3 = rf(M, 8212960)
    f3 = f3 * rf(M, 8215592)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    wfd(8217068, f1)
    f1 = rf(M, 8215620)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8215596)
    wfd(8210520, f1)
    f1 = rf(M, 8212704)
    f1 = f1 * rf(M, 8215512)
    f2 = rf(M, 8212716)
    f2 = f2 * rf(M, 8215524)
    f1 = f1 + f2
    f2 = rf(M, 8212728)
    f2 = f2 * rf(M, 8215536)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210520)
    f2 = rf(M, 8215624)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8215600)
    wfd(8210308, f2)
    f2 = rf(M, 8212704)
    f2 = f2 * rf(M, 8215516)
    f3 = rf(M, 8212716)
    f3 = f3 * rf(M, 8215528)
    f2 = f2 + f3
    f3 = rf(M, 8212728)
    f3 = f3 * rf(M, 8215540)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210308)
    f1 = f1 + f2
    f2 = rf(M, 8215628)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8215604)
    wfd(8210292, f2)
    f2 = rf(M, 8212704)
    f2 = f2 * rf(M, 8215520)
    f3 = rf(M, 8212716)
    f3 = f3 * rf(M, 8215532)
    f2 = f2 + f3
    f3 = rf(M, 8212728)
    f3 = f3 * rf(M, 8215544)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210292)
    f1 = f1 + f2
    f2 = rf(M, 8214964)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217056, f1)
    f1 = rf(M, 8212708)
    f1 = f1 * rf(M, 8215512)
    f2 = rf(M, 8212720)
    f2 = f2 * rf(M, 8215524)
    f1 = f1 + f2
    f2 = rf(M, 8212732)
    f2 = f2 * rf(M, 8215536)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210520)
    f2 = rf(M, 8212708)
    f2 = f2 * rf(M, 8215516)
    f3 = rf(M, 8212720)
    f3 = f3 * rf(M, 8215528)
    f2 = f2 + f3
    f3 = rf(M, 8212732)
    f3 = f3 * rf(M, 8215540)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210308)
    f1 = f1 + f2
    f2 = rf(M, 8212708)
    f2 = f2 * rf(M, 8215520)
    f3 = rf(M, 8212720)
    f3 = f3 * rf(M, 8215532)
    f2 = f2 + f3
    f3 = rf(M, 8212732)
    f3 = f3 * rf(M, 8215544)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210292)
    f1 = f1 + f2
    f2 = rf(M, 8214968)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217060, f1)
    f1 = rf(M, 8212792)
    f1 = f1 * rf(M, 8215512)
    f2 = rf(M, 8212804)
    f2 = f2 * rf(M, 8215524)
    f1 = f1 + f2
    f2 = rf(M, 8212816)
    f2 = f2 * rf(M, 8215536)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210520)
    f2 = rf(M, 8212792)
    f2 = f2 * rf(M, 8215516)
    f3 = rf(M, 8212804)
    f3 = f3 * rf(M, 8215528)
    f2 = f2 + f3
    f3 = rf(M, 8212816)
    f3 = f3 * rf(M, 8215540)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210308)
    f1 = f1 + f2
    f2 = rf(M, 8212792)
    f2 = f2 * rf(M, 8215520)
    f3 = rf(M, 8212804)
    f3 = f3 * rf(M, 8215532)
    f2 = f2 + f3
    f3 = rf(M, 8212816)
    f3 = f3 * rf(M, 8215544)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210292)
    f1 = f1 + f2
    f2 = rf(M, 8214972)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217064, f1)
    f1 = rf(M, 8212776)
    f1 = -f1
    wfd(8212780, f1)
    f1 = f1 * rf(M, 8212704)
    f2 = rf(M, 8212772)
    f2 = f2 * rf(M, 8212708)
    f1 = f1 + f2
    wfd(8212788, f1)
    f1 = f1 * rf(M, 8215560)
    f2 = rf(M, 8212780)
    f2 = f2 * rf(M, 8212716)
    f3 = rf(M, 8212772)
    f3 = f3 * rf(M, 8212720)
    f2 = f2 + f3
    wfd(8212800, f2)
    f2 = f2 * rf(M, 8215572)
    f1 = f1 + f2
    f2 = rf(M, 8212780)
    f2 = f2 * rf(M, 8212728)
    f3 = rf(M, 8212772)
    f3 = f3 * rf(M, 8212732)
    f2 = f2 + f3
    wfd(8212812, f2)
    f2 = f2 * rf(M, 8215584)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8215608)
    f2 = rf(M, 8212788)
    f2 = f2 * rf(M, 8215564)
    f3 = rf(M, 8212800)
    f3 = f3 * rf(M, 8215576)
    f2 = f2 + f3
    f3 = rf(M, 8212812)
    f3 = f3 * rf(M, 8215588)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8212788)
    f2 = f2 * rf(M, 8215568)
    f3 = rf(M, 8212800)
    f3 = f3 * rf(M, 8215580)
    f2 = f2 + f3
    f3 = rf(M, 8212812)
    f3 = f3 * rf(M, 8215592)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8215020)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217072, f1)
    f1 = rf(M, 8212792)
    f1 = f1 * rf(M, 8215560)
    f2 = rf(M, 8212804)
    f2 = f2 * rf(M, 8215572)
    f1 = f1 + f2
    f2 = rf(M, 8212816)
    f2 = f2 * rf(M, 8215584)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8215608)
    f2 = rf(M, 8212792)
    f2 = f2 * rf(M, 8215564)
    f3 = rf(M, 8212804)
    f3 = f3 * rf(M, 8215576)
    f2 = f2 + f3
    f3 = rf(M, 8212816)
    f3 = f3 * rf(M, 8215588)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8212792)
    f2 = f2 * rf(M, 8215568)
    f3 = rf(M, 8212804)
    f3 = f3 * rf(M, 8215580)
    f2 = f2 + f3
    f3 = rf(M, 8212816)
    f3 = f3 * rf(M, 8215592)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8215024)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217076, f1)
  end
  local function C5()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8212788)
    f1 = f1 * rf(M, 8218276)
    f2 = rf(M, 8212792)
    f2 = f2 * rf(M, 8218280)
    f1 = f1 + f2
    wfd(8212940, f1)
    wfd(8212876, f1)
    f1 = rf(M, 8212788)
    f1 = f1 * rf(M, 8218288)
    f2 = rf(M, 8212792)
    f2 = f2 * rf(M, 8218276)
    f1 = f1 + f2
    wfd(8212944, f1)
    wfd(8212880, f1)
    f1 = rf(M, 8212800)
    f1 = f1 * rf(M, 8218276)
    f2 = rf(M, 8212804)
    f2 = f2 * rf(M, 8218280)
    f1 = f1 + f2
    wfd(8212952, f1)
    wfd(8212888, f1)
    f1 = rf(M, 8212800)
    f1 = f1 * rf(M, 8218288)
    f2 = rf(M, 8212804)
    f2 = f2 * rf(M, 8218276)
    f1 = f1 + f2
    wfd(8212956, f1)
    wfd(8212892, f1)
    f1 = rf(M, 8212812)
    f1 = f1 * rf(M, 8218276)
    f2 = rf(M, 8212816)
    f2 = f2 * rf(M, 8218280)
    f1 = f1 + f2
    wfd(8212964, f1)
    wfd(8212900, f1)
    f1 = rf(M, 8212812)
    f1 = f1 * rf(M, 8218288)
    f2 = rf(M, 8212816)
    f2 = f2 * rf(M, 8218276)
    f1 = f1 + f2
    wfd(8212968, f1)
    wfd(8212904, f1)
    f1 = rf(M, 8212868)
    f1 = f1 + rf(M, 8211908)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8211904)
    f2 = rf(M, 421232)
    f1 = fmod(f1, f2)
    wfd(8204120, f2)
    wfd(8212932, f1)
    f1 = rf(M, 8215740)
    f1 = f1 * rf(M, 8218936)
    wfd(8210484, f1)
    f1 = rf(M, 8212936)
    f1 = f1 * rf(M, 8215652)
    f2 = rf(M, 8212948)
    f2 = f2 * rf(M, 8215664)
    f1 = f1 + f2
    f2 = rf(M, 8212960)
    f2 = f2 * rf(M, 8215676)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210484)
    f2 = rf(M, 8215744)
    f2 = f2 * rf(M, 8218936)
    wfd(8210516, f2)
    f2 = rf(M, 8212936)
    f2 = f2 * rf(M, 8215656)
    f3 = rf(M, 8212948)
    f3 = f3 * rf(M, 8215668)
    f2 = f2 + f3
    f3 = rf(M, 8212960)
    f3 = f3 * rf(M, 8215680)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8215748)
    f2 = f2 * rf(M, 8218936)
    wfd(8210292, f2)
    f2 = rf(M, 8212936)
    f2 = f2 * rf(M, 8215660)
    f3 = rf(M, 8212948)
    f3 = f3 * rf(M, 8215672)
    f2 = f2 + f3
    f3 = rf(M, 8212960)
    f3 = f3 * rf(M, 8215684)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210292)
    f1 = f1 + f2
    f2 = rf(M, 8214820)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217080, f1)
    f1 = rf(M, 8212940)
    f1 = f1 * rf(M, 8215652)
    f2 = rf(M, 8212952)
    f2 = f2 * rf(M, 8215664)
    f1 = f1 + f2
    f2 = rf(M, 8212964)
    f2 = f2 * rf(M, 8215676)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210484)
    f2 = rf(M, 8212940)
    f2 = f2 * rf(M, 8215656)
    f3 = rf(M, 8212952)
    f3 = f3 * rf(M, 8215668)
    f2 = f2 + f3
    f3 = rf(M, 8212964)
    f3 = f3 * rf(M, 8215680)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8212940)
    f2 = f2 * rf(M, 8215660)
    f3 = rf(M, 8212952)
    f3 = f3 * rf(M, 8215672)
    f2 = f2 + f3
    f3 = rf(M, 8212964)
    f3 = f3 * rf(M, 8215684)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210292)
    f1 = f1 + f2
    f2 = rf(M, 8214824)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217084, f1)
    f1 = rf(M, 8212944)
    f1 = f1 * rf(M, 8215652)
    f2 = rf(M, 8212956)
    f2 = f2 * rf(M, 8215664)
    f1 = f1 + f2
    f2 = rf(M, 8212968)
    f2 = f2 * rf(M, 8215676)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210484)
    f2 = rf(M, 8212944)
    f2 = f2 * rf(M, 8215656)
    f3 = rf(M, 8212956)
    f3 = f3 * rf(M, 8215668)
    f2 = f2 + f3
    f3 = rf(M, 8212968)
    f3 = f3 * rf(M, 8215680)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8212944)
    f2 = f2 * rf(M, 8215660)
    f3 = rf(M, 8212956)
    f3 = f3 * rf(M, 8215672)
    f2 = f2 + f3
    f3 = rf(M, 8212968)
    f3 = f3 * rf(M, 8215684)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210292)
    f1 = f1 + f2
    f2 = rf(M, 8214828)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217088, f1)
    f1 = rf(M, 8215752)
    f1 = f1 * rf(M, 8218936)
    wfd(8210292, f1)
    f1 = rf(M, 8212936)
    f1 = f1 * rf(M, 8215700)
    f2 = rf(M, 8212948)
    f2 = f2 * rf(M, 8215712)
    f1 = f1 + f2
    f2 = rf(M, 8212960)
    f2 = f2 * rf(M, 8215724)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210292)
    f2 = rf(M, 8215756)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8215736)
    wfd(8210516, f2)
    f2 = rf(M, 8212936)
    f2 = f2 * rf(M, 8215704)
    f3 = rf(M, 8212948)
    f3 = f3 * rf(M, 8215716)
    f2 = f2 + f3
    f3 = rf(M, 8212960)
    f3 = f3 * rf(M, 8215728)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8215760)
    f2 = f2 * rf(M, 8218936)
    wfd(8210484, f2)
    f2 = rf(M, 8212936)
    f2 = f2 * rf(M, 8215708)
    f3 = rf(M, 8212948)
    f3 = f3 * rf(M, 8215720)
    f2 = f2 + f3
    f3 = rf(M, 8212960)
    f3 = f3 * rf(M, 8215732)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8214832)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217092, f1)
    f1 = rf(M, 8212940)
    f1 = f1 * rf(M, 8215700)
    f2 = rf(M, 8212952)
    f2 = f2 * rf(M, 8215712)
    f1 = f1 + f2
    f2 = rf(M, 8212964)
    f2 = f2 * rf(M, 8215724)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210292)
    f2 = rf(M, 8212940)
    f2 = f2 * rf(M, 8215704)
    f3 = rf(M, 8212952)
    f3 = f3 * rf(M, 8215716)
    f2 = f2 + f3
    f3 = rf(M, 8212964)
    f3 = f3 * rf(M, 8215728)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8212940)
    f2 = f2 * rf(M, 8215708)
    f3 = rf(M, 8212952)
    f3 = f3 * rf(M, 8215720)
    f2 = f2 + f3
    f3 = rf(M, 8212964)
    f3 = f3 * rf(M, 8215732)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8214836)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217096, f1)
    f1 = rf(M, 8212944)
    f1 = f1 * rf(M, 8215700)
    f2 = rf(M, 8212956)
    f2 = f2 * rf(M, 8215712)
    f1 = f1 + f2
    f2 = rf(M, 8212968)
    f2 = f2 * rf(M, 8215724)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210292)
    f2 = rf(M, 8212944)
    f2 = f2 * rf(M, 8215704)
    f3 = rf(M, 8212956)
    f3 = f3 * rf(M, 8215716)
    f2 = f2 + f3
    f3 = rf(M, 8212968)
    f3 = f3 * rf(M, 8215728)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8212944)
    f2 = f2 * rf(M, 8215708)
    f3 = rf(M, 8212956)
    f3 = f3 * rf(M, 8215720)
    f2 = f2 + f3
    f3 = rf(M, 8212968)
    f3 = f3 * rf(M, 8215732)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8214840)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217100, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218188)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218192)
    f1 = f1 + f2
    wfd(8213088, f1)
    wfd(8213028, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218292)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218200)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218296)
    f1 = f1 + f2
    wfd(8213092, f1)
    wfd(8213032, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218208)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218304)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218220)
    f1 = f1 + f2
    wfd(8213096, f1)
    wfd(8213036, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218188)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218192)
    f1 = f1 + f2
    wfd(8213100, f1)
    wfd(8213040, f1)
  end
  local function C6()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218292)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218200)
    f1 = f1 + f2
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218296)
    f1 = f1 + f2
    wfd(8213104, f1)
    wfd(8213044, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218208)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218304)
    f1 = f1 + f2
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218220)
    f1 = f1 + f2
    wfd(8213108, f1)
    wfd(8213048, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218188)
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218192)
    f1 = f1 + f2
    wfd(8213112, f1)
    wfd(8213052, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218292)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218200)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218296)
    f1 = f1 + f2
    wfd(8213116, f1)
    wfd(8213056, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218208)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218304)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218220)
    f1 = f1 + f2
    wfd(8213120, f1)
    wfd(8213060, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218224)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218308)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218316)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214504)
    wfd(8213064, f1)
    f1 = rf(M, 8213020)
    f1 = f1 + rf(M, 8211916)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8211912)
    wfd(8213024, f1)
    f1 = f1 * rf(M, 8213096)
    f1 = f1 + rf(M, 8213064)
    wfd(8213440, f1)
    wfd(8213428, f1)
    wfd(8213272, f1)
    wfd(8213260, f1)
    wfd(8213076, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218224)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218308)
    f1 = f1 + f2
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218316)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214508)
    wfd(8213068, f1)
    f1 = rf(M, 8213024)
    f1 = f1 * rf(M, 8213108)
    f1 = f1 + rf(M, 8213068)
    wfd(8213444, f1)
    wfd(8213432, f1)
    wfd(8213276, f1)
    wfd(8213264, f1)
    wfd(8213080, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218224)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218308)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218316)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214512)
    wfd(8213072, f1)
    f1 = rf(M, 8213024)
    f1 = f1 * rf(M, 8213120)
    f1 = f1 + rf(M, 8213072)
    wfd(8213448, f1)
    wfd(8213436, f1)
    wfd(8213280, f1)
    wfd(8213268, f1)
    wfd(8213084, f1)
    f1 = rf(M, 8215860)
    f1 = f1 * rf(M, 8218936)
    wfd(8210484, f1)
    f1 = rf(M, 8213088)
    f1 = f1 * rf(M, 8215784)
    f2 = rf(M, 8213100)
    f2 = f2 * rf(M, 8215796)
    f1 = f1 + f2
    f2 = rf(M, 8213112)
    f2 = f2 * rf(M, 8215808)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210484)
    wfd(8217108, f1)
    f1 = rf(M, 8213092)
    f1 = f1 * rf(M, 8215784)
    f2 = rf(M, 8213104)
    f2 = f2 * rf(M, 8215796)
    f1 = f1 + f2
    f2 = rf(M, 8213116)
    f2 = f2 * rf(M, 8215808)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210484)
    wfd(8217112, f1)
    f1 = rf(M, 8213096)
    f1 = f1 * rf(M, 8215784)
    f2 = rf(M, 8213108)
    f2 = f2 * rf(M, 8215796)
    f1 = f1 + f2
    f2 = rf(M, 8213120)
    f2 = f2 * rf(M, 8215808)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210484)
    f2 = rf(M, 8215004)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217104, f1)
    f1 = rf(M, 8213088)
    f1 = f1 * rf(M, 8218260)
    f2 = rf(M, 8213092)
    f2 = f2 * rf(M, 8218332)
    f1 = f1 + f2
    f2 = rf(M, 8213096)
    f2 = f2 * rf(M, 8218272)
    f1 = f1 + f2
    wfd(8213312, f1)
    wfd(8213232, f1)
    f1 = rf(M, 8213100)
    f1 = f1 * rf(M, 8218260)
    f2 = rf(M, 8213104)
    f2 = f2 * rf(M, 8218332)
    f1 = f1 + f2
    f2 = rf(M, 8213108)
    f2 = f2 * rf(M, 8218272)
    f1 = f1 + f2
    wfd(8213324, f1)
    wfd(8213244, f1)
    f1 = rf(M, 8213112)
    f1 = f1 * rf(M, 8218260)
    f2 = rf(M, 8213116)
    f2 = f2 * rf(M, 8218332)
    f1 = f1 + f2
    f2 = rf(M, 8213120)
    f2 = f2 * rf(M, 8218272)
    f1 = f1 + f2
    wfd(8213336, f1)
    wfd(8213256, f1)
    f1 = rf(M, 8211780)
    wfd(8213284, f1)
    f1 = cos(f1)
    wfd(8213292, f1)
    wfd(8213288, f1)
    f1 = rf(M, 8213088)
    f1 = f1 * rf(M, 8218240)
    f2 = rf(M, 8213096)
    f2 = f2 * rf(M, 8218244)
    f1 = f1 + f2
    wfd(8213224, f1)
    f1 = rf(M, 8213292)
    f1 = f1 * rf(M, 8213224)
    f2 = rf(M, 8213088)
    f2 = f2 * rf(M, 8218320)
    f3 = rf(M, 8213092)
    f3 = f3 * rf(M, 8218252)
    f2 = f2 + f3
    f3 = rf(M, 8213096)
    f3 = f3 * rf(M, 8218324)
    f2 = f2 + f3
    wfd(8213228, f2)
    f2 = rf(M, 8213284)
    f2 = sin(f2)
    wfd(8213296, f2)
    f2 = f2 * rf(M, 8213228)
    f1 = f1 + f2
    wfd(8213456, f1)
    wfd(8213392, f1)
    wfd(8213304, f1)
    f1 = rf(M, 8213100)
    f1 = f1 * rf(M, 8218240)
    f2 = rf(M, 8213108)
    f2 = f2 * rf(M, 8218244)
    f1 = f1 + f2
    wfd(8213236, f1)
    f1 = rf(M, 8213292)
    f1 = f1 * rf(M, 8213236)
    f2 = rf(M, 8213100)
    f2 = f2 * rf(M, 8218320)
    f3 = rf(M, 8213104)
    f3 = f3 * rf(M, 8218252)
    f2 = f2 + f3
    f3 = rf(M, 8213108)
    f3 = f3 * rf(M, 8218324)
    f2 = f2 + f3
    wfd(8213240, f2)
    f2 = rf(M, 8213296)
    f2 = f2 * rf(M, 8213240)
    f1 = f1 + f2
    wfd(8213468, f1)
    wfd(8213404, f1)
    wfd(8213316, f1)
    f1 = rf(M, 8213112)
    f1 = f1 * rf(M, 8218240)
    f2 = rf(M, 8213120)
    f2 = f2 * rf(M, 8218244)
    f1 = f1 + f2
    wfd(8213248, f1)
    f1 = rf(M, 8213292)
    f1 = f1 * rf(M, 8213248)
    f2 = rf(M, 8213112)
    f2 = f2 * rf(M, 8218320)
    f3 = rf(M, 8213116)
    f3 = f3 * rf(M, 8218252)
    f2 = f2 + f3
    f3 = rf(M, 8213120)
    f3 = f3 * rf(M, 8218324)
    f2 = f2 + f3
    wfd(8213252, f2)
    f2 = rf(M, 8213296)
    f2 = f2 * rf(M, 8213252)
    f1 = f1 + f2
    wfd(8213480, f1)
    wfd(8213416, f1)
    wfd(8213328, f1)
    f1 = rf(M, 8213456)
    f1 = f1 * rf(M, 8215924)
    f2 = rf(M, 8213468)
    f2 = f2 * rf(M, 8215936)
    f1 = f1 + f2
    f2 = rf(M, 8213480)
    f2 = f2 * rf(M, 8215948)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8215972)
    f2 = rf(M, 8215996)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8215976)
    wfd(8210484, f2)
    f2 = rf(M, 8213456)
    f2 = f2 * rf(M, 8215928)
    f3 = rf(M, 8213468)
    f3 = f3 * rf(M, 8215940)
    f2 = f2 + f3
    f3 = rf(M, 8213480)
    f3 = f3 * rf(M, 8215952)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8216000)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8215980)
    wfd(8210516, f2)
    f2 = rf(M, 8213456)
    f2 = f2 * rf(M, 8215932)
    f3 = rf(M, 8213468)
    f3 = f3 * rf(M, 8215944)
    f2 = f2 + f3
    f3 = rf(M, 8213480)
    f3 = f3 * rf(M, 8215956)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    wfd(8217128, f1)
    f1 = rf(M, 8215984)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8215960)
    wfd(8210292, f1)
    f1 = rf(M, 8213224)
    f1 = f1 * rf(M, 8215876)
    f2 = rf(M, 8213236)
    f2 = f2 * rf(M, 8215888)
    f1 = f1 + f2
    f2 = rf(M, 8213248)
    f2 = f2 * rf(M, 8215900)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210292)
    f2 = rf(M, 8215988)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8215964)
    wfd(8210308, f2)
    f2 = rf(M, 8213224)
    f2 = f2 * rf(M, 8215880)
    f3 = rf(M, 8213236)
    f3 = f3 * rf(M, 8215892)
    f2 = f2 + f3
    f3 = rf(M, 8213248)
    f3 = f3 * rf(M, 8215904)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210308)
    f1 = f1 + f2
    f2 = rf(M, 8215992)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8215968)
    wfd(8210520, f2)
    f2 = rf(M, 8213224)
    f2 = f2 * rf(M, 8215884)
    f3 = rf(M, 8213236)
    f3 = f3 * rf(M, 8215896)
    f2 = f2 + f3
    f3 = rf(M, 8213248)
    f3 = f3 * rf(M, 8215908)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210520)
    f1 = f1 + f2
    f2 = rf(M, 8214976)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217116, f1)
  end
  local function C7()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8213228)
    f1 = f1 * rf(M, 8215876)
    f2 = rf(M, 8213240)
    f2 = f2 * rf(M, 8215888)
    f1 = f1 + f2
    f2 = rf(M, 8213252)
    f2 = f2 * rf(M, 8215900)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210292)
    f2 = rf(M, 8213228)
    f2 = f2 * rf(M, 8215880)
    f3 = rf(M, 8213240)
    f3 = f3 * rf(M, 8215892)
    f2 = f2 + f3
    f3 = rf(M, 8213252)
    f3 = f3 * rf(M, 8215904)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210308)
    f1 = f1 + f2
    f2 = rf(M, 8213228)
    f2 = f2 * rf(M, 8215884)
    f3 = rf(M, 8213240)
    f3 = f3 * rf(M, 8215896)
    f2 = f2 + f3
    f3 = rf(M, 8213252)
    f3 = f3 * rf(M, 8215908)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210520)
    f1 = f1 + f2
    f2 = rf(M, 8214980)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217120, f1)
    f1 = rf(M, 8213312)
    f1 = f1 * rf(M, 8215876)
    f2 = rf(M, 8213324)
    f2 = f2 * rf(M, 8215888)
    f1 = f1 + f2
    f2 = rf(M, 8213336)
    f2 = f2 * rf(M, 8215900)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210292)
    f2 = rf(M, 8213312)
    f2 = f2 * rf(M, 8215880)
    f3 = rf(M, 8213324)
    f3 = f3 * rf(M, 8215892)
    f2 = f2 + f3
    f3 = rf(M, 8213336)
    f3 = f3 * rf(M, 8215904)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210308)
    f1 = f1 + f2
    f2 = rf(M, 8213312)
    f2 = f2 * rf(M, 8215884)
    f3 = rf(M, 8213324)
    f3 = f3 * rf(M, 8215896)
    f2 = f2 + f3
    f3 = rf(M, 8213336)
    f3 = f3 * rf(M, 8215908)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210520)
    f1 = f1 + f2
    f2 = rf(M, 8214984)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217124, f1)
    f1 = rf(M, 8213296)
    f1 = -f1
    wfd(8213300, f1)
    f1 = f1 * rf(M, 8213224)
    f2 = rf(M, 8213292)
    f2 = f2 * rf(M, 8213228)
    f1 = f1 + f2
    wfd(8213308, f1)
    f1 = f1 * rf(M, 8215924)
    f2 = rf(M, 8213300)
    f2 = f2 * rf(M, 8213236)
    f3 = rf(M, 8213292)
    f3 = f3 * rf(M, 8213240)
    f2 = f2 + f3
    wfd(8213320, f2)
    f2 = f2 * rf(M, 8215936)
    f1 = f1 + f2
    f2 = rf(M, 8213300)
    f2 = f2 * rf(M, 8213248)
    f3 = rf(M, 8213292)
    f3 = f3 * rf(M, 8213252)
    f2 = f2 + f3
    wfd(8213332, f2)
    f2 = f2 * rf(M, 8215948)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8215972)
    f2 = rf(M, 8213308)
    f2 = f2 * rf(M, 8215928)
    f3 = rf(M, 8213320)
    f3 = f3 * rf(M, 8215940)
    f2 = f2 + f3
    f3 = rf(M, 8213332)
    f3 = f3 * rf(M, 8215952)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8213308)
    f2 = f2 * rf(M, 8215932)
    f3 = rf(M, 8213320)
    f3 = f3 * rf(M, 8215944)
    f2 = f2 + f3
    f3 = rf(M, 8213332)
    f3 = f3 * rf(M, 8215956)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8215028)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217132, f1)
    f1 = rf(M, 8213312)
    f1 = f1 * rf(M, 8215924)
    f2 = rf(M, 8213324)
    f2 = f2 * rf(M, 8215936)
    f1 = f1 + f2
    f2 = rf(M, 8213336)
    f2 = f2 * rf(M, 8215948)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8215972)
    f2 = rf(M, 8213312)
    f2 = f2 * rf(M, 8215928)
    f3 = rf(M, 8213324)
    f3 = f3 * rf(M, 8215940)
    f2 = f2 + f3
    f3 = rf(M, 8213336)
    f3 = f3 * rf(M, 8215952)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8213312)
    f2 = f2 * rf(M, 8215932)
    f3 = rf(M, 8213324)
    f3 = f3 * rf(M, 8215944)
    f2 = f2 + f3
    f3 = rf(M, 8213336)
    f3 = f3 * rf(M, 8215956)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8215032)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217136, f1)
    f1 = rf(M, 8213308)
    f1 = f1 * rf(M, 8218276)
    f2 = rf(M, 8213312)
    f2 = f2 * rf(M, 8218336)
    f1 = f1 + f2
    wfd(8213460, f1)
    wfd(8213396, f1)
    f1 = rf(M, 8213308)
    f1 = f1 * rf(M, 8218344)
    f2 = rf(M, 8213312)
    f2 = f2 * rf(M, 8218276)
    f1 = f1 + f2
    wfd(8213464, f1)
    wfd(8213400, f1)
    f1 = rf(M, 8213320)
    f1 = f1 * rf(M, 8218276)
    f2 = rf(M, 8213324)
    f2 = f2 * rf(M, 8218336)
    f1 = f1 + f2
    wfd(8213472, f1)
    wfd(8213408, f1)
    f1 = rf(M, 8213320)
    f1 = f1 * rf(M, 8218344)
    f2 = rf(M, 8213324)
    f2 = f2 * rf(M, 8218276)
    f1 = f1 + f2
    wfd(8213476, f1)
    wfd(8213412, f1)
    f1 = rf(M, 8213332)
    f1 = f1 * rf(M, 8218276)
    f2 = rf(M, 8213336)
    f2 = f2 * rf(M, 8218336)
    f1 = f1 + f2
    wfd(8213484, f1)
    wfd(8213420, f1)
    f1 = rf(M, 8213332)
    f1 = f1 * rf(M, 8218344)
    f2 = rf(M, 8213336)
    f2 = f2 * rf(M, 8218276)
    f1 = f1 + f2
    wfd(8213488, f1)
    wfd(8213424, f1)
    f1 = rf(M, 8213388)
    f1 = f1 + rf(M, 8211932)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8211928)
    f2 = rf(M, 421232)
    f1 = fmod(f1, f2)
    wfd(8204120, f2)
    wfd(8213452, f1)
    f1 = rf(M, 8216104)
    f1 = f1 * rf(M, 8218936)
    wfd(8210516, f1)
    f1 = rf(M, 8213456)
    f1 = f1 * rf(M, 8216016)
    f2 = rf(M, 8213468)
    f2 = f2 * rf(M, 8216028)
    f1 = f1 + f2
    f2 = rf(M, 8213480)
    f2 = f2 * rf(M, 8216040)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210516)
    f2 = rf(M, 8216108)
    f2 = f2 * rf(M, 8218936)
    wfd(8210484, f2)
    f2 = rf(M, 8213456)
    f2 = f2 * rf(M, 8216020)
    f3 = rf(M, 8213468)
    f3 = f3 * rf(M, 8216032)
    f2 = f2 + f3
    f3 = rf(M, 8213480)
    f3 = f3 * rf(M, 8216044)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8216112)
    f2 = f2 * rf(M, 8218936)
    wfd(8210520, f2)
    f2 = rf(M, 8213456)
    f2 = f2 * rf(M, 8216024)
    f3 = rf(M, 8213468)
    f3 = f3 * rf(M, 8216036)
    f2 = f2 + f3
    f3 = rf(M, 8213480)
    f3 = f3 * rf(M, 8216048)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210520)
    f1 = f1 + f2
    f2 = rf(M, 8214844)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217140, f1)
    f1 = rf(M, 8213460)
    f1 = f1 * rf(M, 8216016)
    f2 = rf(M, 8213472)
    f2 = f2 * rf(M, 8216028)
    f1 = f1 + f2
    f2 = rf(M, 8213484)
    f2 = f2 * rf(M, 8216040)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210516)
    f2 = rf(M, 8213460)
    f2 = f2 * rf(M, 8216020)
    f3 = rf(M, 8213472)
    f3 = f3 * rf(M, 8216032)
    f2 = f2 + f3
    f3 = rf(M, 8213484)
    f3 = f3 * rf(M, 8216044)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8213460)
    f2 = f2 * rf(M, 8216024)
    f3 = rf(M, 8213472)
    f3 = f3 * rf(M, 8216036)
    f2 = f2 + f3
    f3 = rf(M, 8213484)
    f3 = f3 * rf(M, 8216048)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210520)
    f1 = f1 + f2
    f2 = rf(M, 8214848)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217144, f1)
    f1 = rf(M, 8213464)
    f1 = f1 * rf(M, 8216016)
    f2 = rf(M, 8213476)
    f2 = f2 * rf(M, 8216028)
    f1 = f1 + f2
    f2 = rf(M, 8213488)
    f2 = f2 * rf(M, 8216040)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210516)
    f2 = rf(M, 8213464)
    f2 = f2 * rf(M, 8216020)
    f3 = rf(M, 8213476)
    f3 = f3 * rf(M, 8216032)
    f2 = f2 + f3
    f3 = rf(M, 8213488)
    f3 = f3 * rf(M, 8216044)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8213464)
    f2 = f2 * rf(M, 8216024)
    f3 = rf(M, 8213476)
    f3 = f3 * rf(M, 8216036)
    f2 = f2 + f3
    f3 = rf(M, 8213488)
    f3 = f3 * rf(M, 8216048)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210520)
    f1 = f1 + f2
    f2 = rf(M, 8214852)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217148, f1)
  end
  local function C8()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8216116)
    f1 = f1 * rf(M, 8218936)
    wfd(8210520, f1)
    f1 = rf(M, 8213456)
    f1 = f1 * rf(M, 8216064)
    f2 = rf(M, 8213468)
    f2 = f2 * rf(M, 8216076)
    f1 = f1 + f2
    f2 = rf(M, 8213480)
    f2 = f2 * rf(M, 8216088)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210520)
    f2 = rf(M, 8216120)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8216100)
    wfd(8210484, f2)
    f2 = rf(M, 8213456)
    f2 = f2 * rf(M, 8216068)
    f3 = rf(M, 8213468)
    f3 = f3 * rf(M, 8216080)
    f2 = f2 + f3
    f3 = rf(M, 8213480)
    f3 = f3 * rf(M, 8216092)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8216124)
    f2 = f2 * rf(M, 8218936)
    wfd(8210516, f2)
    f2 = rf(M, 8213456)
    f2 = f2 * rf(M, 8216072)
    f3 = rf(M, 8213468)
    f3 = f3 * rf(M, 8216084)
    f2 = f2 + f3
    f3 = rf(M, 8213480)
    f3 = f3 * rf(M, 8216096)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8214856)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217152, f1)
    f1 = rf(M, 8213460)
    f1 = f1 * rf(M, 8216064)
    f2 = rf(M, 8213472)
    f2 = f2 * rf(M, 8216076)
    f1 = f1 + f2
    f2 = rf(M, 8213484)
    f2 = f2 * rf(M, 8216088)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210520)
    f2 = rf(M, 8213460)
    f2 = f2 * rf(M, 8216068)
    f3 = rf(M, 8213472)
    f3 = f3 * rf(M, 8216080)
    f2 = f2 + f3
    f3 = rf(M, 8213484)
    f3 = f3 * rf(M, 8216092)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8213460)
    f2 = f2 * rf(M, 8216072)
    f3 = rf(M, 8213472)
    f3 = f3 * rf(M, 8216084)
    f2 = f2 + f3
    f3 = rf(M, 8213484)
    f3 = f3 * rf(M, 8216096)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8214860)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217156, f1)
    f1 = rf(M, 8213464)
    f1 = f1 * rf(M, 8216064)
    f2 = rf(M, 8213476)
    f2 = f2 * rf(M, 8216076)
    f1 = f1 + f2
    f2 = rf(M, 8213488)
    f2 = f2 * rf(M, 8216088)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210520)
    f2 = rf(M, 8213464)
    f2 = f2 * rf(M, 8216068)
    f3 = rf(M, 8213476)
    f3 = f3 * rf(M, 8216080)
    f2 = f2 + f3
    f3 = rf(M, 8213488)
    f3 = f3 * rf(M, 8216092)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8213464)
    f2 = f2 * rf(M, 8216072)
    f3 = rf(M, 8213476)
    f3 = f3 * rf(M, 8216084)
    f2 = f2 + f3
    f3 = rf(M, 8213488)
    f3 = f3 * rf(M, 8216096)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8214864)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217160, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218348)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218352)
    f1 = f1 + f2
    wfd(8213632, f1)
    wfd(8213552, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218364)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218372)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218348)
    f1 = f1 + f2
    wfd(8213560, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218348)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218352)
    f1 = f1 + f2
    wfd(8213644, f1)
    wfd(8213564, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218364)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218372)
    f1 = f1 + f2
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218348)
    f1 = f1 + f2
    wfd(8213572, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218348)
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218352)
    f1 = f1 + f2
    wfd(8213656, f1)
    wfd(8213576, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218364)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218372)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218348)
    f1 = f1 + f2
    wfd(8213584, f1)
    f1 = rf(M, 8213544)
    f1 = f1 + rf(M, 8211952)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8211948)
    f2 = rf(M, 421232)
    f1 = fmod(f1, f2)
    wfd(8204120, f2)
    wfd(8213612, f1)
    f1 = cos(f1)
    wfd(8213620, f1)
    wfd(8213616, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218356)
    f1 = f1 + rf(M, 8214704)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218360)
    f1 = f1 + f2
    wfd(8213556, f1)
    f1 = rf(M, 8213620)
    f1 = f1 * rf(M, 8213556)
    f2 = rf(M, 8213612)
    f2 = sin(f2)
    wfd(8213624, f2)
    f2 = f2 * rf(M, 8213560)
    f1 = f1 + f2
    wfd(8213636, f1)
    f1 = rf(M, 8213624)
    f1 = -f1
    wfd(8213628, f1)
    f1 = f1 * rf(M, 8213556)
    f2 = rf(M, 8213620)
    f2 = f2 * rf(M, 8213560)
    f1 = f1 + f2
    wfd(8214032, f1)
    wfd(8213968, f1)
    wfd(8213864, f1)
    wfd(8213800, f1)
    wfd(8213640, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218356)
    f1 = f1 + rf(M, 8214716)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218360)
    f1 = f1 + f2
    wfd(8213568, f1)
    f1 = rf(M, 8213620)
    f1 = f1 * rf(M, 8213568)
    f2 = rf(M, 8213624)
    f2 = f2 * rf(M, 8213572)
    f1 = f1 + f2
    wfd(8213648, f1)
    f1 = rf(M, 8213628)
    f1 = f1 * rf(M, 8213568)
    f2 = rf(M, 8213620)
    f2 = f2 * rf(M, 8213572)
    f1 = f1 + f2
    wfd(8214044, f1)
    wfd(8213980, f1)
    wfd(8213876, f1)
    wfd(8213812, f1)
    wfd(8213652, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218356)
    f1 = f1 + rf(M, 8214728)
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218360)
    f1 = f1 + f2
    wfd(8213580, f1)
    f1 = rf(M, 8213620)
    f1 = f1 * rf(M, 8213580)
    f2 = rf(M, 8213624)
    f2 = f2 * rf(M, 8213584)
    f1 = f1 + f2
    wfd(8213660, f1)
    f1 = rf(M, 8213628)
    f1 = f1 * rf(M, 8213580)
    f2 = rf(M, 8213620)
    f2 = f2 * rf(M, 8213584)
    f1 = f1 + f2
    wfd(8214056, f1)
    wfd(8213992, f1)
    wfd(8213888, f1)
    wfd(8213824, f1)
    wfd(8213664, f1)
    f1 = rf(M, 8216260)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8216236)
    wfd(8210516, f1)
    f1 = rf(M, 8214032)
    f1 = f1 * rf(M, 8216188)
    f2 = rf(M, 8214044)
    f2 = f2 * rf(M, 8216200)
    f1 = f1 + f2
    f2 = rf(M, 8214056)
    f2 = f2 * rf(M, 8216212)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210516)
    f2 = rf(M, 8216264)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8216240)
    wfd(8210484, f2)
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8216192)
    f3 = rf(M, 8214044)
    f3 = f3 * rf(M, 8216204)
    f2 = f2 + f3
    f3 = rf(M, 8214056)
    f3 = f3 * rf(M, 8216216)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8216196)
    f3 = rf(M, 8214044)
    f3 = f3 * rf(M, 8216208)
    f2 = f2 + f3
    f3 = rf(M, 8214056)
    f3 = f3 * rf(M, 8216220)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8216244)
    f1 = f1 + f2
    wfd(8217184, f1)
    f1 = rf(M, 8216248)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8216224)
    wfd(8210520, f1)
    f1 = rf(M, 8213632)
    f1 = f1 * rf(M, 8216140)
    f2 = rf(M, 8213644)
    f2 = f2 * rf(M, 8216152)
    f1 = f1 + f2
    f2 = rf(M, 8213656)
    f2 = f2 * rf(M, 8216164)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210520)
    f2 = rf(M, 8216252)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8216228)
    wfd(8210308, f2)
    f2 = rf(M, 8213632)
    f2 = f2 * rf(M, 8216144)
    f3 = rf(M, 8213644)
    f3 = f3 * rf(M, 8216156)
    f2 = f2 + f3
    f3 = rf(M, 8213656)
    f3 = f3 * rf(M, 8216168)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210308)
    f1 = f1 + f2
    f2 = rf(M, 8216256)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8216232)
    wfd(8210292, f2)
    f2 = rf(M, 8213632)
    f2 = f2 * rf(M, 8216148)
    f3 = rf(M, 8213644)
    f3 = f3 * rf(M, 8216160)
    f2 = f2 + f3
    f3 = rf(M, 8213656)
    f3 = f3 * rf(M, 8216172)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210292)
    f1 = f1 + f2
    f2 = rf(M, 8214988)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217164, f1)
  end
  local function C9()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8213556)
    f1 = f1 * rf(M, 8216140)
    f2 = rf(M, 8213568)
    f2 = f2 * rf(M, 8216152)
    f1 = f1 + f2
    f2 = rf(M, 8213580)
    f2 = f2 * rf(M, 8216164)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210520)
    f2 = rf(M, 8213556)
    f2 = f2 * rf(M, 8216144)
    f3 = rf(M, 8213568)
    f3 = f3 * rf(M, 8216156)
    f2 = f2 + f3
    f3 = rf(M, 8213580)
    f3 = f3 * rf(M, 8216168)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210308)
    f1 = f1 + f2
    f2 = rf(M, 8213556)
    f2 = f2 * rf(M, 8216148)
    f3 = rf(M, 8213568)
    f3 = f3 * rf(M, 8216160)
    f2 = f2 + f3
    f3 = rf(M, 8213580)
    f3 = f3 * rf(M, 8216172)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210292)
    f1 = f1 + f2
    f2 = rf(M, 8214992)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217168, f1)
    f1 = rf(M, 8213560)
    f1 = f1 * rf(M, 8216140)
    f2 = rf(M, 8213572)
    f2 = f2 * rf(M, 8216152)
    f1 = f1 + f2
    f2 = rf(M, 8213584)
    f2 = f2 * rf(M, 8216164)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210520)
    f2 = rf(M, 8213560)
    f2 = f2 * rf(M, 8216144)
    f3 = rf(M, 8213572)
    f3 = f3 * rf(M, 8216156)
    f2 = f2 + f3
    f3 = rf(M, 8213584)
    f3 = f3 * rf(M, 8216168)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210308)
    f1 = f1 + f2
    f2 = rf(M, 8213560)
    f2 = f2 * rf(M, 8216148)
    f3 = rf(M, 8213572)
    f3 = f3 * rf(M, 8216160)
    f2 = f2 + f3
    f3 = rf(M, 8213584)
    f3 = f3 * rf(M, 8216172)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210292)
    f1 = f1 + f2
    f2 = rf(M, 8214996)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217172, f1)
    f1 = rf(M, 8213632)
    f1 = f1 * rf(M, 8216188)
    f2 = rf(M, 8213644)
    f2 = f2 * rf(M, 8216200)
    f1 = f1 + f2
    f2 = rf(M, 8213656)
    f2 = f2 * rf(M, 8216212)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210516)
    f2 = rf(M, 8213632)
    f2 = f2 * rf(M, 8216192)
    f3 = rf(M, 8213644)
    f3 = f3 * rf(M, 8216204)
    f2 = f2 + f3
    f3 = rf(M, 8213656)
    f3 = f3 * rf(M, 8216216)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8213632)
    f2 = f2 * rf(M, 8216196)
    f3 = rf(M, 8213644)
    f3 = f3 * rf(M, 8216208)
    f2 = f2 + f3
    f3 = rf(M, 8213656)
    f3 = f3 * rf(M, 8216220)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8216244)
    f1 = f1 + f2
    f2 = rf(M, 8215008)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217176, f1)
    f1 = rf(M, 8213636)
    f1 = f1 * rf(M, 8216188)
    f2 = rf(M, 8213648)
    f2 = f2 * rf(M, 8216200)
    f1 = f1 + f2
    f2 = rf(M, 8213660)
    f2 = f2 * rf(M, 8216212)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210516)
    f2 = rf(M, 8213636)
    f2 = f2 * rf(M, 8216192)
    f3 = rf(M, 8213648)
    f3 = f3 * rf(M, 8216204)
    f2 = f2 + f3
    f3 = rf(M, 8213660)
    f3 = f3 * rf(M, 8216216)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8213636)
    f2 = f2 * rf(M, 8216196)
    f3 = rf(M, 8213648)
    f3 = f3 * rf(M, 8216208)
    f2 = f2 + f3
    f3 = rf(M, 8213660)
    f3 = f3 * rf(M, 8216220)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8216244)
    f1 = f1 + f2
    f2 = rf(M, 8215036)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217180, f1)
    f1 = rf(M, 8213632)
    f1 = f1 * rf(M, 8218384)
    f2 = rf(M, 8213636)
    f2 = f2 * rf(M, 8218388)
    f1 = f1 + f2
    wfd(8213856, f1)
    wfd(8213792, f1)
    f1 = rf(M, 8213632)
    f1 = f1 * rf(M, 8218396)
    f2 = rf(M, 8213636)
    f2 = f2 * rf(M, 8218384)
    f1 = f1 + f2
    wfd(8213860, f1)
    wfd(8213796, f1)
    f1 = rf(M, 8213644)
    f1 = f1 * rf(M, 8218384)
    f2 = rf(M, 8213648)
    f2 = f2 * rf(M, 8218388)
    f1 = f1 + f2
    wfd(8213868, f1)
    wfd(8213804, f1)
    f1 = rf(M, 8213644)
    f1 = f1 * rf(M, 8218396)
    f2 = rf(M, 8213648)
    f2 = f2 * rf(M, 8218384)
    f1 = f1 + f2
    wfd(8213872, f1)
    wfd(8213808, f1)
    f1 = rf(M, 8213656)
    f1 = f1 * rf(M, 8218384)
    f2 = rf(M, 8213660)
    f2 = f2 * rf(M, 8218388)
    f1 = f1 + f2
    wfd(8213880, f1)
    wfd(8213816, f1)
    f1 = rf(M, 8213656)
    f1 = f1 * rf(M, 8218396)
    f2 = rf(M, 8213660)
    f2 = f2 * rf(M, 8218384)
    f1 = f1 + f2
    wfd(8213884, f1)
    wfd(8213820, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218380)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8211936)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214504)
    wfd(8213588, f1)
    f1 = rf(M, 8213540)
    f1 = f1 + rf(M, 8211944)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8211940)
    wfd(8213548, f1)
    f1 = f1 * rf(M, 8213560)
    f1 = f1 + rf(M, 8213588)
    wfd(8213600, f1)
    f1 = rf(M, 8213636)
    f1 = f1 * rf(M, 8218228)
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8211956)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8213600)
    wfd(8213840, f1)
    wfd(8213828, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218380)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8211936)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214508)
    wfd(8213592, f1)
    f1 = rf(M, 8213548)
    f1 = f1 * rf(M, 8213572)
    f1 = f1 + rf(M, 8213592)
    wfd(8213604, f1)
    f1 = rf(M, 8213648)
    f1 = f1 * rf(M, 8218228)
    f2 = rf(M, 8214044)
    f2 = f2 * rf(M, 8211956)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8213604)
    wfd(8213844, f1)
    wfd(8213832, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218380)
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8211936)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214512)
    wfd(8213596, f1)
    f1 = rf(M, 8213548)
    f1 = f1 * rf(M, 8213584)
    f1 = f1 + rf(M, 8213596)
    wfd(8213608, f1)
    f1 = rf(M, 8213660)
    f1 = f1 * rf(M, 8218228)
    f2 = rf(M, 8214056)
    f2 = f2 * rf(M, 8211956)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8213608)
    wfd(8213848, f1)
    wfd(8213836, f1)
    f1 = rf(M, 8213788)
    f1 = f1 + rf(M, 8211964)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8211960)
    f2 = rf(M, 421232)
    f1 = fmod(f1, f2)
    wfd(8204120, f2)
    wfd(8213852, f1)
    f1 = rf(M, 8216388)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8216364)
    wfd(8210484, f1)
    f1 = rf(M, 8213856)
    f1 = f1 * rf(M, 8216280)
    f2 = rf(M, 8213868)
    f2 = f2 * rf(M, 8216292)
    f1 = f1 + f2
    f2 = rf(M, 8213880)
    f2 = f2 * rf(M, 8216304)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210484)
    f2 = rf(M, 8216392)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8216368)
    wfd(8210516, f2)
    f2 = rf(M, 8213856)
    f2 = f2 * rf(M, 8216284)
    f3 = rf(M, 8213868)
    f3 = f3 * rf(M, 8216296)
    f2 = f2 + f3
    f3 = rf(M, 8213880)
    f3 = f3 * rf(M, 8216308)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8216396)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8216372)
    wfd(8210292, f2)
    f2 = rf(M, 8213856)
    f2 = f2 * rf(M, 8216288)
    f3 = rf(M, 8213868)
    f3 = f3 * rf(M, 8216300)
    f2 = f2 + f3
    f3 = rf(M, 8213880)
    f3 = f3 * rf(M, 8216312)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210292)
    f1 = f1 + f2
    f2 = rf(M, 8214868)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217188, f1)
    f1 = rf(M, 8213860)
    f1 = f1 * rf(M, 8216280)
    f2 = rf(M, 8213872)
    f2 = f2 * rf(M, 8216292)
    f1 = f1 + f2
    f2 = rf(M, 8213884)
    f2 = f2 * rf(M, 8216304)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210484)
    f2 = rf(M, 8213860)
    f2 = f2 * rf(M, 8216284)
    f3 = rf(M, 8213872)
    f3 = f3 * rf(M, 8216296)
    f2 = f2 + f3
    f3 = rf(M, 8213884)
    f3 = f3 * rf(M, 8216308)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8213860)
    f2 = f2 * rf(M, 8216288)
    f3 = rf(M, 8213872)
    f3 = f3 * rf(M, 8216300)
    f2 = f2 + f3
    f3 = rf(M, 8213884)
    f3 = f3 * rf(M, 8216312)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210292)
    f1 = f1 + f2
    f2 = rf(M, 8214872)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217192, f1)
  end
  local function C10()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8214032)
    f1 = f1 * rf(M, 8216280)
    f2 = rf(M, 8214044)
    f2 = f2 * rf(M, 8216292)
    f1 = f1 + f2
    f2 = rf(M, 8214056)
    f2 = f2 * rf(M, 8216304)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210484)
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8216284)
    f3 = rf(M, 8214044)
    f3 = f3 * rf(M, 8216296)
    f2 = f2 + f3
    f3 = rf(M, 8214056)
    f3 = f3 * rf(M, 8216308)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8216288)
    f3 = rf(M, 8214044)
    f3 = f3 * rf(M, 8216300)
    f2 = f2 + f3
    f3 = rf(M, 8214056)
    f3 = f3 * rf(M, 8216312)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210292)
    f1 = f1 + f2
    f2 = rf(M, 8214876)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217196, f1)
    f1 = rf(M, 8216400)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8216376)
    wfd(8210292, f1)
    f1 = rf(M, 8213856)
    f1 = f1 * rf(M, 8216328)
    f2 = rf(M, 8213868)
    f2 = f2 * rf(M, 8216340)
    f1 = f1 + f2
    f2 = rf(M, 8213880)
    f2 = f2 * rf(M, 8216352)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210292)
    f2 = rf(M, 8216404)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8216380)
    wfd(8210516, f2)
    f2 = rf(M, 8213856)
    f2 = f2 * rf(M, 8216332)
    f3 = rf(M, 8213868)
    f3 = f3 * rf(M, 8216344)
    f2 = f2 + f3
    f3 = rf(M, 8213880)
    f3 = f3 * rf(M, 8216356)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8216408)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8216384)
    wfd(8210484, f2)
    f2 = rf(M, 8213856)
    f2 = f2 * rf(M, 8216336)
    f3 = rf(M, 8213868)
    f3 = f3 * rf(M, 8216348)
    f2 = f2 + f3
    f3 = rf(M, 8213880)
    f3 = f3 * rf(M, 8216360)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8214880)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217200, f1)
    f1 = rf(M, 8213860)
    f1 = f1 * rf(M, 8216328)
    f2 = rf(M, 8213872)
    f2 = f2 * rf(M, 8216340)
    f1 = f1 + f2
    f2 = rf(M, 8213884)
    f2 = f2 * rf(M, 8216352)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210292)
    f2 = rf(M, 8213860)
    f2 = f2 * rf(M, 8216332)
    f3 = rf(M, 8213872)
    f3 = f3 * rf(M, 8216344)
    f2 = f2 + f3
    f3 = rf(M, 8213884)
    f3 = f3 * rf(M, 8216356)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8213860)
    f2 = f2 * rf(M, 8216336)
    f3 = rf(M, 8213872)
    f3 = f3 * rf(M, 8216348)
    f2 = f2 + f3
    f3 = rf(M, 8213884)
    f3 = f3 * rf(M, 8216360)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8214884)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217204, f1)
    f1 = rf(M, 8214032)
    f1 = f1 * rf(M, 8216328)
    f2 = rf(M, 8214044)
    f2 = f2 * rf(M, 8216340)
    f1 = f1 + f2
    f2 = rf(M, 8214056)
    f2 = f2 * rf(M, 8216352)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210292)
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8216332)
    f3 = rf(M, 8214044)
    f3 = f3 * rf(M, 8216344)
    f2 = f2 + f3
    f3 = rf(M, 8214056)
    f3 = f3 * rf(M, 8216356)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8216336)
    f3 = rf(M, 8214044)
    f3 = f3 * rf(M, 8216348)
    f2 = f2 + f3
    f3 = rf(M, 8214056)
    f3 = f3 * rf(M, 8216360)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8214888)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217208, f1)
    f1 = rf(M, 8213632)
    f1 = f1 * rf(M, 8218384)
    f2 = rf(M, 8213636)
    f2 = f2 * rf(M, 8218400)
    f1 = f1 + f2
    wfd(8214024, f1)
    wfd(8213960, f1)
    f1 = rf(M, 8213632)
    f1 = f1 * rf(M, 8218408)
    f2 = rf(M, 8213636)
    f2 = f2 * rf(M, 8218384)
    f1 = f1 + f2
    wfd(8214028, f1)
    wfd(8213964, f1)
    f1 = rf(M, 8213644)
    f1 = f1 * rf(M, 8218384)
    f2 = rf(M, 8213648)
    f2 = f2 * rf(M, 8218400)
    f1 = f1 + f2
    wfd(8214036, f1)
    wfd(8213972, f1)
    f1 = rf(M, 8213644)
    f1 = f1 * rf(M, 8218408)
    f2 = rf(M, 8213648)
    f2 = f2 * rf(M, 8218384)
    f1 = f1 + f2
    wfd(8214040, f1)
    wfd(8213976, f1)
    f1 = rf(M, 8213656)
    f1 = f1 * rf(M, 8218384)
    f2 = rf(M, 8213660)
    f2 = f2 * rf(M, 8218400)
    f1 = f1 + f2
    wfd(8214048, f1)
    wfd(8213984, f1)
    f1 = rf(M, 8213656)
    f1 = f1 * rf(M, 8218408)
    f2 = rf(M, 8213660)
    f2 = f2 * rf(M, 8218384)
    f1 = f1 + f2
    wfd(8214052, f1)
    wfd(8213988, f1)
    f1 = rf(M, 8213636)
    f1 = f1 * rf(M, 8218308)
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8211968)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8213600)
    wfd(8214008, f1)
    wfd(8213996, f1)
    f1 = rf(M, 8213648)
    f1 = f1 * rf(M, 8218308)
    f2 = rf(M, 8214044)
    f2 = f2 * rf(M, 8211968)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8213604)
    wfd(8214012, f1)
    wfd(8214000, f1)
    f1 = rf(M, 8213660)
    f1 = f1 * rf(M, 8218308)
    f2 = rf(M, 8214056)
    f2 = f2 * rf(M, 8211968)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8213608)
    wfd(8214016, f1)
    wfd(8214004, f1)
    f1 = rf(M, 8213956)
    f1 = f1 + rf(M, 8211976)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8211972)
    f2 = rf(M, 421232)
    f1 = fmod(f1, f2)
    wfd(8204120, f2)
    wfd(8214020, f1)
    f1 = rf(M, 8216532)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8216508)
    wfd(8210484, f1)
    f1 = rf(M, 8214024)
    f1 = f1 * rf(M, 8216424)
    f2 = rf(M, 8214036)
    f2 = f2 * rf(M, 8216436)
    f1 = f1 + f2
    f2 = rf(M, 8214048)
    f2 = f2 * rf(M, 8216448)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210484)
    f2 = rf(M, 8216536)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8216512)
    wfd(8210516, f2)
    f2 = rf(M, 8214024)
    f2 = f2 * rf(M, 8216428)
    f3 = rf(M, 8214036)
    f3 = f3 * rf(M, 8216440)
    f2 = f2 + f3
    f3 = rf(M, 8214048)
    f3 = f3 * rf(M, 8216452)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8216540)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8216516)
    wfd(8210292, f2)
    f2 = rf(M, 8214024)
    f2 = f2 * rf(M, 8216432)
    f3 = rf(M, 8214036)
    f3 = f3 * rf(M, 8216444)
    f2 = f2 + f3
    f3 = rf(M, 8214048)
    f3 = f3 * rf(M, 8216456)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210292)
    f1 = f1 + f2
    f2 = rf(M, 8214892)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217212, f1)
    f1 = rf(M, 8214028)
    f1 = f1 * rf(M, 8216424)
    f2 = rf(M, 8214040)
    f2 = f2 * rf(M, 8216436)
    f1 = f1 + f2
    f2 = rf(M, 8214052)
    f2 = f2 * rf(M, 8216448)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210484)
    f2 = rf(M, 8214028)
    f2 = f2 * rf(M, 8216428)
    f3 = rf(M, 8214040)
    f3 = f3 * rf(M, 8216440)
    f2 = f2 + f3
    f3 = rf(M, 8214052)
    f3 = f3 * rf(M, 8216452)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8214028)
    f2 = f2 * rf(M, 8216432)
    f3 = rf(M, 8214040)
    f3 = f3 * rf(M, 8216444)
    f2 = f2 + f3
    f3 = rf(M, 8214052)
    f3 = f3 * rf(M, 8216456)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210292)
    f1 = f1 + f2
    f2 = rf(M, 8214896)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217216, f1)
    f1 = rf(M, 8214032)
    f1 = f1 * rf(M, 8216424)
    f2 = rf(M, 8214044)
    f2 = f2 * rf(M, 8216436)
    f1 = f1 + f2
    f2 = rf(M, 8214056)
    f2 = f2 * rf(M, 8216448)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210484)
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8216428)
    f3 = rf(M, 8214044)
    f3 = f3 * rf(M, 8216440)
    f2 = f2 + f3
    f3 = rf(M, 8214056)
    f3 = f3 * rf(M, 8216452)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8216432)
    f3 = rf(M, 8214044)
    f3 = f3 * rf(M, 8216444)
    f2 = f2 + f3
    f3 = rf(M, 8214056)
    f3 = f3 * rf(M, 8216456)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210292)
    f1 = f1 + f2
    f2 = rf(M, 8214900)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217220, f1)
  end
  local function C11()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8216544)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8216520)
    wfd(8210292, f1)
    f1 = rf(M, 8214024)
    f1 = f1 * rf(M, 8216472)
    f2 = rf(M, 8214036)
    f2 = f2 * rf(M, 8216484)
    f1 = f1 + f2
    f2 = rf(M, 8214048)
    f2 = f2 * rf(M, 8216496)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210292)
    f2 = rf(M, 8216548)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8216524)
    wfd(8210516, f2)
    f2 = rf(M, 8214024)
    f2 = f2 * rf(M, 8216476)
    f3 = rf(M, 8214036)
    f3 = f3 * rf(M, 8216488)
    f2 = f2 + f3
    f3 = rf(M, 8214048)
    f3 = f3 * rf(M, 8216500)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8216552)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8216528)
    wfd(8210484, f2)
    f2 = rf(M, 8214024)
    f2 = f2 * rf(M, 8216480)
    f3 = rf(M, 8214036)
    f3 = f3 * rf(M, 8216492)
    f2 = f2 + f3
    f3 = rf(M, 8214048)
    f3 = f3 * rf(M, 8216504)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8214904)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217224, f1)
    f1 = rf(M, 8214028)
    f1 = f1 * rf(M, 8216472)
    f2 = rf(M, 8214040)
    f2 = f2 * rf(M, 8216484)
    f1 = f1 + f2
    f2 = rf(M, 8214052)
    f2 = f2 * rf(M, 8216496)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210292)
    f2 = rf(M, 8214028)
    f2 = f2 * rf(M, 8216476)
    f3 = rf(M, 8214040)
    f3 = f3 * rf(M, 8216488)
    f2 = f2 + f3
    f3 = rf(M, 8214052)
    f3 = f3 * rf(M, 8216500)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8214028)
    f2 = f2 * rf(M, 8216480)
    f3 = rf(M, 8214040)
    f3 = f3 * rf(M, 8216492)
    f2 = f2 + f3
    f3 = rf(M, 8214052)
    f3 = f3 * rf(M, 8216504)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8214908)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217228, f1)
    f1 = rf(M, 8214032)
    f1 = f1 * rf(M, 8216472)
    f2 = rf(M, 8214044)
    f2 = f2 * rf(M, 8216484)
    f1 = f1 + f2
    f2 = rf(M, 8214056)
    f2 = f2 * rf(M, 8216496)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210292)
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8216476)
    f3 = rf(M, 8214044)
    f3 = f3 * rf(M, 8216488)
    f2 = f2 + f3
    f3 = rf(M, 8214056)
    f3 = f3 * rf(M, 8216500)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8214032)
    f2 = f2 * rf(M, 8216480)
    f3 = rf(M, 8214044)
    f3 = f3 * rf(M, 8216492)
    f2 = f2 + f3
    f3 = rf(M, 8214056)
    f3 = f3 * rf(M, 8216504)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210484)
    f1 = f1 + f2
    f2 = rf(M, 8214912)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217232, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218412)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218416)
    f1 = f1 + f2
    wfd(8214192, f1)
    wfd(8214128, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218424)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218412)
    f1 = f1 + f2
    wfd(8214196, f1)
    wfd(8214132, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218412)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218416)
    f1 = f1 + f2
    wfd(8214204, f1)
    wfd(8214140, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218424)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218412)
    f1 = f1 + f2
    wfd(8214208, f1)
    wfd(8214144, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218412)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218416)
    f1 = f1 + f2
    wfd(8214216, f1)
    wfd(8214152, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218424)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218412)
    f1 = f1 + f2
    wfd(8214220, f1)
    wfd(8214156, f1)
    f1 = rf(M, 8214124)
    f1 = f1 + rf(M, 8211984)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8211980)
    f2 = rf(M, 421232)
    f1 = fmod(f1, f2)
    wfd(8204120, f2)
    wfd(8214188, f1)
    f1 = rf(M, 8216656)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8216652)
    wfd(8210484, f1)
    f1 = rf(M, 8214196)
    f1 = f1 * rf(M, 8216616)
    f2 = rf(M, 8214208)
    f2 = f2 * rf(M, 8216628)
    f1 = f1 + f2
    f2 = rf(M, 8214220)
    f2 = f2 * rf(M, 8216640)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210484)
    wfd(8217240, f1)
    f1 = rf(M, 8214708)
    f1 = f1 * rf(M, 8216616)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8216628)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8216640)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210484)
    wfd(8217244, f1)
    f1 = rf(M, 8214192)
    f1 = f1 * rf(M, 8216616)
    f2 = rf(M, 8214204)
    f2 = f2 * rf(M, 8216628)
    f1 = f1 + f2
    f2 = rf(M, 8214216)
    f2 = f2 * rf(M, 8216640)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210484)
    f2 = rf(M, 8215012)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217236, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218412)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218416)
    f1 = f1 + f2
    wfd(8214356, f1)
    wfd(8214292, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218424)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218412)
    f1 = f1 + f2
    wfd(8214360, f1)
    wfd(8214296, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218412)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218416)
    f1 = f1 + f2
    wfd(8214368, f1)
    wfd(8214304, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218424)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218412)
    f1 = f1 + f2
    wfd(8214372, f1)
    wfd(8214308, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218412)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218416)
    f1 = f1 + f2
    wfd(8214380, f1)
    wfd(8214316, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218424)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218412)
    f1 = f1 + f2
    wfd(8214384, f1)
    wfd(8214320, f1)
    f1 = rf(M, 8214288)
    f1 = f1 + rf(M, 8211992)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8211988)
    f2 = rf(M, 421232)
    f1 = fmod(f1, f2)
    wfd(8204120, f2)
    wfd(8214352, f1)
    f1 = rf(M, 8216760)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8216756)
    wfd(8210484, f1)
    f1 = rf(M, 8214360)
    f1 = f1 * rf(M, 8216720)
    f2 = rf(M, 8214372)
    f2 = f2 * rf(M, 8216732)
    f1 = f1 + f2
    f2 = rf(M, 8214384)
    f2 = f2 * rf(M, 8216744)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210484)
    wfd(8217252, f1)
    f1 = rf(M, 8214708)
    f1 = f1 * rf(M, 8216720)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8216732)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8216744)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210484)
    wfd(8217256, f1)
    f1 = rf(M, 8214356)
    f1 = f1 * rf(M, 8216720)
    f2 = rf(M, 8214368)
    f2 = f2 * rf(M, 8216732)
    f1 = f1 + f2
    f2 = rf(M, 8214380)
    f2 = f2 * rf(M, 8216744)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210484)
    f2 = rf(M, 8215016)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217248, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218412)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218416)
    f1 = f1 + f2
    wfd(8214520, f1)
    wfd(8214456, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218424)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8218412)
    f1 = f1 + f2
    wfd(8214524, f1)
    wfd(8214460, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218412)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218416)
    f1 = f1 + f2
    wfd(8214532, f1)
    wfd(8214468, f1)
  end
  local function C12()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218424)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8218412)
    f1 = f1 + f2
    wfd(8214536, f1)
    wfd(8214472, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218412)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218416)
    f1 = f1 + f2
    wfd(8214544, f1)
    wfd(8214480, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218424)
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8218412)
    f1 = f1 + f2
    wfd(8214548, f1)
    wfd(8214484, f1)
    f1 = rf(M, 8214452)
    f1 = f1 + rf(M, 8212000)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8211996)
    f2 = rf(M, 421232)
    f1 = fmod(f1, f2)
    wfd(8204120, f2)
    wfd(8214516, f1)
    f1 = rf(M, 8214520)
    f1 = f1 * rf(M, 8216824)
    f2 = rf(M, 8214532)
    f2 = f2 * rf(M, 8216836)
    f1 = f1 + f2
    f2 = rf(M, 8214544)
    f2 = f2 * rf(M, 8216848)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8216860)
    wfd(8217260, f1)
    f1 = rf(M, 8214524)
    f1 = f1 * rf(M, 8216824)
    f2 = rf(M, 8214536)
    f2 = f2 * rf(M, 8216836)
    f1 = f1 + f2
    f2 = rf(M, 8214548)
    f2 = f2 * rf(M, 8216848)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8216860)
    wfd(8217264, f1)
    f1 = rf(M, 8214708)
    f1 = f1 * rf(M, 8216824)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8216836)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8216848)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8216860)
    wfd(8217268, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8218428)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8218436)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214504)
    wfd(8214676, f1)
    f1 = rf(M, 8214616)
    f1 = f1 + rf(M, 8212008)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8212004)
    wfd(8214628, f1)
    f1 = f1 * rf(M, 8214700)
    f2 = rf(M, 8214620)
    f2 = f2 + rf(M, 8212016)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8212012)
    wfd(8214632, f2)
    f2 = f2 * rf(M, 8214704)
    f1 = f1 + f2
    f2 = rf(M, 8214624)
    f2 = f2 + rf(M, 8212024)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8212020)
    wfd(8214636, f2)
    f2 = f2 * rf(M, 8214708)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214676)
    wfd(8214688, f1)
    f1 = rf(M, 8214712)
    f1 = f1 * rf(M, 8218428)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8218436)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214508)
    wfd(8214680, f1)
    f1 = rf(M, 8214628)
    f1 = f1 * rf(M, 8214712)
    f2 = rf(M, 8214632)
    f2 = f2 * rf(M, 8214716)
    f1 = f1 + f2
    f2 = rf(M, 8214636)
    f2 = f2 * rf(M, 8214720)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214680)
    wfd(8214692, f1)
    f1 = rf(M, 8214724)
    f1 = f1 * rf(M, 8218428)
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8218436)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214512)
    wfd(8214684, f1)
    f1 = rf(M, 8214628)
    f1 = f1 * rf(M, 8214724)
    f2 = rf(M, 8214632)
    f2 = f2 * rf(M, 8214728)
    f1 = f1 + f2
    f2 = rf(M, 8214636)
    f2 = f2 * rf(M, 8214732)
    f1 = f1 + f2
    f1 = f1 + rf(M, 8214684)
    wfd(8214696, f1)
    f1 = rf(M, 8216972)
    f1 = f1 * rf(M, 8218936)
    f1 = f1 + rf(M, 8216960)
    wfd(8210484, f1)
    f1 = rf(M, 8214700)
    f1 = f1 * rf(M, 8216876)
    f2 = rf(M, 8214712)
    f2 = f2 * rf(M, 8216888)
    f1 = f1 + f2
    f2 = rf(M, 8214724)
    f2 = f2 * rf(M, 8216900)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210484)
    f2 = rf(M, 8216976)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8216964)
    wfd(8210516, f2)
    f2 = rf(M, 8214700)
    f2 = f2 * rf(M, 8216880)
    f3 = rf(M, 8214712)
    f3 = f3 * rf(M, 8216892)
    f2 = f2 + f3
    f3 = rf(M, 8214724)
    f3 = f3 * rf(M, 8216904)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8216980)
    f2 = f2 * rf(M, 8218936)
    f2 = f2 + rf(M, 8216968)
    wfd(8210292, f2)
    f2 = rf(M, 8214700)
    f2 = f2 * rf(M, 8216884)
    f3 = rf(M, 8214712)
    f3 = f3 * rf(M, 8216896)
    f2 = f2 + f3
    f3 = rf(M, 8214724)
    f3 = f3 * rf(M, 8216908)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210292)
    f1 = f1 + f2
    f2 = rf(M, 8215040)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217272, f1)
    f1 = rf(M, 8214704)
    f1 = f1 * rf(M, 8216876)
    f2 = rf(M, 8214716)
    f2 = f2 * rf(M, 8216888)
    f1 = f1 + f2
    f2 = rf(M, 8214728)
    f2 = f2 * rf(M, 8216900)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210484)
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8216880)
    f3 = rf(M, 8214716)
    f3 = f3 * rf(M, 8216892)
    f2 = f2 + f3
    f3 = rf(M, 8214728)
    f3 = f3 * rf(M, 8216904)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8214704)
    f2 = f2 * rf(M, 8216884)
    f3 = rf(M, 8214716)
    f3 = f3 * rf(M, 8216896)
    f2 = f2 + f3
    f3 = rf(M, 8214728)
    f3 = f3 * rf(M, 8216908)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210292)
    f1 = f1 + f2
    f2 = rf(M, 8215044)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217276, f1)
    f1 = rf(M, 8214708)
    f1 = f1 * rf(M, 8216876)
    f2 = rf(M, 8214720)
    f2 = f2 * rf(M, 8216888)
    f1 = f1 + f2
    f2 = rf(M, 8214732)
    f2 = f2 * rf(M, 8216900)
    f1 = f1 + f2
    f1 = f1 * rf(M, 8210484)
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8216880)
    f3 = rf(M, 8214720)
    f3 = f3 * rf(M, 8216892)
    f2 = f2 + f3
    f3 = rf(M, 8214732)
    f3 = f3 * rf(M, 8216904)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210516)
    f1 = f1 + f2
    f2 = rf(M, 8214708)
    f2 = f2 * rf(M, 8216884)
    f3 = rf(M, 8214720)
    f3 = f3 * rf(M, 8216896)
    f2 = f2 + f3
    f3 = rf(M, 8214732)
    f3 = f3 * rf(M, 8216908)
    f2 = f2 + f3
    f2 = f2 * rf(M, 8210292)
    f1 = f1 + f2
    f2 = rf(M, 8215048)
    f2 = f2 * rf(M, 8218936)
    f1 = f1 + f2
    wfd(8217280, f1)
  end
  JIT[0xeb69c9] = function() -- corrector
    C1()
    C2()
    C3()
    C4()
    C5()
    C6()
    C7()
    C8()
    C9()
    C10()
    C11()
    C12()
  end
end
do -- commit (4 chunks)
  local r_eax, r_ebx, r_ecx, r_edx, r_esi, r_edi
  local function C1()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    r_eax = ru(M, 8212052)
    wu(M, 8211812, r_eax)
    r_eax = ru(M, 8212056)
    wu(M, 8211820, r_eax)
    r_eax = ru(M, 8212060)
    wu(M, 8211828, r_eax)
    r_eax = ru(M, 8212064)
    wu(M, 8215052, r_eax)
    r_eax = ru(M, 8212068)
    wu(M, 8215056, r_eax)
    r_eax = ru(M, 8212072)
    wu(M, 8215060, r_eax)
    r_eax = ru(M, 8212128)
    wu(M, 8215064, r_eax)
    r_eax = ru(M, 8212132)
    wu(M, 8215068, r_eax)
    r_eax = ru(M, 8212136)
    wu(M, 8215072, r_eax)
    r_eax = ru(M, 8212140)
    wu(M, 8215076, r_eax)
    r_eax = ru(M, 8212144)
    wu(M, 8215080, r_eax)
    r_eax = ru(M, 8212148)
    wu(M, 8215084, r_eax)
    r_eax = ru(M, 8212152)
    wu(M, 8215088, r_eax)
    r_eax = ru(M, 8212156)
    wu(M, 8215092, r_eax)
    r_eax = ru(M, 8212160)
    wu(M, 8215096, r_eax)
    r_eax = ru(M, 8212080)
    wu(M, 8211836, r_eax)
    r_eax = ru(M, 8212084)
    wu(M, 8211840, r_eax)
    r_eax = ru(M, 8212088)
    wu(M, 8211844, r_eax)
    r_eax = ru(M, 8212076)
    wu(M, 8211848, r_eax)
    f1 = rf(M, 8212164)
    f1 = f1 * rf(M, 8218492)
    wfd(8215100, f1)
    f1 = rf(M, 8212168)
    f1 = f1 * rf(M, 8218492)
    wfd(8215104, f1)
    f1 = rf(M, 8212172)
    f1 = f1 * rf(M, 8218492)
    wfd(8215108, f1)
    f1 = rf(M, 8212176)
    f1 = f1 * rf(M, 8218944)
    wfd(8215112, f1)
    f1 = rf(M, 8212180)
    f1 = f1 * rf(M, 8218948)
    wfd(8215116, f1)
    f1 = rf(M, 8212184)
    f1 = f1 * rf(M, 8218952)
    wfd(8215120, f1)
    r_eax = ru(M, 8212028)
    wu(M, 8211816, r_eax)
    r_eax = ru(M, 8212032)
    wu(M, 8211824, r_eax)
    r_eax = ru(M, 8212036)
    wu(M, 8211832, r_eax)
    r_eax = ru(M, 8212040)
    wu(M, 8211852, r_eax)
    r_eax = ru(M, 8212044)
    wu(M, 8211856, r_eax)
    r_eax = ru(M, 8212048)
    wu(M, 8211860, r_eax)
    r_eax = ru(M, 8214924)
    wu(M, 8215124, r_eax)
    r_eax = ru(M, 8214928)
    wu(M, 8215128, r_eax)
    r_eax = ru(M, 8214932)
    wu(M, 8215132, r_eax)
    r_eax = ru(M, 8214916)
    wu(M, 8215136, r_eax)
    r_eax = ru(M, 8214920)
    wu(M, 8215140, r_eax)
    r_eax = ru(M, 8214936)
    wu(M, 8215144, r_eax)
    r_eax = ru(M, 8212224)
    wu(M, 8215148, r_eax)
    r_eax = ru(M, 8212228)
    wu(M, 8215152, r_eax)
    r_eax = ru(M, 8212232)
    wu(M, 8215156, r_eax)
    r_eax = ru(M, 8212188)
    wu(M, 8215160, r_eax)
    r_eax = ru(M, 8212192)
    wu(M, 8215164, r_eax)
    r_eax = ru(M, 8212196)
    wu(M, 8215168, r_eax)
    r_eax = ru(M, 8212200)
    wu(M, 8215172, r_eax)
    r_eax = ru(M, 8212204)
    wu(M, 8215176, r_eax)
    r_eax = ru(M, 8212208)
    wu(M, 8215180, r_eax)
    r_eax = ru(M, 8212212)
    wu(M, 8215184, r_eax)
    r_eax = ru(M, 8212216)
    wu(M, 8215188, r_eax)
    r_eax = ru(M, 8212220)
    wu(M, 8215192, r_eax)
    r_eax = ru(M, 8212236)
    wu(M, 8215196, r_eax)
    r_eax = ru(M, 8212240)
    wu(M, 8215200, r_eax)
    r_eax = ru(M, 8212244)
    wu(M, 8215204, r_eax)
    r_eax = ru(M, 8212248)
    wu(M, 8215208, r_eax)
    r_eax = ru(M, 8212252)
    wu(M, 8215212, r_eax)
    r_eax = ru(M, 8212256)
    wu(M, 8215216, r_eax)
    r_eax = ru(M, 8212260)
    wu(M, 8215220, r_eax)
    r_eax = ru(M, 8212264)
    wu(M, 8215224, r_eax)
    r_eax = ru(M, 8212268)
    wu(M, 8215228, r_eax)
    r_eax = ru(M, 8212272)
    wu(M, 8215232, r_eax)
    r_eax = ru(M, 8212276)
    wu(M, 8215236, r_eax)
    r_eax = ru(M, 8212280)
    wu(M, 8215240, r_eax)
    f1 = rf(M, 8212320)
    f1 = f1 * rf(M, 8218444)
    wfd(8215244, f1)
    f1 = rf(M, 8212324)
    f1 = f1 * rf(M, 8218444)
    wfd(8215248, f1)
    f1 = rf(M, 8212328)
    f1 = f1 * rf(M, 8218444)
    wfd(8215252, f1)
    r_eax = ru(M, 8214940)
    wu(M, 8215256, r_eax)
    r_eax = ru(M, 8214944)
    wu(M, 8215260, r_eax)
    r_eax = ru(M, 8214948)
    wu(M, 8215264, r_eax)
    r_eax = ru(M, 8212380)
    wu(M, 8215268, r_eax)
    r_eax = ru(M, 8212384)
    wu(M, 8215272, r_eax)
    r_eax = ru(M, 8212388)
    wu(M, 8215276, r_eax)
    r_eax = ru(M, 8212344)
    wu(M, 8215280, r_eax)
    r_eax = ru(M, 8212348)
    wu(M, 8215284, r_eax)
    r_eax = ru(M, 8212352)
    wu(M, 8215288, r_eax)
    r_eax = ru(M, 8212356)
    wu(M, 8215292, r_eax)
    r_eax = ru(M, 8212360)
    wu(M, 8215296, r_eax)
    r_eax = ru(M, 8212364)
    wu(M, 8215300, r_eax)
    r_eax = ru(M, 8212368)
    wu(M, 8215304, r_eax)
    r_eax = ru(M, 8212372)
    wu(M, 8215308, r_eax)
    r_eax = ru(M, 8212376)
    wu(M, 8215312, r_eax)
    r_eax = ru(M, 8212392)
    wu(M, 8215316, r_eax)
    r_eax = ru(M, 8212396)
    wu(M, 8215320, r_eax)
    r_eax = ru(M, 8212400)
    wu(M, 8215324, r_eax)
    r_eax = ru(M, 8212404)
    wu(M, 8215328, r_eax)
    r_eax = ru(M, 8212408)
    wu(M, 8215332, r_eax)
    r_eax = ru(M, 8212412)
    wu(M, 8215336, r_eax)
    r_eax = ru(M, 8212416)
    wu(M, 8215340, r_eax)
    r_eax = ru(M, 8212420)
    wu(M, 8215344, r_eax)
    r_eax = ru(M, 8212424)
    wu(M, 8215348, r_eax)
    r_eax = ru(M, 8212428)
    wu(M, 8215352, r_eax)
    r_eax = ru(M, 8212432)
    wu(M, 8215356, r_eax)
    r_eax = ru(M, 8212436)
    wu(M, 8215360, r_eax)
    f1 = rf(M, 8212476)
    f1 = f1 * rf(M, 8211864)
    wfd(8215364, f1)
    f1 = rf(M, 8212480)
    f1 = f1 * rf(M, 8211868)
    wfd(8215368, f1)
    f1 = rf(M, 8212484)
    f1 = f1 * rf(M, 8211872)
    wfd(8215372, f1)
    f1 = rf(M, 8212488)
    f1 = f1 * rf(M, 8211876)
    wfd(8215376, f1)
    f1 = rf(M, 8212492)
    f1 = f1 * rf(M, 8211880)
    wfd(8215380, f1)
    f1 = rf(M, 8212496)
    f1 = f1 * rf(M, 8211884)
    wfd(8215384, f1)
    r_eax = ru(M, 8214952)
    wu(M, 8215388, r_eax)
    r_eax = ru(M, 8214956)
    wu(M, 8215392, r_eax)
    r_eax = ru(M, 8214960)
    wu(M, 8215396, r_eax)
    r_eax = ru(M, 8212504)
    wu(M, 8211888, r_eax)
    r_eax = ru(M, 8212544)
    wu(M, 8215400, r_eax)
    r_eax = ru(M, 8212548)
    wu(M, 8215404, r_eax)
    r_eax = ru(M, 8212552)
    wu(M, 8215408, r_eax)
    r_eax = ru(M, 8212508)
    wu(M, 8215412, r_eax)
    r_eax = ru(M, 8212512)
    wu(M, 8215416, r_eax)
    r_eax = ru(M, 8212516)
    wu(M, 8215420, r_eax)
    r_eax = ru(M, 8212520)
    wu(M, 8215424, r_eax)
    r_eax = ru(M, 8212524)
    wu(M, 8215428, r_eax)
    r_eax = ru(M, 8212528)
    wu(M, 8215432, r_eax)
    r_eax = ru(M, 8212532)
    wu(M, 8215436, r_eax)
    r_eax = ru(M, 8212536)
    wu(M, 8215440, r_eax)
    r_eax = ru(M, 8212540)
    wu(M, 8215444, r_eax)
    r_eax = ru(M, 8212556)
    wu(M, 8215448, r_eax)
    r_eax = ru(M, 8212560)
    wu(M, 8215452, r_eax)
    r_eax = ru(M, 8212564)
    wu(M, 8215456, r_eax)
    r_eax = ru(M, 8212568)
    wu(M, 8215460, r_eax)
    r_eax = ru(M, 8212572)
    wu(M, 8215464, r_eax)
    r_eax = ru(M, 8212576)
    wu(M, 8215468, r_eax)
    r_eax = ru(M, 8212580)
    wu(M, 8215472, r_eax)
    r_eax = ru(M, 8212584)
    wu(M, 8215476, r_eax)
    r_eax = ru(M, 8212588)
    wu(M, 8215480, r_eax)
    r_eax = ru(M, 8212592)
    wu(M, 8215484, r_eax)
    r_eax = ru(M, 8212596)
    wu(M, 8215488, r_eax)
    r_eax = ru(M, 8212600)
    wu(M, 8215492, r_eax)
    r_eax = ru(M, 8212500)
    wu(M, 8211892, r_eax)
    r_eax = ru(M, 8215000)
    wu(M, 8215496, r_eax)
    r_eax = ru(M, 8212740)
    wu(M, 8215500, r_eax)
    r_eax = ru(M, 8212744)
    wu(M, 8215504, r_eax)
    r_eax = ru(M, 8212748)
    wu(M, 8215508, r_eax)
    r_eax = ru(M, 8212704)
    wu(M, 8215512, r_eax)
    r_eax = ru(M, 8212708)
    wu(M, 8215516, r_eax)
    r_eax = ru(M, 8212712)
    wu(M, 8215520, r_eax)
    r_eax = ru(M, 8212716)
    wu(M, 8215524, r_eax)
    r_eax = ru(M, 8212720)
    wu(M, 8215528, r_eax)
    r_eax = ru(M, 8212724)
    wu(M, 8215532, r_eax)
    r_eax = ru(M, 8212728)
    wu(M, 8215536, r_eax)
    r_eax = ru(M, 8212732)
    wu(M, 8215540, r_eax)
    r_eax = ru(M, 8212736)
    wu(M, 8215544, r_eax)
    r_eax = ru(M, 8212752)
    wu(M, 8215548, r_eax)
    r_eax = ru(M, 8212756)
    wu(M, 8215552, r_eax)
    r_eax = ru(M, 8212760)
    wu(M, 8215556, r_eax)
    r_eax = ru(M, 8212784)
  end
  local function C2()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    wu(M, 8215560, r_eax)
    r_eax = ru(M, 8212788)
    wu(M, 8215564, r_eax)
    r_eax = ru(M, 8212792)
    wu(M, 8215568, r_eax)
    r_eax = ru(M, 8212796)
    wu(M, 8215572, r_eax)
    r_eax = ru(M, 8212800)
    wu(M, 8215576, r_eax)
    r_eax = ru(M, 8212804)
    wu(M, 8215580, r_eax)
    r_eax = ru(M, 8212808)
    wu(M, 8215584, r_eax)
    r_eax = ru(M, 8212812)
    wu(M, 8215588, r_eax)
    r_eax = ru(M, 8212816)
    wu(M, 8215592, r_eax)
    r_eax = ru(M, 8212764)
    wu(M, 8211896, r_eax)
    f1 = rf(M, 8212844)
    f1 = f1 * rf(M, 8218636)
    wfd(8215596, f1)
    f1 = rf(M, 8212848)
    f1 = f1 * rf(M, 8218636)
    wfd(8215600, f1)
    f1 = rf(M, 8212852)
    f1 = f1 * rf(M, 8218636)
    wfd(8215604, f1)
    f1 = rf(M, 8212856)
    f1 = f1 * rf(M, 8218520)
    wfd(8215608, f1)
    f1 = rf(M, 8212860)
    f1 = f1 * rf(M, 8218528)
    wfd(8215612, f1)
    f1 = rf(M, 8212864)
    f1 = f1 * rf(M, 8218520)
    wfd(8215616, f1)
    r_eax = ru(M, 8212700)
    wu(M, 8211900, r_eax)
    r_eax = ru(M, 8214964)
    wu(M, 8215620, r_eax)
    r_eax = ru(M, 8214968)
    wu(M, 8215624, r_eax)
    r_eax = ru(M, 8214972)
    wu(M, 8215628, r_eax)
    r_eax = ru(M, 8215020)
    wu(M, 8215632, r_eax)
    r_eax = ru(M, 8215024)
    wu(M, 8215636, r_eax)
    r_eax = ru(M, 8212908)
    wu(M, 8215640, r_eax)
    r_eax = ru(M, 8212912)
    wu(M, 8215644, r_eax)
    r_eax = ru(M, 8212916)
    wu(M, 8215648, r_eax)
    r_eax = ru(M, 8212872)
    wu(M, 8215652, r_eax)
    r_eax = ru(M, 8212876)
    wu(M, 8215656, r_eax)
    r_eax = ru(M, 8212880)
    wu(M, 8215660, r_eax)
    r_eax = ru(M, 8212884)
    wu(M, 8215664, r_eax)
    r_eax = ru(M, 8212888)
    wu(M, 8215668, r_eax)
    r_eax = ru(M, 8212892)
    wu(M, 8215672, r_eax)
    r_eax = ru(M, 8212896)
    wu(M, 8215676, r_eax)
    r_eax = ru(M, 8212900)
    wu(M, 8215680, r_eax)
    r_eax = ru(M, 8212904)
    wu(M, 8215684, r_eax)
    r_eax = ru(M, 8212920)
    wu(M, 8215688, r_eax)
    r_eax = ru(M, 8212924)
    wu(M, 8215692, r_eax)
    r_eax = ru(M, 8212928)
    wu(M, 8215696, r_eax)
    r_eax = ru(M, 8212936)
    wu(M, 8215700, r_eax)
    r_eax = ru(M, 8212940)
    wu(M, 8215704, r_eax)
    r_eax = ru(M, 8212944)
    wu(M, 8215708, r_eax)
    r_eax = ru(M, 8212948)
    wu(M, 8215712, r_eax)
    r_eax = ru(M, 8212952)
    wu(M, 8215716, r_eax)
    r_eax = ru(M, 8212956)
    wu(M, 8215720, r_eax)
    r_eax = ru(M, 8212960)
    wu(M, 8215724, r_eax)
    r_eax = ru(M, 8212964)
    wu(M, 8215728, r_eax)
    r_eax = ru(M, 8212968)
    wu(M, 8215732, r_eax)
    r_eax = ru(M, 8212932)
    wu(M, 8211904, r_eax)
    f1 = rf(M, 8213012)
    f1 = f1 * rf(M, 8218788)
    wfd(8215736, f1)
    r_eax = ru(M, 8212868)
    wu(M, 8211908, r_eax)
    r_eax = ru(M, 8214820)
    wu(M, 8215740, r_eax)
    r_eax = ru(M, 8214824)
    wu(M, 8215744, r_eax)
    r_eax = ru(M, 8214828)
    wu(M, 8215748, r_eax)
    r_eax = ru(M, 8214832)
    wu(M, 8215752, r_eax)
    r_eax = ru(M, 8214836)
    wu(M, 8215756, r_eax)
    r_eax = ru(M, 8214840)
    wu(M, 8215760, r_eax)
    r_eax = ru(M, 8213024)
    wu(M, 8211912, r_eax)
    r_eax = ru(M, 8213064)
    wu(M, 8215764, r_eax)
    r_eax = ru(M, 8213068)
    wu(M, 8215768, r_eax)
    r_eax = ru(M, 8213072)
    wu(M, 8215772, r_eax)
    r_eax = ru(M, 8213028)
    wu(M, 8215776, r_eax)
    r_eax = ru(M, 8213032)
    wu(M, 8215780, r_eax)
    r_eax = ru(M, 8213036)
    wu(M, 8215784, r_eax)
    r_eax = ru(M, 8213040)
    wu(M, 8215788, r_eax)
    r_eax = ru(M, 8213044)
    wu(M, 8215792, r_eax)
    r_eax = ru(M, 8213048)
    wu(M, 8215796, r_eax)
    r_eax = ru(M, 8213052)
    wu(M, 8215800, r_eax)
    r_eax = ru(M, 8213056)
    wu(M, 8215804, r_eax)
    r_eax = ru(M, 8213060)
    wu(M, 8215808, r_eax)
    r_eax = ru(M, 8213076)
    wu(M, 8215812, r_eax)
    r_eax = ru(M, 8213080)
    wu(M, 8215816, r_eax)
    r_eax = ru(M, 8213084)
    wu(M, 8215820, r_eax)
    r_eax = ru(M, 8213088)
    wu(M, 8215824, r_eax)
    r_eax = ru(M, 8213092)
    wu(M, 8215828, r_eax)
    r_eax = ru(M, 8213096)
    wu(M, 8215832, r_eax)
    r_eax = ru(M, 8213100)
    wu(M, 8215836, r_eax)
    r_eax = ru(M, 8213104)
    wu(M, 8215840, r_eax)
    r_eax = ru(M, 8213108)
    wu(M, 8215844, r_eax)
    r_eax = ru(M, 8213112)
    wu(M, 8215848, r_eax)
    r_eax = ru(M, 8213116)
    wu(M, 8215852, r_eax)
    r_eax = ru(M, 8213120)
    wu(M, 8215856, r_eax)
    r_eax = ru(M, 8213020)
    wu(M, 8211916, r_eax)
    r_eax = ru(M, 8215004)
    wu(M, 8215860, r_eax)
    r_eax = ru(M, 8213260)
    wu(M, 8215864, r_eax)
    r_eax = ru(M, 8213264)
    wu(M, 8215868, r_eax)
    r_eax = ru(M, 8213268)
    wu(M, 8215872, r_eax)
    r_eax = ru(M, 8213224)
    wu(M, 8215876, r_eax)
    r_eax = ru(M, 8213228)
    wu(M, 8215880, r_eax)
    r_eax = ru(M, 8213232)
    wu(M, 8215884, r_eax)
    r_eax = ru(M, 8213236)
    wu(M, 8215888, r_eax)
    r_eax = ru(M, 8213240)
    wu(M, 8215892, r_eax)
    r_eax = ru(M, 8213244)
    wu(M, 8215896, r_eax)
    r_eax = ru(M, 8213248)
    wu(M, 8215900, r_eax)
    r_eax = ru(M, 8213252)
    wu(M, 8215904, r_eax)
    r_eax = ru(M, 8213256)
    wu(M, 8215908, r_eax)
    r_eax = ru(M, 8213272)
    wu(M, 8215912, r_eax)
    r_eax = ru(M, 8213276)
    wu(M, 8215916, r_eax)
    r_eax = ru(M, 8213280)
    wu(M, 8215920, r_eax)
    r_eax = ru(M, 8213304)
    wu(M, 8215924, r_eax)
    r_eax = ru(M, 8213308)
    wu(M, 8215928, r_eax)
    r_eax = ru(M, 8213312)
    wu(M, 8215932, r_eax)
    r_eax = ru(M, 8213316)
    wu(M, 8215936, r_eax)
    r_eax = ru(M, 8213320)
    wu(M, 8215940, r_eax)
    r_eax = ru(M, 8213324)
    wu(M, 8215944, r_eax)
    r_eax = ru(M, 8213328)
    wu(M, 8215948, r_eax)
    r_eax = ru(M, 8213332)
    wu(M, 8215952, r_eax)
    r_eax = ru(M, 8213336)
    wu(M, 8215956, r_eax)
    r_eax = ru(M, 8213284)
    wu(M, 8211920, r_eax)
    f1 = rf(M, 8213364)
    f1 = f1 * rf(M, 8218636)
    wfd(8215960, f1)
    f1 = rf(M, 8213368)
    f1 = f1 * rf(M, 8218636)
    wfd(8215964, f1)
    f1 = rf(M, 8213372)
    f1 = f1 * rf(M, 8218636)
    wfd(8215968, f1)
    f1 = rf(M, 8213376)
    f1 = f1 * rf(M, 8218520)
    wfd(8215972, f1)
    f1 = rf(M, 8213380)
    f1 = f1 * rf(M, 8218528)
    wfd(8215976, f1)
    f1 = rf(M, 8213384)
    f1 = f1 * rf(M, 8218520)
    wfd(8215980, f1)
    r_eax = ru(M, 8213220)
    wu(M, 8211924, r_eax)
    r_eax = ru(M, 8214976)
    wu(M, 8215984, r_eax)
    r_eax = ru(M, 8214980)
    wu(M, 8215988, r_eax)
    r_eax = ru(M, 8214984)
    wu(M, 8215992, r_eax)
    r_eax = ru(M, 8215028)
    wu(M, 8215996, r_eax)
    r_eax = ru(M, 8215032)
    wu(M, 8216000, r_eax)
    r_eax = ru(M, 8213428)
    wu(M, 8216004, r_eax)
    r_eax = ru(M, 8213432)
    wu(M, 8216008, r_eax)
    r_eax = ru(M, 8213436)
    wu(M, 8216012, r_eax)
    r_eax = ru(M, 8213392)
    wu(M, 8216016, r_eax)
    r_eax = ru(M, 8213396)
    wu(M, 8216020, r_eax)
    r_eax = ru(M, 8213400)
    wu(M, 8216024, r_eax)
    r_eax = ru(M, 8213404)
    wu(M, 8216028, r_eax)
    r_eax = ru(M, 8213408)
    wu(M, 8216032, r_eax)
    r_eax = ru(M, 8213412)
    wu(M, 8216036, r_eax)
    r_eax = ru(M, 8213416)
    wu(M, 8216040, r_eax)
    r_eax = ru(M, 8213420)
    wu(M, 8216044, r_eax)
    r_eax = ru(M, 8213424)
    wu(M, 8216048, r_eax)
    r_eax = ru(M, 8213440)
    wu(M, 8216052, r_eax)
    r_eax = ru(M, 8213444)
    wu(M, 8216056, r_eax)
    r_eax = ru(M, 8213448)
    wu(M, 8216060, r_eax)
    r_eax = ru(M, 8213456)
    wu(M, 8216064, r_eax)
    r_eax = ru(M, 8213460)
    wu(M, 8216068, r_eax)
    r_eax = ru(M, 8213464)
    wu(M, 8216072, r_eax)
    r_eax = ru(M, 8213468)
    wu(M, 8216076, r_eax)
    r_eax = ru(M, 8213472)
    wu(M, 8216080, r_eax)
    r_eax = ru(M, 8213476)
    wu(M, 8216084, r_eax)
    r_eax = ru(M, 8213480)
    wu(M, 8216088, r_eax)
    r_eax = ru(M, 8213484)
    wu(M, 8216092, r_eax)
    r_eax = ru(M, 8213488)
    wu(M, 8216096, r_eax)
    r_eax = ru(M, 8213452)
    wu(M, 8211928, r_eax)
  end
  local function C3()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    f1 = rf(M, 8213532)
    f1 = f1 * rf(M, 8218788)
    wfd(8216100, f1)
    r_eax = ru(M, 8213388)
    wu(M, 8211932, r_eax)
    r_eax = ru(M, 8214844)
    wu(M, 8216104, r_eax)
    r_eax = ru(M, 8214848)
    wu(M, 8216108, r_eax)
    r_eax = ru(M, 8214852)
    wu(M, 8216112, r_eax)
    r_eax = ru(M, 8214856)
    wu(M, 8216116, r_eax)
    r_eax = ru(M, 8214860)
    wu(M, 8216120, r_eax)
    r_eax = ru(M, 8214864)
    wu(M, 8216124, r_eax)
    r_eax = ru(M, 8213548)
    wu(M, 8211940, r_eax)
    r_eax = ru(M, 8213588)
    wu(M, 8216128, r_eax)
    r_eax = ru(M, 8213592)
    wu(M, 8216132, r_eax)
    r_eax = ru(M, 8213596)
    wu(M, 8216136, r_eax)
    r_eax = ru(M, 8213552)
    wu(M, 8216140, r_eax)
    r_eax = ru(M, 8213556)
    wu(M, 8216144, r_eax)
    r_eax = ru(M, 8213560)
    wu(M, 8216148, r_eax)
    r_eax = ru(M, 8213564)
    wu(M, 8216152, r_eax)
    r_eax = ru(M, 8213568)
    wu(M, 8216156, r_eax)
    r_eax = ru(M, 8213572)
    wu(M, 8216160, r_eax)
    r_eax = ru(M, 8213576)
    wu(M, 8216164, r_eax)
    r_eax = ru(M, 8213580)
    wu(M, 8216168, r_eax)
    r_eax = ru(M, 8213584)
    wu(M, 8216172, r_eax)
    r_eax = ru(M, 8213600)
    wu(M, 8216176, r_eax)
    r_eax = ru(M, 8213604)
    wu(M, 8216180, r_eax)
    r_eax = ru(M, 8213608)
    wu(M, 8216184, r_eax)
    r_eax = ru(M, 8213632)
    wu(M, 8216188, r_eax)
    r_eax = ru(M, 8213636)
    wu(M, 8216192, r_eax)
    r_eax = ru(M, 8213640)
    wu(M, 8216196, r_eax)
    r_eax = ru(M, 8213644)
    wu(M, 8216200, r_eax)
    r_eax = ru(M, 8213648)
    wu(M, 8216204, r_eax)
    r_eax = ru(M, 8213652)
    wu(M, 8216208, r_eax)
    r_eax = ru(M, 8213656)
    wu(M, 8216212, r_eax)
    r_eax = ru(M, 8213660)
    wu(M, 8216216, r_eax)
    r_eax = ru(M, 8213664)
    wu(M, 8216220, r_eax)
    r_eax = ru(M, 8213612)
    wu(M, 8211948, r_eax)
    f1 = rf(M, 8213764)
    f1 = f1 * rf(M, 8218700)
    wfd(8216224, f1)
    f1 = rf(M, 8213768)
    f1 = f1 * rf(M, 8218700)
    wfd(8216228, f1)
    f1 = rf(M, 8213772)
    f1 = f1 * rf(M, 8218700)
    wfd(8216232, f1)
    f1 = rf(M, 8213776)
    f1 = f1 * rf(M, 8218704)
    wfd(8216236, f1)
    f1 = rf(M, 8213780)
    f1 = f1 * rf(M, 8218144)
    wfd(8216240, f1)
    f1 = rf(M, 8213784)
    f1 = f1 * rf(M, 8218704)
    wfd(8216244, f1)
    r_eax = ru(M, 8213540)
    wu(M, 8211944, r_eax)
    r_eax = ru(M, 8213544)
    wu(M, 8211952, r_eax)
    r_eax = ru(M, 8214988)
    wu(M, 8216248, r_eax)
    r_eax = ru(M, 8214992)
    wu(M, 8216252, r_eax)
    r_eax = ru(M, 8214996)
    wu(M, 8216256, r_eax)
    r_eax = ru(M, 8215008)
    wu(M, 8216260, r_eax)
    r_eax = ru(M, 8215036)
    wu(M, 8216264, r_eax)
    r_eax = ru(M, 8213828)
    wu(M, 8216268, r_eax)
    r_eax = ru(M, 8213832)
    wu(M, 8216272, r_eax)
    r_eax = ru(M, 8213836)
    wu(M, 8216276, r_eax)
    r_eax = ru(M, 8213792)
    wu(M, 8216280, r_eax)
    r_eax = ru(M, 8213796)
    wu(M, 8216284, r_eax)
    r_eax = ru(M, 8213800)
    wu(M, 8216288, r_eax)
    r_eax = ru(M, 8213804)
    wu(M, 8216292, r_eax)
    r_eax = ru(M, 8213808)
    wu(M, 8216296, r_eax)
    r_eax = ru(M, 8213812)
    wu(M, 8216300, r_eax)
    r_eax = ru(M, 8213816)
    wu(M, 8216304, r_eax)
    r_eax = ru(M, 8213820)
    wu(M, 8216308, r_eax)
    r_eax = ru(M, 8213824)
    wu(M, 8216312, r_eax)
    r_eax = ru(M, 8213840)
    wu(M, 8216316, r_eax)
    r_eax = ru(M, 8213844)
    wu(M, 8216320, r_eax)
    r_eax = ru(M, 8213848)
    wu(M, 8216324, r_eax)
    r_eax = ru(M, 8213856)
    wu(M, 8216328, r_eax)
    r_eax = ru(M, 8213860)
    wu(M, 8216332, r_eax)
    r_eax = ru(M, 8213864)
    wu(M, 8216336, r_eax)
    r_eax = ru(M, 8213868)
    wu(M, 8216340, r_eax)
    r_eax = ru(M, 8213872)
    wu(M, 8216344, r_eax)
    r_eax = ru(M, 8213876)
    wu(M, 8216348, r_eax)
    r_eax = ru(M, 8213880)
    wu(M, 8216352, r_eax)
    r_eax = ru(M, 8213884)
    wu(M, 8216356, r_eax)
    r_eax = ru(M, 8213888)
    wu(M, 8216360, r_eax)
    r_eax = ru(M, 8213852)
    wu(M, 8211960, r_eax)
    f1 = rf(M, 8213932)
    f1 = f1 * rf(M, 8218636)
    wfd(8216364, f1)
    f1 = rf(M, 8213936)
    f1 = f1 * rf(M, 8218636)
    wfd(8216368, f1)
    f1 = rf(M, 8213940)
    f1 = f1 * rf(M, 8218636)
    wfd(8216372, f1)
    f1 = rf(M, 8213944)
    f1 = f1 * rf(M, 8218956)
    wfd(8216376, f1)
    f1 = rf(M, 8213948)
    f1 = f1 * rf(M, 8218800)
    wfd(8216380, f1)
    f1 = rf(M, 8213952)
    f1 = f1 * rf(M, 8218960)
    wfd(8216384, f1)
    r_eax = ru(M, 8213788)
    wu(M, 8211964, r_eax)
    r_eax = ru(M, 8214868)
    wu(M, 8216388, r_eax)
    r_eax = ru(M, 8214872)
    wu(M, 8216392, r_eax)
    r_eax = ru(M, 8214876)
    wu(M, 8216396, r_eax)
    r_eax = ru(M, 8214880)
    wu(M, 8216400, r_eax)
    r_eax = ru(M, 8214884)
    wu(M, 8216404, r_eax)
    r_eax = ru(M, 8214888)
    wu(M, 8216408, r_eax)
    r_eax = ru(M, 8213996)
    wu(M, 8216412, r_eax)
    r_eax = ru(M, 8214000)
    wu(M, 8216416, r_eax)
    r_eax = ru(M, 8214004)
    wu(M, 8216420, r_eax)
    r_eax = ru(M, 8213960)
    wu(M, 8216424, r_eax)
    r_eax = ru(M, 8213964)
    wu(M, 8216428, r_eax)
    r_eax = ru(M, 8213968)
    wu(M, 8216432, r_eax)
    r_eax = ru(M, 8213972)
    wu(M, 8216436, r_eax)
    r_eax = ru(M, 8213976)
    wu(M, 8216440, r_eax)
    r_eax = ru(M, 8213980)
    wu(M, 8216444, r_eax)
    r_eax = ru(M, 8213984)
    wu(M, 8216448, r_eax)
    r_eax = ru(M, 8213988)
    wu(M, 8216452, r_eax)
    r_eax = ru(M, 8213992)
    wu(M, 8216456, r_eax)
    r_eax = ru(M, 8214008)
    wu(M, 8216460, r_eax)
    r_eax = ru(M, 8214012)
    wu(M, 8216464, r_eax)
    r_eax = ru(M, 8214016)
    wu(M, 8216468, r_eax)
    r_eax = ru(M, 8214024)
    wu(M, 8216472, r_eax)
    r_eax = ru(M, 8214028)
    wu(M, 8216476, r_eax)
    r_eax = ru(M, 8214032)
    wu(M, 8216480, r_eax)
    r_eax = ru(M, 8214036)
    wu(M, 8216484, r_eax)
    r_eax = ru(M, 8214040)
    wu(M, 8216488, r_eax)
    r_eax = ru(M, 8214044)
    wu(M, 8216492, r_eax)
    r_eax = ru(M, 8214048)
    wu(M, 8216496, r_eax)
    r_eax = ru(M, 8214052)
    wu(M, 8216500, r_eax)
    r_eax = ru(M, 8214056)
    wu(M, 8216504, r_eax)
    r_eax = ru(M, 8214020)
    wu(M, 8211972, r_eax)
    f1 = rf(M, 8214100)
    f1 = f1 * rf(M, 8218636)
    wfd(8216508, f1)
    f1 = rf(M, 8214104)
    f1 = f1 * rf(M, 8218636)
    wfd(8216512, f1)
    f1 = rf(M, 8214108)
    f1 = f1 * rf(M, 8218636)
    wfd(8216516, f1)
    f1 = rf(M, 8214112)
    f1 = f1 * rf(M, 8218956)
    wfd(8216520, f1)
    f1 = rf(M, 8214116)
    f1 = f1 * rf(M, 8218800)
    wfd(8216524, f1)
    f1 = rf(M, 8214120)
    f1 = f1 * rf(M, 8218956)
    wfd(8216528, f1)
    r_eax = ru(M, 8213956)
    wu(M, 8211976, r_eax)
    r_eax = ru(M, 8214892)
    wu(M, 8216532, r_eax)
    r_eax = ru(M, 8214896)
    wu(M, 8216536, r_eax)
    r_eax = ru(M, 8214900)
    wu(M, 8216540, r_eax)
    r_eax = ru(M, 8214904)
    wu(M, 8216544, r_eax)
    r_eax = ru(M, 8214908)
    wu(M, 8216548, r_eax)
    r_eax = ru(M, 8214912)
    wu(M, 8216552, r_eax)
    r_eax = ru(M, 8214164)
    wu(M, 8216556, r_eax)
    r_eax = ru(M, 8214168)
    wu(M, 8216560, r_eax)
    r_eax = ru(M, 8214172)
    wu(M, 8216564, r_eax)
    r_eax = ru(M, 8214128)
    wu(M, 8216568, r_eax)
    r_eax = ru(M, 8214132)
    wu(M, 8216572, r_eax)
    r_eax = ru(M, 8214136)
    wu(M, 8216576, r_eax)
    r_eax = ru(M, 8214140)
    wu(M, 8216580, r_eax)
    r_eax = ru(M, 8214144)
    wu(M, 8216584, r_eax)
    r_eax = ru(M, 8214148)
    wu(M, 8216588, r_eax)
    r_eax = ru(M, 8214152)
    wu(M, 8216592, r_eax)
    r_eax = ru(M, 8214156)
    wu(M, 8216596, r_eax)
    r_eax = ru(M, 8214160)
    wu(M, 8216600, r_eax)
    r_eax = ru(M, 8214176)
    wu(M, 8216604, r_eax)
    r_eax = ru(M, 8214180)
    wu(M, 8216608, r_eax)
    r_eax = ru(M, 8214184)
    wu(M, 8216612, r_eax)
    r_eax = ru(M, 8214192)
    wu(M, 8216616, r_eax)
    r_eax = ru(M, 8214196)
    wu(M, 8216620, r_eax)
    r_eax = ru(M, 8214200)
  end
  local function C4()
    local f1, f2, f3, f4, f5, f6, f7, f8, q
    local p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, p63
    wu(M, 8216624, r_eax)
    r_eax = ru(M, 8214204)
    wu(M, 8216628, r_eax)
    r_eax = ru(M, 8214208)
    wu(M, 8216632, r_eax)
    r_eax = ru(M, 8214212)
    wu(M, 8216636, r_eax)
    r_eax = ru(M, 8214216)
    wu(M, 8216640, r_eax)
    r_eax = ru(M, 8214220)
    wu(M, 8216644, r_eax)
    r_eax = ru(M, 8214224)
    wu(M, 8216648, r_eax)
    r_eax = ru(M, 8214188)
    wu(M, 8211980, r_eax)
    f1 = rf(M, 8214276)
    f1 = f1 * rf(M, 8218812)
    wfd(8216652, f1)
    r_eax = ru(M, 8214124)
    wu(M, 8211984, r_eax)
    r_eax = ru(M, 8215012)
    wu(M, 8216656, r_eax)
    r_eax = ru(M, 8214328)
    wu(M, 8216660, r_eax)
    r_eax = ru(M, 8214332)
    wu(M, 8216664, r_eax)
    r_eax = ru(M, 8214336)
    wu(M, 8216668, r_eax)
    r_eax = ru(M, 8214292)
    wu(M, 8216672, r_eax)
    r_eax = ru(M, 8214296)
    wu(M, 8216676, r_eax)
    r_eax = ru(M, 8214300)
    wu(M, 8216680, r_eax)
    r_eax = ru(M, 8214304)
    wu(M, 8216684, r_eax)
    r_eax = ru(M, 8214308)
    wu(M, 8216688, r_eax)
    r_eax = ru(M, 8214312)
    wu(M, 8216692, r_eax)
    r_eax = ru(M, 8214316)
    wu(M, 8216696, r_eax)
    r_eax = ru(M, 8214320)
    wu(M, 8216700, r_eax)
    r_eax = ru(M, 8214324)
    wu(M, 8216704, r_eax)
    r_eax = ru(M, 8214340)
    wu(M, 8216708, r_eax)
    r_eax = ru(M, 8214344)
    wu(M, 8216712, r_eax)
    r_eax = ru(M, 8214348)
    wu(M, 8216716, r_eax)
    r_eax = ru(M, 8214356)
    wu(M, 8216720, r_eax)
    r_eax = ru(M, 8214360)
    wu(M, 8216724, r_eax)
    r_eax = ru(M, 8214364)
    wu(M, 8216728, r_eax)
    r_eax = ru(M, 8214368)
    wu(M, 8216732, r_eax)
    r_eax = ru(M, 8214372)
    wu(M, 8216736, r_eax)
    r_eax = ru(M, 8214376)
    wu(M, 8216740, r_eax)
    r_eax = ru(M, 8214380)
    wu(M, 8216744, r_eax)
    r_eax = ru(M, 8214384)
    wu(M, 8216748, r_eax)
    r_eax = ru(M, 8214388)
    wu(M, 8216752, r_eax)
    r_eax = ru(M, 8214352)
    wu(M, 8211988, r_eax)
    f1 = rf(M, 8214440)
    f1 = f1 * rf(M, 8218820)
    wfd(8216756, f1)
    r_eax = ru(M, 8214288)
    wu(M, 8211992, r_eax)
    r_eax = ru(M, 8215016)
    wu(M, 8216760, r_eax)
    r_eax = ru(M, 8214492)
    wu(M, 8216764, r_eax)
    r_eax = ru(M, 8214496)
    wu(M, 8216768, r_eax)
    r_eax = ru(M, 8214500)
    wu(M, 8216772, r_eax)
    r_eax = ru(M, 8214456)
    wu(M, 8216776, r_eax)
    r_eax = ru(M, 8214460)
    wu(M, 8216780, r_eax)
    r_eax = ru(M, 8214464)
    wu(M, 8216784, r_eax)
    r_eax = ru(M, 8214468)
    wu(M, 8216788, r_eax)
    r_eax = ru(M, 8214472)
    wu(M, 8216792, r_eax)
    r_eax = ru(M, 8214476)
    wu(M, 8216796, r_eax)
    r_eax = ru(M, 8214480)
    wu(M, 8216800, r_eax)
    r_eax = ru(M, 8214484)
    wu(M, 8216804, r_eax)
    r_eax = ru(M, 8214488)
    wu(M, 8216808, r_eax)
    r_eax = ru(M, 8214504)
    wu(M, 8216812, r_eax)
    r_eax = ru(M, 8214508)
    wu(M, 8216816, r_eax)
    r_eax = ru(M, 8214512)
    wu(M, 8216820, r_eax)
    r_eax = ru(M, 8214520)
    wu(M, 8216824, r_eax)
    r_eax = ru(M, 8214524)
    wu(M, 8216828, r_eax)
    r_eax = ru(M, 8214528)
    wu(M, 8216832, r_eax)
    r_eax = ru(M, 8214532)
    wu(M, 8216836, r_eax)
    r_eax = ru(M, 8214536)
    wu(M, 8216840, r_eax)
    r_eax = ru(M, 8214540)
    wu(M, 8216844, r_eax)
    r_eax = ru(M, 8214544)
    wu(M, 8216848, r_eax)
    r_eax = ru(M, 8214548)
    wu(M, 8216852, r_eax)
    r_eax = ru(M, 8214552)
    wu(M, 8216856, r_eax)
    r_eax = ru(M, 8214516)
    wu(M, 8211996, r_eax)
    f1 = rf(M, 8214604)
    f1 = f1 * rf(M, 8218812)
    wfd(8216860, f1)
    r_eax = ru(M, 8214452)
    wu(M, 8212000, r_eax)
    r_eax = ru(M, 8214628)
    wu(M, 8212004, r_eax)
    r_eax = ru(M, 8214632)
    wu(M, 8212012, r_eax)
    r_eax = ru(M, 8214636)
    wu(M, 8212020, r_eax)
    r_eax = ru(M, 8214676)
    wu(M, 8216864, r_eax)
    r_eax = ru(M, 8214680)
    wu(M, 8216868, r_eax)
    r_eax = ru(M, 8214684)
    wu(M, 8216872, r_eax)
    r_eax = ru(M, 8214640)
    wu(M, 8216876, r_eax)
    r_eax = ru(M, 8214644)
    wu(M, 8216880, r_eax)
    r_eax = ru(M, 8214648)
    wu(M, 8216884, r_eax)
    r_eax = ru(M, 8214652)
    wu(M, 8216888, r_eax)
    r_eax = ru(M, 8214656)
    wu(M, 8216892, r_eax)
    r_eax = ru(M, 8214660)
    wu(M, 8216896, r_eax)
    r_eax = ru(M, 8214664)
    wu(M, 8216900, r_eax)
    r_eax = ru(M, 8214668)
    wu(M, 8216904, r_eax)
    r_eax = ru(M, 8214672)
    wu(M, 8216908, r_eax)
    r_eax = ru(M, 8214688)
    wu(M, 8216912, r_eax)
    r_eax = ru(M, 8214692)
    wu(M, 8216916, r_eax)
    r_eax = ru(M, 8214696)
    wu(M, 8216920, r_eax)
    r_eax = ru(M, 8214700)
    wu(M, 8216924, r_eax)
    r_eax = ru(M, 8214704)
    wu(M, 8216928, r_eax)
    r_eax = ru(M, 8214708)
    wu(M, 8216932, r_eax)
    r_eax = ru(M, 8214712)
    wu(M, 8216936, r_eax)
    r_eax = ru(M, 8214716)
    wu(M, 8216940, r_eax)
    r_eax = ru(M, 8214720)
    wu(M, 8216944, r_eax)
    r_eax = ru(M, 8214724)
    wu(M, 8216948, r_eax)
    r_eax = ru(M, 8214728)
    wu(M, 8216952, r_eax)
    r_eax = ru(M, 8214732)
    wu(M, 8216956, r_eax)
    f1 = rf(M, 8214796)
    f1 = f1 * rf(M, 8218832)
    wfd(8216960, f1)
    f1 = rf(M, 8214800)
    f1 = f1 * rf(M, 8218832)
    wfd(8216964, f1)
    f1 = rf(M, 8214804)
    f1 = f1 * rf(M, 8218832)
    wfd(8216968, f1)
    r_eax = ru(M, 8214616)
    wu(M, 8212008, r_eax)
    r_eax = ru(M, 8214620)
    wu(M, 8212016, r_eax)
    r_eax = ru(M, 8214624)
    wu(M, 8212024, r_eax)
    r_eax = ru(M, 8215040)
    wu(M, 8216972, r_eax)
    r_eax = ru(M, 8215044)
    wu(M, 8216976, r_eax)
    r_eax = ru(M, 8215048)
    wu(M, 8216980, r_eax)
  end
  JIT[0xeb99d8] = function() -- commit
    C1()
    C2()
    C3()
    C4()
  end
end
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
-- controls: {throttle, brake, clutch(engagement), steer(road-wheel rad, + left), shiftUp, shiftDown}
-- contacts: 4 planes {nx,ny,nz,d,gvx,gvy,gvz,surface,grip} or function(phase) -> planes
function M:step(controls,contacts) self.V.drive(controls,contacts) end
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
module("Core","CupTune",[=[
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
    -- steering: PROVISIONAL until Stage 12 recovers 00552720 shaping, pow linearity and the
    -- 00554fb0 ratio. Same slew/speed-reduction law as the validated Stage 5 bench.
    steering=U.copy(Base.steering),
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
module("Roblox","CupChassisAdapter",[=[
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

function M:initialize()
    self.origin=self:groundOrigin(self.spawn)
    self.core:reset()
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
    local controls={throttle=U.clamp(input.throttle or 0,0,1),brake=U.clamp(input.brake or 0,0,1),
        clutch=1-U.clamp(input.clutch or 0,0,1),steer=-self.steerAngle}
    if frame and self.pendingShift~=0 then
        controls.shiftUp=self.pendingShift>0;controls.shiftDown=self.pendingShift<0;self.pendingShift=0
    end
    self.core:step(controls,self.contactFn)
    self:pose(false)
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
        wheels[j]={name=c.name,load=self.inContact[j] and fz or 0,compression=travel,
            slip=(w.rate*self.tune.wheelRadius-forward)/math.max(math.abs(forward),2),
            omega=w.rate,temperature=self.tune.environment.ambientC,grounded=self.inContact[j],
            surface=self.planes[j][8],out1={fx,fy,fz}}
    end
    local gear=self.core:gearIndex()
    return {speed=linear.Magnitude*self.tune.metresPerStud*3.6,rpm=self.core:engineRpm(),
        gear=Vehicle.displayGear(gear),gearIndex=gear,wheels=wheels,torque=0,
        clutchSlip=st[35]-st[37],limiter=self.core:revLimiter(),
        throttleIn=thr,brakeIn=brk,clutchIn=clu,lfSteer=lf,rfSteer=rf,
        droppedTime=0,fault=self.fault,mode="NR2003_CUP",tick=self.core:tick(),backlog=self.runner.accumulator,
        chassisStateCount=45,chassisIntegration="NR2003 original JIT (005b39a0/005b3180/005b3e50/005b2fb0)",
        collision=self.collision==true,
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
module("Roblox","ModeConfig",[=[
return {
    mode="NR2003_CUP", -- stage 6/7: original NR2003 Cup 45-state core. "NR2003_CORE" = stage 5 numeric chassis; "ROBLOX_ADAPTER" = prior bench.
}
]=])
module("Roblox","Stage67SelfTest",[=[
-- Stage 6/7 Studio self-test (edit mode or Play, server side). Golden values embedded below were
-- produced by the ORIGINAL NR2003.exe code (Unicorn, recovery/stage6_7/gen_fixtures.py).
--   require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage67SelfTest).run()        -- quick (~1-3 s)
--   require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage67SelfTest).run(true)    -- full (2 x 2304 ticks)
local Core=script.Parent.Parent.Core
local Vehicle=require(Core.NR2003CupVehicle)
local G={
raw={early={[1]={-4.122151509022842e-09,0.0074640740640461445,-5.1489287500317005e-08,0.00021264172391965985,0.4195873737335205,-0.11125531047582626,5.662935791406198e-07,-2.459541974531021e-06,8.285599761848061e-09,0.9999999403953552,0.0005875946371816099,-0.000926259090192616,0.00013678873074240983,0.0009643075754866004,0.727545976638794,0.0,0.0,2.7353273708285997e-06,0.00013858600868843496,0.0009659883799031377,0.7282822728157043,0.0,0.0,2.728124627537909e-06,0.00014002987882122397,0.0007069737766869366,0.9643265604972839,-1.0768936817839858e-06,-0.0005659053567796946,9.744161388880457e-07,0.00018696159531828016,9.743436066855793e-07,0.00018690507567953318,0.0046763950958848,1.345933437347412,-8.653222721477505e-06,-0.0008391092997044325,4.384708972793305e-06,0.0008411999442614615,1.933614839799702e-06,-0.007126148324459791,4.96531356475316e-07,1.090277964976849e-05,0.0003804502484854311,0.09194210171699524},[2]={5.0385340728098527e-05,0.02051515504717827,1.460520593354886e-06,0.0006659216596744955,0.41914084553718567,-0.128971666097641,2.1717485196859343e-06,3.170319189393922e-07,4.726907718577422e-07,0.9999999403953552,0.0012659355998039246,0.009760855697095394,0.00040925201028585434,0.00525352917611599,1.6618891954421997,0.0,0.0,1.67494363267906e-05,0.04430530592799187,0.005258993245661259,1.663288950920105,0.0,0.0,1.7060541722457856e-05,0.044589295983314514,0.006755010224878788,2.392920732498169,-4.167686711298302e-06,-0.0012111898977309465,-3.517125605867477e-06,-0.005173029378056526,-3.5175096400053008e-06,-0.005173138342797756,0.01051681861281395,2.0175912380218506,-1.0394246601208579e-05,-0.0001601166877662763,-1.5827929018996656e-05,-0.023278875276446342,-4.999448356102221e-05,-0.02346392348408699,2.165019736821705e-07,-0.00017201181617565453,0.0007301322766579688,0.08950424939393997},[3]={0.00014111991913523525,0.030756859108805656,4.632952823158121e-06,0.001193631673231721,0.4187012314796448,-0.10728424787521362,4.987244665244361e-06,3.166465103277005e-05,1.4327945336845005e-06,0.9999998807907104,0.002024392830207944,0.02994164451956749,0.0007221379200927913,0.012383460998535156,2.310955762863159,0.0,0.0,0.0005392637103796005,0.28396153450012207,0.012394892051815987,2.3130505084991455,0.0,0.0,0.0005419960361905396,0.2854534387588501,0.017206372693181038,3.4717049598693848,-9.53133621806046e-06,-0.0019310335628688335,-4.8586760385660455e-05,-0.03077993169426918,-4.835521394852549e-05,-0.030626613646745682,0.018687494099140167,2.688201665878296,-9.71443751041079e-06,0.0005980832502245903,-0.00021811942860949785,-0.1381647139787674,-0.0001596938236616552,-0.03953711315989494,-7.35917183192214e-07,-0.00038289668736979365,0.0010027135722339153,0.052492301911115646},[4]={0.00026277024880982935,0.03845495730638504,9.785690963326488e-06,0.0018003981094807386,0.4183931052684784,-0.06114235147833824,9.215345926349983e-06,0.00010351991659263149,2.9750599424005486e-06,0.9999998807907104,0.0029025485273450613,0.055949002504348755,0.0010745699983090162,0.021249225363135338,2.676208019256592,0.0,0.0,0.002260716399177909,0.6905588507652283,0.021269267424941063,2.679080009460449,0.0,0.0,0.0022732028737664223,0.6988389492034912,0.03081957995891571,4.213775157928467,-1.7608650523470715e-05,-0.002775046741589904,-0.0002901255793403834,-0.12608270347118378,-0.00028886651853099465,-0.12558390200138092,0.029184911400079727,3.3578062057495117,-6.2119461290421896e-06,0.0014749225229024887,-0.0013027321547269821,-0.5662497878074646,-0.00032265318441204727,-0.05406928434967995,-2.464393901391304e-06,-0.000607346766628325,0.0011015177005901933,-0.0011626308551058173},[5]={0.00040808398625813425,0.046742863953113556,1.7143598597613163e-05,0.0024373261258006096,0.41827353835105896,-0.0011694132117554545,1.5066182641021442e-05,0.0002251840487588197,5.148897798790131e-06,0.9999998807907104,0.003915119916200638,0.08648448437452316,0.0014641236048191786,0.030938133597373962,2.7775533199310303,0.0,0.0,0.005497547332197428,0.8678514361381531,0.030969521030783653,2.781552791595459,0.0,0.0,0.005558917764574289,0.8618438839912415,0.0464404821395874,4.618095397949219,-2.880827014450915e-05,-0.0037652908358722925,-0.001042450312525034,-0.38535818457603455,-0.0010383863700553775,-0.38400015234947205,0.04200558736920357,4.026421546936035,5.296267886478745e-07,0.0024849618785083294,-0.004681881982833147,-1.7310560941696167,-0.0005343868979252875,-0.0696183368563652,-4.959986654284876e-06,-0.0007900012424215674,0.0009996992303058505,-0.05960458889603615},[6]={0.0005831600865349174,0.05570746958255768,2.6513587727095e-05,0.002740010619163513,0.41838207840919495,0.067654550075531,2.2675883883493952e-05,0.0004028615076094866,7.922648364910856e-06,0.9999998807907104,0.00473381020128727,0.11950001120567322,0.0016589717706665397,0.04052237421274185,2.618514060974121,0.0,0.0,0.009162009693682194,0.9484943151473999,0.040568575263023376,2.623297929763794,0.0,0.0,0.009276307187974453,0.9482343196868896,0.06287889927625656,4.685423374176025,-4.3455140257719904e-05,-0.004595473874360323,-0.0031320045236498117,-0.9303044080734253,-0.003120612120255828,-0.9271130561828613,0.05714590102434158,4.693721771240234,1.0778159776236862e-05,0.0032998048700392246,-0.014068386517465115,-4.179189205169678,-0.0008007421856746078,-0.08502450585365295,-7.854975592636038e-06,-0.0006974710267968476,0.0006916215643286705,-0.11407651007175446},[7]={0.0007927603437565267,0.05557771027088165,3.623279553721659e-05,0.002774170832708478,0.4187394082546234,0.13853096961975098,3.159585321554914e-05,0.0006392077775672078,1.0884117727982812e-05,0.9999997615814209,0.005537329241633415,0.15240375697612762,0.0017209617653861642,0.049131885170936584,2.300039768218994,0.0,0.0,0.012515119276940823,0.9392794370651245,0.049195870757102966,2.3053770065307617,0.0,0.0,0.012674359604716301,0.9522192478179932,0.07898690551519394,4.447874546051025,-6.098524681874551e-05,-0.005454561207443476,-0.0075914738699793816,-0.9044880867004395,-0.007564859464764595,-0.9011744260787964,0.07460106164216995,5.359888553619385,2.3632810552953742e-05,0.004098498262465,-0.03410174697637558,-4.062740802764893,-0.0011214087717235088,-0.08869709074497223,-9.81057200988289e-06,-0.00035395799204707146,0.0002100378042086959,-0.14723661541938782},[8]={0.000997485825791955,0.05620179325342178,4.5852826588088647e-05,0.0027669770643115044,0.4193445146083832,0.2089644819498062,4.12084482377395e-05,0.0009327036095783114,1.3879346624889877e-05,0.9999995231628418,0.006026067771017551,0.1840021163225174,0.0017217332497239113,0.05649954453110695,1.9387027025222778,0.0,0.0,0.015683451667428017,0.8873845338821411,0.05658070743083954,1.9439492225646973,0.0,0.0,0.01588762365281582,0.9003190398216248,0.09375738352537155,3.957096815109253,-7.994892803253606e-05,-0.005823091603815556,-0.0122267697006464,-1.3375111818313599,-0.012184548191726208,-1.3330166339874268,0.09436596184968948,6.024624347686768,3.785535227507353e-05,0.004581898916512728,-0.05492546409368515,-6.0086870193481445,-0.0014481787802651525,-0.09155792742967606,-1.0965722140099388e-05,-0.00011220778105780482,-0.00035180579288862646,-0.16035225987434387}},rows={[36]={orig={0.0031756837852299213,-0.007108821999281645,0.00037118440377525985,0.005342038813978434,0.464337557554245,0.2590957283973694},pert={0.003175684018060565,-0.0071089426055550575,0.0003711856552399695,0.005342111922800541,0.4643375277519226,0.25909513235092163}},[72]={orig={0.004252929240465164,0.009517446160316467,0.0011116473469883204,0.004263155162334442,0.45713627338409424,-0.31272590160369873},pert={0.004252918995916843,0.009514186531305313,0.001111655030399561,0.004263367038220167,0.45713621377944946,-0.31272533535957336}},[108]={orig={0.005457060877233744,0.02245967835187912,0.0016287552425637841,0.004783059470355511,0.4079051613807678,-0.25723305344581604},pert={0.005640298593789339,0.025664186105132103,0.0018094895640388131,0.003335353219881654,0.40789923071861267,-0.2575279474258423}},[144]={orig={0.006317915860563517,0.015440179966390133,0.0018480134895071387,0.0002608306531328708,0.3991178274154663,0.06401488929986954},pert={0.007197629194706678,0.022613337263464928,0.0018921921728178859,-0.00039729723357595503,0.399072527885437,0.06409197300672531}},[180]={orig={0.006697169970721006,0.027929123491048813,0.002393353497609496,0.006202030926942825,0.41043755412101746,0.08501119911670685},pert={0.007970722392201424,0.022197211161255836,0.0022896169684827328,0.004765135236084461,0.4104243218898773,0.08347994089126587}},[216]={orig={0.007509745191782713,0.025602709501981735,0.0028910799883306026,0.0022283215075731277,0.41666167974472046,0.007923728786408901},pert={0.008976515382528305,0.02420467510819435,0.002960141049697995,0.005083243362605572,0.4164666533470154,0.009342732839286327}},[252]={orig={0.007998848333954811,0.029327677562832832,0.002997871721163392,0.00032397921313531697,0.4166351556777954,0.0062676649540662766},pert={0.01037153135985136,0.024846917018294334,0.0035235313698649406,0.004035989288240671,0.41636210680007935,0.009287833236157894}},[288]={orig={0.009138679131865501,0.021437568590044975,0.002569496165961027,-0.004719353746622801,0.41722947359085083,0.006850570905953646},pert={0.010914103128015995,0.02692665345966816,0.003654445754364133,0.00024394669162575155,0.417232871055603,0.006984945852309465}},[324]={orig={0.05756797641515732,0.7511472105979919,0.0003288450825493783,-0.02194364182651043,0.42223256826400757,0.0570279061794281},pert={0.05996103584766388,0.7642740607261658,0.0014483175473287702,-0.012767614796757698,0.4222427308559418,0.057025451213121414}},[360]={orig={0.1981009989976883,1.4962425231933594,-0.0004542585520539433,0.003583705984055996,0.42524799704551697,-0.013517125509679317},pert={0.20196937024593353,1.515607476234436,0.001183300162665546,0.006688043009489775,0.4248941242694855,-0.014205669984221458}},[396]={orig={0.43206357955932617,2.264070987701416,-6.305898568825796e-05,0.004545422270894051,0.4235735535621643,-0.012966375797986984},pert={0.43814951181411743,2.2630438804626465,0.0018480109283700585,0.003121341811493039,0.42342761158943176,-0.01656964421272278}},[432]={orig={0.7613994479179382,3.0402159690856934,0.0006545076030306518,0.0031818205025047064,0.42282772064208984,-0.00470166839659214},pert={0.7688446640968323,3.0454320907592773,0.0021966202184557915,-0.002331389579921961,0.4229188859462738,-0.0014919760869815946}},[468]={orig={1.188980221748352,3.814605236053467,0.0005358920316211879,-0.0005646882927976549,0.4225747883319855,-0.004480058327317238},pert={1.19705331325531,3.8227951526641846,0.0029313284903764725,0.0068784006871283054,0.42303702235221863,-0.004196243826299906}},[504]={orig={1.716318964958191,4.628135681152344,0.0006931278039701283,0.002058313926681876,0.4230935573577881,-0.003820550860837102},pert={1.725221037864685,4.6531782150268555,0.003999279346317053,0.007204684428870678,0.42306703329086304,-0.0018788543529808521}},[540]={orig={2.347928524017334,5.460864543914795,0.001517589669674635,0.01384335570037365,0.42315202951431274,-0.007691131439059973},pert={2.3573737144470215,5.491568565368652,0.00518070999532938,0.009160822257399559,0.42304956912994385,-0.0027769170701503754}},[576]={orig={3.0851848125457764,6.347022533416748,0.00379356206394732,0.02343427762389183,0.4228590428829193,-0.002692100591957569},pert={3.0970869064331055,6.352250576019287,0.0063979835249483585,0.009837040677666664,0.42301663756370544,-0.0034364520106464624}},[612]={orig={3.930852174758911,7.193730354309082,0.007479082327336073,0.0315227285027504,0.42307594418525696,-0.0028255744837224483},pert={3.942434787750244,7.201690673828125,0.008097946643829346,0.017342273145914078,0.4228879511356354,0.00025451689725741744}},[648]={orig={4.8845038414001465,8.085124969482422,0.011307327076792717,0.029104091227054596,0.4233608543872833,0.0037619632203131914},pert={4.897265434265137,8.090482711791992,0.010910805314779282,0.02729867957532406,0.4234294593334198,0.0016488776309415698}},[684]={orig={5.951437473297119,9.003937721252441,0.014979085884988308,0.030818307772278786,0.423813134431839,0.0016439593164250255},pert={5.96533203125,9.012760162353516,0.014827938750386238,0.03472478315234184,0.42385539412498474,0.002482850104570389}},[720]={orig={7.135684967041016,9.957257270812988,0.019471658393740654,0.041514258831739426,0.42425185441970825,0.001498386263847351},pert={7.150701522827148,9.967798233032227,0.01959053799510002,0.04151555523276329,0.4242364168167114,0.0018738098442554474}},[756]={orig={8.441472053527832,10.948272705078125,0.0254095196723938,0.05314560979604721,0.4246137738227844,0.0021183991339057684},pert={8.457746505737305,10.95779037475586,0.025351129472255707,0.0508480928838253,0.4246152341365814,0.001557733048684895}},[792]={orig={9.87330150604248,11.974578857421875,0.03279946744441986,0.0651363804936409,0.42495015263557434,0.0016761336009949446},pert={9.89089584350586,11.985269546508789,0.03243810683488846,0.06268731504678726,0.42495888471603394,0.0018227797700092196}},[828]={orig={11.435837745666504,13.038309097290039,0.041829995810985565,0.07958149909973145,0.42529043555259705,0.001542681478895247},pert={11.454766273498535,13.049468040466309,0.041158925741910934,0.07704522460699081,0.4252835512161255,0.0016691056080162525}},[864]={orig={13.133697509765625,14.139476776123047,0.05286529287695885,0.09731137007474899,0.4256036877632141,0.0016721152933314443},pert={13.154030799865723,14.150700569152832,0.05186544731259346,0.09457632899284363,0.42560359835624695,0.0015475936233997345}},[900]={orig={14.971415519714355,15.275089263916016,0.0663604587316513,0.1190701425075531,0.4258979558944702,0.0014431102899834514},pert={14.993195533752441,15.286860466003418,0.06500644236803055,0.11614332348108292,0.4258991479873657,0.0014839513460174203}},[936]={orig={16.953067779541016,16.440677642822266,0.0828852653503418,0.1459565907716751,0.42615747451782227,0.0011962243588641286},pert={16.9763240814209,16.452655792236328,0.08115408569574356,0.14284829795360565,0.4261566698551178,0.0012133322888985276}},[972]={orig={19.081859588623047,17.62645149230957,0.1031545102596283,0.17895258963108063,0.4263627529144287,0.000909483409486711},pert={19.106626510620117,17.638532638549805,0.1010238379240036,0.17566272616386414,0.42636287212371826,0.0008938966202549636}},[1008]={orig={21.35940170288086,18.816621780395508,0.1279469132423401,0.2189994901418686,0.4264892041683197,0.00020751652482431382},pert={21.38568115234375,18.82866859436035,0.1253954917192459,0.21556927263736725,0.4264887273311615,0.0002033267228398472}},[1044]={orig={23.785005569458008,19.9920597076416,0.1584763377904892,0.27153873443603516,0.42649590969085693,-0.0007565327105112374},pert={23.81277084350586,20.00385856628418,0.15549017488956451,0.26802361011505127,0.42649421095848083,-0.0007617122028023005}},[1080]={orig={26.355905532836914,21.139543533325195,0.19665749371051788,0.34308457374572754,0.4263887107372284,-0.0014617322012782097},pert={26.385129928588867,21.151039123535156,0.1932317316532135,0.33959051966667175,0.4263863265514374,-0.001469006878323853}},[1116]={orig={29.068313598632812,22.255985260009766,0.24561931192874908,0.44700589776039124,0.42619621753692627,-0.0018681418150663376},pert={29.09895896911621,22.267189025878906,0.24176755547523499,0.44372501969337463,0.4261934161186218,-0.0018670185236260295}},[1152]={orig={31.91858673095703,23.345706939697266,0.3107410669326782,0.6078914999961853,0.42598018050193787,-0.0018680604407563806},pert={31.95062255859375,23.356693267822266,0.3065110146999359,0.6052199602127075,0.42597758769989014,-0.0018597955349832773}},[1188]={orig={34.90245056152344,24.389482498168945,0.42052966356277466,1.2096385955810547,0.4254812002182007,-0.006148269400000572},pert={34.935848236083984,24.4002685546875,0.41601431369781494,1.2078053951263428,0.4254797697067261,-0.006130790803581476}},[1224]={orig={38.004920959472656,25.16813087463379,0.6299493312835693,2.1886513233184814,0.42492637038230896,-0.009227193892002106},pert={38.03959274291992,25.17824935913086,0.6252732276916504,2.187828779220581,0.42492297291755676,-0.009241163730621338}},[1260]={orig={41.182247161865234,25.643163681030273,0.9742816090583801,3.334416151046753,0.42371219396591187,-0.004707811400294304},pert={41.21818161010742,25.6530818939209,0.9695867896080017,3.335017681121826,0.42371585965156555,-0.004669199697673321}},[1296]={orig={44.41156768798828,26.016603469848633,1.4650242328643799,4.522036552429199,0.4235695004463196,0.0015209171688184142},pert={44.44870376586914,26.025606155395508,1.46051824092865,4.524554252624512,0.4235725700855255,0.0015165363438427448}},[1332]={orig={47.68370819091797,26.328811645507812,2.105544090270996,5.728582859039307,0.4238092005252838,0.001202908344566822},pert={47.721900939941406,26.336524963378906,2.1014938354492188,5.733425140380859,0.4238116443157196,0.0012011770159006119}},[1368]={orig={50.9912109375,26.582555770874023,2.8977668285369873,6.948173522949219,0.4239666163921356,0.0011212340323254466},pert={51.0302619934082,26.588531494140625,2.8944878578186035,6.95576286315918,0.4239698648452759,0.0011259738821536303}},[1404]={orig={54.32682418823242,26.778791427612305,3.8427796363830566,8.172661781311035,0.4240615665912628,0.0007253264775499701},pert={54.36648178100586,26.782651901245117,3.8406455516815186,8.183454513549805,0.424066424369812,0.0007383024785667658}},[1440]={orig={57.68342208862305,26.918563842773438,4.9409050941467285,9.39727783203125,0.4241172969341278,0.00024761646636761725},pert={57.72341537475586,26.919841766357422,4.940335273742676,9.41154670715332,0.42412322759628296,0.00025902557536028326}},[1476]={orig={61.05400848388672,27.002639770507812,6.191964149475098,10.61896800994873,0.42414286732673645,4.9780144763644785e-05},pert={61.093990325927734,27.0009765625,6.193401336669922,10.636871337890625,0.4241500198841095,5.305872036842629e-05}},[1512]={orig={64.4316635131836,27.031709671020508,7.5954084396362305,11.835176467895508,0.4241412878036499,-4.610100950230844e-05},pert={64.47122192382812,27.02679443359375,7.599318027496338,11.856817245483398,0.4241497814655304,-3.892144013661891e-05}},[1548]={orig={67.80946350097656,27.00589942932129,9.15041732788086,13.04392147064209,0.424121618270874,-0.00020482410036493093},pert={67.84818267822266,26.997478485107422,9.157261848449707,13.069160461425781,0.4241308867931366,-0.00019642416737042367}},[1584]={orig={71.1805648803711,26.924640655517578,10.855995178222656,14.244452476501465,0.42409011721611023,-0.0008205033373087645},pert={71.21806335449219,26.912630081176758,10.866207122802734,14.272964477539062,0.42409977316856384,-0.0008229357772506773}},[1620]={orig={74.4776840209961,25.686195373535156,12.646088600158691,14.268499374389648,0.4203173816204071,-0.054116807878017426},pert={74.51359558105469,25.674001693725586,12.660215377807617,14.301647186279297,0.4203282296657562,-0.05423765629529953}},[1656]={orig={77.58786010742188,24.113428115844727,14.419496536254883,14.159382820129395,0.4183790683746338,0.029830116778612137},pert={77.62218475341797,24.098966598510742,14.43762493133545,14.191811561584473,0.41841164231300354,0.030177561566233635}},[1692]={orig={80.51416778564453,22.695676803588867,16.181995391845703,14.015641212463379,0.4236077666282654,0.02113592065870762},pert={80.5466537475586,22.681541442871094,16.20436668395996,14.050168991088867,0.42365124821662903,0.02091192454099655}},[1728]={orig={83.25457000732422,21.166967391967773,17.92373275756836,13.87930965423584,0.4246234893798828,0.0030370005406439304},pert={83.2851791381836,21.150806427001953,17.95036506652832,13.913983345031738,0.42464926838874817,0.003001570235937834}},[1764]={orig={85.80664825439453,19.662273406982422,19.652931213378906,13.78329849243164,0.42512816190719604,0.005215369164943695},pert={85.83523559570312,19.645448684692383,19.683956146240234,13.81851863861084,0.4251437783241272,0.005194159224629402}},[1800]={orig={88.1698226928711,18.150604248046875,21.36910057067871,13.672826766967773,0.42563191056251526,0.003481096588075161},pert={88.19627380371094,18.13357925415039,21.40450668334961,13.707727432250977,0.4256460964679718,0.0034427724312990904}},[1836]={orig={90.34424591064453,16.645484924316406,23.069744110107422,13.531778335571289,0.42603370547294617,0.0025357163976877928},pert={90.36870574951172,16.629045486450195,23.109453201293945,13.56572151184082,0.42604246735572815,0.0024685279931873083}},[1872]={orig={92.33154296875,15.156017303466797,24.750263214111328,13.348441123962402,0.4262983798980713,0.0017267029033973813},pert={92.35398864746094,15.140083312988281,24.794116973876953,13.380356788635254,0.42630115151405334,0.0017394046299159527}},[1908]={orig={94.13298034667969,13.666092872619629,26.40375518798828,13.092941284179688,0.4265773594379425,0.0032675222028046846},pert={94.15338134765625,13.648526191711426,26.451322555541992,13.120052337646484,0.4265953600406647,0.0033729588612914085}},[1944]={orig={95.74708557128906,12.161500930786133,28.019454956054688,12.74204158782959,0.42697006464004517,0.002503348747268319},pert={95.76525115966797,12.143317222595215,28.070058822631836,12.76307487487793,0.42698320746421814,0.002452979562804103}},[1980]={orig={97.17310333251953,10.659295082092285,29.58449935913086,12.279634475708008,0.4272950291633606,0.002795378677546978},pert={97.18899536132812,10.641566276550293,29.63726806640625,12.293184280395508,0.427312433719635,0.0027925886679440737}},[2016]={orig={98.4125747680664,9.181093215942383,31.08446502685547,11.702840805053711,0.4276235103607178,0.002276176353916526},pert={98.42638397216797,9.165966033935547,31.13850212097168,11.709806442260742,0.4276360273361206,0.002158280462026596}},[2052]={orig={99.47059631347656,7.761385440826416,32.505645751953125,11.015921592712402,0.4278218150138855,0.001304512727074325},pert={99.4828109741211,7.751539707183838,32.56005859375,11.014636039733887,0.42782580852508545,0.001335561042651534}},[2088]={orig={100.35615539550781,6.424168109893799,33.832489013671875,10.189948081970215,0.428008496761322,0.0016468388494104147},pert={100.36752319335938,6.420238971710205,33.88611602783203,10.178853034973145,0.42801642417907715,0.0016445947112515569}},[2124]={orig={101.08010864257812,5.178073406219482,35.0472297668457,9.22471809387207,0.4281817674636841,0.0009652414009906352},pert={101.09137725830078,5.1806793212890625,35.098941802978516,9.205204963684082,0.42818132042884827,0.0008866111165843904}},[2160]={orig={101.6549301147461,4.041374206542969,36.13311004638672,8.129693984985352,0.42826998233795166,0.00047768448712304235},pert={101.6670150756836,4.051830291748047,36.18191146850586,8.102995872497559,0.42826229333877563,0.0004073084273841232}},[2196]={orig={102.09566497802734,3.036221981048584,37.07463836669922,6.917527675628662,0.42829322814941406,-0.0001657398242969066},pert={102.10960388183594,3.055546522140503,37.119747161865234,6.88546085357666,0.4282743036746979,-0.0002990582725033164}},[2232]={orig={102.41996765136719,2.1815602779388428,37.858062744140625,5.602401256561279,0.42820122838020325,-0.0013234402285888791},pert={102.43690490722656,2.2103114128112793,37.89895248413086,5.56699800491333,0.4281625747680664,-0.0014987282920628786}},[2268]={orig={102.64772033691406,1.4935404062271118,38.47148895263672,4.2017645835876465,0.4279448688030243,-0.0028921940829604864},pert={102.66883850097656,1.5312674045562744,38.50788879394531,4.166541576385498,0.42787986993789673,-0.003141156630590558}},[2304]={orig={102.79924774169922,0.9321352243423462,38.90678024291992,2.741770029067993,0.4274486005306244,-0.005607328377664089},pert={102.82537078857422,0.9689283967018127,38.93901824951172,2.7077322006225586,0.4273456633090973,-0.006132061127573252}}}},
drive={early={[1]={-4.122151509022842e-09,0.007460855878889561,-5.148927328946229e-08,0.00021360036043915898,0.4195873737335205,-0.11125460267066956,5.662935791406198e-07,-2.459541974531021e-06,8.285638841698528e-09,0.9999999403953552,0.0005885791033506393,-0.0009264252730645239,0.00013720060815103352,0.0009643075754866004,0.7276791334152222,-0.002240143483504653,0.0,2.7340929591446184e-06,0.00013779503933619708,0.0009659883799031377,0.7284149527549744,0.002240143483504653,0.0,2.729390644162777e-06,0.00014116131933405995,0.0007069737766869366,0.9643256664276123,-1.0768936817839858e-06,-0.0005668463418260217,9.744161388880457e-07,0.00018715005717240274,9.743436066855793e-07,0.00018709342111833394,0.003740744199603796,0.807286262512207,0.0013948226114735007,0.8072862029075623,4.384708972793305e-06,0.0008420477970503271,1.933614839799702e-06,-0.007122861687093973,4.96531356475316e-07,1.032755335472757e-05,0.0003804502484854311,0.09194137901067734},[2]={5.036255606682971e-05,0.020504947751760483,1.4671493318019202e-06,0.0006687923450954258,0.41914084553718567,-0.12896722555160522,2.1751384338131174e-06,3.1607149253432e-07,4.74116518489609e-07,0.9999999403953552,0.0012688759015873075,0.009759224951267242,0.00041050175786949694,0.005254440009593964,1.6622604131698608,-0.002240143483504653,0.0,1.666736716288142e-05,0.04425033554434776,0.005259901285171509,1.6636589765548706,0.002240143483504653,0.0,1.699580388958566e-05,0.04454166814684868,0.006755004171282053,2.3929178714752197,-4.174063633399783e-06,-0.001213806914165616,-3.5155671866959892e-06,-0.005172070115804672,-3.5159530398232164e-06,-0.005172177217900753,0.007244730368256569,1.2107059955596924,0.0048988088965415955,1.2107059955596924,-1.582091863383539e-05,-0.023274553939700127,-4.997132418793626e-05,-0.023453539237380028,2.125875795400134e-07,-0.00017365302483085543,0.000730126048438251,0.08950027823448181},[3]={0.00014104887668509036,0.030738694593310356,4.652993084164336e-06,0.0011985520832240582,0.41870126128196716,-0.1072736382484436,4.997481482860167e-06,3.1658695661462843e-05,1.4371153156389482e-06,0.9999998807907104,0.002029424998909235,0.029937531799077988,0.0007242648862302303,0.012386009097099304,2.3115062713623047,-0.002240143483504653,0.0,0.0005387888522818685,0.28376826643943787,0.012397429905831814,2.3135986328125,0.002240143483504653,0.0,0.0005415831692516804,0.2852824330329895,0.017206352204084396,3.4716992378234863,-9.549900823913049e-06,-0.0019357942510396242,-4.8584421165287495e-05,-0.030780499801039696,-4.8351641453336924e-05,-0.030626541003584862,0.012148474343121052,1.6135897636413574,0.009802551940083504,1.6135897636413574,-0.00021810612815897912,-0.13816583156585693,-0.0001596213987795636,-0.03951885923743248,-7.473914251932001e-07,-0.0003855987743008882,0.0010026852833107114,0.05248335376381874},[4]={0.00026262071332894266,0.03842901438474655,9.82669553195592e-06,0.0018077008426189423,0.41839316487312317,-0.061124373227357864,9.236275218427181e-06,0.00010350472439313307,2.9838622594979824e-06,0.9999998807907104,0.0029100545216351748,0.055942293256521225,0.0010776967974379659,0.02125394344329834,2.6768743991851807,-0.002240143483504653,0.0,0.002259213011711836,0.6897976994514465,0.021273963153362274,2.6797430515289307,0.002240143483504653,0.0,0.0022718936670571566,0.6981519460678101,0.03081953339278698,4.213766574859619,-1.7647740605752915e-05,-0.0027821208350360394,-0.0002901304396800697,-0.12608695030212402,-0.0002888658782467246,-0.12558557093143463,0.018450241535902023,2.015977621078491,0.01610432006418705,2.015977621078491,-0.00130274158436805,-0.5662631392478943,-0.00032250277581624687,-0.05404401570558548,-2.4872190351743484e-06,-0.0006111948750913143,0.001101449248380959,-0.0011771073332056403},[5]={0.00040783057920634747,0.046694159507751465,1.72146155819064e-05,0.002447528066113591,0.4182736575603485,-0.001139628584496677,1.5102586075954605e-05,0.0002251548576168716,5.164127742318669e-06,0.9999998807907104,0.003925144672393799,0.08647403120994568,0.001468199072405696,0.030945293605327606,2.7782320976257324,-0.002240143483504653,0.0,0.005492016207426786,0.8684046864509583,0.03097664937376976,2.782224416732788,0.002240143483504653,0.0,0.005553890950977802,0.8629124760627747,0.04644039645791054,4.618078708648682,-2.887823575292714e-05,-0.0037753658834844828,-0.0010424815118312836,-0.3853723704814911,-0.0010384002234786749,-0.3840084373950958,0.026148319244384766,2.4178853034973145,0.023802397772669792,2.4178853034973145,-0.00468198349699378,-1.7311067581176758,-0.0005341367213986814,-0.06957122683525085,-4.998360964236781e-06,-0.0007953819003887475,0.000999570358544588,-0.05962797999382019},[6]={0.0005827438435517251,0.05565148964524269,2.6626616090652533e-05,0.0027527811471372843,0.41838231682777405,0.0676942840218544,2.2733795049134642e-05,0.0004028122057206929,7.946792720758822e-06,0.9999998807907104,0.004747150465846062,0.11948595196008682,0.0016647735610604286,0.040531910955905914,2.6191461086273193,-0.002240143483504653,0.0,0.009153582155704498,0.9486234188079834,0.04057806730270386,2.6239306926727295,0.002240143483504653,0.0,0.009269794449210167,0.9485832452774048,0.06287875771522522,4.685403823852539,-4.356911085778847e-05,-0.004609888419508934,-0.0031321244314312935,-0.9303451180458069,-0.003120685927569866,-0.9271417260169983,0.03524084761738777,2.818986654281616,0.03289492800831795,2.818986415863037,-0.014068822376430035,-4.17934513092041,-0.0008003399125300348,-0.08497393131256104,-7.91463753557764e-06,-0.0007036170572973788,0.0006914057303220034,-0.11410348117351532},[7]={0.0007921488722786307,0.05552176758646965,3.6392040783539414e-05,0.0027873734943568707,0.41873982548713684,0.13857890665531158,3.167870454490185e-05,0.0006391311762854457,1.0919403393927496e-05,0.9999997615814209,0.005551663227379322,0.15238545835018158,0.0017274565761908889,0.04914349690079689,2.30059552192688,-0.002240143483504653,0.0,0.012505066581070423,0.938812792301178,0.04920745640993118,2.3059394359588623,0.002240143483504653,0.0,0.012666174210608006,0.9517406225204468,0.07898668944835663,4.44785737991333,-6.115617725299671e-05,-0.005471053998917341,-0.007591804955154657,-0.9045250415802002,-0.007565089501440525,-0.9011996388435364,0.04572480171918869,3.21945858001709,0.04337887838482857,3.21945858001709,-0.03410301357507706,-4.062880516052246,-0.0011208418291062117,-0.08865265548229218,-9.891144145512953e-06,-0.0003596075112000108,0.00020972899801563472,-0.14725065231323242},[8]={0.000996682676486671,0.05614705756306648,4.60576920886524e-05,0.0027801301330327988,0.41934511065483093,0.20902058482170105,4.131618334213272e-05,0.0009325908613391221,1.3925986422691494e-05,0.9999995231628418,0.006040461827069521,0.18397872149944305,0.0017282584449276328,0.056512944400310516,1.9391751289367676,-0.002240143483504653,0.0,0.015671787783503532,0.8869215250015259,0.05659409984946251,1.9444279670715332,0.002240143483504653,0.0,0.01587778329849243,0.8998463153839111,0.09375711530447006,3.9570817947387695,-8.01787682576105e-05,-0.00583985261619091,-0.012227325700223446,-1.3375742435455322,-0.012184946797788143,-1.3330634832382202,0.05759681388735771,3.6190037727355957,0.05525089055299759,3.6190037727355957,-0.05492761358618736,-6.008934497833252,-0.0014474698109552264,-0.09151982516050339,-1.106474610423902e-05,-0.00011724612704711035,-0.00035216001560911536,-0.16036146879196167}},rows={[36]={orig={0.003170991549268365,-0.007282359059900045,0.00037042671465314925,0.005336641799658537,0.46434709429740906,0.2591182291507721},pert={0.0031709903851151466,-0.007282383274286985,0.000370414782082662,0.005336223170161247,0.4643470346927643,0.2591181993484497},gear=1},[72]={orig={0.00423789955675602,0.01030464842915535,0.0011122791329398751,0.004371364135295153,0.4571365714073181,-0.3130236864089966},pert={0.0042379251681268215,0.010311014950275421,0.001112245605327189,0.004372502211481333,0.45713648200035095,-0.31302523612976074},gear=1},[108]={orig={0.0053904117085039616,0.022370239719748497,0.0020072085317224264,0.0055029201321303844,0.40792158246040344,-0.25724929571151733},pert={0.005398104898631573,0.02248395048081875,0.0019998447969555855,0.005470342934131622,0.40792080760002136,-0.25725245475769043},gear=1},[144]={orig={0.006442841142416,0.011385011486709118,0.002248120028525591,0.002131557324901223,0.3991093337535858,0.06566328555345535},pert={0.006356043741106987,0.01997220329940319,0.002148811239749193,0.001799647114239633,0.399125874042511,0.06441587209701538},gear=1},[180]={orig={0.006932164542376995,0.01224792841821909,0.002718001138418913,0.008909254334867,0.41045740246772766,0.08760612457990646},pert={0.007239422760903835,0.027074726298451424,0.002718723379075527,0.0053756809793412685,0.4104704260826111,0.08435705304145813},gear=1},[216]={orig={0.006603265646845102,0.010121997445821762,0.003198746358975768,0.002252001781016588,0.41642215847969055,0.008518518880009651},pert={0.00846798438578844,0.032229550182819366,0.003053554566577077,-0.0009653994929976761,0.4165998101234436,0.0066002123057842255},gear=1},[252]={orig={0.006418984849005938,0.012501209042966366,0.0033548336941748857,-0.0023843247909098864,0.4162687063217163,0.008225449360907078},pert={0.010319818742573261,0.020254066213965416,0.002697550691664219,-0.0038979214150458574,0.4165564477443695,0.007391430903226137},gear=1},[288]={orig={0.0063361721113324165,0.03472380340099335,0.0034137186594307423,-0.00031350358040072024,0.4170086681842804,0.013812731020152569},pert={0.012380590662360191,0.044832564890384674,0.0024663188960403204,-0.00022255109797697514,0.41691824793815613,0.015371785499155521},gear=2},[324]={orig={0.079219289124012,1.1320645809173584,0.0026920908130705357,0.0007758024730719626,0.4245661795139313,0.08238141983747482},pert={0.08604207634925842,1.1211539506912231,0.001259773736819625,-0.011541671119630337,0.424662321805954,0.07801201939582825},gear=2},[360]={orig={0.24668556451797485,1.4904141426086426,0.0035560429096221924,0.011819111183285713,0.424731969833374,-0.05388174578547478},pert={0.25334641337394714,1.5216997861862183,0.0017106812447309494,0.00902494415640831,0.42475080490112305,-0.05510799214243889},gear=2},[396]={orig={0.45955249667167664,1.8780444860458374,0.004999912343919277,0.006105086300522089,0.4203442931175232,-0.019062556326389313},pert={0.467312216758728,1.8861302137374878,0.0025208406150341034,0.0017860147636383772,0.4202060103416443,-0.018519654870033264},gear=2},[432]={orig={0.7185203433036804,2.241992235183716,0.00594467855989933,0.010480371303856373,0.42000317573547363,-0.0013400419848039746},pert={0.7261648178100586,2.264521837234497,0.0024312506429851055,-0.00028059358010068536,0.4200500249862671,-0.0008140144636854529},gear=2},[468]={orig={1.0243836641311646,2.6063287258148193,0.00763081107288599,0.015455196611583233,0.4202008843421936,-0.004978732671588659},pert={1.031140685081482,2.6077680587768555,0.0026405914686620235,0.0035527662839740515,0.42009955644607544,-0.010793011635541916},gear=1},[504]={orig={1.3518922328948975,2.61818790435791,0.009707516990602016,0.013759590685367584,0.41796380281448364,-0.029382722452282906},pert={1.3571268320083618,2.604501724243164,0.0033354517072439194,0.006913893856108189,0.4175935685634613,-0.03046911582350731},gear=1},[540]={orig={1.7017486095428467,3.257002592086792,0.011904247105121613,0.017347263172268867,0.4185068607330322,0.046399686485528946},pert={1.7068495750427246,3.2652010917663574,0.003924419172108173,0.0020046893041580915,0.41873249411582947,0.054748449474573135},gear=3},[576]={orig={2.130610942840576,3.5797033309936523,0.013879666104912758,0.01757378876209259,0.42134493589401245,-0.022952819243073463},pert={2.136150598526001,3.5838229656219482,0.004590301308780909,0.0031840805895626545,0.42145538330078125,-0.02869456820189953},gear=3},[612]={orig={2.5950682163238525,3.845489501953125,0.01653468608856201,0.024809136986732483,0.4195936322212219,-0.011137235909700394},pert={2.6016898155212402,3.866306781768799,0.0049127512611448765,0.001866260776296258,0.41933995485305786,-0.014152010902762413},gear=3},[648]={orig={3.0963010787963867,4.156344890594482,0.019330624490976334,0.01972692273557186,0.41915202140808105,-0.00737347174435854},pert={3.1040380001068115,4.181087493896484,0.005423258058726788,0.00631449231877923,0.41888755559921265,-0.004145881626754999},gear=3},[684]={orig={3.6358344554901123,4.469631195068359,0.021749086678028107,0.019451450556516647,0.41904112696647644,-0.007905273698270321},pert={3.644073009490967,4.482527732849121,0.006387371104210615,0.008332566358149052,0.4189063608646393,-0.004428017418831587},gear=3},[720]={orig={4.214775562286377,4.792664527893066,0.024492526426911354,0.024128491058945656,0.4187876284122467,-0.006457602139562368},pert={4.223062992095947,4.795269966125488,0.007702073082327843,0.012914136052131653,0.4187805652618408,-0.005112085957080126},gear=3},[756]={orig={4.831677436828613,5.071245193481445,0.0280013270676136,0.031119784340262413,0.4186156690120697,-0.005651229061186314},pert={4.840140342712402,5.0612053871154785,0.009437812492251396,0.013602611608803272,0.418607234954834,-0.006702297367155552},gear=1},[792]={orig={5.4646077156066895,5.057666301727295,0.0323357880115509,0.033068977296352386,0.4171820282936096,-0.018373630940914154},pert={5.4731597900390625,5.067355155944824,0.011422194540500641,0.019664082676172256,0.4171922206878662,-0.016786135733127594},gear=1},[828]={orig={6.116064071655273,5.533873081207275,0.035604238510131836,0.028097115457057953,0.41879594326019287,0.043483007699251175},pert={6.1260600090026855,5.52747917175293,0.012954053469002247,0.005850316025316715,0.418707937002182,0.04080212116241455},gear=4},[864]={orig={6.8229851722717285,5.770831108093262,0.039271578192710876,0.041166752576828,0.42052140831947327,-0.020719878375530243},pert={6.833211421966553,5.783228397369385,0.014622676186263561,0.022470293566584587,0.420429527759552,-0.016211386770009995},gear=4},[900]={orig={7.560155391693115,6.029810428619385,0.044709332287311554,0.04270089790225029,0.4191683232784271,-0.009134741500020027},pert={7.5704827308654785,6.026594638824463,0.017337583005428314,0.017660019919276237,0.4192347526550293,-0.010360399261116982},gear=4},[936]={orig={8.328292846679688,6.271257400512695,0.0502636581659317,0.03790070861577988,0.41864296793937683,-0.00613538408651948},pert={8.339422225952148,6.284552097320557,0.020260438323020935,0.02842392772436142,0.41862478852272034,-0.0043391278013587},gear=4},[972]={orig={9.125978469848633,6.502718925476074,0.05521538481116295,0.0336897075176239,0.41836389899253845,-0.002249761950224638},pert={9.138005256652832,6.508553504943848,0.023608777672052383,0.02917562611401081,0.41847383975982666,-0.003720143809914589},gear=4},[1008]={orig={9.951952934265137,6.736327171325684,0.060552116483449936,0.048171721398830414,0.41854697465896606,-0.0018979276064783335},pert={9.964921951293945,6.7344069480896,0.027630876749753952,0.02873644419014454,0.4186641573905945,-0.0008735164301469922},gear=4},[1044]={orig={10.807108879089355,6.960024833679199,0.06725610792636871,0.05859367921948433,0.4187666177749634,-0.0029282760806381702},pert={10.820472717285156,6.97235107421875,0.031194496899843216,0.03380245715379715,0.4188750684261322,-0.00023381029313895851},gear=4},[1080]={orig={11.69066047668457,7.185590744018555,0.07473067194223404,0.06082236394286156,0.41897231340408325,-0.0018548071384429932},pert={11.704256057739258,7.185235500335693,0.03626060485839844,0.04656333848834038,0.4190857708454132,-0.0011882198741659522},gear=4},[1116]={orig={12.598986625671387,7.30173397064209,0.08229895681142807,0.06313223391771317,0.4188915193080902,-0.009672191925346851},pert={12.612323760986328,7.301867485046387,0.04193827509880066,0.04379777982831001,0.4189576208591461,-0.011811381205916405},gear=1},[1152]={orig={13.51004409790039,7.3021979331970215,0.09046553820371628,0.06462526321411133,0.4177786409854889,0.0019651504699140787},pert={13.523246765136719,7.3094258308410645,0.04755161702632904,0.04425235092639923,0.41763922572135925,0.0005926340236328542},gear=5},[1188]={orig={14.461423873901367,7.744656562805176,0.09819083660840988,0.06649192422628403,0.4205789268016815,0.0011306110536679626},pert={14.47532844543457,7.7505693435668945,0.05357963591814041,0.05586019903421402,0.42056068778038025,0.001558940508402884},gear=5},[1224]={orig={15.442736625671387,7.956551551818848,0.10781608521938324,0.08315742760896683,0.4196071922779083,-0.008590144105255604},pert={15.457148551940918,7.960639476776123,0.062052033841609955,0.07386268675327301,0.41959482431411743,-0.009974525310099125},gear=5},[1260]={orig={16.44919204711914,8.153761863708496,0.11856532841920853,0.0865478366613388,0.41885241866111755,-0.005167220253497362},pert={16.46405792236328,8.156624794006348,0.07147037982940674,0.07312893867492676,0.41876038908958435,-0.006296638865023851},gear=5},[1296]={orig={17.478801727294922,8.332096099853516,0.12985804677009583,0.09353591501712799,0.41873401403427124,-0.0004847965610679239},pert={17.494245529174805,8.337569236755371,0.08135297894477844,0.08439739048480988,0.41859906911849976,-0.001121235778555274},gear=5},[1332]={orig={18.530860900878906,8.511489868164062,0.14512600004673004,0.15027841925621033,0.41886091232299805,-0.0025664055719971657},pert={18.546653747558594,8.517818450927734,0.0955987200140953,0.13811014592647552,0.4187827706336975,-0.0003995590377599001},gear=5},[1368]={orig={19.60541343688965,8.687566757202148,0.165840283036232,0.177333265542984,0.418914794921875,-0.0010438293684273958},pert={19.621681213378906,8.699411392211914,0.11526505649089813,0.1768384873867035,0.4188852906227112,-0.0013668143656104803},gear=5},[1404]={orig={20.701770782470703,8.870848655700684,0.1907314658164978,0.22028812766075134,0.4190276265144348,-0.002063962398096919},pert={20.719181060791016,8.871551513671875,0.1386515200138092,0.1983075737953186,0.4190378189086914,-0.0010478263720870018},gear=5},[1440]={orig={21.820409774780273,9.042487144470215,0.21978560090065002,0.24973298609256744,0.4192010760307312,-8.993461960926652e-05},pert={21.838788986206055,9.05421257019043,0.1657709777355194,0.2340746968984604,0.4191550016403198,-0.0009793775388970971},gear=5},[1476]={orig={22.960628509521484,9.213776588439941,0.2531447112560272,0.2867794334888458,0.41925907135009766,-0.003993408288806677},pert={22.980592727661133,9.233785629272461,0.19739046692848206,0.27512529492378235,0.4192778468132019,-0.002664231462404132},gear=5},[1512]={orig={24.12328338623047,9.394749641418457,0.2913200557231903,0.325900673866272,0.4192706048488617,-0.0033605247735977173},pert={24.14444351196289,9.401257514953613,0.23360398411750793,0.30769431591033936,0.419350266456604,-0.0015643610386177897},gear=5},[1548]={orig={25.308570861816406,9.582337379455566,0.334360808134079,0.3660748600959778,0.41931575536727905,-0.0027562216855585575},pert={25.329973220825195,9.583732604980469,0.2746366262435913,0.35234832763671875,0.41938257217407227,-0.0027742076199501753},gear=5},[1584]={orig={26.516399383544922,9.751423835754395,0.3824962377548218,0.40224382281303406,0.4193378984928131,-0.0012049933429807425},pert={26.537818908691406,9.762347221374512,0.3213784992694855,0.3951578438282013,0.41939276456832886,-0.0022897496819496155},gear=5},[1620]={orig={27.745676040649414,9.935894966125488,0.43145108222961426,0.3877766728401184,0.41951945424079895,-0.0011633929098024964},pert={27.768213272094727,9.9382963180542,0.3693055808544159,0.37311962246894836,0.4195236563682556,-0.002494312357157469},gear=5},[1656]={orig={28.99749755859375,10.110454559326172,0.48021742701530457,0.3952106237411499,0.4195186197757721,-0.0031151501461863518},pert={29.0208683013916,10.111013412475586,0.4155385196208954,0.3701179623603821,0.41952651739120483,-0.001260595046915114},gear=5},[1692]={orig={30.271846771240234,10.284638404846191,0.5292539596557617,0.3888009786605835,0.41951972246170044,-0.001923568663187325},pert={30.295642852783203,10.291972160339355,0.46265140175819397,0.3839021325111389,0.4196261763572693,-0.0001984182745218277},gear=5},[1728]={orig={31.568361282348633,10.465534210205078,0.5781981945037842,0.3960740268230438,0.4196226894855499,-0.0008251978433690965},pert={31.592674255371094,10.468448638916016,0.5115519762039185,0.39817166328430176,0.4197297692298889,-0.00015375913062598556},gear=5},[1764]={orig={32.86050796508789,10.146360397338867,0.6283989548683167,0.4008820354938507,0.4191666543483734,-0.013933880254626274},pert={32.885093688964844,10.14590835571289,0.5612323880195618,0.39358586072921753,0.41923975944519043,-0.013478763401508331},gear=5},[1800]={orig={34.10320281982422,9.743009567260742,0.677589476108551,0.3821507394313812,0.4184917211532593,0.006620251107960939},pert={34.128116607666016,9.748576164245605,0.6095889210700989,0.3774445056915283,0.4185347259044647,0.006698393262922764},gear=5},[1836]={orig={35.29599380493164,9.345470428466797,0.7244701981544495,0.3678564727306366,0.41915956139564514,0.003803060157224536},pert={35.32136535644531,9.349061012268066,0.6559382677078247,0.3642968535423279,0.41919490694999695,0.0036213775165379047},gear=5},[1872]={orig={36.43940353393555,8.95161247253418,0.7696295380592346,0.3545037806034088,0.41966208815574646,0.0024901111610233784},pert={36.46512985229492,8.95478630065918,0.7006111741065979,0.35001805424690247,0.4196963906288147,0.002623157575726509},gear=5},[1908]={orig={37.53368377685547,8.560225486755371,0.8130993843078613,0.34037697315216064,0.4200303554534912,0.0027504151221364737},pert={37.559852600097656,8.56357192993164,0.7435792088508606,0.33709779381752014,0.42005330324172974,0.0025385478511452675},gear=1},[1944]={orig={38.57819747924805,8.155163764953613,0.854755699634552,0.32518282532691956,0.420258104801178,0.0012584362411871552},pert={38.604774475097656,8.158366203308105,0.7848321795463562,0.32186028361320496,0.4202817976474762,0.0012736248318105936},gear=1},[1980]={orig={39.57212829589844,7.7515082359313965,0.8945435881614685,0.3106057345867157,0.4204680323600769,0.001425167778506875},pert={39.59920120239258,7.756234169006348,0.8242344856262207,0.30819645524024963,0.4204837679862976,0.001434525940567255},gear=1},[2016]={orig={40.515480041503906,7.348715305328369,0.9325004816055298,0.29626399278640747,0.420659601688385,0.0015047930646687746},pert={40.543052673339844,7.35141658782959,0.8618730306625366,0.2936340868473053,0.4206589460372925,0.0014404566027224064},gear=4},[2052]={orig={41.40951156616211,6.96036434173584,0.9686754941940308,0.2820040285587311,0.4208727777004242,0.0015608458779752254},pert={41.437381744384766,6.962123870849609,0.8977177143096924,0.2790013253688812,0.42087939381599426,0.001613143365830183},gear=4},[2088]={orig={42.25526428222656,6.576177597045898,1.0030335187911987,0.2670149505138397,0.42105403542518616,0.001213461859151721},pert={42.28341293334961,6.57898473739624,0.931702733039856,0.26410651206970215,0.42108047008514404,0.0011688031954690814},gear=4},[2124]={orig={43.05331039428711,6.196385383605957,1.0355360507965088,0.2522774636745453,0.4212200939655304,0.0008023158879950643},pert={43.08182144165039,6.199271202087402,0.9638587236404419,0.24961358308792114,0.4212333858013153,0.0007797842263244092},gear=4},[2160]={orig={43.8039665222168,5.817687034606934,1.0662145614624023,0.23768848180770874,0.42133015394210815,0.0005693589919246733},pert={43.83283233642578,5.820622444152832,0.9942178130149841,0.23527564108371735,0.4213390052318573,0.0005153894308023155},gear=4},[2196]={orig={44.50738525390625,5.44052267074585,1.0951778888702393,0.22455434501171112,0.4214061200618744,0.0002738221955951303},pert={44.536659240722656,5.443253040313721,1.0227818489074707,0.21940375864505768,0.421410471200943,0.0003291927860118449},gear=4},[2232]={orig={45.16379928588867,5.063968181610107,1.1219241619110107,0.20526133477687836,0.4214657247066498,0.00040229674777947366},pert={45.193382263183594,5.066341876983643,1.04913330078125,0.20270346105098724,0.42147624492645264,0.00043206216651014984},gear=4},[2268]={orig={45.773189544677734,4.687727928161621,1.146647572517395,0.18994140625,0.4215254485607147,0.0003854995302390307},pert={45.80305480957031,4.690579414367676,1.0735446214675903,0.18745361268520355,0.4215371906757355,0.0002937726385425776},gear=4},[2304]={orig={46.33562088012695,4.3128228187561035,1.169438362121582,0.17433030903339386,0.42158007621765137,0.00023746589431539178},pert={46.36582565307617,4.315673828125,1.0960341691970825,0.17200689017772675,0.42158377170562744,0.00023465545382350683},gear=4}}},
controls={{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,0.0,0.0,false,false},{0.0,0.0,1.0,0.0,false,false},{0.0,0.0,1.0,0.0,false,false},{0.0,0.0,1.0,0.0,false,false},{0.0,0.0,1.0,0.0,false,false},{0.0,0.0,1.0,0.0,false,false},{0.0,0.0,1.0,0.0,false,false},{0.0,0.0,1.0,0.0,false,false},{0.0,0.0,1.0,0.0,false,false},{0.0,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,true,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,true,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,true,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,true,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.01,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.7,0.0,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,true},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false},{0.0,0.5,1.0,0.0,false,false}}
}
local M={}
local FLAT={}
for i=1,4 do FLAT[i]={0,0,1,0,0,0,0,1,1} end
local function rawInputs(k)
    local t=k/288
    if t<1 then return {gear=1} end
    if t<4 then return {gear=2,clutch=1,throttle=1} end
    if t<5.5 then return {gear=2,clutch=1,throttle=0.6,lfSteer=0.04,rfSteer=0.035} end
    return {gear=2,clutch=1,throttle=0,brake=0.7}
end
local function controls(frame)
    local c=G.controls[frame+1]
    return {throttle=c[1],brake=c[2],clutch=c[3],steer=c[4],shiftUp=c[5],shiftDown=c[6]}
end
local function relerr(a,b) return math.abs(a-b)/math.max(math.abs(a),math.abs(b),1e-3) end
function M.run(full)
    local results,passed,failed={},0,0
    local function check(name,ok,detail)
        if ok then passed+=1 else failed+=1 end
        local line=(ok and "PASS  " or "FAIL  ")..name..(detail and ("  "..detail) or "")
        results[#results+1]=line;print(line)
    end
    local t0=os.clock()
    local car=Vehicle.new(Core.NR2003Cup);local V=car.V
    check("load Core.NR2003Cup",true,string.format("%.2f s",os.clock()-t0))
    local horizon=full and 2304 or 576
    for _,kind in ipairs({"raw","drive"}) do
        V.reset()
        local g=G[kind];local s=table.create(45,0);local worst,bad,mism=0,0,0;local last
        local t=os.clock()
        for k=1,horizon do
            if kind=="raw" then V.stepRaw(rawInputs(k),FLAT) else V.drive(controls((k-1)//8),FLAT) end
            local early=g.early[k];local row=g.rows[k]
            if early or row then V.state(s) end
            if early then for i=1,45 do worst=math.max(worst,relerr(s[i],early[i])) end end
            if row then
                for i=1,6 do
                    local o,p=row.orig[i],row.pert[i]
                    if math.abs(s[i]-o)>3*math.abs(p-o)+0.02+0.01*math.abs(o) then bad+=1 end
                end
                if kind=="drive" and V.gearIndex()~=row.gear then mism+=1 end
                last={k,s[1],row.orig[1],row.pert[1]}
            end
        end
        local dt=os.clock()-t
        check(kind..": ticks 1-8 vs original (rel <= 2e-5)",worst<=2e-5,string.format("worst %.2e",worst))
        check(kind..": chassis states inside original sensitivity envelope ("..horizon.." ticks)",bad==0,
            string.format("%d outside | %.0f ticks/s | x lua %.3f orig %.3f pert %.3f",bad,horizon/dt,last[2],last[3],last[4]))
        if kind=="drive" then check("drive: gear sequence (lifted 00553d70)",mism==0,mism.." mismatches") end
    end
    V.reset()
    for k=1,200 do V.drive(controls((k-1)//8),FLAT) end
    local cp=V.checkpoint();for k=201,400 do V.drive(controls((k-1)//8),FLAT) end
    local a=V.state();V.restore(cp);for k=201,400 do V.drive(controls((k-1)//8),FLAT) end
    local b=V.state();local same=true
    for i=1,45 do if a[i]~=b[i] then same=false end end
    check("checkpoint/restore bit-identical",same)
    print(string.format("Stage 6/7 self-test: %d passed, %d failed",passed,failed))
    return failed==0,results
end
return M
]=])
local serverSource=[=[
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
]=]
local clientSource=[=[
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
local hint=label(panel,"Controls",183,50,11)
hint.Text="W/S acelerar/frear   A/D direção   E/Q marchas\nShift embreagem   Espaço freio de mão   X sair\nT painel   G contatos   H render diag   V câmera   R reposicionar"
local status=label(panel,"Status",232,16,11);status.Text="Tune de teste | contato por raycast"
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
    title.Text=data.mode=="NR2003_CUP" and "NR2003 Cup / núcleo original 45 estados · estágios 6-7"
        or (data.mode=="NR2003_CORE" and "NR2003 / chassi numérico · estágio 5 estabilizado" or "NR2003 / adaptador Roblox")
    local gear=data.gear==-1 and "R" or (data.gear==0 and "N" or tostring(data.gear))
    gauge.Text=string.format("%3.0f km/h | %4.0f rpm | %s",data.speed,data.rpm,gear)
    for j,w in ipairs(data.wheels) do
        rows[j].Text=string.format("%s   %7.0f  %8.1f  %6.1f  %7.1f",w.name,w.load,w.compression*1000,w.slip*100,w.temperature)
        rows[j].TextColor3=w.grounded and Color3.fromRGB(216,228,237) or Color3.fromRGB(246,147,106)
    end
    if data.mode=="NR2003_CUP" then
        status.Text=data.fault and "Física pausada; veja Output. R reinicia." or string.format("acel %.2f freio %.2f embr %.2f | limitador %s | embreagem Δ %.0f rad/s%s",
            data.throttleIn or 0,data.brakeIn or 0,data.clutchIn or 0,data.limiter and "ON" or "off",data.clutchSlip or 0,data.collision and " | colisão" or "")
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
    hint.Visible=expanded;status.Visible=expanded;panel.Size=UDim2.fromOffset(460,expanded and 250 or 76)
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
        remote:FireServer({kind="input",throttle=keys.Gas and 1 or 0,brake=keys.Brake and 1 or 0,
            steer=(keys.Right and 1 or 0)-(keys.Left and 1 or 0),handbrake=keys.Handbrake and 1 or 0,clutch=keys.Clutch and 1 or 0})
    end
end
local renderName="NR2003_Presentation"
RunService:BindToRenderStep(renderName,Enum.RenderPriority.Camera.Value-1,frame)
script.Destroying:Connect(function()
    RunService:UnbindFromRenderStep(renderName);presentation:destroy();unbind()
end)
]=]
-- backup (complete copies) -------------------------------------------------------------
local backup=Instance.new("Folder")
local base="NR2003Backup_Stage67_"..tostring(os.time());local suffix=0
while storage:FindFirstChild(base.."_"..suffix) do suffix=suffix+1 end
backup.Name=base.."_"..suffix
pkg:Clone().Parent=backup;oldServer:Clone().Parent=backup;oldClient:Clone().Parent=backup
backup.Parent=storage
local created,replaced={}, {}
local function apply()
    local cupFolder=CoreF:FindFirstChild("NR2003Cup")
    if cupFolder then cupFolder:Destroy() end
    cupFolder=Instance.new("Folder");cupFolder.Name="NR2003Cup";cupFolder.Parent=CoreF
    created[#created+1]=cupFolder
    local dest={NR2003Cup=cupFolder,Core=CoreF,Roblox=RobloxF}
    for _,m in ipairs(MODULES) do
        local folder,name,source=m[1],m[2],m[3]
        local parent=dest[folder]
        local existing=parent:FindFirstChild(name)
        if existing then existing:Destroy() end
        local s=Instance.new("ModuleScript");s.Name=name
        setSource(s,source);s.Parent=parent
        assert(#s.Source==#source,"fonte truncada: "..folder.."."..name)
    end
    setSource(oldServer,serverSource);setSource(oldClient,clientSource)
    pkg:SetAttribute("NR2003Stage","6-7");pkg:SetAttribute("NR2003Version","3.6.0-stage7")
    local ok,results=require(RobloxF.Stage67SelfTest).run(false)
    assert(ok,"self-test falhou:\n"..table.concat(results,"\n"))
end
local ok,reason=pcall(apply)
if not ok then
    -- revert: restore package and scripts from the backup copies
    local savedPkg=backup:FindFirstChild("NR2003Lab");local savedServer=backup:FindFirstChild("NR2003Server")
    local savedClient=backup:FindFirstChild("NR2003Client")
    pkg:Destroy();savedPkg:Clone().Parent=RS
    setSource(oldServer,savedServer.Source);setSource(oldClient,savedClient.Source)
    error("Patch Stage 6/7 revertido (nada mudou além do backup em ServerStorage."..backup.Name.."): "..tostring(reason))
end
game:GetService("Selection"):Set({car})
print("Stage 6/7 aplicado. Backup: ServerStorage."..backup.Name)
print("Modo NR2003_CUP: núcleo original NR2003 Cup (45 estados: suspensão, cubos, rodas, eixo traseiro, motor, embreagem, outshaft).")
print("Play > F entrar | W/S acel/freio | A/D direção | E/Q marchas | Shift embreagem | R reinicia | G contatos | H render diag | V câmera")
print("Voltar ao estágio 5: NR2003Lab.Roblox.ModeConfig -> mode=\"NR2003_CORE\" (ou \"ROBLOX_ADAPTER\").")
]==]
-- ===== mock Studio DataModel for PATCH_STAGE6_7.lua (install + revert paths) =====
local Instance = {}
local IMeta = {}
local function newInstance(class, name)
	local o = {ClassName = class, Name = name or class, _children = {}, _attrs = {}, Archivable = true, _parent = nil}
	return setmetatable(o, IMeta)
end
IMeta.__index = function(o, k)
	if k == "Parent" then return rawget(o, "_parent") end
	local m = Instance[k]
	if m then return m end
	for _, c in ipairs(rawget(o, "_children")) do if c.Name == k then return c end end
	return nil
end
IMeta.__newindex = function(o, k, v)
	if k == "Parent" then
		local old = rawget(o, "_parent")
		if old then
			local list = rawget(old, "_children")
			for i, c in ipairs(list) do if c == o then table.remove(list, i); break end end
		end
		rawset(o, "_parent", v)
		if v then table.insert(rawget(v, "_children"), o) end
		return
	end
	if k == "Source" and #v >= 200000 then error("Source exceeds 200000 characters (" .. #v .. ")") end
	rawset(o, k, v)
end
function Instance.new(class) return newInstance(class) end
function Instance.FindFirstChild(o, name) for _, c in ipairs(rawget(o, "_children")) do if c.Name == name then return c end end return nil end
function Instance.WaitForChild(o, name) return assert(Instance.FindFirstChild(o, name), "WaitForChild: " .. name) end
function Instance.GetChildren(o) return table.clone(rawget(o, "_children")) end
function Instance.SetAttribute(o, k, v) rawget(o, "_attrs")[k] = v end
function Instance.GetAttribute(o, k) return rawget(o, "_attrs")[k] end
function Instance.IsA(o, c) return o.ClassName == c end
function Instance.Destroy(o) o.Parent = nil; rawset(o, "_destroyed", true) end
function Instance.Clone(o)
	local c = newInstance(o.ClassName, o.Name)
	for k, v in pairs(o) do if k ~= "_children" and k ~= "_parent" and k ~= "_attrs" then rawset(c, k, v) end end
	for k, v in pairs(rawget(o, "_attrs")) do rawget(c, "_attrs")[k] = v end
	for _, ch in ipairs(rawget(o, "_children")) do Instance.Clone(ch).Parent = c end
	return c
end

local function make(class, name, parent, source)
	local o = newInstance(class, name)
	if source then rawset(o, "Source", source) end
	o.Parent = parent
	return o
end
local dataModel = newInstance("DataModel", "game")
local services = {}
for _, n in ipairs({"ReplicatedStorage", "ServerScriptService", "ServerStorage", "StarterPlayer", "Workspace"}) do
	services[n] = make(n, n, dataModel)
end
local SP = make("StarterPlayerScripts", "StarterPlayerScripts", services.StarterPlayer)
local function stage5()
	for _, c in ipairs(services.ReplicatedStorage:GetChildren()) do c:Destroy() end
	local pkg = make("Folder", "NR2003Lab", services.ReplicatedStorage)
	local core = make("Folder", "Core", pkg); local rb = make("Folder", "Roblox", pkg)
	for _, n in ipairs({"NR2003FixedStep", "Surface", "MathUtil", "TestTune", "RecoveredData", "NR2003Math", "Float32"}) do make("ModuleScript", n, core, "return {}") end
	for _, n in ipairs({"VisualRig", "RenderSnapshot", "SnapshotBuffer", "RenderPresentation", "CoreChassisAdapter", "SeatAccess", "Cockpit", "LegacyRobloxAdapter", "ModeConfig"}) do
		make("ModuleScript", n, rb, n == "ModeConfig" and 'return {mode="NR2003_CORE"}' or "return {}")
	end
	if not services.ServerScriptService:FindFirstChild("NR2003Server") then make("Script", "NR2003Server", services.ServerScriptService, "-- stage5 server") end
	if not SP:FindFirstChild("NR2003Client") then make("LocalScript", "NR2003Client", SP, "-- stage5 client") end
	if not services.Workspace:FindFirstChild("NR2003LabWorld") then
		local world = make("Folder", "NR2003LabWorld", services.Workspace)
		local car = make("Model", "TestCar", world); make("Part", "Chassis", car); make("VehicleSeat", "DriverSeat", car)
	end
	return pkg
end
local selection = {Set = function() end}
local scriptEditor = {UpdateSourceAsync = function(_, s, f) rawset(s, "Source", f(s.Source)) end}
local runService = {IsRunning = function() return false end}
local game = {GetService = function(_, n)
	if n == "RunService" then return runService end
	if n == "Selection" then return selection end
	if n == "ScriptEditorService" then return scriptEditor end
	return assert(services[n], "service " .. n)
end}
services.StarterPlayer.WaitForChild = function(_, n) return SP end

-- require(ModuleScript): run its Source with a Roblox-like env (script, require, game)
local cache = {}
local failSelfTest = false
local function mockRequire(m)
	if type(m) == "string" then return require(m) end
	if failSelfTest and m.Name == "Stage67SelfTest" then error("forced self-test failure (revert path)") end
	if cache[m] ~= nil then return cache[m] end
	local f = assert(loadstring(m.Source, m.Name))
	setfenv(f, setmetatable({script = m, require = mockRequire, game = game, workspace = services.Workspace}, {__index = _G}))
	local v = f()
	cache[m] = v
	return v
end

local passed, failed = 0, 0
local function check(name, ok, detail)
	if ok then passed += 1 else failed += 1 end
	print((ok and "PASS  " or "FAIL  ") .. name .. (detail and ("  " .. detail) or ""))
end
local function runPatch()
	local f = assert(loadstring(PATCH, "PATCH_STAGE6_7"))
	setfenv(f, setmetatable({game = game, workspace = services.Workspace, Instance = Instance, require = mockRequire}, {__index = _G}))
	return pcall(f)
end

-- 1) install on a Stage 5 bench
local pkg = stage5()
local ok, err = runPatch()
check("patch runs to completion on a Stage 5 bench (incl. self-test)", ok, ok and nil or tostring(err))
local RS = services.ReplicatedStorage
local newPkg = RS:FindFirstChild("NR2003Lab")
local cup = newPkg and newPkg.Core:FindFirstChild("NR2003Cup")
local cupCount = cup and #cup:GetChildren() or 0
check("Core.NR2003Cup installed with 8 modules", cupCount == 8, tostring(cupCount))
check("Core.NR2003CupVehicle / CupTune, Roblox.CupChassisAdapter / Stage67SelfTest installed",
	newPkg.Core:FindFirstChild("NR2003CupVehicle") and newPkg.Core:FindFirstChild("CupTune") and newPkg.Roblox:FindFirstChild("CupChassisAdapter")
	and newPkg.Roblox:FindFirstChild("Stage67SelfTest") and true or false)
check("ModeConfig switched to NR2003_CUP", newPkg.Roblox.ModeConfig.Source:find('mode="NR2003_CUP"', 1, true) ~= nil)
check("Stage 5 modules kept", newPkg.Roblox:FindFirstChild("CoreChassisAdapter") ~= nil and newPkg.Core:FindFirstChild("TestTune") ~= nil)
check("server/client sources replaced", services.ServerScriptService.NR2003Server.Source:find("NR2003_CUP", 1, true) ~= nil
	and SP.NR2003Client.Source:find("CupTune", 1, true) ~= nil)
local backups = 0
for _, c in ipairs(services.ServerStorage:GetChildren()) do
	if c.Name:find("NR2003Backup_Stage67_", 1, true) and c:FindFirstChild("NR2003Lab") and c:FindFirstChild("NR2003Server") and c:FindFirstChild("NR2003Client") then backups += 1 end
end
check("backup folder with package + scripts in ServerStorage", backups == 1, tostring(backups))
check("package tagged NR2003Stage = 6-7", newPkg:GetAttribute("NR2003Stage") == "6-7")

-- 2) revert path: self-test failure restores the previous package and script sources
local before = RS.NR2003Lab
local serverBefore = services.ServerScriptService.NR2003Server.Source
local clientBefore = SP.NR2003Client.Source
before.Roblox.ModeConfig.Source = 'return {mode="NR2003_CORE"} -- marker'
cache = {}
failSelfTest = true
local ok2, err2 = runPatch()
failSelfTest = false
check("forced failure reports an error", not ok2 and tostring(err2):find("revertido", 1, true) ~= nil, tostring(err2):sub(1, 120))
local restored = RS:FindFirstChild("NR2003Lab")
check("revert restores the previous package", restored ~= nil and restored.Roblox.ModeConfig.Source:find("marker", 1, true) ~= nil)
check("revert restores server/client sources", services.ServerScriptService.NR2003Server.Source == serverBefore and SP.NR2003Client.Source == clientBefore)
print(string.format("\npatch mock: %d passed, %d failed", passed, failed))
if failed > 0 then error("patch mock tests failed") end
