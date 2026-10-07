"""Locate float32/float64 constants in .rdata/.data (within a relative tolerance) and list the .text
instructions that reference those addresses as absolute operands.
python findconst.py 0.44704 1.225 287.05 ..."""
import struct, sys
from nrmem import read
from findptr import find

RANGES = [(0x6e9000, 0x32000), (0x71b000, 0x45000)]
text = read(0x401000, 0x2e8000)

def refs(addr):
    out = []
    pat = struct.pack('<I', addr)
    i = text.find(pat)
    while i >= 0:
        out.append(0x401000 + i)
        i = text.find(pat, i + 1)
    return out

for arg in sys.argv[1:]:
    x = float(arg)
    tol = abs(x) * 2e-6 + 1e-12
    print('== %s' % arg)
    for st, sz in RANGES:
        data = read(st, sz)
        for off in range(0, sz - 3):
            v32 = struct.unpack_from('<f', data, off)[0]
            if abs(v32 - x) <= tol and off % 4 == 0:
                print('  f32 @%08x = %.9g  refs %s' % (st + off, v32, ' '.join('%08x' % r for r in refs(st + off))))
            if off + 8 <= sz and off % 4 == 0:
                v64 = struct.unpack_from('<d', data, off)[0]
                if abs(v64 - x) <= tol:
                    print('  f64 @%08x = %.17g  refs %s' % (st + off, v64, ' '.join('%08x' % r for r in refs(st + off))))
