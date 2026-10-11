# verify-input: adversarial check of the Stage 12 steering input port against the ORIGINAL x86

Label: `verify-input`. Scratch: `/opt/s12/work_verify-input/` (nothing under `/home/user/nrport` was modified).

Port under review (first pass at git HEAD `78390ce2`; re-checked at HEAD `bf4e1c6`, where both port files are
byte-identical to the first pass, same md5 below):

- `core/NR2003Cup/NR2003CupSteering.lua` (md5 `986151bd6a422e2d0262b6bdefc93b18`): `steerInput` (00552720),
  `linearity` (00552410), `assist` (00550230), `settingsBit25` (0055a770), `speed` (00554f50), `exp2`, `zadd`/`zsub`,
  `hostDevices`.
- `core/NR2003Cup/NR2003CupDriver.lua` (md5 `1fb0d5bfc7cb7a6e00cc18cfc3a45bab`) lines 67-89: `axis` = `V.axisOriginal`
  (00552d00).

Original evidence: `recovery/stage8/evidence/00552720.asm`, `recovery/stage8/evidence/00552d00.asm`,
`recovery/stage6_7/evidence/00552410.asm`, `/opt/s12/ev1/{00550230,0055a770,0055a680,00554f50,0057af30,0057af60,
005f7cd0,005f8890,005f8870,00544bf0,005524f0,00551e80}.asm`, memory image `/opt/nrmem`.

## Method

1. Instruction-by-instruction reading of the asm against the Luau, for every comparison (FCOM/FCOMP + FNSTSW + mask),
   every store, the x87-vs-f32 status of every value, the signed zero of each sum and difference under RC down, and the
   order of side effects.
2. Three-way differential on the same vectors. The vectors come from `gen_vec.py` (seed 12): 20034 records for
   00552720, 20000 for 00552d00 and 5000 for 00552410, plus targeted vectors from `gen_zero.py`:
   - **native**: `native` (from `native.c`). This 32-bit freestanding harness maps the `/opt/nrmem` image at its
     original addresses and executes the ORIGINAL code of 00552720, 00552d00 and 00552410 on this machine's real x87
     (`GenuineIntel`, "Intel(R) Xeon(R) Processor @ 2.10GHz") under CW `0x077f`.
   - **unicorn**: `uc_run.py`, the same image under Unicorn/QEMU. This is the same kind of reference the Stage 12
     fixtures were generated from.
   - **luau**: `snap/luau_run.luau` runs `V.steerInputOriginal`, `V.axisOriginal` and `V.steerLinearityOriginal` on a
     byte-identical snapshot of `core/` (`snap/core`).

   The comparison scripts are `compare.py`, `cat_I.py` and `show_zero.py`. Their outputs are in
   `cmp_native_vs_luau.txt`, `cmp_unicorn_vs_luau.txt`, `cat_native.txt`, `cat_unicorn.txt` and
   `targeted_native_unicorn_luau.txt`.
3. Exhaustive or large native scans of single sub-expressions, comparing the real x87 with the Luau double model
   (`p/scan.c`, `p/scan2.c`, `p/scan3.c`). Their outputs are in `scan1_native.txt`, `scan2_native.txt` and
   `scan3_native.txt`. Native and Unicorn probes of the x87 constants and FSIN are in `probe_native.txt` and
   `probe_unicorn.txt`.

The native harness itself was checked in two ways. On 79 % of the 00552720 records it agrees bit for bit with both
Luau and Unicorn. On the 00552d00 slew states, the 00554f50 cache cell `bf6f44` and the 00552410 value it agrees on
100 %, NaN bit patterns included (223 NaN results, all `7fc00000` in all three). Every disagreement is explained
below.

## Discrepancies

### D1 — FSIN at full lock: real x87 under RC-down gives 1 − 2⁻⁶⁴, the port (and Unicorn) give 1.0 (bit-exactness, systematic)

The asm at `00552dce` is `FMUL qword ptr [0x006f5a00]`, where K = 1.570796326793946 (5f1c4454fb21f93f), which is
9.5e-13 **below** π/2. It is followed by `00552dd4 FSIN`. In 00552720, `005527fd FSTP dword ptr [ESP+0x3c]` stores
`a8` to f32.

