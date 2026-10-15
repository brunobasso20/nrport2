#!/usr/bin/env python3
"""Verify both actual distributable V5 ZIPs and compile every XML Source."""
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import xml.etree.ElementTree as ET
import zipfile

from build_watkinsglen import ROOT, fingerprint


def main():
    compiler=shutil.which('luau-compile') or '/workspace/.nrport2-cloud/bin/luau-compile'
    scratch=ROOT/'work/handling_audit/compile';scratch.mkdir(parents=True,exist_ok=True)
    reports=[]
    for folder,archive,model,command in (
        ('studio','WatkinsGlen_Physics_Installer_V5.zip','NR2003_WatkinsGlen_InstallV5','INSTALL_WATKINSGLEN_V5.lua'),
        ('handling/studio','WatkinsGlen_Handling_Patch_V5.zip','NR2003_WatkinsGlen_HandlingV5','APPLY_HANDLING_V5.lua')):
        directory=ROOT/'watkinsglen_implementation'/folder
        manifest=json.loads((directory/'manifest.json').read_text())
        path=ROOT/'watkinsglen_implementation/downloads'/archive
        with zipfile.ZipFile(path) as z:
            assert z.testzip() is None
            xml=z.read(model+'.rbxmx')
            assert xml==(directory/(model+'.rbxmx')).read_bytes()
            cmd=z.read(command).decode()
            assert 'require(workspace.'+model+'.Apply)()' in cmd
            assert 'InstallV1' not in cmd and 'InstallV4' not in cmd
            entries=len(z.infolist())
        root=ET.fromstring(xml).find('Item')
        assert root.attrib['class']=='Model'
        assert root.find("Properties/string[@name='Name']").text==model
        payloads={};sources=[]
        def walk(node,prefix=''):
            name=node.find("Properties/string[@name='Name']").text
            source=node.find("Properties/ProtectedString[@name='Source']")
            key=(prefix+'.'+name).strip('.')
            if source is not None:
                assert node.attrib['class']=='ModuleScript','An installer payload must not execute as a Script'
                text=source.text or ''
                assert len(text.encode())<199000
                sources.append(text)
                if key.startswith('Sources.'):payloads[key.removeprefix('Sources.')]=text
            for child in node.findall('Item'):walk(child,key)
        for node in root.findall('Item'):walk(node)
        assert set(payloads)=={t['key'] for t in manifest['targets']}
        for target in manifest['targets']:
            assert fingerprint(payloads[target['key']])==target['new']
            assert not target['key'].startswith('Server.')
        for i,source in enumerate(sources):
            f=scratch/(model+'_'+str(i)+'.lua');f.write_text(source)
            result=subprocess.run([compiler,str(f)],stdout=subprocess.DEVNULL,stderr=subprocess.PIPE,text=True)
            assert result.returncode==0,result.stderr
        reports.append({'file':archive,'model':model,'bytes':path.stat().st_size,
                        'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),
                        'targets':len(manifest['targets']),'compiledXMLSources':len(sources),
                        'largestSourceBytes':max(len(s.encode()) for s in sources),'zipEntries':entries,
                        'zipCRCVerified':True,'sourceFingerprintsVerified':True,'bundle':manifest['bundle']})
    assert reports[1]['targets']==8
    out=ROOT/'watkinsglen_implementation/handling/package_info.json'
    out.write_text(json.dumps(reports,indent=2)+'\n')
    print(json.dumps(reports,indent=2))


if __name__=='__main__':main()
