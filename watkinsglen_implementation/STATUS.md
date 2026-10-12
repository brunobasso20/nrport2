# Watkins Glen — status (WIP, partial delivery)

**Stage 14 has not been started.** This is a partial delivery. The work stopped early because the weekly usage limit
was running out.

## Done

* **ORIGINAL track load in Unicorn** (`recovery/orig_track.py`, `orig_world.py`). This covers the PTF descriptor readers,
  the track build `00510b70` / `005108f0` (123 sections, 3942.876 m), the track.ini loaders `00538560` (through the
  rts.dll ProfileManager host) and the `00573010` track init.
* **ORIGINAL per-tick world in the reference.** Each frame runs `005789c0` broadphase and `00578a60` pairs. Each tick
  runs contact passes `00578da0` / `00578de0` (tyres → `0055e1e0`, body spheres → walls), `005543f0` world record +
  track query and `00551480`. The car sits on the track at the pit stall (`005512f0`).
* **Track and collision world lifted to Luau.** This is 243 ORIGINAL functions (`recovery/lift/lift_track.py`), plus
  rts.dll `RBNodeBase::Remove`, which is also lifted. Generated modules are in `core/NR2003Cup/`:
  * `NR2003CupTrackCode1..6`: the lifted code.
  * `NR2003CupTrackData1..5`: the track image. It holds the arena, the pools, and the cells the track load changed.
    Examples are track.ini `track_tire_heat` 1.12, `track_tire_wear_exp` 1.11, and the wear-loss grip table ×0.8.
  * `NR2003CupTrack`: the host. It provides `V.loadTrack()`, the placement, and the hooks for each frame and each tick.
* **Car placed on the track = ORIGINAL in-place rebuild** `00551760 → 005b2f20` at the placed pose. At that pose the
  emitter takes 635 decisions differently from the bench pose, and those 635 are identical at every pose measured
  (pit stall 0, pit stall 22 and the straight).
  `recovery/lift/gen_placed.py` generates the placed callback structures: `NR2003CupJITP*` for natural and
  `NR2003CupJITPG*` for generic. It also generates their decision tables (`NR2003CupTrackBuild`).
* **Core integration hooks.** These are inert unless `V.loadTrack()` is called:
  * Driver: world tick order.
  * Frame: `V._place` at `@00550aeb`, and the Stage 11 `005f58d0` queries the loaded track.
  * Build: input overrides, `rebuildFromState`, `addStructure`.
  * Garage: image refresh and callback-set selection.
  * Vehicle loader: memory extended to `0x1250000`.

## Validated

* After the hook changes, the Stage 13 regression gives **40 PASS / 0 FAIL**. This was before the last Build/Garage
  API additions, so the full Stage 1–13 regression must be rerun.
* In Luau, `loadTrack` loads 123 sections, 3942.876 m and 43 pit stalls.

## Not finished (next steps, in order)

1. **Not yet run:** the first Luau session with the placed structures (`tests/run_track.luau stall0`). The last run was
   cut off by a time limit before it reported, so whether placement and ticks work is unknown. If the run is just slow,
   use a longer timeout. Then compare with the reference fixtures (`recovery/ref_track.py` →
   `recovery/gen_fixtures_track.py`, scenarios stall0 / launch / wall) bit for bit.
2. **Not started:** the visual conversion. This covers the PTF surfaces and walls, the 90 TSO `.3do` objects, the 171
   `.mip` textures and the sky (shared.dat). The plan is to reuse `nr2003carmodel_implementation/pipeline` (DAT, 3do,
   MIP, GLB) and to build the surface meshes from the ORIGINAL `005150fa` track → world.
3. **Not started:** track features. These are the grid layout, start/finish and lap timing (`005f58d0` record), the pit
   lane and its speed limit, and the surface / environment data needed later for audio.
4. **Not started:** Studio install script, assets (LFS), full regression, docs.

## Regenerating

```
export NR2003_MEM SERVER_MEM RTS_MEM WG_TRACK=<tracks/watkins_glen> WG_SHARED=<tracks/shared>
python3 recovery/ref_track.py plain plain.pkl
python3 recovery/ref_track.py world w_stall0.pkl stall0
python3 recovery/lift/gen_track.py <out> plain.pkl w_stall0.pkl
python3 recovery/lift/gen_placed.py <out>
```