On real hardware with CW `0x077f`, FSIN honours RC. For v = 1.0 the exact value is 1 − 4.5e-25, so FSIN returns
`mant ffffffffffffffff se 3ffe` = 1 − 2⁻⁶⁴. The f32 store then rounds that down to **`3f7fffff`** (0.99999994). See
`probe_native.txt`, which also shows the same instruction under RN returning exactly 1.

The port evaluates `math.sin(1.0 * K)` in double with round-to-nearest, which gives 1.0, and `fd(1.0)` is
**`3f800000`**. The Luau lines are `NR2003CupDriver.lua:86` (`v = math.sin(v * rf64(0x6f5a00))`) and
`NR2003CupSteering.lua:119` (`local a8 = fd(axis(STEER_RIGHT))`).

Unicorn/QEMU computes FSIN with host doubles and returns 1.0 (`probe_unicorn.txt`). The project reference therefore
has the same deviation as the port, and the Stage 12 fixtures cannot detect it:

- `tests/stage12/fixtures/units.lua` contains 36 `axis` vectors whose final state is 1.0 with rate < 1. All of them
  expect `down = 3f800000`.
- The L1 00552720 test sets `74c990 = 1` (`run.luau:113`). That takes the no-slew, no-FSIN path.
- The `keySeq` vectors stop at a state of 0.66.

The `STAGE12_RECOVERY.md` §6 statement "Unicorn (QEMU) computes FSIN / F2XM1 with host doubles, the same model as the
port" is accurate, but that model is not the original hardware.

Scope, from the exhaustive scan `scan1_native.txt`: over every f32 v in [0, 1] (1,065,353,217 values), the stored
`a8 = f32RD(FSIN(v·K))` differs between real x87 and the port **only for v = 1.0**. Because v = 1.0 exactly is the
steady state of a held key, or of a full-lock analog axis, while `74c990 < 1` (image default 0.033), the effect is
frequent:

- **Right full lock** (control 8 state = 1.0): 00552720 returns one ulp less on hardware. Examples from
  `targeted_native_unicorn_luau.txt`:

  | Case | Hardware | Port and Unicorn |
  |---|---|---|
  | v 0, L 0 | `3f7fffff` | `3f800000` |
  | v 0, L 0.8 | `3f7ffffe` | `3f7fffff` |
  | v 30, L 0.8 | `3f74fa1f` | `3f74fa20` |
  | v 30, L 1.0 | `3f7238a7` | `3f7238a8` |

  This value goes to `bf63c8`, then the tail (`bf63c0`, ×π, ÷ ratio, the road-wheel target), and so to the whole
  physics state from the first full-lock frame on.
- **Both controls at full lock** (state7 = state8 = 1.0): `a8 = 3f7fffff` and `a7` stays x87 at 1 − 2⁻⁶⁴, so
  `00552808 FSUBR` gives −(2⁻²⁴ − 2⁻⁶⁴). The result is x = `b3800000` (L 0) or `b374fa20` (v 30, L 0.8), a tiny left
  steer. The port's `zsub(1, 1)` gives `80000000`.
- **Left full lock alone matches.** With `a8 = +0`, `−(1 − 2⁻⁶⁴)·sens` rounds down to exactly `−sens`, the same as the
  port. Examples are `bf800000`, `bf7fffff` and `bf74fa20` in all three implementations.

Random-vector totals, native against Luau, for the 00552720 return:

- 4281 of 20034 records differ.
- 4270 of them have final state8 = 1.0 with rate < 1.
- The remaining 11 are D3.
- 265 records have state8 = 1.0 and still match. In those, the difference is absorbed: 154 by the second
  `FSTP RD` of the bit-25 limiter multiply, 62 by a non-zero a7, and 49 have a NaN result.

On the same records Unicorn agrees with Luau except for 8 records of class D3. See `cat_native.txt` and
`cat_unicorn.txt`.

Caveats:

