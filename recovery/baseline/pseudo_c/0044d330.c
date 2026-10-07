/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0044d330 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint __fastcall FUN_0044d330(int param_1)

{
  undefined4 *puVar1;
  float fVar2;
  double dVar3;
  ushort uVar4;
  bool bVar5;
  int iVar6;
  char cVar7;
  char cVar8;
  char cVar9;
  undefined4 in_EAX;
  uint uVar10;
  int iVar11;
  int iVar12;
  undefined4 uVar13;
  undefined3 uVar16;
  undefined4 uVar14;
  int *piVar15;
  ushort uVar17;
  float10 fVar18;
  float10 extraout_ST0;
  char local_1f;
  char cStack_1e;
  float fStack_1c;
  int local_18;
  float fStack_14;
  double local_10;
  
  if (*(char *)(param_1 + 0x66) != '\0') {
    uVar10 = CONCAT31((int3)((uint)in_EAX >> 8),*(char *)(param_1 + 0x65));
    if (*(char *)(param_1 + 0x65) == '\0') {
      *(undefined1 *)(param_1 + 0x65) = 1;
      uVar10 = FUN_00450ec0(10,0xd8,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
      return uVar10 & 0xffffff00;
    }
    goto LAB_0044dbea;
  }
  if (DAT_0089bcfd == '\0') {
    *(undefined1 *)(param_1 + 0x76) = 0;
  }
  *(undefined1 *)(param_1 + 0x65) = 0;
  *(undefined1 *)(param_1 + 0x66) = 0;
  fVar18 = (float10)thunk_FUN_0055a760();
  local_18 = -1;
  local_10 = (double)fVar18;
  cVar7 = FUN_005365c0(*(undefined4 *)(DAT_0089e3d8 + 0x5ae),&local_18);
  bVar5 = false;
  if (cVar7 != '\0') {
    iVar12 = local_18 + 8;
    iVar11 = FUN_00538b30();
    puVar1 = (undefined4 *)(iVar11 + 0x9b + iVar12 * 0xc);
    if ((*(int *)(iVar11 + 0x9f + iVar12 * 0xc) == 0) && (puVar1[2] == -0x40100000)) {
LAB_0044d425:
      bVar5 = false;
    }
    else {
      fVar18 = (float10)(**(code **)*puVar1)();
      if (fVar18 <= (float10)*(double *)(puVar1 + 1)) {
        fVar18 = (float10)(**(code **)*puVar1)();
        if (((float10)*(double *)(puVar1 + 1) - fVar18 < (float10)_DAT_006ea4b0) ||
           ((float10)_DAT_006ed098 <= (float10)*(double *)(puVar1 + 1) - fVar18)) goto LAB_0044d425;
      }
      bVar5 = true;
    }
  }
  local_1f = '\0';
  uVar10 = DAT_0089e3cc;
  if ((((DAT_0089e3cc == 6) || (DAT_0089e3cc == 5)) || (uVar10 = DAT_0089e3d8, DAT_0089e3d8 == 0))
     || (*(int *)(DAT_0089e3d8 + 0x5ae) == 0)) goto LAB_0044dbea;
  iVar12 = FUN_00567280();
  if (iVar12 != 2) {
    FUN_0044cb60();
    FUN_0044cfb0();
    if (cVar7 != '\0') {
      FUN_00538b40();
      cVar8 = FUN_0053e390();
      if (((cVar8 == '\0') && (*(char *)(param_1 + 0x5a) == '\0')) &&
         (cVar8 = FUN_00451080(10), cVar8 != '\0')) {
        if (bVar5) {
          uVar10 = FUN_00450ec0(10,10,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
          *(undefined1 *)(param_1 + 0x5a) = 1;
          return uVar10 & 0xffffff00;
        }
        goto LAB_0044d4ed;
      }
    }
    FUN_00538b40();
    cVar8 = FUN_0053e390();
    if (((cVar8 != '\0') || (cVar7 == '\0')) || (!bVar5)) {
      *(undefined1 *)(param_1 + 0x5a) = 0;
    }
  }
LAB_0044d4ed:
  cVar8 = '\0';
  cStack_1e = '\0';
  fStack_14 = 0.0;
  fStack_1c = 0.0;
  if (cVar7 == '\0') {
    iVar11 = 0;
    iVar12 = FUN_00536160();
    cVar8 = '\0';
    if (0 < iVar12) {
      do {
        cVar8 = FUN_00536400(*(undefined4 *)(*(int *)(DAT_0089e3d8 + 0x5ae) + 0x3c),iVar11,
                             0x43fa0000);
        if (cVar8 != '\0') {
          local_18 = iVar11;
          iVar12 = FUN_00536360(iVar11);
          fStack_14 = (float)extraout_ST0;
          fStack_1c = (float)(extraout_ST0 * (float10)_DAT_006ef7b0);
          break;
        }
        iVar11 = iVar11 + 1;
        iVar12 = FUN_00536160();
      } while (iVar11 < iVar12);
    }
LAB_0044d55b:
    uVar16 = (undefined3)((uint)iVar12 >> 8);
    if (*(char *)(param_1 + 0x75) != '\0') goto LAB_0044d562;
  }
  else {
    fVar18 = (float10)FUN_00536360(local_18);
    fStack_14 = (float)fVar18;
    fStack_1c = (float)(fVar18 * (float10)_DAT_006ef7b0);
    if (*(char *)(param_1 + 0x75) == '\0') {
      uVar14 = *(undefined4 *)(DAT_0089e3d8 + 0x5ae);
      FUN_00538b20();
      uVar13 = FUN_00540440();
      iVar12 = FUN_00536960(uVar14,uVar13);
      *(char *)(param_1 + 0x75) = (char)iVar12;
      cVar8 = '\0';
      goto LAB_0044d55b;
    }
LAB_0044d562:
    uVar14 = *(undefined4 *)(DAT_0089e3d8 + 0x5ae);
    FUN_00538b20();
    uVar13 = FUN_00540440();
    iVar12 = FUN_00536960(uVar14,uVar13);
    cVar9 = (char)iVar12;
    if ((cVar9 == '\0') && (iVar12 = thunk_FUN_0055a730(), iVar12 == 4)) {
      local_1f = '\x01';
    }
    uVar16 = (undefined3)((uint)iVar12 >> 8);
    *(char *)(param_1 + 0x75) = cVar9;
  }
  uVar14 = CONCAT31(uVar16,*(char *)(param_1 + 0x74));
  if (*(char *)(param_1 + 0x74) == '\0') {
LAB_0044d5cf:
    *(bool *)(param_1 + 0x74) = cVar8 == '\0';
  }
  else {
    uVar14 = FUN_00535510(*(undefined4 *)(DAT_0089e3d8 + 0x5ae));
    if ((char)uVar14 != '\0') {
      uVar14 = CONCAT31((int3)((uint)uVar14 >> 8),*(char *)(param_1 + 0x74));
      if (*(char *)(param_1 + 0x74) != '\0') {
        local_1f = cVar8;
      }
      goto LAB_0044d5cf;
    }
  }
  uVar16 = (undefined3)((uint)uVar14 >> 8);
  if ((*(char *)(param_1 + 0x2d) == '\0') && (cVar7 != '\0')) {
    dVar3 = local_10 + _DAT_006e9838;
    *(undefined1 *)(param_1 + 0x54) = 0;
    *(undefined1 *)(param_1 + 0x1b) = 1;
    *(double *)(param_1 + 0x1d) = dVar3;
  }
  *(char *)(param_1 + 0x2d) = cVar7;
  uVar10 = CONCAT31(uVar16,*(char *)(param_1 + 0x1b));
  if ((*(char *)(param_1 + 0x1b) != '\0') && (uVar10 = CONCAT31(uVar16,cVar7), cVar7 == '\0')) {
    bVar5 = false;
    iVar12 = 0;
    do {
      uVar10 = FUN_00536160();
      if ((int)uVar10 <= iVar12) {
        if (!bVar5) {
          *(undefined1 *)(param_1 + 0x1b) = 0;
          cStack_1e = '\x01';
        }
        break;
      }
      uVar10 = FUN_00536510(*(undefined4 *)(*(int *)(DAT_0089e3d8 + 0x5ae) + 0x3c),iVar12);
      if (((char)uVar10 == '\0') ||
         (((_DAT_006ea454 <= *(float *)(*(int *)(DAT_0089e3d8 + 0x5ae) + 0x40) ||
           (uVar10 = FUN_00536260(iVar12), *(char *)(uVar10 + 8) == '\0')) &&
          ((fVar2 = *(float *)(*(int *)(DAT_0089e3d8 + 0x5ae) + 0x40),
           uVar17 = (ushort)(fVar2 < _DAT_006ea454), uVar4 = (ushort)(fVar2 == _DAT_006ea454),
           uVar10 = (uint)(ushort)(uVar17 << 8 | uVar4 << 0xe), uVar17 != 0 || uVar4 != 0 ||
           (uVar10 = FUN_00536260(iVar12), *(char *)(uVar10 + 8) != '\0')))))) {
        bVar5 = false;
      }
      else {
        bVar5 = true;
      }
      iVar12 = iVar12 + 1;
    } while (!bVar5);
  }
  uVar14 = CONCAT31((int3)(uVar10 >> 8),DAT_00c533a6);
  if (DAT_00c533a6 != '\0') {
    *(undefined1 *)(param_1 + 0x1a) = 1;
    DAT_00c533a6 = '\0';
  }
  iVar12 = *(int *)(param_1 + 0x2f);
  if (iVar12 != 7) {
    dVar3 = *(double *)(param_1 + 0x33);
    *(undefined1 *)(param_1 + 0x67) = 1;
    *(undefined4 *)(param_1 + 0x2f) = 7;
    uVar14 = CONCAT22((short)(uVar10 >> 0x10),
                      (ushort)(dVar3 < local_10) << 8 | (ushort)(NAN(dVar3) || NAN(local_10)) << 10
                      | (ushort)(dVar3 == local_10) << 0xe);
    if (dVar3 < local_10) {
      *(double *)(param_1 + 0x33) = local_10 + _DAT_006e9830;
      uVar10 = FUN_00450ec0(10,iVar12 + 0xbc,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff)
      ;
      return uVar10 & 0xffffff00;
    }
  }
  cVar8 = *(char *)(param_1 + 0x19);
  iVar12 = CONCAT31((int3)((uint)uVar14 >> 8),cVar8);
  if (cVar8 != '\0') {
    if (*(char *)(param_1 + 0x4a) != '\0') {
      *(undefined1 *)(param_1 + 0x4a) = 0;
      uVar10 = FUN_00450ec0(10,0xc3,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
      return uVar10 & 0xffffff00;
    }
    if (((cVar8 != '\0') && (uVar10 = *(uint *)(param_1 + 0x3c), uVar10 != 0)) &&
       (iVar12 = FUN_00567280(), iVar12 == 7)) {
      iVar11 = 0;
      do {
        if ((uVar10 & 1 << ((byte)iVar11 & 0x1f)) != 0) break;
        iVar11 = iVar11 + 1;
      } while (iVar11 < 7);
      if (iVar11 != 7) {
        *(uint *)(param_1 + 0x3c) = ~(1 << ((byte)iVar11 & 0x1f)) & uVar10;
        if (*(char *)(param_1 + 0x40) == '\0') {
          *(undefined1 *)(param_1 + 0x40) = 1;
          uVar10 = FUN_00450ec0(10,0xca,iVar11 + 0xcb,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
          return uVar10 & 0xffffff00;
        }
        uVar10 = FUN_00450ec0(10,iVar11 + 0xcb,0xffffffff,0xffffffff,0xffffffff,0xffffffff,
                              0xffffffff);
        return uVar10 & 0xffffff00;
      }
    }
  }
  iVar12 = CONCAT31((int3)((uint)iVar12 >> 8),*(char *)(param_1 + 0x3b));
  if (((*(char *)(param_1 + 0x3b) != '\0') && (iVar12 = thunk_FUN_0055a730(), iVar12 != 5)) &&
     (iVar12 = thunk_FUN_0055a730(), iVar12 != 6)) {
    if (*(char *)(param_1 + 0x41) != '\0') {
      if (DAT_0089e3dc == 0) {
        fStack_14 = 0.0;
      }
      else {
        uVar14 = *(undefined4 *)(DAT_0089e3dc + 0x5b2);
        piVar15 = (int *)FUN_00538b00();
        (**(code **)(*piVar15 + 0x30))(uVar14);
        fStack_14 = (float)FUN_005443c0(uVar14);
      }
      piVar15 = (int *)FUN_00538b00();
      fVar2 = (float)(int)fStack_14;
      iVar12 = (**(code **)(*piVar15 + 0x44))();
      uVar14 = 0xffffffff;
      fStack_14 = fVar2 / (float)iVar12;
      if (((*(char *)(param_1 + 0x4b) != '\0') && (*(char *)(param_1 + 0x40) == '\0')) &&
         ((*(char *)(param_1 + 0x5c) == '\0' && (*(char *)(param_1 + 0x67) == '\0')))) {
        iVar12 = FUN_00567280();
        if (iVar12 == 7) {
          uVar14 = 0xd3;
        }
        *(undefined1 *)(param_1 + 0x4b) = 0;
      }
      if ((float)_DAT_006ef7a8 <= fStack_14) {
        uVar13 = 199;
      }
      else {
        uVar13 = 200;
      }
      FUN_00450ec0(10,uVar13,uVar14,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
      uVar10 = FUN_0044c4d0();
      *(undefined1 *)(param_1 + 0x41) = 0;
      *(undefined1 *)(param_1 + 0x67) = 0;
      return uVar10 & 0xffffff00;
    }
    uVar10 = FUN_0044c4e0();
    *(undefined1 *)(param_1 + 0x3b) = 0;
    *(undefined1 *)(param_1 + 0x67) = 0;
    return uVar10 & 0xffffff00;
  }
  iVar12 = CONCAT31((int3)((uint)iVar12 >> 8),local_1f);
  if ((local_1f != '\0') && (iVar12 = FUN_00567280(), iVar12 != 2)) {
    iVar12 = FUN_006c5018();
    if (iVar12 < 0) {
      iVar12 = 0;
    }
    else if (7 < iVar12) {
      iVar12 = 7;
    }
    iVar11 = FUN_00450140(2);
    fVar18 = (float10)FUN_00536360(local_18);
    uVar14 = FUN_0044dc00((float)fVar18);
    iVar12 = FUN_00450ec0(10,iVar11 + 0x17c + iVar12 * 2,0x18c,uVar14,0xffffffff,0xffffffff,
                          0xffffffff);
  }
  iVar12 = CONCAT31((int3)((uint)iVar12 >> 8),cStack_1e);
  if (((cStack_1e == '\0') || (iVar12 = thunk_FUN_0055a730(), iVar12 != 4)) ||
     (iVar12 = FUN_00567280(), iVar12 == 2)) {
    uVar16 = (undefined3)((uint)iVar12 >> 8);
    uVar10 = CONCAT31(uVar16,cVar7);
    if (((cVar7 != '\0') &&
        (uVar10 = CONCAT31(uVar16,*(char *)(param_1 + 0x19)), *(char *)(param_1 + 0x19) == '\0')) &&
       ((uVar10 = FUN_00567280(), uVar10 != 2 && (uVar10 = thunk_FUN_0055a730(), uVar10 == 4)))) {
      iVar12 = *(int *)(DAT_0089e3d8 + 0x5ae);
      fVar2 = *(float *)(iVar12 + 0x14) * *(float *)(iVar12 + 0x14) +
              *(float *)(iVar12 + 0x10) * *(float *)(iVar12 + 0x10) +
              *(float *)(iVar12 + 0xc) * *(float *)(iVar12 + 0xc);
      if ((*(char *)(param_1 + 0x1b) != '\0') || (fVar2 <= fStack_1c * fStack_1c * _DAT_006e9804)) {
        uVar17 = (ushort)(fVar2 < fStack_1c * fStack_1c);
        uVar4 = (ushort)(fVar2 == fStack_1c * fStack_1c);
        uVar10 = (uint)(ushort)(uVar17 << 8 | uVar4 << 0xe);
        if (uVar17 == 0 && uVar4 == 0) {
          dVar3 = *(double *)(param_1 + 0x1d);
          uVar17 = (ushort)(dVar3 < local_10) << 8 | (ushort)(NAN(dVar3) || NAN(local_10)) << 10 |
                   (ushort)(dVar3 == local_10) << 0xe;
          uVar10 = (uint)uVar17;
          if ((dVar3 < local_10) &&
             (uVar10 = (uint)CONCAT11((char)(uVar17 >> 8),*(char *)(param_1 + 0x54)),
             *(char *)(param_1 + 0x54) == '\0')) {
            fVar18 = (float10)FUN_00536360(local_18);
            uVar14 = FUN_0044dc00((float)fVar18);
            uVar10 = FUN_00450ec0(10,0xd4,0xc9,uVar14,0xffffffff,0xffffffff,0xffffffff);
            *(undefined1 *)(param_1 + 0x54) = 1;
          }
        }
      }
      else {
        dVar3 = *(double *)(param_1 + 0x25);
        uVar10 = (uint)(ushort)((ushort)(dVar3 < local_10) << 8 |
                                (ushort)(NAN(dVar3) || NAN(local_10)) << 10 |
                               (ushort)(dVar3 == local_10) << 0xe);
        if (dVar3 < local_10) {
          *(double *)(param_1 + 0x25) = local_10 + _DAT_006ed050;
          uVar10 = FUN_00450ec0(10,0xd5,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
          return uVar10 & 0xffffff00;
        }
      }
    }
LAB_0044dbea:
    return uVar10 & 0xffffff00;
  }
  iVar12 = -1;
  if (*(int *)(param_1 + 0x50) - *(int *)(param_1 + 0x4c) < 6) {
    if ((*(char *)(param_1 + 0x40) != '\0') && (-1 < *(int *)(param_1 + 0x50))) {
      iVar11 = (-(uint)(DAT_0089e3cc != 7) & 0xffffff2d) + 0xd2;
      goto LAB_0044da43;
    }
    iVar11 = -1;
    if (DAT_0089e3cc != 7) goto LAB_0044da9e;
    cVar7 = *(char *)(param_1 + 0x1c);
    iVar6 = -1;
  }
  else {
    iVar11 = (-(uint)(DAT_0089e3cc != 7) & 0xffffff39) + 0xc6;
LAB_0044da43:
    if (DAT_0089e3cc != 7) goto LAB_0044da9e;
    cVar7 = *(char *)(param_1 + 0x1c);
    iVar6 = iVar11;
  }
  iVar11 = iVar6;
  if ((cVar7 != '\0') && (DAT_00898958 != '\0')) {
    iVar11 = 0xc5;
    iVar12 = iVar6;
  }
LAB_0044da9e:
  uVar10 = FUN_00450ec0(10,0xc4,iVar11,iVar12,0xffffffff,0xffffffff,0xffffffff);
  *(undefined1 *)(param_1 + 0x40) = 0;
  return uVar10 & 0xffffff00;
}


