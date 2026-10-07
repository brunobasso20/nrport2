"""Build the Stage 9 deliverables from the package sources:
  roblox/Stage9SelfTest.lua      Studio self-test with golden values from the original code
  PATCH_STAGE9.lua               single Studio Command Bar script (outside Play)
  NR2003_Patch_Stage9.rbxmx      same installer as a ModuleScript (Insert from File, then
                                 require(workspace.NR2003_Patch_Stage9)() in the Command Bar)
The patch updates an installed, validated Stage 8 bench IN PLACE (backup first, revert on error)."""
import json, hashlib, math
from pathlib import Path
from xml.sax.saxutils import escape
root = Path(__file__).resolve().parents[1]
FIX = root / 'recovery/stage9/fixtures_json'


def long_string(text):
    eq = '='
    while (']' + eq + ']') in text: eq += '='
    return '[' + eq + '[\n' + text + ']' + eq + ']'


def lua_value(v):
    if isinstance(v, bool): return 'true' if v else 'false'
    if isinstance(v, int): return str(v)
    if isinstance(v, float): return repr(v)
    if isinstance(v, str): return json.dumps(v)
    if isinstance(v, list): return '{' + ','.join(lua_value(x) for x in v) + '}'
    if isinstance(v, dict): return '{' + ','.join('%s=%s' % (k, lua_value(x)) for k, x in v.items()) + '}'
    if v is None: return 'nil'
    raise TypeError(v)


def read(p): return p.read_text(encoding='utf-8')
def write(p, s): p.write_text(s, encoding='utf-8', newline='\n')


def weather_api(w):
    out = {}
    for k, n in (('temperature', 'temperatureF'), ('wind_mph', 'windSpeedMph'), ('wind_dir', 'windDirection'), ('conditions', 'conditions')):
        if k in w: out[n] = w[k]
    if w.get('night'): out['night'] = True
    return out


