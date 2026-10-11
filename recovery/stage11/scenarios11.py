"""Stage 11 scenarios: deterministic scripts run identically by the ORIGINAL code in Unicorn (OriginalStage11)
and by the Luau port (tests/stage11/run.luau reads the same script from the fixtures).

A scenario = session (weather, race options), duration in 36 Hz frames, a control law per frame and events.
Events (frame index -> list):
  ('collision', kwargs)   ORIGINAL 0054a760 record entry after the frame's last tick (see orig_stage11.collision)
  ('pit', [wheels])       ORIGINAL 00550f10 per wheel (pit tyre change)
  ('enter',)              ORIGINAL 00550a50 subset (car placed on track: repair, engine, fuel, 4 new tyres)
  ('fuel', kg)            fuel load written through the ORIGINAL 00550c60 path (setup item 0x31 = kg? see doc)
Controls use the Stage 8 brake chain (brakeControl, key binding) and the Stage 7 throttle/clutch/shift contract;
steering = provisional road-wheel target (Stage 12 pending), small values only."""

FPS = 36
DEFAULT_SESSION = dict(temperature=70, wind_mph=0, wind_dir=0, conditions=0, night=0)


def law_launch(k):
    t = k / FPS
    c = dict(throttle=1.0 if t < 30 else 0.0, clutch=1.0, steer=0.0,
             brakeControl=1.0 if 30 <= t < 36 else 0.0, brakeDigital=True)
    c['shiftUp'] = k in (40, 110, 200)
    return c


def law_overrev(k):
    # first gear held against the rev limiter (00553d70 limiter + 0051aac0 over-rev / wear accumulators)
    return dict(throttle=1.0, clutch=1.0, steer=0.0, brakeControl=0.0, brakeDigital=True)


def law_brakes(k):
    # accelerate, then repeated hard stops (brake heating / cooling through 0054f260)
    t = k / FPS
    ph = t % 12.0
    c = dict(throttle=1.0 if ph < 8 else 0.0, clutch=1.0, steer=0.0, brakeControl=1.0 if ph >= 8.5 else 0.0,
             brakeDigital=True)
    c['shiftUp'] = k in (40, 110)
    return c


def law_slide(k):
    # power slide: full throttle with steering lock (tyre sliding heat and wear, 0054d610 / 0054e9f0)
    t = k / FPS
    return dict(throttle=1.0, clutch=1.0, steer=0.12 if t > 3 else 0.0, brakeControl=0.0, brakeDigital=True,
                shiftUp=k in (40,))


def law_cruise(k):
    # gentle: first gear at part throttle, one shift (few driveline shocks: random failure stress stays low)
    t = k / FPS
    return dict(throttle=0.45 if t < 28 else 0.0, clutch=1.0, steer=0.0, brakeControl=1.0 if t >= 28 else 0.0,
                brakeDigital=True, shiftUp=k in (40, 160))


def law_idle(k):
    return dict(throttle=0.0, clutch=1.0, steer=0.0, brakeControl=0.0, brakeDigital=True)


def impacts():
    ev = {}
    # body hits at increasing magnitude on different zones (car-frame contact points), wall surface 1
    pts = [(2.4, 0.0, 0.3), (-2.5, 0.0, 0.4), (0.5, 0.95, 0.4), (0.5, -0.95, 0.4), (1.6, 0.9, 0.3), (-1.8, -0.9, 0.4)]
    for i, p in enumerate(pts):
        f = 180 + 72 * i
        ev.setdefault(f, []).append(('collision', dict(magnitude=60000.0 + 45000.0 * i, material=0x10, surface=1,
                                                       point=(10.0, 0.0, 0.5), local=p, velocity=(30.0, 0.0, 0.0),
                                                       normal=(-1.0, 0.0, 0.0), speed=20.0 + 3 * i, key=i % 8)))
    # tyre (material 0x13) impacts LF / RR with the contact-flag variant: 0054aa20 impact = |n'| (n.y x 0.5) x scale x
    # magnitude x material factor x 0.5 = 100000 / 150000, above the wheel limits 65000 / 75000 (tyre states 1 / 2)
    for i, (w, p) in enumerate(((0, (1.45, 0.8, 0.0)), (3, (-1.35, -0.8, 0.0)))):
        f = 700 + 36 * i
        ev.setdefault(f, []).append(('collision', dict(magnitude=400000.0 + 200000.0 * i, material=0x13, surface=1,
                                                       flags=0x2000000 * i, point=(5.0, 0.0, 0.0), local=p,
                                                       velocity=(25.0, 0.0, 0.0), normal=(0.0, 1.0, 0.0),
                                                       speed=15.0, key=6 + i)))
    return ev


