"""Lift set of the Watkins Glen track / collision world: ORIGINAL NR2003.exe functions lifted to Luau with the
Stage 11 lifter (recovery/stage11/lift11.py: Stage 6/7 conventions, round-toward-negative signed zeros, MSVC switches,
MUL64). Discovery entry: python3 lift_track.py

Track lifter additions (TrackLifter):
  * calls through the import address table (call [slot] and the 'jmp [slot]' thunks) are host builtins named by the
    import (IMPORT_BUILTINS); an import without a builtin is a lift error.
  * builtins with an x87 result (B_tire: 0055e1e0 returns float10 in ST0)."""
import os
import sys
import struct
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parent.parent.parent
sys.path.insert(0, str(REPO / 'recovery' / 'stage11'))
sys.path.insert(0, str(REPO / 'recovery' / 'stage10'))
sys.path.insert(0, str(REPO / 'recovery' / 'stage6_7'))
import lift11  # noqa: E402
from lift import LiftError, X  # noqa: E402

# boundary builtins (host side, identical in the Unicorn reference): Stage 11 set minus the 005f58d0 'no track' stub
BUILTINS = dict(lift11.BUILTINS)
del BUILTINS[0x5f58d0]
BUILTINS.update({
    0x55e1e0: 'B_tire',        # tyre contact of the player car: the core's own 0055e1e0 (same memory), via V._callx
    0x6c5af0: 'B_chkstk',      # __chkstk (encrypted CRT): ESP -= EAX
    0x6c4f40: 'B_atexit',      # atexit (encrypted CRT; function-static destructors): registered, EAX = 0 (crt_x87._atexit)
    # race-session object (00538b20 -> [be0e40]): absent in the port and null in the Unicorn reference, which executes
    # its two uses in 005512f0 on a stub page without effect: 00551800 (session->vtable[0x30]() while the player car is
    # simulated) and 00541110 (session->+0x43e = 1). Guarded no-ops (an existing session object stops the port).
    0x551800: 'B_session551800',
    # bgRequestFGAction(fn, a, b): the foreground action runs at once (single-threaded host; Stage 13 convention, the
    # reference's 005f79a0 -> jmp 005f79de direct path): 00551760 = 005b2f20 car rebuild (NR2003CupBuild)
    0x5f79a0: 'B_fgAction',
    0x541110: 'B_session541110',
})
# statically reachable, never executed in the session (verified in the Unicorn reference: code hook on each entry):
# raise if ever reached. 00501b30 (called by 00551520) stops the replay recorder only while one is recording
# (b8f15c != 0 and b8e58a != 0); no replay recorder exists in the port or the reference.
UNREACHED = [0x501a40, 0x501b00, 0x5ab3f0]
for _a in UNREACHED:
    BUILTINS[_a] = 'B_UNREACHED_%06x' % _a
# imports (rts.dll / system) reached by the lifted code -> host builtin (named by the import)
IMPORT_BUILTINS = {
    '?_memFree@@YAXPAX@Z': 'B_memFree',      # rts.dll _memFree: no-op in the Unicorn reference (orig_track.TrackHost)
}
IAT = ((0x6e9000, 0x6ea000), (0x1127000, 0x112b000))
# imports whose ORIGINAL rts.dll code is lifted (the Unicorn reference runs the same code natively, rts_native.py):
# the exe's 'jmp [slot]' thunk becomes an alias of the lifted rts.dll function (rts.dll image base 0x10000000)
IMPORT_LIFT = ['?Remove@RBNodeBase@@QAEXPAV1@@Z']
RTS_BASE = 0x10000000
RTS_SPAN = (0x10000000, 0x10100000)

