# Install the Watkins Glen physics patch

This is the **fresh V5 installer** for the supplied Stage 13 car package. It retains the main server, car assets, cockpit, entry and cameras; the existing original client receives the requested track telemetry HUD. There are 40 source targets, including the recovered world, original stock setups and throttle/clutch processing. For an already installed V4 place, use the smaller [handling update](../handling/README.md), which keeps the V4 backup intact.

1. Open the existing place in Roblox Studio and stop Play/Run. Keep a saved copy of the place.
2. Import and calibrate the track visual asset chunks using their supplied visual installers. They must create `Workspace.NR2003WatkinsGlen` with identity pivot, `TrackOriginEnabled = true` and `NR2003MetresPerStud = 0.28`. The original track physics owns collisions; imported visuals stay anchored with `CanCollide = false` and `CanTouch = false`. Terrain tagged `NR2003TerrainQuery = true` remains queryable for the existing chase camera's ground clearance. Walls and scenery remain non-queryable; these camera queries do not feed the original car physics.
3. Insert `NR2003_WatkinsGlen_InstallV5.rbxmx` into Workspace through **Insert from File**. It creates `Workspace.NR2003_WatkinsGlen_InstallV5`; do not move its individual source modules into the live package manually.
4. Run this one line once in Studio's Command Bar outside Play, then wait for its final output:

```lua
require(workspace.NR2003_WatkinsGlen_InstallV5.Apply)()
```

The installer checks all replaced sources, all bundled track modules and the required recovered Cup dependencies before changing the package. Source fingerprints normalize CRLF/CR to LF. The known CupTune variant with `driver.momentumKeys = 0` is accepted and preserved, including a missing final newline; other unverified CupTune edits are refused. Unknown edits to the client or other replaced/required modules stop installation before writes. Save open script editors before running it.

The installer writes source through `ScriptEditorService`, verifies the saved result, and sets `ReplicatedStorage.NR2003Lab.NR2003Track` to `watkins_glen`. If `Workspace.NR2003LabWorld.TestTrack` exists, its complete generated bench folder moves into the backup so it cannot overlap the original track. `TestCar` and the imported car assets remain in place.

Install and rollback share `ServerStorage.NR2003WatkinsGlenOperation` while running, including source-write yields. A second command refuses without changing the first transaction. The lock is removed on success and handled failures. Every backup entry, reference and original source is verified before application/rollback; entries removed during a write trigger automatic restoration.

An unfinished backup from a recognized earlier installer is automatically archived intact only when every original target matches its starting fingerprint, all added track modules are absent, package attributes are restored, and no moved bench or rollback staging needs recovery. V3 retains it as `ServerStorage.NR2003Backup_WatkinsGlen_Recovered_<time>`. Unknown or partially restored states are refused and their backups retained. Do not delete a backup to bypass these checks.

At Play startup, the Cup adapter places the car at the original first pit stall and prepares an invisible avatar spawn/walking platform before returning to the existing server. An avatar already spawned before the core finished loading is brought onto this platform; later players and respawns use it as well. Existing seated drivers stay seated. Cleanup disconnects character callbacks, restores owned respawn selections and removes the generated platform. This platform supports the Roblox avatar; the original car physics never queries it. Existing car attributes `TrackDlong`, `TrackDlat` and `TrackYaw` can select another original track-space start.

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

Current V5 results are in `../handling/VALIDATION.md`: 60 fresh-installer checks, 24 checks of the actual shipped V4 followed by the handling update, plus original-input/setup comparisons and the expanded HUD. The earlier V4 evidence remains under `validation/`. These checks do not replace actual Roblox Studio driving/visual validation.

Reproduce the installer transaction checks after the original model script audit:

```sh
python3 tools/make_watkinsglen_installer_mock.py
luau work/wg_install_mock/mock.luau
python3 tools/make_watkinsglen_spawn_mock.py
luau work/wg_spawn_mock/mock.luau
python3 tools/make_adapter_mock.py --track
luau watkinsglen_implementation/tests/adapter_track.luau
```

The V5 model, physical filename and command all carry V5. A fresh imported instance avoids reusing old cached installer functions. V5 can archive a recognized unfinished backup only after the starting state is verified. Server restoration is required for the older bundles that changed that Script; V4 is checked without that obsolete server requirement. Use the dedicated handling updater for completed V4 installations. Other completed older installations require their own rollback before a fresh V5 installation. Never delete a backup to bypass these checks.
