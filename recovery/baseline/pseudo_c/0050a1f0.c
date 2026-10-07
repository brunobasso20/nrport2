/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0050a1f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_0050a1f0(float param_1)

{
  float10 fVar1;
  
  if (param_1 < _DAT_006ed6c8) {
    return (float10)_DAT_00b8f920 * (float10)param_1 + (float10)_DAT_00b8fa58;
  }
  fVar1 = (float10)FUN_006c5c40();
  return fVar1;
}


