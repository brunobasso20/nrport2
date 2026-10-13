/* rend_dxg.dll @ 1002c6e0 FUN_1002c6e0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __thiscall FUN_1002c6e0(int param_1_00,double param_1)

{
  bool bVar1;
  char cVar2;
  char cVar3;
  char cVar4;
  undefined4 uVar5;
  int iVar6;
  bool bVar7;
  int iVar8;
  bool bVar9;

  bVar9 = *(int *)(param_1_00 + 0x54) != 0;
  if ((*(int *)(param_1_00 + 0x48) == 0) || (*(int *)(*(int *)(param_1_00 + 0x5c) + 0xec) == 2)) {
    cVar2 = '\0';
    bVar7 = false;
  }
  else {
    bVar7 = true;
    cVar2 = '\x01';
  }
  if (((((param_1 <= _DAT_10097460) || (bVar9)) || (bVar7)) ||
      ((*(int *)(param_1_00 + 0x4c) != 0 || (*(int *)(param_1_00 + 0x50) != 0)))) ||
     ((*(int *)(param_1_00 + 0x38) != 0 || (*(int *)(*(int *)(param_1_00 + 0x5c) + 0xec) != 0)))) {
    cVar3 = '\0';
  }
  else {
    cVar3 = '\x01';
  }
  if (((*(int *)(param_1_00 + 0x40) != 0) || (!bVar7)) || (bVar9)) {
    bVar7 = false;
  }
  else {
    bVar7 = true;
  }
  if ((param_1 <= _DAT_10097460) || (bVar1 = true, cVar3 != '\0')) {
    bVar1 = false;
  }
  iVar8 = -1;
  cVar4 = FUN_10006400();
  if (((cVar4 == '\0') || (-1 < (char)*(uint *)(param_1_00 + 0xc))) ||
     ((*(uint *)(param_1_00 + 0xc) & 4) != 0)) {
    if (bVar7) goto LAB_1002c817;
    if (bVar9) goto LAB_1002c83d;
    if (cVar2 == '\0') goto LAB_1002c8be;
  }
  else {
    if (bVar7) {
LAB_1002c817:
      iVar6 = FUN_1002d6f0();
      if (iVar6 != 1) {
        return 0;
      }
      goto LAB_1002c8e6;
    }
    if (bVar9) {
LAB_1002c83d:
      iVar6 = FUN_1002d390(cVar2,cVar3,!bVar9);
      if (iVar6 != 1) {
        return 0;
      }
      iVar6 = FUN_1002db30(cVar2,1);
      if (iVar6 != 1) {
        return 0;
      }
      if ((cVar2 != '\0') && (iVar6 = FUN_1002d810(), iVar6 != 1)) {
        return 0;
      }
      goto LAB_1002c8e6;
    }
    if (cVar2 == '\0') {
      if (((bVar1) && (*(int *)(*(int *)(param_1_00 + 0x5c) + 0xec) == 0)) &&
         ((*(int *)(param_1_00 + 0x40) != 0 &&
          ((*(int *)(param_1_00 + 0x4c) != 0 && (*(int *)(param_1_00 + 0x50) != 0)))))) {
        uVar5 = FUN_1002d0e0();
        return uVar5;
      }
LAB_1002c8be:
      iVar8 = FUN_1002d390(0,cVar3,1);
      if (iVar8 != 1) {
        return 0;
      }
      iVar8 = *(int *)(*(int *)(param_1_00 + 0x5c) + 0x1c) + -1;
      goto LAB_1002c8e6;
    }
  }
  iVar6 = FUN_1002cf00();
  if (iVar6 != 1) {
    return 0;
  }
LAB_1002c8e6:
  if (bVar1) {
    if (*(int *)(param_1_00 + 0x4c) == 0) {
      if (*(int *)(param_1_00 + 0x50) != 0) {
        iVar6 = FUN_1002da40();
        if (iVar6 != 1) {
          return 0;
        }
        if (iVar8 < 0) {
          return 1;
        }
        *(undefined *)(*(int *)(param_1_00 + 0x5c) + 0x2d + iVar8 * 0x1c) = 2;
        return 1;
      }
    }
    else if (*(int *)(param_1_00 + 0x50) != 0) {
      iVar6 = FUN_1002d000();
      if (iVar6 != 1) {
        return 0;
      }
      if (iVar8 < 0) {
        return 1;
      }
      *(undefined *)(*(int *)(param_1_00 + 0x5c) + 0x2d + iVar8 * 0x1c) = 1;
      return 1;
    }
    iVar8 = FUN_1002d8d0();
    if (iVar8 != 1) {
      return 0;
    }
  }
  return 1;
}
