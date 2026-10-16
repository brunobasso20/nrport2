from pathlib import Path
import importlib.util,io,json,struct,sys,tempfile,unittest,wave,xml.etree.ElementTree as ET
HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE.parent/'pipeline'))
sys.path.insert(0,str(HERE.parent/'tools'))
import import_original as imp
from patch_rules import patch,rules

def fixture_ces(kind=0):
    header=struct.pack('<i2f',3,0,0)+struct.pack('<16f',*([4000,2000]*8))+struct.pack('<4fi',0,1,0,1,1)
    sample=b'fixture.wav'.ljust(64,b'\0')+struct.pack('<3iB2i',0,0,0,1,0,0)
    curve=struct.pack('<i5f',0,0,0,10000,1,0) if kind==0 else struct.pack('<i7f',1,5000,1000,0,0,1000,1,0)
    return header+sample+curve+struct.pack('<3i',4,4,4)

class PipelineTests(unittest.TestCase):
    def test_bank_layout(self):
        b=imp.parse_ces(fixture_ces())
        self.assertEqual(b['engineRefs'],[4000]*8);self.assertEqual(b['gearRefs'],[2000]*8)
        self.assertEqual(b['samples'][0]['curves'][0]['slope'],imp.compile_curve(0,[0,0,10000,1,0])['slope'])
    def test_incomplete_and_unknown_banks(self):
        for data in [fixture_ces()[:-1],fixture_ces()+b'extra',struct.pack('<i',99)]:
            with self.assertRaises(ValueError):imp.parse_ces(data)
    def test_no_guessed_nonlinear_curves(self):
        with self.assertRaisesRegex(ValueError,'reference-memory'):imp.parse_ces(fixture_ces(1))
    def test_path_traversal(self):
        for name in ['../secret.wav','/tmp/audio.wav','C:\\a.wav']:
            with self.assertRaises(ValueError):imp.safe_name(name)
    def test_wav_preserved_and_binding(self):
        with tempfile.TemporaryDirectory() as td:
            root=Path(td);sound=root/'sound';sound.mkdir();out=root/'out'
            (sound/'winston.ces').write_bytes(fixture_ces())
            with wave.open(str(sound/'fixture.wav'),'wb') as w:
                w.setnchannels(1);w.setsampwidth(2);w.setframerate(22050);w.writeframes(b'\0\0'*2205)
            original=(sound/'fixture.wav').read_bytes()
            imp.main(['--sound-dir',str(sound),'--out',str(out),'--studio-local'])
            self.assertEqual((out/'wav/fixture.wav').read_bytes(),original)
            manifest=json.loads((out/'audio_manifest.json').read_text())
            self.assertFalse(manifest['listeningVerified'])
            self.assertEqual(manifest['waves']['fixture.wav']['sampleRate'],22050)
            self.assertIn('winston_nf.ces',manifest['missing'])
            ET.parse(out/'NR2003AudioAssets_Install.rbxmx')
    def test_selfmade_folder_is_not_an_original_bank(self):
        with tempfile.TemporaryDirectory() as td:
            with self.assertRaises(SystemExit):imp.main(['--sound-dir',td,'--out',str(Path(td)/'out')])
    def test_hooks_preserve_user_changes(self):
        root=HERE.parents[1]
        for kind,name in [('server','Server.server.lua'),('client','Client.client.lua')]:
            source=(root/'nr2003carmodel_implementation/roblox/Bench'/name).read_text()
            self.assertEqual(patch(source,kind),source)
            self.assertEqual(patch(source+'\n-- user-specific code\n',kind),source+'\n-- user-specific code\n')
            before=source
            for _,old,new in reversed(rules(kind,'local carModel' in source)):before=before.replace(new,old,1)
            self.assertEqual(patch(before,kind),source)
            with self.assertRaises(ValueError):patch('-- unsupported script',kind)
    def test_xml_payload_matches_sources(self):
        root=HERE.parent
        xml=ET.parse(root/'NR2003_Audio_Install.rbxmx')
        items={p.find('./Properties/string').text:p.find('./Properties/ProtectedString').text for p in xml.findall('.//Item')}
        self.assertEqual(items['NR2003_Audio_Install'],(root/'studio/installer.luau').read_text())
        self.assertEqual(items['Journal'],(root/'studio/transaction.lua').read_text())
        for p in (root/'roblox/Audio').glob('*.lua'):self.assertIn(p.read_text(),items['Sources'])

if __name__=='__main__':unittest.main()
