# Stage 12 — validation (steering chain)

Reference = the ORIGINAL NR2003.exe code executed in Unicorn 2.1.4 (`recovery/stage12/orig_stage12.py`: the Stage 6–11
harness — per-tick physics, the original frame end `00554520` / `00549c40` of Stage 11 — plus the original `00552720`
(called through a stub in place of the `005524f0` call site @`005525c8`; the rest of the `005524f0` player / not-driven
branch is harness host code with the original `00553080`) and the `00551e80` tail `00552082..00552336` executed from
the exe, stopped at `0x552244` / the tail end;
the host writes the same control-table cells as the port). Fixtures: `recovery/stage12/gen_units12.py` (L1) and
`gen_fixtures12.py` (L2–L4) → `tests/stage12/fixtures/` (Lua) and `recovery/stage12/fixtures_json/` (JSON).
Suite: `tests/stage12/run.luau` (`tools/run_stage12_tests.sh` / `.ps1` runs everything). Results:
`tests/stage12/RESULTS_STAGE12.txt`.

**Result: 47 / 47 PASS.** Every comparison is against the original's own numbers; no tolerance was widened to pass a
test. What did not pass at first, and why, is in § 4 (two L4 scenarios) — nothing is hidden.

| Level | Check | Result |
|---|---|---|
| L1 functions | `00552d00` steering axes: 1200 vectors (raw × slew state × rate × binding) | stored state and f32 of the x87 value **bit-exact**; x87 value ≤ 4 double ulp (worst 0.99 ulp) |
| | `00552720` processed input: 3872 vectors (11 inputs −1..1 × speed × yaw rate × linearity × arcade bit) | **bit-exact** (3872 / 3872) |
| | keyboard sequence: 120 frames of `00552720` (key held, released, other key; slew 0.033, release × 2.5, sine) | **bit-exact** |
| | `00554fb0` ratio: 192 vectors (speed at / ±1 ulp around 8.94 and 17.88 m/s × setup ratio 6.5..32 × override) | f32 **bit-exact**, x87 value ≤ 2 double ulp (worst 0.00) |
| | `00551e80` tail (`−bf63c8`, `_CIpow` linearity, × π, ÷ ratio, `bf63b8 / bf6e80 / bf6e88`): 2100 vectors | **bit-exact** |
| | option setters `005502f0 / 005500c0 / 00550110 / 00550210` + controls.cfg conversion of `0043f1d0`: 215 vectors | **bit-exact** |
| | image defaults (no front-end message) | linearity 0, rate 0.0329999998, release 2.5, override on, assistance 0 |
| L2 frame-start snapshots | 1481 snapshots in 10 scenarios: the original's traced frame start (`005524f0` + `00551e80`, every dword it reads or writes + the host cells) loaded into Luau, `V._frameStartOnly`, every written dword compared | **174 384 / 174 384 dwords bit-exact (100 %)**, 0 extra Luau writes |
| L3 full-state restarts | 47 restarts (every 4 s from 2.5 s): the original's complete memory window, contact blocks and clock loaded into Luau; one complete frame (frame start + 8 ticks + frame end) compared cell by cell and on the 80-field row (35 observation fields + the 45 states) | 0 cells and 0 row fields outside 4× the original's one-frame sensitivity (12 twins) |
| L4 closed loop | 10 scenarios, 194 s: 771 gated rows × 35 fields (chassis, steering cells, hub states, draw steer, speed cache, wheel yaw / tilt, tyre Fy / Fz, engine, gear) | all within 4× the envelope of the original's **14 twins**; horizon `notdriven` 297 (§ 4) |
| L5 mutations | 5 deliberate steering-mapping errors (input × 1.001, linearity exponent +5 %, ratio +0.1, low-speed override ignored, target +1e−4 relative) | every one detected by L2 (scenarios per mutation 10 / 10 / 10 / 8 / 10) and by L3 (8 / 8 / 8 / 6 / 7) |
| Behaviour | options survive `reset()` and a garage rebuild; default ratio 18:1; assistance > 0 refused; arcade refused in production / settable for validation; provisional mode = Stage 6–11 contract; full analog lock at rest = π/7 with hubs = target ∓ toe/2 and cockpit wheel −2.79 rad; determinism and checkpoint / restore bit-identical | PASS |

