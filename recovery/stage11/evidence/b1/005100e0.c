/* NR2003.exe @ 005100e0 FUN_005100e0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_005100e0(uint param_1)

{
  if (param_1 < 0x14) {
    return (float10)*(float *)(&DAT_006f65c0 + param_1 * 4);
  }
  return (float10)_DAT_006ea454;
}