# ------------------------------------------------------------------ self-test golden subset
def golden():
    C = json.loads(read(FIX / 'aero_constants.json'))
    U = json.loads(read(FIX / 'aero_units.json'))
    sc = json.loads(read(FIX / 'aero_scenarios.json'))
    sync = json.loads(read(FIX / 'aero_sync.json'))
    meta = {m['name']: m for m in sc['meta']}
    parts = []
    # quick: launch from its 20 s snapshot for 2 s; full: + hsbrake, draft (shortened). The CLI suite
    # (tests/stage9/run.luau) covers every vector and scenario; Studio gets subsets (Source < 200000 chars)
    for name, onset_s, end_s in (('launch', 20.0, 22.0), ('hsbrake', 20.0, 24.0), ('draft', 15.0, 25.0)):
        m, rows = meta[name], sc['rows'][name]
        onset = int(round(onset_s * 288)); end = int(round(end_s * 288))
        snap = next(p for p in sync[name] if p['tick'] == onset)
        pairs = [(ro, rp) for ro, rp in zip(rows['orig'], rows['pert']) if onset < ro[0] <= end]
        rr = []
        for ro, rp in pairs:
            if ro[0] % 72: continue
            near = [(a, b) for a, b in pairs if abs(a[0] - ro[0]) <= 36]
            spread = [max(abs(b[i] - a[i]) for a, b in near) for i in range(1, 7)]
            rr.append('[%d]={orig=%s,spread=%s}' % (ro[0], lua_value(ro[1:7]), lua_value(spread)))
        chunks = '{' + ','.join('{%d,"%s"}' % (a, b) for a, b in snap['chunks']) + '}'
        parts.append('{name=%r,ticks=%d,onset=%d,weather=%s,draft=%s,aero=%s,snapshot=%s,controls=%s,rows={%s}}' % (
            name, end, onset, lua_value(weather_api(m['weather'])), lua_value(m['draft']) if m['draft'] else 'nil',
            lua_value(snap['aero']), chunks, lua_value(m['controls'][:end // 8 + 1]), ','.join(rr)))
    g = ['{', 'cells=' + lua_value(C['cells']) + ',',
         'weather=' + lua_value(U['weather'][::20]) + ',',
         'density=' + lua_value(U['density'][::25]) + ',',
         'halfwind=' + lua_value(U['halfwind'][::15]) + ',', 'halfwindCells=' + lua_value(U['halfwindCells']) + ',',
         'aero=' + lua_value(U['aero'][::100]) + ',', 'aeroCells=' + lua_value(U['aeroCells']) + ',',
         'wake=' + lua_value([r[:3] for r in U['wake'][::25]]) + ',',
         'draft=' + lua_value(U['draft'][::60]) + ',',
         'tape=' + lua_value([r for r in U['tape'] if r[0] % 5 == 0]) + ',',
         'spoiler=' + lua_value([r for r in U['spoiler'] if 45 <= r[0] <= 70]) + ',',
         'scenarios={\n' + ',\n'.join(parts) + '\n}}']
    return '\n'.join(g)


template = read(root / 'tools/selftest9_template.lua')
selftest = template.replace('__GOLDEN__', golden())
write(root / 'roblox/Stage9SelfTest.lua', selftest)

# ------------------------------------------------------------------ module list
modules = [('NR2003Cup', 'NR2003CupAero', read(root / 'core/NR2003Cup/NR2003CupAero.lua')),
           ('NR2003Cup', 'NR2003CupDriver', read(root / 'core/NR2003Cup/NR2003CupDriver.lua')),
           ('Core', 'NR2003CupVehicle', read(root / 'core/NR2003CupVehicle.lua')),
           ('Roblox', 'CupChassisAdapter', read(root / 'roblox/CupChassisAdapter.lua')),
           ('Roblox', 'Stage9SelfTest', selftest)]
for folder, name, src in modules:
    assert len(src) < 199000, '%s.%s is %d characters (Script.Source limit 200000)' % (folder, name, len(src))
client = read(root / 'roblox/Client.client.lua')

header = r'''-- PATCH_STAGE9 — NR2003 Roblox port, estágio 9 (aerodinâmica completa do NR2003 Cup)
-- Cole o arquivo INTEIRO na Command Bar do Studio, FORA do Play, sobre a bancada Stage 8 validada.
-- Atualiza ReplicatedStorage.NR2003Lab no lugar (backup completo em ServerStorage; reverte se falhar).
-- Altera: Core.NR2003Cup.NR2003CupAero (novo), Core.NR2003Cup.NR2003CupDriver, Core.NR2003CupVehicle,
-- Roblox.CupChassisAdapter, Roblox.Stage9SelfTest (novo) e o LocalScript NR2003Client (HUD).
-- Servidor, módulos gerados 6/7 (Core/Image/JIT) e self-tests 6/7 e 8 intactos.
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes do patch")
local RS=game:GetService("ReplicatedStorage")
local SP=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local storage=game:GetService("ServerStorage")
local pkg=assert(RS:FindFirstChild("NR2003Lab"),"NR2003Lab ausente: instale Stage 5 + 6/7 + 8 antes")
local CoreF=assert(pkg:FindFirstChild("Core"),"NR2003Lab.Core ausente")
local RobloxF=assert(pkg:FindFirstChild("Roblox"),"NR2003Lab.Roblox ausente")
local cupFolder=assert(CoreF:FindFirstChild("NR2003Cup"),"Core.NR2003Cup ausente: aplique PATCH_STAGE6_7 e PATCH_STAGE8 antes")
for _,n in ipairs({"NR2003CupCore","NR2003CupDriver","NR2003CupImage1","NR2003CupJIT1"}) do
    assert(cupFolder:FindFirstChild(n),"Core.NR2003Cup."..n.." ausente (Stage 6/7 requerido)")
end
assert(cupFolder.NR2003CupDriver.Source:find("brakePedalOriginal",1,true),"NR2003CupDriver sem a cadeia de freio: aplique PATCH_STAGE8 antes")
for _,n in ipairs({"CupChassisAdapter","Stage67SelfTest","Stage8SelfTest","ModeConfig"}) do
    assert(RobloxF:FindFirstChild(n),"Roblox."..n.." ausente (Stage 8 requerido: aplique PATCH_STAGE8 antes)")
end
local oldClient=assert(SP:FindFirstChild("NR2003Client"),"StarterPlayerScripts.NR2003Client ausente")
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
body.append('local clientSource=' + long_string(client) + '\n')
footer = r'''-- backup (complete copies) -------------------------------------------------------------
local backup=Instance.new("Folder")
local base="NR2003Backup_Stage9_"..tostring(os.time());local suffix=0
while storage:FindFirstChild(base.."_"..suffix) do suffix=suffix+1 end
backup.Name=base.."_"..suffix
pkg:Clone().Parent=backup;oldClient:Clone().Parent=backup
backup.Parent=storage
local function apply()
    local dest={NR2003Cup=cupFolder,Core=CoreF,Roblox=RobloxF}
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
    pkg:SetAttribute("NR2003Stage","9");pkg:SetAttribute("NR2003Version","3.8.0-stage9")
    local ok67,r67=require(RobloxF.Stage67SelfTest).run(false)
    assert(ok67,"self-test Stage 6/7 falhou:\n"..table.concat(r67,"\n"))
    local ok8,r8=require(RobloxF.Stage8SelfTest).run(false)
    assert(ok8,"self-test Stage 8 falhou:\n"..table.concat(r8,"\n"))
    local ok9,r9=require(RobloxF.Stage9SelfTest).run(false)
    assert(ok9,"self-test Stage 9 falhou:\n"..table.concat(r9,"\n"))
end
local ok,reason=pcall(apply)
if not ok then
    local savedPkg=backup:FindFirstChild("NR2003Lab");local savedClient=backup:FindFirstChild("NR2003Client")
    pkg:Destroy();savedPkg:Clone().Parent=RS
    setSource(oldClient,savedClient.Source)
    error("Patch Stage 9 revertido (nada mudou além do backup em ServerStorage."..backup.Name.."): "..tostring(reason))
end
print("Stage 9 aplicado. Backup: ServerStorage."..backup.Name)
print("Aero: sessão original 005a3c00 (70 F, sem vento -> rho 1.0812 kg/m3) + fatores por quadro 005637e0; forças = 00561b70 original.")
print("Atributos do TestCar (aplicados ao reiniciar, R): WeatherTemperatureF, WeatherWindMph, WeatherWindDirection (0..7), WeatherConditions (0..3),")
print("  WeatherNight, TrackNorth, SetupGrilleTape (0..100 %), SetupSpoiler (45..70°), AeroSession=false (sem ar), DraftTestGap/DraftTestLateral (TESTE).")
print("Play > F entrar | W/S acel/freio | A/D direção | E/Q marchas | R reinicia | T painel (linha AERO)")
'''
body.append(footer)
patch = ''.join(body)
write(root / 'PATCH_STAGE9.lua', patch)
rbx = ('<?xml version=\'1.0\' encoding=\'utf-8\'?>\n<roblox version="4">\n  <External>null</External>\n'
       '  <Item class="ModuleScript" referent="RBX_STAGE9">\n    <Properties>\n'
       '      <string name="Name">NR2003_Patch_Stage9</string>\n'
       '      <ProtectedString name="Source">' + escape('return function()\n' + patch + '\nend\n') + '</ProtectedString>\n'
       '    </Properties>\n  </Item>\n</roblox>\n')
write(root / 'NR2003_Patch_Stage9.rbxmx', rbx)
print('PATCH_STAGE9.lua', len(patch), 'chars;', len(modules), 'modules; selftest', len(selftest),
      'chars; sha256', hashlib.sha256(patch.encode()).hexdigest()[:16])
