/* Ghidra pseudo-C; NR2003.exe @ 0057ce40 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0057ce40(float *param_1)

{
  float fVar1;
  
  fVar1 = *param_1;
  if (fVar1 < _DAT_006f4a48) {
    do {
      fVar1 = fVar1 + _DAT_006ee484;
    } while (fVar1 < _DAT_006f4a48);
    *param_1 = fVar1;
  }
  fVar1 = *param_1;
  if (fVar1 < _DAT_006f4a4c) {
    return;
  }
  do {
    fVar1 = fVar1 - _DAT_006ee484;
  } while (_DAT_006f4a4c <= fVar1);
  *param_1 = fVar1;
  return;
}

