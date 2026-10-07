/* NR2003.exe @ 005bd670 FUN_005bd670 */

undefined4 FUN_005bd670(uint *param_1,undefined4 param_2)

{
  uint *puVar1;
  undefined4 uVar2;
  int iVar3;
  uint *puVar4;
  uint *puVar5;
  int iVar6;
  uint uVar7;
  undefined4 uVar8;
  uint uVar9;
  
  puVar1 = param_1;
  uVar8 = 0;
  uVar7 = param_1[3] - 1;
  param_1[3] = uVar7;
  if ((*param_1 & 2) == 0) {
    uVar9 = *param_1 | 2;
    *param_1 = uVar9;
    iVar3 = FUN_005bd200(param_1);
    uVar2 = param_2;
    if (iVar3 == 0) {
      iVar3 = (int)uVar9 >> 2;
      if (iVar3 == 0xe) {
        if (puVar1[2] != 0) {
          FUN_005bd650(puVar1[2],param_2);
        }
        uVar8 = FUN_005bdd50(puVar1[2]);
        FUN_005bdb20(puVar1[1],uVar8);
        return 0;
      }
      if (iVar3 == 0xc) {
        FUN_005bdd70(*(int *)puVar1[1] >> 2);
        *(int *)(puVar1[1] + 0xc) = *(int *)(puVar1[1] + 0xc) + -1;
        FUN_005bd8f0(*(int *)puVar1[1] >> 2);
        if (puVar1[2] != 0) {
          FUN_005bd650(puVar1[2],param_2);
          return 0;
        }
      }
      else {
        if (iVar3 != 0xd) {
          iVar6 = FUN_005bd610(&param_1,puVar1);
          if (iVar6 != 0) {
            FUN_005bded0(iVar3,puVar1[1],puVar1[2],param_2);
            puVar1 = param_1;
            puVar4 = (uint *)FUN_005bd8c0(param_1);
            while (puVar5 = puVar4, puVar5 != (uint *)0x0) {
              FUN_005bdd70(puVar1);
              FUN_005bd930(puVar1);
              puVar4 = (uint *)FUN_005bd8c0(puVar5);
              puVar1 = puVar5;
            }
            FUN_005bdd70(puVar1);
            FUN_005bdac0(puVar1);
            return 0;
          }
          if (0 < (int)uVar7) {
            FUN_005bded0(iVar3,puVar1[1],puVar1[2],param_2);
            uVar8 = FUN_005bd5a0(param_1);
            FUN_005bdac0(uVar8);
            return 0;
          }
          FUN_005bd490(iVar3,puVar1[1],puVar1[2],param_2);
          return 0;
        }
        FUN_005bdbd0(puVar1[1],param_2);
        if (puVar1[2] != 0) {
          FUN_005bd650(puVar1[2],uVar2);
          return 0;
        }
      }
    }
    else {
      iVar3 = FUN_005bd610(&param_1,puVar1);
      puVar5 = param_1;
      puVar4 = param_1;
      if (iVar3 != 0) {
        for (; puVar4 != (uint *)0x0; puVar4 = (uint *)FUN_005bd8c0(puVar4)) {
          FUN_005bdd70(puVar4);
        }
        FUN_005bdae0(&DAT_00ebbf60 + ((int)*puVar1 >> 2) * 4);
        if (puVar5 != (uint *)0x0) {
          do {
            FUN_005bdb00(&DAT_00ebbf60 + (int)puVar5 * 4);
            puVar5 = (uint *)FUN_005bd8c0(puVar5);
          } while (puVar5 != (uint *)0x0);
          return 0;
        }
      }
    }
  }
  else if (((uVar7 == 0) && (iVar3 = FUN_005bd610(&param_1,param_1), iVar3 == 0)) &&
          (param_1 != (uint *)0x0)) {
    uVar8 = FUN_005bd5a0(param_1);
  }
  return uVar8;
}

