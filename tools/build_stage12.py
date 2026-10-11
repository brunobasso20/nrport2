"""Build the Stage 12 deliverables from the package sources:
  roblox/Stage12SelfTest.lua      Studio self-test with golden values from the ORIGINAL code (recovery/stage12)
  PATCH_STAGE12.lua               single Studio Command Bar script (outside Play)
  PATCH_STAGE12_PART1..n.lua      the same content in Command Bar sized parts + PATCH_STAGE12_INSTALL.lua
  PATCH_STAGE12_ROLLBACK.lua      verified rollback to the Stage 11 sources from the patch's own backup
  NR2003_Patch_Stage12.rbxmx      the installer as a ModuleScript (Insert from File, then
                                  require(workspace.NR2003_Patch_Stage12)() in the Command Bar)
Installer policy (STAGE12_RESULT.md, section E): verifies the Stage 11 baseline module by module (exact byte length +
FNV-1a 32 hash of the shipped Stage 11 source, or of the Stage 12 source on a re-run), backs up ONLY the instances it
changes (ServerStorage.NR2003Backup_Stage12, created once, never overwritten), updates sources IN PLACE (no folder is
replaced, nothing is destroyed except on rollback of modules this patch added), edits the large Stage 6-11 self-tests by
one anchored line instead of re-shipping them, runs the self-tests, and reverts by itself on any failure. It never
saves the place.
Since Stage 12.1 the Stage 12 deliverables are FROZEN: every source this builder ships (and the Stage 12 self-test) is
read from the published Stage 12 commit STAGE12_COMMIT, so a rebuild reproduces the published files byte for byte and
the working tree's newer sources are shipped by tools/build_stage12_1.py (incremental 12 -> 12.1 patch)."""
import json, hashlib, subprocess, re
from pathlib import Path
from xml.sax.saxutils import escape
root = Path(__file__).resolve().parents[1]
BASE_COMMIT = '626eabe'            # Stage 11 baseline import (3.10.0-stage11)
STAGE12_COMMIT = 'b531e60'         # published Stage 12 (3.11.0-stage12): the sources this builder ships, frozen
VERSION = '3.11.0-stage12'


def long_string(text):
    eq = '='
    while (']' + eq + ']') in text: eq += '='
    return '[' + eq + '[\n' + text + ']' + eq + ']'


def lua_value(v):
    if isinstance(v, bool): return 'true' if v else 'false'
    if isinstance(v, int): return str(v)
    if isinstance(v, float):
        if v != v: return '0/0'
        return repr(v)
    if isinstance(v, str): return json.dumps(v)
    if isinstance(v, (list, tuple)): return '{' + ','.join(lua_value(x) for x in v) + '}'
    if isinstance(v, dict): return '{' + ','.join('[%s]=%s' % (k if isinstance(k, int) else json.dumps(k), lua_value(x)) for k, x in v.items()) + '}'
    if v is None: return 'nil'
    raise TypeError(v)


def read(p): return p.read_text(encoding='utf-8')
def write(p, s): p.write_text(s, encoding='utf-8', newline='\n')
def base(path): return subprocess.run(['git', 'show', '%s:%s' % (BASE_COMMIT, path)], cwd=root, capture_output=True, check=True).stdout.decode('utf-8')
def published(path): return subprocess.run(['git', 'show', '%s:%s' % (STAGE12_COMMIT, path)], cwd=root, capture_output=True, check=True).stdout.decode('utf-8')


def fnv(s):
    h = 0x811c9dc5
    for b in s.encode('utf-8'):
        h = ((h ^ b) * 0x01000193) & 0xffffffff
    return h


# ------------------------------------------------------------------ self-test (published Stage 12; its generator is now
# tools/build_stage12_1.py, which writes roblox/Stage12SelfTest.lua with the Stage 12.1 checks)
selftest = published('roblox/Stage12SelfTest.lua')