- Verified on this host's Intel Xeon only. Other x87 implementations, such as the AMD or Pentium 4 CPUs of the game's
  era, were not tested (**unresolved**).
- The CW `0x077f` of the simulation task is the inherited Stage 6/7 premise. I did not re-derive it.

### D2 — 00552d00 decrement to exactly zero gives −0 under RC down; the port gives +0 (bit-exactness, sign of zero)

The asm is:

```
00552dab FSUBR dword [ECX*4+0xbf639c]
00552db2 FCOM [ESP+4]
00552db6 FNSTSW
00552db8 TEST AH,5
00552dbb JP 00552dc3
00552dc3 FST dword [ECX*4+0xbf639c]
00552dce FMUL K
00552dd4 FSIN
```

When `prev == rate'`, where `rate' = rate·2.5` when raw < 0.025, `prev − rate'` is an exact zero. Under RC down that
zero is **−0**. The FCOM against raw = ±0 returns "equal" (C3 only, so `AH & 5 = 0`, PF = 1, and the JP keeps v). The
state cell is therefore stored as `80000000`, and FSIN(−0) returns −0.

The port computes `v = prev - rate` at `NR2003CupDriver.lua:79` without `zsub`, which gives +0. The state is stored as
`00000000` and the function returns +0. The increasing branch (`00552d95 FADD`, `NR2003CupDriver.lua:82`) would need
`prev = −rate'`, which is unreachable for a steering state of 0 or more.

Verified natively **and in Unicorn**. Softfloat honours RC for FSUB, so Unicorn reproduces the −0 as well. This means
it is also a discrepancy against the project's own reference; the 1200 fixture `axis` vectors simply contain no
−0 case. Evidence is in `targeted_native_unicorn_luau.txt`: for every rate in {0.151484847, 0.138861120, 0.0757424235,
0.25, 0.5}, for n = 7 and 8, and for raw = +0 and −0:

| | Return | State |
|---|---|---|
| Native | `80000000` | `80000000` |
| Unicorn | `−0` | `80000000` |
| Luau | `00000000` | `00000000` |

Effect at the 00552720 level:

- **Left control (a7 = −0 on hardware):** `00552808 FSUBR` gives `+0 − (−0) = +0`, so the original x = `00000000`
  while the port x = `80000000` (`NR2003CupSteering.lua:121`).
- **Right control:** the return matches (`80000000`), and only the `bf63a0` state sign differs.

Reachability: the default image rate (0.033f, `3d072b02`) cannot hit it, because 2.5·rate needs 25 significant bits.
Momentum settings where 2.5·rate is exactly representable can hit it. `zero_hit.py` simulates the f32-RD slew of a key
press followed by a release. With the rate model `f32RD(1/(m·0.01f)·0.016663333999866692)`, these momentum values m hit
an exact zero after a **5-frame key tap**: 11, 12, 13, 22, 24, 26, 27, 29, 31, 41, 44, 47, 48, 49, 52, 54, 58, 62, 65,
73, 82, 83, 88, 89, 94, 95, 96 and 98. For example, m = 11 gives rate 0.151484847; after 5 frames the state is 5·rate,
and two releases later `prev − 2.5·rate = 0` exactly.

Downstream, inferred and not executed:

- The −0 state lives for one frame. On the next frame, `prev = −0`, raw = 0, and v = raw.
- The sign of zero propagates into `bf63c8`, `bf63c0` (frame value), `bf63b8`, `bf6e80` and `bf6e88` for one or two
  frames.
- The road-wheel inputs `bf6360`/`bf6364` = `bf63c0` ∓ toe are unaffected while toe ≠ 0.

### D3 — x87 extended vs IEEE double low bits (bit-exactness, inherent to the Stage 6/7 "x87 in double" convention)

Not a porting mistake, but a real hardware difference that the port's convention cannot represent:

