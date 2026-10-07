/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0044ef10 */

/* WARNING (jumptable): Unable to track spacebase fully for stack */
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint __fastcall FUN_0044ef10(int param_1)

{
  double dVar1;
  char cVar2;
  char cVar3;
  byte bVar4;
  ushort uVar5;
  ushort uVar6;
  float fVar7;
  undefined4 uVar8;
  uint3 uVar12;
  int iVar9;
  uint uVar10;
  undefined3 uVar13;
  int iVar11;
  int iVar14;
  undefined4 *puVar15;
  undefined4 *puVar16;
  bool bVar17;
  ushort uVar18;
  float10 fVar19;
  double dVar20;
  undefined4 uVar21;
  int iVar22;
  undefined4 uVar23;
  char local_16;
  char local_15;
  int local_14;
  uint local_10;
  uint uStack_c;
  
  uVar8 = FUN_004507f0(DAT_0089e3d8);
  if (((char)uVar8 == '\0') && (*(char *)(param_1 + 0x48) != '\0')) {
    *(undefined1 *)(param_1 + 0x47) = 1;
  }
  *(char *)(param_1 + 0x48) = (char)uVar8;
  uVar12 = (uint3)((uint)uVar8 >> 8);
  if ((DAT_0089bcfd == '\0') && (DAT_0089bce1 == '\0')) {
    uVar10 = CONCAT31(uVar12,*(char *)(param_1 + 0x44));
    if (*(char *)(param_1 + 0x44) != '\0') {
      *(undefined1 *)(param_1 + 0x21) = 0xff;
      *(undefined1 *)(param_1 + 0x22) = 0xff;
      *(undefined1 *)(param_1 + 0x23) = 0;
      *(undefined1 *)(param_1 + 0x24) = 0;
      *(undefined1 *)(param_1 + 0x25) = 0;
      *(undefined4 *)(param_1 + 0x26) = 0;
      *(undefined1 *)(param_1 + 0x2a) = 0;
      *(undefined1 *)(param_1 + 0x44) = 0;
      *(undefined1 *)(param_1 + 0x45) = 0;
      puVar15 = (undefined4 *)(param_1 + 0x19);
      puVar16 = (undefined4 *)(param_1 + 0x2d);
      for (iVar14 = 5; iVar14 != 0; iVar14 = iVar14 + -1) {
        *puVar16 = *puVar15;
        puVar15 = puVar15 + 1;
        puVar16 = puVar16 + 1;
      }
      *(undefined1 *)(param_1 + 0x41) = 0;
      *(undefined1 *)(param_1 + 0x42) = 1;
      *(undefined1 *)(param_1 + 0x43) = 0;
      *(undefined1 *)(param_1 + 0x46) = 0;
      *(undefined1 *)(param_1 + 0x47) = 0;
      return (uint)uVar12 << 8;
    }
  }
  else {
    bVar17 = DAT_0089bcfd == '\0';
    *(undefined1 *)(param_1 + 0x44) = 1;
    local_16 = '\0';
    if ((bVar17) ||
       (((cVar2 = *(char *)(param_1 + 0x41), cVar2 == '\0' && (*(char *)(param_1 + 0x43) == '\0'))
        && ((*(char *)(param_1 + 0x46) == '\0' ||
            (*(char *)(param_1 + 0x3e) == *(char *)(param_1 + 0x2a))))))) {
      if ((*(char *)(param_1 + 0x38) == '\0') ||
         ((*(char *)(param_1 + 0x3e) != *(char *)(param_1 + 0x2a) &&
          (*(char *)(param_1 + 0x43) != '\0')))) {
        *(undefined1 *)(param_1 + 0x7a) = 0;
        *(undefined4 *)(param_1 + 0x62) = 0;
        *(undefined4 *)(param_1 + 0x66) = 0xbff00000;
        *(undefined1 *)(param_1 + 0x61) = 0;
        *(undefined4 *)(param_1 + 0x49) = 0;
        *(undefined4 *)(param_1 + 0x4d) = 0xbff00000;
      }
      else {
        if ((DAT_0089e3e0 == 0) ||
           ((uint)*(byte *)(param_1 + 0x36) != *(uint *)(DAT_0089e3e0 + 0x5b2))) {
          iVar14 = 0;
        }
        else {
          iVar14 = 1;
        }
        iVar14 = param_1 + iVar14 * 0x19;
        *(undefined1 *)(iVar14 + 0x61) = 1;
        if (*(char *)(param_1 + 0x36) != *(char *)(param_1 + 0x22)) {
          *(undefined4 *)(iVar14 + 0x49) = 0;
          *(undefined4 *)(iVar14 + 0x4d) = 0xbff00000;
        }
        *(undefined1 *)(param_1 + 0x41) = 0;
      }
    }
    else {
      cVar3 = *(char *)(param_1 + 0x43);
      if (cVar2 == '\0') {
        iVar14 = FUN_00538b30();
        if (((*(byte *)(iVar14 + 0x2d) & 2) == 0) || (DAT_0089bd1a != '\0')) {
          *(undefined1 *)(param_1 + 0x43) = 1;
        }
        else {
          *(undefined1 *)(param_1 + 0x43) = 0;
        }
      }
      else {
        *(undefined1 *)(param_1 + 0x43) = 0;
      }
      if ((cVar2 != '\0') || ((cVar3 != '\0' && (*(char *)(param_1 + 0x43) == '\0')))) {
        if ((DAT_0089e3e0 == 0) ||
           ((uint)*(byte *)(param_1 + 0x36) != *(uint *)(DAT_0089e3e0 + 0x5b2))) {
          iVar14 = 0;
        }
        else {
          iVar14 = 1;
        }
        local_16 = '\x01';
        iVar14 = param_1 + iVar14 * 0x19;
        *(undefined1 *)(iVar14 + 0x61) = 1;
        *(undefined4 *)(iVar14 + 0x49) = 0;
        *(undefined4 *)(iVar14 + 0x4d) = 0xbff00000;
        *(undefined1 *)(param_1 + 0x41) = 0;
      }
    }
    iVar14 = DAT_0089e3dc;
    if ((*(char *)(param_1 + 0x39) == '\0') || (0x2f < *(byte *)(param_1 + 0x36))) {
      *(undefined4 *)(param_1 + 0x98) = 0xbff00000;
      *(undefined4 *)(param_1 + 0x7f) = 0xbff00000;
      bVar4 = *(byte *)(param_1 + 0x36);
      *(undefined1 *)(param_1 + 0xac) = 0;
      *(undefined4 *)(param_1 + 0x94) = 0;
      *(undefined1 *)(param_1 + 0x93) = 0;
      *(undefined4 *)(param_1 + 0x7b) = 0;
      if ((bVar4 < 0x30) &&
         ((((DAT_0089e3d8 != 0 && (*(int *)(DAT_0089e3d8 + 0x5ae) != 0)) &&
           (iVar14 = FUN_00562f70(bVar4), iVar14 != 0)) &&
          (iVar14 = FUN_00562f70(bVar4), *(int *)(iVar14 + 0x5ae) != 0)))) {
        iVar14 = FUN_00562f70(bVar4);
        fVar19 = (float10)FUN_00516daa(*(undefined4 *)(*(int *)(DAT_0089e3d8 + 0x5ae) + 0x3c),
                                       *(undefined4 *)(*(int *)(iVar14 + 0x5ae) + 0x3c));
        iVar14 = *(int *)(DAT_0089e3d8 + 0x5ae);
        iVar9 = FUN_00562f70(bVar4);
        fVar7 = *(float *)(iVar14 + 0x44) - *(float *)(*(int *)(iVar9 + 0x5ae) + 0x44);
        if ((float)_DAT_006ef810 < fVar7) {
          fVar7 = (float)fVar19 / fVar7;
          if (_DAT_006e97d8 <= fVar7) {
            if (fVar7 < _DAT_006ea514) {
              if (*(double *)(param_1 + 0xbd) < _DAT_006ea4b0) {
                fVar19 = (float10)thunk_FUN_0055a760();
                *(double *)(param_1 + 0xbd) = (double)fVar19;
              }
              *(undefined1 *)(param_1 + 0xc5) = 1;
            }
          }
          else {
            *(undefined1 *)(param_1 + 0xc5) = 1;
            *(undefined4 *)(param_1 + 0xbd) = 0;
            *(undefined4 *)(param_1 + 0xc1) = 0;
          }
        }
      }
    }
    else {
      iVar9 = FUN_00562f70(*(byte *)(param_1 + 0x36));
      iVar14 = param_1 + (3 - (uint)(iVar9 != iVar14)) * 0x19;
      *(undefined1 *)(iVar14 + 0x61) = 1;
      if (*(char *)(param_1 + 0x36) != *(char *)(param_1 + 0x22)) {
        *(undefined4 *)(iVar14 + 0x49) = 0;
        *(undefined4 *)(iVar14 + 0x4d) = 0xbff00000;
      }
    }
    if (*(char *)(param_1 + 0xc5) == '\0') {
      *(undefined4 *)(param_1 + 0xbd) = 0;
      *(undefined4 *)(param_1 + 0xc1) = 0xbff00000;
    }
    if ((*(byte *)(param_1 + 0x35) < 0x30) && (*(char *)(param_1 + 0x37) != '\0')) {
      if ((DAT_0089e3e0 == 0) ||
         (iVar14 = 5, (uint)*(byte *)(param_1 + 0x35) != *(uint *)(DAT_0089e3e0 + 0x5b2))) {
        iVar14 = 6;
      }
      iVar14 = param_1 + iVar14 * 0x19;
      *(undefined1 *)(iVar14 + 0x61) = 1;
      if (*(char *)(param_1 + 0x35) != *(char *)(param_1 + 0x21)) {
        *(undefined4 *)(iVar14 + 0x49) = 0;
        *(undefined4 *)(iVar14 + 0x4d) = 0xbff00000;
      }
    }
    else {
      *(undefined1 *)(param_1 + 0xde) = 0;
      *(undefined4 *)(param_1 + 0xc6) = 0;
      *(undefined4 *)(param_1 + 0xca) = 0xbff00000;
      *(undefined1 *)(param_1 + 0xf7) = 0;
      *(undefined4 *)(param_1 + 0xdf) = 0;
      *(undefined4 *)(param_1 + 0xe3) = 0xbff00000;
    }
    if (*(char *)(param_1 + 0x45) != '\0') {
      *(undefined1 *)(param_1 + 0x110) = 1;
    }
    puVar15 = (undefined4 *)(param_1 + 0x2d);
    puVar16 = (undefined4 *)(param_1 + 0x19);
    for (iVar14 = 5; iVar14 != 0; iVar14 = iVar14 + -1) {
      *puVar16 = *puVar15;
      puVar15 = puVar15 + 1;
      puVar16 = puVar16 + 1;
    }
    fVar19 = (float10)thunk_FUN_0055a760();
    dVar1 = (double)fVar19;
    local_15 = '\x01';
    local_14 = 0;
    do {
      iVar11 = local_14 * 5;
      iVar9 = param_1 + local_14 * 0x14;
      iVar14 = iVar11 + iVar9;
      cVar2 = *(char *)(iVar11 + 0x61 + iVar9);
      uVar10 = CONCAT31((int3)((uint)iVar11 >> 8),cVar2);
      if (cVar2 != '\0') {
        dVar20 = dVar1 - *(double *)(iVar14 + 0x51);
        uVar5 = (ushort)(dVar20 < _DAT_006ef808);
        uVar6 = (ushort)(dVar20 == _DAT_006ef808);
        uVar18 = uVar5 << 8 | uVar6 << 0xe;
        uVar10 = (uint)uVar18;
        if ((uVar5 == 0 && uVar6 == 0) &&
           (uVar10 = (uint)CONCAT11((char)(uVar18 >> 8),local_15), local_15 != '\0')) {
          uVar10 = FUN_00451080(0xe);
          local_15 = (char)uVar10;
          if (local_15 != '\0') {
            uVar10 = FUN_005354f0(*(undefined4 *)(DAT_0089e3d8 + 0x5ae));
            if ((char)uVar10 == '\0') {
              uVar13 = (undefined3)(uVar10 >> 8);
              local_10 = SUB84(dVar1,0);
              uStack_c = (uint)((ulonglong)dVar1 >> 0x20);
              switch(local_14) {
              case 0:
                if ((*(char *)(param_1 + 0x24) != '\0') ||
                   (uVar10 = CONCAT31(uVar13,local_16), local_16 != '\0')) {
                  iVar9 = -1;
                  if (*(char *)(param_1 + 0x2b) != '\0') {
                    iVar9 = (*(char *)(param_1 + 0x3e) != '\0') + 8;
                  }
                  if (*(double *)(iVar14 + 0x49) < _DAT_006ea4b0) {
                    iVar11 = FUN_0044ed70(*(undefined4 *)(param_1 + 0x1d));
                    if (iVar11 != -1) {
                      if (*(char *)(param_1 + 0x3e) != '\0') {
                        iVar22 = iVar9;
                        iVar9 = -1;
                        goto LAB_0044f4b4;
                      }
                      if (*(char *)(param_1 + 0x40) == '\0') {
                        iVar22 = FUN_0044df50(*(undefined4 *)(param_1 + 0x3a));
                        if (iVar22 == 0) {
                          iVar22 = FUN_004503c0();
                          if (iVar22 < 1) {
                            iVar22 = FUN_004503c0();
                            if (iVar22 < 0) {
                              iVar22 = 0x3d;
                              uVar8 = 0x34;
                            }
                            else {
                              iVar22 = 0x3e;
                              uVar8 = 0x34;
                            }
                          }
                          else {
                            iVar22 = 0x3c;
LAB_0044f4b4:
                            uVar8 = 0x34;
                          }
                        }
                        else {
                          iVar22 = FUN_004503c0();
                          if (0 < iVar22) {
                            iVar22 = 0x3d;
                            goto LAB_0044f4b4;
                          }
                          iVar22 = FUN_004503c0();
                          if (iVar22 < 0) {
                            iVar22 = 0x3c;
                            uVar8 = 0x34;
                          }
                          else {
                            iVar22 = 0x3f;
                            uVar8 = 0x34;
                          }
                        }
                      }
                      else {
                        iVar9 = -1;
                        iVar22 = -1;
                        iVar11 = -1;
                        uVar8 = 0x35;
                      }
                      FUN_00450ec0(0xe,uVar8,iVar11,iVar22,iVar9,0xffffffff,0xffffffff);
                    }
                    dVar20 = dVar1 + _DAT_006ef800;
                    *(double *)(iVar14 + 0x51) = dVar1;
                    goto LAB_0044f939;
                  }
                  uVar5 = (ushort)(dVar1 < *(double *)(iVar14 + 0x49));
                  uVar6 = (ushort)(dVar1 == *(double *)(iVar14 + 0x49));
                  uVar10 = (uint)(ushort)(uVar5 << 8 | uVar6 << 0xe);
                  if (uVar5 == 0 && uVar6 == 0) {
                    local_10 = FUN_0044ed70(*(undefined4 *)(param_1 + 0x1d));
                    if (local_10 != 0xffffffff) {
                      dVar20 = rndUniform(0);
                      if (_DAT_006ef7f8 <= dVar20) {
                        uVar21 = 0xffffffff;
                        local_10 = 0xffffffff;
                        uVar8 = 0x37;
                      }
                      else if (*(char *)(param_1 + 0x3e) == '\0') {
                        iVar9 = FUN_0044df50(*(undefined4 *)(param_1 + 0x3a));
                        if (iVar9 == 0) {
                          iVar9 = FUN_004503c0();
                          if (iVar9 < 1) {
                            iVar9 = FUN_004503c0();
                            if (iVar9 < 0) {
                              uVar21 = 0x3d;
                              uVar8 = 0x34;
                            }
                            else {
                              uVar21 = 0x3e;
                              uVar8 = 0x34;
                            }
                          }
                          else {
                            uVar21 = 0x3c;
                            uVar8 = 0x34;
                          }
                        }
                        else {
                          iVar9 = FUN_004503c0();
                          if (iVar9 < 1) {
                            iVar9 = FUN_004503c0();
                            if (iVar9 < 0) {
                              uVar21 = 0x3c;
                              uVar8 = 0x34;
                            }
                            else {
                              uVar21 = 0x3f;
                              uVar8 = 0x34;
                            }
                          }
                          else {
                            uVar21 = 0x3d;
                            uVar8 = 0x34;
                          }
                        }
                      }
                      else {
                        uVar21 = 0xffffffff;
                        uVar8 = 0x34;
                      }
                      local_10 = FUN_00450ec0(0xe,uVar8,local_10,uVar21,0xffffffff,0xffffffff,
                                              0xffffffff);
                    }
                    dVar20 = dVar1 + _DAT_006ef7f0;
                    *(double *)(iVar14 + 0x51) = dVar1;
                    goto LAB_0044f939;
                  }
                }
                break;
              case 1:
                if ((*(char *)(param_1 + 0x24) != '\0') ||
                   (uVar10 = CONCAT31(uVar13,local_16), local_16 != '\0')) {
                  if (*(double *)(iVar14 + 0x49) < _DAT_006ea4b0) {
                    if (*(char *)(param_1 + 0x3e) == '\0') {
                      iVar9 = FUN_0044df50(*(undefined4 *)(param_1 + 0x3a));
                      if (iVar9 == 0) {
                        iVar9 = FUN_004503c0();
                        if (iVar9 < 1) {
                          iVar9 = FUN_004503c0();
                          if (iVar9 < 0) {
                            uVar8 = 0x3d;
                          }
                          else {
                            uVar8 = 0x3e;
                          }
                        }
                        else {
                          uVar8 = 0x3c;
                        }
                      }
                      else {
                        iVar9 = FUN_004503c0();
                        if (iVar9 < 1) {
                          iVar9 = FUN_004503c0();
                          if (iVar9 < 0) {
                            uVar8 = 0x3c;
                          }
                          else {
                            uVar8 = 0x3f;
                          }
                        }
                        else {
                          uVar8 = 0x3d;
                        }
                      }
                    }
                    else {
                      uVar8 = 0xffffffff;
                    }
                    local_10 = FUN_00450ec0(0xe,0x34,0x18d,uVar8,0xffffffff,0xffffffff,0xffffffff);
                    dVar20 = dVar1 + _DAT_006ef800;
                    *(double *)(iVar14 + 0x51) = dVar1;
                    goto LAB_0044f939;
                  }
                  uVar5 = (ushort)(dVar1 < *(double *)(iVar14 + 0x49));
                  uVar6 = (ushort)(dVar1 == *(double *)(iVar14 + 0x49));
                  uVar10 = (uint)(ushort)(uVar5 << 8 | uVar6 << 0xe);
                  if (uVar5 == 0 && uVar6 == 0) {
                    dVar20 = rndUniform(0);
                    if (_DAT_006ef7f8 <= dVar20) {
                      uVar23 = 0xffffffff;
                      uVar21 = 0xffffffff;
                      uVar8 = 0x37;
                    }
                    else if (*(char *)(param_1 + 0x3e) == '\0') {
                      iVar9 = FUN_0044df50(*(undefined4 *)(param_1 + 0x3a));
                      if (iVar9 == 0) {
                        iVar9 = FUN_004503c0();
                        if (iVar9 < 1) {
                          iVar9 = FUN_004503c0();
                          if (iVar9 < 0) {
                            uVar23 = 0x3d;
                            uVar21 = 0x18d;
                            uVar8 = 0x34;
                          }
                          else {
                            uVar23 = 0x3e;
                            uVar21 = 0x18d;
                            uVar8 = 0x34;
                          }
                        }
                        else {
                          uVar23 = 0x3c;
                          uVar21 = 0x18d;
                          uVar8 = 0x34;
                        }
                      }
                      else {
                        iVar9 = FUN_004503c0();
                        if (iVar9 < 1) {
                          iVar9 = FUN_004503c0();
                          if (iVar9 < 0) {
                            uVar23 = 0x3c;
                            uVar21 = 0x18d;
                            uVar8 = 0x34;
                          }
                          else {
                            uVar23 = 0x3f;
                            uVar21 = 0x18d;
                            uVar8 = 0x34;
                          }
                        }
                        else {
                          uVar23 = 0x3d;
                          uVar21 = 0x18d;
                          uVar8 = 0x34;
                        }
                      }
                    }
                    else {
                      uVar23 = 0xffffffff;
                      uVar21 = 0x18d;
                      uVar8 = 0x34;
                    }
                    goto LAB_0044f854;
                  }
                }
                break;
              case 2:
                uVar10 = CONCAT31(uVar13,*(char *)(param_1 + 0x25));
                if ((*(char *)(param_1 + 0x25) != '\0') &&
                   (uVar5 = (ushort)(dVar1 < *(double *)(iVar14 + 0x49)),
                   uVar6 = (ushort)(dVar1 == *(double *)(iVar14 + 0x49)),
                   uVar10 = (uint)(ushort)(uVar5 << 8 | uVar6 << 0xe), uVar5 == 0 && uVar6 == 0)) {
                  iVar9 = -1;
                  uVar8 = 0x38;
LAB_0044f8dc:
                  FUN_00450ec0(0xe,uVar8,iVar9,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
LAB_0044f8e5:
                  *(double *)(iVar14 + 0x51) = dVar1;
LAB_0044f92f:
                  dVar20 = dVar1 + _DAT_006ecfd0;
LAB_0044f939:
                  *(double *)(iVar14 + 0x49) = dVar20;
                  uVar10 = local_10;
                }
                break;
              case 3:
                uVar10 = CONCAT31(uVar13,*(char *)(param_1 + 0x25));
                if ((*(char *)(param_1 + 0x25) != '\0') &&
                   (uVar5 = (ushort)(dVar1 < *(double *)(iVar14 + 0x49)),
                   uVar6 = (ushort)(dVar1 == *(double *)(iVar14 + 0x49)),
                   uVar10 = (uint)(ushort)(uVar5 << 8 | uVar6 << 0xe), uVar5 == 0 && uVar6 == 0)) {
                  uVar8 = 0x39;
LAB_0044f918:
                  FUN_00450ec0(0xe,uVar8,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
                  *(double *)(iVar14 + 0x51) = dVar1;
                  local_10 = uStack_c;
                  goto LAB_0044f92f;
                }
                break;
              case 4:
                uVar5 = (ushort)(dVar1 < *(double *)(iVar14 + 0x49));
                uVar6 = (ushort)(dVar1 == *(double *)(iVar14 + 0x49));
                uVar10 = (uint)(ushort)(uVar5 << 8 | uVar6 << 0xe);
                if ((uVar5 == 0 && uVar6 == 0) &&
                   (dVar20 = dVar1 - *(double *)(iVar14 + 0x59),
                   uVar5 = (ushort)(dVar20 < _DAT_006e9808),
                   uVar6 = (ushort)(dVar20 == _DAT_006e9808),
                   uVar10 = (uint)(ushort)(uVar5 << 8 | uVar6 << 0xe), uVar5 == 0 && uVar6 == 0)) {
                  uVar23 = 0xffffffff;
                  uVar21 = 0xffffffff;
                  uVar8 = 0x36;
LAB_0044f854:
                  local_10 = FUN_00450ec0(0xe,uVar8,uVar21,uVar23,0xffffffff,0xffffffff,0xffffffff);
                  dVar20 = dVar1 + _DAT_006ef7f0;
                  *(double *)(iVar14 + 0x51) = dVar1;
                  goto LAB_0044f939;
                }
                break;
              case 5:
                uVar10 = CONCAT31(uVar13,*(char *)(param_1 + 0x23));
                if ((*(char *)(param_1 + 0x23) != '\0') &&
                   (uVar5 = (ushort)(dVar1 < *(double *)(iVar14 + 0x49)),
                   uVar6 = (ushort)(dVar1 == *(double *)(iVar14 + 0x49)),
                   uVar10 = (uint)(ushort)(uVar5 << 8 | uVar6 << 0xe), uVar5 == 0 && uVar6 == 0)) {
                  iVar9 = 0x18d;
LAB_0044f8da:
                  uVar8 = 0x3b;
                  goto LAB_0044f8dc;
                }
                break;
              case 6:
                uVar10 = CONCAT31(uVar13,*(char *)(param_1 + 0x23));
                if ((*(char *)(param_1 + 0x23) != '\0') &&
                   (uVar5 = (ushort)(dVar1 < *(double *)(iVar14 + 0x49)),
                   uVar6 = (ushort)(dVar1 == *(double *)(iVar14 + 0x49)),
                   uVar10 = (uint)(ushort)(uVar5 << 8 | uVar6 << 0xe), uVar5 == 0 && uVar6 == 0)) {
                  iVar9 = FUN_0044ed70(*(undefined4 *)(param_1 + 0x19));
                  if (iVar9 != -1) goto LAB_0044f8da;
                  goto LAB_0044f8e5;
                }
                break;
              case 7:
                uVar10 = CONCAT31(uVar13,*(char *)(param_1 + 0x45));
                if ((*(char *)(param_1 + 0x45) != '\0') &&
                   (uVar5 = (ushort)(dVar1 < *(double *)(iVar14 + 0x49)),
                   uVar6 = (ushort)(dVar1 == *(double *)(iVar14 + 0x49)),
                   uVar10 = (uint)(ushort)(uVar5 << 8 | uVar6 << 0xe), uVar5 == 0 && uVar6 == 0)) {
                  uVar8 = 0x3a;
                  goto LAB_0044f918;
                }
              }
            }
            *(undefined1 *)(iVar14 + 0x61) = 0;
          }
        }
      }
      local_14 = local_14 + 1;
    } while (local_14 < 8);
  }
  return uVar10 & 0xffffff00;
}


