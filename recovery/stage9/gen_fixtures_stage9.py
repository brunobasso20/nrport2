"""Stage 9 golden data produced by the ORIGINAL NR2003.exe code in Unicorn (orig_aero.py).

  constants : NR2003.exe bytes of every constant the Luau hand port embeds (NR2003CupAero.lua)
  units     : bit-level vectors
              - 005a3c00 session weather -> e0b840 wind x, e0b844 wind y, e0b84c density (+ temperatures)
              - 005a3ba0 density formula (T, P, RH) incl. 005a3be0
              - 00561a80 half wind (with / without the track-object projection)
              - 00561b70 aero force + moment (incl. 00410280, curves, 00410910 damage, 00410b50 stall)
              - 005b0230 wake lookup (incl. 00567818) and 005afd80 drafting on synthetic race rings
              - 00423de0 / 004241d0 garage conversions of grille tape / rear spoiler
  scenarios : complete original car (driver layer + 45-state core) with the session air and the per-frame
              005637e0 subset, plus a twin with +1 ulp on the chassis z at `perturb` (the original's own
              sensitivity envelope). Rows every 36 ticks + dense rows after events.
  sync      : original machine snapshots at events + original results 8 and 16 ticks later, and the
              ORIGINAL 00561b70 evaluated at the snapshot state (telemetry cross-check).
Usage: python gen_fixtures_stage9.py [tests/stage9/fixtures] [recovery/stage9/fixtures_json]
Env:   NR2003_MEM (Ghidra ExportMemoryPy output), UNICORN_PY."""
import sys, struct, json, math, random, base64, time, os
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE)); sys.path.insert(0, str(HERE.parent / 'stage8')); sys.path.insert(0, str(HERE.parent / 'stage6_7'))
from orig_aero import *                       # noqa
from orig_runtime import _w, f32down
from gen_runtime import canonical_state
import image_windows as IW
import gen_fixtures_stage8 as S8

HERE = Path(__file__).resolve().parent        # (the star imports above define their own HERE)
ROOT = HERE.parents[1]
OUT = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'tests/stage9/fixtures'
JSON_OUT = Path(sys.argv[2]) if len(sys.argv) > 2 else HERE / 'fixtures_json'
OUT.mkdir(parents=True, exist_ok=True); JSON_OUT.mkdir(parents=True, exist_ok=True)
HOST = 0xf7f100
HOST_RANGE = (HOST, 0x700)                    # Stage 6/7 host blocks + Stage 9 aero blocks (args, outputs, track object)
BLOCK, OUT6, TOBJ = HOST + 0x600, HOST + 0x640, HOST + 0x680
STUB = 0xf7fe00                               # unused BSS: call stubs ending with FSTP dword [STUB_OUT]
STUB_OUT = 0xf7fe80
WINS = IW.windows()
lua = S8.lua


def u32(x): return struct.unpack('<I', struct.pack('<f', x))[0]
def f32(x): return struct.unpack('<f', struct.pack('<f', x))[0]
def fromu(u): return struct.unpack('<f', struct.pack('<I', u & 0xffffffff))[0]
def ulp_up(x): return fromu(u32(x) + 1)


def host(o):
    S8.host(o)
    o.m.uc.mem_write(HOST + 0x200, b'\0' * 0x500)


STUBS = {}


def stub_call(m, target, nargs, store_f32=True):
    """call stub: push the nargs dword arguments again, call target, pop, FSTP dword [STUB_OUT].
    One address per target: Unicorn keeps translated blocks cached, so code rewritten in place at an
    address that already ran is NOT re-translated. Returns the stub address."""
    if target in STUBS: return STUBS[target]
    at = STUB - 0x40 * (len(STUBS) + 1)
    code = b''
    for _ in range(nargs):
        code += b'\xff\x74\x24' + bytes([4 * nargs])          # push dword [esp + 4*nargs]
    code += b'\xe8' + struct.pack('<i', target - (at + len(code) + 5))
    code += b'\x83\xc4' + bytes([4 * nargs])
    if store_f32: code += b'\xd9\x1d' + struct.pack('<I', STUB_OUT)
    code += b'\xc3'
    m.uc.mem_write(at, code)
    STUBS[target] = at
    return at


