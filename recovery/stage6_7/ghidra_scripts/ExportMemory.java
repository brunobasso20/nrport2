// @category NR2003.Recovery
// Args: outDir -- dumps every memory block (initialized bytes, uninitialized as zero) + blocks.tsv
import ghidra.app.script.GhidraScript;
import ghidra.program.model.mem.*;
import java.nio.file.*;
public class ExportMemory extends GhidraScript {
    public void run() throws Exception {
        Path out=Paths.get(getScriptArgs()[0]); Files.createDirectories(out);
        StringBuilder sb=new StringBuilder("name\tstart\tsize\tinitialized\n");
        for(MemoryBlock b:currentProgram.getMemory().getBlocks()){
            long st=b.getStart().getOffset(); long sz=b.getSize();
            sb.append(b.getName()+"\t"+Long.toHexString(st)+"\t"+sz+"\t"+b.isInitialized()+"\n");
            if(sz>0x4000000) continue;
            byte[] bytes=new byte[(int)sz];
            if(b.isInitialized()) b.getBytes(b.getStart(),bytes);
            Files.write(out.resolve(String.format("%08x.bin",st)),bytes);
        }
        Files.writeString(out.resolve("blocks.tsv"),sb.toString());
    }
}
