"""Generate the Stage 10 Luau setup application (core/NR2003Cup/NR2003CupBuild*.lua): the ORIGINAL NR2003
car build sequence that turns the garage setup into runtime parameters (orig_setup.APPLY_CALLS: 00559820
derived items, 00550c40 engine, 00550c60 fuel, 00550bc0 tyres, 005b29c0 component tree, 005b2f20 setup ->
runtime cells + callback generation, 0054d610 x4), lifted from x86 to Luau (recovery/stage10/lift10.py,
Stage 6/7 lifter conventions), with:
  * the emitter decisions of the GENERIC (setup-invariant) callback structure (generic_search.py): one
    decision per emitter event (0057c8d0 / 0057c900 / 0057ca60) and per literal-pool call (005b9970),
    imposed through decision hooks in the lifted original functions (G_* in the module prelude), exactly
    like emitter_control.TableControl does in Unicorn;
  * the pre-application memory inputs: every dword the sequence touches (union over the footprint
    setups) restored to its value after the default-setup completion 00559950 (fresh-build semantics).
Generated callbacks are executed through the core's translated JIT table (005b9d10 -> V._jit).

Usage: python gen_build10.py <out_dir>          (needs generic_force.pkl from generic_search.py)
Outputs: NR2003CupBuild.lua (host), NR2003CupBuildCode1..n.lua (lifted functions),
         NR2003CupBuildData1..n.lua (inputs + decision tables), build_manifest.json, generic_tables.pkl"""
import os, sys, re, json, base64, pickle, struct, hashlib, random
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE)); sys.path.insert(0, str(HERE.parent / 'stage6_7'))
from lift10 import Lifter10
import trace_apply, orig_setup as OS
from emitter_control import FoldControl2, LiteralControl, TableControl, install, fold_table

BASE, TOP = 0x6e9000, 0xf80000
BUILD_STACK = 0xf7c000            # unused BSS below the core's virtual stack (0xf7f000)
PART_CHARS = 170000               # Roblox Script.Source limit is 200,000 characters
SLOTS = (0xe84548, 0xe84498, 0xe84b90, 0xe84b94, 0xe84b98, 0xe84b9c, 0xe84bdc, 0xe84ba0, 0xe84604)
# emitter state restored on every build in addition to the traced footprint (cells read by the decision
# hooks and literals written by them are not seen by the Unicorn memory hooks)
EMITTER_RANGES = ((0xd3b030, 0xd44c70), (0xd47d60, 0xd47d64), (0xebbf60, 0xec02c8),
                  # the whole garage and active setups: every item is written by the application (B.begin), also the
                  # ones the build itself never reads (e.g. 0x30 steering ratio, read at run time)
                  (0xc03350, 0xc03350 + 0xf00), (0xc055c0, 0xc055c0 + 0xf00))
# never restored: the inBackground stub flag of the Unicorn harness (orig_vehicle.BG_FLAG); the Luau build answers
# 005f8870 with the builtin B_inBackground (BG = 0) and does not touch this byte, which the image keeps at 1
EXCLUDE = (0xf7f000,)

def memreader():
    MEM = Path(os.environ['NR2003_MEM']); blocks = []
    for line in (MEM / 'blocks.tsv').read_text().splitlines()[1:]:
        n, st, sz, ini = line.split('\t'); blocks.append((int(st, 16), int(sz)))
    cache = {}
    def read(a, n):
        for st, sz in blocks:
            if st <= a < st + sz:
                if st not in cache: cache[st] = (MEM / ('%08x.bin' % st)).read_bytes()
                return cache[st][a - st:a - st + n]
        raise KeyError(hex(a))
    return read

BUILTINS = {0x6c5018: 'B_ftol', 0x6c5c40: 'B_pow', 0x5f5870: 'B_nop', 0x5f5880: 'B_nop', 0x5f5890: 'B_nop',
            0x5f58a0: 'B_nop', 0x5f8870: 'B_inBackground', 0x5f8890: 'B_inServer', 0x5cfcfc: 'B_rdtsc',
            0x5b9d10: 'B_callback', 0x5f7c50: 'B_taskGetRate',
            0x425e20: 'B_ret',            # host-only setup file paths (orig_vehicle: patched to ret)
            0x540b80: 'B_ret16'}          # multiplayer engine-block sync (orig_vehicle: patched to ret 16)

