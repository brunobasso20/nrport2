"""Stage 8 original-code harness: the ORIGINAL NR2003 brake input chain executed in Unicorn.

Extends the Stage 6/7 OriginalDriver (recovery/stage6_7/orig_runtime.py). At every 36 Hz frame
start the pedal is no longer written by the host: the ORIGINAL 00553080 runs natively (with its
own 00552d00 axis limiter, 00554f50 speed, 005f7570 attitude, 0057af60 control binding,
00550130 braking help) and its result is stored to bf6eac exactly as 005524f0 does
(FSTP dword [bf6eac] under the simulation task CW 0x077f).

Host-side boundary (documented adaptations, nothing physical):
  * input devices: the raw control values live in the game's own control table
    (0057af30: float at d35b18 + 10*n; 0057af60: binding type int at d37cc8 + 29*n, 1 = analog
    axis, otherwise button/key). Control 5 = throttle, 6 = brake.
  * getIntCount (005f7cd0, timer-interrupt counter that invalidates the 00554f50 speed cache)
    returns a host counter advanced once per frame.
  * c08194 (online session object read by 005c2d20) points to a zero block: offline, so
    005c2d20 returns 0 and 00553080 takes the 005672e0 -> 0055a730 (c067e0) path.
  * 'driver = False' reproduces the 005524f0 'car not driven' branch (brake 1.0, clutch 0, ...).
"""
import sys, struct
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent / 'stage6_7'))
from orig_runtime import *      # noqa: F401,F403  (Original, OriginalDriver, f32down, flat, ...)
from orig_runtime import _w      # float32 store, RC toward -inf

INTCOUNT = 0xf7f010   # unused BSS dword (host): value returned by the patched getIntCount
STUBADDR = 0xf7f020   # unused BSS: call 00553080 ; fstp dword [bf6eac] ; ret
SESSION = 0xf7f040    # unused BSS: zero block standing for the absent (offline) session object
CTRL_RAW = 0xd35b18   # 0057af30: control n raw value  = float [d35b18 + 10n]
CTRL_TYPE = 0xd37cc8  # 0057af60: control n binding    = int   [d37cc8 + 29n] (1 = analog axis)
BRAKE_CTL, THROTTLE_CTL = 6, 5
SETUP_ACTIVE, SETUP_DEFAULT = 0xc055c0, 0xc03350


def control_cells(m, n, value, digital):
    m.wf(CTRL_RAW + 10 * n, value)
    m.w32(CTRL_TYPE + 29 * n, 0 if digital else 1)


def f32near(x):
    """IEEE single, round to nearest (x87 default CW 0x027f)"""
    return struct.unpack('<f', struct.pack('<f', x))[0]


def bias_to_internal(percent):
    """garage setup item 0x28 (front brake bias, integer 50..90 %) -> internal value: ORIGINAL
    toInternal 00423de0 = FILD; FMUL dword [006ea4a4] (0.01f); FSTP dword, under the default
    (non-simulation) x87 CW 0x027f -- reproduces the shipped default 74 -> 0x3f3d70a4."""
    return f32near(percent * f32near(0.01))


