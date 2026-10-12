"""Replacements for the SecuROM-encrypted MSVC CRT routines of NR2003.exe (006c4ac9..006d8000) used by the track code.

The NR2003.exe CRT block is encrypted in the static image; server.exe of the same Ghidra project carries the SAME CRT
unencrypted at a constant offset (NR2003 address - 0x4f0: __ftol 006c5018 <-> 006c4b28, _CIsin 006c6d40 <-> 006c6850,
_CIcos 006c6df0 <-> 006c6900, __CIsqrt 006c6ea0 <-> 006c69b0, __chkstk 006c5af0 <-> 006c5600, _strncpy 006c4b00 <->
006c4610, _strncat 006c5260 <-> 006c4d70, sprintf 006c4ac9 <-> 006c45d9, _stricmp 006c6530 <-> 006c6040, _CIacos 006c72b0
<-> 006c6dc0, atexit 006c4f40 <-> 006c4a50, is*() through server.exe's ctype table). The replacements below transcribe the
server.exe code (evidence: recovery/evidence/crt/):

  _CIsin / _CIcos (x87 "default" path): push edx; fnstcw [esp]; if CW != 0x027f: fldcw [0x027f]; fsin|fcos;
      (finite argument, |x| < 2^63: no fprem1 loop); fldcw [esp] (restore); pop edx; ret.
      FSIN/FCOS are not affected by precision control: ST0 = 64-bit significand rounded to nearest; the caller's
      FSTP rounds it with the caller's CW.
  __CIsqrt: push edx; fnstcw [esp]; if CW != 0x027f: CW' = (CW & 0x300) | 0x7f (caller precision, RC nearest);
      fsqrt; restore CW; pop edx; ret.
  __ftol: truncating FISTP qword (the Stage 6/7 FTOL_X87 replacement, recovery/stage6_7/orig_vehicle.py).
  __chkstk: probe + ESP -= EAX (as server.exe 006c5600).
Error-handler branches (NaN / infinity arguments, negative sqrt) are not reproduced: the guard raises if one is needed.
"""
import struct
from unicorn import UC_HOOK_CODE
from unicorn.x86_const import UC_X86_REG_EAX, UC_X86_REG_ESP, UC_X86_REG_EIP, UC_X86_REG_FPSW, UC_X86_REG_FP0

CW027F = 0x6c3990          # unused bytes right after the import thunk table of the image hold the constant

FTOL = bytes.fromhex('83ec0c d97c2408 668b442408 80cc0c 668944240a d96c240a df3c24 d96c2408 8b0424 8b542404 83c40c c3'
                     .replace(' ', ''))
CHKSTK = bytes.fromhex('51 3d00100000 8d4c2408 7214 81e900100000 2d00100000 8501 3d00100000 73ec 29c1 89e0 8501 89cc'
                       ' 8b08 8b4004 50 c3'.replace(' ', ''))


def _trig(op):
    # push edx; fnstcw [esp]; cmp word [esp],0x27f; je +6; fldcw [CW027F]; op; fldcw [esp]; pop edx; ret
    return (b'\x52\xd9\x3c\x24' + b'\x66\x81\x3c\x24\x7f\x02' + b'\x74\x06' + b'\xd9\x2d' + struct.pack('<I', CW027F)
            + op + b'\xd9\x2c\x24' + b'\x5a\xc3')


CISIN = _trig(b'\xd9\xfe')
CICOS = _trig(b'\xd9\xff')
# push edx; fnstcw [esp]; cmp word [esp],0x27f; je skip; sub esp,4; mov eax,[esp+4]; and eax,0x300; or eax,0x7f;
# mov [esp],eax; fldcw [esp]; add esp,4; skip: fsqrt; fldcw [esp]; pop edx; ret
CISQRT = (b'\x52\xd9\x3c\x24' + b'\x66\x81\x3c\x24\x7f\x02' + b'\x74\x18'
          + b'\x83\xec\x04\x8b\x44\x24\x04\x25\x00\x03\x00\x00\x83\xc8\x7f\x89\x04\x24\xd9\x2c\x24\x83\xc4\x04'
          + b'\xd9\xfa\xd9\x2c\x24\x5a\xc3')

