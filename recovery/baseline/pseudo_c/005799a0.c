/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005799a0 */

void __thiscall FUN_005799a0(int param_1_00,int *param_1)

{
  int iVar1;
  
  if (*param_1 != 0) {
    *(int *)(*param_1 + 0x54) = param_1_00 + 0x50;
  }
  iVar1 = *param_1;
  *(int **)(param_1_00 + 0x54) = param_1;
  *(int *)(param_1_00 + 0x50) = iVar1;
  *param_1 = param_1_00;
  return;
}


