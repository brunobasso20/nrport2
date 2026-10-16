from pathlib import Path
from xml.sax.saxutils import escape
import hashlib,json,sys
sys.path.insert(0,str(Path(__file__).resolve().parent))
from patch_rules import patch,rules
ROOT=Path(__file__).resolve().parents[2]
OUT=ROOT/'nr2003audio_implementation'

def literal(text):
    eq='='
    while ']'+eq+']' in text:eq+='='
    return '['+eq+'[\n'+text+']'+eq+']'
def module(name,source,children=''):
    assert len(source.encode())<195000,(name,'Source too large')
    return '<Item class="ModuleScript"><Properties><string name="Name">'+escape(name)+'</string><ProtectedString name="Source">'+escape(source)+'</ProtectedString></Properties>'+children+'</Item>'
def main():
    for kind,name in [('server','Server.server.lua'),('client','Client.client.lua')]:
        for folder in ['roblox','nr2003carmodel_implementation/roblox/Bench']:
            p=ROOT/folder/name;s=p.read_text();new=patch(s,kind)
            if new!=s:p.write_text(new)
    for name in ('default.project.json','watkinsglen.project.json'):
        p=ROOT/name;data=json.loads(p.read_text())
        data['tree']['ReplicatedStorage']['NR2003Lab']['Audio']={'$path':'nr2003audio_implementation/roblox/Audio'}
        p.write_text(json.dumps(data,indent=2)+'\n')
    sources={p.stem:p.read_text() for p in sorted((OUT/'roblox/Audio').glob('*.lua'))}
    table='return {\n'+',\n'.join('['+json.dumps(k)+']='+literal(v) for k,v in sources.items())+'\n}\n'
    r={k:rules('client' if k=='carClient' else k,k=='carClient') for k in ('server','client','carClient')}
    rs='return {\n'+',\n'.join(k+'={'+','.join('{'+','.join(literal(x) for x in row)+'}' for row in v)+'}' for k,v in r.items())+'\n}\n'
    journal=(OUT/'studio/transaction.lua').read_text()
    children=module('Sources',table)+module('Rules',rs)+module('Journal',journal)
    source=(OUT/'studio/installer.luau').read_text()
    (OUT/'NR2003_Audio_Install.rbxmx').write_text('<roblox version="4">'+module('NR2003_Audio_Install',source,children)+'</roblox>\n')
    (OUT/'INSTALL.lua').write_text('-- Stop Play; Insert from File: NR2003_Audio_Install.rbxmx, then run:\nrequire(workspace.NR2003_Audio_Install)()\n')
    (OUT/'ROLLBACK.lua').write_text('-- Stop Play; reverts only this audio patch. AudioAssets bindings are retained.\nlocal T=(function()\n'+journal+'\nend)()\nT.rollback()\n')
    manifest={'version':'1.0.0','baseCommit':'25be672a755d64b4010b02399c800522aa0ca040',
        'branch':'codex/nr2003-original-audio','originalAssetsIncluded':False,'selfmadeAssetsEnabled':False,
        'audioTailBytes':272,'renderPacketBytes':476,'additionalPayloadBytesPerSecondAt60Hz':16320,
        'profiles':['NR2003_ORIGINAL_REFERENCE','NASCAR_SELFMADE'],'requiredOriginalBanks':
        ['winston.ces','winston_nf.ces','engvol.ces','tire_asphalt.ces','tire_grass.ces','tire_gravel.ces','tire_rumble.ces'],
        'assetIds':{},'listeningVerified':False,
        'files':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in (OUT/'roblox/Audio').glob('*.lua')}}
    (OUT/'MANIFEST.json').write_text(json.dumps(manifest,indent=2)+'\n')
    print('Built audio installer;',len(sources),'modules; 272 additional bytes per render packet')
if __name__=='__main__':main()
