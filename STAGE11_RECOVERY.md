# Stage 11 — recovery report (thermal / wear / damage / fuel)

Base: Stage 10 package (`3.9.0-stage10`). Sources: the OpenNR2003 Ghidra project (`NR2003.exe`, headless Ghidra 11.1.2 +
JDK 21 on this machine, read-only, scripts `recovery/ghidra_tools/`), the memory export of that project, and the
original x86 executed in Unicorn 2.1.4 (Stage 6/7 harness). Raw evidence: `recovery/stage11/evidence/b1..b4/*.c|*.asm`
(Ghidra decompilation + assembly with constants, `index.tsv` callers/callees), xref / operand scans
(`evidence/xref_*.tsv`, `scan_*.txt`), lift call graph (`evidence/lift_callgraph.txt`). Clean pseudo-C:
`recovery/stage11/pseudo/stage11_runtime.c`. State map: `STAGE11_STATE_MAP.md`. Validation: `STAGE11_VALIDATION.md`.

## 1. Audit of the Stage 10 baseline (PART 1)

| Item in the baseline | Class | Note |
|---|---|---|
| Frame end `V._frameEnd` (core) = cut-timer countdown of `0051aac0` only | **C provisional subset** | everything else of `00554520` frozen at the build values (documented in Stages 6–10) |
| Brake temperature: `V.brakeTemperature` reads `tire+0x26c` (protected) | **D adapter (read only)** | value frozen at 295 K (build) |
| Tyre fields written once by the build (`0054d610` ×4 at the end of the build) | **A exact (build)** | never updated afterwards |
| Fuel: `00550c60` in the build (62.47 kg cell), fuel record mass cells | **A exact (build)** | never consumed |
| Aero damage `00410910` (Stage 9) | **A exact** | reads damage zones that nothing wrote (always 0) |
| Damage-related natives inside the Stage 6/7 core (`0055fc50`, `005614b0` read `c086e0`; `0051c1e0` stress accumulator) | **A exact** | inputs never set at run time |
| `CupChassisAdapter` telemetry `temperature = tune.environment.ambientC` | **E invented/test-only** | replaced by the original tyre temperature |
| `TireThermal.lua`, `TestTune` tyre / thermal values (Stage 5 `NR2003_CORE` / `ROBLOX_ADAPTER` modes) | **E test-only** | not used by `NR2003_CUP`; untouched |
| Engine thermal, fuel burn, mass evolution, tyre heat / pressure / wear / failure, damage events, random failures, pit / reset paths | **F not implemented** | Stage 11 |

No provisional Stage 11 logic stays active: in production (`"original"` runtime) the whole original frame end runs; the
Stage 6–10 subset survives only as the explicit `"frozen"` mode used by the Stage 6–10 regression suites.

## 2. Where the systems run (PART 17 — update order)

Simulation task (CW 0x077f), one 36 Hz frame = 8 × 288 Hz ticks (`005b2190`):

```
task loop 005f78f0 : ++getBGCount (0x7559bc)
0055bfd0           : 005a4cc0 dynamic weather (not ported, Stage 9) ; per car 005637e0 (aero factors, airspeed C+0x5aa,
                     drafting)                                        [Stage 9: V._aeroFrame]
005b2190           : 00551e80 frame start (pedals; per-frame tyre accumulators cleared)
                     8 x tick: 005539c0 inputs + predictor, tyres 00578da0 (00576e00 -> 0055e1e0 [+ 0054a760 records]),
                               forces (0051c1e0 stress accumulation inside), corrector, tyres, forces, commit
                     00554520 FRAME END (player car):
                        00551ce0 attitude filter (presentation)
                        005547a0 world/replay record (host)
                        bf3a00 = C+0x5aa (airspeed)
                        radiator air = (1 - grille tape) [x0 if damage component 1 destroyed] x front draft factor
                        0051a830 radiator inputs (1.1, rho, air C, airspeed, radiator air)
                        0051aac0(dt = 1/36) engine: ignition/misfire, fuel burn, water/oil temperature and levels,
                                 leaks, x4d0, over-rev, wear/life, random engine failure, power x rho/1.2
                        0051c3d0 random component failures (stress^3 x damage scale ; component 7)
                        005605c0 fuel mass -> fuel component record (mass, inertia)
                        [inBackground] 005f74c0 world-record angles ; 00551990 car snapshot +
                                       per tyre 0054d610 (pressure, contact fields, 3+3 zone temperatures,
                                       brake temperature 0054f260, wear 0054e9f0 every 0.2 s, smoke/skid) + 00556e30
                        force feedback (bf6ebb; Stage 13)
0055bfd0 (after)   : 00549c40 collision damage of the frame's records (00549290 / 00549860 / 0054a2a0 / 0054a330)
```

