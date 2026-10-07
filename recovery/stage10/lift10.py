"""Stage 10 extension of the Stage 6/7 x86 -> Luau lifter (recovery/stage6_7/lift.py, unchanged).
Adds what the ORIGINAL car build path (005b2f20 and the setup conversion functions) needs:
  * MSVC two-level switch tables:  cmp R,N / ja d / xor c,c / mov cl,[R+idx] / jmp [c*4+tbl]
  * string instructions with REP/REPNE/REPE prefixes (direction flag clear, as in all MSVC code)
  * x87 fldln2, fldl2e, fldl2t, fldlg2, fldpi, fyl2x, f2xm1, fscale, ftst, fxam-free subset
Semantics follow the Stage 6/7 conventions: x87 arithmetic in IEEE double, float32 stores rounded with
the current control word (see Lifter10.cw: 'down' = 0x077f game CW, 'nearest' = 0x027f default CW)."""
import os, sys, re
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent / 'stage6_7'))
sys.path.insert(0, os.environ.get('CAPSTONE_PY', ''))
from lift import Lifter, LiftError, R32, X
import capstone

class Lifter10(Lifter):
    X87_DELTA = dict(Lifter.X87_DELTA)
    X87_DELTA.update({'fldln2': 1, 'fldl2e': 1, 'fldl2t': 1, 'fldlg2': 1, 'fldpi': 1, 'fyl2x': -1})

    def jump_table(self, i, prev):
        r = Lifter.jump_table(self, i, prev)
        if r is not None: return r
        op = i.operands[0]; m = op.mem
        if op.type != X.X86_OP_MEM or m.base or not m.index or m.scale != 4: return None
        # look back for: cmp R, N / ja / [xor C, C] / mov C8, byte ptr [R + idx]
        seq = [x for x in prev if x is not None]
        mv = next((x for x in reversed(seq) if x.mnemonic in ('mov', 'movzx') and x.operands[1].type == X.X86_OP_MEM
                   and x.operands[1].size == 1), None)
        if mv is None: return None
        src = mv.operands[1].mem
        if src.index and src.base: return None
        idxreg = src.base or src.index
        cmp_ = next((x for x in reversed(seq) if x.mnemonic == 'cmp' and x.operands[0].type == X.X86_OP_REG
                     and x.operands[0].reg == idxreg and x.operands[1].type == X.X86_OP_IMM), None)
        if cmp_ is None: return None
        n = cmp_.operands[1].imm + 1
        idx = self.read(src.disp & 0xffffffff, n)
        cnt = max(idx) + 1
        tbl = self.read(m.disp & 0xffffffff, 4 * cnt)
        targets = [int.from_bytes(tbl[4 * b:4 * b + 4], 'little') for b in idx]
        return self.reg32(idxreg), targets

    def discover(self, entry):
        # Lifter.discover only keeps the two instructions before an indirect jump: track a longer window
        ins = {}; leaders = {entry}; work = [entry]; calls = set()
        self.jtables = getattr(self, 'jtables', {})
        while work:
            a = work.pop(); prev = []
            while a not in ins:
                i = self.decode(a); ins[a] = i; mn = i.mnemonic
                if mn == 'jmp' and i.operands[0].type == X.X86_OP_MEM:
                    ends = {x.address + x.size: x for x in ins.values()}
                    chain = []; cur = i
                    for _ in range(6):
                        p = ends.get(cur.address)
                        if p is None: break
                        chain.insert(0, p); cur = p
                    jt = self.jump_table(i, chain if chain else prev)
                    if jt is None: raise LiftError('indirect jump at %x' % a)
                    self.jtables[a] = jt
                    for t in jt[1]: leaders.add(t); work.append(t)
                    break
                prev.append(i)
                hk = self.hooks.get(a)
                if hk is not None:                     # hook sites start a block (see inst())
                    leaders.add(a)
                    if hk[0] == 'branch': leaders.add(hk[2]); work.append(hk[2])
                if mn.startswith('j'):
                    op = i.operands[0]
                    if op.type != X.X86_OP_IMM: raise LiftError('indirect jump at %x' % a)
                    leaders.add(op.imm); work.append(op.imm)
                    if mn != 'jmp':
                        leaders.add(a + i.size); work.append(a + i.size)
                    break
                if mn == 'call':
                    op = i.operands[0]
                    if op.type == X.X86_OP_IMM: calls.add(op.imm)
                if mn in ('ret', 'retn'): break
                a += i.size
        return ins, sorted(leaders), calls

    STR_OPS = {'stosd': 4, 'stosw': 2, 'stosb': 1, 'movsd': 4, 'movsw': 2, 'movsb': 1,
               'scasb': 1, 'scasd': 4, 'cmpsb': 1, 'cmpsd': 4, 'lodsb': 1, 'lodsd': 4}

    class _Strip:
        # instruction proxy without the LOCK prefix (single-threaded emulation of one task)
        def __init__(self, i, mn): self._i = i; self.mnemonic = mn
        def __getattr__(self, k): return getattr(self._i, k)

    # decision hooks (Stage 10 generic emitter, see emitter_control.py and gen_build10.py):
    #   addr -> ('pre', lua)                 statement executed before the instruction at addr
    #   addr -> ('branch', cond, target)     if cond then continue at target (same x87 depth, no live flags)
    hooks = {}

    def inst(self, i, lid):
        hk = self.hooks.get(i.address)
        if hk is not None:
            if hk[0] == 'pre': pre = [hk[1]]
            else: pre = ['if %s then pc = %d; continue end' % (hk[1], lid[hk[2]])]
            lines, term = self._inst(i, lid)
            return pre + lines, term
        return self._inst(i, lid)

    def _inst(self, i, lid):
        if i.mnemonic.startswith('lock '):
            i = Lifter10._Strip(i, i.mnemonic[5:])
        mn = i.mnemonic; ops = i.operands
        pre = None
        if i.prefix[0] in (0xf3, 0xf2):
            pre = 'rep' if i.prefix[0] == 0xf3 else 'repne'
        base = mn.split()[-1] if ' ' in mn else mn
        if base.startswith('rep'): base = base.split()[-1]
        if mn.startswith('rep'):
            parts = mn.split(); base = parts[-1]
            pre = {'rep': 'rep', 'repe': 'rep', 'repz': 'rep', 'repne': 'repne', 'repnz': 'repne'}[parts[0]]
        if base in self.STR_OPS and (ops == [] or all(o.type == X.X86_OP_MEM or o.type == X.X86_OP_REG for o in ops)):
            if base in ('movsd', 'cmpsd') and any(o.type == X.X86_OP_REG and o.reg in (X.X86_REG_XMM0,) for o in ops):
                raise LiftError('sse movsd')
            n = self.STR_OPS[base]; B = self.base
            rd = {1: 'r8b', 2: 'r16b', 4: 'ru'}[n]; wr = {1: 'w8b', 2: 'w16b', 4: 'wu'}[n]
            acc = {1: 'band(EAX, 0xff)', 2: 'band(EAX, 0xffff)', 4: 'EAX'}[n]
            if base.startswith('stos'): body = '%s(M, EDI - %d, %s); EDI = EDI + %d' % (wr, B, acc, n)
            elif base.startswith('movs'): body = '%s(M, EDI - %d, %s(M, ESI - %d)); EDI = EDI + %d; ESI = ESI + %d' % (wr, B, rd, B, n, n)
            elif base.startswith('lods'):
                body = ('EAX = bor(band(EAX, 0xffffff00), %s(M, ESI - %d)); ESI = ESI + %d' % (rd, B, n)) if n == 1 else \
                       ('EAX = %s(M, ESI - %d); ESI = ESI + %d' % (rd, B, n))
            elif base.startswith('scas'):
                body = 'do local a, b = %s, %s(M, EDI - %d); EDI = EDI + %d; FZ = a == b; FC = a < b; FS = band(a - b, %d) ~= 0; FO = false; FP = PAR[band(a - b, 0xff)] end' % (acc, rd, B, n, 1 << (8 * n - 1))
            else:  # cmps
                body = 'do local a, b = %s(M, ESI - %d), %s(M, EDI - %d); ESI = ESI + %d; EDI = EDI + %d; FZ = a == b; FC = a < b; FS = band(a - b, %d) ~= 0; FO = false; FP = PAR[band(a - b, 0xff)] end' % (rd, B, rd, B, n, n, 1 << (8 * n - 1))
            if pre is None: return [body], False
            if base.startswith(('stos', 'movs', 'lods')):
                return ['while ECX ~= 0 do %s; ECX = ECX - 1 end' % body], False
            stop = 'not FZ' if pre == 'rep' else 'FZ'
            return ['while ECX ~= 0 do %s; ECX = ECX - 1; if %s then break end end' % (body, stop)], False
        st = self.st
        consts = {'fldln2': '0.6931471805599453', 'fldl2e': '1.4426950408889634', 'fldl2t': '3.321928094887362',
                  'fldlg2': '0.3010299956639812', 'fldpi': '3.141592653589793'}
        if mn in consts: return [self.push(consts[mn])], False
        if mn == 'fyl2x': return ['%s = %s * (log(%s) / 0.6931471805599453)' % (st(1), st(1), st(0))], False
        if mn == 'f2xm1': return ['%s = 2 ^ %s - 1' % (st(0), st(0))], False
        if mn == 'fscale':
            return ['do local n = %s; if n >= 0 then n = floor(n) else n = -floor(-n) end; %s = %s * 2 ^ n end' % (st(1), st(0), st(0))], False
        if mn == 'ftst':
            return ['FSW = fcmp(%s, 0)' % st(0)], False
        if self.signed_zero_rtn:
            r = self.addsub_rtn(i, mn, ops)
            if r is not None: return r, False
        # byte index tables of two-level switches live in .text (below the Luau memory image): read them
        # from a constant Luau table emitted with the module
        if mn in ('mov', 'movzx') and len(ops) == 2 and ops[1].type == X.X86_OP_MEM and ops[1].size == 1:
            mm = ops[1].mem
            if 0x401000 <= (mm.disp & 0xffffffff) < self.base and (mm.base or mm.index) and not (mm.base and mm.index):
                reg = self.reg32(mm.base or mm.index)
                tbl = mm.disp & 0xffffffff
                if not hasattr(self, 'const_tables'): self.const_tables = {}
                n = 256
                self.const_tables[tbl] = self.read(tbl, n)
                return [self.wr(ops[0], 'CT_%06x[%s] or 0' % (tbl, reg))], False
        return Lifter.inst(self, i, lid)

    # round-toward-negative signed zero for x87 add/sub (enabled for the setup application lift, whose
    # outputs are compared bit for bit with the original; the Stage 6/7 runtime lift is unchanged)
    signed_zero_rtn = False
    def addsub_rtn(self, i, mn, ops):
        st = self.st
        ADD = {'fadd': (False, False), 'fsub': (True, False), 'fsubr': (True, True), 'faddp': (False, False),
               'fsubp': (True, False), 'fsubrp': (True, True), 'fiadd': (False, False), 'fisub': (True, False),
               'fisubr': (True, True)}
        if mn not in ADD: return None
        neg, rev = ADD[mn]
        if mn in ('faddp', 'fsubp', 'fsubrp'):
            k = self.stidx(ops[0]) if ops else 1
            dst, a, b = st(k), st(k), st(0)
        elif mn.startswith('fi'):
            op = ops[0]; fn = {2: 'ri16', 4: 'ri32'}[op.size]
            dst, a, b = st(0), st(0), self.acc(fn, op)
        elif len(ops) == 1:
            op = ops[0]
            if op.type == X.X86_OP_MEM: b = self.acc({4: 'rf32', 8: 'rf64'}[op.size], op)
            else: b = st(self.stidx(op))
            dst, a = st(0), st(0)
        else:
            kd, ks = self.stidx(ops[0]), self.stidx(ops[1])
            dst, a, b = st(kd), st(kd), st(ks)
        if rev: a, b = b, a
        if neg: return ['do local x, y = %s, -(%s); local r = x + y; if r == 0 then r = ZADD(x, y) end; %s = r end' % (a, b, dst)]
        return ['do local x, y = %s, %s; local r = x + y; if r == 0 then r = ZADD(x, y) end; %s = r end' % (a, b, dst)]

    def effect(self, f):
        """x87 stack effect of a call; recursive functions (the 005bd... IR compiler) are resolved by
        assuming 0 for the recursive edge and verifying the assumption afterwards."""
        if f in self.builtins:
            pin, pout = self.BUILTIN_FX.get(self.builtins[f], (0, 0)); return pout - pin
        self.fx = getattr(self, 'fx', {})
        self.assumed = getattr(self, 'assumed', set())
        if f in self.fx:
            if self.fx[f] is None:
                self.assumed.add(f); return 0
            return self.fx[f]
        self.fx[f] = None
        try:
            ins, leaders, calls = self.discover(f)
            _, r = self.depths(f, ins, leaders)
        except Exception:
            del self.fx[f]; raise
        if r not in (0, 1): raise LiftError('x87 return depth %d at %x' % (r, f))
        if f in self.assumed and r != 0: raise LiftError('recursive function %x has x87 effect %d' % (f, r))
        self.fx[f] = r
        return r

    def lift(self, entry):
        """Lifter.lift starts at pc 0 = the lowest leader; functions that jump into code placed before
        their entry (0055e9b0 tail-shares a block of the preceding function) must start at the entry."""
        if entry in self.funcs or entry in self.builtins: return []
        r = Lifter.lift(self, entry)
        ins, leaders, calls = self.discover(entry)
        start = sorted(leaders).index(entry)
        if start:
            body = self.funcs[entry]
            assert body[1] == 'local pc = 0'
            body[1] = 'local pc = %d' % start
        return r