# decision hooks in the ORIGINAL emitter functions (addresses from the x86, see recovery/stage10/pseudo)
HOOKS = {
    0x57c8d0: ('pre', 'G_predEnter(1)'),            # 0057c8d0 cell == 0.0 ?
    0x57c8f7: ('pre', 'EAX = G_predRet(EAX)'), 0x57c8fa: ('pre', 'EAX = G_predRet(EAX)'),
    0x57c900: ('pre', 'G_predEnter(2)'),            # 0057c900 cell == 1.0 ?
    0x57c927: ('pre', 'EAX = G_predRet(EAX)'), 0x57c92a: ('pre', 'EAX = G_predRet(EAX)'),
    0x57ca71: ('branch', 'G_aSite()', 0x57cb12),    # 0057ca60 set constant: forced -> new cell (0057cb30)
    0x57cad4: ('pre', 'G_aTag(122)'),               # share the 0.0 cell
    0x57cb08: ('pre', 'G_aTag(111)'),               # share the 1.0 cell
    0x57cb12: ('pre', 'G_aTag(110)'),               # new cell
    0x57cadc: ('pre', 'G_aRet()'), 0x57cb11: ('pre', 'G_aRet()'), 0x57cb24: ('pre', 'G_aRet()'),
    0x5b9970: ('pre', 'G_litEnter()'),              # 005b9970 literal pool intern
    0x5b9999: ('branch', 'G_litAtAppend()', 0x5b99ae),
    0x5b99ae: ('branch', 'G_litAtFound()', 0x5b9999),
    0x5b99ad: ('pre', 'G_litRet()'), 0x5b99b0: ('pre', 'G_litRet()'),
}

PRELUDE_EXTRA = '''
local log = math.log
-- IEEE 754 sign of an exact zero sum under round-toward-negative (game CW 0x077f): x + y == 0 gives -0
-- unless both operands are +0 (doubles evaluate in round-to-nearest, which would give +0)
local function ZADD(x, y)
	if x == 0 and y == 0 and 1 / x > 0 and 1 / y > 0 then return 0 end
	return -0.0
end
local function B_ret() ESP = band(ESP + 4) end
local function B_ret16() ESP = band(ESP + 20) end
-- ===== Stage 10 generic emitter decisions (mirror of emitter_control.TableControl) =====
-- G.FOLD: one byte per emitter event: 0057c8d0 'Z' forced/'0' no fold/'1' fold; 0057c900 'O'/'2'/'3';
-- 0057ca60 'N' forced new cell/'n' new/'k' keep/'z' share 0.0/'o' share 1.0. G.LITF: '1' append,
-- '0' share; G.LITA: u32 address returned by each 005b9970 call. GENERIC tables: no-fold outcomes are
-- imposed (the generic code computes with the explicit value), fold outcomes must be the setup's natural
-- outcome. NATURAL tables (G.strict): every outcome must be the setup's natural outcome.
local G = ctx.G
local sbyte, readu32 = string.byte, buffer.readu32
local function G_violation(kind, k)
	G.viol += 1
	if G.firstViol == nil then G.firstViol = kind .. " #" .. k end
end
local PK, PSP = table.create(8, 0), 0
local function G_predEnter(kind)
	PSP += 1
	if not G.on then PK[PSP] = 0; return end
	local k = G.fk + 1; G.fk = k
	local c = sbyte(G.FOLD, k)
	local ok
	if kind == 1 then ok = c == 90 or c == 48 or c == 49 else ok = c == 79 or c == 50 or c == 51 end
	if ok then PK[PSP] = k else G_violation("structure", k); PK[PSP] = 0 end
end
local function G_predRet(eax)
	local k = PK[PSP]; PSP -= 1
	if k == 0 then return eax end
	local c = sbyte(G.FOLD, k)
	if c == 49 or c == 51 then
		if eax ~= 1 then G_violation("fold", k) end
		return eax
	end
	if eax ~= 0 then
		G.imposed += 1
		if G.strict then G_violation("fold-strict", k); return eax end
	end
	return 0
end
local AK, AC, ATAG = 0, 0, 0
local function G_aSite()
	if not G.on then AK = 0; return false end
	local k = G.fk + 1; G.fk = k
	local c = sbyte(G.FOLD, k)
	if c ~= 78 and c ~= 110 and c ~= 107 and c ~= 122 and c ~= 111 then
		G_violation("structure", k); AK = 0; return false
	end
	AK, AC, ATAG = k, c, 107
	return c == 78 or (c == 110 and not G.strict)
end
local function G_aTag(t) if AK ~= 0 then ATAG = t end end
local function G_aRet()
	if AK == 0 then return end
	if AC ~= 78 and (AC ~= 110 or G.strict) and ATAG ~= AC then G_violation("cell", AK) end
	AK = 0
end
local LK, LST = 0, 0
local function G_litEnter()
	if not G.on then LK = 0; return end
	LK = G.lk + 1; G.lk = LK; LST = 0
	if LK > G.NLIT then G_violation("literal-structure", LK); LK = 0 end
end
local function G_litAtAppend()        -- 005b9999: the natural search found no equal literal
	if LK == 0 or LST ~= 0 then return false end
	LST = 1
	if sbyte(G.LITF, LK) == 49 then return false end
	local a = readu32(G.LITA, 4 * (LK - 1))
	if rf32(a) ~= rf32(ESP + 4) then G_violation("literal", LK) end
	if G.strict then G_violation("literal-strict", LK) end
	ECX = a
	return true                         -- -> 005b99ae: mov eax, ecx; ret
end
local function G_litAtFound()         -- 005b99ae: the natural search found ECX
	if LK == 0 or LST ~= 0 then return false end
	LST = 1
	if sbyte(G.LITF, LK) == 49 then              -- -> 005b9999 append (ECX = found, as the search leaves it)
		if G.strict then G_violation("literal-strict", LK) end
		return true
	end
	local a = readu32(G.LITA, 4 * (LK - 1))
	if ECX ~= a then
		if rf32(a) ~= rf32(ESP + 4) then G_violation("literal", LK) end
		if G.strict then G_violation("literal-strict", LK) end
		ECX = a
	end
	return false
end
local function G_litRet()
	if LK == 0 then return end
	if EAX ~= readu32(G.LITA, 4 * (LK - 1)) then G_violation("literal-address", LK) end
	LK = 0
end
'''

