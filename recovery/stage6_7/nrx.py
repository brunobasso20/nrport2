"""Unicorn harness that executes ORIGINAL NR2003.exe x86 code from the Ghidra memory image.
Never launches the game. Imports are stubbed (return 0, cdecl) and logged."""
import os, sys
from pathlib import Path
HERE = Path(__file__).resolve().parent
import struct, sys
from pathlib import Path
sys.path.insert(0, os.environ.get('UNICORN_PY', '/home/claude/tools/unicorn/bindings/python'))
from unicorn import *
from unicorn.x86_const import *
MEM = Path(os.environ.get('NR2003_MEM', '/home/claude/gout/mem'))  # ExportMemory.java output
F = lambda x: struct.unpack('<f', struct.pack('<f', x))[0]
bits = lambda x: struct.unpack('<I', struct.pack('<f', x))[0]
STUB = 0x0f000000
HEAP = 0x10000000
STACK_TOP = 0x1f000000
END = 0x1f000ff0

def _msvc_pop(name):
    """Bytes popped by callee for stdcall/thiscall imports (from decoration). cdecl -> 0."""
    import re
    m = re.match(r'^_?[A-Za-z0-9_]+@(\d+)$', name)
    if m: return int(m.group(1))
    if not name.startswith('?'): return 0
    try:
        body = name[name.index('@@') + 2:]
    except ValueError: return 0
    # access/convention codes: Q/U/A/I/E/M (member) + A/B const + E thiscall ; Y + A cdecl/G stdcall
    if body.startswith('Y'):
        conv = body[1]; rest = body[2:]
        if conv != 'G': return 0
    elif body[0] in 'QUAIEMSK':
        if body[0] in 'SK':  # static member functions: S A/G
            conv = body[1]; rest = body[2:]
            if conv != 'G': return 0
        else:
            conv = body[2] if body[1] in 'AB' else body[1]
            rest = body[3:] if body[1] in 'AB' else body[2:]
            if conv not in 'EG': return 0
    else: return 0
    # skip return type (or '@' for ctor/dtor)
    i = 0
    def skip_type(i):
        c = rest[i]
        if c in 'CDEFGHIJKMXZ': return i + 1, (0 if c in 'XZ' else 4)
        if c == 'N': return i + 1, 8
        if c == '_': return i + 2, (8 if rest[i+1] in 'JK' else 4)
        if c.isdigit(): return i + 1, 4
        if c in 'PQRS':
            j = i + 2
            j, _ = skip_type(j); return j, 4
        if c in 'AB':  # reference
            j = i + 2; j, _ = skip_type(j); return j, 4
        if c in 'VUTW':
            j = i + 1 + (1 if c == 'W' else 0)
            if rest[j].isdigit(): return j + 1, 4
            while True:
                j = rest.index('@', j)
                if rest[j+1] == '@': return j + 2, 4
                if rest[j+1].isdigit() and rest[j+2] == '@': return j + 3, 4
                j += 1
        if c == '?':
            j = i + 2; j, sz = skip_type(j); return j, sz
        raise ValueError(c)
    if rest[0] == '@': i = 1
    else:
        if rest[0] == '?': i = 2
        i, _ = skip_type(i)
    total = 0
    while i < len(rest) and rest[i] not in '@Z':
        if rest[i] == 'X': break
        i, sz = skip_type(i); total += sz
    return total

WINAPI_POP = dict(HeapAlloc=12, HeapFree=12, HeapReAlloc=16, HeapSize=12, HeapCreate=12, GetProcessHeap=0,
    InitializeCriticalSection=4, EnterCriticalSection=4, LeaveCriticalSection=4, DeleteCriticalSection=4,
    GetTickCount=0, timeGetTime=0, QueryPerformanceCounter=4, QueryPerformanceFrequency=4,
    GetModuleHandleA=4, GetProcAddress=8, TlsAlloc=0, TlsGetValue=4, TlsSetValue=8, GetLastError=0,
    SetLastError=4, VirtualAlloc=16, VirtualFree=12, GlobalAlloc=8, GlobalFree=4, CreateEventA=16,
    CreateMutexA=12, WaitForSingleObject=8, CloseHandle=4, Sleep=4, InterlockedIncrement=4,
    InterlockedDecrement=4, InterlockedExchange=8, GetVersion=0, GetVersionExA=4, MultiByteToWideChar=24,
    lstrlenA=4, lstrcpyA=8, lstrcatA=8, lstrcmpiA=8, OutputDebugStringA=4, GetSystemTimeAsFileTime=4, GetCurrentThreadId=0,
    GetCurrentProcessId=0, LoadLibraryA=4, FreeLibrary=4, RegisterWindowMessageA=4, GetCurrentThread=0,
    SetThreadPriority=8, GetLocalTime=4, GetSystemTime=4, timeBeginPeriod=4, timeEndPeriod=4,
    CreateThread=24, ResetEvent=4, SetEvent=4, GetCommandLineA=0, GetEnvironmentVariableA=12)

