"""Reuse the existing Studio object/journal mock, with the actual audio payload."""
from pathlib import Path
import json,sys
HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE))
from build_audio import ROOT,OUT,literal
from patch_rules import rules

def pristine(source,kind):
    for _,old,new in reversed(rules(kind,'local carModel' in source)):
        assert source.count(new)==1
        source=source.replace(new,old,1)
    return source
parts=[(ROOT/'tools/adapter_mock_body.luau').read_text().split('-- world: ground plane',1)[0]]
for key,path in [('INSTALLER','studio/installer.luau'),('JOURNAL','studio/transaction.lua')]:
    parts.append('local '+key+'='+literal((OUT/path).read_text())+'\n')
for key,kind,name in [('BASE_CLIENT','client','Client.client.lua'),('BASE_SERVER','server','Server.server.lua')]:
    text=(ROOT/'nr2003carmodel_implementation/roblox/Bench'/name).read_text()
    parts.append('local '+key+'='+literal(pristine(text,kind))+'\n')
parts.append('local BASE_ADAPTER="-- core adapter is never patched by audio"\n')
parts.append('local SOURCES={'+','.join('['+json.dumps(p.stem)+']='+literal(p.read_text()) for p in sorted((OUT/'roblox/Audio').glob('*.lua')))+'}\n')
parts.append('local RULES={'+','.join(k+'={'+','.join('{'+','.join(literal(v) for v in r)+'}' for r in rules('client' if k=='carClient' else k,k=='carClient'))+'}' for k in ('server','client','carClient'))+'}\n')
mock=(ROOT/'tests/track1/installer_body.luau').read_text().split('local passed=0',1)[0]
mock=mock.replace('HUD_RULE[1]..\' | existing format")\'', 'BASE_CLIENT.."\\n-- USER_CLIENT_CODE\\n"')
mock=mock.replace('local package=new("Folder","NR2003Lab",rs);',
    'local servers=new("Folder","ServerScriptService",root)\n    local server=new("Script","NR2003Server",servers,BASE_SERVER.."\\n-- USER_SERVER_CODE\\n")\n    local package=new("Folder","NR2003Lab",rs);')
mock=mock.replace('RunService={IsRunning=', 'ServerScriptService=servers,RunService={IsRunning=')
mock=mock.replace('"NR2003_Track1"','"NR2003_Audio_Install"')
mock=mock.replace('Journal=JOURNAL,SurfaceSource="",HostSource="",Rules="",HudRule=""','Journal=JOURNAL,Sources="",Rules=""')
mock=mock.replace('local loaded={SurfaceSource=SURFACE,HostSource=HOST,Rules=RULES,HudRule=HUD_RULE}',
    'local loaded={Sources=SOURCES,Rules=RULES}')
mock=mock.replace('oldSpawn=oldSpawn,watkins=watkins,client=client,services=services,',
    'oldSpawn=oldSpawn,watkins=watkins,client=client,server=server,services=services,')
parts.extend([mock,(OUT/'tests/installer_body.luau').read_text()])
p=ROOT/'work/audio/installer_test.luau';p.parent.mkdir(parents=True,exist_ok=True);p.write_text(''.join(parts))
print('Built actual audio installer + journal mock:',p.relative_to(ROOT))
spatial='local SPATIAL_SOURCE='+literal((OUT/'roblox/Audio/NR2003AudioSpatial.lua').read_text())+'\n'
(ROOT/'work/audio/spatial_test.luau').write_text(spatial+(OUT/'tests/spatial_body.luau').read_text())
