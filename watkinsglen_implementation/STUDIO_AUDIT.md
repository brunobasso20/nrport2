# Uploaded Studio model audit

The uploaded `all scripts and car modelgen.rbxm` contains the existing Stage 1–13 physics and the original car presentation package. It contains **no Watkins Glen modules or track assets**. Its server and client scripts already include the car model, cockpit, gauges and camera integration; an installer must preserve those integrations and the imported car assets.

## Input and extraction

- Input SHA-256: `a7a6ea2103db3d76a5aab5210ef71c565a9c184c7f3012433c3dcc672eaaab94`.
- Repository baseline inspected: `4a6d07fbc196f331b505fe07e3cabea04ef57710`.
- 555 instances: 106 ModuleScripts, one enabled LocalScript, one enabled Script, 178 MeshParts, 179 Models, 79 SurfaceAppearances, seven Folders, two RemoteEvents and two UnreliableRemoteEvents.
- 108 complete script sources, totalling 5,208,520 UTF-8 bytes, extracted without executing their code.
- Scratch extraction: `work/rbxm_audit/extracted/scripts/`; source and instance manifests: `work/rbxm_audit/extracted/{scripts,instances,property_types}.json`.
- The standalone read-only reader is `work/rbxm_audit/extract_rbxm.py`. It checks compressed chunk lengths and supports raw LZ4 and Zstandard chunks. Header instance count and decoded instance count agree.
- The supplied model has three top-level roots: `NR2003Lab`, `NR2003Client` and `NR2003Server`. It does not contain a running `NR2003LabWorld`/`TestCar` instance. Those are created by the server at runtime.

## Source comparison

97 of the 108 sources match repository source text. Of those, 96 match bytes exactly; `Core/NR2003Cup/NR2003CupFrameData1` only differs in CRLF versus LF line endings. The 11 remaining sources are accounted for below; no additional user-specific script edits were found.

| Uploaded script | Repository comparison | Difference |
|---|---|---|
| Top-level `NR2003Server` | `nr2003carmodel_implementation/roblox/Bench/Server.server.lua` | Exact byte match. Includes optional car model server and DrawState sends. |
| Top-level `NR2003Client` | `nr2003carmodel_implementation/roblox/Bench/Client.client.lua` | Exact byte match. Includes optional car model client, cameras, look controls and FOV controls. |
| All `Roblox/*` modules, including `CupChassisAdapter` | `roblox/*.lua` | Exact byte matches. |
| Ten `CarModel/*` runtime/test modules | `nr2003carmodel_implementation/roblox/CarModel/*.lua` | Exact byte matches. |
| `Core/TestTune` | `core/TestTune.lua` | Uploaded version is `2.0.0`; repository has `3.5.0-stage5`. Solver description differs. Numeric tune and units agree. |
| `Core/NR2003CupVehicle` | `core/NR2003CupVehicle.lua` | Uploaded copy lacks the repository's track-aware memory allocation, track host install and `loadTrack`/`trackLoaded` methods. |
| `Core/NR2003Cup/NR2003CupGarage` | Same path under `core/` | Uploaded copy lacks track build/code-set helpers and reset-image refresh. |
| `Core/NR2003Cup/NR2003CupBuild` | Same path under `core/` | Uploaded copy lacks track input overrides, placement rebuild and named extra structures. |
| `Core/NR2003Cup/NR2003CupFrame` | Same path under `core/` | Uploaded copy lacks shared frame context, original placement hook and loaded-track race-order handling. |
| `Core/NR2003Cup/NR2003CupFrameCode1` through `4` | Same paths under `core/` | Uploaded copies lack dispatch to the real loaded-track point query. |
| `Core/NR2003Cup/NR2003CupDriver` | Same path under `core/` | Uploaded copy always uses host contact planes; repository already switches to the recovered world frame/contact passes when active. |
| `CarModel/Data/NR2003CarModelData_make_a` | No standalone generated Lua counterpart in checkout | Complete generated descriptor extracted to scratch; preserve the installed module. |

The nine Cup core differences are the repository's existing Watkins Glen changes, absent in the uploaded Studio package. They are not unexplained user modifications. Detailed source diffs and machine-readable comparisons are in `work/rbxm_audit/diffs/` and `work/rbxm_audit/comparison.json`.

## Runtime and adapter boundaries

