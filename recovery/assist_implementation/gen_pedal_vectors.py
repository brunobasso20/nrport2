"""Run original 1.2.0.1 throttle/TC and stability routines, never the Luau implementation."""
import itertools
import json
import struct
import sys
from pathlib import Path

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'recovery/stage12'))
import orig_stage12 as O
import scenarios12 as S
from gen_units12 import f32down_exact

def lua(x):
    if isinstance(x,list): return '{'+','.join(map(lua,x))+'}'
    if isinstance(x,dict): return '{'+','.join('['+json.dumps(k)+']='+lua(v) for k,v in x.items())+'}'
    return repr(x)

def main():
    m=S.make('keys').m
    stub=0xf7f0c0
    m.uc.mem_write(stub,b'\xe8'+struct.pack('<i',0x552df0-stub-5)+b'\xdb\x3d'+struct.pack('<I',O.RES)+b'\xc3')
    rows=[]
    for aid,disabled,digital,gear,speed,previous,raw,slip in itertools.product(
        [0,1],[0,1],[0,1],[1,2],[0,2,10,25,60],[0,.3,.8],[0,1],[0,.15,1]):
        m.uc.mem_write(0xbf6f05,bytes([aid]))
        m.w32(O.SETTINGS+0x4c,0x20000000 if disabled else 0)
        m.w32(0x74c97c,gear)
        O.speed_state(m,speed)
        m.wf(0xbf6390,previous)
        O.OB.control_cells(m,5,raw,bool(digital))
        O.OB.control_cells(m,6,1-raw,bool(digital))
        m.wf(0xbf63a4,0);m.wf(0xbf63a8,0)
        m.wf(0xbf513e,slip);m.wf(0xbf5b77,-slip*.8)
        result=O.call_x80(m,stub)
        rows.append([aid,disabled,digital,gear,speed,previous,raw,slip,f32down_exact(result),m.uc.mem_read(0xbf6eba,1)[0]])
    data={'throttle':rows}
    out=ROOT/'tests/assists';out.mkdir(parents=True,exist_ok=True)
    (out/'pedal_vectors.lua').write_text('-- Generated from original x86 00552df0 under CW 077f.\nreturn '+lua(data)+'\n')
    (ROOT/'recovery/assist_implementation/pedal_vectors.json').write_text(json.dumps(data,separators=(',',':'))+'\n')
    print('Original throttle/TC vectors:',len(rows))

if __name__=='__main__': main()
