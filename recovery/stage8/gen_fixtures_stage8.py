"""Stage 8 golden data produced by the ORIGINAL NR2003.exe code in Unicorn (orig_brake.py).

  units   : bit-level vectors for the hand-ported brake input chain
            - 00553080 pedal processing (incl. 00552d00, 00554f50, 005f7570, 00550130)
            - 005f7570 attitude (005f6e40 + 005f74c0)
  scenarios: braking runs of the complete original vehicle (driver layer + 45-state core) and a
            twin that gets +1 ulp on the chassis z cell at the braking onset (the original's own
            sensitivity envelope of the braking phase). Rows every 36 ticks + dense rows around
            braking events. The Luau test restarts from the original snapshot at the onset.
  sync    : original machine snapshots (image windows + host contact blocks) at braking events
            and the original's results 8 and 16 ticks later -> one-frame synchronized tests.
Usage: python gen_fixtures_stage8.py [tests/stage8/fixtures] [recovery/stage8/fixtures_json]
Env:   NR2003_MEM (Ghidra ExportMemory output), UNICORN_PY."""
import sys, struct, json, math, random, base64, time
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE)); sys.path.insert(0, str(HERE.parent / 'stage6_7'))
from orig_brake import *                      # noqa
from gen_runtime import canonical_state
import image_windows as IW

ROOT = HERE.parents[1]
OUT = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'tests/stage8/fixtures'
JSON_OUT = Path(sys.argv[2]) if len(sys.argv) > 2 else HERE / 'fixtures_json'
OUT.mkdir(parents=True, exist_ok=True); JSON_OUT.mkdir(parents=True, exist_ok=True)
HOST = 0xf7f100
HOST_RANGE = (HOST, 0x240)                    # outF/outP/gv + persistent tire contact blocks
WINS = IW.windows()


def u32(x): return struct.unpack('<I', struct.pack('<f', x))[0]
def ulp_up(x): return struct.unpack('<f', struct.pack('<I', u32(x) + 1))[0]


def host(o):
    o.outF = [HOST + 0x00 + 16 * i for i in range(4)]; o.outP = [HOST + 0x40 + 16 * i for i in range(4)]
    o.gv = [HOST + 0x80 + 16 * i for i in range(4)]; o.blocks = [HOST + 0xc0 + 32 * i for i in range(4)]
    o.m.uc.mem_write(HOST, b'\0' * 0x200)


def lua(v):
    if isinstance(v, bool): return 'true' if v else 'false'
    if isinstance(v, int): return str(v)
    if isinstance(v, float):
        if v != v: return '0/0'
        if v in (math.inf, -math.inf): return '1/0' if v > 0 else '-1/0'
        return repr(v)
    if isinstance(v, str): return json.dumps(v)
    if isinstance(v, (list, tuple)): return '{' + ','.join(lua(x) for x in v) + '}'
    if isinstance(v, dict):
        return '{' + ','.join('%s=%s' % (k, lua(x)) for k, x in v.items()) + '}'
    raise TypeError(type(v))


# ============================================================================== unit vectors
def quat_from_euler(roll, pitch, yaw):
    cr, sr = math.cos(roll / 2), math.sin(roll / 2)
    cp, sp = math.cos(pitch / 2), math.sin(pitch / 2)
    cy, sy = math.cos(yaw / 2), math.sin(yaw / 2)
    return (sr * cp * cy - cr * sp * sy, cr * sp * cy + sr * cp * sy, cr * cp * sy - sr * sp * cy, cr * cp * cy + sr * sp * sy)


