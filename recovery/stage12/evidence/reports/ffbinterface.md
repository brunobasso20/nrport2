# FFB interface of the original steering chain: what Stage 13 needs (label: ffbinterface)

Scope: `00554d30` (per-tick FFB statistics), the force-feedback block of the frame end `00554520`, `005d08d0`
(device output), `00550070` (FFB setup / controls gate) and their producers. This is an investigation for Stage 13.
It does not propose an implementation.

Scratch and evidence: `/opt/s12/work_ffbinterface/`
* Ghidra exports (project `/opt/nrproj_4`, read-only): `ev1/` (00554d30, 00554520, 005d08d0, 00550070, 0054fed0,
  00550030 + depth 1, `index.tsv`), `ev2/` (005d3010, 005d2210, 005d2ee0, 005d2370, 005d0840, 005d0870, 005d2170,
  005d21c0, 005d2130, 00550490, 00550a10, 00550a50, 00550b30, 00550680, 00550530, 005548d0, 005f7c50, 00557d60),
  `ev3/` (005d2bb0, 005d2b90, 006c5018).
* Xrefs: `xr1.tsv` (74c960+12, 74c9a4, bf6eb8+60, bf6f20+8, bf3a00) and `xr2.tsv` (telemetry record bf63f0+248,
  74c95c, bf6f1c, bf6f08, c085dc, c081ec, c08250). Operand scan: `scan1.tsv`. Function lists: `lf_*.tsv`.
* Capstone helpers: `tools/nrdis.py` (disassembler on `/opt/nrmem`, with constant values), `tools/findcall.py`
  (every E8/E9 rel32 to a target, whole `.text`). Raw pointers: `recovery/stage9/tools/findptr.py`.
* Dynamic checks on the ORIGINAL code (Unicorn, Stage 12 harness `recovery/stage12/orig_stage12.py`, run with
  `python3 -B`, so nothing was written under `/home/user/nrport`):
  `dyn/dyn_ffb.py` (00554d30 patched to RET, compared with an unpatched run), `dyn/dyn_ffb2.py` (FFB block enabled,
  compared with the bench default), `dyn/dyn_ffb3x.py` (bit-exact formula model), `dyn/dyn_ffb4.py` (identity of the
  0055e180 parameters). Outputs are in `dyn/out*.txt`.

Nothing under `/home/user/nrport` was modified.

---------------------------------------------------------------------------------------------------------------------

## 1. Short answer

* **The original FFB reads no steering-chain cell.** None of `00554d30`, the FFB block of `00554520`, `005d08d0`
  or `00550070` reads `bf63c0`, `bf6360/64`, `bf63c8`, `bf6e80/88`, the hub states 15/16/21/22, or the yaw rate.
  The only physics input is a set of **front-tyre force statistics**. The JIT tyre callback of the two front wheels
  (`0055e180` → `00554e70`) accumulates them twice per tick (predictor and corrector passes) into
  `bf6ed4..bf6ef0` and `74c964/68`, as follows:
  * `A` = `c085dc`: the tyre's relaxed lateral-slip state, `fVar14` of `0054cab0`.
  * `B` = |Fz| + 0.01: the tyre normal load.
  * `C` = Fy: the tyre lateral force.
  * `D` = 0.1·(r×F)z + `c081ec`: the contact-force moment about the wheel centre in the frame of the
    T+0x309 rotation register, plus the tyre aligning moment of `0054cab0`.
* Each tick, `00554d30` turns the accumulators into three values: `bf6ec4` (load-weighted mean of the front
  slip states), `bf6ec8` (sum of the mean front Fy) and `bf6ed0` (sum of the mean front moments). It also writes
  `74c960` (mean front loads, clamped to 1500). Then it clears the accumulators.
* Once per 36 Hz frame, the FFB block of `00554520` runs. It is gated by `bf6ebb` (FF device acquired) and
  `bf6eb8 == 0` (controls not suspended), and it computes:
  * `d = (ec4 − ec0)·rate` (rate = 36)
  * `q = ec4 + d·lat·0.001·v/(v+20)`
  * `m = ed0·q/ec4` (just `ed0` when |ec4| ≤ 1e‑5)
  * `ecc = (m − damp·d + ecc)·0.5`
  * `out = clamp(ecc·strength/(ratio·1600), −1, 1)` → `005d08d0(dev, out)` → DirectInput constant force
    `trunc(out·10000)`.

  `v` = airspeed `bf3a00`, ratio = raw setup item 0x30, and `lat` / `damp` / `strength` = the FFLatency /
  FFDamping / FFStrength options.