def load_force():
    return pickle.load(open(HERE / 'generic_force.pkl', 'rb'))

def reference_tables(fold, follow):
    """Unicorn build of the default setup with the searched forced decisions -> global decision tables"""
    m = OS.boot(); OS.prepare(m)
    fc = FoldControl2(m, fold); lc = LiteralControl(m, follow)
    install(m, fc, lc)
    OS.apply(m, {})
    assert not lc.violations
    FOLD = fold_table(fc.seq, fold)
    n = len(lc.seq)
    LITF = [follow.get(k, lc.seq[k]) == 'append' for k in range(n)]
    LITA = [lc.addr_of[k] for k in range(n)]
    return (FOLD, LITF, LITA), m

def summary(m):
    end = m.u32(0xebbcec)
    code = hashlib.sha1(bytes(m.uc.mem_read(0xead280, end - 0xead280))).hexdigest()
    return {'code': code, 'codeEnd': end, 'pool': m.u32(0xd47d60), 'litTop': m.u32(0xec02c4),
            'slots': [m.u32(s) for s in SLOTS]}

def table_build(items, tables, strict=False):
    m = OS.boot(); OS.prepare(m)
    tc = TableControl(m, *tables, strict=strict); install(m, tc)
    OS.apply(m, items)
    return m, tc

def lift_all(read, extra=()):
    L = Lifter10(read, dict(BUILTINS), BASE)
    L.signed_zero_rtn = True
    L.hooks = HOOKS
    entries = sorted({c[0] for c in OS.APPLY_CALLS if isinstance(c[0], int)} | set(extra) | {0x57c990})
    work = list(entries)
    while work: work += L.lift(work.pop())
    for a in HOOKS:
        assert any(a in L.discover(f)[0] for f in L.funcs), 'hook %x not in lifted code' % a
    return L, entries

def runs(first, P):
    """every touched dword -> (zero runs, nonzero runs with the pre-application data)"""
    zero, data = [], []
    k = 0; n = len(first)
    while k < n:
        if not first[k]: k += 1; continue
        j = k
        while j < n and first[j]: j += 1
        a = k
        while a < j:
            z = P[4 * a:4 * a + 4] == b'\0\0\0\0'
            b_ = a
            while b_ < j and (P[4 * b_:4 * b_ + 4] == b'\0\0\0\0') == z: b_ += 1
            (zero if z else data).append((a, b_))
            a = b_
        k = j
    return zero, data

def footprint_setups(n_random=6, seed=4242):
    import generic_search as GS
    s = GS.garage_setups(0, 0)                       # default + every item at min and max
    s += GS.garage_setups(n_random, seed, extremes=False)[1:]
    return s

