/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056e7b0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint FUN_0056e7b0(int param_1,int param_2)

{
  float fVar1;
  uint uVar2;
  undefined2 uVar3;
  
  uVar2 = *(int *)(param_1 + 0x67) - 1;
  if (param_2 < (int)uVar2) {
    fVar1 = *(float *)(param_1 + 0x6f + param_2 * 8);
    uVar3 = (undefined2)(uVar2 >> 0x10);
    uVar2 = CONCAT22(uVar3,(ushort)(fVar1 < _DAT_006ea454) << 8 |
                           (ushort)(NAN(fVar1) || NAN(_DAT_006ea454)) << 10 |
                           (ushort)(fVar1 == _DAT_006ea454) << 0xe);
    if (((fVar1 != _DAT_006ea454) || (*(short *)(param_1 + 0x6d + param_2 * 8) != 0x7fff)) &&
       ((*(int *)(param_1 + 0x6f + param_2 * 8) != 0x4913a800 ||
        (*(short *)(param_1 + 0x6d + param_2 * 8) != 0)))) {
      fVar1 = *(float *)(param_1 + 0x6f + param_2 * 8);
      uVar2 = CONCAT22(uVar3,(ushort)(fVar1 < _DAT_006ea454) << 8 |
                             (ushort)(NAN(fVar1) || NAN(_DAT_006ea454)) << 10 |
                             (ushort)(fVar1 == _DAT_006ea454) << 0xe);
      if ((fVar1 != _DAT_006ea454) || (*(short *)(param_1 + 0x6d + param_2 * 8) != 0))
      goto LAB_0056e808;
    }
    return CONCAT31((int3)(uVar2 >> 8),1);
  }
LAB_0056e808:
  return uVar2 & 0xffffff00;
}


