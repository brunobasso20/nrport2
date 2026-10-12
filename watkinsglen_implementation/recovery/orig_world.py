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
    # track.ini through the ORIGINAL loaders (00572cb0 -> 00538560(grid option, 0)); grid option = race option of
    # the session (FUN_0055a680()+0x4f bit 0 inverted): host input, starting_grid_<n>
    if m.call(0x538560, _cfg.get('grid', 0), 0) != 1:
        raise RuntimeError('00538560 (track.ini) failed: %r' % (m.prof.loads,))
    m.world_boot = True
    return m


_OR.boot = _boot_world


class OriginalWorld(O13.OriginalStage13):
    def __init__(self, *a, **k):
        super().__init__(*a, **k)
        m = self.m
        # 00573010 (track init after the loaders), its non-rendering part, once the car's physics spec exists (the
        # race lines read per-wheel data 0056ed60): 0050c8d0 AI race lines (.lp; b8f258), 00579cd0 car-part x surface
        # interaction tables, 00573af0, 005105c0(PTF root)
        # 0050c8d0 (AI race lines) needs the series tables (0056c150: c5c3c8 / c5ca20) that the physics bench never
        # loads; it only sets b8f258 (opponent-wheel row 0x12 of the interaction tables: car-car wheel contacts).
        # Not run (single car, no AI): b8f258 = 0, documented.
        m.call(0x579cd0)
        m.call(0x573af0)
        m.call(0x5105c0, m.track_root)
        k = m.i32(CAR + 0x5b2)
        self.k = k
        self.carobj = BG_CAROBJ + k * CAROBJ_SIZE
        # session start 00566e50: BG object init 0059fa90 (base = carobj - 0xcc) and the car's collision geometry
        m.call(0x59fa90, ecx=self.carobj - 0xcc)
        m.w32(self.carobj - 0xcc + 0x270, k)
        if m.call(0x433cb0, k, CAR + 0x58e, self.carobj) == 0:
            raise RuntimeError('00433cb0 (collision geometry) failed')
        m.call(0x578610, ecx=WORLD)
        # world record + race order (0055bfd0 per frame: car+0x5ae = 005a13f0 record, 00563620 insert)
        m.w32(CAR + 0x5ae, self.carobj + 0x98)
        self.place(*_cfg.get('stall', (0.0, 0.0, 0.0)))
        m.call(0x563620, CAR)

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
