"""Stage 10 control of the ORIGINAL code emitter decisions (generic, setup-invariant callback structure).
FoldControl2: selective no-fold of the cell emitter, keyed by call context.
Decision sites: 0057c8d0 (constant == 0.0), 0057c900 (constant == 1.0), 0057ca60 (keep / share 0.0 / share
1.0 / new constant cell). Key = (kind, 3 code return addresses on the stack, cell-variable address,
occurrence). A forced key takes the 'no fold' outcome: predicate false, or a new constant cell."""
import struct, collections
from unicorn import *
from unicorn.x86_const import *

def _chain(uc):
    esp = uc.reg_read(UC_X86_REG_ESP)
    words = struct.unpack('<24I', uc.mem_read(esp, 96))
    return tuple([w for w in words if 0x401000 <= w < 0x6e9000][:3])

class FoldControl2:
    """forced keys take the no-fold outcome"""
    def __init__(self, m, force=()):
        self.m = m; self.force = set(force); self.on = False
        self.seq = []          # (key, decision) in call order
        self.natural = {}      # forced key -> decision the original would have taken
        self.occ = collections.Counter()
        uc = m.uc
        uc.hook_add(UC_HOOK_CODE, self._pred, begin=0x57c8d0, end=0x57c8d0)
        uc.hook_add(UC_HOOK_CODE, self._pred, begin=0x57c900, end=0x57c900)
        uc.hook_add(UC_HOOK_CODE, self._a, begin=0x57ca71, end=0x57ca71)
        for addr, tag in ((0x57cad4, 'z'), (0x57cb08, 'o'), (0x57cb12, 'n')):
            uc.hook_add(UC_HOOK_CODE, self._out(tag), begin=addr, end=addr)
        uc.ctl_flush_tb()      # Unicorn only instruments blocks translated after the hooks exist
    def key(self, uc, kind, p):
        base = (kind, _chain(uc), p)
        n = self.occ[base]; self.occ[base] += 1
        return base + (n,)
    def _pred(self, uc, addr, size, ud):
        if not self.on: return
        kind = 'z' if addr == 0x57c8d0 else 'o'
        esp = uc.reg_read(UC_X86_REG_ESP)
        p = struct.unpack('<I', uc.mem_read(esp + 4, 4))[0]
        cell = struct.unpack('<I', uc.mem_read(p, 4))[0]
        var = 0xebbf5f < cell < 0xebf610
        val = struct.unpack('<f', uc.mem_read(cell, 4))[0] if cell else None
        r = 1 if (not var and val == (0.0 if kind == 'z' else 1.0)) else 0
        k = self.key(uc, kind, p)
        if k in self.force:
            self.natural[k] = r; r = 0
        self.seq.append((k, r))
        ret = struct.unpack('<I', uc.mem_read(esp, 4))[0]
        uc.reg_write(UC_X86_REG_EAX, r); uc.reg_write(UC_X86_REG_ECX, p)
        uc.reg_write(UC_X86_REG_ESP, esp + 4); uc.reg_write(UC_X86_REG_EIP, ret)
    def _a(self, uc, addr, size, ud):
        if not self.on: return
        p = uc.reg_read(UC_X86_REG_ESI)
        k = self.key(uc, 'a', p)
        self.seq.append((k, 'k'))
        if k in self.force:
            esp = uc.reg_read(UC_X86_REG_ESP)
            value = struct.unpack('<f', uc.mem_read(esp + 0xc, 4))[0]
            cell = struct.unpack('<I', uc.mem_read(p, 4))[0]
            n = struct.unpack('<I', uc.mem_read(0xd47d60, 4))[0]
            var = 0xebbf5f < cell < 0xebf610
            promoted = 0
            if 0xd3b02f < cell < 0xd3fe50:
                promoted = struct.unpack('<I', uc.mem_read(0xd3fe50 + ((cell - 0xd3b030) & ~3), 4))[0]
            nat = 'n'
            if cell and (cell < 0xd3b030 + 4 * n or cell >= 0xd3fe50) and not var:
                if struct.unpack('<f', uc.mem_read(cell, 4))[0] == value: nat = 'k'
            if nat == 'n' and value == 0.0 and not var and not promoted: nat = 'z'
            elif nat == 'n' and value == 1.0 and not var and not promoted: nat = 'o'
            self.natural[k] = nat
            uc.reg_write(UC_X86_REG_EIP, 0x57cb12)
    def _out(self, tag):
        def h(uc, addr, size, ud):
            if self.on and self.seq and self.seq[-1][0][0] == 'a': self.seq[-1] = (self.seq[-1][0], tag)
        return h