* **No output feeds back into the physics or the steering chain.**
  * `74c960` and `bf6ec8` have no reader in the image.
  * `bf6ec4` and `bf6ed0` are read only by the FFB block. `bf6ed0` is also copied into the telemetry record
    (`bf643e`, data logging only).
  * `bf6ec0` and `bf6ecc` are FFB-private.
  * `005d08d0` writes only to the device.

  Dynamic proof on the original code: with `00554d30` disabled (RET), the whole window `0x6e9000..0xf80000` stays
  bit-identical for 8640 / 8064 / 6912 / 5184 ticks (`slalom`, `brakesteer`, `keys`, `yawlimit`), except the
  14 FFB dwords. With the FFB block enabled (latency 50, damping 0.5), the window stays bit-identical except
  `bf6ec0` / `bf6ecc` and the option cells written by the test.
* **One output of the "FFB setup" path does gate the steering chain.** `00550070(flag)` writes
  **`bf6eb8`**, which is the "player controls suspended" flag. `005524f0` @`00552549` tests it, and when it is
  non-zero it takes the not-driven branch (`bf63c8 = 0`, steering states zeroed). This is input-session state,
  not FFB arithmetic.
* **`00554d30` does not need to run for the steering chain to be exact.** Nothing in `005539c0` (apart from the
  telemetry copy `bf643e = bf6ed0·0.0254`, gated by `bf63d8`), `00551e80`, `00552720`, `005524f0`, `00552d00`,
  `00552410`, `00554fb0` or `00550230` reads what it writes. It is a leaf function: no calls, the x87 stack is
  balanced, and the control word is unchanged. It is required only for FFB, which needs `bf6ec4` and `bf6ed0`.

---------------------------------------------------------------------------------------------------------------------

## 2. Data flow (verified addresses)

```
per tyre pass (2 / tick: e843fc=1 predictor, e843fc=0 corrector), front wheels only (0055d9c0 @0055e110 cmp esi,2)
  0054cab0 (tyre native, this = T(w) = bf3a20 + w*0xa39, w = T+0x6c: 0 LF, 1 RF)
      c08250 = T+0x6c (w)                                  @0054cb09
      c085dc = fVar14 (relaxed lateral slip state)         @0054d166   (0 when unloaded @0054d3bc)
      c081ec = tyre aligning moment expression             @0054d19c   (0 when unloaded @0054d3c6)
      outputs *param_2 = Fx (T+0x2d8), *param_3 = Fy (T+0x2dc), *param_4 = Fz (T+0x2e0)
  JIT -> 0055e180(p = [Fy (rec c083a4), Fz (rec c082b4), (r x F).z (rec c0861c)])
      -> 00554e70(i = c08250, a = c085dc, b = |Fz| + 0.01, c = Fy, d = 0.1*(rxF).z + c081ec)
           ed4[i] += a ; 74c964[i] += 1 ; edc[i] += b ; ee4[i] += c ; eec[i] += d
per tick, 005539c0 @00553a64 (after bf63c0 += bf6e88, before bf6360 = bf63c0 - c086b0)
  00554d30: 74c960, bf6ec4, bf6ec8, bf6ed0 <- accumulators ; accumulators, counters <- 0
  (005539c0 @00553ca7, only if bf63d8 telemetry: bf643e = bf6ed0 * 0.0254 -> 005548d0 channel 1, 0x4c bytes @bf63f6)
per 36 Hz frame, 00554520 frame end @0055464c..00554775 (bf6ebb != 0 && bf6eb8 == 0)
  bf6ec0, bf6ecc state ; reads bf6ec4, bf6ed0, bf3a00, bf6f20, bf6f24, 74c9a4, setup item 0x30 (c05680)
  -> 005d08d0(bf6ebc, out) -> 005d2260 -> 005d3010: IDirectInputEffect::SetParameters (constant force)
```

---------------------------------------------------------------------------------------------------------------------

## 3. Producers: `0055e180` / `00554e70` (already in the Luau port as JIT natives)

### 3.1 Where they are emitted

The tyre-callback builder is `0055d9c0(w)` (`recovery/stage10/evidence/b1/0055d9c0.c`). Its tail is at
`0055e110..0055e13d`:

```
0055e110 cmp esi, 2 ; jge 0055e140                  ; front wheels only (pseudo-C: if (param_1 < 2))
0055e115 push 0xc083a4 ; call 0057cba0              ; arg p[0]
0055e11f push 0xc082b4 ; call 0057cba0              ; arg p[1]
0055e129 push 0xc0861c ; call 0057cba0              ; arg p[2]
0055e133 push 0x55e180 ; call 0057cc10              ; native call
```

