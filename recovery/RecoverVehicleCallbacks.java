// @category OpenNR2003
// Run in a COPY of the Ghidra project with -noanalysis -readOnly.
// Creates missing callback boundaries in memory only, exports pseudo-C/assembly.
import ghidra.app.script.GhidraScript;
import ghidra.app.decompiler.*;
import ghidra.program.model.listing.*;
import java.io.*;
import java.util.*;
public class RecoverVehicleCallbacks extends GhidraScript {
 public void run() throws Exception {
  File out=new File(getScriptArgs()[0]); out.mkdirs();
  Set<Long> addresses=new TreeSet<>();
  for(long p=0x0074df10L;p<0x0074df20L;p+=4)
   addresses.add(Integer.toUnsignedLong(getInt(toAddr(p))));
  for(long a:new long[]{0x0054c1c0,0x0054cab0,0x0055e160,0x0055e180,
   0x00561040,0x005614b0,0x005618d0,0x00561a80,0x00561b70,0x00561e50,0x005677d1}) addresses.add(a);
  for(long a:addresses)if(getFunctionAt(toAddr(a))==null)
   createFunction(toAddr(a),"recovered_"+Long.toHexString(a));
  for(int depth=0;depth<2;depth++) {
   Set<Long> next=new TreeSet<>(addresses);
   for(long a:addresses){Function f=getFunctionAt(toAddr(a));if(f==null)continue;
    for(Function c:f.getCalledFunctions(monitor))if(!c.isExternal())next.add(c.getEntryPoint().getOffset());}
   addresses=next;
  }
  DecompInterface di=new DecompInterface();di.openProgram(currentProgram);
  for(long a:addresses){Function f=getFunctionAt(toAddr(a));if(f==null)continue;
   DecompileResults r=di.decompileFunction(f,30,monitor);
   if(r.decompileCompleted())try(PrintWriter p=new PrintWriter(new File(out,String.format("%08x.c",a)))){p.println(r.getDecompiledFunction().getC());}
   if(a==0x0054c1c0L||a==0x005677d1L)try(PrintWriter p=new PrintWriter(new File(out,String.format("%08x.asm",a)))){
    for(Instruction i:currentProgram.getListing().getInstructions(f.getBody(),true))p.println(i.getAddress()+" "+i);}
  }
  di.dispose();
  for(long[] block:new long[][]{{0x006e9000L,0x32000L},{0x0071b000L,0x45000L}}){
   byte[] bytes=new byte[(int)block[1]];currentProgram.getMemory().getBytes(toAddr(block[0]),bytes);
   try(FileOutputStream f=new FileOutputStream(new File(out,String.format("%08x.bin",block[0])))){f.write(bytes);}
  }
 }
}
