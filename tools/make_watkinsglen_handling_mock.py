#!/usr/bin/env python3
"""Exercise the shipped V4 installer followed by the actual handling V5 update."""
import json
from pathlib import Path
import subprocess
import sys
import xml.etree.ElementTree as ET
import zipfile

ROOT=Path(__file__).resolve().parents[1]
prefix=ROOT/'work/handling_audit/full_mock.luau'
subprocess.run([sys.executable,str(ROOT/'tools/make_watkinsglen_installer_mock.py'),'--out',str(prefix)],check=True)
code=prefix.read_text().split('local f=fixture();local H=',1)[0]


def quote(value):
    eq='='
    while ']'+eq+']' in value:eq+='='
    return '['+eq+'[\n'+value+']'+eq+']'


def decode(raw):
    model=ET.fromstring(raw).find('Item')
    templates,payloads={},{}
    def read(node,path=''):
        name=node.find("Properties/string[@name='Name']").text
        source=node.find("Properties/ProtectedString[@name='Source']")
        if source is not None:
            if path.startswith('Sources.') or path=='Sources':payloads[(path+'.'+name).removeprefix('Sources.')]=source.text
            else:templates[name]=source.text
        else:
            for ch in node.findall('Item'):read(ch,(path+'.'+name).strip('.'))
    for node in model.findall('Item'):read(node)
    return templates,payloads


with zipfile.ZipFile(ROOT/'watkinsglen_implementation/downloads/WatkinsGlen_Physics_Installer_V4.zip') as z:
    base=decode(z.read('NR2003_WatkinsGlen_Install.rbxmx'))
delta=decode((ROOT/'watkinsglen_implementation/handling/studio/NR2003_WatkinsGlen_HandlingV5.rbxmx').read_bytes())
for name,values in zip(('BASE_TEMPLATES','BASE_PAYLOADS','DELTA_TEMPLATES','DELTA_PAYLOADS'),(*base,*delta)):
    code+='local '+name+'={}\n'
    for key,value in values.items():code+=name+'['+json.dumps(key)+']='+quote(value)+'\n'
code+=(ROOT/'watkinsglen_implementation/handling/tests/installer_mock_body.luau').read_text()
out=ROOT/'work/handling_audit/handling_mock.luau'
out.write_text(code)
print('Generated actual V4 -> V5 installer test',out)
