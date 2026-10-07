/* Ghidra pseudo-C; NR2003.exe @ 005b7d70 */

void FUN_005b7d70(int param_1,int param_2,int param_3)

{
  int iVar1;
  
  iVar1 = 3;
  param_3 = param_3 - param_2;
  param_1 = param_1 - param_2;
  do {
    (**(code **)PTR_PTR_0074fe48)(param_1 + param_2,param_2,param_3 + param_2);
    param_2 = param_2 + 4;
    iVar1 = iVar1 + -1;
  } while (iVar1 != 0);
  return;
}

