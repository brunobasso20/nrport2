"""Generate the Luau NR2003 Cup vehicle runtime from the ORIGINAL executable.
Outputs:
  out/NR2003CupImage.lua    memory image windows (base64) captured after the original build
  out/NR2003CupRuntime.lua  translated JIT callbacks + lifted natives + host step (005b2190 order)
  out/manifest.json         provenance (functions, windows, callbacks, builtins)"""
import os, sys
from pathlib import Path
HERE = Path(__file__).resolve().parent
import sys, json, base64, pickle, struct, hashlib
from pathlib import Path
sys.path.insert(0, os.environ.get('CAPSTONE_PY', '/home/claude/tools/capstone/bindings/python'))
import capstone
from orig_runtime import *
from jit2lua import Translator, Unsupported
from lift import Lifter

OUT = Path(str(HERE / 'out')); OUT.mkdir(exist_ok=True)
BASE, TOP = 0x6e9000, 0xf80000
STACK_HI = 0xf7f000          # virtual x86 stack (grows down), unused BSS in the original
HOST = 0xf7f100              # host-side blocks for 0055e1e0 arguments
INPUTS = 0xbf6360; STATEBLK = 0xbf6d40

def canonical_state():
    st = [0.0] * 45; st[4] = 0.42; st[9] = 1.0
    return st

