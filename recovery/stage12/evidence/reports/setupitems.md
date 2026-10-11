# Setup items 0x30 / 0x3a / 0x9f..0xa4 — who consumes them (label: setupitems)

Scratch / evidence: `/opt/s12/work_setupitems/` (scripts `callscan.py`, `regimm.py`, `pushnext.py`, `refscan.py`,
`nrdis.py`, `dyndiff*.py`, `dyndrive.py`; outputs `acc_calls.tsv`, `setupfn_calls.tsv`, `scan_push.tsv`,
`push_next.tsv`, `regimm.tsv`, `baserefs.tsv`, `dyndiff.out`, `dyndiff2.out`, `dyndrive.out`; Ghidra export
`ev/` (00561290, recovered_005614b0, 0047d97f, 0047e230, 00480b1a, 00424860, 00425ad0, 00559820, 005d08d0 ... +
index.tsv), `xref.tsv`, `funcs_47d.tsv`, `funcs_55c.tsv`, `funcs_561.tsv`, `ghidra1.log`). Ghidra project used:
`/opt/nrproj_2` (read-only). Nothing under `/home/user/nrport` was modified (Python run with bytecode writing off).

## Short answer

* **(a) Item 0x30 (steering ratio) feeds NO derived item and NO build cell or generated code.** The
  "DYN: itens deriv. 1" in SETUP_MAP is the item itself. `item_destinations.json["48"].items == [48]`, and that
  count always includes the stepped item: 0x31 → `[0x31,0x5c,0x62]` = 3, 0x3a → `[0x3a,0xa0,0xa4]` = 3. A
  whole-image + heap diff of the ORIGINAL build (Unicorn, `orig_setup.apply`) for ratio 12 / 18 / 32 changes only
  `c03410` and `c05680` (the item itself in the garage and active setups). Nothing in `0x400000..0x1200000`
  differs, and nothing in the emulator heap does either.
  Run-time consumers of 0x30, all reached through the accessor `00557d60`/`00557ee0`/`005583e0` with an
  immediate `push 0x30`:
  1. `00554fb0` @`00554fba/00554fc1` — the steering ratio divisor (already known). It is called by
     `00551e80` (@`00552255`, physics input), `005662d0` (@`005664e2`, cockpit wheel) and `00565cc0`
     (@`00565ef8`, car-model steering-wheel animation, **new**).
  2. **`00554520` frame end, force-feedback block** (@`0055470f push 0x30` / `0055472e call 00557d60`, **new**):
     `ffb = clamp(bf6ecc · [0074c9a4](=80) / (ratio · 1600), −1, 1)` → `005d08d0(bf6ebc, ffb)`. This only runs when
     `bf6ebb != 0 && bf6eb8 == 0`, which is FFB. It is not physics.
  3. UI and telemetry, display value only: garage `0047d97f` / `0047e230` (`00557ee0(0x30)` → `"%2ld:1"`),
     `00480b00` (±1 step `005583e0(0x30)`), and telemetry setup record `0055c830` @`0055cbd4`.
* **(b) Items 0x3a and 0x9f..0xa4 are NOT steering. They are the rear limited-slip DIFFERENTIAL ramp
  coefficients, and they DO affect the Cup physics at run time.** `00424860` derives them from item 0x3a, an index
  into the 2-entry table `006ed7e0` = {(85,30), (85,85)} degrees. The only consumer outside `00424860` is the
  drivetrain native `005614b0` ("differential capacity", already lifted as `XF[0x5614b0]`). The solver calls it
  twice per tick through the generated callback that `00561290` emits (`005612ff push 0x5614b0; call 0057cc10`).
  It reads 0xa4 when the drive torque is ≥ 0 (power) and 0xa3 when it is < 0 (coast). The dynamic test with the
  original code shows the effect: with the default (idx 0, 85°/30°) the rear wheels stay locked under power
  (RR−LR = 0.000 rad/s). With idx 1 (85°/85°) they split by up to 12 rad/s, and the car state diverges
  (`dyndrive.out`). No build cell or generated code depends on them. They are not used by rendering or UI.

## (a) Item 0x30 — evidence

### Exhaustive accessor-call scan

