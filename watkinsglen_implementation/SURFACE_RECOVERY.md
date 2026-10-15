# Watkins Glen surface physics: recovered evidence

This report distinguishes recovered original behavior from visual approximations and validation still required.
The simulation uses NR2003's material indices, original track queries and contact callbacks. Roblox `Material`
and `CustomPhysicalProperties` do not define the tire model.

## Provenance and restored tools

The public reference is [TChapman500/OpenNR2003](https://github.com/TChapman500/OpenNR2003), commit
`03bcafb44cf63464493f1864edbd9f781fac24f4`. Its main branch contains Ghidra project databases rather than
readable original C source. Ghidra 11.1.2 and Temurin JDK 17 were installed under `work/tools/`; a local copy of
the project was opened for memory export. The public repository was not changed.

The exports are `work/reference/memory/{nr2003,server,rts}/blocks.tsv` and the corresponding memory blocks.
The NR2003 `.text` bytes overlap byte-for-byte with every code byte in the existing
`recovery/vehicle_core/00400000.bin` dump. In particular, the instructions at `00513eaa`, `0054cab0` and
`005e7330` match. This verifies that the restored reference supplies the same code used by the earlier recovery.
These full executable and DLL memory dumps remain scratch inputs; they are not included as public deliverables.

`recovery/evidence/*.c` are Ghidra pseudo-C evidence, not Papyrus source code. Companion `.asm` files are retained
where useful. `recovery/evidence/surface_tables.json` records material values and the exact float32 bit patterns
of the original numeric tables, their addresses, and hashes.

## Material indices and grip

The grip loader is `0050fbd0`. It selects `[track]` defaults and any track-specific override, then multiplies the
override by the base material table at `006f6570`. The loaded table is `0074fb30`; accessor `005100c0` returns
its entry for a material less than 20. A material outside that range returns 1.0.

| Index | NR2003 material | Base scalar | Watkins Glen multiplier | Loaded scalar |
| ---: | --- | ---: | ---: | ---: |
| 0 | Undefined | 0.8000000119 | 1 | 0.8000000119 |
| 1 | Asphalt | 0.8000000119 | 1.05 | 0.8399999738 |
| 2 | Concrete | 0.7680000067 | 1.09 | 0.8371199965 |
| 3 | Rumble strip | 0.7680000067 | 1 | 0.7680000067 |
| 4 | Paint | 0.7199999690 | 1 | 0.7199999690 |
| 5 | Grass | 0.4639999866 | 1 | 0.4639999866 |
| 6 | Dirt | 0.5199999809 | 1 | 0.5199999809 |
| 7 | Sand | 0.6400000453 | 1 | 0.6400000453 |
| 8 | Gravel | 0.6400000453 | 1 | 0.6400000453 |
| 9 | Water | 0.0800000057 | 1 | 0.0800000057 |
| 10 | Armco | 0.7199999690 | 1 | 0.7199999690 |
| 11 | Tire wall | 0.8000000119 | 1 | 0.8000000119 |
| 12 | Hay bale | 0.3599999845 | 1 | 0.3599999845 |
| 13 | Chain fence | 0.5600000024 | 1 | 0.5600000024 |
| 14 | Shrub | 0.3200000226 | 1 | 0.3200000226 |
| 15 | Forest | 0.3200000226 | 1 | 0.3200000226 |
| 16 | Wood fence | 0.6400000453 | 1 | 0.6400000453 |
| 17 | Chassis | 0.7199999690 | 1 | 0.7199999690 |
| 18 | Opponent wheel | 0.8000000119 | 1 | 0.8000000119 |
| 19 | Wheel | 0.8000000119 | 1 | 0.8000000119 |

These scalars are inputs to the original tire model, not a complete Coulomb friction coefficient. `0054d610`
combines the surface scalar with wear, temperature and pressure-dependent properties; `0054cab0` applies load,
camber, combined slip, relaxation states and tire curve tables. Copying these numbers into Roblox friction
properties would bypass the recovered model.

The tire pair callback is `00576e00`, reached through the original world contact passes. It supplies
`0055e1e0` with the plane, ground velocity, material masked by `0x3fffffff`, persistent contact state and
the product of the participating objects' grip fields at `+0x1ac`. For a static track object, material above 16
does not produce this tire contact. Material indices 17–19 describe vehicle parts, not ordinary track terrain.
The `0x40000000` primitive flag is checked separately before tire contact.

## Contact stiffness and damping

`00579cd0` builds the three rows for vehicle materials 17, 18 and 19. It combines the stiffness table at
`006f6148` and damping table at `006f6198` using `a*b/(a+b)`, retaining the original signed coefficients.
The row for material 18 additionally uses the opponent-wheel scaling at `00b8f258`; the single-player reference
has no opponent cars and leaves that scaling at zero. Rows 17 and 19 are track independent.
Accessors `00579e80` and `00579ea0` return these pair coefficients. Body-to-wall response is the separate
callback `00575920`, not a tire friction rule.

Contact state survives a pair while it remains active. `005778a0` initializes the anchor and zeroes state when
the pair first gains a contact. `00577fa0` updates its relative transform; `00578050` invokes the primitive
tests. Reinitializing each wheel's contact every tick would change the original relaxation behavior.

## Grass, dirt, sand and gravel bumps

The shaking effect has a recovered mechanism: `00513eaa` adds deterministic height changes to the queried
contact surface for materials **5, 6, 7 and 8**. It does not draw a new random number on each physics tick.
The original height table begins at `006f41d8` and contains 256 float32 heights in meters.

With the simulation FPU rounding control set to round toward negative infinity, the index is:

```text
i = floor(float32_round_down(dlong * 5.0)) & 15
j = floor(float32_round_down(dlat  * 5.0)) & 15
rough_height = float32_round_down(smooth_height + height_table[i * 16 + j] * amplitude)
```

The final addition follows the original float32 store semantics. The quantization constant at `006ea514`
is 5.0; the amplitude constant at `0074c36c` is 1.0 in this image. Nominal sample spacing is 0.2 m and the
16-sample pattern repeats every 3.2 m in each track-coordinate direction. The table ranges from
`-0.021250000223517418` to `+0.021925000473856926` m. Negative coordinates must use floor before the bit mask.
Truncation toward zero, nearest-integer rounding, interpolation, and per-frame procedural camera shake would
produce different contact behavior.

The lifted `NR2003CupTrackCode1.lua` contains `XF[0x513eaa]` and uses `fistround` with `floor`, along with the
float32 store helper `wfd`. The original height table, amplitude and quantization constant are present in the
assembled generated memory images. Several original track/primitive queries call this lifted function;
the geometry query has separate smooth and rough height outputs.

For materials **1–4**, `00513eaa` instead evaluates generated section-specific bump profiles. The track
initializer `005105c0` creates these once through `00510100`, seeds its generator by section and lateral band,
and restores the saved random state afterward. Runtime section fields `+0x1538` through `+0x154c` carry the
sample bounds, band arrays and longitudinal scaling. These are captured in the Watkins Glen track image.
Materials outside 1–8 return unchanged from this roughness function. This is a physics height mechanism;
normal-map and bump-map texture settings describe a separate rendering effect.

## Rolling resistance, heat and wear

`0054d610` evaluates rolling resistance using material-specific tables at `006f63c8` and `006f6418`:
the constant term plus the speed-squared coefficient, capped at 1.0 before pressure scaling. Examples are:

| Material | Constant term | Speed-squared coefficient |
| --- | ---: | ---: |
| Asphalt/concrete | 0.0025 | 0.0000007 |
| Grass | 0.04 | 0.000004 |
| Dirt | 0.02 | 0.000002 |
| Sand/gravel | 0.30 | 0.000015 |

The exact float32 entries are retained in `surface_tables.json`. Thus off-track behavior changes resistance,
contact compliance, grip and contact height; it is more than a grip multiplier.

The surface heat factor at `006f65c0`, accessed by `005100e0`, is 1.0 for asphalt, 0.9 for concrete and rumble,
0.6 for paint, and 0.0 for grass/dirt/sand/gravel. `0054d610` multiplies the relevant slip/rolling heat inputs
by this factor and by the track heat accessor `00510090`. Other thermal exchanges and cooling still execute.
Zero does not imply that the complete thermal system is disabled on an off-track material.

The uploaded Watkins Glen `track.ini` supplies:

```ini
track_tire_heat = 1.12
track_tire_wear = 1.0
track_tire_wear_loss = 0.20
track_tire_wear_exp = 1.11
track_asphalt_grip = 1.05
track_concrete_grip = 1.09
chassis_type = 4
```

`0054e9f0` advances the original wear/failure state, using accessor `00510080` for track wear. The recovered
wear-to-grip helper `0054ef10` applies `1 - wear_loss * wear^wear_exp`, with the original float32 and x87
operations. The full tire thermal/failure path continues to use the existing Stage 11 frame code.

## Coordinates and decoded query outputs

NR2003 simulation coordinates are meters with Z up. `005150fa` converts track `dlong`, `dlat` and a packed
hint into 11 pointer outputs: world X/Y, smooth Z, rough Z, normal XYZ, tangent XY, material as float, and
the adjacent material metadata as float. Its runtime section stride is `0x1550`; section base pointer is
`00bcf734`. Track length is `00bad918`; section count is `00bad920`. `0051370a` is the world-to-track inverse.

`005f58d0` writes the 0x58-byte query record used by the frame and world code:

| Offset | Meaning |
| ---: | --- |
| `+0x00..+0x08` | Input world point XYZ |
| `+0x0c..+0x14` | World velocity fields maintained by the caller |
| `+0x18..+0x20` | Projected smooth surface point XYZ |
| `+0x24..+0x2c` | Smooth surface normal XYZ |
| `+0x30` | Rough/contact height |
| `+0x34..+0x38` | Plan tangent XY |
| `+0x3c` | Track dlong in meters |
| `+0x40` | Track dlat in meters |
| `+0x4c` | Material integer, converted from the float output |
| `+0x50` | Adjacent material metadata integer |
| `+0x54` | Packed section/band hint |

The hint contains section index in bits 0–14, validity flag `0x8000`, height-band index in bits 16–23 and
material-band index in bits 24–31. Fields `+0x44` and `+0x48` are not assigned by `005f58d0`; do not invent
semantics for them. The additional material metadata's exact meaning is not established by this audit.

## Car specification and garage profiles

Cup chassis type 2 selects the specification at `007238e0`; type 4 selects `00723c70` through the original
series table at `00725ab8`. The complete **0x1c8-byte** specification records are byte-identical in the restored
NR2003 image. This confirms the earlier observation despite Watkins Glen selecting road-course type 4.
The earlier V4 integration preserved the existing user garage baseline. V5 loads the supplied original
track setup files through the recovered input/validation representation instead; the independent original
binary decoder checks and remaining driving differences are documented in `handling/VALIDATION.md`.
Identical specification records alone do not make different garage setups interchangeable.

## Startup pose publication before collision broadphase

The first physics frame must receive the placed world pose before a car is made active in the collision world.
The complete game coordinates this through its BG snapshot lifecycle. The minimal single-thread host performs
the equivalent publication eagerly by calling the recovered `005543f0` after the manual race-order insertion
in `enterTrack`, before the first `005789c0` broadphase. This is a host scheduling adaptation, not an additional
force, coordinate adjustment or change to the original placement function.

The original source evidence establishes these boundaries:

* `005512f0 -> 00551520 ->` foreground `00551760 -> 005b2f20` rebuilds the placed vehicle. None of these
  functions publishes the collision world record through `005543f0`.
* `005b2190` begins with `005789c0` and `00578a60`; its predictor export and `005543f0` publication occur later
  through `005539c0`. Relying on that later export leaves the first broadphase without a valid placed record.
* In the complete outer frame `0055bfd0`, `005a0b60` first publishes BG snapshots. `005a13f0` returns the record
  at BG object base `+0x164` only when flag `+0x324 & 0x10` is set. The caller assigns `car+0x5ae`, inserts
  the car into race order if necessary, calls `005637e0`, and then calls `005b2190`.
* `00554520 -> 005547a0` creates a full track query, quaternion and velocity record at frame end. `005a02b0`
  copies this 0x98-byte snapshot to BG object base `+0x04` and sets flags `+0x324 |= 0x27`. The player branch
  of the following `005a0b60` copies the initialized snapshot to its collision/interpolation records and marks
  the `0x10` publication flag.
* `005543f0` uses the existing placed state at `00bf6d40`, orientation at `00bf6d58` and velocity at
  `00bf6d44/4c/54`. When running in the BG context with a nonempty race ring, it writes the record at
  `00c0890c` for car zero, which is the collision object position at `BG_CAROBJ + 0x98`.

The original reference harness and Luau host must apply the same explicit startup publication. Compare their
subsequent trajectories only after this shared host boundary. The runtime report records the complete
123-section stability sweep and its results; this source audit does not invent a new original-game call site.

## Visual and fidelity boundaries

Physics obtains its surface ID from the original track data, independently of the visible texture. Rendered
terrain should sample the smooth-height output; collision uses the original query and bump mechanism.
The Roblox meshes are render assets and must not create a second tire-force source alongside the original
track world. World contact passes remain in the original 288 Hz simulation order.

The recovered W-section reader `005e7330` transfers custom wall profile bytes when `+0x49 == 1`; pointer
`+0x4d` references the 0x28-byte payload. `005e6f40` copies it verbatim. These reader/copy functions do not
establish its visual interpretation. Collision constructor `00511c9a` does not evaluate this custom visual
profile or read W-section `height_offset_mode` at `+0x45`: its collision top always uses the bank-normal
height, shifts the lateral position by `height*sin(bank_angle)`, and evaluates the ground at that shifted
position. Renderer recovery found visual mode **0 = bank normal, nonzero = world vertical**; the external
OpenNR-Tools header reverses this visual convention. Preserve the native collision construction independently.
Custom wall mesh interpretation, authored nonfinite UV values, detail overlays, seams and original
texture-slot blending belong to the separate renderer recovery; consult its report and final asset manifest.
The OpenNR-Tools viewer is a useful parser reference but ignores the custom wall payload and does not prove
that every rendering mode matches NR2003.

This source audit does not itself certify bit-identical complete gameplay. Use the original-code fixture
comparisons and runtime test report for tested tolerances, trajectories and unsupported host services.
The reference host includes documented adaptations for encrypted CRT helpers, single-thread task handling,
replay, audio and force-feedback outputs. Luau uses double arithmetic for x87 intermediates and explicit
float32 stores; the original x87 has wider intermediate precision. Exact source mechanisms and successful
tested trajectories must be distinguished from an untested claim of 100% end-to-end fidelity.
