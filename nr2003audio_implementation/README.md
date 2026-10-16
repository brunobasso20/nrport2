# NR2003 car audio reference integration

This branch adds the original CES control path to the current **track1 / assists / patch1201** project. It is based on commit `25be672a755d64b4010b02399c800522aa0ca040`, not the older `main` checkpoint. Physics, track contacts, garage calculations and car model sources are unchanged. Only small optional hooks are added to both existing client/server entry points and both Rojo projects.

**The original recordings are not included.** The available `mysounds.zip` and earlier `snds.zip` contain the same self-made recording set. They were not imported, converted or enabled. The branch starts silently until original resources are linked. OpenNR2003 is a Ghidra project, not a complete source-and-audio distribution.

Version **1.1.0** includes recovered continuous weights, shared intro/loop/outro/stopped transport, threshold/gate decisions, intro-tail blending, original tire onset/release ramps, remote-car tire aggregation, and the original component-failure selector. It does **not** claim 100% audio fidelity. Backfires, DirectSound PCM mixing/resampling, reverb and directional filtering remain outside the implemented playback path. Real-bank extraction, sample timing on Roblox and listening remain unverified because the original sound bank files were not supplied. See [RECOVERY.md](RECOVERY.md) and [VALIDATION.md](VALIDATION.md).

## Install in an existing Studio place

1. Stop Play. Keep your current working track1/car/physics installation. Use the current **1.1.0** audio payload once; intermediate audio versions are unnecessary.
2. Insert `NR2003_Audio_Install.rbxmx` using **Insert from File**, into Workspace.
3. Run in the Command Bar:

   ```lua
   require(workspace.NR2003_Audio_Install)()
   ```

The patch checks the existing entry points before writing, preserves unrelated/local source edits, installs `ReplicatedStorage.NR2003Lab.Audio`, and keeps a chunked transaction backup in `ServerStorage.NR2003Backup_Audio`. A second installation of the same version changes nothing. If an earlier audio version was installed, roll it back before installing this version. It never saves or publishes the place. Incompatible/edited hooks abort before installation.

Missing assets are expected to produce `NR2003AudioStatus = "awaiting audio assets"` on the car, without breaking gameplay. The optional server hook falls back to the original render packet if audio initialization fails.

For Rojo, both existing project files map the same Audio modules. The model and track installation method remains the existing repository's method; this patch does not package or replace their assets.

## Extract the original resources locally

Supply your authorized **NR2003 `sound` directory**, including `sound.dat` and any loose `.ces`/`.wav` overrides. WAV files alone do not contain the original response curves. Required bank names recovered from the executable are:

| Resource | Purpose |
|---|---|
| `winston.ces` | Focus-car engine/transmission composite |
| `winston_nf.ces` | Non-focus-car composite |
| `engvol.ces` | Optional engine volume override |
| `tire_asphalt.ces` | Asphalt/concrete/paint tire composite |
| `tire_grass.ces` | Grass/dirt/sand and related materials |
| `tire_gravel.ces` | Gravel tire composite |
| `tire_rumble.ces` | Rumble strip tire composite |

The importer obtains the actual WAV filenames from these banks. It does not invent a sample list, RPM reference, or asset ID.

1. Export `NR2003.exe` memory from the local OpenNR2003 Ghidra project using `recovery/export_original.sh` or the existing `recovery/ghidra_tools` Windows runner. Use the provided `ExportMemoryPy.py`, a JDK 17, and Ghidra 11.1.2. The project must contain `NR2003.exe`; the export is read-only. Full memory dumps stay private.
2. Install the reference dependency: `python -m pip install unicorn==2.1.4`.
3. Run outside Studio, from this repository:

   ```powershell
   python nr2003audio_implementation/pipeline/import_original.py --sound-dir "C:\NR2003\sound" --reference-memory "C:\nr_reference\memory" --out "C:\nr_reference\audio" --studio-local
   ```

The output contains unchanged original WAV files, original CES files, SHA-256/source metadata, WAV format/loop metadata, all original response parameters and reference RPMs, a complete private `audio_manifest.json`, and `NR2003AudioAssets_Install.rbxmx`. Nonlinear curves are compiled with the recovered original x86 code. Unsupported versions, truncated data, unknown selectors and absent nonlinear reference memory fail explicitly.

The output must be outside this git checkout, or under its ignored `work/` folder. The importer has no upload or publication operation.

## Link the reference audio

