"""Build the Stage 11 deliverables from the package sources:
  roblox/Stage11SelfTest.lua     Studio self-test with golden values from the original code (scenario 'cold')
  PATCH_STAGE11.lua              single Studio Command Bar script (outside Play)
  PATCH_STAGE11_PART1..n.lua     the same modules in Command Bar sized parts + PATCH_STAGE11_INSTALL.lua
  NR2003_Patch_Stage11.rbxmx     same installer as a ModuleScript (Insert from File, then
                                 require(workspace.NR2003_Patch_Stage11)() in the Command Bar)
The patch updates an installed, validated Stage 10 bench IN PLACE (backup first, revert on error)."""
import json, hashlib, base64
from pathlib import Path
from xml.sax.saxutils import escape
root = Path(__file__).resolve().parents[1]


def long_string(text):
    eq = '='
    while (']' + eq + ']') in text: eq += '='
    return '[' + eq + '[\n' + text + ']' + eq + ']'


def lua_value(v):
    if isinstance(v, bool): return 'true' if v else 'false'
    if isinstance(v, int): return str(v)
    if isinstance(v, float): return repr(v) if v == v else '0/0'
    if isinstance(v, str): return json.dumps(v)
    if isinstance(v, (list, tuple)): return '{' + ','.join(lua_value(x) for x in v) + '}'
    if isinstance(v, dict): return '{' + ','.join('[%s]=%s' % (k if isinstance(k, int) else json.dumps(k), lua_value(x)) for k, x in v.items()) + '}'
    if v is None: return 'nil'
    raise TypeError(v)


def read(p): return p.read_text(encoding='utf-8')
def write(p, s): p.write_text(s, encoding='utf-8', newline='\n')


# ------------------------------------------------------------------ self-test golden subset (scenario 'cold')
def footprint():
    """runs and row fields of tests/stage11/fixtures/footprint.lua (written by recovery/stage11/gen_fixtures11.py)"""
    import re
    fp = read(root / 'tests/stage11/fixtures/footprint.lua')
    def runs(key):
        m = re.search(r'\["%s"\]=\{((?:\{\d+,\d+\},?)*)\}' % key, fp)
        return [[int(a), int(n)] for a, n in re.findall(r'\{(\d+),(\d+)\}', m.group(1))]
    fields = re.findall(r'"([A-Za-z0-9_]+)"', re.search(r'\["fields"\]=\{([^}]*)\}', fp).group(1))
    return runs('touchRuns'), runs('writeRuns'), fields


def golden():
    doc = json.loads(read(root / 'recovery/stage11/fixtures_json/cold.json'))
    law = doc['law']
    assert law['session']['temperature'] == 40 and law['options'] == {'damage_level': 0}
    # the inlined law of the self-test is scenarios11.law_launch: check it against the fixture's control table
    for k, c in enumerate(law['controls']):
        t = k / 36
        want = [1.0 if t < 30 else 0.0, 1.0, 0.0, 1.0 if 30 <= t < 36 else 0.0, k in (40, 110, 200), False]
        assert c == want, (k, c, want)
    TOUCH_RUNS, WRITE_RUNS, ROW_FIELDS = footprint()
    assert len(ROW_FIELDS) == 60 and 0 < sum(n for _, n in WRITE_RUNS) < sum(n for _, n in TOUCH_RUNS)
    sync = [s for s in doc['sync'] if s['kind'] == 'frame' and s['frame'] == 120]
    assert len(sync) == 1
    idx = {f: i + 1 for i, f in enumerate(ROW_FIELDS)}
    r18 = doc['rows'][1]
    assert r18[0] == 18
    row18 = [r18[idx[f]] for f in ('fuel', 'water', 'oil', 'surfaceMid2', 'carcassMid2', 'brake0', 'x', 'vx', 'z')]
    g = ['{', 'touchRuns=' + lua_value(TOUCH_RUNS) + ',', 'writeRuns=' + lua_value(WRITE_RUNS) + ',',
         'start=' + json.dumps(doc['start']) + ',', 'before=' + json.dumps(sync[0]['before']) + ',',
         'after=' + json.dumps(sync[0]['after']) + ',', 'row18=' + lua_value(row18), '}']
    return '\n'.join(g)


template = read(root / 'tools/selftest11_template.lua')
selftest = template.replace('__GOLDEN__', golden())
write(root / 'roblox/Stage11SelfTest.lua', selftest)

# ------------------------------------------------------------------ module list
C = root / 'core/NR2003Cup'
names = (['NR2003CupFrame'] + sorted(p.stem for p in C.glob('NR2003CupFrameCode*.lua')) +
         sorted(p.stem for p in C.glob('NR2003CupFrameData*.lua')) + ['NR2003CupDriver'])
