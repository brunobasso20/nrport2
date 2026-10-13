"""Generate the Luau modules of the Watkins Glen track / collision world from the ORIGINAL executable:
  NR2003CupTrackCode1..n.lua  the ORIGINAL track / world functions lifted from x86 (lift_track.py: 005789c0, 00578a60,
                              00578da0 / 00578de0 contact passes, pair callbacks, primitives, 005543f0, 0051370a,
                              005512f0 placement, 00433cb0 collision geometry, rts.dll RBNodeBase::Remove, ...)
  NR2003CupTrackData1..n.lua  the track image: what the ORIGINAL track load (PTF, 00510b70 / 005108f0 build, track.ini
                              loaders 00538560, 00573010 track init) leaves in memory, from the Unicorn reference
                              (ref_track.py): the track arena, and the cells of the core image range that differ from
                              the car without a track or that the track code reads and no earlier image holds
  NR2003CupTrack.lua          host (track_host.luau)
Usage: python3 gen_track.py <out dir> <plain.pkl> <world.pkl> [world2.pkl ...]   (pickles from ../ref_track.py)"""
import os
import re
import sys
import json
import base64
import pickle
import array
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parent.parent.parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(REPO / 'recovery' / 'stage11'))
import lift_track as LT  # noqa: E402
import gen_stage11 as G11  # noqa: E402
from lift11 import BASE, PRELUDE11  # noqa: E402

TOP = 0xf80000                    # Stage 6/7 image top
STACK = 0xfbff00                  # track virtual stack (64 KB, inside the extension; unused by any image)
HOSTBLK = 0xfc0000                # host scratch (track queries)
ARENA = 0x1180000                 # orig_track.ARENA
PART_CHARS = 170000
IAT = (0x6e9000, 0x6ea000)        # import slots (reference binding artefacts)
EXCLUDE = [(0xf7a000, 0xf80000), IAT]
TRACK_NAME = 'Watkins Glen'

PRELUDE_TRACK = '''
-- Watkins Glen track world builtins (host boundary, identical semantics in the Unicorn reference)
-- __chkstk (006c5af0, encrypted CRT; x86 replacement crt_x87.CHKSTK): ESP = ESP before the call - EAX, EAX = return slot
local function B_chkstk() local ra = r32(ESP); ESP = band(ESP + 4 - EAX); EAX = ra end
-- atexit (006c4f40, encrypted CRT; crt_x87._atexit): function-static destructor registered, 0
local function B_atexit() EAX = 0; ESP = band(ESP + 4) end
-- rts.dll _memFree: no-op (orig_track.TrackHost)
local function B_memFree() ESP = band(ESP + 4) end
-- race-session object (00538b20 -> [be0e40], null in the port and the reference): 00551800 / 00541110 without effect
local function B_session551800()
	if r32(0xbe0e40) ~= 0 then error("NR2003 track: race-session object present (00551800 not ported)") end
	ESP = band(ESP + 4)
end
local function B_session541110()
	if ECX ~= 0 then error("NR2003 track: race-session object present (00541110 not ported)") end
	ESP = band(ESP + 4)
end
-- bgRequestFGAction (005f79a0): the foreground action at once (ctx.fgAction: 00551760 -> NR2003CupBuild 005b2f20)
local FGACTION = ctx.fgAction
local function B_fgAction()
	EAX = FGACTION(r32(ESP + 4), r32(ESP + 8), r32(ESP + 12)) or 0
	ESP = band(ESP + 4)
end
-- 0055e1e0 tyre contact (11 cdecl arguments, float10 result): the core's lifted function (ctx.tire)
local TIRE = ctx.tire
local function B_tire()
	local a = table.create(11, 0)
	for k = 1, 11 do a[k] = r32(ESP + 4 * k) end
	FT = FT + 1; F[FT] = TIRE(a)
	ESP = band(ESP + 4)
end
'''


def unreached_defs():
    return '\n'.join('local function B_UNREACHED_%06x() error("NR2003 track: %06x reached (never executed in the '
                     'session: replay recorder)") end' % (a, a) for a in LT.UNREACHED)


