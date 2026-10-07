--!native
--!optimize 2
-- GENERATED NR2003 Cup vehicle runtime: translated JIT callbacks, part %(part)s (%(names)s).
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
