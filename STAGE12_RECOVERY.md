# Stage 12 — recovery report (steering chain)

Scope: the complete NR2003 steering chain of the player car, from the driver's controls to the prescribed front hub
coordinates of the multibody, plus the cockpit steering-wheel presentation. Recovered with Ghidra 11.1.2 (headless,
read-only project of NR2003.exe), the exe memory image (`NR2003_MEM`) and Unicorn 2.1.4 executing the original code;
the port is `core/NR2003Cup/NR2003CupSteering.lua` (+ Stage 12 lines in `NR2003CupDriver.lua`). Evidence:
`recovery/stage12/evidence/` (`ev1..ev14`: pseudo-C + asm with constants of the recovered steering functions, `FUNCS.txt` per
export; the message dispatcher / handlers, `004233a0`, `005beac0` and the FFB functions are documented in the `reports/`
evidence lists or in earlier stages' evidence; `funcs_*.tsv` function lists; `reports/` five research reports — bit25, ffbinterface, hubgeometry, setupitems, uiconv — with their own evidence lists). State map:
`STAGE12_STEERING_STATE_MAP.md`. Validation: `STAGE12_VALIDATION.md`.

Force feedback / steering torque is **Stage 13**: `00554d30`, `bf6ec4..bf6ef0` and the FFB block of `00554520` were
analysed only to define the interface (§ 8); nothing of it is implemented.

## 1. Audit of the Stage 11 baseline

- Baseline `OpenNR2003_Roblox_TestBench_STAGE11.zip` imported as commit `626eabe` (3.10.0-stage11) with
  `tests_stage11.zip`; the 72 test files restored from it matched their `MANIFEST.json` sha256, and the whole working
  tree matched the manifest (5202 files, 0 mismatches).
- Regression on this machine before any change: Stage 6/7 16/16, Stage 8 49/49, Stage 9 59/59, Stage 10 23/23 + 61/61,
  Stage 11 66/66, adapter mock 55/55, patch mocks 11 / 13 / 13 / 17 / 15 — all PASS.
- Steering before Stage 12 (PROVISIONAL since Stage 5): the adapter computed a road-wheel target with a Stage 5
  slew / speed law (`CupTune.steering`) and handed it to the core as `controls.steer`; `NR2003CupDriver.frameStart`
  wrote it to `bf63b8 / bf6e80` with the ramps of the original tail. Everything downstream (per-tick ramp, toe,
  hub coordinates, solver) was already original (Stages 6/7). Stage 12 replaces the host target by the original chain.

## 2. Where the chain runs (update order)

```
36 Hz task frame (005b2190 -> 00551e80, player car)
  0057abc0  device poll (HOST): controls 7 (steer left) / 8 (steer right) -> d35b18 + 10n, binding type d37cc8 + 29n
  005524f0  player branch:  00553080 brake ; clutch ; bf63c8 = (f32) 00552720() ; 00552df0 throttle ...
            not driven:     bf63c8 bf6f14 74c98c bf6388 bf6e84 bf63bc bf638c bf6390 = 0, bf6eac = 1, shift keys cleared
    00552720   v = 00554f50 ; yaw = |bf6d70| ; a8 = 00552d00(8) ; a7 = 00552d00(7) ; x = (a8 - a7) * sens
               [arcade: x *= limiter] [assistance > 0: racing-line blend]
  00551e80 tail @00552082..00552336
            bf63c0 = -bf63c8 ; tyre accumulators cleared ; 005524b0 ignition timer
            linearity: if 00552410() != 0 and both controls analog: bf63c0 = sign * |x|^(L+1)   (_CIpow 006c5c40)
            t = f32(bf63c0 * pi_f32) / 00554fb0()  ->  bf63b8 = t ; bf63c0 = bf6e80 (MOV) ; ramps ; bf6e80 = t
288 Hz tick (005539c0, 8 per frame)
            bf63c0 += bf6e88 ; bf6360 = bf63c0 - c086b0 ; bf6364 = c086b4 + bf63c0  -> 005b2b90 -> e84474[0..1]
            -> prescribed lfhub / rfhub rotation (states 15 / 21) -> multibody -> tyres
frame end (00554520 / 00551990, Stage 11): car[0x1554] = (state15 + state21) / 2
draw (005662d0 / 00565cc0): steering wheel = clamp(-(00554fb0() * car[0x1554]), +-2.79 rad)
```

## 3. Recovered functions (new in Stage 12)

| Address | Role | Port | Status |
|---|---|---|---|
| `0057abc0` | device poll: DirectInput axes / keys → control table (`0057af30` raw f32, `0057af40`, `0057af60` digital = type ≠ 1); an axis bound to both steering controls is split by sign | `NR2003CupSteering.hostDevices` + adapter `steerControls` | ADAPTER |
| `005d04d0` | joystick calibration: min / centre / max → −1..1 (quadratic, clamp, no dead zone) | Roblox normalises the axis | ADAPTER (documented) |
| `005524f0` | per-frame driver devices (player / not-driven branches) | `NR2003CupDriver.frameStart` (Stage 7/8) + `V._steerDevices` | EXACT for the steering input (`bf63c8 = 00552720()`), the Stage 8 brake path and the not-driven cells; throttle / clutch device processing (`00552df0` / `005534f0`) still host values (PROVISIONAL since Stage 7); the low-speed `00568e00` / `bf6f18` block, `0057af40(3)` / `bf6f36` / `car+0x1518`, the ignition key and the game-state / `bf6eb8` gate are not ported (the gate is replaced by `controls.driver = false`) |
| `00552d00` | per-control slew limiter + `sin(x·π/2)` shaping (steering indices) | Stage 8 `V.axisOriginal` (reused) | EXACT |
| `00552720` | processed steering input (speed sensitivity, arcade yaw limiter, assistance) | `steerInput` | EXACT (assistance > 0 NOT PORTED) |
| `00552410` | linearity value (arcade / assistance remap 0.66 L + 0.34) | `linearity` | EXACT |
| `00550230` | steering assistance getter (0 when race bit 29) | `assist` | EXACT |
| `0055a770` / `0055a680` | race settings bit 25 (arcade) / race settings record | `settingsBit25` | EXACT |
| `00554f50` | vehicle speed + cache `bf6f44` | `speed` | EXACT |
| `00551e80` tail | linearity, × π, / ratio, target, ramps | `V._steerTail` + `frameStart` | EXACT |
| `005524b0` | ignition-sequence timer (in the tail) | `ignitionTimer` | EXACT |
| `00554fb0` | steering ratio (setup item 0x30) + low-speed override | `ratio` | EXACT |
| `006c5c40` | `_CIpow` (SecuROM-encrypted in the image) | Luau `x ^ y`; reference `POW_X87` (FYL2X / F2XM1 / FSCALE) | EXACT on all vectors (§ 6) |
| `005502f0` / `005500c0` / `00550110` / `00550210` | option setters (linearity, momentum, low-speed override, steering assistance; `00550120` = braking help `bf6f04`, not steering) reached through the front-end messages 0x48 linearity, 0x49 steering momentum, 0x4c low-speed override ("BoostSteering"), 0x51 steering help (table `00752370`, dispatcher `005bad80` drained by `005f8ec0` on the simulation task under CW 0x077f; handlers `005bb010..005bb130`) | `setLinearityRaw`, `setMomentum`, `applyOptions` | EXACT (assistance > 0 refused) |
| `0043f1d0` | controls.cfg load (front-end task): linearity = `FILD [894d40]` (file field) `· 0.01f` (f32 `0x3c23d70a`) → `00570f20` (message 0x48); momentum ints (steering / throttle / brake) → (float)int → messages 0x49..0x4b → `005500c0`; override byte → message 0x4c. UI variables: linearity slider `72c5f0` (shows 100 − value, default 80), momentum sliders `894e18 / 1c / 20` | `setSteeringOptions{linearity, momentum}` (UI-thread f32 rounding to nearest) | EXACT |
| `00550530` | steering state reset (callers `00550490`, `00550a10`, `00551520`) | image restore in `V.reset` | EXACT (same cells) |
| `005662d0` / `00565cc0` | cockpit / car-model steering-wheel angle | `V.steeringWheelAngle` | EXACT formula |
| `00551990` | car snapshot (`car[0x1554]` mean front steer) | Stage 11 lift (frame end) | EXACT |
| `005beac0` | replay / network quantisation of `bf6360` (`e0b6dc`) | — | NOT PORTED (no replay) |

## 4. Findings (what the shipped NR2003 does and does not do)

1. **Two controls, not one axis.** Steering is control 7 (left) and control 8 (right), each 0..1; an analog wheel or
   stick bound to both is split by sign in the device layer. `00552720` returns `a8 − a7` (right − left) scaled; the
   tail negates it (`bf63c0 = −bf63c8`), so the simulation's road-wheel target is **+ = left**.
2. **Keys and axes differ only in the binding type.** Digital controls get the same slew (`74c990`, 0.033 / frame by
   default, × 2.5 below 0.025) and sine shaping as analog ones; the **linearity exponent applies only when both
   steering controls are analog** (`0057af60`).
3. **Speed sensitivity exists only through the linearity value**: `sens = (1 − 0.15 L) + 0.15 L · exp(−0.000493827 v²)`.
   With L = 0 (image default, no controls.cfg) the input is not speed-scaled at all. No other speed multiplier exists.
4. **Lock = π / ratio at full input.** `t = fd(x · π_f32) / ratio` with the setup steering ratio (item 0x30, garage
   12..32, default 18): ±0.1745 rad (10°) at 18:1. The **low-speed override** (ini `[Control Options] steer_ratio`,
   default on) lowers the ratio to 7:1 at ≤ 8.94 m/s (±π/7 = ±0.4488 rad) and ramps it linearly back to the setup
   ratio at 17.88 m/s (slope 1/8.94 = 0.111856826). A setup ratio below 7 is never overridden.
5. **No Ackermann, no bump steer, no steering rate.** Both hubs receive the same angle ± toe/2; the hubs are
   prescribed rotations about an inclined axis (caster 2.455°, inclination 9.215°) through the wheel centre; the
   geometry gives road-wheel yaw ≈ 0.9895 q with a slight anti-Ackermann trend; the suspension is prismatic and the
   bump-steer coefficient (spec `+0x88`) is 0 in all 21 car specs; the hub velocity states (16 / 22) are never written.
   (`reports/hubgeometry.md`.)
6. **Race settings bit 25 is the ARCADE driving mode** (player.ini `DrivingMode`, default Simulation): it enables the
   yaw-rate limiter in `00552720` (`limiter = min(12.25 / v, f) / f · 0.9 + 0.1`, `f = max(|r|, 0.01)`, v ≥ 0.01), remaps L to
   `0.66 L + 0.34` and makes `004233a0` select car chassis spec 0 at build time. Bit 29 is the multiplayer
   "hardcore driving aids" flag (aids → 0). (`reports/bit25.md`.)
7. **Steering assistance** (`bf6f08 > 0`) blends a racing-line steering command from the track system (car world
   record `C+0x5ae`, racing line `bd7960`, `00527580 / 00536180 / 00536260 / 00535530`) — it needs the NR2003 track.
8. **Option values come only from the front end.** Linearity, momentum and the override are sent by the controls.cfg
   load (`0043f1d0`, front-end task, round to nearest: linearity = (float)int · 0.01f with the f32 constant
   `0x3c23d70a` — a double 0.01 would differ for 30 of 0..100); without a controls.cfg nothing is sent and the
   simulation keeps the image values (linearity 0, rate 0.033, override 1 or the ini `steer_ratio`). The front-end
   defaults (linearity int 80 → `0x3f4ccccc`, momentum 0 → rate 1.0) reach the simulation only after the controls dialog
   saves and re-reads controls.cfg. The messages are applied only in game states 0 / 3 / 4 / 5 (flags 0x9201). The
   simulation keeps option values across sessions; setup item 0x30 is read at run time and changes no build cell.
   (`reports/uiconv.md`.)
9. **Cockpit wheel** = `−(ratio_now · mean hub angle)`, clamped to ±2.79 rad: the drawn wheel turns ratio × the hub
   angle (7:1 at low speed with the override, so full lock at rest hits the clamp).
10. **SETUP_MAP correction**: items 0x3a and 0x9f..0xa4 ("steeringGeometry*") are **not steering**: they are the rear
    limited-slip differential ramp coefficients (`00424860` from the table `006ed7e0`; 0xa3 / 0xa4 read every tick by
    the drivetrain native `005614b0`, already lifted). The identifiers are kept for API compatibility; the semantics
    are corrected in `SETUP_MAP.md`. (`reports/setupitems.md`.)

## 5. Host boundary (ADAPTER) — identical in the Luau port and in the Unicorn reference

| Boundary | Original | Port / reference |
|---|---|---|
| raw controls | `0057abc0` polls DirectInput into `d35b18 + 10n`, types `d37cc8 + 29n` | `hostDevices(c)`: `steerAxis` (−1..1, + right) → split by sign, type 1; or `steerLeft` / `steerRight` 0..1 with `steerDigital` (type 0). The Unicorn harness `orig_stage12.host_steer_devices` writes the same cells |
| device calibration | `005d04d0` | not ported: Roblox's gamepad axis is already −1..1 |
| driver present | `005524f0` branch by "car driven" | adapter: seated driver → driven; none → `controls.driver = false` |
| options | front-end messages (table `00752370`) | `V.setSteeringOptions` calls the ORIGINAL setters' logic; the reference calls the original setters |
| arcade / assistance | race settings / options | refused in production (§ 8) |

## 6. Numeric notes

- Simulation task CW `0x077f`: every f32 store rounds toward −∞ (`fd` / `wf32d`); x87 intermediates are evaluated in
  IEEE double (Stage 6/7 convention). Values compared bit for bit are the f32 cells; the x87 value of `00552d00(7 / 8)` is
  compared within ≤ 4 double ulp (observed worst 0.99 ulp), that of `00554fb0` within ≤ 2 double ulp (observed 0.00); the
  target is compared bit for bit through its f32 stores (`bf63b8` / `bf6e80` / ramp `bf6e88`).
- Exact-zero sums under RC-down are −0 (`x − x = −0`). The tail ramps and the per-tick composition sums sign zeros
  the same way (`zadd` / `zsub`); see change record C1 in `STAGE12_RESULT.md`.
- `exp(−0.000493827 v²)` is `FLDL2E / FMUL / FRNDINT (RC down = floor) / F2XM1 / FSCALE`; the port uses the lifter
  convention `exp2` (Stage 6/7). `00552d00` uses `FSIN`; Unicorn (QEMU) computes FSIN / F2XM1 with host doubles, the
  same model as the port — all 1200 + 3872 vectors bit-exact on the stored f32.
- `_CIpow` (`006c5c40`) and `_ftol` are SecuROM-encrypted in the memory image: the reference executes
  `POW_X87` (FYL2X / F2XM1 / FSCALE), the port `x ^ y`; the 2100 tail vectors are bit-exact on `bf63c0`.
- Front-end payloads (linearity `int · 0.01f`) are built on the UI thread (CW `0x027f`, round to nearest):
  `f32near`.
- Unicorn: `emu_start(until)` keeps a translation-block cache; the reference removes it (`ctl_remove_cache`) before
  stopping in the middle of `00551e80`.

## 7. Integration points changed outside Stage 12 (why)

| File | Change | Why |
|---|---|---|
| `core/NR2003Cup/NR2003CupDriver.lua` | `frameStart`: `V._steerDevices(c)` inside the player branch (after the brake / clutch, before the throttle write, as `005524f0`); target from `V._steerTail` (or `controls.steer` in steering mode "provisional"); ramps with `zsub` in original mode. `tickInputs`: `zadd` in the steering / pedal composition sums (C1). `frameStartAll` → `V._frameStartOnly` (frame start without ticks, for the L2 snapshots) | the original order; C1 sign of zero |
| `core/NR2003CupVehicle.lua` | installs `NR2003CupSteering` after the garage; API wrappers | |
| Stage 6/7–11 suites and self-tests | `V.setSteeringMode("provisional")` one-liner | their golden data were produced with the Stage 6–11 host steering contract |
| `roblox/*` | device layer, cockpit wheel angle, render flag, telemetry | presentation / host |

## 8. Not ported / still open

- **Steering assistance > 0** — needs the track racing line (track system not ported): refused (`setSteeringOptions`).
- **Arcade driving mode** — besides the steering branch (EXACT, validated with the bit set), it selects car chassis
  spec 0 (`8945b8`) at build; that path is not recovered: refused in production.
- **Joystick calibration / DirectInput** — host side, not applicable to Roblox (ADAPTER).
- **Replay / network steering quantisation** (`005beac0`) — no replay in the port.
- **Force feedback / steering torque** — Stage 13 (`reports/ffbinterface.md`). The original FFB reads **no steering-chain
  cell**: the front tyre callback `0055e180 → 00554e70` accumulates per pass (front wheels) the relaxed lateral-slip
  state `c085dc`, |Fz| + 0.01, Fy and the moment `0.1·(r×F)z + c081ec` into `bf6ed4..bf6ef0` / `74c964..68`; `00554d30`
  (per tick, in `005539c0`) reduces them to `bf6ec4` (load-weighted front slip), `bf6ec8` (front Fy), `bf6ed0` (front
  moment) and `74c960` (front loads ≤ 1500) and clears the accumulators; the FFB block of `00554520` (gated by
  `bf6ebb` device acquired and `bf6eb8 == 0`) computes `out = clamp(ecc · strength / (ratio · 1600), ±1)` with
  ratio = setup item 0x30, strength `74c9a4` = 80, latency / damping options, airspeed `bf3a00`, and sends it to
  `005d08d0` (DirectInput constant force). No output feeds back into the physics (the original with `00554d30`
  disabled stays bit-identical except the 14 FFB dwords). One cell of the FFB / controls setup path does gate the
  steering chain: `00550070` writes `bf6eb8` ("player controls suspended"), which `005524f0 @00552549` tests to take the
  not-driven branch; it stays 0 in the port and in the reference. Stage 12 implements none of this.
- **Pre-existing, unchanged**: the off-track drag accumulator at the head of `00551e80` (`bf6f28 / bf6f2c` →
  `00561e50`), track dependent.
