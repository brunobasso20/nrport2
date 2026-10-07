/* Ghidra pseudo-C; NR2003.exe @ 005ba130 */

int __fastcall FUN_005ba130(int param_1)

{
  char cVar1;
  int iVar2;
  
  cVar1 = FUN_005ba080();
  if (cVar1 != '\0') {
    return param_1 + 0x2f0;
  }
  iVar2 = FUN_005ba150();
  return iVar2;
}

