# assist_implementation

Test defaults: automatic transmission, auto clutch and ABS **on**. Traction control, stability control and low-speed steering boost **off**. These select the original NR2003 1.2.0.1 routines and constants; they do not alter tire grip or garage presets.

1. Stop Play in Roblox Studio.
2. Insert `NR2003_Assists.rbxmx` into Workspace.
3. Run in the Command Bar: `require(workspace.NR2003_Assists)()`
4. Start Play. The telemetry shows each assist as `true` or `false`.

**K** cycles FAST → EASY → QUALIFY → JASPER and resets at spawn. **Comma (,)** hides/shows the telemetry, including the new assist display. E/Q retains the original automatic-mode reverse/neutral controls; forward shifts happen automatically.

For different tests, set these boolean attributes on TestCar before Play (or reset after changing them): `AutomaticTransmission`, `AutoClutch`, `ABS`, `TractionControl`, `StabilityControl`, `SteeringLowSpeedOverride`. Missing attributes use the defaults above. Automatic transmission uses the original auto clutch. With automatic off, `AutoClutch=false` selects the original manual-clutch mode.

Positive `SteeringAssistance` (0–100) requires the original track racing-line data. The supplied Studio track omits the `.lp` loader/data, so steering help is **off / unavailable** and enabling it is refused. A generated lane or substitute steering equation would not match the original. This is the remaining driving-assist limitation.

The installer accepts the supplied Studio snapshot and the verified repository/preset-update baselines. It preserves Stage 14 prediction/checkpoints and installs the preceding official-preset/K/comma update where needed. It checks every source before any write, backs up to `ServerStorage.NR2003Backup_Assists`, and restores changes if a write fails. Reapplying the installed version is a no-op. To roll back, stop Play and execute `ROLLBACK.lua`; rollback refuses to overwrite scripts edited after installation. Roll back this update before rolling back the preceding preset update.

Original function mapping, numeric checks and remaining limits are in the repository's `ASSIST_IMPLEMENTATION.md`. Automated checks execute recovered original x86 in Unicorn and compare it with Luau. A Studio driving test is still required; this environment cannot run Roblox Studio.
