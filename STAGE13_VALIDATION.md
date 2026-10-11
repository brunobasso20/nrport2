# Stage 13 — validation (force feedback)

Reference = the ORIGINAL NR2003.exe code executed in Unicorn 2.1.4 (`recovery/stage13/orig_stage13.py`): the Stage 6–12
harness (per-tick physics with the original `005539c0`, which always called `00554d30`; the original frame end
`00554520` / `00549c40` of Stage 11; the original steering chain of Stage 12) with the force feedback switched on — the
original FFB block in place inside `00554520`, the original `00550070` / `0054fed0` / `00550680` and option setters —
and the DirectInput layer as host stubs (`005d0820` / `005d0840` / `005d0870`, `005f79a0` → its direct path `005f79de`,
`005d08d0` = `ret` + a hook logging every call). Image: the OpenNR2003 Ghidra project exported with
`ExportMemoryPy.py` (`STAGE13_RECOVERY.md`). Fixtures: `recovery/stage13/gen_units13.py` (L1) and `gen_fixtures13.py`
(L2, L4) → `tests/stage13/fixtures/` (Lua) and `recovery/stage13/fixtures_json/` (JSON). Suite:
`tests/stage13/run.luau` (`tools/run_stage13_tests.sh` / `.ps1` runs everything). Results: `tests/stage13/RESULTS_STAGE13.txt`,
regression `tests/stage13/REGRESSION_STAGE13.txt`.

**Result: 40 / 40 PASS** (suite) — every comparison is against the original's own numbers; no tolerance was widened.

