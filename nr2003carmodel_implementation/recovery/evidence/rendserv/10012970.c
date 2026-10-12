/* NR2003.exe @ 10012970 FUN_10012970 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __cdecl FUN_10012970(float *param_1,float *param_2,float param_3,float *param_4)

{
  float fVar1;
  
  fVar1 = _DAT_100341f0 - param_3;
  if (_DAT_100341f0 <=
      (param_2[3] - param_1[3]) * (param_2[3] - param_1[3]) +
      (param_2[1] - param_1[1]) * (param_2[1] - param_1[1]) +
      (*param_2 - *param_1) * (*param_2 - *param_1) +
      (param_2[2] - param_1[2]) * (param_2[2] - param_1[2])) {
    *param_4 = fVar1 * *param_1 - param_3 * *param_2;
    param_4[1] = fVar1 * param_1[1] - param_3 * param_2[1];
    param_4[2] = fVar1 * param_1[2] - param_3 * param_2[2];
    param_4[3] = fVar1 * param_1[3] - param_3 * param_2[3];
    FUN_10028440(param_4);
    return;
  }
  *param_4 = param_3 * *param_2 + fVar1 * *param_1;
  param_4[1] = param_3 * param_2[1] + fVar1 * param_1[1];
  param_4[2] = param_3 * param_2[2] + fVar1 * param_1[2];
  param_4[3] = param_3 * param_2[3] + fVar1 * param_1[3];
  FUN_10028440(param_4);
  return;
}