- **`a8 − a7` cancellation.** At `005527fd`/`00552808` (`NR2003CupSteering.lua:119-121`), when the two slew states are
  equal or adjacent, `x = f32RD(a8) − sin7` exposes the low bits of the x87 sine (64-bit mantissa) versus the double
  `math.sin`. Results are ~1e-8 to 1e-9 and differ by one f32 ulp: 11 of 20034 random records natively (for example
  `b3071e2f` against `b3071e2e`) and 8 in Unicorn. These are different records, because Unicorn differs from the
  hardware there too: record 7304 matches natively but not in Unicorn.
- **Sensitivity rounding.** At `005527dc..005527f4` (`NR2003CupSteering.lua:118`), for linearity L < ~3.7e-16 the
  x87 RD chain `(1 − a) + a·e` stores `3f7fffff` where the double model gives `3f800000`. This is unreachable through
  the setter `005502f0` and the UI (L = k·0.01f).
  - Over the realistic grid L = k·0.01, k = 0..100 (×f32 e in [0.001, 1), every 7th ulp, 1.2e9 samples each), there
    are 0 differences both without and with the 0.66 L + 0.34 remap (`scan3_native.txt`).
  - One remap sample differs at e = 1.0, which e never reaches because e ≤ `3f7fffff` for s ≥ 0.01.
- **Double-ulp differences in returned x87 values.** 00552d00 values differ by one double ulp in about 10 % of the
  records (`cmp_native_vs_luau.txt`). This is within the test tolerance of ≤ 4 ulp, and the stored f32 is unaffected
  except in D1.

### D5 — 00554f50 speed: x87 extended RD sum + FSQRT vs the double model (bit-exactness, rare; Unicorn agrees with the hardware)

Asm (`/opt/s12/ev1/00554f50.asm`):

```
00554f5d FLD [bf6d54]; 00554f63 FMUL [bf6d54]     ; vz*vz (exact, 48 bits)
00554f69 FLD [bf6d4c]; 00554f6f FMUL [bf6d4c]; 00554f75 FADDP   ; + vy*vy   (64-bit mantissa, RC down)
00554f77 FLD [bf6d44]; 00554f7d FMUL [bf6d44]; 00554f83 FADDP   ; + vx*vx   (64-bit mantissa, RC down)
00554f85 FSQRT                                       ; RC down
00554f87 FSTP dword [bf6f44]                          ; f32 RD
```

Luau: `NR2003CupSteering.lua:76` `local v = math.sqrt((vz * vz + vy * vy) + vx * vx)` then `wf32d(0xbf6f44, v)` (line 78);
the same expression is at `NR2003CupDriver.lua:95`.

When one velocity component is much smaller than another, the sum of squares needs more than 53 bits. The double
model rounds it to nearest, the x87 rounds it down. If the true speed lies just below an f32 value, within about
2^-54 relative, the double path rounds up onto that value and the RD store keeps it. The x87 path stays below it and
stores the next f32 down. The original is then one f32 ulp lower.

Verified by running the ORIGINAL code natively (`native I`, record format unchanged) on 200 constructed cases × 2
(bit 25 off and on). The scratch files are under `p2/`: `spd.c` is the search, `spd_cases.txt` holds the cases,
`mkvec.py` and `vS.bin` build the vectors, `natS_I.bin` is the native output, `snap/luau_runS.luau` and
`luS_out.txt` are the Luau run, and `cmpS.py` compares them. Results:

- `bf6f44` differs in **400 of 400** records. In every one the original stores 1 ulp (or 2) **below** the port.
  Example: vz = `42b26a6c` (89.2078552), vy = 0, vx = `3d55b73c` (0.0521767). The original stores `42b26a6d`; the
  port stores `42b26a6e`. In all 400 records the inline-asm replica in `spd.c` gives the same `bf6f44` as the
  original 00554f50.
- The 00552720 return differs in **20 of 400**. The speed feeds e = exp(K·s²), and with bit 25 also 12.25/s.
  Example: record 13, with vz = `3d050113`, vx = `428a343b`, bit 25 set, gives `3f0e05c0` native against
  `3f0e05bf` Luau.
- **Unicorn agrees with the hardware**: 0 of 400 records differ. Softfloat floatx80 honours RC for FADD and FSQRT.
  This is therefore a discrepancy against the project's own reference as well. The random fixture vectors do not
  reach it.

