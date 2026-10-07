/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005859a0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint FUN_005859a0(int param_1,float param_2)

{
  float fVar1;
  float fVar2;
  float fVar3;
  int iVar4;
  undefined4 uVar5;
  uint uVar6;
  float *pfVar7;
  
  iVar4 = FUN_006c5018();
  if (*(int *)(param_1 + 0x8c) <= iVar4) {
    pfVar7 = (float *)(param_1 + 0x1c);
    iVar4 = 3;
    *(float *)(param_1 + 0x10) = *(float *)(param_1 + 0x10) * _DAT_006f6934;
    *(float *)(param_1 + 0x14) = *(float *)(param_1 + 0x14) * _DAT_006f6934;
    *(float *)(param_1 + 0x18) = *(float *)(param_1 + 0x18) * _DAT_006f6934;
    *(float *)(param_1 + 0x28) = *(float *)(param_1 + 0x28) * _DAT_006f6930;
    *(float *)(param_1 + 0x2c) = *(float *)(param_1 + 0x2c) * _DAT_006f6930;
    *(float *)(param_1 + 0x30) = *(float *)(param_1 + 0x30) * _DAT_006f6930;
    do {
      fVar1 = param_2 * pfVar7[3] + *pfVar7;
      *pfVar7 = fVar1;
      if (_DAT_006f5e58 < fVar1) {
        do {
          fVar1 = fVar1 - _DAT_006f5e58;
        } while (_DAT_006f5e58 < fVar1);
        *pfVar7 = fVar1;
      }
      fVar1 = *pfVar7;
      if (fVar1 < _DAT_006ea454) {
        do {
          fVar1 = fVar1 + _DAT_006f5e58;
        } while (fVar1 < _DAT_006ea454);
        *pfVar7 = fVar1;
      }
      pfVar7 = pfVar7 + 1;
      iVar4 = iVar4 + -1;
    } while (iVar4 != 0);
    pfVar7 = (float *)(param_1 + 4);
    *pfVar7 = param_2 * *(float *)(param_1 + 0x10) + *pfVar7;
    *(float *)(param_1 + 8) = param_2 * *(float *)(param_1 + 0x14) + *(float *)(param_1 + 8);
    *(float *)(param_1 + 0xc) = param_2 * *(float *)(param_1 + 0x18) + *(float *)(param_1 + 0xc);
    FUN_005f58d0(param_1 + 0x34,pfVar7);
    if ((*(int *)(param_1 + 0x80) != 0) &&
       (uVar5 = FUN_005163fa(param_1 + 0x34), (char)uVar5 != '\0')) {
      fVar3 = *(float *)(param_1 + 0x18) - param_2 * _DAT_006f6920;
      *(float *)(param_1 + 0x18) = fVar3;
      fVar1 = *(float *)(param_1 + 0xc);
      fVar2 = *(float *)(param_1 + 100);
      uVar5 = CONCAT22((short)((uint)uVar5 >> 0x10),
                       (ushort)(fVar1 < fVar2) << 8 | (ushort)(NAN(fVar1) || NAN(fVar2)) << 10 |
                       (ushort)(fVar1 == fVar2) << 0xe);
      if (fVar1 < fVar2) {
        fVar1 = *(float *)(param_1 + 0x10) * _DAT_006f4110;
        *(undefined4 *)(param_1 + 0x28) = 0;
        *(undefined4 *)(param_1 + 0xc) = *(undefined4 *)(param_1 + 100);
        *(undefined4 *)(param_1 + 0x2c) = 0;
        *(undefined4 *)(param_1 + 0x30) = 0;
        *(float *)(param_1 + 0x10) = fVar1;
        *(float *)(param_1 + 0x14) = *(float *)(param_1 + 0x14) * _DAT_006f4110;
        fVar1 = fVar3 * _DAT_006f664c - _DAT_006ef640;
        *(float *)(param_1 + 0x18) = fVar1;
        uVar5 = CONCAT22((short)((uint)*(undefined4 *)(param_1 + 100) >> 0x10),
                         (ushort)(fVar1 < _DAT_006ea454) << 8 |
                         (ushort)(NAN(fVar1) || NAN(_DAT_006ea454)) << 10 |
                         (ushort)(fVar1 == _DAT_006ea454) << 0xe);
        if (fVar1 < _DAT_006ea454) {
          *(undefined4 *)(param_1 + 0x18) = 0;
          return CONCAT31((int3)((uint)uVar5 >> 8),1);
        }
      }
      return CONCAT31((int3)((uint)uVar5 >> 8),1);
    }
  }
  uVar6 = FUN_00585970(param_1);
  return uVar6 & 0xffffff00;
}


