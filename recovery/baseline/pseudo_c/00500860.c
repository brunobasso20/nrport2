/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00500860 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 __fastcall FUN_00500860(undefined4 param_1)

{
  char cVar1;
  
  cVar1 = FUN_00502460(param_1);
  if ((cVar1 == '\0') || (DAT_00b8e5aa == 0)) {
    return (float10)_DAT_006ea454;
  }
  if (DAT_00b8e5ae == '\0') {
    return (float10)DAT_00b8e5aa;
  }
  if (DAT_00b8e5aa < 0) {
    return (float10)_DAT_006e97d8 / (float10)(DAT_00b8e5aa + -1);
  }
  return (float10)_DAT_006e97d8 / (float10)(DAT_00b8e5aa + 1);
}