The records come from the same builder:
* `c083a4` and `c082b4` are outputs 3 and 4 of the tyre native `(&PTR_LAB_0074df10)[w]` = `0055d880/8d0/920/970`.
  These wrappers call `0054cab0` with ECX = `bf3a20`, and the param block's first 4 entries are the output
  pointers: param_1..4 = `c081e4`, `c08684`, `c083a4`, `c082b4`.
* The force vector is `c085cc = c08684·c085b0 + c083a4·c083c8 + c082b4·c08628`, that is longitudinal, lateral
  and normal directions.
* `c0861c` is the third component of `c08614 = c08670 × c08608` (`005b7e90` = cross product). Here `c08670` is
  the contact offset and `c08608` the contact force, both transformed by `005b87c0` with the rotation register
  `T+0x309`.

The Luau JIT (`PATCH_STAGE6_7.lua:16856`) confirms that `p[2]` is a cross-product component:
`f1 = rf(8210280)*rf(8207500) − rf(8210484)*rf(8207496); wfd(8210280, f1); p1 = ru(8210280)`.

**Dynamic identity check** (`dyn/dyn_ffb4.py`, slalom, 200 frames, hook at `0055e180`): 6400 calls.
* `w` = 0 for 3200 calls and 1 for 3200 calls.
* `e843fc` = 1 for 3200 calls and 0 for 3200 calls, so it runs in both passes, twice per tick per front wheel.
* `p[0] == T(w)+0x2dc` (Fy) in 6400/6400 calls.
* `p[1] == T(w)+0x2e0` (Fz) in 6400/6400 calls.

`p[0]` equals Fx in only 96 calls (coincidences, at 0).

### 3.2 `0055e180` (asm `recovery/vehicle_core/0055e180.asm`)

```
FLD [p+4] ; FSTP [arg] ; EAX = [arg] & 0x7fffffff         ; |p[1]|  (|Fz|)
FLD [p+8] ; FMUL [006ea4cc]=0.1 ; FADD [c081ec] -> push   ; d = 0.1*p[2] + c081ec
FLD |p[1]| ; FADD [006ea4a4]=0.01 -> push                 ; b = |Fz| + 0.01
push p[0] (c) ; push [c085dc] (a) ; push [c08250] (i) ; call 00554e70
```

### 3.3 `00554e70(i, a, b, c, d)` (capstone, `tools/nrdis.py 554e70`)

```
00554e78 fadd [eax*4+0xbf6ed4] / 00554e8e fstp [eax*4+0xbf6ed4]     ; A[i] += a
00554e7f mov ecx,[eax*4+0x74c964] ; inc ecx ; mov [..],ecx           ; n[i]  += 1
00554e99/ea0 bf6edc[i] += b ; 00554eab/eb2 bf6ee4[i] += c ; 00554ebd/ec4 bf6eec[i] += d
```

Arrays (slot 0 = LF, slot 1 = RF):

| array | slot 0 (LF) | slot 1 (RF) |
|---|---|---|
| `n` | `74c964` | `74c968` |
| `A` | `bf6ed4` | `bf6ed8` |
| `B` | `bf6edc` | `bf6ee0` |
| `C` | `bf6ee4` | `bf6ee8` |
| `D` | `bf6eec` | `bf6ef0` |

w = T+0x6c: `00550bc0` calls `0054c1c0(this = bf3a20 + w·0xa39, w, …)`, and `0054c1c0` writes
`param_1_00[0x1b]` (+0x6c) = w. STAGE11_STATE_MAP gives w = 0 LF, 1 RF, 2 LR, 3 RR.

### 3.4 What `c085dc` and `c081ec` are (`0054cab0`, `recovery/stage8/evidence/0054cab0.c`)

`fVar14 = (T+0x2e8 − c08620·T+0x2cc)·k + c08620`.
* `T+0x2e8` = −param_6 (lateral contact velocity).
* `T+0x2cc` = |param_8|.
* `k` is a protected constant.
* `c08620 ← fVar14` only when `e843fc` is set.

So `fVar14` is a first-order relaxed lateral slip state. The `00554d30` output `bf6ec4` is its front, load-weighted
mean. Observed magnitudes: ~1e‑4..1e‑2 in normal driving, up to ~3.5 in a spin (yawlimit).

