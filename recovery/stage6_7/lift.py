"""Static x86-32 -> Luau lifter for the NR2003.exe native functions called by the vehicle JIT code.
Every lifted function keeps the original instruction order. State is global (registers EAX..EDI,
ESP, EBP as uint32 numbers; x87 stack array F/FT; status word FSW; integer flags), memory is one
Luau buffer `M` addressed as (addr - BASE). Float stores round toward -inf (game CW 0x077f);
FIST rounds toward -inf. x87 arithmetic is evaluated in IEEE double (documented approximation of
64-bit extended precision)."""
import os, sys
from pathlib import Path
HERE = Path(__file__).resolve().parent
import sys, re
sys.path.insert(0, os.environ.get('CAPSTONE_PY', '/home/claude/tools/capstone/bindings/python'))
import capstone
from capstone import x86 as X

R32 = {X.X86_REG_EAX: 'EAX', X.X86_REG_EBX: 'EBX', X.X86_REG_ECX: 'ECX', X.X86_REG_EDX: 'EDX',
       X.X86_REG_ESI: 'ESI', X.X86_REG_EDI: 'EDI', X.X86_REG_ESP: 'ESP', X.X86_REG_EBP: 'EBP'}
R8 = {X.X86_REG_AL: ('EAX', 0), X.X86_REG_AH: ('EAX', 8), X.X86_REG_BL: ('EBX', 0), X.X86_REG_BH: ('EBX', 8),
      X.X86_REG_CL: ('ECX', 0), X.X86_REG_CH: ('ECX', 8), X.X86_REG_DL: ('EDX', 0), X.X86_REG_DH: ('EDX', 8)}
R16 = {X.X86_REG_AX: 'EAX', X.X86_REG_BX: 'EBX', X.X86_REG_CX: 'ECX', X.X86_REG_DX: 'EDX',
       X.X86_REG_SI: 'ESI', X.X86_REG_DI: 'EDI', X.X86_REG_BP: 'EBP'}
STR = [X.X86_REG_ST0, X.X86_REG_ST1, X.X86_REG_ST2, X.X86_REG_ST3, X.X86_REG_ST4, X.X86_REG_ST5, X.X86_REG_ST6, X.X86_REG_ST7]

class LiftError(Exception):
    pass