| Level | Check | Result |
|---|---|---|
| L1 arithmetic | exact x87 add / mul / div (64-bit significand, round toward −inf) on 1518 / 1518 / 1514 operand pairs (random, tiny operands with exponent gaps 20–120, near cancellations, long carries, signed zeros, zero × non-double); FST dword (RD24) on 1518 values. Reference: exact rationals; the reference itself equals real x87 instructions executed in Unicorn on every pair | **bit-exact** (incl. the sign of zero) |
| L1 functions | `00554d30`: 2600 vectors (n ≤ 0, sum ≤ 0, unloaded wheels, tiny / huge, cancellations, signed zeros, the 1500 clamp, exactly 1500) | **bit-exact** (4 outputs + clears) |
| | FFB block `0055464c..0055479d` run in place: 3000 vectors (both gates, \|ec4\| ≤ 1e−5 and the boundary itself, rest with signed zeros, saturation ±1, latency 0..250, damping 0..100, strength 0..100, ratios 6.5..34, raw option values) | **bit-exact** (ec0, ecc, the `005d08d0` call and its force bits) |
| | `00550070` → `0054fed0` / `00550030`: 1728 cases (flag 0 / 1 / 2 × binding type 0 / 1 / 3 × axis 0 / 3 / 15 / 16 / 0x80000002 × direction byte × acquired × same axis × FF on × device capable × acquisition result × effect state); `00550680`: 8 cases | **bit-exact** state (`bf6eb8`, `bf6ebb`, `bf6ebc`, `74c95c`, effect) and identical device-call sequence |
| | option setters (messages 8..11 with the controls.cfg conversion `fild` / `fstp dword`): 464 vectors; device conversion `_ftol(force × 10000)`: 507 forces | **bit-exact** |
| L2 traced calls | the original's own calls in its closed-loop runs (7 scenarios): **21 168** `00554d30` calls (every tick in `slalom` / `suspend`, every 4th tick elsewhere) and **5 400** frame-end FFB blocks, inputs → outputs | **bit-exact** (26 568 / 26 568) |
| L3 restarts | the **32** Stage 12 full-state restarts of the six shared laws (the Stage 12 fixtures always held the original's `00554d30` cells; Stage 12 excluded them as host-only): one Luau frame from the original's state, the 16 FFB cells | 303 cells bit-exact, 209 within 4× the original's 12 one-frame twins, **0 outside** |
| L4 closed loop | 7 scenarios, 5400 frames, FFB on: per frame force / ec4 / ed0 / ecc / 74c960 / bf6ec8 (4× the envelope of the original's **14 twins** over ±9 frames), gate / count / axis fields exact; the 35 Stage 12 observation rows every 9 frames; the device-call sequence (acquire / release / force order and axes) | **0 outside**; device calls identical in every scenario (e.g. `suspend`: 510); `notdriven` rows after the Stage 12 horizon 297 reported (0 outside) |
| L5 errors | 6 mapping errors through the test-only mutation hook (q × 1.001; damping sign; the `00554fb0` ratio instead of the raw item; output × 1.01; slip × (1 + 1e−4); 1500 clamp removed) + `00554d30` called after the tick's tyre passes | each detected: the 6 mappings in all 7 scenarios by L2, the timing in all 6 restart sets by L3 |
| L5 arithmetic model | the same L2 calls with the Stage 6–12 double model (x87 intermediates in IEEE double, f32 stores toward −inf) | **197 / 26 568** calls change a stored bit (0 in `keys`, up to 57 / 1728 = 3.3 % in `ratio12`) — the exact x87 arithmetic is required |
| No feedback | two ORIGINAL machines in lockstep (`brakesteer`, FFB on vs off, 400 frames / 3200 ticks): whole window compared every frame | only the FFB cells differ (`recovery/stage13/evidence/nofeedback.txt`) |
| Behaviour | options survive `reset()` and a garage rebuild; keys never acquire the effect, an analog axis does (block at the frame end); controls suspended = zero force + not-driven branch + block gated, resume runs it again; `endSession` releases; determinism and checkpoint / restore bit-identical | PASS |

## 1. Why these comparisons

| Check | Granularity | Criterion | Justification |
|---|---|---|---|
| L1 / L2 | one original call per vector, inputs written to the original cells | **bit-exact** on every stored f32 / byte / dword and every device call | same code, same inputs; the port evaluates the x87 exactly (64-bit significand, RC = down), so no rounding difference is admissible |
| L3 | one frame from the original's complete state (Stage 12 restart windows), 16 FFB cells | equal or within **4× the original's one-frame sensitivity** (12 twins), never tighter than 2e−5 relative / 1e−6 absolute; the counts `74c964` / `74c968` exact | the FFB inputs come from the per-tick physics of Stages 6–11, which differs from the x87 by a few ulps per frame (`STAGE12_VALIDATION.md`); this level checks the integration (00554d30 at its slot, n = 2, frame-end values) |
| L4 | per frame; rows every 9 frames | within **4× the envelope of 14 twins** over ±9 frames (±0.25 s), floors 2e−5 / 1e−6; integer fields exact unless a twin differs | Stage 12 method (10 Stage 11 twins + 4 'all' twins); the device-call sequence must be identical |
| L5 | mutations / double model | must be detected | proves the tolerances are far tighter than any real mapping error, and that the exact arithmetic is not optional |

## 2. Scenarios (`recovery/stage13/scenarios13.py`)

| Scenario | Law (Stage 12) | FF options | What it exercises |
|---|---|---|---|
| `slalom` 30 s | analog sine 0.08 at 0.5 Hz, full throttle | on, image 80 / 0 / 0 | acquisition at the first analog frame, saturation-free torque, every tick traced |
| `brakesteer` 28 s | braking / power while steering through 17.88 / 8.94 m/s | 100 / 30 / 50 | damping and latency terms |
| `ratio12` 16 s | analog sine, setup ratio 12 | 50 / 100 / 250 | ratio scaling of the output, extreme damping / latency |
| `linear` 22 s | steps at rest + constant radius (linearity 80, momentum 0) | 80 / 10 / 120 | \|ec4\| ≤ 1e−5 at rest |
| `keys` 24 s | digital steering | on | never acquired: 0 device calls, block never runs |
| `notdriven` 12 s | driver off 5–7 s (Stage 12 horizon 297) | 80 / 20 / 0 | FFB through the not-driven branch of the `driver = false` path |
| `suspend` 18 s (new) | analog sine; `00550070(1)` at 6 s, `(0)` at 8 s; keys 11–13 s | 90 / 50 / 80 | bf6eb8 gate (not-driven branch + FFB off + zero force), release on the binding change, re-acquisition |

## 3. Roblox integration (adapter mock + patch mock)

* `tests/stage67/adapter_mock.luau` (the real `CupChassisAdapter` under a Roblox API mock): **77 / 77** — the earlier 66
  checks unchanged + 11 for Stage 13: bench defaults, keys → not acquired, analog axis → acquired with `FFBForce` =
  the core's force and `FFBMagnitude` = trunc(force × 10000), no driver → suspended + zero force, driver back → active,
  option attributes → original setters, `ForceFeedback = false`, defaults again, no fault, `Stage13SelfTest` quick / full.
* `tests/stage13/patch13_mock.luau` (published patches 6/7 .. 12.1 then `PATCH_STAGE13` on a mock Studio DataModel):
  **22 / 22** — refusals, in-place install of 6 modules + 2 new modules, backup + ADDED markers, `Stage13SelfTest.run(true)`
  and `Stage12SelfTest.run(true)` on the Stage 13 bench, idempotent re-run, `PATCH_STAGE12_1_ROLLBACK` refusing a 13
  bench, verified rollback to 12.1 (new modules removed), automatic revert on a failing self-test, split install, no
  SavePlace.

## 4. What is not proven equivalent

* The DirectInput layer (device, effect, gain, driver sign convention) is host: the port delivers the value the
  original hands to `005d08d0` and the `_ftol(force × 10000)` magnitude of `005d3010`.
* L3 / L4 are envelope comparisons because the inherited per-tick physics (Stages 6–11) is not bit-exact to the x87;
  the FFB arithmetic itself is bit-exact (L1 / L2).
* Binding types 2 / 4 (device keys / buttons) were not run through `0057aff0` (front-end name formatting not set up);
  `0054fed0` only tests `type == 1`.
