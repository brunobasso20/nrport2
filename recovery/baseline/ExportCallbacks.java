// @category OpenNR2003
import ghidra.app.script.GhidraScript;
import ghidra.app.decompiler.*;
import ghidra.program.model.listing.*;
import java.io.*;
public class ExportCallbacks extends GhidraScript {
 public void run() throws Exception {
  File out=new File(getScriptArgs()[0]);out.mkdirs();
  String[] addresses={"0055e3e0"};
  DecompInterface di=new DecompInterface();
  for(String s:addresses) {
   Function f=getFunctionAt(toAddr(s));
   if(f==null)f=createFunction(toAddr(s),"recovered_callback_"+s);
   if(f==null)throw new IOException("Cannot recover callback "+s);
  }
  di.openProgram(currentProgram);
  for(String s:addresses) {
   DecompileResults r=di.decompileFunction(getFunctionAt(toAddr(s)),30,monitor);
   if(!r.decompileCompleted())throw new IOException(r.getErrorMessage());
   try(PrintWriter p=new PrintWriter(new File(out,s+".c"))){p.println("/* Callback identified by FUN_0055e410; recovered function boundary in memory only. */");p.println(r.getDecompiledFunction().getC());}
  }
  di.dispose();
 }
}
