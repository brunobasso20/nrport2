"""nr2003carmodel original-code harness: ORIGINAL NR2003.exe / rendserv.dll functions executed in Unicorn.

NR2003.exe (Ghidra memory image, NR2003_MEM; boot = recovery/stage6_7/orig_vehicle.boot: CRT static initialisers,
_ftol / pow replacements of the encrypted CRT, taskGetRate 36):
  0056f040  gauge needle map                    005f6f20  Euler (h, p, r) -> row-major matrix
  005f74c0  matrix -> (h, p, r)                 00565b10  wheel-speed blur state
  00567e10  chase / on-car camera tables        00569b10  per-tick camera of one view (thiscall)
  stubs: 0051370a (track query of 005f58d0) and 005150fa (pit-lane table) -> no track loaded: 'ret' (cdecl).
rendserv.dll (RENDSERV_MEM = ExportMemoryPy of rendserv.dll):
  10011ec0  CompiledStateSwitch child selection 100118e0  CompiledLODSwitch level selection
  10012810  CompiledAnimatedTransform evaluation (keys, translation lerp, quaternion nlerp, 10028290 matrix)
Nothing here launches the game; inputs are synthetic and explicit."""
import math
import os
import struct
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parent.parent
sys.path.insert(0, str(REPO / "recovery" / "stage6_7"))
os.environ.setdefault("NR2003_MEM", "/opt/nrmem")
os.environ.setdefault("UNICORN_PY", "")
import orig_vehicle as OV  # noqa: E402
from nrx import UC_X86_REG_ECX  # noqa: E402,F401
from unicorn import Uc, UC_ARCH_X86, UC_MODE_32, UcError  # noqa: E402
from unicorn.x86_const import UC_X86_REG_ESP, UC_X86_REG_EAX, UC_X86_REG_EIP, UC_X86_REG_FPCW, UC_X86_REG_FP0  # noqa

CAR = 0xc12030
CAM_TABLE = 0xc57450          # on-car cameras (00568580 copy of the <model>.cam chunks), 6 x 9 floats per make


def f32(x):
    return struct.unpack("<f", struct.pack("<f", x))[0]


def x87(reg):
    """Unicorn FP register (mantissa, sign/exponent) -> Python float (exact for f32 results)"""
    mant, se = reg
    sign = -1.0 if se & 0x8000 else 1.0
    e = se & 0x7fff
    if e == 0 and mant == 0:
        return 0.0 * sign
    if e == 0x7fff:
        return float("nan") if mant & ((1 << 63) - 1) else sign * float("inf")
    return sign * math.ldexp(mant, e - 16383 - 63)


