/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0055c750 */

void FUN_0055c750(byte *param_1)

{
  int iVar1;
  undefined4 uVar2;
  int iVar3;
  
  if ((*param_1 & 0x40) == 0) {
    uVar2 = *(undefined4 *)(param_1 + 4);
    iVar3 = 0x30;
    do {
      FUN_005a0b20(uVar2);
      iVar3 = iVar3 + -1;
    } while (iVar3 != 0);
    DAT_00c081a4 = *(undefined4 *)(param_1 + 4);
    iVar3 = FUN_005cebe0(*(int *)(param_1 + 4) + -1 + DAT_00c074c0);
    iVar1 = getBGCount();
    iVar3 = FUN_005cebe0(iVar1 - iVar3);
    if (iVar3 != 0) {
      iVar1 = getBGCount();
      iVar3 = FUN_005cebe0(iVar1 + iVar3);
      taskSetBGCount(iVar3);
    }
    uVar2 = FUN_0055a5c0();
    FUN_0055a4f0(4);
    FUN_0055a5b0(uVar2);
    uVar2 = 0x3f800000;
    FUN_0055a610(0x3f800000);
    FUN_00569270(uVar2);
    FUN_005d0930();
    return;
  }
  return;
}


