# Stage 13 — force-feedback state map

Every Stage 13 state lives in the **original memory layout** of the NR2003 Cup core (`NR2003CupCore` buffer, original
addresses) except the host device state (DirectInput in the original). Port: `core/NR2003Cup/NR2003CupFFB.lua` + the
Stage 13 lines of `NR2003CupDriver` (`tickInputs`, `frameStart`) and `NR2003CupFrame` (`frameEnd11`, `enterTrack`).
Validation: `STAGE13_VALIDATION.md`. No FFB cell is read by the physics or the steering chain (`STAGE13_RECOVERY.md` §9).

## Simulation cells

| cell | type | meaning | written by (original → port) | read by | reset / image |
|---|---|---|---|---|---|
| `74c964` / `74c968` | i32 | pass count LF / RF | `00554e70` (JIT tyre native, Stage 6/7) ++; `00554d30` → 0 | `00554d30` | image 4 / 4 after the build (1 + 3 build passes) |
| `bf6ed4` / `bf6ed8` | f32 | Σ relaxed slip state `c085dc` (A) | `00554e70` +=; `00554d30` → 0 | `00554d30` | 0 |
| `bf6edc` / `bf6ee0` | f32 | Σ (|Fz| + 0.01) (B) | same | same | 0.03 / 0.03 |
| `bf6ee4` / `bf6ee8` | f32 | Σ Fy (C) | same | same | 0 |
| `bf6eec` / `bf6ef0` | f32 | Σ (0.1 (r × F).z + `c081ec`) (D) | same | same | −0 / 0 |
| `74c960` | f32 | mean front load, ≤ 1500 | `00554d30` → `V._ffbTick` | none | 1500 |
| `bf6ec4` | f32 | load-weighted mean front slip state (ec4) | `00554d30` | FFB block | 0 |
| `bf6ec8` | f32 | Σ mean front Fy | `00554d30` | none | 0 |
| `bf6ed0` | f32 | Σ mean front moment (ed0) | `00554d30` | FFB block, telemetry copy `bf643e` (`bf63d8`, no reader) | 0 |
| `bf6ec0` | f32 | previous ec4 (ec0) | FFB block (`V._ffbFrameEnd`), `00550530` reset | FFB block | 0 |
| `bf6ecc` | f32 | filtered torque (ecc) | FFB block | FFB block | 0 |
| `bf6eb8` | u8 | player controls suspended | `00550070` (`V.setControlsSuspended`, `enterTrack`, binding change), `00550490` | FFB block gate; **`005524f0` @00552549** (not-driven branch, `NR2003CupDriver.frameStart`) | 0 |
| `bf6ebb` | u8 | FF effect acquired | `0054fed0`, `00550680` (`endSession`) | FFB block gate, `00550070`, `0054fed0` | 0 |
| `bf6ebc` | u32 | FF axis (global axis number, control-7 binding `rec+0x14`) | `0054fed0` | FFB block (`005d08d0` argument), `00550030` | 0 |
| `74c95c` | i32 | ±1 from the axis-name direction character | `0054fed0` | none | 1 |
| `bf6f1c` | u8 | FF on/off (message 8) | `00550270` (`setForceFeedbackOptions.enabled`) | `0054fed0` (`00550280`) | 0 |
| `74c9a4` | f32 | strength (message 9) | `00550290` (`strength`) | FFB block | 80 |
| `bf6f24` | f32 | damping (message 10) | `005502d0` (`damping`) | FFB block | 0 |
| `bf6f20` | f32 | latency, ms (message 11) | `005502b0` (`latency`) | FFB block | 0 |
| `c055c0 + 0xc0` | f32 | setup item 0x30 (steering ratio, raw) | garage / build (Stage 10) | FFB block (`00557d60(0x30)`), `00554fb0` | 18 (shipped), bench 12 |
| `bf3a00` | f32 | airspeed |v − wind| | `00554520` @0055455f (Stage 11 lift) | FFB block | — |
| `d37d83 + 0x10 / 0x14 / 0x1c` | i32 / i32 / u8 | control-7 binding: type (1 = axis), axis number, direction byte | host device layer (`NR2003CupSteering.hostDevices`: type) | `0054fed0` (`0057aff0`) | 0 / 0 / 0 |

## Host state (ADAPTER, not in the simulation memory)

| state | original | port | notes |
|---|---|---|---|
| FF capable | `005d0820(axis)` (DirectInput device of the axis supports FF) | `setForceFeedbackDevice({capable})` | Roblox: an FF output exists (HUD + gamepad motors) |
| acquisition result | `005d0840(axis)` → `005d2170` → `005d2bb0` | `setForceFeedbackDevice({acquire})` (default true) | |
| effect acquired | `f5d414` | `effect` (in `checkpoint` / `restore`) | gates the device delivery of `005d08d0` |
| last force sent | `IDirectInputEffect` | `forceFeedbackState().force / magnitude`, sink callback | magnitude = `_ftol(force · 10000)` |
| binding type at the last `0054fed0` | (the controls menu flow) | `configuredKind` (in `checkpoint` / `restore`) | a change while FF is on / acquired runs `00550070(0)` |

## Timing

| when | what |
|---|---|
| each tyre pass (2 per tick) | `00554e70` accumulates (front wheels) |
| each tick, `005539c0` @00553a64 | `00554d30`: averages of the previous tick's 2 passes (n = 2), clears |
| frame end | the block uses ec4 / ed0 built at the start of tick 8 from tick 7's passes; tick 8's passes stay in the accumulators until the next frame's first tick |
| car placed on the track (`startSession` / `reset` in a session) | `00550070(0)`: FF axis from the control-7 binding (the image binding is type 0: nothing acquired until the device layer binds an analog axis) |
| controls suspended / resumed | `00550070(1)` zero force + gate; `00550070(0)` set up again |
| session end | `00550680` release |
