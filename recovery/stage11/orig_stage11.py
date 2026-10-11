"""Stage 11 original-code harness: the ORIGINAL NR2003 frame end executed in Unicorn.

Extends the Stage 9 OriginalAero harness (recovery/stage9/orig_aero.py -> stage8 OriginalBrake -> stage6_7
OriginalDriver). Until Stage 10 the frame end of the player car was the subset 'engine_frame' (the cut timer
countdown of 0051aac0). Here the 36 Hz frame runs exactly what the simulation task runs for the player car:

  task loop 005f78f0 / 005f8990      ++getBGCount (0x7559bc) immediately before the bg frame function
  0055bfd0 (per frame)               005637e0 per car (Stage 9 subset: aero factors, airspeed, drafting)
                                     005b2190: 00551e80 frame start, 8 x (005539c0 ... 00554510) ticks,
                                               00554520 FRAME END (ORIGINAL, whole function)
                                     00549c40 collision damage (ORIGINAL), after 005b2190

00554520 = 00551ce0 attitude filter, 005547a0 world/replay state record, bf3a00 airspeed, grille-tape / damage
radiator factor -> 0051a830 (radiator air inputs), 0051aac0 (engine: ignition/misfire, fuel burn, water/oil
temperatures and levels, wear and failure), 0051c3d0 (random component failures), 005605c0 (fuel mass ->
fuel component record), 00551990 (car snapshot + per tyre 0054d610 thermal/wear/brake temperature + 00556e30),
force-feedback output (bf6ebb, off).

Host boundary (identical in the Luau port, documented ADAPTER items, nothing physical):
  * 005547a0 records the car's world state into the track/replay system (005a02b0); without a loaded track it
    faults on track geometry. Patched to 'ret' (cdecl, no arguments).
  * 00592dc0 (car vtable slot 3) forwards a damage change to the replay recorder / multiplayer session
    (00501850, 005acdd0, 00538b50 vtable+0x34). Single player bench: patched to 'ret' (cdecl).
  * 005d08d0 force-feedback device output (only reached when bf6ebb != 0, FFB = Stage 13): 'ret'.
  * the car's track object velocity (005543f0 render copy) = exported chassis velocity, as the Luau Stage 9
    frame update does (car+0x5aa airspeed = |v - wind|, NR2003CupAero.frameAero arithmetic).
"""
import sys, struct, math
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent / 'stage9')); sys.path.insert(0, str(HERE.parent / 'stage8'))
sys.path.insert(0, str(HERE.parent / 'stage6_7'))
from orig_aero import *            # noqa: F401,F403
from orig_runtime import _w, f32down

BGCOUNT = 0x7559bc                 # getBGCount (005f7cb0) cell, incremented by the task loop before each frame
HOST_STUBS = (0x5547a0, 0x592dc0, 0x5d08d0, 0x557650)
# 005f58d0(out, point): world point -> track point record. ADAPTER (no track loaded): out[0..2] = point,
# fields +0x0c..+0x57 (written by the 0051370a track query) cleared. Same semantics as B_trackPoint (Luau).
TRACKPOINT_STUB = bytes.fromhex(
    '8b442408'      # mov eax, [esp+8]   point
    '8b4c2404'      # mov ecx, [esp+4]   out
    '8b10' '8911'   # mov edx,[eax] ; mov [ecx],edx
    '8b5004' '895104'
    '8b5008' '895108'
    '57'            # push edi
    '8d790c'        # lea edi, [ecx+0xc]
    '31c0'          # xor eax, eax
    'b913000000'    # mov ecx, 19
    'f3ab'          # rep stosd
    '5f'            # pop edi
    'c3')
ENGINE = 0xc12030 + 0xc
TIRE = [0xbf3a20 + w * 0xa39 for w in range(4)]
DAMAGE = 0xc12030 + 0x1493         # car vtable slot 1/2 (00592db0): damage object of the player car


def install_host_stubs(m):
    for a_ in HOST_STUBS: m.patch_ret(a_)
    m.uc.mem_write(0x5f58d0, TRACKPOINT_STUB)


