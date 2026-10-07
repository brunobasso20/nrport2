/* NR2003.exe @ 0052c640 FUN_0052c640 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0052c640(void)

{
  uint **ppuVar1;
  int iVar2;
  uint uVar3;
  uint uVar4;
  float fVar5;
  float fVar6;
  char cVar7;
  int iVar8;
  int iVar9;
  undefined4 uVar10;
  int *piVar11;
  int *piVar12;
  double *pdVar13;
  uint *puVar14;
  uint uVar15;
  int iVar16;
  uint *puVar17;
  float10 fVar18;
  float10 fVar19;
  float10 fVar20;
  byte *pbVar21;
  byte local_3e;
  char local_3d;
  int local_3c;
  float local_38;
  float local_34;
  float local_30;
  float local_2c;
  int iStack_28;
  undefined4 uStack_24;
  double dStack_20;
  float fStack_14;
  float fStack_c;
  
  if (DAT_00bd79b8 == '\0') {
    FUN_0052c120();
    DAT_00bd79b8 = '\x01';
  }
  local_3d = '\0';
  if (((DAT_00bdaa28 == '\0') || (iVar8 = FUN_005099b0(), iVar8 != 7)) ||
     (iVar8 = FUN_00538ab0(), *(char *)(iVar8 + 0x10327) != '\0')) goto LAB_0052c9a5;
  iVar8 = FUN_00538ac0();
  iVar8 = *(int *)(iVar8 + 0x30);
  if (iVar8 < 0) goto LAB_0052c9a5;
  iVar16 = DAT_00bdaa2c + 1;
  DAT_00bdaa2c = iVar16;
  iVar9 = FUN_006c5018();
  if (iVar16 < iVar9) goto LAB_0052c9a5;
  DAT_00bdaa2c = 0;
  local_3d = '\x01';
  iVar9 = FUN_004f5970(iVar8);
  uVar10 = FUN_0055ab00();
  iVar16 = FUN_004f5970(uVar10);
  uVar10 = FUN_0055ab00();
  pbVar21 = &local_3e;
  FUN_00538ae0(pbVar21,uVar10);
  FUN_0053d5f0(pbVar21,uVar10);
  if ((((((local_3e & 3) != 0) || (*(int *)(iVar16 + 4) == 0)) ||
       ((*(int *)(iVar16 + 0x5ae) == 0 ||
        ((iVar2 = *(int *)(*(int *)(iVar16 + 0x5ae) + 0x50), iVar2 == 2 || (iVar2 == 4)))))) ||
      (*(int *)(iVar9 + 4) == 0)) ||
     (((*(int *)(iVar9 + 0x5ae) == 0 ||
       (iVar2 = *(int *)(*(int *)(iVar9 + 0x5ae) + 0x50), iVar2 == 2)) || (iVar2 == 4)))) {
    _DAT_00bdaa34 = 0.0;
  }
  local_38 = *(float *)(*(int *)PTR_DAT_00749378 +
                       ((int)ROUND(*(float *)(iVar16 + 0x186a) * _DAT_00bd79d0) + 1) * 0x1c);
  local_30 = *(float *)(iVar9 + 0x186a) * _DAT_00bd79d0;
  local_34 = (float)(int)ROUND(local_30);
  local_2c = *(float *)(*(int *)PTR_DAT_00749378 + ((int)local_34 + 1) * 0x1c);
  piVar11 = (int *)FUN_00538ab0();
  piVar12 = (int *)FUN_00538ab0();
  local_34 = *(float *)(*(int *)PTR_DAT_00749378 + DAT_00b8faa0 * 0x1c);
  uVar10 = FUN_0055ab00();
  (**(code **)(*piVar11 + 0x30))(uVar10);
  iVar9 = FUN_005443c0(uVar10);
  (**(code **)(*piVar12 + 0x30))(iVar8);
  iVar8 = FUN_005443c0(iVar8);
  fVar19 = ((float10)local_38 - (float10)local_2c) + (float10)(iVar9 - iVar8) * (float10)local_34;
  fVar18 = (fVar19 - (float10)_DAT_00bdaa30) / (float10)_DAT_0074b650;
  fVar5 = _DAT_0074b6b0;
  if ((float10)_DAT_006ea454 < fVar19) {
    fVar5 = _DAT_0074b6c8;
  }
  fVar6 = _DAT_0074b6f8;
  if ((float10)_DAT_006ea454 < fVar18) {
    fVar6 = _DAT_0074b710;
  }
  fVar18 = (float10)fpatan((float10)_DAT_0074b698 * fVar19 +
                           (float10)_DAT_0074b6e0 * fVar18 +
                           (float10)fVar5 * fVar19 * fVar19 * fVar19 +
                           (float10)fVar6 * fVar18 * fVar18 * fVar18,(float10)1);
  fVar18 = fVar18 * (float10)_DAT_006f51d8;
  fVar5 = _DAT_0074b680;
  if (fVar18 < (float10)_DAT_006ea454 != (NAN(fVar18) || NAN((float10)_DAT_006ea454))) {
    fVar5 = _DAT_0074b668;
  }
  fVar20 = (float10)_DAT_00bdaa34 * (float10)_DAT_0074b650 * fVar18 * (float10)fVar5 *
           (float10)_DAT_006efe48 + (float10)DAT_00748520;
  fVar18 = (fVar20 - (float10)_DAT_0074851c) * (float10)_DAT_0074b650 * (float10)_DAT_006efe48;
  fVar5 = _DAT_0074b770;
  if ((float10)_DAT_006ea454 < fVar18) {
    fVar5 = _DAT_0074b788;
  }
  fVar20 = fVar20 - (float10)fVar5 * fVar18;
  if (fVar20 < (float10)_DAT_0074b728 != (NAN(fVar20) || NAN((float10)_DAT_0074b728))) {
    fVar20 = (float10)_DAT_0074b728;
  }
  if ((float10)_DAT_0074b740 < fVar20) {
    fVar20 = (float10)_DAT_0074b740;
  }
  DAT_00748520 = (float)fVar20;
  fVar5 = _DAT_0074b758 * _DAT_0074b650 * _DAT_006efe48;
  if (_DAT_00bdaa34 < _DAT_006e97d8 == (NAN(_DAT_00bdaa34) || NAN(_DAT_006e97d8))) {
    _DAT_00bdaa34 = _DAT_00bdaa34 - fVar5;
    if (_DAT_00bdaa34 < _DAT_006e97d8 != (NAN(_DAT_00bdaa34) || NAN(_DAT_006e97d8)))
    goto LAB_0052c995;
  }
  else {
    _DAT_00bdaa34 = fVar5 + _DAT_00bdaa34;
    if (_DAT_006e97d8 < _DAT_00bdaa34) {
LAB_0052c995:
      _DAT_00bdaa34 = 1.0;
    }
  }
  _DAT_00bdaa30 = (float)fVar19;
LAB_0052c9a5:
  local_30 = 0.0;
  local_34 = 0.0;
  local_3c = 0;
  DAT_00bdaa24 = 0;
  cVar7 = FUN_004f5f70(&local_3c);
  while (iVar8 = 0, cVar7 != '\0') {
    if (*(char *)(local_3c + 0x59b) != '\0') {
      *(undefined4 *)(local_3c + 0x1916) = 0;
      *(undefined4 *)(local_3c + 0x191a) = 0;
      *(undefined4 *)(local_3c + 0x191e) = 0;
      *(undefined4 *)(local_3c + 0x18b2) = 0;
    }
    cVar7 = FUN_004f5f70(&local_3c);
  }
  do {
    local_3c = DAT_00acca24;
    if (iVar8 != 0) {
      if (*(int *)(iVar8 + 4) == 0) {
        local_3c = 0;
      }
      else {
        local_3c = *(int *)(iVar8 + 4) + -4;
      }
      if (local_3c == DAT_00acca24) {
        local_3c = 0;
LAB_0052d001:
        if ((iVar8 != 0) && (local_34 != 0.0)) {
          fVar18 = (float10)FUN_0051eff0(local_34,iVar8);
          *(float *)(iVar8 + 0x1ac6) = (float)fVar18;
        }
        FUN_0051f9b0();
        return;
      }
    }
    if (local_3c == 0) goto LAB_0052d001;
    local_2c = *(float *)(local_3c + 0x186a) * _DAT_00bd79d0;
    iStack_28 = (int)ROUND(local_2c);
    *(int *)(local_3c + 0x186e) = iStack_28;
    if (*(char *)(local_3c + 0x59b) == '\0') {
      FUN_0052d030();
      uVar15 = *(uint *)(*(int *)(local_3c + 0x5ae) + 0x54) & 0x7fff;
    }
    else {
      uVar15 = *(uint *)(*(int *)(local_3c + 0x1a76) + 0x54) & 0x7fff;
      DAT_00bdaa24 = DAT_00bdaa24 + 1;
      iVar8 = *(int *)(local_3c + 0x1a76);
      if (iVar8 == 0) {
        *(undefined4 *)(local_3c + 0x1a96) = 0;
        *(undefined4 *)(local_3c + 0x1a9a) = 0x3f800000;
      }
      else {
        *(float *)(local_3c + 0x1a96) =
             *(float *)(iVar8 + 0x38) * *(float *)(iVar8 + 0x24) -
             *(float *)(iVar8 + 0x34) * *(float *)(iVar8 + 0x28);
        *(float *)(local_3c + 0x1a9a) =
             SQRT(_DAT_006e97d8 - *(float *)(local_3c + 0x1a96) * *(float *)(local_3c + 0x1a96));
      }
      *(int *)(local_3c + 0x1d2e) = *(int *)(local_3c + 0x1d2e) + 1;
      if (8 < *(int *)(local_3c + 0x1d2e)) {
        *(undefined4 *)(local_3c + 0x1d2e) = 0;
        FUN_0051a830(0x3f8ccccd,_DAT_00e0bb5c,_DAT_00e0bb40,
                     *(float *)(local_3c + 0x1862) * _DAT_006f410c,0x3f800000);
        uStack_24 = 0;
        FUN_0051a870(&uStack_24,*(undefined4 *)(local_3c + 0x18fe),
                     *(undefined4 *)(local_3c + 0x1906));
        FUN_0051aac0(_DAT_0074b0c8 * _DAT_006ea50c);
        iVar9 = local_3c;
        ppuVar1 = (uint **)(local_3c + 0x518);
        iVar8 = local_3c + 0x524;
        FUN_005f5890(iVar8);
        puVar14 = *(uint **)(iVar9 + 0x520);
        puVar17 = *ppuVar1;
        iVar9 = 2;
        pdVar13 = &dStack_20;
        do {
          uVar3 = *puVar17;
          uVar4 = *puVar14;
          puVar17 = puVar17 + 1;
          puVar14 = puVar14 + 1;
          iVar9 = iVar9 + -1;
          *(uint *)pdVar13 = uVar3 ^ uVar4;
          pdVar13 = (double *)((int)pdVar13 + 4);
        } while (iVar9 != 0);
        FUN_005f58a0(iVar8);
        *(float *)(local_3c + 0x190e) =
             (float)dStack_20 + *(float *)(*(int *)(local_3c + 0x58a) + 8) + _DAT_006f5134;
        iVar8 = FUN_00567630(*(undefined4 *)(local_3c + 0x5b2));
        cVar7 = FUN_0054b4f0(*(float *)(local_3c + 0x1872) * _DAT_006ea620);
        if (cVar7 == '\0') {
          if ((*(uint *)(iVar8 + 0xc) >> 0x19 & 1) != 0) {
            FUN_00567610(*(undefined4 *)(local_3c + 0x5b2),iVar8);
            FUN_0054b550(iVar8);
          }
        }
        else {
          FUN_00567660(*(undefined4 *)(local_3c + 0x5b2));
        }
      }
      if (0 < *(int *)(local_3c + 0x18fa)) {
        *(int *)(local_3c + 0x18fa) = *(int *)(local_3c + 0x18fa) + -1;
      }
      if ((int)uVar15 < *(int *)(local_3c + 0x1866)) {
        FUN_0052d340();
      }
      if (0 < *(int *)(local_3c + 0x1b2a)) {
        *(int *)(local_3c + 0x1b2a) = *(int *)(local_3c + 0x1b2a) + -1;
      }
      if ((0 < *(int *)(local_3c + 0x1b12)) &&
         (*(int *)(local_3c + 0x1b12) = *(int *)(local_3c + 0x1b12) + -1,
         *(int *)(local_3c + 0x1b12) == 0)) {
        FUN_0052e0d0();
      }
      if (0 < *(int *)(local_3c + 0x1b1a)) {
        *(int *)(local_3c + 0x1b1a) = *(int *)(local_3c + 0x1b1a) + -1;
      }
      if (0 < *(int *)(local_3c + 0x1b1e)) {
        *(int *)(local_3c + 0x1b1e) = *(int *)(local_3c + 0x1b1e) + -1;
      }
      *(uint *)(local_3c + 0x1d9b) = ((int)*(char *)(local_3c + 0x1d9b) & 1U) * 2;
      FUN_00567610(*(undefined4 *)(local_3c + 0x5b2));
      local_38 = *(float *)(local_3c + 0x1872) * _DAT_006f51d4;
      if (local_38 < _DAT_006ea454 != (NAN(local_38) || NAN(_DAT_006ea454))) {
        local_38 = 0.0;
      }
      fVar18 = (float10)FUN_0054ba90();
      *(float *)(local_3c + 0x1b2e) =
           (float)(((fVar18 + (float10)_DAT_006ea44c) - (float10)local_38) * (float10)_DAT_006efe48
                  + (float10)*(float *)(local_3c + 0x1b2e));
      if (*(float *)(local_3c + 0x1b2e) < _DAT_006ea454 !=
          (NAN(*(float *)(local_3c + 0x1b2e)) || NAN(_DAT_006ea454))) {
        *(undefined4 *)(local_3c + 0x1b2e) = 0;
      }
      if (local_3d != '\0') {
        FUN_004f6e90();
      }
      FUN_004f7200();
      iVar8 = *(int *)(local_3c + 0x186e);
      local_38 = (_DAT_0074b140 + *(float *)(local_3c + 0x18f2)) - _DAT_006ef678;
      iVar9 = (**(code **)(**(int **)(local_3c + 0x13b3) + 0x50))(local_3c);
      iVar8 = iVar8 * 0x1c;
      if ((*(float *)(*(int *)(iVar9 + 0x10) + 0x14 + iVar8) - local_38 <=
           *(float *)(local_3c + 0x1886)) ||
         (fVar5 = *(float *)(*(int *)(iVar9 + 0x14) + 0x14 + iVar8) + local_38,
         fVar5 < *(float *)(local_3c + 0x1886) == (NAN(fVar5) || NAN(*(float *)(local_3c + 0x1886)))
         )) {
        *(uint *)(local_3c + 0x139f) = *(uint *)(local_3c + 0x139f) & 0xffffffdf;
        cVar7 = (**(code **)(**(int **)(local_3c + 0x13a7) + 0x30))(local_3c);
        if (cVar7 != '\0') {
          FUN_0052e0a0(0x42900000);
        }
      }
      else {
        *(uint *)(local_3c + 0x139f) = *(uint *)(local_3c + 0x139f) | 0x20;
      }
      FUN_00401ab0();
      iVar8 = (int)local_30;
    }
    if ((int)uVar15 < *(int *)(local_3c + 0x1866)) {
      FUN_0052d470();
    }
    *(undefined4 *)(local_3c + 0x1bce) = 0;
    *(undefined4 *)(local_3c + 0x1bda) = 0;
    *(float *)(local_3c + 0x1862) =
         SQRT(*(float *)(local_3c + 0x1872) * *(float *)(local_3c + 0x1872) +
              *(float *)(local_3c + 0x188a) * *(float *)(local_3c + 0x188a));
    iVar9 = *(int *)(local_3c + 0x5ae);
    fStack_14 = *(float *)(iVar9 + 0xc) - DAT_00e0b840;
    fStack_c = *(float *)(iVar9 + 0x14);
    fVar5 = *(float *)(iVar9 + 0x10) - DAT_00e0b844;
    *(float *)(local_3c + 0x5aa) =
         SQRT(fStack_14 * fStack_14 +
              fVar5 * fVar5 + (fStack_c - DAT_00e0b848) * (fStack_c - DAT_00e0b848)) * _DAT_006efe48
    ;
    *(undefined4 *)(local_3c + 0x59e) = 0x3f800000;
    *(undefined4 *)(local_3c + 0x5a2) = 0x3f800000;
    *(undefined4 *)(local_3c + 0x5a6) = 0x3f800000;
    fVar18 = (float10)FUN_00516f1a(uVar15);
    local_38 = (float)fVar18;
    if ((NAN(fVar18) || NAN((float10)_DAT_006ea454)) == (fVar18 == (float10)_DAT_006ea454)) {
      fVar5 = local_38 - *(float *)(local_3c + 0x1886);
      *(float *)(local_3c + 0x1ac2) = fVar5 / local_38;
      if (*(float *)(local_3c + 0x1ac2) <= _DAT_006ea4cc) {
        *(undefined4 *)(local_3c + 0x1ac2) = 0x3dcccccd;
        *(undefined4 *)(local_3c + 0x1abe) = 0x41200000;
      }
      else {
        *(float *)(local_3c + 0x1abe) = local_38 / fVar5;
      }
    }
    else {
      *(undefined4 *)(local_3c + 0x1abe) = 0x3f800000;
      *(undefined4 *)(local_3c + 0x1ac2) = 0x3f800000;
    }
    *(uint *)(local_3c + 0x1866) = uVar15;
    if (iVar8 != 0) {
      fVar18 = (float10)FUN_0051eff0(local_3c,iVar8);
      *(float *)(iVar8 + 0x1ac6) = (float)fVar18;
    }
    local_30 = (float)local_3c;
    iVar8 = local_3c;
    if (local_34 == 0.0) {
      local_34 = (float)local_3c;
    }
  } while( true );
}

