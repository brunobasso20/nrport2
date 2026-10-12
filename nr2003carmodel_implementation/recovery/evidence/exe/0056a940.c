/* NR2003.exe @ 0056a940 FUN_0056a940 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0056a940(int param_1)

{
  float10 fVar1;
  
  fVar1 = (float10)fptan((float10)*(float *)(param_1 + 0x98) * (float10)_DAT_006ea44c);
  fVar1 = (float10)_DAT_006e9808 / fVar1;
  if (fVar1 < (float10)_DAT_006ea44c != (NAN(fVar1) || NAN((float10)_DAT_006ea44c))) {
    *(undefined4 *)(param_1 + 0xa4) = 0x3f000000;
    return;
  }
  if ((float10)_DAT_006ecfc8 < fVar1) {
    *(undefined4 *)(param_1 + 0xa4) = 0x41a00000;
    return;
  }
  *(float *)(param_1 + 0xa4) = (float)fVar1;
  return;
}

