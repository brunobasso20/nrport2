"""Stage 10 fixtures from the ORIGINAL code (Unicorn): setup descriptors of the Cup car and vectors for every
converter and garage operation, executed under the default FPU control word (0x027f: garage / setup files,
CRT init) and under the game control word (0x077f: simulation/pit-stop task).
Output: tests/stage10/fixtures/setup_vectors.lua (+ JSON copy in recovery/stage10/fixtures_json)."""
import sys, os, struct, json, random
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import orig_setup as OS
from unicorn.x86_const import UC_X86_REG_FP0, UC_X86_REG_EAX, UC_X86_REG_FPSW

def f80(t):
    import math
    if isinstance(t, (int, float)): return float(t)
    mant, se = t
    sign = -1.0 if se & 0x8000 else 1.0
    e = se & 0x7fff
    if e == 0 and mant == 0: return sign * 0.0
    if e == 0x7fff: return float('nan')
    return sign * math.ldexp(mant, e - 16383 - 63)
fbits = lambda x: struct.unpack('<I', struct.pack('<f', x))[0]
bitsf = lambda u: struct.unpack('<f', struct.pack('<I', u & 0xffffffff))[0]
def st0(m):
    # Unicorn FP0..FP7 are the physical registers; ST(0) = physical TOP (FPSW bits 11..13)
    top = (m.uc.reg_read(UC_X86_REG_FPSW) >> 11) & 7
    return f80(m.uc.reg_read(UC_X86_REG_FP0 + top))

def descriptors(m):
    rows = []
    for i in range(184):
        e = 0xc05150 + 6 * i
        kind = struct.unpack('<H', m.uc.mem_read(e, 2))[0]; d = m.u32(e + 2)
        r = {'i': i, 'kind': kind, 'desc': d}
        if d:
            t = struct.unpack('<H', m.uc.mem_read(d, 2))[0]
            r.update(type=t, min=m.u32(d + 2), max=m.u32(d + 6), step=m.u32(d + 10), default=m.u32(d + 14),
                     toInternal=m.u32(d + 18), toDisplay=m.u32(d + 22))
        rows.append(r)
    return rows