Cadences: everything above runs **once per frame (36 Hz)**; tyre wear integrates every 0.2 s of its own clock
(`T+0x134`); engine wear tests every 0.2 s (`E+0x558`); the stress accumulator is per tick (Stages 6/7 code), tested per
frame. Stage 11 states are read by the ticks of the **next** frame (previous-frame values): the generated callbacks read
the fuel record mass/inertia cells, the tyre model `0054cab0` reads the hot pressure / contact fields / grip, the engine
torque `0051a870` reads the power factor `E+0x554`, the drivetrain natives read the broken-component flags `c086e0`.

## 3. Recovered functions (new in Stage 11)

All listed functions are lifted from x86 into `core/NR2003Cup/NR2003CupFrameCode1..4` (216 functions in total, the
closure of the roots below) and executed on the core memory. Callers/callees: `evidence/b*/index.tsv`.

| Address | Role | Notes |
|---|---|---|
| `00554520` | frame end of the player car (order above) | root, whole function |
| `0051aac0`, `0051a9c0`, `0051be00`, `0040bde0`, `0051c850`, `00551e10` | engine frame: misfire, fuel burn (BSFC 275 − 115·rpm/max), thermal, leaks, wear/failure, starter | |
| `0051a830`, `0051a000` | radiator inputs, engine object | |
| `0051a020` (via `00550c40`) | engine init: water 93 °C, oil 0 °C, levels, flags | reset path |
| `00550c60` | fuel load (race: setup item 0x31; otherwise spec full cell 62.4698 kg) | reset path |
| `005605c0`, `005b4840` | fuel mass and inertia → fuel component record | |
| `00551990`, `00551890/920/950`, `00556e30`, `00565840`, `00565b70`, `00565c30`, `00562f50` | car snapshot / tyre visual (presentation, kept for draw-order parity) | |
| `0054d610` | tyre frame: ambient, rolling resistance, hot pressure, stiffness, heat input, 3-zone surface/carcass thermal model, cooling, skid/smoke | |
| `0054f260` | brake temperature (no fade: `0054f3d0` / `0054f610` are unreferenced) | |
| `0054e9f0`, `0054ef10` | tyre wear, blow-out, grip = 1 − 0.2·wear | |
| `0054fb50`, `00425e80`, `0040e980`, `0051c3f0`, `0051c5d0`, `004f68c0`, `004f69a0/6900/6a80` | protected value read / write / relocation | |
| `005100a0/b0/c0/e0`, `00510080/90`, `00579e80`, `00579ee0`, `00579ef0`, `00579e50`, `00579f00` | surface / compound / global tables | |
| `0051c3d0`, `0051c300`, `0051c380`, `00548a00`, `00548aa0`, `0054b940`, `0055e7e0` | random component failures → broken flags | |
| `00549c40`, `00549290`, `00549860`, `00549ab0`, `0054a2a0`, `0054a330`, `00549c00`, `00548760`, `00548740` | collision damage, leaks, fire chance, debris, parts off | |
| `0054a760`, `0054a8d0`, `0054aa20`, `0054a710`, `00547e20`, `00547e00` | collision record entry, wheel impacts, zone lookup (BSP `00890490`) | |
| `005486a0`, `0054b6c0`, `0054b5a0`, `0054b610`, `0054b4c0`, `0054b7d0`, `0054b800`, `0054b8c0`, `0054b900`, `0054b970`, `0054b9b0`, `0054ba50`, `0054b0d0` | damage object accessors (packed words + decoded floats) | |
| `00563080`, `0054b3c0`, `0054b410`, `00547ee0`, `00563070` | car reset / repair | reset path |
| `005512d0`, `00550f10` | four new tyres / pit tyre change (session air temperature `e0b834` incl. sun + 11 °C, cold pressure from setup, wear 0) | |
| `00547e90` | race option 'damage' → `bef700` = {0, 0.15, 0.6, 1.0} | session |
| `00433610`, `00433660`, `00547e60` | collision-damage zone tree (constant split planes, static node pool `*bf39d4`), built once per car load (game: `00432d90`) | session (finding 8) |
| `00583250`, `00583490`, `00583590`, `005835b0`, `00583800`, `00583930`, `00583a20`, `00582320`, `00582450`, `005859a0`, `00585970`, `00585e30`, `005861e0`, `005862c0`, `00585da0..00585e00`, `0054d400`, `0054d430`, `0054d580`, `005b5800`, `005b5290`, `005b4de0`, `005b4e60` | sparks / smoke / skid / debris particles | presentation, **kept**: they draw from the physics random stream 0 |
| `005f5650`, `005f5670`, `005f56b0`, `005f56e0` | rndSeed / rndInt / rndUniform / rndNormal (LCG ×0x19660d + 0x3c6ef35f, stream 0 = physics, 1 = weather) | |
| `005f5a60`, `005f5ac0`, `005f59f0`, `005f6e40`, `005f74c0`, `005f6a70`, `005f6d20`, `005f6dc0`, `005f7570` | world-record pose, matrices, angles | |
| `005f7cb0`, `005f7cc0`, `005f7cd0` | getBGCount / getSVCount / getIntCount (memory counters) | |

