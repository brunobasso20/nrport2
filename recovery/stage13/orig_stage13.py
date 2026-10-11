"""Stage 13 original-code harness: the ORIGINAL NR2003 force feedback executed in Unicorn.

Extends the Stage 12 harness (orig_stage12.OriginalStage12 -> orig_stage11 -> stage9 -> stage8 -> stage6_7). Everything of
the force feedback that belongs to the simulation is the ORIGINAL code running in place:

  00554d30   per tick inside the ORIGINAL 005539c0 (@00553a64), as in every earlier stage (it was always executed by the
             harness; the Luau port did not run it until Stage 13)
  00554520   frame end, ORIGINAL, whole function incl. the FFB block 0055464c..0055479d (gate bf6ebb / bf6eb8)
  00550070   player controls active / suspended (bf6eb8) -> 0054fed0 FF axis setup from the control-7 binding (0057b1e0 ->
             0057aff0), 00550030 zero force; run at car placement (00550a50 @00550b07), on suspension events and when the
             host device layer re-binds control 7 (the game's controls menu -> fgmsgSelectActiveControls)
  00550270 / 00550290 / 005502d0 / 005502b0   FF option setters (messages 8..11), called with the controls.cfg conversion
             of 0043f1d0 (fild int ; fstp dword)

Host device layer (ADAPTER, the DirectInput module 005d0xxx / 005d2xxx; identical decisions in NR2003CupFFB):
  005f79a0 bgRequestFGAction    -> jmp 005f79de: the request is served at once by the function's own direct path (the
                                   foreground thread runs 00550000 / 00550060 while the simulation thread waits)
  005d0820(axis) FF supported   -> host byte HCAP
  005d0840(axis) acquire        -> HCAP && HACQ: sets HEFF (f5d414 'effect acquired') and returns 1, else 0
  005d0870(axis) release        -> HCAP: clears HEFF
  005d08d0(axis, force)         -> 'ret' (Stage 11 stub) + a code hook logging every call (axis, force bits): the value the
                                   ORIGINAL code hands to DirectInput (005d3010: _ftol(force * 10000) on the effect)
The stubs are written right after boot, before any code executes (Unicorn keeps translated blocks)."""
import sys, struct, math
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent / 'stage12'))
import orig_stage12 as O12            # noqa: E402  (patches boot: Stage 11 + Stage 12 stubs)
from orig_stage12 import *            # noqa: F401,F403,E402
import orig_stage11 as O11            # noqa: E402
import orig_runtime as _OR            # noqa: E402
from orig_runtime import _w          # noqa: E402
from unicorn import UC_HOOK_CODE      # noqa: E402

HDEV = 0xf7a900                       # harness-only host bytes (unreferenced BSS above the Stage 11 host blocks)
HCAP, HACQ, HEFF = HDEV, HDEV + 1, HDEV + 2
FG_DIRECT = 0x5f79de
SUSPENDED, ACQUIRED, AXIS, DIRSIGN = 0xbf6eb8, 0xbf6ebb, 0xbf6ebc, 0x74c95c
FF_ON, STRENGTH, DAMPING, LATENCY = 0xbf6f1c, 0x74c9a4, 0xbf6f24, 0xbf6f20
REC7 = 0xd37cb8 + 29 * 7
FFB_CELLS = [(0x74c95c, 0x18), (0xbf6eb8, 0x3c), (0xbf6f1c, 4), (0xbf6f20, 8), (0x74c9a4, 4)]


def _p(a): return struct.pack('<I', a)


def _stubs13():
    s = {}
    s[0x5f79a0] = b'\xe9' + struct.pack('<i', FG_DIRECT - (0x5f79a0 + 5))
    s[0x5d0820] = b'\xa0' + _p(HCAP) + b'\xc3'
    # mov al,[HCAP] ; test ; jz fail ; mov al,[HACQ] ; test ; jz fail ; mov byte [HEFF],1 ; mov eax,1 ; ret ; fail: xor eax,eax ; ret
    s[0x5d0840] = (b'\xa0' + _p(HCAP) + b'\x84\xc0' + b'\x74\x16' + b'\xa0' + _p(HACQ) + b'\x84\xc0' + b'\x74\x0d' +
                   b'\xc6\x05' + _p(HEFF) + b'\x01' + b'\xb8\x01\x00\x00\x00' + b'\xc3' + b'\x31\xc0\xc3')
    s[0x5d0870] = b'\xa0' + _p(HCAP) + b'\x84\xc0' + b'\x74\x07' + b'\xc6\x05' + _p(HEFF) + b'\x00' + b'\xc3'
    return s


