# Apply the compatible Watkins Glen physics installer

The current CupTune differs from the original export only by `driver.momentumKeys = 0` instead of `nil`. This is an existing original-driver option. V2 accepts this exact known variant and preserves the entire CupTune source, including that keyboard steering setting. Other unverified CupTune changes are still refused.

1. Stop Play/Run. Keep the already calibrated track and existing car package.
2. Insert the included `NR2003_WatkinsGlen_Install.rbxmx` into Workspace using Insert from File. Its Model name is **NR2003_WatkinsGlen_InstallV2**. The old installer Model can remain; V2 uses fresh modules and a fresh compatibility list.
3. Run the included command in the Command Bar:

```lua
require(workspace.NR2003_WatkinsGlen_InstallV2.Apply)()
```

The track payloads, car assets and client are unchanged from the previous physics installer. CupTune is checked as a dependency and is not replaced. The installer retains its other source/dependency checks, backup, rollback and automatic recovery behavior. After successful installation, start Play; the car should spawn at the original first pit stall. Approach it and press F to enter.

The previous dependency refusal occurred before mutation. A rollback is unnecessary for a refused install. If an earlier successful different physics patch already has a backup, follow its rollback instructions before changing versions.

Thirty headless checks pass, including source preservation with momentumKeys=0, absent final newline, repeated installation, rollback, unknown-scale refusal and injected write-failure recovery. Actual Studio execution remains to be checked. Track/car scale remains 0.28 metres per stud.
