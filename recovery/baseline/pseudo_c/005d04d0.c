/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005d04d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005d04d0(int param_1)

{
  int *piVar1;
  float *pfVar2;
  int iVar3;
  bool bVar4;
  float fVar5;
  int iVar6;
  uint uVar7;
  uint uVar8;
  int iVar9;
  uint uVar10;
  uint uVar11;
  int iVar12;
  uint uVar13;
  int local_8;
  
  iVar6 = param_1;
  iVar3 = (&DAT_00f5d2d0)[param_1];
  iVar12 = (&DAT_00f5d460)[(&DAT_00f5d4a8)[param_1]];
  if (iVar3 < 0) {
LAB_005d0544:
    iVar9 = (&DAT_00f5d210)[param_1];
    if (0 < iVar9) {
LAB_005d0574:
      iVar9 = (&DAT_00f5d210)[param_1];
      bVar4 = iVar3 - iVar9 < 0x20;
      goto LAB_005d0585;
    }
    local_8 = 1;
    if ((&DAT_00f5d290)[param_1] != 0) {
      local_8 = (&DAT_00f5d290)[param_1];
    }
    fVar5 = (float)(iVar9 - iVar3) / (float)local_8;
  }
  else {
    iVar9 = (&DAT_00f5d210)[param_1];
    if (iVar9 < 0) {
      if (iVar3 < 1) goto LAB_005d0544;
      goto LAB_005d0574;
    }
    local_8 = 1;
    if ((&DAT_00f5d290)[param_1] != 0) {
      local_8 = (&DAT_00f5d290)[param_1];
    }
    fVar5 = (float)(iVar3 - iVar9) / (float)local_8;
  }
  if (_DAT_006e9824 <= fVar5) {
    bVar4 = false;
  }
  else {
    bVar4 = true;
  }
LAB_005d0585:
  if ((iVar12 == -1) || (bVar4)) {
    (&DAT_00f5d418)[param_1] = 0;
  }
  else {
    if (iVar12 < (int)(&DAT_00f5d250)[param_1]) {
      iVar12 = (&DAT_00f5d250)[param_1];
    }
    piVar1 = &DAT_00f5d310 + param_1;
    param_1 = iVar12;
    if (*piVar1 < iVar12) {
      param_1 = *piVar1;
    }
    pfVar2 = (float *)(&DAT_00f5d418 + iVar6);
    fVar5 = ((float)param_1 * (float)(&DAT_00f5d354)[iVar6] + (float)(&DAT_00f5d394)[iVar6]) *
            (float)param_1 + (float)(&DAT_00f5d3d4)[iVar6];
    *pfVar2 = fVar5;
    uVar13 = 1 << ((byte)iVar6 & 0x1f) & DAT_00f5d350;
    if ((uVar13 != 0) &&
       (uVar7 = iVar9 - (&DAT_00f5d290)[iVar6], uVar10 = (int)uVar7 >> 0x1f,
       uVar8 = iVar3 - (&DAT_00f5d290)[iVar6], uVar11 = (int)uVar8 >> 0x1f,
       (int)((uVar8 ^ uVar11) - uVar11) < (int)((uVar7 ^ uVar10) - uVar10))) {
      *pfVar2 = _DAT_006e97d8 - fVar5;
    }
    if (_DAT_006e97d8 < *pfVar2) {
      *pfVar2 = 1.0;
      return;
    }
    if (uVar13 == 0) {
      if (*pfVar2 < _DAT_006ea4a8) {
        *pfVar2 = -1.0;
        return;
      }
    }
    else if (*pfVar2 < _DAT_006ea454) {
      *pfVar2 = 0.0;
      return;
    }
  }
  return;
}


