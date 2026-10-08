"""Stage 12 level-1 vectors: ORIGINAL steering functions executed one by one in Unicorn (orig_stage12 harness) on the
post-build car state, for tests/stage12/run.luau (fixtures/units.lua).

  axis     00552d00(7 | 8): control raw value, binding, slew state, rate (74c990) -> returned x87 value (exact 80-bit,
           stored as the nearest double + its float32 rounded toward -inf) and the slew state written
  input    00552720 (via 005524f0's store): speed (exported state block), yaw rate state[12], linearity bf6f00, race
           settings bit 25 (yaw limiter), the 11 normalized inputs -1 .. 1 on controls 7 / 8 (analog, rate 1 = no slew)
           and a slewed keyboard subset -> bf63c8 (float32 bits), slew states
  ratio    00554fb0: speed x setup ratio (item 0x30) x low-speed override, speeds at and +-1 ulp around 8.94 / 17.88
           -> exact x87 value
  tail     00551e80 @00552082..00552336: bf63c8 x linearity x binding x speed x ratio x previous target -> bf63c0 after
           the linearity (_CIpow replacement), bf63b8, bf6e80, bf6e88 (float32 bits)
  setters  005502f0 (linearity, raw values and the controls.cfg conversion 0..100), 005500c0 (steering momentum
           0..100 -> rate), 00550110 (low-speed override), 00550210 (assistance 0)
Usage: python gen_units12.py [tests/stage12/fixtures]"""
import sys, struct, math, json, time
from fractions import Fraction
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import orig_stage12 as O
import scenarios12 as SC12

INPUTS = [-1.0, -0.75, -0.5, -0.25, -0.01, 0.0, 0.01, 0.25, 0.5, 0.75, 1.0]


def f32b(x): return struct.unpack('<I', struct.pack('<f', x))[0]
def bf(u): return struct.unpack('<f', struct.pack('<I', u & 0xffffffff))[0]


def f32down_exact(v):
    """float32 rounding toward -inf of an exact value (Fraction or float); returns the bits"""
    if isinstance(v, float):
        if v != v: return 0x7fc00000
        if v == 0: return 0x80000000 if math.copysign(1, v) < 0 else 0
        v = Fraction(v)
    if v == 0: return 0
    x = float(v)                        # nearest double, then nearest float, then step down while above v
    u = f32b(x)
    while Fraction(bf(u)) > v:
        u = (u - 1) if bf(u) > 0 else ((u + 1) if bf(u) < 0 else 0x80000001)
    # the next float above must exceed v
    return u


def nextf(x, d):
    u = f32b(x)
    if x > 0: u += d
    elif x < 0: u -= d
    return bf(u)


def setup_axis(m, n, raw, digital, prev, rate):
    m.wf(O.CTRL_RAW + 10 * n, raw); m.w32(O.CTRL_TYPE + 29 * n, 0 if digital else 1)
    m.wf(0xbf639c + 4 * (0 if n == 7 else 1), prev)
    m.wf(0x74c990, rate)


def xval(v):
    """an exact x87 result as [nearest double, float32-down bits]"""
    if isinstance(v, float): return [v, f32down_exact(v)]
    return [float(v), f32down_exact(v)]


