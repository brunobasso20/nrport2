#!/bin/sh
# Ghidra headless runner for the NR2003 project (read-only, no analysis) with the Jython scripts of this folder.
#   GHIDRA=/opt/ghidra_11.1.2_PUBLIC PROJECT=/data/nrproj sh recovery/ghidra_tools/run_headless.sh \
#       -postScript ExportMemoryPy.py /data/mem -postScript ExportSetPy.py /data/evidence funcs.txt 1
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
: "${GHIDRA:?set GHIDRA to the Ghidra install folder}"
: "${PROJECT:?set PROJECT to the folder holding OpenNR2003.gpr}"
export JAVA_TOOL_OPTIONS="-Duser.name=TChapman500"   # project owner
exec "$GHIDRA/support/analyzeHeadless" "$PROJECT" OpenNR2003 -process NR2003.exe -readOnly -noanalysis -scriptPath "$HERE" "$@"
