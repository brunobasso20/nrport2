"""ORIGINAL NR2003 car + track + collision world executed in Unicorn (reference of the Watkins Glen port).

Extends the Stage 13 reference (recovery/stage13/orig_stage13.py -> ... -> stage6_7 Original): the player Cup car built
by the ORIGINAL build, driven by the ORIGINAL per-tick chain. What this harness adds, all ORIGINAL code:
  * boot (before the car build, the game's order 00572cb0): PTF load (orig_track.TrackHost: original descriptor
    readers), 00510b70 + 005108f0 track build into the track arena, track.ini through the original loaders
    (00538560: 00537390 / 00537680 / 00537d90 / 005380c0 / 005382a0 / 00538440 / 0050fbd0) with the rts.dll
    ProfileManager host (profile_host.py), 00579cd0 car-part x surface interaction tables.
  * after the build: 00433cb0 -> 00432d90 car collision geometry (4 tyre spheres + body spheres, collision object
    c7e75c with 4 wheel + 5 body parts), 00578610 world reset, race-order ring of one car (car+4), placement on the
    track (005512f0), world record 005543f0.
  * per frame: 005789c0 (broadphase: other cars + track primitives near the car) and 00578a60 (pair maintenance)
    on the world object c74e20, like 005b2190.
  * per tick: 005539c0, 00578da0 (contact pass 1: tyres -> 0055e1e0, body spheres -> 00575920), 005544d0, 005544e0,
    00578de0 (pass 2), 005544d0, 00554510 -- the 005b2190 order (005548d0 replay/telemetry record not run).
Host: the Stage 6-13 host boundary (task rate, critical sections, inBackground flag, replay/sound/FFB stubs), the
rts.dll Archive / ProfileManager hosts, the CRT replacements of crt_x87.py and sscanf from server.exe."""
import os
import struct
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parent.parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(REPO / 'recovery' / 'stage13'))
import orig_track as OT                 # noqa: E402  (patches nrx.Machine._stub_hook)
import orig_stage13 as O13              # noqa: E402
import orig_stage11 as O11              # noqa: E402
import orig_runtime as _OR              # noqa: E402
from profile_host import ProfileHost    # noqa: E402
from server_crt import ServerCRT        # noqa: E402

WORLD = 0xc74e20                         # collision world object (00578590 ctor, static)
BG_CAROBJ = 0xc08874                     # car objects of the simulation task (0x32c each), world record at +0x98
CAROBJ_SIZE = 0x32c
CAR = O11.CAR if hasattr(O11, 'CAR') else 0xc12030
POW_SPAN = (0x6c5c40, 0x6c5c40 + 64)     # Stage 6/7 _CIpow replacement (orig_vehicle.install_pow)

_cfg = {}


def configure(track_dir, shared_dir, server_mem=None, stall=None, grid=0, rts_mem=None):
    """track_dir: folder with <track>.dat + track.ini (the game's tracks/<name>/); shared_dir: tracks/shared."""
    _cfg.update(track=Path(track_dir), shared=Path(shared_dir), server=server_mem or os.environ.get('SERVER_MEM'),
                name=Path(track_dir).name, grid=grid, rts=rts_mem or os.environ.get('RTS_MEM'))
    if stall is not None:
        _cfg['stall'] = stall


_boot13 = _OR.boot


def _boot_world(*a, **k):
    m = _boot13(*a, **k)
    if not _cfg:
        return m
    # the Stage 11 'no track' stub of 005f58d0 was written but never executed: restore the original code
    m.uc.mem_write(0x5f58d0, OT.original_bytes(0x5f58d0, len(O11.TRACKPOINT_STUB)))
    m.uc.ctl_flush_tb()
    import crt_x87
    import rts_native
    # rts.dll code run natively for the pure-computation exports the track / collision code uses
    m.rts_bound = rts_native.load(m, ['?Remove@RBNodeBase@@QAEXPAV1@@Z'], mem=_cfg.get('rts'))
    crt = ServerCRT(_cfg['server'])
    host = OT.TrackHost(m, x87_ranges=((0x510000, 0x51a000), (0x575000, 0x57a000), (0x6c6d40, 0x6c6f00),
                                       (0x6c72b0, 0x6c7300)), crt_allow=(POW_SPAN,),
                        crt_extra={0x6c4ac9: crt_x87.sscanf_server(crt)}, crt_server=crt)
    tdir, sdir = _cfg['track'], _cfg['shared']
    dats = sorted(tdir.glob('*.dat'))
    for d in dats:
        host.add_dat(d)
    for f in tdir.iterdir():
        if f.suffix.lower() in ('.ini', '.cam', '.lp'):
            host.files.setdefault(f.name.lower(), f.read_bytes())
    for d in sorted(sdir.glob('*.dat')):
        host.add_dat(d)
    m.prof = ProfileHost(m, crt, host.files)
    ptf = [n for n in host.files if n.endswith('.ptf')][0]
    root = host.load(host.files[ptf])
    m.track_root = root
    if host.build_track(root, arena=OT.ARENA) <= 0:
        raise RuntimeError('track build failed')
    m.arena_top = (host.arena[1] + 0xfff) & ~0xfff
    # track.ini through the ORIGINAL loaders (00572cb0 -> 00538560(grid option, 0)); grid option = race option of
    # the session (FUN_0055a680()+0x4f bit 0 inverted): host input, starting_grid_<n>
    if m.call(0x538560, _cfg.get('grid', 0), 0) != 1:
        raise RuntimeError('00538560 (track.ini) failed: %r' % (m.prof.loads,))
    m.world_boot = True
    return m


