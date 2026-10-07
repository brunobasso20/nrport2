/* NR2003.exe @ 0051f860 FUN_0051f860 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0051f860(int param_1,float *param_2,float *param_3)

{
  int iVar1;
  
  iVar1 = *(int *)(param_1 + 0x5ae);
  if (iVar1 != 0) {
    *param_2 = (_DAT_00e0bb50 * *(float *)(iVar1 + 0x34) + _DAT_00e0bb54 * *(float *)(iVar1 + 0x38))
               * _DAT_006efe48;
    *param_3 = (_DAT_00e0bb54 * *(float *)(iVar1 + 0x34) - _DAT_00e0bb50 * *(float *)(iVar1 + 0x38))
               * _DAT_006efe48;
    return;
  }
  *param_2 = 0.0;
  *param_3 = 0.0;
  return;
}

