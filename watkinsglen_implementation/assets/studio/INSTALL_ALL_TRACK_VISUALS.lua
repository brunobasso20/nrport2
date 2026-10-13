-- Import all assets/glb/*.glb into Workspace with their file names.
-- Insert assets/studio/NR2003TrackVisualInstallers.rbxmx into Workspace, then run this
-- in Studio's Command Bar outside Play. All chunk installers are idempotent.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing")
local installers = assert(workspace:FindFirstChild("NR2003TrackVisualInstallersV3"), "Insert the updated NR2003TrackVisualInstallers.rbxmx (Model name NR2003TrackVisualInstallersV3)")
local modules = installers:GetChildren()
table.sort(modules, function(a,b) return a.Name < b.Name end)
local installed = 0
local pending = {}
for _, module in ipairs(modules) do
    if module:IsA("ModuleScript") then
        local ok, reason = pcall(function() require(module)() end)
        if ok then installed += 1 else table.insert(pending, {name=module.Name, reason=tostring(reason)}) end
    end
end
local root = workspace:FindFirstChild("NR2003WatkinsGlen")
if root then
    root:SetAttribute("NR2003VisualChunksReady", installed)
    root:SetAttribute("NR2003VisualsComplete", installed == 88 and #pending == 0)
end
if #pending > 0 then
    warn("Watkins Glen: " .. installed .. " chunks ready; " .. #pending .. " pending. Complete chunks were preserved; fix only the imports listed below, then rerun this V3 master.")
    for _, failure in ipairs(pending) do warn(failure.name .. ": " .. failure.reason) end
else
    print("Watkins Glen visuals installed: " .. installed .. " chunks. Track origin = CFrame.identity. Place not saved.")
end
