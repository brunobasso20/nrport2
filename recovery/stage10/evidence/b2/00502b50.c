/* NR2003.exe @ 00502b50 FUN_00502b50 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00502b50(void)

{
  int iVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  undefined4 uVar4;
  undefined4 uVar5;
  
  FUN_00504f30();
  if (DAT_00b8e59a == 1) {
    DAT_00b8e59a = 0;
    FUN_005020e0(2);
    iVar1 = FUN_00503470();
    DAT_00b8e915 = *(undefined4 *)(iVar1 + 4);
    iVar1 = FUN_00503470();
    if (*(int *)(iVar1 + 0xc) == 0) {
      DAT_00b8e919 = -1;
    }
    else {
      DAT_00b8e919 = *(int *)(*(int *)(iVar1 + 0xc) + 0x5b2);
    }
    uVar5 = 0;
    uVar3 = 0;
    uVar2 = 0;
    FUN_00503470(0,0,0);
    FUN_00568d10(uVar2,uVar3,uVar5);
    ram0x00b8e5b5 = 0;
    DAT_00b8e5b4._0_1_ = 0;
    iVar1 = FUN_0055a5a0();
    if ((iVar1 == 4) || (iVar1 == 5)) {
      iVar1 = FUN_0055a610();
      if (*(int *)(iVar1 + 4) == 0) {
        if (DAT_00b8e919 < 0) {
          uVar2 = 0;
        }
        else {
          uVar2 = FUN_00562f70(DAT_00b8e919);
        }
        uVar4 = 0;
        uVar5 = 0;
        uVar3 = DAT_00b8e915;
        FUN_0055a610(DAT_00b8e915,0,0,uVar2);
        FUN_00568e20(uVar3,uVar5,uVar4,uVar2);
      }
    }
    DAT_00b8e59e = 0;
    return;
  }
  DAT_00b8e59e = 0;
  return;
}

