/* NR2003.exe @ 0056f040 FUN_0056f040 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_0056f040(float *param_1,float param_2)

{
  float10 fVar1;
  
  fVar1 = (float10)param_2;
  if (fVar1 < (float10)*param_1 == (NAN(fVar1) || NAN((float10)*param_1))) {
    if ((float10)param_1[1] < fVar1) {
      fVar1 = (float10)param_1[1];
    }
  }
  else {
    fVar1 = (float10)*param_1;
  }
  return (((float10)param_1[3] - (float10)param_1[2]) *
          ((fVar1 - (float10)*param_1) / ((float10)param_1[1] - (float10)*param_1)) +
         (float10)param_1[2]) * (float10)_DAT_006f5cd4;
}

