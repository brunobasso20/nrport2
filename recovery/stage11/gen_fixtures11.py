"""Stage 11 fixtures from the ORIGINAL code executed in Unicorn (OriginalStage11), for tests/stage11/run.luau.

For every scenario of scenarios11.SCENARIOS:
  rows   observation rows every 18 frames (0.5 s): Stage 11 states (fuel, engine thermal / levels / power / wear,
         tyre pressure / temperatures / wear / grip, brake temperatures, damage) + chassis subset + rpm / gear
  pert   the same rows of ten twin runs of the original (its own sensitivity envelope for long horizons):
         chassis height +1 / -1 ulp at the start, and eight 'noise' twins with +-1 ulp on the chassis height cell of
         the multibody state (0xebdd74) at every frame start (signs from an LCG, seeds 1..8) -- the same kind of
         perturbation as the port's inherited per-tick rounding (Stage 6/7: x87 extended intermediates evaluated in
         IEEE double, 1..4 ulps on several state cells per frame, measured with dev/memdump.py, frozen mode)
  restart full-state restart points: the original's complete memory window at the start of frame R (every dword
         that differs from the session start state), its tyre contact blocks and interrupt clock, the dwords that
         change during frame R and the observation row after it, plus 12 one-frame twins of frame R (RESTART_TWINS:
         one integrated chassis cell +-1 ulp; whole 45-state vector +-1 ulp before every tick). The Luau test loads
         the state, runs frame R (8 ticks + frame end) and compares within the twins' envelope: the per-tick physics
         <-> Stage 11 coupling (tyre temperature / pressure / wear -> force, fuel -> mass) in every regime the long
         runs reach, without the chaotic amplification of a closed-loop comparison
  sync   memory snapshots of the Stage 11 footprint (footprint11.pkl) at chosen frames: 'before' = every dword the
         Stage 11 code touches, taken right before the frame end; 'after' = the dwords it writes, right after the
         frame end (00554520 + 00549c40, world record sync included). The Luau test loads 'before' into its own
         memory, runs its frame end and compares bit for bit (original vs Luau intermediate states).
  start  the footprint right after the Stage 11 session start (weather, options, 00550a50 subset)
Event snapshots (collision record entry, pit service) are included in 'sync' with kind = 'event'.
Usage: python gen_fixtures11.py [-j workers] [--restarts-only] <tests/stage11/fixtures dir> [scenario...]
(runs in a process pool; --restarts-only re-runs the reference runs and replaces the restart records only)"""
import sys, json, base64, pickle, struct, time, math, array
from multiprocessing import Pool
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import orig_stage11 as O
import scenarios11 as SC
from lift11 import BASE, TOP

FP = pickle.load(open(HERE / 'footprint11.pkl', 'rb'))
T = FP['touched']
TOUCH = [k for k, t in enumerate(T) if t]
WRITE = [k for k, t in enumerate(T) if t & 2]
# the Unicorn reference runs on its own stack (0x1f000000): the footprint holds no virtual-stack cell of the Luau port;
# host blocks (world record HOST+0x680, Stage 11 blocks 0xf7a000) are state and are compared
EXCL = (0, 0)
TOUCH = [k for k in TOUCH if not (EXCL[0] <= BASE + 4 * k < EXCL[1])]
WRITE = [k for k in WRITE if not (EXCL[0] <= BASE + 4 * k < EXCL[1])]
# cells read / written by the HOST side of the harness (Python, not seen by the Unicorn memory hooks) and by the
# identical host code of NR2003CupFrame: exported state block (world record sync, airspeed), world record, Stage 11 host
# blocks, getBGCount, airspeed / aero factors
HOST_RANGES = [(0xbf6d40, 0x40), (O.TOBJ, 0x32c), (O.S11, O.HOST_SIZE), (0x7559bc, 4), (O.CAR + 0x59e, 0x14), (O.COLL_OBJ, 4)]
_t = set(TOUCH); _w = set(WRITE)
for a, n in HOST_RANGES:
    for x in range(a & ~3, a + n, 4):
        _t.add((x - BASE) >> 2)
for a, n in HOST_RANGES[1:3]:
    for x in range(a & ~3, a + n, 4):
        _w.add((x - BASE) >> 2)
TOUCH, WRITE = sorted(_t), sorted(_w)


def runs(idx):
    out = []
    for k in idx:
        if out and out[-1][0] + out[-1][1] == k: out[-1][1] += 1
        else: out.append([k, 1])
    return [[BASE + 4 * a, n] for a, n in out]


TOUCH_RUNS, WRITE_RUNS = runs(TOUCH), runs(WRITE)


