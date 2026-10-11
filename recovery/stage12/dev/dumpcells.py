"""dev: per-frame steering cells (hex) of the ORIGINAL chain for a control script; compare with dumpcells.luau"""
import sys, json
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
import orig_stage12 as O
import scenarios11 as SC
CELLS = [0xbf63c8, 0xbf63c0, 0xbf63b8, 0xbf6e80, 0xbf6e88, 0xbf639c, 0xbf63a0, 0xbf6360, 0xbf6364, 0xbf6f44,
         0xbf6d7c, 0xbf6d94, 0xc13584]
def law(k, kind):
    t = k / 36
    c = dict(throttle=1.0 if t < 6 else 0.3, clutch=1.0, brakeControl=0.0, brakeDigital=True, shiftUp=k in (40, 110))
    if kind == 'keys':
        c.update(steerLeft=1.0 if 3 < t < 3.5 else 0.0, steerRight=1.0 if 4 < t < 5 else 0.0, steerDigital=True)
    else:
        import math
        c.update(steerAxis=0.6 * math.sin(t * 2.0) if t > 2 else 0.0)
    return c
def main(kind, frames, opts):
    st = [0.0] * 45; st[4] = 0.42; st[9] = 1.0
    o = O.OriginalStage12(state=st, weather=SC.DEFAULT_SESSION, steer_options=opts, **SC.NODMG)
    m = o.m; flat = O.flat(); rows = []
    for k in range(frames):
        c = law(k, kind)
        o.step_driver(c, flat)               # frame start + tick 1
        a = [m.u32(x) for x in CELLS]
        for i in range(7): o.step_driver(c, flat)
        b = [m.u32(x) for x in CELLS]
        rows.append([k, a, b])
    print(json.dumps(rows))
if __name__ == '__main__':
    kind = sys.argv[1]; frames = int(sys.argv[2]); opts = json.loads(sys.argv[3]) if len(sys.argv) > 3 else None
    main(kind, frames, opts)
