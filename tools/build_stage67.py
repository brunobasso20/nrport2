"""Build the Stage 6/7 deliverables from the package sources:
  PATCH_STAGE6_7.lua               single Studio Command Bar script (outside Play)
  NR2003_Patch_Stage6_7.rbxmx      same installer as a ModuleScript (Insert from File, then
                                   require(workspace.NR2003_Patch_Stage6_7)() in the Command Bar)
  roblox/Stage67SelfTest.lua       Studio self-test with golden values from the original code
The patch updates an installed, validated Stage 5 bench IN PLACE (backup first, revert on error)."""
import json, hashlib, re
from pathlib import Path
from xml.sax.saxutils import escape
root = Path(__file__).resolve().parents[1]
FIX = root / 'recovery/stage6_7/fixtures_json'

def long_string(text):
    eq = '='
    while (']' + eq + ']') in text: eq += '='
    return '[' + eq + '[\n' + text + ']' + eq + ']'

def lua_value(v):
    if isinstance(v, bool): return 'true' if v else 'false'
    if isinstance(v, (int,)): return str(v)
    if isinstance(v, float): return repr(v)
    if isinstance(v, list): return '{' + ','.join(lua_value(x) for x in v) + '}'
    raise TypeError(v)

# ------------------------------------------------------------------ self-test golden subset
def golden():
    out = []
    for kind in ('raw', 'drive'):
        js = json.loads((FIX / ('%s_fixture.json' % kind)).read_text())
        early = ['[%d]=%s' % (r[0], lua_value(r[1:46])) for r in js['orig'] if r[0] <= 8]
        rows = []
        for ro, rp in zip(js['orig'], js['pert']):
            if ro[0] % 36: continue
            g = (',gear=%d' % ro[46]) if kind == 'drive' else ''
            rows.append('[%d]={orig=%s,pert=%s%s}' % (ro[0], lua_value(ro[1:7]), lua_value(rp[1:7]), g))
        out.append('%s={early={%s},rows={%s}}' % (kind, ','.join(early), ','.join(rows)))
        if kind == 'drive':
            ctl = js['controls']
            out.append('controls={' + ','.join('{%r,%r,%r,%r,%s,%s}' % (c['throttle'], c['brake'], c['clutch'], c['steer'],
                       lua_value(bool(c.get('shiftUp'))), lua_value(bool(c.get('shiftDown')))) for c in ctl) + '}')
    return '{\n' + ',\n'.join(out) + '\n}'

template = (root / 'tools/selftest_template.lua').read_text()
selftest = template.replace('__GOLDEN__', golden())
(root / 'roblox/Stage67SelfTest.lua').write_text(selftest)

# ------------------------------------------------------------------ module list
cup = sorted((root / 'core/NR2003Cup').glob('*.lua'))
modules = [('NR2003Cup', p.stem, p.read_text()) for p in cup]
modules += [('Core', 'NR2003CupVehicle', (root / 'core/NR2003CupVehicle.lua').read_text()),
            ('Core', 'CupTune', (root / 'core/CupTune.lua').read_text()),
            ('Roblox', 'CupChassisAdapter', (root / 'roblox/CupChassisAdapter.lua').read_text()),
            ('Roblox', 'ModeConfig', (root / 'roblox/ModeConfig.lua').read_text()),
            ('Roblox', 'Stage67SelfTest', selftest)]
for folder, name, src in modules:
    assert len(src) < 199000, '%s.%s is %d characters (Script.Source limit 200000)' % (folder, name, len(src))
server = (root / 'roblox/Server.server.lua').read_text()
client = (root / 'roblox/Client.client.lua').read_text()

