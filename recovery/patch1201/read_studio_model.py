"""Read-only RBXM source/property inventory for the supplied Studio snapshot.

Usage: python read_studio_model.py input.rbxm NEW_SCRATCH_DIRECTORY
Requires lz4 and zstandard. Does not execute scripts or use embedded names as
filesystem paths. Sources are materialized as numeric script-<referent>.lua.
"""
import json, struct, sys, hashlib
from pathlib import Path
import lz4.block, zstandard

source = Path(sys.argv[1])
out = Path(sys.argv[2]); out.mkdir(parents=True, exist_ok=False)
raw = source.read_bytes()
assert raw[:14] == b'<roblox!\x89\xff\r\n\x1a\n'
classes, objects, shared, chunks = {}, {}, [], []
def u32(data, off): return struct.unpack_from('<I', data, off)[0]
def string(data, off):
    n=u32(data,off); return data[off+4:off+4+n], off+4+n
def integers(data, n, signed=False, delta=False):
    assert len(data)>=n*4
    values=[]; acc=0
    for i in range(n):
        value=(data[i]<<24)|(data[n+i]<<16)|(data[2*n+i]<<8)|data[3*n+i]
        if signed:value=(value>>1)^-(value&1)
        if delta:acc+=value;value=acc
        values.append(value)
    return values
i=32
while i<len(raw):
    tag, compressed, size, _ = struct.unpack_from('<4sIII',raw,i)
    payload=raw[i+16:i+16+(compressed or size)]
    if compressed:
        payload=(zstandard.ZstdDecompressor().decompress(payload,max_output_size=size)
                 if payload.startswith(b'\x28\xb5\x2f\xfd') else lz4.block.decompress(payload,uncompressed_size=size))
    assert len(payload)==size
    chunks.append((tag,payload));i+=16+(compressed or size)
    if tag==b'END\0':break
for tag,p in chunks:
    if tag==b'SSTR':
        off=8
        for _ in range(u32(p,4)):
            value,off=string(p,off+16);shared.append(value)
    if tag==b'INST':
        cid=u32(p,0);name,off=string(p,4);fmt=p[off];n=u32(p,off+1)
        refs=integers(p[off+5:],n,True,True)
        classes[cid]=dict(name=name.decode(),refs=refs)
        for ref in refs:objects[ref]=dict(class_name=name.decode(),properties={})
types={}
for tag,p in chunks:
    if tag==b'PROP':
        cid=u32(p,0);name,off=string(p,4);name=name.decode();kind=p[off];data=p[off+1:]
        refs=classes[cid]['refs'];n=len(refs);values=None;types[name]=kind
        if kind==1:
            values=[];off=0
            for _ in refs:value,off=string(data,off);values.append(value)
        elif kind==2:values=[bool(v) for v in data[:n]]
        elif kind==3:values=integers(data,n,True)
        elif kind==4:
            values=[]
            for v in integers(data,n):
                bits=(v>>1)|((v&1)<<31);values.append(struct.unpack('<f',struct.pack('<I',bits))[0])
        elif kind==5:values=list(struct.unpack('<'+'d'*n,data))
        elif kind==0x1c:values=[shared[x] for x in integers(data,n)]
        if values is not None:
            for ref,value in zip(refs,values):objects[ref]['properties'][name]=value
    if tag==b'PRNT':
        n=u32(p,1);children=integers(p[5:],n,True,True);parents=integers(p[5+4*n:],n,True,True)
        for child,parent in zip(children,parents):objects[child]['parent']=parent
def path(ref,seen=None):
    seen=set() if seen is None else seen
    if ref<0:return ''
    assert ref not in seen;seen.add(ref)
    obj=objects[ref];p=path(obj.get('parent',-1),seen)
    name=obj['properties'].get('Name',obj['class_name'])
    if isinstance(name,bytes):name=name.decode('utf-8','replace')
    return p+'/'+name
scripts=[];instances=[]
for ref,obj in objects.items():
    props=obj['properties'];location=path(ref)
    values={k:(v.decode('utf-8','replace') if isinstance(v,bytes) else v)
            for k,v in props.items() if k not in ('Source','AttributesSerialize','Tags')}
    if props.get('AttributesSerialize'):
        values['AttributesSerialize_hex']=props['AttributesSerialize'].hex()
    instances.append(dict(ref=ref,path=location,class_name=obj['class_name'],properties=values))
    if 'Source' in props:
        text=props['Source'];name=f'script-{ref}.lua';(out/name).write_bytes(text)
        scripts.append(dict(ref=ref,path=location,class_name=obj['class_name'],file=name,bytes=len(text),sha256=hashlib.sha256(text).hexdigest(),disabled=props.get('Disabled')))
report=dict(sha256=hashlib.sha256(raw).hexdigest(),instances=len(objects),classes={str(k):v['name'] for k,v in classes.items()},scripts=scripts,property_types=types)
(out/'scripts.json').write_text(json.dumps(report,indent=2))
(out/'instances.json').write_text(json.dumps(instances,indent=2))
print('instances',len(objects),'scripts',len(scripts),'classes',report['classes'])
for script in scripts:print(script['ref'],script['path'],script['bytes'])