# _CIacos (server.exe 006c6dc0 -> 006c6ddd), |x| < 1 path: CW' as __CIsqrt; fld1; fadd st,st(1); fld1; fsub st,st(2);
# fmulp; fsqrt; fxch; fpatan (= atan2(sqrt((1+x)(1-x)), x)); restore CW. |x| >= 1 (exact +-1 -> 0 / pi, domain error)
# is guarded by the caller's data (the Python check below raises if reached).
CIACOS = (b'\x52\xd9\x3c\x24' + b'\x66\x81\x3c\x24\x7f\x02' + b'\x74\x18'
          + b'\x83\xec\x04\x8b\x44\x24\x04\x25\x00\x03\x00\x00\x83\xc8\x7f\x89\x04\x24\xd9\x2c\x24\x83\xc4\x04'
          + b'\xd9\xe8\xd8\xc1\xd9\xe8\xd8\xe2\xde\xc9\xd9\xfa\xd9\xc9\xd9\xf3' + b'\xd9\x2c\x24\x5a\xc3')

CODE = {0x6c72b0: CIACOS, 0x6c5018: FTOL, 0x6c5af0: CHKSTK, 0x6c6d40: CISIN, 0x6c6df0: CICOS, 0x6c6ea0: CISQRT}
ENCRYPTED = (0x6c3990, 0x6d8000)


def install(m, allow=(), extra=None, server=None):
    """Writes the x86 replacements and the Python ones; any other entry into the encrypted CRT block raises."""
    m.uc.mem_write(CW027F, struct.pack('<H', 0x027f))
    for a, code in CODE.items():
        m.uc.mem_write(a, code)
    py = {0x6c4b00: _strncpy, 0x6c5260: _strncat, 0x6c79d2: _isnan, 0x6c6530: _stricmp, 0x6c4f81: _sprintf,
          0x6c4f40: _atexit}
    py.update(extra or {})
    spans = sorted([(a, a + len(c)) for a, c in CODE.items()] + list(allow))

    def guard(uc, address, size, user):
        for a, b in spans:
            if a <= address < b:
                return
        if address == CW027F:
            return
        if address == 0x6c72b0:
            top = (uc.reg_read(UC_X86_REG_FPSW) >> 11) & 7
            mant, se = uc.reg_read(UC_X86_REG_FP0 + top)
            if (se & 0x7fff) >= 0x3fff:
                raise RuntimeError('_CIacos argument |x| >= 1: special path not reproduced')
            return
        f = py.get(address)
        if f is None and server is not None:
            f = _ctype_from_server(server, address)
            if f is not None:
                py[address] = f
        if f is None:
            raise RuntimeError('encrypted CRT routine %08x reached (server.exe %08x): not replaced'
                               % (address, address - 0x4f0))
        esp = uc.reg_read(UC_X86_REG_ESP)
        ret = struct.unpack('<I', bytes(uc.mem_read(esp, 4)))[0]
        args = struct.unpack('<4I', bytes(uc.mem_read(esp + 4, 16)))
        uc.reg_write(UC_X86_REG_EAX, f(m, args) & 0xffffffff)
        uc.reg_write(UC_X86_REG_ESP, esp + 4)          # cdecl
        uc.reg_write(UC_X86_REG_EIP, ret)
    m.uc.hook_add(UC_HOOK_CODE, guard, begin=ENCRYPTED[0], end=ENCRYPTED[1] - 1)
    # the machine may already have translated (and cached) the encrypted bytes: drop the translation cache
    m.uc.ctl_flush_tb()


def _strncpy(m, a):
    dst, src, n = a[0], a[1], a[2]
    s = bytes(m.uc.mem_read(src, n)).split(b'\0', 1)[0]
    m.uc.mem_write(dst, (s + b'\0' * n)[:n])
    return dst


def _strncat(m, a):
    dst, src, n = a[0], a[1], a[2]
    d = m.cstr(dst, 4096).encode('latin-1')
    s = bytes(m.uc.mem_read(src, n)).split(b'\0', 1)[0][:n]
    m.uc.mem_write(dst + len(d), s + b'\0')
    return dst


def _isnan(m, a):
    """server.exe 006c74e2 (_isnan): 1 when the double argument is a NaN (infinities give 0)."""
    lo, hi = a[0], a[1]
    return 1 if (hi & 0x7ff00000) == 0x7ff00000 and ((hi & 0xfffff) or lo) else 0


def _stricmp(m, a):
    """server.exe 006c6040, C-locale path: ASCII A-Z folded to lower case, result -1 / 0 / 1."""
    s1, s2 = m.cstr(a[0], 4096).encode('latin-1'), m.cstr(a[1], 4096).encode('latin-1')
    low = lambda c: c + 0x20 if 0x41 <= c <= 0x5a else c
    for x, y in zip(s1 + b'\0', s2 + b'\0'):
        x, y = low(x), low(y)
        if x != y:
            return -1 if x < y else 1
        if x == 0:
            break
    return 0


