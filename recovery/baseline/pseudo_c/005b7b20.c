/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b7b20 */

int __fastcall FUN_005b7b20(int param_1)

{
  int iVar1;
  
  iVar1 = FUN_005b7c00();
  if (0 < iVar1) {
    return **(int **)(param_1 + 0x1c) * *(int *)(param_1 + 8) + *(int *)(param_1 + 0x14);
  }
  return 0;
}


