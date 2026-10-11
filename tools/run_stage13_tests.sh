#!/bin/sh
# Stage 13 automatic tests (see tools/run_stage13_tests.ps1). Usage: LUAU=/path/luau PYTHON=python3 sh tools/run_stage13_tests.sh
# Rebuilds the FROZEN Stage 12 and Stage 12.1 deliverables (byte-identical to the published ones) and the Stage 13
# deliverables, runs the Stage 6/7 .. 12 suites (regression), the Stage 13 suite (original force feedback vs the ORIGINAL
# code), the adapter mock, the eight patch mocks (6/7 .. 12, 12 -> 12.1, 12.1 -> 13), then a syntax compile.
set -e
cd "$(dirname "$0")/.."
LUAU=${LUAU:-luau}
PYTHON=${PYTHON:-python3}
COMPILE=${COMPILE:-luau-compile}
$PYTHON tools/build_stage12.py
git diff --quiet -- PATCH_STAGE12.lua PATCH_STAGE12_INSTALL.lua PATCH_STAGE12_ROLLBACK.lua PATCH_STAGE12_PART1.lua PATCH_STAGE12_PART2.lua NR2003_Patch_Stage12.rbxmx \
    || { echo "the published Stage 12 deliverables changed"; exit 1; }
$PYTHON tools/build_stage12_1.py
git diff --quiet -- PATCH_STAGE12_1.lua PATCH_STAGE12_1_INSTALL.lua PATCH_STAGE12_1_ROLLBACK.lua PATCH_STAGE12_1_PART1.lua PATCH_STAGE12_1_PART2.lua NR2003_Patch_Stage12_1.rbxmx roblox/Stage12SelfTest.lua \
    || { echo "the published Stage 12.1 deliverables changed"; exit 1; }
$PYTHON tools/build_stage13.py
$PYTHON tools/make_patch12_mock.py
$PYTHON tools/make_patch12_1_mock.py
$PYTHON tools/make_patch13_mock.py
$PYTHON tools/make_adapter_mock.py
$LUAU -O2 --codegen tests/stage67/run.luau
$LUAU -O2 --codegen tests/stage8/run.luau
$LUAU -O2 --codegen tests/stage9/run.luau
$LUAU -O2 tests/stage10/run_setup.luau
$LUAU -O2 --codegen tests/stage10/run.luau
$LUAU -O2 --codegen tests/stage11/run.luau
$LUAU -O2 --codegen tests/stage12/run.luau
$LUAU -O2 --codegen tests/stage13/run.luau
$LUAU -O2 --codegen tests/stage67/adapter_mock.luau
$LUAU -O2 tests/stage67/patch_mock.luau
$LUAU -O2 tests/stage8/patch8_mock.luau
$LUAU -O2 tests/stage9/patch9_mock.luau
$LUAU -O2 tests/stage10/patch10_mock.luau
$LUAU -O2 --codegen tests/stage11/patch11_mock.luau
$LUAU -O2 --codegen tests/stage12/patch12_mock.luau
$LUAU -O2 --codegen tests/stage12/patch12_1_mock.luau
$LUAU -O2 --codegen tests/stage13/patch13_mock.luau
for f in core/*.lua core/NR2003Cup/*.lua roblox/*.lua PATCH_STAGE13*.lua; do $COMPILE --null "$f" > /dev/null; done
echo "syntax OK"
