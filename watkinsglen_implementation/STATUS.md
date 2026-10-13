# Watkins Glen continuation status

Stage14 has not started. Scope is the original track driving test: scale/topography, textures, surface behavior and body/barrier contacts. Race rules, lap timing and pit limiting are excluded.

## Completed runtime integration

- Original123-section track runtime, length3942.875732421875m, with original world/tire/body contact functions.
- Same0.28metres/stud and NRaxis conversion as the existing car. Studio import markers restore that scale and placement.
- Original material grip, stiffness/damping, rolling resistance, heat and off-road roughness data checked against executed original code.
- Fixed lifted PUSH ESP semantics, complete initialized static-data coverage and startup collision-record publication.
- All123section midpoints pass96ticks of contact/stability coverage; five-case smoke43pass/0fail; Stage13regression40pass/0fail; real adapter mock77pass/0fail and original-track adapter8pass/0fail.
- Reversible Studio patch preserves the existing car meshes, cockpit, client and controls; installer transaction23pass/0fail.

Strict original-code replays retain numerical differences:23pass/30fail. This is not certified100% gameplay equality. See RUNTIME_VALIDATION.md and validation/track_reference.log for physical-unit errors and the inherited x87 intermediate-precision limitation.

## Visual work

The complete original PTF,346TSO placements and source textures are parsed. Renderer-derived custom wall profiles, caps and four TrackDetail overlays are recovered. Terrain has been refined against3,225,404 sampled original-query checks to a sampled2mm criterion. Original base/lightmap multiplication is being baked for Roblox's single-UV material interface. Final exports and asset verification are being finalized; all converted files will be kept under assets/.

## Reference regeneration

The recovery programs use NR2003_MEM,SERVER_MEM,RTS_MEM for Ghidra memory-export directories and WG_TRACK/WG_SHARED for the supplied track directories. Local inputs/tools/intermediates remain under work/.

```
python3 watkinsglen_implementation/recovery/ref_track.py plain work/plain.pkl
python3 watkinsglen_implementation/recovery/ref_track.py world work/world.pkl
python3 watkinsglen_implementation/recovery/gen_fixtures_track.py work/world.pkl
```

The original golden fixtures are retained in tests/fixtures/. Converted assets will be sufficient for Studio installation without repeating recovery or conversion. Follow README.md and studio/README_INSTALL.md.
