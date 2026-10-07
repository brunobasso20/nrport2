"""Byte-level xref scan over the NR2003.exe .text dump (absolute operands + call rel32)."""
import sys, struct
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent / 'py'))
import capstone

MEM = Path(sys.argv[1])
if (MEM / '00401000.bin').exists():
    TEXT = (MEM / '00401000.bin').read_bytes(); BASE = 0x401000
else:
    TEXT = (MEM / '00400000.bin').read_bytes(); BASE = 0x400000
md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)

def insn_at(addr):
    """decode the instruction that contains byte addr (try start offsets back to 12 bytes)"""
    best = None
    for back in range(0, 12):
        a = addr - back
        off = a - BASE
        for i in md.disasm(TEXT[off:off + 16], a):
            if i.address <= addr < i.address + i.size:
                best = i
            break
        if best: return best
    return None

def scan_abs(lo, hi):
    out = []
    for a in range(lo, hi + 1, 1):
        pat = struct.pack('<I', a)
        i = TEXT.find(pat)
        while i >= 0:
            ins = insn_at(BASE + i)
            out.append((BASE + i, a, ins))
            i = TEXT.find(pat, i + 1)
    return out

def scan_call(target):
    out = []
    for i in range(len(TEXT) - 5):
        if TEXT[i] == 0xe8:
            rel = struct.unpack('<i', TEXT[i + 1:i + 5])[0]
            if BASE + i + 5 + rel == target: out.append(BASE + i)
    return out

if __name__ == '__main__':
    for arg in sys.argv[2:]:
        if arg.startswith('call:'):
            t = int(arg[5:], 16)
            print('== calls to %08x' % t)
            for a in scan_call(t): print('  %08x' % a)
        else:
            lo, hi = (int(x, 16) for x in arg.split('-')) if '-' in arg else (int(arg, 16),) * 2
            print('== refs %08x-%08x' % (lo, hi))
            for at, a, ins in scan_abs(lo, hi):
                print('  %08x -> %08x  %s' % (at, a, ('%s %s' % (ins.mnemonic, ins.op_str)) if ins else '?'))

