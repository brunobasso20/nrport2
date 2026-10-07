--!optimize 2
-- NR2003 Cup garage / setup layer (Stage 10). Hand port of the ORIGINAL NR2003.exe setup logic:
--   descriptor table c05150 (184 items: kind, display type, min, max, step, default, toInternal, toDisplay)
--   unit converters 00423dc0..004241f0 (toInternal / toDisplay of each descriptor)
--   garage API: 005582d0 stepCount, 00558320 stepIndex, 00557e40 snapped display value,
--               005581d0 set display value (snap + clamp), 005580f0 set display value (clamp only),
--               005583e0 one step up/down, 00558380 set by step index, 00557d20 defaults,
--               00558da0 + 004247e0 setup-file (.sto) load validation
-- Data come from NR2003CupSetupData (generated from the exe). Pure Luau: no Instances, no physics.
--
-- Representation: a setup is an array [0..183] of RAW 32-bit internal values exactly as the game stores them
-- (float items = IEEE single bits, int items = two's complement). Display values are passed as raw bits too
-- (float display = single bits, int display = integer), because that is what the original functions pass.
--
-- FPU rounding: every original converter ends with x87 stores/FISTP that round with the CURRENT control word.
--   mode "nearest" = CW 0x027f (default thread CW: CRT init, garage UI, setup-file loader)  [default]
--   mode "down"    = CW 0x077f (simulation/session task: 0055aa60, pit stops 0040e0xx)
-- x87 intermediates are evaluated in IEEE double (exact for these operations; validated bit for bit
-- against the original in both modes, tests/stage10).
-- Usage: local Setup = require(NR2003CupSetup)(require(NR2003CupSetupData))
return function(DATA)
local Setup = {}
Setup.DATA = DATA
Setup.ITEMS = 184

local S = buffer.create(8)
local function bitsToF(u) buffer.writeu32(S, 0, u); return buffer.readf32(S, 0) end
local function f32n(x) buffer.writef32(S, 0, x); return buffer.readu32(S, 0) end
local function f32d(x)
	-- IEEE single rounding toward -inf (bits)
	buffer.writef32(S, 0, x)
	local r = buffer.readf32(S, 0)
	if r > x then
		local u = buffer.readu32(S, 0)
		if r > 0 then u -= 1 elseif r == 0 then u = 0x80000001 else u += 1 end
		return u
	end
	return buffer.readu32(S, 0)
end
local function f32(x, mode)
	if x ~= x then return 0xffc00000 end -- x87 real indefinite
	if mode == "down" then return f32d(x) end
	return f32n(x)
end
-- x87 FADD with the sign of an exact zero result: round toward -inf gives -0 unless both operands are +0
local function fadd(a, b, mode)
	local r = a + b
	if r == 0 and mode == "down" and not (a == 0 and b == 0 and 1 / a > 0 and 1 / b > 0) then return -0.0 end
	return r
end
local function i32(u) if u >= 0x80000000 then return u - 0x100000000 end return u end
local function u32(i) return i % 0x100000000 end
local function fist(x, mode)
	-- FISTP dword with the current rounding mode; out of range / NaN -> integer indefinite
	local r
	if x ~= x then return 0x80000000 end
	if mode == "down" then r = math.floor(x)
	else
		r = math.floor(x)
		local d = x - r
		if d > 0.5 or (d == 0.5 and r % 2 ~= 0) then r += 1 end
	end
	if r >= 2147483648 or r < -2147483648 then return 0x80000000 end
	return u32(r)
end
local function idiv(a, b)
	-- IDIV (truncation toward zero); the original faults on b = 0 (callers never pass step 0 items)
	assert(b ~= 0, "NR2003 setup: integer divide by zero (item without step)")
	local q = a / b
	if q >= 0 then return math.floor(q) end
	return -math.floor(-q)
end
local function imul(a, b)
	-- 32-bit wrapping signed multiply
	return i32(u32(a * b % 0x100000000))
end

local C = {}
for a, bits in pairs(DATA.consts) do C[a] = bitsToF(bits) end
local K_871A7C = C[0x871a7c] -- 1/175 (CRT init 0042312c)

---------------------------------------------------------------------------------------------------
-- ORIGINAL converters (00423dc0..004241f0). Argument and result are raw 32-bit values.
---------------------------------------------------------------------------------------------------
local CONV = {}
CONV.F_ID = function(u, _mode) return u end                                 -- 00423dc0
CONV.I_ID = function(u, _mode) return u end                                 -- 00423dd0
CONV.PCT_TO_FRAC = function(u, mode) return f32(i32(u) * C[0x6ea4a4], mode) end -- 00423de0
CONV.FRAC_TO_PCT = function(u, mode)                                        -- 00423e00
	local y = f32(bitsToF(u) * C[0x6ed00c] + C[0x6ea4cc], mode)
	return fist(bitsToF(y), mode)
end
CONV.INT_TO_FLOAT = function(u, mode) return f32(i32(u), mode) end          -- 00423e30
CONV.FLOAT_TO_INT = function(u, mode)                                       -- 00423e40
	return fist(bitsToF(f32(bitsToF(u) + C[0x6ea4cc], mode)), mode)
end
CONV.DEG_TO_RAD = function(u, mode) return f32(C[0x6ed7b4] * bitsToF(u), mode) end -- 00423e60
CONV.RAD_TO_DEG = function(u, mode) return f32(C[0x6ed7b8] * bitsToF(u), mode) end -- 00423e80
CONV.STAGGER_IN_TO_M = function(u, mode) return f32(C[0x6ed798] * bitsToF(u) * C[0x6ee330], mode) end -- 00423ea0
CONV.STAGGER_M_TO_IN = function(u, mode) return f32(C[0x6ed794] * bitsToF(u) * C[0x6ee334], mode) end -- 00423ec0
CONV.FSPRING_LBIN_TO_NM = function(u, mode) return f32(i32(u) * C[0x6ed7bc] * C[0x6ee338], mode) end -- 00423ee0
CONV.FSPRING_NM_TO_LBIN = function(u, mode)                                 -- 00423f00
	return fist(bitsToF(f32(K_871A7C * bitsToF(u) * C[0x6ee33c] + C[0x6ea4cc], mode)), mode)
end
CONV.RSPRING_LBIN_TO_NM = function(u, mode) return f32(i32(u) * C[0x6ed7bc] * C[0x6ee340], mode) end -- 00423f30
CONV.RSPRING_NM_TO_LBIN = function(u, mode)                                 -- 00423f50
	return fist(bitsToF(f32(K_871A7C * bitsToF(u) * C[0x6ee344] + C[0x6ea4cc], mode)), mode)
end
CONV.IN_TO_M = function(u, mode) return f32(C[0x6ed798] * bitsToF(u), mode) end -- 00423f80
CONV.M_TO_IN = function(u, mode) return f32(C[0x6ed794] * bitsToF(u), mode) end -- 00423fa0
CONV.TOE_IN_TO_RAD = function(u, mode) return f32(bitsToF(u) * C[0x6ee348], mode) end -- 00423fc0
CONV.TOE_RAD_TO_IN = function(u, mode) return f32(bitsToF(u) * C[0x6ee34c], mode) end -- 00423fe0
CONV.LB_TO_KG = function(u, mode) return f32(i32(u) * C[0x6ed79c], mode) end -- 00424000 / 004240c0 / 00424110
CONV.KG_TO_LB = function(u, mode)                                           -- 00424020 / 004240e0 / 00424130
	return fist(bitsToF(f32(C[0x6ed7a4] * bitsToF(u) + C[0x6ea4cc], mode)), mode)
end
CONV.GAL_TO_KG = function(u, mode) return f32(i32(u) / C[0x6ed7ac], mode) end -- 00424050
CONV.KG_TO_GAL = function(u, mode)                                          -- 00424070
	return fist(bitsToF(f32(C[0x6ed7ac] * bitsToF(u) + C[0x6ea4cc], mode)), mode)
end
CONV.K_TO_C = function(u, mode) return f32(fadd(bitsToF(u), -C[0x6ee350], mode), mode) end -- 004240a0
CONV.FARB_RATE_TO_SIZE = function(u, mode)                                  -- 00424160
	local v = bitsToF(u)
	-- FCOMP 0.0; TEST AH,5; JP: only v < 0 (a bar is fitted) computes the size, else 0.0
	if not (v < 0) then return f32(0, mode) end
	return f32(fadd(fadd(-(K_871A7C * v), -C[0x6ee358], mode) * C[0x6ee354], C[0x6e97d8], mode), mode)
end
CONV.RARB_RATE_TO_SIZE = function(u, mode)                                  -- 004241a0
	local x = (bitsToF(u) - C[0x6ee364]) * C[0x6ee360] * K_871A7C * C[0x6ee35c]
	if x < 0 then return 0xffc00000 end -- FSQRT of a negative: real indefinite
	return f32(math.sqrt(math.sqrt(x)), mode)
end
CONV.SPOILER_DEG_TO_INT = function(u, mode) return f32(i32(u) - 45, mode) end -- 004241d0
CONV.SPOILER_INT_TO_DEG = function(u, mode)                                 -- 004241f0
	return u32(i32(fist(bitsToF(f32(bitsToF(u) + C[0x6ea4cc], mode)), mode)) + 45)
end
Setup.CONV = CONV

---------------------------------------------------------------------------------------------------
-- descriptors
---------------------------------------------------------------------------------------------------
local ITEM = DATA.items
local BYNAME = {}
for i = 0, 183 do BYNAME[ITEM[i].name] = i end
Setup.ITEM = ITEM
function Setup.index(nameOrIndex)
	if type(nameOrIndex) == "number" then return nameOrIndex end
	local i = BYNAME[nameOrIndex]
	assert(i, "NR2003 setup: unknown item " .. tostring(nameOrIndex))
	return i
end
local function desc(i)
	local d = ITEM[i]
	assert(d and d.desc, "NR2003 setup: item " .. i .. " has no descriptor")
	return d
end
function Setup.adjustable(i)
	local d = ITEM[Setup.index(i)]
	return d.desc ~= nil and d.toInternal ~= nil and d.step ~= 0
end
function Setup.toInternal(i, displayBits, mode)
	i = Setup.index(i)
	local d = desc(i)
	assert(d.toInternal, "NR2003 setup: item " .. i .. " is not settable (no toInternal)")
	return CONV[d.toInternal](displayBits, mode or "nearest")
end
function Setup.toDisplay(i, raw, mode)
	i = Setup.index(i)
	local d = desc(i)
	return CONV[d.toDisplay](raw, mode or "nearest")
end

---------------------------------------------------------------------------------------------------
-- garage API (ORIGINAL functions; s = setup array of raw values, i = item index or item name)
---------------------------------------------------------------------------------------------------
-- step index of a display value (shared body of 00558320/00557e40/005581d0/005583e0/005580f0)
local function indexOf(d, dbits, mode)
	if d.type == 3 then return idiv(i32(dbits) - i32(d.min), i32(d.step)) end
	local x = (bitsToF(dbits) - bitsToF(d.min)) / bitsToF(d.step) + C[0x6ea4cc]
	return i32(fist(bitsToF(f32(x, mode)), mode))
end
local function valueAt(d, k, mode)
	-- display value of step k: float FILD k; FMUL step; FADD min; FSTP dword / int IMUL + ADD
	if d.type == 4 then return f32(fadd(k * bitsToF(d.step), bitsToF(d.min), mode), mode) end
	return u32(imul(i32(d.step), k) + i32(d.min))
end

-- 005582d0 of steps between min and max
function Setup.stepCount(i, mode)
	i = Setup.index(i)
	local d = desc(i); mode = mode or "nearest"
	if d.type == 4 then
		return i32(fist(bitsToF(f32((bitsToF(d.max) - bitsToF(d.min)) / bitsToF(d.step) + C[0x6ea4cc], mode)), mode))
	end
	return idiv(i32(d.max) - i32(d.min), i32(d.step))
end
-- 00558320: step index of the stored value
function Setup.stepIndex(s, i, mode)
	i = Setup.index(i)
	local d = desc(i); mode = mode or "nearest"
	return indexOf(d, CONV[d.toDisplay](s[i], mode), mode)
end
-- 00557e40: display value snapped to the step grid (returned as the x87 value the game gets back).
-- Quirk kept: int-display items return their integer bits re-interpreted as a float (FLD dword).
function Setup.snapped(s, i, mode)
	i = Setup.index(i)
	local d = desc(i); mode = mode or "nearest"
	local dbits = CONV[d.toDisplay](s[i], mode)
	if not d.toInternal then return bitsToF(dbits) end
	local k = indexOf(d, dbits, mode)
	return bitsToF(valueAt(d, k, mode))
end
-- 005581d0: set a display value: snapped to the step grid, the snapped value clamped to [min, max], stored
-- through toInternal. Returns the display bits that were stored (EAX).
local function snapClamp(d, dbits, mode)
	local v = valueAt(d, indexOf(d, dbits, mode), mode)
	if d.type == 4 then
		-- FLD snapped; FCOMP min; TEST AH,5; JP / FCOMP max; AND 0x4100: NaN keeps the snapped value
		local x = bitsToF(v)
		if x < bitsToF(d.min) then v = d.min elseif x > bitsToF(d.max) then v = d.max end
	else
		if i32(v) < i32(d.min) then v = d.min elseif i32(v) > i32(d.max) then v = d.max end
	end
	return v
end
function Setup.setSnapped(s, i, dbits, mode)
	i = Setup.index(i)
	local d = desc(i); mode = mode or "nearest"
	local v = snapClamp(d, dbits, mode)
	s[i] = CONV[d.toInternal](v, mode)
	return v
end
-- 005580f0: same store as 005581d0 (snap, clamp the snapped value); the x87 return value is the snapped
-- (unclamped) display value
function Setup.setClamped(s, i, dbits, mode)
	i = Setup.index(i)
	local d = desc(i); mode = mode or "nearest"
	local v = snapClamp(d, dbits, mode)
	s[i] = CONV[d.toInternal](v, mode)
	return v
end
-- 005583e0: one garage step (+/-) clamped to [min, max]; returns true when the stored value changed
function Setup.step(s, i, up, mode)
	i = Setup.index(i)
	local d = desc(i); mode = mode or "nearest"
	local k0 = indexOf(d, CONV[d.toDisplay](s[i], mode), mode)
	local v = valueAt(d, up and k0 + 1 or k0 - 1, mode)
	if d.type == 4 then
		local x = bitsToF(v)
		if x < bitsToF(d.min) then v = d.min elseif x > bitsToF(d.max) then v = d.max end
	else
		if i32(v) < i32(d.min) then v = d.min elseif i32(v) > i32(d.max) then v = d.max end
	end
	if indexOf(d, v, mode) == k0 then return false end
	s[i] = CONV[d.toInternal](v, mode)
	return true
end
-- 00558380: set by step index (no clamping)
function Setup.setIndex(s, i, k, mode)
	i = Setup.index(i)
	local d = desc(i); mode = mode or "nearest"
	s[i] = CONV[d.toInternal](valueAt(d, k, mode), mode)
end
-- 00557d20: default setup from the descriptors (items without a descriptor/toInternal = 0)
function Setup.defaults(mode)
	local s = table.create(184)
	for i = 0, 183 do
		local d = ITEM[i]
		s[i] = (d.desc and d.toInternal) and CONV[d.toInternal](d.default, mode or "nearest") or 0
	end
	return s
end
-- 00558da0 (+ 004247e0): validation of a loaded setup file: every settable item is converted to its display
-- value, clamped to [min, max] (no snapping) and converted back. Returns false for an unknown display type.
function Setup.validateLoaded(s, mode)
	mode = mode or "nearest"
	for i = 0, 183 do
		local d = ITEM[i]
		if d.desc and d.toInternal then
			if d.type ~= 3 and d.type ~= 4 then return false end
			local v = CONV[d.toDisplay](s[i], mode)
			if d.type == 4 then
				local x = bitsToF(v)
				-- FCOMP min; TEST AH,5; JP: NaN and v >= min continue to the max test, v < min -> min
				if x < bitsToF(d.min) then v = d.min
				elseif x > bitsToF(d.max) then v = d.max end
			else
				if i32(v) < i32(d.min) then v = d.min elseif i32(v) > i32(d.max) then v = d.max end
			end
			s[i] = CONV[d.toInternal](v, mode)
		end
	end
	-- 004247e0: in modes 1/5 (00871ad4) the LR track bar may not exceed the RR one
	local m = DATA.consts[0x871ad4]
	if m == 1 or m == 5 then
		local lr = bitsToF(CONV[ITEM[45].toDisplay](s[45], mode))
		local rr = bitsToF(CONV[ITEM[46].toDisplay](s[46], mode))
		if rr < lr then s[45] = CONV[ITEM[45].toInternal](f32(rr, mode), mode) end
	end
	return true
end

---------------------------------------------------------------------------------------------------
-- convenience layer (ROBLOX ADAPTER, not original): numbers in display units <-> raw items
---------------------------------------------------------------------------------------------------
function Setup.copy(s) local t = table.create(184); for i = 0, 183 do t[i] = s[i] end; return t end
function Setup.cupDefault() return Setup.copy(DATA.cupDefault) end
function Setup.cupGarageDefault() return Setup.copy(DATA.cupGarageDefault) end
-- display value of item i as a Luau number (what the garage page prints)
function Setup.display(s, i, mode)
	i = Setup.index(i)
	local d = ITEM[i]
	if not d.desc then return bitsToF(s[i]) end
	local v = CONV[d.toDisplay](s[i], mode or "nearest")
	if d.type == 3 then return i32(v) end
	return bitsToF(v)
end
-- set item i from a display-unit number through the ORIGINAL 005581d0 (snap + clamp); returns the value stored
function Setup.set(s, i, value, mode)
	i = Setup.index(i)
	local d = desc(i)
	assert(d.toInternal, "NR2003 setup: item " .. i .. " (" .. d.name .. ") is not adjustable")
	local bits = d.type == 3 and u32(math.floor(value + 0.5)) or f32n(value)
	local v = Setup.setSnapped(s, i, bits, mode)
	return d.type == 3 and i32(v) or bitsToF(v)
end
Setup.bitsToF = bitsToF
Setup.f32bits = f32n
Setup.i32 = i32
Setup.u32 = u32
return Setup
end
