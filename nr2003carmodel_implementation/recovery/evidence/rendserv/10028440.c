/* NR2003.exe @ 10028440 FUN_10028440 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __cdecl FUN_10028440(float *param_1)

{
  float fVar1;
  
  fVar1 = (float)_DAT_100349a0 /
          SQRT(param_1[3] * param_1[3] +
               param_1[2] * param_1[2] + param_1[1] * param_1[1] + *param_1 * *param_1);
  *param_1 = fVar1 * *param_1;
  param_1[1] = fVar1 * param_1[1];
  param_1[2] = fVar1 * param_1[2];
  param_1[3] = fVar1 * param_1[3];
  return;
}

