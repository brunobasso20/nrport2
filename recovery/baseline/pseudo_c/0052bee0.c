/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052bee0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint __thiscall FUN_0052bee0(int param_1_00,int param_1)

{
  uint uVar1;
  
  uVar1 = 0;
  if (*(int *)(param_1 + 0x5ae) != 0) {
    uVar1 = *(uint *)(*(int *)(param_1 + 0x5ae) + 0x50);
    if ((*(uint *)(param_1_00 + 0x16ba) & 1 << ((byte)uVar1 & 0x1f)) != 0) {
      if (uVar1 == 1) {
        return 1;
      }
      if (((*(float *)(param_1_00 + 0x1886) < _DAT_006ea454) ||
          (*(float *)(param_1 + 0x1886) < _DAT_006ea454)) &&
         ((*(float *)(param_1_00 + 0x1886) < _DAT_006ea454 ==
           (*(float *)(param_1_00 + 0x1886) == _DAT_006ea454) ||
          (*(float *)(param_1 + 0x1886) < _DAT_006ea454 ==
           (*(float *)(param_1 + 0x1886) == _DAT_006ea454))))) {
        return 0;
      }
      return 1;
    }
  }
  return uVar1 & 0xffffff00;
}