```
c081ec = (0.2/fVar1)·Fy·Fx + fVar13·fVar11·(p14 − fVar2·fVar3·0.8) + fVar20·fVar11·(p14 − (fVar3+1)·0.5·fVar2)
         p14 = sqrt(Fz·T+0x2a4)·0.5 + (Fx/fVar15)·0.2 + c082d4[w] + param_14 (JIT record c082ac)
```

This is the tyre aligning (pneumatic-trail) moment, with Fx·Fy coupling and per-wheel offsets. Its physical
meaning is inferred from its structure; the address facts are verified.

---------------------------------------------------------------------------------------------------------------------

## 4. `00554d30`: per-tick FFB statistics (validated bit-exact)

Call site: `005539c0 @00553a64`, after `00553a52 FLD [bf6e88] ; FADD [bf63c0] ; FSTP [bf63c0]` and before
`00553a69 FLD [bf63c0] ; FSUB [c086b0] … FSTP [bf6360]`. It is the only caller (`findcall.py`: one E8 at 00553a64).

### Inputs (all reads, capstone listing `tools/nrdis.py 554d30 13b`)

| address | meaning | read at |
|---|---|---|
| `74c964` / `74c968` | n_LF / n_RF: number of tyre passes accumulated (2 per tick; post-build image = 4) | 00554d31, 00554d59 / 00554d83, 00554d8c |
| `bf6ed4` / `bf6ed8` | Σ relaxed lateral slip state `c085dc`, LF / RF | 00554dfd / 00554de6 |
| `bf6edc` / `bf6ee0` | Σ (\|Fz\| + 0.01), LF / RF (N) | 00554d40, 00554d65, 00554da8 / 00554d3a, 00554da0 |
| `bf6ee4` / `bf6ee8` | Σ Fy, LF / RF (N) | 00554e19 / 00554e11 |
| `bf6eec` / `bf6ef0` | Σ (0.1·(r×F)z + Mz), LF / RF (N·m) | 00554e3d / 00554e35 |
| `006ea454`=0.0, `006e97d8`=1.0, `006f5878`=1500.0 | constants | |

### Computation

x87, CW `0x077f` (64-bit, round toward −∞); `[ESP]` holds an f32 local.

```
sx = B_LF + B_RF ; [ESP] = f32(sx)                              00554d3a..46
if n_LF >= 1 && sx > 0:  a = 1/n_LF ; l = f32(B_LF / f32(sx))   00554d59..6f
else:                    a = 0      ; l = 0                     00554d75..7b
b = (n_RF > 0) ? 1/n_RF : 0                                     00554d83..9a
74c960 = f32(B_RF*b + B_LF*a) ; if (that > 1500) 74c960 = 1500  00554da0..dc7
bf6ec4 = f32( ((1-l)*A_RF)*b + (A_LF*l)*a )                     00554dd1..e0b  (load-weighted mean slip state)
bf6ec8 = f32( C_RF*b + C_LF*a )                                 00554e11..e2f  (Σ mean front Fy)
bf6ed0 = f32( D_RF*b + D_LF*a )                                 00554e35..e5f  (Σ mean front moment)
74c964 = 74c968 = 0 ; bf6edc = bf6ee0 = bf6ee4 = bf6ee8 = bf6eec = bf6ef0 = bf6ed4 = bf6ed8 = 0
```

Note the asymmetry when `n_LF < 1` or `sx ≤ 0`: then `a = l = 0` and `ec4` becomes the RF mean alone. `74c960`
saturates in practice: front loads are about 4000 N per tyre, and `dyn` shows 1500 after the first frames.

### Writes

`74c960` (FST 00554db2, MOV 00554dc7), `74c964` (00554ddf), `74c968` (00554dec), `bf6ec4` (00554e0b),
`bf6ec8` (00554e2f), `bf6ed0` (00554e5f), and zeroes `bf6edc` (00554df1), `bf6ee0` (00554df6), `bf6ee4`
(00554e21), `bf6ee8` (00554e27), `bf6eec` (00554e45), `bf6ef0` (00554e4b), `bf6ed4` (00554e51), `bf6ed8`
(00554e59).

It has no calls. `PUSH ECX … POP ECX` balances the stack, two `FSTP ST0` leave the x87 stack empty, and there is
no FLDCW.

**Bit-exact validation** (`dyn/dyn_ffb3x.py`): an exact model in Python `Fraction`s, with every x87 result rounded
to a 64-bit mantissa toward −∞ and every FST dword rounded to f32 toward −∞, reproduces all four outputs and the
clears of 3200 / 3200 calls (slalom, 400 frames). A round-to-nearest double model fails in 2517 / 3200 calls by
1..few ulp, so the port needs the existing round-down arithmetic.

