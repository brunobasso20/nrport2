"""Generated-callback structures of the car PLACED on the track (Watkins Glen port).

The ORIGINAL placement 005512f0 -> 00551520 -> bgRequestFGAction(00551760) rebuilds the car in place:
00551760 -> 005b2f20(root, bf6d40) regenerates every vehicle callback (mode-2 x87 emitter 005b3090) from the state
block at the placed pose. The emitter decisions depend on values (0057c8d0 x == 0, 0057c900 x == 1, 0057ca60 shared
constant cells, 005b9970 literal dedup): at a track pose 635 cell decisions differ from the bench pose of the shipped
image (the same 635 at every pit stall / grid / straight-line pose measured: one structure for the placed car).

This script runs the ORIGINAL placement in Unicorn (orig_world.OriginalWorld) with the Stage 10 emitter controls
(recovery/stage10/emitter_control.py) and writes, for both callback structures of the garage:
  placed         = the ORIGINAL natural decisions at the placed pose (default setup), strict
  placedGeneric  = the Stage 10 GENERIC forced keys (generic_force.pkl) applied at the placed pose
  NR2003CupTrackBuild.lua        decision tables + reference summary of both (NR2003CupBuild B.addStructure)
  NR2003CupJITP1..n.lua          the placed callbacks translated (recovery/stage6_7/jit2lua.py, gen_runtime layout)
  NR2003CupJITPG1..n.lua         the placed-generic callbacks translated
Usage: python3 gen_placed.py <out dir>   (env as ../ref_track.py)"""
import os
import re
import sys
import base64
import pickle
import hashlib
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parent.parent.parent
sys.path.insert(0, str(HERE.parent))
sys.path.insert(0, str(REPO / 'recovery' / 'stage10'))
sys.path.insert(0, str(REPO / 'recovery' / 'stage6_7'))
import capstone  # noqa: E402
from jit2lua import Translator  # noqa: E402
from emitter_control import FoldControl2, LiteralControl, fold_table  # noqa: E402

BASE = 0x6e9000
SLOTS = {'predictor': 0xe84548, 'solve': 0xe84498, 'tire0': 0xe84b90, 'tire1': 0xe84b94, 'tire2': 0xe84b98,
         'tire3': 0xe84b9c, 'forces': 0xe84bdc, 'corrector': 0xe84ba0, 'commit': 0xe84604}
SLOT_ORDER = [0xe84548, 0xe84498, 0xe84b90, 0xe84b94, 0xe84b98, 0xe84b9c, 0xe84bdc, 0xe84ba0, 0xe84604]
STALL = (341.13, -19.61, 0.0)


class IndexControl(FoldControl2):
    """FoldControl2 keyed by the global event index: key = (kind, index)"""
    def key(self, uc, kind, p):
        return (kind, len(self.seq))


def run(structure):
    """ORIGINAL placement with the emitter controls of `structure` on during the in-place rebuild; returns the machine
    after the placement, the decision tables and the reference summary"""
    import ref_track as R
    import orig_world as W
    W.SNAPSHOT['eips'] = set()
    force, follow, Control = set(), None, FoldControl2
    if structure == 'placedGeneric':
        # the Stage 10 GENERIC structure by global event index: its forced no-fold events ('Z' / 'O' / 'N' of
        # generic_tables.pkl) are imposed, every other decision is the ORIGINAL one at the placed pose; literal calls
        # follow the Stage 10 forced appends (index-based, generic_force.pkl)
        gfold = pickle.load(open(REPO / 'recovery' / 'stage10' / 'generic_tables.pkl', 'rb'))['tables'][0]
        force = {({'Z': 'z', 'O': 'o', 'N': 'a'}[c], i) for i, c in enumerate(gfold) if c in 'ZON'}
        follow = pickle.load(open(REPO / 'recovery' / 'stage10' / 'generic_force.pkl', 'rb'))[1]
        Control = IndexControl
    rec = {}
    base_place = W.OriginalWorld.place

    def place(self, *a):
        m = self.m
        fc = Control(m, force)
        lc = LiteralControl(m, follow)
        fc.on = lc.on = True
        base_place(self, *a)
        fc.on = lc.on = False
        assert not lc.violations, lc.violations[:5]
        n = len(lc.seq)
        rec['tables'] = (fold_table(fc.seq, force), [(follow or {}).get(k, lc.seq[k]) == 'append' for k in range(n)],
                         [lc.addr_of[k] for k in range(n)])
    W.OriginalWorld.place = place
    try:
        W.configure(os.environ['WG_TRACK'], os.environ['WG_SHARED'], os.environ.get('SERVER_MEM'), stall=STALL,
                    rts_mem=os.environ.get('RTS_MEM'))
        W.SNAPSHOT['on'] = False
        o = W.OriginalWorld(state=list(R.STATE0), weather=R.DEFAULT_SESSION, ffb=dict(enabled=True), device=R.DEV,
                            damage_level=0)
    finally:
        W.OriginalWorld.place = base_place
    m = o.m
    end = m.u32(0xebbcec)
    FOLD, LITF, LITA = rec['tables']
    ref = {'pool': m.u32(0xd47d60), 'litTop': m.u32(0xec02c4), 'codeEnd': end, 'nlit': len(LITF), 'nfold': len(FOLD),
           'slots': [m.u32(s) for s in SLOT_ORDER],
           'code': hashlib.sha1(bytes(m.uc.mem_read(0xead280, end - 0xead280))).hexdigest()}
    return m, rec['tables'], ref


