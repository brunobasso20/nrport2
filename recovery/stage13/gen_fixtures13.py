"""Stage 13 scenario fixtures from the ORIGINAL code executed in Unicorn (orig_stage13.OriginalStage13), for
tests/stage13/run.luau:

  stats   level 2: the ORIGINAL 00554d30 of the closed-loop run, traced at its call (code hooks @00554d30 / @00553a69):
          n / A / B / C / D in -> 74c960, bf6ec4, bf6ec8, bf6ed0 out (every tick in FULL scenarios, else every 4th tick)
  blocks  level 2: the ORIGINAL FFB block of every frame end (hooks @0055464c / @00554778): gates, ec4 / ec0 / ecc / ed0,
          airspeed, latency, damping, strength, item 0x30, axis in -> bf6ec0, bf6ecc, 005d08d0 calls out
  ffb     level 4: per frame after the frame end: the force sent by the block (or none), n_LF / n_RF at the block, ec4,
          ed0, ecc, 74c960, bf6ec8, bf6ebb, bf6eb8, bf6ebc; 'pertFfb' = the same of the original's twins (Stage 12 PERTURB:
          chassis z +-1 ulp at the start, 8 chassis-height noise twins, 4 'all' twins)
  rows    level 4: the Stage 12 observation rows every 9 frames (+ twins), for the new law 'suspend' and every scenario
  device  the ORIGINAL code's device-call sequence (acquire / release / force) of the whole run
Usage: python gen_fixtures13.py [-j workers] <tests/stage13/fixtures dir> [scenario...]"""
import sys, json, base64, struct, time
from multiprocessing import Pool
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE.parent / 'stage12'))
sys.path.insert(0, str(HERE.parent / 'stage11'))
import orig_stage13 as O                                              # noqa: E402
import scenarios13 as SC                                              # noqa: E402
import gen_fixtures11 as G11                                          # noqa: E402
import gen_fixtures12 as G12                                          # noqa: E402
from unicorn import UC_HOOK_CODE                                      # noqa: E402

PERTURB = G12.PERTURB
FULL = {'slalom', 'suspend'}
ACC = [0x74c964, 0x74c968, 0xbf6ed4, 0xbf6ed8, 0xbf6edc, 0xbf6ee0, 0xbf6ee4, 0xbf6ee8, 0xbf6eec, 0xbf6ef0]
OUTS = [0x74c960, 0xbf6ec4, 0xbf6ec8, 0xbf6ed0]
BLOCK_IN = [0xbf6ec4, 0xbf6ec0, 0xbf6ecc, 0xbf6ed0, 0xbf3a00, O.LATENCY, O.DAMPING, O.STRENGTH, 0xc055c0 + 4 * 0x30, O.AXIS]
FFB_FIELDS = ['force', 'blockRan', 'nLF', 'nRF', 'ec4', 'ed0', 'ecc', 'load', 'fy', 'acquired', 'suspended', 'axis']


def pack(words):
    return base64.b64encode(struct.pack('<%dI' % len(words), *[w & 0xffffffff for w in words])).decode()


class Trace:
    """code hooks on the ORIGINAL 00554d30 call (@00554d30 entry, @00553a69 return in 005539c0) and the FFB block"""
    def __init__(self, o, every):
        self.o, self.m, self.every = o, o.m, every
        self.stats, self.blocks, self.cur, self.blk = [], [], None, None
        self.block_n = (0, 0); self.block_force = None; self.block_ran = False
        m = self.m
        m.uc.hook_add(UC_HOOK_CODE, self._stats_in, begin=0x554d30, end=0x554d30)
        m.uc.hook_add(UC_HOOK_CODE, self._stats_out, begin=0x553a69, end=0x553a69)
        m.uc.hook_add(UC_HOOK_CODE, self._block_in, begin=O.FFB_BLOCK, end=O.FFB_BLOCK)
        m.uc.hook_add(UC_HOOK_CODE, self._block_out, begin=O.FFB_BLOCK_END, end=O.FFB_BLOCK_END)
    def _stats_in(self, uc, a, s, u):
        self.cur = [self.m.u32(x) for x in ACC]
    def _stats_out(self, uc, a, s, u):
        if self.cur is not None and self.o.tick % self.every == 0:
            self.stats.append([self.o.tick] + self.cur + [self.m.u32(x) for x in OUTS])
        self.cur = None
    def _block_in(self, uc, a, s, u):
        m = self.m
        self.blk = [O.u8(m, O.ACQUIRED), O.u8(m, O.SUSPENDED)] + [m.u32(x) for x in BLOCK_IN]
        self.block_n = (m.u32(0x74c964), m.u32(0x74c968))
        self.mark = len(m.ffb_log)
    def _block_out(self, uc, a, s, u):
        m = self.m
        calls = [c for c in m.ffb_log[self.mark:] if c[0] == 'force']
        self.block_force = calls[-1][2] if calls else None
        self.block_ran = bool(calls)
        self.blocks.append([self.o.tick] + self.blk + [m.u32(0xbf6ec0), m.u32(0xbf6ecc), len(calls), calls[-1][2] if calls else 0])


