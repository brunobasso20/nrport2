"""Oversized metadata must install as bounded scripts and reconstruct the same chunks."""
from pathlib import Path
import os
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
from convert_track import write_visual_luau

class MetadataTests(unittest.TestCase):
    def test_large_single_chunk_is_reassembled_without_loss(self):
        geometry=[{'id':i,'name':'G'+str(i),'source':{'raw':'a'*1000}} for i in range(500)]
        data={'format':'nr2003trackvisual/1','metresPerStud':np.float64(0.28),
              'chunks':[{'name':'large','kind':'walls','file':'glb/large.glb','tris':1000,'geometries':geometry}]}
        (REPO/'work').mkdir(exist_ok=True)
        with tempfile.TemporaryDirectory(dir=REPO/'work') as directory:
            folder=Path(directory);target=folder/'VisualMeta.lua'
            write_visual_luau(data,target)
            parts=list(folder.glob('VisualMetaPart*.lua'))
            self.assertGreater(len(parts),1)
            for p in folder.glob('*.lua'): self.assertLess(p.stat().st_size,199000)
            for p in ET.parse(folder/'WatkinsGlenVisualData.rbxmx').findall('.//ProtectedString'):
                self.assertLess(len(p.text.encode()),199000)
            source=target.read_text()
            driver='''local f=assert(loadstring([====[SOURCE]====]))
setfenv(f,setmetatable({script={Parent={WaitForChild=function(_,name)return name end}},
require=function(name)return require('./'..name)end},{__index=_G}))
local d=f()
assert(#d.chunks==1 and d.chunks[1].name=='large' and d.chunks[1].tris==1000)
assert(#d.chunks[1].geometries==500 and d.metresPerStud==0.28)
for i,g in ipairs(d.chunks[1].geometries)do
 assert(g.id==i-1 and g.name=='G'..(i-1) and #g.source.raw==1000)
end
print('metadata reconstruction passed')
'''.replace('SOURCE',source)
            probe=folder/'probe.luau';probe.write_text(driver)
            luau=os.environ.get('LUAU') or shutil.which('luau')
            self.assertIsNotNone(luau,'Set LUAU or put the Luau CLI on PATH')
            result=subprocess.run([luau,str(probe)],capture_output=True,text=True)
            self.assertEqual(result.returncode,0,result.stdout+result.stderr)

if __name__=='__main__':unittest.main()