# ============================================================================== constants
def constants():
    import importlib.util
    spec_ = importlib.util.spec_from_file_location('nrmem', str(HERE / 'tools/nrmem.py'))
    nm = importlib.util.module_from_spec(spec_); spec_.loader.exec_module(nm)
    src = (ROOT / 'core/NR2003Cup/NR2003CupAero.lua').read_text()
    import re
    kb = {int(a, 16): int(v, 16) for a, v in re.findall(r'\[(0x[0-9a-f]+)\]\s*=\s*(0x[0-9a-f]+),', src)}
    rows = [[a, nm.u32(a)] for a in sorted(kb)]
    wake = [nm.u32(0x6f7234 + 4 * k) for k in range(64)]
    hdr = [nm.u32(0x6f7228), nm.u32(0x6f722c), nm.u32(0x6f7230)]
    q = [nm.u32(0x6ef7b0), nm.u32(0x6ef7b4)]
    print('constants: %d embedded, %d mismatching' % (len(kb), sum(1 for a, v in rows if kb[a] != v)))
    return dict(cells=rows, wake=wake, header=hdr, qword=q, e7d27c=nm.u32(0xe7d27c),
                humidity=0x3e99999a, pressure=0x41ef5c29)


# ============================================================================== units
def units():
    rnd = random.Random(9009)
    o = OriginalBrake(state=canonical_state()); m = o.m
    host(o)
    m.fpcw = GAME_FPCW
    U = {}
    # ---------------------------------------------------------------- 005a3c00 weather -> air
    w = []
    for tF in range(40, 111):
        for cond in range(4):
            for night in (0, 1):
                a = weather_init(m, temperature=tF, conditions=cond, night=night)
                w.append([tF, cond, night, 0, 0, u32(0.0)] + a['bits'] + [u32(a['tC']), u32(a['tAir']), u32(a['dir']), u32(a['speed'])])
    norths = [0.0, 0.7, -1.3, 3.0, 2 * math.pi - 0.01, 1.5707963]
    for mph in range(0, 31):
        for d in range(8):
            for north in norths[:3] if mph % 3 else norths:
                a = weather_init(m, temperature=70, wind_mph=mph, wind_dir=d, track_north=north)
                w.append([70, 0, 0, mph, d, u32(f32(north))] + a['bits'] + [u32(a['tC']), u32(a['tAir']), u32(a['dir']), u32(a['speed'])])
    U['weather'] = w
    print('weather vectors', len(w))
    # ---------------------------------------------------------------- 005a3ba0 density formula
    STUBS.clear()
    sd = stub_call(m, 0x5a3ba0, 3)
    dv = []
    for i in range(2500):
        t = rnd.choice([rnd.uniform(-10, 95), rnd.uniform(15, 60), 49.111111, 21.111111])
        p = rnd.choice([rnd.uniform(25, 32), 29.92, rnd.uniform(28.5, 31)]) * 3386.53
        rh = rnd.choice([0.0, 0.3, 1.0, rnd.random()])
        args = [u32(t), u32(p), u32(rh)]
        m.call(sd, *args)
        dv.append(args + [m.u32(STUB_OUT)])
    U['density'] = dv
    # ---------------------------------------------------------------- 00561a80 half wind
    hw = []
    cells = [m.u32(0x74e094), m.u32(0x74e098), m.u32(0x74e09c)]
    for i in range(600):
        wind = [rnd.choice([0.0, rnd.uniform(-15, 15)]) for _ in range(3)]
        proj = rnd.random() < 0.6
        nv = [0.0, 0.0, 1.0]
        if proj:
            th, ph = rnd.uniform(0, 0.6), rnd.uniform(-math.pi, math.pi)
            nv = [math.sin(th) * math.cos(ph), math.sin(th) * math.sin(ph), math.cos(th)]
        for k in range(3): m.wf(AIR + 4 * k, wind[k])
        for k in range(3): m.wf(TOBJ + 0x24 + 4 * k, nv[k])
        m.w32(CAR + TRACKOBJ, TOBJ if proj else 0)
        m.call(0x561a80)
        hw.append([m.u32(AIR + 4 * k) for k in range(3)] + [m.u32(TOBJ + 0x24 + 4 * k) for k in range(3)] + [1 if proj else 0]
                  + [m.u32(c) for c in cells])
    m.w32(CAR + TRACKOBJ, 0)
    for k in range(3): m.w32(AIR + 4 * k, 0)
    U['halfwind'] = hw
    U['halfwindCells'] = cells
    # ---------------------------------------------------------------- 00561b70 aero force
    zlf, zrf = m.u32(m.u32(0xc084c0) + 0x2d5), m.u32(m.u32(0xc08310) + 0x2d5)
    base = dict(zlf=m.f32(zlf), zrf=m.f32(zrf), hl=m.f32(0xc084c8), hr=m.f32(0xc084cc), pitch0=m.f32(0xc083c4),
                i20=m.f32(0xc055c0 + 4 * 0x20), i21=m.f32(0xc055c0 + 4 * 0x21))
    av = []
    for k in range(6): m.w32(BLOCK + 4 * k, OUT6 + 4 * k)
    for i in range(5000):
        kind = rnd.random()
        vx = rnd.choice([0.0, 0.05, rnd.uniform(-5, 5), rnd.uniform(5, 100), rnd.uniform(40, 95), rnd.uniform(60, 90)])
        if kind < 0.6: vy = vx * rnd.uniform(-0.3, 0.3)
        elif kind < 0.8: vy = abs(vx) * rnd.uniform(-3, 3) + rnd.uniform(-2, 2)        # large yaw / beyond 90 deg
        else: vy = rnd.uniform(-1, 1)
        vz = vx * rnd.choice([rnd.uniform(-0.1, 0.1), rnd.uniform(-0.4, 0.4), 0.0]) + rnd.uniform(-0.3, 0.3)
        wb = [rnd.choice([0.0, rnd.uniform(-1, 1), rnd.uniform(-0.05, 0.05)]) for _ in range(3)]
        rho = rnd.choice([1.08119202, 1.19630301, rnd.uniform(0.9, 1.3), 0.0])
        fac = [rnd.choice([1.0, 1.0, 0.0, rnd.uniform(0.5, 1.1)]) for _ in range(3)]
        p0 = rnd.choice([base['pitch0'], rnd.uniform(-0.02, 0.02)])
        dz = [rnd.choice([0.0, rnd.uniform(-0.06, 0.06), rnd.uniform(0.0, 0.08)]) for _ in range(2)]
        h = [rnd.choice([base['hl'], rnd.uniform(0.12, 0.24)]) for _ in range(2)]
        tape = rnd.choice([0.0, 0.5, 1.0, rnd.random(), 0.05])
        spoiler = rnd.choice([20.0, 0.0, 25.0, float(rnd.randint(0, 25))])
        i20 = rnd.choice([base['i20'], rnd.uniform(-0.12, 0.12)]); i21 = rnd.choice([base['i21'], rnd.uniform(-0.12, 0.12)])
        dmg = [0.0] * 11
        if rnd.random() < 0.15:
            dmg = [rnd.choice([0.0, 0.0, rnd.random(), 1.0]) for _ in range(11)]
        cnt = rnd.choice([rnd.randint(1, 16), 1, 1])
        e0 = rnd.choice([0.0, rnd.uniform(-0.01, 0.01)]); e4 = rnd.choice([0.0, 0.0, rnd.random(), 1.0])
        flag = 1 if rnd.random() < 0.9 else 0
        vals = dict(rho=rho, f=fac, p0=p0, zl=base['zlf'] + dz[0], zr=base['zrf'] + dz[1], hl=h[0], hr=h[1],
                    tape=tape, spoiler=spoiler, i20=i20, i21=i21)
        m.wf(AIR + 12, rho)
        for k, off in enumerate((F_DRAG, F_FRONT, F_REAR)): m.wf(CAR + off, fac[k])
        m.wf(0xc083c4, p0); m.wf(zlf, vals['zl']); m.wf(zrf, vals['zr']); m.wf(0xc084c8, h[0]); m.wf(0xc084cc, h[1])
        m.wf(0xc055c0 + 4 * 0x3b, tape); m.wf(0xc055c0 + 4 * 0x3d, spoiler)
        m.wf(0xc055c0 + 4 * 0x20, i20); m.wf(0xc055c0 + 4 * 0x21, i21)
        for k in range(11): m.wf(CAR + 0x14a3 + 4 * k, dmg[k])
        m.w32(0x74e090, cnt); m.wf(0x7636e0, e0); m.wf(0x7636e4, e4); m.w32(0x71f904, flag)
        for k, v in enumerate([vx, vy, vz] + wb): m.wf(BLOCK + 24 + 4 * k, v)
        inp = [m.u32(a) for a in (AIR + 12, CAR + F_DRAG, CAR + F_FRONT, CAR + F_REAR, 0xc083c4, zlf, zrf, 0xc084c8, 0xc084cc,
                                  0xc055c0 + 4 * 0x3b, 0xc055c0 + 4 * 0x3d, 0xc055c0 + 4 * 0x20, 0xc055c0 + 4 * 0x21,
                                  0x74e090, 0x7636e0, 0x7636e4, 0x71f904)]
        inp += [m.u32(BLOCK + 24 + 4 * k) for k in range(6)]
        inp += [m.u32(CAR + 0x14a3 + 4 * k) for k in range(11)]
        m.call(0x561b70, BLOCK)
        outp = [m.u32(OUT6 + 4 * k) for k in range(6)] + [m.u32(0x74e090), m.u32(0x7636e0), m.u32(0x7636e4)]
        av.append(inp + outp)
    # restore build values of the cells touched
    m.wf(zlf, base['zlf']); m.wf(zrf, base['zrf']); m.wf(0xc084c8, base['hl']); m.wf(0xc084cc, base['hr'])
    U['aero'] = av
    U['aeroCells'] = [zlf, zrf]
    print('aero vectors', len(av))
    # ---------------------------------------------------------------- 005b0230 wake
    sw = stub_call(m, 0x5b0230, 2)
    wk = []
    for i in range(3000):
        g = rnd.choice([rnd.uniform(-60, 280), rnd.uniform(-45, 190), -45.0 + 7.5 * rnd.randint(0, 31), rnd.uniform(185, 300), -0.0, 0.0])
        lat = rnd.choice([rnd.uniform(0, 7.5), 0.0, 3.5, 3.4999998, rnd.uniform(3, 4)])
        args = [u32(g), u32(lat)]
        m.call(sw, *args)
        wk.append(args + [m.u32(STUB_OUT), m.u32(0xe7d274), m.u32(0xe7d278), m.u32(0xe7d27c)])
    U['wake'] = wk
    # ---------------------------------------------------------------- 005afd80 drafting
    U['draft'] = draft_units(m, rnd)
    # ---------------------------------------------------------------- garage conversions (CW 0x027f)
    m.fpcw = 0x027f
    U['tape'] = [[p, m.call(0x423de0, p)] for p in range(0, 101)]
    U['spoiler'] = [[d, m.call(0x4241d0, d)] for d in range(40, 76)]
    m.fpcw = GAME_FPCW
    return U


