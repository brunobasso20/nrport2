# Fresh Watkins Glen V5 physics installation

This is for the original Stage 13 car place after the track visuals have been
imported and calibrated. If V4 is already installed, use
**WatkinsGlen_Handling_Patch_V5.zip** instead, preserving its existing backup.

Stop Play. Insert **NR2003_WatkinsGlen_InstallV5.rbxmx** into Workspace and run:

```lua
require(workspace.NR2003_WatkinsGlen_InstallV5.Apply)()
```

The installer enables the original world and stock `fast.cup.sim` setup, corrects
keyboard throttle/clutch processing, updates the existing track HUD and retains
the main server and imported car/track assets. It checks all sources before
writing and backs up every changed source. Unknown client/solver edits refuse
before mutation.

Source of the handling changes, selectable setups, metrics and fidelity limits:
`../handling/README.md` and `../handling/VALIDATION.md` in the repository.
Whole-game numerical equality and an actual Studio driving comparison are not
certified by the headless tests.
