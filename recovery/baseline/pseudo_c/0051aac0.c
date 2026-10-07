/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0051aac0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_0051aac0(int param_1_00,float param_1)

{
  int *piVar1;
  float fVar2;
  float fVar3;
  uint uVar4;
  float fVar5;
  float fVar6;
  float fVar7;
  bool bVar8;
  int iVar9;
  int iVar10;
  undefined4 **ppuVar11;
  uint uVar12;
  undefined4 uVar13;
  uint *puVar14;
  float *pfVar15;
  double *pdVar16;
  uint **ppuVar17;
  uint *puVar18;
  uint *puVar19;
  float fVar20;
  int *piVar21;
  undefined4 *puVar22;
  bool bVar23;
  float10 fVar24;
  float10 fVar25;
  double dVar26;
  float fStack_4c;
  double dStack_40;
  float local_38;
  float fStack_34;
  uint *apuStack_30 [2];
  float afStack_28 [2];
  double dStack_20;
  undefined4 *apuStack_18 [2];
  undefined8 uStack_10;
  
  local_38 = (float)param_1_00;
  iVar9 = FUN_0051a000();
  bVar23 = param_1_00 == iVar9;
  if ((_DAT_006ea454 < *(float *)(param_1_00 + 0x550)) &&
     (fVar3 = *(float *)(param_1_00 + 0x550) - param_1, *(float *)(param_1_00 + 0x550) = fVar3,
     fVar3 < _DAT_006ea454)) {
    *(undefined4 *)(param_1_00 + 0x550) = 0;
  }
  if (bVar23) {
    FUN_0051a9c0();
  }
  iVar9 = (**(code **)(**(int **)(param_1_00 + 0x56e) + 4))();
  fVar3 = *(float *)(iVar9 + 0x58);
  if (((_DAT_006f053c <= fVar3) || (fVar3 < _DAT_006ea508 != (fVar3 == _DAT_006ea508))) ||
     (dVar26 = rndUniform(0), (double)fVar3 < dVar26)) {
    fVar20 = _DAT_006e97d8 - fVar3;
  }
  else {
    fVar20 = _DAT_006e97d8 - fVar3 * _DAT_006ea44c;
  }
  *(float *)(param_1_00 + 0x554) = fVar20;
  fVar20 = *(float *)(iVar9 + 0x60);
  if (_DAT_006ea4a4 < fVar20) {
    if ((_DAT_006f053c < fVar20) || (dVar26 = rndUniform(0), dVar26 < _DAT_006ecfe8)) {
      fVar20 = *(float *)(param_1_00 + 0x554) - fVar20;
    }
    else {
      fVar20 = *(float *)(param_1_00 + 0x554) - fVar20 * _DAT_006ea44c;
    }
    *(float *)(param_1_00 + 0x554) = fVar20;
    if (*(float *)(param_1_00 + 0x554) < _DAT_006ea454) {
      *(undefined4 *)(param_1_00 + 0x554) = 0;
    }
  }
  *(float *)(param_1_00 + 0x494) =
       *(float *)(param_1_00 + 0x48c) * *(float *)(param_1_00 + 0x484) * _DAT_006f4768;
  *(float *)(param_1_00 + 0x498) =
       *(float *)(param_1_00 + 0x490) * *(float *)(param_1_00 + 0x484) * _DAT_006f4768;
  fVar24 = (float10)FUN_0051be00(*(undefined4 *)(param_1_00 + 0x484));
  uStack_10 = (double)(fVar24 * (float10)*(float *)(param_1_00 + 0x494) * (float10)param_1 *
                      (float10)_DAT_006f47d0);
  bVar8 = inServer();
  if (bVar8) {
    iVar10 = FUN_005099b0();
    if (iVar10 == 5) {
      dVar26 = (double)_DAT_006e97d8;
    }
    else {
      iVar10 = FUN_00544bf0();
      apuStack_18[1] = (undefined4 *)0x0;
      apuStack_18[0] = (undefined4 *)((*(uint *)(iVar10 + 0x50) & 3) + 1);
      dVar26 = (double)apuStack_18[0];
    }
  }
  else {
    iVar10 = FUN_00567280();
    if (iVar10 == 5) {
      dVar26 = (double)_DAT_006e97d8;
    }
    else {
      iVar10 = FUN_0055a680();
      apuStack_18[1] = (undefined4 *)0x0;
      apuStack_18[0] = (undefined4 *)((*(uint *)(iVar10 + 0x50) & 3) + 1);
      dVar26 = (double)apuStack_18[0];
    }
  }
  uStack_10 = dVar26 * uStack_10;
  bVar8 = inServer();
  if (((bVar8) && (iVar10 = FUN_00544bf0(), (*(uint *)(iVar10 + 0x4c) & 0x2000000) != 0)) &&
     (*(char *)(*(int *)(param_1_00 + 0x56e) + 0x59b) != '\0')) {
    uStack_10 = (double)(_DAT_0074b1e8 * (float)uStack_10);
  }
  piVar1 = (int *)(param_1_00 + 0x50c);
  FUN_005f5890(param_1_00 + 0x518);
  FUN_0040e980(apuStack_18,*piVar1,*(undefined4 *)(param_1_00 + 0x514),8);
  FUN_005f58a0(param_1_00 + 0x518);
  dStack_20 = (double)CONCAT44(apuStack_18[1],apuStack_18[0]) - uStack_10;
  FUN_0040bde0(&dStack_20);
  FUN_005f5890(param_1_00 + 0x518);
  dStack_40._0_4_ = (uint *)*piVar1;
  apuStack_30[0] = (uint *)0x2;
  puVar14 = (uint *)&uStack_10;
  puVar18 = *(uint **)(param_1_00 + 0x514);
  do {
    *puVar14 = *dStack_40._0_4_ ^ *puVar18;
    dStack_40._0_4_ = dStack_40._0_4_ + 1;
    apuStack_30[0] = (uint *)((int)apuStack_30[0] + -1);
    puVar14 = puVar14 + 1;
    puVar18 = puVar18 + 1;
  } while (apuStack_30[0] != (uint *)0x0);
  FUN_005f58a0(param_1_00 + 0x518);
  if (uStack_10 < _DAT_006f47c8 == (uStack_10 == _DAT_006f47c8)) {
    fVar20 = (float)param_1_00;
    if ((*(uint *)(iVar9 + 0xc) >> 0x1c & 1) != 0) {
      apuStack_30[0] = (uint *)(**(code **)(**(int **)(param_1_00 + 0x56e) + 8))();
      FUN_0054b610(0);
      bVar8 = inServer();
      if ((bVar8) && (*(char *)(*(int *)(param_1_00 + 0x56e) + 0x59b) != '\0')) {
        FUN_0052e270(iVar9,apuStack_30[0]);
      }
      (**(code **)(**(int **)(param_1_00 + 0x56e) + 0xc))();
    }
  }
  else {
    fStack_34 = (float)(param_1_00 + 0x518);
    uStack_10 = 0.0;
    FUN_005f5890(fStack_34);
    puVar14 = *(uint **)(param_1_00 + 0x510);
    puVar18 = &DAT_00f72120;
    iVar10 = 2;
    ppuVar11 = apuStack_18;
    do {
      uVar12 = *puVar14;
      uVar4 = *puVar18;
      puVar14 = puVar14 + 1;
      puVar18 = puVar18 + 1;
      iVar10 = iVar10 + -1;
      *ppuVar11 = (undefined4 *)(uVar12 ^ uVar4);
      ppuVar11 = ppuVar11 + 1;
    } while (iVar10 != 0);
    iVar10 = 2;
    bVar8 = true;
    ppuVar11 = apuStack_18;
    piVar21 = (int *)*piVar1;
    do {
      if (iVar10 == 0) break;
      iVar10 = iVar10 + -1;
      bVar8 = *ppuVar11 == (undefined4 *)*piVar21;
      ppuVar11 = ppuVar11 + 1;
      piVar21 = piVar21 + 1;
    } while (bVar8);
    if (!bVar8) {
      do {
        DAT_00f7212c = FUN_005cfcfc();
      } while (DAT_00f7212c == 0);
    }
    uVar12 = FUN_005cfcfc();
    if ((uVar12 & 0x3f) == 0) {
      puVar22 = *(undefined4 **)(param_1_00 + 0x514);
      apuStack_30[0] = (uint *)0x2;
      do {
        uVar13 = FUN_005cfcfc();
        *puVar22 = uVar13;
        puVar22 = puVar22 + 1;
        apuStack_30[0] = (uint *)((int)apuStack_30[0] + -1);
      } while (apuStack_30[0] != (uint *)0x0);
    }
    FUN_0040e980(*piVar1,&uStack_10,*(undefined4 *)(param_1_00 + 0x514),8);
    FUN_0040e980(*(undefined4 *)(param_1_00 + 0x510),&DAT_00f72120,*piVar1,8);
    uVar12 = FUN_005cfcfc();
    if ((uVar12 & 0x3ff) == 0) {
      uVar13 = FUN_0051c850(*(undefined4 *)(param_1_00 + 0x514));
      *(undefined4 *)(param_1_00 + 0x514) = uVar13;
    }
    uVar12 = FUN_005cfcfc();
    if ((uVar12 & 0x1ff) == 0) {
      iVar10 = FUN_0051c850(*piVar1);
      *piVar1 = iVar10;
    }
    uVar12 = FUN_005cfcfc();
    if ((uVar12 & 0x7ff) == 0) {
      uVar13 = FUN_0051c850(*(undefined4 *)(param_1_00 + 0x510));
      *(undefined4 *)(param_1_00 + 0x510) = uVar13;
    }
    FUN_005f58a0(fStack_34);
    fVar20 = local_38;
    *(undefined4 *)((int)local_38 + 0x554) = 0;
    if ((*(uint *)(iVar9 + 0xc) >> 0x1c & 1) == 0) {
      apuStack_30[0] = (uint *)(**(code **)(**(int **)((int)local_38 + 0x56e) + 8))();
      FUN_0054b610(1);
      bVar8 = inServer();
      if ((bVar8) && (*(char *)(*(int *)((int)fVar20 + 0x56e) + 0x59b) != '\0')) {
        FUN_0052e270(iVar9,apuStack_30[0]);
      }
      (**(code **)(**(int **)((int)fVar20 + 0x56e) + 0xc))();
      fVar20 = local_38;
    }
  }
  fStack_34 = 0.6122449;
  FUN_005f5890(param_1_00 + 0x518);
  dStack_40._0_4_ = (uint *)*piVar1;
  apuStack_30[0] = (uint *)0x2;
  puVar14 = (uint *)&uStack_10;
  puVar18 = *(uint **)(param_1_00 + 0x514);
  do {
    *puVar14 = *dStack_40._0_4_ ^ *puVar18;
    dStack_40._0_4_ = dStack_40._0_4_ + 1;
    apuStack_30[0] = (uint *)((int)apuStack_30[0] + -1);
    puVar14 = puVar14 + 1;
    puVar18 = puVar18 + 1;
  } while (apuStack_30[0] != (uint *)0x0);
  FUN_005f58a0(param_1_00 + 0x518);
  if (_DAT_006ed050 <= uStack_10) {
    fVar24 = (float10)fStack_34;
  }
  else {
    fStack_34 = (float)(param_1_00 + 0x518);
    FUN_005f5890(fStack_34);
    puVar14 = *(uint **)(param_1_00 + 0x514);
    puVar18 = (uint *)*piVar1;
    apuStack_30[0] = (uint *)0x2;
    puVar19 = (uint *)&uStack_10;
    do {
      uVar12 = *puVar18;
      uVar4 = *puVar14;
      puVar18 = puVar18 + 1;
      puVar14 = puVar14 + 1;
      *puVar19 = uVar12 ^ uVar4;
      apuStack_30[0] = (uint *)((int)apuStack_30[0] + -1);
      puVar19 = puVar19 + 1;
    } while (apuStack_30[0] != (uint *)0x0);
    FUN_005f58a0(fStack_34);
    fVar24 = (float10)uStack_10 * (float10)_DAT_006ef720 * (float10)_DAT_006f47c0;
  }
  if ((((byte)*(undefined4 *)((int)fVar20 + 0x548) & 0x20) != 0x20) ||
     (*(float *)((int)fVar20 + 0x554) <= _DAT_006ea454)) {
    fVar25 = (float10)*(float *)((int)fVar20 + 0x484) / (float10)*(float *)((int)fVar20 + 0x438);
    if (fVar25 <= (float10)_DAT_006e97d8) {
      if (fVar25 < (float10)_DAT_006ea454) {
        fVar25 = (float10)_DAT_006ea454;
      }
    }
    else {
      fVar25 = (float10)_DAT_006e97d8;
    }
    *(undefined4 *)((int)fVar20 + 0x554) = 0;
    *(float *)((int)fVar20 + 0x500) = (float)(fVar25 * fVar24);
  }
  else {
    *(float *)((int)fVar20 + 0x500) = (float)fVar24;
  }
  if ((*(float *)((int)fVar20 + 0x500) < _DAT_006f47bc) &&
     (dVar26 = rndUniform(0),
     (double)*(float *)((int)fVar20 + 0x500) * (double)_DAT_006f47b8 < dVar26)) {
    *(float *)((int)fVar20 + 0x554) = *(float *)((int)fVar20 + 0x554) * _DAT_006f47b4;
  }
  fVar7 = *(float *)((int)fVar20 + 0x438) * _DAT_006efb28;
  fStack_34 = *(float *)((int)fVar20 + 0x438) * _DAT_006ec744;
  fVar5 = *(float *)(*(int *)((int)fVar20 + 0x56a) + 0x34) * _DAT_006ed6c8;
  fVar2 = _DAT_006f47b0;
  if (*(float *)((int)fVar20 + 0x4a0) < fVar5) {
    fVar2 = (*(float *)((int)fVar20 + 0x4a0) / fVar5) * _DAT_006f47b0;
  }
  fVar5 = _DAT_006ea44c * fVar2;
  if (_DAT_006f3fe8 <= *(float *)((int)fVar20 + 0x554)) {
    fVar6 = fVar2;
    if ((*(float *)((int)fVar20 + 0x484) <= fVar7) &&
       (fVar6 = fVar5, fStack_34 <= *(float *)((int)fVar20 + 0x484))) {
      fVar6 = ((fVar2 - fVar5) * (*(float *)((int)fVar20 + 0x484) - fStack_34)) /
              (fVar7 - fStack_34) + fVar5;
    }
    *(float *)((int)fVar20 + 0x4d0) =
         (fVar6 - *(float *)((int)fVar20 + 0x4d0)) * _DAT_006ee4c4 + *(float *)((int)fVar20 + 0x4d0)
    ;
  }
  else {
    fVar5 = *(float *)((int)fVar20 + 0x4d0) - _DAT_006f47ac * fVar2;
    *(float *)((int)fVar20 + 0x4d0) = fVar5;
    if (fVar5 < _DAT_006ea454) {
      *(undefined4 *)((int)fVar20 + 0x4d0) = 0;
    }
  }
  if ((*(float *)((int)fVar20 + 0x4d0) < _DAT_006f47a8) && (fVar7 < *(float *)((int)fVar20 + 0x484))
     ) {
    *(float *)((int)fVar20 + 0x554) =
         (*(float *)((int)fVar20 + 0x4d0) / (fVar2 * _DAT_006ea504)) *
         *(float *)((int)fVar20 + 0x554);
  }
  puVar22 = (undefined4 *)((int)fVar20 + 0x4a4);
  apuStack_30[0] =
       (uint *)((_DAT_006e97d8 - (_DAT_006e97d8 - *(float *)((int)fVar20 + 0x480)) * _DAT_006f47a4)
                * SQRT(*(float *)((int)fVar20 + 0x47c)) * _DAT_006ea698 + _DAT_006ea44c);
  dStack_40._0_4_ =
       (uint *)(param_1 / ((*(float *)((int)fVar20 + 0x4a0) + _DAT_006ea62c) * _DAT_006f47a0));
  afStack_28[0] = (float)dStack_40._0_4_ * *(float *)((int)fVar20 + 0x498);
  uStack_10._0_4_ = puVar22;
  FUN_005f5890((int)fVar20 + 0x4b0);
  FUN_00425e80(&fStack_34,*puVar22,*(undefined4 *)((int)fVar20 + 0x4ac),4);
  FUN_005f58a0((int)fVar20 + 0x4b0);
  dStack_20._0_4_ = fStack_34 + afStack_28[0];
  FUN_0051c3f0(&dStack_20);
  FUN_005f5890((int)fVar20 + 0x4b0);
  dStack_20._0_4_ = (float)(*(uint *)*puVar22 ^ **(uint **)((int)fVar20 + 0x4ac));
  FUN_005f58a0((int)fVar20 + 0x4b0);
  afStack_28[0] =
       *(float *)((int)fVar20 + 0x4d0) * _DAT_006f479c *
       (dStack_20._0_4_ - *(float *)((int)fVar20 + 0x478)) * *(float *)((int)fVar20 + 0x43c) *
       (float)dStack_40._0_4_ * (float)apuStack_30[0];
  FUN_005f5890((int)fVar20 + 0x4b0);
  FUN_00425e80(&dStack_20,*puVar22,*(undefined4 *)((int)fVar20 + 0x4ac),4);
  FUN_005f58a0((int)fVar20 + 0x4b0);
  fStack_34 = dStack_20._0_4_ - afStack_28[0];
  FUN_0051c3f0(&fStack_34);
  puVar22 = (undefined4 *)((int)fVar20 + 0x4d4);
  afStack_28[0] = param_1 / ((*(float *)((int)fVar20 + 0x49c) + _DAT_006ea62c) * _DAT_006f4798);
  dStack_40 = (double)CONCAT44(dStack_40._4_4_,afStack_28[0]);
  afStack_28[0] = afStack_28[0] * *(float *)((int)fVar20 + 0x494);
  apuStack_18[0] = puVar22;
  FUN_005f5890((int)fVar20 + 0x4e0);
  FUN_00425e80(&dStack_20,*puVar22,*(undefined4 *)((int)fVar20 + 0x4dc),4);
  FUN_005f58a0((int)fVar20 + 0x4e0);
  fStack_34 = dStack_20._0_4_ + afStack_28[0];
  FUN_0051c3f0(&fStack_34);
  FUN_005f5890((int)fVar20 + 0x4e0);
  dStack_20 = (double)CONCAT44(dStack_20._4_4_,*(uint *)*puVar22 ^ **(uint **)((int)fVar20 + 0x4dc))
  ;
  FUN_005f58a0((int)fVar20 + 0x4e0);
  afStack_28[0] =
       (dStack_20._0_4_ - *(float *)((int)fVar20 + 0x478)) *
       (*(float *)((int)fVar20 + 0x484) / *(float *)((int)fVar20 + 0x438)) *
       *(float *)((int)fVar20 + 0x440) * (float)dStack_40._0_4_ * (float)apuStack_30[0];
  FUN_005f5890((int)fVar20 + 0x4e0);
  FUN_00425e80(&dStack_20,*puVar22,*(undefined4 *)((int)fVar20 + 0x4dc),4);
  FUN_005f58a0((int)fVar20 + 0x4e0);
  apuStack_30[0] = (uint *)(dStack_20._0_4_ - afStack_28[0]);
  FUN_0051c3f0(apuStack_30);
  fVar2 = *(float *)(iVar9 + 0x4c);
  if ((_DAT_006ea454 < fVar2) &&
     (fVar2 = *(float *)((int)fVar20 + 0x4a0) - fVar2 * fVar2 * param_1 * _DAT_006e9824,
     *(float *)((int)fVar20 + 0x4a0) = fVar2, fVar2 < _DAT_006ea454)) {
    *(undefined4 *)((int)fVar20 + 0x4a0) = 0;
  }
  fVar2 = *(float *)(iVar9 + 0x50);
  if ((_DAT_006ea454 < fVar2) &&
     (fVar2 = *(float *)((int)fVar20 + 0x49c) - fVar2 * fVar2 * param_1 * _DAT_006efb28,
     *(float *)((int)fVar20 + 0x49c) = fVar2, fVar2 < _DAT_006ea454)) {
    *(undefined4 *)((int)fVar20 + 0x49c) = 0;
  }
  fVar2 = *(float *)(iVar9 + 0x54);
  if (_DAT_006ea454 < fVar2) {
    dStack_20 = (double)CONCAT44(dStack_20._4_4_,
                                 fVar2 * fVar2 * param_1 * _DAT_006ee598 * _DAT_006f4714);
    FUN_005f5890(param_1_00 + 0x518);
    fStack_34 = 2.8026e-45;
    apuStack_30[0] = *(uint **)(param_1_00 + 0x514);
    pfVar15 = afStack_28;
    puVar14 = (uint *)*piVar1;
    do {
      *pfVar15 = (float)(*apuStack_30[0] ^ *puVar14);
      apuStack_30[0] = apuStack_30[0] + 1;
      fStack_34 = (float)((int)fStack_34 + -1);
      pfVar15 = pfVar15 + 1;
      puVar14 = puVar14 + 1;
    } while (fStack_34 != 0.0);
    FUN_005f58a0(param_1_00 + 0x518);
    dStack_40 = (double)((float)(double)CONCAT44(afStack_28[1],afStack_28[0]) - dStack_20._0_4_);
    FUN_0040bde0(&dStack_40);
    FUN_005f5890(param_1_00 + 0x518);
    fStack_34 = 2.8026e-45;
    apuStack_30[0] = (uint *)*piVar1;
    pdVar16 = &dStack_20;
    puVar14 = *(uint **)(param_1_00 + 0x514);
    do {
      *(uint *)pdVar16 = *apuStack_30[0] ^ *puVar14;
      apuStack_30[0] = apuStack_30[0] + 1;
      fStack_34 = (float)((int)fStack_34 + -1);
      pdVar16 = (double *)((int)pdVar16 + 4);
      puVar14 = puVar14 + 1;
    } while (fStack_34 != 0.0);
    FUN_005f58a0(param_1_00 + 0x518);
    if (dStack_20 < _DAT_006ea4b0) {
      afStack_28[0] = 0.0;
      afStack_28[1] = 0.0;
      dStack_20 = (double)CONCAT44(dStack_20._4_4_,param_1_00 + 0x518);
      FUN_005f5890(param_1_00 + 0x518);
      puVar14 = *(uint **)(param_1_00 + 0x510);
      puVar18 = &DAT_00f72120;
      iVar10 = 2;
      ppuVar17 = apuStack_30;
      do {
        uVar12 = *puVar14;
        uVar4 = *puVar18;
        puVar14 = puVar14 + 1;
        puVar18 = puVar18 + 1;
        iVar10 = iVar10 + -1;
        *ppuVar17 = (uint *)(uVar12 ^ uVar4);
        ppuVar17 = ppuVar17 + 1;
      } while (iVar10 != 0);
      iVar10 = 2;
      bVar8 = true;
      ppuVar17 = apuStack_30;
      piVar21 = (int *)*piVar1;
      do {
        if (iVar10 == 0) break;
        iVar10 = iVar10 + -1;
        bVar8 = *ppuVar17 == (uint *)*piVar21;
        ppuVar17 = ppuVar17 + 1;
        piVar21 = piVar21 + 1;
      } while (bVar8);
      if (!bVar8) {
        do {
          DAT_00f7212c = FUN_005cfcfc();
        } while (DAT_00f7212c == 0);
      }
      uVar12 = FUN_005cfcfc();
      if ((uVar12 & 0x3f) == 0) {
        puVar22 = *(undefined4 **)(param_1_00 + 0x514);
        apuStack_30[0] = (uint *)0x2;
        do {
          uVar13 = FUN_005cfcfc();
          *puVar22 = uVar13;
          puVar22 = puVar22 + 1;
          apuStack_30[0] = (uint *)((int)apuStack_30[0] + -1);
        } while (apuStack_30[0] != (uint *)0x0);
      }
      puVar14 = *(uint **)(param_1_00 + 0x514);
      pfVar15 = afStack_28;
      apuStack_30[0] = (uint *)0x2;
      puVar18 = (uint *)*piVar1;
      do {
        fVar20 = *pfVar15;
        uVar12 = *puVar14;
        pfVar15 = pfVar15 + 1;
        puVar14 = puVar14 + 1;
        *puVar18 = (uint)fVar20 ^ uVar12;
        apuStack_30[0] = (uint *)((int)apuStack_30[0] + -1);
        puVar18 = puVar18 + 1;
      } while (apuStack_30[0] != (uint *)0x0);
      puVar14 = (uint *)*piVar1;
      puVar19 = &DAT_00f72120;
      apuStack_30[0] = (uint *)0x2;
      puVar18 = *(uint **)(param_1_00 + 0x510);
      do {
        uVar12 = *puVar19;
        uVar4 = *puVar14;
        puVar19 = puVar19 + 1;
        puVar14 = puVar14 + 1;
        *puVar18 = uVar12 ^ uVar4;
        apuStack_30[0] = (uint *)((int)apuStack_30[0] + -1);
        puVar18 = puVar18 + 1;
      } while (apuStack_30[0] != (uint *)0x0);
      uVar12 = FUN_005cfcfc();
      if ((uVar12 & 0x3ff) == 0) {
        uVar13 = FUN_0051c850(*(undefined4 *)(param_1_00 + 0x514));
        *(undefined4 *)(param_1_00 + 0x514) = uVar13;
      }
      uVar12 = FUN_005cfcfc();
      if ((uVar12 & 0x1ff) == 0) {
        iVar10 = FUN_0051c850(*piVar1);
        *piVar1 = iVar10;
      }
      uVar12 = FUN_005cfcfc();
      if ((uVar12 & 0x7ff) == 0) {
        uVar13 = FUN_0051c850(*(undefined4 *)(param_1_00 + 0x510));
        *(undefined4 *)(param_1_00 + 0x510) = uVar13;
      }
      FUN_005f58a0(dStack_20._0_4_);
      fVar20 = local_38;
      puVar22 = apuStack_18[0];
    }
  }
  local_38 = param_1 + *(float *)((int)fVar20 + 0x558);
  *(float *)((int)fVar20 + 0x558) = local_38;
  if ((bVar23) && (_DAT_006e9824 < local_38)) {
    fVar2 = (*(float *)((int)fVar20 + 0x494) + *(float *)((int)fVar20 + 0x498)) * _DAT_006f4790;
    fVar2 = fVar2 * fVar2;
    dStack_40 = (double)CONCAT44(dStack_40._4_4_,fVar2);
    if (fVar2 <= _DAT_006e97d8) {
      if (fVar2 < _DAT_006ef640) {
        dStack_40 = (double)CONCAT44(dStack_40._4_4_,0x3e99999a);
      }
    }
    else {
      dStack_40 = (double)CONCAT44(dStack_40._4_4_,0x3f800000);
    }
    fStack_4c = (float)dStack_40._0_4_ * local_38 * _DAT_006f4794;
    if ((_DAT_006ea508 < fVar3) &&
       (*(float *)((int)fVar20 + 0x438) * _DAT_006ea504 < *(float *)((int)fVar20 + 0x484))) {
      fStack_4c = local_38 * fVar3 * _DAT_006f478c + fStack_4c;
    }
    FUN_005f5890(puVar22 + 3);
    apuStack_18[0] = (undefined4 *)(*(uint *)*puVar22 ^ *(uint *)puVar22[2]);
    FUN_005f58a0(puVar22 + 3);
    if (_DAT_006ee5a4 < (float)apuStack_18[0]) {
      apuStack_18[0] = puVar22 + 3;
      FUN_005f5890(apuStack_18[0]);
      dStack_20 = (double)CONCAT44(dStack_20._4_4_,*(uint *)puVar22[2] ^ *(uint *)*puVar22);
      FUN_005f58a0(apuStack_18[0]);
      fVar2 = (dStack_20._0_4_ - _DAT_006ee5a4) * _DAT_006ee390;
      fStack_4c = *(float *)((int)fVar20 + 0x558) * _DAT_006f4788 * fVar2 * fVar2 + fStack_4c;
    }
    puVar22 = (undefined4 *)uStack_10;
    FUN_005f5890((undefined4 *)uStack_10 + 3);
    uStack_10._0_4_ = (undefined4 *)(*(uint *)*puVar22 ^ *(uint *)puVar22[2]);
    FUN_005f58a0(puVar22 + 3);
    if (_DAT_006f4784 < (float)(undefined4 *)uStack_10) {
      uStack_10._0_4_ = puVar22 + 3;
      FUN_005f5890((undefined4 *)uStack_10);
      apuStack_18[0] = (undefined4 *)(*(uint *)*puVar22 ^ *(uint *)puVar22[2]);
      FUN_005f58a0((undefined4 *)uStack_10);
      fVar2 = ((float)apuStack_18[0] - _DAT_006f4784) * _DAT_006ee390;
      fStack_4c = *(float *)((int)fVar20 + 0x558) * _DAT_006f4788 * fVar2 * fVar2 + fStack_4c;
    }
    fVar2 = *(float *)((int)fVar20 + 0x438) * _DAT_006f4780 + _DAT_006ed00c;
    if (*(float *)((int)fVar20 + 0x484) <= fVar2) {
      *(float *)((int)fVar20 + 0x508) =
           *(float *)((int)fVar20 + 0x508) - *(float *)((int)fVar20 + 0x558);
    }
    else {
      *(float *)((int)fVar20 + 0x508) =
           *(float *)((int)fVar20 + 0x508) + *(float *)((int)fVar20 + 0x558);
      fVar2 = (*(float *)((int)fVar20 + 0x484) - fVar2) *
              (_DAT_006e97d8 / (*(float *)((int)fVar20 + 0x438) * _DAT_006f477c - fVar2));
      if (_DAT_006e97d8 < fVar2) {
        fVar2 = _DAT_006e97d8;
      }
      fVar2 = fVar2 * (float)dStack_40._0_4_;
      fStack_4c = *(float *)((int)fVar20 + 0x558) * _DAT_006ea478 * fVar2 * fVar2 * fVar2 +
                  fStack_4c;
    }
    fVar2 = _DAT_006ea454;
    if ((_DAT_006ea454 <= *(float *)((int)fVar20 + 0x508)) &&
       (fVar2 = _DAT_006ed000, *(float *)((int)fVar20 + 0x508) <= _DAT_006ed000)) {
      fVar2 = *(float *)((int)fVar20 + 0x508);
    }
    *(float *)((int)fVar20 + 0x508) = fVar2;
    fStack_4c = *(float *)((int)fVar20 + 0x558) * _DAT_006ea4cc * fVar2 * _DAT_006ea4cc + fStack_4c;
    fVar2 = *(float *)((int)fVar20 + 0x438) * _DAT_006efb28;
    dStack_40 = (double)CONCAT44(dStack_40._4_4_,fVar2);
    if ((*(float *)((int)fVar20 + 0x4d0) < _DAT_006f47b0) &&
       (fVar2 < *(float *)((int)fVar20 + 0x484))) {
      fVar7 = _DAT_006e97d8 - *(float *)((int)fVar20 + 0x4d0) * _DAT_006f479c;
      fVar2 = (*(float *)((int)fVar20 + 0x484) - fVar2) / (*(float *)((int)fVar20 + 0x438) - fVar2);
      if (_DAT_006e97d8 < fVar2) {
        fVar2 = _DAT_006e97d8;
      }
      fStack_4c = *(float *)((int)fVar20 + 0x558) * _DAT_006f21d4 * fVar2 * fVar2 * fVar7 * fVar7 +
                  fStack_4c;
    }
    fVar2 = _DAT_006ea454;
    if ((*(byte *)(iVar9 + 0xf) & 1) != 0) {
      fVar2 = *(float *)(iVar9 + 0x54);
    }
    if (_DAT_006ea454 < fVar2) {
      fStack_4c = *(float *)((int)fVar20 + 0x558) * _DAT_006f4778 * fVar2 + fStack_4c;
    }
    *(float *)((int)fVar20 + 0x55c) =
         (*(float *)((int)fVar20 + 0x558) / fStack_4c) * *(float *)((int)fVar20 + 0x46c);
    dVar26 = rndUniform(0);
    if (dVar26 * (double)*(float *)((int)fVar20 + 0x46c) < (double)fStack_4c) {
      dVar26 = rndUniform(0);
      fVar24 = (float10)dVar26 * (float10)_DAT_006f4770 + (float10)_DAT_006ea504;
      fStack_4c = (float)fVar24;
      if ((float10)_DAT_006e97d8 < fVar24) {
        fStack_4c = 1.0;
      }
      apuStack_18[0] = (undefined4 *)(**(code **)(**(int **)((int)fVar20 + 0x56e) + 8))();
      apuStack_30[0] = (uint *)(fStack_4c + fVar3);
      if (_DAT_006e97d8 <= (float)apuStack_30[0]) {
        *(undefined4 *)((int)fVar20 + 0x554) = 0;
        apuStack_30[0] = (uint *)0x3f800000;
        if (*(char *)(*(int *)((int)fVar20 + 0x56e) + 0x59b) == '\0') {
          uStack_10._0_4_ = (undefined4 *)0x0;
          uStack_10._4_4_ = 0x40000000;
          rndNormal(0);
          fVar24 = (float10)FUN_006c5c40();
          uStack_10._0_4_ = (undefined4 *)(float)fVar24;
          fVar24 = (float10)FUN_005677d1((int)fVar20 + 0x224,*(undefined4 *)((int)fVar20 + 0x438));
          *(float *)((int)fVar20 + 0x560) =
               (float)(fVar24 * (float10)(float)(undefined4 *)uStack_10);
        }
      }
      FUN_0054b5a0(apuStack_30[0]);
      bVar8 = inServer();
      if ((bVar8) && (*(char *)(*(int *)((int)fVar20 + 0x56e) + 0x59b) != '\0')) {
        FUN_0052e270(iVar9,apuStack_18[0]);
      }
      (**(code **)(**(int **)((int)fVar20 + 0x56e) + 0xc))();
    }
    *(undefined4 *)((int)fVar20 + 0x558) = 0;
  }
  fVar3 = *(float *)((int)fVar20 + 0x474) * *(float *)((int)fVar20 + 0x554) * _DAT_006efac4;
  *(float *)((int)fVar20 + 0x554) = fVar3;
  if (!bVar23) {
    return;
  }
  if (_DAT_006f3fe8 <= fVar3) {
    apuStack_30[0] =
         (uint *)(*(float *)((int)fVar20 + 0x498) * _DAT_006ea44c + *(float *)((int)fVar20 + 0x494))
    ;
    if ((float)apuStack_30[0] <= _DAT_006f476c) {
      apuStack_30[0] = (uint *)0x45b09000;
    }
    fStack_34 = *(float *)((int)fVar20 + 0x484);
    if (fStack_34 < _DAT_006ecff8) {
      fStack_34 = 300.0;
    }
    FUN_00551e10(apuStack_30[0],fStack_34);
    return;
  }
  FUN_00551e10(0,0x43160000);
  return;
}


