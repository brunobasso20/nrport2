"""Build the Stage 8 deliverables from the package sources:
  PATCH_STAGE8.lua               single Studio Command Bar script (outside Play)
  NR2003_Patch_Stage8.rbxmx      same installer as a ModuleScript (Insert from File, then
                                 require(workspace.NR2003_Patch_Stage8)() in the Command Bar)
  roblox/Stage8SelfTest.lua      Studio self-test with golden values from the original code
The patch updates an installed, validated Stage 6/7 bench IN PLACE (backup first, revert on error)."""
import json, hashlib
from pathlib import Path
from xml.sax.saxutils import escape
root = Path(__file__).resolve().parents[1]
FIX = root / 'recovery/stage8/fixtures_json'


def long_string(text):
    eq = '='
    while (']' + eq + ']') in text: eq += '='
    return '[' + eq + '[\n' + text + ']' + eq + ']'


def lua_value(v):
    if isinstance(v, bool): return 'true' if v else 'false'
    if isinstance(v, int): return str(v)
    if isinstance(v, float): return repr(v)
    if isinstance(v, list): return '{' + ','.join(lua_value(x) for x in v) + '}'
    raise TypeError(v)


def read(p): return p.read_text(encoding='utf-8')
def write(p, s): p.write_text(s, encoding='utf-8', newline='\n')


# ------------------------------------------------------------------ self-test golden subset
def golden():
    units = json.loads(read(FIX / 'brake_units.json'))
    pedal = units['pedal'][::15]
    sc = json.loads(read(FIX / 'brake_scenarios.json'))
    sync = json.loads(read(FIX / 'brake_sync.json'))
    meta = {m['name']: m for m in sc['meta']}
    parts = []
    for name in ('max', 'keyboard', 'bias85', 'nearzero'):
        m, rows = meta[name], sc['rows'][name]
        onset = int(round(m['events'][0] * 288))
        snap = next(p for p in sync[name] if p['tick'] == onset)
        rr = []
        pairs = [(ro, rp) for ro, rp in zip(rows['orig'], rows['pert']) if ro[0] > onset]
        for ro, rp in pairs:
            if ro[0] % 36: continue
            # python row: [k, 6 chassis, 4 quat, 4 spin, engine, 24 wheel, pedal, core, gear]
            near = [(a, b) for a, b in pairs if abs(a[0] - ro[0]) <= 36]
            spread = [max(abs(b[i] - a[i]) for a, b in near) for i in range(1, 7)]
            twin_pedal_differs = any(a[40] != b[40] for a, b in near)

            def hold_edge(r):   # auto-hold regime with the resting pitch at the 0.5 deg threshold (00553080)
                import math
                m6 = 2 * (r[7] * r[9] - r[8] * r[10])
                pitch = math.degrees(math.asin(max(-1.0, min(1.0, -m6))))
                v = math.sqrt(r[2] ** 2 + r[4] ** 2 + r[6] ** 2)
                return v < 0.8 and abs(abs(pitch) - 0.5) < 0.05
            ped = '' if (twin_pedal_differs or any(hold_edge(a) for a, _ in near)) else (',pedal=%r' % ro[40])
            rr.append('[%d]={orig=%s,spread=%s%s}' % (ro[0], lua_value(ro[1:7]), lua_value(spread), ped))
        chunks = '{' + ','.join('{%d,"%s"}' % (a, b) for a, b in snap['chunks']) + '}'
        parts.append('{name=%r,ticks=%d,bias=%d,onset=%d,snapshot=%s,controls=%s,rows={%s}}' % (
            name, m['ticks'], m['bias'], onset, chunks, lua_value(m['controls']), ','.join(rr)))
    return '{\npedal=' + lua_value(pedal) + ',\nscenarios={\n' + ',\n'.join(parts) + '\n}}'


template = read(root / 'tools/selftest8_template.lua')
selftest = template.replace('__GOLDEN__', golden())
write(root / 'roblox/Stage8SelfTest.lua', selftest)

# ------------------------------------------------------------------ module list
modules = [('NR2003Cup', 'NR2003CupDriver', read(root / 'core/NR2003Cup/NR2003CupDriver.lua')),
           ('Core', 'NR2003CupVehicle', read(root / 'core/NR2003CupVehicle.lua')),
           ('Roblox', 'CupChassisAdapter', read(root / 'roblox/CupChassisAdapter.lua')),
           ('Roblox', 'Stage8SelfTest', selftest)]
