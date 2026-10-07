/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00403e70 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint FUN_00403e70(int param_1,int param_2)

{
  float fVar1;
  float fVar2;
  int iVar3;
  undefined4 uVar4;
  ushort uVar5;
  byte bVar11;
  int *piVar6;
  float fVar7;
  undefined4 *puVar8;
  undefined2 extraout_var;
  undefined2 uVar12;
  uint uVar9;
  undefined4 *puVar10;
  undefined1 *unaff_EBX;
  ushort uVar13;
  float10 fVar14;
  
  uVar9 = *(uint *)(param_2 + 0x5ae);
  if (*(int *)(uVar9 + 0x50) == 4) {
LAB_00403e87:
    return CONCAT31((int3)(uVar9 >> 8),1);
  }
  piVar6 = (int *)(**(code **)(**(int **)(param_1 + 0x13b3) + 0x4c))(param_1);
  fVar14 = (float10)(**(code **)(*piVar6 + 0x18))(param_1,*(undefined4 *)(param_2 + 0x186e),0,0);
  fVar7 = ABS((float)((float10)*(float *)(param_2 + 0x1886) - fVar14));
  fVar2 = *(float *)(*(int *)(param_1 + 0x21e8) + 8);
  if ((((*(int *)(*(int *)(param_1 + 0x5ae) + 0x50) == 4) ||
       (*(int *)(*(int *)(param_1 + 0x5ae) + 0x50) == 2)) ||
      (iVar3 = *(int *)(*(int *)(param_2 + 0x5ae) + 0x50), iVar3 == 4)) ||
     ((iVar3 == 2 || (*(float *)(param_1 + 0x1ca2) <= fVar2)))) {
    uVar4 = *(undefined4 *)(param_2 + 0x1397);
    puVar8 = (undefined4 *)FUN_00536280(uVar4);
    fVar14 = (float10)FUN_00516d3a(*(undefined4 *)(param_2 + 0x186a),*puVar8);
    if (fVar14 < (float10)_DAT_006ea458) {
      uVar12 = extraout_var;
      if (*(float *)(param_2 + 0x1872) + _DAT_006ea450 < *(float *)(param_1 + 0x1872)) {
        fVar1 = *(float *)(param_1 + 0x1ca2);
        uVar12 = 0;
        if (fVar1 >= fVar2 && fVar1 != fVar2) {
          return CONCAT31((uint3)(fVar1 < fVar2),1);
        }
      }
      fVar1 = *(float *)(param_2 + 0x1872);
      uVar9 = CONCAT22(uVar12,(ushort)(fVar1 < _DAT_006ea450) << 8 |
                              (ushort)(NAN(fVar1) || NAN(_DAT_006ea450)) << 10 |
                              (ushort)(fVar1 == _DAT_006ea450) << 0xe);
      if (fVar1 < _DAT_006ea450) {
        return CONCAT31((int3)(uVar9 >> 8),1);
      }
      if (unaff_EBX == (undefined1 *)0x0) {
        return uVar9;
      }
      fVar1 = *(float *)(param_2 + 0x18f2);
      if (fVar7 < fVar1 || (fVar7 == fVar1) != 0) {
        return (uint)(ushort)((ushort)(fVar7 < fVar1) << 8 | (ushort)(fVar7 == fVar1) << 0xe);
      }
      fVar7 = *(float *)(param_1 + 0x1ca2);
      uVar9 = (uint)(ushort)((ushort)(fVar7 < fVar2) << 8 | (ushort)(NAN(fVar7) || NAN(fVar2)) << 10
                            | (ushort)(fVar7 == fVar2) << 0xe);
      if (fVar7 < fVar2 == (fVar7 == fVar2)) {
        return uVar9;
      }
      *unaff_EBX = 1;
      return uVar9;
    }
    if (*(float *)(param_2 + 0x18f2) < fVar7) {
      fVar7 = *(float *)(param_1 + 0x1ca2);
      uVar9 = (uint)(ushort)((ushort)(fVar7 < fVar2) << 8 | (ushort)(NAN(fVar7) || NAN(fVar2)) << 10
                            | (ushort)(fVar7 == fVar2) << 0xe);
      if (fVar7 < fVar2 != (fVar7 == fVar2)) {
        puVar8 = (undefined4 *)FUN_00536280(uVar4);
        puVar10 = (undefined4 *)FUN_00536280(*(undefined4 *)(param_1 + 0x1397));
        fVar14 = (float10)FUN_00516d3a(*puVar10,*puVar8);
        uVar13 = (ushort)(fVar14 < (float10)_DAT_006ea454);
        uVar5 = (ushort)(fVar14 == (float10)_DAT_006ea454);
        uVar9 = (uint)(ushort)(uVar13 << 8 | uVar5 << 0xe);
        if (uVar13 == 0 && uVar5 == 0) {
          if (unaff_EBX == (undefined1 *)0x0) {
            return 0;
          }
          *unaff_EBX = 1;
          return (uint)unaff_EBX & 0xffffff00;
        }
      }
      goto LAB_00403e87;
    }
    if (((*(float *)(param_1 + 0x1872) < _DAT_0074b080 * _DAT_006e9810 + _DAT_006ea450) &&
        (*(float *)(param_2 + 0x1872) + _DAT_006ea450 < *(float *)(param_1 + 0x1872))) &&
       (fVar7 = *(float *)(param_1 + 0x1ca2), fVar7 >= fVar2 && fVar7 != fVar2)) {
      return CONCAT31((uint3)(fVar7 < fVar2),1);
    }
    fVar2 = *(float *)(param_2 + 0x1872);
    uVar13 = (ushort)(fVar2 < _DAT_006ea450) << 8 | (ushort)(NAN(fVar2) || NAN(_DAT_006ea450)) << 10
             | (ushort)(fVar2 == _DAT_006ea450) << 0xe;
  }
  else {
    fVar2 = *(float *)(param_2 + 0x1872);
    uVar13 = (ushort)(fVar2 < _DAT_006ea45c) << 8 | (ushort)(NAN(fVar2) || NAN(_DAT_006ea45c)) << 10
             | (ushort)(fVar2 == _DAT_006ea45c) << 0xe;
  }
  bVar11 = (byte)(uVar13 >> 8);
  if ((POPCOUNT(bVar11 & 5) & 1U) == 0) {
    return (uint)uVar13;
  }
  return CONCAT31((uint3)bVar11,1);
}