def _sprintf(m, a):
    """server.exe 006c4a91 (sprintf), the conversions used by the track code (%d %i %u %x %s %c, optional width / '0');
    any other conversion raises."""
    import re
    buf, fmt = a[0], m.cstr(a[1], 1024)
    esp_args = list(struct.unpack('<16I', bytes(m.uc.mem_read(m.uc.reg_read(UC_X86_REG_ESP) + 12, 64))))
    out, i, k = [], 0, 0
    for mt in re.finditer(r'%(-?0?\d*)([diuxXsc%])', fmt):
        out.append(fmt[i:mt.start()])
        flags, conv = mt.group(1), mt.group(2)
        if conv == '%':
            out.append('%')
        else:
            v = esp_args[k]; k += 1
            if conv in 'di':
                v = v - (1 << 32) if v >= 0x80000000 else v
                out.append(('%' + flags + 'd') % v)
            elif conv == 'u':
                out.append(('%' + flags + 'd') % v)
            elif conv in 'xX':
                out.append(('%' + flags + conv) % v)
            elif conv == 's':
                out.append(('%' + flags + 's') % m.cstr(v, 1024))
            else:
                out.append(chr(v & 0xff))
        i = mt.end()
    out.append(fmt[i:])
    rest = ''.join(out)
    if '%' in fmt.replace('%%', '') and len(re.findall(r'%', fmt)) != len(re.findall(r'%(-?0?\d*)([diuxXsc%])', fmt)):
        raise RuntimeError('sprintf format not transcribed: %r' % fmt)
    m.uc.mem_write(buf, rest.encode('latin-1') + b'\0')
    return len(rest)


def sscanf_server(crt):
    """006c4ac9 sscanf executed by server.exe's identical CRT (server_crt.ServerCRT); outputs copied byte-exact."""
    import re

    def f(m, a):
        text, fmt = m.cstr(a[0], 4096), m.cstr(a[1], 1024)
        convs = re.findall(r'%(\*?)(\d*)(l?)([dfsieguxc])', fmt)
        outs = list(struct.unpack('<16I', bytes(m.uc.mem_read(m.uc.reg_read(UC_X86_REG_ESP) + 12, 64))))
        kinds = []
        for star, width, l, c in convs:
            if star:
                continue
            if c == 'c' and width not in ('', '1'):
                raise RuntimeError('sscanf %%%sc not transcribed: %r' % (width, fmt))
            kinds.append('s' if c == 's' else 'c' if c == 'c' else
                         'lf' if (l and c in 'feg') else 'f' if c in 'feg' else 'd')
        n, vals = crt.sscanf(text, fmt, kinds)
        from server_crt import HEAP, OUTSZ
        for j, kd in enumerate(kinds[:max(n, 0)]):
            if kd in ('s', 'c'):
                m.uc.mem_write(outs[j], vals[j])
                continue
            size = 8 if kd == 'lf' else 4
            m.uc.mem_write(outs[j], bytes(crt.uc.mem_read(HEAP + 0x2000 + OUTSZ * j, size)))
        return n & 0xffffffff
    return f


def _ctype_from_server(crt, address):
    """is*() of the encrypted block: the server.exe counterpart (address - 0x4f0) is
    'cmp [__mb_cur_max],1 ; jle ; push MASK ; push [esp+8] ; call _isctype ; ... ; mov eax,[_pctype]; movzx/ mov ax,[eax+c*2];
    and eax, MASK'. Answered from server.exe's C-locale table (_pctype -> 0x75c2c0 pointer), as the single-byte path."""
    code = bytes(crt.uc.mem_read(address - 0x4f0, 40))
    if code[:2] != b'\x83\x3d' or code[6] != 1 or code[7] != 0x7e or code[9] != 0x68 and code[9] != 0x6a:
        return None
    mask = code[10] if code[9] == 0x6a else struct.unpack('<I', code[10:14])[0]
    pctype = struct.unpack('<I', bytes(crt.uc.mem_read(0x75c2c0, 4)))[0]

    def f(m, a):
        c = a[0] & 0xffffffff
        c = c - (1 << 32) if c >= 0x80000000 else c
        w = struct.unpack('<H', bytes(crt.uc.mem_read(pctype + 2 * c, 2)))[0]
        return w & mask
    return f


def _atexit(m, a):
    """server.exe 006c4a50 (atexit -> _onexit table 006c49d2): the cleanup is recorded, 0 = registered."""
    m.atexit = getattr(m, 'atexit', []) + [a[0]]
    return 0
