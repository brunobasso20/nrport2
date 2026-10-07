// @category OpenNR2003
import ghidra.app.script.GhidraScript;
import ghidra.app.decompiler.*;
import ghidra.program.model.listing.*;
import ghidra.program.model.address.*;
import java.io.*;
import java.util.*;

public class ExportSelected extends GhidraScript {
    public void run() throws Exception {
        String[] args=getScriptArgs(); File out=new File(args[0]);out.mkdirs();
        DecompInterface di=new DecompInterface(); di.openProgram(currentProgram);
        Set<Function> fs=new TreeSet<>(Comparator.comparing(f->f.getEntryPoint().toString()));
        try(BufferedReader br=new BufferedReader(new FileReader(args[1]))) {
            String s;while((s=br.readLine())!=null) {
                if(s.trim().isEmpty())continue;
                Function f=getFunctionAt(toAddr(s.trim()));if(f!=null)fs.add(f);
            }
        }
        try(PrintWriter p=new PrintWriter(new File(out,"decompile_status.tsv"))) {
            p.println("address\tname\tstatus\terror");
            for(Function f:fs) {
                monitor.checkCancelled(); DecompileResults r=di.decompileFunction(f,30,monitor);
                String addr=f.getEntryPoint().toString();
                p.println(addr+"\t"+f.getName()+"\t"+r.decompileCompleted()+"\t"+r.getErrorMessage());p.flush();
                if(r.decompileCompleted())try(PrintWriter c=new PrintWriter(new File(out,addr+".c"))) {
                    c.println("/* Ghidra pseudo-C; not original source. Program: "+currentProgram.getName()+"; address: "+addr+" */");
                    c.println(r.getDecompiledFunction().getC());
                }
            }
        } finally {di.dispose();}
    }
}
