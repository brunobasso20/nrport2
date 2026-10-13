# Install the Watkins Glen physics patch

This patch targets the Stage 13 package exported in the supplied Roblox model, preserving its original car assets, cockpit, gauges and client cameras. It adds the recovered track runtime, updates the nine existing core hooks, the Cup host adapter and the existing car-model-aware server. It does not replace the car assets or client script.

1. Open the existing place in Roblox Studio and stop Play/Run. Keep a saved copy of the place.
2. Import and calibrate the track visual asset chunks using their supplied visual installers. They must create `Workspace.NR2003WatkinsGlen` with identity pivot, `TrackOriginEnabled = true` and `NR2003MetresPerStud = 0.28`. The original track physics owns collisions; imported visuals stay anchored with `CanCollide = false` and `CanTouch = false`. Terrain tagged `NR2003TerrainQuery = true` remains queryable for the existing chase camera's ground clearance. Walls and scenery remain non-queryable; these camera queries do not feed the original car physics.
3. Insert `NR2003_WatkinsGlen_Install.rbxmx` into Workspace through **Insert from File**. It creates `Workspace.NR2003_WatkinsGlen_Install`; do not move its individual source modules into the live package manually.
4. Run this one line in Studio's Command Bar outside Play:

```lua
require(workspace.NR2003_WatkinsGlen_Install.Apply)()
```

The installer checks all replaced sources, all bundled track modules and the required recovered Cup dependencies before changing the package. Source fingerprints normalize CRLF/CR to LF. Unknown edits in replaced or required solver modules stop installation; unrelated client/car presentation edits remain intact. Save open script editors before running it.

The installer writes source through `ScriptEditorService`, verifies the saved result, and sets `ReplicatedStorage.NR2003Lab.NR2003Track` to `watkins_glen`. If `Workspace.NR2003LabWorld.TestTrack` exists, its complete generated bench folder moves into the backup so it cannot overlap the original track. `TestCar` and the imported car assets remain in place.

At Play startup, the server places the car at the original first pit stall and creates an invisible avatar spawn/walking platform beside it so the driver can reach the seat. This platform supports the Roblox avatar; the original car physics never queries it. Existing car attributes `TrackDlong`, `TrackDlat` and `TrackYaw` can select another original track-space start.

`ServerStorage.NR2003Backup_WatkinsGlen` stores the affected original sources, markers for new modules, prior package attributes and any moved generated bench. Reapplying the same patch is safe and retains the first backup. A different patch version requires rolling back the existing version first.

5. Start Play and inspect Output and the track/car diagnostics. Save the place after checking the actual Studio result. The patch does not save or publish the place, execute the original game executable, run multi-megabyte physics self-tests during installation, or upload Roblox assets automatically.

## Roll back

Stop Play and run:

```lua
require(game.ServerStorage.NR2003Backup_WatkinsGlen.Rollback)()
```

Rollback verifies that affected sources have not acquired unknown edits, restores the saved starting sources and package attributes, removes modules added by this patch and restores the moved bench folder. Imported car and track visual assets remain available. The backup removes itself only after successful rollback. Automatic recovery also restores the starting state if installation fails; an incomplete recovery retains its backup and reports the failure.

## Build and verify the installer

From the repository root:

```sh
python tools/build_watkinsglen.py
python tools/build_watkinsglen.py --check
```

The build verifies every generated module group is contiguous and checks the XML source payloads. Every individual source stays below 199,000 UTF-8 bytes, avoiding the Script.Source paste limit. The optional `--zip` flag packages the Studio patch, required source/dependency files and validation evidence after generation. `manifest.json` records uploaded baseline fingerprints, bundled source hashes and solver compatibility checks.

`validation/installer.log` records 23 passing headless installer checks, including unknown-edit refusal, payload integrity, terrain camera-query flags, backup preparation, instance/client/asset preservation, idempotence, rollback and recovery from injected source-write failures. These checks do not replace the actual Roblox Studio driving/visual check.
