"""Stage 12 scenarios: deterministic steering scripts run identically by the ORIGINAL code in Unicorn
(orig_stage12.OriginalStage12) and by the Luau port (tests/stage12/run.luau reads the script from the fixtures).

A scenario = session, duration in 36 Hz frames, a control law per frame, events and options:
  options.steer   steering options applied through the ORIGINAL setters (orig_stage12.set_steer_options):
                  linearity (controls.cfg 0..100), momentum (0..100), lowSpeedOverride, yawLimiter (race bit 25)
  options.ratio   steering ratio, setup item 0x30 (garage integer 12..32; the Luau test applies it through the Stage 10
                  garage pipeline, the reference writes the active setup cell: item 0x30 is read only at run time by
                  00554fb0 -- STAGE12_RECOVERY.md)
Controls: Stage 8 brake chain (brakeControl, key binding), Stage 7 throttle / clutch / shifts, Stage 12 steering:
  steerLeft / steerRight (controls 7 / 8, 0..1) + steerDigital (keys) or steerAxis (-1..1, + right, analog axis).
Coverage (STAGE12_VALIDATION.md): keys (taps, reversal, repeated taps, holds, lift-off), analog slalom through the
low-speed ratio transitions, linearity 80 + momentum 0 steps (+-0.01 .. +-1) at rest and constant-radius hold,
braking / power while steering through 17.88 / 8.94 m/s, setup ratio 12 / 32, override off, yaw limiter, car not
driven, stationary full-lock geometry."""
import math

FPS = 36
DEFAULT_SESSION = dict(temperature=70, wind_mph=0, wind_dir=0, conditions=0, night=0)
NODMG = dict(damage_level=0)


def _base(k, throttle=1.0, shifts=(40, 110)):
    return dict(throttle=throttle, clutch=1.0, brakeControl=0.0, brakeDigital=True, shiftUp=k in shifts)


def _within(t, a, b): return a <= t < b


def law_keys(k):
    t = k / FPS
    c = _base(k, throttle=0.0 if _within(t, 17.0, 19.0) else 0.8)
    left = right = 0.0
    if _within(t, 2.0, 2.5) or _within(t, 7.0, 7.3) or _within(t, 14.0, 14.4): left = 1.0
    if _within(t, 4.0, 4.5) or _within(t, 7.3, 7.6) or _within(t, 17.5, 17.8): right = 1.0
    for s in (10.0, 10.6, 11.2):                                    # repeated identical taps
        if _within(t, s, s + 0.2): left = 1.0
    if _within(t, 21.0, 21.25): left = right = 1.0                  # both keys (cancel)
    c.update(steerLeft=left, steerRight=right, steerDigital=True)
    return c


def law_slalom(k):
    t = k / FPS
    c = _base(k, shifts=(40, 110, 220))
    a = 0.08 * math.sin(2 * math.pi * 0.5 * (t - 3.0)) if t > 3.0 else 0.0
    c.update(steerAxis=a)
    return c


STEPS = [0.01, 0.25, 0.5, 0.75, 1.0, -0.01, -0.25, -0.5, -0.75, -1.0, 0.0]


def law_linear(k):
    t = k / FPS
    if t < 6.0:                                                     # at rest: input steps (geometry, linearity)
        c = _base(k, throttle=0.0, shifts=())
        i = int(t / 0.5)
        c.update(steerAxis=STEPS[i] if i < len(STEPS) else 0.0)
        return c
    c = _base(k, throttle=0.6 if t < 18.0 else 0.0, shifts=(36 * 6 + 20, 36 * 8))
    c.update(steerAxis=0.05 if t > 10.0 else 0.0)                   # constant radius, lift-off at 18 s
    return c


def law_brakesteer(k):
    # Stable launch (throttle 0.8 as 'keys'; a full-throttle launch spins the ORIGINAL car with zero steering input,
    # chaotic for the original itself -- STAGE12_VALIDATION.md), then: lift + steer 0.05 at 27 m/s, braking while
    # steering through 17.88 and 8.94 m/s, release, power while steering (-0.12) back through 8.94 and 17.88 m/s,
    # coast straight through 17.88 m/s again.
    t = k / FPS
    c = _base(k, throttle=0.8 if t < 9.0 else (0.7 if _within(t, 15.0, 24.0) else 0.0))
    c['brakeControl'] = 0.6 if _within(t, 10.0, 14.0) else 0.0
    s = 0.0
    if _within(t, 9.0, 14.0): s = 0.05
    if _within(t, 15.0, 24.0): s = -0.12
    c.update(steerAxis=s)
    return c


