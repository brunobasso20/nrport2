/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00563bd0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00563bd0(int param_1,char param_2)

{
  float fVar1;
  undefined4 *puVar2;
  float10 fVar3;
  bool bVar4;
  bool bVar5;
  char cVar6;
  char cVar7;
  undefined1 uVar8;
  int iVar9;
  int iVar10;
  int *piVar11;
  int *piVar12;
  float *pfVar13;
  int iVar14;
  float fVar15;
  int *piVar16;
  bool bVar17;
  float10 fVar18;
  float10 fVar19;
  double dVar20;
  undefined *puVar21;
  undefined4 uVar22;
  undefined4 uVar23;
  char local_a5;
  float local_a4;
  float local_a0;
  float local_94;
  int *piStack_88;
  float *local_84;
  int local_80 [4];
  int *piStack_70;
  undefined4 local_6c [4];
  float local_5c [4];
  float local_4c [4];
  float local_3c [4];
  float local_2c [4];
  undefined1 local_1c [28];
  
  cVar6 = FUN_00502480();
  if (cVar6 != '\0') {
    return;
  }
  local_94 = 0.0;
  cVar6 = FUN_0055ab10(*(undefined4 *)(param_1 + 0x5b2));
  if (param_2 == '\0') {
    iVar9 = FUN_0055a610();
    iVar9 = *(int *)(iVar9 + 0xc);
    iVar10 = FUN_0055a610();
    local_a5 = thunk_FUN_0056ba70(*(undefined4 *)(iVar10 + 4));
    iVar10 = FUN_0055a610();
  }
  else {
    iVar9 = FUN_00503470();
    iVar9 = *(int *)(iVar9 + 0xc);
    iVar10 = FUN_00503470();
    local_a5 = thunk_FUN_0056ba70(*(undefined4 *)(iVar10 + 4));
    iVar10 = FUN_00503470();
  }
  bVar17 = iVar9 == param_1;
  iVar9 = *(int *)(iVar10 + 4);
  if ((((iVar9 < 1) || (3 < iVar9)) && (iVar9 != 10)) && ((iVar9 < 0xc || (0xd < iVar9)))) {
    bVar4 = false;
  }
  else {
    bVar4 = true;
  }
  local_84 = (float *)(param_1 + 0x11db);
  local_3c[0] = *(float *)(param_1 + 0x120b);
  local_3c[1] = (float)*(undefined4 *)(param_1 + 0x120f);
  local_3c[2] = (float)*(undefined4 *)(param_1 + 0x1213);
  local_3c[3] = (float)*(undefined4 *)(param_1 + 0x1217);
  local_4c[0] = *(float *)(param_1 + 0x11eb);
  local_4c[1] = (float)*(undefined4 *)(param_1 + 0x11ef);
  local_4c[2] = (float)*(undefined4 *)(param_1 + 0x11f3);
  local_4c[3] = (float)*(undefined4 *)(param_1 + 0x11f7);
  local_2c[0] = *local_84;
  local_2c[1] = (float)*(undefined4 *)(param_1 + 0x11df);
  local_2c[2] = (float)*(undefined4 *)(param_1 + 0x11e3);
  local_5c[0] = *(float *)(param_1 + 0x11cb);
  local_2c[3] = (float)*(undefined4 *)(param_1 + 0x11e7);
  local_5c[1] = (float)*(undefined4 *)(param_1 + 0x11cf);
  local_5c[2] = (float)*(undefined4 *)(param_1 + 0x11d3);
  local_5c[3] = (float)*(undefined4 *)(param_1 + 0x11d7);
  if (!bVar17) {
    fVar15 = 0.0;
    pfVar13 = (float *)(param_1 + 0x11df);
    local_a0 = 0.0;
    local_a4 = 0.0;
    iVar9 = 3;
    fVar1 = _DAT_006e97d8;
    do {
      if (local_a4 < pfVar13[-4]) {
        local_a4 = pfVar13[-4];
      }
      if (local_a0 < pfVar13[4]) {
        local_a0 = pfVar13[4];
      }
      if (*pfVar13 < fVar1) {
        fVar1 = *pfVar13;
      }
      if ((int)fVar15 < (int)pfVar13[0xc]) {
        fVar15 = pfVar13[0xc];
      }
      pfVar13[-4] = 0.0;
      pfVar13 = pfVar13 + 1;
      iVar9 = iVar9 + -1;
    } while (iVar9 != 0);
    *(float *)(param_1 + 0x11cb) = local_a4;
    *local_84 = fVar1;
    *(float *)(param_1 + 0x11eb) = local_a0;
    *(float *)(param_1 + 0x120b) = fVar15;
  }
  if (cVar6 != '\0') {
    iVar9 = FUN_0051c2d0();
    cVar7 = FUN_00548a00(*(undefined4 *)(iVar9 + 0xc));
    if (cVar7 != '\0') {
      local_94 = 1.4013e-45;
    }
  }
  if (param_2 == '\0') {
    iVar9 = 1;
    pfVar13 = (float *)(param_1 + 0x119a);
    do {
      if (_DAT_006ea454 < *pfVar13) {
        FUN_005acd70(param_1);
        break;
      }
      iVar9 = iVar9 + 1;
      pfVar13 = pfVar13 + 1;
    } while (iVar9 < 4);
  }
  if (((*(float *)(param_1 + 0x119a) == _DAT_006ea454) &&
      (*(float *)(param_1 + 0x119e) == _DAT_006ea454)) &&
     (fVar1 = *(float *)(param_1 + 0x124b) - _DAT_006e9824, *(float *)(param_1 + 0x124b) = fVar1,
     fVar1 < _DAT_006ea454)) {
    *(undefined4 *)(param_1 + 0x124b) = 0;
  }
  piVar16 = (int *)(param_1 + 0x11a6);
  if (*(int *)(param_1 + 0x11a6) == 0) {
    piVar11 = (int *)(param_1 + 0x11b6);
    *piVar11 = 0;
    cVar7 = FUN_00412050(*(undefined4 *)(param_1 + 0x572),local_6c,piVar11,4,bVar17);
    if ((cVar7 != '\0') && (0 < *piVar11)) {
      iVar9 = 0;
      if (0 < *piVar11) {
        do {
          piVar11 = (int *)FUN_004ed0d0(local_6c[iVar9],*(undefined4 *)(param_1 + 0x5ae),
                                        *(undefined4 *)(param_1 + 0x1182),0,0,1,1,0,0,0);
          if (*piVar16 != *piVar11) {
            if (*piVar16 != 0) {
              FUN_004c0e30();
            }
            iVar10 = *piVar11;
            *piVar16 = iVar10;
            if (iVar10 != 0) {
              *(int *)(iVar10 + 4) = *(int *)(iVar10 + 4) + 1;
            }
          }
          FUN_004ed160();
          if (*piVar16 == 0) {
            iVar10 = 0;
          }
          else {
            iVar10 = *(int *)(*piVar16 + 8);
          }
          local_80[iVar9] = iVar10;
          iVar9 = iVar9 + 1;
          piVar16 = piVar16 + 1;
        } while (iVar9 < *(int *)(param_1 + 0x11b6));
      }
      FUN_004eaa60(local_80,*(undefined4 *)(param_1 + 0x11b6),0xffffffff);
      *(bool *)(param_1 + 0x11ba) = bVar17;
    }
  }
  else {
    if ((bool)*(char *)(param_1 + 0x11ba) == bVar17) {
      iVar9 = *(int *)(param_1 + 0x11b6);
      iVar10 = 0;
      if (0 < iVar9) {
        do {
          if (*piVar16 == 0) {
            iVar14 = 0;
          }
          else {
            iVar14 = *(int *)(*piVar16 + 8);
          }
          local_80[iVar10] = iVar14;
          iVar10 = iVar10 + 1;
          piVar16 = piVar16 + 1;
        } while (iVar10 < iVar9);
      }
    }
    else {
      iVar9 = *(int *)(param_1 + 0x11b6);
      iVar10 = 0;
      if (0 < iVar9) {
        do {
          if (*piVar16 == 0) {
            iVar14 = 0;
          }
          else {
            iVar14 = *(int *)(*piVar16 + 8);
          }
          local_80[iVar10] = iVar14;
          iVar10 = iVar10 + 1;
          piVar16 = piVar16 + 1;
        } while (iVar10 < iVar9);
      }
      FUN_004f03f0(local_1c,local_80,iVar9);
      piVar16 = (int *)(param_1 + 0x11b6);
      local_a0 = 0.0;
      if (0 < *(int *)(param_1 + 0x11b6)) {
        piVar11 = (int *)(param_1 + 0x11a6);
        do {
          piVar12 = (int *)FUN_004ed0c0();
          if (*piVar11 != *piVar12) {
            if (*piVar11 != 0) {
              FUN_004c0e30();
            }
            iVar9 = *piVar12;
            *piVar11 = iVar9;
            if (iVar9 != 0) {
              *(int *)(iVar9 + 4) = *(int *)(iVar9 + 4) + 1;
            }
          }
          FUN_004ed160();
          local_a0 = (float)((int)local_a0 + 1);
          piVar11 = piVar11 + 1;
        } while ((int)local_a0 < *piVar16);
      }
      *piVar16 = 0;
      cVar7 = FUN_00412050(*(undefined4 *)(param_1 + 0x572),local_6c,piVar16,4,bVar17);
      if ((cVar7 == '\0') || (*piVar16 < 1)) {
        *piVar16 = 0;
      }
      else {
        iVar9 = 0;
        if (0 < *piVar16) {
          piVar16 = (int *)(param_1 + 0x11a6);
          do {
            piVar11 = (int *)FUN_004ed0d0(local_6c[iVar9],*(undefined4 *)(param_1 + 0x5ae),
                                          *(undefined4 *)(param_1 + 0x1182),0,0,1,1,0,0,0);
            if (*piVar16 != *piVar11) {
              if (*piVar16 != 0) {
                FUN_004c0e30();
              }
              iVar10 = *piVar11;
              *piVar16 = iVar10;
              if (iVar10 != 0) {
                *(int *)(iVar10 + 4) = *(int *)(iVar10 + 4) + 1;
              }
            }
            FUN_004ed160();
            if (*piVar16 == 0) {
              iVar10 = 0;
            }
            else {
              iVar10 = *(int *)(*piVar16 + 8);
            }
            local_80[iVar9] = iVar10;
            iVar9 = iVar9 + 1;
            piVar16 = piVar16 + 1;
          } while (iVar9 < *(int *)(param_1 + 0x11b6));
        }
        FUN_004eaa60(local_80,*(undefined4 *)(param_1 + 0x11b6),0xffffffff);
        FUN_004f0410(local_1c,local_80,*(undefined4 *)(param_1 + 0x11b6));
      }
    }
    *(bool *)(param_1 + 0x11ba) = bVar17;
  }
  local_a4 = 800.0;
  if (cVar6 == '\0') {
    local_a4 = -2.0;
  }
  if (DAT_0074e924 == '\0') {
    fVar18 = (float10)_DAT_006ea454;
  }
  else {
    fVar18 = (float10)FUN_0051658a(*(undefined4 *)(param_1 + 0x5ae),&LAB_00564ad0);
  }
  fVar18 = (float10)_DAT_006e97d8 - fVar18;
  iVar9 = 0;
  fVar3 = (float10)_DAT_006e97d8;
  if (0 < *(int *)(param_1 + 0x11b6)) {
    piVar16 = (int *)(param_1 + 0x11a6);
    do {
      if (local_80[iVar9] != 0) {
        if ((local_a5 == '\0') || (!bVar17)) {
          uVar8 = 0;
        }
        else {
          uVar8 = 1;
        }
        *(undefined1 *)(local_80[iVar9] + 0x7c2) = uVar8;
        FUN_004eac30(*(undefined4 *)(param_1 + 0x1508),*(undefined4 *)(param_1 + 0x1510),
                     *(float *)(param_1 + 0x454 + (*(uint *)(param_1 + 0x14fc) & 7) * 4) *
                     *(float *)(param_1 + 0x474),local_94,local_a4);
        if (*piVar16 != 0) {
          *(uint *)(*piVar16 + 0x24) = 2 - (uint)(cVar6 != '\0');
        }
        fVar19 = (float10)FUN_005577d0(local_80[iVar9],*(undefined4 *)(param_1 + 0x1508),
                                       *(undefined4 *)(param_1 + 0x1510));
        local_a0 = (float)fVar19;
        if (*(int *)(param_1 + 0x596) == 0) {
          local_a0 = local_a0 * _DAT_006ea508;
        }
        if (bVar17) {
          if (*piVar16 != 0) {
            *(undefined4 *)(*piVar16 + 0x34) = DAT_0074e90c;
          }
          iVar10 = *piVar16;
          if (local_a5 == '\0') {
            if (bVar4) {
              if (iVar10 != 0) {
                uVar23 = 0;
                puVar21 = &DAT_0074cb58;
                goto LAB_0056427e;
              }
            }
            else if (iVar10 != 0) {
              uVar23 = 0;
              goto LAB_0056427c;
            }
          }
          else if (iVar10 != 0) {
            uVar23 = 1;
LAB_0056427c:
            puVar21 = (undefined *)0x0;
LAB_0056427e:
            FUN_004f0920(puVar21,0,uVar23);
            if (*piVar16 != 0) {
              FUN_004f0aa0((float)(fVar3 - fVar18 * fVar18 * fVar18));
            }
          }
        }
        else if (*piVar16 != 0) {
          FUN_004f0920(0,0,0);
          if (*piVar16 != 0) {
            *(undefined4 *)(*piVar16 + 0x34) = 0;
          }
        }
        fVar19 = (float10)(**(code **)(*(int *)local_80[iVar9] + 0x2c))();
        FUN_004ed1d0((float)fVar19);
        FUN_004ed190(local_a0);
      }
      iVar9 = iVar9 + 1;
      piVar16 = piVar16 + 1;
    } while (iVar9 < *(int *)(param_1 + 0x11b6));
  }
  piVar16 = (int *)(param_1 + 0x11bb);
  local_a0 = 5.60519e-45;
  do {
    bVar5 = false;
    if ((float)piVar16[4] <= _DAT_006f3fe8) {
      if (*piVar16 != 0) {
        piVar16[0x1c] = -0x41800000;
        piVar16[4] = piVar16[0x20];
      }
      if ((float)piVar16[0x18] < (float)_DAT_006ef6d8) {
        piVar11 = (int *)FUN_004ed0c0();
        puVar2 = (undefined4 *)*piVar16;
        if (puVar2 != (undefined4 *)*piVar11) {
          if ((puVar2 != (undefined4 *)0x0) &&
             (iVar9 = puVar2[1], puVar2[1] = iVar9 + -1, iVar9 + -1 == 0)) {
            (**(code **)*puVar2)(1);
          }
          iVar9 = *piVar11;
          *piVar16 = iVar9;
          if (iVar9 != 0) {
            *(int *)(iVar9 + 4) = *(int *)(iVar9 + 4) + 1;
          }
        }
        FUN_004ed160();
        goto LAB_00564431;
      }
    }
    else {
      if (((*piVar16 == 0) || (piVar16[0x14] != piVar16[0x10])) &&
         (iVar9 = FUN_00556e20(piVar16[0x14]), iVar9 != 0)) {
        iVar10 = *piVar16;
        piVar11 = (int *)FUN_004ed0d0(iVar9,*(undefined4 *)(param_1 + 0x5ae),
                                      *(undefined4 *)(param_1 + 0x1182),0,0,4,1,0,0,0);
        puVar2 = (undefined4 *)*piVar16;
        if (puVar2 != (undefined4 *)*piVar11) {
          if ((puVar2 != (undefined4 *)0x0) &&
             (iVar9 = puVar2[1], puVar2[1] = iVar9 + -1, iVar9 + -1 == 0)) {
            (**(code **)*puVar2)(1);
          }
          iVar9 = *piVar11;
          *piVar16 = iVar9;
          if (iVar9 != 0) {
            *(int *)(iVar9 + 4) = *(int *)(iVar9 + 4) + 1;
          }
        }
        FUN_004ed160();
        bVar5 = true;
        if (*piVar16 == 0) {
          piStack_88 = (int *)0x0;
        }
        else {
          piStack_88 = *(int **)(*piVar16 + 8);
        }
        FUN_004eaa60(&piStack_88,1,0);
        if (iVar10 == 0) {
          piVar16[0x18] = 0;
        }
      }
      piVar16[0x1c] = 0x3e800000;
      piVar16[0x20] = piVar16[4];
LAB_00564431:
      piVar16[0x10] = piVar16[0x14];
    }
    if (*piVar16 == 0) {
      piStack_88 = (int *)0x0;
    }
    else {
      piStack_88 = *(int **)(*piVar16 + 8);
    }
    if (piStack_88 != (int *)0x0) {
      *(char *)((int)piStack_88 + 0x7c2) = local_a5;
      FUN_004eac30(piVar16[0xc],0x3f800000,0x3f800000,0,0xbf800000);
      FUN_004ed1d0(piVar16[8]);
      FUN_004ed190((float)piVar16[0x18] * (float)piVar16[4]);
      piVar16[4] = 0;
      if (bVar5) {
        dVar20 = rndUniform(0);
        local_a4 = (float)dVar20;
        if (dVar20 < (double)_DAT_006ea454) {
          local_a4 = -local_a4;
        }
        (**(code **)(*piStack_88 + 0x18))(local_a4);
      }
    }
    fVar1 = (float)piVar16[0x1c] + (float)piVar16[0x18];
    piVar16[0x18] = (int)fVar1;
    if (fVar1 <= _DAT_006e97d8) {
      if (fVar1 < _DAT_006ea454) {
        piVar16[0x18] = 0;
      }
    }
    else {
      piVar16[0x18] = 0x3f800000;
    }
    piVar16 = piVar16 + 1;
    local_a0 = (float)((int)local_a0 + -1);
  } while (local_a0 != 0.0);
  piVar16 = (int *)(param_1 + 0x11bb);
  if (bVar17) {
    iVar9 = 0;
    do {
      FUN_00563460(param_1,local_6c,iVar9);
      if (*piVar16 != 0) {
        FUN_004f0920(local_6c,*(undefined4 *)(param_1 + 0x5ae),0);
        if (*piVar16 != 0) {
          *(undefined4 *)(*piVar16 + 0x34) = DAT_0074e90c;
        }
      }
      iVar9 = iVar9 + 1;
      piVar16 = piVar16 + 1;
    } while (iVar9 < 4);
LAB_0056459f:
    if (DAT_0074e910 < *(float *)(param_1 + 0x15b0)) {
      local_a4 = *(float *)(param_1 + 0x15b0) * _DAT_006f5e34;
      if (local_a4 <= _DAT_006e97d8) {
        if (local_a4 < _DAT_006ea454) {
          local_a4 = 0.0;
        }
      }
      else {
        local_a4 = 1.0;
      }
      piVar16 = (int *)(param_1 + 0x13af);
      if (*(int *)(param_1 + 0x13af) != 0) {
        fVar18 = (float10)FUN_004ed1b0();
        if (fVar18 * (float10)DAT_0074e914 < (float10)local_a4) {
          piVar11 = (int *)FUN_004ed0c0();
          puVar2 = (undefined4 *)*piVar16;
          if (puVar2 != (undefined4 *)*piVar11) {
            if ((puVar2 != (undefined4 *)0x0) &&
               (iVar9 = puVar2[1], puVar2[1] = iVar9 + -1, iVar9 + -1 == 0)) {
              (**(code **)*puVar2)(1);
            }
            iVar9 = *piVar11;
            *piVar16 = iVar9;
            if (iVar9 != 0) {
              *(int *)(iVar9 + 4) = *(int *)(iVar9 + 4) + 1;
            }
          }
          FUN_004ed160();
        }
        if (*piVar16 != 0) goto LAB_005647a7;
      }
      local_94 = 0.5;
      if ((DAT_0074e91c < DAT_0074e920) && (DAT_0074e910 < _DAT_006e97d8)) {
        local_94 = (DAT_0074e920 - DAT_0074e91c) *
                   ((local_a4 - DAT_0074e910) / (_DAT_006e97d8 - DAT_0074e910)) + DAT_0074e91c;
      }
      rndUniform(0);
      if (local_a5 == '\0') {
        iVar9 = FUN_006c5018();
        iVar9 = 0x24 - iVar9;
        if (0x26 < iVar9) {
          iVar9 = 0x27;
        }
      }
      else {
        iVar9 = FUN_006c5018();
        iVar9 = 0x20 - iVar9;
        if (0x22 < iVar9) {
          iVar9 = 0x23;
        }
      }
      piVar11 = (int *)FUN_004ed0d0(*(undefined4 *)(&DAT_00d8c358 + iVar9 * 4),
                                    *(undefined4 *)(param_1 + 0x5ae),
                                    *(undefined4 *)(param_1 + 0x1182),0,local_94,
                                    2 - (uint)(cVar6 != '\0'),1,FUN_00564a80,param_1,0);
      puVar2 = (undefined4 *)*piVar16;
      if (puVar2 != (undefined4 *)*piVar11) {
        if ((puVar2 != (undefined4 *)0x0) &&
           (iVar10 = puVar2[1], puVar2[1] = iVar10 + -1, iVar10 + -1 == 0)) {
          (**(code **)*puVar2)(1);
        }
        iVar10 = *piVar11;
        *piVar16 = iVar10;
        if (iVar10 != 0) {
          *(int *)(iVar10 + 4) = *(int *)(iVar10 + 4) + 1;
        }
      }
      FUN_004ed160();
      iVar9 = FUN_005568b0(iVar9);
      if ((iVar9 != 0) && (*piVar16 != 0)) {
        FUN_004f0920(iVar9,*(undefined4 *)(param_1 + 0x5ae),0);
      }
    }
  }
  else {
    iVar9 = 4;
    do {
      if (*piVar16 != 0) {
        FUN_004f0920(0,0,0);
        if (*piVar16 != 0) {
          *(undefined4 *)(*piVar16 + 0x34) = 0;
        }
      }
      piVar16 = piVar16 + 1;
      iVar9 = iVar9 + -1;
    } while (iVar9 != 0);
    if (DAT_0074e918 == '\0') goto LAB_0056459f;
  }
LAB_005647a7:
  piVar16 = (int *)(param_1 + 0x1186);
  local_a0 = (float)(param_1 + 0x124f);
  local_a4 = 0.0;
  piStack_70 = piVar16;
  do {
    if ((float)piVar16[4] <= _DAT_006ea454) {
      if (*piVar16 != 0) {
        piVar11 = (int *)FUN_004ed0c0();
        puVar2 = (undefined4 *)*piVar16;
        if (puVar2 != (undefined4 *)*piVar11) {
          if ((puVar2 != (undefined4 *)0x0) &&
             (iVar9 = puVar2[1], puVar2[1] = iVar9 + -1, iVar9 + -1 == 0)) {
            (**(code **)*puVar2)(1);
          }
          iVar9 = *piVar11;
          *piVar16 = iVar9;
          if (iVar9 != 0) {
            *(int *)(iVar9 + 4) = *(int *)(iVar9 + 4) + 1;
          }
        }
        FUN_004ed160();
      }
    }
    else {
      iVar9 = FUN_005632c0(param_1,local_a4);
      if (*piVar16 == 0) {
        if ((param_2 == '\0') && ((local_a4 == 1.4013e-45 || (local_a4 == 2.8026e-45)))) {
          iVar10 = *(int *)(param_1 + 0x5ae);
          *(undefined4 *)((int)local_a0 + 0xc) = *(undefined4 *)(iVar10 + 0xc);
          *(undefined4 *)((int)local_a0 + 0x10) = *(undefined4 *)(iVar10 + 0x10);
          *(undefined4 *)((int)local_a0 + 0x14) = *(undefined4 *)(iVar10 + 0x14);
          piVar11 = (int *)FUN_004ed0d0(*(undefined4 *)(&DAT_00d8c358 + iVar9 * 4),local_a0,
                                        *(undefined4 *)(param_1 + 0x1182),
                                        *(undefined4 *)(&DAT_006f5db4 + (int)local_a4 * 4),
                                        piVar16[4],*(undefined4 *)(&DAT_0074ca88 + iVar9 * 4),1,0,0,
                                        0);
          puVar2 = (undefined4 *)*piVar16;
          if (puVar2 != (undefined4 *)*piVar11) {
            if ((puVar2 != (undefined4 *)0x0) &&
               (iVar10 = puVar2[1], puVar2[1] = iVar10 + -1, iVar10 + -1 == 0)) {
              (**(code **)*puVar2)(1);
            }
            iVar10 = *piVar11;
            *piVar16 = iVar10;
            if (iVar10 != 0) {
              *(int *)(iVar10 + 4) = *(int *)(iVar10 + 4) + 1;
            }
          }
        }
        else {
          piVar11 = (int *)FUN_004ed0d0(*(undefined4 *)(&DAT_00d8c358 + iVar9 * 4),
                                        *(undefined4 *)(param_1 + 0x5ae),
                                        *(undefined4 *)(param_1 + 0x1182),
                                        *(undefined4 *)(&DAT_006f5db4 + (int)local_a4 * 4),
                                        piVar16[4],*(undefined4 *)(&DAT_0074ca88 + iVar9 * 4),1,0,0,
                                        0);
          puVar2 = (undefined4 *)*piVar16;
          if (puVar2 != (undefined4 *)*piVar11) {
            if ((puVar2 != (undefined4 *)0x0) &&
               (iVar10 = puVar2[1], puVar2[1] = iVar10 + -1, iVar10 + -1 == 0)) {
              (**(code **)*puVar2)(1);
            }
            iVar10 = *piVar11;
            *piVar16 = iVar10;
            if (iVar10 != 0) {
              *(int *)(iVar10 + 4) = *(int *)(iVar10 + 4) + 1;
            }
          }
        }
        FUN_004ed160();
      }
      iVar10 = *piVar16;
      if (bVar17) {
        if ((&DAT_0074cb2c)[iVar9] == '\0') {
          if (iVar10 != 0) {
            uVar23 = 0;
            uVar22 = 0;
            goto LAB_00564932;
          }
        }
        else if (iVar10 != 0) {
          uVar23 = *(undefined4 *)(param_1 + 0x5ae);
          uVar22 = *(undefined4 *)(&DAT_0074cd58 + iVar9 * 4);
LAB_00564932:
          FUN_004f0920(uVar22,uVar23,0);
          if (*piVar16 != 0) {
            *(undefined4 *)(*piVar16 + 0x34) = DAT_0074e90c;
          }
        }
      }
      else if (iVar10 != 0) {
        FUN_004f0920(0,0,0);
        if (*piVar16 != 0) {
          *(undefined4 *)(*piVar16 + 0x34) = 0;
        }
      }
      FUN_004ed190(piVar16[4]);
      piVar16[4] = 0;
    }
    piVar11 = piStack_70;
    local_a4 = (float)((int)local_a4 + 1);
    local_a0 = (float)((int)local_a0 + 0x58);
    piVar16 = piVar16 + 1;
  } while ((int)local_a4 < 4);
  FUN_004ed1d0(*(float *)(param_1 + 0x5aa) * _DAT_006f5e30 + _DAT_006e981c);
  if ((bVar17) && ((bVar4 || (local_a5 != '\0')))) {
    if (*piVar11 == 0) goto LAB_00564a32;
    puVar21 = &DAT_0074cb58;
  }
  else {
    if (*piVar11 == 0) goto LAB_00564a32;
    puVar21 = (undefined *)0x0;
  }
  FUN_004f0920(puVar21,0,0);
LAB_00564a32:
  if (param_2 == '\0') {
    iVar9 = 0;
    do {
      iVar10 = iVar9 + 4;
      local_84[-4] = *(float *)((int)local_5c + iVar9);
      *local_84 = *(float *)((int)local_2c + iVar9);
      local_84[4] = *(float *)((int)local_4c + iVar9);
      local_84[0xc] = *(float *)((int)local_3c + iVar9);
      local_84 = local_84 + 1;
      iVar9 = iVar10;
    } while (iVar10 < 0x10);
  }
  return;
}


