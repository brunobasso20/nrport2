# Stage 12 — steering state map

Every Stage 12 state lives in the **original memory layout** of the NR2003 Cup core (`NR2003CupCore` buffer, original
addresses). The steering chain is a hand port of the x86 (`core/NR2003Cup/NR2003CupSteering.lua` + the Stage 12 lines of
`NR2003CupDriver.frameStart` / `tickInputs`), compared with the original executed in Unicorn (`recovery/stage12`). No
steering state is duplicated in Roblox: the adapter writes the two raw controls and *reads* the cells below.

Legend — status: **EXACT** (original function hand-ported, bit-exact against the original in Unicorn), **ADAPTER**
(host input / boundary, documented), **NOT PORTED** (refused at run time), **STAGE 13** (read only by force feedback).
Validation levels: L1 functions, L2 frame-start snapshots, L3 full-state restarts, L4 closed loop (`STAGE12_VALIDATION.md`).
Semantic names are interpretations; the numbers are the original's.

Car slot `C = 0x00c12030`; race settings record `S = 0x00c0692a` (`0055a680()`); active setup `U = 0x00c055c0`.
Control `n`: raw value `0xd35b18 + 10·n` (f32), binding type `0xd37cc8 + 29·n` (i32). **Control 7 = steer left,
control 8 = steer right.** Sign convention of the simulation: road-wheel target / hub angle **+ = left**.

## 1. Device layer (host, `0057abc0`)

| State | Original storage | Units / range | Writer | Readers | Default | Status / validation |
|---|---|---|---|---|---|---|
| steer-left control raw | `0xd35b5e` (control 7) | 0..1 | `0057abc0` device poll (host) | `00552d00(7)` via `0057af30` | 0 | ADAPTER (`CupChassisAdapter.steerControls` → `NR2003CupSteering.hostDevices`); L2 host-write cells |
| steer-right control raw | `0xd35b68` (control 8) | 0..1 | idem | `00552d00(8)` | 0 | ADAPTER; L2 |
| binding type 7 / 8 | `0xd37d93` / `0xd37db0` | 1 = analog axis, other = key / button | controls binding (front end) | `0057af60(n)` = type ≠ 1 ("digital"): `00551e80` linearity (both controls must be analog) and the `00552720` assistance branch; `00552d00` (the slew) does not read it | — | ADAPTER: keys → 0, analog axis → 1 (both controls) |
| analog axis value | `f5d418[]` after calibration `005d04d0` (min / centre / max quadratic → −1..1, clamp, **no dead zone**) | −1..1 | DirectInput poll | `0057abc0` splits by sign: negative half → control 7, positive half → control 8 | — | ADAPTER: Roblox already normalises the gamepad axis to −1..1; the calibration curve is the Windows device's, not ported |

## 2. Driver processing (`005524f0` player branch → `00552720`, every 36 Hz frame)

