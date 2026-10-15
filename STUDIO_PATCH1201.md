# Official presets and test shortcuts

The physics reference already is NR2003 1.2.0.1. This update corrects the installed Watkins Glen FAST/QUALIFY
presets to the complete files in the supplied official patch and adds testing shortcuts. It preserves EASY/JASPER,
which the official patch does not replace for Watkins Glen. Surface grip matches the recovered original values;
no extra grip or camber multiplier is applied.

1. **Stop Play.** Save a copy of your place.
2. Insert `NR2003_Patch1201Setups.rbxmx` into Workspace using **Insert from File**.
3. In the Studio Command Bar run:

```lua
require(workspace.NR2003_Patch1201Setups)()
```

Alternatively, paste `PATCH_NR2003_1201_SETUPS.lua` into the Command Bar. Use one installation method.
The installer accepts the supplied Studio sources and the matching current Watkins branch; it refuses unknown
edits. It updates the setup module and server action handler, and adds a small control module and LocalScript.
Backups are in `ServerStorage.NR2003Backup_Patch1201`. Existing simulation modules, track assets and Stage 14
checkpoint behavior are preserved. The place is not saved automatically.

Start Play, enter the car, then use:

| Key | Action |
| --- | --- |
| **K** | FAST → EASY → QUALIFY → JASPER → FAST; resets at the track spawn |
| **,** | Hide/show telemetry HUD |

K clears individual `Setup_*` and legacy brake/tape/spoiler overrides so the whole chosen preset is tested.
Typing into a text field does not activate either shortcut. The server accepts setup changes only from the driver.
If a setup reset fails, its selection/override attributes are restored. Use the HUD's setup name to confirm selection.

To undo: stop Play and run `PATCH_NR2003_1201_SETUPS_ROLLBACK.lua` in the Command Bar. It restores prior sources
and removes only the scripts added by this update; it refuses to overwrite scripts edited after installation.

CLI validation and original x86 evidence are in `tests/patch1201`, `recovery/patch1201`, and `PATCH1201_AUDIT.md`.
Studio itself was not run in the Linux environment; the shipped installer and handlers are exercised by mocks.
