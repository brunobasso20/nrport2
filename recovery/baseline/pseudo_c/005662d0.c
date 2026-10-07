/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005662d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005662d0(int param_1,int param_2)

{
  byte *pbVar1;
  bool bVar2;
  bool bVar3;
  int iVar4;
  int iVar5;
  char cVar6;
  int iVar7;
  int iVar8;
  uint uVar9;
  int iVar10;
  undefined4 *puVar11;
  bool bVar12;
  float unaff_EBP;
  float10 fVar13;
  undefined4 uVar14;
  undefined4 uVar15;
  undefined4 uVar16;
  undefined4 uVar17;
  undefined4 uVar18;
  undefined4 uVar19;
  undefined4 uVar20;
  byte bVar21;
  undefined4 uVar22;
  float fVar23;
  int iStack_18;
  undefined1 auStack_14 [4];
  undefined1 auStack_10 [4];
  undefined1 auStack_c [8];
  undefined4 uStack_4;
  
  iVar5 = param_2;
  iVar4 = param_1;
  iVar7 = FUN_005ba130();
  FUN_005b9e70();
  if (*(undefined4 **)(param_1 + 0x2d8) != (undefined4 *)0x0) {
    (**(code **)**(undefined4 **)(param_1 + 0x2d8))((float)*(int *)(param_2 + 0x2c));
  }
  if ((*(byte *)(param_2 + 0x30) & 0x10) == 0) {
    param_2 = 0;
LAB_00566371:
    puVar11 = *(undefined4 **)(param_1 + 0x20);
  }
  else {
    cVar6 = FUN_005d4eb0();
    if (cVar6 == '\0') {
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
    cVar6 = thunk_FUN_004457a0();
    puVar11 = *(undefined4 **)(param_1 + 0x20);
    if (cVar6 != '\0') {
      (**(code **)*puVar11)(0x40000000);
      goto LAB_00566378;
    }
    param_2 = 0x41200000;
  }
  (**(code **)*puVar11)(param_2);
LAB_00566378:
  param_1 = 0;
  if (DAT_00750194 == 0) {
    param_1 = 0x40000000;
  }
  (**(code **)**(undefined4 **)(iVar4 + 0x24))(param_1);
  if ((*(int *)(iVar4 + 0x68) != 0) && ((*(byte *)(iVar5 + 0x30) & 0x10) != 0)) {
    if ((*(byte *)(iVar5 + 0x30) & 2) == 0) {
      (**(code **)**(undefined4 **)(iVar4 + 0x90))(0x3f800000);
      (**(code **)**(undefined4 **)(iVar4 + 0x8c))(0x3f800000);
    }
    else {
      cVar6 = thunk_FUN_00445780();
      uStack_4 = 0;
      if (cVar6 == '\0') {
        uStack_4 = 0x3f800000;
      }
      (**(code **)**(undefined4 **)(iVar4 + 0x8c))(uStack_4);
      (**(code **)**(undefined4 **)(iVar4 + 0x90))(uStack_4);
    }
  }
  if (*(int *)(iVar4 + 0x28) != 0) {
    iVar8 = FUN_005d44c0();
    uVar14 = 0;
    if (*(char *)(iVar8 + 8) == '\0') {
      uVar14 = 0x3f800000;
    }
    (**(code **)**(undefined4 **)(iVar4 + 0x28))(uVar14);
  }
  if (*(int *)(iVar4 + 0x2c) != 0) {
    uVar14 = 0x3f800000;
    iVar8 = FUN_005d44c0();
    if ((*(char *)(iVar8 + 0xf) != '\0') ||
       (iVar8 = FUN_0055a680(), (*(uint *)(iVar8 + 0x4c) & 0x80000) != 0)) {
      uVar14 = 0;
    }
    (**(code **)**(undefined4 **)(iVar4 + 0x2c))(uVar14);
    if (*(undefined4 **)(iVar4 + 0x1c) != (undefined4 *)0x0) {
      **(undefined4 **)(iVar4 + 0x1c) = *(undefined4 *)(iVar5 + 0x8c);
    }
  }
  puVar11 = *(undefined4 **)(iVar4 + 0x54);
  if ((puVar11 != (undefined4 *)0x0) && (*(int *)(iVar4 + 0x58) != 0)) {
    if (_DAT_006ea4a4 <= *(float *)(iVar7 + 0xf8)) {
      (**(code **)*puVar11)(0x3f800000);
      iVar8 = **(int **)(iVar4 + 0x58);
      uVar14 = FUN_006c5018();
      (**(code **)(iVar8 + 4))(uVar14);
    }
    else {
      (**(code **)*puVar11)(0);
    }
  }
  if (*(undefined4 **)(iVar4 + 0x60) != (undefined4 *)0x0) {
    (**(code **)**(undefined4 **)(iVar4 + 0x60))(*(undefined4 *)(iVar5 + 0x88));
  }
  fVar13 = (float10)FUN_00554fb0();
  fVar13 = -(fVar13 * (float10)*(float *)(iVar7 + 0xbc));
  fVar23 = (float)fVar13;
  if ((float10)_DAT_006f5e70 <= fVar13) {
    if (_DAT_006f5e6c < fVar23) {
      fVar23 = 2.79;
    }
  }
  else {
    fVar23 = -2.79;
  }
  FUN_005f74c0(auStack_c,auStack_10,auStack_14,iVar7 + 0x58);
  uVar14 = *(undefined4 *)(iVar7 + 200);
  iVar8 = *(int *)(iVar7 + 0xc4);
  (**(code **)**(undefined4 **)(iVar4 + 0x140))(*(undefined4 *)(iVar7 + 0xc0),iVar8,uVar14);
  (**(code **)(**(int **)(iVar4 + 0x140) + 8))
            (0,*(float *)(iVar7 + 0xd0) - fVar23,*(float *)(iVar7 + 0xd4) - unaff_EBP);
  if (*(int *)(iVar4 + 0x30) != 0) {
    cVar6 = FUN_00573d20();
    iStack_18 = 0x3f800000;
    if (cVar6 == '\0') {
      iStack_18 = 0;
    }
    (**(code **)**(undefined4 **)(iVar4 + 0x30))(iStack_18);
  }
  bVar21 = (byte)((uint)iVar8 >> 0x18);
  if ((*(byte *)(iVar5 + 0x30) & 0x10) != 0) {
    cVar6 = FUN_0057af40(3);
    if (cVar6 == '\0') {
      uVar22 = *(undefined4 *)(iVar5 + 0x80);
      uVar20 = *(undefined4 *)(iVar5 + 0x70);
      uVar19 = *(undefined4 *)(iVar5 + 0x74);
      uVar18 = *(undefined4 *)(iVar5 + 0x78);
      uVar17 = *(undefined4 *)(iVar5 + 0x7c);
      uVar16 = *(undefined4 *)(iVar5 + 100);
      uVar15 = *(undefined4 *)(iVar5 + 0x28);
    }
    else {
      uVar22 = *(undefined4 *)(iVar5 + 0x80);
      uVar20 = *(undefined4 *)(iVar5 + 0x70);
      uVar19 = *(undefined4 *)(iVar5 + 0x74);
      uVar18 = *(undefined4 *)(iVar5 + 0x78);
      uVar17 = *(undefined4 *)(iVar5 + 0x7c);
      uVar16 = *(undefined4 *)(iVar5 + 0x6c);
      uVar15 = *(undefined4 *)(iVar5 + 0x28);
    }
    FUN_0056edd0(iVar4,uVar15,uVar16,uVar17,uVar18,uVar19,uVar20,uVar22);
    uVar9 = getBGCount();
    if (((~(byte)(uVar9 >> 4) & 1) == 0) ||
       (bVar3 = true, *(float *)(iVar5 + 100) <= *(float *)(iVar5 + 0x68) - _DAT_006f58f8)) {
      bVar3 = false;
    }
    bVar12 = _DAT_006ee574 < *(float *)(iVar5 + 0x78);
    bVar2 = *(float *)(iVar5 + 0x70) < _DAT_006f5a4c;
    iVar8 = CONCAT13(bVar21,0x10000);
    if (_DAT_006f5a48 <= *(float *)(iVar5 + 0x7c)) {
      iVar8 = (uint)bVar21 << 0x18;
    }
    iVar10 = FUN_0055ab00();
    if (*(int *)(iVar5 + 0x20) == iVar10) {
      DAT_00c533a6 = DAT_00c533a6 | (bVar2 || bVar12);
    }
    if (*(undefined4 **)(iVar4 + 0x34) != (undefined4 *)0x0) {
      uVar22 = 0x3f800000;
      if (!bVar3) {
        uVar22 = 0;
      }
      (**(code **)**(undefined4 **)(iVar4 + 0x34))(uVar22);
    }
    if (*(undefined4 **)(iVar4 + 0x3c) != (undefined4 *)0x0) {
      uVar22 = 0x3f800000;
      if (!bVar12) {
        uVar22 = 0;
      }
      (**(code **)**(undefined4 **)(iVar4 + 0x3c))(uVar22);
    }
    if (*(undefined4 **)(iVar4 + 0x38) != (undefined4 *)0x0) {
      uVar22 = 0x3f800000;
      if (!bVar2) {
        uVar22 = 0;
      }
      (**(code **)**(undefined4 **)(iVar4 + 0x38))(uVar22);
    }
    if (*(undefined4 **)(iVar4 + 0x40) != (undefined4 *)0x0) {
      uVar22 = 0x3f800000;
      if ((char)((uint)iVar8 >> 0x10) == '\0') {
        uVar22 = 0;
      }
      (**(code **)**(undefined4 **)(iVar4 + 0x40))(uVar22);
    }
    if (*(undefined4 **)(iVar4 + 0x44) != (undefined4 *)0x0) {
      uVar22 = 0x3f800000;
      if (!bVar3) {
        uVar22 = 0;
      }
      (**(code **)**(undefined4 **)(iVar4 + 0x44))(uVar22);
    }
    if (*(undefined4 **)(iVar4 + 0x4c) != (undefined4 *)0x0) {
      uVar22 = 0x3f800000;
      if (!bVar12) {
        uVar22 = 0;
      }
      (**(code **)**(undefined4 **)(iVar4 + 0x4c))(uVar22);
    }
    if (*(undefined4 **)(iVar4 + 0x48) != (undefined4 *)0x0) {
      iStack_18 = 0x3f800000;
      if (!bVar2) {
        iStack_18 = 0;
      }
      (**(code **)**(undefined4 **)(iVar4 + 0x48))(iStack_18);
    }
    if (*(undefined4 **)(iVar4 + 0x50) != (undefined4 *)0x0) {
      iStack_18 = 0x3f800000;
      if ((char)((uint)iVar8 >> 0x10) == '\0') {
        iStack_18 = 0;
      }
      (**(code **)**(undefined4 **)(iVar4 + 0x50))(iStack_18);
    }
  }
  puVar11 = *(undefined4 **)(iVar4 + 0xe0);
  if (puVar11 != (undefined4 *)0x0) {
    if (((*(byte *)(iVar5 + 0x30) & 0x10) == 0) && ((char)((uint)iVar8 >> 0x18) == '\0')) {
      (**(code **)*puVar11)(0x3f800000);
    }
    else {
      (**(code **)*puVar11)(0);
    }
  }
  if ((*(byte *)(iVar5 + 0x30) & 1) == 0) {
    puVar11 = *(undefined4 **)(iVar4 + 0x2e0);
    if (puVar11 != (undefined4 *)0x0) {
      iStack_18 = FUN_006c5018();
      iStack_18 = iStack_18 * 10;
      if (iStack_18 < 0) {
        iStack_18 = 0;
      }
      (**(code **)*puVar11)((float)iStack_18);
    }
  }
  else {
    (**(code **)(**(int **)(iVar4 + 0x13c) + 8))
              (*(undefined4 *)(iVar4 + 0x28c),*(undefined4 *)(iVar4 + 0x290),uVar14);
    (**(code **)(**(int **)(iVar4 + 0x110) + 8))
              (*(undefined4 *)(iVar4 + 0x2a4),*(undefined4 *)(iVar7 + 0xb4),
               *(undefined4 *)(iVar7 + 0xb8));
  }
  (**(code **)**(undefined4 **)(iVar4 + 0xf0))
            (*(undefined4 *)(iVar4 + 0x22c),*(undefined4 *)(iVar4 + 0x230),
             *(undefined4 *)(iVar7 + 0xd8));
  (**(code **)**(undefined4 **)(iVar4 + 0xf8))
            (*(undefined4 *)(iVar4 + 0x238),*(undefined4 *)(iVar4 + 0x23c),
             *(undefined4 *)(iVar7 + 0xdc));
  (**(code **)(**(int **)(iVar4 + 0xf0) + 8))
            (*(float *)(iVar7 + 0xbc) + _DAT_006f5e74,*(undefined4 *)(iVar4 + 0x264),
             *(undefined4 *)(iVar7 + 0xe8));
  (**(code **)(**(int **)(iVar4 + 0xf8) + 8))
            (*(float *)(iVar7 + 0xbc) + _DAT_006f5e74,*(undefined4 *)(iVar4 + 0x270),
             *(undefined4 *)(iVar7 + 0xec));
  (**(code **)**(undefined4 **)(iVar4 + 0x100))
            (*(undefined4 *)(iVar4 + 0x244),*(undefined4 *)(iVar4 + 0x248),
             *(undefined4 *)(iVar7 + 0xe0));
  (**(code **)**(undefined4 **)(iVar4 + 0x108))
            (*(undefined4 *)(iVar4 + 0x250),*(undefined4 *)(iVar4 + 0x254),
             *(undefined4 *)(iVar7 + 0xe4));
  (**(code **)(**(int **)(iVar4 + 0x100) + 8))
            (*(float *)(iVar4 + 0x274) + _DAT_006f5e74,*(undefined4 *)(iVar4 + 0x27c),
             *(undefined4 *)(iVar7 + 0xf0));
  (**(code **)(**(int **)(iVar4 + 0x108) + 8))
            (*(float *)(iVar4 + 0x280) + _DAT_006f5e74,*(undefined4 *)(iVar4 + 0x288),
             *(undefined4 *)(iVar7 + 0xf4));
  FUN_00566240(iVar4,iVar5);
  FUN_0042b1f0(iVar4,iVar5);
  (**(code **)**(undefined4 **)(iVar4 + 0xe4))(*(undefined4 *)(iVar5 + 0x34));
  FUN_0042b6c0(iVar4,iVar5);
  return;
}


