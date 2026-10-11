-- PATCH_STAGE12_1_INSTALL — instala o que PATCH_STAGE12_1_PART1..2 guardaram em ServerStorage.NR2003Stage12_1Staging
-- (mesmo resultado do PATCH_STAGE12_1.lua inteiro).
-- Cole na Command Bar do Studio, FORA do Play, sobre a bancada Stage 12 publicada (ou Insert from File do .rbxmx; ou as
-- partes + INSTALL). O patch NÃO salva o place: salve você mesmo depois de conferir.
-- Alterados (fonte atualizada no lugar, mesma instância): Core.NR2003Cup.NR2003CupSteering, Core.CupTune,
-- Roblox.CupChassisAdapter, Roblox.Stage12SelfTest, NR2003Client. Nada é criado, substituído ou apagado.
-- Física: a mesma cadeia original do Stage 12. Trava 360° (= o x pi original), relação do setup 12:1 pelo garage original,
-- teclas com a taxa original da imagem (0.033), eixo/mouse com momentum 0 (sem rampa, sem seno), volante do cockpit até a trava.
-- Segurança: confere o Stage 12 módulo por módulo (tamanho + hash da fonte publicada), backup SÓ do que muda em
-- ServerStorage.NR2003Backup_Stage12_1 (criado uma vez, nunca sobrescrito), re-executar é seguro, auto-testes 6/7..12 no
-- fim e reversão automática se algo falhar. Reversão manual: PATCH_STAGE12_1_ROLLBACK.lua.
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes do patch")
local RS=game:GetService("ReplicatedStorage")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local storage=game:GetService("ServerStorage")
local SES=game:GetService("ScriptEditorService")
local pkg=assert(RS:FindFirstChild("NR2003Lab"),"NR2003Lab ausente: instale a bancada Stage 12 antes")
local stage=pkg:GetAttribute("NR2003Stage")
assert(stage=="12" or stage=="12.1","este patch exige a bancada Stage 12 (NR2003Stage = "..tostring(stage).."): aplique antes PATCH_STAGE12")
local CoreF=assert(pkg:FindFirstChild("Core"),"NR2003Lab.Core ausente")
local RobloxF=assert(pkg:FindFirstChild("Roblox"),"NR2003Lab.Roblox ausente")
local cupFolder=assert(CoreF:FindFirstChild("NR2003Cup"),"Core.NR2003Cup ausente")
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
local FOLDERS={NR2003Cup=cupFolder,Core=CoreF,Roblox=RobloxF,Server=SS,Client=SP}
local function find(folder,name) return FOLDERS[folder]:FindFirstChild(name) end
local staging=assert(storage:FindFirstChild("NR2003Stage12_1Staging"),"cole antes as partes 1..2 (PATCH_STAGE12_1_PART*.lua)")
local ITEMS={}
local function item(folder,name,class,oldLen,oldHash,newLen,newHash,source)
    ITEMS[#ITEMS+1]={folder=folder,name=name,class=class,oldLen=oldLen,oldHash=oldHash,newLen=newLen,newHash=newHash,source=source}
end
do local s=assert(staging:FindFirstChild("NR2003Cup.NR2003CupSteering"),"fonte NR2003Cup.NR2003CupSteering ausente: cole de novo as partes")
    assert(#s.Source==21927,"fonte NR2003Cup.NR2003CupSteering incompleta: cole de novo as partes")
    item("NR2003Cup","NR2003CupSteering","ModuleScript",19075,2934930772,21927,1014127710,s.Source) end
do local s=assert(staging:FindFirstChild("Core.CupTune"),"fonte Core.CupTune ausente: cole de novo as partes")
    assert(#s.Source==4911,"fonte Core.CupTune incompleta: cole de novo as partes")
    item("Core","CupTune","ModuleScript",3532,4192037686,4911,116976927,s.Source) end
do local s=assert(staging:FindFirstChild("Roblox.CupChassisAdapter"),"fonte Roblox.CupChassisAdapter ausente: cole de novo as partes")
    assert(#s.Source==33593,"fonte Roblox.CupChassisAdapter incompleta: cole de novo as partes")
    item("Roblox","CupChassisAdapter","ModuleScript",32198,4136930264,33593,1789175741,s.Source) end
do local s=assert(staging:FindFirstChild("Client.NR2003Client"),"fonte Client.NR2003Client ausente: cole de novo as partes")
    assert(#s.Source==16064,"fonte Client.NR2003Client incompleta: cole de novo as partes")
    item("Client","NR2003Client","LocalScript",15936,3687068143,16064,1723780329,s.Source) end
do local s=assert(staging:FindFirstChild("Roblox.Stage12SelfTest"),"fonte Roblox.Stage12SelfTest ausente: cole de novo as partes")
    assert(#s.Source==193065,"fonte Roblox.Stage12SelfTest incompleta: cole de novo as partes")
    item("Roblox","Stage12SelfTest","ModuleScript",191114,1712048471,193065,3846319133,s.Source) end
-- 1) baseline check (nothing is changed before every target is verified) -----------------------------------
local plan,problems={},{}
for _,it in ipairs(ITEMS) do
    local s=find(it.folder,it.name)
    if s==nil then table.insert(problems,it.folder.."."..it.name.." ausente (Stage 12 requerido)") else
        local src=s.Source;local n,h=#src,fnv(src)
        if n==it.newLen and h==it.newHash then table.insert(plan,{it=it,s=s,state="current"})
        elseif n==it.oldLen and h==it.oldHash then table.insert(plan,{it=it,s=s,state="replace"})
        else table.insert(problems,string.format("%s.%s difere do Stage 12 publicado (%d bytes, hash %08x): alterado localmente?",it.folder,it.name,n,h)) end
    end
end
if #problems>0 and not _G.NR2003_PATCH12_1_FORCE then
    error("Patch Stage 12.1 recusado, nada foi alterado:\n  "..table.concat(problems,"\n  ")..
        "\n(_G.NR2003_PATCH12_1_FORCE=true instala mesmo assim, com backup do que existir)")
end
-- 2) backup of exactly the instances this patch changes (created once; a re-run keeps the first backup) ------
local backup=storage:FindFirstChild("NR2003Backup_Stage12_1")
local firstInstall=backup==nil
if firstInstall then
    backup=Instance.new("Folder");backup.Name="NR2003Backup_Stage12_1"
    backup:SetAttribute("FromStage",stage);backup:SetAttribute("FromVersion",pkg:GetAttribute("NR2003Version"))
    backup:SetAttribute("Created",os.time())
    for _,p in ipairs(plan) do
        local c=p.s:Clone();c.Name=p.it.folder.."."..p.it.name;c.Parent=backup
    end
    backup.Parent=storage
end
-- 3) apply (sources updated in place) and self-tests; revert on any failure ---------------------------------
local touched={}
local function apply()
    for _,p in ipairs(plan) do
        if p.state=="replace" then
            local s=p.s
            table.insert(touched,{s=s,old=s.Source})
            setSource(s,p.it.source)
            assert(#s.Source==p.it.newLen and fnv(s.Source)==p.it.newHash,"fonte truncada: "..p.it.folder.."."..p.it.name)
        end
    end
    pkg:SetAttribute("NR2003Stage","12.1");pkg:SetAttribute("NR2003Version","3.11.1-stage12.1")
    for _,n in ipairs({"Stage67SelfTest","Stage8SelfTest","Stage9SelfTest","Stage10SelfTest","Stage11SelfTest","Stage12SelfTest"}) do
        local ok,r=require(RobloxF[n]).run(false)
        assert(ok,"self-test "..n.." falhou:\n"..table.concat(r,"\n"))
    end
end
local ok,reason=pcall(apply)
if not ok then
    for i=#touched,1,-1 do local t=touched[i];setSource(t.s,t.old) end
    pkg:SetAttribute("NR2003Stage",stage);pkg:SetAttribute("NR2003Version",backup:GetAttribute("FromVersion"))
    if firstInstall then backup:Destroy() end
    error("Patch Stage 12.1 revertido (fontes restauradas): "..tostring(reason))
end
staging:Destroy()
print("Stage 12.1 aplicado ("..(firstInstall and "backup: ServerStorage.NR2003Backup_Stage12_1" or "re-execução: backup anterior mantido")..").")
print("Padrões da bancada (Core.CupTune.driver): trava 360° (180° por lado = o x pi original), relação do setup 12:1 (item 0x30 pelo")
print("  garage original; 7:1 abaixo de 20 mph pelo override original), teclas com a taxa original 0.033 por quadro, eixo/mouse")
print("  com momentum 0 (entrada direta), volante do cockpit até a trava (180°).")
print("Atributos do TestCar (no reset, R): SteeringLockDegrees (360 = original), Setup_steeringRatio 12..32, SteeringMomentumKeys /")
print("  SteeringMomentumAxis 0..100, CockpitWheelClamp \"lock\" / \"original\" (160°), e os do Stage 12 (SteeringLinearity, ...).")
print("O place NÃO foi salvo. Reverter: PATCH_STAGE12_1_ROLLBACK.lua. Auto-teste completo: require(...Roblox.Stage12SelfTest).run(true)")
