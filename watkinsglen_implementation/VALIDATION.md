# Watkins Glen driving-test validation

The export and recovered contacts are packaged for the supplied Stage 13 car place. **100% NR2003 gameplay/rendering equality has not been established.** Actual Studio driving, appearance and performance have not been tested in this headless environment.

## Scale and contacts

Original loaded lap length: 3942.875732421875 metres, 123 sections. Car and track share 0.28 metres/stud: 14081.699044363839 studs per lap. Axis conversion is `(x,y,z)_Roblox = (-y,z,-x)_NR / 0.28`. Import calibration restores authored widths, elevations and scenery dimensions.

Original continuous queries, broadphase, wheel/body callbacks and material tables supply car contacts. Material data matches the executed original snapshot. Off-road roughness uses the original deterministic 16×16 height table on a 0.2 m grid; no arbitrary shake was added. [SURFACE_RECOVERY.md](SURFACE_RECOVERY.md) records equations and evidence.

## Runtime results

| Check | Result |
| --- | --- |
| 123 section midpoints, 96 ticks each | 123 pass / 0 fail |
| Pit stall, asphalt launch, wall, grass and sand smoke | 43 pass / 0 fail |
| Existing Stage 13 regression | 40 pass / 0 fail |
| Existing adapter / track adapter | 77 pass / 0 fail; 8 pass / 0 fail |
| Reversible installer transaction/recovery | 23 pass / 0 fail |
| Strict original state/contact/written-memory replay | **23 pass / 30 fail** |

Strict failures remain visible and return nonzero. Per-wheel surface IDs match at retained checkpoints, but numeric trajectories/forces differ. Maximum sampled chassis-position differences: pit stall 0.061 mm, 5 s launch 14.74 mm, 4 s wall 31.07 mm, 1 s grass 0.092 mm, 1 s sand 0.001 mm. These are not full-lap bounds. Inherited double intermediates differ from original x87 precision; signed-zero and foreground initialization differences also remain. [RUNTIME_VALIDATION.md](RUNTIME_VALIDATION.md) contains force/speed errors and raw logs.

## Visual results

| Check | Result |
| --- | --- |
| Calibrated exports | 88 GLBs; 3,333 meshes; 1,024,561 triangles |
| Original scenery | 346 placements; 90 track and 35 shared source models decoded |
| Textures | 426 PNGs: 248 original images and 178 lightmap bakes |
| Original cubic wall profile fixtures | 52 numeric bit comparisons; 0 mismatches |
| Terrain refinement | 3,225,404 original-query samples; maximum sampled XYZ error 1.99998669 mm |
| Individual mesh limits | 16,000 triangles; 1,800 studs per dimension |
| Bounds difference after float32 export | Maximum 0.000418813 studs, approximately 0.117 mm |
| Generated source validation | 120 standalone scripts compiled; 119 XML sources; maximum 176,280 bytes |
| Bake/clipping/filter and oversized metadata checks | 4 tests pass |
| Actual visual installer execution in a Roblox API mock | 450 checks pass; all 88 chunks, partial resume, cached reruns, calibration and marker preservation |

Independent verification checks buffers/indices, finite positions/normals/UVs, calibration markers, PNG pixel hashes, dimensions and source/compile limits. Evidence: `validation/assets.log`, `validation/visual_pipeline.log`, `validation/wall_profiles.log`, `assets/visual_accuracy.json` and `assets/manifest.json`.

The Khronos glTF validator independently checks all 88 actual GLBs with **0 errors and 0 warnings**; 183 informational notices concern image dimensions and unused objects. See `validation/gltf_validator.json`. A representative original textured terrain GLB also imports in Blender 4.3.2. These are format/import checks, not a Roblox Studio execution test. The complete browser-download package refuses Git LFS pointers and verifies all ZIP CRCs and binary headers.

Recovery includes 69 custom wall profiles, 52 caps and four TrackDetail painted rectangles. DXG `10047350/10048b40` consumes the cubic profiles; three distinct serialized types match the executed original routine. DXG `1002cf00` uses RGB `D3DTOP_MODULATE` (enum 4) with base alpha retained; 170 rendered strips use that base/lightmap pass. Bakes contain 98,620,283 texels.

Remaining presentation differences: finite tessellation/baking; seven wall sides without the native boundary-transition compiler; four authored nonfinite-UV faces exported using original constant appearance colors; other texture stages/native seam triangulation; Roblox lighting/filtering; static daytime/highest-LOD scenery; uninstalled original sky/fog effects. The sampled 2 mm criterion is not a uniform bound between checks. Collision uses original continuous geometry independently of the visual mesh.

## Studio comparison

Follow [assets/README_IMPORT.md](assets/README_IMPORT.md) and [studio/README_INSTALL.md](studio/README_INSTALL.md). Match setup, weather, fuel, tires and damage options before comparing. The existing garage baseline is preserved. Review Output, cockpit telemetry, grass/sand response and barriers, then drive a complete lap to assess continuous behavior and performance. Race rules and pit limiting are outside this driving-test build.
