# Jython: decompile functions of the current program whose (demangled or raw) symbol name contains one of the keys.
# @category NR2003.Recovery
# Args: outDir key...
import os
from ghidra.app.decompiler import DecompInterface
args = getScriptArgs()
out, keys = args[0], args[1:]
if not os.path.isdir(out): os.makedirs(out)
di = DecompInterface(); di.openProgram(currentProgram)
st = currentProgram.getSymbolTable()
rows = []
it = st.getAllSymbols(True)
seen = set()
while it.hasNext():
    s = it.next()
    n = s.getName(True)
    if not any(k in n for k in keys): continue
    f = getFunctionAt(s.getAddress())
    if f is None or f.getEntryPoint().getOffset() in seen: continue
    seen.add(f.getEntryPoint().getOffset())
    a = "%08x" % f.getEntryPoint().getOffset()
    rows.append(a + "\t" + n)
    r = di.decompileFunction(f, 120, monitor)
    fh = open(os.path.join(out, a + ".c"), "w")
    fh.write("/* %s @ %s %s */\n" % (currentProgram.getName(), a, n))
    if r.decompileCompleted(): fh.write(r.getDecompiledFunction().getC().encode('utf-8'))
    fh.close()
    asm = []
    ins = currentProgram.getListing().getInstructions(f.getBody(), True)
    while ins.hasNext():
        i = ins.next(); asm.append("%s %s" % (i.getAddress(), i))
    fh = open(os.path.join(out, a + ".asm"), "w"); fh.write("\n".join(asm) + "\n"); fh.close()
fh = open(os.path.join(out, "index.tsv"), "w"); fh.write("\n".join(rows) + "\n"); fh.close()
print("exported %d" % len(rows))
