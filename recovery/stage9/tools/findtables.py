"""List .rdata/.data dwords that point into a code range (vtable / callback-table discovery).
python findtables.py <codeLo> <codeHi>   -> address, target, and the slot offset to the nearest preceding
                                             run start (consecutive code pointers)."""
import struct, sys
from nrmem import read

lo, hi = int(sys.argv[1], 16), int(sys.argv[2], 16)
for st, sz in [(0x6e9000, 0x32000), (0x71b000, 0x45000)]:
    data = read(st, sz)
    run_start = None
    for off in range(0, sz - 3, 4):
        v = struct.unpack_from('<I', data, off)[0]
        is_code = 0x401000 <= v < 0x6e9000
        if is_code and run_start is None:
            run_start = st + off
        elif not is_code:
            run_start = None
        if lo <= v < hi:
            print('%08x -> %08x   run %08x slot +0x%x' % (st + off, v, run_start, st + off - run_start))
