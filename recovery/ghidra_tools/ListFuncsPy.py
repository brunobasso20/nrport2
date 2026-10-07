# Jython (Ghidra 11.1.2 on Java > 21 cannot load .java scripts).
# @category NR2003.Recovery
# Args: outFile start end  -- every function whose entry lies in [start, end): entry, name, size, callers.
args = getScriptArgs()
out, lo, hi = args[0], int(args[1], 16), int(args[2], 16)
rm = currentProgram.getReferenceManager()
rows = ["entry\tname\tsize\tcallers"]
it = currentProgram.getFunctionManager().getFunctions(toAddr(lo), True)
while it.hasNext():
    f = it.next()
    e = f.getEntryPoint().getOffset()
    if e >= hi:
        break
    callers = []
    for ref in rm.getReferencesTo(f.getEntryPoint()):
        cf = getFunctionContaining(ref.getFromAddress())
        callers.append("%s(%s,%s)" % (ref.getFromAddress(), "?" if cf is None else cf.getEntryPoint(), ref.getReferenceType()))
    rows.append("%08x\t%s\t%d\t%s" % (e, f.getName(), f.getBody().getNumAddresses(), " ".join(callers)))
fh = open(out, "w")
fh.write("\n".join(rows) + "\n")
fh.close()
print("functions %d" % (len(rows) - 1))
