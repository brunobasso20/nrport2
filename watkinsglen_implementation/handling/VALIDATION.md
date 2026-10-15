# Watkins Glen V5 handling validation

This update corrects demonstrated input/setup problems. It does **not** establish
100% numerical or driving equality with the original game. The packaged update
has not been driven in an actual Roblox Studio session in this environment.

## Original input and setup comparisons

* **1,800 throttle vectors, zero bit mismatches:** original x86 `00552df0`, axis
  processing and written pedal state, including digital/analog bindings, axis
  rates, release with/without braking, and TC enabled/disabled. The TC-off group
  contains 1,200 vectors. Expected values execute the original function; they are
  not supplied by the old host pedal injection.
* **270 clutch vectors, zero bit mismatches:** original `005534f0`, including its
  low-speed gate, manual/automatic modes and signed-zero stores.
* **280 setup input fields, bit exact:** the independent original `00558830`
  binary decoder and `00558da0` validator versus all four ported setup profiles.
  The reader resets internal setup fields before loading. V5 follows that reset
  instead of retaining hidden bench settings, including the old bump-stop items.
* `fast`, `easy`, `qualify` and `jasper` each build, enter the original world and
  execute native tire-contact ticks. The default is `fast` (22.5 psi, 16:1).

The original keyboard throttle rises by 0.1 per 36 Hz frame. Its release falls by
0.05 per frame, or 0.15 while braking. This progression exists with traction
control disabled. V4 injected the raw key as a processed pedal and skipped it.
The original pedal square and tick ramps remain downstream of that processing.

The placed-generic emitter policy previously rejected these stock setups. V5
mirrors its complete allocation/no-fold policy and widens twelve setup-dependent
constant-cell decisions. The original executable generates the reference
callbacks; the translated callback instructions are unchanged. No surface or tire
grip coefficient is increased to tune the result.

## Four-second original-code drives

The original reference loads the binary setup through `00558830`, validates it,
builds the car and uses the original throttle/clutch routines. The port uses the
same raw keyboard commands, 70 °F, no wind, aids disabled, a matching steering
momentum of zero, the same start location and 1,152 ticks per profile. Commands
include a shift, acceleration, lifting/braking and a short steering pulse.

| Check | fast | easy |
| --- | ---: | ---: |
| Pedal/clutch checkpoint mismatches | 0 | 0 |
| Gear checkpoint mismatches | 0 | 0 |
| Per-wheel material checkpoint mismatches | 0 | 0 |
| Max sampled chassis-position difference | 0.0230103 m | 0.0113525 m |
| Max sampled velocity-component difference | 0.0267174 m/s | 0.0247924 m/s |
| Max sampled yaw-rate difference | 0.005661 rad/s | 0.006503 rad/s |
| Instantaneous tire-force component RMS error | 360.927 N | 375.161 N |
| Max instantaneous tire-force component difference | 6,139.77 N | 7,673.48 N |

**The force differences remain material and are not marked as an equality pass.**
All 45-state differences are retained in the report; 5,592 fast and 4,681 easy
state fields differ at the sampled frames. Small chassis-position differences
are not proof that grip is identical. These short runs are not full-lap bounds.
The inherited core uses double intermediates in places where NR2003 uses x87
extended precision; the complete source of the remaining force differences has
not been isolated by this update. Earlier strict track comparisons also retain
their recorded failures in `../RUNTIME_VALIDATION.md`.

## Installation, HUD and presentation

* Fresh full installer: **60 checks passed** on the supplied original-source fixture.
* Actual shipped V4 installer followed by V5 updater: **24 checks passed**,
  including separate backup, idempotence, fresh imported copies, both rollback
  layers, unknown/unsaved client changes, injected write failures and overlapping
  source-write operations. The V4 backup remains intact.
* Actual adapter plus actual existing HUD callback: **15 checks passed**. The
  client consumes real native-contact telemetry. Airborne tires show SEM CONTATO
  and zero generated forces; the HUD does not change car state.
* Avatar/seat lifecycle regression: **15 checks passed**.
* Existing Stage 13 regression: **40 checks passed**.
* Actual presentation buffer: **8 checks passed**. At the retained 60 Hz/4 ms
  arrival-delay fixture, the active-driver view settles at 20.7 ms delay versus
  55.0 ms for the unchanged observer policy. This is a host presentation choice;
  real network/Studio timing varies. The simulation remains authoritative on the
  server. No rendered pose feeds the tire solver.

The HUD shows each native contact material, its loaded surface scalar, actual
Fx/Fy/Fz in the original tire frame and horizontal force/load usage. That usage
is not a maximum available friction coefficient. Existing pressure, temperature
and wheel-slip rows remain. The track row includes the applied setup, track
coordinates and accumulated simulation backlog in milliseconds.

Raw logs are in `validation/`. Generators and test runners are retained under
`../recovery/`, `tests/` and the repository `tools/` directory. Source packaging
checks verify the physical V5 model name, matching command, source fingerprints,
per-module size limits, ZIP CRCs and regular binary ZIP contents.