class Lifter:
    def __init__(self, read, builtins, base):
        self.read = read           # read(addr, n) -> bytes
        self.builtins = builtins   # addr -> lua function name (hand semantics)
        self.base = base
        self.md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32); self.md.detail = True
        self.funcs = {}            # addr -> list of lua lines
        self.indirect_sites = []   # (func, addr, text)

    def decode(self, a):
        i = next(self.md.disasm(self.read(a, 16), a), None)
        if i is None: raise LiftError('cannot decode %x' % a)
        return i

    def jump_table(self, i, prev):
        """MSVC switch: cmp REG, N / ja default / jmp [REG*4 + table] -> list of N+1 targets"""
        op = i.operands[0]
        m = op.mem
        if op.type != X.X86_OP_MEM or m.base or not m.index or m.scale != 4: return None
        if len(prev) < 2: return None
        c, j = prev[-2], prev[-1]
        if j.mnemonic != 'ja' or c.mnemonic != 'cmp': return None
        if c.operands[0].type != X.X86_OP_REG or c.operands[0].reg != m.index or c.operands[1].type != X.X86_OP_IMM: return None
        n = c.operands[1].imm + 1
        data = self.read(m.disp & 0xffffffff, 4 * n)
        return self.reg32(m.index), [int.from_bytes(data[4 * k:4 * k + 4], 'little') for k in range(n)]

    def discover(self, entry):
        ins = {}; leaders = {entry}; work = [entry]; calls = set()
        self.jtables = getattr(self, 'jtables', {})
        while work:
            a = work.pop(); prev = []
            while a not in ins:
                i = self.decode(a); ins[a] = i; mn = i.mnemonic
                if mn == 'jmp' and i.operands[0].type == X.X86_OP_MEM:
                    ends = {x.address + x.size: x for x in ins.values()}
                    j = ends.get(a); c = ends.get(j.address) if j else None
                    jt = self.jump_table(i, [c, j] if c and j else prev)
                    if jt is None: raise LiftError('indirect jump at %x' % a)
                    self.jtables[a] = jt
                    for t in jt[1]: leaders.add(t); work.append(t)
                    break
                prev.append(i)
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

    # ---------------------------------------------------------------- inline memory accessors
    READ_INLINE = {'r8': 'r8b', 'r16': 'r16b', 'r32': 'ru', 'rf32': 'rf', 'rf64': 'rf64b', 'ri16': 'ri16b', 'ri32': 'ri'}
    def addr_off(self, op):
        """(address - BASE) of a memory operand; no 32-bit wrap (valid NR2003 addresses never wrap)"""
        m = op.mem
        parts = []
        if m.base: parts.append(self.reg32(m.base))
        if m.index: parts.append('%s*%d' % (self.reg32(m.index), m.scale) if m.scale != 1 else self.reg32(m.index))
        c = (m.disp if parts else (m.disp & 0xffffffff)) - self.base
        if not parts: return str(c)
        if parts not in (['ESP'], ['EBP']):
            # general registers may hold wrapped (negative) offsets: keep the 32-bit wrap
            e = ' + '.join(parts)
            if m.disp: e += ' + %d' % m.disp
            return 'band(%s) - %d' % (e, self.base)
        e = ' + '.join(parts)
        if c > 0: e += ' + %d' % c
        elif c < 0: e += ' - %d' % -c
        return e
    def acc(self, fn, op, val=None):
        """memory access with the buffer builtins inlined (Luau fastcalls)"""
        if val is None:
            if fn in self.READ_INLINE: return '%s(M, %s)' % (self.READ_INLINE[fn], self.addr_off(op))
            return '%s(%s)' % (fn, self.ea(op))
        o = self.addr_off(op)
        if fn == 'w8': return 'w8b(M, %s, band(%s, 0xff))' % (o, val)
        if fn == 'w16': return 'w16b(M, %s, band(%s, 0xffff))' % (o, val)
        if fn == 'w32':
            v = val if (re.fullmatch(r'E[A-Z]{2}|\d+|r|v', val)) else 'band(%s)' % val
            return 'wu(M, %s, %s)' % (o, v)
        if fn == 'wf32d': return 'wfd(%s, %s)' % (o, val)
        if fn == 'wf64': return 'wf64b(M, %s, %s)' % (o, val)
        if fn == 'wi32': return 'wi(M, %s, %s)' % (o, val)
        return '%s(%s, %s)' % (fn, self.ea(op), val)

    # ---------------------------------------------------------------- operand helpers
    def ea(self, op):
        m = op.mem
        parts = []
        if m.base: parts.append(self.reg32(m.base))
        if m.index:
            parts.append('%s*%d' % (self.reg32(m.index), m.scale) if m.scale != 1 else self.reg32(m.index))
        if m.disp or not parts: parts.append(str(m.disp & 0xffffffff if not parts else m.disp))
        e = ' + '.join(parts)
        if m.base or m.index: e = 'band(%s)' % e
        return e

    def reg32(self, r):
        if r in R32: return R32[r]
        raise LiftError('reg %d' % r)

    def rd(self, op, signed=False):
        """integer read of an operand"""
        if op.type == X.X86_OP_REG:
            r = op.reg
            if r in R32: return R32[r]
            if r in R8:
                n, sh = R8[r]; return 'band(rshift(%s, %d), 0xff)' % (n, sh) if sh else 'band(%s, 0xff)' % n
            if r in R16: return 'band(%s, 0xffff)' % R16[r]
            raise LiftError('reg read %d' % r)
        if op.type == X.X86_OP_IMM:
            return str(op.imm & ((1 << (8 * op.size)) - 1))
        if op.type == X.X86_OP_MEM:
            fn = {1: 'r8', 2: 'r16', 4: 'r32'}[op.size]
            return self.acc(fn, op)
        raise LiftError('operand')

    def wr(self, op, val):
        if op.type == X.X86_OP_REG:
            r = op.reg
            if r in R32: return '%s = %s' % (R32[r], val)
            if r in R8:
                n, sh = R8[r]
                if sh: return '%s = bor(band(%s, 0xffff00ff), lshift(band(%s, 0xff), 8))' % (n, n, val)
                return '%s = bor(band(%s, 0xffffff00), band(%s, 0xff))' % (n, n, val)
            if r in R16:
                n = R16[r]; return '%s = bor(band(%s, 0xffff0000), band(%s, 0xffff))' % (n, n, val)
            raise LiftError('reg write %d' % r)
        if op.type == X.X86_OP_MEM:
            fn = {1: 'w8', 2: 'w16', 4: 'w32'}[op.size]
            return self.acc(fn, op, val)
        raise LiftError('write operand')

    def stidx(self, op):
        return STR.index(op.reg)

    # ---------------------------------------------------------------- lifting
    # ---------------------------------------------------------------- static x87 stack depth
    # MSVC code keeps the x87 stack depth static per instruction; slots become Lua locals s0..s7
    # (ST(i) = s[d-1-i]). Values cross function boundaries only through the global F stack
    # (float returns, builtin arguments), exactly where the original passes them in ST registers.
    BUILTIN_FX = {'B_ftol': (1, 0), 'B_pow': (2, 1)}   # (popped inputs, pushed outputs)
    X87_DELTA = {'fld': 1, 'fild': 1, 'fldz': 1, 'fld1': 1, 'fstp': -1, 'fistp': -1, 'faddp': -1, 'fsubp': -1,
                 'fmulp': -1, 'fdivp': -1, 'fsubrp': -1, 'fdivrp': -1, 'fsincos': 1, 'fpatan': -1,
                 'fcomp': -1, 'fucomp': -1, 'fcompp': -2, 'fucompp': -2}
    def call_effect(self, i):
        op = i.operands[0]
        if op.type != X.X86_OP_IMM: return 0           # indirect (vtable) targets: checked in effect()
        t = op.imm
        if t in self.builtins:
            pin, pout = self.BUILTIN_FX.get(self.builtins[t], (0, 0)); return pout - pin
        return self.effect(t)
    def depths(self, entry, ins, leaders):
        d = {entry: 0}; work = [entry]; ret = set()
        lset = set(leaders)
        while work:
            a = work.pop(); cur = a; depth = d[a]
            while True:
                i = ins[cur]; mn = i.mnemonic
                if mn == 'call': nd = depth + self.call_effect(i)
                else: nd = depth + self.X87_DELTA.get(mn, 0)
                if nd < 0 or nd > 8: raise LiftError('x87 depth %d at %x' % (nd, cur))
                succ = []
                if mn == 'jmp' and cur in self.jtables: succ = list(self.jtables[cur][1])
                elif mn == 'jmp': succ = [i.operands[0].imm]
                elif mn.startswith('j'): succ = [i.operands[0].imm, cur + i.size]
                elif mn in ('ret', 'retn'): ret.add(depth); succ = []
                else:
                    nxt = cur + i.size
                    if nxt in lset: succ = [nxt]
                    else:
                        if nxt in d and d[nxt] != nd: raise LiftError('x87 depth merge at %x' % nxt)
                        d[nxt] = nd; cur = nxt; depth = nd; continue
                for t in succ:
                    if t in d:
                        if d[t] != nd: raise LiftError('x87 depth merge %d/%d at %x' % (d[t], nd, t))
                    else: d[t] = nd; work.append(t)
                break
        if len(ret) > 1: raise LiftError('x87 depth differs at returns of %x: %s' % (entry, ret))
        return d, (ret.pop() if ret else 0)
    def effect(self, f):
        if f in self.builtins:
            pin, pout = self.BUILTIN_FX.get(self.builtins[f], (0, 0)); return pout - pin
        self.fx = getattr(self, 'fx', {})
        if f in self.fx:
            if self.fx[f] is None: raise LiftError('recursive x87 effect at %x' % f)
            return self.fx[f]
        self.fx[f] = None
        ins, leaders, calls = self.discover(f)
        _, r = self.depths(f, ins, leaders)
        if r not in (0, 1): raise LiftError('x87 return depth %d at %x' % (r, f))
        self.fx[f] = r
        return r

    def lift(self, entry):
        if entry in self.funcs or entry in self.builtins: return []
        self.effect(entry)
        ins, leaders, calls = self.discover(entry)
        self.need = self.flag_liveness(ins, leaders)
        self.dmap, _ = self.depths(entry, ins, leaders)
        blocks = {}
        order = sorted(ins)
        lid = {a: k for k, a in enumerate(leaders)}
        out = []
        out.append('F_%06x = function()' % entry)
        out.append('local pc = 0')
        out.append('local s0, s1, s2, s3, s4, s5, s6, s7')
        out.append('while true do')
        first = True
        for a in leaders:
            out.append('%s pc == %d then' % ('if' if first else 'elseif', lid[a]))
            first = False
            cur = a
            while True:
                i = ins[cur]
                self.d = self.dmap[cur]
                lines, term = self.inst(i, lid)
                out.extend(lines)
                if term: break
                nxt = cur + i.size
                if nxt in lid:
                    out.append('pc = %d' % lid[nxt]); break
                cur = nxt
        out.append('end')
        out.append('end')
        out.append('end')
        self.funcs[entry] = out
        return [c for c in calls if c not in self.funcs and c not in self.builtins]

    def st(self, k):
        j = self.d - 1 - k
        if j < 0: raise LiftError('x87 underflow')
        return 's%d' % j
    def push(self, expr):
        return 's%d = %s' % (self.d, expr)

    JCC = {'je': 'Z', 'jne': 'Z', 'jg': 'ZSO', 'jge': 'SO', 'jl': 'SO', 'jle': 'ZSO', 'ja': 'CZ', 'jae': 'C',
           'jb': 'C', 'jbe': 'CZ', 'js': 'S', 'jns': 'S', 'jp': 'P', 'jnp': 'P'}
    def flag_effect(self, i):
        """(uses, defs) as sets of flag letters; defs = flags unconditionally overwritten"""
        mn = i.mnemonic; ALL = set('CZSOP')
        if mn.startswith('j') and mn != 'jmp': return set(self.JCC[mn]), set()
        if mn.startswith('set'): return set(self.JCC['j' + mn[3:]]), set()
        if mn in ('adc', 'sbb'): return {'C'}, ALL
        if mn in ('add', 'sub', 'cmp', 'neg', 'and', 'or', 'xor', 'test'): return set(), ALL
        if mn in ('inc', 'dec'): return set(), set('ZSOP')
        if mn == 'sahf': return set(), set('CPZS')
        if mn in ('shl', 'shr', 'sar'):
            ops = i.operands
            if len(ops) < 2 or (ops[1].type == X.X86_OP_IMM and (ops[1].imm & 31) != 0): return set(), ALL
            return set(), set()           # count may be zero: flags preserved -> pass-through
        if mn in ('call', 'ret', 'retn'): return set(), ALL   # MSVC: flags never live across call/ret
        return set(), set()

    def flag_liveness(self, ins, leaders):
        lset = set(leaders)
        blocks = {}
        for a in leaders:
            seq = []; cur = a
            while True:
                i = ins[cur]; seq.append(i); mn = i.mnemonic
                if mn.startswith('j') or mn in ('ret', 'retn'): break
                nxt = cur + i.size
                if nxt in lset: break
                cur = nxt
            last = seq[-1]; mn = last.mnemonic; succ = []
            if mn == 'jmp' and last.address in self.jtables: succ = list(self.jtables[last.address][1])
            elif mn == 'jmp': succ = [last.operands[0].imm]
            elif mn.startswith('j'): succ = [last.operands[0].imm, last.address + last.size]
            elif mn in ('ret', 'retn'): succ = []
            else: succ = [last.address + last.size]
            blocks[a] = (seq, succ)
        live_in = {a: set() for a in leaders}
        changed = True
        while changed:
            changed = False
            for a in reversed(leaders):
                seq, succ = blocks[a]
                live = set()
                for b in succ: live |= live_in.get(b, set('CZSOP'))
                for i in reversed(seq):
                    u, d = self.flag_effect(i)
                    live = (live - d) | u
                if live != live_in[a]: live_in[a] = live; changed = True
        need = {}
        for a in leaders:
            seq, succ = blocks[a]
            live = set()
            for b in succ: live |= live_in.get(b, set('CZSOP'))
            for i in reversed(seq):
                need[i.address] = set(live)
                u, d = self.flag_effect(i)
                live = (live - d) | u
        return need

    def flags(self, i, assigns):
        """keep only the flag assignments whose flag is live after instruction i"""
        need = self.need.get(i.address, set('CZSOP'))
        return [x for f, x in assigns if f in need]

    def setflags_logic(self, res, size=4):
        m = (1 << (8 * size)) - 1
        top = 1 << (8 * size - 1)
        return ['FR = band(%s, %d)' % (res, m), 'FZ = FR == 0', 'FS = band(FR, %d) ~= 0' % top,
                'FC = false', 'FO = false', 'FP = PAR[band(FR, 0xff)]']

    def inst(self, i, lid):
        mn = i.mnemonic; ops = i.operands; L = []
        def term_jump(target):
            return 'pc = %d' % lid[target]
        # ---------------- control
        if mn == 'jmp' and i.address in self.jtables:
            reg, targets = self.jtables[i.address]
            parts = ['%s t == %d then pc = %d' % ('if' if k == 0 else 'elseif', k, lid[t]) for k, t in enumerate(targets)]
            return ['do local t = %s' % reg] + parts + ['else error("NR2003 lift: switch index out of range") end end'], True
        if mn == 'jmp':
            return [term_jump(ops[0].imm)], True
        if mn.startswith('j'):
            cond = {'je': 'FZ', 'jne': 'not FZ', 'jg': '(not FZ and FS == FO)', 'jge': '(FS == FO)',
                    'jl': '(FS ~= FO)', 'jle': '(FZ or FS ~= FO)', 'ja': '(not FC and not FZ)', 'jae': 'not FC',
                    'jb': 'FC', 'jbe': '(FC or FZ)', 'js': 'FS', 'jns': 'not FS', 'jp': 'FP', 'jnp': 'not FP'}.get(mn)
            if cond is None: raise LiftError('jcc %s at %x' % (mn, i.address))
            return ['if %s then pc = %d else pc = %d end' % (cond, lid[ops[0].imm], lid[i.address + i.size])], True
        if mn == 'ret':
            n = ops[0].imm if ops else 0
            pre = ['FT = FT + 1; F[FT] = s0'] if self.d == 1 else []   # float return in ST0
            return pre + ['ESP = ESP + %d' % (4 + n), 'do return end'], True
        if mn == 'call':
            op = ops[0]
            if op.type == X.X86_OP_IMM:
                t = op.imm
                fn = self.builtins.get(t, 'F_%06x' % t)
                L = []
                if t in self.builtins:
                    pin, pout = self.BUILTIN_FX.get(fn, (0, 0))
                    for k in range(pin - 1, -1, -1): L.append('FT = FT + 1; F[FT] = %s' % self.st(k))
                    L += ['ESP = ESP - 4', '%s()' % fn]   # return-address slot (value never read)
                    base = self.d - pin
                    for k in range(pout): L.append('s%d = F[FT]; FT = FT - 1' % (base + pout - 1 - k))
                    return L, False
                L += ['ESP = ESP - 4', '%s()' % fn]
                if self.effect(t) == 1: L.append('s%d = F[FT]; FT = FT - 1' % self.d)
                return L, False
            tgt = self.rd(op)
            self.indirect_sites.append((i.address, i.op_str))
            return ['ESP = ESP - 4', 'ICALL(%s)' % tgt], False
        # ---------------- integer
        if mn == 'mov':
            return [self.wr(ops[0], self.rd(ops[1]))], False
        if mn in ('movzx',):
            return [self.wr(ops[0], self.rd(ops[1]))], False
        if mn == 'movsx':
            sz = ops[1].size; v = self.rd(ops[1])
            return [self.wr(ops[0], 'sx%d(%s)' % (8 * sz, v))], False
        if mn == 'lea':
            return [self.wr(ops[0], self.ea(ops[1]))], False
        if mn == 'push':
            v = self.rd(ops[0])
            if re.fullmatch(r'E[A-Z]{2}|\d+', v): return ['ESP = ESP - 4; wu(M, ESP - %d, %s)' % (self.base, v)], False
            return ['do local v = %s; ESP = ESP - 4; wu(M, ESP - %d, band(v)) end' % (v, self.base)], False
        if mn == 'pop':
            if ops[0].type == X.X86_OP_REG and ops[0].reg in R32 and ops[0].reg != X.X86_REG_ESP:
                return ['%s = ru(M, ESP - %d); ESP = ESP + 4' % (R32[ops[0].reg], self.base)], False
            return ['do local v = ru(M, ESP - %d); ESP = ESP + 4; %s end' % (self.base, self.wr(ops[0], 'v'))], False
        if mn in ('add', 'sub', 'cmp', 'adc', 'sbb'):
            sz = ops[0].size; m = (1 << (8 * sz)) - 1; top = 1 << (8 * sz - 1)
            a = self.rd(ops[0]); b = self.rd(ops[1]) if ops[1].type != X.X86_OP_IMM else str(ops[1].imm & m)
            need = self.need.get(i.address, set('CZSOP'))
            if mn == 'cmp' and not need: return [], False
            if not need and mn in ('add', 'sub'):
                op_ = '+' if mn == 'add' else '-'
                if ops[0].type == X.X86_OP_REG and ops[0].reg == X.X86_REG_ESP and ops[1].type == X.X86_OP_IMM:
                    return ['ESP = ESP %s %s' % (op_, b)], False      # stack pointer never wraps
                if sz == 4: return [self.wr(ops[0], 'band(%s %s %s)' % (a, op_, b))], False
            L.append('do local a, b = %s, %s' % (a, b))
            if mn in ('add', 'adc'):
                L.append('local r = a + b%s' % (' + (FC and 1 or 0)' if mn == 'adc' else ''))
                if 'C' in need: L.append('FC = r > %d' % m)
                L.append('r = band(r)' if m == 0xffffffff else 'r = band(r, %d)' % m)
                if 'O' in need: L.append('FO = band(bnot(bxor(a, b)), bxor(a, r), %d) ~= 0' % top)
            else:
                L.append('local r = a - b%s' % (' - (FC and 1 or 0)' if mn == 'sbb' else ''))
                if 'C' in need: L.append('FC = r < 0')
                L.append('r = band(r)' if m == 0xffffffff else 'r = band(r, %d)' % m)
                if 'O' in need: L.append('FO = band(bxor(a, b), bxor(a, r), %d) ~= 0' % top)
            L += self.flags(i, [('Z', 'FZ = r == 0'), ('S', 'FS = band(r, %d) ~= 0' % top), ('P', 'FP = PAR[band(r, 0xff)]')])
            if mn != 'cmp': L.append(self.wr(ops[0], 'r'))
            L.append('end')
            return L, False
        if mn in ('and', 'or', 'xor', 'test'):
            sz = ops[0].size; top = 1 << (8 * sz - 1)
            fn = {'and': 'band', 'test': 'band', 'or': 'bor', 'xor': 'bxor'}[mn]
            need = self.need.get(i.address, set('CZSOP'))
            if not need and mn != 'test':
                if mn == 'xor' and ops[0].type == X.X86_OP_REG and ops[1].type == X.X86_OP_REG and ops[0].reg == ops[1].reg:
                    return [self.wr(ops[0], '0')], False
                return [self.wr(ops[0], 'band(%s(%s, %s), %d)' % (fn, self.rd(ops[0]), self.rd(ops[1]), (1 << (8 * sz)) - 1))], False
            if mn == 'test' and not need: return [], False
            if mn == 'xor' and ops[0].type == X.X86_OP_REG and ops[1].type == X.X86_OP_REG and ops[0].reg == ops[1].reg:
                L.append('do local r = 0')
            else:
                L.append('do local r = band(%s(%s, %s), %d)' % (fn, self.rd(ops[0]), self.rd(ops[1]), (1 << (8 * sz)) - 1))
            L += self.flags(i, [('Z', 'FZ = r == 0'), ('S', 'FS = band(r, %d) ~= 0' % top), ('C', 'FC = false'),
                                ('O', 'FO = false'), ('P', 'FP = PAR[band(r, 0xff)]')])
            if mn != 'test': L.append(self.wr(ops[0], 'r'))
            L.append('end')
            return L, False
        if mn in ('inc', 'dec'):
            sz = ops[0].size; m = (1 << (8 * sz)) - 1; top = 1 << (8 * sz - 1)
            d = '+ 1' if mn == 'inc' else '- 1'
            L.append('do local a = %s; local r = band(a %s, %d)' % (self.rd(ops[0]), d, m))
            L += self.flags(i, [('O', 'FO = r == %d' % top if mn == 'inc' else 'FO = a == %d' % top), ('Z', 'FZ = r == 0'),
                                ('S', 'FS = band(r, %d) ~= 0' % top), ('P', 'FP = PAR[band(r, 0xff)]')])
            L.append(self.wr(ops[0], 'r')); L.append('end')
            return L, False
        if mn == 'neg':
            sz = ops[0].size; m = (1 << (8 * sz)) - 1; top = 1 << (8 * sz - 1)
            L.append('do local a = %s; local r = band(-a, %d)' % (self.rd(ops[0]), m))
            L += self.flags(i, [('C', 'FC = a ~= 0'), ('O', 'FO = a == %d' % top), ('Z', 'FZ = r == 0'),
                                ('S', 'FS = band(r, %d) ~= 0' % top), ('P', 'FP = PAR[band(r, 0xff)]')])
            L.append(self.wr(ops[0], 'r')); L.append('end')
            return L, False
        if mn == 'not':
            sz = ops[0].size; m = (1 << (8 * sz)) - 1
            return [self.wr(ops[0], 'band(bnot(%s), %d)' % (self.rd(ops[0]), m))], False
        if mn in ('shl', 'shr', 'sar'):
            sz = ops[0].size; m = (1 << (8 * sz)) - 1; top = 1 << (8 * sz - 1)
            cnt = self.rd(ops[1]) if len(ops) > 1 else '1'
            fn = {'shl': 'lshift', 'shr': 'rshift', 'sar': 'arshift'}[mn]
            L.append('do local n = band(%s, 31)' % cnt)
            L.append('if n ~= 0 then local a = %s' % self.rd(ops[0]))
            if mn == 'shl': L.append('FC = band(rshift(a, %d - n), 1) ~= 0' % (8 * sz))
            else: L.append('FC = band(rshift(a, n - 1), 1) ~= 0')
            if sz != 4 and mn == 'sar': raise LiftError('sar size')
            L.append('local r = band(%s(a, n), %d)' % (fn, m))
            L.append('FR = r; FZ = r == 0; FS = band(r, %d) ~= 0; FP = PAR[band(r, 0xff)]; FO = false' % top)
            L.append(self.wr(ops[0], 'r'))
            L.append('end end')
            return L, False
        if mn == 'imul':
            if len(ops) == 3:
                L.append('%s' % self.wr(ops[0], 'imul32(%s, %s)' % (self.rd(ops[1]), self.rd(ops[2]))))
            elif len(ops) == 2:
                L.append('%s' % self.wr(ops[0], 'imul32(%s, %s)' % (self.rd(ops[0]), self.rd(ops[1]))))
            else: raise LiftError('imul1')
            return L, False
        if mn in ('idiv', 'div'):
            src = self.rd(ops[0])
            if ops[0].size != 4: raise LiftError('div size')
            if mn == 'idiv':
                L.append('do local d = %s; if d >= 2147483648 then d = d - 4294967296 end' % src)
                L.append('local hi = EDX; if hi >= 2147483648 then hi = hi - 4294967296 end')
            else:
                L.append('do local d = %s; local hi = EDX' % src)
            L.append('local n = hi * 4294967296 + EAX')
            L.append('if d == 0 then error("NR2003 lift: integer divide by zero") end')
            L.append('local q = n / d; if q >= 0 then q = floor(q) else q = -floor(-q) end')
            L.append('local r = n - q * d')
            L.append('EAX = band(q); EDX = band(r) end')
            return L, False
        if mn == 'cdq':
            return ['EDX = band(EAX, 0x80000000) ~= 0 and 0xffffffff or 0'], False
        if mn.startswith('set'):
            cond = {'sete': 'FZ', 'setne': 'not FZ', 'setg': '(not FZ and FS == FO)', 'setl': '(FS ~= FO)',
                    'setge': '(FS == FO)', 'setle': '(FZ or FS ~= FO)', 'seta': '(not FC and not FZ)',
                    'setb': 'FC', 'setae': 'not FC', 'setbe': '(FC or FZ)'}.get(mn)
            if not cond: raise LiftError(mn)
            return [self.wr(ops[0], '(%s) and 1 or 0' % cond)], False
        if mn == 'nop':
            return [], False
        if mn == 'sahf':
            return ['do local ah = band(rshift(EAX, 8), 0xff); FC = band(ah, 1) ~= 0; FP = band(ah, 4) ~= 0; FZ = band(ah, 0x40) ~= 0; FS = band(ah, 0x80) ~= 0 end'], False
        # ---------------- x87 (static depth: st(k) are Lua locals)
        st = self.st
        if mn == 'fld':
            op = ops[0]
            if op.type == X.X86_OP_REG: return [self.push(st(self.stidx(op)))], False
            fn = {4: 'rf32', 8: 'rf64'}.get(op.size)
            if not fn: raise LiftError('fld size %d at %x' % (op.size, i.address))
            return [self.push(self.acc(fn, op))], False
        if mn in ('fild',):
            op = ops[0]; fn = {2: 'ri16', 4: 'ri32', 8: 'ri64'}[op.size]
            return [self.push(self.acc(fn, op))], False
        if mn == 'fldz': return [self.push('0')], False
        if mn == 'fld1': return [self.push('1')], False
        if mn in ('fst', 'fstp'):
            op = ops[0]
            if op.type == X.X86_OP_REG:
                k = self.stidx(op)
                if k: L.append('%s = %s' % (st(k), st(0)))
            else:
                fn = {4: 'wf32d', 8: 'wf64'}.get(op.size)
                if not fn: raise LiftError('fst size')
                L.append(self.acc(fn, op, st(0)))
            return L, False
        if mn in ('fist', 'fistp'):
            op = ops[0]; fn = {4: 'wi32', 8: 'wi64', 2: 'wi16'}[op.size]
            L.append(self.acc(fn, op, 'fistround(%s)' % st(0)))
            return L, False
        bin_ = {'fadd': '+', 'fsub': '-', 'fmul': '*', 'fdiv': '/'}
        if mn in bin_ or mn in ('fsubr', 'fdivr'):
            def comb(dst, a, b):
                if mn in bin_: return '%s = %s %s %s' % (dst, a, bin_[mn], b)
                if mn == 'fsubr': return '%s = %s - %s' % (dst, b, a)
                return '%s = %s / %s' % (dst, b, a)
            if len(ops) == 1:
                op = ops[0]
                if op.type == X.X86_OP_MEM:
                    fn = {4: 'rf32', 8: 'rf64'}[op.size]
                    return [comb(st(0), st(0), self.acc(fn, op))], False
                k = self.stidx(op)
                return [comb(st(0), st(0), st(k))], False
            dd, ss = ops
            kd, ks = self.stidx(dd), self.stidx(ss)
            return [comb(st(kd), st(kd), st(ks))], False
        if mn in ('faddp', 'fsubp', 'fmulp', 'fdivp', 'fsubrp', 'fdivrp'):
            k = self.stidx(ops[0]) if ops else 1
            t, v = st(k), st(0)
            e = {'faddp': '%s + %s' % (t, v), 'fsubp': '%s - %s' % (t, v), 'fmulp': '%s * %s' % (t, v),
                 'fdivp': '%s / %s' % (t, v), 'fsubrp': '%s - %s' % (v, t), 'fdivrp': '%s / %s' % (v, t)}[mn]
            return ['%s = %s' % (t, e)], False
        if mn in ('fiadd', 'fisub', 'fimul', 'fidiv', 'fisubr', 'fidivr'):
            op = ops[0]; fn = {2: 'ri16', 4: 'ri32'}[op.size]
            v = self.acc(fn, op); x = st(0)
            e = {'fiadd': '%s + %s' % (x, v), 'fisub': '%s - %s' % (x, v), 'fimul': '%s * %s' % (x, v),
                 'fidiv': '%s / %s' % (x, v), 'fisubr': '%s - %s' % (v, x), 'fidivr': '%s / %s' % (v, x)}[mn]
            return ['%s = %s' % (x, e)], False
        if mn == 'fxch':
            k = self.stidx(ops[-1]) if ops else 1   # capstone lists (st(0), st(i))
            return ['%s, %s = %s, %s' % (st(0), st(k), st(k), st(0))], False
        if mn == 'fchs': return ['%s = -%s' % (st(0), st(0))], False
        if mn == 'fabs': return ['%s = abs(%s)' % (st(0), st(0))], False
        if mn == 'fsqrt': return ['%s = sqrt(%s)' % (st(0), st(0))], False
        if mn == 'fsin': return ['%s = sin(%s)' % (st(0), st(0))], False
        if mn == 'fcos': return ['%s = cos(%s)' % (st(0), st(0))], False
        if mn == 'fsincos': return ['do local x = %s; %s = sin(x); s%d = cos(x) end' % (st(0), st(0), self.d)], False
        if mn == 'fpatan': return ['%s = atan2(%s, %s)' % (st(1), st(1), st(0))], False
        if mn == 'fprem': return ['%s = fmod(%s, %s)' % (st(0), st(0), st(1))], False
        if mn == 'frndint': return ['%s = fistround(%s)' % (st(0), st(0))], False
        if mn in ('fcom', 'fcomp', 'fcompp', 'fucom', 'fucomp', 'fucompp'):
            if ops:
                op = ops[0]
                if op.type == X.X86_OP_MEM:
                    src = self.acc({4: 'rf32', 8: 'rf64'}[op.size], op)
                else: src = st(self.stidx(op))
            else: src = st(1)
            L.append('FSW = fcmp(%s, %s)' % (st(0), src))
            return L, False
        if mn in ('fnstsw', 'fstsw'):
            op = ops[0]
            if op.type == X.X86_OP_REG and op.reg == X.X86_REG_AX:
                return ['EAX = bor(band(EAX, 0xffff0000), FSW)'], False
            raise LiftError('fnstsw mem')
        if mn in ('fnstcw', 'fstcw'):
            return [self.wr(ops[0], 'FCW')], False
        if mn == 'fldcw':
            return ['FCW = %s' % self.rd(ops[0]), 'if band(FCW, 0xc00) ~= 0x400 then error("NR2003 lift: unsupported FPU rounding change") end'], False
        if mn in ('wait', 'fwait'): return [], False
        raise LiftError('unsupported %s %s at %x' % (mn, i.op_str, i.address))
