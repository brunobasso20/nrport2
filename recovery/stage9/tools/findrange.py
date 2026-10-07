"""Find 32-bit immediates/pointers in .text whose value lies in [lo, hi) (e.g. a vtable base written by a
constructor, or any pointer into a table).  python findrange.py <lo> <hi>"""
import struct, sys
from nrmem import read
from findptr import insn_at

lo, hi = int(sys.argv[1], 16), int(sys.argv[2], 16)
text = read(0x401000, 0x2e8000)
seen = set()
for i in range(len(text) - 3):
    v = struct.unpack_from('<I', text, i)[0]
    if lo <= v < hi:
        ins = insn_at(0x401000 + i)
        if ins is None or ins.address in seen:
            continue
        seen.add(ins.address)
        print('%08x  -> %08x  %s %s' % (ins.address, v, ins.mnemonic, ins.op_str))