class Machine:
    def __init__(self, fpcw=0x027f):
        uc = self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        uc.mem_map(0x400000, 0x1200000 - 0x400000 + 0x100000)  # image incl. bss/sections
        for line in (MEM / 'blocks.tsv').read_text().splitlines()[1:]:
            name, start, size, init = line.split('\t')
            start = int(start, 16)
            if start >= 0xffdff000: continue
            p = MEM / f'{start:08x}.bin'
            if p.exists(): uc.mem_write(start, p.read_bytes())
        uc.mem_map(STUB, 0x100000)
        uc.mem_map(HEAP, 0x8000000)
        uc.mem_map(STACK_TOP - 0x200000, 0x201000)
        uc.mem_map(0xffdff000, 0x1000)  # tdb / TEB-ish
        self.heap = HEAP
        self.imports = {}
        self.calls = []
        self._patch_imports()
        self._patch_jmp_thunks()
        uc.mem_write(STUB, b'\xc3' * 0x100000)
        uc.hook_add(UC_HOOK_CODE, self._stub_hook, begin=STUB, end=STUB + 0x100000 - 1)
        self.bad_fetch = {}
        uc.hook_add(UC_HOOK_MEM_FETCH_UNMAPPED, self._bad_fetch)
        self.prot_hits = {}
        uc.hook_add(UC_HOOK_CODE, self._prot_hook, begin=0xfb0000, end=0x1126fff)
        self.fpcw = fpcw
        self.stubs = {}

    def _patch_imports(self):
        uc = self.uc
        pe = struct.unpack('<I', uc.mem_read(0x40003c, 4))[0] + 0x400000
        imp_rva = struct.unpack('<I', uc.mem_read(pe + 0x80, 4))[0]
        a = 0x400000 + imp_rva; idx = 0
        while True:
            oft, ts, fc, name, ft = struct.unpack('<5I', uc.mem_read(a, 20))
            if name == 0: break
            dll = self.cstr(0x400000 + name)
            t = 0x400000 + (oft or ft); slot = 0x400000 + ft
            while True:
                v = self.u32(t)
                if v == 0: break
                fn = ('#%d' % (v & 0xffff)) if v & 0x80000000 else self.cstr(0x400000 + v + 2)
                stub = STUB + 16 * idx; idx += 1
                self.imports[stub] = dll + '!' + fn
                self.w32(slot, stub)
                t += 4; slot += 4
            a += 20

    def _patch_jmp_thunks(self):
        # FF 25 [slot] thunks whose slot holds an unresolved RVA (a second, unbound IAT in .rdata)
        text = bytes(self.uc.mem_read(0x401000, 0x2e8000))
        idx = len(self.imports) + 1
        i = text.find(b'\xff\x25')
        while i >= 0:
            slot = struct.unpack('<I', text[i+2:i+6])[0]
            if 0x6e9000 <= slot < 0x6ea000 or 0x1127000 <= slot < 0x112b000:
                v = self.u32(slot)
                if not (0x401000 <= v < 0x6e9000) and not (STUB <= v < STUB + 0x100000):
                    name = '?'
                    if 0 < v < 0xd00000:
                        try: name = self.cstr(0x400000 + v + 2, 64)
                        except Exception: pass
                    stub = STUB + 16 * idx; idx += 1
                    self.imports[stub] = 'rdata!' + name
                    self.w32(slot, stub)
            i = text.find(b'\xff\x25', i + 2)

    def _stub_hook(self, uc, address, size, user):
        name = self.imports.get(address & ~15, '?')
        self.calls.append(name)
        handler = self.stubs.get(name.split('!')[-1])
        esp = uc.reg_read(UC_X86_REG_ESP)
        ret = self.u32(esp)
        pop = 0
        if handler: r, pop = handler(self, esp)
        else:
            r = 1 if name.endswith('rdtsc') else 0
            fn = name.split('!')[-1]
            if fn in WINAPI_POP: pop = WINAPI_POP[fn]
            else:
                try: pop = _msvc_pop(fn)
                except Exception: pop = 0
        uc.reg_write(UC_X86_REG_EAX, r & 0xffffffff)
        uc.reg_write(UC_X86_REG_ESP, esp + 4 + pop)
        uc.reg_write(UC_X86_REG_EIP, ret)

    def _bad_fetch(self, uc, access, address, size, value, user):
        # Calls through unresolved runtime pointers (e.g. 0xbbbbbbbb API slots) -> return 0.
        self.bad_fetch[address] = self.bad_fetch.get(address, 0) + 1
        if self.bad_fetch[address] > 100000: return False
        page = address & ~0xfff
        try:
            uc.mem_map(page, 0x1000); uc.mem_write(page, b'\xc3' * 0x1000)
        except UcError: return False
        uc.reg_write(UC_X86_REG_EAX, 0)
        return True

    def _prot_hook(self, uc, address, size, user):
        # SecuROM-protected API thunks (.ojhrz/.nehprt). Treated as cdecl import stubs returning 0.
        self.prot_hits[address] = self.prot_hits.get(address, 0) + 1
        esp = uc.reg_read(UC_X86_REG_ESP)
        ret = self.u32(esp)
        pop = self.prot_pop.get(address, 0)
        uc.reg_write(UC_X86_REG_EAX, self.prot_ret.get(address, 0))
        uc.reg_write(UC_X86_REG_ESP, esp + 4 + pop)
        uc.reg_write(UC_X86_REG_EIP, ret)
    prot_pop = {}
    prot_ret = {}
    def cstr(self, a, n=128):
        return bytes(self.uc.mem_read(a, n)).split(b'\0')[0].decode('latin1')
    def u32(self, a): return struct.unpack('<I', self.uc.mem_read(a, 4))[0]
    def i32(self, a): return struct.unpack('<i', self.uc.mem_read(a, 4))[0]
    def f32(self, a): return struct.unpack('<f', self.uc.mem_read(a, 4))[0]
    def w32(self, a, v): self.uc.mem_write(a, struct.pack('<I', v & 0xffffffff))
    def wf(self, a, v): self.uc.mem_write(a, struct.pack('<f', v))
    def alloc(self, n, init=b''):
        a = self.heap; self.heap += (n + 15) & ~15
        self.uc.mem_write(a, b'\0' * n)
        if init: self.uc.mem_write(a, init)
        return a
    def cell(self, v):
        a = self.alloc(4); self.wf(a, v); return a
    def call(self, address, *args, ecx=None, limit=20_000_000):
        uc = self.uc
        sp = STACK_TOP - 0x1000
        uc.mem_write(sp, struct.pack('<' + 'I' * (len(args) + 1), END, *[x & 0xffffffff for x in args]))
        uc.reg_write(UC_X86_REG_ESP, sp)
        uc.reg_write(UC_X86_REG_EBP, sp + 0x800)
        if ecx is not None: uc.reg_write(UC_X86_REG_ECX, ecx)
        uc.reg_write(UC_X86_REG_FPCW, self.fpcw)
        try:
            uc.emu_start(address, END, count=limit)
        except UcError as e:
            raise RuntimeError('%s at eip=%08x esp=%08x calling %08x' % (e, uc.reg_read(UC_X86_REG_EIP), uc.reg_read(UC_X86_REG_ESP), address))
        eip = uc.reg_read(UC_X86_REG_EIP)
        if eip != END: raise RuntimeError('did not return: %08x eip=%08x' % (address, eip))
        return uc.reg_read(UC_X86_REG_EAX)
    def patch_ret(self, address, pop=0, eax=None):
        code = b''
        if eax is not None: code += b'\xb8' + struct.pack('<I', eax & 0xffffffff)
        code += (b'\xc2' + struct.pack('<H', pop)) if pop else b'\xc3'
        self.uc.mem_write(address, code)
    def st0(self):
        return self.uc.reg_read(UC_X86_REG_FP0)
