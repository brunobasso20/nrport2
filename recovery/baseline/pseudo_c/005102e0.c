/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005102e0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005102e0(float *param_1,float *param_2,float param_3,float param_4,float param_5,
                 float param_6,undefined4 param_7)

{
  float fVar1;
  float10 fVar2;
  
  fVar1 = (param_3 - param_5) + (param_3 - param_5) + param_4 + param_6;
  param_6 = ((param_5 - param_3) * _DAT_006ea62c - (param_4 + param_4)) - param_6;
  fVar2 = (float10)FUN_005103a0(param_7);
  fVar2 = (float10)param_4 * (float10)_DAT_006ea44c +
          (float10)fVar1 * (float10)_DAT_006f4614 + (float10)param_6 * (float10)_DAT_006ea50c +
          (float10)param_3 + fVar2;
  if ((float10)_DAT_006f45dc < fVar2) {
    fVar2 = (float10)_DAT_006f45dc;
  }
  if (fVar2 < (float10)-_DAT_006f45dc) {
    fVar2 = (float10)-_DAT_006f45dc;
  }
  *param_1 = (float)fVar2;
  *param_2 = fVar1 * _DAT_006ed6c8 + param_6 + param_4;
  return;
}


