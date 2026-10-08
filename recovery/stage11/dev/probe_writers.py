"""Stage 11 probe: who writes given cells while the ORIGINAL car drives (EIP of each writing instruction).
Usage: python probe_writers.py <addr> <len> [seconds]   (diagnostic only)"""
import sys, collections
from pathlib import Path
HERE = Path(__file__).resolve().parent.parent      # recovery/stage11 (this file: dev/)
sys.path.insert(0, str(HERE))
from orig_stage11 import *        # noqa
from unicorn import UC_HOOK_MEM_WRITE
from unicorn.x86_const import UC_X86_REG_EIP

a0, n = int(sys.argv[1], 16), int(sys.argv[2], 16)
secs = float(sys.argv[3]) if len(sys.argv) > 3 else 8
o = OriginalStage11(state=[0.0] * 4 + [0.42] + [0.0] * 4 + [1.0] + [0.0] * 35)
m = o.m
print('settings +0x4c %08x +0x50 %08x  car+0x596 %d  bef700 %g' % (m.u32(0xc0692a + 0x4c), m.u32(0xc0692a + 0x50),
      m.i32(0xc12030 + 0x596), m.f32(0xbef700)))
hits = collections.Counter(); vals = {}
def hook(uc, access, addr, size, value, user):
    eip = uc.reg_read(UC_X86_REG_EIP)
    hits[(eip, addr)] += 1; vals[(eip, addr)] = value
m.uc.hook_add(UC_HOOK_MEM_WRITE, hook, begin=a0, end=a0 + n - 1)
for k in range(int(secs * 36)):
    c = dict(throttle=1.0, clutch=1.0, steer=0.02 if k > 100 else 0.0, brakeControl=0.0, shiftUp=k in (36, 90))
    for t in range(8): o.step_driver(c, flat())
for (eip, addr), c in sorted(hits.items()):
    print('eip %08x writes %08x x%d last %08x' % (eip, addr, c, vals[(eip, addr)]))
