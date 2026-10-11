"""dev: Luau rows vs original rows with the envelope of (a) the 10 Stage 11 twins, (b) + the allframe twins"""
import sys, json
from pathlib import Path
name = sys.argv[1]
doc = json.load(open(Path(__file__).resolve().parent.parent / 'fixtures_json' / ('%s.json' % name)))
lua = json.load(open(sys.argv[2])); extra = json.load(open('/opt/s12/allframe_%s.json' % name))
F = doc['fields']; idx = {f: i + 1 for i, f in enumerate(F)}
lmap = {'x': 1, 'vx': 2, 'y': 3, 'vy': 4, 'z': 5, 'vz': 6, 'r': 13, 'input': 14, 'target': 15, 'current': 16, 'lf': 18, 'rf': 19,
        'hubLF': 20, 'hubRF': 21, 'drawSteer': 22, 'speedCache': 23, 'fyLF': 24, 'fyRF': 25, 'fyLR': 26, 'fyRR': 27, 'omegaEngine': 28}
rows = doc['rows'][1:]
for label, perts in (('stage11 twins', doc['pert']), ('+ allframe', doc['pert'] + extra)):
    P = [p[1:] for p in perts]
    bad, first = 0, None
    for i, (o, l) in enumerate(zip(rows, lua)):
        for f, li in lmap.items():
            j = idx[f]; a, b = l[li], o[j]
            env = 0
            for mm in range(max(0, i - 1), min(len(rows), i + 2)):
                for p in P: env = max(env, abs(p[mm][j] - rows[mm][j]))
            if abs(a - b) > max(4 * env, 2e-5 * abs(b), 1e-6):
                bad += 1; first = first or (o[0], f, a, b, env)
    print('%-14s outside 4x envelope: %d field-rows  first %s' % (label, bad, first))
