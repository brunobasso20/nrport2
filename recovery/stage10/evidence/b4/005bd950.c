/* NR2003.exe @ 005bd950 FUN_005bd950 */

void FUN_005bd950(undefined4 param_1,int param_2,int param_3)

{
  int iVar1;
  
  iVar1 = FUN_005bda20(param_3);
  if (iVar1 < 0) {
    FUN_005bd9f0(param_1,param_2 * 8 + 5);
    FUN_005bd910(&DAT_00ebbf60 + param_3 * 4);
    return;
  }
  if ((&DAT_00ebfc68)[iVar1] == param_3) {
    FUN_005bd9f0(param_1,*(int *)(&DAT_00752f08 + iVar1 * 4) + param_2 * 8);
    return;
  }
  FUN_005bd9f0(param_1,*(int *)(&DAT_00752f08 + iVar1 * 4) + 0x40 + param_2 * 8);
  FUN_005bd360((param_3 - (&DAT_00ebfc68)[iVar1]) * 4);
  return;
}