| State | Original storage | Units | Init / reset | Update | Consumers | Cup / image value | Status / validation |
|---|---|---|---|---|---|---|---|
| slew state, control 7 / 8 | `0xbf639c` / `0xbf63a0` | 0..1 | image 0; `00550530` zeroes | `00552d00(n)`: moves toward the raw value by `rate` per frame (`rate · 2.5` when raw < 0.025); output `sin(state · 1.570796326793946)` when rate < 1, raw value (no sine) when rate ≥ 1 | `00552720` | 0 | EXACT (Stage 8 hand port `V.axisOriginal`, steering index 0) · L1 1212 vectors · L2 |
| steering rate ("momentum") | `0x74c990` (index 0; throttle `0x74c994`, brake `0x74c998`) | per frame | image **0.033**; setter `005500c0(0, m)`: `m·0.01 == 0 → 1.0`, else `fd((1/(m·0.01))·0.016663333999866692)` | option message | `00552d00` | 0.033 (no controls.cfg) | EXACT · L1 setters 101 vectors |
| release factor | `0x74c99c` | — | image 2.5 (constant) | — | `00552d00` (raw < 0.025) | 2.5 | EXACT |
| linearity `L` | `0xbf6f00` | 0..1 | image **0**; setter `005502f0`: clamp(x, 0, 1), NaN → 1 | controls.cfg load `0043f1d0`: (float)int · 0.01f, int 0..100 (slider shows 100 − value) | `00552410` | 0 (no controls.cfg) | EXACT · L1 linRaw 10 + linUI 101 vectors |
| low-speed ratio override | `0x74c9a0` (byte) | bool | image **1**; setter `00550110` (ini `[Control Options] steer_ratio`) | option message | `00554fb0` | 1 | EXACT · L1 · scenario `parking` (off) |
| steering assistance | `0xbf6f08` | 0..1 | image 0; setter `00550210` (message 0x51: f32 round-down of byte · 0.01f, 100 → `0x3f7fffff`) | sent at every player load (`00443180`, ini `steeringAssist`) | `00550230` (0 when `S+0x4c` bit 29) | 0 | **NOT PORTED** for values > 0 (the branch blends the track racing line `bd7960` through the car world record `C+0x5ae`): `setSteeringOptions{assist ≠ 0}` errors |
| driving mode ARCADE | `S+0x4c` bit 25 (`0055a770`) | bool | player.ini `DrivingMode`, default Simulation (0) | race settings record (server msg 0x42) | `00552720` yaw limiter, `00552410` remap, `004233a0` chassis spec 0 at build | 0 | **NOT PORTED** in production (arcade also selects car chassis spec 0 `8945b8` at build): `yawLimiter = true` refused unless the validation flag is passed; the branch itself is EXACT (L1, scenario `yawlimit`) |
| hardcore driving aids | `S+0x4c` bit 29 | bool | player.ini `hardcoreMode` (multiplayer only) | — | `00550130/80/d0/230` return 0 | 0 | EXACT (read by `assist()`) |
| vehicle speed `v` | `0xbf6f44` (cache, f32) | m/s | — | `00554f50`: √(vz² + vy² + vx²) of the exported states `bf6d54 / bf6d4c / bf6d44` | `00552720`, `00554fb0` | — | EXACT · L1 |
| chassis yaw rate | `0xbf6d70` (exported state 12) | rad/s | solver | Stage 6 export | `00552720` (absolute value) | — | EXACT (Stage 6) |
| processed input | `0xbf63c8` | −1..1 | image 0; not-driven branch writes 0 | `00552720`: `x = fd((fd(axis 8) − axis 7) · sens)`, `sens = fd((1 − 0.15 L) + 0.15 L · fd(exp(−0.000493827 · v²)))` (`v ≥ 0.01`); arcade: `x = fd(x · limiter)`, `limiter = fd(min(12.25 / v, f) / f · 0.9 + 0.1)`, `f = max(|r|, 0.01)` | `00551e80` tail | — | EXACT · L1 3872 vectors + 400-frame key sequence · L2 |
| not-driven cells | `bf63c8 bf6f14 74c98c bf6388 bf6e84 bf63bc bf638c bf6390` = 0, `bf6eac` = 1.0 | — | — | `005524f0` when the car is not driven (adapter: no seated driver) | — | — | EXACT · scenario `notdriven` (L2 / L3 / L4). `00550640` (called when `0055a5c0() ≠ 3`) runs in neither the reference nor the port |
| assistance filter states | `bf6388 bf6e84 bf63bc bf638c` | — | zeroed | only in the assistance branch | — | 0 | NOT PORTED (assistance refused) |

## 3. Frame tail (`00551e80` @`00552082..00552336`, every frame)