def translate(m):
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    jit = {}
    for name, slot in SLOTS.items():
        a = m.u32(slot)
        code = bytes(m.uc.mem_read(a, 0x20000))
        ins = []
        for i in md.disasm(code, a):
            ins.append((i.address, i.mnemonic, i.op_str, bytes(i.bytes)))
            if i.mnemonic == 'ret':
                break
        jit[name] = (a, ins)
    used = set()

    def index_of(addr):
        used.add(addr)
        return 0
    natives = set()
    T = Translator(index_of, natives, BASE)
    out = {}
    for name, (a, ins) in jit.items():
        lines, _ = T.translate(name, ins)
        out[name] = (a, lines)
    return out, used, natives, T.tables


def emit_modules(out_dir, prefix, jit_lua, head):
    """the gen_runtime.py module layout (chunked callbacks, ~6000 lines per module)"""
    CHUNK, MODULE_LINES = 300, 6000
    groups = [[]]
    size = 0
    for name, (a, lines_) in jit_lua.items():
        n = sum(1 for l in lines_ if l != '--@SPLIT')
        if groups[-1] and size + n > MODULE_LINES:
            groups.append([])
            size = 0
        groups[-1].append(name)
        size += n
    jit_prelude = (REPO / 'recovery' / 'stage6_7' / 'runtime_jit_prelude.luau').read_text()
    files = []
    for gi, names in enumerate(groups):
        J = [jit_prelude % {'part': gi + 1, 'names': ', '.join(names)}]
        for name in names:
            a, lines_ = jit_lua[name]
            chunks = [[]]
            for l in lines_:
                if l == '--@SPLIT':
                    if len(chunks[-1]) >= CHUNK:
                        chunks.append([])
                    continue
                chunks[-1].append(l)
            if not chunks[-1]:
                chunks.pop()
            J.append('do -- %s (%d chunks)' % (name, len(chunks)))
            J.append('  local r_eax, r_ebx, r_ecx, r_edx, r_esi, r_edi')
            for k, c in enumerate(chunks):
                J.append('  local function C%d()' % (k + 1))
                J.append('    local f1, f2, f3, f4, f5, f6, f7, f8, q')
                J.append('    local ' + ', '.join('p%d' % j for j in range(1, 64)))
                for l in c:
                    J.append('    ' + l)
                J.append('  end')
            J.append('  JIT[0x%x] = function() -- %s' % (a, name))
            for k in range(len(chunks)):
                J.append('    C%d()' % (k + 1))
            J.append('  end')
            J.append('end')
        J.append('end')
        src = '\n'.join(J) + '\n'
        lines = src.split('\n')
        assert lines[0] == '--!native' and lines[1] == '--!optimize 2'
        src = '\n'.join(lines[:2]) + '\n' + head + '\n'.join(lines[2:])
        assert len(src) < 199000, (prefix, gi, len(src))
        fn = '%s%d.lua' % (prefix, gi + 1)
        (out_dir / fn).write_text(src)
        files.append((fn, len(src)))
    return files


def core_natives():
    core = REPO / 'core' / 'NR2003Cup' / 'NR2003CupCore.lua'
    return {int(x, 16) for x in re.findall(r'^XF\[0x([0-9a-f]+)\] = function', core.read_text(), re.M)}


def main(out_dir):
    out = Path(out_dir)
    out.mkdir(parents=True, exist_ok=True)
    have = core_natives()
    data = {}
    report = {}
    for structure, prefix in (('placed', 'NR2003CupJITP'), ('placedGeneric', 'NR2003CupJITPG')):
        m, tables, ref = run(structure)
        jit_lua, used, natives, ttables = translate(m)
        missing = sorted(natives - have)
        assert not missing, 'natives not lifted in the core: %s' % ', '.join('%06x' % x for x in missing)
        head = ('-- Watkins Glen port: callbacks of the car PLACED on the track (%s structure), generated by\n'
                '-- watkinsglen_implementation/recovery/lift/gen_placed.py: the ORIGINAL in-place rebuild 00551760 ->\n'
                '-- 005b2f20 at the placed pose (005512f0), translated with recovery/stage6_7/jit2lua.py.\n' % structure)
        files = emit_modules(out, prefix, jit_lua, head)
        data[structure] = (tables, ref)
        report[structure] = {'files': files, 'ref': ref, 'events': len(tables[0]), 'literals': len(tables[1]),
                             'used': len(used), 'natives': len(natives)}
        print(structure, report[structure])
    lines = ['-- GENERATED by watkinsglen_implementation/recovery/lift/gen_placed.py; do not edit.',
             '-- Emitter decision tables of the car placed on the track (ORIGINAL 005b2f20 at the placed pose), for',
             '-- NR2003CupBuild B.addStructure: fold = one byte per 0057c8d0 / 0057c900 / 0057ca60 event, litf = 005b9970',
             '-- append (1) / share (0), lita = u32 literal addresses; ref = pool / literal top / code end / slots.',
             'return {']
    for name, (tables, ref) in data.items():
        FOLD, LITF, LITA = tables
        lita = base64.b64encode(b''.join(a.to_bytes(4, 'little') for a in LITA)).decode()
        lines.append('%s = {fold = "%s",' % (name, FOLD))
        lines.append('litf = "%s",' % ''.join('1' if x else '0' for x in LITF))
        lines.append('lita = "%s",' % lita)
        lines.append('ref = {pool = %d, litTop = %d, codeEnd = %d, nlit = %d, nfold = %d, slots = {%s}}},'
                     % (ref['pool'], ref['litTop'], ref['codeEnd'], ref['nlit'], ref['nfold'],
                        ', '.join(str(s) for s in ref['slots'])))
    lines.append('}')
    src = '\n'.join(lines) + '\n'
    assert len(src) < 199000
    (out / 'NR2003CupTrackBuild.lua').write_text(src)
    pickle.dump(report, open(out / 'placed_report.pkl', 'wb'))


if __name__ == '__main__':
    main(sys.argv[1])
