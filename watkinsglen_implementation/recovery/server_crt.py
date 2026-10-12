"""Exact MSVC CRT sscanf of the NR2003 build, executed from server.exe (same Ghidra project, same CRT, unencrypted).

NR2003.exe's CRT block is SecuROM-encrypted in the static image (sscanf 006c4ac9); server.exe carries the identical CRT at
NR2003 address - 0x4f0 (sscanf 006c45d9). The INI values (ProfileSingleValue<float>::SetValue 004029d0 ->
sscanf(value, "%f", ptr)) and every other sscanf of the track code are evaluated by running server.exe's own sscanf on a
second Unicorn machine (SERVER_MEM = ExportMemoryPy.py output of server.exe)."""
import os
import struct
from pathlib import Path
from unicorn import Uc, UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE, UC_HOOK_MEM_UNMAPPED, UcError
from unicorn.x86_const import UC_X86_REG_ESP, UC_X86_REG_EAX, UC_X86_REG_EIP, UC_X86_REG_FPCW

SSCANF = 0x6c45d9
STACK, HEAP, END = 0x2f000000, 0x30000000, 0x2f0ff000
OUTSZ = 0x200


class ServerCRT:
    def __init__(self, mem=None):
        mem = Path(mem or os.environ['SERVER_MEM'])
        uc = self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        uc.mem_map(0x400000, 0xc00000)
        for line in (mem / 'blocks.tsv').read_text().splitlines()[1:]:
            name, start, size, init = line.split('\t')
            start = int(start, 16)
            if start >= 0xffdff000:
                continue
            p = mem / ('%08x.bin' % start)
            if p.exists():
                uc.mem_write(start, p.read_bytes())
        uc.mem_map(STACK, 0x100000)
        uc.mem_map(HEAP, 0x100000)
        uc.mem_map(0xffdff000, 0x1000)
        # _cfltcvt_init (006c498a, run by the CRT startup through _fpmath): _cfltcvt_tab = {_cfltcvt, _cropzeros,
        # _fassign, _forcdecpt, _positive, _cldcvt} (the static image still holds _fptrap)
        self.call(0x6c498a)

    def call(self, address):
        uc = self.uc
        sp = STACK + 0x80000
        uc.mem_write(sp, struct.pack('<I', END))
        uc.reg_write(UC_X86_REG_ESP, sp)
        uc.emu_start(address, END, count=1_000_000)

    def sscanf(self, text, fmt, kinds, cw=0x027f):
        """kinds: 'f' (float*), 'd' (int*), 'lf' (double*) per conversion; returns (count, values)"""
        uc = self.uc
        s = HEAP
        uc.mem_write(s, text.encode('latin-1') + b'\0')
        f = s + 0x1000
        uc.mem_write(f, fmt.encode('latin-1') + b'\0')
        outs = [s + 0x2000 + OUTSZ * i for i in range(len(kinds))]
        for o in outs:
            uc.mem_write(o, b'\0' * OUTSZ)
        sp = STACK + 0x80000
        uc.mem_write(sp, struct.pack('<%dI' % (3 + len(outs)), END, s, f, *outs))
        uc.reg_write(UC_X86_REG_ESP, sp)
        uc.reg_write(UC_X86_REG_FPCW, cw)
        try:
            uc.emu_start(SSCANF, END, count=5_000_000)
        except UcError as e:
            raise RuntimeError('server sscanf failed at %08x: %s' % (uc.reg_read(UC_X86_REG_EIP), e))
        n = uc.reg_read(UC_X86_REG_EAX)
        vals = []
        for k, o in zip(kinds, outs):
            b = bytes(uc.mem_read(o, 8))
            if k == 's':
                vals.append(bytes(uc.mem_read(o, OUTSZ)).split(b'\0', 1)[0] + b'\0')
            elif k == 'c':
                vals.append(b[:1])
            else:
                vals.append(struct.unpack('<f', b[:4])[0] if k == 'f' else struct.unpack('<d', b)[0] if k == 'lf'
                            else struct.unpack('<i', b[:4])[0])
        return n if n < 0x80000000 else n - (1 << 32), vals

    def raw(self, text, fmt, nbytes):
        """sscanf with one output of nbytes raw bytes (bit-exact)."""
        n, _ = self.sscanf(text, fmt, ['d'])
        return n, bytes(self.uc.mem_read(HEAP + 0x2000, nbytes))
