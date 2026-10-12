/* NR2003.exe @ 005f6b50 FUN_005f6b50 */

void FUN_005f6b50(float *param_1,float *param_2,float *param_3)

{
  float *pfVar1;
  float *pfVar2;
  int iVar3;
  float *pfVar4;
  float local_24 [9];
  
  if ((param_1 == param_2) || (pfVar4 = param_1, param_1 == param_3)) {
    pfVar4 = local_24;
  }
  iVar3 = 3;
  pfVar1 = param_2 + 1;
  pfVar2 = pfVar4;
  do {
    iVar3 = iVar3 + -1;
    *pfVar2 = pfVar1[-1] * *param_3 + *pfVar1 * param_3[3] + pfVar1[1] * param_3[6];
    *(float *)((int)pfVar4 + (-0xc - (int)param_2) + (int)(pfVar1 + 3)) =
         pfVar1[-1] * param_3[1] + *pfVar1 * param_3[4] + pfVar1[1] * param_3[7];
    pfVar2[2] = pfVar1[-1] * param_3[2] + *pfVar1 * param_3[5] + pfVar1[1] * param_3[8];
    pfVar1 = pfVar1 + 3;
    pfVar2 = pfVar2 + 3;
  } while (iVar3 != 0);
  if (pfVar4 != param_1) {
    for (iVar3 = 9; iVar3 != 0; iVar3 = iVar3 + -1) {
      *param_1 = *pfVar4;
      pfVar4 = pfVar4 + 1;
      param_1 = param_1 + 1;
    }
  }
  return;
}

