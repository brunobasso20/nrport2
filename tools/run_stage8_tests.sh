#!/bin/sh
# Stage 8 automatic tests (Luau CLI with native codegen). Usage: sh tools/run_stage8_tests.sh [path/to/luau] [python]
# (Windows: tools/run_stage8_tests.ps1)
LUAU=${1:-luau}
PY=${2:-python3}
LUAUC="$(dirname "$LUAU")/luau-compile"
[ -x "$LUAUC" ] || LUAUC=luau-compile
cd "$(dirname "$0")/.." || exit 1
"$PY" tools/build_stage8.py || exit 1
"$PY" tools/make_adapter_mock.py >/dev/null || exit 1
"$PY" tools/make_patch8_mock.py >/dev/null || exit 1
"$LUAU" -O2 --codegen tests/stage67/run.luau || exit 1
"$LUAU" -O2 --codegen tests/stage8/run.luau || exit 1
"$LUAU" -O2 --codegen tests/stage67/adapter_mock.luau || exit 1
"$LUAU" -O2 tests/stage67/patch_mock.luau || exit 1
"$LUAU" -O2 tests/stage8/patch8_mock.luau || exit 1
for f in core/*.lua core/NR2003Cup/*.lua roblox/*.lua PATCH_STAGE8.lua; do
  "$LUAUC" --null "$f" >/dev/null || { echo "SYNTAX FAIL $f"; exit 1; }
done
echo "syntax OK"
