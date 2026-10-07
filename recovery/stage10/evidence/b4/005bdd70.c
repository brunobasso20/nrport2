/* NR2003.exe @ 005bdd70 FUN_005bdd70 */

void FUN_005bdd70(int param_1)

{
  uint *puVar1;
  uint uVar2;
  int iVar3;
  int iVar4;
  int iVar5;
  int iVar6;
  undefined4 uVar7;
  undefined4 extraout_EDX;
  undefined4 extraout_EDX_00;
  uint uVar8;
  
  iVar3 = param_1;
  puVar1 = (uint *)(&DAT_00ec02c8)[param_1];
  if (puVar1 == (uint *)0x0) {
    return;
  }
  uVar8 = *puVar1;
  if ((uVar8 & 2) == 0) {
    uVar8 = uVar8 | 2;
    *puVar1 = uVar8;
    iVar4 = FUN_005bd610(&param_1,puVar1);
    iVar6 = param_1;
    iVar5 = param_1;
    if (iVar4 != 0) {
      for (; iVar5 != 0; iVar5 = FUN_005bd8c0(iVar5)) {
        FUN_005bdd70(iVar5);
      }
      FUN_005bdae0(&DAT_00ebbf60 + ((int)*puVar1 >> 2) * 4);
      if (iVar6 != 0) {
        do {
          FUN_005bdb00(&DAT_00ebbf60 + iVar6 * 4);
          iVar6 = FUN_005bd8c0(extraout_EDX);
        } while (iVar6 != 0);
        (&DAT_00ec02c8)[iVar3] = 0;
        return;
      }
      goto LAB_005bdeb7;
    }
    uVar2 = puVar1[3];
  }
  else {
    iVar5 = FUN_005bd610(&param_1,puVar1);
    if (iVar5 != 0) goto LAB_005bdeb7;
    uVar2 = puVar1[3];
  }
  if (0 < (int)uVar2) {
    if (param_1 != 0) {
      FUN_005bdae0(&DAT_00ebbf60 + ((int)uVar8 >> 2) * 4);
      iVar5 = FUN_005bd5a0(extraout_EDX_00);
      FUN_005bdb00(&DAT_00ebbf60 + iVar5 * 4);
      (&DAT_00ec02c8)[iVar3] = 0;
      return;
    }
    uVar7 = FUN_005bcd70();
    FUN_005bd160(uVar7,puVar1);
    FUN_005bdae0(&DAT_00ebbf60 + ((int)*puVar1 >> 2) * 4);
    iVar5 = FUN_005bd5a0(uVar7);
    FUN_005bdb00(&DAT_00ebbf60 + iVar5 * 4);
  }
LAB_005bdeb7:
  (&DAT_00ec02c8)[iVar3] = 0;
  return;
}

