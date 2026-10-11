-- PATCH_STAGE12_1_ROLLBACK — volta a bancada para o Stage 12 publicado a partir do backup do próprio patch
-- (ServerStorage.NR2003Backup_Stage12_1). Cole na Command Bar, FORA do Play. Não salva o place.
-- Restaura a fonte de cada instância alterada (mesma instância), confere tamanho + hash de cada fonte restaurada contra o
-- Stage 12 publicado e roda o auto-teste Stage 12. (Para voltar ao Stage 11 depois: PATCH_STAGE12_ROLLBACK.lua.)
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes")
local RS=game:GetService("ReplicatedStorage")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local storage=game:GetService("ServerStorage")
local SES=game:GetService("ScriptEditorService")
local backup=assert(storage:FindFirstChild("NR2003Backup_Stage12_1"),"ServerStorage.NR2003Backup_Stage12_1 ausente: nada para reverter")
local pkg=assert(RS:FindFirstChild("NR2003Lab"),"NR2003Lab ausente")
assert(pkg:GetAttribute("NR2003Stage")=="12.1","a bancada não está no Stage 12.1")
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
local STAGE12={["NR2003Cup.NR2003CupSteering"]={19075,2934930772},["Core.CupTune"]={3532,4192037686},["Roblox.CupChassisAdapter"]={32198,4136930264},["Client.NR2003Client"]={15936,3687068143},["Roblox.Stage12SelfTest"]={191114,1712048471}}
-- verify the whole backup before touching anything
local restore={}
for _,c in ipairs(backup:GetChildren()) do
    local folder,name=string.match(c.Name,"^([^.]+)%.(.+)$")
    local target=FOLDERS[folder] and FOLDERS[folder]:FindFirstChild(name)
    assert(target,"instância "..c.Name.." não existe mais: restaure manualmente a cópia ServerStorage.NR2003Backup_Stage12_1."..c.Name)
    local want=STAGE12[c.Name]
    assert(want==nil or (#c.Source==want[1] and fnv(c.Source)==want[2]),"backup de "..c.Name.." não é a fonte Stage 12 publicada")
    table.insert(restore,{target=target,source=c.Source,key=c.Name})
end
for _,r in ipairs(restore) do setSource(r.target,r.source);assert(#r.target.Source==#r.source,"fonte truncada: "..r.key) end
pkg:SetAttribute("NR2003Stage",backup:GetAttribute("FromStage") or "12")
pkg:SetAttribute("NR2003Version",backup:GetAttribute("FromVersion"))
local ok,r=require(RobloxF.Stage12SelfTest).run(false)
assert(ok,"rollback aplicado, mas o auto-teste Stage 12 falhou:\n"..table.concat(r,"\n"))
print(string.format("Rollback Stage 12.1 -> Stage 12: %d fontes restauradas; auto-teste Stage 12 OK.",#restore))
print("O backup ServerStorage.NR2003Backup_Stage12_1 foi mantido (apague-o você mesmo se quiser). O place NÃO foi salvo.")