`callscan.py` scans **every** `E8 rel32` in `.text` (`/opt/nrmem/00401000.bin`, including code that Ghidra did not
disassemble) whose target is a setup accessor or setup-module function (`00557c00..0055a000`, `00423000..00426000`).
It then disassembles backwards and records the pushed index and ECX. `regimm.py` additionally checks for
`mov reg, imm` / `lea reg,[reg+imm]` index forms. Ghidra `ScanOperandPy` "push 0x30" (167 hits) and `pushnext.py`
map each push to the next call target.

| site | call | setup (ECX) | function | role |
|---|---|---|---|---|
| `00554fc1` | `00557d60(0x30)` | `0xc055c0` | `00554fb0` | steering ratio divisor (Stage 12) |
| `0055472e` | `00557d60(0x30)` | `0xc055c0` | `00554520` (frame end) | FFB gain, gated by `bf6ebb` |
| `0047d97f` | `00557ee0(0x30)` | `[ebx+0x4e2]` (UI copy) | garage page (recovered_0047d97f) | display `sprintf(0x739520)` |
| `0047e257` | `00557ee0(0x30)` | `[esi+0x4e2]` | `0047e230` | display `"%2ld:1"` (UTF-16 @`007396e0`) |
| `00480b1a` | `005583e0(0x30, dir)` | `[esi+0x4e2]` | `00480b00` | garage ±1 step |
| `0055cbd4` | `00557ee0(0x30)` | `0xc055c0` | `0055c830` (telemetry) | display value into the telemetry record |

There is no `push 0x30` before an accessor anywhere in `00423000..00426000` (`00425ad0`, `00425690`, `004257a0`,
`00425900`, `00425a20/30`, `00424860`), in `00559950`, in `0055e9b0` (its computed indices resolve to wheel loops
0x14..0x17, +8, +0x6d.., 0x29/0x2a, 0x41/0x42, see the Ghidra pseudo-C of `0055e9b0`), or in `005601c0`. There is no
absolute reference to `c05680`/`c03410` in code (`findptr.py`; the only hit is a data word at `006ea4ed`). The active
setup is touched as a whole only by the 0xefd-byte `rep movsd` copies in `00559360`, `005597c0`, `005597f0`,
`00559840` and `00559900` (`baserefs.tsv`).

### Dynamic proof (original build in Unicorn)

`dyndiff2.py`: `orig_setup.boot(); prepare(); apply({0x30: f32(r)})`, then a diff of the whole mapped image
`0x400000..0x1200000` plus the emulator heap against the default build:

```
ratio12: image 2 dwords differ: 00c03410 00c05680 (18 -> 12) ; heap 0
ratio32: image 2 dwords differ: 00c03410 00c05680 (18 -> 32) ; heap 0
```

The derived items, the cells, the JIT code and the literal pool are all bit-identical. 0x30 is therefore a pure
run-time item.

### FFB block in `00554520` (asm from `recovery/stage11/evidence/b1/00554520.asm`)

```
0055464c MOV AL,[0x00bf6ebb] ; TEST ; JZ 00554778        ; FFB enabled
0055465b MOV AL,[0x00bf6eb8] ; TEST ; JNZ 00554778
...                                                        ; bf6ecc = (x - bf6f24*rate*Δbf6ec4 + bf6ecc) * 0.5
0055470f PUSH 0x30 ; 00554711 MOV ECX,0xc055c0 ; 0055472e CALL 00557d60
00554733 FLD [EAX] ; FMUL [006f5a44]=1600.0 ; FDIVR [0074c9a4]=80.0 ; FMUL [ESP+0xc]   ; 80/(ratio*1600)*bf6ecc
00554749..0055479d clamp to [-1,1] ; 00554770 CALL 005d08d0(bf6ebc, v)
```

The raw value `0074c9a4` appears in code only at `00550295` (setter `00550290`, reached through the message thunk
`005bb02a jmp`), `005502a2` (getter `005502a0`) and `0055473d` (this block). It is probably an FFB option (inferred). The port already lifts this block (`PATCH_STAGE11.lua` `XF[0x554520]`, `wu(...,48)`,
with `005d08d0` replaced by `B_ret`), so it has no effect there.

### Other callers of `00554fb0` (byte scan E8/E9, no pointer refs)

