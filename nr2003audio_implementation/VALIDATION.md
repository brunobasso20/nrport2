# Audio validation

Automated validation runs in the container and Luau CLI. **No Roblox Studio or listening test was performed.** No original CES/WAV bank was available; binary import was tested with synthetic files. The user's self-made recordings were not enabled.

## Automated checks

| Check | Scope |
|---|---|
| Response kernels | 235 stored vectors produced by original x86 linear/Gaussian/Bezier routines with documented CRT bridges; exact tested float32 agreement, including plateau edges, overlap and extrapolation |
| Mixer/lifecycle | 80 original-x86 normalized-weight configurations; original group ordering/limit; RPM/reference and actual gear-scalar pitch; disabled and missing samples; failure/interior selectors; stable voice ownership; confirmed shift de-duplication; reset/stale silence |
| Transport phases | 2,400 original-x86 threshold/gate/cooldown decisions; mock one-shot intro/outro starts, reversal position, original intro-tail blend, gear entry, completion, missing intro and original half-gain branch |
| Tire presentation | Original-x86 fade, remote aggregation and LCG vectors; onset/release sequence, source-tick cadence, repeated render calls, reset and unchanged input controls |
| Real core state | Eight changing-throttle blocks on the existing complete Cup core; whole memory buffer identical before/after every audio sample; direct original RPM/load/tire control cells; mixed asphalt/concrete/grass/gravel metadata |
| Transport | 476-byte packets; the original 204 bytes remain identical; existing render decoder accepts the extended packet; float32/gear/contact/material round trips; invalid data rejected; render-time interpolation, discrete gear changes, reset epoch and old-packet rejection, 500 ms stale cutoff |
| Installation | Actual generated payload executed in the existing Studio mock; preserves local source edits and track/core objects; idempotent install; exact rollback; modified-source refusal; unsupported-hook preflight; injected Source and backup-chunk failures; chunked backups; Play-mode refusal |
| Playback API mock | Actual Spatial module executed with an injected API surface; one start per loaded loop, late load once, no restart during control updates, loop metadata, 0.28 scale, contained loading errors, owned-object cleanup, one-shot completion, deferred seek/start, cancellation and late-callback rejection |
| Import | CES v2/v3 shape, reference-pair layout, malformed/truncated/trailing data, unsupported curves without native reference, traversal rejection, unchanged PCM bytes/sample rate, generated XML, missing original-bank rejection |
| Existing track | Existing `tests/track1/surfaces.luau` regression; original material and thermal/wear behavior |
| Source scope | Core, adapters, setup calculations, track parameters, model runtime and original snapshot codec unchanged from the selected base commit |

`tools/validate_audio.py` builds once and runs these suites, syntax checks and the preserved-source scope check automatically. Optional `--reference-memory` regenerates all numeric fixtures privately and verifies byte identity. `RESULTS.txt` records the completed test runs. Test fixture IDs and generated silent WAVs are synthetic test inputs, not working asset mappings for the original profile. Numeric fixture probes are not captured gameplay audio.

## Phase and cadence checks

The automated transport tests use synthetic CES/sample handles. They verify the recovered decisions and the adapter's event ownership, not the shipped samples' audible durations. The playback API mock verifies that one-shots do not loop, loading does not create duplicate starts, a cancelled deferred start stays cancelled, and a pending tire-loop phase survives loading.

The native regeneration completed without modifying the Ghidra project, committed fixtures, or vehicle code. The real-core sampler compares the **entire memory buffer** before/after its reads, including the new component-failure flag.

## Studio comparison procedure (pending)

Install/link the original assets as described in README, then start a new Play session. Open Client Output and inspect the TestCar audio attributes. Verify that all expected bank samples load before drawing conclusions about sound quality. Use the same original Cup setup, gear ratios, track/chassis class, RPM, load and camera for each comparison.

| Scenario | Expected control behavior and acceptance check | Status |
|---|---|---|
| Idle | Original bank weights at the actual idle RPM/load; stable loops without repeated starts. Check `Loaded`, RPM and any load failures | Listening pending |
| Progressive RPM up/down | Speed changes continuously by the CES reference RPM formula; inspect Sound.PlaybackSpeed and compare its ratio to recorded RPM, including overlap boundaries | Numeric kernels tested; listening pending |
| Rapid throttle changes | Original effective load field drives curves on the shared presentation timestamp; no 10 Hz telemetry dependency or added RPM filter | State path tested; latency/listening pending |
| Neutral and clutch | Engine follows actual RPM; gear layer uses original gear scalar rather than vehicle speed; clutch slip remains physics-owned | Formula tested; driving/listening pending |
| Gears 1–4 and reverse | Compare confirmed core gear with the audio state; no change until the transition timestamp; verify appropriate direction/ratio response | Codec/transition tests; driving pending |
| Upshifts/downshifts | Original RPM/load change the active samples; one diagnostic shift event per confirmed change, none on reset. No synthetic click was added | De-duplication tested; listening pending |
| Garage ratios/final drive | Change actual setup in the existing garage, rebuild/reset normally, then confirm the sound's gear scalar changes with `car+454/+474` without audio recalibration | Readout formula tested; garage driving pending |
| Rev limiter | Existing original core controls engine/shift cuts; inspect actual limiter/load/RPM. No new timing or cutoff waveform is invented | Original data path present; high-RPM listening pending |
| Asphalt/other materials | Grounded wheels select the original sound class and completed tire volume/pitch/crossfade. Lift, lock and slide a wheel; airborne wheels must create no new tire excitation; the existing voice releases through the original fade | Mixed-state metadata tested; listening pending |
| Damage/ignition cuts | Match the original core's RPM/load and verify that audio does not simulate extra failures or modify power. Bank-controlled startup/shutdown follows recovered phase rules; the core's unported manual ignition inputs are not replaced by audio | Readouts present; driving/listening pending |
| Cockpit/exterior | Original sample selectors follow `carModel.vars._cockpit`, including look-left/right, or the existing fallback cockpit camera | Selector math tested; Studio mode switch pending |
| Reset/avatar respawn | Reset epoch discards old states without a shift event; loops do not multiply. Repeat entry/exit/reset; check Sound counts remain stable | Buffer/controller tests; Studio lifecycle pending |
| Missing/unavailable audio | Remove a mapping or deny one asset. Other samples and driving must continue; diagnostics must show missing/loading/failure | Missing IDs tested; platform load failure pending |
| Network interruption | Stop snapshots for >500 ms. Audio mutes while loops remain allocated; restore stream and confirm normal recovery | Buffer/controller tests; live network pending |
| Performance | Compare no-audio vs linked-audio MicroProfiler CPU and receiver rate; confirm 60 Hz snapshot target and 476-byte raw render payload. Check `PitchClamps=0` in the intended range | Payload measured; Studio CPU/device latency pending |

Measure expected sample pitch objectively as `RPM/referenceRPM`, or `RPM/gearReferenceRPM*gearScalar`, clamped first by the original 0.25 minimum and then by the backend's configured maximum. Record camera, effective load, gear and profile together with the audible capture. A nonzero pitch-clamp count means the backend cannot reproduce that requested playback rate; do not call that sample/range verified.

Native transport decisions, tire fade arithmetic, remote aggregation and numeric mixer weights passed the automated reference comparisons. Actual startup/shutdown/tire timing on Roblox, end-to-end waveform, original backfire playback, exact DirectSound mixing, reverb and acoustic latency are not marked as passed. Those require the original banks, a real game baseline, and Roblox Studio.
