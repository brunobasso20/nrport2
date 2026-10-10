-- PATCH_STAGE12_INSTALL — instala o que PATCH_STAGE12_PART1..2 guardaram em ServerStorage.NR2003Stage12Staging
-- (mesmo resultado do PATCH_STAGE12.lua inteiro).
-- Cole na Command Bar do Studio, FORA do Play, sobre a bancada Stage 11 (ou Insert from File do .rbxmx; ou as partes +
-- INSTALL). O patch NÃO salva o place: salve você mesmo depois de conferir.
-- Novos: Core.NR2003Cup.NR2003CupSteering (00552720 / 00551e80 / 00554fb0 / setters do executável), Roblox.Stage12SelfTest.
-- Alterados (fonte atualizada no lugar, mesma instância): Core.NR2003Cup.NR2003CupDriver, Core.NR2003CupVehicle,
-- Roblox.CupChassisAdapter, Roblox.Cockpit, Roblox.RenderSnapshot, Roblox.RenderPresentation, NR2003Server, NR2003Client;
-- uma linha em Roblox.Stage67/8/9/10/11SelfTest (modo de direção "provisional" das suítes antigas).
-- Segurança: confere o Stage 11 módulo por módulo (tamanho + hash da fonte publicada), backup SÓ do que muda em
-- ServerStorage.NR2003Backup_Stage12 (criado uma vez, nunca sobrescrito), nenhuma pasta é substituída, re-executar é
-- seguro, auto-testes 6/7..12 no fim e reversão automática se algo falhar. Reversão manual: PATCH_STAGE12_ROLLBACK.lua.
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes do patch")
local RS=game:GetService("ReplicatedStorage")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local storage=game:GetService("ServerStorage")
local SES=game:GetService("ScriptEditorService")
local pkg=assert(RS:FindFirstChild("NR2003Lab"),"NR2003Lab ausente: instale a bancada Stage 11 antes")
local stage=pkg:GetAttribute("NR2003Stage")
assert(stage=="11" or stage=="12","este patch exige a bancada Stage 11 (NR2003Stage = "..tostring(stage)..")")
local CoreF=assert(pkg:FindFirstChild("Core"),"NR2003Lab.Core ausente")
local RobloxF=assert(pkg:FindFirstChild("Roblox"),"NR2003Lab.Roblox ausente")
local cupFolder=assert(CoreF:FindFirstChild("NR2003Cup"),"Core.NR2003Cup ausente")
for _,n in ipairs({"NR2003CupCore","NR2003CupFrame","NR2003CupGarage","NR2003CupBuild","NR2003CupAero"}) do
    assert(cupFolder:FindFirstChild(n),"Core.NR2003Cup."..n.." ausente (Stage 11 requerido)")
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
local staging=assert(storage:FindFirstChild("NR2003Stage12Staging"),"cole antes as partes 1..2 (PATCH_STAGE12_PART*.lua)")
local ITEMS={}
local function item(folder,name,class,oldLen,oldHash,newLen,newHash,source)
    ITEMS[#ITEMS+1]={folder=folder,name=name,class=class,oldLen=oldLen,oldHash=oldHash,newLen=newLen,newHash=newHash,source=source}
end
local EDITS={}
local function edit(folder,name,oldLine,newLine,oldLen,oldHash,newLen,newHash)
    EDITS[#EDITS+1]={folder=folder,name=name,oldLine=oldLine,newLine=newLine,oldLen=oldLen,oldHash=oldHash,newLen=newLen,newHash=newHash}
end
do local s=assert(staging:FindFirstChild("NR2003Cup.NR2003CupDriver"),"fonte NR2003Cup.NR2003CupDriver ausente: cole de novo as partes")
    assert(#s.Source==24430,"fonte NR2003Cup.NR2003CupDriver incompleta: cole de novo as partes")
    item("NR2003Cup","NR2003CupDriver","ModuleScript",22394,857451009,24430,3703462688,s.Source) end
do local s=assert(staging:FindFirstChild("Core.NR2003CupVehicle"),"fonte Core.NR2003CupVehicle ausente: cole de novo as partes")
    assert(#s.Source==9070,"fonte Core.NR2003CupVehicle incompleta: cole de novo as partes")
    item("Core","NR2003CupVehicle","ModuleScript",7925,3736862230,9070,588044759,s.Source) end
do local s=assert(staging:FindFirstChild("Roblox.CupChassisAdapter"),"fonte Roblox.CupChassisAdapter ausente: cole de novo as partes")
    assert(#s.Source==31749,"fonte Roblox.CupChassisAdapter incompleta: cole de novo as partes")
    item("Roblox","CupChassisAdapter","ModuleScript",28501,1352800795,31749,2139380016,s.Source) end
do local s=assert(staging:FindFirstChild("Roblox.Cockpit"),"fonte Roblox.Cockpit ausente: cole de novo as partes")
    assert(#s.Source==4459,"fonte Roblox.Cockpit incompleta: cole de novo as partes")
    item("Roblox","Cockpit","ModuleScript",3958,2216434014,4459,1431653166,s.Source) end
do local s=assert(staging:FindFirstChild("Roblox.RenderSnapshot"),"fonte Roblox.RenderSnapshot ausente: cole de novo as partes")
    assert(#s.Source==6198,"fonte Roblox.RenderSnapshot incompleta: cole de novo as partes")
    item("Roblox","RenderSnapshot","ModuleScript",6072,1355566575,6198,607194288,s.Source) end
do local s=assert(staging:FindFirstChild("Roblox.RenderPresentation"),"fonte Roblox.RenderPresentation ausente: cole de novo as partes")
    assert(#s.Source==2986,"fonte Roblox.RenderPresentation incompleta: cole de novo as partes")
    item("Roblox","RenderPresentation","ModuleScript",2853,417927731,2986,27795961,s.Source) end
do local s=assert(staging:FindFirstChild("Server.NR2003Server"),"fonte Server.NR2003Server ausente: cole de novo as partes")
    assert(#s.Source==4742,"fonte Server.NR2003Server incompleta: cole de novo as partes")
    item("Server","NR2003Server","Script",4009,1117744807,4742,3952310422,s.Source) end
do local s=assert(staging:FindFirstChild("Client.NR2003Client"),"fonte Client.NR2003Client ausente: cole de novo as partes")
    assert(#s.Source==15162,"fonte Client.NR2003Client incompleta: cole de novo as partes")
    item("Client","NR2003Client","LocalScript",14210,2653526811,15162,3085570735,s.Source) end
do local s=assert(staging:FindFirstChild("NR2003Cup.NR2003CupSteering"),"fonte NR2003Cup.NR2003CupSteering ausente: cole de novo as partes")
    assert(#s.Source==17974,"fonte NR2003Cup.NR2003CupSteering incompleta: cole de novo as partes")
    item("NR2003Cup","NR2003CupSteering","ModuleScript",nil,nil,17974,3924890501,s.Source) end
do local s=assert(staging:FindFirstChild("Roblox.Stage12SelfTest"),"fonte Roblox.Stage12SelfTest ausente: cole de novo as partes")
    assert(#s.Source==190846,"fonte Roblox.Stage12SelfTest incompleta: cole de novo as partes")
    item("Roblox","Stage12SelfTest","ModuleScript",nil,nil,190846,1567202851,s.Source) end
edit("Roblox","Stage67SelfTest",[=[
if V.setRuntimeMode then V.setRuntimeMode("frozen") end]=],[=[
if V.setRuntimeMode then V.setRuntimeMode("frozen") end if V.setSteeringMode then V.setSteeringMode("provisional") end]=],60457,511586509,60520,2889733461)
edit("Roblox","Stage8SelfTest",[=[
if V.setRuntimeMode then V.setRuntimeMode("frozen") end]=],[=[
if V.setRuntimeMode then V.setRuntimeMode("frozen") end if V.setSteeringMode then V.setSteeringMode("provisional") end]=],188240,3860612614,188303,1091763942)
edit("Roblox","Stage9SelfTest",[=[
if V.setRuntimeMode then V.setRuntimeMode("frozen") end]=],[=[
if V.setRuntimeMode then V.setRuntimeMode("frozen") end if V.setSteeringMode then V.setSteeringMode("provisional") end]=],186234,766859960,186297,3003201880)
edit("Roblox","Stage10SelfTest",[=[
if V.setRuntimeMode then V.setRuntimeMode("frozen") end]=],[=[
if V.setRuntimeMode then V.setRuntimeMode("frozen") end if V.setSteeringMode then V.setSteeringMode("provisional") end]=],198519,2781813066,198582,1233186362)
edit("Roblox","Stage11SelfTest",[=[
    V.setRuntimeMode("original");V.endSession();V.reset()]=],[=[
    V.setRuntimeMode("original");if V.setSteeringMode then V.setSteeringMode("provisional") end;V.endSession();V.reset()]=],172423,250092584,172486,1527985883)
-- 1) baseline check (nothing is changed before every target is verified) -----------------------------------
local plan,problems={},{}
for _,it in ipairs(ITEMS) do
    local s=find(it.folder,it.name)
    if s==nil then
        if it.oldLen~=nil then table.insert(problems,it.folder.."."..it.name.." ausente") else table.insert(plan,{it=it,state="add"}) end
    else
        local src=s.Source;local n,h=#src,fnv(src)
        if n==it.newLen and h==it.newHash then table.insert(plan,{it=it,s=s,state="current"})
        elseif it.oldLen~=nil and n==it.oldLen and h==it.oldHash then table.insert(plan,{it=it,s=s,state="replace"})
        elseif it.oldLen==nil then table.insert(plan,{it=it,s=s,state="replace"})  -- a module this patch adds (re-run)
        else table.insert(problems,string.format("%s.%s difere do Stage 11 publicado (%d bytes, hash %08x): alterado localmente?",it.folder,it.name,n,h)) end
    end
end
for _,e in ipairs(EDITS) do
    local s=find(e.folder,e.name)
    if s==nil then table.insert(problems,e.folder.."."..e.name.." ausente") else
        local src=s.Source;local n,h=#src,fnv(src)
        if n==e.newLen and h==e.newHash then table.insert(plan,{edit=e,s=s,state="current"})
        elseif n==e.oldLen and h==e.oldHash and string.find(src,e.oldLine,1,true) then
            table.insert(plan,{edit=e,s=s,state="edit"})
        else table.insert(problems,string.format("%s.%s difere do Stage 11 publicado (%d bytes, hash %08x)",e.folder,e.name,n,h)) end
    end
end
if #problems>0 and not _G.NR2003_PATCH12_FORCE then
    error("Patch Stage 12 recusado, nada foi alterado:\n  "..table.concat(problems,"\n  ")..
        "\n(_G.NR2003_PATCH12_FORCE=true instala mesmo assim, com backup do que existir)")
end
-- 2) backup of exactly the instances this patch changes (created once; a re-run keeps the first backup) ------
local backup=storage:FindFirstChild("NR2003Backup_Stage12")
local firstInstall=backup==nil
if firstInstall then
    backup=Instance.new("Folder");backup.Name="NR2003Backup_Stage12"
    backup:SetAttribute("FromStage",stage);backup:SetAttribute("FromVersion",pkg:GetAttribute("NR2003Version"))
    backup:SetAttribute("Created",os.time())
    for _,p in ipairs(plan) do
        local key=(p.it and p.it.folder or p.edit.folder).."."..(p.it and p.it.name or p.edit.name)
        if p.s then
            local c=p.s:Clone();c.Name=key;c.Parent=backup
        else
            local v=Instance.new("StringValue");v.Name="ADDED:"..key;v.Value=key;v.Parent=backup
        end
    end
    backup.Parent=storage
end
-- 3) apply (sources updated in place; new modules created) and self-tests; revert on any failure ------------
local touched={}
local function apply()
    for _,p in ipairs(plan) do
        if p.it and p.state~="current" then
            local s=p.s
            if s==nil then
                s=Instance.new(p.it.class);s.Name=p.it.name;s.Parent=FOLDERS[p.it.folder]
            end
            table.insert(touched,{s=s,old=p.state=="add" and nil or s.Source,added=p.state=="add"})
            setSource(s,p.it.source)
            assert(#s.Source==p.it.newLen and fnv(s.Source)==p.it.newHash,"fonte truncada: "..p.it.folder.."."..p.it.name)
        elseif p.edit and p.state=="edit" then
            local s=p.s;local src=s.Source
            local i,j=string.find(src,p.edit.oldLine,1,true)
            local new=string.sub(src,1,i-1)..p.edit.newLine..string.sub(src,j+1)
            table.insert(touched,{s=s,old=src})
            setSource(s,new)
            assert(#s.Source==p.edit.newLen and fnv(s.Source)==p.edit.newHash,"edição incompleta: "..p.edit.folder.."."..p.edit.name)
        end
    end
    pkg:SetAttribute("NR2003Stage","12");pkg:SetAttribute("NR2003Version","3.11.0-stage12")
    for _,n in ipairs({"Stage67SelfTest","Stage8SelfTest","Stage9SelfTest","Stage10SelfTest","Stage11SelfTest","Stage12SelfTest"}) do
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
    error("Patch Stage 12 revertido (fontes restauradas): "..tostring(reason))
end
staging:Destroy()
print("Stage 12 aplicado ("..(firstInstall and "backup: ServerStorage.NR2003Backup_Stage12" or "re-execução: backup anterior mantido")..").")
print("Direção ORIGINAL do NR2003: dispositivo (A/D = teclas, analógico do gamepad = eixo) -> 00552720 (taxa + seno, sensibilidade")
print("  por velocidade) -> linearidade -> x pi / relação do setup (item 0x30, 18:1; 7:1 abaixo de 20 mph) -> rampa + toe -> cubos.")
print("Atributos do TestCar (no reset, R): Setup_steeringRatio 12..32, SteeringLinearity 0..100 (controls.cfg), SteeringMomentum")
print("  0..100 (0 = sem taxa), SteeringLowSpeedOverride true/false, SteeringYawLimiter. O volante do cockpit é o ângulo original.")
print("O place NÃO foi salvo. Reverter: PATCH_STAGE12_ROLLBACK.lua. Auto-teste completo: require(...Roblox.Stage12SelfTest).run(true)")