## 4. Findings (what the shipped NR2003 does and does not do)

1. **Fuel affects physics only through mass**: the fuel component record (`*c08234`) is a variable-mass record (the build
   flags it; `005b4060`); `005605c0` writes fuel kg into its mass cells and fuel·0.1 into its inertia diagonal every frame.
   The generated solve recomputes the aggregate mass, CG and inertia of the 45-state multibody — there is no explicit CG
   formula. Fuel is a protected double in kg; the practice / test session (bench) loads the full cell (62.4698 kg), a
   race loads the garage item 0x31.
2. **Engine power depends on air density** (`E+0x554 *= ρ·0.8333`), misfire on engine damage, and goes to 0 out of fuel.
   Water/oil temperatures, coolant/oil levels and leaks are real states; overheating feeds wear and random failure.
3. **Tyres**: 3 tread zones × (surface + carcass) temperatures, hot pressure by a damped gas law
   ((T̄carcass − Tamb)·0.4 + Tamb)/Tamb·P_cold, stiffness falling with surface temperature, wear with an
   over-temperature cubic term, grip = 1 − 0.2·wear, blow-out probability above 0.66 wear, flat tyre → cold pressure 0,
   grip 0.6. New tyres start at the session air temperature `e0b834` (sun-heated: 49.1 °C at 70 °F) + 11 °C (`00550f10`), not at the garage tyre readings.
4. **Brakes**: temperature evolves (`0054f260`) but **nothing reads it**: fade `0054f3d0` and failure `0054f610` are
   unreferenced in the shipped executable (confirms Stage 8).
5. **Suspension / chassis damage geometry does not exist in the shipped executable**: the hooks that would apply wheel /
   suspension damage (`0055e610`, `0055e670`, `0055e6c0`, `0055e780`) are `ret`, `0055e5d0` only consumes one random draw.
   Wheel damage levels exist as state and drive debris; tyre damage states deflate tyres. Broken *components* (9 flags
   `c086e0`) do reach the drivetrain natives (`0055fc50`, `005614b0`) and the transmission (`005536b0`, `00553920`,
   `005538f0`, `005538a0`). Body-zone damage deforms only the **collision** shapes of the track system (`0054b0d0` →
   `00577cb0`, host objects `c7e75c`), not the multibody.
6. **Aero damage**: zone values `D+0x10..+0x38` → `00410910` (Stage 9, unchanged). Zone 1 destroyed also removes the grille
   tape effect on the radiator (`00554520`).
7. **Random events share one stream** (stream 0) with particles (sparks, smoke, debris): the visual particle functions
   are part of the deterministic draw sequence and are lifted, not stubbed.