FAKE_SPECS = []


def ring(m, cars, self_obj):
    """build the race-order ring CAR -> cars[0] -> ... -> cars[-1] -> CAR in emulator memory.
    each car: dict(lapDistance, lateral, vx, vy, vz, wakeStrength, wakeLength); returns slot addresses"""
    slots = [CAR]
    for c in cars:
        slot = m.alloc(0x15b8); obj = m.alloc(0x60); spec = m.alloc(0x200)
        m.wf(spec + 0xd0, c['wakeStrength']); m.wf(spec + 0xd4, c['wakeLength'])
        m.w32(slot + 0x58a, spec); m.w32(slot + TRACKOBJ, obj)
        m.wf(obj + 0xc, c['vx']); m.wf(obj + 0x10, c['vy']); m.wf(obj + 0x14, c['vz'])
        m.wf(obj + 0x3c, c['lapDistance']); m.wf(obj + 0x40, c['lateral'])
        slots.append(slot)
    n = len(slots)
    for i, s in enumerate(slots):
        m.w32(s + 4, slots[(i + 1) % n] + 4)
        m.w32(s + 8, slots[(i - 1) % n] + 4)
    m.w32(CAR + TRACKOBJ, self_obj)
    return slots


def draft_units(m, rnd):
    out = []
    heap0 = m.heap
    for i in range(3000):
        m.heap = heap0
        L = rnd.choice([800.0, 2500.0, 4023.36, rnd.uniform(500, 5000)])
        sd = rnd.uniform(0, L) if rnd.random() < 0.8 else rnd.choice([0.0, L - 1.0, 1.0])
        slat = rnd.choice([0.0, rnd.uniform(-8, 8), rnd.uniform(-2, 2)])
        n = rnd.choice([1, 1, 2, 3, 4, 6])
        cars = []
        for k in range(n):
            gap = rnd.choice([rnd.uniform(-80, 300), rnd.uniform(0, 40), rnd.uniform(-20, 0), rnd.uniform(-5, 15), 0.0])
            spd = rnd.choice([rnd.uniform(0, 95), rnd.uniform(60, 90), 0.0, 3.0])
            ang = rnd.uniform(-0.2, 0.2)
            cars.append(dict(lapDistance=f32((sd + gap) % L), lateral=f32(rnd.choice([slat, slat + rnd.uniform(-1, 1), rnd.uniform(-9, 9)])),
                             vx=f32(spd * math.cos(ang)), vy=f32(spd * math.sin(ang)), vz=f32(rnd.uniform(-0.2, 0.2)),
                             wakeStrength=f32(rnd.choice([1.0, 1.0, rnd.uniform(0.5, 1.5)])), wakeLength=f32(rnd.choice([1.0, 1.0, rnd.uniform(0.5, 1.5)]))))
        self_obj = TOBJ
        m.wf(self_obj + 0x3c, sd); m.wf(self_obj + 0x40, slat)
        m.wf(0xbad918, L)
        ring(m, cars, self_obj)
        pre = [rnd.choice([1.0, 1.0, rnd.uniform(0.5, 1.1)]) for _ in range(3)]  # 005637e0 writes 1.0; others probe clamps
        for k, off in enumerate((F_DRAG, F_FRONT, F_REAR)): m.wf(CAR + off, pre[k])
        m.call(0x5afd80, CAR)
        row = [u32(f32(L)), m.u32(self_obj + 0x3c), m.u32(self_obj + 0x40)] + [u32(f32(x)) for x in pre]
        row += [m.u32(CAR + off) for off in (F_DRAG, F_FRONT, F_REAR)]
        row.append([[u32(c[k]) for k in ('lapDistance', 'lateral', 'vx', 'vy', 'vz', 'wakeStrength', 'wakeLength')] for c in cars])
        out.append(row)
    m.heap = heap0
    m.w32(CAR + 4, 0); m.w32(CAR + 8, 0); m.w32(CAR + TRACKOBJ, 0)
    for off in (F_DRAG, F_FRONT, F_REAR): m.w32(CAR + off, 0)
    print('draft vectors', len(out))
    return out


