"""dev: Luau rows (tests/stage12/dev/rows.luau) vs the original rows and the 10 twins of a scenario: per field,
the first row where |lua - orig| exceeds 4x the twin envelope, and the evolution of key fields"""
import sys, json
from pathlib import Path
name = sys.argv[1]
doc = json.load(open(Path(__file__).resolve().parent.parent / 'fixtures_json' / ('%s.json' % name)))
lua = json.load(open(sys.argv[2]))
F = doc['fields']
idx = {f: i + 1 for i, f in enumerate(F)}
keys = ['x', 'vx', 'y', 'vy', 'r', 'input', 'target', 'hubLF', 'speedCache', 'fyLF', 'fyRF', 'fyLR', 'fyRR']
lmap = {'x': 1, 'vx': 2, 'y': 3, 'vy': 4, 'r': 13, 'input': 14, 'target': 15, 'hubLF': 20, 'speedCache': 23,
        'fyLF': 24, 'fyRF': 25, 'fyLR': 26, 'fyRR': 27}
rows = doc['rows'][1:]; pert = [p[1:] for p in doc['pert']]
first = {}
for i, (o, l) in enumerate(zip(rows, lua)):
    for f in keys:
        j = idx[f]; a, b = l[lmap[f]], o[j]
        env = 0
        for m in range(max(0, i - 1), min(len(rows), i + 2)):
            for p in pert: env = max(env, abs(p[m][j] - rows[m][j]))
        if abs(a - b) > max(4 * env, 2e-5 * abs(b), 1e-6) and f not in first: first[f] = (o[0], a, b, env)
print('first outside 4x envelope:', first)
for i in range(0, len(rows), max(1, len(rows) // 30)):
    o, l = rows[i], lua[i]
    spread = max(abs(p[i][idx['x']] - o[idx['x']]) for p in pert)
    print('frame %4d  x %.4f/%.4f (twin spread %.2g)  vx %.4f/%.4f  r %.5f/%.5f  target %.6f/%.6f  fyLF %.1f/%.1f' % (
        o[0], l[1], o[idx['x']], spread, l[2], o[idx['vx']], l[13], o[idx['r']], l[15], o[idx['target']], l[24], o[idx['fyLF']]))