_OR.boot = _boot_world


# regions of the track load image (load_image): exe BSS above the Stage 6/7 image (node / pair pools fa9d50..) and the
# track arena; plus the cells of the Stage 6/7 image range [BASE, TOP) that the track load changed
BSS_HI = (0xf80000, 0xfb0000)
IMG = (0x6e9000, 0xf80000)
HOST_EXCLUDE = (0xf7a000, 0xf80000)      # Stage 11 host blocks + virtual stacks (never image)
SNAPSHOT = {}                            # set SNAPSHOT['on'] = True to keep the load-image snapshot (m.load_snap)


def track_init(m):
    """00573010 (track init after the loaders), its non-rendering part, once the car's physics spec exists: 00579cd0
    car-part x surface interaction tables, 00573af0, 005105c0(PTF root). 0050c8d0 (AI race lines, .lp; b8f258) needs the
    series tables (0056c150: c5c3c8 / c5ca20) that the physics bench never loads; it only sets b8f258 (opponent-wheel
    row 0x12 of the interaction tables: car-car wheel contacts). Not run (single car, no AI): b8f258 = 0, documented."""
    m.call(0x579cd0)
    m.call(0x573af0)
    m.call(0x5105c0, m.track_root)


def snapshot(m):
    regs = {}
    for lo, hi in (IMG, BSS_HI):
        regs[lo] = bytes(m.uc.mem_read(lo, hi - lo))
    if getattr(m, 'world_boot', False):
        a0, a1 = OT.ARENA, m.arena_top
        regs[a0] = bytes(m.uc.mem_read(a0, a1 - a0))
    return regs


_host_blocks11 = O11.host_blocks


def _host_blocks_world(m):
    """Stage 11 session start (host blocks) preceded, with a track, by the track init (the game runs 00573010 when the
    track loads, before any session); the load-image snapshot point (plain run: the same point without a track)"""
    if getattr(m, 'world_boot', False) and not getattr(m, 'track_init_done', False):
        track_init(m)
        m.track_init_done = True
    if SNAPSHOT.get('on') and not hasattr(m, 'load_snap'):
        m.load_snap = snapshot(m)
        if SNAPSHOT.get('trace'):
            start_trace(m)
    _host_blocks11(m)


def start_trace(m):
    """memory footprint from here on: dword cells read or written (m.touched); with SNAPSHOT['eips'] (instruction
    addresses) only the accesses of those instructions and of rts.dll code (the lifted track set)"""
    from unicorn import UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE
    from unicorn.x86_const import UC_X86_REG_EIP
    m.touched = set()
    t = m.touched
    eips = SNAPSHOT.get('eips')
    rts_lo = 0x20000000

    def hook(uc, access, addr, size, value, user):
        if eips is not None:
            eip = uc.reg_read(UC_X86_REG_EIP)
            if eip not in eips and not (rts_lo <= eip < rts_lo + 0x100000):
                return
        a = addr & ~3
        t.add(a)
        if addr + size > a + 4:
            t.add(a + 4)
    m.trace_hook = m.uc.hook_add(UC_HOOK_MEM_READ | UC_HOOK_MEM_WRITE, hook)
    # every write (any code): the comparison set of the fixtures
    m.written = set()
    wr = m.written

    def hookw(uc, access, addr, size, value, user):
        a = addr & ~3
        wr.add(a)
        if addr + size > a + 4:
            wr.add(a + 4)
    m.write_hook = m.uc.hook_add(UC_HOOK_MEM_WRITE, hookw)


