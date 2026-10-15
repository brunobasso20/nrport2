-- Assist states come from original core cells published by CupChassisAdapter.present().
-- This shares the existing ScreenGui, so the Comma HUD shortcut controls it too.
local Players=game:GetService("Players")
local Run=game:GetService("RunService")
local player=Players.LocalPlayer
local gui=player:WaitForChild("PlayerGui"):WaitForChild("NR2003LabHUD")
local panel=gui:WaitForChild("Telemetry")
local box=Instance.new("TextLabel")
box.Name="DrivingAssists";box.Size=UDim2.fromOffset(600,56)
box.BackgroundColor3=Color3.fromRGB(17,24,34);box.BackgroundTransparency=0.08
box.BorderSizePixel=0;box.TextColor3=Color3.fromRGB(160,220,255)
box.Font=Enum.Font.Code;box.TextSize=12;box.TextXAlignment=Enum.TextXAlignment.Left
box.TextYAlignment=Enum.TextYAlignment.Center;box.Parent=gui
local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,8);corner.Parent=box
local timer=0
local connection=Run.RenderStepped:Connect(function(dt)
    box.Visible=panel.Visible
    box.Position=UDim2.new(panel.Position.X.Scale,panel.Position.X.Offset,
        panel.Position.Y.Scale,panel.Position.Y.Offset+panel.AbsoluteSize.Y+6)
    timer+=dt;if timer<0.1 then return end;timer=0
    local humanoid=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    local seat=humanoid and humanoid.SeatPart
    local car=seat and seat.Parent
    if not car then box.Text="";return end
    local function state(name)
        local value=car:GetAttribute("DrivingAssist_"..name)
        return type(value)=="boolean" and tostring(value) or "unknown"
    end
    local unavailable=car:GetAttribute("DrivingAssist_steeringAvailable")==false and " (original racing lines unavailable)" or ""
    box.Text=string.format("  Automatic=%s  Auto clutch=%s  ABS=%s\n  Traction control=%s  Stability=%s  Low-speed steering=%s\n  Steering help=%s%s",
        state("automatic"),state("autoClutch"),state("abs"),state("tractionControl"),state("stabilityControl"),
        state("lowSpeedSteering"),state("steering"),unavailable)
end)
script.Destroying:Connect(function() connection:Disconnect();box:Destroy() end)
