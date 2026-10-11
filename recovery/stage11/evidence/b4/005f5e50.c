/* NR2003.exe @ 005f5e50 FUN_005f5e50 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005f5e50(float *param_1,float *param_2,float *param_3)

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
  float fVar13;
  
  if ((NAN(param_3[2]) || NAN(_DAT_006ea454)) == (param_3[2] == _DAT_006ea454)) {
    param_2[2] = -((param_3[1] * param_2[1] + *param_2 * *param_3) / param_3[2]);
    FUN_005f6a70(param_2);
    fVar1 = *param_3;
    fVar2 = param_2[1];
    fVar3 = param_3[1];
    fVar4 = *param_2;
    fVar5 = param_2[2];
    fVar6 = param_3[1];
    fVar7 = param_2[1];
    fVar8 = param_3[2];
    fVar9 = *param_2;
    fVar10 = param_3[2];
    fVar11 = param_2[2];
    fVar12 = *param_3;
    *param_1 = *param_2;
    param_1[3] = param_2[1];
    fVar13 = param_2[2];
    param_1[1] = fVar5 * fVar6 - fVar7 * fVar8;
    param_1[6] = fVar13;
    param_1[4] = fVar9 * fVar10 - fVar11 * fVar12;
    param_1[7] = fVar1 * fVar2 - fVar3 * fVar4;
    param_1[2] = *param_3;
    param_1[5] = param_3[1];
    param_1[8] = param_3[2];
    return;
  }
  param_2[2] = 0.0;
  param_1[4] = 1.0;
  *param_1 = 1.0;
  param_1[7] = 0.0;
  param_1[6] = 0.0;
  param_1[5] = 0.0;
  param_1[3] = 0.0;
  param_1[2] = 0.0;
  param_1[1] = 0.0;
  param_1[8] = 1.0;
  return;
}

