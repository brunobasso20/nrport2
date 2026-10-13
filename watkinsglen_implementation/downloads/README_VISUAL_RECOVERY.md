# Recover the exported Studio track state

[Download WatkinsGlen_Visual_Recovery.zip](https://github.com/brunobasso20/nrport2/raw/refs/heads/codex/watkinsglen-driving-test/watkinsglen_implementation/downloads/WatkinsGlen_Visual_Recovery.zip)

The supplied `state.rbxm` contains 84 complete terrain/wall imports, with all expected meshes and calibration markers. Its four scenery models contain empty Node wrappers: their 494 scenery meshes and 16 markers are absent. The previously installed `NR2003WatkinsGlen` model is also absent. V2 correctly refuses those empty scenery imports, but its master stopped before reaching the 84 valid road/wall chunks.

## Install from this state

1. Stop Play/Run and extract this recovery ZIP into a fresh folder.
2. Import **only the four GLBs included in its `glb/` folder**. Keep all existing 84 terrain/wall imports. The empty scenery wrappers can remain; V3 finds the complete replacements even if Studio adds a suffix such as `(1)` or nests them in another folder. Enable textures and retain all four marker meshes in each GLB.
3. Insert the included `NR2003TrackVisualInstallers.rbxmx` into Workspace using Insert from File. Its Model name is **NR2003TrackVisualInstallersV3**. V1/V2 installers can remain; the new master selects V3 explicitly.
4. Clear Selection. Paste the included **new** `INSTALL_ALL_TRACK_VISUALS.lua` into the Command Bar and run it outside Play.
5. Success ends with `Watkins Glen visuals installed: 88 chunks`. `Workspace.NR2003WatkinsGlen` then has `NR2003VisualChunksReady = 88`, `NR2003VisualsComplete = true`, `TrackOriginEnabled = true` and `NR2003MetresPerStud = 0.28`.

V3 processes each chunk independently. If an import is missing, the remaining valid chunks still calibrate and the final Output lists only the pending ones. Rerunning V3 preserves completed chunks. The original marker meshes and their Node parents are retained with the import remainder in `ServerStorage.NR2003Backup_TrackVisuals`; they are not destroyed. The place is not saved or published automatically.

The exact imported hierarchy and transforms from the supplied state are regression-tested. That state first reaches 84 ready chunks and correctly reports four missing imports; after restoring those four originals it reaches 88 and reruns without duplicating chunks. Maximum recovered centre difference from the original geometry metadata is 0.000508343 studs, approximately 0.142 mm. The test uses the actual captured import data in a Roblox API mock; actual Studio execution still needs checking.

Track geometry, textures, original physical dimensions and car physics remain unchanged. Keep the shared 0.28 metres/stud calibration. After visual recovery, use the existing physics patch instructions for the original track driving test.