8. **Damage sources**: collision records entered by the track contact code (tyre contacts `00576e00`: magnitude = the
   value returned by `0055e1e0`; body contacts: unanalysed code around `005762f6` / `00576c1b`), evaluated by
   `0054a8d0` (immediately) and `00549c40` (frame end); random driveline failures (stress accumulated per tick); engine
   failures (`0051aac0`); tyre blow-outs (`0054e9f0`). Gates: damage scale `bef700` (race option), car series field
   `C+0x596` ≠ 0 (roster), world record present, car in the race order (`C+4` ≠ 0: `00549c40` body damage **and**
   `0054a330` wheel / tyre impact states) and the **collision-damage zone tree** (`00890490[chassis type]` ≠ 0, else
   the zone lookup `0054a710` returns −1). The tree is built from constants in the executable by `00433610` →
   `00433660` (split planes on the car-frame point, nodes from the static pool `*bf39d4` via `00547e60`), called by the
   car-model load `00432d90`, and shared by all 6 chassis types. **Neither the race-order link nor the tree exists in
   the physics-only bench (Stages 6–10 build)**: without them no collision could ever damage the car, in the original
   harness as in the port. Stage 11 runs the original `00433610` at the session start and puts the car in a one-car
   race order around `00549c40` (host state, §5); zones for car-frame points: front bumper (2.4, 0, 0.3) → 4,
   rear (−2.5, 0, 0.4) → 9, sides → 7 / 8, LF wheel → 0, RR quarter → 3.
9. **Reset**: `00550a50` (car placed on track by the simulation task) repairs, re-initialises engine and fuel and fits four
   new tyres. A garage setup rebuild (Stage 10) restores the build values.

## 5. Host boundary (ADAPTER) — identical in the Luau port and in the Unicorn reference

| Original | Why it cannot run in the bench | Port |
|---|---|---|
| `005547a0` world/replay record (`005a02b0`) | track geometry not loaded (faults in `0051455c`) | `ret` |
| `00592dc0` damage → replay recorder / multiplayer | no session object | `ret` |
| `00557650` collision sound event | audio / replay recorder | `ret` |
| `005d08d0` force-feedback output | Stage 13 | `ret` (only reached with FFB on) |
| `005f58d0` world point → track point (`0051370a`) | no track | copy point, clear the track fields |
| `005543f0` world record pose (per tick, track query) | no track | pose synced from the exported state before the frame end (lifted `005f5a60` / `005f5ac0`) |
| task loop counter | host loop | `++0x7559bc` before each frame |
| `getIntCount` (`005f7cd0` → `[7559c4]`, timer-interrupt counter) | host clock | +1 per frame at the frame start (same convention as the Stage 8 harness `INTCOUNT`); read by the lifted `00567660` (called by `0054a8d0` for tyre / continuous contact records: table row copy + `getIntCount` stamp at `C+0x1323`). The Stage 8 speed cache tag `74c9ac` stays unused (Luau `speed()` recomputes) |
| `00554d30` FFB frame statistics (called by `005539c0` every tick; writes `74c960..68`, `bf6ec4/ec8/ed0`, clears `bf6ed4..ef0`) | not ported in Stage 7 (PORT_MAP: "estatísticas de frame") | read only by the force-feedback block of `00554520`, gated by `bf6ebb` = 0 (no device): no effect on the physics; Stage 13 |
| `005512f0` placement, `00550070` FFB setup, `00524930` driver aids | host / Stage 13 | not run in `enterTrack` |
| roster series field `C+0x596` | Stage 6/7 build used 0; real Cup roster value not recovered | **PROVISIONAL** = 1 in the Stage 11 session (only gates collision damage) |
| car-model load `00432d90` → `00433610` (collision-damage zone tree) | the bench loads no car model | the ORIGINAL `00433610(C+0x58e)` (lifted) at every Stage 11 session start, before the series / options / car placement, in the port and in the Unicorn reference (`V.buildDamageZones`) |
| race order (ring `C+4` / `C+8`, Stage 9) | one car, no race order built; `C+4` ≠ 0 would also enable the per-tick render copy `005543f0`, which queries the unloaded track | **ADAPTER**: one-car ring (links → `C+4`) set around `00549c40` only, restored after (port and reference) |
| body collision records (magnitude from the original body contact physics) | body-contact physics not recovered | API `V.collision(record)` with the original record fields; the Roblox bench offers a TEST-only injection |

## 6. Numeric notes (PART 18)

- Float32 stores round toward −∞ (CW 0x077f) exactly as the original; exact-zero sums are signed as under RC-down
  (`ZADD`, Stage 10 lifter option enabled for all Stage 11 code); `frndint` = floor; `fscale` truncates.
