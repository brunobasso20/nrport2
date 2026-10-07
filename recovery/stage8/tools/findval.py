import struct, sys
from pathlib import Path
MEM = Path(r'..\mem')
pat = struct.pack('<I', int(sys.argv[1], 16))
for line in (MEM / 'blocks.tsv').read_text().splitlines()[1:]:
    name, st, sz, init = line.split('\t'); st = int(st, 16)
    p = MEM / ('%08x.bin' % st)
    if not p.exists(): continue
    b = p.read_bytes(); i = b.find(pat)
    while i >= 0:
        print('%s %08x' % (name, st + i)); i = b.find(pat, i + 1)
