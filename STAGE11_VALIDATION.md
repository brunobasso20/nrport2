# Stage 11 — validation (thermal / wear / damage / fuel)

Reference = the ORIGINAL NR2003.exe code executed in Unicorn 2.1.4 (`recovery/stage11/orig_stage11.py`: the Stage 6–10
harness + the whole original frame end `00554520`, the collision frame `00549c40`, the collision record entry
`0054a760`, pit service `00550f10`, car placement `00550a50` subset, race options `00547e90`, damage-zone tree
`00433610`). Fixtures: `recovery/stage11/gen_fixtures11.py` → `tests/stage11/fixtures/` (Lua) and
`recovery/stage11/fixtures_json/` (JSON). Suite: `tests/stage11/run.luau` (`tools/run_stage11_tests.ps1` runs everything).
Results: `tests/stage11/RESULTS_STAGE11.txt`.

**Result: 66 / 66 PASS** (`tests/stage11/RESULTS_STAGE11.txt`); adapter under the Roblox mock 55 / 55; Stage 11 patch
under the Studio mock 15 / 15; Studio self-test 4 / 4 (quick, what the patch runs) and 6 / 6 (full).

| Check | Result |
|---|---|
| Session start, 12 scenarios | 12 × 8551 dwords **bit-exact** (engine, fuel, 4 new tyres, damage repaired, zone tree, options) |
| Synchronized snapshots | 45 frame-end + 8 collision + 1 pit = 54 snapshots, 420 714 dwords: **420 682 bit-exact**, 32 = the protected fuel double within 1 ulp (≤ 1.16e−16 relative), 0 other |
| Full-state restarts | 77 restarts in 12 scenarios (every 5 s and after every event): 0 cells and 0 row fields outside the envelope |
| Sensitivity of the restart check | 36 / 36 deliberate errors detected (grip −2 %, stiffness +5 %, fuel mass +2 kg, in each scenario) |
| Closed-loop runs | 12 / 12 within the envelope: 603 gated rows × 60 fields; horizons `failure` 198, `overrev` 108, `hot` 252 (after-horizon rows, reported only: `overrev` 1 field-row, `hot` 2 of 2160 outside) |
| Determinism | two 10 s runs bit-identical; checkpoint at 5 s / restore bit-identical (fuel, temperatures, wear, damage, RNG) |
| Frozen A/B mode | Stage 11 state held at the post-build values |
| Reference sanity | the restart excursions leave the reference runs unchanged (`dev/excursion_check.py`, `impacts` 1080 frames); every reference run reproduces its stored rows / snapshots / start exactly (`--restarts-only` assertion) |

## 1. What is compared, and why these tolerances

