-- ===== minimal Roblox API mock (only what CupChassisAdapter and its helpers use) =====
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
	if k == "UpVector" then return Vector3.new(c.r[2], c.r[5], c.r[8]) end
	if k == "RightVector" then return Vector3.new(c.r[1], c.r[4], c.r[7]) end
	if k == "LookVector" then return Vector3.new(-c.r[3], -c.r[6], -c.r[9]) end
	return CFrame[k]
end
function CFrame.fromParts(p, r) return setmetatable({p = {p[1], p[2], p[3]}, r = table.clone(r)}, CFrame) end
function CFrame.new(x, y, z, ...)
	if type(x) == "table" then return CFrame.fromParts({x.X, x.Y, x.Z}, {1, 0, 0, 0, 1, 0, 0, 0, 1}) end
	local r = {...}
	if #r == 0 then r = {1, 0, 0, 0, 1, 0, 0, 0, 1} end
	return CFrame.fromParts({x or 0, y or 0, z or 0}, r)
end
local function mulR(a, b)
	local c = {}
	for i = 0, 2 do for j = 0, 2 do
		c[i * 3 + j + 1] = a[i * 3 + 1] * b[j + 1] + a[i * 3 + 2] * b[3 + j + 1] + a[i * 3 + 3] * b[6 + j + 1]
	end end
	return c
end
local function rv(r, v) return Vector3.new(r[1] * v.X + r[2] * v.Y + r[3] * v.Z, r[4] * v.X + r[5] * v.Y + r[6] * v.Z, r[7] * v.X + r[8] * v.Y + r[9] * v.Z) end
local function rtv(r, v) return Vector3.new(r[1] * v.X + r[4] * v.Y + r[7] * v.Z, r[2] * v.X + r[5] * v.Y + r[8] * v.Z, r[3] * v.X + r[6] * v.Y + r[9] * v.Z) end
CFrame.__mul = function(a, b)
	if getmetatable(b) == Vector3 then local w = rv(a.r, b); return Vector3.new(w.X + a.p[1], w.Y + a.p[2], w.Z + a.p[3]) end
	local w = rv(a.r, Vector3.new(b.p[1], b.p[2], b.p[3]))
	return CFrame.fromParts({w.X + a.p[1], w.Y + a.p[2], w.Z + a.p[3]}, mulR(a.r, b.r))
end
CFrame.__add = function(a, v) return CFrame.fromParts({a.p[1] + v.X, a.p[2] + v.Y, a.p[3] + v.Z}, a.r) end
CFrame.__sub = function(a, v) return CFrame.fromParts({a.p[1] - v.X, a.p[2] - v.Y, a.p[3] - v.Z}, a.r) end
function CFrame.PointToWorldSpace(c, v) return c * v end
function CFrame.PointToObjectSpace(c, v) return rtv(c.r, Vector3.new(v.X - c.p[1], v.Y - c.p[2], v.Z - c.p[3])) end
function CFrame.VectorToWorldSpace(c, v) return rv(c.r, v) end
function CFrame.VectorToObjectSpace(c, v) return rtv(c.r, v) end
function CFrame.GetComponents(c) return c.p[1], c.p[2], c.p[3], table.unpack(c.r) end
function CFrame.Angles(rx, ry, rz)
	local cx, sx, cy, sy, cz, sz = math.cos(rx), math.sin(rx), math.cos(ry), math.sin(ry), math.cos(rz), math.sin(rz)
	local X = {1, 0, 0, 0, cx, -sx, 0, sx, cx}
	local Y = {cy, 0, sy, 0, 1, 0, -sy, 0, cy}
	local Z = {cz, -sz, 0, sz, cz, 0, 0, 0, 1}
	return CFrame.fromParts({0, 0, 0}, mulR(mulR(X, Y), Z))
end

-- world: ground plane y = 0 (asphalt), wall plane z = WALL_Z facing +Z (car drives toward -Z)
local WALL_Z = -120
local ground = {Name = "Asphalt", Material = {Name = "Asphalt"}, attrs = {NRSurface = 1, NRGripMultiplier = 1}}
function ground:IsA(c) return c == "BasePart" end
function ground:GetVelocityAtPosition() return Vector3.zero end
function ground:GetAttribute(k) return self.attrs[k] end
local workspace = {}
local SLOPE = 0 -- ground y = SLOPE * z (rises toward +Z, i.e. behind a car facing -Z)
function workspace:Raycast(o, d)
	-- plane y - SLOPE*z = 0
	local den = d.Y - SLOPE * d.Z
	if den >= 0 then return nil end
	local t = -(o.Y - SLOPE * o.Z) / den
	if t < 0 or t > 1 then return nil end
	local p = o + d * t
	local n = Vector3.new(0, 1, -SLOPE).Unit
	return {Position = p, Normal = n, Distance = d.Magnitude * t, Instance = ground, Material = ground.Material}
