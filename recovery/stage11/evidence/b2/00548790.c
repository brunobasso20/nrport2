/* NR2003.exe @ 00548790 FUN_00548790 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_00548790(int param_1)

{
  if ((*(byte *)(param_1 + 0xf) & 1) != 0) {
    return (float10)(uint)(*(ushort *)(param_1 + 2) >> 0xe) * (float10)_DAT_006f49d0;
  }
  return (float10)_DAT_006ea454;
}

