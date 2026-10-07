// @category NR2003.Recovery
// Args: outFile regex  -- defined strings matching regex + referencing functions
import ghidra.app.script.GhidraScript;
import ghidra.program.model.listing.*;
import ghidra.program.model.symbol.*;
import java.nio.file.*;
import java.util.regex.*;
public class FindStrings extends GhidraScript {
    public void run() throws Exception {
        String[] a=getScriptArgs(); Pattern p=Pattern.compile(a[1]);
        StringBuilder sb=new StringBuilder();
        ReferenceManager rm=currentProgram.getReferenceManager();
        DataIterator it=currentProgram.getListing().getDefinedData(true);
        while(it.hasNext()){ Data d=it.next(); if(!d.hasStringValue())continue; String s=String.valueOf(d.getValue());
            if(!p.matcher(s).find())continue;
            sb.append(d.getAddress()).append("\t").append(s.replace("\n","\\n"));
            for(Reference r:rm.getReferencesTo(d.getAddress())){Function f=getFunctionContaining(r.getFromAddress()); sb.append("\t").append(r.getFromAddress()).append("@").append(f==null?"?":f.getEntryPoint().toString());}
            sb.append("\n"); }
        Files.writeString(Paths.get(a[0]),sb.toString());
    }
}