end
function workspace:Blockcast(cf, size, dir)
	local half = size.Z * 0.5
	local front = cf.p[3] - half
	if dir.Z < 0 and front + dir.Z < WALL_Z then
		local dist = math.max(0, (front - WALL_Z) / (-dir.Z / dir.Magnitude))
		return {Distance = dist, Normal = Vector3.new(0, 0, 1), Position = Vector3.new(cf.p[1], cf.p[2], WALL_Z), Instance = ground}
	end
	return nil
end
local RaycastParams = {new = function() return {} end}
local Enum = {RaycastFilterType = {Exclude = "Exclude"}}

-- car instance mock (sizes from the Stage 5 bench model, studs)
local MPS = 0.28
local attributes = {}
local chassis = {Name = "Chassis", Anchored = false, CanCollide = true, Size = Vector3.new(1.78 / MPS, 0.38 / MPS, 4.45 / MPS),
	CFrame = CFrame.new(0, 2.65, 0), AssemblyLinearVelocity = Vector3.zero, AssemblyAngularVelocity = Vector3.zero}
local car = {Chassis = chassis, DriverSeat = {Occupant = nil}}
function car:GetPivot() return chassis.CFrame end
function car:PivotTo(cf) chassis.CFrame = cf end
function car:SetAttribute(k, v) attributes[k] = v end
function car:GetAttribute(k) return attributes[k] end

-- module system: folders hand out refs; require(ref) loads bundled sources with a mock env
local loaded = {}
local realModules = {}
local mockRequire
local function folder(prefix)
	local f = {}
	setmetatable(f, {__index = function(_, name)
		if name == "WaitForChild" or name == "FindFirstChild" then
			return function(_, child)
				if prefix == "Core" and child == "NR2003Cup" then return folder("NR2003Cup") end
				return {ref = prefix .. "." .. child}
			end
		end
		return {ref = prefix .. "." .. name}
	end})
	return f
end
local CoreFolder, RobloxFolder = folder("Core"), folder("Roblox")
local package = {Core = CoreFolder, Roblox = RobloxFolder}
local stubs = {
	["Roblox.VisualRig"] = {new = function() return {update = function(_, dyn, contacts) _G_lastVisual = {dyn = dyn, contacts = contacts} end} end},
	["Roblox.SeatAccess"] = {new = function() return {step = function() end, driver = function() return "player" end, request = function() end,
		exit = function() end, destroy = function() end} end},
	["Roblox.Cockpit"] = {ensure = function() end, update = function(_, _, a) _G_lastSteer = a end, angle = function(a) return a * 12 end},
}
function mockRequire(ref)
	local name = ref.ref
	if name:sub(1, 10) == "NR2003Cup." then
		local m = name:sub(11)
		if realModules[m] == nil then
			local ok, v = pcall(require, "../../core/NR2003Cup/" .. m)
			realModules[m] = ok and v or false
		end
		return realModules[m] or nil
	end
	if stubs[name] then return stubs[name] end
	if loaded[name] then return loaded[name] end
	local source = assert(SOURCES[name], "mock: no source for " .. name)
	local f = assert(loadstring(source, name))
	local prefix = name:match("^(%a+)%.")
	local scriptObj = {Parent = prefix == "Core" and CoreFolder or RobloxFolder}
	scriptObj.Parent.Parent = package
	setfenv(f, setmetatable({script = scriptObj, require = mockRequire, workspace = workspace, Vector3 = Vector3, CFrame = CFrame,
		RaycastParams = RaycastParams, Enum = Enum, warn = print}, {__index = _G}))
	loaded[name] = f()
	return loaded[name]
end
-- folders refs whose FindFirstChild returns refs: NR2003Cup children must be nil when absent
local cupFolderMeta = folder("NR2003Cup")
local origFind = rawget(cupFolderMeta, "FindFirstChild")

