"""Stage 10: derive the setup-invariant ('generic') callback structure of the ORIGINAL emitter.

The original rebuilds the vehicle callbacks at every car build and its emitter decisions depend on values:
  * cell emitter folding (0057c8d0 x==0, 0057c900 x==1, 0057ca60 keep/share-0/share-1/new cell),
  * JIT literal pool dedup by value (005b9970).
A Roblox port needs ONE precompiled callback structure for every garage setup. This script finds, on a large
set of garage setups (defaults, every adjustable item at its minimum and maximum, random setups), the decision
sites whose outcome is not the same for every setup and imposes the non-folding outcome there ('no fold',
'new cell', 'append literal'); all other sites keep the original value-based decision (identical for every
setup). Output: generic_force.pkl = (fold keys, literal call indices) + a report.
Usage: python generic_search.py <random setups per seed> <seeds...>"""
import sys, os, pickle, random, collections, multiprocessing as mp, hashlib, struct, json
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import orig_setup as OS
from emitter_control import FoldControl2, LiteralControl
from unicorn.x86_const import UC_X86_REG_ESP

ITEMS = [0,1,2,3,4,5,6,7,12,13,14,15,20,21,22,23,32,33,34,35,36,38,39,40,41,43,44,45,46,48,49,50,51,53,54,55,56,
         57,59,60,61,62,63,64,65,66,67,68,69,70]
SLOTS = (0xe84548, 0xe84498, 0xe84b90, 0xe84b94, 0xe84b98, 0xe84b9c, 0xe84bdc, 0xe84ba0, 0xe84604)

def garage_setups(n_random, seed, extremes=True):
    m0 = OS.boot(); OS.prepare(m0)
    rng = random.Random(seed)
    def stepped(item, k, base=None):
        tmp = m0.alloc(0xf00, base or bytes(m0.uc.mem_read(OS.ACTIVE, 0xefd)))
        m0.call(0x558380, item, k, ecx=tmp)          # ORIGINAL garage 'set by step index' (005580f0 grid)
        return m0.u32(tmp + 4 * item)
    out = [{}]
    if extremes:
        for item in ITEMS:
            n = m0.call(0x5582d0, item)
            if n <= 0: continue
            out.append({item: stepped(item, 0)}); out.append({item: stepped(item, n)})
    for _ in range(n_random):
        mods = {}
        for item in ITEMS:
            n = m0.call(0x5582d0, item)
            if n > 0: mods[item] = stepped(item, rng.randint(0, n))
        out.append(mods)
    return out

def build(args):
    items, fold_force, lit_follow = args
    m = OS.boot(); OS.prepare(m)
    fc = FoldControl2(m, fold_force); lc = LiteralControl(m, lit_follow)
    orig = m.call
    def pc(addr, *a, **k):
        if addr == 0x57dcd0 and a and a[0] == 0: fc.on = True; lc.on = True   # 005b2f20 body starts
        r = orig(addr, *a, **k)
        if addr == 0x57dcd0 and a and a[0] == 1: fc.on = False; lc.on = False
        return r
    m.call = pc
    OS.apply(m, items)
    end = m.u32(0xebbcec)
    code = hashlib.sha1(bytes(m.uc.mem_read(0xead280, end - 0xead280))).hexdigest()
    return ([d for _, d in fc.seq], [k for k, _ in fc.seq], lc.seq, code, m.u32(0xd47d60), m.u32(0xec02c4),
            tuple(m.u32(s) for s in SLOTS), lc.violations, fc.natural)

def fixpoint(setups, pool, fold, tag):
    for it in range(10):
        res = pool.map(build, [(s, fold, None) for s in setups])
        dec = collections.defaultdict(set); present = collections.Counter()
        for r in res:
            for k, d in zip(r[1], r[0]): dec[k].add(d); present[k] += 1
        new = {k for k, ds in dec.items() if len(ds) > 1 or present[k] != len(res)} - fold
        fold |= new
        same = len(set(tuple(r[0]) for r in res))
        print(tag, 'fold iter', it, 'new', len(new), 'forced', len(fold), 'decision sequences', same,
              'const pool', min(r[4] for r in res), max(r[4] for r in res), flush=True)
        if not new and same == 1: break
    return fold, res

def search(setups, pool):
    fold, res = fixpoint(setups, pool, set(), 'grow')
    # prune: keep only the forced sites whose natural (original) decision differs between setups when every
    # other forced site is in place; repeat until the forced set is stable
    for rnd in range(6):
        nat = collections.defaultdict(set)
        for r in res:
            for k, d in r[8].items(): nat[k].add(d)
        keep = {k for k in fold if len(nat.get(k, ())) > 1 or k not in nat}
        print('prune round', rnd, 'forced', len(fold), '->', len(keep), flush=True)
        if keep == fold: break
        fold, res = fixpoint(setups, pool, keep, 'prune%d' % rnd)
    # literals: reference = default setup (index 0); impose append where the default shares a literal
    # that some setup does not share, keep every other default outcome
    res = pool.map(build, [(s, fold, None) for s in setups])
    seqs = [r[2] for r in res]
    assert len(set(len(s) for s in seqs)) == 1, 'literal call sequences differ'
    ref = seqs[0]
    follow = {k: ('append' if (ref[k] != 'append' and any(s[k] != ref[k] for s in seqs)) else ref[k])
              for k in range(len(ref))}
    forced = sum(1 for k in range(len(ref)) if follow[k] != ref[k])
    print('literal calls', len(ref), 'reference shares', sum(1 for o in ref if o != 'append'), 'forced appends', forced, flush=True)
    return fold, follow