# Continuous-system scenarios run with the ORIGINAL race option 'damage' = 0 (bef700 = 0: no random component failure,
# no collision damage; thermal / wear / fuel unaffected): a random failure is a threshold of a random draw against
# stress^3, so the port's x87-vs-double differences can flip it and end the comparison. The failure logic itself is
# validated bit for bit by 'failure' (default damage scale 1.0, synchronized snapshots across the failure frame) and
# 'impacts' / 'overrev' (default damage).
NODMG = dict(damage_level=0)
SCENARIOS = {
    # name: (session, frames, law, events, options)
    'launch':   (DEFAULT_SESSION, 36 * 45, law_launch, {}, NODMG),
    'overrev':  (DEFAULT_SESSION, 36 * 40, law_overrev, {}, {}),
    'brakes':   (DEFAULT_SESSION, 36 * 50, law_brakes, {}, NODMG),
    'slide':    (DEFAULT_SESSION, 36 * 30, law_slide, {}, NODMG),
    'cold':     (dict(DEFAULT_SESSION, temperature=40), 36 * 25, law_launch, {}, NODMG),
    'hot':      (dict(DEFAULT_SESSION, temperature=110, conditions=0), 36 * 25, law_launch, {}, NODMG),
    'impacts':  (DEFAULT_SESSION, 36 * 30, law_cruise, impacts(), {}),
    'pit':      (DEFAULT_SESSION, 36 * 25, law_slide, {36 * 15: [('pit', [0, 1, 2, 3])]}, NODMG),
    'enter':    (DEFAULT_SESSION, 36 * 20, law_launch, {0: [('enter',)], 36 * 12: [('enter',)]}, NODMG),
    'x4':       (DEFAULT_SESSION, 36 * 25, law_slide, dict(), dict(NODMG, consumption=3)),
    'idle':     (DEFAULT_SESSION, 36 * 30, law_idle, {}, {}),
    'failure':  (DEFAULT_SESSION, 36 * 7, law_launch, {}, {}),
}
TRACE = ['launch', 'overrev', 'brakes', 'slide', 'impacts', 'pit', 'enter', 'x4', 'cold']


def make(name, cls=None, stage11=True):
    import orig_stage11 as O
    session, frames, law, events, opts = SCENARIOS[name]
    cls = cls or O.OriginalStage11
    st = [0.0] * 45; st[4] = 0.42; st[9] = 1.0
    o = cls(state=st, weather=session, stage11=stage11, **opts)
    return o, dict(name=name, frames=frames, law=law, events=events)


def play(o, script, traced=False, observe=None):
    import orig_stage11 as O
    flat4 = O.flat()
    for k in range(script['frames']):
        for ev in script['events'].get(k, []):
            if ev[0] == 'enter':
                O.enter_track(o, traced)
        c = script['law'](k)
        for t in range(8):
            o.step_driver(c, flat4)
        for ev in script['events'].get(k, []):
            if ev[0] == 'collision':
                if traced:
                    with o.tracer: o.collision(**ev[1])
                else:
                    o.collision(**ev[1])
            elif ev[0] == 'pit':
                for w in ev[1]:
                    if traced: o.traced_call(0x550f10, w)
                    else: o.m.call(0x550f10, w)
        if observe: observe(o, k)
