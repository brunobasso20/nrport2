// @category OpenNR2003
import ghidra.app.script.GhidraScript;
import ghidra.program.model.listing.*;
import java.io.*;
public class NumericalInventory extends GhidraScript {
 public void run() throws Exception {
  File out=new File(getScriptArgs()[0]);out.mkdirs();
  try(PrintWriter p=new PrintWriter(new File(out,"numerical_functions.tsv"))) {
   p.println("address\tname\tbytes\tfloating_instructions");
   FunctionIterator fs=currentProgram.getFunctionManager().getFunctions(true);
   while(fs.hasNext()) {
    Function f=fs.next();int fp=0;
    InstructionIterator is=currentProgram.getListing().getInstructions(f.getBody(),true);
    while(is.hasNext()) {
     String m=is.next().getMnemonicString().toUpperCase();
     if(m.startsWith("F")||m.matches("(ADD|SUB|MUL|DIV|SQRT|MIN|MAX|CVT|COMI|UCOMI).*[SP][SD]"))fp++;
    }
    if(fp>0)p.println(f.getEntryPoint()+"\t"+f.getName()+"\t"+f.getBody().getNumAddresses()+"\t"+fp);
   }
  }
 }
}
