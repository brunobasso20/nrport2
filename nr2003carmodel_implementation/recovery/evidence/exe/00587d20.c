/* NR2003.exe @ 00587d20 FUN_00587d20 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00587d20(int param_1)

{
  code **ppcVar1;
  bool bVar2;
  char cVar3;
  int *piVar4;
  int iVar5;
  int iVar6;
  float *pfVar7;
  uint uVar8;
  undefined4 *puVar9;
  undefined4 *puVar10;
  float fVar11;
  int *piVar12;
  int iVar13;
  int iVar14;
  uint uVar15;
  float *pfVar16;
  undefined4 unaff_EBP;
  undefined4 unaff_ESI;
  int unaff_EDI;
  float10 fVar17;
  float10 fVar18;
  float fVar19;
  undefined4 uVar20;
  float fVar21;
  uint uVar22;
  uint uVar23;
  int *piVar24;
  int **ppiVar25;
  float fVar26;
  int **ppiVar27;
  undefined4 *puStack_614;
  float *pfStack_610;
  undefined4 *puStack_60c;
  float fStack_608;
  float fStack_604;
  float fStack_600;
  float fStack_5fc;
  undefined8 uStack_5f8;
  undefined4 *puStack_5f0;
  int iStack_5ec;
  int *piStack_5e8;
  undefined4 *puStack_5e4;
  int iStack_5d0;
  int iStack_5b8;
  undefined4 uStack_5b0;
  undefined4 uStack_5ac;
  int aiStack_5a4 [4];
  int *piStack_594;
  int *apiStack_58c [12];
  int aiStack_55c [48];
  undefined4 uStack_49c;
  undefined4 auStack_498 [42];
  char acStack_3f0 [20];
  char cStack_3dc;
  undefined4 uStack_3db;
  int iStack_1e0;
  int *apiStack_1dc [119];
  
  puStack_5e4 = &DAT_00e0b840;
  piStack_5e8 = (int *)0x587d41;
  (**(code **)(**(int **)(param_1 + 0x61) + 0xc4))();
  piStack_5e8 = DAT_0075018c;
  iStack_5ec = 0x587d4d;
  FUN_00587bc0();
  iStack_5ec = DAT_00750190;
  puStack_5f0 = (undefined4 *)0x587d59;
  FUN_00587c70();
  piStack_5e8 = (int *)0x587d61;
  FUN_005b4b60();
  piStack_5e8 = (int *)0x587d66;
  FUN_00582f80();
  iVar14 = *(int *)(param_1 + 0x1eb);
  iVar13 = *(int *)(param_1 + 0x79);
  iStack_5b8 = 0;
  piStack_5e8 = (int *)0x587d80;
  piVar4 = (int *)FUN_005d35f0();
  piStack_5e8 = (int *)0x587d88;
  iVar5 = (**(code **)*piVar4)();
  piStack_5e8 = (int *)0x587d93;
  iVar6 = (**(code **)(*piVar4 + 4))();
  piStack_5e8 = aiStack_5a4;
  aiStack_5a4[0] = 0;
  iStack_5ec = 0x587dab;
  FUN_005d4450();
  iStack_5ec = iVar13;
  if ((aiStack_5a4[0] < iVar14 + 1) || (iVar14 == 0)) {
    if ((aiStack_5a4[0] != 0) &&
       ((iVar14 = (iVar6 << 2) / 3, iStack_5ec = iVar5, iVar13 != iVar14 && (iVar13 != iVar14 + 1)))
       ) {
      aiStack_5a4[0] = 0;
      iStack_5ec = iVar13;
    }
  }
  else if (1 < iVar14) {
    iStack_5b8 = *(int *)(param_1 + 0x79);
  }
  piStack_5e8 = *(int **)(param_1 + 0x7d);
  piVar4 = *(int **)(param_1 + 0x1db);
  puStack_5f0 = *(undefined4 **)(param_1 + 0x75);
  uStack_5f8._4_4_ = *(int *)(param_1 + 0x71) + iStack_5b8;
  uStack_5f8._0_4_ = 0x587e29;
  piStack_594 = piVar4;
  (**(code **)(**(int **)(param_1 + 0x81) + 0x18))();
  uStack_5f8._0_4_ = *(undefined4 *)(param_1 + 0x91);
  fStack_5fc = *(float *)(param_1 + 0x8d);
  fStack_600 = *(float *)(param_1 + 0x89);
  fStack_604 = 8.126826e-39;
  (**(code **)(**(int **)(param_1 + 0x81) + 8))();
  fStack_604 = *(float *)(param_1 + 0x10d);
  fStack_608 = *(float *)(param_1 + 0x109);
  puStack_60c = *(undefined4 **)(param_1 + 0x105);
  pfStack_610 = *(float **)(param_1 + 0x111);
  puStack_614 = (undefined4 *)0x587e70;
  (**(code **)(**(int **)(param_1 + 0x81) + 0x10))();
  puStack_5f0 = *(undefined4 **)(param_1 + 0x121);
  fVar17 = (float10)(float)puStack_5f0;
  if ((iStack_5d0 != 0) && (unaff_EDI == 0)) {
    if ((piVar4 != (int *)0x0) && ((*(byte *)(piVar4 + 0xc) & 1) != 0)) {
      fVar17 = (float10)_DAT_006f69a0;
    }
    fVar17 = (float10)fptan(fVar17 * (float10)_DAT_006ea668);
    fVar17 = (float10)fpatan(fVar17 * (float10)_DAT_006ecfe8,(float10)1);
    fVar17 = (float10)fptan((fVar17 + fVar17) * (float10)_DAT_006ea668);
    fVar17 = (float10)fpatan(fVar17 * (float10)((double)(int)piStack_5e8 / (double)uStack_5f8._4_4_)
                             ,(float10)1);
    fVar17 = fVar17 + fVar17;
    puStack_5f0 = (undefined4 *)(float)fVar17;
  }
  if ((float10)(float)DAT_006f697c <= fVar17) {
    puStack_5f0 = DAT_006f697c;
  }
  puStack_614 = puStack_5f0;
  (**(code **)(**(int **)(param_1 + 0x81) + 0x1c))();
  (**(code **)(**(int **)(param_1 + 0x81) + 0x28))(*(undefined4 *)(param_1 + 0x125));
  fVar18 = (float10)fptan((float10)_DAT_006f6998);
  fVar17 = (float10)fptan((float10)*(float *)(param_1 + 0x121) * (float10)_DAT_006ea44c);
  fVar18 = fVar18 / fVar17;
  fStack_5fc = (float)fVar18;
  if (_DAT_006ea514 < fStack_5fc) {
    fStack_5fc = 5.0;
  }
  if ((float10)_DAT_006ea62c < fVar18) {
    fVar18 = (float10)_DAT_006ea62c;
  }
  (**(code **)(**(int **)(param_1 + 0x81) + 0x24))
            ((float)(fVar18 * (float10)*(float *)(param_1 + 0x12d)),_DAT_00750184 * fStack_5fc);
  (**(code **)(**(int **)(param_1 + 0x81) + 0x20))(0x3f800000);
  (**(code **)(**(int **)(param_1 + 0x81) + 0x38))(*(undefined *)(param_1 + 0x131));
  pfVar16 = (float *)0x0;
  fVar21 = 0.0;
  (**(code **)(**(int **)(param_1 + 0x61) + 0x18))(0,0,0,0);
  if ((piVar4 == (int *)0x0) || (*(int *)piVar4[9] != 0)) {
    iVar14 = 0;
    if (0 < *(int *)(param_1 + 0x1e3)) {
      do {
        iVar13 = *(int *)(*(int *)(param_1 + 0x1e7) + iVar14 * 4);
        if (((*(int *)(iVar13 + 0x14) == 0) && (piVar24 = *(int **)(iVar13 + 0x24), *piVar24 == 0))
           && (puVar9 = (undefined4 *)piVar24[0x17], puVar9 != (undefined4 *)0x0)) {
          (**(code **)*puVar9)(*(undefined4 *)(*(int *)(param_1 + 0x6d) + 8));
        }
        iVar14 = iVar14 + 1;
      } while (iVar14 < *(int *)(param_1 + 0x1e3));
    }
  }
  else {
    puVar9 = (undefined4 *)((int *)piVar4[9])[0x17];
    if (puVar9 != (undefined4 *)0x0) {
      (**(code **)*puVar9)(*(undefined4 *)(*(int *)(param_1 + 0x6d) + 8));
    }
  }
  if (piVar4 != (int *)0x0) {
    pfVar16 = (float *)(**(code **)(*piVar4 + 0x14))();
    (***(code ***)piVar4[7])(*pfVar16,pfVar16[1],pfVar16[2]);
    (**(code **)(*(int *)piVar4[7] + 4))(pfVar16[0xf],pfVar16[0x10]);
    (**(code **)(*(int *)piVar4[7] + 0xc))(pfVar16[0x22],pfVar16[0x1f],pfVar16[0x20],pfVar16[0x21]);
    (**(code **)(*(int *)piVar4[6] + 0x10))(piVar4[0x13]);
    (**(code **)(*(int *)piVar4[6] + 0x18))(piVar4[0x14]);
    (**(code **)(*(int *)piVar4[6] + 0xc))(piVar4);
    (**(code **)(**(int **)(param_1 + 0x61) + 0x34))(piVar4[6]);
    if (((piVar4[0xe] != 0) || (piVar4[0x10] != 0)) && (*(int **)(param_1 + 0x85) != (int *)0x0)) {
      (**(code **)(**(int **)(param_1 + 0x85) + 8))
                (*(undefined4 *)(param_1 + 0x132),*(undefined4 *)(param_1 + 0x136),
                 *(undefined4 *)(param_1 + 0x13a));
      (**(code **)(**(int **)(param_1 + 0x85) + 0x10))
                (*(undefined4 *)(param_1 + 0x1ba),*(undefined4 *)(param_1 + 0x1ae),
                 *(undefined4 *)(param_1 + 0x1b2),*(undefined4 *)(param_1 + 0x1b6));
      (**(code **)(**(int **)(param_1 + 0x85) + 0x14))(1);
      (**(code **)(**(int **)(param_1 + 0x85) + 0x1c))(*(undefined4 *)(param_1 + 0x1ca));
      (**(code **)(**(int **)(param_1 + 0x85) + 0x20))(0x3f800000);
      (**(code **)(**(int **)(param_1 + 0x85) + 0x28))
                (*(undefined4 *)(param_1 + 0x1ce),*(undefined4 *)(param_1 + 0x1d2));
      (**(code **)(**(int **)(param_1 + 0x85) + 0x24))
                (*(undefined4 *)(param_1 + 0x1d6),DAT_00750188);
    }
    if ((*(byte *)(piVar4 + 0xc) & 1) == 0) {
      puVar9 = (undefined4 *)(**(code **)(**(int **)(param_1 + 0x81) + 0x34))();
      if ((undefined4 *)piVar4[0x11] != (undefined4 *)0x0) {
        (***(code ***)(undefined4 *)piVar4[0x11])(*puVar9,puVar9[1],puVar9[2]);
        (**(code **)(*(int *)piVar4[0x11] + 0xc))
                  (*(undefined4 *)(param_1 + 0x111),*(undefined4 *)(param_1 + 0x105),
                   *(undefined4 *)(param_1 + 0x109),*(undefined4 *)(param_1 + 0x10d));
      }
      if ((undefined4 *)piVar4[0x12] != (undefined4 *)0x0) {
        (***(code ***)(undefined4 *)piVar4[0x12])(*puVar9,puVar9[1],puVar9[2]);
        (**(code **)(*(int *)piVar4[0x12] + 0xc))
                  (*(undefined4 *)(param_1 + 0x111),*(undefined4 *)(param_1 + 0x105),
                   *(undefined4 *)(param_1 + 0x109),*(undefined4 *)(param_1 + 0x10d));
      }
      piVar24 = (int *)piVar4[0x10];
      if (piVar24 != (int *)0x0) {
        if (*(int *)(param_1 + 0x85) == 0) {
          if (piVar24 != (int *)0x0) {
            (**(code **)(*piVar24 + 4))(0,0);
            (**(code **)(*(int *)piVar4[0x10] + 8))(DAT_00750194);
          }
        }
        else {
          (**(code **)(*piVar24 + 4))(*(int *)(param_1 + 0x85),*(undefined4 *)(param_1 + 0x61));
          (**(code **)(*(int *)piVar4[0x10] + 8))(DAT_00750194);
        }
      }
      if (piVar4[0xf] != 0) {
        (**(code **)(**(int **)(param_1 + 0x61) + 0x34))(piVar4[0xf]);
        (**(code **)(**(int **)(param_1 + 0x61) + 0x18))
                  (piVar4[0xf],0x3dcccccd,0x3e4ccccd,0x3fcccccd);
      }
    }
    else {
      (**(code **)(**(int **)(param_1 + 0x61) + 0x18))(piVar4[6],0x3d4ccccd,0x3dcccccd,0x3fcccccd);
      piVar24 = (int *)piVar4[0xe];
      if (piVar24 != (int *)0x0) {
        if (*(int *)(param_1 + 0x85) == 0) {
          if (piVar24 != (int *)0x0) {
            (**(code **)(*piVar24 + 4))(0,0);
            (**(code **)(*(int *)piVar4[0xe] + 8))(DAT_00750194);
          }
        }
        else {
          (**(code **)(*piVar24 + 4))(*(int *)(param_1 + 0x85),*(undefined4 *)(param_1 + 0x61));
          (**(code **)(*(int *)piVar4[0xe] + 8))(DAT_00750194);
        }
      }
    }
  }
  cStack_3dc = '\0';
  puVar9 = &uStack_3db;
  for (iVar14 = 0x7f; iVar14 != 0; iVar14 = iVar14 + -1) {
    *puVar9 = 0;
    puVar9 = puVar9 + 1;
  }
  *(undefined2 *)puVar9 = 0;
  *(undefined *)((int)puVar9 + 2) = 0;
  piVar24 = aiStack_55c;
  aiStack_55c[0] = 0;
  uStack_49c = 0;
  for (iVar14 = 0x2f; piVar24 = piVar24 + 1, iVar14 != 0; iVar14 = iVar14 + -1) {
    *piVar24 = 0;
  }
  puVar9 = auStack_498;
  for (iVar14 = 0x2f; iVar14 != 0; iVar14 = iVar14 + -1) {
    *puVar9 = 0;
    puVar9 = puVar9 + 1;
  }
  if (pfVar16 == (float *)0x0) {
    fVar11 = *(float *)(param_1 + 0xc5);
    pfVar7 = (float *)(param_1 + 0x89);
  }
  else {
    fVar11 = pfVar16[0xf];
    pfVar7 = pfVar16;
  }
  fStack_608 = *pfVar7;
  fStack_604 = pfVar7[1];
  fStack_600 = pfVar7[2];
  if (piVar4 == (int *)0x0) {
    puStack_614 = (undefined4 *)0x0;
  }
  else {
    puStack_614 = (undefined4 *)((*(byte *)(piVar4 + 0xc) & 0xc) >> 2);
  }
  fVar17 = (float10)FUN_00516e1a();
  fVar26 = (float)fVar17;
  fVar17 = (float10)fpatan((float10)*(float *)(param_1 + 0xc1),(float10)*(float *)(param_1 + 0xbd));
  uVar22 = 0;
  uStack_5f8 = (double)fVar17;
  FUN_005f74c0(&puStack_5f0,&piStack_5e8,&puStack_5e4,param_1 + 0xe1);
  fVar19 = ABS((float)uStack_5f8 - (float)puStack_5f0);
  if ((float)_DAT_006efb78 < fVar19) {
    do {
      fVar19 = fVar19 - (float)_DAT_006efb78;
    } while ((float)_DAT_006efb78 < fVar19);
  }
  if ((float)_DAT_006e97f8 < fVar19) {
    fVar19 = (float)_DAT_006efb78 - fVar19;
  }
  bVar2 = fVar19 < (float)_DAT_006f5a00 == (fVar19 == (float)_DAT_006f5a00);
  uVar15 = *(uint *)(param_1 + 0x1e3);
  puStack_60c = (undefined4 *)DAT_007501a8;
  if ((int)uVar15 < (int)DAT_007501a8) {
    puStack_60c = (undefined4 *)uVar15;
  }
  pfStack_610 = (float *)DAT_007501ac;
  if ((int)uVar15 < (int)DAT_007501ac) {
    pfStack_610 = (float *)uVar15;
  }
  if ((piVar4 == (int *)0x0) || ((*(byte *)(piVar4 + 0xc) & 3) == 0)) {
    uVar8 = (int)pfStack_610 + (int)puStack_60c;
    iVar14 = 0;
    if (0 < (int)uVar15) {
      do {
        piVar4 = *(int **)(*(int *)(param_1 + 0x1e7) + iVar14 * 4);
        iVar13 = iVar14;
        if (piVar4[5] == 0) {
          iVar5 = (**(code **)(*piVar4 + 0x14))();
          if (*(int *)piVar4[9] == 0) {
            uVar8 = uVar8 + 1;
            FUN_00589260(aiStack_55c,&uStack_49c,iVar14,0,uVar22);
            uVar15 = uVar22 + 1;
            if ((int)uVar8 < (int)(uVar22 + 1)) {
              uVar15 = uVar8;
            }
LAB_005889e2:
            uVar22 = uVar15;
          }
          else {
            fVar19 = ABS(*(float *)(iVar5 + 0x3c) - fVar11);
            if (fVar26 * _DAT_006ea44c < fVar19) {
              fVar19 = fVar26 - fVar19;
            }
            FUN_00589260(aiStack_55c,&uStack_49c,iVar14,fVar19,uVar22);
            uVar15 = uVar22 + 1;
            uVar22 = uVar8;
            if ((int)uVar15 <= (int)uVar8) goto LAB_005889e2;
          }
          (**(code **)(*(int *)piVar4[6] + 0x10))(piVar4[0x13]);
          (**(code **)(*(int *)piVar4[6] + 0x18))(piVar4[0x14]);
        }
        else if (piVar4[5] == 2) {
          puVar10 = (undefined4 *)(**(code **)(*piVar4 + 0x14))();
          puVar9 = (undefined4 *)piVar4[7];
          (&cStack_3dc)[iVar14] = '\x01';
          iVar13 = iVar14;
          if (puVar9 != (undefined4 *)0x0) {
            (**(code **)*puVar9)(*puVar10,puVar10[1],puVar10[2]);
            (**(code **)(*(int *)piVar4[7] + 4))(puVar10[0xf],puVar10[0x10]);
            (**(code **)(*(int *)piVar4[7] + 0xc))
                      (puVar10[0x22],puVar10[0x1f],puVar10[0x20],puVar10[0x21]);
            iVar13 = iVar14;
          }
          (**(code **)(*(int *)piVar4[6] + 0xc))(piVar4);
          (**(code **)(*(int *)piVar4[6] + 0x10))(0);
          (**(code **)(**(int **)(param_1 + 0x61) + 0x34))(piVar4[6]);
        }
        else {
          puVar9 = (undefined4 *)piVar4[7];
          (&cStack_3dc)[iVar14] = '\x01';
          if (puVar9 != (undefined4 *)0x0) {
            (**(code **)*puVar9)(*pfVar16,pfVar16[1],pfVar16[2]);
            (**(code **)(*(int *)piVar4[7] + 4))(pfVar16[0xf],pfVar16[0x10]);
            (**(code **)(*(int *)piVar4[7] + 0xc))
                      (pfVar16[0x22],pfVar16[0x1f],pfVar16[0x20],pfVar16[0x21]);
            iVar13 = iVar14;
          }
          (**(code **)(*(int *)piVar4[6] + 0xc))(piVar4);
          (**(code **)(**(int **)(param_1 + 0x61) + 0x34))(piVar4[6]);
        }
        iVar14 = iVar13 + 1;
      } while (iVar14 < *(int *)(param_1 + 0x1e3));
    }
    iVar14 = 0;
    if (0 < (int)uVar22) {
      do {
        iVar13 = aiStack_55c[iVar14];
        if ((&cStack_3dc)[iVar13] == '\0') {
          iVar5 = *(int *)(param_1 + 0x1e7);
          (&cStack_3dc)[iVar13] = '\x01';
          piVar4 = *(int **)(iVar5 + iVar13 * 4);
          puVar9 = (undefined4 *)(**(code **)(*piVar4 + 0x14))();
          if ((undefined4 *)piVar4[7] != (undefined4 *)0x0) {
            (***(code ***)(undefined4 *)piVar4[7])(*puVar9,puVar9[1],puVar9[2]);
            (**(code **)(*(int *)piVar4[7] + 4))(puVar9[0xf],puVar9[0x10]);
            (**(code **)(*(int *)piVar4[7] + 0xc))
                      (puVar9[0x22],puVar9[0x1f],puVar9[0x20],puVar9[0x21]);
          }
          (**(code **)(*(int *)piVar4[6] + 0xc))(piVar4);
          (**(code **)(**(int **)(param_1 + 0x61) + 0x34))(piVar4[6]);
        }
        iVar14 = iVar14 + 1;
      } while (iVar14 < (int)uVar22);
    }
  }
  else {
    uVar8 = (uint)puStack_60c;
    if (bVar2) {
      uVar8 = (uint)pfStack_610;
    }
    iVar14 = 0;
    uVar23 = uVar22;
    if (0 < (int)uVar15) {
      do {
        piVar4 = *(int **)(*(int *)(param_1 + 0x1e7) + iVar14 * 4);
        if (piVar4[5] == 0) {
          pfVar7 = (float *)(**(code **)(*piVar4 + 0x14))();
          if (*(int *)piVar4[9] == 0) {
            uVar8 = uVar8 + 1;
            FUN_00589260(aiStack_55c,&uStack_49c,iVar14,0,uVar22);
            uVar15 = uVar22 + 1;
            uVar22 = uVar8;
            if ((int)uVar15 <= (int)uVar8) {
              uVar22 = uVar15;
            }
            uVar23 = uVar22;
            (**(code **)(*(int *)piVar4[6] + 0x10))(piVar4[0x13]);
            (**(code **)(*(int *)piVar4[6] + 0x18))(piVar4[0x14]);
          }
          else {
            fVar19 = (pfVar7[0xf] - fVar11) + _DAT_006ea514;
            if (fVar19 < _DAT_006ea454 != (fVar19 == _DAT_006ea454)) {
              fVar19 = fVar19 + fVar26;
            }
            if (_DAT_006ea494 * fVar19 < fVar26 != (NAN(_DAT_006ea494 * fVar19) || NAN(fVar26))) {
              fVar19 = fVar19 + (fStack_608 - *pfVar7) * (fStack_608 - *pfVar7) +
                                (fStack_604 - pfVar7[1]) * (fStack_604 - pfVar7[1]) +
                                (fStack_600 - pfVar7[2]) * (fStack_600 - pfVar7[2]);
              if ((undefined4 *)((*(byte *)(piVar4 + 0xc) & 0xc) >> 2) != puStack_614) {
                fVar19 = fVar26 * fVar26 + fVar19;
              }
              FUN_00589260(aiStack_55c,&uStack_49c,iVar14,fVar19,uVar22);
              uVar15 = uVar22 + 1;
              uVar22 = uVar8;
              if ((int)uVar15 <= (int)uVar8) {
                uVar22 = uVar15;
              }
              uVar23 = uVar22;
              (**(code **)(*(int *)piVar4[6] + 0x10))(piVar4[0x13]);
              (**(code **)(*(int *)piVar4[6] + 0x18))(piVar4[0x14]);
            }
          }
        }
        else if (piVar4[5] == 2) {
          puVar9 = (undefined4 *)(**(code **)(*piVar4 + 0x14))();
          (&cStack_3dc)[iVar14] = '\x01';
          uVar22 = uVar23;
          if ((undefined4 *)piVar4[7] != (undefined4 *)0x0) {
            (***(code ***)(undefined4 *)piVar4[7])(*puVar9,puVar9[1],puVar9[2]);
            (**(code **)(*(int *)piVar4[7] + 4))(puVar9[0xf],puVar9[0x10]);
            (**(code **)(*(int *)piVar4[7] + 0xc))
                      (puVar9[0x22],puVar9[0x1f],puVar9[0x20],puVar9[0x21]);
            uVar22 = uVar23;
          }
          (**(code **)(*(int *)piVar4[6] + 0xc))(piVar4);
          (**(code **)(*(int *)piVar4[6] + 0x10))(0);
          (**(code **)(**(int **)(param_1 + 0x61) + 0x34))(piVar4[6]);
          uVar23 = uVar22;
        }
        else {
          (&cStack_3dc)[iVar14] = '\x01';
          if ((undefined4 *)piVar4[7] != (undefined4 *)0x0) {
            (***(code ***)(undefined4 *)piVar4[7])(*pfVar16,pfVar16[1],pfVar16[2]);
            (**(code **)(*(int *)piVar4[7] + 4))(pfVar16[0xf],pfVar16[0x10]);
            (**(code **)(*(int *)piVar4[7] + 0xc))
                      (pfVar16[0x22],pfVar16[0x1f],pfVar16[0x20],pfVar16[0x21]);
          }
          (**(code **)(*(int *)piVar4[6] + 0xc))(piVar4);
          (**(code **)(**(int **)(param_1 + 0x61) + 0x34))(piVar4[6]);
        }
        iVar14 = iVar14 + 1;
      } while (iVar14 < *(int *)(param_1 + 0x1e3));
    }
    iVar14 = 0;
    if (0 < (int)uVar23) {
      do {
        iVar13 = aiStack_55c[iVar14];
        if ((&cStack_3dc)[iVar13] == '\0') {
          iVar5 = *(int *)(param_1 + 0x1e7);
          (&cStack_3dc)[iVar13] = '\x01';
          piVar4 = *(int **)(iVar5 + iVar13 * 4);
          puVar9 = (undefined4 *)(**(code **)(*piVar4 + 0x14))();
          if ((undefined4 *)piVar4[7] != (undefined4 *)0x0) {
            (***(code ***)(undefined4 *)piVar4[7])(*puVar9,puVar9[1],puVar9[2]);
            (**(code **)(*(int *)piVar4[7] + 4))(puVar9[0xf],puVar9[0x10]);
            (**(code **)(*(int *)piVar4[7] + 0xc))
                      (puVar9[0x22],puVar9[0x1f],puVar9[0x20],puVar9[0x21]);
          }
          (**(code **)(*(int *)piVar4[6] + 0xc))(piVar4);
          (**(code **)(**(int **)(param_1 + 0x61) + 0x34))(piVar4[6]);
        }
        iVar14 = iVar14 + 1;
      } while (iVar14 < (int)uVar23);
    }
    uVar22 = 0;
    uVar15 = (uint)puStack_60c;
    if (!bVar2) {
      uVar15 = (uint)pfStack_610;
    }
    iVar14 = 0;
    if (0 < *(int *)(param_1 + 0x1e3)) {
      do {
        piVar4 = *(int **)(*(int *)(param_1 + 0x1e7) + iVar14 * 4);
        if ((piVar4[5] == 0) && ((&cStack_3dc)[iVar14] == '\0')) {
          pfVar16 = (float *)(**(code **)(*piVar4 + 0x14))();
          if (*(int *)piVar4[9] == 0) {
            fVar19 = 0.0;
            uVar15 = uVar15 + 1;
          }
          else {
            fVar19 = (fVar11 - pfVar16[0xf]) + _DAT_006ea514;
            if (fVar19 < _DAT_006ea454 != (fVar19 == _DAT_006ea454)) {
              fVar19 = fVar19 + fVar26;
            }
            if (_DAT_006ea494 * fVar19 < fVar26 == (NAN(_DAT_006ea494 * fVar19) || NAN(fVar26)))
            goto LAB_005888b3;
            fVar19 = fVar19 + (fStack_608 - *pfVar16) * (fStack_608 - *pfVar16) +
                              (fStack_604 - pfVar16[1]) * (fStack_604 - pfVar16[1]) +
                              (fStack_600 - pfVar16[2]) * (fStack_600 - pfVar16[2]);
            if ((undefined4 *)((*(byte *)(piVar4 + 0xc) & 0xc) >> 2) != puStack_614) {
              fVar19 = fVar26 * fVar26 + fVar19;
            }
          }
          FUN_00589260(aiStack_55c,&uStack_49c,iVar14,fVar19,uVar22);
          uVar8 = uVar22 + 1;
          uVar22 = uVar15;
          if ((int)uVar8 <= (int)uVar15) {
            uVar22 = uVar8;
          }
          (**(code **)(*(int *)piVar4[6] + 0x10))(piVar4[0x13]);
          (**(code **)(*(int *)piVar4[6] + 0x18))(piVar4[0x14]);
        }
LAB_005888b3:
        iVar14 = iVar14 + 1;
      } while (iVar14 < *(int *)(param_1 + 0x1e3));
    }
    iVar14 = 0;
    if (0 < (int)uVar22) {
      do {
        iVar13 = aiStack_55c[iVar14];
        if ((&cStack_3dc)[iVar13] == '\0') {
          iVar5 = *(int *)(param_1 + 0x1e7);
          (&cStack_3dc)[iVar13] = '\x01';
          piVar4 = *(int **)(iVar5 + iVar13 * 4);
          puVar9 = (undefined4 *)(**(code **)(*piVar4 + 0x14))();
          if ((undefined4 *)piVar4[7] != (undefined4 *)0x0) {
            (***(code ***)(undefined4 *)piVar4[7])(*puVar9,puVar9[1],puVar9[2]);
            (**(code **)(*(int *)piVar4[7] + 4))(puVar9[0xf],puVar9[0x10]);
            (**(code **)(*(int *)piVar4[7] + 0xc))
                      (puVar9[0x22],puVar9[0x1f],puVar9[0x20],puVar9[0x21]);
          }
          (**(code **)(*(int *)piVar4[6] + 0xc))(piVar4);
          (**(code **)(**(int **)(param_1 + 0x61) + 0x34))(piVar4[6]);
        }
        iVar14 = iVar14 + 1;
      } while (iVar14 < (int)uVar22);
    }
  }
  piVar4 = (int *)((uint)fVar26 & 0xffffff00);
  iVar14 = **(int **)(param_1 + 0x6d);
  if (DAT_00750198 != iVar14) {
    piVar4 = (int *)CONCAT31((int3)((uint)fVar26 >> 8),1);
  }
  DAT_00750198 = iVar14;
  if ((*(undefined4 **)(param_1 + 0x6d))[1] != 0) {
    FUN_00598100(**(undefined4 **)(param_1 + 0x6d));
    switch(**(undefined4 **)(param_1 + 0x6d)) {
    default:
      uVar20 = 0;
      break;
    case 4:
    case 5:
    case 6:
      uVar20 = 0x3f800000;
      break;
    case 7:
      uVar20 = 0x40000000;
    }
    (***(code ***)(*(undefined4 **)(param_1 + 0x6d))[1])(uVar20);
  }
  iVar14 = *(int *)(*(int *)(param_1 + 0x6d) + 0x10);
  if (DAT_0075019c != iVar14) {
    piVar4 = (int *)CONCAT31((int3)((uint)piVar4 >> 8),1);
  }
  iVar13 = *(int *)(*(int *)(param_1 + 0x6d) + 0x34);
  if (DAT_007501a0 != iVar13) {
    piVar4 = (int *)CONCAT31((int3)((uint)piVar4 >> 8),1);
  }
  puVar9 = *(undefined4 **)(*(int *)(param_1 + 0x6d) + 0x38);
  DAT_0075019c = iVar14;
  DAT_007501a0 = iVar13;
  if (puVar9 != (undefined4 *)0x0) {
    (**(code **)*puVar9)((float)*(int *)(*(int *)(param_1 + 0x6d) + 0x34));
  }
  iVar14 = *(int *)(param_1 + 0x6d);
  switch(*(undefined4 *)(iVar14 + 0x10)) {
  default:
    if (*(undefined4 **)(iVar14 + 0x14) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(iVar14 + 0x14))(0);
    }
    puVar9 = *(undefined4 **)(*(int *)(param_1 + 0x6d) + 0x3c);
    if (puVar9 != (undefined4 *)0x0) {
      (**(code **)*puVar9)(0);
    }
    puVar9 = *(undefined4 **)(*(int *)(param_1 + 0x6d) + 0x2c);
    if (puVar9 == (undefined4 *)0x0) goto LAB_00588d1e;
    uVar20 = 0;
    break;
  case 2:
  case 3:
    if (*(undefined4 **)(iVar14 + 0x14) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(iVar14 + 0x14))(0x3f800000);
    }
    puVar9 = *(undefined4 **)(*(int *)(param_1 + 0x6d) + 0x3c);
    if (puVar9 != (undefined4 *)0x0) {
      (**(code **)*puVar9)(0x3f800000);
    }
    puVar9 = *(undefined4 **)(*(int *)(param_1 + 0x6d) + 0x2c);
    if (puVar9 == (undefined4 *)0x0) goto LAB_00588d1e;
    uVar20 = 0x3f800000;
  }
  (**(code **)*puVar9)(uVar20);
LAB_00588d1e:
  iVar14 = *(int *)(*(int *)(param_1 + 0x6d) + 0x24);
  if (DAT_007501a4 != iVar14) {
    piVar4 = (int *)CONCAT31((int3)((uint)piVar4 >> 8),1);
  }
  puVar9 = *(undefined4 **)(*(int *)(param_1 + 0x6d) + 0x28);
  DAT_007501a4 = iVar14;
  if (puVar9 != (undefined4 *)0x0) {
    (**(code **)*puVar9)((float)*(int *)(*(int *)(param_1 + 0x6d) + 0x24));
  }
  puVar9 = *(undefined4 **)(*(int *)(param_1 + 0x6d) + 0xc);
  if (puVar9 != (undefined4 *)0x0) {
    (**(code **)*puVar9)(*(undefined4 *)(*(int *)(param_1 + 0x6d) + 8));
  }
  puVar9 = *(undefined4 **)(*(int *)(param_1 + 0x6d) + 0x18);
  if (puVar9 != (undefined4 *)0x0) {
    ppcVar1 = (code **)*puVar9;
    iVar14 = FUN_005d44c0();
    (**ppcVar1)((float)*(int *)(iVar14 + 0x10));
  }
  puVar9 = *(undefined4 **)(*(int *)(param_1 + 0x6d) + 0x1c);
  if (puVar9 != (undefined4 *)0x0) {
    ppcVar1 = (code **)*puVar9;
    iVar14 = FUN_005d44c0();
    pfStack_610 = (float *)(uint)*(byte *)(iVar14 + 0xe);
    (**ppcVar1)((float)(int)pfStack_610);
  }
  piVar24 = (int *)0x0;
  iVar14 = FUN_0040ecf0();
  if (0 < iVar14) {
    pfVar7 = (float *)&DAT_00d7cb74;
    pfVar16 = (float *)(param_1 + 0x6f8);
    do {
      fVar11 = pfVar16[-7];
      if ((((uint)fVar11 & 2) == 0) &&
         ((cVar3 = FUN_0040edc0(), cVar3 == '\0' || (fVar11 = pfVar16[-7], ((uint)fVar11 & 1) == 0))
         )) {
LAB_00588ef0:
        apiStack_58c[(int)piVar24 + 1] = (int *)0x0;
      }
      else {
        pfStack_610 = (float *)((uint)fVar11 >> 2 & 1);
        piVar12 = (int *)FUN_00525960(pfVar16[4],pfVar16[5],pfStack_610);
        apiStack_58c[(int)piVar24 + 1] = piVar12;
        if (piVar12 != (int *)0x0) {
          iVar14 = (**(code **)(*piVar12 + 0x1c))(0,&puStack_614);
          if (iVar14 != 1) goto LAB_00588ef0;
          FUN_005f58d0(&stack0xfffffa20,pfVar16 + -6);
          (**(code **)*puStack_614)(unaff_EDI,unaff_ESI,unaff_EBP);
          (**(code **)(*piVar4 + 4))(uStack_5b0,uStack_5ac);
          fVar17 = (float10)fsin((float10)pfVar16[-3] * (float10)_DAT_006ea44c);
          puStack_614 = (undefined4 *)(float)(fVar17 * (float10)*pfVar16);
          fVar18 = (float10)fcos((float10)pfVar16[-3] * (float10)_DAT_006ea44c);
          (**(code **)(*piVar24 + 0xc))
                    ((float)fVar18,(float)(fVar17 * (float10)pfVar16[-2]),
                     (float)(fVar17 * (float10)pfVar16[-1]),puStack_614);
          fVar26 = pfVar16[4];
          fVar19 = pfVar16[3];
          fVar11 = pfVar16[2];
          pfVar7[1] = pfVar16[5];
          pfVar7[2] = fVar11;
          pfVar7[-1] = fVar21;
          *pfVar7 = fVar26;
          pfVar7[3] = fVar19;
          (**(code **)(*piVar12 + 0xc))(pfVar7 + -3);
          (**(code **)(**(int **)(param_1 + 0x61) + 0x34))(piVar12);
        }
      }
      pfVar16 = pfVar16 + 0xd;
      piVar12 = (int *)((int)piVar24 + 1);
      pfVar7 = pfVar7 + 7;
      piVar24 = piVar12;
      iVar14 = FUN_0040ecf0();
    } while ((int)piVar12 < iVar14);
  }
  ppiVar25 = apiStack_1dc;
  pfStack_610 = (float *)(param_1 + 0x934);
  piVar24 = (int *)0x0;
  puStack_60c = &DAT_00d7ccb4;
  do {
    ppiVar27 = ppiVar25;
    if (piVar24 == *(int **)(param_1 + 0x2c)) {
      *ppiVar25 = (int *)0x0;
      ppiVar25[1] = (int *)0x0;
    }
    else {
      iVar14 = 0;
      puVar9 = puStack_60c;
      pfVar16 = pfStack_610;
      do {
        iVar13 = FUN_005d44c0();
        if ((iVar14 < *(int *)(iVar13 + 0x18)) && (((uint)pfVar16[-7] & 1) != 0)) {
          uVar22 = (uint)pfVar16[-7] >> 2;
          uStack_5f8 = (double)(CONCAT44(uStack_5f8._4_4_,uVar22) & 0xffffffff00000001);
          piVar12 = (int *)FUN_00525960(piVar24,pfVar16[5],uVar22 & 1);
          *ppiVar25 = piVar12;
          if (piVar12 != (int *)0x0) {
            iVar13 = (**(code **)(*piVar12 + 0x1c))(0,&puStack_614);
            if (iVar13 == 1) {
              FUN_005f58d0(&stack0xfffffa20,pfVar16 + -6);
              (**(code **)*puStack_614)(unaff_EDI,unaff_ESI,unaff_EBP);
              uVar20 = uStack_5ac;
              (**(code **)(*piVar4 + 4))(uStack_5b0);
              fVar17 = (float10)fsin((float10)pfVar16[-3] * (float10)_DAT_006ea44c);
              ppiVar27 = (int **)(float)(fVar17 * (float10)pfVar16[-2]);
              puStack_614 = (undefined4 *)(float)(fVar17 * (float10)*pfVar16);
              fVar18 = (float10)fcos((float10)pfVar16[-3] * (float10)_DAT_006ea44c);
              (**(code **)(*piVar24 + 0xc))
                        ((float)fVar18,ppiVar27,(float)(fVar17 * (float10)pfVar16[-1]),puStack_614);
              fVar21 = _DAT_006ea454;
              if ((*(byte *)(pfVar16 + -7) & 2) != 0) {
                fVar21 = pfVar16[2];
              }
              fVar11 = pfVar16[3];
              fVar26 = pfVar16[5];
              puVar9[-1] = ppiVar27;
              puVar9[1] = fVar26;
              puVar9[2] = fVar21;
              *puVar9 = uVar20;
              puVar9[3] = fVar11;
              (**(code **)(*piVar12 + 0xc))(puVar9 + -3);
              (**(code **)(**(int **)(param_1 + 0x61) + 0x34))(piVar12);
            }
            else {
              *ppiVar25 = (int *)0x0;
            }
          }
        }
        else {
          *ppiVar25 = (int *)0x0;
        }
        iVar14 = iVar14 + 1;
        pfVar16 = pfVar16 + 0xd;
        puVar9 = puVar9 + 7;
        ppiVar25 = ppiVar25 + 1;
      } while (iVar14 < 2);
    }
    puStack_60c = puStack_60c + 0xe;
    piVar24 = (int *)((int)piVar24 + 1);
    pfStack_610 = pfStack_610 + 0x1a;
    ppiVar25 = ppiVar27 + 2;
  } while ((int)puStack_60c < 0xd7d734);
  FUN_005d3a40(*(undefined4 *)(param_1 + 0x61),piVar4);
  if ((char)piVar4 != '\0') {
    FUN_00572430();
    FUN_005ae470();
    FUN_00571a30();
  }
  (**(code **)(**(int **)(param_1 + 0x61) + 0xc))(*(undefined4 *)(param_1 + 0x81));
  piVar4 = &iStack_1e0;
  iVar14 = 0x30;
  do {
    iVar13 = 2;
    do {
      if (*piVar4 != 0) {
        (**(code **)(**(int **)(param_1 + 0x61) + 0x44))(*piVar4);
      }
      piVar4 = piVar4 + 1;
      iVar13 = iVar13 + -1;
    } while (iVar13 != 0);
    iVar14 = iVar14 + -1;
  } while (iVar14 != 0);
  iVar13 = 0;
  iVar14 = FUN_0040ecf0();
  if (0 < iVar14) {
    do {
      if (apiStack_58c[iVar13] != (int *)0x0) {
        (**(code **)(**(int **)(param_1 + 0x61) + 0x44))(apiStack_58c[iVar13]);
      }
      iVar13 = iVar13 + 1;
      iVar14 = FUN_0040ecf0();
    } while (iVar13 < iVar14);
  }
  (**(code **)(**(int **)(param_1 + 0x61) + 0x18))(0,0,0,0);
  fVar21 = fStack_600;
  if (((fStack_600 != 0.0) &&
      ((**(code **)(**(int **)(param_1 + 0x61) + 0x44))(*(undefined4 *)((int)fStack_600 + 0x18)),
      (*(byte *)((int)fVar21 + 0x30) & 1) == 0)) &&
     (iVar14 = *(int *)((int)fVar21 + 0x3c), iVar14 != 0)) {
    (**(code **)(**(int **)(param_1 + 0x61) + 0x44))(iVar14);
  }
  iVar14 = 0;
  if (0 < *(int *)(param_1 + 0x1e3)) {
    do {
      iVar13 = *(int *)(*(int *)(param_1 + 0x1e7) + iVar14 * 4);
      if ((*(int *)(iVar13 + 0x14) != 0) || (acStack_3f0[iVar14] != '\0')) {
        (**(code **)(**(int **)(param_1 + 0x61) + 0x44))(*(undefined4 *)(iVar13 + 0x18));
      }
      iVar13 = *(int *)(param_1 + 0x1e3);
      acStack_3f0[iVar14] = '\0';
      iVar14 = iVar14 + 1;
    } while (iVar14 < iVar13);
  }
  return;
}

