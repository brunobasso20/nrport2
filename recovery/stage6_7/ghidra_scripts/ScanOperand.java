// @category NR2003.Recovery
// Args: outFile hexValue...  -- list instructions whose text contains given displacement/scalar
import ghidra.app.script.GhidraScript;
import ghidra.program.model.listing.*;
import java.nio.file.*;
import java.util.*;
public class ScanOperand extends GhidraScript {
    public void run() throws Exception {
        String[] a=getScriptArgs();
        List<String> keys=new ArrayList<>();
        for(int i=1;i<a.length;i++) keys.add(a[i].toLowerCase());
        StringBuilder sb=new StringBuilder();
        InstructionIterator it=currentProgram.getListing().getInstructions(true);
        while(it.hasNext()){ Instruction ins=it.next(); String t=ins.toString().toLowerCase();
            for(String k:keys){ if(t.contains(k)){ Function f=getFunctionContaining(ins.getAddress());
                sb.append(ins.getAddress()).append("\t").append(f==null?"?":f.getEntryPoint().toString()).append("\t").append(ins).append("\n"); break; } } }
        Files.writeString(Paths.get(a[0]),sb.toString());
    }
}
