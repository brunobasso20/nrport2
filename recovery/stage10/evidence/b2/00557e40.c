/* NR2003.exe @ 00557e40 FUN_00557e40 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 __thiscall FUN_00557e40(int param_1_00,float param_1)

{
  short *psVar1;
  int iVar2;
  
  psVar1 = *(short **)((int)&DAT_00c05152 + (int)param_1 * 6);
  param_1 = (float)(**(code **)(psVar1 + 0xb))(*(undefined4 *)(param_1_00 + (int)param_1 * 4));
  if (*(int *)(psVar1 + 9) != 0) {
    if (*psVar1 == 3) {
      iVar2 = ((int)param_1 - *(int *)(psVar1 + 1)) / *(int *)(psVar1 + 5);
    }
    else {
      iVar2 = (int)ROUND((param_1 - *(float *)(psVar1 + 1)) / *(float *)(psVar1 + 5) + _DAT_006ea4cc
                        );
    }
    if (*psVar1 == 4) {
      return (float10)((float)iVar2 * *(float *)(psVar1 + 5) + *(float *)(psVar1 + 1));
    }
    param_1 = (float)(*(int *)(psVar1 + 5) * iVar2 + *(int *)(psVar1 + 1));
  }
  return (float10)param_1;
}

