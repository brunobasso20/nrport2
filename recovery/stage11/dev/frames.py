"""diagnostic: ORIGINAL per-frame rows (gen_fixtures11.observe + the 45 state values) for the first N frames of a
scenario, one JSON list per line:   py dev/frames.py <scenario> <frames> [every] [fpcw|-] [frozen] > out.jsonl
(fpcw: x87 control word of the simulation task after the build, e.g. 0x067f = 53-bit significand, round down;
 'noise<seed>' instead: +-1 ulp on the chassis z cell 0xebdd74 at every frame start, signs from an LCG;
 'tnoise<seed>': +-1 ulp on the x, z and quaternion cells before every tick)"""
import sys, json
from pathlib import Path
HERE = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(HERE))
import gen_fixtures11 as G
import scenarios11 as SC
O = G.O

name, frames = sys.argv[1], int(sys.argv[2])
every = int(sys.argv[3]) if len(sys.argv) > 3 else 1
arg4 = sys.argv[4] if len(sys.argv) > 4 else None
noise = int(arg4[5:]) if arg4 and arg4.startswith('noise') else None
tnoise = int(arg4[6:]) if arg4 and arg4.startswith('tnoise') else None
fpcw = int(arg4, 16) if arg4 and arg4 != '-' and noise is None and tnoise is None else None
session, _, law, events, opts = SC.SCENARIOS[name]
st = [0.0] * 45; st[4] = 0.42; st[9] = 1.0
frozen = len(sys.argv) > 5 and sys.argv[5] == 'frozen'
o = O.OriginalStage11(state=st, weather=session, stage11=not frozen, **opts)
if fpcw is not None: o.m.fpcw = fpcw
flat4 = O.flat()
print(json.dumps([0] + G.observe(o) + list(o.state())))
for k in range(frames):
    for ev in events.get(k, []):
        if ev[0] == 'enter': O.enter_track(o)
    c = law(k)
    if noise is not None:
        noise = (noise * 1103515245 + 12345) & 0x7fffffff
        u = o.m.u32(0xebdd74); o.m.w32(0xebdd74, u + (1 if noise & 0x10000 else -1))
    for t in range(8):
        if tnoise is not None:
            for cell in (0xebdd64, 0xebdd74, 0xebdd7c):
                tnoise = (tnoise * 1103515245 + 12345) & 0x7fffffff
                o.m.w32(cell, o.m.u32(cell) + (1 if tnoise & 0x10000 else -1))
        o.step_driver(c, flat4)
    for ev in events.get(k, []):
        if ev[0] == 'collision': o.collision(**ev[1])
        elif ev[0] == 'pit':
            for w in ev[1]: o.m.call(0x550f10, w)
    if (k + 1) % every == 0: print(json.dumps([k + 1] + G.observe(o) + list(o.state())))
