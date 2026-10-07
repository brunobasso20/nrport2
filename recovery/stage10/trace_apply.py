"""Memory footprint of the ORIGINAL setup application sequence (orig_setup.apply): every dword in the
Luau memory range [0x6e9000, 0xf80000) classified by its first access (read-before-write = input the Luau
rebuild must restore from the pre-application snapshot; write-first = output)."""
import sys, pickle
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import orig_setup as OS
from unicorn import *
LO, HI = 0x6e9000, 0xf80000

def trace(items=None, control=None):
    """control(m): installs emitter controls after prepare (generic structure, see gen_build10.py)"""
    m = OS.boot(); OS.prepare(m)
    P = OS.snapshot(m)
    if control is not None: control(m)
    first = bytearray((HI - LO) // 4)
    def rd(uc, access, addr, size, value, ud):
        if LO <= addr < HI:
            for a in range(addr & ~3, addr + size, 4):
                k = (a - LO) >> 2
                if 0 <= k < len(first) and not first[k]: first[k] = 1
    def wr(uc, access, addr, size, value, ud):
        if LO <= addr < HI:
            for a in range(addr & ~3, addr + size, 4):
                k = (a - LO) >> 2
                if 0 <= k < len(first) and not first[k]:
                    # partial dword writes keep the other bytes: treat as input
                    first[k] = 2 if (size >= 4 and a >= addr and a + 4 <= addr + size) else 1
    indirect = set(); pend = [None]
    def code(uc, addr, size, ud):
        if pend[0] is not None:
            indirect.add(addr); pend[0] = None
        if size >= 2:
            b = uc.mem_read(addr, 2)
            if b[0] == 0xff and (b[1] >> 3) & 7 == 2: pend[0] = addr      # call r/m32
    h0 = m.uc.hook_add(UC_HOOK_CODE, code, begin=0x401000, end=0x6e8fff)
    h1 = m.uc.hook_add(UC_HOOK_MEM_READ, rd)
    h2 = m.uc.hook_add(UC_HOOK_MEM_WRITE, wr)
    m.uc.ctl_flush_tb()   # Unicorn keeps translated blocks: hooks only instrument blocks translated after this
    OS.apply(m, items or {})
    m.uc.hook_del(h0); m.uc.hook_del(h1); m.uc.hook_del(h2)
    Q = OS.snapshot(m)
    trace.indirect = sorted(indirect)
    return P, Q, first

if __name__ == '__main__':
    P, Q, first = trace()
    nread = sum(1 for x in first if x == 1); nw = sum(1 for x in first if x == 2)
    print('read-first dwords', nread, 'write-first dwords', nw)
    # regions
    import collections
    reg = collections.Counter()
    for k, x in enumerate(first):
        if x: reg[(x, (LO + 4 * k) >> 16)] += 1
    for (x, r), n in sorted(reg.items()): print('RW'[x - 1], '%04x0000' % r, n)
    pickle.dump((P, Q, bytes(first)), open(sys.argv[1] if len(sys.argv) > 1 else 'apply_trace.pkl', 'wb'))
