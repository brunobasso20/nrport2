#!/bin/sh
# Stage 6/7 automatic tests (Luau CLI with native codegen). Usage: sh tools/run_stage67_tests.sh [path/to/luau]
LUAU=${1:-luau}
cd "$(dirname "$0")/.." || exit 1
python3 tools/make_adapter_mock.py >/dev/null || exit 1
python3 tools/make_patch_mock.py >/dev/null || exit 1
"$LUAU" -O2 --codegen tests/stage67/run.luau || exit 1
"$LUAU" -O2 --codegen tests/stage67/adapter_mock.luau || exit 1
"$LUAU" -O2 tests/stage67/patch_mock.luau || exit 1
for f in core/*.lua core/NR2003Cup/*.lua roblox/*.lua PATCH_STAGE6_7.lua; do
  luau-compile --null "$f" >/dev/null || { echo "SYNTAX FAIL $f"; exit 1; }
done
echo "syntax OK"