# ============================================================================== scenarios
SHIFT_UP = S8.SHIFT_UP


def accel(f):
    return S8.accel(f)


def after(t0, fn_before, fn_after):
    def ctl(f):
        return fn_after(f) if f / 36.0 >= t0 else fn_before(f)
    return ctl


def brake_at(t0):
    def b(f):
        c = accel(f); c['throttle'] = 0.0; c['brakeControl'] = 1.0; c['brakeDigital'] = False
        return c
    return after(t0, accel, b)


def steer_at(t0, steer, throttle=1.0):
    def s(f):
        c = accel(f); c['steer'] = steer; c['throttle'] = throttle
        return c
    return after(t0, accel, s)


class Draft:
    """phantom car ahead on a straight track: lap distance = x, lateral = y (vehicle-world), same
    velocity as the player; the ORIGINAL 005afd80 runs every frame in 005637e0 order"""
    def __init__(self, gap, lateral=0.0, length=5000.0):
        self.gap, self.lateral, self.length = gap, lateral, length

    def install(self, o):
        m = o.m
        self.self_obj = TOBJ
        for k in range(3): m.wf(TOBJ + 0x24 + 4 * k, (0.0, 0.0, 1.0)[k])
        self.slots = ring(m, [dict(lapDistance=0.0, lateral=0.0, vx=0.0, vy=0.0, vz=0.0, wakeStrength=1.0, wakeLength=1.0)], TOBJ)
        self.obj = m.u32(self.slots[1] + TRACKOBJ)
        # the player's ring links (car+4/car+8) also gate the render copy 005543f0 inside the ORIGINAL
        # 005539c0, which then queries the (unloaded) track: they are set only around 005afd80
        self.links = (m.u32(CAR + 4), m.u32(CAR + 8))
        m.w32(CAR + 4, 0); m.w32(CAR + 8, 0)
        m.wf(0xbad918, self.length)

    def call(self, o):
        m = o.m
        m.w32(CAR + 4, self.links[0]); m.w32(CAR + 8, self.links[1])
        m.call(0x5afd80, CAR)
        m.w32(CAR + 4, 0); m.w32(CAR + 8, 0)

    def update(self, o):
        m = o.m
        x, y = m.f32(0xbf6d40), m.f32(0xbf6d48)
        m.wf(TOBJ + 0x3c, x % self.length); m.wf(TOBJ + 0x40, y)
        m.wf(self.obj + 0x3c, (x + self.gap) % self.length); m.wf(self.obj + 0x40, y + self.lateral)
        for k, a in enumerate((0xbf6d44, 0xbf6d4c, 0xbf6d54)): m.w32(self.obj + 0xc + 4 * k, m.u32(a))

    def env(self, o):
        m = o.m
        return dict(trackLength=self.length, lapDistance=m.f32(TOBJ + 0x3c), lateral=m.f32(TOBJ + 0x40),
                    car=[m.u32(self.obj + 0x3c), m.u32(self.obj + 0x40)] + [m.u32(self.obj + 0xc + 4 * k) for k in range(3)])


