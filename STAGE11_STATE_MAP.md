# Stage 11 — state map (fuel / mass / thermal / wear / damage)

Every Stage 11 state lives in the **original memory layout** of the NR2003 Cup core (`NR2003CupCore` buffer, original
addresses). The Luau runtime executes the original x86 functions lifted to Luau (`core/NR2003Cup/NR2003CupFrameCode*`),
so storage, units, encoding and update order are the original ones. Nothing is duplicated in Roblox: `V.stage11State()`
/ the adapter telemetry *read* these cells.

Legend — status: **EXACT** (original code, lifted, compared with the original executed in Unicorn), **ADAPTER** (host
input/boundary, documented), **PROVISIONAL** (host input whose original value is not recovered). Validation refers to
`tests/stage11/run.luau` (see `STAGE11_VALIDATION.md`). Semantic names are interpretations; the numbers are the original's.

Car slot `C = 0x00c12030`, engine object `E = C + 0xc`, damage object `D = C + 0x1493`, tyre objects
`T(w) = 0x00bf3a20 + w·0xa39` (w = 0 LF, 1 RF, 2 LR, 3 RR). "Protected" = anti-tamper storage (§ protected values).

## Fuel and mass

| State | Original storage | Units | Initialisation | Update (order) | Consumers | Cup values | Status / validation |
|---|---|---|---|---|---|---|---|
| fuel quantity | `E+0x50c` (= `C+0x518`) protected **double** | kg | `00550c60`: session type 2 (race) → setup item 0x31 (garage fuel), else spec `+0x24` full cell | `0051aac0` every frame end: burn = (275 − 115·rpm/maxRpm)·heat·dt·k·rate; leak `D+0x54` | `005605c0`, `0051aac0` (out of fuel → power 0) | full 62.4698 kg | EXACT · snapshots (1 ulp: double, see validation) · trajectories |
| fuel component mass | fuel record (`*c08234` = `0x727c9a`) cells `*(+0x125/+0x141/+0x15d)` | kg | build (`005b4060`: negative record mass = variable-mass flag) | `005605c0` every frame end (after `0051aac0`) | generated solve / predictor / corrector (aggregate mass, CG and inertia of the 45-state multibody) | = fuel | EXACT · snapshots |
| fuel component inertia | same record `*(+0x179/+0x195/+0x1b1)` | kg·m² (diag) | idem | `005605c0`: fuel · spec `+0x28` | idem | 0.1 kg·m² per kg | EXACT |
| consumption rate option | race settings `c0692a+0x50` bits 0..1 | ×1..×4 | race options | read by `0051aac0` / `0054e9f0` (game mode 5 forces ×1) | burn and tyre wear | ×1 | EXACT (option is a host/session input) |
| CG / inertia of the car | **not a separate state**: the fuel record keeps its offset; the solve recomputes the aggregate every tick | — | — | — | — | — | EXACT by construction |

## Engine thermal / damage

