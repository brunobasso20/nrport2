assert(not game:GetService("RunService"):IsRunning(),"Stop Play before rolling back")
local function norm(s) return (s:gsub("\r\n", "\n")) end
local function fnv(s)
    local h=2166136261
    for i=1,#s do
        h=bit32.bxor(h,string.byte(s,i))
        h=bit32.band(bit32.band(h,65535)*16777619+bit32.band(h,4294901760)*403,4294967295)
    end
    return h
end
local backup=assert(game:GetService("ServerStorage"):FindFirstChild("NR2003Backup_Patch1201"),"Patch backup missing")
local entries=backup:GetChildren()
for _,item in ipairs(entries) do
    local target=assert(item.Target.Value,"Backup target missing")
    local source=norm(target.Source)
    assert(#source==item:GetAttribute("NewBytes") and fnv(source)==item:GetAttribute("NewHash"),"A patched script was edited; rollback refused")
end
for _,item in ipairs(entries) do
    if item:GetAttribute("Added") then item.Target.Value:Destroy() else item.Target.Value.Source=item.OriginalSource.Value end
end
backup:Destroy()
print("Previous Watkins Glen presets and test controls restored")
