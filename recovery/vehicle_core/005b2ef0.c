/* Ghidra pseudo-C; NR2003.exe @ 005b2ef0 */

void FUN_005b2ef0(int param_1,code *param_2)

{
  int iVar1;
  
  for (iVar1 = *(int *)(param_1 + 0x75); iVar1 != 0; iVar1 = *(int *)(iVar1 + 0x71)) {
    (*param_2)(iVar1);
  }
  return;
}

