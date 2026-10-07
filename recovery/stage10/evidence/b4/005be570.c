/* NR2003.exe @ 005be570 FUN_005be570 */

void FUN_005be570(uint *param_1,undefined4 param_2)

{
  uint uVar1;
  int iVar2;
  uint *puVar3;
  uint *puVar4;
  undefined4 uVar5;
  int extraout_ECX;
  undefined8 uVar6;
  
  puVar3 = param_1;
  uVar1 = *param_1;
  param_1[3] = param_1[3] - 1;
  if ((uVar1 & 2) == 0) {
    *param_1 = uVar1 | 2;
    iVar2 = FUN_005bd200(param_1);
    if (iVar2 == 0) {
      FUN_005bded0(extraout_ECX >> 2,puVar3[1],puVar3[2],param_2);
      iVar2 = FUN_005bd610(&param_1,puVar3);
      puVar4 = param_1;
      if (iVar2 != 0) {
        do {
          FUN_005bdd70(puVar4);
          FUN_005bd930(puVar4);
          puVar4 = (uint *)FUN_005bd8c0(puVar4);
        } while (puVar4 != (uint *)0x0);
        return;
      }
      if (0 < (int)puVar3[3]) {
        uVar5 = FUN_005bd5a0(param_1);
        FUN_005bd930(uVar5);
        return;
      }
    }
    else {
      FUN_005be710(extraout_ECX >> 2);
      iVar2 = FUN_005bd610(&param_1,puVar3);
      puVar3 = param_1;
      if (iVar2 != 0) {
        do {
          FUN_005bdd70(puVar3);
          FUN_005bd930(puVar3);
          puVar3 = (uint *)FUN_005bd8c0(puVar3);
        } while (puVar3 != (uint *)0x0);
        return;
      }
    }
  }
  else {
    iVar2 = FUN_005bd200(param_1);
    if (iVar2 == 0) {
      iVar2 = FUN_005bd610(&param_1,puVar3);
      puVar4 = param_1;
      if (iVar2 != 0) goto LAB_005be6fe;
    }
    else {
      iVar2 = FUN_005bd610(&param_1,puVar3);
      if (iVar2 != 0) {
        FUN_005be710(param_1);
        return;
      }
      uVar6 = FUN_005bdd00((int)uVar1 >> 2);
      puVar4 = (uint *)((ulonglong)uVar6 >> 0x20);
      if ((int)uVar6 != 0) {
        FUN_005be710(puVar4);
        return;
      }
      if ((&DAT_00ec02c8)[(int)puVar4] != 0) {
        FUN_005be710(puVar4);
        return;
      }
      if ((uint *)(&DAT_00ed7840)[(int)puVar4] == puVar3) {
LAB_005be6fe:
        FUN_005be710(puVar4);
        return;
      }
    }
    puVar4 = param_1;
    uVar5 = FUN_005bd5a0(param_1);
    FUN_005be710(uVar5);
    if (puVar3[3] == 0) {
      uVar5 = FUN_005bd5a0(puVar4);
      FUN_005bd5e0(uVar5);
    }
  }
  return;
}

