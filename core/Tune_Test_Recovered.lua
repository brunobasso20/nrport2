-- Recovered embedded baseline for STRUCTURAL TESTS ONLY.
-- Not an A-Chassis tune. No vehicle dynamics solver or drivable car is included.
local Data = require(script and script.Parent.RecoveredData or "RecoveredData")
local Tree = require(script and script.Parent.ComponentTree or "ComponentTree")
local Track = require(script and script.Parent.TrackProfile or "TrackProfile")
local Rotation = require(script and script.Parent.RotationMatrix or "RotationMatrix")
local Tune = {}

function Tune.new()
    local nodes = {}
    for i = 1, #Data.components do
        local source = Data.components[i]
        local node = {}
        for key, value in pairs(source) do
            if type(value) == "table" then
                local copy = {}
                for k, v in pairs(value) do copy[k] = v end
                node[key] = copy
            else
                node[key] = value
            end
        end
        nodes[i] = node
        local fields = node.rawFieldsF32
        node.initialBasis = Rotation.fromAngles(fields["0x51"] * Data.angleScale,
            fields["0x55"] * Data.angleScale, fields["0x59"] * Data.angleScale)
    end
    local roots = Tree.build(nodes)
    local chassis = assert(Tree.find(nodes, "chassis"))
    local states = Tree.countStates(chassis)
    assert(#roots == 1 and states == 45, "Recovered layout differs from NR2003 initialization")
    return {
        name = "NR2003 Embedded Structural Baseline",
        sourceCommit = Data.sourceCommit,
        runnableVehicle = false,
        status = "PARTIAL_RECOVERY_NO_DYNAMICS_SOLVER",
        components = nodes, roots = roots, stateCount = states,
        track = Track.resolve(),
    }
end

return Tune
