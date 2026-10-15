#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
LUAU=${LUAU:-luau}
PYTHON=${PYTHON:-python3}
studio_args=()
if [[ -n "${NR2003_STUDIO_EXPORT:-}" ]]; then studio_args=(--studio-dir "$NR2003_STUDIO_EXPORT"); fi
"$PYTHON" tools/build_assists.py "${studio_args[@]}"
"$PYTHON" tests/assists/build_installer_test.py "${studio_args[@]}"
for suite in automatic pedals stability integration road generated_installer_test; do
    "$LUAU" -O2 --codegen "tests/assists/$suite.luau"
done
"$PYTHON" tools/make_adapter_mock.py --track
"$LUAU" -O2 --codegen watkinsglen_implementation/tests/adapter_track.luau
"$LUAU" -O2 --codegen tests/patch1201/run_controls.luau
