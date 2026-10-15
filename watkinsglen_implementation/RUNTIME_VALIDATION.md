# Watkins Glen runtime validation

For V5 stock-setup/raw-keyboard tests, see [handling/VALIDATION.md](handling/VALIDATION.md). The older scenarios below injected a processed throttle value and therefore did not cover original `00552df0`. V5 adds independent original pedal and file-loader tests; complete dynamics equality remains unproven.

This is a driving test build. The recovered track algorithms and material data run, and every runtime section
passes the placement/contact coverage test. **The complete physics trajectories are not bit-identical to NR2003.**
The strict tests retain their failures and return a nonzero exit status.

## Final checks

| Check | Result | Evidence |
| --- | --- | --- |
| 123 section midpoints, 96 ticks each, finite states and real positive tyre contacts | 123 pass / 0 fail | `validation/section_sweep.log` |
| Five scenarios: pit stall, asphalt launch, barrier, grass and sand; reset/end-session checks | 43 pass / 0 fail | `validation/track_smoke.log` |
| Stage 13 core regression after shared speed-cache stamp preservation | 40 pass / 0 fail | `validation/stage13_runtime.log` |
| Original x86 PUSH ESP/register/ESP-relative memory semantics vs generated Luau | 6 pass | `validation/lifter_stack.log` |
| Original executed-code state and written-memory comparison | 23 pass / 30 fail | `validation/track_reference.log` |

The smoke total includes exact checks of 20 loaded grip scalars, 20 contact stiffness values, 20 damping values,
20 rolling constant terms, 20 speed-squared rolling terms, 20 surface heat values, 256 roughness heights and both
roughness constants. All match the original executed track-load snapshot bit for bit. It also checks 193 off-road
height samples against recovered `00513eaa` and track/world coordinate roundtrips.

The five strict reference scenarios compare surface IDs, forces, rolling torque, contact speeds, the 45-state
vector and every originally written checkpoint cell. **All per-wheel surface IDs at those checkpoints match.**
The numeric state, force and memory checks fail; their tolerances were not weakened to produce a pass.

## Measured differences from the original reference

These are maximum absolute component differences at the retained samples/checkpoints, not guarantees for arbitrary
laps. Force values are tyre-frame Fx/Fy/Fz; rolling values are the original rolling-resistance torque cells.

| Scenario | Duration (s) | Chassis position (m) | Velocity (m/s) | Wheel force (N) | Rolling torque (Nm) | Contact speed (m/s) |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| stall0 | 0.667 | 6.10351562e-05 | 0.00055347383 | 15.7805176 | 0.00302219391 | 0.00214016438 |
| launch | 5 | 0.0147399902 | 0.0126514435 | 370.709961 | 0.0670511723 | 0.538480163 |
| wall | 4 | 0.0310668945 | 0.101448417 | 111.486328 | 0.222793579 | 0.0676348209 |
| grass | 1 | 9.15527344e-05 | 0.00116921775 | 7.97008419 | 0.100875854 | 0.00529953837 |
| sand | 1 | 9.53674316e-07 | 1.05947256e-05 | 0.240112305 | 0.00842285156 | 3.27993184e-05 |

`validation/runtime_metrics.json` also contains quaternion component differences. An internal suspension/drivetrain
state can differ more than the chassis position; inspect the strict log for the worst state index rather than
interpreting every entry of the mixed-unit 45-state vector as metres.

## What was recovered and what limits equality

The loaded 123-section, 3942.876 m track image and the original section queries, world broadphase, tyre contact
passes, body/barrier callbacks, material grip/compliance/rolling tables and off-road height mechanism are used.
Contacts call the existing recovered vehicle `0055e1e0`; Roblox friction/raycast approximations do not supply those
track-mode forces. Simulation coordinates remain original metres. The presentation mapping remains **0.28 m/stud**;
no vehicle/track physical dimensions or tuning were changed to improve comparisons.

The inherited Stage 1–13 core and the track lifter evaluate most x87 intermediates as IEEE double (53-bit
significand), while NR2003 uses x87 64-bit significands. The existing float32 stores round toward negative infinity;
this does not restore the missing intermediate precision. Small differences accumulate through suspension,
contact and wheel states. Signed-zero and foreground mirror initialization differences also remain in the complete
written-memory comparisons. This work does not certify complete mathematical or gameplay equality.

## Concrete runtime fixes

* Corrected 14 lifted PUSH ESP sites and the generator: x86 pushes the stack pointer value **before** decrementing
  ESP. The previous output corrupted collision iterators and hung on the first broadphase.
* Included the complete initialized executable .rdata/.data at load time, in nine TrackData parts (979,040 decoded
  bytes), rather than only data touched by a few reference drives. This includes alternate collision vtables.
* Published the placed BG collision record before the first broadphase, using original `005543f0` and `00551480`.
  This is an explicit single-thread host startup boundary, mirrored in the original-code reference harness. The
  complete game normally reaches readiness through BG snapshot publication before race-order insertion. It is
  not claimed to be an additional call inside original `005512f0`; see `SURFACE_RECOVERY.md` for the task evidence.
  The initial omission caused first-tick explosions at 61 section midpoints; after the fix all 123 pass.
* Preserved the original speed-cache timer stamp and added read-only track/contact telemetry from actual callbacks.
  Current contact observations clear per pass so an airborne wheel does not retain a previous grounded flag.

The old startup-failure evidence is retained in `validation/pre_startup_section_sweep.log` and
`validation/pre_startup_reference.log`. Final original fixtures were regenerated **after** the shared startup fix;
they are committed under `tests/fixtures/`. Raw executable/DLL memory exports stay under scratch `work/`.

## Performance and remaining verification

Timing is measured with Luau `os.clock()`, which uses a monotonic elapsed clock on this Linux toolchain, not
process CPU time. Selected scenarios were measured with native code generation; see the smoke log for elapsed
seconds per simulated second and the appended process timing. Results vary with concurrent workspace activity.
The section sweep also rebuilds the car repeatedly, so its elapsed time is not a steady-state driving benchmark. Roblox Studio/server performance, a continuous driven full lap, actual steering
wheel force-feedback hardware and multi-car contacts have not been validated by these CLI tests.

Reproduce with:

```sh
luau -O2 --codegen watkinsglen_implementation/tests/run_track.luau -a +smoke
luau -O2 --codegen watkinsglen_implementation/tests/run_sections.luau
luau -O2 --codegen watkinsglen_implementation/tests/run_track.luau
luau -O2 --codegen tests/stage13/run.luau
LUAU=luau python watkinsglen_implementation/tests/test_lifter_stack.py
```

The third command intentionally fails while strict reference differences remain. Golden fixture regeneration uses
`recovery/ref_track.py` and `recovery/gen_fixtures_track.py` with the original NR2003/server/rts memory exports and
the uploaded track directories, as described in `STATUS.md`.