`00552255` (`00551e80`), `005664e2` (`005662d0`, cockpit wheel) and `00565ef8` (`00565cc0`, called from `00587afb`).
`00565cc0` computes `-(00554fb0() * [edi+0xbc])` clamped to ±2.79 (`006f5e6c/70`), with `edi = 005ba130(car)`, and
drives model parts `[esi+0x2e4..0x328]`. **Inferred:** this is the 3D car model's steering-wheel and part
animation. It reads the player's active setup `c055c0`.

Continuation pass: who reaches `00565cc0` (byte scan of every E8/E9 in `.text`, `findptr.py`, capstone):

* `00565cc0` has a single caller, `00587afb`, inside `00587ae0`. `00587ae0` makes a virtual call through
  `[this]+8` if its argument equals `[this+0x18]`; otherwise it calls `00565cc0([this+0x24], this)`. The only pointer
  to `00587ae0` in the image is the vtable word `006f6df4`. The neighbouring word `006f6df0` = `00587a90`, which
  calls the cockpit drawers `005660f0` / `005662d0` (`00587a9e` / `00587aa5`).
* That vtable block is installed into a **48-element object array** by `00599a40`: `esi = 0xd95744`,
  `edi = 0x30`, stride `0x3ec`. Each element gets `[esi-4] = 6f6de8` and `[esi] = 6f6de4`, and its base is built by
  `005ba0c0`, which installs base vtable `6f68fc` (6 × purecall `006c4ac0`). In `6f6de4`, slot 3 = `00587a90` and
  slot 4 = `00587ae0`.
* The vtable is also installed into a singleton at `d956b0` (`00599a24`, registered at `0059a6a2/0059a6c5`). That
  object is only `0x90` bytes before the array, so `this+0x2f0` (read by `005ba130`) would fall inside array element
  0. **Inferred:** the singleton is not a car-model object on this path.
* `005ba130(this)` returns `this+0x2f0` when `005ba080(this+4)` is true. Otherwise it returns
  `this + 0xf8 + [ebbd78]*0xfc` (`005ba150`), which is one buffer of a double-buffered 0xfc-byte render snapshot. So
  `[edi+0xbc]` is a per-object render-snapshot field.
* **Inferred (strong):** `00565cc0` animates the exterior model of **every** car slot that is drawn outside its own
  cockpit view. It always multiplies that car's snapshot steer value by the **local player's** ratio (`c055c0+0xc0`).
  This is render only and does not feed physics. In the port it is presentation only: use each car's own ratio, or
  the player's ratio to stay faithful.

## (b) Items 0x3a, 0x9f..0xa4 — evidence

### Derivation (`00424860`, asm `recovery/stage10/evidence/b2/00424860.asm`)

```
00425306 PUSH 0x3a ; CALL 00557d70 ; MOV EDI,[EAX]                         ; idx = s[0x3a] (int)
0042531d FILD [EDI*8+0x6ed7e0] ; FMUL [006ed7b4]=0.0174533 ; FCOS ; FSTP s[0x9f]   ; cos(tbl[idx].a deg)
0042533a FLD [006ed7dc]=0.05 ; FMUL [006e9804]=4.0 ; FSTP s[0xa1]          ; 0.2 (constant)
00425370 s[0xa3] = s[0xa1] * s[0x9f]
00425383 FILD [EDI*8+0x6ed7e4] ; FMUL k ; FCOS ; FSTP s[0xa0]               ; cos(tbl[idx].b deg)
004253a0 s[0xa2] = 0.05*4 ;  004253d6 s[0xa4] = s[0xa2] * s[0xa0]
```

* Table `006ed7e0` has exactly 2 pairs: `(85,30)` and `(85,85)`. `006ed7f0..` is a different table, the .sto
  version → stored-item count used by `00558830 @0055883b mov edi,[eax*4+0x6ed7f0]`: v12/13/14 → 66/68/70 items
  (`[006ed828]=70`, also read by `005588c0` and `00558c50`).
* Item 0x3a: descriptor `6ee170` (assigned by `00423729 mov [0xc052ae],0x6ee170`). It is an int with identity
  conversion, range 0..32767, default 0. Item 0x30 uses descriptor `6edd9c` (`004235f7`): 12..32, default 18.
  0x3a < 70, so the inferred reading is that it is stored in and loaded from `.sto` (`00558830` loop).
