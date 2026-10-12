# @category NR2003.Recovery
# Args: outFile  -- external entry points + named symbols of the current program
args = getScriptArgs()
st = currentProgram.getSymbolTable()
rows = []
for s in st.getAllSymbols(True):
    if s.isExternalEntryPoint() or (s.getSource().toString() in ("IMPORTED", "USER_DEFINED") and s.getSymbolType().toString() == "Function"):
        rows.append("%s\t%s\t%s" % (s.getAddress(), s.getName(), s.getSource()))
fh = open(args[0], "w"); fh.write("\n".join(rows) + "\n"); fh.close()
print("symbols %d" % len(rows))
