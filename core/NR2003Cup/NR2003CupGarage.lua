--!optimize 2
-- Stage 10: garage setup -> runtime parameters for the NR2003 Cup core.
--
--   Garage / user setup        NR2003CupSetup (hand port of the ORIGINAL descriptor table c05150, unit
--   (display units)            converters 00423dc0..004241f0, garage API 005582d0/00558320/00557e40/
--         |                    005581d0/005580f0/005583e0/00558380, .sto validation 00558da0/004247e0)
--         v  raw 184-item setup (IEEE single / int32 bits, exactly the game's c03350/c055c0 layout)
--   Recovered NR2003 setup     NR2003CupBuild (ORIGINAL car-build sequence lifted from the exe:
--   conversion                 00559820 derived items, 00550c40 engine/gears, 00550c60 fuel, 00550bc0
--         |                    tyres, 005b29c0 component tree, 005b2f20 -> 0055e9b0 setup -> runtime
--         v                    cells + callback generation, 0054d610 x4)
--   Runtime physics            NR2003CupCore memory (cells read by the Stage 6/7 translated callbacks and
--   parameters                 lifted natives, Stage 8 driver layer, Stage 9 aero)
--
-- Applying a setup = the original rebuilds the car (garage -> track). Here: the core memory is reset
-- to the current reset image, the ORIGINAL application sequence runs on it, the result becomes the new
-- reset image and the car is reset (V.reset: Stage 8/9 layers included). Nothing is converted by
-- hand-written formulas in this module (ROBLOX ADAPTER: orchestration, reporting only).
--
-- Callback structure (the original regenerates its x87 callbacks at every build, folding value-dependent
-- decisions, see SETUP_MAP.md "estrutura"):
--   "image"   the shipped image = ORIGINAL build of the Cup default garage setup (exact Stage 6-9 state)
--   "natural" the setup's own ORIGINAL emitter outcome equals the default's: same code as the shipped
--             callbacks (NR2003CupJIT*), cells rebuilt for the setup (exact original structure)
--   "generic" otherwise: setup-invariant structure (NR2003CupJITG*, no-fold at setup-dependent sites);
--             differs from the setup's own original code only by float32 rounding at fold sites
-- Pure Luau: no Instances.
return function(V, Setup, Build, genericJIT)
	local M, BASE = V.memory(), V.base
	local PRISTINE = V._pristine()
	local SIZE = V.imageSize
	local ru, rf = buffer.readu32, buffer.readf32
	local function r32(a) return ru(M, a - BASE) end
	local function rf32(a) return rf(M, a - BASE) end
	local ACTIVE = 0xc055c0

	local JIT = V._jitTable()
	local CODE = {natural = table.clone(JIT), generic = V._jitLoad(genericJIT or {})}
	assert(next(CODE.generic), "NR2003CupJITG modules missing")
	local function selectCode(structure)
		local src = CODE[structure == "generic" and "generic" or "natural"]
		table.clear(JIT)
		for a, f in pairs(src) do JIT[a] = f end
	end
	-- the shipped reset image is the original build of the Cup default garage setup (00559950)
	local IMAGE_FOOTPRINT = Build.saveFootprint(PRISTINE)
	local IMAGE_STRUCTURE = "natural"
	-- default garage setup before (00559950) and after (c055c0 of the image, items derived by 00559820)
	-- the application; both rebuild to the shipped image (00559820 recomputes the derived items)
	local DEFAULT = Setup.cupGarageDefault()
	local DEFAULT_APPLIED = table.create(184)
	for i = 0, 183 do DEFAULT_APPLIED[i] = ru(PRISTINE, ACTIVE + 4 * i - BASE) end
	local current = Setup.copy(DEFAULT_APPLIED)
	local active = "image"
	local lastReport = {ok = true, structure = "image", violations = 0, imposed = 0}

	V.Setup = Setup
	V.Build = Build
	-- Watkins Glen port: a loaded track changes the reset image (NR2003CupTrack): the shipped-image footprint follows it
	function V._garageRefreshImage()
		IMAGE_FOOTPRINT = Build.saveFootprint(PRISTINE)
		IMAGE_STRUCTURE = active == "generic" and "generic" or "natural"
	end
	function V._garageStructure() return active == "generic" and "generic" or "natural" end
	-- further callback sets (Watkins Glen port: the car placed on the track) and their selection by name
	function V._garageAddCode(name, modules) CODE[name] = V._jitLoad(modules) end
	function V._garageUseCode(name)
		local src = assert(CODE[name], "NR2003 garage: no callback set " .. tostring(name))
		table.clear(JIT)
		for a, f in pairs(src) do JIT[a] = f end
	end

	local function same(a, b)
		for i = 0, 183 do if a[i] ~= b[i] then return false end end
		return true
	end
	local function isDefault(items) return same(items, DEFAULT) or same(items, DEFAULT_APPLIED) end
	-- s: raw setup array [0..183] (NR2003CupSetup representation). Runs the ORIGINAL application; on
	-- success the rebuilt car becomes the reset image and the car is reset. When neither structure can
	-- represent the setup (see SETUP_MAP.md) nothing is committed and the previous setup stays.
	-- opts.structure = "natural" | "generic" forces one structure; opts.rebuild = true rebuilds the
	-- default setup instead of restoring the shipped image.
	function V.applySetup(s, opts)
		opts = opts or {}
		assert(type(s) == "table" and s[0] ~= nil, "NR2003 applySetup: raw setup array [0..183] expected")
		local items = {}
		for i = 0, 183 do
			local u = s[i]
			assert(type(u) == "number" and u >= 0 and u < 4294967296 and u % 1 == 0, "NR2003 applySetup: item " .. i .. " is not a raw u32")
			items[i] = u
		end
		local t0 = os.clock()
		if isDefault(items) and not opts.rebuild and not opts.structure then
			Build.loadFootprint(PRISTINE, IMAGE_FOOTPRINT)
			selectCode(IMAGE_STRUCTURE)
			active = IMAGE_STRUCTURE == "natural" and "image" or "generic"
			lastReport = {ok = true, structure = active, violations = 0, imposed = 0, seconds = os.clock() - t0}
			V.reset()
			if V._bindDriverCells then V._bindDriverCells() end
			for i = 0, 183 do current[i] = r32(ACTIVE + 4 * i) end
			return true, lastReport
		end
		local tries = opts.structure and {opts.structure} or {"natural", "generic"}
		local ok, rep, attempts = false, nil, {}
		for _, structure in ipairs(tries) do
			buffer.copy(M, 0, PRISTINE, 0, SIZE)
			selectCode(structure)
			ok, rep = Build.run(items, structure)
			attempts[#attempts + 1] = rep
			if ok then break end
		end
		rep.attempts = attempts
		rep.seconds = os.clock() - t0
		if ok then
			Build.copyFootprint(PRISTINE, M)
			for i = 0, 183 do current[i] = r32(ACTIVE + 4 * i) end -- incl. items derived by 00559820
			active = rep.structure
		else
			selectCode(active == "generic" and "generic" or "natural")
		end
		lastReport = rep
		V.reset()
		if V._bindDriverCells then V._bindDriverCells() end -- Stage 8 cells of the active structure
		return ok, rep
	end
	function V.setupStructure() return active end
	-- applied setup (raw, as stored by the original in c055c0 after 00559820)
	function V.setup() return Setup.copy(current) end
	function V.setupReport() return lastReport end

	-- concise garage -> runtime inspection (no per-tick output): display values of the adjustable items and
	-- the runtime cells the original build derived from them (current core memory)
	local C4 = {"LF", "RF", "LR", "RR"}
	local function cells4(base, ind)
		local t = table.create(4, 0)
		for w = 0, 3 do
			local a = base + 4 * w
			if ind then a = r32(a) end
			t[w + 1] = rf32(a)
		end
		return t
	end
	function V.setupDump(out)
		out = out or {}
		local s = current
		local items = {}
		for i = 0, 70 do
			local d = Setup.ITEM[i]
			if d.desc and Setup.adjustable(i) then
				items[#items + 1] = {index = i, name = d.name, unit = d.unit, display = Setup.display(s, i), raw = s[i]}
			end
		end
		out.items = items
		local ENGINE = 0xc12030 + 0xc
		local gears = {}
		for k = 0, 7 do gears[k + 1] = rf32(ENGINE + 0x448 + 4 * k) end
		out.runtime = {
			springRate = cells4(0x74e0a0),          -- 0055e9b0: wheel rate N/m (sign -), items 20..23
			bumpStopRate = cells4(0x74e0d0),        -- items 137..140 (derived)
			bumpStopGap = cells4(0x74e0b0),         -- items 149..152 (derived)
			bumpRubber = cells4(0x74e0c0),          -- items 28..31
			shockBump = cells4(0x74e0e0),           -- damper coefficients from items 129..132
			shockRebound = cells4(0x74e0f0),        -- items 133..136
			antiRollRate = {rf32(r32(0x74e788)), rf32(r32(0x74e78c))}, -- items 99/100 (variable cells)
			brakeTorque = cells4(0xc0850c, true),   -- item 40 x car max torque (variable cells, Stage 8)
			toeHalf = cells4(0xc086b0),             -- items 41/42 (x0.5)
			springPerch = cells4(0xc083b0),         -- items 145..148
			trackBar = {rf32(0xc085ac), rf32(r32(0xc085b0))}, -- items 45/46
			aeroRefHeight = {rf32(0xc084c8), rf32(0xc084cc)}, -- items 173/174 (Stage 9 aero)
			aeroPitchOffset = rf32(0xc083c4),       -- item 177
			casterTrail = {rf32(0xc082d4), rf32(0xc082d8)}, -- items 67/68
			gearCount = buffer.readi32(M, ENGINE + 0x444 - BASE),
			gearRatio = gears,                      -- items 102..109 via 0051a730
			finalDrive = rf32(ENGINE + 0x468),      -- item 110
			tyrePressure = {rf32(0xbf3a20), rf32(0xbf3a20 + 0xa39), rf32(0xbf3a20 + 2 * 0xa39), rf32(0xbf3a20 + 3 * 0xa39)},
		}
		out.corners = C4
		out.report = lastReport
		return out
	end
	return V
end
