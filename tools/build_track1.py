"""Build a small, additive Studio installer and reversible patch for vis/col.

The adapter source is patched at checked insertion points in Studio; existing
prediction/assist/local changes outside those points are kept verbatim.
"""
from pathlib import Path
from xml.sax.saxutils import escape
import hashlib,json,zipfile
from track1_patch_rules import ADAPTER_RULES,HUD_RULE,patch_adapter

ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'track1_implementation'

def literal(text):
    eq='='
    while ']'+eq+']' in text: eq+='='
    return '['+eq+'[\n'+text+']'+eq+']'

def module(name,source,children=''):
    assert len(source.encode())<195000,(name,'Source exceeds Studio conservative limit')
    return ('<Item class="ModuleScript" referent="TRACK1_'+name+'"><Properties>'
            '<string name="Name">'+escape(name)+'</string><ProtectedString name="Source">'+escape(source)+
            '</ProtectedString></Properties>'+children+'</Item>')

def main():
    OUT.mkdir(exist_ok=True)
    adapter=ROOT/'roblox/CupChassisAdapter.lua'
    assert patch_adapter(adapter.read_text())==adapter.read_text(),'Apply track1_patch_rules.py first'
    for name in ('default.project.json','watkinsglen.project.json'):
        data=json.loads((ROOT/name).read_text())
        data['tree']['ReplicatedStorage']['NR2003Lab']['Roblox']['NR2003Track1']={'$path':'roblox/NR2003Track1.lua'}
        (ROOT/name).write_text(json.dumps(data,indent=2)+'\n')
    client=ROOT/'nr2003carmodel_implementation/roblox/Bench/Client.client.lua'
    source=client.read_text()
    if HUD_RULE[0] in source:
        assert source.count(HUD_RULE[0])==1
        client.write_text(source.replace(*HUD_RULE),encoding='utf-8',newline='\n')
    journal=(OUT/'studio/transaction.lua').read_text()
    children=module('Journal',journal)
    for name,path in [('SurfaceSource','core/NR2003Track1Surface.lua'),('HostSource','roblox/NR2003Track1.lua')]:
        children+=module(name,'return '+literal((ROOT/path).read_text())+'\n')
    rules='return {\n'+',\n'.join('{'+','.join(literal(v) for v in rule)+'}' for rule in ADAPTER_RULES)+'\n}\n'
    children+=module('Rules',rules)
    children+=module('HudRule','return {'+','.join(literal(v) for v in HUD_RULE)+'}\n')
    source=(OUT/'studio/installer_template.luau').read_text()
    (OUT/'NR2003_Track1.rbxmx').write_text('<roblox version="4">'+module('NR2003_Track1',source,children)+'</roblox>\n')
    (OUT/'INSTALL.lua').write_text('-- Stop Play, insert NR2003_Track1.rbxmx into Workspace, then run:\nrequire(workspace.NR2003_Track1)()\n')
    (OUT/'ROLLBACK.lua').write_text('-- Stop Play. Restore only the changes made by the track1 installer.\nlocal Transaction=(function()\n'+journal+'\nend)()\nTransaction.rollback()\n')
    names=['NR2003_Track1.rbxmx','INSTALL.lua','ROLLBACK.lua','DIAGNOSE.lua','APPLY_SURFACE_SELECTED.lua',
           'README.md','VALIDACAO.md','SURFACES.md']
    available=[OUT/name for name in names if (OUT/name).is_file()]
    manifest={'base_branch':'assist_implementation','base_commit':'0731d03ce0086a0b68025ed600ff4957a426f933',
              'files':[{"name":p.name,"bytes":p.stat().st_size,"sha256":hashlib.sha256(p.read_bytes()).hexdigest()} for p in available]}
    (OUT/'MANIFEST.json').write_text(json.dumps(manifest,indent=2)+'\n')
    archive=OUT/'NR2003_TRACK1_PATCH.zip'
    with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED,9) as z:
        for p in available+[OUT/'MANIFEST.json']: z.write(p,p.name)
    print('Built',archive.relative_to(ROOT),archive.stat().st_size,'bytes')

if __name__=='__main__':main()
