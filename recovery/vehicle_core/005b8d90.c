/* Ghidra pseudo-C; NR2003.exe @ 005b8d90 */

void FUN_005b8d90(int param_1,int param_2)

{
  int iVar1;
  int iVar2;
  
  param_2 = param_2 - param_1;
  iVar1 = 6;
  do {
    iVar2 = 6;
    do {
      (**(code **)PTR_PTR_0074fe4c)(param_1,param_2 + param_1);
      param_1 = param_1 + 4;
      iVar2 = iVar2 + -1;
    } while (iVar2 != 0);
    iVar1 = iVar1 + -1;
  } while (iVar1 != 0);
  return;
}

