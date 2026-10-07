"""Build the Stage 10 deliverables from the package sources:
  roblox/Stage10SelfTest.lua     Studio self-test with golden values from the original code
  PATCH_STAGE10.lua              single Studio Command Bar script (outside Play)
  NR2003_Patch_Stage10.rbxmx     same installer as a ModuleScript (Insert from File, then
                                 require(workspace.NR2003_Patch_Stage10)() in the Command Bar)
The patch updates an installed, validated Stage 9 bench IN PLACE (backup first, revert on error)."""
import json, hashlib, base64, re, struct
from pathlib import Path
from xml.sax.saxutils import escape
root = Path(__file__).resolve().parents[1]
FIX = root / 'tests/stage10/fixtures'


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


# ------------------------------------------------------------------ self-test golden subset
def golden():
    SV = json.loads(read(root / 'recovery/stage10/fixtures_json/setup_vectors.json'))['vectors']['modes']
    J = json.loads(read(root / 'recovery/stage10/fixtures_json/stage10_fixtures.json'))
    W = J['windows']
    vec = {}
    for mode in ('nearest', 'down'):
        V = SV[mode]
        vec[mode] = {'toInternal': V['toInternal'][::24], 'toDisplay': V['toDisplay'][::24], 'step': V['step'][::60]}
    items = [dict(item=e['item'], tag=e['tag'], raw=e['raw'], structure=e['report']['structure'], pool=e['report']['pool'],
                  litTop=e['report']['litTop'], hash=e['hash'], var=e['var']) for e in J['items']]
    quick, seen = [], set()
    for e in items:                      # one natural and one generic per group of items, at most 6
        key = (e['structure'], e['item'] // 20)
        if key not in seen and len(quick) < 6: seen.add(key); quick.append(e)
    full = [e for e in items[::3] if len(e['var']) <= 150][:12]
    dname = 'brakes_aero_tyres'
    S = J['setups'][dname]
    drive = json.loads(read(root / 'recovery/stage6_7/fixtures_json/drive_fixture.json'))
    controls = [[c['throttle'], c['brake'], c['clutch'], c['steer'], bool(c.get('shiftUp')), bool(c.get('shiftDown'))] for c in drive['controls']]
    def trim(rows):   # full rows for the first ticks (strict check), tick + chassis x/vx/y/vy/z/vz afterwards
        return [r if k < 8 else r[:7] for k, r in enumerate(rows)]
    dyn = dict(name=dname, items={int(k): v for k, v in S['items'].items()}, ticks=2304, first=8,
               orig=trim(S['orig']), pert=trim(S['pert']), gen=trim(S['gen']), controls=controls)
    solve = J['solve']
    g = ['{', 'vec=' + lua_value(vec) + ',', 'windows=' + lua_value(W) + ',', 'solve=' + lua_value(solve) + ',',
         'itemsQuick=' + lua_value(quick) + ',', 'items=' + lua_value(full) + ',', 'dyn=' + lua_value(dyn), '}']
    return '\n'.join(g)


template = read(root / 'tools/selftest10_template.lua')
selftest = template.replace('__GOLDEN__', golden())
write(root / 'roblox/Stage10SelfTest.lua', selftest)

# ------------------------------------------------------------------ module list
C = root / 'core/NR2003Cup'
names = (['NR2003CupSetupData', 'NR2003CupSetup', 'NR2003CupBuild'] +
         sorted(p.stem for p in C.glob('NR2003CupBuildCode*.lua')) + sorted(p.stem for p in C.glob('NR2003CupBuildData*.lua')) +
         sorted(p.stem for p in C.glob('NR2003CupJITG*.lua')) + ['NR2003CupGarage', 'NR2003CupCore', 'NR2003CupDriver'])
modules = [('NR2003Cup', n, read(C / (n + '.lua'))) for n in names]
modules += [('Core', 'NR2003CupVehicle', read(root / 'core/NR2003CupVehicle.lua')),
            ('Roblox', 'CupChassisAdapter', read(root / 'roblox/CupChassisAdapter.lua')),
            ('Roblox', 'Stage10SelfTest', selftest)]
for folder, name, src in modules:
    assert len(src) < 199000, '%s.%s is %d characters (Script.Source limit 200000)' % (folder, name, len(src))

header = r'''-- PATCH_STAGE10 — NR2003 Roblox port, estágio 10 (setup completo da garagem -> parâmetros de tempo de execução)
-- Recomendado: Insert from File de NR2003_Patch_Stage10.rbxmx (arquivo grande). Alternativa: cole este arquivo INTEIRO na
-- Command Bar do Studio, FORA do Play, sobre a bancada Stage 9 validada.
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
local MODULES={}
local function module(folder,name,source) MODULES[#MODULES+1]={folder,name,source} end
'''
body = [header]
for folder, name, src in modules:
    body.append('module(%s,%s,%s)\n' % (json.dumps(folder), json.dumps(name), long_string(src)))
footer = r'''-- backup (complete copy) ---------------------------------------------------------------
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
        local s=Instance.new("ModuleScript");s.Name=name
        setSource(s,source);s.Parent=parent
        assert(#s.Source==#source,"fonte truncada: "..folder.."."..name)
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
print("Stage 10 aplicado. Backup: ServerStorage."..backup.Name)
print("Setup: atributos Setup_<item> no TestCar em unidades da garagem (ex.: Setup_springLF=1700, Setup_camberLF=-2.5,")
print("  Setup_casterRF=4, Setup_trackBarRR=11, Setup_wedge=50, Setup_gearChoice1=120, Setup_tirePressureRF=40). Aplicados ao reiniciar (R)")
print("  pelo build ORIGINAL do carro; SetupStructure / SetupApplySeconds / SetupError mostram o resultado. Lista: SETUP_MAP.md.")
print("Play > F entrar | W/S acel/freio | A/D direção | E/Q marchas | R reinicia | T painel")
'''
body.append(footer)
patch = ''.join(body)
write(root / 'PATCH_STAGE10.lua', patch)
rbx = ('<?xml version=\'1.0\' encoding=\'utf-8\'?>\n<roblox version="4">\n  <External>null</External>\n'
       '  <Item class="ModuleScript" referent="RBX_STAGE10">\n    <Properties>\n'
       '      <string name="Name">NR2003_Patch_Stage10</string>\n'
       '      <ProtectedString name="Source">' + escape('return function()\n' + patch + '\nend\n') + '</ProtectedString>\n'
       '    </Properties>\n  </Item>\n</roblox>\n')
write(root / 'NR2003_Patch_Stage10.rbxmx', rbx)
print('PATCH_STAGE10.lua', len(patch), 'chars;', len(modules), 'modules; selftest', len(selftest),
      'chars; sha256', hashlib.sha256(patch.encode()).hexdigest()[:16])

# ------------------------------------------------------------------ split install (Command Bar in parts)
# Same modules as PATCH_STAGE10.lua, for when one 2 MB paste is too large for the Command Bar: parts 1..N only store
# the sources in ServerStorage.NR2003Stage10Staging (the game is not changed), PATCH_STAGE10_INSTALL.lua checks that
# every staged source is complete and installs exactly like PATCH_STAGE10.lua (backup, self-tests, revert).
PART_CHARS = 650000
groups = [[]]; size = 0
for m in modules:
    if groups[-1] and size + len(m[2]) > PART_CHARS: groups.append([]); size = 0
    groups[-1].append(m); size += len(m[2])
nparts = len(groups)
for old in root.glob('PATCH_STAGE10_PART*.lua'): old.unlink()
expect = []
for k, grp in enumerate(groups, 1):
    head = (r'''-- PATCH_STAGE10 parte %d/%d — NR2003 Roblox port, estágio 10 (instalação em partes pela Command Bar).
-- Cole as partes 1..%d em ordem (cada uma inteira, FORA do Play) e depois PATCH_STAGE10_INSTALL.lua.
-- As partes só guardam fontes em ServerStorage.NR2003Stage10Staging; nada muda no jogo até o INSTALL.
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes do patch")
local storage=game:GetService("ServerStorage")
local SES=game:GetService("ScriptEditorService")
local function setSource(s,src)
    if #src<200000 then s.Source=src else SES:UpdateSourceAsync(s,function() return src end) end
end
local staging=storage:FindFirstChild("NR2003Stage10Staging")
if not staging then staging=Instance.new("Folder");staging.Name="NR2003Stage10Staging";staging.Parent=storage end
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
    body_k.append('print("PATCH_STAGE10 parte %d/%d guardada (%d módulos). Próximo: %s")\n' % (
        k, nparts, len(grp), ('parte %d' % (k + 1)) if k < nparts else 'PATCH_STAGE10_INSTALL.lua'))
    write(root / ('PATCH_STAGE10_PART%d.lua' % k), ''.join(body_k))
install_head = header.split('local MODULES={}')[0].replace(
    '-- PATCH_STAGE10 — NR2003 Roblox port, estágio 10 (setup completo da garagem -> parâmetros de tempo de execução)',
    '-- PATCH_STAGE10_INSTALL — NR2003 Roblox port, estágio 10: instala o que as partes 1..%d guardaram em\n'
    '-- ServerStorage.NR2003Stage10Staging (mesmo resultado do PATCH_STAGE10.lua inteiro). Cole na Command Bar, FORA do\n'
    '-- Play, depois das partes. Se algo falhar, tudo é revertido e as partes guardadas continuam lá (repita só o INSTALL).' % nparts).replace(
    '''-- Recomendado: Insert from File de NR2003_Patch_Stage10.rbxmx (arquivo grande). Alternativa: cole este arquivo INTEIRO na
-- Command Bar do Studio, FORA do Play, sobre a bancada Stage 9 validada.
''', '')
assert 'Recomendado' not in install_head
install = [install_head,
           'local staging=assert(storage:FindFirstChild("NR2003Stage10Staging"),"cole antes as partes 1..%d (PATCH_STAGE10_PART*.lua)")\n' % nparts,
           'local EXPECT={\n']
for folder, name, n, k in expect:
    install.append('    {%s,%s,%d,%d},\n' % (json.dumps(folder), json.dumps(name), n, k))
install.append('}\n')
install.append(r'''local MODULES={}
for _,e in ipairs(EXPECT) do
    local f=staging:FindFirstChild(e[1]);local s=f and f:FindFirstChild(e[2])
    assert(s and #s.Source==e[3],"módulo "..e[1].."."..e[2].." ausente ou incompleto: cole de novo a parte "..e[4])
    MODULES[#MODULES+1]={e[1],e[2],s}
end
''')
install.append(footer.replace(
    '''        local s=Instance.new("ModuleScript");s.Name=name
        setSource(s,source);s.Parent=parent
        assert(#s.Source==#source,"fonte truncada: "..folder.."."..name)''',
    '''        local s=source:Clone();s.Name=name;s.Parent=parent
        assert(s.Source==source.Source,"fonte truncada: "..folder.."."..name)''').replace(
    'print("Stage 10 aplicado. Backup: ServerStorage."..backup.Name)',
    'staging:Destroy()\nprint("Stage 10 aplicado. Backup: ServerStorage."..backup.Name)'))
inst = ''.join(install)
assert 'source:Clone()' in inst and 'staging:Destroy()' in inst
write(root / 'PATCH_STAGE10_INSTALL.lua', inst)
print('split install:', nparts, 'parts', [len((root / ('PATCH_STAGE10_PART%d.lua' % k)).read_text()) for k in range(1, nparts + 1)],
      'install', len(inst))