* Default Cup values (build): 0x9f = 0.08715512 (cos 85°), 0xa0 = 0.8660253 (cos 30°), 0xa1 = 0xa2 = 0.2,
  0xa3 = 0.01743102, 0xa4 = 0.173205. With idx 1: 0xa0 = 0.08715512, 0xa4 = 0.01743102, the rest unchanged.
  `dyndiff.out` agrees exactly with `item_destinations.json["58"].items = [0x3a,0xa0,0xa4]`.
* `00424860` runs from `00425ad0` (@`00425c0c`, i.e. 00559820 on every setup application) and through the thunk
  `00558770` (`push ecx; call 00424860`), called from pit stop `005601c9`, reset `0055172a` and garage UI
  `00482c38..00482da5`. Its inputs never change, so its outputs never change.

### Consumers

Every accessor call carrying these indices (byte scan, Ghidra scan, `regimm.py`):

| index | write sites (00424860) | read sites outside 00424860 |
|---|---|---|
| 0x3a | — (read @`0042530a`) | **none** |
| 0x9f, 0xa0, 0xa1, 0xa2 | `00425318/42536b`, `0042537e/4253d1`, `00425335/42534f`, `0042539b/4253b5` | **none** (intermediates) |
| 0xa3 | `0042535d` | **`00561542`** (`005614b0`) |
| 0xa4 | `004253c3` | **`00561556`** (`005614b0`) |

The other "push 0x9f..0xa4 / 0x3a" hits in Ghidra's scan are not setup accesses. They are menu/layout calls
`00450ec0` / `00451020` (ECX = UI object, multi-argument, table `0072f788`) at `0044b3f5..0044b72c` and `0044f916`,
plus unrelated `00520030`, `005bd360`, vtable `[edx+0x74]` and so on (`push_next.tsv`). No render path reads them.

### `005614b0` (no Ghidra function; recovered by ExportSetPy → `ev/005614b0.c`; asm `nrdis.py 0x5614b0 0x5615b1`)

```
blk = *(esp+4):  [0]=out*, [1]=a (+4), [2]=b (+8), [3]=engage (+0xc), [4]=gear (+0x10, float), [5]=x (+0x14)
v   = engage < 0.9 ? a : a + b                         ; 005614bb fcomp [006ed020]=0.9
g   = _ftol(gear)                                      ; 005614de call 006c5018
r   = c086e0[g] ? s[0x67] : s[0x66+g]                  ; gear ratio (failed gearbox -> neutral ratio)
t   = r * s[0x6e] * v                                  ; final drive
t   = t < 0 ? -(t * s[0xa3]) : t * s[0xa4]             ; 0056153d push 0xa3 / 00561551 push 0xa4
*out = max(0, t * (1 - |x| / [0074e860]))              ; 0074e860 = spec+0x94 = 10000 (0055f314..0055f31f in 0055e9b0)
```

