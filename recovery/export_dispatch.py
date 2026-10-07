"""Decode static dispatch slots and a source-derived call graph from included exports."""
from pathlib import Path
import struct,csv,json,re
root=Path(__file__).resolve().parent/'vehicle_core'
memory=[(int(p.stem,16),p.read_bytes()) for p in root.glob('*.bin')]
def u32(address):
    for base,data in memory:
        if base<=address<base+len(data)-3:return struct.unpack_from('<I',data,address-base)[0]
    raise ValueError(hex(address))
rows=[]
for mode,b,u in [(0,0x74fdac,0x74fdbc),(1,0x74fde0,0x74fdf0),(2,0x74fe14,0x74fe24)]:
    for kind,base,ops in [('binary',b,['add','wrapped_angle_add','subtract','multiply']),
        ('unary',u,['copy','negate','reciprocal','sqrt','sin','cos','accumulate','min_zero','abs'])]:
        for index,op in enumerate(ops):rows.append(dict(assigned_by='0057dcd0',mode=mode,kind=kind,slot=f'{base+index*4:08x}',operation=op,target=f'{u32(base+index*4):08x}',confidence='table bytes + selector'))
for i in range(4):
    a=0x74e86c+i*4;rows.append(dict(assigned_by='static table',mode='vehicle',kind='brake_output',slot=f'{a:08x}',operation=f'wheel_{i}',target=f'{u32(a):08x}',confidence='005610b0 + table bytes'))
with (root/'dispatch.csv').open('w',newline='') as f:
    w=csv.DictWriter(f,fieldnames=rows[0].keys());w.writeheader();w.writerows(rows)
generated=[('00e84548','005b39a0','predict'),('00e84498','005b3180 + 0055e410','solve/contact preparation'),
    ('00e84b90[0..3]','0055d9c0','per-wheel kernel'),('00e84bdc','005b3990','forces'),('00e84ba0','005b3e50','correct'),('00e84604','005b2fb0','commit')]
(root/'generated_callbacks.json').write_text(json.dumps([dict(pointer=p,builder=b,role=r,assigned_by='005b3090',allocation='005b9cf0',execute='005b9d10',target='runtime generated') for p,b,r in generated],indent=2)+'\n')
functions={}
for p in sorted(root.glob('*.c')):
    # Symbol references, including callbacks; not fabricated Ghidra xref metadata.
    targets=sorted(set(re.findall(r'(?:FUN|LAB|recovered)_([0-9a-f]{8})',p.read_text()))-{p.stem})
    functions[p.stem]={'referencedFunctionSymbols':targets,'method':'decompiled symbol references','missingExports':[a for a in targets if not (root/(a+'.c')).exists()]}
(root/'call_graph.json').write_text(json.dumps(functions,indent=2)+'\n')
print('Decoded 43 dispatch slots, 6 generated pointers and',len(functions),'function symbol records')
