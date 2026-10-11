-- PATCH_STAGE11_INSTALL — NR2003 Roblox port, estágio 11: instala o que as partes 1..3 guardaram em
-- ServerStorage.NR2003Stage11Staging (mesmo resultado do PATCH_STAGE11.lua inteiro). Cole na Command Bar, FORA do
-- Play, depois das partes. Se algo falhar, tudo é revertido e as partes guardadas continuam lá (repita só o INSTALL).
-- Atualiza ReplicatedStorage.NR2003Lab no lugar (backup completo em ServerStorage; reverte se falhar).
-- Novos: Core.NR2003Cup.NR2003CupFrame, NR2003CupFrameCode1..n, NR2003CupFrameData1..n (fim de quadro ORIGINAL 00554520
-- + dano de colisão 00549c40, levantados do executável), Roblox.Stage11SelfTest.
-- Alterados: Core.NR2003Cup.NR2003CupDriver (início de quadro do Stage 11 + fim de quadro trocável), Core.NR2003CupVehicle
-- (carrega o Stage 11, API de sessão/eventos/telemetria), Roblox.CupChassisAdapter (opções de corrida, telemetria),
-- self-tests 6/7, 8, 9, 10 (comparam no modo "frozen" = fim de quadro dos estágios 6-10) e o LocalScript NR2003Client (HUD).
-- Imagem e callbacks 6/7, aero, setup/build do Stage 10 e servidor intactos.
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes do patch")
local RS=game:GetService("ReplicatedStorage")
local SP=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local storage=game:GetService("ServerStorage")
local pkg=assert(RS:FindFirstChild("NR2003Lab"),"NR2003Lab ausente: instale Stage 5 + 6/7 + 8 + 9 + 10 antes")
local CoreF=assert(pkg:FindFirstChild("Core"),"NR2003Lab.Core ausente")
local RobloxF=assert(pkg:FindFirstChild("Roblox"),"NR2003Lab.Roblox ausente")
local cupFolder=assert(CoreF:FindFirstChild("NR2003Cup"),"Core.NR2003Cup ausente: aplique PATCH_STAGE6_7, 8, 9 e 10 antes")
for _,n in ipairs({"NR2003CupCore","NR2003CupDriver","NR2003CupAero","NR2003CupImage1","NR2003CupJIT1","NR2003CupGarage","NR2003CupBuild","NR2003CupSetup"}) do
    assert(cupFolder:FindFirstChild(n),"Core.NR2003Cup."..n.." ausente (Stage 10 requerido: aplique PATCH_STAGE10 antes)")
end
for _,n in ipairs({"CupChassisAdapter","Stage67SelfTest","Stage8SelfTest","Stage9SelfTest","Stage10SelfTest"}) do
    assert(RobloxF:FindFirstChild(n),"Roblox."..n.." ausente (Stage 10 requerido: aplique PATCH_STAGE10 antes)")
end
local oldClient=assert(SP:FindFirstChild("NR2003Client"),"StarterPlayerScripts.NR2003Client ausente")
assert(pkg.Archivable,"Habilite Archivable no pacote para o backup")
local SES=game:GetService("ScriptEditorService")
local function setSource(s,src)
    if #src<200000 then s.Source=src else SES:UpdateSourceAsync(s,function() return src end) end
