// @category NR2003.Recovery
// Run on the supplied OpenNR2003 Ghidra project with -readOnly -noanalysis.
import ghidra.app.script.GhidraScript;
import ghidra.app.decompiler.*;
import ghidra.program.model.address.*;
import ghidra.program.model.listing.*;
import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.util.*;
public class ExportVehicleCore extends GhidraScript {
    public void run() throws Exception {
        Path out=Paths.get(getScriptArgs()[0]); Files.createDirectories(out);
        long[] extra={0x005b31e0L,0x005b3850L,0x0055e160L,0x0055e180L,0x00561040L,
            0x005614b0L,0x00561a80L,0x00561b70L,0x00561e50L,0x0055e3e0L,
            0x005543f0L,0x005b2c10L,0x0057d2f0L,0x0057d3b0L,0x0057d3d0L,
            0x0057d3f0L,0x0057d430L,0x0057d450L,0x0057d470L,0x0057d490L,
            0x0057d4b0L,0x0057d4e0L,0x00551480L,0x00551710L,0x005b2190L,
            0x005544d0L,0x005544e0L,0x00554510L,0x00551760L,0x00560720L,
            0x00560780L,0x00560790L,0x005607a0L,0x005607b0L,0x005607c0L,
            0x005607d0L,0x005607e0L,0x00560870L,0x005b87c0L};
        Set<Long> selected=new TreeSet<>();
        for(long a:extra) selected.add(a);
        FunctionIterator it=currentProgram.getFunctionManager().getFunctions(true);
        while(it.hasNext()) {
            long a=it.next().getEntryPoint().getOffset();
            if((a>=0x005b2980L&&a<0x005ba160L)||(a>=0x0055e000L&&a<0x00562200L)||
                (a>=0x0057c800L&&a<0x0057de00L)) selected.add(a);
        }
        DecompInterface decompiler=new DecompInterface(); decompiler.openProgram(currentProgram);
        StringBuilder index=new StringBuilder("address\tname\tdecompiled\n");
        for(long a:selected) {
            Address address=toAddr(a); Function fn=getFunctionAt(address);
            if(fn==null) {disassemble(address); fn=createFunction(address,"recovered_"+String.format("%08x",a));}
            if(fn==null) {index.append(String.format("%08x\tMISSING\tfalse\n",a));continue;}
            String name=String.format("%08x",a);
            DecompileResults result=decompiler.decompileFunction(fn,90,monitor);
            boolean ok=result.decompileCompleted();
            if(!ok) println(name+" decompile failed: "+result.getErrorMessage());
            index.append(name+"\t"+fn.getName()+"\t"+ok+"\n");
            if(ok) Files.writeString(out.resolve(name+".c"),"/* Ghidra pseudo-C; NR2003.exe @ "+name+" */\n"+result.getDecompiledFunction().getC(),StandardCharsets.UTF_8);
            StringBuilder asm=new StringBuilder();
            InstructionIterator instructions=currentProgram.getListing().getInstructions(fn.getBody(),true);
            while(instructions.hasNext()) {Instruction i=instructions.next();asm.append(i.getAddress()+" "+i+"\n");}
            Files.writeString(out.resolve(name+".asm"),asm.toString(),StandardCharsets.UTF_8);
        }
        Files.writeString(out.resolve("functions.tsv"),index.toString());
        long[][] regions={{0x400000L,0x2c0000L},{0x6e9000L,0x32000L},{0x71b000L,0x45000L}};
        for(long[] r:regions) {byte[] bytes=new byte[(int)r[1]]; currentProgram.getMemory().getBytes(toAddr(r[0]),bytes);
            Files.write(out.resolve(String.format("%08x.bin",r[0])),bytes);}
        decompiler.dispose(); println("Vehicle core exports: "+selected.size());
    }
}
