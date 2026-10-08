"""diagnostic: re-run a scenario's reference run and report which part of the stored fixture it does not reproduce
(rows / sync snapshots / start footprint), down to the first differing dword:   py dev/repro_check.py <scenario>"""
import sys, json, base64, struct
from pathlib import Path
HERE = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(HERE))
import gen_fixtures11 as G

name = sys.argv[1]
doc = json.loads((HERE / 'fixtures_json' / ('%s.json' % name)).read_text())
r = G.run(name, sync=True)
print('rows equal', doc['rows'] == r['rows'], ' start equal', doc['start'] == r['start'], ' sync count', len(doc['sync']), len(r['sync']))


def words(s): b = base64.b64decode(s); return struct.unpack('<%dI' % (len(b) // 4), b)


def addr_of(runs, k):
    for a, n in runs:
        if k < n: return a + 4 * k
        k -= n


for i, (x, y) in enumerate(zip(doc['sync'], r['sync'])):
    for part, runs in (('before', G.TOUCH_RUNS), ('after', G.WRITE_RUNS)):
        if x[part] != y[part]:
            wa, wb = words(x[part]), words(y[part])
            diff = [k for k in range(min(len(wa), len(wb))) if wa[k] != wb[k]]
            print('sync %d (%s frame %d) %s differs: %d dwords, first %s' % (i, x['kind'], x['frame'], part, len(diff),
                  ['%08x %08x->%08x' % (addr_of(runs, k), wa[k], wb[k]) for k in diff[:6]]))
if doc['start'] != r['start']:
    wa, wb = words(doc['start']), words(r['start'])
    diff = [k for k in range(min(len(wa), len(wb))) if wa[k] != wb[k]]
    print('start differs: %d dwords, first %s' % (len(diff), ['%08x %08x->%08x' % (addr_of(G.TOUCH_RUNS, k), wa[k], wb[k]) for k in diff[:6]]))
