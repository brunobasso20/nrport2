"""Per-step fixture: dwords touched by the application, value after each step (Unicorn)."""
import sys, json, base64, pickle
from pathlib import Path
HERE = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(HERE)); sys.path.insert(0, str(HERE.parent / 'stage6_7'))
import trace_apply, orig_setup as OS
items = {int(k): v for k, v in json.loads(sys.argv[2]).items()} if len(sys.argv) > 2 else {}
P, Q, first = trace_apply.trace(items)
LO = 0x6e9000
idx = [k for k in range(len(first)) if first[k]]
m = OS.boot(); OS.prepare(m)
snaps = {}
def on_step(s):
    snaps[s] = OS.snapshot(m)
OS.apply(m, items, on_step)
out = ['return {items={%s}, steps={' % ','.join('[%d]=%d' % (i, v) for i, v in items.items())]
for s in sorted(snaps):
    S = snaps[s]
    # runs over touched dwords
    runs = []; k = 0
    while k < len(idx):
        j = k
        while j + 1 < len(idx) and idx[j + 1] == idx[j] + 1: j += 1
        a, b = idx[k], idx[j] + 1
        runs.append('{%d,"%s"}' % (4 * a, base64.b64encode(S[4 * a:4 * b]).decode()))
        k = j + 1
    out.append('{' + ','.join(runs) + '},')
out.append('}}')
Path(sys.argv[1]).write_text('\n'.join(out) + '\n')
print('steps', len(snaps), 'touched dwords', len(idx))
