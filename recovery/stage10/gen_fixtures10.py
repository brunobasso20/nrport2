"""Stage 10 golden fixtures from the ORIGINAL NR2003.exe code (Unicorn).

For a set of named garage setups (values chosen on the ORIGINAL garage grid with 00558380):
  build : what NR2003CupBuild runs (emitter_control.TableControl): the NATURAL structure (strict, the
          default's original emitter outcome) when the setup's own outcome equals it, else the GENERIC
          structure -> every dword of the core image windows that differs from that structure's default
          build, plus the structure report (constant pool, literal top, code end)
  dyn   : the 'drive' scenario of tests/stage67 (driver layer, flat ground) on
            orig : the ORIGINAL natural build of the setup (no emitter control: what the game runs)
            pert : the same from a 1-ulp perturbed initial state (the original's sensitivity envelope)
            gen  : the generic-structure build of the setup (rounding effect of the generic structure)
Usage: python gen_fixtures10.py <tests/stage10/fixtures> <recovery/stage10/fixtures_json>"""
import os, sys, json, base64, pickle, struct, random, re
from pathlib import Path
import multiprocessing as mp
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE)); sys.path.insert(0, str(HERE.parent / 'stage6_7'))
import orig_runtime, orig_setup as OS
from emitter_control import TableControl, install
from gen_runtime import canonical_state, HOST
import generic_search as GS

TICKS, EVERY, FIRST = 2304, 72, 8
# step indices on the ORIGINAL garage grid (005582d0 counts; defaults in SETUP_MAP.md)
NAMED = [
    ('default', {}),
    ('springs_shocks', {20: 25, 21: 21, 22: 10, 23: 12, 4: 5, 5: 2, 6: 4, 7: 6, 12: 6, 13: 1, 14: 5, 15: 2}),
    ('geometry', {32: 40, 33: 70, 34: 2, 35: 0, 67: 10, 68: 24, 41: 8, 45: 10, 46: 14}),
    ('weight', {64: 42, 62: 22, 63: 28, 36: 1, 38: 3, 39: 2, 43: 9, 44: 12}),
    ('gearing', {53: 8, 54: 22, 55: 35, 56: 40, 57: 20}),
    ('brakes_aero_tyres', {40: 14, 0: 50, 1: 62, 2: 52, 3: 70, 59: 8, 61: 10, 49: 10}),
    ('random', 'random'),
    ('allmin', 'min'),
    ('allmax', 'max'),
]

def raw_setups():
    m0 = OS.boot(); OS.prepare(m0)
    base = bytes(m0.uc.mem_read(OS.ACTIVE, 0xefd))
    def stepped(item, k):
        tmp = m0.alloc(0xf00, base)
        m0.call(0x558380, item, k, ecx=tmp)
        return m0.u32(tmp + 4 * item)
    out = []
    rng = random.Random(1234)
    for name, spec in NAMED:
        if spec == 'random':
            ks = {i: rng.randint(0, m0.call(0x5582d0, i)) for i in GS.ITEMS if m0.call(0x5582d0, i) > 0}
        elif spec == 'min':
            ks = {i: 0 for i in GS.ITEMS if m0.call(0x5582d0, i) > 0}
        elif spec == 'max':
            ks = {i: m0.call(0x5582d0, i) for i in GS.ITEMS if m0.call(0x5582d0, i) > 0}
        else:
            ks = spec
        out.append((name, ks, {i: stepped(i, k) for i, k in ks.items()}))
    return out

def windows_of(core_dir):
    W = []
    for p in sorted(Path(core_dir).glob('NR2003CupImage*.lua')):
        for off, b64 in re.findall(r'\{(\d+),"([A-Za-z0-9+/=]*)"\}', p.read_text()):
            W.append((int(off), len(base64.b64decode(b64))))
    return sorted(W)

def tables(kind='generic'):
    return pickle.load(open(HERE / ('%s_tables.pkl' % kind), 'rb'))['tables']

def build_mem(items, W, structure):
    m = OS.boot(); OS.prepare(m)
    tc = TableControl(m, *tables(structure), strict=structure == 'natural'); install(m, tc)
    OS.apply(m, items)
    m.uc.mem_write(OS.OV.BG_FLAG, b'\x01')   # as orig_runtime.Original after the build (the shipped image has 1)
    mem = b''.join(bytes(m.uc.mem_read(0x6e9000 + off, n)) for off, n in W)
    rep = dict(pool=m.u32(0xd47d60), litTop=m.u32(0xec02c4), codeEnd=m.u32(0xebbcec), violations=len(tc.violations), structure=structure)
    return mem, rep

