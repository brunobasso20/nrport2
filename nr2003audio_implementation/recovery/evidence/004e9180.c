/* NR2003.exe @ 004e9180 recovered_004e9180 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall recovered_004e9180(int param_1,float *param_2,float param_3,char param_4)

{
  int iVar1;
  float10 extraout_ST0;
  undefined auStack_8 [8];
  
  FUN_006c6a24((double)(param_3 * (float)_DAT_006f3818),auStack_8);
  iVar1 = FUN_006c5018();
  param_2[1] = (float)(((float10)*(float *)(param_1 + 0x41 + iVar1 * 8) -
                       (float10)*(float *)(param_1 + 0x39 + iVar1 * 8)) * extraout_ST0 +
                      (float10)*(float *)(param_1 + 0x39 + iVar1 * 8));
  if (param_4 == '\0') {
    *param_2 = param_3;
    return;
  }
  *param_2 = (float)(((float10)*(float *)(param_1 + 0x3d + iVar1 * 8) -
                     (float10)*(float *)(param_1 + 0x35 + iVar1 * 8)) * extraout_ST0 +
                    (float10)*(float *)(param_1 + 0x35 + iVar1 * 8));
  return;
}

