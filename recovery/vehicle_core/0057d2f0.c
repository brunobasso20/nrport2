/* Ghidra pseudo-C; NR2003.exe @ 0057d2f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void recovered_0057d2f0(undefined4 *param_1,undefined4 *param_2,undefined4 *param_3)

{
  float *pfVar1;
  
  *(float *)*param_1 = *(float *)*param_2 + *(float *)*param_3;
  pfVar1 = (float *)*param_1;
  if (*pfVar1 < _DAT_006f4a48) {
    do {
      *pfVar1 = *pfVar1 + _DAT_006ee484;
      pfVar1 = (float *)*param_1;
    } while (*pfVar1 < _DAT_006f4a48);
  }
  if (_DAT_006f4a4c <= *pfVar1) {
    do {
      *pfVar1 = *pfVar1 - _DAT_006ee484;
      pfVar1 = (float *)*param_1;
    } while (_DAT_006f4a4c <= *pfVar1);
  }
  return;
}

