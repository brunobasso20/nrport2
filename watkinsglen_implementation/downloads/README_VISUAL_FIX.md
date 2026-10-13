# Resume the imported track with corrected visual installers

[Download WatkinsGlen_Visual_Installer_Fix.zip](https://github.com/brunobasso20/nrport2/raw/refs/heads/codex/watkinsglen-driving-test/watkinsglen_implementation/downloads/WatkinsGlen_Visual_Installer_Fix.zip)

If the installed `NR2003WatkinsGlen` container has disappeared and the four scenery imports are empty, use [the recovery package](README_VISUAL_RECOVERY.md), which includes just those four missing GLBs.

This small ZIP contains scripts only. Keep your imported track meshes and the scenery that already installed. No GLB reimport is needed for the reported `float64` failure.

1. Stop Play/Run and extract the ZIP.
2. Insert its `NR2003TrackVisualInstallers.rbxmx` into Workspace using Insert from File. The new Model is named **NR2003TrackVisualInstallersV3**. The old `NR2003TrackVisualInstallers` folder can remain; the new command selects V3 explicitly.
3. Clear Selection. Open the included `INSTALL_ALL_TRACK_VISUALS.lua`, paste its complete contents into the Command Bar and run it.
4. Previously completed chunks still present in `NR2003WatkinsGlen` are skipped. The remaining valid terrain/wall chunks calibrate to the original shared **0.28 metres/stud**. Success ends with `Watkins Glen visuals installed: 88 chunks`.

Do not run the old master script again: it points to the old cached modules. If another error occurs, keep the current imported meshes and the complete new Output log; completed chunks remain installed.

The generator now emits native numeric Luau literals rather than Python `np.float64(...)` expressions. Reruns check completed chunks before resolving Selection. Markers and their original Node parents move with the import remainder into `ServerStorage.NR2003Backup_TrackVisuals`; the installer no longer destroys them. This avoids the locked-Parent operation seen in Studio history/Team Create after the previous run.

The corrected actual payloads pass 457 headless checks across all 88 chunks, including the four-scenery partial state, repeated cached calls, rotated/scaled calibration, marker preservation and refusal of malformed imports. This is not a completed Studio execution test. Track geometry, textures, physical dimensions and car physics were not changed by this fix.
