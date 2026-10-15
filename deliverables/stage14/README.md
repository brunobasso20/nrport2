Stage 14 — local NR2003 simulation for the supplied Watkins Glen V6

The driver runs the recovered V6 vehicle solver locally. Steering, throttle,
brake, clutch and shift commands enter the next original device-processing
boundary without waiting for a network reply. Physics stays at 288 Hz and
device processing at 36 Hz. The server independently processes the ordered
commands, acknowledges completed frames, sends complete corrections when
necessary, and replicates its accepted motion to other clients.

**Install into your existing V6 place**

1. Stop Play/Run and save any open script editors.
2. Extract this ZIP. Insert `NR2003_Stage14_Install.rbxmx` into Workspace using
   Insert from File. Its Model name is `NR2003_Stage14_Install`.
3. Run this exact command in Studio's Command Bar:

```lua
require(workspace.NR2003_Stage14_Install.Apply)()
```

Wait for `Stage 14 installed`, then start Play. Save the place after reviewing
it. The installer does not publish or save the place.

The HUD now shows local tick, acknowledged command/tick, outstanding commands,
ping RTT, simulation backlog, reconciliation count and correction distance.
`event->local present` measures the host event through the scheduled local
simulation/presentation path; it does not measure monitor scanout or certify
input-to-photon latency. Remote snapshot age appears in render diagnostics.

The installer changes 21 sources, verifies 67 V6 dependencies, updates existing
instances in place, and keeps the exact preceding sources in
`ServerStorage.NR2003Backup_Stage14`. It preserves the installed CupTune, the
chassis-4/profile-8 selection, setups, track/car assets, cameras and seat
access implementation. Unknown source edits and unsaved editor buffers cause
refusal before installation writes.

**Rollback**

Stop Play/Run and run:

```lua
require(game.ServerStorage.NR2003Backup_Stage14.Rollback)()
```

This restores the exact pre-Stage-14 sources and removes Stage 14's added
modules. It retains the backup under a unique
`NR2003Backup_Stage14_RolledBack_<timestamp>` name. Existing V6/V5/V4 backups
remain available. To reapply Stage 14, run the same Apply command again.
The inserted installer Model can be deleted after a successful install; the
rollback is self-contained in ServerStorage.

**Validation and limits**

717 checks passed across deterministic/network tests, the actual V6 adapter,
client/server orchestration, installer transactions, and Stage 10/13
regressions. Roblox APIs and transport were mocked where required. There was
no connected Roblox Studio session, so actual Studio multiplayer, renderer,
input-to-photon latency and hardware performance remain unverified.

Car-to-car contacts are currently ghosted. Native track/barrier contacts run
locally and in server verification. Contact racing needs a shared original
multicar collision world and authoritative interaction events.

Read `STAGE14_REPORT.md` for measurements, state ownership, checkpoint coverage,
network policy, the exact test scope and inherited NR2003 numerical differences.
`validation/` contains the raw logs. `source/` is the reconstructed runtime and
headless test snapshot for review; the installer performs the selective Studio
update described above. No subagents were used.

**Run the supplied headless checks**

From `source/`, with Luau 0.741 available:

```sh
luau -O2 --codegen stage14_implementation/tests/run.luau
luau -O2 --codegen stage14_implementation/tests/adapter_integration.luau
luau -O2 stage14_implementation/tests/runtime_mock.luau
luau -O2 stage14_implementation/tests/installer_mock.luau
luau -O2 --codegen stage14_implementation/tests/profile.luau
```

The generated mocks are included. Their generators use the original
repository's mock helpers; rebuilding those generators requires that
repository. The installer itself can be rebuilt from this snapshot with
`python3 stage14_implementation/tools/build.py`; its pinned manifest retains
the accepted V6 source fingerprints.
