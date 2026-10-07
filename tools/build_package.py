"""Generate a Studio command-bar installer, rbxmx installation kit and Rojo project.
No web downloads, asset IDs, plugins, or runtime Source editing in the generated car.
"""
from pathlib import Path
import json, hashlib, xml.etree.ElementTree as ET
root=Path(__file__).resolve().parents[1]
def long_string(text):
    eq='='
    while ']'+eq+']' in text: eq+='='
    return '['+eq+'[\n'+text+']'+eq+']'
modules=[]
for directory,name in [('core','Core'),('roblox','Roblox')]:
    for path in sorted((root/directory).glob('*.lua')):
        if path.name.endswith(('.server.lua','.client.lua')):continue
        modules.append((name,path.stem,path.read_text()))
server=(root/'roblox/Server.server.lua').read_text()
client=(root/'roblox/Client.client.lua').read_text()
header='''-- Paste this ENTIRE file into the Studio Command Bar, outside Play.
-- Creates only NR2003Lab-owned folders/scripts. Stops if they already exist.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before installing")
local RS=game:GetService("ReplicatedStorage")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
assert(not RS:FindFirstChild("NR2003Lab"), "NR2003Lab already exists; see README update instructions")
assert(not workspace:FindFirstChild("NR2003LabWorld"), "NR2003LabWorld already exists")
assert(not SS:FindFirstChild("NR2003Server") and not SP:FindFirstChild("NR2003Client"), "Old NR2003 scripts exist")
local package=Instance.new("Folder"); package.Name="NR2003Lab"
local core=Instance.new("Folder"); core.Name="Core"; core.Parent=package
local roblox=Instance.new("Folder"); roblox.Name="Roblox"; roblox.Parent=package
local destinations={Core=core,Roblox=roblox}
local function module(folder,name,source)
    local m=Instance.new("ModuleScript"); m.Name=name; m.Source=source; m.Parent=destinations[folder]
end
'''
lines=[header]
for folder,name,source in modules:lines.append('module('+json.dumps(folder)+','+json.dumps(name)+','+long_string(source)+')\n')
lines.append('local serverSource='+long_string(server)+'\nlocal clientSource='+long_string(client)+'\n')
footer='''local input=Instance.new("RemoteEvent"); input.Name="Input"; input.Parent=package
local telemetry=Instance.new("RemoteEvent"); telemetry.Name="Telemetry"; telemetry.Parent=package
local renderState=Instance.new("UnreliableRemoteEvent"); renderState.Name="RenderState"; renderState.Parent=package
package.Parent=RS
local server=Instance.new("Script"); server.Name="NR2003Server"; server.Source=serverSource; server.Parent=SS
local client=Instance.new("LocalScript"); client.Name="NR2003Client"; client.Source=clientSource; client.Parent=SP
local world=Instance.new("Folder"); world.Name="NR2003LabWorld"; world.Parent=workspace
local tune=require(package.Core.TestTune).new()
local builder=require(package.Roblox.CarBuilder)
builder.makeTrack(world)
local car=builder.create(world,builder.spawnCFrame(tune),tune)
local dynamics=require(package.Core.VehicleDynamics).new(tune)
local contacts=require(package.Roblox.RaycastContacts).new(car,tune):sample(dynamics)
for i,w in ipairs(dynamics.wheels) do w.compression=math.max(0,contacts[i].compression) end
require(package.Roblox.VisualRig).new(car,tune):update(dynamics,contacts,false)
require(package.Roblox.Diagnostics).run(car,tune)
game:GetService("Selection"):Set({car})
print("NR2003 Lab Stage 5 estabilizado instalado. Play > F entrar. H render diag.")
'''
lines.append(footer)
(root/'INSTALL_STUDIO.lua').write_text(''.join(lines))
patch_header='''-- PATCH COMPLETO ATÉ O ESTÁGIO 5. Command Bar, fora de Play.
assert(not game:GetService("RunService"):IsRunning(), "Pare Play antes do patch")
local RS=game:GetService("ReplicatedStorage")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local storage=game:GetService("ServerStorage")
local old=assert(RS:FindFirstChild("NR2003Lab"),"Instale a bancada antes do patch")
local world=assert(workspace:FindFirstChild("NR2003LabWorld"),"NR2003LabWorld ausente")
local car=assert(world:FindFirstChild("TestCar"),"TestCar ausente")
assert(car:FindFirstChild("Chassis") and car:FindFirstChild("DriverSeat"),"Chassis/DriverSeat ausente")
assert(old:FindFirstChild("Core") and old.Core:FindFirstChild("TestTune"),"TestTune ausente")
assert(car.Archivable and old.Archivable,"Habilite Archivable no carro e pacote para backup")
local oldServer=SS:FindFirstChild("NR2003Server")
local oldClient=SP:FindFirstChild("NR2003Client")
local package=Instance.new("Folder");package.Name="NR2003Lab"
local core=Instance.new("Folder");core.Name="Core";core.Parent=package
local roblox=Instance.new("Folder");roblox.Name="Roblox";roblox.Parent=package
local destinations={Core=core,Roblox=roblox}
local function module(folder,name,source)
    local m=Instance.new("ModuleScript");m.Name=name;m.Source=source;m.Parent=destinations[folder]
end
'''
patch=[patch_header]+lines[1:-1]
patch.append('''package.Core.TestTune.Source=old.Core.TestTune.Source
local input=Instance.new("RemoteEvent");input.Name="Input";input.Parent=package
local telemetry=Instance.new("RemoteEvent");telemetry.Name="Telemetry";telemetry.Parent=package
local renderState=Instance.new("UnreliableRemoteEvent");renderState.Name="RenderState";renderState.Parent=package
local server=Instance.new("Script");server.Name="NR2003Server";server.Source=serverSource
local client=Instance.new("LocalScript");client.Name="NR2003Client";client.Source=clientSource
local backup=Instance.new("Folder")
local base="NR2003Backup_"..tostring(os.time());local suffix=0
while storage:FindFirstChild(base.."_"..suffix) do suffix=suffix+1 end
backup.Name=base.."_"..suffix
local savedCar=assert(car:Clone(),"Não foi possível clonar carro");savedCar.Name="TestCar";savedCar.Parent=backup
backup.Parent=storage
old.Parent=backup
if oldServer then oldServer.Parent=backup end
if oldClient then oldClient.Parent=backup end
local ok,reason=pcall(function()
    package.Parent=RS
    local tune=require(package.Core.TestTune).new()
    require(package.Roblox.SeatAccess).configure(car)
    require(package.Roblox.Cockpit).ensure(car,tune)
    server.Parent=SS;client.Parent=SP
    require(package.Roblox.Diagnostics).run(car,tune)
end)
if not ok then
    package:Destroy();server:Destroy();client:Destroy();car:Destroy()
    savedCar.Parent=world;old.Parent=RS
    if oldServer then oldServer.Parent=SS end
    if oldClient then oldClient.Parent=SP end
    error("Patch revertido: "..tostring(reason))
end
game:GetService("Selection"):Set({car})
print("Stage 5 estabilizado aplicado. Backup: ServerStorage."..backup.Name)
print("Modo NR2003_CORE. H mostra render diag; V cockpit. ROBLOX_ADAPTER segue disponível.")
''')
(root/'PATCH_STAGE5.lua').write_text(''.join(patch))
# rbxmx is an alternative to pasting a long installer: its ModuleScript has the same Source.
rbx=ET.Element('roblox',{'version':'4'})
external=ET.SubElement(rbx,'External'); external.text='null'
item=ET.SubElement(rbx,'Item',{'class':'ModuleScript','referent':'RBX_INSTALLER'})
props=ET.SubElement(item,'Properties')
ET.SubElement(props,'string',{'name':'Name'}).text='NR2003_Install'
ET.SubElement(props,'ProtectedString',{'name':'Source'}).text='return function()\n'+''.join(lines)+'\nend\n'
ET.indent(rbx)
ET.ElementTree(rbx).write(root/'NR2003_Install.rbxmx',encoding='utf-8',xml_declaration=True)
props.find('string').text='NR2003_Patch_Stage5'
props.find('ProtectedString').text='return function()\n'+''.join(patch)+'\nend\n'
ET.ElementTree(rbx).write(root/'NR2003_Patch_Stage5.rbxmx',encoding='utf-8',xml_declaration=True)
tree={'$className':'DataModel','ReplicatedStorage':{'NR2003Lab':{
    '$className':'Folder','Core':{'$path':'core'},'Roblox':{'$className':'Folder'},
    'Input':{'$className':'RemoteEvent'},'Telemetry':{'$className':'RemoteEvent'},'RenderState':{'$className':'UnreliableRemoteEvent'}}},
    'ServerScriptService':{'NR2003Server':{'$path':'roblox/Server.server.lua'}},
    'StarterPlayer':{'StarterPlayerScripts':{'NR2003Client':{'$path':'roblox/Client.client.lua'}}}}
