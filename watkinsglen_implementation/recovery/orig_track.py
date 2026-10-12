"""ORIGINAL NR2003 track loading executed in Unicorn (reference for the Watkins Glen port).

What runs ORIGINAL x86 code (NR2003.exe image exported from the OpenNR2003 Ghidra project, NR2003_MEM):
  * the 46 persistent-class registrations (static initializers that link PersistentLoadingInfo entries)
  * every descriptor factory and reader (TrackDescriptor 005e52c0, SegmentDescriptor, X/F/W_Section,
    TSO, TSOReference, TrackDetail, TrackGroove, TrackRaceLine, Texture, Appearance, ...)
  * the track build 00510b70 (-> 00510f00 per segment, 0051208a) and 005108f0 (= 0050f780 without the INI part)
  * any track query (0051370a world -> track, 005150fa track -> world, ...) called by the tests

What is HOST (Python, transcribed from rts.dll, decompiled in recovery/evidence/rts/):
  * Archive::transferBytes / transferPointer / transferPointerButNotData / transferString /
    transferPersistentObject (object and class handle tables, addRef on back references,
    PersistentLoadingInfo::instantiatePersistentObj = strcmp walk of the registered list, vtable[0](archive))
  * _memAlloc (zero-filled heap), _memFree (no-op)
Unicorn cannot re-enter emu_start from a hook, so a new object is created through an x86 trampoline that calls
the registered factory, lets the host record the handle, stores the pointer and calls vtable[0](archive), exactly the
order of rts.dll 10002000.

x87: the build runs under CW 0x073f set by the original 0056772e(buf, 1, 3) (round toward -inf, 64-bit). QEMU
evaluates FSIN/FCOS/FPATAN/FSINCOS/FPTAN with the host double libm; X87Exact replaces each result by the exact value
rounded to the 64-bit significand in the current rounding mode (mpmath), which is what the x87 returns away from the
argument-reduction pathologies (verified for FSIN natively in Stage 12, recovery/stage12/evidence/reports/verify-input.md).
"""
import os
import struct
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parent.parent
sys.path.insert(0, str(REPO / 'recovery' / 'stage6_7'))
import nrx  # noqa: E402
sys.path.insert(0, str(HERE))
import crt_x87  # noqa: E402
from unicorn import UC_HOOK_CODE  # noqa: E402
from unicorn.x86_const import (UC_X86_REG_EAX, UC_X86_REG_ECX, UC_X86_REG_ESP, UC_X86_REG_EIP,  # noqa: E402
                               UC_X86_REG_FPSW, UC_X86_REG_FPCW, UC_X86_REG_FP0)

# call sites of PersistentLoadingInfo::getHead (thunk 005cfcea) in the static registrations (function = site - 0x14)
# (00401d80, the 46th caller, is an inline PersistentLoadingInfo constructor, not a registration)
REGISTRATION_CALLS = [
    0x005beed4, 0x005befc4, 0x005bf384, 0x005bf494, 0x005bf644, 0x005bfdb4, 0x005d7e84, 0x005d7ef4,
    0x005d7f64, 0x005d7fd4, 0x005d8044, 0x005d80b4, 0x005d8134, 0x005d81a4, 0x005d8224, 0x005d82a4, 0x005d8324,
    0x005d83a4, 0x005d8424, 0x005d84a4, 0x005d8514, 0x005d8584, 0x005d85f4, 0x005d8674, 0x005d86e4, 0x005d8754,
    0x005d87d4, 0x005d8844, 0x005d88b4, 0x005d8924, 0x005d8994, 0x005d8a04, 0x005d8a74, 0x005d8af4, 0x005d8b64,
    0x005e4aa4, 0x005e4b14, 0x005e4b84, 0x005e4c04, 0x005e4c74, 0x005e4ce4, 0x005e4d54, 0x005e4dc4, 0x005e4e34,
    0x005e4ea4]

TRACK_BASE = 0xbcf734      # runtime section array pointer
TRACK_COUNT = 0xbad920     # number of runtime sections
TRACK_LENGTH = 0xbad918    # f32 total length (sum of section lengths)
SECTION_SIZE = 0x1550
ARENA = 0x1180000          # track runtime allocations (00510b70 / 005108f0) -> exported image window


def original_bytes(address, n):
    """n bytes of the ORIGINAL NR2003.exe image (NR2003_MEM .text export) at address"""
    data = (Path(os.environ['NR2003_MEM']) / '00401000.bin').read_bytes()
    return data[address - 0x401000:address - 0x401000 + n]


_orig_stub_hook = nrx.Machine._stub_hook