ROOTS = [
    0x5789c0,   # per frame: broadphase (005790c0 track primitives near the car, 00578700 car-car)
    0x578a60,   # per frame: pair maintenance / BVH refresh
    0x578da0,   # per tick: contact pass 1 (00577fa0 + 00578050 -> 005778a0 -> pair callbacks)
    0x578de0,   # per tick: contact pass 2
    0x5543f0,   # per tick: world record of the player car (005f58d0 -> 0051370a track query)
    0x5150fa,   # track -> world (placement, cameras)
    0x51370a,   # world -> track
    0x5512f0,   # placement of the car on the track (grid / pit stall)
    0x563620,   # race order insert
    0x433cb0,   # car collision geometry (00432d90)
    0x578610,   # world reset
    0x579cd0,   # car-part x surface interaction tables
    0x5f58d0,   # world point -> track record (0051370a): Stage 11 frame code (00549c40) and host queries
    0x551480,   # external force accumulators of the car object cleared (005539c0 / 005544e0 tails)
    0x59fa90,   # BG car object init (session start 00566e50)
]
# vtable targets reached through ICALL (pair classes, shapes, primitives)
INDIRECT = [
    0x576e00, 0x575920, 0x5764e0,                       # pair callbacks (+0x14): tyre, body, other-car body
    0x577280, 0x579870, 0x5798a0, 0x5798c0, 0x5798e0,  # pair vtable entries
    0x5176ca, 0x51776a, 0x517caa, 0x575720, 0x5756e0, 0x5756d0,   # shape (group) vtables 006f4660/78/90
    0x51892a, 0x518bea, 0x518d0a, 0x518f7a, 0x51920a, 0x5197c0,   # primitive tests (+4)
    0x5196f0, 0x519750, 0x51718a, 0x5172ca,             # primitive plane accessors / transforms
    0x519700, 0x519720, 0x519760, 0x519780, 0x5197a0, 0x5197d0,   # primitive destructors
    0x519620, 0x519640, 0x519660,                       # group destructors
    0x579960, 0x5775b0, 0x579940, 0x579980,             # car object vtable 006f6100
    0x5792d0,                                           # track group vtable +0x1c (00579730: primitives near a car)
    0x562f70, 0x566a20,                                 # 005789c0 callbacks (world +0x9954 / +0x9958, from 005b2190)
]


def rts_blocks(mem=None):
    mem = Path(mem or os.environ['RTS_MEM'])
    out = []
    for line in (mem / 'blocks.tsv').read_text().splitlines()[1:]:
        name, start, size, init = line.split('\t')
        st = int(start, 16)
        p = mem / ('%08x.bin' % st)
        if p.exists() and RTS_SPAN[0] <= st < RTS_SPAN[1]:
            out.append((st, p.read_bytes()))
    return out


def rts_exports(blocks):
    img = dict(blocks)
    hdr = img[RTS_BASE]
    pe = struct.unpack_from('<I', hdr, 0x3c)[0]
    exp_rva = struct.unpack_from('<I', hdr, pe + 24 + 96)[0]

    def rd(rva, n):
        a = RTS_BASE + rva
        for st, b in blocks:
            if st <= a < st + len(b):
                return b[a - st:a - st + n]
        raise KeyError(hex(a))
    nnames, fn_rva, nm_rva, ord_rva = struct.unpack('<IIII', rd(exp_rva + 24, 16))
    out = {}
    for i in range(nnames):
        nrva = struct.unpack('<I', rd(nm_rva + 4 * i, 4))[0]
        nm = rd(nrva, 256).split(b'\0', 1)[0].decode('latin-1')
        o = struct.unpack('<H', rd(ord_rva + 2 * i, 2))[0]
        out[nm] = RTS_BASE + struct.unpack('<I', rd(fn_rva + 4 * o, 4))[0]
    return out


def memreader(rts_mem=None):
    """exe memory (NR2003_MEM) + rts.dll image (RTS_MEM, unrelocated, base 0x10000000)"""
    exe = lift11.memreader()
    rts = rts_blocks(rts_mem)

    def read(a, n):
        if RTS_SPAN[0] <= a < RTS_SPAN[1]:
            for st, b in rts:
                if st <= a < st + len(b):
                    return b[a - st:a - st + n]
            raise KeyError(hex(a))
        return exe(a, n)
    read.rts = rts
    return read


def import_names():
    """IAT slot -> import name (the exe's import directory, as nrx.Machine binds it)"""
    import nrx
    m = nrx.Machine()
    out = {}
    for lo, hi in IAT:
        for slot in range(lo, hi, 4):
            name = m.imports.get(m.u32(slot))
            if name:
                out[slot] = name.split('!')[-1]
    return out


