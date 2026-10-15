# Original 1.2.0.1 camber reference

`gen_camber_reference.py` executes the original x86 build, generated predictor, and tyre paths in Unicorn. It writes JSON and Luau fixtures under `tests/patch1201/`. The source is the verified **1.2.0.1** executable imported by OpenNR2003, SHA256 `27e76919be6722bee0dcaddc92454fea338e99a97404df6220448314feb4500a`. The generator checks all three committed vehicle-core memory hashes before running. This is a parity regression against the patched version; it does not claim a measured 1.0-to-1.2 delta.

From the repository root, using the existing Stage 6/7 Unicorn Python environment:

```sh
NR2003_MEM=/path/to/exported/memory \
UNICORN_PY=/path/to/python/packages \
CAPSTONE_PY=/path/to/python/packages \
PYTHONPATH=/path/to/python/packages \
python recovery/patch1201/gen_camber_reference.py
luau -O2 --codegen tests/patch1201/run.luau
```

The memory directory is produced by `recovery/ghidra_tools/ExportMemoryPy.py`; the existing harness in `recovery/stage6_7/nrx.py` reads its `blocks.tsv` and memory blocks. The new generator does not launch the game or depend on generated Luau to produce expected values.

The two garage builds use the original setter `005581d0` for LF ride heights 5.0 and 5.5 inches, followed by the original Stage 10 application sequence. Garage conversion uses FPU control word `0x037f`; build/simulation uses `0x077f`. Each build is probed at five signed front suspension coordinates (−0.02, 0, 0.05, 0.10, 0.13 m), three prescribed steering angles (−0.2, 0, 0.2 rad), and three chassis roll angles (−0.05, 0, 0.05 rad): 90 poses in total. LF and RF use the same controlled travel and steering coordinate. These coordinates are imposed kinematic states with zero motion, not a suspension settling simulation or a complete driving scenario. Steering angles bypass device shaping so geometry is isolated.

For every pose, `005b4560` imports the state, `005b2b90` evaluates predictor/solve, and `0055e1e0` evaluates the original tyre path. `0054cab0` stores its actual parameter 11 directly in each tyre object's `+0x2bc` field. The fixture captures that value, plus the world Z component of the local wheel Y axis from the wheel record's exported matrix (`+0x339`, LF record 5 / RF record 8). The camber argument is the wheel-axis/ground-normal scalar consumed by the force model; the test compares that scalar directly and does not substitute an angle derived from a rendered wheel.

The Luau suite compares all 360 output scalars with an absolute tolerance of `2e-6`, rejects nonfinite results, and checks the following quantitative responses at zero steering/roll:

- Adding 0.10 m travel changes LF/RF tyre camber input by approximately `+0.03087015 / −0.03087016`; render axes change by zero.
- Adding 0.2 rad steering changes LF/RF tyre camber input by approximately `−0.01172229 / −0.00541911`.
- Adding 0.05 rad chassis roll changes LF/RF tyre camber input by approximately `+0.04994151 / +0.04999364`.

These results distinguish the tyre path's camber gain from the prismatic multibody's rendered orientation. At fixed imposed travel the two garage heights give identical camber scalars here; this is expected because ride height is not allowed to settle and change travel in this probe. A test-only mutation disables the front camber-gain constants in the reset image and must produce an error above `0.01` on both front tyre inputs. The original constants are restored afterward. Production code and shipped runtime images are unchanged.