def _hooks(m):
    m.ffb_log = []
    def cb(uc, addr, size, user):
        esp = uc.reg_read(UC_X86_REG_ESP)
        a = struct.unpack('<I', uc.mem_read(esp + 4, 4))[0]
        if addr == 0x5d08d0:
            m.ffb_log.append(('force', a, struct.unpack('<I', uc.mem_read(esp + 8, 4))[0]))
        elif addr == 0x5d0840:
            m.ffb_log.append(('acquire', a))
        else:
            m.ffb_log.append(('release', a))
    for a in (0x5d08d0, 0x5d0840, 0x5d0870): m.uc.hook_add(UC_HOOK_CODE, cb, begin=a, end=a)


_boot12 = _OR.boot


def _boot_stage13(*a, **k):
    m = _boot12(*a, **k)
    for a_, code in _stubs13().items(): m.uc.mem_write(a_, code)
    m.uc.mem_write(HDEV, b'\0' * 4)
    _hooks(m)
    return m
_OR.boot = _boot_stage13


def u8(m, a): return m.uc.mem_read(a, 1)[0]
def w8(m, a, v): m.uc.mem_write(a, bytes([v & 0xff]))


def set_device(m, dev):
    """host device layer: dev = {capable, acquire} (NR2003CupFFB.setForceFeedbackDevice)"""
    dev = dev or {}
    w8(m, HCAP, 1 if dev.get('capable') else 0)
    w8(m, HACQ, 0 if dev.get('acquire') is False else 1)


def cfg_float(v, hi):
    """controls.cfg integer -> message payload (0043f1d0: fild dword ; fstp dword), front-end range 0..hi"""
    return u32f(float(max(0, min(hi, int(math.floor(v))))))


def set_ffb_options(m, o):
    """ORIGINAL setters of messages 8..11 (00550270 / 00550290 / 005502d0 / 005502b0)"""
    if o.get('enabled') is not None: m.call(0x550270, 1 if o['enabled'] else 0)
    if o.get('strength') is not None: m.call(0x550290, cfg_float(o['strength'], 100))
    if o.get('damping') is not None: m.call(0x5502d0, cfg_float(o['damping'], 100))
    if o.get('latency') is not None: m.call(0x5502b0, cfg_float(o['latency'], 250))


def enter_track13(o):
    """ORIGINAL 00550a50 subset (Stage 11 enter_track) + 00550070(0) at its place (@00550b07: after car+0x1518 = 0,
    before 005500b0(0) -> bf6eb9 = 0)"""
    m = o.m
    assert m.u32(0xbf63c4) == 0
    O11.ensure_world_record(m)
    m.call(0x563080, O11.CAR, 1)
    m.call(0x550c40)
    m.call(0x550c60)
    m.call(0x5512d0)
    m.w32(O11.CAR + 0x1518, 0)
    o.controls(0)
    m.uc.mem_write(0xbf6eb9, b'\x00')


