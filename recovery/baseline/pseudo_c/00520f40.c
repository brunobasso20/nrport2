/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00520f40 */

bool __fastcall FUN_00520f40(int *param_1)

{
  char cVar1;
  int iVar2;
  
  if (*param_1 != 0) {
    iVar2 = 0;
    do {
      cVar1 = FUN_00520e80(iVar2);
      if (cVar1 != '\0') {
        return true;
      }
      iVar2 = iVar2 + 1;
    } while (iVar2 < 0x1b);
  }
  cVar1 = FUN_00520f80();
  return cVar1 != '\0';
}


