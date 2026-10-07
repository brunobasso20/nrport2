# Jython port of ExportMemory.java (Ghidra 11.1.2 OSGi cannot load .java scripts on Java > 21).
# @category NR2003.Recovery
# Args: outDir -- dumps every memory block (initialized bytes, uninitialized as zero) + blocks.tsv
import os
import jarray
from java.io import FileOutputStream

out = getScriptArgs()[0]
if not os.path.isdir(out):
    os.makedirs(out)
lines = ["name\tstart\tsize\tinitialized"]
for b in currentProgram.getMemory().getBlocks():
    st = b.getStart().getOffset()
    sz = b.getSize()
    lines.append("%s\t%x\t%d\t%s" % (b.getName(), st, sz, "true" if b.isInitialized() else "false"))
    if sz > 0x4000000:
        continue
    arr = jarray.zeros(sz, 'b')
    if b.isInitialized():
        b.getBytes(b.getStart(), arr)
    fos = FileOutputStream(os.path.join(out, "%08x.bin" % st))
    fos.write(arr)
    fos.close()
f = open(os.path.join(out, "blocks.tsv"), "w")
f.write("\n".join(lines) + "\n")
f.close()
print("blocks: %d" % (len(lines) - 1))
