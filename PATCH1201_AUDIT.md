# NR2003 1.2.0.1 physics audit

The existing port's reference is **already 1.2.0.1**, including its suspension and tire code. Applying another
percentage reduction to camber, grip or drafting would introduce behavior unsupported by the original game.
This branch corrects Watkins Glen FAST/QUALIFY preset data from the supplied official patch, adds K preset cycling
and a comma-key telemetry toggle, and retains reproducible version, camber and surface-grip evidence. The existing
physics equations remain intact. See [Studio installation](STUDIO_PATCH1201.md).

## Reference identity: verified directly

Both repositories were inspected at their current heads: `nrport2` at `4a6d07fbc196f331b505fe07e3cabea04ef57710`,
and `TChapman500/OpenNR2003` at `03bcafb44cf63464493f1864edbd9f781fac24f4` (also the port's recorded upstream).
The later Studio attachment was also compared against `codex/watkinsglen-driving-test` at
`e949f5db1a58508999721cd8bca75c8af20408c4` and the Stage 14 downloads branch. This implementation branch builds
on that current Watkins Glen branch. The attachment combines its road-course physics with Stage 14 checkpoint code.
The latter contains a Ghidra project, rather than a complete compilable source tree.
`ExportPatchBaseline.java` exported the original imported FileBytes in read-only/no-analysis mode:

| Observation | Result |
| --- | --- |
| Original filename | `NR2003.exe` |
| PE RT_VERSION file and product version | `1.2.0.1` (numeric fixed structure, English resource 1033) |
| File SHA-256 | `27e76919be6722bee0dcaddc92454fea338e99a97404df6220448314feb4500a` |
| File length / CRC32 | 5,423,105 bytes / `d6335778` |
| Supplied Wise game delta target fields | Same length and CRC32, payload 15, offsets 9 and 5 respectively |
| Port's three committed `recovery/vehicle_core/*.bin` ranges | All byte-identical to the corresponding mapped PE bytes |

See [reference_identity.json](recovery/patch1201/evidence/reference_identity.json). Version identity is established
by the resource and executable bytes; the September 2003 PE timestamp is corroboration only. The Wise header
fields are observations for this pinned patch, not a claim to have implemented its delta format. CRC32 alone is
not a cryptographic proof of file equality; the SHA-256 identifies the exact upstream file used here.

The attachment SHA-256 is `f69747db9865ec560d93b09201ff6c0f687987110aac1eb16947be5b019ca6f5`; its installer is
`20a0e4c6febe68ac7fb008f7af90a9d83b5efee32509bf4ff2fb0ed5254f6134`. All 123 contiguous raw-DEFLATE payloads
were extracted with CRC validation through EOF, including the two alignment bytes. Of these, 39 have the Wise
binary-delta signature. The game executable is a delta, not a complete embedded game EXE. Installer code was
never treated as vehicle physics. [The inventory](recovery/patch1201/evidence/patch_inventory.json) records hashes,
compressed ranges, recovered destination labels and the 29 printable track-INI assignment literals.
The extraction report/PDF mentioned in the task brief were not among the supplied files or repository artifacts.

## Bump camber and steering: existing patched behavior

The original `0055e9b0` builds the inclined suspension/hub geometry; `00424860` derives static camber from the
garage values and static deflection. The per-wheel emitter `0055d9c0` generates the tire path. Existing lifts are
`core/NR2003Cup/NR2003CupBuildCode3.lua`, `NR2003CupJIT3.lua`, and generic `NR2003CupJITG3.lua`. Original
function evidence is in `recovery/stage10/evidence/b1` and `b2`; the detailed prior geometry recovery is
[hubgeometry.md](recovery/stage12/evidence/reports/hubgeometry.md).

For a front wheel, the recovered tire path evaluates:

```text
a = bumpSteerCoefficient * suspensionTravel
b = camberGain * suspensionTravel + camberOffset
localAxle = (sin(a), cos(a)*cos(b), sin(b))
worldAxle = wheelAttachmentRotation * localAxle
forward = normalize(worldAxle cross contactNormal)
lateral = normalize(contactNormal cross forward)
camberArgument = dot(worldAxle, contactNormal)  // 0054cab0 parameter 11
```

The Cup front spec gain at `spec+0x7c/+0x80` is approximately `-0.3092114 rad/m`; build cells `c08224[w]`
use opposite signs for LF/RF. `spec+0x88` is zero in the recovered specs. Hub steering rotates about the inclined
caster/KPI axis; chassis roll acts through the world rotation and contact normal. The setup's static compensation
and the runtime travel term must both be retained. There is no evidence supporting an additional 30–40% reduction.
The patch readme separately describes reduced bump effects and corrected steering camber fall-off; their exact
numerical differences from 1.0 cannot be measured without that older executable.

The new [generator](recovery/patch1201/gen_camber_reference.py) independently executes the original build,
predictor and tire path in Unicorn 2.1.4. It uses two real garage conversions (5.0/5.5 inch LF ride height), five
travel coordinates (-0.02, 0, 0.05, 0.10, 0.13 m), three steering angles (-0.2, 0, 0.2 rad) and three body rolls
(-0.05, 0, 0.05 rad). It captures the actual tire-force camber argument from `tire+0x2bc`, plus the wheel matrix
axis used for presentation. Expected values do not come from Luau or an invented approximation.

**Result:** 90 controlled poses, 360 scalars, maximum absolute Luau/x86 error **0**, acceptance tolerance `2e-6`;
10 checks pass. A test-only mutation disabling front camber gain is detected on both tires. At fixed setup,
100 mm of imposed travel changes LF/RF camber arguments by approximately `+0.03087015/-0.03087016`, while
the multibody wheel axes stay unchanged. Steering and roll alter the tire inputs as expected. The latter distinction
explains why visual wheel tilt alone is insufficient evidence of a physics defect. No independent camber port bug
or causal explanation for the reported unstable driving was established by these probes.

These are kinematic probes, with zero imposed motion; they do not test spring settling or claim complete vehicle
equivalence. At fixed travel the two garage heights yield identical camber arguments in this experiment.
See [reproduction notes](recovery/patch1201/README.md) and [test output](tests/patch1201/RESULTS.txt).

## Official driving-related changes: coverage and limits

The full extracted `readme12.txt` was inspected. The table distinguishes existing recovered 1.2.0.1 paths from
unmeasured changes relative to 1.0. Existing reference-test coverage does not prove every input or integration path.

| Official item | Existing patched reference / port | Status in this audit |
| --- | --- | --- |
| Reduced front bump camber | `0055d9c0`, `0055e9b0`, JIT/JITG tire callbacks | Direct matched pose regression added; older curve unavailable |
| Corrected camber fall-off with steering | Same geometry, `00424860`, Stage 12 steering | Direct steering/roll poses match; no 1.0 function pair |
| Softer front spring motion ratio | `00423ee0/00423f00`, `NR2003CupSetup.lua`, Stage 10 build | Already uses front MR 0.56 (wheel rate scales by MR squared); existing conversion/build regressions pass |
| Superspeedway drag/downforce maps | Stage 9, `00561a80/00561b70 -> 00410280`, `NR2003CupAero.lua` | Patched source identity established; no old/new table diff recovered |
| Extended low-height downforce/balance maps | Same aero chain, `00410b50` | Existing Stage 9 low-ride-height cases retained; no newly inferred map extension |
| Reduced draft effects | `005afd80`, `005b0230`, `NR2003CupAero.lua` | Existing original wake model and speed/separation tests retained; no extra reduction applied |
| Chassis clearance and bottoming friction | Original collision world, Watkins Glen WIP | Track/body-contact integration remains partial; no complete bottoming parity claim |
| Restrictor-plate rear weight limit | Stage 10 spec-dependent setup/build chain | Requires targeted plate-track boundary validation; default chassis setup tests alone are insufficient |
| Increased wear from hot tires | `0054e9f0`, Stage 11 `NR2003CupFrame.lua` | Existing original thermal/wear path and hot-tire regressions retained; pre-patch coefficient delta unknown |
| Stability-control effect on wear | Stage 11/12 runtime/input chain | No new focused assist-to-wear equivalence established; remains unresolved |
| Setup ranges applied on load | Stage 10 setup validation/rebuild | Existing range/conversion tests retained; historical file migration not newly validated |
| Digital throttle/brake may disable TC/ABS | Original driver/options chain | Not newly verified for all device/assist combinations |
| Bristol-Night apron extended surface type | Track data update | Changelog evidence only; corrected material record not independently decoded here |

There is no verified before/after evidence here for altered player tire force/slip curves or global asphalt,
concrete, grass, dirt or sand coefficients. The Watkins Glen INI assignment literals change AI acceleration and
braking modifiers, not player tire friction. The Bristol-Night correction must not be generalized to other surfaces.
The existing dynamic regression suite exercises driving, braking, aero, drafting, tire heat/wear, garage, steering
and FFB; current results are recorded separately from this new pose test.

**Fully verified in this work:** reference version and memory identity; patch extraction/inventory; the sampled
patched camber inputs matching the existing Luau implementation. **Partially covered:** other existing patched
models through their prior reference suites; track/body contact remains WIP. **Unresolved:** exact function/data
differences against 1.0, the additional targeted checks above, and the cause of the user's driving instability.
No new core equation was justified. The installed FAST/QUALIFY setup data did differ from the official patch and
was corrected as described below.

## Actual Studio snapshot and the verified correction

`atnow.rbxm` contains 925 instances and 147 source-bearing modules. Its SHA-256, 20 loaded grip values, six
material constant tables and four thermal/wear inputs are retained in
[studio_grip.json](recovery/patch1201/evidence/studio_grip.json). All match the recovered Watkins Glen inputs
and the original 1.2.0.1 grip-loader multiplication executed directly in Unicorn. Asphalt is `0.8399999738`,
concrete `0.8371199965`, grass `0.4639999866`, dirt `0.5199999809`, sand/gravel `0.6400000453`.
These are original model inputs, not complete friction coefficients. The built-in table at `006f6570` supplies
the approximately 0.8 scale; it is not an invented reduction. The executable's initial/unloaded `0074fb30` values
must not replace the track-loaded table. The raw INI is absent from the snapshot; its inputs are independently
retained by the current branch's surface recovery, rather than recovered anew from a supplied INI file.

Actual Studio modules also pass the 90-pose camber regression (360 exact values), plus 27 surface/roughness and
grass/sand native-contact checks. Active Watkins contacts bypass the Roblox raycast `NRGripMultiplier` path.
The model's road chassis and tire profile match the current road-course implementation. This is stronger evidence
than merely checking a version string, but is not an exhaustive proof of the entire game or every track geometry.

The supplied patch contains complete Watkins `fast.cup.sim` and `qualify.cup.sim` payloads 116 and 119. Comparing
their setup chunks with the actual installed preset module revealed 24 and 26 raw-field differences respectively.
The default FAST pressures were 22.5 psi all round; the official replacement uses 21 psi front / 20.5 psi rear.
Front springs, camber, caster, shocks and other saved setup items also differed. Both presets now use the official
raw values and file hashes, with no UI resnapping. The original x86 setup decoder/validator independently supplied
the expected loaded values. EASY and JASPER are preserved: the official patch does not replace those Watkins files.
This does not claim that those two files were found in the patch. Details: [SETUPS.md](recovery/patch1201/SETUPS.md).

K selects the next preset, clears individual garage overrides, and resets at the original track spawn. The server
retains driver authorization; Stage 14 starts a new prediction epoch using its existing reset path. Comma toggles
only `NR2003LabHUD`. The Studio update checks source fingerprints, backs up changed scripts, supports repeat
application and includes rollback. Keyboard steering momentum remains the user's existing configurable setting;
the snapshot uses 0 rather than the original image's default rate, so not every device preference is a stock default.

Validation: 19 patched-setup checks, 280 setup-load field comparisons, 24 control checks; installer results are
recorded separately. The full Stage 6–13 runner passed on the initially inspected `main` (2,153 PASS lines, no FAIL,
ending `syntax OK`). Subsequent current-road-course validation is focused on the changed presets and native contacts.
The old FAST driving-trajectory fixture is replayed with its explicitly retained old preset. Its recorded input,
expected output and tolerance are preserved; it is not used as an expected trajectory for the corrected preset.

## Reproduce and continue

Run `luau -O2 --codegen tests/patch1201/run.luau` with the committed fixtures. The full existing regressions run via
`LUAU=/path/to/luau COMPILE=/path/to/luau-compile sh tools/run_stage13_tests.sh`.
The latter regenerates historical packages/mocks; on this Watkins Glen WIP head those generated artifacts can
differ from their published versions, so review generated changes separately before committing them.

For fresh evidence, use Ghidra 12.1.4 and a full JDK 21+ on a local clone of OpenNR2003:

```sh
JAVA_TOOL_OPTIONS=-Duser.name=TChapman500 /path/to/ghidra/support/analyzeHeadless \
  /path/to/OpenNR2003 OpenNR2003 -process NR2003.exe -readOnly -noanalysis \
  -scriptPath /path/to/nrport2/recovery/patch1201 \
  -postScript ExportPatchBaseline.java /local/scratch/baseline /local/scratch/memory
python recovery/patch1201/extract_patch.py /path/to/patch.zip /local/scratch/patch
python recovery/patch1201/identify_reference.py /local/scratch/baseline/imported-0.bin \
  --patch /path/to/patch.zip --output /local/scratch/reference_identity.json
```

Unicorn fixture regeneration is documented in `recovery/patch1201/README.md`; Studio checks are in `VALIDACAO.md`.
Keep extracted executables, deltas, original memory and game data in scratch, outside git.

To perform the requested 1.0-versus-1.2 function/data and camber-curve comparisons, the missing input is the
**unmodified English retail `NR2003.exe`, version 1.0.0.0**. Its purpose is the pre-patch physics reference and,
if supported by a delta decoder, reconstruction of the official updated file. `server.exe`, the Wise installer,
or another modified executable cannot establish that baseline. The patched reference is already available.

REA 6.5.0 / skill 42 was installed locally with the supported Skills CLI after the global skill destination proved
read-only. No Codex MCP configuration was changed. REA CLI archive and PE-resource inspections are retained under
`recovery/patch1201/evidence` (Evidence IDs `ev_8b41c9bbe8c8e330bb763986fff21b56f44da1665ae73518bf9b53e0d4111a5b`,
`ev_4bf0c157095fa36efa50601a94fb9bc120fc8ee9c2db2278f77f434cc03156e5`,
`ev_bffdd67b207cb23da1ff0d77e23dd5a7a6830375eb82f9bd0c5d967933227cd1`). Those tools retain opaque resource
payloads; version decoding and byte comparisons were performed by the repository scripts. REA's native-provider
doctor reported `runtime_missing` for the installed JDK; direct Ghidra read-only export and Unicorn execution
worked. Native MCP tools were not connected, and no unavailable REA decompilation is claimed.
