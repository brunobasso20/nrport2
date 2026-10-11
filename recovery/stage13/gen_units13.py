"""Stage 13 level-1 vectors: the ORIGINAL force-feedback functions executed one by one in Unicorn (orig_stage13 harness) on
the post-build car, for tests/stage13/run.luau (fixtures/units.lua):

  x87      exact x87 arithmetic of the port (NR2003CupFFB X87: add / sub / mul / div with a 64-bit significand rounded
           toward -inf, f32 stores rounded toward -inf): exact rational reference (Fraction), and the same operations run
           as x87 instructions (fld tbyte ; f<op>p ; fstp tbyte, CW 0x077f) in Unicorn for a cross-check of the reference
  stats    00554d30 (call): accumulators n / A / B / C / D (random, adversarial: tiny + huge, cancellations, signed zeros,
           sum <= 0, n <= 0) -> 74c960, bf6ec4, bf6ec8, bf6ed0 (bits) and the cleared cells
  block    FFB block of 00554520 (0055464c..00554778 run in place): gates bf6ebb / bf6eb8, ec4 / ec0 / ecc / ed0, airspeed,
           latency, damping, strength, setup item 0x30 -> bf6ec0, bf6ecc (bits), the 005d08d0 call (axis, force bits)
  controls 00550070(flag) -> 0054fed0 / 00550030 and 00550680: control-7 binding (type, axis, direction byte), bf6ebb /
           bf6ebc / bf6f1c before, host device (capable, acquire, effect) -> bf6eb8, bf6ebb, bf6ebc, 74c95c, HEFF and the
           sequence of device calls (acquire / release / force)
  setters  00550270 / 00550290 / 005502d0 / 005502b0 with the controls.cfg conversion of 0043f1d0
Usage: python gen_units13.py [tests/stage13/fixtures]"""
import sys, struct, math, json, random, time
from fractions import Fraction as Fr
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import orig_stage13 as O                                     # noqa: E402
sys.path.insert(0, str(HERE.parent / 'stage11'))
import gen_fixtures11 as G11                                 # noqa: E402

TWO = Fr(2)


def f32b(x): return struct.unpack('<I', struct.pack('<f', x))[0]
def bf(u): return struct.unpack('<f', struct.pack('<I', u & 0xffffffff))[0]
def d2u(x): return struct.unpack('<Q', struct.pack('<d', x))[0]
def u2d(u): return struct.unpack('<d', struct.pack('<Q', u))[0]


# ------------------------------------------------------------------------------------- exact x87 reference (Fraction)
def ilog2(a):
    e = a.numerator.bit_length() - a.denominator.bit_length()
    while TWO ** e > a: e -= 1
    while TWO ** (e + 1) <= a: e += 1
    return e


def rd(v, bits):
    """round toward -inf to a 'bits'-bit significand (unbounded exponent)"""
    if v == 0: return v
    e = ilog2(abs(v))
    u = TWO ** (e - bits + 1)
    q = v / u
    return Fr(math.floor(q)) * u


def rd32(v):
    """FST dword under RC = down: binary32 with subnormals, overflow -> FLT_MAX / -inf; returns bits"""
    if isinstance(v, float):
        if v != v: return 0x7fc00000
        if v == 0: return 0x80000000 if math.copysign(1, v) < 0 else 0
        v = Fr(v)
    if v == 0: return 0
    e = max(ilog2(abs(v)), -126)
    u = TWO ** (e - 23)
    r = Fr(math.floor(v / u)) * u
    FMAX = (2 - TWO ** -23) * TWO ** 127
    if r > FMAX: return 0x7f7fffff
    if r < -FMAX: return 0xff800000
    if r == 0: return 0 if v > 0 else 0x80000000
    return f32b(float(r))


