/* Ghidra pseudo-C; NR2003.exe @ 0057d610 */

void FUN_0057d610(undefined4 *param_1,undefined4 *param_2,undefined4 *param_3)

{
  int iVar1;
  
  iVar1 = FUN_0057c890(param_2);
  if (iVar1 == 0) {
    iVar1 = FUN_0057c890(param_3);
    if (iVar1 == 0) {
      FUN_0057ca60(param_1,*(float *)*param_2 + *(float *)*param_3);
      FUN_0057ce40(*param_1);
      return;
    }
    iVar1 = FUN_0057c8d0(param_2);
    if (iVar1 != 0) {
      FUN_0057d9a0(param_1,param_3);
      return;
    }
    DAT_00d44c70 = (float *)*param_2;
    FUN_0057c990(param_1,*(float *)*param_3 + *DAT_00d44c70);
    FUN_0057ce40(*param_1);
    FUN_005b9a90(param_1,&DAT_00d44c70,param_3);
    return;
  }
  iVar1 = FUN_0057c8d0();
  if (iVar1 != 0) {
    FUN_0057d9a0(param_1,param_2);
    return;
  }
  iVar1 = FUN_0057c890(param_3);
  if (iVar1 != 0) {
    FUN_0057c990(param_1,*(float *)*param_2 + *(float *)*param_3);
    FUN_0057ce40(*param_1);
    FUN_005b9a90(param_1,param_2,param_3);
    return;
  }
  DAT_00d44c70 = (float *)*param_3;
  FUN_0057c990(param_1,*(float *)*param_2 + *DAT_00d44c70);
  FUN_0057ce40(*param_1);
  FUN_005b9a90(param_1,param_2,&DAT_00d44c70);
  return;
}

