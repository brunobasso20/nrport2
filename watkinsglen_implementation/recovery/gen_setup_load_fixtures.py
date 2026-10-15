"""Independent original 00558830 setup decoder + 00558da0 load validation.

Expected editable values come from the original decoder walking the descriptor
table; they do not use the Python field mapping that generates the Luau presets.
"""
import os
from pathlib import Path
import struct
import sys

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'recovery/stage10'))
import orig_setup as S


def main():
    m=S.boot();S.prepare(m,chassis_type=4);m.fpcw=0x027f
    lines=['-- Independent original binary setup decoder and load validator.','return {']
    for name in ('fast','easy','qualify','jasper'):
        raw=(Path(os.environ['WG_TRACK'])/(name+'.cup.sim')).read_bytes()
        p=raw.index(b'DGTS');version,size=struct.unpack_from('<II',raw,p+4)
        packed=m.alloc(size,raw[p+12:p+12+size])
        assert m.call(0x558830,0,version,packed,size,ecx=S.GARAGE)==size
        assert m.call(0x558da0,ecx=S.GARAGE)
        # RF ride height (37) is a derived output, recomputed by the actual build.
        inputs=[i for i in range(71) if i!=37]
        lines.append(name+'={'+','.join('[%d]=0x%08x'%(i,m.u32(S.GARAGE+4*i)) for i in inputs)+'},')
        assert all(m.u32(S.GARAGE+4*i)==0 for i in (137,138,139,140,149,150,151,152))
    lines+=['}','']
    (ROOT/'watkinsglen_implementation/handling/tests/setup_load_fixtures.lua').write_text('\n'.join(lines))
    print('Original file decoder: 4 setups, 70 input fields each, internal bump-stop fields reset to zero')


if __name__=='__main__':main()
