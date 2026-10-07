"""Disassemble original NR2003.exe bytes from the Ghidra memory export: dis.py start end"""
import sys, struct
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent / 'py'))
import capstone
MEM = Path(__file__).parent / 'mem'
blocks = []
for line in (MEM / 'blocks.tsv').read_text().splitlines()[1:]:
    name, st, sz, init = line.split('\t')
    blocks.append((int(st, 16), int(sz)))
def read(a, n):
    for st, sz in blocks:
        if st <= a < st + sz:
            return (MEM / ('%08x.bin' % st)).read_bytes()[a - st:a - st + n]
    raise KeyError(hex(a))
def f32(a): return struct.unpack('<f', read(a, 4))[0]
def f64(a): return struct.unpack('<d', read(a, 8))[0]
def u32(a): return struct.unpack('<I', read(a, 4))[0]
if __name__ == '__main__':
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    s, e = int(sys.argv[1], 16), int(sys.argv[2], 16)
    for i in md.disasm(read(s, e - s), s):
        extra = ''
        for tok in i.op_str.replace('[', ' ').replace(']', ' ').replace(',', ' ').split():
            if tok.startswith('0x') and len(tok) >= 8:
                try:
                    v = int(tok, 16)
                    extra += '  ; [%x] f32=%g u32=%x' % (v, f32(v), u32(v))
                except Exception: pass
        print('%08x  %-24s %s %s%s' % (i.address, i.bytes.hex(), i.mnemonic, i.op_str, extra))
