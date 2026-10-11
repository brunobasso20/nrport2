# FFB interface of the original steering chain: what Stage 13 needs (label: ffbinterface, revision 2)

Scope: `00554d30` (per-tick FFB statistics), the force-feedback block of the frame end `00554520`, `005d08d0`
(device output) and `00550070` (FFB setup / controls gate), plus their producers and consumers. This is an
investigation for Stage 13. It does not propose an implementation.

Revision 2 continues revision 1 (same label). It re-verifies the core claims independently, corrects one claim
(`bf6ebc` is a global **axis** index, not a device index) and resolves the four items left open in revision 1. The
changes are listed in section 0.

Evidence (all under `/opt/s12/work_ffbinterface/`; Ghidra project `/opt/nrproj_4`, read-only):
* Revision 1:
  * `ev1/`, `ev2/`, `ev3/`: Ghidra pseudo-C/asm exports with `index.tsv`.
  * `xr1.tsv`, `xr2.tsv`: data xrefs.
  * `scan1.tsv`, `lf_*.tsv`.
  * `dyn/`: Unicorn runs of the ORIGINAL code through the Stage 12 harness, with outputs in `dyn/out*.txt`.
  * `tools/nrdis.py` (capstone on `/opt/nrmem`, constants annotated) and `tools/findcall.py` (every E8/E9 to a
    target).
* Revision 2 (`v2/`):
  * `rawscan.py` + `raw_ffb.txt`: every raw 32-bit value in every initialised block of the image that falls in
    `74c958..74c9b0` or `bf6eb0..bf6f30`.
  * `census.txt`: raw hits per cell, mapped to the containing function, next to the Ghidra xref count.
  * `allfuncs.tsv`: the full Ghidra function list of `.text`.
  * `xr.tsv`, `xr_ui.tsv`: fresh xrefs.
  * `scan_eff.tsv`: an operand scan for the DirectInput effect slots `+0x162/+0x1a2/+0x1e2/+0x222`.
  * `ev/`, `ev2/`: exports of `0057aff0`, `0057b1e0`, `0057ab00`, `0057ab90`, `005d2ee0`, `005d2bb0`, `005d0910/30`
    and `005baf80`.
  * `operands.txt`: every absolute operand and every call of each analysed routine.
  * `dis/*.txt`: capstone listings of all routines quoted here.
  * `rerun_slalom200.txt`: a re-run of the revision-1 dynamic proof.

Nothing under `/home/user/nrport` was modified: scripts only read it, and the harness ran with `python3 -B`.

---------------------------------------------------------------------------------------------------------------------

## 0. What changed in revision 2

**Re-verified independently (capstone):**
* the instruction-level semantics of `00554d30` and of the FFB block `0055464c..0055479d`;
* `00557d60` is `ret 4`, so the FFB output uses `ecc`, not `q` (see §5);
* the `DIEFFECT` layout in `005d3010`;
* the telemetry-only use of `bf6ed0`;
* the `bf6eb8` gate in `005524f0`.

**New census:** the raw-pointer count equals the Ghidra xref count for every cell written by the FFB code
(`v2/census.txt`). So there is no hidden table, pointer or protected-section reference.

