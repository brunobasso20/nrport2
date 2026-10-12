/* NR2003.exe @ 004296b0 FUN_004296b0 */

bool FUN_004296b0(int param_1,int *param_2)

{
  char cVar1;
  undefined4 uVar2;
  int iVar3;
  int iVar4;
  undefined auStack_108 [264];
  
  uVar2 = FUN_005cfd1a();
  iVar3 = FUN_005cfd14(uVar2);
  if (iVar3 != 0) {
    uVar2 = FUN_0056c020();
    iVar3 = FUN_005cfd14(uVar2);
    if (iVar3 != 0) {
      uVar2 = FUN_0056c0c0(0xffffffff);
      iVar3 = FUN_005cfd14(uVar2);
      if (iVar3 != 0) {
        iVar3 = *param_2;
        if (((&PTR_PTR_s_pacecar_00722cd8)[param_2[2] + iVar3 * 5] != (undefined *)0x0) &&
           (iVar4 = *(int *)((&PTR_PTR_s_pacecar_00722cd8)[param_2[2] + iVar3 * 5] + param_2[1] * 4)
           , iVar4 != 0)) {
          FUN_006c4f81(auStack_108,s__s_shadow_3do_00722df8,iVar4);
          cVar1 = FUN_005d5270();
          if (cVar1 == '\0') {
            iVar3 = FUN_005d3eb0(auStack_108,param_1 + 0x10,0,1);
          }
          else {
            iVar4 = FUN_006c5910(auStack_108,s_pacecar_00722e08);
            if (iVar4 != 0) {
              iVar4 = 1;
              do {
                cVar1 = FUN_0056c150(iVar4,0xffffffff);
                if (cVar1 != '\0') {
                  FUN_006c4f81(auStack_108,s__s_shadow_3do_00722e10,
                               *(undefined4 *)(&PTR_PTR_s_pacecar_00722cd8)[iVar3 * 5 + iVar4]);
                  break;
                }
                iVar4 = iVar4 + 1;
              } while (iVar4 < 5);
            }
            iVar3 = FUN_005d3eb0(auStack_108,param_1 + 0x10,0,1);
          }
          return iVar3 != 0;
        }
      }
    }
  }
  return false;
}