# the stubs are written right after boot (before the car build executes any code: Unicorn keeps translated
# blocks, code must not be rewritten after it ran)
import orig_runtime as _OR
_boot0 = _OR.boot
def _boot_stage11(*a, **k):
    m = _boot0(*a, **k)
    install_host_stubs(m)
    return m
_OR.boot = _boot_stage11


def frame_airspeed(m):
    """Luau NR2003CupAero.frameAero: car+0x5aa = |chassis velocity (bf6d44/4c/54) - wind|, factors 1.0"""
    dx = f32down(m.f32(0xbf6d44) - m.f32(AIR))
    dy = m.f32(0xbf6d4c) - m.f32(AIR + 4)
    dz = m.f32(0xbf6d54) - m.f32(AIR + 8)
    for off in (F_DRAG, F_FRONT, F_REAR): m.w32(CAR + off, ONE)
    _w(m, CAR + AIRSPEED, math.sqrt((dz * dz + dy * dy) + dx * dx))


HOST = 0xf7f100
TOBJ = HOST + 0x680                # Stage 9 car world record block (car+0x5ae), 0x32c bytes
S11 = 0xf7a000                     # Stage 11 host blocks (unreferenced BSS, below the build stack 0xf7c000):
                                   # collision record arguments, contact objects, body proxies
KEYS = S11                         # 8 contact objects (key of 0054a760), 16 bytes each: +4 -> body proxy
BODY = S11 + 0x80                  # body proxy of the player car (+0x1a4 car index 0, +0xec spark parameter)
OTHER = S11 + 0x280                # body proxy of another car (car-car contacts), +0x1a4 = car index 1
VEC = S11 + 0x480                  # 5 vec3 arguments (point, local, other local, velocity, normal)
# ADAPTER host geometry: the player car's collision object of the track system (c7e75c; built by the unrecovered track
# collision code when the car is placed in the world, null in the bench). Layout used by the original damage code
# (0054b0d0 / 00549860 / 0054a8d0 / 00577cb0): +0x18..+0x24 four wheel parts (+0x40 'off' flag), +0x28..+0x38 five
# deformable body parts (+0x14..+0x1c base vector, +0x20 / +0x38 factors, +0x24..+0x2c deformed vector, +0x3c state).
# The host simulates no collision-mesh deformation: zeroed parts (PROVISIONAL, documented in STAGE11_RECOVERY.md).
COLL = S11 + 0x500                 # container (0x40 bytes)
COLL_PARTS = S11 + 0x540           # 9 parts x 0x48
COLL_OBJ = 0xc7e75c                # player collision object pointer read by 00549290 / 0054a8d0 / 00563080
HOST_SIZE = 0x7c8                  # S11 host blocks in use (contacts, proxies, vectors, collision object)
RACE_SETTINGS = 0xc0692a


def ensure_world_record(m, normal=(0.0, 0.0, 1.0)):
    """the car's world record (car+0x5ae): when the car has none (post-build state), the Stage 9 block is used
    with the given surface normal (+0x24, flat track (0,0,1) by default)"""
    if m.u32(CAR + TRACKOBJ) == 0:
        for k in range(3): m.wf(TOBJ + 0x24 + 4 * k, normal[k])
        m.w32(CAR + TRACKOBJ, TOBJ)
    return m.u32(CAR + TRACKOBJ)


def sync_world_record(m, normal=(0.0, 0.0, 1.0)):
    """005543f0 without the track query (ADAPTER, no track loaded): the car's world record (car+0x5ae) gets the
    exported state: position, 005f5a60 (quaternion -> rotation +0x58), 005f5ac0 (velocity +0xc, angular +0x8c)."""
    rec = ensure_world_record(m, normal)
    m.w32(rec, m.u32(0xbf6d40)); m.w32(rec + 4, m.u32(0xbf6d48)); m.w32(rec + 8, m.u32(0xbf6d50))
    m.call(0x5f5a60, rec, 0xbf6d58)
    v = VEC + 0x60
    m.w32(v, m.u32(0xbf6d44)); m.w32(v + 4, m.u32(0xbf6d4c)); m.w32(v + 8, m.u32(0xbf6d54))
    m.call(0x5f5ac0, rec, v, 0xbf6d68)


