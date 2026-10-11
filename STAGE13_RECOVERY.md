# Stage 13 — recovery report (steering torque / force feedback)

Scope: the complete NR2003 force-feedback (FFB) chain of the player car, from the front tyre forces of the multibody to
the DirectInput constant force on the steering axis, and the simulation-side controls / device setup that gates it.
Starting point: the Stage 12 interface research (`recovery/stage12/evidence/reports/ffbinterface.md`, revision 2), which
was re-verified here instruction by instruction and completed (sections 6–8).

Toolchain of this stage: the Ghidra project of **OpenNR2003** (`github.com/TChapman500/OpenNR2003`, `OpenNR2003.gpr` +
`.rep`, program `NR2003.exe`, owner `TChapman500`), opened read-only with Ghidra 11.1.2 headless; the memory image
exported with `recovery/ghidra_tools/ExportMemoryPy.py` (= `NR2003_MEM`, 10 blocks incl. `.rdata`, `.data`, BSS);
Unicorn 2.1.4 + Capstone; Luau CLI 0.741. The export was checked before use: its `.text` equals
`recovery/vehicle_core/00400000.bin` byte for byte, and `recovery/stage12/gen_units12.py` regenerates the committed Stage
12 L1 vectors (`tests/stage12/fixtures/units.lua`) byte for byte. Listings of every routine quoted here:
`recovery/stage13/evidence/dis/` (Capstone on the export, constants annotated).

## 1. Data flow

```
per tyre pass (2 per tick: predictor e843fc = 1, corrector 0), front wheels only (0055d9c0 @0055e110)
  0054cab0 (tyre)            c085dc relaxed lateral slip state, c081ec aligning moment, Fy / Fz outputs
  JIT -> 0055e180            p = [Fy, Fz, (r x F).z] -> 00554e70(w, c085dc, |Fz| + 0.01, Fy, 0.1 (r x F).z + c081ec)
  00554e70                   n 74c964+4w ++ ; A bf6ed4+4w += ; B bf6edc+4w += ; C bf6ee4+4w += ; D bf6eec+4w +=
per 288 Hz tick, 005539c0 (inside the bf6e04 'player vehicle simulated' branch)
  @00553a52  bf63c0 += bf6e88          (Stage 12 ramp)
  @00553a64  call 00554d30             -> 74c960, bf6ec4, bf6ec8, bf6ed0 ; accumulators cleared
  @00553a69  bf6360 = bf63c0 - toe ... (Stage 12 hub inputs)
per 36 Hz frame, frame end 00554520 (whole function gated by 00551880 = bf6e04)
  ... 0055455f bf3a00 = airspeed ... 00551990 car snapshot ...
  0055464c   FFB block (gate bf6ebb != 0 && bf6eb8 == 0) -> 005d08d0(bf6ebc, out)
             -> 005d2260 -> 005d2370 (global axis -> device, local axis) -> 005d3010 (DirectInput SetParameters)
```

The FFB reads **no steering-chain cell** (Stage 12 report §1, re-verified): the steering acts on the FFB only through
the front tyre forces it produces. Nothing written by the FFB is read by the physics (§9).

## 2. `00554d30` — per-tick front tyre statistics (`evidence/dis/00554d30.txt`)

x87 CW 0x077f (64-bit precision, round toward −inf); `[ESP]` is an f32 local.

```
a = 0 ; l = 0                                          (00554d75: fld 0.0 ; mov dword [esp], 0)
if n_LF > 0:                                           (00554d38 jle)
    sx = B_RF + B_LF ; [esp] = f32(sx)                 (fld / fadd / fst)
    if sx > 0:                                         (fcomp 0.0 ; and 0x4100 ; jne: skipped for sx <= 0 and NaN)
        a = 1 / n_LF                                   (fild ; fdivr 1.0)
        l = f32(B_LF / f32(sx))                        (fld ; fdiv dword [esp] ; fstp dword [esp])
b = (n_RF > 0) ? 1 / n_RF : 0
74c960 = f32(B_RF b + B_LF a) ; if the x87 value > 1500: 74c960 = 1500 (immediate 0x44bb8000; NaN is NOT clamped)
bf6ec4 = f32(((1 - l) A_RF) b + (A_LF l) a)
bf6ec8 = f32(C_RF b + C_LF a)
bf6ed0 = f32(D_RF b + D_LF a)
n_LF, n_RF, A, B, C, D <- 0  (integer MOVs; every value is read before its own clear)
```