class OriginalBrake(OriginalDriver):
    def __init__(self, *a, **k):
        super().__init__(*a, **k)
        m = self.m
        m.uc.mem_write(0x5f7cd0, b'\xa1' + struct.pack('<I', INTCOUNT) + b'\xc3')   # getIntCount
        m.w32(INTCOUNT, 0)
        m.uc.mem_write(SESSION, b'\0' * 32)
        m.w32(0xc08194, SESSION)
        code = (b'\xe8' + struct.pack('<i', 0x553080 - (STUBADDR + 5)) +
                b'\xd9\x1d' + struct.pack('<I', 0xbf6eac) + b'\xc3')
        m.uc.mem_write(STUBADDR, code)

    def frame(self, c):
        m = self.m
        N = float(m.i32(0xbf6e9c))
        m.w32(INTCOUNT, (m.u32(INTCOUNT) + 1) & 0xffffffff)
        # ---------------------------------------------------------- 005524f0 (player car), brake subset
        if c.get('driver', True) is False:
            for a in (0xbf63c8, 0xbf6f14, 0x74c98c, 0xbf6388, 0xbf6e84, 0xbf63bc, 0xbf638c, 0xbf6390, 0xbf6eb0):
                m.w32(a, 0)
            m.w32(0xbf6eac, 0x3f800000)
            m.uc.mem_write(0xbf6e20, b'\0\0\0')
        else:
            if 'brakeControl' in c:
                control_cells(m, BRAKE_CTL, c['brakeControl'], c.get('brakeDigital', True))
                control_cells(m, THROTTLE_CTL, c.get('throttleControl', c.get('throttle', 0.0)), c.get('throttleDigital', True))
                if m.uc.mem_read(0xbf6eb9, 1)[0]:
                    m.w32(0xbf6eac, 0x3f800000); m.w32(0xbf6eb0, 0)
                else:
                    m.call(STUBADDR)                               # ORIGINAL 00553080 -> bf6eac
                    _w(m, 0xbf6eb0, c.get('clutch', 0.0))
            else:
                _w(m, 0xbf6eac, c.get('brake', 0.0))               # Stage 7 contract (direct pedal)
                _w(m, 0xbf6eb0, c.get('clutch', 0.0))
            _w(m, 0xbf6390, c.get('throttle', 0.0))
        # ---------------------------------------------------------- 00551e80 tail (as OriginalDriver.frame)
        for w in range(4):
            t = 0xbf3a20 + w * 0xa39
            for o in (0x2ac, 0x2b0, 0x2b4, 0x2b8, 0x2d0, 0x2d4, 0x2bc, 0x2c0): m.w32(t + o, 0)
        target = c.get('steer', 0.0)                                # PROVISIONAL (Stage 12)
        _w(m, 0xbf63b8, target)
        m.w32(0xbf6e38, m.u32(0xbf6eb0))
        m.w32(0xbf63c0, m.u32(0xbf6e80)); m.w32(0xbf636c, m.u32(0xbf6e64))
        m.w32(0xbf6ea4, m.u32(0xbf6e60)); m.w32(0xbf6e14, m.u32(0xbf6e68))
        thr, brk = m.f32(0xbf6390), m.f32(0xbf6eac)
        _w(m, 0xbf6e30, thr * thr); _w(m, 0xbf6e34, brk * brk)
        _w(m, 0xbf6e88, (target - m.f32(0xbf6e80)) / N)
        _w(m, 0xbf6394, (m.f32(0xbf6e30) - m.f32(0xbf6e60)) / N)
        _w(m, 0xbf6358, (m.f32(0xbf6e34) - m.f32(0xbf6e64)) / N)
        cl = m.f32(0xbf6eb0) - m.f32(0xbf6e68)
        m.uc.mem_write(0xbf6e58, bytes(m.uc.mem_read(0xbf6e28, 36)))
        _w(m, 0xbf6e50, cl / N)
        _w(m, 0xbf6e80, target)
        if c.get('driver', True) is not False and m.i32(0xbf6f0c) != 2 and m.i32(0xbf63cc) == 0 \
                and m.i32(0x74c974) != 0 and m.i32(0xbf6f0c) == 0:
            d = (1 if c.get('shiftUp') else 0) - (1 if c.get('shiftDown') else 0)
            if d != 0 and m.i32(0xbf6ea0) in (0, 3, 4):            # 00552450 / 00552480
                m.w32(0xbf63cc, 1 if d > 0 else 5); m.w32(0xbf6e98, 0)

    # ------------------------------------------------------------------ observation helpers
    def tire(self, w):
        """per-wheel original tire/brake fields of the last tire + forces pass (tire object 0xbf3a20 + 0xa39 w)"""
        m = self.m; t = 0xbf3a20 + w * 0xa39
        return dict(torque=m.f32(t + 0x268), fx=m.f32(t + 0x2d8), fy=m.f32(t + 0x2dc), fz=m.f32(t + 0x2e0),
                    vx=m.f32(t + 0x2f0), vslip=m.f32(t + 0x2ec), tread=m.f32(t + 0x2cc), rr=m.f32(t + 0x2c8))

    def brake_cells(self):
        m = self.m
        return dict(pedal=m.f32(0xbf6eac), target=m.f32(0xbf6e34), tick=m.f32(0xbf636c),
                    core=m.f32(m.u32(0xe84480)), kb=[m.f32(m.u32(0xc0850c + 4 * w)) for w in range(4)],
                    rr=[m.f32(m.u32(0xc081f4 + 4 * w)) for w in range(4)])


def build_with_bias(percent, cls=None, **kw):
    """ORIGINAL build path with the garage brake bias (setup item 0x28, percent front) changed
    after the default setup completion (00559950) and before the derived-value pass (00559820)
    and the setup -> runtime conversion 0055e9b0 (inside 005b2f20) run."""
    import orig_vehicle, orig_runtime
    real_build = orig_vehicle.build
    internal = bias_to_internal(percent)

    def build(m, *a, **k):
        real_call = m.call

        def call(address, *args, **kk):
            r = real_call(address, *args, **kk)
            if address == 0x559950 and kk.get('ecx') == SETUP_DEFAULT:
                for blk in (SETUP_DEFAULT, SETUP_ACTIVE):
                    p = real_call(0x557d60, 0x28, ecx=blk)
                    m.wf(p, internal)
            return r
        m.call = call
        try:
            return real_build(m, *a, **k)
        finally:
            m.call = real_call
    orig_vehicle.build = build
    orig_runtime.build = build
    try:
        return (cls or OriginalBrake)(**kw)
    finally:
        orig_vehicle.build = real_build
        orig_runtime.build = real_build
