"""diagnostic: does a restart excursion (twins of frame R run from the saved state, then restored) leave the reference
run unchanged? Runs a scenario with and without restarts and reports the first differing row / field and the harness
state outside the memory window (heap pointer):   py dev/excursion_check.py <scenario> [frames]"""
import sys
from pathlib import Path
HERE = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(HERE))
import gen_fixtures11 as G
import scenarios11 as SC

name = sys.argv[1]
limit = int(sys.argv[2]) if len(sys.argv) > 2 else None
if limit:
    s = list(SC.SCENARIOS[name]); s[1] = limit; SC.SCENARIOS[name] = tuple(s)
G.SYNC_EVERY[name] = []
real = G.restart_frames
G.restart_frames = lambda n: []
a = G.run(name, sync=True)
G.restart_frames = real
b = G.run(name, sync=True)
print('restarts', [r['frame'] for r in b['restart']])
for i, (x, y) in enumerate(zip(a['rows'], b['rows'])):
    if x != y:
        bad = [(G.ROW_FIELDS[j - 1], x[j], y[j]) for j in range(1, len(x)) if x[j] != y[j]]
        print('first differing row: frame', x[0], bad[:6])
        break
else:
    print('rows identical with and without restart excursions')