class LiteralControl:
    """ORIGINAL JIT literal-pool intern 005b9970 (value-deduplicated constants at 0xebf614.., capacity up to
    the backend free list at 0xebfc7c). Outcome per call index: 'append' or ('m', j) = shares the literal
    appended by call j. 'follow' maps call index -> decision to impose ('append' or ('m', j))."""
    LIT, LIMIT = 0xebf610, 0xebfc7c
    def __init__(self, m, follow=None):
        self.m = m; self.follow = follow or {}; self.on = False; self.seq = []; self.owner = {}; self.addr_of = {}
        self.violations = []
        m.uc.hook_add(UC_HOOK_CODE, self._h, begin=0x5b9970, end=0x5b9970)
        m.uc.ctl_flush_tb()
    def _h(self, uc, addr, size, ud):
        if not self.on: return
        k = len(self.seq)
        esp = uc.reg_read(UC_X86_REG_ESP)
        ret = struct.unpack('<I', uc.mem_read(esp, 4))[0]
        bits = struct.unpack('<I', uc.mem_read(esp + 4, 4))[0]
        val = struct.unpack('<f', struct.pack('<I', bits))[0]
        top = struct.unpack('<I', uc.mem_read(0xec02c4, 4))[0]
        res = None; c = top - 4
        while c > self.LIT:
            v = struct.unpack('<f', uc.mem_read(c, 4))[0]
            if v == val: res = c; break
            c -= 4
        natural = 'append' if res is None else ('m', self.owner.get(res, 'pre'))
        self.seq.append(natural)
        want = self.follow.get(k, natural)
        if want == 'append':
            top += 4
            if top >= self.LIMIT: raise RuntimeError('literal pool overflow')
            uc.mem_write(0xec02c4, struct.pack('<I', top)); uc.mem_write(top, struct.pack('<I', bits))
            self.owner[top] = k; self.addr_of[k] = top; res = top
        else:
            j = want[1]
            a = self.addr_of[j]
            if struct.unpack('<f', uc.mem_read(a, 4))[0] != val: self.violations.append(('literal', k, j))
            res = a
            self.addr_of[k] = a
        uc.reg_write(UC_X86_REG_EAX, res); uc.reg_write(UC_X86_REG_ECX, c)
        uc.reg_write(UC_X86_REG_EDX, struct.unpack('<I', uc.mem_read(0xec02c4, 4))[0])
        uc.reg_write(UC_X86_REG_ESP, esp + 4); uc.reg_write(UC_X86_REG_EIP, ret)


def install(m, *controls):
    """switch the controls on for the 005b2f20 body only (57dcd0(0) .. 57dcd0(1)), like the original
    emitter session; returns the controls"""
    orig = m.call
    def pc(addr, *a, **k):
        if addr == 0x57dcd0 and a and a[0] == 0:
            for c in controls: c.on = True
        r = orig(addr, *a, **k)
        if addr == 0x57dcd0 and a and a[0] == 1:
            for c in controls: c.on = False
        return r
    m.call = pc
    return controls


def fold_table(seq, force):
    """global decision table of the generic structure, one character per emitter decision event:
       0057c8d0 (==0):  'Z' forced no-fold, '0' no fold, '1' fold
       0057c900 (==1):  'O' forced no-fold, '2' no fold, '3' fold
       0057ca60:        'N' forced new cell, 'n' new cell, 'k' keep, 'z' share 0.0, 'o' share 1.0"""
    out = []
    for key, d in seq:
        kind = key[0]; f = key in force
        if kind == 'z': out.append('Z' if f else ('1' if d else '0'))
        elif kind == 'o': out.append('O' if f else ('3' if d else '2'))
        else: out.append('N' if f else d)
    return ''.join(out)


