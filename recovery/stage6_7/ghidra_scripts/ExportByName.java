// @category NR2003.Recovery
// Args: outDir regex depth
import ghidra.app.script.GhidraScript;
import ghidra.app.decompiler.*;
import ghidra.program.model.listing.*;
import java.nio.file.*;
import java.util.*;
public class ExportByName extends GhidraScript {
  public void run() throws Exception {
    String[] a=getScriptArgs(); Path out=Paths.get(a[0]); Files.createDirectories(out);
    java.util.regex.Pattern p=java.util.regex.Pattern.compile(a[1]); int depth=Integer.parseInt(a[2]);
    Set<Function> set=new LinkedHashSet<>();
    for(Function f:currentProgram.getFunctionManager().getFunctions(true)) if(p.matcher(f.getName()).find()) set.add(f);
    for(int d=0;d<depth;d++){ Set<Function> n=new LinkedHashSet<>(set); for(Function f:set) for(Function c:f.getCalledFunctions(monitor)) if(!c.isExternal()) n.add(c); set=n; }
    DecompInterface di=new DecompInterface(); di.openProgram(currentProgram);
    for(Function f:set){ DecompileResults r=di.decompileFunction(f,60,monitor);
      String n=f.getEntryPoint().toString()+"_"+f.getName().replaceAll("[^A-Za-z0-9_]","_");
      if(r.decompileCompleted()) Files.writeString(out.resolve(n+".c"),r.getDecompiledFunction().getC()); }
  }
}