Correction of the Stage 12 report: the 1500 clamp is skipped for NaN (`and 0x4100 ; jne` jumps when C0 or C3 is set,
and an unordered compare sets both); the report said "if > 1500 (or unordered): 1500".

## 3. FFB block of the frame end `00554520` (`evidence/dis/00554630.txt`, `0055464c..0055479d`)

```
gate: [bf6ebb] != 0 (FF effect acquired) and [bf6eb8] == 0 (player controls active)
rate = 005f7c50()  (taskGetRate: 0x24 = 36)
d   = f32(rate (ec4 - ec0)) ; ec0 = ec4 (integer MOV)
q   = f32(ec4 + ((1 - 20 / (airspeed + 20)) (latency 0.001f)) d)     latency bf6f20, airspeed bf3a00
m   = (|ec4| > 1e-5f) ? (q / ec4) ed0 : ed0                            (|ec4| = and 0x7fffffff; equality takes ed0)
ecc = f32((m - damping d + ecc) 0.5)                                    damping bf6f24 ; fst [esp+0x10] + fstp ecc
out = f32(ecc (strength / (item0x30 1600)))                             strength 74c9a4 ; 00557d60(0x30), ECX c055c0
out = 1 if 1.0 < out ; -1 if -1.0 > out (NaN passes unchanged)
005d08d0(bf6ebc, out)
```

`00557d60` is `mov eax,[esp+4] ; lea eax,[ecx+eax*4] ; ret 4`, so after the call `[esp+0xc]` is the slot written by
`fst [esp+0x10]` while `push 0x30` was still on the stack: the output uses **ecc** (the stored f32), not q. Item 0x30 is
read raw (the setup ratio, `c05680`), without the low-speed override of `00554fb0`.

Constants (from `.rdata`): 0.0 `006ea454`, 1.0 `006e97d8`, −1.0 `006ea4a8`, 1500 `006f5878`, 20 `006ecfc8`, 0.001f
`006ea67c` (= 0.0010000000474974513), 1e−5f `006ea480`, 0.5 `006ea44c`, 1600 `006f5a44`, 10000 `006f5214`.

## 4. Device output `005d08d0` → `005d3010` (host: DirectInput)

* `005d08d0(axis, force)`: only when `[f5d4f0]` (DirectInput up) and `[f5d414]` (effect acquired) are set, tail jump
  `005d2260` → `005d2370` (global axis → device, local axis) → `005d3010`.
* `005d3010`: `fld dword force ; fmul dword 10000.0` (exact: 24 × 14 bits), `_ftol` (CRT, truncation toward zero;
  SecuROM-encrypted in the shipped exe, the harness replacement and the lifter builtin truncate) → `lMagnitude`, a
  `DICONSTANTFORCE` in a `DIEFFECT` (dwSize 0x38, DIEFF_OBJECTOFFSETS), `SetParameters(DIEP_TYPESPECIFICPARAMS |
  DIEP_START)`.
* `005d2bb0` creates the only effect, `GUID_ConstantForce`, on one axis, `DIEFF_CARTESIAN | DIEFF_OBJECTOFFSETS`,
  `rglDirection = {0}` (one axis: the sign of the magnitude alone gives the direction), duration −1, gain 10000, after
  `SetProperty(DIPROP_AUTOCENTER, 0)`. No spring / damper / condition effect exists (`005d2ee0` returns at its NULL
  check; Stage 12 report §6).

## 5. Gate and options

