"""Stage 12 scenario fixtures from the ORIGINAL code executed in Unicorn (orig_stage12.OriginalStage12), for
tests/stage12/run.luau. Same method as Stage 11 (recovery/stage11/gen_fixtures11.py), applied to the steering chain:

  start   frame-start snapshots (level 2): at chosen frames (steering active, speed near the 8.94 / 17.88 m/s ratio
          transitions, first frames) the ORIGINAL frame start (005524f0 player branch + 00551e80 tail) is traced in
          Unicorn: 'before' = every dword it reads or writes (+ the host cells the Python harness reads / writes) taken
          right before, 'after' = the dwords it writes, right after. The Luau test loads 'before', runs its own frame
          start (V._frameStartOnly) and compares bit for bit; any Luau write outside the original's set is reported.
  restart full-state restarts (level 3): the original's complete memory window at the start of frame R, its contact
          blocks and clock, the dwords that change during frame R (frame start + 8 ticks + frame end) and the row after
          it, plus 12 one-frame twins (RESTART_TWINS as Stage 11). The steering -> solver -> tyres coupling.
  rows    observation rows every 9 frames (0.25 s, level 4): chassis, steering cells, prescribed hub states, front
          road-wheel orientation, tyre forces; 'pert' = the same rows of ten twin runs of the original (Stage 11 PERTURB:
          chassis z +-1 ulp at the start, eight 'noise' twins +-1 ulp on the chassis height every frame).
Usage: python gen_fixtures12.py [-j workers] <tests/stage12/fixtures dir> [scenario...]"""
import sys, json, base64, struct, time, math, array
from multiprocessing import Pool
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE.parent / 'stage11'))
import orig_stage12 as O
import scenarios12 as SC
import gen_fixtures11 as G11
from lift11 import BASE, TOP
from unicorn import UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE, UC_MEM_WRITE

NW = (TOP - BASE) // 4
SKIP = G11.SKIP                     # Luau virtual stacks
INTCOUNT = O.INTCOUNT
CAR = O11 = None
import orig_stage11 as O11
CAR = O11.CAR
AIR = O11.AIR if hasattr(O11, 'AIR') else None
# host cells of the frame start read / written by the Python harness (not seen by the Unicorn hooks) and by the
# identical host code of the Luau port (NR2003CupFrame / NR2003CupAero / NR2003CupSteering.hostDevices / Driver)
HOST_READ = [(0xbf6d40, 0x40), (0x7559bc, 4), (0xbf6f0c, 4), (0xbf63cc, 4), (0x74c974, 4), (0xbf6ea0, 4), (0xbf6eb9, 1)]
HOST_WRITE = [(0x7559bc, 4), (CAR + 0x59e, 0x14), (0xbf6eb0, 4), (0xbf6390, 4), (0xbf6eac, 4), (0xbf63cc, 4),
              (0xbf6e98, 4), (0xbf6e20, 4), (O.CTRL_RAW + 10 * 5, 4 * 10 + 4), (O.CTRL_TYPE + 29 * 5, 29 * 3 + 4)]
for a in O.NOT_DRIVEN: HOST_WRITE.append((a, 4))
if AIR is not None: HOST_READ.append((AIR, 12))
# never compared (harness / port clocks, speed-cache tag = clock value, stacks)
EXCLUDE = [(0x74c9ac, 4), (INTCOUNT, 4), (0x7559c4, 4), (SKIP[0], SKIP[1] - SKIP[0])]


def _cells(ranges):
    out = set()
    for a, n in ranges:
        for x in range(a & ~3, a + n, 4):
            if BASE <= x < TOP: out.add((x - BASE) >> 2)
    return out


EXCL = _cells(EXCLUDE)
HOST_R, HOST_W = _cells(HOST_READ), _cells(HOST_WRITE)


def runs(idx):
    return G11.runs(sorted(idx))


def window(m):
    return G11.window(m)


def pack(w, idx):
    return base64.b64encode(struct.pack('<%dI' % len(idx), *[w[i] for i in idx])).decode()


def wheel_angles(m, root):
    """front road-wheel yaw (atan2 of the spin axis in the chassis frame, CupChassisAdapter.wheels convention) and the
    spin-axis vertical component, from the ORIGINAL component records (rotation pointers +0x339)"""
    def rot(r):
        rec = root + r * 0x505
        return [m.f32(m.u32(rec + 0x339 + 4 * k)) for k in range(9)]
    cr = rot(0)
    out = []
    for r in (5, 8):
        w = rot(r)
        ax = cr[0] * w[1] + cr[3] * w[4] + cr[6] * w[7]
        ay = cr[1] * w[1] + cr[4] * w[4] + cr[7] * w[7]
        az = cr[2] * w[1] + cr[5] * w[4] + cr[8] * w[7]
        out += [math.atan2(ax, ay), az]
    return out


