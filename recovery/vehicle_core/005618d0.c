/* Ghidra pseudo-C; NR2003.exe @ 005618d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005618d0(undefined4 *param_1)

{
  float fVar1;
  float fVar2;
  
  fVar1 = (float)param_1[3];
  fVar2 = (float)param_1[5];
  if (_DAT_00c085a0 <= (float)param_1[2]) {
    *(undefined4 *)*param_1 = 0;
  }
  else {
    *(float *)*param_1 =
         (_DAT_00c085a0 - (float)param_1[2]) * _DAT_006f5cf4 - (float)param_1[4] * _DAT_006f5cf0;
  }
  if (fVar1 < _DAT_00c081e8) {
    *(float *)param_1[1] = (_DAT_00c081e8 - fVar1) * _DAT_006f5cf4 - fVar2 * _DAT_006f5cf0;
    return;
  }
  *(undefined4 *)param_1[1] = 0;
  return;
}