---------------------------------------------------------------------------------------------------------------------

## 5. FFB block of `00554520` (frame end, `0055464c..00554775`)

Gate: `0055464c MOV AL,[bf6ebb] ; TEST ; JZ 00554778` and `0055465b MOV AL,[bf6eb8] ; TEST ; JNZ 00554778`.
The block runs after `00551990` and after `0055455f MOV [bf3a00],EAX` (= car+0x5aa airspeed, written earlier in
the same function).

### Inputs

| address | meaning | read at |
|---|---|---|
| `005f7c50` taskGetRate | frame rate: 36 (`0x24`) if `[755a18]` ≠ 0, else `[7559b4]` | call 00554668 |
| `bf6ec4` | slip state, from `00554d30` | 00554671, 0055467b, 005546c3, 005546f1 |
| `bf6ec0` | previous `bf6ec4` (FFB state) | 00554681 |
| `bf3a00` | airspeed \|v − wind\| (car+0x5aa, m/s) | 00554699 |
| `006ecfc8` = 20.0, `006e97d8` = 1.0 | v/(v+20) | |
| `bf6f20` | **FF latency** (msg FFLatency, ms) | 005546b1 |
| `006ea67c` = 0.001 | ms → s | |
| `006ea480` = 1e‑5 | \|ec4\| threshold | 005546de |
| `bf6ed0` | Σ front moment, from `00554d30` | 005546f7, 005546ff |
| `bf6f24` | **FF damping** (msg FFDamping) | 00554705 |
| `bf6ecc` | filter state (FFB state) | 00554718 |
| `006ea44c` = 0.5 | | |
| `00557d60(0x30)` → `c05680` | **raw** setup item 0x30, steering ratio (active setup c055c0+0xc0) | 0055470f..00554733 |
| `006f5a44` = 1600.0 | | |
| `74c9a4` | **FF strength** (msg FFStrength; image 80.0) | 0055473b |
| `006ea4a8` = −1.0 | clamp | |
| `bf6ebc` | FF device index | 00554768 |

The ratio is the raw setup cell, **not** `00554fb0()`, so the low-speed override `74c9a0` does not apply to FFB.

### Computation (validated bit-exact, 400 / 400 frames, `dyn/dyn_ffb3x.py`)

```
d    = f32((ec4 − ec0)·rate)            ; ec0 = ec4                                00554677..00554695
q    = f32(ec4 + d·(lat·0.001)·(1 − 20/(v+20)))                                    00554699..005546c9
m    = (|ec4| > 1e-5) ? (q/ec4)·ed0 : ed0                                          005546cd..005546ff
ecc  = f32((m − damp·d + ecc)·0.5)       ; FST [ESP+0x10], FSTP [bf6ecc]           00554705..00554728
out  = f32(ecc · strength/(ratio·1600))                                            0055472e..00554745
out  = 1.0 if 1.0 < out ; −1.0 if out < −1.0                                       00554749..0055479d
005d08d0(bf6ebc, out)                                                              0055476e..00554770
```

Writes: `bf6ec0` (00554689) and `bf6ecc` (00554728) only, then the device call. `bf6ec0` and `bf6ecc` are reset to
0 by `00550530` @`005505b3` / `005505b8` (XOR EAX,EAX at 005505a0), the same reset that zeroes the steering states.

Timing: at the frame end, `ec4` and `ed0` hold the averages of tick 7 of the frame. Tick 8's passes are consumed by
the next frame's first `00554d30`. In the dyn runs `n` = 2 at every frame end.

Dynamic sample (slalom, defaults strength 80, ratio 18, latency 50, damping 0.5): `ecc` ≈ ±290 N·m in the
0.5 Hz, 0.08-amplitude slalom, giving `out` ≈ ±0.8. Saturation is at |ecc| ≥ 360 N·m (`dyn/out2_slalom.txt`).

---------------------------------------------------------------------------------------------------------------------

## 6. `005d08d0` and the device layer (host; no simulation memory written)

* `005d08d0(dev, force)`: if `[f5d4f0]` (DI layer up) and `[f5d414]` (FF device acquired, set by `005d0840`),
  it tail-jumps to `005d2260`. That function checks `[f5e844]`, maps the global device index through `005d2370`
  (on the device table `f5d508`, entries 0x262 bytes) and calls `005d3010(local index, force)`.
