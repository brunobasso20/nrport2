-- PATCH_STAGE12_ROLLBACK — volta a bancada para o Stage 11 a partir do backup do próprio patch
-- (ServerStorage.NR2003Backup_Stage12). Cole na Command Bar, FORA do Play. Não salva o place.
-- Restaura a fonte de cada instância alterada (mesma instância), remove só os módulos que o patch ADICIONOU,
-- confere tamanho + hash de cada fonte restaurada contra o Stage 11 publicado e roda o auto-teste Stage 11.
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes")
local RS=game:GetService("ReplicatedStorage")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local storage=game:GetService("ServerStorage")
local SES=game:GetService("ScriptEditorService")
local backup=assert(storage:FindFirstChild("NR2003Backup_Stage12"),"ServerStorage.NR2003Backup_Stage12 ausente: nada para reverter")
local pkg=assert(RS:FindFirstChild("NR2003Lab"),"NR2003Lab ausente")
assert(pkg:GetAttribute("NR2003Stage")=="12","a bancada não está no Stage 12")
local CoreF,RobloxF=pkg.Core,pkg.Roblox
local FOLDERS={NR2003Cup=CoreF.NR2003Cup,Core=CoreF,Roblox=RobloxF,Server=SS,Client=SP}
local function setSource(s,src)
    if #src<200000 then s.Source=src else SES:UpdateSourceAsync(s,function() return src end) end
end
-- FNV-1a 32 of the source bytes; h * 0x01000193 mod 2^32 = h * 0x193 + (h mod 256) * 2^24 (exact in double precision)
local function fnv(src)
    local h=0x811c9dc5
    for i=1,#src do
        h=bit32.bxor(h,string.byte(src,i))
        h=(h*0x193+bit32.band(h,0xff)*0x1000000)%4294967296
    end
    return h
end
local STAGE11={["NR2003Cup.NR2003CupDriver"]={22394,857451009},["Core.NR2003CupVehicle"]={7925,3736862230},["Roblox.CupChassisAdapter"]={28501,1352800795},["Roblox.Cockpit"]={3958,2216434014},["Roblox.RenderSnapshot"]={6072,1355566575},["Roblox.RenderPresentation"]={2853,417927731},["Server.NR2003Server"]={4009,1117744807},["Client.NR2003Client"]={14210,2653526811},["Roblox.Stage67SelfTest"]={60457,511586509},["Roblox.Stage8SelfTest"]={188240,3860612614},["Roblox.Stage9SelfTest"]={186234,766859960},["Roblox.Stage10SelfTest"]={198519,2781813066},["Roblox.Stage11SelfTest"]={172423,250092584}}
-- verify the whole backup before touching anything
local restore,remove={},{}
for _,c in ipairs(backup:GetChildren()) do
    local key=c:IsA("StringValue") and c.Value or c.Name
    local folder,name=string.match(key,"^([^.]+)%.(.+)$")
    local target=FOLDERS[folder] and FOLDERS[folder]:FindFirstChild(name)
    if c:IsA("StringValue") then
        if target then table.insert(remove,target) end
    else
        assert(target,"instância "..key.." não existe mais: restaure manualmente a cópia ServerStorage.NR2003Backup_Stage12."..c.Name)
        local want=STAGE11[key]
        assert(want==nil or (#c.Source==want[1] and fnv(c.Source)==want[2]),"backup de "..key.." não é a fonte Stage 11 publicada")
        table.insert(restore,{target=target,source=c.Source,key=key})
    end
end
for _,r in ipairs(restore) do setSource(r.target,r.source);assert(#r.target.Source==#r.source,"fonte truncada: "..r.key) end
for _,t in ipairs(remove) do t:Destroy() end
pkg:SetAttribute("NR2003Stage",backup:GetAttribute("FromStage") or "11")
pkg:SetAttribute("NR2003Version",backup:GetAttribute("FromVersion"))
local ok,r=require(RobloxF.Stage11SelfTest).run(false)
assert(ok,"rollback aplicado, mas o auto-teste Stage 11 falhou:\n"..table.concat(r,"\n"))
print(string.format("Rollback Stage 12 -> Stage 11: %d fontes restauradas, %d módulos removidos; auto-teste Stage 11 OK.",#restore,#remove))
print("O backup ServerStorage.NR2003Backup_Stage12 foi mantido (apague-o você mesmo se quiser). O place NÃO foi salvo.")
