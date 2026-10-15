# Download the real Watkins Glen Studio package

**V4 track already installed:** download the [V5 handling update](WatkinsGlen_Handling_Patch_V5.zip) and follow [its instructions](../handling/README.md). No track meshes need reimporting. For a fresh physics installation after importing the assets, use [Physics Installer V5](WatkinsGlen_Physics_Installer_V5.zip).

[Download WatkinsGlen_Studio_Package.zip](https://media.githubusercontent.com/media/brunobasso20/nrport2/codex/watkinsglen-driving-test/watkinsglen_implementation/downloads/WatkinsGlen_Studio_Package.zip)

Use that direct binary download, then extract it. This package includes all **88 actual GLBs**, **426 actual PNGs**, visual installers and the reversible physics patch. Git installation is not required. The repository's green Code → Download ZIP can include Git LFS pointers instead of these binaries.

If the track is already imported and the old visual installer failed with `float64`, download [the small visual installer fix](README_VISUAL_FIX.md) instead of the full package. It resumes the existing import with fresh V3 modules. If the old installed container is gone and the four scenery imports are empty, use [the recovery ZIP](README_VISUAL_RECOVERY.md); it includes only those four missing GLBs.

Extract into a fresh folder. Import `assets/glb/*.glb` and run the visual installer. The large asset archive retains the older V4 physics installer; use the separate **Physics Installer V5** linked above for a fresh installation, or the handling updater when V4 is already installed. Preserve the car model and calibration markers until the visual installers run.

The smallest GLB, `watkins_glen_terrain_009.glb`, is **543,684 bytes**. A real GLB starts with `glTF`; a roughly 130-byte file beginning `version https://git-lfs.github.com/spec/v1` is a pointer. The ZIP's exact byte size and SHA-256 are recorded in `package_info.json`. A package builder refuses pointer inputs and checks ZIP CRCs and every binary header.

If the browser download does not start, save `DOWNLOAD_WATKINSGLEN.cmd` and `package_info.json` from this folder together, then double-click the CMD. It uses built-in Windows PowerShell to download the public GitHub LFS object, checks SHA-256 and saves `WatkinsGlen_Studio_Package.zip` beside itself. It needs no Git, credentials or administrator access. Extract the resulting ZIP manually.

The original runtime/contact and visual fidelity limits remain documented in the package. These files pass binary/format checks; the actual Studio driving and appearance comparison remains to be performed.
