-- Edit mode: select ONLY collision pieces (or collision subfolders) to classify.
-- Change SURFACE to "asphalt" or "concrete". Original tire equations are unchanged.
local SURFACE="concrete"
assert(SURFACE=="asphalt" or SURFACE=="concrete","Choose asphalt or concrete")
local package=game:GetService("ReplicatedStorage"):WaitForChild("NR2003Lab")
local col=assert(package.Track1Config.CollisionRoot.Value,"track1 col missing")
local seen={};local count=0
local function apply(part)
    if seen[part] or not part:IsA("BasePart") or not part:IsDescendantOf(col) then return end
    seen[part]=true
    part:SetAttribute("NRSurface",SURFACE=="concrete" and 2 or 1)
    part:SetAttribute("INDY_Surface",SURFACE)
    part.Material=SURFACE=="concrete" and Enum.Material.Concrete or Enum.Material.Asphalt
    count+=1
end
for _,root in ipairs(game:GetService("Selection"):Get()) do
    apply(root);for _,part in ipairs(root:GetDescendants()) do apply(part) end
end
print("track1:",count,"selected collision parts classified as",SURFACE)