class AeroRun(OriginalAero):
    def __init__(self, *a, draft=None, setup=None, **k):
        super().__init__(*a, **k)
        self.draft = draft
        self.setup = setup
        # setup['at'] (s): the change is made at the start of the last frame before that snapshot
        # (an in-race adjustment, like the pit crew's tape change); otherwise at build
        self.setup_tick = int(round(setup['at'] * 288)) - 8 if setup and 'at' in setup else None
        if setup and self.setup_tick is None: self.apply_setup()
        if draft: draft.install(self)
        self.envs = {}

    def apply_setup(self):
        m = self.m
        m.fpcw = 0x027f            # garage conversions run outside the simulation task (00423de0 nearest)
        if 'grilleTape' in self.setup: m.w32(0xc055c0 + 4 * 0x3b, m.call(0x423de0, self.setup['grilleTape']))
        if 'spoiler' in self.setup: m.w32(0xc055c0 + 4 * 0x3d, m.call(0x4241d0, self.setup['spoiler']))
        m.fpcw = GAME_FPCW

    def frame(self, c):
        m = self.m
        if self.setup_tick is not None and self.tick == self.setup_tick:
            self.apply_setup()
        if self.draft:
            self.draft.update(self)
            for off in (F_DRAG, F_FRONT, F_REAR): m.w32(CAR + off, ONE)
            car_frame_aero(m, None, draft=lambda: self.draft.call(self))
            self.envs[self.tick] = self.draft.env(self)
        else:
            car_frame_aero(m)
        OriginalBrake.frame(self, c)


