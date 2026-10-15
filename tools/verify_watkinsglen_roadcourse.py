#!/usr/bin/env python3
"""Validate the actual shipped road-course update ZIP and compile all Sources."""
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import xml.etree.ElementTree as ET
import zipfile
from build_watkinsglen import ROOT, fingerprint


def main():
    folder=ROOT/'watkinsglen_implementation/roadcourse'
    manifest=json.loads((folder/'studio/manifest.json').read_text())
    path=ROOT/'watkinsglen_implementation/downloads/WatkinsGlen_RoadCourse_Patch_V6.zip'
    model='NR2003_WatkinsGlen_RoadCourseV6'
    with zipfile.ZipFile(path) as z:
        assert z.testzip() is None
        xml=z.read(model+'.rbxmx');assert xml==(folder/'studio'/(model+'.rbxmx')).read_bytes()
        assert 'require(workspace.'+model+'.Apply)()' in z.read('APPLY_ROADCOURSE_V6.lua').decode()
        assert 'README.md' in z.namelist() and 'VALIDATION.md' in z.namelist()
        entries=len(z.namelist())
    root=ET.fromstring(xml).find('Item')
    assert root.attrib['class']=='Model' and root.find("Properties/string[@name='Name']").text==model
    payloads={};sources={}
    def walk(node,prefix=''):
        name=node.find("Properties/string[@name='Name']").text
        source=node.find("Properties/ProtectedString[@name='Source']");key=(prefix+'.'+name).strip('.')
        if source is not None:
            assert node.attrib['class']=='ModuleScript','A payload must not auto-execute'
            text=source.text or '';assert len(text.encode())<199000
            sources[key]=text
            if key.startswith('Sources.'):payloads[key.removeprefix('Sources.')]=text
        for child in node.findall('Item'):walk(child,key)
    for node in root.findall('Item'):walk(node)
    assert 'Watkins Glen V6 installed:' in sources['Apply'] and 'Watkins Glen V5 installed:' not in sources['Apply']
    assert set(payloads)=={t['key'] for t in manifest['targets']}
    for t in manifest['targets']:
        assert fingerprint(payloads[t['key']])==t['new']
        assert payloads[t['key']]==(ROOT/t['file']).read_text()
        assert not t['key'].startswith('Server.') and 'CupTune' not in t['key']
    for n in ('Core.NR2003Cup.NR2003CupWatkinsGlenSpec','Core.NR2003Cup.NR2003CupJITWG1',
              'Core.NR2003CupVehicle','Core.NR2003Cup.NR2003CupBuild','Core.NR2003Cup.NR2003CupGarage'):
        assert n in payloads
    compiler=shutil.which('luau-compile') or '/workspace/.nrport2-cloud/bin/luau-compile'
    scratch=ROOT/'work/feeling_v5/compile';scratch.mkdir(parents=True,exist_ok=True)
    for i,text in enumerate(sources.values()):
        f=scratch/(str(i)+'.lua');f.write_text(text)
        r=subprocess.run([compiler,str(f)],stdout=subprocess.DEVNULL,stderr=subprocess.PIPE,text=True)
        assert r.returncode==0,r.stderr
    report={'file':path.name,'model':model,'bytes':path.stat().st_size,
            'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'targets':len(payloads),
            'compiledXMLSources':len(sources),'largestSourceBytes':max(len(s.encode()) for s in sources.values()),
            'zipEntries':entries,'zipCRCVerified':True,'sourceFingerprintsVerified':True,'bundle':manifest['bundle']}
    (folder/'package_info.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))

if __name__=='__main__':main()
