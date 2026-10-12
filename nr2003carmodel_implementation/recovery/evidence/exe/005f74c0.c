/* NR2003.exe @ 005f74c0 FUN_005f74c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005f74c0(float *param_1,float *param_2,float *param_3,float *param_4)

{
  float fVar1;
  float10 fVar2;
  float10 fVar3;
  
  fVar2 = (float10)fpatan((float10)param_4[3],(float10)*param_4);
  *param_1 = (float)fVar2;
  fVar2 = SQRT((float10)param_4[3] * (float10)param_4[3] + (float10)*param_4 * (float10)*param_4);
  fVar3 = (float10)fpatan(-(float10)param_4[6],fVar2);
  *param_2 = (float)fVar3;
  if (fVar2 < (float10)_DAT_006ef4c8 != (NAN(fVar2) || NAN((float10)_DAT_006ef4c8))) {
    fVar2 = (float10)fpatan((float10)param_4[5],(float10)param_4[2]);
    fVar1 = *param_1;
    *param_3 = (float)((float10)fVar1 - fVar2);
    if (_DAT_006ea454 < param_4[6]) {
      *param_3 = (float)((float10)_DAT_006f4a4c - ((float10)fVar1 - fVar2));
    }
    return;
  }
  fVar3 = -(((float10)_DAT_006e97d8 / fVar2) * (float10)param_4[3]);
  fVar2 = ((float10)_DAT_006e97d8 / fVar2) * (float10)*param_4;
  fVar2 = (float10)fpatan(-(fVar3 * (float10)param_4[2] + fVar2 * (float10)param_4[5]),
                          fVar3 * (float10)param_4[1] + fVar2 * (float10)param_4[4]);
  *param_3 = (float)fVar2;
  return;
}

