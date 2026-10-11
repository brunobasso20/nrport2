-- Stage 11 diagnostic: Luau memory vs the ORIGINAL after the session start and after each frame (module written by
-- recovery/stage11/dev/memdump.py):   luau -O2 --codegen tests/stage11/dev/memdiff.luau -a <scenario> <module> [maxPerFrame] [frozen|-] [structs]
local Vehicle = require("../../../core/NR2003CupVehicle")
local function get(name)
	local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name)
	if ok then return m end
	return nil
end
local args = {...}
local name, mod, maxl = args[1], args[2], tonumber(args[3] or "30")
local fx = require("../fixtures/scenario_" .. name)
local D = require(mod)
local V = Vehicle.fromLoader(get).V
local M, BASE = V.memory(), V.base
local FLAT = {}
for i = 1, 4 do FLAT[i] = {0, 0, 1, 0, 0, 0, 0, 1, 1} end
local B64 = {}
do
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	for i = 1, 64 do B64[string.byte(chars, i)] = i - 1 end
end
local function b64(s)
	local out = buffer.create(#s * 3 // 4)
	local o = 0
	for i = 1, #s, 4 do
		local a, b, c, d = string.byte(s, i, i + 3)
		local x = B64[a] * 262144 + B64[b] * 4096 + (c ~= 61 and B64[c] or 0) * 64 + (d ~= 61 and B64[d] or 0)
		buffer.writeu8(out, o, bit32.rshift(x, 16)); o += 1
		if c ~= 61 then buffer.writeu8(out, o, bit32.band(bit32.rshift(x, 8), 0xff)); o += 1 end
		if d ~= 61 then buffer.writeu8(out, o, bit32.band(x, 0xff)); o += 1 end
	end
	return out
end
local S = buffer.create(4)
local function fb(u) buffer.writeu32(S, 0, u); return buffer.readf32(S, 0) end
local function compare(k)
	local b, o, bad = b64(D.frames[k + 1]), 0, 0
	local lines = {}
	for _, r in ipairs(D.runs) do
		for i = 0, r[2] - 1 do
			local a = r[1] + 4 * i
			local want, got = buffer.readu32(b, o), buffer.readu32(M, a - BASE)
			o += 4
			local big = true
			if BIG and want ~= got then
				local x, y = fb(want), fb(got)
				big = not (x == x and y == y and math.abs(x - y) <= 1e-5 * math.max(math.abs(x), math.abs(y)))
				for _, h in ipairs(HOSTONLY) do if a >= h[1] and a < h[2] then big = false end end
			end
			if want ~= got and big then
				bad += 1
				if #lines < maxl then table.insert(lines, string.format("  %08x want %08x (%.9g) got %08x (%.9g)", a, want, fb(want), got, fb(got))) end
			end
		end
	end
	print(string.format("frame %d: %d dwords differ", k, bad))
	for _, l in ipairs(lines) do print(l) end
	-- packed structs at unaligned bases (tyres stride 0xa39, damage car+0x1493): float fields at struct offsets
	if STRUCTS then
		local W = buffer.create(buffer.len(M))
		buffer.copy(W, 0, M, 0, buffer.len(M))
		local b2, o2 = b64(D.frames[k + 1]), 0
		for _, r in ipairs(D.runs) do buffer.copy(W, r[1] - BASE, b2, o2, 4 * r[2]); o2 += 4 * r[2] end
		for _, st in ipairs(STRUCTS) do
			local n = 0
			for off = 0, st[3] - 4, 4 do
				local a = st[2] + off - BASE
				local x, y = buffer.readu32(W, a), buffer.readu32(M, a)
				if x ~= y then
					n += 1
					if n <= maxl then print(string.format("    %s+%03x want %08x (%.9g) got %08x (%.9g)", st[1], off, x, fb(x), y, fb(y))) end
				end
			end
		end
	end
end
STRUCTS = nil
-- big: only dwords that are not float-close (1e-5 relative), outside the host cells that differ by design (Python
-- driver subset 00551e80 / export scratch of the harness)
BIG = args[6] == "big"
HOSTONLY = {{0x74c960, 0x74c9b0}, {0xbf6ed0, 0xbf6ef4}, {0xe847c8, 0xe847cc}, {0xf7f240, 0xf7f2f4}}
if args[5] == "structs" then
	STRUCTS = {}
	for w = 0, 3 do table.insert(STRUCTS, {"tyre" .. w, 0xbf3a20 + w * 0xa39, 0xa39}) end
	table.insert(STRUCTS, {"damage", 0xc12030 + 0x1493, 0x80})
end
local s = fx.law.session
if args[4] == "frozen" then V.setRuntimeMode("frozen") end
local o = fx.law.options or {}
V.startSession({temperatureF = s.temperature, windSpeedMph = s.wind_mph, windDirection = s.wind_dir, conditions = s.conditions,
	night = s.night == 1}, {damageLevel = o.damage_level, consumptionRate = o.consumption, series = o.series or 1, seed = o.seed})
compare(0)
local ev = {}
for _, e in ipairs(fx.law.events) do ev[e[1]] = ev[e[1]] or {}; table.insert(ev[e[1]], e) end
for k = 0, #D.frames - 2 do
	for _, e in ipairs(ev[k] or {}) do if e[2] == "enter" then V.enterTrack() end end
	local c = fx.law.controls[k + 1]
	for _ = 1, 8 do V.drive({throttle = c[1], clutch = c[2], steer = c[3], brakeControl = c[4], brakeDigital = true, shiftUp = c[5], shiftDown = c[6]}, FLAT) end
	compare(k + 1)
end