def build_any(items, W):
    mem, rep = build_mem(items, W, 'natural')
    if rep['violations'] == 0: return mem, rep
    return build_mem(items, W, 'generic')

VAR_LO, VAR_HI = 0xebbf60, 0xebf610      # JIT variable cells
# tyre objects (0054c1c0): 4 x 0xa39 bytes from bf3a20, so wheels 1..3 have UNALIGNED float fields: they are
# compared field by field at their own addresses, everything else as aligned dwords
TY_LO, TY_STRIDE = 0xbf3a20, 0xa39
TY_HI = TY_LO + 4 * TY_STRIDE
SOLVE = set()   # cell offsets (outside the variable cells) written by the build after the code generation (steps
                # 17-19: generated solve pass through the translated JIT, 0057dcd0(1), 0054d610 x4); filled by main()

_CELLS = {}
def cell_list(W):
    """[(offset, position in the window blob)]: aligned dwords outside the tyre objects + tyre fields"""
    key = tuple(tuple(w) for w in W)
    if key not in _CELLS: _CELLS[key] = _cell_list(W)
    return _CELLS[key]

def _cell_list(W):
    out, pos, where = [], 0, []
    for off, n in W:
        where.append((off, n, pos))
        for j in range(0, n, 4):
            a = 0x6e9000 + off + j
            if a + 4 <= TY_LO or a >= TY_HI: out.append((off + j, pos + j))
        pos += n
    for w in range(4):
        for k in range(0, TY_STRIDE - 3, 4):
            o = TY_LO + TY_STRIDE * w + k - 0x6e9000
            p = next(p0 + o - w0 for w0, n0, p0 in where if w0 <= o and o + 4 <= w0 + n0)
            out.append((o, p))
    return out

def tolerant(o): return VAR_LO <= 0x6e9000 + o < VAR_HI or o in SOLVE

def fnv(mem, W):
    """FNV-1a over the cells the build computes exactly (tests/stage10/run.luau)"""
    h = 2166136261
    for o, p in cell_list(W):
        if not tolerant(o): h = ((h ^ struct.unpack('<I', mem[p:p + 4])[0]) * 16777619) & 0xffffffff
    return h

def var_delta(mem, base_, W):
    return [(o, struct.unpack('<I', mem[p:p + 4])[0]) for o, p in cell_list(W) if tolerant(o) and mem[p:p + 4] != base_[p:p + 4]]

def cell_delta(mem, base_, W):
    return [(o, struct.unpack('<I', mem[p:p + 4])[0]) for o, p in cell_list(W) if mem[p:p + 4] != base_[p:p + 4]]

def solve_written(args):
    """cells written by build steps 17-19 (after the code generation) in the Unicorn build"""
    items, structure = args
    from unicorn import UC_HOOK_MEM_WRITE
    m = OS.boot(); OS.prepare(m)
    tc = TableControl(m, *tables(structure), strict=structure == 'natural'); install(m, tc)
    on = [False]; written = set()
    def wr(uc, access, addr, size, value, ud):
        if not on[0]: return
        if TY_LO <= addr < TY_HI or TY_LO <= addr + size - 1 < TY_HI:
            for b in range(addr, addr + size):
                if TY_LO <= b < TY_HI:
                    w = (b - TY_LO) // TY_STRIDE; k = (b - TY_LO - TY_STRIDE * w) // 4 * 4
                    if k <= TY_STRIDE - 4: written.add(TY_LO + TY_STRIDE * w + k)
        else:
            for a in range(addr & ~3, addr + size, 4): written.add(a)
    m.uc.hook_add(UC_HOOK_MEM_WRITE, wr); m.uc.ctl_flush_tb()
    OS.apply(m, items, on_step=lambda k: on.__setitem__(0, k >= 16))
    return sorted(written)

def item_setups():
    """every adjustable garage item at its minimum, maximum and default +/- 1 step (ORIGINAL 00558380 grid)"""
    m0 = OS.boot(); OS.prepare(m0)
    base = bytes(m0.uc.mem_read(OS.ACTIVE, 0xefd))
    out = []
    for i in GS.ITEMS:
        n = m0.call(0x5582d0, i)
        if n <= 0: continue
        kd = m0.call(0x558320, i, ecx=OS.ACTIVE)
        for tag, k in (('min', 0), ('max', n), ('-1', kd - 1), ('+1', kd + 1)):
            if not 0 <= k <= n or k == kd: continue
            tmp = m0.alloc(0xf00, base)
            m0.call(0x558380, i, k, ecx=tmp)
            out.append((i, tag, k, m0.u32(tmp + 4 * i)))
    return out