PART_TAIL = G11.PART_TAIL.replace('NR2003 Stage 11: call to unknown', 'NR2003 track: call to unknown')


def prelude():
    pre = G11.prelude_for_part()
    a = 'local ESP = %d' % G11.FRAME_STACK
    assert a in pre
    pre = pre.replace(a, 'local ESP = %d' % STACK)
    pre = pre.replace('NR2003 Stage 11: generated callback call', 'NR2003 track: generated callback call')
    return pre


def image_coverage():
    """dword cells of [BASE, TOP) that the Luau core memory holds at creation: the Stage 6/7 image windows and the
    Stage 11 supplement (NR2003CupFrameData*)"""
    have = bytearray((TOP - BASE) // 4)
    for off, n in G11.image_windows():
        for k in range(off >> 2, (off + n + 3) >> 2):
            have[k] = 1
    core = REPO / 'core' / 'NR2003Cup'
    for p in sorted(core.glob('NR2003CupFrameData*.lua')):
        t = p.read_text()
        z = re.search(r'zero=\{(.*?)\},\s*data=', t, re.S)
        for mm in re.finditer(r'\{(\d+),(\d+)\}', z.group(1)):
            off, n = int(mm.group(1)), int(mm.group(2))
            for k in range(off >> 2, (off + n + 3) >> 2):
                have[k] = 1
        for mm in re.finditer(r'\{(\d+),"([A-Za-z0-9+/=]*)"\}', t):
            off, n = int(mm.group(1)), len(base64.b64decode(mm.group(2)))
            for k in range(off >> 2, (off + n + 3) >> 2):
                have[k] = 1
    return have


def image_values():
    """u32 values of the Luau core memory at creation for the covered cells (Stage 6/7 windows, Stage 11 supplement)"""
    vals = {}
    core = REPO / 'core' / 'NR2003Cup'
    for p in sorted(core.glob('NR2003CupImage*.lua')) + sorted(core.glob('NR2003CupFrameData*.lua')):
        t = p.read_text()
        for mm in re.finditer(r'\{(\d+),"([A-Za-z0-9+/=]*)"\}', t):
            off, b = int(mm.group(1)), base64.b64decode(mm.group(2))
            for k in range(0, len(b) - 3, 4):
                vals[off + k] = int.from_bytes(b[k:k + 4], 'little')
        z = re.search(r'zero=\{(.*?)\},\s*data=', t, re.S)
        if z:
            for mm in re.finditer(r'\{(\d+),(\d+)\}', z.group(1)):
                off, n = int(mm.group(1)), int(mm.group(2))
                for k in range(0, n, 4):
                    vals[off + k] = 0
    return vals


def build_runs():
    """Stage 10 build footprint runs (offset, length) from NR2003CupBuildData*"""
    runs = []
    core = REPO / 'core' / 'NR2003Cup'
    for p in sorted(core.glob('NR2003CupBuildData*.lua')):
        t = p.read_text()
        for mm in re.finditer(r'\{(\d+),"([A-Za-z0-9+/=]*)"\}', t):
            runs.append((int(mm.group(1)), len(base64.b64decode(mm.group(2)))))
        z = re.search(r'zero=\{(.*?)\}\s*,\s*data', t, re.S)
        if z:
            for mm in re.finditer(r'\{(\d+),(\d+)\}', z.group(1)):
                runs.append((int(mm.group(1)), int(mm.group(2))))
    return runs


def static_refs(L):
    refs = set()
    for f in L.funcs:
        if f in L.alias:
            continue
        ins, leaders, calls = L.discover(f)
        for i in ins.values():
            for op in i.operands:
                if op.type == LT.X.X86_OP_MEM and not op.mem.base:
                    a = op.mem.disp & 0xffffffff
                    if BASE <= a < TOP:
                        refs.add((a, op.mem.index != 0))
                # Constructors store .rdata vtable pointers as immediates. Their virtual slots must be in the image
                # even when a reference scenario never touches the shape (e.g. body/wall rather than tyre/road).
                elif op.type == LT.X.X86_OP_IMM and i.mnemonic == 'mov':
                    a = op.imm & 0xffffffff
                    if 0x6ea000 <= a < 0x71b000:
                        refs.add((a, True))
    return refs


def excluded(a):
    return any(lo <= a < hi for lo, hi in EXCLUDE)


def stalls_from_ini(text):
    """[pit_lane_0] stall_<n> = dlong dlat yaw (track.ini; the ORIGINAL 005410f0 records come from these keys)"""
    out = {}
    sec = None
    for line in text.replace('\r', '\n').split('\n'):
        line = line.split(';', 1)[0].strip()
        if line.startswith('['):
            sec = line.strip('[] ').lower()
            continue
        if sec == 'pit_lane_0' and '=' in line:
            k, v = [x.strip() for x in line.split('=', 1)]
            mm = re.match(r'stall_(\d+)$', k)
            if mm:
                out[int(mm.group(1))] = [float(x) for x in v.split()[:3]]
    return [out[k] for k in sorted(out)]


def lua_num(x):
    r = repr(float(x))
    return r


def main(out_dir, plain_pkl, world_pkls):
    out = Path(out_dir)
    out.mkdir(parents=True, exist_ok=True)
    L, errors = LT.lift(strict=True)
    plain = pickle.load(open(plain_pkl, 'rb'))['snap']
    worlds = [pickle.load(open(p, 'rb')) for p in world_pkls]
    snap = worlds[0]['snap']
    arena_top = worlds[0]['top']
    for w in worlds[1:]:
        assert w['top'] == arena_top
        for k in w['snap']:
            assert w['snap'][k] == snap[k], 'load snapshots differ between runs (region %x)' % k
    touched = set()
    for w in worlds:
        for sc in w['scenarios'].values():
            touched |= sc['touched']
    # every indirect call target of the runs must be lifted (checked by the Luau ICALL at run time as well)
    # ---------------------------------------------------------------- code parts
    pre = prelude()
    ct = ['local CT_%06x = {[0]=%s}  -- byte table at %08x (.text)' % (t, ','.join(str(b) for b in tb), t)
          for t, tb in sorted(getattr(L, 'const_tables', {}).items())]
    bodies = []
    for a in sorted(L.funcs):
        body = '\n'.join(L.funcs[a])
        body = re.sub(r'^F_([0-9a-f]{6,8}) = function\(\)', lambda mm: 'XF[0x%s] = function()' % mm.group(1), body, count=1)
        body = re.sub(r'\bF_([0-9a-f]{6,8})\(\)', lambda mm: 'XF[0x%s]()' % mm.group(1), body)
        bodies.append((a, body))
    head = '\n'.join([pre, PRELUDE11, PRELUDE_TRACK, unreached_defs()] + ct)
    head_len = len(head) + len(PART_TAIL) + 2000
    parts = [[]]
    size = head_len
    for a, body in bodies:
        if parts[-1] and size + len(body) > PART_CHARS:
            parts.append([])
            size = head_len
        parts[-1].append((a, body))
        size += len(body) + 1
    code_files = []
    for pi, part in enumerate(parts):
        lines = ['--!native', '--!optimize 2',
                 '-- GENERATED by watkinsglen_implementation/recovery/lift/gen_track.py from NR2003.exe (+ rts.dll) original x86;',
                 '-- do not edit. Track / collision world, lifted ORIGINAL functions part %d/%d (%d functions, %08x..%08x).'
                 % (pi + 1, len(parts), len(part), part[0][0], part[-1][0]),
                 '-- Simulation task (inBackground = 1). Float32 stores round toward -inf (CW 0x077f); x87 intermediates',
                 '-- in IEEE double; exact zero sums signed as under round-toward-negative (ZADD).',
                 'return function(ctx)', head] + [b for _, b in part] + [PART_TAIL]
        src = '\n'.join(lines) + '\n'
        assert len(src) < 199000, (pi, len(src))
        fn = 'NR2003CupTrackCode%d.lua' % (pi + 1)
        (out / fn).write_text(src)
        code_files.append((fn, len(src)))
    # ---------------------------------------------------------------- track image
    have = image_coverage()
    P = array.array('I', plain[BASE])
    Wd = array.array('I', snap[BASE])
    cells = {}                                   # absolute address -> value (load-image values)
    ndiff = nref = nfoot = 0
    for k in range(len(P)):
        a = BASE + 4 * k
        if P[k] != Wd[k] and not excluded(a):
            cells[a] = Wd[k]
            ndiff += 1
    # cells the track code reads that no earlier image holds (nonzero in the reference): static references (+-4
    # dwords, indexed tables up to 4 KB), the footprint of the track code in the reference runs
    want = set()
    for a, indexed in static_refs(L):
        lo, hi = (a - 64, a + 4096) if indexed else (a - 16, a + 16)
        for x in range(max(lo, BASE) & ~3, min(hi, TOP), 4):
            want.add(x)
    nref = len(want)
    for a in touched:
        if BASE <= a < TOP:
            want.add(a)
    ivals = image_values()
    conv = []
    for a in sorted(want):
        k = (a - BASE) >> 2
        if a in cells or excluded(a):
            continue
        if have[k]:
            # a covered cell whose core-image value is not the reference's at the load point (host conventions of
            # the earlier stages that the Luau core never needed, e.g. c08194 -> the offline session block)
            iv = ivals.get(a - BASE)
            if iv is not None and iv != Wd[k] and a in touched:
                cells[a] = Wd[k]
                conv.append('%08x: %08x -> %08x' % (a, iv, Wd[k]))
            continue
        if Wd[k] == 0:
            continue
        cells[a] = Wd[k]
        nfoot += 1
    if conv:
        print('core-image cells set to the reference value (%d):' % len(conv), ', '.join(conv[:40]))
    # Include complete initialized executable data, not just locations observed in a few test drives. A section's
    # primitive constructors can reach alternate vtables and tables on any later part of the lap.
    # Preserve load-time values (track.ini and car build included); import slots remain host boundaries.
    for a in range(0x6ea000, 0x761000, 4):
        if not excluded(a):
            cells[a] = Wd[(a - BASE) >> 2]
    # BSS above the image (pools) and the track arena: everything nonzero
    for lo in sorted(snap):
        if lo == BASE:
            continue
        arr = array.array('I', snap[lo])
        for k, v in enumerate(arr):
            if v:
                cells[lo + 4 * k] = v
    top = max(arena_top, HOSTBLK + 0x1000)
    top = (top + 0xffff) & ~0xffff
    # runs over the sorted cells (above the image: gaps of up to 8 dwords merged into data runs), zero runs for cells that
    # must become 0 (core image cells the track load cleared)
    addrs = sorted(cells)
    data_runs, zero_runs = [], []
    i = 0
    while i < len(addrs):
        a = addrs[i]
        if cells[a] == 0:
            j = i
            while j + 1 < len(addrs) and addrs[j + 1] == addrs[j] + 4 and cells[addrs[j + 1]] == 0:
                j += 1
            zero_runs.append((a, addrs[j] + 4))
            i = j + 1
            continue
        j = i
        while j + 1 < len(addrs) and cells[addrs[j + 1]] != 0 and (addrs[j + 1] - addrs[j] == 4 or (addrs[j] >= TOP and addrs[j + 1] - addrs[j] <= 36)):
            j += 1
        data_runs.append((a, addrs[j] + 4))
        i = j + 1

    def mem(a):
        for lo, b in snap.items():
            if lo <= a < lo + len(b):
                return int.from_bytes(b[a - lo:a - lo + 4], 'little')
        raise KeyError(hex(a))
    data_lines, zero_lines = [], []
    total = 0
    for a, b in data_runs:
        blob = b''.join(mem(x).to_bytes(4, 'little') for x in range(a, b, 4))
        total += len(blob)
        k = 0
        while k < len(blob):
            e = min(len(blob), k + 3072)
            data_lines.append('{%d,"%s"}' % (a - BASE + k, base64.b64encode(blob[k:e]).decode()))
            k = e
    for a, b in zero_runs:
        zero_lines.append('{%d,%d}' % (a - BASE, b - a))
        total += b - a
    dparts = [{'zero': [], 'data': []}]
    size = 0
    for z in zero_lines:
        if size + len(z) > PART_CHARS:
            dparts.append({'zero': [], 'data': []})
            size = 0
        dparts[-1]['zero'].append(z)
        size += len(z) + 2
    for x in data_lines:
        if size + len(x) > PART_CHARS:
            dparts.append({'zero': [], 'data': []})
            size = 0
        dparts[-1]['data'].append(x)
        size += len(x) + 2
    data_files = []
    for pi, dp in enumerate(dparts):
        src = ['-- GENERATED by watkinsglen_implementation/recovery/lift/gen_track.py; do not edit.',
               '-- Watkins Glen track image part %d/%d: memory left by the ORIGINAL track load / build / track.ini /' % (pi + 1, len(dparts)),
               '-- 00573010 track init (Unicorn reference ref_track.py), offsets from the image base; top = end of the',
               '-- track memory (the core memory is created to cover it).',
               'return {part=%d, parts=%d, top=%d,' % (pi + 1, len(dparts), top),
               'zero={', ',\n'.join(dp['zero']), '},', 'data={', ',\n'.join(dp['data']), '}}']
        s = '\n'.join(src) + '\n'
        assert len(s) < 199000
        fn = 'NR2003CupTrackData%d.lua' % (pi + 1)
        (out / fn).write_text(s)
        data_files.append((fn, len(s)))
    # garage rebuild inputs: track-image cells inside the Stage 10 build footprint
    bruns = build_runs()
    binputs = {}
    for a, v in cells.items():
        if BASE <= a < TOP and P[(a - BASE) >> 2] != v:
            off = a - BASE
            if any(o <= off < o + n for o, n in bruns):
                binputs[off] = v
    # ---------------------------------------------------------------- host
    ini = (Path(os.environ['WG_TRACK']) / 'track.ini').read_text(encoding='latin-1')
    stalls = stalls_from_ini(ini)
    const = ['local CODE_PARTS, DATA_PARTS = %d, %d' % (len(code_files), len(data_files)),
             'local TOP = 0x%x                -- end of the track memory (arena 0x%x..0x%x)' % (top, ARENA, arena_top),
             'local STACK = 0x%x              -- track virtual stack top (64 KB)' % STACK,
             'local HOSTBLK = 0x%x            -- host scratch (track queries)' % HOSTBLK,
             'local TRACK_NAME = "%s"' % TRACK_NAME,
             '-- garage rebuild inputs changed by the track load (offset from the image base -> u32)',
             'local BUILD_INPUTS = {%s}' % ', '.join('[%d] = 0x%08x' % kv for kv in sorted(binputs.items())),
             '-- pit stalls of pit lane 0 (track.ini stall_<n> = dlong dlat yaw; 005410f0 records)',
             'local STALLS = {%s}' % ', '.join('{%s, %s, %s}' % tuple(lua_num(x) for x in s) for s in stalls),
             'local START = STALLS[1]          -- default placement: pit stall 0']
    host = (HERE / 'track_host.luau').read_text().replace('--@CONST@', '\n'.join(const))
    (out / 'NR2003CupTrack.lua').write_text(host)
    man = {'lifted': sorted('%06x' % a for a in L.funcs), 'aliases': {('%06x' % a): '%08x' % t for a, t in L.alias.items()},
           'builtins': {('%06x' % a): v for a, v in L.builtins.items() if a not in L.funcs},
           'roots': ['%06x' % a for a in LT.ROOTS], 'indirect': ['%06x' % a for a in LT.INDIRECT],
           'code': code_files, 'data': data_files, 'imageBytes': total, 'diffCells': ndiff, 'addedCells': nfoot,
           'buildInputs': len(binputs), 'top': hex(top), 'arena': [hex(ARENA), hex(arena_top)], 'stack': hex(STACK),
           'stalls': len(stalls)}
    (out / 'track_manifest.json').write_text(json.dumps(man, indent=1))
    print('lifted', len(L.funcs), 'code', code_files, 'data', data_files, 'image bytes', total, 'diff', ndiff,
          'added', nfoot, 'build inputs', len(binputs), 'top', hex(top))
    return man


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2], sys.argv[3:])
