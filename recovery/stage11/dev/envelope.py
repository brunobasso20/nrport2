"""diagnostic: Luau rows vs the original rows, against the original's sensitivity (fixture start-kick twins and per-frame
noise twins from dev/frames.py ... noise<seed>):   py dev/envelope.py <scenario> <lua.jsonl> <noise.jsonl> [...]"""
import sys, json
from pathlib import Path
HERE = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(HERE))
from gen_fixtures11 import ROW_FIELDS

INT = {'dmg0', 'dmg8', 'dmgC', 'gear', 'rng'}


def load(p):
    return {r[0]: r for r in (json.loads(l) for l in open(p, encoding='utf-8-sig') if l.startswith('['))}


name, lua = sys.argv[1], load(sys.argv[2])
noise = [load(p) for p in sys.argv[3:]]
doc = json.load(open(HERE / 'fixtures_json' / (name + '.json')))
show = ['fuel', 'water', 'oil', 'surfaceMid2', 'wear2', 'brake0', 'x', 'vx', 'omegaEngine']
bad_k = bad_n = 0
for i, row in enumerate(doc['rows']):
    f = row[0]
    if f not in lua: break
    L = lua[f]
    parts = []
    for j, fld in enumerate(ROW_FIELDS, 1):
        if fld in INT: continue
        o = row[j]
        dk = max(abs(p[i][j] - o) for p in doc['pert'])
        dn = max([abs(n[f][j] - o) for n in noise if f in n] or [0])
        dl = abs(L[j] - o)
        floor = max(2e-5 * abs(o), 1e-6)
        if dl > max(4 * dk, floor): bad_k += 1
        if dl > max(4 * max(dk, dn), floor): bad_n += 1
        if fld in show: parts.append('%s %.1e/%.1e/%.1e' % (fld, dl, dk, dn))
    if i % 5 == 0: print('frame %4d lua/kick/noise  %s' % (f, '  '.join(parts)))
print('%s: field-rows outside 4x kick envelope %d, outside 4x (kick+noise) envelope %d' % (name, bad_k, bad_n))
