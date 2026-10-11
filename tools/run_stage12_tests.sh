#!/bin/sh
# Stage 12 automatic tests (see tools/run_stage12_tests.ps1). Usage: LUAU=/path/luau PYTHON=python3 sh tools/run_stage12_tests.sh
# Builds the Stage 12 deliverables, runs the Stage 6/7 .. 11 suites (regression: steering mode "provisional" = the
# Stage 6-11 steering contract), the Stage 12 suite (original steering chain vs the ORIGINAL code), the adapter mock,
# the six patch mocks, then a syntax compile.
set -e
cd "$(dirname "$0")/.."
LUAU=${LUAU:-luau}
PYTHON=${PYTHON:-python3}
COMPILE=${COMPILE:-luau-compile}
$PYTHON tools/build_stage12.py
$PYTHON tools/make_patch12_mock.py
$PYTHON tools/make_adapter_mock.py
$LUAU -O2 --codegen tests/stage67/run.luau
$LUAU -O2 --codegen tests/stage8/run.luau
$LUAU -O2 --codegen tests/stage9/run.luau
$LUAU -O2 tests/stage10/run_setup.luau
$LUAU -O2 --codegen tests/stage10/run.luau
$LUAU -O2 --codegen tests/stage11/run.luau
$LUAU -O2 --codegen tests/stage12/run.luau
$LUAU -O2 --codegen tests/stage67/adapter_mock.luau
$LUAU -O2 tests/stage67/patch_mock.luau
$LUAU -O2 tests/stage8/patch8_mock.luau
$LUAU -O2 tests/stage9/patch9_mock.luau
$LUAU -O2 tests/stage10/patch10_mock.luau
$LUAU -O2 --codegen tests/stage11/patch11_mock.luau
$LUAU -O2 --codegen tests/stage12/patch12_mock.luau
for f in core/*.lua core/NR2003Cup/*.lua roblox/*.lua PATCH_STAGE12*.lua; do $COMPILE --null "$f" > /dev/null; done
echo "syntax OK"
