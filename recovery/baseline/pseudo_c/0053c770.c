/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0053c770 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_0053c770(int param_1)

{
  float fVar1;
  float fVar2;
  double dVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  bool bVar7;
  bool bVar8;
  undefined1 uVar9;
  char cVar10;
  char cVar11;
  int iVar12;
  uint uVar13;
  int iVar14;
  undefined4 uVar15;
  int extraout_ECX;
  int extraout_ECX_00;
  int extraout_ECX_01;
  int *piVar16;
  int *piVar17;
  float10 fVar18;
  float10 extraout_ST0;
  float10 fVar19;
  float local_1bc;
  int local_1ac;
  float local_1a8;
  int local_1a4;
  float local_1a0;
  undefined4 local_19c;
  undefined4 local_198;
  undefined4 auStack_188 [48];
  undefined4 auStack_c8 [49];
  
  iVar12 = FUN_00544bf0();
  uVar13 = *(uint *)(iVar12 + 0x4c) >> 0x14;
  if ((uVar13 & 1) != 0) {
    uVar15 = *(undefined4 *)(param_1 + 0x24);
    *(undefined2 *)(param_1 + 0x2c) = 0;
    FUN_00538ae0(uVar15);
    FUN_0053d920(uVar15);
    uVar15 = *(undefined4 *)(param_1 + 0x24);
    FUN_00538ae0(uVar15);
    FUN_0053d9d0(uVar15);
  }
  iVar12 = FUN_005099b0();
  if (iVar12 != 7) {
    return;
  }
  iVar12 = FUN_00509b60(0xffffffff);
  if (iVar12 < 3) {
    return;
  }
  iVar12 = FUN_00509b60(0xffffffff);
  if (iVar12 == 3) {
    iVar12 = FUN_00538ae0();
    dVar3 = *(double *)(iVar12 + 0xb5) + _DAT_006ecfd0;
    fVar18 = (float10)FUN_00509a20();
    if (fVar18 < (float10)dVar3) {
      return;
    }
  }
  fVar1 = *(float *)(param_1 + 0x2e);
  fVar2 = *(float *)(param_1 + 0x32);
  iVar12 = FUN_00509b60(0xffffffff);
  if ((iVar12 == 5) || (iVar12 = FUN_00509b60(0xffffffff), iVar12 == 6)) {
    uVar9 = 1;
  }
  else {
    uVar9 = 0;
  }
  *(undefined1 *)(param_1 + 0x1e6) = uVar9;
  local_1ac = 0;
  local_1a4 = 0;
  bVar8 = false;
  local_1a0 = -1000.0;
  local_19c = 0xffffffff;
  local_198 = 0xffffffff;
  local_1a8 = -1000.0;
  local_1bc = -1.0;
  piVar16 = (int *)0x0;
LAB_0053c888:
  do {
    do {
      piVar17 = DAT_00acca24;
      if (piVar16 != (int *)0x0) {
        if (piVar16[1] == 0) {
          piVar17 = (int *)0x0;
        }
        else {
          piVar17 = (int *)(piVar16[1] + -4);
        }
        if (piVar17 == DAT_00acca24) {
LAB_0053cca4:
          FUN_00538ab0();
          iVar12 = FUN_005398d0();
          if (((iVar12 == 5) && (5 < local_1ac)) && ((uVar13 & 1) != 0)) {
            uVar15 = *(undefined4 *)(param_1 + 0x24);
            *(byte *)(param_1 + 0x2d) = *(byte *)(param_1 + 0x2d) | 1;
            FUN_00538ae0(uVar15);
            FUN_0053d8e0(uVar15);
            iVar12 = 0;
            if (0 < local_1ac) {
              do {
                FUN_0053c6d0(auStack_188[iVar12]);
                iVar12 = iVar12 + 1;
              } while (iVar12 < local_1ac);
            }
          }
          if (local_1a4 == 0) {
            *(undefined4 *)(param_1 + 0x52) = 0;
            *(undefined4 *)(param_1 + 0x56) = 0xbff00000;
          }
          else if ((*(int *)(param_1 + 0x52) == 0) && (*(int *)(param_1 + 0x56) == -0x40100000)) {
            fVar18 = (float10)(*(code *)**(undefined4 **)(param_1 + 0x4e))();
            *(double *)(param_1 + 0x52) = (double)(fVar18 + (float10)_DAT_006ecfd0);
          }
          if (((*(int *)(param_1 + 0x52) != 0) || (*(int *)(param_1 + 0x56) != -0x40100000)) &&
             ((fVar18 = (float10)(*(code *)**(undefined4 **)(param_1 + 0x4e))(),
              (float10)*(double *)(param_1 + 0x52) < fVar18 ||
              (fVar18 = (float10)(*(code *)**(undefined4 **)(param_1 + 0x4e))(),
              (float10)*(double *)(param_1 + 0x52) - fVar18 == (float10)_DAT_006ea4b0)))) {
            iVar12 = 0;
            *(undefined4 *)(param_1 + 0x52) = 0;
            *(undefined4 *)(param_1 + 0x56) = 0xbff00000;
            if ((uVar13 & 1) != 0) {
              uVar15 = *(undefined4 *)(param_1 + 0x24);
              *(byte *)(param_1 + 0x2d) = *(byte *)(param_1 + 0x2d) | 1;
              FUN_00538ae0(uVar15);
              FUN_0053d8e0(uVar15);
            }
            if (0 < local_1a4) {
              do {
                FUN_0053c6d0(auStack_c8[iVar12]);
                iVar12 = iVar12 + 1;
              } while (iVar12 < local_1a4);
            }
          }
          if (!bVar8) {
            *(undefined4 *)(param_1 + 0x46) = 0;
            *(undefined4 *)(param_1 + 0x4a) = 0xbff00000;
          }
          iVar12 = FUN_0053c610();
          if ((-1 < iVar12) && (iVar12 = FUN_00538af0(iVar12), *(char *)(iVar12 + 0x1e6) != '\0')) {
            *(undefined2 *)(param_1 + 0x2c) = 0x2000;
          }
          return;
        }
      }
      if (piVar17 == (int *)0x0) goto LAB_0053cca4;
      piVar16 = piVar17;
    } while (piVar17 == DAT_00760b38);
    iVar12 = FUN_00538ae0();
    dVar3 = *(double *)(iVar12 + 0x5dc + *(int *)((int)piVar17 + 0x5b2) * 8);
    fVar18 = (float10)FUN_00509a20();
  } while (fVar18 <= (float10)dVar3 + (float10)_DAT_006e9808);
  iVar12 = *(int *)((int)piVar17 + 0x5ae);
  fVar4 = *(float *)(iVar12 + 0x3c);
  fVar5 = *(float *)(iVar12 + 0x44);
  if (fVar2 < fVar1) {
    if (fVar4 <= *(float *)(param_1 + 0x2e)) goto LAB_0053c925;
  }
  else {
    if (fVar4 <= *(float *)(param_1 + 0x2e)) goto LAB_0053c888;
LAB_0053c925:
    if (fVar4 < *(float *)(param_1 + 0x32) == (fVar4 == *(float *)(param_1 + 0x32)))
    goto LAB_0053c888;
  }
  cVar10 = FUN_005365c0(iVar12,0);
  if (cVar10 == '\0') {
    iVar14 = taskGetRate();
    fVar6 = (float)iVar14 * _DAT_0074b080 * _DAT_006e9810;
    cVar10 = FUN_00535530(iVar12);
    FUN_00538ae0();
    iVar12 = FUN_00538ae0();
    fVar18 = (float10)*(double *)(iVar12 + 0x15c + extraout_ECX);
    iVar12 = FUN_00538ae0();
    if (*(double *)(iVar12 + 0x45c + extraout_ECX_00) <= _DAT_006ea4b0) {
LAB_0053c9f1:
      bVar7 = false;
    }
    else {
      iVar12 = FUN_00538ae0();
      dVar3 = *(double *)(iVar12 + 0x45c + extraout_ECX_01) + _DAT_006e9808;
      fVar19 = (float10)FUN_00509a20();
      if ((fVar19 <= (float10)dVar3) || (fVar18 < extraout_ST0 != (fVar18 == extraout_ST0)))
      goto LAB_0053c9f1;
      bVar7 = true;
    }
    if (cVar10 == '\0') {
      auStack_188[local_1ac] = *(undefined4 *)((int)piVar17 + 0x5b2);
      local_1ac = local_1ac + 1;
    }
    else {
      if (bVar7) {
        if (fVar4 - local_1a0 < _DAT_006ecfc8) {
          if ((uVar13 & 1) != 0) {
            uVar15 = *(undefined4 *)(param_1 + 0x24);
            *(byte *)(param_1 + 0x2d) = *(byte *)(param_1 + 0x2d) | 1;
            FUN_00538ae0(uVar15);
            FUN_0053d8e0(uVar15);
            uVar15 = *(undefined4 *)(param_1 + 0x24);
            FUN_00538ae0(uVar15);
            FUN_0053d990(uVar15);
          }
          FUN_0053c6d0(*(undefined4 *)((int)piVar17 + 0x5b2));
          FUN_0053c6d0(local_19c);
        }
        local_19c = *(undefined4 *)((int)piVar17 + 0x5b2);
        local_1a0 = fVar4;
      }
      if ((((fVar5 < fVar6 * _DAT_006f49d0) || (bVar7)) && (fVar6 * _DAT_006ed070 < local_1bc)) &&
         (fVar18 = (float10)FUN_00516daa(local_1a8,fVar4),
         fVar18 / (float10)local_1bc < (float10)_DAT_006ea4a0)) {
        if ((uVar13 & 1) != 0) {
          uVar15 = *(undefined4 *)(param_1 + 0x24);
          *(byte *)(param_1 + 0x2d) = *(byte *)(param_1 + 0x2d) | 1;
          FUN_00538ae0(uVar15);
          FUN_0053d8e0(uVar15);
          uVar15 = *(undefined4 *)(param_1 + 0x24);
          FUN_00538ae0(uVar15);
          FUN_0053d990(uVar15);
        }
        FUN_0053c6d0(*(undefined4 *)((int)piVar17 + 0x5b2));
      }
      if (((fVar5 < fVar6 * _DAT_006e9824) && (local_1bc < fVar6 * _DAT_006e9824)) &&
         (fVar18 = (float10)FUN_00516daa(local_1a8,fVar4), fVar18 < (float10)_DAT_006ed000)) {
        bVar8 = true;
        if ((*(int *)(param_1 + 0x46) == 0) && (*(int *)(param_1 + 0x4a) == -0x40100000)) {
          fVar18 = (float10)(*(code *)**(undefined4 **)(param_1 + 0x42))();
          *(double *)(param_1 + 0x46) = (double)(fVar18 + (float10)_DAT_006ed050);
        }
        else if (((*(int *)(param_1 + 0x46) != 0) || (*(int *)(param_1 + 0x4a) != -0x40100000)) &&
                ((fVar18 = (float10)(*(code *)**(undefined4 **)(param_1 + 0x42))(),
                 (float10)*(double *)(param_1 + 0x46) < fVar18 ||
                 (fVar18 = (float10)(*(code *)**(undefined4 **)(param_1 + 0x42))(),
                 (float10)*(double *)(param_1 + 0x46) - fVar18 == (float10)_DAT_006ea4b0)))) {
          *(undefined4 *)(param_1 + 0x46) = 0;
          *(undefined4 *)(param_1 + 0x4a) = 0xbff00000;
          if ((uVar13 & 1) != 0) {
            uVar15 = *(undefined4 *)(param_1 + 0x24);
            *(byte *)(param_1 + 0x2d) = *(byte *)(param_1 + 0x2d) | 1;
            FUN_00538ae0(uVar15);
            FUN_0053d8e0(uVar15);
            uVar15 = *(undefined4 *)(param_1 + 0x24);
            FUN_00538ae0(uVar15);
            FUN_0053d990(uVar15);
          }
          FUN_0053c6d0(*(undefined4 *)((int)piVar17 + 0x5b2));
          FUN_0053c6d0(local_198);
        }
      }
    }
    uVar15 = (**(code **)(*piVar17 + 4))();
    cVar11 = FUN_00548310(uVar15);
    if (cVar11 != '\0') {
      auStack_c8[local_1a4] = *(undefined4 *)((int)piVar17 + 0x5b2);
      local_1a4 = local_1a4 + 1;
    }
    uVar15 = *(undefined4 *)((int)piVar17 + 0x5b2);
    FUN_00538ac0(uVar15);
    cVar11 = FUN_0053b6a0(uVar15);
    if (cVar11 != '\0') {
      if (cVar10 == '\0') goto LAB_0053c888;
      if (!bVar7) {
        *(undefined1 *)(param_1 + 0x1e6) = 0;
      }
    }
    if (cVar10 != '\0') {
      local_198 = *(undefined4 *)((int)piVar17 + 0x5b2);
      local_1bc = fVar5;
      local_1a8 = fVar4;
    }
  }
  goto LAB_0053c888;
}


