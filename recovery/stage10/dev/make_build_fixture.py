"""Fixture for the Luau rebuild test: every dword touched by the ORIGINAL application sequence, with its
value after the Unicorn run (base64 runs). Optional items: JSON {index: raw}."""
import sys, json, base64, pickle
from pathlib import Path
HERE = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(HERE)); sys.path.insert(0, str(HERE.parent / 'stage6_7'))
import trace_apply
items = {int(k): v for k, v in json.loads(sys.argv[2]).items()} if len(sys.argv) > 2 else {}
P, Q, first = trace_apply.trace(items)
runs = []; k = 0; n = len(first)
while k < n:
    if not first[k]: k += 1; continue
    j = k
    while j < n and first[j]: j += 1
    runs.append((k, j)); k = j
out = ['return {items={%s}, runs={' % ','.join('[%d]=%d' % (i, v) for i, v in items.items())]
for a, b in runs: out.append('{%d,"%s"},' % (4 * a, base64.b64encode(Q[4 * a:4 * b]).decode()))
out.append('}}')
Path(sys.argv[1]).write_text('\n'.join(out) + '\n')
print('runs', len(runs))
