/* NR2003.exe @ 005583e0 FUN_005583e0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __thiscall FUN_005583e0(int param_1_00,int param_1,char param_3)

{
  short *psVar1;
  float fVar2;
  float fVar3;
  int iVar4;
  int iVar5;
  undefined4 uVar6;
  
  psVar1 = *(short **)((int)&DAT_00c05152 + param_1 * 6);
  fVar3 = (float)(**(code **)(psVar1 + 0xb))(*(undefined4 *)(param_1_00 + param_1 * 4));
  if (*psVar1 == 3) {
    iVar4 = ((int)fVar3 - *(int *)(psVar1 + 1)) / *(int *)(psVar1 + 5);
  }
  else {
    iVar4 = (int)ROUND((fVar3 - *(float *)(psVar1 + 1)) / *(float *)(psVar1 + 5) + _DAT_006ea4cc);
  }
  iVar5 = iVar4 + 1;
  if (param_3 == '\0') {
    iVar5 = iVar4 + -1;
  }
  if (*psVar1 == 4) {
    fVar3 = (float)iVar5 * *(float *)(psVar1 + 5) + *(float *)(psVar1 + 1);
    if (fVar3 < *(float *)(psVar1 + 1) == (NAN(fVar3) || NAN(*(float *)(psVar1 + 1)))) {
      if (*(float *)(psVar1 + 3) < fVar3) {
        fVar3 = *(float *)(psVar1 + 3);
      }
    }
    else {
      fVar3 = *(float *)(psVar1 + 1);
    }
  }
  else {
    fVar3 = (float)(*(int *)(psVar1 + 5) * iVar5 + *(int *)(psVar1 + 1));
    fVar2 = *(float *)(psVar1 + 1);
    if (((int)fVar3 < (int)*(float *)(psVar1 + 1)) ||
       (fVar2 = *(float *)(psVar1 + 3), (int)*(float *)(psVar1 + 3) < (int)fVar3)) {
      fVar3 = fVar2;
    }
  }
  if (*psVar1 == 3) {
    iVar5 = ((int)fVar3 - *(int *)(psVar1 + 1)) / *(int *)(psVar1 + 5);
  }
  else {
    iVar5 = (int)ROUND((fVar3 - *(float *)(psVar1 + 1)) / *(float *)(psVar1 + 5) + _DAT_006ea4cc);
  }
  if (iVar5 == iVar4) {
    return 0;
  }
  uVar6 = (**(code **)(psVar1 + 9))(fVar3);
  *(undefined4 *)(param_1_00 + param_1 * 4) = uVar6;
  return 1;
}