end
local staging=assert(storage:FindFirstChild("NR2003Stage11Staging"),"cole antes as partes 1..3 (PATCH_STAGE11_PART*.lua)")
local EXPECT={
    {"NR2003Cup","NR2003CupFrame",18600,1},
    {"NR2003Cup","NR2003CupFrameCode1",163718,1},
    {"NR2003Cup","NR2003CupFrameCode2",167197,1},
    {"NR2003Cup","NR2003CupFrameCode3",168218,1},
    {"NR2003Cup","NR2003CupFrameCode4",134948,2},
    {"NR2003Cup","NR2003CupFrameData1",44797,2},
    {"NR2003Cup","NR2003CupDriver",22394,2},
    {"Core","NR2003CupVehicle",7925,2},
    {"Roblox","CupChassisAdapter",28501,2},
    {"Roblox","Stage67SelfTest",60457,2},
    {"Roblox","Stage8SelfTest",188240,2},
    {"Roblox","Stage9SelfTest",186234,3},
    {"Roblox","Stage10SelfTest",198519,3},
    {"Roblox","Stage11SelfTest",172423,3},
    {"Client","NR2003Client",14210,3},
}
local MODULES={}
local clientSource
for _,e in ipairs(EXPECT) do
    local f=staging:FindFirstChild(e[1]);local s=f and f:FindFirstChild(e[2])
    assert(s and #s.Source==e[3],"módulo "..e[1].."."..e[2].." ausente ou incompleto: cole de novo a parte "..e[4])
    if e[1]=="Client" then clientSource=s.Source else MODULES[#MODULES+1]={e[1],e[2],s} end
end
assert(clientSource,"fonte do NR2003Client ausente")
-- backup (complete copies) -------------------------------------------------------------
local backup=Instance.new("Folder")
local base="NR2003Backup_Stage11_"..tostring(os.time());local suffix=0
while storage:FindFirstChild(base.."_"..suffix) do suffix=suffix+1 end
backup.Name=base.."_"..suffix
pkg:Clone().Parent=backup;oldClient:Clone().Parent=backup
backup.Parent=storage
local function apply()
    local dest={NR2003Cup=cupFolder,Core=CoreF,Roblox=RobloxF}
    -- remove parts of a previous Stage 11 install that this patch no longer ships
    for _,c in ipairs(cupFolder:GetChildren()) do
        if c.Name:match("^NR2003CupFrameCode%d+$") or c.Name:match("^NR2003CupFrameData%d+$") then c:Destroy() end
    end
    for _,m in ipairs(MODULES) do
        local folder,name,source=m[1],m[2],m[3]
        local parent=dest[folder]
        local existing=parent:FindFirstChild(name)
        if existing then existing:Destroy() end
        local s=source:Clone();s.Name=name;s.Parent=parent
        assert(s.Source==source.Source,"fonte truncada: "..folder.."."..name)
    end
    setSource(oldClient,clientSource)
    pkg:SetAttribute("NR2003Stage","11");pkg:SetAttribute("NR2003Version","3.10.0-stage11")
    local ok67,r67=require(RobloxF.Stage67SelfTest).run(false)
    assert(ok67,"self-test Stage 6/7 falhou:\n"..table.concat(r67,"\n"))
    local ok8,r8=require(RobloxF.Stage8SelfTest).run(false)
    assert(ok8,"self-test Stage 8 falhou:\n"..table.concat(r8,"\n"))
    local ok9,r9=require(RobloxF.Stage9SelfTest).run(false)
    assert(ok9,"self-test Stage 9 falhou:\n"..table.concat(r9,"\n"))
    local ok10,r10=require(RobloxF.Stage10SelfTest).run(false)
    assert(ok10,"self-test Stage 10 falhou:\n"..table.concat(r10,"\n"))
    local ok11,r11=require(RobloxF.Stage11SelfTest).run(false)
    assert(ok11,"self-test Stage 11 falhou:\n"..table.concat(r11,"\n"))
end
local ok,reason=pcall(apply)
if not ok then
    local savedPkg=backup:FindFirstChild("NR2003Lab");local savedClient=backup:FindFirstChild("NR2003Client")
    pkg:Destroy();savedPkg:Clone().Parent=RS
    setSource(oldClient,savedClient.Source)
    error("Patch Stage 11 revertido (nada mudou além do backup em ServerStorage."..backup.Name.."): "..tostring(reason))
end
staging:Destroy()
print("Stage 11 aplicado. Backup: ServerStorage."..backup.Name)
print("Runtime original por quadro: combustível (massa/inércia), motor (água/óleo/níveis/potência/desgaste/falha), pneus (3 zonas,")
print("  pressão, desgaste, aderência, estouro), freios (temperatura), falhas aleatórias e dano de colisão — tudo do NR2003.exe.")
print("Atributos do TestCar (aplicados ao reiniciar, R): RaceDamageLevel 0..3 (0 = sem dano), RaceConsumptionRate 0..3 (x1..x4),")
print("  RosterSeries, RandomSeed, Stage11Runtime=\"frozen\" (A/B: fim de quadro dos estágios 6-10). TESTE: DamageTestImpact=<magnitude>,")
print("  PitTyresTest=true. Painel T: linha COMB / água / óleo / pot / dano / pneus / freios.")
print("Play > F entrar | W/S acel/freio | A/D direção | E/Q marchas | R reinicia | T painel")
