"""diagnostic: a debug fixture with full-state restarts at chosen frames (tests/stage11/fixtures/scenario_<name>dbg.lua,
no twins rows: only the restart checks of run.luau are meaningful):   py dev/restart_probe.py <scenario> <frame> ..."""
import sys
from pathlib import Path
HERE = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(HERE))
import gen_fixtures11 as G

name, frames = sys.argv[1], [int(a) for a in sys.argv[2:]]
G.restart_frames = lambda n: frames
G.SYNC_EVERY[name] = []
ref = G.run(name, sync=True)
law = G.law_table(name); law['horizon'] = 0
doc = dict(name=name + 'dbg', law=law, rows=ref['rows'], pert=[], sync=[], start=ref['start'], restart=ref['restart'])
out = HERE.parent.parent / 'tests' / 'stage11' / 'fixtures' / ('scenario_%sdbg.lua' % name)
out.write_text('-- diagnostic fixture (recovery/stage11/dev/restart_probe.py)\nreturn ' + G.lua_value(doc) + '\n')
print('written', out, len(ref['restart']), 'restarts')