class Exe:
    def __init__(self):
        self.m = OV.boot()
        m = self.m
        m.patch_ret(0x51370a)            # track query (no track): outputs untouched, cdecl
        m.patch_ret(0x5150fa)            # track position query (pit-lane cameras), cdecl
        m.call(0x567e10)                 # ORIGINAL chase / on-car / pit / TV table initialisation
        # trampoline for x87 results: push [esp+8]; push [esp+8]; call target; add esp, 8; fstp dword [OUT]; ret
        self.out = m.alloc(16)
        self.tramps = {}                 # one trampoline per target (Unicorn caches translated blocks)

    def call_st0(self, target, a, b):
        m = self.m
        tramp = self.tramps.get(target)
        if tramp is None:
            tramp = self.tramps[target] = m.alloc(64)
            rel = target - (tramp + 8 + 5)
            code = (b"\xff\x74\x24\x08" b"\xff\x74\x24\x08" + b"\xe8" + struct.pack("<i", rel) +
                    b"\x83\xc4\x08" + b"\xd9\x1d" + struct.pack("<I", self.out) + b"\xc3")
            m.uc.mem_write(tramp, code)
        m.call(tramp, a, b)
        return m.f32(self.out)

    def wf(self, a, v): self.m.wf(a, v)
    def f(self, a): return self.m.f32(a)

    def gauge(self, cal, v):
        c = self.m.alloc(16, struct.pack("<4f", *cal))
        return self.call_st0(0x56f040, c, struct.unpack("<I", struct.pack("<f", v))[0])   # stored as f32 (vf2 arg)

    def euler(self, h, p, r):
        out = self.m.alloc(36)
        self.m.call(0x5f6f20, out, *[struct.unpack("<I", struct.pack("<f", x))[0] for x in (h, p, r)])
        return [self.f(out + 4 * i) for i in range(9)]

    def decompose(self, R):
        mat = self.m.alloc(36, struct.pack("<9f", *R))
        h, p, r = self.m.alloc(4), self.m.alloc(4), self.m.alloc(4)
        self.m.call(0x5f74c0, h, p, r, mat)
        return self.f(h), self.f(p), self.f(r)

    def wheel_speed(self, rate):
        return self.m.call(0x565b10, struct.unpack("<I", struct.pack("<f", rate))[0])

    def set_onboard(self, cams):
        """the <model>.cam chunk as 00568580 copies it (series 0, make 0 -> entries 0..5)"""
        order = ["Nose", "Gearbox", "On Car", "Roll Bar", "F Susp", "R Susp"]
        data = b"".join(struct.pack("<9f", *(cams[n]["pos"] + cams[n]["hpr"] + cams[n]["fov"])) for n in order)
        self.m.uc.mem_write(CAM_TABLE, data)

    def camera(self, mode, pos, R, head, head_pitch, head_roll, look=(0.0, 0.0, 0.0), heading=None):
        """00569b10 for one view: body block (+0x18 position, +0x58 matrix), car snapshot cells, look state
        (+0x34c eased, +0x350 sign, +0x354 analog). Returns eye, quaternion (x, y, z, w), matrix, fov triple, near."""
        m = self.m
        body = m.alloc(0x100)
        m.uc.mem_write(body + 0x18, struct.pack("<3f", *pos))
        m.uc.mem_write(body + 0x58, struct.pack("<9f", *R))
        m.w32(CAR + 0x5ae, body)
        m.w32(CAR + 4, CAR)              # race-order ring (00569b10 treats car+4 == 0 as 'no car')
        m.w32(CAR + 0x592, 0)
        m.w32(CAR + 0x596, 0)
        bh, bp, br = self.decompose(R)
        m.uc.mem_write(CAR + 0x1530, struct.pack("<3f", heading if heading is not None else bh, bp, br))
        m.uc.mem_write(CAR + 0x153c, struct.pack("<3f", *head))
        m.uc.mem_write(CAR + 0x154c, struct.pack("<2f", head_pitch, head_roll))
        this = m.alloc(0x400)
        m.w32(this + 0x0c, CAR)
        m.w32(this + 0x340, 0)
        m.uc.mem_write(this + 0x34c, struct.pack("<3f", *look))
        view = m.alloc(0x200)
        m.w32(view, mode)
        m.w32(view + 8, CAR)
        m.call(0x569b10, view, ecx=this)
        cam = view + 0x0c
        eye = [self.f(cam + 4 * i) for i in range(3)]
        q = [self.f(cam + 0x7c + 4 * i) for i in range(4)]
        fov = [self.f(view + 4 * i) for i in (0x29, 0x2a, 0x2b)]
        near = self.f(view + 4 * 0x2c)
        valid = m.uc.mem_read(view + 0x15e, 1)[0]
        return {"eye": eye, "quat": q, "fov": fov, "near": near, "valid": valid}


