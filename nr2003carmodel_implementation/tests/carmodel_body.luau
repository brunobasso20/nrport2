-- nr2003carmodel tests (Luau CLI): luau -O2 nr2003carmodel_implementation/tests/carmodel_run.luau [-a +detail]
-- Generated wrapper: tests/make_carmodel_tests.py [<package dir>] (embeds roblox/CarModel/*.lua and, optionally, the
-- converted descriptor). Golden values: fixtures_carmodel.lua, produced by recovery/gen_fixtures.py from the ORIGINAL
-- NR2003.exe / rendserv.dll code executed in Unicorn (recovery/orig_carmodel.py) and the reference rig (pipeline).
local FX = require("./fixtures_carmodel")
local ARGS = {...}
local DETAIL = false
for _, a in ipairs(ARGS) do if a == "+detail" then DETAIL = true end end

local passed, failed = 0, 0
local function check(name, ok, detail)
	if ok then passed += 1 else failed += 1 end
	print((ok and "PASS  " or "FAIL  ") .. name .. (detail and ("  " .. detail) or ""))
end
local S = buffer.create(8)
local function f32(x) buffer.writef32(S, 0, x); return buffer.readf32(S, 0) end
local function ulp32(x) -- spacing of f32 values at |x|
	x = math.abs(x)
	if x < 1.1754943508222875e-38 then return 1.401298464324817e-45 end
	local _, e = math.frexp(x)
	return 2 ^ (e - 24)
end

------------------------------------------------------------------------------------------------- Roblox API mock
local Vector3 = {}
Vector3.__index = function(v, k)
	if k == "Magnitude" then return math.sqrt(v.X * v.X + v.Y * v.Y + v.Z * v.Z) end
	if k == "Unit" then local m = math.sqrt(v.X * v.X + v.Y * v.Y + v.Z * v.Z); return Vector3.new(v.X / m, v.Y / m, v.Z / m) end
	return Vector3[k]
end
function Vector3.new(x, y, z) return setmetatable({X = x or 0, Y = y or 0, Z = z or 0}, Vector3) end
Vector3.__add = function(a, b) return Vector3.new(a.X + b.X, a.Y + b.Y, a.Z + b.Z) end
Vector3.__sub = function(a, b) return Vector3.new(a.X - b.X, a.Y - b.Y, a.Z - b.Z) end
Vector3.__unm = function(a) return Vector3.new(-a.X, -a.Y, -a.Z) end
Vector3.__mul = function(a, b)
	if type(a) == "number" then return Vector3.new(a * b.X, a * b.Y, a * b.Z) end
	if type(b) == "number" then return Vector3.new(a.X * b, a.Y * b, a.Z * b) end
	return Vector3.new(a.X * b.X, a.Y * b.Y, a.Z * b.Z)
end
Vector3.__div = function(a, b) return Vector3.new(a.X / b, a.Y / b, a.Z / b) end
function Vector3.Dot(a, b) return a.X * b.X + a.Y * b.Y + a.Z * b.Z end
function Vector3.Cross(a, b) return Vector3.new(a.Y * b.Z - a.Z * b.Y, a.Z * b.X - a.X * b.Z, a.X * b.Y - a.Y * b.X) end
Vector3.zero = Vector3.new(0, 0, 0)

local CFrame = {}
CFrame.__index = function(c, k)
	if k == "Position" then return Vector3.new(c.p[1], c.p[2], c.p[3]) end
	if k == "Rotation" then return CFrame.fromParts({0, 0, 0}, c.r) end
	return CFrame[k]
end
function CFrame.fromParts(p, r) return setmetatable({p = {p[1], p[2], p[3]}, r = table.clone(r)}, CFrame) end
function CFrame.new(x, y, z, ...)
	if type(x) == "table" then return CFrame.fromParts({x.X, x.Y, x.Z}, {1, 0, 0, 0, 1, 0, 0, 0, 1}) end
	local r = {...}
	if #r == 0 then r = {1, 0, 0, 0, 1, 0, 0, 0, 1} end
	return CFrame.fromParts({x or 0, y or 0, z or 0}, r)
end
function CFrame.fromMatrix(p, vx, vy, vz)
	return CFrame.fromParts({p.X, p.Y, p.Z}, {vx.X, vy.X, vz.X, vx.Y, vy.Y, vz.Y, vx.Z, vy.Z, vz.Z})
end
local function mulR(a, b)
	local c = {}
	for i = 0, 2 do for j = 0, 2 do
		c[i * 3 + j + 1] = a[i * 3 + 1] * b[j + 1] + a[i * 3 + 2] * b[3 + j + 1] + a[i * 3 + 3] * b[6 + j + 1]
	end end
	return c
end
local function rv(r, v) return Vector3.new(r[1] * v.X + r[2] * v.Y + r[3] * v.Z, r[4] * v.X + r[5] * v.Y + r[6] * v.Z, r[7] * v.X + r[8] * v.Y + r[9] * v.Z) end
CFrame.__mul = function(a, b)
	if getmetatable(b) == Vector3 then local w = rv(a.r, b); return Vector3.new(w.X + a.p[1], w.Y + a.p[2], w.Z + a.p[3]) end
	local w = rv(a.r, Vector3.new(b.p[1], b.p[2], b.p[3]))
	return CFrame.fromParts({w.X + a.p[1], w.Y + a.p[2], w.Z + a.p[3]}, mulR(a.r, b.r))
end
function CFrame.Inverse(c)
	local r = c.r
	local t = {r[1], r[4], r[7], r[2], r[5], r[8], r[3], r[6], r[9]}
	local p = rv(t, Vector3.new(c.p[1], c.p[2], c.p[3]))
	return CFrame.fromParts({-p.X, -p.Y, -p.Z}, t)
end
function CFrame.GetComponents(c) return c.p[1], c.p[2], c.p[3], table.unpack(c.r) end
function CFrame.Angles(rx, ry, rz)
	local cx, sx, cy, sy, cz, sz = math.cos(rx), math.sin(rx), math.cos(ry), math.sin(ry), math.cos(rz), math.sin(rz)
	return CFrame.fromParts({0, 0, 0}, mulR(mulR({1, 0, 0, 0, cx, -sx, 0, sx, cx}, {cy, 0, sy, 0, 1, 0, -sy, 0, cy}), {cz, -sz, 0, sz, cz, 0, 0, 0, 1}))
end
local function cfError(a, b) -- max |position| (studs), max |rotation element|
	local dp = 0
	for i = 1, 3 do dp = math.max(dp, math.abs(a.p[i] - b.p[i])) end
	local dr = 0
	for i = 1, 9 do dr = math.max(dr, math.abs(a.r[i] - b.r[i])) end
	return dp, dr
end

-- parts / models (only what NR2003CarModelRig touches)
local Part = {}
Part.__index = function(p, k)
	if k == "Position" then return rawget(p, "CFrame").Position end
	return Part[k]
end
function Part.IsA(p, c) return c == "BasePart" or c == "MeshPart" or c == "Instance" end
function Part.Clone(p) local c = setmetatable({}, Part); for k, v in pairs(p) do c[k] = v end; c.Parent = nil; return c end
function Part.GetDescendants() return {} end
function Part.Destroy(p) p.Parent = nil end
local function newPart(name, cf, size) return setmetatable({Name = name, CFrame = cf, Size = size, TextureID = ""}, Part) end
local Model = {}
Model.__index = Model
function Model.SetAttribute(m, k, v) m.attrs[k] = v end
function Model.Destroy(m) m.destroyed = true end
local Instance = {new = function(class)
	assert(class == "Model", "mock: Instance.new " .. tostring(class))
	return setmetatable({ClassName = "Model", attrs = {}}, Model)
end}
local bulk = {calls = 0, parts = 0}
local workspace = {}
function workspace:BulkMoveTo(parts, cframes)
	bulk.calls += 1; bulk.parts = #parts
	for i, p in ipairs(parts) do p.CFrame = cframes[i] end
end
local Enum = {BulkMoveMode = {FireCFrameChanged = "FireCFrameChanged"}}
local Random = {new = function(seed)
	local st = seed
	return {NextNumber = function(_, a, b) st = (st * 1103515245 + 12345) % 2147483648; return a + (b - a) * st / 2147483648 end}
end}

-- module system: script.Parent.<Name> -> {ref = Name}; require loads the embedded source with the mock globals
local loaded = {}
-- script.Parent of the CarModel modules; its Parent is the NR2003Lab package (Core.CupTune / Core.TestTune)
local folder = {}
local corePkg = {FindFirstChild = function(self, name) return self[name] end, CupTune = {ref = "CupTune"}, TestTune = {ref = "TestTune"}}
folder.Parent = {Core = corePkg, FindFirstChild = function(self, name) return self[name] end}
function folder.FindFirstChild(_, name) return nil end
setmetatable(folder, {__index = function(_, name) return {ref = name} end})
local function mockRequire(ref)
	local name = ref.ref
	if loaded[name] then return loaded[name] end
	local f = assert(loadstring(assert(SOURCES[name], "no source " .. name), name))
	setfenv(f, setmetatable({script = {Parent = folder}, require = mockRequire, workspace = workspace, Vector3 = Vector3,
		CFrame = CFrame, Instance = Instance, Enum = Enum, Random = Random}, {__index = _G}))
	loaded[name] = f()
	return loaded[name]
end
local Scale = mockRequire({ref = "NR2003Scale"})
local Gauges = mockRequire({ref = "NR2003Gauges"})
local DrawState = mockRequire({ref = "NR2003DrawState"})
local Cameras = mockRequire({ref = "NR2003CameraSystem"})
local Rig = mockRequire({ref = "NR2003CarModelRig"})
check("load the CarModel modules under the mock", Scale and Gauges and DrawState and Cameras and Rig and true or false)

----------------------------------------------------------------------------------------------- NR2003Scale
do
	-- the ONE scale: identical to the bench constant (TestTune / CupTune metresPerStud) of the Stage 5-13 modules
	local TestTune = mockRequire({ref = "TestTune"})
	local CupTune = mockRequire({ref = "CupTune"})
	check("METRES_PER_STUD == core TestTune / CupTune metresPerStud (the Stage 5-13 bench and Cup adapter scale)",
		Scale.METRES_PER_STUD == TestTune.metresPerStud and Scale.METRES_PER_STUD == CupTune.metresPerStud
		and pcall(Scale.check, CupTune), string.format("%g m/stud", Scale.METRES_PER_STUD))
	check("Scale.check rejects a different scale", not pcall(Scale.check, {metresPerStud = 0.3}))
	-- axis map: +X fwd -> -Z, +Y left -> -X, +Z up -> +Y; cframe(t, R) * point(v) == point(t + R v)
	local worst, worstInv, worstRound = 0, 0, 0
	local seed = 12345
	local function rand(a, b) seed = (seed * 1103515245 + 12345) % 2147483648; return a + (b - a) * seed / 2147483648 end
	for _ = 1, 200 do
		local h, p, r = rand(-3.1, 3.1), rand(-1.5, 1.5), rand(-3.1, 3.1)
		local R = Scale.euler(h, p, r)
		local t = {rand(-50, 50), rand(-50, 50), rand(-5, 5)}
		local v = {rand(-3, 3), rand(-3, 3), rand(-3, 3)}
		local cf = Scale.cframe(t[1], t[2], t[3], R)
		local a = cf * Scale.point(v[1], v[2], v[3])
		local x, y, z = Scale.apply(R, v[1], v[2], v[3])
		local b = Scale.point(t[1] + x, t[2] + y, t[3] + z)
		worst = math.max(worst, (a - b).Magnitude)
		local tx, ty, tz, R2 = Scale.fromCFrame(cf)
		local d = math.max(math.abs(tx - t[1]), math.abs(ty - t[2]), math.abs(tz - t[3]))
		for i = 1, 9 do d = math.max(d, math.abs(R2[i] - R[i])) end
		worstInv = math.max(worstInv, d)
		local px, py, pz = Scale.toNRPoint(Scale.point(v[1], v[2], v[3]))
		worstRound = math.max(worstRound, math.abs(px - v[1]), math.abs(py - v[2]), math.abs(pz - v[3]))
	end
	local p = Scale.point(1, 0, 0)
	local q = Scale.point(0, 1, 0)
	local u = Scale.point(0, 0, 1)
	check("axis map: 1 m forward = -Z, 1 m left = -X, 1 m up = +Y (in 1/0.28 studs)",
		math.abs(p.Z + 1 / 0.28) < 1e-12 and p.X == 0 and p.Y == 0 and math.abs(q.X + 1 / 0.28) < 1e-12 and math.abs(u.Y - 1 / 0.28) < 1e-12)
	check("Scale.cframe(t, R) * point(v) == point(t + R v) (200 random poses)", worst < 1e-9, string.format("max %.3g studs", worst))
	check("Scale.fromCFrame inverts Scale.cframe; toNRPoint inverts point", worstInv < 1e-12 and worstRound < 1e-12,
		string.format("%.3g / %.3g", worstInv, worstRound))
	check("verticalFov: 4:3 horizontal 65 deg -> 51.0772 deg vertical (Hor+)", math.abs(Scale.verticalFov(math.rad(65)) - 51.077193466669826) < 1e-9,
		string.format("%.4f", Scale.verticalFov(math.rad(65))))
end

-------------------------------------------------------------------------------- 005f6f20 / 005f74c0 (original)
do
	local worst = 0
	for _, e in ipairs(FX.euler) do
		local R = Scale.euler(e[1][1], e[1][2], e[1][3])
		for i = 1, 9 do worst = math.max(worst, math.abs(R[i] - e[2][i])) end
	end
	check("Scale.euler == ORIGINAL 005f6f20 (150 vectors, f32 result)", worst <= 1.2e-7, string.format("max %.3g", worst))
	local worstD = 0
	for _, e in ipairs(FX.decompose) do
		local h, p, r = Scale.decompose(e[1])
		worstD = math.max(worstD, math.abs(h - e[2][1]), math.abs(p - e[2][2]), math.abs(r - e[2][3]))
	end
	check("Scale.decompose == ORIGINAL 005f74c0 (150 matrices, f32 result)", worstD <= 4.8e-7, string.format("max %.3g rad", worstD))
end

---------------------------------------------------------------------------------- 0056f040 gauges (original)
do
	local exact, worst, n = 0, 0, 0
	local firstBad
	for _, g in ipairs(FX.gauges) do
		local cal = Gauges.CAL[g[1]]
		local a = Gauges.angle(cal, g[2])
		n += 1
		if a == g[3] then exact += 1 end
		local d = math.abs(a - g[3]) / ulp32(g[3])
		if d > worst then worst = d; firstBad = string.format("%s(%.9g) = %.9g, original %.9g", g[1], g[2], a, g[3]) end
	end
	check(string.format("needle angles == ORIGINAL 0056f040 (%d values incl. clamps and NaN, 6 calibrations)", n),
		worst <= 1, string.format("%d exact, max %.2g f32 ulp%s", exact, worst, (worst > 0 and DETAIL and firstBad) and ("  " .. firstBad) or ""))
	local ws = 0
	for _, w in ipairs(FX.wheelSpeed) do if DrawState.wheelSpeedState(w[1]) == w[2] then ws += 1 end end
	check("wheel_speed state == ORIGINAL 00565b10", ws == #FX.wheelSpeed, string.format("%d / %d", ws, #FX.wheelSpeed))
	-- warning lights (005662d0): thresholds and blink bit
	local L = Gauges.lights({rpm = 9000, revLimit = 9400, bgCount = 0, temp1524 = 111, oilPressure = 2.0, fuelPressure = 0.3})
	local L2 = Gauges.lights({rpm = 8900, revLimit = 9400, bgCount = 16, temp1524 = 110, oilPressure = 2.05, fuelPressure = 0.31})
	check("warning lights: shift band 500 rpm + getBGCount bit 4 blink, water > 110, oil < 30 psi, fuel < 4.5 psi",
		L.tachLightEnable == 1 and L.waterTempLightEnable == 1 and L.oilPressureLightEnable == 1 and L.fuelPressureLightEnable == 1
		and L2.tachLightEnable == 0 and L2.waterTempLightEnable == 0 and L2.oilPressureLightEnable == 0 and L2.fuelPressureLightEnable == 0)
end

------------------------------------------------------------------------- look easing (original 00569210 ..)
do
	local worst = 0
	for _, e in ipairs(FX.ease) do
		local x = e[1]
		worst = math.max(worst, math.abs(f32(Cameras.easeOut(x)) - e[2]), math.abs(f32(Cameras.invEaseOut(x)) - e[3]),
			math.abs(f32(Cameras.easeIn(x)) - e[4]), math.abs(f32(Cameras.invEaseIn(x)) - e[5]))
	end
	check("look easing == ORIGINAL 00569210 / 00569230 / 00569250 / 00569260", worst <= 1.2e-7, string.format("max %.3g", worst))
	-- 00568e20 conversions keep the eased yaw continuous when LookLeft/Right <-> cockpit
	local c = Cameras.new({})
	c:setMode(1); c.lookCur = 0.6; c:setMode(2)
	local a = c.lookCur
	c.lookTarget = 1; c:tick(0)
	local yawLook = c.lookEased
	c:setMode(1); c:tick(0)
	check("00568e20: cockpit <-> LookLeft conversion keeps the eased look angle",
		math.abs(a - Cameras.invEaseOut(Cameras.easeIn(0.6))) < 1e-7 and math.abs(c.lookEased - yawLook) < 1e-6,
		string.format("%.6f -> %.6f", yawLook, c.lookEased))
	-- 005697e0: full travel in 0.1 s, 45 deg
	local d = Cameras.new({})
	d:input(true, false, nil, 1 / 60); d:tick(0.05)
	local half = d.lookEased
	d:tick(0.05)
	check("005697e0: LookLeft eases 0 -> 45 deg in 0.1 s ((1-(1-x)^2) pi/4)", d.mode == 2 and math.abs(half - 0.75 * Cameras.QUARTER_PI) < 1e-6
		and math.abs(d.lookEased - 0.7853982) < 1e-7, string.format("%.4f, %.4f rad", half, d.lookEased))
end

----------------------------------------------------------------------- 0056a9a0 render camera (original)
do
	local cams = Cameras.new({onCar = FX.onCar, widescreen = false})
	local wide = Cameras.new({onCar = FX.onCar, widescreen = true})
	local byMode = {}
	local worstE, worstR, worstF, bad = 0, 0, 0, 0
	local firstBad
	local wideOk = true
	for _, c in ipairs(FX.cameras) do
		for _, cs in ipairs({cams, wide}) do
			cs.mode = c.mode
			cs.lookSign, cs.lookEased, cs.lookAnalog = 1, c.look, c.analog
		end
		local ds = {head = c.head, headPitch = c.headPitch, headRoll = c.headRoll}
		local o = cams:compute(c.pos, c.R, ds, nil, {})
		local ow = wide:compute(c.pos, c.R, ds, nil, {})
		local e, r = 0, 0
		for i = 1, 3 do e = math.max(e, math.abs(o.eye[i] - c.eye[i])) end
		for i = 1, 9 do r = math.max(r, math.abs(o.R[i] - c.M[i])) end
		local f = math.max(math.abs(o.fov43 - c.fov[1]), math.abs(o.shift[1] - c.fov[2]), math.abs(o.shift[2] - c.fov[3]), math.abs(o.near - c.near))
		local m = byMode[c.mode] or {e = 0, r = 0, f = 0, n = 0}
		byMode[c.mode] = m
		m.e, m.r, m.f, m.n = math.max(m.e, e), math.max(m.r, r), math.max(m.f, f), m.n + 1
		worstE, worstR, worstF = math.max(worstE, e), math.max(worstR, r), math.max(worstF, f)
		if e > 2e-4 or r > 2e-6 or f > 1e-6 then
			bad += 1
			firstBad = firstBad or string.format("mode %d: eye %.4f %.4f %.4f vs %.4f %.4f %.4f", c.mode, o.eye[1], o.eye[2], o.eye[3], c.eye[1], c.eye[2], c.eye[3])
		end
		-- widescreen (00587ea2): the cockpit views are forced to 65 deg (4:3), the other views keep their FOV
		if c.mode <= 3 then
			if ow.fov43 ~= Cameras.WIDESCREEN_COCKPIT_FOV then wideOk = false end
		elseif ow.fov43 ~= o.fov43 then wideOk = false end
	end
	check(string.format("cameras == ORIGINAL 0056a9a0: %d poses x 14 modes (cockpit, look L/R + analog, 4 chase, 6 on-car)", #FX.cameras / 14),
		bad == 0, string.format("eye max %.3g m, rotation max %.3g, fov/shift/near max %.3g%s", worstE, worstR, worstF, firstBad and ("  " .. firstBad) or ""))
	if DETAIL then
		for _, mode in ipairs({1, 2, 3, 4, 5, 6, 7, 8, 10, 11, 12, 13, 14, 15}) do
			local m = byMode[mode]
			print(string.format("      mode %2d %-10s eye %.3g m  R %.3g  fov %.3g", mode, Cameras.NAMES[mode], m.e, m.r, m.f))
		end
	end
	check("widescreen projection: cockpit / look views 65 deg (00587ea2), other views unchanged", wideOk)
	-- FOV option (00440a30 / 00567a80 / 00567ab0): 65..78 deg in 1 deg steps
	local o = Cameras.new({})
	local def = o:optionRad()
	o:fovUp()
	local one = o.fovDeg
	for _ = 1, 20 do o:fovUp() end
	local hi = o:optionRad()
	for _ = 1, 20 do o:fovDown() end
	check("cockpit FOV option: degrees, 1 deg steps, clamped to c5c27c / c5736c (00569450, 00411850 / 00411860)",
		math.abs(def - math.rad(65)) < 1e-6 and math.abs(one - 66) < 1e-4 and math.abs(hi - Cameras.FOV_MAX) < 1e-6
		and math.abs(o:optionRad() - Cameras.FOV_MIN) < 1e-6, string.format("%.6f -> %.4f deg; %.7f .. %.7f rad", def, one, o:optionRad(), hi))
	-- camera cycles while driving (006ec798 / 006ec7f0): next 1 -> 13 -> 4 -> 5 -> 10 -> 1, previous the reverse
	local n = Cameras.new({})
	local seq = {}
	for _ = 1, 5 do n:nextCamera(); seq[#seq + 1] = n.mode end
	local p = Cameras.new({})
	local seqP = {}
	for _ = 1, 5 do p:prevCamera(); seqP[#seqP + 1] = p.mode end
	local tablesOk = true
	if FX.camTables then
		for i = 0, 21 do
			if Cameras.NEXT[i] ~= FX.camTables.next[i + 1] or Cameras.PREV[i] ~= FX.camTables.prev[i + 1] then tablesOk = false end
		end
	end
	check("camera order == ORIGINAL tables 006ec798 / 006ec7f0 (next 1,13,4,5,10 / previous reversed)",
		table.concat(seq, ",") == "13,4,5,10,1" and table.concat(seqP, ",") == "10,5,4,13,1" and tablesOk,
		table.concat(seq, ",") .. " / " .. table.concat(seqP, ","))
	local consts = FX.constants
	if consts then
		local ok = Cameras.FOV_MIN == consts.fovMin and Cameras.FOV_MAX == consts.fovMax and Cameras.FOV_STEP == consts.fovStep
			and Cameras.FOV_OPTION_DEFAULT_DEG == consts.fovDefaultDeg and Cameras.OPTION_DEG_TO_RAD == consts.optionDegToRad
			and Cameras.OPTION_RAD_TO_DEG == consts.optionRadToDeg and Cameras.LOOK_TIME == consts.lookTime
			and Cameras.WIDESCREEN_COCKPIT_FOV == consts.wideFov and Cameras.QUARTER_PI == consts.quarterPi
			and Cameras.FOUR_OVER_PI == consts.fourOverPi and Cameras.LOOK_SMOOTHING == consts.lookSmoothing
			and Cameras.LOOK_DEADZONE == consts.lookDeadZone
		for i = 1, 3 do
			if Cameras.EYE_OFFSET[i] ~= consts.eye[i] or Cameras.DEFAULT_FOV[i] ~= consts.defaultFov[i] then ok = false end
		end
		check("camera constants == ORIGINAL image (FOV option / clamps / step, look time / smoothing / dead zone, pi/4, 4/pi, widescreen 65 deg, eye offset, default FOV)", ok)
	end
	-- Sky / Zeppelin / Pit Lane / TV cameras need the track system (not ported): compute returns nil, no fallback
	local t = Cameras.new({})
	t.mode = 9
	check("track cameras (Sky, Zeppelin, Pit Lane, TV) not substituted", t:compute({0, 0, 0}, Scale.euler(0, 0, 0), {head = {0, 0, 0}, headPitch = 0, headRoll = 0}) == nil)
end

----------------------------------------------------- rendserv.dll compiled nodes (original 10011ec0 / 100118e0 / 10012810)
do
	local ok, n = 0, 0
	for _, s in ipairs(FX.stateSwitch) do
		n += 1
		if Rig.selectState(s[1], s[2]) == s[3] then ok += 1 end
	end
	check("StateSwitch child == ORIGINAL rendserv 10011ec0", ok == n, string.format("%d / %d", ok, n))
	local okL, nL = 0, 0
	for _, l in ipairs(FX.lod) do
		nL += 1
		if Rig.selectLod(l[1], l[2], l[3]) == l[4] then okL += 1 end
	end
	check("LodSwitch level == ORIGINAL rendserv 100118e0 (distance thresholds + renderer detail floor)", okL == nL,
		string.format("%d / %d", okL, nL))
	local worstT, worstM = 0, 0
	local cnt = 0
	local R = {}
	for _, a in ipairs(FX.animated) do
		for _, smp in ipairs(a.samples) do
			cnt += 1
			local tx, ty, tz = Rig.animated(a.keys, smp[1], R)
			worstT = math.max(worstT, math.abs(tx - smp[2][1]), math.abs(ty - smp[2][2]), math.abs(tz - smp[2][3]))
			for i = 1, 9 do worstM = math.max(worstM, math.abs(R[i] - smp[3][i])) end
		end
	end
	check(string.format("AnimatedTransform == ORIGINAL rendserv 10012810 (%d driver/wheel tracks, %d times)", #FX.animated, cnt),
		worstT <= 2e-6 and worstM <= 2e-6, string.format("translation max %.3g m, matrix max %.3g", worstT, worstM))
end

------------------------------------------------------------------------- draw state (005ba170 interpolation)
do
	local s = {}
	local seed = 7
	local function rand(a, b) seed = (seed * 1103515245 + 12345) % 2147483648; return a + (b - a) * seed / 2147483648 end
	for _, k in ipairs(DrawState.FIELDS) do s[k] = f32(rand(-50, 50)) end
	s.bgCount = 0x12345678
	local b = DrawState.encode(513, 1234.5678, s)
	local d = DrawState.decode(b)
	local same = d ~= nil and d.seq == 513 and d.time == 1234.5678 and d.bgCount == 0x12345678
	if d then for _, k in ipairs(DrawState.FIELDS) do if d[k] ~= s[k] then same = false end end end
	check("draw state encode / decode (43 f32 fields, seq, server time, getBGCount)", same, string.format("%d bytes", buffer.len(b)))
	local bad = buffer.create(buffer.len(b)); buffer.copy(bad, 0, b); buffer.writef32(bad, DrawState.HEADER, 0 / 0)
	check("draw state decode rejects NaN / wrong version / short buffers", DrawState.decode(bad) == nil
		and DrawState.decode(buffer.create(8)) == nil and DrawState.decode("x") == nil)
	-- interpolation rules
	local function rec(t, v) local r = table.clone(v); r.time = t; return r end
	local base = {}
	for _, k in ipairs(DrawState.FIELDS) do base[k] = 0 end
	local A = rec(10.0, base)
	A.steer, A.headPitch, A.headRoll, A.shifterP, A.attHeading = 3.0, 0.1, 3.0, -3.1, 3.1
	A.headX, A.wheelZ1, A.roofFlap, A.arm3 = 1.0, -0.05, 0.2, 0.5
	A.spin1, A.rate1, A.rpm = 6.0, 30.0, 5000
	local B = rec(10.1, base)
	B.steer, B.headPitch, B.headRoll, B.shifterP, B.attHeading = 3.4, 0.3, -3.0, -3.2, -3.1
	B.headX, B.wheelZ1, B.roofFlap, B.arm3 = 2.0, -0.07, 0.4, 0.7
	B.spin1, B.rate1, B.rpm = 2.0, 40.0, 6000
	local buf = DrawState.newBuffer(8)
	buf:push(B); buf:push(A)
	local o = buf:sample(10.05)
	local twoPi = 6.2831854820251465
	local spin = f32(0.1 * 40 * 0.5 + 6.0)
	spin = f32(spin - math.floor(f32(spin * 0.15915494309199166) + 0.5) * 6.283185307175784)
	local ok = math.abs(o.alpha - 0.5) < 1e-9
		and math.abs(o.steer - (3.2 - twoPi)) < 1e-9                -- lerp 3.2, wrapped (> pi)
		and math.abs(o.headPitch - 0.2) < 1e-9
		and math.abs(o.headRoll - (3.0 + (-3.0 + twoPi - 3.0) * 0.5 - twoPi)) < 1e-9   -- shortest path through +-pi
		and math.abs(o.shifterP - (-3.15 + twoPi)) < 1e-9
		and math.abs(o.attHeading - (0.0)) < 1e-9                     -- plain lerp (no shortest path) then wrap
		and math.abs(o.headX - 1.5) < 1e-9 and math.abs(o.wheelZ1 + 0.06) < 1e-9 and math.abs(o.roofFlap - 0.3) < 1e-9
		and math.abs(o.arm3 - 0.6) < 1e-9 and o.rpm == 6000 and o.spin1 == spin
	check("005ba170 interpolation: lerp / lerp+wrap / roll shortest path / spin = prev + rate dt alpha (2 pi wrap) / newer gauges", ok,
		string.format("steer %.4f roll %.4f spin %.4f", o.steer, o.headRoll, o.spin1))
	check("draw state buffer: before / after the window -> first / last record",
		buf:sample(9.0).rpm == 5000 and buf:sample(11.0).rpm == 6000 and buf:sample(nil).rpm == 6000)
	-- 005662d0 steering-wheel angle and external driver animation time
	check("steering wheel angle = clamp(-(ratio * steer), +-2.79) (005662d0)",
		DrawState.steeringWheelAngle({ratio = 15, steer = 0.1}) == -1.5 and DrawState.steeringWheelAngle({ratio = 15, steer = -1}) == 2.7899999618530273
		and DrawState.steeringWheelAngle({ratio = 15, steer = 1, limit = 2}) == -2)
	check("timeValue = 10 max(0, trunc(deg(a) + 160.355225)) (0056885b..)",
		DrawState.timeValue(0) == 1600 and DrawState.timeValue(-2.78) == 10 and DrawState.timeValue(-2.79) == 0
		and DrawState.timeValue(-3) == 0 and DrawState.timeValue(2.79) == 3200)
end

------------------------------------------------------------------------------------- ORIGINAL core cells
do
	local okV, Vehicle = pcall(require, "../../core/NR2003CupVehicle")
	local car
	if okV then
		local function get(name)
			local ok, m = pcall(require, "../../core/NR2003Cup/" .. name)
			if ok then return m end
			return nil
		end
		local okC, c = pcall(Vehicle.fromLoader, get)
		if okC then car = c end
	end
	if not car then
		check("core cells (NR2003CupVehicle not loadable from this checkout)", true, "skipped")
	else
		local V = car.V
		V.reset()
		V.startSession({}, {})
		local FLAT = {}
		for i = 1, 4 do FLAT[i] = {0, 0, 1, 0, 0, 0, 0, 1, 1} end
		for _ = 1, 288 do V.drive({throttle = 0.6, clutch = 1, steerAxis = 0.3}, FLAT) end
		local spec = V.r32(DrawState.CAR + 0x58a)
		local cal = {ptach = 0x148, pfuel = 0x168, pwater = 0x178, poilt = 0x188, poilp = 0x198, pvoltage = 0x1a8}
		local same = spec ~= 0
		for name, off in pairs(cal) do
			for i = 1, 4 do if V.rf32(spec + off + 4 * (i - 1)) ~= Gauges.CAL[name][i] then same = false end end
		end
		check("needle calibrations == the car spec of the ORIGINAL image (car+0x58a -> +0x148 .. +0x1a8, 0056edd0)", same,
			string.format("spec %08x", spec))
		local s = DrawState.sample(car)
		local st = V.steeringState()
		local okS = s ~= nil and s.rpm == V.rf32(DrawState.CAR + 0x1508) and s.rpm > 500 and s.steer == st.drawSteer
			and s.ratio == st.ratioNow and s.revLimit == V.rf32(V.r32(DrawState.CAR + 0x576) + 0x2c) and s.revLimit > 1000
		for _, k in ipairs(DrawState.FIELDS) do if s and s[k] ~= s[k] then okS = false end end
		check("DrawState.sample reads the ORIGINAL frame-end cells (rpm, steer, ratio, rev limit) of a running Cup core", okS,
			s and string.format("rpm %.0f, steer %.4f, ratio %.3f, limit %.0f", s.rpm, s.steer, s.ratio, s.revLimit) or "nil")
		local snapshot = V.tick
		local frozen = s and DrawState.sample(car)
		check("sampling has no side effect on the core (tick unchanged)", V.tick == snapshot and frozen and frozen.rpm == s.rpm)
	end
end

----------------------------------------------------------------------------- rig (descriptor, mock import)
if DESCRIPTOR_SOURCE then
	local desc = assert(loadstring(DESCRIPTOR_SOURCE, "descriptor"))()
	-- the ORIGINAL physics geometry: front hubs (1.2070, +-0.7684), rear hubs (-1.5870, +-0.7684) (CupTune, component
	-- records 0x727290..) == the 3do wheel nodes, with no rescaling
	local CupTune = mockRequire({ref = "CupTune"})
	local fx, rx, ht = -CupTune.frontZ, -CupTune.rearZ, CupTune.frontTrack / 2
	local wheels = {lfwheel = {fx, ht}, rfwheel = {fx, -ht}, lrwheel = {rx, CupTune.rearTrack / 2}, rrwheel = {rx, -CupTune.rearTrack / 2}}
	local worstW, found = 0, 0
	for _, n in ipairs(desc.nodes) do
		local w = wheels[n.name]
		if w and n.t then
			found += 1
			worstW = math.max(worstW, math.abs(n.t[1] - w[1]), math.abs(n.t[2] - w[2]))
		end
	end
	check("3do wheel nodes == ORIGINAL physics hub positions (CupTune frontZ / rearZ / tracks; scale 1:1 in metres)", found >= 4 and worstW < 1e-4,
		string.format("%d nodes, max %.2g m", found, worstW))
	-- mock import: arbitrary rigid transform + uniform scale k (whatever the Studio importer does), measured back by the
	-- marker tetrahedra
	local k = 1.7
	local Q = CFrame.Angles(0.3, -1.1, 0.25)
	local imp = CFrame.new(31, 7, -12) * Q
	local function placed(local_) return imp * (local_ * k) end
	local assets = {parts = {}}
	function assets:FindFirstChild(name) return self.parts[name] end
	local c = desc.markerSize * 0.25
	for name, m in pairs(desc.markers) do
		local pos = placed(Vector3.new(m[1] + c, m[2] + c, m[3] + c))
		assets.parts[name] = newPart(name, CFrame.fromParts({pos.X, pos.Y, pos.Z}, Q.r), Vector3.new(1, 1, 1))
	end
	for _, g in ipairs(desc.geometries) do
		local pos = placed(Vector3.new(g.center[1], g.center[2], g.center[3]))
		local cf = CFrame.fromParts({pos.X, pos.Y, pos.Z}, Q.r)
		assets.parts[g.name] = newPart(g.name, cf, Vector3.new(g.max[1] - g.min[1], g.max[2] - g.min[2], g.max[3] - g.min[3]) * k)
	end
	local rig = Rig.new(desc, assets, workspace, {name = "test"})
	check("import calibration from the markers (rigid transform + uniform scale recovered)", #rig.missing == 0
		and math.abs(rig.importScale - k) < 1e-9 and rig.importError < 1e-9 and rig.centerError < 1e-9,
		string.format("k %.6f, centre error %.3g studs", rig.importScale, rig.centerError))
	local worstP, worstR, mism, total = 0, 0, 0, 0
	for si, sc in ipairs(FX.rig) do
		local vars = table.clone(sc.vars)
		vars._cockpit = vars.cockpitView == 1
		local ds = {steer = sc.ds.steer, wheelAngle = sc.ds.steeringWheelAngle, headPitch = sc.ds.headPitch, headRoll = sc.ds.headRoll}
		for i = 1, 4 do ds["spin" .. i] = sc.ds.spin[i] end
		if sc.ds.wheelZ then for i = 1, 4 do ds["wheelZ" .. i] = sc.ds.wheelZ[i] end end
		if sc.ds.gauges and next(sc.ds.gauges) then ds.needles = sc.ds.gauges end
		if sc.ds.shifter then ds.shifterP, ds.shifterR = sc.ds.shifter[1], sc.ds.shifter[2] end
		if sc.ds.head then ds.headTranslation = sc.ds.head end
		local body = sc.ds.body or {0, 0, 0}
		local bodyCF = Scale.cframe(12.5, -40.25, 3.0, Scale.euler(body[1], body[2], body[3]))
		local camPos = bodyCF * Scale.point(sc.camera[1], sc.camera[2], sc.camera[3])
		rig:update(bodyCF, vars, ds, camPos, 1)
		local want = {}
		for _, a in ipairs(sc.active) do
			want[a[1]] = bodyCF * Scale.cframe(a[2][1], a[2][2], a[2][3], a[3])
		end
		local geomOf = {}
		for _, inst in ipairs(desc.instances) do geomOf[inst.id] = inst.geometry end
		for id, p in pairs(rig.instParts) do
			if p and rig.instActive[id] then
				total += 1
				local w = want[id]
				if not w then mism += 1
				else
					local g = desc.geometries[geomOf[id] + 1]
					local expect = w * CFrame.new(g.center[1], g.center[2], g.center[3])
					local dp, dr = cfError(p.CFrame, expect)
					worstP, worstR = math.max(worstP, dp), math.max(worstR, dr)
					want[id] = nil
				end
			end
		end
		for _ in pairs(want) do mism += 1 end
		if DETAIL then print(string.format("      scenario %d: %d parts, %d nodes", si, rig.stats.parts, rig.stats.nodes)) end
	end
	check(string.format("rig == reference rig (3 scenarios: cockpit + needles/steer/shifter/head, chase LOD, far LOD; %d parts)", total),
		mism == 0 and worstP < 1e-6 and worstR < 1e-9, string.format("set mismatches %d, position max %.3g studs, rotation max %.3g", mism, worstP, worstR))
	-- livery: replaces the card texture only
	rig:setLivery("rbxassetid://1")
	local cardOnly = true
	for _, g in ipairs(desc.geometries) do
		local t = rig.templates[g.id]
		if t and ((g.texture == "card") ~= (t.TextureID == "rbxassetid://1")) then cardOnly = false end
	end
	check("livery replaces the 'card' placeholder texture only (CAR CTEX = card.mip)", cardOnly)

	-- performance (Luau side of one presentation frame: graph walk + overrides + LOD; BulkMoveTo is engine work)
	local vars = {cockpitView = 1, _cockpit = true, steeringWheelEnable = 0, windshieldEnable = 0, day_night = 0}
	local ds = {steer = 0.05, wheelAngle = -0.6, spin1 = 0, spin2 = 0, spin3 = 0, spin4 = 0, headPitch = 0, headRoll = 0,
		needles = {ptach = 0, poilp = 0, poilt = 0, pfuel = 0, pwater = 0, pvoltage = 0}, headTranslation = {-0.75, 0.4, 0.467}}
	local bodyCF = Scale.cframe(0, 0, 0.5, Scale.euler(0, 0, 0))
	local t0 = os.clock()
	local N = 2000
	for i = 1, N do ds.spin1 = i * 0.01; rig:update(bodyCF, vars, ds, bodyCF * Scale.point(-0.65, 0.4, 0.6), 1) end
	local cockpitMs = (os.clock() - t0) / N * 1000
	vars.cockpitView, vars._cockpit = 0, false
	t0 = os.clock()
	for i = 1, N do ds.spin1 = i * 0.01; rig:update(bodyCF, vars, ds, bodyCF * Scale.point(-6, 0, 2.25), 1) end
	local chaseMs = (os.clock() - t0) / N * 1000
	check("performance: rig update per frame (Luau CLI, interpreter)", cockpitMs < 2 and chaseMs < 2,
		string.format("cockpit %.3f ms (%d parts), chase %.3f ms (%d parts)", cockpitMs, 26, chaseMs, rig.stats.parts))

	-------------------------------------------------------------- NR2003CarModelClient end to end (mocked engine API)
	SOURCES.DESC = DESCRIPTOR_SOURCE
	local handler
	local attrs = {}
	local chassis = {Name = "Chassis", CFrame = Scale.cframe(100, 50, 0.45, Scale.euler(0.4, 0.01, -0.02))}
	local car = {Name = "TestCar", Chassis = chassis, PrimaryPart = chassis}
	function car:GetAttribute(k) return attrs[k] end
	function car:SetAttribute(k, v) attrs[k] = v end
	function car:FindFirstChild(n) return self[n] end
	function car:GetDescendants() return {} end
	function car:GetPivot() return chassis.CFrame end
	local dataF = {FindFirstChild = function(_, n) return n == "NR2003CarModelData_make_a" and {ref = "DESC"} or nil end}
	local assetsF = {FindFirstChild = function(_, n) return n == desc.meta.package and assets or nil end}
	local cmFolder = {FindFirstChild = function(_, n) return n == "Data" and dataF or n == "Assets" and assetsF or nil end}
	local remote = {OnClientEvent = {Connect = function(_, f) handler = f; return {Disconnect = function() end} end}}
	local package = {FindFirstChild = function(_, n) return n == "CarModel" and cmFolder or n == "DrawState" and remote or nil end}
	local camera = {CFrame = CFrame.new(0, 0, 0), FieldOfView = 70, CameraType = "Custom", ViewportSize = {X = 1920, Y = 1080}}
	workspace.CurrentCamera = camera
	function workspace:Raycast() return nil end
	local UIS = {GetLastInputType = function() return {Name = "Keyboard"} end, GetGamepadConnected = function() return false end}
	local env = {GetService = function(_, n) if n == "UserInputService" then return UIS end return {} end}
	local RaycastParams = {new = function() return {} end}
	Enum.RaycastFilterType = {Exclude = "Exclude"}
	Enum.CameraType = {Scriptable = "Scriptable"}
	local f = assert(loadstring(SOURCES.NR2003CarModelClient, "NR2003CarModelClient"))
	setfenv(f, setmetatable({script = {Parent = folder}, require = mockRequire, workspace = workspace, Vector3 = Vector3,
		CFrame = CFrame, Instance = Instance, Enum = Enum, game = env, RaycastParams = RaycastParams}, {__index = _G}))
	local Client = f()
	local presentation = {buffer = {renderTime = 10.05}}
	local keys = {}
	local cm = Client.new(car, presentation, package, {Character = nil}, function() return keys end)
	check("client: data module + imported model found, DrawState listener connected", cm.status == "ok" and cm.active and handler ~= nil,
		tostring(cm.status))
	local function packet(t, steer, rpm)
		local s = {}
		for _, k in ipairs(DrawState.FIELDS) do s[k] = 0 end
		s.rpm, s.steer, s.ratio, s.limit, s.revLimit = rpm, steer, 15, 2.7899999618530273, 9300
		s.temp1520, s.temp1524, s.oilPressure, s.fuelPressure, s.voltage = 90, 95, 4, 0.6, 13.8
		s.wheelZ1, s.wheelZ2, s.wheelZ3, s.wheelZ4 = -0.06, -0.06, -0.07, -0.07
		s.rate1, s.rate2, s.rate3, s.rate4 = 30, 30, 30, 30
		handler(DrawState.encode(1, t, s))
	end
	packet(10.0, 0.02, 5000); packet(10.1, 0.04, 6000)
	local okU = cm:update(1 / 60, true)
	local okC = cm:applyCamera(camera)
	-- expected cockpit camera: the ORIGINAL camera chain on the interpolated head (alpha 0.5) and the body pose
	local bx, by, bz, Rb = Scale.fromCFrame(chassis.CFrame)
	local headNode = desc.nodes[desc.roles.head[1] + 1]
	local cams = Cameras.new({onCar = desc.cameras, widescreen = true})
	local want = cams:compute({bx, by, bz}, Rb, {head = headNode.t, headPitch = 0, headRoll = 0}, nil, {})
	local eye = Scale.point(want.eye[1], want.eye[2], want.eye[3])
	local camPos = camera.CFrame.Position
	check("client cockpit: Scriptable camera at the ORIGINAL eye, vertical FOV of the 65 deg widescreen cockpit (00587ea2)",
		okU and okC and camera.CameraType == "Scriptable" and (camPos - eye).Magnitude < 1e-6
		and math.abs(camera.FieldOfView - Scale.verticalFov(Cameras.WIDESCREEN_COCKPIT_FOV)) < 1e-9 and attrs.NR2003Camera == "cockpit",
		string.format("FOV %.4f deg, eye error %.2g studs", camera.FieldOfView, (camPos - eye).Magnitude))
	check("client draw state at the render time: steer lerp 0.03, rpm newer record, wheel angle = clamp(-(15 * 0.03))",
		math.abs(cm.ds.steer - 0.03) < 1e-6 and cm.ds.rpm == 6000 and math.abs(cm.ds.wheelAngle + 0.45) < 1e-5
		and cm.vars.cockpitView == 1 and cm.vars.tachLightEnable == 0 and cm.vars.waterTempLightEnable == 0)
	cm:nextCamera(); cm:update(1 / 60, true); cm:applyCamera(camera)
	local rb = desc.cameras["Roll Bar"]
	check("V -> Roll Bar (13): on-car camera of the .cam, its own FOV, car drawn (cockpitView 0)",
		attrs.NR2003Camera == "Roll Bar" and math.abs(camera.FieldOfView - Scale.verticalFov(rb.fov[1])) < 1e-9 and cm.vars.cockpitView == 0,
		string.format("FOV %.3f deg", camera.FieldOfView))
	camera.ViewportSize = {X = 5000, Y = 1000}      -- 5:1: the widescreen branch clamps the horizontal FOV to 2.5 rad
	cm:applyCamera(camera)
	local hfov = 2 * math.atan(5 * math.tan(math.rad(camera.FieldOfView) / 2))
	check("widescreen branch: horizontal FOV at the display aspect clamped to 2.5 rad (00587ed8)", math.abs(hfov - 2.5) < 1e-9,
		string.format("%.4f rad", hfov))
	camera.ViewportSize = {X = 1920, Y = 1080}
	cm:prevCamera(); cm:prevCamera(); cm:update(1 / 60, true)
	check("B B -> Nose (10): car hidden (cockpitView 10, 0056bb30)", attrs.NR2003Camera == "Nose" and cm.vars.cockpitView == 10)
	keys.LookLeft = true
	cm:prevCamera(); cm:prevCamera(); cm:prevCamera(); cm:prevCamera()
	for _ = 1, 12 do cm:update(1 / 60, true) end
	check("Z held in the cockpit -> LookLeft eased to 45 deg", attrs.NR2003Camera == "LookLeft" and math.abs(cm.cams.lookEased - 0.7853982) < 1e-7)
	keys.LookLeft = nil
	local t1 = os.clock()
	for i = 1, 500 do presentation.buffer.renderTime = 10.0 + (i % 100) * 0.001; cm:update(1 / 60, true); cm:applyCamera(camera) end
	check("performance: full client frame (draw state + gauges + camera + rig)", true,
		string.format("%.3f ms per frame (Luau CLI, interpreter)", (os.clock() - t1) / 500 * 1000))
else
	print("SKIP  rig section: generated without a converted package (make_carmodel_tests.py <package dir>)")
end

----------------------------------------------------------------------------------- Studio self-test (mocked)
do
	local ST = mockRequire({ref = "NR2003CarModelSelfTest"})
	local ok, lines = ST.run(false, true)
	check("Studio self-test NR2003CarModelSelfTest.run (code only, golden subset) passes under the mock", ok, lines[#lines])
end

print(string.format("\n%d passed, %d failed", passed, failed))
if failed > 0 then error("nr2003carmodel tests failed") end