modules = [('NR2003Cup', n, read(C / (n + '.lua'))) for n in names]
modules += [('Core', 'NR2003CupVehicle', read(root / 'core/NR2003CupVehicle.lua')),
            ('Roblox', 'CupChassisAdapter', read(root / 'roblox/CupChassisAdapter.lua'))]
modules += [('Roblox', n, read(root / ('roblox/%s.lua' % n)))
            for n in ('Stage67SelfTest', 'Stage8SelfTest', 'Stage9SelfTest', 'Stage10SelfTest')]
modules += [('Roblox', 'Stage11SelfTest', selftest)]
for folder, name, src in modules:
    assert len(src) < 199000, '%s.%s is %d characters (Script.Source limit 200000)' % (folder, name, len(src))
client = read(root / 'roblox/Client.client.lua')
assert not client.startswith('﻿')

header = r'''-- PATCH_STAGE11 — NR2003 Roblox port, estágio 11 (térmico / desgaste / dano / combustível do NR2003 Cup)
-- Recomendado: Insert from File de NR2003_Patch_Stage11.rbxmx (arquivo grande). Alternativa: cole este arquivo INTEIRO na
-- Command Bar do Studio, FORA do Play, sobre a bancada Stage 10 validada (ou as partes + INSTALL).
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
'''
module_def = r'''local MODULES={}
local function module(folder,name,source) MODULES[#MODULES+1]={folder,name,source} end
'''
footer = r'''-- backup (complete copies) -------------------------------------------------------------
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
        local s=Instance.new("ModuleScript");s.Name=name
        setSource(s,source);s.Parent=parent
        assert(#s.Source==#source,"fonte truncada: "..folder.."."..name)
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
print("Stage 11 aplicado. Backup: ServerStorage."..backup.Name)
print("Runtime original por quadro: combustível (massa/inércia), motor (água/óleo/níveis/potência/desgaste/falha), pneus (3 zonas,")
print("  pressão, desgaste, aderência, estouro), freios (temperatura), falhas aleatórias e dano de colisão — tudo do NR2003.exe.")
print("Atributos do TestCar (aplicados ao reiniciar, R): RaceDamageLevel 0..3 (0 = sem dano), RaceConsumptionRate 0..3 (x1..x4),")
print("  RosterSeries, RandomSeed, Stage11Runtime=\"frozen\" (A/B: fim de quadro dos estágios 6-10). TESTE: DamageTestImpact=<magnitude>,")
print("  PitTyresTest=true. Painel T: linha COMB / água / óleo / pot / dano / pneus / freios.")
print("Play > F entrar | W/S acel/freio | A/D direção | E/Q marchas | R reinicia | T painel")
'''
body = [header, module_def]
for folder, name, src in modules:
    body.append('module(%s,%s,%s)\n' % (json.dumps(folder), json.dumps(name), long_string(src)))
body.append('local clientSource=' + long_string(client) + '\n')
body.append(footer)
patch = ''.join(body)
write(root / 'PATCH_STAGE11.lua', patch)
rbx = ('<?xml version=\'1.0\' encoding=\'utf-8\'?>\n<roblox version="4">\n  <External>null</External>\n'
       '  <Item class="ModuleScript" referent="RBX_STAGE11">\n    <Properties>\n'
       '      <string name="Name">NR2003_Patch_Stage11</string>\n'
       '      <ProtectedString name="Source">' + escape('return function()\n' + patch + '\nend\n') + '</ProtectedString>\n'
       '    </Properties>\n  </Item>\n</roblox>\n')
write(root / 'NR2003_Patch_Stage11.rbxmx', rbx)
print('PATCH_STAGE11.lua', len(patch), 'chars;', len(modules), 'modules + client; selftest', len(selftest),
      'chars; sha256', hashlib.sha256(patch.encode()).hexdigest()[:16])

# ------------------------------------------------------------------ split install (Command Bar in parts)
# Same modules as PATCH_STAGE11.lua: parts 1..N only store the sources (and the client source) in
# ServerStorage.NR2003Stage11Staging; PATCH_STAGE11_INSTALL.lua checks every staged source and installs exactly like
# PATCH_STAGE11.lua (backup, self-tests, revert).
PART_CHARS = 650000
items = modules + [('Client', 'NR2003Client', client)]
groups = [[]]; size = 0
for m in items:
    if groups[-1] and size + len(m[2]) > PART_CHARS: groups.append([]); size = 0
    groups[-1].append(m); size += len(m[2])
