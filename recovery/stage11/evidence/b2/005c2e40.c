/* NR2003.exe @ 005c2e40 FUN_005c2e40 */

int FUN_005c2e40(int param_1)

{
  int iVar1;
  undefined4 uVar2;
  int iVar3;
  int iVar4;
  
  iVar1 = FUN_005c2d40(param_1);
  if ((iVar1 == 2) && (*(int *)(param_1 + 0x2e) < 1)) {
    uVar2 = FUN_005c31a0(param_1);
    iVar1 = FUN_005c34b0(uVar2);
    iVar3 = FUN_005cfcde(param_1 + 0xa2);
    iVar4 = FUN_005c3ec0(param_1);
    if (iVar3 + iVar4 < iVar1) {
      return iVar1 - (iVar3 + iVar4);
    }
  }
  return 0;
}