def ffb_row(o, tr, frame):
    m = o.m
    nan = 0x7fc00000
    return [frame, tr.block_force if tr.block_force is not None else nan, 1 if tr.block_ran else 0, tr.block_n[0], tr.block_n[1],
            m.u32(0xbf6ec4), m.u32(0xbf6ed0), m.u32(0xbf6ecc), m.u32(0x74c960), m.u32(0xbf6ec8), O.u8(m, O.ACQUIRED),
            O.u8(m, O.SUSPENDED), m.u32(O.AXIS)]


def run(name, perturb=0, sync=False):
    session, frames, law, events, opts = SC.SCENARIOS[name]
    noise, kick, allseed = None, None, None
    if perturb:
        p = PERTURB[perturb]
        if p[0] == 'kick': kick = (p[1], p[2])
        elif p[0] == 'all': allseed = p[1]
        else: noise = p[1]
    o = SC.make(name, kick=kick)
    m = o.m
    tr = Trace(o, 1 if name in FULL else 4)
    flat4 = O.flat()
    out = {'rows': [[0] + G12.observe(o)], 'ffb': []}
    for k in range(frames):
        c = law(k)
        for ev in events.get(k, []):
            if ev[0] == 'controls': o.controls(ev[1])
        if noise is not None:
            noise = (noise * 1103515245 + 12345) & 0x7fffffff
            u = m.u32(G11.Z_CELL); m.w32(G11.Z_CELL, u + (1 if noise & 0x10000 else -1))
        if allseed is not None: allseed = G11.state_noise(o, allseed)
        tr.block_force, tr.block_ran, tr.block_n = None, False, (0, 0)
        for t in range(8): o.step_driver(c, flat4)
        out['ffb'].append(ffb_row(o, tr, k + 1))
        if (k + 1) % 9 == 0: out['rows'].append([k + 1] + G12.observe(o))
    if sync:
        out['stats'] = pack([w for r in tr.stats for w in r]); out['statsCount'] = len(tr.stats)
        out['blocks'] = pack([w for r in tr.blocks for w in r]); out['blocksCount'] = len(tr.blocks)
        out['device'] = [[{'force': 0, 'acquire': 1, 'release': 2}[c[0]], c[1], c[2] if len(c) > 2 else 0] for c in m.ffb_log]
    return out


def law_table(name):
    session, frames, law, events, opts = SC.SCENARIOS[name]
    return dict(session=session, frames=frames,
                options={k: v for k, v in opts.items() if k not in ('steer', 'ratio', 'ffb', 'device')},
                steer=opts.get('steer'), ratio=opts.get('ratio'), ffb=opts.get('ffb'), device=opts.get('device'),
                events=[[k, e[0], e[1]] for k, evs in sorted(events.items()) for e in evs],
                horizon=G12.HORIZON.get(name), controls=[G12.law_row(law(k)) for k in range(frames)])


def _task(t):
    name, p = t
    t0 = time.time()
    r = run(name, perturb=p, sync=(p == 0))
    return name, p, (r if p == 0 else {'rows': r['rows'], 'ffb': r['ffb']}), time.time() - t0


def write_scenario(out, js, name, got):
    ref = got[(name, 0)]
    pert = [got[(name, p)] for p in sorted(PERTURB)]
    doc = dict(name=name, law=law_table(name), fields=G12.ROW_FIELDS, ffbFields=FFB_FIELDS, rows=ref['rows'],
               pert=[p['rows'] for p in pert], ffb=ref['ffb'], pertFfb=[p['ffb'] for p in pert],
               pertKinds=[PERTURB[p][0] for p in sorted(PERTURB)], stats=ref['stats'], statsCount=ref['statsCount'],
               statsEvery=1 if name in FULL else 4, blocks=ref['blocks'], blocksCount=ref['blocksCount'], device=ref['device'])
    (js / ('%s.json' % name)).write_text(json.dumps(doc))
    (out / ('scenario_%s.lua' % name)).write_text('-- GENERATED by recovery/stage13/gen_fixtures13.py from the ORIGINAL NR2003 code (Unicorn); do not edit.\n'
                                                   'return ' + G11.lua_value(doc) + '\n')
    nf = sum(1 for r in ref['ffb'] if r[2])
    print('%-10s frames %d (block ran %d) stats %d blocks %d device calls %d twins %d' % (
        name, len(ref['ffb']), nf, ref['statsCount'], ref['blocksCount'], len(ref['device']), len(pert)), flush=True)


def main(out_dir, names, workers=4):
    out = Path(out_dir); out.mkdir(parents=True, exist_ok=True)
    js = HERE / 'fixtures_json'; js.mkdir(exist_ok=True)
    tasks = [(n, p) for n in sorted(names, key=lambda n: -SC.SCENARIOS[n][1]) for p in [0] + sorted(PERTURB)]
    got = {}
    t0 = time.time()
    with Pool(workers) as pool:
        for name, p, r, dt in pool.imap_unordered(_task, tasks):
            got[(name, p)] = r
            print('  %-10s run %2d  %.1f s' % (name, p, dt), flush=True)
            if all((name, q) in got for q in [0] + sorted(PERTURB)):
                write_scenario(out, js, name, got)
    print('total %.1f s' % (time.time() - t0))


if __name__ == '__main__':
    args = sys.argv[1:]
    workers = 4
    if args[:1] == ['-j']: workers = int(args[1]); args = args[2:]
    names = args[1:] or list(SC.SCENARIOS)
    out = args[0] if args else str(HERE.parent.parent / 'tests' / 'stage13' / 'fixtures')
    main(out, names, workers)
