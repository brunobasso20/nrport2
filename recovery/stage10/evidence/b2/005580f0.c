/* NR2003.exe @ 005580f0 FUN_005580f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 __thiscall FUN_005580f0(int param_1_00,float param_1,float param_2)

{
  short *psVar1;
  int iVar2;
  int iVar3;
  float fVar4;
  undefined4 uVar5;
  
  iVar2 = (int)param_1;
  psVar1 = *(short **)((int)&DAT_00c05152 + (int)param_1 * 6);
  if (*psVar1 == 3) {
    iVar3 = ((int)param_2 - *(int *)(psVar1 + 1)) / *(int *)(psVar1 + 5);
  }
  else {
    iVar3 = (int)ROUND((param_2 - *(float *)(psVar1 + 1)) / *(float *)(psVar1 + 5) + _DAT_006ea4cc);
  }
  if (*psVar1 == 4) {
    param_1 = (float)iVar3 * *(float *)(psVar1 + 5) + *(float *)(psVar1 + 1);
    if (param_1 < *(float *)(psVar1 + 1) == (NAN(param_1) || NAN(*(float *)(psVar1 + 1)))) {
      if (*(float *)(psVar1 + 3) < param_1) {
        param_1 = *(float *)(psVar1 + 3);
      }
    }
    else {
      param_1 = *(float *)(psVar1 + 1);
    }
  }
  else {
    param_1 = (float)(*(int *)(psVar1 + 5) * iVar3 + *(int *)(psVar1 + 1));
    fVar4 = *(float *)(psVar1 + 1);
    if (((int)param_1 < (int)fVar4) || (fVar4 = *(float *)(psVar1 + 3), (int)fVar4 < (int)param_1))
    {
      param_1 = fVar4;
    }
  }
  uVar5 = (**(code **)(psVar1 + 9))(param_1);
  *(undefined4 *)(param_1_00 + iVar2 * 4) = uVar5;
  return (float10)param_1;
}

