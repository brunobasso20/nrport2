"""Execute actual generated installer payloads, including partial Studio-run recovery."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest
import xml.etree.ElementTree as ET

import numpy as np

PIPELINE=Path(__file__).resolve().parents[1]
REPO=PIPELINE.parents[1]
sys.path.insert(0,str(PIPELINE))
from studio_track import installer,lua_number
def to_lua(value):
    if isinstance(value,str):return json.dumps(value)
    if isinstance(value,bool):return 'true' if value else 'false'
    if isinstance(value,(int,float)):return repr(float(value))
    if isinstance(value,list):return '{'+','.join(to_lua(x) for x in value)+'}'
    if isinstance(value,dict):return '{'+','.join(k+'='+to_lua(v) for k,v in value.items())+'}'
    raise TypeError(type(value))

class InstallerTests(unittest.TestCase):
    def test_nonfinite_numbers_are_refused(self):
        for value in (np.float64(float('nan')),float('inf'),float('-inf')):
            with self.assertRaises(ValueError):lua_number(value)

    def test_actual_sources_execute_including_numpy_and_partial_resume(self):
        assets=REPO/'watkinsglen_implementation/assets'
        manifest=json.loads((assets/'manifest.json').read_text())
        sources={}
        for item in ET.parse(assets/'studio/NR2003TrackVisualInstallers.rbxmx').findall('.//Item[@class="ModuleScript"]'):
            props=item.find('Properties')
            sources[props.find('string[@name="Name"]').text]=props.find('ProtectedString[@name="Source"]').text
        def case(c,source):
            return dict(name=c['name'],kind=c['kind'],hash=hashlib.sha256(json.dumps(c,sort_keys=True).encode()).hexdigest(),
                source=source,geometries=[dict(name=g['name'],center=g['center'],size=[b-a for a,b in zip(g['min'],g['max'])]) for g in c['geometries']])
        chunks=sorted(manifest['chunks'],key=lambda c:c['name'])
        cases=[case(c,sources[c['name']]) for c in chunks]
        self.assertEqual(len(cases),88)
        synthetic=json.loads(json.dumps(chunks[4]))
        for g in synthetic['geometries']:
            g['center']=[np.float64(x) for x in g['center']]
            g['opacity']=np.float64(g['opacity'])
        numpy_case=case(synthetic,'return function()\n'+installer(synthetic,manifest['textures'],np.float64(.28))+'\nend\n')
        helpers=(REPO/'tools/adapter_mock_body.luau').read_text().split('-- world: ground plane')[0]
        captured=json.loads((PIPELINE/'tests/fixtures/studio_import_state.json').read_text())
        master=(assets/'studio/INSTALL_ALL_TRACK_VISUALS.lua').read_text()
        runner=helpers+'\nlocal CASES='+to_lua(cases)+'\nlocal NUMPY_CASE='+to_lua(numpy_case)+'\nlocal CAPTURED_STATE='+to_lua(captured)+'\nlocal MASTER_SOURCE='+to_lua(master)+'\n'+(PIPELINE/'tests/visual_installer_mock.luau').read_text()
        (REPO/'work').mkdir(exist_ok=True)
        with tempfile.TemporaryDirectory(dir=REPO/'work') as folder:
            target=Path(folder)/'visual_installers.luau';target.write_text(runner)
            cli=os.environ.get('LUAU') or shutil.which('luau')
            self.assertIsNotNone(cli,'Set LUAU or put luau on PATH')
            result=subprocess.run([cli,str(target)],text=True,capture_output=True)
            self.assertEqual(result.returncode,0,result.stdout+result.stderr)
            print(result.stdout.strip())

if __name__=='__main__':unittest.main()