def units():
    rnd = random.Random(8008)
    o = OriginalBrake(state=canonical_state()); m = o.m
    QOUT = 0xf7f400                                              # host scratch (unused BSS)
    vec = []
    specials_speed = [0.0, 0.3, 0.79, 0.7999999, 0.8, 0.8000001, 5.0, 10.99, 11.0, 11.01, 30.0]
    for i in range(3000):
        spd = rnd.choice(specials_speed) if rnd.random() < 0.6 else rnd.uniform(0, 40)
        az, el = rnd.uniform(-math.pi, math.pi), rnd.uniform(-0.3, 0.3)
        vx, vy, vz = spd * math.cos(el) * math.cos(az), spd * math.cos(el) * math.sin(az), spd * math.sin(el)
        kind = rnd.random()
        if kind < 0.35: att = (rnd.uniform(-0.004, 0.004), rnd.uniform(-0.008, 0.008), rnd.uniform(-3, 3))   # flat
        elif kind < 0.7: att = (rnd.uniform(-0.2, 0.2), rnd.uniform(-0.3, 0.3), rnd.uniform(-3, 3))          # slopes
        elif kind < 0.8: att = (rnd.uniform(-0.2, 0.2), rnd.choice([-1, 1]) * rnd.uniform(1.55, 1.5707), rnd.uniform(-3, 3))  # gimbal
        elif kind < 0.85: att = (0.0, rnd.uniform(-0.02, 0.02), 0.0)                                      # roll exactly 0
        else: att = (rnd.uniform(-math.pi, math.pi), rnd.uniform(-1.5, 1.5), rnd.uniform(-math.pi, math.pi))
        q = quat_from_euler(*att)
        thr = rnd.choice([0.0, 0.1, 0.19999999, 0.2, 0.2000001, 0.5, 1.0, rnd.random()])
        gear = rnd.choice([0, 1, 1, 2, 3, 5])
        prev = rnd.choice([0.0, 0.2, 0.9, 0.98, 1.0, rnd.random(), rnd.random()])
        braw = rnd.choice([0.0, 1.0, 0.3, 0.6, 0.98, 0.979, rnd.random()])
        bdig = rnd.random() < 0.5
        traw = rnd.choice([0.0, 1.0, 0.49999997, 0.5, rnd.random()])
        tdig = rnd.random() < 0.5
        help_ = rnd.random() < 0.4
        sl = [rnd.choice([0.0, rnd.uniform(0, 3), rnd.uniform(0, 20), 1.5, 2.1, 12.5]) for _ in range(4)]
        kind_driver = 1 if rnd.random() < 0.03 else 0
        rate5 = 1.0 if rnd.random() < 0.8 else rnd.choice([0.05, 0.2, 0.999])
        rate6 = 1.0 if rnd.random() < 0.7 else rnd.choice([0.05, 0.2, 0.999])
        ax5, ax6 = rnd.random(), rnd.random()
        carflag = 0x20000000 if rnd.random() < 0.05 else 0
        # ----- write original cells
        for a, v in ((0xbf6d44, vx), (0xbf6d4c, vy), (0xbf6d54, vz), (0xbf6d58, q[0]), (0xbf6d5c, q[1]),
                     (0xbf6d60, q[2]), (0xbf6d64, q[3]), (0xbf6390, thr), (0xbf6eac, prev),
                     (0xbf3cd4, sl[0]), (0xbf470d, sl[1]), (0xbf5146, sl[2]), (0xbf5b7f, sl[3]),
                     (0x74c994, rate5), (0x74c998, rate6), (0xbf63a4, ax5), (0xbf63a8, ax6)):
            m.wf(a, v)
        m.w32(0x74c97c, gear); m.w32(0xc067e0, kind_driver); m.uc.mem_write(0xbf6f04, bytes([1 if help_ else 0]))
        m.w32(0xc0692a + 0x4c, carflag)
        control_cells(m, BRAKE_CTL, braw, bdig); control_cells(m, THROTTLE_CTL, traw, tdig)
        m.w32(INTCOUNT, (m.u32(INTCOUNT) + 1) & 0xffffffff)
        m.call(STUBADDR)
        row = [m.u32(a) for a in (0xbf6d44, 0xbf6d4c, 0xbf6d54, 0xbf6d58, 0xbf6d5c, 0xbf6d60, 0xbf6d64, 0xbf6390)]
        row += [u32(struct.unpack('<f', struct.pack('<f', prev))[0]), u32(struct.unpack('<f', struct.pack('<f', braw))[0]),
                1 if bdig else 0, u32(struct.unpack('<f', struct.pack('<f', traw))[0]), 1 if tdig else 0,
                1 if help_ else 0, gear, kind_driver, carflag]
        row += [u32(struct.unpack('<f', struct.pack('<f', x))[0]) for x in sl]
        row += [u32(struct.unpack('<f', struct.pack('<f', x))[0]) for x in (rate5, rate6, ax5, ax6)]
        # outputs: pedal bf6eac, speed cache bf6f44, axis states bf63a4 (throttle) / bf63a8 (brake)
        row += [m.u32(0xbf6eac), m.u32(0xbf6f44), m.u32(0xbf63a4), m.u32(0xbf63a8)]
        vec.append(row)
    # restore defaults touched above (not needed further: o discarded)
    # ----- 005f7570 attitude vectors
    att_rows = []
    for i in range(1500):
        kind = rnd.random()
        if kind < 0.3: att = (rnd.uniform(-0.05, 0.05), rnd.uniform(-0.05, 0.05), rnd.uniform(-3.2, 3.2))
        elif kind < 0.5: att = (rnd.uniform(-3, 3), rnd.choice([-1, 1]) * rnd.uniform(1.56, 1.5707963), rnd.uniform(-3, 3))
        else: att = (rnd.uniform(-math.pi, math.pi), rnd.uniform(-1.57, 1.57), rnd.uniform(-math.pi, math.pi))
        q = quat_from_euler(*att)
        if rnd.random() < 0.1: q = tuple(x * rnd.uniform(0.98, 1.02) for x in q)    # slightly non-unit
        for k in range(4): m.wf(QOUT + 16 + 4 * k, q[k])
        m.call(0x5f7570, QOUT, QOUT + 4, QOUT + 8, QOUT + 16)
        att_rows.append([m.u32(QOUT + 16 + 4 * k) for k in range(4)] + [m.u32(QOUT), m.u32(QOUT + 4), m.u32(QOUT + 8)])
    return vec, att_rows


