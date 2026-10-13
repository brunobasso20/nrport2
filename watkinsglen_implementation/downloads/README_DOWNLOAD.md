# Download the real Watkins Glen Studio package

[Download WatkinsGlen_Studio_Package.zip](https://media.githubusercontent.com/media/brunobasso20/nrport2/codex/watkinsglen-driving-test/watkinsglen_implementation/downloads/WatkinsGlen_Studio_Package.zip)

Use that direct binary download, then extract it. This package includes all **88 actual GLBs**, **426 actual PNGs**, visual installers and the reversible physics patch. Git installation is not required. The repository's green Code → Download ZIP can include Git LFS pointers instead of these binaries.

Extract into a fresh folder. Follow `README.md`: import `assets/glb/*.glb`, run the visual installer, then apply `studio/NR2003_WatkinsGlen_Install.rbxmx`. Preserve the car model and calibration markers until the visual installers run.

The smallest GLB, `watkins_glen_terrain_009.glb`, is **543,684 bytes**. A real GLB starts with `glTF`; a roughly 130-byte file beginning `version https://git-lfs.github.com/spec/v1` is a pointer. The ZIP's exact byte size and SHA-256 are recorded in `package_info.json`. A package builder refuses pointer inputs and checks ZIP CRCs and every binary header.

If the browser download does not start, save `DOWNLOAD_WATKINSGLEN.cmd` and `package_info.json` from this folder together, then double-click the CMD. It uses built-in Windows PowerShell to download the public GitHub LFS object, checks SHA-256 and saves `WatkinsGlen_Studio_Package.zip` beside itself. It needs no Git, credentials or administrator access. Extract the resulting ZIP manually.

The original runtime/contact and visual fidelity limits remain documented in the package. These files pass binary/format checks; the actual Studio driving and appearance comparison remains to be performed.
