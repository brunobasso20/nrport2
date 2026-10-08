/* NR2003.exe @ 005f6a70 FUN_005f6a70 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005f6a70(float *param_1)

{
  float fVar1;
  
  fVar1 = SQRT(param_1[2] * param_1[2] + param_1[1] * param_1[1] + *param_1 * *param_1);
  if (ABS(fVar1) < _DAT_006f8b88) {
    *param_1 = 1.0;
    param_1[1] = 0.0;
    param_1[2] = 0.0;
    return;
  }
  fVar1 = _DAT_006e97d8 / fVar1;
  *param_1 = fVar1 * *param_1;
  param_1[1] = fVar1 * param_1[1];
  param_1[2] = fVar1 * param_1[2];
  return;
}

