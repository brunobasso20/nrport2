-- PATCH_STAGE10_INSTALL — NR2003 Roblox port, estágio 10: instala o que as partes 1..4 guardaram em
-- ServerStorage.NR2003Stage10Staging (mesmo resultado do PATCH_STAGE10.lua inteiro). Cole na Command Bar, FORA do
-- Play, depois das partes. Se algo falhar, tudo é revertido e as partes guardadas continuam lá (repita só o INSTALL).
-- Atualiza ReplicatedStorage.NR2003Lab no lugar (backup completo em ServerStorage; reverte se falhar).
-- Novos: Core.NR2003Cup.NR2003CupSetupData, NR2003CupSetup, NR2003CupBuild, NR2003CupBuildCode1..n,
-- NR2003CupBuildData1..n, NR2003CupJITG1..n, NR2003CupGarage, Roblox.Stage10SelfTest.
-- Alterados: Core.NR2003Cup.NR2003CupCore (exporta a imagem de reset e a tabela de callbacks), NR2003CupDriver (re-liga
-- as células do freio após um rebuild), Core.NR2003CupVehicle (carrega o Stage 10), Roblox.CupChassisAdapter (atributos
-- Setup_<item>). Imagem e callbacks 6/7 (NR2003CupImage*, NR2003CupJIT*), aero, servidor e cliente intactos.
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes do patch")
local RS=game:GetService("ReplicatedStorage")
local storage=game:GetService("ServerStorage")
local pkg=assert(RS:FindFirstChild("NR2003Lab"),"NR2003Lab ausente: instale Stage 5 + 6/7 + 8 + 9 antes")
local CoreF=assert(pkg:FindFirstChild("Core"),"NR2003Lab.Core ausente")
local RobloxF=assert(pkg:FindFirstChild("Roblox"),"NR2003Lab.Roblox ausente")
local cupFolder=assert(CoreF:FindFirstChild("NR2003Cup"),"Core.NR2003Cup ausente: aplique PATCH_STAGE6_7, 8 e 9 antes")
for _,n in ipairs({"NR2003CupCore","NR2003CupDriver","NR2003CupAero","NR2003CupImage1","NR2003CupJIT1"}) do
    assert(cupFolder:FindFirstChild(n),"Core.NR2003Cup."..n.." ausente (Stage 9 requerido)")
end
for _,n in ipairs({"CupChassisAdapter","Stage67SelfTest","Stage8SelfTest","Stage9SelfTest"}) do
    assert(RobloxF:FindFirstChild(n),"Roblox."..n.." ausente (Stage 9 requerido: aplique PATCH_STAGE9 antes)")
end
assert(pkg.Archivable,"Habilite Archivable no pacote para o backup")
local SES=game:GetService("ScriptEditorService")
local function setSource(s,src)
    if #src<200000 then s.Source=src else SES:UpdateSourceAsync(s,function() return src end) end