Emitter `00561290` (called by `00560680` @`005606ee`; `00560680` is reached through the tail jump
`005b3995 jmp 00560680`; `XF[0x561290]()` is executed by the port's lifted Stage 10 build, `PATCH_STAGE10.lua:27286`)
generates the call: `005612ff push 0x5614b0; 00561304 call 0057cc10`. In the Stage 6/7 natural code it is
`NC(0x5614b0, 6)` with out = `0xebcf20` (`PATCH_STAGE6_7.lua:18801`). The port already names it
`Drivetrain.differentialCapacity` (`PORT_MAP.md:389`, `core/Drivetrain.lua:44`, arguments `powerRamp/coastRamp`).

### Dynamic proof that it matters (`dyndrive.py` → `dyndrive.out`)

The run uses `OriginalDriver` on a flat surface: clutch from 0.5 s, full throttle from 0.75 s, shifts at
0.8/1.6/2.6 s, steer 0.01 between 3 and 4 s, lift at 4.5 s, 1728 ticks. It compares 0x3a = 0 against 0x3a = 1,
with `005614b0` hooked:

```
calls: 3456 (2 per tick) ; out cell 0x00ebcf20
power  tick 700 (gear idx 3): idx0 816.894  idx1 82.2217   (ratio = 0.173205/0.01743102)
coast  tick 1726 (gear idx 4, args < 0): idx0 7.86675 idx1 8.02312 (both use 0xa3; differ only by state)
first output difference: tick 285
t   | idx0: vx  LRw  RRw  (RR-LR) eng | idx1: vx  LRw  RRw (RR-LR) eng
2s  | 6.780 97.450 97.450 0.000 706.51 | 6.778 99.141 95.741 -3.400 706.45
3s  | 13.391 92.505 92.505 0.000 524.86 | 13.380 98.496 86.502 -11.994 524.83
4s  | 18.820 58.280 58.280 0.000 330.67 | 19.318 59.122 59.206 0.084 335.69
```

State indices follow PORT_MAP: 1 = vx, 30/32 = LR/RR wheel spin rate, 34 = engine. The build diff for 0x3a = 1
changes only `c03438/c056a8`, `c035d0/c05840` and `c035e0/c05850`, with 0 cells and 0 heap words. The influence is
purely at run time, through `005614b0`.

## Verified vs inferred

The **Verified** list holds what the evidence shows directly. The **Inferred** list holds what is plausible but not
proven.

**Verified:** everything with an address above; the item values; the build image and heap diffs; the 2-entry table
and the adjacent version table; the accessor call sites; the lifted FFB block and `XF[0x5614b0]` in the port.

**Inferred:**
* That `005614b0` is a ramp-type (Salisbury) LSD, with 0.05 as a friction coefficient and 4 as a number of faces.
  What is verified is the formula and that it sets the left/right rear coupling.
* That positive torque means "power". The test shows positive under throttle and negative on lift.
* That `00565cc0` is the 3D-model animation.
* That `0074c9a4` is an "FFB strength" option.
* That 0x3a is loaded from `.sto` files.

## Unresolved

* Whether any garage page for any series exposes 0x3a through a table-driven item index. No immediate or
  register-immediate access exists; the Cup garage shows nothing for it.
* Whether `00565cc0` runs for AI or remote cars is narrowed, not proven. It is reachable only through vtable word
  `006f6df4`, which is installed into the 48-slot car-object array at `d95744` (stride `0x3ec`). That strongly
  suggests it runs per car. The virtual call site that dispatches the slot was not identified, and no dynamic render
  run was made.
* The exact physical meaning of blk `a` / `b` / `x` in `005614b0`. They look like engine and clutch torque terms and
  an axle load; this was not traced further.
* For indexes ≥ 2 (`.sto` file or the descriptor maximum 32767), the original reads past the 2-entry table into the
  `006ed7f0` version table and beyond: idx 2..7 → (-1,-1) → coefficient 0.19997; idx 8 → (66,68). This was not run
  in the emulator.

## Impact on the Luau port / docs

1. **SETUP_MAP.md / `setup_semantics.py` / `PATCH_STAGE10` setup table:** rename these items and move them to group
   `drivetrain` with run-time consumer `005614b0`:

   | item | new name |
   |---|---|
   | 0x3a | `differentialRampSet` (index into `006ed7e0`: 0 = 85°/30°, 1 = 85°/85°) |
   | 0x9f | `diffCoastRampCos` |
   | 0xa0 | `diffPowerRampCos` |
   | 0xa1 | `diffCoastFrictionGain` (0.2) |
   | 0xa2 | `diffPowerFrictionGain` (0.2) |
   | 0xa3 | `diffCoastLockCoeff` |
   | 0xa4 | `diffPowerLockCoeff` |

   Fix the "DYN: itens deriv. N" column. N includes the item itself, so for 0x30 write "no derived item; no build
   cell (whole-image diff)".
2. **No physics change is needed.** The port's lifted `XF[0x424860]` (Stage 10 apply) and `XF[0x5614b0]` (Stage 6/7
   and 10 code) already compute and read 0xa3/0xa4 from the active setup memory. Do not treat 0x3a/0x9f..0xa4 as
   steering geometry in Stage 12. No Ackermann or steering-arm data exists in the setup; front-wheel geometry comes
   from the build cells (hub axes and offsets) and the prescribed lfhub/rfhub angles.
