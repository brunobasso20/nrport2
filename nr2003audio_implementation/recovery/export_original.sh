#!/bin/sh
# Read-only export from the user's local OpenNR2003 Ghidra checkout.
# GHIDRA=/path/ghidra PROJECT=/path/OpenNR2003 OUT=/private/memory sh export_original.sh
set -eu
: "${GHIDRA:?Set GHIDRA to Ghidra 11.1.2}"
: "${PROJECT:?Set PROJECT to the folder containing OpenNR2003.gpr}"
: "${OUT:?Set OUT to a private memory dump destination}"
TASK_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
export JAVA_TOOL_OPTIONS=-Duser.name=TChapman500
exec "$GHIDRA/support/analyzeHeadless" "$PROJECT" OpenNR2003 -process NR2003.exe \
    -readOnly -noanalysis -scriptPath "$TASK_ROOT/recovery/ghidra_tools" \
    -postScript ExportMemoryPy.py "$OUT"