# ------------------------------------------------------------------ what the patch changes
C = root / 'core/NR2003Cup'
# (folder key, instance name, repo path, kind): kind 'module' = ModuleScript under the package, 'server' / 'client'
REPLACE = [
    ('NR2003Cup', 'NR2003CupDriver', 'core/NR2003Cup/NR2003CupDriver.lua'),
    ('Core', 'NR2003CupVehicle', 'core/NR2003CupVehicle.lua'),
    ('Roblox', 'CupChassisAdapter', 'roblox/CupChassisAdapter.lua'),
    ('Roblox', 'Cockpit', 'roblox/Cockpit.lua'),
    ('Roblox', 'RenderSnapshot', 'roblox/RenderSnapshot.lua'),
    ('Roblox', 'RenderPresentation', 'roblox/RenderPresentation.lua'),
    ('Server', 'NR2003Server', 'roblox/Server.server.lua'),
    ('Client', 'NR2003Client', 'roblox/Client.client.lua'),
]
ADD = [
    ('NR2003Cup', 'NR2003CupSteering', 'core/NR2003Cup/NR2003CupSteering.lua'),
    ('Roblox', 'Stage12SelfTest', None),
]
# one-line anchored edits of the Stage 6-11 self-tests (sources of up to 199 kB are not re-shipped)
LINE = 'if V.setSteeringMode then V.setSteeringMode("provisional") end'
EDITS = []
for name, path in (('Stage67SelfTest', 'roblox/Stage67SelfTest.lua'), ('Stage8SelfTest', 'roblox/Stage8SelfTest.lua'),
                   ('Stage9SelfTest', 'roblox/Stage9SelfTest.lua'), ('Stage10SelfTest', 'roblox/Stage10SelfTest.lua'),
                   ('Stage11SelfTest', 'roblox/Stage11SelfTest.lua')):
    old, new = base(path), published(path)
    # the single changed line: find it
    ol, nl = old.split('\n'), new.split('\n')
    assert len(ol) == len(nl), path
    diff = [(a, b) for a, b in zip(ol, nl) if a != b]
    assert len(diff) == 1, (path, len(diff))
    EDITS.append(('Roblox', name, diff[0][0], diff[0][1], len(old.encode()), fnv(old), len(new.encode()), fnv(new)))

items = []
for folder, name, path in REPLACE:
    old, new = base(path), published(path)
    items.append(dict(folder=folder, name=name, source=new, oldLen=len(old.encode()), oldHash=fnv(old),
                      newLen=len(new.encode()), newHash=fnv(new)))
for folder, name, path in ADD:
    new = selftest if path is None else published(path)
    items.append(dict(folder=folder, name=name, source=new, oldLen=None, oldHash=None, newLen=len(new.encode()), newHash=fnv(new)))
for it in items:
    assert len(it['source']) < 199000, '%s.%s is %d characters (Script.Source limit 200000)' % (it['folder'], it['name'], len(it['source']))

# ------------------------------------------------------------------ installer
header = r'''-- PATCH_STAGE12 — NR2003 Roblox port, estágio 12 (cadeia de direção ORIGINAL do NR2003 Cup)
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
'''
data_def = r'''local ITEMS={}
local function item(folder,name,class,oldLen,oldHash,newLen,newHash,source)
    ITEMS[#ITEMS+1]={folder=folder,name=name,class=class,oldLen=oldLen,oldHash=oldHash,newLen=newLen,newHash=newHash,source=source}
end
local EDITS={}
local function edit(folder,name,oldLine,newLine,oldLen,oldHash,newLen,newHash)
    EDITS[#EDITS+1]={folder=folder,name=name,oldLine=oldLine,newLine=newLine,oldLen=oldLen,oldHash=oldHash,newLen=newLen,newHash=newHash}
end
'''
footer = r'''-- 1) baseline check (nothing is changed before every target is verified) -----------------------------------
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
    pkg:SetAttribute("NR2003Stage","12");pkg:SetAttribute("NR2003Version","__VERSION__")
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
print("Stage 12 aplicado ("..(firstInstall and "backup: ServerStorage.NR2003Backup_Stage12" or "re-execução: backup anterior mantido")..").")
print("Direção ORIGINAL do NR2003: dispositivo (A/D = teclas, analógico do gamepad = eixo) -> 00552720 (taxa + seno, sensibilidade")
print("  por velocidade) -> linearidade -> x pi / relação do setup (item 0x30, 18:1; 7:1 abaixo de 20 mph) -> rampa + toe -> cubos.")
print("Atributos do TestCar (no reset, R): Setup_steeringRatio 12..32, SteeringLinearity 0..100 (controls.cfg), SteeringMomentum")
print("  0..100 (0 = sem taxa), SteeringLowSpeedOverride true/false (modo arcade e assistência: não portados, recusados). O volante do cockpit é o ângulo original.")
print("O place NÃO foi salvo. Reverter: PATCH_STAGE12_ROLLBACK.lua. Auto-teste completo: require(...Roblox.Stage12SelfTest).run(true)")
'''
footer = footer.replace('__VERSION__', VERSION)


