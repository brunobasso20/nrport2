/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052e0f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint __fastcall FUN_0052e0f0(int param_1)

{
  uint uVar1;
  int iVar2;
  uint uVar3;
  float fVar4;
  ushort uVar5;
  
  if (*(int *)(param_1 + 4) == 0) {
    return 1;
  }
  if (param_1 == DAT_00760b38) {
    return CONCAT31((int3)((uint)*(int *)(param_1 + 4) >> 8),1);
  }
  if (0 < *(int *)(param_1 + 0x1b1e)) {
    return CONCAT31((int3)((uint)*(int *)(param_1 + 0x1b1e) >> 8),1);
  }
  uVar3 = *(uint *)(param_1 + 0x1b1a);
  if ((int)uVar3 < 1) {
    iVar2 = *(int *)(param_1 + 0x5ae);
    if (iVar2 == 0) {
      iVar2 = *(int *)(param_1 + 0x1a76);
    }
    if (DAT_0074aff0 <= ABS(*(float *)(param_1 + 0x197e))) {
      fVar4 = *(float *)(param_1 + 0x1862);
      uVar3 = CONCAT22((short)((uint)ABS(*(float *)(param_1 + 0x197e)) >> 0x10),
                       (ushort)(fVar4 < _DAT_006ea61c) << 8 |
                       (ushort)(NAN(fVar4) || NAN(_DAT_006ea61c)) << 10 |
                       (ushort)(fVar4 == _DAT_006ea61c) << 0xe);
      if (fVar4 >= _DAT_006ea61c) goto LAB_0052e203;
    }
    fVar4 = ABS(*(float *)(param_1 + 0x18ae));
    uVar3 = CONCAT22((short)((uint)fVar4 >> 0x10),
                     (ushort)(fVar4 < DAT_0074b008) << 8 |
                     (ushort)(NAN(fVar4) || NAN(DAT_0074b008)) << 10 |
                     (ushort)(fVar4 == DAT_0074b008) << 0xe);
    if ((fVar4 < DAT_0074b008) &&
       (uVar1 = (uint)(*(float *)(iVar2 + 0x60) * *(float *)(iVar2 + 0x24) +
                       *(float *)(iVar2 + 0x6c) * *(float *)(iVar2 + 0x28) +
                       *(float *)(iVar2 + 0x78) * *(float *)(iVar2 + 0x2c) < DAT_0074b020),
       uVar3 = uVar1 << 8, uVar1 == 0)) {
      fVar4 = *(float *)(param_1 + 0x18b6);
      uVar5 = (ushort)(fVar4 < DAT_0074b038) << 8 | (ushort)(NAN(fVar4) || NAN(DAT_0074b038)) << 10
              | (ushort)(fVar4 == DAT_0074b038) << 0xe;
      uVar3 = (uint)uVar5;
      if (fVar4 < DAT_0074b038) {
        return CONCAT31((uint3)(byte)(uVar5 >> 8),1);
      }
    }
  }
LAB_0052e203:
  return uVar3 & 0xffffff00;
}