- x87 extended intermediates are evaluated in IEEE double (Stage 6/7 convention). Measured consequence inside one frame
  end: **one** cell differs — the fuel double, by 1 ulp (≈ 1e−16 relative), because the original stores an 80-bit
  result rounded toward −∞ and the port a double rounded to nearest. All float32 Stage 11 states were bit-exact in
  every synchronized snapshot.
- Protected values: rdtsc = 1 in both harnesses (no re-keying / relocation), so encoded words compare directly.
- **Inherited per-tick differences (measured, Stage 6/7 convention).** A whole-memory diff of the port against the
  original, frame by frame (`recovery/stage11/dev/memdump.py` + `tests/stage11/dev/memdiff.luau`), shows 1–4 ulp
  differences in a few chassis state cells from the first frame on, **identically with the Stage 11 runtime frozen**
  (Stages 6–10 only). No Stage 11 field differs by more than a few ulps in those frames. Experiments: running the
  original with a 53-bit x87 significand leaves 900 frames bit-identical (float32 stores rounded down hide the
  intermediate width), so the residual differences come from specific spots of the per-tick runtime, among them the
  sign of exact-zero sums (the Stage 6/7 runtime lift returns +0 where the x87 under RC-down gives −0; the Stage 10/11
  lifts emulate it with `ZADD`).
- **Sensitivity of the original itself.** One frame of the original re-run from its own state with a 1-ulp change of an
  integrated chassis cell moves solver cells and some chassis rates by up to ~1e−3 relative (same cells, same size as
  the port's one-frame differences). Over seconds the trajectories are chaotic: in the `hot` launch 3 of 10 noise twins
  of the original leave the wheel-spin regime and accelerate cleanly, as the port does. The validation therefore uses
  the original's own twins as tolerance (`STAGE11_VALIDATION.md`).
- **Quasi-static creep (inherited).** With the car in neutral at the rev limiter (`overrev`), the Stage 6–10 runtime
  leaves the original's stick-slip creep branch after ~2.5 s also in frozen mode (frame 108: 0.024 vs 0.0055 m/s); the
  rolling wheels then heat their brakes slightly differently (+0.13 K). Not a Stage 11 effect; recorded as an open item
  of the Stage 6/7 runtime (§8).

## 7. Integration points changed outside Stage 11 (why)

| File | Change | Reason |
|---|---|---|
| `core/NR2003Cup/NR2003CupDriver.lua` | `V.drive` calls `V._frameStart11()` before the frame and `V._frameEnd()` (looked up at run time) | the frame end is replaced by the original one; the task-loop counter precedes the frame (`005f78f0`) |
| `core/NR2003CupVehicle.lua` | loads `NR2003CupFrame` (before the garage), Stage 11 API wrappers, `startSession(weather, opts)` | the image supplement must be part of the reset image the garage snapshots |
| `tests/stage67|8|9|10/run.luau`, `roblox/Stage67|8|9|10SelfTest.lua`, `tools/selftest*_template.lua` | one line: `V.setRuntimeMode("frozen")` | their golden data were produced by the original code with the Stage 6–10 frame end |
| `roblox/CupChassisAdapter.lua`, `roblox/Client.client.lua` | session options, A/B attribute, TEST-only events, telemetry + HUD line | presentation / host only |

## 8. Not ported / still open

- Body-contact physics (car–wall / car–car penalty forces and the record magnitude they produce, code around
  `005762f6` / `00576c1b`, not analysed by Ghidra). Damage evaluation is ready; the producer is the open item.
- The tyre-contact record emission of `00576e00` (needs the contact object's own body-frame point; the bench `tires()`
  calls `0055e1e0` directly). Wheel-impact damage is evaluated exactly when a record is entered.
- Dynamic weather `005a4cc0` (Stage 9 item; ambient is constant per session).
- Pit menu `0040e1c0` / in-race adjustments `005601c0` / refuelling during a stop (only tyre change `00550f10` ported).
- Multiplayer damage packets (`00520af0`, `0052e990`) and replay damage records — Stage 14.
- Stage 6/7 runtime (inherited, outside Stage 11): exact-zero sums are +0 in the per-tick runtime lift (x87 RC-down:
  −0); suspected cause of the quasi-static creep divergence above. Enabling the Stage 10 `ZADD` option for the runtime
  lift would change validated Stage 6/7 code and is left to a dedicated task.
- Stage 12 (steering chain) was **not** started.
