#!/bin/bash
# usage: run.sh Script.java args...
S=$1; shift
/home/claude/tools/ghidra_11.1.2_PUBLIC/support/analyzeHeadless /home/claude/gproj OpenNR2003 -process NR2003.exe -readOnly -noanalysis -scriptPath /home/claude/gscripts -postScript $S "$@" > /home/claude/gout/last.log 2>&1
grep -E "ERROR|Exception" /home/claude/gout/last.log | head -5