class Rendserv:
    """rendserv.dll image in its own Unicorn (base 0x10000000), plain cdecl / fastcall / thiscall calls"""
    HEAP, STACK, END = 0x20000000, 0x2f000000, 0x2f000ff0

    def __init__(self, mem=os.environ.get("RENDSERV_MEM", "/opt/rsmem")):
        uc = self.uc = Uc(UC_ARCH_X86, UC_MODE_32)
        uc.mem_map(0x10000000, 0x80000)
        for line in open(os.path.join(mem, "blocks.tsv")).read().splitlines()[1:]:
            name, start, size, init = line.split("\t")
            s = int(start, 16)
            if s >= 0xffdff000:
                continue
            p = os.path.join(mem, "%08x.bin" % s)
            if os.path.exists(p):
                uc.mem_write(s, open(p, "rb").read())
        uc.mem_map(self.HEAP, 0x1000000)
        uc.mem_map(self.STACK - 0x100000, 0x101000)
        self.heap = self.HEAP
        # renderer object stub (DAT_10042dc4 / DAT_10042244 vtables): +0x20 / +0x24 lod scale, +0x28 far value,
        # +0x154 lod floor -- given explicitly by the caller of lod()
        self.vt = self.alloc(0x200)
        self.renderer = self.alloc(16)
        self.w32(self.renderer, self.vt)
        self.code = self.alloc(0x100)

    def alloc(self, n, init=b""):
        a = self.heap
        self.heap += (n + 15) & ~15
        self.uc.mem_write(a, b"\0" * n)
        if init:
            self.uc.mem_write(a, init)
        return a

    def w32(self, a, v): self.uc.mem_write(a, struct.pack("<I", v & 0xffffffff))
    def wf(self, a, v): self.uc.mem_write(a, struct.pack("<f", v))
    def u32(self, a): return struct.unpack("<I", self.uc.mem_read(a, 4))[0]
    def f(self, a): return struct.unpack("<f", self.uc.mem_read(a, 4))[0]

    def call(self, addr, *args, ecx=None):
        sp = self.STACK - 0x1000
        self.uc.mem_write(sp, struct.pack("<" + "I" * (len(args) + 1), self.END, *[a & 0xffffffff for a in args]))
        self.uc.reg_write(UC_X86_REG_ESP, sp)
        if ecx is not None:
            self.uc.reg_write(UC_X86_REG_ECX, ecx)
        self.uc.reg_write(UC_X86_REG_FPCW, 0x027f)
        self.uc.emu_start(addr, self.END, count=2_000_000)
        return self.uc.reg_read(UC_X86_REG_EAX)

    def state_switch(self, values, v, integer=False):
        """10011ec0: object +0x2c -> variable (+0x38 value), +0x30 flag, +0x34 count, +0x38 values; pushes the blend
        fraction onto 10042a74[[10042ab4]++]"""
        var = self.alloc(0x40)
        self.wf(var + 0x38, v)
        vals = self.alloc(4 * len(values), struct.pack("<%df" % len(values), *values))
        obj = self.alloc(0x40)
        self.w32(obj + 0x2c, var)
        self.wf(obj + 0x30, 1.0 if integer else 0.0)
        self.w32(obj + 0x34, len(values) - 1)
        self.w32(obj + 0x38, vals)
        self.w32(0x10042ab4, 0)             # per-frame blend stack (10042a74[i]) index; the renderer resets it
        r = self.call(0x10011ec0, ecx=obj)
        return None if r == 0xffffffff else r

    def lod(self, distances, d, floor=0, far=1.0e30):
        """100118e0 (thiscall, float distance): +0x38 count, +0x3c thresholds (count + 1 slots, the last one written
        with the renderer's vf +0x28 value); renderer vf +0x154 = detail floor (10042244)"""
        n = len(distances)
        th = self.alloc(4 * (n + 1), struct.pack("<%df" % n, *distances))
        obj = self.alloc(0x50)
        self.w32(obj + 0x38, n)
        self.w32(obj + 0x3c, th)
        # vf +0x28 -> fld far ; ret   /  vf +0x154 -> mov eax, floor ; ret
        c1 = self.alloc(16, b"\xd9\x05" + struct.pack("<I", self.code) + b"\xc3")
        self.wf(self.code, far)
        c2 = self.alloc(16, b"\xb8" + struct.pack("<I", floor & 0xffffffff) + b"\xc3")
        self.w32(self.vt + 0x28, c1)
        self.w32(self.vt + 0x154, c2)
        self.w32(0x10042dc4, self.renderer)
        self.w32(0x10042244, self.renderer)
        self.w32(0x10042a1c, 0)
        return self.call(0x100118e0, struct.unpack("<I", struct.pack("<f", d))[0], ecx=obj)

    def animated(self, keys, t):
        """10012810: +0x74 variable (+0x38 time), +0x78 key count, +0x7c keys (8 floats: time, q x y z w, t x y z);
        outputs +0x44 translation, +0x50 matrix (10028290)"""
        var = self.alloc(0x40)
        self.wf(var + 0x38, t)
        raw = b"".join(struct.pack("<8f", float(k[0]), *k[1], *k[2]) for k in keys)
        kp = self.alloc(len(raw), raw)
        obj = self.alloc(0x100)
        self.w32(obj + 0x74, var)
        self.w32(obj + 0x78, len(keys))
        self.w32(obj + 0x7c, kp)
        self.call(0x10012810, ecx=obj)
        return [self.f(obj + 0x44 + 4 * i) for i in range(3)], [self.f(obj + 0x50 + 4 * i) for i in range(9)]


