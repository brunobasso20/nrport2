/* NR2003.exe @ 005662d0 FUN_005662d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005662d0(int param_1,int param_2)

{
  byte *pbVar1;
  float fVar2;
  bool bVar3;
  bool bVar4;
  int iVar5;
  int iVar6;
  char cVar7;
  int iVar8;
  int iVar9;
  uint uVar10;
  int iVar11;
  undefined4 *puVar12;
  bool bVar13;
  float unaff_EBP;
  float10 fVar14;
  undefined4 uVar15;
  undefined4 uVar16;
  undefined4 uVar17;
  undefined4 uVar18;
  undefined4 uVar19;
  undefined4 uVar20;
  undefined4 uVar21;
  byte bVar22;
  undefined4 uVar23;
  float fVar24;
  int iStack_18;
  undefined auStack_14 [4];
  undefined auStack_10 [4];
  undefined auStack_c [8];
  undefined4 uStack_4;
  
  iVar6 = param_2;
  iVar5 = param_1;
  iVar8 = FUN_005ba130();
  FUN_005b9e70();
  if (*(undefined4 **)(param_1 + 0x2d8) != (undefined4 *)0x0) {
    (**(code **)**(undefined4 **)(param_1 + 0x2d8))((float)*(int *)(param_2 + 0x2c));
  }
  if ((*(byte *)(param_2 + 0x30) & 0x10) == 0) {
    param_2 = 0;
LAB_00566371:
    puVar12 = *(undefined4 **)(param_1 + 0x20);
  }
  else {
    cVar7 = FUN_005d4eb0();
    if (cVar7 == '\0') {
      pbVar1 = (byte *)(param_2 + 0x30);
      if ((*pbVar1 & 0x20) == 0) {
        (**(code **)**(undefined4 **)(param_1 + 0x20))(0x41200000);
        goto LAB_00566378;
      }
      param_2 = 0x3f800000;
      if ((*pbVar1 & 1) == 0) {
        param_2 = 0;
      }
      goto LAB_00566371;
    }
    cVar7 = thunk_FUN_004457a0();
    puVar12 = *(undefined4 **)(param_1 + 0x20);
    if (cVar7 != '\0') {
      (**(code **)*puVar12)(0x40000000);
      goto LAB_00566378;
    }
    param_2 = 0x41200000;
  }
  (**(code **)*puVar12)(param_2);
LAB_00566378:
  param_1 = 0;
  if (DAT_00750194 == 0) {
    param_1 = 0x40000000;
  }
  (**(code **)**(undefined4 **)(iVar5 + 0x24))(param_1);
  if ((*(int *)(iVar5 + 0x68) != 0) && ((*(byte *)(iVar6 + 0x30) & 0x10) != 0)) {
    if ((*(byte *)(iVar6 + 0x30) & 2) == 0) {
      (**(code **)**(undefined4 **)(iVar5 + 0x90))(0x3f800000);
      (**(code **)**(undefined4 **)(iVar5 + 0x8c))(0x3f800000);
    }
    else {
      cVar7 = thunk_FUN_00445780();
      uStack_4 = 0;
      if (cVar7 == '\0') {
        uStack_4 = 0x3f800000;
      }
      (**(code **)**(undefined4 **)(iVar5 + 0x8c))(uStack_4);
      (**(code **)**(undefined4 **)(iVar5 + 0x90))(uStack_4);
    }
  }
  if (*(int *)(iVar5 + 0x28) != 0) {
    iVar9 = FUN_005d44c0();
    uVar15 = 0;
    if (*(char *)(iVar9 + 8) == '\0') {
      uVar15 = 0x3f800000;
    }
    (**(code **)**(undefined4 **)(iVar5 + 0x28))(uVar15);
  }
  if (*(int *)(iVar5 + 0x2c) != 0) {
    uVar15 = 0x3f800000;
    iVar9 = FUN_005d44c0();
    if ((*(char *)(iVar9 + 0xf) != '\0') ||
       (iVar9 = FUN_0055a680(), (*(uint *)(iVar9 + 0x4c) & 0x80000) != 0)) {
      uVar15 = 0;
    }
    (**(code **)**(undefined4 **)(iVar5 + 0x2c))(uVar15);
    if (*(undefined4 **)(iVar5 + 0x1c) != (undefined4 *)0x0) {
      **(undefined4 **)(iVar5 + 0x1c) = *(undefined4 *)(iVar6 + 0x8c);
    }
  }
  puVar12 = *(undefined4 **)(iVar5 + 0x54);
  if ((puVar12 != (undefined4 *)0x0) && (*(int *)(iVar5 + 0x58) != 0)) {
    if (*(float *)(iVar8 + 0xf8) < _DAT_006ea4a4 ==
        (NAN(*(float *)(iVar8 + 0xf8)) || NAN(_DAT_006ea4a4))) {
      (**(code **)*puVar12)(0x3f800000);
      iVar9 = **(int **)(iVar5 + 0x58);
      uVar15 = FUN_006c5018();
      (**(code **)(iVar9 + 4))(uVar15);
    }
    else {
      (**(code **)*puVar12)(0);
    }
  }
  if (*(undefined4 **)(iVar5 + 0x60) != (undefined4 *)0x0) {
    (**(code **)**(undefined4 **)(iVar5 + 0x60))(*(undefined4 *)(iVar6 + 0x88));
  }
  fVar14 = (float10)FUN_00554fb0();
  fVar14 = -(fVar14 * (float10)*(float *)(iVar8 + 0xbc));
  fVar24 = (float)fVar14;
  if (fVar14 < (float10)_DAT_006f5e70 == (NAN(fVar14) || NAN((float10)_DAT_006f5e70))) {
    if (_DAT_006f5e6c < fVar24) {
      fVar24 = 2.79;
    }
  }
  else {
    fVar24 = -2.79;
  }
  FUN_005f74c0(auStack_c,auStack_10,auStack_14,iVar8 + 0x58);
  uVar15 = *(undefined4 *)(iVar8 + 200);
  iVar9 = *(int *)(iVar8 + 0xc4);
  (**(code **)**(undefined4 **)(iVar5 + 0x140))(*(undefined4 *)(iVar8 + 0xc0),iVar9,uVar15);
  (**(code **)(**(int **)(iVar5 + 0x140) + 8))
            (0,*(float *)(iVar8 + 0xd0) - fVar24,*(float *)(iVar8 + 0xd4) - unaff_EBP);
  if (*(int *)(iVar5 + 0x30) != 0) {
    cVar7 = FUN_00573d20();
    iStack_18 = 0x3f800000;
    if (cVar7 == '\0') {
      iStack_18 = 0;
    }
    (**(code **)**(undefined4 **)(iVar5 + 0x30))(iStack_18);
  }
  bVar22 = (byte)((uint)iVar9 >> 0x18);
  if ((*(byte *)(iVar6 + 0x30) & 0x10) != 0) {
    cVar7 = FUN_0057af40(3);
    if (cVar7 == '\0') {
      uVar23 = *(undefined4 *)(iVar6 + 0x80);
      uVar21 = *(undefined4 *)(iVar6 + 0x70);
      uVar20 = *(undefined4 *)(iVar6 + 0x74);
      uVar19 = *(undefined4 *)(iVar6 + 0x78);
      uVar18 = *(undefined4 *)(iVar6 + 0x7c);
      uVar17 = *(undefined4 *)(iVar6 + 100);
      uVar16 = *(undefined4 *)(iVar6 + 0x28);
    }
    else {
      uVar23 = *(undefined4 *)(iVar6 + 0x80);
      uVar21 = *(undefined4 *)(iVar6 + 0x70);
      uVar20 = *(undefined4 *)(iVar6 + 0x74);
      uVar19 = *(undefined4 *)(iVar6 + 0x78);
      uVar18 = *(undefined4 *)(iVar6 + 0x7c);
      uVar17 = *(undefined4 *)(iVar6 + 0x6c);
      uVar16 = *(undefined4 *)(iVar6 + 0x28);
    }
    FUN_0056edd0(iVar5,uVar16,uVar17,uVar18,uVar19,uVar20,uVar21,uVar23);
    uVar10 = getBGCount();
    fVar24 = _DAT_006ee574;
    if (((~(byte)(uVar10 >> 4) & 1) == 0) ||
       (fVar2 = *(float *)(iVar6 + 0x68) - _DAT_006f58f8, bVar4 = true,
       fVar2 < *(float *)(iVar6 + 100) == (NAN(fVar2) || NAN(*(float *)(iVar6 + 100))))) {
      bVar4 = false;
    }
    fVar2 = *(float *)(iVar6 + 0x78);
    bVar13 = _DAT_006ee574 < fVar2;
    bVar3 = *(float *)(iVar6 + 0x70) < _DAT_006f5a4c !=
            (NAN(*(float *)(iVar6 + 0x70)) || NAN(_DAT_006f5a4c));
    iVar9 = CONCAT13(bVar22,0x10000);
    if (*(float *)(iVar6 + 0x7c) < _DAT_006f5a48 ==
        (NAN(*(float *)(iVar6 + 0x7c)) || NAN(_DAT_006f5a48))) {
      iVar9 = (uint)bVar22 << 0x18;
    }
    iVar11 = FUN_0055ab00();
    if (*(int *)(iVar6 + 0x20) == iVar11) {
      DAT_00c533a6 = DAT_00c533a6 | (bVar3 || bVar13);
    }
    if (*(undefined4 **)(iVar5 + 0x34) != (undefined4 *)0x0) {
      uVar23 = 0x3f800000;
      if (!bVar4) {
        uVar23 = 0;
      }
      (**(code **)**(undefined4 **)(iVar5 + 0x34))(uVar23);
    }
    if (*(undefined4 **)(iVar5 + 0x3c) != (undefined4 *)0x0) {
      uVar23 = 0x3f800000;
      if (fVar2 <= fVar24) {
        uVar23 = 0;
      }
      (**(code **)**(undefined4 **)(iVar5 + 0x3c))(uVar23);
    }
    if (*(undefined4 **)(iVar5 + 0x38) != (undefined4 *)0x0) {
      uVar23 = 0x3f800000;
      if (!bVar3) {
        uVar23 = 0;
      }
      (**(code **)**(undefined4 **)(iVar5 + 0x38))(uVar23);
    }
    if (*(undefined4 **)(iVar5 + 0x40) != (undefined4 *)0x0) {
      uVar23 = 0x3f800000;
      if ((char)((uint)iVar9 >> 0x10) == '\0') {
        uVar23 = 0;
      }
      (**(code **)**(undefined4 **)(iVar5 + 0x40))(uVar23);
    }
    if (*(undefined4 **)(iVar5 + 0x44) != (undefined4 *)0x0) {
      uVar23 = 0x3f800000;
      if (!bVar4) {
        uVar23 = 0;
      }
      (**(code **)**(undefined4 **)(iVar5 + 0x44))(uVar23);
    }
    if (*(undefined4 **)(iVar5 + 0x4c) != (undefined4 *)0x0) {
      uVar23 = 0x3f800000;
      if (fVar2 <= fVar24) {
        uVar23 = 0;
      }
      (**(code **)**(undefined4 **)(iVar5 + 0x4c))(uVar23);
    }
    if (*(undefined4 **)(iVar5 + 0x48) != (undefined4 *)0x0) {
      iStack_18 = 0x3f800000;
      if (!bVar3) {
        iStack_18 = 0;
      }
      (**(code **)**(undefined4 **)(iVar5 + 0x48))(iStack_18);
    }
    if (*(undefined4 **)(iVar5 + 0x50) != (undefined4 *)0x0) {
      iStack_18 = 0x3f800000;
      if ((char)((uint)iVar9 >> 0x10) == '\0') {
        iStack_18 = 0;
      }
      (**(code **)**(undefined4 **)(iVar5 + 0x50))(iStack_18);
    }
  }
  puVar12 = *(undefined4 **)(iVar5 + 0xe0);
  if (puVar12 != (undefined4 *)0x0) {
    if (((*(byte *)(iVar6 + 0x30) & 0x10) == 0) && ((char)((uint)iVar9 >> 0x18) == '\0')) {
      (**(code **)*puVar12)(0x3f800000);
    }
    else {
      (**(code **)*puVar12)(0);
    }
  }
  if ((*(byte *)(iVar6 + 0x30) & 1) == 0) {
    puVar12 = *(undefined4 **)(iVar5 + 0x2e0);
    if (puVar12 != (undefined4 *)0x0) {
      iStack_18 = FUN_006c5018();
      iStack_18 = iStack_18 * 10;
      if (iStack_18 < 0) {
        iStack_18 = 0;
      }
      (**(code **)*puVar12)((float)iStack_18);
    }
  }
  else {
    (**(code **)(**(int **)(iVar5 + 0x13c) + 8))
              (*(undefined4 *)(iVar5 + 0x28c),*(undefined4 *)(iVar5 + 0x290),uVar15);
    (**(code **)(**(int **)(iVar5 + 0x110) + 8))
              (*(undefined4 *)(iVar5 + 0x2a4),*(undefined4 *)(iVar8 + 0xb4),
               *(undefined4 *)(iVar8 + 0xb8));
  }
  (**(code **)**(undefined4 **)(iVar5 + 0xf0))
            (*(undefined4 *)(iVar5 + 0x22c),*(undefined4 *)(iVar5 + 0x230),
             *(undefined4 *)(iVar8 + 0xd8));
  (**(code **)**(undefined4 **)(iVar5 + 0xf8))
            (*(undefined4 *)(iVar5 + 0x238),*(undefined4 *)(iVar5 + 0x23c),
             *(undefined4 *)(iVar8 + 0xdc));
  (**(code **)(**(int **)(iVar5 + 0xf0) + 8))
            (*(float *)(iVar8 + 0xbc) + _DAT_006f5e74,*(undefined4 *)(iVar5 + 0x264),
             *(undefined4 *)(iVar8 + 0xe8));
  (**(code **)(**(int **)(iVar5 + 0xf8) + 8))
            (*(float *)(iVar8 + 0xbc) + _DAT_006f5e74,*(undefined4 *)(iVar5 + 0x270),
             *(undefined4 *)(iVar8 + 0xec));
  (**(code **)**(undefined4 **)(iVar5 + 0x100))
            (*(undefined4 *)(iVar5 + 0x244),*(undefined4 *)(iVar5 + 0x248),
             *(undefined4 *)(iVar8 + 0xe0));
  (**(code **)**(undefined4 **)(iVar5 + 0x108))
            (*(undefined4 *)(iVar5 + 0x250),*(undefined4 *)(iVar5 + 0x254),
             *(undefined4 *)(iVar8 + 0xe4));
  (**(code **)(**(int **)(iVar5 + 0x100) + 8))
            (*(float *)(iVar5 + 0x274) + _DAT_006f5e74,*(undefined4 *)(iVar5 + 0x27c),
             *(undefined4 *)(iVar8 + 0xf0));
  (**(code **)(**(int **)(iVar5 + 0x108) + 8))
            (*(float *)(iVar5 + 0x280) + _DAT_006f5e74,*(undefined4 *)(iVar5 + 0x288),
             *(undefined4 *)(iVar8 + 0xf4));
  FUN_00566240(iVar5,iVar6);
  FUN_0042b1f0(iVar5,iVar6);
  (**(code **)**(undefined4 **)(iVar5 + 0xe4))(*(undefined4 *)(iVar6 + 0x34));
  FUN_0042b6c0(iVar5,iVar6);
  return;
}

