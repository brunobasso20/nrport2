/* NR2003.exe @ 005590d0 FUN_005590d0 */

undefined4 __thiscall
FUN_005590d0(int param_1,undefined4 param_2,undefined4 param_3,undefined4 param_4)

{
  undefined4 uVar1;
  int iVar2;
  int iStack_4;
  
  iStack_4 = param_1;
  uVar1 = FUN_005cfd1a();
  iVar2 = FUN_005cfd14(uVar1);
  if (((iVar2 != 0) && (iVar2 = FUN_005cfd14(s_players_0074dab0), iVar2 != 0)) &&
     (iVar2 = FUN_005cfd14(param_2), iVar2 != 0)) {
    iVar2 = FUN_005cfd14(s_setups_0074dab8);
    if (iVar2 == 0) {
      iVar2 = FUN_005cfe34(s_setups_0074dac0);
      if (iVar2 == 0) {
        return 0;
      }
      iVar2 = FUN_005cfd14(s_setups_0074dac8);
      if (iVar2 == 0) {
        return 0;
      }
    }
    iVar2 = FUN_005cfd14(param_3);
    if (iVar2 == 0) {
      iVar2 = FUN_005cfe34(param_3);
      if (iVar2 == 0) {
        return 0;
      }
      iVar2 = FUN_005cfd14(param_3);
      if (iVar2 == 0) {
        return 0;
      }
    }
    iVar2 = FUN_005cfdda(&iStack_4,param_1 + 0x2ec);
    if (iVar2 != 0) {
      iVar2 = FUN_005cfe46(iStack_4,0x44534c50,4,0x303,param_4);
      if ((iVar2 != 0) && (iVar2 = FUN_005cfd08(iStack_4), iVar2 != 0)) {
        return 1;
      }
      FUN_005cfd08(iStack_4);
    }
  }
  return 0;
}

