/* Ghidra pseudo-C; NR2003.exe @ 005b7fe0 */

void FUN_005b7fe0(int param_1,int param_2)

{
  int iVar1;
  
  iVar1 = 6;
  param_2 = param_2 - param_1;
  do {
    (**(code **)PTR_PTR_0074fe4c)(param_1,param_2 + param_1);
    param_1 = param_1 + 4;
    iVar1 = iVar1 + -1;
  } while (iVar1 != 0);
  return;
}

