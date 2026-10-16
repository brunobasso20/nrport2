/* NR2003.exe @ 004ecb70 recovered_004ecb70 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 __fastcall recovered_004ecb70(int param_1)

{
  float10 fVar1;
  
  fVar1 = (float10)*(float *)(param_1 + 0x18) /
          (float10)*(float *)(*(int *)(param_1 + 0x28) + 0x182c + *(int *)(param_1 + 0x2c) * 4);
  if (fVar1 < (float10)_DAT_006ea50c != (NAN(fVar1) || NAN((float10)_DAT_006ea50c))) {
    fVar1 = (float10)_DAT_006ea50c;
  }
  return fVar1;
}

