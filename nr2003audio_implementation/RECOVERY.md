# Recovered behavior and boundaries

The executable reference is the OpenNR2003 commit recorded in `recovery/PROVENANCE.json`. Ghidra 11.1.2 opened the copied project read-only. Focused pseudo-C and assembly exports are in `recovery/evidence/`; these are reverse-engineering evidence, not recovered Papyrus source files. No full executable/DLL memory image or original recording is committed.

## Original control path

| Original function/data | Recovered behavior | Integration |
|---|---|---|
| `00551e10`, `car+1508/1510` | Snapshot RPM and effective engine load from the existing drivetrain | Read directly, including the already-ported limiter/shift behavior; throttle is separate diagnostic data |
| `00563bd0` | Supplies RPM, load and `car[454+gearIndex*4] * car[474]` to each engine composite; chooses focus/internal perspectives | Read these original fields; no vehicle-velocity RPM substitute or fixed gear-ratio copy |
| `00412050`, `004120f0` | Load `winston.ces` / `winston_nf.ces` from the sound resource directory | Local resource importer, loose files before DAT entries |
| `004ea2d0`, `004ea090` | CES v2/v3 header, eight engine/gear reference pairs, gain bounds, up to 32 samples, selector fields and four response curves per sample | Strict binary parser; preserves selectors, roles and all four curves |
| `004e9c50`, `004e9b60`, `004e9480` | Linear, Gaussian and Bezier response serialization | Types 0/1/2 supported; 3/4 preserve inactive/unity semantics. Bezier consumes both original 48-byte reads |
| `004e9c20/004e9bd0` | Linear intercept/slope; equal-domain constant; nonnegative output | Same float32 store points |
| `004e98f0/004e9570` | Gaussian plateau and two 128-entry lookup tables | Tables compiled by the original x86 constructor; lookup rules ported |
| `004e93c0/004e9250` | Bezier 256-entry lookup, original extrapolation slopes | Tables compiled by the original x86 constructor; original lookup/extrapolation rules ported |
| `004ec250`, `00548a00`, `0051c2d0` | First CES selector follows the original component-failure control flag; the other selects interior/exterior | Read the original damage bit and failure selector; cockpit mode comes from the existing car-model client. The original parser field previously called `focus` is now `selector` (legacy profiles remain accepted) |
| `004eb260` | Products of RPM and load curves, grouped normalized sample weights, `1/(sum+1e-5)` | Original float32 normalization; disabled samples retain weight while their output is muted; absent handles are excluded |
| `004eab20`, `004ea9f0`, `004eaa60` | Up to four engine/gear composites, engines first in bank order; share the phase transport of the first composite with phase samples | Same layout/priority; tire constructor at `00556b0d` selects engine group zero |
| `004eac30`, `004f01f0`, `004f02d0` | Intro (0), outro (1), loop (2), stopped (3); strict RPM/load thresholds, startup gate and 0.5-second transition guard | Native-verified decision kernel; source timestamps drive the clock |
| `004eaea0` | Intro/outro reversal seeks to `1 - opposite normalized position` | One-shot backend supports seek, deferred loading and cancellation |
| `004ec8d0`, `004eb4d0`, `004ebe10` | Intro reaches loop transport after normalized position 0.6000000238; master intro tail blends with slope 2.500000238; completed outro stops | Playback clocks/Ended signals feed these rules; actual Studio timing still pending |
| `00563bd0`, `car+596` | Additional 0.5 composite gain when the original field equals zero | Read as a flag; applied to engine/gear/phase output without changing pitch |
| `004ecb70` | Engine playback speed `max(0.25, RPM / referenceRPM[group])` | Same mechanical source |
| `004ecdb0` | Gear playback speed `max(0.25, RPM / gearReferenceRPM[group] * currentGearScalar)` | Uses actual gear/final-drive fields; neutral/reverse use original values |
| `005577d0`, `engvol.ces` | Optional sum of engine-volume response products with clamp, mapped to volume bounds | Optional original bank; bank load ramp used when absent |
| `00551990 -> 00556e30` | Original tire rolling/squeal response, surface classes, volume, pitch and crossfade | **Already lifted in the project.** Audio reads the completed result; no new tire model |

The second response pair is preserved in the manifest; the recovered continuous weighting and intro/outro mixing routines above consume the first pair. No new use is invented for the other pair. Intro/outro playback uses the first selected phase sample per composite, as in the original mixer; the other phase clocks advance silently.

## State mapping

`C=0xc12030`, `E=C+0xc`, `T(w)=0xbf3a20+w*0xa39`. All addresses are from the current original core; the audio code uses `rf32/r32` reads and calls no exporter, decoder, setter or physics function. The entire memory buffer stays identical across each sampled test frame.