| Check | Granularity | Criterion | Justification |
|---|---|---|---|
| Session start | every dword the original Stage 11 code touches (footprint, 8000+ dwords) | **bit-exact** (protected values decoded) | same code, same inputs |
| Synchronized frame / event snapshots | original state loaded into Luau right before one frame end (`00554520` + `00549c40`), collision record, pit stop or car placement; every written dword compared | **bit-exact**, float cells ≤ 2e−5 relative (never needed), protected values decoded | isolates the Stage 11 logic from the inherited per-tick numerics; observed: 1 cell differs, the protected fuel double, by 1 ulp (x87 80-bit RC-down store vs IEEE double), ≈ 1e−16 relative |
| Full-state restarts | the original's complete memory window at the start of frame R (every dword that differs from the session start, its tyre contact blocks and interrupt clock) loaded into Luau; one complete frame (8 ticks + frame end); the whole window (packed fields matched at any alignment) and the 105-value observation row compared | each cell within **4× the original's own one-frame sensitivity**: frame R re-run by the original from the same state with ±1 ulp on one integrated chassis cell (z, x, quaternion: 6 twins) and with ±1 ulp on the whole 45-state vector before every tick (original export `005b2cb0` → ±1 ulp → original import `005b4560`: 6 twins); never tighter than 2e−5 relative / 1e−6 absolute; integer cells exact | the per-tick physics (Stages 6–10, unchanged) evaluates x87 extended intermediates in IEEE double; measured (whole-memory diff, also with Stage 11 frozen): 1–4 ulps on several state cells per frame. The original itself moves the same solver cells by up to ~1e−3 relative under a 1-ulp change in one frame (`dev/restart_twin.py`); quantised states (the driver-head component s40..s44: differences of float32 positions) move by whole quanta (1.9e−6) only under the whole-state noise (`dev/restart_twin2.py`: an unperturbed export/import round trip is bit-identical) |
| Sensitivity of the restart check | three deliberate errors in Stage 11 states the ticks read (rear-left grip factor −2 %, pressure-derived stiffness +5 %, fuel mass +2 kg) | **each must be detected** | proves the restart tolerance is far tighter than any real coupling error |
| Closed-loop runs (20–50 s) | 60 fields every 0.5 s (fuel, engine, 4 tyres × pressure / temperatures / wear / grip / brake, damage words and zones, leaks, chassis, rpm, gear, fuel record, RNG state) | within **4× the envelope of the original's ten twins** (start ±1 ulp on the chassis height; eight runs with ±1 ulp on the multibody chassis height every frame), over the row and its neighbours (±0.5 s), never tighter than 2e−5 relative / 1e−6 absolute; integer fields exact unless a twin differs | long horizons are chaotic for the original itself (in the `hot` launch 3 of 10 noise twins leave the wheel-spin regime, as the port does); the twins measure that sensitivity |
| Horizons | rows after `law.horizon` are reported, not gated | `failure` (frame 198: a random driveline failure follows, threshold flipped by rounding — validated by 22 snapshots across it); `overrev` (frame 108: inherited Stage 6–10 quasi-static creep divergence, present with Stage 11 frozen) | documented per scenario in `gen_fixtures11.HORIZON` |
| Determinism | two identical 10 s runs; checkpoint at 5 s / restore | **bit-identical** | |
| Frozen A/B mode | Stage 6–10 frame end | Stage 11 state held | regression mode for Stages 6–10 |

## 2. Scenarios

| Scenario | Law / events | Stage 11 systems exercised |
|---|---|---|
| `launch` 45 s | full-throttle launch, upshifts, brake to stop | fuel burn, water / oil heating, tyre heating to the 505 K limit, wear, brake heating |
| `overrev` 40 s | neutral at the rev limiter (default damage) | over-rev accumulators, engine wear, overheating (141 °C water), random failure draws |
| `brakes` 50 s | repeated accelerate / hard stops | brake heating / cooling (`0054f260`), tyre cooling |
| `slide` 30 s | power slide with steering lock | sliding heat, 3-zone temperatures, wear |
| `cold` / `hot` 25 s | launch at 40 °F / 110 °F | ambient / track temperature dependence, air density → engine power |
| `impacts` 30 s | 6 body hits (front, rear, sides, quarters) + 2 tyre impacts (default damage) | **collision damage**: zone tree, zone values, engine damage, leaks, wheel / tyre impact states, debris |
| `pit` 25 s | slide, pit tyre change at 15 s | `00550f10` |
| `enter` 20 s | car placed on track at 0 s and 12 s | `00550a50` subset: repair, engine / fuel init, new tyres |
| `x4` 25 s | slide with consumption ×4 | race option consumption rate |
| `idle` 30 s | idle (default damage) | idle thermal / fuel |
| `failure` 7 s | launch (default damage) | random driveline failure (component 3, frame 207) |

## 3. Results per subsystem