class X:
    """an x87 value: exact Fraction + sign of zero"""
    __slots__ = ('v', 'neg')
    def __init__(self, v, neg=False):
        if isinstance(v, float):
            neg = math.copysign(1, v) < 0 if v == 0 else v < 0
            v = Fr(v)
        self.v = v; self.neg = neg if v == 0 else v < 0
    def pair(self):
        """canonical (h, l): h = value truncated toward zero to 53 bits, l = rest -> four u32 (h hi/lo, l hi/lo)"""
        if self.v == 0:
            h = -0.0 if self.neg else 0.0; l = 0.0
        else:
            a = abs(self.v); e = ilog2(a); u = TWO ** (e - 52)
            hm = Fr(math.floor(a / u)) * u
            s = -1 if self.v < 0 else 1
            h = float(s * hm); l = float(s * (a - hm))
            assert Fr(h) + Fr(l) == self.v
        return [d2u(h) >> 32, d2u(h) & 0xffffffff, d2u(l) >> 32, d2u(l) & 0xffffffff]


def x_add(a, b):
    s = a.v + b.v
    if s == 0:
        return X(Fr(0), not (a.v == 0 and b.v == 0 and not a.neg and not b.neg))
    return X(rd(s, 64))


def x_mul(a, b):
    p = a.v * b.v
    if p == 0: return X(Fr(0), a.neg != b.neg)
    return X(rd(p, 64))


def x_div(a, b):
    q = a.v / b.v
    if q == 0: return X(Fr(0), a.neg != b.neg)
    return X(rd(q, 64))


def x_f32(a):
    if a.v == 0: return 0x80000000 if a.neg else 0
    return rd32(a.v)


# x87 instruction check in Unicorn: fld tbyte [A] ; fld tbyte [B] ; f<op>p st(1), st(0) ; fstp tbyte [R] ; ret
XA, XB, XR, XCODE = 0xf7a940, 0xf7a950, 0xf7a960, 0xf7a980
OPS = {'add': b'\xde\xc1', 'mul': b'\xde\xc9', 'div': b'\xde\xf9'}


def to80(x):
    if x.v == 0: return struct.pack('<QH', 0, 0x8000 if x.neg else 0)
    a = abs(x.v); e = ilog2(a)
    m = a / TWO ** (e - 63)
    assert m.denominator == 1 and (1 << 63) <= m < (1 << 64), 'not a 64-bit value'
    return struct.pack('<QH', int(m), ((0x8000 if x.v < 0 else 0) | (e + 16383)))


def from80(b):
    m, se = struct.unpack('<QH', b)
    s, e = se >> 15, se & 0x7fff
    if m == 0: return X(Fr(0), bool(s))
    v = Fr(m) * TWO ** (e - 16383 - 63)
    return X(-v if s else v)


def install_x87(m):
    for k, (name, op) in enumerate(OPS.items()):
        code = b'\xdb\x2d' + struct.pack('<I', XA) + b'\xdb\x2d' + struct.pack('<I', XB) + op + b'\xdb\x3d' + struct.pack('<I', XR) + b'\xc3'
        m.uc.mem_write(XCODE + 0x20 * k, code)


def unicorn_op(m, name, a, b):
    k = list(OPS).index(name)
    m.uc.mem_write(XA, to80(a)); m.uc.mem_write(XB, to80(b))
    m.call(XCODE + 0x20 * k)
    return from80(bytes(m.uc.mem_read(XR, 10)))


def rand64(rng, e_lo=-40, e_hi=40):
    m = rng.getrandbits(64) | (1 << 63)
    if rng.random() < 0.15: m |= (1 << 64) - (1 << rng.randrange(1, 40))       # long runs of ones (carries)
    if rng.random() < 0.15: m &= ~((1 << rng.randrange(1, 60)) - 1) | (1 << 63)  # short significands
    v = Fr(m) * TWO ** (rng.randint(e_lo, e_hi) - 63)
    return X(-v if rng.random() < 0.5 else v)


def randf32(rng, e_lo=-30, e_hi=30):
    v = Fr(rng.getrandbits(24) | (1 << 23)) * TWO ** (rng.randint(e_lo, e_hi) - 23)
    return X(-v if rng.random() < 0.5 else v)


