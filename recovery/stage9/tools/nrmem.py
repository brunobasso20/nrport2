"""Static access to the NR2003.exe memory image exported by ExportMemoryPy.py (no emulation).
Usage as a script:
    python nrmem.py dis <start> [end]        disassemble (stops at ret when no end) with constant values
    python nrmem.py f32 <addr> [count]       dump floats
    python nrmem.py u32 <addr> [count]       dump dwords
Environment: NR2003_MEM = ExportMemoryPy.py output dir, CAPSTONE_PY = capstone site dir."""
import os, sys, struct
from pathlib import Path
sys.path.insert(0, os.environ.get('CAPSTONE_PY', ''))
import capstone

MEM = Path(os.environ.get('NR2003_MEM', 'mem'))
_blocks = []
for _line in (MEM / 'blocks.tsv').read_text().splitlines()[1:]:
    _name, _st, _sz, _init = _line.split('\t')
    _blocks.append((int(_st, 16), int(_sz)))
_cache = {}


def read(a, n):
    for st, sz in _blocks:
        if st <= a < st + sz:
            if st not in _cache:
                _cache[st] = (MEM / ('%08x.bin' % st)).read_bytes()
            return _cache[st][a - st:a - st + n]
    raise KeyError(hex(a))


def f32(a): return struct.unpack('<f', read(a, 4))[0]
def f64(a): return struct.unpack('<d', read(a, 8))[0]
def u32(a): return struct.unpack('<I', read(a, 4))[0]
def i32(a): return struct.unpack('<i', read(a, 4))[0]
def cstr(a, n=96): return read(a, n).split(b'\0')[0].decode('latin1')


md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)


def dis(s, e=None, out=print):
    end = e if e else s + 0x2000
    for i in md.disasm(read(s, end - s), s):
        extra = ''
        for tok in i.op_str.replace('[', ' ').replace(']', ' ').replace(',', ' ').split():
            if tok.startswith('0x') and len(tok) >= 7:
                try:
                    v = int(tok, 16)
                    extra += '  ; [%x] f32=%.9g u32=%x' % (v, f32(v), u32(v))
                except Exception:
                    pass
        out('%08x  %-22s %s %s%s' % (i.address, i.bytes.hex(), i.mnemonic, i.op_str, extra))
        if e is None and i.mnemonic == 'ret':
            break


if __name__ == '__main__':
    cmd, a = sys.argv[1], int(sys.argv[2], 16)
    if cmd == 'dis':
        dis(a, int(sys.argv[3], 16) if len(sys.argv) > 3 else None)
    elif cmd in ('f32', 'u32'):
        n = int(sys.argv[3]) if len(sys.argv) > 3 else 1
        for k in range(n):
            x = a + 4 * k
            print('%08x  %08x  %.9g' % (x, u32(x), f32(x)))
