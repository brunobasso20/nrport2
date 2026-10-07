/* Ghidra pseudo-C; NR2003.exe @ 00561040 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void recovered_00561040(undefined4 *param_1)

{
  float fVar1;
  
  if (_DAT_006ea454 <= (float)param_1[2]) {
    if ((float)param_1[2] < (float)param_1[1]) {
      *(float *)*param_1 = -(float)param_1[2];
      return;
    }
    *(float *)*param_1 = -(float)param_1[1];
    return;
  }
  fVar1 = -(float)param_1[2];
  if (fVar1 < (float)param_1[1]) {
    *(float *)*param_1 = fVar1;
    return;
  }
  *(undefined4 *)*param_1 = param_1[1];
  return;
}

