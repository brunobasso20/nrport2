"""dev: REVERSE restart -- the ORIGINAL code continued from the PORT's own complete state (tests/stage12/dev/dumpmem.luau
at the start of frame R). Mirror of the level-3 restart (tests/stage12/run.luau restartFrame): the whole memory window
is the port's except the harness-only ranges (HOSTONLY), where the original keeps its own, plus the port's contact
blocks and clock. Then the original runs the scenario's control law for N frames; rows every 9 frames as the fixtures.
If the original, given the port's state, follows the port's trajectory, a long-horizon difference is the original's
own sensitivity to the state (inherited per-tick rounding), not a difference of logic.
Usage: reverse.py <scenario> <R> <luau mem dump at R> <luau mem dump at 0> <frames> <out.json>
Mirror of the forward restart (port start image + the original's changes since its start): here the ORIGINAL's start
image + the PORT's changes since the port's start; harness-only ranges keep the original's current values."""
import sys, json, array
from pathlib import Path
HERE = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(HERE)); sys.path.insert(0, str(HERE.parent / 'stage11'))
import gen_fixtures12 as G, scenarios12 as SC, orig_stage12 as O
from lift11 import BASE, TOP
HOSTONLY = [(0x74c960, 0x74c96c), (0x74c9ac, 0x74c9b0), (0xbf6ec0, 0xbf6ef4), (0xe847c8, 0xe847cc),
            (0xf7b000, 0xf7f100), (0xf7f100, 0xf7f240), (0xf7f240, 0xf7f2f4)]
BLK = 0xf7f100 + 0xc0
name, R, dump, dump0, N, out = sys.argv[1], int(sys.argv[2]), sys.argv[3], sys.argv[4], int(sys.argv[5]), sys.argv[6]
EVERY = int(sys.argv[7]) if len(sys.argv) > 7 else 9           # row period (frames)
SEEDS = [int(x) for x in sys.argv[8].split(',') if x] if len(sys.argv) > 8 else []   # + 'all' noise twins from the same state
KEEP_ORIG_ONLY = len(sys.argv) > 9 and sys.argv[9] == 'keep'   # cells the port never changes keep the original's value
import gen_fixtures11 as G11
law = SC.SCENARIOS[name][2]
def load(path):
    lines = open(path).read().split('\n')
    assert int(lines[0].split()[0]) == BASE
    w = array.array('I', [int(x, 16) for x in (lines[1][i:i + 8] for i in range(0, len(lines[1].strip()), 8))])
    assert len(w) * 4 == TOP - BASE
    return w
luau, luau0 = load(dump), load(dump0)
o = SC.make(name); m = o.m; flat = O.flat()
w0 = array.array('I'); w0.frombytes(bytes(m.uc.mem_read(BASE, TOP - BASE)))
for k in range(R):
    c = law(k)
    for t in range(8): o.step_driver(c, flat)
ref_row = [R] + G.observe(o)
own = array.array('I'); own.frombytes(bytes(m.uc.mem_read(BASE, TOP - BASE)))
host = set()
for a, b in HOSTONLY: host.update(range((a - BASE) // 4, (b - BASE) // 4))
new = array.array('I', w0)
for i in range(len(new)):
    if i in host: new[i] = own[i]
    elif luau[i] != luau0[i]: new[i] = luau[i]
new[(O.INTCOUNT - BASE) // 4] = luau[(O.INTCOUNT - BASE) // 4]
ndiff = sum(1 for i in range(len(new)) if new[i] != own[i])
origOnly = [BASE + 4 * i for i in range(len(new)) if i not in host and own[i] != w0[i] and luau[i] == luau0[i]]
print('cells changed by the original since its start but not by the port: %d %s' % (len(origOnly), ' '.join('%x' % a for a in origOnly[:40])))
if KEEP_ORIG_ONLY:
    for a in origOnly: new[(a - BASE) // 4] = own[(a - BASE) // 4]
m.uc.mem_write(BASE, new.tobytes())
# the port's persistent tyre contact blocks (BLK, 32-byte stride) -> the harness's own blocks (orig_runtime m.alloc)
for w in range(4):
    for j in range(5): m.w32(o.blocks[w] + 4 * j, luau[(BLK + 32 * w + 4 * j - BASE) // 4])
blocks = [bytes(m.uc.mem_read(b, 20)) for b in o.blocks]
saved = (new.tobytes(), blocks, o.tick)
runs = []
for seed in [0] + SEEDS:
    m.uc.mem_write(BASE, saved[0])
    for b, val in zip(o.blocks, saved[1]): m.uc.mem_write(b, val)
    o.tick = saved[2]
    rows = [[R] + G.observe(o)]
    for k in range(R, R + N):
        c = law(k)
        if seed: seed = G11.state_noise(o, seed)
        for t in range(8): o.step_driver(c, flat)
        if (k + 1) % EVERY == 0: rows.append([k + 1] + G.observe(o))
    runs.append(rows)
json.dump(dict(fields=None, R=R, dwordsReplaced=ndiff, refRow=ref_row, rows=runs[0], twins=runs[1:]), open(out, 'w'))
print('replaced %d dwords of the original window with the port state; %d rows' % (ndiff, len(rows)))
