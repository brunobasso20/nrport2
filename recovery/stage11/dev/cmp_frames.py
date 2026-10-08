"""diagnostic: compare two per-frame row files (dev/frames.py vs tests/stage11/frames.luau); prints, per frame,
the fields whose relative difference exceeds a threshold:   py dev/cmp_frames.py orig.jsonl lua.jsonl [rel] [maxlines]"""
import sys, json
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from gen_fixtures11 import ROW_FIELDS

NAMES = ['frame'] + ROW_FIELDS + ['s%d' % k for k in range(45)]


def load(p):
    out = []
    for line in open(p, encoding='utf-8-sig'):
        line = line.strip()
        if line.startswith('['): out.append(json.loads(line))
    return out


a, b = load(sys.argv[1]), load(sys.argv[2])
rel = float(sys.argv[3]) if len(sys.argv) > 3 else 1e-6
maxl = int(sys.argv[4]) if len(sys.argv) > 4 else 40
n = 0
for ra, rb in zip(a, b):
    bad = []
    for j in range(1, len(ra)):
        x, y = ra[j], rb[j]
        d = abs(x - y) / max(abs(x), abs(y), 1e-9)
        if d > rel and abs(x - y) > 1e-9: bad.append('%s %.9g/%.9g' % (NAMES[j], x, y))
    if bad:
        print('frame %d: %d fields: %s' % (ra[0], len(bad), '; '.join(bad[:12])))
        n += 1
        if n >= maxl: break
print('frames compared', min(len(a), len(b)))
