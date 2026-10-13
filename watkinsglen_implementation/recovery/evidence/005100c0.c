/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005100c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_005100c0(uint param_1)

{
  if (param_1 < 0x14) {
    return (float10)(float)(&DAT_0074fb30)[param_1];
  }
  return (float10)_DAT_006e97d8;
}
