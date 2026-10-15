-- Independent test shortcuts: K selects the next original preset; Comma toggles the telemetry HUD.
local function bind(services, keyCodes)
    local input = services:GetService("UserInputService")
    local player = services:GetService("Players").LocalPlayer
    local gui = player:WaitForChild("PlayerGui")
    local package = services:GetService("ReplicatedStorage"):WaitForChild("NR2003Lab")
    local remote = package:WaitForChild("Input")
    local existing = gui:FindFirstChild("NR2003LabHUD")
    local visible = existing == nil or existing.Enabled
    local held, connections = {}, {}
    local function show(child)
        if child.Name == "NR2003LabHUD" and child:IsA("ScreenGui") then child.Enabled = visible end
    end
    connections[#connections + 1] = gui.ChildAdded:Connect(show)
    connections[#connections + 1] = input.InputBegan:Connect(function(event, processed)
        if processed or input:GetFocusedTextBox() then return end
        local key = event.KeyCode
        if (key ~= keyCodes.K and key ~= keyCodes.Comma) or held[key] then return end
        held[key] = true
        if key == keyCodes.K then
            remote:FireServer({kind="cycleSetup"})
        else
            visible = not visible
            for _, child in ipairs(gui:GetChildren()) do show(child) end
        end
    end)
    connections[#connections + 1] = input.InputEnded:Connect(function(event) held[event.KeyCode] = nil end)
    connections[#connections + 1] = input.WindowFocusReleased:Connect(function() table.clear(held) end)
    return function()
        for _, connection in ipairs(connections) do connection:Disconnect() end
    end
end

if game then bind(game, Enum.KeyCode) end
return bind