def main(out):
    m = OS.boot()                       # CRT init (CW 0x027f): descriptors + defaults
    crt = [m.u32(OS.ACTIVE + 4 * i) for i in range(184)]
    OS.prepare(m)                       # Cup car: 00559950 default completion (004254d0 ...)
    cup = [m.u32(OS.ACTIVE + 4 * i) for i in range(184)]
    garage = [m.u32(OS.GARAGE + 4 * i) for i in range(184)]
    desc = descriptors(m)
    k871a7c = m.u32(0x871a7c)
    m.patch_ret = m.patch_ret
    rng = random.Random(10)
    vec = {'k871a7c': k871a7c, 'modes': {}}
    buf = m.alloc(0x400)
    for mode, cw in (('nearest', 0x027f), ('down', 0x077f)):
        m.fpcw = cw
        V = {'toInternal': [], 'toDisplay': [], 'stepCount': [], 'stepIndex': [], 'snapped': [], 'setSnap': [],
             'setClamp': [], 'step': [], 'setIndex': [], 'validate': []}
        for r in desc:
            if not r['desc']: continue
            i, t = r['i'], r['type']
            ti, td = r['toInternal'], r['toDisplay']
            fmin, fmax, fstep = (bitsf(r['min']), bitsf(r['max']), bitsf(r['step'])) if t == 4 else (None, None, None)
            imin = r['min'] - (1 << 32 if r['min'] >> 31 else 0); imax = r['max'] - (1 << 32 if r['max'] >> 31 else 0)
            istep = r['step'] - (1 << 32 if r['step'] >> 31 else 0)
            # display values: grid, off-grid, out of range
            if t == 4:
                n = int(round((fmax - fmin) / fstep)) if fstep else 0
                disp = [fbits(fmin + k * fstep) for k in range(-1, n + 2)] if fstep else [r['min']]
                disp += [fbits(fmin + (k + rng.random()) * fstep) for k in range(min(n, 6))] if fstep else []
                disp += [fbits(fmin - 10 * abs(fstep or 1)), fbits(fmax + 10 * abs(fstep or 1)), fbits(0.0), fbits(-0.0)]
            else:
                n = (imax - imin) // istep if istep else 0
                ks = list(range(-1, n + 2)) if n <= 120 else sorted(set(list(range(-1, 11)) + list(range(n - 10, n + 2)) + [rng.randint(0, n) for _ in range(40)]))
                disp = [(imin + k * istep) & 0xffffffff for k in ks] if istep else [r['min']]
                disp += [(imin + rng.randint(0, max(imax - imin, 0))) & 0xffffffff for _ in range(4)]
                disp += [(imin - 7) & 0xffffffff, (imax + 7) & 0xffffffff, 0]
            disp = sorted(set(disp))
            raws = []
            if ti:
                for d in disp:
                    raw = m.call(ti, d); V['toInternal'].append((i, d, raw)); raws.append(raw)
            raws = sorted(set(raws + [crt[i], cup[i]]))
            if td:
                for raw in raws:
                    out_ = m.call(td, raw); V['toDisplay'].append((i, raw, out_))
            if ti and td and (istep if t == 3 else fstep):
                V['stepCount'].append((i, m.call(0x5582d0, i) & 0xffffffff))
                for raw in raws:
                    m.w32(buf + 4 * i, raw)
                    V['stepIndex'].append((i, raw, m.call(0x558320, i, ecx=buf) & 0xffffffff))
                    m.call(0x557e40, i, ecx=buf); V['snapped'].append((i, raw, st0(m)))
                    for up in (1, 0):
                        m.w32(buf + 4 * i, raw)
                        ch = m.call(0x5583e0, i, up, ecx=buf) & 0xff
                        V['step'].append((i, raw, up, ch, m.u32(buf + 4 * i)))
                for d in disp:
                    m.w32(buf + 4 * i, 0)
                    m.call(0x5581d0, i, d, ecx=buf); V['setSnap'].append((i, d, m.u32(buf + 4 * i), m.uc.reg_read(UC_X86_REG_EAX)))
                    m.w32(buf + 4 * i, 0)
                    m.call(0x5580f0, i, d, ecx=buf); V['setClamp'].append((i, d, m.u32(buf + 4 * i)))
                nn = m.call(0x5582d0, i)
                for k in (range(-1, nn + 2) if nn <= 120 else sorted(set(list(range(-1, 11)) + list(range(nn - 10, nn + 2)) + [rng.randint(0, nn) for _ in range(40)]))):
                    m.call(0x558380, i, k & 0xffffffff, ecx=buf); V['setIndex'].append((i, k, m.u32(buf + 4 * i)))
        # load validation 00558da0 on whole setups (thiscall on a 0xefd buffer, then 004247e0)
        for trial in range(30):
            s = m.alloc(0xf00, bytes(m.uc.mem_read(OS.GARAGE, 0xefd)))
            for r in desc:
                if r['desc'] and r['toInternal'] and rng.random() < 0.5:
                    if r['type'] == 4: v = fbits(bitsf(r['min']) + (bitsf(r['max']) - bitsf(r['min']) + 2) * rng.random() - 1)
                    else:
                        lo = r['min'] - (1 << 32 if r['min'] >> 31 else 0); hi = r['max'] - (1 << 32 if r['max'] >> 31 else 0)
                        v = (rng.randint(lo - 3, hi + 3)) & 0xffffffff
                    m.w32(s + 4 * r['i'], m.call(r['toInternal'], v))
            before = [m.u32(s + 4 * i) for i in range(184)]
            ok = m.call(0x558da0, ecx=s) & 0xff
            V['validate'].append((before, [m.u32(s + 4 * i) for i in range(184)], ok))
        vec['modes'][mode] = V
    data = {'descriptors': desc, 'crt': crt, 'cup': cup, 'garage': garage, 'vectors': vec}
    Path(out).parent.mkdir(parents=True, exist_ok=True)
    jd = HERE / 'fixtures_json'; jd.mkdir(exist_ok=True)
    json.dump(data, open(jd / 'setup_vectors.json', 'w'))
    # Luau fixture
    def lua(v):
        if isinstance(v, bool): return 'true' if v else 'false'
        if isinstance(v, (int,)): return str(v)
        if isinstance(v, float):
            if v != v: return '0/0'
            if v in (float('inf'), float('-inf')): return ('1/0' if v > 0 else '-1/0')
            return repr(v)
        if isinstance(v, (list, tuple)): return '{' + ','.join(lua(x) for x in v) + '}'
        if isinstance(v, dict): return '{' + ','.join('%s=%s' % (k, lua(x)) for k, x in v.items()) + '}'
        if v is None: return 'nil'
        return '"%s"' % v
    Path(out).write_text('-- GENERATED by recovery/stage10/gen_setup_vectors.py from NR2003.exe (original x86, Unicorn)\nreturn ' + lua(data) + '\n')
    print('vectors', {k: len(v) for k, v in vec['modes']['nearest'].items()})

if __name__ == '__main__':
    main(sys.argv[1] if len(sys.argv) > 1 else str(HERE.parent.parent / 'tests' / 'stage10' / 'fixtures' / 'setup_vectors.lua'))
