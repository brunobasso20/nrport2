/* NR2003.exe @ 005b8040 FUN_005b8040 */

void FUN_005b8040(int param_1,int param_2,int param_3)

{
  int iVar1;
  
  iVar1 = 6;
  param_3 = param_3 - param_2;
  param_1 = param_1 - param_2;
  do {
    (**(code **)PTR_PTR_FUN_0074fe48)(param_1 + param_2,param_2,param_3 + param_2);
    param_2 = param_2 + 4;
    iVar1 = iVar1 + -1;
  } while (iVar1 != 0);
  return;
}