| State | Original storage | Units | Update | Consumers | Status / validation |
|---|---|---|---|---|---|
| shaped input (transient) | `0xbf63c0` (first use) | −1..1 | `bf63c0 = −bf63c8`; if `00552410() ≠ 0` and both steering controls are analog: `sign(x) · |x|^(L+1)` (`_CIpow 006c5c40`, f32 store) | the target below | EXACT · L1 2100 vectors · L2 |
| ignition timers | `0xbf6e0c` / `0xbf6ea0` | frames / state | `005524b0`: count down; at 0: state 5 → 6, 7 → 0 | starter sequence | EXACT · L2 |
| steering ratio (now) | x87 value of `00554fb0` | :1 | `r = U+0xc0` (setup item **0x30**); override on and `r ≥ 7` and `v ≤ 17.88`: `v ≤ 8.94 → min(r, 7)`, else `r − (17.88 − v)·(r − 7)·0.111856826` | the target; `005662d0` cockpit wheel | EXACT · L1 192 vectors (speed at / ±1 ulp around both thresholds) |
| setup steering ratio | `0x00c05680` (`U + 4·0x30`, float) | :1 | Stage 10 garage pipeline (integer 12..32 → float; changes **no** build cell) | `00554fb0`; FFB block of `00554520` (Stage 13) | 18 | EXACT (Stage 10) · scenarios `ratio12` / `ratio32` |
| road-wheel target | `0xbf63b8` (FST) and `0xbf6e80` (frame target, after the ramps) | rad, + left | `t = fd(shaped · π_f32) / ratio` (x87 division, `π_f32 = 3.14159274` at `006f4a4c`) | ramps; `005539c0` per tick | EXACT · L1 · L2 |
| steering ramp | `0xbf6e88` | rad / tick | `(t − bf6e80_old) / 8` (exact-zero differences signed −0 as under RC-down) | `005539c0` | EXACT · L2 (bit-exact incl. sign of zero) |
| current steering (per tick) | `0xbf63c0` (after the frame-start MOV `bf63c0 = bf6e80_old`) | rad | every tick (`005539c0`): `bf63c0 += bf6e88` | hub inputs | EXACT · L2 / L3 |

Not steering, documented: the head of `00551e80` (`bf6f28` / `bf6f2c`) is an off-track drag accumulator feeding the
`00561e50` force (track dependent, pre-existing omission since Stage 6/7, unchanged).

## 4. Hub inputs and geometry (every 288 Hz tick, `005539c0` → solver)

| State | Original storage | Units | Update | Consumers | Cup values | Status |
|---|---|---|---|---|---|---|
| left / right hub input | `0xbf6360` / `0xbf6364` | rad | `lf = bf63c0 − c086b0`, `rf = c086b4 + bf63c0` | `005b2b90` copies into the core input cells `e84474[0..1]` → prescribed hub coordinates | — | EXACT (Stage 7 lines + C1 sign of zero) |
| toe halves | `0xc086b0` / `0xc086b4` | rad | build: setup item 0x29 (toe) · 0.5 | idem | 0.00224014 | EXACT (Stage 10) |
| hub coordinate `q` LF / RF | states **15 / 21** (exported `bf6d7c` / `bf6d94`; core cells `ebdd40` / `ebdd44`) | rad | **prescribed** rotation (flags 0x300: code 6, local z axis) about the inclined steering axis | multibody (wheel orientation → tyres) | — | EXACT (Stage 6 solver) |
| hub velocity | states 16 / 22 | rad/s | never written (cells read by the solve, always 0) | — | 0 | EXACT: the original models no steering rate |
| steering axis | hub record base angles (0, −10.407°, ±10.604°) on the suspension (0, 7.907°, ∓1.420°), wheel roll ∓8° | — | build `0055e9b0` (caster item 0x43/0x44 → hub pitch, camber 0x20/0x21 → hub roll) | — | caster 2.455°, inclination 9.215°, through the wheel centre | EXACT (Stage 6 / 10); research report `recovery/stage12/evidence/reports/hubgeometry.md` |
| road-wheel yaw | wheel record pose (`componentPose`) | rad | `≈ 0.9895 · q` + static toe-out ≈ 0.0032 rad per side in the multibody pose (`componentPose`; the suite measures 0.00317); at the tyre (tyre path, camber-gain coupling) 0.0038 rad per side and LF−RF 0.0076 → 0.0069 rad at q = 0.3 (slight anti-Ackermann); **no Ackermann term, no bump steer** (prismatic suspension; bump-steer coefficient spec `+0x88` = 0) | tyres | measured in the adapter mock: 0.9888 q at q = 0.449 | EXACT (geometry is the original multibody) |

