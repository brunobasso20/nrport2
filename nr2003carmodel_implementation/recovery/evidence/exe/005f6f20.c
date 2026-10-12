/* NR2003.exe @ 005f6f20 FUN_005f6f20 */

void FUN_005f6f20(float *param_1,float param_2,float param_3,float param_4)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float10 fVar7;
  float10 fVar8;
  
  fVar7 = (float10)fcos((float10)param_2);
  fVar8 = (float10)fsin((float10)param_2);
  fVar1 = (float)fVar7;
  fVar2 = (float)fVar8;
  fVar7 = (float10)fcos((float10)param_3);
  fVar8 = (float10)fsin((float10)param_3);
  fVar3 = (float)fVar7;
  fVar4 = (float)fVar8;
  fVar7 = (float10)fcos((float10)param_4);
  fVar8 = (float10)fsin((float10)param_4);
  fVar5 = (float)fVar7;
  fVar6 = (float)fVar8;
  *param_1 = fVar3 * fVar1;
  param_1[1] = fVar1 * fVar6 * fVar4 - fVar5 * fVar2;
  param_1[2] = fVar6 * fVar2 + fVar1 * fVar5 * fVar4;
  param_1[3] = fVar3 * fVar2;
  param_1[4] = fVar5 * fVar1 + fVar6 * fVar4 * fVar2;
  param_1[5] = fVar5 * fVar4 * fVar2 - fVar6 * fVar1;
  param_1[6] = -fVar4;
  param_1[7] = fVar6 * fVar3;
  param_1[8] = fVar5 * fVar3;
  return;
}

