#!/usr/bin/env python3
"""Extract authorized local NR2003 car audio and compile its ORIGINAL CES banks.

No network, Roblox upload, gain normalization, WAV resampling, or self-made
recordings. Loose resource files override DAT entries as in the existing tools.
"""
from pathlib import Path,PurePosixPath
import argparse,hashlib,json,math,struct,sys
from xml.sax.saxutils import escape
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
sys.path.insert(0,str(ROOT/'nr2003carmodel_implementation/pipeline'))
sys.path.insert(0,str(HERE))
from nr2003res.dat import DatArchive
from native_curves import NativeCurves,compile_curve

BANKS=('winston.ces','winston_nf.ces','engvol.ces','tire_asphalt.ces','tire_grass.ces','tire_gravel.ces','tire_rumble.ces')

def safe_name(name):
    name=name.replace('\\','/')
    p=PurePosixPath(name)
    if p.is_absolute() or '..' in p.parts or ':' in name:raise ValueError('Unsafe resource name '+name)
    return str(p).lower()

class Resources:
    def __init__(self,folder):
        self.files={safe_name(str(p.relative_to(folder))):p for p in folder.rglob('*') if p.is_file()}
        self.archives=[(p,DatArchive(p)) for p in sorted(folder.glob('*.dat'))]
        self.used={}
    def get(self,name):
        name=safe_name(name)
        if name in self.files:
            p=self.files[name];data=p.read_bytes();source={'kind':'loose','file':p.name}
        else:
            found=next(((p,z) for p,z in self.archives if name in z),None)
            if found is None:return None
            p,z=found;data=z.read(name);source={'kind':'dat','file':p.name,'entry':name}
        self.used[name]={**source,'bytes':len(data),'sha256':hashlib.sha256(data).hexdigest()}
        return data

class Reader:
    def __init__(self,data):self.data,self.pos=data,0
    def take(self,n):
        if n<0 or self.pos+n>len(self.data):raise ValueError('Truncated CES at byte '+str(self.pos))
        value=self.data[self.pos:self.pos+n];self.pos+=n;return value
    def unpack(self,fmt):return struct.unpack('<'+fmt,self.take(struct.calcsize('<'+fmt)))
    def number(self):
        x=self.unpack('f')[0]
        if not math.isfinite(x):raise ValueError('Non-finite CES value')
        return x

def curve(r,version,native):
    kind=r.unpack('i')[0]
    if kind in (3,4):return {'kind':kind}
    if kind==0:p=[r.number() for _ in range(5)]
    elif kind==1:
        p=[r.number() for _ in range(7 if version>=3 else 6)]
        if version<3:p.append(0)
    elif kind==2:
        # 004e9480 performs TWO 0x30-byte reads into the same struct.
        first=[r.number() for _ in range(12)]
        p=[r.number() for _ in range(12)]
    else:raise ValueError('Unsupported CES response kind '+str(kind))
    out=compile_curve(kind,p,native);out['parameters']=p
    return out

def parse_ces(data,native=None):
    r=Reader(data);version=r.unpack('i')[0]
    if version not in (2,3):raise ValueError('Unsupported CES version '+str(version))
    thresholds=[r.number(),r.number()];engine,gear=[],[]
    for _ in range(8):engine.append(r.number());gear.append(r.number())
    ev=[r.number(),r.number()];gv=[r.number(),r.number()]
    count=r.unpack('i')[0]
    if not 0<=count<=32:raise ValueError('CES sample count exceeds original 32-slot bank')
    samples=[]
    for i in range(count):
        name=safe_name(r.take(64).split(b'\0',1)[0].decode('latin-1'))
        selector,phase,mechanical=r.unpack('3i');enabled=r.unpack('B')[0]!=0
        perspective,group=r.unpack('2i')
        if selector not in (0,1,2) or perspective not in (0,1,2) or mechanical not in (0,1) or not 0<=group<8 or phase not in (0,1,2):
            raise ValueError('Unsupported CES sample selectors at sample '+str(i))
        samples.append({'file':name,'selector':selector,'phase':phase,'mechanical':mechanical,
            'enabled':enabled,'perspective':perspective,'group':group,
            'curves':[curve(r,version,native) for _ in range(4)],'loop':{'wholeFile':phase==0}})
    if r.pos!=len(data):raise ValueError('CES has unparsed trailing bytes; refusing a partial bank')
    return {'version':version,'thresholds':thresholds,'engineRefs':engine,'gearRefs':gear,
        'engineVolume':ev,'gearVolume':gv,'samples':samples}

def wave_info(data):
    if data[:4]!=b'RIFF' or data[8:12]!=b'WAVE':raise ValueError('Expected RIFF/WAVE')
    p=12;out={}
    while p+8<=len(data):
        tag,n=struct.unpack_from('<4sI',data,p);q=p+8
        if q+n>len(data):raise ValueError('Truncated WAVE chunk')
        if tag==b'fmt ' and n>=16:
            encoding,channels,rate,byte_rate,align,bits=struct.unpack_from('<HHIIHH',data,q)
            if not rate or not align:raise ValueError('Invalid WAVE format')
            out.update(encoding=encoding,channels=channels,sampleRate=rate,bits=bits,blockAlign=align)
        if tag==b'data':out['dataBytes']=n
        if tag==b'smpl' and n>=60 and struct.unpack_from('<I',data,q+28)[0]:
            start,end=struct.unpack_from('<II',data,q+44);out['loopSamples']=[start,end+1]
        p=q+n+(n&1)
    if 'sampleRate' not in out or 'dataBytes' not in out:raise ValueError('Missing WAVE fmt/data chunk')
    out['frames']=out['dataBytes']//out['blockAlign'];out['duration']=out['frames']/out['sampleRate']
    if 'loopSamples' in out:
        a,b=out['loopSamples']
        if not 0<=a<b<=out['frames']:raise ValueError('Invalid WAVE loop')
        out['loop']={'startSeconds':a/out['sampleRate'],'endSeconds':b/out['sampleRate']}
    return out