## 5. Presentation (draw side, no feedback into the simulation)

| State | Original storage | Units | Update | Consumers | Status |
|---|---|---|---|---|---|
| car snapshot steer | `C + 0x1554` (`0x00c13584`) | rad | `00551990` (Stage 11 frame end): `(state15 + state21) · 0.5` | draw record: `00565880` gathers car fields into the snapshot slot `drawobj + 0xf8 + idx·0xfc` (`005ba150`), slot `+0xbc` ← `car+0x1554` (`00565a7d`); render interpolation `005ba170` → `drawobj+0x2f0` (`+0xbc` = lerp(prev, cur, t) wrapped to ±π) → `005662d0` | EXACT (Stage 11 lift; the draw gather / interpolation is presentation, not ported: the adapter reads `car+0x1554` of the current frame) |
| cockpit steering-wheel angle | — (draw) | rad, + clockwise (right turn) | `005662d0` (also `00565cc0`): `clamp(−(00554fb0() · car[0x1554]), ±2.79)` | original: roll of the model node `steer` (rest heading / pitch kept) only for the focus car in the cockpit / LookLeft / LookRight cameras; otherwise only the 3do variable `timeValue = 10·max(0, trunc(deg(a) + 160.355))`; the front wheels show the mean angle | EXACT formula · `V.steeringWheelAngle()` → `Cockpit.updateAngle` / render snapshot `steer` (flag `FLAG_WHEEL_ANGLE`); Roblox rotates the cockpit wheel in every view (ROBLOX ADAPTER presentation choice; `reports/drawchain.md`) |
| replay / network steer | packet field from `bf6360` quantised by `005beac0(e0b6dc)` | — | replay recorder | replay | NOT PORTED (no replay) |

## 6. Force feedback (Stage 13 interface, not implemented)

The original FFB reads **no steering-chain cell** (`recovery/stage12/evidence/reports/ffbinterface.md`). Its inputs are
front-tyre statistics accumulated twice per tick by the tyre callback `0055e180 → 00554e70` (front wheels): relaxed
lateral slip `c085dc`, |Fz| + 0.01, Fy, moment `0.1·(r×F)z + c081ec` → `bf6ed4..bf6ef0`, counters `74c964 / 74c968`.
`00554d30` (per tick, `005539c0 @00553a64`) writes `bf6ec4` (load-weighted front slip), `bf6ec8` (front Fy, no reader),
`bf6ed0` (front moment; also telemetry `bf643e`), `74c960` (front loads ≤ 1500, no reader) and clears the
accumulators. The FFB block of `00554520` (gated by `bf6ebb` and `bf6eb8 == 0`) keeps `bf6ec0 / bf6ecc` and outputs
`clamp(ecc · 74c9a4 (= 80) / (item 0x30 ratio · 1600), ±1)` to the device (`005d08d0`). Nothing feeds back into the
physics. `bf6eb8` (written by `00550070`, "player controls suspended") makes `005524f0` take the not-driven branch: it
is 0 in the port and in the reference. Stage 12 leaves all FFB cells untouched (Stage 11 values).

## 7. Initialisation / reset / persistence

- **Image defaults** (no controls.cfg, bench image): linearity 0, rate 0.033 / frame, release 2.5, override 1,
  assistance 0, Simulation, setup ratio 18.
- **Reset**: `V.reset()` restores the post-build image, then re-applies the option table given to
  `V.setSteeringOptions` (the original keeps option values across sessions). `00550530` (original steering reset)
  zeroes `bf63c8 bf6f14 74c98c bf6388 bf6e84 bf63bc bf638c bf639c..bf63a8 bf6360/64 bf6f28/2c`; the image restore
  covers the same cells.
- **Garage**: setup item 0x30 goes through the Stage 10 pipeline (`applySetup`); it changes no build cell, only `U+0xc0`.
- **Checkpoint / restore**: all steering states are memory cells → `V.checkpoint()` / `V.restore()` replay bit-identically
  (determinism test of the Stage 12 suite).
