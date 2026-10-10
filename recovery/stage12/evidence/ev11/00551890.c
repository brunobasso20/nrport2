/* NR2003.exe @ 00551890 FUN_00551890 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_00551890(float param_1)

{
  int iVar1;
  float10 fVar2;
  
  iVar1 = (int)param_1;
  if (param_1 == 0.0) {
    param_1 = DAT_00bf6d74;
  }
  else if (param_1 == 1.401298e-45) {
    param_1 = DAT_00bf6d8c;
  }
  else {
    fVar2 = (float10)fsin((float10)_DAT_00bf6dac);
    if (param_1 == 2.802597e-45) {
      param_1 = (float)(fVar2 * (float10)_DAT_00c0839c + (float10)_DAT_00bf6da4);
    }
    else {
      param_1 = (float)((float10)_DAT_00bf6da4 - fVar2 * (float10)_DAT_00c0839c);
    }
  }
  fVar2 = (float10)FUN_00560550(iVar1);
  fVar2 = fVar2 + (float10)param_1;
  if ((float10)_DAT_006ea454 < fVar2) {
    return (float10)_DAT_006ea454;
  }
  if (fVar2 < (float10)_DAT_006f52cc != (NAN(fVar2) || NAN((float10)_DAT_006f52cc))) {
    fVar2 = (float10)_DAT_006f52cc;
  }
  return fVar2;
}