def literal(text):
    eq='='
    while ']'+eq+']' in text:eq+='='
    return '['+eq+'['+text+']'+eq+']'

def binding_xml(config):
    data=json.dumps(config,separators=(',',':'),ensure_ascii=True)
    chunks=[data[i:i+90000] for i in range(0,len(data),90000)]
    source='local p={}\nfor i=1,'+str(len(chunks))+' do p[i]=require(script["Part"..i]) end\nreturn game:GetService("HttpService"):JSONDecode(table.concat(p))\n'
    def module(name,source,children=''):
        return '<Item class="ModuleScript"><Properties><string name="Name">'+escape(name)+'</string><ProtectedString name="Source">'+escape(source)+'</ProtectedString></Properties>'+children+'</Item>'
    children=''.join(module('Part'+str(i+1),'return '+literal(chunk)) for i,chunk in enumerate(chunks))
    install='''return function()
assert(not game:GetService("RunService"):IsRunning(),"Stop Play before linking audio")
local package=assert(game:GetService("ReplicatedStorage"):FindFirstChild("NR2003Lab"),"NR2003Lab missing")
local previous=package:FindFirstChild("AudioAssets")
if previous then
 local backup=Instance.new("Folder");backup.Name="NR2003AudioAssetsBackup_"..game:GetService("HttpService"):GenerateGUID(false)
 backup.Parent=game:GetService("ServerStorage");previous.Parent=backup
end
local assets=script.AudioAssets:Clone();assets.Parent=package
print("Original audio binding linked; missing IDs remain silent. Start a new Play session.")
end
'''
    return '<roblox version="4">'+module('NR2003AudioAssets_Install',install,module('AudioAssets',source,children))+'</roblox>\n'

def main(argv=None):
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--sound-dir',type=Path,required=True)
    ap.add_argument('--out',type=Path,required=True)
    ap.add_argument('--reference-memory',type=Path)
    ap.add_argument('--asset-map',type=Path)
    ap.add_argument('--studio-local',action='store_true',help='Generate private Studio rbxasset paths; no upload')
    a=ap.parse_args(argv);out=a.out.resolve()
    if out.is_relative_to(ROOT.resolve()) and not out.is_relative_to((ROOT/'work').resolve()):
        ap.error('Private original resources must be outside the git checkout, or under ignored work/')
    if not a.sound_dir.is_dir():ap.error('--sound-dir must be your local NR2003 sound directory')
    res=Resources(a.sound_dir)
    if res.get('winston.ces') is None:
        ap.error('Original winston.ces is missing. Supply NR2003/sound with its DAT/loose CES resources; the self-made recording ZIP is not an original bank.')
    native=NativeCurves(a.reference_memory) if a.reference_memory else None
    banks={};missing=[];warnings=[]
    for name in BANKS:
        data=res.get(name)
        if data is None:missing.append(name);continue
        banks[name]=parse_ces(data,native)
    assets={};waves={};asset_ids={}
    if a.asset_map:asset_ids={safe_name(k):v for k,v in json.loads(a.asset_map.read_text()).items()}
    for bank in banks.values():
        for sample in bank['samples']:
            name=sample['file'];data=res.get(name)
            if data is None and not name.endswith('.wav'):
                name+='.wav';data=res.get(name);sample['file']=name
            if data is None:missing.append(name);continue
            info=wave_info(data);waves[name]=info
            sample['durationSeconds']=info['duration']
            if 'loop' in info:sample['loop']=info['loop']
            assets[name]=('rbxasset://sounds/nr2003_reference/'+name) if a.studio_local else asset_ids.get(name)
            p=out/'wav'/name;p.parent.mkdir(parents=True,exist_ok=True);p.write_bytes(data)
    for name in banks:
        p=out/'ces'/name;p.parent.mkdir(parents=True,exist_ok=True);p.write_bytes(res.get(name))
    profile={'banks':banks,'assets':assets,'engineBank':'winston.ces','otherEngineBank':'winston_nf.ces',
        'status':'Original CES controls recovered; listening comparison unverified','referenceOnly':True}
    config={'version':1,'profiles':{'NR2003_ORIGINAL_REFERENCE':profile}}
    out.mkdir(parents=True,exist_ok=True)
    (out/'audio_manifest.json').write_text(json.dumps({'config':config,'sources':res.used,'waves':waves,
        'missing':sorted(set(missing)),'warnings':sorted(set(warnings)),'listeningVerified':False},indent=2)+'\n')
    (out/'asset_ids.json').write_text(json.dumps(assets,indent=2)+'\n')
    (out/'NR2003AudioAssets_Install.rbxmx').write_text(binding_xml(config))
    print(json.dumps({'banks':len(banks),'waves':len(waves),'missing':sorted(set(missing)),
        'unlinked':sum(v is None for v in assets.values()),'warnings':sorted(set(warnings)),
        'output':str(out),'listeningVerified':False},indent=2))
    return 0

if __name__=='__main__':
    try:raise SystemExit(main())
    except (ValueError,ImportError) as e:raise SystemExit(str(e))