end
local staging=assert(storage:FindFirstChild("NR2003Stage10Staging"),"cole antes as partes 1..4 (PATCH_STAGE10_PART*.lua)")
local EXPECT={
    {"NR2003Cup","NR2003CupSetupData",46531,1},
    {"NR2003Cup","NR2003CupSetup",15595,1},
    {"NR2003Cup","NR2003CupBuild",10224,1},
    {"NR2003Cup","NR2003CupBuildCode1",161018,1},
    {"NR2003Cup","NR2003CupBuildCode2",164236,1},
    {"NR2003Cup","NR2003CupBuildCode3",164713,1},
    {"NR2003Cup","NR2003CupBuildCode4",164303,2},
    {"NR2003Cup","NR2003CupBuildCode5",167501,2},
    {"NR2003Cup","NR2003CupBuildCode6",152476,2},
    {"NR2003Cup","NR2003CupBuildData1",169926,3},
    {"NR2003Cup","NR2003CupBuildData2",19080,3},
    {"NR2003Cup","NR2003CupJITG1",90759,3},
    {"NR2003Cup","NR2003CupJITG2",142333,3},
    {"NR2003Cup","NR2003CupJITG3",74909,3},
    {"NR2003Cup","NR2003CupJITG4",126210,3},
    {"NR2003Cup","NR2003CupGarage",8256,3},
    {"NR2003Cup","NR2003CupCore",172961,4},
    {"NR2003Cup","NR2003CupDriver",21975,4},
    {"Core","NR2003CupVehicle",6632,4},
    {"Roblox","CupChassisAdapter",24277,4},
    {"Roblox","Stage10SelfTest",198344,4},
}
local MODULES={}
for _,e in ipairs(EXPECT) do
    local f=staging:FindFirstChild(e[1]);local s=f and f:FindFirstChild(e[2])
    assert(s and #s.Source==e[3],"módulo "..e[1].."."..e[2].." ausente ou incompleto: cole de novo a parte "..e[4])
    MODULES[#MODULES+1]={e[1],e[2],s}
end
-- backup (complete copy) ---------------------------------------------------------------
local backup=Instance.new("Folder")
local base="NR2003Backup_Stage10_"..tostring(os.time());local suffix=0
while storage:FindFirstChild(base.."_"..suffix) do suffix=suffix+1 end
backup.Name=base.."_"..suffix
pkg:Clone().Parent=backup
backup.Parent=storage
local function apply()
    local dest={NR2003Cup=cupFolder,Core=CoreF,Roblox=RobloxF}
    -- remove parts of a previous Stage 10 install that this patch no longer ships
    for _,c in ipairs(cupFolder:GetChildren()) do
        if c.Name:match("^NR2003CupBuildCode%d+$") or c.Name:match("^NR2003CupBuildData%d+$") or c.Name:match("^NR2003CupJITG%d+$") then c:Destroy() end
    end
    for _,m in ipairs(MODULES) do
        local folder,name,source=m[1],m[2],m[3]
        local parent=dest[folder]
        local existing=parent:FindFirstChild(name)
        if existing then existing:Destroy() end
        local s=source:Clone();s.Name=name;s.Parent=parent
        assert(s.Source==source.Source,"fonte truncada: "..folder.."."..name)
    end
    pkg:SetAttribute("NR2003Stage","10");pkg:SetAttribute("NR2003Version","3.9.0-stage10")
    local ok67,r67=require(RobloxF.Stage67SelfTest).run(false)
    assert(ok67,"self-test Stage 6/7 falhou:\n"..table.concat(r67,"\n"))
    local ok8,r8=require(RobloxF.Stage8SelfTest).run(false)
    assert(ok8,"self-test Stage 8 falhou:\n"..table.concat(r8,"\n"))
    local ok9,r9=require(RobloxF.Stage9SelfTest).run(false)
    assert(ok9,"self-test Stage 9 falhou:\n"..table.concat(r9,"\n"))
    local ok10,r10=require(RobloxF.Stage10SelfTest).run(false)
    assert(ok10,"self-test Stage 10 falhou:\n"..table.concat(r10,"\n"))
end
local ok,reason=pcall(apply)
if not ok then
    local savedPkg=backup:FindFirstChild("NR2003Lab")
    pkg:Destroy();savedPkg:Clone().Parent=RS
    error("Patch Stage 10 revertido (nada mudou além do backup em ServerStorage."..backup.Name.."): "..tostring(reason))
end
staging:Destroy()
print("Stage 10 aplicado. Backup: ServerStorage."..backup.Name)
print("Setup: atributos Setup_<item> no TestCar em unidades da garagem (ex.: Setup_springLF=1700, Setup_camberLF=-2.5,")
print("  Setup_casterRF=4, Setup_trackBarRR=11, Setup_wedge=50, Setup_gearChoice1=120, Setup_tirePressureRF=40). Aplicados ao reiniciar (R)")
print("  pelo build ORIGINAL do carro; SetupStructure / SetupApplySeconds / SetupError mostram o resultado. Lista: SETUP_MAP.md.")
print("Play > F entrar | W/S acel/freio | A/D direção | E/Q marchas | R reinicia | T painel")
