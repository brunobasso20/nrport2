/* NR2003.exe @ 005581d0 FUN_005581d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float __thiscall FUN_005581d0(int param_1_00,int param_1,float param_2)

{
  short *psVar1;
  int iVar2;
  undefined4 uVar3;
  float fVar4;
  float fVar5;
  
  psVar1 = *(short **)((int)&DAT_00c05152 + param_1 * 6);
  if (*psVar1 == 3) {
    iVar2 = ((int)param_2 - *(int *)(psVar1 + 1)) / *(int *)(psVar1 + 5);
  }
  else {
    iVar2 = (int)ROUND((param_2 - *(float *)(psVar1 + 1)) / *(float *)(psVar1 + 5) + _DAT_006ea4cc);
  }
  if (*psVar1 == 4) {
    fVar5 = (float)iVar2 * *(float *)(psVar1 + 5) + *(float *)(psVar1 + 1);
    if (fVar5 < *(float *)(psVar1 + 1) != (NAN(fVar5) || NAN(*(float *)(psVar1 + 1)))) {
      fVar4 = *(float *)(psVar1 + 1);
      uVar3 = (**(code **)(psVar1 + 9))(fVar4);
      *(undefined4 *)(param_1_00 + param_1 * 4) = uVar3;
      return fVar4;
    }
    if (*(float *)(psVar1 + 3) < fVar5) {
      fVar4 = *(float *)(psVar1 + 3);
      uVar3 = (**(code **)(psVar1 + 9))(fVar4);
      *(undefined4 *)(param_1_00 + param_1 * 4) = uVar3;
      return fVar4;
    }
  }
  else {
    fVar5 = (float)(*(int *)(psVar1 + 5) * iVar2 + *(int *)(psVar1 + 1));
    fVar4 = *(float *)(psVar1 + 1);
    if (((int)fVar5 < (int)fVar4) || (fVar4 = *(float *)(psVar1 + 3), (int)fVar4 < (int)fVar5)) {
      fVar5 = fVar4;
    }
  }
  uVar3 = (**(code **)(psVar1 + 9))(fVar5);
  *(undefined4 *)(param_1_00 + param_1 * 4) = uVar3;
  return fVar5;
}

