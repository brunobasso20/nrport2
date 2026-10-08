"""Generate the Stage 11 Luau modules from the ORIGINAL executable:
  core/NR2003Cup/NR2003CupFrameCode1..n.lua  the ORIGINAL per-frame runtime functions lifted from x86 (lift11.py:
                                             frame end 00554520, collision damage 00549c40, record entry 0054a760,
                                             pit tyre service 00550f10, car placed on track 00550a50 subset, ...)
  core/NR2003Cup/NR2003CupFrameData1..n.lua  image supplement: the dwords the Stage 11 original code touches that are
                                             not inside the Stage 6/7 image windows, with their values after the
                                             ORIGINAL build (same post-build memory as recovery/stage6_7/gen_runtime.py)
  core/NR2003Cup/NR2003CupFrame.lua          host (from frame_host.luau): order of 005b2190/0055bfd0, API, telemetry
Usage: python gen_stage11.py <core/NR2003Cup dir>      (needs footprint11.pkl from trace11.py)"""
import os, sys, re, json, base64, pickle, struct, hashlib
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE)); sys.path.insert(0, str(HERE.parent / 'stage6_7'))
import lift11
from lift11 import BASE, TOP, PRELUDE11

FRAME_STACK = 0xf7e000            # unreferenced BSS between the build stack (0xf7c000) and the core stack (0xf7f000)
PART_CHARS = 170000               # Roblox Script.Source limit is 200,000 characters
EXCLUDE = [(0xf7a000, 0xf80000)]  # host blocks and virtual stacks (never part of the image)


def prelude_for_part():
    prelude = open(HERE.parent / 'stage6_7' / 'runtime_prelude.luau').read()
    head, body = prelude.split('return function(Image, jitModules)')
    body = body.replace('local M = buffer.create(Image.size)\nlocal BASE = Image.base', 'local M = ctx.M\nlocal BASE = ctx.base')
    body = body.replace('local ESP = Image.stackTop', 'local ESP = %d' % FRAME_STACK)
    body = body.replace('local F, FT = table.create(16, 0), 0', 'local F, FT = ctx.F, 0')
    body = re.sub(r'local function B_callback\(\).*?\nend\n', 'local function B_callback() error("NR2003 Stage 11: generated callback call") end\n', body, flags=re.S)
    body = re.sub(r'-- services for the JIT modules.*$', '', body, flags=re.S)
    assert 'ctx.M' in body and 'ctx.F' in body and 'local BG = 1' in body
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
	if not g then error(string.format("NR2003 Stage 11: call to unknown %08x", a)) end
	local s = function() SAVE(); g(); LOAD() end
	t[a] = s
	return s
