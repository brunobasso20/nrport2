/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 006c6d40 */

/* WARNING: Control flow encountered bad instruction data */

void __fastcall FUN_006c6d40(byte param_1)

{
  code *pcVar1;
  byte bVar2;
  undefined4 in_EAX;
  int unaff_EBP;
  undefined4 *unaff_EDI;
  
  *unaff_EDI = in_EAX;
  bVar2 = (byte)((uint)in_EAX >> 8);
  if (!CARRY1(param_1,bVar2) &&
      !CARRY1(param_1 + bVar2,
              (longlong)(int)((longlong)unaff_EBP * -0x2f) != (longlong)unaff_EBP * -0x2f)) {
    do {
                    /* WARNING: Do nothing block with infinite loop */
    } while( true );
  }
  pcVar1 = (code *)swi(0x7b);
  (*pcVar1)();
                    /* WARNING: Bad instruction - Truncating control flow here */
  halt_baddata();
}


