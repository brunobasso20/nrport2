"""Verify recovered colour blending and geometric preservation using independent small examples."""
from pathlib import Path
import sys
import tempfile
from types import SimpleNamespace
import unittest
import numpy as np
from PIL import Image

PIPELINE=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(PIPELINE))
from lightmaps import bake, _sample, _tile_geometry

class LightmapTests(unittest.TestCase):
    def quad(self):
        return dict(name='quad',positions=[(0,0,0),(1,0,0),(1,1,0),(0,1,0)],
                    normals=[(0,0,1)]*4,uvs=[(0,0),(1,0),(1,1),(0,1)],tris=[(0,1,2),(0,2,3)],
                    material={'textures':['base.mip',None,'light.mip']},source={'descriptor':42})
    def test_native_modulate_rgb_retains_base_alpha(self):
        channels=[None]*18
        channels[0]=channels[16]=[0,1,1,0]
        channels[1]=channels[17]=[0,0,1,1]
        descriptor=SimpleNamespace(handle=42,w_section=SimpleNamespace(channels=channels))
        with tempfile.TemporaryDirectory() as directory:
            folder=Path(directory)
            Image.new('RGBA',(2,2),(120,90,60,128)).save(folder/'base.png')
            Image.new('RGBA',(2,2),(85,170,255,0)).save(folder/'light.png')
            meta={k:dict(clampU=True,clampV=True) for k in ('base','light')}
            result,report=bake([self.quad()],SimpleNamespace(objects={42:descriptor}),meta,folder)
            self.assertEqual((report['sourceStrips'],report['bakedTextures']),(1,1))
            stem=result[0]['material']['textures'][0].removesuffix('.mip')
            with Image.open(folder/(stem+'.png')) as im:
                self.assertEqual(set(im.getdata()),{(40,60,60,128)})
    def test_uv_tile_clipping_preserves_original_plane_and_area(self):
        areas=[]
        for x in range(2):
            for y in range(2):
                q=_tile_geometry(self.quad(),np.array([x,y])/2,np.array([x+1,y+1])/2,'tile')
                for tri in q['tris']:
                    p=np.array([q['positions'][i] for i in tri])
                    self.assertTrue(np.all(p[:,2]==0))
                    areas.append(np.linalg.norm(np.cross(p[1]-p[0],p[2]-p[0]))/2)
                self.assertTrue(all(0<=v<=1 for uv in q['uvs'] for v in uv))
        self.assertAlmostEqual(sum(areas),1.0,places=14)
    def test_original_wrap_and_clamp_sample_pixel_centres(self):
        pixels=np.array([[(10,0,0,255),(90,0,0,255)],[(20,0,0,255),(80,0,0,255)]],dtype=float)
        uv=np.array([(0.25,0.25),(1.25,0.25)])
        self.assertEqual(_sample(pixels,uv,False,False)[:,0].tolist(),[10,10])
        self.assertEqual(_sample(pixels,uv,True,True)[:,0].tolist(),[10,90])

if __name__=='__main__':unittest.main()