def ulp_up(x): return struct.unpack('<f', struct.pack('<I', struct.unpack('<I', struct.pack('<f', x))[0] + 1))[0]

def drive_controls(frame):
    t = frame / 36.0
    c = dict(throttle=0.0, brake=0.0, clutch=0.0, steer=0.0)
    if t >= 0.5: c['clutch'] = 1.0
    if t >= 0.75: c['throttle'] = 0.7
    if 4.5 <= t < 5.5: c['steer'] = 0.01
    if t >= 6.0: c['throttle'] = 0.0; c['brake'] = 0.5
    up = [round(36 * s) for s in (0.8, 1.6, 2.6, 3.8)]
    if frame in up: c['shiftUp'] = True
    if frame == round(36 * 6.6): c['shiftDown'] = True
    return c

def drive(items, generic, perturb):
    def b(m, chassis_type=OS.OV.CHASSIS_TYPE, series=OS.OV.CUP, log=print):
        spec = OS.prepare(m, chassis_type, series)
        if generic: install(m, TableControl(m, *tables()))
        OS.apply(m, items)
        return spec, 0x727290
    orig_runtime.build = b
    st = canonical_state()
    if perturb: st[4] = ulp_up(st[4])
    o = orig_runtime.OriginalDriver(state=st); m = o.m
    o.outF = [HOST + 0x00 + 16 * i for i in range(4)]; o.outP = [HOST + 0x40 + 16 * i for i in range(4)]
    o.gv = [HOST + 0x80 + 16 * i for i in range(4)]; o.blocks = [HOST + 0xc0 + 32 * i for i in range(4)]
    m.uc.mem_write(HOST, b'\0' * 0x200)
    con = orig_runtime.flat(0.0, 1); rows = []
    for k in range(1, TICKS + 1):
        s = o.step_driver(drive_controls((k - 1) // 8), con)
        if k <= FIRST or k % EVERY == 0:
            rows.append([k] + s + [m.i32(0x74c97c)])
    return rows

def job(args):
    kind, name, items, W = args
    if kind == 'build': return kind, name, build_any(items, W)
    if kind == 'gdefault': return kind, name, build_mem(items, W, 'generic')
    if kind == 'item': return kind, name, build_any(items, W)
    if kind == 'solve': return kind, name, solve_written((items, name[1]))
    return kind, name, drive(items, kind == 'gen', kind == 'pert')

def lua(v):
    if isinstance(v, float): return repr(v) if v == v else '0/0'
    if isinstance(v, (list, tuple)): return '{' + ','.join(lua(x) for x in v) + '}'
    return str(v)

def main(out_dir, json_dir):
    out = Path(out_dir); out.mkdir(parents=True, exist_ok=True)
    jd = Path(json_dir); jd.mkdir(parents=True, exist_ok=True)
    W = windows_of(sys.argv[3] if len(sys.argv) > 3 else HERE.parent.parent / 'core' / 'NR2003Cup')
    setups = raw_setups()
    isets = item_setups()
    jobs = [('build', n, it, W) for n, _, it in setups] + [('gdefault', 'default', {}, W)] + \
           [('item', (i, tag), {i: raw}, W) for i, tag, k, raw in isets] + \
           [('solve', (n, st), it, W) for n, _, it in setups for st in ('natural', 'generic')] + \
           [(k, n, it, W) for n, _, it in setups for k in ('orig', 'pert', 'gen')]
    with mp.Pool(4) as pool:
        res = pool.map(job, jobs)
    R = {(k, n): v for k, n, v in res}
    cells = set(o for o, p in cell_list(W))
    for (k, n), v in R.items():
        if k == 'solve': SOLVE.update(a - 0x6e9000 for a in v if (a - 0x6e9000) in cells and not (VAR_LO <= a < VAR_HI))
    print('solve-pass cells in the image windows (outside the variable cells):', len(SOLVE))
    nmem, nref = R[('build', 'default')]
    assert nref['structure'] == 'natural'
    dmem, dref = R[('gdefault', 'default')]
    DEF = {'natural': nmem, 'generic': dmem}
    # ---------------------------------------------------------------- build fixture
    L = ['-- GENERATED by recovery/stage10/gen_fixtures10.py from the ORIGINAL NR2003.exe (Unicorn); do not edit.',
         '-- Setup application (emitter_control.TableControl, natural structure when representable, else generic) of',
         '-- named garage setups: image-window dwords that differ from the default build of the same structure',
         '-- (natural default = the shipped image; genericDefault = generic build of the default setup). Cells = aligned',
         '-- dwords outside the tyre objects + tyre fields at their own (unaligned) addresses; solve = cells written after the',
         '-- code generation (computed in double by the port).',
         'return {', 'windows = %s,' % lua([list(w) for w in W]),
         'solve = %s,' % lua(sorted(SOLVE)),
         'genericDefault = "%s",' % base64.b64encode(dmem).decode(),
         'setups = {']
    J = {'windows': W, 'solve': sorted(SOLVE), 'setups': {}}
    for name, ks, items in setups:
        mem, rep = R[('build', name)]
        base_ = DEF[rep['structure']]
        delta = cell_delta(mem, base_, W)
        L.append('{name="%s", structure="%s", steps={%s}, items={%s}, violations=%d, pool=%d, litTop=%d, codeEnd=%d, delta={%s}},' % (
            name, rep['structure'], ','.join('[%d]=%d' % kv for kv in sorted(ks.items())), ','.join('[%d]=%d' % kv for kv in sorted(items.items())),
            rep['violations'], rep['pool'], rep['litTop'], rep['codeEnd'], ','.join('{%d,%d}' % d for d in delta)))
        J['setups'][name] = {'steps': ks, 'items': items, 'report': rep, 'delta': delta}
    L += ['}', '}']
    (out / 'build_fixture.lua').write_text('\n'.join(L) + '\n')
    # ---------------------------------------------------------------- dynamics fixture
    L = ['-- GENERATED by recovery/stage10/gen_fixtures10.py from the ORIGINAL NR2003.exe (Unicorn); do not edit.',
         '-- drive scenario (tests/stage67) per garage setup: rows {tick, state[1..45], gearIndex}',
         '-- orig = ORIGINAL natural build of the setup, pert = 1-ulp perturbed start, gen = generic-structure build',
         'return {ticks=%d, every=%d, first=%d, setups={' % (TICKS, EVERY, FIRST)]
    for name, ks, items in setups:
        L.append('{name="%s", items={%s},' % (name, ','.join('[%d]=%d' % kv for kv in sorted(items.items()))))
        for k in ('orig', 'pert', 'gen'):
            L.append('%s=%s,' % (k, lua(R[(k, name)])))
            J['setups'][name][k] = R[(k, name)]
        L.append('},')
    L += ['}}']
    (out / 'dyn_fixture.lua').write_text('\n'.join(L) + '\n')
    # ---------------------------------------------------------------- per-item fixture
    L = ['-- GENERATED by recovery/stage10/gen_fixtures10.py from the ORIGINAL NR2003.exe (Unicorn); do not edit.',
         '-- Every adjustable garage item at min / max / default -1 / default +1 step (00558380 grid), applied alone:',
         '-- structure used, FNV-1a of the image-window dwords outside the variable cells, variable-cell deltas',
         '-- (vs the default build of the same structure). Defaults: natural = shipped image, generic = build_fixture.',
         'return {']
    J['items'] = []
    for i, tag, k, raw in isets:
        mem, rep = R[('item', (i, tag))]
        base_ = DEF[rep['structure']]
        vd = var_delta(mem, base_, W)
        L.append('{item=%d, tag="%s", k=%d, raw=%d, structure="%s", violations=%d, pool=%d, litTop=%d, hash=%d, var={%s}},' % (
            i, tag, k, raw, rep['structure'], rep['violations'], rep['pool'], rep['litTop'], fnv(mem, W), ','.join('{%d,%d}' % d for d in vd)))
        J['items'].append(dict(item=i, tag=tag, k=k, raw=raw, report=rep, hash=fnv(mem, W), var=vd))
    L.append('}')
    (out / 'items_fixture.lua').write_text('\n'.join(L) + '\n')
    print('items', len(isets), 'natural', sum(1 for x in J['items'] if x['report']['structure'] == 'natural'),
          'generic', sum(1 for x in J['items'] if x['report']['structure'] == 'generic'))
    (jd / 'stage10_fixtures.json').write_text(json.dumps(J))
    for name, ks, items in setups:
        o, p, g = R[('orig', name)][-1], R[('pert', name)][-1], R[('gen', name)][-1]
        print('%-18s %-8s final x orig %.4f pert %.4f gen %.4f  gear %d  build delta %d' % (
            name, J['setups'][name]['report']['structure'], o[1], p[1], g[1], o[-1], len(J['setups'][name]['delta'])))

if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