def _trace_one(args):
    items, tables = args
    ctl = (lambda m: install(m, TableControl(m, *tables))) if tables is not None else None
    P_, Q_, f_ = trace_apply.trace(items, control=ctl)
    return hashlib.sha1(P_).hexdigest(), bytes(f_), sorted(trace_apply.trace.indirect)

def footprint(tables, cache=HERE / 'footprint.pkl'):
    """union of the traced footprints (cached, keyed by the decision tables; tables None = the ORIGINAL
    natural build without emitter control)"""
    key = hashlib.sha1(pickle.dumps(tables)).hexdigest()
    if cache.exists():
        c = pickle.load(open(cache, 'rb'))
        if c['key'] == key: return bytearray(c['first']), set(c['indirect']), c['P']
    import multiprocessing as mp
    setups = footprint_setups()
    with mp.Pool(4) as pool:
        res = pool.map(_trace_one, [(s, tables) for s in setups])
    m = OS.boot(); OS.prepare(m); P = OS.snapshot(m)
    assert all(r[0] == hashlib.sha1(P).hexdigest() for r in res)
    n = len(res[0][1]); acc = 0; indirect = set()
    for _, f_, ind in res:
        indirect |= set(ind)
        acc |= int.from_bytes(f_, 'little')            # touched in any setup (values 1/2/3 = touched)
    first = bytearray(acc.to_bytes(n, 'little'))
    pickle.dump({'key': key, 'first': bytes(first), 'indirect': sorted(indirect), 'P': P, 'setups': len(setups)}, open(cache, 'wb'))
    return first, indirect, P

def prelude_for_part(ctx_doc):
    prelude = open(HERE.parent / 'stage6_7' / 'runtime_prelude.luau').read()
    head, body = prelude.split('return function(Image, jitModules)')
    body = body.replace('local M = buffer.create(Image.size)\nlocal BASE = Image.base', 'local M = ctx.M\nlocal BASE = ctx.base')
    body = body.replace('local ESP = Image.stackTop', 'local ESP = %d' % BUILD_STACK)
    body = body.replace('local F, FT = table.create(16, 0), 0', 'local F, FT = ctx.F, 0')
    body = body.replace('local BG = 1       -- inBackground() on the simulation task thread',
                        'local BG = 0       -- inBackground(): the car is built on the foreground task (bgRequestFGAction 00551760)')
    body = re.sub(r'local function B_callback\(\).*?\nend\n', '''local function B_callback()
	-- 005b9d10: jmp [esp+4] into generated code -> the core's translated callback
	ctx.callJIT(r32(ESP + 4))
	ESP = band(ESP + 4)
end
''', body, flags=re.S)
    # services for the core's JIT modules are not needed here
    body = re.sub(r'-- services for the JIT modules.*$', '', body, flags=re.S)
    assert 'ctx.M' in body and 'ctx.F' in body and 'ctx.callJIT' in body
    return body

PART_TAIL = '''
-- registers are per module: calls between modules go through the shared register file ctx.R
local R = ctx.R
local function LOAD() EAX, EBX, ECX, EDX, ESI, EDI, EBP, ESP, FT, FSW = R[1], R[2], R[3], R[4], R[5], R[6], R[7], R[8], R[9], R[10] end
local function SAVE() R[1], R[2], R[3], R[4], R[5], R[6], R[7], R[8], R[9], R[10] = EAX, EBX, ECX, EDX, ESI, EDI, EBP, ESP, FT, FSW end
for a, f in pairs(XF) do
	ctx.XF[a] = function() LOAD(); f(); SAVE() end
end
setmetatable(XF, {__index = function(t, a)
	local g = ctx.XF[a]
	if not g then error(string.format("NR2003 build: call to unknown %08x", a)) end
	local s = function() SAVE(); g(); LOAD() end
	t[a] = s
	return s
end})
end
'''

def natural_tables():
    """decision tables of the ORIGINAL natural build of the default setup (the Stage 6/7 core structure)"""
    m = OS.boot(); OS.prepare(m)
    fc = FoldControl2(m, set()); lc = LiteralControl(m, None)
    install(m, fc, lc)
    OS.apply(m, {})
    n = len(lc.seq)
    return (fold_table(fc.seq, set()), [lc.seq[k] == 'append' for k in range(n)], [lc.addr_of[k] for k in range(n)]), m

