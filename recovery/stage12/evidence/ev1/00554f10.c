/* NR2003.exe @ 00554f10 FUN_00554f10 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_00554f10(void)

{
  float10 fVar1;
  
  fVar1 = (float10)_DAT_00bf6dc8 * (float10)_DAT_006f5a54;
  if (fVar1 < (float10)_DAT_006ecff8 != (NAN(fVar1) || NAN((float10)_DAT_006ecff8))) {
    return (float10)_DAT_006ecff8;
  }
  if ((float10)_DAT_006f51f4 < fVar1) {
    fVar1 = (float10)_DAT_006f51f4;
  }
  return fVar1;
}