class TableControl:
    """Unicorn mirror of the Luau build policy (gen_build10.py G_* hooks): decisions by GLOBAL event index.
    fold: fold_table() string; lit_append[k]: True = append, lit_addr[k]: address the literal call returns.
    No-fold outcomes ('0','2','Z','O','n','N', append) are imposed (always representable: the generic code
    computes with the explicit value); fold outcomes ('1','3','k','z','o', share) must be the natural outcome
    of the setup, otherwise the setup is outside the generic structure (violation)."""
    LIT, LIMIT = 0xebf610, 0xebfc7c
    def __init__(self, m, fold, lit_append, lit_addr, strict=False):
        """strict=True (NATURAL structure tables): every outcome must be the setup's natural outcome, nothing
        is imposed (the setup's original code is then identical to the reference code)"""
        self.m = m; self.fold = fold; self.lit_append = lit_append; self.lit_addr = lit_addr; self.strict = strict
        self.on = False; self.fk = 0; self.lk = 0; self.violations = []; self.imposed = 0
        self.astack = []
        uc = m.uc
        uc.hook_add(UC_HOOK_CODE, self._pred, begin=0x57c8d0, end=0x57c8d0)
        uc.hook_add(UC_HOOK_CODE, self._pred, begin=0x57c900, end=0x57c900)
        uc.hook_add(UC_HOOK_CODE, self._a, begin=0x57ca71, end=0x57ca71)
        for addr, tag in ((0x57cad4, 'z'), (0x57cb08, 'o'), (0x57cb12, 'n')):
            uc.hook_add(UC_HOOK_CODE, self._tag(tag), begin=addr, end=addr)
        for addr in (0x57cadc, 0x57cb11, 0x57cb24):
            uc.hook_add(UC_HOOK_CODE, self._aret, begin=addr, end=addr)
        uc.hook_add(UC_HOOK_CODE, self._lit, begin=0x5b9970, end=0x5b9970)
        uc.ctl_flush_tb()
    def _next(self, kinds):
        k = self.fk; self.fk += 1
        if k >= len(self.fold) or self.fold[k] not in kinds:
            self.violations.append(('structure', k)); return None
        return self.fold[k]
    def _pred(self, uc, addr, size, ud):
        if not self.on: return
        esp = uc.reg_read(UC_X86_REG_ESP)
        p = struct.unpack('<I', uc.mem_read(esp + 4, 4))[0]
        cell = struct.unpack('<I', uc.mem_read(p, 4))[0]
        var = 0xebbf5f < cell < 0xebf610
        val = struct.unpack('<f', uc.mem_read(cell, 4))[0]
        z = addr == 0x57c8d0
        nat = 1 if (not var and val == (0.0 if z else 1.0)) else 0
        c = self._next('Z01' if z else 'O23')
        if c is None: r = nat
        elif c in 'Z0O2':
            r = 0
            if nat:
                self.imposed += 1
                if self.strict: self.violations.append(('fold-strict', self.fk - 1)); r = nat
        else:
            r = 1
            if not nat: self.violations.append(('fold', self.fk - 1)); r = nat
        ret = struct.unpack('<I', uc.mem_read(esp, 4))[0]
        uc.reg_write(UC_X86_REG_EAX, r); uc.reg_write(UC_X86_REG_ECX, p)
        uc.reg_write(UC_X86_REG_ESP, esp + 4); uc.reg_write(UC_X86_REG_EIP, ret)
    def _a(self, uc, addr, size, ud):
        if not self.on: return
        c = self._next('Nnkzo')
        self.astack.append([self.fk - 1, c, 'k'])
        if c == 'N' or (c == 'n' and not self.strict):
            uc.reg_write(UC_X86_REG_EIP, 0x57cb12)
    def _tag(self, tag):
        def h(uc, addr, size, ud):
            if self.on and self.astack: self.astack[-1][2] = tag
        return h
    def _aret(self, uc, addr, size, ud):
        # 0057ca60 is not re-entered by its callees (0057c8b0/0057c890/0057c860/0057cb30): at most one open
        # event; the 0x74fda8 early path returns through 0x57cb24 without an event (stack empty)
        if not self.on or not self.astack: return
        k, c, tag = self.astack.pop()
        if c is not None and c != 'N' and (c != 'n' or self.strict) and tag != c: self.violations.append(('cell', k))
    def _lit(self, uc, addr, size, ud):
        if not self.on: return
        k = self.lk; self.lk += 1
        esp = uc.reg_read(UC_X86_REG_ESP)
        ret = struct.unpack('<I', uc.mem_read(esp, 4))[0]
        bits = struct.unpack('<I', uc.mem_read(esp + 4, 4))[0]
        val = struct.unpack('<f', struct.pack('<I', bits))[0]
        top = struct.unpack('<I', uc.mem_read(0xec02c4, 4))[0]
        res = None; c = top - 4
        while c > self.LIT:
            if struct.unpack('<f', uc.mem_read(c, 4))[0] == val: res = c; break
            c -= 4
        if k >= len(self.lit_append):
            self.violations.append(('literal-structure', k)); append = res is None; want = None
        else:
            append = self.lit_append[k]; want = self.lit_addr[k]
        if self.strict and want is not None:
            if append != (res is None) or (not append and res != want): self.violations.append(('literal-strict', k))
        if append:
            top += 4
            uc.mem_write(0xec02c4, struct.pack('<I', top)); uc.mem_write(top, struct.pack('<I', bits))
            res = top; ecx = c
        elif want is None:
            ecx = res                       # outside the table (structure already violated): natural share
        else:
            if struct.unpack('<f', uc.mem_read(want, 4))[0] != val: self.violations.append(('literal', k))
            res = want; ecx = want
        if want is not None and res != want: self.violations.append(('literal-address', k))
        uc.reg_write(UC_X86_REG_EAX, res); uc.reg_write(UC_X86_REG_ECX, ecx)
        uc.reg_write(UC_X86_REG_EDX, top)
        uc.reg_write(UC_X86_REG_ESP, esp + 4); uc.reg_write(UC_X86_REG_EIP, ret)
