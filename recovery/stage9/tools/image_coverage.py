"""Which original memory is missing from the Luau core image (core/NR2003Cup/NR2003CupImage*.lua)?
The image holds only the windows the Stage 6/7 build trace touched; data read only by branches that trace
did not exercise (e.g. the aero damage tables, read with damage != 0) is absent and reads as 0 in Luau.
Compares the ORIGINAL post-build emulator memory with the image windows over the given ranges.
    python image_coverage.py 71f908-71fa68 7238e0-723a28 ...
Env: NR2003_MEM, UNICORN_PY (as for recovery/stage8/orig_brake.py)."""
import sys
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / 'stage8')); sys.path.insert(0, str(HERE.parents[1] / 'stage6_7'))
from orig_brake import OriginalBrake
from gen_runtime import canonical_state
import image_windows as IW

o = OriginalBrake(state=canonical_state()); m = o.m
wins = IW.windows(HERE.parents[2])


def covered(a):
    for s, d in wins:
        if s <= a < s + len(d): return d[a - s:a - s + 4]
    return None


for arg in sys.argv[1:]:
    lo, hi = (int(x, 16) for x in arg.split('-'))
    missing, differs = [], []
    for a in range(lo, hi, 4):
        img = covered(a)
        if img is None:
            if bytes(m.uc.mem_read(a, 4)) != b'\0\0\0\0': missing.append(a)
        elif img != bytes(m.uc.mem_read(a, 4)): differs.append(a)
    print('%08x-%08x: %d non-zero dwords missing from the image, %d differing' % (lo, hi, len(missing), len(differs)))
    for a in missing: print('  missing %08x = %08x' % (a, m.u32(a)))
