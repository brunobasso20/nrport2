/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005550c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_005550c0(void)

{
  ushort uVar1;
  float10 fVar2;
  
  if (ABS((float10)_DAT_00bf6d88) < (float10)_DAT_006e9808) {
    uVar1 = (ushort)(ABS(_DAT_00bf6db8) < (float)_DAT_006ed050) << 8 |
            (ushort)(ABS(_DAT_00bf6db8) == (float)_DAT_006ed050) << 0xe;
  }
  else {
    fVar2 = (float10)fpatan(ABS((float10)_DAT_00bf6d88 - (float10)_DAT_00bf6db8),
                            ABS((float10)_DAT_00bf6d88));
    uVar1 = (ushort)(fVar2 < (float10)_DAT_006ef7f8) << 8 |
            (ushort)(fVar2 == (float10)_DAT_006ef7f8) << 0xe;
  }
  if (uVar1 == 0) {
    return 1;
  }
  return 0;
}


