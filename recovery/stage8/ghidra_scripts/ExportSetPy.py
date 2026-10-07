# Jython port of ExportSet.java (Ghidra 11.1.2 OSGi cannot load .java scripts on Java > 21).
# @category NR2003.Recovery
# Args: outDir addrFile depth
# Decompiles listed functions (+ callees to depth), writes .c/.asm (with data-operand values) and
# index.tsv with callers / callees.
import os, struct
from ghidra.app.decompiler import DecompInterface
from java.lang import Float, Double

args = getScriptArgs()
out, addr_file, depth = args[0], args[1], int(args[2])
if not os.path.isdir(out):
    os.makedirs(out)
want = []
for line in open(addr_file).read().splitlines():
    line = line.strip()
    if not line or line.startswith('#'):
        continue
    want.append(int(line.split()[0], 16))
sel = set()
for x in want:
    a = toAddr(x)
    f = getFunctionAt(a)
    if f is None:
        f = getFunctionContaining(a)   # an instruction address inside a function -> its entry
    if f is None:
        disassemble(a)
        f = createFunction(a, "recovered_%08x" % x)
    sel.add(f.getEntryPoint().getOffset() if f is not None else x)
for d in range(depth):
    nxt = set(sel)
    for x in sel:
        f = getFunctionAt(toAddr(x))
        if f is None:
            continue
        for c in f.getCalledFunctions(monitor):
            if not c.isExternal() and not c.isThunk():
                nxt.add(c.getEntryPoint().getOffset())
    sel = nxt
di = DecompInterface()
di.openProgram(currentProgram)
rm = currentProgram.getReferenceManager()
idx = ["address\tname\tsize\tcallers\tcallees"]
for x in sorted(sel):
    f = getFunctionAt(toAddr(x))
    n = "%08x" % x
    if f is None:
        idx.append(n + "\tMISSING")
        continue
    cp = os.path.join(out, n + ".c")
    if not os.path.exists(cp):
        r = di.decompileFunction(f, 120, monitor)
        if r.decompileCompleted():
            fh = open(cp, "w")
            fh.write("/* NR2003.exe @ %s %s */\n" % (n, f.getName()))
            fh.write(r.getDecompiledFunction().getC().encode('utf-8'))
            fh.close()
        asm = []
        it = currentProgram.getListing().getInstructions(f.getBody(), True)
        while it.hasNext():
            i = it.next()
            s = "%s %s" % (i.getAddress(), i)
            for ref in i.getReferencesFrom():
                if ref.getReferenceType().isData():
                    t = ref.getToAddress()
                    try:
                        v = getInt(t)
                        s += "   ; [%s] f32=%s i32=%d" % (t, Float.intBitsToFloat(v), v)
                        s += " f64=%s" % Double.longBitsToDouble(getLong(t))
                    except:
                        pass
            asm.append(s)
        fh = open(os.path.join(out, n + ".asm"), "w")
        fh.write("\n".join(asm) + "\n")
        fh.close()
    callers = []
    for ref in rm.getReferencesTo(f.getEntryPoint()):
        cf = getFunctionContaining(ref.getFromAddress())
        callers.append("%s(%s,%s)" % (ref.getFromAddress(), "?" if cf is None else cf.getEntryPoint(), ref.getReferenceType()))
    callees = [str(c.getEntryPoint()) for c in f.getCalledFunctions(monitor)]
    idx.append("%s\t%s\t%d\t%s\t%s" % (n, f.getName(), f.getBody().getNumAddresses(), " ".join(callers), " ".join(callees)))
fh = open(os.path.join(out, "index.tsv"), "w")
fh.write("\n".join(idx) + "\n")
fh.close()
di.dispose()
print("exported %d" % len(sel))
