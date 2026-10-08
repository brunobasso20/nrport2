"""Stage 12 original-code harness: the ORIGINAL NR2003 steering chain executed in Unicorn.

Extends the Stage 11 harness (orig_stage11.OriginalStage11 -> stage9 OriginalAero -> stage8 OriginalBrake -> stage6_7
OriginalDriver). Until Stage 11 the frame start of the player car was a Python hand port of the 00551e80 tail with a
PROVISIONAL road-wheel target supplied by the host. Here the frame start runs the ORIGINAL code of the steering chain:

  005524f0 player branch   Stage 8 brake subset (ORIGINAL 00553080 through STUBADDR), clutch / throttle host values
                           (the device processing 005534f0 / 00552df0 is not ported, as in Stages 7-11), and
                           bf63c8 = ORIGINAL 00552720()  (STEERSTUB: call 00552720 ; fstp dword [bf63c8] ; ret)
                             -> 00554f50 speed, 00552410 linearity, 00552d00(8) / 00552d00(7) slew + sin shaping,
                                0055a770 / 00550230 aids gates (race settings 0055a680 = c0692a)
  00551e80 tail            the ORIGINAL instructions 00552082 .. 00552336 executed in place (EBX = 0, scratch frame):
                           bf63c0 = -bf63c8, per-frame tyre accumulators, 005524b0, linearity _CIpow (00552410 != 0 and
                           both steering controls analog), x pi, / 00554fb0 (setup item 0x30 + low-speed override
                           74c9a0), bf63b8, MOVs, pedal squares, per-tick ramps bf6e88 / bf6394 / bf6358 / bf6e50,
                           rep movsd bf6e28 -> bf6e58, bf6e80
  shift request            hand port of the remaining tail (Stage 7, unchanged)

Host device layer (ADAPTER, identical in the Luau port NR2003CupSteering.hostDevices): the raw values of controls
7 (steer left) and 8 (steer right) and their binding (d37cc8 + 29n: 1 = analog axis, 0 = key / button) are written to
the control table as the original device layer 0057abc0 would after polling (an analog axis is split in halves).
Steering options are applied by calling the ORIGINAL setters (005502f0 linearity, 005500c0 momentum -> rate,
00550110 low-speed override, 00550210 assistance) on the simulation-task FPU state (CW 0x077f).

_CIpow (006c5c40) is SecuROM-encrypted in the shipped exe: the inherited Stage 6/7 harness replaces it by an x87
FYL2X / F2XM1 / FSCALE sequence (orig_vehicle.POW_X87, documented adaptation); the Luau runtime uses x ^ y.
"""
import sys, struct, math
from fractions import Fraction
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent / 'stage11'))
from orig_stage11 import *          # noqa: F401,F403
import orig_stage11 as O11
import orig_brake as OB
import orig_runtime as _OR
from orig_runtime import _w, f32down
from nrx import STACK_TOP
from unicorn.x86_const import UC_X86_REG_ESP, UC_X86_REG_EBP, UC_X86_REG_EBX, UC_X86_REG_FPCW, UC_X86_REG_EIP

STEER_LEFT, STEER_RIGHT = 7, 8
CTRL_RAW, CTRL_TYPE = OB.CTRL_RAW, OB.CTRL_TYPE
INTCOUNT = OB.INTCOUNT
# host stubs in unused BSS between the Stage 8 session block (0xf7f040..0xf7f060) and HOST (0xf7f100)
STEERSTUB = 0xf7f060              # call 00552720 ; fstp dword [bf63c8] ; ret         (005524f0 @005525c8)
RATIOSTUB = 0xf7f070              # call 00554fb0 ; fstp tbyte [RES] ; ret
AXISSTUB = 0xf7f080               # push [esp+4] ; call 00552d00 ; add esp,4 ; fstp tbyte [RES] ; ret
LINSTUB = 0xf7f0a0                # call 00552410 ; fstp tbyte [RES] ; ret
INPUTSTUB = 0xf7f0b0              # call 00552720 ; fstp tbyte [RES] ; ret
RES = 0xf7f0f0                    # 10-byte x87 result of the stubs
TAIL_BEGIN, TAIL_SHAPED, TAIL_END = 0x552082, 0x552244, 0x552336
SETTINGS = 0xc0692a
SETUP_RATIO = 0xc055c0 + 4 * 0x30


def _rel(src, dst): return struct.pack('<i', dst - (src + 5))


