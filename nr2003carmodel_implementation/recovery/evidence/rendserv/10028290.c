/* NR2003.exe @ 10028290 FUN_10028290 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __cdecl FUN_10028290(float *param_1,float *param_2)

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
  
  fVar7 = param_2[3] + param_2[3];
  fVar1 = *param_2;
  fVar2 = param_2[1];
  fVar3 = param_2[2];
  fVar8 = fVar7 * param_2[3];
  fVar12 = *param_2 + *param_2;
  fVar4 = param_2[1];
  fVar5 = param_2[2];
  fVar9 = param_2[1] + param_2[1];
  fVar10 = fVar9 * param_2[2];
  fVar6 = param_2[1];
  fVar11 = param_2[2] * param_2[2];
  *param_1 = (fVar12 * *param_2 + fVar8) - _DAT_100341f0;
  param_1[1] = fVar12 * fVar4 - fVar7 * fVar3;
  param_1[2] = fVar12 * fVar5 + fVar7 * fVar2;
  param_1[3] = fVar12 * fVar4 + fVar7 * fVar3;
  param_1[4] = (fVar9 * fVar6 + fVar8) - _DAT_100341f0;
  param_1[5] = fVar10 - fVar7 * fVar1;
  param_1[6] = fVar12 * fVar5 - fVar7 * fVar2;
  param_1[7] = fVar10 + fVar7 * fVar1;
  param_1[8] = (fVar11 + fVar11 + fVar8) - _DAT_100341f0;
  return;
}