header = r'''-- PATCH_STAGE6_7 — NR2003 Roblox port, estágios 6 e 7 (núcleo original NR2003 Cup de 45 estados)
-- Cole o arquivo INTEIRO na Command Bar do Studio, FORA do Play, sobre a bancada Stage 5 validada.
-- Atualiza ReplicatedStorage.NR2003Lab no lugar (backup completo em ServerStorage; reverte se falhar).
-- Mantém NR2003_CORE (estágio 5) e ROBLOX_ADAPTER; o modo padrão passa a ser NR2003_CUP.
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes do patch")
local RS=game:GetService("ReplicatedStorage")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local storage=game:GetService("ServerStorage")
local pkg=assert(RS:FindFirstChild("NR2003Lab"),"NR2003Lab ausente: instale/aplique o Stage 5 antes")
local world=assert(workspace:FindFirstChild("NR2003LabWorld"),"NR2003LabWorld ausente")
local car=assert(world:FindFirstChild("TestCar"),"TestCar ausente")
assert(car:FindFirstChild("Chassis") and car:FindFirstChild("DriverSeat"),"Chassis/DriverSeat ausente")
local CoreF=assert(pkg:FindFirstChild("Core"),"NR2003Lab.Core ausente")
local RobloxF=assert(pkg:FindFirstChild("Roblox"),"NR2003Lab.Roblox ausente")
for _,n in ipairs({"NR2003FixedStep","Surface","MathUtil","TestTune"}) do assert(CoreF:FindFirstChild(n),"Core."..n.." ausente (Stage 5 requerido)") end
for _,n in ipairs({"VisualRig","RenderSnapshot","SnapshotBuffer","RenderPresentation","CoreChassisAdapter","SeatAccess","Cockpit","LegacyRobloxAdapter"}) do
    assert(RobloxF:FindFirstChild(n),"Roblox."..n.." ausente (Stage 5 requerido)")
end
local oldServer=assert(SS:FindFirstChild("NR2003Server"),"ServerScriptService.NR2003Server ausente")
local oldClient=assert(SP:FindFirstChild("NR2003Client"),"StarterPlayerScripts.NR2003Client ausente")
assert(pkg.Archivable and car.Archivable,"Habilite Archivable no pacote e no carro para o backup")
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
body.append('local serverSource=' + long_string(server) + '\nlocal clientSource=' + long_string(client) + '\n')
footer = r'''-- backup (complete copies) -------------------------------------------------------------
local backup=Instance.new("Folder")
local base="NR2003Backup_Stage67_"..tostring(os.time());local suffix=0
while storage:FindFirstChild(base.."_"..suffix) do suffix=suffix+1 end
backup.Name=base.."_"..suffix
pkg:Clone().Parent=backup;oldServer:Clone().Parent=backup;oldClient:Clone().Parent=backup
backup.Parent=storage
local created,replaced={}, {}
local function apply()
    local cupFolder=CoreF:FindFirstChild("NR2003Cup")
    if cupFolder then cupFolder:Destroy() end
    cupFolder=Instance.new("Folder");cupFolder.Name="NR2003Cup";cupFolder.Parent=CoreF
    created[#created+1]=cupFolder
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
    setSource(oldServer,serverSource);setSource(oldClient,clientSource)
    pkg:SetAttribute("NR2003Stage","6-7");pkg:SetAttribute("NR2003Version","3.6.0-stage7")
    local ok,results=require(RobloxF.Stage67SelfTest).run(false)
    assert(ok,"self-test falhou:\n"..table.concat(results,"\n"))
end
local ok,reason=pcall(apply)
if not ok then
    -- revert: restore package and scripts from the backup copies
    local savedPkg=backup:FindFirstChild("NR2003Lab");local savedServer=backup:FindFirstChild("NR2003Server")
    local savedClient=backup:FindFirstChild("NR2003Client")
    pkg:Destroy();savedPkg:Clone().Parent=RS
    setSource(oldServer,savedServer.Source);setSource(oldClient,savedClient.Source)
    error("Patch Stage 6/7 revertido (nada mudou além do backup em ServerStorage."..backup.Name.."): "..tostring(reason))
end
game:GetService("Selection"):Set({car})
print("Stage 6/7 aplicado. Backup: ServerStorage."..backup.Name)
print("Modo NR2003_CUP: núcleo original NR2003 Cup (45 estados: suspensão, cubos, rodas, eixo traseiro, motor, embreagem, outshaft).")
print("Play > F entrar | W/S acel/freio | A/D direção | E/Q marchas | Shift embreagem | R reinicia | G contatos | H render diag | V câmera")
print("Voltar ao estágio 5: NR2003Lab.Roblox.ModeConfig -> mode=\"NR2003_CORE\" (ou \"ROBLOX_ADAPTER\").")
'''
body.append(footer)
patch = ''.join(body)
(root / 'PATCH_STAGE6_7.lua').write_text(patch)
rbx = ('<?xml version=\'1.0\' encoding=\'utf-8\'?>\n<roblox version="4">\n  <External>null</External>\n'
       '  <Item class="ModuleScript" referent="RBX_STAGE67">\n    <Properties>\n'
       '      <string name="Name">NR2003_Patch_Stage6_7</string>\n'
       '      <ProtectedString name="Source">' + escape('return function()\n' + patch + '\nend\n') + '</ProtectedString>\n'
       '    </Properties>\n  </Item>\n</roblox>\n')
(root / 'NR2003_Patch_Stage6_7.rbxmx').write_text(rbx)
print('PATCH_STAGE6_7.lua', len(patch), 'chars;', len(modules), 'modules; sha256', hashlib.sha256(patch.encode()).hexdigest()[:16])
