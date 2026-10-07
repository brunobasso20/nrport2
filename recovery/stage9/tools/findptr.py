"""Find every aligned/unaligned occurrence of 32-bit values in all exported memory blocks
(pointer / vtable / immediate operand search).  python findptr.py <hex> [<hex> ...]
Code hits are decoded with capstone (instruction containing the bytes)."""
import struct, sys
from nrmem import _blocks, read, md

def find(value):
    pat = struct.pack('<I', value)
    hits = []
    for st, sz in _blocks:
        data = read(st, sz)
        i = data.find(pat)
        while i >= 0:
            hits.append(st + i)
            i = data.find(pat, i + 1)
    return hits

def insn_at(addr):
    for back in range(0, 12):
        a = addr - back
        try:
            for ins in md.disasm(read(a, 16), a):
                if ins.address <= addr < ins.address + ins.size:
                    return ins
                break
        except KeyError:
            return None
    return None

if __name__ == '__main__':
    for arg in sys.argv[1:]:
        v = int(arg, 16)
        print('== %08x' % v)
        for h in find(v):
            ins = insn_at(h) if 0x401000 <= h < 0x6e9000 else None
            print('  %08x  %s' % (h, ('%08x %s %s' % (ins.address, ins.mnemonic, ins.op_str)) if ins else 'data'))