Frequency: it is rare. On realistic distributions the native-versus-double mismatch rate is about 1e-9 per call: 1 in
2e8 for uniform components (`spd.c`, "random speed") and 1 in 4e8 for near-axis motion with |vz| 5..90 and small
vx/vy (`spd2.c`). This is the same mechanism as D3: the Stage 6/7 "x87 intermediates in double" convention. Here it
shows on the cached speed `bf6f44`, which is also read by 00554fb0 (`ratio`, `NR2003CupSteering.lua:135`). Correction
of an earlier statement in this report: `bf6f44` was bit-identical on all *random* vectors, **not** universally.

### D4 — `hostDevices` binding type for keys is 0, while the original key bindings are 2 or 4 (cosmetic)

At `NR2003CupSteering.lua:173-174`, `kind = isDigital and 0 or 1`. The original device layer uses 1 for an axis and 2
or 4 for keys and buttons. In this chain the cell is read only by `0057af60`:

```
MOV ESI,[EAX+ECX*4+0xd37cc8]
CMP ESI,1
SETNZ
```

That test treats 0 exactly like 2 or 4, so there is no behavioural effect here. Any other reader of `d37cc8 + 29n`
would see a value the original never writes. `hostDevices` is an adapter in any case: the raw values bypass the
original 0057abc0 calibration.

## Matches (verified)

### 00552720 input part (`NR2003CupSteering.lua:104-131`)

- **Speed clamp.** `00552728 FLD 0.01`, `0055272e FCOMP` (ST0 = 0.01 against ST1 = v), `AND 0x4100`, `JNZ keep v`.
  This keeps v when 0.01 < v, 0.01 == v, or unordered, and otherwise uses the immediate `0x3c23d70a`, which is the
  same bits as `[006ea4a4]`. Luau line 107 matches.
- **Yaw.** `MOV`/`AND EAX,0x7fffffff` is a bit-level absolute value, matched by `abs(rf32(0xbf6d70))` (line 108). The
  same clamp with `FCOMP [ESP+0x20]` matches line 110.
- **s² and the exponential.** `FLD s; FMUL s` is exact in both precisions. The `FST [ESP+0x1c]` f32 copy of s² is used
  only by the aid branch. The exponential uses the order `(s²·K59fc)·FLDL2E`, then `FRNDINT` (RC down, so floor),
  `FSUB ST0,ST1`, `F2XM1`, `FLD1`, `FADDP`, `FSCALE` and `FSTP ST1`, and ends with `FSTP dword [ESP+0x38]`. Luau
  `exp2` plus `fd` (lines 62-68 and 112) matches. **Exhaustive check:** for all 128,198,903 f32 s in [0.01, 400] the
  stored e is identical on real x87 and in the Luau model (`scan1_native.txt`, scan2 e). This holds even though real
  `FLDL2E` under RC down loads mantissa `...f0bb` against the double's `...f0bc`. Unicorn ignores RC there and loads
  `...f0bc`.
- **Yaw limiter.** `FLD 12.25; FDIV s`. `FCOM` (q against f): `AND 0x4100` and `JNZ` keep q when q ≤ f or
  unordered; otherwise `FSTP ST0; FLD ST0` uses f. Then `FDIV ST0,ST1` (m/f), `FMUL 0.9f`, `FADD 0.1f` and
  `FSTP [ESP+0x34]`. Luau lines 113-116 match. There were 0 differences in 1e8 random native samples (`scan2_native.txt`).
- **Sensitivity.** `CALL 00552410` gives an x87 L, then `FMUL 0.15f`, `FLD 1`, `FSUB ST0,ST1` (1 − a), `FXCH`,
  `FMUL e`, `FADDP`, and `FSTP` to orig `ESP+0xc`, with the stack offsets checked across `PUSH 8` and `PUSH 7`. Luau
  lines 117-118 match, apart from D3. An exact zero would need a ≥ 1, which is unreachable for L ≤ 1.
