/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00578450 */

int FUN_00578450(int param_1,int param_2,undefined4 param_3)

{
  int *piVar1;
  int iVar2;
  int iVar3;
  
  piVar1 = *(int **)(param_1 + 0x10);
  while (piVar1 != (int *)0x0) {
    iVar2 = piVar1[1];
    if (((iVar2 == param_2) && (*piVar1 == param_1)) || ((iVar2 == param_1 && (*piVar1 == param_2)))
       ) {
      *(undefined4 *)((int)piVar1 + 0x3e) = param_3;
      return 0;
    }
    if (param_1 == *piVar1) {
      piVar1 = *(int **)((int)piVar1 + 0x42);
    }
    else {
      if (param_1 != iVar2) break;
      piVar1 = *(int **)((int)piVar1 + 0x4a);
    }
  }
  piVar1 = *(int **)(param_2 + 0x10);
  while (piVar1 != (int *)0x0) {
    iVar2 = piVar1[1];
    if (((iVar2 == param_2) && (*piVar1 == param_1)) || ((iVar2 == param_1 && (*piVar1 == param_2)))
       ) {
      *(undefined4 *)((int)piVar1 + 0x3e) = param_3;
      return 0;
    }
    if (param_2 == iVar2) {
      piVar1 = *(int **)((int)piVar1 + 0x4a);
    }
    else {
      if (param_2 != *piVar1) break;
      piVar1 = *(int **)((int)piVar1 + 0x42);
    }
  }
  iVar2 = FUN_00577a80(*(undefined4 *)(param_1 + 4),*(undefined4 *)(param_2 + 8));
  if (iVar2 != 0) {
    iVar3 = FUN_00578530(0x52);
    if ((iVar3 != 0) && (iVar3 = FUN_00577e40(param_1,param_2,iVar2), iVar3 != 0)) {
      *(undefined4 *)(iVar3 + 0x3e) = param_3;
      return iVar3;
    }
    FUN_00577860();
    FUN_00577ad0(iVar2);
  }
  return 0;
}


