/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005ee0e0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005ee0e0(int param_1,int param_2,int param_3,undefined4 param_4)

{
  undefined4 uVar1;
  int iVar2;
  int iVar3;
  int iVar4;
  int *piVar5;
  int iVar6;
  undefined4 *puVar7;
  int *piVar8;
  int iStack_28;
  int iStack_24;
  undefined4 *local_20;
  int iStack_1c;
  int local_18;
  undefined4 local_14;
  undefined4 *local_10 [2];
  undefined8 local_8;
  
  FUN_005ee030(2);
  local_8 = _DAT_006e9808;
  *local_10[0] = 0;
  local_10[0][1] = 0x3f800000;
  local_8 = local_8 / (double)CONCAT44(DAT_006f8b4c,DAT_006f8b48);
  local_18 = DAT_006f8b48;
  local_14 = DAT_006f8b4c;
  FUN_005ee970();
  iVar2 = FUN_005cfce4(&local_20,0x1c);
  if ((iVar2 == 0) || (local_20 == (undefined4 *)0x0)) {
    iStack_28 = 0;
  }
  else {
    iStack_28 = FUN_005f4020(*(undefined4 *)(param_1 + 4),*(undefined4 *)(param_1 + 8));
  }
  FUN_005ee330(param_1,iStack_28);
  FUN_005f4bf0(local_18,local_14);
  iStack_24 = 1;
  if (0 < param_3) {
    local_20 = &DAT_00f6e88c;
    do {
      puVar7 = local_20;
      uVar1 = *local_20;
      iVar2 = *(int *)(param_1 + 4) / 2;
      if (iVar2 < 2) {
        iVar2 = 1;
      }
      iVar3 = *(int *)(param_1 + 8) / 2;
      if (iVar3 < 2) {
        iVar3 = 1;
      }
      iVar4 = FUN_005cfce4(&iStack_1c,0x1c);
      if ((iVar4 == 0) || (iStack_1c == 0)) {
        piVar5 = (int *)0x0;
      }
      else {
        piVar5 = (int *)FUN_005f4020(iVar2,iVar3);
      }
      FUN_005f4b30(piVar5,uVar1);
      FUN_005f4bb0(0,0x3f800000);
      FUN_005f4bf0((undefined4)local_8,local_8._4_4_);
      if (0xf6e88c < (int)puVar7) {
        iVar2 = iStack_24 + -1;
        piVar8 = piVar5;
        do {
          iVar3 = *piVar8 / 2;
          if (iVar3 < 2) {
            iVar3 = 1;
          }
          iVar4 = piVar8[1] / 2;
          if (iVar4 < 2) {
            iVar4 = 1;
          }
          iVar6 = FUN_005cfce4(&local_18,0x1c);
          if ((iVar6 == 0) || (local_18 == 0)) {
            piVar5 = (int *)0x0;
          }
          else {
            piVar5 = (int *)FUN_005f4020(iVar3,iVar4);
          }
          FUN_005f4b30(piVar5,local_10);
          FUN_005f4110();
          FUN_005cfccc(piVar8);
          iVar2 = iVar2 + -1;
          puVar7 = local_20;
          piVar8 = piVar5;
        } while (iVar2 != 0);
      }
      FUN_005ee660(piVar5,*(undefined4 *)(param_2 + iStack_24 * 4),param_4);
      if (piVar5 != (int *)0x0) {
        FUN_005f4110();
        FUN_005cfccc(piVar5);
      }
      iStack_24 = iStack_24 + 1;
      local_20 = puVar7 + 1;
    } while (iStack_24 <= param_3);
  }
  if (iStack_28 != 0) {
    FUN_005f4110();
    FUN_005cfccc(iStack_28);
  }
  FUN_005eeb70();
  FUN_005ee080();
  return;
}


