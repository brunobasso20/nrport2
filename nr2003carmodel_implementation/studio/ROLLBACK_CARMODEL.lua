-- ROLLBACK_CARMODEL — volta a bancada para o Stage 13 publicado a partir do backup do próprio instalador
-- (ServerStorage.NR2003Backup_CarModel). Cole na Command Bar, FORA do Play. Não salva o place.
-- Restaura a fonte de NR2003Client / NR2003Server (mesmas instâncias) e confere tamanho + hash contra o Stage 13
-- publicado; a pasta NR2003Lab.CarModel (inclusive Data e o modelo importado em Assets) NÃO é apagada: vai para
-- ServerStorage.NR2003CarModel_Removido (apague você mesmo se quiser); o RemoteEvent DrawState criado pelo instalador é
-- removido. Depois roda o auto-teste Stage 13.
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes")
local RS=game:GetService("ReplicatedStorage")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local storage=game:GetService("ServerStorage")
local SES=game:GetService("ScriptEditorService")
local backup=assert(storage:FindFirstChild("NR2003Backup_CarModel"),"ServerStorage.NR2003Backup_CarModel ausente: nada para reverter")
local pkg=assert(RS:FindFirstChild("NR2003Lab"),"NR2003Lab ausente")
local FOLDERS={Server=SS,Client=SP}
local function setSource(s,src)
    if #src<200000 then s.Source=src else SES:UpdateSourceAsync(s,function() return src end) end
end
local function fnv(src)
    local h=0x811c9dc5
    for i=1,#src do
        h=bit32.bxor(h,string.byte(src,i))
        h=(h*0x193+bit32.band(h,0xff)*0x1000000)%4294967296
    end
    return h
end
for _,e in ipairs({{folder="Client",name="NR2003Client",len=18023,hash=4247357387},{folder="Server",name="NR2003Server",len=4742,hash=3952310422}}) do
    local saved=assert(backup:FindFirstChild(e.folder.."."..e.name),"backup de "..e.name.." ausente")
    local s=assert(FOLDERS[e.folder]:FindFirstChild(e.name),e.name.." não existe mais: restaure manualmente a cópia do backup")
    setSource(s,saved.Source)
    assert(#s.Source==e.len and fnv(s.Source)==e.hash,e.name.." restaurado difere do Stage 13 publicado")
end
local folder=pkg:FindFirstChild("CarModel")
if folder and backup:FindFirstChild("ADDED:NR2003Lab.CarModel") then
    local old=storage:FindFirstChild("NR2003CarModel_Removido");if old then old.Name="NR2003CarModel_Removido_"..os.time() end
    folder.Name="NR2003CarModel_Removido";folder.Parent=storage
end
local remote=pkg:FindFirstChild("DrawState")
if remote and backup:FindFirstChild("ADDED:NR2003Lab.DrawState") then remote:Destroy() end
pkg:SetAttribute("NR2003CarModel",nil)
local ok,r=require(pkg.Roblox.Stage13SelfTest).run(false)
assert(ok,"auto-teste Stage 13 falhou depois da reversão:\n"..table.concat(r,"\n"))
print("Bancada de volta ao Stage 13 publicado (NR2003Client / NR2003Server conferidos; auto-teste Stage 13 OK).")
print("O backup ServerStorage.NR2003Backup_CarModel foi mantido (apague-o você mesmo se quiser). O place NÃO foi salvo.")
