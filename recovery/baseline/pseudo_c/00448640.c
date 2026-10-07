/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00448640 */

/* WARNING (jumptable): Unable to track spacebase fully for stack */
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint __fastcall FUN_00448640(int param_1)

{
  double dVar1;
  ushort uVar2;
  ushort uVar3;
  bool bVar4;
  double dVar5;
  bool bVar6;
  char cVar7;
  undefined2 extraout_var;
  uint uVar8;
  int iVar9;
  uint3 uVar10;
  int *piVar11;
  int *piVar12;
  int iVar13;
  float10 fVar14;
  float10 fVar15;
  undefined4 uVar16;
  
  dVar1 = DAT_0089bd2f;
  uVar8 = DAT_0089e3d8;
  if (((DAT_0089e3d8 != 0) && (*(int *)(DAT_0089e3d8 + 0x5ae) != 0)) &&
     ((DAT_0089bcfd == '\0' ||
      (uVar8 = CONCAT31((int3)(DAT_0089e3d8 >> 8),DAT_0089bd15), DAT_0089bd15 == '\0')))) {
    fVar14 = (float10)thunk_FUN_0055a760();
    fVar14 = fVar14 - (float10)dVar1;
    fVar15 = (float10)_DAT_006ed050;
    uVar8 = CONCAT22(extraout_var,
                     (ushort)(fVar14 < fVar15) << 8 | (ushort)(NAN(fVar14) || NAN(fVar15)) << 10 |
                     (ushort)(fVar14 == fVar15) << 0xe);
    if ((fVar14 >= fVar15) &&
       (((uVar8 = FUN_00567280(), uVar8 != 7 || (uVar8 = 0, DAT_0089bce1 == '\0')) &&
        (uVar8 = CONCAT31((int3)(uVar8 >> 8),DAT_0089e3e4), DAT_0089e3e4 == '\0')))) {
      if ((_DAT_0089b904 != _DAT_006ea4b8) &&
         (fVar15 = (float10)(*(code *)*DAT_0089b900)(), fVar15 <= (float10)_DAT_0089b904)) {
        fVar15 = (float10)(*(code *)*DAT_0089b900)();
        uVar2 = (ushort)((float10)_DAT_0089b904 - fVar15 < (float10)_DAT_006ea4b0);
        uVar3 = (ushort)((float10)_DAT_0089b904 - fVar15 == (float10)_DAT_006ea4b0);
        uVar8 = (uint)(ushort)(uVar2 << 8 | uVar3 << 0xe);
        if (uVar2 == 0 && uVar3 == 0) goto LAB_0044915d;
      }
      uVar8 = FUN_00450190();
      if ((((char)uVar8 == '\0') &&
          (uVar8 = FUN_005365c0(*(undefined4 *)(DAT_0089e3d8 + 0x5ae),0), (char)uVar8 == '\0')) &&
         (uVar8 = FUN_004504c0(), (char)uVar8 != '\0')) {
        FUN_004484b0();
        cVar7 = FUN_004503b0();
        iVar13 = *(int *)(param_1 + 0x35);
        if (cVar7 == '\0') {
          if (iVar13 == 0) {
            if (*(int *)(param_1 + 0x31) == 0) {
              iVar13 = 1;
            }
            else {
LAB_004487a1:
              if (iVar13 < 2) {
                if (iVar13 != 1) {
                  if (1 < *(int *)(param_1 + 0x31)) {
                    bVar4 = false;
                    iVar13 = 0;
                    bVar6 = false;
                    if (0 < *(int *)(param_1 + 0x31)) {
                      piVar11 = (int *)(param_1 + 0x19);
                      do {
                        if (bVar4) goto LAB_004489f3;
                        iVar9 = 0;
                        if (0 < *(int *)(param_1 + 0x31)) {
                          piVar12 = (int *)(param_1 + 0x19);
                          do {
                            if ((iVar13 != iVar9) &&
                               (_DAT_006ef678 <
                                ABS((*(float *)(*(int *)PTR_DAT_00749378 + 0x14 +
                                               (int)ROUND(*(float *)(*(int *)(*piVar12 + 0x5ae) +
                                                                    0x3c) * _DAT_00898818) * 0x1c) -
                                    *(float *)(*(int *)(*piVar12 + 0x5ae) + 0x40)) -
                                    (*(float *)(*(int *)PTR_DAT_00749378 + 0x14 +
                                               (int)ROUND(*(float *)(*(int *)(*piVar11 + 0x5ae) +
                                                                    0x3c) * _DAT_00898818) * 0x1c) -
                                    *(float *)(*(int *)(*piVar11 + 0x5ae) + 0x40))))) {
                              bVar6 = true;
                              bVar4 = true;
                              break;
                            }
                            iVar9 = iVar9 + 1;
                            piVar12 = piVar12 + 1;
                            bVar4 = bVar6;
                          } while (iVar9 < *(int *)(param_1 + 0x31));
                        }
                        iVar13 = iVar13 + 1;
                        piVar11 = piVar11 + 1;
                      } while (iVar13 < *(int *)(param_1 + 0x31));
                      if (bVar4) {
LAB_004489f3:
                        iVar13 = 5;
                        goto LAB_00448a1f;
                      }
                    }
                  }
                  iVar13 = 2;
                  goto LAB_00448a1f;
                }
              }
              else {
                bVar4 = false;
                iVar9 = 0;
                bVar6 = false;
                if (0 < iVar13) {
                  piVar11 = (int *)(param_1 + 0x25);
                  do {
                    if (bVar4) goto LAB_004488bd;
                    iVar13 = 0;
                    if (0 < *(int *)(param_1 + 0x35)) {
                      piVar12 = (int *)(param_1 + 0x25);
                      do {
                        if ((iVar9 != iVar13) &&
                           (_DAT_006ef678 <
                            ABS((*(float *)(*(int *)PTR_DAT_00749378 + 0x14 +
                                           (int)ROUND(*(float *)(*(int *)(*piVar12 + 0x5ae) + 0x3c)
                                                      * _DAT_00898818) * 0x1c) -
                                *(float *)(*(int *)(*piVar12 + 0x5ae) + 0x40)) -
                                (*(float *)(*(int *)PTR_DAT_00749378 + 0x14 +
                                           (int)ROUND(*(float *)(*(int *)(*piVar11 + 0x5ae) + 0x3c)
                                                      * _DAT_00898818) * 0x1c) -
                                *(float *)(*(int *)(*piVar11 + 0x5ae) + 0x40))))) {
                          bVar6 = true;
                          bVar4 = true;
                          break;
                        }
                        iVar13 = iVar13 + 1;
                        piVar12 = piVar12 + 1;
                        bVar4 = bVar6;
                      } while (iVar13 < *(int *)(param_1 + 0x35));
                    }
                    iVar9 = iVar9 + 1;
                    piVar11 = piVar11 + 1;
                  } while (iVar9 < *(int *)(param_1 + 0x35));
                  if (bVar4) {
LAB_004488bd:
                    iVar13 = 6;
                    goto LAB_00448a1f;
                  }
                }
              }
              iVar13 = 3;
            }
          }
          else {
            if (*(int *)(param_1 + 0x31) == 0) goto LAB_004487a1;
            iVar13 = 4;
          }
        }
        else if ((iVar13 == 0) && (*(int *)(param_1 + 0x31) == 0)) {
          iVar13 = 1;
        }
        else {
          iVar13 = (iVar13 != 0) + 2;
        }
LAB_00448a1f:
        fVar15 = (float10)thunk_FUN_0055a760();
        bVar4 = false;
        dVar1 = (double)fVar15;
        iVar9 = *(int *)(param_1 + 0x39) + -1;
        switch(iVar9) {
        case 0:
          iVar9 = iVar13 + -2;
          switch(iVar9) {
          case 0:
switchD_00448a4a_caseD_0:
            iVar9 = FUN_004503c0();
            if (iVar9 < 1) {
              iVar9 = FUN_004503c0();
              if (-1 < iVar9) goto LAB_00448fca;
              iVar9 = FUN_00451020(1,0x61,0x32,0x62,0x32,0xffffffff,0);
            }
            else {
              iVar9 = FUN_00451020(1,99,0x32,100,0x32,0xffffffff,0);
            }
            break;
          case 1:
switchD_00448a5d_caseD_2:
            iVar9 = FUN_004503c0();
            if (iVar9 < 1) {
              iVar9 = FUN_004503c0();
              if (-1 < iVar9) goto LAB_00449022;
              iVar9 = FUN_00451020(1,99,0x32,100,0x32,0xffffffff,0);
            }
            else {
LAB_00448fe5:
              iVar9 = FUN_00451020(1,0x61,0x32,0x62,0x32,0xffffffff,0);
            }
            break;
          case 2:
switchD_00448f3b_caseD_3:
            iVar9 = FUN_00450ec0(1,0x5c,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
            break;
          case 3:
switchD_00448b6e_caseD_4:
            iVar9 = FUN_004503c0();
            if (iVar9 < 1) {
              iVar9 = FUN_004503c0();
              if (iVar9 < 0) {
                iVar9 = FUN_00450ec0(1,0x5d,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
              }
              else {
                iVar9 = FUN_00450ec0(1,0x60,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
              }
            }
            else {
LAB_0044903a:
              iVar9 = FUN_00450ec0(1,0x5e,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
            }
            break;
          case 4:
switchD_00448b6e_caseD_5:
            iVar9 = FUN_004503c0();
            if (iVar9 < 1) {
              iVar9 = FUN_004503c0();
              if (-1 < iVar9) goto LAB_00448e49;
              iVar9 = FUN_00450ec0(1,0x5e,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
            }
            else {
              iVar9 = FUN_00450ec0(1,0x5d,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
            }
          }
          break;
        case 1:
          iVar9 = iVar13 + -1;
          switch(iVar9) {
          case 0:
            iVar9 = CONCAT31((int3)((uint)iVar9 >> 8),*(char *)(param_1 + 0x55));
            if (*(char *)(param_1 + 0x55) == '\0') {
LAB_00448f7b:
              *(undefined1 *)(param_1 + 0x55) = 1;
LAB_004490a9:
              bVar4 = true;
            }
            else {
              uVar8 = (uint)(dVar1 < *(double *)(param_1 + 0x49));
              iVar9 = uVar8 << 8;
              if (uVar8 != 0) break;
              iVar9 = FUN_004503c0();
              if (iVar9 < 1) {
                iVar9 = FUN_004503c0();
                if (iVar9 < 0) {
                  uVar16 = 0x67;
                }
                else {
                  uVar16 = 0x6d;
                }
              }
              else {
                uVar16 = 0x68;
              }
LAB_00448f65:
              iVar9 = FUN_00451020(1,0x65,0x32,uVar16,0x32,0xffffffff,0);
              *(undefined1 *)(param_1 + 0x55) = 0;
            }
            break;
          case 1:
            if ((*(int *)(param_1 + 0x3d) == 1) &&
               (uVar8 = (uint)(dVar1 < *(double *)(param_1 + 0x49)), iVar9 = uVar8 << 8, uVar8 == 0)
               ) {
              iVar9 = FUN_004503c0();
              if (iVar9 < 1) {
                iVar9 = FUN_004503c0();
                if (iVar9 < 0) {
                  iVar9 = FUN_00451020(1,0x71,0x32,0x75,0x32,0x78,0x32);
                }
                else {
                  iVar9 = FUN_00451020(1,0x73,0x32,0x77,0x32,0x78,0x32);
                }
              }
              else {
                iVar9 = FUN_00451020(1,0x70,0x32,0x74,0x32,0x78,0x32);
              }
              goto LAB_004490a9;
            }
            break;
          case 2:
            goto switchD_00448a5d_caseD_2;
          case 3:
            goto switchD_00448f3b_caseD_3;
          case 4:
            goto switchD_00448b6e_caseD_4;
          case 5:
            goto switchD_00448b6e_caseD_5;
          }
          break;
        case 2:
          iVar9 = iVar13 + -1;
          switch(iVar9) {
          case 0:
            iVar9 = CONCAT31((int3)((uint)iVar9 >> 8),*(char *)(param_1 + 0x55));
            if (*(char *)(param_1 + 0x55) == '\0') goto LAB_00448f7b;
            uVar8 = (uint)(dVar1 < *(double *)(param_1 + 0x49));
            iVar9 = uVar8 << 8;
            if (uVar8 == 0) {
              iVar9 = FUN_004503c0();
              if (iVar9 < 1) {
                iVar9 = FUN_004503c0();
                if (iVar9 < 0) {
                  uVar16 = 0x68;
                }
                else {
                  uVar16 = 0x6e;
                }
              }
              else {
                uVar16 = 0x67;
              }
              goto LAB_00448f65;
            }
            break;
          case 1:
            *(undefined4 *)(param_1 + 0x3d) = 0;
            goto switchD_00448a4a_caseD_0;
          case 2:
            if ((*(int *)(param_1 + 0x3d) == 1) &&
               (uVar8 = (uint)(dVar1 < *(double *)(param_1 + 0x49)), iVar9 = uVar8 << 8, uVar8 == 0)
               ) {
              iVar9 = FUN_004503c0();
              if (iVar9 < 1) {
                iVar9 = FUN_004503c0();
                if (iVar9 < 0) {
                  iVar9 = FUN_00451020(1,0x70,0x32,0x74,0x32,0x78,0x32);
                }
                else {
                  iVar9 = FUN_00451020(1,0x72,0x32,0x76,0x32,0x78,0x32);
                }
              }
              else {
                iVar9 = FUN_00451020(1,0x71,0x32,0x75,0x32,0x78,0x32);
              }
              goto LAB_004490a9;
            }
            break;
          case 3:
            goto switchD_00448f3b_caseD_3;
          case 4:
            goto switchD_00448b6e_caseD_4;
          case 5:
            goto switchD_00448b6e_caseD_5;
          }
          break;
        case 3:
          iVar9 = iVar13 + -1;
          switch(iVar9) {
          case 0:
switchD_00448f3b_caseD_0:
            iVar9 = CONCAT31((int3)((uint)(iVar13 + -1) >> 8),*(char *)(param_1 + 0x55));
            if (*(char *)(param_1 + 0x55) == '\0') goto LAB_00448f7b;
            uVar8 = (uint)(dVar1 < *(double *)(param_1 + 0x49));
            iVar9 = uVar8 << 8;
            if (uVar8 == 0) {
              uVar16 = 0x66;
              goto LAB_00448f65;
            }
            break;
          case 1:
            iVar9 = FUN_004503c0();
            if (iVar9 < 1) {
              iVar9 = FUN_004503c0();
              if (iVar9 < 0) {
                iVar9 = FUN_00451020(1,0x61,0x32,0x68,0x32,0xffffffff,0);
              }
              else {
                iVar9 = FUN_00451020(1,0x69,0x32,0x6e,0x32,0xffffffff,0);
              }
            }
            else {
              iVar9 = FUN_00451020(1,99,0x32,0x67,0x32,0xffffffff,0);
            }
            break;
          case 2:
            iVar9 = FUN_004503c0();
            if (iVar9 < 1) {
              iVar9 = FUN_004503c0();
              if (iVar9 < 0) {
                iVar9 = FUN_00451020(1,99,0x32,0x67,0x32,0xffffffff,0);
              }
              else {
                iVar9 = FUN_00451020(1,0x6b,0x32,0x6d,0x32,0xffffffff,0);
              }
            }
            else {
              iVar9 = FUN_00451020(1,0x61,0x32,0x68,0x32,0xffffffff,0);
            }
            break;
          case 3:
switchD_00448f3b_caseD_5:
            iVar9 = iVar13 + -1;
            if ((*(int *)(param_1 + 0x3d) == 1) &&
               (uVar8 = (uint)(dVar1 < *(double *)(param_1 + 0x49)), iVar9 = uVar8 << 8, uVar8 == 0)
               ) {
              iVar9 = FUN_00450ec0(1,0x6f,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
              goto LAB_004490a9;
            }
            break;
          case 4:
            iVar9 = FUN_004503c0();
            if (0 < iVar9) goto LAB_0044903a;
            iVar9 = FUN_004503c0();
            if (iVar9 < 0) {
              iVar9 = FUN_00450ec0(1,0x5d,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
            }
            else {
              iVar9 = FUN_00450ec0(1,0x60,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
            }
            break;
          case 5:
            iVar9 = FUN_004503c0();
            if (iVar9 < 1) goto LAB_00448e26;
LAB_00448f15:
            iVar9 = FUN_00450ec0(1,0x5d,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
          }
          break;
        case 4:
          iVar9 = iVar13 + -1;
          switch(iVar9) {
          case 0:
            goto switchD_00448f3b_caseD_0;
          case 1:
            iVar9 = FUN_004503c0();
            if (iVar9 < 1) {
              iVar9 = FUN_004503c0();
              if (iVar9 < 0) {
                iVar9 = FUN_00451020(1,0x61,0x32,0x62,0x32,0xffffffff,0);
              }
              else {
                iVar9 = FUN_00451020(1,0x69,0x32,0x6a,0x32,0xffffffff,0);
              }
            }
            else {
LAB_00448f8d:
              iVar9 = FUN_00451020(1,99,0x32,100,0x32,0xffffffff,0);
            }
            break;
          case 2:
            iVar9 = FUN_004503c0();
            if (0 < iVar9) goto LAB_00448fe5;
            iVar9 = FUN_004503c0();
            if (iVar9 < 0) {
              iVar9 = FUN_00451020(1,99,0x32,100,0x32,0xffffffff,0);
            }
            else {
              iVar9 = FUN_00451020(1,0x6b,0x32,0x6c,0x32,0xffffffff,0);
            }
            break;
          case 3:
            goto switchD_00448f3b_caseD_3;
          case 4:
            goto switchD_00448f3b_caseD_5;
          case 5:
            iVar9 = FUN_004503c0();
            if (0 < iVar9) goto LAB_00448f15;
LAB_00448e26:
            iVar9 = FUN_004503c0();
            if (iVar9 < 0) {
              iVar9 = FUN_00450ec0(1,0x5e,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
            }
            else {
LAB_00448e49:
              iVar9 = FUN_00450ec0(1,0x5f,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
            }
          }
          break;
        case 5:
          iVar9 = iVar13 + -1;
          switch(iVar9) {
          case 0:
            goto switchD_00448f3b_caseD_0;
          case 1:
            iVar9 = FUN_004503c0();
            if (0 < iVar9) goto LAB_00448f8d;
            iVar9 = FUN_004503c0();
            if (iVar9 < 0) {
              iVar9 = FUN_00451020(1,0x61,0x32,0x62,0x32,0xffffffff,0);
              break;
            }
LAB_00448fca:
            iVar9 = FUN_00451020(1,0x69,0x32,0x6a,0x32,0xffffffff,0);
            break;
          case 2:
            iVar9 = FUN_004503c0();
            if (0 < iVar9) goto LAB_00448fe5;
            iVar9 = FUN_004503c0();
            if (iVar9 < 0) {
              iVar9 = FUN_00451020(1,99,0x32,100,0x32,0xffffffff,0);
              break;
            }
LAB_00449022:
            iVar9 = FUN_00451020(1,0x6b,0x32,0x6c,0x32,0xffffffff,0);
            break;
          case 3:
            goto switchD_00448f3b_caseD_3;
          case 4:
            iVar9 = FUN_004503c0();
            if (0 < iVar9) goto LAB_0044903a;
            iVar9 = FUN_004503c0();
            if (iVar9 < 0) {
              iVar9 = FUN_00450ec0(1,0x5d,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
            }
            else {
              iVar9 = FUN_00450ec0(1,0x60,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
            }
            break;
          case 5:
            goto switchD_00448f3b_caseD_5;
          }
        }
        dVar5 = _DAT_006e9838;
        if (iVar13 != 1) {
          if (bVar4) {
            dVar5 = (dVar1 - *(double *)(param_1 + 0x41)) * _DAT_006ef688 + _DAT_006e9838;
            if (_DAT_006ecfd0 < dVar5) {
              dVar5 = _DAT_006ecfd0;
            }
LAB_0044910c:
            *(double *)(param_1 + 0x49) = dVar5 + dVar1;
          }
          else if (iVar13 != *(int *)(param_1 + 0x39)) {
            *(undefined4 *)(param_1 + 0x3d) = 0;
            *(double *)(param_1 + 0x41) = dVar1;
            goto LAB_0044910c;
          }
          uVar8 = DAT_007321b1;
          *(int *)(param_1 + 0x39) = iVar13;
          *(undefined1 *)(param_1 + 0x55) = 0;
          if (uVar8 != 0xffffffff) {
            uVar8 = FUN_0044c4d0();
            return uVar8 & 0xffffff00;
          }
          goto LAB_00449164;
        }
        uVar10 = (uint3)((uint)iVar9 >> 8);
        if (bVar4) {
          *(double *)(param_1 + 0x49) = dVar1 + _DAT_006e9808;
          return (uint)uVar10 << 8;
        }
        uVar8 = CONCAT31(uVar10,*(char *)(param_1 + 0x55));
        if (*(char *)(param_1 + 0x55) != '\0') goto LAB_00449164;
        *(undefined4 *)(param_1 + 0x3d) = 0;
      }
    }
  }
LAB_0044915d:
  *(undefined4 *)(param_1 + 0x39) = 1;
LAB_00449164:
  return uVar8 & 0xffffff00;
}


