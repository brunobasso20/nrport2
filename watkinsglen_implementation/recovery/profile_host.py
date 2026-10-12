"""rts.dll ProfileManager / ProfileValue host for the Unicorn reference (track.ini loading by the ORIGINAL readers).

Transcribed from rts.dll (decompiled in recovery/evidence/rts/): ProfileValue::Initialize (100127b0) records the value
(file id, section, key, comment, save options); ProfileManager::Load (10010b50) = RestoreDefaults(file id), read the
file, FUN_10011790 parse: lines split at CR/LF, everything after ';' removed, leading white space skipped, '[name]'
selects a section (name trimmed, case-insensitive compare 100180e0), 'key = value' (key trimmed of trailing white space,
case-insensitive) -> value vtable +0x0c SetValue(text after '=', true), +0x24 SetFoundInFile(1), +0x28 (0); command
line overrides (10011410) are not used by the game binary here (no command line).

Value classes (exe template instances, vtables written by the static constructors of the boot):
  ProfileSingleValue<float, FLOAT_FORMAT>  vtable 006ed6e8: storage +0x22, default +0x26, current +0x2a
     SetValue 004029d0: sscanf(text, "%f", storage) != 1 -> storage = default; current = storage
     RestoreDefault 00402a10: storage = default
  ProfileCString<64> (exe instance)        vtable 006efa4c (SetValue 0040e880), ... every class's methods run as
  ORIGINAL code: Load only decides which methods are called, in the rts.dll order.
The exe's sscanf (006c4ac9) is in the encrypted CRT block: it is executed from server.exe (server_crt.py)."""
import struct

VT_FLOAT = 0x6ed6e8
INIT = '?Initialize@ProfileValue@@UAEXHQBD00W4SaveOption@1@1@Z'
UNINIT = '?Uninitialize@ProfileValue@@UAEXXZ'
LOAD = '?Load@ProfileManager@@SA?AW4success@@HQBD@Z'
WS = ' \t'


class ProfileHost:
    def __init__(self, m, crt, files):
        self.m, self.crt, self.files = m, crt, files
        self.values = []               # registration order (rts list order is per file / section / key tree)
        self.loads = []
        self.scripts = []
        m.stubs[INIT] = self._init
        m.stubs[UNINIT] = self._uninit
        if not hasattr(m, 'redirect_stubs'):
            m.redirect_stubs = {}
        m.redirect_stubs[LOAD] = self._load
        host = getattr(m, 'track_host', None)
        if host is not None:
            for k in (INIT, UNINIT):
                host.prefix[k[:60]] = m.stubs[k]

    def _args(self, esp, n):
        return struct.unpack('<%dI' % n, bytes(self.m.uc.mem_read(esp + 4, 4 * n)))

    def _init(self, m, esp):
        from unicorn.x86_const import UC_X86_REG_ECX
        this = m.uc.reg_read(UC_X86_REG_ECX)
        fid, sec, key, com, o1, o2 = self._args(esp, 6)
        m.w32(this + 4, fid); m.w32(this + 8, sec); m.w32(this + 0xc, key); m.w32(this + 0x10, com)
        m.w32(this + 0x14, o1); m.w32(this + 0x18, o2)
        m.uc.mem_write(this + 0x1c, b'\0'); m.w32(this + 0x1e, 0)
        self.values = [v for v in self.values if v != this] + [this]
        return 0, 24

    def _uninit(self, m, esp):
        from unicorn.x86_const import UC_X86_REG_ECX
        this = m.uc.reg_read(UC_X86_REG_ECX)
        self.values = [v for v in self.values if v != this]
        return 0, 0

    def _load(self, m, esp):
        """ProfileManager::Load(file id, name), cdecl. RestoreDefaults(file id) then the parsed key lines, each through
        the value's own ORIGINAL methods (vtable +0x10 RestoreDefault, +0x0c SetValue(text, true), +0x24
        SetFoundInFile(1), +0x28 (0)) run by a generated x86 call script (Unicorn cannot nest emu_start)."""
        from unicorn.x86_const import UC_X86_REG_ESP, UC_X86_REG_EIP, UC_X86_REG_EAX
        fid, name_ptr = self._args(esp, 2)
        name = m.cstr(name_ptr, 260).replace('\\', '/').split('/')[-1].lower()
        mine = [v for v in self.values if m.i32(v + 4) == fid]
        calls = [(v, 0x10, ()) for v in mine]
        data = self.files.get(name)
        self.loads.append((fid, name, data is not None))
        ok = 0
        if data is not None:
            ok = 1
            by = {}
            for v in mine:
                by.setdefault((m.cstr(m.u32(v + 8)).lower(), m.cstr(m.u32(v + 0xc)).lower()), v)
            section = None
            for line in data.decode('latin-1').replace('\r', '\n').split('\n'):
                line = line.split(';', 1)[0]
                s = line.lstrip(WS)
                if not s:
                    continue
                if s[0] == '[':
                    if ']' not in s:
                        continue
                    section = s[1:s.index(']')].strip(WS).lower()
                    continue
                if section is None or '=' not in s:
                    continue
                key, value = s.split('=', 1)
                v = by.get((section, key.rstrip(WS).lower()))
                if v is not None:
                    text = m.alloc(len(value) + 1, value.encode('latin-1') + b'\0')
                    calls += [(v, 0x0c, (text, 1)), (v, 0x24, (1,)), (v, 0x28, (0,))]
        code = b''
        for obj, slot, args in calls:
            for a in reversed(args):
                code += b'\x68' + struct.pack('<I', a)            # push imm32
            code += b'\xb9' + struct.pack('<I', obj)              # mov ecx, obj
            code += b'\x8b\x01'                                   # mov eax, [ecx]
            code += b'\xff\x50' + bytes([slot])                   # call [eax + slot]
        code += b'\xb8' + struct.pack('<I', ok) + b'\xc3'          # mov eax, ok ; ret
        script = m.alloc(len(code) + 16, code)
        self.scripts.append(script)
        m.uc.reg_write(UC_X86_REG_EIP, script)                # stack still [ret][fid][name]
        return None
