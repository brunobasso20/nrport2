/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b7b40 */

void __thiscall FUN_005b7b40(int param_1_00,int param_1)

{
  int iVar1;
  
  iVar1 = *(int *)(param_1_00 + 4);
  param_1 = **(int **)(param_1_00 + 0x1c) + param_1;
  if (0 < iVar1) {
    for (; iVar1 <= param_1; param_1 = param_1 - iVar1) {
    }
  }
  **(int **)(param_1_00 + 0x1c) = param_1;
  return;
}


