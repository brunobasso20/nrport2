# Jython port of XrefData.java (Ghidra 11.1.2 OSGi cannot load .java scripts on Java > 21).
# @category NR2003.Recovery
# Args: outFile addrFile   -- for each address range "start [len]", list referencing instructions/functions.
args = getScriptArgs()
rm = currentProgram.getReferenceManager()
rows = []
for line in open(args[1]).read().splitlines():
    line = line.strip()
    if not line or line.startswith('#'):
        continue
    parts = line.split()
    start = int(parts[0], 16)
    ln = int(parts[1]) if len(parts) > 1 else 1
    for x in range(start, start + ln):
        t = toAddr(x)
        for ref in rm.getReferencesTo(t):
            f = getFunctionContaining(ref.getFromAddress())
            rows.append("%08x\t%s\t%s\t%s" % (x, ref.getFromAddress(), "?" if f is None else "%s:%s" % (f.getEntryPoint(), f.getName()), ref.getReferenceType()))
fh = open(args[0], "w")
fh.write("\n".join(rows) + "\n")
fh.close()
print("xrefs %d" % len(rows))