class TrackLifter(lift11.Lifter11):
    BUILTIN_FX = dict(lift11.Lifter11.BUILTIN_FX)
    BUILTIN_FX.update({'B_tire': (0, 1)})

    def __init__(self, read, builtins, base, imports):
        super().__init__(read, builtins, base)
        self.imports = imports
        self.import_sites = {}          # call site -> (slot, import name, builtin)
        self.alias = {}                 # exe import thunk -> lifted rts.dll function
        self.rts_exports = rts_exports(read.rts) if hasattr(read, 'rts') else {}

    def iat_slot(self, op):
        if op.type != X.X86_OP_MEM or op.mem.base or op.mem.index:
            return None
        a = op.mem.disp & 0xffffffff
        return a if any(lo <= a < hi for lo, hi in IAT) else None

    def import_builtin(self, slot, where):
        name = self.imports.get(slot, '?')
        b = IMPORT_BUILTINS.get(name)
        if b is None:
            raise LiftError('import %s (slot %x) at %x has no builtin' % (name, slot, where))
        return name, b

    def thunk(self, f):
        """'jmp [slot]' import thunk at f -> builtin name (None for a lifted import: self.alias[f] = target)"""
        if f in self.alias or RTS_SPAN[0] <= f < RTS_SPAN[1]:
            return None
        i = self.decode(f)
        if i.mnemonic == 'jmp' and i.operands[0].type == X.X86_OP_MEM:
            slot = self.iat_slot(i.operands[0])
            if slot is not None:
                name = self.imports.get(slot, '?')
                if name in IMPORT_LIFT:
                    self.alias[f] = self.rts_exports[name]
                    return None
                return self.import_builtin(slot, f)[1]
        return None

    def effect(self, f):
        if f not in self.builtins:
            self.thunk(f)
        if f in self.alias:
            return self.effect(self.alias[f])
        return lift11.Lifter11.effect(self, f)

    def lift(self, entry):
        if entry in self.alias:
            if entry in self.funcs:
                return []
            t = self.alias[entry]
            self.funcs[entry] = ['F_%06x = function()' % entry, 'F_%06x()' % t, 'end']
            return [t] if t not in self.funcs else []
        return lift11.Lifter11.lift(self, entry)

    def call_effect(self, i):
        op = i.operands[0]
        slot = self.iat_slot(op) if op.type == X.X86_OP_MEM else None
        if slot is not None:
            _, b = self.import_builtin(slot, i.address)
            pin, pout = self.BUILTIN_FX.get(b, (0, 0))
            return pout - pin
        if op.type == X.X86_OP_IMM and op.imm not in self.builtins:
            b = self.thunk(op.imm)
            if b is not None:
                self.builtins[op.imm] = b
        return lift11.Lifter11.call_effect(self, i)

    def _inst(self, i, lid):
        if i.mnemonic == 'call' and i.operands[0].type == X.X86_OP_MEM:
            slot = self.iat_slot(i.operands[0])
            if slot is not None:
                name, b = self.import_builtin(slot, i.address)
                self.import_sites[i.address] = (slot, name, b)
                pin, pout = self.BUILTIN_FX.get(b, (0, 0))
                L = []
                for k in range(pin - 1, -1, -1):
                    L.append('FT = FT + 1; F[FT] = %s' % self.st(k))
                L += ['ESP = ESP - 4', '%s()' % b]
                base = self.d - pin
                for k in range(pout):
                    L.append('s%d = F[FT]; FT = FT - 1' % (base + pout - 1 - k))
                return L, False
        return lift11.Lifter11._inst(self, i, lid)


def lift(read=None, roots=None, indirect=None, builtins=None, strict=False):
    read = read or memreader()
    L = TrackLifter(read, dict(builtins or BUILTINS), lift11.BASE, import_names())
    L.signed_zero_rtn = True
    L.hooks = {}
    work = [(f, None) for f in (roots or ROOTS) + (indirect or INDIRECT)]
    parent = {}
    errors = []
    while work:
        f, p = work.pop()
        if f in L.funcs or f in L.builtins:
            continue
        parent.setdefault(f, p)
        try:
            b = L.thunk(f)
            if b is not None:
                L.builtins[f] = b
                continue
            new = L.lift(f)
        except Exception as e:
            chain = []
            x = f
            while x is not None:
                chain.append('%06x' % x)
                x = parent.get(x)
            msg = '%s (chain %s; x87 chain %s)' % (e, ' <- '.join(chain), getattr(e, 'chain', ''))
            if strict:
                raise RuntimeError(msg)
            errors.append(msg)
            L.builtins[f] = 'B_MISSING_%06x' % f
            continue
        work += [(c, f) for c in new]
    for f in (indirect or INDIRECT):
        if f in L.funcs and L.effect(f) != 0:
            errors.append('indirect target %x has an x87 effect' % f)
    if strict and errors:
        raise RuntimeError('; '.join(errors))
    return L, errors


if __name__ == '__main__':
    L, errors = lift(None)
    print('lifted', len(L.funcs))
    for e in errors:
        print('ERR', e)
    print('indirect sites', len(L.indirect_sites))
    print('import sites', sorted(set(v[1] for v in L.import_sites.values())))
