"""Stage 11 exploration: run the ORIGINAL frame end 00554520 (whole function) in Unicorn after every
36 Hz frame of a drive, and record (a) the functions executed under it, (b) indirect call targets,
(c) memory read/written by each direct callee of 00554520 / 00551990. Diagnostic tool (no outputs used
by the port directly); results in recovery/stage11/evidence/explore_*.txt"""
import sys, struct, json, collections
from pathlib import Path
HERE = Path(__file__).resolve().parent.parent      # recovery/stage11 (this file: dev/)
sys.path.insert(0, str(HERE.parent / 'stage9')); sys.path.insert(0, str(HERE.parent / 'stage8'))
sys.path.insert(0, str(HERE.parent / 'stage6_7'))
from orig_aero import *          # noqa
from unicorn import UC_HOOK_BLOCK, UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE
import capstone

EV = HERE / 'evidence'; EV.mkdir(exist_ok=True)
FUNCS = []
for line in (HERE.parent / 'baseline' / 'functions.tsv').read_text().splitlines()[1:]:
    f = line.split('\t'); FUNCS.append((int(f[0], 16), int(f[3]), f[1]))
FUNCS.sort()
import bisect
STARTS = [a for a, _, _ in FUNCS]
def func_of(a):
    k = bisect.bisect_right(STARTS, a) - 1
    if k >= 0 and FUNCS[k][0] <= a < FUNCS[k][0] + max(FUNCS[k][1], 1): return FUNCS[k][0]
    return None

class Explore(OriginalAero):
    pass

def drive_controls(k):
    # simple drive: launch in 1st, shift up every 1.5 s, steer slightly, brake at the end
    t = k / 36.0
    c = dict(throttle=1.0 if t < 7 else 0.0, clutch=1.0, steer=0.01 if 3 < t < 6 else 0.0,
             brakeControl=1.0 if t >= 7 else 0.0, brakeDigital=True)
    c['shiftUp'] = (k % 54 == 10) and t < 6
    return c

def main(frames=360):
    o = Explore()
    m = o.m
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    executed = collections.Counter(); indirect = collections.Counter()
    state = {'on': False}
    def blk(uc, addr, size, user):
        if not state['on']: return
        f = func_of(addr)
        executed[f if f is not None else addr] += 0
        if f == addr: executed[f] += 1
    m.uc.hook_add(UC_HOOK_BLOCK, blk, begin=0x401000, end=0x6e9000)
    # indirect calls: decode 'call' with non-immediate operand at block ends is costly; instead record
    # every block start that is a function entry and not called by a direct call (resolved later)
    flat4 = flat()
    log = []
    for k in range(frames):
        c = drive_controls(k)
        o.frame(c)
        for t in range(8):
            o.drive_tick(flat4)
        state['on'] = True
        m.call(0x554520)
        state['on'] = False
        if k % 36 == 35:
            eng = 0xc12030 + 0xc
            log.append('frame %d rpm %.1f gear %d fuel? %08x %08x' % (k + 1, m.f32(0xbf6d40 + 4 * 34) * 9.5493, m.i32(0x74c97c),
                                                                       m.u32(eng + 0x50c), m.u32(eng + 0x514)))
    names = {a: n for a, _, n in FUNCS}
    out = ['executed functions under 00554520 (entry hits):']
    for a, n in sorted(executed.items(), key=lambda x: (x[0] or 0)):
        out.append('%08x %-30s %d' % (a or 0, names.get(a, '?'), n))
    out += log
    (EV / 'explore_executed.txt').write_text('\n'.join(out) + '\n')
    print('\n'.join(out[:200]))
    print('imports called', collections.Counter(m.calls).most_common(20))

if __name__ == '__main__':
    main(int(sys.argv[1]) if len(sys.argv) > 1 else 360)
