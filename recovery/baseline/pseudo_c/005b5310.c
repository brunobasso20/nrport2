/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b5310 */

int __fastcall FUN_005b5310(int param_1)

{
  int iVar1;
  
  if (0 < *(int *)(param_1 + 5)) {
    iVar1 = *(int *)(param_1 + 1);
    *(int *)(param_1 + 1) = *(int *)(param_1 + 1) + 1;
    *(uint *)(param_1 + 1) = *(uint *)(param_1 + 1) & 0x3ff;
    *(int *)(param_1 + 5) = *(int *)(param_1 + 5) + -1;
    return iVar1 * 0x1f + 0xd + param_1;
  }
  return 0;
}