def item_line(it):
    cls = {'Server': 'Script', 'Client': 'LocalScript'}.get(it['folder'], 'ModuleScript')
    return 'item(%s,%s,%s,%s,%s,%d,%d,%s)\n' % (json.dumps(it['folder']), json.dumps(it['name']), json.dumps(cls),
        'nil' if it['oldLen'] is None else str(it['oldLen']), 'nil' if it['oldHash'] is None else str(it['oldHash']),
        it['newLen'], it['newHash'], long_string(it['source']))


def edit_line(e):
    return 'edit(%s,%s,%s,%s,%d,%d,%d,%d)\n' % (json.dumps(e[0]), json.dumps(e[1]), long_string(e[2]), long_string(e[3]), e[4], e[5], e[6], e[7])


body = [header, data_def] + [item_line(it) for it in items] + [edit_line(e) for e in EDITS] + [footer]
patch = ''.join(body)
write(root / 'PATCH_STAGE12.lua', patch)
rbx = ('<?xml version=\'1.0\' encoding=\'utf-8\'?>\n<roblox version="4">\n  <External>null</External>\n'
       '  <Item class="ModuleScript" referent="RBX_STAGE12">\n    <Properties>\n'
       '      <string name="Name">NR2003_Patch_Stage12</string>\n'
       '      <ProtectedString name="Source">' + escape('return function()\n' + patch + '\nend\n') + '</ProtectedString>\n'
       '    </Properties>\n  </Item>\n</roblox>\n')
write(root / 'NR2003_Patch_Stage12.rbxmx', rbx)

# ------------------------------------------------------------------ parts (Command Bar size) + INSTALL
# Parts store the item sources in ServerStorage.NR2003Stage12Staging (nothing else changes); INSTALL = the same header /
# checks / backup / apply as PATCH_STAGE12.lua, with the sources taken from the staging folder.
PART_CHARS = 180000
groups = [[]]; size = 0
for it in items:
    if groups[-1] and size + len(it['source']) > PART_CHARS: groups.append([]); size = 0
    groups[-1].append(it); size += len(it['source'])