ROW_FIELDS = ['x', 'vx', 'y', 'vy', 'z', 'vz', 'qx', 'qy', 'qz', 'qw', 'p', 'q', 'r',
              'input', 'target', 'current', 'frameTarget', 'lf', 'rf', 'hubLF', 'hubRF', 'drawSteer', 'speedCache',
              'yawLF', 'tiltLF', 'yawRF', 'tiltRF', 'fyLF', 'fyRF', 'fyLR', 'fyRR', 'fzLF', 'fzRF', 'omegaEngine', 'gear']
INT_FIELDS = ['gear']


def observe(o):
    m = o.m
    s = o.state()
    row = [s[k] for k in range(13)]
    row += [m.f32(0xbf63c8), m.f32(0xbf63b8), m.f32(0xbf63c0), m.f32(0xbf6e80), m.f32(0xbf6360), m.f32(0xbf6364),
            s[15], s[21], m.f32(CAR + 0x1554), m.f32(0xbf6f44)]
    row += wheel_angles(m, o.root)
    T = O11.TIRE
    row += [m.f32(T[0] + 0x2dc), m.f32(T[1] + 0x2dc), m.f32(T[2] + 0x2dc), m.f32(T[3] + 0x2dc), m.f32(T[0] + 0x2e0), m.f32(T[1] + 0x2e0)]
    row += [s[34], m.i32(0x74c97c)]
    return row


def steering_active(law, k):
    for j in range(max(0, k - 24), k + 1):
        c = law(j)
        if c.get('steerAxis') not in (None, 0.0) or c.get('steerLeft', 0.0) or c.get('steerRight', 0.0) \
                or c.get('driver', True) is False:
            return True
    return False


MAX_STARTS = 150


class Tracer:
    def __init__(self, m):
        self.m = m; self.r = set(); self.w = set(); self.h = None
    def _mem(self, uc, access, addr, size, value, user):
        if BASE <= addr < TOP:
            for a in range(addr & ~3, addr + size, 4):
                k = (a - BASE) >> 2
                if k < NW: (self.w if access == UC_MEM_WRITE else self.r).add(k)
    def __enter__(self):
        self.r.clear(); self.w.clear()
        self.h = self.m.uc.hook_add(UC_HOOK_MEM_READ | UC_HOOK_MEM_WRITE, self._mem)
        return self
    def __exit__(self, *a):
        self.m.uc.hook_del(self.h)


def restart_frames(name):
    session, frames, law, events, opts = SC.SCENARIOS[name]
    return [r for r in range(90, frames - 1, 144)]


def run(name, perturb=0, sync=False):
    session, frames, law, events, opts = SC.SCENARIOS[name]
    noise, kick = None, None
    if perturb:
        p = G11.PERTURB[perturb]
        if p[0] == 'kick': kick = (p[1], p[2])         # initial state index +-1 ulp (Stage 11 twins 1 / 2)
        else: noise = p[1]
    o = SC.make(name, kick=kick)
    m = o.m
    out = {'rows': [], 'start': [], 'restart': []}
    restarts = set(restart_frames(name)) if sync else set()
    w0 = window(m) if (restarts or sync) else None
    flat4 = O.flat()
    tr = Tracer(m) if sync else None
    nstart = 0
    out['rows'].append([0] + observe(o))
    for k in range(frames):
        c = law(k)
        wr = window(m) if k in restarts else None
        if wr is not None:
            blocks = [m.u32(o.blocks[w] + 4 * j) for w in range(4) for j in range(5)]
            intcount = m.u32(INTCOUNT); tick_r = o.tick
        if noise is not None:
            noise = (noise * 1103515245 + 12345) & 0x7fffffff
            u = m.u32(G11.Z_CELL); m.w32(G11.Z_CELL, u + (1 if noise & 0x10000 else -1))
        # frame start (traced when snapshot) + 8 ticks + frame end
        v = m.f32(0xbf6f44)
        snap = sync and nstart < MAX_STARTS and (k < 3 or (steering_active(law, k) and k % 2 == 0) or
                                                abs(v - 8.94) < 0.6 or abs(v - 17.88) < 0.6)
        if snap:
            wb = window(m)
            with tr: o.frame(c)
            wa = window(m)
            R = (tr.r | tr.w | HOST_R | HOST_W) - EXCL
            W = (tr.w | HOST_W) - EXCL
            R = [i for i in R if SKIP[0] > BASE + 4 * i or BASE + 4 * i >= SKIP[1]]
            W = [i for i in W if SKIP[0] > BASE + 4 * i or BASE + 4 * i >= SKIP[1]]
            ctrl = law_row(c)
            out['start'].append(dict(frame=k, beforeRuns=runs(R), before=pack(wb, sorted(R)), afterRuns=runs(W),
                                     after=pack(wa, sorted(W)), controls=ctrl))
            nstart += 1
            o.drive_tick(flat4)
            for t in range(7): o.step_driver(c, flat4)      # the last one runs the frame end
        else:
            for t in range(8): o.step_driver(c, flat4)
        if wr is not None:
            row1 = [k + 1] + observe(o) + list(o.state())
            w1 = window(m)
            saved1 = (bytes(w1), [bytes(m.uc.mem_read(b, 20)) for b in o.blocks], m.u32(INTCOUNT), o.tick)
            bi = [i for i in range(NW) if wr[i] != w0[i] and G11._kept(i)]
            ai = [i for i in range(NW) if w1[i] != wr[i] and G11._kept(i)]
            twins = []
            for tw in G11.RESTART_TWINS:
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
                        seed = G11.state_noise(o, seed)
                        o.step_driver(c, flat4)
                trow = [k + 1] + observe(o) + list(o.state())
                wt = window(m)
                ti = [i for i in range(NW) if wt[i] != w1[i] and G11._kept(i)]
                twins.append(dict(runs=runs(ti), values=pack(wt, ti), row=trow))
            m.uc.mem_write(BASE, saved1[0])
            for b, val in zip(o.blocks, saved1[1]): m.uc.mem_write(b, val)
            m.w32(INTCOUNT, saved1[2]); o.tick = saved1[3]
            out['restart'].append(dict(frame=k, beforeRuns=runs(bi), before=pack(wr, bi), afterRuns=runs(ai),
                                       after=pack(w1, ai), blocks=blocks, intCount=intcount, row=row1, twins=twins))
        if (k + 1) % 9 == 0: out['rows'].append([k + 1] + observe(o))
    return out