-- ===== scenario =====
local passed, failed = 0, 0
local function check(name, ok, detail)
	if ok then passed += 1 else failed += 1 end
	print((ok and "PASS  " or "FAIL  ") .. name .. (detail and ("  " .. detail) or ""))
end
-- NR2003CupVehicle.new(folder) probes NR2003CupImage1.. until nil: make missing modules nil
do
	local orig = mockRequire
	mockRequire = function(ref)
		if ref.ref:sub(1, 10) == "NR2003Cup." then
			local m = ref.ref:sub(11)
			if realModules[m] == nil then
				local ok, v = pcall(require, "../../core/NR2003Cup/" .. m)
				realModules[m] = ok and v or false
			end
			return realModules[m] or nil
		end
		return orig(ref)
	end
end
local Adapter = mockRequire({ref = "Roblox.CupChassisAdapter"})
-- NR2003CupVehicle.new uses folder:FindFirstChild(name) and require(m): wrap so absent -> nil
local Vehicle = mockRequire({ref = "Core.NR2003CupVehicle"})
local realNew = Vehicle.new
Vehicle.new = function(f)
	return Vehicle.fromLoader(function(name) return mockRequire({ref = "NR2003Cup." .. name}) end)
end
local TestTune = mockRequire({ref = "Core.TestTune"}).new()
local ctl = Adapter.new(car, TestTune, {})
check("adapter constructed, root anchored and non-colliding", chassis.Anchored == true and chassis.CanCollide == false)
check("numeric origin on the ground under the spawn", math.abs(ctl.origin.p[2]) < 1e-6, string.format("origin y %.4f", ctl.origin.p[2]))
local y0 = ctl.rootCF.p[2]
check("initial root height = core chassis z (0.42 m) in studs", math.abs(y0 - 0.42 / MPS) < 1e-3, string.format("%.4f studs", y0))

local dt = 1 / 60
local input = {throttle = 0, brake = 0, steer = 0, handbrake = 0, clutch = 0}
-- settle 1 s with clutch engaged (pedal released) in neutral
for f = 1, 60 do ctl:step(dt, input) end
local yRest = chassis.CFrame.p[2]
check("car settles on the raycast ground (chassis ref 0.41..0.43 m)", yRest * MPS > 0.41 and yRest * MPS < 0.43, string.format("%.4f m", yRest * MPS))
local planes = ctl.planes
check("contact planes from raycasts: n = (0,0,1), d = 0 on flat ground", math.abs(planes[1][3] - 1) < 1e-6 and math.abs(planes[1][4]) < 1e-4 and math.abs(planes[4][4]) < 1e-4,
	string.format("n=(%.3g %.3g %.3g) d=%.3g", planes[1][1], planes[1][2], planes[1][3], planes[1][4]))
local tel = ctl:telemetry()
check("telemetry: neutral at rest, loads positive", tel.gear == 0 and tel.wheels[1].load > 1000 and tel.wheels[4].load > 1000,
	string.format("gear %s loads %.0f %.0f %.0f %.0f", tostring(tel.gear), tel.wheels[1].load, tel.wheels[2].load, tel.wheels[3].load, tel.wheels[4].load))
-- shift to 1st and accelerate
ctl:shift(1)
for f = 1, 20 do ctl:step(dt, input) end
input.throttle = 1
local z0 = chassis.CFrame.p[3]
for f = 1, 120 do ctl:step(dt, input); if f == 60 then ctl:shift(1) end end
tel = ctl:telemetry()
local z1 = chassis.CFrame.p[3]
check("accelerates forward = Roblox -Z", z1 < z0 - 5, string.format("dz %.2f studs, %.1f km/h, gear %s, %.0f rpm", z1 - z0, tel.speed, tostring(tel.gear), tel.rpm))
check("upshifts reached 2nd gear", tel.gear == 2, "gear " .. tostring(tel.gear))
check("wheel visual data: compression ~ -0.06 m, spin advancing", math.abs(ctl.wheelPose[1].compression + 0.063) < 0.03,
	string.format("comp %.4f angle %.3f rate %.2f", ctl.wheelPose[1].compression, ctl.wheelPose[1].angle, ctl.wheelPose[1].rate))
