# Jython port of ScanOperand.java (Ghidra 11.1.2 OSGi cannot load .java scripts on Java > 21).
# @category NR2003.Recovery
# Args: outFile key...  -- every instruction whose listing text contains one of the keys
#       (case-insensitive substring, e.g. "+ 0x59e]" for a displacement or "0xe0b84c" for an address).
args = getScriptArgs()
keys = [k.lower() for k in args[1:]]
rows = []
it = currentProgram.getListing().getInstructions(True)
while it.hasNext():
    ins = it.next()
    t = str(ins).lower()
    for k in keys:
        if k in t:
            f = getFunctionContaining(ins.getAddress())
            rows.append("%s\t%s\t%s\t%s" % (k, ins.getAddress(), "?" if f is None else f.getEntryPoint(), ins))
            break
fh = open(args[0], "w")
fh.write("\n".join(rows) + "\n")
fh.close()
print("operand hits %d" % len(rows))
