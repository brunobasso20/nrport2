"""Lift set of the Watkins Glen track / collision world: ORIGINAL NR2003.exe functions (+ rts.dll RBNodeBase::Remove)
lifted to Luau with the Stage 11 lifter (recovery/stage11/lift11.py: Stage 6/7 conventions, round-toward-negative
signed zeros, MSVC switches, MUL64). Discovery entry: python3 lift_track.py"""
import os
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parent.parent.parent
sys.path.insert(0, str(REPO / 'recovery' / 'stage11'))
sys.path.insert(0, str(REPO / 'recovery' / 'stage10'))
sys.path.insert(0, str(REPO / 'recovery' / 'stage6_7'))
import lift11  # noqa: E402

# boundary builtins (host side, identical in the Unicorn reference): Stage 11 set minus the 005f58d0 'no track' stub
BUILTINS = dict(lift11.BUILTINS)
del BUILTINS[0x5f58d0]
BUILTINS.update({
    0x55e1e0: 'B_tire',        # tyre contact of the player car: the core's own 0055e1e0 (same memory), via V._callx
    0x6c5af0: 'B_chkstk',      # __chkstk (encrypted CRT): ESP -= EAX
})

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
]


def lift(read=None):
    return lift11.lift_all(read=read, roots=ROOTS, indirect=INDIRECT) if False else _lift(read)


def _lift(read):
    read = read or lift11.memreader()
    L = lift11.Lifter11(read, dict(BUILTINS), lift11.BASE)
    L.signed_zero_rtn = True
    L.hooks = {}
    work = [(f, None) for f in ROOTS + INDIRECT]
    parent = {}
    errors = []
    while work:
        f, p = work.pop()
        if f in L.funcs or f in L.builtins:
            continue
        parent.setdefault(f, p)
        try:
            new = L.lift(f)
        except Exception as e:
            chain = []
            x = f
            while x is not None:
                chain.append('%06x' % x)
                x = parent.get(x)
            errors.append('%s (chain %s)' % (e, ' <- '.join(chain)))
            L.builtins[f] = 'B_MISSING_%06x' % f
            continue
        work += [(c, f) for c in new]
    return L, errors


if __name__ == '__main__':
    L, errors = _lift(None)
    print('lifted', len(L.funcs))
    for e in errors:
        print('ERR', e)
    print('indirect sites', len(L.indirect_sites))
