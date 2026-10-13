# Install the Watkins Glen physics patch

This patch targets the Stage 13 package exported in the supplied Roblox models, preserving its existing server/client scripts, car assets, cockpit, gauges, entry controls and client cameras. It adds the recovered track runtime and updates the nine existing core hooks and Cup host adapter. V4 has 36 source targets: ten existing core/adapter modules and 26 new track modules. ServerScriptService and StarterPlayerScripts are not source-write targets.

1. Open the existing place in Roblox Studio and stop Play/Run. Keep a saved copy of the place.
2. Import and calibrate the track visual asset chunks using their supplied visual installers. They must create `Workspace.NR2003WatkinsGlen` with identity pivot, `TrackOriginEnabled = true` and `NR2003MetresPerStud = 0.28`. The original track physics owns collisions; imported visuals stay anchored with `CanCollide = false` and `CanTouch = false`. Terrain tagged `NR2003TerrainQuery = true` remains queryable for the existing chase camera's ground clearance. Walls and scenery remain non-queryable; these camera queries do not feed the original car physics.
3. Insert `NR2003_WatkinsGlen_Install.rbxmx` into Workspace through **Insert from File**. It creates `Workspace.NR2003_WatkinsGlen_InstallV4`; do not move its individual source modules into the live package manually.
4. Run this one line once in Studio's Command Bar outside Play, then wait for its final output:

```lua
require(workspace.NR2003_WatkinsGlen_InstallV4.Apply)()
```

The installer checks all replaced sources, all bundled track modules and the required recovered Cup dependencies before changing the package. Source fingerprints normalize CRLF/CR to LF. The known CupTune variant with `driver.momentumKeys = 0` is accepted and preserved, including a missing final newline; other unverified CupTune edits are refused. Unknown edits in replaced or required solver modules stop installation; unrelated client/car presentation edits remain intact. Save open script editors before running it.

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

`validation/installer.log` records 57 passing headless installer checks, including source integrity, car/asset preservation, idempotence, rollback, overlapping operations, unfinished-backup recovery and custom main-server preservation. `validation/installer_current_export.log` runs the same checks with the supplied current car sources (the server was not exported and uses the original fixture). `validation/spawn.log` records 15 avatar lifecycle checks using the actual SeatAccess module; `validation/adapter_track.log` records ten original-core startup/contact/reset checks with momentumKeys=0. These checks do not replace the actual Roblox Studio driving/visual check.

Reproduce the installer transaction checks after the original model script audit:

```sh
python3 tools/make_watkinsglen_installer_mock.py
luau work/wg_install_mock/mock.luau
python3 tools/make_watkinsglen_spawn_mock.py
luau work/wg_spawn_mock/mock.luau
python3 tools/make_adapter_mock.py --track
luau watkinsglen_implementation/tests/adapter_track.luau
```

The new V4 Model name prevents reuse of old cached modules. If a previous attempt was refused or the original state was fully restored, insert V4 and run its command directly. V4 checks and archives any remaining recognized unfinished backup before retrying. Earlier incomplete backups also verify restoration of their old server target before archival, even though V4 does not write that Script. A completed older installation still requires its own rollback before updating. Wait for previous commands to finish; run only the V4 command during this retry.