def x87_vectors(m):
    rng = random.Random(1301)
    install_x87(m)
    out = {'add': [], 'mul': [], 'div': [], 'f32': []}
    gens = []
    for i in range(1500):
        kind = i % 6
        if kind == 0: a, b = rand64(rng), rand64(rng)
        elif kind == 1: a, b = randf32(rng), randf32(rng)
        elif kind == 2: a, b = rand64(rng), randf32(rng)
        elif kind == 3:                                            # tiny addend (exponent gap 20 .. 120)
            a = rand64(rng); b = rand64(rng, -160, -60)
        elif kind == 4:                                            # near cancellation
            a = rand64(rng); d = rand64(rng, -70, -30); b = X(-(a.v + d.v)) if rng.random() < 0.5 else X(-a.v)
            if b.v != 0 and to80_ok(b) is False: b = X(-a.v)
        else:                                                      # f32 vs tiny f32 / ints
            a = randf32(rng); b = randf32(rng, -60, -40)
        gens.append((a, b))
    specials = [(X(0.0), X(0.0)), (X(0.0), X(-0.0)), (X(-0.0), X(-0.0)), (X(1.0), X(-1.0)), (X(-0.0), X(2.5)),
                (X(Fr(1)), X(Fr(-1, 2**80))), (X(Fr(-1)), X(Fr(-1, 2**80))), (X(Fr(1)), X(Fr(1, 2**80))),
                (X(Fr(2**64 - 1, 2**63)), X(Fr(1, 2**63))), (X(Fr(-(2**64 - 1), 2**63)), X(Fr(-1, 2**70))),
                (X(Fr(20)), X(Fr(36))), (X(Fr(1)), X(Fr(3))), (X(Fr(1500)), X(Fr(-1, 2**60))),
                # zero x / by a value that is not a double (64-bit significand): sign of the exact zero
                (X(-0.0), X(rd(Fr(1, 3), 64))), (X(0.0), X(-rd(Fr(1, 3), 64))), (X(-0.0), X(-rd(Fr(2, 7), 64))),
                (X(0.0), X(rd(Fr(5, 3), 64))), (X(rd(Fr(1, 3), 64)), X(-0.0))]
    gens = specials + gens
    for a, b in gens:
        if not (to80_ok(a) and to80_ok(b)): continue
        for name, f in (('add', x_add), ('mul', x_mul), ('div', x_div)):
            if name == 'div' and b.v == 0: continue
            r = f(a, b)
            if name != 'add' or True:
                if not (a.v == 0 and b.v == 0 and name == 'div'):
                    u = unicorn_op(m, name, a, b)
                    assert u.v == r.v and (u.v != 0 or u.neg == r.neg), (name, a.v, b.v, u.v, r.v, u.neg, r.neg)
            out[name].append(a.pair() + b.pair() + r.pair())
        r = x_add(a, b)
        out['f32'].append(r.pair() + [x_f32(r)])
    # sub = add of the negation (FSUB under RC = down is exact-rounded a - b)
    return out


def to80_ok(x):
    if x.v == 0: return True
    a = abs(x.v); e = ilog2(a)
    q = a / TWO ** (e - 63)
    return q.denominator == 1 and -16000 < e < 16000


# ------------------------------------------------------------------------------------------------------- 00554d30
N_LF, N_RF = 0x74c964, 0x74c968
ACC = [0xbf6ed4, 0xbf6ed8, 0xbf6edc, 0xbf6ee0, 0xbf6ee4, 0xbf6ee8, 0xbf6eec, 0xbf6ef0]   # A_LF A_RF B_LF B_RF C_LF C_RF D_LF D_RF
OUTS = [0x74c960, 0xbf6ec4, 0xbf6ec8, 0xbf6ed0]


def rnd_f(rng, scale, tiny=False):
    if tiny: return bf(f32b(rng.uniform(-1, 1) * scale * 2.0 ** rng.randint(-60, -20)))
    return bf(f32b(rng.uniform(-1, 1) * scale))


