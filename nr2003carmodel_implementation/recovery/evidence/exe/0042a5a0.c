/* NR2003.exe @ 0042a5a0 FUN_0042a5a0 */

undefined4 FUN_0042a5a0(int param_1,int *param_2)

{
  undefined4 uVar1;
  int iVar2;
  undefined auStack_108 [264];
  
  uVar1 = FUN_005cfd1a();
  iVar2 = FUN_005cfd14(uVar1);
  if (iVar2 != 0) {
    uVar1 = FUN_0056c020();
    iVar2 = FUN_005cfd14(uVar1);
    if (iVar2 != 0) {
      uVar1 = FUN_0056c0c0(0xffffffff);
      iVar2 = FUN_005cfd14(uVar1);
      if (iVar2 != 0) {
        if (((&PTR_PTR_s_pacecar_00722cd8)[*param_2 * 5 + param_2[2]] != (undefined *)0x0) &&
           (iVar2 = *(int *)((&PTR_PTR_s_pacecar_00722cd8)[*param_2 * 5 + param_2[2]] +
                            param_2[1] * 4), iVar2 != 0)) {
          FUN_006c4f81(auStack_108,s__s_light_cockpit_3do_00723298,iVar2);
          FUN_005d52d0(0);
          iVar2 = FUN_005d3eb0(auStack_108,param_1 + 0x68,0,0);
          if (iVar2 != 0) {
            return 1;
          }
        }
      }
    }
  }
  return 0;
}