def _stubs():
    s = {}
    s[STEERSTUB] = b'\xe8' + _rel(STEERSTUB, 0x552720) + b'\xd9\x1d' + struct.pack('<I', 0xbf63c8) + b'\xc3'
    s[RATIOSTUB] = b'\xe8' + _rel(RATIOSTUB, 0x554fb0) + b'\xdb\x3d' + struct.pack('<I', RES) + b'\xc3'
    s[AXISSTUB] = (b'\xff\x74\x24\x04' + b'\xe8' + _rel(AXISSTUB + 4, 0x552d00) + b'\x83\xc4\x04' +
                   b'\xdb\x3d' + struct.pack('<I', RES) + b'\xc3')
    s[LINSTUB] = b'\xe8' + _rel(LINSTUB, 0x552410) + b'\xdb\x3d' + struct.pack('<I', RES) + b'\xc3'
    s[INPUTSTUB] = b'\xe8' + _rel(INPUTSTUB, 0x552720) + b'\xdb\x3d' + struct.pack('<I', RES) + b'\xc3'
    for a, code in s.items():
        assert a + len(code) <= 0xf7f0f0 or a >= RES, hex(a)
    return s


# the stubs are written right after boot (Unicorn keeps translated blocks: code must not be rewritten after it ran)
_boot11 = _OR.boot
def _boot_stage12(*a, **k):
    m = _boot11(*a, **k)
    for a_, code in _stubs().items(): m.uc.mem_write(a_, code)
    return m
_OR.boot = _boot_stage12


def x80(m, a=RES):
    """exact value of a 10-byte x87 extended at a (Fraction; signed zero returned as a float)"""
    b = bytes(m.uc.mem_read(a, 10))
    mant, se = struct.unpack('<QH', b)
    sign, e = se >> 15, se & 0x7fff
    if e == 0x7fff: return float('nan') if mant & ((1 << 63) - 1) else (-math.inf if sign else math.inf)
    if mant == 0: return -0.0 if sign else 0.0
    v = Fraction(mant) * (Fraction(2) ** (max(e, 1) - 16383 - 63))
    return -v if sign else v


def fnear(v):
    """nearest IEEE double of an exact value (Fraction / float)"""
    return float(v)


def f32near(x): return struct.unpack('<f', struct.pack('<f', x))[0]
def u32f(x): return struct.unpack('<I', struct.pack('<f', x))[0]


def host_steer_devices(m, c):
    """0057abc0 equivalent (ADAPTER, same as NR2003CupSteering.hostDevices): controls 7 / 8 + binding"""
    if c.get('steerAxis') is not None:
        x = max(-1.0, min(1.0, float(c['steerAxis'])))
        left = -x if x < 0 else 0.0
        right = x if x > 0 else 0.0
        digital = False
    else:
        left = max(0.0, min(1.0, float(c.get('steerLeft', 0.0) or 0.0)))
        right = max(0.0, min(1.0, float(c.get('steerRight', 0.0) or 0.0)))
        digital = c.get('steerDigital', True) is not False
    m.wf(CTRL_RAW + 10 * STEER_LEFT, left); m.wf(CTRL_RAW + 10 * STEER_RIGHT, right)
    kind = 0 if digital else 1
    m.w32(CTRL_TYPE + 29 * STEER_LEFT, kind); m.w32(CTRL_TYPE + 29 * STEER_RIGHT, kind)


def set_steer_options(m, o):
    """ORIGINAL simulation-side setters (message handlers 005bb070 / 005bb080 / 005bb0e0 / 005bb130), called on the
    simulation task FPU state; the front-end conversions of 0043f1d0 (controls.cfg) as in NR2003CupSteering"""
    if o.get('linearityRaw') is not None:
        m.call(0x5502f0, u32f(f32near(o['linearityRaw'])))
    elif o.get('linearity') is not None:
        v = max(0, min(100, int(math.floor(o['linearity']))))
        m.call(0x5502f0, u32f(f32near(v * f32near(0.01))))
    if o.get('momentum') is not None:
        mm = max(0, min(100, int(math.floor(o['momentum']))))
        m.call(0x5500c0, 0, u32f(float(mm)))
    if o.get('lowSpeedOverride') is not None:
        m.call(0x550110, 1 if o['lowSpeedOverride'] else 0)
    if o.get('assist') is not None:
        m.call(0x550210, u32f(float(o['assist'])))
    if o.get('yawLimiter') is not None:
        v = m.u32(SETTINGS + 0x4c)
        m.w32(SETTINGS + 0x4c, (v | 0x2000000) if o['yawLimiter'] else (v & ~0x2000000))


