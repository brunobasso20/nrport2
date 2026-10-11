"""Build the Stage 12.1 deliverables (incremental patch over the PUBLISHED Stage 12, commit STAGE12_COMMIT):
  roblox/Stage12SelfTest.lua        Studio self-test (golden values from the ORIGINAL code, recovery/stage12) + the 12.1
                                    host-option checks (tools/selftest12_template.lua)
  PATCH_STAGE12_1.lua               single Studio Command Bar script (outside Play)
  PATCH_STAGE12_1_PART1..n.lua      the same content in Command Bar sized parts + PATCH_STAGE12_1_INSTALL.lua
  PATCH_STAGE12_1_ROLLBACK.lua      verified rollback to the published Stage 12 sources from the patch's own backup
  NR2003_Patch_Stage12_1.rbxmx      the installer as a ModuleScript (Insert from File, then
                                    require(workspace.NR2003_Patch_Stage12_1)() in the Command Bar)
Stage 12.1 = host options of the steering chain (steering lock, cockpit draw limit, momentum per input device), the
bench defaults (lock 360 deg = the original x pi, garage setup ratio 12:1, keys = image rate, axis = momentum 0, cockpit
wheel up to the lock) and the HUD sign convention. Installer policy as Stage 12 (STAGE12_RESULT.md, section E): verifies
the published Stage 12 module by module (exact byte length + FNV-1a 32 hash, or the Stage 12.1 source on a re-run),
backs up ONLY the instances it changes (ServerStorage.NR2003Backup_Stage12_1, created once, never overwritten), updates
sources IN PLACE (nothing is created, replaced or destroyed), runs the self-tests 6/7..12 and reverts by itself on any
failure. It never saves the place."""
import json, hashlib, subprocess
from pathlib import Path
from xml.sax.saxutils import escape
root = Path(__file__).resolve().parents[1]
STAGE12_COMMIT = 'b531e60'         # published Stage 12 (3.11.0-stage12): the baseline this patch verifies
STAGE12_1_COMMIT = '5d9f5ee'       # published Stage 12.1 (3.11.1-stage12.1): the sources this builder ships, frozen
VERSION = '3.11.1-stage12.1'


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
def published(path): return subprocess.run(['git', 'show', '%s:%s' % (STAGE12_COMMIT, path)], cwd=root, capture_output=True, check=True).stdout.decode('utf-8')
# Since Stage 13 the Stage 12.1 deliverables are FROZEN: the sources are read from the published Stage 12.1 commit (the
# working tree holds the Stage 13 sources, shipped by tools/build_stage13.py)
def published121(path): return subprocess.run(['git', 'show', '%s:%s' % (STAGE12_1_COMMIT, path)], cwd=root, capture_output=True, check=True).stdout.decode('utf-8')


def fnv(s):
    h = 0x811c9dc5
    for b in s.encode('utf-8'):
        h = ((h ^ b) * 0x01000193) & 0xffffffff
    return h


