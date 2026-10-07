/* NR2003.exe @ 00523760 FUN_00523760 */

void __thiscall FUN_00523760(int param_1_00,int param_1)

{
  int iVar1;
  
  if (*(char *)(param_1_00 + 0xfd) != '\0') {
    iVar1 = FUN_00557da0(0x3b);
    if (param_1 < iVar1) {
      param_1 = iVar1;
    }
    iVar1 = FUN_00557de0(0x3b);
    if (iVar1 < param_1) {
      param_1 = iVar1;
    }
    *(int *)(param_1_00 + 0xf2) = param_1;
  }
  return;
}

