# Watkins Glen continuation status

**Current V6:** [road-course correction](roadcourse/README.md) selects chassis 4 and tire profile 8. V4/V5 incorrectly retained the bench speedway specification. [New explicit road-course references](roadcourse/VALIDATION.md) document the correction and remaining dynamics differences. The older counts below are historical.

The original-track driving test is implemented and packaged. Scope is scale/topography, textures, surface behavior and body/barrier contacts. Stage 14/15, race rules, lap timing and pit limiting have not been started.

## Completed

- Original 123-section runtime, length 3942.875732421875 m, with original world/tire/body contacts.
- Shared 0.28 metres/stud conversion and calibrated Studio import at original dimensions.
- Original grip, compliance, rolling resistance, heat and roughness data checked against executed original code.
- Fixed PUSH ESP semantics, initialized static-data coverage and startup collision-record publication.
- All 123 section midpoints pass contact/stability coverage; smoke 43/0; Stage 13 40/0; adapter 77/0 and track adapter 8/0.
- Finished exports: 88 GLBs, 426 PNGs, all 346 TSO placements, wall profiles/caps and painted details. Independent asset validation passes.
- Terrain refined against 3,225,404 original-query samples to a sampled 2 mm criterion; base/lightmap pass baked for Roblox.
- Reversible Studio patch preserves existing car/cockpit/client/controls; installer transaction 23/0.

Strict original-code replays retain differences: **23 pass / 30 fail**. This is not certified 100% gameplay equality. Studio performance, appearance and a continuous driven lap remain unverified. See [VALIDATION.md](VALIDATION.md) and [RUNTIME_VALIDATION.md](RUNTIME_VALIDATION.md).

## Reference regeneration

Recovery uses `NR2003_MEM`, `SERVER_MEM`, `RTS_MEM` for Ghidra memory-export directories, and `WG_TRACK`/`WG_SHARED` for supplied track directories. Original inputs/tools/intermediates stay under `work/`.

```sh
python3 watkinsglen_implementation/recovery/ref_track.py plain work/plain.pkl
python3 watkinsglen_implementation/recovery/ref_track.py world work/world.pkl
python3 watkinsglen_implementation/recovery/gen_fixtures_track.py \
  watkinsglen_implementation/tests/fixtures work/world.pkl
```

Golden fixtures are committed in `tests/fixtures/`; GLBs/PNGs use Git LFS. Installation requires no new conversion/Ghidra. Follow [README.md](README.md), [assets/README_IMPORT.md](assets/README_IMPORT.md) and [studio/README_INSTALL.md](studio/README_INSTALL.md).