def _stub_hook(self, uc, address, size, user):
    """nrx.Machine import dispatch + the rts.dll Archive host (transferPersistentObject may enter the trampoline)."""
    host = getattr(self, 'track_host', None)
    if host is not None:
        name = self.imports.get(address & ~15, '?').split('!')[-1]
        if name.startswith('?transferPersistentObject@Archive@@'):
            return host._transferPersistentObject(uc)
        for k, fn in getattr(self, 'redirect_stubs', {}).items():
            if name.startswith(k[:60]):                     # handler sets EIP itself (x86 continuation)
                self.calls.append(name)
                return fn(self, uc.reg_read(UC_X86_REG_ESP))
        if name not in self.stubs and name[:60] in host.prefix:
            self.stubs[name] = host.prefix[name[:60]]
    return _orig_stub_hook(self, uc, address, size, user)


nrx.Machine._stub_hook = _stub_hook      # patched before any machine is created (the hook is bound at init)


class TrackHost:
    """rts.dll Archive host + file table + class registry + CRT replacements, attached to an nrx.Machine."""

    def __init__(self, m, x87_ranges=((0x510000, 0x51a000), (0x6c0000, 0x6c8000)), crt_allow=(), crt_extra=None, crt_server=None):
        self.m = m
        m.track_host = self
        self.head = m.alloc(16)                    # PersistentLoadingInfo list head (rts.dll static)
        self.tramp = m.alloc(64)                   # x86 trampoline (heap: outside the hooked stub page)
        self.factcell = m.alloc(4)
        self.archive = m.alloc(0x4040)             # Archive object: +0 file, +5 storing flag (0 = loading), +9 mips
        self.streams = {}                          # Archive address -> [bytes, position, objects, classes]
        self.files = {}                            # lower-case resource name -> bytes (libfileOpenRead)
        self.handles = {}                          # fake PapyFile handle -> name
        self.opened = []                           # names opened (TSO scenery, textures are skipped)
        self.class_of = {}                         # address -> class name
        self.pending = []                          # handles waiting for their factory result
        self.registry = {}
        self._build_trampoline()
        stubs = {
            '?getHead@PersistentLoadingInfo@@KAPAPAV1@XZ': self._getHead,
            '?transferBytes@Archive@@QAE?AW4success@@PAXI@Z': self._transferBytes,
            '?transferPointer@Archive@@QAE?AW4success@@PAPAXI@Z': self._transferPointer,
            '?transferPointerButNotData@Archive@@QAE?AW4success@@PAPAXI@Z': self._transferPointerButNotData,
            '?transferString@Archive@@QAE?AW4success@@PAPAD@Z': self._transferString,
            '?_memAlloc@@YA?AW4success@@PAPAXK@Z': self._memAlloc,
            '?_memAllocTemp@@YA?AW4success@@PAPAXK@Z': self._memAlloc,
            '?_memFree@@YAXPAX@Z': lambda mm, esp: (0, 0),
            '?isMustLoadMips@Archive@@QAE_NXZ': lambda mm, esp: (0, 0),
            '?isReading@Archive@@QAE_NXZ': lambda mm, esp: (1, 0),
            '?libfileOpenRead@@YA?AW4success@@PAPAVPapyFile@@PBD@Z': self._libfileOpenRead,
            '?fileClose@@YA?AW4success@@PAVPapyFile@@@Z': lambda mm, esp: (1, 0),
            '?OpenArchive@Archive@@QAE?AW4success@@PAVPapyFile@@W4DiskDirection@1@@Z': self._OpenArchive,
            '?CloseArchive@Archive@@QAE?AW4success@@XZ': self._CloseArchive,
        }
        m.stubs.update(stubs)
        # the rdata thunks keep the decorated name truncated at 64 chars: index the handlers by prefix too
        self.prefix = {k[:60]: v for k, v in stubs.items()}
        # TextureDescriptor vtable[6] (005e2b30) loads the MIP image into the renderer while reading: rendering
        # host, skipped (returns success; the descriptor keeps the texture name)
        m.patch_ret(0x5e2b30, pop=8, eax=1)
        crt_x87.install(m, allow=crt_allow, extra=crt_extra, server=crt_server)
        self.x87 = X87Exact(m, x87_ranges)
        self._register_classes()

    def _build_trampoline(self):
        m, t = self.m, self.tramp
        code = b''
        code += b'\x51'                                         # push ecx (archive)
        code += b'\xff\x15' + struct.pack('<I', self.factcell)  # call [factcell]   (cdecl factory, no arguments)
        self.mark = t + len(code)
        code += b'\x90'                                         # MARK (host records the handle -> eax)
        code += b'\x8b\x54\x24\x08'                             # mov edx,[esp+8]   (PersistentObject **)
        code += b'\x89\x02'                                     # mov [edx],eax
        code += b'\x5a'                                         # pop edx (archive)
        code += b'\x52'                                         # push edx
        code += b'\x89\xc1'                                     # mov ecx,eax
        code += b'\x8b\x01'                                     # mov eax,[ecx]
        code += b'\xff\x10'                                     # call [eax]        (vtable[0](archive), thiscall)
        code += b'\xc2\x04\x00'                                 # ret 4
        m.uc.mem_write(t, code)
        m.uc.hook_add(UC_HOOK_CODE, self._mark_hook, begin=self.mark, end=self.mark)

    def _mark_hook(self, uc, address, size, user):
        obj = uc.reg_read(UC_X86_REG_EAX)
        objects, handle, cname = self.pending.pop()
        if obj == 0:
            raise RuntimeError('factory of %s returned 0' % cname)
        objects[handle] = obj
        self.class_of[obj] = cname

    # ---- registry ----
    def _getHead(self, m, esp):
        return self.head, 0

    def _register_classes(self):
        m = self.m
        for site in REGISTRATION_CALLS:
            fn = site - 0x14
            if bytes(m.uc.mem_read(fn, 2)) != b'\xc7\x05':
                raise RuntimeError('registration function not found before %08x' % site)
            m.call(fn)
        p = m.u32(self.head)
        while p:
            self.registry[m.cstr(m.u32(p + 4))] = m.u32(p + 8)
            p = m.u32(p)

    # ---- Archive (rts.dll) ----
    def read(self, n):
        st = self.streams[self.m.uc.reg_read(UC_X86_REG_ECX)]
        if st[1] + n > len(st[0]):
            raise RuntimeError('stream overrun at 0x%x (+%d)' % (st[1], n))
        b = st[0][st[1]:st[1] + n]
        st[1] += n
        return b

    def _libfileOpenRead(self, m, esp):
        out, name_ptr = self._args(esp, 2)
        name = m.cstr(name_ptr, 260).replace('\\', '/').split('/')[-1].lower()
        if name not in self.files:
            m.w32(out, 0)
            return 0, 0
        h = 0x7f000000 + 16 * (len(self.handles) + 1)
        self.handles[h] = name
        self.opened.append(name)
        m.w32(out, h)
        return 1, 0

    def _OpenArchive(self, m, esp):
        f, direction = self._args(esp, 2)
        a = m.uc.reg_read(UC_X86_REG_ECX)
        m.w32(a, f)
        m.uc.mem_write(a + 5, b'\0\0\0\0')            # loading
        self.streams[a] = [self.files[self.handles[f]], 0, {}, {}]
        return 1, 8

    def _CloseArchive(self, m, esp):
        a = m.uc.reg_read(UC_X86_REG_ECX)
        st = self.streams.pop(a)
        if st[1] != len(st[0]):
            raise RuntimeError('%s not consumed: %d of %d' % (self.handles.get(m.u32(a)), st[1], len(st[0])))
        return 1, 0

    def _args(self, esp, n):
        return struct.unpack('<%dI' % n, bytes(self.m.uc.mem_read(esp + 4, 4 * n)))

    def _transferBytes(self, m, esp):
        ptr, size = self._args(esp, 2)
        if size:
            m.uc.mem_write(ptr, self.read(size))
        return 1, 8

    def _memAlloc(self, m, esp):
        out, size = self._args(esp, 2)
        m.w32(out, m.alloc(max(size, 1)))
        return 1, 0

    def _transferPointer(self, m, esp):
        pp, _size = self._args(esp, 2)
        n = struct.unpack('<I', self.read(4))[0]
        if n == 0:
            m.w32(pp, 0)
            return 1, 8
        a = m.alloc(n)
        m.w32(pp, a)
        m.uc.mem_write(a, self.read(n))
        return 1, 8

    def _transferPointerButNotData(self, m, esp):
        pp, _size = self._args(esp, 2)
        n = struct.unpack('<I', self.read(4))[0]
        m.w32(pp, m.alloc(n) if n else 0)
        return 1, 8

    def _transferString(self, m, esp):
        (pp,) = self._args(esp, 1)
        n = struct.unpack('<I', self.read(4))[0]
        if n == 0:
            m.w32(pp, 0)
            return 1, 4
        a = m.alloc(n)
        m.uc.mem_write(a, self.read(n))
        m.w32(pp, a)
        return 1, 4

    def _read_class(self, classes):
        ch = struct.unpack('<I', self.read(4))[0]
        if ch not in classes:
            n = struct.unpack('<I', self.read(4))[0]
            classes[ch] = self.read(n).split(b'\0', 1)[0].decode('latin-1')
        return classes[ch]

    def _transferPersistentObject(self, uc):
        m = self.m
        esp = uc.reg_read(UC_X86_REG_ESP)
        ret, pp = struct.unpack('<II', bytes(uc.mem_read(esp, 8)))
        st = self.streams[uc.reg_read(UC_X86_REG_ECX)]
        objects, classes = st[2], st[3]
        h = struct.unpack('<I', self.read(4))[0]
        if h == 0 or h in objects:
            obj = objects.get(h, 0)
            m.w32(pp, obj)
            if obj:
                m.w32(obj + 4, m.u32(obj + 4) + 1)   # addRef
            uc.reg_write(UC_X86_REG_EAX, 1)
            uc.reg_write(UC_X86_REG_ESP, esp + 8)
            uc.reg_write(UC_X86_REG_EIP, ret)
            return
        m.w32(pp, 0)
        cname = self._read_class(classes)
        factory = self.registry.get(cname)
        if factory is None:
            raise RuntimeError('class %r is not registered' % cname)
        self.pending.append((objects, h, cname))
        m.w32(self.factcell, factory)
        uc.reg_write(UC_X86_REG_EIP, self.tramp)    # stack still [ret][pp], ECX = archive

    def load(self, data):
        """Reads one persistent object stream (.ptf / .3do) with the original readers; returns the root address."""
        m = self.m
        self.streams[self.archive] = [data, 0, {}, {}]
        root = m.alloc(4)
        code = m.alloc(32)
        # mov ecx, archive ; push root ; call thunk 005cff48 ; ret
        body = b'\xb9' + struct.pack('<I', self.archive) + b'\x68' + struct.pack('<I', root)
        body += b'\xe8' + struct.pack('<i', 0x5cff48 - (code + len(body) + 5)) + b'\xc3'
        m.uc.mem_write(code, body)
        ok = m.call(code)
        if ok != 1:
            raise RuntimeError('transferPersistentObject failed')
        st = self.streams.pop(self.archive)
        if st[1] != len(data):
            raise RuntimeError('stream not consumed: %d of %d bytes' % (st[1], len(data)))
        self.root_objects = st[2]
        return m.u32(root)

    def add_dat(self, path):
        """Makes every entry of a Papyrus .dat available to libfileOpenRead (track first, then shared)."""
        sys.path.insert(0, str(REPO / 'nr2003carmodel_implementation' / 'pipeline'))
        from nr2003res.dat import DatArchive
        a = DatArchive(str(path))
        for e in a.entries:
            self.files.setdefault(e.name.lower(), a.read(e))

    def build_track(self, root, arena=None):
        """ORIGINAL 0050f780 minus the INI part: 00510b70 (runtime sections) + 005108f0 (per-section buffers).
        arena: heap address for the runtime allocations (the exported track image window)."""
        m = self.m
        saved = None
        if arena is not None:
            saved, m.heap = m.heap, arena
        try:
            if m.call(0x510b70, root) != 1:
                raise RuntimeError('00510b70 failed')
            if m.call(0x5108f0, root) != 1:
                raise RuntimeError('005108f0 failed')
        finally:
            if saved is not None:
                self.arena = (arena, m.heap)
                m.heap = saved
        return m.i32(TRACK_COUNT)


