/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00541a30 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_00541a30(double *param_1_00,int *param_1)

{
  float fVar1;
  double dVar2;
  double dVar3;
  char cVar4;
  ushort uVar5;
  undefined4 uVar6;
  bool bVar7;
  int iVar8;
  int *piVar9;
  int iVar10;
  float *pfVar11;
  uint uVar12;
  undefined4 *puVar13;
  undefined4 *puVar14;
  double *pdVar15;
  undefined4 *puVar16;
  int *piVar17;
  float10 fVar18;
  double dVar19;
  undefined4 uVar20;
  undefined4 uVar21;
  undefined4 uVar22;
  undefined1 *puVar23;
  int *piStack_12c;
  double *pdStack_128;
  int iStack_120;
  float *pfStack_11c;
  int iStack_118;
  int iStack_114;
  int iStack_f0;
  int iStack_ec;
  int iStack_e8;
  int iStack_e4;
  int iStack_e0;
  int iStack_dc;
  undefined1 auStack_cc [4];
  double local_c8;
  undefined1 auStack_c0 [28];
  double dStack_a4;
  undefined4 auStack_9c [4];
  double adStack_8b [16];
  
  iVar8 = *(int *)((int)param_1 + 0x1fba);
  *(int *)((int)param_1 + 0x1fba) = iVar8 + -1;
  if (0 < iVar8) {
    return;
  }
  if (*(float *)((int)param_1 + 0x186a) < _DAT_006ee5b0) {
    *(undefined4 *)((int)param_1 + 0x1fba) = 1;
    return;
  }
  if ((char)param_1[0x7ee] != '\0') {
    *(undefined4 *)((int)param_1 + 0x1fba) = 1;
    return;
  }
  iVar8 = FUN_00544bf0();
  uVar22 = *(undefined4 *)((int)param_1 + 0x5b2);
  local_c8 = _DAT_006ed050 - (double)(*(uint *)(iVar8 + 0x50) & 3);
  piVar9 = (int *)FUN_00538ab0();
  (**(code **)(*piVar9 + 0x30))(uVar22);
  iVar8 = FUN_005443c0(uVar22);
  fVar18 = (float10)FUN_00516e1a();
  fVar18 = (float10)*(float *)((int)param_1 + 0x186a) / fVar18 + (float10)iVar8;
  *param_1_00 = (double)fVar18;
  if (fVar18 < (float10)_DAT_006ea4b0) {
    *(undefined4 *)param_1_00 = 0;
    *(undefined4 *)((int)param_1_00 + 4) = 0;
  }
  piVar9 = (int *)FUN_00538ab0();
  puVar23 = auStack_cc;
  (**(code **)(*piVar9 + 0x30))(puVar23);
  iVar8 = FUN_005443e0(puVar23);
  iVar10 = FUN_00509a00();
  fVar18 = (float10)FUN_00516e1a();
  param_1_00[1] =
       (double)((float10)(iVar10 - iVar8) - (float10)*(float *)((int)param_1 + 0x186a) / fVar18);
  pfVar11 = (float *)FUN_00536280(*(undefined4 *)((int)param_1 + 0x1397));
  fVar18 = (float10)FUN_00516e1a();
  fVar1 = *pfVar11;
  param_1_00[0xe] = (double)((float10)fVar1 / fVar18);
  fVar18 = (float10)FUN_006c503f((double)(((float10)*param_1_00 + (float10)_DAT_006e9808) -
                                         (float10)fVar1 / fVar18));
  param_1_00[0xf] = (double)(fVar18 + (float10)param_1_00[0xe]);
  param_1_00[0xc] =
       (double)((_DAT_006f5440 / *(float *)(*(int *)((int)param_1 + 0x58a) + 0x24)) * _DAT_006f5448
               * _DAT_006ee580);
  iVar8 = (**(code **)(*param_1 + 4))();
  iVar10 = 0;
  pfStack_11c = (float *)((int)param_1 + 0x1cce);
  *(undefined4 *)(param_1_00 + 2) = 0;
  *(undefined4 *)((int)param_1_00 + 0x14) = 0;
  bVar7 = false;
  pdVar15 = param_1_00 + 3;
  do {
    param_1_00[2] = (double)(*pfStack_11c + (float)param_1_00[2]);
    uVar5 = *(ushort *)(iVar8 + 2);
    *(undefined4 *)pdVar15 = 0;
    if (((uVar5 & 0xfff) >> ((char)iVar10 * '\x02' & 0x1fU) & 3) == 0) {
      *(undefined4 *)((int)pdVar15 + 4) = 0;
    }
    else {
      *(undefined4 *)((int)pdVar15 + 4) = 0x40340000;
      bVar7 = true;
    }
    iVar10 = iVar10 + 1;
    pdVar15 = pdVar15 + 1;
    pfStack_11c = pfStack_11c + 1;
  } while (iVar10 < 4);
  fVar1 = (float)param_1[0x879] * (float)param_1_00[2] * (float)_DAT_006ef6d0;
  param_1_00[2] = (double)fVar1;
  if (fVar1 < (float)_DAT_006ef6d8) {
    *(undefined4 *)(param_1_00 + 2) = 0xeb1c432d;
    *(undefined4 *)((int)param_1_00 + 0x14) = 0x3f1a36e2;
  }
  fVar1 = ((float)param_1[0x153] / *(float *)(*(int *)((int)param_1 + 0x58a) + 0x24)) *
          (float)param_1[0x878];
  param_1_00[7] = (double)fVar1;
  if (fVar1 < (float)_DAT_006ef6d8) {
    *(undefined4 *)(param_1_00 + 7) = 0xeb1c432d;
    *(undefined4 *)((int)param_1_00 + 0x3c) = 0x3f1a36e2;
  }
  dVar2 = param_1_00[7];
  if (param_1_00[7] < param_1_00[2]) {
    dVar2 = param_1_00[2];
  }
  param_1_00[0xd] = _DAT_006e9808 / dVar2 - _DAT_006ed078;
  FUN_00521000();
  fVar18 = (float10)FUN_00520fb0();
  param_1_00[0xb] = (double)(fVar18 * (float10)_DAT_006f5478);
  fVar18 = (float10)FUN_00521140();
  param_1_00[9] = (double)fVar18;
  fVar18 = (float10)FUN_00521150();
  param_1_00[10] = (double)fVar18;
  fVar18 = (float10)FUN_00401c20(param_1);
  param_1_00[8] = (double)fVar18;
  fVar1 = (float)_DAT_006e9830 - *(float *)((int)param_1 + 0x179e);
  param_1_00[0x10] = (double)(fVar1 * fVar1 * (float)_DAT_006ea668 + (float)_DAT_006ea668);
  if (*(char *)((int)param_1 + 0x1fb6) != '\0') {
    if (*(int *)((int)param_1 + 0x1db7) < 1) {
      puVar13 = (undefined4 *)((int)param_1 + 0x1e51);
      puVar14 = (undefined4 *)((int)param_1 + 0x1d9f);
      for (iVar8 = 0x2c; iVar8 != 0; iVar8 = iVar8 + -1) {
        *puVar14 = *puVar13;
        puVar13 = puVar13 + 1;
        puVar14 = puVar14 + 1;
      }
      *(undefined2 *)puVar14 = *(undefined2 *)puVar13;
      FUN_00541600();
    }
    *(undefined4 *)((int)param_1 + 0x1dbb) = *(undefined4 *)(param_1_00 + 0xf);
    *(undefined4 *)((int)param_1 + 0x1dbf) = *(undefined4 *)((int)param_1_00 + 0x7c);
    if (0 < *(int *)((int)param_1 + 0x1f1b)) {
      FUN_00541640(0,*(undefined4 *)(param_1_00 + 0xf),*(undefined4 *)((int)param_1_00 + 0x7c),
                   *(undefined4 *)((int)param_1 + 0x1dc3),*(undefined4 *)((int)param_1 + 0x1dc7),0,0
                  );
    }
    if (0 < *(int *)((int)param_1 + 0x1e69)) {
      FUN_00541640(0,*(undefined4 *)(param_1_00 + 0xf),*(undefined4 *)((int)param_1_00 + 0x7c),
                   *(undefined4 *)((int)param_1 + 0x1dc3),*(undefined4 *)((int)param_1 + 0x1dc7),0,0
                  );
    }
  }
  FUN_00542660(param_1,(int)param_1 + 0x1d9f);
  FUN_005429b0(param_1,(int)param_1 + 0x1d9f);
  FUN_00542660(param_1,(int)param_1 + 0x1f03);
  FUN_005429b0(param_1,(int)param_1 + 0x1f03);
  FUN_00542660(param_1,(int)param_1 + 0x1e51);
  FUN_005429b0(param_1,(int)param_1 + 0x1e51);
  dVar2 = param_1_00[1];
  dVar3 = *param_1_00;
  iStack_ec = 4;
  iStack_114 = 0;
  iStack_f0 = 0;
  iStack_e8 = 1;
  if (((param_1_00[8] <= _DAT_006f5470) &&
      ((_DAT_006ef6c8 <= param_1_00[8] || ((param_1_00[0xb] <= _DAT_006ef6c8 && (!bVar7)))))) ||
     (*(char *)((int)param_1 + 0x1fb6) != '\0')) {
    *(undefined1 *)((int)param_1 + 0x1fb9) = 0;
  }
  else {
    iStack_ec = 2;
    iStack_e8 = 3;
    if (param_1[0x875] != 0) {
      iStack_e8 = 2;
    }
    iStack_f0 = 1;
    if (*(char *)((int)param_1 + 0x1fb9) == '\0') {
      *(undefined1 *)((int)param_1 + 0x1fb9) = 1;
      FUN_00541820((int)param_1 + 0x1fbe,*(undefined4 *)((int)param_1 + 0x1db7),
                   param_1_00[0xd] + _DAT_006e9808,1);
      FUN_00541820(param_1 + 0x81c,*(undefined4 *)((int)param_1 + 0x1e69),
                   param_1_00[0xd] + _DAT_006e9808,1);
      FUN_00541820((int)param_1 + 0x2122,*(undefined4 *)((int)param_1 + 0x1f1b),
                   param_1_00[0xd] + _DAT_006e9808,1);
    }
    uVar22 = *(undefined4 *)((int)param_1 + 0x1dc7);
    uVar6 = *(undefined4 *)((int)param_1 + 0x1dc3);
    bVar7 = *(int *)((int)param_1 + 0x1fd6) < 1;
    if (bVar7) {
      FUN_00541640(0,*(undefined4 *)(param_1_00 + 0xf),*(undefined4 *)((int)param_1_00 + 0x7c),uVar6
                   ,uVar22,0,0);
      uVar21 = 0xbff00000;
      uVar20 = 0;
    }
    else {
      uVar21 = *(undefined4 *)((int)param_1_00 + 0x7c);
      uVar20 = *(undefined4 *)(param_1_00 + 0xf);
    }
    FUN_00541640(bVar7,uVar20,uVar21,uVar6,uVar22,0,0);
    if (0 < param_1[0x822]) {
      FUN_00541640(0,*(undefined4 *)(param_1_00 + 0xf),*(undefined4 *)((int)param_1_00 + 0x7c),uVar6
                   ,uVar22,0,0);
    }
    if (0 < *(int *)((int)param_1 + 0x213a)) {
      FUN_00541640(0,*(undefined4 *)(param_1_00 + 0xf),*(undefined4 *)((int)param_1_00 + 0x7c),uVar6
                   ,uVar22,0,0);
    }
    FUN_00542660(param_1,(int)param_1 + 0x1fbe);
    FUN_005429b0(param_1,(int)param_1 + 0x1fbe);
    FUN_00542660(param_1,(int)param_1 + 0x2122);
    FUN_005429b0(param_1,(int)param_1 + 0x2122);
    FUN_00542660(param_1,param_1 + 0x81c);
    FUN_005429b0(param_1,param_1 + 0x81c);
  }
  iStack_118 = 0;
  if (-1 < iStack_f0) {
    do {
      if (iStack_118 == 0) {
        iStack_dc = *(int *)((int)param_1 + 0x1db7);
        cVar4 = *(char *)((int)param_1 + 0x1fb6);
      }
      else {
        iStack_dc = *(int *)((int)param_1 + 0x1fd6);
        cVar4 = '\x01';
      }
      iStack_e4 = 0;
      do {
        if (iStack_e4 == 1) {
          iVar8 = iStack_dc + -1;
        }
        else {
          iVar8 = iStack_dc;
          if (iStack_e4 == 2) {
            iVar8 = iStack_dc + 1;
          }
        }
        pfStack_11c = (float *)iVar8;
        if (4 < iVar8) {
          pfStack_11c = (float *)0x5;
        }
        if (iVar8 == iStack_dc) {
          if (iStack_118 == 0) {
            pdStack_128 = (double *)((int)param_1 + 0x1d9f);
          }
          else {
            pdStack_128 = (double *)((int)param_1 + 0x1fbe);
          }
        }
        else {
          if (iVar8 < iStack_dc) {
            if (iStack_118 == 0) {
              pdStack_128 = (double *)((int)param_1 + 0x1f03);
            }
            else {
              pdStack_128 = (double *)((int)param_1 + 0x2122);
            }
          }
          else {
            pdStack_128 = (double *)(param_1 + 0x81c);
            if (iStack_118 == 0) {
              pdStack_128 = (double *)((int)param_1 + 0x1e51);
            }
          }
          if (*(int *)(pdStack_128 + 3) != iVar8) {
            FUN_00541820(pdStack_128,iVar8,param_1_00[0xd] + _DAT_006e9808,cVar4);
          }
        }
        uVar22 = *(undefined4 *)(pdStack_128 + 5);
        uVar6 = *(undefined4 *)((int)pdStack_128 + 0x24);
        if (-1 < iVar8) {
          if ((int)(uint)(cVar4 != '\0') < iVar8) {
            if (0 < iVar8) {
              iStack_120 = iStack_ec;
              if (iStack_118 != 0) {
                iStack_120 = iStack_e8;
              }
              if (iStack_120 != 0) {
                uVar12 = (uint)(cVar4 != '\0');
                do {
                  pdVar15 = pdStack_128;
                  puVar13 = (undefined4 *)auStack_c0;
                  for (iVar8 = 0x2c; iVar8 != 0; iVar8 = iVar8 + -1) {
                    *puVar13 = *(undefined4 *)pdVar15;
                    pdVar15 = (double *)((int)pdVar15 + 4);
                    puVar13 = puVar13 + 1;
                  }
                  *(undefined2 *)puVar13 = *(undefined2 *)pdVar15;
                  if ((int)uVar12 <= (int)pfStack_11c) {
                    iVar8 = ((int)pfStack_11c - uVar12) + 1;
                    puVar13 = (undefined4 *)((int)auStack_9c + uVar12 * 0x19);
                    do {
                      *puVar13 = uVar6;
                      puVar13[1] = uVar22;
                      puVar13 = (undefined4 *)((int)puVar13 + 0x19);
                      iVar8 = iVar8 + -1;
                    } while (iVar8 != 0);
                  }
                  if (cVar4 == '\0') {
                    rndUniform(0);
                    iVar8 = FUN_006c5018();
                  }
                  else {
                    rndUniform(0);
                    iVar8 = FUN_006c5018();
                    iVar8 = iVar8 + 1;
                  }
                  iStack_e0 = 10;
                  iVar10 = iVar8 * 0x19;
                  pdVar15 = (double *)((int)&dStack_a4 + iVar10);
                  do {
                    dVar19 = rndUniform(0);
                    fVar18 = (float10)FUN_006c503f((((dVar19 + dVar19) - _DAT_006e9808) * local_c8 +
                                                    *pdVar15 + _DAT_006e9808) - param_1_00[0xe]);
                    fVar18 = fVar18 + (float10)param_1_00[0xe];
                    if (iVar8 < (int)pfStack_11c + -1) {
                      if ((float10)*(double *)((int)adStack_8b + iVar10) <= fVar18) {
                        dVar19 = *(double *)((int)adStack_8b + iVar10);
LAB_00542331:
                        fVar18 = (float10)dVar19 - (float10)_DAT_006e9808;
                      }
                    }
                    else {
                      dVar19 = dVar2 + dVar3;
                      if ((float10)(dVar2 + dVar3) <= fVar18) goto LAB_00542331;
                    }
                    if (iVar8 < 1) {
                      if (fVar18 < (float10)param_1_00[0xf]) {
                        fVar18 = (float10)param_1_00[0xf];
                      }
                    }
                    else if (fVar18 < (float10)*(double *)(auStack_c0 + iVar10 + 3) !=
                             (fVar18 == (float10)*(double *)(auStack_c0 + iVar10 + 3))) {
                      fVar18 = (float10)*(double *)(auStack_c0 + iVar10 + 3) +
                               (float10)_DAT_006e9808;
                    }
                  } while ((fVar18 == (float10)*pdVar15) &&
                          (bVar7 = 0 < iStack_e0, iStack_e0 = iStack_e0 + -1, bVar7));
                  *pdVar15 = (double)fVar18;
                  FUN_00542660(param_1,auStack_c0);
                  FUN_005429b0(param_1,auStack_c0);
                  iStack_114 = iStack_114 + 1;
                  if ((double)auStack_c0._0_8_ < *pdStack_128) {
                    puVar13 = (undefined4 *)auStack_c0;
                    pdVar15 = pdStack_128;
                    for (iVar8 = 0x2c; iVar8 != 0; iVar8 = iVar8 + -1) {
                      *(undefined4 *)pdVar15 = *puVar13;
                      puVar13 = puVar13 + 1;
                      pdVar15 = (double *)((int)pdVar15 + 4);
                    }
                    *(undefined2 *)pdVar15 = *(undefined2 *)puVar13;
                  }
                  if (99 < iStack_114) goto LAB_00542405;
                  iStack_120 = iStack_120 + -1;
                } while (0 < iStack_120);
              }
            }
          }
          else {
            pdVar15 = pdStack_128;
            puVar13 = (undefined4 *)auStack_c0;
            for (iVar10 = 0x2c; iVar10 != 0; iVar10 = iVar10 + -1) {
              *puVar13 = *(undefined4 *)pdVar15;
              pdVar15 = (double *)((int)pdVar15 + 4);
              puVar13 = puVar13 + 1;
            }
            *(undefined2 *)puVar13 = *(undefined2 *)pdVar15;
            if (cVar4 == '\0') {
              auStack_9c[0] = uVar6;
              auStack_9c[1] = uVar22;
            }
            if (iVar8 < 1) {
              FUN_00542b70(param_1,auStack_c0);
            }
            else {
              FUN_00542660(param_1,auStack_c0);
              FUN_005429b0(param_1,auStack_c0);
            }
            iStack_114 = iStack_114 + 1;
            if ((double)auStack_c0._0_8_ < *pdStack_128) {
              puVar13 = (undefined4 *)auStack_c0;
              for (iVar8 = 0x2c; iVar8 != 0; iVar8 = iVar8 + -1) {
                *(undefined4 *)pdStack_128 = *puVar13;
                puVar13 = puVar13 + 1;
                pdStack_128 = (double *)((int)pdStack_128 + 4);
              }
              *(undefined2 *)pdStack_128 = *(undefined2 *)puVar13;
            }
          }
        }
      } while ((iStack_114 < 100) && (iStack_e4 = iStack_e4 + 1, iStack_e4 < 3));
LAB_00542405:
      iStack_118 = iStack_118 + 1;
    } while (iStack_118 <= iStack_f0);
  }
  if ((((*(char *)((int)param_1 + 0x1fb6) != '\0') && (*(int *)((int)param_1 + 0x1f1b) < 1)) ||
      (*(double *)((int)param_1 + 0x1d9f) - _DAT_006e9808 <= *(double *)((int)param_1 + 0x1f03))) ||
     (*(double *)((int)param_1 + 0x1e51) <= *(double *)((int)param_1 + 0x1f03))) {
    if (((*(char *)((int)param_1 + 0x1fb6) != '\0') && (*(int *)((int)param_1 + 0x1e69) < 1)) ||
       ((*(double *)((int)param_1 + 0x1d9f) - _DAT_006e9808 <= *(double *)((int)param_1 + 0x1e51) ||
        (*(double *)((int)param_1 + 0x1f03) <= *(double *)((int)param_1 + 0x1e51)))))
    goto LAB_005424e9;
    puVar13 = (undefined4 *)((int)param_1 + 0x1f03);
    puVar14 = (undefined4 *)((int)param_1 + 0x1e51);
  }
  else {
    puVar13 = (undefined4 *)((int)param_1 + 0x1e51);
    puVar14 = (undefined4 *)((int)param_1 + 0x1f03);
  }
  puVar16 = (undefined4 *)((int)param_1 + 0x1d9f);
  for (iVar8 = 0x2c; iVar8 != 0; iVar8 = iVar8 + -1) {
    *puVar13 = *puVar16;
    puVar16 = puVar16 + 1;
    puVar13 = puVar13 + 1;
  }
  *(undefined2 *)puVar13 = *(undefined2 *)puVar16;
  puVar13 = (undefined4 *)((int)param_1 + 0x1d9f);
  for (iVar8 = 0x2c; iVar8 != 0; iVar8 = iVar8 + -1) {
    *puVar13 = *puVar14;
    puVar14 = puVar14 + 1;
    puVar13 = puVar13 + 1;
  }
  *(undefined2 *)puVar13 = *(undefined2 *)puVar14;
  FUN_00541600();
LAB_005424e9:
  if (*(char *)((int)param_1 + 0x1fb9) != '\0') {
    if ((((0 < *(int *)((int)param_1 + 0x213a)) &&
         (pdVar15 = (double *)((int)param_1 + 0x2122),
         *(double *)((int)param_1 + 0x2122) < *(double *)((int)param_1 + 0x1fbe) - _DAT_006e9808))
        && (piVar9 = param_1 + 0x81c, *pdVar15 < *(double *)(param_1 + 0x81c))) ||
       (((0 < param_1[0x822] &&
         (pdVar15 = (double *)(param_1 + 0x81c),
         *(double *)(param_1 + 0x81c) < *(double *)((int)param_1 + 0x1fbe) - _DAT_006e9808)) &&
        (piVar9 = (int *)((int)param_1 + 0x2122), *pdVar15 < *(double *)((int)param_1 + 0x2122)))))
    {
      piStack_12c = (int *)((int)param_1 + 0x1fbe);
      piVar17 = piStack_12c;
      for (iVar8 = 0x2c; iVar8 != 0; iVar8 = iVar8 + -1) {
        *piVar9 = *piVar17;
        piVar17 = piVar17 + 1;
        piVar9 = piVar9 + 1;
      }
      *(short *)piVar9 = (short)*piVar17;
      for (iVar8 = 0x2c; iVar8 != 0; iVar8 = iVar8 + -1) {
        *piStack_12c = *(int *)pdVar15;
        pdVar15 = (double *)((int)pdVar15 + 4);
        piStack_12c = piStack_12c + 1;
      }
      *(undefined2 *)piStack_12c = *(undefined2 *)pdVar15;
      FUN_00541600();
    }
    iVar8 = *(int *)((int)param_1 + 0x5b2);
    iVar10 = FUN_00538ae0();
    if (((*(char *)(iVar10 + 0xfb + iVar8) != '\0') || (_DAT_006ef6c8 < param_1_00[0xb])) &&
       (*(double *)((int)param_1 + 0x1fbe) < *(double *)((int)param_1 + 0x1d9f) - _DAT_006e9808)) {
      *(undefined1 *)((int)param_1 + 0x1fb9) = 0;
      puVar13 = (undefined4 *)((int)param_1 + 0x1fbe);
      puVar14 = (undefined4 *)((int)param_1 + 0x1d9f);
      for (iVar8 = 0x2c; iVar8 != 0; iVar8 = iVar8 + -1) {
        *puVar14 = *puVar13;
        puVar13 = puVar13 + 1;
        puVar14 = puVar14 + 1;
      }
      *(undefined2 *)puVar14 = *(undefined2 *)puVar13;
      *(undefined1 *)((int)param_1 + 0x1fb6) = 1;
      puVar13 = (undefined4 *)((int)param_1 + 0x2122);
      puVar14 = (undefined4 *)((int)param_1 + 0x1f03);
      for (iVar8 = 0x2c; iVar8 != 0; iVar8 = iVar8 + -1) {
        *puVar14 = *puVar13;
        puVar13 = puVar13 + 1;
        puVar14 = puVar14 + 1;
      }
      *(undefined2 *)puVar14 = *(undefined2 *)puVar13;
      piVar9 = param_1 + 0x81c;
      piVar17 = (int *)((int)param_1 + 0x1e51);
      for (iVar8 = 0x2c; iVar8 != 0; iVar8 = iVar8 + -1) {
        *piVar17 = *piVar9;
        piVar9 = piVar9 + 1;
        piVar17 = piVar17 + 1;
      }
      *(short *)piVar17 = (short)*piVar9;
    }
  }
  *(undefined4 *)((int)param_1 + 0x1fba) = 4;
  return;
}