def build_zone_tree(m, call=None):
    """ORIGINAL 00433610(chassis type car+0x58e): builds the collision-damage zone tree (00433660: a decision tree of
    hard-coded split planes, nodes from the static pool *bf39d4 via 00547e60) once for all 6 chassis types
    (table 00890490). In the game the car-model load 00432d90 calls it; the physics-only bench never did, so every
    zone lookup (0054a710 -> 00547e20) returned -1 and no collision damage could be evaluated."""
    (call or m.call)(0x433610, m.u32(CAR + 0x58e))


class race_order:
    """ADAPTER host state: the player car is in the race order of the session (in the game every car on the track is
    a member of the race-order ring car+4 / car+8; Stage 9 recovered the ring for 005afd80). The Stage 6/7 build never
    inserted it (links 0), which disables the collision damage of 00549c40 (`car+4 != 0` gates 00549290 body damage
    and 0054a330 wheel / tyre impact states). A single-car ring (links -> car+4, the shape of a one-car race order) is
    set around 00549c40 only: car+4 != 0 also enables the render copy 005543f0 inside the per-tick 005539c0, which
    queries the unloaded track (README_RECOVERY_STAGE9)."""
    def __init__(self, m): self.m = m
    def __enter__(self):
        m = self.m
        self.saved = (m.u32(CAR + 4), m.u32(CAR + 8))
        m.w32(CAR + 4, CAR + 4); m.w32(CAR + 8, CAR + 4)
    def __exit__(self, *a):
        self.m.w32(CAR + 4, self.saved[0]); self.m.w32(CAR + 8, self.saved[1])


def host_blocks(m):
    m.uc.mem_write(S11, b'\0' * HOST_SIZE)
    for k in range(8): m.w32(KEYS + 16 * k + 4, BODY)
    m.w32(BODY + 0x1a4, 0); m.w32(OTHER + 0x1a4, 1)
    for k in range(9): m.w32(COLL + 0x18 + 4 * k, COLL_PARTS + 0x48 * k)
    m.w32(COLL_OBJ, COLL)


class OriginalStage11(OriginalAero):
    """OriginalAero + the ORIGINAL frame end (00554520) and collision damage frame (00549c40).
    stage11=False keeps the Stage 6-10 frame end (cut timer subset) for regression comparisons.
    series: roster series field of the player car (car+0x596, 00562e80 <- 00574370(+0x94)); the Stage 6/7 build
    uses 0 (spec rows 0 and 1 of 00725ab8 are the same Cup specs); collision damage (00549290/00549860) needs it
    nonzero (PROVISIONAL host input, see STAGE11_RECOVERY.md)."""
    def __init__(self, *a, stage11=True, series=1, damage_level=None, consumption=None, seed=None, enter=True,
                 zone_tree=True, **k):
        super().__init__(*a, **k)
        self.stage11 = stage11
        m = self.m
        if stage11:
            # Stage 11 session start, same order as NR2003CupFrame (V.startSession): host blocks, collision-damage zone
            # tree, series field, race options, random seed, then the car is placed on the track (00550a50 subset)
            host_blocks(m)
            if zone_tree: build_zone_tree(m)
            m.w32(CAR + 0x596, series)
            if damage_level is not None: set_damage_level(m, damage_level)
            if consumption is not None: set_consumption(m, consumption)
            if seed is not None: m.w32(0xf6eae4, seed)
            if enter: enter_track(self)

    def frame(self, c):
        m = self.m
        if self.stage11:
            m.w32(BGCOUNT, (m.u32(BGCOUNT) + 1) & 0xffffffff)
        frame_airspeed(m)
        OriginalBrake.frame(self, c)

    def frame_end(self):
        m = self.m
        sync_world_record(m)
        m.call(0x554520)
        with race_order(m):
            m.call(0x549c40)

    def collision(self, magnitude, material=0x13, surface=1, flags=0, point=(0, 0, 0), local=(0, 0, 0),
                  other_local=(0, 0, 0), velocity=(0, 0, 0), normal=(0, 0, 1), p9=0, speed=0.0, key=0, other=False):
        """ORIGINAL collision record entry 0054a760 (what the track contact code 00576e00 / 0057xxxx calls):
        key = contact object index (0..7), magnitude (float, kept as the frame maximum per key), material = self
        contact material (0x13 tyre), flags (0x2000000 = continuous contact), surface = other material, point =
        world contact point, local = contact point in the car frame (zone lookup 0054a710), other_local, velocity,
        normal (normalised by 005f6a70), p9 / speed = c7e78c / c7e790 of the contact query."""
        m = self.m
        vecs = (point, local, other_local, velocity, normal)
        for k, v in enumerate(vecs):
            for j in range(3): m.wf(VEC + 12 * k + 4 * j, v[j])
        m.call(0x54a760, KEYS + 16 * key, u32f(magnitude), (flags | material) & 0xffffffff, surface,
               VEC, VEC + 12, VEC + 24, VEC + 36, p9, u32f(speed), OTHER if other else 0, VEC + 48)

    def step_driver(self, controls, contacts):
        if self.tick % TICKS_PER_FRAME == 0: self.frame(controls)
        self.drive_tick(contacts)
        if self.tick % TICKS_PER_FRAME == 0:
            if self.stage11: self.frame_end()
            else: engine_frame(self.m)
        return self.state()

    def protected_f32(self, a): return protected_f32(self.m, a)
    def protected_f64(self, a): return protected_f64(self.m, a)


