/* NR2003.exe @ 0043f0c0 FUN_0043f0c0 */

void FUN_0043f0c0(int param_1)

{
  if (param_1 < 0) {
    DAT_0072c5f0 = 0;
    return;
  }
  if (100 < param_1) {
    param_1 = 100;
  }
  DAT_0072c5f0 = param_1;
  return;
}

