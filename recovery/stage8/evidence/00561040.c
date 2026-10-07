/* NR2003.exe @ 00561040 recovered_00561040 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void recovered_00561040(float **param_1)

{
  float *pfVar1;
  float fVar2;
  
  pfVar1 = param_1[2];
  if ((float)param_1[2] < _DAT_006ea454 == (NAN((float)param_1[2]) || NAN(_DAT_006ea454))) {
    if ((float)pfVar1 < (float)param_1[1] != (NAN((float)pfVar1) || NAN((float)param_1[1]))) {
      **param_1 = -(float)param_1[2];
      return;
    }
    **param_1 = -(float)param_1[1];
    return;
  }
  fVar2 = -(float)pfVar1;
  if (fVar2 < (float)param_1[1] != (NAN(fVar2) || NAN((float)param_1[1]))) {
    **param_1 = fVar2;
    return;
  }
  **param_1 = (float)param_1[1];
  return;
}

