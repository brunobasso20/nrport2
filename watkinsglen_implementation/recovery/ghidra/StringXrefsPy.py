# Jython (Ghidra 11.1.2 headless, read-only): every defined string containing one of the keys + its referencing functions.
# @category NR2003.Recovery
# Args: outFile key...
args = getScriptArgs()
out, keys = args[0], [k.lower() for k in args[1:]]
lst = currentProgram.getListing()
rm = currentProgram.getReferenceManager()
rows = []
it = lst.getDefinedData(True)
while it.hasNext():
    d = it.next()
    try:
        v = d.getValue()
    except:
        continue
    if not isinstance(v, unicode) and not isinstance(v, str):
        continue
    s = v.lower()
    if not any(k in s for k in keys):
        continue
    refs = []
    for r in rm.getReferencesTo(d.getAddress()):
        f = getFunctionContaining(r.getFromAddress())
        refs.append("%s@%s" % (f.getEntryPoint() if f else "-", r.getFromAddress()))
    rows.append("%s\t%r\t%s" % (d.getAddress(), v.encode('utf-8'), " ".join(refs)))
fh = open(out, "w"); fh.write("\n".join(rows) + "\n"); fh.close()
print("strings: %d" % len(rows))
