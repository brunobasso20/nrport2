/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b7a60 */

void __thiscall FUN_005b7a60(int param_1_00,undefined4 param_1,int param_2)

{
  int iVar1;
  
  if (0 < param_2) {
    iVar1 = *(int *)(param_1_00 + 8);
    FUN_005b7c80(param_1,param_1,iVar1 * param_2,
                 **(int **)(param_1_00 + 0x1c) * iVar1 + *(int *)(param_1_00 + 0x14),
                 *(int *)(param_1_00 + 0x14),*(int *)(param_1_00 + 4) * iVar1,iVar1 * param_2);
    iVar1 = *(int *)(param_1_00 + 4);
    param_2 = **(int **)(param_1_00 + 0x1c) + param_2;
    if (0 < iVar1) {
      for (; iVar1 <= param_2; param_2 = param_2 - iVar1) {
      }
    }
    **(int **)(param_1_00 + 0x1c) = param_2;
  }
  return;
}


