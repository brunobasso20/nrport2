# Install the Watkins Glen physics patch with checked backup recovery

The supplied current export contains the original live car hooks, no added track modules, and the correct V2 compatibility list. The log shows overlapping commands and an entry disappearing from the backup. V3 protects install and rollback with a shared DataModel lock, validates every backup entry before changing live sources, and detects entries removed during a source write.

1. Stop Play/Run and wait for any previous installer command to finish. Keep the calibrated track and existing car package.
2. Insert the included `NR2003_WatkinsGlen_Install.rbxmx` into Workspace using Insert from File. Its Model name is **NR2003_WatkinsGlen_InstallV3**.
3. Run this command **once**, then wait for its success or error output:

```lua
require(workspace.NR2003_WatkinsGlen_InstallV3.Apply)()
```

Do not delete `ServerStorage.NR2003Backup_WatkinsGlen`. If an unfinished backup from either previous installer remains, V3 verifies that all live targets and package attributes were restored, all newly added track modules are absent, and no bench/staging folder needs recovery. It then retains the entire stale backup as `NR2003Backup_WatkinsGlen_Recovered_<time>` before creating a fresh backup and installing. It refuses partially restored or unknown states and retains their backups.

If a previous installation completed successfully, use that backup's rollback command before updating. V3 never archives a completed installation automatically. The old installer Models may remain, but use the V3 command for this installation.

All 37 car/track payloads are unchanged from V2. CupTune, including `momentumKeys=0`, is preserved. Track/car scale remains 0.28 metres per stud. No track reimport is needed. After the success message, start Play; the car should spawn at the original first pit stall. Approach it and press F to enter.

All 52 checks pass on each fixture. Headless validation covers overlapping installers, concurrent rollback, a missing/removed backup entry, verified archival, incomplete-state refusal and the existing source/rollback checks. Tests run against both the original fixture and the supplied current car sources; the server source was not included in the current export and uses the original fixture. Actual Studio execution and driving remain to be checked.