def stats_vectors(m):
    rng = random.Random(1302)
    vecs = []
    def one(nl, nr, acc):
        m.w32(N_LF, nl); m.w32(N_RF, nr)
        for a, u in zip(ACC, acc): m.w32(a, u)
        m.call(0x554d30)
        outs = [m.u32(a) for a in OUTS]
        cleared = all(m.u32(a) == 0 for a in ACC + [N_LF, N_RF])
        vecs.append([nl & 0xffffffff, nr & 0xffffffff] + list(acc) + outs + [1 if cleared else 0])
    for i in range(2600):
        k = i % 13
        nl = rng.choice([2, 2, 2, 1, 3, 4, 5, 7, 0, -1, 1000]); nr = rng.choice([2, 2, 2, 1, 3, 4, 6, 0, -2])
        bl = abs(rnd_f(rng, 20000)); br = abs(rnd_f(rng, 20000))
        A = [rnd_f(rng, 0.3), rnd_f(rng, 0.3)]
        C = [rnd_f(rng, 30000), rnd_f(rng, 30000)]
        D = [rnd_f(rng, 3000), rnd_f(rng, 3000)]
        if k == 1: bl = rnd_f(rng, 1, tiny=True); bl = abs(bl)                     # unloaded LF
        if k == 2: C[0] = rnd_f(rng, 30000, tiny=True)                            # tiny vs large
        if k == 3: D[1] = -D[0]                                                   # exact cancellation (nr == nl)
        if k == 4: bl, br = 0.0, 0.0                                              # sum 0 -> l = a = 0
        if k == 5: bl, br = -abs(bl), abs(bl) * 0.5                               # negative sum
        if k == 6: A = [rnd_f(rng, 0.3, tiny=True), rnd_f(rng, 0.3)]
        if k == 7: C = [-0.0, 0.0]; D = [0.0, -0.0]; A = [-0.0, -0.0]             # signed zeros
        if k == 8: bl = bf(f32b(br * 3.0))                                        # l near 3/4
        if k == 9: nl, nr = 2, 2; D = [rnd_f(rng, 3000), rnd_f(rng, 3000, tiny=True)]
        if k == 10: bl, br = 0.01 * 2, 0.01 * 2                                   # unloaded both (|Fz| = 0)
        if k == 11: bl, br = 1e30, 1e30                                           # 74c960 clamp (> 1500)
        if k == 12: nl, nr = 2, 2; bl = bf(f32b(1500.0)); br = bf(f32b(1500.0))   # exactly 1500
        acc = [f32b(A[0]), f32b(A[1]), f32b(bl), f32b(br), f32b(C[0]), f32b(C[1]), f32b(D[0]), f32b(D[1])]
        one(nl, nr, acc)
    return vecs


# ------------------------------------------------------------------------------------------------------- FFB block
SLIP, PREV, FILT, MOMENT = 0xbf6ec4, 0xbf6ec0, 0xbf6ecc, 0xbf6ed0
AIRSPEED, RATIO = 0xbf3a00, 0xc055c0 + 4 * 0x30


