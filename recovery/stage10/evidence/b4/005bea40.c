/* NR2003.exe @ 005bea40 FUN_005bea40 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005bea40(float *param_1,undefined4 param_2,float param_3,char param_4,char param_5)

{
  float fVar1;
  float fVar2;
  float10 fVar3;
  float10 fVar4;
  
  fVar3 = (float10)FUN_006c72b0();
  fVar4 = (float10)fptan(fVar3);
  fVar1 = (float)((1 << (param_4 - (param_5 != '\0') & 0x1fU)) + -1);
  param_1[5] = fVar1;
  if (param_5 == '\0') {
    fVar2 = 0.0;
  }
  else {
    fVar2 = (float)-(int)fVar1;
  }
  param_1[4] = fVar2;
  *param_1 = (float)(fVar4 / (float10)param_3);
  param_1[1] = (float)(((float10)_DAT_006ea44c + (float10)(int)fVar1) / fVar3);
  param_1[2] = (float)(fVar3 / (float10)(int)fVar1);
  param_1[3] = (float)((float10)param_3 / fVar4);
  return;
}