def aero_eval(o):
    """the ORIGINAL 00561b70 at the current exported state, exactly as NR2003CupAero.aeroState builds
    its inputs (side effects on 0074e090 / 007636e0 / 007636e4 restored)"""
    m = o.m
    s = o.state()
    rec = o.root
    rot = [m.f32(m.u32(rec + 0x339 + 4 * k)) for k in range(9)]
    wx, wy, wz = m.f32(AIR), m.f32(AIR + 4), m.f32(AIR + 8)
    tobj = m.u32(CAR + TRACKOBJ)
    if tobj:
        nx, ny, nz = m.f32(tobj + 0x24), m.f32(tobj + 0x28), m.f32(tobj + 0x2c)
        dn = wx * nx + wz * nz + wy * ny
        wx, wy, wz = wx - dn * nx, wy - dn * ny, wz - dn * nz
    rx, ry, rz = s[1] - wx * 0.5, s[3] - wy * 0.5, s[5] - wz * 0.5
    bx = rot[0] * rx + rot[3] * ry + rot[6] * rz
    by = rot[1] * rx + rot[4] * ry + rot[7] * rz
    bz = rot[2] * rx + rot[5] * ry + rot[8] * rz
    for k in range(6): m.w32(BLOCK + 4 * k, OUT6 + 4 * k)
    for k, v in enumerate((bx, by, bz, s[10], s[11], s[12])): m.wf(BLOCK + 24 + 4 * k, v)
    c0, e0, e4 = m.u32(0x74e090), m.u32(0x7636e0), m.u32(0x7636e4)
    m.call(0x561b70, BLOCK)
    m.w32(0x74e090, c0); m.w32(0x7636e0, e0); m.w32(0x7636e4, e4)
    return [m.u32(OUT6 + 4 * k) for k in range(6)]


WHEEL_FZ = (0x2e0,)


def observe(o, s):
    m = o.m
    row = list(s[0:13]) + [s[13], s[19], s[25], s[27], s[34]]
    for w in range(4):
        t = o.tire(w)
        row += [t['fx'], t['fy'], t['fz']]
    row += [m.i32(0x74c97c)] + [m.f32(CAR + off) for off in (F_DRAG, F_FRONT, F_REAR, AIRSPEED)] + [m.f32(0x7636e4)]
    return row


SCENARIOS = [
    # name, controls, ticks, weather, setup, draft, perturb time (s) = restart point of the Luau run
    # (first event), events (s): dense rows + synchronized snapshots
    ('launch', accel, 11520, {}, None, None, 5.0, [5.0, 10.0, 20.0, 35.0]),
    ('hsbrake', brake_at(20.0), 7488, {}, None, None, 20.0, [20.0, 20.25, 21.0, 23.0]),
    ('hscorner', steer_at(18.0, 0.01), 8640, {}, None, None, 18.0, [18.0, 18.5, 22.0, 28.0]),
    ('spin', steer_at(18.0, 0.12, 0.6), 6048, {}, None, None, 18.0, [18.0, 18.5, 19.0, 19.5, 20.0]),
    ('cold', accel, 7200, dict(temperature=40), None, None, 10.0, [10.0, 20.0]),
    ('hot', accel, 7200, dict(temperature=110), None, None, 10.0, [10.0, 20.0]),
    ('cloudy', accel, 7200, dict(conditions=2), None, None, 10.0, [10.0, 20.0]),
    ('headwind', accel, 7200, dict(wind_mph=30, wind_dir=0), None, None, 10.0, [10.0, 20.0]),
    ('tailwind', accel, 7200, dict(wind_mph=30, wind_dir=4), None, None, 10.0, [10.0, 20.0]),
    ('crosswind', accel, 7200, dict(wind_mph=30, wind_dir=2), None, None, 10.0, [10.0, 20.0]),
    ('spoiler45', accel, 7200, {}, dict(spoiler=45, at=10.0), None, 10.0, [10.0, 20.0]),
    ('spoiler70', accel, 7200, {}, dict(spoiler=70, at=10.0), None, 10.0, [10.0, 20.0]),
    ('tape100', accel, 7200, {}, dict(grilleTape=100, at=10.0), None, 10.0, [10.0, 20.0]),
    ('tape100build', accel, 7200, {}, dict(grilleTape=100), None, 10.0, [10.0, 20.0]),
    ('draft', accel, 8640, {}, None, (8.0, 0.0), 10.0, [10.0, 15.0, 25.0]),
    ('draftside', accel, 7200, {}, None, (6.0, 2.0), 10.0, [10.0, 20.0]),
    ('creep', S8.sc_nearzero, 2304, {}, None, None, 2.5, [2.5, 5.0]),
]


