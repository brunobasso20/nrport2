/* Ghidra pseudo-C; NR2003.exe @ 0057c9b0 */

void FUN_0057c9b0(int *param_1)

{
  int iVar1;
  
  iVar1 = FUN_0057c890(param_1);
  if (iVar1 == 0) {
    iVar1 = FUN_0057c860(param_1);
    if (iVar1 != 0) {
      *param_1 = iVar1;
      return;
    }
    iVar1 = FUN_005b2980(param_1);
    if (iVar1 == 0) {
      iVar1 = FUN_005bcd70();
      *param_1 = (int)(&DAT_00ebbf60 + iVar1 * 4);
    }
    else {
      FUN_005bcd80(param_1);
    }
    *(int **)PTR_DAT_0074fd54 = param_1;
    PTR_DAT_0074fd54 = PTR_DAT_0074fd54 + 4;
  }
  return;
}

