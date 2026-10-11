-- PATCH_STAGE13_INSTALL — instala o que PATCH_STAGE13_PART1..2 guardaram em ServerStorage.NR2003Stage13Staging
-- (mesmo resultado do PATCH_STAGE13.lua inteiro).
-- Cole na Command Bar do Studio, FORA do Play, sobre a bancada Stage 12.1 publicada (ou Insert from File do .rbxmx; ou as
-- partes + INSTALL). O patch NÃO salva o place: salve você mesmo depois de conferir.
-- Novos: Core.NR2003Cup.NR2003CupFFB (00554d30 / bloco FFB de 00554520 / 00550070 + 0054fed0 / setters, aritmética x87
-- exata), Roblox.Stage13SelfTest.
-- Alterados (fonte atualizada no lugar, mesma instância): Core.NR2003Cup.NR2003CupDriver, Core.NR2003Cup.NR2003CupFrame,
-- Core.NR2003CupVehicle, Core.CupTune, Roblox.CupChassisAdapter, NR2003Client.
-- Física: inalterada (o FFB não realimenta nada). Saída: a força constante original (-1..1) em atributos do carro
-- (FFBForce / FFBMagnitude / FFBActive), linha FFB no painel e motores do gamepad (apresentação).
-- Segurança: confere o Stage 12.1 módulo por módulo (tamanho + hash da fonte publicada), backup SÓ do que muda em
-- ServerStorage.NR2003Backup_Stage13 (criado uma vez, nunca sobrescrito), re-executar é seguro, auto-testes 6/7..13 no
-- fim e reversão automática se algo falhar. Reversão manual: PATCH_STAGE13_ROLLBACK.lua.
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes do patch")
local RS=game:GetService("ReplicatedStorage")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local storage=game:GetService("ServerStorage")
local SES=game:GetService("ScriptEditorService")
local pkg=assert(RS:FindFirstChild("NR2003Lab"),"NR2003Lab ausente: instale a bancada Stage 12.1 antes")
local stage=pkg:GetAttribute("NR2003Stage")
assert(stage=="12.1" or stage=="13","este patch exige a bancada Stage 12.1 (NR2003Stage = "..tostring(stage).."): aplique antes PATCH_STAGE12_1")
local CoreF=assert(pkg:FindFirstChild("Core"),"NR2003Lab.Core ausente")
local RobloxF=assert(pkg:FindFirstChild("Roblox"),"NR2003Lab.Roblox ausente")
local cupFolder=assert(CoreF:FindFirstChild("NR2003Cup"),"Core.NR2003Cup ausente")
for _,n in ipairs({"NR2003CupCore","NR2003CupFrame","NR2003CupGarage","NR2003CupBuild","NR2003CupAero","NR2003CupSteering"}) do
    assert(cupFolder:FindFirstChild(n),"Core.NR2003Cup."..n.." ausente (Stage 12.1 requerido)")
