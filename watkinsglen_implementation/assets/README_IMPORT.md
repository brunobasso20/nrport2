# Import Watkins Glen into the existing car place

Finished exports include 88 GLBs, 426 PNGs, 346 scenery placements and original terrain/barriers. Textures are embedded in each GLB. Car and track both use **0.28 metres per stud**; the original lap is **3942.875732421875 metres**.

## Obtain actual assets

For browser downloads, use the [complete Studio package](../downloads/README_DOWNLOAD.md). It contains real binaries and requires no Git installation. GitHub's repository Download ZIP can contain 130-byte Git LFS pointer files; Studio rejects those with “Failed to open the selected file.”

GLBs and PNGs use Git LFS. Download an LFS checkout:

```sh
git lfs install
git clone --branch codex/watkinsglen-driving-test https://github.com/brunobasso20/nrport2.git
cd nrport2
git lfs pull
```

For an existing checkout, fetch/switch to the branch and run `git lfs pull`. A real GLB starts with `glTF`. A small text file beginning `version https://git-lfs.github.com/spec/v1` is a pointer and cannot be imported; source ZIPs may contain pointers.

## Import and calibrate

1. Open the existing place containing your NR2003Lab, server/client and imported car. Stop Play.
2. Import all `glb/*.glb` with Studio's 3D Importer, in batches if needed. Import complete scenes into Workspace, preserve file/model and mesh names, retain all four `NR2003_MARKER_*` meshes and enable textures. Disable per-object recentering. Each mesh stays within 16,000 triangles and 1,800 studs per dimension.
3. Insert `studio/NR2003TrackVisualInstallers.rbxmx` into Workspace using Insert from File. Clear selection. Paste the contents of `studio/INSTALL_ALL_TRACK_VISUALS.lua` into the Command Bar and run it outside Play.
4. The installer creates `Workspace.NR2003WatkinsGlen` at identity pivot, restores original scale/position from the markers and removes them. It sets `TrackOriginEnabled = true` and `NR2003MetresPerStud = 0.28`. Uniform translation, rotation and scale are corrected; nonuniform/reflected transforms and missing meshes stop the affected chunk before editing it.
5. Install the physics patch following [../studio/README_INSTALL.md](../studio/README_INSTALL.md), then start Play and enter the existing car. The first original pit stall is the default spawn.

If a chunk is missing, import that GLB under its original name and rerun the master. Completed chunks are skipped. You can also select one complete imported chunk and run its matching `studio/INSTALL_<chunk>.lua`. Replaced chunks remain in `ServerStorage.NR2003Backup_TrackVisuals`. The master installs chunks separately; a later failure leaves earlier successful chunks installed. It does not save or publish the place.

For missing textures, check Studio's normal image import/moderation result. `textures/` contains separate PNG copies. `luau/WatkinsGlenVisualData.rbxmx` is optional inspection metadata.

Meshes are anchored, non-colliding and non-touchable. Terrain answers existing chase-camera queries. The recovered NR2003 world supplies car contacts, grip/compliance and off-road bumps. Roblox material friction does not tune the car. [../VALIDATION.md](../VALIDATION.md) records passing checks and remaining differences, including unverified Studio performance/appearance and a continuous driven lap.
