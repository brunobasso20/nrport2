/* NR2003.exe @ 00558fa0 FUN_00558fa0 */

undefined4 __thiscall
FUN_00558fa0(int param_1,undefined4 param_2,undefined4 param_3,undefined4 param_4)

{
  char cVar1;
  undefined4 uVar2;
  int iVar3;
  int iStack_4;
  
  iStack_4 = param_1;
  uVar2 = FUN_005cfd1a();
  iVar3 = FUN_005cfd14(uVar2);
  if (((iVar3 != 0) && (iVar3 = FUN_005cfd14(s_players_0074da90), iVar3 != 0)) &&
     (iVar3 = FUN_005cfd14(param_2), iVar3 != 0)) {
    iVar3 = FUN_005cfd14(s_setups_0074da98);
    if (iVar3 == 0) {
      iVar3 = FUN_005cfe34(s_setups_0074daa0);
      if (iVar3 == 0) {
        return 0;
      }
      iVar3 = FUN_005cfd14(s_setups_0074daa8);
      if (iVar3 == 0) {
        return 0;
      }
    }
    iVar3 = FUN_005cfd14(param_3);
    if (iVar3 == 0) {
      iVar3 = FUN_005cfe34(param_3);
      if (iVar3 == 0) {
        return 0;
      }
      iVar3 = FUN_005cfd14(param_3);
      if (iVar3 == 0) {
        return 0;
      }
    }
    cVar1 = FUN_005cfd74(param_1 + 0x2ec);
    if ((cVar1 != '\0') && (iVar3 = FUN_005cfdc2(&iStack_4,param_1 + 0x2ec), iVar3 != 0)) {
      iVar3 = FUN_005cfedc(param_4,0x44534c50,4,0x303,iStack_4);
      if ((iVar3 != 0) && (iVar3 = FUN_005cfd08(iStack_4), iVar3 != 0)) {
        return 1;
      }
      FUN_005cfd08(iStack_4);
    }
  }
  return 0;
}