## 1. What is compared, and why these tolerances

| Check | Granularity | Criterion | Justification |
|---|---|---|---|
| L1 | one original function per vector, inputs written to the original cells, outputs read from the original cells / the x87 result (stub stores `FSTP tbyte`) | **bit-exact** on every stored f32 / byte / dword; x87 values passed on: `00552d00(7 / 8)` ≤ 4 double ulp, `00554fb0` ≤ 2 double ulp; the target through its f32 stores `bf63b8 / bf6e80 / bf6e88` (bit-exact) | same code, same inputs; the port evaluates x87 extended intermediates in double (Stage 6/7 convention) |
| L2 | the frame start of one frame from the original's own state (per-frame traced footprint: Unicorn memory hooks on every read / write + the harness host cells) | **bit-exact**, and Luau must not write any other dword | isolates the steering logic from the inherited per-tick numerics (the frame start is the steering chain) |
| L3 | the original's complete memory window at the start of frame R loaded into Luau; one frame | each cell within **4× the original's own one-frame sensitivity** (frame R re-run by the original with ±1 ulp on one chassis cell — 6 twins — and with ±1 ulp on the whole 45-state vector before every tick — 6 twins), never tighter than 2e−5 relative / 1e−6 absolute; integer cells exact; protected values decoded | Stage 11 method; the per-tick physics (Stages 6–11, unchanged) differs from the x87 by 1–4 ulps per frame on several solver cells, and the original itself moves those cells by up to ~1e−3 relative under 1 ulp (near-zero solver cells show large relative values inside their envelope, e.g. `0xebd7d4`) |
| L4 | 35 fields every 0.25 s | within **4× the envelope of 14 twins** of the original over the row and its neighbours (±0.25 s), never tighter than 2e−5 relative / 1e−6 absolute; integer fields exact unless a twin differs; rows after `law.horizon` reported, not gated | twins = 10 Stage 11 twins (chassis height ±1 ulp at the start; 8 with ±1 ulp on the chassis height every frame) + **4 'all' twins** (±1 ulp on the whole 45-state vector at every frame start through the original export `005b2cb0` / import `005b4560` — the Stage 11 restart-twin class `('all', seed)`, i.e. the per-tick perturbation class of the port's inherited rounding) |
| L5 | the same comparisons with a deliberate mapping error injected through the test-only hook `V._steerMutate` | every error must be detected by L2 and by L3 | proves the tolerances are far tighter than any real mapping error; a mutation goes undetected where it has no effect (override ignored with the override off — `parking` — or at speeds above 17.88 m/s; any mutation while the car is not driven), where its effect is below the 1e−6 absolute floor (target +1e−4 on the small `linear` target at L3 frame 378) or where no L3 mutation run exists (`keys`: no restart frame with steering input) |

## 2. Scenarios (`recovery/stage12/scenarios12.py`)

| Scenario | Law | Steering paths exercised |
|---|---|---|
| `keys` 24 s | throttle 0.8, key taps / reversal / repeated taps / both keys / holds / lift-off | digital controls, slew 0.033 + release × 2.5, sine shaping, ratio blend at speed |
| `slalom` 30 s | full throttle, analog sine 0.08 at 0.5 Hz | analog axis, 8.94 / 17.88 m/s transitions, 59 m/s |
| `linear` 22 s | linearity 80, momentum 0: input steps ±0.01..±1 at rest, constant-radius hold, lift-off | linearity exponent, no slew (rate 1, no sine), speed sensitivity |
| `brakesteer` 28 s | throttle 0.8 launch; lift + steer 0.05 at 27 m/s; braking 0.6 while steering through 17.88 / 8.94 m/s; power while steering (−0.12) back through both thresholds; coast | ratio ramp in both directions under braking / power |
| `ratio12` / `ratio32` 16 s | analog sine 0.1 at 0.4 Hz with setup ratio 12 / 32 (Stage 10 garage pipeline) | item 0x30 at run time |
| `parking` 16 s | low-speed override off: key steering at walking speed, braking to rest with lock | 18:1 at all speeds |
| `yawlimit` 18 s | linearity 50 + race bit 25 (validation only) | arcade yaw-rate limiter, 0.66 L + 0.34 remap |
| `notdriven` 12 s | analog 0.3 from 3 to 8 s, driver off 5–7 s | `005524f0` not-driven branch, return to centre, quasi-static rest |
| `stationary` 12 s | momentum 40: slow analog full-lock sweep at rest, then key holds | rate `005500c0(40)`, full lock 7:1, cockpit clamp |

## 3. Results per element

| Element | Original code | Evidence | Status |
|---|---|---|---|
| Device layer / bindings | `0057abc0` (host) | L2 host-write cells identical; adapter mock (keys, analog, legacy) | ADAPTER (validated boundary) |
| Slew + sine | `00552d00` | L1 1200 vectors; L2 | EXACT |
| Processed input | `00552720`, `00552410`, `00550230`, `0055a770`, `00554f50` | L1 3872 + 120-frame sequence; L2; L4 | EXACT (assistance > 0 NOT PORTED) |
| Linearity, × π, target, ramps | `00551e80` tail, `005524b0` | L1 2100; L2 bit-exact incl. the sign of zero (C1); L5 | EXACT |
| Steering ratio + low-speed override | `00554fb0`, item 0x30 | L1 192 (thresholds ±1 ulp); `ratio12` / `ratio32` / `parking`; L5 mutations 3 and 4 | EXACT |
| Per-tick ramp, toe, hub coordinates | `005539c0`, `005b2b90` | L3 47 restarts; L4 hub / wheel yaw fields | EXACT |
| Options | `005502f0`, `005500c0`, `00550110`, `00550210`, `0043f1d0` conversion | L1 215; survive reset / garage | EXACT |
| Cockpit wheel | `005662d0` / `00565cc0` formula, `car[0x1554]` from `00551990` | behaviour check (−2.79 rad clamp), adapter mock (Cockpit + render snapshot) | EXACT formula (presentation) |
| Road-wheel geometry | multibody (Stage 6) | adapter mock: measured wheel yaw 0.9888 q at q = 0.449 (research: 0.9875–0.9895); LF−RF anti-Ackermann trend | EXACT (original multibody) |

## 4. Closed loop: what failed first, and what was done (no tolerance widened)

With the Stage 11 L4 method unchanged (10 twins), 8 of 10 scenarios passed; two did not:

- **`brakesteer` (first version)** — the law launched at **full throttle** for 13 s *before any steering input*. The
  original car itself spins in that launch (twin spread of x: 2.6 m at 8.5 s, 210 m at 17 s; the original spins at
  ~8 s with zero steering input, some of its twins do not, the port does not): the run compared two different
  trajectories, not the steering chain. The scenario was redesigned (launch at throttle 0.8 as `keys`; braking 0.6 while
  steering through 17.88 / 8.94 m/s; power while steering back through both) and regenerated from the original. Result:
  0 rows outside; after 28 s port vs original x differ by 3.7 m (301.0 / 297.3 m) while the original's own 14 twins end
  between 295.1 and 300.8 m (up to 3.5 m from the original).
- **`notdriven`** — after the driver gets off (5–7 s) the car rolls to rest; at rest the front tyre pair sits on one
  of two quasi-static stick-slip branches (±4600 N; the original's **own twins split** between both). After the
  steering is released at ~2.4 m/s (frame 288, the car accelerating again at throttle 0.7) the pair selects one of two rolling branches (LF/RF ≈ +920 / −975 N in
  the port vs ≈ −190 / +400 N in the original), at zero steering target (identical in port and original).
  Evidence that this is the original's own branch choice, not a logic difference (`recovery/stage12/dev/reverse.py`,
  summary `recovery/stage12/evidence/reverse_restart_notdriven.txt`): **the ORIGINAL code continued from the PORT's
  own complete state** at frame 288 (mirror of the L3 restart; transfer check at frame 378: one frame later
  |Δvx| 4.8e−7 m/s against an original twin spread of 2.9e−6) **takes the port's branch for the remaining 4 s**
  (|Δvx| ≤ 1.4e−3 m/s with the peak at frame 306 during the branch selection, then ≤ 4.1e−4 m/s; Fy within ~1 N
  after frame 315, up to ~110 N during frames 298–306), three of its four ±1-ulp twins too, and the fourth takes the other branch (the
  original's own run). The same front-tyre branch split appears **without any steering** (`dev/nosteer.py`: the same
  launch with steerAxis 0; all port rows within the twins' envelope, branch flips of ~1000 N in both). Actions:
  (1) the four 'all' twins (the Stage 11 restart-twin perturbation class) were added to the L4 envelope of **every**
  scenario — with them the first exceedance moves from frame 171 to 351; (2) the documented horizon `notdriven` 297
  (`gen_fixtures12.HORIZON`, the last row before the branch selection; Stage 11 precedent `overrev` / `failure` /
  `hot`). After the horizon: 15 rows reported, 13 field-rows outside (all front Fy / derived), not gated; the frames
  after the horizon remain covered by L2 (23 of the scenario's 131 snapshots) and L3 (the restart at frame 378).

## 5. Determinism, regression, integration

- Determinism: 200 steering frames twice bit-identical; checkpoint at 100 frames / restore replays bit-identically.
- Regression (steering mode `"provisional"` = the Stage 6–11 steering contract; Stage 6/7–10 suites in the Stage 11
  `"frozen"` runtime as in Stage 11, the Stage 11 suite in the original runtime): Stage 6/7
  16/16, Stage 8 49/49, Stage 9 59/59, Stage 10 23/23 + 61/61, Stage 11 66/66 — identical to the Stage 11 baseline.
- Adapter under the Roblox mock: 65/65 (10 new Stage 12 checks: defaults, analog full lock + cockpit + render snapshot,
  hubs and measured wheel yaw, keys, legacy input, options / garage ratio from attributes, defaults again, no fault,
  `Stage12SelfTest` quick and full).
- Patch mocks: `PATCH_STAGE6_7` .. `PATCH_STAGE11` unchanged; `PATCH_STAGE12` 19/19 (§ 6).
- Studio self-test `Stage12SelfTest`: quick (what the patch runs) and full pass under the mock.

## 6. Installer validation (`tests/stage12/patch12_mock.luau`, mock Studio DataModel)

Refuses a non-Stage-11 bench and a locally modified module (size + FNV-1a hash of every published Stage 11 source);
installs in place (same Instance identity, no folder replaced); one-line anchored edits of the Stage 6/7–11 self-tests;
backup of only the changed instances (+ markers for the added ones) in `ServerStorage.NR2003Backup_Stage12`, created
once; re-run without duplicates; verified rollback (sources restored and hashed, added modules removed, Stage 11
self-test); automatic revert when a self-test fails; split install (parts + INSTALL) = single file; `SavePlace` never
called by the patch, the parts, INSTALL or ROLLBACK.

## 7. Not executed / open

- **Manual Roblox Studio validation** (15 items in `VALIDACAO.md`) — not executed here (no Studio in this environment).
- Steering assistance > 0 and the arcade mode in production: refused, not validated beyond the bit-25 branch.
- Real-wheel device curves (DirectInput calibration) — host side, not applicable.