| Subsystem | Original code | Evidence (Luau / original) | Status |
|---|---|---|---|
| Fuel burn → mass / inertia | `0051aac0`, `005605c0` | snapshots exact (fuel double 1 ulp); restart mutation +2 kg detected; end of runs: `launch` 61.419 / 61.423 kg, `x4` 59.495 / 59.495 kg, `impacts` (fuel leak) 59.292 / 59.292 kg | **PASS** (EXACT) |
| Engine thermal, levels, power, wear, failure | `0051aac0`, `0051a830`, `0051a9c0` | snapshots exact; `overrev` water 141.41 / 141.36 °C at 40 s; `idle`, `cold`, `hot` | **PASS** (EXACT) |
| Tyre thermal (3 zones), hot pressure, stiffness | `0054d610` | snapshots exact; restart mutation of the pressure-derived stiffness detected; `slide`, `launch`, `cold`, `hot` | **PASS** (EXACT) |
| Tyre wear, grip, blow-out | `0054e9f0`, `0054ef10` | snapshots exact; restart mutation grip −2 % detected; `launch` LR wear 0.7863 / 0.7863 | **PASS** (EXACT) |
| Brake temperature (no fade in the exe) | `0054f260` | `brakes` LF 334.4 / 334.4 K at 50 s | **PASS** (EXACT) |
| Random component failures → drivetrain | `0051c3d0` | `failure`: 22 snapshots across the failure at frame 207, bit-exact | **PASS** (EXACT) |
| Collision damage (zones, engine, leaks, wheel / tyre states) | `00549c40`, `0054a760`, `00433610` | `impacts`: 8 collision + 4 frame snapshots bit-exact (62 328 + 31 164 dwords), restarts after the impacts, 30 s closed loop | **PASS** (EXACT; host collision object PROVISIONAL) |
| Pit tyre change, car placement | `00550f10`, `00550a50` subset | pit snapshot exact; `pit`, `enter` scenarios | **PASS** (EXACT) |
| Race options (damage, consumption), seed | `00547e90`, settings `+0x50` | start footprints; `x4` | **PASS** (EXACT) |
| Coupling to the per-tick physics (Stages 6–10) | generated callbacks, `0054cab0`, drivetrain natives | 77 full-state restarts, 36 / 36 mutations detected | **PASS** |

## 4. Regression (Stages 1–10)

`tests/stage11/RESULTS_REGRESSION.txt` — every earlier suite unchanged except one line: `V.setRuntimeMode("frozen")`
(their golden data were produced by the original with the Stage 6–10 frame end; the production runtime is
`"original"`). Stage 1–5 behaviour is covered by the Stage 6/7 suite (core, driver) and the patch mocks (bench).

| Suite | Result |
|---|---|
| Stage 6/7 (`tests/stage67/run.luau`) | 16 / 16 PASS |
| Stage 8 (`tests/stage8/run.luau`) | 49 / 49 PASS |
| Stage 9 (`tests/stage9/run.luau`) | 59 / 59 PASS |
| Stage 10 setup conversion / dynamics (`tests/stage10/run_setup.luau`, `run.luau`) | 23 / 23, 61 / 61 PASS |
| Adapter under the Roblox mock (Stages 5–11, self-tests 6/7–11 quick and full) | 55 / 55 PASS |
| Patch mocks: `PATCH_STAGE6_7`, `8`, `9`, `10` (unchanged), `11` | 11 / 11, 13 / 13, 13 / 13, 17 / 17, 15 / 15 PASS |
| Syntax (`luau-compile`, all runtime modules + `PATCH_STAGE11*`) | 98 files PASS |

Why the frozen line is needed (and harmless): with the original runtime, fuel / temperatures / wear / pressures evolve
every frame and the multibody fuel mass changes, so the Stage 6–10 golden trajectories (produced without those
systems) would no longer be the reference. The frozen mode restores exactly the Stage 6–10 frame end (verified: the
suites pass unchanged), while the production runtime is validated against the original with the systems on (above).

## 5. Not validated / limits

- Body-contact **producers** (the car–wall / car–car contact physics that enter collision records with their
  magnitude) are not recovered; the damage evaluation is validated from the record onwards with the original's records.
- The track collision system's mesh deformation (`c7e75c` parts) is host geometry: zeroed parts in the port and in the
  reference (PROVISIONAL), so the corner zones 0–3 and 5 change only when an impact destroys them.
- Dynamic weather (`005a4cc0`) — ambient is constant per session (Stage 9 item).
- Stage 12 (steering chain) was not started.
