-- Stage 11 diagnostic (Luau CLI): list every mismatching dword of one synchronized snapshot.
--   luau -O2 --codegen tests/stage11/dev/diff_sync.luau -a <scenario> <index>
local Vehicle = require("../../../core/NR2003CupVehicle")
local FP = require("../fixtures/footprint")
local function get(name)
	local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name)
	if ok then return m end
	return nil
end
local args = {...}
local name, idx = args[1] or "cold", tonumber(args[2] or "1")
local fx = require("../fixtures/scenario_" .. name)
local car = Vehicle.fromLoader(get)
local V = car.V
local M, BASE = V.memory(), V.base
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
local s = fx.law.session
V.startSession({temperatureF = s.temperature, windSpeedMph = s.wind_mph, windDirection = s.wind_dir, conditions = s.conditions,
	night = s.night == 1}, {})
local sn = fx.sync[idx]
print("snapshot", idx, sn.kind, "frame", sn.frame)
local b, o = b64(sn.before), 0
for _, r in ipairs(FP.touchRuns) do buffer.copy(M, r[1] - BASE, b, o, 4 * r[2]); o += 4 * r[2] end
-- 'before' values of the written set, to see what the frame end changed
local before = {}
do
	local bb, oo = b64(sn.before), 0
	for _, r in ipairs(FP.touchRuns) do
		for k = 0, r[2] - 1 do before[r[1] + 4 * k] = buffer.readu32(bb, oo); oo += 4 end
	end
end
if sn.kind == "frame" then V._frameEnd() end
local a, oa = b64(sn.after), 0
local n = 0
for _, r in ipairs(FP.writeRuns) do
	for k = 0, r[2] - 1 do
		local addr = r[1] + 4 * k
		local want, mine = buffer.readu32(a, oa), buffer.readu32(M, addr - BASE)
		oa += 4
		if want ~= mine then
			n += 1
			local tyre = ""
			if addr >= 0xbf3a20 and addr < 0xbf3a20 + 4 * 0xa39 then
				local w = (addr - 0xbf3a20) // 0xa39
				tyre = string.format(" tyre%d+0x%03x", w, addr - 0xbf3a20 - w * 0xa39)
			elseif addr >= 0xc12030 and addr < 0xc12030 + 0x15b8 then
				tyre = string.format(" car+0x%04x", addr - 0xc12030)
			end
			print(string.format("%08x%s  before %08x (%.7g)  want %08x (%.9g)  got %08x (%.9g)", addr, tyre, before[addr] or 0,
				fb(before[addr] or 0), want, fb(want), mine, fb(mine)))
		end
	end
end
print("mismatches", n)