| State | Storage | Units | Init (`0051a020` via `00550c40`) | Update | Consumers | Cup | Status |
|---|---|---|---|---|---|---|---|
| water temperature | `E+0x4a4` protected float | °C | 93.0 | `0051aac0`: + dt/((coolant+3)·12000)·heat_rear − x4d0·0.18375·(T−ambient)·k43c·…·air | `0051aac0` wear / failure (> 105 °C term) | k43c 450 | EXACT |
| oil temperature | `E+0x4d4` protected float | °C | 0.0 | `0051aac0`: + dt/((oil+3)·28000)·heat_front − (T−ambient)·rpm/max·k440·…·air | wear / failure (> 115 °C term) | k440 1390 | EXACT |
| coolant level | `E+0x4a0` | (spec units) | spec engine `+0x34` | − leak² · dt · 0.2 (`D+0x4c`) | thermal capacity | 19 | EXACT |
| oil level | `E+0x49c` | (spec units) | spec engine `+0x38` | − leak² · dt · 0.8 (`D+0x50`) | thermal capacity | 12 | EXACT |
| radiator inputs | `E+0x470..+0x480` | 1.1, ρ, air °C, airspeed, radiator air (1 − tape)·front draft factor | — | `0051a830` every frame end (before `0051aac0`) | water cooling | — | EXACT (+ Stage 9 session inputs) |
| power factor (ignition / misfire / air) | `E+0x554` | 0..1 | running → 1.0 | `0051aac0`: misfire from `D+0x58` / `D+0x60` (random), out-of-fuel 0, × ρ/1.2 | engine torque (`0051a870` lifted Stage 6/7) | 0.901 at 70 °F | EXACT |
| thermal margin "x4d0" | `E+0x4d0` | 0..5.44 | 2.7211 | relaxes to an rpm-band target (0.15/frame) or decays | water cooling, power above 0.8·max rpm | — | EXACT (semantics PROVISIONAL) |
| over-rev accumulator | `E+0x508` | s | 0 | + dt above 0.995·max+100 rpm, else − dt, clamp 0..50 | failure rate | — | EXACT |
| wear clock / life | `E+0x558` / `E+0x55c` | s / s | 0 / 290000 | every 0.2 s: rate from rpm, temperatures, over-rev, fuel leak; random failure | `0054b5a0` engine damage | — | EXACT |
| blown torque factor | `E+0x560` | — | 0 | random on catastrophic failure | engine | — | EXACT |
| starter / ignition state | `E+0x548` flags, `E+0x54c`, `E+0x550` cut timer | bits / frames / s | flags 0x22 (simulation task path) | `0051a9c0`, `0051aac0` | Stages 6/7 (cut timer) | — | EXACT |

## Tyres (per wheel, `T(w)`)

| State | Storage | Units | Init / reset | Update | Consumers | Cup | Status |
|---|---|---|---|---|---|---|---|
| surface temperature, 3 zones (inner/middle/outer) | protected floats `+0x160 / +0x18c / +0x1b8` | K | new tyre `00550f10`: air temperature (`e0b834`, incl. +28 °C sun) + 11 °C | `0054d610` (frame end, per tyre): heat from lateral work split by camber/side, conduction to carcass (h = 35), forced convection √(airspeed+2)·18·k, cap 505 K | wear (`0054e9f0`), stiffness `+0x29c`, grip `+0xd0` | c = 650 | EXACT |
| carcass temperature, 3 zones | protected `+0x1e4 / +0x210 / +0x23c` | K | idem | `0054d610`: + conduction + longitudinal work; zone-to-zone conduction (h·0.02) | hot pressure | c = 4500 | EXACT |
| cold pressure | `+0x000` | psi | setup items 0..3 (Stage 10) / `00550f10` | 0 when the tyre is flat (state ≥ 2) | hot pressure | 36 | EXACT |
| hot pressure | `+0x2a0` | psi | — | `0054d610`: ((T̄carcass − Tamb)·0.4 + Tamb)/Tamb · P0 | tyre model `0054cab0` (stiffness, contact) | 37.9 hot | EXACT |
| derived contact fields | `+0x298, +0x29c, +0x2a4, +0x2a8, +0x2c4, +0xd0` | — | — | `0054d610` | `0054cab0`, generated tyre callbacks | — | EXACT |
| wear | protected `+0x074` | 0..1 | 0 (new tyre) | `0054e9f0` every 0.2 s (`+0x134` clock): rate·(1 + over-temperature³ term)·work·dt; blow-out chance above 0.66 | grip `+0xcc` = 1 − 0.2·wear (`0054ef10`); ≥ 1 → flat | k40 6.67e-6, k44 1.8e-4, Topt 388 K | EXACT |
| grip vs wear | `+0xcc` | factor | 1 | `0054e9f0` | `0054cab0` | 0.6 when flat | EXACT |
| tyre damage state | `D+2` bits `2w..2w+1` | 0..3 (≥ 2 flat) | 0 | `0054aa20` (wheel impacts), `0054e9f0` (blow-out), `0054a330` | `0054e9f0` (P0 = 0, wear 1, grip 0.6), collision geometry `0054b0d0` (host) | — | EXACT |
| wheel / suspension damage | `D+0` bits `6+2w..` | 0..3 | 0 | `0054aa20`, `0054a330` | debris only — **the shipped exe has no damage-dependent suspension geometry** (`0055e610/670/6c0/780` = `ret`, `0055e5d0` one rnd draw) | — | EXACT |
| brake temperature | protected `+0x26c` | K | 295 (build) | `0054f260` (inside `0054d610`): + (|τ·ω|/9200 − (T − Tamb)(√airspeed + 1)·0.0036)·dt | **none** (fade `0054f3d0` / failure `0054f610` unreferenced) | 9200 / 0.0036 | EXACT |
| ambient | `0074c954` | K | — | `0054d610`: `e0b830` (Stage 9 air °C) + 273.15 | tyres, brakes | 294.26 at 70 °F | EXACT |
| airspeed copy | `bf3a00` | m/s | — | `00554520` / `00551990` ← `C+0x5aa` (Stage 9) | convection | — | EXACT |