for folder,name,_ in modules:
    if folder=='Roblox':tree['ReplicatedStorage']['NR2003Lab']['Roblox'][name]={'$path':'roblox/'+name+'.lua'}
(root/'default.project.json').write_text(json.dumps({'name':'OpenNR2003TestBench','tree':tree},indent=2)+'\n')
syntax_files=[str(p.relative_to(root)) for folder in ('core','roblox','tests') for p in sorted((root/folder).glob('*.lua'))
    if p.name!='check_syntax.lua']+['INSTALL_STUDIO.lua','PATCH_STAGE5.lua']
(root/'tests/check_syntax.lua').write_text('local files={'+','.join(json.dumps(p) for p in syntax_files)+'}\n'
    +'for _,p in ipairs(files) do local chunk,err=loadfile(p); assert(chunk,p..": "..tostring(err)) end\n'
    +'print("PASS: syntax for "..#files.." Lua files")\n')
manifest={'sourceCommit':'03bcafb44cf63464493f1864edbd9f781fac24f4',
    'version':'3.5.2-stage5-validated','completedThroughRoadmapStage':5,
    'liveIntegration':'13 chassis states + existing wheel/suspension/drivetrain adapter + client render interpolation',
    'fullCoreGraphStates':45,'defaultMode':'NR2003_CORE',
    'runtimeModules':len(modules),'runtimeLuaFiles':len(modules)+2,
    'runtimeLines':sum(len(s.splitlines()) for _,_,s in modules)+len(server.splitlines())+len(client.splitlines()),
    'fullNR2003Parity':False,'studioPlayVerified':True,'studioValidationDate':'2026-10-04',
    'studioValidationSummary':'User reports vehicle presentation fully smooth; suspension effects more visible after interpolation; no suspension retune required.',
    'nextRoadmapStages':[6,7],'referenceVehicle':'NR2003 NASCAR/Cup car',
    'referenceCalibrationPolicy':'Recover and use original NR2003 NASCAR tune/setup/runtime values where available; no arbitrary Roblox tuning as final.',
    'files':{str(p.relative_to(root)):hashlib.sha256(p.read_bytes()).hexdigest()
        for p in sorted(root.rglob('*')) if p.is_file() and p.name!='MANIFEST.json'}}
(root/'MANIFEST.json').write_text(json.dumps(manifest,indent=2)+'\n')
print(json.dumps({k:v for k,v in manifest.items() if k!='files'}))