* `005d3010`:
  * Uses the effect at `obj+0x1e2+4·idx`.
  * Builds a `DIEFFECT` with dwSize 0x38, dwFlags 2 (DIEFF_OBJECTOFFSETS) and cbTypeSpecificParams 4, pointing
    to `{lMagnitude = _ftol(force·10000.0)}` (`006f5214` = 10000.0; `006c5018` = encrypted CRT `_ftol`, which
    truncates, per `recovery/stage6_7/orig_vehicle.py:31`).
  * Calls `IDirectInputEffect::SetParameters(…, 0x20000100)` = DIEP_TYPESPECIFICPARAMS | DIEP_START.
  * The effect is created in `005d2bb0` with `CreateEffect(GUID_ConstantForce {13541C20-8E33-11D0-9AD0-00A0C9A06E35}
    @006fb590, …)` (vtable +0x48), DIEFF_CARTESIAN|OBJECTOFFSETS (0x12), 1 axis, duration −1, gain 10000.
    Autocenter is turned off first (SetProperty(9 = DIPROP_AUTOCENTER, DIPROPDWORD 0)), followed by
    Acquire, Download and Start(1,0).
* `005d08a0(dev, offset, coef1, coef2)` → `005d2210` → `005d2ee0` sets two condition effects:
  * `+0x162`: lOffset = offset·10000, lPos = lNeg = coef1·10000, gain 10000, flags 0x20000104.
  * `+0x1a2`: lOffset 0, lPos = lNeg = coef2·10000.

  Their creators and GUIDs are not in the FFB acquire path (unresolved).
  `00550030` calls `005d08a0(dev, 0, 0, 0.75)` and then `005d08d0(dev, 0.0)`.
* `005d0910` / `005d0930` (from `0055c4b0`, `0055c750`, `00437260`) Stop / Start all effects (+0x162/+0x1a2/+0x1e2/
  +0x222). They carry no simulation data.
* The axis sign `74c95c = (axis string after the digits == '>') ? −1 : +1` is written by `0054fed0` @`0054ff74`
  and **never read**: findptr finds only that write. The constant force is not sign-corrected by the binding
  direction.

---------------------------------------------------------------------------------------------------------------------

## 7. `00550070(flag)`: FFB setup and the controls gate

```
00550075 test bl,bl ; jnz ; call 0054fed0         ; flag == 0: (re)configure the FF device
0055007e if (bf6ebb && flag) 00550030(0,0)         ; suspend: zero constant force + condition effects
00550097 mov byte [bf6eb8], bl                    ; bf6eb8 = flag
```

`0054fed0` reads the binding of **control 7** (steer left) through `0057b1e0(…, 7)` → `0057aff0` (not analysed).
If the binding is an axis (type 1), it does the following:
* sets `bf6ebc` = its device index;
* releases the device (`00550060` → `005d0870`, `bf6ebb = 0`) if FF is disabled (`bf6f1c`, through `00550280`) or
  the device changed;
* acquires it (`00550000` → `005d0840` → `005d2170` → `005d2bb0`, then `00550030`, `bf6ebb = 1`) if `bf6f1c` is set
  and `005d0820(dev)` reports FF support.

If control 7 is not an axis, the device is released.

So **the FF device is the device of the steer-left axis binding**, which is the same control table the Stage 12
device layer reads.

**`bf6eb8`** ("player controls suspended"):

Readers:
* `005524f0 @00552549 CMP byte [bf6eb8],BL ; JNZ 0055269a`: the player branch requires `bf6eb8 == 0`. Otherwise
  `0055269a..00552715` zero `bf63c8 bf6f14 74c98c bf6388 bf6e84 bf63bc bf638c bf6390`, set `bf6eac = 1.0`,
  `bf6eb0 = 0`, and clear `bf6e20..22`.
* `00554520 @0055465b`: the FFB gate.

Writers:
* `00550490 @00550501`: 1 at session/car init. It also sets `bf6ebb = 0` (005504c4) and calls `0054fed0`.
* `00550070 @00550097`. Its callers are:
  * `00550930 @005509dc`, `00550a50 @00550b07`, `00550b30 @00550b9e`: `(0)`, after car placement `005512f0`.
  * `00550a10 @00550a12`: `(1)`, followed by the `00550530` reset.
  * `0057ab00 @0057ab0e`: `(0)` when flags & 3.
  * `0057ab90 @0057ab9c`: `(1)` when flags & 1 (input-manager entry points; their callers were not traced).

