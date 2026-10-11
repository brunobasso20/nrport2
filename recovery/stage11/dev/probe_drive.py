"""Stage 11 probe: drive the ORIGINAL car with the ORIGINAL frame end in Unicorn and print the Stage 11
state evolution (fuel, engine temperatures, tyre temperatures/pressure/wear, brake temperatures).
Diagnostic only."""
import sys, time
from pathlib import Path
HERE = Path(__file__).resolve().parent.parent      # recovery/stage11 (this file: dev/)
sys.path.insert(0, str(HERE))
from orig_stage11 import *        # noqa

def controls(k):
    t = k / 36.0
    c = dict(throttle=1.0 if t < 20 else 0.0, clutch=1.0, steer=0.0, brakeControl=1.0 if 20 <= t < 24 else 0.0,
             brakeDigital=True)
    c['shiftUp'] = (k in (36, 90, 160))
    return c

def main(seconds=30):
    t0 = time.time()
    o = OriginalStage11(state=[0.0] * 4 + [0.42] + [0.0] * 4 + [1.0] + [0.0] * 35)
    m = o.m
    flat4 = flat()
    def show(k):
        e = ENGINE
        fuel = o.protected_f64(e + 0x50c)
        wt, ot = o.protected_f32(e + 0x4a4), o.protected_f32(e + 0x4d4)
        print('t=%5.1f v=%6.2f rpm=%6.0f gear=%d fuel=%.4f water=%.3f oil=%.3f lvl=%.4f/%.4f ign=%.3f wear=%.5f' % (
            k / 36.0, m.f32(0xbf6d44), m.f32(0xbf6d40 + 4 * 34) * 9.5493, m.i32(0x74c97c), fuel, wt, ot,
            m.f32(e + 0x4a0), m.f32(e + 0x49c), m.f32(e + 0x554), m.f32(e + 0x55c)))
        for w in range(4):
            T = TIRE[w]
            surf = [o.protected_f32(T + 0x160 + 0x2c * z) for z in range(3)]
            core = [o.protected_f32(T + 0x1e4 + 0x2c * z) for z in range(3)]
            print('   w%d P0=%.3f P=%.3f surf=%s core=%s wear=%.6f brake=%.2f grip=%.4f' % (
                w, m.f32(T), m.f32(T + 0x2a0), ['%.2f' % x for x in surf], ['%.2f' % x for x in core],
                o.protected_f32(T + 0x74), o.protected_f32(T + 0x26c), m.f32(T + 0xcc)))
    show(0)
    for k in range(int(seconds * 36)):
        c = controls(k)
        for t in range(8): o.step_driver(c, flat4)
        if (k + 1) % 180 == 0: show(k + 1)
    print('elapsed %.1f s' % (time.time() - t0))

if __name__ == '__main__':
    main(float(sys.argv[1]) if len(sys.argv) > 1 else 30)
