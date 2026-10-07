// @category NR2003.Recovery
// Args: outDir addrFile depth
// Decompiles listed functions (+ callees to depth), writes .c/.asm and xrefs (callers, data refs).
import ghidra.app.script.GhidraScript;
import ghidra.app.decompiler.*;
import ghidra.program.model.address.*;
import ghidra.program.model.listing.*;
import ghidra.program.model.symbol.*;
import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.util.*;
public class ExportSet extends GhidraScript {
    public void run() throws Exception {
        String[] a=getScriptArgs();
        Path out=Paths.get(a[0]); Files.createDirectories(out);
        int depth=Integer.parseInt(a[2]);
        Set<Long> set=new TreeSet<>();
        for(String line:Files.readAllLines(Paths.get(a[1]))){line=line.trim(); if(line.isEmpty()||line.startsWith("#"))continue; set.add(Long.parseLong(line.split("\\s+")[0],16));}
        for(long x:set){ if(getFunctionAt(toAddr(x))==null){ disassemble(toAddr(x)); createFunction(toAddr(x),String.format("recovered_%08x",x)); } }
        for(int d=0;d<depth;d++){
            Set<Long> next=new TreeSet<>(set);
            for(long x:set){Function f=getFunctionAt(toAddr(x)); if(f==null)continue;
                for(Function c:f.getCalledFunctions(monitor)) if(!c.isExternal()&&!c.isThunk()) next.add(c.getEntryPoint().getOffset());}
            set=next;
        }
        DecompInterface di=new DecompInterface(); di.openProgram(currentProgram);
        StringBuilder idx=new StringBuilder("address\tname\tsize\tcallers\tcallees\n");
        ReferenceManager rm=currentProgram.getReferenceManager();
        for(long x:set){
            Function f=getFunctionAt(toAddr(x)); String n=String.format("%08x",x);
            if(f==null){idx.append(n+"\tMISSING\n");continue;}
            Path cp=out.resolve(n+".c");
            if(!Files.exists(cp)){
                DecompileResults r=di.decompileFunction(f,120,monitor);
                if(r.decompileCompleted()) Files.writeString(cp,"/* NR2003.exe @ "+n+" "+f.getName()+" */\n"+r.getDecompiledFunction().getC(),StandardCharsets.UTF_8);
                StringBuilder asm=new StringBuilder();
                for(Instruction i:currentProgram.getListing().getInstructions(f.getBody(),true)){
                    asm.append(i.getAddress()).append(" ").append(i);
                    for(Reference ref:i.getReferencesFrom()){ if(ref.getReferenceType().isData()){ Address t=ref.getToAddress();
                        try{ asm.append(String.format("   ; [%s] f32=%s i32=%d",t,Float.intBitsToFloat(getInt(t)),getInt(t))); if(true){ long bits=getLong(t); asm.append(" f64="+Double.longBitsToDouble(bits)); } }catch(Exception e){} } }
                    asm.append("\n");
                }
                Files.writeString(out.resolve(n+".asm"),asm.toString(),StandardCharsets.UTF_8);
            }
            StringBuilder callers=new StringBuilder();
            for(Reference ref:rm.getReferencesTo(f.getEntryPoint())){ Function cf=getFunctionContaining(ref.getFromAddress());
                callers.append(ref.getFromAddress()).append("(").append(cf==null?"?":cf.getEntryPoint().toString()).append(",").append(ref.getReferenceType()).append(") "); }
            StringBuilder callees=new StringBuilder();
            for(Function c:f.getCalledFunctions(monitor)) callees.append(c.getEntryPoint()).append(" ");
            idx.append(n+"\t"+f.getName()+"\t"+f.getBody().getNumAddresses()+"\t"+callers+"\t"+callees+"\n");
        }
        Files.writeString(out.resolve("index.tsv"),idx.toString());
        di.dispose();
        println("exported "+set.size());
    }
}
