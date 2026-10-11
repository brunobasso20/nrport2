"""Build the Stage 13 deliverables (incremental patch over the PUBLISHED Stage 12.1, commit STAGE12_1_COMMIT):
  roblox/Stage13SelfTest.lua        Studio self-test, golden values from the ORIGINAL code (recovery/stage13)
  PATCH_STAGE13.lua                 single Studio Command Bar script (outside Play)
  PATCH_STAGE13_PART1..n.lua        the same content in Command Bar sized parts + PATCH_STAGE13_INSTALL.lua
  PATCH_STAGE13_ROLLBACK.lua        verified rollback to the published Stage 12.1 sources from the patch's own backup
  NR2003_Patch_Stage13.rbxmx        the installer as a ModuleScript (Insert from File, then
                                    require(workspace.NR2003_Patch_Stage13)() in the Command Bar)
Stage 13 = the ORIGINAL force feedback (NR2003CupFFB: 00554d30, the FFB block of 00554520, 00550070 / 0054fed0 /
00550680, option setters; exact x87 arithmetic) + its integration (NR2003CupDriver: 00554d30 slot and the bf6eb8 gate
of 005524f0; NR2003CupFrame: the block after the lifted 00554520, 00550070(0) at car placement; NR2003CupVehicle:
install + API) + the Roblox adapter (options / device attributes, seat -> controls suspended, FFBForce output, HUD,
gamepad motors). Installer policy as Stage 12 / 12.1: verifies the published Stage 12.1 module by module (exact byte
length + FNV-1a 32 hash, or the Stage 13 source on a re-run), backs up ONLY the instances it changes (ServerStorage.
NR2003Backup_Stage13, created once, never overwritten; modules it adds are recorded as ADDED markers), updates sources
IN PLACE and creates the two new modules, runs the self-tests 6/7..13 and reverts by itself on any failure. It never
saves the place."""
import json, hashlib, subprocess, base64, struct
from pathlib import Path
from xml.sax.saxutils import escape
root = Path(__file__).resolve().parents[1]
STAGE12_1_COMMIT = '5d9f5ee'       # published Stage 12.1 (3.11.1-stage12.1): the baseline this patch verifies
VERSION = '3.12.0-stage13'


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
# the sources as the earlier patches installed them in Studio (their builders read the files with newline translation)
def published(path):
    return subprocess.run(['git', 'show', '%s:%s' % (STAGE12_1_COMMIT, path)], cwd=root, capture_output=True,
                          check=True).stdout.decode('utf-8').replace('\r\n', '\n')


def fnv(s):
    h = 0x811c9dc5
    for b in s.encode('utf-8'):
        h = ((h ^ b) * 0x01000193) & 0xffffffff
    return h


def pack(words):
    return base64.b64encode(struct.pack('<%dI' % len(words), *[w & 0xffffffff for w in words])).decode()


