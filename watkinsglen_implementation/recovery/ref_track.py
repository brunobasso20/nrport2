"""Reference runs of the ORIGINAL track / collision world (orig_world.OriginalWorld in Unicorn) for the Luau generator
and the regression fixtures.

  python3 ref_track.py plain <out.pkl>              load-image snapshot of the car without a track (diff base)
  python3 ref_track.py world <out.pkl> [scenario..] load-image snapshot with Watkins Glen + per-scenario footprint
                                                    and fixtures (states every tick, written cells at checkpoints)
Environment: NR2003_MEM, SERVER_MEM, RTS_MEM (Ghidra memory exports), WG_TRACK (tracks/watkins_glen), WG_SHARED
(tracks/shared)."""
import os
import sys
import math
import pickle
import struct
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE.parent.parent / 'recovery' / 'stage12'))
import orig_world as W  # noqa: E402

FPS = 36
DEFAULT_SESSION = dict(temperature=70, wind_mph=0, wind_dir=0, conditions=0, night=0)
DEV = dict(capable=True, acquire=True)


def _base(k, throttle=0.0, shifts=()):
    return dict(throttle=throttle, clutch=1.0, brakeControl=0.0, brakeDigital=True, shiftUp=k in shifts, steerAxis=0.0)


def law_idle(k):
    return _base(k)


def law_launch(k):
    t = k / FPS
    c = _base(k, throttle=0.8 if t < 4.0 else 0.0, shifts=(18,))
    return c


def law_wall(k):
    # pit lane, toward the pit wall on the right (lane_on_right = 1, lane_has_wall = 1): body / wall contacts
    t = k / FPS
    c = _base(k, throttle=0.6 if t < 3.0 else 0.0, shifts=(18,))
    c['steerAxis'] = 0.35 if 0.8 < t < 3.0 else 0.0
    return c


# name: (stall (dlong, dlat, yaw), frames, law, checkpoint frames)
SCENARIOS = {
    'stall0': ((341.13, -19.61, 0.0), 24, law_idle, (1, 2, 24)),
    'launch': ((255.0, -0.21, 0.0), 36 * 5, law_launch, (1, 36, 36 * 5)),
    'wall':   ((341.13, -19.61, 0.0), 36 * 4, law_wall, (1, 36 * 2, 36 * 4)),
}
STATE0 = [0.0] * 45
STATE0[4] = 0.42
STATE0[9] = 1.0
HOST_EXCLUDE = W.HOST_EXCLUDE


def track_eips():
    """instruction addresses of the lifted track set (lift/lift_track.py)"""
    sys.path.insert(0, str(HERE / 'lift'))
    import lift_track
    L, errors = lift_track.lift(strict=True)
    eips = set()
    for f in L.funcs:
        if f in L.alias or f >= 0x10000000:
            continue
        ins, leaders, calls = L.discover(f)
        eips |= set(ins)
    return eips


def make(plain=False, scenario=None):
    W.SNAPSHOT['on'] = True
    W.SNAPSHOT['trace'] = not plain
    if not plain and 'eips' not in W.SNAPSHOT:
        W.SNAPSHOT['eips'] = track_eips()
    if not plain:
        S = os.environ
        stall = SCENARIOS[scenario][0] if scenario else (0.0, 0.0, 0.0)
        W.configure(S['WG_TRACK'], S['WG_SHARED'], S.get('SERVER_MEM'), stall=stall, rts_mem=S.get('RTS_MEM'))
        return W.OriginalWorld(state=list(STATE0), weather=DEFAULT_SESSION, ffb=dict(enabled=True), device=DEV,
                               damage_level=0)
    import orig_stage13 as O13
    return O13.OriginalStage13(state=list(STATE0), weather=DEFAULT_SESSION, ffb=dict(enabled=True), device=DEV,
                               damage_level=0, enter=False)


def written_cells(m, cells, lo, hi):
    out = {}
    for a in sorted(cells):
        if lo <= a < hi and not (HOST_EXCLUDE[0] <= a < HOST_EXCLUDE[1]):
            out[a] = m.u32(a)
    return out


def run(scenario):
    stall, frames, law, checks = SCENARIOS[scenario]
    o = make(scenario=scenario)
    m = o.m
    top = m.arena_top
    snap = m.load_snap
    fx = {'stall': stall, 'frames': frames, 'controls': [], 'states': [], 'checks': {}}
    fx['enter'] = written_cells(m, m.written, 0x6e9000, top)
    for f in range(frames):
        c = law(f)
        fx['controls'].append(c)
        for t in range(8):
            st = o.step_driver(c)
            fx['states'].append([struct.unpack('<I', struct.pack('<f', x))[0] for x in st])
        if f + 1 in checks:
            fx['checks'][f + 1] = written_cells(m, m.written, 0x6e9000, top)
    m.uc.hook_del(m.trace_hook)
    m.uc.hook_del(m.write_hook)
    return snap, m.touched, fx, top


if __name__ == '__main__':
    mode, out = sys.argv[1], sys.argv[2]
    if mode == 'plain':
        o = make(plain=True)
        pickle.dump({'snap': o.m.load_snap}, open(out, 'wb'))
    else:
        res = {'scenarios': {}}
        for name in (sys.argv[3:] or list(SCENARIOS)):
            snap, touched, fx, top = run(name)
            res['snap'], res['top'] = snap, top
            res['scenarios'][name] = {'touched': touched, 'fixture': fx}
            print(name, 'touched', len(touched), 'final pos', [struct.unpack('<f', struct.pack('<I', fx['states'][-1][i]))[0] for i in (0, 2, 4)])
        pickle.dump(res, open(out, 'wb'))
