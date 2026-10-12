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


def configure(track_dir, shared_dir, server_mem=None):
    """track_dir: folder with <track>.dat + track.ini (the game's tracks/<name>/); shared_dir: tracks/shared."""
    _cfg.update(track=Path(track_dir), shared=Path(shared_dir), server=server_mem or os.environ.get('SERVER_MEM'))


_boot13 = _OR.boot


def _boot_world(*a, **k):
    m = _boot13(*a, **k)
    if not _cfg:
        return m
    # the Stage 11 'no track' stub of 005f58d0 was written but never executed: restore the original code
    m.uc.mem_write(0x5f58d0, OT.original_bytes(0x5f58d0, len(O11.TRACKPOINT_STUB)))
    m.uc.ctl_flush_tb()
    import crt_x87
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


__all__ = ['configure', 'OriginalWorld', 'WORLD', 'BG_CAROBJ']