end
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
local staging=assert(storage:FindFirstChild("NR2003Stage13Staging"),"cole antes as partes 1..2 (PATCH_STAGE13_PART*.lua)")
local ITEMS={}
local function item(folder,name,class,oldLen,oldHash,newLen,newHash,source)
    ITEMS[#ITEMS+1]={folder=folder,name=name,class=class,oldLen=oldLen,oldHash=oldHash,newLen=newLen,newHash=newHash,source=source}
end
do local s=assert(staging:FindFirstChild("NR2003Cup.NR2003CupDriver"),"fonte NR2003Cup.NR2003CupDriver ausente: cole de novo as partes")
    assert(#s.Source==25607,"fonte NR2003Cup.NR2003CupDriver incompleta: cole de novo as partes")
    item("NR2003Cup","NR2003CupDriver","ModuleScript",25020,1689364345,25607,4100876898,s.Source) end
do local s=assert(staging:FindFirstChild("NR2003Cup.NR2003CupFrame"),"fonte NR2003Cup.NR2003CupFrame ausente: cole de novo as partes")
    assert(#s.Source==19469,"fonte NR2003Cup.NR2003CupFrame incompleta: cole de novo as partes")
    item("NR2003Cup","NR2003CupFrame","ModuleScript",18600,2779562858,19469,3109773798,s.Source) end
do local s=assert(staging:FindFirstChild("Core.NR2003CupVehicle"),"fonte Core.NR2003CupVehicle ausente: cole de novo as partes")
    assert(#s.Source==10193,"fonte Core.NR2003CupVehicle incompleta: cole de novo as partes")
    item("Core","NR2003CupVehicle","ModuleScript",9070,588044759,10193,1159174214,s.Source) end
do local s=assert(staging:FindFirstChild("Core.CupTune"),"fonte Core.CupTune ausente: cole de novo as partes")
    assert(#s.Source==5569,"fonte Core.CupTune incompleta: cole de novo as partes")
    item("Core","CupTune","ModuleScript",4911,116976927,5569,669310955,s.Source) end
do local s=assert(staging:FindFirstChild("Roblox.CupChassisAdapter"),"fonte Roblox.CupChassisAdapter ausente: cole de novo as partes")
    assert(#s.Source==37708,"fonte Roblox.CupChassisAdapter incompleta: cole de novo as partes")
    item("Roblox","CupChassisAdapter","ModuleScript",33593,1789175741,37708,2918153274,s.Source) end
do local s=assert(staging:FindFirstChild("Client.NR2003Client"),"fonte Client.NR2003Client ausente: cole de novo as partes")
    assert(#s.Source==18023,"fonte Client.NR2003Client incompleta: cole de novo as partes")
    item("Client","NR2003Client","LocalScript",16064,1723780329,18023,4247357387,s.Source) end
do local s=assert(staging:FindFirstChild("NR2003Cup.NR2003CupFFB"),"fonte NR2003Cup.NR2003CupFFB ausente: cole de novo as partes")
    assert(#s.Source==30938,"fonte NR2003Cup.NR2003CupFFB incompleta: cole de novo as partes")
    item("NR2003Cup","NR2003CupFFB","ModuleScript",nil,nil,30938,3259516721,s.Source) end
do local s=assert(staging:FindFirstChild("Roblox.Stage13SelfTest"),"fonte Roblox.Stage13SelfTest ausente: cole de novo as partes")
    assert(#s.Source==160437,"fonte Roblox.Stage13SelfTest incompleta: cole de novo as partes")
    item("Roblox","Stage13SelfTest","ModuleScript",nil,nil,160437,2806672334,s.Source) end
-- 1) baseline check (nothing is changed before every target is verified) -----------------------------------
local plan,problems={},{}
for _,it in ipairs(ITEMS) do
    local s=find(it.folder,it.name)
    if s==nil then
        if it.oldLen~=nil then table.insert(problems,it.folder.."."..it.name.." ausente (Stage 12.1 requerido)") else table.insert(plan,{it=it,state="add"}) end
    else
        local src=s.Source;local n,h=#src,fnv(src)
        if n==it.newLen and h==it.newHash then table.insert(plan,{it=it,s=s,state="current"})
        elseif it.oldLen~=nil and n==it.oldLen and h==it.oldHash then table.insert(plan,{it=it,s=s,state="replace"})
        elseif it.oldLen==nil then table.insert(plan,{it=it,s=s,state="replace"})  -- a module this patch adds (re-run)
        else table.insert(problems,string.format("%s.%s difere do Stage 12.1 publicado (%d bytes, hash %08x): alterado localmente?",it.folder,it.name,n,h)) end
    end
end
if #problems>0 and not _G.NR2003_PATCH13_FORCE then
    error("Patch Stage 13 recusado, nada foi alterado:\n  "..table.concat(problems,"\n  ")..
        "\n(_G.NR2003_PATCH13_FORCE=true instala mesmo assim, com backup do que existir)")
end
-- 2) backup of exactly the instances this patch changes (created once; a re-run keeps the first backup) ------
local backup=storage:FindFirstChild("NR2003Backup_Stage13")
local firstInstall=backup==nil
if firstInstall then
    backup=Instance.new("Folder");backup.Name="NR2003Backup_Stage13"
    backup:SetAttribute("FromStage",stage);backup:SetAttribute("FromVersion",pkg:GetAttribute("NR2003Version"))
    backup:SetAttribute("Created",os.time())
    for _,p in ipairs(plan) do
        local key=p.it.folder.."."..p.it.name
        if p.state=="add" then
            local v=Instance.new("StringValue");v.Name="ADDED:"..key;v.Value=key;v.Parent=backup
        elseif p.s then
            local c=p.s:Clone();c.Name=key;c.Parent=backup
        end
    end
    backup.Parent=storage
end
-- 3) apply (sources updated in place; new modules created) and self-tests; revert on any failure ------------
local touched={}
local function apply()
    for _,p in ipairs(plan) do
        if p.state~="current" then
            local s=p.s
            if s==nil then
                s=Instance.new(p.it.class);s.Name=p.it.name;s.Parent=FOLDERS[p.it.folder]
            end
            table.insert(touched,{s=s,old=p.state=="add" and nil or s.Source,added=p.state=="add"})
            setSource(s,p.it.source)
            assert(#s.Source==p.it.newLen and fnv(s.Source)==p.it.newHash,"fonte truncada: "..p.it.folder.."."..p.it.name)
        end
    end
    pkg:SetAttribute("NR2003Stage","13");pkg:SetAttribute("NR2003Version","3.12.0-stage13")
    for _,n in ipairs({"Stage67SelfTest","Stage8SelfTest","Stage9SelfTest","Stage10SelfTest","Stage11SelfTest","Stage12SelfTest","Stage13SelfTest"}) do
        local ok,r=require(RobloxF[n]).run(false)
        assert(ok,"self-test "..n.." falhou:\n"..table.concat(r,"\n"))
    end
end
local ok,reason=pcall(apply)
if not ok then
    for i=#touched,1,-1 do
        local t=touched[i]
        if t.added then t.s:Destroy() else setSource(t.s,t.old) end
    end
    pkg:SetAttribute("NR2003Stage",stage);pkg:SetAttribute("NR2003Version",backup:GetAttribute("FromVersion"))
    if firstInstall then backup:Destroy() end
    error("Patch Stage 13 revertido (fontes restauradas): "..tostring(reason))
end
staging:Destroy()
print("Stage 13 aplicado ("..(firstInstall and "backup: ServerStorage.NR2003Backup_Stage13" or "re-execução: backup anterior mantido")..").")
print("Force feedback ORIGINAL do NR2003: 00554d30 (estatísticas dos pneus dianteiros, por tick) -> bloco FFB do fim de quadro")
print("  00554520 (latência / amortecimento / força / relação do setup) -> força constante -1..1 (DirectInput: x10000).")
print("Padrões da bancada (Core.CupTune.driver): FFB ligado com os valores da imagem (força 80, amortecimento 0, latência 0),")
print("  dispositivo presente. O efeito só é adquirido com a direção num eixo analógico (gamepad), como no original (0054fed0).")
print("Atributos do TestCar (no reset, R): ForceFeedback true/false, ForceFeedbackStrength 0..100, ForceFeedbackDamping 0..100,")
print("  ForceFeedbackLatency 0..250 ms, ForceFeedbackDevice true/false. Saída: FFBForce, FFBMagnitude, FFBActive (atributos).")
print("O place NÃO foi salvo. Reverter: PATCH_STAGE13_ROLLBACK.lua. Auto-teste completo: require(...Roblox.Stage13SelfTest).run(true)")