local snap = ctl:renderSnapshot(1, 0, 1)
local RenderSnapshot = mockRequire({ref = "Roblox.RenderSnapshot"})
local ok, decoded = pcall(function() return RenderSnapshot.decode(RenderSnapshot.encode(snap)) end)
check("render snapshot encodes/decodes", ok and decoded and math.abs(decoded.pz - snap.pz) < 1e-3, ok and "" or tostring(decoded))
-- steering right: yaw to the right (Roblox: LookVector rotates toward +X)
input.steer = 1
for f = 1, 60 do ctl:step(dt, input) end
local look = chassis.CFrame.LookVector
check("steer right turns toward +X", look.X > 0.05, string.format("look (%.3f %.3f %.3f) steer cell lf %.4f", look.X, look.Y, look.Z, ctl:telemetry().lfSteer))
input.steer = 0
-- collision boundary: drive into the wall at z = WALL_Z
for f = 1, 900 do
	ctl:step(dt, input)
	if chassis.CFrame.p[3] - chassis.Size.Z / 2 < WALL_Z - 0.5 then break end
end
local front = chassis.CFrame.p[3] - chassis.Size.Z / 2
check("collision boundary keeps the chassis box out of the wall", front >= WALL_Z - 0.5, string.format("front %.2f wall %.2f collided %s", front, WALL_Z, tostring(ctl.collision)))
check("no physics fault", ctl.fault == nil, tostring(ctl.fault))
-- reset
ctl:reset()
check("reset returns to spawn pose", math.abs(chassis.CFrame.p[3]) < 1e-6 and math.abs(chassis.CFrame.p[2] - 0.42 / MPS) < 1e-3)
-- slope: on a 5 % grade (downhill toward -Z) the car in neutral must roll DOWNHILL; a sign error in
-- the normal/plane mapping would make it climb or fault
SLOPE = 0.05
chassis.CFrame = CFrame.new(0, 2.65, 0)
ctl.spawn = chassis.CFrame
ctl:reset()
input.throttle = 0; input.brake = 0; input.steer = 0; input.clutch = 0
local zs = chassis.CFrame.p[3]
for f = 1, 180 do ctl:step(dt, input) end
local ze = chassis.CFrame.p[3]
local np = ctl.planes[1]
check("5 % slope: plane normal tilted, car rolls downhill (-Z)", ze < zs - 1 and math.abs(np[1]) > 0.04 and ctl.fault == nil,
	string.format("dz %.2f studs, plane n=(%.4f %.4f %.4f)", ze - zs, np[1], np[2], np[3]))
SLOPE = 0
-- ===== Stage 8: the ORIGINAL brake input chain through the adapter (keyboard = key binding) =====
chassis.CFrame = CFrame.new(0, 2.65, 0)
ctl.spawn = chassis.CFrame
ctl:reset()
input = {throttle = 0, brake = 0, steer = 0, handbrake = 0, clutch = 0}
for f = 1, 30 do ctl:step(dt, input) end
tel = ctl:telemetry()
check("stage 8: at rest without throttle the original auto-hold applies the brake (00553080)", (tel.brakePedal or 0) > 0.1 and math.abs(tel.speed) < 1,
	string.format("pedal %.3f core %.4f speed %.2f km/h", tel.brakePedal or -1, tel.brakeCore or -1, tel.speed))