def unpack(s):
    b = base64.b64decode(s)
    return list(struct.unpack('<%dI' % (len(b) // 4), b))


# ------------------------------------------------------------------ self-test golden subset
def golden():
    js = root / 'recovery/stage13/fixtures_json'
    U = json.loads(read(js / 'units.json'))
    g = {}
    g['x87'] = {op: pack([w for v in U['x87'][op][::15] for w in v]) for op in ('add', 'mul', 'div')}
    g['x87']['f32'] = pack([w for v in U['x87']['f32'][::15] for w in v])
    g['stats'] = pack([w for v in U['stats'][::8] for w in v])              # 15 words per vector
    g['block'] = pack([w for v in U['block'][::10] for w in v])             # 15 words per vector
    g['controls'] = [[v['i'], v['o'], v['log']] for v in U['controls'][::8]]
    g['setters'] = [v for v in U['setters'][::4] if v[0] != 'enabled' and 0 <= v[1] <= {'latency': 250}.get(v[0], 100)]
    # the original's own calls in a closed-loop run: slalom (first 1.2 s of ticks, every 10th frame end) and the suspend /
    # device-switch windows of 'suspend'
    sl = json.loads(read(js / 'slalom.json'))
    su = json.loads(read(js / 'suspend.json'))
    st_sl, bl_sl = unpack(sl['stats']), unpack(sl['blocks'])
    st_su, bl_su = unpack(su['stats']), unpack(su['blocks'])
    rec = lambda w, n: [w[k:k + n] for k in range(0, len(w), n)]
    stats = rec(st_sl, 15)[:300] + [r for r in rec(st_su, 15) if 1712 <= r[0] < 1800 or 2300 <= r[0] < 2350 or 3740 <= r[0] < 3790]
    blocks = rec(bl_sl, 17)[::10] + [r for r in rec(bl_su, 17) if 1700 <= r[0] < 2350 or 3150 <= r[0] < 3800]
    g['tracedStats'] = pack([w for r in stats for w in r])
    g['tracedBlocks'] = pack([w for r in blocks for w in r])
    return lua_value(g)


template = read(root / 'tools/selftest13_template.lua')
selftest = template.replace('__GOLDEN__', golden())
write(root / 'roblox/Stage13SelfTest.lua', selftest)

# ------------------------------------------------------------------ what the patch changes
REPLACE = [
    ('NR2003Cup', 'NR2003CupDriver', 'core/NR2003Cup/NR2003CupDriver.lua'),
    ('NR2003Cup', 'NR2003CupFrame', 'core/NR2003Cup/NR2003CupFrame.lua'),
    ('Core', 'NR2003CupVehicle', 'core/NR2003CupVehicle.lua'),
    ('Core', 'CupTune', 'core/CupTune.lua'),
    ('Roblox', 'CupChassisAdapter', 'roblox/CupChassisAdapter.lua'),
    ('Client', 'NR2003Client', 'roblox/Client.client.lua'),
]
ADD = [
    ('NR2003Cup', 'NR2003CupFFB', 'core/NR2003Cup/NR2003CupFFB.lua'),
    ('Roblox', 'Stage13SelfTest', 'roblox/Stage13SelfTest.lua'),
]
items = []
for folder, name, path in REPLACE:
    old, new = published(path), read(root / path)
    assert old != new, '%s unchanged since Stage 12.1' % path
    items.append(dict(folder=folder, name=name, source=new, oldLen=len(old.encode()), oldHash=fnv(old),
                      newLen=len(new.encode()), newHash=fnv(new)))
for folder, name, path in ADD:
    new = read(root / path)
    items.append(dict(folder=folder, name=name, source=new, oldLen=None, oldHash=None, newLen=len(new.encode()), newHash=fnv(new)))
for it in items:
    assert len(it['source']) < 199000, '%s.%s is %d characters (Script.Source limit 200000)' % (it['folder'], it['name'], len(it['source']))

# ------------------------------------------------------------------ installer
header = r'''-- PATCH_STAGE13 — NR2003 Roblox port, estágio 13 (torque de direção / force feedback ORIGINAL do NR2003)
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
    pkg:SetAttribute("NR2003Stage","13");pkg:SetAttribute("NR2003Version","__VERSION__")
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
print("Stage 13 aplicado ("..(firstInstall and "backup: ServerStorage.NR2003Backup_Stage13" or "re-execução: backup anterior mantido")..").")
print("Force feedback ORIGINAL do NR2003: 00554d30 (estatísticas dos pneus dianteiros, por tick) -> bloco FFB do fim de quadro")
print("  00554520 (latência / amortecimento / força / relação do setup) -> força constante -1..1 (DirectInput: x10000).")
print("Padrões da bancada (Core.CupTune.driver): FFB ligado com os valores da imagem (força 80, amortecimento 0, latência 0),")
print("  dispositivo presente. O efeito só é adquirido com a direção num eixo analógico (gamepad), como no original (0054fed0).")
print("Atributos do TestCar (no reset, R): ForceFeedback true/false, ForceFeedbackStrength 0..100, ForceFeedbackDamping 0..100,")
print("  ForceFeedbackLatency 0..250 ms, ForceFeedbackDevice true/false. Saída: FFBForce, FFBMagnitude, FFBActive (atributos).")
print("O place NÃO foi salvo. Reverter: PATCH_STAGE13_ROLLBACK.lua. Auto-teste completo: require(...Roblox.Stage13SelfTest).run(true)")
'''
footer = footer.replace('__VERSION__', VERSION)


def cls_of(it): return {'Server': 'Script', 'Client': 'LocalScript'}.get(it['folder'], 'ModuleScript')


def item_line(it):
    return 'item(%s,%s,%s,%s,%s,%d,%d,%s)\n' % (json.dumps(it['folder']), json.dumps(it['name']), json.dumps(cls_of(it)),
        'nil' if it['oldLen'] is None else str(it['oldLen']), 'nil' if it['oldHash'] is None else str(it['oldHash']),
        it['newLen'], it['newHash'], long_string(it['source']))


patch = ''.join([header, data_def] + [item_line(it) for it in items] + [footer])
write(root / 'PATCH_STAGE13.lua', patch)
rbx = ('<?xml version=\'1.0\' encoding=\'utf-8\'?>\n<roblox version="4">\n  <External>null</External>\n'
       '  <Item class="ModuleScript" referent="RBX_STAGE13">\n    <Properties>\n'
       '      <string name="Name">NR2003_Patch_Stage13</string>\n'
       '      <ProtectedString name="Source">' + escape('return function()\n' + patch + '\nend\n') + '</ProtectedString>\n'
       '    </Properties>\n  </Item>\n</roblox>\n')
write(root / 'NR2003_Patch_Stage13.rbxmx', rbx)

# ------------------------------------------------------------------ parts (Command Bar size) + INSTALL
PART_CHARS = 180000
groups = [[]]; size = 0
for it in items:
    if groups[-1] and size + len(it['source']) > PART_CHARS: groups.append([]); size = 0
    groups[-1].append(it); size += len(it['source'])
nparts = len(groups)
for old in root.glob('PATCH_STAGE13_PART*.lua'): old.unlink()
for k, grp in enumerate(groups, 1):
    head = (r'''-- PATCH_STAGE13 parte %d/%d — NR2003 Roblox port, estágio 13 (instalação em partes pela Command Bar).
-- Cole as partes 1..%d em ordem (cada uma inteira, FORA do Play) e depois PATCH_STAGE13_INSTALL.lua.
-- As partes só guardam fontes em ServerStorage.NR2003Stage13Staging; nada muda no jogo até o INSTALL.
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes do patch")
local storage=game:GetService("ServerStorage")
local SES=game:GetService("ScriptEditorService")
local function setSource(s,src)
    if #src<200000 then s.Source=src else SES:UpdateSourceAsync(s,function() return src end) end
end
local staging=storage:FindFirstChild("NR2003Stage13Staging")
if not staging then staging=Instance.new("Folder");staging.Name="NR2003Stage13Staging";staging.Parent=storage end
local function stage(key,source)
    local old=staging:FindFirstChild(key);if old then old:Destroy() end
    local s=Instance.new("ModuleScript");s.Name=key;setSource(s,source);s.Parent=staging
    assert(#s.Source==#source,"fonte truncada: "..key)
end
''' % (k, nparts, nparts))
    b = [head] + ['stage(%s,%s)\n' % (json.dumps(it['folder'] + '.' + it['name']), long_string(it['source'])) for it in grp]
    b.append('print("PATCH_STAGE13 parte %d/%d guardada (%d fontes). Próximo: %s")\n' % (
        k, nparts, len(grp), ('parte %d' % (k + 1)) if k < nparts else 'PATCH_STAGE13_INSTALL.lua'))
    write(root / ('PATCH_STAGE13_PART%d.lua' % k), ''.join(b))
install = [header.replace('-- PATCH_STAGE13 — NR2003 Roblox port, estágio 13 (torque de direção / force feedback ORIGINAL do NR2003)',
                          '-- PATCH_STAGE13_INSTALL — instala o que PATCH_STAGE13_PART1..%d guardaram em ServerStorage.NR2003Stage13Staging\n'
                          '-- (mesmo resultado do PATCH_STAGE13.lua inteiro).' % nparts),
           'local staging=assert(storage:FindFirstChild("NR2003Stage13Staging"),"cole antes as partes 1..%d (PATCH_STAGE13_PART*.lua)")\n' % nparts,
           data_def]
for it in items:
    key = it['folder'] + '.' + it['name']
    install.append('do local s=assert(staging:FindFirstChild(%s),"fonte %s ausente: cole de novo as partes")\n'
                   '    assert(#s.Source==%d,"fonte %s incompleta: cole de novo as partes")\n'
                   '    item(%s,%s,%s,%s,%s,%d,%d,s.Source) end\n' % (
                       json.dumps(key), key, it['newLen'], key, json.dumps(it['folder']), json.dumps(it['name']),
                       json.dumps(cls_of(it)), 'nil' if it['oldLen'] is None else str(it['oldLen']),
                       'nil' if it['oldHash'] is None else str(it['oldHash']), it['newLen'], it['newHash']))
install.append(footer.replace('print("Stage 13 aplicado', 'staging:Destroy()\nprint("Stage 13 aplicado'))
inst = ''.join(install)
write(root / 'PATCH_STAGE13_INSTALL.lua', inst)

# ------------------------------------------------------------------ rollback
rollback = r'''-- PATCH_STAGE13_ROLLBACK — volta a bancada para o Stage 12.1 publicado a partir do backup do próprio patch
-- (ServerStorage.NR2003Backup_Stage13). Cole na Command Bar, FORA do Play. Não salva o place.
-- Restaura a fonte de cada instância alterada (mesma instância), apaga os módulos que o Stage 13 criou (NR2003CupFFB,
-- Stage13SelfTest), confere tamanho + hash de cada fonte restaurada contra o Stage 12.1 publicado e roda o auto-teste
-- Stage 12. (Para voltar ao Stage 12 depois: PATCH_STAGE12_1_ROLLBACK.lua.)
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes")
local RS=game:GetService("ReplicatedStorage")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local storage=game:GetService("ServerStorage")
local SES=game:GetService("ScriptEditorService")
local backup=assert(storage:FindFirstChild("NR2003Backup_Stage13"),"ServerStorage.NR2003Backup_Stage13 ausente: nada para reverter")
local pkg=assert(RS:FindFirstChild("NR2003Lab"),"NR2003Lab ausente")
assert(pkg:GetAttribute("NR2003Stage")=="13","a bancada não está no Stage 13")
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
local STAGE12_1={__STAGE12_1__}
-- verify the whole backup before touching anything
local restore,remove={},{}
for _,c in ipairs(backup:GetChildren()) do
    local added=string.match(c.Name,"^ADDED:(.+)$")
    local key=added or c.Name
    local folder,name=string.match(key,"^([^.]+)%.(.+)$")
    local target=FOLDERS[folder] and FOLDERS[folder]:FindFirstChild(name)
    if added then
        if target then table.insert(remove,target) end
    else
        assert(target,"instância "..c.Name.." não existe mais: restaure manualmente a cópia ServerStorage.NR2003Backup_Stage13."..c.Name)
        local want=STAGE12_1[c.Name]
        assert(want==nil or (#c.Source==want[1] and fnv(c.Source)==want[2]),"backup de "..c.Name.." não é a fonte Stage 12.1 publicada")
        table.insert(restore,{target=target,source=c.Source,key=c.Name})
    end
end
for _,r in ipairs(restore) do setSource(r.target,r.source);assert(#r.target.Source==#r.source,"fonte truncada: "..r.key) end
for _,t in ipairs(remove) do t:Destroy() end
pkg:SetAttribute("NR2003Stage",backup:GetAttribute("FromStage") or "12.1")
pkg:SetAttribute("NR2003Version",backup:GetAttribute("FromVersion"))
local ok,r=require(RobloxF.Stage12SelfTest).run(false)
assert(ok,"rollback aplicado, mas o auto-teste Stage 12 falhou:\n"..table.concat(r,"\n"))
print(string.format("Rollback Stage 13 -> Stage 12.1: %d fontes restauradas, %d módulos do Stage 13 removidos; auto-teste Stage 12 OK.",#restore,#remove))
print("O backup ServerStorage.NR2003Backup_Stage13 foi mantido (apague-o você mesmo se quiser). O place NÃO foi salvo.")
'''
st121 = ['[%s]={%d,%d}' % (json.dumps(it['folder'] + '.' + it['name']), it['oldLen'], it['oldHash']) for it in items if it['oldLen'] is not None]
write(root / 'PATCH_STAGE13_ROLLBACK.lua', rollback.replace('__STAGE12_1__', ','.join(st121)))

print('Stage13SelfTest', len(selftest), 'chars')
print('PATCH_STAGE13.lua', len(patch), 'chars;', len(items), 'items; sha256', hashlib.sha256(patch.encode()).hexdigest()[:16])
print('parts', nparts, [len(read(root / ('PATCH_STAGE13_PART%d.lua' % k))) for k in range(1, nparts + 1)], 'install', len(inst))