class TrackMachine(nrx.Machine):
    """Standalone machine for the loader: nrx.Machine + TrackHost (fpcw 0x073f, the track build CW)."""

    def __init__(self):
        super().__init__(fpcw=0x073f)
        self.host = TrackHost(self)

    def __getattr__(self, name):
        return getattr(self.__dict__['host'], name)

    def f64(self, a):
        return struct.unpack('<d', self.uc.mem_read(a, 8))[0]

    def section_bytes(self, i):
        return bytes(self.uc.mem_read(self.u32(TRACK_BASE) + SECTION_SIZE * i, SECTION_SIZE))


class X87Exact:
    """Exact FSIN / FCOS / FSINCOS / FPATAN / FPTAN results (64-bit significand, current RC) over QEMU's double libm."""
    OPS = {0xd9fe: 'fsin', 0xd9ff: 'fcos', 0xd9fb: 'fsincos', 0xd9f3: 'fpatan', 0xd9f2: 'fptan'}

    def __init__(self, m, ranges):
        import mpmath
        self.mp = mpmath
        self.m = m
        self.pending = None
        self.count = {}
        sites = []
        for begin, end in ranges:
            code = bytes(m.uc.mem_read(begin, end - begin))
            for op in self.OPS:
                pat = struct.pack('>H', op)
                i = code.find(pat)
                while i >= 0:
                    sites.append(begin + i)
                    i = code.find(pat, i + 1)
        self.sites = set(sites)
        for s in sites:
            m.uc.hook_add(UC_HOOK_CODE, self._before, begin=s, end=s)
            m.uc.hook_add(UC_HOOK_CODE, self._after, begin=s + 2, end=s + 2)

    def _st(self, uc, i):
        top = (uc.reg_read(UC_X86_REG_FPSW) >> 11) & 7
        return UC_X86_REG_FP0 + ((top + i) & 7)

    def _value(self, mant, se):
        mp = self.mp
        sign, e = se >> 15, se & 0x7fff
        if e == 0 and mant == 0:
            return mp.mpf(0), sign
        return mp.ldexp(mp.mpf(mant), max(e, 1) - 16383 - 63) * (-1 if sign else 1), sign

    def _encode(self, v, rc):
        mp = self.mp
        if v == 0:
            return (0, 0)
        sign = 1 if v < 0 else 0
        a = -v if sign else v
        e = int(mp.floor(mp.log(a, 2)))
        while mp.ldexp(1, e) > a:
            e -= 1
        while mp.ldexp(1, e + 1) <= a:
            e += 1
        scaled = mp.ldexp(a, 63 - e)                          # in [2^63, 2^64)
        lo = int(mp.floor(scaled))
        exact = (scaled == lo)
        if exact:
            mant = lo
        elif rc == 0:                                          # nearest even
            frac = scaled - lo
            mant = lo + 1 if (frac > 0.5 or (frac == 0.5 and lo & 1)) else lo
        elif rc == 1:                                          # down (toward -inf)
            mant = lo if not sign else lo + 1
        elif rc == 2:                                          # up
            mant = lo + 1 if not sign else lo
        else:                                                  # toward zero
            mant = lo
        if mant >= 1 << 64:
            mant >>= 1
            e += 1
        return (mant, ((e + 16383) & 0x7fff) | (sign << 15))

    def _before(self, uc, address, size, user):
        op = self.OPS.get(struct.unpack('>H', bytes(uc.mem_read(address, 2)))[0])
        if op is None or address not in self.sites:
            return
        mp = self.mp
        mp.mp.prec = 200
        x, _ = self._value(*uc.reg_read(self._st(uc, 0)))
        y = None
        if op == 'fpatan':
            y, _ = self._value(*uc.reg_read(self._st(uc, 1)))
        self.pending = (address, op, x, y)

    def _after(self, uc, address, size, user):
        if self.pending is None or self.pending[0] != address - 2:
            return
        _, op, x, y = self.pending
        self.pending = None
        mp = self.mp
        mp.mp.prec = 200
        rc = (uc.reg_read(UC_X86_REG_FPCW) >> 10) & 3
        self.count[op] = self.count.get(op, 0) + 1
        if op == 'fsin':
            uc.reg_write(self._st(uc, 0), self._encode(mp.sin(x), rc))
        elif op == 'fcos':
            uc.reg_write(self._st(uc, 0), self._encode(mp.cos(x), rc))
        elif op == 'fsincos':      # ST0 = cos, ST1 = sin
            uc.reg_write(self._st(uc, 0), self._encode(mp.cos(x), rc))
            uc.reg_write(self._st(uc, 1), self._encode(mp.sin(x), rc))
        elif op == 'fptan':        # ST0 = 1.0, ST1 = tan
            uc.reg_write(self._st(uc, 1), self._encode(mp.tan(x), rc))
        elif op == 'fpatan':       # ST0 = atan2(ST1, ST0) after the pop
            uc.reg_write(self._st(uc, 0), self._encode(mp.atan2(y, x), rc))


def default_paths():
    s = os.environ.get('WG_SRC')
    return Path(s) if s else None


if __name__ == '__main__':
    track_dat, shared_dat = Path(sys.argv[1]), Path(sys.argv[2])
    m = TrackMachine()
    print('registered classes:', len(m.host.registry))
    m.add_dat(track_dat)
    m.add_dat(shared_dat)
    ptf = [n for n in m.files if n.endswith('.ptf')][0]
    root = m.load(m.files[ptf])
    print('root', hex(root), m.class_of.get(root), 'objects', len(m.root_objects), 'files opened', len(m.opened))
    n = m.build_track(root, arena=ARENA)
    print('sections', n, 'length', m.f32(TRACK_LENGTH), 'x87', m.x87.count, 'arena', hex(m.arena[1] - m.arena[0]))