ctl:shift(1)
for f = 1, 20 do ctl:step(dt, input) end
input.throttle = 1
for f = 1, 300 do ctl:step(dt, input); if f == 70 or f == 150 or f == 240 then ctl:shift(1) end end
tel = ctl:telemetry()
local vBrake = tel.speed
check("stage 8: driving: pedal released (0) once moving with throttle", tel.brakePedal == 0 and vBrake > 60, string.format("pedal %.3f %.1f km/h", tel.brakePedal, vBrake))
input.throttle = 0; input.brake = 1
local pedals, saturated, lockSeen = {}, false, false
for f = 1, 30 do
	ctl:step(dt, input)
	local t = ctl:telemetry()
	pedals[#pedals + 1] = t.brakePedal
	local tq = math.abs(t.wheels[1].brakeTorque)
	if tq > 2700 and tq < 2815 then saturated = true end
	if t.wheels[1].locked or t.wheels[2].locked then lockSeen = true end
end
local monotone, stepOk = true, true
for i = 2, #pedals do
	if pedals[i] < pedals[i - 1] then monotone = false end
	if pedals[i] - pedals[i - 1] > 2 / 12 + 1e-6 then stepOk = false end
end
check("stage 8: key brake ramps up (<= 1/12 per 36 Hz frame) to 1.0 (digital binding)", monotone and stepOk and pedals[#pedals] == 1,
	string.format("pedal after 1 host step %.4f, after 0.5 s %.4f", pedals[1], pedals[#pedals]))
check("stage 8: hard key braking at 74 %: front brake torque saturates (~2800 N*m, Kb 2812) without locking (as the original)", saturated and not lockSeen)
for f = 1, 600 do ctl:step(dt, input); if ctl:telemetry().speed < 0.2 then break end end
tel = ctl:telemetry()
check("stage 8: car brakes to a stop through wheel torque + tyres", tel.speed < 0.5, string.format("%.2f km/h (from %.1f)", tel.speed, vBrake))
input.brake = 0
local zStop = chassis.CFrame.p[3]
for f = 1, 120 do ctl:step(dt, input) end
tel = ctl:telemetry()
check("stage 8: brake key released at standstill: original auto-hold keeps the car still", math.abs(chassis.CFrame.p[3] - zStop) < 0.2 and tel.brakePedal > 0,
	string.format("dz %.3f studs, pedal %.3f", chassis.CFrame.p[3] - zStop, tel.brakePedal))
local realDriver = ctl.access.driver
ctl.access.driver = function() return nil end
for f = 1, 10 do ctl:step(dt, input) end
tel = ctl:telemetry()
check("stage 8: nobody seated -> 005524f0 'not driven': pedal held at exactly 1.0", tel.brakePedal == 1, string.format("pedal %.4f", tel.brakePedal))
ctl.access.driver = realDriver
car:SetAttribute("SetupBrakeBias", 60)
ctl:reset()
local kbF, kbR = ctl.core:wheelBrake(0).kb, ctl.core:wheelBrake(2).kb
check("stage 8: SetupBrakeBias=60 applied at reset (garage item 0x28 -> 0055e9b0 cells)", car:GetAttribute("BrakeBiasApplied") == 60
	and kbF == 2279.999755859375 and kbR == 1520.0001220703125, string.format("Kb %.7g / %.7g", kbF, kbR))
car:SetAttribute("SetupBrakeBias", nil)
ctl:reset()
check("stage 8: default bias 74 % restored on reset without the attribute", car:GetAttribute("BrakeBiasApplied") == 74 and ctl.core:wheelBrake(0).kb == 2812)
check("stage 8: no physics fault", ctl.fault == nil, tostring(ctl.fault))
-- ===== Stage 9: session air, aero setup, aero telemetry, test-only phantom draft =====
WALL_Z = -1e9 -- long straight for the high-speed checks
chassis.CFrame = CFrame.new(0, 2.65, 0)
ctl.spawn = chassis.CFrame
for _, k in ipairs({"SetupBrakeBias", "AeroSession", "SetupGrilleTape", "SetupSpoiler", "WeatherTemperatureF", "DraftTestGap"}) do car:SetAttribute(k, nil) end
ctl:reset()
check("stage 9: reset starts the session with the original defaults (rho 1.08119202, tape 0 %, spoiler 65 deg)",
	math.abs((car:GetAttribute("AirDensityApplied") or 0) - 1.08119202) < 1e-6 and car:GetAttribute("GrilleTapeApplied") == 0 and car:GetAttribute("SpoilerApplied") == 65,
	string.format("rho %.9g tape %s spoiler %s", car:GetAttribute("AirDensityApplied") or -1, tostring(car:GetAttribute("GrilleTapeApplied")), tostring(car:GetAttribute("SpoilerApplied"))))
input = {throttle = 0, brake = 0, steer = 0, handbrake = 0, clutch = 0}
for f = 1, 30 do ctl:step(dt, input) end
ctl:shift(1)
for f = 1, 20 do ctl:step(dt, input) end
input.throttle = 1
for f = 1, 1200 do ctl:step(dt, input); if f == 70 or f == 150 or f == 240 then ctl:shift(1) end end
tel = ctl:telemetry()
local a9 = tel.aero
check("stage 9: aero telemetry at speed = ORIGINAL 00561b70 output (session, q, drag, downforce, factors 1.0)",
	a9 and a9.session and a9.q > 1500 and a9.drag > 1000 and a9.downforce > 800 and a9.factorDrag == 1 and a9.factorFront == 1 and a9.factorRear == 1,
	a9 and string.format("%.1f km/h q %.0f Pa drag %.0f N down %.0f N (F %.0f R %.0f) rh %.4f", tel.speed, a9.q, a9.drag, a9.downforce, a9.front, a9.rear, a9.rideHeight) or "no aero")
check("stage 9: track normal for 00561a80 from the grounded contact planes (flat ground: (0,0,1))",
	ctl.trackNormal ~= nil and math.abs(ctl.trackNormal[3] - 1) < 1e-6, ctl.trackNormal and string.format("(%.3g %.3g %.3g)", ctl.trackNormal[1], ctl.trackNormal[2], ctl.trackNormal[3]) or "nil")
car:SetAttribute("DraftTestGap", 8)
for f = 1, 120 do ctl:step(dt, input) end
local d9 = ctl:telemetry().aero
check("stage 9: DraftTestGap=8 (TEST ADAPTER phantom car) drives the ORIGINAL 005afd80: drag/front factors < 1",
	d9.draftTest and d9.factorDrag < 0.95 and d9.factorFront < 0.95 and d9.factorRear == 1, string.format("factors %.3f/%.3f/%.3f", d9.factorDrag, d9.factorFront, d9.factorRear))
car:SetAttribute("DraftTestGap", nil)
for f = 1, 30 do ctl:step(dt, input) end
d9 = ctl:telemetry().aero
check("stage 9: phantom removed -> no race ring, factors back to 1.0", not d9.draftTest and d9.factorDrag == 1 and d9.factorFront == 1)
check("stage 9: no physics fault at speed", ctl.fault == nil, tostring(ctl.fault))
car:SetAttribute("AeroSession", false)
ctl:reset()
for f = 1, 10 do ctl:step(dt, input) end
check("stage 9: AeroSession=false -> post-build state (rho 0, no aero force)", car:GetAttribute("AirDensityApplied") == 0
	and ctl:telemetry().aero.session == false and ctl:telemetry().aero.drag == 0)
car:SetAttribute("AeroSession", nil)
car:SetAttribute("SetupGrilleTape", 100); car:SetAttribute("SetupSpoiler", 45); car:SetAttribute("WeatherTemperatureF", 40)
ctl:reset()
local tape9, sp9 = ctl.core:aeroSetup()
check("stage 9: SetupGrilleTape / SetupSpoiler / WeatherTemperatureF applied at reset (garage items 0x3b/0x3d, 005a3c00 at 40 F)",
	car:GetAttribute("GrilleTapeApplied") == 100 and car:GetAttribute("SpoilerApplied") == 45 and tape9 == 100 and sp9 == 45
	and math.abs(car:GetAttribute("AirDensityApplied") - 1.14886904) < 1e-6, string.format("tape %d spoiler %d rho %.9g", tape9, sp9, car:GetAttribute("AirDensityApplied")))
car:SetAttribute("SetupGrilleTape", nil); car:SetAttribute("SetupSpoiler", nil); car:SetAttribute("WeatherTemperatureF", nil)
ctl:reset()
check("stage 9: attributes removed -> Cup defaults again", car:GetAttribute("GrilleTapeApplied") == 0 and car:GetAttribute("SpoilerApplied") == 65
	and math.abs(car:GetAttribute("AirDensityApplied") - 1.08119202) < 1e-6)
-- ===== Stage 10: garage setup attributes through the ORIGINAL car build =====
if ctl.core.V.applySetup then
	car:SetAttribute("Setup_springLF", 1700); car:SetAttribute("Setup_camberLF", -2.96); car:SetAttribute("Setup_trackBarRR", 11)
	ctl:reset()
	local S10 = ctl.core:setupModule()
	local applied = ctl.core:setup()
	local want = S10.cupGarageDefault()
	S10.set(want, "springLF", 1700); S10.set(want, "camberLF", -2.96); S10.set(want, "trackBarRR", 11)
	local d10 = ctl.core:setupDump()
	check("stage 10: Setup_<item> attributes -> 005581d0 (snap/clamp) -> ORIGINAL build at reset",
		car:GetAttribute("SetupError") == nil and applied[20] == want[20] and applied[32] == want[32] and applied[46] == want[46]
		and d10.runtime.springRate[1] == S10.bitsToF(applied[20]),
		string.format("%s %.2f s, spring LF %g lb/in -> %.0f N/m, camber LF %.2f deg", tostring(car:GetAttribute("SetupStructure")),
			car:GetAttribute("SetupApplySeconds") or -1, S10.display(applied, "springLF"), d10.runtime.springRate[1], S10.display(applied, "camberLF")))
	local rep0 = ctl.core:setupReport()
	ctl:reset()
	check("stage 10: reset with an unchanged setup does not rebuild (reset image keeps the setup)", ctl.core:setupReport() == rep0
		and ctl.core:setup()[20] == applied[20])
	input = {throttle = 0, brake = 0, steer = 0, handbrake = 0, clutch = 0}
	for f = 1, 60 do ctl:step(dt, input) end
	check("stage 10: car runs on the rebuilt setup (no fault, loads positive)", ctl.fault == nil and ctl:telemetry().wheels ~= nil, tostring(ctl.fault))
	car:SetAttribute("Setup_springLF", nil); car:SetAttribute("Setup_camberLF", nil); car:SetAttribute("Setup_trackBarRR", nil)
	ctl:reset()
	check("stage 10: attributes removed -> shipped default image (structure 'image')", car:GetAttribute("SetupStructure") == "image"
		and ctl.core.V.setupStructure() == "image")
end
-- ===== Stage 11: ORIGINAL per-frame runtime (fuel, thermal, wear, damage) through the adapter =====
if ctl.core.V.stage11State then
	local S11KEYS = {"RaceDamageLevel", "RaceConsumptionRate", "RosterSeries", "RandomSeed", "Stage11Runtime", "DamageTestImpact", "PitTyresTest"}
	for _, k in ipairs(S11KEYS) do car:SetAttribute(k, nil) end
	ctl:reset()
	local t0 = ctl:telemetry()
	local s0 = t0.stage11
	-- new tyres (00550f10): session temperature of 005a3c00 (weather +0x108: 49.1 C at 70 F) + 11 C
	local tyreNew = ctl.core.V.weather().densityTemperatureC + 11
	check("stage 11: reset starts the original runtime (fuel 62.4698 kg, water 93 C, oil 0 C, new tyres at session temperature + 11 C)",
		s0 ~= nil and s0.mode == "original" and math.abs(s0.fuelKg - 62.4698) < 1e-3 and math.abs(s0.water - 93) < 1e-3 and s0.oil == 0
		and math.abs(t0.wheels[1].temperature - tyreNew) < 0.05 and t0.wheels[3].tyreWear == 0,
		s0 and string.format("%s fuel %.4f kg water %.2f oil %.2f tyre LF %.2f C (new %.2f)", s0.mode, s0.fuelKg, s0.water, s0.oil, t0.wheels[1].temperature, tyreNew) or "no stage11")
	input = {throttle = 0, brake = 0, steer = 0, handbrake = 0, clutch = 0}
	for f = 1, 30 do ctl:step(dt, input) end
	ctl:shift(1)
	input.throttle = 1
	for f = 1, 600 do ctl:step(dt, input); if f == 70 or f == 150 then ctl:shift(1) end end
	local t1 = ctl:telemetry()
	local s1 = t1.stage11
	check("stage 11: driving burns fuel (mass record follows), heats the oil, evolves water / tyre temperatures, wears the tyres (ORIGINAL 0051aac0 / 005605c0 / 0054d610 / 0054e9f0)",
		s1.fuelKg < s0.fuelKg and s1.water ~= s0.water and s1.oil > s0.oil and t1.wheels[3].temperature ~= t0.wheels[3].temperature
		and t1.wheels[3].tyreWear > 0 and math.abs(s1.fuelRecordKg - s1.fuelKg) < 1e-3,
		string.format("fuel %.4f kg (record %.4f) water %.2f oil %.2f LR %.1f C wear %.5f", s1.fuelKg, s1.fuelRecordKg, s1.water, s1.oil, t1.wheels[3].temperature, t1.wheels[3].tyreWear))
	local zones0 = table.clone(s1.zones)
	car:SetAttribute("DamageTestImpact", 150000)
	for f = 1, 10 do ctl:step(dt, input) end
	local s2 = ctl:telemetry().stage11
	local hit = false
	for k = 1, #zones0 do if s2.zones[k] ~= zones0[k] then hit = true end end
	check("stage 11: DamageTestImpact (TEST ADAPTER) -> ORIGINAL 0054a760 record -> 00549c40 damages a body zone", car:GetAttribute("DamageTestImpact") == nil and hit
		and s2.damageScale == 1, string.format("scale %.2f zones %s", s2.damageScale, table.concat(s2.zones, " ", 1, math.min(#s2.zones, 6))))
	car:SetAttribute("PitTyresTest", true)
	for f = 1, 2 do ctl:step(dt, input) end
	local t3 = ctl:telemetry()
	check("stage 11: PitTyresTest (TEST ADAPTER) -> ORIGINAL 00550f10 x4: new tyres (wear 0, session temperature + 11 C)", car:GetAttribute("PitTyresTest") == nil
		and t3.wheels[3].tyreWear < t1.wheels[3].tyreWear and math.abs(t3.wheels[3].temperature - tyreNew) < 1,
		string.format("LR wear %.6f temperature %.2f C", t3.wheels[3].tyreWear, t3.wheels[3].temperature))
	check("stage 11: no physics fault", ctl.fault == nil, tostring(ctl.fault))
	car:SetAttribute("RaceDamageLevel", 0); car:SetAttribute("RaceConsumptionRate", 3)
	ctl:reset()
	local s4 = ctl:telemetry().stage11
	check("stage 11: RaceDamageLevel=0 -> 00547e90 damage scale 0; RaceConsumptionRate applied at reset", s4.damageScale == 0 and s4.mode == "original",
		string.format("scale %.2f", s4.damageScale))
	car:SetAttribute("RaceDamageLevel", nil); car:SetAttribute("RaceConsumptionRate", nil)
	car:SetAttribute("Stage11Runtime", "frozen")
	ctl:reset()
	local f0 = ctl:telemetry().stage11
	for f = 1, 120 do ctl:step(dt, input) end
	local f1 = ctl:telemetry().stage11
	check("stage 11: Stage11Runtime=\"frozen\" (A/B) keeps the Stage 6-10 frame end: fuel / water held", f0.mode == "frozen" and f1.fuelKg == f0.fuelKg
		and f1.water == f0.water, string.format("%s fuel %.4f -> %.4f", f0.mode, f0.fuelKg, f1.fuelKg))
	for _, k in ipairs(S11KEYS) do car:SetAttribute(k, nil) end
	ctl:reset()
	check("stage 11: attributes removed -> original runtime again", ctl:telemetry().stage11.mode == "original")
end
-- the Studio self-test modules themselves (quick mode), as the patches run them after installing
local ST = mockRequire({ref = "Roblox.Stage67SelfTest"})
local stOk = ST.run(false)
check("Roblox/Stage67SelfTest.run(false) passes (what PATCH_STAGE6_7 executes)", stOk)
local ST8 = mockRequire({ref = "Roblox.Stage8SelfTest"})
local st8Ok = ST8.run(false)
check("Roblox/Stage8SelfTest.run(false) passes (what PATCH_STAGE8 executes)", st8Ok)
local st8Full = ST8.run(true)
check("Roblox/Stage8SelfTest.run(true) passes (full: 4 braking phases)", st8Full)
local ST9 = mockRequire({ref = "Roblox.Stage9SelfTest"})
local st9Ok = ST9.run(false)
check("Roblox/Stage9SelfTest.run(false) passes (what PATCH_STAGE9 executes)", st9Ok)
local st9Full = ST9.run(true)
check("Roblox/Stage9SelfTest.run(true) passes (full: launch, high-speed braking, drafting)", st9Full)
if SOURCES["Roblox.Stage10SelfTest"] then
	local ST10 = mockRequire({ref = "Roblox.Stage10SelfTest"})
	local st10Ok = ST10.run(false)
	check("Roblox/Stage10SelfTest.run(false) passes (what PATCH_STAGE10 executes)", st10Ok)
	local st10Full = ST10.run(true)
	check("Roblox/Stage10SelfTest.run(true) passes (full: more builds, 8 s drive with a setup)", st10Full)
end
if SOURCES["Roblox.Stage11SelfTest"] then
	local ST11 = mockRequire({ref = "Roblox.Stage11SelfTest"})
	check("Roblox/Stage11SelfTest.run(false) passes (what PATCH_STAGE11 executes)", (ST11.run(false)))
	check("Roblox/Stage11SelfTest.run(true) passes (full: 10 s drives, determinism, frozen A/B)", (ST11.run(true)))
end
print(string.format("\nadapter mock: %d passed, %d failed", passed, failed))
if failed > 0 then error("adapter mock tests failed") end