def main():
    o = Original(state=canonical_state()); m = o.m
    # host blocks at fixed addresses inside the image (replace the emulator heap ones)
    o.outF = [HOST + 0x00 + 16 * i for i in range(4)]
    o.outP = [HOST + 0x40 + 16 * i for i in range(4)]
    o.gv = [HOST + 0x80 + 16 * i for i in range(4)]
    o.blocks = [HOST + 0xc0 + 32 * i for i in range(4)]
    m.uc.mem_write(HOST, b'\0' * 0x200)
    # ---------------------------------------------------------------- JIT callbacks
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    slots = {'predictor': 0xe84548, 'solve': 0xe84498, 'tire0': 0xe84b90, 'tire1': 0xe84b94, 'tire2': 0xe84b98,
             'tire3': 0xe84b9c, 'forces': 0xe84bdc, 'corrector': 0xe84ba0, 'commit': 0xe84604}
    jit = {}
    for name, slot in slots.items():
        a = m.u32(slot); code = bytes(m.uc.mem_read(a, 0x20000)); ins = []
        for i in md.disasm(code, a):
            ins.append((i.address, i.mnemonic, i.op_str, bytes(i.bytes)))
            if i.mnemonic == 'ret': break
        jit[name] = (a, ins)
    used = set()
    def index_of(addr): used.add(addr); return 0
    natives = set()
    T = Translator(index_of, natives, BASE)
    jit_lua = {}
    for name, (a, ins) in jit.items():
        lines, _ = T.translate(name, ins)
        jit_lua[name] = (a, lines)
    # ---------------------------------------------------------------- natives (lifted)
    def read(a, n): return bytes(m.uc.mem_read(a, n))
    builtins = {0x6c5018: 'B_ftol', 0x6c5c40: 'B_pow', 0x5f5870: 'B_nop', 0x5f5880: 'B_nop', 0x5f5890: 'B_nop',
                0x5f58a0: 'B_nop', 0x5f8870: 'B_inBackground', 0x5f8890: 'B_inServer', 0x5cfcfc: 'B_rdtsc',
                0x5b9d10: 'B_callback', 0x5f7c50: 'B_taskGetRate'}
    L = Lifter(read, builtins, BASE)
    roots = sorted(natives | {0x5677d1, 0x55e1e0, 0x5b2b90, 0x5b2bd0, 0x5b2be0, 0x5b2c00, 0x5b2cb0, 0x5b2cd0,
                                 0x553d70, 0x554f10, 0x5b4560})   # + per-tick driver layer: shift FSM/auto clutch, rpm
    work = list(roots)
    while work:
        f = work.pop()
        work += L.lift(f)
    # indirect call targets observed in the emulator (vtables) are lifted too
    extra = [0x566aa0]
    for f in extra:
        # indirect calls are emitted with x87 effect 0: the observed vtable target must be neutral
        assert L.effect(f) == 0, 'indirect target %x has an x87 effect' % f
        work = [f]
        while work: work += L.lift(work.pop())
    # ---------------------------------------------------------------- memory windows
    cells, tables = pickle.load(open(str(HERE) + '/cells.pkl', 'rb'))
    lines = set()
    def addrange(a, n):
        for x in range(a & ~63, a + n + 63, 64): lines.add(x)
    for a, (sz, w, r) in cells.items():
        if BASE <= a < TOP: addrange(a - 64, 192)
    for a in used: addrange(a, 4)
    for t in tables:
        last = m.i32(t + 8); addrange(t, 12 + 4 * (last + 2))
    for t in T.tables:
        last = m.i32(t + 8); addrange(t, 12 + 4 * (last + 2))
    addrange(0x727290, 16 * 0x505)           # component records
    addrange(0xbf3a20, 4 * 0xa39 + 64)       # tire objects
    addrange(0xc12030, 0x15b8)               # car slot 0 incl. engine object (+0xc)
    addrange(0xc055c0, 0xefc)                # active setup
    addrange(o.spec, 0x1c8)                  # car spec
    addrange(0x8b0c00, 0xa00)                # tire profiles
    addrange(0xd35900, 0x400)                # surface pair tables
    addrange(0xc08000, 0x800)                # vehicle globals
    addrange(0xe84400, 0x900)                # solver globals / callback slots
    addrange(0xebbf00, 0x3800)               # JIT cells
    addrange(0x6e9000, 0x4000)               # .rdata constants head (CRT/fp constants)
    addrange(0x6ed000, 0x9000)               # .rdata physics constants block
    addrange(0x74c000, 0x4000)               # .data vehicle tables
    addrange(0xf6f000, 0x4000)               # obfuscation pool values
    addrange(0xbf6300, 0x1000)               # driver input / state blocks
    addrange(0xd37c00, 0x600)                # driver option table (0057af60)
    lines = sorted(x for x in lines if BASE <= x < TOP)
    windows = []
    for x in lines:
        if windows and windows[-1][1] == x: windows[-1][1] = x + 64
        else: windows.append([x, x + 64])
    img = []
    for a, b in windows:
        data = bytes(m.uc.mem_read(a, b - a))
        img.append((a - BASE, base64.b64encode(data).decode()))
    total = sum(b - a for a, b in windows)
    print('windows', len(windows), 'bytes', total, 'lifted', len(L.funcs), 'indirect', L.indirect_sites)
    # ---------------------------------------------------------------- emit image
    # split in parts: Roblox limits Script.Source to 200,000 characters
    parts = [[]]; size = 0
    for off, b64 in img:
        if parts[-1] and size + len(b64) > 150000: parts.append([]); size = 0
        parts[-1].append((off, b64)); size += len(b64) + 16
    for pi, part in enumerate(parts):
        img_lua = ['-- GENERATED by recovery/stage6_7/gen_runtime.py from NR2003.exe (original x86, Unicorn).',
                   '-- Memory image of the ORIGINAL NR2003 Cup vehicle after its own build path (part %d/%d); do not edit.' % (pi + 1, len(parts)),
                   'return {base=%d, size=%d, stackTop=%d, host=%d, part=%d, parts=%d, windows={' % (BASE, TOP - BASE, STACK_HI, HOST, pi + 1, len(parts))]
        for off, b64 in part: img_lua.append('{%d,"%s"},' % (off, b64))
        img_lua.append('}}')
        (OUT / ('NR2003CupImage%d.lua' % (pi + 1))).write_text('\n'.join(img_lua) + '\n')
    image_parts = len(parts)
    # ---------------------------------------------------------------- emit runtime
    R = []
    emit = R.append
    emit(open(str(HERE) + '/runtime_prelude.luau').read())
    emit('-- ===== lifted natives (%d functions) =====' % len(L.funcs))
    for a in sorted(L.funcs):
        body = '\n'.join(L.funcs[a]).replace('F_%06x = function()' % a, 'XF[0x%x] = function()' % a, 1)
        # internal direct calls F_xxxxxx() -> XF[...]()
        import re
        body = re.sub(r'\bF_([0-9a-f]{6})\(\)', lambda mm: 'XF[0x%s]()' % mm.group(1), body)
        emit(body)
    # ---------------------------------------------------------------- JIT modules
    # Each callback is cut into chunk functions at points where no FPU/temp value is live, and the
    # callbacks are grouped into modules small enough for Luau native code generation.
    CHUNK, MODULE_LINES = 300, 6000
    groups = [[]]; size = 0
    for name, (a, lines_) in jit_lua.items():
        n = sum(1 for l in lines_ if l != '--@SPLIT')
        if groups[-1] and size + n > MODULE_LINES: groups.append([]); size = 0
        groups[-1].append(name); size += n
    jit_prelude = open(str(HERE) + '/runtime_jit_prelude.luau').read()
    jit_files = []
    for gi, names in enumerate(groups):
        J = [jit_prelude % {'part': gi + 1, 'names': ', '.join(names)}]
        for name in names:
            a, lines_ = jit_lua[name]
            chunks = [[]]
            for l in lines_:
                if l == '--@SPLIT':
                    if len(chunks[-1]) >= CHUNK: chunks.append([])
                    continue
                chunks[-1].append(l)
            if not chunks[-1]: chunks.pop()
            J.append('do -- %s (%d chunks)' % (name, len(chunks)))
            J.append('  local r_eax, r_ebx, r_ecx, r_edx, r_esi, r_edi')
            for k, c in enumerate(chunks):
                J.append('  local function C%d()' % (k + 1))
                J.append('    local f1, f2, f3, f4, f5, f6, f7, f8, q')
                J.append('    local ' + ', '.join('p%d' % j for j in range(1, 64)))
                for l in c: J.append('    ' + l)
                J.append('  end')
            J.append('  JIT[0x%x] = function() -- %s' % (a, name))
            for k in range(len(chunks)): J.append('    C%d()' % (k + 1))
            J.append('  end')
            J.append('end')
        J.append('end')
        fn = 'NR2003CupJIT%d.lua' % (gi + 1)
        (OUT / fn).write_text('\n'.join(J) + '\n'); jit_files.append(fn)
    emit(open(str(HERE) + '/runtime_host.luau').read())
    (OUT / 'NR2003CupCore.lua').write_text('\n'.join(R) + '\n')
    man = {'callbacks': {k: hex(v[0]) for k, v in jit.items()}, 'natives': sorted(hex(x) for x in natives),
           'lifted': sorted(hex(x) for x in L.funcs), 'builtins': {hex(k): v for k, v in builtins.items()},
           'windows': len(windows), 'imageBytes': total, 'jitModules': jit_files, 'imageParts': image_parts, 'spec': hex(o.spec), 'root': hex(o.root)}
    (OUT / 'manifest.json').write_text(json.dumps(man, indent=1))
    pickle.dump({'jit': jit}, open(OUT / 'jit_listing.pkl', 'wb'))

if __name__ == '__main__':
    main()