def enter_track(o, traced=False):
    """ORIGINAL 00550a50 subset, run by the simulation task when the car is placed on the track (drive from the
    garage, reset to pits, restart): 00563080(car, 1) (damage repair 0054b3c0 + 0054b410, timers), 00550c40
    (engine init 0051a020: water 93 C, oil 0 C, levels, ignition flags on the simulation task path), 00550c60
    (fuel load), 005512d0 (00550f10 x4: four new tyres at the session air temperature e0b834 + 11 C, cold pressures from the
    setup, wear 0), car+0x1518 = 0, bf6eb9 = 0 (car released). Host parts not run: 005512f0 placement on the
    track (the bench pose is the reset pose), 00550070 force-feedback device setup (Stage 13), 00524930 driver
    aid state, the optional bf63c4 hook (null in the bench)."""
    call = o.traced_call if (traced and getattr(o, 'tracer', None)) else o.m.call
    m = o.m
    assert m.u32(0xbf63c4) == 0
    ensure_world_record(m)
    call(0x563080, CAR, 1)
    call(0x550c40)
    call(0x550c60)
    call(0x5512d0)
    m.w32(CAR + 0x1518, 0)
    m.uc.mem_write(0xbf6eb9, b'\x00')


def set_damage_level(m, level):
    """race option 'damage' (race settings +0x4c bits 22..23) -> ORIGINAL 00547e90 (session start 0055be60)"""
    v = m.u32(RACE_SETTINGS + 0x4c) & ~(3 << 22)
    m.w32(RACE_SETTINGS + 0x4c, v | ((level & 3) << 22))
    m.call(0x547e90, level & 3)


def set_consumption(m, rate):
    """race option fuel / tyre consumption multiplier (race settings +0x50 bits 0..1: x1..x4), read at run time"""
    v = m.u32(RACE_SETTINGS + 0x50) & ~3
    m.w32(RACE_SETTINGS + 0x50, v | (rate & 3))


def protected_f32(m, a):
    """value of an obfuscated float (pointer triple at a: value = *p0 ^ *p2)"""
    return struct.unpack('<f', struct.pack('<I', m.u32(m.u32(a)) ^ m.u32(m.u32(a + 8))))[0]


def protected_f64(m, a):
    p0, p2 = m.u32(a), m.u32(a + 8)
    lo = m.u32(p0) ^ m.u32(p2); hi = m.u32(p0 + 4) ^ m.u32(p2 + 4)
    return struct.unpack('<d', struct.pack('<II', lo, hi))[0]
