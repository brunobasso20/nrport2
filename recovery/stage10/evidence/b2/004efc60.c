/* NR2003.exe @ 004efc60 FUN_004efc60 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_004efc60(int param_1)

{
  if (param_1 < 0) {
    DAT_00a6c1f8 = 0;
    _DAT_00a6c254 = 0;
    return;
  }
  if (0x40 < param_1) {
    param_1 = 0x40;
  }
  _DAT_00a6c254 = param_1;
  DAT_00a6c1f8 = 0;
  return;
}

