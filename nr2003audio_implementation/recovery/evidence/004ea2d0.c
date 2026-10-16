/* NR2003.exe @ 004ea2d0 FUN_004ea2d0 */

void __thiscall FUN_004ea2d0(int param_1_00,undefined4 param_1)

{
  int *piVar1;
  int *piVar2;
  int iVar3;
  int iVar4;
  int *piVar5;
  
  iVar4 = 0x20;
  piVar5 = (int *)(param_1_00 + 0x17a0);
  piVar2 = piVar5;
  iVar3 = param_1_00;
  do {
    *piVar2 = iVar3;
    piVar2 = piVar2 + 1;
    iVar3 = iVar3 + 0xbd;
    iVar4 = iVar4 + -1;
  } while (iVar4 != 0);
  piVar2 = (int *)(param_1_00 + 0x187c);
  FUN_005cfdb6(param_1,piVar2,4);
  if (1 < *piVar2) {
    FUN_005cfdb6(param_1,param_1_00 + 0x1824,8);
    iVar3 = param_1_00 + 0x184c;
    iVar4 = 8;
    do {
      FUN_005cfdb6(param_1,iVar3 + -0x20,4);
      FUN_005cfdb6(param_1,iVar3,4);
      iVar3 = iVar3 + 4;
      iVar4 = iVar4 + -1;
    } while (iVar4 != 0);
    FUN_005cfdb6(param_1,param_1_00 + 0x186c,4);
    FUN_005cfdb6(param_1,param_1_00 + 0x1870,4);
    FUN_005cfdb6(param_1,param_1_00 + 0x1874,4);
    FUN_005cfdb6(param_1,param_1_00 + 0x1878,4);
    piVar1 = (int *)(param_1_00 + 0x1820);
    FUN_005cfdb6(param_1,piVar1,4);
    iVar3 = 0;
    if (0 < *piVar1) {
      do {
        FUN_004ea090(param_1,*piVar2);
        iVar4 = *piVar5;
        piVar5 = piVar5 + 1;
        *(int *)(iVar4 + 0xb9) = iVar3;
        iVar3 = iVar3 + 1;
      } while (iVar3 < *piVar1);
    }
  }
  return;
}

