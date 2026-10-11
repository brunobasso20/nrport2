"""Stage 13 scenarios: deterministic scripts run identically by the ORIGINAL code in Unicorn (orig_stage13.OriginalStage13)
and by the Luau port (tests/stage13/run.luau reads the script from the fixtures).

Six scenarios reuse the Stage 12 laws unchanged (scenarios12: same session, steering options, setup ratio), with the force
feedback switched on: the physics of such a run is the Stage 12 run (nothing of the FFB feeds back -- dynamic proof in
STAGE13_VALIDATION.md), so the Stage 12 full-state restarts of the same scenario carry the original's 00554d30 cells.
'suspend' is new: player controls suspended through the ORIGINAL 00550070(1) / (0) (bf6eb8: 005524f0 not-driven branch +
FFB gate, zero force) and a device switch analog -> keys -> analog (binding change: 0054fed0 releases / re-acquires).

  options.ffb     FF options through the ORIGINAL setters (controls.cfg integers): enabled, strength, damping, latency
  options.device  host device layer: capable (FF on the steering axis), acquire (acquisition result)
  events          frame -> list of ('controls', flag): ORIGINAL 00550070(flag) before that frame (Luau setControlsSuspended)"""
import sys, math
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent / 'stage12'))
import scenarios12 as SC12                                          # noqa: E402

FPS = SC12.FPS
DEFAULT_SESSION, NODMG = SC12.DEFAULT_SESSION, SC12.NODMG
DEV = dict(capable=True, acquire=True)


def law_suspend(k):
    t = k / FPS
    c = SC12._base(k, throttle=0.8 if t < 15.0 else 0.0, shifts=(40, 110))
    if SC12._within(t, 11.0, 13.0):            # device switch: keys (digital binding -> FF released), back to the axis
        c.update(steerLeft=1.0 if SC12._within(t, 11.5, 12.0) else 0.0, steerRight=0.0, steerDigital=True)
    else:
        c.update(steerAxis=0.07 * math.sin(2 * math.pi * 0.4 * (t - 2.0)) if t > 2.0 else 0.0)
    return c


def _from12(name, ffb, frames=None):
    session, n, law, events, opts = SC12.SCENARIOS[name]
    o = dict(opts); o['ffb'] = ffb; o['device'] = DEV
    return (session, frames or n, law, dict(events), o)


SCENARIOS = {
    # name: (session, frames, law, events, options)
    'slalom':     _from12('slalom', dict(enabled=True)),                                        # image 80 / 0 / 0
    'brakesteer': _from12('brakesteer', dict(enabled=True, strength=100, damping=30, latency=50)),
    'ratio12':    _from12('ratio12', dict(enabled=True, strength=50, damping=100, latency=250)),
    'linear':     _from12('linear', dict(enabled=True, damping=10, latency=120)),
    'keys':       _from12('keys', dict(enabled=True)),                                          # digital: never acquired
    'notdriven':  _from12('notdriven', dict(enabled=True, damping=20)),
    'suspend':    (DEFAULT_SESSION, 36 * 18, law_suspend, {216: [('controls', 1)], 288: [('controls', 0)]},
                   dict(NODMG, ffb=dict(enabled=True, strength=90, damping=50, latency=80), device=DEV)),
}


def make(name, kick=None):
    import orig_stage13 as O
    sys.path.insert(0, str(HERE.parent / 'stage11'))
    import gen_fixtures11 as G11
    session, frames, law, events, opts = SCENARIOS[name]
    opts = dict(opts)
    steer, ratio = opts.pop('steer', None), opts.pop('ratio', None)
    ffb, device = opts.pop('ffb', None), opts.pop('device', None)
    st = [0.0] * 45; st[4] = 0.42; st[9] = 1.0
    if kick: st[kick[0]] = G11.ulp(st[kick[0]], kick[1])
    return O.OriginalStage13(state=st, weather=session, steer_options=steer, setup_ratio=ratio, ffb=ffb, device=device, **opts)
