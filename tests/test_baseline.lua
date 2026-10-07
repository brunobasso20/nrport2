package.path = "core/?.lua;" .. package.path
local Tree = require("ComponentTree")
local Data = require("RecoveredData")
local Track = require("TrackProfile")
local F32 = require("Float32")
local Tune = require("Tune_Test_Recovered")
local Rotation = require("RotationMatrix")

local a, b = Tune.new(), Tune.new()
assert(a.stateCount == 45 and #a.components == 16 and #a.roots == 1)
assert(not a.runnableVehicle and a.components[1] ~= b.components[1])
assert(Tree.find(a.components, "CHASSIS") == nil)
assert(Tree.find(a.components, "lfwheel").parent.name == "lfhub")
assert(Tree.find(a.components, "lfhub").parent.name == "lfsusp")
assert(Tree.find(a.components, "rrwheel").parent.name == "raxle")
assert(Tree.find(a.components, "engine").parent.name == "chassis")
assert(#Tree.build(a.components) == 1 and Tree.countStates(a.roots[1]) == 45)
local bad = {{name="a",parentName="b",flags=0},{name="b",parentName="a",flags=0}}
assert(not pcall(Tree.build, bad))

local default = Track.resolve()
assert(default.track_tire_wear == 1 and default.track_tire_heat == 1)
assert(default.track_tire_wear_loss == F32.round(0.2))
assert(#default.surfaces == 20)
for i = 1, #Data.surfaces do
    assert(default.surfaces[i].effectiveScalar == Data.surfaces[i].base)
end
local changed = Track.resolve(
    {track_asphalt_grip=1.3, track_tire_heat=2},
    {track_asphalt_grip=1.1, track_tire_heat=-123456792})
assert(changed.surfaces[2].multiplier == F32.round(1.1))
assert(changed.surfaces[2].effectiveScalar == F32.round(Data.surfaces[2].base*F32.round(1.1)))
assert(changed.track_tire_heat == 2)
assert(Track.resolve({}, {track_asphalt_grip=0}).surfaces[2].effectiveScalar == 0)
assert(not pcall(Track.resolve, {track_asphalt_grip="invalid"}))
local identity = Rotation.fromAngles(0,0,0)
for i=1,9 do assert(identity[i] == ((i==1 or i==5 or i==9) and 1 or 0)) end
for n=1,300 do
    local matrix = Rotation.fromAngles(n*0.13, n*0.17, -n*0.11)
    for row=0,2 do
        for other=0,2 do
            local dot = 0
            for col=1,3 do dot=dot+matrix[3*row+col]*matrix[3*other+col] end
            assert(math.abs(dot-(row==other and 1 or 0)) < 1e-6, "Non-orthogonal rotation")
        end
    end
end
print("PASS: 16 recovered components; 45 states; hierarchy/cycle checks; 20 material factors; override precedence; float32 assignments; 300 orthogonal rotations.")
