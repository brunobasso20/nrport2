/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 006c6f60 */

/* WARNING: Control flow encountered bad instruction data */

void __fastcall FUN_006c6f60(int param_1,undefined2 param_2)

{
  undefined4 *unaff_ESI;
  undefined2 unaff_retaddr;
  
  out(*unaff_ESI,param_2);
  if (param_1 == 1) {
    return;
  }
  out(*(undefined4 *)((int)unaff_ESI + 3),unaff_retaddr);
                    /* WARNING: Bad instruction - Truncating control flow here */
  halt_baddata();
}


