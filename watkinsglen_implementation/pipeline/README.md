# Watkins Glen visual conversion

Studio users can install the committed assets directly; conversion and Ghidra are not required. See [../assets/README_IMPORT.md](../assets/README_IMPORT.md).

`ptf.py` strictly reads the PTF and invokes original lifted `005150fa`/`005f58d0` surface queries. `render_recovery.py` transcribes renderer UV, wall/cap and TrackDetail behavior. `convert_track.py` reuses the existing car project's DAT/3DO/MIP reader, applies original placements and exports calibrated GLBs and bounded Studio scripts. `lightmaps.py` bakes original base/lightmap RGB multiplication, preserving base alpha and independent UV streams. Original texture texels, resource hashes, scene branches and renderer descriptors remain inspectable.

## Rebuild

Use Python 3, NumPy, Pillow and a native Luau CLI. Extract supplied archives to scratch directories. From the repository root:

```sh
python3 -m venv work/converter-venv
work/converter-venv/bin/pip install numpy pillow
work/converter-venv/bin/python watkinsglen_implementation/pipeline/convert_track.py \
  --track work/tracks/watkins_glen --shared work/tracks/shared \
  --generate-geometry --luau /path/to/luau --work-dir work/geometry \
  --road-tolerance 0.002 --terrain-tolerance 0.002 --out work/rebuilt-assets
```

Generation executes recovered queries and can take substantial time. To reuse generated geometry, replace generation/query options with `--geometry work/geometry/geometry.json`. Default state is daytime/race/full population/highest LOD; `--variable NAME=VALUE` selects explicit authored branches. `--no-lightmap-bake` creates a diagnostic base-texture export.

```sh
python3 watkinsglen_implementation/pipeline/verify_assets.py work/rebuilt-assets \
  --luau-compile /path/to/luau-compile
LUAU=/path/to/luau python3 -m unittest discover \
  -s watkinsglen_implementation/pipeline/tests -p 'test_*.py'
python3 watkinsglen_implementation/pipeline/tests/verify_profiles_fixture.py work/watkins_glen.ptf
```

The profile check uses original PTF and committed original-code bit fixtures. `verify_profiles_native.py` can regenerate evidence using original Ghidra memory exports and the recovery environment. Original binaries/exports remain scratch inputs. See [../VALIDATION.md](../VALIDATION.md), `../assets/manifest.json` and `../recovery/evidence/rend_dxg/` for renderer evidence and finite bake/tessellation limits.