def grab(m, rr):
    return base64.b64encode(b''.join(bytes(m.uc.mem_read(a, 4 * n)) for a, n in rr)).decode()


def f32b(u): return struct.unpack('<f', struct.pack('<I', u))[0]


def observe(o):
    m = o.m; E = O.ENGINE; D = O.DAMAGE
    s = o.state()
    row = [O.protected_f64(m, E + 0x50c), O.protected_f32(m, E + 0x4a4), O.protected_f32(m, E + 0x4d4),
           m.f32(E + 0x4a0), m.f32(E + 0x49c), m.f32(E + 0x554), m.f32(E + 0x508), m.f32(E + 0x558)]
    for w in range(4):
        t = O.TIRE[w]
        row += [m.f32(t + 0x2a0), O.protected_f32(m, t + 0x18c), O.protected_f32(m, t + 0x210), O.protected_f32(m, t + 0x74),
                m.f32(t + 0xcc), O.protected_f32(m, t + 0x26c)]
    row += [m.u32(D), m.u32(D + 8), m.u32(D + 0xc)] + [m.f32(D + 0x10 + 4 * k) for k in range(11)]
    row += [m.f32(D + 0x4c), m.f32(D + 0x50), m.f32(D + 0x54), m.f32(D + 0x58)]
    row += [s[0], s[1], s[2], s[3], s[4], s[5], s[34], m.i32(0x74c97c), m.f32(m.u32(m.u32(0xc08234) + 0x125)), m.u32(0xf6eae4)]
    return row


ROW_FIELDS = ['fuel', 'water', 'oil', 'coolantLevel', 'oilLevel', 'power', 'overRev', 'engineWear'] + \
    ['%s%d' % (f, w) for w in range(4) for f in ('pressure', 'surfaceMid', 'carcassMid', 'wear', 'gripWear', 'brake')] + \
    ['dmg0', 'dmg8', 'dmgC'] + ['zone%d' % k for k in range(11)] + ['leakRadiator', 'leakOil', 'leakFuel', 'engineDamage'] + \
    ['x', 'vx', 'y', 'vy', 'z', 'vz', 'omegaEngine', 'gear', 'fuelRecordMass', 'rng']

SYNC_EVERY = {'launch': [1, 36, 400, 1080, 1300], 'overrev': [36, 700], 'brakes': [330, 900], 'slide': [200, 800],
              'cold': [120], 'hot': [120], 'impacts': [181, 400, 701, 900], 'pit': [541, 700], 'enter': [433, 500],
              'x4': [400], 'idle': [500], 'failure': list(range(196, 218))}
# last row compared as a closed-loop trajectory (later frames: validated by the snapshots and full-state restarts)
#   failure  the random driveline failure follows (frame 207); its threshold is a draw the port's rounding can flip
#   overrev  car in neutral at the rev limiter, quasi-static stick-slip creep: the INHERITED Stage 6-10 per-tick runtime
#            leaves the original's creep branch from ~frame 90 also in frozen mode (no Stage 11 code; dev/frames.py vs
#            tests/stage11/dev/frames.luau ... frozen: frame 108 vx 0.0240 vs 0.0055 m/s), which then shifts the brake
#            heating of the rolling wheels; none of the original's twins does
#   hot      110 F full-throttle launch: from frame ~252 the original's own twins disagree on the regime (engine-speed
#            spread up to 88 %; 2 of the 8 noise twins -- 3 of 10 seeds in dev/frames.py -- leave the wheel-spin regime,
#            as the port does) while the tyre surface temperatures sit on the 505 K cap of 0054d610, where the twin
#            envelope collapses to 0 (a 1 K dip below the cap is ordinary: the twins show it on the other rear tyre)
HORIZON = {'failure': 198, 'overrev': 108, 'hot': 252}


def ulp(x, d):
    return struct.unpack('<f', struct.pack('<I', struct.unpack('<I', struct.pack('<f', x))[0] + d))[0]


