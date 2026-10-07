/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005f6ff0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005f6ff0(float *param_1)

{
  float fVar1;
  
  fVar1 = (float)_DAT_006e9808 /
          SQRT(param_1[3] * param_1[3] +
               param_1[2] * param_1[2] + param_1[1] * param_1[1] + *param_1 * *param_1);
  *param_1 = fVar1 * *param_1;
  param_1[1] = fVar1 * param_1[1];
  param_1[2] = fVar1 * param_1[2];
  param_1[3] = fVar1 * param_1[3];
  return;
}