- **Call order.** `005527e8 PUSH 8; CALL 00552d00` comes **before** `00552801 PUSH 7; CALL 00552d00`. `a8` is stored
  to f32 (`FSTP [ESP+0x3c]` = orig 0x38) and `a7` stays x87. Then `FSUBR [ESP+0x40]` (a8 − a7), `FMUL [ESP+0xc]` and
  `FSTP [ESP+0x20]`. Luau lines 119-121 match, with the same order of the two slew-state writes (`bf63a0`, then
  `bf639c`). `zsub` reproduces the RC-down signs of the zero difference for all four ±0 pairs.
- **Bit 25.** `CALL 0055a770; TEST AL,AL; JZ`, then `FLD x; FMUL [ESP+0x34]; FSTP` matches line 122.
- **Assist test.** `CALL 00550230; FCOMP [0.0]; AND 0x4100; JNZ 00552cee` (return x if aid ≤ 0 or NaN) matches lines
  123-124. `00552cee FLD dword [ESP+0x20]` returns the f32 matching line 130. 005524f0 then does
  `005525cd FSTP dword [bf63c8]`, matched by `wf32d` in `V._steerDevices`.
- **Device call order in 005524f0.** The order is brake 00553080, clutch 005534f0, `00552720`, throttle 00552df0. The
  car-held path (`bf6eb9`) still calls 00552720. `NR2003CupDriver.lua:250-267` follows the same order.

### 00552d00 (`NR2003CupDriver.lua:68-89`)

- **Jump table.** The table at `00552dd8` reads `[552d35, 552d41, 552d26, 552d2c]`. So n = 5 gives ECX = 2, EDX = 1;
  n = 6 gives ECX = 3, EDX = 2; n = 7 gives ECX = 0, EDX = 0; n = 8 gives ECX = 1, EDX = 0. `JA` returns raw for any
  other n. The Luau mapping is the same.
- **Rate test.** `FCOMP [1.0]` with `AND 0x100` and `JZ ret` returns raw when rate ≥ 1; NaN goes on. This matches line
  74.
- **Low-raw test.** `FCOMP [0.025]` with `TEST AH,5` and `JP` skips the 2.5 factor when raw ≥ 0.025 or unordered.
  This matches line 75; the cell `74c99c` is read on each call.
- **Branch.** `FCOMP [prev]` with `AND 0x4100` and `JNZ` takes the decreasing branch when raw ≤ prev or unordered,
  matching line 78. The clamps `TEST AH,5 / JP` (keep when v ≥ raw or unordered) and `AND 0x4100 / JNZ` (keep when
  v ≤ raw or unordered) match lines 80 and 83.
- **Stores.** `FST dword` of the state and the x87 return match line 85 (`wf32d`). FSIN is applied only when EDX = 0.
  All 20000 random vectors gave **bit-identical slew states** on native, Unicorn and Luau.

### Other functions

- **00552410 (`linearity`, lines 90-96).**
  - `CALL 0055a770; JNZ remap`; then `00550230`, `FCOMP 0`, `AND 0x4100`, `JZ remap` (remap only when aid > 0); and
    `FLD bf6f00; FMUL 0.66f; FADD 0.34f`.
  - The remap is exact in both double and extended for every L = k·0.01 (at most 52 significant bits) and for every
    L ≥ 2^-7. Arbitrary f32 L below about 2^-8 needs more than 53 bits, so double and extended can differ. Such an L
    is not reachable through `005502f0` or the UI. Checked with exact rationals (no file). All 5000 vectors were
    identical.
  - The tail's `005521ba FCOMP 0; TEST AH,0x44; JNP skip` matches `L ~= K_ZERO or L ~= L` (line 206).
- **00550230 (`assist`, lines 85-88).** Under inServer() = false and inBackground() = true it reads
  `0055a680` = `c0692a`, `TEST [EAX+0x4c],0x20000000`, then `FLD 0.0` or `FLD [bf6f08]`. The Luau is the same
  (see Unresolved for the thread premise).
