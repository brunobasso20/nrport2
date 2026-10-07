/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004febe0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 __thiscall FUN_004febe0(int param_1_00,int param_1)

{
  if ((-1 < param_1) && (param_1 < 0xf)) {
    return (float10)*(float *)(param_1_00 + 0x11d + param_1 * 4);
  }
  return (float10)_DAT_006e97d8;
}


