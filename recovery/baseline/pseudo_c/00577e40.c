/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00577e40 */

void __thiscall FUN_00577e40(int *param_1_00,int param_1,int param_2,undefined4 param_3)

{
  int iVar1;
  int *piVar2;
  
  param_1_00[1] = param_2;
  *param_1_00 = param_1;
  *(undefined4 *)((int)param_1_00 + 0x3a) = param_3;
  *(int *)(param_1 + 0x3c) = *(int *)(param_1 + 0x3c) + 1;
  iVar1 = *param_1_00;
  *(undefined4 **)((int)param_1_00 + 0x46) = (undefined4 *)(iVar1 + 0x10);
  piVar2 = *(int **)(iVar1 + 0x10);
  if (piVar2 != (int *)0x0) {
    if (iVar1 == *piVar2) {
      *(int *)((int)piVar2 + 0x46) = (int)param_1_00 + 0x42;
    }
    else if (iVar1 == piVar2[1]) {
      *(int *)((int)piVar2 + 0x4e) = (int)param_1_00 + 0x42;
    }
  }
  *(undefined4 *)((int)param_1_00 + 0x42) = *(undefined4 *)(*param_1_00 + 0x10);
  *(int **)(*param_1_00 + 0x10) = param_1_00;
  *(int *)(param_1_00[1] + 0x3c) = *(int *)(param_1_00[1] + 0x3c) + 1;
  iVar1 = param_1_00[1];
  *(undefined4 **)((int)param_1_00 + 0x4e) = (undefined4 *)(iVar1 + 0x10);
  piVar2 = *(int **)(iVar1 + 0x10);
  if (piVar2 != (int *)0x0) {
    if (iVar1 == piVar2[1]) {
      *(int *)((int)piVar2 + 0x4e) = (int)param_1_00 + 0x4a;
      *(undefined4 *)((int)param_1_00 + 0x4a) = *(undefined4 *)(param_1_00[1] + 0x10);
      *(int **)(param_1_00[1] + 0x10) = param_1_00;
      return;
    }
    if (iVar1 == *piVar2) {
      *(int *)((int)piVar2 + 0x46) = (int)param_1_00 + 0x4a;
    }
  }
  *(undefined4 *)((int)param_1_00 + 0x4a) = *(undefined4 *)(param_1_00[1] + 0x10);
  *(int **)(param_1_00[1] + 0x10) = param_1_00;
  return;
}