**New gates:**
* The whole frame end, including the FFB block, is skipped unless `00551880()` (= byte `bf6e04`, "player vehicle
  simulated") is set: `0055452a je 00554778`.
* `00554d30` is called unconditionally on every tick that passes the same `bf6e04` gate in `005539c0`
  (`00553a28 jz 00553d67`).

**Correction:** `bf6ebc` holds `rec+0x14` of the control-7 binding record. For an axis binding this is a **global
axis number**. `005d2370` maps it to (device, local axis), and the constant force is created on that one axis
(`rgdwAxes = [dev+0xb2+4·axis]`). Revision 1 called it a device index.

**Resolved (open in revision 1):**
1. **Condition effects.** `+0x162`/`+0x1a2` are never created. `005d2bb0 @005d2cbf` is the only `CreateEffect`
   in the DirectInput module, and its target is `GUID_ConstantForce` → slot `+0x1e2`. `005d2ee0` therefore returns
   at its NULL check, and `00550030`'s `005d08a0(dev, 0, 0, 0.75)` has no effect.
2. **`0057aff0` internals.** The binding-record fields it returns are listed in §7.
3. **Callers of `0057ab00`/`0057ab90`:**
   * message 6 (id 0x40) `fgmsgSelectActiveControls`, handler `005baf80`;
   * the sim-task init `0055d0e0`, which calls `0057ab90(-1)`.
4. **controls.cfg defaults.** There is no code default: `0043f1d0` aborts on a short read. The front-end ranges
   are strength 0..100, damping 0..100 and latency 0..250 ms (§8).

---------------------------------------------------------------------------------------------------------------------

## 1. Short answer

* **The original FFB reads no steering-chain cell.** None of `00554d30`, the FFB block of `00554520`, `005d08d0`
  (+ `005d2260`/`005d3010`) or `00550070` (+ `00550030`/`0054fed0`) references any of these
  (`v2/operands.txt`, §2):
  * `bf63c0`, `bf6360/64`, `bf63c8`, `bf6e80/88`, `bf639c..a8`;
  * the options `bf6f00`, `bf6f08`, `74c990..a0`;
  * the hub states 15/16/21/22, the yaw rate `bf6d70`, or the cockpit cell `car+0x1554`.

  The only physics input is a set of **front-tyre force statistics**. The JIT tyre callback of the two front
  wheels (`0055e180` → `00554e70`) accumulates them twice per tick (predictor and corrector passes):
  * `A` = `c085dc`: the relaxed lateral-slip state (`fVar14` of `0054cab0`).
  * `B` = |Fz| + 0.01: the wheel load.
  * `C` = Fy: the lateral force.
  * `D` = 0.1·(r×F)z + `c081ec`: the contact-force moment about the wheel centre plus the tyre aligning moment.

  Per tick, `00554d30` produces:
  * `bf6ec4`: the load-weighted mean front slip state;
  * `bf6ec8`: Σ mean front Fy;
  * `bf6ed0`: Σ mean front moment;
  * `74c960`: Σ mean front load, clamped to 1500.

  It then clears the accumulators. Once per 36 Hz frame, the FFB block turns `bf6ec4`, `bf6ed0`, the airspeed
  `bf3a00` and the raw ratio setup item 0x30 into a constant force −1..1 on the steering axis.
* **No FFB output feeds back into the physics or the steering chain.**
  * `74c960` and `bf6ec8` have no reader.
  * `bf6ec4` and `bf6ed0` are read only by the FFB block. `bf6ed0` is also copied into the telemetry record
    `bf643e` when `bf63d8` is set; that record has no reader in the sim.
  * `bf6ec0` and `bf6ecc` are FFB-private.
  * `005d08d0` writes only DirectInput state (`f5d…`/device objects).

  Dynamic proof: with `00554d30` = RET, the whole window `0x6e9000..0xf80000` stays identical except the 14 FFB
  dwords, over 8640 / 8064 / 6912 / 5184 ticks (re-run in revision 2: 1600 ticks, same result).
* **One cell written by the "FFB setup" function does gate the steering chain: `bf6eb8`.** `00550070(flag)` stores
  `bf6eb8 = flag`. This is the "player controls suspended" flag. `005524f0 @00552549` takes the not-driven branch
  when it is set (`bf6e04`-gated path; `bf63c8 = 0` and the steering states are zeroed). It is an input-session
  state, not FFB arithmetic.
* **`00554d30` does not need to run for the steering chain to be exact.** Nothing in `005539c0` (apart from the
  `bf63d8`-gated telemetry copy), `00551e80`, `00552720`, `005524f0`, `00552d00`, `00552410`, `00554fb0` or
  `00550230` reads what it writes. It is a leaf (no calls). The x87 stack is empty at its call site and balanced
  inside it, and it executes no FLDCW. It is needed only for FFB.

---------------------------------------------------------------------------------------------------------------------

## 2. Every input and output, per routine (from `v2/operands.txt` and the listings in `v2/dis/`)

| routine | reads (sim data) | reads (constants / options / host) | writes | calls |
|---|---|---|---|---|
| `0055e180` (JIT native, front wheels only) | `p[0]`=Fy, `p[1]`=Fz, `p[2]`=(r×F)z (JIT records `c083a4`, `c082b4`, `c0861c`), `c085dc` slip state, `c081ec` aligning moment, `c08250` wheel index | `006ea4cc`=0.1, `006ea4a4`=0.01 | stack only | `00554e70` |
| `00554e70(i,a,b,c,d)` | accumulators | — | `bf6ed4[i]+=a`, `74c964[i]++`, `bf6edc[i]+=b`, `bf6ee4[i]+=c`, `bf6eec[i]+=d` | — |
| `00554d30` | `74c964/68` (n), `bf6ed4/d8` (ΣA), `bf6edc/e0` (ΣB), `bf6ee4/e8` (ΣC), `bf6eec/f0` (ΣD) | `006ea454`=0, `006e97d8`=1, `006f5878`=1500 | `74c960`, `bf6ec4`, `bf6ec8`, `bf6ed0`; clears `74c964 74c968 bf6ed4..bf6ef0` | none |
| FFB block `0055464c..0055479d` | `bf6ec4`, `bf6ed0`, `bf6ec0`, `bf6ecc`, `bf3a00` (airspeed), `c05680` (setup item 0x30 via `00557d60`, ECX `c055c0`) | `bf6ebb`, `bf6eb8` (gates), `bf6f20` latency, `bf6f24` damping, `74c9a4` strength, `bf6ebc` axis; `005f7c50` rate; `006ecfc8`=20, `006ea67c`=0.001, `006ea480`=1e‑5, `006ea44c`=0.5, `006f5a44`=1600, `006ea4a8`=−1 | `bf6ec0`, `bf6ecc` | `005f7c50`, `00557d60`, `005d08d0` |
| `005d08d0(axis, force)` | — | `f5d4f0` (DI up), `f5d414` (FF acquired) | — | tail `005d2260` → `005d2370`, `005d3010` |
| `005d3010(local axis, force)` | — | device object `+0xae` (axis count), `+0x1e2+4·axis` (effect), `006f5214`=10000 | DirectInput only (`SetParameters`) | `006c5018` (`_ftol`) |
| `00550070(flag)` | — | `bf6ebb` | **`bf6eb8 = flag`** | `0054fed0` (if flag = 0), `00550030` (if `bf6ebb` && flag) |
| `00550030` | — | `bf6ebc` | DirectInput only | `005d08a0(axis,0,0,0.75)` (no-op, §6), `005d08d0(axis,0.0)` |
| `0054fed0` | control-7 binding record `d37d83` (= `d37cb8+29·7`) via `0057b1e0` | `bf6ebb`, `bf6f1c` (via `00550280`) | `bf6ebc`, `bf6ebb`, `74c95c` | `0057b1e0`, `00550280`, `005d0820`, `005f79a0` (FG request of `00550000`/`00550060`), `00501b30` |

Physical meaning of the inputs:
* `bf3a00` is the airspeed |v − wind| (`car+0x5aa`), copied at `0055455f` earlier in the same frame end.
* `c05680` is the active setup's steering ratio as the raw cell (`c055c0+0xc0`). This is the same cell `00554fb0`
  reads, but the FFB block does not apply the low-speed override `74c9a0`.
* Wheel loads enter only through `B` (Σ|Fz| + 0.01), which is used as the LF/RF weighting of the slip state and as
  `74c960`.
* The **tyre aligning moment** enters only through `D` (`c081ec`), together with 0.1·(r×F)z.
* **No hub or steering angle or rate is read directly.** The steering acts on the FFB only through the front tyre
  forces it produces.

---------------------------------------------------------------------------------------------------------------------

## 3. Data flow (verified addresses)

```
per tyre pass (2 / tick: e843fc=1 predictor, e843fc=0 corrector), front wheels only (0055d9c0 @0055e110 cmp esi,2)
  0054cab0 (tyre native, this = T(w) = bf3a20 + w*0xa39, w = T+0x6c: 0 LF, 1 RF)
      c08250 = T+0x6c (w)                                  @0054cb09
      c085dc = fVar14 (relaxed lateral slip state)         @0054d166   (0 when unloaded @0054d3bc)
      c081ec = tyre aligning moment expression             @0054d19c   (0 when unloaded @0054d3c6)
      outputs *param_2 = Fx (T+0x2d8), *param_3 = Fy (T+0x2dc), *param_4 = Fz (T+0x2e0)
  JIT -> 0055e180(p = [Fy (rec c083a4), Fz (rec c082b4), (r x F).z (rec c0861c)])
      -> 00554e70(i = c08250, a = c085dc, b = |Fz| + 0.01, c = Fy, d = 0.1*(rxF).z + c081ec)
per tick, 005539c0 (only when 00551880() = bf6e04 != 0: 00553a21 call, 00553a28 jz 00553d67)
  00553a52..5e  bf63c0 += bf6e88
  00553a64      call 00554d30   (x87 stack empty; unconditional inside the bf6e04 branch)
  00553a69..91  bf6360 = bf63c0 - c086b0 ; bf6364 = c086b4 + bf63c0
  00553b57      if bf63d8 (telemetry on, set @00553a13): ... 00553ca7 bf643e = bf6ed0 * 0.0254 ... -> 005548d0
per 36 Hz frame, 00554520 frame end (whole function gated by 00551880 = bf6e04 @0055452a)
  0055464c..00554775 (bf6ebb != 0 && bf6eb8 == 0): FFB block -> 005d08d0(bf6ebc, out)
      -> 005d2260 -> 005d2370 (global axis -> device, local axis) -> 005d3010: IDirectInputEffect::SetParameters
```

---------------------------------------------------------------------------------------------------------------------

## 4. Producers `0055e180` / `00554e70` (already in the Luau port as JIT natives)

### Where they are emitted

The tail of the tyre-callback builder `0055d9c0(w)` (`recovery/stage10/evidence/b1/0055d9c0.c`) emits:

```
0055e110 cmp esi,2 ; jge 0055e140                     ; front wheels only
0055e115 push 0xc083a4 / 0055e11f push 0xc082b4 / 0055e129 push 0xc0861c ; args p[0..2] (0057cba0)
0055e133 push 0x55e180 ; call 0057cc10                ; native call
```

### Dynamic identity check

`dyn/dyn_ffb4.py`, slalom, 200 frames, 6400 calls of `0055e180`:
* `w` = 0 in 3200 calls and 1 in 3200 calls.
* `e843fc` = 1 in 3200 calls and 0 in 3200 calls, so the callback runs in both passes.
* `p[0] == T(w)+0x2dc` (Fy) in 6400/6400 calls.
* `p[1] == T(w)+0x2e0` (Fz) in 6400/6400 calls.

### `0055e180` asm (`v2/dis/0055e180.txt`)

```
0055e187 fld [ecx+4] ; 0055e18c fstp [esp+0xc] ; and eax,0x7fffffff        ; |p[1]|
0055e1a1 fld [ecx+8] ; fmul [6ea4cc]=0.1 ; 0055e1ba fadd [c081ec]           ; d
0055e1c3 fld |p[1]| ; fadd [6ea4a4]=0.01                                     ; b
push p[0] (c), [c085dc] (a), [c08250] (i) ; call 00554e70
```

### `00554e70` arrays (slot 0 = LF, slot 1 = RF)

| array | slot 0 (LF) | slot 1 (RF) |
|---|---|---|
| `n` | `74c964` | `74c968` |
| `A` | `bf6ed4` | `bf6ed8` |
| `B` | `bf6edc` | `bf6ee0` |
| `C` | `bf6ee4` | `bf6ee8` |
| `D` | `bf6eec` | `bf6ef0` |

The operands are `[eax*4 + base]`, for example `00554e78 fadd [eax*4+0xbf6ed4]`.

### Meaning of `c085dc`

`0054cab0` (`recovery/stage8/evidence/0054cab0.c`) computes `fVar14 = (T+0x2e8 − c08620·T+0x2cc)·k + c08620`,
and `c08620 ← fVar14` only when `e843fc` is set. So `c085dc` is a first-order relaxed lateral slip state.

### Meaning of `c081ec`

```
c081ec = (0.2/fVar1)·Fy·Fx + fVar13·fVar11·(p14 − fVar2·fVar3·0.8) + fVar20·fVar11·(p14 − (fVar3+1)·0.5·fVar2)
```

This is the tyre pneumatic-trail aligning moment. The meaning is inferred from the structure; the addresses are
verified.

### Port status

The JIT natives `XF[0x55e180]` → `XF[0x554e70]` are ported (`PATCH_STAGE6_7.lua:3619..3634` writes
`74c964+4i`, `bf6edc+4i`, …). `00554d30` is not ported (`PORT_MAP.md:51`), so in the current port the
accumulators grow without bound. This is harmless: it is exactly machine B of the dynamic proof.

The static exe image has `74c960` = 1500, `74c964` = `74c968` = 1 and the sums at 0. The Luau image (post-build)
has `74c964` = `74c968` = 4 and `bf6edc` = `bf6ee0` = 0.03 (revision 1). This is consistent: 1 plus 3 build
passes with no load, and 3 × 0.01.

---------------------------------------------------------------------------------------------------------------------

## 5. `00554d30` (validated bit-exact) and the FFB block (validated bit-exact)

### `00554d30` (`v2/dis/00554d30.txt`; x87 CW `0x077f`, 64-bit precision, round down; `[ESP]` is an f32 local)

```
sx = B_LF + B_RF ; [ESP] = f32(sx)                              00554d3a..46
if n_LF >= 1 && sx > 0:  a = 1/n_LF ; l = f32(B_LF / f32(sx))   00554d59..6f
else:                    a = 0      ; l = 0                     00554d75..7b
b = (n_RF > 0) ? 1/n_RF : 0                                     00554d83..9a
74c960 = f32(B_RF*b + B_LF*a) ; if > 1500 (or unordered): 1500  00554da0..dc7
bf6ec4 = f32( ((1-l)*A_RF)*b + (A_LF*l)*a )                     00554dd1..e0b
bf6ec8 = f32( C_RF*b + C_LF*a )                                 00554e11..e2f
bf6ed0 = f32( D_RF*b + D_LF*a )                                 00554e35..e5f
n, ΣA, ΣB, ΣC, ΣD <- 0 (integer MOVs, 00554ddf..00554e59) ; fstp st0 x2 ; pop ecx ; ret
```

### FFB block (`v2/dis/00554520.txt`)

```
0055464c/5b  gate: [bf6ebb] != 0 && [bf6eb8] == 0
d    = f32((ec4 − ec0)·rate) ; ec0 = ec4 (MOV)                       00554668..00554695   rate = 005f7c50() = 36
q    = f32(ec4 + d·(lat·0.001)·(1 − 20/(v+20)))                        00554699..005546c9   v = bf3a00
m    = (|ec4| > 1e-5) ? (q/ec4)·ed0 : ed0                              005546cd..005546ff
ecc  = f32((m − damp·d + ecc)·0.5)                                     00554705..00554728   (fst [esp+0x10] after push 0x30)
out  = f32(ecc · strength/(ratio·1600))                                0055472e..00554745
out  = 1 if out > 1 ; −1 if out < −1                                   00554749..0055479d
005d08d0(bf6ebc, out)                                                  00554768..00554770
```

`00557d60` is `mov eax,[esp+4] ; lea eax,[ecx+eax*4] ; ret 4`. So after the call, `[esp+0xc]` (read at
`00554741`) is the slot written by `00554724 fst [esp+0x10]` while `push 0x30` was still on the stack. That slot
holds **`ecc`**.

The bit-exact models reproduce every call:
* `00554d30`: 3200/3200 calls in each scenario;
* the FFB block: 400/400 frames, slalom and brakesteer.

`dyn/dyn_ffb3x.py` uses rational arithmetic rounded like the x87 (64-bit mantissa, round down, f32 stores round
down). A round-to-nearest double model misses 2517/3200 calls by 1..few ulp.

**Timing.** At the frame end, `ec4` and `ed0` hold the averages that `00554d30` built at the start of tick 8, from
tick 7's passes. Tick 8's own passes stay in the accumulators until the next frame's first `00554d30`. In the dyn
runs, `n` = 2 at every frame end.

---------------------------------------------------------------------------------------------------------------------

## 6. Device layer (host; writes no simulation memory)

* **`005d08d0(axis, force)`**: if `[f5d4f0]` and `[f5d414]` are set, it tail-jumps to `005d2260`. `005d2260`
  checks `[f5e844]`, maps the global axis through `005d2370`, then calls `005d3010(local axis, force)`.
* **`005d2370`**: walks the device records at `this+4+i·0x262`, each with its axis count at `+0xae`, until the
  global index falls inside a record. It returns that device record and `local = global − Σ previous counts`.
* **`005d3010`**: on `slot = [dev+0x1e2+4·axis]` (after `axis < [dev+0xae]` and `slot != 0`), it builds a
  `DIEFFECT`:
  * dwSize 0x38, dwFlags 2 = DIEFF_OBJECTOFFSETS;
  * cbTypeSpecificParams = 4 at +0x2c;
  * lpvTypeSpecificParams = &arg1 at +0x30;
  * arg1 is overwritten with `_ftol(force·10000)` (`006f5214` = 10000.0; `006c5018` is the CRT `_ftol`, which
    truncates).

  It then calls `vtbl+0x18` = `IDirectInputEffect::SetParameters(…, 0x20000100)`
  (DIEP_TYPESPECIFICPARAMS | DIEP_START).
* **The effect** is created only in `005d2bb0` (`v2/dis/005d2bb0.txt`):
  * `SetProperty(9 = DIPROP_AUTOCENTER, 0)` and `Acquire`;
  * `CreateEffect(GUID_ConstantForce @006fb590 = {13541C20-8E33-11D0-9AD0-00A0C9A06E35}, …, &[dev+0x1e2+4·axis])`
    @`005d2cbf`, with dwFlags 0x12 (CARTESIAN | OBJECTOFFSETS), 1 axis (`rgdwAxes = [dev+0xb2+4·axis]`, the axis
    object offset stored at enumeration `005d289c`), duration −1, gain 10000;
  * then `Download` (vt+0x28) and `Start(1, 0)` (vt+0x1c).
* **No other effect exists:**
  * A raw scan of the whole image finds `006fb590` as the only DirectInput-effect GUID referenced (once, at
    `005d2cba`). The Spring, Damper, Friction and other GUIDs at `006fb4e0..006fb580` are never referenced.
  * The only other `call [reg+0x48]` in `005d0000..005d6000` (`005d415b`) is on an unrelated object `[f5e874]`.
  * The slots `+0x162`, `+0x1a2` and `+0x222` are only zeroed (`005d28c1..d6` at enumeration, `005d2d95..dad`),
    released (vt+8, `005d2d20`), stopped (vt+0x20, `005d2e10`) or started (vt+0x1c, `005d2e70`).
  * So `005d2ee0` (the condition-effect setter) returns at `005d2f00 test ebx,ebx; je` / `005d2f0f`, and
    `00550030`'s `005d08a0(axis, 0, 0, 0.75)` does nothing. **The original FFB is a single constant force.**
    There is no spring, damper or centring effect, and autocentre is disabled while the effect exists.
  * On release, `005d2d20` releases all four slots, zeroes them (`005d2d95..dad`), and calls
    `SetProperty(9, dwData = 1)` (autocentre back on, `005d2de3`) and device vt+0x1c (`005d2df7`).
* **`74c95c`** = (axis name ends in `'>'`) ? −1 : +1 (`0054ff26..0054ff32`, stored at `0054ff74`). Its only raw
  reference is that store, so the force is **not** sign-corrected by the binding direction.

---------------------------------------------------------------------------------------------------------------------

## 7. `00550070(flag)`, the control-7 binding and the `bf6eb8` lifecycle

```
00550075 test bl,bl ; jnz ; call 0054fed0          ; flag == 0: (re)configure the FF axis
0055007e if (bf6ebb && flag) 00550030(0,0)          ; suspend: zero the constant force
00550097 mov byte [bf6eb8], bl                     ; bf6eb8 = flag
```

**`0054fed0`** calls `0057b1e0(&type, &name, &dirstr, &rec8, &rec14, &flag, 7)`. Stack accounting at
`0054fedf..0054fef2`:

* `a1 = S+4`, `a2 = S+8`, `a3 = S+0x18`, `a4 = S+0x14`, `a5 = S+0xc`, `a6 = S+3`.
* `0057b1e0` turns arg 7 into the record address `d37cb8 + 29·7 = d37d83` (`lea edx,[eax+ecx*4+0xd37cb8]`) and
  jumps to `0057aff0`.

`0057aff0` returns these fields of the 29-byte binding record:

| out | field | meaning |
|---|---|---|
| `*a1` | `rec+0x10` | type: 1 axis, 2 key bits, 4 button |
| `*a6` | `rec+0xc != 0` | flag |
| `*a4` | `rec+8` | control-group mask |
| `*a5` | `rec+0x14` | axis or button number |
| `*a2` | name | for an axis, `0074fc68 + ((byte rec+0x1c != 0) + 2·rec+0x14)·4`, i.e. `"<n><"` or `"<n>>"` |

`rec+8` is the mask that `0057ab00` tests against `d3b028`.

If the type is 1 (axis):
* `bf6ebc = rec+0x14` (`0054ff2d mov esi,[esp+0x10]` = `S+0xc`; `0054ff7a`), the global axis number of the
  steer-left axis;
* `74c95c` is set from the direction character;
* the effect is released if FF is off (`bf6f1c` via `00550280`) or the axis changed;
* it is acquired (`00550000` → `005d0840` → `005d2170` → `005d2bb0`) if `bf6f1c` is set and `005d0820` reports FF
  support.

If the type is not 1, the effect is released.

**`bf6eb8` readers** (census: 5 raw hits = 4 xrefs plus the dead getter `005500a0`, which has no caller or
pointer):
* `005524f0 @00552549 cmp [bf6eb8],bl ; jne 0055269a`: the not-driven branch. At `0055269a..00552715` it zeroes
  `bf63c8 bf6f14 74c98c bf6388 bf6e84 bf63bc bf638c bf6390`, sets `bf6eac = 1.0` and `bf6eb0 = 0`, and clears
  `bf6e20..22`.
* `00554520 @0055465b`: the FFB gate.

**`bf6eb8` writers:**
* Image value 0 (uninitialised `.data`).
* `00550490 @00550501` = 1 at car init.
* `00550070 @00550097`. Its callers:
  * `00550930 @005509dc`, `00550a50 @00550b07`, `00550b30 @00550b9e`: `(0)` after car placement.
  * `00550a10 @00550a12`: `(1)`, followed by the `00550530` reset.
  * `0057ab00 @0057ab0e`: `(0)` when `mask & 3`.
  * `0057ab90 @0057ab9c`: `(1)` when `mask & 1`.

**Callers of `0057ab00`/`0057ab90`** (resolved):
* **`005baf80`**, the handler of sim message **6 (id 0x40) `fgmsgSelectActiveControls`**:
  * table entry `00752570/74` = (0x49249, `005baf80`); the name getter `005baab0` returns `752aa0`;
  * it calls `0057ab90(m0 & ~m1)` (`005baf91`), then `0057ab00(m1)` (`005bafa1`), where `m0 = [esi]` and
    `m1 = [esi+4]`.

  So activating control group bits 0/1 un-suspends the controls (`bf6eb8 = 0`) and reconfigures the FF axis.
  Deactivating bit 0 suspends them (`bf6eb8 = 1`) and zeroes the force.
* **`0055d0e0 @0055d1c3`** `0057ab90(-1)`:
  * `0055d0e0` is the init of the background sim task `0055cef0` (called at `0055ceff`), registered at
    `0043e839 call 005f8560(0x57e070, 0x55cef0, 0x546f80, 0x24, 0)` with rate 0x24 = 36.
  * So every sim session starts with all control groups inactive and `bf6eb8 = 1`.

`0057ab00`/`0057ab90` also maintain `d3b028`, the active-group mask, and (de)activate the devices of key/button
bindings (`005d0070`, `005d06c0`, `005d0140`).

The Stage 12 harness bypasses this gate: it calls `00552720` directly and uses `driver=false` for the not-driven
branch. Release at session end goes through `00550680` (from `00572cb0` and `00573bc0`).

---------------------------------------------------------------------------------------------------------------------

## 8. FFB options

Sim messages: table `752540`, names at `752ad8..`, mailbox ids `0x3a+idx`.

| msg idx (id) | name | thunk → setter | sim cell | image | front end |
|---|---|---|---|---|---|
| 8 (0x42) | fgmsgCarSetForceFeedbackOnOff | `005bb010` → `00550270` | `bf6f1c` (byte) | 0 | `894d80` from cfg → shadow `894d49` → `00570e00` |
| 9 (0x43) | fgmsgCarSetFFStrength | `005bb020` → `00550290` | `74c9a4` (f32) | 80.0 | int `894de0` from cfg → `72c5ec` (UI shadow, image **50**, clamped 0..100 by `0043ef90`/`0043efc0`) → `00570e30(float)` |
| 10 (0x44) | fgmsgCarSetFFDamping | `005bb030` → `005502d0` | `bf6f24` (f32) | 0.0 | int `894dac` from cfg → `894e10` (clamped **0..100**, `0043efe0`/`0043f010`) → `00570e60(float)` |
| 11 (0x45) | fgmsgCarSetFFLatency | `005bb040` → `005502b0` | `bf6f20` (f32) | 0.0 | int `894d78` from cfg → `894e14` (clamped **0..250**, `0043f030`/`0043f060`) → `00570e90(float)` |

`0043f1d0` reads controls.cfg field by field with `005cfdb6(file, &cell, size)` (sizes 1/1/1/4/4/4 at
`0043f30a..0043f3a8`). Any short read jumps to `0043f5c2`, which calls `005cfd08(file)` (inferred: close) and
returns before the senders at `0043f510..0043f57a`, so no message is sent. There is no code default for these
fields: without a valid controls.cfg the sim keeps its image values (FF off, strength 80, damping 0, latency 0).
The front-end strength shadow `72c5ec` has image 50, which differs from the sim's 80.

The values reaching the sim are integers converted to float: damping 0..100 (physical unit unresolved) and latency
0..250 (ms, inferred from the 0.001 factor). The dynamic test value damping = 0.5 is therefore not a UI value, but
it exercises the same arithmetic.

---------------------------------------------------------------------------------------------------------------------

## 9. Reader/writer census of every cell written (`v2/census.txt`: raw hits over the whole image = Ghidra xrefs)

| cell | raw hits / xrefs | writers | readers | feeds physics / steering? |
|---|---|---|---|---|
| `74c960` | 2 / 2 | 00554d30 (00554db2, 00554dc7) | **none** | no |
| `74c964/68` | 6 / 6, 3 / 3 | 00554d30 (clear), 00554e70 (++) | 00554d30, 00554e70 | no |
| `bf6ec4` | 5 / 5 | 00554d30 @00554e0b | FFB block only | no |
| `bf6ec8` | 1 / 1 | 00554d30 @00554e2f | **none** | no |
| `bf6ed0` | 4 / 4 | 00554d30 @00554e5f | FFB block; 005539c0 @00553ca7 (telemetry, gated by `bf63d8`) | no |
| `bf6ed4..bf6ef0` | 4,2,6,3,4,2,4,2 = xrefs | 00554e70 (+=), 00554d30 (clear) | 00554e70, 00554d30 | no |
| `bf643e` | 1 (writer only) | 005539c0 @00553cee | none direct; record base `bf63f6` used only by the telemetry block of 005539c0 and `0055495b` (005548d0 sender) | no |
| `bf6ec0`, `bf6ecc` | 3 / 3 each | FFB block, 00550530 (reset @005505b3/b8) | FFB block | no |
| `bf6eb8` | 5 / 4 (+ dead getter 005500a0) | 00550070, 00550490 | **005524f0** @00552549, FFB block | **yes**: player-branch gate (input-session state) |
| `bf6ebb` | 11 / 11 | 0054fed0, 00550490, 00550680 | FFB block, 00550070, 0054fed0, 00550680 | no |
| `bf6ebc` | 8 / 8 | 0054fed0 | FFB block, 00550000/30/60, 0054fed0 | no |
| `74c95c` | 1 / 1 | 0054fed0 | **none** | no |

---------------------------------------------------------------------------------------------------------------------

## 10. Dynamic proof on the original code (Unicorn, Stage 12 harness)

`dyn/dyn_ffb.py` runs two machines in lockstep: A unmodified, B with `00554d30` = RET (block cache flushed). After
every frame it compares the whole `0x6e9000..0xf80000` window.

| scenario | ticks | differing dwords | which |
|---|---|---|---|
| slalom | 8640 | 14 | `74c960 74c964 74c968 bf6ec4 bf6ec8 bf6ed0 bf6ed4 bf6ed8 bf6edc bf6ee0 bf6ee4 bf6ee8 bf6eec bf6ef0` |
| brakesteer | 8064 | 14 | same |
| keys | 6912 | 14 | same |
| yawlimit | 5184 | 14 | same |
| slalom (revision 2 re-run, `v2/rerun_slalom200.txt`) | 1600 | 14 | same; `bf63c0 bf63c8 bf6360 bf6364 bf6e80 bf6e88 bf6d70` identical |

`dyn/dyn_ffb2.py` compares the bench default (A) with B = `bf6ebb = 1`, `bf6eb8 = 0`, latency 50, damping 0.5. The
only differing dwords are `bf6ec0`, `bf6ecc` and the option cells written by the test (`bf6eb8`, `bf6f20`,
`bf6f24`), over 1080 (slalom) and 1008 (brakesteer) FFB calls.

Sample, slalom with defaults (strength 80, ratio 18): `ecc` ≈ ±290, giving `out` ≈ ±0.8. The output saturates at
|ecc| ≥ 360.

---------------------------------------------------------------------------------------------------------------------

## 11. What Stage 13 needs from the Stage 12 steering chain

1. **No steering-chain cell is an FFB input.** The torque is built from front-tyre force statistics. What Stage 13
   needs from Stage 12 is the steered physics itself: the hub states 15/21 set the front contact frames, and those
   produce Fy, Fz, (r×F)z, `c081ec` and `c085dc`. The accumulation (`0055e180` → `00554e70`) is already ported.
2. **The per-tick slot of `00554d30` in `005539c0`** (@00553a64), inside the `bf6e04` branch, every tick, after
   `bf63c0 += bf6e88` and before `bf6360`. Its position relative to the steering arithmetic does not matter: the
   two share no cells. What matters is that it runs before the tick's tyre passes, so that `n = 2`.
3. **Setup item 0x30 (raw `c05680`)**: the same cell `00554fb0` reads, without the `74c9a0` low-speed override.
4. **`bf6eb8`**, the controls-suspended flag. It is shared with the `005524f0` player-branch gate, so it must be
   one state in the port. It is driven by `00550070` from `fgmsgSelectActiveControls` and from session/car init.
5. **The FF axis = the control-7 (steer left) axis binding** (`rec+0x14` of record `d37d83`) from the Stage 12
   device layer. The original never sign-corrects the force for the binding direction (`74c95c` is unused).
6. **Frame-end inputs already in the port (Stage 11)**: `bf3a00` airspeed (`0055455f`), taskGetRate = 36, and the
   `00550530` reset, which zeroes `bf6ec0`/`bf6ecc` together with the steering states.
7. **Options**: `74c9a4` strength, `bf6f24` damping, `bf6f20` latency, `bf6f1c` on/off.
8. **Arithmetic**: x87 64-bit precision with RC = down, and f32 stores rounded down.
9. **Device model**: a single constant force, `trunc(out·10000)`, on one axis, with autocentre off. There is no
   spring or damper effect.

---------------------------------------------------------------------------------------------------------------------

## 12. Verified / inferred / unresolved

**Verified** (static asm plus the census; dynamic where stated):
* all formulas and their bit-exactness (dynamic);
* every reader and writer (raw-pointer census = xrefs);
* the `0055e180` parameter identities, the LF/RF slots and the 2 passes per tick (dynamic);
* no physics or steering effect of `00554d30` or of the FFB block (dynamic, whole window, 5 runs);
* the `bf6eb8` gate in `005524f0`, the `bf6e04` gate of both `00554d30` and the frame end;
* `00557d60` is `ret 4`;
* the DIEFFECT layout, the single ConstantForce effect and the no-op condition setter;
* `bf6ebc` = global axis of the control-7 binding;
* the callers of `0057ab00`/`0057ab90` (message 6 `fgmsgSelectActiveControls`, sim-task init `0055d0e0`);
* the controls.cfg read without defaults, and the front-end clamps;
* the option message mapping.

**Inferred:**
* the physical meanings: `c085dc` relaxed lateral slip state; `c081ec` pneumatic-trail aligning moment; `c0861c`
  moment about the hub z-axis (the `T+0x309` register frame being the hub frame); `74c960` total front load;
* the units of `bf6f20` (ms; supported by the 0.001 factor and the 0..250 UI clamp); `bf6f24` has no established
  unit;
* `005cfdb6`/`005cfd08` are the file read and close helpers of the controls.cfg loader;
* the meaning of the control groups `d3b028` (bit 0 = driving controls).

**Unresolved:**
* What `005f79a0` (`bgRequestFGAction`) does with its arguments: it runs `00550000`/`00550060` on the foreground
  thread (from its name and use; not traced).
* What `005d2b90` checks before `005d2bb0` (FF capability of the axis); not needed for the sim.
* Which front-end paths, other than controls.cfg load, send messages 8..11 when the user moves the sliders (the
  `00570e00..00570e90` senders' other callers were not traced).
