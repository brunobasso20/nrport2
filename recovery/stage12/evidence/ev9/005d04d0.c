/* NR2003.exe @ 005d04d0 FUN_005d04d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005d04d0(int param_1)

{
  int *piVar1;
  float *pfVar2;
  float fVar3;
  int iVar4;
  bool bVar5;
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
  iVar4 = (&DAT_00f5d2d0)[param_1];
  iVar12 = (&DAT_00f5d460)[(&DAT_00f5d4a8)[param_1]];
  if (iVar4 < 0) {
LAB_005d0544:
    iVar9 = (&DAT_00f5d210)[param_1];
    if (0 < iVar9) {
LAB_005d0574:
      iVar9 = (&DAT_00f5d210)[param_1];
      bVar5 = iVar4 - iVar9 < 0x20;
      goto LAB_005d0585;
    }
    local_8 = 1;
    if ((&DAT_00f5d290)[param_1] != 0) {
      local_8 = (&DAT_00f5d290)[param_1];
    }
    fVar3 = (float)(iVar9 - iVar4) / (float)local_8;
  }
  else {
    iVar9 = (&DAT_00f5d210)[param_1];
    if (iVar9 < 0) {
      if (iVar4 < 1) goto LAB_005d0544;
      goto LAB_005d0574;
    }
    local_8 = 1;
    if ((&DAT_00f5d290)[param_1] != 0) {
      local_8 = (&DAT_00f5d290)[param_1];
    }
    fVar3 = (float)(iVar4 - iVar9) / (float)local_8;
  }
  if (fVar3 < _DAT_006e9824 == (NAN(fVar3) || NAN(_DAT_006e9824))) {
    bVar5 = false;
  }
  else {
    bVar5 = true;
  }
LAB_005d0585:
  if ((iVar12 == -1) || (bVar5)) {
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
    fVar3 = ((float)param_1 * (float)(&DAT_00f5d354)[iVar6] + (float)(&DAT_00f5d394)[iVar6]) *
            (float)param_1 + (float)(&DAT_00f5d3d4)[iVar6];
    *pfVar2 = fVar3;
    uVar13 = 1 << ((byte)iVar6 & 0x1f) & DAT_00f5d350;
    if ((uVar13 != 0) &&
       (uVar7 = iVar9 - (&DAT_00f5d290)[iVar6], uVar10 = (int)uVar7 >> 0x1f,
       uVar8 = iVar4 - (&DAT_00f5d290)[iVar6], uVar11 = (int)uVar8 >> 0x1f,
       (int)((uVar8 ^ uVar11) - uVar11) < (int)((uVar7 ^ uVar10) - uVar10))) {
      *pfVar2 = _DAT_006e97d8 - fVar3;
    }
    if (_DAT_006e97d8 < *pfVar2) {
      *pfVar2 = 1.0;
      return;
    }
    fVar3 = *pfVar2;
    if (uVar13 == 0) {
      if (fVar3 < _DAT_006ea4a8 != (NAN(fVar3) || NAN(_DAT_006ea4a8))) {
        *pfVar2 = -1.0;
        return;
      }
    }
    else if (fVar3 < _DAT_006ea454 != (NAN(fVar3) || NAN(_DAT_006ea454))) {
      *pfVar2 = 0.0;
      return;
    }
  }
  return;
}