nparts = len(groups)
for old in root.glob('PATCH_STAGE11_PART*.lua'): old.unlink()
expect = []
for k, grp in enumerate(groups, 1):
    head = (r'''-- PATCH_STAGE11 parte %d/%d — NR2003 Roblox port, estágio 11 (instalação em partes pela Command Bar).
-- Cole as partes 1..%d em ordem (cada uma inteira, FORA do Play) e depois PATCH_STAGE11_INSTALL.lua.
-- As partes só guardam fontes em ServerStorage.NR2003Stage11Staging; nada muda no jogo até o INSTALL.
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes do patch")
local storage=game:GetService("ServerStorage")
local SES=game:GetService("ScriptEditorService")
local function setSource(s,src)
    if #src<200000 then s.Source=src else SES:UpdateSourceAsync(s,function() return src end) end
end
local staging=storage:FindFirstChild("NR2003Stage11Staging")
if not staging then staging=Instance.new("Folder");staging.Name="NR2003Stage11Staging";staging.Parent=storage end
local function module(folder,name,source)
    local f=staging:FindFirstChild(folder)
    if not f then f=Instance.new("Folder");f.Name=folder;f.Parent=staging end
    local old=f:FindFirstChild(name);if old then old:Destroy() end
    local s=Instance.new("ModuleScript");s.Name=name;setSource(s,source);s.Parent=f
    assert(#s.Source==#source,"fonte truncada: "..folder.."."..name)
end
''' % (k, nparts, nparts))
    body_k = [head]
    for folder, name, src in grp:
        body_k.append('module(%s,%s,%s)\n' % (json.dumps(folder), json.dumps(name), long_string(src)))
        expect.append((folder, name, len(src.encode('utf-8')), k))   # Luau #Source counts bytes
    body_k.append('print("PATCH_STAGE11 parte %d/%d guardada (%d módulos). Próximo: %s")\n' % (
        k, nparts, len(grp), ('parte %d' % (k + 1)) if k < nparts else 'PATCH_STAGE11_INSTALL.lua'))
    write(root / ('PATCH_STAGE11_PART%d.lua' % k), ''.join(body_k))
install_head = header.replace(
    '-- PATCH_STAGE11 — NR2003 Roblox port, estágio 11 (térmico / desgaste / dano / combustível do NR2003 Cup)',
    '-- PATCH_STAGE11_INSTALL — NR2003 Roblox port, estágio 11: instala o que as partes 1..%d guardaram em\n'
    '-- ServerStorage.NR2003Stage11Staging (mesmo resultado do PATCH_STAGE11.lua inteiro). Cole na Command Bar, FORA do\n'
    '-- Play, depois das partes. Se algo falhar, tudo é revertido e as partes guardadas continuam lá (repita só o INSTALL).' % nparts).replace(
    '''-- Recomendado: Insert from File de NR2003_Patch_Stage11.rbxmx (arquivo grande). Alternativa: cole este arquivo INTEIRO na
-- Command Bar do Studio, FORA do Play, sobre a bancada Stage 10 validada (ou as partes + INSTALL).
''', '')
assert 'Recomendado' not in install_head
install = [install_head,
           'local staging=assert(storage:FindFirstChild("NR2003Stage11Staging"),"cole antes as partes 1..%d (PATCH_STAGE11_PART*.lua)")\n' % nparts,
           'local EXPECT={\n']
for folder, name, n, k in expect:
    install.append('    {%s,%s,%d,%d},\n' % (json.dumps(folder), json.dumps(name), n, k))
install.append('}\n')
install.append(r'''local MODULES={}
local clientSource
for _,e in ipairs(EXPECT) do
    local f=staging:FindFirstChild(e[1]);local s=f and f:FindFirstChild(e[2])
    assert(s and #s.Source==e[3],"módulo "..e[1].."."..e[2].." ausente ou incompleto: cole de novo a parte "..e[4])
    if e[1]=="Client" then clientSource=s.Source else MODULES[#MODULES+1]={e[1],e[2],s} end
end
assert(clientSource,"fonte do NR2003Client ausente")
''')
footer_install = footer.replace(
    '''        local s=Instance.new("ModuleScript");s.Name=name
        setSource(s,source);s.Parent=parent
        assert(#s.Source==#source,"fonte truncada: "..folder.."."..name)''',
    '''        local s=source:Clone();s.Name=name;s.Parent=parent
        assert(s.Source==source.Source,"fonte truncada: "..folder.."."..name)''').replace(
    'print("Stage 11 aplicado. Backup: ServerStorage."..backup.Name)',
    'staging:Destroy()\nprint("Stage 11 aplicado. Backup: ServerStorage."..backup.Name)')
install.append(footer_install)
inst = ''.join(install)
assert 'source:Clone()' in inst and 'staging:Destroy()' in inst
write(root / 'PATCH_STAGE11_INSTALL.lua', inst)
print('split install:', nparts, 'parts', [len((root / ('PATCH_STAGE11_PART%d.lua' % k)).read_text(encoding='utf-8')) for k in range(1, nparts + 1)],
      'install', len(inst))