| State | Source |
|---|---|
| Engine sound RPM / load | `C+1508`, `C+1510` |
| Engine / shaft angular rate | Exported state block `bf6d40`, indices 34 / 36 |
| Confirmed gear | `74c97c`, display = index − 1 |
| Effective throttle / clutch | Existing input cells `bf6368` / `bf6370` |
| Power / cut timer / engine flags | `E+554`, `E+550`, `E+548` |
| Limiter | Existing `bf6f3c` flag; **no independent limiter waveform** |
| Wheel spin | Existing exported states 18 / 24 / 30 / 32 |
| Longitudinal/lateral slip, contact velocity, forces | `T+2ec/2e8/2f0/2d8/2dc/2e0` |
| Tire audio volume / pitch / crossfade / sound type | `C+11cb/11db/11eb/120b + 4*w` |
| CES failure control flag | `00548a00`: `bcf76c` selects a bit at `C+1493+e`; failure type 1 is always false; evaluated only for the original player car |
| Player car / half gain | `C+5b2 == c06926`, `C+596 == 0`; stored in reserved audio header flags |
| Grounded/material | Existing native Watkins contact view, or current track1/bench planes |

Original surface sound classes at `006f6520`: asphalt, concrete and paint → 1; rumble → 4; grass/dirt/sand → 2; gravel → 3. This is not a mapping from Roblox Material names. The existing track integration remains responsible for NR2003 material indices.

## Reference execution boundary

The Gaussian/Bezier tables and 235 numerical golden vectors were generated by running original x86 routines in Unicorn 2.1.4. `_CIpow` (`006c5c40`) and `_ftol` (`006c5018`) are encrypted CRT entries in the available image; they use the existing project's explicit x87 bridges. `modf` (`006c6a24`) uses an x87 truncate/store/subtract bridge. These boundaries are recorded in the provenance file and compiler, and are not described as running the original encrypted CRT. Tested float32 outputs agree exactly for the 235 stored response vectors and the 80 additional mixer configurations. Another 2,400 original transport decisions execute `004eac30/004f02d0` with the original host clock cell `a6c238`; callback lists are deliberately empty to isolate decisions from sample playback. Twenty-four fade probes execute the original `005644d0..0056450d` instruction block. Thirty-two aggregation probes execute `00563d35..00563dbc`; thirty-two uniform probes execute `005f5670/005f56b0`. Those probes do not replace the original phase functions with host implementations. This does not prove equality for all possible curves, the unavailable shipped CES banks, or playback waveforms.

## Roblox-specific choices and remaining limits

* Audio adds a **272-byte tail** to the existing 204-byte render packet, once per snapshot, without a new RemoteEvent. Old render decoders ignore the tail. At 60 Hz it adds 16,320 raw payload bytes/s per car/client; serialization, compression and transport overhead are not included. The existing car-model draw stream remains separate.
* A causal audio buffer shares the primary car's rendered timestamp. RPM/continuous controls interpolate; gears/flags/material/contact changes stay discrete. Epoch changes prevent interpolation across resets. Duplicate/old packets cannot repeat shift events. After 500 ms without data the controller mutes, keeping loop positions.
* The existing snapshot path is 60 Hz, while several original controls update at the 36 Hz original frame boundary. Repeated values are expected. The existing presentation delay remains; this task does not claim zero network/device latency or change prediction.
* Roblox Sound provides playback speed, per-wheel attachments and inverse-tapered distance attenuation. Profile safety bounds are 0.25–20 pitch and 0–10 gain. Sound's interpolation, mixing, resampling, Doppler, roll-off, timing and backend buffers are not NR2003 DirectSound. No bit-identical waveform claim is made.
* Tire onset/release adds +/-0.25 after applying the old fade. It runs once per original 36 Hz frame from the existing tick, rather than at display refresh rate. Missing intermediate presentation frames hold the available control values during bounded catch-up; actual snapshot/device timing still needs Studio validation. A released tire retains its last volume through the original fade instead of being cut immediately by an extra contact check.
* Non-focus tire controls preserve the shipped loop over wheels **2..4**: maximum volume/crossfade/class, minimum pitch starting at 1, emitted at the car body. This unusual rule was retained and tested against the original instruction block. The implementation copies controls without clearing the physics wheel arrays.
* Tire initial phase uses the original LCG/uniform formula with a private `audioSeed` (default 1). It does not consume or alter the physics RNG stream. The original shared game's random sequence and exact initial phases are not reproduced.
* Backfire control math and the eight standard internal/external resource names are recovered in `005637e0/00563bd0/00593ad0`. Playback is not enabled: the CRT random call at `006c522a` remains encrypted in this reference image, and neither the original recordings nor an observed reference sequence is available. No substituted probability distribution is presented as original behavior.
* Camera directional filtering/reverb, the original PCM mixer/resampler, exact sample alignment and acoustic latency remain outside the port. Sound clocks and asynchronous asset loading are Roblox-specific boundaries. Native decision tests do not validate these backend timings.
* Shift events are diagnostic confirmed gear changes, not invented shift-click samples. Damage/cuts/limiting feed the original RPM/load fields. No additional damage sound, limiter pulse, turbo, starter or tire squeal is synthesized.
* Both perspective banks and all assets are missing here. Local `rbxasset` content paths are a private Studio test route and still need actual Studio verification. Native bank/WAV extraction has only been tested with synthetic format fixtures; no absent archive or listening test is claimed to have passed.

This stage can become an audible engine/transmission/tire reference after authorized original files are supplied and linked. The original banks are required to validate their actual parameters, sample roles and durations; Studio and a recorded original-game baseline are required to assess audible fidelity. No full-system exact-clone claim is made.
