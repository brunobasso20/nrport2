#!/bin/sh
# Stage 9 automatic tests (POSIX shell). LUAU=path/to/luau PYTHON=python3 sh tools/run_stage9_tests.sh
set -e
cd "$(dirname "$0")/.."
LUAU=${LUAU:-luau}; PYTHON=${PYTHON:-python3}
COMPILE=${LUAU_COMPILE:-$(dirname "$LUAU")/luau-compile}
$PYTHON tools/build_stage9.py
$PYTHON tools/make_adapter_mock.py
$PYTHON tools/make_patch9_mock.py
$LUAU -O2 --codegen tests/stage67/run.luau
$LUAU -O2 --codegen tests/stage8/run.luau
$LUAU -O2 --codegen tests/stage9/run.luau
$LUAU -O2 --codegen tests/stage67/adapter_mock.luau
$LUAU -O2 tests/stage67/patch_mock.luau
$LUAU -O2 tests/stage8/patch8_mock.luau
$LUAU -O2 tests/stage9/patch9_mock.luau
for f in core/*.lua core/NR2003Cup/*.lua roblox/*.lua PATCH_STAGE9.lua; do "$COMPILE" --null "$f" >/dev/null; done
echo "syntax OK"
