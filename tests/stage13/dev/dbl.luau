local Vehicle = require("../../../core/NR2003CupVehicle")
local function get(name) local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name); if ok then return m end; return nil end
local car = Vehicle.fromLoader(get)
local V = car.V
local fx = require("../fixtures/scenario_slalom")
local B64 = {}
do local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"; for i = 1, 64 do B64[string.byte(chars, i)] = i - 1 end end
local function b64(s)
	local out = buffer.create(#s * 3 // 4); local o = 0
	for i = 1, #s, 4 do
		local a, b, c, d = string.byte(s, i, i + 3)
		local x = B64[a] * 262144 + B64[b] * 4096 + (c ~= 61 and B64[c] or 0) * 64 + (d ~= 61 and B64[d] or 0)
		buffer.writeu8(out, o, bit32.rshift(x, 16)); o += 1
		if c ~= 61 then buffer.writeu8(out, o, bit32.band(bit32.rshift(x, 8), 0xff)); o += 1 end
		if d ~= 61 then buffer.writeu8(out, o, bit32.band(x, 0xff)); o += 1 end
	end
	return out
end
local ACC = {0xbf6ed4, 0xbf6ed8, 0xbf6edc, 0xbf6ee0, 0xbf6ee4, 0xbf6ee8, 0xbf6eec, 0xbf6ef0}
local OUTS = {0x74c960, 0xbf6ec4, 0xbf6ec8, 0xbf6ed0}
local b = b64(fx.stats)
local cnt = {0, 0, 0, 0}
for r = 0, 2000 do
	local o = 60 * r
	local function load()
		V.w32(0x74c964, buffer.readu32(b, o + 4)); V.w32(0x74c968, buffer.readu32(b, o + 8))
		for k = 1, 8 do V.w32(ACC[k], buffer.readu32(b, o + 8 + 4 * k)) end
	end
	load(); V._ffbModel("x87"); V.ffbStatsOriginal()
	local x = {}; for k = 1, 4 do x[k] = V.r32(OUTS[k]) end
	load(); V._ffbModel("double"); V.ffbStatsOriginal()
	for k = 1, 4 do
		if V.r32(OUTS[k]) ~= x[k] then
			cnt[k] += 1
			if cnt[k] <= 2 then print(string.format("r %d cell %x x87 %08x (%.9g) dbl %08x (%.9g)", r, OUTS[k], x[k], V.rf32(OUTS[k]) , V.r32(OUTS[k]), V.rf32(OUTS[k]))) end
		end
	end
end
print("mismatch per cell", table.concat(cnt, " "))
