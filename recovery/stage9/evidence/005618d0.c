/* NR2003.exe @ 005618d0 FUN_005618d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005618d0(float **param_1)

{
  float *pfVar1;
  float *pfVar2;
  float *pfVar3;
  
  pfVar1 = param_1[2];
  pfVar2 = param_1[3];
  pfVar3 = param_1[5];
  if ((float)pfVar1 < _DAT_00c085a0 == (NAN((float)pfVar1) || NAN(_DAT_00c085a0))) {
    **param_1 = 0.0;
  }
  else {
    **param_1 = (_DAT_00c085a0 - (float)pfVar1) * _DAT_006f5cf4 - (float)param_1[4] * _DAT_006f5cf0;
  }
  if ((float)pfVar2 < _DAT_00c081e8 != (NAN((float)pfVar2) || NAN(_DAT_00c081e8))) {
    *param_1[1] = (_DAT_00c081e8 - (float)pfVar2) * _DAT_006f5cf4 - (float)pfVar3 * _DAT_006f5cf0;
    return;
  }
  *param_1[1] = 0.0;
  return;
}

