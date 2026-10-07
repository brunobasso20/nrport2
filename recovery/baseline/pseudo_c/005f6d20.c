/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005f6d20 */

void FUN_005f6d20(float *param_1,float *param_2,float *param_3)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float fVar7;
  float fVar8;
  float fVar9;
  float fVar10;
  float fVar11;
  float fVar12;
  
  if (param_1 == param_3) {
    fVar1 = param_2[4];
    fVar2 = param_3[1];
    fVar3 = param_2[3];
    fVar4 = *param_3;
    fVar5 = param_2[5];
    fVar6 = param_3[2];
    fVar7 = param_2[7];
    fVar8 = param_3[1];
    fVar9 = param_2[6];
    fVar10 = *param_3;
    fVar11 = param_2[8];
    fVar12 = param_3[2];
    *param_1 = *param_2 * *param_3 + param_2[2] * param_3[2] + param_2[1] * param_3[1];
    param_1[1] = fVar5 * fVar6 + fVar3 * fVar4 + fVar1 * fVar2;
    param_1[2] = fVar11 * fVar12 + fVar9 * fVar10 + fVar7 * fVar8;
    return;
  }
  *param_1 = *param_2 * *param_3 + param_2[2] * param_3[2] + param_2[1] * param_3[1];
  param_1[1] = param_2[5] * param_3[2] + param_2[3] * *param_3 + param_2[4] * param_3[1];
  param_1[2] = param_2[8] * param_3[2] + param_2[6] * *param_3 + param_2[7] * param_3[1];
  return;
}


