// Export original imported file bytes for version identification, without changing the program.
// @category NR2003.Recovery
import ghidra.app.script.GhidraScript;
import ghidra.program.database.mem.FileBytes;
import java.io.File;
import java.io.FileOutputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import ghidra.program.model.mem.MemoryBlock;

public class ExportPatchBaseline extends GhidraScript {
    public void run() throws Exception {
        File out = new File(getScriptArgs()[0]);
        if (!out.mkdirs() && !out.isDirectory()) throw new java.io.IOException("Output directory");
        println("program=" + currentProgram.getName());
        println("executableSHA256=" + currentProgram.getExecutableSHA256());
        int index = 0;
        for (FileBytes source : currentProgram.getMemory().getAllFileBytes()) {
            File target = new File(out, "imported-" + index++ + ".bin");
            try (FileOutputStream stream = new FileOutputStream(target)) {
                byte[] bytes = new byte[1024 * 1024];
                long offset = 0;
                while (offset < source.getSize()) {
                    int count = (int)Math.min(bytes.length, source.getSize() - offset);
                    source.getOriginalBytes(offset, bytes, 0, count);
                    stream.write(bytes, 0, count);
                    offset += count;
                }
            }
            println("file=" + source.getFilename() + " size=" + source.getSize() + " output=" + target);
        }
        if (getScriptArgs().length > 1) {
            File memory = new File(getScriptArgs()[1]);
            if (!memory.mkdirs() && !memory.isDirectory()) throw new java.io.IOException("Memory directory");
            StringBuilder blocks = new StringBuilder("name\tstart\tsize\tinitialized\n");
            for (MemoryBlock block : currentProgram.getMemory().getBlocks()) {
                long start = block.getStart().getOffset(), size = block.getSize();
                blocks.append(block.getName()).append('\t').append(Long.toHexString(start)).append('\t')
                    .append(size).append('\t').append(block.isInitialized()).append('\n');
                if (size > 0x4000000) continue;
                byte[] bytes = new byte[(int)size];
                if (block.isInitialized()) block.getBytes(block.getStart(), bytes);
                Files.write(new File(memory, String.format("%08x.bin", start)).toPath(), bytes);
            }
            Files.write(new File(memory, "blocks.tsv").toPath(), blocks.toString().getBytes(StandardCharsets.UTF_8));
        }
    }
}
