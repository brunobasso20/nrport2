-- Exercise the production preset helper and the production client input handler with small Roblox mocks.
local Controls = require("../../roblox/SetupTestControls")
local bind = require("../../roblox/SetupTestBindings.client")
local passed = 0
local function check(label, condition)
    assert(condition, label)
    passed += 1; print("PASS  " .. label)
end
local function car(attributes)
    return {
        GetAttributes=function() return table.clone(attributes) end,
        GetAttribute=function(_, name) return attributes[name] end,
        SetAttribute=function(_, name, value) attributes[name] = value end,
    }, attributes
end
local selected, attributes = car({NR2003Track="watkins_glen", TrackSetupApplied="fast", WatkinsGlenSetup="qualify",
    Setup_tirePressureLF=35, Setup_camberRF=-1, SetupBrakeBias=70, SetupGrilleTape=10, SetupSpoiler=55, KeepMe=123})
local resets = 0
for _, expected in ipairs({"easy", "qualify", "jasper", "fast"}) do
    local nextName = Controls.cycle(selected, function(name)
        resets += 1
        check("preset overrides are cleared before reset " .. name,
            attributes.Setup_tirePressureLF == nil and attributes.Setup_camberRF == nil and attributes.SetupBrakeBias == nil
            and attributes.SetupGrilleTape == nil and attributes.SetupSpoiler == nil)
        attributes.TrackSetupApplied = name
        return true
    end)
    check("cycle selects " .. expected, nextName == expected and attributes.WatkinsGlenSetup == expected)
end
check("four cycles invoke four resets and preserve unrelated attributes", resets == 4 and attributes.KeepMe == 123)
check("next wraps and defaults unknown names", Controls.next("jasper") == "fast" and Controls.next(nil) == "easy")
local configured, settings = car({NR2003Track="watkins_glen", WatkinsGlenSetup="qualify"})
check("configured selection is used without an applied selection", Controls.cycle(configured, function() end) == "jasper")
local defaultCar = car({NR2003Track="watkins_glen"})
check("missing selection starts from fast", Controls.cycle(defaultCar, function() end) == "easy")
for _, explicitFailure in ipairs({false, true}) do
    local failedCar, old = car({NR2003Track="watkins_glen", WatkinsGlenSetup="fast", TrackSetupApplied="fast",
        TrackSetupSHA256="old-hash", Setup_tirePressureLF=31, SetupSpoiler=60, KeepMe=44})
    local ok = pcall(Controls.cycle, failedCar, function()
        old.TrackSetupApplied="easy"; old.TrackSetupSHA256="wrong-hash"; old.Setup_newOverride=9
        if explicitFailure then return false, "reset rejected" end
        error("reset failed")
    end)
    check("failed reset restores selection, overrides and applied source " .. tostring(explicitFailure),
        not ok and old.WatkinsGlenSetup == "fast" and old.TrackSetupApplied == "fast" and old.TrackSetupSHA256 == "old-hash"
        and old.Setup_tirePressureLF == 31 and old.SetupSpoiler == 60 and old.Setup_newOverride == nil and old.KeepMe == 44)
end
local wrongTrack = car({NR2003Track="other"})
check("other tracks cannot cycle", not pcall(Controls.cycle, wrongTrack, function() error("must not run") end))
local function signal()
    local callbacks = {}
    return {
        Connect=function(_, callback)
            callbacks[callback] = true
            return {Disconnect=function() callbacks[callback] = nil end}
        end,
        Fire=function(_, ...) for callback in pairs(callbacks) do callback(...) end end,
    }
end
local focused, sent = false, {}
local input = {InputBegan=signal(), InputEnded=signal(), WindowFocusReleased=signal(),
    GetFocusedTextBox=function() return focused and {} or nil end}
local children = {}
local gui = {ChildAdded=signal(), GetChildren=function() return children end,
    FindFirstChild=function(_, name) for _, child in ipairs(children) do if child.Name == name then return child end end end}
local remote = {FireServer=function(_, message) sent[#sent + 1] = message end}
local package = {WaitForChild=function(_, name) assert(name == "Input"); return remote end}
local services = {GetService=function(_, name)
    if name == "UserInputService" then return input end
    if name == "Players" then return {LocalPlayer={WaitForChild=function(_, child) assert(child == "PlayerGui"); return gui end}} end
    assert(name == "ReplicatedStorage")
    return {WaitForChild=function(_, child) assert(child == "NR2003Lab"); return package end}
end}
local disconnect = bind(services, {K="K", Comma=","})
local function began(key, processed) input.InputBegan:Fire({KeyCode=key}, processed == true) end
local function released(key) input.InputEnded:Fire({KeyCode=key}) end
began("K", true); focused=true; began("K"); began(","); focused=false
check("processed keys and focused text boxes ignore both shortcuts", #sent == 0)
began("K"); began("K")
check("K sends one cycle request per key press", #sent == 1 and sent[1].kind == "cycleSetup")
released("K"); began("K")
check("K works again after key release", #sent == 2)
began(",")
local hud = {Name="NR2003LabHUD", Enabled=true, IsA=function(_, class) return class == "ScreenGui" end}
children[#children + 1] = hud; gui.ChildAdded:Fire(hud)
check("HUD created after a hide shortcut stays hidden", hud.Enabled == false)
began(",")
check("held Comma cannot toggle repeatedly", hud.Enabled == false)
released(","); began(",")
check("Comma restores the telemetry HUD without sending network input", hud.Enabled and #sent == 2)
released(","); began(".")
check("period no longer changes HUD visibility", hud.Enabled)
input.WindowFocusReleased:Fire(); began("K")
check("focus loss releases held shortcuts", #sent == 3)
disconnect(); released("K"); began("K")
check("client bindings disconnect cleanly", #sent == 3)
print(string.format("Setup test controls: %d checks passed", passed))