# twin k: ('kick', initial state index, ulps) = chassis z +1 / -1 ulp at the start; ('noise', seed) = +-1 ulp on the
# multibody chassis height cell at every frame start (0xebdd74: the integrated state; the velocity copies are derived)
PERTURB = {1: ('kick', 4, 1), 2: ('kick', 4, -1)}
PERTURB.update({2 + s: ('noise', s) for s in range(1, 9)})    # 8 noise twins, seeds 1..8 (fixed for every scenario)
Z_CELL = 0xebdd74
# restart twins on the integrated multibody chassis state (0xebdd64 x, 0xebdd74 z, 0xebdd7c quaternion; a 1-ulp change
# of these propagates -- dev/frames.py experiments; the y cell and the velocity copies do not):
#   ('kick', cell, ulps)  one +-1 ulp change at the start of frame R
#   ('all', seed)         before every tick of frame R: ORIGINAL export 005b2cb0 of the 45-state vector, +-1 ulp on
#                         every value (signs from an LCG), ORIGINAL import 005b4560 (the V.translate path): the
#                         per-tick perturbation class of the port's inherited rounding, spread over all 16 components
#                         (the port differs by 1..4 ulps on several state cells per frame: dev/memdump.py, frozen mode).
#                         An unperturbed export/import round trip leaves the frame bit-identical (dev/restart_twin2.py);
#                         a perturbation of the three chassis cells only misses e.g. the head states (s40..s44)
STATE_CELLS = (0xebdd64, Z_CELL, 0xebdd7c)
EXPORT_SCRATCH = 0xf7f100 + 0x140  # host export scratch (HOST + 0x140, as the Luau core)
RESTART_TWINS = ([('kick', Z_CELL, 1), ('kick', Z_CELL, -1), ('kick', 0xebdd64, 1), ('kick', 0xebdd64, -1),
                  ('kick', 0xebdd7c, 1), ('kick', 0xebdd7c, -1)] + [('all', s) for s in range(1, 7)])


def state_noise(o, seed):
    """+-1 ulp on the whole 45-state vector through the original export / import (one tick of an 'all' twin)"""
    m, S = o.m, EXPORT_SCRATCH
    m.w32(0xe847c8, S); m.call(0x5b2cb0, S, o.root)
    for i in range(45):
        seed = (seed * 1103515245 + 12345) & 0x7fffffff
        m.w32(S + 4 * i, m.u32(S + 4 * i) + (1 if seed & 0x10000 else -1))
    m.w32(0xe847c8, S); m.w32(0xe84664, 0xe84474); m.call(0x5b4560, o.root)
    return seed
# full-state restart points: every 5 s from 2.5 s, plus frames right after events (no event / frame snapshot at R)
RESTART_EXTRA = {'impacts': [184, 546, 742], 'pit': [545], 'enter': [440], 'failure': [150, 230]}
SKIP = (0xf7b000, 0xf7f100)        # Luau virtual stacks (the Unicorn reference runs on its own stack)
INTCOUNT = 0xf7f010                # orig_brake.INTCOUNT: value returned by the harness getIntCount (005f7cd0)
NW = (TOP - BASE) // 4


def restart_frames(name):
    session, frames, law, events, opts = SC.SCENARIOS[name]
    want = set(SYNC_EVERY.get(name, []))
    rs = set(range(90, frames - 1, 180)) | set(RESTART_EXTRA.get(name, []))
    return sorted(r for r in rs if r < frames and r not in events and (r + 1) not in want and r not in want)


def window(m):
    w = array.array('I')
    w.frombytes(bytes(m.uc.mem_read(BASE, TOP - BASE)))
    return w


def _kept(i):
    return not (SKIP[0] <= BASE + 4 * i < SKIP[1])