| cell | meaning | writers (original) | image |
|---|---|---|---|
| `bf6ebb` (byte) | FF effect acquired | `0054fed0` (1 after a successful acquisition, 0 on release), `00550680`, `00550490` | 0 |
| `bf6eb8` (byte) | player controls suspended — also the `005524f0` gate @`00552549` (not-driven branch) | `00550070`, `00550490` (car init) | 0 in the port's post-build image |
| `bf6ebc` (dword) | FF axis = global axis number of the control-7 binding (`rec+0x14`) | `0054fed0` | 0 |
| `74c95c` (dword) | +1 / −1 from the direction character of the axis name (no reader) | `0054fed0` | 1 |
| `bf6f1c` (byte) | FF on/off | `00550270` (message 8) | 0 (off) |
| `74c9a4` (f32) | strength | `00550290` (message 9) | 80.0 |
| `bf6f24` (f32) | damping | `005502d0` (message 10) | 0.0 |
| `bf6f20` (f32) | latency (ms; the 0.001 factor) | `005502b0` (message 11) | 0.0 |
| `bf6ec0` / `bf6ecc` (f32) | previous slip / filtered torque (block state) | block, `00550530` (reset) | 0 |

## 6. Controls and FF setup (`evidence/dis/00550070.txt`, `0054fed0.txt`, `00550680.txt`, `0057aff0.txt`)

```
00550070(flag):  if flag == 0: 0054fed0()                         (byte flag)
                 if bf6ebb && flag: 00550030()  -> 005d08a0(axis, 0, 0, 0.75) (no effect exists: no-op) + 005d08d0(axis, 0.0)
                 bf6eb8 = flag
0054fed0():      0057b1e0(7) -> 0057aff0 on the control-7 binding record d37d83 = d37cb8 + 29 * 7:
                   type = rec+0x10 (1 = analog axis), axis = rec+0x14, name = table 0074fc68[(byte rec+0x1c != 0) + 2 axis]
                   ("<n><" / "<n>>", axis < 16) or "?" (0074fd52)
                 type != 1:  if bf6ebb: 501b30 ; 005f79a0(00550060) (release on the FG thread) ; bf6ebb = 0 ; return
                 if bf6ebb and not (FF on (00550280 = bf6f1c) and bf6ebc == axis): release ; bf6ebb = 0
                 74c95c = (first character after the digits == '>') ? -1 : 1 ; bf6ebc = axis
                 if not bf6ebb and FF on and 005d0820(axis) (FF capable):
                     501b30 ; 005f79a0(00550000, &ok) -> 005d0840(axis) acquire ; ok -> 00550030 (zero force)
                     ok: bf6ebb = 1
00550680():      if bf6ebb: release ; bf6ebb = 0                      (session end: 00572cb0 / 00573bc0)
```

`005f79a0` (bgRequestFGAction) waits on the simulation thread until the foreground thread has run the request; its own
direct path `005f79de` calls the function at once (used when not in the background). Callers of `00550070`
(raw call scan of `.text`): `00550930` / `00550a50` @00550b07 / `00550b30` (car placed: flag 0), `00550a10` (flag 1),
`0057ab00` / `0057ab90` (fgmsgSelectActiveControls, message 6). `00550a50` calls it right after `car+0x1518 = 0` and
before `00524930` / `005500b0(0)` — the port's `enterTrack` (Stage 11 subset) now runs it at that place.

## 7. Where the FF options come from (resolved, open in the Stage 12 report)

A raw scan of every `E8 / E9` in `.text` finds exactly one caller of each option sender `00570e00` / `00570e30` /
`00570e60` / `00570e90`: the controls.cfg loader `0043f1d0` (@`0043f52b..0043f57a`). It sends the controls.cfg integers
converted by `fild dword ; fstp dword` (exact for 0..250), without clamping them at load; the front-end slider setters
clamp strength and damping to 0..100 (`0043ef90` / `0043efe0`) and latency to 0..250 (`0043f030`). Without a
controls.cfg the simulation keeps its image values (FF off, 80, 0, 0); the front-end strength shadow `72c5ec` is 50.

## 8. Arithmetic: why the port evaluates the FFB in exact x87 arithmetic

