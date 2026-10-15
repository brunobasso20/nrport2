"""Compile the actual XML payloads into a mock runner; run with Luau CLI."""
import argparse
import importlib.util
import json
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT=Path(__file__).resolve().parents[2]
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--studio-dir',type=Path)
args=parser.parse_args()
spec=importlib.util.spec_from_file_location('builder',ROOT/'tools/build_assists.py')
B=importlib.util.module_from_spec(spec);spec.loader.exec_module(B)
manifest=json.loads((ROOT/'recovery/assist_implementation/evidence/installer_manifest.json').read_text())
xml=ET.parse(ROOT/'assist_implementation/NR2003_Assists.rbxmx').getroot().find('Item')
source=lambda item:item.find('Properties/ProtectedString').text
new={item.find('Properties/string').text:source(item) for item in xml.findall('Item')}
apply=source(xml)
rows=[]
for entry in manifest:
    old=B.git_text(B.BASE,entry['path'])
    if old is None: old=''
    payload=new[entry['payload']]
    replacement='('+payload.removeprefix('return ').strip()+')'
    apply=apply.replace('require(script:WaitForChild("'+entry['payload']+'"))',replacement)
    rows.append('{name='+json.dumps(entry['name'])+',parent='+json.dumps(entry['parent'])+',class='+json.dumps(entry['class_name'])+
        ',id='+json.dumps(entry['id'])+',old='+B.literal(old)+',studio='+B.literal(
            (args.studio_dir/f"script-{entry['studio_ref']}.lua").read_text() if args.studio_dir and entry['studio_ref'] else old)+',source='+replacement+'},')
apply=apply.removesuffix('return apply\n')+'apply()\n'
out='local APPLY='+B.literal(apply)+'\nlocal ROLLBACK='+B.literal((ROOT/'assist_implementation/ROLLBACK.lua').read_text())+'\n'
out+='local ENTRIES={'+''.join(rows)+'}\n'
utilities=(ROOT/'tests/patch1201/installer_mock_body.luau').read_text().split('local function fixture(prediction)')[0]
out+=utilities+(ROOT/'tests/assists/installer_mock_body.luau').read_text()
(ROOT/'tests/assists/generated_installer_test.luau').write_text(out)
print('Built actual XML installer mock')