## Random failures and damage

| State | Storage | Units | Init / reset | Update | Consumers | Status |
|---|---|---|---|---|---|---|
| stress accumulator | `bcf760` [0..3] | — | static init `0051c230`; build `0055f880` ([2] = −1, [3] = 1) | per tick in the force natives (`0051c1e0`, `0056010a`: component [3] = 3); per frame `0051c300` tests and clears | random component failure | EXACT |
| component failure flags | `D+0xe` bits 0..7 | bits | 0 | `00548aa0`/`0054b940` (random `0051c300` p = stress³·k·damage scale, `0051c380` component 7) | `0055e7e0` / `0055e840` → `c086e0[0..8]` + `c08704` → drivetrain natives `0055fc50` / `005614b0`, transmission `005536b0` / `00553920` / `005538f0` / `005538a0` | EXACT |
| packed zone / component values | `D+8` (layout `006f56b8`: 10 × 3 bits + 2 bits) | levels | 0 | `0054b6c0` | decoded floats | EXACT |
| zone damage | `D+0x10 .. +0x38` (11 floats) | 0..1, 2.0 destroyed | 0 | `00549860` (collision), `0054b410` (decode) | aero `00410910` (Stage 9), radiator (zone 1) | EXACT |
| tyre damage values | `D+0x3c..+0x48` | — | 0 | `0054b410` | — | EXACT |
| radiator / oil / fuel leak | `D+0x4c / +0x50 / +0x54` | 0..1 | 0 | `00549290` (collision), `0054a2a0` (fire chance) | coolant / oil level, fuel | EXACT |
| engine damage | `D+0x58` (+ `D+0xc` bits 0..5) | 0..1 | 0 | `0054b5a0` (collision, engine failure) | misfire / power | EXACT |
| `D+0x5c`, `D+0x60` | floats | — | 0 | `0054b410` | `0051aac0` (`+0x60` misfire) | EXACT (semantics PROVISIONAL) |
| flags | `D+0xc` bits 24, 25, 28, 29..30 | bits | 0 | `0054b7d0`, `0054b4c0` (changed), `0054b610` (engine off), `0054ba50` | sync / engine / debris | EXACT |
| damage scale | `bef700` | {0, 0.15, 0.6, 1.0} | static 1.0; session start `00547e90(settings+0x4c bits 22..23)` | — | every damage path | EXACT (option = session input) |
| collision records | pool `bf09c0` → list `bf39f0`, hash `bf0940[32]`, 0x60 bytes | — | per frame (cleared by `00549c40`) | `0054a760` (entered by the contact code), `0054a8d0`, `0054aa20` | `00549c40` → `00549290` | EXACT (entry = host geometry: ADAPTER) |
| debris queue | `bef3b8` (16 × 0x34), `bf39e8` | — | per frame | `0054aa20` → `0054a330` | wheel / tyre states, particles | EXACT |
| collision-damage zone tree | table `00890490[6]` (one tree shared by the 6 chassis types), nodes 0x18 bytes from the static pool `*bf39d4` (`bef728..`) | decision tree on the car-frame point (constant split planes: x 0.8 / −1.5, z 0.5, y 0.2 / −0.2 …) → zone 0..10 | built once per car load: `00433610(C+0x58e)` → `00433660` (game: car-model load `00432d90`) | — | `0054a710` → `00547e20` (zone of every collision record) | EXACT (the bench never loaded the model: built at the Stage 11 session start) |
| zone table | `006f5500` + 0x20·zone: wheel, zone value index, collision part, start, range, destroy limit, engine factor, suspension factor | — | static | — | `00549290`, `00549860`, `0054aa20` | front 4 → value 6; rear 9 → 7; sides 7/8 → 9/8; corners 0..3 → 2..5 (collision parts 0..3); zone 5 → part 4 | EXACT |
| race order membership | ring links `C+4` / `C+8` (Stage 9) | pointers | 0 in the bench build | — | `00549c40` body damage and `0054a330` wheel / tyre states run only when `C+4` ≠ 0 | ADAPTER: one-car ring set around `00549c40` only |
| car collision object (track system) | `c7e75c` → container: `+0x18..+0x24` wheel parts (`+0x40` off flag), `+0x28..+0x38` deformable body parts (`+0x3c` state, `+0x14..+0x2c` vectors, `+0x20` / `+0x38` factors) | — | built by the track collision code (not recovered); null in the bench | `0054b0d0` (zone values → parts), `00549860` (destroyed part), `00577cb0` (shape update) | zone values of the corners 0..3 and zone 5 = part state | ADAPTER / PROVISIONAL: host block `0xf7a500` with 9 zeroed parts (no mesh deformation simulated) |
| tyre-contact stamp | `C+0x1323` (+ 26-dword table row) | `getIntCount` ticks | — | `00567660` from `0054a8d0` (tyre / continuous contact records) | — | EXACT (clock = ADAPTER: +1 per frame) |
| roster series field | `C+0x596` | int | 0 in the bench build (Stage 6/7 harness) | session (`00562e80` ← roster `00574370 +0x94`) | `00549290` / `00549860` (collision damage only when ≠ 0), particles | **PROVISIONAL** host input (1 in the Stage 11 session) |
| random stream 0 | `f6eae4` (stream 1 `f6eae8` = weather) | LCG state | post-build 0 | `005f5670` (×0x19660d + 0x3c6ef35f) | every random draw (misfire, failures, damage, particles) | EXACT (seed = session input) |
| task frame counter | `7559bc` | frames | 0 | ++ before each frame (task loop `005f78f0`) | `00549c40` (delay `C+0x1487`) | ADAPTER (host loop, same order) |
| timer-interrupt counter | `7559c4` (`getIntCount` `005f7cd0`) | ticks | 0 | ++ before each frame (same convention as the Stage 8 harness) | `00567660` stamp; Stage 8 speed cache tag (unused in Luau) | ADAPTER |

