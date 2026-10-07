"""Stage 9 original-code harness: the ORIGINAL NR2003 aero inputs executed in Unicorn.

Extends the Stage 8 OriginalBrake harness (recovery/stage8/orig_brake.py), which extends the Stage 6/7
OriginalDriver (recovery/stage6_7/orig_runtime.py).

What the car build alone (Stages 6/7/8) never ran, and the game runs before/while driving:
  * session start, simulation task (0055d3ec -> 0055af80 -> 0055b140 -> 0055a830):
      005a3c00(this = weather object 0xe0b728, race settings 0055a680() = 0xc0692a)
      -> weather fields +0x118/+0x11c/+0x120/+0x124 = e0b840 wind x / e0b844 wind y / e0b848 wind z /
         e0b84c air density, read by the aero natives 00561a80 / 00561b70.
  * every 36 Hz frame, simulation task (0055d3f4 -> 0055b450 -> 0055bfd0), before the 8 physics ticks:
      005637e0(car): car+0x59e / +0x5a2 / +0x5a6 (drag / front / rear aero factors) = 1.0,
                     car+0x5aa = |track-object velocity - wind|,
                     005afd80(car) drafting for the focused car (multiplies the three factors).
Both run under the simulation task FPU CW 0x077f (bg loop 0055cef0 -> 00567704(1,3)).

The emulator executes the ORIGINAL 005a3c00 and 005afd80; the 005637e0 subset (three stores of
1.0f, the airspeed, the 005afd80 call) is done by the harness exactly as 005637e0 does it.
"""
import sys, struct, math
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent / 'stage8')); sys.path.insert(0, str(HERE.parent / 'stage6_7'))
from orig_brake import *            # noqa: F401,F403
from orig_runtime import _w, f32down

WEATHER = 0xe0b728        # 005a3c00 / 005a4cc0 'this' (0055a830, 0055bfd0)
SETTINGS = 0xc0692a       # 0055a680(): race settings (+0x40 time, +0x48 flags, +0x4c wind dir bits 26..28,
                          # +0x54 weather mode, +0x58 conditions, +0x5c temperature F (byte), +0x5d wind mph (byte))
AIR = 0xe0b840            # = WEATHER + 0x118: wind x, y, z, density
TRACK_NORTH = 0xbdbcf8    # track orientation angle used by 005a3c00 (track data)
CAR = 0xc12030            # player car slot (00562f70(0))
F_DRAG, F_FRONT, F_REAR, AIRSPEED, TRACKOBJ = 0x59e, 0x5a2, 0x5a6, 0x5aa, 0x5ae
ONE = 0x3f800000


def u32f(x): return struct.unpack('<I', struct.pack('<f', x))[0]


def weather_settings(m, temperature=70, wind_mph=0, wind_dir=0, conditions=0, night=0, mode=0, time=0):
    """race settings consumed by 005a3c00 (option getters clamp: temperature 40..110 F (004cd280),
    wind direction 0..7 (004cd2b0), wind speed 0..30 mph (004cd2d0), conditions 0..3 (004cd260))"""
    m.uc.mem_write(SETTINGS + 0x5c, bytes([temperature & 0xff, wind_mph & 0xff]))
    v = m.u32(SETTINGS + 0x4c) & ~(7 << 26)
    m.w32(SETTINGS + 0x4c, v | ((wind_dir & 7) << 26))
    f = m.u32(SETTINGS + 0x48) & ~2
    m.w32(SETTINGS + 0x48, f | ((night & 1) << 1))
    m.w32(SETTINGS + 0x54, mode)
    m.w32(SETTINGS + 0x58, conditions)
    m.w32(SETTINGS + 0x40, time)


def weather_init(m, track_north=0.0, **settings):
    """ORIGINAL 005a3c00 on the session weather object (as 0055a830 calls it)"""
    weather_settings(m, **settings)
    m.wf(TRACK_NORTH, track_north)
    saved = m.fpcw
    m.fpcw = GAME_FPCW
    m.call(0x5a3c00, SETTINGS, ecx=WEATHER)
    m.fpcw = saved
    return air(m)


def air(m):
    return dict(wind=(m.f32(AIR), m.f32(AIR + 4), m.f32(AIR + 8)), rho=m.f32(AIR + 12),
                bits=[m.u32(AIR + 4 * k) for k in range(4)],
                tC=m.f32(WEATHER + 0x108), tAir=m.f32(WEATHER + 0x10c), dir=m.f32(WEATHER + 0x110),
                speed=m.f32(WEATHER + 0x114))


def car_frame_aero(m, track_obj=None, draft=None):
    """005637e0 subset run every frame before the physics ticks: factors = 1.0, airspeed, drafting.
    track_obj: address of the car's track object (velocity at +0xc) or None (slot+0x5ae = 0: the
    Stage 6/7 build state; airspeed is then left untouched)."""
    for off in (F_DRAG, F_FRONT, F_REAR):
        m.w32(CAR + off, ONE)
    if track_obj:
        dx = m.f32(track_obj + 0xc) - m.f32(AIR)
        dy = m.f32(track_obj + 0x10) - m.f32(AIR + 4)
        dz = m.f32(track_obj + 0x14) - m.f32(AIR + 8)
        _w(m, CAR + AIRSPEED, math.sqrt(dx * dx + dy * dy + dz * dz))
    if draft:
        draft()


class OriginalAero(OriginalBrake):
    """OriginalBrake + session weather + per-frame aero factors (single car: no drafting partner)."""
    def __init__(self, *a, weather=None, **k):
        super().__init__(*a, **k)
        self.weather = dict(weather or {})
        self.air0 = weather_init(self.m, **self.weather)

    def frame(self, c):
        car_frame_aero(self.m)
        super().frame(c)