def block_vectors(m):
    rng = random.Random(1303)
    vecs = []
    for i in range(3000):
        k = i % 12
        ebb = 0 if k == 0 else 1
        eb8 = 1 if k == 1 else 0
        ec4 = rnd_f(rng, 0.2); ec0 = bf(f32b(ec4 + rng.uniform(-1, 1) * 0.01)) if rng.random() < 0.8 else rnd_f(rng, 0.2)
        ecc = rnd_f(rng, 400); ed0 = rnd_f(rng, 3000)
        v = abs(rnd_f(rng, 90))
        lat = float(rng.randint(0, 250)); damp = float(rng.randint(0, 100)); st = float(rng.randint(0, 100))
        ratio = rng.choice([6.5, 7.0, 12.0, 18.0, 24.0, 32.0, bf(f32b(rng.uniform(6, 34)))])
        if k == 2: ec4 = rnd_f(rng, 1e-5)                                          # |ec4| <= 1e-5 branch
        if k == 3: ec4 = bf(f32b(1e-5)) * (1 if rng.random() < 0.5 else -1)       # the boundary itself
        if k == 4: ec4, ec0, ecc, ed0, v = 0.0, 0.0, 0.0, 0.0, 0.0                # rest: signed zeros
        if k == 5: ed0 = rnd_f(rng, 3e5); st = 100.0                              # saturation +-1
        if k == 6: lat = rng.choice([0.0, 250.0]); v = rng.choice([0.0, 1e-3, 90.0])
        if k == 7: ec0 = ec4                                                      # d = 0 exactly
        if k == 8: damp = bf(f32b(rng.uniform(0, 100))); lat = bf(f32b(rng.uniform(0, 250)))  # raw option values
        if k == 9: ecc = rnd_f(rng, 400, tiny=True); ed0 = rnd_f(rng, 3000, tiny=True)
        if k == 10: v = -0.0 if rng.random() < 0.5 else 0.0
        O.w8(m, 0xbf6ebb, ebb); O.w8(m, 0xbf6eb8, eb8)
        m.w32(0xbf6ebc, 5)
        vals = [ec4, ec0, ecc, ed0, v, lat, damp, st, ratio]
        addrs = [SLIP, PREV, FILT, MOMENT, AIRSPEED, O.LATENCY, O.DAMPING, O.STRENGTH, RATIO]
        bits = [f32b(x) for x in vals]
        for a, u in zip(addrs, bits): m.w32(a, u)
        m.ffb_log.clear()
        O.run_ffb_block(m)
        calls = [c for c in m.ffb_log if c[0] == 'force']
        force = calls[0][2] if calls else None
        vecs.append([ebb, eb8] + bits + [m.u32(PREV), m.u32(FILT), len(calls), force if force is not None else 0])
    O.w8(m, 0xbf6ebb, 0); O.w8(m, 0xbf6eb8, 0)
    return vecs


# ------------------------------------------------------------------------------------------------------- controls
def controls_vectors(m):
    vecs = []
    REC7 = O.REC7
    for flag in (0, 1, 2):
        for kind in (0, 1, 3):     # 2 / 4 (key / button): 0057aff0 formats key names (front-end strings, not set up)
            for axis in (0, 3, 15, 16, 0x80000002):
                for direc in (0, 1):
                    for ebb in (0, 1):
                        for same in (0, 1):
                            for ffon in (0, 1):
                                for cap in (0, 1):
                                    for acq in (0, 1):
                                        for eff in (0, 1):
                                            if kind != 1 and (axis != 3 or direc or same): continue
                                            if flag == 2 and (axis not in (0, 3)): continue
                                            prev_axis = axis if same else 7
                                            m.w32(REC7 + 0x10, kind); m.w32(REC7 + 0x14, axis); O.w8(m, REC7 + 0x1c, direc)
                                            O.w8(m, O.ACQUIRED, ebb); m.w32(O.AXIS, prev_axis); m.w32(O.DIRSIGN, 0x55)
                                            O.w8(m, O.FF_ON, ffon); O.w8(m, O.SUSPENDED, 0x33)
                                            O.w8(m, O.HCAP, cap); O.w8(m, O.HACQ, acq); O.w8(m, O.HEFF, eff)
                                            m.ffb_log.clear()
                                            m.call(0x550070, flag)
                                            log = [[{'force': 0, 'acquire': 1, 'release': 2}[c[0]], c[1], c[2] if len(c) > 2 else 0] for c in m.ffb_log]
                                            vecs.append(dict(i=[flag, kind, axis, direc, ebb, prev_axis, ffon, cap, acq, eff],
                                                             o=[O.u8(m, O.SUSPENDED), O.u8(m, O.ACQUIRED), m.u32(O.AXIS), m.u32(O.DIRSIGN), O.u8(m, O.HEFF)],
                                                             log=log))
    # 00550680 (session end)
    rel = []
    for ebb in (0, 1):
        for cap in (0, 1):
            for eff in (0, 1):
                O.w8(m, O.ACQUIRED, ebb); m.w32(O.AXIS, 9); O.w8(m, O.HCAP, cap); O.w8(m, O.HEFF, eff)
                m.ffb_log.clear()
                m.call(0x550680)
                log = [[{'force': 0, 'acquire': 1, 'release': 2}[c[0]], c[1], c[2] if len(c) > 2 else 0] for c in m.ffb_log]
                rel.append(dict(i=[ebb, cap, eff], o=[O.u8(m, O.ACQUIRED), O.u8(m, O.HEFF)], log=log))
    return vecs, rel