## World record (car+0x5ae) — host boundary

| Field | Original writer | Bench |
|---|---|---|
| position `+0`, velocity `+0xc`, rotation `+0x58`, quaternion `+0x7c`, angular `+0x8c`, track-frame velocity `+0x44/+0x48` | `005543f0` per tick (needs the track: `005f58d0` → `0051370a`) | ADAPTER: `V._frameEnd` sync from the exported state before the frame end (lifted `005f5a60` / `005f5ac0`); track fields cleared |
| surface normal `+0x24` | track query | Stage 9 `setTrackNormal` (flat (0,0,1) by default) |

## Protected values

Triple `{p0, p1, p2}` + lock word: value = `*p0 ^ *p2`, check `*p1 ^ [f72118] == *p0` (double: `[f72120]`). Storage pool
`0xf6f000..` (static; relocation / re-keying driven by rdtsc never happens in the bench: rdtsc = 1). The Luau port
stores exactly the same words (snapshot tests compare them; 1-ulp value differences show as differing data words).

## Initialisation / reset / persistence

| Event | Original | Luau |
|---|---|---|
| fresh car (build) | post-build state | `V.reset()` = post-build image (Stage 6/7 image + Stage 11 supplement + Stage 10 build footprint) |
| session / car placed on track / restart | `00550a50`: repair `00563080(car,1)`, engine `00550c40`, fuel `00550c60`, four new tyres `005512d0` | `V.startSession(weather, opts)` and `V.reset()` in an active session → `V.enterTrack()` (lifted subset) |
| pit tyre change | `00550f10(w)` | `V.pitTyres({w...})` |
| garage setup | rebuild (Stage 10): Stage 11 state back to the build values | `V.applySetup` (unchanged) |
| checkpoint / restore | — | `V.checkpoint()` copies the whole memory: fuel, temperatures, wear, damage, RNG, counters included (bit-identical replay tested) |
