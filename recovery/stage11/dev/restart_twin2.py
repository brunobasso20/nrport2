"""diagnostic: one-frame sensitivity of the original at a restart point under per-tick noise on the WHOLE 45-state
vector (original export 005b2cb0 -> +-1 ulp on every value -> original import 005b4560, the V.translate path),
compared with the three-cell tick noise:   py dev/restart_twin2.py <scenario> <R> <addr> [seeds]"""
import sys, struct
from pathlib import Path
HERE = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(HERE))
import gen_fixtures11 as G
import scenarios11 as SC
from lift11 import BASE, TOP
O = G.O

name, R, cell = sys.argv[1], int(sys.argv[2]), int(sys.argv[3], 16)
seeds = int(sys.argv[4]) if len(sys.argv) > 4 else 6
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
S = 0xf7f100 + 0x140


def restore():
    m.uc.mem_write(BASE, win)
    for b, v in zip(o.blocks, blk): m.uc.mem_write(b, v)
    m.w32(G.INTCOUNT, ic); o.tick = tick


def all_noise(seed):
    m.w32(0xe847c8, S); m.call(0x5b2cb0, S, o.root)
    for i in range(45):
        seed = (seed * 1103515245 + 12345) & 0x7fffffff
        m.w32(S + 4 * i, m.u32(S + 4 * i) + (1 if seed & 0x10000 else -1))
    m.w32(0xe847c8, S); m.w32(0xe84664, 0xe84474); m.call(0x5b4560, o.root)
    return seed


def frame(kind, seed=0):
    restore()
    for t in range(8):
        if kind == 'all': seed = all_noise(seed)
        elif kind == 'cells':
            for c in G.STATE_CELLS:
                seed = (seed * 1103515245 + 12345) & 0x7fffffff
                m.w32(c, m.u32(c) + (1 if seed & 0x10000 else -1))
        o.step_driver(law(R), flat4)
    return m.f32(cell)


ref = frame('none')
print('reference %08x = %.9g' % (cell, ref))
print('import without perturbation (seed affects nothing):', end=' ')
restore()
m.w32(0xe847c8, S); m.call(0x5b2cb0, S, o.root); m.w32(0xe847c8, S); m.w32(0xe84664, 0xe84474); m.call(0x5b4560, o.root)
for t in range(8): o.step_driver(law(R), flat4)
print('%.9g' % m.f32(cell))
for kind in ('cells', 'all'):
    vals = [frame(kind, s) for s in range(1, seeds + 1)]
    print('%-5s twins: %s' % (kind, ' '.join('%+.3g' % (v - ref) for v in vals)))
