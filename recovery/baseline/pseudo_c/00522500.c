/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00522500 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: stack */

void __thiscall FUN_00522500(float *param_1_00,undefined4 param_1,undefined4 param_2)

{
  ushort uVar1;
  ushort uVar2;
  float fVar3;
  float fVar4;
  char cVar5;
  undefined1 uVar6;
  char cVar7;
  uint uVar8;
  undefined2 extraout_var;
  int iVar9;
  int iVar10;
  int *piVar11;
  int iVar12;
  undefined1 *puVar13;
  float *pfVar14;
  float10 fVar15;
  float10 fVar16;
  undefined4 uVar17;
  undefined1 uStack_39;
  float fStack_38;
  float fStack_34;
  float fStack_30;
  float fStack_2c;
  float fStack_28;
  float local_24;
  double local_20;
  float fStack_18;
  float fStack_14;
  float fStack_10;
  float fStack_c;
  float fStack_8;
  float fStack_4;
  
  FUN_005215c0();
  FUN_00520170();
  local_24 = (float)taskGetRate();
  *(undefined4 *)((int)param_1_00 + 0xbd) = param_1;
  *(undefined4 *)((int)param_1_00 + 0xc1) = param_2;
  fVar3 = _DAT_006e97d8 / (float)(int)local_24;
  *(float *)((int)param_1_00 + 0xaf) = fVar3;
  uVar1 = (ushort)(*(float *)((int)param_1_00 + 0xc5) < _DAT_006ea454);
  uVar2 = (ushort)(*(float *)((int)param_1_00 + 0xc5) == _DAT_006ea454);
  uVar8 = (uint)(ushort)(uVar1 << 8 | uVar2 << 0xe);
  if (uVar1 == 0 && uVar2 == 0) {
    *(float *)((int)param_1_00 + 0xc5) = *(float *)((int)param_1_00 + 0xc5) - fVar3;
    iVar9 = *(int *)(*(int *)((int)param_1_00 + 0x89) + 0x5ae);
    uVar8 = 0;
    if (iVar9 != 0) {
      fVar15 = (float10)FUN_00516d3a(*(undefined4 *)(iVar9 + 0x3c),param_1_00[0xf]);
      local_20 = (double)ABS(fVar15);
      fVar16 = (float10)FUN_00516e1a();
      fVar16 = fVar16 * (float10)_DAT_006ea50c;
      fVar15 = (float10)local_20;
      uVar8 = CONCAT22(extraout_var,
                       (ushort)(fVar16 < fVar15) << 8 | (ushort)(NAN(fVar16) || NAN(fVar15)) << 10 |
                       (ushort)(fVar16 == fVar15) << 0xe);
      if (fVar16 < fVar15) {
        *(undefined4 *)((int)param_1_00 + 0xc5) = 0;
      }
    }
  }
  if (*(char *)((int)param_1_00 + 0x8d) != '\0') {
    FUN_005500b0(CONCAT31((int3)(uVar8 >> 8),*(undefined1 *)((int)param_1_00 + 0x8e)));
    iVar9 = (**(code **)(**(int **)((int)param_1_00 + 0x89) + 4))();
    cVar5 = '\0';
    pfVar14 = (float *)&DAT_00bf3cc0;
    do {
      if ((*pfVar14 < _DAT_006ea4cc) ||
         (((*(ushort *)(iVar9 + 2) & 0xfff) >> (cVar5 * '\x02' & 0x1fU) & 3) != 0)) {
        if ((pfVar14 == (float *)&DAT_00bf3cc0) || (pfVar14 == (float *)&DAT_00bf5132)) {
          FUN_005234b0(1,0);
        }
        else {
          FUN_00523520(1,0);
        }
      }
      pfVar14 = (float *)((int)pfVar14 + 0xa39);
      cVar5 = cVar5 + '\x01';
    } while ((int)pfVar14 < 0xbf65a4);
  }
  if ((*(char *)(*(int *)((int)param_1_00 + 0x89) + 0x59b) != '\0') &&
     (cVar5 = FUN_00521990(), cVar5 != '\0')) {
    FUN_00521950();
  }
  iVar9 = 0;
  if (*(int *)((int)param_1_00 + 0x8f) == 0) {
    if (*(char *)((int)param_1_00 + 0x8d) == '\0') {
      iVar10 = FUN_00509b60(0xffffffff);
    }
    else {
      iVar10 = thunk_FUN_0055a730();
    }
    if (0 < iVar10) {
      if (iVar10 < 3) {
        return;
      }
      if (iVar10 == 6) {
        *(undefined1 *)((int)param_1_00 + 0x111) = 0;
        goto LAB_005226a7;
      }
    }
    *(undefined1 *)((int)param_1_00 + 0x111) = 1;
  }
LAB_005226a7:
  if (*(int *)((int)param_1_00 + 0x93) != 1) {
    if (*(char *)((int)param_1_00 + 0x8d) == '\0') {
      iVar10 = FUN_00509b60(0xffffffff);
      if (3 < iVar10) {
        uVar17 = *(undefined4 *)(*(int *)((int)param_1_00 + 0x89) + 0x5b2);
        FUN_00538ac0(uVar17);
        cVar5 = FUN_0053b6a0(uVar17);
        goto LAB_005226fa;
      }
    }
    else {
      iVar10 = thunk_FUN_0055a730();
      if (3 < iVar10) {
        FUN_00538b40();
        cVar5 = FUN_0053e360();
LAB_005226fa:
        if (cVar5 == '\0') {
          *(undefined1 *)((int)param_1_00 + 0x111) = 0;
        }
      }
    }
    cVar5 = FUN_00520f40();
    if (cVar5 != '\0') {
      *(undefined1 *)((int)param_1_00 + 0x111) = 0;
    }
  }
  if (_DAT_006ea454 < *(float *)((int)param_1_00 + 0xb3)) {
    fVar3 = *(float *)((int)param_1_00 + 0xb3) - *(float *)((int)param_1_00 + 0xaf);
    *(float *)((int)param_1_00 + 0xb3) = fVar3;
    if ((*(char *)((int)param_1_00 + 0xb7) != '\0') && (fVar3 < _DAT_006ea514)) {
      if (*(char *)((int)param_1_00 + 0x8d) == '\0') {
        param_1 = CONCAT31(param_1._1_3_,*(undefined1 *)(param_1_00 + 0x2e));
        uVar17 = *(undefined4 *)(*(int *)((int)param_1_00 + 0x89) + 0x5b2);
        piVar11 = (int *)FUN_00538ad0();
        (**(code **)(*piVar11 + 0x3c))(uVar17,&param_1);
      }
      else {
        piVar11 = (int *)FUN_00538b20();
        (**(code **)(*piVar11 + 0x40))(*(undefined1 *)(param_1_00 + 0x2e));
      }
      *(undefined1 *)((int)param_1_00 + 0xb7) = 0;
      *(undefined1 *)(param_1_00 + 0x2e) = 0;
    }
    if (*(float *)((int)param_1_00 + 0xb3) < _DAT_006ea454 ==
        (*(float *)((int)param_1_00 + 0xb3) == _DAT_006ea454)) {
      return;
    }
    *(undefined4 *)((int)param_1_00 + 0xb3) = 0;
    *(undefined1 *)((int)param_1_00 + 0x8e) = 0;
    FUN_00521ee0(1);
    FUN_00521f90();
    FUN_0040f100();
    *(undefined4 *)((int)param_1_00 + 0x8f) = 2;
    *(undefined1 *)(param_1_00 + 0x3f) = 0;
    *(undefined1 *)((int)param_1_00 + 0xfd) = 0;
    return;
  }
  if (*(char *)((int)param_1_00 + 0x10e) != '\0') {
    fVar3 = *(float *)((int)param_1_00 + 0xb9) - *(float *)((int)param_1_00 + 0xaf);
    *(float *)((int)param_1_00 + 0xb9) = fVar3;
    if (fVar3 < _DAT_006ea454) {
      *(undefined4 *)((int)param_1_00 + 0xb9) = 0;
    }
    uStack_39 = 0;
    if (*(char *)((int)param_1_00 + 0x8d) == '\0') {
      fVar15 = (float10)(**(code **)(*DAT_00bdb9d8 + 0x1c))
                                  (*(undefined4 *)(*(int *)((int)param_1_00 + 0x89) + 0x5b2),
                                   &uStack_39);
    }
    else {
      piVar11 = (int *)FUN_00538b40();
      fVar15 = (float10)(**(code **)(*piVar11 + 0x38))(&uStack_39);
    }
    fVar16 = (float10)_DAT_006ef6c8;
    if (*(char *)((int)param_1_00 + 0x8d) == '\0') {
      iVar10 = FUN_00509b60(0xffffffff);
      if (3 < iVar10) {
        uVar17 = *(undefined4 *)(*(int *)((int)param_1_00 + 0x89) + 0x5b2);
        FUN_00538ac0(uVar17);
        cVar5 = FUN_0053b6a0(uVar17);
        goto LAB_005228e0;
      }
LAB_005228e4:
      if (fVar16 <= fVar15) goto LAB_00522949;
    }
    else {
      iVar10 = thunk_FUN_0055a730();
      if (iVar10 < 4) goto LAB_005228e4;
      FUN_00538b40();
      cVar5 = FUN_0053e360();
LAB_005228e0:
      if (cVar5 != '\0') goto LAB_005228e4;
    }
    *(undefined1 *)((int)param_1_00 + 0x10e) = 0;
    cVar5 = FUN_00520f40();
    if (cVar5 == '\0') {
      *(undefined1 *)((int)param_1_00 + 0x8e) = 0;
      FUN_00521ee0(1);
      fVar15 = (float10)FUN_00516e1a();
      *(float *)((int)param_1_00 + 0xc5) = (float)(fVar15 * (float10)_DAT_006f4a34);
      if (*(char *)((int)param_1_00 + 0x8d) != '\0') {
        piVar11 = (int *)FUN_00538b40();
        (**(code **)(*piVar11 + 0x2c))(0,1);
        FUN_00538b20();
        FUN_00540880();
      }
    }
    *(char *)((int)param_1_00 + 0xb3e) = *(char *)((int)param_1_00 + 0xb3e) + '\x01';
  }
LAB_00522949:
  if (*(char *)(param_1_00 + 0x22) != '\0') {
    if (*(char *)((int)param_1_00 + 0x8d) == '\0') {
      iVar10 = FUN_005099b0();
    }
    else {
      iVar10 = FUN_00567280();
    }
    if ((((iVar10 != 7) || (*(int *)(*(int *)((int)param_1_00 + 0x89) + 0x5ae) == 0)) ||
        (cVar5 = FUN_00535410(*(int *)((int)param_1_00 + 0x89)), cVar5 != '\0')) ||
       (cVar5 = FUN_00535440(*(undefined4 *)((int)param_1_00 + 0x89)), cVar5 != '\0')) {
      if (*(char *)((int)param_1_00 + 0x8d) == '\0') {
        FUN_00523ac0(&DAT_00bd64e8 + *(int *)(*(int *)((int)param_1_00 + 0x89) + 0x5b2) * 0x68);
        do {
          FUN_00523b00(&DAT_00bd44a8 +
                       (iVar9 + *(int *)(*(int *)((int)param_1_00 + 0x89) + 0x5b2) * 2) * 0x34,
                       (&DAT_0074ba58)[iVar9],0);
          iVar9 = iVar9 + 1;
        } while (iVar9 < 2);
        return;
      }
      FUN_00523ac0(&DAT_00bd2318);
      iVar10 = FUN_0040ecf0();
      if (iVar10 < 1) {
        return;
      }
      puVar13 = &DAT_00bd0ef0;
      do {
        FUN_00523b00(puVar13,iVar9,0);
        iVar9 = iVar9 + 1;
        puVar13 = puVar13 + 0x34;
        iVar10 = FUN_0040ecf0();
      } while (iVar9 < iVar10);
      return;
    }
    *(undefined1 *)(param_1_00 + 0x22) = 0;
  }
  iVar9 = *(int *)((int)param_1_00 + 0x89);
  *(undefined1 *)((int)param_1_00 + 0x81) = 0;
  fStack_38 = 0.0;
  fStack_30 = 1e+06;
  iVar10 = *(int *)(iVar9 + 0x5ae);
  fStack_2c = 1e+06;
  fStack_34 = 0.0;
  fStack_28 = 0.0;
  *(int *)((int)param_1_00 + 0x69) = iVar10;
  if (iVar10 == 0) {
    return;
  }
  if (*(char *)((int)param_1_00 + 0x86) == '\0') {
    fVar15 = (float10)fpatan((float10)*(float *)(*(int *)(iVar9 + 0x5ae) + 100),
                             (float10)*(float *)(*(int *)(iVar9 + 0x5ae) + 0x58));
    *(float *)((int)param_1_00 + 0x6d) = (float)fVar15;
    fVar15 = (float10)fcos(fVar15);
    *(float *)((int)param_1_00 + 0x71) = (float)fVar15;
    fVar15 = (float10)fsin((float10)*(float *)((int)param_1_00 + 0x6d));
    *(float *)((int)param_1_00 + 0x75) = (float)fVar15;
    *(undefined4 *)((int)param_1_00 + 0x79) = **(undefined4 **)((int)param_1_00 + 0x69);
    *(undefined4 *)((int)param_1_00 + 0x7d) = (*(undefined4 **)((int)param_1_00 + 0x69))[1];
  }
  cVar5 = *(char *)(param_1_00 + 0x44);
  *(undefined1 *)((int)param_1_00 + 0x81) = 1;
  uVar6 = FUN_00535440(iVar9);
  *(undefined1 *)(param_1_00 + 0x44) = uVar6;
  cVar7 = FUN_00535410(*(undefined4 *)((int)param_1_00 + 0x89));
  *(char *)((int)param_1_00 + 0x10f) = cVar7;
  if ((cVar5 != '\0') && (cVar7 != '\0')) {
    FUN_0040ee80();
  }
  if ((*(int *)((int)param_1_00 + 0x93) != 1) &&
     ((*(char *)((int)param_1_00 + 0x10f) != '\0' || (*(char *)(param_1_00 + 0x44) != '\0')))) {
    if (*(char *)((int)param_1_00 + 0x86) == '\0') {
      *(undefined4 *)((int)param_1_00 + 0x82) = 0;
    }
    else {
      *(undefined4 *)((int)param_1_00 + 0x82) = 0x3f800000;
    }
    fVar3 = _DAT_006ea454;
    pfVar14 = *(float **)((int)param_1_00 + 0x69);
    fStack_18 = *pfVar14 - *param_1_00;
    fStack_14 = pfVar14[1] - param_1_00[1];
    fStack_10 = pfVar14[2] - param_1_00[2];
    fStack_34 = fStack_18 * fStack_18 + fStack_14 * fStack_14 + fStack_10 * fStack_10;
    if (fStack_34 < _DAT_006f4a54) {
      local_20 = (double)CONCAT44(local_20._4_4_,&fStack_c);
      fStack_38 = SQRT(pfVar14[5] * pfVar14[5] + pfVar14[4] * pfVar14[4] + pfVar14[3] * pfVar14[3]);
      fStack_30 = fStack_38 * _DAT_006f4a50;
      fStack_4 = fStack_30 * _DAT_006ea44c;
      fStack_c = fStack_4 * pfVar14[3];
      fStack_8 = fStack_4 * pfVar14[4];
      fStack_4 = fStack_4 * pfVar14[5];
      local_24 = fStack_34;
      if (_DAT_006ea508 < fStack_38) {
        iVar9 = *(int *)((int)param_1_00 + 0x69);
        fVar4 = ((*param_1_00 - fStack_c) * *(float *)(iVar9 + 0xc) +
                (param_1_00[1] - fStack_8) * *(float *)(iVar9 + 0x10) +
                (param_1_00[2] - fStack_4) * *(float *)(iVar9 + 0x14)) * (_DAT_006e97d8 / fStack_38)
        ;
        local_24 = fStack_30;
        if (_DAT_006ea454 < fVar4) {
          fVar4 = fVar4 * (_DAT_006e97d8 / fStack_38);
          fStack_30 = fStack_30 + fVar4;
          local_20 = (double)CONCAT44(local_20._4_4_,&fStack_18);
          fStack_c = fStack_c + *pfVar14 + fVar4 * *(float *)(iVar9 + 0xc);
          fStack_8 = fStack_8 + pfVar14[1] + fVar4 * *(float *)(iVar9 + 0x10);
          fStack_4 = fStack_4 + pfVar14[2] + fVar4 * *(float *)(iVar9 + 0x14);
          local_24 = fStack_30;
        }
      }
      if (_DAT_006ea454 < param_1_00[0x41]) {
        for (fStack_28 = *(float *)((int)param_1_00 + 0x6d) - param_1_00[0x18];
            _DAT_006f4a4c < fStack_28; fStack_28 = fStack_28 - _DAT_006ee484) {
        }
        for (; fStack_28 < _DAT_006f4a48; fStack_28 = fStack_28 + _DAT_006ee484) {
        }
        local_20 = (double)CONCAT44(local_20._4_4_,fStack_28);
        fStack_28 = ABS(fStack_28);
      }
      fStack_18 = *param_1_00 - fStack_c;
      fStack_14 = param_1_00[1] - fStack_8;
      fStack_10 = param_1_00[2] - fStack_4;
      fStack_2c = fStack_18 * fStack_18 + fStack_14 * fStack_14 + fStack_10 * fStack_10;
      if (*(char *)((int)param_1_00 + 0x86) == '\0') {
        *(float *)((int)param_1_00 + 0x79) = fStack_c;
        *(float *)((int)param_1_00 + 0x7d) = fStack_8;
        if (fVar3 < param_1_00[0x41]) {
          fVar3 = _DAT_006e97d8 - fStack_38 * _DAT_006e9824;
          *(float *)((int)param_1_00 + 0x82) = fVar3;
          if (fVar3 < _DAT_006ea454) {
            *(undefined4 *)((int)param_1_00 + 0x82) = 0;
          }
          if (_DAT_006f4a44 < fStack_28) {
            if (_DAT_006f4a40 <= fStack_28) {
              *(undefined4 *)((int)param_1_00 + 0x82) = 0;
            }
            else {
              *(float *)((int)param_1_00 + 0x82) =
                   (_DAT_006f4a40 - fStack_28) * *(float *)((int)param_1_00 + 0x82) * _DAT_006f4a3c;
            }
          }
        }
      }
      if ((*(char *)((int)param_1_00 + 0x112) == '\0') && (cVar5 = FUN_0040ed90(), cVar5 != '\0')) {
        *(undefined1 *)((int)param_1_00 + 0x112) = 1;
        *(undefined1 *)((int)param_1_00 + 0x113) = 1;
      }
      if ((*(char *)((int)param_1_00 + 0x113) != '\0') &&
         ((cVar5 = FUN_005354d0(*(undefined4 *)((int)param_1_00 + 0x69)), cVar5 != '\0' ||
          (cVar5 = FUN_0040ed90(), cVar5 == '\0')))) {
        *(undefined1 *)((int)param_1_00 + 0x113) = 0;
      }
      fVar15 = (float10)FUN_00516d3a(*(undefined4 *)(*(int *)((int)param_1_00 + 0x69) + 0x3c),
                                     param_1_00[0xf]);
      if (((((float10)_DAT_006ea454 < fVar15) && (fStack_2c < fStack_34)) &&
          (*(int *)((int)param_1_00 + 0x8f) == 0)) &&
         (((local_24 < _DAT_006ea478 &&
           ((*(char *)((int)param_1_00 + 0x112) != '\0' || (_DAT_006ee5b0 < fStack_34)))) &&
          (*(char *)((int)param_1_00 + 0x113) == '\0')))) {
        FUN_00521f90();
      }
    }
  }
  iVar9 = 0;
  if (*(int *)((int)param_1_00 + 0x8f) != 0) {
    if (((*(int *)((int)param_1_00 + 0x93) == 0) && (fStack_34 < fStack_2c)) &&
       (_DAT_006f4a38 < fStack_2c)) {
      if (*(int *)((int)param_1_00 + 0x8f) == 1) {
        FUN_0040f090();
      }
      else {
        FUN_0040f4d0();
      }
      *(undefined1 *)(param_1_00 + 0x3f) = 1;
      *(undefined4 *)((int)param_1_00 + 0x8f) = 2;
      *(undefined4 *)((int)param_1_00 + 0x93) = 2;
      *(undefined1 *)((int)param_1_00 + 0xfd) = 1;
    }
    iVar12 = 0;
    iVar10 = FUN_0040ecf0();
    if (0 < iVar10) {
      do {
        iVar10 = FUN_0051fe50(*(undefined4 *)((int)param_1_00 + 0xaf));
        iVar9 = iVar9 + iVar10;
        iVar12 = iVar12 + 1;
        iVar10 = FUN_0040ecf0();
      } while (iVar12 < iVar10);
    }
  }
  if (((*(int *)((int)param_1_00 + 0x8f) == 1) && (fStack_2c < _DAT_006ee5b0)) &&
     (fStack_30 < _DAT_006ea494)) {
    FUN_0040f100();
    *(undefined1 *)(param_1_00 + 0x3f) = 0;
    *(undefined4 *)((int)param_1_00 + 0x8f) = 2;
    *(undefined1 *)((int)param_1_00 + 0xff) = 0;
  }
  if (*(int *)((int)param_1_00 + 0x8f) != 2) goto LAB_005233a0;
  iVar10 = *(int *)((int)param_1_00 + 0x93);
  if (iVar10 == 0) {
    *(undefined4 *)((int)param_1_00 + 0x97) = param_1;
    *(undefined4 *)((int)param_1_00 + 0x9b) = param_2;
    *(undefined4 *)((int)param_1_00 + 0xab) = 0;
  }
  else {
    *(float *)((int)param_1_00 + 0xab) =
         *(float *)((int)param_1_00 + 0xaf) + *(float *)((int)param_1_00 + 0xab);
  }
  if (iVar10 == 1) {
    *(undefined4 *)((int)param_1_00 + 0xa7) = *(undefined4 *)((int)param_1_00 + 0xab);
  }
  if (iVar10 != 2) {
    *(undefined4 *)((int)param_1_00 + 0x9f) = param_1;
    *(undefined4 *)((int)param_1_00 + 0xa3) = param_2;
  }
  if ((iVar10 == 1) && (cVar5 = FUN_00521540(), cVar5 != '\0')) {
    FUN_00522320();
  }
  if ((*(int *)((int)param_1_00 + 0x93) != 0) || (_DAT_006f410c <= fStack_2c)) goto LAB_00523372;
  if ((*(char *)((int)param_1_00 + 0xff) == '\0') &&
     (fVar15 = (float10)FUN_00516d3a(*(undefined4 *)(*(int *)((int)param_1_00 + 0x69) + 0x3c),
                                     param_1_00[0xf]),
     (float10)fStack_38 * (float10)_DAT_006ee368 + (fVar15 - (float10)_DAT_006ea44c) <
     (float10)_DAT_006ea454)) {
    FUN_0040f490();
    *(undefined1 *)((int)param_1_00 + 0xff) = 1;
  }
  if (_DAT_006ea4cc <= fStack_38) {
    *(undefined1 *)(param_1_00 + 0x40) = 0;
    goto LAB_0052335d;
  }
  if (param_1_00[0x41] < _DAT_006e97d8) {
    if (*(char *)(param_1_00 + 0x42) == '\0') {
      if (((*(int *)(*(int *)((int)param_1_00 + 0x69) + 0x50) == 4) &&
          (*(char *)((int)param_1_00 + 0x101) == '\0')) &&
         (*(char *)((int)param_1_00 + 0x8d) != '\0')) {
        iVar10 = thunk_FUN_0055a730();
        if (3 < iVar10) {
          FUN_00538b40();
          cVar5 = FUN_0053e360();
          if (cVar5 == '\0') goto LAB_0052333f;
        }
        *(undefined1 *)((int)param_1_00 + 0x101) = 1;
        fVar15 = (float10)FUN_00516d3a(param_1_00[0xf],
                                       *(undefined4 *)(*(int *)((int)param_1_00 + 0x69) + 0x3c));
        if (fVar15 <= (float10)_DAT_006ea454) {
          FUN_0040ed50();
        }
        else {
          FUN_0040ed40();
        }
      }
LAB_0052333f:
      *(undefined1 *)((int)param_1_00 + 0x103) = 0;
      *(undefined1 *)(param_1_00 + 0x40) = 0;
      *(undefined1 *)((int)param_1_00 + 0x102) = 0;
      goto LAB_00523372;
    }
    if (*(char *)((int)param_1_00 + 0x103) == '\0') {
      *(undefined1 *)((int)param_1_00 + 0x103) = 1;
      cVar5 = FUN_00521720();
      if (cVar5 == '\0') {
        if (*(char *)((int)param_1_00 + 0xfe) == '\0') goto LAB_005232b2;
        FUN_0040ed20();
        *(undefined1 *)((int)param_1_00 + 0x101) = 0;
        *(undefined1 *)(param_1_00 + 0x40) = 0;
        *(undefined1 *)((int)param_1_00 + 0x102) = 0;
      }
      else {
        if (*(char *)((int)param_1_00 + 0xfe) != '\0') {
LAB_005232b2:
          FUN_0040ed30();
          goto LAB_005232b7;
        }
        FUN_0040ed20();
        *(undefined1 *)((int)param_1_00 + 0x101) = 0;
        *(undefined1 *)(param_1_00 + 0x40) = 0;
        *(undefined1 *)((int)param_1_00 + 0x102) = 0;
      }
    }
    else {
LAB_005232b7:
      *(undefined1 *)((int)param_1_00 + 0x101) = 0;
      *(undefined1 *)(param_1_00 + 0x40) = 0;
      *(undefined1 *)((int)param_1_00 + 0x102) = 0;
    }
  }
  else {
    if (fStack_28 < _DAT_006f4a44 == (fStack_28 == _DAT_006f4a44)) {
      if (*(char *)((int)param_1_00 + 0x8d) != '\0') {
        iVar10 = thunk_FUN_0055a730();
        if (3 < iVar10) {
          FUN_00538b40();
          cVar5 = FUN_0053e360();
          if (cVar5 == '\0') goto LAB_0052335d;
        }
        if (*(char *)(param_1_00 + 0x40) == '\0') {
          *(undefined1 *)(param_1_00 + 0x40) = 1;
          FUN_0040ed60();
        }
      }
LAB_0052335d:
      *(undefined1 *)((int)param_1_00 + 0x102) = 0;
    }
    else {
      cVar5 = FUN_00520f40();
      if (cVar5 == '\0') {
        if (*(float *)((int)param_1_00 + 0xc5) <= _DAT_006ea454) {
          FUN_00522130();
        }
      }
      else {
        if (*(char *)((int)param_1_00 + 0x8d) != '\0') {
          iVar10 = thunk_FUN_0055a730();
          if (3 < iVar10) {
            FUN_00538b40();
            cVar5 = FUN_0053e360();
            if (cVar5 == '\0') goto LAB_005231ad;
          }
          if (*(char *)((int)param_1_00 + 0x102) == '\0') {
            *(undefined1 *)((int)param_1_00 + 0x102) = 1;
            FUN_0040ed80();
          }
        }
LAB_005231ad:
        *(undefined1 *)((int)param_1_00 + 0x8e) = 1;
        FUN_00521ee0(0);
        *(undefined4 *)((int)param_1_00 + 0x93) = 2;
      }
    }
    *(undefined1 *)((int)param_1_00 + 0x101) = 0;
    *(undefined1 *)((int)param_1_00 + 0x103) = 0;
  }
LAB_00523372:
  if (*(int *)((int)param_1_00 + 0x93) == 2) {
    if (param_1_00[0x41] < _DAT_006e97d8) {
      *(char *)((int)param_1_00 + 0xb3d) = *(char *)((int)param_1_00 + 0xb3d) + '\x01';
    }
    if (iVar9 == 0) {
      FUN_00521fe0();
    }
  }
LAB_005233a0:
  if (*(char *)((int)param_1_00 + 0x8d) == '\0') {
    FUN_00523ac0(&DAT_00bd64e8 + *(int *)(*(int *)((int)param_1_00 + 0x89) + 0x5b2) * 0x68);
    iVar9 = 0;
    do {
      FUN_00523b00(&DAT_00bd44a8 +
                   (iVar9 + *(int *)(*(int *)((int)param_1_00 + 0x89) + 0x5b2) * 2) * 0x34,
                   (&DAT_0074ba58)[iVar9],0);
      iVar9 = iVar9 + 1;
    } while (iVar9 < 2);
  }
  else {
    FUN_00523ac0(&DAT_00bd2318);
    iVar10 = 0;
    iVar9 = FUN_0040ecf0();
    if (0 < iVar9) {
      puVar13 = &DAT_00bd0ef0;
      do {
        FUN_00523b00(puVar13,iVar10,0);
        iVar10 = iVar10 + 1;
        puVar13 = puVar13 + 0x34;
        iVar9 = FUN_0040ecf0();
      } while (iVar10 < iVar9);
      return;
    }
  }
  return;
}


