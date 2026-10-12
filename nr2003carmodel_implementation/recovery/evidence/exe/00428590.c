/* NR2003.exe @ 00428590 FUN_00428590 */

undefined4 FUN_00428590(undefined4 param_1)

{
  undefined4 uVar1;
  int iVar2;
  undefined4 uStack_4;
  
  uVar1 = FUN_005cfd1a();
  iVar2 = FUN_005cfd14(uVar1);
  if (iVar2 != 0) {
    uVar1 = FUN_0056c020();
    iVar2 = FUN_005cfd14(uVar1);
    if (iVar2 != 0) {
      uVar1 = FUN_0056c0c0(0xffffffff);
      iVar2 = FUN_005cfd14(uVar1);
      if (iVar2 != 0) {
        uStack_4 = 0;
        iVar2 = FUN_005cfd0e(&param_1,param_1);
        if (iVar2 == 1) {
          iVar2 = FUN_005d3bb0(param_1,&uStack_4,1,0,1);
          FUN_005cfd08(param_1);
          if (iVar2 != 0) {
            return uStack_4;
          }
        }
      }
    }
  }
  return 0;
}