def law_ratio(k):
    t = k / FPS
    c = _base(k, shifts=(40, 110))
    c.update(steerAxis=0.1 * math.sin(2 * math.pi * 0.4 * (t - 2.0)) if t > 2.0 else 0.0)
    return c


def law_parking(k):
    t = k / FPS
    c = _base(k, throttle=0.35 if t < 12.0 else 0.0, shifts=(40,))
    c['brakeControl'] = 1.0 if t >= 12.0 else 0.0
    left = 1.0 if (_within(t, 2.0, 3.5) or _within(t, 8.0, 9.0) or _within(t, 13.0, 14.0)) else 0.0
    right = 1.0 if (_within(t, 4.5, 6.0) or _within(t, 10.0, 11.0)) else 0.0
    c.update(steerLeft=left, steerRight=right, steerDigital=True)
    return c


def law_yawlimit(k):
    t = k / FPS
    c = _base(k, throttle=0.9 if t < 14.0 else 0.0, shifts=(40, 110, 220))
    s = 0.0
    if _within(t, 6.0, 9.0): s = 0.1
    if _within(t, 10.0, 12.0): s = -0.15
    if _within(t, 14.0, 16.0): s = 0.2
    c.update(steerAxis=s)
    return c


def law_notdriven(k):
    t = k / FPS
    c = _base(k, throttle=0.7, shifts=(40,))
    c.update(steerAxis=0.3 if _within(t, 3.0, 8.0) else 0.0)
    if _within(t, 5.0, 7.0): c['driver'] = False
    return c


def law_stationary(k):
    t = k / FPS
    c = _base(k, throttle=0.0, shifts=())
    if t < 6.0: c.update(steerAxis=math.sin(2 * math.pi * t / 6.0))   # one slow full-lock sweep (analog)
    else:
        c.update(steerLeft=1.0 if _within(t, 6.5, 8.5) else 0.0, steerRight=1.0 if _within(t, 9.0, 11.0) else 0.0,
                 steerDigital=True)
    return c


SCENARIOS = {
    # name: (session, frames, law, events, options)
    'keys':       (DEFAULT_SESSION, 36 * 24, law_keys, {}, dict(NODMG)),
    'slalom':     (DEFAULT_SESSION, 36 * 30, law_slalom, {}, dict(NODMG)),
    'linear':     (DEFAULT_SESSION, 36 * 22, law_linear, {}, dict(NODMG, steer=dict(linearity=80, momentum=0))),
    'brakesteer': (DEFAULT_SESSION, 36 * 28, law_brakesteer, {}, dict(NODMG)),
    'ratio12':    (DEFAULT_SESSION, 36 * 16, law_ratio, {}, dict(NODMG, ratio=12)),
    'ratio32':    (DEFAULT_SESSION, 36 * 16, law_ratio, {}, dict(NODMG, ratio=32)),
    'parking':    (DEFAULT_SESSION, 36 * 16, law_parking, {}, dict(NODMG, steer=dict(lowSpeedOverride=False))),
    'yawlimit':   (DEFAULT_SESSION, 36 * 18, law_yawlimit, {}, dict(NODMG, steer=dict(linearity=50, yawLimiter=True))),
    'notdriven':  (DEFAULT_SESSION, 36 * 12, law_notdriven, {}, dict(NODMG)),
    'stationary': (DEFAULT_SESSION, 36 * 12, law_stationary, {}, dict(NODMG, steer=dict(momentum=40))),
}


def make(name, kick=None):
    import orig_stage12 as O, gen_fixtures11 as G11
    session, frames, law, events, opts = SCENARIOS[name]
    opts = dict(opts)
    steer, ratio = opts.pop('steer', None), opts.pop('ratio', None)
    st = [0.0] * 45; st[4] = 0.42; st[9] = 1.0
    if kick: st[kick[0]] = G11.ulp(st[kick[0]], kick[1])
    return O.OriginalStage12(state=st, weather=session, steer_options=steer, setup_ratio=ratio, **opts)
