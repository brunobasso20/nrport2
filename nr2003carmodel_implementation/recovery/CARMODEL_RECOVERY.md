# nr2003carmodel — recovery report (original Cup car model, cockpit, instruments, cameras)

Scope: everything NR2003 does to **draw the player's Cup car** and **place the camera** — resource files, the 3do scene
graph and how rendserv.dll evaluates it, the per-frame draw record and its interpolation, the node overrides of the
model draw (wheels, steering wheel, needles, shifter, head), the instrument and warning-light logic, the camera system
(inventory, order, offsets, look, FOV option, projection) and the unit / axis mapping to Roblox. **Damage is out of scope**
(the undamaged car is exported; no damage code was touched). Physics: nothing here writes a physics cell.

Toolchain: the OpenNR2003 Ghidra project (`OpenNR2003.gpr`, programs `NR2003.exe` and `rendserv.dll`, owner
`TChapman500`) opened read-only with Ghidra 11.1.2 headless and the repository scripts `recovery/ghidra_tools/*Py.py`
(+ `recovery/ghidra/ExportsPy.py`, symbol listing of rendserv.dll); memory images exported with `ExportMemoryPy.py`
(`NR2003_MEM` = the image of every earlier stage; `RENDSERV_MEM` = rendserv.dll); Unicorn 2.1.4 for the original-code
harness `recovery/orig_carmodel.py`; Luau CLI 0.741. Decompiled listings + annotated disassembly of every routine cited
here: `recovery/evidence/exe/<address>.c|.asm` (237 functions) and `recovery/evidence/rendserv/` (24 functions), each
with `index.tsv` (callers / callees). File formats were cross-checked against OpenNR-Tools (MIT) `docs/formats/*.md`
and its readers; every reader in `pipeline/nr2003res` consumes its input completely and raises on anything unknown.

## 1. Resources (what the game loads for the player car)

| Resource | Loaded by | Content |
|---|---|---|
| `<series>/cup.dat` | resource system | Papyrus DAT archive; entries PKWARE DCL "implode" compressed when flags & 0x0200 (`pipeline/nr2003res/dat.py`, `dcl.py`) |
| `make_a.3do` | `004287a0` / `004296b0` | the car: body LODs × 4 makes (`carMakeIdx`), cockpit, driver, wheels, damage branches |
| `make_a_light_cockpit.3do`, `make_a_shadow.3do` | `0042a5a0` / `0042a660` / `00429800` | outside gauges / lights, shadow (converted, not wired: §8) |
| `make_a.cam` | `00568610` → `00567e10` | chunk `MACC` (216 bytes) = 6 on-car cameras × 9 floats (pos, hpr, fov triple) for modes 10..15 |
| `*.mip` | texture manager | BMAP / BMHD / DATA chunks, DXT1 / DXT3 / 16-bit formats, colour key, clamp flags (`mip.py`) |
| `cars/<name>.cup.car` | car roster | `CARF { CTYP, CINI, CTEX, CREW }`; **CTEX replaces `card.mip`** for that car (`car.py`) |

