# Driving assists — NR2003 1.2.0.1

`assist_implementation` enables the original automatic transmission, auto clutch and ABS for testing. Traction control, stability control and low-speed steering boost default off. Tire grip, engine curves and the four Watkins garage presets retain their recovered values.

[Studio installer and instructions](assist_implementation/README.md) · [Download ZIP](assist_implementation/NR2003_Assist_Implementation.zip)

## Original mapping

| Assist | Original state/routine | Integration |
|---|---|---|
| Automatic transmission | `74c974=0`; `00562f90` thresholds, `00553920` predicted RPM, `005536b0` selection | New numeric module requests shifts at the original frame-tail slot; existing `00553d70` executes them. |
| Auto clutch | `005542e0`: `74c974!=3`; `005542f0` engagement ramp | Existing original clutch/shift FSM. Manual + auto clutch uses method 1; manual clutch uses 3. |
| ABS / Anti-Lock Brakes | `bf6f04`; `00550130`, `00553080` | Original brake-pedal assistance, including low-speed reduction and tire-slip feedback. No replacement per-wheel controller. |
| Traction control | `bf6f05`; `00550180`, `00552df0` | Original throttle-pedal reduction from rear-tire slip and speed. Digital pedal ramps apply even when TC is off. |
| Stability control | `bf6f06`; `005501d0`, `00561e50` | Existing lifted original chassis corrective forces and yaw moment. |
| Low-speed steering boost | `74c9a0`; `00550110`, `00554fb0` | Existing original steering-ratio override; now defaults off as requested. |
| Steering help | `bf6f08`; `00550230`, positive branch of `00552720` | **Unavailable with supplied track data.** The original racing-line pointers/data are absent. Remains off and guarded. |

Race settings `c0692a+4c` bit 29 disables ABS, TC, stability and steering-help getters. It does not disable automatic transmission or auto clutch. Telemetry reads the effective original cells and this gate, and shows booleans rather than inferring assists from the setup name. These are enabled states, not claims that each assist is intervening on every tick.

Automatic shifting uses original float32 stores with simulation-task rounding toward negative infinity and original constants, including the exact downshift-equality comparison. The original global tire-profile pointer table was omitted from the earlier packaged runtime image. The implementation reads the identical profile objects already bound to the built car's two rear tires by `0054c1c0`; native fixture generation verifies those bindings against `0056ed60`. It does not substitute a guessed rolling radius or an RPM-only shift rule. Details: [automatic recovery evidence](recovery/assist_implementation/automatic_evidence.md).

## Test configuration

Car attributes, read at initialize/reset:

| Attribute | Default |
|---|---|
| `AutomaticTransmission` | `true` |
| `AutoClutch` | `true` (automatic transmission also uses auto clutch) |
| `ABS` | `true` |
| `TractionControl` | `false` |
| `StabilityControl` | `false` |
| `SteeringLowSpeedOverride` | `false` |
| `SteeringAssistance` | `0`; positive values require missing original racing-line data |

The core API is `vehicle:setDrivingAssists({...})` / `vehicle:drivingAssists()`. Direct numeric users retain the original packaged defaults until they call the setter; the Roblox adapter applies the requested testing defaults from `CupTune.driver.assists`. Changing garage presets does not silently change assists.

The separate assist HUD lives inside `NR2003LabHUD`, follows the existing telemetry panel, and reads live `DrivingAssist_*` attributes published by the adapter. Comma therefore hides it with the rest of telemetry. The installer preserves the supplied Stage 14 client, renderer, protocol and server-authority behavior. It carries forward the existing checkpoint hooks into the checked-in numeric sources and adapter. This is an update for the installed Studio project, not a new complete Stage 14 Rojo distribution.

## Verification

Reference: `TChapman500/OpenNR2003` commit `03bcafb44cf63464493f1864edbd9f781fac24f4`, imported NR2003.exe **1.2.0.1**, SHA-256 `27e76919be6722bee0dcaddc92454fea338e99a97404df6220448314feb4500a`. Supplied `atnow.rbxm` SHA-256 `2db67cbb01093d604a84d3ea23ff24514275a76e9776710c54cc9c8628ac7024`.

The same Reverse Engineer Anything skill's evidence discipline was applied: original addresses, immutable reference identity, independently executed x86 fixtures, and explicit unavailable behavior. Its managed native provider remains unavailable in this environment, so original instructions were inspected through the existing Ghidra project/assembly exports and executed in the documented Unicorn harness. Recovered pseudocode is not original source code. The game installer and game itself were not launched.

| Check | Result |
|---|---|
| Automatic threshold initialization | 50 cells bit-exact |
| Predicted RPM | 102 vectors, float32-down exact; maximum relative intermediate error `1.24e-16` |
| Automatic selector | 588 cases bit-exact, including adjacent threshold values, skipped gears, modes and shift phases |
| Throttle/TC | 1,440 vectors, output bits and digital-key state exact |
| Stability | 36 vectors, all 252 force/scalar bits exact; real corrective forces exercised |
| Existing brake/ABS suite | 3,000 pedal vectors bit-exact; 49 checks pass |
| Existing steering suite | 52 checks pass |
| Automatic driving/replay | 10 checks pass; 12 seconds without manual shifts; native memory replay exact |
| Watkins FAST/EASY/QUALIFY/JASPER | All four run original contacts with these defaults, reset and replay exactly |
| Production adapter | 15 checks pass: defaults, attribute overrides, telemetry and Stage 14 local-host startup |
| Studio installer | 89 checks pass against uploaded and repository baselines: actual XML/payload sources, guarded preflight, repeat apply, write-failure recovery, rollback and Play-mode refusal |

Reproduce the focused checks with `bash tools/run_assist_tests.sh`. Set `NR2003_STUDIO_EXPORT` to an extracted script directory to include the uploaded snapshot in installer tests. Native fixture generators are in `recovery/assist_implementation`; they require the same reference-memory export and Python Unicorn environment as the earlier recovery stages. Fixtures and result logs are retained in `tests/assists`.

The full loaded Watkins image has a non-null car-world record but a zero `bd7960` racing-line pointer. `orig_world.py` also explicitly omits the `.lp` loader. Enabling positive steering help would read absent original data; generating a centerline would change the algorithm's input. The update reports this limitation instead of claiming original steering help is available. A Roblox Studio driving/performance test remains necessary because Studio cannot run in this environment.
