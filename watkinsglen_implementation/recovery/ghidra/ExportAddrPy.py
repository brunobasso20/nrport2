# Jython: decompile + asm of functions at the given addresses (current program; creates functions if needed)
# @category NR2003.Recovery
# Args: outDir addr...
import os
from ghidra.app.decompiler import DecompInterface
args = getScriptArgs()
out = args[0]
if not os.path.isdir(out): os.makedirs(out)
di = DecompInterface(); di.openProgram(currentProgram)
for a in args[1:]:
    x = toAddr(int(a, 16))
    f = getFunctionAt(x) or getFunctionContaining(x)
    if f is None:
        disassemble(x); f = createFunction(x, "recovered_%s" % a)
    n = "%08x" % f.getEntryPoint().getOffset()
    r = di.decompileFunction(f, 120, monitor)
    fh = open(os.path.join(out, n + ".c"), "w")
    fh.write("/* %s @ %s %s */\n" % (currentProgram.getName(), n, f.getName()))
    if r.decompileCompleted(): fh.write(r.getDecompiledFunction().getC().encode('utf-8'))
    fh.close()
    asm = []
    it = currentProgram.getListing().getInstructions(f.getBody(), True)
    while it.hasNext():
        i = it.next(); asm.append("%s %s" % (i.getAddress(), i))
    fh = open(os.path.join(out, n + ".asm"), "w"); fh.write("\n".join(asm) + "\n"); fh.close()
print("done")
