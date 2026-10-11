/* NR2003.exe @ 00548960 FUN_00548960 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_00548960(int param_1)

{
  return (float10)((*(ushort *)(param_1 + 2) & 0x3000) >> 0xc) * (float10)_DAT_006f49d0;
}

