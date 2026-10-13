# Watkins Glen driving test for the existing NR2003 car

This continuation imports the supplied original NR2003 track into the existing Stage 1–13 car project. The scope is terrain/topography, original textures, tire surfaces and original barrier contacts, with the original pit stall as a test spawn. Race rules, pit limiting, lap timing and Stage 14 are outside this delivery.

The original NR2003 solver remains in charge of the car. Recovered track polynomials and contact primitives supply the wheel/body contacts; Roblox material friction does not determine tire grip. Roblox renders the imported meshes and the existing car/cockpit. The same axis conversion and **0.28 metres per stud** apply to both.

The recovered lap is **3942.875732421875 metres**, or **14081.699044363839 Roblox studs** at this shared scale. The importer calibration restores original widths, elevations and scenery dimensions after Studio import.

## Studio installation

Use your existing place containing the exported NR2003Lab, NR2003Server and NR2003Client. Preserve its imported car model.

For a browser download, use the [complete Studio package](downloads/README_DOWNLOAD.md), which contains the actual GLBs/PNGs and installers. For a repository checkout, use **Git LFS**. GitHub's repository Download ZIP can contain pointer text instead of binary assets. Download/import details are in [assets/README_IMPORT.md](assets/README_IMPORT.md).

1. Stop Play. Import the supplied `assets/glb/*.glb` files with Studio's 3D Importer. Keep the generated chunk names; their textures are embedded.
2. Insert `assets/studio/NR2003TrackVisualInstallers.rbxmx`, then follow `assets/studio/INSTALL_ALL_TRACK_VISUALS.lua` to calibrate the imported chunks.
3. Insert `studio/NR2003_WatkinsGlen_Install.rbxmx`. Run this in the Command Bar outside Play:

```lua
require(workspace.NR2003_WatkinsGlen_InstallV4.Apply)()
```

4. Start Play. The car is placed by the original track placement routine in pit stall 0. The avatar spawns beside it; approach the seat and use the existing F/entry controls. Drive with your existing control bindings and cockpit/camera controls.

The installer checks the exported baseline, preserves the car assets and client, and backs up changed scripts. Full installation and rollback instructions are in `studio/README_INSTALL.md`. Visual geometry stays non-colliding; terrain answers presentation camera queries, while the recovered car world evaluates its own contacts. A small invisible SpawnLocation is used only as a walking surface for the avatar beside the car.

For alternate test positions, set the TestCar numeric attributes `TrackDlong`, `TrackDlat` (metres) and `TrackYaw` (radians relative to the track) before initializing the car. The default is `(341.13, -19.61, 0)`. These are original track coordinates, not Roblox studs. Track diagnostics include `TrackDlongCurrent`, `TrackDlatCurrent`, `TrackSurface` and `TrackContactMode`.

For a useful NR2003 comparison, match the garage setup, weather, tire condition, fuel and damage options. This integration preserves your existing garage baseline; it does not automatically select one of Watkins Glen's separate setup files. For nonzero wind, match the track orientation input as well (`TrackNorth` is radians; the supplied track.ini specifies 180 degrees).

## Fidelity and verification

See `VALIDATION.md`, `SURFACE_RECOVERY.md`, `STUDIO_AUDIT.md` and `assets/manifest.json`. The report separates original equations from Roblox presentation adaptation and lists remaining visual/runtime verification limits. Headless numerical tests do not establish a completed Studio driving comparison or a full-lap visual review.

Converted assets are supplied in this package; installation does not require another conversion or Ghidra. Recovery scripts, source hashes and golden fixtures are retained for reproducibility. Imported meshes and textures still need Studio's normal asset import into your account/place.
