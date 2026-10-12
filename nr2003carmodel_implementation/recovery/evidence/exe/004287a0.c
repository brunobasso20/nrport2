/* NR2003.exe @ 004287a0 FUN_004287a0 */

undefined4 FUN_004287a0(undefined4 param_1,int param_2)

{
  undefined4 uVar1;
  int iVar2;
  
  uVar1 = FUN_005cfd1a();
  iVar2 = FUN_005cfd14(uVar1);
  if (iVar2 != 0) {
    uVar1 = FUN_0056c020();
    iVar2 = FUN_005cfd14(uVar1);
    if (iVar2 != 0) {
      uVar1 = FUN_0056c0c0(0xffffffff);
      iVar2 = FUN_005cfd14(uVar1);
      if ((iVar2 != 0) && (param_2 != 0)) {
        iVar2 = FUN_005d3eb0(param_2,param_1,1,0);
        if (iVar2 != 0) {
          return 1;
        }
      }
    }
  }
  return 0;
}