for folder, name, src in modules:
    assert len(src) < 199000, '%s.%s is %d characters (Script.Source limit 200000)' % (folder, name, len(src))
client = read(root / 'roblox/Client.client.lua')

header = r'''-- PATCH_STAGE8 — NR2003 Roblox port, estágio 8 (modelo de freio completo do NR2003 Cup)
-- Cole o arquivo INTEIRO na Command Bar do Studio, FORA do Play, sobre a bancada Stage 6/7 validada.
-- Atualiza ReplicatedStorage.NR2003Lab no lugar (backup completo em ServerStorage; reverte se falhar).
-- Altera: Core.NR2003Cup.NR2003CupDriver, Core.NR2003CupVehicle, Roblox.CupChassisAdapter,
-- Roblox.Stage8SelfTest (novo) e o LocalScript NR2003Client (HUD). Servidor e módulos gerados 6/7 intactos.
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes do patch")
local RS=game:GetService("ReplicatedStorage")
local SP=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local storage=game:GetService("ServerStorage")
local pkg=assert(RS:FindFirstChild("NR2003Lab"),"NR2003Lab ausente: instale Stage 5 + Stage 6/7 antes")
local CoreF=assert(pkg:FindFirstChild("Core"),"NR2003Lab.Core ausente")
local RobloxF=assert(pkg:FindFirstChild("Roblox"),"NR2003Lab.Roblox ausente")
local cupFolder=assert(CoreF:FindFirstChild("NR2003Cup"),"Core.NR2003Cup ausente: aplique PATCH_STAGE6_7 antes")
for _,n in ipairs({"NR2003CupCore","NR2003CupDriver","NR2003CupImage1","NR2003CupJIT1"}) do
    assert(cupFolder:FindFirstChild(n),"Core.NR2003Cup."..n.." ausente (Stage 6/7 requerido)")
end
for _,n in ipairs({"CupChassisAdapter","Stage67SelfTest","ModeConfig"}) do
    assert(RobloxF:FindFirstChild(n),"Roblox."..n.." ausente (Stage 6/7 requerido)")
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
local base="NR2003Backup_Stage8_"..tostring(os.time());local suffix=0
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
    pkg:SetAttribute("NR2003Stage","8");pkg:SetAttribute("NR2003Version","3.7.0-stage8")
    local ok67,r67=require(RobloxF.Stage67SelfTest).run(false)
    assert(ok67,"self-test Stage 6/7 falhou:\n"..table.concat(r67,"\n"))
    local ok8,r8=require(RobloxF.Stage8SelfTest).run(false)
    assert(ok8,"self-test Stage 8 falhou:\n"..table.concat(r8,"\n"))
end
local ok,reason=pcall(apply)
if not ok then
    local savedPkg=backup:FindFirstChild("NR2003Lab");local savedClient=backup:FindFirstChild("NR2003Client")
    pkg:Destroy();savedPkg:Clone().Parent=RS
    setSource(oldClient,savedClient.Source)
    error("Patch Stage 8 revertido (nada mudou além do backup em ServerStorage."..backup.Name.."): "..tostring(reason))
end
print("Stage 8 aplicado. Backup: ServerStorage."..backup.Name)
print("Freio: cadeia original 00553080 (tecla S = ligação digital, rampa 1/12 por quadro; hold automático parado).")
print("Viés de freio: atributo SetupBrakeBias (50..90, % dianteiro) no TestCar; aplicado ao reiniciar (R). Padrão Cup 74.")
print("Play > F entrar | W/S acel/freio | A/D direção | E/Q marchas | Shift embreagem | R reinicia | T painel")
'''
body.append(footer)
patch = ''.join(body)
write(root / 'PATCH_STAGE8.lua', patch)
rbx = ('<?xml version=\'1.0\' encoding=\'utf-8\'?>\n<roblox version="4">\n  <External>null</External>\n'
       '  <Item class="ModuleScript" referent="RBX_STAGE8">\n    <Properties>\n'
       '      <string name="Name">NR2003_Patch_Stage8</string>\n'
       '      <ProtectedString name="Source">' + escape('return function()\n' + patch + '\nend\n') + '</ProtectedString>\n'
       '    </Properties>\n  </Item>\n</roblox>\n')
write(root / 'NR2003_Patch_Stage8.rbxmx', rbx)
print('PATCH_STAGE8.lua', len(patch), 'chars;', len(modules), 'modules; selftest', len(selftest),
      'chars; sha256', hashlib.sha256(patch.encode()).hexdigest()[:16])