nparts = len(groups)
for old in root.glob('PATCH_STAGE12_PART*.lua'): old.unlink()
for k, grp in enumerate(groups, 1):
    head = (r'''-- PATCH_STAGE12 parte %d/%d — NR2003 Roblox port, estágio 12 (instalação em partes pela Command Bar).
-- Cole as partes 1..%d em ordem (cada uma inteira, FORA do Play) e depois PATCH_STAGE12_INSTALL.lua.
-- As partes só guardam fontes em ServerStorage.NR2003Stage12Staging; nada muda no jogo até o INSTALL.
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes do patch")
local storage=game:GetService("ServerStorage")
local SES=game:GetService("ScriptEditorService")
local function setSource(s,src)
    if #src<200000 then s.Source=src else SES:UpdateSourceAsync(s,function() return src end) end
end
local staging=storage:FindFirstChild("NR2003Stage12Staging")
if not staging then staging=Instance.new("Folder");staging.Name="NR2003Stage12Staging";staging.Parent=storage end
local function stage(key,source)
    local old=staging:FindFirstChild(key);if old then old:Destroy() end
    local s=Instance.new("ModuleScript");s.Name=key;setSource(s,source);s.Parent=staging
    assert(#s.Source==#source,"fonte truncada: "..key)
end
''' % (k, nparts, nparts))
    b = [head] + ['stage(%s,%s)\n' % (json.dumps(it['folder'] + '.' + it['name']), long_string(it['source'])) for it in grp]
    b.append('print("PATCH_STAGE12 parte %d/%d guardada (%d fontes). Próximo: %s")\n' % (
        k, nparts, len(grp), ('parte %d' % (k + 1)) if k < nparts else 'PATCH_STAGE12_INSTALL.lua'))
    write(root / ('PATCH_STAGE12_PART%d.lua' % k), ''.join(b))
install = [header.replace('-- PATCH_STAGE12 — NR2003 Roblox port, estágio 12 (cadeia de direção ORIGINAL do NR2003 Cup)',
                          '-- PATCH_STAGE12_INSTALL — instala o que PATCH_STAGE12_PART1..%d guardaram em ServerStorage.NR2003Stage12Staging\n'
                          '-- (mesmo resultado do PATCH_STAGE12.lua inteiro).' % nparts),
           'local staging=assert(storage:FindFirstChild("NR2003Stage12Staging"),"cole antes as partes 1..%d (PATCH_STAGE12_PART*.lua)")\n' % nparts,
           data_def]
for it in items:
    key = it['folder'] + '.' + it['name']
    install.append('do local s=assert(staging:FindFirstChild(%s),"fonte %s ausente: cole de novo as partes")\n'
                   '    assert(#s.Source==%d,"fonte %s incompleta: cole de novo as partes")\n'
                   '    item(%s,%s,%s,%s,%s,%d,%d,s.Source) end\n' % (
                       json.dumps(key), key, it['newLen'], key, json.dumps(it['folder']), json.dumps(it['name']),
                       json.dumps({'Server': 'Script', 'Client': 'LocalScript'}.get(it['folder'], 'ModuleScript')),
                       'nil' if it['oldLen'] is None else str(it['oldLen']), 'nil' if it['oldHash'] is None else str(it['oldHash']),
                       it['newLen'], it['newHash']))
install += [edit_line(e) for e in EDITS]
install.append(footer.replace('print("Stage 12 aplicado', 'staging:Destroy()\nprint("Stage 12 aplicado'))
inst = ''.join(install)
write(root / 'PATCH_STAGE12_INSTALL.lua', inst)

# ------------------------------------------------------------------ rollback
rollback = r'''-- PATCH_STAGE12_ROLLBACK — volta a bancada para o Stage 11 a partir do backup do próprio patch
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
local STAGE11={__STAGE11__}
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
'''
st11 = []
for it in items:
    if it['oldLen'] is not None: st11.append('[%s]={%d,%d}' % (json.dumps(it['folder'] + '.' + it['name']), it['oldLen'], it['oldHash']))
for e in EDITS: st11.append('[%s]={%d,%d}' % (json.dumps(e[0] + '.' + e[1]), e[4], e[5]))
write(root / 'PATCH_STAGE12_ROLLBACK.lua', rollback.replace('__STAGE11__', ','.join(st11)))

print('Stage12SelfTest', len(selftest), 'chars')
print('PATCH_STAGE12.lua', len(patch), 'chars;', len(items), 'items +', len(EDITS), 'edits; sha256', hashlib.sha256(patch.encode()).hexdigest()[:16])
print('parts', nparts, [len(read(root / ('PATCH_STAGE12_PART%d.lua' % k))) for k in range(1, nparts + 1)], 'install', len(inst))