The Stage 12 harness bypasses this gate: it calls `00552720` directly and uses `driver=false` for the not-driven
branch. Release at session end: `00550680` (from `00572cb0`, `00573bc0`).

---------------------------------------------------------------------------------------------------------------------

## 8. FFB options (message table `752540`, names `005baabc..`, mailbox ids `0056f7b2..`)

| msg idx (id) | name (`752ad8..`) | thunk → setter | cell | image value | front end (`0043f1d0` controls.cfg) |
|---|---|---|---|---|---|
| 8 (0x42) | fgmsgCarSetForceFeedbackOnOff | `005bb010` → `00550270` | `bf6f1c` (byte) | 0 | `00570e00(byte [894d80])` |
| 9 (0x43) | fgmsgCarSetFFStrength | `005bb020` → `00550290` | `74c9a4` (f32) | 80.0 | `00570e30(float(int [894de0]))` → also `72c5ec` (image 50) |
| 10 (0x44) | fgmsgCarSetFFDamping | `005bb030` → `005502d0` | `bf6f24` (f32) | 0.0 | `00570e60(float(int [894dac]))` |
| 11 (0x45) | fgmsgCarSetFFLatency | `005bb040` → `005502b0` | `bf6f20` (f32) | 0.0 | `00570e90(float(int [894d78]))` |

How the mapping was established:
* Table entry `752540 + 8·idx` = (flags, thunk): idx 8..11 = `5bb010/020/030/040`.
* The name getters `005baabc/ac2/ac8/ace` return `752ad8/af8/b10/b28` in the same order.
* The mailbox ids are id = 0x3a + idx: `0056f7b2` registers c6f70c → 0x42, c691ac → 0x43, c69034 → 0x44,
  c6a40c → 0x45.
* Cross-check: linearity sender `00570f20` uses mailbox c70b2c → id 0x48 = idx 14 → `005bb070` → `005502f0`
  (the known linearity setter).
* The getters `005502a0/c0/e0` have no caller and no pointer in the image.
* Without a controls.cfg, the sim keeps the image values: FF off, strength 80, damping 0, latency 0.
* UI strings: `chkForceFeedback`, `sliFFStrength`, `sliFFDamping`.

---------------------------------------------------------------------------------------------------------------------

## 9. Reader / writer census of every cell written (Ghidra xrefs `xr1.tsv`, operand scan, findptr on the whole image)

| cell | writers | readers | feeds physics / steering? |
|---|---|---|---|
| `74c960` | 00554d30 (00554db2, 00554dc7) | **none** (findptr: only those 2 sites) | no |
| `74c964/68` | 00554d30 (clear), 00554e70 (++) | 00554d30, 00554e70 | no (FFB accumulator) |
| `bf6ec4` | 00554d30 @00554e0b | 00554520 FFB block only | no |
| `bf6ec8` | 00554d30 @00554e2f | **none** (findptr: 00554e31 only) | no |
| `bf6ed0` | 00554d30 @00554e5f | 00554520 FFB block; 005539c0 @00553ca7 → `bf643e` (telemetry, gated by `bf63d8`) | no |
| `bf6ed4..bf6ef0` | 00554e70 (+=), 00554d30 (clear) | 00554e70, 00554d30 | no |
| `bf643e` | 005539c0 @00553cee | 005548d0 (`005b0980(1, 0x4c, &bf63f6)` telemetry channel; gated by `bf63d8`) | no (not in the 9-dword solver input block `bf6360..bf6380` copied by `005b2b90`) |
| `bf6ec0`, `bf6ecc` | 00554520 FFB, 00550530 (reset) | 00554520 FFB | no |
| `bf6eb8` | 00550070, 00550490 | **005524f0** @00552549, 00554520 | **yes**: player-branch gate |
| `bf6ebb` | 0054fed0, 00550490, 00550680 | 00554520, 00550070, 0054fed0, 00550680 | no (FFB gate) |
| `bf6ebc` | 0054fed0 | 00554520, 00550000/30/60, 0054fed0 | no |
| `74c95c` | 0054fed0 | **none** | no |

---------------------------------------------------------------------------------------------------------------------

## 10. Dynamic proof on the original code (Unicorn, Stage 12 harness)

`dyn/dyn_ffb.py`: two machines run in lockstep, A unmodified and B with `00554d30` = RET (block cache flushed).
After every frame the whole `0x6e9000..0xf80000` window is compared.

