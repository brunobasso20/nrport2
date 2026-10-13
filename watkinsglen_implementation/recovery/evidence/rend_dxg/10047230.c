/* rend_dxg.dll @ 10047230 FUN_10047230 */

void FUN_10047230(int param_1,int param_2,float param_3,undefined4 param_4,float param_5,
                 undefined4 param_6)

{
  int iVar1;
  int iVar2;
  double *pdVar3;
  int iVar4;
  int iVar5;
  int iVar6;
  int iVar7;
  double *pdVar8;
  float local_18 [5];

  if (param_2 == 0) {
    local_18[0] = param_5;
    local_18[1] = (float)param_6;
    local_18[2] = (float)param_4;
    local_18[3] = param_3;
  }
  else if (param_2 == 2) {
    local_18[0] = param_3;
    local_18[1] = (float)param_4;
    local_18[2] = (float)param_6;
    local_18[3] = param_5;
  }
  iVar7 = 0;
  iVar1 = *(int *)(param_1 + 0x38);
  iVar2 = *(int *)(param_1 + 8);
  pdVar3 = *(double **)(param_1 + 0x18);
  iVar4 = *(int *)(param_1 + 0x28);
  iVar5 = *(int *)(param_1 + 0x48);
  iVar6 = *(int *)(param_1 + 0x58);
  pdVar8 = pdVar3;
  do {
    if (iVar2 != 0) {
      *(double *)((iVar2 - (int)pdVar3) + (int)pdVar8) = (double)local_18[iVar7];
    }
    if (pdVar3 != (double *)0x0) {
      *pdVar8 = (double)local_18[iVar7];
    }
    if (iVar4 != 0) {
      *(double *)((iVar4 - (int)pdVar3) + (int)pdVar8) = (double)local_18[iVar7];
    }
    if (iVar1 != 0) {
      *(double *)((iVar1 - (int)pdVar3) + (int)pdVar8) = (double)local_18[iVar7];
    }
    if (iVar5 != 0) {
      *(double *)((iVar5 - (int)pdVar3) + (int)pdVar8) = (double)local_18[iVar7];
    }
    if (iVar6 != 0) {
      *(double *)((iVar6 - (int)pdVar3) + (int)pdVar8) = (double)local_18[iVar7];
    }
    iVar7 = iVar7 + 1;
    pdVar8 = pdVar8 + 1;
  } while (iVar7 < 4);
  return;
}
