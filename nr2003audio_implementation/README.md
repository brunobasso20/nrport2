# NR2003 car audio reference integration

This branch adds the original CES control path to the current **track1 / assists / patch1201** project. It is based on commit `25be672a755d64b4010b02399c800522aa0ca040`, not the older `main` checkpoint. Physics, track contacts, garage calculations and car model sources are unchanged. Only small optional hooks are added to both existing client/server entry points and both Rojo projects.

**The original recordings are not included.** The available `mysounds.zip` and earlier `snds.zip` contain the same self-made recording set. They were not imported, converted or enabled. The branch starts silently until original resources are linked. OpenNR2003 is a Ghidra project, not a complete source-and-audio distribution.

This is a tested **continuous-loop reference implementation**, not a completed claim of 100% NR2003 audio fidelity. Original startup/shutdown intro/outro scheduling, backfires, original tire onset fades, remote-car tire aggregation, DirectSound resampling, reverb and directional filtering are not ported. Real-bank extraction and listening remain unverified because the original sound bank files were not supplied. See [RECOVERY.md](RECOVERY.md) and [VALIDATION.md](VALIDATION.md).

## Install in an existing Studio place

1. Stop Play. Keep your current working track1/car/physics installation.
2. Insert `NR2003_Audio_Install.rbxmx` using **Insert from File**, into Workspace.
3. Run in the Command Bar:

   ```lua
   require(workspace.NR2003_Audio_Install)()
   ```

The patch checks the existing entry points before writing, preserves unrelated/local source edits, installs `ReplicatedStorage.NR2003Lab.Audio`, and keeps a chunked transaction backup in `ServerStorage.NR2003Backup_Audio`. A second installation changes nothing. It never saves or publishes the place. Incompatible/edited hooks abort before installation.

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

Client attributes include `NR2003AudioStatus`, `NR2003AudioRPM`, `NR2003AudioAgeMs`, `NR2003AudioMissing`, `NR2003AudioLoaded`, `NR2003AudioShiftEvents`, and `NR2003AudioPitchClamps`. These are diagnostics, not inputs to physics. `AgeMs` measures source-state age, not sound-device latency. Playback limits are profile-level 0.25–20, gains are explicit, loop metadata is per sample. Asset/loop failures are reported without stopping the vehicle.

The current server registers the existing car ID. Additional car senders can share `RenderState` with unique vehicle IDs and `NR2003AudioVehicleId` attributes; `NR2003AudioClient:register(car,id,presentation)` accepts their existing presentation buffers. This does not implement new multiplayer simulation or prediction. Non-primary cars have a bounded 55 ms fallback interpolation delay and still require multiplayer validation.

## Roll back

Stop Play and run `ROLLBACK.lua` in the Command Bar. It restores the exact client/server sources and package settings saved by this audio patch, and removes only its installed Audio modules. Existing physics, tracks, models and independently imported `AudioAssets` remain. Rollback refuses to overwrite sources modified after installation; resolve those edits explicitly first. Previous private asset bindings remain in their named ServerStorage backups and can be restored manually.

## Verify

```bash
python3 nr2003audio_implementation/tools/build_audio.py
python3 -m unittest discover -s nr2003audio_implementation/tests -p 'test_*.py'
python3 nr2003audio_implementation/tools/build_installer_test.py
luau -O2 nr2003audio_implementation/tests/kernels.luau
luau -O2 --codegen nr2003audio_implementation/tests/state.luau
luau -O2 work/audio/installer_test.luau
luau -O2 work/audio/spatial_test.luau
```

Golden fixtures can be regenerated with `recovery/regenerate_curves.py --memory <private-memory-export>`. They are numeric synthetic curve probes of the original executable, not fabricated game recordings or listening results.

Roblox references: [Sound](https://create.roblox.com/docs/reference/engine/classes/Sound), [content paths](https://create.roblox.com/docs/projects/assets), [UnreliableRemoteEvent](https://create.roblox.com/docs/reference/engine/classes/UnreliableRemoteEvent), [ContentProvider](https://create.roblox.com/docs/reference/engine/classes/ContentProvider).