| scenario | ticks | differing dwords | which |
|---|---|---|---|
| slalom | 8640 | 14 | `74c960 74c964 74c968 bf6ec4 bf6ec8 bf6ed0 bf6ed4 bf6ed8 bf6edc bf6ee0 bf6ee4 bf6ee8 bf6eec bf6ef0` |
| brakesteer | 8064 | 14 | same |
| keys | 6912 | 14 | same |
| yawlimit | 5184 | 14 | same |

The steering cells (`bf63c0 bf63c8 bf6360 bf6364 bf6e80 bf6e88`), the yaw rate `bf6d70` and every other cell of
the window are identical at every frame. In B the counters grow to e.g. 0x4384 and the sums to ~7e7, with no effect.

`dyn/dyn_ffb2.py`: A is the bench default; B has `bf6ebb = 1`, `bf6eb8 = 0`, latency 50 and damping 0.5. 1080
(slalom) and 1008 (brakesteer) FFB calls; the only differing dwords are `bf6ec0`, `bf6ecc` and the option bytes
written by the test (`bf6eb8` dword, `bf6f20`, `bf6f24`).

---------------------------------------------------------------------------------------------------------------------

## 11. What Stage 13 needs from the Stage 12 steering chain

1. **No steering-chain state is an FFB input.** The original torque is built from front-tyre forces, so what
   Stage 13 needs from Stage 12 is the physics those forces come from: the steered hub states drive the front
   contact frames. The accumulation itself is already ported (JIT `XF[0x55e180]` → `XF[0x554e70]`). The
   accumulator cells exist in the Luau image with the original post-build values `74c964 = 74c968 = 4`,
   `bf6edc = bf6ee0 = 0.03` (3 build passes with no load), `74c960 = 1500`, and the rest 0.
2. **The per-tick slot of `00554d30` in `005539c0`** (@00553a64; independent of the surrounding steering
   arithmetic). It must run every tick, before the tick's tyre passes, to give `n = 2` averages.
3. **Setup item 0x30 (raw ratio cell `c05680`)**: the same cell `00554fb0` reads, but without the low-speed
   override.
4. **`bf6eb8`, the controls-suspended flag**, shared with the `005524f0` player-branch gate. It must be one state
   in the port.
5. **The FF device binding = the control-7 (steer left) axis binding** of the Stage 12 device layer
   (`0054fed0`).
6. **Frame-end inputs already in the port (Stage 11)**: `bf3a00` airspeed (`0055455f`), taskGetRate = 36. Also
   the `00550530` reset, which zeroes `bf6ec0` / `bf6ecc` together with the steering states.
7. **Options**: `74c9a4` (strength), `bf6f24` (damping), `bf6f20` (latency), `bf6f1c` (on/off). These are
   messages 9/10/11/8, int values from controls.cfg passed as floats.
8. **Arithmetic**: x87 64-bit with RC = down, f32 stores rounded down. A round-to-nearest double model is off by
   1..few ulp in about 80% of calls; the exact model matches 100%.

---------------------------------------------------------------------------------------------------------------------

## 12. Verified vs inferred vs unresolved

**Verified**
* All formulas: static asm plus the bit-exact dynamic model.
* Every reader and writer: Ghidra xrefs, operand scan, and findptr over the whole image.
* Which `0055e180` parameter is Fy and which is Fz (dynamic).
* LF/RF slot mapping and 2 passes per tick (dynamic).
* No physics or steering effect of `00554d30` or of the FFB block (dynamic, whole window).
* `bf6eb8` gating `005524f0`.
* Option message mapping (table, names, mailbox ids, linearity cross-check).
* GUID_ConstantForce.

**Inferred**
* `c085dc` (`fVar14`) is a relaxed lateral slip / deflection state. It is verified as the `fVar14` value of
  `0054cab0`; the physical meaning is read from its structure.
* `c081ec` is the tyre pneumatic-trail aligning moment.
* `c0861c` is the contact-force moment about the hub (steering) z-axis. It is verified as the z of
  `c08670 × c08608` in the `T+0x309` register frame; that this frame is the hub frame is inferred.
* `74c960` is the total front load.
* `bf6f20` / `bf6f24` units: ms and N·m·s per unit slip rate.
* The meaning of `0057ab00` / `0057ab90` flags (input focus / menu).

**Unresolved**
* What creates the condition effects at `+0x162` / `+0x1a2` (GUIDs). They are set only by `00550030`
  (0, 0, 0.75).
* The internals of `0057aff0` (control-7 binding query).
* The controls.cfg defaults of damping and latency (`894dac`, `894d78`) when the file has no value.
* The callers of `0057ab00` / `0057ab90`.