def units():
    o = SC12.make('keys')                # post-build car + Stage 11 session, no steering option (image values)
    m = o.m
    out = {}
    base_rate = m.f32(0x74c990)
    # image values of the option cells (no front-end message has run: controls.cfg absent)
    out['image'] = dict(rate=m.u32(0x74c990), release=m.u32(0x74c99c), lowSpeed=m.uc.mem_read(0x74c9a0, 1)[0],
                        linearity=m.u32(0xbf6f00), assist=m.u32(0xbf6f08))
    # ---------------------------------------------------------------------------------------- axis 00552d00
    ax = []
    raws = [0.0, 0.01, 0.024, 0.025, 0.026, 0.25, 0.5, 0.75, 0.99, 1.0]
    prevs = [0.0, 0.01, 0.3, 0.6, 1.0]
    rates = [base_rate, 1.0, O.f32near(0.016663333999866692), O.f32near(0.0833166700), 0.5, 0.9999]
    for n in (7, 8):
        for raw in raws:
            for prev in prevs:
                for rate in rates:
                    for dig in (True, False):
                        setup_axis(m, n, raw, dig, prev, rate)
                        v = O.call_x80(m, O.AXISSTUB, n)
                        ax.append([n, f32b(raw), dig, f32b(prev), f32b(rate)] + xval(v) + [m.u32(0xbf639c + 4 * (0 if n == 7 else 1))])
    m.wf(0x74c990, base_rate)
    out['axis'] = ax
    # ---------------------------------------------------------------------------------------- input 00552720
    inp = []
    speeds = [0.0, 0.004, 0.01, 0.5, 5.0, 8.94, 12.0, 17.88, 25.0, 45.0, 70.0]
    yaws = [0.0, 0.003, -0.2, 1.5]
    lins = [0.0, 0.2, 0.8, 1.0]
    s25_0 = m.u32(O.SETTINGS + 0x4c)
    for v in speeds:
        for yaw in yaws:
            for L in lins:
                for b25 in (0, 1):
                    m.w32(O.SETTINGS + 0x4c, (s25_0 | 0x2000000) if b25 else (s25_0 & ~0x2000000))
                    m.wf(0xbf6f00, L)
                    m.wf(0x74c990, 1.0)
                    for u in INPUTS:
                        O.speed_state(m, v, yaw)
                        m.wf(O.CTRL_RAW + 70, -u if u < 0 else 0.0); m.wf(O.CTRL_RAW + 80, u if u > 0 else 0.0)
                        m.w32(O.CTRL_TYPE + 29 * 7, 1); m.w32(O.CTRL_TYPE + 29 * 8, 1)
                        m.call(O.STEERSTUB)
                        inp.append([f32b(v), f32b(yaw), f32b(L), b25, f32b(u), 1, m.u32(0xbf63c8)])
    # slewed keyboard subset (rate = image value 0.033): a key held for 1..40 frames then released, speed 3 / 30 m/s
    m.w32(O.SETTINGS + 0x4c, s25_0); m.wf(0xbf6f00, 0.0); m.wf(0x74c990, base_rate)
    seq = []
    for v in (3.0, 30.0):
        m.wf(0xbf639c, 0.0); m.wf(0xbf63a0, 0.0)
        for k in range(60):
            key = 1.0 if k < 40 else 0.0
            O.speed_state(m, v, 0.1)
            m.wf(O.CTRL_RAW + 70, key if (k // 20) % 2 == 0 else 0.0); m.wf(O.CTRL_RAW + 80, key if (k // 20) % 2 == 1 else 0.0)
            m.w32(O.CTRL_TYPE + 29 * 7, 0); m.w32(O.CTRL_TYPE + 29 * 8, 0)
            m.call(O.STEERSTUB)
            seq.append([f32b(v), m.u32(O.CTRL_RAW + 70), m.u32(O.CTRL_RAW + 80), m.u32(0xbf63c8), m.u32(0xbf639c), m.u32(0xbf63a0)])
    out['input'] = inp
    out['keySeq'] = seq
    m.w32(O.SETTINGS + 0x4c, s25_0)
    # ---------------------------------------------------------------------------------------- ratio 00554fb0
    rat = []
    vs = [0.0, 1.0, nextf(8.94, -1), O.f32near(8.94), nextf(8.94, 1), 10.0, 13.41, nextf(17.88, -1), O.f32near(17.88),
          nextf(17.88, 1), 20.0, 50.0]
    ratios = [6.5, 7.0, 7.5, 12.0, 13.0, 18.0, 25.0, 32.0]
    for ov in (1, 0):
        m.call(0x550110, ov)
        for r in ratios:
            m.wf(O.SETUP_RATIO, r)
            for v in vs:
                O.speed_state(m, v)
                rv = O.call_x80(m, O.RATIOSTUB)
                rat.append([ov, f32b(r), f32b(v)] + xval(rv))
    m.call(0x550110, 1); m.wf(O.SETUP_RATIO, 18.0)
    out['ratio'] = rat
    # ---------------------------------------------------------------------------------------- tail 00551e80
    tl = []
    c8s = [-1.0, -0.75, -0.5, -0.25, -0.01, -0.0, 0.0, 0.01, 0.25, 0.5, 0.75, 1.0, -0.123456, 0.987654]
    for L in (0.0, 0.2, 0.5, 0.8, 1.0):
        m.call(0x5502f0, O.u32f(L))
        for dig in (False, True):
            for (v, r) in ((0.0, 18.0), (12.0, 18.0), (30.0, 18.0), (30.0, 12.0), (5.0, 32.0)):
                m.wf(O.SETUP_RATIO, r)
                for c8 in c8s:
                    for prev in (0.0, -0.0, 0.05):
                        O.speed_state(m, v)
                        m.w32(O.CTRL_TYPE + 29 * 7, 0 if dig else 1); m.w32(O.CTRL_TYPE + 29 * 8, 0 if dig else 1)
                        m.wf(0xbf63c8, c8); m.wf(0xbf6e80, prev)
                        sh = []
                        O.run_tail(m, sh)
                        tl.append([f32b(L), dig, f32b(v), f32b(r), f32b(c8), f32b(prev), sh[0], m.u32(0xbf63b8),
                                   m.u32(0xbf6e80), m.u32(0xbf6e88), m.u32(0xbf63c0)])
    m.call(0x5502f0, O.u32f(0.0)); m.wf(O.SETUP_RATIO, 18.0)
    out['tail'] = tl
    # ---------------------------------------------------------------------------------------- setters
    st = {'linRaw': [], 'linUI': [], 'momentum': [], 'lowSpeed': [], 'assist': []}
    for x in (-1.0, -0.0, 0.0, 1e-7, 0.3, 0.8, 0.99999994, 1.0, 1.5, float('nan')):
        m.call(0x5502f0, O.u32f(x)); st['linRaw'].append([f32b(x), m.u32(0xbf6f00)])
    for v in range(101):
        x = O.f32near(v * O.f32near(0.01))
        m.call(0x5502f0, O.u32f(x)); st['linUI'].append([v, m.u32(0xbf6f00)])
    for mm in range(101):
        m.call(0x5500c0, 0, O.u32f(float(mm))); st['momentum'].append([mm, m.u32(0x74c990)])
    for b in (0, 1):
        m.call(0x550110, b); st['lowSpeed'].append([b, m.uc.mem_read(0x74c9a0, 1)[0]])
    m.call(0x550210, O.u32f(0.0)); st['assist'].append([0, m.u32(0xbf6f08)])
    out['setters'] = st
    return out


def lua_value(v):
    if isinstance(v, bool): return 'true' if v else 'false'
    if isinstance(v, int): return str(v)
    if isinstance(v, float):
        if v != v: return '0/0'
        if v in (float('inf'), float('-inf')): return '(1/0)' if v > 0 else '(-1/0)'
        if v == 0 and math.copysign(1, v) < 0: return '-0.0'
        return repr(v)
    if isinstance(v, str): return json.dumps(v)
    if isinstance(v, (list, tuple)): return '{' + ','.join(lua_value(x) for x in v) + '}'
    if isinstance(v, dict): return '{' + ','.join('[%s]=%s' % (k if isinstance(k, int) else json.dumps(k), lua_value(x)) for k, x in v.items()) + '}'
    raise TypeError(v)


if __name__ == '__main__':
    out_dir = Path(sys.argv[1] if len(sys.argv) > 1 else HERE.parent.parent / 'tests' / 'stage12' / 'fixtures')
    out_dir.mkdir(parents=True, exist_ok=True)
    t0 = time.time()
    u = units()
    (HERE / 'fixtures_json').mkdir(exist_ok=True)
    (HERE / 'fixtures_json' / 'units.json').write_text(json.dumps(u))
    (out_dir / 'units.lua').write_text('-- GENERATED by recovery/stage12/gen_units12.py from the ORIGINAL NR2003 code (Unicorn); do not edit.\nreturn ' + lua_value(u) + '\n')
    print('units: axis %d input %d keySeq %d ratio %d tail %d linUI %d momentum %d  %.1f s' % (
        len(u['axis']), len(u['input']), len(u['keySeq']), len(u['ratio']), len(u['tail']), len(u['setters']['linUI']),
        len(u['setters']['momentum']), time.time() - t0))
