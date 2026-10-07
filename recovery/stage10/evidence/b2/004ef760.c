/* NR2003.exe @ 004ef760 FUN_004ef760 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_004ef760(int param_1)

{
  if (param_1 < 0) {
    _DAT_00a6c250 = 0;
    return;
  }
  if (3 < param_1) {
    param_1 = 3;
  }
  _DAT_00a6c250 = param_1;
  return;
}

