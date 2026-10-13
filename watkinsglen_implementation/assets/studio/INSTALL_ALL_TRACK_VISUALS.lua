-- Import all assets/glb/*.glb into Workspace with their file names.
-- Insert assets/studio/NR2003TrackVisualInstallers.rbxmx into Workspace, then run this
-- in Studio's Command Bar outside Play. All chunk installers are idempotent.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing")
local installers = assert(workspace:FindFirstChild("NR2003TrackVisualInstallersV2"), "Insert the updated NR2003TrackVisualInstallers.rbxmx (Model name NR2003TrackVisualInstallersV2)")
local modules = installers:GetChildren()
table.sort(modules, function(a,b) return a.Name < b.Name end)
local installed = 0
for _, module in ipairs(modules) do
    if module:IsA("ModuleScript") then require(module)(); installed += 1 end
end
print("Watkins Glen visuals installed: " .. installed .. " chunks. Track origin = CFrame.identity. Place not saved.")
