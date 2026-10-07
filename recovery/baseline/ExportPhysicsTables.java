// @category OpenNR2003
import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.*;
import ghidra.program.model.symbol.*;
import ghidra.program.model.listing.*;
import java.io.*;
public class ExportPhysicsTables extends GhidraScript {
 public void run() throws Exception {
  File out=new File(getScriptArgs()[0]);out.mkdirs();
  String[][] ranges={{"00727290","0072c300"},{"0074aa70","0074b800"},{"006f6570","006f65c0"},{"0074b9d8","0074b9e8"},{"0074f7d8","0074f830"},{"0074fb30","0074fb90"},{"006e9700","006e9900"},{"006f4610","006f4620"}};
  for(String[] r:ranges) {
   Address a=toAddr(r[0]),b=toAddr(r[1]);byte[] bytes=new byte[(int)b.subtract(a)];currentProgram.getMemory().getBytes(a,bytes);
   try(FileOutputStream s=new FileOutputStream(new File(out,r[0]+".bin"))){s.write(bytes);}
  }
  try(PrintWriter p=new PrintWriter(new File(out,"table_references.tsv"))) {
   p.println("data_address\tfrom\tfunction_address\tfunction");
   for(String[] r:ranges) for(Address a=toAddr(r[0]);a.compareTo(toAddr(r[1]))<0;a=a.add(1)) {
    ReferenceIterator it=currentProgram.getReferenceManager().getReferencesTo(a);
    while(it.hasNext()) {
     Reference ref=it.next();Function f=getFunctionContaining(ref.getFromAddress());
     if(f!=null)p.println(a+"\t"+ref.getFromAddress()+"\t"+f.getEntryPoint()+"\t"+f.getName());
    }
   }
  }
 }
}
