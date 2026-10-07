// Export function inventory and physics-related string references; no autoanalysis.+// @category OpenNR2003
import ghidra.app.script.GhidraScript;
import ghidra.program.model.listing.*;
import ghidra.program.model.symbol.*;
import ghidra.program.model.address.*;
import java.io.*;
import java.util.*;
import java.util.regex.*;

public class InventoryPhysics extends GhidraScript {
    public void run() throws Exception {
        File out = new File(getScriptArgs()[0]); out.mkdirs();
        FunctionManager fm = currentProgram.getFunctionManager();
        Pattern pat = Pattern.compile("(?i)tire|tyre|wheel|suspens|slip|torque|rpm|gearbox|drivetrain|brak|aero|throttle|clutch|spring|damper|shock|differential|inertia|camber|caster|understeer|oversteer|physics|chassis|engine|fuel|drag|downforce");
        int n=0, named=0, refs=0;
        try (PrintWriter p = new PrintWriter(new File(out,"functions.tsv"))) {
            p.println("address\tname\tsource\tbytes\tsignature\tcallees");
            FunctionIterator it = fm.getFunctions(true);
            while(it.hasNext()) {
                Function f=it.next(); n++;
                if(!f.getName().startsWith("FUN_") && !f.getName().startsWith("thunk_FUN_")) named++;
                List<String> calls=new ArrayList<>();
                for(Function c:f.getCalledFunctions(monitor)) calls.add(c.getEntryPoint().toString());
                Collections.sort(calls);
                p.println(f.getEntryPoint()+"\t"+f.getName()+"\t"+f.getSymbol().getSource()+"\t"+f.getBody().getNumAddresses()+"\t"+f.getSignature()+"\t"+String.join(",",calls));
            }
        }
        try(PrintWriter p = new PrintWriter(new File(out,"physics_strings.tsv")); PrintWriter all = new PrintWriter(new File(out,"strings.tsv"))) {
            p.println("address\tstring\tref_address\tfunction_address\tfunction");
            all.println("address\tstring");
            DataIterator it=currentProgram.getListing().getDefinedData(true);
            while(it.hasNext()) {
                Data d=it.next(); if(!d.hasStringValue())continue;
                String s=String.valueOf(d.getValue()).replace("\t"," ").replace("\n","\\n").replace("\r","");
                all.println(d.getAddress()+"\t"+s);
                if(!pat.matcher(s).find())continue;
                ReferenceIterator ri=currentProgram.getReferenceManager().getReferencesTo(d.getAddress());
                boolean any=false;
                while(ri.hasNext()) {
                    Reference r=ri.next(); Function f=fm.getFunctionContaining(r.getFromAddress());
                    p.println(d.getAddress()+"\t"+s+"\t"+r.getFromAddress()+"\t"+(f==null?"":f.getEntryPoint())+"\t"+(f==null?"":f.getName())); any=true;refs++;
                }
                if(!any)p.println(d.getAddress()+"\t"+s+"\t\t\t");
            }
        }
        try(PrintWriter p=new PrintWriter(new File(out,"program.txt"))) {
            p.println("Program: "+currentProgram.getName());p.println("Functions: "+n);p.println("Named functions: "+named);p.println("Physics string references: "+refs);
            p.println(currentProgram.getOptions("Program Information").getOptions(""));
        }
        println("INVENTORY functions="+n+" named="+named+" physics refs="+refs);
    }
}