end})
end
'''


def image_windows():
    """the Stage 6/7 image windows (offset, length) of core/NR2003Cup/NR2003CupImage*.lua"""
    core = HERE.parent.parent / 'core' / 'NR2003Cup'
    wins = []
    for p in sorted(core.glob('NR2003CupImage*.lua')):
        for m in re.finditer(r'\{(\d+),"([A-Za-z0-9+/=]*)"\}', p.read_text()):
            wins.append((int(m.group(1)), len(base64.b64decode(m.group(2)))))
    return wins


def static_refs(L):
    """absolute data addresses referenced by the lifted instructions (constants, tables, globals)"""
    refs = set()
    for f in L.funcs:
        ins, leaders, calls = L.discover(f)
        for i in ins.values():
            for op in i.operands:
                if op.type == lift11.X.X86_OP_MEM and not op.mem.base:
                    a = op.mem.disp & 0xffffffff
                    if BASE <= a < TOP: refs.add((a, op.mem.index != 0))
    return refs


def postbuild_memory():
    """post-build memory of the ORIGINAL car (exactly recovery/stage6_7/gen_runtime.py: Original(canonical state),
    host blocks cleared), as bytes of [BASE, TOP)"""
    sys.path.insert(0, str(HERE.parent / 'stage6_7'))
    from orig_runtime import Original
    import gen_runtime
    o = Original(state=gen_runtime.canonical_state()); m = o.m
    m.uc.mem_write(gen_runtime.HOST, b'\0' * 0x200)
    return bytes(m.uc.mem_read(BASE, TOP - BASE))


def main(out_dir):
    out = Path(out_dir)
    L = lift11.lift_all()
    fp = pickle.load(open(HERE / 'footprint11.pkl', 'rb'))
    assert not fp['outside'], 'Stage 11 code accesses memory outside the Luau image: %r' % fp['outside']
    for site, targets in fp['indirect'].items():
        for t in targets: assert t in lift11.INDIRECT, 'indirect call %x -> %x not lifted' % (site, t)
    # ---------------------------------------------------------------- code parts
    pre = prelude_for_part()
    ct = ['local CT_%06x = {[0]=%s}  -- byte table at %08x (.text)' % (t, ','.join(str(b) for b in tb), t)
          for t, tb in sorted(getattr(L, 'const_tables', {}).items())]
    bodies = []
    for a in sorted(L.funcs):
        body = '\n'.join(L.funcs[a]).replace('F_%06x = function()' % a, 'XF[0x%x] = function()' % a, 1)
        body = re.sub(r'\bF_([0-9a-f]{6})\(\)', lambda mm: 'XF[0x%s]()' % mm.group(1), body)
        bodies.append((a, body))
    head_len = len(pre) + len(PRELUDE11) + sum(len(x) + 1 for x in ct) + len(PART_TAIL) + 2000
    parts = [[]]; size = head_len
    for a, body in bodies:
        if parts[-1] and size + len(body) > PART_CHARS: parts.append([]); size = head_len
        parts[-1].append((a, body)); size += len(body) + 1
    code_files = []
    for pi, part in enumerate(parts):
        lines = ['--!native', '--!optimize 2',
                 '-- GENERATED by recovery/stage11/gen_stage11.py from NR2003.exe (original x86); do not edit.',
                 '-- Stage 11 per-frame runtime systems, lifted ORIGINAL functions part %d/%d (%d functions, %08x..%08x).'
                 % (pi + 1, len(parts), len(part), part[0][0], part[-1][0]),
                 '-- Simulation task (inBackground = 1). Float32 stores round toward -inf (CW 0x077f); x87 intermediates',
                 '-- in IEEE double; exact zero sums signed as under round-toward-negative (ZADD).',
                 'return function(ctx)', pre, PRELUDE11] + ct + [b for _, b in part] + [PART_TAIL]
        src = '\n'.join(lines) + '\n'
        assert len(src) < 199000, (pi, len(src))
        fn = 'NR2003CupFrameCode%d.lua' % (pi + 1); (out / fn).write_text(src); code_files.append((fn, len(src)))
    # ---------------------------------------------------------------- image supplement
    touched = fp['touched']
    have = bytearray((TOP - BASE) // 4)
    for off, n in image_windows():
        for k in range(off >> 2, (off + n + 3) >> 2): have[k] = 1
    want = bytearray((TOP - BASE) // 4)
    for k, t in enumerate(touched):
        if t: want[k] = 1
    for a, indexed in static_refs(L):
        lo, hi = (a - 64, a + 256) if indexed else (a - 16, a + 16)   # tables: generous window, scalars: +-4 dwords
        for x in range(max(lo, BASE) & ~3, min(hi, TOP), 4): want[(x - BASE) >> 2] = 1
    for lo, hi in EXCLUDE:
        for x in range(lo, hi, 4): want[(x - BASE) >> 2] = 0
    P = postbuild_memory()
    runs = []; k = 0; n = len(want)
    while k < n:
        if not want[k] or have[k]: k += 1; continue
        j = k
        while j < n and want[j] and not have[j]: j += 1
        runs.append((k, j)); k = j
    data_lines = []; zero_lines = []; total = 0
    for a, b in runs:
        blob = P[4 * a:4 * b]; total += len(blob)
        if blob.count(0) == len(blob): zero_lines.append('{%d,%d}' % (4 * a, 4 * (b - a))); continue
        kk = a
        while kk < b:
            e = min(b, kk + 4096)
            data_lines.append('{%d,"%s"}' % (4 * kk, base64.b64encode(P[4 * kk:4 * e]).decode())); kk = e
    dparts = [{'zero': [], 'data': []}]; size = 0
    for z in zero_lines:
        if size + len(z) > PART_CHARS: dparts.append({'zero': [], 'data': []}); size = 0
        dparts[-1]['zero'].append(z); size += len(z) + 2
    for x in data_lines:
        if size + len(x) > PART_CHARS: dparts.append({'zero': [], 'data': []}); size = 0
        dparts[-1]['data'].append(x); size += len(x) + 2
    data_files = []
    for pi, dp in enumerate(dparts):
        src = ['-- GENERATED by recovery/stage11/gen_stage11.py; do not edit.',
               '-- Stage 11 image supplement part %d/%d: dwords read or written by the ORIGINAL Stage 11 code outside the' % (pi + 1, len(dparts)),
               '-- Stage 6/7 image windows, with their values after the ORIGINAL car build (offsets from the image base).',
               'return {part=%d, parts=%d,' % (pi + 1, len(dparts)),
               'zero={', ',\n'.join(dp['zero']), '},', 'data={', ',\n'.join(dp['data']), '}}']
        s = '\n'.join(src) + '\n'
        assert len(s) < 199000
        fn = 'NR2003CupFrameData%d.lua' % (pi + 1); (out / fn).write_text(s); data_files.append((fn, len(s)))
    # ---------------------------------------------------------------- host
    host = open(HERE / 'frame_host.luau').read()
    host = host.replace('--@PARTS@', 'local CODE_PARTS, DATA_PARTS = %d, %d' % (len(code_files), len(data_files)))
    (out / 'NR2003CupFrame.lua').write_text(host)
    man = {'lifted': sorted('%06x' % a for a in L.funcs), 'builtins': {('%06x' % a): v for a, v in lift11.BUILTINS.items()},
           'roots': ['%06x' % a for a in lift11.ROOTS], 'indirect': ['%06x' % a for a in lift11.INDIRECT],
           'code': code_files, 'data': data_files, 'supplementBytes': total, 'runs': len(runs),
           'touchedDwords': sum(1 for t in touched if t), 'frameStack': hex(FRAME_STACK)}
    (HERE / 'frame_manifest.json').write_text(json.dumps(man, indent=1))
    print('lifted', len(L.funcs), 'code parts', code_files, 'data parts', data_files, 'supplement bytes', total, 'runs', len(runs))
    return man


if __name__ == '__main__':
    main(sys.argv[1] if len(sys.argv) > 1 else str(HERE / 'out'))
