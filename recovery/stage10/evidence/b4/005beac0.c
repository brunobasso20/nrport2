/* NR2003.exe @ 005beac0 FUN_005beac0 */

float FUN_005beac0(float *param_1,float param_2)

{
  float fVar1;
  
  fpatan((float10)param_2 * (float10)*param_1,(float10)1);
  fVar1 = (float)FUN_006c5018();
  if ((int)fVar1 < (int)param_1[4]) {
    return param_1[4];
  }
  if ((int)param_1[5] < (int)fVar1) {
    fVar1 = param_1[5];
  }
  return fVar1;
}