3. **Steering ratio (0x30):** Stage 12 should read it at run time from `c055c0+0xc0` (float) through `00554fb0`, both
   for the steering input (`00551e80`) and for presentation (`005662d0` cockpit wheel; optionally `00565cc0` model
   animation, clamp ±2.79). Changing it needs **no rebuild** in the port: the build output is bit-identical for any
   ratio. The original still only copies garage → active on session start, at `00559360`. The FFB block of
   `00554520` also scales with 1/ratio but stays inert (`bf6ebb = 0`, `005d08d0` = host stub).
4. **Roblox UI:** do not expose 0x3a as a steering control. If it is exposed at all, offer it as "rear diff 85/30
   (default) or 85/85" and clamp it to 0..1. Larger values reproduce original out-of-table reads, which is faithful
   but meaningless.
5. **Optional tests:** add a fixture for 0x3a = 1, checking 0xa0 = 0x3db27e62 and 0xa4 = 0x3c8ecb81. Add a drive
   check that RR−LR stays 0 under power with idx 0 and splits with idx 1, using the dyndrive scenario.

## Continuation pass: independent re-verification (2026-10-08)

This pass re-checked the claims above against the memory image (`nrdis.py`, `refscan.py`, `findptr.py` run with
`-B`, and new byte scans). Nothing under `/home/user/nrport` was modified.

* **Accessors:** `00557d60` and `00557d70` are both `lea eax,[ecx+idx*4]; ret 4`, which returns a pointer to the raw
  item. `00557ee0` returns the display int `desc[c05152+idx*6]->[+0x16](raw)`. `00557e40` returns the display value
  as a float.
* **No absolute reference** in the image to any of the cells involved: active `c05680` (0x30), `c056a8` (0x3a),
  `c0583c..c05850` (0x9f..0xa4); garage `c03410`, `c03438`, `c035cc..c035e0`. The only hit is the unaligned
  `.rdata` word `006ea4ed` for `c05680`, which is coincidence.
* **Immediate-index accessor calls** (`setupfn_calls.tsv`, every E8 into the setup modules), filtered for
  0x30/0x3a/0x9f..0xa4, give exactly the sites listed in (a) and (b). `regimm.tsv`'s `0055cbef 00557e40` hit is a
  false positive: that call pushes `0x5c` (fuel gallons, `0055cbdd`). The only 0x30 read in telemetry is `0055cbd4`.
* **`005614b0`, re-disassembled:** `00561530 fcomp [6ea454]=0; test ah,5; jp 00561551` selects
  `t*s[0xa4]` when t ≥ 0 (or unordered) and `-(t*s[0xa3])` when t < 0. `00561593..005615a2` clamps the result to
  ≥ 0. `005614bb fcomp [6ed020]=0.9` adds b only when engage ≥ 0.9.
* **`00424860` block `00425306..004253de`, re-disassembled:** identical to the derivation listed above. The table
  `006ed7e0` = `{85,30},{85,85}`, followed by `-1 × 12` (`006ed7f0..006ed81c`) and `66,68,70` (`006ed820..`).
  Computed with float32 k = 0.0174533: idx 0 → 0xa3 = 0.017431025, 0xa4 = 0.17320506; idx 1 → both 0.017431025;
  idx 2..7 → both 0.19996954; idx 8 → 0.08134724 / 0.074921226.
* **`item_destinations.json`** (`recovery/stage10/evidence`): `"48".items = [48]` (0x30 alone);
  `"58".items = [58,160,164]` (0x3a, 0xa0, 0xa4). 0x9f/0xa1/0xa2/0xa3 do not change with the index, because
  `0xa3 = 0.2·cos(85°)` for both table rows.
* **Port:** `PATCH_STAGE10.lua` `XF[0x5614b0]` (line 18909..) pushes 163/164 with `ECX = 12604864` (`0xc055c0`) into
  `XF[0x557d60]`. The 0xa3/0xa4 path is already executed from setup memory. The stand-alone helper
  `INSTALL_STUDIO.lua` `differentialCapacity` is algebraically identical. It computes `|x|/unload` instead of
  `(1/unload)·|x|`, so it is not bit-exact with x87, but it is not the executed path.
* **Callers by E8/E9 byte scan:** `00554fb0` ← `00552255`, `00565ef8`, `005664e2` (no others); `00565cc0` ←
  `00587afb` only; `005662d0` ← `00587aa5` only.