def make(weather, setup, draft):
    st = canonical_state()
    o = AeroRun(state=st, weather=weather, setup=setup, draft=Draft(*draft) if draft else None)
    host(o)
    if draft: o.draft.install(o)   # host() cleared the host blocks: re-install the track object
    return o


def capture(o):
    m = o.m
    win = IW.read_windows(m, WINS)
    d = IW.diff(WINS, win)
    d.append((HOST_RANGE[0], bytes(m.uc.mem_read(*HOST_RANGE))))
    out = []
    for a, data in d:
        data = bytearray(data)
        for cell in (0xc08194, CAR + 4, CAR + 8):         # emulator-only pointers (session object, fake race ring)
            if a <= cell < a + len(data):
                data[cell - a:cell - a + 4] = b'\0\0\0\0'
        out.append([a, base64.b64encode(bytes(data)).decode()])
    return out


def run(name, fn, N, weather, setup, draft, perturb_t, events, perturb, want_sync):
    o = make(weather, setup, draft)
    con = flat(0.0, 1)
    tp = int(round(perturb_t * 288))
    dense = set()
    for e in events:
        k0 = int(round(e * 288)); dense.update(range(k0 + 1, k0 + 17))
    rows, syncs, pending = [], [], []
    sync_at = {int(round(e * 288)) for e in events} if want_sync else set()
    envs = []
    for k in range(1, N + 1):
        s = o.step_driver(fn((k - 1) // 8), con)
        if k % 36 == 0 or k in dense:
            rows.append([k] + observe(o, s))
        for p in pending:
            if k == p['tick'] + 8 or k == p['tick'] + 16:
                p['after'].append([k] + list(s) + observe(o, s)[18:])
        if k in sync_at:
            assert k % 8 == 0
            pending.append(dict(tick=k, chunks=capture(o), after=[], aero=aero_eval(o)))
        if perturb and k == tp:
            S8.perturb_z(o)
    if draft:
        envs = [[t] + o.envs[t]['car'] + [u32(o.envs[t]['lapDistance']), u32(o.envs[t]['lateral'])] for t in sorted(o.envs)]
    for p in pending:
        assert len(p['after']) == 2
        syncs.append(p)
    return rows, syncs, envs, o.air0


def controls_table(fn, N):
    return S8.controls_table(fn, N)


def main():
    t0 = time.time()
    C = constants()
    (OUT / 'aero_constants.lua').write_text(
        '-- GENERATED by recovery/stage9/gen_fixtures_stage9.py from the NR2003.exe memory export.\n'
        '-- cells: {address, u32}; wake: 64 u32 rows of 006f7234; header 006f7228; qword 006ef7b0 lo, hi\n'
        'return ' + lua(C) + '\n')
    (JSON_OUT / 'aero_constants.json').write_text(json.dumps(C))
    U = units()
    print('units %.0fs' % (time.time() - t0))
    head = ('-- GENERATED by recovery/stage9/gen_fixtures_stage9.py from the ORIGINAL NR2003.exe (Unicorn).\n'
            '-- weather : {tempF, conditions, night, mph, dir, north(u32) | e0b840 e0b844 e0b848 e0b84c | +108 +10c +110 +114}\n'
            '-- density : {T, P, RH | rho} (u32, 005a3ba0 result stored by FSTP)\n'
            '-- halfwind: {wind x y z, normal x y z, projected | half-wind cells x y z}\n'
            '-- aero    : {rho, fDrag, fFront, fRear, c083c4, zLF, zRF, c084c8, c084cc, tape, spoiler, item20, item21, counter,\n'
            '--            e0, e4, flag71f904, vx, vy, vz, wx, wy, wz, damage[11] | Fx Fy Fz Mx My Mz, counter, e0, e4}\n'
            '-- wake    : {gap, lat | result, e7d274, e7d278, e7d27c}\n'
            '-- draft   : {trackLength, selfDist, selfLat, pre drag/front/rear | drag front rear, {car rows}}\n'
            '-- tape / spoiler: {display, internal u32}\n')
    (OUT / 'aero_units.lua').write_text(head + 'return ' + lua(U) + '\n')
    (JSON_OUT / 'aero_units.json').write_text(json.dumps(U))
    if os.environ.get('STAGE9_ONLY') == 'units':
        return
    if os.environ.get('STAGE9_ONLY') == 'smoke':
        U = None
    meta, allrows, allsync = [], {}, {}
    smoke = os.environ.get('STAGE9_ONLY') == 'smoke'   # quick harness check: short runs, nothing written
    # STAGE9_SCENARIOS=a,b: regenerate only those scenarios, keep the others from fixtures_json
    only = os.environ.get('STAGE9_SCENARIOS')
    names = set(only.split(',')) if only else None
    prev_meta, prev_rows, prev_sync = {}, {}, {}
    if names:
        old = json.loads((JSON_OUT / 'aero_scenarios.json').read_text())
        prev_meta = {mm['name']: mm for mm in old['meta']}; prev_rows = old['rows']
        prev_sync = json.loads((JSON_OUT / 'aero_sync.json').read_text())
    for name, fn, N, weather, setup, draft, tp, events in SCENARIOS:
        if names and name not in names:
            if name in prev_meta:
                meta.append(prev_meta[name]); allrows[name] = prev_rows[name]; allsync[name] = prev_sync[name]
            continue
        if smoke:
            N, tp, events = 1152, 2.0, [2.0]
            rows, syncs, envs, air0 = run(name, fn, N, weather, setup, draft, tp, events, True, True)
            last = rows[-1]
            print('smoke %-10s v %6.2f f %.3f/%.3f/%.3f air %s aero %s' % (name, math.sqrt(last[2] ** 2 + last[4] ** 2 + last[6] ** 2),
                  last[-5], last[-4], last[-3], [hex(x) for x in air0['bits']], [round(fromu(x), 1) for x in syncs[0]['aero']]))
            continue
        t = time.time()
        rows, syncs, envs, air0 = run(name, fn, N, weather, setup, draft, tp, events, False, True)
        prow, _, penvs, _ = run(name, fn, N, weather, setup, draft, tp, events, True, False)
        allrows[name] = dict(orig=rows, pert=prow)
        allsync[name] = syncs
        meta.append(dict(name=name, ticks=N, weather=weather, setup=setup or {}, draft=list(draft) if draft else [],
                         perturb=tp, events=events, controls=controls_table(fn, N), air=air0['bits'], envs=envs))
        last = rows[-1]
        v = math.sqrt(last[2] ** 2 + last[4] ** 2 + last[6] ** 2)
        print('%-10s %5d ticks  x %8.2f  v %6.2f  z %.4f  f %.3f/%.3f/%.3f  %.0fs' % (name, N, last[1], v, last[5], last[-5], last[-4], last[-3], time.time() - t))
    if smoke:
        return
    head2 = ('-- GENERATED by recovery/stage9/gen_fixtures_stage9.py from the ORIGINAL NR2003.exe (Unicorn).\n'
             '-- row: {tick, x,vx,y,vy,z,vz, qx,qy,qz,qw, wx,wy,wz, travelLF, travelRF, travelRaxle, rollRaxle, wEngine,\n'
             '--       per wheel LF,RF,LR,RR: fx fy fz, gearIndex, factor drag/front/rear, airspeed(car+0x5aa), stall(007636e4)}\n'
             '-- controls per frame: {throttle, brakeControl(-1 = none), brakeDigital, clutch, steer, shiftUp, shiftDown, driver}\n'
             '-- envs (draft scenarios, per frame start tick): {tick, other car lapDist lat vx vy vz (u32), self lapDist, lat (u32)}\n')
    (OUT / 'aero_scenarios.lua').write_text(head2 + 'return {\n' + ',\n'.join(
        '{name=%s,ticks=%d,weather=%s,setup=%s,draft=%s,perturb=%r,events=%s,air=%s,controls=%s,envs=%s,orig=%s,pert=%s}' % (
            lua(mm['name']), mm['ticks'], lua(mm['weather']), lua(mm['setup']), lua(mm['draft']), mm['perturb'], lua(mm['events']),
            lua(mm['air']), lua(mm['controls']), lua(mm['envs']), lua(allrows[mm['name']]['orig']), lua(allrows[mm['name']]['pert']))
        for mm in meta) + '\n}\n')
    head3 = ('-- GENERATED by recovery/stage9/gen_fixtures_stage9.py from the ORIGINAL NR2003.exe (Unicorn).\n'
             '-- Original machine snapshots after tick `tick` (frame boundary): changed 16-byte chunks of the Luau image\n'
             '-- windows + host blocks {address, base64}; aero = ORIGINAL 00561b70 at that state (Fx Fy Fz Mx My Mz u32);\n'
             '-- after = original results 8 and 16 ticks later: {tick, state[1..45], observe() from index 18 on}\n')
    parts = []
    for mm in meta:
        for p in allsync[mm['name']]:
            parts.append('{scenario=%s,tick=%d,aero=%s,chunks=%s,after=%s}' % (lua(mm['name']), p['tick'], lua(p['aero']), lua(p['chunks']), lua(p['after'])))
    (OUT / 'aero_sync.lua').write_text(head3 + 'return {\n' + ',\n'.join(parts) + '\n}\n')
    (JSON_OUT / 'aero_scenarios.json').write_text(json.dumps({'meta': meta, 'rows': allrows}))
    (JSON_OUT / 'aero_sync.json').write_text(json.dumps({mm['name']: allsync[mm['name']] for mm in meta}))
    print('done %.0fs' % (time.time() - t0))


if __name__ == '__main__':
    main()
