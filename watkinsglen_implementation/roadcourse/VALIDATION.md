# Road-course V6 validation

## Corrected omission in V4/V5

The uploaded Watkins Glen track.ini has `chassis_type=4`. V4/V5 retained the
inherited Cup bench vehicle's `chassis_type=2` even after loading stock track
setup files. Earlier controls/setup-file tests passed but did **not** validate
this vehicle selection: the driving reference inherited the same wrong type.
Those older reports are historical evidence, not road-course parity evidence.

The original selectors/build now choose the road-course car spec at 0x723c70
instead of 0x7238e0. Original tire selection 0056ed60 then chooses profile 8
(pointer 0x8b0fa0) on all four wheels; the former all-right-side speedway
selection in these runs used profile 5 (0x8b0df0). Profile selection also affects
pressure, slip/load and thermal parameters; changing fast/easy did not change
the underlying vehicle specification.

Both the NR2003 and server memory exports contain VS_FIXEDFILEINFO version
**1.2.0.1**, matching the version named by `nr2003_update_en_1000_1201 patch.exe`.
The Drive installer itself was not downloaded; its filename does not prove that
no additional modifications exist in the user's installed game.

## Recovery and exact checks

* Original pre-application snapshots for chassis 2 and 4 differ at eight aligned
  input words. V6 restores the original chassis-4 words before rebuilding.
* Original x86 emitter: default plus fast/easy/qualify/jasper produce a common
  road generic callback code hash and common placed callback code hash. A
  speedway-shared literal now needs a distinct road-course literal. Three
  additional placed constant cells are allocated from their original values.
  `emitter_report.json` retains hashes, counts and the recovered input words.
* Three independent original-x86 drives explicitly construct chassis 4, load
  the real setup file through 00558830/00558da0, and use original raw keyboard
  throttle/clutch with all boolean aids off. Each executes 1,152 physics ticks.
* Each drive verifies **150 spec/profile constants bit for bit** against the
  original: 450 checks across the three cases. All four actual tire-object
  profile pointers are checked again after entering the track.
* Pedal/clutch, gear and per-wheel material checkpoints: **zero mismatches** in
  all three drives.

## Measured trajectories — not full equality

70 F, no wind, keyboard steering momentum 0 matched on both sides, manual shift
at frame 18 and full raw throttle from frame 24. The concrete case starts at
track coordinates (799.8, -2.8) and adds a short steering pulse. Pit cases start
at the original first stall (341.13, -19.61). All runs cover four simulated
seconds, including the initial idle/shift interval.

| Maximum sampled difference | pit fast | pit easy | concrete fast |
| --- | ---: | ---: | ---: |
| Chassis position, m | 0.000793457 | 0.001953125 | 0.001464844 |
| Velocity component, m/s | 0.016750813 | 0.013632059 | 0.007010937 |
| Engine RPM | 100.812 | 104.553 | 84.096 |
| Yaw rate, rad/s | 0.000399331 | 0.000477924 | 0.001918294 |
| Instantaneous tire-force component, N | 4379.287 | 5001.593 | 264.018 |
| Tire-force component RMS error, N | 229.739 | 259.895 | 14.016 |

One second after full throttle, pit-fast speed is 15.606 km/h versus 15.595 in
the original reference; pit-easy is 15.800 versus 15.793. At 3.33 seconds,
pit-fast is 63.784 versus 63.783 km/h. These runs do not reproduce an immediate
7,000-RPM spike: pit-fast RPM at those two times is 1172.52/1113.93 and
4093.87/4011.02 (port/original).

**Material force and RPM differences remain.** Small chassis-position errors
do not certify identical grip, long-run stability or keyboard driving feel.
The inherited intermediate-precision limitation remains; the full cause of
all remaining discrepancies has not been isolated. No full-lap equivalence or
actual Roblox Studio driving result is claimed.

## Runtime / installer checks

* All four stock setups build, enter native contacts, survive reset, and retain
  chassis 4 and four profile-8 tire objects. Restoring a default image also
  retains the correct road callback set.
* A separate bench vehicle retains chassis 2 and its original callbacks. Build
  reference metadata is now per instance; a road car cannot change another
  vehicle's callback-layout validation.
* Actual adapter and existing HUD callback: **15 checks passed**. The adapter's
  host raycast/blockcast methods throw if called by track physics. Existing
  support, airborne-zero and legacy-telemetry checks still pass.
* Existing Stage 10 garage regression: **61 passed, 0 failed**.
* Existing Stage 13 regression: **40 passed, 0 failed**.
* Actual shipped V4 + actual V5 updater + actual V6, and separately actual full
  V5 + V6: **33 transaction checks passed**. These cover separate backups,
  source/instance preservation, all rollback layers, unknown/unsaved edits,
  damaged backups, injected write/recovery failures, Play refusal and shared
  operation locking. No server Script, car mesh or track asset is replaced.

The HUD reports the loaded setup, actual chassis type and four selected tire
profile IDs alongside the existing native surface/force telemetry.

Reproduce from the repository root (Luau CLI and original exports for fixture
regeneration):

```sh
luau -O2 --codegen watkinsglen_implementation/roadcourse/tests/run_vehicle.luau
luau -O2 --codegen watkinsglen_implementation/roadcourse/tests/run_driving.luau
python3 tools/build_watkinsglen_roadcourse.py
python3 tools/make_watkinsglen_roadcourse_mock.py
luau -O2 work/feeling_v5/installer_mock.luau
python3 tools/verify_watkinsglen_roadcourse.py
```

V5 installers/ZIPs remain the historical shipped binaries. Use commit 3dced7f
when reproducing their old build scripts; current road-course sources belong
to V6. The new V6 generator uses the pinned V5 manifests and emits only the
changed runtime sources plus the new road callback/specification modules.
