/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005f5ce0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005f5ce0(float *param_1,float *param_2,float *param_3)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float fVar7;
  float fVar8;
  
  if (param_3[2] != _DAT_006ea454) {
    param_1[2] = -((param_3[1] * param_1[1] + *param_1 * *param_3) / param_3[2]);
    FUN_005f6a70(param_1);
    fVar1 = param_1[2];
    fVar2 = param_3[1];
    fVar3 = param_1[1];
    fVar4 = param_3[2];
    fVar5 = *param_1;
    fVar6 = param_3[2];
    fVar7 = param_1[2];
    fVar8 = *param_3;
    param_2[2] = *param_3 * param_1[1] - *param_1 * param_3[1];
    *param_2 = fVar1 * fVar2 - fVar3 * fVar4;
    param_2[1] = fVar5 * fVar6 - fVar7 * fVar8;
    return;
  }
  param_1[2] = 0.0;
  return;
}