def validate(setups, fold, follow, pool):
    res = pool.map(build, [(s, fold, follow) for s in setups])
    viol = [v for r in res for v in r[7]]
    print('validation setups', len(res), 'fold sequences', len(set(tuple(r[0]) for r in res)),
          'code hashes', len(set(r[3] for r in res)), 'callback slots', len(set(r[6] for r in res)),
          'const pool', set(r[4] for r in res), 'literal top', set(hex(r[5]) for r in res), 'violations', len(viol), flush=True)
    return res

def _main():
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 60
    seeds = [int(x) for x in sys.argv[2:]] or [11, 23, 37]
    setups = garage_setups(0, 0)
    for sd in seeds: setups += garage_setups(n, sd, extremes=False)[1:]
    print('search setups', len(setups), flush=True)
    with mp.Pool(4) as pool:
        fold, follow = search(setups, pool)
        pickle.dump((fold, follow), open(HERE / 'generic_force.pkl', 'wb'))
        val = garage_setups(n, 9001, extremes=False)[1:]
        validate([{}] + val, fold, follow, pool)


# ------------------------------------------------------------------ literal classes (value vectors)
class _LitValues(LiteralControl):
    """natural literal decisions + the value of every 005b9970 call"""
    def __init__(self, m):
        super().__init__(m, None); self.values = []
    def _h(self, uc, addr, size, ud):
        if self.on:
            esp = uc.reg_read(UC_X86_REG_ESP)
            self.values.append(struct.unpack('<f', uc.mem_read(esp + 4, 4))[0])
        return LiteralControl._h(self, uc, addr, size, ud)

def lit_values(args):
    items, fold = args
    m = OS.boot(); OS.prepare(m)
    fc = FoldControl2(m, fold); lc = _LitValues(m)
    from emitter_control import install
    install(m, fc, lc)
    OS.apply(m, items)
    return [0.0 + v for v in lc.values]          # -0.0 == 0.0 for the x87 compare: normalise

def literal_classes(setups, fold, pool):
    """calls whose literal value is equal in EVERY setup share one literal (first call appends)"""
    vals = pool.map(lit_values, [(s, fold) for s in setups])
    n = len(vals[0]); assert all(len(v) == n for v in vals), 'literal call sequences differ'
    first = {}; follow = {}
    for k in range(n):
        vec = tuple(v[k] for v in vals)
        if any(x != x for x in vec): follow[k] = 'append'; continue      # NaN never compares equal
        if vec in first: follow[k] = ('m', first[vec])
        else: first[vec] = k; follow[k] = 'append'
    print('literal calls', n, 'literals', sum(1 for o in follow.values() if o == 'append'), flush=True)
    return follow

def table_check(args):
    items, tables = args
    from emitter_control import TableControl, install
    m = OS.boot(); OS.prepare(m)
    tc = TableControl(m, *tables); install(m, tc)
    try:
        OS.apply(m, items)
    except Exception as e:
        return ('crash', str(e)[:200])
    end = m.u32(0xebbcec)
    code = hashlib.sha1(bytes(m.uc.mem_read(0xead280, end - 0xead280))).hexdigest()
    return (code, m.u32(0xd47d60), m.u32(0xec02c4), tuple(m.u32(s) for s in SLOTS), tc.violations[:5],
            len(tc.violations), tc.imposed, tc.fk, tc.lk)

def validate_tables(setups, tables, pool, tag):
    res = pool.map(table_check, [(s, tables) for s in setups])
    crashes = [r for r in res if r[0] == 'crash']
    ok = [r for r in res if r[0] != 'crash']
    print(tag, 'setups', len(res), 'crashes', len(crashes), 'code hashes', len(set(r[0] for r in ok)),
          'pool', set(r[1] for r in ok), 'literal top', set(hex(r[2]) for r in ok), 'slots', len(set(r[3] for r in ok)),
          'violating setups', sum(1 for r in ok if r[5]), 'imposed', sorted(set(r[6] for r in ok))[:5],
          'events', set(r[7] for r in ok), 'literal calls', set(r[8] for r in ok), flush=True)
    for r in ok:
        if r[5]: print('  violations', r[4], flush=True)
    for r in crashes[:3]: print('  crash', r[1], flush=True)
    return res

def main_literals(n, seeds, nval):
    fold, _ = pickle.load(open(HERE / 'generic_force.pkl', 'rb'))
    setups = garage_setups(0, 0)
    for sd in seeds: setups += garage_setups(n, sd, extremes=False)[1:]
    print('literal search setups', len(setups), 'forced fold sites', len(fold), flush=True)
    with mp.Pool(4) as pool:
        follow = literal_classes(setups, fold, pool)
        pickle.dump((fold, follow), open(HERE / 'generic_force.pkl', 'wb'))
        import gen_build10 as GB
        tables, m = GB.reference_tables(fold, follow)
        print('reference', GB.summary(m)['pool'], hex(GB.summary(m)['litTop']), flush=True)
        validate_tables(setups[:40], tables, pool, 'search-subset')
        validate_tables([{}] + garage_setups(nval, 9001, extremes=False)[1:], tables, pool, 'validation-9001')
        validate_tables(garage_setups(nval, 777, extremes=False)[1:], tables, pool, 'validation-777')


if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == 'literals':
        main_literals(int(sys.argv[2]), [int(x) for x in sys.argv[3:]], 60)
    else:
        _main()
