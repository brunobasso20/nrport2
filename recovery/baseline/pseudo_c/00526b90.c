/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00526b90 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __thiscall FUN_00526b90(int param_1,int param_2,int param_3,int param_4)

{
  int *piVar1;
  uint *puVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  uint uVar7;
  int iVar8;
  int iVar9;
  int iVar10;
  undefined2 *puVar11;
  int iVar12;
  float *pfVar13;
  int iVar14;
  float *pfVar15;
  undefined2 *puVar16;
  float *pfVar17;
  float10 fVar18;
  uint uStack_28;
  undefined2 *puStack_24;
  uint uStack_20;
  int iStack_1c;
  undefined2 *puStack_18;
  int local_14;
  int iStack_10;
  int iStack_c;
  int iStack_8;
  int iStack_4;
  
  piVar1 = (int *)(param_1 + 0x18);
  if (*(int *)(param_1 + 0x18) != 0) {
    FUN_00526b70();
  }
  iVar9 = FUN_005cfce4(piVar1,((int)DAT_00b8faa0 + 3) * 0x40);
  if (iVar9 == 0) {
    return 0;
  }
  *(int *)(param_1 + 0xc) = param_2;
  pfVar17 = (float *)(param_3 + 0x14);
  *(int *)(param_1 + 0x10) = param_3;
  *(int *)(param_1 + 0x14) = param_4;
  puStack_18 = (undefined2 *)(*pfVar17 - *(float *)(param_4 + 0x14));
  if ((float)puStack_18 < _DAT_006e97d8 != ((float)puStack_18 == _DAT_006e97d8)) {
    puStack_18 = (undefined2 *)0x3f800000;
  }
  uStack_28 = 0;
  if (DAT_00b8faa0 != (undefined2 *)0xfffffffe && -1 < (int)(DAT_00b8faa0 + 1)) {
    pfVar15 = (float *)(param_4 + 8);
    iVar9 = 0;
    pfVar13 = (float *)(param_2 + 0xc);
    do {
      fVar3 = *pfVar17 - *(float *)((param_4 - param_3) + (int)pfVar17);
      if (fVar3 < _DAT_006e97d8 != (fVar3 == _DAT_006e97d8)) {
        fVar3 = _DAT_006e97d8;
      }
      *(float *)(iVar9 + *piVar1) = fVar3;
      fVar4 = _DAT_006e97d8 / fVar3;
      fVar6 = -fVar4;
      *(float *)(iVar9 + 4 + *piVar1) =
           (*(float *)((param_2 - param_3) + (int)pfVar17) -
           *(float *)((param_4 - param_3) + (int)pfVar17)) * fVar6;
      if (_DAT_006f50e4 < *(float *)(iVar9 + 4 + *piVar1)) {
        *(undefined4 *)(iVar9 + 4 + *piVar1) = 0xbba3d70a;
      }
      *(float *)(*piVar1 + iVar9 + 8) = _DAT_006e97d8 / *(float *)(*piVar1 + 4 + iVar9);
      *(float *)(iVar9 + 0xc + *piVar1) =
           (*pfVar17 - *(float *)((param_2 - param_3) + (int)pfVar17)) * fVar4;
      if (*(float *)(iVar9 + 0xc + *piVar1) < _DAT_006eebb8) {
        *(undefined4 *)(iVar9 + 0xc + *piVar1) = 0x3ba3d70a;
      }
      *(float *)(*piVar1 + iVar9 + 0x10) = _DAT_006e97d8 / *(float *)(*piVar1 + 0xc + iVar9);
      fVar5 = (fVar3 - (float)puStack_18) / _DAT_006f4a98;
      if (_DAT_006ea454 < fVar5) {
        fVar5 = _DAT_006ea454;
      }
      fVar5 = _DAT_0074b2f0 * fVar5;
      *(float *)(*piVar1 + iVar9 + 0x14) =
           (*(float *)(*piVar1 + iVar9 + 4) * fVar5 +
           (*pfVar13 - *(float *)((int)pfVar13 + (param_4 - param_2)))) * fVar6;
      *(float *)(*piVar1 + iVar9 + 0x18) =
           ((pfVar17[-2] - *pfVar13) - *(float *)(*piVar1 + 0xc + iVar9) * fVar5) * fVar4;
      *(float *)(iVar9 + 0x1c + *piVar1) = (pfVar13[1] - pfVar15[2]) * fVar6;
      *(float *)(iVar9 + 0x20 + *piVar1) = (pfVar17[-1] - pfVar13[1]) * fVar4;
      *(float *)(iVar9 + 0x24 + *piVar1) = (pfVar13[-1] * pfVar13[-1] - *pfVar15 * *pfVar15) * fVar6
      ;
      *(float *)(iVar9 + 0x28 + *piVar1) =
           (pfVar17[-3] * pfVar17[-3] - pfVar13[-1] * pfVar13[-1]) * fVar4;
      *(undefined4 *)(iVar9 + 0x3c + *piVar1) = 0;
      *(uint *)(iVar9 + 0x34 + *piVar1) = *(uint *)(iVar9 + 0x34 + *piVar1) | 0xffff;
      *(undefined2 *)(iVar9 + 0x36 + *piVar1) = 0xffff;
      puVar2 = (uint *)(iVar9 + 0x38 + *piVar1);
      *puVar2 = *puVar2 | 0xffff;
      *(undefined2 *)(iVar9 + 0x3a + *piVar1) = 0xffff;
      uStack_28 = uStack_28 + 1;
      pfVar15 = pfVar15 + 7;
      pfVar17 = pfVar17 + 7;
      pfVar13 = pfVar13 + 7;
      iVar9 = iVar9 + 0x40;
      puStack_18 = (undefined2 *)fVar3;
    } while ((int)uStack_28 < (int)(DAT_00b8faa0 + 1));
  }
  iVar9 = 0;
  uStack_28 = 0;
  if (0 < (int)(DAT_00b8faa0 + 1)) {
    iStack_c = 0;
    do {
      fVar3 = *(float *)(iVar9 + 0x18 + *(int *)(param_1 + 0xc));
      fVar4 = _DAT_006f4aa8 * fVar3;
      fVar18 = (float10)FUN_0051700a((float)(int)uStack_28 * _DAT_006f4a98 + fVar4);
      fVar6 = *(float *)(*(int *)(param_1 + 0xc) +
                        ((int)ROUND((float)((float10)_DAT_00bd7914 * fVar18)) + 1) * 0x1c) -
              *(float *)(iVar9 + 0x1c + *(int *)(param_1 + 0xc));
      if (fVar6 < _DAT_006ea454) {
        fVar6 = fVar6 + *(float *)(*(int *)(param_1 + 0xc) + (int)DAT_00b8faa0 * 0x1c);
      }
      *(float *)(iStack_c + 0x30 + *piVar1) =
           ((fVar4 / fVar6 - fVar3) / _DAT_006f4aa8) * _DAT_006e9804;
      iVar12 = *piVar1 + iStack_c;
      fVar3 = (_DAT_0074b2c0 * _DAT_006e9818 - *(float *)(iVar12 + 0x30)) /
              (_DAT_0074b2c0 * _DAT_006e9818);
      if (fVar3 < _DAT_006e97d8) {
        fVar3 = _DAT_006e97d8;
      }
      iStack_c = iStack_c + 0x40;
      uStack_28 = uStack_28 + 1;
      iVar9 = iVar9 + 0x1c;
      *(float *)(iVar12 + 0x2c) =
           (_DAT_0074b290 * _DAT_006ea448 - _DAT_006ea448) * fVar3 + _DAT_006ea448;
    } while ((int)uStack_28 < (int)(DAT_00b8faa0 + 1));
  }
  uStack_20 = 0xffffffff;
  puStack_24 = (undefined2 *)0xffffffff;
  uStack_28 = 0xffffffff;
  puStack_18 = (undefined2 *)0xffffffff;
  iStack_c = -1;
  iStack_8 = -1;
  iStack_4 = -1;
  iStack_1c = 0;
  iStack_10 = -1;
  puVar16 = DAT_00b8faa0 + 1;
  puVar11 = DAT_00b8faa0;
  iVar9 = -1;
  if (-1 < (int)puVar16) {
    local_14 = (int)DAT_00b8faa0 + 3;
    iVar12 = (int)puVar16 * 0x40;
    do {
      iVar14 = (int)puVar16 % (int)DAT_00b8faa0;
      iVar9 = iVar14 * 0x1c;
      if ((*(float *)(iVar9 + 0x10 + param_2) <= (float)_DAT_006f4138) ||
         (*(float *)(iVar9 + 0x14 + param_2) + _DAT_006f50e0 <= *(float *)(iVar9 + 0x14 + param_3)))
      {
        if ((*(float *)(iVar9 + 0x10 + param_2) < (float)_DAT_006f50d8) &&
           (*(float *)(iVar9 + 0x14 + param_2) - _DAT_006f50e0 < *(float *)(iVar9 + 0x14 + param_4))
           ) {
          uStack_20 = 2;
          goto LAB_00527058;
        }
      }
      else {
        uStack_20 = 1;
LAB_00527058:
        if ((int)puStack_24 < 0) {
          puStack_24 = puVar16;
        }
      }
      if ((float)_DAT_006f50d0 <=
          *(float *)(param_2 + 0x18 + (local_14 % (int)DAT_00b8faa0) * 0x1c) -
          *(float *)(iVar9 + 0x18 + param_2)) {
        uStack_28 = 0;
      }
      else {
        uStack_28 = 4;
        iStack_1c = 5;
        if ((int)puStack_18 < 0) {
          puStack_18 = puVar16;
        }
      }
      iVar10 = iStack_1c + -1;
      if ((0 < iStack_1c) && (uStack_28 == 0)) {
        uStack_28 = 4;
      }
      iVar8 = iVar14;
      if (*(float *)(iVar9 + 0x14 + param_3) < *(float *)(iVar9 + 0x14 + param_2) + _DAT_006f50e0) {
        iStack_c = iVar14;
        iVar8 = iStack_4;
      }
      iStack_4 = iVar8;
      iVar8 = iVar14;
      if (*(float *)(iVar9 + 0x14 + param_2) - _DAT_006f50e0 < *(float *)(iVar9 + 0x14 + param_4)) {
        iVar8 = iStack_10;
        iStack_8 = iVar14;
      }
      iStack_10 = iVar8;
      if (-1 < (int)puStack_24) {
        *(uint *)(iVar12 + 0x3c + *piVar1) =
             *(uint *)(iVar12 + 0x3c + *piVar1) & 0xfffffffc | uStack_20;
      }
      if (-1 < (int)puStack_18) {
        *(uint *)(iVar12 + 0x3c + *piVar1) =
             *(uint *)(iVar12 + 0x3c + *piVar1) & 0xfffffffb | uStack_28;
      }
      puVar16 = (undefined2 *)((int)puVar16 + -1);
      *(undefined2 *)(iVar12 + 0x34 + *piVar1) = (undefined2)iStack_c;
      *(undefined2 *)(iVar12 + 0x36 + *piVar1) = (undefined2)iStack_8;
      iVar9 = *piVar1;
      *(undefined2 *)(iVar12 + 0x38 + iVar9) = (undefined2)iStack_4;
      puVar11 = (undefined2 *)CONCAT22((short)((uint)iVar9 >> 0x10),(undefined2)iStack_10);
      *(undefined2 *)(iVar12 + 0x3a + *piVar1) = (undefined2)iStack_10;
      local_14 = local_14 + -1;
      iVar12 = iVar12 + -0x40;
      iVar9 = iStack_10;
      iStack_1c = iVar10;
    } while (-1 < (int)puVar16);
  }
  puVar16 = DAT_00b8faa0 + 1;
  if (-1 < (int)puVar16) {
    iVar12 = (int)puVar16 * 0x40;
    do {
      uVar7 = uStack_28;
      if ((int)puStack_24 < (int)puVar16) {
        *(uint *)(iVar12 + 0x3c + *piVar1) =
             *(uint *)(iVar12 + 0x3c + *piVar1) & 0xfffffffc | uStack_20;
      }
      if ((iStack_1c < 1) || (uStack_28 = 4, uVar7 != 0)) {
        uStack_28 = 0;
      }
      if ((int)puStack_18 < (int)puVar16) {
        *(uint *)(iVar12 + 0x3c + *piVar1) =
             *(uint *)(iVar12 + 0x3c + *piVar1) & 0xfffffffb | uStack_28;
      }
      if (iStack_c < 0) {
        *(short *)(iVar12 + 0x34 + *piVar1) =
             (short)((((int)DAT_00b8faa0 >> 1) + (int)puVar16) % (int)DAT_00b8faa0);
      }
      else if (*(short *)(iVar12 + 0x34 + *piVar1) < 0) {
        *(short *)(iVar12 + 0x34 + *piVar1) = (short)iStack_c;
      }
      if (iStack_8 < 0) {
        *(short *)(iVar12 + 0x36 + *piVar1) =
             (short)((((int)DAT_00b8faa0 >> 1) + (int)puVar16) % (int)DAT_00b8faa0);
      }
      else if (*(short *)(iVar12 + 0x36 + *piVar1) < 0) {
        *(short *)(iVar12 + 0x36 + *piVar1) = (short)iStack_8;
      }
      if (iStack_4 < 0) {
        *(short *)(iVar12 + 0x38 + *piVar1) =
             (short)((((int)DAT_00b8faa0 >> 1) + (int)puVar16) % (int)DAT_00b8faa0);
      }
      else if (*(short *)(iVar12 + 0x38 + *piVar1) < 0) {
        *(short *)(iVar12 + 0x38 + *piVar1) = (short)iStack_4;
      }
      if (iVar9 < 0) {
        puVar11 = (undefined2 *)*piVar1;
        *(short *)(iVar12 + 0x3a + (int)puVar11) =
             (short)((((int)DAT_00b8faa0 >> 1) + (int)puVar16) % (int)DAT_00b8faa0);
      }
      else {
        puVar11 = (undefined2 *)(iVar12 + 0x3a + *piVar1);
        if (*(short *)(iVar12 + 0x3a + *piVar1) < 0) {
          *puVar11 = (short)iVar9;
        }
      }
      puVar16 = (undefined2 *)((int)puVar16 + -1);
      iVar12 = iVar12 + -0x40;
      iStack_1c = iStack_1c + -1;
    } while (-1 < (int)puVar16);
  }
  return CONCAT31((int3)((uint)puVar11 >> 8),1);
}