def run(name, perturb=0, sync=False):
    session, frames, law, events, opts = SC.SCENARIOS[name]
    st = [0.0] * 45; st[4] = 0.42; st[9] = 1.0
    noise = None
    if perturb:
        p = PERTURB[perturb]
        if p[0] == 'kick': st[p[1]] = ulp(st[p[1]], p[2])
        else: noise = p[1]
    o = O.OriginalStage11(state=st, weather=session, **opts)
    m = o.m
    out = {'rows': [], 'sync': [], 'restart': [], 'start': grab(m, TOUCH_RUNS) if sync else None}
    want = set(SYNC_EVERY.get(name, [])) if sync else set()
    restarts = set(restart_frames(name)) if sync else set()
    w0 = window(m) if restarts else None
    flat4 = O.flat()
    out['rows'].append([0] + observe(o))
    for k in range(frames):
        wr = window(m) if k in restarts else None
        if wr is not None:
            # host state outside the window: the persistent per-wheel contact blocks of 0055e1e0 (harness heap; Luau:
            # host block BLK) and the getIntCount clock (orig_brake.INTCOUNT; Luau: 0x7559c4)
            blocks = [m.u32(o.blocks[w] + 4 * j) for w in range(4) for j in range(5)]
            intcount = m.u32(INTCOUNT)
            tick_r = o.tick
        for ev in events.get(k, []):
            if ev[0] == 'enter':
                before = grab(m, TOUCH_RUNS) if sync and k in want else None
                O.enter_track(o)
                if before: out['sync'].append(dict(kind='enter', frame=k, before=before, after=grab(m, WRITE_RUNS)))
        c = law(k)
        if noise is not None:
            noise = (noise * 1103515245 + 12345) & 0x7fffffff
            u = m.u32(Z_CELL); m.w32(Z_CELL, u + (1 if noise & 0x10000 else -1))
        for t in range(7): o.step_driver(c, flat4)
        # last tick of the frame with the frame end split out (snapshot right before it)
        o.frame_end_hook = None
        if sync and (k + 1) in want:
            o.drive_tick(flat4)
            before = grab(m, TOUCH_RUNS)
            o.frame_end()
            out['sync'].append(dict(kind='frame', frame=k + 1, before=before, after=grab(m, WRITE_RUNS)))
            o.state()
        else:
            o.step_driver(c, flat4)
        for ev in events.get(k, []):
            if ev[0] == 'collision':
                before = grab(m, TOUCH_RUNS) if sync else None
                o.collision(**ev[1])
                if sync: out['sync'].append(dict(kind='collision', frame=k + 1, args=ev[1], before=before, after=grab(m, WRITE_RUNS)))
            elif ev[0] == 'pit':
                before = grab(m, TOUCH_RUNS) if sync else None
                for w in ev[1]: m.call(0x550f10, w)
                if sync: out['sync'].append(dict(kind='pit', frame=k + 1, wheels=ev[1], before=before, after=grab(m, WRITE_RUNS)))
        if wr is not None:
            row1 = [k + 1] + observe(o) + list(o.state())
            w1 = window(m)                 # after the row: state() writes the export scratch block (host-only cells)
            saved1 = (bytes(w1), [bytes(m.uc.mem_read(b, 20)) for b in o.blocks], m.u32(INTCOUNT), o.tick)
            bi = [i for i in range(NW) if wr[i] != w0[i] and _kept(i)]
            ai = [i for i in range(NW) if w1[i] != wr[i] and _kept(i)]
            pack = lambda w, idx: base64.b64encode(struct.pack('<%dI' % len(idx), *[w[i] for i in idx])).decode()
            # the original's own one-frame sensitivity at R: frame R again from the saved state with one integrated
            # chassis state cell +1 / -1 ulp (height, x position, quaternion component: the cells whose 1-ulp change
            # propagates) -- the envelope of the Luau comparison, cell by cell
            twins = []
            for tw in RESTART_TWINS:
                m.uc.mem_write(BASE, bytes(wr))
                for w in range(4):
                    for j in range(5): m.w32(o.blocks[w] + 4 * j, blocks[5 * w + j])
                m.w32(INTCOUNT, intcount); o.tick = tick_r
                if tw[0] == 'kick':
                    m.w32(tw[1], m.u32(tw[1]) + tw[2])
                    for t in range(8): o.step_driver(c, flat4)
                else:
                    seed = tw[1]
                    for t in range(8):
                        seed = state_noise(o, seed)
                        o.step_driver(c, flat4)
                trow = [k + 1] + observe(o) + list(o.state())
                wt = window(m)
                ti = [i for i in range(NW) if wt[i] != w1[i] and _kept(i)]
                twins.append(dict(runs=runs(ti), values=pack(wt, ti), row=trow))
            m.uc.mem_write(BASE, saved1[0])
            for b, v in zip(o.blocks, saved1[1]): m.uc.mem_write(b, v)
            m.w32(INTCOUNT, saved1[2]); o.tick = saved1[3]
            out['restart'].append(dict(frame=k, beforeRuns=runs(bi), before=pack(wr, bi), afterRuns=runs(ai),
                                       after=pack(w1, ai), blocks=blocks, intCount=intcount, row=row1, twins=twins))
        if (k + 1) % 18 == 0: out['rows'].append([k + 1] + observe(o))
    return out


def law_table(name):
    """the control law and events of a scenario as data (the Luau test replays them)"""
    session, frames, law, events, opts = SC.SCENARIOS[name]
    ctl = []
    for k in range(frames):
        c = law(k)
        ctl.append([c.get('throttle', 0.0), c.get('clutch', 1.0), c.get('steer', 0.0), c.get('brakeControl', 0.0),
                    bool(c.get('shiftUp')), bool(c.get('shiftDown'))])
    ev = []
    for k, lst in sorted(events.items()):
        for e in lst:
            if e[0] == 'collision': ev.append([k, 'collision', e[1]])
            elif e[0] == 'pit': ev.append([k, 'pit', e[1]])
            elif e[0] == 'enter': ev.append([k, 'enter'])
    return dict(session=session, frames=frames, options=opts, controls=ctl, events=ev)


