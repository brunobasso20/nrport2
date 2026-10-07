/* NR2003.exe @ 0051aac0 FUN_0051aac0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_0051aac0(int param_1_00,float param_1)

{
  uint **ppuVar1;
  float fVar2;
  float fVar3;
  uint uVar4;
  float fVar5;
  float fVar6;
  float fVar7;
  bool bVar8;
  int iVar9;
  int iVar10;
  uint ***pppuVar11;
  uint uVar12;
  undefined4 uVar13;
  uint *puVar14;
  float *pfVar15;
  undefined8 *puVar16;
  uint **ppuVar17;
  uint *puVar18;
  uint *puVar19;
  uint **ppuVar20;
  undefined4 *puVar21;
  bool bVar22;
  float10 fVar23;
  double dVar24;
  double dVar25;
  float fStack_4c;
  undefined8 uStack_40;
  float local_38;
  float fStack_34;
  uint *apuStack_30 [2];
  float afStack_28 [2];
  undefined8 uStack_20;
  uint **appuStack_18 [2];
  undefined8 uStack_10;
  
  local_38 = (float)param_1_00;
  iVar9 = FUN_0051a000();
  bVar22 = param_1_00 == iVar9;
  if (_DAT_006ea454 < *(float *)(param_1_00 + 0x550)) {
    fVar2 = *(float *)(param_1_00 + 0x550) - param_1;
    *(float *)(param_1_00 + 0x550) = fVar2;
    if (fVar2 < _DAT_006ea454 != (NAN(fVar2) || NAN(_DAT_006ea454))) {
      *(undefined4 *)(param_1_00 + 0x550) = 0;
    }
  }
  if (bVar22) {
    FUN_0051a9c0();
  }
  iVar9 = (**(code **)(**(int **)(param_1_00 + 0x56e) + 4))();
  fVar2 = *(float *)(iVar9 + 0x58);
  if (((_DAT_006f053c <= fVar2) || (fVar2 < _DAT_006ea508 != (fVar2 == _DAT_006ea508))) ||
     (dVar24 = rndUniform(0), (double)fVar2 < dVar24)) {
    fVar3 = _DAT_006e97d8 - fVar2;
  }
  else {
    fVar3 = _DAT_006e97d8 - fVar2 * _DAT_006ea44c;
  }
  *(float *)(param_1_00 + 0x554) = fVar3;
  fVar3 = *(float *)(iVar9 + 0x60);
  if (_DAT_006ea4a4 < fVar3) {
    if ((_DAT_006f053c < fVar3) ||
       (dVar24 = rndUniform(0), dVar24 < _DAT_006ecfe8 != (NAN(dVar24) || NAN(_DAT_006ecfe8)))) {
      fVar3 = *(float *)(param_1_00 + 0x554) - fVar3;
    }
    else {
      fVar3 = *(float *)(param_1_00 + 0x554) - fVar3 * _DAT_006ea44c;
    }
    *(float *)(param_1_00 + 0x554) = fVar3;
    if (*(float *)(param_1_00 + 0x554) < _DAT_006ea454 !=
        (NAN(*(float *)(param_1_00 + 0x554)) || NAN(_DAT_006ea454))) {
      *(undefined4 *)(param_1_00 + 0x554) = 0;
    }
  }
  *(float *)(param_1_00 + 0x494) =
       *(float *)(param_1_00 + 0x48c) * *(float *)(param_1_00 + 0x484) * _DAT_006f4768;
  *(float *)(param_1_00 + 0x498) =
       *(float *)(param_1_00 + 0x490) * *(float *)(param_1_00 + 0x484) * _DAT_006f4768;
  fVar23 = (float10)FUN_0051be00(*(undefined4 *)(param_1_00 + 0x484));
  uStack_10 = (double)(fVar23 * (float10)*(float *)(param_1_00 + 0x494) * (float10)param_1 *
                      (float10)_DAT_006f47d0);
  bVar8 = inServer();
  if (bVar8) {
    iVar10 = FUN_005099b0();
    fVar3 = _DAT_006e97d8;
    if (iVar10 != 5) {
      iVar10 = FUN_00544bf0();
      appuStack_18[1] = (uint **)0x0;
      appuStack_18[0] = (uint **)((*(uint *)(iVar10 + 0x50) & 3) + 1);
      fVar3 = (float)ZEXT48(appuStack_18[0]);
    }
  }
  else {
    iVar10 = FUN_00567280();
    fVar3 = _DAT_006e97d8;
    if (iVar10 != 5) {
      iVar10 = FUN_0055a680();
      appuStack_18[1] = (uint **)0x0;
      appuStack_18[0] = (uint **)((*(uint *)(iVar10 + 0x50) & 3) + 1);
      fVar3 = (float)ZEXT48(appuStack_18[0]);
    }
  }
  uStack_10 = (double)(fVar3 * (float)uStack_10);
  bVar8 = inServer();
  if (((bVar8) && (iVar10 = FUN_00544bf0(), (*(uint *)(iVar10 + 0x4c) & 0x2000000) != 0)) &&
     (*(char *)(*(int *)(param_1_00 + 0x56e) + 0x59b) != '\0')) {
    uStack_10 = (double)(_DAT_0074b1e8 * (float)uStack_10);
  }
  ppuVar1 = (uint **)(param_1_00 + 0x50c);
  FUN_005f5890(param_1_00 + 0x518);
  FUN_0040e980(appuStack_18,*ppuVar1,*(undefined4 *)(param_1_00 + 0x514),8);
  FUN_005f58a0(param_1_00 + 0x518);
  uStack_20 = (double)CONCAT44(appuStack_18[1],appuStack_18[0]) - uStack_10;
  FUN_0040bde0(&uStack_20);
  FUN_005f5890(param_1_00 + 0x518);
  uStack_40._0_4_ = *ppuVar1;
  apuStack_30[0] = (uint *)0x2;
  puVar16 = &uStack_10;
  puVar14 = *(uint **)(param_1_00 + 0x514);
  do {
    *(uint *)puVar16 = *(uint *)uStack_40 ^ *puVar14;
    uStack_40._0_4_ = (uint *)uStack_40 + 1;
    apuStack_30[0] = (uint *)((int)apuStack_30[0] + -1);
    puVar16 = (undefined8 *)((int)puVar16 + 4);
    puVar14 = puVar14 + 1;
  } while (apuStack_30[0] != (uint *)0x0);
  FUN_005f58a0(param_1_00 + 0x518);
  if (uStack_10 < _DAT_006f47c8 == (uStack_10 == _DAT_006f47c8)) {
    iVar10 = param_1_00;
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
    pppuVar11 = appuStack_18;
    do {
      uVar12 = *puVar14;
      uVar4 = *puVar18;
      puVar14 = puVar14 + 1;
      puVar18 = puVar18 + 1;
      iVar10 = iVar10 + -1;
      *pppuVar11 = (uint **)(uVar12 ^ uVar4);
      pppuVar11 = pppuVar11 + 1;
    } while (iVar10 != 0);
    iVar10 = 2;
    bVar8 = true;
    pppuVar11 = appuStack_18;
    puVar14 = *ppuVar1;
    do {
      if (iVar10 == 0) break;
      iVar10 = iVar10 + -1;
      bVar8 = *pppuVar11 == (uint **)*puVar14;
      pppuVar11 = pppuVar11 + 1;
      puVar14 = puVar14 + 1;
    } while (bVar8);
    if (!bVar8) {
      do {
        DAT_00f7212c = FUN_005cfcfc();
      } while (DAT_00f7212c == 0);
    }
    uVar12 = FUN_005cfcfc();
    if ((uVar12 & 0x3f) == 0) {
      puVar21 = *(undefined4 **)(param_1_00 + 0x514);
      apuStack_30[0] = (uint *)0x2;
      do {
        uVar13 = FUN_005cfcfc();
        *puVar21 = uVar13;
        puVar21 = puVar21 + 1;
        apuStack_30[0] = (uint *)((int)apuStack_30[0] + -1);
      } while (apuStack_30[0] != (uint *)0x0);
    }
    FUN_0040e980(*ppuVar1,&uStack_10,*(undefined4 *)(param_1_00 + 0x514),8);
    FUN_0040e980(*(undefined4 *)(param_1_00 + 0x510),&DAT_00f72120,*ppuVar1,8);
    uVar12 = FUN_005cfcfc();
    if ((uVar12 & 0x3ff) == 0) {
      uVar13 = FUN_0051c850(*(undefined4 *)(param_1_00 + 0x514));
      *(undefined4 *)(param_1_00 + 0x514) = uVar13;
    }
    uVar12 = FUN_005cfcfc();
    if ((uVar12 & 0x1ff) == 0) {
      puVar14 = (uint *)FUN_0051c850(*ppuVar1);
      *ppuVar1 = puVar14;
    }
    uVar12 = FUN_005cfcfc();
    if ((uVar12 & 0x7ff) == 0) {
      uVar13 = FUN_0051c850(*(undefined4 *)(param_1_00 + 0x510));
      *(undefined4 *)(param_1_00 + 0x510) = uVar13;
    }
    FUN_005f58a0(fStack_34);
    iVar10 = (int)local_38;
    *(undefined4 *)((int)local_38 + 0x554) = 0;
    if ((*(uint *)(iVar9 + 0xc) >> 0x1c & 1) == 0) {
      apuStack_30[0] = (uint *)(**(code **)(**(int **)((int)local_38 + 0x56e) + 8))();
      FUN_0054b610(1);
      bVar8 = inServer();
      if ((bVar8) && (*(char *)(*(int *)(iVar10 + 0x56e) + 0x59b) != '\0')) {
        FUN_0052e270(iVar9,apuStack_30[0]);
      }
      (**(code **)(**(int **)(iVar10 + 0x56e) + 0xc))();
      iVar10 = (int)local_38;
    }
  }
  fStack_34 = 0.6122449;
  FUN_005f5890(param_1_00 + 0x518);
  uStack_40._0_4_ = *ppuVar1;
  apuStack_30[0] = (uint *)0x2;
  puVar16 = &uStack_10;
  puVar14 = *(uint **)(param_1_00 + 0x514);
  do {
    *(uint *)puVar16 = *(uint *)uStack_40 ^ *puVar14;
    uStack_40._0_4_ = (uint *)uStack_40 + 1;
    apuStack_30[0] = (uint *)((int)apuStack_30[0] + -1);
    puVar16 = (undefined8 *)((int)puVar16 + 4);
    puVar14 = puVar14 + 1;
  } while (apuStack_30[0] != (uint *)0x0);
  FUN_005f58a0(param_1_00 + 0x518);
  fVar3 = fStack_34;
  if (uStack_10 < _DAT_006ed050 != (NAN(uStack_10) || NAN(_DAT_006ed050))) {
    fStack_34 = (float)(param_1_00 + 0x518);
    FUN_005f5890(fStack_34);
    puVar14 = *(uint **)(param_1_00 + 0x514);
    puVar18 = *ppuVar1;
    apuStack_30[0] = (uint *)0x2;
    puVar16 = &uStack_10;
    do {
      uVar12 = *puVar18;
      uVar4 = *puVar14;
      puVar18 = puVar18 + 1;
      puVar14 = puVar14 + 1;
      *(uint *)puVar16 = uVar12 ^ uVar4;
      apuStack_30[0] = (uint *)((int)apuStack_30[0] + -1);
      puVar16 = (undefined8 *)((int)puVar16 + 4);
    } while (apuStack_30[0] != (uint *)0x0);
    FUN_005f58a0(fStack_34);
    fVar3 = (float)uStack_10 * (float)_DAT_006ef720 * _DAT_006f47c0;
  }
  if ((((byte)*(undefined4 *)(iVar10 + 0x548) & 0x20) != 0x20) ||
     (*(float *)(iVar10 + 0x554) <= _DAT_006ea454)) {
    fVar6 = *(float *)(iVar10 + 0x484) / *(float *)(iVar10 + 0x438);
    fVar5 = _DAT_006e97d8;
    if ((fVar6 <= _DAT_006e97d8) &&
       (fVar5 = fVar6, fVar6 < _DAT_006ea454 != (NAN(fVar6) || NAN(_DAT_006ea454)))) {
      fVar5 = _DAT_006ea454;
    }
    *(undefined4 *)(iVar10 + 0x554) = 0;
    *(float *)(iVar10 + 0x500) = fVar5 * fVar3;
  }
  else {
    *(float *)(iVar10 + 0x500) = fVar3;
  }
  if ((*(float *)(iVar10 + 0x500) < _DAT_006f47bc !=
       (NAN(*(float *)(iVar10 + 0x500)) || NAN(_DAT_006f47bc))) &&
     (dVar25 = rndUniform(0), dVar24 = (double)*(float *)(iVar10 + 0x500) * (double)_DAT_006f47b8,
     dVar24 < dVar25 != (NAN(dVar24) || NAN(dVar25)))) {
    *(float *)(iVar10 + 0x554) = *(float *)(iVar10 + 0x554) * _DAT_006f47b4;
  }
  fVar5 = *(float *)(iVar10 + 0x438) * _DAT_006efb28;
  fStack_34 = *(float *)(iVar10 + 0x438) * _DAT_006ec744;
  fVar6 = *(float *)(*(int *)(iVar10 + 0x56a) + 0x34) * _DAT_006ed6c8;
  fVar3 = _DAT_006f47b0;
  if (*(float *)(iVar10 + 0x4a0) < fVar6 != (NAN(*(float *)(iVar10 + 0x4a0)) || NAN(fVar6))) {
    fVar3 = (*(float *)(iVar10 + 0x4a0) / fVar6) * _DAT_006f47b0;
  }
  fVar6 = _DAT_006ea44c * fVar3;
  if (*(float *)(iVar10 + 0x554) < _DAT_006f3fe8 ==
      (NAN(*(float *)(iVar10 + 0x554)) || NAN(_DAT_006f3fe8))) {
    fVar7 = fVar3;
    if ((*(float *)(iVar10 + 0x484) <= fVar5) &&
       (fVar7 = fVar6,
       *(float *)(iVar10 + 0x484) < fStack_34 == (NAN(*(float *)(iVar10 + 0x484)) || NAN(fStack_34))
       )) {
      fVar7 = ((fVar3 - fVar6) * (*(float *)(iVar10 + 0x484) - fStack_34)) / (fVar5 - fStack_34) +
              fVar6;
    }
    *(float *)(iVar10 + 0x4d0) =
         (fVar7 - *(float *)(iVar10 + 0x4d0)) * _DAT_006ee4c4 + *(float *)(iVar10 + 0x4d0);
  }
  else {
    fVar6 = *(float *)(iVar10 + 0x4d0) - _DAT_006f47ac * fVar3;
    *(float *)(iVar10 + 0x4d0) = fVar6;
    if (fVar6 < _DAT_006ea454 != (NAN(fVar6) || NAN(_DAT_006ea454))) {
      *(undefined4 *)(iVar10 + 0x4d0) = 0;
    }
  }
  if ((*(float *)(iVar10 + 0x4d0) < _DAT_006f47a8 !=
       (NAN(*(float *)(iVar10 + 0x4d0)) || NAN(_DAT_006f47a8))) &&
     (fVar5 < *(float *)(iVar10 + 0x484))) {
    *(float *)(iVar10 + 0x554) =
         (*(float *)(iVar10 + 0x4d0) / (fVar3 * _DAT_006ea504)) * *(float *)(iVar10 + 0x554);
  }
  ppuVar17 = (uint **)(iVar10 + 0x4a4);
  apuStack_30[0] =
       (uint *)((_DAT_006e97d8 - (_DAT_006e97d8 - *(float *)(iVar10 + 0x480)) * _DAT_006f47a4) *
                SQRT(*(float *)(iVar10 + 0x47c)) * _DAT_006ea698 + _DAT_006ea44c);
  uStack_40._0_4_ =
       (uint *)(param_1 / ((*(float *)(iVar10 + 0x4a0) + _DAT_006ea62c) * _DAT_006f47a0));
  afStack_28[0] = (float)(uint *)uStack_40 * *(float *)(iVar10 + 0x498);
  uStack_10._0_4_ = ppuVar17;
  FUN_005f5890(iVar10 + 0x4b0);
  FUN_00425e80(&fStack_34,*ppuVar17,*(undefined4 *)(iVar10 + 0x4ac),4);
  FUN_005f58a0(iVar10 + 0x4b0);
  uStack_20._0_4_ = fStack_34 + afStack_28[0];
  FUN_0051c3f0(&uStack_20);
  FUN_005f5890(iVar10 + 0x4b0);
  uStack_20._0_4_ = (float)(**ppuVar17 ^ **(uint **)(iVar10 + 0x4ac));
  FUN_005f58a0(iVar10 + 0x4b0);
  afStack_28[0] =
       *(float *)(iVar10 + 0x4d0) * _DAT_006f479c * ((float)uStack_20 - *(float *)(iVar10 + 0x478))
       * *(float *)(iVar10 + 0x43c) * (float)(uint *)uStack_40 * (float)apuStack_30[0];
  FUN_005f5890(iVar10 + 0x4b0);
  FUN_00425e80(&uStack_20,*ppuVar17,*(undefined4 *)(iVar10 + 0x4ac),4);
  FUN_005f58a0(iVar10 + 0x4b0);
  fStack_34 = (float)uStack_20 - afStack_28[0];
  FUN_0051c3f0(&fStack_34);
  ppuVar17 = (uint **)(iVar10 + 0x4d4);
  afStack_28[0] = param_1 / ((*(float *)(iVar10 + 0x49c) + _DAT_006ea62c) * _DAT_006f4798);
  uStack_40 = (double)CONCAT44(uStack_40._4_4_,afStack_28[0]);
  afStack_28[0] = afStack_28[0] * *(float *)(iVar10 + 0x494);
  appuStack_18[0] = ppuVar17;
  FUN_005f5890(iVar10 + 0x4e0);
  FUN_00425e80(&uStack_20,*ppuVar17,*(undefined4 *)(iVar10 + 0x4dc),4);
  FUN_005f58a0(iVar10 + 0x4e0);
  fStack_34 = (float)uStack_20 + afStack_28[0];
  FUN_0051c3f0(&fStack_34);
  FUN_005f5890(iVar10 + 0x4e0);
  uStack_20 = (double)CONCAT44(uStack_20._4_4_,**ppuVar17 ^ **(uint **)(iVar10 + 0x4dc));
  FUN_005f58a0(iVar10 + 0x4e0);
  afStack_28[0] =
       ((float)uStack_20 - *(float *)(iVar10 + 0x478)) *
       (*(float *)(iVar10 + 0x484) / *(float *)(iVar10 + 0x438)) * *(float *)(iVar10 + 0x440) *
       (float)(uint *)uStack_40 * (float)apuStack_30[0];
  FUN_005f5890(iVar10 + 0x4e0);
  FUN_00425e80(&uStack_20,*ppuVar17,*(undefined4 *)(iVar10 + 0x4dc),4);
  FUN_005f58a0(iVar10 + 0x4e0);
  apuStack_30[0] = (uint *)((float)uStack_20 - afStack_28[0]);
  FUN_0051c3f0(apuStack_30);
  fVar3 = *(float *)(iVar9 + 0x4c);
  if (_DAT_006ea454 < fVar3) {
    fVar3 = *(float *)(iVar10 + 0x4a0) - fVar3 * fVar3 * param_1 * _DAT_006e9824;
    *(float *)(iVar10 + 0x4a0) = fVar3;
    if (fVar3 < _DAT_006ea454 != (NAN(fVar3) || NAN(_DAT_006ea454))) {
      *(undefined4 *)(iVar10 + 0x4a0) = 0;
    }
  }
  fVar3 = *(float *)(iVar9 + 0x50);
  if (_DAT_006ea454 < fVar3) {
    fVar3 = *(float *)(iVar10 + 0x49c) - fVar3 * fVar3 * param_1 * _DAT_006efb28;
    *(float *)(iVar10 + 0x49c) = fVar3;
    if (fVar3 < _DAT_006ea454 != (NAN(fVar3) || NAN(_DAT_006ea454))) {
      *(undefined4 *)(iVar10 + 0x49c) = 0;
    }
  }
  fVar3 = *(float *)(iVar9 + 0x54);
  if (_DAT_006ea454 < fVar3) {
    uStack_20 = (double)CONCAT44(uStack_20._4_4_,
                                 fVar3 * fVar3 * param_1 * _DAT_006ee598 * _DAT_006f4714);
    FUN_005f5890(param_1_00 + 0x518);
    fStack_34 = 2.802597e-45;
    apuStack_30[0] = *(uint **)(param_1_00 + 0x514);
    pfVar15 = afStack_28;
    puVar14 = *ppuVar1;
    do {
      *pfVar15 = (float)(*apuStack_30[0] ^ *puVar14);
      apuStack_30[0] = apuStack_30[0] + 1;
      fStack_34 = (float)((int)fStack_34 + -1);
      pfVar15 = pfVar15 + 1;
      puVar14 = puVar14 + 1;
    } while (fStack_34 != 0.0);
    FUN_005f58a0(param_1_00 + 0x518);
    uStack_40 = (double)((float)(double)CONCAT44(afStack_28[1],afStack_28[0]) - (float)uStack_20);
    FUN_0040bde0(&uStack_40);
    FUN_005f5890(param_1_00 + 0x518);
    fStack_34 = 2.802597e-45;
    apuStack_30[0] = *ppuVar1;
    puVar16 = &uStack_20;
    puVar14 = *(uint **)(param_1_00 + 0x514);
    do {
      *(uint *)puVar16 = *apuStack_30[0] ^ *puVar14;
      apuStack_30[0] = apuStack_30[0] + 1;
      fStack_34 = (float)((int)fStack_34 + -1);
      puVar16 = (undefined8 *)((int)puVar16 + 4);
      puVar14 = puVar14 + 1;
    } while (fStack_34 != 0.0);
    FUN_005f58a0(param_1_00 + 0x518);
    if (uStack_20 < _DAT_006ea4b0 != (NAN(uStack_20) || NAN(_DAT_006ea4b0))) {
      afStack_28[0] = 0.0;
      afStack_28[1] = 0.0;
      uStack_20 = (double)CONCAT44(uStack_20._4_4_,param_1_00 + 0x518);
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
      ppuVar20 = (uint **)*ppuVar1;
      do {
        if (iVar10 == 0) break;
        iVar10 = iVar10 + -1;
        bVar8 = *ppuVar17 == *ppuVar20;
        ppuVar17 = ppuVar17 + 1;
        ppuVar20 = ppuVar20 + 1;
      } while (bVar8);
      if (!bVar8) {
        do {
          DAT_00f7212c = FUN_005cfcfc();
        } while (DAT_00f7212c == 0);
      }
      uVar12 = FUN_005cfcfc();
      if ((uVar12 & 0x3f) == 0) {
        puVar21 = *(undefined4 **)(param_1_00 + 0x514);
        apuStack_30[0] = (uint *)0x2;
        do {
          uVar13 = FUN_005cfcfc();
          *puVar21 = uVar13;
          puVar21 = puVar21 + 1;
          apuStack_30[0] = (uint *)((int)apuStack_30[0] + -1);
        } while (apuStack_30[0] != (uint *)0x0);
      }
      puVar14 = *(uint **)(param_1_00 + 0x514);
      pfVar15 = afStack_28;
      apuStack_30[0] = (uint *)0x2;
      puVar18 = *ppuVar1;
      do {
        fVar3 = *pfVar15;
        uVar12 = *puVar14;
        pfVar15 = pfVar15 + 1;
        puVar14 = puVar14 + 1;
        *puVar18 = (uint)fVar3 ^ uVar12;
        apuStack_30[0] = (uint *)((int)apuStack_30[0] + -1);
        puVar18 = puVar18 + 1;
      } while (apuStack_30[0] != (uint *)0x0);
      puVar14 = *ppuVar1;
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
        puVar14 = (uint *)FUN_0051c850(*ppuVar1);
        *ppuVar1 = puVar14;
      }
      uVar12 = FUN_005cfcfc();
      if ((uVar12 & 0x7ff) == 0) {
        uVar13 = FUN_0051c850(*(undefined4 *)(param_1_00 + 0x510));
        *(undefined4 *)(param_1_00 + 0x510) = uVar13;
      }
      FUN_005f58a0((float)uStack_20);
      iVar10 = (int)local_38;
      ppuVar17 = appuStack_18[0];
    }
  }
  local_38 = param_1 + *(float *)(iVar10 + 0x558);
  *(float *)(iVar10 + 0x558) = local_38;
  if ((bVar22) && (_DAT_006e9824 < local_38)) {
    fVar3 = (*(float *)(iVar10 + 0x494) + *(float *)(iVar10 + 0x498)) * _DAT_006f4790;
    fVar3 = fVar3 * fVar3;
    uStack_40 = (double)CONCAT44(uStack_40._4_4_,fVar3);
    if (fVar3 <= _DAT_006e97d8) {
      if (fVar3 < _DAT_006ef640 != (NAN(fVar3) || NAN(_DAT_006ef640))) {
        uStack_40 = (double)CONCAT44(uStack_40._4_4_,0x3e99999a);
      }
    }
    else {
      uStack_40 = (double)CONCAT44(uStack_40._4_4_,0x3f800000);
    }
    fStack_4c = (float)(uint *)uStack_40 * local_38 * _DAT_006f4794;
    if ((_DAT_006ea508 < fVar2) &&
       (fVar3 = *(float *)(iVar10 + 0x438) * _DAT_006ea504,
       fVar3 < *(float *)(iVar10 + 0x484) != (NAN(fVar3) || NAN(*(float *)(iVar10 + 0x484))))) {
      fStack_4c = local_38 * fVar2 * _DAT_006f478c + fStack_4c;
    }
    FUN_005f5890(ppuVar17 + 3);
    appuStack_18[0] = (uint **)(**ppuVar17 ^ *ppuVar17[2]);
    FUN_005f58a0(ppuVar17 + 3);
    if (_DAT_006ee5a4 < (float)appuStack_18[0]) {
      appuStack_18[0] = ppuVar17 + 3;
      FUN_005f5890(appuStack_18[0]);
      uStack_20 = (double)CONCAT44(uStack_20._4_4_,*ppuVar17[2] ^ **ppuVar17);
      FUN_005f58a0(appuStack_18[0]);
      fVar3 = ((float)uStack_20 - _DAT_006ee5a4) * _DAT_006ee390;
      fStack_4c = *(float *)(iVar10 + 0x558) * _DAT_006f4788 * fVar3 * fVar3 + fStack_4c;
    }
    ppuVar1 = (uint **)uStack_10;
    FUN_005f5890((uint **)uStack_10 + 3);
    uStack_10._0_4_ = (uint **)(**ppuVar1 ^ *ppuVar1[2]);
    FUN_005f58a0(ppuVar1 + 3);
    if (_DAT_006f4784 < (float)(uint **)uStack_10) {
      uStack_10._0_4_ = ppuVar1 + 3;
      FUN_005f5890((uint **)uStack_10);
      appuStack_18[0] = (uint **)(**ppuVar1 ^ *ppuVar1[2]);
      FUN_005f58a0((uint **)uStack_10);
      fVar3 = ((float)appuStack_18[0] - _DAT_006f4784) * _DAT_006ee390;
      fStack_4c = *(float *)(iVar10 + 0x558) * _DAT_006f4788 * fVar3 * fVar3 + fStack_4c;
    }
    fVar3 = *(float *)(iVar10 + 0x438) * _DAT_006f4780 + _DAT_006ed00c;
    if (fVar3 < *(float *)(iVar10 + 0x484) == (NAN(fVar3) || NAN(*(float *)(iVar10 + 0x484)))) {
      *(float *)(iVar10 + 0x508) = *(float *)(iVar10 + 0x508) - *(float *)(iVar10 + 0x558);
    }
    else {
      *(float *)(iVar10 + 0x508) = *(float *)(iVar10 + 0x508) + *(float *)(iVar10 + 0x558);
      fVar3 = (*(float *)(iVar10 + 0x484) - fVar3) *
              (_DAT_006e97d8 / (*(float *)(iVar10 + 0x438) * _DAT_006f477c - fVar3));
      if (_DAT_006e97d8 < fVar3) {
        fVar3 = _DAT_006e97d8;
      }
      fVar3 = fVar3 * (float)(uint *)uStack_40;
      fStack_4c = *(float *)(iVar10 + 0x558) * _DAT_006ea478 * fVar3 * fVar3 * fVar3 + fStack_4c;
    }
    fVar3 = _DAT_006ea454;
    if ((*(float *)(iVar10 + 0x508) < _DAT_006ea454 ==
         (NAN(*(float *)(iVar10 + 0x508)) || NAN(_DAT_006ea454))) &&
       (fVar3 = _DAT_006ed000, *(float *)(iVar10 + 0x508) <= _DAT_006ed000)) {
      fVar3 = *(float *)(iVar10 + 0x508);
    }
    *(float *)(iVar10 + 0x508) = fVar3;
    fStack_4c = *(float *)(iVar10 + 0x558) * _DAT_006ea4cc * fVar3 * _DAT_006ea4cc + fStack_4c;
    fVar3 = *(float *)(iVar10 + 0x438) * _DAT_006efb28;
    uStack_40 = (double)CONCAT44(uStack_40._4_4_,fVar3);
    if ((*(float *)(iVar10 + 0x4d0) < _DAT_006f47b0 !=
         (NAN(*(float *)(iVar10 + 0x4d0)) || NAN(_DAT_006f47b0))) &&
       (fVar3 < *(float *)(iVar10 + 0x484))) {
      fVar5 = _DAT_006e97d8 - *(float *)(iVar10 + 0x4d0) * _DAT_006f479c;
      fVar3 = (*(float *)(iVar10 + 0x484) - fVar3) / (*(float *)(iVar10 + 0x438) - fVar3);
      if (_DAT_006e97d8 < fVar3) {
        fVar3 = _DAT_006e97d8;
      }
      fStack_4c = *(float *)(iVar10 + 0x558) * _DAT_006f21d4 * fVar3 * fVar3 * fVar5 * fVar5 +
                  fStack_4c;
    }
    fVar3 = _DAT_006ea454;
    if ((*(byte *)(iVar9 + 0xf) & 1) != 0) {
      fVar3 = *(float *)(iVar9 + 0x54);
    }
    if (_DAT_006ea454 < fVar3) {
      fStack_4c = *(float *)(iVar10 + 0x558) * _DAT_006f4778 * fVar3 + fStack_4c;
    }
    *(float *)(iVar10 + 0x55c) =
         (*(float *)(iVar10 + 0x558) / fStack_4c) * *(float *)(iVar10 + 0x46c);
    dVar24 = rndUniform(0);
    dVar24 = dVar24 * (double)*(float *)(iVar10 + 0x46c);
    if (dVar24 < (double)fStack_4c != (NAN(dVar24) || NAN((double)fStack_4c))) {
      dVar24 = rndUniform(0);
      fStack_4c = (float)dVar24 * (float)_DAT_006f4770 + _DAT_006ea504;
      if (_DAT_006e97d8 < fStack_4c) {
        fStack_4c = 1.0;
      }
      appuStack_18[0] = (uint **)(**(code **)(**(int **)(iVar10 + 0x56e) + 8))();
      apuStack_30[0] = (uint *)(fStack_4c + fVar2);
      if (_DAT_006e97d8 <= (float)apuStack_30[0]) {
        *(undefined4 *)(iVar10 + 0x554) = 0;
        apuStack_30[0] = (uint *)0x3f800000;
        if (*(char *)(*(int *)(iVar10 + 0x56e) + 0x59b) == '\0') {
          uStack_10._0_4_ = (uint **)0x0;
          uStack_10._4_4_ = 0x40000000;
          rndNormal(0);
          fVar23 = (float10)FUN_006c5c40();
          uStack_10._0_4_ = (uint **)(float)fVar23;
          fVar23 = (float10)FUN_005677d1(iVar10 + 0x224,*(undefined4 *)(iVar10 + 0x438));
          *(float *)(iVar10 + 0x560) = (float)(fVar23 * (float10)(float)(uint **)uStack_10);
        }
      }
      FUN_0054b5a0(apuStack_30[0]);
      bVar8 = inServer();
      if ((bVar8) && (*(char *)(*(int *)(iVar10 + 0x56e) + 0x59b) != '\0')) {
        FUN_0052e270(iVar9,appuStack_18[0]);
      }
      (**(code **)(**(int **)(iVar10 + 0x56e) + 0xc))();
    }
    *(undefined4 *)(iVar10 + 0x558) = 0;
  }
  fVar2 = *(float *)(iVar10 + 0x474) * *(float *)(iVar10 + 0x554) * _DAT_006efac4;
  *(float *)(iVar10 + 0x554) = fVar2;
  if (!bVar22) {
    return;
  }
  if (fVar2 < _DAT_006f3fe8 == (NAN(fVar2) || NAN(_DAT_006f3fe8))) {
    apuStack_30[0] =
         (uint *)(*(float *)(iVar10 + 0x498) * _DAT_006ea44c + *(float *)(iVar10 + 0x494));
    if ((float)apuStack_30[0] <= _DAT_006f476c) {
      apuStack_30[0] = (uint *)0x45b09000;
    }
    fStack_34 = *(float *)(iVar10 + 0x484);
    if (fStack_34 < _DAT_006ecff8) {
      fStack_34 = 300.0;
    }
    FUN_00551e10(apuStack_30[0],fStack_34);
    return;
  }
  FUN_00551e10(0,0x43160000);
  return;
}