3do: typed object stream (`obj3do.py`): object / class handles, descriptor header (version, name), allocation-size
prefixed arrays; classes used by the Cup car: Empty, Group, LodSwitch, StateSwitch, Transform, AnimatedTransform,
Billboard, SelfLighting, Portal, Shape, Geometry, TriList / TriStrip / TriFan, PlainVertexList, RegionMorphVertexList,
Texture, Appearance (readers `005e07f0`, `005e11f0`, `005e0c40`... per OpenNR-Tools' descriptor map). Strip winding
alternates, degenerate triangles are dropped; orientation check against the authored normals: 14 005 agree, 26 disagree
(kept as authored).

## 2. Scene-graph evaluation (rendserv.dll compiled nodes)

| Node | rendserv | Rule (ported in `NR2003CarModelRig.lua`, Python twin `pipeline/nr2003res/rig.py`) |
|---|---|---|
| Transform | — / `005f6f20` | child = T(t) · R, R = Rz(h) Ry(p) Rx(r), row-major |
| AnimatedTransform | `10012810` (+ `10028290` quat → matrix) | keys (time, quat x y z w, t); bracket = first key with t < key.time; translation lerp; quaternion nlerp with the sign flipped when \|q2 − q1\|² ≥ 1; t ≤ key0 → key0, past the end → last key |
| StateSwitch | `10011ec0` | v = variable (+0x38); child i with values[i] ≤ v < values[i+1]; v = values[n] → n−1; v outside [values[0], values[n]] → nothing; pushes a blend fraction on `10042a74[[10042ab4]++]` (per-frame stack, irrelevant for the draw) |
| LodSwitch | `100118e0` | level = first threshold ≥ distance (thresholds[1..]); the renderer's detail floor (vf +0x154) raises the level **only when it is below the level count** |
| Variables never bound by the game | — | keep their 3do default (e.g. `animate_wheel`: the string does not exist in NR2003.exe) |

## 3. The draw record and its interpolation

`00551990` (frame end, ported in Stage 11) writes the car snapshot cells `car+0x1508..0x15b4` (car = `0xc12030`):
rpm `+0x1508` (= engine+0x484), oil pressure `+0x151c` (= car+0x4dc), `+0x1520` = decoded protected float car+0x4b0 /
+0x4b8 (`00425e80`), `+0x1524` = `*(car+0x4e8) ^ *(car+0x4e0)` (protected), fuel pressure `+0x1528`, voltage `+0x152c`,
head `+0x153c..44` (= head-state displacement + modelinfo head `00562f50`), filtered pitch / roll `+0x154c / +0x1550`,
mean front hub steer `+0x1554` = (bf6d7c + bf6d94) · 0.5, roof flap `+0x15ac`. `00565880` gathers them into the draw object
(gauges `drawobj+0x64..0x80`, rates `+0x54..0x60`, flags `+0x30`) and the per-tick record (`005ba150` slot):

| record | car cell | `005ba170` rule (render alpha between the last two records) |
|---|---|---|
| 0x98..0xb0 | 0x1594, 0x1598, 0x159c, 0x1590, 0x15a0..0x15a8 (shift arm) | lerp |
| 0xb4 / 0xb8 / 0xbc | 0x1588 / 0x158c shifter, 0x1554 steer | lerp, wrap to [−π, π] (`006e97f8` / `006f4638`, step `006ee484`) |
| 0xc0..0xc8 | 0x153c.. head | lerp |
| 0xcc / 0xd0 | 0x1548 heading / 0x154c head pitch | lerp, wrap |
| 0xd4 | 0x1550 head roll | shortest path through ±π/2 (`006ee480` / `006f59cc`), lerp, wrap |
| 0xd8..0xe4 | 0x1558.. wheel z | lerp |
| 0xe8..0xf4 | 0x1568.. wheel spin | prev + (1 / taskRate) · rate(newer, drawobj+0x54..) · alpha, minus round(x / 2π) · 2π (`006f7598`, `006efb78`, FISTP nearest) |
| 0xf8 | 0x15ac roof flap | lerp |

Port: the server samples these cells (read-only) at every render snapshot and sends them with the snapshot's sequence
and server time (`NR2003DrawState`); the client applies the table above at the same render time as the body pose.
Δt between records = the record interval (the original's consecutive ticks).

## 4. Model draw `005662d0` (evidence `exe/005662d0.c|asm`)

Flags `drawobj+0x30`: bit 0x10 = focus car, bit 0x20 = car visible, bit 0x01 = cockpit camera.

* `cockpitView` (binding +0x20): not focus → 0; focus & hidden (bit 0x20 clear) → 10; else bit 0x01 ? 1 : 0.
* `mirrorFrameEnable` (+0x24) = `[00750194] == 0 ? 2 : 0`; option bindings +0x28 / +0x2c = graphics options
  (`005d44c0` +0x08 / +0x0f, +0x2c also 0 when session flag 0x80000) → `steeringWheelEnable` / `windshieldEnable`
  (image defaults: animated wheel and windshield on); roof flap `+0x54/+0x58` (`[rec 0xf8] ≥ 006ea4a4` → 1 and
  `roof_flap_state` = _ftol); backfire frame `+0x60` = `drawobj+0x88`.
* **Needles** (focus car, every view): `0056edd0(spec = car+0x58a)` → `0056f040(spec + off, v)`:
  ptach ← rpm (0x148; `drawobj+0x6c` while control 3 is held), pfuel ← +0x7c (0x168), pwater ← +0x78 = car+0x1524
  (0x178), poilt ← +0x74 = car+0x1520 (0x188), poilp ← +0x70 (0x198), pvoltage ← +0x80 (0x1a8); node rotation
  vf2(0, rest pitch, angle). `0056f040`: clamp to [v0, v1] (NaN → v0), linear to [deg0, deg1], × `006f5cd4` (π/180 f32).
* **Warning lights** (focus car): tach = !(getBGCount bit 4) && revLimit − 500 < rpm (`006f58f8`, rev limit
  `*(car+0x576)+0x2c`); water = 110 < `drawobj+0x78` (`006ee574`); oil pressure < 2.0408 atm (`006f5a4c`, 30 psi);
  fuel pressure < 0.30612 atm (`006f5a48`, 4.5 psi).
* **Steering wheel**: a = clamp(−(`00554fb0`() · steer), ±2.79) (`006f5e70` / `006f5e6c`); bit 0x01 → steer node
  vf2(rest h, rest p, a), shifter vf2(rest h, rec 0xb4, rec 0xb8); else `timeValue` = 10 · max(0, _ftol(…)) for the
  driver / wheel AnimatedTransforms.
* **Head node** (+0x140, every view): vf0(rec 0xc0..0xc8); vf2(0, rec 0xd0 − p, rec 0xd4 − r) with (h, p, r) =
  `005f74c0`(rec body matrix) (asm `00566525..0056658a`).
* **Wheels**: lf / rf vf0(rest x, rest y, rec 0xd8 / 0xdc), vf2(steer + 1.570795 (`006f5e74`), rest r, spin); lr / rr
  vf0(rest x, rest y, rec 0xe0 / 0xe4), vf2(rest h + 1.570795, rest r, spin); `wheel_speed_N` = `00565b10`(\|rate\|):
  < 20 → 0, < 60 → 1, else 2.

Note — engine cells: the water needle and the water light read `car+0x1524` = engine+0x4d4, which
`STAGE11_STATE_MAP.md` labels "oil temperature" (initial 0 °C, rises slowly); the oil-temperature needle reads
engine+0x4a4 (labelled "water"). The port follows the ORIGINAL draw path; the Stage 11 labels are left unchanged (physics
untouched) and this note records the discrepancy.

## 5. Cameras (`exe/0056a9a0`, `00569b10`, `00568e20`, `00569450`, `005697e0`, `00567e10`, `00587e70`)

| Mode | Name (`0056b960`) | Placement in `0056a9a0` (body = interpolated record) | FOV triple / near |
|---|---|---|---|
| 1 / 2 / 3 | cockpit / LookLeft / LookRight | eye = body + R_b (head + (0.1, 0, 0.1) `0074ebbc`); R = R_b · Euler(look, headPitch − p_b, headRoll − r_b) | fov = opt + look · 4/π · (c5736c − opt), (0, −0.125), 0.2 |
| 4 / 6 | F10Near / Chase | xy = body + R_b (−6, 0); z = body z + 2.25 (`00411770`); R = Euler(h_b, 0.18, 0) | (1.36126, 0, −0.125), 0.4 |
| 5 / 7 | F10Far / Far Chase | eye = body + R_b (−9, 0, 4.0); R = R_b · Euler(0, 0.1995, 0) | idem |
| 8 | Rear chase | xy = body + R_b (5, 0); z + 2.25; R = Euler(h_b − π, 0.24, 0) | idem |
| 10..15 | Nose, Gearbox, On Car, Roll Bar, F Susp, R Susp | eye = body + R_b · pos(.cam); R = R_b · Euler(hpr(.cam)) | fov(.cam), 0.2; car hidden in 10, 11, 14, 15 (`0056bb30`) |
| 9, 16..21 | Sky, Zeppelin, Pit Lane (2), TV1..3 | need the track system | not ported (no substitute camera) |

Chase cameras keep the eye ≥ 1 m above the track (`006e97d8`) — read from the code; not exercised by the vectors (no
track loaded in the harness). Order while driving (`00411530` / `00411550`, tables `006ec798` / `006ec7f0`): next
1 → 13 → 4 → 5 → 10 → 1, previous the reverse (cockpit only when session flag 0x80000). Look (`00569450`): digital
controls 0x54 / 0x55 switch cockpit ↔ LookLeft / LookRight when the eased value is 0; analog axis = right − left with the
dead zone `0074eb98` and the smoothing `0.5^(T/dt)` (`0074eb94`); easing `005697e0`: 0.1 s full travel, x² towards 0,
1 − (1 − x)² towards 1, × π/4; mode changes `00568e20` convert the eased value (`00569260(00569210(x))`,
`00569230(00569250(x))`). FOV option: degrees in `00894ee8` (default 65, `00440a30`), read × `006ec778`, written ×
`006ec77c` (`00411850` / `00411860`), controls 0x6d / 0x6e ± `006e97f0` clamped to `c5c27c` / `c5736c` (65 / 78 deg,
`00567a80` / `00567ab0`). Final clamp [0.25°, 110°] (`0056b388`).

Projection (`00587e70` + rendserv `100043a0`): the FOV is the **horizontal FOV of a 4:3 view**; wider displays keep the
4:3 vertical FOV (Hor+) → Roblox `FieldOfView` = 2 atan(0.75 tan(fov / 2)), exact at any aspect ratio. Widescreen
branch `00587e7e..00587ed8` (evidence `exe/00587d20.asm`): when the focus draw object has the cockpit bit (0x01) the FOV
is replaced by `006f69a0` = 1.1343804537521816 (65°); then vertical = 2 atan(0.75 tan(fov / 2)), horizontal at the display
aspect = 2 atan(aspect · tan(vertical / 2)), clamped to 2.5 rad (`006f697c`; inactive at 16:9, where 78° gives 94.4°). With
the branch off the game uses the 4:3 value as the horizontal FOV of the whole view (a 4:3 display); the port's
`NR2003WidescreenProjection` = false keeps Hor+ (exact only for a 4:3 viewport). The frustum shift (0, −0.125) has no Roblox
equivalent: the view is tilted up by atan(0.125 tan(vfov / 2)) so the original view axis lands on the same screen row
(attribute `NR2003CameraShift` = false disables it) — an approximation, documented as such.

## 6. Scale and axes

NR2003: metres, +X forward, +Y left, +Z up. Roblox bench: studs, (x, y, z) → (−y, z, −x) / 0.28 (`METRES_PER_STUD` =
`TestTune.metresPerStud` = `CupTune.metresPerStud`), rotations R_rbx = B R B^T. Evidence of 1:1 scale: the 3do wheel
nodes (1.207005, ±0.768351) / (−1.587, ±0.768351) equal the physics hubs of the ORIGINAL component records
(CupTune 1.2070 / 1.5870 / 0.7684) to 5e−5 m, with no rescaling; tyre radius 0.354 m. `NR2003Scale` is the one module the
future track import must use.

## 7. Original-code harness (`orig_carmodel.py`) and golden vectors (`gen_fixtures.py`)

`Exe`: boot of the Stage 6/7 image, `0051370a` / `005150fa` (track queries) patched to `ret`, the original `00567e10`
table initialisation, `<model>.cam` written to `c57450`; calls `0056f040`, `005f6f20`, `005f74c0`, `00565b10`,
`00569210..00569260`, `00569b10` and `0056a9a0` (draw object with the body record at +0 / +0x18 / +0x58, record slot
drawobj + 0xf8, `[ebbd78]` = `[ebbd84]` = 0, view +0x0c mode / +0x10 car, look block view + 0x1c). x87 results through a
per-target `fstp` trampoline. `Rendserv`: rendserv.dll image in its own Unicorn; `10011ec0` (blend-stack index reset per
call), `100118e0` (renderer stubs for vf +0x28 far value / +0x154 floor), `10012810`.

## 8. Not recovered / not ported (with reason)

* Rear-view mirror (Portal `rearView`, `mirrorFrameEnable`): needs a second render target — not in Roblox.
* SelfLighting / night (`day_night` = 0 = day), headlights, backfire sprite animation: day only.
* Track cameras (Sky, Zeppelin, Pit Lane, TV): need the track system (stage after 14).
* LOD scale factor of the renderer (detail option): `lodScale` = 1, floor 0 (default detail).
* `make_a_light_cockpit` (outside gauges for other cars) and `make_a_shadow`: converted, not wired.
* Texture `factor` field of the MIP header and the 3do material colours: carried in the descriptor, not applied (Roblox
  MeshPart has no equivalent); glass opacity < 1 → Part.Transparency = 1 − opacity.
* Damage: undamaged branches only (out of scope by request).
