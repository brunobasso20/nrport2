"""Stage 11 probe: call the direct callees of 00554520 one by one (after one driven frame) to see which
ones the emulator can execute without the track / render subsystems. Diagnostic only."""
import sys
from pathlib import Path
HERE = Path(__file__).resolve().parent.parent      # recovery/stage11 (this file: dev/)
sys.path.insert(0, str(HERE.parent / 'stage9')); sys.path.insert(0, str(HERE.parent / 'stage8'))
sys.path.insert(0, str(HERE.parent / 'stage6_7'))
from orig_aero import *          # noqa

o = OriginalAero(); m = o.m
o.frame(dict(throttle=1.0, clutch=1.0, brakeControl=0.0))
for t in range(8): o.drive_tick(flat())
def tryc(name, *a, **k):
    snap = m.uc.context_save()
    try:
        r = m.call(*a, **k); print('OK  ', name, hex(r))
    except Exception as e:
        print('FAIL', name, e)
tryc('00551ce0', 0x551ce0)
tryc('005547a0', 0x5547a0)
tryc('0051a000', 0x51a000)
eng = 0xc12030 + 0xc
car = 0xc12030
print('car vtable', hex(m.u32(car)), [hex(m.u32(m.u32(car) + 4 * k)) for k in range(8)])
print('engine+0x56e (car ptr)', hex(m.u32(eng + 0x56e)), 'engine+0x56a', hex(m.u32(eng + 0x56a)))
tryc('0051aac0', 0x51aac0, f32bits := 0x3ce38e39, ecx=eng)
tryc('0051c2d0', 0x51c2d0, 0x3ce38e39)
tryc('0051c3d0', 0x51c3d0, 0x3ce38e39, ecx=0xbcf760)
tryc('005605c0', 0x5605c0)
tryc('00551990', 0x551990, car)