The Stage 6–12 convention (x87 intermediates in IEEE double, f32 stores rounded toward −inf) can change a stored bit
whenever an exact intermediate lies within double rounding of an f32 boundary — e.g. an f32 `a` plus a tiny negative
`b`: double returns `a`, the x87 (64-bit, RC = down) a value below `a`, stored one f32 ulp lower. The Stage 11 lift of
`00554520` contains the FFB block in that double model. Measured on the original's own calls of the closed-loop runs
(Stage 13 L2): the double model changes a stored bit in 197 of 26 568 calls — 8 / 9720 (slalom), 61 / 3024
(brakesteer), 57 / 1728 (ratio12: latency 250, damping 100), 15 / 2376 (linear), 7 / 1296 (notdriven), 49 / 5832
(suspend), 0 / 2592 (keys: block never runs). Stage 13 therefore evaluates `00554d30` and the block with exact x87 arithmetic
(`NR2003CupFFB` X87: 64-bit significand, round toward −inf, every op; exact double fast path when TwoSum / Dekker
TwoProduct show the operation exact) and skips the lifted copy of the block (§10).

## 9. No feedback (dynamic proof, `recovery/stage13/dev/nofeedback.py`, `evidence/nofeedback.txt`)

Two ORIGINAL machines in lockstep, `brakesteer` with the FFB on (strength 100, damping 30, latency 50, acquired, block
every frame) and the same law with the FFB off: over 400 frames (3200 ticks) the whole window `0x6e9000..0xf80000`
differs only in `74c9a4`, `bf6eb8` (dword holding `bf6ebb`), `bf6ec0`, `bf6ecc`, `bf6f1c`, `bf6f20`, `bf6f24` and the
harness host byte. The Stage 12 proof (`00554d30` = RET, 5 runs) showed the same for the statistics.

## 10. Port (`core/NR2003Cup/NR2003CupFFB.lua`) and integration

* `00554d30` → `V._ffbTick`, called by `NR2003CupDriver.tickInputs` at its slot @00553a64 (after `bf63c0 += bf6e88`,
  before `bf6360`).
* FFB block → `V._ffbFrameEnd`, called by `NR2003CupFrame` right after the lifted `00554520` (where the block ends the
  function); the lifted copy is skipped by presenting `bf6ebb = 0` during the call (its only reader in `00554520` /
  `00549c40`); the whole frame end is gated by `bf6e04` as in the original.
* `00550070` / `0054fed0` / `00550030` / `00550680` and the option setters: hand port; `NR2003CupFrame.enterTrack` runs
  `00550070(0)` at the place of @00550b07; `NR2003CupDriver.frameStart` takes the `005524f0` not-driven branch while
  `bf6eb8` is set.
* Device layer (ADAPTER, the DirectInput module): capable / acquire supplied by the host, `005d08d0` delivered to a sink
  (`axis, force, lMagnitude = _ftol(force · 10000)`), effect state host-side (part of `checkpoint` / `restore`).
* The Roblox device layer re-binds controls 7 / 8 every frame (Stage 12); a change of the control-7 binding type while
  FF is on (keys ↔ axis) runs `00550070(0)`, what the game's controls menu + fgmsgSelectActiveControls do (ADAPTER).

## 11. Verified / inferred / not ported

**Verified** (static listings; dynamic in the Unicorn harness): every formula and gate above; the block's use of ecc;
the NaN behaviour of both clamps; the only callers of the option senders; the `00550a50` call order; the device
decisions of `0054fed0` for binding types 0 / 1 / 3 (types 2 / 4 run front-end string formatting in `0057aff0`, not set
up in the bench; `0054fed0` only tests `type == 1`); the no-feedback property.

**Inferred** (unchanged from the Stage 12 report): the physical meanings (`c085dc` relaxed slip, `c081ec` aligning
moment, `74c960` front load), latency in ms, damping without a physical unit; the DirectInput sign convention of a
single-axis constant force (positive magnitude toward the positive axis direction).

**Not ported (host)**: DirectInput itself (`005d0xxx` / `005d2xxx`, device enumeration, `005d2370` axis mapping),
`501b30` (unidentified host routine called before each FG request: it reads `b8f15c` / `b8e58a` and returns at once in the bench; it writes no simulation cell of the FFB), the telemetry copy `bf643e` (`bf63d8`, no reader), the
controls menu / controls.cfg file (the API takes the controls.cfg integers).
