-- dev: list the dwords differing in the frame-start snapshots of a scenario (sign of zero vs value)
local Vehicle = require("../../../core/NR2003CupVehicle")
local function get(name) local ok, m = pcall(require, "../../../core/NR2003Cup/" .. name); if ok then return m end; return nil end
local car = Vehicle.fromLoader(get)
local V = car.V
local M, BASE = V.memory(), V.base
local name = ({...})[1] or "slalom"
local fx = require("../fixtures/scenario_" .. name)
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
local function applyRuns(runs, s) local b = b64(s); local o = 0; for _, r in ipairs(runs) do buffer.copy(M, r[1] - BASE, b, o, 4 * r[2]); o += 4 * r[2] end end
local function mapOf(runs, s) local b = b64(s); local t, o = {}, 0; for _, r in ipairs(runs) do for k = 0, r[2] - 1 do t[r[1] + 4 * k] = buffer.readu32(b, o); o += 4 end end; return t end
local S = buffer.create(4)
local function fb(u) buffer.writeu32(S, 0, u); return buffer.readf32(S, 0) end
local function controlsOf(row)
	local c = {throttle = row[1], clutch = row[2], brakeControl = row[3], brakeDigital = true, shiftUp = row[4], shiftDown = row[5]}
	if row[9] then c.steerAxis = row[10] else c.steerLeft = row[6]; c.steerRight = row[7]; c.steerDigital = row[8] end
	if not row[11] then c.driver = false end
	return c
end
V.setRuntimeMode("original"); V.endSession(); V.reset()
if fx.law.steer then V.setSteeringOptions(fx.law.steer, true) end -- validation: may set race bit 25 as the reference
V.startSession({temperatureF = 70, windSpeedMph = 0, windDirection = 0, conditions = 0, night = false}, {damageLevel = 0, series = 1})
local count, zeroSign = {}, {}
for _, sn in ipairs(fx.start) do
	local cp = V.checkpoint()
	applyRuns(sn.beforeRuns, sn.before)
	V._frameStartOnly(controlsOf(sn.controls))
	for a, w in pairs(mapOf(sn.afterRuns, sn.after)) do
		local mine = V.r32(a)
		if mine ~= w then
			local k = string.format("%08x", a)
			count[k] = (count[k] or 0) + 1
			if fb(w) == 0 and fb(mine) == 0 then zeroSign[k] = (zeroSign[k] or 0) + 1
			elseif (count[k] or 0) <= 2 then print(string.format("frame %d %s want %08x (%.9g) got %08x (%.9g)", sn.frame, k, w, fb(w), mine, fb(mine))) end
		end
	end
	V.restore(cp)
end
for k, n in pairs(count) do print(k, n, "sign-of-zero only:", zeroSign[k] or 0) end
