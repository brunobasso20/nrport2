// @category OpenNR2003
import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.*;
import java.io.*;
public class ExportProfileData extends GhidraScript {
 String cstr(long ptr) throws Exception {
  if(ptr==0)return "";
  StringBuilder s=new StringBuilder();Address a=toAddr(ptr);
  for(int i=0;i<512;i++){int b=currentProgram.getMemory().getByte(a.add(i))&255;if(b==0)break;s.append((char)b);}
  return s.toString().replace("\t"," ").replace("\n","\\n").replace("\r","");
 }
 public void run() throws Exception {
  File out=new File(getScriptArgs()[0]);out.mkdirs();
  try(PrintWriter p=new PrintWriter(new File(out,"ai_defaults.tsv"))) {
   p.println("index\taddress\tfile_code\tsection\tkey\tdefault_f32\tdefault_bits\tcomment");
   for(int i=0;i<144;i++) {
    Address a=toAddr(0x0074aa70L+24*i);int bits=getInt(a.add(16));
    p.println(i+"\t"+a+"\t"+getInt(a)+"\t"+cstr(Integer.toUnsignedLong(getInt(a.add(4))))+"\t"+cstr(Integer.toUnsignedLong(getInt(a.add(8))))+"\t"+Float.intBitsToFloat(bits)+"\t"+String.format("%08x",bits)+"\t"+cstr(Integer.toUnsignedLong(getInt(a.add(12)))));
   }
  }
  try(PrintWriter p=new PrintWriter(new File(out,"surface_defaults.tsv"))) {
   p.println("index\tkey\tbase_f32\tbase_bits");
   for(int i=0;i<20;i++) {
    int bits=getInt(toAddr(0x006f6570L+4*i));
    p.println(i+"\t"+cstr(Integer.toUnsignedLong(getInt(toAddr(0x0074f7d8L+4*i))))+"\t"+Float.intBitsToFloat(bits)+"\t"+String.format("%08x",bits));
   }
  }
 }
}
