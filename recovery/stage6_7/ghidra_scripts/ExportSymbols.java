// @category NR2003.Recovery
// Args: outDir regex depth  -- decompile functions at symbols matching regex (exports), + callees
import ghidra.app.script.GhidraScript;
import ghidra.app.decompiler.*;
import ghidra.program.model.listing.*;
import ghidra.program.model.symbol.*;
import java.nio.file.*;
import java.util.*;
public class ExportSymbols extends GhidraScript {
  public void run() throws Exception {
    String[] a=getScriptArgs(); Path out=Paths.get(a[0]); Files.createDirectories(out);
    java.util.regex.Pattern p=java.util.regex.Pattern.compile(a[1]); int depth=Integer.parseInt(a[2]);
    Set<Function> set=new LinkedHashSet<>(); StringBuilder sb=new StringBuilder();
    SymbolIterator it=currentProgram.getSymbolTable().getAllSymbols(true);
    while(it.hasNext()){ Symbol s=it.next(); if(!p.matcher(s.getName()).find()) continue;
      sb.append(s.getAddress()+"\t"+s.getName()+"\n");
      Function f=getFunctionAt(s.getAddress()); if(f==null){ disassemble(s.getAddress()); f=createFunction(s.getAddress(),null);} if(f!=null) set.add(f); }
    for(int d=0;d<depth;d++){ Set<Function> n=new LinkedHashSet<>(set); for(Function f:set) for(Function c:f.getCalledFunctions(monitor)) if(!c.isExternal()) n.add(c); set=n; }
    DecompInterface di=new DecompInterface(); di.openProgram(currentProgram);
    for(Function f:set){ DecompileResults r=di.decompileFunction(f,60,monitor);
      String n=f.getEntryPoint().toString()+"_"+f.getName().replaceAll("[^A-Za-z0-9_]","_");
      if(r.decompileCompleted()) Files.writeString(out.resolve(n+".c"),r.getDecompiledFunction().getC()); }
    Files.writeString(out.resolve("symbols.tsv"),sb.toString());
  }
}