# ============================================================================== scenarios
SHIFT_UP = [round(36 * s) for s in (0.5, 1.7, 3.0, 4.6)]


def accel(f):
    """common launch: hold in N, 1st at 0.5 s, keyboard throttle from 0.6 s, upshifts 1.7/3.0/4.6 s"""
    t = f / 36.0
    c = dict(throttle=0.0, clutch=0.0, steer=0.0, brakeControl=0.0, brakeDigital=True)
    if t >= 0.5: c['clutch'] = 1.0
    if t >= 0.6: c['throttle'] = 1.0
    if f in SHIFT_UP: c['shiftUp'] = True
    return c


def brake_after(t0, level, digital=False, until=None):
    def ctl(f):
        c = accel(f); t = f / 36.0
        if t >= t0 and (until is None or t < until):
            c['throttle'] = 0.0; c['brakeControl'] = level; c['brakeDigital'] = digital
        elif until is not None and t >= until:
            c['throttle'] = 0.0
        return c
    return ctl


def sc_keyboard(f):
    c = accel(f); t = f / 36.0
    if t >= 6.0:
        c['throttle'] = 0.0
        c['brakeControl'] = 1.0 if (6.0 <= t < 7.5 or 8.0 <= t < 11.5) else 0.0
        c['brakeDigital'] = True
    return c


def sc_turn(f):
    c = accel(f); t = f / 36.0
    if t >= 5.0: c['steer'] = 0.02
    if t >= 6.0: c['throttle'] = 0.0; c['brakeControl'] = 0.6; c['brakeDigital'] = False
    return c


def sc_nearzero(f):
    """low speed: creep in 1st, analog brake 0.6 to a standstill, then release the pedal (no throttle)"""
    t = f / 36.0
    c = dict(throttle=0.0, clutch=0.0, steer=0.0, brakeControl=0.0, brakeDigital=False)
    if t >= 0.5: c['clutch'] = 1.0
    if t >= 0.6: c['throttle'] = 0.3
    if f == SHIFT_UP[0]: c['shiftUp'] = True
    if t >= 2.5: c['throttle'] = 0.0; c['brakeControl'] = 0.6
    if t >= 5.0: c['brakeControl'] = 0.0
    return c


def sc_nodriver(f):
    c = accel(f)
    if f / 36.0 >= 6.0:
        c = dict(driver=False, throttle=0.0, clutch=0.0, steer=0.0)
    return c