def setter_vectors(m):
    out = []
    for name, fn, cell, hi in (('strength', 0x550290, O.STRENGTH, 100), ('damping', 0x5502d0, O.DAMPING, 100),
                               ('latency', 0x5502b0, O.LATENCY, 250)):
        for v in list(range(0, hi + 1)) + [-5, hi + 7, 33.7]:
            m.call(fn, O.cfg_float(v, hi))
            out.append([name, v, m.u32(cell)])
    for v in (0, 1):
        m.call(0x550270, v); out.append(['enabled', v, O.u8(m, O.FF_ON)])
    return out


def main(out_dir):
    t0 = time.time()
    st = [0.0] * 45; st[4] = 0.42; st[9] = 1.0
    o = O.OriginalStage13(state=st, weather=dict(temperature=70, wind_mph=0, wind_dir=0, conditions=0, night=0), damage_level=0)
    m = o.m
    image = dict(strength=m.u32(O.STRENGTH), damping=m.u32(O.DAMPING), latency=m.u32(O.LATENCY), on=O.u8(m, O.FF_ON),
                 acquired=O.u8(m, O.ACQUIRED), suspended=O.u8(m, O.SUSPENDED), axis=m.u32(O.AXIS), sign=m.u32(O.DIRSIGN))
    x87 = x87_vectors(m)
    stats = stats_vectors(m)
    block = block_vectors(m)
    ctl, rel = controls_vectors(m)
    setters = setter_vectors(m)
    # 005d3010 device conversion: lMagnitude = _ftol(force * 10000.0f) (exact product, truncation toward zero)
    rng = random.Random(1304)
    forces = [bf(f32b(rng.uniform(-1, 1))) for _ in range(500)] + [1.0, -1.0, 0.0, -0.0, bf(f32b(0.99995)), bf(f32b(-0.00005)), bf(0x3f7fffff)]
    mags = [[f32b(f), int(Fr(f) * 10000) if f >= 0 else -int(-Fr(f) * 10000)] for f in forces]
    doc = dict(image=image, x87=x87, stats=stats, block=block, controls=ctl, release=rel, setters=setters, magnitude=mags)
    out = Path(out_dir); out.mkdir(parents=True, exist_ok=True)
    js = HERE / 'fixtures_json'; js.mkdir(exist_ok=True)
    (js / 'units.json').write_text(json.dumps(doc))
    (out / 'units.lua').write_text('-- GENERATED by recovery/stage13/gen_units13.py from the ORIGINAL NR2003 code (Unicorn); do not edit.\n'
                                   'return ' + G11.lua_value(doc) + '\n')
    print('units: x87 add %d mul %d div %d f32 %d, stats %d, block %d, controls %d + release %d, setters %d, magnitudes %d  %.1f s'
          % (len(x87['add']), len(x87['mul']), len(x87['div']), len(x87['f32']), len(stats), len(block), len(ctl), len(rel),
             len(setters), len(mags), time.time() - t0))


if __name__ == '__main__':
    main(sys.argv[1] if len(sys.argv) > 1 else str(HERE.parent.parent / 'tests' / 'stage13' / 'fixtures'))
