#!/usr/bin/env python3
"""Build the nr2003carmodel Studio deliverables (additive install over the PUBLISHED Stage 13 bench, commit STAGE13_COMMIT):
  studio/INSTALL_CARMODEL.lua          Studio Command Bar script (outside Play)
  studio/ROLLBACK_CARMODEL.lua         verified rollback to the published Stage 13 sources from the installer's own backup
  studio/NR2003_CarModel_Install.rbxmx the installer as a ModuleScript (Insert from File, then
                                       require(workspace.NR2003_CarModel_Install)() in the Command Bar)
Installs: ReplicatedStorage.NR2003Lab.CarModel (modules + empty Data / Assets folders), NR2003Lab.DrawState
(UnreliableRemoteEvent), and the two bench scripts with the car-model hooks (roblox/Bench: NR2003Client, NR2003Server).
Policy as the stage patches: verifies NR2003Stage = 13 and the two scripts byte for byte (length + FNV-1a 32 of the
published Stage 13 sources, or the car-model sources on a re-run); backs up ONLY what it changes (ServerStorage.
NR2003Backup_CarModel, created once, never overwritten; added instances recorded as ADDED markers); runs
NR2003CarModelSelfTest (code only) and reverts by itself on any failure; never saves the place; never changes the
physics modules (Core / Roblox folders) nor NR2003Stage. The converted model (descriptor + imported meshes) is installed
afterwards by the INSTALL_CARMODEL_ASSETS.lua that convert_car.py writes next to the converted package."""
import json
import subprocess
from pathlib import Path
from xml.sax.saxutils import escape

HERE = Path(__file__).resolve().parent
IMPL = HERE.parent
ROOT = IMPL.parent
STAGE13_COMMIT = 'c64ad5e'       # published Stage 13 (3.12.0-stage13): the baseline this installer verifies
VERSION = '1.0.0-carmodel'
MODULES = ['NR2003Scale', 'NR2003Gauges', 'NR2003DrawState', 'NR2003CameraSystem', 'NR2003CarModelRig',
           'NR2003CarModelClient', 'NR2003CarModelServer', 'NR2003CarModelGolden', 'NR2003CarModelSelfTest']
SCRIPTS = [('Client', 'NR2003Client', 'LocalScript', 'roblox/Client.client.lua', 'roblox/Bench/Client.client.lua'),
           ('Server', 'NR2003Server', 'Script', 'roblox/Server.server.lua', 'roblox/Bench/Server.server.lua')]


def long_string(text):
    eq = '='
    while (']' + eq + ']') in text:
        eq += '='
    return '[' + eq + '[\n' + text + ']' + eq + ']'


def read(p):
    return p.read_text(encoding='utf-8')


def write(p, s):
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(s, encoding='utf-8', newline='\n')


def published(path):
    return subprocess.run(['git', 'show', '%s:%s' % (STAGE13_COMMIT, path)], cwd=ROOT, capture_output=True,
                          check=True).stdout.decode('utf-8').replace('\r\n', '\n')


def fnv(s):
    h = 0x811c9dc5
    for b in s.encode('utf-8'):
        h = ((h ^ b) * 0x01000193) & 0xffffffff
    return h