def law_row(c):
    ax = c.get('steerAxis')
    return [c.get('throttle', 0.0), c.get('clutch', 1.0), c.get('brakeControl', 0.0), bool(c.get('shiftUp')),
            bool(c.get('shiftDown')), float(c.get('steerLeft', 0.0) or 0.0), float(c.get('steerRight', 0.0) or 0.0),
            c.get('steerDigital', True) is not False, ax is not None, float(ax or 0.0), c.get('driver', True) is not False]


def law_table(name):
    session, frames, law, events, opts = SC.SCENARIOS[name]
    return dict(session=session, frames=frames, options={k: v for k, v in opts.items() if k not in ('steer', 'ratio')},
                steer=opts.get('steer'), ratio=opts.get('ratio'), controls=[law_row(law(k)) for k in range(frames)])


lua_value = G11.lua_value


def _task(t):
    name, p = t
    t0 = time.time()
    r = run(name, perturb=p, sync=(p == 0))
    return name, p, (r if p == 0 else r['rows']), time.time() - t0


def write_scenario(out, js, name, got):
    ref = got[(name, 0)]
    pert = [got[(name, p)] for p in sorted(G11.PERTURB)]
    doc = dict(name=name, law=law_table(name), fields=ROW_FIELDS, rows=ref['rows'], pert=pert,
               pertKinds=[G11.PERTURB[p][0] for p in sorted(G11.PERTURB)], start=ref['start'], restart=ref['restart'])
    (js / ('%s.json' % name)).write_text(json.dumps(doc))
    (out / ('scenario_%s.lua' % name)).write_text('-- GENERATED by recovery/stage12/gen_fixtures12.py from the ORIGINAL NR2003 code (Unicorn); do not edit.\n'
                                                   'return ' + lua_value(doc) + '\n')
    print('%-10s rows %d twins %d start %d restart %d' % (name, len(ref['rows']), len(pert), len(ref['start']), len(ref['restart'])), flush=True)


def main(out_dir, names, workers=4):
    out = Path(out_dir); out.mkdir(parents=True, exist_ok=True)
    js = HERE / 'fixtures_json'; js.mkdir(exist_ok=True)
    tasks = [(n, p) for n in sorted(names, key=lambda n: -SC.SCENARIOS[n][1]) for p in [0] + sorted(G11.PERTURB)]
    got = {}
    t0 = time.time()
    with Pool(workers) as pool:
        for name, p, r, dt in pool.imap_unordered(_task, tasks):
            got[(name, p)] = r
            print('  %-10s run %2d  %.1f s' % (name, p, dt), flush=True)
            if all((name, q) in got for q in [0] + sorted(G11.PERTURB)):
                write_scenario(out, js, name, got)
    print('total %.1f s' % (time.time() - t0))


if __name__ == '__main__':
    args = sys.argv[1:]
    workers = 4
    if args[:1] == ['-j']: workers = int(args[1]); args = args[2:]
    names = args[1:] or list(SC.SCENARIOS)
    out = args[0] if args else str(HERE.parent.parent / 'tests' / 'stage12' / 'fixtures')
    main(out, names, workers)
