import os, sys
from pathlib import Path
HERE = Path(__file__).resolve().parent
import struct, json
from nrx import *
m = Machine()
m.stubs.update({'HeapAlloc': lambda mm,esp:(mm.alloc(max(mm.u32(esp+12),16)),12),'GetProcessHeap': lambda mm,esp:(1,0),'InitializeCriticalSection': lambda mm,esp:(0,4)})
table = [m.u32(a) for a in range(0x71b004, 0x71e7a4, 4)]
for fn in table:
    try: m.call(fn, limit=2_000_000)
    except Exception: pass
open(str(HERE) + '/after_init.bin','wb').write(bytes(m.uc.mem_read(0x400000, 0x1200000-0x400000)))
rows=[]
for i in range(184):
    e = 0xc05150 + 6*i
    typ = struct.unpack('<H', m.uc.mem_read(e,2))[0]; d = m.u32(e+2)
    internal = m.u32(0xc03350+4*i)
    r = {'index':i,'entryType':typ,'desc':hex(d),'internalBits':internal,'internalF':m.f32(0xc03350+4*i)}
    if d:
        dt = struct.unpack('<H', m.uc.mem_read(d,2))[0]; r['descType']=dt
        if dt==3: r.update(min=m.i32(d+2),max=m.i32(d+6),step=m.i32(d+10),default=m.i32(d+14))
        else: r.update(min=m.f32(d+2),max=m.f32(d+6),step=m.f32(d+10),default=m.f32(d+14))
        r['toInternal']=hex(m.u32(d+18)); r['toDisplay']=hex(m.u32(d+22))
        # display value of current internal via toDisplay
        if m.u32(d+22):
            m.call(m.u32(d+22), internal)
            st = m.uc.reg_read(UC_X86_REG_FP0)
            r['displayEAX']=m.uc.reg_read(UC_X86_REG_EAX)
    rows.append(r)
json.dump(rows, open(str(HERE) + '/setup_desc.json','w'), indent=1)
for r in rows:
    if r['desc']!='0x0': print(r['index'], r.get('descType'), r.get('min'), r.get('max'), r.get('step'), r.get('default'), r['internalF'] if r.get('descType')==4 else r['internalBits'], r['toInternal'], r['toDisplay'])