def main():
    scripts = []
    for folder, name, cls, base, new in SCRIPTS:
        old, src = published(base), read(IMPL / new)
        assert old != src
        assert old == read(ROOT / base), '%s differs from the published Stage 13 source' % base
        scripts.append((folder, name, cls, len(old.encode()), fnv(old), len(src.encode()), fnv(src), src))
    modules = []
    for m in MODULES:
        src = read(IMPL / 'roblox' / 'CarModel' / (m + '.lua'))
        assert len(src) < 199000, m
        modules.append((m, len(src.encode()), fnv(src), src))

    header = r'''-- INSTALL_CARMODEL — NR2003 Roblox port: carro ORIGINAL do NR2003 (modelo, cockpit, instrumentos, volante, câmeras)
-- Cole na Command Bar do Studio, FORA do Play, sobre a bancada Stage 13 publicada (ou Insert from File do .rbxmx).
-- NÃO salva o place: salve você mesmo depois de conferir.
-- Novos: ReplicatedStorage.NR2003Lab.CarModel (módulos NR2003Scale, NR2003Gauges, NR2003DrawState, NR2003CameraSystem,
--   NR2003CarModelRig, NR2003CarModelClient, NR2003CarModelServer, NR2003CarModelGolden, NR2003CarModelSelfTest + pastas
--   Data e Assets vazias) e NR2003Lab.DrawState (UnreliableRemoteEvent).
-- Alterados (fonte atualizada no lugar, mesma instância): NR2003Client (StarterPlayerScripts), NR2003Server
--   (ServerScriptService) — só os ganchos opcionais do modelo; sem CarModel instalado eles se comportam como no Stage 13.
-- Física: inalterada (Core / Roblox / NR2003Stage não são tocados; o estado de desenho é só lido).
-- Segurança: confere NR2003Stage = 13 e os dois scripts byte a byte (tamanho + hash da fonte publicada), backup SÓ do que
-- muda em ServerStorage.NR2003Backup_CarModel (criado uma vez, nunca sobrescrito), re-executar é seguro, auto-teste no
-- fim e reversão automática se algo falhar. Reversão manual: ROLLBACK_CARMODEL.lua.
-- Depois: importe o modelo convertido e rode INSTALL_CARMODEL_ASSETS.lua (gerado pelo convert_car.py).
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes de instalar")
local RS=game:GetService("ReplicatedStorage")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local storage=game:GetService("ServerStorage")
local SES=game:GetService("ScriptEditorService")
local pkg=assert(RS:FindFirstChild("NR2003Lab"),"NR2003Lab ausente: instale a bancada Stage 13 antes")
local stage=pkg:GetAttribute("NR2003Stage")
assert(stage=="13","o modelo do carro exige a bancada Stage 13 (NR2003Stage = "..tostring(stage)..")")
assert(pkg:FindFirstChild("Core") and pkg.Core:FindFirstChild("CupTune"),"NR2003Lab.Core.CupTune ausente")
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
local FOLDERS={Server=SS,Client=SP}
local SCRIPTS,MODULES={},{}
local function script_(folder,name,class,oldLen,oldHash,newLen,newHash,source)
    SCRIPTS[#SCRIPTS+1]={folder=folder,name=name,class=class,oldLen=oldLen,oldHash=oldHash,newLen=newLen,newHash=newHash,source=source}
end
local function module_(name,newLen,newHash,source)
    MODULES[#MODULES+1]={name=name,newLen=newLen,newHash=newHash,source=source}
end
'''
    footer = r'''-- 1) baseline check (nothing is changed before every target is verified) -----------------------------------
local plan,problems={},{}
for _,it in ipairs(SCRIPTS) do
    local s=FOLDERS[it.folder]:FindFirstChild(it.name)
    if s==nil then table.insert(problems,it.folder.."."..it.name.." ausente (Stage 13 requerido)")
    else
        local src=s.Source;local n,h=#src,fnv(src)
        if n==it.newLen and h==it.newHash then table.insert(plan,{it=it,s=s,state="current"})
        elseif n==it.oldLen and h==it.oldHash then table.insert(plan,{it=it,s=s,state="replace"})
        else table.insert(problems,string.format("%s.%s difere do Stage 13 publicado (%d bytes, hash %08x): alterado localmente?",it.folder,it.name,n,h)) end
    end
end
if #problems>0 and not _G.NR2003_CARMODEL_FORCE then
    error("Instalação do modelo recusada, nada foi alterado:\n  "..table.concat(problems,"\n  ")..
        "\n(_G.NR2003_CARMODEL_FORCE=true instala mesmo assim, com backup do que existir)")
end
if #problems>0 then
    for _,it in ipairs(SCRIPTS) do
        local s=FOLDERS[it.folder]:FindFirstChild(it.name)
        local seen=false
        for _,p in ipairs(plan) do if p.it==it then seen=true end end
        if s and not seen then table.insert(plan,{it=it,s=s,state="replace"}) end
    end
end
-- 2) backup of exactly what this installer changes (created once; a re-run keeps the first backup) -----------
local backup=storage:FindFirstChild("NR2003Backup_CarModel")
local firstInstall=backup==nil
local folder=pkg:FindFirstChild("CarModel")
local remote=pkg:FindFirstChild("DrawState")
if firstInstall then
    backup=Instance.new("Folder");backup.Name="NR2003Backup_CarModel"
    backup:SetAttribute("FromStage",stage);backup:SetAttribute("FromVersion",pkg:GetAttribute("NR2003Version"))
    backup:SetAttribute("Created",os.time())
    for _,p in ipairs(plan) do local c=p.s:Clone();c.Name=p.it.folder.."."..p.it.name;c.Parent=backup end
    local added={}
    if folder==nil then table.insert(added,"NR2003Lab.CarModel") end
    if remote==nil then table.insert(added,"NR2003Lab.DrawState") end
    for _,k in ipairs(added) do
        local v=Instance.new("StringValue");v.Name="ADDED:"..k;v.Value=k;v.Parent=backup
    end
    backup.Parent=storage
end
-- 3) apply and self-test; revert on any failure ------------------------------------------------------------
local touched,created={},{}
local function apply()
    if folder==nil then
        folder=Instance.new("Folder");folder.Name="CarModel";folder.Parent=pkg;table.insert(created,folder)
    end
    for _,n in ipairs({"Data","Assets"}) do
        if not folder:FindFirstChild(n) then local f=Instance.new("Folder");f.Name=n;f.Parent=folder;table.insert(created,f) end
    end
    if remote==nil then
        remote=Instance.new("UnreliableRemoteEvent");remote.Name="DrawState";remote.Parent=pkg;table.insert(created,remote)
    end
    for _,m in ipairs(MODULES) do
        local s=folder:FindFirstChild(m.name)
        if s==nil then
            s=Instance.new("ModuleScript");s.Name=m.name;setSource(s,m.source);s.Parent=folder;table.insert(created,s)
        else
            table.insert(touched,{s=s,old=s.Source});setSource(s,m.source)
        end
        assert(#s.Source==m.newLen and fnv(s.Source)==m.newHash,"fonte truncada: CarModel."..m.name)
    end
    for _,p in ipairs(plan) do
        if p.state~="current" then
            table.insert(touched,{s=p.s,old=p.s.Source});setSource(p.s,p.it.source)
            assert(#p.s.Source==p.it.newLen and fnv(p.s.Source)==p.it.newHash,"fonte truncada: "..p.it.folder.."."..p.it.name)
        end
    end
    pkg:SetAttribute("NR2003CarModel","__VERSION__")
    local ok,r=require(folder.NR2003CarModelSelfTest).run(false,true)
    assert(ok,"auto-teste do modelo falhou:\n"..table.concat(r,"\n"))
end
local previous=pkg:GetAttribute("NR2003CarModel")
local ok,reason=pcall(apply)
if not ok then
    for i=#touched,1,-1 do setSource(touched[i].s,touched[i].old) end
    for i=#created,1,-1 do created[i]:Destroy() end
    pkg:SetAttribute("NR2003CarModel",previous)
    if firstInstall then backup:Destroy() end
    error("Instalação do modelo revertida (fontes restauradas): "..tostring(reason))
end
print("Modelo do carro ORIGINAL instalado (código "..(firstInstall and "novo; backup: ServerStorage.NR2003Backup_CarModel" or "re-execução: backup anterior mantido")..").")
print("Próximo passo: importe <pacote>/obj/make_a.obj pelo 3D Importer (unidade Stud, sem reescala) e rode")
print("  INSTALL_CARMODEL_ASSETS.lua (gerado pelo convert_car.py) para o descritor + o modelo importado.")
print("Sem os assets a bancada continua como no Stage 13. Atributos do TestCar: NR2003CockpitFOV (65..78), NR2003WidescreenProjection,")
print("  NR2003AnimatedSteeringWheel, NR2003Windshield, NR2003CameraShift, NR2003LiveryTexture (rbxassetid opcional).")
print("Teclas: V/B câmera +/-, Z/C olhar esq./dir., [ ] FOV. O place NÃO foi salvo. Reverter: ROLLBACK_CARMODEL.lua.")
'''.replace('__VERSION__', VERSION)
    body = [header]
    for folder, name, cls, ol, oh, nl, nh, src in scripts:
        body.append('script_(%s,%s,%s,%d,%d,%d,%d,%s)\n' % (json.dumps(folder), json.dumps(name), json.dumps(cls), ol, oh,
                                                            nl, nh, long_string(src)))
    for name, nl, nh, src in modules:
        body.append('module_(%s,%d,%d,%s)\n' % (json.dumps(name), nl, nh, long_string(src)))
    body.append(footer)
    install = ''.join(body)
    out = IMPL / 'studio'
    write(out / 'INSTALL_CARMODEL.lua', install)
    rbx = ('<?xml version=\'1.0\' encoding=\'utf-8\'?>\n<roblox version="4">\n  <External>null</External>\n'
           '  <Item class="ModuleScript" referent="RBX_CARMODEL">\n    <Properties>\n'
           '      <string name="Name">NR2003_CarModel_Install</string>\n'
           '      <ProtectedString name="Source">' + escape('return function()\n' + install + '\nend\n') +
           '</ProtectedString>\n    </Properties>\n  </Item>\n</roblox>\n')
    write(out / 'NR2003_CarModel_Install.rbxmx', rbx)

    st13 = ','.join('{folder=%s,name=%s,len=%d,hash=%d}' % (json.dumps(f), json.dumps(n), ol, oh)
                    for f, n, _, ol, oh, _, _, _ in scripts)
    rollback = r'''-- ROLLBACK_CARMODEL — volta a bancada para o Stage 13 publicado a partir do backup do próprio instalador
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
for _,e in ipairs({__STAGE13__}) do
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
'''.replace('__STAGE13__', st13)
    write(out / 'ROLLBACK_CARMODEL.lua', rollback)
    print('INSTALL_CARMODEL.lua %d chars, ROLLBACK_CARMODEL.lua %d chars' % (len(install), len(rollback)))


if __name__ == '__main__':
    main()
