"""diagnostic: ORIGINAL memory after the session start and after each of the first N frames of a scenario, restricted
to the dwords that change (session start .. frame N) plus the Stage 11 footprint; written as a Lua module for
tests/stage11/memdiff.luau:   py dev/memdump.py <scenario> <frames> <out.lua> [frozen]
(frozen: the Stage 6-10 frame end, no Stage 11 session start: baseline of the inherited per-tick rounding)"""
import sys, base64, struct
from pathlib import Path
HERE = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(HERE))
import gen_fixtures11 as G
import scenarios11 as SC
from lift11 import BASE, TOP
O = G.O

name, frames, out = sys.argv[1], int(sys.argv[2]), sys.argv[3]
session, _, law, events, opts = SC.SCENARIOS[name]
st = [0.0] * 45; st[4] = 0.42; st[9] = 1.0
frozen = len(sys.argv) > 4 and sys.argv[4] == 'frozen'
o = O.OriginalStage11(state=st, weather=session, stage11=not frozen, **opts)
m = o.m
flat4 = O.flat()
SKIP = (0xf7b000, 0xf7f100)     # Luau virtual stacks (the Unicorn reference runs on its own stack)


def snap():
    return bytes(m.uc.mem_read(BASE, TOP - BASE))


snaps = [snap()]
for k in range(frames):
    for ev in events.get(k, []):
        if ev[0] == 'enter': O.enter_track(o)
    c = law(k)
    for t in range(8): o.step_driver(c, flat4)
    snaps.append(snap())
n = (TOP - BASE) // 4
words = [struct.unpack('<%dI' % n, s) for s in snaps]
sel = set(G.TOUCH)
w0 = words[0]
for w in words[1:]:
    for i in range(n):
        if w[i] != w0[i]: sel.add(i)
sel = sorted(i for i in sel if not (SKIP[0] <= BASE + 4 * i < SKIP[1]))
runs = G.runs(sel)
with open(out, 'w') as f:
    f.write('return {runs = {%s},\nframes = {\n' % ','.join('{%d,%d}' % (a, b) for a, b in runs))
    for w in words:
        f.write('"%s",\n' % base64.b64encode(struct.pack('<%dI' % len(sel), *[w[i] for i in sel])).decode())
    f.write('}}\n')
print('dwords', len(sel), 'runs', len(runs))