O11.host_blocks = _host_blocks_world


def session_init(o):
    """session start 00566e50, the world part: BG object init 0059fa90 (base = carobj - 0xcc, index +0x270), the car's
    collision geometry 00433cb0 (4 tyre spheres + body spheres, collision object c7e75c), world reset 00578610, world
    record car+0x5ae = BG car object + 0x98 (005a13f0 record)"""
    m = o.m
    m.call(0x59fa90, ecx=o.carobj - 0xcc)
    m.w32(o.carobj - 0xcc + 0x270, o.k)
    if m.call(0x433cb0, o.k, CAR + 0x58e, o.carobj) == 0:
        raise RuntimeError('00433cb0 (collision geometry) failed')
    m.call(0x578610, ecx=WORLD)
    m.w32(CAR + 0x5ae, o.carobj + 0x98)


def enter_world(o, stall):
    """ORIGINAL 00550a50 subset of Stage 11..13 (enter_track13) with the placement 005512f0 at its place (@00550aeb:
    after 005512d0 and the bf63c4 hook, before car+0x1518 = 0), then the race-order insert 00563620 (0055bfd0)"""
    m = o.m
    assert m.u32(0xbf63c4) == 0
    O11.ensure_world_record(m)
    m.call(0x563080, CAR, 1)
    m.call(0x550c40)
    m.call(0x550c60)
    m.call(0x5512d0)
    o.place(*stall)
    m.w32(CAR + 0x1518, 0)
    o.controls(0)
    m.uc.mem_write(0xbf6eb9, b'\x00')
    m.call(0x563620, CAR)


class OriginalWorld(O13.OriginalStage13):
    """Order (= the Luau port, NR2003CupTrack): boot track load -> car build -> track init (00579cd0, 00573af0, 005105c0)
    -> [load-image snapshot] -> Stage 11..13 session (host blocks, zone tree, series, options, steering, FFB) ->
    enterTrack = session_init (0059fa90, 00433cb0, 00578610, car+0x5ae) + 00550a50 subset with 005512f0 + 00563620."""
    def __init__(self, *a, enter=True, stall=None, **k):
        super().__init__(*a, enter=False, **k)
        m = self.m
        self.k = m.i32(CAR + 0x5b2)
        self.carobj = BG_CAROBJ + self.k * CAROBJ_SIZE
        self.stall = stall if stall is not None else _cfg.get('stall', (0.0, 0.0, 0.0))
        if enter and self.stage11:
            self.enter()

    def enter(self, stall=None):
        session_init(self)
        enter_world(self, stall or self.stall)

    def place(self, dlong, dlat, yaw=0.0):
        """ORIGINAL 005512f0(dlong, dlat, yaw): track -> world (005150fa), BG object init, multibody pose 00551520"""
        f = lambda x: struct.unpack('<I', struct.pack('<f', x))[0]
        self.m.call(0x5512f0, f(dlong), f(dlat), f(yaw))

    def world_frame(self):
        """005b2190 head: 005789c0(00562f70, 00566a20) broadphase, 00578a60 pair maintenance (world c74e20)"""
        m = self.m
        m.call(0x5789c0, 0x562f70, 0x566a20, ecx=WORLD)
        m.call(0x578a60, ecx=WORLD)

    def drive_tick(self, contacts=None):
        """one 005b2190 tick: 005539c0, 00578da0, 005544d0, 005544e0, 00578de0, 005544d0, 00554510"""
        m = self.m
        m.w32(0xe8441c, self.tick % O11.TICKS_PER_FRAME)
        m.uc.mem_write(0xe843fc, b'\x01')
        m.call(0x5539c0)
        m.call(0x578da0, ecx=WORLD)
        m.call(0x5544d0)
        m.uc.mem_write(0xe843fc, b'\x00')
        m.call(0x5544e0)
        m.call(0x578de0, ecx=WORLD)
        m.call(0x5544d0)
        m.call(0x554510)
        self.tick += 1

    def frame_end(self):
        m = self.m
        m.call(0x554520)
        m.call(0x549c40)

    def step_driver(self, controls, contacts=None):
        if self.tick % O11.TICKS_PER_FRAME == 0:
            self.world_frame()
            self.frame(controls)
        self.drive_tick()
        if self.tick % O11.TICKS_PER_FRAME == 0:
            self.frame_end()
        return self.state()


__all__ = ['configure', 'OriginalWorld', 'WORLD', 'BG_CAROBJ']