SCENARIOS = [
    # name, control fn, ticks, brake bias %, event times (s) for dense rows / sync snapshots
    ('coast', brake_after(6.0, 0.0, digital=True), 2880, None, [6.0, 6.5]),
    ('light', brake_after(6.0, 0.3), 2880, None, [6.0, 6.5]),
    ('medium', brake_after(6.0, 0.6), 2880, None, [6.0, 6.5]),
    ('max', brake_after(6.0, 1.0), 2880, None, [6.0, 6.25, 7.0]),
    ('highspeed', brake_after(8.0, 1.0), 3456, None, [8.0, 8.25]),
    ('keyboard', sc_keyboard, 3456, None, [6.0, 7.5, 8.0, 11.5]),
    ('turn', sc_turn, 2880, None, [6.0, 6.5]),
    ('bias60', brake_after(6.0, 1.0), 2880, 60, [6.0, 6.5]),
    ('bias85', brake_after(6.0, 1.0), 2880, 85, [6.0, 6.5, 8.25, 8.5]),
    ('nearzero', sc_nearzero, 2304, None, [2.5, 5.0, 5.25, 5.5]),
    ('nodriver', sc_nodriver, 2592, None, [6.0, 6.25]),
]
RATE_IDX = [18, 24, 30, 32]                    # C indices of LF/RF/LR/RR spin rates (state layout)


def perturb_z(o):
    """+1 ulp on the chassis z through the ORIGINAL state import 005b4560 (same path as the Luau
    V.translate): export 005b2cb0 to a scratch block, bump z, import. Writing the translation cell
    directly has no effect (the integrator restores it from the saved state)."""
    m = o.m; S = HOST + 0x300
    m.call(0x5b2cb0, S, o.root)
    m.wf(S + 16, ulp_up(m.f32(S + 16)))
    m.w32(0xe847c8, S); m.w32(0xe84664, 0xe84474)
    m.call(0x5b4560, o.root)


def make(bias):
    st = canonical_state()
    o = build_with_bias(bias, state=st) if bias is not None else OriginalBrake(state=st)
    host(o)
    return o


def observe(o, s):
    m = o.m; b = o.brake_cells()
    row = list(s[0:6]) + list(s[6:10]) + [s[i] for i in RATE_IDX] + [s[34]]
    for w in range(4):
        t = o.tire(w)
        row += [t['torque'], t['fx'], t['fy'], t['fz'], t['vx'], t['vslip']]
    row += [b['pedal'], b['core'], m.i32(0x74c97c)]
    return row


def capture(o):
    m = o.m
    win = IW.read_windows(m, WINS)
    d = IW.diff(WINS, win)
    d.append((HOST_RANGE[0], bytes(m.uc.mem_read(*HOST_RANGE))))
    # host-only cells of the emulator harness: session pointer (Luau treats 005c2d20 as offline)
    out = []
    for a, data in d:
        data = bytearray(data)
        if a <= 0xc08194 < a + len(data):
            data[0xc08194 - a:0xc08194 - a + 4] = b'\0\0\0\0'
        out.append([a, base64.b64encode(bytes(data)).decode()])
    return out


