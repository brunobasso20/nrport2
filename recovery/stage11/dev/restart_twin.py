"""diagnostic: the ORIGINAL's own one-frame sensitivity at a restart point. Runs a scenario to frame R, saves the
complete state (window, contact blocks, interrupt clock, harness tick), runs frame R (reference), restores, applies a
1-ulp kick to the multibody chassis height (0xebdd74) and runs frame R again; prints the relative change of chosen
cells and of the observation row:   py dev/restart_twin.py <scenario> <R> [addr ...]"""
import sys, struct
from pathlib import Path
HERE = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(HERE))
import gen_fixtures11 as G
import scenarios11 as SC
from lift11 import BASE, TOP
O = G.O

name, R = sys.argv[1], int(sys.argv[2])
cells = [int(a, 16) for a in sys.argv[3:]]
session, frames, law, events, opts = SC.SCENARIOS[name]
st = [0.0] * 45; st[4] = 0.42; st[9] = 1.0
o = O.OriginalStage11(state=st, weather=session, **opts)
m = o.m
flat4 = O.flat()
for k in range(R):
    for ev in events.get(k, []):
        if ev[0] == 'enter': O.enter_track(o)
    for t in range(8): o.step_driver(law(k), flat4)
    for ev in events.get(k, []):
        if ev[0] == 'collision': o.collision(**ev[1])
        elif ev[0] == 'pit':
            for w in ev[1]: m.call(0x550f10, w)
win = bytes(m.uc.mem_read(BASE, TOP - BASE))
blk = [bytes(m.uc.mem_read(b, 20)) for b in o.blocks]
ic, tick = m.u32(G.INTCOUNT), o.tick


def restore():
    m.uc.mem_write(BASE, win)
    for b, v in zip(o.blocks, blk): m.uc.mem_write(b, v)
    m.w32(G.INTCOUNT, ic); o.tick = tick


def frame(kick):
    restore()
    if kick: m.w32(0xebdd74, m.u32(0xebdd74) + kick)
    for t in range(8): o.step_driver(law(R), flat4)
    return [m.f32(a) for a in cells], G.observe(o) + list(o.state()), bytes(m.uc.mem_read(BASE, TOP - BASE))


ref_c, ref_r, ref_w = frame(0)
again_c, again_r, _ = frame(0)
print('restore reproducible:', ref_c == again_c and ref_r == again_r)
names = G.ROW_FIELDS + ['s%d' % k for k in range(45)]
for kick in (1, -1):
    c, r, w = frame(kick)
    rel = lambda x, y: abs(x - y) / max(abs(x), abs(y), 1e-9)
    print('kick %+d ulp:' % kick)
    for a, x, y in zip(cells, ref_c, c): print('   %08x %.9g -> %.9g  rel %.2e' % (a, x, y, rel(x, y)))
    worst = sorted(((rel(x, y), n, x, y) for n, x, y in zip(names, ref_r, r) if abs(x - y) > 1e-9), reverse=True)[:6]
    print('   row worst:', ', '.join('%s %.2e (%.6g/%.6g)' % (n, d, x, y) for d, n, x, y in worst))
    n = (TOP - BASE) // 4
    a1 = struct.unpack('<%dI' % n, ref_w); a2 = struct.unpack('<%dI' % n, w)
    diffs = [(i, a1[i], a2[i]) for i in range(n) if a1[i] != a2[i]]
    fl = []
    for i, u, v in diffs:
        x, y = struct.unpack('<f', struct.pack('<I', u))[0], struct.unpack('<f', struct.pack('<I', v))[0]
        if x == x and y == y and abs(x) < 1e12 and abs(y) < 1e12 and max(abs(x), abs(y)) > 1e-3: fl.append(rel(x, y))
    fl.sort(reverse=True)
    print('   window: %d dwords differ; float cells |v|>1e-3: worst rel %s' % (len(diffs), ['%.1e' % d for d in fl[:8]]))
