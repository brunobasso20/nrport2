/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00516f1a */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_00516f1a(int param_1)

{
  if (*(int *)(param_1 * 0x1550 + DAT_00bcf734) == 2) {
    return (float10)*(float *)(param_1 * 0x1550 + DAT_00bcf734 + 0x44);
  }
  return (float10)_DAT_006ea454;
}


