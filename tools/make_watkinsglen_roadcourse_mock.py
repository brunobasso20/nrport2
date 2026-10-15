#!/usr/bin/env python3
"""Run the shipped V4 -> shipped V5 -> actual V6 installer, plus fresh V5 -> V6."""
import json
from pathlib import Path
import subprocess
import sys
import xml.etree.ElementTree as ET
import zipfile
ROOT=Path(__file__).resolve().parents[1]
prefix=ROOT/'work/feeling_v5/full_mock.luau'
subprocess.run([sys.executable,str(ROOT/'tools/make_watkinsglen_installer_mock.py'),'--out',str(prefix)],check=True)
code=prefix.read_text().split('local f=fixture();local H=',1)[0]
def quote(value):
    eq='='
    while ']'+eq+']' in value:eq+='='
    return '['+eq+'[\n'+value+']'+eq+']'
def decode(raw):
    model=ET.fromstring(raw).find('Item');templates,payloads={},{}
    def read(node,path=''):
        name=node.find("Properties/string[@name='Name']").text;source=node.find("Properties/ProtectedString[@name='Source']")
        if source is not None:
            if path.startswith('Sources.') or path=='Sources':payloads[(path+'.'+name).removeprefix('Sources.')]=source.text
            else:templates[name]=source.text
        else:
            for ch in node.findall('Item'):read(ch,(path+'.'+name).strip('.'))
    for node in model.findall('Item'):read(node)
    return templates,payloads
for tag,archive,model in [('BASE4','WatkinsGlen_Physics_Installer_V4.zip','NR2003_WatkinsGlen_Install'),
                          ('BASE5','WatkinsGlen_Handling_Patch_V5.zip','NR2003_WatkinsGlen_HandlingV5'),
                          ('FULL5','WatkinsGlen_Physics_Installer_V5.zip','NR2003_WatkinsGlen_InstallV5'),
                          ('DELTA','WatkinsGlen_RoadCourse_Patch_V6.zip','NR2003_WatkinsGlen_RoadCourseV6')]:
    with zipfile.ZipFile(ROOT/'watkinsglen_implementation/downloads'/archive) as z:values=decode(z.read(model+'.rbxmx'))
    for suffix,table in zip(('TEMPLATES','PAYLOADS'),values):
        var=tag+'_'+suffix;code+='local '+var+'={}\n'
        for key,value in table.items():code+=var+'['+json.dumps(key)+']='+quote(value)+'\n'
code+=(ROOT/'watkinsglen_implementation/roadcourse/tests/installer_mock_body.luau').read_text()
out=ROOT/'work/feeling_v5/installer_mock.luau';out.write_text(code)
print('Generated actual V6 update transaction tests',out)
