"""Stage 11 dev: fine-grained ORIGINAL snapshots inside one frame end (diagnostics for the Luau port).
Runs a scenario to frame F, then executes the frame end with code hooks at the entry of each 0054d610 call and
dumps the Stage 11 footprint at: before the frame end, after the world record sync, each 0054d610 entry (4),
00554520 return, after 00549c40. Output: tests/stage11/dev_steps_<scenario>_<F>.lua
Usage: python dump_steps.py <scenario> <frame>"""
import sys, json, base64
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
import orig_stage11 as O
import scenarios11 as SC
import gen_fixtures11 as G
from unicorn import UC_HOOK_CODE

name, F = sys.argv[1], int(sys.argv[2])
session, frames, law, events, opts = SC.SCENARIOS[name]
st = [0.0] * 45; st[4] = 0.42; st[9] = 1.0
o = O.OriginalStage11(state=st, weather=session, **opts)
m = o.m
flat4 = O.flat()
for k in range(F - 1):
    c = law(k)
    for t in range(8): o.step_driver(c, flat4)
c = law(F - 1)
for t in range(7): o.step_driver(c, flat4)
o.drive_tick(flat4)
steps = [('before', G.grab(m, G.TOUCH_RUNS))]
O.sync_world_record(m)
steps.append(('synced', G.grab(m, G.TOUCH_RUNS)))
def hook(uc, addr, size, user):
    steps.append(('tyre_ecx_%x' % uc.reg_read(O.UC_X86_REG_ECX), G.grab(m, G.TOUCH_RUNS)))
m.uc.ctl_flush_tb()
h = m.uc.hook_add(UC_HOOK_CODE, hook, begin=0x54d610, end=0x54d610)
m.call(0x554520)
m.uc.hook_del(h)
steps.append(('after554520', G.grab(m, G.TOUCH_RUNS)))
m.call(0x549c40)
steps.append(('after549c40', G.grab(m, G.TOUCH_RUNS)))
out = HERE.parent.parent.parent / 'tests' / 'stage11' / ('dev_steps_%s_%d.lua' % (name, F))
out.write_text('return ' + G.lua_value([dict(name=n, mem=s) for n, s in steps]) + '\n')
print('wrote', out, [n for n, _ in steps])