def camera_render(E, mode, pos, R, head, head_pitch, head_roll, look=0.0, analog=0.0):
    """0056a9a0 (the RENDER path that sets the frame's camera): arg1 camera out, arg2 mirror camera (0), arg3 the
    focus car draw object (vtable +0x14 -> body record: position at +0 and +0x18, matrix at +0x58; draw record slot
    drawobj + 0xf8 with [ebbd78] = 0 and [ebbd84] = 0: no interpolation), arg4 view (+0xc mode, +0x10 car),
    arg5 car index. Look state = the view block of 0056b720 (view + 0x1c): [0] = sign * eased, [7] = analog axis."""
    m = E.m
    body = m.alloc(0x100)
    m.uc.mem_write(body, struct.pack("<3f", *pos))
    m.uc.mem_write(body + 0x18, struct.pack("<3f", *pos))
    m.uc.mem_write(body + 0x58, struct.pack("<9f", *R))
    getter = m.alloc(16, b"\xb8" + struct.pack("<I", body) + b"\xc3")
    vt = m.alloc(0x40)
    m.w32(vt + 0x14, getter)
    drawobj = m.alloc(0x400)
    m.w32(drawobj, vt)
    m.w32(0xebbd78, 0)
    m.w32(0xebbd84, 0)
    rec = drawobj + 0xf8
    m.uc.mem_write(rec + 0xc0, struct.pack("<3f", *head))
    m.uc.mem_write(rec + 0xd0, struct.pack("<2f", head_pitch, head_roll))
    m.w32(CAR + 0x592, 0)
    m.w32(CAR + 0x596, 0)
    view = m.alloc(0x80)
    m.w32(view + 0xc, mode)
    m.w32(view + 0x10, CAR)
    lookp = view + 0x1c                     # 0056b720: view + 0x1c + [ebbd78] * 0x20 (block filled by 0056b8a0)
    m.uc.mem_write(lookp, struct.pack("<f", look))
    m.uc.mem_write(lookp + 0x1c, struct.pack("<f", analog))
    cam = m.alloc(0x100)
    m.call(0x56a9a0, cam, 0, drawobj, view, 0)
    eye = [E.f(cam + 4 * i) for i in range(3)]
    q = [E.f(cam + 0x7c + 4 * i) for i in range(4)]
    fov = [E.f(cam + 0x98 + 4 * i) for i in range(3)]
    return {"eye": eye, "quat": q, "fov": fov, "near": E.f(cam + 0xa4), "lookPtr": lookp}


def quat_matrix(q):
    x, y, z, w = q
    return [2 * x * x + 2 * w * w - 1, 2 * x * y - 2 * w * z, 2 * x * z + 2 * w * y,
            2 * x * y + 2 * w * z, 2 * y * y + 2 * w * w - 1, 2 * y * z - 2 * w * x,
            2 * x * z - 2 * w * y, 2 * y * z + 2 * w * x, 2 * z * z + 2 * w * w - 1]
