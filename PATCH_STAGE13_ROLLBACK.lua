-- PATCH_STAGE13_ROLLBACK — volta a bancada para o Stage 12.1 publicado a partir do backup do próprio patch
-- (ServerStorage.NR2003Backup_Stage13). Cole na Command Bar, FORA do Play. Não salva o place.
-- Restaura a fonte de cada instância alterada (mesma instância), apaga os módulos que o Stage 13 criou (NR2003CupFFB,
-- Stage13SelfTest), confere tamanho + hash de cada fonte restaurada contra o Stage 12.1 publicado e roda o auto-teste
-- Stage 12. (Para voltar ao Stage 12 depois: PATCH_STAGE12_1_ROLLBACK.lua.)
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes")
local RS=game:GetService("ReplicatedStorage")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local storage=game:GetService("ServerStorage")
local SES=game:GetService("ScriptEditorService")
local backup=assert(storage:FindFirstChild("NR2003Backup_Stage13"),"ServerStorage.NR2003Backup_Stage13 ausente: nada para reverter")
local pkg=assert(RS:FindFirstChild("NR2003Lab"),"NR2003Lab ausente")
assert(pkg:GetAttribute("NR2003Stage")=="13","a bancada não está no Stage 13")
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
local STAGE12_1={["NR2003Cup.NR2003CupDriver"]={25020,1689364345},["NR2003Cup.NR2003CupFrame"]={18600,2779562858},["Core.NR2003CupVehicle"]={9070,588044759},["Core.CupTune"]={4911,116976927},["Roblox.CupChassisAdapter"]={33593,1789175741},["Client.NR2003Client"]={16064,1723780329}}
-- verify the whole backup before touching anything
local restore,remove={},{}
for _,c in ipairs(backup:GetChildren()) do
    local added=string.match(c.Name,"^ADDED:(.+)$")
    local key=added or c.Name
    local folder,name=string.match(key,"^([^.]+)%.(.+)$")
    local target=FOLDERS[folder] and FOLDERS[folder]:FindFirstChild(name)
    if added then
        if target then table.insert(remove,target) end
    else
        assert(target,"instância "..c.Name.." não existe mais: restaure manualmente a cópia ServerStorage.NR2003Backup_Stage13."..c.Name)
        local want=STAGE12_1[c.Name]
        assert(want==nil or (#c.Source==want[1] and fnv(c.Source)==want[2]),"backup de "..c.Name.." não é a fonte Stage 12.1 publicada")
        table.insert(restore,{target=target,source=c.Source,key=c.Name})
    end
end
for _,r in ipairs(restore) do setSource(r.target,r.source);assert(#r.target.Source==#r.source,"fonte truncada: "..r.key) end
for _,t in ipairs(remove) do t:Destroy() end
pkg:SetAttribute("NR2003Stage",backup:GetAttribute("FromStage") or "12.1")
pkg:SetAttribute("NR2003Version",backup:GetAttribute("FromVersion"))
local ok,r=require(RobloxF.Stage12SelfTest).run(false)
assert(ok,"rollback aplicado, mas o auto-teste Stage 12 falhou:\n"..table.concat(r,"\n"))
print(string.format("Rollback Stage 13 -> Stage 12.1: %d fontes restauradas, %d módulos do Stage 13 removidos; auto-teste Stage 12 OK.",#restore,#remove))
print("O backup ServerStorage.NR2003Backup_Stage13 foi mantido (apague-o você mesmo se quiser). O place NÃO foi salvo.")
