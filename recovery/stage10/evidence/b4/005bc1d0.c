/* NR2003.exe @ 005bc1d0 FUN_005bc1d0 */

undefined4 FUN_005bc1d0(int param_1)

{
  int iVar1;
  undefined4 uVar2;
  int iVar3;
  int iVar4;
  int iVar5;
  int local_8;
  undefined4 local_4;
  
  iVar1 = *(int *)(PTR_DAT_00749378 + 0x2c);
  if (((iVar1 != 0) && (0 < DAT_00b8faa0)) && (0 < *(int *)(param_1 + 0x10))) {
    uVar2 = *(undefined4 *)(PTR_DAT_00749378 + 4);
    local_4 = *(undefined4 *)(PTR_DAT_00749378 + 8);
    iVar5 = DAT_00b8faa0 * 4;
    iVar4 = FUN_005cfce4(&local_8,iVar5);
    iVar3 = local_8;
    if ((iVar4 != 0) && (local_8 != 0)) {
      iVar5 = FUN_005cfce4(&local_8,iVar5);
      if ((iVar5 != 0) && (local_8 != 0)) {
        iVar5 = FUN_005bccc0(iVar1,iVar3,local_8);
        if (iVar5 == 1) {
          FUN_005bc2d0(iVar1,uVar2,local_4,iVar3,local_8,param_1);
        }
        iVar5 = FUN_005bcd40(iVar1,iVar3);
        if (iVar5 == 1) {
          FUN_005bc950(iVar1,iVar3,param_1);
        }
        FUN_005cfccc(iVar3);
        FUN_005cfccc(local_8);
        return 1;
      }
      FUN_005cfccc(iVar3);
    }
  }
  return 1;
}

