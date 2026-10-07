// @category NR2003.Recovery
// Args: outFile startHex endHex  -- disassemble (if needed) and print instructions in range
import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.*;
import ghidra.program.model.listing.*;
import ghidra.program.model.scalar.Scalar;
import java.nio.file.*;
public class DumpRange extends GhidraScript {
    public void run() throws Exception {
        String[] a=getScriptArgs();
        long s=Long.parseLong(a[1],16), e=Long.parseLong(a[2],16);
        Address cur=toAddr(s);
        StringBuilder sb=new StringBuilder();
        while(cur.getOffset()<e){
            Instruction ins=getInstructionAt(cur);
            if(ins==null){ disassemble(cur); ins=getInstructionAt(cur); }
            if(ins==null){ sb.append(cur).append(" ??\n"); cur=cur.add(1); continue; }
            sb.append(cur).append(" ").append(ins);
            for(int i=0;i<ins.getNumOperands();i++){ Object[] objs=ins.getOpObjects(i);
                for(Object o:objs) if(o instanceof Scalar){ long v=((Scalar)o).getUnsignedValue(); if(v>0xffff && v<=0xffffffffL) sb.append(String.format("  ;f=%s",Float.intBitsToFloat((int)v))); } }
            sb.append("\n");
            cur=cur.add(ins.getLength());
        }
        Files.writeString(Paths.get(a[0]),sb.toString());
    }
}
