"""Build a source-guarded Studio installer from reviewed sources, with one bounded payload per script."""
import argparse
import json
import subprocess
from pathlib import Path
from xml.sax.saxutils import escape
import zipfile

ROOT=Path(__file__).resolve().parents[1]
BASE='21c52574df3ade197f134d9019a3119260960df0'
OLD='e949f5db1a58508999721cd8bca75c8af20408c4'

def fnv(s):
    h=2166136261
    for b in s.encode(): h=((h^b)*16777619)&0xffffffff
    return h

def literal(s):
    eq='='
    while ']'+eq+']' in s: eq+='='
    return '['+eq+'[\n'+s+']'+eq+']'

def git_text(ref,path):
    result=subprocess.run(['git','show',f'{ref}:{path}'],cwd=ROOT,capture_output=True)
    return result.stdout.decode().replace('\r\n','\n') if result.returncode==0 else None

def item(name,source,children=''):
    return ('<Item class="ModuleScript" referent="RBX_'+name+'"><Properties><string name="Name">'+escape(name)+
        '</string><ProtectedString name="Source">'+escape(source)+'</ProtectedString></Properties>'+children+'</Item>')

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--studio-dir',type=Path,help='Optional read-only script export of supplied atnow.rbxm')
    args=parser.parse_args()
    snapshot=args.studio_dir
    entries=[]
    def add(parent,name,path,ref=None,added=False,cls='ModuleScript',ident=None):
        entries.append(dict(parent=parent,name=name,path=path,ref=ref,added=added,cls=cls,id=ident or name))
    add('core','CupTune','core/CupTune.lua',36)
    add('core','NR2003CupVehicle','core/NR2003CupVehicle.lua',37)
    for name,ref in [('Core',48),('Aero',46),('Garage',47),('Frame',64),('Steering',70),('FFB',71),('Driver',69)]:
        add('cup','NR2003Cup'+name,'core/NR2003Cup/NR2003Cup'+name+'.lua',ref)
    for name in ['Automatic','Assists']:
        add('cup','NR2003Cup'+name,'core/NR2003Cup/NR2003Cup'+name+'.lua',added=True)
    add('cup','NR2003CupTrack','watkinsglen_implementation/core/NR2003Cup/NR2003CupTrack.lua',80,ident='track')
    add('modules','CupChassisAdapter','roblox/CupChassisAdapter.lua',121)
    # Preserve/install the preceding official preset + K/comma update in the supplied Studio state as well.
    add('modules','NR2003WatkinsGlenSetup','roblox/NR2003WatkinsGlenSetup.lua',130)
    add('modules','SetupTestControls','roblox/SetupTestControls.lua',added=True)
    add('starter','NR2003SetupTestBindings','roblox/SetupTestBindings.client.lua',added=True,cls='LocalScript')
    add('modules','PredictionServer','roblox/PredictionServer.lua',137,ident='prediction')
    add('servers','NR2003Server','roblox/Server.server.lua',ident='legacy',cls='Script')
    add('starter','NR2003AssistTelemetry','roblox/AssistTelemetry.client.lua',added=True,cls='LocalScript')
    manifest=[];definitions=[];payloads=[];baselines={}
    for i,e in enumerate(entries,1):
        source=(ROOT/e['path']).read_text().replace('\r\n','\n')
        old=[git_text(ref,e['path']) for ref in [BASE,OLD]]
        if e['ref'] and snapshot: old.append((snapshot/f"script-{e['ref']}.lua").read_text())
        unique={}
        for s in old:
            if s is not None: unique[(len(s.encode()),fnv(s))]=s
        # Future builds use the retained fingerprints, without requiring an untracked Studio export.
        retained=ROOT/'recovery/assist_implementation/evidence/installer_manifest.json'
        if retained.exists():
            for previous in json.loads(retained.read_text()):
                if previous['path']==e['path']:
                    for pair in previous['baselines']: unique.setdefault(tuple(pair),None)
        pairs=list(unique)
        name=f'Source{i}'
        definitions.append('{id='+json.dumps(e['id'])+',parent='+e['parent']+',name='+json.dumps(e['name'])+
            ',class='+json.dumps(e['cls'])+',added='+str(e['added']).lower()+',baselines={'+
            ','.join('{'+str(n)+','+str(h)+'}' for n,h in pairs)+'},source=require(script:WaitForChild("'+name+'"))},')
        payload='return '+literal(source)+'\n'
        assert len(payload.encode())<195000,(e['path'],'payload exceeds conservative script limit')
        payloads.append(item(name,payload))
        manifest.append(dict(path=e['path'],name=e['name'],parent=e['parent'],class_name=e['cls'],id=e['id'],added=e['added'],studio_ref=e['ref'],
            baselines=pairs,bytes=len(source.encode()),fnv=fnv(source),payload=name))
        baselines[e['path']]=next((s for s in unique.values() if s is not None),None)
    apply=(ROOT/'recovery/assist_implementation/installer_template.luau').read_text().replace('-- @SOURCES@','\n'.join(definitions))
    out=ROOT/'assist_implementation';out.mkdir(exist_ok=True)
    (out/'NR2003_Assists.rbxmx').write_text('<roblox version="4">'+item('NR2003_Assists',apply,''.join(payloads))+'</roblox>\n')
    (out/'INSTALL.lua').write_text('-- Insert NR2003_Assists.rbxmx into Workspace, then run in Edit mode:\nrequire(workspace.NR2003_Assists)()\n')
    rollback=(ROOT/'recovery/patch1201/rollback_template.luau').read_text().replace('NR2003Backup_Patch1201','NR2003Backup_Assists').replace('Previous Watkins Glen presets and test controls restored','Previous scripts restored (assist_implementation rolled back)')
    (out/'ROLLBACK.lua').write_text(rollback)
    (ROOT/'recovery/assist_implementation/evidence/installer_manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    if (out/'README.md').exists():
        with zipfile.ZipFile(out/'NR2003_Assist_Implementation.zip','w',zipfile.ZIP_DEFLATED,9) as z:
            for name in ['NR2003_Assists.rbxmx','INSTALL.lua','ROLLBACK.lua','README.md']:
                z.write(out/name,name)
    print('Built',len(entries),'guarded script payloads; original Studio checkpoint changes preserved')

if __name__=='__main__': main()