`ModeConfig.mode` is `NR2003_CUP`. The server constructs `CupChassisAdapter.new(car, tune, Input)`, which constructs `NR2003CupVehicle.new(Core.NR2003Cup)`. The recovered solver owns all 45 states; the chassis is anchored and non-colliding. Roblox applies no rigid-body forces to this mode.

The server advances the adapter from `RunService.PreSimulation`. The core fixed step is `1/288 s`; eight ticks form one original 36 Hz frame. The server sends `RenderState` snapshots and the original `DrawState` at the same sequence/time. The client consumes render snapshots before updating the original car model and cameras; render state does not feed simulation.

Remote interfaces to preserve:

- `Input` (RemoteEvent): server-authorized seating, controls, gear shift, reset, debug and exit.
- `Telemetry` (RemoteEvent): per-driver instrumentation.
- `RenderState` (UnreliableRemoteEvent): chassis/wheel snapshot.
- `DrawState` (UnreliableRemoteEvent): original car/cockpit draw record.

Current adapter integration gaps:

1. Neither the uploaded adapter nor its server calls `self.core:loadTrack()`. Merely installing track modules does not activate their collision world.
2. `initialize()` currently sets `self.origin = self:groundOrigin(self.spawn)` and then resets/builds/starts the session. Track load must happen before the relevant track-aware build/session sequence. A chosen `setTrackStart` must be applied before session placement.
3. `self.core.V.loadTrack`, `setTrackStart`, `trackInfo`, `trackPointRaw`, `worldRecord` and `worldActive` are reachable through `controller.core.V` once the patched core and track modules are installed. `controller.core:loadTrack()` is the repository's public load facade.
4. The existing recovered Driver switches to original track contact passes only while `V._world.active()` is true. Loading sets `loaded`; `enterTrack()` activates the world, while `reset()` and `endSession()` deactivate it. Session placement/reactivation must remain intact after reset.
5. The current adapter `pose()` performs a Roblox Blockcast and calls `core:translate()` on a hit. This provisional positional collision correction must be bypassed when the original track world owns contacts and collision response.
6. `aeroHostInputs()` averages the adapter's host raycast normals and can inject a test drafting environment. In track mode, the original track query/world record must supply the surface normal. Bench test drafting must not silently replace the real track/race-order data.
7. `inContact`, `planes`, contact markers, grounded snapshot flags and surface telemetry are currently updated inside the host contact callback. Original-world mode bypasses that callback. These presentation/telemetry values need to read the original contact/world records rather than remain stale or supply physics inputs.
8. The adapter's fixed-step checkpoint includes core memory, origin and host contact flags. Track runtime activation/callback selection must also remain consistent across checkpoint restore; this requires checking the track host's non-memory runtime flags.

## Units, axes and imported car alignment

The uploaded `NR2003Scale` is identical to the repository car model scale module. Both `TestTune` and `CupTune` use **0.28 metres per stud**. Original NR2003 coordinates are metres with `+X` forward, `+Y` left, `+Z` up. The shared conversion is:

```
Roblox position in studs = (-NR.y, NR.z, -NR.x) / 0.28
Roblox direction        = (-NR.y, NR.z, -NR.x)
Roblox rotation         = B * NR.rotation * transpose(B)
```

The existing Cup adapter applies an additional `self.origin` CFrame around this mapping. For absolute original track coordinates, use identity as that origin, or one explicit shared placement applied to both track assets and vehicle presentation. Using the pit car's spawn/ground frame as the origin would translate and rotate the original track-space positions twice.

`CarModel.Assets.make_a` contains the user's imported car geometry/materials and four calibration markers. Decoded marker displacement vectors are:

```
X - O = (-4, 0, 0) studs
Y - O = ( 0, 4.000000834465027, 0) studs
Z - O = (-0.0000004768371582, 0, -4) studs
```

The imported model therefore has uniform scale approximately 1, a 180-degree yaw and a translation. `NR2003CarModelRig.calibrate()` already measures and removes this import transform using the markers. Preserve the complete assets hierarchy and its uploaded MeshId/texture/SurfaceAppearance references; do not manually reposition or rescale it to align a track. The car import's calibration frame is not the track/world origin.

## Verification limits

This audit verifies complete uploaded source extraction, source comparison and saved instance/marker transforms. It does not execute Roblox Studio or demonstrate live server/client driving. It does not establish whole-game 100% NR2003 fidelity; matching recovered arithmetic and original contact code still needs the reference tests and an actual Studio run with the imported track.