def lua_value(v):
    if isinstance(v, bool): return 'true' if v else 'false'
    if isinstance(v, int): return str(v)
    if isinstance(v, float):
        if v != v: return '0/0'
        if v in (float('inf'), float('-inf')): return '(1/0)' if v > 0 else '(-1/0)'
        return repr(v)
    if isinstance(v, str): return json.dumps(v)
    if isinstance(v, (list, tuple)): return '{' + ','.join(lua_value(x) for x in v) + '}'
    if isinstance(v, dict): return '{' + ','.join('[%s]=%s' % (k if isinstance(k, int) else json.dumps(k), lua_value(x)) for k, x in v.items()) + '}'
    if v is None: return 'nil'
    raise TypeError(v)


def _task(t):
    name, p = t
    t0 = time.time()
    r = run(name, perturb=p, sync=(p == 0))
    return name, p, (r if p == 0 else r['rows']), time.time() - t0


def main(out_dir, names, workers=4):
    out = Path(out_dir); out.mkdir(parents=True, exist_ok=True)
    js = HERE / 'fixtures_json'; js.mkdir(exist_ok=True)
    head = {'touchRuns': TOUCH_RUNS, 'writeRuns': WRITE_RUNS, 'fields': ROW_FIELDS}
    (out / 'footprint.lua').write_text('-- GENERATED by recovery/stage11/gen_fixtures11.py; do not edit.\n'
                                       '-- Stage 11 footprint runs {address, dwords}: touch = read or written by the ORIGINAL Stage 11 code,\n'
                                       '-- write = written by it.\nreturn ' + lua_value(head) + '\n')
    # every run (reference with snapshots + twins) is an independent Unicorn process; longest scenarios first
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


def restarts_only(out_dir, names, workers=4):
    """re-run only the reference runs and replace the restart records of existing fixtures (the reference rows,
    snapshots and twins of the fixture must be reproduced exactly: asserted)"""
    out = Path(out_dir); js = HERE / 'fixtures_json'
    t0 = time.time()
    with Pool(workers) as pool:
        for name, p, r, dt in pool.imap_unordered(_task, [(n, 0) for n in sorted(names, key=lambda n: -SC.SCENARIOS[n][1])]):
            doc = json.loads((js / ('%s.json' % name)).read_text())
            # (compared in their JSON form: event arguments are tuples in the run, lists in the stored fixture)
            assert json.loads(json.dumps([r['rows'], r['sync'], r['start']])) == [doc['rows'], doc['sync'], doc['start']], name
            doc['restart'] = r['restart']
            doc['law']['horizon'] = HORIZON.get(name)
            (js / ('%s.json' % name)).write_text(json.dumps(doc))
            (out / ('scenario_%s.lua' % name)).write_text('-- GENERATED by recovery/stage11/gen_fixtures11.py from the ORIGINAL NR2003 code (Unicorn); do not edit.\n'
                                                           'return ' + lua_value(doc) + '\n')
            print('%-10s restarts %d (%d twins each) %.1f s' % (name, len(r['restart']), len(RESTART_TWINS), dt), flush=True)
    print('total %.1f s' % (time.time() - t0))


def write_scenario(out, js, name, got):
    ref = got[(name, 0)]
    pert = [got[(name, p)] for p in sorted(PERTURB)]
    law = law_table(name); law['horizon'] = HORIZON.get(name)
    doc = dict(name=name, law=law, rows=ref['rows'], pert=pert, pertKinds=[PERTURB[p][0] for p in sorted(PERTURB)],
               sync=ref['sync'], start=ref['start'], restart=ref['restart'])
    (js / ('%s.json' % name)).write_text(json.dumps(doc))
    (out / ('scenario_%s.lua' % name)).write_text('-- GENERATED by recovery/stage11/gen_fixtures11.py from the ORIGINAL NR2003 code (Unicorn); do not edit.\n'
                                                   'return ' + lua_value(doc) + '\n')
    print('%-10s rows %d twins %d sync %d restart %d' % (name, len(ref['rows']), len(pert), len(ref['sync']),
                                                          len(ref['restart'])), flush=True)


if __name__ == '__main__':
    args = sys.argv[1:]
    workers, only = 4, False
    while args[:1] in (['-j'], ['--restarts-only']):
        if args[0] == '-j': workers = int(args[1]); args = args[2:]
        else: only = True; args = args[1:]
    names = args[1:] or list(SC.SCENARIOS)
    out = args[0] if args else str(HERE.parent.parent / 'tests' / 'stage11' / 'fixtures')
    (restarts_only if only else main)(out, names, workers)
