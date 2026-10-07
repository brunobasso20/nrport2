"""Translate the x87 code that NR2003.exe generates at runtime (005b3090 / mode-2 emitter 005b9a70...)
into straight-line Luau. One Lua statement per x87 store/branch; FPU stack is modeled by Lua locals
(double precision), memory cells by array `c` (1-based). Every 32-bit store goes through `fd()`
(IEEE single rounding toward -inf: the game's FPU control word 0x077f). Natives get their argument
block as explicit Lua arguments: pointer args are cell indices, value args are numbers.
The translator refuses any instruction/idiom it does not model exactly."""
import re

REG32 = ('eax', 'ebx', 'ecx', 'edx', 'esi', 'edi')

class Unsupported(Exception):
    pass

class Translator:
    def __init__(self, index_of, natives, base=0x6e9000):
        self.base = base
        self.index_of = index_of       # addr -> cell index (creates on demand)
        self.natives = natives         # set of native addresses called
        self.lines = []
        self.tables = set()

    def cell(self, addr):
        self.index_of(addr)
        return 'rf(M, %d)' % (addr - self.base)

    def off(self, addr):
        self.index_of(addr)
        return addr - self.base

    def memaddr(self, op, regs):
        # op: 'dword ptr [ebx + 0x24]' / '[0x74fd70]' / '[esp]'
        m = re.match(r'dword ptr \[(.*)\]$', op.strip())
        if not m: raise Unsupported(op)
        inner = m.group(1).replace(' ', '')
        if inner == 'esp': return 'esp'
        mm = re.match(r'^(e[a-z]{2})([+-]0x[0-9a-f]+|[+-]\d+)?$', inner)
        if mm:
            r = mm.group(1); disp = int(mm.group(2), 0) if mm.group(2) else 0
            v = regs.get(r)
            if not (isinstance(v, tuple) and v[0] == 'imm'): raise Unsupported('base reg not constant: ' + op)
            return (v[1] + disp) & 0xffffffff
        mm = re.match(r'^(0x[0-9a-f]+)$', inner)
        if mm: return int(mm.group(1), 16)
        raise Unsupported(op)

    def translate(self, name, ins):
        out = []; emit = out.append
        regs = {}                # reg -> ('imm', v) | ('val', luaexpr)
        stack = []               # x86 stack entries
        fpu = []                 # list of local names, top = last
        free = ['f%d' % i for i in range(1, 9)]
        pool = ['p%d' % k for k in range(1, 64)]
        used = set()
        def newtemp():
            t = pool.pop(0); used.add(t); return t
        def release(e):
            if e and e[0] in ('val', 'raw') and e[1].startswith('p') and e[1] in used:
                used.discard(e[1]); pool.insert(0, e[1])
        def push(expr):
            v = free.pop(0); fpu.append(v); emit('%s = %s' % (v, expr)); return v
        def pop():
            v = fpu.pop(); free.insert(0, v); return v
        def st(i):
            return fpu[-1 - i]
        n = len(ins); i = 0
        while i < n:
            if not fpu and not used and out and out[-1] != '--@SPLIT':
                emit('--@SPLIT')     # nothing live except translation-time regs and r_* raws
            a, mn, op, raw = ins[i]
            op = op.strip()
            # ---- idioms (exact instruction sequences emitted by NR2003's mode-2 code generator)
            if mn == 'push' and op == 'eax' and i + 7 < n and ins[i + 1][1] == 'fstp' and ins[i + 1][2] == 'dword ptr [esp]' \
               and ins[i + 2][1] == 'fld1' and ins[i + 3][1:3] == ('mov', 'eax, dword ptr [esp]') \
               and ins[i + 4][1:3] == ('and', 'eax, 0x7f000000') and ins[i + 5][1] == 'je' \
               and ins[i + 6][1:3] == ('fdiv', 'dword ptr [esp]') and ins[i + 7][1:3] == ('pop', 'eax'):
                # reciprocal 0057da40-style: v=f32(st0); st0 = (|v| has exponent field >= 2) ? 1/v : 1
                v = st(0); t = 'q'
                emit('%s = fd(%s)' % (t, v))
                emit('if %s < TINY and %s > -TINY then %s = 1 else %s = 1 / %s end' % (t, t, v, v, t))
                i += 8; continue
            if mn == 'push' and op == 'edx' and i + 9 < n and ins[i + 1][1:3] == ('push', 'eax') \
               and ins[i + 2][1:3] == ('fstp', 'dword ptr [esp]') and ins[i + 3][1:3] == ('mov', 'eax, dword ptr [esp]') \
               and ins[i + 4][1] == 'cdq' and ins[i + 5][1:3] == ('and', 'eax, edx') \
               and ins[i + 6][1:3] == ('mov', 'dword ptr [esp], eax') and ins[i + 7][1:3] == ('fld', 'dword ptr [esp]') \
               and ins[i + 8][1:3] == ('pop', 'eax') and ins[i + 9][1:3] == ('pop', 'edx'):
                # min_zero 0057dc10-style: keep value if sign bit set, else +0
                v = st(0)
                emit('%s = fd(%s)' % (v, v))
                emit('if %s > 0 or (%s == 0 and 1 / %s > 0) or %s ~= %s then %s = 0 end' % (v, v, v, v, v, v))
                i += 10; continue
            # ---- integer / stack bookkeeping
            if mn == 'mov':
                dst, src = [x.strip() for x in op.split(',', 1)]
                if dst in REG32 and re.match(r'^0x[0-9a-f]+$|^\d+$', src):
                    regs[dst] = ('imm', int(src, 0)); i += 1; continue
                if dst in REG32 and src.startswith('dword ptr ['):
                    addr = self.memaddr(src, regs)
                    if addr == 'esp':
                        raise Unsupported('mov reg,[esp] outside idiom at %x' % a)
                    t = 'r_' + dst; emit('%s = ru(M, %d)' % (t, self.off(addr))); regs[dst] = ('raw', t); i += 1; continue
                if dst.startswith('dword ptr [') and src in REG32:
                    addr = self.memaddr(dst, regs)
                    v = regs.get(src)
                    if not (isinstance(v, tuple) and v[0] == 'raw'): raise Unsupported('store of non-value reg at %x' % a)
                    emit('wu(M, %d, %s)' % (self.off(addr), v[1])); i += 1; continue
                if dst == 'eax' and src == 'esp':
                    regs['eax'] = ('esp', len(stack)); i += 1; continue
                raise Unsupported('%x mov %s' % (a, op))
            if mn == 'push':
                if op in REG32:
                    v = regs.get(op)
                    if isinstance(v, tuple) and v[0] == 'esp' and i + 1 < n and ins[i + 1][1] == 'call':
                        stack.append(('block', v[1]))
                    elif isinstance(v, tuple) and v[0] == 'imm':
                        stack.append(('ptr', v[1]))
                    else:
                        stack.append(('save', op, v))
                    i += 1; continue
                if re.match(r'^0x[0-9a-f]+$', op):
                    stack.append(('ptr', int(op, 16))); i += 1; continue
                if op.startswith('dword ptr ['):
                    addr = self.memaddr(op, regs)
                    t = newtemp(); emit('%s = ru(M, %d)' % (t, self.off(addr))); stack.append(('raw', t)); i += 1; continue
                raise Unsupported('%x push %s' % (a, op))
            if mn == 'pop':
                e = stack.pop()
                if e[0] == 'save': regs[op] = e[2]
                release(e)
                i += 1; continue
            if mn == 'add' and op.startswith('esp,'):
                k = int(op.split(',')[1], 0) // 4
                for _ in range(k): release(stack.pop())
                i += 1; continue
            if mn == 'call' and int(op, 16) == 0x5677d1:
                # 005677d1 lookup(table*, x): cdecl, result returned in ST0
                tp, xv = stack[-1], stack[-2]
                if tp[0] != 'ptr' or xv[0] not in ('val', 'raw'): raise Unsupported('lookup args at %x' % a)
                self.tables.add(tp[1])
                for r in ('eax', 'ecx', 'edx'): regs[r] = None
                # LKU/LKF (core module): build the same cdecl frame on the virtual x86 stack, run the
                # lifted 005677d1 and pop its ST0 result
                push('%s(%d, %s)' % ('LKU' if xv[0] == 'raw' else 'LKF', tp[1], xv[1])); i += 1; continue
            if mn == 'call':
                target = int(op, 16)
                top = stack[-1]
                if top[0] != 'block': raise Unsupported('call without arg block at %x' % a)
                if fpu: raise Unsupported('FPU not empty at native call %x' % a)
                depth = top[1]
                # only the entries pushed after the register saves belong to the block
                args = []
                for e in reversed(stack[:depth]):
                    if e[0] == 'save': break
                    args.append(e)
                self.natives.add(target)
                for r in ('eax', 'ecx', 'edx'): regs[r] = None   # cdecl caller-saved
                # rebuild the original arg block on the virtual x86 stack: block[0] = last pushed
                n_ = len(args)
                # NB(n): ESP -= 4*(n+2), returns ESP; NC(target, n): block ptr, return slot, call, cdecl cleanup
                code = ['do local sp = NB(%d)' % n_]
                for k, e in enumerate(args):
                    o = 'sp + %d' % (8 + 4 * k - self.base)
                    if e[0] == 'ptr': self.index_of(e[1]); code.append('wu(M, %s, %d)' % (o, e[1]))
                    elif e[0] == 'raw': code.append('wu(M, %s, %s)' % (o, e[1]))
                    elif e[0] == 'val': code.append('wf(M, %s, %s)' % (o, e[1]))
                    else: raise Unsupported('arg kind %s' % e[0])
                code.append('NC(0x%x, %d) end' % (target, n_))
                emit('; '.join(code))
                i += 1; continue
            if mn == 'ret':
                if fpu: raise Unsupported('FPU not empty at ret')
                break
            # ---- x87
            if mn == 'fld':
                if op.startswith('st('):
                    k = int(op[3]); push(st(k)); i += 1; continue
                addr = self.memaddr(op, regs)
                if addr == 'esp':
                    e = stack[-1]
                    if e[0] != 'val': raise Unsupported('fld [esp] of non value')
                    push(e[1]); i += 1; continue
                push(self.cell(addr)); i += 1; continue
            if mn == 'fld1': push('1'); i += 1; continue
            if mn == 'fldz': push('0'); i += 1; continue
            if mn in ('fst', 'fstp'):
                if op.startswith('st('):
                    k = int(op[3]); v = st(0)
                    if mn != 'fstp': raise Unsupported('fst st(i)')
                    if k == 0: pop(); i += 1; continue
                    tgt = st(k); emit('%s = %s' % (tgt, v)); pop(); i += 1; continue
                addr = self.memaddr(op, regs)
                v = st(0)
                if addr == 'esp':
                    # value pushed by 'push eax' then overwritten with the rounded float
                    e = stack[-1]
                    if not (e[0] == 'save' and e[1] == 'eax'): raise Unsupported('fstp [esp] without push eax at %x' % a)
                    t = newtemp(); emit('%s = fd(%s)' % (t, v)); stack[-1] = ('val', t)
                else:
                    emit('wfd(%d, %s)' % (self.off(addr), v))
                if mn == 'fstp': pop()
                i += 1; continue
            arith = {'fadd': '+', 'fsub': '-', 'fmul': '*', 'fdiv': '/'}
            if mn in arith or mn in ('fsubr', 'fdivr'):
                if op.startswith('dword ptr ['):
                    addr = self.memaddr(op, regs)
                    src = (stack[-1][1] if stack[-1][0] == 'val' else None) if addr == 'esp' else self.cell(addr)
                    if src is None: raise Unsupported('arith [esp] non value')
                    v = st(0)
                    if mn in arith: emit('%s = %s %s %s' % (v, v, arith[mn], src))
                    elif mn == 'fsubr': emit('%s = %s - %s' % (v, src, v))
                    else: emit('%s = %s / %s' % (v, src, v))
                    i += 1; continue
                if op.startswith('st(') and len(op) == 5:
                    k = int(op[3]); v = st(0); s = st(k)
                    if mn in arith: emit('%s = %s %s %s' % (v, v, arith[mn], s))
                    elif mn == 'fsubr': emit('%s = %s - %s' % (v, s, v))
                    else: emit('%s = %s / %s' % (v, s, v))
                    i += 1; continue
                raise Unsupported('%x %s %s' % (a, mn, op))
            if mn in ('faddp', 'fsubp', 'fmulp', 'fdivp', 'fsubrp', 'fdivrp'):
                k = int(op[3]) if op else 1
                tgt = st(k); v = st(0)
                expr = {'faddp': '%s + %s', 'fsubp': '%s - %s', 'fmulp': '%s * %s', 'fdivp': '%s / %s'}.get(mn)
                if expr: emit('%s = %s' % (tgt, expr % (tgt, v)))
                elif mn == 'fsubrp': emit('%s = %s - %s' % (tgt, v, tgt))
                else: emit('%s = %s / %s' % (tgt, v, tgt))
                pop(); i += 1; continue
            if mn == 'fxch':
                k = int(op[3]) if op else 1
                fpu[-1], fpu[-1 - k] = fpu[-1 - k], fpu[-1]
                i += 1; continue
            if mn == 'fchs': v = st(0); emit('%s = -%s' % (v, v)); i += 1; continue
            if mn == 'fabs': v = st(0); emit('%s = abs(%s)' % (v, v)); i += 1; continue
            if mn == 'fsqrt': v = st(0); emit('%s = sqrt(%s)' % (v, v)); i += 1; continue
            if mn == 'fsin': v = st(0); emit('%s = sin(%s)' % (v, v)); i += 1; continue
            if mn == 'fcos': v = st(0); emit('%s = cos(%s)' % (v, v)); i += 1; continue
            if mn == 'fprem': v = st(0); emit('%s = fmod(%s, %s)' % (v, v, st(1))); i += 1; continue
            raise Unsupported('%x %s %s' % (a, mn, op))
        return out, 64 - len(pool)