def steer_frame13(o, c, shaped=None):
    """orig_stage12.steer_frame + Stage 13: the 005524f0 not-driven branch while bf6eb8 (controls suspended) is set, and
    the host device layer's re-binding of control 7 followed by 00550070(0) (as NR2003CupFFB's V._steerDevices)"""
    m = o.m
    m.w32(INTCOUNT, (m.u32(INTCOUNT) + 1) & 0xffffffff)
    driven = c.get('driver', True) is not False and u8(m, SUSPENDED) == 0
    if not driven:
        for a in NOT_DRIVEN: m.w32(a, 0)
        m.w32(0xbf6eac, 0x3f800000)
        m.uc.mem_write(0xbf6e20, b'\0\0\0')
    else:
        if 'brakeControl' in c:
            OB.control_cells(m, OB.BRAKE_CTL, c['brakeControl'], c.get('brakeDigital', True))
            OB.control_cells(m, OB.THROTTLE_CTL, c.get('throttleControl', c.get('throttle', 0.0)), c.get('throttleDigital', True))
            if m.uc.mem_read(0xbf6eb9, 1)[0]:
                m.w32(0xbf6eac, 0x3f800000); m.w32(0xbf6eb0, 0)
            else:
                m.call(OB.STUBADDR)
                _w(m, 0xbf6eb0, c.get('clutch', 0.0))
        else:
            _w(m, 0xbf6eac, c.get('brake', 0.0))
            _w(m, 0xbf6eb0, c.get('clutch', 0.0))
        host_steer_devices(m, c)
        m.call(STEERSTUB)
        if m.i32(REC7 + 0x10) != o.configured_kind and (u8(m, FF_ON) or u8(m, ACQUIRED)):
            o.controls(0)
        _w(m, 0xbf6390, c.get('throttle', 0.0))
    run_tail(m, shaped)
    if driven and m.i32(0xbf6f0c) != 2 and m.i32(0xbf63cc) == 0 and m.i32(0x74c974) != 0 and m.i32(0xbf6f0c) == 0:
        d = (1 if c.get('shiftUp') else 0) - (1 if c.get('shiftDown') else 0)
        if d != 0 and m.i32(0xbf6ea0) in (0, 3, 4):
            m.w32(0xbf63cc, 1 if d > 0 else 5); m.w32(0xbf6e98, 0)


class OriginalStage13(O12.OriginalStage12):
    """OriginalStage12 + the ORIGINAL force feedback. ffb = options {enabled, strength, damping, latency} (controls.cfg
    integers; None = image values), device = {capable, acquire} (host). Order as the Luau test: steering options / setup
    ratio (Stage 12), device, FF options (+ 00550070 with the current flag, as setForceFeedbackOptions), car placement."""
    def __init__(self, *a, ffb=None, device=None, enter=True, **k):
        super().__init__(*a, enter=False, **k)
        m = self.m
        self.configured_kind = None
        set_device(m, device)
        if ffb is not None:
            set_ffb_options(m, ffb)
            self.controls(u8(m, SUSPENDED))
        if enter and self.stage11: enter_track13(self)

    def controls(self, flag):
        """ORIGINAL 00550070(flag)"""
        if flag == 0: self.configured_kind = self.m.i32(REC7 + 0x10)
        self.m.call(0x550070, flag & 0xff)

    def frame(self, c):
        if self.steering != 'original':
            return O12.OriginalStage12.frame(self, c)
        m = self.m
        if self.stage11:
            m.w32(O11.BGCOUNT, (m.u32(O11.BGCOUNT) + 1) & 0xffffffff)
        O11.frame_airspeed(m)
        steer_frame13(self, c, self.shaped)


# ------------------------------------------------------------------------------------------- function-level helpers
FFB_BLOCK, FFB_BLOCK_END = 0x55464c, 0x554778


def run_ffb_block(m):
    """the ORIGINAL FFB block 0055464c..00554778 executed in place on a scratch frame (the block pops EDI / ESI saved by
    00554520 and uses the 0x10-byte local frame below them); stops before 'add esp,0x10 ; ret'"""
    from unicorn.x86_const import UC_X86_REG_ESP, UC_X86_REG_EBP, UC_X86_REG_FPCW, UC_X86_REG_EIP
    uc = m.uc
    uc.ctl_remove_cache(FFB_BLOCK, FFB_BLOCK_END + 0x10)
    sp = STACK_TOP - 0x3000
    uc.mem_write(sp, b'\0' * 0x40)
    uc.reg_write(UC_X86_REG_ESP, sp); uc.reg_write(UC_X86_REG_EBP, sp + 0x800)
    uc.reg_write(UC_X86_REG_FPCW, m.fpcw)
    uc.emu_start(FFB_BLOCK, FFB_BLOCK_END, count=200000)
    eip = uc.reg_read(UC_X86_REG_EIP)
    if eip != FFB_BLOCK_END: raise RuntimeError('FFB block stopped at %08x' % eip)
