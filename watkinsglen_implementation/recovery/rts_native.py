"""rts.dll executed natively inside the Unicorn reference (selected exports).

rts.dll (same Ghidra project, RTS_MEM = ExportMemoryPy.py output) is mapped at a free base, its base relocations
(.reloc) applied, and the NR2003.exe import slots of the chosen exports are pointed at the relocated code, so the
ORIGINAL rts.dll code runs (e.g. RBNodeBase::Remove / DeleteFixup of the track-primitive cache tree). Only exports
whose code needs no further imports are bound this way (checked: no call through rts.dll's own IAT is reached)."""
import os
import struct
from pathlib import Path

BASE0 = 0x10000000


def _blocks(mem):
    out = []
    for line in (mem / 'blocks.tsv').read_text().splitlines()[1:]:
        name, start, size, init = line.split('\t')
        out.append((name, int(start, 16), int(size)))
    return out


def load(m, names, base=0x20000000, mem=None):
    mem = Path(mem or os.environ['RTS_MEM'])
    blocks = [b for b in _blocks(mem) if b[1] < 0xffdff000]
    lo = min(b[1] for b in blocks)
    hi = max(b[1] + b[2] for b in blocks)
    size = (hi - lo + 0xfff) & ~0xfff
    delta = base - BASE0
    m.uc.mem_map(base + (lo - BASE0), size)
    image = bytearray(size)
    for name, start, sz in blocks:
        p = mem / ('%08x.bin' % start)
        if p.exists():
            data = p.read_bytes()
            image[start - lo:start - lo + len(data)] = data
    pe = struct.unpack_from('<I', image, 0x3c)[0]
    opt = pe + 24
    # data directories: export (0), base relocation (5)
    exp_rva, exp_size = struct.unpack_from('<II', image, opt + 96)
    rel_rva, rel_size = struct.unpack_from('<II', image, opt + 96 + 5 * 8)
    p = rel_rva
    while p < rel_rva + rel_size:
        page, bsz = struct.unpack_from('<II', image, p)
        if bsz == 0:
            break
        for k in range((bsz - 8) // 2):
            e = struct.unpack_from('<H', image, p + 8 + 2 * k)[0]
            if e >> 12 == 3:
                off = page + (e & 0xfff)
                v = struct.unpack_from('<I', image, off)[0]
                struct.pack_into('<I', image, off, (v + delta) & 0xffffffff)
        p += bsz
    m.uc.mem_write(base + (lo - BASE0), bytes(image))
    # exports
    nnames, fn_rva, nm_rva, ord_rva = struct.unpack_from('<IIII', image, exp_rva + 24)
    exports = {}
    for i in range(nnames):
        nrva = struct.unpack_from('<I', image, nm_rva + 4 * i)[0]
        nm = bytes(image[nrva:nrva + 256]).split(b'\0', 1)[0].decode('latin-1')
        ordv = struct.unpack_from('<H', image, ord_rva + 2 * i)[0]
        exports[nm] = base + struct.unpack_from('<I', image, fn_rva + 4 * ordv)[0]
    # bind the exe's import slots (the stubs nrx wrote) to the relocated exports
    bound = {}
    iat = bytes(m.uc.mem_read(0x6e9000, 0x1000)) + bytes(m.uc.mem_read(0x1127000, 0x4000))
    addrs = [0x6e9000 + i for i in range(0, 0x1000, 4)] + [0x1127000 + i for i in range(0, 0x4000, 4)]
    vals = [struct.unpack_from('<I', iat, i)[0] for i in range(0, len(iat), 4)]
    for want in names:
        target = exports.get(want)
        if target is None:
            raise KeyError('rts.dll export %r not found' % want)
        stubs = [a for a, n in m.imports.items() if n.split('!')[-1][:60] == want[:60]]
        for slot, v in zip(addrs, vals):
            if v in stubs:
                m.w32(slot, target)
                bound.setdefault(want, []).append(slot)
        if want not in bound:
            raise KeyError('no import slot bound for %r' % want)
    m.rts_exports = exports
    return bound