def run_range(m, begin, until, fresh=True):
    """execute ORIGINAL instructions [begin, until) in place (00551e80 tail: EBX = 0 from 00551e92 / 00551eea, locals
    [ESP+8..0x10] on a scratch frame below the call stack of m.call)"""
    uc = m.uc
    # Unicorn places the stop check of emu_start(until) when it translates a block: a block of this range cached by a
    # run with another 'until' has no stop at this one -> drop the cached blocks of the range first
    uc.ctl_remove_cache(TAIL_BEGIN, TAIL_END + 0x10)
    if fresh:
        sp = STACK_TOP - 0x3000
        uc.reg_write(UC_X86_REG_ESP, sp); uc.reg_write(UC_X86_REG_EBP, sp + 0x800)
        uc.reg_write(UC_X86_REG_EBX, 0)
        uc.reg_write(UC_X86_REG_FPCW, m.fpcw)
    uc.emu_start(begin, until, count=2_000_000)
    eip = uc.reg_read(UC_X86_REG_EIP)
    if eip != until: raise RuntimeError('range %08x..%08x stopped at %08x' % (begin, until, eip))


def run_tail(m, shaped=None):
    """ORIGINAL 00551e80 @00552082..00552336; shaped(list) receives bf63c0 after the linearity (@00552244)"""
    if shaped is not None:
        run_range(m, TAIL_BEGIN, TAIL_SHAPED)
        shaped.append(m.u32(0xbf63c0))
        run_range(m, TAIL_SHAPED, TAIL_END, fresh=False)
    else:
        run_range(m, TAIL_BEGIN, TAIL_END)


NOT_DRIVEN = (0xbf63c8, 0xbf6f14, 0x74c98c, 0xbf6388, 0xbf6e84, 0xbf63bc, 0xbf638c, 0xbf6390, 0xbf6eb0)


def steer_frame(o, c, shaped=None):
    """the frame start (005524f0 player branch + 00551e80 tail) with the ORIGINAL steering chain"""
    m = o.m
    m.w32(INTCOUNT, (m.u32(INTCOUNT) + 1) & 0xffffffff)
    if c.get('driver', True) is False:
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
                m.call(OB.STUBADDR)                                  # ORIGINAL 00553080 -> bf6eac
                _w(m, 0xbf6eb0, c.get('clutch', 0.0))
        else:
            _w(m, 0xbf6eac, c.get('brake', 0.0))
            _w(m, 0xbf6eb0, c.get('clutch', 0.0))
        host_steer_devices(m, c)
        m.call(STEERSTUB)                                            # ORIGINAL 00552720 -> bf63c8
        _w(m, 0xbf6390, c.get('throttle', 0.0))
    run_tail(m, shaped)                                              # ORIGINAL 00551e80 tail
    if c.get('driver', True) is not False and m.i32(0xbf6f0c) != 2 and m.i32(0xbf63cc) == 0 \
            and m.i32(0x74c974) != 0 and m.i32(0xbf6f0c) == 0:
        d = (1 if c.get('shiftUp') else 0) - (1 if c.get('shiftDown') else 0)
        if d != 0 and m.i32(0xbf6ea0) in (0, 3, 4):                 # 00552450 / 00552480
            m.w32(0xbf63cc, 1 if d > 0 else 5); m.w32(0xbf6e98, 0)


class OriginalStage12(OriginalStage11):
    """OriginalStage11 + the ORIGINAL steering chain in the frame start.
    steering='provisional' keeps the Stage 6-11 frame start (host road-wheel target, hand port) for regression."""
    def __init__(self, *a, steering='original', steer_options=None, setup_ratio=None, **k):
        super().__init__(*a, **k)
        self.steering = steering
        self.shaped = None
        if setup_ratio is not None: self.m.wf(SETUP_RATIO, float(setup_ratio))
        if steer_options: set_steer_options(self.m, steer_options)

    def frame(self, c):
        if self.steering != 'original':
            return OriginalStage11.frame(self, c)
        m = self.m
        if self.stage11:
            m.w32(O11.BGCOUNT, (m.u32(O11.BGCOUNT) + 1) & 0xffffffff)
        O11.frame_airspeed(m)
        steer_frame(self, c, self.shaped)


# ------------------------------------------------------------------------------------------- function-level helpers
def call_x80(m, stub, *args):
    m.call(stub, *args)
    return x80(m)


def speed_state(m, v, yaw=0.0, vx_share=1.0):
    """exported state block: chassis velocity |v| (vx = v * share, vy the rest) and yaw rate state[12] (bf6d70);
    the getIntCount clock is advanced so that 00554f50 recomputes its cache"""
    vx = v * vx_share
    vy = math.sqrt(max(0.0, v * v - vx * vx))
    m.wf(0xbf6d44, vx); m.wf(0xbf6d4c, vy); m.wf(0xbf6d54, 0.0)
    m.wf(0xbf6d70, yaw)
    m.w32(INTCOUNT, (m.u32(INTCOUNT) + 1) & 0xffffffff)