def run(name, fn, N, bias, events, perturb, want_sync):
    """perturb: the twin is identical up to the braking onset (events[0]) and then gets +1 ulp on
    the primary chassis z cell -> the original's own sensitivity envelope of the braking phase"""
    o = make(bias)
    con = flat(0.0, 1)
    t0 = int(round(events[0] * 288))
    dense = set()
    for e in events:
        k0 = int(round(e * 288))
        dense.update(range(k0 + 1, k0 + 17))
    rows, syncs = [], []
    sync_at = {int(round(e * 288)) for e in events} if want_sync else set()
    pending = []
    for k in range(1, N + 1):
        s = o.step_driver(fn((k - 1) // 8), con)
        if k % 36 == 0 or k in dense:
            rows.append([k] + observe(o, s))
        for p in pending:
            if k == p['tick'] + 8 or k == p['tick'] + 16:
                p['after'].append([k] + list(s) + observe(o, s)[15:])
        if k in sync_at:
            assert k % 8 == 0
            pending.append(dict(tick=k, chunks=capture(o), after=[]))
        if perturb and k == t0:
            perturb_z(o)
    for p in pending:
        assert len(p['after']) == 2, (name, p['tick'])
        syncs.append(p)
    return rows, syncs


def controls_table(fn, N):
    out = []
    for f in range(N // 8):
        c = fn(f)
        out.append([c.get('throttle', 0.0), c.get('brakeControl', -1.0), 1 if c.get('brakeDigital', True) else 0,
                    c.get('clutch', 0.0), c.get('steer', 0.0), 1 if c.get('shiftUp') else 0,
                    1 if c.get('shiftDown') else 0, 0 if c.get('driver', True) is False else 1])
    return out


def main():
    t0 = time.time()
    vec, att = units()
    print('units', len(vec), 'attitude', len(att), '%.1fs' % (time.time() - t0))
    (OUT / 'brake_units.lua').write_text(
        '-- GENERATED by recovery/stage8/gen_fixtures_stage8.py from the ORIGINAL NR2003.exe (Unicorn).\n'
        '-- pedal rows (u32 bits unless noted): vx vy vz qx qy qz qw throttle(bf6390) prev(bf6eac) brakeRaw brakeDigital\n'
        '--   throttleRaw throttleDigital help gear driverKind carFlag s0 s1 s2 s3 rate5 rate6 axis5 axis6 |\n'
        '--   OUT: bf6eac bf6f44 bf63a4 bf63a8\n'
        '-- attitude rows: qx qy qz qw | out1 out2 out3 (005f7570)\n'
        'return {pedal=' + lua(vec) + ',\nattitude=' + lua(att) + '}\n')
    (JSON_OUT / 'brake_units.json').write_text(json.dumps({'pedal': vec, 'attitude': att}))
    import os
    if os.environ.get('STAGE8_ONLY') == 'units':     # regenerate only the unit vectors
        return
    meta, allrows, allsync = [], {}, {}
    for name, fn, N, bias, events in SCENARIOS:
        t = time.time()
        rows, syncs = run(name, fn, N, bias, events, False, True)
        prow, _ = run(name, fn, N, bias, events, True, False)
        allrows[name] = dict(orig=rows, pert=prow)
        allsync[name] = syncs
        meta.append(dict(name=name, ticks=N, bias=bias if bias is not None else 74, events=events,
                         controls=controls_table(fn, N)))
        last = rows[-1]
        print('%-10s %5d ticks  x %.2f  v %.2f  pedal %.3f  %.0fs' % (name, N, last[1], last[2], last[-3], time.time() - t))
    head = ('-- GENERATED by recovery/stage8/gen_fixtures_stage8.py from the ORIGINAL NR2003.exe (Unicorn).\n'
            '-- row: {tick, x,vx,y,vy,z,vz, qx,qy,qz,qw, wLF,wRF,wLR,wRR (spin rates), wEngine,\n'
            '--       per wheel LF,RF,LR,RR: torque(+0x268) fx fy fz vx vslip, pedal(bf6eac), core(e84480), gearIndex}\n'
            '-- controls per frame: {throttle, brakeControl(-1 = none), brakeDigital, clutch, steer, shiftUp, shiftDown, driver}\n')
    (OUT / 'brake_scenarios.lua').write_text(head + 'return {\n' + ',\n'.join(
        '{name=%s,ticks=%d,bias=%d,events=%s,controls=%s,orig=%s,pert=%s}' % (
            lua(mm['name']), mm['ticks'], mm['bias'], lua(mm['events']), lua(mm['controls']),
            lua(allrows[mm['name']]['orig']), lua(allrows[mm['name']]['pert'])) for mm in meta) + '\n}\n')
    head2 = ('-- GENERATED by recovery/stage8/gen_fixtures_stage8.py from the ORIGINAL NR2003.exe (Unicorn).\n'
             '-- Original machine snapshots after tick `tick` (frame boundary): changed 16-byte chunks of the Luau\n'
             '-- image windows + host contact blocks {address, base64}; `after` = original results 8 and 16 ticks\n'
             '-- later: {tick, state[1..45], per wheel LF,RF,LR,RR: torque fx fy fz vx vslip, pedal, core, gearIndex}\n')
    parts = []
    for mm in meta:
        for p in allsync[mm['name']]:
            parts.append('{scenario=%s,tick=%d,chunks=%s,after=%s}' % (lua(mm['name']), p['tick'], lua(p['chunks']), lua(p['after'])))
    (OUT / 'brake_sync.lua').write_text(head2 + 'return {\n' + ',\n'.join(parts) + '\n}\n')
    (JSON_OUT / 'brake_scenarios.json').write_text(json.dumps({'meta': meta, 'rows': allrows}))
    (JSON_OUT / 'brake_sync.json').write_text(json.dumps({mm['name']: allsync[mm['name']] for mm in meta}))
    print('done %.0fs' % (time.time() - t0))


if __name__ == '__main__':
    main()