def check_tables(tables, mref, strict):
    mt, tc = table_build({}, tables, strict)
    assert not tc.violations, tc.violations[:5]
    Q, Qt = OS.snapshot(mref), OS.snapshot(mt)
    d = sum(1 for i in range(0, len(Q), 4) if Q[i:i + 4] != Qt[i:i + 4]) if Qt != Q else 0
    assert d == 0, 'TableControl reference differs in %d dwords' % d

def main(out_dir):
    out = Path(out_dir); out.mkdir(parents=True, exist_ok=True)
    read = memreader()
    fold, follow = load_force()
    tables, mref = reference_tables(fold, follow)
    ref = summary(mref)
    FOLD, LITF, LITA = tables
    # the table-driven Unicorn build reproduces the forced-key build exactly
    check_tables(tables, mref, False)
    print('GENERIC events', len(FOLD), 'forced', sum(1 for c in FOLD if c in 'ZON'), 'literal calls', len(LITF),
          'literals', sum(1 for k in range(len(LITF)) if LITF[k]), 'pool', ref['pool'], 'literal top', hex(ref['litTop']))
    pickle.dump({'tables': tables, 'ref': ref}, open(HERE / 'generic_tables.pkl', 'wb'))
    ntables, mnat = natural_tables()
    nref = summary(mnat)
    m0 = OS.boot(); OS.prepare(m0); OS.apply(m0, {})       # plain ORIGINAL build (no control at all)
    assert OS.snapshot(m0) == OS.snapshot(mnat)
    check_tables(ntables, mnat, True)
    NFOLD, NLITF, NLITA = ntables
    print('NATURAL events', len(NFOLD), 'literal calls', len(NLITF), 'literals', sum(1 for x in NLITF if x),
          'pool', nref['pool'], 'literal top', hex(nref['litTop']))
    pickle.dump({'tables': ntables, 'ref': nref}, open(HERE / 'natural_tables.pkl', 'wb'))
    # memory footprint: union over default, every item at its minimum/maximum and random setups, both structures
    first, indirect, P = footprint(tables)
    first_n, indirect_n, P_n = footprint(None, HERE / 'footprint_natural.pkl')
    assert P_n == P
    first = bytearray((int.from_bytes(first, 'little') | int.from_bytes(first_n, 'little')).to_bytes(len(first), 'little'))
    indirect |= indirect_n
    for lo, hi in EMITTER_RANGES:
        for a in range(lo, hi, 4): first[(a - BASE) >> 2] = first[(a - BASE) >> 2] or 1
    for a in EXCLUDE: first[(a - BASE) >> 2] = 0
    zero, data = runs(first, P)
    ind = [a for a in sorted(indirect) if 0x401000 <= a < 0x6e9000 and a not in BUILTINS]
    L, entries = lift_all(read, ind)
    print('lifted', len(L.funcs), 'indirect targets', len(ind), 'touched dwords', sum(1 for x in first if x))
    # ---------------------------------------------------------------- code parts
    pre = prelude_for_part('')
    ct = ['local CT_%06x = {[0]=%s}  -- byte table at %08x (.text)' % (t, ','.join(str(b) for b in tb), t)
          for t, tb in sorted(getattr(L, 'const_tables', {}).items())]
    bodies = []
    for a in sorted(L.funcs):
        body = '\n'.join(L.funcs[a]).replace('F_%06x = function()' % a, 'XF[0x%x] = function()' % a, 1)
        body = re.sub(r'\bF_([0-9a-f]{6})\(\)', lambda mm: 'XF[0x%s]()' % mm.group(1), body)
        bodies.append((a, body))
    head_len = len(pre) + len(PRELUDE_EXTRA) + sum(len(x) + 1 for x in ct) + len(PART_TAIL) + 2000
    parts = [[]]; size = head_len
    for a, body in bodies:
        if parts[-1] and size + len(body) > PART_CHARS: parts.append([]); size = head_len
        parts[-1].append((a, body)); size += len(body) + 1
    code_files = []
    for pi, part in enumerate(parts):
        lines = ['--!native', '--!optimize 2',
                 '-- GENERATED by recovery/stage10/gen_build10.py from NR2003.exe (original x86); do not edit.',
                 '-- Stage 10 setup application, lifted ORIGINAL functions part %d/%d (%d functions, %08x..%08x).'
                 % (pi + 1, len(parts), len(part), part[0][0], part[-1][0]),
                 '-- Float32 stores round toward -inf (CW 0x077f); x87 intermediates in IEEE double.',
                 'return function(ctx)', pre, PRELUDE_EXTRA] + ct + [b for _, b in part] + [PART_TAIL]
        src = '\n'.join(lines) + '\n'
        assert len(src) < 199000, (pi, len(src))
        fn = 'NR2003CupBuildCode%d.lua' % (pi + 1); (out / fn).write_text(src); code_files.append((fn, len(src)))
    # ---------------------------------------------------------------- data parts
    items = []   # (kind, payload) entries, packed into modules below the size limit
    for pre_, (F_, LF_, LA_) in (('', tables), ('n', ntables)):
        items.append('%sfold=%s' % (pre_, json.dumps(F_)))
        items.append('%slitf=%s' % (pre_, json.dumps(''.join('1' if x else '0' for x in LF_))))
        items.append('%slita=%s' % (pre_, json.dumps(base64.b64encode(struct.pack('<%dI' % len(LA_), *LA_)).decode())))
    chunks = []
    for a, b in zero: chunks.append('{%d,%d}' % (4 * a, 4 * (b - a)))
    zero_lines = chunks
    data_lines = []
    for a, b in data:
        k = a
        while k < b:                                # long runs split so every line stays small
            e = min(b, k + 4096)
            data_lines.append('{%d,"%s"}' % (4 * k, base64.b64encode(P[4 * k:4 * e]).decode())); k = e
    dparts = [{'zero': [], 'data': [], 'tables': []}]; size = 0
    def room(n):
        nonlocal size
        if size + n > PART_CHARS: dparts.append({'zero': [], 'data': [], 'tables': []}); size = 0
        size += n
    for t in items: room(len(t) + 4); dparts[-1]['tables'].append(t)
    for z in zero_lines: room(len(z) + 2); dparts[-1]['zero'].append(z)
    for x in data_lines: room(len(x) + 2); dparts[-1]['data'].append(x)
    data_files = []
    for pi, dp in enumerate(dparts):
        src = ['-- GENERATED by recovery/stage10/gen_build10.py; do not edit.',
               '-- Stage 10 setup application inputs, part %d/%d: pre-application memory (original state after' % (pi + 1, len(dparts)),
               '-- the default-setup completion 00559950) and generic emitter decision tables.',
               'return {part=%d, parts=%d, %s' % (pi + 1, len(dparts), ''.join(t + ', ' for t in dp['tables'])),
               'zero={', ',\n'.join(dp['zero']), '},', 'data={', ',\n'.join(dp['data']), '}}']
        s = '\n'.join(src) + '\n'
        assert len(s) < 199000
        fn = 'NR2003CupBuildData%d.lua' % (pi + 1); (out / fn).write_text(s); data_files.append((fn, len(s)))
    # ---------------------------------------------------------------- host
    host = open(HERE / 'build_host.luau').read()
    def lref(r, F_, LF_):
        return '{pool = %d, litTop = %d, codeEnd = %d, nlit = %d, nfold = %d, slots = {%s}}' % (
            r['pool'], r['litTop'], r['codeEnd'], len(LF_), len(F_), ', '.join(str(x) for x in r['slots']))
    host = host.replace('--@REF@', 'local REF = {generic = %s,\n\tnatural = %s}' % (lref(ref, FOLD, LITF), lref(nref, NFOLD, NLITF)))
    host = host.replace('--@PARTS@', 'local CODE_PARTS, DATA_PARTS = %d, %d' % (len(code_files), len(data_files)))
    (out / 'NR2003CupBuild.lua').write_text(host)
    man = {'lifted': len(L.funcs), 'code': code_files, 'data': data_files, 'zeroRuns': len(zero), 'dataRuns': len(data),
           'touchedDwords': sum(1 for x in first if x), 'events': len(FOLD), 'forcedEvents': sum(1 for c in FOLD if c in 'ZON'),
           'literalCalls': len(LITF), 'literals': sum(1 for x in LITF if x), 'ref': ref,
           'naturalEvents': len(NFOLD), 'naturalLiteralCalls': len(NLITF), 'naturalLiterals': sum(1 for x in NLITF if x), 'naturalRef': nref,
           'indirect': [hex(a) for a in ind],
           'hooks': {hex(a): list(h) for a, h in HOOKS.items()}}
    (out / 'build_manifest.json').write_text(json.dumps(man, indent=1))
    print('code parts', code_files, 'data parts', data_files)
    return man

if __name__ == '__main__':
    main(sys.argv[1] if len(sys.argv) > 1 else str(HERE / 'out'))
