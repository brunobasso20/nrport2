"""diagnostic: the original's own 1-ulp sensitivity in a fixture: per row, the spread of the three twins for chosen
fields:   py dev/twins.py <scenario> [field ...]"""
import sys, json
from pathlib import Path
HERE = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(HERE))
from gen_fixtures11 import ROW_FIELDS

name = sys.argv[1]
fields = sys.argv[2:] or ['fuel', 'water', 'oil', 'wear2', 'surfaceMid2', 'x', 'vx', 'omegaEngine', 'gear']
doc = json.load(open(HERE / 'fixtures_json' / (name + '.json')))
idx = {f: i + 1 for i, f in enumerate(ROW_FIELDS)}
for i, row in enumerate(doc['rows']):
    parts = []
    for f in fields:
        j = idx[f]
        tw = [p[i][j] for p in doc['pert']]
        parts.append('%s %.6g [%s]' % (f, row[j], ' '.join('%+.2e' % (t - row[j]) for t in tw)))
    print('frame %4d  %s' % (row[0], '  '.join(parts)))