For a private local Studio comparison, `--studio-local` writes `rbxasset://sounds/nr2003_reference/...` links. Copy the output `wav` directory's **contents**, preserving subdirectories, to `content/sounds/nr2003_reference` in the **active Studio version's content folder**. On Windows this is typically under `%LOCALAPPDATA%\Roblox\Versions\<Studio-version>\content`. Roblox documents that `rbxasset` resolves its device content folder; this does not make those local files available to published clients. This route still needs validation on your Studio installation and may need to be repeated after Studio updates.

Insert the generated `NR2003AudioAssets_Install.rbxmx`, then run:

```lua
require(workspace.NR2003AudioAssets_Install)()
```

An existing `AudioAssets` binding is moved into a uniquely named ServerStorage backup before the new binding is installed. Restart Play after linking; required ModuleScripts are cached within a session. No place save occurs automatically.

For audio you have permission to host, pass `--asset-map asset_ids.json` instead of `--studio-local`. That JSON maps the **actual WAV resource names** to your real numeric IDs or `rbxassetid://...` strings. Null/missing IDs remain silent. This tool does not upload recordings or grant asset permissions. Keep the proprietary reference profile out of published experiences unless you have the necessary rights.

## Switch profiles and inspect

`NR2003AudioProfile` on `NR2003Lab`, or on an individual car, selects `NR2003_ORIGINAL_REFERENCE` or `NASCAR_SELFMADE`. `NR2003AudioEnabled=false` mutes the system; the package-level setting also stops adding the audio tail. The self-made profile is structurally ready and intentionally empty. In phase two, supply that profile's banks, sample roles, curves/reference RPMs, loop regions and real asset IDs in `AudioAssets`; no physics/network rewrite is needed.

Client attributes include `NR2003AudioStatus`, `NR2003AudioRPM`, `NR2003AudioAgeMs`, `NR2003AudioMissing`, `NR2003AudioLoaded`, `NR2003AudioShiftEvents`, `NR2003AudioPitchClamps`, and `NR2003AudioEnginePhase` (0 intro, 1 outro, 2 loop, 3 stopped). These are diagnostics, not inputs to physics. `AgeMs` measures source-state age, not sound-device latency. Playback limits are profile-level 0.25–20, gains are explicit, loop metadata is per sample. Asset/loop failures are reported without stopping the vehicle.

The current server registers the existing car ID. Additional car senders can share `RenderState` with unique vehicle IDs and `NR2003AudioVehicleId` attributes; `NR2003AudioClient:register(car,id,presentation)` accepts their existing presentation buffers. This does not implement new multiplayer simulation or prediction. Non-primary cars have a bounded 55 ms fallback interpolation delay and still require multiplayer validation.

## Roll back

Stop Play and run `ROLLBACK.lua` in the Command Bar. It restores the exact client/server sources and package settings saved by this audio patch, and removes only its installed Audio modules. Existing physics, tracks, models and independently imported `AudioAssets` remain. Rollback refuses to overwrite sources modified after installation; resolve those edits explicitly first. Previous private asset bindings remain in their named ServerStorage backups and can be restored manually.

## Verify

Run the complete regression command. It builds the installer once, executes independent suites with at most three local test processes, compiles the changed sources, checks the preserved source scope, and saves concise JSON/logs under ignored `work/audio/`:

```bash
python3 nr2003audio_implementation/tools/validate_audio.py --luau /path/to/luau --write-results
```

`luau-compile` is found beside `luau`, on PATH, or through `--luau-compile`. `LUAU_BIN` can supply the CLI path. The committed fixtures contain 2,803 original-x86 numeric probes: 235 response vectors, 2,400 transport decisions, 80 mixer configurations, 24 tire fade steps, 32 remote tire combinations and 32 random conversions. These are synthetic numeric inputs, not game recordings or listening results.

Add `--reference-memory /path/to/private-memory-export` to regenerate all native fixtures in a temporary directory and compare them byte for byte with the committed fixtures. This optional check requires Unicorn and does not rewrite the stored fixtures. `--write-results` refreshes `RESULTS.txt` only after every check passes. No original recordings, network, upload, Studio or listening test is part of this command.

Roblox references: [Sound](https://create.roblox.com/docs/reference/engine/classes/Sound), [content paths](https://create.roblox.com/docs/projects/assets), [UnreliableRemoteEvent](https://create.roblox.com/docs/reference/engine/classes/UnreliableRemoteEvent), [ContentProvider](https://create.roblox.com/docs/reference/engine/classes/ContentProvider).
