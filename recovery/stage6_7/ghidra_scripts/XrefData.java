// @category NR2003.Recovery
// Args: outFile addrFile   -- for each address (data or function), list referencing functions.
import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.*;
import ghidra.program.model.listing.*;
import ghidra.program.model.symbol.*;
import java.nio.file.*;
import java.util.*;
public class XrefData extends GhidraScript {
    public void run() throws Exception {
        String[] a=getScriptArgs();
        StringBuilder sb=new StringBuilder();
        ReferenceManager rm=currentProgram.getReferenceManager();
        for(String line:Files.readAllLines(Paths.get(a[1]))){line=line.trim(); if(line.isEmpty())continue;
            String[] parts=line.split("\\s+"); long start=Long.parseLong(parts[0],16); long len=parts.length>1?Long.parseLong(parts[1]):1;
            for(long x=start;x<start+len;x++){ Address t=toAddr(x);
                for(Reference ref:rm.getReferencesTo(t)){ Function f=getFunctionContaining(ref.getFromAddress());
                    sb.append(String.format("%08x\t%s\t%s\t%s\n",x,ref.getFromAddress(),f==null?"?":f.getEntryPoint()+":"+f.getName(),ref.getReferenceType())); } }
        }
        Files.writeString(Paths.get(a[0]),sb.toString());
    }
}
