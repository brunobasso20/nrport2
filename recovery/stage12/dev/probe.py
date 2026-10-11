"""dev: original steering chain in Unicorn, same keyboard-left script as tests/stage12/dev/smoke.luau"""
import sys, time, struct
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
import orig_stage12 as O
import scenarios11 as SC
st = [0.0] * 45; st[4] = 0.42; st[9] = 1.0
t0 = time.time()
o = O.OriginalStage12(state=st, weather=SC.DEFAULT_SESSION)
print('built %.1f s' % (time.time() - t0))
m = o.m
flat = O.flat()
def f(a): return m.f32(a)
for k in range(36 * 4):
    t = (k * 8 + 7) / 288
    c = dict(throttle=0.5, clutch=1.0, brakeControl=0.0, brakeDigital=True,
             steerLeft=1.0 if 1 < (k * 8) / 288 < 2 else 0.0, steerRight=0.0, steerDigital=True)
    for i in range(8): o.step_driver(c, flat)
    if k % 4 == 3:
        print('t=%.2f in=%.4f ratio? target=%.5f cur=%.5f lf=%.5f rf=%.5f v=%.2f e80=%08x e88=%08x c0=%08x c8=%08x' % (
            t, f(0xbf63c8), f(0xbf63b8), f(0xbf63c0), f(0xbf6360), f(0xbf6364), f(0xbf6f44),
            m.u32(0xbf6e80), m.u32(0xbf6e88), m.u32(0xbf63c0), m.u32(0xbf63c8)))
print('total %.1f s' % (time.time() - t0))
