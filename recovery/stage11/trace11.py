"""Stage 11 memory footprint of the ORIGINAL per-frame runtime code (Unicorn).

Runs coverage scenarios with OriginalStage11 and records, only while Stage 11 original code executes (frame end
00554520 + collision frame 00549c40, collision record entry 0054a760, pit service 00550f10), every dword read or
written. Output (footprint11.pkl):
  touched   bytearray per dword of [BASE, TOP): bit0 read, bit1 written, bit2 read before any write in the run
  outside   {address-page: count} of accesses outside the Luau image range (must be empty)
  indirect  {site: set(targets)} of indirect calls executed (checked against lift11.INDIRECT)
Scenarios are also used by gen_fixtures11.py; they live in scenarios11.py."""
import sys, os, pickle, collections, struct
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from orig_stage11 import *          # noqa
HERE = Path(__file__).resolve().parent   # (the star import above re-binds HERE)
from unicorn import UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE, UC_HOOK_CODE
from unicorn.x86_const import *
import lift11
import capstone

BASE, TOP = lift11.BASE, lift11.TOP
STACK_LO = 0x1f000000 - 0x200000


class Tracer:
    def __init__(self, m, sites=()):
        self.m = m
        self.touched = bytearray((TOP - BASE) // 4)
        self.outside = collections.Counter()
        self.indirect = collections.defaultdict(set)
        self.handles = []
        self.sites = list(sites)
        self.md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32); self.md.detail = True

    def _mem(self, uc, access, addr, size, value, user):
        if STACK_LO <= addr < 0x1f001000: return
        if BASE <= addr < TOP:
            w = access == UC_MEM_WRITE
            for a in range((addr & ~3), addr + size, 4):
                k = (a - BASE) >> 2
                if k >= len(self.touched): break
                t = self.touched[k]
                if w: t |= 2
                else:
                    t |= 1
                    if not (t & 2): t |= 4
                self.touched[k] = t
        elif not (0x401000 <= addr < 0x6e9000):
            self.outside[addr & ~0xfff] += 1

    def _site(self, uc, address, size, user):
        i = next(self.md.disasm(bytes(uc.mem_read(address, 16)), address))
        op = i.operands[0]
        regs = {capstone.x86.X86_REG_EAX: UC_X86_REG_EAX, capstone.x86.X86_REG_ECX: UC_X86_REG_ECX,
                capstone.x86.X86_REG_EDX: UC_X86_REG_EDX, capstone.x86.X86_REG_EBX: UC_X86_REG_EBX,
                capstone.x86.X86_REG_ESI: UC_X86_REG_ESI, capstone.x86.X86_REG_EDI: UC_X86_REG_EDI,
                capstone.x86.X86_REG_EBP: UC_X86_REG_EBP, capstone.x86.X86_REG_ESP: UC_X86_REG_ESP}
        if op.type == capstone.x86.X86_OP_REG:
            t = uc.reg_read(regs[op.reg])
        else:
            mm = op.mem; a = mm.disp
            if mm.base: a += uc.reg_read(regs[mm.base])
            if mm.index: a += uc.reg_read(regs[mm.index]) * mm.scale
            t = struct.unpack('<I', uc.mem_read(a & 0xffffffff, 4))[0]
        self.indirect[address].add(t)

    # Unicorn instruments memory/code hooks when it translates a block: translated blocks are flushed whenever
    # the hooks change so that every block executed under the tracer is instrumented (and the others are not)
    def _flush(self):
        self.m.uc.ctl_flush_tb()

    def __enter__(self):
        uc = self.m.uc
        self._flush()
        self.handles.append(uc.hook_add(UC_HOOK_MEM_READ | UC_HOOK_MEM_WRITE, self._mem))
        for s in self.sites:
            self.handles.append(uc.hook_add(UC_HOOK_CODE, self._site, begin=s, end=s))
        return self

    def __exit__(self, *a):
        for h in self.handles: self.m.uc.hook_del(h)
        self.handles = []


class TracedStage11(OriginalStage11):
    tracer = None
    def frame_end(self):
        with self.tracer:
            OriginalStage11.frame_end(self)
    def traced_call(self, *a, **k):
        with self.tracer:
            return self.m.call(*a, **k)


def run(scenarios, sites):
    import scenarios11 as SC
    acc = None
    for name in scenarios:
        t0 = time.time()
        if name == 'zonetree':
            # session-start step run once per car load: the collision-damage zone tree (00433610), traced alone
            import orig_stage11 as O
            st = [0.0] * 45; st[4] = 0.42; st[9] = 1.0
            o = TracedStage11(state=st, weather=SC.DEFAULT_SESSION, zone_tree=False)
            o.tracer = Tracer(o.m, sites)
            O.build_zone_tree(o.m, call=o.traced_call)
        else:
            o, script = SC.make(name, cls=TracedStage11)
            o.tracer = Tracer(o.m, sites)
            SC.play(o, script, traced=True)
        tr = o.tracer
        if acc is None: acc = tr
        else:
            for k, v in enumerate(tr.touched):
                if v: acc.touched[k] |= v
            acc.outside.update(tr.outside)
            for s, t in tr.indirect.items(): acc.indirect[s] |= t
        print('%-14s %.1f s  touched %d  outside %d' % (name, time.time() - t0, sum(1 for x in tr.touched if x), sum(tr.outside.values())))
    return acc


def merge(paths, out):
    acc = None
    for p in paths:
        d = pickle.load(open(p, 'rb'))
        if acc is None:
            acc = {'touched': bytearray(d['touched']), 'outside': dict(d['outside']), 'indirect': {k: set(v) for k, v in d['indirect'].items()}}
            continue
        t = acc['touched']
        for k, v in enumerate(d['touched']):
            if v: t[k] |= v
        for k, v in d['outside'].items(): acc['outside'][k] = acc['outside'].get(k, 0) + v
        for k, v in d['indirect'].items(): acc['indirect'].setdefault(k, set()).update(v)
    pickle.dump({'touched': bytes(acc['touched']), 'outside': acc['outside'],
                 'indirect': {k: sorted(v) for k, v in acc['indirect'].items()}}, open(out, 'wb'))
    return acc


if __name__ == '__main__':
    # python trace11.py <scenario>...   -> footprint11_<scenario>.pkl each
    # python trace11.py --merge         -> footprint11.pkl (union of footprint11_*.pkl)
    import time, scenarios11 as SC
    if sys.argv[1:2] == ['--merge']:
        paths = sorted(HERE.glob('footprint11_*.pkl'))
        acc = merge(paths, HERE / 'footprint11.pkl')
        print('merged', [p.name for p in paths], 'touched', sum(1 for x in acc['touched'] if x),
              'outside', acc['outside'], 'indirect', {hex(k): [hex(x) for x in v] for k, v in acc['indirect'].items()})
        sys.exit(0)
    L = lift11.lift_all()
    sites = [a for a, _ in L.indirect_sites] if os.environ.get('TRACE_SITES') else []
    for name in (sys.argv[1:] or SC.TRACE):
        acc = run([name], sites)
        pickle.dump({'touched': bytes(acc.touched), 'outside': dict(acc.outside),
                     'indirect': {k: sorted(v) for k, v in acc.indirect.items()}}, open(HERE / ('footprint11_%s.pkl' % name), 'wb'))
        print('outside pages', {hex(k): v for k, v in acc.outside.items()})
        print('indirect', {hex(k): [hex(x) for x in v] for k, v in acc.indirect.items()})
