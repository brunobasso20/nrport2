# Official Watkins Glen setup correction

The uploaded official 1.2.0.1 patch contains complete `fast.cup.sim` and `qualify.cup.sim` files in verified Wise streams 116 and 119. Their raw setup fields differ from the files previously used by this port. The physics executable was already 1.2.0.1; this change replaces those two setup profiles without changing tyre equations or applying a grip multiplier. `easy` and `jasper` retain their original source hashes and settings.

`gen_patch_setups.py` verifies the supplied ZIP hash and the complete payload SHA256 values, calls the existing `tools/build_watkinsglen_setups.py` decoder for the module's 68 stored fields, and independently executes the original x86 `00558830` setup decoder and `00558da0` loaded-file validator to obtain 70 expected input fields. Original float values between garage UI steps are retained. Fixtures record the source hashes, original DGTS bytes, raw fields, and original validated results. No old driving trajectory was changed to fit the new setup.

Reproduce after extracting the uploaded patch with the existing verified Wise extractor:

```sh
NR2003_MEM=/path/to/exported/memory \
UNICORN_PY=/path/to/python/packages \
CAPSTONE_PY=/path/to/python/packages \
PYTHONPATH=/path/to/python/packages \
python recovery/patch1201/gen_patch_setups.py \
  --streams /path/to/verified/payloads \
  --archive '/path/to/nr2003_update_en_1000_1201 patch.zip'
luau -O2 --codegen tests/patch1201/run_setups.luau
luau -O2 --codegen watkinsglen_implementation/handling/tests/run_setups.luau
```

The focused suite checks the exact patch bytes, independently decoded load results, source identities, preserved easy/jasper profiles, default and invalid selections, and both updated profiles through the actual road-course generic build and placement, including tyre pressures, finite state, and native track contacts.

The older `handling/tests/driving_fixtures.lua` fast trajectory was captured with the prior fast setup and is not a reference for the corrected profile. Regenerating a long-horizon comparison requires the original Watkins Glen/shared assets and server/RTS memory exports, plus the patched fast file, using `watkinsglen_implementation/recovery/gen_handling_drives.py`. The retained old fixture remains useful evidence of its original setup and is not silently rewritten.

The road-course driving regression now explicitly supplies `recorded_fast_setup.lua` when replaying the old FAST
fixtures, preserving their original inputs. Updated presets are checked separately; no tolerance was relaxed.
