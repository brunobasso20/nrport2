"""Dynamic proof that nothing of the ORIGINAL force feedback feeds back into the simulation (Stage 13 evidence).
Two ORIGINAL machines in lockstep from the same start: A = scenario with the FFB on (options, device, 00550070 on the
binding change, the FFB block every frame end), B = the same law with the FFB off (image options: FF off, never acquired).
After every frame the whole window 0x6e9000..0xf80000 is compared; allowed to differ: the FFB cells (options, gate,
axis / direction, filter state bf6ec0 / bf6ecc) and the harness host-device bytes.
Usage: NR2003_MEM=... python3 -B dev/nofeedback.py <scenario> [frames]"""
import sys, array
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
import scenarios13 as SC
import orig_stage13 as O
from lift11 import BASE, TOP

ALLOWED = set()
for a, n in [(0x74c95c, 4), (0xbf6eb8, 8), (0xbf6ec0, 4), (0xbf6ecc, 4), (0xbf6f1c, 0xc), (0x74c9a4, 4), (O.HDEV, 4)]:
    for x in range(a & ~3, a + n, 4): ALLOWED.add(x)


def window(m):
    w = array.array('I'); w.frombytes(bytes(m.uc.mem_read(BASE, TOP - BASE))); return w


name = sys.argv[1]; frames = int(sys.argv[2]) if len(sys.argv) > 2 else None
session, n, law, events, opts = SC.SCENARIOS[name]
frames = frames or n
a = SC.make(name)
saved = dict(SC.SCENARIOS[name][4]); SC.SCENARIOS[name][4]['ffb'] = None; SC.SCENARIOS[name][4]['device'] = None
b = SC.make(name)
SC.SCENARIOS[name][4].update(saved)
flat = O.flat()
diff_cells, worst = set(), 0
for k in range(frames):
    c = law(k)
    for o in (a, b):
        for ev in events.get(k, []):
            if ev[0] == 'controls': o.controls(ev[1])
        for t in range(8): o.step_driver(c, flat)
    wa, wb = window(a.m), window(b.m)
    d = [BASE + 4 * i for i in range(len(wa)) if wa[i] != wb[i] and (BASE + 4 * i) not in ALLOWED]
    if d:
        print('frame %d: %d cells differ outside the FFB cells, first %s' % (k + 1, len(d), ', '.join('%08x' % x for x in d[:8])))
        sys.exit(1)
    for i in range(len(wa)):
        if wa[i] != wb[i]: diff_cells.add(BASE + 4 * i)
print('%s: %d frames (%d ticks): A (FFB on, block ran %d frames) and B (FFB off) identical outside the FFB cells; differing cells: %s'
      % (name, frames, 8 * frames, sum(1 for c in a.m.ffb_log if c[0] == 'force'), ' '.join('%08x' % x for x in sorted(diff_cells))))