# ------------------------------------------------------------------ self-test golden subset (same subset as Stage 12)
def golden():
    js = root / 'recovery/stage12/fixtures_json'
    U = json.loads(read(js / 'units.json'))
    g = {}
    g['axis'] = U['axis'][::12]                         # 100 of 1200
    g['input'] = U['input'][::16]                       # 242 of 3872
    g['ratio'] = U['ratio']                             # 192
    g['tail'] = U['tail'][::12]                         # 175 of 2100
    g['linUI'] = U['setters']['linUI']
    g['momentum'] = U['setters']['momentum']
    scen = []
    for name, quick in (('keys', 4), ('linear', 4), ('ratio32', 4)):
        d = json.loads(read(js / ('%s.json' % name)))
        starts = d['start']
        pick = [starts[i] for i in range(0, len(starts), max(1, len(starts) // 16))][:16]
        scen.append(dict(name=name, steer=d['law'].get('steer'), ratio=d['law'].get('ratio'), quick=quick,
                         start=[dict(frame=s['frame'], beforeRuns=s['beforeRuns'], before=s['before'], afterRuns=s['afterRuns'],
                                     after=s['after'], controls=s['controls']) for s in pick]))
    g['scenarios'] = scen
    return lua_value(g)


template = published121('tools/selftest12_template.lua')
selftest = template.replace('__GOLDEN__', golden())
assert selftest == published121('roblox/Stage12SelfTest.lua'), 'Stage 12.1 self-test changed'
write(root / 'roblox/Stage12SelfTest.lua', selftest)
# the golden part must be exactly the published one (only the 12.1 checks are new)
assert published('roblox/Stage12SelfTest.lua').replace(published('tools/selftest12_template.lua').split('__GOLDEN__')[0], '', 1) \
    .startswith(golden()), 'Stage 12 golden subset changed'

# ------------------------------------------------------------------ what the patch changes (all replaced in place)
REPLACE = [
    ('NR2003Cup', 'NR2003CupSteering', 'core/NR2003Cup/NR2003CupSteering.lua'),
    ('Core', 'CupTune', 'core/CupTune.lua'),
    ('Roblox', 'CupChassisAdapter', 'roblox/CupChassisAdapter.lua'),
    ('Client', 'NR2003Client', 'roblox/Client.client.lua'),
    ('Roblox', 'Stage12SelfTest', 'roblox/Stage12SelfTest.lua'),
]
items = []
for folder, name, path in REPLACE:
    old, new = published(path), published121(path)
    assert old != new, '%s unchanged since Stage 12' % path
    items.append(dict(folder=folder, name=name, source=new, oldLen=len(old.encode()), oldHash=fnv(old),
                      newLen=len(new.encode()), newHash=fnv(new)))
for it in items:
    assert len(it['source']) < 199000, '%s.%s is %d characters (Script.Source limit 200000)' % (it['folder'], it['name'], len(it['source']))

# ------------------------------------------------------------------ installer
header = r'''-- PATCH_STAGE12_1 — NR2003 Roblox port, estágio 12.1 (opções da direção: trava, relação, momentum por dispositivo)
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
'''
data_def = r'''local ITEMS={}
local function item(folder,name,class,oldLen,oldHash,newLen,newHash,source)
    ITEMS[#ITEMS+1]={folder=folder,name=name,class=class,oldLen=oldLen,oldHash=oldHash,newLen=newLen,newHash=newHash,source=source}
end
'''
footer = r'''-- 1) baseline check (nothing is changed before every target is verified) -----------------------------------
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
    pkg:SetAttribute("NR2003Stage","12.1");pkg:SetAttribute("NR2003Version","__VERSION__")
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
print("Stage 12.1 aplicado ("..(firstInstall and "backup: ServerStorage.NR2003Backup_Stage12_1" or "re-execução: backup anterior mantido")..").")
print("Padrões da bancada (Core.CupTune.driver): trava 360° (180° por lado = o x pi original), relação do setup 12:1 (item 0x30 pelo")
print("  garage original; 7:1 abaixo de 20 mph pelo override original), teclas com a taxa original 0.033 por quadro, eixo/mouse")
print("  com momentum 0 (entrada direta), volante do cockpit até a trava (180°).")
print("Atributos do TestCar (no reset, R): SteeringLockDegrees (360 = original), Setup_steeringRatio 12..32, SteeringMomentumKeys /")
print("  SteeringMomentumAxis 0..100, CockpitWheelClamp \"lock\" / \"original\" (160°), e os do Stage 12 (SteeringLinearity, ...).")
print("O place NÃO foi salvo. Reverter: PATCH_STAGE12_1_ROLLBACK.lua. Auto-teste completo: require(...Roblox.Stage12SelfTest).run(true)")
'''
footer = footer.replace('__VERSION__', VERSION)


def cls_of(it): return {'Server': 'Script', 'Client': 'LocalScript'}.get(it['folder'], 'ModuleScript')


def item_line(it):
    return 'item(%s,%s,%s,%d,%d,%d,%d,%s)\n' % (json.dumps(it['folder']), json.dumps(it['name']), json.dumps(cls_of(it)),
        it['oldLen'], it['oldHash'], it['newLen'], it['newHash'], long_string(it['source']))


patch = ''.join([header, data_def] + [item_line(it) for it in items] + [footer])
write(root / 'PATCH_STAGE12_1.lua', patch)
rbx = ('<?xml version=\'1.0\' encoding=\'utf-8\'?>\n<roblox version="4">\n  <External>null</External>\n'
       '  <Item class="ModuleScript" referent="RBX_STAGE12_1">\n    <Properties>\n'
       '      <string name="Name">NR2003_Patch_Stage12_1</string>\n'
       '      <ProtectedString name="Source">' + escape('return function()\n' + patch + '\nend\n') + '</ProtectedString>\n'
       '    </Properties>\n  </Item>\n</roblox>\n')
write(root / 'NR2003_Patch_Stage12_1.rbxmx', rbx)

# ------------------------------------------------------------------ parts (Command Bar size) + INSTALL
# Parts store the item sources in ServerStorage.NR2003Stage12_1Staging (nothing else changes); INSTALL = the same header /
# checks / backup / apply as PATCH_STAGE12_1.lua, with the sources taken from the staging folder.
PART_CHARS = 180000
groups = [[]]; size = 0
for it in items:
    if groups[-1] and size + len(it['source']) > PART_CHARS: groups.append([]); size = 0
    groups[-1].append(it); size += len(it['source'])
nparts = len(groups)
for old in root.glob('PATCH_STAGE12_1_PART*.lua'): old.unlink()
for k, grp in enumerate(groups, 1):
    head = (r'''-- PATCH_STAGE12_1 parte %d/%d — NR2003 Roblox port, estágio 12.1 (instalação em partes pela Command Bar).
-- Cole as partes 1..%d em ordem (cada uma inteira, FORA do Play) e depois PATCH_STAGE12_1_INSTALL.lua.
-- As partes só guardam fontes em ServerStorage.NR2003Stage12_1Staging; nada muda no jogo até o INSTALL.
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes do patch")
local storage=game:GetService("ServerStorage")
local SES=game:GetService("ScriptEditorService")
local function setSource(s,src)
    if #src<200000 then s.Source=src else SES:UpdateSourceAsync(s,function() return src end) end
end
local staging=storage:FindFirstChild("NR2003Stage12_1Staging")
if not staging then staging=Instance.new("Folder");staging.Name="NR2003Stage12_1Staging";staging.Parent=storage end
local function stage(key,source)
    local old=staging:FindFirstChild(key);if old then old:Destroy() end
    local s=Instance.new("ModuleScript");s.Name=key;setSource(s,source);s.Parent=staging
    assert(#s.Source==#source,"fonte truncada: "..key)
end
''' % (k, nparts, nparts))
    b = [head] + ['stage(%s,%s)\n' % (json.dumps(it['folder'] + '.' + it['name']), long_string(it['source'])) for it in grp]
    b.append('print("PATCH_STAGE12_1 parte %d/%d guardada (%d fontes). Próximo: %s")\n' % (
        k, nparts, len(grp), ('parte %d' % (k + 1)) if k < nparts else 'PATCH_STAGE12_1_INSTALL.lua'))
    write(root / ('PATCH_STAGE12_1_PART%d.lua' % k), ''.join(b))
install = [header.replace('-- PATCH_STAGE12_1 — NR2003 Roblox port, estágio 12.1 (opções da direção: trava, relação, momentum por dispositivo)',
                          '-- PATCH_STAGE12_1_INSTALL — instala o que PATCH_STAGE12_1_PART1..%d guardaram em ServerStorage.NR2003Stage12_1Staging\n'
                          '-- (mesmo resultado do PATCH_STAGE12_1.lua inteiro).' % nparts),
           'local staging=assert(storage:FindFirstChild("NR2003Stage12_1Staging"),"cole antes as partes 1..%d (PATCH_STAGE12_1_PART*.lua)")\n' % nparts,
           data_def]
for it in items:
    key = it['folder'] + '.' + it['name']
    install.append('do local s=assert(staging:FindFirstChild(%s),"fonte %s ausente: cole de novo as partes")\n'
                   '    assert(#s.Source==%d,"fonte %s incompleta: cole de novo as partes")\n'
                   '    item(%s,%s,%s,%d,%d,%d,%d,s.Source) end\n' % (
                       json.dumps(key), key, it['newLen'], key, json.dumps(it['folder']), json.dumps(it['name']),
                       json.dumps(cls_of(it)), it['oldLen'], it['oldHash'], it['newLen'], it['newHash']))
install.append(footer.replace('print("Stage 12.1 aplicado', 'staging:Destroy()\nprint("Stage 12.1 aplicado'))
inst = ''.join(install)
write(root / 'PATCH_STAGE12_1_INSTALL.lua', inst)

# ------------------------------------------------------------------ rollback
rollback = r'''-- PATCH_STAGE12_1_ROLLBACK — volta a bancada para o Stage 12 publicado a partir do backup do próprio patch
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
local STAGE12={__STAGE12__}
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
'''
st12 = ['[%s]={%d,%d}' % (json.dumps(it['folder'] + '.' + it['name']), it['oldLen'], it['oldHash']) for it in items]
write(root / 'PATCH_STAGE12_1_ROLLBACK.lua', rollback.replace('__STAGE12__', ','.join(st12)))

print('Stage12SelfTest', len(selftest), 'chars')
print('PATCH_STAGE12_1.lua', len(patch), 'chars;', len(items), 'items; sha256', hashlib.sha256(patch.encode()).hexdigest()[:16])
print('parts', nparts, [len(read(root / ('PATCH_STAGE12_1_PART%d.lua' % k))) for k in range(1, nparts + 1)], 'install', len(inst))