- **0055a770 (`settingsBit25`).** `[c0692a+0x4c] >> 25 & 1` matches line 82.
- **00554f50 (`speed`, lines 74-80).** The order `vz², +vy², +vx²`, then `FSQRT`, `FSTP dword [bf6f44]` and
  `FLD [bf6f44]` matches the Luau in operation order, and `bf6f44` was bit-identical on all random vectors. Constructed near-axis
  cases differ in the last bit; see D5. The cache tag (`74c9ac` against
  `getIntCount` `[7559c4]`) is not modelled; this is equivalent under the project's "+1 per frame" counter convention.
- **0057af30 / 0057af60.** These read `[d35b18 + 10n]` (f32) and `[d37cc8 + 29n] != 1`, matching `CTRL_RAW + 10n`
  and `digital()` (line 98).
- **`zadd`/`zsub`.** They return −0 for every exact-zero sum except +0 + +0. This equals IEEE roundTowardNegative,
  checked case by case for (±0, ±0) and for x − x.
- **`exp2`.** It handles NaN, ±inf and the truncation toward zero of FSCALE like the x87, and gives the same stored f32
  as the hardware for the whole domain in use (above).
- **`hostDevices` (lines 162-175).** One axis splits into control 7 = −x (x < 0) and control 8 = x (x > 0), and is
  clamped. This is consistent with the recovered 0057abc0 sign rule. The binding cells are written before
  `steerInput` reads them.

## Unresolved / assumptions not re-verified here

- **FSIN on other CPUs.** D1 is shown on this Intel Xeon only. Behaviour on AMD or period-correct x87 hardware is not
  tested.
- **CW `0x077f`.** The control word of the simulation task is inherited from Stage 6/7 (0055cef0 → 00567704) and was
  not re-derived.
- **Thread identity in 00550230.**
  - If 005f8890 ("server thread") were true on the simulation thread, the aids-off bit would be read from `bebd38+0x4c`
    (00544bf0) instead of `c0692a+0x4c`.
  - If neither thread matched, `bf6f08` would be returned unconditionally.
  - The port assumes the background-thread case. This is moot while `bf6f08 = 0`, which is the production value since
    assist > 0 is refused.
- **Speed cache (00554f50) in the real game.** The game uses the timer count `7559c4` as its key. If two simulation
  frames ran within one count, or a draw-thread call to 00554fb0 (005662d0 / 00565cc0) refreshed the cache mid-frame,
  the original would use a stale `bf6f44`. The port always recomputes. The project models the count as +1 per frame;
  the real timer behaviour is not established.
- **Downstream effect of D1 and D2.** The effect past 00552720 (tail, per-tick composition) is inferred from the code
  and was not executed natively end to end.

## Reproduction

```
cd /opt/s12/work_verify-input
./native I vI.bin nat_I.bin; ./native A vA.bin nat_A.bin; ./native L vL.bin nat_L.bin     # real x87, original code
python3 -B uc_run.py I vI.bin uc_I.bin   # (also A, L) Unicorn reference
(cd snap && /opt/tools/luau/luau -O2 luau_run.luau > ../lu_out.txt)                     # Luau port
python3 -B compare.py nat; python3 -B compare.py uc; python3 -B cat_I.py nat
python3 -B gen_zero.py && ./native I vZI.bin natZ_I.bin && ./native A vZA.bin natZ_A.bin \
  && (cd snap && /opt/tools/luau/luau -O2 luau_runZ.luau > ../luZ_out.txt) && python3 -B show_zero.py
p/probe; p/scan; p/scan2; p/scan3; python3 -B x87probe.py; python3 -B zero_hit.py
(cd p2 && gcc -O2 -o spd spd.c -lm && ./spd && python3 -I mkvec.py) && ./native I p2/vS.bin p2/natS_I.bin \
  && (cd snap && /opt/tools/luau/luau -O2 luau_runS.luau > ../p2/luS_out.txt) && (cd p2 && python3 -I cmpS.py) \
  && python3 -B uc_run.py I p2/vS.bin p2/ucS_I.bin; (cd p2 && gcc -O2 -o spd2 spd2.c -lm && ./spd2)   # D5
```
